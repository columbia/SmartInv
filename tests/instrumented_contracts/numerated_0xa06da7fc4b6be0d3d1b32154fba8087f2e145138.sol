1 pragma solidity ^0.4.25;
2 
3 /*
4 * METADOLLAR SMART CONTRACT 
5 * https://www.metadollar.org/ETH/contract-status/0005
6 * See website for contract status and features
7 */
8 
9 contract METADOLLAR {
10 
11     /**
12      * Only with tokens
13      */
14     modifier onlyBagholders {
15         require(myTokens() > 0);
16         _;
17     }
18 
19     /**
20      * Only with dividends
21      */
22     modifier onlyStronghands {
23         require(myDividends(true) > 0);
24         _;
25     }
26 
27     event onTokenPurchase(
28         address indexed customerAddress,
29         uint256 incomingEthereum,
30         uint256 tokensMinted,
31         uint timestamp,
32         uint256 price
33     );
34 
35     event onTokenSell(
36         address indexed customerAddress,
37         uint256 tokensBurned,
38         uint256 ethereumEarned,
39         uint timestamp,
40         uint256 price
41     );
42 
43     event onReinvestment(
44         address indexed customerAddress,
45         uint256 ethereumReinvested
46     );
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51     );
52 
53     event Transfer(
54         address indexed from,
55         address indexed to,
56         uint256 tokens
57     );
58 
59     string public name = "Metadollar Dynamic Fund";
60     string public symbol = "MDY";
61     uint public createdAt;
62     
63     bool public started = true;
64     modifier onlyStarted {
65         require(started);
66         _;
67     }
68     modifier onlyNotStarted {
69         require(!started);
70         _;
71     }
72 
73     uint8 constant public decimals = 18;
74 
75     /**
76      * fees
77      */
78     uint8 constant internal entryFee_ = 15;
79     uint8 constant internal ownerFee_ = 4;
80     uint8 constant internal transferFee_ = 5;
81     uint8 constant internal exitFeeD0_ = 50;
82     uint8 constant internal exitFee_ = 6;
83     uint8 constant internal refferalFee_ = 33;
84 
85     address internal _ownerAddress;
86 
87     /**
88      * Initial token values
89      */
90     uint256 constant internal tokenPriceInitial_ = 1 ether;
91     uint256 constant internal tokenPriceIncremental_ = 0.0001 ether;
92 
93     uint256 constant internal magnitude = 2 ** 64;
94 
95 
96     mapping(address => uint256) internal tokenBalanceLedger_;
97     mapping(address => uint256) internal referralBalance_;
98     mapping(address => int256) internal payoutsTo_;
99     mapping(address => uint256) internal summaryReferralProfit_;
100     mapping(address => uint256) internal dividendsUsed_;
101 
102     uint256 internal tokenSupply_;
103     uint256 internal profitPerShare_;
104     
105     uint public blockCreation;
106     
107     /**
108      * Admins. Only rename tokens, change referral settings and add new admins
109      */
110     mapping(bytes32 => bool) public administrators;
111     modifier onlyAdministrator(){
112         address _customerAddress = msg.sender;
113         require(administrators[keccak256(_customerAddress)]);
114         _;
115     }
116 
117     function isAdmin() public view returns (bool) {
118         return administrators[keccak256(msg.sender)];
119     }
120 
121     function setAdministrator(address _id, bool _status)
122         onlyAdministrator()
123         public
124     {
125         if (_id != _ownerAddress) {
126             administrators[keccak256(_id)] = _status;
127         }
128     } 
129 
130     function setName(string _name)
131         onlyAdministrator()
132         public
133     {
134         name = _name;
135     }
136 
137     function setSymbol(string _symbol)
138         onlyAdministrator()
139         public
140     {
141         symbol = _symbol;
142     }
143 
144     constructor() public {
145         _ownerAddress = msg.sender;
146         administrators[keccak256(_ownerAddress)] = true;
147         blockCreation = block.number;
148     }
149     
150     function start() onlyNotStarted() onlyAdministrator() public {
151         started = true;
152         createdAt = block.timestamp;
153     }
154     
155     function getLifetime() public view returns (uint8) {
156         if (!started)
157         {
158             return 0;
159         }
160         return (uint8) ((now - createdAt) / 60 / 60 / 24);
161     }
162     
163     
164     function getSupply() public view returns (uint256) {
165         if (!started)
166         {
167             return 0;
168         }
169         return totalSupply();
170     }
171     
172     function getExitFee() public view returns (uint8) {
173         uint tsupply = getSupply();
174         if (tsupply <= 1e18) { 
175             return exitFeeD0_; // 50%
176         } else if (tsupply > 2e18 && tsupply <= 3e18) {
177             return (uint8) (exitFeeD0_  - 15); // 35%
178         } else if (tsupply > 3e18 && tsupply <= 4e18) {
179             return (uint8) (exitFeeD0_  -20); // 30%
180         } else if (tsupply > 4e18 && tsupply <= 5e18) {
181             return (uint8) (exitFeeD0_  - 25); // 25%
182         } else if (tsupply > 5e18 && tsupply <= 10e18) {
183             return (uint8) (exitFeeD0_  - 30); // 20%
184         } else if (tsupply > 10e18 && tsupply <= 20e18) {
185             return (uint8) (exitFeeD0_  - 32); // 18%
186         } else if (tsupply > 20e18 && tsupply <= 50e18) {
187             return (uint8) (exitFeeD0_  - 35); // 15%
188         } else if (tsupply > 50e18 && tsupply <= 100e18) {
189             return (uint8) (exitFeeD0_  - 38); // 12%
190         } else if (tsupply > 100e18 && tsupply <= 500e18) {
191             return (uint8) (exitFeeD0_  - 40); // 10%
192         } else if (tsupply > 500e18 && tsupply <= 1000e18) {
193             return (uint8) (exitFeeD0_  - 41); // 9%
194         } else if (tsupply > 1000e18 && tsupply <= 2500e18) {
195             return (uint8) (exitFeeD0_  - 42); // 8%
196         } else if (tsupply > 2500e18 && tsupply <= 5000e18) {
197             return (uint8) (exitFeeD0_  - 43); // 7%
198         } else if (tsupply > 5000e18 && tsupply <= 10000e18) {
199             return (uint8) (exitFeeD0_  - 44); // 6%
200         } else {
201             return exitFee_; // 6%
202         }
203     }
204 
205     function buy(address _r1, address _r2, address _r3, address _r4, address _r5) onlyStarted() public payable returns (uint256) {
206         purchaseTokens(msg.value, _r1, _r2, _r3, _r4, _r5);
207     }
208 
209     function reinvest() onlyStronghands public {
210         uint256 _dividends = myDividends(false);
211         address _customerAddress = msg.sender;
212         dividendsUsed_[_customerAddress] += _dividends;
213         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
214         _dividends += referralBalance_[_customerAddress];
215         referralBalance_[_customerAddress] = 0;
216         purchaseTokens(_dividends, 0x0, 0x0, 0x0, 0x0, 0x0);
217         emit onReinvestment(_customerAddress, _dividends);
218     }
219 
220     function exit() public {
221         address _customerAddress = msg.sender;
222         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
223         if (_tokens > 0) sell(_tokens);
224         withdraw();
225     }
226 
227     function withdraw() onlyStronghands public {
228         address _customerAddress = msg.sender;
229         uint256 _dividends = myDividends(false);
230         dividendsUsed_[_customerAddress] += _dividends;
231         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
232         _dividends += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress] = 0;
234         
235         uint256 _fee = SafeMath.div(SafeMath.mul(_dividends, getExitFee() - 3), 100);
236         
237         uint256 _ownerFee = SafeMath.div(SafeMath.mul(_dividends, 3), 100);
238         
239         uint256 _dividendsTaxed = SafeMath.sub(_dividends, _fee + _ownerFee);
240         
241         if (_customerAddress != _ownerAddress) {
242             referralBalance_[_ownerAddress] += _ownerFee;
243             summaryReferralProfit_[_ownerAddress] += _ownerFee;
244         } else {
245             _dividendsTaxed += _ownerFee;
246         }
247         
248         profitPerShare_ = SafeMath.add(profitPerShare_, (_fee * magnitude) / tokenSupply_);
249     
250         _customerAddress.transfer(_dividendsTaxed);
251         emit onWithdraw(_customerAddress, _dividends);
252     }
253 
254     function sell(uint256 _amountOfTokens) onlyBagholders public {
255         address _customerAddress = msg.sender;
256         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
257         uint256 _tokens = _amountOfTokens;
258         uint256 _ethereum = tokensToEthereum_(_tokens);
259 
260         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
262 
263         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_ethereum * magnitude));
264         payoutsTo_[_customerAddress] -= _updatedPayouts;
265 
266         emit onTokenSell(_customerAddress, _tokens, _ethereum, now, buyPrice());
267     }
268 
269     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
270         address _customerAddress = msg.sender;
271         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
272 
273         if (myDividends(true) > 0) {
274             withdraw();
275         }
276 
277         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
278         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
279         uint256 _dividends = tokensToEthereum_(_tokenFee);
280 
281         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
282         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
283         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
284         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
285         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
286         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
287         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
288         return true;
289     }
290 
291 
292     function totalEthereumBalance() public view returns (uint256) {
293         return address(this).balance;
294     }
295 
296     function totalSupply() public view returns (uint256) {
297         return tokenSupply_;
298     }
299 
300     function myTokens() public view returns (uint256) {
301         address _customerAddress = msg.sender;
302         return balanceOf(_customerAddress);
303     }
304 
305     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
306         address _customerAddress = msg.sender;
307         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
308     }
309 
310     function balanceOf(address _customerAddress) public view returns (uint256) {
311         return tokenBalanceLedger_[_customerAddress];
312     }
313 
314     function dividendsOf(address _customerAddress) public view returns (uint256) {
315         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
316     }
317     
318     function dividendsFull(address _customerAddress) public view returns (uint256) {
319         return dividendsOf(_customerAddress) + dividendsUsed_[_customerAddress] + summaryReferralProfit_[_customerAddress];
320     }
321 
322     function sellPrice() public view returns (uint256) {
323         return sellPriceAt(tokenSupply_);
324     }
325 
326     function buyPrice() public view returns (uint256) {
327         if (tokenSupply_ == 0) {
328             return tokenPriceInitial_ + tokenPriceIncremental_;
329         } else {
330             uint256 _ethereum = tokensToEthereum_(1e18);
331             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
332             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
333 
334             return _taxedEthereum;
335         }
336     }
337 
338     function calculateTokensReceived(uint256 _incomingEthereum) public view returns (uint256) {
339         uint256 _dividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
340         
341         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
342         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
343 
344         return _amountOfTokens;
345     }
346 
347     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
348         require(_tokensToSell <= tokenSupply_);
349         return tokensToEthereum_(_tokensToSell);
350     }
351     
352     uint256 public I_S = 0.25 ether;
353     uint256 public I_R1 = 30;
354 
355     function setI_S(uint256 _v)
356         onlyAdministrator()
357         public
358     {
359         I_S = _v;
360     }
361 
362     function setI_R1(uint256 _v)
363         onlyAdministrator()
364         public
365     {
366         I_R1 = _v;
367     }
368 
369     
370     uint256 public II_S = 5 ether;
371     uint256 public II_R1 = 30;
372     uint256 public II_R2 = 10;
373 
374     function setII_S(uint256 _v)
375         onlyAdministrator()
376         public
377     {
378         II_S = _v;
379     }
380 
381     function setII_R1(uint256 _v)
382         onlyAdministrator()
383         public
384     {
385         II_R1 = _v;
386     }
387 
388     function setII_R2(uint256 _v)
389         onlyAdministrator()
390         public
391     {
392         II_R2 = _v;
393     }
394     
395     uint256 public III_S = 10 ether;
396     uint256 public III_R1 = 30;
397     uint256 public III_R2 = 10;
398     uint256 public III_R3 = 10;
399 
400     function setIII_S(uint256 _v)
401         onlyAdministrator()
402         public
403     {
404         III_S = _v;
405     }
406 
407     function setIII_R1(uint256 _v)
408         onlyAdministrator()
409         public
410     {
411         III_R1 = _v;
412     }
413 
414     function setIII_R2(uint256 _v)
415         onlyAdministrator()
416         public
417     {
418         III_R2 = _v;
419     }
420 
421     function setIII_R3(uint256 _v)
422         onlyAdministrator()
423         public
424     {
425         III_R3 = _v;
426     }
427     
428     uint256 public IV_S = 20 ether;
429     uint256 public IV_R1 = 30;
430     uint256 public IV_R2 = 20;
431     uint256 public IV_R3 = 10;
432     uint256 public IV_R4 = 10;
433 
434     function setIV_S(uint256 _v)
435         onlyAdministrator()
436         public
437     {
438         IV_S = _v;
439     }
440 
441     function setIV_R1(uint256 _v)
442         onlyAdministrator()
443         public
444     {
445         IV_R1 = _v;
446     }
447 
448     function setIV_R2(uint256 _v)
449         onlyAdministrator()
450         public
451     {
452         IV_R2 = _v;
453     }
454 
455     function setIV_R3(uint256 _v)
456         onlyAdministrator()
457         public
458     {
459         IV_R3 = _v;
460     }
461 
462     function setIV_R4(uint256 _v)
463         onlyAdministrator()
464         public
465     {
466         IV_R4 = _v;
467     }
468     
469     uint256 public V_S = 100 ether;
470     uint256 public V_R1 = 40;
471     uint256 public V_R2 = 20;
472     uint256 public V_R3 = 10;
473     uint256 public V_R4 = 10;
474     uint256 public V_R5 = 10;
475 
476     function setV_S(uint256 _v)
477         onlyAdministrator()
478         public
479     {
480         V_S = _v;
481     }
482 
483     function setV_R1(uint256 _v)
484         onlyAdministrator()
485         public
486     {
487         V_R1 = _v;
488     }
489 
490     function setV_R2(uint256 _v)
491         onlyAdministrator()
492         public
493     {
494         V_R2 = _v;
495     }
496 
497     function setV_R3(uint256 _v)
498         onlyAdministrator()
499         public
500     {
501         V_R3 = _v;
502     }
503 
504     function setV_R4(uint256 _v)
505         onlyAdministrator()
506         public
507     {
508         V_R4 = _v;
509     }
510 
511     function setV_R5(uint256 _v)
512         onlyAdministrator()
513         public
514     {
515         V_R5 = _v;
516     }
517     
518     function canRef(address _r, address _c, uint256 _m) internal returns (bool) {
519         return _r != 0x0000000000000000000000000000000000000000 && _r != _c && tokenBalanceLedger_[_r] >= _m;
520     }
521     
522     function etherBalance(address r) internal returns (uint256) {
523         uint _v = tokenBalanceLedger_[r];
524         if (_v < 0.00000001 ether) {
525             return 0;
526         } else {
527             return tokensToEthereum_(_v);
528         }
529     }
530     
531     function getLevel(address _cb) public view returns (uint256) {
532         uint256 _b = etherBalance(_cb);
533         uint256 _o = 0;
534         
535         if (_b >= V_S) {
536             _o = 5;
537         } else if (_b >= IV_S) {
538             _o = 4;
539         } else if (_b >= III_S) {
540             _o = 3;
541         } else if (_b >= II_S) {
542             _o = 2;
543         } else if (_b >= I_S) {
544             _o = 1;
545         }
546         
547         return _o;
548     }
549 
550     function purchaseTokens(uint256 _incomingEthereum, address _r1, address _r2, address _r3, address _r4, address _r5) internal {
551         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
552         uint256 _dividends = _undividedDividends;
553 
554         uint256 __bC = 0;
555         uint256 _b = 0;
556         
557         if (canRef(_r1, msg.sender, I_S)) {
558             __bC = I_R1;
559 
560             if (etherBalance(_r1) >= V_S) {
561                 __bC = V_R1;
562             } else if (etherBalance(_r1) >= IV_S) {
563                 __bC = IV_R1;
564             } else if (etherBalance(_r1) >= III_S) {
565                 __bC = III_R1;
566             } else if (etherBalance(_r1) >= II_S) {
567                 __bC = II_R1;
568             }
569             
570             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
571             referralBalance_[_r1] = SafeMath.add(referralBalance_[_r1], _b);
572             addReferralProfit(_r1, msg.sender, _b);
573             _dividends = SafeMath.sub(_dividends, _b);
574         }
575         
576         if (canRef(_r2, msg.sender, II_S)) {
577             __bC = II_R2;
578 
579             if (etherBalance(_r2) >= V_S) {
580                 __bC = V_R2;
581             } else if (etherBalance(_r2) >= IV_S) {
582                 __bC = IV_R2;
583             } else if (etherBalance(_r2) >= III_S) {
584                 __bC = III_R2;
585             }
586             
587             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
588             referralBalance_[_r2] = SafeMath.add(referralBalance_[_r2], _b);
589             addReferralProfit(_r2, _r1, _b);
590             _dividends = SafeMath.sub(_dividends, _b);
591         }
592         
593         if (canRef(_r3, msg.sender, III_S)) {
594             __bC = III_R3;
595 
596             if (etherBalance(_r3) >= V_S) {
597                 __bC = V_R3;
598             } else if (etherBalance(_r3) >= IV_S) {
599                 __bC = IV_R3;
600             }
601             
602             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
603             referralBalance_[_r3] = SafeMath.add(referralBalance_[_r3], _b);
604             addReferralProfit(_r3, _r2, _b);
605             _dividends = SafeMath.sub(_dividends, _b);
606         }
607         
608         if (canRef(_r4, msg.sender, IV_S)) {
609             __bC = IV_R4;
610 
611             if (etherBalance(_r4) >= V_S) {
612                 __bC = V_R4;
613             }
614             
615             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
616             referralBalance_[_r4] = SafeMath.add(referralBalance_[_r4], _b);
617             addReferralProfit(_r4, _r3, _b);
618             _dividends = SafeMath.sub(_dividends, _b);
619         }
620         
621         if (canRef(_r5, msg.sender, V_S)) {
622             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, V_R5), 1000);
623             referralBalance_[_r5] = SafeMath.add(referralBalance_[_r5], _b);
624             addReferralProfit(_r5, _r4, _b);
625             _dividends = SafeMath.sub(_dividends, _b);
626         }
627 
628         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
629         uint256 _fee = _dividends * magnitude;
630 
631         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
632 
633         if (tokenSupply_ > 0) {
634             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
635             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
636             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
637         } else {
638             tokenSupply_ = _amountOfTokens;
639         }
640 
641         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
642         payoutsTo_[msg.sender] += (int256) (profitPerShare_ * _amountOfTokens - _fee);
643         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, now, buyPrice());
644     }
645 
646     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
647         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
648         uint256 _tokensReceived =
649             (
650                 (
651                     SafeMath.sub(
652                         (sqrt
653                             (
654                                 (_tokenPriceInitial ** 2)
655                                 +
656                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
657                                 +
658                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
659                                 +
660                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
661                             )
662                         ), _tokenPriceInitial
663                     )
664                 ) / (tokenPriceIncremental_)
665             ) - (tokenSupply_);
666 
667         return _tokensReceived;
668     }
669 
670     function sellPriceAt(uint256 _atSupply) public view returns (uint256) {
671         if (_atSupply == 0) {
672             return tokenPriceInitial_ - tokenPriceIncremental_;
673         } else {
674             uint256 _ethereum = tokensToEthereumAtSupply_(1e18, _atSupply);
675             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
676             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
677  
678             return _taxedEthereum;
679         }
680     }
681    
682     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
683         return tokensToEthereumAtSupply_(_tokens, tokenSupply_);
684     }
685  
686     function tokensToEthereumAtSupply_(uint256 _tokens, uint256 _atSupply) public view returns (uint256) {
687         if (_tokens < 0.00000001 ether) {
688             return 0;
689         }
690         uint256 tokens_ = (_tokens + 1e18);
691         uint256 _tokenSupply = (_atSupply + 1e18);
692         uint256 _etherReceived =
693             (
694                 SafeMath.sub(
695                     (
696                         (
697                             (
698                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
699                             ) - tokenPriceIncremental_
700                         ) * (tokens_ - 1e18)
701                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
702                 )
703                 / 1e18);
704  
705         return _etherReceived;
706     }
707 
708     function sqrt(uint256 x) internal pure returns (uint256 y) {
709         uint256 z = (x + 1) / 2;
710         y = x;
711 
712         while (z < y) {
713             y = z;
714             z = (x / z + z) / 2;
715         }
716     }
717     
718     mapping(address => mapping(address => uint256)) internal referralProfit_;
719     
720     function addReferralProfit(address _referredBy, address _referral, uint256 _profit) internal {
721         referralProfit_[_referredBy][_referral] += _profit;
722         summaryReferralProfit_[_referredBy] += _profit;
723     }
724     
725     function getReferralProfit(address _referredBy, address _referral) public view returns (uint256) {
726         return referralProfit_[_referredBy][_referral];
727     }
728     
729     function getSummaryReferralProfit(address _referredBy) public view returns (uint256) {
730         if (_ownerAddress == _referredBy) {
731             return 0;
732         } else {
733             return summaryReferralProfit_[_referredBy];
734         }
735     }
736 
737 }
738 
739 library SafeMath {
740     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
741         if (a == 0) {
742             return 0;
743         }
744         uint256 c = a * b;
745         assert(c / a == b);
746         return c;
747     }
748 
749     function div(uint256 a, uint256 b) internal pure returns (uint256) {
750         uint256 c = a / b;
751         return c;
752     }
753 
754     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
755         assert(b <= a);
756         return a - b;
757     }
758 
759     function add(uint256 a, uint256 b) internal pure returns (uint256) {
760         uint256 c = a + b;
761         assert(c >= a);
762         return c;
763     }
764 }