1 pragma solidity ^0.4.23;
2 
3 /*
4 * ========================================*
5 *  ______      _____ _______        ____  *
6 * |  ____/\   |  __ \__   __|      |___ \ *
7 * | |__ /  \  | |__) | | |    __   ____) |*
8 * |  __/ /\ \ |  _  /  | |    \ \ / /__ < *
9 * | | / ____ \| | \ \  | |     \ V /___) |*
10 * |_|/_/    \_\_|  \_\ |_|      \_/|____/ *    
11 * ========================================*
12 * 
13 * Freedom Around Revolutionary Technology
14 *
15 * After the previous contract had problems, i would like to make things right.
16 * Contract was audited by P3D dev team.
17 * 
18 * https://www.number2.io/buyFART.html
19 * https://discord.gg/Cg5htYS
20 *
21 */
22 
23 contract FARTv3 {
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
50         require(administrators[keccak256(_customerAddress)]);
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
125     string public name = "FARTv3";
126     string public symbol = "FARTv3";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 10;
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     // proof of stake (defaults at 100 tokens)
134     uint256 public stakingRequirement = 5e18;
135     
136     // ambassador program
137     mapping(address => bool) internal ambassadors_;
138     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
139     uint256 constant internal ambassadorQuota_ = 1 ether;
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
155     mapping(bytes32 => bool) public administrators;
156     
157     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
158     bool public onlyAmbassadors = false;
159     
160 
161 
162     /*=======================================
163     =            PUBLIC FUNCTIONS            =
164     =======================================*/
165     /*
166     * -- APPLICATION ENTRY POINTS --  
167     */
168 
169     function FART()
170         public
171     {
172         // add administrators here
173         //fuck admin! Drive it like you stole it!
174         
175 
176         // add the ambassadors here. 
177         ambassadors_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //K
178         ambassadors_[0xfD7533DA3eBc49a608eaac6200A88a34fc479C77] = true; //M
179         ambassadors_[0x05fd5cebbd6273668bdf57fff52caae24be1ca4a] = true; //L
180         ambassadors_[0xec54170ca59ca80f0b5742b9b867511cbe4ccfa7] = true; //A
181         ambassadors_[0xe57b7c395767d7c852d3b290f506992e7ce3124a] = true; //D
182 
183     }
184     address _customerAdress = msg.sender; //Sender is customer
185      
186     /**
187      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
188      */
189     function buy(address _referredBy)
190         public
191         payable
192         returns(uint256)
193     {
194         purchaseTokens(msg.value, _referredBy);
195     }
196     
197     /**
198      * Fallback function to handle ethereum that was send straight to the contract
199      * Unfortunately we cannot use a referral address this way.
200      */
201     function()
202         payable
203         public
204     {
205         purchaseTokens(msg.value, 0x0);
206     }
207     
208     /**
209      * Converts all of caller's dividends to tokens.
210      */
211     function reinvest()
212         onlyStronghands()
213         public
214     {
215         // fetch dividends
216         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
217         
218         // pay out the dividends virtually
219         address _customerAddress = msg.sender;
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221         
222         // retrieve ref. bonus
223         _dividends += referralBalance_[_customerAddress];
224         referralBalance_[_customerAddress] = 0;
225         
226         // dispatch a buy order with the virtualized "withdrawn dividends"
227         uint256 _tokens = purchaseTokens(_dividends, 0x0);
228         
229         // fire event
230         onReinvestment(_customerAddress, _dividends, _tokens);
231     }
232     
233     /**
234      * Alias of sell() and withdraw().
235      */
236     function exit()
237         public
238     {
239         // get token count for caller & sell them all
240         address _customerAddress = msg.sender;
241         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
242         if(_tokens > 0) sell(_tokens);
243         
244         // lambo delivery service
245         withdraw();
246     }
247 
248     /**
249      * Withdraws all of the callers earnings.
250      */
251     function withdraw()
252         onlyStronghands()
253         public
254     {
255         // setup data
256         address _customerAddress = msg.sender;
257         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
258         
259         // update dividend tracker
260         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
261         
262         // add ref. bonus
263         _dividends += referralBalance_[_customerAddress];
264         referralBalance_[_customerAddress] = 0;
265         
266         
267          _customerAdress.transfer(_dividends);// lambo delivery service
268         
269         // fire event
270         onWithdraw(_customerAddress, _dividends);
271     }
272     
273     /**
274      * Liquifies tokens to ethereum.
275      */
276     function sell(uint256 _amountOfTokens)
277         onlyBagholders()
278         public
279     {
280         // setup data
281         address _customerAddress = msg.sender;
282         // russian hackers BTFO
283         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
284         uint256 _tokens = _amountOfTokens;
285         uint256 _ethereum = tokensToEthereum_(_tokens);
286         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
287         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
288         
289         // burn the sold tokens
290         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
291         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
292         
293         // update dividends tracker
294         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
295         payoutsTo_[_customerAddress] -= _updatedPayouts;       
296         
297         // dividing by zero is a bad idea
298         if (tokenSupply_ > 0) {
299             // update the amount of dividends per token
300             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
301         }
302         
303         // fire event
304         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
305     }
306     
307     
308     /**
309      * Transfer tokens from the caller to a new holder.
310      * Remember, there's a 10% fee here as well.
311      */
312     function transfer(address _toAddress, uint256 _amountOfTokens)
313         onlyBagholders()
314         public
315         returns(bool)
316     {
317         // setup
318         address _customerAddress = msg.sender;
319         
320         // make sure we have the requested tokens
321         // also disables transfers until ambassador phase is over
322         // ( we dont want whale premines )
323         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
324         
325         // withdraw all outstanding dividends first
326         if(myDividends(true) > 0) withdraw();
327         
328         // liquify 10% of the tokens that are transfered
329         // these are dispersed to shareholders
330         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
331         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
332         uint256 _dividends = tokensToEthereum_(_tokenFee);
333   
334         // burn the fee tokens
335         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
336 
337         // exchange tokens
338         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
339         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
340         
341         // update dividend trackers
342         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
343         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
344         
345         // disperse dividends among holders
346         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
347         
348         // fire event
349         Transfer(_customerAddress, _toAddress, _taxedTokens);
350         
351         // ERC20
352         return true;
353        
354     }
355     
356     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
357     /**
358      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
359      */
360     function disableInitialStage()
361         onlyAdministrator()
362         public
363     {
364         onlyAmbassadors = false;
365     }
366     
367     /**
368      * In case one of us dies, we need to replace ourselves.
369      */
370     function setAdministrator(bytes32 _identifier, bool _status)
371         onlyAdministrator()
372         public
373     {
374         administrators[_identifier] = _status;
375     }
376     
377     /**
378      * Precautionary measures in case we need to adjust the masternode rate.
379      */
380     function setStakingRequirement(uint256 _amountOfTokens)
381         onlyAdministrator()
382         public
383     {
384         stakingRequirement = _amountOfTokens;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setName(string _name)
391         onlyAdministrator()
392         public
393     {
394         name = _name;
395     }
396     
397     /**
398      * If we want to rebrand, we can.
399      */
400     function setSymbol(string _symbol)
401         onlyAdministrator()
402         public
403     {
404         symbol = _symbol;
405     }
406 
407     
408     /*----------  HELPERS AND CALCULATORS  ----------*/
409     /**
410      * Method to view the current Ethereum stored in the contract
411      * Example: totalEthereumBalance()
412      */
413     function totalEthereumBalance()
414         public
415         view
416         returns(uint)
417     {
418         return address (this).balance;
419     }
420     
421     /**
422      * Retrieve the total token supply.
423      */
424     function totalSupply()
425         public
426         view
427         returns(uint256)
428     {
429         return tokenSupply_;
430     }
431     
432     /**
433      * Retrieve the tokens owned by the caller.
434      */
435     function myTokens()
436         public
437         view
438         returns(uint256)
439     {
440         address _customerAddress = msg.sender;
441         return balanceOf(_customerAddress);
442     }
443     
444     /**
445      * Retrieve the dividends owned by the caller.
446      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
447      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
448      * But in the internal calculations, we want them separate. 
449      */ 
450     function myDividends(bool _includeReferralBonus) 
451         public 
452         view 
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
457     }
458     
459     /**
460      * Retrieve the token balance of any single address.
461      */
462     function balanceOf(address _customerAddress)
463         view
464         public
465         returns(uint256)
466     {
467         return tokenBalanceLedger_[_customerAddress];
468     }
469     
470     /**
471      * Retrieve the dividend balance of any single address.
472      */
473     function dividendsOf(address _customerAddress)
474         view
475         public
476         returns(uint256)
477     {
478         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
479     }
480     
481     /**
482      * Return the buy price of 1 individual token.
483      */
484     function sellPrice() 
485         public 
486         view 
487         returns(uint256)
488     {
489         // our calculation relies on the token supply, so we need supply. Doh.
490         if(tokenSupply_ == 0){
491             return tokenPriceInitial_ - tokenPriceIncremental_;
492         } else {
493             uint256 _ethereum = tokensToEthereum_(1e18);
494             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
495             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
496             return _taxedEthereum;
497         }
498     }
499     
500     /**
501      * Return the sell price of 1 individual token.
502      */
503     function buyPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ + tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
521      */
522     function calculateTokensReceived(uint256 _ethereumToSpend) 
523         public 
524         view 
525         returns(uint256)
526     {
527         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
528         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
529         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
530         
531         return _amountOfTokens;
532     }
533     
534     /**
535      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
536      */
537     function calculateEthereumReceived(uint256 _tokensToSell) 
538         public 
539         view 
540         returns(uint256)
541     {
542         require(_tokensToSell <= tokenSupply_);
543         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
544         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
545         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
546         return _taxedEthereum;
547     }
548     
549     
550     /*==========================================
551     =            INTERNAL FUNCTIONS            =
552     ==========================================*/
553     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
554         antiEarlyWhale(_incomingEthereum)
555         internal
556         returns(uint256)
557     {
558         // data setup
559         address _customerAddress = msg.sender;
560         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
561         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
562         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
563         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
564         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
565         uint256 _fee = _dividends * magnitude;
566  
567         // no point in continuing execution if OP is a poorfag russian hacker
568         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
569         // (or hackers)
570         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
571         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
572         
573         // is the user referred by a masternode?
574         if(
575             // is this a referred purchase?
576             _referredBy != 0x0000000000000000000000000000000000000000 &&
577 
578             // no cheating!
579             _referredBy != _customerAddress &&
580             
581             // does the referrer have at least X whole tokens?
582             // i.e is the referrer a godly chad masternode
583             tokenBalanceLedger_[_referredBy] >= stakingRequirement
584         ){
585             // wealth redistribution
586             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
587         } else {
588             // no ref purchase
589             // add the referral bonus back to the global dividends cake
590             _dividends = SafeMath.add(_dividends, _referralBonus);
591             _fee = _dividends * magnitude;
592         }
593         
594         // we can't give people infinite ethereum
595         if(tokenSupply_ > 0){
596             
597             // add tokens to the pool
598             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
599  
600             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
601             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
602             
603             // calculate the amount of tokens the customer receives over his purchase 
604             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
605         
606         } else {
607             // add tokens to the pool
608             tokenSupply_ = _amountOfTokens;
609         }
610         
611         // update circulating supply & the ledger address for the customer
612         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
613         
614         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
615         //really i know you think you do but you don't
616         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
617         payoutsTo_[_customerAddress] += _updatedPayouts;
618         
619         // fire event
620         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
621         
622         return _amountOfTokens;
623     }
624 
625     /**
626      * Calculate Token price based on an amount of incoming ethereum
627      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
628      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
629      */
630     function ethereumToTokens_(uint256 _ethereum)
631         internal
632         view
633         returns(uint256)
634     {
635         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
636         uint256 _tokensReceived = 
637          (
638             (
639                 // underflow attempts BTFO
640                 SafeMath.sub(
641                     (sqrt
642                         (
643                             (_tokenPriceInitial**2)
644                             +
645                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
646                             +
647                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
648                             +
649                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
650                         )
651                     ), _tokenPriceInitial
652                 )
653             )/(tokenPriceIncremental_)
654         )-(tokenSupply_)
655         ;
656   
657         return _tokensReceived;
658     }
659     
660     /**
661      * Calculate token sell value.
662      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
663      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
664      */
665      function tokensToEthereum_(uint256 _tokens)
666         internal
667         view
668         returns(uint256)
669     {
670 
671         uint256 tokens_ = (_tokens + 1e18);
672         uint256 _tokenSupply = (tokenSupply_ + 1e18);
673         uint256 _etherReceived =
674         (
675             // underflow attempts BTFO
676             SafeMath.sub(
677                 (
678                     (
679                         (
680                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
681                         )-tokenPriceIncremental_
682                     )*(tokens_ - 1e18)
683                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
684             )
685         /1e18);
686         return _etherReceived;
687     }
688     
689     
690     //This is where all your gas goes, sorry
691     //Not sorry, you probably only paid 1 gwei
692     function sqrt(uint x) internal pure returns (uint y) {
693         uint z = (x + 1) / 2;
694         y = x;
695         while (z < y) {
696             y = z;
697             z = (x / z + z) / 2;
698         }
699     }
700 }
701 
702 /**
703  * @title SafeMath
704  * @dev Math operations with safety checks that throw on error
705  */
706 library SafeMath {
707 
708     /**
709     * @dev Multiplies two numbers, throws on overflow.
710     */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         if (a == 0) {
713             return 0;
714         }
715         uint256 c = a * b;
716         assert(c / a == b);
717         return c;
718     }
719 
720     /**
721     * @dev Integer division of two numbers, truncating the quotient.
722     */
723     function div(uint256 a, uint256 b) internal pure returns (uint256) {
724         // assert(b > 0); // Solidity automatically throws when dividing by 0
725         uint256 c = a / b;
726         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
727         return c;
728     }
729 
730     /**
731     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
732     */
733     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
734         assert(b <= a);
735         return a - b;
736     }
737 
738     /**
739     * @dev Adds two numbers, throws on overflow.
740     */
741     function add(uint256 a, uint256 b) internal pure returns (uint256) {
742         uint256 c = a + b;
743         assert(c >= a);
744         return c;
745     }
746 }