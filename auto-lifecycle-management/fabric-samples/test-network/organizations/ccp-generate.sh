#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$6/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$6/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=manufacturer
P0PORT=7051
P1PORT=7151
CAPORT=7054
PEERPEM=organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/tlsca/tlsca.manufacturer.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/ca/ca.manufacturer.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/connection-manufacturer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/connection-manufacturer.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/connection-manufacturer.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.automobile-lifecycle.com/connection-manufacturer.yaml


ORG=dealer
P0PORT=9051
P1PORT=9151
CAPORT=8054
PEERPEM=organizations/peerOrganizations/dealer.automobile-lifecycle.com/tlsca/tlsca.dealer.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/dealer.automobile-lifecycle.com/ca/ca.dealer.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/dealer.automobile-lifecycle.com/connection-dealer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/dealer.automobile-lifecycle.com/connection-dealer.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/dealer.automobile-lifecycle.com/connection-dealer.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/dealer.automobile-lifecycle.com/connection-dealer.yaml


ORG=regulator
P0PORT=13051
P1PORT=13151
CAPORT=9054
PEERPEM=organizations/peerOrganizations/regulator.automobile-lifecycle.com/tlsca/tlsca.regulator.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/regulator.automobile-lifecycle.com/ca/ca.regulator.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.automobile-lifecycle.com/connection-regulator.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.automobile-lifecycle.com/connection-regulator.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.automobile-lifecycle.com/connection-regulator.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.automobile-lifecycle.com/connection-regulator.yaml


ORG=vehicleowner
P0PORT=9251
P1PORT=9351
CAPORT=8070
PEERPEM=organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/tlsca/tlsca.vehicleowner.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/ca/ca.vehicleowner.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/connection-vehicleowner.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/connection-vehicleowner.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/connection-vehicleowner.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/vehicleowner.automobile-lifecycle.com/connection-vehicleowner.yaml

ORG=carserviceprovider
P0PORT=9451
P1PORT=9551
CAPORT=9070
PEERPEM=organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/tlsca/tlsca.carserviceprovider.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/ca/ca.carserviceprovider.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/connection-carserviceprovider.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/connection-carserviceprovider.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/connection-carserviceprovider.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/carserviceprovider.automobile-lifecycle.com/connection-carserviceprovider.yaml

ORG=insuranceprovider
P0PORT=9651
P1PORT=9751
CAPORT=9170
PEERPEM=organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/tlsca/tlsca.insuranceprovider.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/ca/ca.insuranceprovider.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/connection-insuranceprovider.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/insurnaceprovider.automobile-lifecycle.com/connection-insuranceprovider.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/connection-insuranceprovider.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/insuranceprovider.automobile-lifecycle.com/connection-insuranceprovider.yaml

ORG=scrapmerchant
P0PORT=9851
P1PORT=9951
CAPORT=9270
PEERPEM=organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/tlsca/tlsca.scrapmerchant.automobile-lifecycle.com-cert.pem
CAPEM=organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/ca/ca.scrapmerchant.automobile-lifecycle.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/connection-scrapmerchant.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/connection-scrapmerchant.yaml
echo "$(json_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/connection-scrapmerchant.json
echo "$(yaml_ccp $ORG $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/scrapmerchant.automobile-lifecycle.com/connection-scrapmerchant.yaml

