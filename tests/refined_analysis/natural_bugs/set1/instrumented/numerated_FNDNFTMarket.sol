1 /*
2   ･
3    *　★
4       ･ ｡
5         　･　ﾟ☆ ｡
6   　　　 *　★ ﾟ･｡ *  ｡
7           　　* ☆ ｡･ﾟ*.｡
8       　　　ﾟ *.｡☆｡★　･
9 ​
10                       `                     .-:::::-.`              `-::---...```
11                      `-:`               .:+ssssoooo++//:.`       .-/+shhhhhhhhhhhhhyyyssooo:
12                     .--::.            .+ossso+/////++/:://-`   .////+shhhhhhhhhhhhhhhhhhhhhy
13                   `-----::.         `/+////+++///+++/:--:/+/-  -////+shhhhhhhhhhhhhhhhhhhhhy
14                  `------:::-`      `//-.``.-/+ooosso+:-.-/oso- -////+shhhhhhhhhhhhhhhhhhhhhy
15                 .--------:::-`     :+:.`  .-/osyyyyyyso++syhyo.-////+shhhhhhhhhhhhhhhhhhhhhy
16               `-----------:::-.    +o+:-.-:/oyhhhhhhdhhhhhdddy:-////+shhhhhhhhhhhhhhhhhhhhhy
17              .------------::::--  `oys+/::/+shhhhhhhdddddddddy/-////+shhhhhhhhhhhhhhhhhhhhhy
18             .--------------:::::-` +ys+////+yhhhhhhhddddddddhy:-////+yhhhhhhhhhhhhhhhhhhhhhy
19           `----------------::::::-`.ss+/:::+oyhhhhhhhhhhhhhhho`-////+shhhhhhhhhhhhhhhhhhhhhy
20          .------------------:::::::.-so//::/+osyyyhhhhhhhhhys` -////+shhhhhhhhhhhhhhhhhhhhhy
21        `.-------------------::/:::::..+o+////+oosssyyyyyyys+`  .////+shhhhhhhhhhhhhhhhhhhhhy
22        .--------------------::/:::.`   -+o++++++oooosssss/.     `-//+shhhhhhhhhhhhhhhhhhhhyo
23      .-------   ``````.......--`        `-/+ooooosso+/-`          `./++++///:::--...``hhhhyo
24                                               `````
25    *　
26       ･ ｡
27 　　　　･　　ﾟ☆ ｡
28   　　　 *　★ ﾟ･｡ *  ｡
29           　　* ☆ ｡･ﾟ*.｡
30       　　　ﾟ *.｡☆｡★　･
31     *　　ﾟ｡·*･｡ ﾟ*
32   　　　☆ﾟ･｡°*. ﾟ
33 　 ･ ﾟ*｡･ﾟ★｡
34 　　･ *ﾟ｡　　 *
35 　･ﾟ*｡★･
36  ☆∴｡　*
37 ･ ｡
38 */
39 
40 // SPDX-License-Identifier: MIT OR Apache-2.0
41 
42 pragma solidity ^0.8.0;
43 
44 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
45 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
46 
47 import "./mixins/Constants.sol";
48 import "./mixins/FoundationTreasuryNode.sol";
49 import "./mixins/NFTMarketAuction.sol";
50 import "./mixins/NFTMarketBuyPrice.sol";
51 import "./mixins/NFTMarketCore.sol";
52 import "./mixins/NFTMarketCreators.sol";
53 import "./mixins/NFTMarketFees.sol";
54 import "./mixins/NFTMarketOffer.sol";
55 import "./mixins/NFTMarketPrivateSale.sol";
56 import "./mixins/NFTMarketReserveAuction.sol";
57 import "./mixins/SendValueWithFallbackWithdraw.sol";
58 
59 /**
60  * @title A market for NFTs on Foundation.
61  * @notice The Foundation marketplace is a contract which allows traders to buy and sell NFTs.
62  * It supports buying and selling via auctions, private sales, buy price, and offers.
63  * @dev All sales in the Foundation market will pay the creator 10% royalties on secondary sales. This is not specific
64  * to NFTs minted on Foundation, it should work for any NFT. If royalty information was not defined when the NFT was
65  * originally deployed, it may be added using the [Royalty Registry](https://royaltyregistry.xyz/) which will be
66  * respected by our market contract.
67  */
68 contract FNDNFTMarket is
69   Constants,
70   Initializable,
71   FoundationTreasuryNode,
72   NFTMarketCore,
73   ReentrancyGuardUpgradeable,
74   NFTMarketCreators,
75   SendValueWithFallbackWithdraw,
76   NFTMarketFees,
77   NFTMarketAuction,
78   NFTMarketReserveAuction,
79   NFTMarketPrivateSale,
80   NFTMarketBuyPrice,
81   NFTMarketOffer
82 {
83   /**
84    * @notice Set immutable variables for the implementation contract.
85    * @dev Using immutable instead of constants allows us to use different values on testnet.
86    */
87   constructor(
88     address payable treasury,
89     address feth,
90     address royaltyRegistry,
91     uint256 duration,
92     address marketProxyAddress
93   )
94     FoundationTreasuryNode(treasury)
95     NFTMarketCore(feth)
96     NFTMarketCreators(royaltyRegistry)
97     NFTMarketReserveAuction(duration)
98     NFTMarketPrivateSale(marketProxyAddress) // solhint-disable-next-line no-empty-blocks
99   {}
100 
101   /**
102    * @notice Called once to configure the contract after the initial proxy deployment.
103    * @dev This farms the initialize call out to inherited contracts as needed to initialize mutable variables.
104    */
105   function initialize() external initializer {
106     NFTMarketAuction._initializeNFTMarketAuction();
107   }
108 
109   /**
110    * @inheritdoc NFTMarketCore
111    * @dev This is a no-op function required to avoid compile errors.
112    */
113   function _afterAuctionStarted(address nftContract, uint256 tokenId)
114     internal
115     override(NFTMarketCore, NFTMarketBuyPrice, NFTMarketOffer)
116   {
117     super._afterAuctionStarted(nftContract, tokenId);
118   }
119 
120   /**
121    * @inheritdoc NFTMarketCore
122    * @dev This is a no-op function required to avoid compile errors.
123    */
124   function _transferFromEscrow(
125     address nftContract,
126     uint256 tokenId,
127     address recipient,
128     address seller
129   ) internal override(NFTMarketCore, NFTMarketReserveAuction, NFTMarketBuyPrice, NFTMarketOffer) {
130     super._transferFromEscrow(nftContract, tokenId, recipient, seller);
131   }
132 
133   /**
134    * @inheritdoc NFTMarketCore
135    * @dev This is a no-op function required to avoid compile errors.
136    */
137   function _transferFromEscrowIfAvailable(
138     address nftContract,
139     uint256 tokenId,
140     address recipient
141   ) internal override(NFTMarketCore, NFTMarketReserveAuction, NFTMarketBuyPrice) {
142     super._transferFromEscrowIfAvailable(nftContract, tokenId, recipient);
143   }
144 
145   /**
146    * @inheritdoc NFTMarketCore
147    * @dev This is a no-op function required to avoid compile errors.
148    */
149   function _transferToEscrow(address nftContract, uint256 tokenId)
150     internal
151     override(NFTMarketCore, NFTMarketReserveAuction, NFTMarketBuyPrice)
152   {
153     super._transferToEscrow(nftContract, tokenId);
154   }
155 
156   /**
157    * @inheritdoc NFTMarketCore
158    * @dev This is a no-op function required to avoid compile errors.
159    */
160   function _getSellerFor(address nftContract, uint256 tokenId)
161     internal
162     view
163     override(NFTMarketCore, NFTMarketReserveAuction, NFTMarketBuyPrice)
164     returns (address payable seller)
165   {
166     return super._getSellerFor(nftContract, tokenId);
167   }
168 }
