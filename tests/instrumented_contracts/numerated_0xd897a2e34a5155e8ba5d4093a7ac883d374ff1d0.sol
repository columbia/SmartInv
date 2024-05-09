1 pragma solidity ^0.4.20;
2  
3 /*
4 IronHandsCommerce - a pyramid where you choose your own tariffs.
5 
6 + No contracts
7 + Timed start
8 + Community premine
9 */
10  
11 contract IronHandsCommerce {
12     /*=================================
13     =            MODIFIERS            =
14     =================================*/
15     // only people with tokens
16     modifier onlyBagholders() {
17         require(myTokens() > 0);
18         _;
19     }
20     
21     // only people with profits
22     modifier onlyStronghands() {
23         require(myDividends() > 0);
24         _;
25     }
26     
27     // only people with set tarifs
28     modifier onlyTarifed() {
29         address _customerAddress = msg.sender;
30         require(tarif[_customerAddress] != 0);
31         _;
32     }
33     
34     //don't allow smart contracts to play
35     modifier noContracts {
36         require(msg.sender == tx.origin);
37         _;
38     }
39     
40     //wait for game to start
41     modifier isStarted {
42         require(now >= disableTime);
43         _;
44     }
45     
46     // administrators can:
47     // -> change the name of the contract
48     // -> change the name of the token
49     // they CANNOT:
50     // -> take funds
51     // -> disable withdrawals
52     // -> kill the contract
53     // -> change the price of tokens
54     modifier onlyAdministrator() {
55         address _customerAddress = msg.sender;
56         require(administrators[_customerAddress]);
57         _;
58     }
59  
60  
61     // ensures that the first tokens in the contract will be equally distributed
62     // meaning, no divine dump will be ever possible
63     // result: healthy longevity.
64     modifier antiEarlyWhale(uint256 _amountOfEthereum){
65         address _customerAddress = msg.sender;
66         
67         //admin can premine and setup the contract
68         if(administrators[msg.sender] == true) {
69             _;
70         }
71         //ambassadors go through this
72         else {
73             // are we still in the vulnerable phase?
74             // if so, enact anti early whale protocol
75             if( onlyAmbassadors ){
76                 require(
77                     // is the customer in the ambassador list?
78                     ambassadors_[_customerAddress] == true &&
79      
80                     // does the customer purchase exceed the max ambassador quota?
81                     (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
82      
83                 );
84      
85                 // updated the accumulated quota
86                 ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
87      
88                 // execute
89                 _;
90             }
91             else {
92                 _;
93             }
94         }
95     }
96  
97  
98     /*==============================
99     =            EVENTS            =
100     ==============================*/
101     event onTokenPurchase(
102         address indexed customerAddress,
103         uint256 incomingEthereum,
104         uint256 tokensMinted
105     );
106  
107     event onTokenSell(
108         address indexed customerAddress,
109         uint256 tokensBurned,
110         uint256 ethereumEarned
111     );
112  
113     event onReinvestment(
114         address indexed customerAddress,
115         uint256 ethereumReinvested,
116         uint256 tokensMinted
117     );
118  
119     event onWithdraw(
120         address indexed customerAddress,
121         uint256 ethereumWithdrawn
122     );
123     
124  
125  
126     /*=====================================
127     =            CONFIGURABLES            =
128     =====================================*/
129     string public name = "IronHandsCommerce";
130     string public symbol = "IHC";
131     uint8 constant public decimals = 18;
132     mapping(address => uint256) internal tarif; //valid tarifs are in [5, 45] interval
133     uint256 constant internal tarifMin = 5;
134     uint256 constant internal tarifMax = 45;
135     uint256 constant internal tarifDiff = 50;
136     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
137     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
138     uint256 constant internal magnitude = 2**64;
139     
140     // ambassador program
141     mapping(address => bool) internal ambassadors_;
142     uint256 constant internal ambassadorMaxPurchase_ = 0.1 ether;
143     uint256 constant internal timeToStart = 300 seconds;
144     uint256 public disableTime = 0;
145     
146     
147     
148    /*================================
149     =            DATASETS            =
150     ================================*/
151     // amount of shares for each address (scaled number)
152     mapping(address => uint256) internal tokenBalanceLedger_;
153     mapping(address => int256) internal payoutsTo_;
154     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
155     uint256 internal tokenSupply_ = 0;
156     uint256 internal profitPerShare_;
157  
158     // administrator list (see above on what they can do)
159     mapping(address => bool) public administrators;
160  
161     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
162     bool public onlyAmbassadors = true;
163  
164  
165  
166     /*=======================================
167     =            PUBLIC FUNCTIONS            =
168     =======================================*/
169     /*
170     * -- APPLICATION ENTRY POINTS --
171     */
172     constructor()
173         public
174     {
175         // add administrators here
176         administrators[0xc124DB59B549792e05Ab3562314eD370b90F7D42] = true;
177     }
178  
179     /**
180      * Converts all incoming ethereum to tokens for the caller
181      * Set a new tarif if sender has no tokens
182      * Otherwise, just ignore the input and use previous tarif
183      */
184     function buy(uint256 newTarif)
185         noContracts()
186         isStarted()
187         public
188         payable
189         returns(uint256)
190     {
191         address _customerAddress = msg.sender;
192         require(newTarif >= tarifMin && newTarif <= tarifMax);
193         if(myTokens() == 0) {
194             tarif[_customerAddress] = newTarif;
195         }
196         purchaseTokens(msg.value);
197     }
198  
199     /**
200      * Fallback function to handle ethereum that was send straight to the contract
201      * Default 25:25 tarif is provided
202      */
203     function()
204         noContracts()
205         isStarted()
206         payable
207         public
208     {
209         address _customerAddress = msg.sender;
210         if(myTokens() == 0) {
211             tarif[_customerAddress] = 25;
212         }
213         purchaseTokens(msg.value);
214     }
215     
216     /**
217      * Converts all of caller's dividends to tokens.
218     */
219     function reinvest()
220         noContracts()
221         isStarted()
222         onlyStronghands()
223         public
224     {
225         // fetch dividends
226         uint256 _dividends = myDividends();
227  
228         // pay out the dividends virtually
229         address _customerAddress = msg.sender;
230         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
231  
232         // dispatch a buy order with the virtualized "withdrawn dividends"
233         uint256 _tokens = purchaseTokens(_dividends);
234  
235         // fire event
236         emit onReinvestment(_customerAddress, _dividends, _tokens);
237     }
238  
239     /**
240      * Alias of sell() and withdraw().
241      */
242     function exit()
243         noContracts()
244         isStarted()
245         public
246     {
247         // get token count for caller & sell them all
248         address _customerAddress = msg.sender;
249         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
250         if(_tokens > 0) sell(_tokens);
251  
252         // lambo delivery service
253         withdraw();
254     }
255  
256     /**
257      * Withdraws all of the callers earnings.
258      */
259     function withdraw()
260         noContracts()
261         isStarted()
262         onlyStronghands()
263         public
264     {
265         // setup data
266         address _customerAddress = msg.sender;
267         uint256 _dividends = myDividends();
268  
269         // update dividend tracker
270         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
271  
272         // lambo delivery service
273         _customerAddress.transfer(_dividends);
274  
275         // fire event
276         emit onWithdraw(_customerAddress, _dividends);
277     }
278  
279     /**
280      * Liquifies tokens to ethereum.
281      */
282     function sell(uint256 _amountOfTokens)
283         noContracts()
284         isStarted()
285         onlyBagholders()
286         public
287     {
288         // setup data
289         address _customerAddress = msg.sender;
290         // russian hackers BTFO
291         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292         uint256 _tokens = _amountOfTokens;
293         uint256 _ethereum = tokensToEthereum_(_tokens);
294         uint256 dividendFee_ = SafeMath.sub(tarifDiff, tarif[_customerAddress]);
295         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
296         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
297  
298         // burn the sold tokens
299         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
300         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
301  
302         // update dividends tracker
303         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
304         payoutsTo_[_customerAddress] -= _updatedPayouts;
305  
306         // dividing by zero is a bad idea
307         if (tokenSupply_ > 0) {
308             // update the amount of dividends per token
309             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
310         }
311  
312         // fire event
313         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
314     }
315  
316     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
317     /**
318      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
319      */
320     function disableInitialStage()
321         onlyAdministrator()
322         public
323     {
324         onlyAmbassadors = false;
325         disableTime = now + timeToStart;
326     }
327     
328     /**
329      * Add ambassadors dynamically.
330      */
331     function addAmbassador(address _identifier)
332         onlyAdministrator()
333         public
334     {
335         ambassadors_[_identifier] = true;
336     }
337  
338     /**
339      * In case one of us dies, we need to replace ourselves.
340      */
341     function setAdministrator(address _identifier, bool _status)
342         onlyAdministrator()
343         public
344     {
345         administrators[_identifier] = _status;
346     }
347  
348     /**
349      * If we want to rebrand, we can.
350      */
351     function setName(string _name)
352         onlyAdministrator()
353         public
354     {
355         name = _name;
356     }
357  
358     /**
359      * If we want to rebrand, we can.
360      */
361     function setSymbol(string _symbol)
362         onlyAdministrator()
363         public
364     {
365         symbol = _symbol;
366     }
367  
368  
369     /*----------  HELPERS AND CALCULATORS  ----------*/
370     /**
371      * Method to view the current Ethereum stored in the contract
372      * Example: totalEthereumBalance()
373      */
374     function totalEthereumBalance()
375         public
376         view
377         returns(uint)
378     {
379         return address(this).balance;
380     }
381  
382     /**
383      * Retrieve the total token supply.
384      */
385     function totalSupply()
386         public
387         view
388         returns(uint256)
389     {
390         return tokenSupply_;
391     }
392  
393     /**
394      * Retrieve the tokens owned by the caller.
395      */
396     function myTokens()
397         public
398         view
399         returns(uint256)
400     {
401         address _customerAddress = msg.sender;
402         return balanceOf(_customerAddress);
403     }
404  
405     /**
406      * Retrieve the dividends owned by the caller.
407      */
408     function myDividends()
409         public
410         view
411         returns(uint256)
412     {
413         address _customerAddress = msg.sender;
414         return dividendsOf(_customerAddress);
415     }
416     
417     /**
418      * Retrieve the tarif used by the caller.
419      */
420     function myTarif()
421         public
422         view
423         returns(uint256)
424     {
425         address _customerAddress = msg.sender;
426         return tarifOf(_customerAddress);
427     }
428  
429     /**
430      * Retrieve the token balance of any single address.
431      */
432     function balanceOf(address _customerAddress)
433         view
434         public
435         returns(uint256)
436     {
437         return tokenBalanceLedger_[_customerAddress];
438     }
439  
440     /**
441      * Retrieve the dividend balance of any single address.
442      */
443     function dividendsOf(address _customerAddress)
444         view
445         public
446         returns(uint256)
447     {
448         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
449     }
450     
451     /**
452      * Retrieve the buy tarif of any single address.
453      * Calculate sell tarif yourself
454      */
455     function tarifOf(address _customerAddress)
456         view
457         public
458         returns(uint256)
459     {
460         return tarif[_customerAddress];
461     }
462  
463     /**
464      * Return the buy price of 1 individual token.
465      */
466     function sellPrice()
467         public
468         view
469         returns(uint256)
470     {
471         address _customerAddress = msg.sender;
472         // our calculation relies on the token supply, so we need supply. Doh.
473         if(tokenSupply_ == 0) {
474             return tokenPriceInitial_ - tokenPriceIncremental_;
475         } else {
476             uint256 _ethereum = tokensToEthereum_(1e18);
477             uint256 dividendFee_ = SafeMath.sub(tarifDiff, tarif[_customerAddress]);
478             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
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
492         address _customerAddress = msg.sender;
493         // our calculation relies on the token supply, so we need supply. Doh.
494         if(tokenSupply_ == 0){
495             return tokenPriceInitial_ + tokenPriceIncremental_;
496         } else {
497             uint256 _ethereum = tokensToEthereum_(1e18);
498             uint256 dividendFee_ = tarif[_customerAddress];
499             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
500             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
501             return _taxedEthereum;
502         }
503     }
504  
505     /**
506      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
507      */
508     function calculateTokensReceived(uint256 _ethereumToSpend)
509         public
510         view
511         returns(uint256)
512     {
513         address _customerAddress = msg.sender;
514         uint256 dividendFee_ = tarif[_customerAddress];
515         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
516         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
517         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
518  
519         return _amountOfTokens;
520     }
521  
522     /**
523      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
524      */
525     function calculateEthereumReceived(uint256 _tokensToSell)
526         public
527         view
528         returns(uint256)
529     {
530         address _customerAddress = msg.sender;
531         require(_tokensToSell <= tokenSupply_);
532         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
533         uint256 dividendFee_ = SafeMath.sub(tarifDiff, tarif[_customerAddress]);
534         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
535         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
536         return _taxedEthereum;
537     }
538  
539  
540     /*==========================================
541     =            INTERNAL FUNCTIONS            =
542     ==========================================*/
543     function purchaseTokens(uint256 _incomingEthereum)
544         antiEarlyWhale(_incomingEthereum)
545         internal
546         returns(uint256)
547     {
548         // data setup
549         address _customerAddress = msg.sender;
550         uint256 dividendFee_ = tarif[_customerAddress];
551         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
552         uint256 _dividends = _undividedDividends;
553         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
554         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
555         uint256 _fee = _dividends * magnitude;
556  
557         // no point in continuing execution if OP is a poorfag russian hacker
558         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
559         // (or hackers)
560         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
561         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
562         
563         // we can't give people infinite ethereum
564         if(tokenSupply_ > 0){
565  
566             // add tokens to the pool
567             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
568  
569             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
570             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
571  
572             // calculate the amount of tokens the customer receives over his purchase
573             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
574  
575         } else {
576             // add tokens to the pool
577             tokenSupply_ = _amountOfTokens;
578         }
579  
580         // update circulating supply & the ledger address for the customer
581         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
582  
583         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
584         //really i know you think you do but you don't
585         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
586         payoutsTo_[_customerAddress] += _updatedPayouts;
587  
588         // fire event
589         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens);
590  
591         return _amountOfTokens;
592     }
593  
594     /**
595      * Calculate Token price based on an amount of incoming ethereum
596      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
597      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
598      */
599     function ethereumToTokens_(uint256 _ethereum)
600         internal
601         view
602         returns(uint256)
603     {
604         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
605         uint256 _tokensReceived =
606          (
607             (
608                 // underflow attempts BTFO
609                 SafeMath.sub(
610                     (sqrt
611                         (
612                             (_tokenPriceInitial**2)
613                             +
614                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
615                             +
616                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
617                             +
618                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
619                         )
620                     ), _tokenPriceInitial
621                 )
622             )/(tokenPriceIncremental_)
623         )-(tokenSupply_)
624         ;
625  
626         return _tokensReceived;
627     }
628  
629     /**
630      * Calculate token sell value.
631      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
632      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
633      */
634      function tokensToEthereum_(uint256 _tokens)
635         internal
636         view
637         returns(uint256)
638     {
639  
640         uint256 tokens_ = (_tokens + 1e18);
641         uint256 _tokenSupply = (tokenSupply_ + 1e18);
642         uint256 _etherReceived =
643         (
644             // underflow attempts BTFO
645             SafeMath.sub(
646                 (
647                     (
648                         (
649                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
650                         )-tokenPriceIncremental_
651                     )*(tokens_ - 1e18)
652                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
653             )
654         /1e18);
655         return _etherReceived;
656     }
657  
658  
659     //This is where all your gas goes, sorry
660     //Not sorry, you probably only paid 1 gwei
661     function sqrt(uint x) internal pure returns (uint y) {
662         uint z = (x + 1) / 2;
663         y = x;
664         while (z < y) {
665             y = z;
666             z = (x / z + z) / 2;
667         }
668     }
669 }
670  
671 /**
672  * @title SafeMath
673  * @dev Math operations with safety checks that throw on error
674  */
675 library SafeMath {
676  
677     /**
678     * @dev Multiplies two numbers, throws on overflow.
679     */
680     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
681         if (a == 0) {
682             return 0;
683         }
684         uint256 c = a * b;
685         assert(c / a == b);
686         return c;
687     }
688  
689     /**
690     * @dev Integer division of two numbers, truncating the quotient.
691     */
692     function div(uint256 a, uint256 b) internal pure returns (uint256) {
693         // assert(b > 0); // Solidity automatically throws when dividing by 0
694         uint256 c = a / b;
695         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
696         return c;
697     }
698  
699     /**
700     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
701     */
702     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
703         assert(b <= a);
704         return a - b;
705     }
706  
707     /**
708     * @dev Adds two numbers, throws on overflow.
709     */
710     function add(uint256 a, uint256 b) internal pure returns (uint256) {
711         uint256 c = a + b;
712         assert(c >= a);
713         return c;
714     }
715 }