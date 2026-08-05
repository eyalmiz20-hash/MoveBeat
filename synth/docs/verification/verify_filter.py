#!/usr/bin/env python3
"""
MoveBeat Synth -- Moog Ladder Filter verification
==================================================

Implements the exact per-sample algorithm specified in
MoveBeat/synth/dsp/moog_ladder.genexpr (and mirrored inside
movebeat_core.genexpr) in plain Python/NumPy, and checks:

  1. Stability   -- white noise through the filter at several cutoffs
                    and resonance amounts stays finite and bounded.
  2. Frequency response -- the filter is low-pass, rolls off at
                    ~24 dB/octave above Fc, and has its -3 dB point
                    near the programmed cutoff.
  3. Resonance   -- the gain peak at Fc grows with k.
  4. Self-oscillation -- at k = 4.0 with (near) zero input the filter
                    sustains a steady tone near Fc.

Run with:  python3 verify_filter.py
Outputs:   magnitude_response.png, slope_check.png, self_oscillation.png
           (written next to this script), plus PASS/FAIL lines on stdout.
"""

import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

FS = 48000.0
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

PASS = []  # collect (name, bool, detail) for final summary


# ----------------------------------------------------------------------
# 1. The filter, sample-accurate port of moog_ladder.genexpr
# ----------------------------------------------------------------------
def moog_ladder(x, fc, k, drive=0.0, comp=0.0, fs=FS):
    """
    x    : 1D numpy array, input samples
    fc   : scalar or 1D array (per-sample) cutoff in Hz, clamped 20..18000
    k    : scalar or 1D array (per-sample) resonance, clamped 0..4
    drive: scalar 0..1 input drive
    comp : scalar 0..1 resonance make-up gain

    Returns y (out1 = 4-pole output) as a numpy array, following the
    per-sample recurrence in moog_ladder.genexpr exactly:

        wc = tan(pi * Fc / Fs)
        G  = wc / (1 + wc)
        U  = tanh(x*mk - k*y4z)
        v1=(U -s1)*G; y1=v1+s1; s1=y1+v1
        v2=(y1-s2)*G; y2=v2+s2; s2=y2+v2
        v3=(y2-s3)*G; y3=v3+s3; s3=y3+v3
        v4=(y3-s4)*G; y4=v4+s4; s4=y4+v4
        y4z = y4
        output = y4
    """
    n = len(x)
    fc_arr = np.full(n, fc, dtype=np.float64) if np.isscalar(fc) else np.asarray(fc, dtype=np.float64)
    k_arr = np.full(n, k, dtype=np.float64) if np.isscalar(k) else np.asarray(k, dtype=np.float64)

    fc_arr = np.clip(fc_arr, 20.0, 18000.0)
    k_arr = np.clip(k_arr, 0.0, 4.0)
    drive = float(np.clip(drive, 0.0, 1.0))
    comp = float(np.clip(comp, 0.0, 1.0))

    s1 = s2 = s3 = s4 = 0.0
    y4z = 0.0
    y = np.zeros(n, dtype=np.float64)

    for i in range(n):
        Fc = fc_arr[i]
        kk = k_arr[i]
        wc = np.tan(np.pi * Fc / fs)
        G = wc / (1.0 + wc)

        xin = x[i] * (1.0 + 3.0 * drive)
        mk = 1.0 + comp * kk * 0.5
        U = np.tanh(xin * mk - kk * y4z)

        v1 = (U - s1) * G;  y1 = v1 + s1;  s1 = y1 + v1
        v2 = (y1 - s2) * G; y2 = v2 + s2;  s2 = y2 + v2
        v3 = (y2 - s3) * G; y3 = v3 + s3;  s3 = y3 + v3
        v4 = (y3 - s4) * G; y4 = v4 + s4;  s4 = y4 + v4

        y4z = y4
        y[i] = y4

    return y


