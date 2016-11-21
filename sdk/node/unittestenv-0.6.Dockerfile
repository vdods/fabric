# Start with an image that has most of the necessary tools
FROM hyperledger/fabric-src:x86_64-0.6.2-preview-snapshot-ee5b85c
ENV FABRIC_SDK_NODE_DIR $GOPATH/src/github.com/hyperledger/fabric/sdk/node/
# In order for `npm install` to complete successfully, node-gyp requires python 2, so install it and set the PYTHON env var.
RUN apt-get update && \
    apt-get --assume-yes install python2.7-minimal
ENV PYTHON python2.7
# Set the fabric/sdk/node dir as the working dir.
WORKDIR $FABRIC_SDK_NODE_DIR
