#!/usr/bin/env python3
import argparse
import subprocess
import sys
from pathlib import Path

import sounddevice as sd
from scipy.io.wavfile import write


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--seconds", type=int, default=5)
    parser.add_argument("--out", default="input.wav")
    args = parser.parse_args()

    # --- 5 秒録音 --------------------------------------------------------
    sr = 44_100
    print(f"Recording {args.seconds}s …", flush=True)
    audio = sd.rec(int(args.seconds * sr), samplerate=sr,
                   channels=1, dtype="float32")
    sd.wait()
    write(args.out, sr, audio)
    print(f"Saved {args.out}", flush=True)

    # --- BasicPitch CLI --------------------------------------------------
    midi = Path(args.out).with_suffix(".mid")
    print("Running BasicPitch CLI …", flush=True)

    cli = Path(sys.executable).with_name("basic-pitch")           # venv 内の実行ファイル
    subprocess.run([str(cli), "--save-midi", ".", args.out], check=True)

    print(f"Done → {midi}", flush=True)


if __name__ == "__main__":
    main()
