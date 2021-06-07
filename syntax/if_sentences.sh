#!/bin/bash

read -p "Please enter a number: " num

if [ $num -ge 90 ]; then
    echo "Score: A"
elif [ $num -ge 60 ]; then
    echo "Score: B"
else
    echo "Score: C"
fi
