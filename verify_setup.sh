#!/bin/bash
# =============================================
# VERIFY SETUP - CPRE431 Lab
# =============================================

echo "========================================"
echo "  1. GROUPS CREATED"
echo "========================================"
cat /etc/group | grep -E "allstaff|prog|mgmt"

echo ""
echo "========================================"
echo "  2. USER GROUP MEMBERSHIPS"
echo "========================================"
id user1
id user2
id user3
id user4
id user5

echo ""
echo "========================================"
echo "  3. HOME DIRECTORY PERMISSIONS"
echo "========================================"
ls -l /home/user1/

echo ""
echo "========================================"
echo "  4. CODE DIRECTORY PERMISSIONS"
echo "========================================"
ls -l /home/user1/code/

echo ""
echo "========================================"
echo "  5. DOCUMENTATION DIRECTORY PERMISSIONS"
echo "========================================"
ls -l /home/user1/documentation/

echo ""
echo "========================================"
echo "  6. FINANCE DIRECTORY PERMISSIONS"
echo "========================================"
ls -l /home/user4/finance/
