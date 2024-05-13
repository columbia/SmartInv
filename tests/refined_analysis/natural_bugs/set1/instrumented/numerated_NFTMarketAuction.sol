1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
6 
7 /**
8  * @title An abstraction layer for auctions.
9  * @dev This contract can be expanded with reusable calls and data as more auction types are added.
10  */
11 abstract contract NFTMarketAuction is Initializable {
12   /**
13    * @notice A global id for auctions of any type.
14    */
15   uint256 private nextAuctionId;
16 
17   /**
18    * @notice Called once to configure the contract after the initial proxy deployment.
19    * @dev This sets the initial auction id to 1, making the first auction cheaper
20    * and id 0 represents no auction found.
21    */
22   function _initializeNFTMarketAuction() internal onlyInitializing {
23     nextAuctionId = 1;
24   }
25 
26   /**
27    * @notice Returns id to assign to the next auction.
28    */
29   function _getNextAndIncrementAuctionId() internal returns (uint256) {
30     // AuctionId cannot overflow 256 bits.
31     unchecked {
32       return nextAuctionId++;
33     }
34   }
35 
36   /**
37    * @notice This empty reserved space is put in place to allow future versions to add new
38    * variables without shifting down storage in the inheritance chain.
39    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
40    */
41   uint256[1000] private __gap;
42 }
