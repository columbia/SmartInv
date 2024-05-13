1 pragma solidity ^0.4.8;
2 
3 import "./linkERC20.sol";
4 
5 contract ERC677 is linkERC20 {
6   function transferAndCall(address to, uint value, bytes data) returns (bool success);
7 
8   event Transfer(address indexed from, address indexed to, uint value, bytes data);
9 }
