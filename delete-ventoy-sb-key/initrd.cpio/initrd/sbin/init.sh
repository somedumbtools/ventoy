#!/bin/sh

mkdir  /proc  /sys 
mount -t proc proc /proc
mount -t sysfs sys /sys
mdev -s

mkdir -p /sys/firmware/efi/efivars
mount -t efivarfs none /sys/firmware/efi/efivars

sh /ventoy_delete_key.sh

exec /bin/sh

