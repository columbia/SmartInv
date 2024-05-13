1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract MockStETH {
5   bool shouldRevert = false;
6   uint256 pooledEthByShares;
7   uint256 sharesByPooledEth;
8 
9   function mockSetRevert(bool _shouldRevert) external {
10     shouldRevert = _shouldRevert;
11   }
12 
13   function mockSetData(uint256 _pooledEthByShares, uint256 _sharesByPooledEth) external {
14     pooledEthByShares = _pooledEthByShares;
15     sharesByPooledEth = _sharesByPooledEth;
16   }
17 
18   function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256) {
19     if (shouldRevert) revert("");
20     _sharesAmount = _sharesAmount;
21     return pooledEthByShares;
22   }
23 
24   function getSharesByPooledEth(uint256 _pooledEthAmount) external view returns (uint256) {
25     if (shouldRevert) revert("");
26     _pooledEthAmount = _pooledEthAmount;
27     return sharesByPooledEth;
28   }
29 }
