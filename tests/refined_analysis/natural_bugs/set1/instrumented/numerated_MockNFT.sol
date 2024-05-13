1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
7 
8 contract MockNFT is Ownable, ERC721 {
9   uint256 private nextTokenId;
10 
11   constructor()
12     ERC721("MockNFT", "mNFT") // solhint-disable-next-line no-empty-blocks
13   {}
14 
15   function mint() external onlyOwner {
16     _mint(msg.sender, ++nextTokenId);
17   }
18 }
