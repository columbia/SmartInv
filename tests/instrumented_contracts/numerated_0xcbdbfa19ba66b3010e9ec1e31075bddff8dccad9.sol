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
48 library TableLib {
49     using SafeMath for uint256;
50 
51     struct TableValue {
52       bool exists;
53       uint256 value;
54     }
55 
56     struct Table {
57         mapping (address => TableValue) tableMapping;
58         address[] addressList;
59     }
60 
61     function getNum(Table storage tbl, address adrs) internal view returns (uint256 num) {
62       return tbl.tableMapping[adrs].value;
63     }
64 
65     function add(Table storage tbl, address adrs, uint256 num) internal {
66         if (!tbl.tableMapping[adrs].exists) {
67           tbl.addressList.push(adrs);
68           tbl.tableMapping[adrs].exists = true;
69         }
70         tbl.tableMapping[adrs].value = tbl.tableMapping[adrs].value.add(num);
71     }
72 
73     function getValues(Table storage tbl, uint256 page) internal view
74     returns (uint256 count, address[] addressList, uint256[] numList) {
75       count = tbl.addressList.length;
76       uint256 maxPageSize = 50;
77       uint256 index = 0;
78       uint256 pageSize = maxPageSize;
79       if ( page*maxPageSize > count ) {
80         pageSize = count - (page-1)*maxPageSize;
81       }
82       addressList = new address[](pageSize);
83       numList = new uint256[](pageSize);
84       for (uint256 i = (page - 1) * maxPageSize; i < count && index < pageSize; i++) {
85         address adrs = tbl.addressList[i];
86         addressList[index] = adrs;
87         numList[index] = tbl.tableMapping[adrs].value;
88         index++;
89       }
90     }
91 }
92 
93 
94 library HolderLib {
95     using SafeMath for uint256;
96 
97     struct HolderValue {
98       uint256 value;
99       uint256[] relatedRoundIds;
100       uint256 fromIndex;
101       string refCode;
102     }
103 
104     struct Holder {
105         mapping (address => HolderValue) holderMap;
106     }
107 
108     function getNum(Holder storage holder, address adrs) internal view returns (uint256 num) {
109         return holder.holderMap[adrs].value;
110     }
111 
112     function setRefCode(Holder storage holder, address adrs, string refCode) internal {
113         holder.holderMap[adrs].refCode = refCode;
114     }
115 
116     function getRefCode(Holder storage holder, address adrs) internal view returns (string refCode) {
117         return holder.holderMap[adrs].refCode;
118     }
119 
120     function add(Holder storage holder, address adrs, uint256 num) internal {
121         holder.holderMap[adrs].value = holder.holderMap[adrs].value.add(num);
122     }
123 
124     function sub(Holder storage holder, address adrs, uint256 num) internal {
125         holder.holderMap[adrs].value = holder.holderMap[adrs].value.sub(num);
126     }
127 
128     function setNum(Holder storage holder, address adrs, uint256 num) internal {
129         holder.holderMap[adrs].value = num;
130     }
131 
132     function addRelatedRoundId(Holder storage holder, address adrs, uint256 roundId) internal {
133         uint256[] storage ids = holder.holderMap[adrs].relatedRoundIds;
134         if (ids.length > 0 && ids[ids.length - 1] == roundId) {
135           return;
136         }
137         ids.push(roundId);
138     }
139 
140     function removeRelatedRoundId(Holder storage holder, address adrs, uint256 roundId) internal {
141         HolderValue storage value = holder.holderMap[adrs];
142         require(value.relatedRoundIds[value.fromIndex] == roundId, 'only the fromIndex element can be removed');
143         value.fromIndex++;
144     }
145 }
146 
147 library RoundLib {
148     using SafeMath for uint256;
149     using HolderLib for HolderLib.Holder;
150     using TableLib for TableLib.Table;
151 
152     event Log(string str, uint256 v1, uint256 v2, uint256 v3);
153 
154     uint256 constant private roundSizeIncreasePercent = 160;
155 
156     struct Round {
157         uint256 roundId;
158         uint256 roundNum;
159         uint256 max;
160         TableLib.Table investers;
161         uint256 raised;
162         uint256 pot;
163         address addressOfMaxInvestment;
164     }
165 
166     function getInitRound(uint256 initSize) internal pure returns (Round) {
167         TableLib.Table memory investers;
168         return Round({
169             roundId: 1,
170             roundNum: 1,
171             max: initSize,
172             investers: investers,
173             raised: 0,
174             pot: 0,
175             addressOfMaxInvestment: 0
176         });
177     }
178 
179     function getNextRound(Round storage round, uint256 initSize) internal view returns (Round) {
180         TableLib.Table memory investers;
181         bool isFinished = round.max == round.raised;
182         return Round({
183             roundId: round.roundId + 1,
184             roundNum: isFinished ? round.roundNum + 1 : 1,
185             max: isFinished ? round.max * roundSizeIncreasePercent / 100 : initSize,
186             investers: investers,
187             raised: 0,
188             pot: 0,
189             addressOfMaxInvestment: 0
190         });
191     }
192 
193     function add (Round storage round, address adrs, uint256 amount) internal
194     returns (bool isFinished, uint256 amountUsed) {
195         if (round.raised + amount >= round.max) {
196             isFinished = true;
197             amountUsed = round.max - round.raised;
198         } else {
199             isFinished = false;
200             amountUsed = amount;
201         }
202         round.investers.add(adrs, amountUsed);
203         if (round.addressOfMaxInvestment == 0 || getNum(round, adrs) > getNum(round, round.addressOfMaxInvestment)) {
204             round.addressOfMaxInvestment = adrs;
205         }
206         round.raised = round.raised.add(amountUsed);
207     }
208 
209     function getNum(Round storage round, address adrs) internal view returns (uint256) {
210         return round.investers.getNum(adrs);
211     }
212 
213     function getBalance(Round storage round, address adrs)
214     internal view returns (uint256) {
215         uint256 balance = round.investers.getNum(adrs);
216         if (balance == 0) {
217           return balance;
218         }
219         return balance * round.pot / round.raised;
220     }
221 
222     function moveToHolder(Round storage round, address adrs, HolderLib.Holder storage coinHolders) internal {
223         if (round.pot == 0) {
224           return;
225         }
226         uint256 amount = getBalance(round, adrs);
227         if (amount > 0) {
228             coinHolders.add(adrs, amount);
229             coinHolders.removeRelatedRoundId(adrs, round.roundId);
230         }
231     }
232 
233     function getInvestList(Round storage round, uint256 page) internal view
234     returns (uint256 count, address[] addressList, uint256[] numList) {
235         return round.investers.getValues(page);
236     }
237 }
238 
239 library DealerLib {
240     using SafeMath for uint256;
241 
242     struct DealerInfo {
243         address addr;
244         uint256 amount;
245         uint256 rate; // can not more than 300
246     }
247 
248     struct Dealers {
249         mapping (string => DealerInfo) dealerMap;
250         mapping (address => string) addressToCodeMap;
251     }
252 
253     function query(Dealers storage dealers, string code) internal view returns (DealerInfo storage) {
254         return dealers.dealerMap[code];
255     }
256 
257     function queryCodeByAddress(Dealers storage dealers, address adrs) internal view returns (string code) {
258         return dealers.addressToCodeMap[adrs];
259     }
260 
261     function dealerExisted(Dealers storage dealers, string code) internal view returns (bool value) {
262         return dealers.dealerMap[code].addr != 0x0;
263     }
264 
265     function insert(Dealers storage dealers, string code, address addr, uint256 rate) internal {
266         require(!dealerExisted(dealers, code), "code existed");
267         require(bytes(queryCodeByAddress(dealers, addr)).length == 0, "address existed in dealers");
268         setDealer(dealers, code, addr, rate);
269     }
270 
271     function update(Dealers storage dealers, string code, address addr, uint256 rate) internal {
272         address oldAddr = dealers.dealerMap[code].addr;
273 
274         require(oldAddr != 0x0, "code not exist");
275         require(bytes(queryCodeByAddress(dealers, addr)).length == 0, "address existed in dealers");
276 
277         delete dealers.addressToCodeMap[oldAddr];
278         setDealer(dealers, code, addr, rate);
279     }
280 
281     function setDealer(Dealers storage dealers, string code, address addr, uint256 rate) private {
282         require(addr != 0x0, "invalid address");
283         require(rate <= 300, "invalid rate");
284         dealers.addressToCodeMap[addr] = code;
285         dealers.dealerMap[code].addr = addr;
286         dealers.dealerMap[code].rate = rate;
287     }
288 
289     function addAmount(Dealers storage dealers, string code, uint256 amountUsed) internal
290     returns (uint256 amountToDealer) {
291         require(amountUsed > 0, "amount must be greater than 0");
292         require(dealerExisted(dealers, code), "code not exist");
293         amountToDealer = amountUsed * dealers.dealerMap[code].rate / 10000;
294         dealers.dealerMap[code].amount = dealers.dealerMap[code].amount.add(amountToDealer);
295     }
296 }
297 
298 
299 contract Ownable {
300   address public owner;
301 
302   event OwnershipRenounced(address indexed previousOwner);
303   event OwnershipTransferred(
304     address indexed previousOwner,
305     address indexed newOwner
306   );
307 
308   /**
309    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
310    * account.
311    */
312   constructor() public {
313     owner = msg.sender;
314   }
315 
316   /**
317    * @dev Throws if called by any account other than the owner.
318    */
319   modifier onlyOwner() {
320     require(msg.sender == owner);
321     _;
322   }
323 
324   /**
325    * @dev Allows the current owner to transfer control of the contract to a newOwner.
326    * @param _newOwner The address to transfer ownership to.
327    */
328   function transferOwnership(address _newOwner) public onlyOwner {
329     _transferOwnership(_newOwner);
330   }
331 
332   /**
333    * @dev Transfers control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function _transferOwnership(address _newOwner) internal {
337     require(_newOwner != address(0));
338     emit OwnershipTransferred(owner, _newOwner);
339     owner = _newOwner;
340   }
341 }
342 
343 contract Cox is Ownable {
344     using SafeMath for uint256;
345     using HolderLib for HolderLib.Holder;
346     using RoundLib for RoundLib.Round;
347     using DealerLib for DealerLib.Dealers;
348 
349     event RoundIn(address addr, uint256 amt, uint256 currentRoundRaised, uint256 round, uint256 bigRound, string refCode);
350     event Log(string str, uint256 value);
351     event PoolAdd(uint256 value);
352     event PoolSub(uint256 value);
353 
354     uint256 private roundDuration = 1 days;
355     uint256 private initSize = 10 ether;       // fund of first round
356     uint256 private minRecharge = 0.01 ether;  // minimum of invest amount
357     bool private mIsActive = false;
358     bool private isAutoRestart = true;
359     uint256 private rate = 300;                // 300 of ten thousand
360     string private defaultRefCode = "owner";
361 
362     DealerLib.Dealers private dealers;    // dealer information
363     HolderLib.Holder private coinHolders; // all investers information
364     RoundLib.Round[] private roundList;
365 
366     uint256 private fundPoolSize;
367     uint256 private roundStartTime;
368     uint256 private roundEndTime;
369     uint256 private bigRound = 1;
370     uint256 private totalAmountInvested = 0;
371 
372     constructor() public {
373         roundList.push(RoundLib.getInitRound(initSize));
374         dealers.insert(defaultRefCode, msg.sender, 100);
375     }
376 
377     function transferOwnership(address _newOwner) public onlyOwner {
378         Ownable.transferOwnership(_newOwner);
379         dealers.update(defaultRefCode, _newOwner, 100);
380     }
381 
382     function poolAdd(uint256 value) private {
383       fundPoolSize = fundPoolSize.add(value);
384       emit PoolAdd(value);
385     }
386 
387     function poolSub(uint256 value) private {
388       fundPoolSize = fundPoolSize.sub(value);
389       emit PoolSub(value);
390     }
391 
392     modifier isActive() {
393         require(mIsActive == true, "it's not ready yet.");
394         require(now >= roundStartTime, "it's not started yet.");
395         _;
396     }
397 
398     modifier callFromHuman(address addr) {
399         uint size;
400         assembly {size := extcodesize(addr)}
401         require(size == 0, "not human");
402         _;
403     }
404 
405     // deposit
406     function recharge(string code) public isActive callFromHuman(msg.sender) payable {
407         require(msg.value >= minRecharge, "not enough fund");
408 
409         string memory _code = coinHolders.getRefCode(msg.sender);
410         if (bytes(_code).length > 0) {
411             code = _code;
412         } else {
413             if (!dealers.dealerExisted(code)) {
414                 code = defaultRefCode;
415             }
416             coinHolders.setRefCode(msg.sender, code);
417         }
418 
419         coinHolders.add(msg.sender, msg.value);
420         roundIn(msg.value, code);
421     }
422 
423     function moveRoundsToHolder(address adrs) internal {
424       HolderLib.HolderValue storage holderValue = coinHolders.holderMap[adrs];
425       uint256[] memory roundIds = holderValue.relatedRoundIds;
426       uint256 roundId;
427 
428       for (uint256 i = holderValue.fromIndex; i < roundIds.length; i++) {
429         roundId = roundIds[i];
430         roundList[roundId - 1].moveToHolder(adrs, coinHolders);
431       }
432     }
433 
434     function withdraw() public callFromHuman(msg.sender) {
435         moveRoundsToHolder(msg.sender);
436         uint256 amount = coinHolders.getNum(msg.sender);
437         if (amount > 0) {
438             coinHolders.sub(msg.sender, amount);
439             //transfer
440             msg.sender.transfer(amount);
441         }
442     }
443 
444     function roundIn() public isActive {
445         string memory code = coinHolders.getRefCode(msg.sender);
446         require(bytes(code).length > 0, "code must not be empty");
447         require(dealers.dealerExisted(code), "dealer not exist");
448 
449         moveRoundsToHolder(msg.sender);
450         uint256 amount = coinHolders.getNum(msg.sender);
451         require(amount > 0, "your balance is 0");
452         roundIn(amount, code);
453     }
454 
455     function endRound() public isActive {
456       RoundLib.Round storage curRound = roundList[roundList.length - 1];
457       endRoundWhenTimeout(curRound);
458     }
459 
460     function endRoundWhenTimeout(RoundLib.Round storage curRound) private isActive {
461       if (now >= roundEndTime) {
462           uint256 preRoundMax = 0;
463           if (curRound.roundNum > 1) {
464               RoundLib.Round storage preRound = roundList[roundList.length - 2];
465               preRoundMax = preRound.max;
466           }
467           uint256 last2RoundsRaised = preRoundMax + curRound.raised;
468 
469           if (last2RoundsRaised > 0) {
470               if (curRound.addressOfMaxInvestment != 0) {
471                   // 20% of fund pool going to the lucky dog
472                   uint256 amountToLuckyDog = fundPoolSize * 2 / 10;
473                   coinHolders.add(curRound.addressOfMaxInvestment, amountToLuckyDog);
474                   poolSub(amountToLuckyDog);
475               }
476 
477               curRound.pot = curRound.raised * fundPoolSize / last2RoundsRaised;
478               if (curRound.roundNum > 1) {
479                   preRound.pot = preRound.raised * fundPoolSize / last2RoundsRaised;
480                   poolSub(preRound.pot);
481               }
482               poolSub(curRound.pot);
483           }
484 
485           mIsActive = isAutoRestart;
486           startNextRound(curRound);
487           bigRound++;
488       }
489     }
490 
491     function startNextRound(RoundLib.Round storage curRound) private {
492         roundList.push(curRound.getNextRound(initSize));
493         roundStartTime = now;
494         roundEndTime = now + roundDuration;
495     }
496 
497     function roundIn(uint256 amt, string code) private isActive {
498         require(coinHolders.getNum(msg.sender) >= amt, "not enough coin");
499         RoundLib.Round storage curRound = roundList[roundList.length - 1];
500 
501         if (now >= roundEndTime) {
502             endRoundWhenTimeout(curRound);
503             return;
504         }
505 
506         (bool isFinished, uint256 amountUsed) = curRound.add(msg.sender, amt);
507         totalAmountInvested = totalAmountInvested.add(amountUsed);
508 
509         require(amountUsed > 0, 'amountUsed must greater than 0');
510 
511         emit RoundIn(msg.sender, amountUsed, curRound.raised, curRound.roundNum, bigRound, code);
512 
513         coinHolders.addRelatedRoundId(msg.sender, curRound.roundId);
514 
515         coinHolders.sub(msg.sender, amountUsed);
516 
517         uint256 amountToDealer = dealers.addAmount(code, amountUsed);
518         uint256 amountToOwner = (amountUsed * rate / 10000).sub(amountToDealer);
519         coinHolders.add(owner, amountToOwner);
520         coinHolders.add(dealers.query(code).addr, amountToDealer);
521         poolAdd(amountUsed.sub(amountToDealer).sub(amountToOwner));
522 
523         if (isFinished) {
524             if (curRound.roundNum > 1) {
525                 RoundLib.Round storage preRound2 = roundList[roundList.length - 2];
526                 preRound2.pot = preRound2.max * 11 / 10;
527                 poolSub(preRound2.pot);
528             }
529 
530             startNextRound(curRound);
531         }
532     }
533 
534     function verifyCodeLength(string code) public pure returns (bool) {
535         return bytes(code).length >= 4 && bytes(code).length <= 20;
536     }
537 
538     function addDealer(string code, address addr, uint256 _rate) public onlyOwner {
539         require(verifyCodeLength(code), "code length should between 4 and 20");
540         dealers.insert(code, addr, _rate);
541     }
542 
543     function addDealerForSender(string code) public {
544         require(verifyCodeLength(code), "code length should between 4 and 20");
545         dealers.insert(code, msg.sender, 100);
546     }
547 
548     function getDealerInfo(string code) public view returns (string _code, address adrs, uint256 amount, uint256 _rate) {
549         DealerLib.DealerInfo storage dealer = dealers.query(code);
550         return (code, dealer.addr, dealer.amount, dealer.rate);
551     }
552 
553     function updateDealer(string code, address addr, uint256 _rate) public onlyOwner {
554         dealers.update(code, addr, _rate);
555     }
556 
557     function setIsAutoRestart(bool isAuto) public onlyOwner {
558         isAutoRestart = isAuto;
559     }
560 
561     function setMinRecharge(uint256 a) public onlyOwner {
562         minRecharge = a;
563     }
564 
565     function setRoundDuration(uint256 a) public onlyOwner {
566         roundDuration = a;
567     }
568 
569     function setInitSize(uint256 size) public onlyOwner {
570         initSize = size;
571         RoundLib.Round storage curRound = roundList[roundList.length - 1];
572         if (curRound.roundNum == 1 && curRound.raised < size) {
573             curRound.max = size;
574         }
575     }
576 
577     function activate() public onlyOwner {
578         // can only be ran once
579         require(mIsActive == false, "already activated");
580         // activate the contract
581         mIsActive = true;
582         roundStartTime = now;
583         roundEndTime = now + roundDuration;
584     }
585 
586     function setStartTime(uint256 startTime) public onlyOwner {
587         roundStartTime = startTime;
588         roundEndTime = roundStartTime + roundDuration;
589     }
590 
591     function deactivate() public onlyOwner {
592         require(mIsActive == true, "already deactivated");
593         mIsActive = false;
594     }
595 
596     function getGlobalInfo() public view returns
597     (bool _isActive, bool _isAutoRestart, uint256 _round, uint256 _bigRound,
598       uint256 _curRoundSize, uint256 _curRoundRaised, uint256 _fundPoolSize,
599       uint256 _roundStartTime, uint256 _roundEndTime, uint256 _totalAmountInvested) {
600         RoundLib.Round storage curRound = roundList[roundList.length - 1];
601         return (mIsActive, isAutoRestart, curRound.roundNum, bigRound,
602           curRound.max, curRound.raised, fundPoolSize,
603           roundStartTime, roundEndTime, totalAmountInvested);
604     }
605 
606     function getMyInfo() public view
607       returns (address ethAddress, uint256 balance, uint256 preRoundAmount, uint256 curRoundAmount,
608         string dealerCode, uint256 dealerAmount, uint256 dealerRate) {
609       return getAddressInfo(msg.sender);
610     }
611 
612     function getAddressInfo(address _address) public view
613     returns (address ethAddress, uint256 balance, uint256 preRoundAmount, uint256 curRoundAmount,
614       string dealerCode, uint256 dealerAmount, uint256 dealerRate) {
615         RoundLib.Round storage curRound = roundList[roundList.length - 1];
616         preRoundAmount = 0;
617         if (curRound.roundNum > 1) {
618             RoundLib.Round storage preRound = roundList[roundList.length - 2];
619             preRoundAmount = preRound.getNum(_address);
620         }
621 
622         (dealerCode, , dealerAmount, dealerRate) = getDealerInfo(dealers.queryCodeByAddress(_address));
623 
624         return (_address, coinHolders.getNum(_address) + getBalanceFromRound(_address),
625         preRoundAmount, curRound.getNum(_address), dealerCode, dealerAmount, dealerRate);
626     }
627 
628     function getBalanceFromRound(address adrs) internal view returns (uint256) {
629         HolderLib.HolderValue storage holderValue = coinHolders.holderMap[adrs];
630         uint256[] storage roundIds = holderValue.relatedRoundIds;
631         uint256 roundId;
632 
633         uint256 balance = 0;
634         for (uint256 i = holderValue.fromIndex; i < roundIds.length; i++) {
635           roundId = roundIds[i];
636           balance += roundList[roundId - 1].getBalance(adrs);
637         }
638         return balance;
639     }
640 
641     function getRoundInfo(uint256 roundId, uint256 page) public view
642     returns (uint256 _roundId, uint256 roundNum, uint256 max, uint256 raised, uint256 pot,
643       uint256 count, address[] addressList, uint256[] numList) {
644         RoundLib.Round storage round = roundList[roundId - 1];
645         _roundId = round.roundId;
646         roundNum = round.roundNum;
647         max = round.max;
648         raised = round.raised;
649         pot = round.pot;
650         (count, addressList, numList) = round.getInvestList(page);
651     }
652 }