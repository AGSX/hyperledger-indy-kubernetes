# Introduction

This is initial work a Helm chart to launch a small Indy cluster for testing.

Since the docs (as of late 2017) are mixed between the Sovrin project and the Indy project it is difficult to know which one is the correct source of setup information. This is our best attempt to distil what we've found.

# Setup

Follow the Docker docs to generate required keys. The values.yaml can be duplicated and updated to use the generated keys.

```
helm install --name indy --namespace indy --values my-values.yaml .
```

# External docs

The docs & resources found so far are:

- <https://github.com/hyperledger/indy-node/blob/master/setup.md>
- <https://github.com/hyperledger/indy-node/blob/master/docs/Sovrin_Running_Locally.md>
- <https://jira.hyperledger.org/browse/INDY-444> (sovrin shell code to add a node?)

Dockerfile resources

- <https://github.com/evernym/sovrin-environments/tree/master/docker>
- <https://github.com/hyperledger/indy-node/tree/master/docker-files>

Finally once running this is the getting started example (note: may also need agents running):

- <https://github.com/hyperledger/indy-node/blob/master/getting-started.md>