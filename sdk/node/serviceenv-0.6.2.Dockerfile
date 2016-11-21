# Start with an image that has most of the necessary tools
FROM hyperledger/fabric-ccenv:x86_64-0.6.2-preview-snapshot-ee5b85c
# In order for `npm install` to complete successfully, node-gyp requires python 2, so install it and set the PYTHON env var.
# Also install `pip` and install the `requests` python package for use in `synchronizer`.
# Also pull the `synchronizer` tool from github.com.
RUN apt-get update && \
    apt-get --assume-yes install python2.7-minimal python-pip && \
    pip install requests && \
    git clone https://github.com/vdods/synchronizer.git /synchronizer
ENV PYTHON python2.7