# ----------------------------------------------------------------------
# 2. Stability check
# ----------------------------------------------------------------------
def check_stability():
    print("\n=== 1. STABILITY ===")
    rng = np.random.default_rng(42)
    n = int(2.0 * FS)  # 2 seconds of noise
    ok = True
    worst_peak = 0.0
    for fc in (100.0, 1000.0, 5000.0):
        for k in (0.0, 1.0, 2.0, 3.0, 3.9):
            noise = rng.uniform(-1.0, 1.0, n)
            y = moog_ladder(noise, fc, k, drive=0.3, comp=0.5)
            finite = np.all(np.isfinite(y))
            peak = float(np.max(np.abs(y))) if finite else float("inf")
            worst_peak = max(worst_peak, peak)
            good = finite and peak < 10.0
            ok = ok and good
            print(f"  fc={fc:6.0f} Hz  k={k:.1f}  finite={finite}  peak={peak:.4f}  -> {'OK' if good else 'FAIL'}")
    print(f"  worst-case peak across all runs: {worst_peak:.4f}")
    PASS.append(("Stability (finite, bounded < 10 for fc in {100,1000,5000}Hz, k in 0..3.9)", ok, f"worst peak={worst_peak:.4f}"))
    print(f"  -> {'PASS' if ok else 'FAIL'}")
    return ok


# ----------------------------------------------------------------------
# 3. Frequency response (magnitude, slope, -3dB point)
# ----------------------------------------------------------------------
def measure_magnitude_response(fc_target, k, n=1 << 16, drive=0.0, comp=0.0):
    """Feed white noise, estimate the magnitude response via Welch-style
    averaged periodogram (transfer function estimate H = Pxy/Pxx works for
    linear systems; the ladder is only mildly nonlinear at these levels,
    good enough for a shape/slope/-3dB estimate)."""
    rng = np.random.default_rng(7)
    x = rng.uniform(-1.0, 1.0, n)
    y = moog_ladder(x, fc_target, k, drive=drive, comp=comp)

    # Use a Hann window and a single large FFT (impulse-response-free
    # transfer estimate via cross/auto spectra) for a smooth, low-noise
    # magnitude curve.
    from scipy.signal import csd, welch
    nperseg = 4096
    f, Pxx = welch(x, fs=FS, nperseg=nperseg)
    _, Pxy = csd(x, y, fs=FS, nperseg=nperseg)
    H = Pxy / Pxx
    mag = np.abs(H)
    return f, mag


