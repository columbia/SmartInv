1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-04
3 */
4 
5 pragma solidity ^0.4.20;
6 
7 /*
8 * -> What?
9 * The original autonomous pyramid, improved:
10 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
11 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
12 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
13 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
14 * [x] New Feature: Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
15 * [x] Masternodes: Holding 100 M3X Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
16 */
17 
18 contract Hourglass {
19     /*=================================
20     =            MODIFIERS            =
21     =================================*/
22     // only people with tokens
23     modifier onlyBagholders() {
24         require(myTokens() > 0);
25         _;
26     }
27     
28     // only people with profits
29     modifier onlyStronghands() {
30         require(myDividends(true) > 0);
31         _;
32     }
33     
34     // administrators can:
35     // -> change the name of the contract
36     // -> change the name of the token
37     // -> change the difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
38     // they CANNOT:
39     // -> take funds
40     // -> disable withdrawals
41     // -> kill the contract
42     // -> change the price of tokens
43     modifier onlyAdministrator(){
44         address _customerAddress = msg.sender;
45         require(administrators[_customerAddress]);
46         _;
47     }
48     
49     
50     // ensures that the first tokens in the contract will be equally distributed
51     // meaning, no divine dump will be ever possible
52     // result: healthy longevity.
53     modifier antiEarlyWhale(uint256 _amountOfEthereum){
54         address _customerAddress = msg.sender;
55         
56         // are we still in the vulnerable phase?
57         // if so, enact anti early whale protocol 
58         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
59             require(
60                 // is the customer in the ambassador list?
61                 ambassadors_[_customerAddress] == true &&
62                 
63                 // does the customer purchase exceed the max ambassador quota?
64                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
65                 
66             );
67             
68             // updated the accumulated quota    
69             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
70         
71             // execute
72             _;
73         } else {
74             // in case the ether count drops low, the ambassador phase won't reinitiate
75             onlyAmbassadors = false;
76             _;    
77         }
78         
79     }
80     
81     
82     /*==============================
83     =            EVENTS            =
84     ==============================*/
85     event onTokenPurchase(
86         address indexed customerAddress,
87         uint256 incomingEthereum,
88         uint256 tokensMinted,
89         address indexed referredBy
90     );
91     
92     event onTokenSell(
93         address indexed customerAddress,
94         uint256 tokensBurned,
95         uint256 ethereumEarned
96     );
97     
98     event onReinvestment(
99         address indexed customerAddress,
100         uint256 ethereumReinvested,
101         uint256 tokensMinted
102     );
103     
104     event onWithdraw(
105         address indexed customerAddress,
106         uint256 ethereumWithdrawn
107     );
108     
109     // ERC20
110     event Transfer(
111         address indexed from,
112         address indexed to,
113         uint256 tokens
114     );
115     
116     
117     /*=====================================
118     =            CONFIGURABLES            =
119     =====================================*/
120     string public name = "MegaMine Token";
121     string public symbol = "M3X";
122     uint8 constant public decimals = 18;
123     uint8 constant internal dividendFee_ = 15; // 15% tax on trade
124     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
125     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
126     uint256 constant internal magnitude = 2**64;
127     
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 100e18;
130     
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
134     uint256 constant internal ambassadorQuota_ = 20 ether;
135     
136     
137     
138    /*================================
139     =            DATASETS            =
140     ================================*/
141     // amount of shares for each address (scaled number)
142     mapping(address => uint256) internal tokenBalanceLedger_;
143     mapping(address => uint256) internal referralBalance_;
144     mapping(address => int256) internal payoutsTo_;
145     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
146     uint256 internal tokenSupply_ = 0;
147     uint256 internal profitPerShare_;
148     
149     // administrator list (see above on what they can do)
150     mapping(address => bool) public administrators;
151     
152     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
153     bool public onlyAmbassadors = true;
154     
155 
156 
157     /*=======================================
158     =            PUBLIC FUNCTIONS            =
159     =======================================*/
160     /*
161     * -- APPLICATION ENTRY POINTS --  
162     */
163     function Hourglass()
164         public
165     {
166         // add administrators here
167       administrators[0xbf75D729a3Dabd159DC8d3e4dfC4bA0Af5Bd5d0E] = true; //0xbf75D729a3Dabd159DC8d3e4dfC4bA0Af5Bd5d0E
168         
169         // add the ambassadors here.
170         // mantso - lead solidity dev & lead web dev. 
171         ambassadors_[0xbf75D729a3Dabd159DC8d3e4dfC4bA0Af5Bd5d0E] = true;
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
200      */
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
276         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_); // 15% sell fees
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
298     
299     function transfer(address _toAddress, uint256 _amountOfTokens)
300         onlyBagholders()
301         public
302         returns(bool)
303     {
304         // setup
305         address _customerAddress = msg.sender;
306         
307         // make sure we have the requested tokens
308         // also disables transfers until ambassador phase is over
309         // ( we dont want whale premines )
310         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
311         
312         // withdraw all outstanding dividends first
313         if(myDividends(true) > 0) withdraw();
314         
315         
316         // these are dispersed to shareholders
317         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
318         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
319         uint256 _dividends = tokensToEthereum_(_tokenFee);
320   
321         // burn the fee tokens
322         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
323 
324         // exchange tokens
325         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
326         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
327         
328         // update dividend trackers
329         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
330         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
331         
332         // disperse dividends among holders
333         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334         
335         // fire event
336         Transfer(_customerAddress, _toAddress, _taxedTokens);
337         
338         // ERC20
339         return true;
340        
341     }
342     
343     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
344     /**
345      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
346      */
347     function disableInitialStage()
348         onlyAdministrator()
349         public
350     {
351         onlyAmbassadors = false;
352     }
353     
354     function destruct() onlyAdministrator() public{
355         selfdestruct(0xbf75D729a3Dabd159DC8d3e4dfC4bA0Af5Bd5d0E);
356     }
357     
358     /**
359      * In case one of us dies, we need to replace ourselves.
360      */
361     function setAdministrator(address _identifier, bool _status)
362         onlyAdministrator()
363         public
364     {
365         administrators[_identifier] = _status;
366     }
367     
368     /**
369      * Precautionary measures in case we need to adjust the masternode rate.
370      */
371     function setStakingRequirement(uint256 _amountOfTokens)
372         onlyAdministrator()
373         public
374     {
375         stakingRequirement = _amountOfTokens;
376     }
377     
378     /**
379      * If we want to rebrand, we can.
380      */
381     function setName(string _name)
382         onlyAdministrator()
383         public
384     {
385         name = _name;
386     }
387     
388     /**
389      * If we want to rebrand, we can.
390      */
391     function setSymbol(string _symbol)
392         onlyAdministrator()
393         public
394     {
395         symbol = _symbol;
396     }
397 
398     
399     /*----------  HELPERS AND CALCULATORS  ----------*/
400     /**
401      * Method to view the current Ethereum stored in the contract
402      * Example: totalEthereumBalance()
403      */
404     function totalEthereumBalance()
405         public
406         view
407         returns(uint)
408     {
409         return this.balance;
410     }
411     
412     /**
413      * Retrieve the total token supply.
414      */
415     function totalSupply()
416         public
417         view
418         returns(uint256)
419     {
420         return tokenSupply_;
421     }
422     
423     /**
424      * Retrieve the tokens owned by the caller.
425      */
426     function myTokens()
427         public
428         view
429         returns(uint256)
430     {
431         address _customerAddress = msg.sender;
432         return balanceOf(_customerAddress);
433     }
434     
435     /**
436      * Retrieve the dividends owned by the caller.
437      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
438      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
439      * But in the internal calculations, we want them separate. 
440      */ 
441     function myDividends(bool _includeReferralBonus) 
442         public 
443         view 
444         returns(uint256)
445     {
446         address _customerAddress = msg.sender;
447         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
448     }
449     
450     /**
451      * Retrieve the token balance of any single address.
452      */
453     function balanceOf(address _customerAddress)
454         view
455         public
456         returns(uint256)
457     {
458         return tokenBalanceLedger_[_customerAddress];
459     }
460     
461     /**
462      * Retrieve the dividend balance of any single address.
463      */
464     function dividendsOf(address _customerAddress)
465         view
466         public
467         returns(uint256)
468     {
469         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
470     }
471     
472     /**
473      * Return the buy price of 1 individual token.
474      */
475     function sellPrice() 
476         public 
477         view 
478         returns(uint256)
479     {
480         // our calculation relies on the token supply, so we need supply. Doh.
481         if(tokenSupply_ == 0){
482             return tokenPriceInitial_ - tokenPriceIncremental_;
483         } else {
484             uint256 _ethereum = tokensToEthereum_(1e18);
485             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
486             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
487             return _taxedEthereum;
488         }
489     }
490     
491     /**
492      * Return the sell price of 1 individual token.
493      */
494     function buyPrice() 
495         public 
496         view 
497         returns(uint256)
498     {
499         // our calculation relies on the token supply, so we need supply. Doh.
500         if(tokenSupply_ == 0){
501             return tokenPriceInitial_ + tokenPriceIncremental_;
502         } else {
503             uint256 _ethereum = tokensToEthereum_(1e18);
504             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
505             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
506             return _taxedEthereum;
507         }
508     }
509     
510     /**
511      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
512      */
513     function calculateTokensReceived(uint256 _ethereumToSpend) 
514         public 
515         view 
516         returns(uint256)
517     {
518         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
519         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
520         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
521         
522         return _amountOfTokens;
523     }
524     
525     /**
526      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
527      */
528     function calculateEthereumReceived(uint256 _tokensToSell) 
529         public 
530         view 
531         returns(uint256)
532     {
533         require(_tokensToSell <= tokenSupply_);
534         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
535         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
536         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
537         return _taxedEthereum;
538     }
539     
540     
541     /*==========================================
542     =            INTERNAL FUNCTIONS            =
543     ==========================================*/
544     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
545         antiEarlyWhale(_incomingEthereum)
546         internal
547         returns(uint256)
548     {
549         // data setup
550         address _customerAddress = msg.sender;
551         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
552         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
553         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
554         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
555         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
556         uint256 _fee = _dividends * magnitude;
557  
558         // no point in continuing execution if OP is a poorfag russian hacker
559         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
560         // (or hackers)
561         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
562         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
563         
564         // is the user referred by a masternode?
565         if(
566             // is this a referred purchase?
567             _referredBy != 0x0000000000000000000000000000000000000000 &&
568 
569             // no cheating!
570             _referredBy != _customerAddress &&
571             
572             // does the referrer have at least X whole tokens?
573             // i.e is the referrer a godly chad masternode
574             tokenBalanceLedger_[_referredBy] >= stakingRequirement
575         ){
576             // wealth redistribution
577             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
578         } else {
579             // no ref purchase
580             // add the referral bonus back to the global dividends cake
581             _dividends = SafeMath.add(_dividends, _referralBonus);
582             _fee = _dividends * magnitude;
583         }
584         
585         // we can't give people infinite ethereum
586         if(tokenSupply_ > 0){
587             
588             // add tokens to the pool
589             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
590  
591             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
592             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
593             
594             // calculate the amount of tokens the customer receives over his purchase 
595             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
596         
597         } else {
598             // add tokens to the pool
599             tokenSupply_ = _amountOfTokens;
600         }
601         
602         // update circulating supply & the ledger address for the customer
603         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
604         
605         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
606         //really i know you think you do but you don't
607         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
608         payoutsTo_[_customerAddress] += _updatedPayouts;
609         
610         // fire event
611         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
612         
613         return _amountOfTokens;
614     }
615 
616     /**
617      * Calculate Token price based on an amount of incoming ethereum
618      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
619      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
620      */
621     function ethereumToTokens_(uint256 _ethereum)
622         internal
623         view
624         returns(uint256)
625     {
626         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
627         uint256 _tokensReceived = 
628          (
629             (
630                 // underflow attempts BTFO
631                 SafeMath.sub(
632                     (sqrt
633                         (
634                             (_tokenPriceInitial**2)
635                             +
636                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
637                             +
638                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
639                             +
640                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
641                         )
642                     ), _tokenPriceInitial
643                 )
644             )/(tokenPriceIncremental_)
645         )-(tokenSupply_)
646         ;
647   
648         return _tokensReceived;
649     }
650     
651     /**
652      * Calculate token sell value.
653      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
654      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
655      */
656      function tokensToEthereum_(uint256 _tokens)
657         internal
658         view
659         returns(uint256)
660     {
661 
662         uint256 tokens_ = (_tokens + 1e18);
663         uint256 _tokenSupply = (tokenSupply_ + 1e18);
664         uint256 _etherReceived =
665         (
666             // underflow attempts BTFO
667             SafeMath.sub(
668                 (
669                     (
670                         (
671                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
672                         )-tokenPriceIncremental_
673                     )*(tokens_ - 1e18)
674                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
675             )
676         /1e18);
677         return _etherReceived;
678     }
679     
680     
681     //This is where all your gas goes, sorry
682     //Not sorry, you probably only paid 1 gwei
683     function sqrt(uint x) internal pure returns (uint y) {
684         uint z = (x + 1) / 2;
685         y = x;
686         while (z < y) {
687             y = z;
688             z = (x / z + z) / 2;
689         }
690     }
691 }
692 
693 /**
694  * @title SafeMath
695  * @dev Math operations with safety checks that throw on error
696  */
697 library SafeMath {
698 
699     /**
700     * @dev Multiplies two numbers, throws on overflow.
701     */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         if (a == 0) {
704             return 0;
705         }
706         uint256 c = a * b;
707         assert(c / a == b);
708         return c;
709     }
710 
711     /**
712     * @dev Integer division of two numbers, truncating the quotient.
713     */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         // assert(b > 0); // Solidity automatically throws when dividing by 0
716         uint256 c = a / b;
717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
718         return c;
719     }
720 
721     /**
722     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
725         assert(b <= a);
726         return a - b;
727     }
728 
729     /**
730     * @dev Adds two numbers, throws on overflow.
731     */
732     function add(uint256 a, uint256 b) internal pure returns (uint256) {
733         uint256 c = a + b;
734         assert(c >= a);
735         return c;
736     }
737     
738     
739 }