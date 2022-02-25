#!/bin/bash

DEPO=0xd8c00a439ac617f51e1f8fb58fa7f7334be56f63
# probably have a more secure setup for your key if you're going to copy this
cast send --private-key $1 $DEPO "masterAtArms(address)" --rpc-url $RPC $2