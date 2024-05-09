1 pragma solidity ^0.4.24;
2 
3 library DataSet {
4 
5     enum RoundState {
6         UNKNOWN,        // aim to differ from normal states
7         STARTED,        // start current round
8         STOPPED,        // stop current round
9         DRAWN,          // draw winning number
10         ASSIGNED        // assign to foundation, winner
11     }
12 
13     struct Round {
14         uint256                         count;              // record total numbers sold already
15         uint256                         timestamp;          // timestamp refer to first bet(round start)
16         uint256                         blockNumber;        // block number refer to last bet
17         uint256                         drawBlockNumber;    // block number refer to draw winning number
18         RoundState                      state;              // round state
19         uint256                         pond;               // amount refer to current round
20         uint256                         winningNumber;      // winning number
21         address                         winner;             // winner's address
22     }
23 
24 }
25 
26 /**
27  * @title NumberCompressor
28  * @dev Number compressor to storage the begin and end numbers into a uint256
29  */
30 library NumberCompressor {
31 
32     uint256 constant private MASK = 16777215;   // 2 ** 24 - 1
33 
34     function encode(uint256 _begin, uint256 _end, uint256 _ceiling) internal pure returns (uint256)
35     {
36         require(_begin <= _end && _end < _ceiling, "number is invalid");
37 
38         return _begin << 24 | _end;
39     }
40 
41     function decode(uint256 _value) internal pure returns (uint256, uint256)
42     {
43         uint256 end = _value & MASK;
44         uint256 begin = (_value >> 24) & MASK;
45         return (begin, end);
46     }
47 
48 }
49 
50 /**
51  * @title SafeMath v0.1.9
52  * @dev Math operations with safety checks that throw on error
53  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
54  * - added sqrt
55  * - added sq
56  * - added pwr
57  * - changed asserts to requires with error log outputs
58  * - removed div, its useless
59  */
60 library SafeMath {
61 
62     /**
63     * @dev Multiplies two numbers, throws on overflow.
64     */
65     function mul(uint256 a, uint256 b)
66         internal
67         pure
68         returns (uint256 c)
69     {
70         if (a == 0) {
71             return 0;
72         }
73         c = a * b;
74         require(c / a == b, "SafeMath mul failed");
75         return c;
76     }
77 
78     /**
79     * @dev Integer division of two numbers, truncating the quotient.
80     */
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         // assert(b > 0); // Solidity automatically throws when dividing by 0
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85         return c;
86     }
87 
88     /**
89     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b)
92         internal
93         pure
94         returns (uint256)
95     {
96         require(b <= a, "SafeMath sub failed");
97         return a - b;
98     }
99 
100     /**
101     * @dev Adds two numbers, throws on overflow.
102     */
103     function add(uint256 a, uint256 b)
104         internal
105         pure
106         returns (uint256 c)
107     {
108         c = a + b;
109         require(c >= a, "SafeMath add failed");
110         return c;
111     }
112 
113     /**
114      * @dev gives square root of given x.
115      */
116     function sqrt(uint256 x)
117         internal
118         pure
119         returns (uint256 y)
120     {
121         uint256 z = ((add(x,1)) / 2);
122         y = x;
123         while (z < y)
124         {
125             y = z;
126             z = ((add((x / z),z)) / 2);
127         }
128     }
129 
130     /**
131      * @dev gives square. multiplies x by x
132      */
133     function sq(uint256 x)
134         internal
135         pure
136         returns (uint256)
137     {
138         return (mul(x,x));
139     }
140 
141     /**
142      * @dev x to the power of y
143      */
144     function pwr(uint256 x, uint256 y)
145         internal
146         pure
147         returns (uint256)
148     {
149         if (x==0)
150             return (0);
151         else if (y==0)
152             return (1);
153         else
154         {
155             uint256 z = x;
156             for (uint256 i=1; i < y; i++)
157                 z = mul(z,x);
158             return (z);
159         }
160     }
161 
162     function min(uint x, uint y) internal pure returns (uint z) {
163         return x <= y ? x : y;
164     }
165 
166     function max(uint x, uint y) internal pure returns (uint z) {
167         return x >= y ? x : y;
168     }
169 }
170 
171 contract Events {
172 
173     event onActivate
174     (
175         address indexed addr,
176         uint256 timestamp,
177         uint256 bonus,
178         uint256 issued_numbers
179     );
180 
181     event onDraw
182     (
183         uint256 timestatmp,
184         uint256 blockNumber,
185         uint256 roundID,
186         uint256 winningNumber
187     );
188 
189     event onStartRunnd
190     (
191         uint256 timestamp,
192         uint256 roundID
193     );
194 
195     event onBet
196     (
197         address indexed addr,
198         uint256 timestamp,
199         uint256 roundID,
200         uint256 beginNumber,
201         uint256 endNumber
202     );
203 
204     event onAssign
205     (
206         address indexed operatorAddr,
207         uint256 timestatmp,
208         address indexed winnerAddr,
209         uint256 roundID,
210         uint256 pond,
211         uint256 bonus,      // assigned to winner
212         uint256 fund        // assigned to platform
213     );
214 
215     event onRefund
216     (
217         address indexed operatorAddr,
218         uint256 timestamp,
219         address indexed playerAddr,
220         uint256 count,
221         uint256 amount
222     );
223 
224     event onLastRefund
225     (
226         address indexed operatorAddr,
227         uint256 timestamp,
228         address indexed platformAddr,
229         uint256 amout
230     );
231 
232 }
233 
234 contract Winner is Events {
235 
236     using SafeMath for *;
237 
238     uint256     constant private    MIN_BET = 0.01 ether;                                   // min bet every time
239     uint256     constant private    PRICE   = 0.01 ether;                                   // 0.01 ether every number
240     uint256     constant private    MAX_DURATION = 30 days;                                 // max duration every round
241     uint256     constant private    REFUND_RATE = 90;                                       // refund rate to player(%)
242     address     constant private    platform = 0x1f79bfeCe98447ac5466Fd9b8F71673c780566Df;  // paltform's address
243     uint256     private             curRoundID;                                             // current round
244     uint256     private             drawnRoundID;                                           // already drawn round
245     uint256     private             drawnBlockNumber;                                       // already drawn a round in block
246     uint256     private             bonus;                                                  // bonus assigned to the winner
247     uint256     private             issued_numbers;                                         // total numbers every round
248     bool        private             initialized;                                            // game is initialized or not
249 
250     // (roundID => data) returns round data
251     mapping (uint256 => DataSet.Round) private rounds;
252     // (roundID => address => numbers) returns player's numbers in round
253     mapping (uint256 => mapping(address => uint256[])) private playerNumbers;
254     mapping (address => bool) private administrators;
255 
256     // default constructor
257     constructor() public {
258     }
259 
260     /**
261      * @dev check sender must be administrators
262      */
263     modifier isAdmin() {
264         require(administrators[msg.sender], "only administrators");
265         _;
266     }
267 
268     /**
269      * @dev make sure no one can interact with contract until it has
270      * been initialized.
271      */
272     modifier isInitialized () {
273         require(initialized == true, "game is inactive");
274         _;
275     }
276 
277     /**
278      * @dev prevent contract from interacting with external contracts.
279      */
280     modifier isHuman() {
281         address _addr = msg.sender;
282         uint256 _codeLength;
283 
284         assembly {_codeLength := extcodesize(_addr)}
285         require(_codeLength == 0, "sorry, humans only");
286         _;
287     }
288 
289     /**
290      * @dev check the bet's bound
291      * @param _eth the eth amount
292      * In order to ensure as many as possiable players envolve in the
293      * game, you can only buy no more than 2 * issued_numbers every time.
294      */
295     modifier isWithinLimits(uint256 _eth) {
296         require(_eth >= MIN_BET, "the bet is too small");
297         require(_eth <= PRICE.mul(issued_numbers).mul(2), "the bet is too big");
298         _;
299     }
300 
301     /**
302      * @dev default to bet
303      */
304     function() public payable isHuman() isInitialized() isWithinLimits(msg.value)
305     {
306         bet(msg.value);
307     }
308 
309     /**
310      * @dev initiate game
311      * @param _bonus the bonus assigned the winner every round
312      * @param _issued_numbers the quantity of candidate numbers every round
313      */
314     function initiate(uint256 _bonus, uint256 _issued_numbers) public isHuman()
315     {
316         // can only be initialized once
317         require(initialized == false, "it has been initialized already");
318         require(_bonus > 0, "bonus is invalid");
319         require(_issued_numbers > 0, "issued_numbers is invalid");
320 
321         // initiate global parameters
322         initialized = true;
323         administrators[msg.sender] = true;
324         bonus = _bonus;
325         issued_numbers = _issued_numbers;
326 
327         emit onActivate(msg.sender, block.timestamp, bonus, issued_numbers);
328 
329         // start the first round game
330         curRoundID = 1;
331         rounds[curRoundID].state = DataSet.RoundState.STARTED;
332         rounds[curRoundID].timestamp = block.timestamp;
333         drawnRoundID = 0;
334 
335         emit onStartRunnd(block.timestamp, curRoundID);
336     }
337 
338     /**
339      * @dev draw winning number
340      */
341     function drawNumber() private view returns(uint256) {
342         return uint256(keccak256(abi.encodePacked(
343 
344             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number))))) / (block.timestamp)).add
345             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 1))))) / (block.timestamp)).add
346             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 2))))) / (block.timestamp)).add
347             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 3))))) / (block.timestamp)).add
348             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 4))))) / (block.timestamp)).add
349             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 5))))) / (block.timestamp)).add
350             ((uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 6))))) / (block.timestamp))
351 
352         ))) % issued_numbers;
353 
354     }
355 
356     /**
357      * @dev bet
358      * @param _amount the amount for a bet
359      */
360     function bet(uint256 _amount) private
361     {
362         // 1. draw the winning number if it is necessary
363         if (block.number != drawnBlockNumber
364             && curRoundID > drawnRoundID
365             && rounds[drawnRoundID + 1].count == issued_numbers
366             && block.number >= rounds[drawnRoundID + 1].blockNumber + 7)
367         {
368             drawnBlockNumber = block.number;
369             drawnRoundID += 1;
370 
371             rounds[drawnRoundID].winningNumber = drawNumber();
372             rounds[drawnRoundID].state = DataSet.RoundState.DRAWN;
373             rounds[drawnRoundID].drawBlockNumber = drawnBlockNumber;
374 
375             emit onDraw(block.timestamp, drawnBlockNumber, drawnRoundID, rounds[drawnRoundID].winningNumber);
376         }
377 
378         // 2. bet
379         uint256 amount = _amount;
380         while (true)
381         {
382             // in every round, one can buy min(max, available) numbers.
383             uint256 max = issued_numbers - rounds[curRoundID].count;
384             uint256 available = amount.div(PRICE).min(max);
385 
386             if (available == 0)
387             {
388                 // on condition that the PRICE is 0.01 eth, if the player pays 0.056 eth for
389                 // a bet, then the player can exchange only five number, as 0.056/0.01 = 5,
390                 // and the rest 0.06 eth distributed to the pond of current round.
391                 if (amount != 0)
392                 {
393                     rounds[curRoundID].pond += amount;
394                 }
395                 break;
396             }
397             uint256[] storage numbers = playerNumbers[curRoundID][msg.sender];
398             uint256 begin = rounds[curRoundID].count;
399             uint256 end = begin + available - 1;
400             uint256 compressedNumber = NumberCompressor.encode(begin, end, issued_numbers);
401             numbers.push(compressedNumber);
402             rounds[curRoundID].pond += available.mul(PRICE);
403             rounds[curRoundID].count += available;
404             amount -= available.mul(PRICE);
405 
406             emit onBet(msg.sender, block.timestamp, curRoundID, begin, end);
407 
408             if (rounds[curRoundID].count == issued_numbers)
409             {
410                 // end current round and start the next round
411                 rounds[curRoundID].blockNumber = block.number;
412                 rounds[curRoundID].state = DataSet.RoundState.STOPPED;
413                 curRoundID += 1;
414                 rounds[curRoundID].state = DataSet.RoundState.STARTED;
415                 rounds[curRoundID].timestamp = block.timestamp;
416 
417                 emit onStartRunnd(block.timestamp, curRoundID);
418             }
419         }
420     }
421 
422     /**
423      * @dev assign for a round
424      * @param _roundID the round ID
425      */
426     function assign(uint256 _roundID) external isHuman() isInitialized()
427     {
428         assign2(msg.sender, _roundID);
429     }
430 
431     /**
432      * @dev assign for a round
433      * @param _player the player's address
434      * @param _roundID the round ID
435      */
436     function assign2(address _player, uint256 _roundID) public isHuman() isInitialized()
437     {
438         require(rounds[_roundID].state == DataSet.RoundState.DRAWN, "it's not time for assigning");
439 
440         uint256[] memory numbers = playerNumbers[_roundID][_player];
441         require(numbers.length > 0, "player did not involve in");
442         uint256 targetNumber = rounds[_roundID].winningNumber;
443         for (uint256 i = 0; i < numbers.length; i ++)
444         {
445             (uint256 start, uint256 end) = NumberCompressor.decode(numbers[i]);
446             if (targetNumber >= start && targetNumber <= end)
447             {
448                 // assgin bonus to player, and the rest of the pond to platform
449                 uint256 fund = rounds[_roundID].pond.sub(bonus);
450                 _player.transfer(bonus);
451                 platform.transfer(fund);
452                 rounds[_roundID].state = DataSet.RoundState.ASSIGNED;
453                 rounds[_roundID].winner = _player;
454 
455                 emit onAssign(msg.sender, block.timestamp, _player, _roundID, rounds[_roundID].pond, bonus, fund);
456 
457                 break;
458             }
459         }
460     }
461 
462     /**
463      * @dev refund to player and platform
464      */
465     function refund() external isHuman() isInitialized()
466     {
467         refund2(msg.sender);
468     }
469 
470     /**
471      * @dev refund to player and platform
472      * @param _player the player's address
473      */
474     function refund2(address _player) public isInitialized() isHuman()
475     {
476         require(block.timestamp.sub(rounds[curRoundID].timestamp) >= MAX_DURATION, "it's not time for refunding");
477 
478         // 1. count numbers owned by the player
479         uint256[] storage numbers = playerNumbers[curRoundID][_player];
480         require(numbers.length > 0, "player did not involve in");
481 
482         uint256 count = 0;
483         for (uint256 i = 0; i < numbers.length; i ++)
484         {
485             (uint256 begin, uint256 end) = NumberCompressor.decode(numbers[i]);
486             count += (end - begin + 1);
487         }
488 
489         // 2. refund 90% to the player
490         uint256 amount = count.mul(PRICE).mul(REFUND_RATE).div(100);
491         rounds[curRoundID].pond = rounds[curRoundID].pond.sub(amount);
492         _player.transfer(amount);
493 
494         emit onRefund(msg.sender, block.timestamp, _player, count, amount);
495 
496         // 3. refund the rest(abount 10% of the pond) to the platform if the player is the last to refund
497         rounds[curRoundID].count -= count;
498         if (rounds[curRoundID].count == 0)
499         {
500             uint256 last = rounds[curRoundID].pond;
501             platform.transfer(last);
502             rounds[curRoundID].pond = 0;
503 
504             emit onLastRefund(msg.sender, block.timestamp, platform, last);
505         }
506     }
507 
508     /**
509      * @dev return player's numbers in the round
510      * @param _roundID round ID
511      * @param _palyer player's address
512      * @return uint256[], player's numbers
513      */
514     function getPlayerRoundNumbers(uint256 _roundID, address _palyer) public view returns(uint256[])
515     {
516         return playerNumbers[_roundID][_palyer];
517     }
518 
519     /**
520      * @dev return round's information
521      * @param _roundID round ID
522      * @return uint256, quantity of round's numbers
523      * @return uint256, block number refer to last bet
524      * @return uint256, block number refer to draw winning number
525      * @return uint256, round's running state
526      * @return uint256, round's pond
527      * @return uint256, round's winning number if drawn
528      * @return address, round's winner if assigned
529      */
530     function getRoundInfo(uint256 _roundID) public view
531         returns(uint256, uint256, uint256, uint256, uint256, uint256, address)
532     {
533         return (
534             rounds[_roundID].count,
535             rounds[_roundID].blockNumber,
536             rounds[_roundID].drawBlockNumber,
537             uint256(rounds[_roundID].state),
538             rounds[_roundID].pond,
539             rounds[_roundID].winningNumber,
540             rounds[_roundID].winner
541         );
542     }
543 
544     /**
545      * @dev return game's information
546      * @return bool, game is active or not
547      * @return uint256, bonus assigned to the winner
548      * @return uint256, total numbers every round
549      * @return uint256, current round ID
550      * @return uint256, already drawn round ID
551      */
552     function gameInfo() public view
553         returns(bool, uint256, uint256, uint256, uint256)
554     {
555         return (
556             initialized,
557             bonus,
558             issued_numbers,
559             curRoundID,
560             drawnRoundID
561         );
562     }
563 }
564 
565 /**
566  * @title Proxy
567  * @dev Gives the possibility to delegate any call to a foreign implementation.
568  */
569 contract Proxy {
570     /**
571     * @dev Tells the address of the implementation where every call will be delegated.
572     * @return address of the implementation to which it will be delegated
573     */
574     function implementation() public view returns (address);
575 
576     /**
577     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
578     * This function will return whatever the implementation call returns
579     */
580     function () public payable {
581         address _impl = implementation();
582         require(_impl != address(0), "address invalid");
583 
584         assembly {
585             let ptr := mload(0x40)
586             calldatacopy(ptr, 0, calldatasize)
587             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
588             let size := returndatasize
589             returndatacopy(ptr, 0, size)
590 
591             switch result
592             case 0 { revert(ptr, size) }
593             default { return(ptr, size) }
594         }
595     }
596 }
597 
598 /**
599  * @title UpgradeabilityProxy
600  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
601  */
602 contract UpgradeabilityProxy is Proxy {
603     /**
604     * @dev This event will be emitted every time the implementation gets upgraded
605     * @param implementation representing the address of the upgraded implementation
606     */
607     event Upgraded(address indexed implementation);
608 
609     // Storage position of the address of the current implementation
610     bytes32 private constant implementationPosition = keccak256("you are the lucky man.proxy");
611 
612     /**
613     * @dev Constructor function
614     */
615     constructor() public {}
616 
617     /**
618     * @dev Tells the address of the current implementation
619     * @return address of the current implementation
620     */
621     function implementation() public view returns (address impl) {
622         bytes32 position = implementationPosition;
623         assembly {
624             impl := sload(position)
625         }
626     }
627 
628     /**
629     * @dev Sets the address of the current implementation
630     * @param newImplementation address representing the new implementation to be set
631     */
632     function setImplementation(address newImplementation) internal {
633         bytes32 position = implementationPosition;
634         assembly {
635             sstore(position, newImplementation)
636         }
637     }
638 
639     /**
640     * @dev Upgrades the implementation address
641     * @param newImplementation representing the address of the new implementation to be set
642     */
643     function _upgradeTo(address newImplementation) internal {
644         address currentImplementation = implementation();
645         require(currentImplementation != newImplementation, "new address is the same");
646         setImplementation(newImplementation);
647         emit Upgraded(newImplementation);
648     }
649 }
650 
651 /**
652  * @title OwnedUpgradeabilityProxy
653  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
654  */
655 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
656     /**
657     * @dev Event to show ownership has been transferred
658     * @param previousOwner representing the address of the previous owner
659     * @param newOwner representing the address of the new owner
660     */
661     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
662 
663     // Storage position of the owner of the contract
664     bytes32 private constant proxyOwnerPosition = keccak256("you are the lucky man.proxy.owner");
665 
666     /**
667     * @dev the constructor sets the original owner of the contract to the sender account.
668     */
669     constructor() public {
670         setUpgradeabilityOwner(msg.sender);
671     }
672 
673     /**
674     * @dev Throws if called by any account other than the owner.
675     */
676     modifier onlyProxyOwner() {
677         require(msg.sender == proxyOwner(), "owner only");
678         _;
679     }
680 
681     /**
682     * @dev Tells the address of the owner
683     * @return the address of the owner
684     */
685     function proxyOwner() public view returns (address owner) {
686         bytes32 position = proxyOwnerPosition;
687         assembly {
688             owner := sload(position)
689         }
690     }
691 
692     /**
693     * @dev Sets the address of the owner
694     */
695     function setUpgradeabilityOwner(address newProxyOwner) internal {
696         bytes32 position = proxyOwnerPosition;
697         assembly {
698             sstore(position, newProxyOwner)
699         }
700     }
701 
702     /**
703     * @dev Allows the current owner to transfer control of the contract to a newOwner.
704     * @param newOwner The address to transfer ownership to.
705     */
706     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
707         require(newOwner != address(0), "address is invalid");
708         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
709         setUpgradeabilityOwner(newOwner);
710     }
711 
712     /**
713     * @dev Allows the proxy owner to upgrade the current version of the proxy.
714     * @param implementation representing the address of the new implementation to be set.
715     */
716     function upgradeTo(address implementation) public onlyProxyOwner {
717         _upgradeTo(implementation);
718     }
719 
720     /**
721     * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
722     * to initialize whatever is needed through a low level call.
723     * @param implementation representing the address of the new implementation to be set.
724     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
725     * signature of the implementation to be called with the needed payload
726     */
727     function upgradeToAndCall(address implementation, bytes data) public payable onlyProxyOwner {
728         upgradeTo(implementation);
729         require(address(this).call.value(msg.value)(data), "data is invalid");
730     }
731 }