1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 interface F2mInterface {
10     function joinNetwork(address[6] _contract) public;
11     // one time called
12     function disableRound0() public;
13     function activeBuy() public;
14     // Dividends from all sources (DApps, Donate ...)
15     function pushDividends() public payable;
16     /**
17      * Converts all of caller's dividends to tokens.
18      */
19     //function reinvest() public;
20     //function buy() public payable;
21     function buyFor(address _buyer) public payable;
22     function sell(uint256 _tokenAmount) public;
23     function exit() public;
24     function devTeamWithdraw() public returns(uint256);
25     function withdrawFor(address sender) public returns(uint256);
26     function transfer(address _to, uint256 _tokenAmount) public returns(bool);
27     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
28     function setAutoBuy() public;
29     /*==========================================
30     =            public FUNCTIONS            =
31     ==========================================*/
32     // function totalEthBalance() public view returns(uint256);
33     function ethBalance(address _address) public view returns(uint256);
34     function myBalance() public view returns(uint256);
35     function myEthBalance() public view returns(uint256);
36 
37     function swapToken() public;
38     function setNewToken(address _newTokenAddress) public;
39 }
40 
41 interface CitizenInterface {
42  
43     function joinNetwork(address[6] _contract) public;
44     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
45     function devTeamWithdraw() public;
46 
47     /*----------  WRITE FUNCTIONS  ----------*/
48     function updateUsername(string _sNewUsername) public;
49     //Sources: Token contract, DApps
50     function pushRefIncome(address _sender) public payable;
51     function withdrawFor(address _sender) public payable returns(uint256);
52     function devTeamReinvest() public returns(uint256);
53 
54     /*----------  READ FUNCTIONS  ----------*/
55     function getRefWallet(address _address) public view returns(uint256);
56 }
57 
58 interface DevTeamInterface {
59     function setF2mAddress(address _address) public;
60     function setLotteryAddress(address _address) public;
61     function setCitizenAddress(address _address) public;
62     function setBankAddress(address _address) public;
63     function setRewardAddress(address _address) public;
64     function setWhitelistAddress(address _address) public;
65 
66     function setupNetwork() public;
67 }
68 
69 interface BankInterface {
70     function joinNetwork(address[6] _contract) public;
71     // Core functions
72     function pushToBank(address _player) public payable;
73 }
74 
75 interface RewardInterface {
76 
77     function mintReward(
78         address _lucker,
79         uint256 curRoundId,
80         uint256 _tNumberFrom,
81         uint256 _tNumberTo,
82         uint256 _value,
83         uint256 _rewardType)
84         public;
85         
86     function joinNetwork(address[6] _contract) public;
87     function pushBounty(uint256 _curRoundId) public payable;
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that revert on error
93  */
94 library SafeMath {
95     int256 constant private INT256_MIN = -2**255;
96 
97     /**
98     * @dev Multiplies two unsigned integers, reverts on overflow.
99     */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Multiplies two signed integers, reverts on overflow.
116     */
117     function mul(int256 a, int256 b) internal pure returns (int256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
126 
127         int256 c = a * b;
128         require(c / a == b);
129 
130         return c;
131     }
132 
133     /**
134     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
135     */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Solidity only automatically asserts when dividing by 0
138         require(b > 0);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
147     */
148     function div(int256 a, int256 b) internal pure returns (int256) {
149         require(b != 0); // Solidity only automatically asserts when dividing by 0
150         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
151 
152         int256 c = a / b;
153 
154         return c;
155     }
156 
157     /**
158     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
159     */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b <= a);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168     * @dev Subtracts two signed integers, reverts on overflow.
169     */
170     function sub(int256 a, int256 b) internal pure returns (int256) {
171         int256 c = a - b;
172         require((b >= 0 && c <= a) || (b < 0 && c > a));
173 
174         return c;
175     }
176 
177     /**
178     * @dev Adds two unsigned integers, reverts on overflow.
179     */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a);
183 
184         return c;
185     }
186 
187     /**
188     * @dev Adds two signed integers, reverts on overflow.
189     */
190     function add(int256 a, int256 b) internal pure returns (int256) {
191         int256 c = a + b;
192         require((b >= 0 && c >= a) || (b < 0 && c < a));
193 
194         return c;
195     }
196 
197     /**
198     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
199     * reverts when dividing by zero.
200     */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b != 0);
203         return a % b;
204     }
205 }
206 
207 library Helper {
208     using SafeMath for uint256;
209 
210     uint256 constant public ZOOM = 1000;
211     uint256 constant public SDIVIDER = 3450000;
212     uint256 constant public PDIVIDER = 3450000;
213     uint256 constant public RDIVIDER = 1580000;
214     // Starting LS price (SLP)
215     uint256 constant public SLP = 0.002 ether;
216     // Starting Added Time (SAT)
217     uint256 constant public SAT = 30; // seconds
218     // Price normalization (PN)
219     uint256 constant public PN = 777;
220     // EarlyIncome base
221     uint256 constant public PBASE = 13;
222     uint256 constant public PMULTI = 26;
223     uint256 constant public LBase = 15;
224 
225     uint256 constant public ONE_HOUR = 3600;
226     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
227     //uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
228     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
229     
230     function bytes32ToString (bytes32 data)
231         public
232         pure
233         returns (string) 
234     {
235         bytes memory bytesString = new bytes(32);
236         for (uint j=0; j<32; j++) {
237             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
238             if (char != 0) {
239                 bytesString[j] = char;
240             }
241         }
242         return string(bytesString);
243     }
244     
245     function uintToBytes32(uint256 n)
246         public
247         pure
248         returns (bytes32) 
249     {
250         return bytes32(n);
251     }
252     
253     function bytes32ToUint(bytes32 n) 
254         public
255         pure
256         returns (uint256) 
257     {
258         return uint256(n);
259     }
260     
261     function stringToBytes32(string memory source) 
262         public
263         pure
264         returns (bytes32 result) 
265     {
266         bytes memory tempEmptyStringTest = bytes(source);
267         if (tempEmptyStringTest.length == 0) {
268             return 0x0;
269         }
270 
271         assembly {
272             result := mload(add(source, 32))
273         }
274     }
275     
276     function stringToUint(string memory source) 
277         public
278         pure
279         returns (uint256)
280     {
281         return bytes32ToUint(stringToBytes32(source));
282     }
283     
284     function uintToString(uint256 _uint) 
285         public
286         pure
287         returns (string)
288     {
289         return bytes32ToString(uintToBytes32(_uint));
290     }
291 
292 /*     
293     function getSlice(uint256 begin, uint256 end, string text) public pure returns (string) {
294         bytes memory a = new bytes(end-begin+1);
295         for(uint i = 0; i <= end - begin; i++){
296             a[i] = bytes(text)[i + begin - 1];
297         }
298         return string(a);    
299     }
300  */
301     function validUsername(string _username)
302         public
303         pure
304         returns(bool)
305     {
306         uint256 len = bytes(_username).length;
307         // Im Raum [4, 18]
308         if ((len < 4) || (len > 18)) return false;
309         // Letzte Char != ' '
310         if (bytes(_username)[len-1] == 32) return false;
311         // Erste Char != '0'
312         return uint256(bytes(_username)[0]) != 48;
313     }
314 
315     // Lottery Helper
316 
317     // Seconds added per LT = SAT - ((Current no. of LT + 1) / SDIVIDER)^6
318     function getAddedTime(uint256 _rTicketSum, uint256 _tAmount)
319         public
320         pure
321         returns (uint256)
322     {
323         //Luppe = 10000 = 10^4
324         uint256 base = (_rTicketSum + 1).mul(10000) / SDIVIDER;
325         uint256 expo = base;
326         expo = expo.mul(expo).mul(expo); // ^3
327         expo = expo.mul(expo); // ^6
328         // div 10000^6
329         expo = expo / (10**24);
330 
331         if (expo > SAT) return 0;
332         return (SAT - expo).mul(_tAmount);
333     }
334 
335     function getNewEndTime(uint256 toAddTime, uint256 slideEndTime, uint256 fixedEndTime)
336         public
337         view
338         returns(uint256)
339     {
340         uint256 _slideEndTime = (slideEndTime).add(toAddTime);
341         uint256 timeout = _slideEndTime.sub(block.timestamp);
342         // timeout capped at TIMEOUT1
343         if (timeout > TIMEOUT1) timeout = TIMEOUT1;
344         _slideEndTime = (block.timestamp).add(timeout);
345         // Capped at fixedEndTime
346         if (_slideEndTime > fixedEndTime)  return fixedEndTime;
347         return _slideEndTime;
348     }
349 
350     // get random in range [1, _range] with _seed
351     function getRandom(uint256 _seed, uint256 _range)
352         public
353         pure
354         returns(uint256)
355     {
356         if (_range == 0) return _seed;
357         return (_seed % _range) + 1;
358     }
359 
360 
361     function getEarlyIncomeMul(uint256 _ticketSum)
362         public
363         pure
364         returns(uint256)
365     {
366         // Early-Multiplier = 1 + PBASE / (1 + PMULTI * ((Current No. of LT)/RDIVIDER)^6)
367         uint256 base = _ticketSum * ZOOM / RDIVIDER;
368         uint256 expo = base.mul(base).mul(base); //^3
369         expo = expo.mul(expo) / (ZOOM**6); //^6
370         return (1 + PBASE / (1 + expo.mul(PMULTI)));
371     }
372 
373     // get reveiced Tickets, based on current round ticketSum
374     function getTAmount(uint256 _ethAmount, uint256 _ticketSum) 
375         public
376         pure
377         returns(uint256)
378     {
379         uint256 _tPrice = getTPrice(_ticketSum);
380         return _ethAmount.div(_tPrice);
381     }
382 
383     // Lotto-Multiplier = 1 + LBase * (Current No. of Tickets / PDivider)^6
384     function getTMul(uint256 _ticketSum) // Unit Wei
385         public
386         pure
387         returns(uint256)
388     {
389         uint256 base = _ticketSum * ZOOM / PDIVIDER;
390         uint256 expo = base.mul(base).mul(base);
391         expo = expo.mul(expo); // ^6
392         return 1 + expo.mul(LBase) / (10**18);
393     }
394 
395     // get ticket price, based on current round ticketSum
396     //unit in ETH, no need / zoom^6
397     function getTPrice(uint256 _ticketSum)
398         public
399         pure
400         returns(uint256)
401     {
402         uint256 base = (_ticketSum + 1).mul(ZOOM) / PDIVIDER;
403         uint256 expo = base;
404         expo = expo.mul(expo).mul(expo); // ^3
405         expo = expo.mul(expo); // ^6
406         uint256 tPrice = SLP + expo / PN;
407         return tPrice;
408     }
409 
410     // get weight of slot, chance to win grandPot
411     function getSlotWeight(uint256 _ethAmount, uint256 _ticketSum)
412         public
413         pure
414         returns(uint256)
415     {
416         uint256 _tAmount = getTAmount(_ethAmount, _ticketSum);
417         uint256 _tMul = getTMul(_ticketSum);
418         return (_tAmount).mul(_tMul);
419     }
420 
421     // used to draw grandpot results
422     // weightRange = roundWeight * grandpot / (grandpot - initGrandPot)
423     // grandPot = initGrandPot + round investedSum(for grandPot)
424     function getWeightRange(uint256 grandPot, uint256 initGrandPot, uint256 curRWeight)
425         public
426         pure
427         returns(uint256)
428     {
429         //calculate round grandPot-investedSum
430         uint256 grandPotInvest = grandPot - initGrandPot;
431         if (grandPotInvest == 0) return 8;
432         uint256 zoomMul = grandPot * ZOOM / grandPotInvest;
433         uint256 weightRange = zoomMul * curRWeight / ZOOM;
434         if (weightRange < curRWeight) weightRange = curRWeight;
435         return weightRange;
436     }
437 }
438 
439 contract Lottery {
440     using SafeMath for uint256;
441 
442     modifier withdrawRight(){
443         require(msg.sender == address(bankContract), "Bank only");
444         _;
445     }
446 
447     modifier onlyDevTeam() {
448         require(msg.sender == devTeam, "only for development team");
449         _;
450     }
451 
452     modifier buyable() {
453         require(block.timestamp > round[curRoundId].startTime, "not ready to sell Ticket");
454         require(block.timestamp < round[curRoundId].slideEndTime, "round over");
455         _;
456     }
457 
458     enum RewardType {
459         Minor,
460         Major,
461         Grand,
462         Bounty
463     }
464 
465     // 1 buy = 1 slot = _ethAmount => (tAmount, tMul) 
466     struct Slot {
467         address buyer;
468         uint256 rId;
469         // ticket numbers in range and unique in all rounds
470         uint256 tNumberFrom;
471         uint256 tNumberTo;
472         // weight to, used for grandPot finalize
473         uint256 wTo;
474         uint256 ethAmount;
475         uint256 salt;
476     }
477 
478     struct Round {
479         // earlyIncome weight sum
480         uint256 rEarlyIncomeWeight;
481         // blockNumber to get hash as random seed
482         uint256 keyBlockNr;
483         
484         mapping(address => uint256) pTicketSum;
485         mapping(address => uint256) pInvestedSum;
486 
487         // early income weight by address
488         mapping(address => uint256) pEarlyIncomeWeight;
489         mapping(address => uint256) pEarlyIncomeCredit;
490         mapping(address => uint256) pEarlyIncomeClaimed;
491         // early income per weight
492         uint256 ppw;
493         // endTime increased every slot sold
494         // endTime limited by fixedEndTime
495         uint256 startTime;
496         uint256 slideEndTime;
497         uint256 fixedEndTime;
498 
499         // ticketSum from round 1 to this round
500         uint256 ticketSum;
501         // investedSum from round 1 to this round
502         uint256 investedSum;
503         // number of slots from round 1 to this round
504         uint256 slotSum;
505     }
506 
507     // round started with this grandPot amount,
508     // used to calculate the rate for grandPot results
509     // init in roundInit function
510     uint256 initGrandPot;
511 
512     Slot[] slot;
513     // slotId logs by address
514     mapping( address => uint256[]) pSlot;
515     mapping( address => uint256) public pSlotSum;
516 
517     // logs by address
518     mapping( address => uint256) public pTicketSum;
519     mapping( address => uint256) public pInvestedSum;
520 
521     CitizenInterface public citizenContract;
522     F2mInterface public f2mContract;
523     BankInterface public bankContract;
524     RewardInterface public rewardContract;
525 
526     address public devTeam;
527 
528     uint256 constant public ZOOM = 1000;
529     uint256 constant public ONE_HOUR = 60 * 60;
530     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
531     uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
532     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
533     uint256 constant public TIMEOUT2 = 7 * ONE_DAY;
534     uint256 constant public FINALIZE_WAIT_DURATION = 60; // 60 Seconds
535     uint256 constant public NEWROUND_WAIT_DURATION = ONE_DAY; // 24 Hours
536 
537     // 15 seconds on Ethereum, 12 seconds used instead to make sure blockHash unavaiable
538     // when slideEndTime reached
539     // keyBlockNumber will be estimated again after every slot buy
540     uint256 constant public BLOCK_TIME = 12;
541     uint256 constant public MAX_BLOCK_DISTANCE = 254;
542 
543     uint256 constant public MAJOR_RATE = 1000;
544     uint256 constant public MINOR_RATE = 1000;
545     uint256 constant public MAJOR_MIN = 0.1 ether ;
546     uint256 constant public MINOR_MIN = 0.1 ether ;
547 
548     //uint256 public toNextPotPercent = 27;
549     uint256 public grandRewardPercent = 20;
550     uint256 public jRewardPercent = 60;
551 
552     uint256 public toTokenPercent = 12; // 10% dividends 2% fund
553     uint256 public toBuyTokenPercent = 1;
554     uint256 public earlyIncomePercent = 22;
555     uint256 public toRefPercent = 15;
556 
557     // sum == 100% = toPotPercent/100 * investedSum
558     // uint256 public grandPercent = 68;
559     uint256 public majorPercent = 24;
560     uint256 public minorPercent = 8;
561 
562     uint256 public grandPot;
563     uint256 public majorPot;
564     uint256 public minorPot;
565 
566     uint256 public curRoundId;
567     uint256 public lastRoundId = 88888888;
568 
569     uint256 constant public startPrice = 0.002 ether;
570 
571     mapping (address => uint256) public rewardBalance;
572     // used to save gas on earlyIncome calculating, curRoundId never included
573     // only earlyIncome from round 1st to curRoundId-1 are fixed
574     mapping (address => uint256) public lastWithdrawnRound;
575     mapping (address => uint256) public earlyIncomeScannedSum;
576 
577     mapping (uint256 => Round) public round;
578 
579     // Current Round
580 
581     // first SlotId in last Block to fire jackpot
582     uint256 public jSlot;
583     // jackpot results of all slots in same block will be drawed at the same time,
584     // by player, who buys the first slot in next block
585     uint256 public lastBlockNr;
586     // used to calculate grandPot results
587     uint256 public curRWeight;
588     // added by slot salt after every slot buy
589     // does not matter with overflow
590     uint256 public curRSalt;
591     // ticket sum of current round
592     uint256 public curRTicketSum;
593 
594     constructor (address _devTeam)
595         public
596     {
597         // register address in network
598         DevTeamInterface(_devTeam).setLotteryAddress(address(this));
599         devTeam = _devTeam;
600     }
601 
602     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
603     function joinNetwork(address[6] _contract)
604         public
605     {
606         require(address(citizenContract) == 0x0,"already setup");
607         f2mContract = F2mInterface(_contract[0]);
608         bankContract = BankInterface(_contract[1]);
609         citizenContract = CitizenInterface(_contract[2]);
610         //lotteryContract = LotteryInterface(lotteryAddress);
611         rewardContract = RewardInterface(_contract[4]);
612     }
613 
614     function activeFirstRound()
615         public
616         onlyDevTeam()
617     {
618         require(curRoundId == 0, "already activated");
619         initRound();
620     }
621 
622     // Core Functions
623 
624     function pushToPot() 
625         public 
626         payable
627     {
628         addPot(msg.value);
629     }
630 
631     function checkpoint() 
632         private
633     {
634         // dummy slot between every 2 rounds
635         // dummy slot never win jackpot cause of min 0.1 ETH
636         Slot memory _slot;
637         _slot.tNumberTo = round[curRoundId].ticketSum;
638         slot.push(_slot);
639 
640         Round memory _round;
641         _round.startTime = NEWROUND_WAIT_DURATION.add(block.timestamp);
642         // started with 3 hours timeout
643         _round.slideEndTime = TIMEOUT0 + _round.startTime;
644         _round.fixedEndTime = TIMEOUT2 + _round.startTime;
645         _round.keyBlockNr = genEstKeyBlockNr(_round.slideEndTime);
646         _round.ticketSum = round[curRoundId].ticketSum;
647         _round.investedSum = round[curRoundId].investedSum;
648         _round.slotSum = slot.length;
649 
650         curRoundId = curRoundId + 1;
651         round[curRoundId] = _round;
652 
653         initGrandPot = grandPot;
654         curRWeight = 0;
655         curRTicketSum = 0;
656     }
657 
658     // from round 18+ function
659     function isLastRound()
660         public
661         view
662         returns(bool)
663     {
664         return (curRoundId == lastRoundId);
665     }
666 
667     function goNext()
668         private
669     {
670         uint256 _totalPot = getTotalPot();
671         grandPot = 0;
672         majorPot = 0;
673         minorPot = 0;
674         f2mContract.pushDividends.value(_totalPot)();
675         // never start
676         round[curRoundId].startTime = block.timestamp * 10;
677         round[curRoundId].slideEndTime = block.timestamp * 10 + 1;
678     }
679 
680     function initRound()
681         private
682     {
683         // update all Round Log
684         checkpoint();
685         if (isLastRound()) goNext();
686     }
687 
688     function finalizeable() 
689         public
690         view
691         returns(bool)
692     {
693         uint256 finalizeTime = FINALIZE_WAIT_DURATION.add(round[curRoundId].slideEndTime);
694         if (finalizeTime > block.timestamp) return false; // too soon to finalize
695         if (getEstKeyBlockNr(curRoundId) >= block.number) return false; //block hash not exist
696         return curRoundId > 0;
697     }
698 
699     // bounty
700     function finalize()
701         public
702     {
703         require(finalizeable(), "Not ready to draw results");
704         // avoid txs blocked => curRTicket ==0 => die
705         require((round[curRoundId].pTicketSum[msg.sender] > 0) || (curRTicketSum == 0), "must buy at least 1 ticket");
706         endRound(msg.sender);
707         initRound();
708     }
709 
710     function mintReward(
711         address _lucker,
712         uint256 _slotId,
713         uint256 _value,
714         RewardType _rewardType)
715         private
716     {
717         // add reward balance
718         rewardBalance[_lucker] = rewardBalance[_lucker].add(_value);
719         // reward log
720         rewardContract.mintReward(
721             _lucker,
722             curRoundId,
723             slot[_slotId].tNumberFrom,
724             slot[_slotId].tNumberTo,
725             _value,
726             uint256(_rewardType)
727         );
728     }
729 
730     function jackpot()
731         private
732     {
733         // get blocknumber to get blockhash
734         uint256 keyBlockNr = getKeyBlockNr(lastBlockNr);//block.number;
735         // salt not effected by jackpot, too risk
736         uint256 seed = getSeed(keyBlockNr);
737         // slot numberic from 1 ... totalSlot(round)
738         // jackpot for all slot in last block, jSlot <= i <= lastSlotId (=slotSum - 1)
739         // _to = first Slot in new block
740         //uint256 _to = round[curRoundId].slotSum;
741 
742         uint256 jReward;
743         uint256 toF2mAmount;
744         address winner;
745         // jackpot check for slots in last block
746         while (jSlot + 1 < round[curRoundId].slotSum) {
747             // majorPot
748             if ((seed % MAJOR_RATE == 6) &&
749                 (slot[jSlot].ethAmount >= MAJOR_MIN)) {
750 
751                 winner = slot[jSlot].buyer;
752                 jReward = majorPot / 100 * jRewardPercent;
753                 mintReward(winner, jSlot, jReward, RewardType.Major);
754                 toF2mAmount = majorPot / 100 * toTokenPercent;
755                 f2mContract.pushDividends.value(toF2mAmount)();
756                 majorPot = majorPot - jReward - toF2mAmount;
757             }
758 
759             // minorPot
760             if (((seed + jSlot) % MINOR_RATE == 8) && 
761                 (slot[jSlot].ethAmount >= MINOR_MIN)) {
762 
763                 winner = slot[jSlot].buyer;
764                 jReward = minorPot / 100 * jRewardPercent;
765                 mintReward(winner, jSlot, jReward, RewardType.Minor);
766                 toF2mAmount = minorPot / 100 * toTokenPercent;
767                 f2mContract.pushDividends.value(toF2mAmount)();
768                 minorPot = minorPot - jReward - toF2mAmount;
769             }
770             seed = seed + 1;
771             jSlot = jSlot + 1;
772         }
773     }
774 
775     function endRound(address _bountyHunter)
776         private
777     {
778         uint256 _rId = curRoundId;
779         uint256 keyBlockNr = getKeyBlockNr(round[_rId].keyBlockNr);
780         uint256 _seed = getSeed(keyBlockNr) + curRSalt;
781         uint256 onePercent = grandPot / 100;
782         uint256 rGrandReward = onePercent * grandRewardPercent;
783 
784         //PUSH DIVIDENDS
785         uint256 toF2mAmount = onePercent * toTokenPercent;
786         //uint256 _bountyAmount = onePercent * bountyPercent;
787         
788         grandPot = grandPot - toF2mAmount - onePercent;
789         f2mContract.pushDividends.value(toF2mAmount)();
790 
791         // base on grand-intestedSum current grandPot
792         uint256 weightRange = getWeightRange();
793 
794         // roll 3 turns
795         for (uint256 i = 0; i < 3; i++){
796             uint256 winNr = Helper.getRandom(_seed, weightRange);
797             // if winNr > curRoundWeight => no winner this turn
798             // win Slot : fromWeight <= winNr <= toWeight
799             // got winner this rolling turn
800             if (winNr <= curRWeight) {
801                 grandPot -= rGrandReward;
802                 uint256 _winSlot = getWinSlot(winNr);
803                 address _winner = slot[_winSlot].buyer;
804                 mintReward(_winner, _winSlot, rGrandReward, RewardType.Grand);
805                 _seed = _seed + (_seed / 10);
806             }
807         }
808         mintReward(_bountyHunter, 0, onePercent * 3 / 10, RewardType.Bounty);
809         rewardContract.pushBounty.value(onePercent * 7 / 10)(curRoundId);
810     }
811 
812     function buy(string _sSalt)
813         public
814         payable
815     {
816         buyFor(_sSalt, msg.sender);
817     }
818 
819     function updateInvested(address _buyer, uint256 _ethAmount)
820         private
821     {
822         round[curRoundId].investedSum += _ethAmount;
823         round[curRoundId].pInvestedSum[_buyer] += _ethAmount;
824         pInvestedSum[_buyer] += _ethAmount;
825     }
826 
827     function updateTicketSum(address _buyer, uint256 _tAmount)
828         private
829     {
830         round[curRoundId].ticketSum = round[curRoundId].ticketSum + _tAmount;
831         round[curRoundId].pTicketSum[_buyer] = round[curRoundId].pTicketSum[_buyer] + _tAmount;
832         curRTicketSum = curRTicketSum + _tAmount;
833         pTicketSum[_buyer] = pTicketSum[_buyer] + _tAmount;
834     }
835 
836     function updateEarlyIncome(address _buyer, uint256 _pWeight)
837         private
838     {
839         round[curRoundId].rEarlyIncomeWeight = _pWeight.add(round[curRoundId].rEarlyIncomeWeight);
840         round[curRoundId].pEarlyIncomeWeight[_buyer] = _pWeight.add(round[curRoundId].pEarlyIncomeWeight[_buyer]);
841         round[curRoundId].pEarlyIncomeCredit[_buyer] = round[curRoundId].pEarlyIncomeCredit[_buyer].add(_pWeight.mul(round[curRoundId].ppw));
842     }
843 
844     function buyFor(string _sSalt, address _sender) 
845         public
846         payable
847         buyable()
848     {
849         uint256 _salt = Helper.stringToUint(_sSalt);
850         uint256 _ethAmount = msg.value;
851         uint256 _ticketSum = curRTicketSum;
852         require(_ethAmount >= Helper.getTPrice(_ticketSum), "not enough to buy 1 ticket");
853 
854         // investedSum logs
855         updateInvested(_sender, _ethAmount);
856         // update salt
857         curRSalt = curRSalt + _salt;
858         // init new Slot, Slot Id = 1..curRSlotSum
859         Slot memory _slot;
860         _slot.rId = curRoundId;
861         _slot.buyer = _sender;
862         _slot.ethAmount = _ethAmount;
863         _slot.salt = _salt;
864         uint256 _tAmount = Helper.getTAmount(_ethAmount, _ticketSum);
865         uint256 _tMul = Helper.getTMul(_ticketSum);
866         uint256 _pMul = Helper.getEarlyIncomeMul(_ticketSum);
867         uint256 _pWeight = _pMul.mul(_tAmount);
868         uint256 _toAddTime = Helper.getAddedTime(_ticketSum, _tAmount);
869         addTime(curRoundId, _toAddTime);
870 
871         // update weight
872         uint256 _slotWeight = (_tAmount).mul(_tMul);
873         curRWeight = curRWeight.add(_slotWeight);
874         _slot.wTo = curRWeight;
875         uint256 lastSlot = slot.length - 1;
876         // update ticket params
877         _slot.tNumberFrom = slot[lastSlot].tNumberTo + 1;
878         _slot.tNumberTo = slot[lastSlot].tNumberTo + _tAmount;
879         updateTicketSum(_sender, _tAmount);
880 
881         // EarlyIncome Weight
882         // ppw and credit zoomed x1000
883         // earlyIncome mul of each ticket in this slot
884         updateEarlyIncome(_sender, _pWeight);
885      
886         // add Slot and update round data
887         slot.push(_slot);
888         round[curRoundId].slotSum = slot.length;
889         // add slot to player logs
890         pSlot[_sender].push(slot.length - 1);
891 
892         // first slot in this block draw jacpot results for 
893         // all slot in last block
894         if (lastBlockNr != block.number) {
895             jackpot();
896             lastBlockNr = block.number;
897         }
898 
899         distributeSlotBuy(_sender, curRoundId, _ethAmount);
900 
901         round[curRoundId].keyBlockNr = genEstKeyBlockNr(round[curRoundId].slideEndTime);
902     }
903 
904     function distributeSlotBuy(address _sender, uint256 _rId, uint256 _ethAmount)
905         private
906     {
907         uint256 onePercent = _ethAmount / 100;
908         uint256 toF2mAmount = onePercent * toTokenPercent; // 12
909         uint256 toRefAmount = onePercent * toRefPercent; // 10
910         uint256 toBuyTokenAmount = onePercent * toBuyTokenPercent; //1
911         uint256 earlyIncomeAmount = onePercent * earlyIncomePercent; //27
912         uint256 taxAmount = toF2mAmount + toRefAmount + toBuyTokenAmount + earlyIncomeAmount; // 50
913         uint256 taxedEthAmount = _ethAmount.sub(taxAmount); // 50
914         addPot(taxedEthAmount);
915         
916         // 10% Ref
917         citizenContract.pushRefIncome.value(toRefAmount)(_sender);
918         // 2% Fund + 10% Dividends 
919         f2mContract.pushDividends.value(toF2mAmount)();
920         // 1% buy Token
921         f2mContract.buyFor.value(toBuyTokenAmount)(_sender);
922         // 27% Early
923         uint256 deltaPpw = (earlyIncomeAmount * ZOOM).div(round[_rId].rEarlyIncomeWeight);
924         round[_rId].ppw = deltaPpw.add(round[_rId].ppw);
925     }
926 
927     function claimEarlyIncomebyAddress(address _buyer)
928         private
929     {
930         if (curRoundId == 0) return;
931         claimEarlyIncomebyAddressRound(_buyer, curRoundId);
932         uint256 _rId = curRoundId - 1;
933         while ((_rId > lastWithdrawnRound[_buyer]) && (_rId + 20 > curRoundId)) {
934             earlyIncomeScannedSum[_buyer] += claimEarlyIncomebyAddressRound(_buyer, _rId);
935             _rId = _rId - 1;
936         }
937     }
938 
939     function claimEarlyIncomebyAddressRound(address _buyer, uint256 _rId)
940         private
941         returns(uint256)
942     {
943         uint256 _amount = getCurEarlyIncomeByAddressRound(_buyer, _rId);
944         if (_amount == 0) return 0;
945         round[_rId].pEarlyIncomeClaimed[_buyer] = _amount.add(round[_rId].pEarlyIncomeClaimed[_buyer]);
946         rewardBalance[_buyer] = _amount.add(rewardBalance[_buyer]);
947         return _amount;
948     }
949 
950     function withdrawFor(address _sender)
951         public
952         withdrawRight()
953         returns(uint256)
954     {
955         if (curRoundId == 0) return;
956         claimEarlyIncomebyAddress(_sender);
957         lastWithdrawnRound[_sender] = curRoundId - 1;
958         uint256 _amount = rewardBalance[_sender];
959         rewardBalance[_sender] = 0;
960         bankContract.pushToBank.value(_amount)(_sender);
961         return _amount;
962     }
963     
964     function addTime(uint256 _rId, uint256 _toAddTime)
965         private
966     {
967         round[_rId].slideEndTime = Helper.getNewEndTime(_toAddTime, round[_rId].slideEndTime, round[_rId].fixedEndTime);
968     }
969 
970     // distribute to 3 pots Grand, Majorm Minor
971     function addPot(uint256 _amount)
972         private
973     {
974         uint256 onePercent = _amount / 100;
975         uint256 toMinor = onePercent * minorPercent;
976         uint256 toMajor = onePercent * majorPercent;
977         uint256 toGrand = _amount - toMinor - toMajor;
978 
979         minorPot = minorPot + toMinor;
980         majorPot = majorPot + toMajor;
981         grandPot = grandPot + toGrand;
982     }
983 
984 
985     //////////////////////////////////////////////////////////////////
986     // READ FUNCTIONS
987     //////////////////////////////////////////////////////////////////
988 
989     function isWinSlot(uint256 _slotId, uint256 _keyNumber)
990         public
991         view
992         returns(bool)
993     {
994         return (slot[_slotId - 1].wTo < _keyNumber) && (slot[_slotId].wTo >= _keyNumber);
995     }
996 
997     function getWeightRange()
998         public
999         view
1000         returns(uint256)
1001     {
1002         return Helper.getWeightRange(grandPot, initGrandPot, curRWeight);
1003     }
1004 
1005     function getWinSlot(uint256 _keyNumber)
1006         public
1007         view
1008         returns(uint256)
1009     {
1010         // return 0 if not found
1011         uint256 _to = slot.length - 1;
1012         uint256 _from = round[curRoundId-1].slotSum + 1; // dummy slot ignore
1013         uint256 _pivot;
1014         //Slot memory _slot;
1015         uint256 _pivotWTo;
1016         // Binary search
1017         while (_from <= _to) {
1018             _pivot = (_from + _to) / 2;
1019             //_slot = round[_rId].slot[_pivot];
1020             _pivotWTo = slot[_pivot].wTo;
1021             if (isWinSlot(_pivot, _keyNumber)) return _pivot;
1022             if (_pivotWTo < _keyNumber) { // in right side
1023                 _from = _pivot + 1;
1024             } else { // in left side
1025                 _to = _pivot - 1;
1026             }
1027         }
1028         return _pivot; // never happens or smt gone wrong
1029     }
1030 
1031     // Key Block in future
1032     function genEstKeyBlockNr(uint256 _endTime) 
1033         public
1034         view
1035         returns(uint256)
1036     {
1037         if (block.timestamp >= _endTime) return block.number + 8; 
1038         uint256 timeDist = _endTime - block.timestamp;
1039         uint256 estBlockDist = timeDist / BLOCK_TIME;
1040         return block.number + estBlockDist + 8;
1041     }
1042 
1043     // get block hash of first block with blocktime > _endTime
1044     function getSeed(uint256 _keyBlockNr)
1045         public
1046         view
1047         returns (uint256)
1048     {
1049         // Key Block not mined atm
1050         if (block.number <= _keyBlockNr) return block.number;
1051         return uint256(blockhash(_keyBlockNr));
1052     }
1053 
1054     // current reward balance
1055     function getRewardBalance(address _buyer)
1056         public
1057         view
1058         returns(uint256)
1059     {
1060         return rewardBalance[_buyer];
1061     } 
1062 
1063     // GET endTime
1064     function getSlideEndTime(uint256 _rId)
1065         public
1066         view
1067         returns(uint256)
1068     {
1069         return(round[_rId].slideEndTime);
1070     }
1071 
1072     function getFixedEndTime(uint256 _rId)
1073         public
1074         view
1075         returns(uint256)
1076     {
1077         return(round[_rId].fixedEndTime);
1078     }
1079 
1080     function getTotalPot()
1081         public
1082         view
1083         returns(uint256)
1084     {
1085         return grandPot + majorPot + minorPot;
1086     }
1087 
1088     // EarlyIncome
1089     function getEarlyIncomeByAddress(address _buyer)
1090         public
1091         view
1092         returns(uint256)
1093     {
1094         uint256 _sum = earlyIncomeScannedSum[_buyer];
1095         uint256 _fromRound = lastWithdrawnRound[_buyer] + 1; // >=1
1096         if (_fromRound + 100 < curRoundId) _fromRound = curRoundId - 100;
1097         uint256 _rId = _fromRound;
1098         while (_rId <= curRoundId) {
1099             _sum = _sum + getEarlyIncomeByAddressRound(_buyer, _rId);
1100             _rId++;
1101         }
1102         return _sum;
1103     }
1104 
1105     // included claimed amount
1106     function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId)
1107         public
1108         view
1109         returns(uint256)
1110     {
1111         uint256 _pWeight = round[_rId].pEarlyIncomeWeight[_buyer];
1112         uint256 _ppw = round[_rId].ppw;
1113         uint256 _rCredit = round[_rId].pEarlyIncomeCredit[_buyer];
1114         uint256 _rEarlyIncome = ((_ppw.mul(_pWeight)).sub(_rCredit)).div(ZOOM);
1115         return _rEarlyIncome;
1116     }
1117 
1118     function getCurEarlyIncomeByAddress(address _buyer)
1119         public
1120         view
1121         returns(uint256)
1122     {
1123         uint256 _sum = 0;
1124         uint256 _fromRound = lastWithdrawnRound[_buyer] + 1; // >=1
1125         if (_fromRound + 100 < curRoundId) _fromRound = curRoundId - 100;
1126         uint256 _rId = _fromRound;
1127         while (_rId <= curRoundId) {
1128             _sum = _sum.add(getCurEarlyIncomeByAddressRound(_buyer, _rId));
1129             _rId++;
1130         }
1131         return _sum;
1132     }
1133 
1134     function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId)
1135         public
1136         view
1137         returns(uint256)
1138     {
1139         uint256 _rEarlyIncome = getEarlyIncomeByAddressRound(_buyer, _rId);
1140         return _rEarlyIncome.sub(round[_rId].pEarlyIncomeClaimed[_buyer]);
1141     }
1142 
1143     ////////////////////////////////////////////////////////////////////
1144 
1145     function getEstKeyBlockNr(uint256 _rId)
1146         public
1147         view
1148         returns(uint256)
1149     {
1150         return round[_rId].keyBlockNr;
1151     }
1152 
1153     function getKeyBlockNr(uint256 _estKeyBlockNr)
1154         public
1155         view
1156         returns(uint256)
1157     {
1158         require(block.number > _estKeyBlockNr, "blockHash not avaiable");
1159         uint256 jump = (block.number - _estKeyBlockNr) / MAX_BLOCK_DISTANCE * MAX_BLOCK_DISTANCE;
1160         return _estKeyBlockNr + jump;
1161     }
1162 
1163     // Logs
1164     function getCurRoundId()
1165         public
1166         view
1167         returns(uint256)
1168     {
1169         return curRoundId;
1170     }
1171 
1172     function getTPrice()
1173         public
1174         view
1175         returns(uint256)
1176     {
1177         return Helper.getTPrice(curRTicketSum);
1178     }
1179 
1180     function getTMul()
1181         public
1182         view
1183         returns(uint256)
1184     {
1185         return Helper.getTMul(curRTicketSum);
1186     }
1187 
1188     function getPMul()
1189         public
1190         view
1191         returns(uint256)
1192     {
1193         return Helper.getEarlyIncomeMul(curRTicketSum);
1194     }
1195 
1196     function getPTicketSumByRound(uint256 _rId, address _buyer)
1197         public
1198         view
1199         returns(uint256)
1200     {
1201         return round[_rId].pTicketSum[_buyer];
1202     }
1203 
1204     function getTicketSumToRound(uint256 _rId)
1205         public
1206         view
1207         returns(uint256)
1208     {
1209         return round[_rId].ticketSum;
1210     }
1211 
1212     function getPInvestedSumByRound(uint256 _rId, address _buyer)
1213         public
1214         view
1215         returns(uint256)
1216     {
1217         return round[_rId].pInvestedSum[_buyer];
1218     }
1219 
1220     function getInvestedSumToRound(uint256 _rId)
1221         public
1222         view
1223         returns(uint256)
1224     {
1225         return round[_rId].investedSum;
1226     }
1227 
1228     function getPSlotLength(address _sender)
1229         public
1230         view
1231         returns(uint256)
1232     {
1233         return pSlot[_sender].length;
1234     }
1235 
1236     function getSlotLength()
1237         public
1238         view
1239         returns(uint256)
1240     {
1241         return slot.length;
1242     }
1243 
1244     function getSlotId(address _sender, uint256 i)
1245         public
1246         view
1247         returns(uint256)
1248     {
1249         return pSlot[_sender][i];
1250     }
1251 
1252     function getSlotInfo(uint256 _slotId)
1253         public
1254         view
1255         returns(address, uint256[4], string)
1256     {
1257         Slot memory _slot = slot[_slotId];
1258         return (_slot.buyer,[_slot.rId, _slot.tNumberFrom, _slot.tNumberTo, _slot.ethAmount], Helper.uintToString(_slot.salt));
1259     }
1260 
1261     function cashoutable(address _address) 
1262         public
1263         view
1264         returns(bool)
1265     {
1266         // need 1 ticket or in waiting time to start new round
1267         return (round[curRoundId].pTicketSum[_address] > 0) || (round[curRoundId].startTime > block.timestamp);
1268     }
1269 
1270     // set endRound, prepare to upgrade new version
1271     function setLastRound(uint256 _lastRoundId) 
1272         public
1273         onlyDevTeam()
1274     {
1275         require(_lastRoundId >= 18 && _lastRoundId > curRoundId, "too early to end");
1276         require(lastRoundId == 88888888, "already set");
1277         lastRoundId = _lastRoundId;
1278     }
1279 }