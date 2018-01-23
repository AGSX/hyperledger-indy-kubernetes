# Bootstrapping an INDY Cluster


## Running a test cluster locally

The directory `cluster/dev` contains sample genesis transaction files, this can be used to bootstrap a test cluster. Details on how to generate these files are provided below. 

The following nodes and users are created:

| node      | ip        | node port | client port | seed                             |
|-----------|-----------|-----------|-------------|----------------------------------|
| steward1    | 10.0.1.11 | 9701      | 9702        | 00000000000000000000000000000001 |
| steward2       | 10.0.1.12 | 9701      | 9702        | 00000000000000000000000000000002 |
| steward3       | 10.0.1.13 | 9701      | 9702        | 00000000000000000000000000000003 |
| steward4 | 10.0.1.14 | 9701      | 9702        | 00000000000000000000000000000004 |

| identity  | role    | seed                             |
|-----------|---------|----------------------------------|
| trustee1       | trustee | 00000000000000000000000000000000 |
| steward1    | steward | 00000000000000000000000000000001 |
| steward2       | steward | 00000000000000000000000000000002 |
| steward3       | steward | 00000000000000000000000000000003 |
| steward4 | steward | 00000000000000000000000000000004 |


### Build the docker container

```
$ docker build -t local/indy .
```

(TODO: Point to docker repository here)

### Create the docker network

The nodes defined in `cluster/dev` needs a new docker network created.

```
$ docker network create --subnet 10.0.1.0/24 indy
```

### Start the containers

The containers needs the following:

- network: indy
- ip: as defined on the transactions file
- env:
    - node: $alias
- volumes:
    - `build/$node` -> `/home/indy/.indy`
   
#### steward1

```
mkdir -p $(pwd)/build/steward1
cp $(pwd)/cluster/dev/* $(pwd)/build/steward1
echo "00000000000000000000000000000001" > $(pwd)/build/steward1/seed
docker run -d \
    --name steward1 \
    --hostname steward1 \
    --network indy \
    --ip 10.0.1.11 \
    -e node=steward1 \
    -v $(pwd)/build/steward1:/home/indy/.indy \
    local/indy
```

#### steward1

```
mkdir -p $(pwd)/build/steward1
cp $(pwd)/cluster/dev/* $(pwd)/build/steward2
echo "00000000000000000000000000000002" > $(pwd)/build/steward2/seed
docker run -d \
    --name steward2 \
    --hostname steward2 \
    --network indy \
    --ip 10.0.1.12 \
    -e node=steward2 \
    -v $(pwd)/build/steward2:/home/indy/.indy \
    local/indy
```

#### steward3

```
mkdir -p $(pwd)/build/steward3
cp $(pwd)/cluster/dev/* $(pwd)/build/steward3
echo "00000000000000000000000000000003" > $(pwd)/build/steward3/seed
docker run -d \
    --name steward3 \
    --hostname steward3 \
    --network indy \
    --ip 10.0.1.13 \
    -e node=steward3 \
    -v $(pwd)/build/steward3:/home/indy/.indy \
    local/indy
```


#### steward4

```
mkdir -p $(pwd)/build/steward4
cp $(pwd)/cluster/dev/* $(pwd)/build/steward4
echo "00000000000000000000000000000004" > $(pwd)/build/steward4/seed
docker run -d \
    --name steward4 \
    --hostname steward4 \
    --network indy \
    --ip 10.0.1.14 \
    -e node=steward4 \
    -v $(pwd)/build/steward4:/home/indy/.indy \
    local/indy
```

#### Client

```
docker run --rm -it \
    --name client \
    --hostname client \
    --network indy \
    --ip 10.0.1.100 \
    -v $(pwd)/build/client:/home/indy/.indy \
    --entrypoint indy \
    local/indy
```




## Generating the domain transactions

The `domain_transactions_sandbox_genesis` contains the list of `TRUSTEES`, `STEWARDS`, and initial `CLIENTS`. This is a file that lives in `/home/indy/.indy/domain_transactions_sandbox_genesis` and is required to bootstrap the cluster. 

eg. 

