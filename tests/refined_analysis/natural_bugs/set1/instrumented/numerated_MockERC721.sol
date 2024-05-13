1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
6 
7 /// @title MockERC721
8 contract MockERC721 is ERC721 {
9 
10     constructor() ERC721("Mock", "MOCK") {
11     }
12 
13     function mockMint(address account, uint256 id) external {
14         _mint(account, id);
15     }
16 
17     function permit(
18         address spender,
19         uint256 tokenId,
20         uint256,
21         bytes memory
22     ) public {
23         _approve(spender, tokenId);
24     }
25 }