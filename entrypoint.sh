#!/bin/sh

# Run syslogd because postfix uses it for all logging.
# Set its output to be the stdout of process 1.
syslogd -O /proc/1/fd/1

# Start postfix, but run it in the foreground.
exec postfix start-fg
