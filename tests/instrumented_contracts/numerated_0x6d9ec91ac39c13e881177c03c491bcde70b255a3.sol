1 pragma solidity ^0.4.24;
2 
3 //  
4 // /$$      /$$           /$$                       /$$$$$$ /$$           /$$$$$$$            /$$          
5 //| $$$    /$$$          | $$                      |_  $$_/| $$          | $$__  $$          |__/          
6 //| $$$$  /$$$$  /$$$$$$ | $$   /$$  /$$$$$$         | $$ /$$$$$$        | $$  \ $$  /$$$$$$  /$$ /$$$$$$$ 
7 //| $$ $$/$$ $$ |____  $$| $$  /$$/ /$$__  $$        | $$|_  $$_/        | $$$$$$$/ |____  $$| $$| $$__  $$
8 //| $$  $$$| $$  /$$$$$$$| $$$$$$/ | $$$$$$$$        | $$  | $$          | $$__  $$  /$$$$$$$| $$| $$  \ $$
9 //| $$\  $ | $$ /$$__  $$| $$_  $$ | $$_____/        | $$  | $$ /$$      | $$  \ $$ /$$__  $$| $$| $$  | $$
10 //| $$ \/  | $$|  $$$$$$$| $$ \  $$|  $$$$$$$       /$$$$$$|  $$$$/      | $$  | $$|  $$$$$$$| $$| $$  | $$
11 //|__/     |__/ \_______/|__/  \__/ \_______/      |______/ \___/        |__/  |__/ \_______/|__/|__/  |__/
12 //                                                                                                         
13 //  site:     https://makingitrain.me
14 //
15 //  support:  makingitraindev@gmail.com
16 //
17 //  discord:  https://discord.gg/kndpqU3
18 //                                                                                                    
19 
20 
21 contract Rain {
22     /*=================================
23     =            MODIFIERS            =
24     =================================*/
25     // only people with tokens
26     modifier onlyBagholders() {
27         require(myTokens() > 0);
28         _;
29     }
30     
31     // only people with profits
32     modifier onlyStronghands() {
33         require(myDividends(true) > 0);
34         _;
35     }
36     
37     // administrator can:
38     // -> change the name of the contract
39     // -> change the name of the token
40     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
41     // they CANNOT:
42     // -> take funds
43     // -> disable withdrawals
44     // -> kill the contract
45     // -> change the price of tokens
46     modifier onlyAdministrator(){
47         require(msg.sender == owner);
48         _;
49     }
50     
51     modifier limitBuy() { 
52         if(limit && msg.value > 3 ether) { // check if the transaction is over 3 ether and limit is active
53             if ((msg.value) < address(this).balance && (address(this).balance-(msg.value)) >= 50 ether) { // if contract reaches 50 ether disable limit
54                 limit = false;
55             }
56             else {
57                 revert(); // revert the transaction
58             }
59         }
60         _;
61     }
62 
63     /*==============================
64     =            EVENTS            =
65     ==============================*/
66     event onTokenPurchase(
67         address indexed customerAddress,
68         uint256 incomingEthereum,
69         uint256 tokensMinted,
70         address indexed referredBy
71     );
72     
73     event onTokenSell(
74         address indexed customerAddress,
75         uint256 tokensBurned,
76         uint256 ethereumEarned
77     );
78     
79     event onReinvestment(
80         address indexed customerAddress,
81         uint256 ethereumReinvested,
82         uint256 tokensMinted
83     );
84     
85     event onWithdraw(
86         address indexed customerAddress,
87         uint256 ethereumWithdrawn
88     );
89 
90     event OnRedistribution (
91         uint256 amount,
92         uint256 timestamp
93     );
94     
95     // ERC20
96     event Transfer(
97         address indexed from,
98         address indexed to,
99         uint256 tokens
100     );
101     
102     
103     /*=====================================
104     =            CONFIGURABLES            =
105     =====================================*/
106     string public name = "Rain";
107     string public symbol = "Rain";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 20; // 20%
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113     
114     // proof of stake (defaults at 10 tokens)
115     uint256 public stakingRequirement = 0;
116     
117     
118     
119    /*================================
120     =            DATASETS            =
121     ================================*/
122     // amount of shares for each address (scaled number)
123     mapping(address => uint256) internal tokenBalanceLedger_;
124     mapping(address => address) internal referralOf_;
125     mapping(address => uint256) internal referralBalance_;
126     mapping(address => int256) internal payoutsTo_;
127     mapping(address => bool) internal alreadyBought;
128     uint256 internal tokenSupply_ = 0;
129     uint256 internal profitPerShare_;
130     mapping(address => bool) internal whitelisted_;
131     bool internal whitelist_ = true;
132     bool internal limit = true;
133     
134     address public owner;
135     
136 
137 
138     /*=======================================
139     =            PUBLIC FUNCTIONS            =
140     =======================================*/
141     /*
142     * -- APPLICATION ENTRY POINTS --  
143     */
144     constructor()
145         public
146     {
147         owner = msg.sender;
148         whitelisted_[msg.sender] = true;
149 
150         whitelist_ = false;
151     }
152     
153      
154     /**
155      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
156      */
157     function buy(address _referredBy)
158         public
159         payable
160         returns(uint256)
161     {
162         purchaseTokens(msg.value, _referredBy);
163     }
164     
165     /**
166      * Fallback function to handle ethereum that was send straight to the contract
167      * Unfortunately we cannot use a referral address this way.
168      */
169     function()
170         payable
171         public
172     {
173         purchaseTokens(msg.value, 0x0);
174     }
175     
176     /**
177      * Converts all of caller's dividends to tokens.
178      */
179     function reinvest()
180         onlyStronghands()
181         public
182     {
183         // fetch dividends
184         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
185         
186         // pay out the dividends virtually
187         address _customerAddress = msg.sender;
188         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
189         
190         // retrieve ref. bonus
191         _dividends += referralBalance_[_customerAddress];
192         referralBalance_[_customerAddress] = 0;
193         
194         // dispatch a buy order with the virtualized "withdrawn dividends"
195         uint256 _tokens = purchaseTokens(_dividends, 0x0);
196         
197         // fire event
198         emit onReinvestment(_customerAddress, _dividends, _tokens);
199     }
200     
201     /**
202      * Alias of sell() and withdraw().
203      */
204     function exit()
205         public
206     {
207         // get token count for caller & sell them all
208         address _customerAddress = msg.sender;
209         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
210         if(_tokens > 0) sell(_tokens);
211         
212         // lambo delivery service
213         withdraw();
214     }
215 
216     /**
217      * Withdraws all of the callers earnings.
218      */
219     function withdraw()
220         onlyStronghands()
221         public
222     {
223         // setup data
224         address _customerAddress = msg.sender;
225         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
226         
227         // update dividend tracker
228         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
229         
230         // add ref. bonus
231         _dividends += referralBalance_[_customerAddress];
232         referralBalance_[_customerAddress] = 0;
233         
234         // lambo delivery service
235         _customerAddress.transfer(_dividends);
236         
237         // fire event
238         emit onWithdraw(_customerAddress, _dividends);
239     }
240     
241     /**
242      * Liquifies tokens to ethereum.
243      */
244     function sell(uint256 _amountOfTokens)
245         onlyBagholders()
246         public
247     {
248         // setup data
249         address _customerAddress = msg.sender;
250         // russian hackers BTFO
251         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
252         uint256 _tokens = _amountOfTokens;
253         uint256 _ethereum = tokensToEthereum_(_tokens);
254         
255         uint256 _undividedDividends = SafeMath.div(_ethereum*dividendFee_, 100); // 20% dividendFee_
256         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
257         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
258 
259  
260         
261         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends));
262 
263         address _referredBy = referralOf_[_customerAddress];
264         
265         if(
266             // is this a referred purchase?
267             _referredBy != 0x0000000000000000000000000000000000000000 &&
268 
269             // no cheating!
270             _referredBy != _customerAddress &&
271             
272             // does the referrer have at least X whole tokens?
273             // i.e is the referrer a godly chad masternode
274             tokenBalanceLedger_[_referredBy] >= stakingRequirement
275         ){
276 
277             // wealth redistribution
278             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
279 
280             address tier2 = referralOf_[_referredBy];
281 
282             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
283                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
284 
285                 //address tier3 = referralOf_[tier2];
286                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
287                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
288                     }
289                 else {
290                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
291                 }
292             }
293             else {
294                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
295             }
296             
297         } else {
298             // no ref purchase
299             // add the referral bonus back to the global dividends cake
300             _dividends = SafeMath.add(_dividends, _referralBonus);
301         }
302 
303         // burn the sold tokens
304         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
305         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
306         
307         // update dividends tracker
308         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
309         payoutsTo_[_customerAddress] -= _updatedPayouts;       
310         
311         // dividing by zero is a bad idea
312         if (tokenSupply_ > 0) {
313             // update the amount of dividends per token
314             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
315         }
316         
317         // fire event
318         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
319     }
320     
321      /**
322      * Transfer tokens from the caller to a new holder.
323      * 0% fee.
324      */
325     function transfer(address _toAddress, uint256 _amountOfTokens)
326         onlyBagholders()
327         public
328         returns(bool)
329     {
330         // setup
331         address _customerAddress = msg.sender;
332         
333         // make sure we have the requested tokens
334         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
335         
336         // withdraw all outstanding dividends first
337         if(myDividends(true) > 0) withdraw();
338 
339         // exchange tokens
340         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
341         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
342         
343         // update dividend trackers
344         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
345         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
346         
347         // fire event
348         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
349         
350         // ERC20
351         return true;
352        
353     }
354 
355     /**
356     * redistribution of dividends
357      */
358     function redistribution()
359         external
360         payable
361     {
362         // setup
363         uint256 ethereum = msg.value;
364         
365         // disperse ethereum among holders
366         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
367         
368         // fire event
369         emit OnRedistribution(ethereum, block.timestamp);
370     }
371     
372     /**
373      * In case one of us dies, we need to replace ourselves.
374      */
375     function setAdministrator(address _newAdmin)
376         onlyAdministrator()
377         external
378     {
379         owner = _newAdmin;
380     }
381     
382     /**
383      * Precautionary measures in case we need to adjust the masternode rate.
384      */
385     function setStakingRequirement(uint256 _amountOfTokens)
386         onlyAdministrator()
387         public
388     {
389         stakingRequirement = _amountOfTokens;
390     }
391     
392     /**
393      * If we want to rebrand, we can.
394      */
395     function setName(string _name)
396         onlyAdministrator()
397         public
398     {
399         name = _name;
400     }
401     
402     /**
403      * If we want to rebrand, we can.
404      */
405     function setSymbol(string _symbol)
406         onlyAdministrator()
407         public
408     {
409         symbol = _symbol;
410     }
411 
412     
413     /*----------  HELPERS AND CALCULATORS  ----------*/
414     /**
415      * Method to view the current Ethereum stored in the contract
416      * Example: totalEthereumBalance()
417      */
418     function totalEthereumBalance()
419         public
420         view
421         returns(uint)
422     {
423         return address(this).balance;
424     }
425     
426     /**
427      * Retrieve the total token supply.
428      */
429     function totalSupply()
430         public
431         view
432         returns(uint256)
433     {
434         return tokenSupply_;
435     }
436     
437     /**
438      * Retrieve the tokens owned by the caller.
439      */
440     function myTokens()
441         public
442         view
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return balanceOf(_customerAddress);
447     }
448     
449     /**
450      * Retrieve the dividends owned by the caller.
451      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
452      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
453      * But in the internal calculations, we want them separate. 
454      */ 
455     function myDividends(bool _includeReferralBonus) 
456         public 
457         view 
458         returns(uint256)
459     {
460         address _customerAddress = msg.sender;
461         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
462     }
463     
464     /**
465      * Retrieve the token balance of any single address.
466      */
467     function balanceOf(address _customerAddress)
468         view
469         public
470         returns(uint256)
471     {
472         return tokenBalanceLedger_[_customerAddress];
473     }
474     
475     /**
476      * Retrieve the dividend balance of any single address.
477      */
478     function dividendsOf(address _customerAddress)
479         view
480         public
481         returns(uint256)
482     {
483         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
484     }
485     
486     /**
487      * Return the buy price of 1 individual token.
488      */
489     function sellPrice() 
490         public 
491         view 
492         returns(uint256)
493     {
494         // our calculation relies on the token supply, so we need supply. Doh.
495         if(tokenSupply_ == 0){
496             return tokenPriceInitial_ - tokenPriceIncremental_;
497         } else {
498             uint256 _ethereum = tokensToEthereum_(1e18);
499             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
500             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
501             return _taxedEthereum;
502         }
503     }
504     
505     /**
506      * Return the sell price of 1 individual token.
507      */
508     function buyPrice() 
509         public 
510         view 
511         returns(uint256)
512     {
513         // our calculation relies on the token supply, so we need supply. Doh.
514         if(tokenSupply_ == 0){
515             return tokenPriceInitial_ + tokenPriceIncremental_;
516         } else {
517             uint256 _ethereum = tokensToEthereum_(1e18);
518             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
519             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
520             return _taxedEthereum;
521         }
522     }
523     
524     /**
525      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
526      */
527     function calculateTokensReceived(uint256 _ethereumToSpend) 
528         public 
529         view 
530         returns(uint256)
531     {
532         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
533         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
534         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
535         
536         return _amountOfTokens;
537     }
538     
539     /**
540      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
541      */
542     function calculateEthereumReceived(uint256 _tokensToSell) 
543         public 
544         view 
545         returns(uint256)
546     {
547         require(_tokensToSell <= tokenSupply_);
548         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
549         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
550         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
551         return _taxedEthereum;
552     }
553     
554     function disableWhitelist() onlyAdministrator() external {
555         whitelist_ = false;
556     }
557 
558     /*==========================================
559     =            INTERNAL FUNCTIONS            =
560     ==========================================*/
561     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
562         limitBuy()
563         internal
564         returns(uint256)
565     {   
566         
567         //As long as the whitelist is true, only whitelisted people are allowed to buy.
568 
569         // if the person is not whitelisted but whitelist is true/active, revert the transaction
570         if (whitelisted_[msg.sender] == false && whitelist_ == true) { 
571             revert();
572         }
573         // data setup
574         address _customerAddress = msg.sender;
575         uint256 _undividedDividends = SafeMath.div(_incomingEthereum*dividendFee_, 100); // 20% dividendFee_
576    
577 
578         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
579 
580         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
581 
582         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends));
583         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
584         uint256 _fee = _dividends * magnitude;
585 
586 
587         // no point in continuing execution if OP is a poorfag russian hacker
588         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
589         // (or hackers)
590         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
591         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
592         
593         // is the user referred by a masternode?
594         if(
595             // is this a referred purchase?
596             _referredBy != 0x0000000000000000000000000000000000000000 &&
597 
598             // no cheating!
599             _referredBy != _customerAddress &&
600             
601             // does the referrer have at least X whole tokens?
602             // i.e is the referrer a godly chad masternode
603             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
604 
605             referralOf_[_customerAddress] == 0x0000000000000000000000000000000000000000 &&
606 
607             alreadyBought[_customerAddress] == false
608         ){
609             referralOf_[_customerAddress] = _referredBy;
610             
611             // wealth redistribution
612             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
613 
614             address tier2 = referralOf_[_referredBy];
615 
616             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
617                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
618 
619                 //address tier3 = referralOf_[tier2];
620 
621                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
622                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
623                     }
624                 else {
625                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
626                     _fee = _dividends * magnitude;
627                 }
628             }
629             else {
630                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
631                 _fee = _dividends * magnitude;
632             }
633             
634         } else {
635             // no ref purchase
636             // add the referral bonus back to the global dividends cake
637             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], (_referralBonus / 2));
638             _dividends = SafeMath.add(_dividends, _referralBonus / 2);
639             _fee = _dividends * magnitude;
640         }
641         
642         // we can't give people infinite ethereum
643         if(tokenSupply_ > 0){
644             
645             // add tokens to the pool
646             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
647  
648             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
649             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
650             
651             // calculate the amount of tokens the customer receives over his purchase 
652             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
653         
654         } else {
655             // add tokens to the pool
656             tokenSupply_ = _amountOfTokens;
657         }
658         
659         // update circulating supply & the ledger address for the customer
660         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
661         
662         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
663         //really i know you think you do but you don't
664         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
665         payoutsTo_[_customerAddress] += _updatedPayouts;
666         alreadyBought[_customerAddress] = true;
667         // fire event
668         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
669         
670         return _amountOfTokens;
671     }
672 
673     /**
674      * Calculate Token price based on an amount of incoming ethereum
675      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
676      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
677      */
678     function ethereumToTokens_(uint256 _ethereum)
679         internal
680         view
681         returns(uint256)
682     {
683         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
684         uint256 _tokensReceived = 
685          (
686             (
687                 // underflow attempts BTFO
688                 SafeMath.sub(
689                     (sqrt
690                         (
691                             (_tokenPriceInitial**2)
692                             +
693                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
694                             +
695                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
696                             +
697                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
698                         )
699                     ), _tokenPriceInitial
700                 )
701             )/(tokenPriceIncremental_)
702         )-(tokenSupply_)
703         ;
704   
705         return _tokensReceived;
706     }
707     
708     /**
709      * Calculate token sell value.
710      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
711      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
712      */
713     function tokensToEthereum_(uint256 _tokens)
714         internal
715         view
716         returns(uint256)
717     {
718 
719         uint256 tokens_ = (_tokens + 1e18);
720         uint256 _tokenSupply = (tokenSupply_ + 1e18);
721         uint256 _etherReceived =
722         (
723             // underflow attempts BTFO
724             SafeMath.sub(
725                 (
726                     (
727                         (
728                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
729                         )-tokenPriceIncremental_
730                     )*(tokens_ - 1e18)
731                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
732             )
733         /1e18);
734         return _etherReceived;
735     }
736     
737     
738     //This is where all your gas goes, sorry
739     //Not sorry, you probably only paid 1 gwei
740     function sqrt(uint x) internal pure returns (uint y) {
741         uint z = (x + 1) / 2;
742         y = x;
743         while (z < y) {
744             y = z;
745             z = (x / z + z) / 2;
746         }
747     }
748 }
749 
750 /**
751  * @title SafeMath
752  * @dev Math operations with safety checks that throw on error
753  */
754 library SafeMath {
755 
756     /**
757     * @dev Multiplies two numbers, throws on overflow.
758     */
759     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
760         if (a == 0) {
761             return 0;
762         }
763         uint256 c = a * b;
764         assert(c / a == b);
765         return c;
766     }
767 
768     /**
769     * @dev Integer division of two numbers, truncating the quotient.
770     */
771     function div(uint256 a, uint256 b) internal pure returns (uint256) {
772         // assert(b > 0); // Solidity automatically throws when dividing by 0
773         uint256 c = a / b;
774         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
775         return c;
776     }
777 
778     /**
779     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
780     */
781     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
782         assert(b <= a);
783         return a - b;
784     }
785 
786     /**
787     * @dev Adds two numbers, throws on overflow.
788     */
789     function add(uint256 a, uint256 b) internal pure returns (uint256) {
790         uint256 c = a + b;
791         assert(c >= a);
792         return c;
793     }
794 }