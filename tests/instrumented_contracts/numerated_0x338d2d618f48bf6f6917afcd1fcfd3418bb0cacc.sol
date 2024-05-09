1 pragma solidity >=0.5.0 <0.6.0;
2 
3 
4 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * @notice Renouncing to ownership will leave the contract without an owner.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
78 
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 interface IERC20 {
150     function transfer(address to, uint256 value) external returns (bool);
151 
152     function approve(address spender, uint256 value) external returns (bool);
153 
154     function transferFrom(address from, address to, uint256 value) external returns (bool);
155 
156     function totalSupply() external view returns (uint256);
157 
158     function balanceOf(address who) external view returns (uint256);
159 
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: lib/CanReclaimToken.sol
168 /**
169  * @title Contracts that should be able to recover tokens
170  * @author SylTi
171  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
172  * This will prevent any accidental loss of tokens.
173  */
174 contract CanReclaimToken is Ownable {
175 
176   /**
177    * @dev Reclaim all ERC20 compatible tokens
178    * @param token ERC20 The address of the token contract
179    */
180   function reclaimToken(IERC20 token) external onlyOwner {
181     address payable owner = address(uint160(owner()));
182 
183     if (address(token) == address(0)) {
184       owner.transfer(address(this).balance);
185       return;
186     }
187     uint256 balance = token.balanceOf(address(this));
188     token.transfer(owner, balance);
189   }
190 
191 }
192 
193 // File: lib/PPQueue.sol
194 /**
195  * @title PPQueue
196  */
197 library PPQueue {
198   struct Item {
199     //    uint idx;
200     bool exists;
201     uint prev;
202     uint next;
203   }
204 
205   struct Queue {
206     uint length;
207     uint first;
208     uint last;
209     uint counter;
210     mapping (uint => Item) items;
211   }
212 
213   /**
214    * @dev push item to fifo queue
215    */
216   function push(Queue storage queue, uint index) internal {
217     require(!queue.items[index].exists);
218     queue.items[index] = Item({
219       exists: true,
220       prev: queue.last,
221       next: 0
222       });
223 
224     if (queue.length == 0) {
225       queue.first = index;
226     } else {
227       queue.items[queue.last].next = index;
228     }
229 
230     //save last item queue idx
231     queue.last = index;
232     queue.length++;
233   }
234 
235   /**
236   * @dev pop item from fifo queue
237   */
238   function popf(Queue storage queue) internal returns (uint index) {
239     index = queue.first;
240     remove(queue, index);
241   }
242 
243   /**
244   * @dev pop item from lifo queue
245   */
246   function popl(Queue storage queue) internal returns (uint index) {
247     index = queue.last;
248     remove(queue, index);
249   }
250 
251   /**
252    * @dev remove an item from queue
253    */
254   function remove(Queue storage queue, uint index) internal {
255     require(queue.length > 0);
256     require(queue.items[index].exists);
257 
258 
259     if (queue.items[index].prev != 0) {
260       queue.items[queue.items[index].prev].next = queue.items[index].next;
261     } else {
262       //assume we delete first item
263       queue.first = queue.items[index].next;
264     }
265 
266     if (queue.items[index].next != 0) {
267       queue.items[queue.items[index].next].prev = queue.items[index].prev;
268     } else {
269       //assume we delete last item
270       queue.last = queue.items[index].prev;
271     }
272     //del from queue
273     delete queue.items[index];
274     queue.length--;
275 
276   }
277 
278   /**
279   * @dev get queue length
280   * @return uint
281   */
282   function len(Queue storage queue) internal view returns (uint) {
283     //auto prevent existing of agents with updated address and same id
284     return queue.length;
285   }
286 }
287 
288 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
289 
290 /**
291  * @title Helps contracts guard against reentrancy attacks.
292  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
293  * @dev If you mark a function `nonReentrant`, you should also
294  * mark it `external`.
295  */
296 contract ReentrancyGuard {
297     /// @dev counter to allow mutex lock with only one SSTORE operation
298     uint256 private _guardCounter;
299 
300     constructor () internal {
301         // The counter starts at one to prevent changing it from zero to a non-zero
302         // value, which is a more expensive operation.
303         _guardCounter = 1;
304     }
305 
306     /**
307      * @dev Prevents a contract from calling itself, directly or indirectly.
308      * Calling a `nonReentrant` function from another `nonReentrant`
309      * function is not supported. It is possible to prevent this from happening
310      * by making the `nonReentrant` function external, and make it call a
311      * `private` function that does the actual work.
312      */
313     modifier nonReentrant() {
314         _guardCounter += 1;
315         uint256 localCounter = _guardCounter;
316         _;
317         require(localCounter == _guardCounter);
318     }
319 }
320 
321 // File: contracts/Referrals.sol
322 
323 interface Affiliates {
324   function plusByCode(address _token, uint256 _affCode, uint _amount) external payable;
325   function upAffCode(uint256 _affCode) external view returns (uint);
326   function setUpAffCodeByAddr(address _address, uint _upAffCode) external;
327   function getAffCode(uint256 _a) external pure returns (uint);
328   function sendAffReward(address _token, address _address) external returns (uint);
329 }
330 
331 contract Referrals is Ownable, ReentrancyGuard {
332   using SafeMath for uint;
333 
334   //1% - 100, 10% - 1000 50% - 5000
335   uint256[] public affLevelReward;
336   Affiliates public aff;
337 
338   constructor (address _aff) public {
339     require(_aff != address(0));
340     aff = Affiliates(_aff);
341 
342     // two upper levels for each: winner and loser
343     // total sum of level's % must be 100%
344     //1% - 100, 10% - 1000 50% - 5000
345     affLevelReward.push(0); // level 0, 10% - player self - cacheback
346     affLevelReward.push(8000); // level 1, 70% of affPool
347     affLevelReward.push(2000); // level 2, 20% of affPool
348   }
349 
350 
351   //AFFILIATES
352   function setAffiliateLevel(uint256 _level, uint256 _rewardPercent) external onlyOwner {
353     require(_level < affLevelReward.length);
354     affLevelReward[_level] = _rewardPercent;
355   }
356 
357   function incAffiliateLevel(uint256 _rewardPercent) external onlyOwner {
358     affLevelReward.push(_rewardPercent);
359   }
360 
361   function decAffiliateLevel() external onlyOwner {
362     delete affLevelReward[affLevelReward.length--];
363   }
364 
365   function affLevelsCount() external view returns (uint) {
366     return affLevelReward.length;
367   }
368 
369   function _distributeAffiliateReward(uint256 _sum, uint256 _affCode, uint256 _level, bool _cacheBack) internal {
370     uint upAffCode = aff.upAffCode(_affCode);
371 
372     if (affLevelReward[_level] > 0 && _affCode != 0 && (_level > 0 || (_cacheBack && upAffCode != 0))) {
373       uint total = _getPercent(_sum, affLevelReward[_level]);
374       aff.plusByCode.value(total)(address(0x0), _affCode, total);
375     }
376 
377     if (affLevelReward.length > ++_level) {
378       _distributeAffiliateReward(_sum, upAffCode, _level, false);
379     }
380   }
381 
382   function getAffReward() external nonReentrant {
383     aff.sendAffReward(address(0x0), msg.sender);
384   }
385 
386   //1% - 100, 10% - 1000 50% - 5000
387   function _getPercent(uint256 _v, uint256 _p) internal pure returns (uint)    {
388     return _v.mul(_p) / 10000;
389   }
390 }
391 
392 // File: openzeppelin-solidity/contracts/access/Roles.sol
393 /**
394  * @title Roles
395  * @dev Library for managing addresses assigned to a Role.
396  */
397 library Roles {
398     struct Role {
399         mapping (address => bool) bearer;
400     }
401 
402     /**
403      * @dev give an account access to this role
404      */
405     function add(Role storage role, address account) internal {
406         require(account != address(0));
407         require(!has(role, account));
408 
409         role.bearer[account] = true;
410     }
411 
412     /**
413      * @dev remove an account's access to this role
414      */
415     function remove(Role storage role, address account) internal {
416         require(account != address(0));
417         require(has(role, account));
418 
419         role.bearer[account] = false;
420     }
421 
422     /**
423      * @dev check if an account has this role
424      * @return bool
425      */
426     function has(Role storage role, address account) internal view returns (bool) {
427         require(account != address(0));
428         return role.bearer[account];
429     }
430 }
431 
432 // File: lib/ServiceRole.sol
433 contract ServiceRole {
434   using Roles for Roles.Role;
435 
436   event ServiceAdded(address indexed account);
437   event ServiceRemoved(address indexed account);
438 
439   Roles.Role private services;
440 
441   constructor() internal {
442     _addService(msg.sender);
443   }
444 
445   modifier onlyService() {
446     require(isService(msg.sender));
447     _;
448   }
449 
450   function isService(address account) public view returns (bool) {
451     return services.has(account);
452   }
453 
454   function renounceService() public {
455     _removeService(msg.sender);
456   }
457 
458   function _addService(address account) internal {
459     services.add(account);
460     emit ServiceAdded(account);
461   }
462 
463   function _removeService(address account) internal {
464     services.remove(account);
465     emit ServiceRemoved(account);
466   }
467 }
468 
469 // File: contracts/Services.sol
470 contract Services is Ownable,ServiceRole {
471   constructor() public{
472 
473   }
474 
475   function addService(address account) external onlyOwner {
476     _addService(account);
477   }
478 
479   function removeService(address account) external onlyOwner {
480     _removeService(account);
481   }
482 
483 }
484 
485 // File: contracts/BetLevels.sol
486 contract BetLevels is Ownable {
487 
488   //value => level
489   mapping(uint => uint) betLevels;
490   //array of avail bets values
491   uint[] public betLevelValues;
492 
493   constructor () public {
494     //zero level = 0, skip it
495     betLevelValues.length += 8;
496     _setBetLevel(1, 0.01 ether);
497     _setBetLevel(2, 0.05 ether);
498     _setBetLevel(3, 0.1 ether);
499     _setBetLevel(4, 0.5 ether);
500     _setBetLevel(5, 1 ether);
501     _setBetLevel(6, 5 ether);
502     _setBetLevel(7, 10 ether);
503   }
504 
505   function addBetLevel(uint256 value) external onlyOwner {
506     require(betLevelValues.length == 0 || betLevelValues[betLevelValues.length - 1] < value);
507     betLevelValues.length++;
508     _setBetLevel(betLevelValues.length - 1, value);
509   }
510 
511   function _setBetLevel(uint level, uint value) internal {
512     betLevelValues[level] = value;
513     betLevels[value] = level;
514   }
515 
516   function setBetLevel(uint level, uint value) external onlyOwner {
517     require(betLevelValues.length > level);
518     require(betLevelValues[level] != value);
519     delete betLevels[betLevelValues[level]];
520     _setBetLevel(level, value);
521   }
522 
523   function betLevelsCount() external view returns (uint) {
524     return betLevelValues.length;
525   }
526 
527   function getBetLevel(uint value) internal view returns (uint level) {
528     level = betLevels[value];
529     require(level != 0);
530   }
531 }
532 
533 // File: contracts/BetIntervals.sol
534 contract BetIntervals is Ownable {
535   event SetInterval(uint startsFrom, uint pastCount, uint newInterval, uint newPeriod);
536 
537   uint public constant BetEpoch = 1550534400; //Tuesday, 19 February 2019 г., 0:00:00
538 
539 
540   struct RoundInterval {
541     uint interval;
542     uint from;
543     uint count;
544     uint period;
545   }
546   RoundInterval[] public intervalHistory;
547 
548   constructor() public{
549     intervalHistory.push(RoundInterval({
550       period : 10 * 60,
551       from : BetEpoch,
552       count : 0,
553       interval : 15 * 60
554       }));
555   }
556 
557   function setInterval(uint _interval, uint _period) external onlyOwner {
558     RoundInterval memory i = _getRoundIntervalAt(now);
559     uint intervalsCount = (now - i.from) / i.interval + 1;
560     RoundInterval memory ni = RoundInterval({
561       interval : _interval,
562       from : i.from + i.interval * intervalsCount,
563       count : intervalsCount + i.count,
564       period : _period
565       });
566     intervalHistory.push(ni);
567     emit SetInterval(ni.from, ni.count, _interval, _period);
568   }
569 
570   function getCurrentRoundId() public view returns (uint) {
571     return getRoundIdAt(now, 0);
572   }
573 
574   function getNextRoundId() public view returns (uint) {
575     return getRoundIdAt(now, 1);
576   }
577 
578   function getRoundIdAt(uint _time, uint _shift) public view returns (uint) {
579     uint intervalId = _getRoundIntervalIdAt(_time);
580     RoundInterval memory i = intervalHistory[intervalId];
581     return _time > i.from ? (_time - i.from) / i.interval + i.count + _shift : 0;
582 
583   }
584 
585 
586   function getCurrentRoundInterval() public view returns (uint interval, uint period) {
587     return getRoundIntervalAt(now);
588   }
589 
590   function getRoundIntervalAt(uint _time) public view returns (uint interval, uint period) {
591     RoundInterval memory i = _getRoundIntervalAt(_time);
592     interval = i.interval;
593     period = i.period;
594   }
595 
596   function getCurrentRoundInfo() public view returns (
597     uint roundId,
598     uint startAt,
599     uint finishAt
600   ) {
601     return getRoundInfoAt(now, 0);
602   }
603 
604   function getNextRoundInfo() public view returns (
605     uint roundId,
606     uint startAt,
607     uint finishAt
608   ) {
609     return getRoundInfoAt(now, 1);
610   }
611 
612   function getRoundInfoAt(uint _time, uint _shift) public view returns (
613     uint roundId,
614     uint startAt,
615     uint finishAt
616   ) {
617     RoundInterval memory i = _getRoundIntervalAt(_time);
618 
619     uint intervalsCount = _time > i.from ? (_time - i.from) / i.interval + _shift : 0;
620     startAt = i.from + i.interval * intervalsCount;
621     roundId = i.count + intervalsCount;
622     finishAt = i.period + startAt;
623   }
624 
625 
626   function _getRoundIntervalAt(uint _time) internal view returns (RoundInterval memory) {
627     return intervalHistory[_getRoundIntervalIdAt(_time)];
628   }
629 
630 
631   function _getRoundIntervalIdAt(uint _time) internal view returns (uint) {
632     require(intervalHistory.length > 0);
633     //    if (intervalHistory.length == 0) return 0;
634     // Shortcut for the actual value
635     if (_time >= intervalHistory[intervalHistory.length - 1].from)
636       return intervalHistory.length - 1;
637     if (_time < intervalHistory[0].from) return 0;
638 
639     // Binary search of the value in the array
640     uint min = 0;
641     uint max = intervalHistory.length - 1;
642     while (max > min) {
643       uint mid = (max + min + 1) / 2;
644       if (intervalHistory[mid].from <= _time) {
645         min = mid;
646       } else {
647         max = mid - 1;
648       }
649     }
650     return min;
651   }
652 
653 }
654 
655 // File: contracts/ReservedValue.sol
656 
657 contract ReservedValue is Ownable {
658   using SafeMath for uint;
659   event Income(address source, uint256 amount);
660 
661   address payable public wallet;
662   //total reserved eth amount
663   uint256 public totalReserved;
664 
665   constructor(address payable _w) public {
666     require(_w != address(0));
667     wallet = _w;
668 
669   }
670 
671   function setWallet(address payable _w) external onlyOwner {
672     require(address(_w) != address(0));
673     wallet = _w;
674   }
675 
676   /// @notice The fallback function payable
677   function() external payable {
678     require(msg.value > 0);
679     _flushBalance();
680   }
681 
682   function _flushBalance() internal {
683     uint256 balance = address(this).balance.sub(totalReserved);
684     if (balance > 0) {
685       address(wallet).transfer(balance);
686       emit Income(address(this), balance);
687     }
688   }
689 
690   function _incTotalReserved(uint value) internal {
691     totalReserved = totalReserved.add(value);
692   }
693 
694   function _decTotalReserved(uint value) internal {
695     totalReserved = totalReserved.sub(value);
696   }
697 }
698 
699 // File: contracts/Bets.sol
700 contract Bets is Ownable, ReservedValue, BetIntervals, BetLevels, Referrals, Services, CanReclaimToken {
701   using SafeMath for uint;
702 
703   event BetCreated(address indexed bettor, uint betId, uint index, uint allyRace, uint enemyRace, uint betLevel, uint value, uint utmSource);
704   event BetAccepted(uint betId, uint opBetId, uint roundId);
705   event BetCanceled(uint betId);
706   event BetRewarded(uint winBetId, uint loseBetId, uint reward, bool noWin);
707   event BetRoundCalculated(uint roundId, uint winnerRace, uint loserRace, uint betLevel, uint pool, uint bettorCount);
708   event StartBetRound(uint roundId, uint startAt, uint finishAt);
709   event RoundRaceResult(uint roundId, uint raceId, int32 result);
710   event FinishBetRound(uint roundId, uint startCheckedAt, uint finishCheckedAt);
711 
712   using PPQueue for PPQueue.Queue;
713 
714   struct Bettor {
715     uint counter;
716     mapping(uint => uint) bets;
717   }
718 
719   struct Race {
720     uint index;
721     bool exists;
722     uint count;
723     int32 result;
724   }
725 
726   struct BetRound {
727     uint startedAt;
728     uint finishedAt;
729     uint startCheckedAt;
730     uint finishCheckedAt;
731     uint[] bets;
732     mapping(uint => Race) races;
733     uint[] raceList;
734   }
735 
736   uint[] public roundsList;
737 
738   //roundId => BetRound
739   mapping(uint => BetRound) betRounds;
740 
741   struct Bet {
742     address payable bettor;
743     uint roundId;
744     uint allyRace;
745     uint enemyRace;
746     uint value;
747     uint level;
748     uint opBetId;
749     uint reward;
750     bool active;
751   }
752 
753   struct BetStat {
754     uint sum;
755     uint pool;
756     uint affPool;
757     uint count;
758     bool taxed;
759   }
760 
761   uint public lastBetId;
762   mapping(uint => Bet)  bets;
763   mapping(address => Bettor)  bettors;
764 
765   struct BetData {
766     mapping(uint => BetStat) stat;
767     PPQueue.Queue queue;
768   }
769 
770   //betLevel => allyRace => enemyRace => BetData
771   mapping(uint => mapping(uint => mapping(uint => BetData))) betData;
772 
773   //raceId => allowed
774   mapping(uint => bool) public allowedRace;
775 
776   uint public systemFeePcnt;
777   uint public affPoolPcnt;
778 
779 
780   constructor(address payable _w, address _aff) ReservedValue(_w) Referrals(_aff) public payable {
781     //    systemFee 5% (from loser sum)
782     //    affPoolPercent 5% (from loser  sum)
783     setFee(500, 500);
784 
785     //allow races, BTC,LTC,ETH by default
786     allowedRace[1] = true;
787     allowedRace[2] = true;
788     allowedRace[4] = true;
789     allowedRace[10] = true;
790     allowedRace[13] = true;
791   }
792 
793   function setFee(uint _systemFee, uint _affFee) public onlyOwner
794   {
795     systemFeePcnt = _systemFee;
796     affPoolPcnt = _affFee;
797   }
798 
799   function allowRace(uint _race, bool _allow) external onlyOwner {
800     allowedRace[_race] = _allow;
801   }
802 
803   function makeBet(uint allyRace, uint enemyRace, uint _affCode, uint _source) public payable {
804     require(allyRace != enemyRace && allowedRace[allyRace] && allowedRace[enemyRace]);
805     //require bet level exists
806     uint level = getBetLevel(msg.value);
807 
808     Bet storage bet = bets[++lastBetId];
809     bet.active = true;
810     bet.bettor = msg.sender;
811     bet.allyRace = allyRace;
812     bet.enemyRace = enemyRace;
813     bet.value = msg.value;
814     bet.level = level;
815 
816     //save bet to bettor list && inc. bets count
817     bettors[bet.bettor].bets[++bettors[bet.bettor].counter] = lastBetId;
818 
819     emit BetCreated(bet.bettor, lastBetId, bettors[bet.bettor].counter, allyRace, enemyRace, level, msg.value, _source);
820 
821     //upd queue
822     BetData storage allyData = betData[level][allyRace][enemyRace];
823     BetData storage enemyData = betData[level][enemyRace][allyRace];
824 
825     //if there is nobody on opposite side
826     if (enemyData.queue.len() == 0) {
827       allyData.queue.push(lastBetId);
828     } else {
829       //accepting bet
830       uint nextRoundId = _startNextRound();
831       uint opBetId = enemyData.queue.popf();
832       bet.opBetId = opBetId;
833       bet.roundId = nextRoundId;
834       bets[opBetId].opBetId = lastBetId;
835       bets[opBetId].roundId = nextRoundId;
836 
837       //upd fight stat
838       allyData.stat[nextRoundId].sum = allyData.stat[nextRoundId].sum.add(msg.value);
839       allyData.stat[nextRoundId].count++;
840 
841       enemyData.stat[nextRoundId].sum = enemyData.stat[nextRoundId].sum.add(bets[opBetId].value);
842       enemyData.stat[nextRoundId].count++;
843       if (!betRounds[nextRoundId].races[allyRace].exists) {
844         betRounds[nextRoundId].races[allyRace].exists = true;
845         betRounds[nextRoundId].races[allyRace].index = betRounds[nextRoundId].raceList.length;
846         betRounds[nextRoundId].raceList.push(allyRace);
847       }
848       betRounds[nextRoundId].races[allyRace].count++;
849 
850       if (!betRounds[nextRoundId].races[enemyRace].exists) {
851         betRounds[nextRoundId].races[enemyRace].exists = true;
852         betRounds[nextRoundId].races[enemyRace].index = betRounds[nextRoundId].raceList.length;
853         betRounds[nextRoundId].raceList.push(enemyRace);
854       }
855       betRounds[nextRoundId].races[enemyRace].count++;
856       betRounds[nextRoundId].bets.push(opBetId);
857       betRounds[nextRoundId].bets.push(lastBetId);
858 
859       emit BetAccepted(opBetId, lastBetId, nextRoundId);
860     }
861     _incTotalReserved(msg.value);
862 
863     // update last affiliate
864     aff.setUpAffCodeByAddr(bet.bettor, _affCode);
865   }
866 
867   function _startNextRound() internal returns (uint nextRoundId) {
868     uint nextStartAt;
869     uint nextFinishAt;
870     (nextRoundId, nextStartAt, nextFinishAt) = getNextRoundInfo();
871     
872     if (betRounds[nextRoundId].startedAt == 0) {
873       betRounds[nextRoundId].startedAt = nextStartAt;
874       roundsList.push(nextRoundId);
875       emit StartBetRound(nextRoundId, nextStartAt, nextFinishAt);
876     }
877   }
878 
879   function cancelBettorBet(address bettor, uint betIndex) external onlyService {
880     _cancelBet(bettors[bettor].bets[betIndex]);
881   }
882 
883   function cancelMyBet(uint betIndex) external nonReentrant {
884     _cancelBet(bettors[msg.sender].bets[betIndex]);
885   }
886 
887   function cancelBet(uint betId) external nonReentrant {
888     require(bets[betId].bettor == msg.sender);
889     _cancelBet(betId);
890   }
891 
892   function _cancelBet(uint betId) internal {
893     Bet storage bet = bets[betId];
894     require(bet.active);
895     //can cancel only not yet accepted bets
896     require(bet.roundId == 0);
897 
898     //upd queue
899     BetData storage allyData = betData[bet.level][bet.allyRace][bet.enemyRace];
900     allyData.queue.remove(betId);
901 
902     _decTotalReserved(bet.value);
903     bet.bettor.transfer(bet.value);
904     emit BetCanceled(betId);
905 
906     // del bet
907     delete bets[betId];
908   }
909 
910 
911   function _calcRoundLevel(uint level, uint allyRace, uint enemyRace, uint roundId) internal returns (int32 allyResult, int32 enemyResult){
912     require(betRounds[roundId].startedAt != 0 && betRounds[roundId].finishedAt != 0);
913 
914     allyResult = betRounds[roundId].races[allyRace].result;
915     enemyResult = betRounds[roundId].races[enemyRace].result;
916 
917     if (allyResult < enemyResult) {
918       (allyRace, enemyRace) = (enemyRace, allyRace);
919     }
920     BetData storage winnerData = betData[level][allyRace][enemyRace];
921     BetData storage loserData = betData[level][enemyRace][allyRace];
922 
923     if (!loserData.stat[roundId].taxed) {
924       loserData.stat[roundId].taxed = true;
925 
926       //check if really winner
927       if (allyResult != enemyResult) {
928         //system fee
929         uint fee = _getPercent(loserData.stat[roundId].sum, systemFeePcnt);
930         _decTotalReserved(fee);
931 
932         //affiliate %
933         winnerData.stat[roundId].affPool = _getPercent(loserData.stat[roundId].sum, affPoolPcnt);
934         //calc pool for round
935         winnerData.stat[roundId].pool = loserData.stat[roundId].sum - fee - winnerData.stat[roundId].affPool;
936 
937         emit BetRoundCalculated(roundId, allyRace, enemyRace, level, winnerData.stat[roundId].pool, winnerData.stat[roundId].count);
938       }
939     }
940 
941     if (!winnerData.stat[roundId].taxed) {
942       winnerData.stat[roundId].taxed = true;
943     }
944   }
945 
946   function rewardBettorBet(address bettor, uint betIndex) external onlyService {
947     _rewardBet(bettors[bettor].bets[betIndex]);
948   }
949 
950   function rewardMyBet(uint betIndex) external nonReentrant {
951     _rewardBet(bettors[msg.sender].bets[betIndex]);
952   }
953 
954   function rewardBet(uint betId) external nonReentrant {
955     require(bets[betId].bettor == msg.sender);
956     _rewardBet(betId);
957   }
958 
959 
960   function _rewardBet(uint betId) internal {
961     Bet storage bet = bets[betId];
962     require(bet.active);
963     //only accepted bets
964     require(bet.roundId != 0);
965     (int32 allyResult, int32 enemyResult) = _calcRoundLevel(bet.level, bet.allyRace, bet.enemyRace, bet.roundId);
966 
967     //disabling bet
968     bet.active = false;
969     if (allyResult >= enemyResult) {
970       bet.reward = bet.value;
971       if (allyResult > enemyResult) {
972         //win
973         BetStat memory s = betData[bet.level][bet.allyRace][bet.enemyRace].stat[bet.roundId];
974         bet.reward = bet.reward.add(s.pool / s.count);
975 
976         // winner's affiliates + loser's affiliates
977         uint affPool = s.affPool / s.count;
978         _decTotalReserved(affPool);
979         // affiliate pool is 1/2 of total aff. pool, per each winner and loser
980         _distributeAffiliateReward(affPool >> 1, aff.getAffCode(uint(bet.bettor)), 0, false); //no cacheback to winner
981         _distributeAffiliateReward(affPool >> 1, aff.getAffCode(uint(bets[bet.opBetId].bettor)), 0, true); //cacheback to looser
982       }
983 
984 
985       bet.bettor.transfer(bet.reward);
986       _decTotalReserved(bet.reward);
987       emit BetRewarded(betId, bet.opBetId, bet.reward, allyResult == enemyResult);
988     }
989     _flushBalance();
990   }
991 
992 
993   function provisionBetReward(uint betId) public view returns (uint reward) {
994     Bet storage bet = bets[betId];
995     if (!bet.active) {
996       return 0;
997     }
998 
999     int32 allyResult = betRounds[bet.roundId].races[bet.allyRace].result;
1000     int32 enemyResult = betRounds[bet.roundId].races[bet.enemyRace].result;
1001 
1002     if (allyResult < enemyResult) {
1003       return 0;
1004     }
1005     reward = bet.value;
1006 
1007     BetData storage allyData = betData[bet.level][bet.allyRace][bet.enemyRace];
1008     BetData storage enemyData = betData[bet.level][bet.enemyRace][bet.allyRace];
1009 
1010     if (allyResult > enemyResult) {
1011       //win
1012       if (!enemyData.stat[bet.roundId].taxed) {
1013         uint pool = enemyData.stat[bet.roundId].sum - _getPercent(enemyData.stat[bet.roundId].sum, systemFeePcnt + affPoolPcnt);
1014         reward = bet.value.add(pool / allyData.stat[bet.roundId].count);
1015       } else {
1016         reward = bet.value.add(allyData.stat[bet.roundId].pool / allyData.stat[bet.roundId].count);
1017       }
1018     }
1019   }
1020 
1021   function provisionBettorBetReward(address bettor, uint betIndex) public view returns (uint reward) {
1022     return provisionBetReward(bettors[bettor].bets[betIndex]);
1023   }
1024 
1025   function finalizeBetRound(uint betLevel, uint allyRace, uint enemyRace, uint roundId) external onlyService {
1026     _calcRoundLevel(betLevel, allyRace, enemyRace, roundId);
1027     _flushBalance();
1028   }
1029 
1030   function roundsCount() external view returns (uint) {
1031     return roundsList.length;
1032   }
1033 
1034   function getBettorsBetCounter(address bettor) external view returns (uint) {
1035     return bettors[bettor].counter;
1036   }
1037 
1038   function getBettorsBetId(address bettor, uint betIndex) external view returns (uint betId) {
1039     return bettors[bettor].bets[betIndex];
1040   }
1041 
1042   function getBettorsBets(address bettor) external view returns (uint[] memory betIds) {
1043     Bettor storage b = bettors[bettor];
1044     uint j;
1045     for (uint i = 1; i <= b.counter; i++) {
1046       if (b.bets[i] != 0) {
1047         j++;
1048       }
1049     }
1050     if (j > 0) {
1051       betIds = new uint[](j);
1052       j = 0;
1053       for (uint i = 1; i <= b.counter; i++) {
1054         if (b.bets[i] != 0) {
1055           betIds[j++] = b.bets[i];
1056         }
1057       }
1058     }
1059   }
1060 
1061 
1062   function getBet(uint betId) public view returns (
1063     address bettor,
1064     bool active,
1065     uint roundId,
1066     uint allyRace,
1067     uint enemyRace,
1068     uint value,
1069     uint level,
1070     uint opBetId,
1071     uint reward
1072   ) {
1073     Bet memory b = bets[betId];
1074     return (b.bettor, b.active, b.roundId, b.allyRace, b.enemyRace, b.value, b.level, b.opBetId, b.reward);
1075   }
1076 
1077   function getBetRoundStat(uint roundId, uint allyRace, uint enemyRace, uint level) public view returns (
1078     uint sum,
1079     uint pool,
1080     uint affPool,
1081     uint count,
1082     bool taxed
1083   ) {
1084     BetStat memory bs = betData[level][allyRace][enemyRace].stat[roundId];
1085     return (bs.sum, bs.pool, bs.affPool, bs.count, bs.taxed);
1086   }
1087 
1088   function getBetQueueLength(uint allyRace, uint enemyRace, uint level) public view returns (uint) {
1089     return betData[level][allyRace][enemyRace].queue.len();
1090   }
1091 
1092   function getCurrentBetRound() public view returns (
1093     uint roundId,
1094     uint startedAt,
1095     uint finishedAt,
1096     uint startCheckedAt,
1097     uint finishCheckedAt,
1098     uint betsCount,
1099     uint raceCount
1100   ) {
1101     roundId = getCurrentRoundId();
1102     (startedAt, finishedAt, startCheckedAt, finishCheckedAt, betsCount, raceCount) = getBetRound(roundId);
1103   }
1104 
1105   function getNextBetRound() public view returns (
1106     uint roundId,
1107     uint startedAt,
1108     uint finishedAt,
1109     uint startCheckedAt,
1110     uint finishCheckedAt,
1111     uint betsCount,
1112     uint raceCount
1113   ) {
1114     roundId = getCurrentRoundId() + 1;
1115     (startedAt, finishedAt, startCheckedAt, finishCheckedAt, betsCount, raceCount) = getBetRound(roundId);
1116   }
1117 
1118   function getBetRound(uint roundId) public view returns (
1119     uint startedAt,
1120     uint finishedAt,
1121     uint startCheckedAt,
1122     uint finishCheckedAt,
1123     uint betsCount,
1124     uint raceCount
1125   ) {
1126     BetRound memory b = betRounds[roundId];
1127     return (b.startedAt, b.finishedAt, b.startCheckedAt, b.finishCheckedAt, b.bets.length, b.raceList.length);
1128   }
1129 
1130   function getBetRoundBets(uint roundId) public view returns (uint[] memory betIds) {
1131     return betRounds[roundId].bets;
1132   }
1133 
1134   function getBetRoundBetId(uint roundId, uint betIndex) public view returns (uint betId) {
1135     return betRounds[roundId].bets[betIndex];
1136   }
1137 
1138 
1139   function getBetRoundRaces(uint roundId) public view returns (uint[] memory raceIds) {
1140     return betRounds[roundId].raceList;
1141   }
1142 
1143   function getBetRoundRaceStat(uint roundId, uint raceId) external view returns (
1144     uint index,
1145     uint count,
1146     int32 result
1147   ){
1148     Race memory r = betRounds[roundId].races[raceId];
1149     return (r.index, r.count, r.result);
1150   }
1151 
1152   function setBetRoundResult(uint roundId, uint count, uint[] memory packedRaces, uint[] memory packedResults) public onlyService {
1153     require(packedRaces.length == packedResults.length);
1154     require(packedRaces.length * 8 >= count);
1155 
1156     BetRound storage r = betRounds[roundId];
1157     require(r.startedAt != 0 && r.finishedAt == 0);
1158 
1159     uint raceId;
1160     int32 result;
1161     for (uint i = 0; i < count; i++) {
1162       raceId = _upack(packedRaces[i / 8], i % 8);
1163       result = int32(_upack(packedResults[i / 8], i % 8));
1164       r.races[raceId].result = result;
1165       emit RoundRaceResult(roundId, raceId, result);
1166     }
1167   }
1168 
1169   function finishBetRound(uint roundId, uint startCheckedAt, uint finishCheckedAt) public onlyService {
1170     BetRound storage r = betRounds[roundId];
1171     require(r.startedAt != 0 && r.finishedAt == 0);
1172     uint finishAt;
1173     (, , finishAt) = getRoundInfoAt(r.startedAt, 0);
1174     require(now >= finishAt);
1175     r.finishedAt = finishAt;
1176     r.startCheckedAt = startCheckedAt;
1177     r.finishCheckedAt = finishCheckedAt;
1178     emit FinishBetRound(roundId, startCheckedAt, finishCheckedAt);
1179   }
1180 
1181   //extract n-th 32-bit int from uint
1182   function _upack(uint _v, uint _n) internal pure returns (uint) {
1183     //    _n = _n & 7; //be sure < 8
1184     return (_v >> (32 * _n)) & 0xFFFFFFFF;
1185   }
1186 
1187 }