============================================================
1. LOCAL MACHINE → attacker
============================================================
# You begin outside the environment. Your only entry point is attacker.
ssh attacker@172.28.0.10


============================================================
2. attacker → PC1
============================================================
# Attacker can only reach PC1 directly.
ssh user-1@172.28.0.11
cat /flag.txt
# This flag contains the credentials for PC2.
exit


============================================================
3. attacker → create tunnel to PC2 THROUGH PC1
============================================================
# PC1 can reach PC2, but attacker cannot.
# So attacker must SSH INTO PC1 and forward a port to PC2.
ssh -L 9001:172.29.0.11:22 user-1@172.28.0.11
# Keep this session open. It is your tunnel.


============================================================
4. LOCAL MACHINE → PC2 (using the tunnel)
============================================================
# Now your local machine can reach PC2 through attacker → PC1.
ssh user-2@localhost -p 9001
cat /flag.txt
# This flag contains the credentials for PC3.
# Stay on PC2 for the next step.


============================================================
5. PC2 → create tunnel to PC3
============================================================
# PC2 can reach PC3, but attacker and PC1 cannot.
# So the tunnel must be created FROM PC2.
ssh -L 9002:172.30.0.30:22 user-3@172.30.0.30
# This gives you a shell on PC3 AND opens the tunnel on PC2.


============================================================
6. LOCAL MACHINE → PC3 (multi-hop)
============================================================
# You now have:
#   local → attacker → PC1 → PC2 → PC3
# Use SSH jump (-J) to chain through the tunnels.
ssh -J user-2@localhost:9001 user-3@localhost -p 9002
cat /flag.txt
# This flag contains the credentials for PC4.
# Stay on PC3 for the next step.


============================================================
7. PC3 → create tunnel to PC4
============================================================
# PC3 can reach PC4, so the tunnel must originate here.
ssh -L 9003:172.31.0.40:22 user-4@172.31.0.40
# You now have a shell on PC4 AND a tunnel on PC3.


============================================================
8. LOCAL MACHINE → PC4 (multi-hop)
============================================================
# Full chain:
#   local → attacker → PC1 → PC2 → PC3 → PC4
ssh -J user-2@localhost:9001,user-3@localhost:9002 user-4@localhost -p 9003
cat /flag.txt
# This flag contains the credentials for PC5.
# Stay on PC4 for the next step.


============================================================
9. PC4 → create tunnel to PC5
============================================================
# PC4 can reach PC5, so the tunnel must originate here.
ssh -L 9004:172.32.0.50:22 final-user@172.32.0.50
# You now have a shell on PC5 AND a tunnel on PC4.


============================================================
10. LOCAL MACHINE → PC5 (final hop)
============================================================
# Full chain:
#   local → attacker → PC1 → PC2 → PC3 → PC4 → PC5
ssh -J user-2@localhost:9001,user-3@localhost:9002,user-4@localhost:9003 final-user@localhost -p 9004
cat ~/welldone.txt
# Final flag captured.
