1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "./OZ/ERC165Checker.sol";
6 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
7 
8 import "./Constants.sol";
9 
10 import "../interfaces/IGetFees.sol";
11 import "../interfaces/IGetRoyalties.sol";
12 import "../interfaces/IOwnable.sol";
13 import "../interfaces/IRoyaltyInfo.sol";
14 import "../interfaces/ITokenCreator.sol";
15 import "@manifoldxyz/royalty-registry-solidity/contracts/IRoyaltyRegistry.sol";
16 
17 error NFTMarketCreators_Address_Does_Not_Support_IRoyaltyRegistry();
18 
19 /**
20  * @title A mixin for associating creators to NFTs.
21  * @dev In the future this may store creators directly in order to support NFTs created on a different platform.
22  */
23 abstract contract NFTMarketCreators is
24   Constants,
25   ReentrancyGuardUpgradeable // Adding this unused mixin to help with linearization
26 {
27   using ERC165Checker for address;
28 
29   IRoyaltyRegistry private immutable royaltyRegistry;
30 
31   /**
32    * @notice Configures the registry allowing for royalty overrides to be defined.
33    * @param _royaltyRegistry The registry to use for royalty overrides.
34    */
35   constructor(address _royaltyRegistry) {
36     if (!_royaltyRegistry.supportsInterface(type(IRoyaltyRegistry).interfaceId)) {
37       revert NFTMarketCreators_Address_Does_Not_Support_IRoyaltyRegistry();
38     }
39     royaltyRegistry = IRoyaltyRegistry(_royaltyRegistry);
40   }
41 
42   /**
43    * @notice Looks up the royalty payment configuration for a given NFT.
44    * @dev This will check various royalty APIs on the NFT and the royalty override
45    * if one was registered with the royalty registry. This aims to send royalties
46    * in the manner requested by the NFT owner, regardless of where the NFT was minted.
47    */
48   // solhint-disable-next-line code-complexity
49   function _getCreatorPaymentInfo(
50     address nftContract,
51     uint256 tokenId,
52     address seller
53   )
54     internal
55     view
56     returns (
57       address payable[] memory recipients,
58       uint256[] memory splitPerRecipientInBasisPoints,
59       bool isCreator
60     )
61   {
62     // All NFTs implement 165 so we skip that check, individual interfaces should return false if 165 is not implemented
63 
64     // 1st priority: ERC-2981
65     if (nftContract.supportsERC165Interface(type(IRoyaltyInfo).interfaceId)) {
66       try IRoyaltyInfo(nftContract).royaltyInfo{ gas: READ_ONLY_GAS_LIMIT }(tokenId, BASIS_POINTS) returns (
67         address receiver,
68         uint256 /* royaltyAmount */
69       ) {
70         if (receiver != address(0)) {
71           recipients = new address payable[](1);
72           recipients[0] = payable(receiver);
73           // splitPerRecipientInBasisPoints is not relevant when only 1 recipient is defined
74           if (receiver == seller) {
75             return (recipients, splitPerRecipientInBasisPoints, true);
76           }
77         }
78       } catch // solhint-disable-next-line no-empty-blocks
79       {
80         // Fall through
81       }
82     }
83 
84     // 2nd priority: getRoyalties
85     if (recipients.length == 0 && nftContract.supportsERC165Interface(type(IGetRoyalties).interfaceId)) {
86       try IGetRoyalties(nftContract).getRoyalties{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
87         address payable[] memory _recipients,
88         uint256[] memory recipientBasisPoints
89       ) {
90         if (_recipients.length > 0 && _recipients.length == recipientBasisPoints.length) {
91           bool hasRecipient;
92           unchecked {
93             // The array length cannot overflow 256 bits.
94             for (uint256 i = 0; i < _recipients.length; ++i) {
95               if (_recipients[i] != address(0)) {
96                 hasRecipient = true;
97                 if (_recipients[i] == seller) {
98                   return (_recipients, recipientBasisPoints, true);
99                 }
100               }
101             }
102           }
103           if (hasRecipient) {
104             recipients = _recipients;
105             splitPerRecipientInBasisPoints = recipientBasisPoints;
106           }
107         }
108       } catch // solhint-disable-next-line no-empty-blocks
109       {
110         // Fall through
111       }
112     }
113 
114     /* Overrides must support ERC-165 when registered, except for overrides defined by the registry owner.
115        If that results in an override w/o 165 we may need to upgrade the market to support or ignore that override. */
116     // The registry requires overrides are not 0 and contracts when set.
117     // If no override is set, the nftContract address is returned.
118     if (recipients.length == 0) {
119       try royaltyRegistry.getRoyaltyLookupAddress{ gas: READ_ONLY_GAS_LIMIT }(nftContract) returns (
120         address overrideContract
121       ) {
122         if (overrideContract != nftContract) {
123           nftContract = overrideContract;
124 
125           // The functions above are repeated here if an override is set.
126 
127           // 3rd priority: ERC-2981 override
128           if (nftContract.supportsERC165Interface(type(IRoyaltyInfo).interfaceId)) {
129             try IRoyaltyInfo(nftContract).royaltyInfo{ gas: READ_ONLY_GAS_LIMIT }(tokenId, BASIS_POINTS) returns (
130               address receiver,
131               uint256 /* royaltyAmount */
132             ) {
133               if (receiver != address(0)) {
134                 recipients = new address payable[](1);
135                 recipients[0] = payable(receiver);
136                 // splitPerRecipientInBasisPoints is not relevant when only 1 recipient is defined
137                 if (receiver == seller) {
138                   return (recipients, splitPerRecipientInBasisPoints, true);
139                 }
140               }
141             } catch // solhint-disable-next-line no-empty-blocks
142             {
143               // Fall through
144             }
145           }
146 
147           // 4th priority: getRoyalties override
148           if (recipients.length == 0 && nftContract.supportsERC165Interface(type(IGetRoyalties).interfaceId)) {
149             try IGetRoyalties(nftContract).getRoyalties{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
150               address payable[] memory _recipients,
151               uint256[] memory recipientBasisPoints
152             ) {
153               if (_recipients.length > 0 && _recipients.length == recipientBasisPoints.length) {
154                 bool hasRecipient;
155                 for (uint256 i = 0; i < _recipients.length; ++i) {
156                   if (_recipients[i] != address(0)) {
157                     hasRecipient = true;
158                     if (_recipients[i] == seller) {
159                       return (_recipients, recipientBasisPoints, true);
160                     }
161                   }
162                 }
163                 if (hasRecipient) {
164                   recipients = _recipients;
165                   splitPerRecipientInBasisPoints = recipientBasisPoints;
166                 }
167               }
168             } catch // solhint-disable-next-line no-empty-blocks
169             {
170               // Fall through
171             }
172           }
173         }
174       } catch // solhint-disable-next-line no-empty-blocks
175       {
176         // Ignore out of gas errors and continue using the nftContract address
177       }
178     }
179 
180     // 5th priority: getFee* from contract or override
181     if (recipients.length == 0 && nftContract.supportsERC165Interface(type(IGetFees).interfaceId)) {
182       try IGetFees(nftContract).getFeeRecipients{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
183         address payable[] memory _recipients
184       ) {
185         if (_recipients.length > 0) {
186           try IGetFees(nftContract).getFeeBps{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
187             uint256[] memory recipientBasisPoints
188           ) {
189             if (_recipients.length == recipientBasisPoints.length) {
190               bool hasRecipient;
191               unchecked {
192                 // The array length cannot overflow 256 bits.
193                 for (uint256 i = 0; i < _recipients.length; ++i) {
194                   if (_recipients[i] != address(0)) {
195                     hasRecipient = true;
196                     if (_recipients[i] == seller) {
197                       return (_recipients, recipientBasisPoints, true);
198                     }
199                   }
200                 }
201               }
202               if (hasRecipient) {
203                 recipients = _recipients;
204                 splitPerRecipientInBasisPoints = recipientBasisPoints;
205               }
206             }
207           } catch // solhint-disable-next-line no-empty-blocks
208           {
209             // Fall through
210           }
211         }
212       } catch // solhint-disable-next-line no-empty-blocks
213       {
214         // Fall through
215       }
216     }
217 
218     // 6th priority: tokenCreator w/ or w/o requiring 165 from contract or override
219     try ITokenCreator(nftContract).tokenCreator{ gas: READ_ONLY_GAS_LIMIT }(tokenId) returns (
220       address payable _creator
221     ) {
222       if (_creator != address(0)) {
223         if (recipients.length == 0) {
224           // Only pay the tokenCreator if there wasn't another royalty defined
225           recipients = new address payable[](1);
226           recipients[0] = _creator;
227           // splitPerRecipientInBasisPoints is not relevant when only 1 recipient is defined
228         }
229         return (recipients, splitPerRecipientInBasisPoints, _creator == seller);
230       }
231     } catch // solhint-disable-next-line no-empty-blocks
232     {
233       // Fall through
234     }
235 
236     // 7th priority: owner from contract or override
237     try IOwnable(nftContract).owner{ gas: READ_ONLY_GAS_LIMIT }() returns (address owner) {
238       if (recipients.length == 0) {
239         // Only pay the owner if there wasn't another royalty defined
240         recipients = new address payable[](1);
241         recipients[0] = payable(owner);
242         // splitPerRecipientInBasisPoints is not relevant when only 1 recipient is defined
243       }
244       return (recipients, splitPerRecipientInBasisPoints, owner == seller);
245     } catch // solhint-disable-next-line no-empty-blocks
246     {
247       // Fall through
248     }
249 
250     // If no valid payment address or creator is found, return 0 recipients
251   }
252 
253   /**
254    * @notice Returns the address of the registry allowing for royalty configuration overrides.
255    * @return registry The address of the royalty registry contract.
256    */
257   function getRoyaltyRegistry() public view returns (address registry) {
258     return address(royaltyRegistry);
259   }
260 
261   /**
262    * @notice This empty reserved space is put in place to allow future versions to add new
263    * variables without shifting down storage in the inheritance chain.
264    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
265    * @dev 500 slots were consumed with the addition of `SendValueWithFallbackWithdraw`.
266    */
267   uint256[500] private __gap;
268 }
