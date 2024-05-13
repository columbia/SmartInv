1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
6 
7 contract MockERC1155 is ERC1155 {
8 
9     constructor (string memory name) ERC1155(name) {}
10 
11     function mockMint(address account, uint256 id, uint256 amount) external {
12         _mint(account, id, amount, new bytes(0));
13     }
14 }