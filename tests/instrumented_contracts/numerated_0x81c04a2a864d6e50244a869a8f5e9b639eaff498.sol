1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 library SafeMath {
10     int256 constant private INT256_MIN = -2**255;
11 
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Multiplies two signed integers, reverts on overflow.
31     */
32     function mul(int256 a, int256 b) internal pure returns (int256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
41 
42         int256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
62     */
63     function div(int256 a, int256 b) internal pure returns (int256) {
64         require(b != 0); // Solidity only automatically asserts when dividing by 0
65         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
66 
67         int256 c = a / b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Subtracts two signed integers, reverts on overflow.
84     */
85     function sub(int256 a, int256 b) internal pure returns (int256) {
86         int256 c = a - b;
87         require((b >= 0 && c <= a) || (b < 0 && c > a));
88 
89         return c;
90     }
91 
92     /**
93     * @dev Adds two unsigned integers, reverts on overflow.
94     */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Adds two signed integers, reverts on overflow.
104     */
105     function add(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a + b;
107         require((b >= 0 && c >= a) || (b < 0 && c < a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114     * reverts when dividing by zero.
115     */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 library Helper {
123     using SafeMath for uint256;
124 
125     uint256 constant public ZOOM = 1000;
126     uint256 constant public SDIVIDER = 3450000;
127     uint256 constant public PDIVIDER = 3450000;
128     uint256 constant public RDIVIDER = 1580000;
129     // Starting LS price (SLP)
130     uint256 constant public SLP = 0.002 ether;
131     // Starting Added Time (SAT)
132     uint256 constant public SAT = 30; // seconds
133     // Price normalization (PN)
134     uint256 constant public PN = 777;
135     // EarlyIncome base
136     uint256 constant public PBASE = 13;
137     uint256 constant public PMULTI = 26;
138     uint256 constant public LBase = 15;
139 
140     uint256 constant public ONE_HOUR = 3600;
141     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
142     //uint256 constant public TIMEOUT0 = 3 * ONE_HOUR;
143     uint256 constant public TIMEOUT1 = 12 * ONE_HOUR;
144     
145     function bytes32ToString (bytes32 data)
146         public
147         pure
148         returns (string) 
149     {
150         bytes memory bytesString = new bytes(32);
151         for (uint j=0; j<32; j++) {
152             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
153             if (char != 0) {
154                 bytesString[j] = char;
155             }
156         }
157         return string(bytesString);
158     }
159     
160     function uintToBytes32(uint256 n)
161         public
162         pure
163         returns (bytes32) 
164     {
165         return bytes32(n);
166     }
167     
168     function bytes32ToUint(bytes32 n) 
169         public
170         pure
171         returns (uint256) 
172     {
173         return uint256(n);
174     }
175     
176     function stringToBytes32(string memory source) 
177         public
178         pure
179         returns (bytes32 result) 
180     {
181         bytes memory tempEmptyStringTest = bytes(source);
182         if (tempEmptyStringTest.length == 0) {
183             return 0x0;
184         }
185 
186         assembly {
187             result := mload(add(source, 32))
188         }
189     }
190     
191     function stringToUint(string memory source) 
192         public
193         pure
194         returns (uint256)
195     {
196         return bytes32ToUint(stringToBytes32(source));
197     }
198     
199     function uintToString(uint256 _uint) 
200         public
201         pure
202         returns (string)
203     {
204         return bytes32ToString(uintToBytes32(_uint));
205     }
206 
207 /*     
208     function getSlice(uint256 begin, uint256 end, string text) public pure returns (string) {
209         bytes memory a = new bytes(end-begin+1);
210         for(uint i = 0; i <= end - begin; i++){
211             a[i] = bytes(text)[i + begin - 1];
212         }
213         return string(a);    
214     }
215  */
216     function validUsername(string _username)
217         public
218         pure
219         returns(bool)
220     {
221         uint256 len = bytes(_username).length;
222         // Im Raum [4, 18]
223         if ((len < 4) || (len > 18)) return false;
224         // Letzte Char != ' '
225         if (bytes(_username)[len-1] == 32) return false;
226         // Erste Char != '0'
227         return uint256(bytes(_username)[0]) != 48;
228     }
229 
230     // Lottery Helper
231 
232     // Seconds added per LT = SAT - ((Current no. of LT + 1) / SDIVIDER)^6
233     function getAddedTime(uint256 _rTicketSum, uint256 _tAmount)
234         public
235         pure
236         returns (uint256)
237     {
238         //Luppe = 10000 = 10^4
239         uint256 base = (_rTicketSum + 1).mul(10000) / SDIVIDER;
240         uint256 expo = base;
241         expo = expo.mul(expo).mul(expo); // ^3
242         expo = expo.mul(expo); // ^6
243         // div 10000^6
244         expo = expo / (10**24);
245 
246         if (expo > SAT) return 0;
247         return (SAT - expo).mul(_tAmount);
248     }
249 
250     function getNewEndTime(uint256 toAddTime, uint256 slideEndTime, uint256 fixedEndTime)
251         public
252         view
253         returns(uint256)
254     {
255         uint256 _slideEndTime = (slideEndTime).add(toAddTime);
256         uint256 timeout = _slideEndTime.sub(block.timestamp);
257         // timeout capped at TIMEOUT1
258         if (timeout > TIMEOUT1) timeout = TIMEOUT1;
259         _slideEndTime = (block.timestamp).add(timeout);
260         // Capped at fixedEndTime
261         if (_slideEndTime > fixedEndTime)  return fixedEndTime;
262         return _slideEndTime;
263     }
264 
265     // get random in range [1, _range] with _seed
266     function getRandom(uint256 _seed, uint256 _range)
267         public
268         pure
269         returns(uint256)
270     {
271         if (_range == 0) return _seed;
272         return (_seed % _range) + 1;
273     }
274 
275 
276     function getEarlyIncomeMul(uint256 _ticketSum)
277         public
278         pure
279         returns(uint256)
280     {
281         // Early-Multiplier = 1 + PBASE / (1 + PMULTI * ((Current No. of LT)/RDIVIDER)^6)
282         uint256 base = _ticketSum * ZOOM / RDIVIDER;
283         uint256 expo = base.mul(base).mul(base); //^3
284         expo = expo.mul(expo) / (ZOOM**6); //^6
285         return (1 + PBASE / (1 + expo.mul(PMULTI)));
286     }
287 
288     // get reveiced Tickets, based on current round ticketSum
289     function getTAmount(uint256 _ethAmount, uint256 _ticketSum) 
290         public
291         pure
292         returns(uint256)
293     {
294         uint256 _tPrice = getTPrice(_ticketSum);
295         return _ethAmount.div(_tPrice);
296     }
297 
298     // Lotto-Multiplier = 1 + LBase * (Current No. of Tickets / PDivider)^6
299     function getTMul(uint256 _ticketSum) // Unit Wei
300         public
301         pure
302         returns(uint256)
303     {
304         uint256 base = _ticketSum * ZOOM / PDIVIDER;
305         uint256 expo = base.mul(base).mul(base);
306         expo = expo.mul(expo); // ^6
307         return 1 + expo.mul(LBase) / (10**18);
308     }
309 
310     // get ticket price, based on current round ticketSum
311     //unit in ETH, no need / zoom^6
312     function getTPrice(uint256 _ticketSum)
313         public
314         pure
315         returns(uint256)
316     {
317         uint256 base = (_ticketSum + 1).mul(ZOOM) / PDIVIDER;
318         uint256 expo = base;
319         expo = expo.mul(expo).mul(expo); // ^3
320         expo = expo.mul(expo); // ^6
321         uint256 tPrice = SLP + expo / PN;
322         return tPrice;
323     }
324 
325     // get weight of slot, chance to win grandPot
326     function getSlotWeight(uint256 _ethAmount, uint256 _ticketSum)
327         public
328         pure
329         returns(uint256)
330     {
331         uint256 _tAmount = getTAmount(_ethAmount, _ticketSum);
332         uint256 _tMul = getTMul(_ticketSum);
333         return (_tAmount).mul(_tMul);
334     }
335 
336     // used to draw grandpot results
337     // weightRange = roundWeight * grandpot / (grandpot - initGrandPot)
338     // grandPot = initGrandPot + round investedSum(for grandPot)
339     function getWeightRange(uint256 grandPot, uint256 initGrandPot, uint256 curRWeight)
340         public
341         pure
342         returns(uint256)
343     {
344         //calculate round grandPot-investedSum
345         uint256 grandPotInvest = grandPot - initGrandPot;
346         if (grandPotInvest == 0) return 8;
347         uint256 zoomMul = grandPot * ZOOM / grandPotInvest;
348         uint256 weightRange = zoomMul * curRWeight / ZOOM;
349         if (weightRange < curRWeight) weightRange = curRWeight;
350         return weightRange;
351     }
352 }
353 
354 interface DevTeamInterface {
355     function setF2mAddress(address _address) public;
356     function setLotteryAddress(address _address) public;
357     function setCitizenAddress(address _address) public;
358     function setBankAddress(address _address) public;
359     function setRewardAddress(address _address) public;
360     function setWhitelistAddress(address _address) public;
361 
362     function setupNetwork() public;
363 }
364 
365 interface LotteryInterface {
366     function joinNetwork(address[6] _contract) public;
367     // call one time
368     function activeFirstRound() public;
369     // Core Functions
370     function pushToPot() public payable;
371     function finalizeable() public view returns(bool);
372     // bounty
373     function finalize() public;
374     function buy(string _sSalt) public payable;
375     function buyFor(string _sSalt, address _sender) public payable;
376     //function withdraw() public;
377     function withdrawFor(address _sender) public returns(uint256);
378 
379     function getRewardBalance(address _buyer) public view returns(uint256);
380     function getTotalPot() public view returns(uint256);
381     // EarlyIncome
382     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
383     // included claimed amount
384     // function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
385     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
386     // function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
387     function getCurRoundId() public view returns(uint256);
388     // set endRound, prepare to upgrade new version
389     function setLastRound(uint256 _lastRoundId) public;
390     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
391     function cashoutable(address _address) public view returns(bool);
392     function isLastRound() public view returns(bool);
393 }
394 
395 contract Reward {
396     using SafeMath for uint256;
397 
398     event NewReward(address indexed _lucker, uint256[5] _info);
399     
400     modifier onlyOwner() {
401         require(msg.sender == address(lotteryContract), "This is just log for lottery contract");
402         _;
403     }
404 
405     modifier claimable() {
406         require(
407             rest > 1 && 
408             block.number > lastBlock &&
409             lastRoundClaim[msg.sender] < lastRoundId,
410             "out of stock in this round, block or already claimed");
411         _;
412     }
413 
414 /*     
415     enum RewardType {
416         Minor, 0
417         Major, 1
418         Grand, 2
419         Bounty 3
420         SBounty 4 // smal bounty
421     } 
422 */
423 
424     struct Rewards {
425         address lucker;
426         uint256 time;
427         uint256 rId;
428         uint256 value;
429         uint256 winNumber;
430         uint256 rewardType;
431     }
432 
433     Rewards[] public rewardList;
434     // reward array by address
435     mapping( address => uint256[]) public pReward;
436     // reward sum by address
437     mapping( address => uint256) public pRewardedSum;
438     // reward sum by address, round
439     mapping( address => mapping(uint256 => uint256)) public pRewardedSumPerRound;
440     // reward sum by round
441     mapping( uint256 => uint256) public rRewardedSum;
442     // reward sum all round, all addresses
443     uint256 public rewardedSum;
444     
445     // last claimed round by address to check timeout
446     // timeout balance will be pushed to dividends
447     mapping(address => uint256) lastRoundClaim;
448 
449     LotteryInterface lotteryContract;
450 
451     //////////////////////////////////////////////////////////
452     
453     // rest times for sBounty, small bountys free for all (round-players) after each round
454     uint256 public rest = 0;
455     // last block that sBounty claimed, to prevent 2 time claimed in same block
456     uint256 public lastBlock = 0;
457     // sBounty will be saved in logs of last round
458     // new round will be started after sBountys pushed
459     uint256 public lastRoundId;
460 
461     constructor (address _devTeam)
462         public
463     {
464         // register address in network
465         DevTeamInterface(_devTeam).setRewardAddress(address(this));
466     }
467 
468     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
469     function joinNetwork(address[6] _contract)
470         public
471     {
472         require((address(lotteryContract) == 0x0),"already setup");
473         lotteryContract = LotteryInterface(_contract[3]);
474     }
475 
476     // sBounty program
477     // rules :
478     // 1. accept only eth from lottery contract
479     // 2. one claim per block
480     // 3. one claim per address (reset each round)
481 
482     function getSBounty()
483         public
484         view
485         returns(uint256, uint256, uint256)
486     {
487         uint256 sBountyAmount = rest < 2 ? 0 : address(this).balance / (rest-1);
488         return (rest, sBountyAmount, lastRoundId);
489     }
490 
491     // pushed from lottery contract only
492     function pushBounty(uint256 _curRoundId) 
493         public 
494         payable 
495         onlyOwner() 
496     {
497         rest = 8;
498         lastBlock = block.number;
499         lastRoundId = _curRoundId;
500     }
501 
502     function claim()
503         public
504         claimable()
505     {
506         address _sender = msg.sender;
507         uint256 rInvested = lotteryContract.getPInvestedSumByRound(lastRoundId, _sender);
508         require(rInvested > 0, "sorry, not invested no bounty");
509         lastBlock = block.number;
510         lastRoundClaim[_sender] = lastRoundId;
511         rest = rest - 1;
512         uint256 claimAmount = address(this).balance / rest;
513         _sender.transfer(claimAmount);
514         mintRewardCore(
515             _sender,
516             lastRoundId,
517             0,
518             0,
519             claimAmount,
520             4
521         );
522     }
523 
524     // rewards sealed by lottery contract
525     function mintReward(
526         address _lucker,
527         uint256 _curRoundId,
528         uint256 _tNumberFrom,
529         uint256 _tNumberTo,
530         uint256 _value,
531         uint256 _rewardType)
532         public
533         onlyOwner()
534     {
535         mintRewardCore(
536             _lucker,
537             _curRoundId,
538             _tNumberFrom,
539             _tNumberTo,
540             _value,
541             _rewardType);
542     }
543 
544     // reward logs generator
545     function mintRewardCore(
546         address _lucker,
547         uint256 _curRoundId,
548         uint256 _tNumberFrom,
549         uint256 _tNumberTo,
550         uint256 _value,
551         uint256 _rewardType)
552         private
553     {
554         Rewards memory _reward;
555         _reward.lucker = _lucker;
556         _reward.time = block.timestamp;
557         _reward.rId = _curRoundId;
558         _reward.value = _value;
559 
560         // get winning number if rewardType is not bounty or sBounty
561         // seed = rewardList.length to be sure that seed changed after
562         // every reward minting
563         if (_rewardType < 3)
564         _reward.winNumber = getWinNumberBySlot(_tNumberFrom, _tNumberTo);
565 
566         _reward.rewardType = _rewardType;
567         rewardList.push(_reward);
568         pReward[_lucker].push(rewardList.length - 1);
569         // reward sum logs
570         pRewardedSum[_lucker] += _value;
571         rRewardedSum[_curRoundId] += _value;
572         rewardedSum += _value;
573         pRewardedSumPerRound[_lucker][_curRoundId] += _value;
574         emit NewReward(_reward.lucker, [_reward.time, _reward.rId, _reward.value, _reward.winNumber, uint256(_reward.rewardType)]);
575     }
576 
577     function getWinNumberBySlot(uint256 _tNumberFrom, uint256 _tNumberTo)
578         public
579         view
580         returns(uint256)
581     {
582         //uint256 _seed = uint256(keccak256(rewardList.length));
583         uint256 _seed = rewardList.length * block.number + block.timestamp;
584         // get random number in range (1, _to - _from + 1)
585         uint256 _winNr = Helper.getRandom(_seed, _tNumberTo + 1 - _tNumberFrom);
586         return _tNumberFrom + _winNr - 1;
587     }
588 
589     function getPRewardLength(address _sender)
590         public
591         view
592         returns(uint256)
593     {
594         return pReward[_sender].length;
595     }
596 
597     function getRewardListLength()
598         public
599         view
600         returns(uint256)
601     {
602         return rewardList.length;
603     }
604 
605     function getPRewardId(address _sender, uint256 i)
606         public
607         view
608         returns(uint256)
609     {
610         return pReward[_sender][i];
611     }
612 
613     function getPRewardedSumByRound(uint256 _rId, address _buyer)
614         public
615         view
616         returns(uint256)
617     {
618         return pRewardedSumPerRound[_buyer][_rId];
619     }
620 
621     function getRewardedSumByRound(uint256 _rId)
622         public
623         view
624         returns(uint256)
625     {
626         return rRewardedSum[_rId];
627     }
628 
629     function getRewardInfo(uint256 _id)
630         public
631         view
632         returns(
633             address,
634             uint256,
635             uint256,
636             uint256,
637             uint256,
638             uint256
639         )
640     {
641         Rewards memory _reward = rewardList[_id];
642         return (
643             _reward.lucker,
644             _reward.winNumber,
645             _reward.time,
646             _reward.rId,
647             _reward.value,
648             _reward.rewardType
649         );
650     }
651 }