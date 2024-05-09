1 pragma solidity ^0.4.18;
2       
3 contract MultiTransfer {
4     function multiTransfer(address token, address[] _addresses, uint256 amount) public {
5         for (uint256 i = 0; i < _addresses.length; i++) {
6             token.transfer(amount);
7         }
8     }
9 }