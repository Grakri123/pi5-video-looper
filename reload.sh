#!/bin/sh

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./reload.sh"
  exit 1
fi

# Restart the supervisor service to reload the video looper
echo "Restarting video looper..."
service supervisor restart

echo "Done! Video looper has been restarted."