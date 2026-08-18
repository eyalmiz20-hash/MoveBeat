#!/usr/bin/env python3
"""
Listens on the Mac for the PC's Kinect doctor report.

Run this here, on the Mac:

    python3 tools/mac/kinect-doctor-listen.py

The PC's tools/kinect-doctor.ps1 broadcasts every observation to UDP port
7401 on the wired LAN. This binds that port, prints what arrives, keeps a
local copy in tools/logs/kinect-doctor-received.log, and - the point of the
exercise - keeps score, so it can tell you which of the two very different
faults you actually have:

    the PROCESS is dying and being restarted   (a code or updater problem)
    the SENSOR is dropping off USB             (a hardware or power problem)

Those look identical from a distance and have nothing in common as fixes.

Port 7401 is deliberately not 7400: 7400 carries the joint stream into Max
and must not be disturbed. You can run this while the synth is playing.

    -p / --port   port to listen on (default 7401)
    -q / --quiet  only show transitions and verdicts, hide the heartbeats
"""

import argparse
import os
import signal
import socket
import sys
import time
from collections import deque
from datetime import datetime

DEFAULT_PORT = 7401
QUIET_HINT_SECONDS = 30

# Kinds the PC sends, and how loudly to render them.
BOLD = "\033[1m"
DIM = "\033[2m"
RED = "\033[31m"
YELLOW = "\033[33m"
GREEN = "\033[32m"
CYAN = "\033[36m"
RESET = "\033[0m"

COLOURS = {
    "SNAPSHOT": CYAN,
    "WATCH": CYAN,
    "START": YELLOW,
    "EXIT": RED,
    "CRASH": RED,
    "DEVICE": YELLOW,
    "SERVICE": YELLOW,
    "VERDICT": BOLD + RED,
    "ERROR": RED,
    "HB": DIM,
    "DONE": GREEN,
}


def supports_colour():
    return sys.stdout.isatty() and os.environ.get("TERM") not in (None, "dumb")


class Tally:
    """Keeps score so the tool can reach a conclusion, not just relay text."""

    def __init__(self):
        self.starts = deque(maxlen=64)      # datetimes of MoveBeat.exe starts
        self.exits = 0
        self.device_changes = 0
        self.crashes = 0
        self.clean_exits = 0
        self.first_seen = None
        self.last_seen = None
        self.host = None

    def note(self, kind, text, when=None):
        # `when` is the PC's own clock at the moment it observed the event.
        # Restart intervals must be measured from that, not from when the
        # packet happened to arrive here - network delay and this process's
        # own scheduling would otherwise show up as restart timing, which is
        # the one number the whole tool exists to report accurately.
        now = when or datetime.now()
        if self.first_seen is None:
            self.first_seen = now
        self.last_seen = now

        if kind == "START":
            self.starts.append(now)
        elif kind == "EXIT":
            if "is GONE" in text:
                self.exits += 1
            if "EXITED CLEANLY" in text:
                self.clean_exits += 1
        elif kind == "CRASH":
            self.crashes += 1
        elif kind == "DEVICE":
            self.device_changes += 1

    def restart_interval(self):
        """Mean seconds between observed restarts, or None."""
        if len(self.starts) < 2:
            return None
        deltas = [
            (b - a).total_seconds()
            for a, b in zip(list(self.starts)[:-1], list(self.starts)[1:])
        ]
        return sum(deltas) / len(deltas)

    def verdict(self):
        """The whole reason this tool exists. Returns (headline, detail)."""
        lines = []
        interval = self.restart_interval()

        if len(self.starts) >= 3:
            head = "THE PROCESS IS RESTARTING"
            if interval is not None:
                lines.append(
                    "MoveBeat.exe has started %d times, on average %.1fs apart."
                    % (len(self.starts), interval)
                )
            if self.crashes > 0:
                lines.append(
                    "Windows recorded %d crash(es). It is FAULTING - see the CRASH "
                    "lines for the faulting module and exception." % self.crashes
                )
            elif self.clean_exits > 0:
                lines.append(
                    "No Windows crash record: it is EXITING CLEANLY, so something is "
                    "closing it on purpose. Check sync.log on the PC for the "
                    "auto-updater killing it, and movebeat.log for its own last lines."
                )
            else:
                lines.append(
                    "Cause not established yet - wait for the next EXIT line."
                )
            return head, lines

        if self.device_changes >= 3:
            return "THE SENSOR IS DROPPING OFF USB", [
                "The Kinect device changed state %d times while the process stayed up."
                % self.device_changes,
                "This is hardware, not code: USB bandwidth, the sensor's power brick, "
                "or USB selective suspend.",
                "Nothing in the repo will fix it. Try another USB 3.0 controller and "
                "confirm the power adapter is connected.",
            ]

        if self.exits == 0 and self.device_changes == 0 and self.starts:
            return "STABLE SO FAR", [
                "One start, no exits, no device changes since this listener began."
            ]

        return None, []


