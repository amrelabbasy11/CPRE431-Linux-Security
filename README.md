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

## Part 1 - Password 
