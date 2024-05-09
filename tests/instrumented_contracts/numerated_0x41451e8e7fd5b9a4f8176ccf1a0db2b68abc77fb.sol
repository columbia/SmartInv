1 pragma solidity ^0.4.21;
2 
3 /*
4 * ====================================*
5 *  _____   ____    ____   _______     *
6 * |  ___| / __ \  |    \ |__   __|    * 
7 * | |___ | |__| | |    /    | |       *
8 * |  ___||  __  | | |\ \    | |       *
9 * | |    | |  | | | | \ \   | |       *
10 * |_|    |_|  |_| |_|  \_\  |_|       *
11 * ====================================*
12 * 
13 * Freedom Around Revolutionary Technology
14 *
15 * Changing the humanitarian world while having fun!
16 *
17 * This source code is THE contract the crypto-community 
18 * deserves. It was cloned from POOH and perfected by the genius mind of 
19 * Kenneth Pacheco using ideas from the proof crypto-community.
20 *
21 *  
22 *    Auditors:
23 *   
24 *   Etherguy -------- 5/4/18
25 *   Sensei Kevlar --- 5/4/18
26 *   Sixophrenia ----- 5/4/18
27 *   ccashwell ------- 5/4/18
28 *   
29 *   
30 *   
31 * 
32 */
33 
34 contract FART {
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38     // only people with tokens
39     modifier onlyTokenHolders() {
40         require(myTokens() > 0);
41         _;
42     }
43     
44     // only non-founders
45     modifier onlyNonFounders() {
46         require(!foundingFARTers_[msg.sender]);
47         _;
48     }
49     
50     // only people with profits
51     modifier onlyStronghands() {
52         require(myDividends(true) > 0);
53         _;
54     }
55     
56     // ensures that the contract is only open to the public when the founders are ready for it to be
57     modifier areWeLive(uint256 _amountOfEthereum){
58         address _customerAddress = msg.sender;
59         
60         // are we open to the public?
61         if( onlyFounders && ((totalEthereumBalance() - _amountOfEthereum) <= preLiveTeamFoundersMaxPurchase_ )){
62             require(
63                 // is the customer in the ambassador list?
64                 foundingFARTers_[_customerAddress] == true &&
65                 
66                 // does the customer purchase exceed the max quota needed to send contract live?
67                 (contractQuotaToGoLive_[_customerAddress] + _amountOfEthereum) <= preLiveIndividualFoundersMaxPurchase_
68                 
69             );
70             
71             // update the accumulated quota    
72             contractQuotaToGoLive_[_customerAddress] = SafeMath.add(contractQuotaToGoLive_[_customerAddress], _amountOfEthereum);
73         
74             // execute
75             _;
76         } else {
77             // in case the ether count drops low, the ambassador phase won't reinitiate
78             onlyFounders = false;
79             _;    
80         }
81         
82     }
83     
84     
85     /*==============================
86     =            EVENTS            =
87     ==============================*/
88     event onTokenPurchase(
89         address indexed customerAddress,
90         uint256 incomingEthereum,
91         uint256 tokensMinted,
92         address indexed referredBy
93     );
94     
95     event onTokenSell(
96         address indexed customerAddress,
97         uint256 tokensBurned,
98         uint256 ethereumEarned
99     );
100     
101     event onReinvestment(
102         address indexed customerAddress,
103         uint256 ethereumReinvested,
104         uint256 tokensMinted
105     );
106     
107     event onWithdraw(
108         address indexed customerAddress,
109         uint256 ethereumWithdrawn
110     );
111     
112     event Transfer(
113         address indexed from,
114         address indexed to,
115         uint256 tokens
116     );
117     
118     
119     /*=====================================
120     =            CONFIGURABLES            =
121     =====================================*/
122     string public name = "FART";
123     string public symbol = "FART";
124     uint8 constant public decimals = 18;
125     uint8 constant internal dividendFee_ = 7; // roughly 15% = (5% to charity + 10% divs)
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128     uint256 constant internal magnitude = 2**64;
129     
130     // Referral link requirement (20 tokens instead of 5 bacause this game is mainly for charity)
131     uint256 public referralLinkMinimum = 20e18; 
132     
133     // founders program (Founders initially put in 1 ETH and can add more later when contract is live)
134     mapping(address => bool) internal foundingFARTers_;
135     uint256 constant internal preLiveIndividualFoundersMaxPurchase_ = 2 ether; // 2 ETH max for me so I can make sure to break the 1 ETH threshold.
136     uint256 constant internal preLiveTeamFoundersMaxPurchase_ = 1 ether; // 1 ETH threshold to go live
137     
138     
139     
140    /*================================
141     =            DATASETS            =
142     ================================*/
143     // amount of shares for each address (scaled number)
144     mapping(address => uint256) internal tokenBalanceLedger_;
145     mapping(address => uint256) internal referralBalance_;
146     mapping(address => int256) internal payoutsTo_;
147     mapping(address => uint256) internal contractQuotaToGoLive_;
148     uint256 internal tokenSupply_ = 0;
149     uint256 internal profitPerShare_;
150     
151     // administrator list (see above on what they can do)
152     mapping(bytes32 => bool) public administrators;
153     
154     // when this is set to true, only founders can purchase tokens (this prevents an errored contract from being live to the public)
155     bool public onlyFounders = true;
156     
157 
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --  
164     */
165     function FART()
166         public
167     {
168         
169         //No admin! True trust-less contracts don't have the ability to be alteredd! ('This is HUUUUUUUUUUGE!' - Donald Trump)
170         
171         
172         // add the founders here. Founders cannot sell or transfer FART tokens, 
173         // thereby making the token increase in value over time
174         foundingFARTers_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //Kenneth Pacheco    - https://www.linkedin.com/in/kennethpacheco/
175     }
176     
177      
178     /**
179      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
180      */
181     function buy(address _referredBy, address _charity)
182         public
183         payable
184         returns(uint256)
185     {
186         purchaseTokens(msg.value, _referredBy, _charity);
187     }
188     
189     /**
190      * Fallback function to handle ethereum that was sent straight to the contract
191      */
192     function()
193         payable
194         public
195     {
196         purchaseTokens(msg.value, 0x0, 0x0);
197     }
198     
199     /**
200      * Converts all of caller's dividends to tokens.
201      */
202     function reinvest()
203         onlyStronghands()//  <------Hey! We know this term!
204         public
205     {
206         // fetch dividends
207         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
208         
209         // pay out the dividends virtually
210         address _customerAddress = msg.sender;
211         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
212         
213         // retrieve ref. bonus
214         _dividends += referralBalance_[_customerAddress];
215         referralBalance_[_customerAddress] = 0;
216         
217         // dispatch a buy order with the virtualized "withdrawn dividends"
218         uint256 _tokens = purchaseTokens(_dividends, 0x0, 0x0);
219         
220         // fire event
221         emit onReinvestment(_customerAddress, _dividends, _tokens);
222     }
223     
224     /**
225      * Alias of sell() and withdraw().
226      */
227     function eject()
228         public
229     {
230         // get token count for caller & sell them all
231         address _customerAddress = msg.sender;
232         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
233         if(_tokens > 0) sell(_tokens, 0x0);
234         
235         // get out now
236         withdraw();
237     }
238 
239     /**
240      * Withdraws all of the callers earnings.
241      */
242     function withdraw()
243         onlyStronghands()
244         public
245     {
246         // setup data
247         address _customerAddress = msg.sender;
248         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
249         
250         // update dividend tracker
251         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
252         
253         // add ref. bonus
254         _dividends += referralBalance_[_customerAddress];
255         referralBalance_[_customerAddress] = 0;
256         
257         // lambo delivery service
258         _customerAddress.transfer(_dividends);
259         
260         // fire event
261         emit onWithdraw(_customerAddress, _dividends);
262     }
263     
264  
265     
266     /**
267      * Liquifies tokens to ethereum.
268      */
269     function sell(uint256 _amountOfTokens, address _charity)
270         onlyTokenHolders() //Can't sell what you don't have
271         onlyNonFounders() //Founders can't sell tokens
272         public {
273             // setup data
274             address _customerAddress = msg.sender;
275             require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
276             uint256 _tokens = _amountOfTokens;
277             uint256 _ethereum = tokensToEthereum_(_tokens);
278             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
279             uint256 _charityDividends = 0;
280             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
281             
282             if(_charity != 0x0000000000000000000000000000000000000000 && _charity != _customerAddress)//if not, it's an eject-call with no charity address
283             {     _charityDividends = SafeMath.div(_dividends, 3); // 1/3 of divs go to charity (5%)
284                  _dividends = SafeMath.sub(_dividends, _charityDividends); // 2/3 of divs go to everyone (10%)
285             }
286            
287             // burn the sold tokens
288             tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
289             tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
290             
291             // update dividends tracker
292             int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
293             payoutsTo_[_customerAddress] -= _updatedPayouts;       
294             
295             // dividing by zero is a bad idea
296             if (tokenSupply_ > 0) {
297                 // update the amount of dividends per token
298                 profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
299             }
300             
301             // fire event
302             emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
303             if(_charityDividends > 0) {
304                 //fire event to send to charity
305                 _charity.transfer(_charityDividends);
306             }
307         }
308     
309     
310     /**
311      * Transfer tokens from the caller to a new holder.
312      * No fee to transfer because I hate doing math.
313      */
314     function transfer(address _toAddress, uint256 _amountOfTokens)
315         onlyTokenHolders() // Can't tranfer what you don't have
316         onlyNonFounders() // Founders cannot transfer their tokens to be able to sell them
317         public
318         returns(bool) {
319         
320             // setup
321             address _customerAddress = msg.sender;
322             
323             // make sure we have the requested tokens
324             // also disables transfers until ambassador phase is over
325             // ( we dont want whale premines )
326             require(!onlyFounders && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
327             
328             // withdraw all outstanding dividends first
329             if(myDividends(true) > 0) withdraw();
330     
331             // exchange tokens
332             tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
333             tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
334             
335             // fire event
336             emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
337             
338             // ERC20
339             return true;
340            
341         }
342     
343     /*----------  HELPERS AND CALCULATORS  ----------*/
344     /**
345      * Method to view the current Ethereum stored in the contract
346      * Example: totalEthereumBalance()
347      */
348     function totalEthereumBalance()
349         public
350         view
351         returns(uint) {
352         return address (this).balance;
353     }
354     
355     /**
356      * Retrieve the total token supply.
357      */
358     function totalSupply()
359         public
360         view
361         returns(uint256) {
362         return tokenSupply_;
363     }
364     
365     /**
366      * Retrieve the tokens owned by the caller.
367      */
368     function myTokens()
369         public
370         view
371         returns(uint256) {
372         address _customerAddress = msg.sender;
373         return balanceOf(_customerAddress);
374     }
375     
376     /**
377      * Retrieve the dividends owned by the caller.
378      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
379      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
380      * But in the internal calculations, we want them separate. 
381      */ 
382     function myDividends(bool _includeReferralBonus) 
383         public 
384         view 
385         returns(uint256) {
386         address _customerAddress = msg.sender;
387         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
388     }
389     
390     /**
391      * Retrieve the token balance of any single address.
392      */
393     function balanceOf(address _customerAddress)
394         view
395         public
396         returns(uint256) {
397         return tokenBalanceLedger_[_customerAddress];
398     }
399     
400     /**
401      * Retrieve the dividend balance of any single address.
402      */
403     function dividendsOf(address _customerAddress)
404         view
405         public
406         returns(uint256) {
407         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
408     }
409     
410     /**
411      * Return the buy price of 1 individual token.
412      */
413     function sellPrice() 
414         public 
415         view 
416         returns(uint256) {
417         // our calculation relies on the token supply, so we need supply. Doh.
418         if(tokenSupply_ == 0){
419             return tokenPriceInitial_ - tokenPriceIncremental_;
420         } else {
421             uint256 _ethereum = tokensToEthereum_(1e18);
422             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
423             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
424             return _taxedEthereum;
425         }
426     }
427     
428     /**
429      * Return the sell price of 1 individual token.
430      */
431     function buyPrice() 
432         public 
433         view 
434         returns(uint256) {
435         // our calculation relies on the token supply, so we need supply. Doh.
436         if(tokenSupply_ == 0){
437             return tokenPriceInitial_ + tokenPriceIncremental_;
438         } else {
439             uint256 _ethereum = tokensToEthereum_(1e18);
440             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
441             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
442             return _taxedEthereum;
443         }
444     }
445     
446     /**
447      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
448      */
449     function calculateTokensReceived(uint256 _ethereumToSpend) 
450         public 
451         view 
452         returns(uint256) {
453         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
454         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
455         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
456         
457         return _amountOfTokens;
458     }
459     
460     /**
461      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
462      */
463     function calculateEthereumReceived(uint256 _tokensToSell) 
464         public 
465         view 
466         returns(uint256) {
467         require(_tokensToSell <= tokenSupply_);
468         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
469         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
470         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
471         return _taxedEthereum;
472     }
473     
474     
475     /*==========================================
476     =            INTERNAL FUNCTIONS            =
477     ==========================================*/
478      function purchaseTokens(uint256 _incomingEthereum, address _referredBy, address _charity)
479         areWeLive(_incomingEthereum)
480         internal
481         returns(uint256) {
482         // data setup
483        
484         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
485         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
486         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus), _referralBonus);  //subrtacting referral bonus and charity divs
487         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
488         uint256 _fee = _dividends * magnitude;
489         bool charity = false;
490  
491         // no point in continuing execution if OP is a poorfag russian hacker
492         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
493         // (or hackers)
494         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
495         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
496         
497         // is the user referred by a masternode?
498         if(
499             // is this a referred purchase?
500             _referredBy != 0x0000000000000000000000000000000000000000 &&
501 
502             // no cheating!
503             _referredBy != msg.sender &&
504             
505             // does the referrer have at least X whole tokens?
506             // i.e is the referrer a godly chad masternode
507             tokenBalanceLedger_[_referredBy] >= referralLinkMinimum
508         ){
509             // wealth redistribution
510             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
511         } else {
512             // no ref purchase
513             // add the referral bonus back to the global dividends cake
514             _dividends = SafeMath.add(_dividends, SafeMath.div(_undividedDividends, 3));
515             _fee = _dividends * magnitude;
516         }
517         
518         //Let's check for foul play with the charity address
519         if(
520             // is this a referred purchase?
521             _charity != 0x0000000000000000000000000000000000000000 &&
522 
523             // no cheating!
524             _charity != msg.sender 
525         ){
526             // charity redistribution
527             charity = true;
528           
529             
530             
531         } else {
532             // no ref purchase
533             // add the referral bonus back to the global dividends
534             _dividends = SafeMath.add(_dividends, _referralBonus);
535             _fee = _dividends * magnitude;
536         }
537         
538         // we can't give people infinite ethereum
539         if(tokenSupply_ > 0){
540             
541             // add tokens to the pool
542             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
543  
544             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
545             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
546             
547             // calculate the amount of tokens the customer receives over his purchase 
548             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
549         
550         } else {
551             // add tokens to the pool
552             tokenSupply_ = _amountOfTokens;
553         }
554         
555         // update circulating supply & the ledger address for the customer
556         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
557         
558         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
559         //really i know you think you do but you don't
560         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
561         payoutsTo_[msg.sender] += _updatedPayouts;
562         
563         
564         // fire event
565         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
566         if(charity) {
567          // fire event to send charity proceeds
568         _charity.transfer(_referralBonus);
569         }
570         
571         return _amountOfTokens;
572     }
573     
574 
575     /**
576      * Calculate Token price based on an amount of incoming ethereum
577      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
578      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
579      */
580     function ethereumToTokens_(uint256 _ethereum)
581         internal
582         view
583         returns(uint256) {
584         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
585         uint256 _tokensReceived = 
586          (
587             (
588                 // underflow attempts BTFO
589                 SafeMath.sub(
590                     (sqrt
591                         (
592                             (_tokenPriceInitial**2)
593                             +
594                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
595                             +
596                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
597                             +
598                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
599                         )
600                     ), _tokenPriceInitial
601                 )
602             )/(tokenPriceIncremental_)
603         )-(tokenSupply_)
604         ;
605   
606         return _tokensReceived;
607     }
608     
609     /**
610      * Calculate token sell value.
611      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
612      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
613      */
614      function tokensToEthereum_(uint256 _tokens)
615         internal
616         view
617         returns(uint256) {
618 
619         uint256 tokens_ = (_tokens + 1e18);
620         uint256 _tokenSupply = (tokenSupply_ + 1e18);
621         uint256 _etherReceived =
622         (
623             // underflow attempts BTFO
624             SafeMath.sub(
625                 (
626                     (
627                         (
628                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
629                         )-tokenPriceIncremental_
630                     )*(tokens_ - 1e18)
631                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
632             )
633         /1e18);
634         return _etherReceived;
635     }
636     
637     
638     //This is where all your gas goes, sorry
639     //Not sorry, you probably only paid 1 gwei
640     function sqrt(uint x) internal pure returns (uint y) {
641         uint z = (x + 1) / 2;
642         y = x;
643         while (z < y) {
644             y = z;
645             z = (x / z + z) / 2;
646         }
647     }
648 }
649 
650 /**
651  * @title SafeMath
652  * @dev Math operations with safety checks that throw on error
653  */
654 library SafeMath {
655 
656     /**
657     * @dev Multiplies two numbers, throws on overflow.
658     */
659     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
660         if (a == 0) {
661             return 0;
662         }
663         uint256 c = a * b;
664         assert(c / a == b);
665         return c;
666     }
667 
668     /**
669     * @dev Integer division of two numbers, truncating the quotient.
670     */
671     function div(uint256 a, uint256 b) internal pure returns (uint256) {
672         // assert(b > 0); // Solidity automatically throws when dividing by 0
673         uint256 c = a / b;
674         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
675         return c;
676     }
677 
678     /**
679     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
680     */
681     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
682         assert(b <= a);
683         return a - b;
684     }
685 
686     /**
687     * @dev Adds two numbers, throws on overflow.
688     */
689     function add(uint256 a, uint256 b) internal pure returns (uint256) {
690         uint256 c = a + b;
691         assert(c >= a);
692         return c;
693         
694         // If you have read all the way to here, thank you.  You are one of the good players that does their OWN resarch! Way to go!
695     }
696 }