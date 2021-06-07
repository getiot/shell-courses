#!/bin/bash

user=`whoami`

case $user in
    root) echo "You are super user";;
    rudy) echo "You are my boyfriend";;
    tina) echo "You are my girlfriend";;
    *) echo "Other user";;
esac

