#!/bin/bash

function createManufacturer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-manufacturer --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the manufacturer admin"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/msp --csr.hosts peer0.manufacturer.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/msp --csr.hosts peer1.manufacturer.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer0.manufacturer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/tlsca/tlsca.manufacturer.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer0.manufacturer.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/ca/ca.manufacturer.automobile-lifecycle.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer1.manufacturer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/tlsca/tlsca.manufacturer.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/peers/peer1.manufacturer.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/ca/ca.manufacturer.automobile-lifecycle.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/users/User1@manufacturer.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/users/User1@manufacturer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the manufacturer admin msp"
  set -x
  fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/users/Admin@manufacturer.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/users/Admin@manufacturer.automobile-lifecycle.com/msp/config.yaml
}

function createDealer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/dealer.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-dealer --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the dealer admin"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name dealeradmin --id.secret dealeradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/msp --csr.hosts peer0.dealer.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/msp --csr.hosts peer1.dealer.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer0.dealer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/tlsca/tlsca.dealer.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer0.dealer.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/ca/ca.dealer.automobile-lifecycle.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer1.dealer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/tlsca/tlsca.dealer.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/peers/peer1.dealer.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/ca/ca.dealer.automobile-lifecycle.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/users/User1@dealer.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/users/User1@dealer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the dealer admin msp"
  set -x
  fabric-ca-client enroll -u https://dealeradmin:dealeradminpw@localhost:8054 --caname ca-dealer -M ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/users/Admin@dealer.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/dealer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dealer.automobile-lifecycle.com/users/Admin@dealer.automobile-lifecycle.com/msp/config.yaml
}

function createRegulator() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/regulator.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2054 --caname ca-regulator --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-regulator.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-regulator.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-regulator.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-regulator.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the regulator admin"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name regulatoradmin --id.secret regulatoradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/msp --csr.hosts peer0.regulator.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/msp --csr.hosts peer1.regulator.automobile-lifecycle.com --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer0.regulator.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/tlsca/tlsca.regulator.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer0.regulator.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/ca/ca.regulator.automobile-lifecycle.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts peer1.regulator.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/tlsca/tlsca.regulator.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/ca
  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/peers/peer1.regulator.automobile-lifecycle.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/ca/ca.regulator.automobile-lifecycle.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/users/User1@regulator.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/users/User1@regulator.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the regulator admin msp"
  set -x
  fabric-ca-client enroll -u https://regulatoradmin:regulatoradminpw@localhost:2054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/users/Admin@regulator.automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/regulator/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/regulator.automobile-lifecycle.com/users/Admin@regulator.automobile-lifecycle.com/msp/config.yaml
}

function createVehicleOwner() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-vehicleowner --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-vehicleowner.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-vehicleowner.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-vehicleowner.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-vehicleowner.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy vehicleowner's CA cert to vehicleowner's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/tlscacerts/ca.crt"

  # Copy vehicleowner's CA cert to vehicleowner's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/tlsca/tlsca.vehicleowner.automobile-lifecycle.com-cert.pem"

  # Copy vehicleowner's CA cert to vehicleowner's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/ca"
  cp "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/ca/ca.vehicleowner.automobile-lifecycle.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-vehicleowner --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-vehicleowner --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-vehicleowner --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the vehicleowner admin"
  set -x
  fabric-ca-client register --caname ca-vehicleowner --id.name vehicleowneradmin --id.secret vehicleowneradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/msp" --csr.hosts peer0.vehicleowner.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/msp" --csr.hosts peer1.vehicleowner.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer0.vehicleowner.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer0.vehicleowner.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer1.vehicleowner.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/peers/peer1.vehicleowner.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/users/User1@vehicleowner.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/users/User1@vehicleowner.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the vehicleowner admin msp"
  set -x
  fabric-ca-client enroll -u https://vehicleowneradmin:vehicleowneradminpw@localhost:6054 --caname ca-vehicleowner -M "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/users/Admin@vehicleowner.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/vehicleowner/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/users/Admin@vehicleowner.automobile-lifecycle.com/msp/config.yaml"
}

