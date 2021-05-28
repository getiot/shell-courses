#!/bin/sh

# If run this shell script failed in your linux
# Please use /bin/bash instead of /bin/sh

echo "Usage: $0 hello"
echo ""

if [ $1 == "hello" ]; then
    echo "Well done!"
fi
