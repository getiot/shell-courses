#!/bin/bash

for file in `ls -1`;
do
    cat $file
    echo -e "\t$file"
done
