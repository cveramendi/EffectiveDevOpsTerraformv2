#!/bin/bash
# run it with ./test_protection.sh http://websitetocontact/
i=0
while [ $i -le 3000 ]; do
    echo $i
    echo $1
    i=$(expr $i + 1)
    curl http://playground-1174667763.us-east-1.elb.amazonaws.com/subdir/

done
