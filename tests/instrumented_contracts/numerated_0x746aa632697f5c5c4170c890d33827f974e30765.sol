1 pragma solidity ^0.4.19;
2 
3 /**
4 * Please don't be stupid enough to put anything in here.
5 
6 * This is a testament to greed and herd stupidity.
7 
8 * I will likely take any money you put in here and either donate it to Giveth or into the EthPhoenix marketing wallet.
9 
10 * The point I'm making here is that this is not hard to do. It is not tricky, it does not require hype or a lead-in of a week announcement.
11 
12 * If you put your Ether in here you deserve everything that's coming to you.
13 * See you on the moon, as proof of reverse psychology.
14  
15 * /Norsefire, PhD.
16 **/
17 
18 contract CharlieCoin {
19 
20     /*=================================
21     =            MODIFIERS            =
22     =================================*/
23     // only people with tokens
24     modifier onlyBagholders() {
25         require(myTokens() > 0);
26         _;
27     }
28     
29     // only people with profits
30     modifier onlyStronghands() {
31         require(myDividends(true) > 0);
32         _;
33     }
34     
35     // administrators can:
36     // -> change the name of the contract
37     // -> change the name of the token
38     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
39     // they CANNOT:
40     // -> take funds
41     // -> disable withdrawals
42     // -> kill the contract
43     // -> change the price of tokens
44     modifier onlyAdministrator(){
45         address _customerAddress = msg.sender;
46         require(administrators[keccak256(_customerAddress)]);
47         _;
48     }    
49     
50     /*==============================
51     =            EVENTS            =
52     ==============================*/
53     event onTokenPurchase(
54         address indexed customerAddress,
55         uint256 incomingEthereum,
56         uint256 tokensMinted,
57         address indexed referredBy
58     );
59     
60     event onTokenSell(
61         address indexed customerAddress,
62         uint256 tokensBurned,
63         uint256 ethereumEarned
64     );
65     
66     event onReinvestment(
67         address indexed customerAddress,
68         uint256 ethereumReinvested,
69         uint256 tokensMinted
70     );
71     
72     event onWithdraw(
73         address indexed customerAddress,
74         uint256 ethereumWithdrawn
75     );
76     
77     // ERC20
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 tokens
82     );
83     
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );    
89     
90     /*=====================================
91     =            CONFIGURABLES            =
92     =====================================*/
93     string public name = "CharlieCoin";
94     string public symbol = "CHARLIES";
95     uint8 constant public decimals = 18;
96     uint8 constant internal dividendFee_ = 10;
97     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
98     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
99     uint256 constant internal magnitude = 2**64;
100     
101     // proof of stake (defaults at 100 tokens)
102     uint256 public stakingRequirement = 100e18;
103     
104     // ambassador program
105     mapping(address => bool) internal ambassadors_;
106     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
107     uint256 constant internal ambassadorQuota_ = 1 ether;
108     
109    /*================================
110     =            DATASETS            =
111     ================================*/
112     // amount of shares for each address (scaled number)
113     mapping(address => uint256) internal tokenBalanceLedger_;
114     mapping(address => uint256) internal referralBalance_;
115     mapping(address => int256) internal payoutsTo_;
116     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
117     uint256 internal tokenSupply_ = 0;
118     uint256 internal profitPerShare_;
119     
120     // Owner of account approves the transfer of an amount to another account
121     mapping(address => mapping (address => uint256)) allowed;
122     
123     // administrator list (see above on what they can do)
124     mapping(bytes32 => bool) public administrators;
125     
126     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
127     bool public onlyAmbassadors = false;
128     
129     /*=======================================
130     =            PUBLIC FUNCTIONS            =
131     =======================================*/
132     /*
133     * -- APPLICATION ENTRY POINTS --  
134     */
135     function CharlieCoin()
136         public
137     {  
138     
139     }
140          
141     /**
142      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
143      */
144     function buy(address _referredBy)
145         public
146         payable
147         returns(uint256)
148     {
149         purchaseTokens(msg.value, _referredBy);
150     }
151     
152     /**
153      * Fallback function to handle ethereum that was send straight to the contract
154      * Unfortunately we cannot use a referral address this way.
155      */
156     function()
157         payable
158         public
159     {
160         purchaseTokens(msg.value, 0x0);
161     }
162     
163     /**
164      * Converts all of caller's dividends to tokens.
165      */
166     function reinvest()
167         onlyStronghands()
168         public
169     {
170         // fetch dividends
171         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
172         
173         // pay out the dividends virtually
174         address _customerAddress = msg.sender;
175         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
176         
177         // retrieve ref. bonus
178         _dividends += referralBalance_[_customerAddress];
179         referralBalance_[_customerAddress] = 0;
180         
181         // dispatch a buy order with the virtualized "withdrawn dividends"
182         uint256 _tokens = purchaseTokens(_dividends, 0x0);
183         
184         // fire event
185         onReinvestment(_customerAddress, _dividends, _tokens);
186     }
187     
188     /**
189      * Alias of sell() and withdraw().
190      */
191     function exit()
192         public
193     {
194         // get token count for caller & sell them all
195         address _customerAddress = msg.sender;
196         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
197         if(_tokens > 0) sell(_tokens);
198         
199         // lambo delivery service
200         withdraw();
201     }
202 
203     /**
204      * Withdraws all of the callers earnings.
205      */
206     function withdraw()
207         onlyStronghands()
208         public
209     {
210         // setup data
211         address _customerAddress = msg.sender;
212         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
213         
214         // update dividend tracker
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216         
217         // add ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220         
221         // lambo delivery service
222         _customerAddress.transfer(_dividends);
223         
224         // fire event
225         onWithdraw(_customerAddress, _dividends);
226     }
227     
228     /**
229      * Liquifies tokens to ethereum.
230      */
231     function sell(uint256 _amountOfTokens)
232         onlyBagholders()
233         public
234     {
235         // setup data
236         address _customerAddress = msg.sender;
237         // russian hackers BTFO
238         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
239         uint256 _tokens = _amountOfTokens;
240         uint256 _ethereum = tokensToEthereum_(_tokens);
241         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
242         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
243         
244         // burn the sold tokens
245         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
246         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
247         
248         // update dividends tracker
249         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
250         payoutsTo_[_customerAddress] -= _updatedPayouts;       
251         
252         // dividing by zero is a bad idea
253         if (tokenSupply_ > 0) {
254             // update the amount of dividends per token
255             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
256         }
257         
258         // fire event
259         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
260     }
261     
262     
263     /**
264      * Transfer tokens from the caller to a new holder.
265      * NEW AND IMPROVED ZERO FEE ON TRANSFER BECAUSE FUCK EXTORTION
266      */
267     function transfer(address _toAddress, uint256 _amountOfTokens)
268         onlyBagholders()
269         public
270         returns(bool)
271     {
272         // setup
273         address _customerAddress = msg.sender;
274         
275         // make sure we have the requested tokens
276         // also disables transfers until ambassador phase is over
277         // ( we dont want whale premines )
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         
280         // withdraw all outstanding dividends first
281         if(myDividends(true) > 0) withdraw();
282         
283         // exchange tokens
284         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
285         
286         // fire event
287         transferFrom(_customerAddress, _toAddress, 0);
288         
289         // ERC20
290         return true;
291        
292     }
293     
294     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
295 
296     /**
297      * In case one of us dies, we need to replace ourselves.
298      */
299     function setAdministrator(bytes32 _identifier, bool _status)
300         onlyAdministrator()
301         public
302     {
303         administrators[_identifier] = _status;
304     }
305     
306     /**
307      * Precautionary measures in case we need to adjust the masternode rate.
308      */
309     function setStakingRequirement(uint256 _amountOfTokens)
310         onlyAdministrator()
311         public
312     {
313         stakingRequirement = _amountOfTokens;
314     }
315     
316     /**
317      * If we want to rebrand, we can.
318      */
319     function setName(string _name)
320         onlyAdministrator()
321         public
322     {
323         name = _name;
324     }
325     
326     /**
327      * If we want to rebrand, we can.
328      */
329     function setSymbol(string _symbol)
330         onlyAdministrator()
331         public
332     {
333         symbol = _symbol;
334     }
335 
336     
337     /*----------  HELPERS AND CALCULATORS  ----------*/
338     /**
339      * Method to view the current Ethereum stored in the contract
340      * Example: totalEthereumBalance()
341      */
342     function totalEthereumBalance()
343         public
344         view
345         returns(uint)
346     {
347         return this.balance;
348     }
349     
350     /**
351      * Retrieve the total token supply.
352      */
353     function totalSupply()
354         public
355         view
356         returns(uint256)
357     {
358         return tokenSupply_;
359     }
360     
361     /**
362      * Retrieve the tokens owned by the caller.
363      */
364     function myTokens()
365         public
366         view
367         returns(uint256)
368     {
369         address _customerAddress = msg.sender;
370         return balanceOf(_customerAddress);
371     }
372     
373     /**
374      * Retrieve the dividends owned by the caller.
375      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
376      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
377      * But in the internal calculations, we want them separate. 
378      */ 
379     function myDividends(bool _includeReferralBonus) 
380         public 
381         view 
382         returns(uint256)
383     {
384         address _customerAddress = msg.sender;
385         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
386     }
387     
388     /**
389      * Retrieve the token balance of any single address.
390      */
391     function balanceOf(address _customerAddress)
392         view
393         public
394         returns(uint256)
395     {
396         return tokenBalanceLedger_[_customerAddress];
397     }
398     
399     /**
400      * Retrieve the dividend balance of any single address.
401      */
402     function dividendsOf(address _customerAddress)
403         view
404         public
405         returns(uint256)
406     {
407         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
408     }
409     
410     /**
411      * Return the buy price of 1 individual token.
412      */
413     function sellPrice() 
414         public 
415         view 
416         returns(uint256)
417     {
418         // our calculation relies on the token supply, so we need supply. Doh.
419         if(tokenSupply_ == 0){
420             return tokenPriceInitial_ - tokenPriceIncremental_;
421         } else {
422             uint256 _ethereum = tokensToEthereum_(1e18);
423             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
424             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
425             return _taxedEthereum;
426         }
427     }
428     
429     /**
430      * Return the sell price of 1 individual token.
431      */
432     function buyPrice() 
433         public 
434         view 
435         returns(uint256)
436     {
437         // our calculation relies on the token supply, so we need supply. Doh.
438         if(tokenSupply_ == 0){
439             return tokenPriceInitial_ + tokenPriceIncremental_;
440         } else {
441             uint256 _ethereum = tokensToEthereum_(1e18);
442             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
443             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
444             return _taxedEthereum;
445         }
446     }
447     
448     /**
449      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
450      */
451     function calculateTokensReceived(uint256 _ethereumToSpend) 
452         public 
453         view 
454         returns(uint256)
455     {
456         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
457         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
458         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
459         
460         return _amountOfTokens;
461     }
462     
463     /**
464      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
465      */
466     function calculateEthereumReceived(uint256 _tokensToSell) 
467         public 
468         view 
469         returns(uint256)
470     {
471         require(_tokensToSell <= tokenSupply_);
472         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
473         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
474         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
475         return _taxedEthereum;
476     }
477     
478         
479     /*=================================
480     =            HURR-DURR            =
481     =================================*/
482     
483     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
484         // Check for approved spend
485         if (_from != msg.sender) {
486             require(_value <= allowed[_from][msg.sender]);
487             allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
488         }
489 
490         require(_to != address(0));
491         require(_value <= tokenBalanceLedger_[_from]);
492 
493         // Move the tokens across
494         tokenBalanceLedger_[_from] = tokenBalanceLedger_[_from] - _value;
495         tokenBalanceLedger_[_to] = tokenBalanceLedger_[_to] + _value;
496 
497         // Fire 20 event
498         Transfer(_from, _to, _value);
499 
500         // All's well that ends well
501         return true;
502     }
503 
504     function approve(address _spender, uint256 _value) public returns (bool) {
505         allowed[msg.sender][_spender] = _value;
506         Approval(msg.sender, _spender, _value);
507         return true;
508     }
509     
510     /*==========================================
511     =            INTERNAL FUNCTIONS            =
512     ==========================================*/
513     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
514         internal
515         returns(uint256)
516     {
517         // data setup
518         address _customerAddress = msg.sender;
519         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
520         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
521         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
522         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
523         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
524         uint256 _fee = _dividends * magnitude;
525  
526         // no point in continuing execution if OP is a poorfag russian hacker
527         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
528         // (or hackers)
529         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
530         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
531         
532         // is the user referred by a masternode?
533         if(
534             // is this a referred purchase?
535             _referredBy != 0x0000000000000000000000000000000000000000 &&
536 
537             // no cheating!
538             _referredBy != _customerAddress &&
539             
540             // does the referrer have at least X whole tokens?
541             // i.e is the referrer a godly chad masternode
542             tokenBalanceLedger_[_referredBy] >= stakingRequirement
543         ){
544             // wealth redistribution
545             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
546         } else {
547             // no ref purchase
548             // add the referral bonus back to the global dividends cake
549             _dividends = SafeMath.add(_dividends, _referralBonus);
550             _fee = _dividends * magnitude;
551         }
552         
553         // we can't give people infinite ethereum
554         if(tokenSupply_ > 0){
555             
556             // add tokens to the pool
557             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
558  
559             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
560             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
561             
562             // calculate the amount of tokens the customer receives over his purchase 
563             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
564         
565         } else {
566             // add tokens to the pool
567             tokenSupply_ = _amountOfTokens;
568         }
569         
570         // update circulating supply & the ledger address for the customer
571         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
572         
573         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
574         //really i know you think you do but you don't
575         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
576         payoutsTo_[_customerAddress] += _updatedPayouts;
577         
578         // fire event
579         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
580         
581         return _amountOfTokens;
582     }
583 
584     /**
585      * Calculate Token price based on an amount of incoming ethereum
586      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
587      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
588      */
589     function ethereumToTokens_(uint256 _ethereum)
590         internal
591         view
592         returns(uint256)
593     {
594         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
595         uint256 _tokensReceived = 
596          (
597             (
598                 // underflow attempts BTFO
599                 SafeMath.sub(
600                     (sqrt
601                         (
602                             (_tokenPriceInitial**2)
603                             +
604                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
605                             +
606                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
607                             +
608                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
609                         )
610                     ), _tokenPriceInitial
611                 )
612             )/(tokenPriceIncremental_)
613         )-(tokenSupply_)
614         ;
615   
616         return _tokensReceived;
617     }
618     
619     /**
620      * Calculate token sell value.
621      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
622      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
623      */
624      function tokensToEthereum_(uint256 _tokens)
625         internal
626         view
627         returns(uint256)
628     {
629 
630         uint256 tokens_ = (_tokens + 1e18);
631         uint256 _tokenSupply = (tokenSupply_ + 1e18);
632         uint256 _etherReceived =
633         (
634             // underflow attempts BTFO
635             SafeMath.sub(
636                 (
637                     (
638                         (
639                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
640                         )-tokenPriceIncremental_
641                     )*(tokens_ - 1e18)
642                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
643             )
644         /1e18);
645         return _etherReceived;
646     }
647     
648     
649     //This is where all your gas goes, sorry
650     //Not sorry, you probably only paid 1 gwei
651     function sqrt(uint x) internal pure returns (uint y) {
652         uint z = (x + 1) / 2;
653         y = x;
654         while (z < y) {
655             y = z;
656             z = (x / z + z) / 2;
657         }
658     }
659 }
660 
661 /**
662  * @title SafeMath
663  * @dev Math operations with safety checks that throw on error
664  */
665 library SafeMath {
666 
667     /**
668     * @dev Multiplies two numbers, throws on overflow.
669     */
670     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
671         if (a == 0) {
672             return 0;
673         }
674         uint256 c = a * b;
675         assert(c / a == b);
676         return c;
677     }
678 
679     /**
680     * @dev Integer division of two numbers, truncating the quotient.
681     */
682     function div(uint256 a, uint256 b) internal pure returns (uint256) {
683         // assert(b > 0); // Solidity automatically throws when dividing by 0
684         uint256 c = a / b;
685         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
686         return c;
687     }
688 
689     /**
690     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
691     */
692     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
693         assert(b <= a);
694         return a - b;
695     }
696 
697     /**
698     * @dev Adds two numbers, throws on overflow.
699     */
700     function add(uint256 a, uint256 b) internal pure returns (uint256) {
701         uint256 c = a + b;
702         assert(c >= a);
703         return c;
704     }
705 }