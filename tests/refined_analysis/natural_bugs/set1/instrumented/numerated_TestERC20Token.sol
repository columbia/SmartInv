1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 import { ERC20Permit } from "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
6 
7 contract TestERC20Token is ERC20Permit {
8     uint8 private _decimals = 18;
9 
10     constructor(string memory name, string memory symbol, uint256 totalSupply) ERC20(name, symbol) ERC20Permit(name) {
11         _mint(msg.sender, totalSupply);
12     }
13 
14     function decimals() public view virtual override returns (uint8) {
15         return _decimals;
16     }
17 
18     function updateDecimals(uint8 newDecimals) external {
19         _decimals = newDecimals;
20     }
21 }
