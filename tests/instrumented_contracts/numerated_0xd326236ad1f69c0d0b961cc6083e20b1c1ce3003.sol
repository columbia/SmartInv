1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function transfer(address _recipient, uint256 amount) public;
5 }       
6 contract MultiTransfer {
7     function multiTransfer(ERC20 token, address[] _addresses, uint256 amount) public {
8         for (uint256 i = 0; i < _addresses.length; i++) {
9             token.transfer(_addresses[i], amount);
10         }
11     }
12 }