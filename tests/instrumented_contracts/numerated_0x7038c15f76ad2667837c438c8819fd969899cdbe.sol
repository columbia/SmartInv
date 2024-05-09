1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function transfer(address _recipient, uint256 _value) public returns (bool success);
5 }
6 
7 contract Airdrop {
8   function drop(ERC20 token, address[] recipients, uint256[] values) public {
9     for (uint256 i = 0; i < recipients.length; i++) {
10       token.transfer(recipients[i], values[i]);
11     }
12   }
13 }