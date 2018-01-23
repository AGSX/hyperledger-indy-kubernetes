#!/bin/bash
IFS=

set -u

echo $1 # seed

indy "new key with seed $(echo $1)" "exit" 