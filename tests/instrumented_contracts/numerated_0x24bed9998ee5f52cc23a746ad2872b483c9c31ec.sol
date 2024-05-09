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
91     uint8 constant internal exitFeeD2_ = 10;
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
183             return (uint8) (exitFeeD2_  - 1); // 9%
184         } else if (tsupply > 2e18 && tsupply <= 3e18) {
185             return (uint8) (exitFeeD2_  - 2); // 8%
186         } else if (tsupply > 3e18 && tsupply <= 5e18) {
187             return (uint8) (exitFeeD2_  - 3); // 7%
188         } else if (tsupply > 5e18 && tsupply <= 10e18) {
189             return (uint8) (exitFeeD2_  - 4); // 6%
190         } else if (tsupply > 10e18 && tsupply <= 50e18) {
191             return (uint8) (exitFeeD2_  - 5); // 5%
192         } else if (tsupply > 50e18 && tsupply <= 100e18) {
193             return (uint8) (exitFeeD2_  - 6); // 4%
194         } else if (tsupply > 100e18 && tsupply <= 1000e18) {
195             return (uint8) (exitFeeD2_  - 7); // 3%
196         } else {
197             return exitFee2_; // 2% with a token supply of over 1000
198         }
199     }
200     
201     function getExitFee() public view returns (uint8) {
202         uint lifetime = getLifetime();
203         if (lifetime <= 6) { 
204             return exitFeeD0_;
205         } else if (lifetime > 6 && lifetime <= 30) {
206             return (uint8) (exitFeeD0_ - lifetime + 6);
207         } else {
208             return exitFee_ + getExitFee2();
209         }
210     }
211     
212 
213     function buy(address _r1, address _r2, address _r3, address _r4, address _r5) onlyStarted() public payable returns (uint256) {
214         purchaseTokens(msg.value, _r1, _r2, _r3, _r4, _r5);
215     }
216 
217     function reinvest() onlyStronghands public {
218         uint256 _dividends = myDividends(false);
219         address _customerAddress = msg.sender;
220         dividendsUsed_[_customerAddress] += _dividends;
221         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
222         _dividends += referralBalance_[_customerAddress];
223         referralBalance_[_customerAddress] = 0;
224         purchaseTokens(_dividends, 0x0, 0x0, 0x0, 0x0, 0x0);
225         emit onReinvestment(_customerAddress, _dividends);
226     }
227 
228     function exit() public {
229         address _customerAddress = msg.sender;
230         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
231         if (_tokens > 0) sell(_tokens);
232         withdraw();
233     }
234 
235     function withdraw() onlyStronghands public {
236         address _customerAddress = msg.sender;
237         uint256 _dividends = myDividends(false);
238         dividendsUsed_[_customerAddress] += _dividends;
239         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242         
243         uint256 _fee = SafeMath.div(SafeMath.mul(_dividends, getExitFee() - 3), 100);
244         
245         uint256 _ownerFee = SafeMath.div(SafeMath.mul(_dividends, 3), 100);
246         
247         uint256 _dividendsTaxed = SafeMath.sub(_dividends, _fee + _ownerFee);
248         
249         if (_customerAddress != _ownerAddress) {
250             referralBalance_[_ownerAddress] += _ownerFee;
251             summaryReferralProfit_[_ownerAddress] += _ownerFee;
252         } else {
253             _dividendsTaxed += _ownerFee;
254         }
255         
256         profitPerShare_ = SafeMath.add(profitPerShare_, (_fee * magnitude) / tokenSupply_);
257     
258         _customerAddress.transfer(_dividendsTaxed);
259         emit onWithdraw(_customerAddress, _dividends);
260     }
261 
262     function sell(uint256 _amountOfTokens) onlyBagholders public {
263         address _customerAddress = msg.sender;
264         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
265         uint256 _tokens = _amountOfTokens;
266         uint256 _ethereum = tokensToEthereum_(_tokens);
267 
268         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
269         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
270 
271         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_ethereum * magnitude));
272         payoutsTo_[_customerAddress] -= _updatedPayouts;
273 
274         emit onTokenSell(_customerAddress, _tokens, _ethereum, now, buyPrice());
275     }
276 
277     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
278         address _customerAddress = msg.sender;
279         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
280 
281         if (myDividends(true) > 0) {
282             withdraw();
283         }
284 
285         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
286         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
287         uint256 _dividends = tokensToEthereum_(_tokenFee);
288 
289         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
291         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
292         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
293         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
294         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
295         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
296         return true;
297     }
298 
299 
300     function totalEthereumBalance() public view returns (uint256) {
301         return address(this).balance;
302     }
303 
304     function totalSupply() public view returns (uint256) {
305         return tokenSupply_;
306     }
307 
308     function myTokens() public view returns (uint256) {
309         address _customerAddress = msg.sender;
310         return balanceOf(_customerAddress);
311     }
312 
313     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
314         address _customerAddress = msg.sender;
315         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
316     }
317 
318     function balanceOf(address _customerAddress) public view returns (uint256) {
319         return tokenBalanceLedger_[_customerAddress];
320     }
321 
322     function dividendsOf(address _customerAddress) public view returns (uint256) {
323         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
324     }
325     
326     function dividendsFull(address _customerAddress) public view returns (uint256) {
327         return dividendsOf(_customerAddress) + dividendsUsed_[_customerAddress] + summaryReferralProfit_[_customerAddress];
328     }
329 
330     function sellPrice() public view returns (uint256) {
331         return sellPriceAt(tokenSupply_);
332     }
333 
334     function buyPrice() public view returns (uint256) {
335         if (tokenSupply_ == 0) {
336             return tokenPriceInitial_ + tokenPriceIncremental_;
337         } else {
338             uint256 _ethereum = tokensToEthereum_(1e18);
339             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
340             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
341 
342             return _taxedEthereum;
343         }
344     }
345 
346     function calculateTokensReceived(uint256 _incomingEthereum) public view returns (uint256) {
347         uint256 _dividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
348         
349         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
350         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
351 
352         return _amountOfTokens;
353     }
354 
355     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
356         require(_tokensToSell <= tokenSupply_);
357         return tokensToEthereum_(_tokensToSell);
358     }
359     
360     uint256 public I_S = 0.25 ether;
361     uint256 public I_R1 = 30;
362 
363     function setI_S(uint256 _v)
364         onlyAdministrator()
365         public
366     {
367         I_S = _v;
368     }
369 
370     function setI_R1(uint256 _v)
371         onlyAdministrator()
372         public
373     {
374         I_R1 = _v;
375     }
376 
377     
378     uint256 public II_S = 5 ether;
379     uint256 public II_R1 = 30;
380     uint256 public II_R2 = 10;
381 
382     function setII_S(uint256 _v)
383         onlyAdministrator()
384         public
385     {
386         II_S = _v;
387     }
388 
389     function setII_R1(uint256 _v)
390         onlyAdministrator()
391         public
392     {
393         II_R1 = _v;
394     }
395 
396     function setII_R2(uint256 _v)
397         onlyAdministrator()
398         public
399     {
400         II_R2 = _v;
401     }
402     
403     uint256 public III_S = 10 ether;
404     uint256 public III_R1 = 30;
405     uint256 public III_R2 = 10;
406     uint256 public III_R3 = 10;
407 
408     function setIII_S(uint256 _v)
409         onlyAdministrator()
410         public
411     {
412         III_S = _v;
413     }
414 
415     function setIII_R1(uint256 _v)
416         onlyAdministrator()
417         public
418     {
419         III_R1 = _v;
420     }
421 
422     function setIII_R2(uint256 _v)
423         onlyAdministrator()
424         public
425     {
426         III_R2 = _v;
427     }
428 
429     function setIII_R3(uint256 _v)
430         onlyAdministrator()
431         public
432     {
433         III_R3 = _v;
434     }
435     
436     uint256 public IV_S = 20 ether;
437     uint256 public IV_R1 = 30;
438     uint256 public IV_R2 = 20;
439     uint256 public IV_R3 = 10;
440     uint256 public IV_R4 = 10;
441 
442     function setIV_S(uint256 _v)
443         onlyAdministrator()
444         public
445     {
446         IV_S = _v;
447     }
448 
449     function setIV_R1(uint256 _v)
450         onlyAdministrator()
451         public
452     {
453         IV_R1 = _v;
454     }
455 
456     function setIV_R2(uint256 _v)
457         onlyAdministrator()
458         public
459     {
460         IV_R2 = _v;
461     }
462 
463     function setIV_R3(uint256 _v)
464         onlyAdministrator()
465         public
466     {
467         IV_R3 = _v;
468     }
469 
470     function setIV_R4(uint256 _v)
471         onlyAdministrator()
472         public
473     {
474         IV_R4 = _v;
475     }
476     
477     uint256 public V_S = 100 ether;
478     uint256 public V_R1 = 40;
479     uint256 public V_R2 = 20;
480     uint256 public V_R3 = 10;
481     uint256 public V_R4 = 10;
482     uint256 public V_R5 = 10;
483 
484     function setV_S(uint256 _v)
485         onlyAdministrator()
486         public
487     {
488         V_S = _v;
489     }
490 
491     function setV_R1(uint256 _v)
492         onlyAdministrator()
493         public
494     {
495         V_R1 = _v;
496     }
497 
498     function setV_R2(uint256 _v)
499         onlyAdministrator()
500         public
501     {
502         V_R2 = _v;
503     }
504 
505     function setV_R3(uint256 _v)
506         onlyAdministrator()
507         public
508     {
509         V_R3 = _v;
510     }
511 
512     function setV_R4(uint256 _v)
513         onlyAdministrator()
514         public
515     {
516         V_R4 = _v;
517     }
518 
519     function setV_R5(uint256 _v)
520         onlyAdministrator()
521         public
522     {
523         V_R5 = _v;
524     }
525     
526     function canRef(address _r, address _c, uint256 _m) internal returns (bool) {
527         return _r != 0x0000000000000000000000000000000000000000 && _r != _c && tokenBalanceLedger_[_r] >= _m;
528     }
529     
530     function etherBalance(address r) internal returns (uint256) {
531         uint _v = tokenBalanceLedger_[r];
532         if (_v < 0.00000001 ether) {
533             return 0;
534         } else {
535             return tokensToEthereum_(_v);
536         }
537     }
538     
539     function getLevel(address _cb) public view returns (uint256) {
540         uint256 _b = etherBalance(_cb);
541         uint256 _o = 0;
542         
543         if (_b >= V_S) {
544             _o = 5;
545         } else if (_b >= IV_S) {
546             _o = 4;
547         } else if (_b >= III_S) {
548             _o = 3;
549         } else if (_b >= II_S) {
550             _o = 2;
551         } else if (_b >= I_S) {
552             _o = 1;
553         }
554         
555         return _o;
556     }
557 
558     function purchaseTokens(uint256 _incomingEthereum, address _r1, address _r2, address _r3, address _r4, address _r5) internal {
559         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
560         uint256 _dividends = _undividedDividends;
561 
562         uint256 __bC = 0;
563         uint256 _b = 0;
564         
565         if (canRef(_r1, msg.sender, I_S)) {
566             __bC = I_R1;
567 
568             if (etherBalance(_r1) >= V_S) {
569                 __bC = V_R1;
570             } else if (etherBalance(_r1) >= IV_S) {
571                 __bC = IV_R1;
572             } else if (etherBalance(_r1) >= III_S) {
573                 __bC = III_R1;
574             } else if (etherBalance(_r1) >= II_S) {
575                 __bC = II_R1;
576             }
577             
578             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
579             referralBalance_[_r1] = SafeMath.add(referralBalance_[_r1], _b);
580             addReferralProfit(_r1, msg.sender, _b);
581             _dividends = SafeMath.sub(_dividends, _b);
582         }
583         
584         if (canRef(_r2, msg.sender, II_S)) {
585             __bC = II_R2;
586 
587             if (etherBalance(_r2) >= V_S) {
588                 __bC = V_R2;
589             } else if (etherBalance(_r2) >= IV_S) {
590                 __bC = IV_R2;
591             } else if (etherBalance(_r2) >= III_S) {
592                 __bC = III_R2;
593             }
594             
595             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
596             referralBalance_[_r2] = SafeMath.add(referralBalance_[_r2], _b);
597             addReferralProfit(_r2, _r1, _b);
598             _dividends = SafeMath.sub(_dividends, _b);
599         }
600         
601         if (canRef(_r3, msg.sender, III_S)) {
602             __bC = III_R3;
603 
604             if (etherBalance(_r3) >= V_S) {
605                 __bC = V_R3;
606             } else if (etherBalance(_r3) >= IV_S) {
607                 __bC = IV_R3;
608             }
609             
610             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
611             referralBalance_[_r3] = SafeMath.add(referralBalance_[_r3], _b);
612             addReferralProfit(_r3, _r2, _b);
613             _dividends = SafeMath.sub(_dividends, _b);
614         }
615         
616         if (canRef(_r4, msg.sender, IV_S)) {
617             __bC = IV_R4;
618 
619             if (etherBalance(_r4) >= V_S) {
620                 __bC = V_R4;
621             }
622             
623             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
624             referralBalance_[_r4] = SafeMath.add(referralBalance_[_r4], _b);
625             addReferralProfit(_r4, _r3, _b);
626             _dividends = SafeMath.sub(_dividends, _b);
627         }
628         
629         if (canRef(_r5, msg.sender, V_S)) {
630             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, V_R5), 1000);
631             referralBalance_[_r5] = SafeMath.add(referralBalance_[_r5], _b);
632             addReferralProfit(_r5, _r4, _b);
633             _dividends = SafeMath.sub(_dividends, _b);
634         }
635 
636         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
637         uint256 _fee = _dividends * magnitude;
638 
639         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
640 
641         if (tokenSupply_ > 0) {
642             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
643             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
644             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
645         } else {
646             tokenSupply_ = _amountOfTokens;
647         }
648 
649         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
650         payoutsTo_[msg.sender] += (int256) (profitPerShare_ * _amountOfTokens - _fee);
651         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, now, buyPrice());
652     }
653 
654     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
655         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
656         uint256 _tokensReceived =
657             (
658                 (
659                     SafeMath.sub(
660                         (sqrt
661                             (
662                                 (_tokenPriceInitial ** 2)
663                                 +
664                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
665                                 +
666                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
667                                 +
668                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
669                             )
670                         ), _tokenPriceInitial
671                     )
672                 ) / (tokenPriceIncremental_)
673             ) - (tokenSupply_);
674 
675         return _tokensReceived;
676     }
677 
678     function sellPriceAt(uint256 _atSupply) public view returns (uint256) {
679         if (_atSupply == 0) {
680             return tokenPriceInitial_ - tokenPriceIncremental_;
681         } else {
682             uint256 _ethereum = tokensToEthereumAtSupply_(1e18, _atSupply);
683             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
684             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
685  
686             return _taxedEthereum;
687         }
688     }
689    
690     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
691         return tokensToEthereumAtSupply_(_tokens, tokenSupply_);
692     }
693  
694     function tokensToEthereumAtSupply_(uint256 _tokens, uint256 _atSupply) public view returns (uint256) {
695         if (_tokens < 0.00000001 ether) {
696             return 0;
697         }
698         uint256 tokens_ = (_tokens + 1e18);
699         uint256 _tokenSupply = (_atSupply + 1e18);
700         uint256 _etherReceived =
701             (
702                 SafeMath.sub(
703                     (
704                         (
705                             (
706                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
707                             ) - tokenPriceIncremental_
708                         ) * (tokens_ - 1e18)
709                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
710                 )
711                 / 1e18);
712  
713         return _etherReceived;
714     }
715 
716     function sqrt(uint256 x) internal pure returns (uint256 y) {
717         uint256 z = (x + 1) / 2;
718         y = x;
719 
720         while (z < y) {
721             y = z;
722             z = (x / z + z) / 2;
723         }
724     }
725     
726     mapping(address => mapping(address => uint256)) internal referralProfit_;
727     
728     function addReferralProfit(address _referredBy, address _referral, uint256 _profit) internal {
729         referralProfit_[_referredBy][_referral] += _profit;
730         summaryReferralProfit_[_referredBy] += _profit;
731     }
732     
733     function getReferralProfit(address _referredBy, address _referral) public view returns (uint256) {
734         return referralProfit_[_referredBy][_referral];
735     }
736     
737     function getSummaryReferralProfit(address _referredBy) public view returns (uint256) {
738         if (_ownerAddress == _referredBy) {
739             return 0;
740         } else {
741             return summaryReferralProfit_[_referredBy];
742         }
743     }
744 
745 }
746 
747 library SafeMath {
748     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
749         if (a == 0) {
750             return 0;
751         }
752         uint256 c = a * b;
753         assert(c / a == b);
754         return c;
755     }
756 
757     function div(uint256 a, uint256 b) internal pure returns (uint256) {
758         uint256 c = a / b;
759         return c;
760     }
761 
762     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
763         assert(b <= a);
764         return a - b;
765     }
766 
767     function add(uint256 a, uint256 b) internal pure returns (uint256) {
768         uint256 c = a + b;
769         assert(c >= a);
770         return c;
771     }
772 }