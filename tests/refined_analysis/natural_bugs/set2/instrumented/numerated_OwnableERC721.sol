1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
5 
6 /// @title OwnableERC721
7 /// @notice Use ERC721 ownership for access control
8 contract OwnableERC721 {
9     address private _nftAddress;
10 
11     modifier onlyOwner() {
12         require(owner() == msg.sender, "OwnableERC721: caller is not the owner");
13         _;
14     }
15 
16     function _setNFT(address nftAddress) internal {
17         _nftAddress = nftAddress;
18     }
19 
20     function nft() public view virtual returns (address nftAddress) {
21         return _nftAddress;
22     }
23 
24     function owner() public view virtual returns (address ownerAddress) {
25         return IERC721(_nftAddress).ownerOf(uint256(address(this)));
26     }
27 }
