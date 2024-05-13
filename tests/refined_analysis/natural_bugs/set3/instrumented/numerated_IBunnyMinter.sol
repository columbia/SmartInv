1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IBunnyMinter {
5     function isMinter(address) view external returns(bool);
6     function amountBunnyToMint(uint bnbProfit) view external returns(uint);
7     function amountBunnyToMintForBunnyBNB(uint amount, uint duration) view external returns(uint);
8     function withdrawalFee(uint amount, uint depositedAt) view external returns(uint);
9     function performanceFee(uint profit) view external returns(uint);
10     function mintFor(address flip, uint _withdrawalFee, uint _performanceFee, address to, uint depositedAt) external;
11     function mintForBunnyBNB(uint amount, uint duration, address to) external;
12 
13     function bunnyPerProfitBNB() view external returns(uint);
14     function WITHDRAWAL_FEE_FREE_PERIOD() view external returns(uint);
15     function WITHDRAWAL_FEE() view external returns(uint);
16 
17     function setMinter(address minter, bool canMint) external;
18 }
