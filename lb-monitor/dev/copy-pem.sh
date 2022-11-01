#!/usr/bin/bash

# Write private key file
terraform output -raw tls_private_key > ./id_rsa

# We get these permissions when we write over
#-rw-r--r-- 1 ubuntu ubuntu 3243 Oct  9 20:07 id_rsa
# chmod 600 id_rsa

# Variables
MY_USER="ubuntu"
SRC_FILE="./id_rsa"
DEST_IP="$(terraform output jump_pip | sed -e 's/"//g')"
DEST_DIR="/home/ubuntu/.ssh"
KEY="/c/Users/rgran/.ssh/id_rsa_azure"

DEST="${MY_USER}@${DEST_IP}:${DEST_DIR}"
echo "INFO: Destination: ${DEST}"
echo "INFO: Destination: ${DEST}"

# Copy
if [[ -f $SRC_FILE && $KEY ]]
then
    echo "INFO: scp -i $KEY ${SRC_FILE} ${DEST}"
    scp -i $KEY ${SRC_FILE} ${DEST}
else
    print "ERROR: $SRC_FILE and/or $KEY do not exist."
fi

