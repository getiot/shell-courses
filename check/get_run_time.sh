#!/bin/bash

start=$(date +%s)

sleep 5;

end=$(date +%s)
take=$(( end - start ))
echo Time taken to execute commands is ${take} seconds.
