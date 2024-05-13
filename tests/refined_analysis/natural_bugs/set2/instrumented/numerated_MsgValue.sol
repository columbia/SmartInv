1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {ETH} from './ETH.sol';
5 import {SafeCast} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/SafeCast.sol';
6 
7 library MsgValue {
8     using SafeCast for uint256;
9 
10     function getUint112() internal returns (uint112 value) {
11         value = msg.value.truncateUint112();
12         unchecked {
13             if (msg.value > value) ETH.transfer(payable(msg.sender), msg.value - value);
14         }
15     }
16 }
