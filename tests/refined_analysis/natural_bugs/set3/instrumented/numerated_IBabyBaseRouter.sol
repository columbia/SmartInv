1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 interface IBabyBaseRouter {
6 
7     function factory() external view returns (address);
8     function WETH() external view returns (address);
9     function swapMining() external view returns (address);
10     function routerFeeReceiver() external view returns(address);
11 
12 }
