1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity ^0.7.0;
3 pragma abicoder v2;
4 
5 import "./global/StorageLayoutV1.sol";
6 
7 abstract contract ActionGuards is StorageLayoutV1 {
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     modifier nonReentrant() {
12         // On the first call to nonReentrant, _notEntered will be true
13         require(reentrancyStatus != _ENTERED, "Reentrant call");
14 
15         // Any calls to nonReentrant after this point will fail
16         reentrancyStatus = _ENTERED;
17 
18         _;
19 
20         // By storing the original value once again, a refund is triggered (see
21         // https://eips.ethereum.org/EIPS/eip-2200)
22         reentrancyStatus = _NOT_ENTERED;
23     }
24 }