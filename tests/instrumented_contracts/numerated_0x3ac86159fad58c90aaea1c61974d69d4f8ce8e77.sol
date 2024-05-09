1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10  
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15  
16   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20  
21   function add(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract Ownable {
29     
30   address public owner;
31  
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   function transferOwnership(address newOwner) onlyOwner {
42     require(newOwner != address(0));      
43     owner = newOwner;
44   }
45  
46 }
47 
48 contract SingleTokenCoin {
49   function totalSupply() constant returns(uint256);
50   function finishMinting();
51   function moveUnsold(address _addr);
52   function setFreeze(address _addr);
53   function removeFreeze(address _addr);
54   function transfer(address _to, uint256 _value);
55   function newTransferManualTokensnewTransfer(address _from, address _to, uint256 _value) returns (bool);
56   function transferTokens(address _to, uint256 _amount, uint256 freezeTime, uint256 _type);
57   function transferTokens(address _from, address _to, uint256 _amount, uint256 freezeTime, uint256 _type);
58   function withdrowTokens(address _address, uint256 _tokens);
59   function setTotalSupply(address _addr);
60   function tokenTransferOwnership(address _address);
61   function getOwnerToken() constant returns(address);
62 }
63 
64 contract WrapperOraclize {
65   function update(string datasource, string arg) payable;
66   function getWrapperData() constant returns(bytes32);
67   function() external payable;
68 }
69 
70 contract Crowdsale is Ownable {
71 
72   //string public ETHUSD;
73 
74   using SafeMath for uint256;
75 
76   //SingleTokenCoin public token = SingleTokenCoin(0xf579F37FE3129c4C897d2a9561f9D8DbEa3A0943);
77     SingleTokenCoin public token;
78 
79   //Address from testnet
80   //WrapperOraclize private wrapper = WrapperOraclize(0x676b33cdcc3fa7b994ca6d16cd3c9dfe3c64ec52);
81 
82   //Address from mainnet
83   WrapperOraclize private wrapper = WrapperOraclize(0xfC484c66daE464CC6055d7a4782Ec8761dc9842F);
84 
85   uint256 private angel_sale_start;
86   uint256 private angel_sale_finish;
87 
88   uint256 private pre_sale_start;
89   uint256 private pre_sale_finish;
90 
91   uint256 private public_sale_start;
92   uint256 private public_sale_finish;
93 
94   bool private isAngel;
95   bool private isPreSale;
96   bool private isPublic;
97 
98   uint256 private angel_rate;
99   uint256 private public_rate;
100 
101   uint256 private decimals;
102 
103   uint256 private totalETH;
104 
105   address public coreTeamAddr;
106   address public itDevAddr;
107   address public futDevAddr;
108   address public commFoundAddr;
109   address public socWarefareAddr;
110   address public marketingAddr;
111 
112   address public unsoldAddr;
113   address public collectAddr;  
114   
115   bool public mintingFinished = false;
116 
117   //Storage for Founding Buyers Token
118   mapping(address => uint256) private founding_buyers_token;  // 0
119 
120   //Storage for Angel Buyers ETH
121   mapping(address => uint256) private angel_buyers_eth;       // 2
122 
123   //Storage for Angel Buyers Token
124   mapping(address => uint256) private angel_buyers_token;     // 2
125 
126   //Storage for Angel Buyers ETH
127   mapping(address => uint256) private pre_sale_buyers_eth;    // 1
128 
129   //Storage for Angel Buyers Token
130   mapping(address => uint256) private pre_sale_buyers_token;  // 1
131 
132   //Storage for Angel Buyers Token
133   mapping(address => uint256) private pe_buyers_token;        // 3
134 
135   //Storage for Angel Buyers ETH
136   mapping(address => uint256) private public_buyers_eth;      // 4
137 
138   //Storage for Angel Buyers Token
139   mapping(address => uint256) private public_buyers_token;    // 4
140 
141   address[] private founding_investors; // 0
142   address[] private pre_sale_investors; // 1
143   address[] private angel_investors;    // 2
144   address[] private pe_investors;       // 3
145   address[] private public_investors;   // 4
146 
147   uint256 private soldTokens;
148   
149   uint256 private maxcup;
150 
151   uint256 private totalAmount; 
152   uint256 private foundingAmount; 
153   uint256 private angelAmount;  
154   uint256 private preSaleAmount;
155   uint256 private PEInvestorAmount;
156   uint256 private publicSaleAmount;
157 
158   uint256 private coreTeamAmount;
159   uint256 private coreTeamAuto;
160   uint256 private coreTeamManual;
161   uint256 private itDevAmount;  
162   uint256 private futDevAmount; 
163   uint256 private commFoundAmount;
164   uint256 private socWarefareAmount;
165   uint256 private marketingAmount;
166 
167   uint256 private angel_sale_sold;
168   uint256 private pre_sale_sold;
169   uint256 private public_sale_sold;
170   uint256 private founding_sold;
171   uint256 private peInvestors_sold;
172 
173   uint256 private angel_sale_totalETH;
174   uint256 private pre_sale_totalETH;
175   uint256 private public_sale_totalETH;
176 
177   uint256 private firstPhaseAmount;
178   uint256 private secondPhaseAmount; 
179   uint256 private thirdPhaseAmount;  
180   uint256 private fourPhaseAmount;
181 
182   uint256 private firstPhaseDiscount;
183   uint256 private secondPhaseDiscount;
184   uint256 private thirdPhaseDiscount;
185   uint256 private fourPhaseDiscount;
186 
187   uint256 private currentPhase;
188 
189   bool private moveTokens;
190 
191   bool withdrowTokensComplete = false;  
192 
193   function Crowdsale(address token_addr) {
194 
195     token = SingleTokenCoin(token_addr);
196 
197     //set calculate rate from USD
198     public_rate = 3546099290780141; // ~ 1 USD
199 
200     angel_rate = 20;
201 
202     decimals = 35460992907801; // 18 decimals
203 
204     //now
205     angel_sale_start = now - 3 days;
206     //06.12.2017 08:30 AM
207     angel_sale_finish = 1510488000;
208 
209     //07.12.2017 08:30 AM
210     pre_sale_start = 1510491600;
211     //06 .01.2018 08:30 AM
212     pre_sale_finish = 1512561600;
213 
214     //07.01.2018 08:30 AM
215     //public_sale_start = 1512565200;
216     public_sale_start = 1512565200;
217     //10.01.2018 08:30 AM
218     public_sale_finish = public_sale_start + 14 days;
219 
220     moveTokens = false;
221     
222     isAngel = true;
223     isPreSale = false;
224     isPublic = false;
225 
226     currentPhase = 1;
227 
228     founding_sold = 0;
229     peInvestors_sold = 0;
230     angel_sale_sold = 0;
231     pre_sale_sold = 0;
232     public_sale_sold = 0;
233 
234     angel_sale_totalETH = 0;
235     pre_sale_totalETH = 0;
236     public_sale_totalETH = 0;
237 
238     firstPhaseAmount = 18750000E18;     // 18 750 000;  // with 18 decimals
239     secondPhaseAmount = 37500000E18;    // 37 500 000;  // with 18 decimals
240     thirdPhaseAmount = 56250000E18;     // 56 250 000;  // with 18 decimals-
241     fourPhaseAmount = 75000000E18;      // 75 000 000;  // with 18 decimals
242 
243     firstPhaseDiscount = 30;
244     secondPhaseDiscount = 40;
245     thirdPhaseDiscount = 50;
246     fourPhaseDiscount = 60;
247 
248     totalAmount = 500000000E18;         // 500 000 000;  // with 18 decimals
249     foundingAmount = 10000000E18;       //  10 000 000;  // with 18 decimals
250     angelAmount = 25000000E18;          //  25 000 000;  // with 18 decimals
251     preSaleAmount = 75000000E18;        //  75 000 000;  // with 18 decimals
252     PEInvestorAmount = 50000000E18;     //  50 000 000;  // with 18 decimals
253     publicSaleAmount = 100000000E18;    // 100 000 000;  // with 18 decimals
254 
255     coreTeamAmount = 100000000E18;      // 100 000 000;  // with 18 decimals
256     coreTeamAuto = 60000000E18;         //  60 000 000;  // with 18 decimals
257     coreTeamManual = 40000000E18;       //  40 000 000;  // with 18 decimals
258     itDevAmount = 50000000E18;          //  50 000 000;  // with 18 decimals
259     futDevAmount = 50000000E18;         //  50 000 000;  // with 18 decimals
260     commFoundAmount = 15000000E18;      //  15 000 000;  // with 18 decimals
261     socWarefareAmount = 10000000E18;    //  10 000 000;  // with 18 decimals
262     marketingAmount = 15000000E18;      //  15 000 000;  // with 18 decimals
263 
264     mintingFinished = false;
265 
266     coreTeamAddr = 0xB0A3A845cfA5e2baCD3925Af85c59dE4D32D874f;
267     itDevAddr = 0x61528ffdCd4BC26c81c88423018780b399Fbb8e7;
268     futDevAddr = 0xA1f9C3F137496e6b8bA4445d15b0986CaA22FDe3;
269     commFoundAddr = 0xC30a0E7FFad754A9AD2A1C1cFeB10e05f7C7aB6A;
270     socWarefareAddr = 0xd5d692C89C83313579d02C94F4faE600fe30D1d9;
271     marketingAddr = 0x5490510072b929273F65dba4B72c96cd45A99b5A;
272 
273     unsoldAddr = 0x18051b5b0F1FDb4D44eACF2FA49f19bB80105Fc1;
274     collectAddr = 0xB338121B8e5dA0900a6E8580321293f3CF52E58D;
275 
276   }
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   function setFreeze(address _addr) public onlyOwner {
284     token.setFreeze(_addr);
285   }
286 
287   function removeFreeze(address _addr) public onlyOwner {
288     token.removeFreeze(_addr);
289   }
290 
291   function moveUnsold() public onlyOwner {
292     angelAmount = 0;
293     preSaleAmount = 0;
294     publicSaleAmount = 0;
295 
296     angel_sale_sold = 0;
297     pre_sale_sold = 0;
298     public_sale_sold = 0;
299     token.moveUnsold(unsoldAddr);
300   }
301 
302   function newTransferManualTokensnewTransfer(address _from, address _to, uint256 _value) onlyOwner returns (bool) {
303     return token.newTransferManualTokensnewTransfer(_from, _to, _value);
304   }
305 
306   function() external payable {
307     mint();    
308   }
309 
310   function bytesToUInt(bytes32 v) private constant returns (uint ret) {
311     if (v == 0x0) {
312         revert();
313     }
314 
315     uint digit;
316 
317     for (uint i = 0; i < 32; i++) {
318       digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
319       if (digit == 0 || digit == 46) {
320           break;
321       }
322       else if (digit < 48 || digit > 57) {
323           revert();
324       }
325       ret *= 10;
326       ret += (digit - 48);
327     }
328     return ret;
329   }
330 
331   function calculateRate() public constant returns(uint256) {
332     bytes32 result = getWrapperData();
333     uint256 usd = bytesToUInt(result);
334 
335     uint256 price = 1 ether / usd; //price for 1 BMC //4545454545454546;
336 
337     return price;
338   }
339 
340   function calculatePrice(uint256 _usd, uint256 _pre_sale_sold) private constant returns(uint256) {
341     
342     if (currentPhase == 1 && pre_sale_sold + _pre_sale_sold <= firstPhaseAmount) {
343       return _usd.mul(firstPhaseDiscount).div(100);
344     }
345 
346     if (currentPhase == 2 && pre_sale_sold + _pre_sale_sold > firstPhaseAmount && pre_sale_sold + _pre_sale_sold <= secondPhaseAmount) {
347       return _usd.mul(secondPhaseDiscount).div(100);
348     }
349 
350     if (currentPhase == 3 && pre_sale_sold + _pre_sale_sold > secondPhaseAmount && pre_sale_sold + _pre_sale_sold <= thirdPhaseAmount) {
351       return _usd.mul(thirdPhaseDiscount).div(100);
352     }
353 
354     if (currentPhase == 4 && pre_sale_sold + _pre_sale_sold > thirdPhaseAmount && pre_sale_sold + _pre_sale_sold <= fourPhaseAmount) {
355       return _usd.mul(fourPhaseDiscount).div(100);
356     }
357 
358     return _usd;
359   }
360 
361   function sendToAddress(address _address, uint256 _tokens, uint256 _type) canMint onlyOwner public {
362 
363    if (_type != 1 && _type != 2 && _type != 3) {
364      revert();
365    }
366 
367     //Founding
368     if (_type == 1) {
369       if (founding_sold + _tokens > foundingAmount) {
370         revert();
371       }
372 
373       if (founding_buyers_token[_address] == 0) {
374         founding_investors.push(_address);
375       }
376 
377       require(foundingAmount >= _tokens);
378 
379       founding_buyers_token[_address] = founding_buyers_token[_address].add(_tokens);
380     
381       founding_sold = founding_sold + _tokens;
382 
383       token.transferTokens(_address, _tokens, public_sale_start, 1);
384 
385       foundingAmount = foundingAmount - _tokens;
386     }
387     // PE Investors
388     if (_type == 2) {
389       if (peInvestors_sold + _tokens > PEInvestorAmount) {
390         revert();
391       }
392 
393       if (pe_buyers_token[_address] == 0) {
394         pe_investors.push(_address);
395       }
396 
397       require(PEInvestorAmount >= _tokens);
398 
399       pe_buyers_token[_address] = pe_buyers_token[_address].add(_tokens);
400     
401       peInvestors_sold = peInvestors_sold + _tokens;
402       
403       token.transferTokens(_address, _tokens, public_sale_start, 2);
404 
405       PEInvestorAmount = PEInvestorAmount - _tokens;
406     }
407     //Core Team
408     if (_type == 3) {
409       require(coreTeamAmount >= _tokens);
410       token.transferTokens(coreTeamAddr, _address, _tokens, public_sale_start, 3);
411       coreTeamAmount = coreTeamAmount - _tokens;
412     } else {
413       soldTokens = soldTokens + _tokens;
414     }
415   }
416 
417   modifier isICOFinished() {
418     if (now > public_sale_finish) {
419       finishMinting();
420     }
421     _;
422   }
423 
424   modifier isAnyStage() {
425     if (now > angel_sale_finish && now > pre_sale_finish && now > public_sale_finish) {
426       revert();
427     }
428 
429     if (now < angel_sale_start && now < pre_sale_start && now < public_sale_start) {
430       revert();
431     }
432 
433     _;
434   }
435 
436   function setTransferOwnership(address _address) public onlyOwner {
437 
438     transferOwnership(_address);
439   }
440 
441   //only for demonstrate Test Version
442   function setAngelDate(uint256 _time) public onlyOwner {
443     angel_sale_start = _time;
444   }
445 
446   //only for demonstrate Test Version
447   function setPreSaleDate(uint256 _time) public onlyOwner {
448     pre_sale_start = _time;
449   }
450 
451   //only for demonstrate Test Version
452   function setPublicSaleDate(uint256 _time) public onlyOwner {
453     public_sale_start = _time;
454   }
455 
456   function getStartDates() public constant returns(uint256 _angel_sale_start, uint256 _pre_sale_start, uint256 _public_sale_start) {
457     return (angel_sale_start, pre_sale_start, public_sale_start);
458   }
459 
460   //only for demonstrate Test Version
461   function setAngelFinishDate(uint256 _time) public onlyOwner {
462     angel_sale_finish = _time;
463   }
464 
465   //only for demonstrate Test Version
466   function setPreSaleFinishDate(uint256 _time) public onlyOwner {
467     pre_sale_finish = _time;
468   }
469 
470   //only for demonstrate Test Version
471   function setPublicSaleFinishDate(uint256 _time) public onlyOwner {
472     public_sale_finish = _time;
473   }
474 
475   function getFinishDates() public constant returns(uint256 _angel_sale_finish, uint256 _pre_sale_finish, uint256 _public_sale_finish) {
476     return (angel_sale_finish, pre_sale_finish, public_sale_finish);
477   }
478 
479   function mint() public canMint isICOFinished isAnyStage payable {
480 
481     if (now > angel_sale_finish && now < pre_sale_finish) {
482       isPreSale = true;
483       isAngel = false;
484     }
485 
486     if (now > pre_sale_finish && now < public_sale_finish) {
487       isPreSale = false;
488       isAngel = false;
489       isPublic = true;
490     }
491 
492     if (now > angel_sale_finish && now < pre_sale_start) {
493       revert();
494     }
495 
496     if (now > pre_sale_finish && now < public_sale_start) {
497       revert();
498     }
499 
500     if (isAngel && angelAmount == angel_sale_sold) {
501       revert();
502     }
503 
504     if (isPreSale && preSaleAmount == pre_sale_sold) {
505       revert();
506     }
507 
508     if (isPublic && publicSaleAmount == public_sale_sold) {
509       revert();
510     }
511 
512     public_rate = calculateRate();
513 
514     uint256 eth = msg.value * 1E18;
515 
516     uint256 discountPrice = 0;
517 
518     if (isPreSale) {
519       discountPrice = calculatePrice(public_rate, 0);
520       pre_sale_totalETH = pre_sale_totalETH + eth;
521     }
522 
523     if (isAngel) {
524       discountPrice = public_rate.mul(angel_rate).div(100);
525       angel_sale_totalETH = angel_sale_totalETH + eth;
526     }
527 
528     uint currentRate = 0;
529 
530     if (isPublic) {
531       currentRate = public_rate;
532       public_sale_totalETH = public_sale_totalETH + eth;
533     } else {
534       currentRate = discountPrice;
535     }
536 
537     if (eth < currentRate) {
538       revert();
539     }
540 
541     uint256 tokens = eth.div(currentRate);
542 
543     if (isPublic && !moveTokens) {
544       if (angelAmount > angel_sale_sold) {
545         uint256 angelRemainder = angelAmount - angel_sale_sold;
546         publicSaleAmount = publicSaleAmount + angelRemainder;
547       }
548       if (preSaleAmount > pre_sale_sold) {
549         uint256 preSaleRemainder = preSaleAmount - pre_sale_sold;
550         publicSaleAmount = publicSaleAmount + preSaleRemainder;
551       }
552       moveTokens = true;
553     }
554 
555     if (isPreSale) {
556       uint256 availableTokensPhase = 0;
557       uint256 ethToRefundPhase = 0;
558 
559       uint256 remETH = 0;
560 
561       uint256 totalTokensPhase = 0;
562 
563       if (currentPhase == 1 && pre_sale_sold + tokens > firstPhaseAmount) {
564         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(firstPhaseAmount, pre_sale_sold, currentRate, tokens);
565         totalTokensPhase = availableTokensPhase;
566 
567         remETH = ethToRefundPhase;
568 
569         currentPhase = 2;
570 
571         currentRate = calculatePrice(pre_sale_sold, totalTokensPhase);
572         tokens = remETH.div(currentRate);
573       }
574 
575       if (currentPhase == 2 && pre_sale_sold + tokens + totalTokensPhase > secondPhaseAmount) {
576         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(secondPhaseAmount, pre_sale_sold, currentRate, tokens);
577         totalTokensPhase = totalTokensPhase + availableTokensPhase;
578         
579         remETH = ethToRefundPhase;
580 
581         currentPhase = 3;
582 
583         currentRate = calculatePrice(pre_sale_sold, totalTokensPhase);
584         tokens = remETH.div(currentRate);
585       }
586 
587       if (currentPhase == 3 && pre_sale_sold + tokens + totalTokensPhase > thirdPhaseAmount) {
588         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(thirdPhaseAmount, pre_sale_sold, currentRate, tokens);
589         totalTokensPhase = totalTokensPhase + availableTokensPhase;
590         
591         remETH = ethToRefundPhase;
592 
593         currentPhase = 4;
594 
595         currentRate = calculatePrice(pre_sale_sold, totalTokensPhase);
596         tokens = remETH.div(currentRate);
597       }
598 
599       if (currentPhase == 4 && pre_sale_sold + tokens + totalTokensPhase > fourPhaseAmount) {
600         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(fourPhaseAmount, pre_sale_sold, currentRate, tokens);
601         totalTokensPhase = totalTokensPhase + availableTokensPhase;
602         
603         remETH = ethToRefundPhase;
604 
605         currentPhase = 0;
606 
607         currentRate = calculatePrice(pre_sale_sold, totalTokensPhase);
608         tokens = remETH.div(currentRate);
609       }
610 
611       tokens = tokens + totalTokensPhase;
612     }
613 
614     if (isPreSale) {
615       if (pre_sale_sold + tokens > preSaleAmount) {
616         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(preSaleAmount, pre_sale_sold, currentRate, tokens);
617         tokens = availableTokensPhase;
618         eth = eth - ethToRefundPhase;
619         refund(ethToRefundPhase);
620       }
621     }
622 
623     if (isAngel) {
624       if (angel_sale_sold + tokens > angelAmount) {
625         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(angelAmount, angel_sale_sold, currentRate, tokens);
626         tokens = availableTokensPhase;
627         eth = eth - ethToRefundPhase;
628         refund(ethToRefundPhase);
629         
630       }    
631     }
632 
633     if (isPublic) {
634       if (public_sale_sold + tokens > publicSaleAmount) {
635         (availableTokensPhase, ethToRefundPhase) = calculateMinorRefund(publicSaleAmount, public_sale_sold, currentRate, tokens);
636         tokens = availableTokensPhase;
637         eth = eth - ethToRefundPhase;
638         refund(ethToRefundPhase);
639         
640       }
641     }
642 
643     saveInfoAboutInvestors(msg.sender, eth, tokens);
644 
645     if (isAngel) {
646       token.transferTokens(msg.sender, tokens, public_sale_start, 0);
647     } else {
648       // 0 - not freeze time; 4 - not freeze type currently;
649       token.transferTokens(msg.sender, tokens, 0, 4);
650     }
651 
652     soldTokens = soldTokens + tokens;
653     
654     totalETH = totalETH + eth;
655   }
656 
657   function calculateMinorRefund(uint256 _maxcup, uint256 _sold, uint256 _rate, uint256 _tokens) private returns(uint256 _availableTokens, uint256 _ethToRefund) {
658     uint256 availableTokens = _maxcup - _sold;
659     uint256 tokensForRefund = _tokens - availableTokens;
660     uint256 refundETH = tokensForRefund * _rate;
661 
662     return (availableTokens, refundETH);
663   }
664 
665   function withdrowETH() public onlyOwner {
666     require(now > public_sale_finish);
667 
668     collectAddr.transfer(this.balance);
669   }
670 
671   function withdrowTokens() public onlyOwner {    
672     if (!withdrowTokensComplete) {
673       
674       token.withdrowTokens(coreTeamAddr, coreTeamAmount);
675       token.withdrowTokens(itDevAddr, itDevAmount);
676       token.withdrowTokens(futDevAddr, futDevAmount);
677       token.withdrowTokens(commFoundAddr, commFoundAmount);
678       token.withdrowTokens(socWarefareAddr, socWarefareAmount);
679       token.withdrowTokens(marketingAddr, marketingAmount);
680 
681       withdrowTokensComplete = true;
682     }
683   }
684 
685   function saveInfoAboutInvestors(address _address, uint256 _amount, uint256 _tokens) private {
686     if (isAngel) {
687       if (angel_buyers_token[_address] == 0) {
688         angel_investors.push(_address);
689       }
690 
691       angel_buyers_eth[_address] = angel_buyers_eth[_address].add(_amount);
692 
693       angel_buyers_token[_address] = angel_buyers_token[_address].add(_tokens);
694 
695       angel_sale_sold = angel_sale_sold + _tokens;
696     }
697 
698     if (isPreSale) {
699       if (pre_sale_buyers_token[_address] == 0) {
700         pre_sale_investors.push(_address);
701       }
702 
703       pre_sale_buyers_eth[_address] = pre_sale_buyers_eth[_address].add(_amount);
704 
705       pre_sale_buyers_token[_address] = pre_sale_buyers_token[_address].add(_tokens);
706     
707       pre_sale_sold = pre_sale_sold + _tokens;
708     }
709 
710     if (isPublic) {
711       if (public_buyers_token[_address] == 0) {
712         public_investors.push(_address);
713       }
714 
715       public_buyers_eth[_address] = public_buyers_eth[_address].add(_amount);
716 
717       public_buyers_token[_address] = public_buyers_token[_address].add(_tokens);
718     
719       public_sale_sold = public_sale_sold + _tokens;
720     }
721   }
722 
723   // Change for private when deploy to main net
724   function finishMinting() public onlyOwner {
725 
726     if (mintingFinished) {
727       revert();
728     }
729 
730     token.finishMinting();
731 
732     mintingFinished = true;
733   }
734 
735   function getFinishStatus() public constant returns(bool) {
736     return mintingFinished;
737   }
738 
739   function refund(uint256 _amount) private {
740     msg.sender.transfer(_amount);
741   }
742 
743   function getBalanceContract() public constant returns(uint256) {
744     return this.balance;
745   }
746 
747   function getSoldToken() public constant returns(uint256 _soldTokens, uint256 _angel_sale_sold, uint256 _pre_sale_sold, uint256 _public_sale_sold, uint256 _founding_sold, uint256 _peInvestors_sold) {
748     return (soldTokens, angel_sale_sold, pre_sale_sold, public_sale_sold, founding_sold, peInvestors_sold);
749   }
750 
751   function getInvestorsTokens(address _address, uint256 _type) public constant returns(uint256) {
752     if (_type == 0) {
753       return founding_buyers_token[_address];
754     }
755     if (_type == 1) {
756       return pre_sale_buyers_token[_address];
757     }
758     if (_type == 2) {
759       return angel_buyers_token[_address];
760     }
761     if (_type == 3) {
762       return pe_buyers_token[_address];
763     }
764     if (_type == 4) {
765       return public_buyers_token[_address];
766     }
767   }
768 
769   function getInvestorsCount(uint256 _type) public constant returns(uint256) {
770     if (_type == 0) {
771       return founding_investors.length;
772     }
773     if (_type == 1) {
774       return pre_sale_investors.length;
775     }
776     if (_type == 2) {
777       return angel_investors.length;
778     }
779     if (_type == 3) {
780       return pe_investors.length;
781     }
782     if (_type == 4) {
783       return public_investors.length;
784     }
785   }
786 
787   function getInvestorByIndex(uint256 _index, uint256 _type) public constant returns(address) {
788     if (_type == 0) {
789       return founding_investors[_index];
790     }
791     if (_type == 1) {
792       return pre_sale_investors[_index];
793     }
794     if (_type == 2) {
795       return angel_investors[_index];
796     }
797     if (_type == 3) {
798       return pe_investors[_index];
799     }
800     if (_type == 4) {
801       return public_investors[_index];
802     }
803   }
804 
805   function getLeftToken() public constant returns(uint256 _all_left, uint256 _founding_left, uint256 _angel_left, uint256 _preSaleAmount_left, uint256 _PEInvestorAmount_left, uint256 _publicSaleAmount_left) {
806     uint256 all_left = token.totalSupply() != 0 ? token.totalSupply() - soldTokens : token.totalSupply();
807     uint256 founding_left = foundingAmount != 0 ? foundingAmount - founding_sold : foundingAmount;
808     uint256 angel_left = angelAmount != 0 ? angelAmount - angel_sale_sold : angelAmount;
809     uint256 preSaleAmount_left = preSaleAmount != 0 ? preSaleAmount - pre_sale_sold : preSaleAmount;
810     uint256 PEInvestorAmount_left = PEInvestorAmount != 0 ? PEInvestorAmount - peInvestors_sold : PEInvestorAmount;
811     uint256 publicSaleAmount_left = publicSaleAmount != 0 ? publicSaleAmount - public_sale_sold : publicSaleAmount;
812 
813     return (all_left, founding_left, angel_left, preSaleAmount_left, PEInvestorAmount_left, publicSaleAmount_left);
814   }
815 
816   function getTotalToken() public constant returns(uint256 _totalToken, uint256 _foundingAmount, uint256 _angelAmount, uint256 _preSaleAmount, uint256 _PEInvestorAmount, uint256 _publicSaleAmount) {
817     return (token.totalSupply(), foundingAmount, angelAmount, preSaleAmount, PEInvestorAmount, publicSaleAmount);
818   }
819 
820   function getTotalETH() public constant returns(uint256 _totalETH, uint256 _angel_sale_totalETH, uint256 _pre_sale_totalETH, uint256 _public_sale_totalETH) {
821     return (totalETH, angel_sale_totalETH, pre_sale_totalETH, public_sale_totalETH);
822   }
823 
824   function getCurrentPrice() public constant returns(uint256) {  
825     uint256 price = calculateRate();
826     return calculatePrice(price, 0);
827   }
828 
829   function getContractAddress() public constant returns(address) {
830     return this;
831   }
832 
833   function getOwner() public constant returns(address) {
834     return owner;
835   }
836 
837   function sendOracleData() public payable {
838     if (msg.value != 0) {
839         wrapper.transfer(msg.value);
840     }
841     
842     wrapper.update("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
843   }
844 
845   function getWrapperData() public constant returns(bytes32) {
846     return wrapper.getWrapperData();
847   }
848 }