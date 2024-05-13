1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 interface IGetRoyalties {
6   function getRoyalties(uint256 tokenId)
7     external
8     view
9     returns (address payable[] memory recipients, uint256[] memory feesInBasisPoints);
10 }
