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
11 
12 interface IMinimumOracle {
13     function getPrice() external view returns (uint256);
14 
15     function setPrice(uint256 newPrice) external;
16 
17     function transferOwnership(address newOwner) external;
18 }
19 
20 
21 contract MinimumOracle {
22     address public _OWNER_;
23     uint256 public tokenPrice;
24 
25     // ============ Events ============
26 
27     event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
28 
29     // ============ Modifiers ============
30 
31     modifier onlyOwner() {
32         require(msg.sender == _OWNER_, "NOT_OWNER");
33         _;
34     }
35 
36     // ============ Functions ============
37 
38     constructor() public {
39         _OWNER_ = msg.sender;
40         emit OwnershipTransfer(address(0), _OWNER_);
41     }
42 
43     function transferOwnership(address newOwner) external onlyOwner {
44         require(newOwner != address(0), "INVALID_OWNER");
45         emit OwnershipTransfer(_OWNER_, newOwner);
46         _OWNER_ = newOwner;
47     }
48 
49     function setPrice(uint256 newPrice) external onlyOwner {
50         tokenPrice = newPrice;
51     }
52 
53     function getPrice() external view returns (uint256) {
54         return tokenPrice;
55     }
56 }
