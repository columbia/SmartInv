1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20 {
5   function transfer(address _recipient, uint256 _value) public returns (bool success);
6 }
7 
8 contract Airdrop {
9   function drop(ERC20 token, address[] recipients, uint256[] values) public {
10     for (uint256 i = 0; i < recipients.length; i++) {
11       token.transfer(recipients[i], values[i]);
12     }
13   }
14 }