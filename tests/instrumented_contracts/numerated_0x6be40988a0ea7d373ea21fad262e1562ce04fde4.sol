1 // File: soltsice/contracts/MultiOwnable.sol
2 
3 pragma solidity ^0.4.18;
4 
5 /*
6  * A minimum multisig wallet interface. Compatible with MultiSigWallet by Gnosis.
7  */
8 contract WalletBasic {
9     function isOwner(address owner) public returns (bool);
10 }
11 
12 /**
13  * @dev MultiOwnable contract.
14  */
15 contract MultiOwnable {
16     
17     WalletBasic public wallet;
18     
19     event MultiOwnableWalletSet(address indexed _contract, address indexed _wallet);
20 
21     function MultiOwnable 
22         (address _wallet)
23         public
24     {
25         wallet = WalletBasic(_wallet);
26         MultiOwnableWalletSet(this, wallet);
27     }
28 
29     /** Check if a caller is the MultiSig wallet. */
30     modifier onlyWallet() {
31         require(wallet == msg.sender);
32         _;
33     }
34 
35     /** Check if a caller is one of the current owners of the MultiSig wallet or the wallet itself. */
36     modifier onlyOwner() {
37         require (isOwner(msg.sender));
38         _;
39     }
40 
41     function isOwner(address _address) 
42         public
43         constant
44         returns(bool)
45     {
46         // NB due to lazy eval wallet could be a normal address and isOwner won't be called if the first condition is met
47         return wallet == _address || wallet.isOwner(_address);
48     }
49 
50 
51     /* PAUSABLE with upause callable only by wallet */ 
52 
53     bool public paused = false;
54 
55     event Pause();
56     event Unpause();
57 
58     /**
59     * @dev Modifier to make a function callable only when the contract is not paused.
60     */
61     modifier whenNotPaused() {
62         require(!paused);
63         _;
64     }
65 
66     /**
67     * @dev Modifier to make a function callable only when the contract is paused.
68     */
69     modifier whenPaused() {
70         require(paused);
71         _;
72     }
73 
74     /**
75     * @dev called by any MSW owner to pause, triggers stopped state
76     */
77     function pause() 
78         onlyOwner
79         whenNotPaused 
80         public 
81     {
82         paused = true;
83         Pause();
84     }
85 
86     /**
87     * @dev called by the MSW (all owners) to unpause, returns to normal state
88     */
89     function unpause() 
90         onlyWallet
91         whenPaused
92         public
93     {
94         paused = false;
95         Unpause();
96     }
97 }
98 
99 // File: soltsice/contracts/BotManageable.sol
100 
101 pragma solidity ^0.4.18;
102 
103 
104 /**
105  * @dev BotManaged contract provides a modifier isBot and methods to enable/disable bots.
106  */
107 contract BotManageable is MultiOwnable {
108     uint256 constant MASK64 = 18446744073709551615;
109 
110     // NB packing saves gas even in memory due to stack size
111     // struct StartEndTimeLayout {
112     //     uint64 startTime;
113     //     uint64 endTime;
114     // }
115 
116     /**
117      * Bot addresses and their start/end times (two uint64 timestamps)
118      */
119     mapping (address => uint128) internal botsStartEndTime;
120 
121     event BotsStartEndTimeChange(address indexed _botAddress, uint64 _startTime, uint64 _endTime);
122 
123     function BotManageable 
124         (address _wallet)
125         public
126         MultiOwnable(_wallet)
127     { }
128 
129     /** Check if a caller is an active bot. */
130     modifier onlyBot() {
131         require (isBot(msg.sender));
132         _;
133     }
134 
135     /** Check if a caller is an active bot or an owner or the wallet. */
136     modifier onlyBotOrOwner() {
137         require (isBot(msg.sender) || isOwner(msg.sender));
138         _;
139     }
140 
141     /** Enable bot address. */
142     function enableBot(address _botAddress)
143         onlyWallet()
144         public 
145     {
146         uint128 botLifetime = botsStartEndTime[_botAddress];
147         // cannot re-enable existing bot
148         require((botLifetime >> 64) == 0 && (botLifetime & MASK64) == 0);
149         botLifetime |= uint128(now) << 64;
150         botsStartEndTime[_botAddress] = botLifetime;
151         BotsStartEndTimeChange(_botAddress, uint64(botLifetime >> 64), uint64(botLifetime & MASK64));
152     }
153 
154     /** Disable bot address. */
155     function disableBot(address _botAddress, uint64 _fromTimeStampSeconds)
156         onlyOwner()
157         public 
158     {
159         uint128 botLifetime = botsStartEndTime[_botAddress];
160         // bot must have been enabled previously and not disabled before
161         require((botLifetime >> 64) > 0 && (botLifetime & MASK64) == 0);
162         botLifetime |= uint128(_fromTimeStampSeconds);
163         botsStartEndTime[_botAddress] = botLifetime;
164         BotsStartEndTimeChange(_botAddress, uint64(botLifetime >> 64), uint64(botLifetime & MASK64));
165     }
166 
167     /** Operational contracts call this method to check if a caller is an approved bot. */
168     function isBot(address _botAddress) 
169         public
170         constant
171         returns(bool)
172     {
173         return isBotAt(_botAddress, uint64(now));
174     }
175 
176     // truffle-contract doesn't like method overloading, use a different name
177 
178     function isBotAt(address _botAddress, uint64 _atTimeStampSeconds) 
179         public
180         constant 
181         returns(bool)
182     {
183         uint128 botLifetime = botsStartEndTime[_botAddress];
184         if ((botLifetime >> 64) == 0 || (botLifetime >> 64) > _atTimeStampSeconds) {
185             return false;
186         }
187         if ((botLifetime & MASK64) == 0) {
188             return true;
189         }
190         if (_atTimeStampSeconds < (botLifetime & MASK64)) {
191             return true;
192         }
193         return false;
194     }
195 }
196 
197 // File: zeppelin-solidity/contracts/math/SafeMath.sol
198 
199 pragma solidity ^0.4.24;
200 
201 
202 /**
203  * @title SafeMath
204  * @dev Math operations with safety checks that throw on error
205  */
206 library SafeMath {
207 
208   /**
209   * @dev Multiplies two numbers, throws on overflow.
210   */
211   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
212     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
213     // benefit is lost if 'b' is also tested.
214     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
215     if (_a == 0) {
216       return 0;
217     }
218 
219     c = _a * _b;
220     assert(c / _a == _b);
221     return c;
222   }
223 
224   /**
225   * @dev Integer division of two numbers, truncating the quotient.
226   */
227   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
228     // assert(_b > 0); // Solidity automatically throws when dividing by 0
229     // uint256 c = _a / _b;
230     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
231     return _a / _b;
232   }
233 
234   /**
235   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
236   */
237   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
238     assert(_b <= _a);
239     return _a - _b;
240   }
241 
242   /**
243   * @dev Adds two numbers, throws on overflow.
244   */
245   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
246     c = _a + _b;
247     assert(c >= _a);
248     return c;
249   }
250 }
251 
252 // File: contracts/Auction.sol
253 
254 pragma solidity ^0.4.18;
255 
256 
257 
258 contract ERC20Basic {
259     function totalSupply() public view returns (uint256);
260     function transferFrom(address from, address to, uint256 value) public returns (bool);
261     function transfer(address to, uint256 value) public returns (bool);
262 }
263 
264 contract AuctionHub is BotManageable {
265     using SafeMath for uint256;
266 
267     /*
268      *  Data structures
269      */
270     
271     struct TokenBalance {
272         address token;
273         uint256 value;
274     }
275 
276     struct TokenRate {
277         uint256 value;
278         uint256 decimals;
279     }
280 
281     struct BidderState {
282         uint256 etherBalance;
283         uint256 tokensBalanceInEther;
284         //uint256 managedBid;
285         TokenBalance[] tokenBalances;        
286         uint256 etherBalanceInUsd; // (decimals = 2)
287         uint256 tokensBalanceInUsd; // (decimals = 2)
288         //uint256 managedBidInUsd;
289     }
290 
291     struct ActionState {
292         uint256 endSeconds; // end time in Unix seconds, 1514160000 for Dec 25, 2017 (need to double check!)
293         uint256 maxTokenBidInEther; // максимальная ставка токенов в эфире. Думаю убрать это ограничение.
294         uint256 minPrice; // минимальная цена лота в WEI
295         
296         uint256 highestBid; 
297         
298         // next 5 fields should be packed into one 32-bytes slot
299         address highestBidder;
300         //uint64 highestManagedBidder;
301         //bool allowManagedBids;
302         bool cancelled;
303         bool finalized;        
304 
305         uint256 maxTokenBidInUsd; // max token bid in usd (decimals = 2)
306         uint256 highestBidInUsd; // highest bid in usd (decimals = 2)
307         address highestBidderInUsd; // highest bidder address in usd (decimals = 2)
308         //uint64 highestManagedBidderInUsd; // highest manage bid in usd
309 
310         mapping(address => BidderState) bidderStates;
311 
312         bytes32 item;       
313     }
314 
315     /*
316      *  Storage
317      */
318     mapping(address => ActionState) public auctionStates;
319     mapping(address => TokenRate) public tokenRates;    
320     // ether rate in usd
321     uint256 public etherRate;
322 
323     /*
324      *  Events
325      */
326 
327     event NewAction(address indexed auction, string item);
328     event Bid(address indexed auction, address bidder, uint256 totalBidInEther, uint256 indexed tokensBidInEther, uint256 totalBidInUsd, uint256 indexed tokensBidInUsd);
329     event TokenBid(address indexed auction, address bidder, address token, uint256 numberOfTokens);
330     //event ManagedBid(address indexed auction, uint64 bidder, uint256 bid, address knownManagedBidder);
331     //event NewHighestBidder(address indexed auction, address bidder, uint64 managedBidder, uint256 totalBid);
332     event NewHighestBidder(address indexed auction, address bidder, uint256 totalBid);
333     //event NewHighestBidderInUsd(address indexed auction, address bidder, uint64 managedBidderInUsd, uint256 totalBidInUsd);
334     event NewHighestBidderInUsd(address indexed auction, address bidder, uint256 totalBidInUsd);
335     event TokenRateUpdate(address indexed token, uint256 rate);
336     event EtherRateUpdate(uint256 rate); // in usdt
337     event Withdrawal(address indexed auction, address bidder, uint256 etherAmount, uint256 tokensBidInEther);
338     event Charity(address indexed auction, address bidder, uint256 etherAmount, uint256 tokensAmount); // not used
339     //event Finalized(address indexed auction, address highestBidder, uint64 highestManagedBidder, uint256 amount);
340     event Finalized(address indexed auction, address highestBidder, uint256 amount);
341     event FinalizedInUsd(address indexed auction, address highestBidderInUsd, uint256 amount);
342     event FinalizedTokenTransfer(address indexed auction, address token, uint256 tokensBidInEther);
343     event FinalizedEtherTransfer(address indexed auction, uint256 etherAmount);
344     event ExtendedEndTime(address indexed auction, uint256 newEndtime);
345     event Cancelled(address indexed auction);
346 
347     /*
348      *  Modifiers
349      */
350 
351     modifier onlyActive {
352         // NB this modifier also serves as check that an auction exists (otherwise endSeconds == 0)
353         ActionState storage auctionState = auctionStates[msg.sender];
354         require (now < auctionState.endSeconds && !auctionState.cancelled);
355         _;
356     }
357 
358     modifier onlyBeforeEnd {
359         // NB this modifier also serves as check that an auction exists (otherwise endSeconds == 0)
360         ActionState storage auctionState = auctionStates[msg.sender];
361         require (now < auctionState.endSeconds);
362         _;
363     }
364 
365     modifier onlyAfterEnd {
366         ActionState storage auctionState = auctionStates[msg.sender];
367         require (now > auctionState.endSeconds && auctionState.endSeconds > 0);
368         _;
369     }
370 
371     modifier onlyNotCancelled {
372         ActionState storage auctionState = auctionStates[msg.sender];
373         require (!auctionState.cancelled);
374         _;
375     }
376 
377     /*modifier onlyAllowedManagedBids {
378         ActionState storage auctionState = auctionStates[msg.sender];
379         require (auctionState.allowManagedBids);
380         _;
381     }*/
382 
383     /*
384      * _rates are per big token (e.g. Ether vs. wei), i.e. number of wei per [number of tokens]*[10 ** decimals]
385      */
386     function AuctionHub 
387         (address _wallet, address[] _tokens, uint256[] _rates, uint256[] _decimals, uint256 _etherRate)
388         public
389         BotManageable(_wallet)
390     {
391         // make sender a bot to avoid an additional step
392         botsStartEndTime[msg.sender] = uint128(now) << 64;
393 
394         require(_tokens.length == _rates.length);
395         require(_tokens.length == _decimals.length);
396 
397         // save initial token list
398         for (uint i = 0; i < _tokens.length; i++) {
399             require(_tokens[i] != 0x0);
400             require(_rates[i] > 0);
401             ERC20Basic token = ERC20Basic(_tokens[i]);
402             tokenRates[token] = TokenRate(_rates[i], _decimals[i]);
403             emit TokenRateUpdate(token, _rates[i]);
404         }
405 
406         // save ether rate in usd
407         require(_etherRate > 0);
408         etherRate = _etherRate;
409         emit EtherRateUpdate(_etherRate);
410     }
411 
412     function stringToBytes32(string memory source) returns (bytes32 result) {
413         bytes memory tempEmptyStringTest = bytes(source);
414         if (tempEmptyStringTest.length == 0) {
415             return 0x0;
416         }
417 
418         assembly {
419             result := mload(add(source, 32))
420         }
421     }
422 
423     function createAuction(
424         uint _endSeconds, 
425         uint256 _maxTokenBidInEther,
426         uint256 _minPrice,
427         string _item
428         //bool _allowManagedBids
429     )
430         onlyBot
431         public
432         returns (address)
433     {
434         require (_endSeconds > now);
435         require(_maxTokenBidInEther <= 1000 ether);
436         require(_minPrice > 0);
437 
438         Auction auction = new Auction(this);
439 
440         ActionState storage auctionState = auctionStates[auction];
441 
442         auctionState.endSeconds = _endSeconds;
443         auctionState.maxTokenBidInEther = _maxTokenBidInEther;
444         // пока не используется в коде
445         auctionState.maxTokenBidInUsd = _maxTokenBidInEther.mul(etherRate).div(10 ** 2);
446         auctionState.minPrice = _minPrice;
447         //auctionState.allowManagedBids = _allowManagedBids;
448         string memory item = _item;
449         auctionState.item = stringToBytes32(item);
450 
451         emit NewAction(auction, _item);
452         return address(auction);
453     }
454 
455     function () 
456         payable
457         public
458     {
459         throw;
460         // It's charity!
461         // require(wallet.send(msg.value));
462         // Charity(0x0, msg.sender, msg.value, 0);
463     }
464 
465     function bid(address _bidder, uint256 _value, address _token, uint256 _tokensNumber)
466         // onlyActive - inline check to reuse auctionState variable
467         public
468         returns (bool isHighest, bool isHighestInUsd)
469     {
470         ActionState storage auctionState = auctionStates[msg.sender];
471         // same as onlyActive modifier, but we already have a variable here
472         require (now < auctionState.endSeconds && !auctionState.cancelled);
473 
474         BidderState storage bidderState = auctionState.bidderStates[_bidder];
475         
476         uint256 totalBid;
477         uint256 totalBidInUsd;
478 
479         if (_tokensNumber > 0) {
480             (totalBid, totalBidInUsd) = tokenBid(msg.sender, _bidder,  _token, _tokensNumber);
481         }else {
482             require(_value > 0);
483 
484             // NB if current token bid == 0 we still could have previous token bids
485             (totalBid, totalBidInUsd) = (bidderState.tokensBalanceInEther, bidderState.tokensBalanceInUsd);
486         }
487 
488         uint256 etherBid = bidderState.etherBalance + _value;
489         // error "CompilerError: Stack too deep, try removing local variables"
490         
491         bidderState.etherBalance = etherBid;      
492 
493         //totalBid = totalBid + etherBid + bidderState.managedBid;
494         totalBid = totalBid + etherBid;
495         //totalBidInUsd = totalBidInUsd + etherBidInUsd + bidderState.managedBidInUsd;
496         
497 
498         if (totalBid > auctionState.highestBid && totalBid >= auctionState.minPrice) {
499             auctionState.highestBid = totalBid;
500             auctionState.highestBidder = _bidder;
501             //auctionState.highestManagedBidder = 0;
502             emit NewHighestBidder(msg.sender, _bidder, totalBid);
503             if ((auctionState.endSeconds - now) < 1800) {
504                 /*uint256 newEnd = now + 1800;
505                 auctionState.endSeconds = newEnd;
506                 ExtendedEndTime(msg.sender, newEnd);*/
507                 //uint256 newEnd = now + 1800;
508                 // убираем увеличение времени аукциона на 30 мин. при высокой ставки в Ether
509                 /*auctionState.endSeconds = now + 1800;
510                 ExtendedEndTime(msg.sender, auctionState.endSeconds);*/
511             }
512             isHighest = true;
513         }
514 
515         /*    
516         uint256 etherBidInUsd = bidderState.etherBalanceInUsd + _value.mul(etherRate);
517         bidderState.etherBalanceInUsd = etherBidInUsd;
518         totalBidInUsd = totalBidInUsd + etherBidInUsd;*/
519         uint256 etherBidInUsd = bidderState.etherBalanceInUsd + _value.mul(etherRate).div(10 ** 2);
520         bidderState.etherBalanceInUsd = etherBidInUsd;
521         totalBidInUsd = totalBidInUsd + etherBidInUsd;
522 
523         if (totalBidInUsd > auctionState.highestBidInUsd && totalBidInUsd >= auctionState.minPrice.mul(etherRate).div(10 ** 2)) {
524             auctionState.highestBidInUsd = totalBidInUsd;
525             auctionState.highestBidderInUsd = _bidder;
526             //auctionState.highestManagedBidderInUsd = 0;
527             emit NewHighestBidderInUsd(msg.sender, _bidder, totalBidInUsd);
528             if ((auctionState.endSeconds - now) < 1800) {
529                 //uint256 newEndUsd = now + 1800;
530                 //auctionState.endSeconds = newEndUsd;
531                 //ExtendedEndTime(msg.sender, newEndUsd);
532                 //uint256 newEndUsd = now + 1800;
533                 auctionState.endSeconds = now + 1800;
534                 emit ExtendedEndTime(msg.sender, auctionState.endSeconds);
535             }
536             isHighestInUsd = true;
537         }
538 
539         emit Bid(msg.sender, _bidder, totalBid, totalBid - etherBid, totalBidInUsd, totalBidInUsd - etherBidInUsd);        
540 
541         return (isHighest, isHighestInUsd);
542     }
543 
544     function tokenBid(address _auction, address _bidder, address _token, uint256 _tokensNumber)
545         internal
546         returns (uint256 tokenBid, uint256 tokenBidInUsd)
547     {
548         // NB actual token transfer happens in auction contracts, which owns both ether and tokens
549         // This Hub contract is for accounting
550 
551         ActionState storage auctionState = auctionStates[_auction];
552         BidderState storage bidderState = auctionState.bidderStates[_bidder];
553         
554         uint256 totalBid = bidderState.tokensBalanceInEther;
555         uint256 totalBidInUsd = bidderState.tokensBalanceInUsd;
556 
557         TokenRate storage tokenRate = tokenRates[_token];
558         require(tokenRate.value > 0);
559 
560         // find token index
561         uint256 index = bidderState.tokenBalances.length;
562         for (uint i = 0; i < index; i++) {
563             if (bidderState.tokenBalances[i].token == _token) {
564                 index = i;
565                 break;
566             }
567         }
568 
569         // array was empty/token not found - push empty to the end
570         if (index == bidderState.tokenBalances.length) {
571             bidderState.tokenBalances.push(TokenBalance(_token, _tokensNumber));
572         } else {
573             // safe math is already in transferFrom
574             bidderState.tokenBalances[index].value += _tokensNumber;
575         }
576         
577         //totalBid = totalBid + _tokensNumber.mul(tokenRate.value).div(10 ** tokenRate.decimals);
578         
579         totalBid = calcTokenTotalBid(totalBid, _token, _tokensNumber);
580         //totalBidInUsd = totalBidInUsd + _tokensNumber.mul(tokenRate.value).mul(etherRate).div(10 ** 2).div(10 ** tokenRate.decimals);
581         
582         totalBidInUsd = calcTokenTotalBidInUsd(totalBidInUsd, _token, _tokensNumber);
583 
584         // !Note! зачем тут ограничивать макс ставку токена эфиром
585         //require(totalBid <= auctionState.maxTokenBidInEther);
586 
587         bidderState.tokensBalanceInEther = totalBid;
588         bidderState.tokensBalanceInUsd = totalBidInUsd;
589 
590         //TokenBid(_auction, _bidder, _token, _tokensNumber);
591         //emit TokenBid(_auction, _bidder, _token, _tokensNumber, _tokensNumber.mul(tokenRate.value).div(10 ** tokenRate.decimals), _tokensNumber.mul(tokenRate.value).mul(etherRate).div(10 ** 2).div(10 ** tokenRate.decimals));
592         emit TokenBid(_auction, _bidder, _token, _tokensNumber);
593         return (totalBid, totalBidInUsd);
594     }
595 
596     function calcTokenTotalBid(uint256 totalBid, address _token, uint256 _tokensNumber)
597         internal
598         //returns(uint256 _totalBid, uint256 _bidInEther){
599         returns(uint256 _totalBid){
600             TokenRate storage tokenRate = tokenRates[_token];
601             // tokenRate.value is for a whole/big token (e.g. ether vs. wei) but _tokensNumber is in small/wei tokens, need to divide by decimals
602             uint256 bidInEther = _tokensNumber.mul(tokenRate.value).div(10 ** tokenRate.decimals);
603             //totalBid = totalBid + _tokensNumber.mul(tokenRate.value).div(10 ** tokenRate.decimals);
604             totalBid += bidInEther;
605             //return (totalBid, bidInEther);
606             return totalBid;
607         }
608     
609     function calcTokenTotalBidInUsd(uint256 totalBidInUsd, address _token, uint256 _tokensNumber)
610         internal
611         returns(uint256 _totalBidInUsd){
612             TokenRate storage tokenRate = tokenRates[_token];
613             uint256 bidInUsd = _tokensNumber.mul(tokenRate.value).mul(etherRate).div(10 ** 2).div(10 ** tokenRate.decimals);
614             //totalBidInUsd = totalBidInUsd + _tokensNumber.mul(tokenRate.value).mul(etherRate).div(10 ** 2).div(10 ** tokenRate.decimals);
615             totalBidInUsd += bidInUsd;
616             return totalBidInUsd;
617         }
618    
619     function totalDirectBid(address _auction, address _bidder)
620         view
621         public
622         returns (uint256 _totalBid)
623     {
624         ActionState storage auctionState = auctionStates[_auction];
625         BidderState storage bidderState = auctionState.bidderStates[_bidder];
626         return bidderState.tokensBalanceInEther + bidderState.etherBalance;
627     }
628 
629     function totalDirectBidInUsd(address _auction, address _bidder)
630         view
631         public
632         returns (uint256 _totalBidInUsd)
633     {
634         ActionState storage auctionState = auctionStates[_auction];
635         BidderState storage bidderState = auctionState.bidderStates[_bidder];
636         return bidderState.tokensBalanceInUsd + bidderState.etherBalanceInUsd;
637     }
638 
639     function setTokenRate(address _token, uint256 _tokenRate)
640         onlyBot
641         public
642     {
643         TokenRate storage tokenRate = tokenRates[_token];
644         require(tokenRate.value > 0);
645         tokenRate.value = _tokenRate;
646         emit TokenRateUpdate(_token, _tokenRate);
647     }
648 
649     function setEtherRate(uint256 _etherRate)
650         onlyBot
651         public
652     {        
653         require(_etherRate > 0);
654         etherRate = _etherRate;
655         emit EtherRateUpdate(_etherRate);
656     }
657 
658     function withdraw(address _bidder)
659         public
660         returns (bool success)
661     {
662         ActionState storage auctionState = auctionStates[msg.sender];
663         BidderState storage bidderState = auctionState.bidderStates[_bidder];
664 
665         bool sent; 
666 
667         // anyone could withdraw at any time except the highest bidder
668         // if cancelled, the highest bidder could withdraw as well
669         //require((_bidder != auctionState.highestBidder) || auctionState.cancelled);
670         require((_bidder != auctionState.highestBidderInUsd) || auctionState.cancelled);
671         uint256 tokensBalanceInEther = bidderState.tokensBalanceInEther;
672         uint256 tokensBalanceInUsd = bidderState.tokensBalanceInUsd;
673         if (bidderState.tokenBalances.length > 0) {
674             for (uint i = 0; i < bidderState.tokenBalances.length; i++) {
675                 uint256 tokenBidValue = bidderState.tokenBalances[i].value;
676                 if (tokenBidValue > 0) {
677                     bidderState.tokenBalances[i].value = 0;
678                     sent = Auction(msg.sender).sendTokens(bidderState.tokenBalances[i].token, _bidder, tokenBidValue);
679                     require(sent);
680                 }
681             }
682             bidderState.tokensBalanceInEther = 0;
683             bidderState.tokensBalanceInUsd = 0;
684         } else {
685             require(tokensBalanceInEther == 0);
686         }
687 
688         uint256 etherBid = bidderState.etherBalance;
689         if (etherBid > 0) {
690             bidderState.etherBalance = 0;
691             bidderState.etherBalanceInUsd = 0;
692             sent = Auction(msg.sender).sendEther(_bidder, etherBid);
693             require(sent);
694         }
695 
696         emit Withdrawal(msg.sender, _bidder, etherBid, tokensBalanceInEther);
697         
698         return true;
699     }
700 
701     function finalize()
702         // onlyNotCancelled - inline check to reuse auctionState variable
703         // onlyAfterEnd - inline check to reuse auctionState variable
704         public
705         returns (bool)
706     {
707         ActionState storage auctionState = auctionStates[msg.sender];
708         // same as onlyNotCancelled+onlyAfterEnd modifiers, but we already have a variable here
709         require (!auctionState.finalized && now > auctionState.endSeconds && auctionState.endSeconds > 0 && !auctionState.cancelled);
710 
711         // если есть хоть одна ставка
712         if (auctionState.highestBidder != address(0)) {
713             bool sent; 
714             BidderState storage bidderState = auctionState.bidderStates[auctionState.highestBidder];
715             uint256 tokensBalanceInEther = bidderState.tokensBalanceInEther;
716             uint256 tokensBalanceInUsd = bidderState.tokensBalanceInUsd;
717             if (bidderState.tokenBalances.length > 0) {
718                 for (uint i = 0; i < bidderState.tokenBalances.length; i++) {
719                     uint256 tokenBid = bidderState.tokenBalances[i].value;
720                     if (tokenBid > 0) {
721                         bidderState.tokenBalances[i].value = 0;
722                         sent = Auction(msg.sender).sendTokens(bidderState.tokenBalances[i].token, wallet, tokenBid);
723                         require(sent);
724                         emit FinalizedTokenTransfer(msg.sender, bidderState.tokenBalances[i].token, tokenBid);
725                     }
726                 }
727                 bidderState.tokensBalanceInEther = 0;
728                 bidderState.tokensBalanceInUsd = 0;
729             } else {
730                 require(tokensBalanceInEther == 0);
731             }
732             
733             uint256 etherBid = bidderState.etherBalance;
734             if (etherBid > 0) {
735                 bidderState.etherBalance = 0;
736                 bidderState.etherBalanceInUsd = 0;
737                 sent = Auction(msg.sender).sendEther(wallet, etherBid);
738                 require(sent);
739                 emit FinalizedEtherTransfer(msg.sender, etherBid);
740             }
741         }
742 
743         auctionState.finalized = true;
744         emit Finalized(msg.sender, auctionState.highestBidder, auctionState.highestBid);
745         emit FinalizedInUsd(msg.sender, auctionState.highestBidderInUsd, auctionState.highestBidInUsd);
746 
747         return true;
748     }
749 
750     function cancel()
751         // onlyActive - inline check to reuse auctionState variable
752         public
753         returns (bool success)
754     {
755         ActionState storage auctionState = auctionStates[msg.sender];
756         // same as onlyActive modifier, but we already have a variable here
757         require (now < auctionState.endSeconds && !auctionState.cancelled);
758 
759         auctionState.cancelled = true;
760         emit Cancelled(msg.sender);
761         return true;
762     }
763 
764 }
765 
766 
767 contract Auction {
768 
769     AuctionHub public owner;
770 
771     modifier onlyOwner {
772         require(owner == msg.sender);
773         _;
774     }
775 
776     modifier onlyBot {
777         require(owner.isBot(msg.sender));
778         _;
779     }
780 
781     modifier onlyNotBot {
782         require(!owner.isBot(msg.sender));
783         _;
784     }
785 
786     function Auction(
787         address _owner
788     ) 
789         public 
790     {
791         require(_owner != address(0x0));
792         owner = AuctionHub(_owner);
793     }
794 
795     function () 
796         payable
797         public
798     {
799         owner.bid(msg.sender, msg.value, 0x0, 0);
800     }
801 
802     function bid(address _token, uint256 _tokensNumber)
803         payable
804         public
805         returns (bool isHighest, bool isHighestInUsd)
806     {
807         if (_token != 0x0 && _tokensNumber > 0) {
808             require(ERC20Basic(_token).transferFrom(msg.sender, this, _tokensNumber));
809         }
810         return owner.bid(msg.sender, msg.value, _token, _tokensNumber);
811     }   
812 
813     function sendTokens(address _token, address _to, uint256 _amount)
814         onlyOwner
815         public
816         returns (bool)
817     {
818         return ERC20Basic(_token).transfer(_to, _amount);
819     }
820 
821     function sendEther(address _to, uint256 _amount)
822         onlyOwner
823         public
824         returns (bool)
825     {
826         return _to.send(_amount);
827     }
828 
829     function withdraw()
830         public
831         returns (bool success)
832     {
833         return owner.withdraw(msg.sender);
834     }
835 
836     function finalize()
837         onlyBot
838         public
839         returns (bool)
840     {
841         return owner.finalize();
842     }
843 
844     function cancel()
845         onlyBot
846         public
847         returns (bool success)
848     {
849         return  owner.cancel();
850     }
851 
852     function totalDirectBid(address _bidder)
853         public
854         view
855         returns (uint256)
856     {
857         return owner.totalDirectBid(this, _bidder);
858     }
859 
860     function totalDirectBidInUsd(address _bidder)
861         public
862         view
863         returns (uint256)
864     {
865         return owner.totalDirectBidInUsd(this, _bidder);
866     }
867 
868     function maxTokenBidInEther()
869         public
870         view
871         returns (uint256)
872     {
873         //var (,maxTokenBidInEther,,,,,,,,,,,) = owner.auctionStates(this);
874         //var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,allowManagedBids,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,bidderStates) = owner.auctionStates(this);
875         //(endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
876         var (,maxTokenBidInEther,,,,,,,,,) = owner.auctionStates(this);
877         return maxTokenBidInEther;
878     }
879 
880     function maxTokenBidInUsd()
881         public
882         view
883         returns (uint256)
884     {
885         //var (,,,,,,,,,,maxTokenBidInUsd,,) = owner.auctionStates(this);
886         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
887         return maxTokenBidInUsd;
888     }
889 
890     function endSeconds()
891         public
892         view
893         returns (uint256)
894     {
895         //var (endSeconds,,,,,,,,,) = owner.auctionStates(this);
896         //(endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
897         var (endSeconds,,,,,,,,,,) = owner.auctionStates(this);
898         return endSeconds;
899     }
900 
901     function item()
902         public
903         view
904         returns (string)
905     {
906         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
907         //var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,allowManagedBids,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,bidderStates,item) = owner.auctionStates(this);
908         bytes memory bytesArray = new bytes(32);
909         for (uint256 i; i < 32; i++) {
910             bytesArray[i] = item[i];
911             }
912         return string(bytesArray);
913     }
914 
915     function minPrice()
916         public
917         view
918         returns (uint256)
919     {
920         //var (,,minPrice,,,,,,,) = owner.auctionStates(this);
921         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
922         return minPrice;
923     }
924 
925     function cancelled()
926         public
927         view
928         returns (bool)
929     {
930         //var (,,,,,,cancelled,,,) = owner.auctionStates(this);
931         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
932         return cancelled;
933     }
934 
935     function finalized()
936         public
937         view
938         returns (bool)
939     {
940         //var (,,,,,,,finalized,,) = owner.auctionStates(this);
941         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
942         return finalized;
943     }
944 
945     function highestBid()
946         public
947         view
948         returns (uint256)
949     {
950         //var (,,,highestBid,,,,,,,,,) = owner.auctionStates(this);
951         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
952         // ,,,,,,,,,,,,
953         // ,,,highestBid,,,,,,,,,
954         return highestBid;
955     }
956 
957     function highestBidInUsd()
958         public
959         view
960         returns (uint256)
961     {
962         //var (,,,,,,,,,,,highestBidInUsd,) = owner.auctionStates(this);
963         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
964         // ,,,,,,,,,,,,
965         return highestBidInUsd;
966     }
967 
968     function highestBidder()
969         public
970         view
971         returns (address)
972     {
973         //var (,,,,highestBidder,,,,,) = owner.auctionStates(this);
974         //var (,,,,highestBidder,,,,,,,,) = owner.auctionStates(this);
975         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
976         // ,,,,highestBidder,,,,,,,,
977         return highestBidder;
978     }
979 
980     
981     function highestBidderInUsd()
982         public
983         view
984         returns (address)
985     {
986         //var (,,,,highestBidder,,,,,) = owner.auctionStates(this);
987         //var (,,,,,,,,,,,,highestBidderInUsd) = owner.auctionStates(this);
988         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,item) = owner.auctionStates(this);
989         // ,,,,,,,,,,,,
990         return highestBidderInUsd;
991     }
992 
993     /*function highestManagedBidder()
994         public
995         view
996         returns (uint64)
997     {
998         //var (,,,,,highestManagedBidder,,,,) = owner.auctionStates(this);
999         var (,,,,,highestManagedBidder,,,,,,,) = owner.auctionStates(this);
1000         // ,,,,,highestManagedBidder,,,,,,,
1001         return highestManagedBidder;
1002     }*/
1003 
1004 
1005     /*function allowManagedBids()
1006         public
1007         view
1008         returns (bool)
1009     {
1010         //var (,,,,,,allowManagedBids,,,) = owner.auctionStates(this);
1011         var (endSeconds,maxTokenBidInEther,minPrice,highestBid,highestBidder,allowManagedBids,cancelled,finalized,maxTokenBidInUsd,highestBidInUsd,highestBidderInUsd,bidderStates) = owner.auctionStates(this);
1012         return allowManagedBids;
1013     }*/
1014 
1015 
1016     // mapping(address => uint256) public etherBalances;
1017     // mapping(address => uint256) public tokenBalances;
1018     // mapping(address => uint256) public tokenBalancesInEther;
1019     // mapping(address => uint256) public managedBids;
1020     
1021     // bool allowManagedBids;
1022 }
1023 
1024 // File: contracts/TokenStarsAuction.sol
1025 
1026 pragma solidity ^0.4.18;
1027 
1028 
1029 contract TokenStarsAuctionHub is AuctionHub {
1030     //real
1031     address public ACE = 0x06147110022B768BA8F99A8f385df11a151A9cc8;
1032     //renkeby
1033     //address public ACE = 0xa0813ad2e1124e0779dc04b385f5229776dcbba8;
1034     //real
1035     address public TEAM = 0x1c79ab32C66aCAa1e9E81952B8AAa581B43e54E7;
1036     // rinkeby
1037     //address public TEAM = 0x10b882e7da9ef31ef6e0e9c4c5457dfaf8dd9a24;
1038     //address public wallet = 0x963dF7904cF180aB2C033CEAD0be8687289f05EC;
1039     address public wallet = 0x0C9b07209750BbcD1d1716DA52B591f371eeBe77;//
1040     address[] public tokens = [ACE, TEAM];
1041     // ACE = 0.01 ETH; 
1042     // TEAM = 0,002 ETH
1043     uint256[] public rates = [10000000000000000, 2000000000000000];
1044     uint256[] public decimals = [0, 4];
1045     // ETH = $138.55
1046     uint256 public etherRate = 13855;
1047 
1048     function TokenStarsAuctionHub()
1049         public
1050         AuctionHub(wallet, tokens, rates, decimals, etherRate)
1051     {
1052     }
1053 
1054     function createAuction(
1055         address _wallet,
1056         uint _endSeconds, 
1057         uint256 _maxTokenBidInEther,
1058         uint256 _minPrice,
1059         string _item
1060         //bool _allowManagedBids
1061     )
1062         onlyBot
1063         public
1064         returns (address)
1065     {
1066         require (_endSeconds > now);
1067         require(_maxTokenBidInEther <= 1000 ether);
1068         require(_minPrice > 0);
1069 
1070         Auction auction = new TokenStarsAuction(this);
1071 
1072         ActionState storage auctionState = auctionStates[auction];
1073 
1074         auctionState.endSeconds = _endSeconds;
1075         auctionState.maxTokenBidInEther = _maxTokenBidInEther;
1076         auctionState.minPrice = _minPrice;
1077         //auctionState.allowManagedBids = _allowManagedBids;
1078         string memory item = _item;
1079         auctionState.item = stringToBytes32(item);
1080 
1081         NewAction(auction, _item);
1082         return address(auction);
1083     }
1084 }
1085 
1086 contract TokenStarsAuctionHubMock is AuctionHub {
1087     uint256[] public rates = [2400000000000000, 2400000000000000];
1088     uint256[] public decimals = [0, 4];
1089     uint256 public etherRate = 13855;
1090 
1091     function TokenStarsAuctionHubMock(address _wallet, address[] _tokens)
1092         public
1093         AuctionHub(_wallet, _tokens, rates, decimals, etherRate)
1094     {
1095     }
1096 
1097     function createAuction(
1098         uint _endSeconds, 
1099         uint256 _maxTokenBidInEther,
1100         uint256 _minPrice,
1101         string _item
1102         //bool _allowManagedBids
1103     )
1104         onlyBot
1105         public
1106         returns (address)
1107     {
1108         require (_endSeconds > now);
1109         require(_maxTokenBidInEther <= 1000 ether);
1110         require(_minPrice > 0);
1111 
1112         Auction auction = new TokenStarsAuction(this);
1113 
1114         ActionState storage auctionState = auctionStates[auction];
1115 
1116         auctionState.endSeconds = _endSeconds;
1117         auctionState.maxTokenBidInEther = _maxTokenBidInEther;
1118         auctionState.maxTokenBidInUsd = _maxTokenBidInEther.mul(etherRate).div(10 ** 2);
1119         auctionState.minPrice = _minPrice;
1120         //auctionState.allowManagedBids = _allowManagedBids;
1121         string memory item = _item;
1122         auctionState.item = stringToBytes32(item);
1123 
1124         NewAction(auction, _item);
1125         return address(auction);
1126     }
1127 }
1128 
1129 contract TokenStarsAuction is Auction {
1130         
1131     function TokenStarsAuction(
1132         address _owner) 
1133         public
1134         Auction(_owner)
1135     {
1136         
1137     }
1138 
1139     function bidAce(uint256 _tokensNumber)
1140         payable
1141         public
1142         returns (bool isHighest, bool isHighestInUsd)
1143     {
1144         return super.bid(TokenStarsAuctionHub(owner).ACE(), _tokensNumber);
1145     }
1146 
1147     function bidTeam(uint256 _tokensNumber)
1148         payable
1149         public
1150         returns (bool isHighest, bool isHighestInUsd)
1151     {
1152         return super.bid(TokenStarsAuctionHub(owner).TEAM(), _tokensNumber);
1153     }
1154 }