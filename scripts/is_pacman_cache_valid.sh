#!/bin/bash

# Exit code 1 means that pacman packages should be upgraded
# Example ./is_pacman_cache_valid.sh 3600
update_cache_seconds=$1

last_upgrade_date=$(tac /var/log/pacman.log | grep -m 1 "\[PACMAN] synchronizing package lists" | cut -d ' ' -f 1 | tr -d '[]')
# Check we have at least one pacman cache upgrade
if [[ -z "$last_upgrade_date" ]]; then
  exit 1
fi
# Calculate time elapsed since last upgrade
last_upgrade_seconds=$(date +%s -d "$last_upgrade_date")
now_seconds=$(date +%s)
elapsed_seconds=$((now_seconds - last_upgrade_seconds))
# Check elapsed time against the threshold
if [[ "$elapsed_seconds" -gt "$update_cache_seconds" ]]; then
  exit 1
fi
