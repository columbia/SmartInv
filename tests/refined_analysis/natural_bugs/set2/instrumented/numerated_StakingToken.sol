1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.7.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 contract StakingToken is ERC20 {
7     uint256 public constant INITIAL_SUPPLY = 1000000000; // 1 billion
8 
9     constructor(address tokenHolder) ERC20("Staking Token", "STAKE") {
10         // fund the token swap contract
11         _mint(tokenHolder, INITIAL_SUPPLY * 1e18);
12     }
13 }
