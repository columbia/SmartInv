1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 import { ERC20Burnable } from "../token/ERC20Burnable.sol";
7 
8 import { TestERC20Token } from "./TestERC20Token.sol";
9 
10 contract TestERC20Burnable is TestERC20Token, ERC20Burnable {
11     constructor(
12         string memory name,
13         string memory symbol,
14         uint256 totalSupply
15     ) TestERC20Token(name, symbol, totalSupply) {}
16 
17     function decimals() public view virtual override(ERC20, TestERC20Token) returns (uint8) {
18         return TestERC20Token.decimals();
19     }
20 }
