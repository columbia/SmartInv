1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.3;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 contract MockToken is ERC20 {
7     constructor(
8         string memory name,
9         string memory symbol,
10         uint8 decimals
11     ) ERC20(name, symbol) {
12         _setupDecimals(decimals);
13     }
14 
15     function mint(address to, uint256 amount) external {
16         _mint(to, amount);
17     }
18 }
