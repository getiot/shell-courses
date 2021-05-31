#!/bin/bash

a=1; b=2
echo $a+$b
echo $[$a+$b]

c=`expr $a + $b`
echo $c

var=`echo "scale=4;10/3"|bc`
echo $var

array=(10 20 30 40 50)
echo ${array[3]}
array[3]=100
echo ${array[3]}
array[6]="apple"
echo ${array[6]}

len=${#array[@]}
echo $len
len=${#array[*]}
echo $len
len=${#array[6]}
echo $len
