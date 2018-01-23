#!/bin/bash
IFS=

set -u

echo $1 # name
echo $2 # node port
echo $3 # client port
echo $4 # seed

node=$(init_indy_node $(echo $1) $(echo $2) $(echo $3) $(echo $4))

ver=$(echo $node | grep -m 1 "Verification key is" | cut -c 21- -)
blspub=$(echo $node | grep -m 1 "BLS Public key is " | cut -c 19- -)

echo "Verification key: $(echo $ver)"
echo "BLS Pubkey: $(echo $blspub)"

dest=$(python3 -c "from plenum.common.test_network_setup import TestNetworkSetup; print(TestNetworkSetup.getNymFromVerkey(str.encode('$(echo $ver)')))")

echo "dest: $(echo $dest)"
echo "txnId: $(openssl rand -hex 32)"
