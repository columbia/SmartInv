1 pragma solidity ^0.4.20;
2 
3 /*
4 * Created by LOCKEDiN
5 * ====================================*
6 * ->About LOCK
7 * An autonomousfully automated passive income:
8 * [x] Created by a team of professional Developers from India who run a software company and specialize in Internet and Cryptographic Security
9 * [x] Pen-tested multiple times with zero vulnerabilities!
10 * [X] Able to operate even if our website www.lockedin.io is down via Metamask and Etherscan
11 * [x] 30 LOCK required for a Masternode Link generation
12 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
13 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
14 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
15 * - 33% Reward of dividends if someone signs up using your Masternode link
16 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
17 * Upon entry into the contract it will automatically deduct your 10% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
18 * You are able to withdraw your entire balance at any time you so choose. 
19 */
20 
21 
22 contract Hourglass {
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26     // only people with tokens
27     modifier onlyBagholders() {
28         require(myTokens() > 0);
29         _;
30     }
31 
32     // only people with profits
33     modifier onlyStronghands() {
34         require(myDividends(true) > 0);
35         _;
36     }
37 
38 
39     // ensures that the first tokens in the contract will be equally distributed
40     // meaning, no divine dump will be ever possible
41     // result: healthy longevity.
42     modifier antiEarlyWhale(uint256 _amountOfEthereum){
43         address _customerAddress = msg.sender;
44 
45         // are we still in the vulnerable phase?
46         // if so, enact anti early whale protocol 
47         if( onlyDeves&& ((totalEthereumBalance() - _amountOfEthereum) <= devsQuota_ )){
48             require(
49                 // is the customer in the ambassador list?
50                 developers_[_customerAddress] == true &&
51 
52                 // does the customer purchase exceed the max ambassador quota?
53                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= devsMaxPurchase_
54 
55             );
56 
57             // updated the accumulated quota    
58             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
59 
60             // execute
61             _;
62         } else {
63             // in case the ether count drops low, the ambassador phase won't reinitiate
64             onlyDeves = false;
65             _;    
66         }
67 
68     }
69 
70 
71     /*==============================
72     =            EVENTS            =
73     ==============================*/
74     event onTokenPurchase(
75         address indexed customerAddress,
76         uint256 incomingEthereum,
77         uint256 tokensMinted,
78         address indexed referredBy
79     );
80 
81     event onTokenSell(
82         address indexed customerAddress,
83         uint256 tokensBurned,
84         uint256 ethereumEarned
85     );
86 
87     event onReinvestment(
88         address indexed customerAddress,
89         uint256 ethereumReinvested,
90         uint256 tokensMinted
91     );
92 
93     event onWithdraw(
94         address indexed customerAddress,
95         uint256 ethereumWithdrawn
96     );
97 
98     // ERC20
99     event Transfer(
100         address indexed from,
101         address indexed to,
102         uint256 tokens
103     );
104 
105 
106     /*=====================================
107     =            CONFIGURABLES            =
108     =====================================*/
109     string public name = "LOCKEDiN";
110     string public symbol = "LOCK";
111     uint8 constant public decimals = 18;
112     uint8 constant internal dividendFee_ = 10;
113     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
114     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
115     uint256 constant internal magnitude = 2**64;
116 
117     // proof of stake (defaults at 30 tokens)
118     uint256 public stakingRequirement = 30e18;
119 
120     // Developer program
121     mapping(address => bool) internal developers_;
122     uint256 constant internal devsMaxPurchase_ = 1 ether;
123     uint256 constant internal devsQuota_ = 3 ether;
124 
125 
126 
127    /*================================
128     =            DATASETS            =
129     ================================*/
130     // amount of shares for each address (scaled number)
131     mapping(address => uint256) internal tokenBalanceLedger_;
132     mapping(address => uint256) internal referralBalance_;
133     mapping(address => int256) internal payoutsTo_;
134     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
135     uint256 internal tokenSupply_ = 0;
136     uint256 internal profitPerShare_;
137 
138 
139     // when this is set to true, only developers can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
140     bool public onlyDeves = true;
141 
142 
143 
144     /*=======================================
145     =            PUBLIC FUNCTIONS            =
146     =======================================*/
147     /*
148     * -- APPLICATION ENTRY POINTS --  
149     */
150     function Hourglass()
151         public
152     {
153         // add developers here
154         developers_[0x2AAC4821B03Ed3c14Cab6d62782a368e0c44e7de] = true;
155 
156         developers_[0xd9eA90E6491475EB498d55Be2165775080eD4F83] = true;
157 
158         developers_[0xEb1874f8b702AB8911ae64D36f6B34975afcc431] = true;
159 
160 
161     }
162 
163 
164     /**
165      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
166      */
167     function buy(address _referredBy)
168         public
169         payable
170         returns(uint256)
171     {
172         purchaseTokens(msg.value, _referredBy);
173     }
174 
175     /**
176      * Fallback function to handle ethereum that was send straight to the contract
177      * Unfortunately we cannot use a referral address this way.
178      */
179     function()
180         payable
181         public
182     {
183         purchaseTokens(msg.value, 0x0);
184     }
185 
186     /**
187      * Converts all of caller's dividends to tokens.
188      */
189     function reinvest()
190     onlyStronghands()
191         public
192     {
193         // fetch dividends
194         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
195 
196         // pay out the dividends virtually
197         address _customerAddress = msg.sender;
198         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
199 
200         // retrieve ref. bonus
201         _dividends += referralBalance_[_customerAddress];
202         referralBalance_[_customerAddress] = 0;
203 
204         // dispatch a buy order with the virtualized "withdrawn dividends"
205         uint256 _tokens = purchaseTokens(_dividends, 0x0);
206 
207         // fire event
208         emit onReinvestment(_customerAddress, _dividends, _tokens);
209     }
210 
211     /**
212      * Alias of sell() and withdraw().
213      */
214     function exit()
215         public
216     {
217         // get token count for caller & sell them all
218         address _customerAddress = msg.sender;
219         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
220         if(_tokens > 0) sell(_tokens);
221 
222         // lambo delivery service
223         withdraw();
224     }
225 
226     /**
227      * Withdraws all of the callers earnings.
228      */
229     function withdraw()
230     onlyStronghands()
231         public
232     {
233         // setup data
234         address _customerAddress = msg.sender;
235         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
236 
237         // update dividend tracker
238         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
239 
240         // add ref. bonus
241         _dividends += referralBalance_[_customerAddress];
242         referralBalance_[_customerAddress] = 0;
243 
244         // lambo delivery service
245         _customerAddress.transfer(_dividends);
246 
247         // fire event
248         emit onWithdraw(_customerAddress, _dividends);
249     }
250 
251     /**
252      * Liquifies tokens to ethereum.
253      */
254     function sell(uint256 _amountOfTokens)
255         onlyBagholders()
256         public
257     {
258         // setup data
259         address _customerAddress = msg.sender;
260         // russian hackers BTFO
261         require(_amountOfTokens<= tokenBalanceLedger_[_customerAddress]);
262         uint256 _tokens = _amountOfTokens;
263         uint256 _ethereum = tokensToEthereum_(_tokens);
264         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
265         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
266 
267         // burn the sold tokens
268         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
269         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
270 
271         // update dividends tracker
272         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
273         payoutsTo_[_customerAddress] -= _updatedPayouts;       
274 
275         // dividing by zero is a bad idea
276         if (tokenSupply_ > 0) {
277             // update the amount of dividends per token
278             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
279         }
280 
281         // fire event
282         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
283     }
284 
285 
286     /**
287      * Transfer tokens from the caller to a new holder.
288      * Remember, there's a 10% fee here as well.
289      */
290     function transfer(address _toAddress, uint256 _amountOfTokens)
291         onlyBagholders()
292         public
293         returns(bool)
294     {
295         // setup
296         address _customerAddress = msg.sender;
297 
298         // make sure we have the requested tokens
299         // also disables transfers until ambassador phase is over
300         // ( wedont want whale premines )
301         require(!onlyDeves&& _amountOfTokens<= tokenBalanceLedger_[_customerAddress]);
302 
303         // withdraw all outstanding dividends first
304         if(myDividends(true) > 0) withdraw();
305 
306         // liquify 10% of the tokens that are transfered
307         // these are dispersed to shareholders
308         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
309         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
310         uint256 _dividends = tokensToEthereum_(_tokenFee);
311 
312         // burn the fee tokens
313         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
314 
315         // exchange tokens
316         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
317         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
318 
319         // update dividend trackers
320         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
321         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
322 
323         // disperse dividends among holders
324         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325 
326         // fire event
327         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
328 
329         // ERC20
330         return true;
331 
332     }
333 
334     
335 
336     /*----------  HELPERS AND CALCULATORS  ----------*/
337     /**
338      * Method to view the current Ethereum stored in the contract
339      * Example: totalEthereumBalance()
340      */
341     function totalEthereumBalance()
342         public
343         view
344         returns(uint)
345     {
346         return this.balance;
347     }
348 
349     /**
350      * Retrieve the total token supply.
351      */
352     function totalSupply()
353         public
354         view
355         returns(uint256)
356     {
357         return tokenSupply_;
358     }
359 
360     /**
361      * Retrieve the tokens owned by the caller.
362      */
363     function myTokens()
364         public
365         view
366         returns(uint256)
367     {
368         address _customerAddress = msg.sender;
369         return balanceOf(_customerAddress);
370     }
371 
372     /**
373      * Retrieve the dividends owned by the caller.
374      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
375      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
376      * But in the internal calculations, we want them separate. 
377      */ 
378     function myDividends(bool _includeReferralBonus) 
379         public 
380         view 
381         returns(uint256)
382     {
383         address _customerAddress = msg.sender;
384         return _includeReferralBonus ?dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
385     }
386 
387     /**
388      * Retrieve the token balance of any single address.
389      */
390     function balanceOf(address _customerAddress)
391         view
392         public
393         returns(uint256)
394     {
395         return tokenBalanceLedger_[_customerAddress];
396     }
397 
398     /**
399      * Retrieve the dividend balance of any single address.
400      */
401     function dividendsOf(address _customerAddress)
402         view
403         public
404         returns(uint256)
405     {
406         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
407     }
408 
409     /**
410      * Return the buy price of 1 individual token.
411      */
412     function sellPrice() 
413         public 
414         view 
415         returns(uint256)
416     {
417         // our calculation relies on the token supply, so we need supply. Doh.
418             if(tokenSupply_ == 0){
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
434         returns(uint256)
435     {
436         // our calculation relies on the token supply, so we need supply. Doh.
437         if(tokenSupply_ == 0){
438             return tokenPriceInitial_ + tokenPriceIncremental_;
439         } else {
440             uint256 _ethereum = tokensToEthereum_(1e18);
441             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
442             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
443             return _taxedEthereum;
444         }
445     }
446 
447     /**
448      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
449      */
450     function calculateTokensReceived(uint256 _ethereumToSpend) 
451         public 
452         view 
453         returns(uint256)
454     {
455         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
456         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
457         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
458 
459         return _amountOfTokens;
460     }
461 
462     /**
463      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
464      */
465     function calculateEthereumReceived(uint256 _tokensToSell) 
466         public 
467         view 
468         returns(uint256)
469     {
470         require(_tokensToSell<= tokenSupply_);
471         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
472         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
473         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
474         return _taxedEthereum;
475     }
476 
477 
478     /*==========================================
479     =            INTERNAL FUNCTIONS            =
480     ==========================================*/
481     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
482         antiEarlyWhale(_incomingEthereum)
483         internal
484         returns(uint256)
485     {
486         // data setup
487         address _customerAddress = msg.sender;
488         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
489         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
490         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
491         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
492         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
493         uint256 _fee = _dividends * magnitude;
494 
495         // no point in continuing execution if OP is a poorfagrussian hacker
496         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
497         // (or hackers)
498         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
499         require(_amountOfTokens> 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) >tokenSupply_));
500 
501         // is the user referred by a masternode?
502         if(
503             // is this a referred purchase?
504             _referredBy != 0x0000000000000000000000000000000000000000 &&
505 
506             // no cheating!
507             _referredBy != _customerAddress&&
508 
509             // does the referrer have at least X whole tokens?
510             // i.e is the referrer a godly chad masternode
511             tokenBalanceLedger_[_referredBy] >= stakingRequirement
512         ){
513             // wealth redistribution
514             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
515         } else {
516             // no ref purchase
517             // add the referral bonus back to the global dividends cake
518             _dividends = SafeMath.add(_dividends, _referralBonus);
519             _fee = _dividends * magnitude;
520         }
521 
522         // we can't give people infinite ethereum
523         if(tokenSupply_ > 0){
524 
525             // add tokens to the pool
526             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
527 
528             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
529             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
530 
531             // calculate the amount of tokens the customer receives over his purchase 
532             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
533 
534         } else {
535             // add tokens to the pool
536             tokenSupply_ = _amountOfTokens;
537         }
538 
539         // update circulating supply & the ledger address for the customer
540         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
541 
542         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
543         //really i know you think you do but you don't
544         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
545         payoutsTo_[_customerAddress] += _updatedPayouts;
546 
547         // fire event
548         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
549 
550         return _amountOfTokens;
551     }
552 
553     /**
554      * Calculate Token price based on an amount of incoming ethereum
555      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
556      */
557     function ethereumToTokens_(uint256 _ethereum)
558         internal
559         view
560         returns(uint256)
561     {
562         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
563         uint256 _tokensReceived = 
564          (
565             (
566                 // underflow attempts BTFO
567                 SafeMath.sub(
568                     (sqrt
569                         (
570                             (_tokenPriceInitial**2)
571                             +
572                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
573                             +
574                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
575                             +
576                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
577                         )
578                     ), _tokenPriceInitial
579                 )
580             )/(tokenPriceIncremental_)
581         )-(tokenSupply_)
582         ;
583 
584         return _tokensReceived;
585     }
586 
587     /**
588      * Calculate token sell value.
589      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
590      */
591      function tokensToEthereum_(uint256 _tokens)
592         internal
593         view
594         returns(uint256)
595     {
596 
597         uint256 tokens_ = (_tokens + 1e18);
598         uint256 _tokenSupply = (tokenSupply_ + 1e18);
599         uint256 _etherReceived =
600         (
601             // underflow attempts BTFO
602             SafeMath.sub(
603                 (
604                     (
605                         (
606                         tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
607                                                 )-tokenPriceIncremental_
608                     )*(tokens_ - 1e18)
609                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
610             )
611         /1e18);
612         return _etherReceived;
613     }
614 
615 
616     function sqrt(uint x) internal pure returns (uint y) {
617         uint z = (x + 1) / 2;
618         y = x;
619         while (z < y) {
620             y = z;
621             z = (x / z + z) / 2;
622         }
623     }
624 }
625 
626 /**
627  * @title SafeMath
628  * @dev Math operations with safety checks that throw on error
629  */
630 library SafeMath {
631 
632     /**
633     * @dev Multiplies two numbers, throws on overflow.
634     */
635     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
636         if (a == 0) {
637             return 0;
638         }
639         uint256 c = a * b;
640         assert(c / a == b);
641         return c;
642     }
643 
644     /**
645     * @dev Integer division of two numbers, truncating the quotient.
646     */
647     function div(uint256 a, uint256 b) internal pure returns (uint256) {
648         // assert(b > 0); // Solidity automatically throws when dividing by 0
649         uint256 c = a / b;
650         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
651         return c;
652     }
653 
654     /**
655     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
656     */
657     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
658         assert(b <= a);
659         return a - b;
660     }
661 
662     /**
663     * @dev Adds two numbers, throws on overflow.
664     */
665     function add(uint256 a, uint256 b) internal pure returns (uint256) {
666         uint256 c = a + b;
667         assert(c >= a);
668         return c;
669     }
670 }