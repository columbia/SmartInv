1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.4;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 import '@openzeppelin/contracts/access/Ownable.sol';
8 import "hardhat/console.sol";
9 
10 contract MockToken is ERC20, Ownable {
11     constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) {
12         if (decimals_ != 18) {
13             _setupDecimals(decimals_);
14         }
15     }
16 
17     function mint (address to_, uint amount_) public {
18         _mint(to_, amount_);
19     }
20 }
