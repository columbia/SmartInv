1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
5 
6 contract MockNFT is ERC721 {
7     constructor(address recipient) ERC721("MockNFT", "MockNFT") {
8         ERC721._mint(recipient, uint256(address(this)));
9     }
10 }
