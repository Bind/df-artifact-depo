#!/bin/bash
# This wasn't used for the live deploy

DF_CORE="0x5da117b8ab8b739346f5edc166789e5afb1a7145"
BLESSED=""
# before for real put your private key somewhere safe
forge create \
--rpc-url "http://161.35.57.217:8545/"  \
--constructor-args $DF_CORE $BLESSED \
--private-key $1 \
 Depo