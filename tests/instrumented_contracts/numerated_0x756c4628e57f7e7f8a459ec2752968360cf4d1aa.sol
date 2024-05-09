1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 contract Echoer {
6   event Echo(address indexed who, bytes data);
7 
8   function echo(bytes calldata _data) external {
9     emit Echo(msg.sender, _data);
10   }
11 }