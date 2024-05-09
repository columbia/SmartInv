1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11   address public ethAddress;
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20     ethAddress = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 contract Token {
47     uint256 public _totalSupply;
48     function balanceOf(address _owner) constant returns (uint256 balance);
49     function transfer(address _to, uint256 _value) returns (bool success);
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
51     function approve(address _spender, uint256 _value) returns (bool success);
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 /**
59  * @title       Token
60  * @dev         ERC-20 Standard Token
61  */
62 contract StandardToken is Token {
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65       if (balances[msg.sender] >= _value && _value > 0) {
66         balances[msg.sender] -= _value;
67         balances[_to] += _value;
68         Transfer(msg.sender, _to, _value);
69         return true;
70       } else {
71         return false;
72       }
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
77         balances[_to] += _value;
78         balances[_from] -= _value;
79         allowed[_from][msg.sender] -= _value;
80         Transfer(_from, _to, _value);
81         return true;
82       } else {
83         return false;
84       }
85     }
86 
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100 
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103     uint256 public totalSupply;
104 }
105 
106 /// @title ERC-20 Auction Base
107 /// @dev Contains models, variables, and internal methods for the auction.
108 /// @notice We omit a fallback function to prevent accidental sends to this contract.
109 /// @author Fazri Zubair, Farhan Khwaja (Lucid Sight, Inc.)
110 contract AuctionBase {
111     // Represents an auction on an FT (ERC-20)
112     struct Auction {
113         // Current owner of FT (ERC-20)
114         address seller;
115         // Price (in wei) at beginning of auction
116         uint128 startingPrice;
117         // Price (in wei) at end of auction
118         uint128 endingPrice;
119         // Duration (in seconds) of auction
120         uint64 duration;
121         // Time when auction started
122         // NOTE: 0 if this auction has been concluded
123         uint64 startedAt;
124         // Token Quantity
125         uint256 tokenQuantity;
126         // Token Address
127         address tokenAddress;
128         // Auction number of this auction wrt tokenAddress
129         uint256 auctionNumber;
130     }
131 
132     /// ERC-20 Auction Contract Address
133     address public cryptiblesAuctionContract;
134 
135     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
136     // Values 0-10,000 map to 0%-100%
137     uint256 public ownerCut = 375;
138 
139     // Map to keep a track on number of auctions by an owner
140     mapping (address => uint256) auctionCounter;
141 
142     // Map from token,owner to their corresponding auction.
143     mapping (address => mapping (uint256 => Auction)) tokensAuction;
144 
145     event AuctionCreated(address tokenAddress, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 quantity, uint256 auctionNumber, uint64 startedAt);
146     event AuctionWinner(address tokenAddress, uint256 totalPrice, address winner, uint256 quantity, uint256 auctionNumber);
147     event AuctionCancelled(address tokenAddress, address sellerAddress, uint256 auctionNumber, uint256 quantity);
148     event EtherWithdrawed(uint256 value);
149 
150     /// @dev Returns true if the claimant owns the token.
151     /// @param _claimant - Address claiming to own the token.
152     /// @param _totalTokens - Check total tokens being put on auction against user balance
153     function _owns(address _tokenAddress, address _claimant, uint256 _totalTokens) internal view returns (bool) {
154         StandardToken tokenContract = StandardToken(_tokenAddress);
155         return (tokenContract.balanceOf(_claimant) >= _totalTokens);
156     }
157 
158     /// @dev Escrows the ERC-20 Token, assigning ownership to this contract.
159     /// Throws if the escrow fails.
160     /// @param _owner - Current owner address of token to escrow.
161     /// @param _totalTokens - Number of tokens (ERC-20) to 
162     function _escrow(address _tokenAddress, address _owner, uint256 _totalTokens) internal {
163         // it will throw if transfer fails
164         StandardToken tokenContract = StandardToken(_tokenAddress);
165         tokenContract.transferFrom(_owner, this, _totalTokens);
166     }
167 
168     /// @dev Transfers an Erc-20 Token owned by this contract to another address.
169     /// Returns true if the transfer succeeds.
170     /// @param _receiver - Address to transfer ERC-20 Token to.
171     /// @param _totalTokens - Tokens to transfer
172     function _transfer(address _tokenAddress, address _receiver, uint256 _totalTokens) internal {
173         // it will throw if transfer fails
174         StandardToken tokenContract = StandardToken(_tokenAddress);
175         tokenContract.transfer(_receiver, _totalTokens);
176     }
177 
178     /// @dev Adds an auction to the list of open auctions. Also fires the
179     ///  AuctionCreated event.
180     /// @param _tokenAddress The address of the token to be put on auction.
181     /// @param _auction Auction to add.
182     function _addAuction(address _tokenAddress, Auction _auction) internal {
183         // Require that all auctions have a duration of
184         // at least one minute.
185         require(_auction.duration >= 1 minutes);
186         
187         AuctionCreated(
188             _tokenAddress,
189             uint256(_auction.startingPrice),
190             uint256(_auction.endingPrice),
191             uint256(_auction.duration),
192             uint256(_auction.tokenQuantity),
193             uint256(_auction.auctionNumber),
194             uint64(_auction.startedAt)
195         );
196     }
197 
198     /// @dev Cancels an auction unconditionally.
199     function _cancelAuction(address _tokenAddress, uint256 _auctionNumber) internal {
200         // Get a reference to the auction struct
201         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
202         address seller = auction.seller;
203         uint256 tokenQuantity = auction.tokenQuantity;
204 
205         _removeAuction(_tokenAddress, _auctionNumber);
206         _transfer(_tokenAddress, seller, tokenQuantity);
207         AuctionCancelled(_tokenAddress, seller, _auctionNumber, tokenQuantity);
208     }
209 
210     /// @dev Computes the price and transfers winnings.
211     /// Does NOT transfer ownership of token.
212     function _bid(address _tokenAddress, uint256 _auctionNumber, uint256 _bidAmount)
213         internal
214     {
215         // Get a reference to the auction struct
216         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
217 
218         // Explicitly check that this auction is currently live.
219         // (Because of how Ethereum mappings work, we can't just count
220         // on the lookup above failing. An invalid _tokenAddress will just
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
231         uint256 quantity = auction.tokenQuantity;
232 
233         // The bid is good! Remove the auction before sending the fees
234         // to the sender so we can't have a reentrancy attack.
235         _removeAuction(_tokenAddress, _auctionNumber);
236 
237         // Transfer proceeds to seller (if there are any!)
238         if (price > 0) {
239             // Calculate the auctioneer's cut.
240             // (NOTE: _computeCut() is guaranteed to return a
241             // value <= price, so this subtraction can't go negative.)
242             uint256 auctioneerCut = _computeCut(price);
243             uint256 sellerProceeds = price - auctioneerCut;
244 
245             // NOTE: Doing a transfer() in the middle of a complex
246             // method like this is generally discouraged because of
247             // reentrancy attacks and DoS attacks if the seller is
248             // a contract with an invalid fallback function. We explicitly
249             // guard against reentrancy attacks by removing the auction
250             // before calling transfer(), and the only thing the seller
251             // can DoS is the sale of their own asset! (And if it's an
252             // accident, they can call cancelAuction(). )
253             seller.transfer(sellerProceeds);
254         }
255 
256         // Calculate any excess funds included with the bid. If the excess
257         // is anything worth worrying about, transfer it back to bidder.
258         // NOTE: We checked above that the bid amount is greater than or
259         // equal to the price so this cannot underflow.
260         uint256 bidExcess = _bidAmount - price;
261 
262         // Return the funds. Similar to the previous transfer, this is
263         // not susceptible to a re-entry attack because the auction is
264         // removed before any transfers occur.
265         msg.sender.transfer(bidExcess);
266 
267         // Tell the world!
268         AuctionWinner(_tokenAddress, price, msg.sender, quantity, _auctionNumber);
269     }
270 
271     /// @dev Removes an auction from the list of open auctions.
272     /// @param _tokenAddress - Address of FT (ERC-20) on auction.
273     /// @param _auctionNumber - Auction Number corresponding the auction bidding on
274     function _removeAuction(address _tokenAddress, uint256 _auctionNumber) internal {
275         delete tokensAuction[_tokenAddress][_auctionNumber];
276     }
277 
278     /// @dev Returns true if the FT (ERC-20) is on auction.
279     /// @param _auction - Auction to check.
280     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
281         return (_auction.startedAt > 0);
282     }
283 
284     /// @dev Returns current price of an FT (ERC-20) on auction. Broken into two
285     ///  functions (this one, that computes the duration from the auction
286     ///  structure, and the other that does the price computation) so we
287     ///  can easily test that the price computation works correctly.
288     function _currentPrice(Auction storage _auction)
289         internal
290         view
291         returns (uint256)
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
320         internal
321         pure
322         returns (uint256)
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
362     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
363     ///  approval. Setting _approved to address(0) clears all transfer approval.
364     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
365     ///  _approve() and transferFrom() are used together for putting Kitties on auction, and
366     ///  there is no value in spamming the log with Approval events in that case.
367     function _approve(address _tokenAddress, address _approved, uint256 _tokenQuantity) internal {
368         StandardToken tokenContract = StandardToken(_tokenAddress);
369         tokenContract.approve(_approved, _tokenQuantity);
370     }
371 }
372 
373 /**
374  * @title Pausable
375  * @dev Base contract which allows children to implement an emergency stop mechanism.
376  */
377 contract Pausable is Ownable {
378   event Pause();
379   event Unpause();
380 
381   bool public paused = false;
382 
383 
384   /**
385    * @dev modifier to allow actions only when the contract IS paused
386    */
387   modifier whenNotPaused() {
388     require(!paused);
389     _;
390   }
391 
392   /**
393    * @dev modifier to allow actions only when the contract IS NOT paused
394    */
395   modifier whenPaused {
396     require(paused);
397     _;
398   }
399 
400   /**
401    * @dev called by the owner to pause, triggers stopped state
402    */
403   function pause() onlyOwner whenNotPaused returns (bool) {
404     paused = true;
405     Pause();
406     return true;
407   }
408 
409   /**
410    * @dev called by the owner to unpause, returns to normal state
411    */
412   function unpause() onlyOwner whenPaused returns (bool) {
413     paused = false;
414     Unpause();
415     return true;
416   }
417 }
418 
419 /// @title Clock auction for fungible tokens.
420 /// @notice We omit a fallback function to prevent accidental sends to this contract.
421 contract ClockAuction is Pausable, AuctionBase {
422 
423     /// @dev Constructor creates a reference to the FT (ERC-20) ownership contract
424     /// @param _contractAddr - Address of the SaleClockAuction Contract. Setting the variable.
425     function ClockAuction(address _contractAddr) public {
426         require(ownerCut <= 10000);
427         cryptiblesAuctionContract = _contractAddr;
428     }
429 
430     /// @dev Remove all Ether from the contract, which is the owner's cuts
431     ///  as well as any Ether sent directly to the contract address.
432     ///  Always transfers to the FT (ERC-20) contract, but can be called either by
433     ///  the owner or the FT (ERC-20) contract.
434     function withdrawBalance() external {
435         require(
436             msg.sender == owner ||
437             msg.sender == ethAddress
438         );
439         // We are using this boolean method to make sure that even if one fails it will still work
440         bool res = msg.sender.send(this.balance);
441 
442     }
443 
444     /// @dev Creates and begins a new auction.
445     /// @param _tokenAddress - Address of token to auction, sender must be owner.
446     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
447     /// @param _endingPrice - Price of item (in wei) at end of auction.
448     /// @param _duration - Length of time to move between starting
449     ///  price and ending price (in seconds).
450     /// @param _totalQuantity - Token Quantity to Auction
451     function createAuction(
452         address _tokenAddress,
453         uint256 _startingPrice,
454         uint256 _endingPrice,
455         uint256 _duration,
456         uint256 _totalQuantity
457     )
458         external
459         whenNotPaused
460     {
461         // Checking whether user has enough balance
462         require(_owns(_tokenAddress, msg.sender, _totalQuantity));
463         
464         // We can't approve our ERC-20 Tokens minted earlier as they will need to be
465         // approved by the owner and not by our contract
466         // _approve(_tokenAddress, msg.sender, _tokenQuantity);
467 
468         // Sanity check that no inputs overflow how many bits we've allocated
469         // to store them in the auction struct.
470         require(_startingPrice == uint256(uint128(_startingPrice)));
471         require(_endingPrice == uint256(uint128(_endingPrice)));
472         require(_duration == uint256(uint64(_duration)));
473 
474         require(this == address(cryptiblesAuctionContract));
475 
476         uint256 auctionNumber = auctionCounter[_tokenAddress];
477         
478         // Defaults to 0, incrementing the counter
479         if(auctionNumber == uint256(0)){
480             auctionNumber = 1;
481         }else{
482             auctionNumber += 1;
483         }
484 
485         auctionCounter[_tokenAddress] = auctionNumber;
486         
487         _escrow(_tokenAddress, msg.sender, _totalQuantity);
488 
489         Auction memory auction = Auction(
490             msg.sender,
491             uint128(_startingPrice),
492             uint128(_endingPrice),
493             uint64(_duration),
494             uint64(now),
495             uint256(_totalQuantity),
496             _tokenAddress,
497             auctionNumber
498         );
499 
500         tokensAuction[_tokenAddress][auctionNumber] = auction;
501 
502         _addAuction(_tokenAddress, auction);
503     }
504 
505     /// @dev Bids on an open auction, completing the auction and transferring
506     ///  ownership of the FT (ERC-20) if enough Ether is supplied.
507     /// @param _tokenAddress - Address of token to bid on.
508     /// @param _auctionNumber - Auction Number corresponding the auction bidding on
509     function bid(address _tokenAddress, uint256 _auctionNumber)
510         external
511         payable
512         whenNotPaused
513     {
514         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
515         // _bid will throw if the bid or funds transfer fails
516         _bid(_tokenAddress, _auctionNumber, msg.value);
517         _transfer(_tokenAddress, msg.sender, auction.tokenQuantity);
518     }
519 
520     /// @dev Cancels an auction that hasn't been won yet.
521     ///  Returns the FT (ERC-20) to original owner.
522     /// @notice This is a state-modifying function that can
523     ///  be called while the contract is paused.
524     /// @param _tokenAddress - Address of token on auction
525     /// @param _auctionNumber - Auction Number for the token
526     function cancelAuction(address _tokenAddress, uint256 _auctionNumber)
527         external
528     {
529         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
530         require(_isOnAuction(auction));
531         address seller = auction.seller;
532         require(msg.sender == seller);
533         _cancelAuction(_tokenAddress, _auctionNumber);
534     }
535 
536     /// @dev Cancels an auction when the contract is paused.
537     ///  Only the owner may do this, and FT (ERC-20)s are returned to
538     ///  the seller. This should only be used in emergencies.
539     /// @param _tokenAddress - Address of the FT (ERC-20) on auction to cancel.
540     /// @param _auctionNumber - Auction Number for the token
541     function cancelAuctionWhenPaused(address _tokenAddress, uint256 _auctionNumber)
542         whenPaused
543         onlyOwner
544         external
545     {
546         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
547         require(_isOnAuction(auction));
548         _cancelAuction(_tokenAddress, _auctionNumber);
549     }
550 
551     /// @dev Returns auction info for an FT (ERC-20) on auction.
552     /// @param _tokenAddress - Address of FT (ERC-20) on auction.
553     /// @param _auctionNumber - Auction Number for the token
554     function getAuction(address _tokenAddress, uint256 _auctionNumber)
555         external
556         view
557         returns
558     (
559         address seller,
560         uint256 startingPrice,
561         uint256 endingPrice,
562         uint256 duration,
563         uint256 startedAt,
564         uint256 tokenQuantity,
565         address tokenAddress,
566         uint256 auctionNumber
567     ) {
568         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
569         require(_isOnAuction(auction));
570         return (
571             auction.seller,
572             auction.startingPrice,
573             auction.endingPrice,
574             auction.duration,
575             auction.startedAt,
576             auction.tokenQuantity,
577             auction.tokenAddress,
578             auction.auctionNumber
579         );
580     }
581 
582     /// @dev Returns the current price of an auction.
583     /// @param _tokenAddress - Address of the token price we are checking.
584     /// @param _auctionNumber - Auction Number for the token
585     function getCurrentPrice(address _tokenAddress, uint256 _auctionNumber)
586         external
587         view
588         returns (uint256)
589     {
590         Auction storage auction = tokensAuction[_tokenAddress][_auctionNumber];
591         require(_isOnAuction(auction));
592         return _currentPrice(auction);
593     }
594 
595 }
596 
597 
598 /// @title Sale Clock auction 
599 /// @notice We omit a fallback function to prevent accidental sends to this contract.
600 contract SaleClockAuction is ClockAuction {
601 
602     // @dev Sanity check that allows us to ensure that we are pointing to the
603     //  right auction call.
604     bool public isSaleClockAuction = true;
605 
606     function SaleClockAuction() public
607         ClockAuction(this) {
608         }
609     
610     /// @dev Creates and begins a new auction.
611     /// @param _tokenAddress - Address of token to auction, sender must be owner.
612     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
613     /// @param _endingPrice - Price of item (in wei) at end of auction.
614     /// @param _duration - Length of auction (in seconds).
615     /// @param _tokenQuantity - Token Quantity to auction
616     function createAuction(
617         address _tokenAddress,
618         uint256 _startingPrice,
619         uint256 _endingPrice,
620         uint256 _duration,
621         uint256 _tokenQuantity
622     )
623         external
624     {
625         require(_owns(_tokenAddress, msg.sender, _tokenQuantity));
626 
627         // We can't approve our ERC-20 Tokens minted earlier as they will need to be
628         // approved by the owner and not by our contract
629         // _approve(_tokenAddress, msg.sender, _tokenQuantity);
630 
631         // Sanity check that no inputs overflow how many bits we've allocated
632         // to store them in the auction struct.
633         require(_startingPrice == uint256(uint128(_startingPrice)));
634         require(_endingPrice == uint256(uint128(_endingPrice)));
635         require(_duration == uint256(uint64(_duration)));
636 
637         require(this == address(cryptiblesAuctionContract));
638 
639         uint256 auctionNumber = auctionCounter[_tokenAddress];
640         
641         // Defaults to 0, incrementing the counter
642         if(auctionNumber == 0){
643             auctionNumber = 1;
644         }else{
645             auctionNumber += 1;
646         }
647 
648         auctionCounter[_tokenAddress] = auctionNumber;
649         
650         _escrow(_tokenAddress, msg.sender, _tokenQuantity);
651 
652         Auction memory auction = Auction(
653             msg.sender,
654             uint128(_startingPrice),
655             uint128(_endingPrice),
656             uint64(_duration),
657             uint64(now),
658             uint256(_tokenQuantity),
659             _tokenAddress,
660             auctionNumber
661         );
662 
663         tokensAuction[_tokenAddress][auctionNumber] = auction;
664         
665         _addAuction(_tokenAddress, auction);
666     }
667 
668     /// @dev works the same as default bid method.
669     /// @param _tokenAddress - Address of token to auction, sender must be owner.
670     /// @param _auctionNumber - Auction number associated with the Token Address
671     function bid(address _tokenAddress, uint256 _auctionNumber)
672         external
673         payable
674     {
675         uint256 quantity = tokensAuction[_tokenAddress][_auctionNumber].tokenQuantity;
676         _bid(_tokenAddress, _auctionNumber, msg.value);
677         _transfer(_tokenAddress,msg.sender, quantity);
678     }
679 
680     /// @dev Function to chnage the OwnerCut only accessible by the Owner of the contract
681     /// @param _newCut - Sets the ownerCut to new value
682     function setOwnerCut(uint256 _newCut) external onlyOwner {
683         require(_newCut <= 10000);
684         ownerCut = _newCut;
685     }
686 }