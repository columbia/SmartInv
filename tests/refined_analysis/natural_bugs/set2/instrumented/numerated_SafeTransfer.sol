1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
6 import {SafeERC20} from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
7 
8 library SafeTransfer {
9     using SafeERC20 for IERC20;
10 
11     function safeTransfer(
12         IERC20 token,
13         IPair to,
14         uint256 amount
15     ) internal {
16         token.safeTransfer(address(to), amount);
17     }
18 
19     function safeTransferFrom(
20         IERC20 token,
21         address from,
22         IPair to,
23         uint256 amount
24     ) internal {
25         token.safeTransferFrom(from, address(to), amount);
26     }
27 }
