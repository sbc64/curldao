# Difference in the Althea app instalation between:

 * Solidity DAO kit script
 * aragon/cli install

### DAO kit script

The dao kit is a smart contract that atomically creates a dao by calling a sequential number of functions.

Usually it starts by creating an Kernel.sol proxy. Then it creates different app proxies by referencing the namehash of the app (appId). For aragon apps it is `vault.aragonpm.eth` and for althea it will be `althea.open.aragonpm.eth`:

```
Althea althea = Althea(
    dao.newAppInstance(altheaId, latestVersionAppBase(altheaId), new bytes(0), true)
);
```
https://github.com/aragon/aragonOS/blob/dev/contracts/kernel/Kernel.sol#L83

The last parameter changes the flow of code by setting it as a default app. It takes it to this line:

https://github.com/aragon/aragonOS/blob/dev/contracts/kernel/Kernel.sol#L216

The `_setAppIfNew()` function gets called and all it does is save the base app to the `KERNEL_APP_ADDR_NAMESPACE`. But only if the base app doesn't exist in that namespace. This allows one to later call `getApp()` with the kernel namespace bytes32 and the altheaId, `namehash('alhtea.open.aragonpm.eth)`. During this setup the event `NewAppProxy` gets emited, BUT the address of the proxy contract is not the same as the address that gets saved into the [mapping](https://github.com/aragon/aragonOS/blob/dev/contracts/kernel/Kernel.sol#L88-L89). The address that gets saved into that namespace is the base contract address, not the proxy address which is used by the front end app.

After the proxies are created the next steps of the DAO kit is to call the `initialize()` function of the apps and then later set the different permissions in the kernel `ACL`.

### CLI installation.

The cli calls `newAppInstance` function on the DAO (wich is a Kernel.sol contract): https://github.com/aragon/aragon-cli/blob/master/src/commands/dao_cmds/install.js#L141. 

One can see a few lines above that it is passing `false` for the last parameter. So this line: https://github.com/aragon/aragonOS/blob/dev/contracts/kernel/Kernel.sol#L92

The `_setAppIfNew()` function gets called and all it does is save the base app to the `KERNEL_APP_ADDR_NAMESPACE`. But only if the base app doesn't exist in that namespace.

is false and the app doesn't get installed in the `KERNEL_APP_ADDR_NAMESPACE`. The event `NewAppProxy` gets emitted but it is never saved into the `apps` hashmap of the kernel. The same flow mentioned earlier

### Conclusion

On both cases the `_setAppIfNew()` function gets called and all it does is save the base app to the `KERNEL_APP_ADDR_NAMESPACE`. But only if the base app doesn't exist. This saves the base app into the hasmap. The only way to obtain the current proxy app is checking the `NewAppProxy` logs, since the app proxy DOES NOT get saved into the `apps` namespace

According to Jorge about setting default apps:
```
this is useful when you want a certain app instance fetchable from other apps (smart contract level) in the DAO
we use it for the ACL, the EVMScriptExecutorRegistry and the Vault that gets used as a escape hatch in case assets are sent to apps that don't know how to manage them
we don't recommend using it for anything else, for example the Finance app depends on a Vault but we have a explicit dependency via a state variable (instead of using the default Vault)
there is a brief explanation here: https://hack.aragon.org/docs/aragonos-ref.html#namespaces 
```