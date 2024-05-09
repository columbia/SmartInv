1 pragma solidity ^0.4.24;
2 contract ERC20 {
3   function transfer(address _recipient, uint256 _value) public returns (bool success);
4 }
5 
6 contract Airdrop {
7   function multisend(ERC20 token, address[] recipients, uint256 value) public {
8     for (uint256 i = 0; i < recipients.length; i++) {
9       token.transfer(recipients[i], value * 100000);
10     }
11   }
12 }