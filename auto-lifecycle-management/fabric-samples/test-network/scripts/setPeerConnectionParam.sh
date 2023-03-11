#!/bin/bash

# import utils
source /home/mayurpatil2211/Project/auto-lifecycle-management/fabric-samples/test-network/scripts/envVar.sh

parsePeerConnectionParameters $@

echo $PEER_CONN_PARMS

export PEER_CONN_PARMS=$PEER_CONN_PARMS