1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 /**
111    @title ERC827 interface, an extension of ERC20 token standard
112 
113    Interface of a ERC827 token, following the ERC20 standard with extra
114    methods to transfer value and data and execute calls in transfers and
115    approvals.
116  */
117 contract ERC827 is ERC20 {
118 
119   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
120   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
121   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
122 
123 }
124 
125 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
126 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
127 contract ERC721 {
128     // Required methods
129     function totalSupply() public view returns (uint256 total);
130     function balanceOf(address _owner) public view returns (uint256 balance);
131     function ownerOf(uint256 _tokenId) public view returns (address owner);
132     function approve(address _to, uint256 _tokenId) public;
133     function transfer(address _to, uint256 _tokenId) public;
134     function transferFrom(address _from, address _to, uint256 _tokenId) public;
135 
136     // Events
137     event Transfer(address from, address to, uint256 tokenId);
138     event Approval(address owner, address approved, uint256 tokenId);
139 
140     // Optional
141     // function name() public view returns (string name);
142     // function symbol() public view returns (string symbol);
143     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
144     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
145 
146     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
147     function supportsInterface(bytes4 _interfaceID) public view returns (bool);
148 }
149 
150 /// @title Auction Core
151 /// @dev Contains models, variables, and internal methods for the auction.
152 /// @notice We omit a fallback function to prevent accidental sends to this contract.
153 contract ClockAuctionBase {
154 
155     // Represents an auction on an NFT
156     struct Auction {
157         // Current owner of NFT
158         address seller;
159         // Price (in wei) at beginning of auction
160         uint128 startingPrice;
161         // Price (in wei) at end of auction
162         uint128 endingPrice;
163         // Duration (in seconds) of auction
164         uint64 duration;
165         // Time when auction started
166         // NOTE: 0 if this auction has been concluded
167         uint64 startedAt;
168     }
169 
170     // Reference to contract tracking NFT ownership
171     ERC721 public nonFungibleContract;
172 
173     ERC827 public joyTokenContract;
174 
175     address public cfoAddress;
176 
177     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
178     // Values 0-10,000 map to 0%-100%
179     uint256 public ownerCut;
180 
181     // Map from token ID to their corresponding auction.
182     mapping (uint256 => Auction) tokenIdToAuction;
183 
184     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
185     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
186     event AuctionCancelled(uint256 tokenId);
187 
188     /// @dev Returns true if the claimant owns the token.
189     /// @param _claimant - Address claiming to own the token.
190     /// @param _tokenId - ID of token whose ownership to verify.
191     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
192         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
193     }
194 
195     /// @dev Escrows the NFT, assigning ownership to this contract.
196     /// Throws if the escrow fails.
197     /// @param _owner - Current owner address of token to escrow.
198     /// @param _tokenId - ID of token whose approval to verify.
199     function _escrow(address _owner, uint256 _tokenId) internal {
200         // it will throw if transfer fails
201         nonFungibleContract.transferFrom(_owner, this, _tokenId);
202     }
203 
204     /// @dev Transfers an NFT owned by this contract to another address.
205     /// Returns true if the transfer succeeds.
206     /// @param _receiver - Address to transfer NFT to.
207     /// @param _tokenId - ID of token to transfer.
208     function _transfer(address _receiver, uint256 _tokenId) internal {
209         // it will throw if transfer fails
210         nonFungibleContract.transfer(_receiver, _tokenId);
211     }
212 
213     /// @dev Adds an auction to the list of open auctions. Also fires the
214     ///  AuctionCreated event.
215     /// @param _tokenId The ID of the token to be put on auction.
216     /// @param _auction Auction to add.
217     function _addAuction(uint256 _tokenId, Auction _auction) internal {
218         // Require that all auctions have a duration of
219         // at least one minute. (Keeps our math from getting hairy!)
220         require(_auction.duration >= 1 minutes);
221 
222         tokenIdToAuction[_tokenId] = _auction;
223         
224         AuctionCreated(
225             uint256(_tokenId),
226             uint256(_auction.startingPrice),
227             uint256(_auction.endingPrice),
228             uint256(_auction.duration)
229         );
230     }
231 
232     /// @dev Cancels an auction unconditionally.
233     function _cancelAuction(uint256 _tokenId, address _seller) internal {
234         _removeAuction(_tokenId);
235         _transfer(_seller, _tokenId);
236         AuctionCancelled(_tokenId);
237     }
238 
239     /// @dev Computes the price and transfers winnings.
240     /// Does NOT transfer ownership of token.
241     function _bid(address _bidder, uint256 _tokenId, uint256 _bidAmount)
242         internal
243         returns (uint256)
244     {
245         // Get a reference to the auction struct
246         Auction storage auction = tokenIdToAuction[_tokenId];
247 
248         // Explicitly check that this auction is currently live.
249         // (Because of how Ethereum mappings work, we can't just count
250         // on the lookup above failing. An invalid _tokenId will just
251         // return an auction object that is all zeros.)
252         require(_isOnAuction(auction));
253 
254         // Check that the bid is greater than or equal to the current price
255         uint256 price = _currentPrice(auction);
256         require(_bidAmount >= price);
257 
258         // Grab a reference to the seller before the auction struct
259         // gets deleted.
260         address seller = auction.seller;
261 
262         // The bid is good! Remove the auction before sending the fees
263         // to the sender so we can't have a reentrancy attack.
264         _removeAuction(_tokenId);
265 
266         // Transfer proceeds to seller (if there are any!)
267         if (price > 0) {
268             //  Calculate the auctioneer's cut.
269             // (NOTE: _computeCut() is guaranteed to return a
270             //  value <= price, so this subtraction can't go negative.)
271             uint256 auctioneerCut = _computeCut(price);
272             uint256 sellerProceeds = price - auctioneerCut;
273 
274             require(joyTokenContract.transferFrom(_bidder, cfoAddress, auctioneerCut));
275 
276             // NOTE: Doing a transfer() in the middle of a complex
277             // method like this is generally discouraged because of
278             // reentrancy attacks and DoS attacks if the seller is
279             // a contract with an invalid fallback function. We explicitly
280             // guard against reentrancy attacks by removing the auction
281             // before calling transfer(), and the only thing the seller
282             // can DoS is the sale of their own asset! (And if it's an
283             // accident, they can call cancelAuction(). )
284             require(joyTokenContract.transferFrom(_bidder, seller, sellerProceeds));
285         }
286 
287         // Tell the world!
288         AuctionSuccessful(_tokenId, price, _bidder);
289 
290         return price;
291     }
292 
293     /// @dev Removes an auction from the list of open auctions.
294     /// @param _tokenId - ID of NFT on auction.
295     function _removeAuction(uint256 _tokenId) internal {
296         delete tokenIdToAuction[_tokenId];
297     }
298 
299     /// @dev Returns true if the NFT is on auction.
300     /// @param _auction - Auction to check.
301     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
302         return (_auction.startedAt > 0);
303     }
304 
305     /// @dev Returns current price of an NFT on auction. Broken into two
306     ///  functions (this one, that computes the duration from the auction
307     ///  structure, and the other that does the price computation) so we
308     ///  can easily test that the price computation works correctly.
309     function _currentPrice(Auction storage _auction)
310         internal
311         view
312         returns (uint256)
313     {
314         uint256 secondsPassed = 0;
315         
316         // A bit of insurance against negative values (or wraparound).
317         // Probably not necessary (since Ethereum guarnatees that the
318         // now variable doesn't ever go backwards).
319         if (now > _auction.startedAt) {
320             secondsPassed = now - _auction.startedAt;
321         }
322 
323         return _computeCurrentPrice(
324             _auction.startingPrice,
325             _auction.endingPrice,
326             _auction.duration,
327             secondsPassed
328         );
329     }
330 
331     /// @dev Computes the current price of an auction. Factored out
332     ///  from _currentPrice so we can run extensive unit tests.
333     ///  When testing, make this function public and turn on
334     ///  `Current price computation` test suite.
335     function _computeCurrentPrice(
336         uint256 _startingPrice,
337         uint256 _endingPrice,
338         uint256 _duration,
339         uint256 _secondsPassed
340     )
341         internal
342         pure
343         returns (uint256)
344     {
345         // NOTE: We don't use SafeMath (or similar) in this function because
346         //  all of our public functions carefully cap the maximum values for
347         //  time (at 64-bits) and currency (at 128-bits). _duration is
348         //  also known to be non-zero (see the require() statement in
349         //  _addAuction())
350         if (_secondsPassed >= _duration) {
351             // We've reached the end of the dynamic pricing portion
352             // of the auction, just return the end price.
353             return _endingPrice;
354         } else {
355             // Starting price can be higher than ending price (and often is!), so
356             // this delta can be negative.
357             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
358             
359             // This multiplication can't overflow, _secondsPassed will easily fit within
360             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
361             // will always fit within 256-bits.
362             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
363             
364             // currentPriceChange can be negative, but if so, will have a magnitude
365             // less that _startingPrice. Thus, this result will always end up positive.
366             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
367             
368             return uint256(currentPrice);
369         }
370     }
371 
372     /// @dev Computes owner's cut of a sale.
373     /// @param _price - Sale price of NFT.
374     function _computeCut(uint256 _price) internal view returns (uint256) {
375         // NOTE: We don't use SafeMath (or similar) in this function because
376         //  all of our entry functions carefully cap the maximum values for
377         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
378         //  statement in the ClockAuction constructor). The result of this
379         //  function is always guaranteed to be <= _price.
380         return _price * ownerCut / 10000;
381     }
382 
383 }
384 
385 /// @title Clock auction for non-fungible tokens.
386 /// @notice We omit a fallback function to prevent accidental sends to this contract.
387 contract ClockAuction is Pausable, ClockAuctionBase {
388 
389     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9f40b779);
390 
391     /// @dev Constructor creates a reference to the NFT ownership contract
392     ///  and verifies the owner cut is in the valid range.
393     /// @param _nftAddress - address of a deployed contract implementing
394     ///  the Nonfungible Interface.
395     /// @param _cut - percent cut the owner takes on each auction, must be
396     ///  between 0-10,000.
397     function ClockAuction(address _joyTokenAdress, address _nftAddress, uint256 _cut) public {
398         require(_cut <= 10000);
399         ownerCut = _cut;
400         
401         ERC721 candidateContract = ERC721(_nftAddress);
402         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
403         nonFungibleContract = candidateContract;
404 
405         joyTokenContract = ERC827(_joyTokenAdress);
406 
407         cfoAddress = msg.sender;
408     }
409 
410     function setOwnerCut(uint256 _cut) external onlyOwner {
411         require(_cut <= 10000);
412         ownerCut = _cut;
413     }
414 
415     function setCFO(address _newCFO) external onlyOwner {
416         require(_newCFO != address(0));
417 
418         cfoAddress = _newCFO;
419     }
420 
421     modifier onlyCFO() {
422         require(msg.sender == cfoAddress);
423         _;
424     }
425 
426     function withdrawTokens() external onlyCFO {
427         uint256 value = joyTokenContract.balanceOf(address(this));
428         joyTokenContract.transfer(cfoAddress, value);
429     }
430 
431     /// @dev Cancels an auction that hasn't been won yet.
432     ///  Returns the NFT to original owner.
433     /// @notice This is a state-modifying function that can
434     ///  be called while the contract is paused.
435     /// @param _tokenId - ID of token on auction
436     function cancelAuction(uint256 _tokenId)
437         external
438     {
439         Auction storage auction = tokenIdToAuction[_tokenId];
440         require(_isOnAuction(auction));
441         address seller = auction.seller;
442         require(msg.sender == seller);
443         _cancelAuction(_tokenId, seller);
444     }
445 
446     /// @dev Cancels an auction when the contract is paused.
447     ///  Only the owner may do this, and NFTs are returned to
448     ///  the seller. This should only be used in emergencies.
449     /// @param _tokenId - ID of the NFT on auction to cancel.
450     function cancelAuctionWhenPaused(uint256 _tokenId)
451         whenPaused
452         onlyOwner
453         external
454     {
455         Auction storage auction = tokenIdToAuction[_tokenId];
456         require(_isOnAuction(auction));
457         _cancelAuction(_tokenId, auction.seller);
458     }
459 
460     /// @dev Returns auction info for an NFT on auction.
461     /// @param _tokenId - ID of NFT on auction.
462     function getAuction(uint256 _tokenId)
463         external
464         view
465         returns
466     (
467         address seller,
468         uint256 startingPrice,
469         uint256 endingPrice,
470         uint256 duration,
471         uint256 startedAt
472     ) {
473         Auction storage auction = tokenIdToAuction[_tokenId];
474         require(_isOnAuction(auction));
475         return (
476             auction.seller,
477             auction.startingPrice,
478             auction.endingPrice,
479             auction.duration,
480             auction.startedAt
481         );
482     }
483 
484     /// @dev Returns the current price of an auction.
485     /// @param _tokenId - ID of the token price we are checking.
486     function getCurrentPrice(uint256 _tokenId)
487         external
488         view
489         returns (uint256)
490     {
491         Auction storage auction = tokenIdToAuction[_tokenId];
492         require(_isOnAuction(auction));
493         return _currentPrice(auction);
494     }
495 
496 }
497 
498 /// @title Clock auction modified for sale of players
499 /// @notice We omit a fallback function to prevent accidental sends to this contract.
500 contract SaleClockAuction is ClockAuction {
501 
502     // @dev Sanity check that allows us to ensure that we are pointing to the
503     //  right auction in our setSaleAuctionAddress() call.
504     bool public constant isSaleClockAuction = true;
505     
506     // Delegate constructor
507     function SaleClockAuction(address _joyTokenAdress, address _nftAddr, uint256 _cut) public
508         ClockAuction(_joyTokenAdress, _nftAddr, _cut) {}
509 
510     /// @dev Creates and begins a new auction.
511     /// @param _tokenId - ID of token to auction, sender must be owner.
512     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
513     /// @param _endingPrice - Price of item (in wei) at end of auction.
514     /// @param _duration - Length of auction (in seconds).
515     /// @param _seller - Seller, if not the message sender
516     function createAuction(
517         uint256 _tokenId,
518         uint256 _startingPrice,
519         uint256 _endingPrice,
520         uint256 _duration,
521         address _seller
522     )
523         external
524         whenNotPaused
525     {
526         // Sanity check that no inputs overflow how many bits we've allocated
527         // to store them in the auction struct.
528         require(_startingPrice == uint256(uint128(_startingPrice)));
529         require(_endingPrice == uint256(uint128(_endingPrice)));
530         require(_duration == uint256(uint64(_duration)));
531 
532         require(msg.sender == address(nonFungibleContract));
533         _escrow(_seller, _tokenId);
534         Auction memory auction = Auction(
535             _seller,
536             uint128(_startingPrice),
537             uint128(_endingPrice),
538             uint64(_duration),
539             uint64(now)
540         );
541         _addAuction(_tokenId, auction);
542     }
543 
544     /// @dev Updates lastSalePrice if seller is the nft contract
545     /// Otherwise, works the same as default bid method.
546     function bid(address _bidder, uint256 _tokenId, uint256 _value) external whenNotPaused {
547         require(msg.sender == address(joyTokenContract) || msg.sender == _bidder);
548         // _bid verifies token ID size
549         // address seller = tokenIdToAuction[_tokenId].seller;
550         // uint256 price = _bid(_tokenId, msg.value);
551         _bid(_bidder, _tokenId, _value);
552         _transfer(_bidder, _tokenId);
553     }
554 }