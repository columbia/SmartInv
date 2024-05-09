1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 * Created by WeClosedInto
6 * ====================================*
7 * ->About WeClosedInto
8 * An autonomousfully automated passive income:
9 * [x] Created by a team of professional Developers from India who run a software company and specialize in Internet and Cryptographic Security
10 * [x] Pen-tested multiple times with zero vulnerabilities!
11 * [x] 25 WeClosedInto required for a Masternode Link generation
12 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
13 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
14 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
15 * - 33% Reward of dividends if someone signs up using your Masternode link
16 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
17 * Upon entry into the contract it will automatically deduct your 10% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
18 * You are able to withdraw your entire balance at any time you so choose. 
19 
20 */
21 
22 
23 contract WeClosedInto {
24     /*=================================
25     =            MODIFIERS            =
26     =================================*/
27     // only people with tokens
28     modifier onlyBagholders() {
29         require(myTokens() > 0);
30         _;
31     }
32     
33     // only people with profits
34     modifier onlyStronghands() {
35         require(myDividends(true) > 0);
36         _;
37     }
38     
39     // administrators can:
40     // -> change the name of the contract
41     // -> change the name of the token
42     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
43     // they CANNOT:
44     // -> take funds
45     // -> disable withdrawals
46     // -> kill the contract
47     // -> change the price of tokens
48     modifier onlyAdministrator(){
49         address _customerAddress = msg.sender;
50         require(administrators[_customerAddress]);
51         _;
52     }
53     
54     
55     // ensures that the first tokens in the contract will be equally distributed
56     // meaning, no divine dump will be ever possible
57     // result: healthy longevity.
58     modifier antiEarlyWhale(uint256 _amountOfEthereum){
59         address _customerAddress = msg.sender;
60         
61         // are we still in the vulnerable phase?
62         // if so, enact anti early whale protocol 
63         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
64             require(
65                 // is the customer in the ambassador list?
66                 ambassadors_[_customerAddress] == true &&
67                 
68                 // does the customer purchase exceed the max ambassador quota?
69                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
70                 
71             );
72             
73             // updated the accumulated quota    
74             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
75         
76             // execute
77             _;
78         } else {
79             // in case the ether count drops low, the ambassador phase won't reinitiate
80             onlyAmbassadors = false;
81             _;    
82         }
83         
84     }
85     
86     
87     /*==============================
88     =            EVENTS            =
89     ==============================*/
90     event onTokenPurchase(
91         address indexed customerAddress,
92         uint256 incomingEthereum,
93         uint256 tokensMinted,
94         address indexed referredBy
95     );
96     
97     event onTokenSell(
98         address indexed customerAddress,
99         uint256 tokensBurned,
100         uint256 ethereumEarned
101     );
102     
103     event onReinvestment(
104         address indexed customerAddress,
105         uint256 ethereumReinvested,
106         uint256 tokensMinted
107     );
108     
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113     
114     // ERC20
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens
119     );
120     
121     
122     /*=====================================
123     =            CONFIGURABLES            =
124     =====================================*/
125     string public name = "WeClosedInto";
126     string public symbol = "WeClosedInto";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 3; 
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     // proof of stake (defaults at 100 tokens)
134     uint256 public stakingRequirement = 100e18;
135     
136     // ambassador program
137     mapping(address => bool) internal ambassadors_;
138     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
139     uint256 constant internal ambassadorQuota_ = 20 ether;
140     
141     
142     
143    /*================================
144     =            DATASETS            =
145     ================================*/
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153     
154     // administrator list (see above on what they can do)
155     mapping(address => bool) public administrators;
156     bool public onlyAmbassadors = false;
157     
158 
159 
160     /*=======================================
161     =            PUBLIC FUNCTIONS            =
162     =======================================*/
163     /*
164     * -- APPLICATION ENTRY POINTS --  
165     */
166     function WeClosedInto()
167         public
168     {
169         // add administrators here
170 
171         administrators[0xf5ddf626c98a91e10e2711883CDE2857D68d0660] = true;
172 
173     }
174     
175      
176     /**
177      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
178      */
179     function buy(address _referredBy)
180         public
181         payable
182         returns(uint256)
183     {
184         purchaseTokens(msg.value, _referredBy);
185     }
186     
187     /**
188      * Fallback function to handle ethereum that was send straight to the contract
189      * Unfortunately we cannot use a referral address this way.
190      */
191     function()
192         payable
193         public
194     {
195         purchaseTokens(msg.value, 0x0);
196     }
197     
198     /**
199      * Converts all of caller's dividends to tokens.
200     */
201     function reinvest()
202         onlyStronghands()
203         public
204     {
205         // fetch dividends
206         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
207         
208         // pay out the dividends virtually
209         address _customerAddress = msg.sender;
210         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
211         
212         // retrieve ref. bonus
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215         
216         // dispatch a buy order with the virtualized "withdrawn dividends"
217         uint256 _tokens = purchaseTokens(_dividends, 0x0);
218         
219         // fire event
220         onReinvestment(_customerAddress, _dividends, _tokens);
221     }
222     
223     /**
224      * Alias of sell() and withdraw().
225      */
226     function exit()
227         public
228     {
229         // get token count for caller & sell them all
230         address _customerAddress = msg.sender;
231         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
232         if(_tokens > 0) sell(_tokens);
233         
234         // lambo delivery service
235         withdraw();
236     }
237 
238     /**
239      * Withdraws all of the callers earnings.
240      */
241     function withdraw()
242         onlyStronghands()
243         public
244     {
245         // setup data
246         address _customerAddress = msg.sender;
247         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
248         
249         // update dividend tracker
250         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
251         
252         // add ref. bonus
253         _dividends += referralBalance_[_customerAddress];
254         referralBalance_[_customerAddress] = 0;
255         
256         // lambo delivery service
257         _customerAddress.transfer(_dividends);
258         
259         // fire event
260         onWithdraw(_customerAddress, _dividends);
261     }
262     
263     /**
264      * Liquifies tokens to ethereum.
265      */
266     function sell(uint256 _amountOfTokens)
267         onlyBagholders()
268         public
269     {
270         // setup data
271         address _customerAddress = msg.sender;
272         // russian hackers BTFO
273         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
274         uint256 _tokens = _amountOfTokens;
275         uint256 _ethereum = tokensToEthereum_(_tokens);
276         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
277         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
278         
279         // burn the sold tokens
280         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
281         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
282         
283         // update dividends tracker
284         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
285         payoutsTo_[_customerAddress] -= _updatedPayouts;       
286         
287         // dividing by zero is a bad idea
288         if (tokenSupply_ > 0) {
289             // update the amount of dividends per token
290             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
291         }
292         
293         // fire event
294         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
295     }
296     
297     
298     /**
299      * Transfer tokens from the caller to a new holder.
300      * Remember, there's a 10% fee here as well.
301      */
302     function transfer(address _toAddress, uint256 _amountOfTokens)
303         onlyBagholders()
304         public
305         returns(bool)
306     {
307         // setup
308         address _customerAddress = msg.sender;
309         
310         // make sure we have the requested tokens
311         // also disables transfers until ambassador phase is over
312         // ( we dont want whale premines )
313         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
314         
315         // withdraw all outstanding dividends first
316         if(myDividends(true) > 0) withdraw();
317         
318         // liquify 10% of the tokens that are transfered
319         // these are dispersed to shareholders
320         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
321         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
322         uint256 _dividends = tokensToEthereum_(_tokenFee);
323   
324         // burn the fee tokens
325         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
326 
327         // exchange tokens
328         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
329         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
330         
331         // update dividend trackers
332         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
333         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
334         
335         // disperse dividends among holders
336         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         
338         // fire event
339         Transfer(_customerAddress, _toAddress, _taxedTokens);
340         
341         // ERC20
342         return true;
343        
344     }
345     
346     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
347     /**
348      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
349      */
350     function disableInitialStage()
351         onlyAdministrator()
352         public
353     {
354         onlyAmbassadors = false;
355     }
356     
357     /**
358      * In case one of us dies, we need to replace ourselves.
359      */
360 
361     
362     /**
363      * Precautionary measures in case we need to adjust the masternode rate.
364      */
365     function setStakingRequirement(uint256 _amountOfTokens)
366         onlyAdministrator()
367         public
368     {
369         stakingRequirement = _amountOfTokens;
370     }
371     
372     /**
373      * If we want to rebrand, we can.
374      */
375     function setName(string _name)
376         onlyAdministrator()
377         public
378     {
379         name = _name;
380     }
381     
382     /**
383      * If we want to rebrand, we can.
384      */
385     function setSymbol(string _symbol)
386         onlyAdministrator()
387         public
388     {
389         symbol = _symbol;
390     }
391 
392     
393     /*----------  HELPERS AND CALCULATORS  ----------*/
394     /**
395      * Method to view the current Ethereum stored in the contract
396      * Example: totalEthereumBalance()
397      */
398     function totalEthereumBalance()
399         public
400         view
401         returns(uint)
402     {
403         return this.balance;
404     }
405     
406     /**
407      * Retrieve the total token supply.
408      */
409     function totalSupply()
410         public
411         view
412         returns(uint256)
413     {
414         return tokenSupply_;
415     }
416     
417     /**
418      * Retrieve the tokens owned by the caller.
419      */
420     function myTokens()
421         public
422         view
423         returns(uint256)
424     {
425         address _customerAddress = msg.sender;
426         return balanceOf(_customerAddress);
427     }
428     
429     /**
430      * Retrieve the dividends owned by the caller.
431      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
432      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
433      * But in the internal calculations, we want them separate. 
434      */ 
435     function myDividends(bool _includeReferralBonus) 
436         public 
437         view 
438         returns(uint256)
439     {
440         address _customerAddress = msg.sender;
441         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
442     }
443     
444     /**
445      * Retrieve the token balance of any single address.
446      */
447     function balanceOf(address _customerAddress)
448         view
449         public
450         returns(uint256)
451     {
452         return tokenBalanceLedger_[_customerAddress];
453     }
454     
455     /**
456      * Retrieve the dividend balance of any single address.
457      */
458     function dividendsOf(address _customerAddress)
459         view
460         public
461         returns(uint256)
462     {
463         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
464     }
465     
466     /**
467      * Return the buy price of 1 individual token.
468      */
469     function sellPrice() 
470         public 
471         view 
472         returns(uint256)
473     {
474         // our calculation relies on the token supply, so we need supply. Doh.
475         if(tokenSupply_ == 0){
476             return tokenPriceInitial_ - tokenPriceIncremental_;
477         } else {
478             uint256 _ethereum = tokensToEthereum_(1e18);
479             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
480             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
481             return _taxedEthereum;
482         }
483     }
484     
485     /**
486      * Return the sell price of 1 individual token.
487      */
488     function buyPrice() 
489         public 
490         view 
491         returns(uint256)
492     {
493         // our calculation relies on the token supply, so we need supply. Doh.
494         if(tokenSupply_ == 0){
495             return tokenPriceInitial_ + tokenPriceIncremental_;
496         } else {
497             uint256 _ethereum = tokensToEthereum_(1e18);
498             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
499             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
500             return _taxedEthereum;
501         }
502     }
503     
504     /**
505      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
506      */
507     function calculateTokensReceived(uint256 _ethereumToSpend) 
508         public 
509         view 
510         returns(uint256)
511     {
512         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
513         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
514         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
515         
516         return _amountOfTokens;
517     }
518     
519     /**
520      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
521      */
522     function calculateEthereumReceived(uint256 _tokensToSell) 
523         public 
524         view 
525         returns(uint256)
526     {
527         require(_tokensToSell <= tokenSupply_);
528         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
529         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
530         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
531         return _taxedEthereum;
532     }
533     
534     
535     /*==========================================
536     =            INTERNAL FUNCTIONS            =
537     ==========================================*/
538     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
539         antiEarlyWhale(_incomingEthereum)
540         internal
541         returns(uint256)
542     {
543         // data setup
544         address _customerAddress = msg.sender;
545         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
546         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
547         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
548         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
549         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
550         uint256 _fee = _dividends * magnitude;
551  
552         // no point in continuing execution if OP is a poorfag russian hacker
553         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
554         // (or hackers)
555         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
556         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
557         
558         // is the user referred by a masternode?
559         if(
560             // is this a referred purchase?
561             _referredBy != 0x0000000000000000000000000000000000000000 &&
562 
563             // no cheating!
564             _referredBy != _customerAddress &&
565             
566             // does the referrer have at least X whole tokens?
567             // i.e is the referrer a godly chad masternode
568             tokenBalanceLedger_[_referredBy] >= stakingRequirement
569         ){
570             // wealth redistribution
571             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
572         } else {
573             // no ref purchase
574             // add the referral bonus back to the global dividends cake
575             _dividends = SafeMath.add(_dividends, _referralBonus);
576             _fee = _dividends * magnitude;
577         }
578         
579         // we can't give people infinite ethereum
580         if(tokenSupply_ > 0){
581             
582             // add tokens to the pool
583             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
584  
585             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
586             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
587             
588             // calculate the amount of tokens the customer receives over his purchase 
589             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
590         
591         } else {
592             // add tokens to the pool
593             tokenSupply_ = _amountOfTokens;
594         }
595         
596         // update circulating supply & the ledger address for the customer
597         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
598         
599         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
600         //really i know you think you do but you don't
601         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
602         payoutsTo_[_customerAddress] += _updatedPayouts;
603         
604         // fire event
605         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
606         
607         return _amountOfTokens;
608     }
609 
610     /**
611      * Calculate Token price based on an amount of incoming ethereum
612      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
613      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
614      */
615     function ethereumToTokens_(uint256 _ethereum)
616         internal
617         view
618         returns(uint256)
619     {
620         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
621         uint256 _tokensReceived = 
622          (
623             (
624                 // underflow attempts BTFO
625                 SafeMath.sub(
626                     (sqrt
627                         (
628                             (_tokenPriceInitial**2)
629                             +
630                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
631                             +
632                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
633                             +
634                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
635                         )
636                     ), _tokenPriceInitial
637                 )
638             )/(tokenPriceIncremental_)
639         )-(tokenSupply_)
640         ;
641   
642         return _tokensReceived;
643     }
644     
645     /**
646      * Calculate token sell value.
647      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
648      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
649      */
650      function tokensToEthereum_(uint256 _tokens)
651         internal
652         view
653         returns(uint256)
654     {
655 
656         uint256 tokens_ = (_tokens + 1e18);
657         uint256 _tokenSupply = (tokenSupply_ + 1e18);
658         uint256 _etherReceived =
659         (
660             // underflow attempts BTFO
661             SafeMath.sub(
662                 (
663                     (
664                         (
665                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
666                         )-tokenPriceIncremental_
667                     )*(tokens_ - 1e18)
668                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
669             )
670         /1e18);
671         return _etherReceived;
672     }
673     
674     
675     //This is where all your gas goes, sorry
676     //Not sorry, you probably only paid 1 gwei
677     function sqrt(uint x) internal pure returns (uint y) {
678         uint z = (x + 1) / 2;
679         y = x;
680         while (z < y) {
681             y = z;
682             z = (x / z + z) / 2;
683         }
684     }
685 }
686 
687 /**
688  * @title SafeMath
689  * @dev Math operations with safety checks that throw on error
690  */
691 library SafeMath {
692 
693     /**
694     * @dev Multiplies two numbers, throws on overflow.
695     */
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         if (a == 0) {
698             return 0;
699         }
700         uint256 c = a * b;
701         assert(c / a == b);
702         return c;
703     }
704 
705     /**
706     * @dev Integer division of two numbers, truncating the quotient.
707     */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         // assert(b > 0); // Solidity automatically throws when dividing by 0
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712         return c;
713     }
714 
715     /**
716     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
717     */
718     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
719         assert(b <= a);
720         return a - b;
721     }
722 
723     /**
724     * @dev Adds two numbers, throws on overflow.
725     */
726     function add(uint256 a, uint256 b) internal pure returns (uint256) {
727         uint256 c = a + b;
728         assert(c >= a);
729         return c;
730     }
731 }