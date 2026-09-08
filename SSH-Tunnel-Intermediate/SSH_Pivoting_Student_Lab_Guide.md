# SSH Pivoting & Tunneling: Student Lab Guide

**Course/Lab:** Intermediate Network Security & Lateral Movement  
**Document Type:** Student Lab Guide & Field Manual  

---

## 1. Executive Overview

Welcome to the Intermediate SSH Tunneling & Pivoting Lab! In this exercise, you will act as a security practitioner navigating through a multi-tiered, segmented network using SSH. You will start on an `attacker` workstation and must pivot sequentially across isolated network segments from `pc1` through to `pc5`.

Each intermediate host contains a `/flag.txt` file at the root directory (`/`) containing the credentials required to access the subsequent target machine. Your ultimate objective is to reach the final host (`pc5`) and retrieve the target flag located in its home directory (`~/flag.txt`).

---

## 2. Network Architecture & Credential Matrix

| Hostname | IPv4 Address | Username | Password | Flag Location | Network Segment |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **attacker** | `172.28.0.10` | `attacker` | `attacker` | N/A (Starting Point) | Segment A |
| **pc1** | `172.28.0.11` | `user-1` | `franklin` | `/flag.txt` | Segment A / B |
| **pc2** | `172.29.0.11` | `user-2` | `billybob` | `/flag.txt` | Segment B / C |
| **pc3** | `172.30.0.30` | `user-3` | `marigold` | `/flag.txt` | Segment C / D |
| **pc4** | `172.31.0.40` | `user-4` | `velvet` | `/flag.txt` | Segment D / E |
| **pc5** | `172.32.0.50` | `final-user` | `lastone` | `~/flag.txt` | Segment E |

> **Network Isolation Rule:**  
> You cannot access internal hosts directly from your local terminal or `attacker` host! Each machine can only communicate directly with the adjacent node in the network chain. Tunnels or jump host connections are required to advance through each segment.

---

## 3. Core Technical Concepts

### 3.1 Local Port Forwarding (`-L`)
Local port forwarding allows you to take a port on your local machine (`127.0.0.1`) and tunnel connection requests through an SSH server to a destination IP and port that the SSH server can reach.

* **Syntax:** `ssh -L [local_ip:]local_port:destination_ip:destination_port user@jump_host`
* **Flags used:**
  * `-L`: Defines local port forwarding.
  * `-N`: Do not execute a remote command (useful for forwarding ports only).
  * `-f`: Requests SSH to go to background just before command execution.

### 3.2 SSH Jump Hosts (`-J`)
The `-J` option specifies a jump host (or a comma-separated list of multiple jump hosts) to tunnel through. Instead of building manual port-forward chains, SSH handles establishing the intermediate `direct-tcpip` channels automatically.

* **Syntax:** `ssh -J user1@host1,user2@host2 target_user@target_host`

### 3.3 SSH Connection Multiplexing
Multiplexing allows multiple parallel SSH sessions or channels to share a single, already-established TCP connection. This skips repeated authentications across long jump chains.

* **Key Options:**
  * `ControlMaster auto`: Automatically creates or reuses a master socket.
  * `ControlPath`: File path location for the control socket.
  * `ControlPersist`: Keeps the background socket open for a specified duration.

---

## 4. Step-by-Step Execution Guide

### Phase 1: Establish Access to Attacker Host
1. Connect to the initial attacker container environment from your workspace:
   ```bash
   ssh attacker@172.28.0.10
   ```
   *Password:* `attacker`

2. Verify system environment:
   ```bash
   hostname
   ip a
   ```

---

### Phase 2: Pivot 1 — Compromise PC1
1. SSH directly into `pc1` from the `attacker` terminal:
   ```bash
   ssh user-1@172.28.0.11
   ```
   *Password:* `franklin`

2. Harvest credentials for `pc2` from the root directory:
   ```bash
   cat /flag.txt
   ```
