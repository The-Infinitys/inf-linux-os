#!/bin/bash

echo "Building Infinity Linux!"

# Set the time zone

echo "Updating System..."
apt update
apt upgrade -y
apt full-upgrade -y
echo "Updated System."

