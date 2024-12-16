# Use a base image with NFS support
FROM debian:latest

# Install necessary packages for NFS
RUN apt-get update && apt-get install -y \
    nfs-kernel-server \
    nfs-common \
    && rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /etc/secrets /jobfile-run

# Add script for setting up NFS users and exports
COPY setup_nfs.sh /usr/local/bin/setup_nfs.sh
RUN chmod +x /usr/local/bin/setup_nfs.sh

# Set entrypoint to run setup and start NFS server
ENTRYPOINT ["/usr/local/bin/setup_nfs.sh"]

# Expose ports used by NFS
EXPOSE 111/udp 2049/tcp








# # Use an official NFS server base image (e.g., Ubuntu or Debian)
# FROM ubuntu:20.04

# # Set environment variables
# ENV DEBIAN_FRONTEND=noninteractive

# # Update package list and install NFS server and necessary utilities
# RUN apt-get update && \
#     apt-get install -y \
#     nfs-kernel-server \
#     make \
#     sudo \
#     gnupg \
#     && rm -rf /var/lib/apt/lists/*

# # Create necessary directories for the NFS mount point
# RUN mkdir -p /mnt/nfs && \
#     mkdir -p /jobfile-run && \
#     chown nobody:nogroup /mnt/nfs /jobfile-run

# # Copy secret files into the container
# COPY secrets /etc/secrets

# # Add NFS users from the secret file, using /usr/sbin/nologin if not present
# RUN make secrets && \
#     while IFS= read -r user; do \
#         if ! id "$user" &>/dev/null; then \
#             useradd -m -s /usr/sbin/nologin "$user"; \
#         fi \
#     done < /etc/secrets/users.txt

# # Configure NFS exports
# RUN echo "/jobfile-run *(rw,sync,no_subtree_check)" > /etc/exports

# # Expose NFS ports
# EXPOSE 2049

# # Start the NFS server
# CMD ["sh", "-c", "exportfs -a && service nfs-kernel-server start && tail -f /var/log/syslog"]


