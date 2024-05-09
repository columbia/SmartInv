1 pragma solidity ^0.4.20;
2 
3 
4 
5 contract EthereumStaking {
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9     // only people with tokens
10     modifier onlybelievers () {
11         require(myTokens() > 0);
12         _;
13     }
14     
15     // only people with profits
16     modifier onlyhodler() {
17         require(myDividends(true) > 0);
18         _;
19     }
20     
21     // administrators can:
22     // -> change the name of the contract
23     // -> change the name of the token
24     // -> change the PoS difficulty 
25     // they CANNOT:
26     // -> take funds
27     // -> disable withdrawals
28     // -> kill the contract
29     // -> change the price of tokens
30     modifier onlyAdministrator(){
31         address _customerAddress = msg.sender;
32         require(administrators[keccak256(_customerAddress)]);
33         _;
34     }
35     
36     
37     modifier antiEarlyWhale(uint256 _amountOfEthereum){
38         address _customerAddress = msg.sender;
39         
40       
41         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
42             require(
43                 // is the customer in the ambassador list?
44                 ambassadors_[_customerAddress] == true &&
45                 
46                 // does the customer purchase exceed the max ambassador quota?
47                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
48                 
49             );
50             
51             // updated the accumulated quota    
52             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
53         
54             // execute
55             _;
56         } else {
57             // in case the ether count drops low, the ambassador phase won't reinitiate
58             onlyAmbassadors = false;
59             _;    
60         }
61         
62     }
63     
64     
65     /*==============================
66     =            EVENTS            =
67     ==============================*/
68     event onTokenPurchase(
69         address indexed customerAddress,
70         uint256 incomingEthereum,
71         uint256 tokensMinted,
72         address indexed referredBy
73     );
74     
75     event onTokenSell(
76         address indexed customerAddress,
77         uint256 tokensBurned,
78         uint256 ethereumEarned
79     );
80     
81     event onReinvestment(
82         address indexed customerAddress,
83         uint256 ethereumReinvested,
84         uint256 tokensMinted
85     );
86     
87     event onWithdraw(
88         address indexed customerAddress,
89         uint256 ethereumWithdrawn
90     );
91     
92     // ERC20
93     event Transfer(
94         address indexed from,
95         address indexed to,
96         uint256 tokens
97     );
98     
99     
100     /*=====================================
101     =            CONFIGURABLES            =
102     =====================================*/
103     string public name = "EthereumStaking";
104     string public symbol = "EST";
105     uint8 constant public decimals = 18;
106     uint8 constant internal dividendFee_ = 10;
107     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
108     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
109     uint256 constant internal magnitude = 2**64;
110     
111     // proof of stake (defaults at 1 token)
112     uint256 public stakingRequirement = 1e18;
113     
114     // ambassador program
115     mapping(address => bool) internal ambassadors_;
116     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
117     uint256 constant internal ambassadorQuota_ = 1 ether;
118     
119     
120     
121    /*================================
122     =            DATASETS            =
123     ================================*/
124     // amount of shares for each address (scaled number)
125     mapping(address => uint256) internal tokenBalanceLedger_;
126     mapping(address => uint256) internal referralBalance_;
127     mapping(address => int256) internal payoutsTo_;
128     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
129     uint256 internal tokenSupply_ = 0;
130     uint256 internal profitPerShare_;
131     
132     // administrator list (see above on what they can do)
133     mapping(bytes32 => bool) public administrators;
134     
135     
136     bool public onlyAmbassadors = false;
137     
138 
139 
140     /*=======================================
141     =            PUBLIC FUNCTIONS            =
142     =======================================*/
143     /*
144     * -- APPLICATION ENTRY POINTS --  
145     */
146     function EthereumStaking()
147         public
148      {
149         // add administrators here
150         administrators[keccak256(0xbCa688e17875fe7D239806B5C11088f19bE34783)] = true;
151 						 
152    
153         ambassadors_[0x0000000000000000000000000000000000000000] = true;
154                        
155     }
156     
157      
158     /**
159      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
160      */
161     function buy(address _referredBy)
162         public
163         payable
164         returns(uint256)
165     {
166         purchaseTokens(msg.value, _referredBy);
167     }
168     
169     
170     function()
171         payable
172         public
173     {
174         purchaseTokens(msg.value, 0x0);
175     }
176     
177     /**
178      * Converts all of caller's dividends to tokens.
179      */
180     function reinvest()
181         onlyhodler()
182         public
183     {
184         // fetch dividends
185         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
186         
187         // pay out the dividends virtually
188         address _customerAddress = msg.sender;
189         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
190         
191         // retrieve ref. bonus
192         _dividends += referralBalance_[_customerAddress];
193         referralBalance_[_customerAddress] = 0;
194         
195         // dispatch a buy order with the virtualized "withdrawn dividends"
196         uint256 _tokens = purchaseTokens(_dividends, 0x0);
197         
198         // fire event
199         onReinvestment(_customerAddress, _dividends, _tokens);
200     }
201     
202     /**
203      * Alias of sell() and withdraw().
204      */
205     function exit()
206         public
207     {
208         // get token count for caller & sell them all
209         address _customerAddress = msg.sender;
210         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
211         if(_tokens > 0) sell(_tokens);
212         
213         
214         withdraw();
215     }
216 
217     /**
218      * Withdraws all of the callers earnings.
219      */
220     function withdraw()
221         onlyhodler()
222         public
223     {
224         // setup data
225         address _customerAddress = msg.sender;
226         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
227         
228         // update dividend tracker
229         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
230         
231         // add ref. bonus
232         _dividends += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress] = 0;
234         
235         // delivery service
236         _customerAddress.transfer(_dividends);
237         
238         // fire event
239         onWithdraw(_customerAddress, _dividends);
240     }
241     
242     /**
243      * Liquifies tokens to ethereum.
244      */
245     function sell(uint256 _amountOfTokens)
246         onlybelievers ()
247         public
248     {
249       
250         address _customerAddress = msg.sender;
251        
252         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
253         uint256 _tokens = _amountOfTokens;
254         uint256 _ethereum = tokensToEthereum_(_tokens);
255         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
256         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
257         
258         // burn the sold tokens
259         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
260         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
261         
262         // update dividends tracker
263         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
264         payoutsTo_[_customerAddress] -= _updatedPayouts;       
265         
266         // dividing by zero is a bad idea
267         if (tokenSupply_ > 0) {
268             // update the amount of dividends per token
269             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
270         }
271         
272         // fire event
273         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
274     }
275     
276     
277     /**
278      * Transfer tokens from the caller to a new holder.
279      * Remember, there's a 10% fee here as well.
280      */
281     function transfer(address _toAddress, uint256 _amountOfTokens)
282         onlybelievers ()
283         public
284         returns(bool)
285     {
286         // setup
287         address _customerAddress = msg.sender;
288         
289         // make sure we have the requested tokens
290      
291         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292         
293         // withdraw all outstanding dividends first
294         if(myDividends(true) > 0) withdraw();
295         
296         // liquify 10% of the tokens that are transfered
297         // these are dispersed to shareholders
298         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
299         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
300         uint256 _dividends = tokensToEthereum_(_tokenFee);
301   
302         // burn the fee tokens
303         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
304 
305         // exchange tokens
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
307         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
308         
309         // update dividend trackers
310         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
311         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
312         
313         // disperse dividends among holders
314         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
315         
316         // fire event
317         Transfer(_customerAddress, _toAddress, _taxedTokens);
318         
319         // ERC20
320         return true;
321        
322     }
323     
324     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
325     /**
326      * administrator can manually disable the ambassador phase.
327      */
328     function disableInitialStage()
329         onlyAdministrator()
330         public
331     {
332         onlyAmbassadors = false;
333     }
334     
335    
336     function setAdministrator(bytes32 _identifier, bool _status)
337         onlyAdministrator()
338         public
339     {
340         administrators[_identifier] = _status;
341     }
342     
343    
344     function setStakingRequirement(uint256 _amountOfTokens)
345         onlyAdministrator()
346         public
347     {
348         stakingRequirement = _amountOfTokens;
349     }
350     
351     
352     function setName(string _name)
353         onlyAdministrator()
354         public
355     {
356         name = _name;
357     }
358     
359    
360     function setSymbol(string _symbol)
361         onlyAdministrator()
362         public
363     {
364         symbol = _symbol;
365     }
366 
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
406        */ 
407     function myDividends(bool _includeReferralBonus) 
408         public 
409         view 
410         returns(uint256)
411     {
412         address _customerAddress = msg.sender;
413         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
414     }
415     
416     /**
417      * Retrieve the token balance of any single address.
418      */
419     function balanceOf(address _customerAddress)
420         view
421         public
422         returns(uint256)
423     {
424         return tokenBalanceLedger_[_customerAddress];
425     }
426     
427     /**
428      * Retrieve the dividend balance of any single address.
429      */
430     function dividendsOf(address _customerAddress)
431         view
432         public
433         returns(uint256)
434     {
435         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
436     }
437     
438     /**
439      * Return the buy price of 1 individual token.
440      */
441     function sellPrice() 
442         public 
443         view 
444         returns(uint256)
445     {
446        
447         if(tokenSupply_ == 0){
448             return tokenPriceInitial_ - tokenPriceIncremental_;
449         } else {
450             uint256 _ethereum = tokensToEthereum_(1e18);
451             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
452             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
453             return _taxedEthereum;
454         }
455     }
456     
457     /**
458      * Return the sell price of 1 individual token.
459      */
460     function buyPrice() 
461         public 
462         view 
463         returns(uint256)
464     {
465         
466         if(tokenSupply_ == 0){
467             return tokenPriceInitial_ + tokenPriceIncremental_;
468         } else {
469             uint256 _ethereum = tokensToEthereum_(1e18);
470             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
471             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
472             return _taxedEthereum;
473         }
474     }
475     
476    
477     function calculateTokensReceived(uint256 _ethereumToSpend) 
478         public 
479         view 
480         returns(uint256)
481     {
482         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
483         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
484         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
485         
486         return _amountOfTokens;
487     }
488     
489    
490     function calculateEthereumReceived(uint256 _tokensToSell) 
491         public 
492         view 
493         returns(uint256)
494     {
495         require(_tokensToSell <= tokenSupply_);
496         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
497         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
498         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
499         return _taxedEthereum;
500     }
501     
502     
503     /*==========================================
504     =            INTERNAL FUNCTIONS            =
505     ==========================================*/
506     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
507         antiEarlyWhale(_incomingEthereum)
508         internal
509         returns(uint256)
510     {
511         // data setup
512         address _customerAddress = msg.sender;
513         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
514         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
515         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
516         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
517         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
518         uint256 _fee = _dividends * magnitude;
519  
520       
521         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
522         
523         // is the user referred by a karmalink?
524         if(
525             // is this a referred purchase?
526             _referredBy != 0x0000000000000000000000000000000000000000 &&
527 
528             // no cheating!
529             _referredBy != _customerAddress &&
530             
531         
532             tokenBalanceLedger_[_referredBy] >= stakingRequirement
533         ){
534             // wealth redistribution
535             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
536         } else {
537             // no ref purchase
538             // add the referral bonus back to the global dividends cake
539             _dividends = SafeMath.add(_dividends, _referralBonus);
540             _fee = _dividends * magnitude;
541         }
542         
543         // we can't give people infinite ethereum
544         if(tokenSupply_ > 0){
545             
546             // add tokens to the pool
547             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
548  
549             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
550             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
551             
552             // calculate the amount of tokens the customer receives over his purchase 
553             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
554         
555         } else {
556             // add tokens to the pool
557             tokenSupply_ = _amountOfTokens;
558         }
559         
560         // update circulating supply & the ledger address for the customer
561         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
562         
563         
564         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
565         payoutsTo_[_customerAddress] += _updatedPayouts;
566         
567         // fire event
568         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
569         
570         return _amountOfTokens;
571     }
572 
573     /**
574      * Calculate Token price based on an amount of incoming ethereum
575      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
576      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
577      */
578     function ethereumToTokens_(uint256 _ethereum)
579         internal
580         view
581         returns(uint256)
582     {
583         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
584         uint256 _tokensReceived = 
585          (
586             (
587                 // underflow attempts BTFO
588                 SafeMath.sub(
589                     (sqrt
590                         (
591                             (_tokenPriceInitial**2)
592                             +
593                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
594                             +
595                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
596                             +
597                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
598                         )
599                     ), _tokenPriceInitial
600                 )
601             )/(tokenPriceIncremental_)
602         )-(tokenSupply_)
603         ;
604   
605         return _tokensReceived;
606     }
607     
608     /**
609      * Calculate token sell value.
610           */
611      function tokensToEthereum_(uint256 _tokens)
612         internal
613         view
614         returns(uint256)
615     {
616 
617         uint256 tokens_ = (_tokens + 1e18);
618         uint256 _tokenSupply = (tokenSupply_ + 1e18);
619         uint256 _etherReceived =
620         (
621             // underflow attempts BTFO
622             SafeMath.sub(
623                 (
624                     (
625                         (
626                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
627                         )-tokenPriceIncremental_
628                     )*(tokens_ - 1e18)
629                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
630             )
631         /1e18);
632         return _etherReceived;
633     }
634     
635     
636     
637     function sqrt(uint x) internal pure returns (uint y) {
638         uint z = (x + 1) / 2;
639         y = x;
640         while (z < y) {
641             y = z;
642             z = (x / z + z) / 2;
643         }
644     }
645 }
646 
647 /**
648  * @title SafeMath
649  * @dev Math operations with safety checks that throw on error
650  */
651 library SafeMath {
652 
653    
654     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
655         if (a == 0) {
656             return 0;
657         }
658         uint256 c = a * b;
659         assert(c / a == b);
660         return c;
661     }
662 
663    
664     function div(uint256 a, uint256 b) internal pure returns (uint256) {
665         // assert(b > 0); // Solidity automatically throws when dividing by 0
666         uint256 c = a / b;
667         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
668         return c;
669     }
670 
671     
672     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
673         assert(b <= a);
674         return a - b;
675     }
676 
677    
678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
679         uint256 c = a + b;
680         assert(c >= a);
681         return c;
682     }
683 
684 /**
685 * EFT.
686 */
687     
688 }