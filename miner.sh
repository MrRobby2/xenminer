#!/bin/bash
# Variable 'core' with the number of CPU cores
core=$(cat /proc/cpuinfo | grep -E '^processor' | wc -l)

# Default value for the number of runs (if -c parameter is not provided)
runs="$core"

# Variable indicating whether to kill the screen session and processes (default: false)
kill_session=false

# Function displaying variable descriptions
function display_help() {
  echo "Script for launching a screen session with htop and/or python3 miner.py."
  echo "Usage: $0 [-c NUMBER] [-k] [-h|--help]"
  echo "  -c NUMBER     How many instances of python3 miner.py to run (default: $runs)."
  echo "  -k            Kill the screen session and all processes without displaying a summary."
  echo "  -h, --help    Display this help message."
}

# Parsing command line arguments
while getopts "c:kh-" opt; do
  case "$opt" in
    c) runs="$OPTARG" ;;
    k) kill_session=true ;;
    h|--help) display_help; exit 0 ;;
    \?) echo "Error: Unknown argument -$OPTARG" >&2; exit 1 ;;
  esac
done

# Screen session name
session="miner_session"

# Run the 'htop' command in a screen session
screen -S "$session" -dm bash -c "echo 'Launched htop:'; htop; read -p 'Press Enter to continue...'"

# Run instances of 'python3 miner.py' in the screen session (if runs > 0)
for ((i = 1; i <= runs; i++)); do
  screen -S "$session" -X screen bash -c "echo 'Launched python3 miner.py instance $i of $runs:'; python3 miner.py; read -p 'Press Enter to continue...'"
done

# Display a summary if -k flag is not set
if [ "$kill_session" = false ]; then
  echo "Launched $runs instances of python3 miner.py."
fi

# If the -k flag is set to true, kill the session and processes
if [ "$kill_session" = true ]; then
  pkill -f 'miner_session'
fi
