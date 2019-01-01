#!/usr/bin/env bash

DAO='0x9787eC88D04074A915648Ae2daaB02d34D72B208'
RinkebyDAO='0xBF6879f5f9AdD7D36b5c5B4f63E59fd4E32A6A1c'

#althea.open.aragonpm.eth
altheaIdRin='33ec2d92fc47b5383901b8a3856d208d3a66104fa46c4a06f3f97536e9b6fc5b'
# use this one for devchain
altheaIdDev='6f154f8fd38a0dcc9fbfbb13f3a54845bbea75a4cfffa70a64c93579e1d257a7'

CORE_NAMESPACE='c681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8'
APP_BASES_NAMESPACE='f1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f'
APP_ADDR_NAMESPACE='d6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb'
# finance.aragonpm.eth
financeId='bf8491150dafc5dcaee5b861414dca922de09ccffa344964ae167212e8c673ae'
vaultId='7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1'

getApp='be00bbd8'
getVault='32f0a3b5'
getInitializationBlock='8b3dd749'
setApp='2ec1ae0a449b7ae354b9dacfb3ade6b6332ba26b7fcbb935835fa39dd7263b23'
# seth keccak 'NewAppProxy(address,bool,bytes32)'
newAppProxy='d880e726dced8808d727f02dd0e6fdd3a945b24bfee77e13367bcbe61ddbaf47'

function getBlock() {
  cat << EOF
{
  "jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1
}
EOF
}


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

function getFilter() {
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

url='https://sasquatch.network/rinkeby'
echo Rinkeby
blockNumber=$(curl --silent \
 -H "Accept: application/json" \
 -H "Content-Type:application/json" \
 -X POST --data "$(startBlock)" $url | jq '.result')

# removes quotes and 0x
blockNumber=$(echo $blockNumber | sed 's|0x||; s|"||g' | tail -c 7)
echo blockNumber $blockNumber

data=$(getFilter $blockNumber)
echo
events=$(curl --silent \
 -H "Accept: application/json" \
 -H "Content-Type:application/json" \
 -X POST --data "$data" $url | jq '.result' )

lastInstalled=$(echo $events | jq '.[-1].data' | sed 's|0x||; s|"||g')
#event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);

echo address:
echo ${lastInstalled:0:64}
echo
echo isUpgradeable:
echo ${lastInstalled:64:64}
echo
echo appId:
echo ${lastInstalled:128:64}
