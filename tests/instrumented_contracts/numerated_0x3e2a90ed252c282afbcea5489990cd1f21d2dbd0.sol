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
236         function makeTradeDetail(address fromToken, address toToken, uint256 price, uint256 bestPrice, address maker, uint256 remainingAmount) internal returns(uint256[3] [fillTaker, fillMaker, makerFee], bool makerFullfill);
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
338 /*
339     function userMakeOrder(
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
355             address user = getUser(representor_);
356             uint256 costAmount = makeOrder(fromToken_, toToken_, price_, amount_, user, depositAmount);
357 
358             // log event: MakeOrder
359             eMakeOrder(fromToken_, toToken_, price_, user, amount_);
360 
361             if(costAmount < depositAmount) {
362                 updateBalance(user, fromToken_, safeSub(depositAmount, costAmount), true);
363             } else if(costAmount > depositAmount) {
364                 updateBalance(user, fromToken_, safeSub(costAmount, depositAmount), false);
365             }
366             return true;
367         }
368     }
369 */
370     function userTakeOrder(
371         address fromToken_,
372         address toToken_,
373         uint256 price_,
374         uint256 amount_,
375         address representor_
376     )
377         public
378         payable
379         onlyActive
380     returns(bool) {
381         // checkBalance => findAndTrade => userMakeOrder => updateBalance
382         address user = getUser(representor_);
383         uint256 depositAmount = depositAndFreeze(fromToken_, user);
384         if(
385             checkAmount(fromToken_, amount_) &&
386             checkPriceAmount(price_) &&
387             checkBalance(user, fromToken_, amount_, depositAmount)
388         ) {
389             // log event: MakeOrder
390             emit eMakeOrder(fromToken_, toToken_, price_, user, amount_);
391 
392             uint256[2] memory fillAmount;
393             uint256[2] memory profit;
394             (fillAmount, profit) = findAndTrade(fromToken_, toToken_, price_, amount_);
395             uint256 fee;
396             uint256 toAmount;
397             uint256 orderAmount;
398 
399             if(fillAmount[0] > 0) {
400                 // log event: makeTrade
401                 emit eFillOrder(fromToken_, toToken_, price_, user, fillAmount[0]);
402 
403                 toAmount = safeDiv(safeMul(fillAmount[0], price_), 1 ether);
404                 if(amount_ > fillAmount[0]) {
405                     orderAmount = safeSub(amount_, fillAmount[0]);
406                     makeOrder(fromToken_, toToken_, price_, amount_, user, depositAmount);
407                 }
408                 if(toAmount > 0) {
409                     (toAmount, fee) = caculateFee(user, toAmount, 1);
410                     profit[1] = profit[1] + fee;
411 
412                     // save profit
413                     updateBalance(bank, fromToken_, profit[0], true);
414                     updateBalance(bank, toToken_, profit[1], true);
415 
416                     // transfer to Taker
417                     if(manualWithdraw[user]) {
418                         updateBalance(user, toToken_, toAmount, true);
419                     } else {
420                         transferToken(user, toToken_, toAmount);
421                     }
422                 }
423             } else {
424                 orderAmount = amount_;
425                 makeOrder(fromToken_, toToken_, price_, orderAmount, user, depositAmount);
426             }
427 
428             // update balance
429             if(amount_ > depositAmount) {
430                 updateBalance(user, fromToken_, safeSub(amount_, depositAmount), false);
431             } else if(amount_ < depositAmount) {
432                 updateBalance(user, fromToken_, safeSub(depositAmount, amount_), true);
433             }
434 
435             return true;
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
457             if(getOrderAmount(fromToken_, toToken_, price_, user) == 0) {
458                 disconnectOrderUser(fromToken_, toToken_, price_, user);
459             }
460             if(manualWithdraw[user]) {
461                 updateBalance(user, fromToken_, amount, true);
462             } else {
463                 transferToken(user, fromToken_, amount);
464             }
465             return true;
466         }
467     }
468 
469     /* role - 0: maker 1: taker */
470     function caculateFee(
471         address user_,
472         uint256 amount_,
473         uint8 role_
474     )
475         public
476         view
477     returns(uint256, uint256) {
478         uint256 myXPABalance = Token(XPAToken).balanceOf(user_);
479         uint256 myFeerate = manualWithdraw[user_]
480             ? feerate[role_]
481             : feerate[role_] + feerate[2];
482         myFeerate =
483             myXPABalance > 1000000 ether ? myFeerate * 0.5 ether / 1 ether :
484             myXPABalance > 100000 ether ? myFeerate * 0.6 ether / 1 ether :
485             myXPABalance > 10000 ether ? myFeerate * 0.8 ether / 1 ether :
486             myFeerate;
487         uint256 fee = safeDiv(safeMul(amount_, myFeerate), 1 ether);
488         uint256 toAmount = safeSub(amount_, fee);
489         return(toAmount, fee);
490     }
491 
492     function trade(
493         address fromToken_,
494         address toToken_
495     )
496         public
497         onlyActive
498     {
499         // Don't worry, this takes maker feerate
500         uint256 takerPrice = getNextOrderPrice(fromToken_, toToken_, 0);
501         address taker = getNextOrderUser(fromToken_, toToken_, takerPrice, 0);
502         uint256 takerAmount = getOrderAmount(fromToken_, toToken_, takerPrice, taker);
503         /*
504             fillAmount[0] = TakerFill
505             fillAmount[1] = MakerFill
506             profit[0] = fromTokenProfit
507             profit[1] = toTokenProfit
508          */
509         uint256[2] memory fillAmount;
510         uint256[2] memory profit;
511         (fillAmount, profit) = findAndTrade(fromToken_, toToken_, takerPrice, takerAmount);
512         if(fillAmount[0] > 0) {
513             profit[1] = profit[1] + fillOrder(fromToken_, toToken_, takerPrice, taker, fillAmount[0]);
514 
515             // save profit to operator
516             updateBalance(msg.sender, fromToken_, profit[0], true);
517             updateBalance(msg.sender, toToken_, profit[1], true);
518         }
519     }
520 
521     function setManualWithdraw(
522         bool manual_
523     )
524         public
525     {
526         manualWithdraw[msg.sender] = manual_;
527     }
528 
529     function getPrice(
530         address fromToken_,
531         address toToken_
532     )
533         public
534         view
535     returns(uint256) {
536         if(uint256(fromToken_) >= uint256(toToken_)) {
537             return priceBooks[fromToken_][toToken_];            
538         } else {
539             return priceBooks[toToken_][fromToken_] > 0 ? safeDiv(10 ** 36, priceBooks[toToken_][fromToken_]) : 0;
540         }
541     }
542 
543     /* Internal Function */
544     // deposit all allowance
545     function depositAndFreeze(
546         address token_,
547         address user
548     )
549         internal
550     returns(uint256) {
551         uint256 amount;
552         if(token_ == address(0)) {
553             // log event: Deposit
554             emit eDeposit(user, address(0), msg.value);
555 
556             amount = msg.value;
557             return amount;
558         } else {
559             if(msg.value > 0) {
560                 // log event: Deposit
561                 emit eDeposit(user, address(0), msg.value);
562 
563                 updateBalance(user, address(0), msg.value, true);
564             }
565             amount = Token(token_).allowance(msg.sender, this);
566             if(
567                 amount > 0 &&
568                 Token(token_).transferFrom(msg.sender, this, amount)
569             ) {
570                 // log event: Deposit
571                 emit eDeposit(user, token_, amount);
572 
573                 return amount;
574             }
575         }
576     }
577 
578     function checkBalance(
579         address user_,
580         address token_,
581         uint256 amount_,
582         uint256 depositAmount_
583     )
584         internal
585     returns(bool) {
586         if(safeAdd(balances[user_][token_], depositAmount_) >= amount_) {
587             return true;
588         } else {
589             emit Error(0);
590             return false;
591         }
592     }
593 
594     function checkAmount(
595         address token_,
596         uint256 amount_
597     )
598         internal
599     returns(bool) {
600         uint256 min = getMinAmount(token_);
601         if(amount_ > maxAmount || amount_ < min) {
602             emit Error(2);
603             return false;
604         } else {
605             return true;
606         }
607     }
608 
609     function checkPriceAmount(
610         uint256 price_
611     )
612         internal
613     returns(bool) {
614         if(price_ == 0 || price_ > maxPrice) {
615             emit Error(3);
616             return false;
617         } else {
618             return true;
619         }
620     }
621 
622     function makeOrder(
623         address fromToken_,
624         address toToken_,
625         uint256 price_,
626         uint256 amount_,
627         address user_,
628         uint256 depositAmount_
629     )
630         internal
631     returns(uint256) {
632         if(checkBalance(user_, fromToken_, amount_, depositAmount_)) {
633             updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, true);
634             connectOrderPrice(fromToken_, toToken_, price_, 0);
635             connectOrderUser(fromToken_, toToken_, price_, user_);
636             return amount_;
637         } else {
638             return 0;
639         }
640     }
641 
642     function findAndTrade(
643         address fromToken_,
644         address toToken_,
645         uint256 price_,
646         uint256 amount_
647     )
648         internal
649     returns(uint256[2], uint256[2]) {
650         /*
651             totalMatchAmount[0]: Taker total match amount
652             totalMatchAmount[1]: Maker total match amount
653             profit[0]: fromToken profit
654             profit[1]: toToken profit
655             matchAmount[0]: Taker match amount
656             matchAmount[1]: Maker match amount
657          */
658         uint256[2] memory totalMatchAmount;
659         uint256[2] memory profit;
660         uint256[3] memory matchAmount;
661         uint256 toAmount;
662         uint256 remaining = amount_;
663         uint256 matches = 0;
664         uint256 prevBestPrice = 0;
665         uint256 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
666         for(; matches < autoMatch && remaining > 0;) {
667             matchAmount = makeTrade(fromToken_, toToken_, price_, bestPrice, remaining);
668             if(matchAmount[0] > 0) {
669                 remaining = safeSub(remaining, matchAmount[0]);
670                 totalMatchAmount[0] = safeAdd(totalMatchAmount[0], matchAmount[0]);
671                 totalMatchAmount[1] = safeAdd(totalMatchAmount[1], matchAmount[1]);
672                 profit[0] = safeAdd(profit[0], matchAmount[2]);
673                 
674                 // for next loop
675                 matches++;
676                 prevBestPrice = bestPrice;
677                 bestPrice = getNextOrderPrice(toToken_, fromToken_, prevBestPrice);
678             } else {
679                 break;
680             }
681         }
682 
683         if(totalMatchAmount[0] > 0) {
684             // log price
685             logPrice(toToken_, fromToken_, prevBestPrice);
686 
687             // calculating spread profit
688             toAmount = safeDiv(safeMul(totalMatchAmount[0], price_), 1 ether);
689             profit[1] = safeSub(totalMatchAmount[1], toAmount);
690             if(totalMatchAmount[1] >= safeDiv(safeMul(amount_, price_), 1 ether)) {
691                 // fromProfit += amount_ - takerFill;
692                 profit[0] = profit[0] + amount_ - totalMatchAmount[0];
693                 // fullfill Taker order
694                 totalMatchAmount[0] = amount_;
695             } else {
696                 toAmount = totalMatchAmount[1];
697                 // fromProfit += takerFill - (toAmount / price_ * 1 ether)
698                 profit[0] = profit[0] + totalMatchAmount[0] - (toAmount * 1 ether /price_);
699                 // (real) takerFill = toAmount / price_ * 1 ether
700                 totalMatchAmount[0] = safeDiv(safeMul(toAmount, 1 ether), price_);
701             }
702         }
703 
704         return (totalMatchAmount, profit);
705     }
706 
707     function makeTrade(
708         address fromToken_,
709         address toToken_,
710         uint256 price_,
711         uint256 bestPrice_,
712         uint256 remaining_
713     )
714         internal
715     returns(uint256[3]) {
716         if(checkPricePair(price_, bestPrice_)) {
717             address prevMaker = address(0);
718             address maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, 0);
719             uint256 remaining = remaining_;
720 
721             /*
722                 totalFill[0]: Total Taker fillAmount
723                 totalFill[1]: Total Maker fillAmount
724                 totalFill[2]: Total Maker fee
725              */
726             uint256[3] memory totalFill;
727             for(uint256 i = 0; i < autoMatch && remaining > 0 && maker != address(0); i++) {
728                 uint256[3] memory fill;
729                 bool fullfill;
730                 (fill, fullfill) = makeTradeDetail(fromToken_, toToken_, price_, bestPrice_, maker, remaining);
731                 if(fill[0] > 0) {
732                     if(fullfill) {
733                         disconnectOrderUser(toToken_, fromToken_, bestPrice_, maker);
734                     }
735                     remaining = safeSub(remaining, fill[0]);
736                     totalFill[0] = safeAdd(totalFill[0], fill[0]);
737                     totalFill[1] = safeAdd(totalFill[1], fill[1]);
738                     totalFill[2] = safeAdd(totalFill[2], fill[2]);
739                     prevMaker = maker;
740                     maker = getNextOrderUser(toToken_, fromToken_, bestPrice_, prevMaker);
741                     if(maker == address(0)) {
742                         break;
743                     }
744                 } else {
745                     break;
746                 }
747             }
748         }
749         return totalFill;
750     }
751 
752     function makeTradeDetail(
753         address fromToken_,
754         address toToken_,
755         uint256 price_,
756         uint256 bestPrice_,
757         address maker_,
758         uint256 remaining_
759     )
760         internal
761     returns(uint256[3], bool) {
762         /*
763             fillAmount[0]: Taker fillAmount
764             fillAmount[1]: Maker fillAmount
765             fillAmount[2]: Maker fee
766          */
767         uint256[3] memory fillAmount;
768         uint256 takerProvide = remaining_;
769         uint256 takerRequire = safeDiv(safeMul(takerProvide, price_), 1 ether);
770         uint256 makerProvide = getOrderAmount(toToken_, fromToken_, bestPrice_, maker_);
771         uint256 makerRequire = safeDiv(safeMul(makerProvide, bestPrice_), 1 ether);
772         fillAmount[0] = caculateFill(takerProvide, takerRequire, price_, makerProvide);
773         fillAmount[1] = caculateFill(makerProvide, makerRequire, bestPrice_, takerProvide);
774         fillAmount[2] = fillOrder(toToken_, fromToken_, bestPrice_, maker_, fillAmount[1]);
775         return (fillAmount, (makerRequire <= takerProvide));
776     }
777 
778     function caculateFill(
779         uint256 provide_,
780         uint256 require_,
781         uint256 price_,
782         uint256 pairProvide_
783     )
784         internal
785         pure
786     returns(uint256) {
787         return require_ > pairProvide_ ? safeDiv(safeMul(pairProvide_, 1 ether), price_) : provide_;
788     }
789 
790     function checkPricePair(
791         uint256 price_,
792         uint256 bestPrice_
793     )
794         internal pure 
795     returns(bool) {
796         if(bestPrice_ < price_) {
797             return checkPricePair(bestPrice_, price_);
798         } else if(bestPrice_ < 1 ether) {
799             return true;
800         } else if(price_ > 1 ether) {
801             return false;
802         } else {
803             return price_ * bestPrice_ <= 1 ether * 1 ether;
804         }
805     }
806 
807     function fillOrder(
808         address fromToken_,
809         address toToken_,
810         uint256 price_,
811         address user_,
812         uint256 amount_
813     )
814         internal
815     returns(uint256) {
816         // log event: fillOrder
817         emit eFillOrder(fromToken_, toToken_, price_, user_, amount_);
818 
819         uint256 toAmount = safeDiv(safeMul(amount_, price_), 1 ether);
820         uint256 fee;
821         updateOrderAmount(fromToken_, toToken_, price_, user_, amount_, false);
822         (toAmount, fee) = caculateFee(user_, toAmount, 0);
823         if(manualWithdraw[user_]) {
824             updateBalance(user_, toToken_, toAmount, true);
825         } else {
826             transferToken(user_, toToken_, toAmount);
827         }
828         return fee;
829     }
830     function transferToken(
831         address user_,
832         address token_,
833         uint256 amount_
834     )
835         internal
836     returns(bool) {
837         if(token_ == address(0)) {
838             if(address(this).balance < amount_) {
839                 emit Error(1);
840                 return false;
841             } else {
842                 // log event: Withdraw
843                 emit eWithdraw(user_, token_, amount_);
844 
845                 user_.transfer(amount_);
846                 return true;
847             }
848         } else if(Token(token_).transfer(user_, amount_)) {
849             // log event: Withdraw
850             emit eWithdraw(user_, token_, amount_);
851 
852             return true;
853         } else {
854             emit Error(1);
855             return false;
856         }
857     }
858 
859     function updateBalance(
860         address user_,
861         address token_,
862         uint256 amount_,
863         bool addOrSub_
864     )
865         internal
866     returns(bool) {
867         if(addOrSub_) {
868             balances[user_][token_] = safeAdd(balances[user_][token_], amount_);
869         } else {
870             if(checkBalance(user_, token_, amount_, 0)){
871                 balances[user_][token_] = safeSub(balances[user_][token_], amount_);
872                 return true;
873             } else {
874                 return false;
875             }
876         }
877     }
878 
879     function connectOrderPrice(
880         address fromToken_,
881         address toToken_,
882         uint256 price_,
883         uint256 prev_
884     )
885         internal
886     {
887         if(checkPriceAmount(price_)) {
888             uint256 prevPrice = getNextOrderPrice(fromToken_, toToken_, prev_);
889             uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, prevPrice);
890             if(prev_ != price_ && prevPrice != price_ && nextPrice != price_) {
891                 if(price_ < prevPrice) {
892                     updateNextOrderPrice(fromToken_, toToken_, prev_, price_);
893                     updateNextOrderPrice(fromToken_, toToken_, price_, prevPrice);
894                 } else if(nextPrice == 0) {
895                     updateNextOrderPrice(fromToken_, toToken_, prevPrice, price_);
896                 } else {
897                     connectOrderPrice(fromToken_, toToken_, price_, prevPrice);
898                 }
899             }
900         }
901     }
902 
903     function connectOrderUser(
904         address fromToken_,
905         address toToken_,
906         uint256 price_,
907         address user_
908     )
909         internal 
910     {
911         address firstUser = getNextOrderUser(fromToken_, toToken_, price_, 0);
912         if(user_ != address(0) && user_ != firstUser) {
913             updateNextOrderUser(fromToken_, toToken_, price_, 0, user_);
914             if(firstUser != address(0)) {
915                 updateNextOrderUser(fromToken_, toToken_, price_, user_, firstUser);
916             }
917         }
918     }
919 
920     function disconnectOrderPrice(
921         address fromToken_,
922         address toToken_,
923         uint256 price_
924     )
925         internal
926     {
927         uint256 currPrice = getNextOrderPrice(fromToken_, toToken_, 0);
928         uint256 nextPrice = getNextOrderPrice(fromToken_, toToken_, currPrice);
929         if(price_ == currPrice) {
930             updateNextOrderPrice(fromToken_, toToken_, 0, nextPrice);
931         }
932     }
933 
934     function disconnectOrderUser(
935         address fromToken_,
936         address toToken_,
937         uint256 price_,
938         address user_
939     )
940         internal
941     {
942         if(user_ == address(0)) {
943             return;
944         }
945         address currUser = getNextOrderUser(fromToken_, toToken_, price_, address(0));
946         address nextUser = getNextOrderUser(fromToken_, toToken_, price_, currUser);
947         if(currUser == user_) {
948             updateNextOrderUser(fromToken_, toToken_, price_, address(0), nextUser);
949             if(nextUser == address(0)) {
950                 disconnectOrderPrice(fromToken_, toToken_, price_);
951             }
952         }
953     }
954 
955     function getNextOrderPrice(
956         address fromToken_,
957         address toToken_,
958         uint256 price_
959     )
960         internal
961         view
962     returns(uint256) {
963         return nextOrderPrice[fromToken_][toToken_][price_];
964     }
965 
966     function updateNextOrderPrice(
967         address fromToken_,
968         address toToken_,
969         uint256 price_,
970         uint256 nextPrice_
971     )
972         internal
973     {
974         nextOrderPrice[fromToken_][toToken_][price_] = nextPrice_;
975     }
976 
977     function getNextOrderUser(
978         address fromToken_,
979         address toToken_,
980         uint256 price_,
981         address user_
982     )
983         internal
984         view
985     returns(address) {
986         return orderBooks[fromToken_][toToken_][price_][user_].nextUser;
987     }
988 
989     function getOrderAmount(
990         address fromToken_,
991         address toToken_,
992         uint256 price_,
993         address user_
994     )
995         internal
996         view
997     returns(uint256) {
998         return orderBooks[fromToken_][toToken_][price_][user_].amount;
999     }
1000 
1001     function updateNextOrderUser(
1002         address fromToken_,
1003         address toToken_,
1004         uint256 price_,
1005         address user_,
1006         address nextUser_
1007     )
1008         internal
1009     {
1010         orderBooks[fromToken_][toToken_][price_][user_].nextUser = nextUser_;
1011     }
1012 
1013     function updateOrderAmount(
1014         address fromToken_,
1015         address toToken_,
1016         uint256 price_,
1017         address user_,
1018         uint256 amount_,
1019         bool addOrSub_
1020     )
1021         internal
1022     {
1023         if(addOrSub_) {
1024             orderBooks[fromToken_][toToken_][price_][user_].amount = safeAdd(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1025         } else {
1026             orderBooks[fromToken_][toToken_][price_][user_].amount = safeSub(orderBooks[fromToken_][toToken_][price_][user_].amount, amount_);
1027         }
1028     }
1029 
1030     function logPrice(
1031         address fromToken_,
1032         address toToken_,
1033         uint256 price_
1034     )
1035         internal
1036     {
1037         if(price_ > 0) {
1038             if(uint256(fromToken_) >= uint256(toToken_)) {
1039                 priceBooks[fromToken_][toToken_] = price_;
1040             } else  {
1041                 priceBooks[toToken_][fromToken_] = safeDiv(10 ** 36, price_);
1042             }
1043         }
1044     }
1045 }