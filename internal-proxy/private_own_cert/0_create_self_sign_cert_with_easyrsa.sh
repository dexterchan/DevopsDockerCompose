#!/bin/bash

root_domain=$1
mkdir -p cert
CURPATH=$(pwd)

#export EASYRSA_REQ_CN=$root_domain

rm -Rf easy-rsa
git clone https://github.com/OpenVPN/easy-rsa.git
pushd easy-rsa/easyrsa3
./easyrsa init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch build-server-full ${root_domain} nopass


cp pki/ca.crt ${CURPATH}/cert/ca.crt
cp pki/issued/${root_domain}.crt ${CURPATH}/cert/${root_domain}.crt
cp pki/private/${root_domain}.key ${CURPATH}/cert/${root_domain}.key


popd
