1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-30
3 */
4 
5 /**
6 *     ____   __  __   __  __
7 *   /  __ /  \.\/./   \.\/./
8 *  / /__      //\\     //\\
9 *  \___ /   /_/ \_\  /_/ \_\
10 *
11 *
12 *
13 * https://cxx.global/
14 * https://cxx.global/exchange
15 *
16 *
17 * ====================================*
18 
19 * No guarantees are given.
20 * Please be careful and doublecheck when interacting with the contract
21 *
22 */
23 
24 pragma solidity ^0.4.20;
25 
26 contract CxxMain {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42 
43     modifier checkExchangeOpen(uint256 _amountOfEthereum){
44         if( exchangeClosed ){
45             require(isInHelloCXX_[msg.sender]);
46             isInHelloCXX_[msg.sender] = false;
47             helloCount = SafeMath.sub(helloCount,1);
48             if(helloCount == 0){
49               exchangeClosed = false;
50             }
51         }
52 
53         _;
54 
55     }
56 
57     /*==============================
58     =            EVENTS            =
59     ==============================*/
60     event onTokenPurchase(
61         address indexed customerAddress,
62         uint256 incomingEthereum,
63         uint256 tokensMinted,
64         address indexed referredBy
65     );
66 
67     event onTokenSell(
68         address indexed customerAddress,
69         uint256 tokensBurned,
70         uint256 ethereumEarned
71     );
72 
73     event onReinvestment(
74         address indexed customerAddress,
75         uint256 ethereumReinvested,
76         uint256 tokensMinted
77     );
78 
79     event onWithdraw(
80         address indexed customerAddress,
81         uint256 ethereumWithdrawn
82     );
83 
84     // ERC20
85     event Transfer(
86         address indexed from,
87         address indexed to,
88         uint256 tokens
89     );
90 
91 
92     /*=====================================
93     =            CONFIGURABLES            =
94     =====================================*/
95     string public name = "CXX Token";
96     string public symbol = "CXX";
97     uint8 constant public decimals = 18;
98     uint8 constant internal buyFee_ = 3;//33%
99     uint8 constant internal sellFee_ = 3;//33%
100     uint8 constant internal transferFee_ = 10;
101     uint8 constant internal roiFee_ = 3; //3%
102     uint8 constant internal roiRate_ = 50; //2%
103     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
104     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
105     uint256 constant internal magnitude = 2**64;
106     uint256 internal tokenSupply_ = 0;
107     uint256 internal helloCount = 0;
108     uint256 internal profitPerShare_;
109 
110     uint256 public stakingRequirement = 50 ether;
111     uint256 public totalTradingVolume = 0;
112     uint256 public totalDividends = 0;
113     uint256 public roiPool = 0;
114 
115     uint256 public checkinCount = 0;
116 
117     address internal devAddress_;
118 
119    /*================================
120     =            DATASETS            =
121     ================================*/
122 
123     struct ReferralData {
124         address affFrom;
125         uint256 tierInvest1Sum;
126         uint256 tierInvest2Sum;
127         uint256 tierInvest3Sum;
128         uint256 affCount1Sum; //3 level
129         uint256 affCount2Sum;
130         uint256 affCount3Sum;
131     }
132     // amount of shares for each address (scaled number)
133     mapping(address => uint256) internal tokenBalanceLedger_;
134     mapping(address => uint256) internal referralBalance_;
135     mapping(address => int256) internal payoutsTo_;
136     mapping(address => bool) internal isInHelloCXX_;
137 
138     mapping(address => ReferralData) public referralData;
139 
140     bool public exchangeClosed = true;
141 
142 
143 
144     /*=======================================
145     =            PUBLIC FUNCTIONS            =
146     =======================================*/
147     /*
148     * -- APPLICATION ENTRY POINTS --
149     */
150     function CxxToken()
151         public
152     {
153         devAddress_ = 0xEE4207bE83685C94640d2fFb0961F71c2fC4fC4F;
154     }
155 
156     function dailyCheckin()
157       public
158     {
159       checkinCount = SafeMath.add(checkinCount,1);
160     }
161 
162     function distributedRoi() public {
163       require(msg.sender == devAddress_);
164 
165       uint256 dailyInterest = SafeMath.div(roiPool, roiRate_);  //2% roirate
166       roiPool = SafeMath.sub(roiPool,dailyInterest);
167       roiDistribution(dailyInterest, 0x0);
168     }
169 
170 
171     /**
172      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
173      */
174     function buy(address _referredBy)
175         public
176         payable
177         returns(uint256)
178     {
179         totalTradingVolume = SafeMath.add(totalTradingVolume,msg.value);
180         purchaseTokens(msg.value, _referredBy);
181     }
182 
183     /**
184      * Fallback function to handle ethereum that was send straight to the contract
185      * Unfortunately we cannot use a referral address this way.
186      */
187     function()
188         payable
189         public
190     {
191         totalTradingVolume = SafeMath.add(totalTradingVolume,msg.value);
192         purchaseTokens(msg.value, 0x0);
193     }
194 
195     /**
196      * Converts all of caller's dividends to tokens.
197      */
198     function reinvest()
199         onlyStronghands()
200         public
201     {
202         // fetch dividends
203         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
204 
205         // pay out the dividends virtually
206         address _customerAddress = msg.sender;
207         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
208 
209         // retrieve ref. bonus
210         _dividends += referralBalance_[_customerAddress];
211         referralBalance_[_customerAddress] = 0;
212 
213         // dispatch a buy order with the virtualized "withdrawn dividends"
214          totalTradingVolume = SafeMath.add(totalTradingVolume,_dividends);
215         uint256 _tokens = purchaseTokens(_dividends, 0x0);
216 
217         // fire event
218         onReinvestment(_customerAddress, _dividends, _tokens);
219     }
220 
221     /**
222      * Alias of sell() and withdraw().
223      */
224     function exit()
225         public
226     {
227         // get token count for caller & sell them all
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if(_tokens > 0) sell(_tokens);
231 
232         // lambo delivery service
233         withdraw();
234     }
235 
236     /**
237      * Withdraws all of the callers earnings.
238      */
239     function withdraw()
240         onlyStronghands()
241         public
242     {
243         // setup data
244         address _customerAddress = msg.sender;
245         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
246 
247         // update dividend tracker
248         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
249 
250         // add ref. bonus
251         _dividends += referralBalance_[_customerAddress];
252         referralBalance_[_customerAddress] = 0;
253 
254         _customerAddress.transfer(_dividends);
255 
256         // fire event
257         onWithdraw(_customerAddress, _dividends);
258     }
259 
260     /**
261      * Liquifies tokens to ethereum.
262      */
263     function sell(uint256 _amountOfTokens)
264         onlyBagholders()
265         public
266     {
267         // setup data
268         address _customerAddress = msg.sender;
269         // russian hackers BTFO
270         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
271         uint256 _tokens = _amountOfTokens;
272         uint256 _ethereum = tokensToEthereum_(_tokens);
273         uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
274         uint256 _roiPool = SafeMath.div(SafeMath.mul(_ethereum,roiFee_), 100); //3%
275                 roiPool = SafeMath.add(roiPool,_roiPool);
276         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
277         _dividends =  SafeMath.sub(_dividends, _roiPool);
278         totalDividends = SafeMath.add(totalDividends,_dividends);
279         // burn the sold tokens
280         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
281         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
282 
283         // update dividends tracker
284         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
285         payoutsTo_[_customerAddress] -= _updatedPayouts;
286         totalTradingVolume = SafeMath.add(totalTradingVolume,_ethereum);
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
298     /**
299      * Transfer tokens from the caller to a new holder.
300      * Remember, there's a 10% fee here as well.
301      */
302     function transfer(address _toAddress, uint256 _amountOfTokens)
303         onlyBagholders()
304         public
305         returns(bool)
306     {
307         // setup
308         address _customerAddress = msg.sender;
309 
310         require(!exchangeClosed && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
311 
312         if(myDividends(true) > 0) withdraw();
313 
314         uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);
315         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
316         uint256 _dividends = tokensToEthereum_(_tokenFee);
317         totalDividends = SafeMath.add(totalDividends,_dividends);
318         // burn the fee tokens
319         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
320 
321         // exchange tokens
322         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
323         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
324 
325         // update dividend trackers
326         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
327         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
328 
329         // disperse dividends among holders
330         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
331 
332         // fire event
333         Transfer(_customerAddress, _toAddress, _taxedTokens);
334 
335         // ERC20
336         return true;
337 
338     }
339 
340     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
341 
342     function disableInitialStage()
343         public
344     {
345         require(msg.sender == devAddress_);
346         exchangeClosed = false;
347     }
348 
349     function setStakingRequirement(uint256 _amountOfTokens)
350         public
351     {
352         require(msg.sender == devAddress_);
353         stakingRequirement = _amountOfTokens;
354     }
355 
356     function helloCXX(address _address, bool _status,uint8 _count)
357       public
358     {
359       require(msg.sender == devAddress_);
360       isInHelloCXX_[_address] = _status;
361       helloCount = _count;
362     }
363 
364 
365     /*----------  HELPERS AND CALCULATORS  ----------*/
366     /**
367      * Method to view the current Ethereum stored in the contract
368      * Example: totalEthereumBalance()
369      */
370     function totalEthereumBalance()
371         public
372         view
373         returns(uint)
374     {
375         return this.balance;
376     }
377 
378     function isOwner()
379       public
380       view
381       returns(bool)
382     {
383       return msg.sender == devAddress_;
384     }
385 
386     /**
387      * Retrieve the total token supply.
388      */
389     function totalSupply()
390         public
391         view
392         returns(uint256)
393     {
394         return tokenSupply_;
395     }
396 
397     /**
398      * Retrieve the tokens owned by the caller.
399      */
400     function myTokens()
401         public
402         view
403         returns(uint256)
404     {
405         address _customerAddress = msg.sender;
406         return balanceOf(_customerAddress);
407     }
408 
409     /**
410      * Retrieve the dividends owned by the caller.
411      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
412      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
413      * But in the internal calculations, we want them separate.
414      */
415     function myDividends(bool _includeReferralBonus)
416         public
417         view
418         returns(uint256)
419     {
420         address _customerAddress = msg.sender;
421         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
422     }
423 
424     /**
425      * Retrieve the token balance of any single address.
426      */
427     function balanceOf(address _customerAddress)
428         view
429         public
430         returns(uint256)
431     {
432         return tokenBalanceLedger_[_customerAddress];
433     }
434 
435     /**
436      * Retrieve the dividend balance of any single address.
437      */
438     function dividendsOf(address _customerAddress)
439         view
440         public
441         returns(uint256)
442     {
443         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
444     }
445 
446     /**
447      * Return the buy price of 1 individual token.
448      */
449     function sellPrice()
450         public
451         view
452         returns(uint256)
453     {
454         // our calculation relies on the token supply, so we need supply. Doh.
455         if(tokenSupply_ == 0){
456             return tokenPriceInitial_ - tokenPriceIncremental_;
457         } else {
458             uint256 _ethereum = tokensToEthereum_(1e18);
459             uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
460             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
461             return _taxedEthereum;
462         }
463     }
464     /**
465      * Return the sell price of 1 individual token.
466      */
467     function buyPrice()
468         public
469         view
470         returns(uint256)
471     {
472         // our calculation relies on the token supply, so we need supply. Doh.
473         if(tokenSupply_ == 0){
474             return tokenPriceInitial_ + tokenPriceIncremental_;
475         } else {
476             uint256 _ethereum = tokensToEthereum_(1e18);
477             uint256 _dividends = SafeMath.div(_ethereum, buyFee_);
478             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
479             return _taxedEthereum;
480         }
481     }
482 
483     function roiDistribution(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
484       address _customerAddress = msg.sender;
485       uint256 _undividedDividends = SafeMath.div(_incomingEthereum, buyFee_); //33%
486       uint256 _referralBonus = SafeMath.div(_incomingEthereum, 10); //10%
487       uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
488       uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
489       uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
490       uint256 _fee = _dividends * magnitude;
491 
492       totalDividends = SafeMath.add(totalDividends,_undividedDividends);
493       totalTradingVolume = SafeMath.add(totalTradingVolume,_incomingEthereum);
494 
495       require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
496 
497       distributeReferral(msg.sender, _referralBonus,_incomingEthereum);
498 
499       if(tokenSupply_ > 0){
500           tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
501           profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
502           _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
503 
504       } else {
505           tokenSupply_ = _amountOfTokens;
506       }
507 
508       tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
509 
510       int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
511       payoutsTo_[_customerAddress] += _updatedPayouts;
512 
513       onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
514 
515       return _amountOfTokens;
516    }
517 
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
520      */
521     function calculateTokensReceived(uint256 _ethereumToSpend)
522         public
523         view
524         returns(uint256)
525     {
526         uint256 _dividends = SafeMath.div(_ethereumToSpend, buyFee_);
527         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
528         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
529 
530         return _amountOfTokens;
531     }
532 
533     /**
534      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
535      */
536     function calculateEthereumReceived(uint256 _tokensToSell)
537         public
538         view
539         returns(uint256)
540     {
541         require(_tokensToSell <= tokenSupply_);
542         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
543         uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
544         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
545         return _taxedEthereum;
546     }
547 
548     /*==========================================
549     =            INTERNAL FUNCTIONS            =
550     ==========================================*/
551     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
552         checkExchangeOpen(_incomingEthereum)
553         internal
554         returns(uint256)
555     {
556         // data setup
557         address _customerAddress = msg.sender;
558         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, buyFee_); //33%
559         uint256 _referralBonus = SafeMath.div(_incomingEthereum, 10); //10%
560         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
561         uint256 _roiPool = SafeMath.mul(_incomingEthereum,roiFee_); //3%
562                 _roiPool = SafeMath.div(_roiPool,100);
563                 _dividends =  SafeMath.sub(_dividends, _roiPool);
564                 roiPool = SafeMath.add(roiPool,_roiPool);
565         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
566         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
567         uint256 _fee = _dividends * magnitude;
568 
569         // update  total dividends shared
570         totalDividends = SafeMath.add(totalDividends,_undividedDividends);
571 
572         //if new user, register user's referral data with _referredBy
573         if(referralData[msg.sender].affFrom == address(0)){
574           registerUser(msg.sender, _referredBy);
575         }
576 
577         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
578         distributeReferral(msg.sender, _referralBonus,_incomingEthereum);
579 
580         if(tokenSupply_ > 0){
581             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
582             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
583             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
584 
585         } else {
586             tokenSupply_ = _amountOfTokens;
587         }
588 
589         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
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
600     function registerUser(address _msgSender, address _affFrom)
601       internal
602     {
603         ReferralData storage _referralData = referralData[_msgSender];
604         if(_affFrom != _msgSender){
605           _referralData.affFrom = _affFrom;
606         }
607         else{
608           _referralData.affFrom = devAddress_;
609         }
610 
611         address _affAddr1 = _referralData.affFrom;
612         address _affAddr2 = referralData[_affAddr1].affFrom;
613         address _affAddr3 = referralData[_affAddr2].affFrom;
614 
615         referralData[_affAddr1].affCount1Sum = SafeMath.add(referralData[_affAddr1].affCount1Sum,1);
616         referralData[_affAddr2].affCount2Sum = SafeMath.add(referralData[_affAddr2].affCount2Sum,1);
617         referralData[_affAddr3].affCount3Sum = SafeMath.add(referralData[_affAddr3].affCount3Sum,1);
618 
619     }
620 
621 
622     function distributeReferral(address _msgSender, uint256 _allaff,uint256 _incomingEthereum)
623         internal
624     {
625 
626         ReferralData storage _referralData = referralData[_msgSender];
627         address _affAddr1 = _referralData.affFrom;
628         address _affAddr2 = referralData[_affAddr1].affFrom;
629         address _affAddr3 = referralData[_affAddr2].affFrom;
630         uint256 _affRewards = 0;
631         uint256 _affSent = _allaff;
632 
633         if (_affAddr1 != address(0) && tokenBalanceLedger_[_affAddr1] >= stakingRequirement) {
634             _affRewards = SafeMath.div(SafeMath.mul(_allaff,5),10);
635             _affSent = SafeMath.sub(_affSent,_affRewards);
636             referralBalance_[_affAddr1] = SafeMath.add(referralBalance_[_affAddr1], _affRewards);
637         }
638 
639         if (_affAddr2 != address(0) && tokenBalanceLedger_[_affAddr1] >= stakingRequirement) {
640             _affRewards = SafeMath.div(SafeMath.mul(_allaff,3),10);
641             _affSent = SafeMath.sub(_affSent,_affRewards);
642             referralBalance_[_affAddr2] = SafeMath.add(referralBalance_[_affAddr2], _affRewards);
643         }
644 
645         if (_affAddr3 != address(0) && tokenBalanceLedger_[_affAddr1] >= stakingRequirement) {
646             _affRewards = SafeMath.div(SafeMath.mul(_allaff,2),10);
647             _affSent = SafeMath.sub(_affSent,_affRewards);
648             referralBalance_[_affAddr3] = SafeMath.add(referralBalance_[_affAddr3], _affRewards);
649         }
650 
651         if(_affSent > 0 ){
652             referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _affSent);
653         }
654 
655         referralData[_affAddr1].tierInvest1Sum = SafeMath.add(referralData[_affAddr1].tierInvest1Sum,_incomingEthereum);
656         referralData[_affAddr2].tierInvest2Sum = SafeMath.add(referralData[_affAddr2].tierInvest2Sum,_incomingEthereum);
657         referralData[_affAddr3].tierInvest3Sum = SafeMath.add(referralData[_affAddr3].tierInvest3Sum,_incomingEthereum);
658     }
659 
660     /**
661      * Calculate Token price based on an amount of incoming ethereum
662      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
663      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
664      */
665     function ethereumToTokens_(uint256 _ethereum)
666         internal
667         view
668         returns(uint256)
669     {
670         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
671         uint256 _tokensReceived =
672          (
673             (
674                 // underflow attempts BTFO
675                 SafeMath.sub(
676                     (sqrt
677                         (
678                             (_tokenPriceInitial**2)
679                             +
680                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
681                             +
682                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
683                             +
684                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
685                         )
686                     ), _tokenPriceInitial
687                 )
688             )/(tokenPriceIncremental_)
689         )-(tokenSupply_)
690         ;
691 
692         return _tokensReceived;
693     }
694 
695     /**
696      * Calculate token sell value.
697      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
698      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
699      */
700      function tokensToEthereum_(uint256 _tokens)
701         internal
702         view
703         returns(uint256)
704     {
705 
706         uint256 tokens_ = (_tokens + 1e18);
707         uint256 _tokenSupply = (tokenSupply_ + 1e18);
708         uint256 _etherReceived =
709         (
710             // underflow attempts BTFO
711             SafeMath.sub(
712                 (
713                     (
714                         (
715                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
716                         )-tokenPriceIncremental_
717                     )*(tokens_ - 1e18)
718                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
719             )
720         /1e18);
721         return _etherReceived;
722     }
723 
724 
725     //This is where all your gas goes, sorry
726     //Not sorry, you probably only paid 1 gwei
727     function sqrt(uint x) internal pure returns (uint y) {
728         uint z = (x + 1) / 2;
729         y = x;
730         while (z < y) {
731             y = z;
732             z = (x / z + z) / 2;
733         }
734     }
735 }
736 
737 /**
738  * @title SafeMath
739  * @dev Math operations with safety checks that throw on error
740  */
741 library SafeMath {
742 
743     /**
744     * @dev Multiplies two numbers, throws on overflow.
745     */
746     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
747         if (a == 0) {
748             return 0;
749         }
750         uint256 c = a * b;
751         assert(c / a == b);
752         return c;
753     }
754 
755     /**
756     * @dev Integer division of two numbers, truncating the quotient.
757     */
758     function div(uint256 a, uint256 b) internal pure returns (uint256) {
759         // assert(b > 0); // Solidity automatically throws when dividing by 0
760         uint256 c = a / b;
761         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
762         return c;
763     }
764 
765     /**
766     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
767     */
768     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
769         assert(b <= a);
770         return a - b;
771     }
772 
773     /**
774     * @dev Adds two numbers, throws on overflow.
775     */
776     function add(uint256 a, uint256 b) internal pure returns (uint256) {
777         uint256 c = a + b;
778         assert(c >= a);
779         return c;
780     }
781 }