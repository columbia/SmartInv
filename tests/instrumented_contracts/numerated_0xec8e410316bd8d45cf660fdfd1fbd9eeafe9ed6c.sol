1 pragma solidity ^0.4.11;
2 
3 
4 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
6 contract ERC721 {
7     // Required methods
8     function totalSupply() public view returns (uint256 total);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) external view returns (address owner);
11     function approve(address _to, uint256 _tokenId) external;
12     function transfer(address _to, uint256 _tokenId) external;
13     function transferFrom(address _from, address _to, uint256 _tokenId) external;
14 
15     // Events
16     event Transfer(address from, address to, uint256 tokenId);
17     event Approval(address owner, address approved, uint256 tokenId);
18 
19     // Optional
20     // function name() public view returns (string name);
21     // function symbol() public view returns (string symbol);
22     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
23     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
24 
25     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
26     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
27 }
28 
29 
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address public owner;
38 
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         if (newOwner != address(0)) {
64             owner = newOwner;
65         }
66     }
67 
68 }
69 
70 
71 
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78     event Pause();
79     event Unpause();
80 
81     bool public paused = false;
82 
83 
84     /**
85      * @dev modifier to allow actions only when the contract IS paused
86      */
87     modifier whenNotPaused() {
88         require(!paused);
89         _;
90     }
91 
92     /**
93      * @dev modifier to allow actions only when the contract IS NOT paused
94      */
95     modifier whenPaused {
96         require(paused);
97         _;
98     }
99 
100     /**
101      * @dev called by the owner to pause, triggers stopped state
102      */
103     function pause() public onlyOwner whenNotPaused returns (bool) {
104         paused = true;
105         Pause();
106         return true;
107     }
108 
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() public onlyOwner whenPaused returns (bool) {
113         paused = false;
114         Unpause();
115         return true;
116     }
117 }
118 
119 
120 
121 
122 
123 
124 /// @title Auction Core
125 /// @dev Contains models, variables, and internal methods for the auction.
126 /// @notice We omit a fallback function to prevent accidental sends to this contract.
127 contract ClockAuctionBase {
128 
129     // Represents an auction on an NFT
130     struct Auction {
131         // Current owner of NFT
132         address seller;
133         // Price (in wei) at beginning of auction
134         uint128 startingPrice;
135         // Price (in wei) at end of auction
136         uint128 endingPrice;
137         // Duration (in seconds) of auction
138         uint64 duration;
139         // Time when auction started
140         // NOTE: 0 if this auction has been concluded
141         uint64 startedAt;
142     }
143 
144     // Reference to contract tracking NFT ownership
145     ERC721 public nonFungibleContract;
146 
147     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
148     // Values 0-10,000 map to 0%-100%
149     uint256 public ownerCut;
150 
151     // Map from token ID to their corresponding auction.
152     mapping (uint256 => Auction) tokenIdToAuction;
153 
154     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
155     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
156     event AuctionCancelled(uint256 tokenId);
157 
158     /// @dev Returns true if the claimant owns the token.
159     /// @param _claimant - Address claiming to own the token.
160     /// @param _tokenId - ID of token whose ownership to verify.
161     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
162         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
163     }
164 
165     /// @dev Escrows the NFT, assigning ownership to this contract.
166     /// Throws if the escrow fails.
167     /// @param _owner - Current owner address of token to escrow.
168     /// @param _tokenId - ID of token whose approval to verify.
169     function _escrow(address _owner, uint256 _tokenId) internal {
170         // it will throw if transfer fails
171         nonFungibleContract.transferFrom(_owner, this, _tokenId);
172     }
173 
174     /// @dev Transfers an NFT owned by this contract to another address.
175     /// Returns true if the transfer succeeds.
176     /// @param _receiver - Address to transfer NFT to.
177     /// @param _tokenId - ID of token to transfer.
178     function _transfer(address _receiver, uint256 _tokenId) internal {
179         // it will throw if transfer fails
180         nonFungibleContract.transfer(_receiver, _tokenId);
181     }
182 
183     /// @dev Adds an auction to the list of open auctions. Also fires the
184     ///  AuctionCreated event.
185     /// @param _tokenId The ID of the token to be put on auction.
186     /// @param _auction Auction to add.
187     function _addAuction(uint256 _tokenId, Auction _auction) internal {
188         // Require that all auctions have a duration of
189         // at least one minute. (Keeps our math from getting hairy!)
190         require(_auction.duration >= 1 minutes);
191 
192         tokenIdToAuction[_tokenId] = _auction;
193 
194         AuctionCreated(
195             uint256(_tokenId),
196             uint256(_auction.startingPrice),
197             uint256(_auction.endingPrice),
198             uint256(_auction.duration)
199         );
200     }
201 
202     /// @dev Cancels an auction unconditionally.
203     function _cancelAuction(uint256 _tokenId, address _seller) internal {
204         _removeAuction(_tokenId);
205         _transfer(_seller, _tokenId);
206         AuctionCancelled(_tokenId);
207     }
208 
209     /// @dev Computes the price and transfers winnings.
210     /// Does NOT transfer ownership of token.
211     function _bid(uint256 _tokenId, uint256 _bidAmount)
212     internal
213     returns (uint256)
214     {
215         // Get a reference to the auction struct
216         Auction storage auction = tokenIdToAuction[_tokenId];
217 
218         // Explicitly check that this auction is currently live.
219         // (Because of how Ethereum mappings work, we can't just count
220         // on the lookup above failing. An invalid _tokenId will just
221         // return an auction object that is all zeros.)
222         require(_isOnAuction(auction));
223 
224         // Check that the bid is greater than or equal to the current price
225         uint256 price = _currentPrice(auction);
226         require(_bidAmount >= price);
227 
228         // Grab a reference to the seller before the auction struct
229         // gets deleted.
230         address seller = auction.seller;
231 
232         // The bid is good! Remove the auction before sending the fees
233         // to the sender so we can't have a reentrancy attack.
234         _removeAuction(_tokenId);
235 
236         // Transfer proceeds to seller (if there are any!)
237         if (price > 0) {
238             // Calculate the auctioneer's cut.
239             // (NOTE: _computeCut() is guaranteed to return a
240             // value <= price, so this subtraction can't go negative.)
241             uint256 auctioneerCut = _computeCut(price);
242             uint256 sellerProceeds = price - auctioneerCut;
243 
244             // NOTE: Doing a transfer() in the middle of a complex
245             // method like this is generally discouraged because of
246             // reentrancy attacks and DoS attacks if the seller is
247             // a contract with an invalid fallback function. We explicitly
248             // guard against reentrancy attacks by removing the auction
249             // before calling transfer(), and the only thing the seller
250             // can DoS is the sale of their own asset! (And if it's an
251             // accident, they can call cancelAuction(). )
252             seller.transfer(sellerProceeds);
253         }
254 
255         // Calculate any excess funds included with the bid. If the excess
256         // is anything worth worrying about, transfer it back to bidder.
257         // NOTE: We checked above that the bid amount is greater than or
258         // equal to the price so this cannot underflow.
259         uint256 bidExcess = _bidAmount - price;
260 
261         // Return the funds. Similar to the previous transfer, this is
262         // not susceptible to a re-entry attack because the auction is
263         // removed before any transfers occur.
264         msg.sender.transfer(bidExcess);
265 
266         // Tell the world!
267         AuctionSuccessful(_tokenId, price, msg.sender);
268 
269         return price;
270     }
271 
272     /// @dev Removes an auction from the list of open auctions.
273     /// @param _tokenId - ID of NFT on auction.
274     function _removeAuction(uint256 _tokenId) internal {
275         delete tokenIdToAuction[_tokenId];
276     }
277 
278     /// @dev Returns true if the NFT is on auction.
279     /// @param _auction - Auction to check.
280     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
281         return (_auction.startedAt > 0);
282     }
283 
284     /// @dev Returns current price of an NFT on auction. Broken into two
285     ///  functions (this one, that computes the duration from the auction
286     ///  structure, and the other that does the price computation) so we
287     ///  can easily test that the price computation works correctly.
288     function _currentPrice(Auction storage _auction)
289     internal
290     view
291     returns (uint256)
292     {
293         uint256 secondsPassed = 0;
294 
295         // A bit of insurance against negative values (or wraparound).
296         // Probably not necessary (since Ethereum guarnatees that the
297         // now variable doesn't ever go backwards).
298         if (now > _auction.startedAt) {
299             secondsPassed = now - _auction.startedAt;
300         }
301 
302         return _computeCurrentPrice(
303             _auction.startingPrice,
304             _auction.endingPrice,
305             _auction.duration,
306             secondsPassed
307         );
308     }
309 
310     /// @dev Computes the current price of an auction. Factored out
311     ///  from _currentPrice so we can run extensive unit tests.
312     ///  When testing, make this function public and turn on
313     ///  `Current price computation` test suite.
314     function _computeCurrentPrice(
315         uint256 _startingPrice,
316         uint256 _endingPrice,
317         uint256 _duration,
318         uint256 _secondsPassed
319     )
320     internal
321     pure
322     returns (uint256)
323     {
324         // NOTE: We don't use SafeMath (or similar) in this function because
325         //  all of our public functions carefully cap the maximum values for
326         //  time (at 64-bits) and currency (at 128-bits). _duration is
327         //  also known to be non-zero (see the require() statement in
328         //  _addAuction())
329         if (_secondsPassed >= _duration) {
330             // We've reached the end of the dynamic pricing portion
331             // of the auction, just return the end price.
332             return _endingPrice;
333         } else {
334             // Starting price can be higher than ending price (and often is!), so
335             // this delta can be negative.
336             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
337 
338             // This multiplication can't overflow, _secondsPassed will easily fit within
339             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
340             // will always fit within 256-bits.
341             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
342 
343             // currentPriceChange can be negative, but if so, will have a magnitude
344             // less that _startingPrice. Thus, this result will always end up positive.
345             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
346 
347             return uint256(currentPrice);
348         }
349     }
350 
351     /// @dev Computes owner's cut of a sale.
352     /// @param _price - Sale price of NFT.
353     function _computeCut(uint256 _price) internal view returns (uint256) {
354         // NOTE: We don't use SafeMath (or similar) in this function because
355         //  all of our entry functions carefully cap the maximum values for
356         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
357         //  statement in the ClockAuction constructor). The result of this
358         //  function is always guaranteed to be <= _price.
359         return _price * ownerCut / 10000;
360     }
361 
362 }
363 
364 
365 
366 
367 
368 /// @title Clock auction for non-fungible tokens.
369 /// @notice We omit a fallback function to prevent accidental sends to this contract.
370 contract ClockAuction is Pausable, ClockAuctionBase {
371 
372     /// @dev The ERC-165 interface signature for ERC-721.
373     ///  Ref: https://github.com/ethereum/EIPs/issues/165
374     ///  Ref: https://github.com/ethereum/EIPs/issues/721
375     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
376 
377     /// @dev Constructor creates a reference to the NFT ownership contract
378     ///  and verifies the owner cut is in the valid range.
379     /// @param _nftAddress - address of a deployed contract implementing
380     ///  the Nonfungible Interface.
381     /// @param _cut - percent cut the owner takes on each auction, must be
382     ///  between 0-10,000.
383     function ClockAuction(address _nftAddress, uint256 _cut) public {
384         require(_cut <= 10000);
385         ownerCut = _cut;
386 
387         ERC721 candidateContract = ERC721(_nftAddress);
388         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
389         nonFungibleContract = candidateContract;
390     }
391 
392     /// @dev Remove all Ether from the contract, which is the owner's cuts
393     ///  as well as any Ether sent directly to the contract address.
394     ///  Always transfers to the NFT contract, but can be called either by
395     ///  the owner or the NFT contract.
396     function withdrawBalance() external {
397         address nftAddress = address(nonFungibleContract);
398 
399         require(
400             msg.sender == owner ||
401             msg.sender == nftAddress
402         );
403         // We are using this boolean method to make sure that even if one fails it will still work
404         nftAddress.transfer(this.balance);
405     }
406 
407     /// @dev Creates and begins a new auction.
408     /// @param _tokenId - ID of token to auction, sender must be owner.
409     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
410     /// @param _endingPrice - Price of item (in wei) at end of auction.
411     /// @param _duration - Length of time to move between starting
412     ///  price and ending price (in seconds).
413     /// @param _seller - Seller, if not the message sender
414     function createAuction(
415         uint256 _tokenId,
416         uint256 _startingPrice,
417         uint256 _endingPrice,
418         uint256 _duration,
419         address _seller
420     )
421     external
422     whenNotPaused
423     {
424         // Sanity check that no inputs overflow how many bits we've allocated
425         // to store them in the auction struct.
426         require(_startingPrice == uint256(uint128(_startingPrice)));
427         require(_endingPrice == uint256(uint128(_endingPrice)));
428         require(_duration == uint256(uint64(_duration)));
429 
430         require(_owns(msg.sender, _tokenId));
431         _escrow(msg.sender, _tokenId);
432         Auction memory auction = Auction(
433             _seller,
434             uint128(_startingPrice),
435             uint128(_endingPrice),
436             uint64(_duration),
437             uint64(now)
438         );
439         _addAuction(_tokenId, auction);
440     }
441 
442     /// @dev Bids on an open auction, completing the auction and transferring
443     ///  ownership of the NFT if enough Ether is supplied.
444     /// @param _tokenId - ID of token to bid on.
445     function bid(uint256 _tokenId)
446     external
447     payable
448     whenNotPaused
449     {
450         // _bid will throw if the bid or funds transfer fails
451         _bid(_tokenId, msg.value);
452         _transfer(msg.sender, _tokenId);
453     }
454 
455     /// @dev Cancels an auction that hasn't been won yet.
456     ///  Returns the NFT to original owner.
457     /// @notice This is a state-modifying function that can
458     ///  be called while the contract is paused.
459     /// @param _tokenId - ID of token on auction
460     function cancelAuction(uint256 _tokenId)
461     external
462     {
463         Auction storage auction = tokenIdToAuction[_tokenId];
464         require(_isOnAuction(auction));
465         address seller = auction.seller;
466         require(msg.sender == seller);
467         _cancelAuction(_tokenId, seller);
468     }
469 
470     /// @dev Cancels an auction when the contract is paused.
471     ///  Only the owner may do this, and NFTs are returned to
472     ///  the seller. This should only be used in emergencies.
473     /// @param _tokenId - ID of the NFT on auction to cancel.
474     function cancelAuctionWhenPaused(uint256 _tokenId)
475     whenPaused
476     onlyOwner
477     external
478     {
479         Auction storage auction = tokenIdToAuction[_tokenId];
480         require(_isOnAuction(auction));
481         _cancelAuction(_tokenId, auction.seller);
482     }
483 
484     /// @dev Returns auction info for an NFT on auction.
485     /// @param _tokenId - ID of NFT on auction.
486     function getAuction(uint256 _tokenId)
487     external
488     view
489     returns
490     (
491         address seller,
492         uint256 startingPrice,
493         uint256 endingPrice,
494         uint256 duration,
495         uint256 startedAt
496     ) {
497         Auction storage auction = tokenIdToAuction[_tokenId];
498         require(_isOnAuction(auction));
499         return (
500         auction.seller,
501         auction.startingPrice,
502         auction.endingPrice,
503         auction.duration,
504         auction.startedAt
505         );
506     }
507 
508     /// @dev Returns the current price of an auction.
509     /// @param _tokenId - ID of the token price we are checking.
510     function getCurrentPrice(uint256 _tokenId)
511     external
512     view
513     returns (uint256)
514     {
515         Auction storage auction = tokenIdToAuction[_tokenId];
516         require(_isOnAuction(auction));
517         return _currentPrice(auction);
518     }
519 
520 }
521 
522 //
523 contract GeneScience {
524 
525     uint64 _seed = 0;
526 
527     /// @dev simply a boolean to indicate this is the contract we expect to be
528     /// pure means "they promise not to read from or modify the state."
529     function isGeneScience() public pure returns (bool) {
530         return true;
531     }
532 
533     // return a pseudo random number between lower and upper bounds
534     // given the number of previous blocks it should hash.
535     function random(uint64 upper) internal returns (uint64) {
536         _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
537         return _seed % upper;
538     }
539 
540     function randomBetween(uint32 a, uint32 b) internal returns (uint32) {
541         uint32 min;
542         uint32 max;
543         if(a < b) {
544             min = a;
545             max = b;
546         } else {
547             min = b;
548             max = a;
549         }
550 
551         return min + uint32(random(max - min + 1));
552     }
553 
554     function randomCode() internal returns (uint8) {
555         //
556         uint64 r = random(1000000);
557 
558         if (r <= 163) return 151;
559         if (r <= 327) return 251;
560         if (r <= 490) return 196;
561         if (r <= 654) return 197;
562         if (r <= 817) return 238;
563         if (r <= 981) return 240;
564         if (r <= 1144) return 239;
565         if (r <= 1308) return 173;
566         if (r <= 1471) return 175;
567         if (r <= 1635) return 174;
568         if (r <= 1798) return 236;
569         if (r <= 1962) return 172;
570         if (r <= 2289) return 250;
571         if (r <= 2616) return 249;
572         if (r <= 2943) return 244;
573         if (r <= 3270) return 243;
574         if (r <= 3597) return 245;
575         if (r <= 4087) return 145;
576         if (r <= 4577) return 146;
577         if (r <= 5068) return 144;
578         if (r <= 5885) return 248;
579         if (r <= 6703) return 149;
580         if (r <= 7520) return 143;
581         if (r <= 8337) return 112;
582         if (r <= 9155) return 242;
583         if (r <= 9972) return 212;
584         if (r <= 10790) return 160;
585         if (r <= 11607) return 6;
586         if (r <= 12424) return 157;
587         if (r <= 13242) return 131;
588         if (r <= 14059) return 3;
589         if (r <= 14877) return 233;
590         if (r <= 15694) return 9;
591         if (r <= 16511) return 154;
592         if (r <= 17329) return 182;
593         if (r <= 18146) return 176;
594         if (r <= 19127) return 150;
595         if (r <= 20762) return 130;
596         if (r <= 22397) return 68;
597         if (r <= 24031) return 65;
598         if (r <= 25666) return 59;
599         if (r <= 27301) return 94;
600         if (r <= 28936) return 199;
601         if (r <= 30571) return 169;
602         if (r <= 32205) return 208;
603         if (r <= 33840) return 230;
604         if (r <= 35475) return 186;
605         if (r <= 37110) return 36;
606         if (r <= 38744) return 38;
607         if (r <= 40379) return 192;
608         if (r <= 42014) return 26;
609         if (r <= 43649) return 237;
610         if (r <= 45284) return 148;
611         if (r <= 46918) return 247;
612         if (r <= 48553) return 2;
613         if (r <= 50188) return 5;
614         if (r <= 51823) return 8;
615         if (r <= 53785) return 134;
616         if (r <= 55746) return 232;
617         if (r <= 57708) return 76;
618         if (r <= 59670) return 136;
619         if (r <= 61632) return 135;
620         if (r <= 63593) return 181;
621         if (r <= 65555) return 62;
622         if (r <= 67517) return 34;
623         if (r <= 69479) return 31;
624         if (r <= 71440) return 221;
625         if (r <= 73402) return 71;
626         if (r <= 75364) return 185;
627         if (r <= 77325) return 18;
628         if (r <= 79287) return 15;
629         if (r <= 81249) return 12;
630         if (r <= 83211) return 159;
631         if (r <= 85172) return 189;
632         if (r <= 87134) return 219;
633         if (r <= 89096) return 156;
634         if (r <= 91058) return 153;
635         if (r <= 93510) return 217;
636         if (r <= 95962) return 139;
637         if (r <= 98414) return 229;
638         if (r <= 100866) return 141;
639         if (r <= 103319) return 210;
640         if (r <= 105771) return 45;
641         if (r <= 108223) return 205;
642         if (r <= 110675) return 78;
643         if (r <= 113127) return 224;
644         if (r <= 115580) return 171;
645         if (r <= 118032) return 164;
646         if (r <= 120484) return 178;
647         if (r <= 122936) return 195;
648         if (r <= 125388) return 105;
649         if (r <= 127840) return 162;
650         if (r <= 130293) return 168;
651         if (r <= 132745) return 184;
652         if (r <= 135197) return 166;
653         if (r <= 138467) return 103;
654         if (r <= 141736) return 89;
655         if (r <= 145006) return 99;
656         if (r <= 148275) return 142;
657         if (r <= 151545) return 80;
658         if (r <= 154814) return 91;
659         if (r <= 158084) return 115;
660         if (r <= 161354) return 106;
661         if (r <= 164623) return 73;
662         if (r <= 167893) return 28;
663         if (r <= 171162) return 241;
664         if (r <= 174432) return 121;
665         if (r <= 177701) return 55;
666         if (r <= 180971) return 126;
667         if (r <= 184241) return 82;
668         if (r <= 187510) return 125;
669         if (r <= 190780) return 110;
670         if (r <= 194049) return 85;
671         if (r <= 197319) return 57;
672         if (r <= 200589) return 107;
673         if (r <= 203858) return 97;
674         if (r <= 207128) return 119;
675         if (r <= 210397) return 227;
676         if (r <= 213667) return 117;
677         if (r <= 216936) return 49;
678         if (r <= 220206) return 40;
679         if (r <= 223476) return 101;
680         if (r <= 226745) return 87;
681         if (r <= 230015) return 215;
682         if (r <= 233284) return 42;
683         if (r <= 236554) return 22;
684         if (r <= 239823) return 207;
685         if (r <= 243093) return 24;
686         if (r <= 246363) return 93;
687         if (r <= 249632) return 47;
688         if (r <= 252902) return 20;
689         if (r <= 256171) return 53;
690         if (r <= 259441) return 113;
691         if (r <= 262710) return 198;
692         if (r <= 265980) return 51;
693         if (r <= 269250) return 108;
694         if (r <= 272519) return 190;
695         if (r <= 275789) return 158;
696         if (r <= 279058) return 95;
697         if (r <= 282328) return 1;
698         if (r <= 285598) return 225;
699         if (r <= 288867) return 4;
700         if (r <= 292137) return 155;
701         if (r <= 295406) return 7;
702         if (r <= 298676) return 152;
703         if (r <= 301945) return 25;
704         if (r <= 305215) return 132;
705         if (r <= 309302) return 67;
706         if (r <= 313389) return 64;
707         if (r <= 317476) return 75;
708         if (r <= 321563) return 70;
709         if (r <= 325650) return 180;
710         if (r <= 329737) return 61;
711         if (r <= 333824) return 33;
712         if (r <= 337911) return 30;
713         if (r <= 341998) return 17;
714         if (r <= 346085) return 202;
715         if (r <= 350172) return 188;
716         if (r <= 354259) return 11;
717         if (r <= 358346) return 14;
718         if (r <= 362433) return 235;
719         if (r <= 367337) return 214;
720         if (r <= 372241) return 127;
721         if (r <= 377146) return 124;
722         if (r <= 382050) return 128;
723         if (r <= 386954) return 123;
724         if (r <= 391859) return 226;
725         if (r <= 396763) return 234;
726         if (r <= 401667) return 122;
727         if (r <= 406572) return 211;
728         if (r <= 411476) return 203;
729         if (r <= 416381) return 200;
730         if (r <= 421285) return 206;
731         if (r <= 426189) return 44;
732         if (r <= 431094) return 193;
733         if (r <= 435998) return 222;
734         if (r <= 440902) return 58;
735         if (r <= 445807) return 83;
736         if (r <= 450711) return 35;
737         if (r <= 455615) return 201;
738         if (r <= 460520) return 37;
739         if (r <= 465424) return 218;
740         if (r <= 470329) return 220;
741         if (r <= 475233) return 213;
742         if (r <= 481772) return 114;
743         if (r <= 488311) return 137;
744         if (r <= 494850) return 77;
745         if (r <= 501390) return 138;
746         if (r <= 507929) return 140;
747         if (r <= 514468) return 209;
748         if (r <= 521007) return 228;
749         if (r <= 527546) return 170;
750         if (r <= 534085) return 204;
751         if (r <= 540624) return 92;
752         if (r <= 547164) return 133;
753         if (r <= 553703) return 104;
754         if (r <= 560242) return 177;
755         if (r <= 566781) return 246;
756         if (r <= 573320) return 147;
757         if (r <= 579859) return 46;
758         if (r <= 586399) return 194;
759         if (r <= 594573) return 111;
760         if (r <= 602746) return 98;
761         if (r <= 610920) return 88;
762         if (r <= 619094) return 79;
763         if (r <= 627268) return 66;
764         if (r <= 635442) return 27;
765         if (r <= 643616) return 74;
766         if (r <= 651790) return 216;
767         if (r <= 659964) return 231;
768         if (r <= 668138) return 63;
769         if (r <= 676312) return 102;
770         if (r <= 684486) return 109;
771         if (r <= 692660) return 81;
772         if (r <= 700834) return 84;
773         if (r <= 709008) return 118;
774         if (r <= 717182) return 56;
775         if (r <= 725356) return 96;
776         if (r <= 733530) return 54;
777         if (r <= 741703) return 90;
778         if (r <= 749877) return 72;
779         if (r <= 758051) return 120;
780         if (r <= 766225) return 116;
781         if (r <= 774399) return 69;
782         if (r <= 782573) return 48;
783         if (r <= 790747) return 86;
784         if (r <= 798921) return 179;
785         if (r <= 807095) return 100;
786         if (r <= 815269) return 23;
787         if (r <= 823443) return 223;
788         if (r <= 831617) return 32;
789         if (r <= 839791) return 29;
790         if (r <= 847965) return 39;
791         if (r <= 856139) return 60;
792         if (r <= 864313) return 167;
793         if (r <= 872487) return 21;
794         if (r <= 880660) return 165;
795         if (r <= 888834) return 163;
796         if (r <= 897008) return 52;
797         if (r <= 905182) return 19;
798         if (r <= 913356) return 16;
799         if (r <= 921530) return 41;
800         if (r <= 929704) return 161;
801         if (r <= 937878) return 187;
802         if (r <= 946052) return 50;
803         if (r <= 954226) return 183;
804         if (r <= 962400) return 13;
805         if (r <= 970574) return 10;
806         if (r <= 978748) return 191;
807         if (r <= 988556) return 43;
808         if (r <= 1000000) return 129;
809 
810         return 129;
811     }
812 
813     function getBaseStats(uint8 id) public pure returns (uint32 ra, uint32 rd, uint32 rs) {
814         if (id == 151) return (210, 210, 200);
815         if (id == 251) return (210, 210, 200);
816         if (id == 196) return (261, 194, 130);
817         if (id == 197) return (126, 250, 190);
818         if (id == 238) return (153, 116, 90);
819         if (id == 240) return (151, 108, 90);
820         if (id == 239) return (135, 110, 90);
821         if (id == 173) return (75, 91, 100);
822         if (id == 175) return (67, 116, 70);
823         if (id == 174) return (69, 34, 180);
824         if (id == 236) return (64, 64, 70);
825         if (id == 172) return (77, 63, 40);
826         if (id == 250) return (239, 274, 193);
827         if (id == 249) return (193, 323, 212);
828         if (id == 244) return (235, 176, 230);
829         if (id == 243) return (241, 210, 180);
830         if (id == 245) return (180, 235, 200);
831         if (id == 145) return (253, 188, 180);
832         if (id == 146) return (251, 184, 180);
833         if (id == 144) return (192, 249, 180);
834         if (id == 248) return (251, 212, 200);
835         if (id == 149) return (263, 201, 182);
836         if (id == 143) return (190, 190, 320);
837         if (id == 112) return (222, 206, 210);
838         if (id == 242) return (129, 229, 510);
839         if (id == 212) return (236, 191, 140);
840         if (id == 160) return (205, 197, 170);
841         if (id == 6) return (223, 176, 156);
842         if (id == 157) return (223, 176, 156);
843         if (id == 131) return (165, 180, 260);
844         if (id == 3) return (198, 198, 160);
845         if (id == 233) return (198, 183, 170);
846         if (id == 9) return (171, 210, 158);
847         if (id == 154) return (168, 202, 160);
848         if (id == 182) return (169, 189, 150);
849         if (id == 176) return (139, 191, 110);
850         if (id == 150) return (300, 182, 193);
851         if (id == 130) return (237, 197, 190);
852         if (id == 68) return (234, 162, 180);
853         if (id == 65) return (271, 194, 110);
854         if (id == 59) return (227, 166, 180);
855         if (id == 94) return (261, 156, 120);
856         if (id == 199) return (177, 194, 190);
857         if (id == 169) return (194, 178, 170);
858         if (id == 208) return (148, 333, 150);
859         if (id == 230) return (194, 194, 150);
860         if (id == 186) return (174, 192, 180);
861         if (id == 36) return (178, 171, 190);
862         if (id == 38) return (169, 204, 146);
863         if (id == 192) return (185, 148, 150);
864         if (id == 26) return (193, 165, 120);
865         if (id == 237) return (173, 214, 100);
866         if (id == 148) return (163, 138, 122);
867         if (id == 247) return (155, 133, 140);
868         if (id == 2) return (151, 151, 120);
869         if (id == 5) return (158, 129, 116);
870         if (id == 8) return (126, 155, 118);
871         if (id == 134) return (205, 177, 260);
872         if (id == 232) return (214, 214, 180);
873         if (id == 76) return (211, 229, 160);
874         if (id == 136) return (246, 204, 130);
875         if (id == 135) return (232, 201, 130);
876         if (id == 181) return (211, 172, 180);
877         if (id == 62) return (182, 187, 180);
878         if (id == 34) return (204, 157, 162);
879         if (id == 31) return (180, 174, 180);
880         if (id == 221) return (181, 147, 200);
881         if (id == 71) return (207, 138, 160);
882         if (id == 185) return (167, 198, 140);
883         if (id == 18) return (166, 157, 166);
884         if (id == 15) return (169, 150, 130);
885         if (id == 12) return (167, 151, 120);
886         if (id == 159) return (150, 151, 130);
887         if (id == 189) return (118, 197, 150);
888         if (id == 219) return (139, 209, 100);
889         if (id == 156) return (158, 129, 116);
890         if (id == 153) return (122, 155, 120);
891         if (id == 217) return (236, 144, 180);
892         if (id == 139) return (207, 227, 140);
893         if (id == 229) return (224, 159, 150);
894         if (id == 141) return (220, 203, 120);
895         if (id == 210) return (212, 137, 180);
896         if (id == 45) return (202, 170, 150);
897         if (id == 205) return (161, 242, 150);
898         if (id == 78) return (207, 167, 130);
899         if (id == 224) return (197, 141, 150);
900         if (id == 171) return (146, 146, 250);
901         if (id == 164) return (145, 179, 200);
902         if (id == 178) return (192, 146, 130);
903         if (id == 195) return (152, 152, 190);
904         if (id == 105) return (144, 200, 120);
905         if (id == 162) return (148, 130, 170);
906         if (id == 168) return (161, 128, 140);
907         if (id == 184) return (112, 152, 200);
908         if (id == 166) return (107, 209, 110);
909         if (id == 103) return (233, 158, 190);
910         if (id == 89) return (190, 184, 210);
911         if (id == 99) return (240, 214, 110);
912         if (id == 142) return (221, 164, 160);
913         if (id == 80) return (177, 194, 190);
914         if (id == 91) return (186, 323, 100);
915         if (id == 115) return (181, 165, 210);
916         if (id == 106) return (224, 211, 100);
917         if (id == 73) return (166, 237, 160);
918         if (id == 28) return (182, 202, 150);
919         if (id == 241) return (157, 211, 190);
920         if (id == 121) return (210, 184, 120);
921         if (id == 55) return (191, 163, 160);
922         if (id == 126) return (206, 169, 130);
923         if (id == 82) return (223, 182, 100);
924         if (id == 125) return (198, 173, 130);
925         if (id == 110) return (174, 221, 130);
926         if (id == 85) return (218, 145, 120);
927         if (id == 57) return (207, 144, 130);
928         if (id == 107) return (193, 212, 100);
929         if (id == 97) return (144, 215, 170);
930         if (id == 119) return (175, 154, 160);
931         if (id == 227) return (148, 260, 130);
932         if (id == 117) return (187, 182, 110);
933         if (id == 49) return (179, 150, 140);
934         if (id == 40) return (156, 93, 280);
935         if (id == 101) return (173, 179, 120);
936         if (id == 87) return (139, 184, 180);
937         if (id == 215) return (189, 157, 110);
938         if (id == 42) return (161, 153, 150);
939         if (id == 22) return (182, 135, 130);
940         if (id == 207) return (143, 204, 130);
941         if (id == 24) return (167, 158, 120);
942         if (id == 93) return (223, 112, 90);
943         if (id == 47) return (165, 146, 120);
944         if (id == 20) return (161, 144, 110);
945         if (id == 53) return (150, 139, 130);
946         if (id == 113) return (60, 176, 500);
947         if (id == 198) return (175, 87, 120);
948         if (id == 51) return (167, 147, 70);
949         if (id == 108) return (108, 137, 180);
950         if (id == 190) return (136, 112, 110);
951         if (id == 158) return (117, 116, 100);
952         if (id == 95) return (85, 288, 70);
953         if (id == 1) return (118, 118, 90);
954         if (id == 225) return (128, 90, 90);
955         if (id == 4) return (116, 96, 78);
956         if (id == 155) return (116, 96, 78);
957         if (id == 7) return (94, 122, 88);
958         if (id == 152) return (92, 122, 90);
959         if (id == 25) return (112, 101, 70);
960         if (id == 132) return (91, 91, 96);
961         if (id == 67) return (177, 130, 160);
962         if (id == 64) return (232, 138, 80);
963         if (id == 75) return (164, 196, 110);
964         if (id == 70) return (172, 95, 130);
965         if (id == 180) return (145, 112, 140);
966         if (id == 61) return (130, 130, 130);
967         if (id == 33) return (137, 112, 122);
968         if (id == 30) return (117, 126, 140);
969         if (id == 17) return (117, 108, 126);
970         if (id == 202) return (60, 106, 380);
971         if (id == 188) return (91, 127, 110);
972         if (id == 11) return (45, 94, 100);
973         if (id == 14) return (46, 86, 90);
974         if (id == 235) return (40, 88, 110);
975         if (id == 214) return (234, 189, 160);
976         if (id == 127) return (238, 197, 130);
977         if (id == 124) return (223, 182, 130);
978         if (id == 128) return (198, 197, 150);
979         if (id == 123) return (218, 170, 140);
980         if (id == 226) return (148, 260, 130);
981         if (id == 234) return (192, 132, 146);
982         if (id == 122) return (192, 233, 80);
983         if (id == 211) return (184, 148, 130);
984         if (id == 203) return (182, 133, 140);
985         if (id == 200) return (167, 167, 120);
986         if (id == 206) return (131, 131, 200);
987         if (id == 44) return (153, 139, 120);
988         if (id == 193) return (154, 94, 130);
989         if (id == 222) return (118, 156, 110);
990         if (id == 58) return (136, 96, 110);
991         if (id == 83) return (124, 118, 104);
992         if (id == 35) return (107, 116, 140);
993         if (id == 201) return (136, 91, 96);
994         if (id == 37) return (96, 122, 76);
995         if (id == 218) return (118, 71, 80);
996         if (id == 220) return (90, 74, 100);
997         if (id == 213) return (17, 396, 40);
998         if (id == 114) return (183, 205, 130);
999         if (id == 137) return (153, 139, 130);
1000         if (id == 77) return (170, 132, 100);
1001         if (id == 138) return (155, 174, 70);
1002         if (id == 140) return (148, 162, 60);
1003         if (id == 209) return (137, 89, 120);
1004         if (id == 228) return (152, 93, 90);
1005         if (id == 170) return (106, 106, 150);
1006         if (id == 204) return (108, 146, 100);
1007         if (id == 92) return (186, 70, 60);
1008         if (id == 133) return (104, 121, 110);
1009         if (id == 104) return (90, 165, 100);
1010         if (id == 177) return (134, 89, 80);
1011         if (id == 246) return (115, 93, 100);
1012         if (id == 147) return (119, 94, 82);
1013         if (id == 46) return (121, 99, 70);
1014         if (id == 194) return (75, 75, 110);
1015         if (id == 111) return (140, 157, 160);
1016         if (id == 98) return (181, 156, 60);
1017         if (id == 88) return (135, 90, 160);
1018         if (id == 79) return (109, 109, 180);
1019         if (id == 66) return (137, 88, 140);
1020         if (id == 27) return (126, 145, 100);
1021         if (id == 74) return (132, 163, 80);
1022         if (id == 216) return (142, 93, 120);
1023         if (id == 231) return (107, 107, 180);
1024         if (id == 63) return (195, 103, 50);
1025         if (id == 102) return (107, 140, 120);
1026         if (id == 109) return (119, 164, 80);
1027         if (id == 81) return (165, 128, 50);
1028         if (id == 84) return (158, 88, 70);
1029         if (id == 118) return (123, 115, 90);
1030         if (id == 56) return (148, 87, 80);
1031         if (id == 96) return (89, 158, 120);
1032         if (id == 54) return (122, 96, 100);
1033         if (id == 90) return (116, 168, 60);
1034         if (id == 72) return (97, 182, 80);
1035         if (id == 120) return (137, 112, 60);
1036         if (id == 116) return (129, 125, 60);
1037         if (id == 69) return (139, 64, 100);
1038         if (id == 48) return (100, 102, 120);
1039         if (id == 86) return (85, 128, 130);
1040         if (id == 179) return (114, 82, 110);
1041         if (id == 100) return (109, 114, 80);
1042         if (id == 23) return (110, 102, 70);
1043         if (id == 223) return (127, 69, 70);
1044         if (id == 32) return (105, 76, 92);
1045         if (id == 29) return (86, 94, 110);
1046         if (id == 39) return (80, 44, 230);
1047         if (id == 60) return (101, 82, 80);
1048         if (id == 167) return (105, 73, 80);
1049         if (id == 21) return (112, 61, 80);
1050         if (id == 165) return (72, 142, 80);
1051         if (id == 163) return (67, 101, 120);
1052         if (id == 52) return (92, 81, 80);
1053         if (id == 19) return (103, 70, 60);
1054         if (id == 16) return (85, 76, 80);
1055         if (id == 41) return (83, 76, 80);
1056         if (id == 161) return (79, 77, 70);
1057         if (id == 187) return (67, 101, 70);
1058         if (id == 50) return (109, 88, 20);
1059         if (id == 183) return (37, 93, 140);
1060         if (id == 13) return (63, 55, 80);
1061         if (id == 10) return (55, 62, 90);
1062         if (id == 191) return (55, 55, 60);
1063         if (id == 43) return (131, 116, 90);
1064         if (id == 129) return (29, 102, 40);
1065         return (0, 0, 0);
1066 
1067     }
1068 
1069     function sqrt(uint256 x) internal pure returns (uint256 y) {
1070         uint256 z = (x + 1) / 2;
1071         y = x;
1072         while (z < y) {
1073             y = z;
1074             z = (x / z + z) / 2;
1075         }
1076     }
1077 
1078     function maxCP(uint256 genes, uint16 generation) public pure returns (uint32 max_cp) {
1079         var code = uint8(genes & 0xFF);
1080         var a = uint32((genes >> 8) & 0xFF);
1081         var d = uint32((genes >> 16) & 0xFF);
1082         var s = uint32((genes >> 24) & 0xFF);
1083 //      var gender = uint32((genes >> 32) & 0x1);
1084         var bgColor = uint8((genes >> 33) & 0xFF);
1085         var (ra, rd, rs) = getBaseStats(code);
1086 
1087 
1088         max_cp = uint32(sqrt(uint256(ra + a) * uint256(ra + a) * uint256(rd + d) * uint256(rs + s) * 3900927938993281/10000000000000000 / 100));
1089         if(max_cp < 10)
1090             max_cp = 10;
1091 
1092         if(generation < 10)
1093             max_cp += (10 - generation) * 50;
1094 
1095         // bgColor
1096         if(bgColor >= 8)
1097             bgColor = 0;
1098 
1099         max_cp += bgColor * 25;
1100         return max_cp;
1101     }
1102 
1103     function getCode(uint256 genes) pure public returns (uint8) {
1104         return uint8(genes & 0xFF);
1105     }
1106 
1107     function getAttack(uint256 genes) pure public returns (uint8) {
1108         return uint8((genes >> 8) & 0xFF);
1109     }
1110 
1111     function getDefense(uint256 genes) pure public returns (uint8) {
1112         return uint8((genes >> 16) & 0xFF);
1113     }
1114 
1115     function getStamina(uint256 genes) pure public returns (uint8) {
1116         return uint8((genes >> 24) & 0xFF);
1117     }
1118 
1119     /// @dev given genes of kitten 1 & 2, return a genetic combination - may have a random factor
1120     /// @param genes1 genes of mom
1121     /// @param genes2 genes of sire
1122     /// @return the genes that are supposed to be passed down the child
1123     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256) {
1124 
1125         uint8 code;
1126         var r = random(10);
1127 
1128         // 20% percent of parents DNA
1129         if(r == 0)
1130             code = getCode(genes1);
1131         else if(r == 1)
1132             code = getCode(genes2);
1133         else
1134             code = randomCode();
1135 
1136         // 70% percent of parents DNA
1137         var attack = random(3) == 0 ? uint8(random(32)) : uint8(randomBetween(getAttack(genes1), getAttack(genes2)));
1138         var defense = random(3) == 0 ? uint8(random(32)) : uint8(randomBetween(getDefense(genes1), getDefense(genes2)));
1139         var stamina = random(3) == 0 ? uint8(random(32)) : uint8(randomBetween(getStamina(genes1), getStamina(genes2)));
1140         var gender = uint8(random(2));
1141         var bgColor = uint8(random(8));
1142         var rand = random(~uint64(0));
1143 
1144         return uint256(code) // 8
1145         | (uint256(attack) << 8) // 8
1146         | (uint256(defense) << 16) // 8
1147         | (uint256(stamina) << 24) // 8
1148         | (uint256(gender) << 32) // 1
1149         | (uint256(bgColor) << 33) // 8
1150         | (uint256(rand) << 41) // 64
1151         ;
1152     }
1153 
1154     function randomGenes() public returns (uint256) {
1155         var code = randomCode();
1156         var attack = uint8(random(32));
1157         var defense = uint8(random(32));
1158         var stamina = uint8(random(32));
1159         var gender = uint8(random(2));
1160         var bgColor = uint8(random(8));
1161         var rand = random(~uint64(0));
1162 
1163         return uint256(code) // 8
1164         | (uint256(attack) << 8) // 8
1165         | (uint256(defense) << 16) // 8
1166         | (uint256(stamina) << 24) // 8
1167         | (uint256(gender) << 32) // 1
1168         | (uint256(bgColor) << 33) // 8
1169         | (uint256(rand) << 41) // 64
1170         ;
1171     }
1172 }
1173 
1174 /// @title Clock auction modified for sale of monsters
1175 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1176 contract SaleClockAuction is ClockAuction {
1177 
1178     // @dev Sanity check that allows us to ensure that we are pointing to the
1179     //  right auction in our setSaleAuctionAddress() call.
1180     bool public isSaleClockAuction = true;
1181 
1182     // Tracks last 5 sale price of gen0 monster sales
1183     uint256 public gen0SaleCount;
1184     uint256[5] public lastGen0SalePrices;
1185 
1186     // Delegate constructor
1187     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1188     ClockAuction(_nftAddr, _cut) {}
1189 
1190     /// @dev Creates and begins a new auction.
1191     /// @param _tokenId - ID of token to auction, sender must be owner.
1192     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1193     /// @param _endingPrice - Price of item (in wei) at end of auction.
1194     /// @param _duration - Length of auction (in seconds).
1195     /// @param _seller - Seller, if not the message sender
1196     function createAuction(
1197         uint256 _tokenId,
1198         uint256 _startingPrice,
1199         uint256 _endingPrice,
1200         uint256 _duration,
1201         address _seller
1202     )
1203     external
1204     {
1205         // Sanity check that no inputs overflow how many bits we've allocated
1206         // to store them in the auction struct.
1207         require(_startingPrice == uint256(uint128(_startingPrice)));
1208         require(_endingPrice == uint256(uint128(_endingPrice)));
1209         require(_duration == uint256(uint64(_duration)));
1210 
1211         require(msg.sender == address(nonFungibleContract));
1212         _escrow(_seller, _tokenId);
1213         Auction memory auction = Auction(
1214             _seller,
1215             uint128(_startingPrice),
1216             uint128(_endingPrice),
1217             uint64(_duration),
1218             uint64(now)
1219         );
1220         _addAuction(_tokenId, auction);
1221     }
1222 
1223     /// @dev Updates lastSalePrice if seller is the nft contract
1224     /// Otherwise, works the same as default bid method.
1225     function bid(uint256 _tokenId)
1226     external
1227     payable
1228     {
1229         // _bid verifies token ID size
1230         address seller = tokenIdToAuction[_tokenId].seller;
1231         uint256 price = _bid(_tokenId, msg.value);
1232         _transfer(msg.sender, _tokenId);
1233 
1234         // If not a gen0 auction, exit
1235         if (seller == address(nonFungibleContract)) {
1236             // Track gen0 sale prices
1237             lastGen0SalePrices[gen0SaleCount % 5] = price;
1238             gen0SaleCount++;
1239         }
1240     }
1241 
1242     function averageGen0SalePrice() external view returns (uint256) {
1243         uint256 sum = 0;
1244         for (uint256 i = 0; i < 5; i++) {
1245             sum += lastGen0SalePrices[i];
1246         }
1247         return sum / 5;
1248     }
1249 
1250 }
1251 
1252 /// @title Reverse auction modified for siring
1253 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1254 contract SiringClockAuction is ClockAuction {
1255 
1256     // @dev Sanity check that allows us to ensure that we are pointing to the
1257     //  right auction in our setSiringAuctionAddress() call.
1258     bool public isSiringClockAuction = true;
1259 
1260     // Delegate constructor
1261     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1262     ClockAuction(_nftAddr, _cut) {}
1263 
1264     /// @dev Creates and begins a new auction. Since this function is wrapped,
1265     /// require sender to be MonsterCore contract.
1266     /// @param _tokenId - ID of token to auction, sender must be owner.
1267     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1268     /// @param _endingPrice - Price of item (in wei) at end of auction.
1269     /// @param _duration - Length of auction (in seconds).
1270     /// @param _seller - Seller, if not the message sender
1271     function createAuction(
1272         uint256 _tokenId,
1273         uint256 _startingPrice,
1274         uint256 _endingPrice,
1275         uint256 _duration,
1276         address _seller
1277     )
1278     external
1279     {
1280         // Sanity check that no inputs overflow how many bits we've allocated
1281         // to store them in the auction struct.
1282         require(_startingPrice == uint256(uint128(_startingPrice)));
1283         require(_endingPrice == uint256(uint128(_endingPrice)));
1284         require(_duration == uint256(uint64(_duration)));
1285 
1286         require(msg.sender == address(nonFungibleContract));
1287         _escrow(_seller, _tokenId);
1288         Auction memory auction = Auction(
1289             _seller,
1290             uint128(_startingPrice),
1291             uint128(_endingPrice),
1292             uint64(_duration),
1293             uint64(now)
1294         );
1295         _addAuction(_tokenId, auction);
1296     }
1297 
1298     /// @dev Places a bid for siring. Requires the sender
1299     /// is the MonsterCore contract because all bid methods
1300     /// should be wrapped. Also returns the monster to the
1301     /// seller rather than the winner.
1302     function bid(uint256 _tokenId)
1303     external
1304     payable
1305     {
1306         require(msg.sender == address(nonFungibleContract));
1307         address seller = tokenIdToAuction[_tokenId].seller;
1308         // _bid checks that token ID is valid and will throw if bid fails
1309         _bid(_tokenId, msg.value);
1310         // We transfer the monster back to the seller, the winner will get
1311         // the offspring
1312         _transfer(seller, _tokenId);
1313     }
1314 
1315 }
1316 
1317 
1318 
1319 
1320 
1321 
1322 
1323 /// @title A facet of MonsterCore that manages special access privileges.
1324 /// @author Axiom Zen (https://www.axiomzen.co)
1325 /// @dev See the MonsterCore contract documentation to understand how the various contract facets are arranged.
1326 contract MonsterAccessControl {
1327     // This facet controls access control for CryptoMonsters. There are four roles managed here:
1328     //
1329     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
1330     //         contracts. It is also the only role that can unpause the smart contract. It is initially
1331     //         set to the address that created the smart contract in the MonsterCore constructor.
1332     //
1333     //     - The CFO: The CFO can withdraw funds from MonsterCore and its auction contracts.
1334     //
1335     //     - The COO: The COO can release gen0 monsters to auction, and mint promo monsters.
1336     //
1337     // It should be noted that these roles are distinct without overlap in their access abilities, the
1338     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
1339     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
1340     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
1341     // convenience. The less we use an address, the less likely it is that we somehow compromise the
1342     // account.
1343 
1344     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
1345     event ContractUpgrade(address newContract);
1346 
1347     // The addresses of the accounts (or contracts) that can execute actions within each roles.
1348     address public ceoAddress;
1349     address public cfoAddress;
1350     address public cooAddress;
1351 
1352     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
1353     bool public paused = false;
1354 
1355     /// @dev Access modifier for CEO-only functionality
1356     modifier onlyCEO() {
1357         require(msg.sender == ceoAddress);
1358         _;
1359     }
1360 
1361     /// @dev Access modifier for CFO-only functionality
1362     modifier onlyCFO() {
1363         require(msg.sender == cfoAddress);
1364         _;
1365     }
1366 
1367     /// @dev Access modifier for COO-only functionality
1368     modifier onlyCOO() {
1369         require(msg.sender == cooAddress);
1370         _;
1371     }
1372 
1373     modifier onlyCLevel() {
1374         require(
1375             msg.sender == cooAddress ||
1376             msg.sender == ceoAddress ||
1377             msg.sender == cfoAddress
1378         );
1379         _;
1380     }
1381 
1382     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
1383     /// @param _newCEO The address of the new CEO
1384     function setCEO(address _newCEO) external onlyCEO {
1385         require(_newCEO != address(0));
1386 
1387         ceoAddress = _newCEO;
1388     }
1389 
1390     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
1391     /// @param _newCFO The address of the new CFO
1392     function setCFO(address _newCFO) external onlyCEO {
1393         require(_newCFO != address(0));
1394 
1395         cfoAddress = _newCFO;
1396     }
1397 
1398     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
1399     /// @param _newCOO The address of the new COO
1400     function setCOO(address _newCOO) external onlyCEO {
1401         require(_newCOO != address(0));
1402 
1403         cooAddress = _newCOO;
1404     }
1405 
1406     /*** Pausable functionality adapted from OpenZeppelin ***/
1407 
1408     /// @dev Modifier to allow actions only when the contract IS NOT paused
1409     modifier whenNotPaused() {
1410         require(!paused);
1411         _;
1412     }
1413 
1414     /// @dev Modifier to allow actions only when the contract IS paused
1415     modifier whenPaused {
1416         require(paused);
1417         _;
1418     }
1419 
1420     /// @dev Called by any "C-level" role to pause the contract. Used only when
1421     ///  a bug or exploit is detected and we need to limit damage.
1422     function pause() external onlyCLevel whenNotPaused {
1423         paused = true;
1424     }
1425 
1426     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
1427     ///  one reason we may pause the contract is when CFO or COO accounts are
1428     ///  compromised.
1429     /// @notice This is public rather than external so it can be called by
1430     ///  derived contracts.
1431     function unpause() public onlyCEO whenPaused {
1432         // can't unpause if contract was upgraded
1433         paused = false;
1434     }
1435 }
1436 
1437 
1438 
1439 
1440 /// @title Base contract for CryptoMonsters. Holds all common structs, events and base variables.
1441 /// @author Axiom Zen (https://www.axiomzen.co)
1442 /// @dev See the MonsterCore contract documentation to understand how the various contract facets are arranged.
1443 contract MonsterBase is MonsterAccessControl {
1444     /*** EVENTS ***/
1445 
1446     /// @dev The Birth event is fired whenever a new monster comes into existence. This obviously
1447     ///  includes any time a monster is created through the giveBirth method, but it is also called
1448     ///  when a new gen0 monster is created.
1449     event Birth(address owner, uint256 monsterId, uint256 matronId, uint256 sireId, uint256 genes, uint16 generation);
1450 
1451     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a monster
1452     ///  ownership is assigned, including births.
1453     event Transfer(address from, address to, uint256 tokenId);
1454 
1455     /*** DATA TYPES ***/
1456 
1457     /// @dev The main Monster struct. Every monster in CryptoMonsters is represented by a copy
1458     ///  of this structure, so great care was taken to ensure that it fits neatly into
1459     ///  exactly two 256-bit words. Note that the order of the members in this structure
1460     ///  is important because of the byte-packing rules used by Ethereum.
1461     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
1462     struct Monster {
1463         // The Monster's genetic code is packed into these 256-bits, the format is
1464         // sooper-sekret! A monster's genes never change.
1465         uint256 genes;
1466 
1467         // The timestamp from the block when this monster came into existence.
1468         uint64 birthTime;
1469 
1470         // The minimum timestamp after which this monster can engage in breeding
1471         // activities again. This same timestamp is used for the pregnancy
1472         // timer (for matrons) as well as the siring cooldown.
1473         uint64 cooldownEndBlock;
1474 
1475         // The ID of the parents of this monster, set to 0 for gen0 monsters.
1476         // Note that using 32-bit unsigned integers limits us to a "mere"
1477         // 4 billion monsters. This number might seem small until you realize
1478         // that Ethereum currently has a limit of about 500 million
1479         // transactions per year! So, this definitely won't be a problem
1480         // for several years (even as Ethereum learns to scale).
1481         uint32 matronId;
1482         uint32 sireId;
1483 
1484         // Set to the ID of the sire monster for matrons that are pregnant,
1485         // zero otherwise. A non-zero value here is how we know a monster
1486         // is pregnant. Used to retrieve the genetic material for the new
1487         // monster when the birth transpires.
1488         uint32 siringWithId;
1489 
1490         // Set to the index in the cooldown array (see below) that represents
1491         // the current cooldown duration for this Monster. This starts at zero
1492         // for gen0 monsters, and is initialized to floor(generation/2) for others.
1493         // Incremented by one for each successful breeding action, regardless
1494         // of whether this monster is acting as matron or sire.
1495         uint16 cooldownIndex;
1496 
1497         // The "generation number" of this monster. Monsters minted by the CK contract
1498         // for sale are called "gen0" and have a generation number of 0. The
1499         // generation number of all other monsters is the larger of the two generation
1500         // numbers of their parents, plus one.
1501         // (i.e. max(matron.generation, sire.generation) + 1)
1502         uint16 generation;
1503     }
1504 
1505     /*** CONSTANTS ***/
1506 
1507     /// @dev A lookup table indimonstering the cooldown duration after any successful
1508     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
1509     ///  for sires. Designed such that the cooldown roughly doubles each time a monster
1510     ///  is bred, encouraging owners not to just keep breeding the same monster over
1511     ///  and over again. Caps out at one week (a monster can breed an unbounded number
1512     ///  of times, and the maximum cooldown is always seven days).
1513     uint32[14] public cooldowns = [
1514     uint32(1 minutes),
1515     uint32(2 minutes),
1516     uint32(5 minutes),
1517     uint32(10 minutes),
1518     uint32(30 minutes),
1519     uint32(1 hours),
1520     uint32(2 hours),
1521     uint32(4 hours),
1522     uint32(8 hours),
1523     uint32(16 hours),
1524     uint32(1 days),
1525     uint32(2 days),
1526     uint32(4 days),
1527     uint32(7 days)
1528     ];
1529 
1530     // An approximation of currently how many seconds are in between blocks.
1531     uint256 public secondsPerBlock = 15;
1532 
1533     /*** STORAGE ***/
1534 
1535     /// @dev An array containing the Monster struct for all Monsters in existence. The ID
1536     ///  of each monster is actually an index into this array. Note that ID 0 is a negamonster,
1537     ///  the unMonster, the mythical beast that is the parent of all gen0 monsters. A bizarre
1538     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
1539     ///  In other words, monster ID 0 is invalid... ;-)
1540     Monster[] monsters;
1541 
1542     /// @dev A mapping from monster IDs to the address that owns them. All monsters have
1543     ///  some valid owner address, even gen0 monsters are created with a non-zero owner.
1544     mapping(uint256 => address) public monsterIndexToOwner;
1545 
1546     // @dev A mapping from owner address to count of tokens that address owns.
1547     //  Used internally inside balanceOf() to resolve ownership count.
1548     mapping(address => uint256) ownershipTokenCount;
1549 
1550     /// @dev A mapping from MonsterIDs to an address that has been approved to call
1551     ///  transferFrom(). Each Monster can only have one approved address for transfer
1552     ///  at any time. A zero value means no approval is outstanding.
1553     mapping(uint256 => address) public monsterIndexToApproved;
1554 
1555     /// @dev A mapping from MonsterIDs to an address that has been approved to use
1556     ///  this Monster for siring via breedWith(). Each Monster can only have one approved
1557     ///  address for siring at any time. A zero value means no approval is outstanding.
1558     mapping(uint256 => address) public sireAllowedToAddress;
1559 
1560     /// @dev The address of the ClockAuction contract that handles sales of Monsters. This
1561     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
1562     ///  initiated every 15 minutes.
1563     SaleClockAuction public saleAuction;
1564 
1565     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
1566     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
1567     ///  after a sales and siring auction are quite different.
1568     SiringClockAuction public siringAuction;
1569 
1570     GeneScience public geneScience;
1571 
1572     /// @dev Assigns ownership of a specific Monster to an address.
1573     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1574         // Since the number of monsters is capped to 2^32 we can't overflow this
1575         ownershipTokenCount[_to]++;
1576         // transfer ownership
1577         monsterIndexToOwner[_tokenId] = _to;
1578 
1579         // When creating new monsters _from is 0x0, but we can't account that address.
1580         if (_from != address(0)) {
1581             ownershipTokenCount[_from]--;
1582             // once the monster is transferred also clear sire allowances
1583             delete sireAllowedToAddress[_tokenId];
1584             // clear any previously approved ownership exchange
1585             delete monsterIndexToApproved[_tokenId];
1586         }
1587         // Emit the transfer event.
1588         Transfer(_from, _to, _tokenId);
1589     }
1590 
1591     /// @dev An internal method that creates a new monster and stores it. This
1592     ///  method doesn't do any checking and should only be called when the
1593     ///  input data is known to be valid. Will generate both a Birth event
1594     ///  and a Transfer event.
1595     /// @param _matronId The monster ID of the matron of this monster (zero for gen0)
1596     /// @param _sireId The monster ID of the sire of this monster (zero for gen0)
1597     /// @param _generation The generation number of this monster, must be computed by caller.
1598     /// @param _genes The monster's genetic code.
1599     /// @param _owner The inital owner of this monster, must be non-zero (except for the unMonster, ID 0)
1600     function _createMonster(
1601         uint256 _matronId,
1602         uint256 _sireId,
1603         uint256 _generation,
1604         uint256 _genes,
1605         address _owner
1606     )
1607     internal
1608     returns (uint)
1609     {
1610         // These requires are not strictly necessary, our calling code should make
1611         // sure that these conditions are never broken. However! _createMonster() is already
1612         // an expensive call (for storage), and it doesn't hurt to be especially careful
1613         // to ensure our data structures are always valid.
1614         require(_matronId == uint256(uint32(_matronId)));
1615         require(_sireId == uint256(uint32(_sireId)));
1616         require(_generation == uint256(uint16(_generation)));
1617 
1618         // New monster starts with the same cooldown as parent gen/2
1619         uint16 cooldownIndex = uint16(_generation / 2);
1620         if (cooldownIndex > 13) {
1621             cooldownIndex = 13;
1622         }
1623 
1624         Monster memory _monster = Monster({
1625             genes : _genes,
1626             birthTime : uint64(now),
1627             cooldownEndBlock : 0,
1628             matronId : uint32(_matronId),
1629             sireId : uint32(_sireId),
1630             siringWithId : 0,
1631             cooldownIndex : cooldownIndex,
1632             generation : uint16(_generation)
1633             });
1634         uint256 newKittenId = monsters.push(_monster) - 1;
1635 
1636         // It's probably never going to happen, 4 billion monsters is A LOT, but
1637         // let's just be 100% sure we never let this happen.
1638         require(newKittenId == uint256(uint32(newKittenId)));
1639 
1640         // emit the birth event
1641         Birth(
1642             _owner,
1643             newKittenId,
1644             uint256(_monster.matronId),
1645             uint256(_monster.sireId),
1646             _monster.genes,
1647             uint16(_generation)
1648         );
1649 
1650         // This will assign ownership, and also emit the Transfer event as
1651         // per ERC721 draft
1652         _transfer(0, _owner, newKittenId);
1653 
1654         return newKittenId;
1655     }
1656 
1657     // Any C-level can fix how many seconds per blocks are currently observed.
1658     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
1659         require(secs < cooldowns[0]);
1660         secondsPerBlock = secs;
1661     }
1662 }
1663 
1664 
1665 
1666 
1667 
1668 /// @title The external contract that is responsible for generating metadata for the monsters,
1669 ///  it has one function that will return the data as bytes.
1670 contract ERC721Metadata {
1671     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
1672     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
1673         if (_tokenId == 1) {
1674             buffer[0] = "Hello World! :D";
1675             count = 15;
1676         } else if (_tokenId == 2) {
1677             buffer[0] = "I would definitely choose a medi";
1678             buffer[1] = "um length string.";
1679             count = 49;
1680         } else if (_tokenId == 3) {
1681             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
1682             buffer[1] = "st accumsan dapibus augue lorem,";
1683             buffer[2] = " tristique vestibulum id, libero";
1684             buffer[3] = " suscipit varius sapien aliquam.";
1685             count = 128;
1686         }
1687     }
1688 }
1689 
1690 
1691 /// @title The facet of the CryptoMonsters core contract that manages ownership, ERC-721 (draft) compliant.
1692 /// @author Axiom Zen (https://www.axiomzen.co)
1693 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
1694 ///  See the MonsterCore contract documentation to understand how the various contract facets are arranged.
1695 contract MonsterOwnership is MonsterBase, ERC721 {
1696 
1697     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
1698     string public constant name = "Ethermon";
1699     string public constant symbol = "EM";
1700 
1701     // The contract that will return monster metadata
1702     ERC721Metadata public erc721Metadata;
1703 
1704     bytes4 constant InterfaceSignature_ERC165 =
1705     bytes4(keccak256('supportsInterface(bytes4)'));
1706 
1707     bytes4 constant InterfaceSignature_ERC721 =
1708     bytes4(keccak256('name()')) ^
1709     bytes4(keccak256('symbol()')) ^
1710     bytes4(keccak256('totalSupply()')) ^
1711     bytes4(keccak256('balanceOf(address)')) ^
1712     bytes4(keccak256('ownerOf(uint256)')) ^
1713     bytes4(keccak256('approve(address,uint256)')) ^
1714     bytes4(keccak256('transfer(address,uint256)')) ^
1715     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1716     bytes4(keccak256('tokensOfOwner(address)')) ^
1717     bytes4(keccak256('tokenMetadata(uint256,string)'));
1718 
1719     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
1720     ///  Returns true for any standardized interfaces implemented by this contract. We implement
1721     ///  ERC-165 (obviously!) and ERC-721.
1722     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
1723     {
1724         // DEBUG ONLY
1725         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
1726 
1727         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
1728     }
1729 
1730     /// @dev Set the address of the sibling contract that tracks metadata.
1731     ///  CEO only.
1732     function setMetadataAddress(address _contractAddress) public onlyCEO {
1733         erc721Metadata = ERC721Metadata(_contractAddress);
1734     }
1735 
1736     // Internal utility functions: These functions all assume that their input arguments
1737     // are valid. We leave it to public methods to sanitize their inputs and follow
1738     // the required logic.
1739 
1740     /// @dev Checks if a given address is the current owner of a particular Monster.
1741     /// @param _claimant the address we are validating against.
1742     /// @param _tokenId monster id, only valid when > 0
1743     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1744         return monsterIndexToOwner[_tokenId] == _claimant;
1745     }
1746 
1747     /// @dev Checks if a given address currently has transferApproval for a particular Monster.
1748     /// @param _claimant the address we are confirming monster is approved for.
1749     /// @param _tokenId monster id, only valid when > 0
1750     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1751         return monsterIndexToApproved[_tokenId] == _claimant;
1752     }
1753 
1754     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
1755     ///  approval. Setting _approved to address(0) clears all transfer approval.
1756     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
1757     ///  _approve() and transferFrom() are used together for putting Monsters on auction, and
1758     ///  there is no value in spamming the log with Approval events in that case.
1759     function _approve(uint256 _tokenId, address _approved) internal {
1760         monsterIndexToApproved[_tokenId] = _approved;
1761     }
1762 
1763     /// @notice Returns the number of Monsters owned by a specific address.
1764     /// @param _owner The owner address to check.
1765     /// @dev Required for ERC-721 compliance
1766     function balanceOf(address _owner) public view returns (uint256 count) {
1767         return ownershipTokenCount[_owner];
1768     }
1769 
1770     /// @notice Transfers a Monster to another address. If transferring to a smart
1771     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1772     ///  CryptoMonsters specifically) or your Monster may be lost forever. Seriously.
1773     /// @param _to The address of the recipient, can be a user or contract.
1774     /// @param _tokenId The ID of the Monster to transfer.
1775     /// @dev Required for ERC-721 compliance.
1776     function transfer(
1777         address _to,
1778         uint256 _tokenId
1779     )
1780     external
1781     whenNotPaused
1782     {
1783         // Safety check to prevent against an unexpected 0x0 default.
1784         require(_to != address(0));
1785         // Disallow transfers to this contract to prevent accidental misuse.
1786         // The contract should never own any monsters (except very briefly
1787         // after a gen0 monster is created and before it goes on auction).
1788         require(_to != address(this));
1789         // Disallow transfers to the auction contracts to prevent accidental
1790         // misuse. Auction contracts should only take ownership of monsters
1791         // through the allow + transferFrom flow.
1792         require(_to != address(saleAuction));
1793         require(_to != address(siringAuction));
1794 
1795         // You can only send your own monster.
1796         require(_owns(msg.sender, _tokenId));
1797 
1798             // Reassign ownership, clear pending approvals, emit Transfer event.
1799         _transfer(msg.sender, _to, _tokenId);
1800     }
1801 
1802     /// @notice Grant another address the right to transfer a specific Monster via
1803     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1804     /// @param _to The address to be granted transfer approval. Pass address(0) to
1805     ///  clear all approvals.
1806     /// @param _tokenId The ID of the Monster that can be transferred if this call succeeds.
1807     /// @dev Required for ERC-721 compliance.
1808     function approve(
1809         address _to,
1810         uint256 _tokenId
1811     )
1812     external
1813     whenNotPaused
1814     {
1815         // Only an owner can grant transfer approval.
1816         require(_owns(msg.sender, _tokenId));
1817 
1818         // Register the approval (replacing any previous approval).
1819         _approve(_tokenId, _to);
1820 
1821         // Emit approval event.
1822         Approval(msg.sender, _to, _tokenId);
1823     }
1824 
1825     /// @notice Transfer a Monster owned by another address, for which the calling address
1826     ///  has previously been granted transfer approval by the owner.
1827     /// @param _from The address that owns the Monster to be transfered.
1828     /// @param _to The address that should take ownership of the Monster. Can be any address,
1829     ///  including the caller.
1830     /// @param _tokenId The ID of the Monster to be transferred.
1831     /// @dev Required for ERC-721 compliance.
1832     function transferFrom(
1833         address _from,
1834         address _to,
1835         uint256 _tokenId
1836     )
1837     external
1838     whenNotPaused
1839     {
1840         // Safety check to prevent against an unexpected 0x0 default.
1841         require(_to != address(0));
1842         // Disallow transfers to this contract to prevent accidental misuse.
1843         // The contract should never own any monsters (except very briefly
1844         // after a gen0 monster is created and before it goes on auction).
1845         require(_to != address(this));
1846         // Check for approval and valid ownership
1847         require(_approvedFor(msg.sender, _tokenId));
1848         require(_owns(_from, _tokenId));
1849 
1850         // Reassign ownership (also clears pending approvals and emits Transfer event).
1851         _transfer(_from, _to, _tokenId);
1852     }
1853 
1854     /// @notice Returns the total number of Monsters currently in existence.
1855     /// @dev Required for ERC-721 compliance.
1856     function totalSupply() public view returns (uint) {
1857         return monsters.length - 1;
1858     }
1859 
1860     /// @notice Returns the address currently assigned ownership of a given Monster.
1861     /// @dev Required for ERC-721 compliance.
1862     function ownerOf(uint256 _tokenId)
1863     external
1864     view
1865     returns (address owner)
1866     {
1867         owner = monsterIndexToOwner[_tokenId];
1868 
1869         require(owner != address(0));
1870     }
1871 
1872     /// @notice Returns a list of all Monster IDs assigned to an address.
1873     /// @param _owner The owner whose Monsters we are interested in.
1874     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1875     ///  expensive (it walks the entire Monster array looking for monsters belonging to owner),
1876     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
1877     ///  not contract-to-contract calls.
1878     function tokensOfOwner(address _owner) external view returns (uint256[] ownerTokens) {
1879         uint256 tokenCount = balanceOf(_owner);
1880 
1881         if (tokenCount == 0) {
1882             // Return an empty array
1883             return new uint256[](0);
1884         } else {
1885             uint256[] memory result = new uint256[](tokenCount);
1886             uint256 totalMonsters = totalSupply();
1887             uint256 resultIndex = 0;
1888 
1889             // We count on the fact that all monsters have IDs starting at 1 and increasing
1890             // sequentially up to the totalMonster count.
1891             uint256 monsterId;
1892 
1893             for (monsterId = 1; monsterId <= totalMonsters; monsterId++) {
1894                 if (monsterIndexToOwner[monsterId] == _owner) {
1895                     result[resultIndex] = monsterId;
1896                     resultIndex++;
1897                 }
1898             }
1899 
1900             return result;
1901         }
1902     }
1903 
1904     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
1905     ///  This method is licenced under the Apache License.
1906     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
1907     function _memcpy(uint _dest, uint _src, uint _len) private view {
1908         // Copy word-length chunks while possible
1909         for (; _len >= 32; _len -= 32) {
1910             assembly {
1911                 mstore(_dest, mload(_src))
1912             }
1913             _dest += 32;
1914             _src += 32;
1915         }
1916 
1917         // Copy remaining bytes
1918         uint256 mask = 256 ** (32 - _len) - 1;
1919         assembly {
1920             let srcpart := and(mload(_src), not(mask))
1921             let destpart := and(mload(_dest), mask)
1922             mstore(_dest, or(destpart, srcpart))
1923         }
1924     }
1925 
1926     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
1927     ///  This method is licenced under the Apache License.
1928     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
1929     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
1930         var outputString = new string(_stringLength);
1931         uint256 outputPtr;
1932         uint256 bytesPtr;
1933 
1934         assembly {
1935             outputPtr := add(outputString, 32)
1936             bytesPtr := _rawBytes
1937         }
1938 
1939         _memcpy(outputPtr, bytesPtr, _stringLength);
1940 
1941         return outputString;
1942     }
1943 
1944     /// @notice Returns a URI pointing to a metadata package for this token conforming to
1945     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
1946     /// @param _tokenId The ID number of the Monster whose metadata should be returned.
1947     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
1948         require(erc721Metadata != address(0));
1949         bytes32[4] memory buffer;
1950         uint256 count;
1951         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
1952 
1953         return _toString(buffer, count);
1954     }
1955 }
1956 
1957 
1958 
1959 /// @title A facet of MonsterCore that manages Monster siring, gestation, and birth.
1960 /// @author Axiom Zen (https://www.axiomzen.co)
1961 /// @dev See the MonsterCore contract documentation to understand how the various contract facets are arranged.
1962 contract MonsterBreeding is MonsterOwnership {
1963 
1964     /// @dev The Pregnant event is fired when two monsters successfully breed and the pregnancy
1965     ///  timer begins for the matron.
1966     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
1967 
1968     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
1969     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
1970     ///  the COO role as the gas price changes.
1971     uint256 public autoBirthFee = 8 finney;
1972 
1973     // Keeps track of number of pregnant monsters.
1974     uint256 public pregnantMonsters;
1975 
1976     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
1977     ///  genetic combination algorithm.
1978 
1979     /// @dev Update the address of the genetic contract, can only be called by the CEO.
1980     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
1981     function setGeneScienceAddress(address _address) external onlyCEO {
1982         GeneScience candidateContract = GeneScience(_address);
1983 
1984         require(candidateContract.isGeneScience());
1985 
1986         // Set the new contract address
1987         geneScience = candidateContract;
1988     }
1989 
1990     /// @dev Checks that a given monster is able to breed. Requires that the
1991     ///  current cooldown is finished (for sires) and also checks that there is
1992     ///  no pending pregnancy.
1993     function _isReadyToBreed(Monster _monster) internal view returns (bool) {
1994         // In addition to checking the cooldownEndBlock, we also need to check to see if
1995         // the monster has a pending birth; there can be some period of time between the end
1996         // of the pregnacy timer and the birth event.
1997         return (_monster.siringWithId == 0) && (_monster.cooldownEndBlock <= uint64(block.number));
1998     }
1999 
2000     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
2001     ///  and matron have the same owner, or if the sire has given siring permission to
2002     ///  the matron's owner (via approveSiring()).
2003     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
2004         address matronOwner = monsterIndexToOwner[_matronId];
2005         address sireOwner = monsterIndexToOwner[_sireId];
2006 
2007         // Siring is okay if they have same owner, or if the matron's owner was given
2008         // permission to breed with this sire.
2009         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
2010     }
2011 
2012     /// @dev Set the cooldownEndTime for the given Monster, based on its current cooldownIndex.
2013     ///  Also increments the cooldownIndex (unless it has hit the cap).
2014     /// @param _monster A reference to the Monster in storage which needs its timer started.
2015     function _triggerCooldown(Monster storage _monster) internal {
2016         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
2017         _monster.cooldownEndBlock = uint64((cooldowns[_monster.cooldownIndex] / secondsPerBlock) + block.number);
2018 
2019         // Increment the breeding count, clamping it at 13, which is the length of the
2020         // cooldowns array. We could check the array size dynamically, but hard-coding
2021         // this as a constant saves gas. Yay, Solidity!
2022         if (_monster.cooldownIndex < 13) {
2023             _monster.cooldownIndex += 1;
2024         }
2025     }
2026 
2027     /// @notice Grants approval to another user to sire with one of your Monsters.
2028     /// @param _addr The address that will be able to sire with your Monster. Set to
2029     ///  address(0) to clear all siring approvals for this Monster.
2030     /// @param _sireId A Monster that you own that _addr will now be able to sire with.
2031     /// KERNYS 외부에서 아빠가 호출할 수 있다. (meta mask로)
2032     function approveSiring(address _addr, uint256 _sireId)
2033     external
2034     whenNotPaused
2035     {
2036         require(_owns(msg.sender, _sireId));
2037         sireAllowedToAddress[_sireId] = _addr;
2038     }
2039 
2040     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
2041     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
2042     ///  by the autobirth daemon).
2043     function setAutoBirthFee(uint256 val) external onlyCOO {
2044         autoBirthFee = val;
2045     }
2046 
2047     /// @dev Checks to see if a given Monster is pregnant and (if so) if the gestation
2048     ///  period has passed.
2049     function _isReadyToGiveBirth(Monster _matron) private view returns (bool) {
2050         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
2051     }
2052 
2053     /// @notice Checks that a given monster is able to breed (i.e. it is not pregnant or
2054     ///  in the middle of a siring cooldown).
2055     /// @param _monsterId reference the id of the monster, any user can inquire about it
2056     function isReadyToBreed(uint256 _monsterId)
2057     public
2058     view
2059     returns (bool)
2060     {
2061         require(_monsterId > 0);
2062         Monster storage monster = monsters[_monsterId];
2063         return _isReadyToBreed(monster);
2064     }
2065 
2066     /// @dev Checks whether a monster is currently pregnant.
2067     /// @param _monsterId reference the id of the monster, any user can inquire about it
2068     function isPregnant(uint256 _monsterId)
2069     public
2070     view
2071     returns (bool)
2072     {
2073         require(_monsterId > 0);
2074         // A monster is pregnant if and only if this field is set
2075         return monsters[_monsterId].siringWithId != 0;
2076     }
2077 
2078     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
2079     ///  check ownership permissions (that is up to the caller).
2080     /// @param _matron A reference to the Monster struct of the potential matron.
2081     /// @param _matronId The matron's ID.
2082     /// @param _sire A reference to the Monster struct of the potential sire.
2083     /// @param _sireId The sire's ID
2084     function _isValidMatingPair(
2085         Monster storage _matron,
2086         uint256 _matronId,
2087         Monster storage _sire,
2088         uint256 _sireId
2089     )
2090     private
2091     view
2092     returns (bool)
2093     {
2094         // A Monster can't breed with itself!
2095         if (_matronId == _sireId) {
2096             return false;
2097         }
2098 
2099         // Monsters can't breed with their parents.
2100         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
2101             return false;
2102         }
2103         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
2104             return false;
2105         }
2106 
2107         // We can short circuit the sibling check (below) if either monster is
2108         // gen zero (has a matron ID of zero).
2109         if (_sire.matronId == 0 || _matron.matronId == 0) {
2110             return true;
2111         }
2112 
2113         // Monsters can't breed with full or half siblings.
2114         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
2115             return false;
2116         }
2117         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
2118             return false;
2119         }
2120 
2121         // Everything seems cool! Let's get DTF.
2122         return true;
2123     }
2124 
2125     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
2126     ///  breeding via auction (i.e. skips ownership and siring approval checks).
2127     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
2128     internal
2129     view
2130     returns (bool)
2131     {
2132         Monster storage matron = monsters[_matronId];
2133         Monster storage sire = monsters[_sireId];
2134         return _isValidMatingPair(matron, _matronId, sire, _sireId);
2135     }
2136 
2137     /// @notice Checks to see if two monsters can breed together, including checks for
2138     ///  ownership and siring approvals. Does NOT check that both monsters are ready for
2139     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
2140     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
2141     /// @param _matronId The ID of the proposed matron.
2142     /// @param _sireId The ID of the proposed sire.
2143     function canBreedWith(uint256 _matronId, uint256 _sireId)
2144     external
2145     view
2146     returns (bool)
2147     {
2148         require(_matronId > 0);
2149         require(_sireId > 0);
2150         Monster storage matron = monsters[_matronId];
2151         Monster storage sire = monsters[_sireId];
2152         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
2153         _isSiringPermitted(_sireId, _matronId);
2154     }
2155 
2156     /// @dev Internal utility function to initiate breeding, assumes that all breeding
2157     ///  requirements have been checked.
2158     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
2159         // Grab a reference to the Monsters from storage.
2160         Monster storage sire = monsters[_sireId];
2161         Monster storage matron = monsters[_matronId];
2162 
2163         // Mark the matron as pregnant, keeping track of who the sire is.
2164         matron.siringWithId = uint32(_sireId);
2165 
2166         // Trigger the cooldown for both parents.
2167         _triggerCooldown(sire);
2168         _triggerCooldown(matron);
2169 
2170         // Clear siring permission for both parents. This may not be strictly necessary
2171         // but it's likely to avoid confusion!
2172         delete sireAllowedToAddress[_matronId];
2173         delete sireAllowedToAddress[_sireId];
2174 
2175         // Every time a monster gets pregnant, counter is incremented.
2176         pregnantMonsters++;
2177 
2178         // Emit the pregnancy event.
2179         Pregnant(monsterIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
2180     }
2181 
2182     /// @notice Breed a Monster you own (as matron) with a sire that you own, or for which you
2183     ///  have previously been given Siring approval. Will either make your monster pregnant, or will
2184     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
2185     /// @param _matronId The ID of the Monster acting as matron (will end up pregnant if successful)
2186     /// @param _sireId The ID of the Monster acting as sire (will begin its siring cooldown if successful)
2187     function breedWithAuto(uint256 _matronId, uint256 _sireId)
2188     external
2189     payable
2190     whenNotPaused
2191     {
2192         // Checks for payment.
2193         require(msg.value >= autoBirthFee);
2194 
2195         // Caller must own the matron.
2196         require(_owns(msg.sender, _matronId));
2197 
2198         // Neither sire nor matron are allowed to be on auction during a normal
2199         // breeding operation, but we don't need to check that explicitly.
2200         // For matron: The caller of this function can't be the owner of the matron
2201         //   because the owner of a Monster on auction is the auction house, and the
2202         //   auction house will never call breedWith().
2203         // For sire: Similarly, a sire on auction will be owned by the auction house
2204         //   and the act of transferring ownership will have cleared any oustanding
2205         //   siring approval.
2206         // Thus we don't need to spend gas explicitly checking to see if either monster
2207         // is on auction.
2208 
2209         // Check that matron and sire are both owned by caller, or that the sire
2210         // has given siring permission to caller (i.e. matron's owner).
2211         // Will fail for _sireId = 0
2212         require(_isSiringPermitted(_sireId, _matronId));
2213 
2214         // Grab a reference to the potential matron
2215         Monster storage matron = monsters[_matronId];
2216 
2217         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
2218         require(_isReadyToBreed(matron));
2219 
2220         // Grab a reference to the potential sire
2221         Monster storage sire = monsters[_sireId];
2222 
2223         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
2224         require(_isReadyToBreed(sire));
2225 
2226         // Test that these monsters are a valid mating pair.
2227         require(_isValidMatingPair(
2228                 matron,
2229                 _matronId,
2230                 sire,
2231                 _sireId
2232             ));
2233 
2234         // All checks passed, monster gets pregnant!
2235         _breedWith(_matronId, _sireId);
2236     }
2237 
2238     /// @notice Have a pregnant Monster give birth!
2239     /// @param _matronId A Monster ready to give birth.
2240     /// @return The Monster ID of the new monster.
2241     /// @dev Looks at a given Monster and, if pregnant and if the gestation period has passed,
2242     ///  combines the genes of the two parents to create a new monster. The new Monster is assigned
2243     ///  to the current owner of the matron. Upon successful completion, both the matron and the
2244     ///  new monster will be ready to breed again. Note that anyone can call this function (if they
2245     ///  are willing to pay the gas!), but the new monster always goes to the mother's owner.
2246     function giveBirth(uint256 _matronId)
2247     external
2248     onlyCOO
2249     whenNotPaused
2250     returns (uint256)
2251     {
2252         // Grab a reference to the matron in storage.
2253         Monster storage matron = monsters[_matronId];
2254 
2255         // Check that the matron is a valid monster.
2256         require(matron.birthTime != 0);
2257 
2258         // Check that the matron is pregnant, and that its time has come!
2259         require(_isReadyToGiveBirth(matron));
2260 
2261         // Grab a reference to the sire in storage.
2262         uint256 sireId = matron.siringWithId;
2263         Monster storage sire = monsters[sireId];
2264 
2265         // Determine the higher generation number of the two parents
2266         uint16 parentGen = matron.generation;
2267         if (sire.generation > matron.generation) {
2268             parentGen = sire.generation;
2269         }
2270 
2271         // Call the sooper-sekret gene mixing operation.
2272         // targetBlock
2273         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
2274 
2275         // Make the new monster!
2276         address owner = monsterIndexToOwner[_matronId];
2277         uint256 monsterId = _createMonster(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
2278 
2279         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
2280         // set is what marks a matron as being pregnant.)
2281         delete matron.siringWithId;
2282 
2283         // Every time a monster gives birth counter is decremented.
2284         pregnantMonsters--;
2285 
2286         // Send the balance fee to the person who made birth happen.
2287         msg.sender.send(autoBirthFee);
2288 
2289         // return the new monster's ID
2290         return monsterId;
2291     }
2292 }
2293 
2294 
2295 
2296 
2297 
2298 
2299 
2300 
2301 
2302 
2303 
2304 
2305 /// @title Handles creating auctions for sale and siring of monsters.
2306 ///  This wrapper of ReverseAuction exists only so that users can create
2307 ///  auctions with only one transaction.
2308 contract MonsterAuction is MonsterBreeding {
2309 
2310     // @notice The auction contract variables are defined in MonsterBase to allow
2311     //  us to refer to them in MonsterOwnership to prevent accidental transfers.
2312     // `saleAuction` refers to the auction for gen0 and p2p sale of monsters.
2313     // `siringAuction` refers to the auction for siring rights of monsters.
2314 
2315     /// @dev Sets the reference to the sale auction.
2316     /// @param _address - Address of sale contract.
2317     function setSaleAuctionAddress(address _address) external onlyCEO {
2318         SaleClockAuction candidateContract = SaleClockAuction(_address);
2319 
2320         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2321         require(candidateContract.isSaleClockAuction());
2322 
2323         // Set the new contract address
2324         saleAuction = candidateContract;
2325     }
2326 
2327     /// @dev Sets the reference to the siring auction.
2328     /// @param _address - Address of siring contract.
2329     function setSiringAuctionAddress(address _address) external onlyCEO {
2330         SiringClockAuction candidateContract = SiringClockAuction(_address);
2331 
2332         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2333         require(candidateContract.isSiringClockAuction());
2334 
2335         // Set the new contract address
2336         siringAuction = candidateContract;
2337     }
2338 
2339     /// @dev Put a monster up for auction.
2340     ///  Does some ownership trickery to create auctions in one tx.
2341     function createSaleAuction(
2342         uint256 _monsterId,
2343         uint256 _startingPrice,
2344         uint256 _endingPrice,
2345         uint256 _duration
2346     )
2347     external
2348     whenNotPaused
2349     {
2350         // Auction contract checks input sizes
2351         // If monster is already on any auction, this will throw
2352         // because it will be owned by the auction contract.
2353         require(_owns(msg.sender, _monsterId));
2354         // Ensure the monster is not pregnant to prevent the auction
2355         // contract accidentally receiving ownership of the child.
2356         // NOTE: the monster IS allowed to be in a cooldown.
2357         require(!isPregnant(_monsterId));
2358         _approve(_monsterId, saleAuction);
2359         // Sale auction throws if inputs are invalid and clears
2360         // transfer and sire approval after escrowing the monster.
2361         saleAuction.createAuction(
2362             _monsterId,
2363             _startingPrice,
2364             _endingPrice,
2365             _duration,
2366             msg.sender
2367         );
2368     }
2369 
2370     /// @dev Put a monster up for auction to be sire.
2371     ///  Performs checks to ensure the monster can be sired, then
2372     ///  delegates to reverse auction.
2373     function createSiringAuction(
2374         uint256 _monsterId,
2375         uint256 _startingPrice,
2376         uint256 _endingPrice,
2377         uint256 _duration
2378     )
2379     external
2380     whenNotPaused
2381     {
2382         // Auction contract checks input sizes
2383         // If monster is already on any auction, this will throw
2384         // because it will be owned by the auction contract.
2385         require(_owns(msg.sender, _monsterId));
2386         require(isReadyToBreed(_monsterId));
2387         _approve(_monsterId, siringAuction);
2388         // Siring auction throws if inputs are invalid and clears
2389         // transfer and sire approval after escrowing the monster.
2390         siringAuction.createAuction(
2391             _monsterId,
2392             _startingPrice,
2393             _endingPrice,
2394             _duration,
2395             msg.sender
2396         );
2397     }
2398 
2399     /// @dev Completes a siring auction by bidding.
2400     ///  Immediately breeds the winning matron with the sire on auction.
2401     /// @param _sireId - ID of the sire on auction.
2402     /// @param _matronId - ID of the matron owned by the bidder.
2403     function bidOnSiringAuction(
2404         uint256 _sireId,
2405         uint256 _matronId
2406     )
2407     external
2408     payable
2409     whenNotPaused
2410     {
2411         // Auction contract checks input sizes
2412         require(_owns(msg.sender, _matronId));
2413         require(isReadyToBreed(_matronId));
2414         require(_canBreedWithViaAuction(_matronId, _sireId));
2415 
2416         // Define the current price of the auction.
2417         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
2418         require(msg.value >= currentPrice + autoBirthFee);
2419 
2420         // Siring auction will throw if the bid fails.
2421         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
2422         _breedWith(uint32(_matronId), uint32(_sireId));
2423     }
2424 
2425     /// @dev Transfers the balance of the sale auction contract
2426     /// to the MonsterCore contract. We use two-step withdrawal to
2427     /// prevent two transfer calls in the auction bid function.
2428     function withdrawAuctionBalances() external onlyCLevel {
2429         saleAuction.withdrawBalance();
2430         siringAuction.withdrawBalance();
2431     }
2432 }
2433 
2434 
2435 /// @title all functions related to creating monsters
2436 contract MonsterMinting is MonsterAuction {
2437 
2438     // Limits the number of monsters the contract owner can ever create.
2439     uint256 public constant PROMO_CREATION_LIMIT = 5000;
2440     uint256 public constant GEN0_CREATION_LIMIT = 45000;
2441 
2442     // Constants for gen0 auctions.
2443     uint256 public constant GEN0_STARTING_PRICE = 10 finney;
2444     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
2445 
2446     // Counts the number of monsters the contract owner has created.
2447     uint256 public promoCreatedCount;
2448     uint256 public gen0CreatedCount;
2449 
2450     /// @dev we can create promo monsters, up to a limit. Only callable by COO
2451     /// @param _genes the encoded genes of the monster to be created, any value is accepted
2452     /// @param _owner the future owner of the created monsters. Default to contract COO
2453     function createPromoMonster(uint256 _genes, address _owner) external onlyCOO {
2454         address monsterOwner = _owner;
2455         if (monsterOwner == address(0)) {
2456             monsterOwner = cooAddress;
2457         }
2458         require(promoCreatedCount < PROMO_CREATION_LIMIT);
2459 
2460         promoCreatedCount++;
2461         _createMonster(0, 0, 0, _genes, monsterOwner);
2462     }
2463 
2464     /// @dev Creates a new gen0 monster with the given genes and
2465     ///  creates an auction for it.
2466     function createGen0Auction(uint256 _genes) external onlyCOO {
2467         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
2468 
2469         uint256 genes = _genes;
2470         if(genes == 0)
2471             genes = geneScience.randomGenes();
2472 
2473         uint256 monsterId = _createMonster(0, 0, 0, genes, address(this));
2474         _approve(monsterId, saleAuction);
2475 
2476         saleAuction.createAuction(
2477             monsterId,
2478             _computeNextGen0Price(),
2479             0,
2480             GEN0_AUCTION_DURATION,
2481             address(this)
2482         );
2483 
2484         gen0CreatedCount++;
2485     }
2486 
2487     /// @dev Computes the next gen0 auction starting price, given
2488     ///  the average of the past 5 prices + 50%.
2489     function _computeNextGen0Price() internal view returns (uint256) {
2490         uint256 avePrice = saleAuction.averageGen0SalePrice();
2491 
2492         // Sanity check to ensure we don't overflow arithmetic
2493         require(avePrice == uint256(uint128(avePrice)));
2494 
2495         uint256 nextPrice = avePrice + (avePrice / 2);
2496 
2497         // We never auction for less than starting price
2498         if (nextPrice < GEN0_STARTING_PRICE) {
2499             nextPrice = GEN0_STARTING_PRICE;
2500         }
2501 
2502         return nextPrice;
2503     }
2504 }
2505 
2506 
2507 /// @title CryptoMonsters: Collectible, breedable, and oh-so-adorable monsters on the Ethereum blockchain.
2508 /// @author Axiom Zen (https://www.axiomzen.co)
2509 /// @dev The main CryptoMonsters contract, keeps track of monsters so they don't wander around and get lost.
2510 contract MonsterCore is MonsterMinting {
2511 
2512     // This is the main CryptoMonsters contract. In order to keep our code seperated into logical sections,
2513     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
2514     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
2515     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
2516     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
2517     // monster ownership. The genetic combination algorithm is kept seperate so we can open-source all of
2518     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
2519     // Don't worry, I'm sure someone will reverse engineer it soon enough!
2520     //
2521     // Secondly, we break the core contract into multiple files using inheritence, one for each major
2522     // facet of functionality of CK. This allows us to keep related code bundled together while still
2523     // avoiding a single giant file with everything in it. The breakdown is as follows:
2524     //
2525     //      - MonsterBase: This is where we define the most fundamental code shared throughout the core
2526     //             functionality. This includes our main data storage, constants and data types, plus
2527     //             internal functions for managing these items.
2528     //
2529     //      - MonsterAccessControl: This contract manages the various addresses and constraints for operations
2530     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
2531     //
2532     //      - MonsterOwnership: This provides the methods required for basic non-fungible token
2533     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
2534     //
2535     //      - MonsterBreeding: This file contains the methods necessary to breed monsters together, including
2536     //             keeping track of siring offers, and relies on an external genetic combination contract.
2537     //
2538     //      - MonsterAuctions: Here we have the public methods for auctioning or bidding on monsters or siring
2539     //             services. The actual auction functionality is handled in two sibling contracts (one
2540     //             for sales and one for siring), while auction creation and bidding is mostly mediated
2541     //             through this facet of the core contract.
2542     //
2543     //      - MonsterMinting: This final facet contains the functionality we use for creating new gen0 monsters.
2544     //             We can make up to 5000 "promo" monsters that can be given away (especially important when
2545     //             the community is new), and all others can only be created and then immediately put up
2546     //             for auction via an algorithmically determined starting price. Regardless of how they
2547     //             are created, there is a hard limit of 50k gen0 monsters. After that, it's all up to the
2548     //             community to breed, breed, breed!
2549 
2550     // Set in case the core contract is broken and an upgrade is required
2551     address public newContractAddress;
2552 
2553     /// @notice Creates the main CryptoMonsters smart contract instance.
2554     function MonsterCore() public {
2555         // Starts paused.
2556         paused = false;
2557 
2558         // the creator of the contract is the initial CEO
2559         ceoAddress = msg.sender;
2560 
2561         // the creator of the contract is also the initial COO
2562         cooAddress = msg.sender;
2563 
2564         //
2565         cfoAddress = msg.sender;
2566 
2567         // start with the mythical monster 0 - so we don't have generation-0 parent issues
2568         _createMonster(0, 0, 0, uint256(-1), address(0));
2569     }
2570 
2571     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
2572     ///  breaking bug. This method does nothing but keep track of the new contract and
2573     ///  emit a message indimonstering that the new address is set. It's up to clients of this
2574     ///  contract to update to the new contract address in that case. (This contract will
2575     ///  be paused indefinitely if such an upgrade takes place.)
2576     /// @param _v2Address new address
2577     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2578         // See README.md for updgrade plan
2579         newContractAddress = _v2Address;
2580         ContractUpgrade(_v2Address);
2581     }
2582 
2583     /// @notice No tipping!
2584     /// @dev Reject all Ether from being sent here, unless it's from one of the
2585     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2586     function() external payable {
2587         require(
2588             msg.sender == address(saleAuction) ||
2589             msg.sender == address(siringAuction)
2590         );
2591     }
2592 
2593     /// @notice Returns all the relevant information about a specific monster.
2594     /// @param _id The ID of the monster of interest.
2595     function getMonster(uint256 _id)
2596     external
2597     view
2598     returns (
2599         bool isGestating,
2600         bool isReady,
2601         uint256 cooldownIndex,
2602         uint256 nextActionAt,
2603         uint256 siringWithId,
2604         uint256 birthTime,
2605         uint256 matronId,
2606         uint256 sireId,
2607         uint256 generation,
2608         uint256 genes
2609     ) {
2610         Monster storage monster = monsters[_id];
2611 
2612         // if this variable is 0 then it's not gestating
2613         isGestating = (monster.siringWithId != 0);
2614         isReady = (monster.cooldownEndBlock <= block.number);
2615         cooldownIndex = uint256(monster.cooldownIndex);
2616         nextActionAt = uint256(monster.cooldownEndBlock);
2617         siringWithId = uint256(monster.siringWithId);
2618         birthTime = uint256(monster.birthTime);
2619         matronId = uint256(monster.matronId);
2620         sireId = uint256(monster.sireId);
2621         generation = uint256(monster.generation);
2622         genes = monster.genes;
2623     }
2624 
2625     /// @dev Override unpause so it requires all external contract addresses
2626     ///  to be set before contract can be unpaused. Also, we can't have
2627     ///  newContractAddress set either, because then the contract was upgraded.
2628     /// @notice This is public rather than external so we can call super.unpause
2629     ///  without using an expensive CALL.
2630     function unpause() public onlyCEO whenPaused {
2631         require(saleAuction != address(0));
2632         require(siringAuction != address(0));
2633         require(geneScience != address(0));
2634         require(newContractAddress == address(0));
2635 
2636         // Actually unpause the contract.
2637         super.unpause();
2638     }
2639 
2640     // @dev Allows the CFO to capture the balance available to the contract.
2641     function withdrawBalance() external onlyCFO {
2642         uint256 balance = this.balance;
2643         // Subtract all the currently pregnant monsters we have, plus 1 of margin.
2644         uint256 subtractFees = (pregnantMonsters + 1) * autoBirthFee;
2645 
2646         if (balance > subtractFees) {
2647             cfoAddress.send(balance - subtractFees);
2648         }
2649     }
2650 }