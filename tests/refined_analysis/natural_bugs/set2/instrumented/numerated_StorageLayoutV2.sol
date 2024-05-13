1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "./StorageLayoutV1.sol";
6 
7 contract StorageLayoutV2 is StorageLayoutV1 {
8     // Contract that manages the treasury and reserves
9     address internal treasuryManagerContract;
10 
11     // Reserve buffers per currency, used in the TreasuryAction contract
12     mapping(uint256 => uint256) internal reserveBuffer;
13 
14     // Pending owner used in the transfer ownership / claim ownership pattern
15     address internal pendingOwner;
16 }
