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
11 import {Ownable} from "../lib/Ownable.sol";
12 import {SafeERC20} from "../lib/SafeERC20.sol";
13 import {IERC20} from "../intf/IERC20.sol";
14 
15 
16 interface IDODORewardVault {
17     function reward(address to, uint256 amount) external;
18 }
19 
20 
21 contract DODORewardVault is Ownable {
22     using SafeERC20 for IERC20;
23 
24     address public dodoToken;
25 
26     constructor(address _dodoToken) public {
27         dodoToken = _dodoToken;
28     }
29 
30     function reward(address to, uint256 amount) external onlyOwner {
31         IERC20(dodoToken).safeTransfer(to, amount);
32     }
33 }
