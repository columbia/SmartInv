1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86    OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     Unpause();
133   }
134 }
135 
136 
137 /**
138  * @title ERC721 interface
139  * @dev see https://github.com/ethereum/eips/issues/721
140  */
141 contract ERC721 {
142   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
143   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
144 
145   function balanceOf(address _owner) public view returns (uint256 _balance);
146   function ownerOf(uint256 _tokenId) public view returns (address _owner);
147   function transfer(address _to, uint256 _tokenId) public;
148   function approve(address _to, uint256 _tokenId) public;
149   function takeOwnership(uint256 _tokenId) public;
150 }
151 
152 
153 /// @title CryptoCelebritiesMarket
154 /// @dev Contains models, variables, and internal methods for sales.
155 contract CelebrityMarket is Pausable{
156 
157     ERC721 ccContract;
158 
159     // Represents a sale item on an NFT
160     struct Sale {
161         // Current owner of NFT
162         address seller;
163         // Price (in wei) at beginning of a sale item
164         uint256 salePrice;
165         // Time when sale started
166         // NOTE: 0 if this sale has been concluded
167         uint64 startedAt;
168     }
169 
170     // Owner of this contract
171     address public owner;
172 
173     // Map from token ID to their corresponding sale.
174     mapping (uint256 => Sale) tokenIdToSale;
175 
176     event SaleCreated(address seller,uint256 tokenId, uint256 salePrice, uint256 startedAt);
177     event SaleSuccessful(address seller, uint256 tokenId, uint256 totalPrice, address winner);
178     event SaleCancelled(address seller, uint256 tokenId);
179     event SaleUpdated(address seller, uint256 tokenId, uint256 oldPrice, uint256 newPrice);
180     
181     /// @dev Constructor registers the nft address (CCAddress)
182     /// @param _ccAddress - Address of the CryptoCelebrities contract
183     function CelebrityMarket(address _ccAddress) public {
184         ccContract = ERC721(_ccAddress);
185         owner = msg.sender;
186     }
187 
188     /// @dev DON'T give me your money.
189     function() external {}
190 
191 
192     /// @dev Remove all Ether from the contract, which is the owner's cuts
193     ///  as well as any Ether sent directly to the contract address.
194     ///  Always transfers to the NFT contract, but can be called either by
195     ///  the owner or the NFT contract.
196     function withdrawBalance() external {
197         require(
198             msg.sender == owner
199         );
200         msg.sender.transfer(address(this).balance);
201     }
202 
203     /// @dev Creates and begins a new sale.
204     /// @param _tokenId - ID of token to sell, sender must be owner.
205     /// @param _salePrice - Sale Price of item (in wei).
206     function createSale(
207         uint256 _tokenId,
208         uint256 _salePrice
209     )
210         public
211         whenNotPaused
212     {
213         require(_owns(msg.sender, _tokenId));
214         _escrow(_tokenId);
215         Sale memory sale = Sale(
216             msg.sender,
217             _salePrice,
218             uint64(now)
219         );
220         _addSale(_tokenId, sale);
221     }
222 
223     /// @dev Update sale price of a sale item that hasn't been completed yet.
224     /// @notice This is a state-modifying function that can
225     ///  be called while the contract is paused.
226     /// @param _tokenId - ID of token on sale
227     /// @param _newPrice - new sale price
228     function updateSalePrice(uint256 _tokenId, uint256 _newPrice)
229         public
230     {
231         Sale storage sale = tokenIdToSale[_tokenId];
232         require(_isOnSale(sale));
233         address seller = sale.seller;
234         require(msg.sender == seller);
235         _updateSalePrice(_tokenId, _newPrice, seller);
236     }
237 
238     /// @dev Allows to buy a sale item, completing the sale and transferring
239     /// ownership of the NFT if enough Ether is supplied.
240     /// @param _tokenId - ID of token to buy.
241     function buy(uint256 _tokenId)
242         public
243         payable
244         whenNotPaused
245     {
246         // _bid will throw if the bid or funds transfer fails
247         _buy(_tokenId, msg.value);
248         _transfer(msg.sender, _tokenId);
249     }
250 
251     /// @dev Cancels a sale that hasn't been completed yet.
252     ///  Returns the NFT to original owner.
253     /// @notice This is a state-modifying function that can
254     ///  be called while the contract is paused.
255     /// @param _tokenId - ID of token on sale
256     function cancelSale(uint256 _tokenId)
257         public
258     {
259         Sale storage sale = tokenIdToSale[_tokenId];
260         require(_isOnSale(sale));
261         address seller = sale.seller;
262         require(msg.sender == seller);
263         _cancelSale(_tokenId, seller);
264     }
265 
266     /// @dev Cancels a sale when the contract is paused.
267     ///  Only the owner may do this, and NFTs are returned to
268     ///  the seller. This should only be used in emergencies.
269     /// @param _tokenId - ID of the NFT on sale to cancel.
270     function cancelSaleWhenPaused(uint256 _tokenId)
271         whenPaused
272         onlyOwner
273         public
274     {
275         Sale storage sale = tokenIdToSale[_tokenId];
276         require(_isOnSale(sale));
277         _cancelSale(_tokenId, sale.seller);
278     }
279 
280     /// @dev Returns sale info for an NFT on sale.
281     /// @param _tokenId - ID of NFT on sale.
282     function getSale(uint256 _tokenId)
283         public
284         view
285         returns
286     (
287         address seller,
288         uint256 salePrice,
289         uint256 startedAt
290     ) {
291         Sale storage sale = tokenIdToSale[_tokenId];
292         require(_isOnSale(sale));
293         return (
294             sale.seller,
295             sale.salePrice,
296             sale.startedAt
297         );
298     }
299 
300     /// @dev Returns the current price of a sale item.
301     /// @param _tokenId - ID of the token price we are checking.
302     function getSalePrice(uint256 _tokenId)
303         public
304         view
305         returns (uint256)
306     {
307         Sale storage sale = tokenIdToSale[_tokenId];
308         require(_isOnSale(sale));
309         return sale.salePrice;
310     }
311 
312     /// @dev Returns true if the claimant owns the token.
313     /// @param _claimant - Address claiming to own the token.
314     /// @param _tokenId - ID of token whose ownership to verify.
315     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
316         return (ccContract.ownerOf(_tokenId) == _claimant);
317     }
318 
319     /// @dev Escrows the CCToken, assigning ownership to this contract.
320     /// Throws if the escrow fails.
321     /// @param _tokenId - ID of token whose approval to verify.
322     function _escrow(uint256 _tokenId) internal {
323         // it will throw if transfer fails
324         ccContract.takeOwnership(_tokenId);
325     }
326 
327     /// @dev Transfers a CCToken owned by this contract to another address.
328     /// Returns true if the transfer succeeds.
329     /// @param _receiver - Address to transfer NFT to.
330     /// @param _tokenId - ID of token to transfer.
331     function _transfer(address _receiver, uint256 _tokenId) internal {
332         // it will throw if transfer fails
333         ccContract.transfer(_receiver, _tokenId);
334     }
335 
336     /// @dev Adds a sale to the list of open sales. Also fires the
337     ///  SaleCreated event.
338     /// @param _tokenId The ID of the token to be put on sale.
339     /// @param _sale Sale to add.
340     function _addSale(uint256 _tokenId, Sale _sale) internal {
341 
342         tokenIdToSale[_tokenId] = _sale;
343         
344         SaleCreated(
345             address(_sale.seller),
346             uint256(_tokenId),
347             uint256(_sale.salePrice),
348             uint256(_sale.startedAt)
349         );
350     }
351 
352     /// @dev Cancels a sale unconditionally.
353     function _cancelSale(uint256 _tokenId, address _seller) internal {
354         _removeSale(_tokenId);
355         _transfer(_seller, _tokenId);
356         SaleCancelled(_seller, _tokenId);
357     }
358 
359     /// @dev updates sale price of item
360     function _updateSalePrice(uint256 _tokenId, uint256 _newPrice, address _seller) internal {
361         // Get a reference to the sale struct
362         Sale storage sale = tokenIdToSale[_tokenId];
363         uint256 oldPrice = sale.salePrice;
364         sale.salePrice = _newPrice;
365         SaleUpdated(_seller, _tokenId, oldPrice, _newPrice);
366     }
367 
368     /// @dev Computes the price and transfers winnings.
369     /// Does NOT transfer ownership of token.
370     function _buy(uint256 _tokenId, uint256 _amount)
371         internal
372         returns (uint256)
373     {
374         // Get a reference to the sale struct
375         Sale storage sale = tokenIdToSale[_tokenId];
376 
377         // Explicitly check that this sale is currently live.
378         // (Because of how Ethereum mappings work, we can't just count
379         // on the lookup above failing. An invalid _tokenId will just
380         // return an sale object that is all zeros.)
381         require(_isOnSale(sale));
382 
383         // Check that the incoming bid is higher than the current
384         // price
385         uint256 price = sale.salePrice;
386 
387         require(_amount >= price);
388 
389         // Grab a reference to the seller before the sale struct
390         // gets deleted.
391         address seller = sale.seller;
392 
393         // The bid is good! Remove the sale before sending the fees
394         // to the sender so we can't have a reentrancy attack.
395         _removeSale(_tokenId);
396 
397         // Transfer proceeds to seller (if there are any!)
398         if (price > 0) {
399             //  Calculate the market owner's cut.
400             // (NOTE: _computeCut() is guaranteed to return a
401             //  value <= price, so this subtraction can't go negative.)
402             uint256 ownerCut = _computeCut(price);
403             uint256 sellerProceeds = price - ownerCut;
404 
405             // NOTE: Doing a transfer() in the middle of a complex
406             // method like this is generally discouraged because of
407             // reentrancy attacks and DoS attacks if the seller is
408             // a contract with an invalid fallback function. We explicitly
409             // guard against reentrancy attacks by removing the sale item
410             // before calling transfer(), and the only thing the seller
411             // can DoS is the sale of their own asset! (And if it's an
412             // accident, they can call cancelSale(). )
413             seller.transfer(sellerProceeds);
414         }
415 
416         // Calculate any excess funds included with the bid. If the excess
417         // is anything worth worrying about, transfer it back to bidder.
418         // NOTE: We checked above that the bid amount is greater than or
419         // equal to the price so this cannot underflow.
420         uint256 amountExcess = _amount - price;
421 
422         // Return the funds. Similar to the previous transfer, this is
423         // not susceptible to a re-entry attack because the sale is
424         // removed before any transfers occur.
425         msg.sender.transfer(amountExcess);
426 
427         // Tell the world!
428         SaleSuccessful(seller, _tokenId, price, msg.sender);
429 
430         return price;
431     }
432 
433     /// @dev Removes a sale item from the list of open sales.
434     /// @param _tokenId - ID of NFT on sale.
435     function _removeSale(uint256 _tokenId) internal {
436         delete tokenIdToSale[_tokenId];
437     }
438 
439     /// @dev Returns true if the NFT is on sale.
440     /// @param _sale - Sale to check.
441     function _isOnSale(Sale storage _sale) internal view returns (bool) {
442         return (_sale.startedAt > 0);
443     }
444 
445     /// @dev Computes owner's cut of a sale.
446     /// @param _price - Sale price of NFT.
447     function _computeCut(uint256 _price) internal pure returns (uint256) {
448         return uint256(SafeMath.div(SafeMath.mul(_price, 6), 100));
449     }
450 
451 }