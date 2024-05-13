1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IBunnyMinterV2 {
5     function isMinter(address) view external returns(bool);
6     function amountBunnyToMint(uint bnbProfit) view external returns(uint);
7     function amountBunnyToMintForBunnyBNB(uint amount, uint duration) view external returns(uint);
8     function withdrawalFee(uint amount, uint depositedAt) view external returns(uint);
9     function performanceFee(uint profit) view external returns(uint);
10     function mintFor(address flip, uint _withdrawalFee, uint _performanceFee, address to, uint depositedAt) external payable;
11     function mintForV2(address flip, uint _withdrawalFee, uint _performanceFee, address to, uint depositedAt) external payable;
12 
13     function WITHDRAWAL_FEE_FREE_PERIOD() view external returns(uint);
14     function WITHDRAWAL_FEE() view external returns(uint);
15 
16     function setMinter(address minter, bool canMint) external;
17 
18     // V2 functions
19     function mint(uint amount) external;
20     function safeBunnyTransfer(address to, uint256 amount) external;
21     function mintGov(uint amount) external;
22 }