def main():
    ap = argparse.ArgumentParser(
        description="Receive the MoveBeat Kinect doctor report from the PC."
    )
    ap.add_argument("-p", "--port", type=int, default=DEFAULT_PORT)
    ap.add_argument(
        "-q", "--quiet", action="store_true", help="hide routine heartbeats"
    )
    args = ap.parse_args()

    # Python block-buffers stdout when it is not a terminal, so piping this
    # into tee or a log made it look frozen and lost everything on exit.
    try:
        sys.stdout.reconfigure(line_buffering=True)
    except AttributeError:
        pass

    # Ctrl+C already prints the summary; make a plain kill do the same instead
    # of discarding the tally.
    def _on_term(_signum, _frame):
        raise KeyboardInterrupt

    signal.signal(signal.SIGTERM, _on_term)

    use_colour = supports_colour()

    def paint(s, colour):
        if not use_colour or not colour:
            return s
        return colour + s + RESET

    repo_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    log_dir = os.path.join(repo_root, "tools", "logs")
    try:
        os.makedirs(log_dir, exist_ok=True)
        log_path = os.path.join(log_dir, "kinect-doctor-received.log")
        log_file = open(log_path, "a", buffering=1)
    except OSError:
        log_path = None
        log_file = None

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        sock.bind(("0.0.0.0", args.port))
    except OSError as exc:
        print(paint("Cannot bind UDP port %d: %s" % (args.port, exc), RED))
        print("Another copy of this listener is probably already running.")
        return 1
    sock.settimeout(1.0)

    print(paint("MoveBeat Kinect doctor - listening on UDP %d" % args.port, BOLD))
    print("Writing to: %s" % (log_path or "(log file unavailable)"))
    print("The PC broadcasts here automatically once MoveBeat.exe restarts.")
    print("Ctrl+C to stop and print a summary.\n")

    tally = Tally()
    started = time.time()
    hinted = False

    try:
        while True:
            try:
                data, addr = sock.recvfrom(65535)
            except socket.timeout:
                if (
                    not hinted
                    and tally.first_seen is None
                    and time.time() - started > QUIET_HINT_SECONDS
                ):
                    hinted = True
                    print(
                        paint(
                            "\nNothing received in %ds. Check, in this order:"
                            % QUIET_HINT_SECONDS,
                            YELLOW,
                        )
                    )
                    print("  1. Is this Mac on the wired 192.168.0.x LAN? Wi-Fi will not")
                    print("     receive the PC's subnet broadcast.")
                    print("  2. Has a push landed on the PC since the doctor was added?")
                    print("     The doctor starts when MoveBeat.exe next starts.")
                    print("  3. Is macOS's firewall blocking python3? System Settings ->")
                    print("     Network -> Firewall.\n")
                continue

            try:
                text = data.decode("utf-8", errors="replace")
            except Exception:
                continue

            if not text.startswith("MBDOC|"):
                continue

            parts = text.split("|", 4)
            if len(parts) < 5:
                continue
            _, host, stamp, kind, body = parts
            kind = kind.strip()
            tally.host = host

            try:
                when = datetime.strptime(stamp.strip(), "%Y-%m-%d %H:%M:%S")
            except ValueError:
                when = None
            tally.note(kind, body, when)

            if log_file:
                log_file.write(
                    "%s  %s  %-9s %s\n"
                    % (datetime.now().strftime("%H:%M:%S"), host, kind, body)
                )

            if args.quiet and kind == "HB":
                continue

            line = "%s  %-9s %s" % (stamp, kind, body)
            print(paint(line, COLOURS.get(kind)))

            # A verdict is worth interrupting the stream for, but only when it
            # changes - repeating it every packet would bury the evidence.
            head, detail = tally.verdict()
            if head and head != getattr(main, "_last_verdict", None):
                main._last_verdict = head
                print()
                print(paint("  >> %s <<" % head, BOLD + RED))
                for d in detail:
                    print(paint("     %s" % d, BOLD))
                print()

    except KeyboardInterrupt:
        pass
    finally:
        sock.close()

    print("\n" + paint("Summary", BOLD))
    if tally.first_seen is None:
        print("  No data was received from the PC at all.")
        print("  See the three checks above - the LAN is the usual answer.")
        return 0

    print("  Reporting host      : %s" % tally.host)
    print("  MoveBeat.exe starts : %d" % len(tally.starts))
    print("  MoveBeat.exe exits  : %d" % tally.exits)
    print("  Windows crashes     : %d" % tally.crashes)
    print("  Sensor device changes: %d" % tally.device_changes)
    interval = tally.restart_interval()
    if interval is not None:
        print("  Mean restart interval: %.1fs (by the PC's clock)" % interval)

    head, detail = tally.verdict()
    if head:
        print("\n  " + paint(head, BOLD + RED))
        for d in detail:
            print("    %s" % d)
    if log_path:
        print("\n  Full transcript: %s" % log_path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
