let abi = require('./KernelAbi.json')


for (var i in abi) {
  console.log(abi[i].name, ' ' , abi[i].inputs)
}
