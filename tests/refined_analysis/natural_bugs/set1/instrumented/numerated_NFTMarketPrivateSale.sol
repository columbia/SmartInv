1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 
7 import "./NFTMarketFees.sol";
8 
9 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
10 
11 error NFTMarketPrivateSale_Can_Be_Offered_For_24Hrs_Max();
12 error NFTMarketPrivateSale_Proxy_Address_Is_Not_A_Contract();
13 error NFTMarketPrivateSale_Sale_Expired();
14 error NFTMarketPrivateSale_Signature_Verification_Failed();
15 error NFTMarketPrivateSale_Too_Much_Value_Provided();
16 
17 /**
18  * @title Allows owners to offer an NFT for sale to a specific collector.
19  * @notice Private sales are authorized by the seller with an EIP-712 signature.
20  * @dev Private sale offers must be accepted by the buyer before they expire, typically in 24 hours.
21  */
22 abstract contract NFTMarketPrivateSale is NFTMarketFees {
23   using AddressUpgradeable for address;
24 
25   /// @dev This value was replaced with an immutable version.
26   bytes32 private __gap_was_DOMAIN_SEPARATOR;
27 
28   /// @notice The domain used in EIP-712 signatures.
29   /// @dev It is not a constant so that the chainId can be determined dynamically.
30   /// If multiple classes use EIP-712 signatures in the future this can move to a shared file.
31   bytes32 private immutable DOMAIN_SEPARATOR;
32 
33   /// @notice The hash of the private sale method signature used for EIP-712 signatures.
34   bytes32 private constant BUY_FROM_PRIVATE_SALE_TYPEHASH =
35     keccak256("BuyFromPrivateSale(address nftContract,uint256 tokenId,address buyer,uint256 price,uint256 deadline)");
36   /// @notice The name used in the EIP-712 domain.
37   /// @dev If multiple classes use EIP-712 signatures in the future this can move to the shared constants file.
38   string private constant NAME = "FNDNFTMarket";
39 
40   /**
41    * @notice Emitted when an NFT is sold in a private sale.
42    * @dev The total amount of this sale is `f8nFee` + `creatorFee` + `ownerRev`.
43    * @param nftContract The address of the NFT contract.
44    * @param tokenId The ID of the NFT.
45    * @param seller The address of the seller.
46    * @param buyer The address of the buyer.
47    * @param f8nFee The amount of ETH that was sent to Foundation for this sale.
48    * @param creatorFee The amount of ETH that was sent to the creator for this sale.
49    * @param ownerRev The amount of ETH that was sent to the owner for this sale.
50    */
51   event PrivateSaleFinalized(
52     address indexed nftContract,
53     uint256 indexed tokenId,
54     address indexed seller,
55     address buyer,
56     uint256 f8nFee,
57     uint256 creatorFee,
58     uint256 ownerRev,
59     uint256 deadline
60   );
61 
62   /**
63    * @notice Configures the contract to accept EIP-712 signatures.
64    * @param marketProxyAddress The address of the proxy contract which will be called when accepting a private sale.
65    */
66   constructor(address marketProxyAddress) {
67     if (!marketProxyAddress.isContract()) {
68       revert NFTMarketPrivateSale_Proxy_Address_Is_Not_A_Contract();
69     }
70     uint256 chainId;
71     // solhint-disable-next-line no-inline-assembly
72     assembly {
73       chainId := chainid()
74     }
75     DOMAIN_SEPARATOR = keccak256(
76       abi.encode(
77         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
78         keccak256(bytes(NAME)),
79         // Incrementing the version can be used to invalidate previously signed messages.
80         keccak256(bytes("1")),
81         chainId,
82         marketProxyAddress
83       )
84     );
85   }
86 
87   /**
88    * @notice Buy an NFT from a private sale.
89    * @dev The seller signs a message approving the sale and then the buyer calls this function
90    * with the `msg.value` equal to the agreed upon price.
91    * @param nftContract The address of the NFT contract.
92    * @param tokenId The ID of the NFT.
93    * @param deadline The timestamp at which the offer to sell will expire.
94    * @param v The v value of the EIP-712 signature.
95    * @param r The r value of the EIP-712 signature.
96    * @param s The s value of the EIP-712 signature.
97    */
98   function buyFromPrivateSale(
99     IERC721 nftContract,
100     uint256 tokenId,
101     uint256 deadline,
102     uint8 v,
103     bytes32 r,
104     bytes32 s
105   ) external payable {
106     buyFromPrivateSaleFor(nftContract, tokenId, msg.value, deadline, v, r, s);
107   }
108 
109   /**
110    * @notice Buy an NFT from a private sale.
111    * @dev The seller signs a message approving the sale and then the buyer calls this function
112    * with the `amount` equal to the agreed upon price.
113    * @dev `amount` - `msg.value` is withdrawn from the bidder's FETH balance.
114    * @param nftContract The address of the NFT contract.
115    * @param tokenId The ID of the NFT.
116    * @param amount The amount to buy for, if this is more than `msg.value` funds will be
117    * withdrawn from your FETH balance.
118    * @param deadline The timestamp at which the offer to sell will expire.
119    * @param v The v value of the EIP-712 signature.
120    * @param r The r value of the EIP-712 signature.
121    * @param s The s value of the EIP-712 signature.
122    */
123   function buyFromPrivateSaleFor(
124     IERC721 nftContract,
125     uint256 tokenId,
126     uint256 amount,
127     uint256 deadline,
128     uint8 v,
129     bytes32 r,
130     bytes32 s
131   ) public payable nonReentrant {
132     if (deadline < block.timestamp) {
133       // The signed message from the seller has expired.
134       revert NFTMarketPrivateSale_Sale_Expired();
135     } else if (deadline > block.timestamp + 2 days) {
136       // Private sales typically expire in 24 hours, but 2 days is used here in order to ensure
137       // that transactions do not fail due to a minor timezone error or similar during signing.
138 
139       // This prevents malicious actors from requesting signatures that never expire.
140       revert NFTMarketPrivateSale_Can_Be_Offered_For_24Hrs_Max();
141     }
142 
143     if (amount > msg.value) {
144       // Withdraw additional ETH required from their available FETH balance.
145 
146       unchecked {
147         // The if above ensures delta will not underflow
148         uint256 delta = amount - msg.value;
149         feth.marketWithdrawFrom(msg.sender, delta);
150       }
151     } else if (amount < msg.value) {
152       // The terms of the sale cannot change, so if too much ETH is sent then something went wrong.
153       revert NFTMarketPrivateSale_Too_Much_Value_Provided();
154     }
155 
156     // The seller must have the NFT in their wallet when this function is called,
157     // otherwise the signature verification below will fail.
158     address payable seller = payable(nftContract.ownerOf(tokenId));
159 
160     // Scoping this block to avoid a stack too deep error
161     {
162       bytes32 digest = keccak256(
163         abi.encodePacked(
164           "\x19\x01",
165           DOMAIN_SEPARATOR,
166           keccak256(abi.encode(BUY_FROM_PRIVATE_SALE_TYPEHASH, nftContract, tokenId, msg.sender, amount, deadline))
167         )
168       );
169 
170       // Revert if the signature is invalid, the terms are not as expected, or if the seller transferred the NFT.
171       if (ecrecover(digest, v, r, s) != seller) {
172         revert NFTMarketPrivateSale_Signature_Verification_Failed();
173       }
174     }
175 
176     // This should revert if the seller has not given the market contract approval.
177     nftContract.transferFrom(seller, msg.sender, tokenId);
178 
179     // Distribute revenue for this sale.
180     (uint256 f8nFee, uint256 creatorFee, uint256 ownerRev) = _distributeFunds(
181       address(nftContract),
182       tokenId,
183       seller,
184       amount
185     );
186 
187     emit PrivateSaleFinalized(
188       address(nftContract),
189       tokenId,
190       seller,
191       msg.sender,
192       f8nFee,
193       creatorFee,
194       ownerRev,
195       deadline
196     );
197   }
198 
199   /**
200    * @notice This empty reserved space is put in place to allow future versions to add new
201    * variables without shifting down storage in the inheritance chain.
202    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
203    */
204   uint256[1000] private __gap;
205 }