function createCarServiceProvider() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:5054 --caname ca-carserviceprovider --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-carserviceprovider.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-carserviceprovider.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-carserviceprovider.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-carserviceprovider.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy carserviceprovider's CA cert to carserviceprovider's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/tlscacerts/ca.crt"

  # Copy carserviceprovider's CA cert to carserviceprovider's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/tlsca/tlsca.carserviceprovider.automobile-lifecycle.com-cert.pem"

  # Copy carserviceprovider's CA cert to carserviceprovider's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/ca"
  cp "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/ca/ca.carserviceprovider.automobile-lifecycle.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-carserviceprovider --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-carserviceprovider --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-carserviceprovider --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the carserviceprovider admin"
  set -x
  fabric-ca-client register --caname ca-carserviceprovider --id.name carserviceprovideradmin --id.secret carserviceprovideradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/msp" --csr.hosts peer0.carserviceprovider.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/msp" --csr.hosts peer1.carserviceprovider.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer0.carserviceprovider.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer0.carserviceprovider.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer1.carserviceprovider.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/peers/peer1.carserviceprovider.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/users/User1@carserviceprovider.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/users/User1@carserviceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the carserviceprovider admin msp"
  set -x
  fabric-ca-client enroll -u https://carserviceprovideradmin:carserviceprovideradminpw@localhost:5054 --caname ca-carserviceprovider -M "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/users/Admin@carserviceprovider.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/carserviceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/users/Admin@carserviceprovider.automobile-lifecycle.com/msp/config.yaml"
}

function createInsuranceProvider() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:4054 --caname ca-insuranceprovider --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-4054-ca-insuranceprovider.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-4054-ca-insuranceprovider.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-4054-ca-insuranceprovider.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-4054-ca-insuranceprovider.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy insuranceprovider's CA cert to insuranceprovider's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/tlscacerts/ca.crt"

  # Copy insuranceprovider's CA cert to insuranceprovider's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/tlsca/tlsca.insuranceprovider.automobile-lifecycle.com-cert.pem"

  # Copy insuranceprovider's CA cert to insuranceprovider's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/ca"
  cp "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/ca/ca.insuranceprovider.automobile-lifecycle.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-insuranceprovider --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-insuranceprovider --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-insuranceprovider --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the insuranceprovider admin"
  set -x
  fabric-ca-client register --caname ca-insuranceprovider --id.name insuranceprovideradmin --id.secret insuranceprovideradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/msp" --csr.hosts peer0.insuranceprovider.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/msp" --csr.hosts peer1.insuranceprovider.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer0.insuranceprovider.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer0.insuranceprovider.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer1.insuranceprovider.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/peers/peer1.insuranceprovider.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/users/User1@insuranceprovider.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/users/User1@insuranceprovider.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the insuranceprovider admin msp"
  set -x
  fabric-ca-client enroll -u https://insuranceprovideradmin:insuranceprovideradminpw@localhost:4054 --caname ca-insuranceprovider -M "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/users/Admin@insuranceprovider.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/insuranceprovider/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/users/Admin@insuranceprovider.automobile-lifecycle.com/msp/config.yaml"
}

function createScrapMerchant() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:3054 --caname ca-scrapmerchant --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-3054-ca-scrapmerchant.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-3054-ca-scrapmerchant.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-3054-ca-scrapmerchant.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-3054-ca-scrapmerchant.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy scrapmerchant's CA cert to scrapmerchant's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/tlscacerts/ca.crt"

  # Copy scrapmerchant's CA cert to scrapmerchant's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/tlsca/tlsca.scrapmerchant.automobile-lifecycle.com-cert.pem"

  # Copy scrapmerchant's CA cert to scrapmerchant's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/ca"
  cp "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/ca/ca.scrapmerchant.automobile-lifecycle.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-scrapmerchant --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-scrapmerchant --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-scrapmerchant --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the scrapmerchant admin"
  set -x
  fabric-ca-client register --caname ca-scrapmerchant --id.name scrapmerchantadmin --id.secret scrapmerchantadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/msp" --csr.hosts peer0.scrapmerchant.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/msp" --csr.hosts peer1.scrapmerchant.automobile-lifecycle.com --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer0.scrapmerchant.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer0.scrapmerchant.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls" --enrollment.profile tls --csr.hosts peer1.scrapmerchant.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/peers/peer1.scrapmerchant.automobile-lifecycle.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/users/User1@scrapmerchant.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/users/User1@scrapmerchant.automobile-lifecycle.com/msp/config.yaml"

  infoln "Generating the scrapmerchant admin msp"
  set -x
  fabric-ca-client enroll -u https://scrapmerchantadmin:scrapmerchantadminpw@localhost:3054 --caname ca-scrapmerchant -M "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/users/Admin@scrapmerchant.automobile-lifecycle.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/scrapmerchant/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/users/Admin@scrapmerchant.automobile-lifecycle.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/automobile-lifecycle.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/msp --csr.hosts orderer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls --enrollment.profile tls --csr.hosts orderer.automobile-lifecycle.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/msp/tlscacerts/tlsca.automobile-lifecycle.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/orderers/orderer.automobile-lifecycle.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/msp/tlscacerts/tlsca.automobile-lifecycle.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/users/Admin@automobile-lifecycle.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/automobile-lifecycle.com/users/Admin@automobile-lifecycle.com/msp/config.yaml
}
