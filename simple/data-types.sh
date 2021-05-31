#!/bin/bash

NUM="Hello"
echo $NUM+1

echo `expr $NUM + 1`

NUM=1
echo `expr $NUM + 1`

RESULT="false"

if $RESULT; then
    echo "Is true. $RESULT"
else
    echo "Is false. $RESULT"
fi

str1=getiot.tech
str2='getiot.tech'
str3="getiot.tech"

echo $str1
echo $str2
echo $str3
echo ${#str3}
echo ${str:0:2}
