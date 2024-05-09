1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b)
9         internal
10         pure
11         returns (uint256 c)
12     {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b, "SafeMath mul failed");
18         return c;
19     }
20 
21     /**
22     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23     */
24     function sub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256)
28     {
29         require(b <= a, "SafeMath sub failed");
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256 c)
40     {
41         c = a + b;
42         require(c >= a, "SafeMath add failed");
43         return c;
44     }
45 }
46 
47 
48 library HolderLib {
49     using SafeMath for uint256;
50 
51     struct HolderValue {
52       uint256 value;
53       uint256[] relatedRoundIds;
54       uint256 fromIndex;
55       string refCode;
56     }
57 
58     struct Holder {
59         mapping (address => HolderValue) holderMap;
60     }
61 
62     function getNum(Holder storage holder, address adrs) internal view returns (uint256 num) {
63         return holder.holderMap[adrs].value;
64     }
65 
66     function setRefCode(Holder storage holder, address adrs, string refCode) internal {
67         holder.holderMap[adrs].refCode = refCode;
68     }
69 
70     function getRefCode(Holder storage holder, address adrs) internal view returns (string refCode) {
71         return holder.holderMap[adrs].refCode;
72     }
73 
74     function add(Holder storage holder, address adrs, uint256 num) internal {
75         holder.holderMap[adrs].value = holder.holderMap[adrs].value.add(num);
76     }
77 
78     function sub(Holder storage holder, address adrs, uint256 num) internal {
79         holder.holderMap[adrs].value = holder.holderMap[adrs].value.sub(num);
80     }
81 
82     function setNum(Holder storage holder, address adrs, uint256 num) internal {
83         holder.holderMap[adrs].value = num;
84     }
85 
86     function addRelatedRoundId(Holder storage holder, address adrs, uint256 roundId) internal {
87         uint256[] storage ids = holder.holderMap[adrs].relatedRoundIds;
88         if (ids.length > 0 && ids[ids.length - 1] == roundId) {
89           return;
90         }
91         ids.push(roundId);
92     }
93 
94     function removeRelatedRoundId(Holder storage holder, address adrs, uint256 roundId) internal {
95         HolderValue storage value = holder.holderMap[adrs];
96         require(value.relatedRoundIds[value.fromIndex] == roundId, 'only the fromIndex element can be removed');
97         value.fromIndex++;
98     }
99 }
100 
101 library TableLib {
102     using SafeMath for uint256;
103 
104     struct TableValue {
105       bool exists;
106       uint256 value;
107     }
108 
109     struct Table {
110         mapping (address => TableValue) tableMapping;
111         address[] addressList;
112     }
113 
114     function getNum(Table storage tbl, address adrs) internal view returns (uint256 num) {
115       return tbl.tableMapping[adrs].value;
116     }
117 
118     function add(Table storage tbl, address adrs, uint256 num) internal {
119         if (!tbl.tableMapping[adrs].exists) {
120           tbl.addressList.push(adrs);
121           tbl.tableMapping[adrs].exists = true;
122         }
123         tbl.tableMapping[adrs].value = tbl.tableMapping[adrs].value.add(num);
124     }
125 
126     function getValues(Table storage tbl, uint256 page) internal view
127     returns (uint256 count, address[] addressList, uint256[] numList) {
128       count = tbl.addressList.length;
129       uint256 maxPageSize = 50;
130       uint256 index = 0;
131       uint256 pageSize = maxPageSize;
132       if ( page*maxPageSize > count ) {
133         pageSize = count - (page-1)*maxPageSize;
134       }
135       addressList = new address[](pageSize);
136       numList = new uint256[](pageSize);
137       for (uint256 i = (page - 1) * maxPageSize; i < count && index < pageSize; i++) {
138         address adrs = tbl.addressList[i];
139         addressList[index] = adrs;
140         numList[index] = tbl.tableMapping[adrs].value;
141         index++;
142       }
143     }
144 }
145 
146 library RoundLib {
147     using SafeMath for uint256;
148     using HolderLib for HolderLib.Holder;
149     using TableLib for TableLib.Table;
150 
151     event Log(string str, uint256 v1, uint256 v2, uint256 v3);
152 
153     uint256 constant private roundSizeIncreasePercent = 160;
154 
155     struct Round {
156         uint256 roundId;      // 一直累加，永不重复
157         uint256 roundNum;     // 轮次，数字会重复
158         uint256 max;          // 本轮应募集数量
159         TableLib.Table investers;  // 投资者数据
160         uint256 raised;       // 本轮已募集
161         uint256 pot;          // 本轮需要分配的金额
162     }
163 
164     function getInitRound(uint256 initSize) internal pure returns (Round) {
165         TableLib.Table memory investers;
166         return Round({
167           roundId: 1,
168           roundNum: 1,
169           max: initSize,
170           investers: investers,
171           raised: 0,
172           pot: 0
173         });
174     }
175 
176     function getNextRound(Round storage round, uint256 initSize) internal view returns (Round) {
177       TableLib.Table memory investers;
178       bool isFinished = round.max == round.raised;
179       return Round({
180         roundId: round.roundId + 1,
181         roundNum: isFinished ? round.roundNum + 1 : 1,
182         max: isFinished ? round.max * roundSizeIncreasePercent / 100 : initSize,
183         investers: investers,
184         raised: 0,
185         pot: 0
186       });
187     }
188 
189     function add (Round storage round, address adrs, uint256 amount) internal
190     returns (bool isFinished, uint256 amountUsed) {
191         if (round.raised + amount >= round.max) {
192             isFinished = true;
193             amountUsed = round.max - round.raised;
194         } else {
195             isFinished = false;
196             amountUsed = amount;
197         }
198         round.investers.add(adrs, amountUsed);
199         round.raised = round.raised.add(amountUsed);
200     }
201 
202     function getNum(Round storage round, address adrs) internal view returns (uint256) {
203         return round.investers.getNum(adrs);
204     }
205 
206     function getBalance(Round storage round, address adrs)
207     internal view returns (uint256) {
208         uint256 balance = round.investers.getNum(adrs);
209         if (balance == 0) {
210           return balance;
211         }
212         return balance * round.pot / round.raised;
213     }
214 
215     function moveToHolder(Round storage round, address adrs, HolderLib.Holder storage coinHolders) internal {
216         if (round.pot == 0) {
217           return;
218         }
219         uint256 amount = getBalance(round, adrs);
220         if (amount > 0) {
221             coinHolders.add(adrs, amount);
222             coinHolders.removeRelatedRoundId(adrs, round.roundId);
223         }
224     }
225 
226     function getInvestList(Round storage round, uint256 page) internal view
227     returns (uint256 count, address[] addressList, uint256[] numList) {
228         return round.investers.getValues(page);
229     }
230 }
231 
232 library DealerLib {
233     using SafeMath for uint256;
234 
235     struct DealerInfo {
236         address addr;
237         uint256 amount;
238         uint256 rate; // 万分之，必须不大于 200，即 2%
239     }
240 
241     struct Dealers {
242         mapping (string => DealerInfo) dealerMap;
243         mapping (address => string) addressToCodeMap;
244     }
245 
246     function query(Dealers storage dealers, string code) internal view returns (DealerInfo storage) {
247         return dealers.dealerMap[code];
248     }
249 
250     function queryCodeByAddress(Dealers storage dealers, address adrs) internal view returns (string code) {
251         return dealers.addressToCodeMap[adrs];
252     }
253 
254     function dealerExisted(Dealers storage dealers, string code) internal view returns (bool value) {
255         return dealers.dealerMap[code].addr != 0x0;
256     }
257 
258     function insert(Dealers storage dealers, string code, address addr, uint256 rate) internal {
259         require(!dealerExisted(dealers, code), "code existed");
260         require(bytes(queryCodeByAddress(dealers, addr)).length == 0, "address existed in dealers");
261         setDealer(dealers, code, addr, rate);
262     }
263 
264     function update(Dealers storage dealers, string code, address addr, uint256 rate) internal {
265         address oldAddr = dealers.dealerMap[code].addr;
266 
267         require(oldAddr != 0x0, "code not exist");
268         require(bytes(queryCodeByAddress(dealers, addr)).length == 0, "address existed in dealers");
269 
270         delete dealers.addressToCodeMap[oldAddr];
271         setDealer(dealers, code, addr, rate);
272     }
273 
274     function setDealer(Dealers storage dealers, string code, address addr, uint256 rate) private {
275         require(addr != 0x0, "invalid address");
276         require(rate <= 300, "invalid rate");
277         dealers.addressToCodeMap[addr] = code;
278         dealers.dealerMap[code].addr = addr;
279         dealers.dealerMap[code].rate = rate;
280     }
281 
282     function addAmount(Dealers storage dealers, string code, uint256 amountUsed) internal
283     returns (uint256 amountToDealer) {
284         require(amountUsed > 0, "amount must be greater than 0");
285         require(dealerExisted(dealers, code), "code not exist");
286         amountToDealer = amountUsed * dealers.dealerMap[code].rate / 10000;
287         dealers.dealerMap[code].amount = dealers.dealerMap[code].amount.add(amountToDealer);
288     }
289 }
290 
291 contract Ownable {
292   address public owner;
293 
294   event OwnershipRenounced(address indexed previousOwner);
295   event OwnershipTransferred(
296     address indexed previousOwner,
297     address indexed newOwner
298   );
299 
300   /**
301    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
302    * account.
303    */
304   constructor() public {
305     owner = msg.sender;
306   }
307 
308   /**
309    * @dev Throws if called by any account other than the owner.
310    */
311   modifier onlyOwner() {
312     require(msg.sender == owner);
313     _;
314   }
315 
316   /**
317    * @dev Allows the current owner to transfer control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320   function transferOwnership(address _newOwner) public onlyOwner {
321     _transferOwnership(_newOwner);
322   }
323 
324   /**
325    * @dev Transfers control of the contract to a newOwner.
326    * @param _newOwner The address to transfer ownership to.
327    */
328   function _transferOwnership(address _newOwner) internal {
329     require(_newOwner != address(0));
330     emit OwnershipTransferred(owner, _newOwner);
331     owner = _newOwner;
332   }
333 }
334 
335 contract Cox is Ownable {
336     using SafeMath for uint256;
337     using HolderLib for HolderLib.Holder;
338     using RoundLib for RoundLib.Round;
339     using DealerLib for DealerLib.Dealers;
340 
341     event RoundIn(address addr, uint256 amt, uint256 currentRoundRaised, uint256 round, uint256 bigRound, string refCode);
342     event Log(string str, uint256 value);
343     event PoolAdd(uint256 value);
344     event PoolSub(uint256 value);
345 
346     // 可配置参数
347     uint256 private roundDuration = 1 days;
348     uint256 private initSize = 10 ether;       // 首轮募集数量
349     uint256 private minRecharge = 0.01 ether;  // 最小充值数量
350     bool private mIsActive = false;      // 游戏是否接受充值和提现
351     bool private isAutoRestart = true;   // 最后一轮结束后，是否马上重新开始第一轮
352     uint256 private rate = 300;           // 万分之，300 即 3%
353     string private defaultRefCode = "owner";
354 
355     DealerLib.Dealers private dealers;    // 渠道商信息
356     HolderLib.Holder private coinHolders; // 投资人信息
357     RoundLib.Round[] private roundList;
358 
359     uint256 private fundPoolSize;            // 奖池金额
360     uint256 private roundStartTime;
361     uint256 private roundEndTime;
362     uint256 private bigRound = 1;
363     uint256 private totalAmountInvested = 0;
364 
365     constructor() public {
366         roundList.push(RoundLib.getInitRound(initSize));
367         dealers.insert(defaultRefCode, msg.sender, 100);
368     }
369 
370     function transferOwnership(address _newOwner) public onlyOwner {
371         Ownable.transferOwnership(_newOwner);
372         dealers.update(defaultRefCode, _newOwner, 100);
373     }
374 
375     function poolAdd(uint256 value) private {
376       fundPoolSize = fundPoolSize.add(value);
377       emit PoolAdd(value);
378     }
379 
380     function poolSub(uint256 value) private {
381       fundPoolSize = fundPoolSize.sub(value);
382       emit PoolSub(value);
383     }
384 
385     modifier isActive() {
386         require(mIsActive == true, "it's not ready yet.");
387         require(now >= roundStartTime, "it's not started yet.");
388         _;
389     }
390 
391     modifier callFromHuman(address addr) {
392         uint size;
393         assembly {size := extcodesize(addr)}
394         require(size == 0, "not human");
395         _;
396     }
397 
398     // 充值
399     function recharge(string code) public isActive callFromHuman(msg.sender) payable {
400         require(msg.value >= minRecharge, "not enough fund");
401 
402         string memory _code = coinHolders.getRefCode(msg.sender);
403         if (bytes(_code).length > 0) {
404             code = _code;
405         } else {
406             if (!dealers.dealerExisted(code)) {
407                 code = defaultRefCode;
408             }
409             coinHolders.setRefCode(msg.sender, code);
410         }
411 
412         coinHolders.add(msg.sender, msg.value);
413         roundIn(msg.value, code);
414     }
415 
416     function moveRoundsToHolder(address adrs) internal {
417       HolderLib.HolderValue storage holderValue = coinHolders.holderMap[adrs];
418       uint256[] memory roundIds = holderValue.relatedRoundIds;
419       uint256 roundId;
420 
421       for (uint256 i = holderValue.fromIndex; i < roundIds.length; i++) {
422         roundId = roundIds[i];
423         roundList[roundId - 1].moveToHolder(adrs, coinHolders);
424       }
425     }
426 
427     // 提现
428     function withdraw() public callFromHuman(msg.sender) {
429         moveRoundsToHolder(msg.sender);
430         uint256 amount = coinHolders.getNum(msg.sender);
431         if (amount > 0) {
432             coinHolders.sub(msg.sender, amount);
433             //transfer
434             msg.sender.transfer(amount);
435         }
436     }
437 
438     // 余额再投资
439     function roundIn() public isActive {
440         string memory code = coinHolders.getRefCode(msg.sender);
441         require(bytes(code).length > 0, "code must not be empty");
442         require(dealers.dealerExisted(code), "dealer not exist");
443 
444         moveRoundsToHolder(msg.sender);
445         uint256 amount = coinHolders.getNum(msg.sender);
446         require(amount > 0, "your balance is 0");
447         roundIn(amount, code);
448     }
449 
450     // 结束本局
451     function endRound() public isActive {
452       RoundLib.Round storage curRound = roundList[roundList.length - 1];
453       endRoundWhenTimeout(curRound);
454     }
455 
456     function endRoundWhenTimeout(RoundLib.Round storage curRound) private isActive {
457       if (now >= roundEndTime) {
458           uint256 preRoundMax = 0;
459           if (curRound.roundNum > 1) {
460               RoundLib.Round storage preRound = roundList[roundList.length - 2];
461               preRoundMax = preRound.max;
462           }
463           uint256 last2RoundsRaised = preRoundMax + curRound.raised;
464 
465           if (last2RoundsRaised > 0) {
466               curRound.pot = curRound.raised * fundPoolSize / last2RoundsRaised;
467               if (curRound.roundNum > 1) {
468                   preRound.pot = preRound.raised * fundPoolSize / last2RoundsRaised;
469                   poolSub(preRound.pot);
470               }
471               poolSub(curRound.pot);
472           }
473 
474           mIsActive = isAutoRestart;
475           startNextRound(curRound);
476           bigRound++;
477       }
478     }
479 
480     function startNextRound(RoundLib.Round storage curRound) private {
481         roundList.push(curRound.getNextRound(initSize));
482         roundStartTime = now;
483         roundEndTime = now + roundDuration;
484     }
485 
486     function roundIn(uint256 amt, string code) private isActive {
487         require(coinHolders.getNum(msg.sender) >= amt, "not enough coin");
488         RoundLib.Round storage curRound = roundList[roundList.length - 1];
489 
490         if (now >= roundEndTime) {
491             endRoundWhenTimeout(curRound);
492             return;
493         }
494 
495         (bool isFinished, uint256 amountUsed) = curRound.add(msg.sender, amt);
496         totalAmountInvested = totalAmountInvested.add(amountUsed);
497 
498         require(amountUsed > 0, 'amountUsed must greater than 0');
499 
500         emit RoundIn(msg.sender, amountUsed, curRound.raised, curRound.roundNum, bigRound, code);
501 
502         // 添加关联 roundId
503         coinHolders.addRelatedRoundId(msg.sender, curRound.roundId);
504 
505         coinHolders.sub(msg.sender, amountUsed);
506 
507         // 分配维护资金和代理商
508         uint256 amountToDealer = dealers.addAmount(code, amountUsed);
509         uint256 amountToOwner = (amountUsed * rate / 10000).sub(amountToDealer);
510         coinHolders.add(owner, amountToOwner);
511         coinHolders.add(dealers.query(code).addr, amountToDealer);
512         poolAdd(amountUsed.sub(amountToDealer).sub(amountToOwner));
513 
514         if (isFinished) {
515             if (curRound.roundNum > 1) {
516                 RoundLib.Round storage preRound2 = roundList[roundList.length - 2];
517                 preRound2.pot = preRound2.max * 11 / 10;
518                 poolSub(preRound2.pot);
519             }
520 
521             startNextRound(curRound);
522         }
523     }
524 
525     function verifyCodeLength(string code) public pure returns (bool) {
526         return bytes(code).length >= 4 && bytes(code).length <= 20;
527     }
528 
529     function addDealer(string code, address addr, uint256 _rate) public onlyOwner {
530         require(verifyCodeLength(code), "code length should between 4 and 20");
531         dealers.insert(code, addr, _rate);
532     }
533 
534     function addDealerForSender(string code) public {
535         require(verifyCodeLength(code), "code length should between 4 and 20");
536         dealers.insert(code, msg.sender, 100);
537     }
538 
539     function getDealerInfo(string code) public view returns (string _code, address adrs, uint256 amount, uint256 _rate) {
540         DealerLib.DealerInfo storage dealer = dealers.query(code);
541         return (code, dealer.addr, dealer.amount, dealer.rate);
542     }
543 
544     function updateDealer(string code, address addr, uint256 _rate) public onlyOwner {
545         dealers.update(code, addr, _rate);
546     }
547 
548     function setIsAutoRestart(bool isAuto) public onlyOwner {
549         isAutoRestart = isAuto;
550     }
551 
552     function setMinRecharge(uint256 a) public onlyOwner {
553         minRecharge = a;
554     }
555 
556     function setRoundDuration(uint256 a) public onlyOwner {
557         roundDuration = a;
558     }
559 
560     function setInitSize(uint256 size) public onlyOwner {
561         initSize = size;
562         RoundLib.Round storage curRound = roundList[roundList.length - 1];
563         if (curRound.roundNum == 1 && curRound.raised < size) {
564             curRound.max = size;
565         }
566     }
567 
568     function activate() public onlyOwner {
569         // can only be ran once
570         require(mIsActive == false, "already activated");
571         // activate the contract
572         mIsActive = true;
573         roundStartTime = now;
574         roundEndTime = now + roundDuration;
575     }
576 
577     function setStartTime(uint256 startTime) public onlyOwner {
578         roundStartTime = startTime;
579         roundEndTime = roundStartTime + roundDuration;
580     }
581 
582     function deactivate() public onlyOwner {
583         require(mIsActive == true, "already deactivated");
584         mIsActive = false;
585     }
586 
587     function getGlobalInfo() public view returns
588     (bool _isActive, bool _isAutoRestart, uint256 _round, uint256 _bigRound,
589       uint256 _curRoundSize, uint256 _curRoundRaised, uint256 _fundPoolSize,
590       uint256 _roundStartTime, uint256 _roundEndTime, uint256 _totalAmountInvested) {
591         RoundLib.Round storage curRound = roundList[roundList.length - 1];
592         return (mIsActive, isAutoRestart, curRound.roundNum, bigRound,
593           curRound.max, curRound.raised, fundPoolSize,
594           roundStartTime, roundEndTime, totalAmountInvested);
595     }
596 
597     function getMyInfo() public view
598       returns (address ethAddress, uint256 balance, uint256 preRoundAmount, uint256 curRoundAmount,
599         string dealerCode, uint256 dealerAmount, uint256 dealerRate) {
600       return getAddressInfo(msg.sender);
601     }
602 
603     function getAddressInfo(address _address) public view
604     returns (address ethAddress, uint256 balance, uint256 preRoundAmount, uint256 curRoundAmount,
605       string dealerCode, uint256 dealerAmount, uint256 dealerRate) {
606         RoundLib.Round storage curRound = roundList[roundList.length - 1];
607         preRoundAmount = 0;
608         if (curRound.roundNum > 1) {
609             RoundLib.Round storage preRound = roundList[roundList.length - 2];
610             preRoundAmount = preRound.getNum(_address);
611         }
612 
613         (dealerCode, , dealerAmount, dealerRate) = getDealerInfo(dealers.queryCodeByAddress(_address));
614 
615         return (_address, coinHolders.getNum(_address) + getBalanceFromRound(_address),
616         preRoundAmount, curRound.getNum(_address), dealerCode, dealerAmount, dealerRate);
617     }
618 
619     function getBalanceFromRound(address adrs) internal view returns (uint256) {
620         HolderLib.HolderValue storage holderValue = coinHolders.holderMap[adrs];
621         uint256[] storage roundIds = holderValue.relatedRoundIds;
622         uint256 roundId;
623 
624         uint256 balance = 0;
625         for (uint256 i = holderValue.fromIndex; i < roundIds.length; i++) {
626           roundId = roundIds[i];
627           balance += roundList[roundId - 1].getBalance(adrs);
628         }
629         return balance;
630     }
631 
632     function getRoundInfo(uint256 roundId, uint256 page) public view
633     returns (uint256 _roundId, uint256 roundNum, uint256 max, uint256 raised, uint256 pot,
634       uint256 count, address[] addressList, uint256[] numList) {
635         RoundLib.Round storage round = roundList[roundId - 1];
636         _roundId = round.roundId;
637         roundNum = round.roundNum;
638         max = round.max;
639         raised = round.raised;
640         pot = round.pot;
641         (count, addressList, numList) = round.getInvestList(page);
642     }
643 }