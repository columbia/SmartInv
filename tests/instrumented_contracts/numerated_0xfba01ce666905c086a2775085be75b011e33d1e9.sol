1 pragma solidity ^0.4.22;
2 
3 /*
4 *       ===3D HODL===           
5 * 10%  dividend fee on each buy
6 * 20%  dividend fee on each sell
7 *  0%  TRANSFER FEES in future games 
8 */
9 
10 
11 /**
12  * Games Bridge
13  */
14 contract AcceptsToken3D {
15     Token3D public tokenContract;
16 
17     function AcceptsToken3D(address _tokenContract) public {
18         tokenContract = Token3D(_tokenContract);
19     }
20 
21     modifier onlyTokenContract {
22         require(msg.sender == address(tokenContract));
23         _;
24     }
25 
26 
27     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
28 }
29 
30 
31 contract Token3D {
32     /*=================================
33     =            MODIFIERS            =
34     =================================*/
35     // only people with tokens
36     modifier onlyBagholders() {
37         require(myTokens() > 0);
38         _;
39     }
40 
41     // only people with profits
42     modifier onlyStronghands() {
43         require(myDividends(true) > 0);
44         _;
45     }
46 
47     modifier notContract() {
48       require (msg.sender == tx.origin);
49       _;
50     }
51 
52 
53     modifier onlyAdministrator(){
54         address _customerAddress = msg.sender;
55         require(administrators[_customerAddress]);
56         _;
57     }
58 
59 
60     modifier antiEarlyWhale(uint256 _amountOfEthereum){
61         address _customerAddress = msg.sender;
62 
63         // are we still in the vulnerable phase?
64         // if so, enact anti early whale protocol
65         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
66             require(
67                 // is the customer in the ambassador list?
68                 ambassadors_[_customerAddress] == true &&
69 
70                 // does the customer purchase exceed the max ambassador quota?
71                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
72 
73             );
74 
75             // updated the accumulated quota
76             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
77 
78             // execute
79             _;
80         } else {
81             // in case the ether count drops low, the ambassador phase won't reinitiate
82             onlyAmbassadors = false;
83             _;
84         }
85 
86     }
87 
88     /*==============================
89     =            EVENTS            =
90     ==============================*/
91     event onTokenPurchase(
92         address indexed customerAddress,
93         uint256 incomingEthereum,
94         uint256 tokensMinted,
95         address indexed referredBy
96     );
97 
98     event onTokenSell(
99         address indexed customerAddress,
100         uint256 tokensBurned,
101         uint256 ethereumEarned
102     );
103 
104     event onReinvestment(
105         address indexed customerAddress,
106         uint256 ethereumReinvested,
107         uint256 tokensMinted
108     );
109 
110     event onWithdraw(
111         address indexed customerAddress,
112         uint256 ethereumWithdrawn
113     );
114 
115     // ERC20
116     event Transfer(
117         address indexed from,
118         address indexed to,
119         uint256 tokens
120     );
121 
122 
123     /*=====================================
124     =            CONFIGURABLES            =
125     =====================================*/
126     string public name = "3D HODL";
127     string public symbol = "3D";
128     uint8 constant public decimals = 18;
129     uint8 constant internal dividendFee_ = 10; // 10% dividend fee on each buy
130     uint8 constant internal selldividendFee_ = 20; // 10% dividend fee on each sell
131     uint8 constant internal xFee_ = 0; 
132     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
134     uint256 constant internal magnitude = 2**64;
135 
136    
137     
138     address constant public giveEthxAddress = 0x0000000000000000000000000000000000000000;
139     uint256 public totalEthxRecieved; 
140     uint256 public totalEthxCollected; 
141     
142     // proof of stake (defaults at 100 tokens)
143     uint256 public stakingRequirement = 1000e18;
144 
145     // ambassador program
146     mapping(address => bool) internal ambassadors_;
147     uint256 constant internal ambassadorMaxPurchase_ = 0.01 ether;
148     uint256 constant internal ambassadorQuota_ = 0.01 ether; // If ambassor quota not met, disable to open to public.
149 
150 
151 
152    /*================================
153     =            DATASETS            =
154     ================================*/
155     // amount of shares for each address (scaled number)
156     mapping(address => uint256) internal tokenBalanceLedger_;
157     mapping(address => uint256) internal referralBalance_;
158     mapping(address => int256) internal payoutsTo_;
159     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
160     uint256 internal tokenSupply_ = 0;
161     uint256 internal profitPerShare_;
162 
163     // administrator list (see above on what they can do)
164     mapping(address => bool) public administrators;
165 
166     bool public onlyAmbassadors = false;
167 
168     
169     mapping(address => bool) public canAcceptTokens_; 
170 
171 
172 
173     /*=======================================
174     =            PUBLIC FUNCTIONS            =
175     =======================================*/
176     
177     function Token3D()
178         public
179     {
180         // add administrators here
181         administrators[0xded61af41df552e4755c9e97e477643c833904e3] = true;
182 
183         // add the ambassadors here.
184         ambassadors_[0xded61af41df552e4755c9e97e477643c833904e3] = true;
185        
186     }
187 
188 
189     function buy(address _referredBy)
190         public
191         payable
192         returns(uint256)
193     {
194         purchaseInternal(msg.value, _referredBy);
195     }
196 
197     
198     function()
199         payable
200         public
201     {
202         purchaseInternal(msg.value, 0x0);
203     }
204 
205    
206 
207     function reinvest()
208         onlyStronghands()
209         public
210     {
211         // fetch dividends
212         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
213 
214         // pay out the dividends virtually
215         address _customerAddress = msg.sender;
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217 
218         // retrieve ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221 
222         // dispatch a buy order with the virtualized "withdrawn dividends"
223         uint256 _tokens = purchaseTokens(_dividends, 0x0);
224 
225         // fire event
226         onReinvestment(_customerAddress, _dividends, _tokens);
227     }
228 
229     
230     function exit()
231         public
232     {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if(_tokens > 0) sell(_tokens);
237 
238         withdraw();
239     }
240 
241     
242     function withdraw()
243         onlyStronghands()
244         public
245     {
246         // setup data
247         address _customerAddress = msg.sender;
248         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
249 
250         // update dividend tracker
251         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
252 
253         // add ref. bonus
254         _dividends += referralBalance_[_customerAddress];
255         referralBalance_[_customerAddress] = 0;
256 
257         _customerAddress.transfer(_dividends);
258 
259         onWithdraw(_customerAddress, _dividends);
260     }
261 
262     /**
263      * Liquifies tokens to ethereum.
264      */
265     function sell(uint256 _amountOfTokens)
266         onlyBagholders()
267         public
268     {
269         // setup data
270         address _customerAddress = msg.sender;
271         // russian hackers BTFO
272         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
273         uint256 _tokens = _amountOfTokens;
274         uint256 _ethereum = tokensToEthereum_(_tokens);
275 
276         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, selldividendFee_), 100);
277         uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereum, xFee_), 100);
278 
279         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _xPayout);
280 
281         
282         totalEthxCollected = SafeMath.add(totalEthxCollected, _xPayout);
283 
284         // burn the sold tokens
285         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
286         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
287 
288         // update dividends tracker
289         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
290         payoutsTo_[_customerAddress] -= _updatedPayouts;
291 
292         // dividing by zero is a bad idea
293         if (tokenSupply_ > 0) {
294             // update the amount of dividends per token
295             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         }
297 
298         // fire event
299         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
300     }
301 
302 
303     /**
304      * Transfer tokens from the caller to a new holder.
305      * REMEMBER THIS IS 0% TRANSFER FEE
306      */
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314 
315         // make sure we have the requested tokens
316         // also disables transfers until ambassador phase is over
317         // ( we dont want whale premines )
318         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
319 
320         // withdraw all outstanding dividends first
321         if(myDividends(true) > 0) withdraw();
322 
323         // exchange tokens
324         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
325         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
326 
327         // update dividend trackers
328         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
329         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
330 
331 
332         // fire event
333         Transfer(_customerAddress, _toAddress, _amountOfTokens);
334 
335         // ERC20
336         return true;
337     }
338 
339     
340     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
341       require(_to != address(0));
342       require(canAcceptTokens_[_to] == true); 
343       require(transfer(_to, _value)); 
344 
345       if (isContract(_to)) {
346         AcceptsToken3D receiver = AcceptsToken3D(_to);
347         require(receiver.tokenFallback(msg.sender, _value, _data));
348       }
349 
350       return true;
351     }
352 
353     
354      function isContract(address _addr) private constant returns (bool is_contract) {
355        // retrieve the size of the code on target address, this needs assembly
356        uint length;
357        assembly { length := extcodesize(_addr) }
358        return length > 0;
359      }
360 
361     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
362     /**
363      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
364      */
365     function disableInitialStage()
366         onlyAdministrator()
367         public
368     {
369         onlyAmbassadors = false;
370     }
371 
372     
373     function setAdministrator(address _identifier, bool _status)
374         onlyAdministrator()
375         public
376     {
377         administrators[_identifier] = _status;
378     }
379 
380     
381     function setStakingRequirement(uint256 _amountOfTokens)
382         onlyAdministrator()
383         public
384     {
385         stakingRequirement = _amountOfTokens;
386     }
387 
388     
389     function setCanAcceptTokens(address _address, bool _value)
390       onlyAdministrator()
391       public
392     {
393       canAcceptTokens_[_address] = _value;
394     }
395 
396     
397     function setName(string _name)
398         onlyAdministrator()
399         public
400     {
401         name = _name;
402     }
403 
404     
405     function setSymbol(string _symbol)
406         onlyAdministrator()
407         public
408     {
409         symbol = _symbol;
410     }
411 
412 
413     /*----------  HELPERS AND CALCULATORS  ----------*/
414     /**
415      * Method to view the current Ethereum stored in the contract
416      * Example: totalEthereumBalance()
417      */
418     function totalEthereumBalance()
419         public
420         view
421         returns(uint)
422     {
423         return this.balance;
424     }
425 
426     /**
427      * Retrieve the total token supply.
428      */
429     function totalSupply()
430         public
431         view
432         returns(uint256)
433     {
434         return tokenSupply_;
435     }
436 
437     /**
438      * Retrieve the tokens owned by the caller.
439      */
440     function myTokens()
441         public
442         view
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return balanceOf(_customerAddress);
447     }
448 
449     
450     function myDividends(bool _includeReferralBonus)
451         public
452         view
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
457     }
458 
459     
460     function balanceOf(address _customerAddress)
461         view
462         public
463         returns(uint256)
464     {
465         return tokenBalanceLedger_[_customerAddress];
466     }
467 
468     
469     function dividendsOf(address _customerAddress)
470         view
471         public
472         returns(uint256)
473     {
474         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
475     }
476 
477     
478     function sellPrice()
479         public
480         view
481         returns(uint256)
482     {
483         // our calculation relies on the token supply, so we need supply. Doh.
484         if(tokenSupply_ == 0){
485             return tokenPriceInitial_ - tokenPriceIncremental_;
486         } else {
487             uint256 _ethereum = tokensToEthereum_(1e18);
488             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, selldividendFee_), 100);
489             uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereum, xFee_), 100);
490             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _xPayout);
491             return _taxedEthereum;
492         }
493     }
494 
495     
496     function buyPrice()
497         public
498         view
499         returns(uint256)
500     {
501         
502         if(tokenSupply_ == 0){
503             return tokenPriceInitial_ + tokenPriceIncremental_;
504         } else {
505             uint256 _ethereum = tokensToEthereum_(1e18);
506             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
507             uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereum, xFee_), 100);
508             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _xPayout);
509             return _taxedEthereum;
510         }
511     }
512 
513     
514     function calculateTokensReceived(uint256 _ethereumToSpend)
515         public
516         view
517         returns(uint256)
518     {
519         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
520         uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, xFee_), 100);
521         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _xPayout);
522         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
523         return _amountOfTokens;
524     }
525 
526     
527     function calculateEthereumReceived(uint256 _tokensToSell)
528         public
529         view
530         returns(uint256)
531     {
532         require(_tokensToSell <= tokenSupply_);
533         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
534         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, selldividendFee_), 100);
535         uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereum, xFee_), 100);
536         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _xPayout);
537         return _taxedEthereum;
538     }
539 
540    
541 
542     /*==========================================
543     =            INTERNAL FUNCTIONS            =
544     ==========================================*/
545 
546     // Make sure we will send back excess if user sends more then 4 ether before 100 ETH in contract
547     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
548       notContract()// no contracts allowed
549       internal
550       returns(uint256) {
551 
552       uint256 purchaseEthereum = _incomingEthereum;
553       uint256 excess;
554       if(purchaseEthereum > 4 ether) { // check if the transaction is over 4 ether
555           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
556               purchaseEthereum = 4 ether;
557               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
558           }
559       }
560 
561       purchaseTokens(purchaseEthereum, _referredBy);
562 
563       if (excess > 0) {
564         msg.sender.transfer(excess);
565       }
566     }
567 
568 
569     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
570         antiEarlyWhale(_incomingEthereum)
571         internal
572         returns(uint256)
573     {
574         // data setup
575         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
576         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
577         uint256 _xPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, xFee_), 100);
578         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
579         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _xPayout);
580 
581         totalEthxCollected = SafeMath.add(totalEthxCollected, _xPayout);
582 
583         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
584         uint256 _fee = _dividends * magnitude;
585 
586         
587         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
588 
589         // is the user referred by a masternode?
590         if(
591             // is this a referred purchase?
592             _referredBy != 0x0000000000000000000000000000000000000000 &&
593 
594             // no cheating!
595             _referredBy != msg.sender &&
596 
597             // does the referrer have at least X whole tokens?
598             // i.e is the referrer a godly chad masternode
599             tokenBalanceLedger_[_referredBy] >= stakingRequirement
600         ){
601             // wealth redistribution
602             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
603         } else {
604             // no ref purchase
605             // add the referral bonus back to the global dividends cake
606             _dividends = SafeMath.add(_dividends, _referralBonus);
607             _fee = _dividends * magnitude;
608         }
609 
610         // we can't give people infinite ethereum
611         if(tokenSupply_ > 0){
612 
613             // add tokens to the pool
614             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
615 
616             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
617             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
618 
619             // calculate the amount of tokens the customer receives over his purchase
620             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
621 
622         } else {
623             // add tokens to the pool
624             tokenSupply_ = _amountOfTokens;
625         }
626 
627         // update circulating supply & the ledger address for the customer
628         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
629 
630         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
631         //really i know you think you do but you don't
632         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
633         payoutsTo_[msg.sender] += _updatedPayouts;
634 
635         // fire event
636         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
637 
638         return _amountOfTokens;
639     }
640 
641     /**
642      * Calculate Token price based on an amount of incoming ethereum
643      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
644      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
645      */
646     function ethereumToTokens_(uint256 _ethereum)
647         internal
648         view
649         returns(uint256)
650     {
651         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
652         uint256 _tokensReceived =
653          (
654             (
655                 // underflow attempts BTFO
656                 SafeMath.sub(
657                     (sqrt
658                         (
659                             (_tokenPriceInitial**2)
660                             +
661                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
662                             +
663                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
664                             +
665                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
666                         )
667                     ), _tokenPriceInitial
668                 )
669             )/(tokenPriceIncremental_)
670         )-(tokenSupply_)
671         ;
672 
673         return _tokensReceived;
674     }
675 
676     /**
677      * Calculate token sell value.
678      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
679      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
680      */
681      function tokensToEthereum_(uint256 _tokens)
682         internal
683         view
684         returns(uint256)
685     {
686 
687         uint256 tokens_ = (_tokens + 1e18);
688         uint256 _tokenSupply = (tokenSupply_ + 1e18);
689         uint256 _etherReceived =
690         (
691             // underflow attempts BTFO
692             SafeMath.sub(
693                 (
694                     (
695                         (
696                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
697                         )-tokenPriceIncremental_
698                     )*(tokens_ - 1e18)
699                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
700             )
701         /1e18);
702         return _etherReceived;
703     }
704 
705 
706     //This is where all your gas goes, sorry
707     //Not sorry, you probably only paid 1 gwei
708     function sqrt(uint x) internal pure returns (uint y) {
709         uint z = (x + 1) / 2;
710         y = x;
711         while (z < y) {
712             y = z;
713             z = (x / z + z) / 2;
714         }
715     }
716 }
717 
718 /**
719  * @title SafeMath
720  * @dev Math operations with safety checks that throw on error
721  */
722 library SafeMath {
723 
724     /**
725     * @dev Multiplies two numbers, throws on overflow.
726     */
727     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
728         if (a == 0) {
729             return 0;
730         }
731         uint256 c = a * b;
732         assert(c / a == b);
733         return c;
734     }
735 
736     /**
737     * @dev Integer division of two numbers, truncating the quotient.
738     */
739     function div(uint256 a, uint256 b) internal pure returns (uint256) {
740         // assert(b > 0); // Solidity automatically throws when dividing by 0
741         uint256 c = a / b;
742         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
743         return c;
744     }
745 
746     /**
747     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
748     */
749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
750         assert(b <= a);
751         return a - b;
752     }
753 
754     /**
755     * @dev Adds two numbers, throws on overflow.
756     */
757     function add(uint256 a, uint256 b) internal pure returns (uint256) {
758         uint256 c = a + b;
759         assert(c >= a);
760         return c;
761     }
762 }