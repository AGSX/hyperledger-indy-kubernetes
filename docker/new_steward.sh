#!/bin/bash
IFS=

set -u

echo $1 # trustee-seed
echo $2 # steward did
echo $3 # steward verkey

docker run --rm -it --network indy --ip 10.0.1.100 -v $(pwd)/build/steward1:/home/indy/.indy --entrypoint indy local/indy "connect local" "new key with seed $(echo $1)" "send NYM dest=$(echo $2) role=STEWARD" "send NYM dest=(echo $2) verkey=(echo $3)" "exit"
