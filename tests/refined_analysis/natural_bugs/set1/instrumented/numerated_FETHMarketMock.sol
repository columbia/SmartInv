1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "../interfaces/IFethMarket.sol";
6 
7 contract FETHMarketMock {
8   IFethMarket public feth;
9 
10   receive() external payable {
11     require(msg.sender == address(feth), "Only receive from FETH");
12   }
13 
14   function setFeth(address _feth) public {
15     feth = IFethMarket(_feth);
16   }
17 
18   function marketLockupFor(address account, uint256 amount) public payable {
19     feth.marketLockupFor{ value: msg.value }(account, amount);
20   }
21 
22   function marketWithdrawLocked(
23     address account,
24     uint256 expiration,
25     uint256 amount
26   ) public {
27     feth.marketWithdrawLocked(account, expiration, amount);
28   }
29 
30   function marketWithdrawFrom(address account, uint256 amount) public {
31     feth.marketWithdrawFrom(account, amount);
32   }
33 
34   function marketUnlockFor(
35     address account,
36     uint256 expiration,
37     uint256 amount
38   ) public {
39     feth.marketUnlockFor(account, expiration, amount);
40   }
41 
42   function marketChangeLockup(
43     address unlockFrom,
44     uint256 unlockExpiration,
45     uint256 unlockAmount,
46     address depositFor,
47     uint256 depositAmount
48   ) external payable {
49     feth.marketChangeLockup{ value: msg.value }(unlockFrom, unlockExpiration, unlockAmount, depositFor, depositAmount);
50   }
51 }
