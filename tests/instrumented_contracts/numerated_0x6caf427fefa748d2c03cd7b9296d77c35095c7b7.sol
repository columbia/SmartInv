1 pragma solidity ^0.4.18;
2 contract ERC20 {
3     function transfer(address _recipient, uint256 amount) public;
4 }       
5 contract MultiTransfer {
6     function multiTransfer(ERC20 token, address[] _addresses, uint256 amount) public {
7         for (uint256 i = 0; i < _addresses.length; i++) {
8             token.transfer(_addresses[i], amount);
9         }
10     }
11 }