#!/bin/bash

echo "SSH to 'user-2@172.29.0.11' using the password 'billybob'" > flag.txt

nohup ncat -l -k -p 22 -c 'echo "Hello from $(hostname) on port 22"' >/dev/null 2>&1 &

nohup ncat -l -k -p 69 -c 'echo "Hello from $(hostname) on port 69"' >/dev/null 2>&1 &

nohup ncat -l -k -p 80 -c 'echo "Hello from $(hostname) on port 80"' >/dev/null 2>&1 &

nohup ncat -l -k -p 135 -c 'echo "Hello from $(hostname) on port 135"' >/dev/null 2>&1 &

nohup ncat -l -k -p 445 -c 'echo "Hello from $(hostname) on port 445"' >/dev/null 2>&1 &

nohup ncat -l -k -p 3306 -c 'echo "Hello from $(hostname) on port 3306"' >/dev/null 2>&1 &

nohup ncat -l -k -p 139 -c 'echo "Hello from $(hostname) on port 139"' >/dev/null 2>&1 &
