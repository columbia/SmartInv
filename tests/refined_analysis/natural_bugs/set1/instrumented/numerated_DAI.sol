1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 contract DAI is ERC20, ERC20Burnable, Ownable {
9   constructor() ERC20("DAI", "DAI") {}
10 
11   function mint(address to, uint256 amount) public onlyOwner {
12     _mint(to, amount);
13   }
14 }
