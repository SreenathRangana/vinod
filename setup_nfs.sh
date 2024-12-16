#!/bin/bash

# Load secrets and create users
if [ -f /etc/secrets/nfs_users ]; then
    while IFS=: read -r username password; do
        if ! id "$username" &>/dev/null; then
            useradd -M -s /usr/sbin/nologin "$username"
            echo "$username:$password" | chpasswd
        fi
    done < /etc/secrets/nfs_users
fi

# Ensure the global mount point exists
mkdir -p /jobfile-run

# Configure exports
echo "/jobfile-run *(rw,sync,no_root_squash)" > /etc/exports

# Start required services
rpcbind
service nfs-kernel-server start

# Keep container running
tail -f /dev/null
