1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 
7 contract MockConfigurableERC20 is ERC20, ERC20Burnable {
8     constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
9 
10     function mint(address account, uint256 amount) public returns (bool) {
11         _mint(account, amount);
12         return true;
13     }
14 }
