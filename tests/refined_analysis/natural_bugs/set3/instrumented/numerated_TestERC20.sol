1 // SPDX-License-Identifier: MIT
2 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
3 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
4 
5 pragma solidity 0.8.10;
6 
7 // initial supply of 100M
8 contract TestERC20 is ERC20 {
9     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
10         _mint(msg.sender, 100_000_000e18);
11     }
12 }
