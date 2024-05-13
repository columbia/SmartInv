1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 pragma experimental ABIEncoderV2;
4 
5 interface IDelegation{
6     function clearDelegate(bytes32 _id) external;
7     function setDelegate(bytes32 _id, address _delegate) external;
8 }