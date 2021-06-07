#!/bin/bash

a=10; b=20

if [ !false ]; then
    echo "true"
else
    echo "false"
fi

if [ $a -lt 20 -o $b -gt 100 ]; then
    echo "true"
else
    echo "false"
fi

if [ $a -lt 20 ] || [ $b -gt 100 ]; then
    echo "true"
else
    echo "false"
fi

if [ $a -lt 20 -a $b -gt 100 ]; then
    echo "true"
else
    echo "false"
fi

if [ $a -lt 20 ] && [ $b -gt 100 ]; then
    echo "true"
else
    echo "false"
fi

echo "--------"

myStr="getiot"

if [ -z $myStr ]; then
    echo "true"
else
    echo "false"
fi

if [ -n $myStr ]; then
    echo "true"
else
    echo "false"
fi

if [ $myStr == "getiot" ]; then
    echo "true"
else
    echo "false"
fi

if [ $myStr != "getiot" ]; then
    echo "true"
else
    echo "false"
fi
