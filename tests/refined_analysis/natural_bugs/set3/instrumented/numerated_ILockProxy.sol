1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.5.0;
3 
4 interface ILockProxy {
5     function managerProxyContract() external view returns (address);
6     function proxyHashMap(uint64) external view returns (bytes memory);
7     function assetHashMap(address, uint64) external view returns (bytes memory);
8     function getBalanceFor(address) external view returns (uint256);
9     function setManagerProxy(
10         address eccmpAddr
11     ) external;
12     
13     function bindProxyHash(
14         uint64 toChainId, 
15         bytes calldata targetProxyHash
16     ) external returns (bool);
17 
18     function bindAssetHash(
19         address fromAssetHash, 
20         uint64 toChainId, 
21         bytes calldata toAssetHash
22     ) external returns (bool);
23 
24     function lock(
25         address fromAssetHash, 
26         uint64 toChainId, 
27         bytes calldata toAddress, 
28         uint256 amount
29     ) external payable returns (bool);
30 }