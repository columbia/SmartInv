1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
5 
6 
7 interface IVToken is IBEP20 {
8     function underlying() external returns (address);
9 
10     function mint(uint mintAmount) external returns (uint);
11     function redeem(uint redeemTokens) external returns (uint);
12     function redeemUnderlying(uint redeemAmount) external returns (uint);
13     function borrow(uint borrowAmount) external returns (uint);
14     function repayBorrow(uint repayAmount) external returns (uint);
15 
16     function balanceOfUnderlying(address owner) external returns (uint);
17     function borrowBalanceCurrent(address account) external returns (uint);
18     function totalBorrowsCurrent() external returns (uint);
19 
20     function exchangeRateCurrent() external returns (uint);
21     function exchangeRateStored() external view returns (uint);
22 
23     function supplyRatePerBlock() external view returns (uint);
24     function borrowRatePerBlock() external view returns (uint);
25 }
