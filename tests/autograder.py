#! /usr/bin/env python3

# Startup script for the LC3 autograder.
# If you have Python installed, you can install all the dependencies for the autograder with:
#   python3 -m pip install "lc3-ensemble-test[std]" (macOS/Linux)
#   py -m pip install "lc3-ensemble-test[std]" (Windows)
#
# Once completed, you can call this script with:
#   python3 autograder.py (macOS/Linux)
#   py autograder.py (Windows)

from pathlib import Path
import os
import pytest
import sys
import webbrowser

if __name__ == "__main__":
    OUTPUT_PATH = "report.html"

    # Set root directory (where ASM files are located) to current directory 
    # if no directory is defined
    os.environ.setdefault("TEST_ROOT_DIR", ".")
    # Run Pytest
    retcode = pytest.main(["--html", OUTPUT_PATH, "--self-contained-html", *sys.argv[1:]])
    
    # Automatically open file in browser:
    path = Path(OUTPUT_PATH).resolve()
    if path.exists():
        webbrowser.open(path.as_uri())

    exit(retcode)
