1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @notice Interface for functions the market uses in FETH.
7  */
8 interface IFethMarket {
9   function marketLockupFor(address account, uint256 amount) external payable returns (uint256 expiration);
10 
11   function marketWithdrawFrom(address from, uint256 amount) external;
12 
13   function marketWithdrawLocked(
14     address account,
15     uint256 expiration,
16     uint256 amount
17   ) external;
18 
19   function marketUnlockFor(
20     address account,
21     uint256 expiration,
22     uint256 amount
23   ) external;
24 
25   function marketChangeLockup(
26     address unlockFrom,
27     uint256 unlockExpiration,
28     uint256 unlockAmount,
29     address depositFor,
30     uint256 depositAmount
31   ) external payable returns (uint256 expiration);
32 }
