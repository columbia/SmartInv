1 pragma solidity ^0.4.25;
2 
3 /*
4 *ETH Platinum is a community-based social project and it is not controlled by any person and can never be turned off. You can withdraw all your funds at any time and you are in total control. As people move in and out of this project, you earn dividends in Ethereum, which you can withdraw or reinvest at any time.
5 * www.ethplatinum.io - Official Website
6 * www.ethplatinum.club - Backup Website
7 */
8 
9 
10 contract Ownable {
11     
12     address public owner;
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17         }
18 
19 
20 contract ETHPlatinum is Ownable{
21     /*=================================
22     =            MODIFIERS            =
23     =================================*/
24     // only people with tokens
25     modifier onlybelievers () {
26         require(myTokens() > 0);
27         _;
28     }
29     
30     // only people with profits
31     modifier onlyhodler() {
32         require(myDividends(true) > 0);
33         _;
34     }
35     
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty 
40     // -> change the launch time
41     // they CANNOT:
42     // -> take funds
43     // -> disable withdrawals
44     // -> kill the contract
45     // -> change the price of tokens
46     modifier onlyAdministrator(){
47          require(msg.sender == owner);  
48         _;
49     }
50     
51         modifier antiEarlyWhale(uint256 _amountOfEthereum){
52         address _customerAddress = msg.sender;
53         
54       
55         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
56             require(
57                 // is the customer in the ambassador list?
58                 ambassadors_[_customerAddress] == true &&
59                 
60                 // does the customer purchase exceed the max ambassador quota?
61                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
62                 
63             );
64             
65             // updated the accumulated quota    
66             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
67         
68             // execute
69             _;
70         } else {
71             // in case the ether count drops low, the ambassador phase won't reinitiate
72             onlyAmbassadors = false;
73             _;    
74         }
75         
76     }
77     
78     
79     /*==============================
80     =            EVENTS            =
81     ==============================*/
82     event onTokenPurchase(
83         address indexed customerAddress,
84         uint256 incomingEthereum,
85         uint256 tokensMinted,
86         address indexed referredBy
87     );
88     
89     event onTokenSell(
90         address indexed customerAddress,
91         uint256 tokensBurned,
92         uint256 ethereumEarned
93     );
94     
95     event onReinvestment(
96         address indexed customerAddress,
97         uint256 ethereumReinvested,
98         uint256 tokensMinted
99     );
100     
101     event onWithdraw(
102         address indexed customerAddress,
103         uint256 ethereumWithdrawn
104     );
105     
106     // ERC20
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 tokens
111     );
112     
113     
114     /*=====================================
115     =            CONFIGURABLES            =
116     =====================================*/
117     string public name = "ETHPlatinum";
118     string public symbol = "PLTE";
119     uint8 constant public decimals = 18;
120     uint8 constant internal dividendFee_ = 10;
121     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
122     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
123     uint256 constant internal magnitude = 2**64;
124     uint256 public launchtime = 1636837200;  // Epoch timestamp - Launch Time
125     
126      // proof of stake (defaults at 1 token)
127     uint256 public stakingRequirement = 1e18;
128     
129     // ambassador program
130     mapping(address => bool) internal ambassadors_;
131     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
132     uint256 constant internal ambassadorQuota_ = 5 ether;
133     
134     
135     
136    /*================================
137     =            DATASETS            =
138     ================================*/
139     // amount of shares for each address (scaled number)
140     mapping(address => uint256) internal tokenBalanceLedger_;
141     mapping(address => uint256) internal referralBalance_;
142     mapping(address => int256) internal payoutsTo_;
143     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
144     uint256 internal tokenSupply_ = 0;
145     uint256 internal profitPerShare_;
146     
147     
148     //mapping(bytes32 => bool) public administrators;
149     
150     
151     bool public onlyAmbassadors = true;
152     
153 
154 
155     /*=======================================
156     =            PUBLIC FUNCTIONS            =
157     =======================================*/
158     /*
159     * -- APPLICATION ENTRY POINTS --  
160     */
161     function ETHPlatinum()
162         public
163     {
164                    
165          // Ambassador 1
166         ambassadors_[0x2197b2C19ebB841B0944f2dB9A2E904459d09117] = true;
167         
168          // Ambassador 2
169         ambassadors_[0xB1ac371B9D5Bc5eFd4505dB8c642Cf18d9449184] = true;
170         
171          // Ambassador 3
172         ambassadors_[0x9492Ff5074bF84263ec238C3AD37A8A8f4f7e7C5] = true;
173         
174          // Ambassador 4
175         ambassadors_[0x371415Ba1792C20D34D2F1463467ab0A2425De9C] = true;
176         
177          // Ambassador 5
178         ambassadors_[0x20890F6F8954A13aD93972c2ac15412573F9fEA1] = true;
179                        
180                        
181     }
182     
183      
184     /**
185      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
186      */
187     function buy(address _referredBy)
188         public
189         payable
190         returns(uint256)
191     {
192         require(now >= launchtime);
193         purchaseTokens(msg.value, _referredBy);
194     }
195     
196     
197     function()
198         payable
199         public
200     {
201         require(now >= launchtime);
202         purchaseTokens(msg.value, 0x0);
203     }
204     
205     /**
206      * Converts all of caller's dividends to tokens.
207      */
208     function reinvest()
209         onlyhodler()
210         public
211     {
212         // fetch dividends
213         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
214         
215         // pay out the dividends virtually
216         address _customerAddress = msg.sender;
217         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
218         
219         // retrieve ref. bonus
220         _dividends += referralBalance_[_customerAddress];
221         referralBalance_[_customerAddress] = 0;
222         
223         // dispatch a buy order with the virtualized "withdrawn dividends"
224         uint256 _tokens = purchaseTokens(_dividends, 0x0);
225         
226         // fire event
227         onReinvestment(_customerAddress, _dividends, _tokens);
228     }
229     
230     /**
231      * Alias of sell() and withdraw().
232      */
233     function exit()
234         public
235     {
236         // get token count for caller & sell them all
237         address _customerAddress = msg.sender;
238         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
239         if(_tokens > 0) sell(_tokens);
240         
241         
242         withdraw();
243     }
244 
245     /**
246      * Withdraws all of the callers earnings.
247      */
248     function withdraw()
249         onlyhodler()
250         public
251     {
252         // setup data
253         address _customerAddress = msg.sender;
254         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
255         
256         // update dividend tracker
257         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
258         
259         // add ref. bonus
260         _dividends += referralBalance_[_customerAddress];
261         referralBalance_[_customerAddress] = 0;
262         
263         // delivery service
264         _customerAddress.transfer(_dividends);
265         
266         // fire event
267         onWithdraw(_customerAddress, _dividends);
268     }
269     
270     /**
271      * Liquifies tokens to ethereum.
272      */
273     function sell(uint256 _amountOfTokens)
274         onlybelievers ()
275         public
276     {
277       
278         address _customerAddress = msg.sender;
279        
280         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
281         uint256 _tokens = _amountOfTokens;
282         uint256 _ethereum = tokensToEthereum_(_tokens);
283         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
284         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
285         
286         // burn the sold tokens
287         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
288         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
289         
290         // update dividends tracker
291         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
292         payoutsTo_[_customerAddress] -= _updatedPayouts;       
293         
294         // dividing by zero is a bad idea
295         if (tokenSupply_ > 0) {
296             // update the amount of dividends per token
297             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
298         }
299         
300         // fire event
301         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
302     }
303     
304     
305     /**
306      * Transfer tokens from the caller to a new holder.
307      * Remember, there's a 10% fee here as well.
308      */
309     function transfer(address _toAddress, uint256 _amountOfTokens)
310         onlybelievers ()
311         public
312         returns(bool)
313     {
314         // setup
315         address _customerAddress = msg.sender;
316         
317         // make sure we have the requested tokens
318      
319         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320         
321         // withdraw all outstanding dividends first
322         if(myDividends(true) > 0) withdraw();
323         
324         // liquify 10% of the tokens that are transfered
325         // these are dispersed to shareholders
326         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
327         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
328         uint256 _dividends = tokensToEthereum_(_tokenFee);
329   
330         // burn the fee tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
332 
333         // exchange tokens
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
335         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
336         
337         // update dividend trackers
338         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
339         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
340         
341         // disperse dividends among holders
342         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
343         
344         // fire event
345         Transfer(_customerAddress, _toAddress, _taxedTokens);
346         
347         // ERC20
348         return true;
349        
350     }
351     
352     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
353     /**
354      * administrator can manually disable the ambassador phase.
355      */
356     function disableInitialStage()
357         onlyAdministrator()
358         public
359     {
360         onlyAmbassadors = false;
361     }
362     
363        function updateLaunchtime(uint256 _Launchtime) 
364        onlyAdministrator()
365        public 
366        {
367         launchtime = _Launchtime;
368        }
369     
370    
371         function setStakingRequirement(uint256 _amountOfTokens)
372         onlyAdministrator()
373         public
374     {
375         stakingRequirement = _amountOfTokens;
376     }
377     
378     
379     function setName(string _name)
380         onlyAdministrator()
381         public
382     {
383         name = _name;
384     }
385     
386    
387     function setSymbol(string _symbol)
388         onlyAdministrator()
389         public
390     {
391         symbol = _symbol;
392     }
393 
394     
395     /*----------  HELPERS AND CALCULATORS  ----------*/
396     /**
397      * Method to view the current Ethereum stored in the contract
398      * Example: totalEthereumBalance()
399      */
400     function totalEthereumBalance()
401         public
402         view
403         returns(uint)
404     {
405         return this.balance;
406     }
407     
408     /**
409      * Retrieve the total token supply.
410      */
411     function totalSupply()
412         public
413         view
414         returns(uint256)
415     {
416         return tokenSupply_;
417     }
418     
419     /**
420      * Retrieve the tokens owned by the caller.
421      */
422     function myTokens()
423         public
424         view
425         returns(uint256)
426     {
427         address _customerAddress = msg.sender;
428         return balanceOf(_customerAddress);
429     }
430     
431     /**
432      * Retrieve the dividends owned by the caller.
433        */ 
434     function myDividends(bool _includeReferralBonus) 
435         public 
436         view 
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
441     }
442     
443     /**
444      * Retrieve the token balance of any single address.
445      */
446     function balanceOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return tokenBalanceLedger_[_customerAddress];
452     }
453     
454     /**
455      * Retrieve the dividend balance of any single address.
456      */
457     function dividendsOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
463     }
464     
465     /**
466      * Return the buy price of 1 individual token.
467      */
468     function sellPrice() 
469         public 
470         view 
471         returns(uint256)
472     {
473        
474         if(tokenSupply_ == 0){
475             return tokenPriceInitial_ - tokenPriceIncremental_;
476         } else {
477             uint256 _ethereum = tokensToEthereum_(1e18);
478             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
479             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
480             return _taxedEthereum;
481         }
482     }
483     
484     /**
485      * Return the sell price of 1 individual token.
486      */
487     function buyPrice() 
488         public 
489         view 
490         returns(uint256)
491     {
492         
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ + tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502     
503    
504     function calculateTokensReceived(uint256 _ethereumToSpend) 
505         public 
506         view 
507         returns(uint256)
508     {
509         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
510         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
511         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
512         
513         return _amountOfTokens;
514     }
515     
516    
517     function calculateEthereumReceived(uint256 _tokensToSell) 
518         public 
519         view 
520         returns(uint256)
521     {
522         require(_tokensToSell <= tokenSupply_);
523         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
524         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
525         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
526         return _taxedEthereum;
527     }
528     
529     
530     /*==========================================
531     =            INTERNAL FUNCTIONS            =
532     ==========================================*/
533     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
534         antiEarlyWhale(_incomingEthereum)
535         internal
536         returns(uint256)
537     {
538         // data setup
539         address _customerAddress = msg.sender;
540         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
541         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2);
542         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
543         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
544         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
545         uint256 _fee = _dividends * magnitude;
546  
547       
548         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
549         
550         // is the user referred by a karmalink?
551         if(
552             // is this a referred purchase?
553             _referredBy != 0x0000000000000000000000000000000000000000 &&
554 
555             // no cheating!
556             _referredBy != _customerAddress &&
557             
558         
559             tokenBalanceLedger_[_referredBy] >= stakingRequirement
560         ){
561             // wealth redistribution
562             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
563         } else {
564             // no ref purchase
565             // add the referral bonus back to the global dividends cake
566             _dividends = SafeMath.add(_dividends, _referralBonus);
567             _fee = _dividends * magnitude;
568         }
569         
570         // we can't give people infinite ethereum
571         if(tokenSupply_ > 0){
572             
573             // add tokens to the pool
574             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
575  
576             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
577             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
578             
579             // calculate the amount of tokens the customer receives over his purchase 
580             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
581         
582         } else {
583             // add tokens to the pool
584             tokenSupply_ = _amountOfTokens;
585         }
586         
587         // update circulating supply & the ledger address for the customer
588         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
589         
590         
591         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
592         payoutsTo_[_customerAddress] += _updatedPayouts;
593         
594         // fire event
595         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
596         
597         return _amountOfTokens;
598     }
599 
600     /**
601      * Calculate Token price based on an amount of incoming ethereum
602      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
603      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
604      */
605     function ethereumToTokens_(uint256 _ethereum)
606         internal
607         view
608         returns(uint256)
609     {
610         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
611         uint256 _tokensReceived = 
612          (
613             (
614                 // underflow attempts BTFO
615                 SafeMath.sub(
616                     (sqrt
617                         (
618                             (_tokenPriceInitial**2)
619                             +
620                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
621                             +
622                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
623                             +
624                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
625                         )
626                     ), _tokenPriceInitial
627                 )
628             )/(tokenPriceIncremental_)
629         )-(tokenSupply_)
630         ;
631   
632         return _tokensReceived;
633     }
634     
635     /**
636      * Calculate token sell value.
637           */
638      function tokensToEthereum_(uint256 _tokens)
639         internal
640         view
641         returns(uint256)
642     {
643 
644         uint256 tokens_ = (_tokens + 1e18);
645         uint256 _tokenSupply = (tokenSupply_ + 1e18);
646         uint256 _etherReceived =
647         (
648             // underflow attempts BTFO
649             SafeMath.sub(
650                 (
651                     (
652                         (
653                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
654                         )-tokenPriceIncremental_
655                     )*(tokens_ - 1e18)
656                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
657             )
658         /1e18);
659         return _etherReceived;
660     }
661     
662     
663     
664     function sqrt(uint x) internal pure returns (uint y) {
665         uint z = (x + 1) / 2;
666         y = x;
667         while (z < y) {
668             y = z;
669             z = (x / z + z) / 2;
670         }
671     }
672 }
673 
674 /**
675  * @title SafeMath
676  * @dev Math operations with safety checks that throw on error
677  */
678 library SafeMath {
679 
680    
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         if (a == 0) {
683             return 0;
684         }
685         uint256 c = a * b;
686         assert(c / a == b);
687         return c;
688     }
689 
690    
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         // assert(b > 0); // Solidity automatically throws when dividing by 0
693         uint256 c = a / b;
694         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
695         return c;
696     }
697 
698     
699     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
700         assert(b <= a);
701         return a - b;
702     }
703 
704    
705     function add(uint256 a, uint256 b) internal pure returns (uint256) {
706         uint256 c = a + b;
707         assert(c >= a);
708         return c;
709     }
710 
711 }