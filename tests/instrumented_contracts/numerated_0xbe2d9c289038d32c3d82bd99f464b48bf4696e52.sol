1 pragma solidity 0.5.6;
2 
3 
4 
5 contract Ownable {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner, "");
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0), "");
19         owner = newOwner;
20     }
21 
22 }
23 
24 
25 // Developer @gogol
26 // Design @chechenets
27 // Architect @tugush
28 
29 contract Manageable is Ownable {
30     mapping(address => bool) public listOfManagers;
31 
32     modifier onlyManager() {
33         require(listOfManagers[msg.sender], "");
34         _;
35     }
36 
37     function addManager(address _manager) public onlyOwner returns (bool success) {
38         if (!listOfManagers[_manager]) {
39             require(_manager != address(0), "");
40             listOfManagers[_manager] = true;
41             success = true;
42         }
43     }
44 
45     function removeManager(address _manager) public onlyOwner returns (bool success) {
46         if (listOfManagers[_manager]) {
47             listOfManagers[_manager] = false;
48             success = true;
49         }
50     }
51 
52     function getInfo(address _manager) public view returns (bool) {
53         return listOfManagers[_manager];
54     }
55 }
56 
57 // Developer @gogol
58 // Design @chechenets
59 // Architect @tugush
60 
61 library SafeMath {
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "");
70 
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
76         uint256 c = a / b;
77 
78         return c;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a, "");
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "");
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0, "");
97         return a % b;
98     }
99 }
100 
101 
102 // Developer @gogol
103 // Design @chechenets
104 // Architect @tugush
105 
106 contract iRNG {
107     function update(uint roundNumber, uint additionalNonce, uint period) public payable;
108 }
109 
110 
111 contract BaseGame is Manageable {
112     using SafeMath for uint;
113 
114     enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
115 
116     struct Round {
117         RoundState state;
118         uint ticketsCount;
119         uint participantCount;
120         TicketsInterval[] tickets;
121         address[] participants;
122         uint random;
123         uint nonce; //xored participants addresses
124         uint startRoundTime;
125         uint[] winningTickets;
126         address[] winners;
127         uint roundFunds;
128         mapping(address => uint) winnersFunds;
129         mapping(address => uint) participantFunds;
130         mapping(address => bool) sendGain;
131     }
132 
133     struct TicketsInterval {
134         address participant;
135         uint firstTicket;
136         uint lastTicket;
137     }
138 
139     uint constant public NUMBER_OF_WINNERS = 10;
140     uint constant public SHARE_DENOMINATOR = 10000;
141     uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
142     uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
143     address payable public organiser;
144     uint constant public ORGANISER_PERCENT = 20;
145     uint constant public ROUND_FUND_PERCENT = 80;
146 
147     uint public period;
148     address public hourlyGame;
149     address public management;
150     address payable public rng;
151 
152     mapping (uint => Round) public rounds;
153 
154     uint public ticketPrice;
155     uint public currentRound;
156 
157     event GameStarted(uint start);
158     event RoundStateChanged(uint currentRound, RoundState state);
159     event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
160     event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
161     event RefundIsSuccess(uint round, address participant, uint funds);
162     event RefundIsFailed(uint round, address participant);
163     event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
164     event TicketPriceChanged(uint price);
165 
166     modifier onlyRng {
167         require(msg.sender == address(rng), "");
168         _;
169     }
170 
171     modifier onlyGameContract {
172         require(msg.sender == address(hourlyGame) || msg.sender == management, "");
173         _;
174     }
175 
176     constructor (address payable _rng, uint _period) public {
177         require(_rng != address(0), "");
178         require(_period >= 60, "");
179 
180         rng = _rng;
181         period = _period;
182     }
183 
184     function setContracts(address payable _rng, address _hourlyGame, address _management) public onlyOwner {
185         require(_rng != address(0), "");
186         require(_hourlyGame != address(0), "");
187         require(_management != address(0), "");
188 
189         rng = _rng;
190         hourlyGame = _hourlyGame;
191         management = _management;
192     }
193 
194     function startGame(uint _startPeriod) public payable onlyGameContract {
195         currentRound = 1;
196         uint time = getCurrentTime().add(_startPeriod).sub(period);
197         rounds[currentRound].startRoundTime = time;
198         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
199 
200         iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
201 
202         emit GameStarted(time);
203     }
204 
205     function buyTickets(address _participant) public payable onlyGameContract {
206         uint funds = msg.value;
207 
208         updateRoundTimeAndState();
209         addParticipant(_participant, funds.div(ticketPrice));
210         updateRoundFundsAndParticipants(_participant, funds);
211 
212         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
213             rounds[currentRound].participantCount >= 10
214         ) {
215             _restartGame();
216         }
217     }
218 
219     function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyGameContract {
220         updateRoundTimeAndState();
221         addParticipant(_participant, _ticketsCount);
222         updateRoundFundsAndParticipants(_participant, uint(0));
223 
224         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
225             rounds[currentRound].participantCount >= 10
226         ) {
227             _restartGame();
228         }
229     }
230 
231     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
232         if (rounds[_round].winners.length != 0) {
233             return true;
234         }
235 
236         if (checkRoundState(_round) == RoundState.REFUND) {
237             return true;
238         }
239 
240         if (rounds[_round].participantCount < 10) {
241             rounds[_round].state = RoundState.ACCEPT_FUNDS;
242             emit RoundStateChanged(_round, rounds[_round].state);
243             return true;
244         }
245 
246         rounds[_round].random = _randomNumber;
247         findWinTickets(_round);
248         findWinners(_round);
249         rounds[_round].state = RoundState.SUCCESS;
250         emit RoundStateChanged(_round, rounds[_round].state);
251 
252         if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
253             currentRound = _round.add(1);
254             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
255             emit RoundStateChanged(currentRound, rounds[currentRound].state);
256         }
257 
258         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
259         getRandomNumber(_round + 1, rounds[_round].nonce);
260         return true;
261     }
262 
263     function restartGame() public payable onlyOwner {
264         _restartGame();
265     }
266 
267     function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
268         iRNG(rng).update(_round, _nonce, period);
269     }
270 
271     function setTicketPrice(uint _ticketPrice) public onlyGameContract {
272         require(_ticketPrice > 0, "");
273 
274         emit TicketPriceChanged(_ticketPrice);
275         ticketPrice = _ticketPrice;
276     }
277 
278     function findWinTickets(uint _round) public {
279         uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
280 
281         for (uint i = 0; i < 10; i++) {
282             rounds[_round].winningTickets.push(winners[i]);
283         }
284     }
285 
286     function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
287         uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
288         uint winnersNum = 10;
289 
290         uint[10] memory winTickets;
291         uint shift = uint(256).div(winnersNum);
292 
293         for (uint i = 0; i < 10; i++) {
294             winTickets[i] =
295             uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
296         }
297 
298         return winTickets;
299     }
300 
301     function refund(uint _round) public {
302         if (checkRoundState(_round) == RoundState.REFUND
303         && rounds[_round].participantFunds[msg.sender] > 0
304         ) {
305             uint amount = rounds[_round].participantFunds[msg.sender];
306             rounds[_round].participantFunds[msg.sender] = 0;
307             address(msg.sender).transfer(amount);
308             emit RefundIsSuccess(_round, msg.sender, amount);
309         } else {
310             emit RefundIsFailed(_round, msg.sender);
311         }
312     }
313 
314     function checkRoundState(uint _round) public returns (RoundState) {
315         if (rounds[_round].state == RoundState.WAIT_RESULT
316         && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
317         ) {
318             rounds[_round].state = RoundState.REFUND;
319             emit RoundStateChanged(_round, rounds[_round].state);
320         }
321         return rounds[_round].state;
322     }
323 
324     function setOrganiser(address payable _organiser) public onlyOwner {
325         require(_organiser != address(0), "");
326 
327         organiser = _organiser;
328     }
329 
330    function getGain(uint _fromRound, uint _toRound) public {
331         _transferGain(msg.sender, _fromRound, _toRound);
332     }
333 
334     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
335         _transferGain(_participant, _fromRound, _toRound);
336     }
337 
338     function getTicketsCount(uint _round) public view returns (uint) {
339         return rounds[_round].ticketsCount;
340     }
341 
342     function getTicketPrice() public view returns (uint) {
343         return ticketPrice;
344     }
345 
346     function getCurrentTime() public view returns (uint) {
347         return now;
348     }
349 
350     function getPeriod() public view returns (uint) {
351         return period;
352     }
353 
354     function getRoundWinners(uint _round) public view returns (address[] memory) {
355         return rounds[_round].winners;
356     }
357 
358     function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
359         return rounds[_round].winningTickets;
360     }
361 
362     function getRoundParticipants(uint _round) public view returns (address[] memory) {
363         return rounds[_round].participants;
364     }
365 
366     function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
367         return rounds[_round].winnersFunds[_winner];
368     }
369 
370     function getRoundFunds(uint _round) public view returns (uint) {
371         return rounds[_round].roundFunds;
372     }
373 
374     function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
375         return rounds[_round].participantFunds[_participant];
376     }
377 
378     function getCurrentRound() public view returns (uint) {
379         return currentRound;
380     }
381 
382     function getRoundStartTime(uint _round) public view returns (uint) {
383         return rounds[_round].startRoundTime;
384     }
385 
386     function _restartGame() internal {
387         uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
388         rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
389         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
390         emit RoundStateChanged(currentRound, rounds[currentRound].state);
391         iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
392     }
393 
394     function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
395         require(_fromRound <= _toRound, "");
396         require(_participant != address(0), "");
397 
398         uint funds;
399 
400         for (uint i = _fromRound; i <= _toRound; i++) {
401 
402             if (rounds[i].state == RoundState.SUCCESS
403             && rounds[i].sendGain[_participant] == false) {
404 
405                 rounds[i].sendGain[_participant] = true;
406                 funds = funds.add(getWinningFunds(i, _participant));
407             }
408         }
409 
410         require(funds > 0, "");
411         _participant.transfer(funds);
412         emit Withdraw(_participant, funds, _fromRound, _toRound);
413 
414     }
415 
416     // find participant who has winning ticket
417     // to start: _begin is 0, _end is last index in ticketsInterval array
418     function getWinner(
419         uint _round,
420         uint _beginInterval,
421         uint _endInterval,
422         uint _winningTicket
423     )
424         internal
425         returns (address)
426     {
427         if (_beginInterval == _endInterval) {
428             return rounds[_round].tickets[_beginInterval].participant;
429         }
430 
431         uint len = _endInterval.add(1).sub(_beginInterval);
432         uint mid = _beginInterval.add((len.div(2))).sub(1);
433         TicketsInterval memory interval = rounds[_round].tickets[mid];
434 
435         if (_winningTicket < interval.firstTicket) {
436             return getWinner(_round, _beginInterval, mid, _winningTicket);
437         } else if (_winningTicket > interval.lastTicket) {
438             return getWinner(_round, mid.add(1), _endInterval, _winningTicket);
439         } else {
440             return interval.participant;
441         }
442     }
443 
444     function addParticipant(address _participant, uint _ticketsCount) internal {
445         rounds[currentRound].participants.push(_participant);
446         uint currTicketsCount = rounds[currentRound].ticketsCount;
447         rounds[currentRound].ticketsCount = currTicketsCount.add(_ticketsCount);
448         rounds[currentRound].tickets.push(TicketsInterval(
449                 _participant,
450                 currTicketsCount,
451                 rounds[currentRound].ticketsCount.sub(1))
452         );
453         rounds[currentRound].nonce = rounds[currentRound].nonce + uint(keccak256(abi.encodePacked(_participant)));
454         emit ParticipantAdded(currentRound, _participant, _ticketsCount, _ticketsCount.mul(ticketPrice));
455     }
456 
457     function updateRoundTimeAndState() internal {
458         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
459             && rounds[currentRound].participantCount >= 10
460         ) {
461             rounds[currentRound].state = RoundState.WAIT_RESULT;
462             emit RoundStateChanged(currentRound, rounds[currentRound].state);
463             currentRound = currentRound.add(1);
464             rounds[currentRound].startRoundTime = rounds[currentRound-1].startRoundTime.add(period);
465             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
466             emit RoundStateChanged(currentRound, rounds[currentRound].state);
467         }
468     }
469 
470     function updateRoundFundsAndParticipants(address _participant, uint _funds) internal {
471 
472         if (rounds[currentRound].participantFunds[_participant] == 0) {
473             rounds[currentRound].participantCount = rounds[currentRound].participantCount.add(1);
474         }
475 
476         rounds[currentRound].participantFunds[_participant] =
477         rounds[currentRound].participantFunds[_participant].add(_funds);
478 
479         rounds[currentRound].roundFunds =
480         rounds[currentRound].roundFunds.add(_funds);
481     }
482 
483     function findWinners(uint _round) internal {
484         address winner;
485         uint fundsToWinner;
486         for (uint i = 0; i < NUMBER_OF_WINNERS; i++) {
487             winner = getWinner(
488                 _round,
489                 0,
490                 (rounds[_round].tickets.length).sub(1),
491                 rounds[_round].winningTickets[i]
492             );
493 
494             rounds[_round].winners.push(winner);
495             fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
496             rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
497         }
498     }
499 
500 
501 }
502 
503 
504 // Developer @gogol
505 // Design @chechenets
506 // Architect @tugush
507 
508 
509 contract IChecker {
510     function update() public payable;
511 }
512 
513 
514 contract SuperJackPot is BaseGame {
515 
516     IChecker public checker;
517     uint constant public SUPERJACKPOT_ORGANISER_SHARE = 20;          // 20% to organiser
518     uint constant public SUPERJACKPOT_WINNER_SHARE = 80;             // 80% to winner
519 
520     modifier onlyChecker {
521         require(msg.sender == address(checker), "");
522         _;
523     }
524 
525     constructor(
526         address payable _rng,
527         uint _period,
528         address _checker
529     )
530         public
531         BaseGame(_rng, _period) {
532             require(_checker != address(0), "");
533 
534             checker = IChecker(_checker);
535     }
536 
537     function () external payable {
538 
539     }
540 
541     function processGame() public payable onlyChecker {
542         rounds[currentRound].state = RoundState.WAIT_RESULT;
543         emit RoundStateChanged(currentRound, rounds[currentRound].state);
544         iRNG(rng).update.value(msg.value)(currentRound, rounds[currentRound].nonce, 0);
545         currentRound = currentRound.add(1);
546         rounds[currentRound].startRoundTime = getCurrentTime();
547         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
548         emit RoundStateChanged(currentRound, rounds[currentRound].state);
549     }
550 
551     function startGame(uint _startPeriod) public payable onlyGameContract {
552         _startPeriod;
553         currentRound = 1;
554         uint time = getCurrentTime();
555         rounds[currentRound].startRoundTime = time;
556         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
557         emit RoundStateChanged(currentRound, rounds[currentRound].state);
558         emit GameStarted(time);
559         checker.update.value(msg.value)();
560     }
561 
562     function setChecker(address _checker) public onlyOwner {
563         require(_checker != address(0), "");
564 
565         checker = IChecker(_checker);
566     }
567 
568     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
569         rounds[_round].random = _randomNumber;
570         rounds[_round].winningTickets.push(_randomNumber.mod(rounds[_round].ticketsCount));
571 
572         address winner = getWinner(
573             _round,
574             0,
575             (rounds[_round].tickets.length).sub(1),
576             rounds[_round].winningTickets[0]
577         );
578 
579         rounds[_round].winners.push(winner);
580         rounds[_round].winnersFunds[winner] = rounds[_round].roundFunds;
581         rounds[_round].state = RoundState.SUCCESS;
582 
583         emit RoundStateChanged(_round, rounds[_round].state);
584         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
585 
586         return true;
587     }
588 
589     function buyTickets(address _participant) public payable onlyGameContract {
590         require(msg.value > 0, "");
591 
592         uint ticketsCount = msg.value.div(ticketPrice);
593         addParticipant(_participant, ticketsCount);
594 
595         updateRoundFundsAndParticipants(_participant, msg.value);
596     }
597 
598     function getGain(uint _fromRound, uint _toRound) public {
599         transferGain(msg.sender, _fromRound, _toRound);
600     }
601 
602     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
603         transferGain(_participant, _fromRound, _toRound);
604     }
605 
606     function transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
607         require(_fromRound <= _toRound, "");
608         require(_participant != address(0), "");
609 
610         uint funds;
611 
612         for (uint i = _fromRound; i <= _toRound; i++) {
613 
614             if (rounds[i].state == RoundState.SUCCESS
615                 && rounds[i].sendGain[_participant] == false) {
616 
617                 rounds[i].sendGain[_participant] = true;
618                 funds = funds.add(getWinningFunds(i, _participant));
619             }
620         }
621 
622         require(funds > 0, "");
623 
624         uint fundsToOrganiser = funds.mul(SUPERJACKPOT_ORGANISER_SHARE).div(100);
625         uint fundsToWinner = funds.mul(SUPERJACKPOT_WINNER_SHARE).div(100);
626 
627         _participant.transfer(fundsToWinner);
628         organiser.transfer(fundsToOrganiser);
629 
630         emit Withdraw(_participant, fundsToWinner, _fromRound, _toRound);
631         emit Withdraw(organiser, fundsToOrganiser, _fromRound, _toRound);
632 
633     }
634 }
635 
636 
637 // Developer @gogol
638 // Design @chechenets
639 // Architect @tugush