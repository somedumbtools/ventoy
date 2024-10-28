#!/bin/sh

print_err() {
    echo -e "\n\n\n\n"
    echo -e "\n\033[31m [ERROR] $* \033[0m"
    echo ""
    echo ""    
    read -p "Press Enter to reboot ...... "
    reboot -f 
}

print_log() {
    echo -e "\033[32m $* \033[0m"
}


if [ -e /sys/firmware/efi ]; then
    :
else
    print_err "Current is NOT in UEFI mode. Please boot in UEFI mode."
    exit 1
fi

Var=$(ls -1 /sys/firmware/efi/efivars/ | grep -i "secureboot")
if [ -z "$Var" ]; then
    print_err "SecureBoot EFI variables not found!"
    exit 1
fi

if hexdump -e '16/1 "%02x " "\n"'  /sys/firmware/efi/efivars/$Var | grep -q "01 *$"; then
    :
else
    print_err "SecureBoot option is not enabled in the BIOS, please enable it firstly!"
    exit 1
fi


if [ -f /ENROLL_THIS_KEY_IN_MOKMANAGER.cer ];then
    (echo 123; echo 123) | mokutil --delete /ENROLL_THIS_KEY_IN_MOKMANAGER.cer > /dev/null 2>&1

    clear
    echo -e "\n\n\n\n"
    print_log "======================================================================"
    print_log " Ventoy key is now successfully marked as deleted."
    print_log " Please delete it with password 123 after you reboot into MokManager."
    print_log "======================================================================"
    echo ""

    for i in 5 4 3 2 1; do
        echo -en "\033[32m \rSystem will reboot in $i seconds. \033[0m"
        sleep 1
    done
    echo ""
    reboot -f
else
    print_err "/ENROLL_THIS_KEY_IN_MOKMANAGER.cer not found!"
    exit 1
fi
