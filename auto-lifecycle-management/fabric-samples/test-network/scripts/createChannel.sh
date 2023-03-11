#!/bin/bash

# imports  
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="autochannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelTx() {
	set -x
	configtxgen -profile SevenOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	setGlobals "manufacturer"
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.automobile-lifecycle.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER_CA >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  FABRIC_CFG_PATH=$PWD/configtx/
  ORG=$1
  setGlobals $ORG
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer0.${ORG} has failed to join channel '$CHANNEL_NAME' "
	
}

setAnchorPeer() {
  ORG=$1
  docker exec cli ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME 
}

FABRIC_CFG_PATH=${PWD}/configtx

## Create channeltx
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

FABRIC_CFG_PATH=$PWD/configtx/
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

## Join all the peers to the channel
infoln "Joining manufacturer peer to the channel..."
joinChannel "manufacturer"
infoln "Joining dealer peer to the channel..."
joinChannel "dealer"
infoln "Joining regulator peer to the channel..."
joinChannel "regulator"
infoln "Joining vehicleowner peer to the channel..."
joinChannel "vehicleowner"
infoln "Joining carserviceprovider peer to the channel..."
joinChannel "carserviceprovider"
infoln "Joining insuranceprovider peer to the channel..."
joinChannel "insuranceprovider"
infoln "Joining scrapmerchant peer to the channel..."
joinChannel "scrapmerchant"

## Set the anchor peers for each org in the channel
infoln "Setting anchor peer for manufacturer..."
setAnchorPeer "manufacturer"
infoln "Setting anchor peer for dealer..."
setAnchorPeer "dealer"
infoln "Setting anchor peer for regulator..."
setAnchorPeer "regulator"
infoln "Setting anchor peer for vehicleowner..."
setAnchorPeer "vehicleowner"
infoln "Setting anchor peer for carserviceprovider..."
setAnchorPeer "carserviceprovider"
infoln "Setting anchor peer for insuranceprovider..."
setAnchorPeer "insuranceprovider"
infoln "Setting anchor peer for scrapmerchant..."
setAnchorPeer "scrapmerchant"

successln "Channel '$CHANNEL_NAME' joined"
