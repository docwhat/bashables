#!/usr/bin/env python3

import os
import pty
import sys

sys.exit(
    os.waitstatus_to_exitcode(pty.spawn(sys.argv[1:], lambda fd: os.read(fd, 1024)))
)

# EOF
