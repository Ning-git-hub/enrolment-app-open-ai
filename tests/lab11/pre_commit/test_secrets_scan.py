import json
import subprocess
import sys


def test_detect_secrets_scan_passes():
    result = subprocess.run(
        [
            sys.executable,
            "-m",
            "detect_secrets",
            "scan",
            "--exclude-files",
            "legacy-lab3/.*|reports/report\\.json|reports/report\\.md",
        ],
        capture_output=True,
        text=True,
    )

    returncode = result.returncode

    assert returncode == 0, result.stderr

    findings = json.loads(result.stdout)

    assert findings.get("results", {}) == {}, "Potential secrets detected"