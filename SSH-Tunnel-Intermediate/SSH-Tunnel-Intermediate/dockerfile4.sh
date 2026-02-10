#!/bin/bash

echo "SSH to 'user-4@172.31.0.40' using the password 'velvet'" > flag.txt

nohup ncat -l -k -p 9 -c 'echo "Hello from $(hostname) on port 9"' >/dev/null 2>&1 &

nohup ncat -l -k -p 21 -c 'echo "Hello from $(hostname) on port 21"' >/dev/null 2>&1 &

nohup ncat -l -k -p 23 -c 'echo "Hello from $(hostname) on port 23"' >/dev/null 2>&1 &

nohup ncat -l -k -p 53 -c 'echo "Hello from $(hostname) on port 53"' >/dev/null 2>&1 &

nohup ncat -l -k -p 80 -c 'echo "Hello from $(hostname) on port 80"' >/dev/null 2>&1 &

nohup ncat -l -k -p 143 -c 'echo "Hello from $(hostname) on port 143"' >/dev/null 2>&1 &

nohup ncat -l -k -p 443 -c 'echo "Hello from $(hostname) on port 443"' >/dev/null 2>&1 &

nohup ncat -l -k -p 5900 -c 'echo "Hello from $(hostname) on port 5900"' >/dev/null 2>&1 &

nohup ncat -l -k -p 8000 -c 'echo "Hello from $(hostname) on port 8000"' >/dev/null 2>&1 &

nohup ncat -l -k -p 8080 -c 'echo "Hello from $(hostname) on port 8080"' >/dev/null 2>&1 &
