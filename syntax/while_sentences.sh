#!/bin/bash

count=3

while [ $count -gt 0 ]
do
    date
    sleep 1
    ((count--))
    
    if [ $count -lt 2 ]; then
        break
    fi
done
