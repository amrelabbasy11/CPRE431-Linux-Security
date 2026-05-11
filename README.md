# CPRE431 - Linux Server Security Lab
## By: Amr El Abbasy
## Date: May 2026

---

## Table of Contents
1. [Project Overview](#overview)
2. [Files in this Project](#files)
3. [Part 1 - Password Cracking](#part1)
4. [Part 2 - User and Group Management](#part2)
5. [DevOps Tools](#devops)
6. [Screenshots](#screenshots)

---

## Project Overview
This project involves working on a Linux Server Virtual Machine (VM).
The goals are:
- Perform password cracking to gain access to the server
- Manage users, groups, and file permissions as server administrator
- Use DevOps tools to automate the setup

---

## Files in this Project

| File | Where to run | Description |
|------|-------------|-------------|
| crack.sh | Ubuntu machine | Cracks admin1 password |
| crack_users.sh | Inside VM | Cracks all user passwords |
| playbook.yml | Ubuntu machine | Ansible playbook for server setup |
| inventory.ini | Ubuntu machine | Ansible VM connection details |
| verify_setup.sh | Inside VM | Verifies groups and permissions |
| test_access.sh | Inside VM | Tests all access control rules |
| README.md | - | Project documentation |

---

## Part 1 - Password Cracking

### Step 1 - Decrypt the VM link
The VM download link was encrypted using AES-256-CBC
with password class2027 and 1000 iterations.

Command used:
openssl enc -aes-256-cbc -d -iter 1000 
-in gotolink.txt -out decrypted_link.txt -k class2027

> 📸 SCREENSHOT 1: Show the decryption command and output

---

### Step 2 - Download and Setup VM
- Downloaded CPRE431-2.ova from the decrypted Box link
- Imported into VMware Workstation
- Booted VM to get login screen

> 📸 SCREENSHOT 2: Show VMware with VM running and login screen

---

### Step 3 - Get Password Hashes
Booted VM into recovery mode to access /etc/shadow file.

Commands used in recovery mode:
mount -o remount,rw /
cat /etc/shadow

> 📸 SCREENSHOT 3: Show /etc/shadow contents with all hashes

---

### 1a - Hash Type
The admin1 hash from /etc/shadow:
admin1:66
6xgLS35S6$2UjEq.dUhICPw9zgDVJXcQYQp/9ilLPQt/
8Zgu0uwngI5mVvB1eKQG9SnVLjmOOfkB4Jjb5VSAXGXjY4Cf5k90

Hash type is identified by the prefix:
- $1$ = MD5
- $5$ = SHA-256
- $6$ = SHA-512

**Answer: The hash type is SHA-512**

---

### 1b - Salt Value
The salt is the value between the second and third $ signs:
66
6 xgLS35S6 $2UjEq...
      ^^^^^^^^
    Salt = xgLS35S6

**Answer: The salt value is xgLS35S6**

---

### 1c - Crack All Passwords

#### How the crack script works:

Read each password from 100k NIST wordlist
Hash it using openssl passwd -6 -salt SALT PASSWORD
Compare generated hash with stored hash
If match found = PASSWORD CRACKED!


#### Run admin1 crack script:
chmod +x crack.sh
./crack.sh

> 📸 SCREENSHOT 4: Show crack.sh running and finding admin1 password

#### Run all users crack script (inside VM):
chmod +x crack_users.sh
./crack_users.sh

> 📸 SCREENSHOT 5: Show crack_users.sh finding all passwords

#### Cracked passwords results:

| User | Salt | Password |
|------|------|----------|
| admin1 | xgLS35S6 | P@ssw0rd |
| user1 | 2Ff.cblr | ????????? |
| user2 | zZKc4nOX | ????????? |
| user3 | dCPTizMy | ????????? |
| user4 | 0Ptm7uW6 | ????????? |
| user5 | QpU0v3n/ | ????????? |

#### Login to server as admin1:
ssh admin1@192.168.1.26
password: P@ssw0rd

> 📸 SCREENSHOT 6: Show successful login as admin1

---

## Part 2 - User and Group Management

### Server Users Overview

| User | Role | Groups |
|------|------|--------|
| user1 | Programmer | allstaff, prog |
| user2 | Programmer | allstaff, prog |
| user3 | Programmer + Manager | allstaff, prog, mgmt |
| user4 | Manager | allstaff, mgmt |
| user5 | External Consultant | none |

---

### 2a - Create Groups and Assign Users

#### Groups created:
- **allstaff** - all staff members (user1, user2, user3, user4)
- **prog** - all programmers (user1, user2, user3)
- **mgmt** - all managers (user3, user4)

#### Commands used manually:
sudo groupadd allstaff
sudo groupadd prog
sudo groupadd mgmt
sudo usermod -aG allstaff,prog user1
sudo usermod -aG allstaff,prog user2
sudo usermod -aG allstaff,prog,mgmt user3
sudo usermod -aG allstaff,mgmt user4

#### Automated with Ansible:
ansible-playbook -i inventory.ini playbook.yml

> 📸 SCREENSHOT 7: Show Ansible playbook running successfully

#### Verify groups and users:
sudo ./verify_setup.sh

> 📸 SCREENSHOT 8: Show groups created (allstaff, prog, mgmt)
> 📸 SCREENSHOT 9: Show user memberships (id user1 to id user5)

---

### File Structure Created

#### Programmers (user1, user2, user3):
/home/userX/
├── schedule.txt        (644 - all can read)
├── code/               (770 - prog group)
│   ├── source_code.txt (660 - prog group)
│   └── myapp.exe       (750 - prog can execute)
└── documentation/      (750 - allstaff group)
└── notes.txt       (640 - allstaff group)

#### Managers (user3, user4):
/home/userX/
├── schedule.txt        (644 - all can read)
└── finance/            (700 - owner only)
└── business.txt    (600 - owner only)

#### External Consultant (user5):
/home/user5/
└── schedule.txt        (644 - all can read)

---

### 2b - File Access Control

#### Permission table:

| File/Directory | chmod | Owner | Group | Reason |
|---------------|-------|-------|-------|--------|
| /home/userX/ | 711 | user | user | others cannot list |
| schedule.txt | 644 | user | user | all can read |
| documentation/ | 750 | user | allstaff | staff can read |
| notes.txt | 640 | user | allstaff | staff can read |
| code/ | 770 | user | prog | prog can write |
| source_code.txt | 660 | user | prog | prog can edit |
| myapp.exe | 750 | user | prog | prog can run |
| finance/ | 700 | user | user | owner only |
| business.txt | 600 | user | user | owner only |

#### Permission numbers explained:
7 = rwx (read + write + execute)
6 = rw- (read + write)
5 = r-x (read + execute)
4 = r-- (read only)
1 = --x (execute only)
0 = --- (no permission)
Format: Owner-Group-Others
711 = rwx--x--x
644 = rw-r--r--
750 = rwxr-x---
700 = rwx------

> 📸 SCREENSHOT 10: Show ls -l /home/user1/ permissions
> 📸 SCREENSHOT 11: Show ls -l /home/user1/code/ permissions
> 📸 SCREENSHOT 12: Show ls -l /home/user1/documentation/ permissions
> 📸 SCREENSHOT 13: Show ls -l /home/user4/finance/ permissions

---

#### Access Control Tests:

##### Tests that SHOULD work:
sudo -u user1 cat /home/user2/schedule.txt       (all can read)
sudo -u user1 cat /home/user2/documentation/notes.txt  (allstaff)
sudo -u user1 cat /home/user2/code/source_code.txt     (prog group)
sudo -u user4 cat /home/user4/finance/business.txt     (owner)

##### Tests that SHOULD fail:
sudo -u user5 cat /home/user1/code/source_code.txt     (not in prog)
sudo -u user1 cat /home/user4/finance/business.txt     (not owner)
sudo -u user5 cat /home/user1/documentation/notes.txt  (not allstaff)
sudo -u user4 cat /home/user3/finance/business.txt     (not owner)

#### Run all tests:
sudo ./test_access.sh

> 📸 SCREENSHOT 14: Show test_access.sh with all 8 tests PASSED

---

## DevOps Tools Used (Bonus)

### 1. Ansible
Used to automate all of Part 2 setup automatically.
Instead of running 50+ commands manually, one playbook
configures everything perfectly.

Why Ansible:
- Automated group creation
- Automated user assignment
- Automated file structure creation
- Automated permission setting
- No human errors
- Repeatable and consistent

Run the playbook:
ansible-playbook -i inventory.ini playbook.yml

> 📸 SCREENSHOT 15: Show Ansible playbook output

### 2. Git
Used for version control to track all project scripts.

Commands used:
git init
git add .
git commit -m "CPRE431 Final Project - Complete"
git push -u origin master

> 📸 SCREENSHOT 16: Show git log --oneline output

### 3. Lynis (Security Audit)
Used to audit the server security after setup.

Commands:
sudo apt install lynis -y
sudo lynis audit system

> 📸 SCREENSHOT 17: Show Lynis security score

---

## Screenshots Summary

| Screenshot | Description |
|-----------|-------------|
| 1 | Decryption of gotolink.txt |
| 2 | VMware with VM login screen |
| 3 | /etc/shadow contents |
| 4 | crack.sh finding admin1 password |
| 5 | crack_users.sh finding all passwords |
| 6 | Successful login as admin1 |
| 7 | Ansible playbook running |
| 8 | Groups created (allstaff, prog, mgmt) |
| 9 | User memberships (id user1-5) |
| 10 | ls -l /home/user1/ |
| 11 | ls -l /home/user1/code/ |
| 12 | ls -l /home/user1/documentation/ |
| 13 | ls -l /home/user4/finance/ |
| 14 | test_access.sh all 8 tests passed |
| 15 | Ansible playbook output |
| 16 | git log output |
| 17 | Lynis security score |

---

## How to Run Everything

### On Ubuntu machine:
Step 1 - Crack admin password
cd ~/sec project
./crack.sh
Step 2 - Run Ansible playbook
ansible-playbook -i inventory.ini playbook.yml
Step 3 - SSH into VM
ssh admin1@192.168.1.26

### Inside VM:
Step 4 - Crack all user passwords
./crack_users.sh
Step 5 - Verify setup
sudo ./verify_setup.sh
Step 6 - Test access control
sudo ./test_access.sh

Save: Ctrl+O → Enter → Ctrl+X

Now push everything to GitH
