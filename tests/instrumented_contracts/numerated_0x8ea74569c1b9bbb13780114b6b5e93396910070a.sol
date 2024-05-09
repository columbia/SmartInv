1 pragma solidity ^0.4.21;
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
93     function powerSwitch(
94         bool onOff_
95     )
96         public
97         onlyOperator
98     {
99         powerStatus = onOff_;
100     }
101 
102     function transferOwnership(address newOwner_)
103         onlyOwner
104         public
105     {
106         owner = newOwner_;
107     }
108     
109     function assignOperator(address user_)
110         public
111         onlyOwner
112     {
113         operator = user_;
114         agentBooks[bank] = user_;
115     }
116     
117     function assignBank(address bank_)
118         public
119         onlyOwner
120     {
121         bank = bank_;
122     }
123 
124     function assignAgent(
125         address agent_
126     )
127         public
128     {
129         agentBooks[msg.sender] = agent_;
130     }
131 
132     function isRepresentor(
133         address representor_
134     )
135         public
136         view
137     returns(bool) {
138         return agentBooks[representor_] == msg.sender;
139     }
140 
141     function getUser(
142         address representor_
143     )
144         internal
145         view
146     returns(address) {
147         return isRepresentor(representor_) ? representor_ : msg.sender;
148     }
149 }
150 
151 /*  Error Code
152     0: insufficient funds (user)
153     1: insufficient funds (contract)
154     2: invalid amount
155     3: invalid price
156  */
157 
158 /*
159     1. 檢驗是否指定代理用戶，若是且為合法代理人則將操作角色轉換為被代理人，否則操作角色不變
160     2. 檢驗此操作是否有存入 ETH，有則暫時紀錄存入額度 A，若掛單指定 fromToken 不是 ETH 則直接更新用戶 ETH 帳戶餘額
161     3. 檢驗此操作是否有存入 fromToken，有則暫時紀錄存入額度 A
162     4. 檢驗用戶 fromToken 帳戶餘額 + 存入額度 A 是否 >= Amount，若是送出 makeOrder 掛單事件，否則結束操作
163     5. 依照 fromToken、toToken 尋找可匹配的交易對 P
164     6. 找出 P 的最低價格單進行匹配，記錄匹配數量，送出 fillOrder 成交事件，並結算 maker 交易結果，若成交完還有掛單數量有剩且未達迴圈次數上限則重複此步驟
165     7. 統計步驟 6 總成交量、交易價差利潤、交易手續費
166     8. 若扣除總成交量後 Taker 掛單尚未撮合完，則將剩餘額度轉換為 Maker 單
167     9. 結算交易所手續費
168     10. 結算 Taker 交易結果
169  */
170 
171 contract Baliv is SafeMath, Authorization {
172     /* struct for exchange data */
173     struct linkedBook {
174         uint256 amount;
175         address nextUser;
176     }
177 
178     /* business options */
179     mapping(address => uint256) public minAmount;
180     uint256[3] public feerate = [0, 1 * (10 ** 15), 1 * (10 ** 15)];
181     uint256 public autoMatch = 10;
182     uint256 public maxAmount = 10 ** 27;
183     uint256 public maxPrice = 10 ** 36;
184     address public XPAToken = 0x0090528aeb3a2b736b780fd1b6c478bb7e1d643170;
185 
186     /* exchange data */
187     mapping(address => mapping(address => mapping(uint256 => mapping(address => linkedBook)))) public orderBooks;
188     mapping(address => mapping(address => mapping(uint256 => uint256))) public nextOrderPrice;
189     mapping(address => mapping(address => uint256)) public priceBooks;
190     
191     /* user data */
192     mapping(address => mapping(address => uint256)) public balances;
193     mapping(address => bool) internal manualWithdraw;
194 
195     /* event */
196     event eDeposit(address user,address token, uint256 amount);
197     event eWithdraw(address user,address token, uint256 amount);
198     event eMakeOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
199     event eFillOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
200     event eCancelOrder(address fromToken, address toToken, uint256 price, address user, uint256 amount);
201 
202     event Error(uint256 code);
203 
204     /* constructor */
205     function Baliv() public {
206         minAmount[0] = 10 ** 16;
207     }
208 
209     /* Operator Function
210         function setup(uint256 autoMatch, uint256 maxAmount, uint256 maxPrice) external;
211         function setMinAmount(address token, uint256 amount) external;
212         function setFeerate(uint256[3] [maker, taker, autoWithdraw]) external;
213     */
214 
215     /* External Function
216         function () public payable;
217         function deposit(address token, address representor) external payable;
218         function withdraw(address token, uint256 amount, address representor) external returns(bool);
219         function userTakeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external payable returns(bool);
220         function userCancelOrder(address fromToken, address toToken, uint256 price, uint256 amount, address representor) external returns(bool);
221         function caculateFee(address user, uint256 amount, uint8 role) external returns(uint256 remaining, uint256 fee);
222         function trade(address fromToken, address toToken) external;
223         function setManualWithdraw(bool) external;
224         function getMinAmount(address) external returns(uint256);
225         function getPrice(address fromToken, address toToken) external returns(uint256);
226     */
227 
228     /* Internal Function
229         function depositAndFreeze(address token, address user) internal payable returns(uint256 amount);
230         function checkBalance(address user, address token, uint256 amount, uint256 depositAmount) internal returns(bool);
231         function checkAmount(address token, uint256 amount) internal returns(bool);
232         function checkPriceAmount(uint256 price) internal returns(bool);
233         function makeOrder(address fromToken, address toToken, uint256 price, uint256 amount, address user, uint256 depositAmount) internal returns(uint256 amount);
234         function findAndTrade(address fromToken, address toToken, uint256 price, uint256 amount) internal returns(uint256[2] totalMatchAmount[fromToken, toToken], uint256[2] profit[fromToken, toToken]);
235         function makeTrade(address fromToken, address toToken, uint256 price, uint256 bestPrice, uint256 remainingAmount) internal returns(uint256[3] [fillTaker, fillMaker, makerFee]);
236         function makeTradeDetail(address fromToken, address toToken, uint256 price, uint256 bestPrice, address maker, uint256 remainingAmount) internal returns(uint256[3] [fillTaker, fillMaker, makerFee]);
237         function caculateFill(uint256 provide, uint256 require, uint256 price, uint256 pairProvide) internal pure returns(uint256 fillAmount);
238         function checkPricePair(uint256 price, uint256 bestPrice) internal pure returns(bool matched);
239         function fillOrder(address fromToken, address toToken, uint256 price, uint256 amount) internal returns(uint256 fee);
240         function transferToken(address user, address token, uint256 amount) internal returns(bool);
241         function updateBalance(address user, address token, uint256 amount, bool addOrSub) internal returns(bool);
242         function connectOrderPrice(address fromToken, address toToken, uint256 price, uint256 prevPrice) internal;
243         function connectOrderUser(address fromToken, address toToken, uint256 price, address user) internal;
244         function disconnectOrderPrice(address fromToken, address toToken, uint256 price) internal;
245         function disconnectOrderUser(address fromToken, address toToken, uint256 price, address user) internal;
246         function getNextOrderPrice(address fromToken, address toToken, uint256 price) internal view returns(uint256 price);
247         function updateNextOrderPrice(address fromToken, address toToken, uint256 price, uint256 nextPrice) internal;
248         function getNexOrdertUser(address fromToken, address toToken, uint256 price, address user) internal view returns(address nextUser);
249         function getOrderAmount(address fromToken, address toToken, uint256 price, address user) internal view returns(uint256 amount);
250         function updateNextOrderUser(address fromToken, address toToken, uint256 price, address user, address nextUser) internal;
251         function updateOrderAmount(address fromToken, address toToken, uint256 price, address user, uint256 amount, bool addOrSub) internal;
252         function logPrice(address fromToken, address toToken, uint256 price) internal;
253     */
254 
255     /* Operator function */
256     function setup(
257         uint256 autoMatch_,
258         uint256 maxAmount_,
259         uint256 maxPrice_
260     )
261         onlyOperator
262         public
263     {
264         autoMatch = autoMatch_;
265         maxAmount = maxAmount_;
266         maxPrice = maxPrice_;
267     }
268     
269     function setMinAmount(
270         address token_,
271         uint256 amount_
272     )
273         onlyOperator
274         public
275     {
276         minAmount[token_] = amount_;
277     }
278     
279     function getMinAmount(
280         address token_
281     )
282         public
283         view
284     returns(uint256) {
285         return minAmount[token_] > 0
286             ? minAmount[token_]
287             : minAmount[0];
288     }
289     
290     function setFeerate(
291         uint256[3] feerate_
292     )
293         onlyOperator
294         public
295     {
296         require(feerate_[0] < 0.05 ether && feerate_[1] < 0.05 ether && feerate_[2] < 0.05 ether);
297         feerate = feerate_;
298     }
299 
300     /* External function */
301     // fallback
302     function ()
303         public
304         payable
305     {
306         deposit(0, 0);
307     }
308 
309     // deposit all allowance
310     function deposit(
311         address token_,
312         address representor_
313     )
314         public
315         payable
316         onlyActive
317     {
318         address user = getUser(representor_);
319         uint256 amount = depositAndFreeze(token_, user);
320         if(amount > 0) {
321             updateBalance(msg.sender, token_, amount, true);
322         }
323     }
324 
325     function withdraw(
326         address token_,
327         uint256 amount_,
328         address representor_
329     )
330         public
331     returns(bool) {
332         address user = getUser(representor_);
333         if(updateBalance(user, token_, amount_, false)) {
334             require(transferToken(user, token_, amount_));
335             return true;
336         }
337     }
338 
339     function agentMakeOrder(
340         address fromToken_,
341         address toToken_,
342         uint256 price_,
343         uint256 amount_,
344         address representor_
345     )
346         public
347         payable
348     returns(bool) {
349         // depositToken => makeOrder => updateBalance
350         uint256 depositAmount = depositAndFreeze(fromToken_, representor_);
351         if(
352             checkAmount(fromToken_, amount_) &&
353             checkPriceAmount(price_)
354         ) {
355             require(representor_ != address(0));
356             address user = representor_;
357             uint256 costAmount = makeOrder(fromToken_, toToken_, price_, amount_, user, depositAmount);
358 
359             // log event: MakeOrder
360             emit eMakeOrder(fromToken_, toToken_, price_, user, amount_);
361 
362             require(costAmount <= depositAmount);
363             updateBalance(msg.sender, fromToken_, safeSub(depositAmount, costAmount), true);
364             return true;
365         }
366     }
367 
368     function userTakeOrder(
369         address fromToken_,
370         address toToken_,
371         uint256 price_,
372         uint256 amount_,
373         address representor_
374     )
375         public
376         payable
377         onlyActive
378     returns(bool) {
379         // checkBalance => findAndTrade => userMakeOrder => updateBalance
380         address user = getUser(representor_);
381         uint256 depositAmount = depositAndFreeze(fromToken_, user);
382         if(
383             checkAmount(fromToken_, amount_) &&
384             checkPriceAmount(price_) &&
385             checkBalance(user, fromToken_, amount_, depositAmount)
386         ) {
387             // log event: MakeOrder
388             emit eMakeOrder(fromToken_, toToken_, price_, user, amount_);
389 
390             uint256[2] memory fillAmount;
391             uint256[2] memory profit;
392             (fillAmount, profit) = findAndTrade(fromToken_, toToken_, price_, amount_);
393             uint256 fee;
394             uint256 toAmount;
395             uint256 orderAmount;
396 
397             if(fillAmount[0] > 0) {
398                 // log event: makeTrade
399                 emit eFillOrder(fromToken_, toToken_, price_, user, fillAmount[0]);
400 
401                 toAmount = safeDiv(safeMul(fillAmount[0], price_), 1 ether);
402                 if(amount_ > fillAmount[0]) {
403                     orderAmount = safeSub(amount_, fillAmount[0]);
404                     makeOrder(fromToken_, toToken_, price_, orderAmount, user, depositAmount);
405                 }
406                 if(toAmount > 0) {
407                     (toAmount, fee) = caculateFee(user, toAmount, 1);
408                     profit[1] = profit[1] + fee;
409 
410                     // save profit
411                     updateBalance(bank, fromToken_, profit[0], true);
412                     updateBalance(bank, toToken_, profit[1], true);
413 
414                     // transfer to Taker
415                     if(manualWithdraw[user]) {
416                         updateBalance(user, toToken_, toAmount, true);
417                     } else {
418                         transferToken(user, toToken_, toAmount);
419                     }
420                 }
421             } else {
422                 orderAmount = amount_;
423                 makeOrder(fromToken_, toToken_, price_, orderAmount, user, depositAmount);
424             }
425 
426             // update balance
427             if(amount_ > depositAmount) {
428                 updateBalance(user, fromToken_, safeSub(amount_, depositAmount), false);
429             } else if(amount_ < depositAmount) {
430                 updateBalance(user, fromToken_, safeSub(depositAmount, amount_), true);
431             }
432 
433             return true;
434         } else if(depositAmount > 0) {
435             updateBalance(user, fromToken_, depositAmount, true);
436         }
437     }
438 
439     function userCancelOrder(
440         address fromToken_,
441         address toToken_,
442         uint256 price_,
443         uint256 amount_,
444         address representor_
445     )
446         public
447     returns(bool) {
448         // updateOrderAmount => disconnectOrderUser => withdraw
449         address user = getUser(representor_);
450         uint256 amount = getOrderAmount(fromToken_, toToken_, price_, user);
451         amount = amount > amount_ ? amount_ : amount;
452         if(amount > 0) {
453             // log event: CancelOrder
454             emit eCancelOrder(fromToken_, toToken_, price_, user, amount);
455 
456             updateOrderAmount(fromToken_, toToken_, price_, user, amount, false);
457             if(manualWithdraw[user]) {
458                 updateBalance(user, fromToken_, amount, true);
459             } else {
460                 transferToken(user, fromToken_, amount);
461             }
462             return true;
463         }
464     }
465 
466     /* role - 0: maker 1: taker */
467     function caculateFee(
468         address user_,
469         uint256 amount_,
470         uint8 role_
471     )
472         public
473         view
474     returns(uint256, uint256) {
475         uint256 myXPABalance = Token(XPAToken).balanceOf(user_);
476         uint256 myFeerate = manualWithdraw[user_]
477             ? feerate[role_]
478             : feerate[role_] + feerate[2];
479         myFeerate =
480             myXPABalance > 1000000 ether ? myFeerate * 0.5 ether / 1 ether :
481             myXPABalance > 100000 ether ? myFeerate * 0.6 ether / 1 ether :
482             myXPABalance > 10000 ether ? myFeerate * 0.8 ether / 1 ether :
483             myFeerate;
484         uint256 fee = safeDiv(safeMul(amount_, myFeerate), 1 ether);
485         uint256 toAmount = safeSub(amount_, fee);
486         return(toAmount, fee);
487     }
488 
489     function trade(
490         address fromToken_,
491         address toToken_
492     )
493         public
494         onlyActive
495     {
496         // Don't worry, this takes maker feerate
497         uint256 takerPrice = getNextOrderPrice(fromToken_, toToken_, 0);
498         address taker = getNextOrderUser(fromToken_, toToken_, takerPrice, 0);
499         uint256 takerAmount = getOrderAmount(fromToken_, toToken_, takerPrice, taker);
500         /*
501             fillAmount[0] = TakerFill
502             fillAmount[1] = MakerFill
503             profit[0] = fromTokenProfit
504             profit[1] = toTokenProfit
505          */
506         uint256[2] memory fillAmount;
507         uint256[2] memory profit;
508         (fillAmount, profit) = findAndTrade(fromToken_, toToken_, takerPrice, takerAmount);
509         if(fillAmount[0] > 0) {
510             profit[1] = profit[1] + fillOrder(fromToken_, toToken_, takerPrice, taker, fillAmount[0]);
511 
512             // save profit to operator
513             updateBalance(msg.sender, fromToken_, profit[0], true);
514             updateBalance(msg.sender, toToken_, profit[1], true);
515         }
516     }
517 
518     function setManualWithdraw(
519         bool manual_
520     )
521         public
522     {
523         manualWithdraw[msg.sender] = manual_;
524     }
525 
526     function getPrice(
527         address fromToken_,
528         address toToken_
529     )
530         public
531         view
532     returns(uint256) {
533         if(uint256(fromToken_) >= uint256(toToken_)) {
534             return priceBooks[fromToken_][toToken_];            
535         } else {
536             return priceBooks[toToken_][fromToken_] > 0 ? safeDiv(10 ** 36, priceBooks[toToken_][fromToken_]) : 0;
537         }
538     }
539 
540     /* Internal Function */
541     // deposit all allowance
542     function depositAndFreeze(
543         address token_,
544         address user
545     )
546         internal
547     returns(uint256) {
548         uint256 amount;
549         if(token_ == address(0)) {
550             // log event: Deposit
551             emit eDeposit(user, address(0), msg.value);
552 
553             amount = msg.value;
554             return amount;
555         } else {
556             if(msg.value > 0) {
557                 // log event: Deposit
558                 emit eDeposit(user, address(0), msg.value);
559 
560                 updateBalance(user, address(0), msg.value, true);
561             }
562             amount = Token(token_).allowance(msg.sender, this);
563             if(
564                 amount > 0 &&
565                 Token(token_).transferFrom(msg.sender, this, amount)
566             ) {
567                 // log event: Deposit
568                 emit eDeposit(user, token_, amount);
569 
570                 return amount;
571             }
572         }
573     }
574 
575     function checkBalance(
576         address user_,
577         address token_,
578         uint256 amount_,
579         uint256 depositAmount_
580     )
581         internal
582     returns(bool) {
583         if(safeAdd(balances[user_][token_], depositAmount_) >= amount_) {
584             return true;
585         } else {
586             emit Error(0);
587             return false;
588         }
589     }
590 
591     function checkAmount(
592         address token_,
593         uint256 amount_
594     )
595         internal
596     returns(bool) {
597         uint256 min = getMinAmount(token_);
598         if(amount_ > maxAmount || amount_ < min) {
599             emit Error(2);
600             return false;
601         } else {
602             return true;
603         }
604     }
605 
606     function checkPriceAmount(
607         uint256 price_
608     )
609         internal
610     returns(bool) {
611         if(price_ == 0 || price_ > maxPrice) {
612             emit Error(3);
613             return false;
614         } else {
615             return true;
616         }
617     }
618 
619     function makeOrder(
620         address fromToken_,
621         address toToken_,
622         uint256 price_,
623         uint256 amount_,
624         address user_,
625         uint256 depositAmount_
626     )
627         internal
628     returns(uint256) {
629         if(checkBalance(user_, fromToken_, amount_, depositAmount_)) {
630             updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, true);
631             connectOrderPrice(fromToken_, toToken_, price_, 0);
632             connectOrderUser(fromToken_, toToken_, price_, user_);
633             return amount_;
634         } else {
635             return 0;
636         }
637     }
638 
639     function findAndTrade(
640         address fromToken_,
641         address toToken_,
642         uint256 price_,
643         uint256 amount_
644     )
645         internal
646     returns(uint256[2], uint256[2]) {
647         /*
648             totalMatchAmount[0]: Taker total match amount
649             totalMatchAmount[1]: Maker total match amount
650             profit[0]: fromToken profit
651             profit[1]: toToken profit
652             matchAmount[0]: Taker match amount
653             matchAmount[1]: Maker match amount
654          */
655         uint256[2] memory totalMatchAmount;
656         uint256[2] memory profit;
657         uint256[3] memory matchAmount;
658         uint256 toAmount;
659         uint256 remaining = amount_;
660         uint256 matches = 0;
661         uint256 prevBestPrice = 0;
662         uint256 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
663         for(; matches < autoMatch && remaining > 0;) {
664             matchAmount = makeTrade(fromToken_, toToken_, price_, bestPrice, remaining);
665             if(matchAmount[0] > 0) {
666                 remaining = safeSub(remaining, matchAmount[0]);
667                 totalMatchAmount[0] = safeAdd(totalMatchAmount[0], matchAmount[0]);
668                 totalMatchAmount[1] = safeAdd(totalMatchAmount[1], matchAmount[1]);
669                 profit[0] = safeAdd(profit[0], matchAmount[2]);
670                 
671                 // for next loop
672                 matches++;
673                 prevBestPrice = bestPrice;
674                 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
675             } else {
676                 break;
677             }
678         }
679 
680         if(totalMatchAmount[0] > 0) {
681             // log price
682             logPrice(toToken_, fromToken_, prevBestPrice);
683 
684             // calculating spread profit
685             toAmount = safeDiv(safeMul(totalMatchAmount[0], price_), 1 ether);
686             profit[1] = safeSub(totalMatchAmount[1], toAmount);
687             if(totalMatchAmount[1] >= safeDiv(safeMul(amount_, price_), 1 ether)) {
688                 // fromProfit += amount_ - takerFill;
689                 profit[0] = profit[0] + amount_ - totalMatchAmount[0];
690                 // fullfill Taker order
691                 totalMatchAmount[0] = amount_;
692             } else {
693                 toAmount = totalMatchAmount[1];
694                 // fromProfit += takerFill - (toAmount / price_ * 1 ether)
695                 profit[0] = profit[0] + totalMatchAmount[0] - (toAmount * 1 ether /price_);
696                 // (real) takerFill = toAmount / price_ * 1 ether
697                 totalMatchAmount[0] = safeDiv(safeMul(toAmount, 1 ether), price_);
698             }
699         }
700 
701         return (totalMatchAmount, profit);
702     }
703 
704     function makeTrade(
705         address fromToken_,
706         address toToken_,
707         uint256 price_,
708         uint256 bestPrice_,
709         uint256 remaining_
710     )
711         internal
712     returns(uint256[3]) {
713         if(checkPricePair(price_, bestPrice_)) {
714             address prevMaker = address(0);
715             address maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, 0);
716             uint256 remaining = remaining_;
717 
718             /*
719                 totalFill[0]: Total Taker fillAmount
720                 totalFill[1]: Total Maker fillAmount
721                 totalFill[2]: Total Maker fee
722              */
723             uint256[3] memory totalFill;
724             for(uint256 i = 0; i < autoMatch && remaining > 0 && maker != address(0); i++) {
725                 uint256[3] memory fill;
726                 fill = makeTradeDetail(fromToken_, toToken_, price_, bestPrice_, maker, remaining);
727                 if(fill[0] > 0) {
728                     remaining = safeSub(remaining, fill[0]);
729                     totalFill[0] = safeAdd(totalFill[0], fill[0]);
730                     totalFill[1] = safeAdd(totalFill[1], fill[1]);
731                     totalFill[2] = safeAdd(totalFill[2], fill[2]);
732                     prevMaker = maker;
733                     maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, prevMaker);
734                     if(maker == address(0)) {
735                         break;
736                     }
737                 } else {
738                     break;
739                 }
740             }
741         }
742         return totalFill;
743     }
744 
745     function makeTradeDetail(
746         address fromToken_,
747         address toToken_,
748         uint256 price_,
749         uint256 bestPrice_,
750         address maker_,
751         uint256 remaining_
752     )
753         internal
754     returns(uint256[3]) {
755         /*
756             fillAmount[0]: Taker fillAmount
757             fillAmount[1]: Maker fillAmount
758             fillAmount[2]: Maker fee
759          */
760         uint256[3] memory fillAmount;
761         uint256 takerProvide = remaining_;
762         uint256 takerRequire = safeDiv(safeMul(takerProvide, price_), 1 ether);
763         uint256 makerProvide = getOrderAmount(toToken_, fromToken_, bestPrice_, maker_);
764         uint256 makerRequire = safeDiv(safeMul(makerProvide, bestPrice_), 1 ether);
765         fillAmount[0] = caculateFill(takerProvide, takerRequire, price_, makerProvide);
766         fillAmount[1] = caculateFill(makerProvide, makerRequire, bestPrice_, takerProvide);
767         fillAmount[2] = fillOrder(toToken_, fromToken_, bestPrice_, maker_, fillAmount[1]);
768         return (fillAmount);
769     }
770 
771     function caculateFill(
772         uint256 provide_,
773         uint256 require_,
774         uint256 price_,
775         uint256 pairProvide_
776     )
777         internal
778         pure
779     returns(uint256) {
780         return require_ > pairProvide_ ? safeDiv(safeMul(pairProvide_, 1 ether), price_) : provide_;
781     }
782 
783     function checkPricePair(
784         uint256 price_,
785         uint256 bestPrice_
786     )
787         internal pure 
788     returns(bool) {
789         if(bestPrice_ < price_) {
790             return checkPricePair(bestPrice_, price_);
791         } else if(bestPrice_ < 1 ether) {
792             return true;
793         } else if(price_ > 1 ether) {
794             return false;
795         } else {
796             return price_ * bestPrice_ <= 1 ether * 1 ether;
797         }
798     }
799 
800     function fillOrder(
801         address fromToken_,
802         address toToken_,
803         uint256 price_,
804         address user_,
805         uint256 amount_
806     )
807         internal
808     returns(uint256) {
809         // log event: fillOrder
810         emit eFillOrder(fromToken_, toToken_, price_, user_, amount_);
811 
812         uint256 toAmount = safeDiv(safeMul(amount_, price_), 1 ether);
813         uint256 fee;
814         updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, false);
815         (toAmount, fee) = caculateFee(user_, toAmount, 0);
816 
817         if(manualWithdraw[user_]) {
818             updateBalance(user_, toToken_, toAmount, true);
819         } else {
820             transferToken(user_, toToken_, toAmount);
821         }
822         return fee;
823     }
824     function transferToken(
825         address user_,
826         address token_,
827         uint256 amount_
828     )
829         internal
830     returns(bool) {
831         if(amount_ > 0) {
832             if(token_ == address(0)) {
833                 if(address(this).balance < amount_) {
834                     emit Error(1);
835                     return false;
836                 } else {
837                     // log event: Withdraw
838                     emit eWithdraw(user_, token_, amount_);
839     
840                     user_.transfer(amount_);
841                     return true;
842                 }
843             } else if(Token(token_).transfer(user_, amount_)) {
844                 // log event: Withdraw
845                 emit eWithdraw(user_, token_, amount_);
846     
847                 return true;
848             } else {
849                 emit Error(1);
850                 return false;
851             }
852         } else {
853             return true;
854         }
855     }
856 
857     function updateBalance(
858         address user_,
859         address token_,
860         uint256 amount_,
861         bool addOrSub_
862     )
863         internal
864     returns(bool) {
865         if(addOrSub_) {
866             balances[user_][token_] = safeAdd(balances[user_][token_], amount_);
867         } else {
868             if(checkBalance(user_, token_, amount_, 0)){
869                 balances[user_][token_] = safeSub(balances[user_][token_], amount_);
870                 return true;
871             } else {
872                 return false;
873             }
874         }
875     }
876 
877     function connectOrderPrice(
878         address fromToken_,
879         address toToken_,
880         uint256 price_,
881         uint256 prev_
882     )
883         internal
884     {
885         if(checkPriceAmount(price_)) {
886             uint256 prevPrice = getNextOrderPrice(fromToken_, toToken_, prev_);
887             uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, prevPrice);
888             if(prev_ != price_ && prevPrice != price_ && nextPrice != price_) {
889                 if(price_ < prevPrice) {
890                     updateNextOrderPrice(fromToken_, toToken_, prev_, price_);
891                     updateNextOrderPrice(fromToken_, toToken_, price_, prevPrice);
892                 } else if(nextPrice == 0) {
893                     updateNextOrderPrice(fromToken_, toToken_, prevPrice, price_);
894                 } else {
895                     connectOrderPrice(fromToken_, toToken_, price_, prevPrice);
896                 }
897             }
898         }
899     }
900 
901     function connectOrderUser(
902         address fromToken_,
903         address toToken_,
904         uint256 price_,
905         address user_
906     )
907         internal 
908     {
909         address firstUser = getNextOrderUser(fromToken_, toToken_, price_, 0);
910         if(user_ != address(0) && user_ != firstUser) {
911             updateNextOrderUser(fromToken_, toToken_, price_, 0, user_);
912             if(firstUser != address(0)) {
913                 updateNextOrderUser(fromToken_, toToken_, price_, user_, firstUser);
914             }
915         }
916     }
917 
918     function disconnectOrderPrice(
919         address fromToken_,
920         address toToken_,
921         uint256 price_
922     )
923         internal
924     {
925         uint256 currPrice = getNextOrderPrice(fromToken_, toToken_, 0);
926         uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, currPrice);
927         if(price_ == currPrice) {
928             updateNextOrderPrice(fromToken_, toToken_, 0, nextPrice);
929         }
930     }
931 
932     function disconnectOrderUser(
933         address fromToken_,
934         address toToken_,
935         uint256 price_,
936         address user_
937     )
938         public
939     {
940         if(user_ == address(0) || getOrderAmount(fromToken_, toToken_, price_, user_) > 0) {
941             return;
942         }
943         address currUser = getNextOrderUser(fromToken_, toToken_, price_, address(0));
944         address nextUser = getNextOrderUser(fromToken_, toToken_, price_, currUser);
945         if(currUser == user_) {
946             updateNextOrderUser(fromToken_, toToken_, price_, address(0), nextUser);
947             if(nextUser == address(0)) {
948                 disconnectOrderPrice(fromToken_, toToken_, price_);
949             }
950         }
951     }
952 
953     function getNextOrderPrice(
954         address fromToken_,
955         address toToken_,
956         uint256 price_
957     )
958         internal
959         view
960     returns(uint256) {
961         return nextOrderPrice[fromToken_][toToken_][price_];
962     }
963 
964     function updateNextOrderPrice(
965         address fromToken_,
966         address toToken_,
967         uint256 price_,
968         uint256 nextPrice_
969     )
970         internal
971     {
972         nextOrderPrice[fromToken_][toToken_][price_] = nextPrice_;
973     }
974 
975     function getNextOrderUser(
976         address fromToken_,
977         address toToken_,
978         uint256 price_,
979         address user_
980     )
981         internal
982         view
983     returns(address) {
984         return orderBooks[fromToken_][toToken_][price_][user_].nextUser;
985     }
986 
987     function getOrderAmount(
988         address fromToken_,
989         address toToken_,
990         uint256 price_,
991         address user_
992     )
993         internal
994         view
995     returns(uint256) {
996         return orderBooks[fromToken_][toToken_][price_][user_].amount;
997     }
998 
999     function updateNextOrderUser(
1000         address fromToken_,
1001         address toToken_,
1002         uint256 price_,
1003         address user_,
1004         address nextUser_
1005     )
1006         internal
1007     {
1008         orderBooks[fromToken_][toToken_][price_][user_].nextUser = nextUser_;
1009     }
1010 
1011     function updateOrderAmount(
1012         address fromToken_,
1013         address toToken_,
1014         uint256 price_,
1015         address user_,
1016         uint256 amount_,
1017         bool addOrSub_
1018     )
1019         internal
1020     {
1021         if(addOrSub_) {
1022             orderBooks[fromToken_][toToken_][price_][user_].amount = safeAdd(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1023         } else {
1024             orderBooks[fromToken_][toToken_][price_][user_].amount = safeSub(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1025             disconnectOrderUser(fromToken_, toToken_, price_, user_);
1026         }
1027     }
1028 
1029     function logPrice(
1030         address fromToken_,
1031         address toToken_,
1032         uint256 price_
1033     )
1034         internal
1035     {
1036         if(price_ > 0) {
1037             if(uint256(fromToken_) >= uint256(toToken_)) {
1038                 priceBooks[fromToken_][toToken_] = price_;
1039             } else  {
1040                 priceBooks[toToken_][fromToken_] = safeDiv(10 ** 36, price_);
1041             }
1042         }
1043     }
1044 }