1 pragma solidity ^0.4.20;
2 
3 /*
4   _____   ____   _____  _____ 
5  |  __ \ / __ \ / ____|/ ____|
6  | |__) | |  | | (___ | |     
7  |  ___/| |  | |\___ \| |     
8  | |    | |__| |____) | |____ 
9  |_|     \____/|_____/ \_____|
10 
11                   ,.
12                  (\(\)
13  ,_              ;  o >
14   {`-.          /  (_)
15   `={\`-._____/`   |
16    `-{ /    -=`\   |
17     `={  -= = _/   /
18        `\  .-'   /`
19         {`-,__.'===,_
20         //`        `\\
21        //
22       `\=
23 
24 [x] No Price increase/decrease => No Pump & Dump
25 [x] Dividends : 20% for Buy and Sell
26 [X] Masternode/Referral Dividends : 6,6%
27 
28 */
29 
30 contract POSC {
31     /*=================================
32     =            MODIFIERS            =
33     =================================*/
34     // only people with tokens
35     modifier onlyBagholders() {
36         require(myTokens() > 0);
37         _;
38     }
39     
40     // only people with profits
41     modifier onlyStronghands() {
42         require(myDividends(true) > 0);
43         _;
44     }
45     
46     // administrators can:
47     // -> change the name of the contract
48     // -> change the name of the token
49     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
50     // they CANNOT:
51     // -> take funds
52     // -> disable withdrawals
53     // -> kill the contract
54     // -> change the price of tokens
55     modifier onlyAdministrator(){
56         address _customerAddress = msg.sender;
57         require(msg.sender == owner);
58         _;
59     }
60     
61     
62     // ensures that the first tokens in the contract will be equally distributed
63     // meaning, no divine dump will be ever possible
64     // result: healthy longevity.
65     modifier antiEarlyWhale(uint256 _amountOfEthereum){
66         address _customerAddress = msg.sender;
67         
68         // are we still in the vulnerable phase?
69         // if so, enact anti early whale protocol 
70         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
71             require(
72                 // is the customer in the ambassador list?
73                 ambassadors_[_customerAddress] == true &&
74                 
75                 // does the customer purchase exceed the max ambassador quota?
76                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
77                 
78             );
79             
80             // updated the accumulated quota    
81             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
82         
83             // execute
84             _;
85         } else {
86             // in case the ether count drops low, the ambassador phase won't reinitiate
87             onlyAmbassadors = false;
88             _;    
89         }
90         
91     }
92     
93     
94     /*==============================
95     =            EVENTS            =
96     ==============================*/
97     event onTokenPurchase(
98         address indexed customerAddress,
99         uint256 incomingEthereum,
100         uint256 tokensMinted,
101         address indexed referredBy
102     );
103     
104     event onTokenSell(
105         address indexed customerAddress,
106         uint256 tokensBurned,
107         uint256 ethereumEarned
108     );
109     
110     event onReinvestment(
111         address indexed customerAddress,
112         uint256 ethereumReinvested,
113         uint256 tokensMinted
114     );
115     
116     event onWithdraw(
117         address indexed customerAddress,
118         uint256 ethereumWithdrawn
119     );
120     
121     // ERC20
122     event Transfer(
123         address indexed from,
124         address indexed to,
125         uint256 tokens
126     );
127     
128     
129     /*=====================================
130     =            CONFIGURABLES            =
131     =====================================*/
132     address public owner;
133     string public name = "POSC";
134     string public symbol = "PSC";
135     uint8  public decimals = 18;
136     uint8 constant internal dividendFee_ = 5;
137     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
138     // We need no increment. The price is stable
139     uint256 constant internal magnitude = 2**64;
140     
141     // proof of stake (defaults at 100 tokens)
142     uint256 public stakingRequirement = 100e18;
143     
144     // ambassador program
145     mapping(address => bool) internal ambassadors_;
146     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
147     uint256 constant internal ambassadorQuota_ = 20 ether;
148     
149     
150     
151    /*================================
152     =            DATASETS            =
153     ================================*/
154     // amount of shares for each address (scaled number)
155     mapping(address => uint256) internal tokenBalanceLedger_;
156     mapping(address => uint256) internal referralBalance_;
157     mapping(address => int256) internal payoutsTo_;
158     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
159     uint256 internal tokenSupply_ = 0;
160     uint256 internal profitPerShare_;
161     
162     // administrator list (see above on what they can do)
163     mapping(bytes32 => bool) public administrators;
164     
165     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
166     bool public onlyAmbassadors = true;
167     
168 
169 
170     /*=======================================
171     =            PUBLIC FUNCTIONS            =
172     =======================================*/
173     /*
174     * -- APPLICATION ENTRY POINTS --  
175     */
176     function POSC()
177         public
178     {
179         // add administrators here
180         owner = msg.sender;
181         name = "POSC";
182         symbol = "PSC";
183         decimals = 18;
184 
185         ambassadors_[0x4D802cC9ca75ccd72d1Ba4fA3624994a6C380A04] = true;
186     }
187     
188      
189     /**
190      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
191      */
192     function buy(address _referredBy)
193         public
194         payable
195         returns(uint256)
196     {
197         purchaseTokens(msg.value, _referredBy);
198     }
199     
200     /**
201      * Fallback function to handle ethereum that was send straight to the contract
202      * Unfortunately we cannot use a referral address this way.
203      */
204     function()
205         payable
206         public
207     {
208         purchaseTokens(msg.value, 0x0);
209     }
210     
211     /**
212      * Converts all of caller's dividends to tokens.
213     */
214     function reinvest()
215         onlyStronghands()
216         public
217     {
218         // fetch dividends
219         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
220         
221         // pay out the dividends virtually
222         address _customerAddress = msg.sender;
223         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
224         
225         // retrieve ref. bonus
226         _dividends += referralBalance_[_customerAddress];
227         referralBalance_[_customerAddress] = 0;
228         
229         // dispatch a buy order with the virtualized "withdrawn dividends"
230         uint256 _tokens = purchaseTokens(_dividends, 0x0);
231         
232         // fire event
233         onReinvestment(_customerAddress, _dividends, _tokens);
234     }
235     
236     /**
237      * Alias of sell() and withdraw().
238      */
239     function exit()
240         public
241     {
242         // get token count for caller & sell them all
243         address _customerAddress = msg.sender;
244         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
245         if(_tokens > 0) sell(_tokens);
246         
247         // lambo delivery service
248         withdraw();
249     }
250 
251     /**
252      * Withdraws all of the callers earnings.
253      */
254     function withdraw()
255         onlyStronghands()
256         public
257     {
258         // setup data
259         address _customerAddress = msg.sender;
260         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
261         
262         // update dividend tracker
263         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
264         
265         // add ref. bonus
266         _dividends += referralBalance_[_customerAddress];
267         referralBalance_[_customerAddress] = 0;
268         
269         // lambo delivery service
270         _customerAddress.transfer(_dividends);
271         
272         // fire event
273         onWithdraw(_customerAddress, _dividends);
274     }
275     
276     /**
277      * Liquifies tokens to ethereum.
278      */
279     function sell(uint256 _amountOfTokens)
280         onlyBagholders()
281         public
282     {
283         // setup data
284         address _customerAddress = msg.sender;
285         // russian hackers BTFO
286         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
287         uint256 _tokens = _amountOfTokens;
288         uint256 _ethereum = tokensToEthereum_(_tokens);
289         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
290         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
291         
292         // burn the sold tokens
293         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
294         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
295         
296         // update dividends tracker
297         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
298         payoutsTo_[_customerAddress] -= _updatedPayouts;       
299         
300         // dividing by zero is a bad idea
301         if (tokenSupply_ > 0) {
302             // update the amount of dividends per token
303             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
304         }
305         
306         // fire event
307         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
308     }
309     
310     
311     /**
312      * Transfer tokens from the caller to a new holder.
313      * Remember, there's a 10% fee here as well.
314      */
315     function transfer(address _toAddress, uint256 _amountOfTokens)
316         onlyBagholders()
317         public
318         returns(bool)
319     {
320         // setup
321         address _customerAddress = msg.sender;
322         
323         // make sure we have the requested tokens
324         // also disables transfers until ambassador phase is over
325         // ( we dont want whale premines )
326         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
327         
328         // withdraw all outstanding dividends first
329         if(myDividends(true) > 0) withdraw();
330         
331         // liquify 10% of the tokens that are transfered
332         // these are dispersed to shareholders
333         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
334         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
335         uint256 _dividends = tokensToEthereum_(_tokenFee);
336   
337         // burn the fee tokens
338         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
339 
340         // exchange tokens
341         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
342         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
343         
344         // update dividend trackers
345         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
346         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
347         
348         // disperse dividends among holders
349         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
350         
351         // fire event
352         Transfer(_customerAddress, _toAddress, _taxedTokens);
353         
354         // ERC20
355         return true;
356        
357     }
358     
359     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
360     /**
361      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
362      */
363     function disableInitialStage()
364         onlyAdministrator()
365         public
366     {
367         onlyAmbassadors = false;
368     }
369     
370     /**
371      * In case one of us dies, we need to replace ourselves.
372      */
373     function setAdministrator(address newowner)
374         onlyAdministrator()
375         public
376     {
377         owner = newowner;
378     }
379     
380     /**
381      * Precautionary measures in case we need to adjust the masternode rate.
382      */
383     function setStakingRequirement(uint256 _amountOfTokens)
384         onlyAdministrator()
385         public
386     {
387         stakingRequirement = _amountOfTokens;
388     }
389     
390     /**
391      * If we want to rebrand, we can.
392      */
393     function setName(string _name)
394         onlyAdministrator()
395         public
396     {
397         name = _name;
398     }
399     
400     /**
401      * If we want to rebrand, we can.
402      */
403     function setSymbol(string _symbol)
404         onlyAdministrator()
405         public
406     {
407         symbol = _symbol;
408     }
409 
410     
411     /*----------  HELPERS AND CALCULATORS  ----------*/
412     /**
413      * Method to view the current Ethereum stored in the contract
414      * Example: totalEthereumBalance()
415      */
416     function totalEthereumBalance()
417         public
418         view
419         returns(uint)
420     {
421         return this.balance;
422     }
423     
424     /**
425      * Retrieve the total token supply.
426      */
427     function totalSupply()
428         public
429         view
430         returns(uint256)
431     {
432         return tokenSupply_;
433     }
434     
435     /**
436      * Retrieve the tokens owned by the caller.
437      */
438     function myTokens()
439         public
440         view
441         returns(uint256)
442     {
443         address _customerAddress = msg.sender;
444         return balanceOf(_customerAddress);
445     }
446     
447     /**
448      * Retrieve the dividends owned by the caller.
449      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
450      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
451      * But in the internal calculations, we want them separate. 
452      */ 
453     function myDividends(bool _includeReferralBonus) 
454         public 
455         view 
456         returns(uint256)
457     {
458         address _customerAddress = msg.sender;
459         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
460     }
461     
462     /**
463      * Retrieve the token balance of any single address.
464      */
465     function balanceOf(address _customerAddress)
466         view
467         public
468         returns(uint256)
469     {
470         return tokenBalanceLedger_[_customerAddress];
471     }
472     
473     /**
474      * Retrieve the dividend balance of any single address.
475      */
476     function dividendsOf(address _customerAddress)
477         view
478         public
479         returns(uint256)
480     {
481         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
482     }
483     
484     /**
485      * Return the buy price of 1 individual token.
486      */
487     function sellPrice() 
488         public 
489         view 
490         returns(string)
491     {
492             return "0.001";
493     }
494     
495     /**
496      * Return the sell price of 1 individual token.
497      */
498     function buyPrice() 
499         public 
500         view 
501         returns(string)
502     {
503         return "0.001";
504     }
505     
506     /**
507      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
508      */
509     function calculateTokensReceived(uint256 _ethereumToSpend) 
510         public 
511         view 
512         returns(uint256)
513     {
514         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
515         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
516         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
517         
518         return _amountOfTokens;
519     }
520     
521     /**
522      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
523      */
524     function calculateEthereumReceived(uint256 _tokensToSell) 
525         public 
526         view 
527         returns(uint256)
528     {
529         require(_tokensToSell <= tokenSupply_);
530         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
531         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
532         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
533         return _taxedEthereum;
534     }
535     
536     
537     /*==========================================
538     =            INTERNAL FUNCTIONS            =
539     ==========================================*/
540     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
541         antiEarlyWhale(_incomingEthereum)
542         internal
543         returns(uint256)
544     {
545         // data setup
546         address _customerAddress = msg.sender;
547         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
548         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
549         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
550         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
551         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
552         uint256 _fee = _dividends * magnitude;
553  
554         // no point in continuing execution if OP is a poorfag russian hacker
555         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
556         // (or hackers)
557         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
558         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
559         
560         // is the user referred by a masternode?
561         if(
562             // is this a referred purchase?
563             _referredBy != 0x0000000000000000000000000000000000000000 &&
564 
565             // no cheating!
566             _referredBy != _customerAddress &&
567             
568             // does the referrer have at least X whole tokens?
569             // i.e is the referrer a godly chad masternode
570             tokenBalanceLedger_[_referredBy] >= stakingRequirement
571         ){
572             // wealth redistribution
573             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
574         } else {
575             // no ref purchase
576             // add the referral bonus back to the global dividends cake
577             _dividends = SafeMath.add(_dividends, _referralBonus);
578             _fee = _dividends * magnitude;
579         }
580         
581         // we can't give people infinite ethereum
582         if(tokenSupply_ > 0){
583             
584             // add tokens to the pool
585             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
586  
587             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
588             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
589             
590             // calculate the amount of tokens the customer receives over his purchase 
591             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
592         
593         } else {
594             // add tokens to the pool
595             tokenSupply_ = _amountOfTokens;
596         }
597         
598         // update circulating supply & the ledger address for the customer
599         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
600         
601         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
602         //really i know you think you do but you don't
603         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
604         payoutsTo_[_customerAddress] += _updatedPayouts;
605         
606         // fire event
607         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
608         
609         return _amountOfTokens;
610     }
611 
612     /**
613      * Calculate Token price based on an amount of incoming ethereum
614      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
615      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
616      */
617     function ethereumToTokens_(uint256 _ethereum)
618         internal
619         view
620         returns(uint256)
621     {
622         return (_ethereum * 1000);
623     }
624     
625     /**
626      * Calculate token sell value.
627      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
628      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
629      */
630      function tokensToEthereum_(uint256 _tokens)
631         internal
632         view
633         returns(uint256)
634     {
635         return (_tokens / 1000);
636     }
637 }
638 
639 /**
640  * @title SafeMath
641  * @dev Math operations with safety checks that throw on error
642  */
643 library SafeMath {
644 
645     /**
646     * @dev Multiplies two numbers, throws on overflow.
647     */
648     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
649         if (a == 0) {
650             return 0;
651         }
652         uint256 c = a * b;
653         assert(c / a == b);
654         return c;
655     }
656 
657     /**
658     * @dev Integer division of two numbers, truncating the quotient.
659     */
660     function div(uint256 a, uint256 b) internal pure returns (uint256) {
661         // assert(b > 0); // Solidity automatically throws when dividing by 0
662         uint256 c = a / b;
663         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
664         return c;
665     }
666 
667     /**
668     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
669     */
670     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
671         assert(b <= a);
672         return a - b;
673     }
674 
675     /**
676     * @dev Adds two numbers, throws on overflow.
677     */
678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
679         uint256 c = a + b;
680         assert(c >= a);
681         return c;
682     }
683 }