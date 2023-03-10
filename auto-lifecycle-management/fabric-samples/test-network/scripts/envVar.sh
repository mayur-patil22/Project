#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/msp/tlscacerts/tlsca.automobile-lifecycle.com-cert.pem
export PEER0_manufacturer_CA=${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/ca.crt
export PEER1_manufacturer_CA=${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/ca.crt
export PEER0_dealer_CA=${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/ca.crt
export PEER1_dealer_CA=${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/ca.crt
export PEER0_regulator_CA=${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/ca.crt
export PEER1_regulator_CA=${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/ca.crt
export PEER0_vehicleowner_CA=${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/ca.crt
export PEER1_vehicleowner_CA=${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/ca.crt
export PEER0_carserviceprovider_CA=${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/ca.crt
export PEER1_carserviceprovider_CA=${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/ca.crt
export PEER0_insuranceprovider_CA=${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/ca.crt
export PEER1_insuranceprovider_CA=${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/ca.crt
export PEER0_scrapmerchant_CA=${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/ca.crt
export PEER1_scrapmerchant_CA=${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/ca.crt


# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG == "manufacturer" ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_manufacturer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/users/Admin@manufacturer.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_manufacturer_CA
    export CORE_PEER_ADDRESS=localhost:7151
  elif [ $USING_ORG == "dealer" ]; then
    export CORE_PEER_LOCALMSPID="DealerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_dealer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/users/Admin@dealer.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_dealer_CA
    export CORE_PEER_ADDRESS=localhost:9151
  elif [ $USING_ORG == "regulator" ]; then
    export CORE_PEER_LOCALMSPID="RegulatorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_regulator_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/users/Admin@regulator.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_regulator_CA
    export CORE_PEER_ADDRESS=localhost:13151
  elif [ $USING_ORG == "vehicleowner" ]; then
    export CORE_PEER_LOCALMSPID="VehicleOwnerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_vehicleowner_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/users/Admin@vehicleowner.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:9251
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_vehicleowner_CA
    export CORE_PEER_ADDRESS=localhost:9351
  elif [ $USING_ORG == "carserviceprovider" ]; then
    export CORE_PEER_LOCALMSPID="CarServiceProviderMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_carserviceprovider_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/users/Admin@carserviceprovider.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:9451
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_carserviceprovider_CA
    export CORE_PEER_ADDRESS=localhost:9551
  elif [ $USING_ORG == "insuranceprovider" ]; then
    export CORE_PEER_LOCALMSPID="InsuranceProviderMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_insuranceprovider_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/users/Admin@insuranceprovider.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:9651
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_insuranceprovider_CA
    export CORE_PEER_ADDRESS=localhost:9751
  elif [ $USING_ORG == "scrapmerchant" ]; then
    export CORE_PEER_LOCALMSPID="ScrapMerchantMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_scrapmerchant_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/users/Admin@scrapmerchant.automobile-lifecycle.com/msp
    export CORE_PEER_ADDRESS=localhost:9851
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_scrapmerchant_CA
    export CORE_PEER_ADDRESS=localhost:9951 
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG == "manufacturer" ]; then
    export CORE_PEER_ADDRESS=peer0.manufacturer.automobile-lifecycle.com:7051
    export CORE_PEER_ADDRESS=peer1.manufacturer.automobile-lifecycle.com:7151
  elif [ $USING_ORG == "dealer" ]; then
    export CORE_PEER_ADDRESS=peer0.dealer.automobile-lifecycle.com:9051
    export CORE_PEER_ADDRESS=peer1.dealer.automobile-lifecycle.com:9151
  elif [ $USING_ORG == "regulator" ]; then
    export CORE_PEER_ADDRESS=peer0.regulator.automobile-lifecycle.com:13051
    export CORE_PEER_ADDRESS=peer1.regulator.automobile-lifecycle.com:13151
  elif [ $USING_ORG == "vehicleowner" ]; then
    export CORE_PEER_ADDRESS=peer0.vehicleowner.automobile-lifecycle.com:9251
    export CORE_PEER_ADDRESS=peer1.vehicleowner.automobile-lifecycle.com:9351
  elif [ $USING_ORG == "carserviceprovider" ]; then
    export CORE_PEER_ADDRESS=peer0.carserviceprovider.automobile-lifecycle.com:9451
    export CORE_PEER_ADDRESS=peer1.carserviceprovider.automobile-lifecycle.com:9551
  elif [ $USING_ORG == "insuranceprovider" ]; then
    export CORE_PEER_ADDRESS=peer0.insuranceprovider.automobile-lifecycle.com:9651
    export CORE_PEER_ADDRESS=peer1.insuranceprovider.automobile-lifecycle.com:9751
  elif [ $USING_ORG == "scrapmerchant" ]; then
    export CORE_PEER_ADDRESS=peer0.scrapmerchant.automobile-lifecycle.com:9851
    export CORE_PEER_ADDRESS=peer1.scrapmerchant.automobile-lifecycle.com:9951

  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}