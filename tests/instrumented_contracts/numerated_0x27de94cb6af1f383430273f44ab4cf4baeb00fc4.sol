1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://metadollar.org - Copyright 2018
5 *
6 * METADOLLAR DYNAMIC FUND SMART CONTRACT
7 *
8 * Dynamic withdraw fee depending on total token supply(10% to 2%).
9 * Initial withdraw fee during the first 30 days from launch(30% to 6%).
10 * The two combined withdraw fees go from max 40% to min 8%.
11 * Deposit fee at 10%.
12 * Developers, marketing and website maintenence fee at 3%(from withdraw).
13 * 5 levels of earning from referral.
14 * Anti-dump price optimization to eliminate eccessive volatility and speculation attacks.
15 */
16 
17 contract METADOLLAR {
18 
19     /**
20      * Only with tokens
21      */
22     modifier onlyBagholders {
23         require(myTokens() > 0);
24         _;
25     }
26 
27     /**
28      * Only with dividends
29      */
30     modifier onlyStronghands {
31         require(myDividends(true) > 0);
32         _;
33     }
34 
35     event onTokenPurchase(
36         address indexed customerAddress,
37         uint256 incomingEthereum,
38         uint256 tokensMinted,
39         uint timestamp,
40         uint256 price
41     );
42 
43     event onTokenSell(
44         address indexed customerAddress,
45         uint256 tokensBurned,
46         uint256 ethereumEarned,
47         uint timestamp,
48         uint256 price
49     );
50 
51     event onReinvestment(
52         address indexed customerAddress,
53         uint256 ethereumReinvested
54     );
55 
56     event onWithdraw(
57         address indexed customerAddress,
58         uint256 ethereumWithdrawn
59     );
60 
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 tokens
65     );
66 
67     string public name = "METADOLLAR DYNAMIC FUND";
68     string public symbol = "MDY";
69     uint public createdAt;
70     
71     bool public started = true;
72     modifier onlyStarted {
73         require(started);
74         _;
75     }
76     modifier onlyNotStarted {
77         require(!started);
78         _;
79     }
80 
81     uint8 constant public decimals = 18;
82 
83     /**
84      * fees
85      */
86     uint8 constant internal entryFee_ = 10;
87     uint8 constant internal ownerFee_ = 3;
88     uint8 constant internal transferFee_ = 1;
89     uint8 constant internal exitFeeD0_ = 30;
90     uint8 constant internal exitFee_ = 6;
91     uint8 constant internal exitFeeD2_ = 15;
92     uint8 constant internal exitFee2_ = 2;
93     uint8 constant internal referralFee_ = 33;
94 
95     address internal _ownerAddress;
96 
97     /**
98      * Initial token values
99      */
100     uint256 constant internal tokenPriceInitial_ = 1 ether;
101     uint256 constant internal tokenPriceIncremental_ = 0.0001 ether;
102 
103     uint256 constant internal magnitude = 2 ** 64;
104 
105 
106     mapping(address => uint256) internal tokenBalanceLedger_;
107     mapping(address => uint256) internal referralBalance_;
108     mapping(address => int256) internal payoutsTo_;
109     mapping(address => uint256) internal summaryReferralProfit_;
110     mapping(address => uint256) internal dividendsUsed_;
111 
112     uint256 internal tokenSupply_;
113     uint256 internal profitPerShare_;
114     
115     uint public blockCreation;
116     
117     /**
118      * Admins. Only rename tokens, change referral settings and add new admins
119      */
120     mapping(bytes32 => bool) public administrators;
121     modifier onlyAdministrator(){
122         address _customerAddress = msg.sender;
123         require(administrators[keccak256(_customerAddress)]);
124         _;
125     }
126 
127     function isAdmin() public view returns (bool) {
128         return administrators[keccak256(msg.sender)];
129     }
130 
131     function setAdministrator(address _id, bool _status)
132         onlyAdministrator()
133         public
134     {
135         if (_id != _ownerAddress) {
136             administrators[keccak256(_id)] = _status;
137         }
138     } 
139 
140     function setName(string _name)
141         onlyAdministrator()
142         public
143     {
144         name = _name;
145     }
146 
147     function setSymbol(string _symbol)
148         onlyAdministrator()
149         public
150     {
151         symbol = _symbol;
152     }
153 
154     constructor() public {
155         _ownerAddress = msg.sender;
156         administrators[keccak256(_ownerAddress)] = true;
157         blockCreation = block.number;
158     }
159     
160     function start() onlyNotStarted() onlyAdministrator() public {
161         started = true;
162         createdAt = block.timestamp;
163     }
164     
165     function getLifetime() public view returns (uint8) {
166         if (!started)
167         {
168             return 0;
169         }
170         return (uint8) ((now - createdAt) / 60 / 60 / 24);
171     }
172     
173     function getSupply() public view returns (uint256) {
174        
175         return totalSupply();
176     }
177     
178     function getExitFee2() public view returns (uint8) {
179         uint tsupply = getSupply();
180         if (tsupply <= 1e18) { 
181             return exitFeeD2_; // 10%
182         } else if (tsupply > 1e18 && tsupply <= 2e18) {
183             return (uint8) (exitFeeD0_  - 1); // 9%
184         } else if (tsupply > 2e18 && tsupply <= 3e18) {
185             return (uint8) (exitFeeD0_  - 2); // 8%
186         } else if (tsupply > 3e18 && tsupply <= 5e18) {
187             return (uint8) (exitFeeD0_  - 3); // 7%
188         } else if (tsupply > 5e18 && tsupply <= 10e18) {
189             return (uint8) (exitFeeD0_  - 4); // 6%
190         } else if (tsupply > 10e18 && tsupply <= 50e18) {
191             return (uint8) (exitFeeD0_  - 5); // 5%
192         } else if (tsupply > 50e18 && tsupply <= 100e18) {
193             return (uint8) (exitFeeD0_  - 6); // 4%
194         } else if (tsupply > 100e18 && tsupply <= 1000e18) {
195             return (uint8) (exitFeeD0_  - 7); // 3%
196         } else {
197             return exitFee2_; // 2% with a token supply of over 1000
198         }
199     }
200     
201     function getExitFee() public view returns (uint8) {
202         uint lifetime = getLifetime();
203         if (lifetime <= 6) { 
204             return exitFeeD2_; // 30%
205         } else if (lifetime < 30) {
206             return (uint8) (exitFeeD0_ - lifetime + 6);// first 30 days from launch 30% to 7% + dynamic fee(10% to 2%)
207         } else {
208             return exitFee_ + getExitFee2(); // after 30 days from launch 6% + dynamic fee(10% to 2%)
209         }
210     }
211 
212     function buy(address _r1, address _r2, address _r3, address _r4, address _r5) onlyStarted() public payable returns (uint256) {
213         purchaseTokens(msg.value, _r1, _r2, _r3, _r4, _r5);
214     }
215 
216     function reinvest() onlyStronghands public {
217         uint256 _dividends = myDividends(false);
218         address _customerAddress = msg.sender;
219         dividendsUsed_[_customerAddress] += _dividends;
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221         _dividends += referralBalance_[_customerAddress];
222         referralBalance_[_customerAddress] = 0;
223         purchaseTokens(_dividends, 0x0, 0x0, 0x0, 0x0, 0x0);
224         emit onReinvestment(_customerAddress, _dividends);
225     }
226 
227     function exit() public {
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if (_tokens > 0) sell(_tokens);
231         withdraw();
232     }
233 
234     function withdraw() onlyStronghands public {
235         address _customerAddress = msg.sender;
236         uint256 _dividends = myDividends(false);
237         dividendsUsed_[_customerAddress] += _dividends;
238         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
239         _dividends += referralBalance_[_customerAddress];
240         referralBalance_[_customerAddress] = 0;
241         
242         uint256 _fee = SafeMath.div(SafeMath.mul(_dividends, getExitFee() - 3), 100);
243         
244         uint256 _ownerFee = SafeMath.div(SafeMath.mul(_dividends, 3), 100);
245         
246         uint256 _dividendsTaxed = SafeMath.sub(_dividends, _fee + _ownerFee);
247         
248         if (_customerAddress != _ownerAddress) {
249             referralBalance_[_ownerAddress] += _ownerFee;
250             summaryReferralProfit_[_ownerAddress] += _ownerFee;
251         } else {
252             _dividendsTaxed += _ownerFee;
253         }
254         
255         profitPerShare_ = SafeMath.add(profitPerShare_, (_fee * magnitude) / tokenSupply_);
256     
257         _customerAddress.transfer(_dividendsTaxed);
258         emit onWithdraw(_customerAddress, _dividends);
259     }
260 
261     function sell(uint256 _amountOfTokens) onlyBagholders public {
262         address _customerAddress = msg.sender;
263         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
264         uint256 _tokens = _amountOfTokens;
265         uint256 _ethereum = tokensToEthereum_(_tokens);
266 
267         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
268         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
269 
270         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_ethereum * magnitude));
271         payoutsTo_[_customerAddress] -= _updatedPayouts;
272 
273         emit onTokenSell(_customerAddress, _tokens, _ethereum, now, buyPrice());
274     }
275 
276     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
277         address _customerAddress = msg.sender;
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279 
280         if (myDividends(true) > 0) {
281             withdraw();
282         }
283 
284         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
285         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
286         uint256 _dividends = tokensToEthereum_(_tokenFee);
287 
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
289         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
290         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
291         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
292         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
293         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
294         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
295         return true;
296     }
297 
298 
299     function totalEthereumBalance() public view returns (uint256) {
300         return address(this).balance;
301     }
302 
303     function totalSupply() public view returns (uint256) {
304         return tokenSupply_;
305     }
306 
307     function myTokens() public view returns (uint256) {
308         address _customerAddress = msg.sender;
309         return balanceOf(_customerAddress);
310     }
311 
312     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
313         address _customerAddress = msg.sender;
314         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
315     }
316 
317     function balanceOf(address _customerAddress) public view returns (uint256) {
318         return tokenBalanceLedger_[_customerAddress];
319     }
320 
321     function dividendsOf(address _customerAddress) public view returns (uint256) {
322         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
323     }
324     
325     function dividendsFull(address _customerAddress) public view returns (uint256) {
326         return dividendsOf(_customerAddress) + dividendsUsed_[_customerAddress] + summaryReferralProfit_[_customerAddress];
327     }
328 
329     function sellPrice() public view returns (uint256) {
330         return sellPriceAt(tokenSupply_);
331     }
332 
333     function buyPrice() public view returns (uint256) {
334         if (tokenSupply_ == 0) {
335             return tokenPriceInitial_ + tokenPriceIncremental_;
336         } else {
337             uint256 _ethereum = tokensToEthereum_(1e18);
338             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
339             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
340 
341             return _taxedEthereum;
342         }
343     }
344 
345     function calculateTokensReceived(uint256 _incomingEthereum) public view returns (uint256) {
346         uint256 _dividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
347         
348         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
349         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
350 
351         return _amountOfTokens;
352     }
353 
354     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
355         require(_tokensToSell <= tokenSupply_);
356         return tokensToEthereum_(_tokensToSell);
357     }
358     
359     uint256 public I_S = 0.25 ether;
360     uint256 public I_R1 = 30;
361 
362     function setI_S(uint256 _v)
363         onlyAdministrator()
364         public
365     {
366         I_S = _v;
367     }
368 
369     function setI_R1(uint256 _v)
370         onlyAdministrator()
371         public
372     {
373         I_R1 = _v;
374     }
375 
376     
377     uint256 public II_S = 5 ether;
378     uint256 public II_R1 = 30;
379     uint256 public II_R2 = 10;
380 
381     function setII_S(uint256 _v)
382         onlyAdministrator()
383         public
384     {
385         II_S = _v;
386     }
387 
388     function setII_R1(uint256 _v)
389         onlyAdministrator()
390         public
391     {
392         II_R1 = _v;
393     }
394 
395     function setII_R2(uint256 _v)
396         onlyAdministrator()
397         public
398     {
399         II_R2 = _v;
400     }
401     
402     uint256 public III_S = 10 ether;
403     uint256 public III_R1 = 30;
404     uint256 public III_R2 = 10;
405     uint256 public III_R3 = 10;
406 
407     function setIII_S(uint256 _v)
408         onlyAdministrator()
409         public
410     {
411         III_S = _v;
412     }
413 
414     function setIII_R1(uint256 _v)
415         onlyAdministrator()
416         public
417     {
418         III_R1 = _v;
419     }
420 
421     function setIII_R2(uint256 _v)
422         onlyAdministrator()
423         public
424     {
425         III_R2 = _v;
426     }
427 
428     function setIII_R3(uint256 _v)
429         onlyAdministrator()
430         public
431     {
432         III_R3 = _v;
433     }
434     
435     uint256 public IV_S = 20 ether;
436     uint256 public IV_R1 = 30;
437     uint256 public IV_R2 = 20;
438     uint256 public IV_R3 = 10;
439     uint256 public IV_R4 = 10;
440 
441     function setIV_S(uint256 _v)
442         onlyAdministrator()
443         public
444     {
445         IV_S = _v;
446     }
447 
448     function setIV_R1(uint256 _v)
449         onlyAdministrator()
450         public
451     {
452         IV_R1 = _v;
453     }
454 
455     function setIV_R2(uint256 _v)
456         onlyAdministrator()
457         public
458     {
459         IV_R2 = _v;
460     }
461 
462     function setIV_R3(uint256 _v)
463         onlyAdministrator()
464         public
465     {
466         IV_R3 = _v;
467     }
468 
469     function setIV_R4(uint256 _v)
470         onlyAdministrator()
471         public
472     {
473         IV_R4 = _v;
474     }
475     
476     uint256 public V_S = 100 ether;
477     uint256 public V_R1 = 40;
478     uint256 public V_R2 = 20;
479     uint256 public V_R3 = 10;
480     uint256 public V_R4 = 10;
481     uint256 public V_R5 = 10;
482 
483     function setV_S(uint256 _v)
484         onlyAdministrator()
485         public
486     {
487         V_S = _v;
488     }
489 
490     function setV_R1(uint256 _v)
491         onlyAdministrator()
492         public
493     {
494         V_R1 = _v;
495     }
496 
497     function setV_R2(uint256 _v)
498         onlyAdministrator()
499         public
500     {
501         V_R2 = _v;
502     }
503 
504     function setV_R3(uint256 _v)
505         onlyAdministrator()
506         public
507     {
508         V_R3 = _v;
509     }
510 
511     function setV_R4(uint256 _v)
512         onlyAdministrator()
513         public
514     {
515         V_R4 = _v;
516     }
517 
518     function setV_R5(uint256 _v)
519         onlyAdministrator()
520         public
521     {
522         V_R5 = _v;
523     }
524     
525     function canRef(address _r, address _c, uint256 _m) internal returns (bool) {
526         return _r != 0x0000000000000000000000000000000000000000 && _r != _c && tokenBalanceLedger_[_r] >= _m;
527     }
528     
529     function etherBalance(address r) internal returns (uint256) {
530         uint _v = tokenBalanceLedger_[r];
531         if (_v < 0.00000001 ether) {
532             return 0;
533         } else {
534             return tokensToEthereum_(_v);
535         }
536     }
537     
538     function getLevel(address _cb) public view returns (uint256) {
539         uint256 _b = etherBalance(_cb);
540         uint256 _o = 0;
541         
542         if (_b >= V_S) {
543             _o = 5;
544         } else if (_b >= IV_S) {
545             _o = 4;
546         } else if (_b >= III_S) {
547             _o = 3;
548         } else if (_b >= II_S) {
549             _o = 2;
550         } else if (_b >= I_S) {
551             _o = 1;
552         }
553         
554         return _o;
555     }
556 
557     function purchaseTokens(uint256 _incomingEthereum, address _r1, address _r2, address _r3, address _r4, address _r5) internal {
558         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
559         uint256 _dividends = _undividedDividends;
560 
561         uint256 __bC = 0;
562         uint256 _b = 0;
563         
564         if (canRef(_r1, msg.sender, I_S)) {
565             __bC = I_R1;
566 
567             if (etherBalance(_r1) >= V_S) {
568                 __bC = V_R1;
569             } else if (etherBalance(_r1) >= IV_S) {
570                 __bC = IV_R1;
571             } else if (etherBalance(_r1) >= III_S) {
572                 __bC = III_R1;
573             } else if (etherBalance(_r1) >= II_S) {
574                 __bC = II_R1;
575             }
576             
577             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
578             referralBalance_[_r1] = SafeMath.add(referralBalance_[_r1], _b);
579             addReferralProfit(_r1, msg.sender, _b);
580             _dividends = SafeMath.sub(_dividends, _b);
581         }
582         
583         if (canRef(_r2, msg.sender, II_S)) {
584             __bC = II_R2;
585 
586             if (etherBalance(_r2) >= V_S) {
587                 __bC = V_R2;
588             } else if (etherBalance(_r2) >= IV_S) {
589                 __bC = IV_R2;
590             } else if (etherBalance(_r2) >= III_S) {
591                 __bC = III_R2;
592             }
593             
594             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
595             referralBalance_[_r2] = SafeMath.add(referralBalance_[_r2], _b);
596             addReferralProfit(_r2, _r1, _b);
597             _dividends = SafeMath.sub(_dividends, _b);
598         }
599         
600         if (canRef(_r3, msg.sender, III_S)) {
601             __bC = III_R3;
602 
603             if (etherBalance(_r3) >= V_S) {
604                 __bC = V_R3;
605             } else if (etherBalance(_r3) >= IV_S) {
606                 __bC = IV_R3;
607             }
608             
609             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
610             referralBalance_[_r3] = SafeMath.add(referralBalance_[_r3], _b);
611             addReferralProfit(_r3, _r2, _b);
612             _dividends = SafeMath.sub(_dividends, _b);
613         }
614         
615         if (canRef(_r4, msg.sender, IV_S)) {
616             __bC = IV_R4;
617 
618             if (etherBalance(_r4) >= V_S) {
619                 __bC = V_R4;
620             }
621             
622             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
623             referralBalance_[_r4] = SafeMath.add(referralBalance_[_r4], _b);
624             addReferralProfit(_r4, _r3, _b);
625             _dividends = SafeMath.sub(_dividends, _b);
626         }
627         
628         if (canRef(_r5, msg.sender, V_S)) {
629             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, V_R5), 1000);
630             referralBalance_[_r5] = SafeMath.add(referralBalance_[_r5], _b);
631             addReferralProfit(_r5, _r4, _b);
632             _dividends = SafeMath.sub(_dividends, _b);
633         }
634 
635         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
636         uint256 _fee = _dividends * magnitude;
637 
638         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
639 
640         if (tokenSupply_ > 0) {
641             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
642             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
643             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
644         } else {
645             tokenSupply_ = _amountOfTokens;
646         }
647 
648         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
649         payoutsTo_[msg.sender] += (int256) (profitPerShare_ * _amountOfTokens - _fee);
650         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, now, buyPrice());
651     }
652 
653     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
654         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
655         uint256 _tokensReceived =
656             (
657                 (
658                     SafeMath.sub(
659                         (sqrt
660                             (
661                                 (_tokenPriceInitial ** 2)
662                                 +
663                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
664                                 +
665                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
666                                 +
667                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
668                             )
669                         ), _tokenPriceInitial
670                     )
671                 ) / (tokenPriceIncremental_)
672             ) - (tokenSupply_);
673 
674         return _tokensReceived;
675     }
676 
677     function sellPriceAt(uint256 _atSupply) public view returns (uint256) {
678         if (_atSupply == 0) {
679             return tokenPriceInitial_ - tokenPriceIncremental_;
680         } else {
681             uint256 _ethereum = tokensToEthereumAtSupply_(1e18, _atSupply);
682             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
683             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
684  
685             return _taxedEthereum;
686         }
687     }
688    
689     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
690         return tokensToEthereumAtSupply_(_tokens, tokenSupply_);
691     }
692  
693     function tokensToEthereumAtSupply_(uint256 _tokens, uint256 _atSupply) public view returns (uint256) {
694         if (_tokens < 0.00000001 ether) {
695             return 0;
696         }
697         uint256 tokens_ = (_tokens + 1e18);
698         uint256 _tokenSupply = (_atSupply + 1e18);
699         uint256 _etherReceived =
700             (
701                 SafeMath.sub(
702                     (
703                         (
704                             (
705                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
706                             ) - tokenPriceIncremental_
707                         ) * (tokens_ - 1e18)
708                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
709                 )
710                 / 1e18);
711  
712         return _etherReceived;
713     }
714 
715     function sqrt(uint256 x) internal pure returns (uint256 y) {
716         uint256 z = (x + 1) / 2;
717         y = x;
718 
719         while (z < y) {
720             y = z;
721             z = (x / z + z) / 2;
722         }
723     }
724     
725     mapping(address => mapping(address => uint256)) internal referralProfit_;
726     
727     function addReferralProfit(address _referredBy, address _referral, uint256 _profit) internal {
728         referralProfit_[_referredBy][_referral] += _profit;
729         summaryReferralProfit_[_referredBy] += _profit;
730     }
731     
732     function getReferralProfit(address _referredBy, address _referral) public view returns (uint256) {
733         return referralProfit_[_referredBy][_referral];
734     }
735     
736     function getSummaryReferralProfit(address _referredBy) public view returns (uint256) {
737         if (_ownerAddress == _referredBy) {
738             return 0;
739         } else {
740             return summaryReferralProfit_[_referredBy];
741         }
742     }
743 
744 }
745 
746 library SafeMath {
747     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
748         if (a == 0) {
749             return 0;
750         }
751         uint256 c = a * b;
752         assert(c / a == b);
753         return c;
754     }
755 
756     function div(uint256 a, uint256 b) internal pure returns (uint256) {
757         uint256 c = a / b;
758         return c;
759     }
760 
761     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
762         assert(b <= a);
763         return a - b;
764     }
765 
766     function add(uint256 a, uint256 b) internal pure returns (uint256) {
767         uint256 c = a + b;
768         assert(c >= a);
769         return c;
770     }
771 }