1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/marketplace/Marketplace.sol
94 
95 /**
96  * @title Interface for contracts conforming to ERC-20
97  */
98 contract ERC20Interface {
99     function transferFrom(address from, address to, uint tokens) public returns (bool success);
100 }
101 
102 /**
103  * @title Interface for contracts conforming to ERC-721
104  */
105 contract ERC721Interface {
106     function ownerOf(uint256 assetId) public view returns (address);
107     function safeTransferFrom(address from, address to, uint256 assetId) public;
108     function isAuthorized(address operator, uint256 assetId) public view returns (bool);
109 }
110 
111 contract Marketplace is Ownable {
112     using SafeMath for uint256;
113 
114     ERC20Interface public acceptedToken;
115     ERC721Interface public nonFungibleRegistry;
116 
117     struct Auction {
118         // Auction ID
119         bytes32 id;
120         // Owner of the NFT
121         address seller;
122         // Price (in wei) for the published item
123         uint256 price;
124         // Time when this sale ends
125         uint256 expiresAt;
126     }
127 
128     mapping (uint256 => Auction) public auctionByAssetId;
129 
130     uint256 public ownerCutPercentage;
131     uint256 public publicationFeeInWei;
132 
133     /* EVENTS */
134     event AuctionCreated(
135         bytes32 id,
136         uint256 indexed assetId,
137         address indexed seller, 
138         uint256 priceInWei, 
139         uint256 expiresAt
140     );
141     event AuctionSuccessful(
142         bytes32 id,
143         uint256 indexed assetId, 
144         address indexed seller, 
145         uint256 totalPrice, 
146         address indexed winner
147     );
148     event AuctionCancelled(
149         bytes32 id,
150         uint256 indexed assetId, 
151         address indexed seller
152     );
153 
154     event ChangedPublicationFee(uint256 publicationFee);
155     event ChangedOwnerCut(uint256 ownerCut);
156 
157 
158     /**
159      * @dev Constructor for this contract.
160      * @param _acceptedToken - Address of the ERC20 accepted for this marketplace
161      * @param _nonFungibleRegistry - Address of the ERC721 registry contract.
162      */
163     function Marketplace(address _acceptedToken, address _nonFungibleRegistry) public {
164         acceptedToken = ERC20Interface(_acceptedToken);
165         nonFungibleRegistry = ERC721Interface(_nonFungibleRegistry);
166     }
167 
168     /**
169      * @dev Sets the publication fee that's charged to users to publish items
170      * @param publicationFee - Fee amount in wei this contract charges to publish an item
171      */
172     function setPublicationFee(uint256 publicationFee) onlyOwner public {
173         publicationFeeInWei = publicationFee;
174 
175         ChangedPublicationFee(publicationFeeInWei);
176     }
177 
178     /**
179      * @dev Sets the share cut for the owner of the contract that's
180      *  charged to the seller on a successful sale.
181      * @param ownerCut - Share amount, from 0 to 100
182      */
183     function setOwnerCut(uint8 ownerCut) onlyOwner public {
184         require(ownerCut < 100);
185 
186         ownerCutPercentage = ownerCut;
187 
188         ChangedOwnerCut(ownerCutPercentage);
189     }
190 
191     /**
192      * @dev Cancel an already published order
193      * @param assetId - ID of the published NFT
194      * @param priceInWei - Price in Wei for the supported coin.
195      * @param expiresAt - Duration of the auction (in hours)
196      */
197     function createOrder(uint256 assetId, uint256 priceInWei, uint256 expiresAt) public {
198         address assetOwner = nonFungibleRegistry.ownerOf(assetId);
199         require(msg.sender == assetOwner);
200         require(nonFungibleRegistry.isAuthorized(address(this), assetId));
201         require(priceInWei > 0);
202         require(expiresAt > now.add(1 minutes));
203 
204         bytes32 auctionId = keccak256(
205             block.timestamp, 
206             assetOwner,
207             assetId, 
208             priceInWei
209         );
210 
211         auctionByAssetId[assetId] = Auction({
212             id: auctionId,
213             seller: assetOwner,
214             price: priceInWei,
215             expiresAt: expiresAt
216         });
217 
218         // Check if there's a publication fee and
219         // transfer the amount to marketplace owner.
220         if (publicationFeeInWei > 0) {
221             require(acceptedToken.transferFrom(
222                 msg.sender,
223                 owner,
224                 publicationFeeInWei
225             ));
226         }
227 
228         AuctionCreated(
229             auctionId,
230             assetId, 
231             assetOwner,
232             priceInWei, 
233             expiresAt
234         );
235     }
236 
237     /**
238      * @dev Cancel an already published order
239      *  can only be canceled by seller or the contract owner.
240      * @param assetId - ID of the published NFT
241      */
242     function cancelOrder(uint256 assetId) public {
243         require(auctionByAssetId[assetId].seller == msg.sender || msg.sender == owner);
244 
245         bytes32 auctionId = auctionByAssetId[assetId].id;
246         address auctionSeller = auctionByAssetId[assetId].seller;
247         delete auctionByAssetId[assetId];
248 
249         AuctionCancelled(auctionId, assetId, auctionSeller);
250     }
251 
252     /**
253      * @dev Executes the sale for a published NTF
254      * @param assetId - ID of the published NFT
255      */
256     function executeOrder(uint256 assetId, uint256 price) public {
257         address seller = auctionByAssetId[assetId].seller;
258 
259         require(seller != address(0));
260         require(seller != msg.sender);
261         require(auctionByAssetId[assetId].price == price);
262         require(now < auctionByAssetId[assetId].expiresAt);
263 
264         require(seller == nonFungibleRegistry.ownerOf(assetId));
265 
266         uint saleShareAmount = 0;
267 
268         if (ownerCutPercentage > 0) {
269 
270             // Calculate sale share
271             saleShareAmount = price.mul(ownerCutPercentage).div(100);
272 
273             // Transfer share amount for marketplace Owner.
274             acceptedToken.transferFrom(
275                 msg.sender,
276                 owner,
277                 saleShareAmount
278             );
279         }
280 
281         // Transfer sale amount to seller
282         acceptedToken.transferFrom(
283             msg.sender,
284             seller,
285             price.sub(saleShareAmount)
286         );
287 
288         // Transfer asset owner
289         nonFungibleRegistry.safeTransferFrom(
290             seller,
291             msg.sender,
292             assetId
293         );
294 
295 
296         bytes32 auctionId = auctionByAssetId[assetId].id;
297         delete auctionByAssetId[assetId];
298 
299         AuctionSuccessful(auctionId, assetId, seller, price, msg.sender);
300     }
301  }