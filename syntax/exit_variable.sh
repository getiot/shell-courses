#!/bin/bash

fun_test() {
    if [ $1 == 0 ]; then
        return 0
    else
        return 1
    fi
}

FILE=test.txt
touch ${FILE}
echo $?
rm ${FILE}
echo $?
rm ${FILE}
echo $?

fun_test $1
echo $?
