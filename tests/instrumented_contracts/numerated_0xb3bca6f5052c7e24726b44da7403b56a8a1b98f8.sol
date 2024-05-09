1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
46 
47 /**
48  * @title Destructible
49  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
50  */
51 contract Destructible is Ownable {
52 
53   function Destructible() public payable { }
54 
55   /**
56    * @dev Transfers the current balance to the owner and terminates the contract.
57    */
58   function destroy() onlyOwner public {
59     selfdestruct(owner);
60   }
61 
62   function destroyAndSend(address _recipient) onlyOwner public {
63     selfdestruct(_recipient);
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     Unpause();
110   }
111 }
112 
113 // File: zeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   /**
144   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 // File: contracts/marketplace/Marketplace.sol
162 
163 /**
164  * @title Interface for contracts conforming to ERC-20
165  */
166 contract ERC20Interface {
167     function transferFrom(address from, address to, uint tokens) public returns (bool success);
168 }
169 
170 /**
171  * @title Interface for contracts conforming to ERC-721
172  */
173 contract ERC721Interface {
174     function ownerOf(uint256 assetId) public view returns (address);
175     function safeTransferFrom(address from, address to, uint256 assetId) public;
176     function isAuthorized(address operator, uint256 assetId) public view returns (bool);
177 }
178 
179 contract Marketplace is Ownable, Pausable, Destructible {
180     using SafeMath for uint256;
181 
182     ERC20Interface public acceptedToken;
183     ERC721Interface public nonFungibleRegistry;
184 
185     struct Auction {
186         // Auction ID
187         bytes32 id;
188         // Owner of the NFT
189         address seller;
190         // Price (in wei) for the published item
191         uint256 price;
192         // Time when this sale ends
193         uint256 expiresAt;
194     }
195 
196     mapping (uint256 => Auction) public auctionByAssetId;
197 
198     uint256 public ownerCutPercentage;
199     uint256 public publicationFeeInWei;
200 
201     /* EVENTS */
202     event AuctionCreated(
203         bytes32 id,
204         uint256 indexed assetId,
205         address indexed seller, 
206         uint256 priceInWei, 
207         uint256 expiresAt
208     );
209     event AuctionSuccessful(
210         bytes32 id,
211         uint256 indexed assetId, 
212         address indexed seller, 
213         uint256 totalPrice, 
214         address indexed winner
215     );
216     event AuctionCancelled(
217         bytes32 id,
218         uint256 indexed assetId, 
219         address indexed seller
220     );
221 
222     event ChangedPublicationFee(uint256 publicationFee);
223     event ChangedOwnerCut(uint256 ownerCut);
224 
225 
226     /**
227      * @dev Constructor for this contract.
228      * @param _acceptedToken - Address of the ERC20 accepted for this marketplace
229      * @param _nonFungibleRegistry - Address of the ERC721 registry contract.
230      */
231     function Marketplace(address _acceptedToken, address _nonFungibleRegistry) public {
232         acceptedToken = ERC20Interface(_acceptedToken);
233         nonFungibleRegistry = ERC721Interface(_nonFungibleRegistry);
234     }
235 
236     /**
237      * @dev Sets the publication fee that's charged to users to publish items
238      * @param publicationFee - Fee amount in wei this contract charges to publish an item
239      */
240     function setPublicationFee(uint256 publicationFee) onlyOwner public {
241         publicationFeeInWei = publicationFee;
242 
243         ChangedPublicationFee(publicationFeeInWei);
244     }
245 
246     /**
247      * @dev Sets the share cut for the owner of the contract that's
248      *  charged to the seller on a successful sale.
249      * @param ownerCut - Share amount, from 0 to 100
250      */
251     function setOwnerCut(uint8 ownerCut) onlyOwner public {
252         require(ownerCut < 100);
253 
254         ownerCutPercentage = ownerCut;
255 
256         ChangedOwnerCut(ownerCutPercentage);
257     }
258 
259     /**
260      * @dev Cancel an already published order
261      * @param assetId - ID of the published NFT
262      * @param priceInWei - Price in Wei for the supported coin.
263      * @param expiresAt - Duration of the auction (in hours)
264      */
265     function createOrder(uint256 assetId, uint256 priceInWei, uint256 expiresAt) public whenNotPaused {
266         address assetOwner = nonFungibleRegistry.ownerOf(assetId);
267         require(msg.sender == assetOwner);
268         require(nonFungibleRegistry.isAuthorized(address(this), assetId));
269         require(priceInWei > 0);
270         require(expiresAt > now.add(1 minutes));
271 
272         bytes32 auctionId = keccak256(
273             block.timestamp, 
274             assetOwner,
275             assetId, 
276             priceInWei
277         );
278 
279         auctionByAssetId[assetId] = Auction({
280             id: auctionId,
281             seller: assetOwner,
282             price: priceInWei,
283             expiresAt: expiresAt
284         });
285 
286         // Check if there's a publication fee and
287         // transfer the amount to marketplace owner.
288         if (publicationFeeInWei > 0) {
289             require(acceptedToken.transferFrom(
290                 msg.sender,
291                 owner,
292                 publicationFeeInWei
293             ));
294         }
295 
296         AuctionCreated(
297             auctionId,
298             assetId, 
299             assetOwner,
300             priceInWei, 
301             expiresAt
302         );
303     }
304 
305     /**
306      * @dev Cancel an already published order
307      *  can only be canceled by seller or the contract owner.
308      * @param assetId - ID of the published NFT
309      */
310     function cancelOrder(uint256 assetId) public whenNotPaused {
311         require(auctionByAssetId[assetId].seller == msg.sender || msg.sender == owner);
312 
313         bytes32 auctionId = auctionByAssetId[assetId].id;
314         address auctionSeller = auctionByAssetId[assetId].seller;
315         delete auctionByAssetId[assetId];
316 
317         AuctionCancelled(auctionId, assetId, auctionSeller);
318     }
319 
320     /**
321      * @dev Executes the sale for a published NTF
322      * @param assetId - ID of the published NFT
323      */
324     function executeOrder(uint256 assetId, uint256 price) public whenNotPaused {
325         address seller = auctionByAssetId[assetId].seller;
326 
327         require(seller != address(0));
328         require(seller != msg.sender);
329         require(auctionByAssetId[assetId].price == price);
330         require(now < auctionByAssetId[assetId].expiresAt);
331 
332         require(seller == nonFungibleRegistry.ownerOf(assetId));
333 
334         uint saleShareAmount = 0;
335 
336         if (ownerCutPercentage > 0) {
337 
338             // Calculate sale share
339             saleShareAmount = price.mul(ownerCutPercentage).div(100);
340 
341             // Transfer share amount for marketplace Owner.
342             acceptedToken.transferFrom(
343                 msg.sender,
344                 owner,
345                 saleShareAmount
346             );
347         }
348 
349         // Transfer sale amount to seller
350         acceptedToken.transferFrom(
351             msg.sender,
352             seller,
353             price.sub(saleShareAmount)
354         );
355 
356         // Transfer asset owner
357         nonFungibleRegistry.safeTransferFrom(
358             seller,
359             msg.sender,
360             assetId
361         );
362 
363 
364         bytes32 auctionId = auctionByAssetId[assetId].id;
365         delete auctionByAssetId[assetId];
366 
367         AuctionSuccessful(auctionId, assetId, seller, price, msg.sender);
368     }
369  }