def check_frequency_response():
    print("\n=== 2. FREQUENCY RESPONSE (fc=1000 Hz, k=0) ===")
    fc_target = 1000.0
    f, mag = measure_magnitude_response(fc_target, k=0.0)

    mag_db = 20.0 * np.log10(np.maximum(mag, 1e-12))
    # normalize to the low-frequency (passband) gain
    passband_mask = (f > 20) & (f < 200)
    ref_db = np.median(mag_db[passband_mask])
    mag_db_norm = mag_db - ref_db

    # (a) low-pass shape: gain well above Fc should be much lower than passband
    hf_mask = (f > 4000) & (f < 8000)
    hf_db = np.median(mag_db_norm[hf_mask])
    is_lowpass = hf_db < -20.0
    print(f"  passband ref level: {ref_db:.2f} dB (raw)")
    print(f"  gain at 4-8 kHz relative to passband: {hf_db:.2f} dB  -> low-pass shape: {'OK' if is_lowpass else 'FAIL'}")

    # (b) slope above Fc: fit line to log2(f) vs dB in [Fc*1.2, Fc*4] (~1-2 octaves up)
    slope_mask = (f > fc_target * 1.2) & (f < fc_target * 4.0) & (f > 0)
    f_fit = f[slope_mask]
    db_fit = mag_db_norm[slope_mask]
    log2f = np.log2(f_fit)
    # linear fit: dB = m * log2f + b   => m is dB/octave
    m, b = np.polyfit(log2f, db_fit, 1)
    slope_ok = -28.0 <= m <= -20.0
    print(f"  fitted slope above Fc: {m:.2f} dB/octave  -> {'OK' if slope_ok else 'FAIL'} (expect approx -20..-28)")

    # (c) -3 dB point: find where mag_db_norm crosses -3 dB (search near fc)
    search_mask = (f > 50) & (f < 10000)
    f_s = f[search_mask]
    db_s = mag_db_norm[search_mask]
    # find first crossing from above -3 to below -3 dB as freq increases
    below = np.where(db_s < -3.0)[0]
    if len(below) > 0:
        idx = below[0]
        # linear interpolate between idx-1 and idx for the crossing frequency
        if idx > 0:
            f0, f1_ = f_s[idx - 1], f_s[idx]
            d0, d1_ = db_s[idx - 1], db_s[idx]
            frac = (-3.0 - d0) / (d1_ - d0) if d1_ != d0 else 0.0
            f3db = f0 + frac * (f1_ - f0)
        else:
            f3db = f_s[idx]
    else:
        f3db = float("nan")
    # allow a reasonably wide tolerance: ladder -3dB point can sit somewhat
    # below the coefficient's nominal Fc because of the cascaded stages
    f3db_ok = (0.4 * fc_target) <= f3db <= (1.3 * fc_target)
    print(f"  measured -3 dB point: {f3db:.1f} Hz (target Fc = {fc_target:.0f} Hz) -> {'OK' if f3db_ok else 'FAIL'}")

    ok = is_lowpass and slope_ok and f3db_ok
    PASS.append(("Low-pass shape (>=20dB down by 4-8kHz)", is_lowpass, f"{hf_db:.2f} dB"))
    PASS.append(("Slope above Fc ~ -20..-28 dB/oct", slope_ok, f"{m:.2f} dB/oct"))
    PASS.append(("-3dB point near Fc=1000Hz", f3db_ok, f"{f3db:.1f} Hz"))

    # -------- plot: magnitude_response.png (k = 0,1,2,3) --------
    plt.figure(figsize=(8, 5))
    for k in (0.0, 1.0, 2.0, 3.0):
        f_k, mag_k = measure_magnitude_response(fc_target, k=k)
        mag_k_db = 20.0 * np.log10(np.maximum(mag_k, 1e-12))
        ref_k = np.median(mag_k_db[(f_k > 20) & (f_k < 200)])
        plt.semilogx(f_k, mag_k_db - ref_k, label=f"k={k:.0f}")
    plt.axvline(fc_target, color="gray", linestyle="--", linewidth=1, label="Fc = 1000 Hz")
    plt.axhline(-3, color="red", linestyle=":", linewidth=1, label="-3 dB")
    plt.xlim(20, 20000)
    plt.ylim(-60, 30)
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Magnitude (dB, normalized to passband)")
    plt.title("Moog ladder magnitude response vs resonance k (Fc = 1000 Hz)")
    plt.legend()
    plt.grid(True, which="both", alpha=0.3)
    plt.tight_layout()
    plt.savefig(os.path.join(OUT_DIR, "magnitude_response.png"), dpi=130)
    plt.close()

    # -------- plot: slope_check.png (k=0 curve + fitted slope line) -----
    plt.figure(figsize=(8, 5))
    plt.semilogx(f, mag_db_norm, label="measured (k=0)")
    fit_line = m * np.log2(f_fit) + b
    plt.semilogx(f_fit, fit_line, "r--", linewidth=2, label=f"fit: {m:.1f} dB/oct")
    plt.axvline(fc_target, color="gray", linestyle="--", linewidth=1, label="Fc = 1000 Hz")
    plt.axhline(-3, color="green", linestyle=":", linewidth=1, label="-3 dB")
    plt.xlim(200, 8000)
    plt.ylim(-60, 10)
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Magnitude (dB, normalized)")
    plt.title(f"Roll-off slope fit above Fc (measured {m:.2f} dB/oct)")
    plt.legend()
    plt.grid(True, which="both", alpha=0.3)
    plt.tight_layout()
    plt.savefig(os.path.join(OUT_DIR, "slope_check.png"), dpi=130)
    plt.close()

    print(f"  -> {'PASS' if ok else 'FAIL'}")
    return ok, m, f3db


# ----------------------------------------------------------------------
# 4. Resonance peak grows with k
# ----------------------------------------------------------------------
def check_resonance_peak():
    print("\n=== 3. RESONANCE PEAK vs k ===")
    fc_target = 1000.0
    f, mag0 = measure_magnitude_response(fc_target, k=0.0)
    _, mag3 = measure_magnitude_response(fc_target, k=3.0)

    near_fc = (f > fc_target * 0.7) & (f < fc_target * 1.3)
    peak0_db = 20 * np.log10(np.max(mag0[near_fc]))
    peak3_db = 20 * np.log10(np.max(mag3[near_fc]))

    grows = peak3_db > peak0_db + 3.0  # require a meaningful, clear increase
    print(f"  peak near Fc, k=0: {peak0_db:.2f} dB")
    print(f"  peak near Fc, k=3: {peak3_db:.2f} dB")
    print(f"  increase: {peak3_db - peak0_db:.2f} dB -> {'OK' if grows else 'FAIL'}")
    PASS.append(("Resonance peak grows k=0 -> k=3", grows, f"+{peak3_db - peak0_db:.2f} dB"))
    print(f"  -> {'PASS' if grows else 'FAIL'}")
    return grows


