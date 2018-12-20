#!/usr/bin/env bash


endPoint='http://localhost:8545'
DAO='0x00741602bB70270772D5Dc9D0Bd3Af29D1b78e9f'
RinkebyDAO='0xdc98315ea5d929f17929a2f7adab3b26eeb1b2c9'
from='0xb4124ceb3451635dacedd11767f004d8a28c6ee7'

#althea.open.aragonpm.eth
altheaId='33ec2d92fc47b5383901b8a3856d208d3a66104fa46c4a06f3f97536e9b6fc5b'
# use this one for devchain
#altheaId='6f154f8fd38a0dcc9fbfbb13f3a54845bbea75a4cfffa70a64c93579e1d257a7'
CORE_NAMESPACE='c681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8'
APP_BASES_NAMESPACE='f1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f'
APP_ADDR_NAMESPACE='d6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb'
# finance.aragonpm.eth
financeId='bf8491150dafc5dcaee5b861414dca922de09ccffa344964ae167212e8c673ae'
vaultId='7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1'

getApp='be00bbd8'
getVault='32f0a3b5'

function getBlock() {
  cat << EOF
{
  "jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1
}
EOF
}

#"data": "0x$getApp$APP_BASES_NAMESPACE$vaultId"
function altheaAddress() {
  cat << EOF
{
  "jsonrpc":"2.0",
  "method":"eth_call",
  "params":[{
    "to": "$DAO",
    "data": "0x$getApp$APP_ADDR_NAMESPACE$financeId"
  },
  "latest"
  ],
  "id":2
}
EOF
}


#url='http://localhost:8545'
url='https://sasquatch.network/rinkeby'

echo -n "Block Number "
curl --silent -X POST --data "$(getBlock)" $endPoint | jq ".result"

altheaAddress
curl --silent \
  -H "Accept: application/json" \
 -H "Content-Type:application/json" \
 -X POST --data "$(altheaAddress)" $url
