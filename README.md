SSH‑Tunnel‑Intermediate
A hands‑on intermediate‑level SSH tunneling and pivoting lab designed to teach students how to move through isolated network segments using multi‑hop SSH tunnels.
This lab focuses on realistic lateral movement, port forwarding, and pivot chaining, all inside a safe, containerized environment.

📘 Overview
In this lab, students begin on an attacker machine and must pivot through a sequence of isolated hosts.
Each host can only communicate with the next one in the chain, forcing the student to:
• 	Create SSH local port forwards
• 	Build multi‑hop tunnels
• 	Use jump hosts
• 	Extract credentials from each compromised machine
• 	Reach the final target through a full pivot chain
This lab is ideal for teaching intermediate‑level SSH concepts, red‑team fundamentals, or CTF‑style lateral movement.

🗺️ Network Topology
The environment contains six machines:

Each machine contains a  file in  with the credentials for the next machine.

🎯 Learning Objectives
Students will learn how to:
• 	Use SSH to access remote systems
• 	Create local port forwards ()
• 	Build multi‑hop tunnels through multiple isolated networks
• 	Use SSH jump hosts ()
• 	Understand real‑world pivoting and lateral movement
• 	Follow network reachability to determine where tunnels must originate

🚀 Lab Flow
Students progress through the environment in this order:
1. 	Connect to the attacker machine
2. 	SSH into PC1 and retrieve the next credentials
3. 	Create a tunnel from attacker → PC1 → PC2
4. 	SSH into PC2 through the tunnel
5. 	Create a tunnel from PC2 → PC3
6. 	SSH into PC3 through the multi‑hop chain
7. 	Create a tunnel from PC3 → PC4
8. 	SSH into PC4 through the chain
9. 	Create a tunnel from PC4 → PC5
10. 	SSH into PC5 and retrieve the final flag
Each step reinforces the idea that you can only pivot from the machine that has network access to the next target.

📂 Included Materials
This repository includes:
• 	Lab instructions (teaching version)
• 	Command‑only version for quick reference
• 	Docker environment (optional, if you include it)
• 	Network diagram (optional)
• 	Instructor notes (optional)

🧪 Skills Practiced
• 	SSH fundamentals
• 	Local port forwarding
• 	Multi‑hop tunneling
• 	Jump hosts
• 	Network segmentation awareness
• 	Lateral movement techniques
• 	Credential harvesting in chained environments

📦 Requirements
• 	Linux or macOS terminal (Windows WSL works too)
• 	SSH client
• 	Docker (if using the containerized version)

📜 License
MIT License — feel free to use, modify, and adapt this lab for training, CTFs, or classroom use.
