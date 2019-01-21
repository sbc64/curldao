#!/usr/bin/env bash

function getBlock() {
  cat << EOF
{
  "jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":2
}
EOF
}


AltheaRinkeby='0x97895FDBdEFdB4F68985d000D421573446d87892'

getMember='376679b0'
getCountOfSubscribers='3b8bd013'
perBlockFee='50e34717'
billMapping='6bcbf58a'
subnetSubscribers='ad8073e3'
useMapping='a41557c6'
payMyBills='7f0dc238'
withdrawFromBill='ef5001fe'

function getCountOfSubscribers() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$AltheaRinkeby",
    "data": "0x$getCountOfSubscribers"
  },
  "latest"],
  "id":2
}
EOF
}

function getPerBlockFee() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$AltheaRinkeby",
    "data": "0x$perBlockFee"
  },
  "latest"],
  "id":2
}
EOF
}

function getSubscriber() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$AltheaRinkeby",
    "data": "0x$subnetSubscribers0000000000000000000000000000000000000000000000000000000000000001"
  },
  "latest"],
  "id":2
}
EOF
}

# This gets the etherum address from an ipv6 address
function getMember() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$AltheaRinkeby",
    "data": "0x$getMember$1"
  },
  "latest"],
  "id":2
}
EOF
}


# URL of the RPC endpoint
url='https://sasquatch.network/rinkeby'
echo RINKEBY

curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(getBlock)" $url | jq '.result'

echo Count of Subscribers
curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(getCountOfSubscribers)" $url | jq '.result'

echo Get Subscriber
curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(getSubscriber)" $url

echo Get Member 
curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(getMember deadbeef)" $url | jq '.result'
