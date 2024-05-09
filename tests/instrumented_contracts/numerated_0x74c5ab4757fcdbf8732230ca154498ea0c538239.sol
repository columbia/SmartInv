1 pragma solidity ^0.4.20;
2 /*
3 /*
4 * Welcome to The Illuminati (ILMT) / https://theilluminati.io ..
5 * =======================================================================================*
6 *                                                                                        *
7 *                                       `-.        .-'.                                  * 
8 *                                    `-.    -./\.-    .-'                                *
9 *                                        -.  /_|\  .-                                    *
10 *                                    `-.   `/____\'   .-'.                               *
11 *                                 `-.    -./.-""-.\.-      '                             *
12 *                                    `-.  /< (()) >\  .-'                                *
13 *                                  -   .`/__`-..-'__\'   .-                              *
14 *                                ,...`-./___|____|___\.-'.,.                             *
15 *                                   ,-'   ,` . . ',   `-,                                *
16 *                                ,-'   ________________  `-,                             *
17 *                                   ,'/____|_____|_____\                                 *
18 *                                  / /__|_____|_____|___\                                *
19 *                                 / /|_____|_____|_____|_\                               *
20 *                                ' /____|_____|_____|_____\                              *
21 *                              .' /__|_____|_____|_____|___\                             *
22 *                             ,' /|_____|_____|_____|_____|_\                            *
23 *,,---''--...___...--'''--.. /../____|_____|_____|_____|_____\ ..--```--...___...--``---,,*
24 *                           '../__|_____|_____|_____|_____|___\                          *
25 *      \    )              '.:/|_____|_____|_____|_____|_____|_\               (    /    *
26 *      )\  / )           ,':./____|_____|_____|_____|_____|_____\             ( \  /(    *
27 *     / / ( (           /:../__|_____|_____|_____|_____|_____|___\             ) ) \ \   *
28 *    | |   \ \         /.../|_____|_____|_____|_____|_____|_____|_\           / /   | |  *
29 * .-.\ \    \ \       '..:/____|_____|_____|_____|_____|_____|_____\         / /    / /.-.*
30 *(=  )\ `._.' |       \:./ _  _ ___  ____ ____ _    _ _ _ _ _  _ ___\        | `._.' /(  =)*
31 * \ (_)       )       \./             WE'RE WATCHING YOU             \       (       (_) /*
32 *  \    `----'         """"""""""""""""""""""""""""""""""""""""""""""""       `----'    /*
33 *   \   ____\__                                                              __/____   /*
34 *    \ (=\     \                                                            /     /-) /*
35 *     \_)_\     \                                                          /     /_(_/*
36 *          \     \                                                        /     /     *
37 *           )     )  _                                                _  (     (      *
38 *          (     (,-' `-..__                                    __..-' `-,)     )     *
39 *           \_.-''          ``-..____                  ____..-''          ``-._/      *
40 *            `-._                    ``--...____...--''                    _.-'       *
41 *                `-.._                                                _..-'           *
42 *                     `-..__          THEILLUMINATI.IO          __..-'                *
43 *                           ``-..____                  ____..-''                      *
44 *                                    ``--...____...--''                               *
45 * ============================================================================================*
46 * Created by The Illuminati
47 * ====================================*
48 * ->About ILMT
49 * An autonomousfully automated passive income:
50 * [x] Pen-tested multiple times with zero vulnerabilities!
51 * [X] Able to operate even if our website www.theilluminati.io is down via Metamask and Etherscan
52 * [x] 30 ILMT required for a Masternode Link generation
53 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
54 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
55 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
56 * - 33% Reward of dividends if someone signs up using your Masternode link
57 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
58 * Upon entry into the contract it will automatically deduct your 15% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
59 * You are able to withdraw your entire balance at any time you so choose. 
60 */
61 
62 
63 contract TheIlluminati {
64     /*=================================
65     =            MODIFIERS            =
66     =================================*/
67     // only people with tokens
68     modifier onlyBagholders() {
69         require(myTokens() > 0);
70         _;
71     }
72 
73     // only people with profits
74     modifier onlyStronghands() {
75         require(myDividends(true) > 0);
76         _;
77     }
78 
79     // ensures that the first tokens in the contract will be equally distributed
80     // meaning, no divine dump will be ever possible
81     // result: healthy longevity.
82     modifier antiEarlyWhale(uint256 _amountOfEthereum){
83         address _customerAddress = msg.sender;
84 
85         // are we still in the vulnerable phase?
86         // if so, enact anti early whale protocol 
87         if( onlyDevs && ((totalEthereumBalance() - _amountOfEthereum) <= devsQuota_ )){
88             require(
89                 // is the customer in the ambassador list?
90                 developers_[_customerAddress] == true &&
91 
92                 // does the customer purchase exceed the max ambassador quota?
93                 (devsAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= devsMaxPurchase_
94             );
95 
96             // updated the accumulated quota    
97             devsAccumulatedQuota_[_customerAddress] = SafeMath.add(devsAccumulatedQuota_[_customerAddress], _amountOfEthereum);
98 
99             // execute
100             _;
101         } else {
102             // in case the ether count drops low, the ambassador phase won't reinitiate
103             onlyDevs = false;
104             _;    
105         }
106 
107     }
108 
109 
110     /*==============================
111     =            EVENTS            =
112     ==============================*/
113     event onTokenPurchase(
114         address indexed customerAddress,
115         uint256 incomingEthereum,
116         uint256 tokensMinted,
117         address indexed referredBy
118     );
119 
120     event onTokenSell(
121         address indexed customerAddress,
122         uint256 tokensBurned,
123         uint256 ethereumEarned
124     );
125 
126     event onReinvestment(
127         address indexed customerAddress,
128         uint256 ethereumReinvested,
129         uint256 tokensMinted
130     );
131 
132     event onWithdraw(
133         address indexed customerAddress,
134         uint256 ethereumWithdrawn
135     );
136 
137     // ERC20
138     event Transfer(
139         address indexed from,
140         address indexed to,
141         uint256 tokens
142     );
143 
144 
145     /*=====================================
146     =            CONFIGURABLES            =
147     =====================================*/
148     string public name = "The Illuminati";
149     string public symbol = "ILMT";
150     uint8 constant public decimals = 18;
151     uint8 constant internal dividendFee_ = 15;
152     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
153     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
154     uint256 constant internal magnitude = 2**64;
155 
156     // proof of stake (defaults at 30 tokens)
157     uint256 public stakingRequirement = 30e18;
158 
159     // Developer program
160     mapping(address => bool) internal developers_;
161     uint256 constant internal devsMaxPurchase_ = 1 ether;
162     uint256 constant internal devsQuota_ = 1 ether;
163 
164 
165 
166    /*================================
167     =            DATASETS            =
168     ================================*/
169     // amount of shares for each address (scaled number)
170     mapping(address => uint256) internal tokenBalanceLedger_;
171     mapping(address => uint256) internal referralBalance_;
172     mapping(address => int256) internal payoutsTo_;
173     mapping(address => uint256) internal devsAccumulatedQuota_;
174     uint256 internal tokenSupply_ = 0;
175     uint256 internal profitPerShare_;
176 
177 
178     // when this is set to true, only developers can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
179     bool public onlyDevs = false;
180 
181     /*=======================================
182     =            PUBLIC FUNCTIONS            =
183     =======================================*/
184     /*
185     * -- APPLICATION ENTRY POINTS --  
186     */
187     function TheIlluminati()
188         public
189     {
190         // add developers here
191         developers_[0x4b84e4ec2cdce70aa929db0f169568e1f2d50bb8] = true;
192         
193         developers_[0xf990b7dAB7334a9FD48e1a05EeA28356857cb2d9] = true;
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
222      */
223     function reinvest()
224     onlyStronghands()
225         public
226     {
227         // fetch dividends
228         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
229 
230         // pay out the dividends virtually
231         address _customerAddress = msg.sender;
232         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
233 
234         // retrieve ref. bonus
235         _dividends += referralBalance_[_customerAddress];
236         referralBalance_[_customerAddress] = 0;
237 
238         // dispatch a buy order with the virtualized "withdrawn dividends"
239         uint256 _tokens = purchaseTokens(_dividends, 0x0);
240 
241         // fire event
242         emit onReinvestment(_customerAddress, _dividends, _tokens);
243     }
244 
245     /**
246      * Alias of sell() and withdraw().
247      */
248     function exit()
249         public
250     {
251         // get token count for caller & sell them all
252         address _customerAddress = msg.sender;
253         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
254         if(_tokens > 0) sell(_tokens);
255 
256         // lambo delivery service
257         withdraw();
258     }
259 
260     /**
261      * Withdraws all of the callers earnings.
262      */
263     function withdraw()
264     onlyStronghands()
265         public
266     {
267         // setup data
268         address _customerAddress = msg.sender;
269         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
270 
271         // update dividend tracker
272         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
273 
274         // add ref. bonus
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277 
278         // lambo delivery service
279         _customerAddress.transfer(_dividends);
280 
281         // fire event
282         emit onWithdraw(_customerAddress, _dividends);
283     }
284 
285     /**
286      * Liquifies tokens to ethereum.
287      */
288     function sell(uint256 _amountOfTokens)
289         onlyBagholders()
290         public
291     {
292         // setup data
293         address _customerAddress = msg.sender;
294         // russian hackers BTFO
295         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         uint256 _tokens = _amountOfTokens;
297         uint256 _ethereum = tokensToEthereum_(_tokens);
298         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
299         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
300 
301         // burn the sold tokens
302         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
304 
305         // update dividends tracker
306         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
307         payoutsTo_[_customerAddress] -= _updatedPayouts;       
308 
309         // dividing by zero is a bad idea
310         if (tokenSupply_ > 0) {
311             // update the amount of dividends per token
312             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
313         }
314 
315         // fire event
316         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
317     }
318 
319 
320     /**
321      * Transfer tokens from the caller to a new holder.
322      * Remember, there's a 10% fee here as well.
323      */
324     function transfer(address _toAddress, uint256 _amountOfTokens)
325         onlyBagholders()
326         public
327         returns(bool)
328     {
329         // setup
330         address _customerAddress = msg.sender;
331 
332         // make sure we have the requested tokens
333         // also disables transfers until ambassador phase is over
334         // ( wedont want whale premines )
335         require(!onlyDevs && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336 
337         // withdraw all outstanding dividends first
338         if(myDividends(true) > 0) withdraw();
339 
340         // liquify 10% of the tokens that are transfered
341         // these are dispersed to shareholders
342         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
343         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
344         uint256 _dividends = tokensToEthereum_(_tokenFee);
345 
346         // burn the fee tokens
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
348 
349         // exchange tokens
350         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
351         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
352 
353         // update dividend trackers
354         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
355         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
356 
357         // disperse dividends among holders
358         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
359 
360         // fire event
361         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
362 
363         // ERC20
364         return true;
365 
366     }
367 
368     /*----------  HELPERS AND CALCULATORS  ----------*/
369     /**
370      * Method to view the current Ethereum stored in the contract
371      * Example: totalEthereumBalance()
372      */
373     function totalEthereumBalance()
374         public
375         view
376         returns(uint)
377     {
378         return this.balance;
379     }
380 
381     /**
382      * Retrieve the total token supply.
383      */
384     function totalSupply()
385         public
386         view
387         returns(uint256)
388     {
389         return tokenSupply_;
390     }
391 
392     /**
393      * Retrieve the tokens owned by the caller.
394      */
395     function myTokens()
396         public
397         view
398         returns(uint256)
399     {
400         address _customerAddress = msg.sender;
401         return balanceOf(_customerAddress);
402     }
403 
404     /**
405      * Retrieve the dividends owned by the caller.
406      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
407      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
408      * But in the internal calculations, we want them separate. 
409      */ 
410     function myDividends(bool _includeReferralBonus) 
411         public 
412         view 
413         returns(uint256)
414     {
415         address _customerAddress = msg.sender;
416         return _includeReferralBonus ?dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
417     }
418 
419     /**
420      * Retrieve the token balance of any single address.
421      */
422     function balanceOf(address _customerAddress)
423         view
424         public
425         returns(uint256)
426     {
427         return tokenBalanceLedger_[_customerAddress];
428     }
429 
430     /**
431      * Retrieve the dividend balance of any single address.
432      */
433     function dividendsOf(address _customerAddress)
434         view
435         public
436         returns(uint256)
437     {
438         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
439     }
440 
441     /**
442      * Return the buy price of 1 individual token.
443      */
444     function sellPrice() 
445         public 
446         view 
447         returns(uint256)
448         {
449         // our calculation relies on the token supply, so we need supply. Doh.
450         if(tokenSupply_ == 0)
451         {
452             return tokenPriceInitial_ - tokenPriceIncremental_;
453         }
454         else
455         {
456             uint256 _ethereum = tokensToEthereum_(1e18);
457             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
458             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
459             return _taxedEthereum;
460         }
461         }
462 
463     /**
464      * Return the sell price of 1 individual token.
465      */
466     function buyPrice() 
467         public 
468         view 
469         returns(uint256)
470     {
471         // our calculation relies on the token supply, so we need supply. Doh.
472         if(tokenSupply_ == 0){
473             return tokenPriceInitial_ + tokenPriceIncremental_;
474         } else {
475             uint256 _ethereum = tokensToEthereum_(1e18);
476             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
477             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
478             return _taxedEthereum;
479         }
480     }
481 
482     /**
483      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
484      */
485     function calculateTokensReceived(uint256 _ethereumToSpend) 
486         public 
487         view 
488         returns(uint256)
489     {
490         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
491         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
492         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
493 
494         return _amountOfTokens;
495     }
496 
497     /**
498      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
499      */
500     function calculateEthereumReceived(uint256 _tokensToSell) 
501         public 
502         view 
503         returns(uint256)
504     {
505         require(_tokensToSell <= tokenSupply_);
506         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
507         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
508         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
509         return _taxedEthereum;
510     }
511 
512 
513     /*==========================================
514     =            INTERNAL FUNCTIONS            =
515     ==========================================*/
516     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
517         antiEarlyWhale(_incomingEthereum)
518         internal
519         returns(uint256)
520     {
521         // data setup
522         address _customerAddress = msg.sender;
523         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
524         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
525         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
526         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
527         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
528         uint256 _fee = _dividends * magnitude;
529 
530         // no point in continuing execution if OP is a poorfagrussian hacker
531         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
532         // (or hackers)
533         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
534         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
535 
536         // is the user referred by a masternode?
537         if(
538             // is this a referred purchase?
539             _referredBy != 0x0000000000000000000000000000000000000000 &&
540 
541             // no cheating!
542             _referredBy != _customerAddress&&
543 
544             // does the referrer have at least X whole tokens?
545             // i.e is the referrer a godly chad masternode
546             tokenBalanceLedger_[_referredBy] >= stakingRequirement
547         ){
548             // wealth redistribution
549             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
550         } else {
551             // no ref purchase
552             // add the referral bonus back to the global dividends cake
553             _dividends = SafeMath.add(_dividends, _referralBonus);
554             _fee = _dividends * magnitude;
555         }
556 
557         // we can't give people infinite ethereum
558         if(tokenSupply_ > 0){
559 
560             // add tokens to the pool
561             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
562 
563             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
564             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
565 
566             // calculate the amount of tokens the customer receives over his purchase 
567             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
568 
569         } else {
570             // add tokens to the pool
571             tokenSupply_ = _amountOfTokens;
572         }
573 
574         // update circulating supply & the ledger address for the customer
575         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
576 
577         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
578         //really i know you think you do but you don't
579         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
580         payoutsTo_[_customerAddress] += _updatedPayouts;
581 
582         // fire event
583         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
584 
585         return _amountOfTokens;
586     }
587 
588     /**
589      * Calculate Token price based on an amount of incoming ethereum
590      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
591      */
592     function ethereumToTokens_(uint256 _ethereum)
593         internal
594         view
595         returns(uint256)
596     {
597         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
598         uint256 _tokensReceived = 
599         (
600             (
601                 // underflow attempts BTFO
602                 SafeMath.sub(
603                     (sqrt
604                         (
605                             (_tokenPriceInitial**2)
606                             +
607                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
608                             +
609                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
610                             +
611                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
612                         )
613                     ), _tokenPriceInitial
614                 )
615             )/(tokenPriceIncremental_)
616         )-(tokenSupply_)
617         ;
618 
619         return _tokensReceived;
620     }
621 
622     /**
623      * Calculate token sell value.
624      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
625      */
626     function tokensToEthereum_(uint256 _tokens)
627         internal
628         view
629         returns(uint256)
630     {
631 
632         uint256 tokens_ = (_tokens + 1e18);
633         uint256 _tokenSupply = (tokenSupply_ + 1e18);
634         uint256 _etherReceived = 
635         (
636             // underflow attempts BTFO
637             SafeMath.sub(
638                 (
639                     (
640                         (
641                         tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply/1e18))
642                                                 )-tokenPriceIncremental_
643                     )*(tokens_ - 1e18)
644                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
645             )
646         /1e18);
647         return _etherReceived;
648     }
649 
650     function sqrt(uint x) internal pure returns (uint y) {
651         uint z = (x + 1) / 2;
652         y = x;
653         while (z < y) {
654             y = z;
655             z = (x / z + z) / 2;
656         }
657     }
658 }
659 
660 /**
661  * @title SafeMath
662  * @dev Math operations with safety checks that throw on error
663  */
664 library SafeMath {
665 
666     /**
667     * @dev Multiplies two numbers, throws on overflow.
668     */
669     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
670         if (a == 0) {
671             return 0;
672         }
673         uint256 c = a * b;
674         assert(c / a == b);
675         return c;
676     }
677 
678     /**
679     * @dev Integer division of two numbers, truncating the quotient.
680     */
681     function div(uint256 a, uint256 b) internal pure returns (uint256) {
682         // assert(b > 0); // Solidity automatically throws when dividing by 0
683         uint256 c = a / b;
684         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
685         return c;
686     }
687 
688     /**
689     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
690     */
691     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
692         assert(b <= a);
693         return a - b;
694     }
695 
696     /**
697     * @dev Adds two numbers, throws on overflow.
698     */
699     function add(uint256 a, uint256 b) internal pure returns (uint256) {
700         uint256 c = a + b;
701         assert(c >= a);
702         return c;
703     }
704 }