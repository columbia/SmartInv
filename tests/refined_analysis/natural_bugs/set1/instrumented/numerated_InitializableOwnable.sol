1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 /**
12  * @title Ownable
13  * @author DODO Breeder
14  *
15  * @notice Ownership related functions
16  */
17 contract InitializableOwnable {
18     address public _OWNER_;
19     address public _NEW_OWNER_;
20 
21     // ============ Events ============
22 
23     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     // ============ Modifiers ============
28 
29     modifier onlyOwner() {
30         require(msg.sender == _OWNER_, "NOT_OWNER");
31         _;
32     }
33 
34     // ============ Functions ============
35 
36     function transferOwnership(address newOwner) external onlyOwner {
37         require(newOwner != address(0), "INVALID_OWNER");
38         emit OwnershipTransferPrepared(_OWNER_, newOwner);
39         _NEW_OWNER_ = newOwner;
40     }
41 
42     function claimOwnership() external {
43         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
44         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
45         _OWNER_ = _NEW_OWNER_;
46         _NEW_OWNER_ = address(0);
47     }
48 }
