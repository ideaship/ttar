# Testing

## Overview

The repo contains a script, `run_test.sh`, for basic testing. It creates an archive from sample data, compares the result to a reference archive, then unpacks the archive and compares the result to the original sample data.

## Supported platforms

The test script should run without issues on popular Linux distributions. It prints some errors on macOS which needs some additional code for comparing symbolic links.
