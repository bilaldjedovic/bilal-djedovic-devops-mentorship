#!/bin/bash
# Test using at command

echo "This script ran at $(date +%B%d,%T)" > script08-1.out
echo >> script08-1.out
sleep 5
echo "This is the script's end..." >> script08-1.out