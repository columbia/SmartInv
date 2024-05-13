1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 
5 interface IVBNB {
6     function totalSupply() external view returns (uint);
7 
8     function mint() external payable;
9     function redeem(uint redeemTokens) external returns (uint);
10     function redeemUnderlying(uint redeemAmount) external returns (uint);
11     function borrow(uint borrowAmount) external returns (uint);
12     function repayBorrow() external payable;
13 
14     function balanceOfUnderlying(address owner) external returns (uint);
15     function borrowBalanceCurrent(address account) external returns (uint);
16     function totalBorrowsCurrent() external returns (uint);
17 
18     function exchangeRateCurrent() external returns (uint);
19     function exchangeRateStored() external view returns (uint);
20 
21     function supplyRatePerBlock() external view returns (uint);
22     function borrowRatePerBlock() external view returns (uint);
23 }
