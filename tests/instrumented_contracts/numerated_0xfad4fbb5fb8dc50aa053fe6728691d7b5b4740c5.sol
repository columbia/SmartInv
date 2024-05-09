1 pragma solidity ^0.4.20;
2 
3 /*
4 Project: XPA Exchange - https://xpa.exchange
5 Author : Luphia Chang - luphia.chang@isuncloud.com
6  */
7 
8 interface Token {
9     function totalSupply() constant external returns (uint256 ts);
10     function balanceOf(address _owner) constant external returns (uint256 balance);
11     function transfer(address _to, uint256 _value) external returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
13     function approve(address _spender, uint256 _value) external returns (bool success);
14     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
15 }
16 
17 contract SafeMath {
18     function safeAdd(uint x, uint y)
19         internal
20         pure
21     returns(uint) {
22       uint256 z = x + y;
23       require((z >= x) && (z >= y));
24       return z;
25     }
26 
27     function safeSub(uint x, uint y)
28         internal
29         pure
30     returns(uint) {
31       require(x >= y);
32       uint256 z = x - y;
33       return z;
34     }
35 
36     function safeMul(uint x, uint y)
37         internal
38         pure
39     returns(uint) {
40       uint z = x * y;
41       require((x == 0) || (z / x == y));
42       return z;
43     }
44     
45     function safeDiv(uint x, uint y)
46         internal
47         pure
48     returns(uint) {
49         require(y > 0);
50         return x / y;
51     }
52 
53     function random(uint N, uint salt)
54         internal
55         view
56     returns(uint) {
57       bytes32 hash = keccak256(block.number, msg.sender, salt);
58       return uint(hash) % N;
59     }
60 }
61 
62 contract Authorization {
63     mapping(address => address) public agentBooks;
64     address public owner;
65     address public operator;
66     address public bank;
67     bool public powerStatus = true;
68 
69     function Authorization()
70         public
71     {
72         owner = msg.sender;
73         operator = msg.sender;
74         bank = msg.sender;
75     }
76 
77     modifier onlyOwner
78     {
79         assert(msg.sender == owner);
80         _;
81     }
82     modifier onlyOperator
83     {
84         assert(msg.sender == operator || msg.sender == owner);
85         _;
86     }
87     modifier onlyActive
88     {
89         assert(powerStatus);
90         _;
91     }
92 
93     function transferOwnership(address newOwner_)
94         onlyOwner
95         public
96     {
97         owner = newOwner_;
98     }
99     
100     function assignOperator(address user_)
101         public
102         onlyOwner
103     {
104         operator = user_;
105         agentBooks[bank] = user_;
106     }
107     
108     function assignBank(address bank_)
109         public
110         onlyOwner
111     {
112         bank = bank_;
113     }
114 
115     function assignAgent(
116         address agent_
117     )
118         public
119     {
120         agentBooks[msg.sender] = agent_;
121     }
122 
123     function isRepresentor(
124         address representor_
125     )
126         public
127         view
128     returns(bool) {
129         return agentBooks[representor_] == msg.sender;
130     }
131 
132     function getUser(
133         address representor_
134     )
135         internal
136         view
137     returns(address) {
138         return isRepresentor(representor_) ? representor_ : msg.sender;
139     }
140 }
141 
142 /*  Error Code
143     0: insufficient funds (user)
144     1: insufficient funds (contract)
145     2: invalid amount
146     3: invalid price
147  */
148 
149 /*
150     1. 檢驗是否指定代理用戶，若是且為合法代理人則將操作角色轉換為被代理人，否則操作角色不變
151     2. 檢驗此操作是否有存入 ETH，有則暫時紀錄存入額度 A，若掛單指定 fromToken 不是 ETH 則直接更新用戶 ETH 帳戶餘額
152     3. 檢驗此操作是否有存入 fromToken，有則暫時紀錄存入額度 A
153     4. 檢驗用戶 fromToken 帳戶餘額 + 存入額度 A 是否 >= Amount，若是送出 makeOrder 掛單事件，否則結束操作
154     5. 依照 fromToken、toToken 尋找可匹配的交易對 P
155     6. 找出 P 的最低價格單進行匹配，記錄匹配數量，送出 fillOrder 成交事件，並結算 maker 交易結果，若成交完還有掛單數量有剩且未達迴圈次數上限則重複此步驟
156     7. 統計步驟 6 總成交量、交易價差利潤、交易手續費
157     8. 若扣除總成交量後 Taker 掛單尚未撮合完，則將剩餘額度轉換為 Maker 單
158     9. 結算交易所手續費
159     10. 結算 Taker 交易結果
160  */
161 
162 contract Baliv is SafeMath, Authorization {
163     /* struct for exchange data */
164     struct linkedBook {
165         uint256 amount;
166         address nextUser;
167     }
168 
169     /* business options */
170     mapping(address => uint256) public minAmount;
171     uint256[3] public feerate = [0, 1 * (10 ** 15), 1 * (10 ** 15)];
172     uint256 public autoMatch = 10;
173     uint256 public maxAmount = 10 ** 27;
174     uint256 public maxPrice = 10 ** 36;
175     address public XPAToken = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
176 
177     /* exchange data */
178     mapping(address => mapping(address => mapping(uint256 => mapping(address => linkedBook)))) public orderBooks;
179     mapping(address => mapping(address => mapping(uint256 => uint256))) public nextOrderPrice;
180     mapping(address => mapping(address => uint256)) public priceBooks;
181     
182     /* user data */
183     mapping(address => mapping(address => uint256)) public balances;
184     mapping(address => bool) internal manualWithdraw;
185 
186     /* event */
187     event eDeposit(address user,address token, uint256 amount);
188     event eWithdraw(address user,address token, uint256 amount);
189     event eMakeOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
190     event eFillOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
191     event eCancelOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
192 
193     //event Error(uint256 code);
194 
195     /* constructor */
196     function Baliv() public {}
197 
198     /* Operator Function
199         function setup(uint256 autoMatch, uint256 maxAmount, uint256 maxPrice) external;
200         function setMinAmount(address token, uint256 amount) external;
201         function setFeerate(uint256[3] [maker, taker, autoWithdraw]) external;
202     */
203 
204     /* External Function
205         function () public payable;
206         function deposit(address token, address representor) external payable;
207         function withdraw(address token, uint256 amount, address representor) external returns(bool);
208         function userTakeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external payable returns(bool);
209         function userCancelOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external returns(bool);
210         function caculateFee(address user, uint256 amount, uint8 role) external returns(uint256 remaining, uint256 fee);
211         function trade(address fromToken, address toToken) external;
212         function setManualWithdraw(bool) external;
213         function getMinAmount(address) external returns(uint256);
214     */
215 
216     /* Internal Function
217         function depositAndFreeze(address token, address user) internal payable returns(uint256 amount);
218         function checkBalance(address user, address token, uint256 amount, uint256 depositAmount) internal returns(bool);
219         function checkAmount(address token, uint256 amount) internal returns(bool);
220         function checkPriceAmount(uint256 price) internal returns(bool);
221         function makeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address user, uint256 depositAmount) internal returns(uint256 amount);
222         function findAndTrade(address fromToken, address toToken, uint256 price, uint256 amount) internal returns(uint256[2] totalMatchAmount[fromToken, toToken], uint256[2] profit[fromToken, toToken]);
223         function makeTrade(address fromToken, address toToken, uint256 price, uint256 bestPrice, uint256 prevBestPrice, uint256 remainingAmount) internal returns(uint256[3] [fillTaker, fillMaker, makerFee]);
224         function makeTradeDetail(address fromToken, address toToken, uint256 price, uint256 bestPrice, address maker, uint256 remainingAmount) internal returns(uint256[3] [fillTaker, fillMaker, makerFee], bool makerFullfill);
225         function caculateFill(uint256 provide, uint256 require, uint256 price, uint256 pairProvide) internal pure returns(uint256 fillAmount);
226         function checkPricePair(uint256 price, uint256 bestPrice) internal pure returns(bool matched);
227         function fillOrder(address fromToken, address toToken, uint256 price, uint256 amount) internal returns(uint256 fee);
228         function transferToken(address user, address token, uint256 amount) internal returns(bool);
229         function updateBalance(address user, address token, uint256 amount, bool addOrSub) internal returns(bool);
230         function connectOrderPrice(address fromToken, address toToken, uint256 price, uint256 prevPrice) internal;
231         function connectOrderUser(address fromToken, address toToken, uint256 price, address user) internal;
232         function disconnectOrderPrice(address fromToken, address toToken, uint256 price, uint256 prevPrice) internal;
233         function disconnectOrderUser(address fromToken, address toToken, uint256 price, uint256 prevPrice, address user, address prevUser) internal;
234         function getNextOrderPrice(address fromToken, address toToken, uint256 price) internal view returns(uint256 price);
235         function updateNextOrderPrice(address fromToken, address toToken, uint256 price, uint256 nextPrice) internal;
236         function getNexOrdertUser(address fromToken, address toToken, uint256 price, address user) internal view returns(address nextUser);
237         function getOrderAmount(address fromToken, address toToken, uint256 price, address user) internal view returns(uint256 amount);
238         function updateNextOrderUser(address fromToken, address toToken, uint256 price, address user, address nextUser) internal;
239         function updateOrderAmount(address fromToken, address toToken, uint256 price, address user, uint256 amount, bool addOrSub) internal;
240     */
241 
242     /* Operator function */
243     function setup(
244         uint256 autoMatch_,
245         uint256 maxAmount_,
246         uint256 maxPrice_,
247         bool power_
248     )
249         onlyOperator
250         public
251     {
252         autoMatch = autoMatch_;
253         maxAmount = maxAmount_;
254         maxPrice = maxPrice_;
255         powerStatus = power_;
256     }
257     
258     function setMinAmount(
259         address token_,
260         uint256 amount_
261     )
262         onlyOperator
263         public
264     {
265         minAmount[token_] = amount_;
266     }
267     
268     function getMinAmount(
269         address token_
270     )
271         public
272         view
273     returns(uint256) {
274         return minAmount[token_] > 0
275             ? minAmount[token_]
276             : minAmount[0];
277     }
278     
279     function setFeerate(
280         uint256[3] feerate_
281     )
282         onlyOperator
283         public
284     {
285         require(feerate_[0] < 0.05 ether && feerate_[1] < 0.05 ether && feerate_[2] < 0.05 ether);
286         feerate = feerate_;
287     }
288 
289     /* External function */
290     // fallback
291     function ()
292         public
293         payable
294     {
295         deposit(0, 0);
296     }
297 
298     // deposit all allowance
299     function deposit(
300         address token_,
301         address representor_
302     )
303         public
304         payable
305         onlyActive
306     {
307         address user = getUser(representor_);
308         uint256 amount = depositAndFreeze(token_, user);
309         if(amount > 0) {
310             updateBalance(msg.sender, token_, amount, true);
311         }
312     }
313 
314     function withdraw(
315         address token_,
316         uint256 amount_,
317         address representor_
318     )
319         public
320     returns(bool) {
321         address user = getUser(representor_);
322         if(updateBalance(user, token_, amount_, false)) {
323             require(transferToken(user, token_, amount_));
324             return true;
325         }
326     }
327 /*
328     function userMakeOrder(
329         address fromToken_,
330         address toToken_,
331         uint256 price_,
332         uint256 amount_,
333         address representor_
334     )
335         public
336         payable
337     returns(bool) {
338         // depositToken => makeOrder => updateBalance
339         uint256 depositAmount = depositAndFreeze(fromToken_, representor_);
340         if(
341             checkAmount(fromToken_, amount_) &&
342             checkPriceAmount(price_)
343         ) {
344             address user = getUser(representor_);
345             uint256 costAmount = makeOrder(fromToken_, toToken_, price_, amount_, user, depositAmount);
346 
347             // log event: MakeOrder
348             eMakeOrder(fromToken_, toToken_, price_, user, amount_);
349 
350             if(costAmount < depositAmount) {
351                 updateBalance(user, fromToken_, safeSub(depositAmount, costAmount), true);
352             } else if(costAmount > depositAmount) {
353                 updateBalance(user, fromToken_, safeSub(costAmount, depositAmount), false);
354             }
355             return true;
356         }
357     }
358 */
359     function userTakeOrder(
360         address fromToken_,
361         address toToken_,
362         uint256 price_,
363         uint256 amount_,
364         address representor_
365     )
366         public
367         payable
368         onlyActive
369     returns(bool) {
370         // checkBalance => findAndTrade => userMakeOrder => updateBalance
371         address user = getUser(representor_);
372         uint256 depositAmount = depositAndFreeze(fromToken_, user);
373         if(
374             checkAmount(fromToken_, amount_) &&
375             checkPriceAmount(price_) &&
376             checkBalance(user, fromToken_, amount_, depositAmount)
377         ) {
378             // log event: MakeOrder
379             emit eMakeOrder(fromToken_, toToken_, price_, user, amount_);
380 
381             uint256[2] memory fillAmount;
382             uint256[2] memory profit;
383             (fillAmount, profit) = findAndTrade(fromToken_, toToken_, price_, amount_);
384             uint256 fee;
385             uint256 toAmount;
386             uint256 orderAmount;
387 
388             if(fillAmount[0] > 0) {
389                 // log event: makeTrade
390                 emit eFillOrder(fromToken_, toToken_, price_, user, fillAmount[0]);
391 
392                 // log price
393                 priceBooks[fromToken_][toToken_] = price_;
394 
395                 toAmount = safeDiv(safeMul(fillAmount[0], price_), 1 ether);
396                 if(amount_ > fillAmount[0]) {
397                     orderAmount = safeSub(amount_, fillAmount[0]);
398                     makeOrder(fromToken_, toToken_, price_, amount_, user, depositAmount);
399                 }
400                 if(toAmount > 0) {
401                     (toAmount, fee) = caculateFee(user, toAmount, 1);
402                     profit[1] = profit[1] + fee;
403 
404                     // save profit
405                     updateBalance(bank, fromToken_, profit[0], true);
406                     updateBalance(bank, toToken_, profit[1], true);
407 
408                     // transfer to Taker
409                     if(manualWithdraw[user]) {
410                         updateBalance(user, toToken_, toAmount, true);
411                     } else {
412                         transferToken(user, toToken_, toAmount);
413                     }
414                 }
415             } else {
416                 orderAmount = amount_;
417                 makeOrder(fromToken_, toToken_, price_, orderAmount, user, depositAmount);
418             }
419 
420             // update balance
421             if(amount_ > depositAmount) {
422                 updateBalance(user, fromToken_, safeSub(amount_, depositAmount), false);
423             } else if(amount_ < depositAmount) {
424                 updateBalance(user, fromToken_, safeSub(depositAmount, amount_), true);
425             }
426 
427             return true;
428         }
429     }
430 
431     function userCancelOrder(
432         address fromToken_,
433         address toToken_,
434         uint256 price_,
435         uint256 amount_,
436         address representor_
437     )
438         public
439     returns(bool) {
440         // updateOrderAmount => disconnectOrderUser => withdraw
441         address user = getUser(representor_);
442         uint256 amount = getOrderAmount(fromToken_, toToken_, price_, user);
443         amount = amount > amount_ ? amount_ : amount;
444         if(amount > 0) {
445             // log event: CancelOrder
446             emit eCancelOrder(fromToken_, toToken_, price_, user, amount);
447 
448             updateOrderAmount(fromToken_, toToken_, price_, user, amount, false);
449             if(getOrderAmount(fromToken_, toToken_, price_, user) == 0) {
450                 disconnectOrderUser(fromToken_, toToken_, price_, 0, user, address(0));
451             }
452             if(manualWithdraw[user]) {
453                 updateBalance(user, fromToken_, amount, true);
454             } else {
455                 transferToken(user, fromToken_, amount);
456             }
457             return true;
458         }
459     }
460 
461     /* role - 0: maker 1: taker */
462     function caculateFee(
463         address user_,
464         uint256 amount_,
465         uint8 role_
466     )
467         public
468         view
469     returns(uint256, uint256) {
470         uint256 myXPABalance = Token(XPAToken).balanceOf(user_);
471         uint256 myFeerate = manualWithdraw[user_]
472             ? feerate[role_]
473             : feerate[role_] + feerate[2];
474         myFeerate =
475             myXPABalance > 1000000 ether ? myFeerate * 0.5 ether / 1 ether :
476             myXPABalance > 100000 ether ? myFeerate * 0.6 ether / 1 ether :
477             myXPABalance > 10000 ether ? myFeerate * 0.8 ether / 1 ether :
478             myFeerate;
479         uint256 fee = safeDiv(safeMul(amount_, myFeerate), 1 ether);
480         uint256 toAmount = safeSub(amount_, fee);
481         return(toAmount, fee);
482     }
483 
484     function trade(
485         address fromToken_,
486         address toToken_
487     )
488         public
489         onlyActive
490     {
491         // Don't worry, this takes maker feerate
492         uint256 takerPrice = getNextOrderPrice(fromToken_, toToken_, 0);
493         address taker = getNextOrderUser(fromToken_, toToken_, takerPrice, 0);
494         uint256 takerAmount = getOrderAmount(fromToken_, toToken_, takerPrice, taker);
495         /*
496             fillAmount[0] = TakerFill
497             fillAmount[1] = MakerFill
498             profit[0] = fromTokenProfit
499             profit[1] = toTokenProfit
500          */
501         uint256[2] memory fillAmount;
502         uint256[2] memory profit;
503         (fillAmount, profit) = findAndTrade(fromToken_, toToken_, takerPrice, takerAmount);
504         if(fillAmount[0] > 0) {
505             profit[1] = profit[1] + fillOrder(fromToken_, toToken_, takerPrice, taker, fillAmount[0]);
506 
507             // save profit to operator
508             updateBalance(msg.sender, fromToken_, profit[0], true);
509             updateBalance(msg.sender, toToken_, profit[1], true);
510         }
511     }
512 
513     function setManualWithdraw(
514         bool manual_
515     )
516         public
517     {
518         manualWithdraw[msg.sender] = manual_;
519     }
520 
521     /* Internal Function */
522     // deposit all allowance
523     function depositAndFreeze(
524         address token_,
525         address user
526     )
527         internal
528     returns(uint256) {
529         uint256 amount;
530         if(token_ == address(0)) {
531             // log event: Deposit
532             emit eDeposit(user, address(0), msg.value);
533 
534             amount = msg.value;
535             return amount;
536         } else {
537             if(msg.value > 0) {
538                 // log event: Deposit
539                 emit eDeposit(user, address(0), msg.value);
540 
541                 updateBalance(user, address(0), msg.value, true);
542             }
543             amount = Token(token_).allowance(msg.sender, this);
544             if(
545                 amount > 0 &&
546                 Token(token_).transferFrom(msg.sender, this, amount)
547             ) {
548                 // log event: Deposit
549                 emit eDeposit(user, token_, amount);
550 
551                 return amount;
552             }
553         }
554     }
555 
556     function checkBalance(
557         address user_,
558         address token_,
559         uint256 amount_,
560         uint256 depositAmount_
561     )
562         internal
563         view
564     returns(bool) {
565         if(safeAdd(balances[user_][token_], depositAmount_) >= amount_) {
566             return true;
567         } else {
568             //emit Error(0);
569             return false;
570         }
571     }
572 
573     function checkAmount(
574         address token_,
575         uint256 amount_
576     )
577         internal
578         view
579     returns(bool) {
580         uint256 min = getMinAmount(token_);
581         if(amount_ > maxAmount || amount_ < min) {
582             //emit Error(2);
583             return false;
584         } else {
585             return true;
586         }
587     }
588 
589     function checkPriceAmount(
590         uint256 price_
591     )
592         internal
593         view
594     returns(bool) {
595         if(price_ == 0 || price_ > maxPrice) {
596             //emit Error(3);
597             return false;
598         } else {
599             return true;
600         }
601     }
602 
603     function makeOrder(
604         address fromToken_,
605         address toToken_,
606         uint256 price_,
607         uint256 amount_,
608         address user_,
609         uint256 depositAmount_
610     )
611         internal
612     returns(uint256) {
613         if(checkBalance(user_, fromToken_, amount_, depositAmount_)) {
614             updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, true);
615             connectOrderPrice(fromToken_, toToken_, price_, 0);
616             connectOrderUser(fromToken_, toToken_, price_, user_);
617             return amount_;
618         } else {
619             return 0;
620         }
621     }
622 
623     function findAndTrade(
624         address fromToken_,
625         address toToken_,
626         uint256 price_,
627         uint256 amount_
628     )
629         internal
630     returns(uint256[2], uint256[2]) {
631         /*
632             totalMatchAmount[0]: Taker total match amount
633             totalMatchAmount[1]: Maker total match amount
634             profit[0]: fromToken profit
635             profit[1]: toToken profit
636             matchAmount[0]: Taker match amount
637             matchAmount[1]: Maker match amount
638          */
639         uint256[2] memory totalMatchAmount;
640         uint256[2] memory profit;
641         uint256[3] memory matchAmount;
642         uint256 toAmount;
643         uint256 remaining = amount_;
644         uint256 matches = 0;
645         uint256 prevBestPrice = 0;
646         uint256 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
647         for(; matches < autoMatch && remaining > 0;) {
648             matchAmount = makeTrade(fromToken_, toToken_, price_, bestPrice, prevBestPrice, remaining);
649             if(matchAmount[0] > 0) {
650                 remaining = safeSub(remaining, matchAmount[0]);
651                 totalMatchAmount[0] = safeAdd(totalMatchAmount[0], matchAmount[0]);
652                 totalMatchAmount[1] = safeAdd(totalMatchAmount[1], matchAmount[1]);
653                 profit[0] = safeAdd(profit[0], matchAmount[2]);
654                 
655                 // for next loop
656                 matches++;
657                 prevBestPrice = bestPrice;
658                 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
659             } else {
660                 break;
661             }
662         }
663 
664         if(totalMatchAmount[0] > 0) {
665             // calculating spread profit
666             toAmount = safeDiv(safeMul(totalMatchAmount[0], price_), 1 ether);
667             profit[1] = safeSub(totalMatchAmount[1], toAmount);
668             if(totalMatchAmount[1] >= safeDiv(safeMul(amount_, price_), 1 ether)) {
669                 // fromProfit += amount_ - takerFill;
670                 profit[0] = profit[0] + amount_ - totalMatchAmount[0];
671                 // fullfill Taker order
672                 totalMatchAmount[0] = amount_;
673             } else {
674                 toAmount = totalMatchAmount[1];
675                 // fromProfit += takerFill - (toAmount / price_ * 1 ether)
676                 profit[0] = profit[0] + totalMatchAmount[0] - (toAmount * 1 ether /price_);
677                 // (real) takerFill = toAmount / price_ * 1 ether
678                 totalMatchAmount[0] = safeDiv(safeMul(toAmount, 1 ether), price_);
679             }
680         }
681 
682         return (totalMatchAmount, profit);
683     }
684 
685     function makeTrade(
686         address fromToken_,
687         address toToken_,
688         uint256 price_,
689         uint256 bestPrice_,
690         uint256 prevBestPrice_,
691         uint256 remaining_
692     )
693         internal
694     returns(uint256[3]) {
695         if(checkPricePair(price_, bestPrice_)) {
696             address prevMaker = address(0);
697             address maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, 0);
698             uint256 remaining = remaining_;
699 
700             /*
701                 totalFill[0]: Total Taker fillAmount
702                 totalFill[1]: Total Maker fillAmount
703                 totalFill[2]: Total Maker fee
704              */
705             uint256[3] memory totalFill;
706             for(uint256 i = 0; i < autoMatch && remaining > 0 && maker != address(0); i++) {
707                 uint256[3] memory fill;
708                 bool fullfill;
709                 (fill, fullfill) = makeTradeDetail(fromToken_, toToken_, price_, bestPrice_, maker, remaining);
710                 if(fill[0] > 0) {
711                     if(fullfill) {
712                         disconnectOrderUser(toToken_, fromToken_, bestPrice_, prevBestPrice_, maker, prevMaker);
713                     }
714                     remaining = safeSub(remaining, fill[0]);
715                     totalFill[0] = safeAdd(totalFill[0], fill[0]);
716                     totalFill[1] = safeAdd(totalFill[1], fill[1]);
717                     totalFill[2] = safeAdd(totalFill[2], fill[2]);
718                     prevMaker = maker;
719                     maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, prevMaker);
720                     if(maker == address(0)) {
721                         break;
722                     }
723                 } else {
724                     break;
725                 }
726             }
727         }
728         return totalFill;
729     }
730 
731     function makeTradeDetail(
732         address fromToken_,
733         address toToken_,
734         uint256 price_,
735         uint256 bestPrice_,
736         address maker_,
737         uint256 remaining_
738     )
739         internal
740     returns(uint256[3], bool) {
741         /*
742             fillAmount[0]: Taker fillAmount
743             fillAmount[1]: Maker fillAmount
744             fillAmount[2]: Maker fee
745          */
746         uint256[3] memory fillAmount;
747         uint256 takerProvide = remaining_;
748         uint256 takerRequire = safeDiv(safeMul(takerProvide, price_), 1 ether);
749         uint256 makerProvide = getOrderAmount(toToken_, fromToken_, bestPrice_, maker_);
750         uint256 makerRequire = safeDiv(safeMul(makerProvide, bestPrice_), 1 ether);
751         fillAmount[0] = caculateFill(takerProvide, takerRequire, price_, makerProvide);
752         fillAmount[1] = caculateFill(makerProvide, makerRequire, bestPrice_, takerProvide);
753         fillAmount[2] = fillOrder(toToken_, fromToken_, bestPrice_, maker_, fillAmount[1]);
754         return (fillAmount, (makerRequire <= takerProvide));
755     }
756 
757     function caculateFill(
758         uint256 provide_,
759         uint256 require_,
760         uint256 price_,
761         uint256 pairProvide_
762     )
763         internal
764         pure
765     returns(uint256) {
766         return require_ > pairProvide_ ? safeDiv(safeMul(pairProvide_, 1 ether), price_) : provide_;
767     }
768 
769     function checkPricePair(
770         uint256 price_,
771         uint256 bestPrice_
772     )
773         internal pure 
774     returns(bool) {
775         if(bestPrice_ < price_) {
776             return checkPricePair(bestPrice_, price_);
777         } else if(bestPrice_ < 1 ether) {
778             return true;
779         } else if(price_ > 1 ether) {
780             return false;
781         } else {
782             return price_ * bestPrice_ <= 1 ether * 1 ether;
783         }
784     }
785 
786     function fillOrder(
787         address fromToken_,
788         address toToken_,
789         uint256 price_,
790         address user_,
791         uint256 amount_
792     )
793         internal
794     returns(uint256) {
795         // log event: fillOrder
796         emit eFillOrder(fromToken_, toToken_, price_, user_, amount_);
797 
798         uint256 toAmount = safeDiv(safeMul(amount_, price_), 1 ether);
799         uint256 fee;
800         updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, false);
801         (toAmount, fee) = caculateFee(user_, toAmount, 0);
802         if(manualWithdraw[user_]) {
803             updateBalance(user_, toToken_, toAmount, true);
804         } else {
805             transferToken(user_, toToken_, toAmount);
806         }
807         return fee;
808     }
809     function transferToken(
810         address user_,
811         address token_,
812         uint256 amount_
813     )
814         internal
815     returns(bool) {
816         if(token_ == address(0)) {
817             if(address(this).balance < amount_) {
818                 //emit Error(1);
819                 return false;
820             } else {
821                 // log event: Withdraw
822                 emit eWithdraw(user_, token_, amount_);
823 
824                 user_.transfer(amount_);
825                 return true;
826             }
827         } else if(Token(token_).transfer(user_, amount_)) {
828             // log event: Withdraw
829             emit eWithdraw(user_, token_, amount_);
830 
831             return true;
832         } else {
833             //emit Error(1);
834             return false;
835         }
836     }
837 
838     function updateBalance(
839         address user_,
840         address token_,
841         uint256 amount_,
842         bool addOrSub_
843     )
844         internal
845     returns(bool) {
846         if(addOrSub_) {
847             balances[user_][token_] = safeAdd(balances[user_][token_], amount_);
848         } else {
849             if(checkBalance(user_, token_, amount_, 0)){
850                 balances[user_][token_] = safeSub(balances[user_][token_], amount_);
851                 return true;
852             } else {
853                 return false;
854             }
855         }
856     }
857 
858     function connectOrderPrice(
859         address fromToken_,
860         address toToken_,
861         uint256 price_,
862         uint256 prev_
863     )
864         internal
865     {
866         if(checkPriceAmount(price_)) {
867             uint256 prevPrice = getNextOrderPrice(fromToken_, toToken_, prev_);
868             uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, prevPrice);
869             if(prev_ != price_ && prevPrice != price_ && nextPrice != price_) {
870                 if(price_ < prevPrice) {
871                     updateNextOrderPrice(fromToken_, toToken_, prev_, price_);
872                     updateNextOrderPrice(fromToken_, toToken_, price_, prevPrice);
873                 } else if(nextPrice == 0) {
874                     updateNextOrderPrice(fromToken_, toToken_, prevPrice, price_);
875                 } else {
876                     connectOrderPrice(fromToken_, toToken_, price_, prevPrice);
877                 }
878             }
879         }
880     }
881 
882     function connectOrderUser(
883         address fromToken_,
884         address toToken_,
885         uint256 price_,
886         address user_
887     )
888         internal 
889     {
890         address firstUser = getNextOrderUser(fromToken_, toToken_, price_, 0);
891         if(user_ != address(0) && user_ != firstUser) {
892             updateNextOrderUser(fromToken_, toToken_, price_, 0, user_);
893             if(firstUser != address(0)) {
894                 updateNextOrderUser(fromToken_, toToken_, price_, user_, firstUser);
895             }
896         }
897     }
898 
899     function disconnectOrderPrice(
900         address fromToken_,
901         address toToken_,
902         uint256 price_,
903         uint256 prev_
904     )
905         internal
906     {
907         if(checkPriceAmount(price_)) {
908             uint256 prevPrice = getNextOrderPrice(fromToken_, toToken_, prev_);
909             uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, prevPrice);
910             if(price_ == prevPrice) {
911                 updateNextOrderPrice(fromToken_, toToken_, prev_, nextPrice);
912             } else if(price_ < prevPrice) {
913                 disconnectOrderPrice(fromToken_, toToken_, price_, prevPrice);
914             }
915         }
916     }
917 
918     function disconnectOrderUser(
919         address fromToken_,
920         address toToken_,
921         uint256 price_,
922         uint256 prevPrice_,
923         address user_,
924         address prev_
925     )
926         internal
927     {
928         if(user_ == address(0)) {
929             return;
930         }
931         address prevUser = getNextOrderUser(fromToken_, toToken_, price_, prev_);
932         address nextUser = getNextOrderUser(fromToken_, toToken_, price_, prevUser);
933         if(prevUser == user_) {
934             updateNextOrderUser(fromToken_, toToken_, price_, prev_, nextUser);
935             if(nextUser == address(0)) {
936                 disconnectOrderPrice(fromToken_, toToken_, price_, prevPrice_);
937             }
938         }
939     }
940 
941     function getNextOrderPrice(
942         address fromToken_,
943         address toToken_,
944         uint256 price_
945     )
946         internal
947         view
948     returns(uint256) {
949         return nextOrderPrice[fromToken_][toToken_][price_];
950     }
951 
952     function updateNextOrderPrice(
953         address fromToken_,
954         address toToken_,
955         uint256 price_,
956         uint256 nextPrice_
957     )
958         internal
959     {
960         nextOrderPrice[fromToken_][toToken_][price_] = nextPrice_;
961     }
962 
963     function getNextOrderUser(
964         address fromToken_,
965         address toToken_,
966         uint256 price_,
967         address user_
968     )
969         internal
970         view
971     returns(address) {
972         return orderBooks[fromToken_][toToken_][price_][user_].nextUser;
973     }
974 
975     function getOrderAmount(
976         address fromToken_,
977         address toToken_,
978         uint256 price_,
979         address user_
980     )
981         internal
982         view
983     returns(uint256) {
984         return orderBooks[fromToken_][toToken_][price_][user_].amount;
985     }
986 
987     function updateNextOrderUser(
988         address fromToken_,
989         address toToken_,
990         uint256 price_,
991         address user_,
992         address nextUser_
993     )
994         internal
995     {
996         orderBooks[fromToken_][toToken_][price_][user_].nextUser = nextUser_;
997     }
998 
999     function updateOrderAmount(
1000         address fromToken_,
1001         address toToken_,
1002         uint256 price_,
1003         address user_,
1004         uint256 amount_,
1005         bool addOrSub_
1006     )
1007         internal
1008     {
1009         if(addOrSub_) {
1010             orderBooks[fromToken_][toToken_][price_][user_].amount = safeAdd(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1011         } else {
1012             orderBooks[fromToken_][toToken_][price_][user_].amount = safeSub(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1013         }
1014     }
1015 }