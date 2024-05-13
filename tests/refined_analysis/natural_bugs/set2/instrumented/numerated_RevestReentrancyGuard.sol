1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
6 
7 contract RevestReentrancyGuard is ReentrancyGuard {
8 
9     // Used to avoid reentrancy
10     uint private constant MAX_INT = 0xFFFFFFFFFFFFFFFF;
11     uint private currentId = MAX_INT;
12 
13     modifier revestNonReentrant(uint fnftId) {
14         // On the first call to nonReentrant, _notEntered will be true
15         require(fnftId != currentId, "E052");
16 
17         // Any calls to nonReentrant after this point will fail
18         currentId = fnftId;
19 
20         _;
21 
22         currentId = MAX_INT;
23     }
24 }
