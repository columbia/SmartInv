1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7     address private _owner;
8 
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     constructor () internal {
16         _owner = msg.sender;
17         emit OwnershipTransferred(address(0), _owner);
18     }
19 
20     /**
21      * @return the address of the owner.
22      */
23     function owner() public view returns (address) {
24         return _owner;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(isOwner());
32         _;
33     }
34 
35     /**
36      * @return true if `msg.sender` is the owner of the contract.
37      */
38     function isOwner() public view returns (bool) {
39         return msg.sender == _owner;
40     }
41 
42     /**
43      * @dev Allows the current owner to relinquish control of the contract.
44      * @notice Renouncing to ownership will leave the contract without an owner.
45      * It will not be possible to call the functions with the `onlyOwner`
46      * modifier anymore.
47      */
48     function renounceOwnership() public onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param newOwner The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner) public onlyOwner {
58         _transferOwnership(newOwner);
59     }
60 
61     /**
62      * @dev Transfers control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function _transferOwnership(address newOwner) internal {
66         require(newOwner != address(0));
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 }
71 /**
72  * @title SafeMath
73  * @dev Unsigned math operations with safety checks that revert on error
74  */
75 library SafeMath {
76     /**
77      * @dev Multiplies two unsigned integers, reverts on overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b);
89 
90         return c;
91     }
92 
93     /**
94      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Solidity only automatically asserts when dividing by 0
98         require(b > 0);
99         uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102         return c;
103     }
104 
105     /**
106      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         require(b <= a);
110         uint256 c = a - b;
111 
112         return c;
113     }
114 
115     /**
116      * @dev Adds two unsigned integers, reverts on overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a);
121 
122         return c;
123     }
124 
125     /**
126      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
127      * reverts when dividing by zero.
128      */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b != 0);
131         return a % b;
132     }
133 }
134 contract SimpleToken is Ownable {
135     using SafeMath for uint256;
136 
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 
139     mapping (address => uint256) private _balances;
140 
141     uint256 private _totalSupply;
142 
143     /**
144      * @dev Total number of tokens in existence
145      */
146     function totalSupply() public view returns (uint256) {
147         return _totalSupply;
148     }
149 
150     /**
151      * @dev Gets the balance of the specified address.
152      * @param owner The address to query the balance of.
153      * @return An uint256 representing the amount owned by the passed address.
154      */
155     function balanceOf(address owner) public view returns (uint256) {
156         return _balances[owner];
157     }
158 
159     /**
160      * @dev Transfer token for a specified address
161      * @param to The address to transfer to.
162      * @param value The amount to be transferred.
163      */
164     function transfer(address to, uint256 value) public returns (bool) {
165         _transfer(msg.sender, to, value);
166         return true;
167     }
168 
169 
170     /**
171      * @dev Transfer token for a specified addresses
172      * @param from The address to transfer from.
173      * @param to The address to transfer to.
174      * @param value The amount to be transferred.
175      */
176     function _transfer(address from, address to, uint256 value) internal {
177         require(to != address(0));
178         require(value <= _balances[from]); // Check there is enough balance.
179 
180         _balances[from] = _balances[from].sub(value);
181         _balances[to] = _balances[to].add(value);
182         emit Transfer(from, to, value);
183     }
184 
185     /**
186      * @dev public function that mints an amount of the token and assigns it to
187      * an account. This encapsulates the modification of balances such that the
188      * proper events are emitted.
189      * @param account The account that will receive the created tokens.
190      * @param value The amount that will be created.
191      */
192     function _mint(address account, uint256 value) internal {
193         require(account != address(0));
194 
195         _totalSupply = _totalSupply.add(value);
196         _balances[account] = _balances[account].add(value);
197         emit Transfer(address(0), account, value);
198     }
199 }
200 contract Manageable is Ownable {
201     mapping(address => bool) public listOfManagers;
202 
203     modifier onlyManager() {
204         require(listOfManagers[msg.sender], "");
205         _;
206     }
207 
208     function addManager(address _manager) public onlyOwner returns (bool success) {
209         if (!listOfManagers[_manager]) {
210             require(_manager != address(0), "");
211             listOfManagers[_manager] = true;
212             success = true;
213         }
214     }
215 
216     function removeManager(address _manager) public onlyOwner returns (bool success) {
217         if (listOfManagers[_manager]) {
218             listOfManagers[_manager] = false;
219             success = true;
220         }
221     }
222 
223     function getInfo(address _manager) public view returns (bool) {
224         return listOfManagers[_manager];
225     }
226 }
227 
228 
229 contract iRNG {
230     function update(uint roundNumber, uint additionalNonce, uint period) public payable;
231     function __callback(bytes32 _queryId, uint _result) public;
232 }
233 
234 
235 contract iKYCWhitelist {
236     function isWhitelisted(address _participant) public view returns (bool);
237 }
238 
239 contract BaseLottery is Manageable {
240     using SafeMath for uint;
241 
242     enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
243 
244     struct Round {
245         RoundState state;
246         uint ticketsCount;
247         uint participantCount;
248         TicketsInterval[] tickets;
249         address[] participants;
250         uint random;
251         uint nonce; //xored participants addresses
252         uint startRoundTime;
253         uint[] winningTickets;
254         address[] winners;
255         uint roundFunds;
256         mapping(address => uint) winnersFunds;
257         mapping(address => uint) participantFunds;
258         mapping(address => bool) sendGain;
259     }
260 
261     struct TicketsInterval {
262         address participant;
263         uint firstTicket;
264         uint lastTicket;
265     }
266 
267     uint constant public NUMBER_OF_WINNERS = 10;
268     uint constant public SHARE_DENOMINATOR = 10000;
269     //uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
270     uint public ORACLIZE_TIMEOUT = 86400;  // only for tests
271     uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
272     address payable public organiser;
273     uint constant public ORGANISER_PERCENT = 20;
274     uint constant public ROUND_FUND_PERCENT = 80;
275 
276     iKYCWhitelist public KYCWhitelist;
277 
278     uint public period;
279     address public mainLottery;
280     address public management;
281     address payable public rng;
282 
283     mapping (uint => Round) public rounds;
284 
285     uint public ticketPrice;
286     uint public currentRound;
287 
288     event LotteryStarted(uint start);
289     event RoundStateChanged(uint currentRound, RoundState state);
290     event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
291     event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
292     event RefundIsSuccess(uint round, address participant, uint funds);
293     event RefundIsFailed(uint round, address participant);
294     event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
295     event AddressIsNotAddedInKYC(address participant);
296     event TicketPriceChanged(uint price);
297 
298     modifier onlyRng {
299         require(msg.sender == address(rng), "");
300         _;
301     }
302 
303     modifier onlyLotteryContract {
304         require(msg.sender == address(mainLottery) || msg.sender == management, "");
305         _;
306     }
307 
308     constructor (address payable _rng, uint _period) public {
309         require(_rng != address(0), "");
310         require(_period >= 60, "");
311 
312         rng = _rng;
313         period = _period;
314     }
315 
316     function setContracts(address payable _rng, address _mainLottery, address _management) public onlyOwner {
317         require(_rng != address(0), "");
318         require(_mainLottery != address(0), "");
319         require(_management != address(0), "");
320 
321         rng = _rng;
322         mainLottery = _mainLottery;
323         management = _management;
324     }
325 
326     function startLottery(uint _startPeriod) public payable onlyLotteryContract {
327         currentRound = 1;
328         uint time = getCurrentTime().add(_startPeriod).sub(period);
329         rounds[currentRound].startRoundTime = time;
330         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
331 
332         iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
333 
334         emit LotteryStarted(time);
335     }
336 
337     function buyTickets(address _participant) public payable onlyLotteryContract {
338         uint funds = msg.value;
339 
340         updateRoundTimeAndState();
341         addParticipant(_participant, funds.div(ticketPrice));
342         updateRoundFundsAndParticipants(_participant, funds);
343 
344         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
345             rounds[currentRound].participantCount >= 10
346         ) {
347             _restartLottery();
348         }
349     }
350 
351     function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyLotteryContract {
352         updateRoundTimeAndState();
353         addParticipant(_participant, _ticketsCount);
354         updateRoundFundsAndParticipants(_participant, uint(0));
355 
356         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
357             rounds[currentRound].participantCount >= 10
358         ) {
359             _restartLottery();
360         }
361     }
362 
363     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
364         if (rounds[_round].winners.length != 0) {
365             return true;
366         }
367 
368         if (checkRoundState(_round) == RoundState.REFUND) {
369             return true;
370         }
371 
372         if (rounds[_round].participantCount < 10) {
373             rounds[_round].state = RoundState.ACCEPT_FUNDS;
374             emit RoundStateChanged(_round, rounds[_round].state);
375             return true;
376         }
377 
378         rounds[_round].random = _randomNumber;
379         findWinTickets(_round);
380         findWinners(_round);
381         rounds[_round].state = RoundState.SUCCESS;
382         emit RoundStateChanged(_round, rounds[_round].state);
383 
384         if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
385             currentRound = _round.add(1);
386             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
387             emit RoundStateChanged(currentRound, rounds[currentRound].state);
388         }
389 
390         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
391         getRandomNumber(_round + 1, rounds[_round].nonce);
392         return true;
393     }
394 
395     function restartLottery() public payable onlyOwner {
396         _restartLottery();
397     }
398 
399     function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
400         iRNG(rng).update(_round, _nonce, period);
401     }
402 
403     function setTicketPrice(uint _ticketPrice) public onlyLotteryContract {
404         require(_ticketPrice > 0, "");
405 
406         emit TicketPriceChanged(_ticketPrice);
407         ticketPrice = _ticketPrice;
408     }
409 
410     function findWinTickets(uint _round) public {
411         uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
412 
413         for (uint i = 0; i < 10; i++) {
414             rounds[_round].winningTickets.push(winners[i]);
415         }
416     }
417 
418     function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
419         uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
420         uint winnersNum = 10;
421 
422         uint[10] memory winTickets;
423         uint shift = uint(256).div(winnersNum);
424 
425         for (uint i = 0; i < 10; i++) {
426             winTickets[i] =
427             uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
428         }
429 
430         return winTickets;
431     }
432 
433     function refund(uint _round) public {
434         if (checkRoundState(_round) == RoundState.REFUND
435         && rounds[_round].participantFunds[msg.sender] > 0
436         ) {
437             uint amount = rounds[_round].participantFunds[msg.sender];
438             rounds[_round].participantFunds[msg.sender] = 0;
439             address(msg.sender).transfer(amount);
440             emit RefundIsSuccess(_round, msg.sender, amount);
441         } else {
442             emit RefundIsFailed(_round, msg.sender);
443         }
444     }
445 
446     function checkRoundState(uint _round) public returns (RoundState) {
447         if (rounds[_round].state == RoundState.WAIT_RESULT
448         && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
449         ) {
450             rounds[_round].state = RoundState.REFUND;
451             emit RoundStateChanged(_round, rounds[_round].state);
452         }
453         return rounds[_round].state;
454     }
455 
456     function setOrganiser(address payable _organiser) public onlyOwner {
457         require(_organiser != address(0), "");
458 
459         organiser = _organiser;
460     }
461 
462     function setKYCWhitelist(address _KYCWhitelist) public onlyOwner {
463         require(_KYCWhitelist != address(0), "");
464 
465         KYCWhitelist = iKYCWhitelist(_KYCWhitelist);
466     }
467 
468     function getGain(uint _fromRound, uint _toRound) public {
469         _transferGain(msg.sender, _fromRound, _toRound);
470     }
471 
472     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
473         _transferGain(_participant, _fromRound, _toRound);
474     }
475 
476     function getTicketsCount(uint _round) public view returns (uint) {
477         return rounds[_round].ticketsCount;
478     }
479 
480     function getTicketPrice() public view returns (uint) {
481         return ticketPrice;
482     }
483 
484     function getCurrentTime() public view returns (uint) {
485         return now;
486     }
487 
488     function getPeriod() public view returns (uint) {
489         return period;
490     }
491 
492     function getRoundWinners(uint _round) public view returns (address[] memory) {
493         return rounds[_round].winners;
494     }
495 
496     function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
497         return rounds[_round].winningTickets;
498     }
499 
500     function getRoundParticipants(uint _round) public view returns (address[] memory) {
501         return rounds[_round].participants;
502     }
503 
504     function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
505         return rounds[_round].winnersFunds[_winner];
506     }
507 
508     function getRoundFunds(uint _round) public view returns (uint) {
509         return rounds[_round].roundFunds;
510     }
511 
512     function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
513         return rounds[_round].participantFunds[_participant];
514     }
515 
516     function getCurrentRound() public view returns (uint) {
517         return currentRound;
518     }
519 
520     function getRoundStartTime(uint _round) public view returns (uint) {
521         return rounds[_round].startRoundTime;
522     }
523 
524     function _restartLottery() internal {
525         uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
526         rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
527         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
528         emit RoundStateChanged(currentRound, rounds[currentRound].state);
529         iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
530     }
531 
532     function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
533         require(_fromRound <= _toRound, "");
534         require(_participant != address(0), "");
535 
536         if (KYCWhitelist.isWhitelisted(_participant)) {
537             uint funds;
538 
539             for (uint i = _fromRound; i <= _toRound; i++) {
540 
541                 if (rounds[i].state == RoundState.SUCCESS
542                 && rounds[i].sendGain[_participant] == false) {
543 
544                     rounds[i].sendGain[_participant] = true;
545                     funds = funds.add(getWinningFunds(i, _participant));
546                 }
547             }
548 
549             require(funds > 0, "");
550             _participant.transfer(funds);
551             emit Withdraw(_participant, funds, _fromRound, _toRound);
552         } else {
553             emit AddressIsNotAddedInKYC(_participant);
554         }
555     }
556 
557     // find participant who has winning ticket
558     // to start: _begin is 0, _end is last index in ticketsInterval array
559     function getWinner(
560         uint _round,
561         uint _beginInterval,
562         uint _endInterval,
563         uint _winningTicket
564     )
565         internal
566         returns (address)
567     {
568         if (_beginInterval == _endInterval) {
569             return rounds[_round].tickets[_beginInterval].participant;
570         }
571 
572         uint len = _endInterval.add(1).sub(_beginInterval);
573         uint mid = _beginInterval.add((len.div(2))).sub(1);
574         TicketsInterval memory interval = rounds[_round].tickets[mid];
575 
576         if (_winningTicket < interval.firstTicket) {
577             return getWinner(_round, _beginInterval, mid, _winningTicket);
578         } else if (_winningTicket > interval.lastTicket) {
579             return getWinner(_round, mid.add(1), _endInterval, _winningTicket);
580         } else {
581             return interval.participant;
582         }
583     }
584 
585     function addParticipant(address _participant, uint _ticketsCount) internal {
586         rounds[currentRound].participants.push(_participant);
587         uint currTicketsCount = rounds[currentRound].ticketsCount;
588         rounds[currentRound].ticketsCount = currTicketsCount.add(_ticketsCount);
589         rounds[currentRound].tickets.push(TicketsInterval(
590                 _participant,
591                 currTicketsCount,
592                 rounds[currentRound].ticketsCount.sub(1))
593         );
594         rounds[currentRound].nonce = rounds[currentRound].nonce + uint(keccak256(abi.encodePacked(_participant)));
595         emit ParticipantAdded(currentRound, _participant, _ticketsCount, _ticketsCount.mul(ticketPrice));
596     }
597 
598     function updateRoundTimeAndState() internal {
599         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
600             && rounds[currentRound].participantCount >= 10
601         ) {
602             rounds[currentRound].state = RoundState.WAIT_RESULT;
603             emit RoundStateChanged(currentRound, rounds[currentRound].state);
604             currentRound = currentRound.add(1);
605             rounds[currentRound].startRoundTime = rounds[currentRound-1].startRoundTime.add(period);
606             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
607             emit RoundStateChanged(currentRound, rounds[currentRound].state);
608         }
609     }
610 
611     function updateRoundFundsAndParticipants(address _participant, uint _funds) internal {
612 
613         if (rounds[currentRound].participantFunds[_participant] == 0) {
614             rounds[currentRound].participantCount = rounds[currentRound].participantCount.add(1);
615         }
616 
617         rounds[currentRound].participantFunds[_participant] =
618         rounds[currentRound].participantFunds[_participant].add(_funds);
619 
620         rounds[currentRound].roundFunds =
621         rounds[currentRound].roundFunds.add(_funds);
622     }
623 
624     function findWinners(uint _round) internal {
625         address winner;
626         uint fundsToWinner;
627         for (uint i = 0; i < NUMBER_OF_WINNERS; i++) {
628             winner = getWinner(
629                 _round,
630                 0,
631                 (rounds[_round].tickets.length).sub(1),
632                 rounds[_round].winningTickets[i]
633             );
634 
635             rounds[_round].winners.push(winner);
636             fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
637             rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
638         }
639     }
640 
641 }contract FiatContract {
642   function USD(uint _id) public pure returns (uint256);
643 }
644 
645 contract RealToken is Ownable, SimpleToken {
646   FiatContract public price;
647   BaseLottery public lottery;
648     
649   using SafeMath for uint256;
650 
651   string public constant name = "DreamPot Token";
652   string public constant symbol = "DPT";
653   uint32 public constant decimals = 0;
654 
655   address payable public ethBank;
656 
657   uint256 public factor;
658 
659   event GetEth(address indexed from, uint256 value);
660 
661   constructor() public {
662     price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
663     ethBank = address(uint160(owner()));
664     factor = 100;
665   }
666 
667   function setLotteryBank(address bank) public onlyOwner {
668     require(bank != address(0));
669     ethBank = address(uint160(bank));
670   }
671 
672   function setRoundFactor(uint256 newFactor) public onlyOwner {
673     factor = newFactor;
674   }
675   
676   function AddTokens(address addrTo) public payable {
677     uint256 ethCent = price.USD(0);
678     uint256 usdv = ethCent.div(1000);
679     usdv = usdv.mul(factor);
680     
681     uint256 tokens = msg.value.div(usdv);
682     ethBank.transfer(msg.value);
683     emit GetEth(addrTo, msg.value);
684     _mint(addrTo, tokens);
685   }
686   
687   function() external payable {
688   }
689 }
690 contract IChecker {
691     function update() public payable;
692 }
693 
694 
695 contract SuperJackPot is BaseLottery {
696 
697     IChecker public checker;
698 
699     modifier onlyChecker {
700         require(msg.sender == address(checker), "");
701         _;
702     }
703 
704     constructor(
705         address payable _rng,
706         uint _period,
707         address _checker
708     )
709         public
710         BaseLottery(_rng, _period) {
711             require(_checker != address(0), "");
712 
713             checker = IChecker(_checker);
714     }
715 
716     function () external payable {
717 
718     }
719 
720     function processLottery() public payable onlyChecker {
721         rounds[currentRound].state = RoundState.WAIT_RESULT;
722         emit RoundStateChanged(currentRound, rounds[currentRound].state);
723         currentRound = currentRound.add(1);
724         rounds[currentRound].startRoundTime = getCurrentTime();
725         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
726         emit RoundStateChanged(currentRound, rounds[currentRound].state);
727         iRNG(rng).update.value(msg.value)(currentRound, rounds[currentRound].nonce, 0);
728     }
729 
730     function startLottery(uint _startPeriod) public payable onlyLotteryContract {
731         _startPeriod;
732         currentRound = 1;
733         uint time = getCurrentTime();
734         rounds[currentRound].startRoundTime = time;
735         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
736         emit RoundStateChanged(currentRound, rounds[currentRound].state);
737         emit LotteryStarted(time);
738         checker.update.value(msg.value)();
739     }
740 
741     function setChecker(address _checker) public onlyOwner {
742         require(_checker != address(0), "");
743 
744         checker = IChecker(_checker);
745     }
746 
747     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
748         rounds[_round].random = _randomNumber;
749         rounds[_round].winningTickets.push(_randomNumber.mod(rounds[_round].ticketsCount));
750 
751         address winner = getWinner(
752             _round,
753             0,
754             (rounds[_round].tickets.length).sub(1),
755             rounds[_round].winningTickets[0]
756         );
757 
758         rounds[_round].winners.push(winner);
759         rounds[_round].winnersFunds[winner] = rounds[_round].roundFunds;
760         rounds[_round].state = RoundState.SUCCESS;
761 
762         emit RoundStateChanged(_round, rounds[_round].state);
763         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
764 
765         currentRound = currentRound.add(1);
766         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
767 
768         emit RoundStateChanged(_round, rounds[_round].state);
769         return true;
770     }
771 
772     function buyTickets(address _participant) public payable onlyLotteryContract {
773         require(msg.value > 0, "");
774 
775         uint ticketsCount = msg.value.div(ticketPrice);
776         addParticipant(_participant, ticketsCount);
777 
778         updateRoundFundsAndParticipants(_participant, msg.value);
779     }
780 }