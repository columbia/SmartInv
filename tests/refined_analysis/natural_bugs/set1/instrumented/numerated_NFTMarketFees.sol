1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
6 
7 import "./Constants.sol";
8 import "./FoundationTreasuryNode.sol";
9 import "./NFTMarketCore.sol";
10 import "./NFTMarketCreators.sol";
11 import "./SendValueWithFallbackWithdraw.sol";
12 
13 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
14 
15 /**
16  * @title A mixin to distribute funds when an NFT is sold.
17  */
18 abstract contract NFTMarketFees is
19   Constants,
20   Initializable,
21   FoundationTreasuryNode,
22   NFTMarketCore,
23   NFTMarketCreators,
24   SendValueWithFallbackWithdraw
25 {
26   /**
27    * @dev Removing old unused variables in an upgrade safe way. Was:
28    * uint256 private _primaryFoundationFeeBasisPoints;
29    * uint256 private _secondaryFoundationFeeBasisPoints;
30    * uint256 private _secondaryCreatorFeeBasisPoints;
31    */
32   uint256[3] private __gap_was_fees;
33 
34   /// @notice Track if there has been a sale for the NFT in this market previously.
35   mapping(address => mapping(uint256 => bool)) private _nftContractToTokenIdToFirstSaleCompleted;
36 
37   /// @notice The royalties sent to creator recipients on secondary sales.
38   uint256 private constant CREATOR_ROYALTY_BASIS_POINTS = 1000; // 10%
39   /// @notice The fee collected by Foundation for sales facilitated by this market contract for a primary sale.
40   uint256 private constant PRIMARY_FOUNDATION_FEE_BASIS_POINTS = 1500; // 15%
41   /// @notice The fee collected by Foundation for sales facilitated by this market contract for a secondary sale.
42   uint256 private constant SECONDARY_FOUNDATION_FEE_BASIS_POINTS = 500; // 5%
43 
44   /**
45    * @notice Distributes funds to foundation, creator recipients, and NFT owner after a sale.
46    */
47   // solhint-disable-next-line code-complexity
48   function _distributeFunds(
49     address nftContract,
50     uint256 tokenId,
51     address payable seller,
52     uint256 price
53   )
54     internal
55     returns (
56       uint256 foundationFee,
57       uint256 creatorFee,
58       uint256 ownerRev
59     )
60   {
61     address payable[] memory creatorRecipients;
62     uint256[] memory creatorShares;
63 
64     address payable ownerRevTo;
65     (foundationFee, creatorRecipients, creatorShares, creatorFee, ownerRevTo, ownerRev) = _getFees(
66       nftContract,
67       tokenId,
68       seller,
69       price
70     );
71 
72     _sendValueWithFallbackWithdraw(getFoundationTreasury(), foundationFee, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);
73 
74     if (creatorFee > 0) {
75       if (creatorRecipients.length > 1) {
76         uint256 maxCreatorIndex = creatorRecipients.length - 1;
77         if (maxCreatorIndex > MAX_ROYALTY_RECIPIENTS_INDEX) {
78           maxCreatorIndex = MAX_ROYALTY_RECIPIENTS_INDEX;
79         }
80 
81         // Determine the total shares defined so it can be leveraged to distribute below
82         uint256 totalShares;
83         unchecked {
84           // The array length cannot overflow 256 bits.
85           for (uint256 i = 0; i <= maxCreatorIndex; ++i) {
86             if (creatorShares[i] > BASIS_POINTS) {
87               // If the numbers are >100% we ignore the fee recipients and pay just the first instead
88               maxCreatorIndex = 0;
89               break;
90             }
91             // The check above ensures totalShares wont overflow.
92             totalShares += creatorShares[i];
93           }
94         }
95         if (totalShares == 0) {
96           maxCreatorIndex = 0;
97         }
98 
99         // Send payouts to each additional recipient if more than 1 was defined
100         uint256 totalDistributed;
101         for (uint256 i = 1; i <= maxCreatorIndex; ++i) {
102           uint256 share = (creatorFee * creatorShares[i]) / totalShares;
103           totalDistributed += share;
104           _sendValueWithFallbackWithdraw(creatorRecipients[i], share, SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS);
105         }
106 
107         // Send the remainder to the 1st creator, rounding in their favor
108         _sendValueWithFallbackWithdraw(
109           creatorRecipients[0],
110           creatorFee - totalDistributed,
111           SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS
112         );
113       } else {
114         _sendValueWithFallbackWithdraw(creatorRecipients[0], creatorFee, SEND_VALUE_GAS_LIMIT_MULTIPLE_RECIPIENTS);
115       }
116     }
117     _sendValueWithFallbackWithdraw(ownerRevTo, ownerRev, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);
118 
119     _nftContractToTokenIdToFirstSaleCompleted[nftContract][tokenId] = true;
120   }
121 
122   /**
123    * @notice Returns how funds will be distributed for a sale at the given price point.
124    * @param nftContract The address of the NFT contract.
125    * @param tokenId The id of the NFT.
126    * @param price The sale price to calculate the fees for.
127    * @return foundationFee How much will be sent to the Foundation treasury.
128    * @return creatorRev How much will be sent across all the `creatorRecipients` defined.
129    * @return creatorRecipients The addresses of the recipients to receive a portion of the creator fee.
130    * @return creatorShares The percentage of the creator fee to be distributed to each `creatorRecipient`.
131    * If there is only one `creatorRecipient`, this may be an empty array.
132    * Otherwise `creatorShares.length` == `creatorRecipients.length`.
133    * @return ownerRev How much will be sent to the owner/seller of the NFT.
134    * If the NFT is being sold by the creator, this may be 0 and the full revenue will appear as `creatorRev`.
135    * @return owner The address of the owner of the NFT.
136    * If `ownerRev` is 0, this may be `address(0)`.
137    */
138   function getFeesAndRecipients(
139     address nftContract,
140     uint256 tokenId,
141     uint256 price
142   )
143     external
144     view
145     returns (
146       uint256 foundationFee,
147       uint256 creatorRev,
148       address payable[] memory creatorRecipients,
149       uint256[] memory creatorShares,
150       uint256 ownerRev,
151       address payable owner
152     )
153   {
154     address payable seller = _getSellerFor(nftContract, tokenId);
155     (foundationFee, creatorRecipients, creatorShares, creatorRev, owner, ownerRev) = _getFees(
156       nftContract,
157       tokenId,
158       seller,
159       price
160     );
161   }
162 
163   /**
164    * @dev Calculates how funds should be distributed for the given sale details.
165    */
166   function _getFees(
167     address nftContract,
168     uint256 tokenId,
169     address payable seller,
170     uint256 price
171   )
172     private
173     view
174     returns (
175       uint256 foundationFee,
176       address payable[] memory creatorRecipients,
177       uint256[] memory creatorShares,
178       uint256 creatorRev,
179       address payable ownerRevTo,
180       uint256 ownerRev
181     )
182   {
183     bool isCreator;
184     (creatorRecipients, creatorShares, isCreator) = _getCreatorPaymentInfo(nftContract, tokenId, seller);
185 
186     // Calculate the Foundation fee
187     uint256 fee;
188     if (isCreator && !_nftContractToTokenIdToFirstSaleCompleted[nftContract][tokenId]) {
189       fee = PRIMARY_FOUNDATION_FEE_BASIS_POINTS;
190     } else {
191       fee = SECONDARY_FOUNDATION_FEE_BASIS_POINTS;
192     }
193 
194     foundationFee = (price * fee) / BASIS_POINTS;
195 
196     if (creatorRecipients.length > 0) {
197       if (isCreator) {
198         // When sold by the creator, all revenue is split if applicable.
199         creatorRev = price - foundationFee;
200       } else {
201         // Rounding favors the owner first, then creator, and foundation last.
202         creatorRev = (price * CREATOR_ROYALTY_BASIS_POINTS) / BASIS_POINTS;
203         ownerRevTo = seller;
204         ownerRev = price - foundationFee - creatorRev;
205       }
206     } else {
207       // No royalty recipients found.
208       ownerRevTo = seller;
209       ownerRev = price - foundationFee;
210     }
211   }
212 
213   /**
214    * @notice This empty reserved space is put in place to allow future versions to add new
215    * variables without shifting down storage in the inheritance chain.
216    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
217    */
218   uint256[1000] private __gap;
219 }
