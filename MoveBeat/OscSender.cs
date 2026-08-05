using System;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Runtime.InteropServices;

/// <summary>
/// Hand-written, zero-allocation-per-frame OSC 1.0 encoder and UDP broadcaster.
///
/// Deliberately not using an OSC library: the wire format is ~70 lines of
/// well-understood binary encoding, this PC is the weak machine in the
/// project, and a library that allocates a message object per joint per
/// frame would put the GC to work in a 30x/second hot path for no benefit.
///
/// Usage per frame:
///   sender.BeginBundle();
///   sender.AddMessage("/mb/head", x, y, z, trackingState);
///   ... (one AddMessage call per joint) ...
///   sender.AddTrackedMessage(true);
///   sender.Send();
/// </summary>
class OscSender : IDisposable
{
    const int BufferSize = 2048;

    readonly Socket _socket;
    readonly IPEndPoint _target;
    readonly byte[] _buf = new byte[BufferSize];
    int _pos;

    public IPAddress TargetAddress => _target.Address;
    public int TargetPort => _target.Port;

    /// <param name="port">UDP port to send to (Max side: udpreceive on the same port).</param>
    /// <param name="ipOverride">
    /// Optional explicit destination IP. When null/empty, the subnet-directed
    /// broadcast address is computed automatically so no configuration is
    /// needed on either machine.
    /// </param>
    public OscSender(int port, string ipOverride)
    {
        _socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
        _socket.EnableBroadcast = true;

        IPAddress targetIp = !string.IsNullOrEmpty(ipOverride)
            ? IPAddress.Parse(ipOverride)
            : ResolveBroadcastAddress();

        _target = new IPEndPoint(targetIp, port);
    }

    /// <summary>
    /// Resolves the subnet-directed broadcast address (e.g. 192.168.0.255) of
    /// the WIRED Ethernet interface.
    ///
    /// Wi-Fi is deliberately excluded. This machine is on two routable subnets
    /// at once (Ethernet 192.168.0.x and Wi-Fi 192.168.8.x); broadcasting to
    /// whichever one happened to enumerate first was non-deterministic and
    /// could silently change across reboots. The Kinect-to-Max link runs over
    /// the LAN cable by design: it is the lower-latency, non-contended path,
    /// which matters for a 30 Hz control stream feeding a synthesizer.
    ///
    /// Falls back to the limited broadcast address only if no usable wired
    /// interface exists at all. Pass --ip to override entirely.
    /// </summary>
    static IPAddress ResolveBroadcastAddress()
    {
        try
        {
            foreach (var nic in NetworkInterface.GetAllNetworkInterfaces())
            {
                if (nic.OperationalStatus != OperationalStatus.Up)
                    continue;
                if (nic.NetworkInterfaceType == NetworkInterfaceType.Loopback)
                    continue;

                // Wired only. GigabitEthernet/Ethernet3Megabit are the other
                // spellings Windows can report; USB Ethernet adapters (this
                // machine uses a Realtek USB GbE) report as Ethernet.
                if (nic.NetworkInterfaceType != NetworkInterfaceType.Ethernet &&
                    nic.NetworkInterfaceType != NetworkInterfaceType.GigabitEthernet &&
                    nic.NetworkInterfaceType != NetworkInterfaceType.Ethernet3Megabit)
                    continue;

                IPAddress found = TryGetBroadcast(nic);
                if (found != null)
                    return found;
            }
        }
        catch
        {
            // Fall through to the default below - never let target resolution
            // crash startup.
        }

        return IPAddress.Broadcast;
    }

