#!/bin/bash

lines=9 
tail -n+$lines $0 > /tmp/hello.tar.bz2
cd /tmp
tar jxvf hello.tar.bz2
sudo cp hello /bin
exit 0