```
{"dest":"4QxzWk3ajdnEA37NdNU5Kt","role":"0","type":"1","verkey":"~8RBNqGxt6TsUL4uHQmpy4r"}
{"dest":"4cLztgZYocjqTdAZM93t27","identifier":"4QxzWk3ajdnEA37NdNU5Kt","role":"2","type":"1","verkey":"~G735ywSBri4x3svvVE8qYY"}
{"dest":"JDmZmbYJnRyz5mb5U9wCxK","identifier":"4QxzWk3ajdnEA37NdNU5Kt","role":"2","type":"1","verkey":"~4Z7Qnboe25QhrDsy1MqUUu"}
{"dest":"NhSTz5qnEnUtR4eD3pef4N","identifier":"4QxzWk3ajdnEA37NdNU5Kt","role":"2","type":"1","verkey":"~FByWuddNxRVcSaHqDMmjor"}
{"dest":"XvfMzdPbDtUoVuMAKGH7n8","identifier":"4QxzWk3ajdnEA37NdNU5Kt","role":"2","type":"1","verkey":"~XPHMTchMuFnxdtU1GgyDEY"}
```

It is composed of several line separated JSON files which contains the entities and their roles.

The JSON fields are:

```
dest: the DID of the entity (generated with indy client)
role: 0 for TRUSTEE, 2 for STEWARD, no role for CLIENT (there's more, have to look at SDK)
type: 1 (no idea yet, leave it as is?)
verkey: is the truncated verification key (generated with indy client)
identifier: (no idea yet, seems to point to the trustee, could be the trustee that added it?)
```

To generated the `DID` and `verkey`, run the following:

```
indy> new key with seed {{32 character secret}}
```

Note: The seed should be unique for each identity


To bootstrap a usable Indy Cluster, the following needs to be in the `domain_transactions_sandbox_genesis` file:

- at least 1 trustee
- at least 4 stewards


## Generating the pool transactions

The `pool_transactions_sandbox_genesis` contains the initial list of nodes. This file lives `/home/indy/.indy/pool_transactions_sandbox_genesis` and is required to bootstrap the cluster. 

eg. 

```
{"data":{"alias":"steward1","blskey":"gVE5JwrJzfCB7JhzDKehyjv771N24Ce8sFffJdN82KjtDfCzLngPG7DQGhncFnLe9TWDqGmUkGQv24LhMicFTBWR69kxmLFohzeNLvXfKEAZZwYXFMoTEU2SR7Pq19ezU3QDBccHP4x7TyKZTKg4YKs4wsVvMsLKzpo3qJzjKyNvdb","client_ip":"10.0.1.11","client_port":9702,"node_ip":"10.0.1.11","node_port":9701,"services":["VALIDATOR"]},"dest":"2y6oVqbnTeZ4tv6WUY7FMHhY6SouNixyeWKHPgFDCsY8","identifier":"4cLztgZYocjqTdAZM93t27","txnId":"fea82e10e894419fe2bea7d96296a6d46f50f93f9eeda954ec461b2ed2950b62","type":"0"}
{"data":{"alias":"steward2","blskey":"2X7jXgMSDwfHAn1Sirz32RTiiEVMAoqF7pJksAHnJeRgDaWG3ra6NXH5Fxgjm9Nqs195PAyEDhLRxUd7Up9YuTwqNzsax49M7pXVnNpmE4grX42xdnCHXmSiEd9hXtC66AS8FxbHzVRrhei22o3jrT3DF63GtXedxMV3cL9nfKAQwSD","client_ip":"10.0.1.12","client_port":9702,"node_ip":"10.0.1.12","node_port":9701,"services":["VALIDATOR"]},"dest":"APN393PJb55Jyi94DtgkQPd9zxghPbFSPqheppei5Esf","identifier":"JDmZmbYJnRyz5mb5U9wCxK","txnId":"1ac8aece2a18ced660fef8694b61aac3af08ba875ce3026a160acbc3a3af35fc","type":"0"}
{"data":{"alias":"steward3","blskey":"2LDCy2sXtvYDwPEeE2Swwo4nGRV3KaaD3imEpSHmuG8ZWYvRwzaj2T9VVLc2ezj5RStaQiCtbMowWscsrQR5YPZ3ZK1VvLp43EvepRDGzR8ingcgMx4vFEWVWmRSJxm64Ee6Py8c7FT5zTjAAiCu5NFxQznUSG93HgbLjiQ8NTubbC9","client_ip":"10.0.1.13","client_port":9702,"node_ip":"10.0.1.13","node_port":9701,"services":["VALIDATOR"]},"dest":"CptjtSLBcJyLuHN8SQYfCg9VnYRqVPnHYr4vaNg9yspQ","identifier":"NhSTz5qnEnUtR4eD3pef4N","txnId":"7e9f355dffa78ed24668f0e0e369fd8c224076571c51e2ea8be5f26479edebe4","type":"0"}
{"data":{"alias":"steward4","blskey":"eLSXyKqw7neULSsiSYWg9M5UnKBj6dsF5pP5FTKFABYkXxbzoiWUoTNxZSdWEYgAGCERewMNWi1Fhd6mdxw6Q42RiZFdJ5vBs4Kz1XUed6vymGGYJjHQwv8nKTwG95yfr5FQm2YcTHoBZHGrunGAa6xybQ5nsdrxovX7mMwecxGqmr","client_ip":"10.0.1.14","client_port":9702,"node_ip":"10.0.1.14","node_port":9701,"services":["VALIDATOR"]},"dest":"HrcB3sXM3zaVSG4druxdtmBCSq5p5C6XPer9BZYSgqY4","identifier":"XvfMzdPbDtUoVuMAKGH7n8","txnId":"aa5e817d7cc626170eca175822029339a444eb0ee8f0bd20d3b0b76e566fb008","type":"0"}
```

