#!/bin/bash

# iostat's first sample covers uptime, so only the second reflects current load
/usr/sbin/iostat -c 2 | awk 'END { printf "%.0f", $(NF-5) + $(NF-4) }'