# ----------------------------------------------------------------------
# 5. Self-oscillation at k=4
# ----------------------------------------------------------------------
def check_self_oscillation():
    print("\n=== 4. SELF-OSCILLATION (k=4.0) ===")
    fc_target = 1000.0
    n = int(2.0 * FS)
    x = np.zeros(n)
    x[0] = 1e-3  # tiny kick to seed the oscillation (0 input also self-starts via tanh(0)=0 -> stays 0; a nudge is physically realistic and matches how a real ladder is excited)
    y = moog_ladder(x, fc_target, k=4.0, drive=0.0, comp=0.0)

    finite = np.all(np.isfinite(y))
    # look at the tail (steady state), skip the first 0.5s transient
    tail = y[int(0.5 * FS):]
    peak = float(np.max(np.abs(tail)))
    sustained = finite and peak > 0.05  # still oscillating, not decayed to ~0

    # dominant frequency via FFT of the tail
    win = np.hanning(len(tail))
    spec = np.abs(np.fft.rfft(tail * win))
    freqs = np.fft.rfftfreq(len(tail), d=1.0 / FS)
    # ignore near-DC
    mask = freqs > 20
    dom_freq = freqs[mask][np.argmax(spec[mask])]

    freq_ok = abs(dom_freq - fc_target) < 0.15 * fc_target  # within 15%
    ok = finite and sustained and freq_ok
    print(f"  finite: {finite}, tail peak amplitude: {peak:.4f}, sustained: {sustained}")
    print(f"  dominant frequency: {dom_freq:.1f} Hz (target Fc = {fc_target:.0f} Hz) -> {'OK' if freq_ok else 'FAIL'}")
    PASS.append(("Self-oscillation sustains near Fc at k=4", ok, f"{dom_freq:.1f} Hz vs Fc={fc_target:.0f} Hz, peak={peak:.4f}"))
    print(f"  -> {'PASS' if ok else 'FAIL'}")

    # -------- plot: self_oscillation.png --------
    t = np.arange(n) / FS
    fig, axes = plt.subplots(2, 1, figsize=(8, 6))
    axes[0].plot(t, y, linewidth=0.6)
    axes[0].set_xlabel("Time (s)")
    axes[0].set_ylabel("Amplitude")
    axes[0].set_title("Self-oscillation waveform (k = 4.0, input ~ 0)")
    axes[0].grid(True, alpha=0.3)

    axes[1].plot(freqs[mask], 20 * np.log10(spec[mask] / np.max(spec[mask]) + 1e-12))
    axes[1].axvline(fc_target, color="gray", linestyle="--", label="Fc = 1000 Hz")
    axes[1].axvline(dom_freq, color="red", linestyle=":", label=f"measured peak = {dom_freq:.1f} Hz")
    axes[1].set_xlim(0, 5000)
    axes[1].set_ylim(-80, 5)
    axes[1].set_xlabel("Frequency (Hz)")
    axes[1].set_ylabel("Magnitude (dB, normalized)")
    axes[1].set_title("Spectrum of steady-state self-oscillation")
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(os.path.join(OUT_DIR, "self_oscillation.png"), dpi=130)
    plt.close()

    return ok, dom_freq


# ----------------------------------------------------------------------
# main
# ----------------------------------------------------------------------
if __name__ == "__main__":
    print("MoveBeat Moog Ladder Filter -- verification (Fs = %d Hz)" % int(FS))

    ok_stability = check_stability()
    ok_freq, slope_db_oct, f3db = check_frequency_response()
    ok_resonance = check_resonance_peak()
    ok_selfosc, selfosc_freq = check_self_oscillation()

    print("\n================ SUMMARY ================")
    all_ok = True
    for name, ok, detail in PASS:
        status = "PASS" if ok else "FAIL"
        all_ok = all_ok and ok
        print(f"[{status}] {name}  ({detail})")
    print("===========================================")
    print(f"OVERALL: {'ALL CHECKS PASS' if all_ok else 'SOME CHECKS FAILED'}")

    # expose key numbers for the report writer / grep
    print("\nKEY NUMBERS:")
    print(f"  measured -3dB point (Fc=1000Hz target): {f3db:.1f} Hz")
    print(f"  measured slope above Fc: {slope_db_oct:.2f} dB/octave")
    print(f"  self-oscillation frequency at k=4 (Fc=1000Hz target): {selfosc_freq:.1f} Hz")
