1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 interface Token {
34     function transfer(address to, uint256 value) external returns (bool success);
35     function transferFrom(address from, address to, uint256 value) external returns (bool success);
36     function approve(address spender, uint256 value) external returns (bool success);
37 
38     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions.
39     function totalSupply() external constant returns (uint256 supply);
40     function balanceOf(address owner) external constant returns (uint256 balance);
41     function allowance(address owner, address spender) external constant returns (uint256 remaining);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 interface PromissoryToken {
47 
48 	function claim() payable external;
49 	function lastPrice() external returns(uint256);
50 }
51 
52 contract DutchAuction {
53 
54     /*
55      *  Events
56      */
57     event BidSubmission(address indexed sender, uint256 amount);
58     event logPayload(bytes _data, uint _lengt);
59 
60     /*
61      *  Constants
62      */
63     uint constant public MAX_TOKENS_SOLD = 10000000 * 10**18; // 10M
64     uint constant public WAITING_PERIOD = 45 days;
65 
66     /*
67      *  Storage
68      */
69 
70 
71     address public pWallet;
72     Token public KittieFightToken;
73     address public owner;
74     PromissoryToken public PromissoryTokenIns; 
75     address constant public promissoryAddr = 0x0348B55AbD6E1A99C6EBC972A6A4582Ec0bcEb5c;
76     uint public ceiling;
77     uint public priceFactor;
78     uint public startBlock;
79     uint public endTime;
80     uint public totalReceived;
81     uint public finalPrice;
82     mapping (address => uint) public bids;
83     Stages public stage;
84 
85     /*
86      *  Enums
87      */
88     enum Stages {
89         AuctionDeployed,
90         AuctionSetUp,
91         AuctionStarted,
92         AuctionEnded,
93         TradingStarted
94     }
95 
96     /*
97      *  Modifiers
98      */
99     modifier atStage(Stages _stage) {
100         require(stage == _stage);
101             // Contract not in expected state
102         _;
103     }
104 
105     modifier isOwner() {
106         require(msg.sender == owner);
107             // Only owner is allowed to proceed
108         _;
109     }
110 
111     modifier isWallet() {
112          require(msg.sender == address(pWallet));
113             // Only wallet is allowed to proceed
114         _;
115     }
116 
117     modifier isValidPayload() {
118         emit logPayload(msg.data, msg.data.length);
119         require(msg.data.length == 4 || msg.data.length == 36, "No valid payload");
120         _;
121     }
122 
123     modifier timedTransitions() {
124         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
125             finalizeAuction();
126         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
127             stage = Stages.TradingStarted;
128         _;
129     }
130 
131     /*
132      *  Public functions
133      */
134     /// @dev Contract constructor function sets owner.
135     /// @param _pWallet KittieFight promissory wallet.
136     /// @param _ceiling Auction ceiling.
137     /// @param _priceFactor Auction price factor.
138     constructor(address _pWallet, uint _ceiling, uint _priceFactor)
139         public
140     {
141         if (_pWallet == 0 || _ceiling == 0 || _priceFactor == 0)
142             // Arguments are null.
143             revert();
144         owner = msg.sender;
145         PromissoryTokenIns = PromissoryToken(promissoryAddr);
146         pWallet = _pWallet;
147         ceiling = _ceiling;
148         priceFactor = _priceFactor;
149         stage = Stages.AuctionDeployed;
150     }
151 
152     /// @dev Setup function sets external contracts' addresses.
153     /// @param _kittieToken  token address.
154     function setup(address _kittieToken)
155         public
156         isOwner
157         atStage(Stages.AuctionDeployed)
158     {
159         if (_kittieToken == 0)
160             // Argument is null.
161             revert();
162         KittieFightToken = Token(_kittieToken);
163         // Validate token balance
164         if (KittieFightToken.balanceOf(this) != MAX_TOKENS_SOLD)
165             revert();
166         stage = Stages.AuctionSetUp;
167     }
168 
169     /// @dev Starts auction and sets startBlock.
170     function startAuction()
171         public
172         isOwner
173         atStage(Stages.AuctionSetUp)
174     {
175         stage = Stages.AuctionStarted;
176         startBlock = block.number;
177     }
178 
179     /// @dev Changes auction ceiling and start price factor before auction is started.
180     /// @param _ceiling Updated auction ceiling.
181     /// @param _priceFactor Updated start price factor.
182     function changeSettings(uint _ceiling, uint _priceFactor)
183         public
184         isWallet
185         atStage(Stages.AuctionSetUp)
186     {
187         ceiling = _ceiling;
188         priceFactor = _priceFactor;
189     }
190 
191     /// @dev Calculates current token price.
192     /// @return Returns token price.
193     function calcCurrentTokenPrice()
194         public
195         timedTransitions
196         returns (uint)
197     {
198         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
199             return finalPrice;
200         return calcTokenPrice();
201     }
202 
203     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
204     /// @return Returns current auction stage.
205     function updateStage()
206         public
207         timedTransitions
208         returns (Stages)
209     {
210         return stage;
211     }
212 
213     /// @dev Allows to send a bid to the auction.
214     /// @param receiver Bid will be assigned to this address if set.
215     function bid(address receiver)
216         public
217         payable
218         //isValidPayload
219         timedTransitions
220         atStage(Stages.AuctionStarted)
221         returns (uint amount)
222     {
223         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
224         if (receiver == 0)
225             receiver = msg.sender;
226         amount = msg.value;
227         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
228         uint maxWei = (MAX_TOKENS_SOLD / 10**18) * calcTokenPrice() - totalReceived;
229         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
230         if (maxWeiBasedOnTotalReceived < maxWei)
231             maxWei = maxWeiBasedOnTotalReceived;
232         // Only invest maximum possible amount.
233         if (amount > maxWei) {
234             amount = maxWei;
235             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
236             if (!receiver.send(msg.value - amount))
237                 // Sending failed
238                 revert();
239         }
240         // Forward funding to ether pWallet
241         if (amount == 0 || !address(pWallet).send(amount))
242             // No amount sent or sending failed
243             revert();
244         bids[receiver] += amount;
245         totalReceived += amount;
246         if (maxWei == amount)
247             // When maxWei is equal to the big amount the auction is ended and finalizeAuction is triggered.
248             finalizeAuction();
249         emit BidSubmission(receiver, amount);
250     }
251 
252     /// @dev Claims tokens for bidder after auction.
253     /// @param receiver Tokens will be assigned to this address if set.
254     function claimTokens(address receiver)
255         public
256         isValidPayload
257         timedTransitions
258         atStage(Stages.TradingStarted)
259     {
260         if (receiver == 0)
261             receiver = msg.sender;
262         uint tokenCount = bids[receiver] * 10**18 / finalPrice;
263         bids[receiver] = 0;
264         KittieFightToken.transfer(receiver, tokenCount);
265     }
266 
267     /// @dev Calculates stop price.
268     /// @return Returns stop price.
269     function calcStopPrice()
270         view
271         public
272         returns (uint)
273     {
274         return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
275     }
276 
277     /// @dev Calculates token price.
278     /// @return Returns token price.
279     function calcTokenPrice()
280         view
281         public
282         returns (uint)
283     {
284         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
285     }
286 
287     /*
288      *  Private functions
289      */
290     function finalizeAuction()
291         private
292     {
293         stage = Stages.AuctionEnded;
294 
295         if (totalReceived == ceiling)
296             finalPrice = calcTokenPrice();
297         else
298             finalPrice = calcStopPrice();
299 
300         endTime = now;
301     }
302 
303 
304 }
305 
306 contract Dutchwrapper is DutchAuction {
307 
308 
309     uint constant public MAX_TOKEN_REFERRAL = 2000000 * 10**18; // One Million and eight hundred  thousand
310 
311     uint public claimedTokenReferral = 0; // 800,000 : eigth hundred thousand limit
312     uint public totalEthEarnedByPartners = 0; // Partners earning
313 
314 
315     // 2,000,000 :  2 million: total MAX_TOKEN_REFERRAL
316     uint constant public TOTAL_BONUS_TOKEN = 2000000 * 10**18;
317 
318     uint public softCap;
319     bool public softcapReached = false;
320 
321 
322     uint constant public Partners = 1; // Distinction between promotion groups, partnership for eth
323     uint constant public Referrals = 2; // Distinction between promotion groups, referral campaign for tokens
324     
325 
326     uint constant public ONE = 1; // NUMBER 1
327 
328     // various reward levels
329     uint constant public thirty = 30 * 10**18; // thirty tokens awarded to bidder when earned
330     uint constant public twoHundred = 200 * 10**18; // two hundred tokens awarded to bidder when earned
331     uint constant public sixHundred = 600 * 10**18; // six hundred tokens awarded to bidder when earned
332 
333     uint constant public oneHundred = 100 * 10**18; // one hundred tokens awarded to refferer when earned
334     uint constant public fiveHundred = 500 * 10**18; // five hundred tokens awarded to refferer when earned
335     uint constant public oneThousand = 1000 * 10**18; // one thousand tokens awarded to refferer when earned
336     uint public residualToken; // variable tracking number of tokens left at near complete token exhaustion
337 
338     mapping (address => uint) public SuperDAOTokens; // amount of bonus Superdao Tokens earned per bidder
339     //for participation on auction based on eth bid
340 
341     struct PartnerForEth {
342         bytes4 hash; // unique hash for partner
343         address addr; //address for partner
344         uint totalReferrals; // Number of reffered parties
345         uint totalContribution; // total contribution in ETH by reffered parties
346         uint[] individualContribution; // individual contribution list, number of eth per contributor
347         uint percentage; // percentage share for partner of each referral
348         uint EthEarned; // up to date total amount earned
349     }
350 
351 	address [] public PartnersList; // list of partners
352 
353     //for token referal campaign
354     struct tokenForReferral {
355         bytes4 hash; // hash of this campaign
356         address addr; // address of this user
357         uint totalReferrals; // total amount of participators refered
358         uint totalTokensEarned; // total tokens earned based on referals
359         mapping(uint => uint) tokenAmountPerReferred;// Amount of tokens earned for each participator referred
360     }
361 
362      address [] public TokenReferalList; // list of partners
363 
364      bytes4 [20] public topAddrHashes; // display top 20 refferers address hashes
365      uint [20] public topReferredNum; // display number of bidders reffered by top 20 refferers
366 
367     event topAddrHashesUpdate(bytes4 [20] topAddrHashes); // log display top 20 refferers address hashes ( see function orderTop20 )
368     event topNumbersUpdate(uint[20] topNumArray);  // log number of bidders reffered by top 20 refferers (( see function orderTop20 )
369     bool public bidderBonus = true; // bolean bonus indicator for both refferers and bidders
370 
371     mapping(bytes4 => PartnerForEth )  public MarketingPartners;
372     mapping(bytes4 => tokenForReferral)  public TokenReferrals;
373     mapping(address => bool ) public Admins;
374 
375     // statistics on the number of bidders
376     struct bidder {
377         address addr;
378         uint amount;
379     }
380 
381     bidder [] public CurrentBidders; // document current bidders
382 
383 
384     event PartnerReferral(bytes4 _partnerHash,address _addr, uint _amount);//fired after marketing partner referral happens
385     event TokenReferral(bytes4 _campaignHash,address _addr, uint _amount);// fired when token referral happens
386     event BidEvent(bytes4 _hash, address _addr, uint _amount); //fired when a bid happens
387     event SetupReferal(uint _type); //fired when a referal campaign is setup
388     event ReferalSignup(bytes4 _Hash, address _addr); // fired when a token promoter signs up
389     event ClaimtokenBonus(bytes4 _Hash, address _addr, bool success); //fired when a person claims earned tokens
390 
391 
392 
393     // check when dutch auction is ended and trading has started
394     modifier tradingstarted(){
395         require(stage == Stages.TradingStarted);
396         _;
397     }
398 
399     // uint constant public MAX_TOKEN_REFERRAL = 1800000 * 10**18; // 1 800,000 : one million and eight hundred  thousand    
400     // uint public claimedTokenReferral = 0; // 800,000 : eigth hundred thousand limit
401 
402     // safety check for requiring limits at maximum amount allocated for referrals
403     modifier ReferalCampaignLimit() {
404         require (claimedTokenReferral < MAX_TOKEN_REFERRAL);
405         _;
406     }
407 
408 
409     constructor  (address _pWallet, uint _ceiling, uint _priceFactor, uint _softCap)
410         DutchAuction(_pWallet, _ceiling, _priceFactor)  public {
411 
412             softCap = _softCap;
413     }
414 
415     function checksoftCAP() internal {
416         //require (softcapReached == false);
417         if( totalReceived >= softCap ) {
418             softcapReached = true;
419         }
420     }
421 
422     // creates either a marketing partnering for eth or a twitter retweet campaign. referal marketing in
423     // exchange for tokens are self generated in referal signup function
424 
425     function setupReferal(address _addr, uint _percentage)
426         public
427         isOwner
428         returns (string successmessage) 
429     {
430 
431             bytes4 tempHash = bytes4(keccak256(abi.encodePacked(_addr, msg.sender)));
432 
433             MarketingPartners[tempHash].hash = tempHash;
434             MarketingPartners[tempHash].addr = _addr;
435             MarketingPartners[tempHash].percentage = _percentage;
436 
437             InternalReferalSignupByhash(tempHash, _addr);
438 
439     		emit SetupReferal(1); // Marketin partners
440             return "partner signed up";
441     }
442 
443     // generated hash on behalf of partners earning cash and tokensby tokens. referalcampaignlimmit modifier
444     //removed because partner signup it will fail if referal tokens are used up
445     function InternalReferalSignup(address _addr) internal returns (bytes4 referalhash) {
446         
447         bytes4 tempHash = bytes4(keccak256(abi.encodePacked(_addr)));
448         TokenReferrals[tempHash].addr = msg.sender;
449         TokenReferrals[tempHash].hash = tempHash;
450         referalhash = tempHash;
451         emit ReferalSignup(tempHash, _addr);
452     }
453 
454     //
455     function InternalReferalSignupByhash(bytes4 _hash, address _addr) internal returns (bytes4 referalhash) {
456         TokenReferrals[_hash].addr = _addr;
457         TokenReferrals[_hash].hash = _hash;
458         referalhash = _hash;
459         emit ReferalSignup(_hash, _addr);
460     }
461 
462 
463     // public self generated hash by token earning promoters
464     function referralSignup() public ReferalCampaignLimit returns (bytes4 referalhash) {
465         bytes4 tempHash = bytes4(keccak256(abi.encodePacked(msg.sender)));
466         require (tempHash != TokenReferrals[tempHash].hash); //check prevent overwriting
467         TokenReferrals[tempHash].addr = msg.sender;
468         TokenReferrals[tempHash].hash = tempHash;
469         referalhash = tempHash;
470         emit ReferalSignup(tempHash, msg.sender);
471     }
472 
473 
474     // Biding using a referral hash
475     function bidReferral(address _receiver, bytes4 _hash) public payable returns (uint) {
476 
477         uint bidAmount = msg.value;
478         uint256 promissorytokenLastPrice = PromissoryTokenIns.lastPrice();
479 
480 
481         if(bidAmount > ceiling - totalReceived) {
482             bidAmount = ceiling - totalReceived;
483         }
484 
485         require( bid(_receiver) == bidAmount );
486 
487 		uint amount = msg.value;
488 		bidder memory _bidder;
489 		_bidder.addr = _receiver;
490 		_bidder.amount = amount;
491         SuperDAOTokens[msg.sender] += amount/promissorytokenLastPrice;
492 		CurrentBidders.push(_bidder);
493         checksoftCAP();
494 
495         emit BidEvent(_hash, msg.sender, amount);
496 
497         if (_hash == MarketingPartners[_hash].hash) {
498 
499             MarketingPartners[_hash].totalReferrals += ONE;
500             MarketingPartners[_hash].totalContribution += amount;
501             MarketingPartners[_hash].individualContribution.push(amount);
502             MarketingPartners[_hash].EthEarned += referalPercentage(amount, MarketingPartners[_hash].percentage);
503 
504             totalEthEarnedByPartners += referalPercentage(amount, MarketingPartners[_hash].percentage);
505 
506             if( (msg.value >= 1 ether) && (msg.value <= 3 ether) && (bidderBonus == true)) {
507              if(bonusChecker(oneHundred, thirty) == false){
508                     discontinueBonus(oneHundred, thirty);
509                     return;
510                     }
511               TokenReferrals[_hash].totalReferrals += ONE;
512               orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
513               TokenReferrals[_hash].tokenAmountPerReferred[amount] = oneHundred;
514               TokenReferrals[_hash].totalTokensEarned += oneHundred;
515               bidderEarnings (thirty) == true ? claimedTokenReferral = oneHundred + thirty : claimedTokenReferral += oneHundred;
516               emit TokenReferral(_hash ,msg.sender, amount);
517 
518 
519               } else if ((msg.value > 3 ether)&&(msg.value <= 6 ether) && (bidderBonus == true)) {
520                    if(bonusChecker(fiveHundred, twoHundred) == false){
521                     discontinueBonus(fiveHundred, twoHundred);
522                     return;
523                     }
524                   TokenReferrals[_hash].totalReferrals += ONE;
525                   orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
526                   TokenReferrals[_hash].tokenAmountPerReferred[amount] = fiveHundred;
527                   TokenReferrals[_hash].totalTokensEarned += fiveHundred;
528                   bidderEarnings (twoHundred) == true ? claimedTokenReferral = fiveHundred + twoHundred : claimedTokenReferral += fiveHundred;
529                   emit TokenReferral(_hash ,msg.sender, amount);
530 
531 
532                   } else if ((msg.value > 6 ether) && (bidderBonus == true)) {
533                     if(bonusChecker(oneThousand, sixHundred) == false){
534                     discontinueBonus(oneThousand, sixHundred);
535                     return;
536                     }
537                     TokenReferrals[_hash].totalReferrals += ONE;
538                     orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
539                     TokenReferrals[_hash].tokenAmountPerReferred[amount] = oneThousand;
540                     TokenReferrals[_hash].totalTokensEarned += oneThousand;
541                     bidderEarnings (sixHundred) == true ? claimedTokenReferral = oneThousand + sixHundred : claimedTokenReferral += oneThousand;
542                     emit TokenReferral(_hash, msg.sender, amount);
543 
544                   }
545 
546             emit PartnerReferral(_hash, MarketingPartners[_hash].addr, amount);
547 
548             return Partners;
549 
550           } else if (_hash == TokenReferrals[_hash].hash){
551 
552         			if( (msg.value >= 1 ether) && (msg.value <= 3 ether) && (bidderBonus == true) ) {
553         			    if(bonusChecker(oneHundred, thirty) == false){
554                             discontinueBonus(oneHundred, thirty);
555                                 return;
556                             }
557                             TokenReferrals[_hash].totalReferrals += ONE;
558                             orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
559             				TokenReferrals[_hash].tokenAmountPerReferred[amount] = oneHundred;
560             				TokenReferrals[_hash].totalTokensEarned += oneHundred;
561                             bidderEarnings (thirty) == true ? claimedTokenReferral = oneHundred + thirty : claimedTokenReferral += oneHundred;
562             				emit TokenReferral(_hash ,msg.sender, amount);
563             				return Referrals;
564 
565         				} else if ((msg.value > 3 ether)&&(msg.value <= 6 ether) && (bidderBonus == true)) {
566         				    if(bonusChecker(fiveHundred, twoHundred) == false){
567                                 discontinueBonus(fiveHundred, twoHundred);
568                                 return;
569                                 }
570                                 TokenReferrals[_hash].totalReferrals += ONE;
571                                 orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
572         						TokenReferrals[_hash].tokenAmountPerReferred[amount] = fiveHundred;
573         						TokenReferrals[_hash].totalTokensEarned += fiveHundred;
574                                 bidderEarnings (twoHundred) == true ? claimedTokenReferral = fiveHundred + twoHundred : claimedTokenReferral += fiveHundred;
575         						emit TokenReferral(_hash ,msg.sender, amount);
576         						return Referrals;
577 
578         						} else if ((msg.value > 6 ether) && (bidderBonus == true)) {
579         						    if(bonusChecker(oneThousand, sixHundred) == false){
580                                      discontinueBonus(oneThousand, sixHundred);
581                                      return;
582                                     }
583                                     TokenReferrals[_hash].totalReferrals += ONE;
584                                     orderTop20(TokenReferrals[_hash].totalReferrals, _hash);
585         							TokenReferrals[_hash].tokenAmountPerReferred[amount] = oneThousand;
586         							TokenReferrals[_hash].totalTokensEarned += oneThousand;
587         							bidderEarnings (sixHundred) == true ? claimedTokenReferral = oneThousand + sixHundred : claimedTokenReferral += oneThousand;
588         							emit TokenReferral(_hash, msg.sender, amount);
589         							return Referrals;
590         						}
591                         }
592     
593     }
594 
595 
596 	function referalPercentage(uint _amount, uint _percent)
597 	    internal
598 	    pure
599 	    returns (uint) {
600             return SafeMath.mul( SafeMath.div( SafeMath.sub(_amount, _amount%100), 100 ), _percent );
601 	}
602 
603 
604     function claimtokenBonus () public returns(bool success)  {
605 
606         bytes4 _personalHash = bytes4(keccak256(abi.encodePacked(msg.sender)));
607         
608         if ((_personalHash == TokenReferrals[_personalHash].hash) 
609                 && (TokenReferrals[_personalHash].totalTokensEarned > 0)) {
610 
611             uint TokensToTransfer1 = TokenReferrals[_personalHash].totalTokensEarned;
612             TokenReferrals[_personalHash].totalTokensEarned = 0;
613             KittieFightToken.transfer(TokenReferrals[_personalHash].addr , TokensToTransfer1);
614             emit ClaimtokenBonus(_personalHash, msg.sender, true);
615          
616             return true;
617 
618         } else {
619 
620             return false;
621        }
622     }
623 
624 
625     function claimCampaignTokenBonus(bytes4 _campaignHash) public returns(bool success)  {
626         
627         bytes4 _marketingCampaignHash = bytes4(keccak256(abi.encodePacked(msg.sender, owner)));
628 
629         if ((_marketingCampaignHash == TokenReferrals[_campaignHash].hash) 
630                 && (TokenReferrals[_campaignHash].totalTokensEarned > 0)) {
631 
632             uint TokensToTransfer1 = TokenReferrals[_campaignHash].totalTokensEarned;
633             TokenReferrals[_campaignHash].totalTokensEarned = 0;
634             KittieFightToken.transfer(TokenReferrals[_campaignHash].addr , TokensToTransfer1);
635             emit ClaimtokenBonus(_campaignHash, msg.sender, true);
636          
637             return true;
638 
639         } else {
640 
641             return false;
642        }
643     }
644     
645 
646     /*
647      *  Admin transfers all unsold tokens back to token contract
648      */
649     function transferUnsoldTokens(uint _unsoldTokens, address _addr)
650         public
651         isOwner
652 
653      {
654 
655         uint soldTokens = totalReceived * 10**18 / finalPrice;
656         uint totalSold = (MAX_TOKENS_SOLD + claimedTokenReferral)  - soldTokens;
657 
658         require (_unsoldTokens < totalSold );
659         KittieFightToken.transfer(_addr, _unsoldTokens);
660     }
661 
662 
663     function tokenAmountPerReferred(bytes4 _hash, uint _amount ) public view returns(uint tokenAmount) {
664         tokenAmount = TokenReferrals[_hash].tokenAmountPerReferred[_amount];
665     }
666 
667     function getCurrentBiddersCount () public view returns(uint biddersCount)  {
668         biddersCount = CurrentBidders.length;
669     }
670 
671     // helper functions  return msg.senders hash
672     function calculatPersonalHash() public view returns (bytes4 _hash) {
673         _hash = bytes4(keccak256(abi.encodePacked(msg.sender)));
674     }
675 
676     function calculatPersonalHashByAddress(address _addr) public view returns (bytes4 _hash) {
677         _hash = bytes4(keccak256(abi.encodePacked(_addr)));
678     }
679 
680     function calculateCampaignHash(address _addr) public view returns (bytes4 _hash) {
681         _hash = bytes4(keccak256(abi.encodePacked(_addr, msg.sender)));
682     }
683 
684     // helper functions ordering top 20 address by number of reffered bidders
685     // array of addresses and bidder numbers are logged
686     function orderTop20(uint _value, bytes4 _hash) private {
687         uint i = 0;
688         /** get the index of the current max element **/
689         for(i; i < topReferredNum.length; i++) {
690             if(topReferredNum[i] < _value) {
691                 break;
692             }
693         }
694 
695         if(i < topReferredNum.length)
696         {
697             if(topAddrHashes[i]!=_hash)
698             {
699                 /** shift the array of one position (getting rid of the last element) **/
700                 for(uint j = topReferredNum.length - 1; j > i; j--) {
701                     (topReferredNum[j], topAddrHashes[j] ) = (topReferredNum[j - 1],topAddrHashes[j - 1]);
702                 }
703 
704             
705             }
706             /** update the new max element **/
707             (topReferredNum[i], topAddrHashes[i]) = (_value, _hash);
708             emit topAddrHashesUpdate (topAddrHashes);
709             emit topNumbersUpdate(topReferredNum);
710         }
711 
712 
713 
714     }
715 
716     // helper functions returning top 20 leading number of reffered bidders by refferers
717     function getTop20Reffered() public view returns (uint [20]){
718       return topReferredNum;
719     }
720 
721     // helper functions  top 20 refferer addresses
722     function getTop20Addr() public view returns (bytes4 [20]){
723         return topAddrHashes;
724      }
725 
726     // helper functions  return msg.senders address from given hash
727     function getAddress (bytes4 _hash) public view returns (address){
728         return TokenReferrals[_hash].addr;
729     }
730 
731     // helper checking existence of bidder as a token refferer
732     // creates a token refferer hash for bidder, if bidder is not already a refferer
733     // also allocates  20%, 25% or 40% (30, 200, 600 KTY tokens) discounts to bidder, based on amount bid
734     function bidderEarnings (uint _amountEarned) private returns (bool){
735 
736         bytes4 bidderTemphash = calculatPersonalHash();
737 
738         if ( bidderTemphash == TokenReferrals[bidderTemphash].hash){
739             TokenReferrals[bidderTemphash].totalTokensEarned += _amountEarned;
740             return true;
741         }else{
742             bytes4 newBidderHash = InternalReferalSignup(msg.sender);
743             TokenReferrals[newBidderHash].totalTokensEarned = _amountEarned;
744             return true;
745         }
746         return false;
747     }
748 
749      // check if both bidder bonus and refferer bonus is avalable
750      // return true if bonus is available
751      function bonusChecker(uint _tokenRefferralBonus, uint _bidderBonusAmount) public view returns (bool){
752       return _tokenRefferralBonus + _bidderBonusAmount + claimedTokenReferral <= MAX_TOKEN_REFERRAL ? true : false;
753     }
754 
755     //document actual remaining residual tokens
756     //call function to terminate bonus
757     function discontinueBonus(uint _tokenRefferralBonus, uint _bidderBonusAmount) private returns (string) {
758         residualToken = MAX_TOKEN_REFERRAL - (_tokenRefferralBonus + _bidderBonusAmount + claimedTokenReferral);
759         return setBonustoFalse();
760     }
761 
762 
763     // bolean bonus switcher, only called when
764     // tokens bonus availability is exhuated
765     // terminate bonus
766     function setBonustoFalse() private returns (string) {
767         require (bidderBonus == true,"no more bonuses");
768         bidderBonus = false;
769         return "tokens exhausted";
770     }
771 
772 }