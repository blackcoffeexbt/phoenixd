#!/bin/sh

# Ensure the .ssh directory exists and has appropriate permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate a new SSH key pair only if it does not already exist
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
    echo "New SSH key generated."
else
    echo "Existing SSH key found."
fi

# Output the public key to allow easy access
echo "SSH Public Key:"
cat ~/.ssh/id_rsa.pub

# Setup the SSH reverse tunnel and keep the tunnel open
# Start the autossh reverse tunnel and keep it running
autossh -M 0 -fNT -R $REMOTE_PORT:localhost:9740 \
    -o "StrictHostKeyChecking=no" \
    -o "ServerAliveInterval=60" \
    -o "ServerAliveCountMax=3" \
    $SSH_USER@$REMOTE_HOST

/usr/local/bin/satdress --conf /phoenix/.satdress/config.yml > /phoenix/logs/satdress.out 2> /phoenix/logs/satdress.err &

# Start the phoenixd daemon
exec /phoenix/bin/phoenixd --agree-to-terms-of-service --http-bind-ip "0.0.0.0"