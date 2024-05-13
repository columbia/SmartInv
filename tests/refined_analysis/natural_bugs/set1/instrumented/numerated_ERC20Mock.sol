1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/ERC20.sol";
4 
5 contract ERC20Mock is ERC20 {
6     uint256 public override totalSupply;
7 
8     constructor(uint256 _initialAmount) public {
9         // Give the creator all initial tokens
10         balanceOf[msg.sender] = _initialAmount;
11         // Update total supply
12         totalSupply = _initialAmount;
13     }
14 }
