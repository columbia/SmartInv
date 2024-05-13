1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
6 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
7 
8 import "./Constants.sol";
9 
10 import "../interfaces/IFethMarket.sol";
11 
12 error NFTMarketCore_FETH_Address_Is_Not_A_Contract();
13 error NFTMarketCore_Only_FETH_Can_Transfer_ETH();
14 
15 /**
16  * @title A place for common modifiers and functions used by various NFTMarket mixins, if any.
17  * @dev This also leaves a gap which can be used to add a new mixin to the top of the inheritance tree.
18  */
19 abstract contract NFTMarketCore is Constants {
20   using AddressUpgradeable for address;
21 
22   /// @notice The FETH ERC-20 token for managing escrow and lockup.
23   IFethMarket internal immutable feth;
24 
25   constructor(address _feth) {
26     if (!_feth.isContract()) {
27       revert NFTMarketCore_FETH_Address_Is_Not_A_Contract();
28     }
29     feth = IFethMarket(_feth);
30   }
31 
32   /**
33    * @notice Only used by FETH. Any direct transfer from users will revert.
34    */
35   receive() external payable {
36     if (msg.sender != address(feth)) {
37       revert NFTMarketCore_Only_FETH_Can_Transfer_ETH();
38     }
39   }
40 
41   /**
42    * @notice Notify implementors when an auction has received its first bid.
43    * Once a bid is received the sale is guaranteed to the auction winner
44    * and other sale mechanisms become unavailable.
45    * @dev Implementors of this interface should update internal state to reflect an auction has been kicked off.
46    */
47   function _afterAuctionStarted(
48     address, /*nftContract*/
49     uint256 /*tokenId*/ // solhint-disable-next-line no-empty-blocks
50   ) internal virtual {
51     // No-op
52   }
53 
54   /**
55    * @notice If there is a buy price at this amount or lower, accept that and return true.
56    */
57   function _autoAcceptBuyPrice(
58     address nftContract,
59     uint256 tokenId,
60     uint256 amount
61   ) internal virtual returns (bool);
62 
63   /**
64    * @notice If there is a valid offer at the given price or higher, accept that and return true.
65    */
66   function _autoAcceptOffer(
67     address nftContract,
68     uint256 tokenId,
69     uint256 minAmount
70   ) internal virtual returns (bool);
71 
72   /**
73    * @notice Cancel the buyer's offer if there is one in order to free up their FETH balance.
74    */
75   function _cancelBuyersOffer(address nftContract, uint256 tokenId) internal virtual;
76 
77   /**
78    * @notice Transfers the NFT from escrow and clears any state tracking this escrowed NFT.
79    */
80   function _transferFromEscrow(
81     address nftContract,
82     uint256 tokenId,
83     address recipient,
84     address /*seller*/
85   ) internal virtual {
86     IERC721(nftContract).transferFrom(address(this), recipient, tokenId);
87   }
88 
89   /**
90    * @notice Transfers the NFT from escrow unless there is another reason for it to remain in escrow.
91    */
92   function _transferFromEscrowIfAvailable(
93     address nftContract,
94     uint256 tokenId,
95     address recipient
96   ) internal virtual {
97     IERC721(nftContract).transferFrom(address(this), recipient, tokenId);
98   }
99 
100   /**
101    * @notice Transfers an NFT into escrow,
102    * if already there this requires the msg.sender is authorized to manage the sale of this NFT.
103    */
104   function _transferToEscrow(address nftContract, uint256 tokenId) internal virtual {
105     IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
106   }
107 
108   /**
109    * @notice Gets the FETH contract used to escrow offer funds.
110    * @return fethAddress The FETH contract address.
111    */
112   function getFethAddress() external view returns (address fethAddress) {
113     return address(feth);
114   }
115 
116   /**
117    * @dev Determines the minimum amount when increasing an existing offer or bid.
118    */
119   function _getMinIncrement(uint256 currentAmount) internal pure returns (uint256) {
120     uint256 minIncrement = currentAmount * MIN_PERCENT_INCREMENT_IN_BASIS_POINTS;
121     unchecked {
122       minIncrement /= BASIS_POINTS;
123       if (minIncrement == 0) {
124         // Since minIncrement reduces from the currentAmount, this cannot overflow.
125         // The next amount must be at least 1 wei greater than the current.
126         return currentAmount + 1;
127       }
128     }
129 
130     return minIncrement + currentAmount;
131   }
132 
133   /**
134    * @notice Checks who the seller for an NFT is, checking escrow or return the current owner if not in escrow.
135    * @dev If the NFT did not have an escrowed seller to return, fall back to return the current owner.
136    */
137   function _getSellerFor(address nftContract, uint256 tokenId) internal view virtual returns (address payable seller) {
138     seller = payable(IERC721(nftContract).ownerOf(tokenId));
139   }
140 
141   /**
142    * @notice Checks if an escrowed NFT is currently in active auction.
143    * @return Returns false if the auction has ended, even if it has not yet been settled.
144    */
145   function _isInActiveAuction(address nftContract, uint256 tokenId) internal view virtual returns (bool);
146 
147   /**
148    * @notice This empty reserved space is put in place to allow future versions to add new
149    * variables without shifting down storage in the inheritance chain.
150    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
151    * @dev 50 slots were consumed by adding `ReentrancyGuard`.
152    */
153   uint256[950] private __gap;
154 }
