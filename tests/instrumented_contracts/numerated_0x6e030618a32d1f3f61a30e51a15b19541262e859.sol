1 pragma solidity ^0.5.17;
2 
3 /*************************
4 **************************
5 * https://nexus-dapp.com *
6 **************************
7 *************************/
8 
9 contract Nexus {
10 
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14 
15     /// @dev Only people with tokens
16     modifier onlyBagholders {
17         require(myTokens(msg.sender) > 0);
18         _;
19     }
20 
21     /// @dev Only people with profits
22     modifier onlySetherghands {
23         require(myDividends(true, msg.sender) > 0);
24         _;
25     }
26 
27 
28     /// @dev isControlled
29     modifier isControlled() {
30       require(isStarted());
31       _;
32     }
33 
34     /*==============================
35     =            EVENTS            =
36     ==============================*/
37 
38     event onTokenPurchase(
39         address indexed customerAddress,
40         uint256 incomingEther,
41         uint256 tokensMinted,
42         address indexed referredBy,
43         uint timestamp,
44         uint256 price
45     );
46 
47     event onTokenSell(
48         address indexed customerAddress,
49         uint256 tokensBurned,
50         uint256 etherEarned,
51         uint timestamp,
52         uint256 price
53     );
54 
55     event onReinvestment(
56         address indexed customerAddress,
57         uint256 etherReinvested,
58         uint256 tokensMinted
59     );
60 
61     event onWithdraw(
62         address indexed customerAddress,
63         uint256 etherWithdrawn
64     );
65 
66     // ERC20
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 tokens
71     );
72 	
73     event Approval(
74 		address indexed admin, 
75 		address indexed spender, 
76 		uint256 value
77 	);
78 
79     /*=====================================
80     =            CONFIGURABLES            =
81     =====================================*/
82 
83     string public name = "Nexus";
84     string public symbol = "NEX";
85     uint8 constant public decimals = 18;
86 
87     /// @dev 5% dividends for token selling
88     uint8 constant internal exitFee_ = 5;
89 
90     /// @dev 33% masternode
91     uint8 constant internal refferalFee_ = 30;
92 
93     /// @dev P3D pricing
94     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
95     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
96 
97     uint256 constant internal magnitude = 2 ** 64;
98 
99     /// @dev 100 needed for masternode activation
100     uint256 public stakingRequirement = 100e18;
101 
102     /// @dev light the marketing
103     address payable public marketing;
104 	
105 	// @dev ERC20 allowances
106 	mapping (address => mapping (address => uint256)) private _allowances;
107 
108 
109    /*=================================
110     =            DATASETS            =
111     ================================*/
112 
113     // amount of shares for each address (scaled number)
114     mapping(address => uint256) internal tokenBalanceLedger_;
115     mapping(address => int256) public payoutsTo_;
116     mapping(address => uint256) public referralBalance_;
117 	
118 	// referrers
119 	mapping(address => address) public referrers_;	
120     
121 	uint256 public jackPot_;
122 	address payable public jackPotPretender_;	
123 	uint256 public jackPotStartTime_;
124 	
125     uint256 internal tokenSupply_;
126     uint256 internal profitPerShare_;
127     uint256 public depositCount_;
128 
129 
130     /*=======================================
131     =            CONSTRUCTOR                =
132     =======================================*/
133 
134    constructor (address payable _marketing) public {
135 
136 		marketing = _marketing;
137 		jackPotStartTime_ = now;
138 		jackPot_ = 20 ether;
139  
140    }
141 
142     /*=======================================
143     =            PUBLIC FUNCTIONS           =
144     =======================================*/
145 
146     /**
147      * @dev Fallback function to handle ethereum that was send straight to the contract
148      *  Unfortunately we cannot use a referral address this way.
149      */
150     
151 	function() external isControlled payable  {	
152         purchaseTokens(msg.value, address(0x0), msg.sender);
153     }
154 
155     /// @dev Converts all incoming ether to tokens for the caller, and passes down the referral addy (if any)
156     function buyNEX(address _referredBy) isControlled public payable  returns (uint256) {
157         purchaseTokens(msg.value, _referredBy , msg.sender);
158     }
159 
160     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
161     function purchaseFor(address _referredBy, address payable _customerAddress) isControlled public payable returns (uint256) {
162         purchaseTokens(msg.value, _referredBy , _customerAddress);
163     }
164 
165     /// @dev Converts all of caller's dividends to tokens.
166     function reinvest() onlySetherghands public {
167         // fetch dividends
168         uint256 _dividends = myDividends(false, msg.sender); // retrieve ref. bonus later in the code
169 
170         // pay out the dividends virtually
171         address payable _customerAddress = msg.sender;
172         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
173 
174         // retrieve ref. bonus
175         _dividends += referralBalance_[_customerAddress];
176         referralBalance_[_customerAddress] = 0;
177 
178         // dispatch a buy order with the virtualized "withdrawn dividends"
179         uint256 _tokens = purchaseTokens(_dividends, address(0x0) , _customerAddress);
180 
181         // fire event
182         emit onReinvestment(_customerAddress, _dividends, _tokens);
183     }
184 	
185 	/// @dev The new user welcome function
186     function reg() public returns(bool) {	
187 		return true;
188 	}
189 	
190     /// @dev Alias of sell() and withdraw().
191     function exit() public {
192         // get token count for caller & sell them all
193         address _customerAddress = msg.sender;
194         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
195         if (_tokens > 0) sell(_tokens);
196 
197         // capitulation
198         withdraw();
199     }
200 
201     /// @dev Withdraws all of the callers earnings.
202     function withdraw() onlySetherghands public {
203         // setup data
204         address payable _customerAddress = msg.sender;
205         uint256 _dividends = myDividends(false, msg.sender); // get ref. bonus later in the code
206 
207         // update dividend tracker
208         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
209 
210         // add ref. bonus
211         _dividends += referralBalance_[_customerAddress];
212         referralBalance_[_customerAddress] = 0;
213 
214         // lambo delivery service
215         _customerAddress.transfer(_dividends);
216 
217         // fire event
218         emit onWithdraw(_customerAddress, _dividends);
219     }
220 
221     /// @dev Liquifies tokens to ether.
222     function sell(uint256 _amountOfTokens) onlyBagholders public {
223         // setup data
224         address _customerAddress = msg.sender;
225         // russian hackers BTFO
226         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
227         uint256 _tokens = _amountOfTokens;
228         uint256 _ether = tokensToEther_(_tokens);
229         uint256 _dividends = SafeMath.div(SafeMath.mul(_ether, exitFee_), 100);
230         uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
231 
232         // burn the sold tokens
233         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
234         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
235 
236         // update dividends tracker
237         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEther * magnitude));
238         payoutsTo_[_customerAddress] -= _updatedPayouts;
239 
240         // dividing by zero is a bad idea
241         if (tokenSupply_ > 0) {
242             // update the amount of dividends per token
243             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
244         }
245 
246         // fire event
247 		emit Transfer(_customerAddress, address(0x0), _tokens);
248         emit onTokenSell(_customerAddress, _tokens, _taxedEther, now, buyPrice());
249     }
250 	
251     /**
252      * @dev ERC20 functions.
253      */
254     function allowance(address _admin, address _spender) public view returns (uint256) {
255         return _allowances[_admin][_spender];
256     }
257 
258     function approve(address _spender, uint256 _amountOfTokens) public returns (bool) {
259         approveInternal(msg.sender, _spender, _amountOfTokens);
260         return true;
261     }
262 
263     function approveInternal(address _admin, address _spender, uint256 _amountOfTokens) internal {
264         require(_admin != address(0x0), "ERC20: approve from the zero address");
265         require(_spender != address(0x0), "ERC20: approve to the zero address");
266 
267         _allowances[_admin][_spender] = _amountOfTokens;
268         emit Approval(_admin, _spender, _amountOfTokens);
269     }
270 	
271     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
272         approveInternal(msg.sender, spender, SafeMath.add(_allowances[msg.sender][spender], addedValue));
273         return true;
274     }
275 
276     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
277         approveInternal(msg.sender, spender, SafeMath.sub(_allowances[msg.sender][spender], subtractedValue));
278         return true;
279     }	
280 	
281     /**
282      * @dev Transfer tokens from the caller to a new holder.
283      */
284     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
285         // setup
286         address _customerAddress = msg.sender;
287 
288         // make sure we have the requested tokens
289         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
290 
291         // withdraw all outstanding dividends first
292         if (myDividends(true, msg.sender) > 0) {
293             withdraw();
294         }
295 
296         return transferInternal(_toAddress,_amountOfTokens,_customerAddress);
297     }
298 	
299     function transferFrom(address _fromAddress, address _toAddress, uint256 _amountOfTokens) public returns (bool) {
300         transferInternal(_toAddress, _amountOfTokens, _fromAddress);
301         approveInternal(_fromAddress, msg.sender, SafeMath.sub(_allowances[_fromAddress][msg.sender], _amountOfTokens));
302         return true;
303     }	
304 
305     function transferInternal(address _toAddress, uint256 _amountOfTokens , address _fromAddress) internal returns (bool) {
306         // setup
307         address _customerAddress = _fromAddress;
308 
309         // exchange tokens
310         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
311         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
312 
313         // update dividend trackers
314         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
315         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
316 
317         // fire event
318         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
319 
320         // ERC20
321         return true;
322     }
323 	
324 
325     /*=====================================
326     =      HELPERS AND CALCULATORS        =
327     =====================================*/
328 
329     /**
330      * @dev Method to view the current Ether stored in the contract
331      *  Example: totalEtherBalance()
332      */
333     function totalEtherBalance() public view returns (uint256) {
334         return address(this).balance;
335     }
336 
337     /// @dev Retrieve the total token supply.
338     function totalSupply() public view returns (uint256) {
339         return tokenSupply_;
340     }
341 
342     /// @dev Retrieve the tokens balance.
343     function myTokens(address _customerAddress) public view returns (uint256) {
344         return balanceOf(_customerAddress);
345     }
346 
347     /**
348      * @dev Retrieve the dividends owned by the caller.
349      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
350      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
351      *  But in the internal calculations, we want them separate.
352      */
353     function myDividends(bool _includeReferralBonus, address _customerAddress) public view returns (uint256) {
354         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
355     }
356 
357     /// @dev Retrieve the token balance of any single address.
358     function balanceOf(address _customerAddress) public view returns (uint256) {
359         return tokenBalanceLedger_[_customerAddress];
360     }
361 
362     /// @dev Retrieve the dividend balance of any single address.
363     function dividendsOf(address _customerAddress) public view returns (uint256) {
364         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
365     }
366 
367     /// @dev Return the sell price of 1 individual token.
368     function sellPrice() public view returns (uint256) {
369         // our calculation relies on the token supply, so we need supply. Doh.
370         if (tokenSupply_ == 0) {
371             return tokenPriceInitial_ - tokenPriceIncremental_;
372         } else {
373             uint256 _ether = tokensToEther_(1e18);
374             uint256 _dividends = SafeMath.div(SafeMath.mul(_ether, exitFee_), 100);
375             uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
376 
377             return _taxedEther;
378         }
379     }
380 
381     /// @dev Return the buy price of 1 individual token.
382     function buyPrice() public view returns (uint256) {
383         // our calculation relies on the token supply, so we need supply. Doh.
384         if (tokenSupply_ == 0) {
385             return tokenPriceInitial_ + tokenPriceIncremental_;
386         } else {
387             uint256 _ether = tokensToEther_(1e18);
388             uint256 _dividends = SafeMath.div(SafeMath.mul(_ether, entryFee()), 100);
389             uint256 _taxedEther = SafeMath.add(_ether, _dividends);
390 
391             return _taxedEther;
392         }
393     }
394 
395     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
396     function calculateTokensReceived(uint256 _etherToSpend) public view returns (uint256) {
397         uint256 _dividends = SafeMath.div(SafeMath.mul(_etherToSpend, entryFee()), 100);
398         uint256 _taxedEther = SafeMath.sub(_etherToSpend, _dividends);
399         uint256 _amountOfTokens = etherToTokens_(_taxedEther);
400         return _amountOfTokens;
401     }
402 
403     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
404     function calculateEtherReceived(uint256 _tokensToSell) public view returns (uint256) {
405         require(_tokensToSell <= tokenSupply_);
406         uint256 _ether = tokensToEther_(_tokensToSell);
407         uint256 _dividends = SafeMath.div(SafeMath.mul(_ether, exitFee_), 100);
408         uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
409         return _taxedEther;
410     }
411 
412     /// @dev Function for the frontend to get untaxed receivable ether.
413     function calculateUntaxedEtherReceived(uint256 _tokensToSell) public view returns (uint256) {
414         require(_tokensToSell <= tokenSupply_);
415         uint256 _ether = tokensToEther_(_tokensToSell);
416         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ether, exitFee()), 100);
417         //uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
418         return _ether;
419     }
420 
421     function entryFee() private view returns (uint8){
422       uint256 volume = address(this).balance  - msg.value;
423 
424       if (volume<=1 ether){
425         return 22;
426       }
427       if (volume<=2 ether){
428         return 21;
429       }
430       if (volume<=5000 ether){
431         return 20;
432       }
433       if (volume<=6000 ether){
434         return 19;
435       }
436       if (volume<=7000 ether){
437         return 18;
438       }
439 
440       return 17;
441 	  
442     }
443 
444      // @dev Function for find if premine
445     function jackPotInfo() public view returns (uint256 jackPot, uint256 timer, address jackPotPretender) {
446 		jackPot = jackPot_;
447 		if (jackPot > address(this).balance) {
448 			jackPot = address(this).balance;
449 		}
450 		jackPot = SafeMath.div(jackPot,2);
451 		
452 		timer = now - jackPotStartTime_;
453 		jackPotPretender = jackPotPretender_;
454     }
455 	
456 	// @dev Function for find if premine
457     function isPremine() public view returns (bool) {
458       return depositCount_<=5;
459     }
460 
461     // @dev Function for find if premine
462     function isStarted() public pure returns (bool) {
463       return true; //startTime!=0 && now > startTime;
464     }
465 
466     /*==========================================
467     =            INTERNAL FUNCTIONS            =
468     ==========================================*/
469 
470     /// @dev Internal function to actually purchase the tokens.
471     function purchaseTokens(uint256 _incomingEther, address _referredBy , address payable _customerAddress) internal returns (uint256) {
472         // data setup
473 		require (_incomingEther > 0);
474 		
475         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEther, entryFee()), 100);
476         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
477         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
478         uint256 _taxedEther = SafeMath.sub(_incomingEther, _undividedDividends);
479         uint256 _amountOfTokens = etherToTokens_(_taxedEther);
480         uint256 _fee = _dividends * magnitude;
481 		uint256 _marketing = SafeMath.div(SafeMath.mul(_incomingEther, 4), 100); //4%
482 		
483         // no point in continuing execution if OP is a poorfag russian hacker
484         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
485         // (or hackers)
486         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
487         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
488 
489         // is the user referred by a masternode?
490         if (
491             // is this a referred purchase?
492             _referredBy != address(0x0) &&
493 
494             // no cheating!
495             _referredBy != _customerAddress &&
496 
497             // does the referrer have at least X whole tokens?
498             // i.e is the referrer a godly chad masternode
499             tokenBalanceLedger_[_referredBy] >= stakingRequirement
500         ) {
501             // wealth redistribution
502 			if (referrers_[_customerAddress] == address(0x0)) {
503 				referrers_[_customerAddress] = _referredBy;
504 			}
505 			calculateReferrers(_customerAddress, _referralBonus, 1);
506         } else {
507             // no ref purchase
508             // add the referral bonus back to the global dividends cake
509             _dividends = SafeMath.add(_dividends, _referralBonus);
510             _fee = _dividends * magnitude;
511         }
512 
513         // we can't give people infinite ether
514         if (tokenSupply_ > 0) {
515             // add tokens to the pool
516             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
517 			
518 			// fire event
519 			emit Transfer(address(0x0), _customerAddress, _amountOfTokens);
520 
521             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
522             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
523 
524             // calculate the amount of tokens the customer receives over his purchase
525             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
526         } else {
527             // add tokens to the pool
528             tokenSupply_ = _amountOfTokens;
529         }
530 
531         // update circulating supply & the ledger address for the customer
532         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
533 
534         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
535         // really i know you think you do but you don't
536         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
537         payoutsTo_[_customerAddress] += _updatedPayouts;
538 		
539 		// JackPot calculate
540 		calculateJackPot(_incomingEther, _customerAddress);
541 		
542 		// 4% for marketing 
543 		marketing.send(_marketing);
544 
545         // fire event
546         emit onTokenPurchase(_customerAddress, _incomingEther, _amountOfTokens, _referredBy, now, buyPrice());
547 
548         // Keep track
549         depositCount_++;
550         return _amountOfTokens;
551     }
552 
553     /**
554      * @dev Calculate Referrers reward 
555      * Level 1: 35%, Level 2: 20%, Level 3: 15%, Level 4: 10%, Level 5: 10%, Level 6: 5%, Level 7: 5%
556      */	
557 	function calculateReferrers(address _customerAddress, uint256 _referralBonus, uint8 _level) internal {
558 		address _referredBy = referrers_[_customerAddress];
559 		uint256 _percent = 35;
560 		if (_referredBy != address(0x0)) {
561 			if (_level == 2) _percent = 20;
562 			if (_level == 3) _percent = 15;
563 			if (_level == 4 || _level == 5) _percent = 10;
564 			if (_level == 6 || _level == 7) _percent = 5;
565 			uint256 _newReferralBonus = SafeMath.div(SafeMath.mul(_referralBonus, _percent), 100);
566 			referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _newReferralBonus);
567 			if (_level < 7) {
568 				calculateReferrers(_referredBy, _referralBonus, _level+1);
569 			}
570 		}
571 	}
572 
573     /**
574      * @dev Calculate JackPot 
575      * 40% from entryFee is going to JackPot 
576      * The last investor (with 0.2 ether) will receive the jackpot in 12 hours 
577      */	
578 	function calculateJackPot(uint256 _incomingEther, address payable _customerAddress) internal {
579 		uint256 timer = SafeMath.div(SafeMath.sub(now, jackPotStartTime_), 12 hours);
580 		if (timer > 0 && jackPotPretender_ != address(0x0) && jackPot_ > 0) {
581 			//pay jackPot
582 			if (address(this).balance < jackPot_) {
583 				jackPot_ = address(this).balance;
584 			}
585 				
586 			jackPotPretender_.send(SafeMath.div(jackPot_,2));
587 			jackPot_ = SafeMath.div(jackPot_,2);
588 			jackPotStartTime_ = now;
589 			jackPotPretender_ = address(0x0);
590 		}
591 		
592 		uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEther, entryFee()), 100);
593 		jackPot_ += SafeMath.div(SafeMath.mul(_undividedDividends, 40), 100);
594 		
595 		if (_incomingEther >= 0.2 ether) { 
596 			jackPotPretender_ = _customerAddress;
597 			jackPotStartTime_ = now;
598 		}
599 	}	
600 	
601     /**
602      * @dev Calculate Token price based on an amount of incoming ether
603      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
604      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
605      */
606     function etherToTokens_(uint256 _ether) internal view returns (uint256) {
607         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
608         uint256 _tokensReceived =
609          (
610             (
611                 // underflow attempts BTFO
612                 SafeMath.sub(
613                     (sqrt
614                         (
615                             (_tokenPriceInitial ** 2)
616                             +
617                             (2 * (tokenPriceIncremental_ * 1e18) * (_ether * 1e18))
618                             +
619                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
620                             +
621                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
622                         )
623                     ), _tokenPriceInitial
624                 )
625             ) / (tokenPriceIncremental_)
626         ) - (tokenSupply_);
627 
628         return _tokensReceived;
629     }
630 
631     /**
632      * @dev Calculate token sell value.
633      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
634      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
635      */
636     function tokensToEther_(uint256 _tokens) internal view returns (uint256) {
637         uint256 tokens_ = (_tokens + 1e18);
638         uint256 _tokenSupply = (tokenSupply_ + 1e18);
639         uint256 _etherReceived =
640         (
641             // underflow attempts BTFO
642             SafeMath.sub(
643                 (
644                     (
645                         (
646                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
647                         ) - tokenPriceIncremental_
648                     ) * (tokens_ - 1e18)
649                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
650             )
651         / 1e18);
652 
653         return _etherReceived;
654     }
655 
656     /// @dev This is where all your gas goes.
657     function sqrt(uint256 x) internal pure returns (uint256 y) {
658         uint256 z = (x + 1) / 2;
659         y = x;
660 
661         while (z < y) {
662             y = z;
663             z = (x / z + z) / 2;
664         }
665     }
666 
667 
668 }
669 
670 /**
671  * @title SafeMath
672  * @dev Math operations with safety checks that throw on error
673  */
674 library SafeMath {
675 
676     /**
677     * @dev Multiplies two numbers, throws on overflow.
678     */
679     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
680         if (a == 0) {
681             return 0;
682         }
683         uint256 c = a * b;
684         assert(c / a == b);
685         return c;
686     }
687 
688     /**
689     * @dev Integer division of two numbers, truncating the quotient.
690     */
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         // assert(b > 0); // Solidity automatically throws when dividing by 0
693         uint256 c = a / b;
694         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
695         return c;
696     }
697 
698     /**
699     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
700     */
701     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702         assert(b <= a);
703         return a - b;
704     }
705 
706     /**
707     * @dev Adds two numbers, throws on overflow.
708     */
709     function add(uint256 a, uint256 b) internal pure returns (uint256) {
710         uint256 c = a + b;
711         assert(c >= a);
712         return c;
713     }
714 
715 }