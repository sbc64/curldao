#!/usr/bin/env bash

RinkebyDAO='0xBF6879f5f9AdD7D36b5c5B4f63E59fd4E32A6A1c'
getInitializationBlock='8b3dd749'
# seth keccak 'NewAppProxy(address,bool,bytes32)'
newAppProxy='d880e726dced8808d727f02dd0e6fdd3a945b24bfee77e13367bcbe61ddbaf47'
#althea.open.aragonpm.eth
altheaIdRin='33ec2d92fc47b5383901b8a3856d208d3a66104fa46c4a06f3f97536e9b6fc5b'

function startBlock() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$RinkebyDAO",
    "data": "0x$getInitializationBlock"
  },
  "latest"
  ],
  "id":2
}
EOF
}

function getLogs() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_getLogs",
  "params":[{
    "fromBlock": "0x$1",
    "address": "$RinkebyDAO",
    "topics": ["0x$newAppProxy"]
  }],
  "id":2
}
EOF
}

# URL of the RPC endpoint
url='https://sasquatch.network/rinkeby'
echo Rinkeby
# This obtains the block number the DAO was created
blockNumber=$(curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(startBlock)" $url | jq '.result')

blockNumber=${blockNumber:61:6}
echo blockNumber $blockNumber
echo

# This curl obtains all of the logs that match the filter
events=$(curl --silent \
 -H "Content-Type:application/json" \
 -X POST --data "$(getLogs $blockNumber)" $url | jq '.result' )

# This obtains the data of the last log
lastEvent=$(echo $events | jq '.[-1].data' | sed 's|0x||; s|"||g')

# Event signature:
#event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
echo address:
echo ${lastEvent:0:64}
echo
echo isUpgradeable:
echo ${lastEvent:64:64}
echo
echo appId:
echo ${lastEvent:128:64}
