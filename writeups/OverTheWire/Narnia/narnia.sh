#!/bin/bash

# Check if a username argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <level>"
    exit 1
fi

# Store the username from the command-line argument
LEVEL=$1

# Define the server address (replace with your server's address)
SERVER="narnia.labs.overthewire.org"

# Define the password file
PASSWORD_FILE="narnia-passwords.txt"

# Read the corresponding password for narnia1 from the file
PASSWORD=$(sed -n "$((LEVEL + 1))p" "$PASSWORD_FILE")

# Check if the password was found
if [ -z "$PASSWORD" ]; then
    echo "No password found for user narnia1 in $PASSWORD_FILE."
    exit 1
fi

# Connect to the SSH server using the username narnia0 and the fetched password
sshpass -p "$PASSWORD" ssh "narnia${LEVEL}@${SERVER}" -p 2226