It is composed of several line separated JSON files which contains the initial nodes.

The JSON fields are:

```
alias: an alias for the node, eg. steward1
blskey: generated using init_indy_node
client_ip: ip where clients communicate, eg. 10.0.1.11
client_port: port whre clients communicate, eg. 9702
node_ip: ip for inter-node communication, eg. 10.0.1.11
node_port: port for inter-node communication, eg. 9701
dest: base58 encoded node verification key
identifier: the DID of the steward (from domain_transactions)
txnId: a series of hex characters (64 characters, must be unique)
```

the `blskey` and `dest` will be generated using the following:

```
$ init_indy_node $alias $node_port $client_port $seed
```

The `blskey` is from the output: `BLS Public Key`. The `Verification key` needs to be encoded to Base58.

```
$ python3 -c "from plenum.common.test_network_setup import TestNetworkSetup; print(TestNetworkSetup.getNymFromVerkey(str.encode('NODE_VERKEY')))"
```

To bootstrap a usable Indy Cluster, the following needs to be in the `pool_transactions_sandbox_genesis` file:

- at least 4 nodes

## Starting the nodes

The nodes should have a copy of the following:

- `domain_transactions_sandbox_genesis`
- `pool_transactions_sandbox_genesis`

The nodes need to run the following:

```
$ init_indy_node $alias $node_port $client_port $seed
$ start_indy_node $alias $node_port $client_port
```

Once the nodes are started, run a client and connect to the `test` network:

```
indy> connect test
```

This should show the client connecting to the indy nodes.


## Adding new nodes

New nodes can be added by doing the following:

- use the trustee to register a new steward
- use the new steward to register the node
- run the container for new node

### Register a new steward

The new steward should generate new keys using indy client and provide the keys to the trustee:

```
indy> new key with seed (steward-key)
```

The Trustee should add the new steward keys:

```
indy@test> new key with seed (trustee-seed) #### this is to change DID to the trustee
indy@test> send NYM dest=(steward-did) role=STEWARD
indy@test> send NYM dest=(steward-did) verkey=(steward-verkey)
```

Once the keys are added, the new steward should send an add node request:

```
#### generate node keys

$ init_indy_node $alias $node_port $client_port $seed

#### generate node_dest

$ python3 -c "from plenum.common.test_network_setup import TestNetworkSetup; print(TestNetworkSetup.getNymFromVerkey(str.encode('NODE_VERKEY')))"

#### send node
indy@test> new key with seed (steward-key) #### this is to change DID to the new steward
indy@test> send NODE dest=$node_dest data={"services":["VALIDATOR"], "node_ip": "$node_ip", "node_port": $node_port, "client_ip": "$client_ip", "client_port": $client_port, "alias": "$alias", "blskey": "$blskey"}
```

Once the node has been accepted, the node can be started (eg. start container).