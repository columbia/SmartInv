1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @notice Interface for EIP-2981: NFT Royalty Standard.
7  * For more see: https://eips.ethereum.org/EIPS/eip-2981.
8  */
9 interface IRoyaltyInfo {
10   /// @notice Called with the sale price to determine how much royalty
11   //          is owed and to whom.
12   /// @param _tokenId - the NFT asset queried for royalty information
13   /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
14   /// @return receiver - address of who should be sent the royalty payment
15   /// @return royaltyAmount - the royalty payment amount for _salePrice
16   function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
17     external
18     view
19     returns (address receiver, uint256 royaltyAmount);
20 }
