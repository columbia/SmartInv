1 pragma solidity ^0.6.0;
2 
3 contract Echoer {
4   event Echo(address indexed who, bytes data);
5 
6   function echo(bytes calldata _data) external {
7     emit Echo(msg.sender, _data);
8   }
9 }