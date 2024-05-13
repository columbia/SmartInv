1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IVenusDistribution {
5     function oracle() external view returns (address);
6 
7     function enterMarkets(address[] memory _vtokens) external;
8     function exitMarket(address _vtoken) external;
9     function getAssetsIn(address account) external view returns (address[] memory);
10 
11     function markets(address vTokenAddress) external view returns (bool, uint, bool);
12     function getAccountLiquidity(address account) external view returns (uint, uint, uint);
13 
14     function claimVenus(address holder, address[] memory vTokens) external;
15     function venusSpeeds(address) external view returns (uint);
16 }