    /// <summary>
    /// Returns the subnet-directed broadcast address for the first usable IPv4
    /// address on this interface, or null if it has none.
    /// </summary>
    static IPAddress TryGetBroadcast(NetworkInterface nic)
    {
        var props = nic.GetIPProperties();
        foreach (var ua in props.UnicastAddresses)
        {
            if (ua.Address.AddressFamily != AddressFamily.InterNetwork)
                continue;
            if (ua.IPv4Mask == null)
                continue;

            byte[] ipBytes = ua.Address.GetAddressBytes();

            // Skip APIPA / link-local (169.254.0.0/16). This machine reports
            // several of them (Bluetooth PAN, virtual adapters), and an
            // unplugged Ethernet port self-assigns one too. Broadcasting to a
            // link-local subnet reaches nothing, and the failure is silent:
            // the app looks healthy while Max receives nothing at all.
            if (ipBytes[0] == 169 && ipBytes[1] == 254)
                continue;

            byte[] maskBytes = ua.IPv4Mask.GetAddressBytes();

            // All-zero mask means "no mask configured" - not usable.
            bool maskIsZero = true;
            foreach (var b in maskBytes)
                if (b != 0) { maskIsZero = false; break; }
            if (maskIsZero)
                continue;

            byte[] broadcastBytes = new byte[4];
            for (int i = 0; i < 4; i++)
                broadcastBytes[i] = (byte)(ipBytes[i] | ~maskBytes[i]);

            return new IPAddress(broadcastBytes);
        }

        return null;
    }

    // ---------------- low-level buffer writers ----------------

    /// <summary>OSC string: ASCII bytes + at least one null, padded to a 4-byte boundary.</summary>
    void WriteString(string s)
    {
        int start = _pos;
        for (int i = 0; i < s.Length; i++)
            _buf[_pos++] = (byte)s[i];

        int written = _pos - start;
        int padded = ((written / 4) + 1) * 4; // room for >=1 null, then round up to 4
        int nullCount = padded - written;
        for (int i = 0; i < nullCount; i++)
            _buf[_pos++] = 0;
    }

    void WriteInt32BE(int v)
    {
        _buf[_pos++] = (byte)(v >> 24);
        _buf[_pos++] = (byte)(v >> 16);
        _buf[_pos++] = (byte)(v >> 8);
        _buf[_pos++] = (byte)v;
    }

    static void WriteInt32BEAt(byte[] buf, int pos, int v)
    {
        buf[pos] = (byte)(v >> 24);
        buf[pos + 1] = (byte)(v >> 16);
        buf[pos + 2] = (byte)(v >> 8);
        buf[pos + 3] = (byte)v;
    }

    /// <summary>
    /// Bit-reinterprets a float as its big-endian byte representation with no
    /// heap allocation (an explicit-layout struct instead of BitConverter,
    /// since net48 has no allocation-free float-to-int-bits API).
    /// </summary>
    [StructLayout(LayoutKind.Explicit)]
    struct FloatIntUnion
    {
        [FieldOffset(0)] public float FloatValue;
        [FieldOffset(0)] public int IntValue;
    }

    void WriteFloatBE(float f)
    {
        FloatIntUnion u = default(FloatIntUnion);
        u.FloatValue = f;
        WriteInt32BE(u.IntValue);
    }

    // ---------------- bundle / message building ----------------

    /// <summary>Starts a new OSC bundle in the reused buffer (resets the write cursor).</summary>
    public void BeginBundle()
    {
        _pos = 0;
        WriteString("#bundle");
        // OSC "immediate" time tag: 8 bytes, value 1 (all zero except the final bit).
        WriteInt32BE(0);
        WriteInt32BE(1);
    }

    /// <summary>Appends one OSC message with type tag ",ffff" (x, y, z, trackingState) as a bundle element.</summary>
    public void AddMessage(string address, float x, float y, float z, float w)
    {
        int sizePos = _pos;
        _pos += 4; // placeholder for the bundle-element size, patched below

        int msgStart = _pos;
        WriteString(address);
        WriteString(",ffff");
        WriteFloatBE(x);
        WriteFloatBE(y);
        WriteFloatBE(z);
        WriteFloatBE(w);

        int msgLen = _pos - msgStart;
        WriteInt32BEAt(_buf, sizePos, msgLen);
    }

    /// <summary>Appends the "/mb/tracked 0|1" message as a bundle element.</summary>
    public void AddTrackedMessage(bool tracked)
    {
        int sizePos = _pos;
        _pos += 4;

        int msgStart = _pos;
        WriteString("/mb/tracked");
        WriteString(",i");
        WriteInt32BE(tracked ? 1 : 0);

        int msgLen = _pos - msgStart;
        WriteInt32BEAt(_buf, sizePos, msgLen);
    }

    /// <summary>Sends the buffer built since BeginBundle() as a single UDP packet.</summary>
    public void Send()
    {
        _socket.SendTo(_buf, 0, _pos, SocketFlags.None, _target);
    }

    public void Dispose()
    {
        _socket.Dispose();
    }
}
