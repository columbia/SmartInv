1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 interface ITokenCreator {
6   function tokenCreator(uint256 tokenId) external view returns (address payable);
7 }