3. Record credentials (`user-2` / `billybob`) and exit back to `attacker`.

---

### Phase 3: Pivot 2 — Local Port Forwarding to PC2
1. From `attacker`, build a local port forward (`-L`) through `pc1` (`172.28.0.11`) to reach `pc2` (`172.29.0.11`):
   ```bash
   ssh -L 2222:172.29.0.11:22 user-1@172.28.0.11 -N -f
   ```

2. Connect to `pc2` locally through port 2222:
   ```bash
   ssh -p 2222 user-2@127.0.0.1
   ```
   *Password:* `billybob`

3. Read the flag to obtain credentials for `pc3`:
   ```bash
   cat /flag.txt
   ```
4. Record credentials (`user-3` / `marigold`) and close the connection.

---

### Phase 4: Pivot 3 — Multi-Hop Jump Host to PC3
1. Use SSH Jump Host syntax (`-J`) to chain connections through `pc1` and `pc2` simultaneously:
   ```bash
   ssh -J user-1@172.28.0.11,user-2@172.29.0.11 user-3@172.30.0.30
   ```
   *Authentications required in order:*
   * `user-1` password: `franklin`
   * `user-2` password: `billybob`
   * `user-3` password: `marigold`

2. Harvest credentials for `pc4`:
   ```bash
   cat /flag.txt
   ```
3. Record credentials (`user-4` / `velvet`) and exit.

---

### Phase 5: Pivot 4 — Deep Pivot to PC4
1. Extend your SSH Jump Host chain across 3 intermediate hops to reach `pc4`:
   ```bash
   ssh -J user-1@172.28.0.11,user-2@172.29.0.11,user-3@172.30.0.30 user-4@172.31.0.40
   ```
   *Authentications:* Enter passwords sequentially for `user-1`, `user-2`, `user-3`, and finally `user-4` (`velvet`).

2. Harvest credentials for the final target:
   ```bash
   cat /flag.txt
   ```
3. Record credentials (`final-user` / `lastone`) and exit.

---

### Phase 6: Final Phase — Capture Final Flag on PC5
1. Traverse the full 4-hop network pivot chain to reach `pc5`:
   ```bash
   ssh -J user-1@172.28.0.11,user-2@172.29.0.11,user-3@172.30.0.30,user-4@172.31.0.40 final-user@172.32.0.50
   ```
   *Password for final-user:* `lastone`

2. Extract the final flag from the user's home directory:
   ```bash
   cat ~/flag.txt
   ```

---

## 5. Advanced Optimization: Multiplexing Setup

To avoid repeated password prompts during lab exercises, set up an SSH configuration file on the `attacker` host (`~/.ssh/config`):

```text
Host *
    ControlMaster auto
    ControlPath ~/.ssh/control-%r@%h:%p
    ControlPersist 10m

Host pc1
    HostName 172.28.0.11
    User user-1

Host pc2
    HostName 172.29.0.11
    User user-2
    ProxyJump pc1

Host pc3
    HostName 172.30.0.30
    User user-3
    ProxyJump pc2

Host pc4
    HostName 172.31.0.40
    User user-4
    ProxyJump pc3

Host pc5
    HostName 172.32.0.50
    User final-user
    ProxyJump pc4
```

With this configuration created, connecting to any deep target requires only a single, simple command:
```bash
ssh pc5
```

---

## 6. Verification Checklist & Notes

* [ ] Logged into `attacker` host (`172.28.0.10`)
* [ ] Compromised `pc1` (`172.28.0.11`) and obtained `user-2` password
* [ ] Established local port forward to `pc2` (`172.29.0.11`) and obtained `user-3` password
* [ ] Built multi-hop jump chain to `pc3` (`172.30.0.30`) and obtained `user-4` password
* [ ] Navigated jump chain to `pc4` (`172.31.0.40`) and obtained `final-user` password
* [ ] Reached `pc5` (`172.32.0.50`) and recorded final home directory flag
