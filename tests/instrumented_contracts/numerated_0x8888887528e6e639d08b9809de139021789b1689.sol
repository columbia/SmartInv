1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier - Full Stack Blockchain Developer
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 contract Reward {
10     using SafeMath for uint256;
11 
12     event NewReward(address indexed _lucker, uint256[5] _info);
13     
14     modifier onlyOwner() {
15         require(msg.sender == address(lotteryContract), "This is just log for lottery contract");
16         _;
17     }
18 
19     modifier claimable() {
20         require(
21             rest > 1 && 
22             block.number > lastBlock &&
23             lastRoundClaim[msg.sender] < lastRoundId,
24             "out of stock in this round, block or already claimed");
25         _;
26     }
27 
28 /*     
29     enum RewardType {
30         Minor, 0
31         Major, 1
32         Grand, 2
33         Bounty 3
34         SBounty 4 // smal bounty
35     } 
36 */
37 
38     struct Rewards {
39         address lucker;
40         uint256 time;
41         uint256 rId;
42         uint256 value;
43         uint256 winNumber;
44         uint256 rewardType;
45     }
46 
47     Rewards[] public rewardList;
48     // reward array by address
49     mapping( address => uint256[]) public pReward;
50     // reward sum by address
51     mapping( address => uint256) public pRewardedSum;
52     // reward sum by address, round
53     mapping( address => mapping(uint256 => uint256)) public pRewardedSumPerRound;
54     // reward sum by round
55     mapping( uint256 => uint256) public rRewardedSum;
56     // reward sum all round, all addresses
57     uint256 public rewardedSum;
58     
59     // last claimed round by address to check timeout
60     // timeout balance will be pushed to dividends
61     mapping(address => uint256) lastRoundClaim;
62 
63     LotteryInterface lotteryContract;
64 
65     //////////////////////////////////////////////////////////
66     
67     // rest times for sBounty, small bountys free for all (round-players) after each round
68     uint256 public rest = 0;
69     // last block that sBounty claimed, to prevent 2 time claimed in same block
70     uint256 public lastBlock = 0;
71     // sBounty will be saved in logs of last round
72     // new round will be started after sBountys pushed
73     uint256 public lastRoundId;
74 
75     constructor (address _devTeam)
76         public
77     {
78         // register address in network
79         DevTeamInterface(_devTeam).setRewardAddress(address(this));
80     }
81 
82     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
83     function joinNetwork(address[6] _contract)
84         public
85     {
86         require((address(lotteryContract) == 0x0),"already setup");
87         lotteryContract = LotteryInterface(_contract[3]);
88     }
89 
90     // sBounty program
91     // rules :
92     // 1. accept only calls from lottery contract
93     // 2. one claim per block
94     // 3. one claim per address (reset each round)
95 
96     function getSBounty()
97         public
98         view
99         returns(uint256, uint256, uint256)
100     {
101         uint256 sBountyAmount = rest < 2 ? 0 : address(this).balance / (rest-1);
102         return (rest, sBountyAmount, lastRoundId);
103     }
104 
105     // pushed from lottery contract only
106     function resetCounter(uint256 _curRoundId) 
107         public 
108         onlyOwner() 
109     {
110         rest = 8;
111         lastBlock = block.number;
112         lastRoundId = _curRoundId;
113     }
114 
115     function claim()
116         public
117         claimable()
118     {
119         address _sender = msg.sender;
120         lastBlock = block.number;
121         lastRoundClaim[_sender] = lastRoundId;
122         rest = rest - 1;
123         uint256 claimAmount = lotteryContract.sBountyClaim(_sender);
124         mintRewardCore(
125             _sender,
126             lastRoundId,
127             0,
128             0,
129             0,
130             claimAmount,
131             4
132         );
133     }
134 
135     // rewards sealed by lottery contract
136     function mintReward(
137         address _lucker,
138         uint256 _curRoundId,
139         uint256 _winNr,
140         uint256 _tNumberFrom,
141         uint256 _tNumberTo,
142         uint256 _value,
143         uint256 _rewardType)
144         public
145         onlyOwner()
146     {
147         mintRewardCore(
148             _lucker,
149             _curRoundId,
150             _winNr,
151             _tNumberFrom,
152             _tNumberTo,
153             _value,
154             _rewardType);
155     }
156 
157     // reward logs generator
158     function mintRewardCore(
159         address _lucker,
160         uint256 _curRoundId,
161         uint256 _winNr,
162         uint256 _tNumberFrom,
163         uint256 _tNumberTo,
164         uint256 _value,
165         uint256 _rewardType)
166         private
167     {
168         Rewards memory _reward;
169         _reward.lucker = _lucker;
170         _reward.time = block.timestamp;
171         _reward.rId = _curRoundId;
172         _reward.value = _value;
173 
174         // get winning number if rewardType is not bounty or sBounty
175         // seed = rewardList.length to be sure that seed changed after
176         // every reward minting
177         if (_winNr > 0) {
178             _reward.winNumber = _winNr;
179         } else 
180         if (_rewardType < 3)
181             _reward.winNumber = getWinNumberBySlot(_tNumberFrom, _tNumberTo);
182 
183         _reward.rewardType = _rewardType;
184         rewardList.push(_reward);
185         pReward[_lucker].push(rewardList.length - 1);
186         // reward sum logs
187         pRewardedSum[_lucker] += _value;
188         rRewardedSum[_curRoundId] += _value;
189         rewardedSum += _value;
190         pRewardedSumPerRound[_lucker][_curRoundId] += _value;
191         emit NewReward(_reward.lucker, [_reward.time, _reward.rId, _reward.value, _reward.winNumber, uint256(_reward.rewardType)]);
192     }
193 
194     function getWinNumberBySlot(uint256 _tNumberFrom, uint256 _tNumberTo)
195         public
196         view
197         returns(uint256)
198     {
199         //uint256 _seed = uint256(keccak256(rewardList.length));
200         uint256 _seed = rewardList.length * block.number + block.timestamp;
201         // get random number in range (1, _to - _from + 1)
202         uint256 _winNr = Helper.getRandom(_seed, _tNumberTo + 1 - _tNumberFrom);
203         return _tNumberFrom + _winNr - 1;
204     }
205 
206     function getPRewardLength(address _sender)
207         public
208         view
209         returns(uint256)
210     {
211         return pReward[_sender].length;
212     }
213 
214     function getRewardListLength()
215         public
216         view
217         returns(uint256)
218     {
219         return rewardList.length;
220     }
221 
222     function getPRewardId(address _sender, uint256 i)
223         public
224         view
225         returns(uint256)
226     {
227         return pReward[_sender][i];
228     }
229 
230     function getPRewardedSumByRound(uint256 _rId, address _buyer)
231         public
232         view
233         returns(uint256)
234     {
235         return pRewardedSumPerRound[_buyer][_rId];
236     }
237 
238     function getRewardedSumByRound(uint256 _rId)
239         public
240         view
241         returns(uint256)
242     {
243         return rRewardedSum[_rId];
244     }
245 
246     function getRewardInfo(uint256 _id)
247         public
248         view
249         returns(
250             address,
251             uint256,
252             uint256,
253             uint256,
254             uint256,
255             uint256
256         )
257     {
258         Rewards memory _reward = rewardList[_id];
259         return (
260             _reward.lucker,
261             _reward.winNumber,
262             _reward.time,
263             _reward.rId,
264             _reward.value,
265             _reward.rewardType
266         );
267     }
268 }
269 
270 library Helper {
271     using SafeMath for uint256;
272 
273     uint256 constant public ZOOM = 1000;
274     uint256 constant public SDIVIDER = 3450000;
275     uint256 constant public PDIVIDER = 3450000;
276     uint256 constant public RDIVIDER = 1580000;
277     // Starting LS price (SLP)
278     uint256 constant public SLP = 0.002 ether;
279     // Starting Added Time (SAT)
280     uint256 constant public SAT = 30; // seconds
281     // Price normalization (PN)
282     uint256 constant public PN = 777;
283     // EarlyIncome base
284     uint256 constant public PBASE = 13;
285     uint256 constant public PMULTI = 26;
286     uint256 constant public LBase = 1;
287 
288     uint256 constant public ONE_HOUR = 3600;
289     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
290     //uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
291     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
292     uint256 constant public TIMEOUT2 = 7 * ONE_DAY;
293     
294     function bytes32ToString (bytes32 data)
295         public
296         pure
297         returns (string) 
298     {
299         bytes memory bytesString = new bytes(32);
300         for (uint j=0; j<32; j++) {
301             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
302             if (char != 0) {
303                 bytesString[j] = char;
304             }
305         }
306         return string(bytesString);
307     }
308     
309     function uintToBytes32(uint256 n)
310         public
311         pure
312         returns (bytes32) 
313     {
314         return bytes32(n);
315     }
316     
317     function bytes32ToUint(bytes32 n) 
318         public
319         pure
320         returns (uint256) 
321     {
322         return uint256(n);
323     }
324     
325     function stringToBytes32(string memory source) 
326         public
327         pure
328         returns (bytes32 result) 
329     {
330         bytes memory tempEmptyStringTest = bytes(source);
331         if (tempEmptyStringTest.length == 0) {
332             return 0x0;
333         }
334 
335         assembly {
336             result := mload(add(source, 32))
337         }
338     }
339     
340     function stringToUint(string memory source) 
341         public
342         pure
343         returns (uint256)
344     {
345         return bytes32ToUint(stringToBytes32(source));
346     }
347     
348     function uintToString(uint256 _uint) 
349         public
350         pure
351         returns (string)
352     {
353         return bytes32ToString(uintToBytes32(_uint));
354     }
355 
356 /*     
357     function getSlice(uint256 begin, uint256 end, string text) public pure returns (string) {
358         bytes memory a = new bytes(end-begin+1);
359         for(uint i = 0; i <= end - begin; i++){
360             a[i] = bytes(text)[i + begin - 1];
361         }
362         return string(a);    
363     }
364  */
365     function validUsername(string _username)
366         public
367         pure
368         returns(bool)
369     {
370         uint256 len = bytes(_username).length;
371         // Im Raum [4, 18]
372         if ((len < 4) || (len > 18)) return false;
373         // Letzte Char != ' '
374         if (bytes(_username)[len-1] == 32) return false;
375         // Erste Char != '0'
376         return uint256(bytes(_username)[0]) != 48;
377     }
378 
379     // Lottery Helper
380 
381     // Seconds added per LT = SAT - ((Current no. of LT + 1) / SDIVIDER)^6
382     function getAddedTime(uint256 _rTicketSum, uint256 _tAmount)
383         public
384         pure
385         returns (uint256)
386     {
387         //Luppe = 10000 = 10^4
388         uint256 base = (_rTicketSum + 1).mul(10000) / SDIVIDER;
389         uint256 expo = base;
390         expo = expo.mul(expo).mul(expo); // ^3
391         expo = expo.mul(expo); // ^6
392         // div 10000^6
393         expo = expo / (10**24);
394 
395         if (expo > SAT) return 0;
396         return (SAT - expo).mul(_tAmount);
397     }
398 
399     function getNewEndTime(uint256 toAddTime, uint256 slideEndTime, uint256 fixedEndTime)
400         public
401         view
402         returns(uint256)
403     {
404         uint256 _slideEndTime = (slideEndTime).add(toAddTime);
405         uint256 timeout = _slideEndTime.sub(block.timestamp);
406         // timeout capped at TIMEOUT1
407         if (timeout > TIMEOUT1) timeout = TIMEOUT1;
408         _slideEndTime = (block.timestamp).add(timeout);
409         // Capped at fixedEndTime
410         if (_slideEndTime > fixedEndTime)  return fixedEndTime;
411         return _slideEndTime;
412     }
413 
414     // get random in range [1, _range] with _seed
415     function getRandom(uint256 _seed, uint256 _range)
416         public
417         pure
418         returns(uint256)
419     {
420         if (_range == 0) return _seed;
421         return (_seed % _range) + 1;
422     }
423 
424 
425     function getEarlyIncomeMul(uint256 _ticketSum)
426         public
427         pure
428         returns(uint256)
429     {
430         // Early-Multiplier = 1 + PBASE / (1 + PMULTI * ((Current No. of LT)/RDIVIDER)^6)
431         uint256 base = _ticketSum * ZOOM / RDIVIDER;
432         uint256 expo = base.mul(base).mul(base); //^3
433         expo = expo.mul(expo) / (ZOOM**6); //^6
434         return (1 + PBASE / (1 + expo.mul(PMULTI)));
435     }
436 
437     // get reveiced Tickets, based on current round ticketSum
438     function getTAmount(uint256 _ethAmount, uint256 _ticketSum) 
439         public
440         pure
441         returns(uint256)
442     {
443         uint256 _tPrice = getTPrice(_ticketSum);
444         return _ethAmount.div(_tPrice);
445     }
446 
447     function isGoldenMin(
448         uint256 _slideEndTime
449         )
450         public
451         view
452         returns(bool)
453     {
454         uint256 _restTime1 = _slideEndTime.sub(block.timestamp);
455         // golden min. exist if timer1 < 6 hours
456         if (_restTime1 > 6 hours) return false;
457         uint256 _min = (block.timestamp / 60) % 60;
458         return _min == 8;
459     }
460 
461     // percent ZOOM = 100, ie. mul = 2.05 return 205
462     // Lotto-Multiplier = ((grandPot / initGrandPot)^2) * x * y * z
463     // x = (TIMEOUT1 - timer1 - 1) / 4 + 1 => (unit = hour, max = 11/4 + 1 = 3.75) 
464     // y = (TIMEOUT2 - timer2 - 1) / 3 + 1) => (unit = day max = 3)
465     // z = isGoldenMin ? 4 : 1
466     function getTMul(
467         uint256 _initGrandPot,
468         uint256 _grandPot, 
469         uint256 _slideEndTime, 
470         uint256 _fixedEndTime
471         )
472         public
473         view
474         returns(uint256)
475     {
476         uint256 _pZoom = 100;
477         uint256 base = _initGrandPot != 0 ?_pZoom.mul(_grandPot) / _initGrandPot : _pZoom;
478         uint256 expo = base.mul(base);
479         uint256 _timer1 = _slideEndTime.sub(block.timestamp) / 1 hours; // 0.. 11
480         uint256 _timer2 = _fixedEndTime.sub(block.timestamp) / 1 days; // 0 .. 6
481         uint256 x = (_pZoom * (11 - _timer1) / 4) + _pZoom; // [1, 3.75]
482         uint256 y = (_pZoom * (6 - _timer2) / 3) + _pZoom; // [1, 3]
483         uint256 z = isGoldenMin(_slideEndTime) ? 4 : 1;
484         uint256 res = expo.mul(x).mul(y).mul(z) / (_pZoom ** 3); // ~ [1, 90]
485         return res;
486     }
487 
488     // get ticket price, based on current round ticketSum
489     //unit in ETH, no need / zoom^6
490     function getTPrice(uint256 _ticketSum)
491         public
492         pure
493         returns(uint256)
494     {
495         uint256 base = (_ticketSum + 1).mul(ZOOM) / PDIVIDER;
496         uint256 expo = base;
497         expo = expo.mul(expo).mul(expo); // ^3
498         expo = expo.mul(expo); // ^6
499         uint256 tPrice = SLP + expo / PN;
500         return tPrice;
501     }
502 
503     // used to draw grandpot results
504     // weightRange = roundWeight * grandpot / (grandpot - initGrandPot)
505     // grandPot = initGrandPot + round investedSum(for grandPot)
506     function getWeightRange(uint256 initGrandPot)
507         public
508         pure
509         returns(uint256)
510     {
511         uint256 avgMul = 30;
512         return ((initGrandPot * 2 * 100 / 68) * avgMul / SLP) + 1000;
513     }
514 
515     // dynamic rate _RATE = n
516     // major rate = 1/n with _RATE = 1000 999 ... 1
517     // minor rate = 1/n with _RATE = 500 499 ... 1
518     // loop = _ethAmount / _MIN
519     // lose rate = ((n- 1) / n) * ((n- 2) / (n - 1)) * ... * ((n- k) / (n - k + 1)) = (n - k) / n
520     function isJackpot(
521         uint256 _seed,
522         uint256 _RATE,
523         uint256 _MIN,
524         uint256 _ethAmount
525         )
526         public
527         pure
528         returns(bool)
529     {
530         // _RATE >= 2
531         uint256 k = _ethAmount / _MIN;
532         if (k == 0) return false;
533         // LOSE RATE MIN 50%, WIN RATE MAX 50%
534         uint256 _loseCap = _RATE / 2;
535         // IF _RATE - k > _loseCap
536         if (_RATE > k + _loseCap) _loseCap = _RATE - k;
537 
538         bool _lose = (_seed % _RATE) < _loseCap;
539         return !_lose;
540     }
541 }
542 
543 interface DevTeamInterface {
544     function setF2mAddress(address _address) public;
545     function setLotteryAddress(address _address) public;
546     function setCitizenAddress(address _address) public;
547     function setBankAddress(address _address) public;
548     function setRewardAddress(address _address) public;
549     function setWhitelistAddress(address _address) public;
550 
551     function setupNetwork() public;
552 }
553 
554 interface LotteryInterface {
555     function joinNetwork(address[6] _contract) public;
556     // call one time
557     function activeFirstRound() public;
558     // Core Functions
559     function pushToPot() public payable;
560     function finalizeable() public view returns(bool);
561     // bounty
562     function finalize() public;
563     function buy(string _sSalt) public payable;
564     function buyFor(string _sSalt, address _sender) public payable;
565     //function withdraw() public;
566     function withdrawFor(address _sender) public returns(uint256);
567 
568     function getRewardBalance(address _buyer) public view returns(uint256);
569     function getTotalPot() public view returns(uint256);
570     // EarlyIncome
571     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
572     // included claimed amount
573     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
574     function getCurRoundId() public view returns(uint256);
575     // set endRound, prepare to upgrade new version
576     function setLastRound(uint256 _lastRoundId) public;
577     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
578     function cashoutable(address _address) public view returns(bool);
579     function isLastRound() public view returns(bool);
580     function sBountyClaim(address _sBountyHunter) public returns(uint256);
581 }
582 
583 
584 /**
585  * @title SafeMath
586  * @dev Math operations with safety checks that revert on error
587  */
588 library SafeMath {
589     int256 constant private INT256_MIN = -2**255;
590 
591     /**
592     * @dev Multiplies two unsigned integers, reverts on overflow.
593     */
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
596         // benefit is lost if 'b' is also tested.
597         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
598         if (a == 0) {
599             return 0;
600         }
601 
602         uint256 c = a * b;
603         require(c / a == b);
604 
605         return c;
606     }
607 
608     /**
609     * @dev Multiplies two signed integers, reverts on overflow.
610     */
611     function mul(int256 a, int256 b) internal pure returns (int256) {
612         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
613         // benefit is lost if 'b' is also tested.
614         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
615         if (a == 0) {
616             return 0;
617         }
618 
619         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
620 
621         int256 c = a * b;
622         require(c / a == b);
623 
624         return c;
625     }
626 
627     /**
628     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
629     */
630     function div(uint256 a, uint256 b) internal pure returns (uint256) {
631         // Solidity only automatically asserts when dividing by 0
632         require(b > 0);
633         uint256 c = a / b;
634         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
635 
636         return c;
637     }
638 
639     /**
640     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
641     */
642     function div(int256 a, int256 b) internal pure returns (int256) {
643         require(b != 0); // Solidity only automatically asserts when dividing by 0
644         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
645 
646         int256 c = a / b;
647 
648         return c;
649     }
650 
651     /**
652     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
653     */
654     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
655         require(b <= a);
656         uint256 c = a - b;
657 
658         return c;
659     }
660 
661     /**
662     * @dev Subtracts two signed integers, reverts on overflow.
663     */
664     function sub(int256 a, int256 b) internal pure returns (int256) {
665         int256 c = a - b;
666         require((b >= 0 && c <= a) || (b < 0 && c > a));
667 
668         return c;
669     }
670 
671     /**
672     * @dev Adds two unsigned integers, reverts on overflow.
673     */
674     function add(uint256 a, uint256 b) internal pure returns (uint256) {
675         uint256 c = a + b;
676         require(c >= a);
677 
678         return c;
679     }
680 
681     /**
682     * @dev Adds two signed integers, reverts on overflow.
683     */
684     function add(int256 a, int256 b) internal pure returns (int256) {
685         int256 c = a + b;
686         require((b >= 0 && c >= a) || (b < 0 && c < a));
687 
688         return c;
689     }
690 
691     /**
692     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
693     * reverts when dividing by zero.
694     */
695     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
696         require(b != 0);
697         return a % b;
698     }
699 }