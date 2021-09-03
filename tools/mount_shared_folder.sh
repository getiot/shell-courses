#!/bin/bash

sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other,nonempty

exit 0
