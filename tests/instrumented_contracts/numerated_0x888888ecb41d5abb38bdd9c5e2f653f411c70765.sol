1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier - Full Stack Blockchain Developer
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 /*
10     CHANGELOGS:
11     . GrandPot : 2 rewards per round
12         5% pot with winner rate 100%, 
13             no dividends, no fund to F2M contract
14 
15         15% pot with winner rate dynamic, init at 1st round with rate = ((initGrandPot * 2 * 100 / 68) * avgMul / SLP) + 1000;
16             push 12% to F2M contract (10% dividends, 2% fund) => everybody happy! // --REMOVED
17             if total tickets > rate then 100% got winner
18             no winner : increased in the next round
19             got winner : decreased in the next round
20 
21     . Bounty : received 30% bought tickets of bountyhunter back in the next round instead of ETH
22         (bonus tickets not included)
23     . SBountys : received 10% bought tickets of sbountyhunter back in the next round instead of ETH
24         (bonus tickets not included)
25         claimable only in pending time between 2 rounds
26 
27     . 1% bought tickets as bonus to next round (1st buy turn)
28         (bonus Tickets not included)
29 
30     . Jackpot: rates increased from (1/Rate1, 1/Rate2) to (1/(Rate1 - 1), 1/(Rate2 - 1)) after each buy
31         and reseted if jackpot triggered.
32         jackpot rate = (ethAmount / 0.1) * rate, max winrate = 1/2
33         no dividends, no fund to F2M contract
34 
35     . Ticketsnumbers start from 1 in every rounds
36 
37     . Multiplier system: 
38         . all tickets got same weight = 1
39         . 2 decimals in stead of 0
40         . Multi = (grandPot / initGrandPot) * x * y * z
41             x = (11 - timer1) / 4  + 1 (unit = hour(s), max = 15/4)
42                 timer1 updated real time, but x got delay 60 seconds from last buy
43 
44             y = (6 - timer2) / 3 + 1 (unit = day(s), max = 3)
45 
46             z = 4 if isGoldenMin, else 1
47             GOLDEN MINUTE : realTime, set = 8 atm
48             that means from x: 08 : 00 to x:08:59 is goldenMin and z = 4
49 
50     . Waiting time between 2 rounds 24 hours -> 18 hours
51 
52     . addPot :
53         80% -> grandPot
54         10% -> majorPot
55         10% -> minorPot
56 
57     BUGS FIXED:
58     . Jackpot rate increased with multi = ethAmount / 0.1 (ether)
59         no more split buy required
60     . GrandPot getWeightRange() problems
61 
62     AUTHORS:
63     . Seizo : 
64         Tickets bonus per 100 tickets,
65         setLastRound anytime
66         remove pushDividend when grandPot, jackpot triggered, called only on tickets buying
67         remove round0
68 
69     . Clark : Multiplier system
70         0xd9cd43AD9cD04183b5083E9E6c8DD0CE0c08eDe3
71 
72     . GMEB : Tickets bounty system, Math. formulas
73         0xA4a799086aE18D7db6C4b57f496B081b44888888
74 
75     . Kuroo Hazama : Dynamic rate
76         0x1E55fa952FCBc1f917746277C9C99cf65D53EbC8
77 */
78 
79 library Helper {
80     using SafeMath for uint256;
81 
82     uint256 constant public ZOOM = 1000;
83     uint256 constant public SDIVIDER = 3450000;
84     uint256 constant public PDIVIDER = 3450000;
85     uint256 constant public RDIVIDER = 1580000;
86     // Starting LS price (SLP)
87     uint256 constant public SLP = 0.002 ether;
88     // Starting Added Time (SAT)
89     uint256 constant public SAT = 30; // seconds
90     // Price normalization (PN)
91     uint256 constant public PN = 777;
92     // EarlyIncome base
93     uint256 constant public PBASE = 13;
94     uint256 constant public PMULTI = 26;
95     uint256 constant public LBase = 1;
96 
97     uint256 constant public ONE_HOUR = 3600;
98     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
99     //uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
100     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
101     uint256 constant public TIMEOUT2 = 7 * ONE_DAY;
102     
103     function bytes32ToString (bytes32 data)
104         public
105         pure
106         returns (string) 
107     {
108         bytes memory bytesString = new bytes(32);
109         for (uint j=0; j<32; j++) {
110             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
111             if (char != 0) {
112                 bytesString[j] = char;
113             }
114         }
115         return string(bytesString);
116     }
117     
118     function uintToBytes32(uint256 n)
119         public
120         pure
121         returns (bytes32) 
122     {
123         return bytes32(n);
124     }
125     
126     function bytes32ToUint(bytes32 n) 
127         public
128         pure
129         returns (uint256) 
130     {
131         return uint256(n);
132     }
133     
134     function stringToBytes32(string memory source) 
135         public
136         pure
137         returns (bytes32 result) 
138     {
139         bytes memory tempEmptyStringTest = bytes(source);
140         if (tempEmptyStringTest.length == 0) {
141             return 0x0;
142         }
143 
144         assembly {
145             result := mload(add(source, 32))
146         }
147     }
148     
149     function stringToUint(string memory source) 
150         public
151         pure
152         returns (uint256)
153     {
154         return bytes32ToUint(stringToBytes32(source));
155     }
156     
157     function uintToString(uint256 _uint) 
158         public
159         pure
160         returns (string)
161     {
162         return bytes32ToString(uintToBytes32(_uint));
163     }
164 
165 /*     
166     function getSlice(uint256 begin, uint256 end, string text) public pure returns (string) {
167         bytes memory a = new bytes(end-begin+1);
168         for(uint i = 0; i <= end - begin; i++){
169             a[i] = bytes(text)[i + begin - 1];
170         }
171         return string(a);    
172     }
173  */
174     function validUsername(string _username)
175         public
176         pure
177         returns(bool)
178     {
179         uint256 len = bytes(_username).length;
180         // Im Raum [4, 18]
181         if ((len < 4) || (len > 18)) return false;
182         // Letzte Char != ' '
183         if (bytes(_username)[len-1] == 32) return false;
184         // Erste Char != '0'
185         return uint256(bytes(_username)[0]) != 48;
186     }
187 
188     // Lottery Helper
189 
190     // Seconds added per LT = SAT - ((Current no. of LT + 1) / SDIVIDER)^6
191     function getAddedTime(uint256 _rTicketSum, uint256 _tAmount)
192         public
193         pure
194         returns (uint256)
195     {
196         //Luppe = 10000 = 10^4
197         uint256 base = (_rTicketSum + 1).mul(10000) / SDIVIDER;
198         uint256 expo = base;
199         expo = expo.mul(expo).mul(expo); // ^3
200         expo = expo.mul(expo); // ^6
201         // div 10000^6
202         expo = expo / (10**24);
203 
204         if (expo > SAT) return 0;
205         return (SAT - expo).mul(_tAmount);
206     }
207 
208     function getNewEndTime(uint256 toAddTime, uint256 slideEndTime, uint256 fixedEndTime)
209         public
210         view
211         returns(uint256)
212     {
213         uint256 _slideEndTime = (slideEndTime).add(toAddTime);
214         uint256 timeout = _slideEndTime.sub(block.timestamp);
215         // timeout capped at TIMEOUT1
216         if (timeout > TIMEOUT1) timeout = TIMEOUT1;
217         _slideEndTime = (block.timestamp).add(timeout);
218         // Capped at fixedEndTime
219         if (_slideEndTime > fixedEndTime)  return fixedEndTime;
220         return _slideEndTime;
221     }
222 
223     // get random in range [1, _range] with _seed
224     function getRandom(uint256 _seed, uint256 _range)
225         public
226         pure
227         returns(uint256)
228     {
229         if (_range == 0) return _seed;
230         return (_seed % _range) + 1;
231     }
232 
233 
234     function getEarlyIncomeMul(uint256 _ticketSum)
235         public
236         pure
237         returns(uint256)
238     {
239         // Early-Multiplier = 1 + PBASE / (1 + PMULTI * ((Current No. of LT)/RDIVIDER)^6)
240         uint256 base = _ticketSum * ZOOM / RDIVIDER;
241         uint256 expo = base.mul(base).mul(base); //^3
242         expo = expo.mul(expo) / (ZOOM**6); //^6
243         return (1 + PBASE / (1 + expo.mul(PMULTI)));
244     }
245 
246     // get reveiced Tickets, based on current round ticketSum
247     function getTAmount(uint256 _ethAmount, uint256 _ticketSum) 
248         public
249         pure
250         returns(uint256)
251     {
252         uint256 _tPrice = getTPrice(_ticketSum);
253         return _ethAmount.div(_tPrice);
254     }
255 
256     function isGoldenMin(
257         uint256 _slideEndTime
258         )
259         public
260         view
261         returns(bool)
262     {
263         uint256 _restTime1 = _slideEndTime.sub(block.timestamp);
264         // golden min. exist if timer1 < 6 hours
265         if (_restTime1 > 6 hours) return false;
266         uint256 _min = (block.timestamp / 60) % 60;
267         return _min == 8;
268     }
269 
270     // percent ZOOM = 100, ie. mul = 2.05 return 205
271     // Lotto-Multiplier = ((grandPot / initGrandPot)^2) * x * y * z
272     // x = (TIMEOUT1 - timer1 - 1) / 4 + 1 => (unit = hour, max = 11/4 + 1 = 3.75) 
273     // y = (TIMEOUT2 - timer2 - 1) / 3 + 1) => (unit = day max = 3)
274     // z = isGoldenMin ? 4 : 1
275     function getTMul(
276         uint256 _initGrandPot,
277         uint256 _grandPot, 
278         uint256 _slideEndTime, 
279         uint256 _fixedEndTime
280         )
281         public
282         view
283         returns(uint256)
284     {
285         uint256 _pZoom = 100;
286         uint256 base = _initGrandPot != 0 ?_pZoom.mul(_grandPot) / _initGrandPot : _pZoom;
287         uint256 expo = base.mul(base);
288         uint256 _timer1 = _slideEndTime.sub(block.timestamp) / 1 hours; // 0.. 11
289         uint256 _timer2 = _fixedEndTime.sub(block.timestamp) / 1 days; // 0 .. 6
290         uint256 x = (_pZoom * (11 - _timer1) / 4) + _pZoom; // [1, 3.75]
291         uint256 y = (_pZoom * (6 - _timer2) / 3) + _pZoom; // [1, 3]
292         uint256 z = isGoldenMin(_slideEndTime) ? 4 : 1;
293         uint256 res = expo.mul(x).mul(y).mul(z) / (_pZoom ** 3); // ~ [1, 90]
294         return res;
295     }
296 
297     // get ticket price, based on current round ticketSum
298     //unit in ETH, no need / zoom^6
299     function getTPrice(uint256 _ticketSum)
300         public
301         pure
302         returns(uint256)
303     {
304         uint256 base = (_ticketSum + 1).mul(ZOOM) / PDIVIDER;
305         uint256 expo = base;
306         expo = expo.mul(expo).mul(expo); // ^3
307         expo = expo.mul(expo); // ^6
308         uint256 tPrice = SLP + expo / PN;
309         return tPrice;
310     }
311 
312     // used to draw grandpot results
313     // weightRange = roundWeight * grandpot / (grandpot - initGrandPot)
314     // grandPot = initGrandPot + round investedSum(for grandPot)
315     function getWeightRange(uint256 initGrandPot)
316         public
317         pure
318         returns(uint256)
319     {
320         uint256 avgMul = 30;
321         return ((initGrandPot * 2 * 100 / 68) * avgMul / SLP) + 1000;
322     }
323 
324     // dynamic rate _RATE = n
325     // major rate = 1/n with _RATE = 1000 999 ... 1
326     // minor rate = 1/n with _RATE = 500 499 ... 1
327     // loop = _ethAmount / _MIN
328     // lose rate = ((n- 1) / n) * ((n- 2) / (n - 1)) * ... * ((n- k) / (n - k + 1)) = (n - k) / n
329     function isJackpot(
330         uint256 _seed,
331         uint256 _RATE,
332         uint256 _MIN,
333         uint256 _ethAmount
334         )
335         public
336         pure
337         returns(bool)
338     {
339         // _RATE >= 2
340         uint256 k = _ethAmount / _MIN;
341         if (k == 0) return false;
342         // LOSE RATE MIN 50%, WIN RATE MAX 50%
343         uint256 _loseCap = _RATE / 2;
344         // IF _RATE - k > _loseCap
345         if (_RATE > k + _loseCap) _loseCap = _RATE - k;
346 
347         bool _lose = (_seed % _RATE) < _loseCap;
348         return !_lose;
349     }
350 }
351 
352 contract Lottery {
353     using SafeMath for uint256;
354 
355     modifier withdrawRight(){
356         require(msg.sender == address(bankContract), "Bank only");
357         _;
358     }
359 
360     modifier onlyDevTeam() {
361         require(msg.sender == devTeam, "only for development team");
362         _;
363     }
364 
365     modifier buyable() {
366         require(block.timestamp > round[curRoundId].startTime, "not ready to sell Ticket");
367         require(block.timestamp < round[curRoundId].slideEndTime, "round over");
368         require(block.number <= round[curRoundId].keyBlockNr, "round over");
369         _;
370     }
371 
372     modifier notStarted() {
373         require(block.timestamp < round[curRoundId].startTime, "round started");
374         _;
375     }
376 
377     enum RewardType {
378         Minor,
379         Major,
380         Grand,
381         Bounty
382     }
383 
384     // 1 buy = 1 slot = _ethAmount => (tAmount, tMul) 
385     struct Slot {
386         address buyer;
387         uint256 rId;
388         // ticket numbers in range and unique in all rounds
389         uint256 tNumberFrom;
390         uint256 tNumberTo;
391         uint256 ethAmount;
392         uint256 salt;
393     }
394 
395     struct Round {
396         // earlyIncome weight sum
397         uint256 rEarlyIncomeWeight;
398         // blockNumber to get hash as random seed
399         uint256 keyBlockNr;
400         mapping(address => bool) pBonusReceived;
401 
402         mapping(address => uint256) pBoughtTicketSum;
403         mapping(address => uint256) pTicketSum;
404         mapping(address => uint256) pInvestedSum;
405 
406         // early income weight by address
407         mapping(address => uint256) pEarlyIncomeWeight;
408         mapping(address => uint256) pEarlyIncomeCredit;
409         mapping(address => uint256) pEarlyIncomeClaimed;
410         // early income per weight
411         uint256 ppw;
412         // endTime increased every slot sold
413         // endTime limited by fixedEndTime
414         uint256 startTime;
415         uint256 slideEndTime;
416         uint256 fixedEndTime;
417 
418         // ticketSum from round 1 to this round
419         uint256 ticketSum;
420         // investedSum from round 1 to this round
421         uint256 investedSum;
422         // number of slots from round 1 to this round
423         uint256 slotSum;
424     }
425 
426     // round started with this grandPot amount,
427     // used to calculate the rate for grandPot results
428     // init in roundInit function
429     uint256 public initGrandPot;
430 
431     Slot[] public slot;
432     // slotId logs by address
433     mapping( address => uint256[]) pSlot;
434     mapping( address => uint256) public pSlotSum;
435 
436     // logs by address
437     mapping( address => uint256) public pTicketSum;
438     mapping( address => uint256) public pInvestedSum;
439 
440     CitizenInterface public citizenContract;
441     F2mInterface public f2mContract;
442     BankInterface public bankContract;
443     RewardInterface public rewardContract;
444 
445     address public devTeam;
446 
447     uint256 constant public ZOOM = 1000;
448     uint256 constant public ONE_HOUR = 60 * 60;
449     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
450     uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
451     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
452     uint256 constant public TIMEOUT2 = 7 * ONE_DAY;
453     uint256 constant public FINALIZE_WAIT_DURATION = 60; // 60 Seconds
454     uint256 constant public NEWROUND_WAIT_DURATION = 18 * ONE_HOUR; // 24 Hours
455 
456     // 15 seconds on Ethereum, 12 seconds used instead to make sure blockHash unavaiable
457     // when slideEndTime reached
458     // keyBlockNumber will be estimated again after every slot buy
459     uint256 constant public BLOCK_TIME = 12;
460     uint256 constant public MAX_BLOCK_DISTANCE = 250;
461 
462     uint256 constant public TBONUS_RATE = 100;
463     uint256 public CASHOUT_REQ = 1;
464 
465     uint256 public GRAND_RATE;
466     uint256 public MAJOR_RATE = 1001;
467     uint256 public MINOR_RATE = 501;
468     uint256 constant public MAJOR_MIN = 0.1 ether;
469     uint256 constant public MINOR_MIN = 0.1 ether;
470 
471     //Bonus Tickets : Bounty + 7 sBounty
472     uint256 public bountyPercent = 30;
473     uint256 public sBountyPercent = 10;
474 
475     //uint256 public toNextPotPercent = 27;
476     uint256 public grandRewardPercent = 15;
477     uint256 public sGrandRewardPercent = 5;
478     uint256 public jRewardPercent = 60;
479 
480     uint256 public toTokenPercent = 12; // 10% dividends 2% fund
481     uint256 public toBuyTokenPercent = 1;
482     uint256 public earlyIncomePercent = 22;
483     uint256 public toRefPercent = 15;
484 
485     // sum == 100% = toPotPercent/100 * investedSum
486     // uint256 public grandPercent = 80; //68;
487     uint256 public majorPercent = 10; // 24;
488     uint256 public minorPercent = 10; // 8;
489 
490     uint256 public grandPot;
491     uint256 public majorPot;
492     uint256 public minorPot;
493 
494     uint256 public curRoundId;
495     uint256 public lastRoundId = 88888888;
496 
497     mapping (address => uint256) public rewardBalance;
498     // used to save gas on earlyIncome calculating, curRoundId never included
499     // only earlyIncome from round 1st to curRoundId-1 are fixed
500     mapping (address => uint256) public lastWithdrawnRound;
501     mapping (address => uint256) public earlyIncomeScannedSum;
502 
503     mapping (uint256 => Round) public round;
504 
505     // Current Round
506 
507     // first SlotId in last Block to fire jackpot
508     uint256 public jSlot;
509     // jackpot results of all slots in same block will be drawed at the same time,
510     // by player, who buys the first slot in next block
511     uint256 public lastBlockNr;
512     // added by slot salt after every slot buy
513     // does not matter with overflow
514     uint256 public curRSalt;
515     // ticket sum of current round
516     uint256 public curRTicketSum;
517 
518     uint256 public lastBuyTime;
519     uint256 public lastEndTime;
520     uint256 constant multiDelayTime = 60;
521 
522     constructor (address _devTeam)
523         public
524     {
525         // register address in network
526         DevTeamInterface(_devTeam).setLotteryAddress(address(this));
527         devTeam = _devTeam;
528     }
529 
530     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
531     function joinNetwork(address[6] _contract)
532         public
533     {
534         require(address(citizenContract) == 0x0,"already setup");
535         f2mContract = F2mInterface(_contract[0]);
536         bankContract = BankInterface(_contract[1]);
537         citizenContract = CitizenInterface(_contract[2]);
538         //lotteryContract = LotteryInterface(lotteryAddress);
539         rewardContract = RewardInterface(_contract[4]);
540     }
541 
542     function activeFirstRound()
543         public
544         onlyDevTeam()
545     {
546         require(curRoundId == 0, "already activated");
547         initRound();
548         GRAND_RATE = getWeightRange();
549     }
550 
551     // Core Functions
552 
553     function pushToPot() 
554         public 
555         payable
556     {
557         addPot(msg.value);
558     }
559 
560     function checkpoint() 
561         private
562     {
563         // dummy slot between every 2 rounds
564         // dummy slot never win jackpot cause of min 0.1 ETH
565         Slot memory _slot;
566         // _slot.tNumberTo = round[curRoundId].ticketSum;
567         slot.push(_slot);
568 
569         Round memory _round;
570         _round.startTime = NEWROUND_WAIT_DURATION.add(block.timestamp);
571         // started with 3 hours timeout
572         _round.slideEndTime = TIMEOUT0 + _round.startTime;
573         _round.fixedEndTime = TIMEOUT2 + _round.startTime;
574         _round.keyBlockNr = genEstKeyBlockNr(_round.slideEndTime);
575         _round.ticketSum = round[curRoundId].ticketSum;
576         _round.investedSum = round[curRoundId].investedSum;
577         _round.slotSum = slot.length;
578 
579         curRoundId = curRoundId + 1;
580         round[curRoundId] = _round;
581 
582         initGrandPot = grandPot;
583         curRTicketSum = 0;
584     }
585 
586     // from round 28+ function -- REMOVED
587     function isLastRound()
588         public
589         view
590         returns(bool)
591     {
592         return (curRoundId == lastRoundId);
593     }
594 
595     function goNext()
596         private
597     {
598         grandPot = 0;
599         majorPot = 0;
600         minorPot = 0;
601         f2mContract.pushDividends.value(this.balance)();
602         // never start
603         round[curRoundId].startTime = block.timestamp * 10;
604         round[curRoundId].slideEndTime = block.timestamp * 10 + 1;
605         CASHOUT_REQ = 0;
606     }
607 
608     function initRound()
609         private
610     {
611         // update all Round Log
612         checkpoint();
613         if (isLastRound()) goNext();
614         updateMulti();
615     }
616 
617     function finalizeable() 
618         public
619         view
620         returns(bool)
621     {
622         uint256 finalizeTime = FINALIZE_WAIT_DURATION.add(round[curRoundId].slideEndTime);
623         if (finalizeTime > block.timestamp) return false; // too soon to finalize
624         if (getEstKeyBlockNr(curRoundId) >= block.number) return false; //block hash not exist
625         return curRoundId > 0;
626     }
627 
628     // bounty
629     function finalize()
630         public
631     {
632         require(finalizeable(), "Not ready to draw results");
633         uint256 _pRoundTicketSum = round[curRoundId].pBoughtTicketSum[msg.sender];
634         uint256 _bountyTicketSum = _pRoundTicketSum * bountyPercent / 100;
635         endRound(msg.sender, _bountyTicketSum);
636         initRound();
637         mintSlot(msg.sender, _bountyTicketSum, 0, 0);
638     }
639 
640     function mintReward(
641         address _lucker,
642         uint256 _winNr,
643         uint256 _slotId,
644         uint256 _value,
645         RewardType _rewardType)
646         private
647     {
648         // add reward balance if its not Bounty Type and winner != 0x0
649         if ((_rewardType != RewardType.Bounty) && (_lucker != 0x0))
650             rewardBalance[_lucker] = rewardBalance[_lucker].add(_value);
651         // reward log
652         rewardContract.mintReward(
653             _lucker,
654             curRoundId,
655             _winNr,
656             slot[_slotId].tNumberFrom,
657             slot[_slotId].tNumberTo,
658             _value,
659             uint256(_rewardType)
660         );
661     }
662 
663     function mintSlot(
664         address _buyer,
665         // uint256 _rId,
666         // ticket numbers in range and unique in all rounds
667         // uint256 _tNumberFrom,
668         // uint256 _tNumberTo,
669         uint256 _tAmount,
670         uint256 _ethAmount,
671         uint256 _salt
672         )
673         private
674     {
675         uint256 _tNumberFrom = curRTicketSum + 1;
676         uint256 _tNumberTo = _tNumberFrom + _tAmount - 1;
677         Slot memory _slot;
678         _slot.buyer = _buyer;
679         _slot.rId = curRoundId;
680         _slot.tNumberFrom = _tNumberFrom;
681         _slot.tNumberTo = _tNumberTo;
682         _slot.ethAmount = _ethAmount;
683         _slot.salt = _salt;
684         slot.push(_slot);
685         updateTicketSum(_buyer, _tAmount);
686         round[curRoundId].slotSum = slot.length;
687         pSlot[_buyer].push(slot.length - 1);
688     }
689 
690     function jackpot()
691         private
692     {
693         // get blocknumber to get blockhash
694         uint256 keyBlockNr = getKeyBlockNr(lastBlockNr);//block.number;
695         // salt not effected by jackpot, too risk
696         uint256 seed = getSeed(keyBlockNr);
697         // slot numberic from 1 ... totalSlot(round)
698         // jackpot for all slot in last block, jSlot <= i <= lastSlotId (=slotSum - 1)
699         // _to = first Slot in new block
700         //uint256 _to = round[curRoundId].slotSum;
701 
702         uint256 jReward;
703         // uint256 toF2mAmount;
704         address winner;
705         // jackpot check for slots in last block
706         while (jSlot + 1 < round[curRoundId].slotSum) {
707             // majorPot
708             if (MAJOR_RATE > 2) MAJOR_RATE--;
709             if (Helper.isJackpot(seed, MAJOR_RATE, MAJOR_MIN, slot[jSlot].ethAmount)){
710 
711                 winner = slot[jSlot].buyer;
712                 jReward = majorPot / 100 * jRewardPercent;
713                 mintReward(winner, 0, jSlot, jReward, RewardType.Major);
714                 majorPot = majorPot - jReward;
715                 MAJOR_RATE = 1001;
716             }
717             seed = seed + jSlot;
718             // minorPot
719             if (MINOR_RATE > 2) MINOR_RATE--;
720             if (Helper.isJackpot(seed, MINOR_RATE, MINOR_MIN, slot[jSlot].ethAmount)){
721 
722                 winner = slot[jSlot].buyer;
723                 jReward = minorPot / 100 * jRewardPercent;
724                 mintReward(winner, 0, jSlot, jReward, RewardType.Minor);
725                 minorPot = minorPot - jReward;
726                 MINOR_RATE = 501;
727             }
728             seed = seed + jSlot;
729             jSlot++;
730         }
731     }
732 
733     function endRound(address _bountyHunter, uint256 _bountyTicketSum)
734         private
735     {
736         // GRAND_RATE = GRAND_RATE * 9 / 10; // REMOVED
737         uint256 _rId = curRoundId;
738         uint256 keyBlockNr = getKeyBlockNr(round[_rId].keyBlockNr);
739         // curRSalt SAFE, CHECKED
740         uint256 _seed = getSeed(keyBlockNr) + curRSalt;
741         uint256 onePercent = grandPot / 100;
742 
743         // 0 : 5% grandPot, 100% winRate
744         // 1 : 15% grandPot, dynamic winRate
745         uint256[2] memory rGrandReward = [
746             onePercent * sGrandRewardPercent, 
747             onePercent * grandRewardPercent
748         ];
749         uint256[2] memory weightRange = [
750             curRTicketSum, 
751             GRAND_RATE > curRTicketSum ? GRAND_RATE : curRTicketSum
752         ];
753         // REMOVED
754         // uint256[2] memory toF2mAmount = [0, onePercent * toTokenPercent];
755 
756         // 1st turn for small grandPot (val = 5% rate = 100%)
757         // 2nd turn for big grandPot (val = 15%, rate = max(GRAND_RATE, curRTicketSum), 12% to F2M contract if got winner)
758 
759         for (uint256 i = 0; i < 2; i++){
760             address _winner = 0x0;
761             uint256 _winSlot = 0;
762             uint256 _winNr = Helper.getRandom(_seed, weightRange[i]);
763             // if winNr > curRTicketSum => no winner this turn
764             // win Slot : fromWeight <= winNr <= toWeight
765             // got winner this rolling turn
766             if (_winNr <= curRTicketSum) {
767                 // grandPot -= rGrandReward[i] + toF2mAmount[i];
768                 grandPot -= rGrandReward[i];
769                 // big grandPot 15%
770                 if (i == 1) {
771                     GRAND_RATE = GRAND_RATE * 2;
772                     // f2mContract.pushDividends.value(toF2mAmount[i])();
773                 }
774                 _winSlot = getWinSlot(_winNr);
775                 _winner = slot[_winSlot].buyer;
776                 _seed = _seed + (_seed / 10);
777             }
778             mintReward(_winner, _winNr, _winSlot, rGrandReward[i], RewardType.Grand);
779         }
780 
781         mintReward(_bountyHunter, 0, 0, _bountyTicketSum, RewardType.Bounty);
782         rewardContract.resetCounter(curRoundId);
783         GRAND_RATE = (GRAND_RATE / 100) * 99 + 1;
784     }
785 
786     function buy(string _sSalt)
787         public
788         payable
789     {
790         buyFor(_sSalt, msg.sender);
791     }
792 
793     function updateInvested(address _buyer, uint256 _ethAmount)
794         private
795     {
796         round[curRoundId].investedSum += _ethAmount;
797         round[curRoundId].pInvestedSum[_buyer] += _ethAmount;
798         pInvestedSum[_buyer] += _ethAmount;
799     }
800 
801     function updateTicketSum(address _buyer, uint256 _tAmount)
802         private
803     {
804         round[curRoundId].ticketSum = round[curRoundId].ticketSum + _tAmount;
805         round[curRoundId].pTicketSum[_buyer] = round[curRoundId].pTicketSum[_buyer] + _tAmount;
806         curRTicketSum = curRTicketSum + _tAmount;
807         pTicketSum[_buyer] = pTicketSum[_buyer] + _tAmount;
808     }
809 
810     function updateEarlyIncome(address _buyer, uint256 _pWeight)
811         private
812     {
813         round[curRoundId].rEarlyIncomeWeight = _pWeight.add(round[curRoundId].rEarlyIncomeWeight);
814         round[curRoundId].pEarlyIncomeWeight[_buyer] = _pWeight.add(round[curRoundId].pEarlyIncomeWeight[_buyer]);
815         round[curRoundId].pEarlyIncomeCredit[_buyer] = round[curRoundId].pEarlyIncomeCredit[_buyer].add(_pWeight.mul(round[curRoundId].ppw));
816     }
817 
818     function getBonusTickets(address _buyer)
819         private
820         returns(uint256)
821     {
822         if (round[curRoundId].pBonusReceived[_buyer]) return 0;
823         round[curRoundId].pBonusReceived[_buyer] = true;
824         return round[curRoundId - 1].pBoughtTicketSum[_buyer] / TBONUS_RATE;
825     }
826 
827     function updateMulti()
828         private
829     {
830         if (lastBuyTime + multiDelayTime < block.timestamp) {
831             lastEndTime = round[curRoundId].slideEndTime;
832         }
833         lastBuyTime = block.timestamp;
834     }
835 
836     function buyFor(string _sSalt, address _sender) 
837         public
838         payable
839         buyable()
840     {
841         uint256 _salt = Helper.stringToUint(_sSalt);
842         uint256 _ethAmount = msg.value;
843         uint256 _ticketSum = curRTicketSum;
844         require(_ethAmount >= Helper.getTPrice(_ticketSum), "not enough to buy 1 ticket");
845 
846         // investedSum logs
847         updateInvested(_sender, _ethAmount);
848         updateMulti();
849         // update salt
850         curRSalt = curRSalt + _salt;
851         uint256 _tAmount = Helper.getTAmount(_ethAmount, _ticketSum);
852         uint256 _tMul = getTMul(); // 100x Zoomed
853         uint256 _pMul = Helper.getEarlyIncomeMul(_ticketSum);
854         uint256 _pWeight = _pMul.mul(_tAmount);
855         uint256 _toAddTime = Helper.getAddedTime(_ticketSum, _tAmount);
856         addTime(curRoundId, _toAddTime);
857         _tAmount = _tAmount.mul(_tMul) / 100;
858         round[curRoundId].pBoughtTicketSum[_sender] += _tAmount;
859         mintSlot(_sender, _tAmount + getBonusTickets(_sender), _ethAmount, _salt);
860 
861         // EarlyIncome Weight
862         // ppw and credit zoomed x1000
863         // earlyIncome mul of each ticket in this slot
864         updateEarlyIncome(_sender, _pWeight);
865 
866         // first slot in this block draw jacpot results for 
867         // all slot in last block
868         if (lastBlockNr != block.number) {
869             jackpot();
870             lastBlockNr = block.number;
871         }
872 
873         distributeSlotBuy(_sender, curRoundId, _ethAmount);
874 
875         round[curRoundId].keyBlockNr = genEstKeyBlockNr(round[curRoundId].slideEndTime);
876     }
877 
878     function distributeSlotBuy(address _sender, uint256 _rId, uint256 _ethAmount)
879         private
880     {
881         uint256 onePercent = _ethAmount / 100;
882         uint256 toF2mAmount = onePercent * toTokenPercent; // 12
883         uint256 toRefAmount = onePercent * toRefPercent; // 10
884         uint256 toBuyTokenAmount = onePercent * toBuyTokenPercent; //1
885         uint256 earlyIncomeAmount = onePercent * earlyIncomePercent; //27
886         uint256 taxAmount = toF2mAmount + toRefAmount + toBuyTokenAmount + earlyIncomeAmount; // 50
887         uint256 taxedEthAmount = _ethAmount.sub(taxAmount); // 50
888         addPot(taxedEthAmount);
889         
890         // 10% Ref
891         citizenContract.pushRefIncome.value(toRefAmount)(_sender);
892         // 2% Fund + 10% Dividends 
893         f2mContract.pushDividends.value(toF2mAmount)();
894         // 1% buy Token
895         f2mContract.buyFor.value(toBuyTokenAmount)(_sender);
896         // 27% Early
897         uint256 deltaPpw = (earlyIncomeAmount * ZOOM).div(round[_rId].rEarlyIncomeWeight);
898         round[_rId].ppw = deltaPpw.add(round[_rId].ppw);
899     }
900 
901     function claimEarlyIncomebyAddress(address _buyer)
902         private
903     {
904         if (curRoundId == 0) return;
905         claimEarlyIncomebyAddressRound(_buyer, curRoundId);
906         uint256 _rId = curRoundId - 1;
907         while ((_rId > lastWithdrawnRound[_buyer]) && (_rId + 20 > curRoundId)) {
908             earlyIncomeScannedSum[_buyer] += claimEarlyIncomebyAddressRound(_buyer, _rId);
909             _rId = _rId - 1;
910         }
911     }
912 
913     function claimEarlyIncomebyAddressRound(address _buyer, uint256 _rId)
914         private
915         returns(uint256)
916     {
917         uint256 _amount = getCurEarlyIncomeByAddressRound(_buyer, _rId);
918         if (_amount == 0) return 0;
919         round[_rId].pEarlyIncomeClaimed[_buyer] = _amount.add(round[_rId].pEarlyIncomeClaimed[_buyer]);
920         rewardBalance[_buyer] = _amount.add(rewardBalance[_buyer]);
921         return _amount;
922     }
923 
924     function withdrawFor(address _sender)
925         public
926         withdrawRight()
927         returns(uint256)
928     {
929         if (curRoundId == 0) return;
930         claimEarlyIncomebyAddress(_sender);
931         lastWithdrawnRound[_sender] = curRoundId - 1;
932         uint256 _amount = rewardBalance[_sender];
933         rewardBalance[_sender] = 0;
934         bankContract.pushToBank.value(_amount)(_sender);
935         return _amount;
936     }
937     
938     function addTime(uint256 _rId, uint256 _toAddTime)
939         private
940     {
941         round[_rId].slideEndTime = Helper.getNewEndTime(_toAddTime, round[_rId].slideEndTime, round[_rId].fixedEndTime);
942     }
943 
944     // distribute to 3 pots Grand, Majorm Minor
945     function addPot(uint256 _amount)
946         private
947     {
948         uint256 onePercent = _amount / 100;
949         uint256 toMinor = onePercent * minorPercent;
950         uint256 toMajor = onePercent * majorPercent;
951         uint256 toGrand = _amount - toMinor - toMajor;
952 
953         minorPot = minorPot + toMinor;
954         majorPot = majorPot + toMajor;
955         grandPot = grandPot + toGrand;
956     }
957 
958 
959     //////////////////////////////////////////////////////////////////
960     // READ FUNCTIONS
961     //////////////////////////////////////////////////////////////////
962 
963     function isWinSlot(uint256 _slotId, uint256 _keyNumber)
964         public
965         view
966         returns(bool)
967     {
968         return (slot[_slotId - 1].tNumberTo < _keyNumber) && (slot[_slotId].tNumberTo >= _keyNumber);
969     }
970 
971     function getWeightRange()
972         public
973         view
974         returns(uint256)
975     {
976         return Helper.getWeightRange(initGrandPot);
977     }
978 
979     function getWinSlot(uint256 _keyNumber)
980         public
981         view
982         returns(uint256)
983     {
984         // return 0 if not found
985         uint256 _to = slot.length - 1;
986         uint256 _from = round[curRoundId-1].slotSum + 1; // dummy slot ignore
987         uint256 _pivot;
988         //Slot memory _slot;
989         uint256 _pivotTo;
990         // Binary search
991         while (_from <= _to) {
992             _pivot = (_from + _to) / 2;
993             _pivotTo = slot[_pivot].tNumberTo;
994             if (isWinSlot(_pivot, _keyNumber)) return _pivot;
995             if (_pivotTo < _keyNumber) { // in right side
996                 _from = _pivot + 1;
997             } else { // in left side
998                 _to = _pivot - 1;
999             }
1000         }
1001         return _pivot; // never happens or smt gone wrong
1002     }
1003 
1004     // Key Block in future
1005     function genEstKeyBlockNr(uint256 _endTime) 
1006         public
1007         view
1008         returns(uint256)
1009     {
1010         if (block.timestamp >= _endTime) return block.number + 8; 
1011         uint256 timeDist = _endTime - block.timestamp;
1012         uint256 estBlockDist = timeDist / BLOCK_TIME;
1013         return block.number + estBlockDist + 8;
1014     }
1015 
1016     // get block hash of first block with blocktime > _endTime
1017     function getSeed(uint256 _keyBlockNr)
1018         public
1019         view
1020         returns (uint256)
1021     {
1022         // Key Block not mined atm
1023         if (block.number <= _keyBlockNr) return block.number;
1024         return uint256(blockhash(_keyBlockNr));
1025     }
1026 
1027     // current reward balance
1028     function getRewardBalance(address _buyer)
1029         public
1030         view
1031         returns(uint256)
1032     {
1033         return rewardBalance[_buyer];
1034     } 
1035 
1036     // GET endTime
1037     function getSlideEndTime(uint256 _rId)
1038         public
1039         view
1040         returns(uint256)
1041     {
1042         return(round[_rId].slideEndTime);
1043     }
1044 
1045     function getFixedEndTime(uint256 _rId)
1046         public
1047         view
1048         returns(uint256)
1049     {
1050         return(round[_rId].fixedEndTime);
1051     }
1052 
1053     function getTotalPot()
1054         public
1055         view
1056         returns(uint256)
1057     {
1058         return grandPot + majorPot + minorPot;
1059     }
1060 
1061     // EarlyIncome
1062     function getEarlyIncomeByAddress(address _buyer)
1063         public
1064         view
1065         returns(uint256)
1066     {
1067         uint256 _sum = earlyIncomeScannedSum[_buyer];
1068         uint256 _fromRound = lastWithdrawnRound[_buyer] + 1; // >=1
1069         if (_fromRound + 100 < curRoundId) _fromRound = curRoundId - 100;
1070         uint256 _rId = _fromRound;
1071         while (_rId <= curRoundId) {
1072             _sum = _sum + getEarlyIncomeByAddressRound(_buyer, _rId);
1073             _rId++;
1074         }
1075         return _sum;
1076     }
1077 
1078     // included claimed amount
1079     function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId)
1080         public
1081         view
1082         returns(uint256)
1083     {
1084         uint256 _pWeight = round[_rId].pEarlyIncomeWeight[_buyer];
1085         uint256 _ppw = round[_rId].ppw;
1086         uint256 _rCredit = round[_rId].pEarlyIncomeCredit[_buyer];
1087         uint256 _rEarlyIncome = ((_ppw.mul(_pWeight)).sub(_rCredit)).div(ZOOM);
1088         return _rEarlyIncome;
1089     }
1090 
1091     function getCurEarlyIncomeByAddress(address _buyer)
1092         public
1093         view
1094         returns(uint256)
1095     {
1096         uint256 _sum = 0;
1097         uint256 _fromRound = lastWithdrawnRound[_buyer] + 1; // >=1
1098         if (_fromRound + 100 < curRoundId) _fromRound = curRoundId - 100;
1099         uint256 _rId = _fromRound;
1100         while (_rId <= curRoundId) {
1101             _sum = _sum.add(getCurEarlyIncomeByAddressRound(_buyer, _rId));
1102             _rId++;
1103         }
1104         return _sum;
1105     }
1106 
1107     function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId)
1108         public
1109         view
1110         returns(uint256)
1111     {
1112         uint256 _rEarlyIncome = getEarlyIncomeByAddressRound(_buyer, _rId);
1113         return _rEarlyIncome.sub(round[_rId].pEarlyIncomeClaimed[_buyer]);
1114     }
1115 
1116     ////////////////////////////////////////////////////////////////////
1117 
1118     function getEstKeyBlockNr(uint256 _rId)
1119         public
1120         view
1121         returns(uint256)
1122     {
1123         return round[_rId].keyBlockNr;
1124     }
1125 
1126     function getKeyBlockNr(uint256 _estKeyBlockNr)
1127         public
1128         view
1129         returns(uint256)
1130     {
1131         require(block.number > _estKeyBlockNr, "blockHash not avaiable");
1132         uint256 jump = (block.number - _estKeyBlockNr) / MAX_BLOCK_DISTANCE * MAX_BLOCK_DISTANCE;
1133         return _estKeyBlockNr + jump;
1134     }
1135 
1136     // Logs
1137     function getCurRoundId()
1138         public
1139         view
1140         returns(uint256)
1141     {
1142         return curRoundId;
1143     }
1144 
1145     function getTPrice()
1146         public
1147         view
1148         returns(uint256)
1149     {
1150         return Helper.getTPrice(curRTicketSum);
1151     }
1152 
1153     function getTMul()
1154         public
1155         view
1156         returns(uint256)
1157     {
1158         return Helper.getTMul(
1159                 initGrandPot, 
1160                 grandPot, 
1161                 lastBuyTime + multiDelayTime < block.timestamp ? round[curRoundId].slideEndTime : lastEndTime, 
1162                 round[curRoundId].fixedEndTime
1163             );
1164     }
1165 
1166     function getPMul()
1167         public
1168         view
1169         returns(uint256)
1170     {
1171         return Helper.getEarlyIncomeMul(curRTicketSum);
1172     }
1173 
1174     function getPTicketSumByRound(uint256 _rId, address _buyer)
1175         public
1176         view
1177         returns(uint256)
1178     {
1179         return round[_rId].pTicketSum[_buyer];
1180     }
1181 
1182     function getTicketSumToRound(uint256 _rId)
1183         public
1184         view
1185         returns(uint256)
1186     {
1187         return round[_rId].ticketSum;
1188     }
1189 
1190     function getPInvestedSumByRound(uint256 _rId, address _buyer)
1191         public
1192         view
1193         returns(uint256)
1194     {
1195         return round[_rId].pInvestedSum[_buyer];
1196     }
1197 
1198     function getInvestedSumToRound(uint256 _rId)
1199         public
1200         view
1201         returns(uint256)
1202     {
1203         return round[_rId].investedSum;
1204     }
1205 
1206     function getPSlotLength(address _sender)
1207         public
1208         view
1209         returns(uint256)
1210     {
1211         return pSlot[_sender].length;
1212     }
1213 
1214     function getSlotLength()
1215         public
1216         view
1217         returns(uint256)
1218     {
1219         return slot.length;
1220     }
1221 
1222     function getSlotId(address _sender, uint256 i)
1223         public
1224         view
1225         returns(uint256)
1226     {
1227         return pSlot[_sender][i];
1228     }
1229 
1230     function getSlotInfo(uint256 _slotId)
1231         public
1232         view
1233         returns(address, uint256[4], string)
1234     {
1235         Slot memory _slot = slot[_slotId];
1236         return (_slot.buyer,[_slot.rId, _slot.tNumberFrom, _slot.tNumberTo, _slot.ethAmount], Helper.uintToString(_slot.salt));
1237     }
1238 
1239     function cashoutable(address _address) 
1240         public
1241         view
1242         returns(bool)
1243     {
1244         // need 1 ticket of curRound or lastRound in waiting time to start new round
1245         if (round[curRoundId].pTicketSum[_address] >= CASHOUT_REQ) return true;
1246         if (round[curRoundId].startTime > block.timestamp) {
1247             // underflow return false
1248             uint256 _lastRoundTickets = getPTicketSumByRound(curRoundId - 1, _address);
1249             if (_lastRoundTickets >= CASHOUT_REQ) return true;
1250         }
1251         return false;
1252     }
1253 
1254     // set endRound, prepare to upgrade new version
1255     function setLastRound(uint256 _lastRoundId) 
1256         public
1257         onlyDevTeam()
1258     {
1259         require(_lastRoundId >= 8 && _lastRoundId > curRoundId, "too early to end");
1260         require(lastRoundId == 88888888, "already set");
1261         lastRoundId = _lastRoundId;
1262 
1263     }
1264 
1265     function sBountyClaim(address _sBountyHunter)
1266         public
1267         notStarted()
1268         returns(uint256)
1269     {
1270         require(msg.sender == address(rewardContract), "only Reward contract can manage sBountys");
1271         uint256 _lastRoundTickets = round[curRoundId - 1].pBoughtTicketSum[_sBountyHunter];
1272         uint256 _sBountyTickets = _lastRoundTickets * sBountyPercent / 100;
1273         mintSlot(_sBountyHunter, _sBountyTickets, 0, 0);
1274         return _sBountyTickets;
1275     }
1276 
1277     /*
1278         TEST
1279     */
1280 
1281     // function forceEndRound() 
1282     //     public
1283     // {
1284     //     round[curRoundId].keyBlockNr = block.number;
1285     //     round[curRoundId].slideEndTime = block.timestamp;
1286     //     round[curRoundId].fixedEndTime = block.timestamp;
1287     // }
1288 
1289     // function setTimer1(uint256 _hours)
1290     //     public
1291     // {
1292     //     round[curRoundId].slideEndTime = block.timestamp + _hours * 1 hours + 60;
1293     //     round[curRoundId].keyBlockNr = genEstKeyBlockNr(round[curRoundId].slideEndTime);
1294     // }
1295 
1296     // function setTimer2(uint256 _days)
1297     //     public
1298     // {
1299     //     round[curRoundId].fixedEndTime = block.timestamp + _days * 1 days + 60;
1300     //     require(round[curRoundId].fixedEndTime >= round[curRoundId].slideEndTime, "invalid test data");
1301     // }
1302 }
1303 
1304 interface F2mInterface {
1305     function joinNetwork(address[6] _contract) public;
1306     // one time called
1307     // function disableRound0() public;
1308     function activeBuy() public;
1309     // function premine() public;
1310     // Dividends from all sources (DApps, Donate ...)
1311     function pushDividends() public payable;
1312     /**
1313      * Converts all of caller's dividends to tokens.
1314      */
1315     function buyFor(address _buyer) public payable;
1316     function sell(uint256 _tokenAmount) public;
1317     function exit() public;
1318     function devTeamWithdraw() public returns(uint256);
1319     function withdrawFor(address sender) public returns(uint256);
1320     function transfer(address _to, uint256 _tokenAmount) public returns(bool);
1321     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1322     function setAutoBuy() public;
1323     /*==========================================
1324     =            PUBLIC FUNCTIONS            =
1325     ==========================================*/
1326     function ethBalance(address _address) public view returns(uint256);
1327     function myBalance() public view returns(uint256);
1328     function myEthBalance() public view returns(uint256);
1329 
1330     function swapToken() public;
1331     function setNewToken(address _newTokenAddress) public;
1332 }
1333 
1334 interface CitizenInterface {
1335  
1336     function joinNetwork(address[6] _contract) public;
1337     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1338     function devTeamWithdraw() public;
1339 
1340     /*----------  WRITE FUNCTIONS  ----------*/
1341     function updateUsername(string _sNewUsername) public;
1342     //Sources: Token contract, DApps
1343     function pushRefIncome(address _sender) public payable;
1344     function withdrawFor(address _sender) public payable returns(uint256);
1345     function devTeamReinvest() public returns(uint256);
1346 
1347     /*----------  READ FUNCTIONS  ----------*/
1348     function getRefWallet(address _address) public view returns(uint256);
1349 }
1350 
1351 interface DevTeamInterface {
1352     function setF2mAddress(address _address) public;
1353     function setLotteryAddress(address _address) public;
1354     function setCitizenAddress(address _address) public;
1355     function setBankAddress(address _address) public;
1356     function setRewardAddress(address _address) public;
1357     function setWhitelistAddress(address _address) public;
1358 
1359     function setupNetwork() public;
1360 }
1361 
1362 interface BankInterface {
1363     function joinNetwork(address[6] _contract) public;
1364     function pushToBank(address _player) public payable;
1365 }
1366 
1367 interface RewardInterface {
1368 
1369     function mintReward(
1370         address _lucker,
1371         uint256 curRoundId,
1372         uint256 _winNr,
1373         uint256 _tNumberFrom,
1374         uint256 _tNumberTo,
1375         uint256 _value,
1376         uint256 _rewardType)
1377         public;
1378         
1379     function joinNetwork(address[6] _contract) public;
1380     function pushBounty(uint256 _curRoundId) public payable;
1381     function resetCounter(uint256 _curRoundId) public;
1382 }
1383 
1384 /**
1385  * @title SafeMath
1386  * @dev Math operations with safety checks that revert on error
1387  */
1388 library SafeMath {
1389     int256 constant private INT256_MIN = -2**255;
1390 
1391     /**
1392     * @dev Multiplies two unsigned integers, reverts on overflow.
1393     */
1394     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1395         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1396         // benefit is lost if 'b' is also tested.
1397         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1398         if (a == 0) {
1399             return 0;
1400         }
1401 
1402         uint256 c = a * b;
1403         require(c / a == b);
1404 
1405         return c;
1406     }
1407 
1408     /**
1409     * @dev Multiplies two signed integers, reverts on overflow.
1410     */
1411     function mul(int256 a, int256 b) internal pure returns (int256) {
1412         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1413         // benefit is lost if 'b' is also tested.
1414         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1415         if (a == 0) {
1416             return 0;
1417         }
1418 
1419         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
1420 
1421         int256 c = a * b;
1422         require(c / a == b);
1423 
1424         return c;
1425     }
1426 
1427     /**
1428     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1429     */
1430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1431         // Solidity only automatically asserts when dividing by 0
1432         require(b > 0);
1433         uint256 c = a / b;
1434         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1435 
1436         return c;
1437     }
1438 
1439     /**
1440     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
1441     */
1442     function div(int256 a, int256 b) internal pure returns (int256) {
1443         require(b != 0); // Solidity only automatically asserts when dividing by 0
1444         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
1445 
1446         int256 c = a / b;
1447 
1448         return c;
1449     }
1450 
1451     /**
1452     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1453     */
1454     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1455         require(b <= a);
1456         uint256 c = a - b;
1457 
1458         return c;
1459     }
1460 
1461     /**
1462     * @dev Subtracts two signed integers, reverts on overflow.
1463     */
1464     function sub(int256 a, int256 b) internal pure returns (int256) {
1465         int256 c = a - b;
1466         require((b >= 0 && c <= a) || (b < 0 && c > a));
1467 
1468         return c;
1469     }
1470 
1471     /**
1472     * @dev Adds two unsigned integers, reverts on overflow.
1473     */
1474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1475         uint256 c = a + b;
1476         require(c >= a);
1477 
1478         return c;
1479     }
1480 
1481     /**
1482     * @dev Adds two signed integers, reverts on overflow.
1483     */
1484     function add(int256 a, int256 b) internal pure returns (int256) {
1485         int256 c = a + b;
1486         require((b >= 0 && c >= a) || (b < 0 && c < a));
1487 
1488         return c;
1489     }
1490 
1491     /**
1492     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1493     * reverts when dividing by zero.
1494     */
1495     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1496         require(b != 0);
1497         return a % b;
1498     }
1499 }