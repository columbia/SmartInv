1 pragma solidity ^0.4.20;
2 
3 /*
4 https://discord.gg/TQPCqnz
5 P3D with new rules:
6 > 1 ETH buy in per 2 minutes
7 > Cannot sell/transfer/withdraw for 2 hours since last ETH buy in (reinvest doesnt up this timer)
8 > No transfer fees
9 
10 */
11 
12 contract POMoooon {
13     /*=================================
14     =            MODIFIERS            =
15     =================================*/
16     // only people with tokens
17     modifier onlyBagholders() {
18         require(myTokens() > 0);
19         _;
20     }
21     
22     // only people with profits
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27     
28     mapping (address => uint256) public sellTmr;
29     mapping (address => uint256) public buyTmr;
30     
31     uint256 sellTimerN = (2 hours);
32     uint256 buyTimerN = (2 minutes);
33     
34     uint256 buyMax = 1 ether;
35     
36     
37     modifier sellLimit(){
38         require(block.timestamp > sellTmr[msg.sender] , "You cannot sell because of the sell timer");
39         
40         _;
41     }
42     
43     modifier buyLimit(){
44         require(block.timestamp > buyTmr[msg.sender], "You cannot buy because of buy cooldown");
45         require(msg.value <= buyMax, "You cannot buy because you bought over the max");
46         buyTmr[msg.sender] = block.timestamp + buyTimerN;
47         sellTmr[msg.sender] = block.timestamp + sellTimerN;
48         _;
49     }
50     
51     // administrators can:
52     // -> change the name of the contract
53     // -> change the name of the token
54     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
55     // they CANNOT:
56     // -> take funds
57     // -> disable withdrawals
58     // -> kill the contract
59     // -> change the price of tokens
60     modifier onlyAdministrator(){
61         address _customerAddress = msg.sender;
62         require(administrators[_customerAddress]);
63         _;
64     }
65     
66     
67     // ensures that the first tokens in the contract will be equally distributed
68     // meaning, no divine dump will be ever possible
69     // result: healthy longevity.
70     modifier antiEarlyWhale(uint256 _amountOfEthereum){
71         address _customerAddress = msg.sender;
72         
73         // are we still in the vulnerable phase?
74         // if so, enact anti early whale protocol 
75         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
76             require(
77                 // is the customer in the ambassador list?
78                 ambassadors_[_customerAddress] == true &&
79                 
80                 // does the customer purchase exceed the max ambassador quota?
81                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
82                 
83             );
84             
85             // updated the accumulated quota    
86             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
87         
88             // execute
89             _;
90         } else {
91             // in case the ether count drops low, the ambassador phase won't reinitiate
92             onlyAmbassadors = false;
93             _;    
94         }
95         
96     }
97     
98     
99     /*==============================
100     =            EVENTS            =
101     ==============================*/
102     event onTokenPurchase(
103         address indexed customerAddress,
104         uint256 incomingEthereum,
105         uint256 tokensMinted,
106         address indexed referredBy
107     );
108     
109     event onTokenSell(
110         address indexed customerAddress,
111         uint256 tokensBurned,
112         uint256 ethereumEarned
113     );
114     
115     event onReinvestment(
116         address indexed customerAddress,
117         uint256 ethereumReinvested,
118         uint256 tokensMinted
119     );
120     
121     event onWithdraw(
122         address indexed customerAddress,
123         uint256 ethereumWithdrawn
124     );
125     
126     // ERC20
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132     
133     
134     /*=====================================
135     =            CONFIGURABLES            =
136     =====================================*/
137     string public name = "POMoooon";
138     string public symbol = "MOON";
139     uint8 constant public decimals = 18;
140     uint8 constant internal dividendFee_ = 5; // Look, strong Math
141     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
142     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
143     uint256 constant internal magnitude = 2**64;
144     
145     // proof of stake (defaults at 100 tokens)
146     uint256 public stakingRequirement = 100e18;
147     
148     // ambassador program
149     mapping(address => bool) internal ambassadors_;
150     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
151     uint256 constant internal ambassadorQuota_ = 2000 ether;
152     
153     
154     
155    /*================================
156     =            DATASETS            =
157     ================================*/
158     // amount of shares for each address (scaled number)
159     mapping(address => uint256) internal tokenBalanceLedger_;
160     mapping(address => uint256) internal referralBalance_;
161     mapping(address => int256) internal payoutsTo_;
162     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
163     uint256 internal tokenSupply_ = 0;
164     uint256 internal profitPerShare_;
165     
166     // administrator list (see above on what they can do)
167     mapping(address => bool) public administrators;
168     
169     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
170     bool public onlyAmbassadors = true;
171     
172 
173 
174     /*=======================================
175     =            PUBLIC FUNCTIONS            =
176     =======================================*/
177     /*
178     * -- APPLICATION ENTRY POINTS --  
179     */
180     function POMoooon()
181         public payable
182     {
183         // add administrators here
184 
185         administrators[msg.sender] = true;
186         ambassadors_[msg.sender] = true;
187         ambassadors_[0x48e672219610F4aD66261eF19C9BfBD5BfF0b4Ab] = true;
188         ambassadors_[0xd17e2bFE196470A9fefb567e8f5992214EB42F24] = true;
189         
190 
191 
192         purchaseTokens(msg.value, address(0x0));
193         
194 
195     }
196     
197      
198     /**
199      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
200      */
201     function buy(address _referredBy)
202         public
203         payable
204         returns(uint256)
205     {
206         purchaseTokens(msg.value, _referredBy);
207     }
208     
209     /**
210      * Fallback function to handle ethereum that was send straight to the contract
211      * Unfortunately we cannot use a referral address this way.
212      */
213     function()
214         payable
215         public
216     {
217         purchaseTokens(msg.value, 0x0);
218     }
219     
220     /**
221      * Converts all of caller's dividends to tokens.
222     */
223     function reinvest()
224         onlyStronghands()
225         public
226     {
227         // fetch dividends
228         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
229         
230         // pay out the dividends virtually
231         address _customerAddress = msg.sender;
232         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
233         
234         // retrieve ref. bonus
235         _dividends += referralBalance_[_customerAddress];
236         referralBalance_[_customerAddress] = 0;
237         
238         // dispatch a buy order with the virtualized "withdrawn dividends"
239         uint256 _tokens = _purchaseTokens(_dividends, 0x0);
240         
241         // fire event
242         onReinvestment(_customerAddress, _dividends, _tokens);
243     }
244     
245     /**
246      * Alias of sell() and withdraw().
247      */
248     function exit()
249         public
250         sellLimit()
251     {
252         // get token count for caller & sell them all
253         address _customerAddress = msg.sender;
254         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
255         if(_tokens > 0) sell(_tokens);
256         
257         // lambo delivery service
258         withdraw();
259     }
260 
261     /**
262      * Withdraws all of the callers earnings.
263      */
264     function withdraw()
265         onlyStronghands()
266         sellLimit()
267         public
268     {
269         // setup data
270         address _customerAddress = msg.sender;
271         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
272         
273         // update dividend tracker
274         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
275         
276         // add ref. bonus
277         _dividends += referralBalance_[_customerAddress];
278         referralBalance_[_customerAddress] = 0;
279         
280         // lambo delivery service
281         _customerAddress.transfer(_dividends);
282         
283         // fire event
284         onWithdraw(_customerAddress, _dividends);
285     }
286     
287     /**
288      * Liquifies tokens to ethereum.
289      */
290     function sell(uint256 _amountOfTokens)
291         onlyBagholders()
292         sellLimit()
293         public
294     {
295         // setup data
296         address _customerAddress = msg.sender;
297         // russian hackers BTFO
298         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
299         uint256 _tokens = _amountOfTokens;
300         uint256 _ethereum = tokensToEthereum_(_tokens);
301         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
302         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303         
304         // burn the sold tokens
305         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
307         
308         // update dividends tracker
309         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
310         payoutsTo_[_customerAddress] -= _updatedPayouts;       
311         
312         // dividing by zero is a bad idea
313         if (tokenSupply_ > 0) {
314             // update the amount of dividends per token
315             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
316         }
317         
318         // fire event
319         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
320     }
321     
322     
323     /**
324      * Transfer tokens from the caller to a new holder.
325      * Remember, there's a 10% fee here as well.
326      */
327     function transfer(address _toAddress, uint256 _amountOfTokens)
328         onlyBagholders()
329         sellLimit()
330         public
331         returns(bool)
332     {
333         // setup
334         address _customerAddress = msg.sender;
335         
336         // make sure we have the requested tokens
337         // also disables transfers until ambassador phase is over
338         // ( we dont want whale premines )
339         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
340         
341         // withdraw all outstanding dividends first
342         if(myDividends(true) > 0) withdraw();
343         
344   
345 
346 
347         // exchange tokens
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
349         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
350         
351         // update dividend trackers
352         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
353         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
354 
355         
356         // fire event
357         Transfer(_customerAddress, _toAddress, _amountOfTokens);
358         
359         // ERC20
360         return true;
361        
362     }
363     
364     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
365     /**
366      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
367      */
368     function disableInitialStage()
369         onlyAdministrator()
370         public
371     {
372         onlyAmbassadors = false;
373     }
374     
375     /**
376      * In case one of us dies, we need to replace ourselves.
377      */
378     function setAdministrator(address _identifier, bool _status)
379         onlyAdministrator()
380         public
381     {
382         administrators[_identifier] = _status;
383     }
384     
385     /**
386      * Precautionary measures in case we need to adjust the masternode rate.
387      */
388     function setStakingRequirement(uint256 _amountOfTokens)
389         onlyAdministrator()
390         public
391     {
392         stakingRequirement = _amountOfTokens;
393     }
394     
395     /**
396      * If we want to rebrand, we can.
397      */
398     function setName(string _name)
399         onlyAdministrator()
400         public
401     {
402         name = _name;
403     }
404     
405     /**
406      * If we want to rebrand, we can.
407      */
408     function setSymbol(string _symbol)
409         onlyAdministrator()
410         public
411     {
412         symbol = _symbol;
413     }
414 
415     
416     /*----------  HELPERS AND CALCULATORS  ----------*/
417     /**
418      * Method to view the current Ethereum stored in the contract
419      * Example: totalEthereumBalance()
420      */
421     function totalEthereumBalance()
422         public
423         view
424         returns(uint)
425     {
426         return this.balance;
427     }
428     
429     /**
430      * Retrieve the total token supply.
431      */
432     function totalSupply()
433         public
434         view
435         returns(uint256)
436     {
437         return tokenSupply_;
438     }
439     
440     /**
441      * Retrieve the tokens owned by the caller.
442      */
443     function myTokens()
444         public
445         view
446         returns(uint256)
447     {
448         address _customerAddress = msg.sender;
449         return balanceOf(_customerAddress);
450     }
451     
452     /**
453      * Retrieve the dividends owned by the caller.
454      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
455      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
456      * But in the internal calculations, we want them separate. 
457      */ 
458     function myDividends(bool _includeReferralBonus) 
459         public 
460         view 
461         returns(uint256)
462     {
463         address _customerAddress = msg.sender;
464         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
465     }
466     
467     /**
468      * Retrieve the token balance of any single address.
469      */
470     function balanceOf(address _customerAddress)
471         view
472         public
473         returns(uint256)
474     {
475         return tokenBalanceLedger_[_customerAddress];
476     }
477     
478     /**
479      * Retrieve the dividend balance of any single address.
480      */
481     function dividendsOf(address _customerAddress)
482         view
483         public
484         returns(uint256)
485     {
486         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
487     }
488     
489     /**
490      * Return the buy price of 1 individual token.
491      */
492     function sellPrice() 
493         public 
494         view 
495         returns(uint256)
496     {
497         // our calculation relies on the token supply, so we need supply. Doh.
498         if(tokenSupply_ == 0){
499             return tokenPriceInitial_ - tokenPriceIncremental_;
500         } else {
501             uint256 _ethereum = tokensToEthereum_(1e18);
502             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
503             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
504             return _taxedEthereum;
505         }
506     }
507     
508     /**
509      * Return the sell price of 1 individual token.
510      */
511     function buyPrice() 
512         public 
513         view 
514         returns(uint256)
515     {
516         // our calculation relies on the token supply, so we need supply. Doh.
517         if(tokenSupply_ == 0){
518             return tokenPriceInitial_ + tokenPriceIncremental_;
519         } else {
520             uint256 _ethereum = tokensToEthereum_(1e18);
521             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
522             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
523             return _taxedEthereum;
524         }
525     }
526     
527     /**
528      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
529      */
530     function calculateTokensReceived(uint256 _ethereumToSpend) 
531         public 
532         view 
533         returns(uint256)
534     {
535         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
536         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
537         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
538         
539         return _amountOfTokens;
540     }
541     
542     /**
543      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
544      */
545     function calculateEthereumReceived(uint256 _tokensToSell) 
546         public 
547         view 
548         returns(uint256)
549     {
550         require(_tokensToSell <= tokenSupply_);
551         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
552         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
553         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
554         return _taxedEthereum;
555     }
556     
557     
558     /*==========================================
559     =            INTERNAL FUNCTIONS            =
560     ==========================================*/
561     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
562         antiEarlyWhale(_incomingEthereum)
563         buyLimit()
564         internal
565         returns(uint256)
566     {
567         return _purchaseTokens(_incomingEthereum, _referredBy);
568     }
569     
570     function _purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256){
571         
572         // data setup
573         address _customerAddress = msg.sender;
574         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
575         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
576         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
577         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
578         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
579         uint256 _fee = _dividends * magnitude;
580  
581         // no point in continuing execution if OP is a poorfag russian hacker
582         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
583         // (or hackers)
584         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
585         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
586         
587         // is the user referred by a masternode?
588         if(
589             // is this a referred purchase?
590             _referredBy != 0x0000000000000000000000000000000000000000 &&
591 
592             // no cheating!
593             _referredBy != _customerAddress &&
594             
595             // does the referrer have at least X whole tokens?
596             // i.e is the referrer a godly chad masternode
597             tokenBalanceLedger_[_referredBy] >= stakingRequirement
598         ){
599             // wealth redistribution
600             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
601         } else {
602             // no ref purchase
603             // add the referral bonus back to the global dividends cake
604             _dividends = SafeMath.add(_dividends, _referralBonus);
605             _fee = _dividends * magnitude;
606         }
607         
608         // we can't give people infinite ethereum
609         if(tokenSupply_ > 0){
610             
611             // add tokens to the pool
612             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
613  
614             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
615             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
616             
617             // calculate the amount of tokens the customer receives over his purchase 
618             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
619         
620         } else {
621             // add tokens to the pool
622             tokenSupply_ = _amountOfTokens;
623         }
624         
625         // update circulating supply & the ledger address for the customer
626         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
627         
628         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
629         //really i know you think you do but you don't
630         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
631         payoutsTo_[_customerAddress] += _updatedPayouts;
632         
633         // fire event
634         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
635         
636         return _amountOfTokens;
637     }
638 
639     /**
640      * Calculate Token price based on an amount of incoming ethereum
641      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
642      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
643      */
644     function ethereumToTokens_(uint256 _ethereum)
645         internal
646         view
647         returns(uint256)
648     {
649         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
650         uint256 _tokensReceived = 
651          (
652             (
653                 // underflow attempts BTFO
654                 SafeMath.sub(
655                     (sqrt
656                         (
657                             (_tokenPriceInitial**2)
658                             +
659                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
660                             +
661                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
662                             +
663                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
664                         )
665                     ), _tokenPriceInitial
666                 )
667             )/(tokenPriceIncremental_)
668         )-(tokenSupply_)
669         ;
670   
671         return _tokensReceived;
672     }
673     
674     /**
675      * Calculate token sell value.
676      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
677      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
678      */
679      function tokensToEthereum_(uint256 _tokens)
680         internal
681         view
682         returns(uint256)
683     {
684 
685         uint256 tokens_ = (_tokens + 1e18);
686         uint256 _tokenSupply = (tokenSupply_ + 1e18);
687         uint256 _etherReceived =
688         (
689             // underflow attempts BTFO
690             SafeMath.sub(
691                 (
692                     (
693                         (
694                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
695                         )-tokenPriceIncremental_
696                     )*(tokens_ - 1e18)
697                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
698             )
699         /1e18);
700         return _etherReceived;
701     }
702     
703     
704     //This is where all your gas goes, sorry
705     //Not sorry, you probably only paid 1 gwei
706     function sqrt(uint x) internal pure returns (uint y) {
707         uint z = (x + 1) / 2;
708         y = x;
709         while (z < y) {
710             y = z;
711             z = (x / z + z) / 2;
712         }
713     }
714 }
715 
716 /**
717  * @title SafeMath
718  * @dev Math operations with safety checks that throw on error
719  */
720 library SafeMath {
721 
722     /**
723     * @dev Multiplies two numbers, throws on overflow.
724     */
725     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
726         if (a == 0) {
727             return 0;
728         }
729         uint256 c = a * b;
730         assert(c / a == b);
731         return c;
732     }
733 
734     /**
735     * @dev Integer division of two numbers, truncating the quotient.
736     */
737     function div(uint256 a, uint256 b) internal pure returns (uint256) {
738         // assert(b > 0); // Solidity automatically throws when dividing by 0
739         uint256 c = a / b;
740         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
741         return c;
742     }
743 
744     /**
745     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
746     */
747     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
748         assert(b <= a);
749         return a - b;
750     }
751 
752     /**
753     * @dev Adds two numbers, throws on overflow.
754     */
755     function add(uint256 a, uint256 b) internal pure returns (uint256) {
756         uint256 c = a + b;
757         assert(c >= a);
758         return c;
759     }
760 }