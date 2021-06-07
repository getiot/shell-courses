#!/bin/bash

func() {
    echo "Usage:"
    echo "test.sh [-s S_DIR] [-d D_DIR]"
    echo "Description:"
    echo "S_DIR, the path of source."
    echo "D_DIR, the path of destination."
    exit -1
}

upload="false"

while getopts 'h:s:d:u' OPT; do
    case $OPT in
        s) S_DIR="$OPTARG"; echo "$OPTIND: $OPTARG";;
        d) D_DIR="$OPTARG"; echo "$OPTIND: $OPTARG";;
        u) upload="true"; echo "$OPTIND: $OPTARG";;
        h) func; echo "$OPTIND: $OPTARG";;
        ?) func;;
    esac
done

echo $S_DIR
echo $D_DIR
echo $upload

echo $OPTIND
shift $(($OPTIND - 1))
echo $1
