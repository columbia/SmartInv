1 pragma solidity ^0.4.20;
2 
3 /*
4 
5   ___        __ _       _ _                   
6  |_ _|_ __  / _(_)_ __ (_) |_ _   _           
7   | || '_ \| |_| | '_ \| | __| | | |          
8   | || | | |  _| | | | | | |_| |_| |          
9  |___|_| |_|_| |_|_| |_|_|\__|\__, |          
10   _   _                       |___/           
11  | | | | ___  _   _ _ __ __ _| | __ _ ___ ___ 
12  | |_| |/ _ \| | | | '__/ _` | |/ _` / __/ __|
13  |  _  | (_) | |_| | | | (_| | | (_| \__ \__ \
14  |_| |_|\___/ \__,_|_|  \__, |_|\__,_|___/___/
15                         |___/                 
16 
17 Website: https://InfinityHourglass.io
18 Discord: https://discord.gg/33Nu2va
19 Twitter: https://twitter.com/Infinity_ETH
20 
21 
22 */
23 
24 contract InfinityHourglass {
25 
26     modifier onlyPeopleWithTokens() {
27         require(myTokens() > 0);_; }
28 
29     modifier onlyPeopleWithProfits() {
30         require(myDividends(true) > 0);_;}
31 
32     modifier onlyAdmin(){
33         address _customerAddress = msg.sender;
34         require(administrator[_customerAddress]);
35         _;
36     }
37     modifier antiEarlyWhale(uint256 _amountOfEthereum){
38         address _customerAddress = msg.sender;
39  
40         if( onlyAdminsFriends && ((totalEthereumBalance() - _amountOfEthereum) <= adminsFriendQuota_ )){
41             require(
42 
43                 adminsFriends_[_customerAddress] == true &&
44 
45                 (adminsFriendAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= adminsFriendMaxPurchase_            
46             );
47             
48 
49             adminsFriendAccumulatedQuota_[_customerAddress] = SafeMath.add(adminsFriendAccumulatedQuota_[_customerAddress], _amountOfEthereum);
50         
51             _;
52         } else {onlyAdminsFriends = false; _; }
53         
54     }
55     
56     event onTokenPurchase(
57         address indexed customerAddress,
58         uint256 incomingEthereum,
59         uint256 tokensMinted,
60         address indexed referredBy
61     );
62     
63     event onTokenSell(
64         address indexed customerAddress,
65         uint256 tokensBurned,
66         uint256 ethereumEarned
67     );
68     
69     event onReinvestment(
70         address indexed customerAddress,
71         uint256 ethereumReinvested,
72         uint256 tokensMinted
73     );
74     
75     event onWithdraw(
76         address indexed customerAddress,
77         uint256 ethereumWithdrawn
78     );
79     
80     // ERC20
81     event Transfer(
82     address indexed from,
83     address indexed to,
84     uint256 tokens);
85     string public name = "Infinity Hourglass";
86     string public symbol = "INF";
87     uint8 constant public decimals = 18;
88     uint8 constant internal dividendFee_ = 7;
89     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
90     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
91     uint256 constant internal magnitude = 2**64;
92     uint256 public stakingRequirement = 100e18;
93     mapping(address => bool) internal adminsFriends_;
94     uint256 constant internal adminsFriendMaxPurchase_ = 1 ether;
95     uint256 constant internal adminsFriendQuota_ = 20 ether;
96     mapping(address => uint256) internal tokenBalanceLedger_;
97     mapping(address => uint256) internal referralBalance_;
98     mapping(address => int256) internal payoutsTo_;
99     mapping(address => uint256) internal adminsFriendAccumulatedQuota_;
100     uint256 internal tokenSupply_ = 0;
101     uint256 internal profitPerShare_;
102     mapping(address => bool) public administrator;
103     bool public onlyAdminsFriends = true;
104     
105 
106 
107     /*=======================================
108     =            PUBLIC FUNCTIONS            =
109     =======================================*/
110     /*
111     * -- APPLICATION ENTRY POINTS --  
112     */
113     function InfinityHourglass()
114         public
115     {administrator[0x703e04F6162f0f6c63F397994EbbF372a90e3d1d] = true;}
116     
117      
118     /**
119      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
120      */
121     function buy(address _referredBy)
122         public
123         payable
124         returns(uint256)
125     {
126         purchaseTokens(msg.value, _referredBy);
127     }
128     
129     /**
130      * Fallback function to handle ethereum that was send straight to the contract
131      * Unfortunately we cannot use a referral address this way.
132      */
133     function()
134         payable
135         public
136     {
137         purchaseTokens(msg.value, 0x0);
138     }
139     
140     /**
141      * Converts all of caller's dividends to tokens.
142      */
143     function reinvest()
144         onlyPeopleWithProfits()
145         public
146     {
147         // fetch dividends
148         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
149         
150         // pay out the dividends virtually
151         address _customerAddress = msg.sender;
152         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
153         
154         // retrieve ref. bonus
155         _dividends += referralBalance_[_customerAddress];
156         referralBalance_[_customerAddress] = 0;
157         
158         // dispatch a buy order with the virtualized "withdrawn dividends"
159         uint256 _tokens = purchaseTokens(_dividends, 0x0);
160         
161         // fire event
162         onReinvestment(_customerAddress, _dividends, _tokens);
163     }
164     
165     /**
166      * Alias of sell() and withdraw().
167      */
168     function exit()
169         public
170     {
171         // get token count for caller & sell them all
172         address _customerAddress = msg.sender;
173         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
174         if(_tokens > 0) sell(_tokens);
175         
176         // lambo delivery service
177         withdraw();
178     }
179 
180     /**
181      * Withdraws all of the callers earnings.
182      */
183     function withdraw()
184         onlyPeopleWithProfits()
185         public
186     {
187         // setup data
188         address _customerAddress = msg.sender;
189         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
190         
191         // update dividend tracker
192         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
193         
194         // add ref. bonus
195         _dividends += referralBalance_[_customerAddress];
196         referralBalance_[_customerAddress] = 0;
197         
198         // lambo delivery service
199         _customerAddress.transfer(_dividends);
200         
201         // fire event
202         onWithdraw(_customerAddress, _dividends);
203     }
204     
205     /**
206      * Liquifies tokens to ethereum.
207      */
208     function sell(uint256 _amountOfTokens)
209         onlyPeopleWithTokens()
210         public
211     {
212         // setup data
213         address _customerAddress = msg.sender;
214         // russian hackers BTFO
215         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
216         uint256 _tokens = _amountOfTokens;
217         uint256 _ethereum = tokensToEthereum_(_tokens);
218         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
219         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
220         
221         // burn the sold tokens
222         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
223         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
224         
225         // update dividends tracker
226         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
227         payoutsTo_[_customerAddress] -= _updatedPayouts;       
228         
229         // dividing by zero is a bad idea
230         if (tokenSupply_ > 0) {
231             // update the amount of dividends per token
232             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
233         }
234         
235         // fire event
236         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
237     }
238     
239     
240     /**
241      * Transfer tokens from the caller to a new holder.
242      * Remember, there's a 10% fee here as well.
243      */
244     function transfer(address _toAddress, uint256 _amountOfTokens)
245         onlyPeopleWithTokens()
246         public
247         returns(bool)
248     {
249         // setup
250         address _customerAddress = msg.sender;
251         
252         // make sure we have the requested tokens
253         // also disables transfers until adminsFriend phase is over
254         // ( we dont want whale premines )
255         require(!onlyAdminsFriends && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
256         
257         // withdraw all outstanding dividends first
258         if(myDividends(true) > 0) withdraw();
259         
260         // liquify 10% of the tokens that are transfered
261         // these are dispersed to shareholders
262         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
263         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
264         uint256 _dividends = tokensToEthereum_(_tokenFee);
265   
266         // burn the fee tokens
267         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
268 
269         // exchange tokens
270         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
271         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
272         
273         // update dividend trackers
274         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
275         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
276         
277         // disperse dividends among holders
278         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
279         
280         // fire event
281         Transfer(_customerAddress, _toAddress, _taxedTokens);
282         
283         // ERC20
284         return true;
285        
286     }
287     
288     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
289     /**
290      * In case the amassador quota is not met, the administrator can manually disable the adminsFriend phase.
291      */
292     function disableInitialStage()
293         onlyAdmin()
294         public
295     {
296         onlyAdminsFriends = false;
297     }
298     
299 
300     /**
301      * Precautionary measures in case we need to adjust the masternode rate.
302      */
303     function setStakingRequirement(uint256 _amountOfTokens)
304         onlyAdmin()
305         public
306     {
307         stakingRequirement = _amountOfTokens;
308     }
309     
310     /**
311      * If we want to rebrand, we can.
312      */
313     function setName(string _name)
314         onlyAdmin()
315         public
316     {
317         name = _name;
318     }
319     
320     /**
321      * If we want to rebrand, we can.
322      */
323     function setSymbol(string _symbol)
324         onlyAdmin()
325         public
326     {
327         symbol = _symbol;
328     }
329 
330     
331     /*----------  HELPERS AND CALCULATORS  ----------*/
332     /**
333      * Method to view the current Ethereum stored in the contract
334      * Example: totalEthereumBalance()
335      */
336     function totalEthereumBalance()
337         public
338         view
339         returns(uint)
340     {
341         return this.balance;
342     }
343     
344     /**
345      * Retrieve the total token supply.
346      */
347     function totalSupply()
348         public
349         view
350         returns(uint256)
351     {
352         return tokenSupply_;
353     }
354     
355     /**
356      * Retrieve the tokens owned by the caller.
357      */
358     function myTokens()
359         public
360         view
361         returns(uint256)
362     {
363         address _customerAddress = msg.sender;
364         return balanceOf(_customerAddress);
365     }
366     
367     /**
368      * Retrieve the dividends owned by the caller.
369      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
370      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
371      * But in the internal calculations, we want them separate. 
372      */ 
373     function myDividends(bool _includeReferralBonus) 
374         public 
375         view 
376         returns(uint256)
377     {
378         address _customerAddress = msg.sender;
379         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
380     }
381     
382     /**
383      * Retrieve the token balance of any single address.
384      */
385     function balanceOf(address _customerAddress)
386         view
387         public
388         returns(uint256)
389     {
390         return tokenBalanceLedger_[_customerAddress];
391     }
392     
393     /**
394      * Retrieve the dividend balance of any single address.
395      */
396     function dividendsOf(address _customerAddress)
397         view
398         public
399         returns(uint256)
400     {
401         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
402     }
403     
404     /**
405      * Return the buy price of 1 individual token.
406      */
407     function sellPrice() 
408         public 
409         view 
410         returns(uint256)
411     {
412         // our calculation relies on the token supply, so we need supply. Doh.
413         if(tokenSupply_ == 0){
414             return tokenPriceInitial_ - tokenPriceIncremental_;
415         } else {
416             uint256 _ethereum = tokensToEthereum_(1e18);
417             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
418             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
419             return _taxedEthereum;
420         }
421     }
422     
423     /**
424      * Return the sell price of 1 individual token.
425      */
426     function buyPrice() 
427         public 
428         view 
429         returns(uint256)
430     {
431         // our calculation relies on the token supply, so we need supply. Doh.
432         if(tokenSupply_ == 0){
433             return tokenPriceInitial_ + tokenPriceIncremental_;
434         } else {
435             uint256 _ethereum = tokensToEthereum_(1e18);
436             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
437             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
438             return _taxedEthereum;
439         }
440     }
441     
442     /**
443      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
444      */
445     function calculateTokensReceived(uint256 _ethereumToSpend) 
446         public 
447         view 
448         returns(uint256)
449     {
450         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
451         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
452         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
453         
454         return _amountOfTokens;
455     }
456     
457     /**
458      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
459      */
460     function calculateEthereumReceived(uint256 _tokensToSell) 
461         public 
462         view 
463         returns(uint256)
464     {
465         require(_tokensToSell <= tokenSupply_);
466         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
467         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
468         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
469         return _taxedEthereum;
470     }
471     
472     
473     /*==========================================
474     =            INTERNAL FUNCTIONS            =
475     ==========================================*/
476     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
477         antiEarlyWhale(_incomingEthereum)
478         internal
479         returns(uint256)
480     {
481         // data setup
482         address _customerAddress = msg.sender;
483         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
484         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
485         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
486         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
487         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
488         uint256 _fee = _dividends * magnitude;
489  
490         // no point in continuing execution if OP is a poorfag russian hacker
491         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
492         // (or hackers)
493         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
494         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
495         
496         // is the user referred by a masternode?
497         if(
498             // is this a referred purchase?
499             _referredBy != 0x0000000000000000000000000000000000000000 &&
500 
501             // no cheating!
502             _referredBy != _customerAddress &&
503             
504             // does the referrer have at least X whole tokens?
505             // i.e is the referrer a godly chad masternode
506             tokenBalanceLedger_[_referredBy] >= stakingRequirement
507         ){
508             // wealth redistribution
509             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
510         } else {
511             // no ref purchase
512             // add the referral bonus back to the global dividends cake
513             _dividends = SafeMath.add(_dividends, _referralBonus);
514             _fee = _dividends * magnitude;
515         }
516         
517         // we can't give people infinite ethereum
518         if(tokenSupply_ > 0){
519             
520             // add tokens to the pool
521             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
522  
523             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
524             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
525             
526             // calculate the amount of tokens the customer receives over his purchase 
527             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
528         
529         } else {
530             // add tokens to the pool
531             tokenSupply_ = _amountOfTokens;
532         }
533         
534         // update circulating supply & the ledger address for the customer
535         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
536         
537         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
538         //really i know you think you do but you don't
539         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
540         payoutsTo_[_customerAddress] += _updatedPayouts;
541         
542         // fire event
543         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
544         
545         return _amountOfTokens;
546     }
547 
548     /**
549      * Calculate Token price based on an amount of incoming ethereum
550      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
551      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
552      */
553     function ethereumToTokens_(uint256 _ethereum)
554         internal
555         view
556         returns(uint256)
557     {
558         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
559         uint256 _tokensReceived = 
560          (
561             (
562                 // underflow attempts BTFO
563                 SafeMath.sub(
564                     (sqrt
565                         (
566                             (_tokenPriceInitial**2)
567                             +
568                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
569                             +
570                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
571                             +
572                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
573                         )
574                     ), _tokenPriceInitial
575                 )
576             )/(tokenPriceIncremental_)
577         )-(tokenSupply_)
578         ;
579   
580         return _tokensReceived;
581     }
582     
583     /**
584      * Calculate token sell value.
585      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
586      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
587      */
588      function tokensToEthereum_(uint256 _tokens)
589         internal
590         view
591         returns(uint256)
592     {
593 
594         uint256 tokens_ = (_tokens + 1e18);
595         uint256 _tokenSupply = (tokenSupply_ + 1e18);
596         uint256 _etherReceived =
597         (
598             // underflow attempts BTFO
599             SafeMath.sub(
600                 (
601                     (
602                         (
603                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
604                         )-tokenPriceIncremental_
605                     )*(tokens_ - 1e18)
606                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
607             )
608         /1e18);
609         return _etherReceived;
610     }
611     
612     
613     //This is where all your gas goes, sorry
614     //Not sorry, you probably only paid 1 gwei
615     function sqrt(uint x) internal pure returns (uint y) {
616         uint z = (x + 1) / 2;
617         y = x;
618         while (z < y) {
619             y = z;
620             z = (x / z + z) / 2;
621         }
622     }
623 }
624 
625 /**
626  * @title SafeMath
627  * @dev Math operations with safety checks that throw on error
628  */
629 library SafeMath {
630 
631     /**
632     * @dev Multiplies two numbers, throws on overflow.
633     */
634     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
635         if (a == 0) {
636             return 0;
637         }
638         uint256 c = a * b;
639         assert(c / a == b);
640         return c;
641     }
642 
643     /**
644     * @dev Integer division of two numbers, truncating the quotient.
645     */
646     function div(uint256 a, uint256 b) internal pure returns (uint256) {
647         // assert(b > 0); // Solidity automatically throws when dividing by 0
648         uint256 c = a / b;
649         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
650         return c;
651     }
652 
653     /**
654     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
655     */
656     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
657         assert(b <= a);
658         return a - b;
659     }
660 
661     /**
662     * @dev Adds two numbers, throws on overflow.
663     */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) {
665         uint256 c = a + b;
666         assert(c >= a);
667         return c;
668     }
669 }