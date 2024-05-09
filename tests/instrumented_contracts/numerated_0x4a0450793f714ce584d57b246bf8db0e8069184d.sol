1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://www.tokenbuyersclub.com - Copyright 2018 TokenBuyersClub.com
5 *
6 * Token Buyers Club Fund Concept
7 *
8 * [✓] 6% Withdraw fee (3% to dividends, 3% to owner). First 6 days 30%, next 24 days it will decrease to 6%
9 * [✓] 25% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 5 lines referral system with 5 levels of rewards
12 *
13 */
14 
15 contract TBC {
16 
17     /**
18      * Only with tokens
19      */
20     modifier onlyBagholders {
21         require(myTokens() > 0);
22         _;
23     }
24 
25     /**
26      * Only with dividends
27      */
28     modifier onlyStronghands {
29         require(myDividends(true) > 0);
30         _;
31     }
32 
33     event onTokenPurchase(
34         address indexed customerAddress,
35         uint256 incomingEthereum,
36         uint256 tokensMinted,
37         uint timestamp,
38         uint256 price
39     );
40 
41     event onTokenSell(
42         address indexed customerAddress,
43         uint256 tokensBurned,
44         uint256 ethereumEarned,
45         uint timestamp,
46         uint256 price
47     );
48 
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested
52     );
53 
54     event onWithdraw(
55         address indexed customerAddress,
56         uint256 ethereumWithdrawn
57     );
58 
59     event Transfer(
60         address indexed from,
61         address indexed to,
62         uint256 tokens
63     );
64 
65     string public name = "Token Buyers Club";
66     string public symbol = "TBC";
67     uint public createdAt;
68     
69     bool public started = false;
70     modifier onlyStarted {
71         require(started);
72         _;
73     }
74     modifier onlyNotStarted {
75         require(!started);
76         _;
77     }
78 
79     uint8 constant public decimals = 18;
80 
81     /**
82      * fees
83      */
84     uint8 constant internal entryFee_ = 20;
85     uint8 constant internal ownerFee_ = 4;
86     uint8 constant internal transferFee_ = 1;
87     uint8 constant internal exitFeeD0_ = 30;
88     uint8 constant internal exitFee_ = 6;
89     uint8 constant internal refferalFee_ = 33;
90 
91     address internal _ownerAddress;
92 
93     /**
94      * Initial token values
95      */
96     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
97     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
98 
99     uint256 constant internal magnitude = 2 ** 64;
100 
101 
102     mapping(address => uint256) internal tokenBalanceLedger_;
103     mapping(address => uint256) internal referralBalance_;
104     mapping(address => int256) internal payoutsTo_;
105     mapping(address => uint256) internal summaryReferralProfit_;
106     mapping(address => uint256) internal dividendsUsed_;
107 
108     uint256 internal tokenSupply_;
109     uint256 internal profitPerShare_;
110     
111     uint public blockCreation;
112     
113     /**
114      * Admins. Only rename tokens, change referral settings and add new admins
115      */
116     mapping(bytes32 => bool) public administrators;
117     modifier onlyAdministrator(){
118         address _customerAddress = msg.sender;
119         require(administrators[keccak256(_customerAddress)]);
120         _;
121     }
122 
123     function isAdmin() public view returns (bool) {
124         return administrators[keccak256(msg.sender)];
125     }
126 
127     function setAdministrator(address _id, bool _status)
128         onlyAdministrator()
129         public
130     {
131         if (_id != _ownerAddress) {
132             administrators[keccak256(_id)] = _status;
133         }
134     } 
135 
136     function setName(string _name)
137         onlyAdministrator()
138         public
139     {
140         name = _name;
141     }
142 
143     function setSymbol(string _symbol)
144         onlyAdministrator()
145         public
146     {
147         symbol = _symbol;
148     }
149 
150     constructor() public {
151         _ownerAddress = msg.sender;
152         administrators[keccak256(_ownerAddress)] = true;
153         blockCreation = block.number;
154     }
155     
156     function start() onlyNotStarted() onlyAdministrator() public {
157         started = true;
158         createdAt = block.timestamp;
159     }
160     
161     function getLifetime() public view returns (uint8) {
162         if (!started)
163         {
164             return 0;
165         }
166         return (uint8) ((now - createdAt) / 60 / 60 / 24);
167     }
168     
169     function getExitFee() public view returns (uint8) {
170         uint lifetime = getLifetime();
171         if (lifetime <= 6) { 
172             return exitFeeD0_; // 30%
173         } else if (lifetime < 30) {
174             return (uint8) (exitFeeD0_ - lifetime + 6);
175         } else {
176             return exitFee_; // 6%
177         }
178     }
179 
180     function buy(address _r1, address _r2, address _r3, address _r4, address _r5) onlyStarted() public payable returns (uint256) {
181         purchaseTokens(msg.value, _r1, _r2, _r3, _r4, _r5);
182     }
183 
184     function reinvest() onlyStronghands public {
185         uint256 _dividends = myDividends(false);
186         address _customerAddress = msg.sender;
187         dividendsUsed_[_customerAddress] += _dividends;
188         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
189         _dividends += referralBalance_[_customerAddress];
190         referralBalance_[_customerAddress] = 0;
191         purchaseTokens(_dividends, 0x0, 0x0, 0x0, 0x0, 0x0);
192         emit onReinvestment(_customerAddress, _dividends);
193     }
194 
195     function exit() public {
196         address _customerAddress = msg.sender;
197         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
198         if (_tokens > 0) sell(_tokens);
199         withdraw();
200     }
201 
202     function withdraw() onlyStronghands public {
203         address _customerAddress = msg.sender;
204         uint256 _dividends = myDividends(false);
205         dividendsUsed_[_customerAddress] += _dividends;
206         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
207         _dividends += referralBalance_[_customerAddress];
208         referralBalance_[_customerAddress] = 0;
209         
210         uint256 _fee = SafeMath.div(SafeMath.mul(_dividends, getExitFee() - 3), 100);
211         
212         uint256 _ownerFee = SafeMath.div(SafeMath.mul(_dividends, 3), 100);
213         
214         uint256 _dividendsTaxed = SafeMath.sub(_dividends, _fee + _ownerFee);
215         
216         if (_customerAddress != _ownerAddress) {
217             referralBalance_[_ownerAddress] += _ownerFee;
218             summaryReferralProfit_[_ownerAddress] += _ownerFee;
219         } else {
220             _dividendsTaxed += _ownerFee;
221         }
222         
223         profitPerShare_ = SafeMath.add(profitPerShare_, (_fee * magnitude) / tokenSupply_);
224     
225         _customerAddress.transfer(_dividendsTaxed);
226         emit onWithdraw(_customerAddress, _dividends);
227     }
228 
229     function sell(uint256 _amountOfTokens) onlyBagholders public {
230         address _customerAddress = msg.sender;
231         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
232         uint256 _tokens = _amountOfTokens;
233         uint256 _ethereum = tokensToEthereum_(_tokens);
234 
235         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
236         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
237 
238         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_ethereum * magnitude));
239         payoutsTo_[_customerAddress] -= _updatedPayouts;
240 
241         emit onTokenSell(_customerAddress, _tokens, _ethereum, now, buyPrice());
242     }
243 
244     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
245         address _customerAddress = msg.sender;
246         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
247 
248         if (myDividends(true) > 0) {
249             withdraw();
250         }
251 
252         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
253         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
254         uint256 _dividends = tokensToEthereum_(_tokenFee);
255 
256         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
257         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
258         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
259         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
260         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
261         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
262         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
263         return true;
264     }
265 
266 
267     function totalEthereumBalance() public view returns (uint256) {
268         return address(this).balance;
269     }
270 
271     function totalSupply() public view returns (uint256) {
272         return tokenSupply_;
273     }
274 
275     function myTokens() public view returns (uint256) {
276         address _customerAddress = msg.sender;
277         return balanceOf(_customerAddress);
278     }
279 
280     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
281         address _customerAddress = msg.sender;
282         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
283     }
284 
285     function balanceOf(address _customerAddress) public view returns (uint256) {
286         return tokenBalanceLedger_[_customerAddress];
287     }
288 
289     function dividendsOf(address _customerAddress) public view returns (uint256) {
290         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
291     }
292     
293     function dividendsFull(address _customerAddress) public view returns (uint256) {
294         return dividendsOf(_customerAddress) + dividendsUsed_[_customerAddress] + summaryReferralProfit_[_customerAddress];
295     }
296 
297     function sellPrice() public view returns (uint256) {
298         return sellPriceAt(tokenSupply_);
299     }
300 
301     function buyPrice() public view returns (uint256) {
302         if (tokenSupply_ == 0) {
303             return tokenPriceInitial_ + tokenPriceIncremental_;
304         } else {
305             uint256 _ethereum = tokensToEthereum_(1e18);
306             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
307             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
308 
309             return _taxedEthereum;
310         }
311     }
312 
313     function calculateTokensReceived(uint256 _incomingEthereum) public view returns (uint256) {
314         uint256 _dividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
315         
316         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
317         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
318 
319         return _amountOfTokens;
320     }
321 
322     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
323         require(_tokensToSell <= tokenSupply_);
324         return tokensToEthereum_(_tokensToSell);
325     }
326     
327     uint256 public I_S = 0.25 ether;
328     uint256 public I_R1 = 30;
329 
330     function setI_S(uint256 _v)
331         onlyAdministrator()
332         public
333     {
334         I_S = _v;
335     }
336 
337     function setI_R1(uint256 _v)
338         onlyAdministrator()
339         public
340     {
341         I_R1 = _v;
342     }
343 
344     
345     uint256 public II_S = 5 ether;
346     uint256 public II_R1 = 30;
347     uint256 public II_R2 = 10;
348 
349     function setII_S(uint256 _v)
350         onlyAdministrator()
351         public
352     {
353         II_S = _v;
354     }
355 
356     function setII_R1(uint256 _v)
357         onlyAdministrator()
358         public
359     {
360         II_R1 = _v;
361     }
362 
363     function setII_R2(uint256 _v)
364         onlyAdministrator()
365         public
366     {
367         II_R2 = _v;
368     }
369     
370     uint256 public III_S = 10 ether;
371     uint256 public III_R1 = 30;
372     uint256 public III_R2 = 10;
373     uint256 public III_R3 = 10;
374 
375     function setIII_S(uint256 _v)
376         onlyAdministrator()
377         public
378     {
379         III_S = _v;
380     }
381 
382     function setIII_R1(uint256 _v)
383         onlyAdministrator()
384         public
385     {
386         III_R1 = _v;
387     }
388 
389     function setIII_R2(uint256 _v)
390         onlyAdministrator()
391         public
392     {
393         III_R2 = _v;
394     }
395 
396     function setIII_R3(uint256 _v)
397         onlyAdministrator()
398         public
399     {
400         III_R3 = _v;
401     }
402     
403     uint256 public IV_S = 20 ether;
404     uint256 public IV_R1 = 30;
405     uint256 public IV_R2 = 20;
406     uint256 public IV_R3 = 10;
407     uint256 public IV_R4 = 10;
408 
409     function setIV_S(uint256 _v)
410         onlyAdministrator()
411         public
412     {
413         IV_S = _v;
414     }
415 
416     function setIV_R1(uint256 _v)
417         onlyAdministrator()
418         public
419     {
420         IV_R1 = _v;
421     }
422 
423     function setIV_R2(uint256 _v)
424         onlyAdministrator()
425         public
426     {
427         IV_R2 = _v;
428     }
429 
430     function setIV_R3(uint256 _v)
431         onlyAdministrator()
432         public
433     {
434         IV_R3 = _v;
435     }
436 
437     function setIV_R4(uint256 _v)
438         onlyAdministrator()
439         public
440     {
441         IV_R4 = _v;
442     }
443     
444     uint256 public V_S = 100 ether;
445     uint256 public V_R1 = 40;
446     uint256 public V_R2 = 20;
447     uint256 public V_R3 = 10;
448     uint256 public V_R4 = 10;
449     uint256 public V_R5 = 10;
450 
451     function setV_S(uint256 _v)
452         onlyAdministrator()
453         public
454     {
455         V_S = _v;
456     }
457 
458     function setV_R1(uint256 _v)
459         onlyAdministrator()
460         public
461     {
462         V_R1 = _v;
463     }
464 
465     function setV_R2(uint256 _v)
466         onlyAdministrator()
467         public
468     {
469         V_R2 = _v;
470     }
471 
472     function setV_R3(uint256 _v)
473         onlyAdministrator()
474         public
475     {
476         V_R3 = _v;
477     }
478 
479     function setV_R4(uint256 _v)
480         onlyAdministrator()
481         public
482     {
483         V_R4 = _v;
484     }
485 
486     function setV_R5(uint256 _v)
487         onlyAdministrator()
488         public
489     {
490         V_R5 = _v;
491     }
492     
493     function canRef(address _r, address _c, uint256 _m) internal returns (bool) {
494         return _r != 0x0000000000000000000000000000000000000000 && _r != _c && tokenBalanceLedger_[_r] >= _m;
495     }
496     
497     function etherBalance(address r) internal returns (uint256) {
498         uint _v = tokenBalanceLedger_[r];
499         if (_v < 0.00000001 ether) {
500             return 0;
501         } else {
502             return tokensToEthereum_(_v);
503         }
504     }
505     
506     function getLevel(address _cb) public view returns (uint256) {
507         uint256 _b = etherBalance(_cb);
508         uint256 _o = 0;
509         
510         if (_b >= V_S) {
511             _o = 5;
512         } else if (_b >= IV_S) {
513             _o = 4;
514         } else if (_b >= III_S) {
515             _o = 3;
516         } else if (_b >= II_S) {
517             _o = 2;
518         } else if (_b >= I_S) {
519             _o = 1;
520         }
521         
522         return _o;
523     }
524 
525     function purchaseTokens(uint256 _incomingEthereum, address _r1, address _r2, address _r3, address _r4, address _r5) internal {
526         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
527         uint256 _dividends = _undividedDividends;
528 
529         uint256 __bC = 0;
530         uint256 _b = 0;
531         
532         if (canRef(_r1, msg.sender, I_S)) {
533             __bC = I_R1;
534 
535             if (etherBalance(_r1) >= V_S) {
536                 __bC = V_R1;
537             } else if (etherBalance(_r1) >= IV_S) {
538                 __bC = IV_R1;
539             } else if (etherBalance(_r1) >= III_S) {
540                 __bC = III_R1;
541             } else if (etherBalance(_r1) >= II_S) {
542                 __bC = II_R1;
543             }
544             
545             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
546             referralBalance_[_r1] = SafeMath.add(referralBalance_[_r1], _b);
547             addReferralProfit(_r1, msg.sender, _b);
548             _dividends = SafeMath.sub(_dividends, _b);
549         }
550         
551         if (canRef(_r2, msg.sender, II_S)) {
552             __bC = II_R2;
553 
554             if (etherBalance(_r2) >= V_S) {
555                 __bC = V_R2;
556             } else if (etherBalance(_r2) >= IV_S) {
557                 __bC = IV_R2;
558             } else if (etherBalance(_r2) >= III_S) {
559                 __bC = III_R2;
560             }
561             
562             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
563             referralBalance_[_r2] = SafeMath.add(referralBalance_[_r2], _b);
564             addReferralProfit(_r2, _r1, _b);
565             _dividends = SafeMath.sub(_dividends, _b);
566         }
567         
568         if (canRef(_r3, msg.sender, III_S)) {
569             __bC = III_R3;
570 
571             if (etherBalance(_r3) >= V_S) {
572                 __bC = V_R3;
573             } else if (etherBalance(_r3) >= IV_S) {
574                 __bC = IV_R3;
575             }
576             
577             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
578             referralBalance_[_r3] = SafeMath.add(referralBalance_[_r3], _b);
579             addReferralProfit(_r3, _r2, _b);
580             _dividends = SafeMath.sub(_dividends, _b);
581         }
582         
583         if (canRef(_r4, msg.sender, IV_S)) {
584             __bC = IV_R4;
585 
586             if (etherBalance(_r4) >= V_S) {
587                 __bC = V_R4;
588             }
589             
590             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, __bC), 1000);
591             referralBalance_[_r4] = SafeMath.add(referralBalance_[_r4], _b);
592             addReferralProfit(_r4, _r3, _b);
593             _dividends = SafeMath.sub(_dividends, _b);
594         }
595         
596         if (canRef(_r5, msg.sender, V_S)) {
597             _b = SafeMath.div(SafeMath.mul(_incomingEthereum, V_R5), 1000);
598             referralBalance_[_r5] = SafeMath.add(referralBalance_[_r5], _b);
599             addReferralProfit(_r5, _r4, _b);
600             _dividends = SafeMath.sub(_dividends, _b);
601         }
602 
603         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
604         uint256 _fee = _dividends * magnitude;
605 
606         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
607 
608         if (tokenSupply_ > 0) {
609             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
610             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
611             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
612         } else {
613             tokenSupply_ = _amountOfTokens;
614         }
615 
616         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
617         payoutsTo_[msg.sender] += (int256) (profitPerShare_ * _amountOfTokens - _fee);
618         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, now, buyPrice());
619     }
620 
621     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
622         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
623         uint256 _tokensReceived =
624             (
625                 (
626                     SafeMath.sub(
627                         (sqrt
628                             (
629                                 (_tokenPriceInitial ** 2)
630                                 +
631                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
632                                 +
633                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
634                                 +
635                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
636                             )
637                         ), _tokenPriceInitial
638                     )
639                 ) / (tokenPriceIncremental_)
640             ) - (tokenSupply_);
641 
642         return _tokensReceived;
643     }
644 
645     function sellPriceAt(uint256 _atSupply) public view returns (uint256) {
646         if (_atSupply == 0) {
647             return tokenPriceInitial_ - tokenPriceIncremental_;
648         } else {
649             uint256 _ethereum = tokensToEthereumAtSupply_(1e18, _atSupply);
650             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
651             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
652  
653             return _taxedEthereum;
654         }
655     }
656    
657     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
658         return tokensToEthereumAtSupply_(_tokens, tokenSupply_);
659     }
660  
661     function tokensToEthereumAtSupply_(uint256 _tokens, uint256 _atSupply) public view returns (uint256) {
662         if (_tokens < 0.00000001 ether) {
663             return 0;
664         }
665         uint256 tokens_ = (_tokens + 1e18);
666         uint256 _tokenSupply = (_atSupply + 1e18);
667         uint256 _etherReceived =
668             (
669                 SafeMath.sub(
670                     (
671                         (
672                             (
673                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
674                             ) - tokenPriceIncremental_
675                         ) * (tokens_ - 1e18)
676                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
677                 )
678                 / 1e18);
679  
680         return _etherReceived;
681     }
682 
683     function sqrt(uint256 x) internal pure returns (uint256 y) {
684         uint256 z = (x + 1) / 2;
685         y = x;
686 
687         while (z < y) {
688             y = z;
689             z = (x / z + z) / 2;
690         }
691     }
692     
693     mapping(address => mapping(address => uint256)) internal referralProfit_;
694     
695     function addReferralProfit(address _referredBy, address _referral, uint256 _profit) internal {
696         referralProfit_[_referredBy][_referral] += _profit;
697         summaryReferralProfit_[_referredBy] += _profit;
698     }
699     
700     function getReferralProfit(address _referredBy, address _referral) public view returns (uint256) {
701         return referralProfit_[_referredBy][_referral];
702     }
703     
704     function getSummaryReferralProfit(address _referredBy) public view returns (uint256) {
705         if (_ownerAddress == _referredBy) {
706             return 0;
707         } else {
708             return summaryReferralProfit_[_referredBy];
709         }
710     }
711 
712 }
713 
714 library SafeMath {
715     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
716         if (a == 0) {
717             return 0;
718         }
719         uint256 c = a * b;
720         assert(c / a == b);
721         return c;
722     }
723 
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         uint256 c = a / b;
726         return c;
727     }
728 
729     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
730         assert(b <= a);
731         return a - b;
732     }
733 
734     function add(uint256 a, uint256 b) internal pure returns (uint256) {
735         uint256 c = a + b;
736         assert(c >= a);
737         return c;
738     }
739 }