#!/bin/bash
# =============================================
# TEST ACCESS CONTROL - CPRE431 Lab
# Run as: sudo ./test_access.sh
# =============================================

echo "========================================"
echo "  TESTS THAT SHOULD WORK"
echo "========================================"

echo ""
echo "--- TEST 1: user1 reads user2 schedule ---"
sudo -u user1 cat /home/user2/schedule.txt \
    && echo "PASSED" || echo "FAILED"

echo ""
echo "--- TEST 2: user1 reads user2 notes.txt ---"
sudo -u user1 cat /home/user2/documentation/notes.txt \
    && echo "PASSED" || echo "FAILED"

echo ""
echo "--- TEST 3: user1 reads user2 source_code ---"
sudo -u user1 cat /home/user2/code/source_code.txt \
    && echo "PASSED" || echo "FAILED"

echo ""
echo "--- TEST 4: user4 reads own finance ---"
sudo -u user4 cat /home/user4/finance/business.txt \
    && echo "PASSED" || echo "FAILED"

echo ""
echo "========================================"
echo "  TESTS THAT SHOULD FAIL"
echo "========================================"

echo ""
echo "--- TEST 5: user5 reads user1 code (should FAIL) ---"
sudo -u user5 cat /home/user1/code/source_code.txt \
    && echo "FAILED" || echo "PASSED (correctly denied)"

echo ""
echo "--- TEST 6: user1 reads user4 finance (should FAIL) ---"
sudo -u user1 cat /home/user4/finance/business.txt \
    && echo "FAILED" || echo "PASSED (correctly denied)"

echo ""
echo "--- TEST 7: user5 reads user1 notes (should FAIL) ---"
sudo -u user5 cat /home/user1/documentation/notes.txt \
    && echo "FAILED" || echo "PASSED (correctly denied)"

echo ""
echo "--- TEST 8: user4 reads user3 finance (should FAIL) ---"
sudo -u user4 cat /home/user3/finance/business.txt \
    && echo "FAILED" || echo "PASSED (correctly denied)"

echo ""
echo "========================================"
echo "  ALL TESTS COMPLETE!"
echo "========================================"
