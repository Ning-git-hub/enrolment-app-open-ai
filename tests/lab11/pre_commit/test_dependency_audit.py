import subprocess
import sys


def test_pip_audit_passes():
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "pip_audit",
        ],
        capture_output=True,
        text=True,
    )

    returncode = result.returncode

    assert returncode == 0, result.stdout + result.stderr