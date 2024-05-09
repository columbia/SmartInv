1 pragma solidity ^0.4.20;
2 
3 
4 contract OBOK {
5     /*=================================
6     =            MODIFIERS            =
7     =================================*/
8     // only people with tokens
9     modifier onlyTokenHolders() {
10         require(myTokens() > 0);
11         _;
12     }
13     
14     // only people with profits
15     modifier onlyBalancePositive() {
16         require(myDividends(true) > 0);
17         _;
18     }
19     
20     
21     modifier onlyOwner(){
22         require(msg.sender == owner);
23         _;
24     }
25     
26     modifier noUnAuthContracts()
27     {
28         if( authContracts_[msg.sender] == false)
29         {
30             require(msg.sender == tx.origin);
31         }
32         
33         _;
34     }
35     
36     
37     modifier antiEarlyWhale(uint256 _amountOfEthereum){
38         
39         if(ambassadors_[msg.sender] == false)
40         {
41           require(onlyAmbassadors == false); 
42         }
43         
44         _;
45         
46     }
47     
48     
49     /*==============================
50     =            EVENTS            =
51     ==============================*/
52     event onTokenPurchase(
53         address indexed customerAddress,
54         uint256 incomingEthereum,
55         uint256 tokensMinted,
56         address indexed referredBy
57     );
58     
59     event onTokenSell(
60         address indexed customerAddress,
61         uint256 tokensBurned,
62         uint256 ethereumEarned
63     );
64     
65     event onReinvestment(
66         address indexed customerAddress,
67         uint256 ethereumReinvested,
68         uint256 tokensMinted
69     );
70     
71     event onWithdraw(
72         address indexed customerAddress,
73         uint256 ethereumWithdrawn
74     );
75     
76     // ERC20
77     event Transfer(
78         address indexed from,
79         address indexed to,
80         uint256 tokens
81     );
82     
83     
84     /*=====================================
85     =            CONFIGURABLES            =
86     =====================================*/
87     string public name = "OBOK";
88     string public symbol = "OBOK";
89     uint8 constant public decimals = 18;
90     uint8 constant internal dividendFee_ = 10;
91     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
92     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
93     uint256 constant internal magnitude = 2**64;
94     
95     // referral link requirement = 5 tokens
96     uint256 public stakingRequirement = 5e18;
97     
98     // ambassador program
99     mapping(address => bool) internal ambassadors_;
100     address internal owner;
101     
102     
103    /*================================
104     =            DATASETS            =
105     ================================*/
106     // amount of shares for each address (scaled number)
107     mapping(address => uint256) internal tokenBalanceLedger_;
108     mapping(address => uint256) internal referralBalance_;
109     mapping(address => int256) internal payoutsTo_;
110     mapping(address => bool) internal authContracts_;
111     uint256 internal tokenSupply_ = 0;
112     uint256 internal profitPerShare_;
113     
114     // administrator list (see above on what they can do)
115     mapping(bytes32 => bool) public administrators;
116     
117     // when this is set to true, only ambassadors can purchase tokens
118     bool public onlyAmbassadors = true;
119     
120 
121 
122     /*=======================================
123     =            PUBLIC FUNCTIONS            =
124     =======================================*/
125     /*
126     * -- APPLICATION ENTRY POINTS --  
127     */
128     constructor()
129     public
130     {
131         owner = msg.sender;
132         
133         // add the ambassadors here. 
134         ambassadors_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //We all know who this guy is
135         ambassadors_[0x3460CAD0381b6D4c6c37F5F82633BDad109F020A] = true; //You know this guy, too
136     }
137     
138      
139     /**
140      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
141      */
142 
143     function buy(address _referredBy)
144         noUnAuthContracts()
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
157         noUnAuthContracts()
158         payable
159         public
160     {
161         purchaseTokens(msg.value, 0x0);
162     }
163 
164     /**
165      * This method serves as a way for anyone to spread some love to all tokenholders without buying tokens
166      */
167     function donateDivs()
168         payable
169         public
170     {
171         require(msg.value > 10000 wei);
172 
173         uint256 _dividends = msg.value;
174         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
175         profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
176     }    
177     /**
178      * Converts all of caller's dividends to tokens.
179      */
180     function reinvest()
181         noUnAuthContracts()
182         onlyBalancePositive()
183         public
184     {
185         // fetch dividends
186         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
187         
188         // pay out the dividends virtually
189         address _customerAddress = msg.sender;
190         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
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
207         noUnAuthContracts()
208         public
209     {
210         // get token count for caller & sell them all
211         address _customerAddress = msg.sender;
212         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
213         if(_tokens > 0) sell(_tokens);
214         
215         // lambo delivery service
216         withdraw();
217     }
218 
219     /**
220      * Withdraws all of the callers earnings.
221      */
222     function withdraw()
223         noUnAuthContracts()
224         onlyBalancePositive()
225         public
226     {
227         // setup data
228         address _customerAddress = msg.sender;
229         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
230         
231         // update dividend tracker
232         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
233         
234         // add ref. bonus
235         _dividends += referralBalance_[_customerAddress];
236         referralBalance_[_customerAddress] = 0;
237         
238         // pay customer
239         _customerAddress.transfer(_dividends);
240         
241         // fire event
242         emit onWithdraw(_customerAddress, _dividends);
243     }
244     
245     /**
246      * Liquifies tokens to ethereum.
247      */
248     function sell(uint256 _amountOfTokens)
249         noUnAuthContracts()
250         onlyTokenHolders()
251         public
252     {
253         // setup data
254         address _customerAddress = msg.sender;
255 
256         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
257         uint256 _tokens = _amountOfTokens;
258         uint256 _ethereum = tokensToEthereum_(_tokens);
259         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
260         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
261         
262         // burn the sold tokens
263         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
264         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
265         
266         // update dividends tracker
267         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
268         payoutsTo_[_customerAddress] -= _updatedPayouts;       
269         
270         // dividing by zero is a bad idea
271         if (tokenSupply_ > 0) {
272             // update the amount of dividends per token
273             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
274         }
275         
276         // fire event
277         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
278     }
279     
280     
281     /**
282      * Transfer tokens from the caller to a new holder.
283      */
284     function transfer(address _toAddress, uint256 _amountOfTokens)
285         onlyTokenHolders()
286         noUnAuthContracts()
287         public
288         returns(bool)
289     {
290         // setup
291         address _customerAddress = msg.sender;
292         
293         // make sure we have the requested tokens
294         require( _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
295         
296         // withdraw all outstanding dividends first
297         if(myDividends(true) > 0) withdraw();
298 
299 
300         // update dividend trackers       
301         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);       
302         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
303         
304         // exchange tokens
305         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
306         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
307         
308         // fire event
309         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
310         
311         // ERC20
312         return true;
313        
314     }
315     
316     /*----------  OWNER ONLY FUNCTIONS  ----------*/
317     /**
318      * In case the amassador quota is not met, the owner can manually disable the ambassador phase.
319      */
320     function disableInitialStage()
321         onlyOwner()
322         public
323     {
324         onlyAmbassadors = false;
325     }
326 
327     function registerAuthContract(address contractAddress)
328         onlyOwner()
329         public
330     {
331         authContracts_[contractAddress] == true;
332     }
333     
334     /*----------  HELPERS AND CALCULATORS  ----------*/
335     /**
336      * Method to view the current Ethereum stored in the contract
337      */
338     function totalEthereumBalance()
339         public
340         view
341         returns(uint)
342     {
343         return address (this).balance;
344     }
345     
346     /**
347      * Retrieve the total token supply.
348      */
349     function totalSupply()
350         public
351         view
352         returns(uint256)
353     {
354         return tokenSupply_;
355     }
356     
357     /**
358      * Retrieve the tokens owned by the caller.
359      */
360     function myTokens()
361         public
362         view
363         returns(uint256)
364     {
365         return balanceOf(msg.sender);
366     }
367     
368     /**
369      * Retrieve the dividends owned by the caller.
370      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
371      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
372      * But in the internal calculations, we want them separate. 
373      */ 
374     function myDividends(bool _includeReferralBonus) 
375         public 
376         view 
377         returns(uint256)
378     {
379         address _customerAddress = msg.sender;
380         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
381     }
382     
383     /**
384      * Retrieve the token balance of any single address.
385      */
386     function balanceOf(address _customerAddress)
387         view
388         public
389         returns(uint256)
390     {
391         return tokenBalanceLedger_[_customerAddress];
392     }
393     
394     /**
395      * Retrieve the dividend balance of any single address.
396      */
397     function dividendsOf(address _customerAddress)
398         view
399         public
400         returns(uint256)
401     {
402         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
403     }
404     
405     /**
406      * Return the buy price of 1 individual token.
407      */
408     function sellPrice() 
409         public 
410         view 
411         returns(uint256)
412     {
413         // our calculation relies on the token supply, so we need supply. Doh.
414         if(tokenSupply_ == 0){
415             return tokenPriceInitial_ - tokenPriceIncremental_;
416         } else {
417             uint256 _ethereum = tokensToEthereum_(1e18);
418             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
419             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
420             return _taxedEthereum;
421         }
422     }
423     
424     /**
425      * Return the sell price of 1 individual token.
426      */
427     function buyPrice() 
428         public 
429         view 
430         returns(uint256)
431     {
432         // our calculation relies on the token supply, so we need supply. Doh.
433         if(tokenSupply_ == 0){
434             return tokenPriceInitial_ + tokenPriceIncremental_;
435         } else {
436             uint256 _ethereum = tokensToEthereum_(1e18);
437             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
438             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
439             return _taxedEthereum;
440         }
441     }
442     
443     /**
444      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
445      */
446     function calculateTokensReceived(uint256 _ethereumToSpend) 
447         public 
448         view 
449         returns(uint256)
450     {
451         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
452         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
453         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
454         
455         return _amountOfTokens;
456     }
457     
458     /**
459      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
460      */
461     function calculateEthereumReceived(uint256 _tokensToSell) 
462         public 
463         view 
464         returns(uint256)
465     {
466         require(_tokensToSell <= tokenSupply_);
467         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
468         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
469         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
470         return _taxedEthereum;
471     }
472     
473     
474     /*==========================================
475     =            INTERNAL FUNCTIONS            =
476     ==========================================*/
477     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
478         antiEarlyWhale(_incomingEthereum)
479         internal
480         returns(uint256)
481     {
482          
483 
484         // data setup
485         address _customerAddress = msg.sender;
486         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
487         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
488         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
489         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
490         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
491         uint256 _fee = _dividends * magnitude;
492 
493         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
494 
495         // is the user referred by a masternode?
496         if(
497             // is this a referred purchase?
498             _referredBy != 0x0000000000000000000000000000000000000000 &&
499 
500             // no cheating!
501             _referredBy != _customerAddress &&
502             
503             // does the referrer have at least X whole tokens?
504             // i.e is the referrer a godly chad masternode
505             tokenBalanceLedger_[_referredBy] >= stakingRequirement
506         ){
507             // wealth redistribution
508             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
509         } else {
510             // no ref purchase
511             // add the referral bonus back to the global dividends cake
512             _dividends = SafeMath.add(_dividends, _referralBonus);
513             _fee = _dividends * magnitude;
514         }
515         
516         // we can't give people infinite ethereum
517         if(tokenSupply_ > 0){
518             
519             // add tokens to the pool
520             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
521  
522             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
523             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
524             
525             // calculate the amount of tokens the customer receives over his purchase 
526             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
527         
528         } else {
529             // add tokens to the pool
530             tokenSupply_ = _amountOfTokens;
531         }
532         
533         // update circulating supply & the ledger address for the customer
534         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
535         
536         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
537         payoutsTo_[_customerAddress] += _updatedPayouts;
538         
539         // fire event
540         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
541         
542         return _amountOfTokens;
543     }
544 
545     /**
546      * Calculate Token price based on an amount of incoming ethereum
547      */
548     function ethereumToTokens_(uint256 _ethereum)
549         internal
550         view
551         returns(uint256)
552     {
553         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
554         uint256 _tokensReceived = 
555          (
556             (
557                 // underflow attempts BTFO
558                 SafeMath.sub(
559                     (sqrt
560                         (
561                             (_tokenPriceInitial**2)
562                             +
563                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
564                             +
565                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
566                             +
567                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
568                         )
569                     ), _tokenPriceInitial
570                 )
571             )/(tokenPriceIncremental_)
572         )-(tokenSupply_)
573         ;
574   
575         return _tokensReceived;
576     }
577     
578     /**
579      * Calculate token sell value.
580      */
581      function tokensToEthereum_(uint256 _tokens)
582         internal
583         view
584         returns(uint256)
585     {
586 
587         uint256 tokens_ = (_tokens + 1e18);
588         uint256 _tokenSupply = (tokenSupply_ + 1e18);
589         uint256 _etherReceived =
590         (
591             SafeMath.sub(
592                 (
593                     (
594                         (
595                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
596                         )-tokenPriceIncremental_
597                     )*(tokens_ - 1e18)
598                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
599             )
600         /1e18);
601         return _etherReceived;
602     }
603     
604     
605     function sqrt(uint x) internal pure returns (uint y) {
606         uint z = (x + 1) / 2;
607         y = x;
608         while (z < y) {
609             y = z;
610             z = (x / z + z) / 2;
611         }
612     }
613 }
614 
615 /**
616  * @title SafeMath
617  * @dev Math operations with safety checks that throw on error
618  */
619 library SafeMath {
620 
621     /**
622     * @dev Multiplies two numbers, throws on overflow.
623     */
624     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
625         if (a == 0) {
626             return 0;
627         }
628         uint256 c = a * b;
629         assert(c / a == b);
630         return c;
631     }
632 
633     /**
634     * @dev Integer division of two numbers, truncating the quotient.
635     */
636     function div(uint256 a, uint256 b) internal pure returns (uint256) {
637         // assert(b > 0); // Solidity automatically throws when dividing by 0
638         uint256 c = a / b;
639         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
640         return c;
641     }
642 
643     /**
644     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
645     */
646     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
647         assert(b <= a);
648         return a - b;
649     }
650 
651     /**
652     * @dev Adds two numbers, throws on overflow.
653     */
654     function add(uint256 a, uint256 b) internal pure returns (uint256) {
655         uint256 c = a + b;
656         assert(c >= a);
657         return c;
658     }
659 }