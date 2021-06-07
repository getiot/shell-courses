#!/bin/bash

for i in {1..10}
do
    echo $i
done

for i in $(seq 1 10)
do
    echo $i
done

for ((i=1; i<=10; i++))
do
    echo $i
done

fruit="apple banana orange"
for i in $fruit
do
    echo $i
done

for i in `ls`
do
    echo $i
done
