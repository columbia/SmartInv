1 pragma solidity ^0.4.21;
2 /*
3 * Created by LowIQ
4 * ====================================*
5 * ->About POB https://powerofbubble.com/
6 * An autonomousfully automated passive income:
7 * [x] Created by a team of professional Developers from India who run a software company and specialize in Internet and Cryptographic Security
8 * [x] Pen-tested multiple times with zero vulnerabilities!
9 * [X] Able to operate even if our website www.lockedin.io is down via Metamask and Etherscan
10 * [x] 30 LCK required for a Masternode Link generation
11 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
12 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
13 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
14 * - 33% Reward of dividends if someone signs up using your Masternode link
15 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
16 * Upon entry into the contract it will automatically deduct your 10% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
17 * You are able to withdraw your entire balance at any time you so choose. 
18 */
19 
20 
21 contract PowerofBubble {
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
37     // ensures that the first tokens in the contract will be equally distributed
38     // meaning, no divine dump will be ever possible
39     // result: healthy longevity.
40     modifier antiEarlyWhale(uint256 _amountOfEthereum){
41         address _customerAddress = msg.sender;
42 
43         // are we still in the vulnerable phase?
44         // if so, enact anti early whale protocol 
45         if( onlyDevs && ((totalEthereumBalance() - _amountOfEthereum) <= devsQuota_ )){
46             require(
47                 // is the customer in the ambassador list?
48                 developers_[_customerAddress] == true &&
49 
50                 // does the customer purchase exceed the max ambassador quota?
51                 (devsAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= devsMaxPurchase_
52             );
53 
54             // updated the accumulated quota    
55             devsAccumulatedQuota_[_customerAddress] = SafeMath.add(devsAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56 
57             // execute
58             _;
59         } else {
60             // in case the ether count drops low, the ambassador phase won't reinitiate
61             onlyDevs = false;
62             _;    
63         }
64 
65     }
66 
67 
68     /*==============================
69     =            EVENTS            =
70     ==============================*/
71     event onTokenPurchase(
72         address indexed customerAddress,
73         uint256 incomingEthereum,
74         uint256 tokensMinted,
75         address indexed referredBy
76     );
77 
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 tokensBurned,
81         uint256 ethereumEarned
82     );
83 
84     event onReinvestment(
85         address indexed customerAddress,
86         uint256 ethereumReinvested,
87         uint256 tokensMinted
88     );
89 
90     event onWithdraw(
91         address indexed customerAddress,
92         uint256 ethereumWithdrawn
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
106     string public name = "Power of Bubble";
107     string public symbol = "POB";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 25;
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113 
114     // proof of stake (defaults at 30 tokens)
115     uint256 public stakingRequirement = 30e18;
116 
117     // Developer program
118     mapping(address => bool) internal developers_;
119     uint256 constant internal devsMaxPurchase_ = 0.3 ether;
120     uint256 constant internal devsQuota_ = 0.1 ether;
121 
122 
123 
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     // amount of shares for each address (scaled number)
128     mapping(address => uint256) internal tokenBalanceLedger_;
129     mapping(address => uint256) internal referralBalance_;
130     mapping(address => int256) internal payoutsTo_;
131     mapping(address => uint256) internal devsAccumulatedQuota_;
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134 
135 
136     // when this is set to true, only developers can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
137     bool public onlyDevs = true;
138 
139     /*=======================================
140     =            PUBLIC FUNCTIONS            =
141     =======================================*/
142     /*
143     * -- APPLICATION ENTRY POINTS --  
144     */
145     function PowerofBubble()
146         public
147     {
148         // add developers here
149         developers_[0xE18e877A0e35dF8f3d578DacD252B8435318D027] = true;
150         
151         developers_[0xD6d3955714C8ffdc3f236e66Af065f2E9B10706a] = true;
152 
153     }
154 
155 
156     /**
157      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
158      */
159     function buy(address _referredBy)
160         public
161         payable
162         returns(uint256)
163     {
164         purchaseTokens(msg.value, _referredBy);
165     }
166 
167     /**
168      * Fallback function to handle ethereum that was send straight to the contract
169      * Unfortunately we cannot use a referral address this way.
170      */
171     function()
172         payable
173         public
174     {
175         purchaseTokens(msg.value, 0x0);
176     }
177 
178     /**
179      * Converts all of caller's dividends to tokens.
180      */
181     function reinvest()
182     onlyStronghands()
183         public
184     {
185         // fetch dividends
186         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
187 
188         // pay out the dividends virtually
189         address _customerAddress = msg.sender;
190         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
191 
192         // retrieve ref. bonus
193         _dividends += referralBalance_[_customerAddress];
194         referralBalance_[_customerAddress] = 0;
195 
196         // dispatch a buy order with the virtualized "withdrawn dividends"
197         uint256 _tokens = purchaseTokens(_dividends, 0x0);
198 
199         // fire event
200         emit onReinvestment(_customerAddress, _dividends, _tokens);
201     }
202 
203     /**
204      * Alias of sell() and withdraw().
205      */
206     function exit()
207         public
208     {
209         // get token count for caller & sell them all
210         address _customerAddress = msg.sender;
211         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
212         if(_tokens > 0) sell(_tokens);
213 
214         // lambo delivery service
215         withdraw();
216     }
217 
218     /**
219      * Withdraws all of the callers earnings.
220      */
221     function withdraw()
222     onlyStronghands()
223         public
224     {
225         // setup data
226         address _customerAddress = msg.sender;
227         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
228 
229         // update dividend tracker
230         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
231 
232         // add ref. bonus
233         _dividends += referralBalance_[_customerAddress];
234         referralBalance_[_customerAddress] = 0;
235 
236         // lambo delivery service
237         _customerAddress.transfer(_dividends);
238 
239         // fire event
240         emit onWithdraw(_customerAddress, _dividends);
241     }
242 
243     /**
244      * Liquifies tokens to ethereum.
245      */
246     function sell(uint256 _amountOfTokens)
247         onlyBagholders()
248         public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         // russian hackers BTFO
253         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
254         uint256 _tokens = _amountOfTokens;
255         uint256 _ethereum = tokensToEthereum_(_tokens);
256         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
257         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
258 
259         // burn the sold tokens
260         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
262 
263         // update dividends tracker
264         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
265         payoutsTo_[_customerAddress] -= _updatedPayouts;       
266 
267         // dividing by zero is a bad idea
268         if (tokenSupply_ > 0) {
269             // update the amount of dividends per token
270             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
271         }
272 
273         // fire event
274         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
275     }
276 
277 
278     /**
279      * Transfer tokens from the caller to a new holder.
280      * Remember, there's a 10% fee here as well.
281      */
282     function transfer(address _toAddress, uint256 _amountOfTokens)
283         onlyBagholders()
284         public
285         returns(bool)
286     {
287         // setup
288         address _customerAddress = msg.sender;
289 
290         // make sure we have the requested tokens
291         // also disables transfers until ambassador phase is over
292         // ( wedont want whale premines )
293         require(!onlyDevs && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
294 
295         // withdraw all outstanding dividends first
296         if(myDividends(true) > 0) withdraw();
297 
298         // liquify 10% of the tokens that are transfered
299         // these are dispersed to shareholders
300         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
301         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
302         uint256 _dividends = tokensToEthereum_(_tokenFee);
303 
304         // burn the fee tokens
305         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
306 
307         // exchange tokens
308         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
309         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
310 
311         // update dividend trackers
312         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
313         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
314 
315         // disperse dividends among holders
316         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
317 
318         // fire event
319         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
320 
321         // ERC20
322         return true;
323 
324     }
325 
326     /*----------  HELPERS AND CALCULATORS  ----------*/
327     /**
328      * Method to view the current Ethereum stored in the contract
329      * Example: totalEthereumBalance()
330      */
331     function totalEthereumBalance()
332         public
333         view
334         returns(uint)
335     {
336         return this.balance;
337     }
338 
339     /**
340      * Retrieve the total token supply.
341      */
342     function totalSupply()
343         public
344         view
345         returns(uint256)
346     {
347         return tokenSupply_;
348     }
349 
350     /**
351      * Retrieve the tokens owned by the caller.
352      */
353     function myTokens()
354         public
355         view
356         returns(uint256)
357     {
358         address _customerAddress = msg.sender;
359         return balanceOf(_customerAddress);
360     }
361 
362     /**
363      * Retrieve the dividends owned by the caller.
364      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
365      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
366      * But in the internal calculations, we want them separate. 
367      */ 
368     function myDividends(bool _includeReferralBonus) 
369         public 
370         view 
371         returns(uint256)
372     {
373         address _customerAddress = msg.sender;
374         return _includeReferralBonus ?dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
375     }
376 
377     /**
378      * Retrieve the token balance of any single address.
379      */
380     function balanceOf(address _customerAddress)
381         view
382         public
383         returns(uint256)
384     {
385         return tokenBalanceLedger_[_customerAddress];
386     }
387 
388     /**
389      * Retrieve the dividend balance of any single address.
390      */
391     function dividendsOf(address _customerAddress)
392         view
393         public
394         returns(uint256)
395     {
396         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
397     }
398 
399     /**
400      * Return the buy price of 1 individual token.
401      */
402     function sellPrice() 
403         public 
404         view 
405         returns(uint256)
406         {
407         // our calculation relies on the token supply, so we need supply. Doh.
408         if(tokenSupply_ == 0)
409         {
410             return tokenPriceInitial_ - tokenPriceIncremental_;
411         }
412         else
413         {
414             uint256 _ethereum = tokensToEthereum_(1e18);
415             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
416             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
417             return _taxedEthereum;
418         }
419         }
420 
421     /**
422      * Return the sell price of 1 individual token.
423      */
424     function buyPrice() 
425         public 
426         view 
427         returns(uint256)
428     {
429         // our calculation relies on the token supply, so we need supply. Doh.
430         if(tokenSupply_ == 0){
431             return tokenPriceInitial_ + tokenPriceIncremental_;
432         } else {
433             uint256 _ethereum = tokensToEthereum_(1e18);
434             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
435             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
436             return _taxedEthereum;
437         }
438     }
439 
440     /**
441      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
442      */
443     function calculateTokensReceived(uint256 _ethereumToSpend) 
444         public 
445         view 
446         returns(uint256)
447     {
448         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
449         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
450         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
451 
452         return _amountOfTokens;
453     }
454 
455     /**
456      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
457      */
458     function calculateEthereumReceived(uint256 _tokensToSell) 
459         public 
460         view 
461         returns(uint256)
462     {
463         require(_tokensToSell <= tokenSupply_);
464         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
465         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
466         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
467         return _taxedEthereum;
468     }
469 
470 
471     /*==========================================
472     =            INTERNAL FUNCTIONS            =
473     ==========================================*/
474     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
475         antiEarlyWhale(_incomingEthereum)
476         internal
477         returns(uint256)
478     {
479         // data setup
480         address _customerAddress = msg.sender;
481         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
482         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
483         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
484         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
485         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
486         uint256 _fee = _dividends * magnitude;
487 
488         // no point in continuing execution if OP is a poorfagrussian hacker
489         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
490         // (or hackers)
491         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
492         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
493 
494         // is the user referred by a masternode?
495         if(
496             // is this a referred purchase?
497             _referredBy != 0x0000000000000000000000000000000000000000 &&
498 
499             // no cheating!
500             _referredBy != _customerAddress&&
501 
502             // does the referrer have at least X whole tokens?
503             // i.e is the referrer a godly chad masternode
504             tokenBalanceLedger_[_referredBy] >= stakingRequirement
505         ){
506             // wealth redistribution
507             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
508         } else {
509             // no ref purchase
510             // add the referral bonus back to the global dividends cake
511             _dividends = SafeMath.add(_dividends, _referralBonus);
512             _fee = _dividends * magnitude;
513         }
514 
515         // we can't give people infinite ethereum
516         if(tokenSupply_ > 0){
517 
518             // add tokens to the pool
519             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
520 
521             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
522             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
523 
524             // calculate the amount of tokens the customer receives over his purchase 
525             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
526 
527         } else {
528             // add tokens to the pool
529             tokenSupply_ = _amountOfTokens;
530         }
531 
532         // update circulating supply & the ledger address for the customer
533         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
534 
535         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
536         //really i know you think you do but you don't
537         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
538         payoutsTo_[_customerAddress] += _updatedPayouts;
539 
540         // fire event
541         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
542 
543         return _amountOfTokens;
544     }
545 
546     /**
547      * Calculate Token price based on an amount of incoming ethereum
548      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
549      */
550     function ethereumToTokens_(uint256 _ethereum)
551         internal
552         view
553         returns(uint256)
554     {
555         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
556         uint256 _tokensReceived = 
557         (
558             (
559                 // underflow attempts BTFO
560                 SafeMath.sub(
561                     (sqrt
562                         (
563                             (_tokenPriceInitial**2)
564                             +
565                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
566                             +
567                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
568                             +
569                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
570                         )
571                     ), _tokenPriceInitial
572                 )
573             )/(tokenPriceIncremental_)
574         )-(tokenSupply_)
575         ;
576 
577         return _tokensReceived;
578     }
579 
580     /**
581      * Calculate token sell value.
582      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
583      */
584     function tokensToEthereum_(uint256 _tokens)
585         internal
586         view
587         returns(uint256)
588     {
589 
590         uint256 tokens_ = (_tokens + 1e18);
591         uint256 _tokenSupply = (tokenSupply_ + 1e18);
592         uint256 _etherReceived = 
593         (
594             // underflow attempts BTFO
595             SafeMath.sub(
596                 (
597                     (
598                         (
599                         tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply/1e18))
600                                                 )-tokenPriceIncremental_
601                     )*(tokens_ - 1e18)
602                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
603             )
604         /1e18);
605         return _etherReceived;
606     }
607 
608     function sqrt(uint x) internal pure returns (uint y) {
609         uint z = (x + 1) / 2;
610         y = x;
611         while (z < y) {
612             y = z;
613             z = (x / z + z) / 2;
614         }
615     }
616 }
617 
618 /**
619  * @title SafeMath
620  * @dev Math operations with safety checks that throw on error
621  */
622 library SafeMath {
623 
624     /**
625     * @dev Multiplies two numbers, throws on overflow.
626     */
627     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
628         if (a == 0) {
629             return 0;
630         }
631         uint256 c = a * b;
632         assert(c / a == b);
633         return c;
634     }
635 
636     /**
637     * @dev Integer division of two numbers, truncating the quotient.
638     */
639     function div(uint256 a, uint256 b) internal pure returns (uint256) {
640         // assert(b > 0); // Solidity automatically throws when dividing by 0
641         uint256 c = a / b;
642         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
643         return c;
644     }
645 
646     /**
647     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
648     */
649     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
650         assert(b <= a);
651         return a - b;
652     }
653 
654     /**
655     * @dev Adds two numbers, throws on overflow.
656     */
657     function add(uint256 a, uint256 b) internal pure returns (uint256) {
658         uint256 c = a + b;
659         assert(c >= a);
660         return c;
661     }
662 }