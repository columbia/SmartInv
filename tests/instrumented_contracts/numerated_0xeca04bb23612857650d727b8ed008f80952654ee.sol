1 pragma solidity 0.4.18;
2 
3 // File: contracts/wrapperContracts/KyberRegisterWallet.sol
4 
5 interface BurnerWrapperProxy {
6     function registerWallet(address wallet) public;
7 }
8 
9 
10 contract KyberRegisterWallet {
11 
12     BurnerWrapperProxy public feeBurnerWrapperProxyContract;
13 
14     function KyberRegisterWallet(BurnerWrapperProxy feeBurnerWrapperProxy) public {
15         require(feeBurnerWrapperProxy != address(0));
16 
17         feeBurnerWrapperProxyContract = feeBurnerWrapperProxy;
18     }
19 
20     function registerWallet(address wallet) public {
21         feeBurnerWrapperProxyContract.registerWallet(wallet);
22     }
23 }