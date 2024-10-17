#!/bin/bash

# Check if a username argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <level>"
    exit 1
fi

# Store the username from the command-line argument
LEVEL=$1

# Define the server address (replace with your server's address)
SERVER="leviathan.labs.overthewire.org"

# Define the password file
PASSWORD_FILE="leviathan-passwords.txt"


# Read the corresponding password from the file
PASSWORD=$(sed -n "$1p" "$PASSWORD_FILE")

# Check if the password was found
if [ -z "$PASSWORD" ]; then
    echo "No password found for user leviathan$LEVEL in $PASSWORD_FILE."
    exit 1
fi

# Connect to the SSH server using the provided username and password
sshpass -p "$PASSWORD" ssh "leviathan${LEVEL}@${SERVER}" -p 2223

