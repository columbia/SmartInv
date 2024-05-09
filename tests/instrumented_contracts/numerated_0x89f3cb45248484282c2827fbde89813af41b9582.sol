1 pragma solidity 0.5.6;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner, "");
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0), "");
18         owner = newOwner;
19     }
20 
21 }
22 
23 
24 // Developer @gogol
25 // Design @chechenets
26 // Architect @tugush
27 
28 contract Manageable is Ownable {
29     mapping(address => bool) public listOfManagers;
30 
31     modifier onlyManager() {
32         require(listOfManagers[msg.sender], "");
33         _;
34     }
35 
36     function addManager(address _manager) public onlyOwner returns (bool success) {
37         if (!listOfManagers[_manager]) {
38             require(_manager != address(0), "");
39             listOfManagers[_manager] = true;
40             success = true;
41         }
42     }
43 
44     function removeManager(address _manager) public onlyOwner returns (bool success) {
45         if (listOfManagers[_manager]) {
46             listOfManagers[_manager] = false;
47             success = true;
48         }
49     }
50 
51     function getInfo(address _manager) public view returns (bool) {
52         return listOfManagers[_manager];
53     }
54 }
55 
56 // Developer @gogol
57 // Design @chechenets
58 // Architect @tugush
59 
60 library SafeMath {
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "");
69 
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
75         uint256 c = a / b;
76 
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a, "");
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "");
90 
91         return c;
92     }
93 
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0, "");
96         return a % b;
97     }
98 }
99 
100 
101 // Developer @gogol
102 // Design @chechenets
103 // Architect @tugush
104 
105 contract iRNG {
106     function update(uint roundNumber, uint additionalNonce, uint period) public payable;
107 }
108 
109 
110 contract BaseGame is Manageable {
111     using SafeMath for uint;
112 
113     enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
114 
115     struct Round {
116         RoundState state;
117         uint ticketsCount;
118         uint participantCount;
119         TicketsInterval[] tickets;
120         address[] participants;
121         uint random;
122         uint nonce; //xored participants addresses
123         uint startRoundTime;
124         uint[] winningTickets;
125         address[] winners;
126         uint roundFunds;
127         mapping(address => uint) winnersFunds;
128         mapping(address => uint) participantFunds;
129         mapping(address => bool) sendGain;
130     }
131 
132     struct TicketsInterval {
133         address participant;
134         uint firstTicket;
135         uint lastTicket;
136     }
137 
138     uint constant public NUMBER_OF_WINNERS = 10;
139     uint constant public SHARE_DENOMINATOR = 10000;
140     uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
141     uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
142     address payable public organiser;
143     uint constant public ORGANISER_PERCENT = 20;
144     uint constant public ROUND_FUND_PERCENT = 80;
145 
146     uint public period;
147     address public hourlyGame;
148     address public management;
149     address payable public rng;
150 
151     mapping (uint => Round) public rounds;
152 
153     uint public ticketPrice;
154     uint public currentRound;
155 
156     event GameStarted(uint start);
157     event RoundStateChanged(uint currentRound, RoundState state);
158     event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
159     event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
160     event RefundIsSuccess(uint round, address participant, uint funds);
161     event RefundIsFailed(uint round, address participant);
162     event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
163     event TicketPriceChanged(uint price);
164 
165     modifier onlyRng {
166         require(msg.sender == address(rng), "");
167         _;
168     }
169 
170     modifier onlyGameContract {
171         require(msg.sender == address(hourlyGame) || msg.sender == management, "");
172         _;
173     }
174 
175     constructor (address payable _rng, uint _period) public {
176         require(_rng != address(0), "");
177         require(_period >= 60, "");
178 
179         rng = _rng;
180         period = _period;
181     }
182 
183     function setContracts(address payable _rng, address _hourlyGame, address _management) public onlyOwner {
184         require(_rng != address(0), "");
185         require(_hourlyGame != address(0), "");
186         require(_management != address(0), "");
187 
188         rng = _rng;
189         hourlyGame = _hourlyGame;
190         management = _management;
191     }
192 
193     function startGame(uint _startPeriod) public payable onlyGameContract {
194         currentRound = 1;
195         uint time = getCurrentTime().add(_startPeriod).sub(period);
196         rounds[currentRound].startRoundTime = time;
197         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
198 
199         iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
200 
201         emit GameStarted(time);
202     }
203 
204     function buyTickets(address _participant) public payable onlyGameContract {
205         uint funds = msg.value;
206 
207         updateRoundTimeAndState();
208         addParticipant(_participant, funds.div(ticketPrice));
209         updateRoundFundsAndParticipants(_participant, funds);
210 
211         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
212             rounds[currentRound].participantCount >= 10
213         ) {
214             _restartGame();
215         }
216     }
217 
218     function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyGameContract {
219         updateRoundTimeAndState();
220         addParticipant(_participant, _ticketsCount);
221         updateRoundFundsAndParticipants(_participant, uint(0));
222 
223         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
224             rounds[currentRound].participantCount >= 10
225         ) {
226             _restartGame();
227         }
228     }
229 
230     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
231         if (rounds[_round].winners.length != 0) {
232             return true;
233         }
234 
235         if (checkRoundState(_round) == RoundState.REFUND) {
236             return true;
237         }
238 
239         if (rounds[_round].participantCount < 10) {
240             rounds[_round].state = RoundState.ACCEPT_FUNDS;
241             emit RoundStateChanged(_round, rounds[_round].state);
242             return true;
243         }
244 
245         rounds[_round].random = _randomNumber;
246         findWinTickets(_round);
247         findWinners(_round);
248         rounds[_round].state = RoundState.SUCCESS;
249         emit RoundStateChanged(_round, rounds[_round].state);
250 
251         if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
252             currentRound = _round.add(1);
253             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
254             emit RoundStateChanged(currentRound, rounds[currentRound].state);
255         }
256 
257         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
258         getRandomNumber(_round + 1, rounds[_round].nonce);
259         return true;
260     }
261 
262     function restartGame() public payable onlyOwner {
263         _restartGame();
264     }
265 
266     function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
267         iRNG(rng).update(_round, _nonce, period);
268     }
269 
270     function setTicketPrice(uint _ticketPrice) public onlyGameContract {
271         require(_ticketPrice > 0, "");
272 
273         emit TicketPriceChanged(_ticketPrice);
274         ticketPrice = _ticketPrice;
275     }
276 
277     function findWinTickets(uint _round) public {
278         uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
279 
280         for (uint i = 0; i < 10; i++) {
281             rounds[_round].winningTickets.push(winners[i]);
282         }
283     }
284 
285     function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
286         uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
287         uint winnersNum = 10;
288 
289         uint[10] memory winTickets;
290         uint shift = uint(256).div(winnersNum);
291 
292         for (uint i = 0; i < 10; i++) {
293             winTickets[i] =
294             uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
295         }
296 
297         return winTickets;
298     }
299 
300     function refund(uint _round) public {
301         if (checkRoundState(_round) == RoundState.REFUND
302         && rounds[_round].participantFunds[msg.sender] > 0
303         ) {
304             uint amount = rounds[_round].participantFunds[msg.sender];
305             rounds[_round].participantFunds[msg.sender] = 0;
306             address(msg.sender).transfer(amount);
307             emit RefundIsSuccess(_round, msg.sender, amount);
308         } else {
309             emit RefundIsFailed(_round, msg.sender);
310         }
311     }
312 
313     function checkRoundState(uint _round) public returns (RoundState) {
314         if (rounds[_round].state == RoundState.WAIT_RESULT
315         && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
316         ) {
317             rounds[_round].state = RoundState.REFUND;
318             emit RoundStateChanged(_round, rounds[_round].state);
319         }
320         return rounds[_round].state;
321     }
322 
323     function setOrganiser(address payable _organiser) public onlyOwner {
324         require(_organiser != address(0), "");
325 
326         organiser = _organiser;
327     }
328 
329    function getGain(uint _fromRound, uint _toRound) public {
330         _transferGain(msg.sender, _fromRound, _toRound);
331     }
332 
333     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
334         _transferGain(_participant, _fromRound, _toRound);
335     }
336 
337     function getTicketsCount(uint _round) public view returns (uint) {
338         return rounds[_round].ticketsCount;
339     }
340 
341     function getTicketPrice() public view returns (uint) {
342         return ticketPrice;
343     }
344 
345     function getCurrentTime() public view returns (uint) {
346         return now;
347     }
348 
349     function getPeriod() public view returns (uint) {
350         return period;
351     }
352 
353     function getRoundWinners(uint _round) public view returns (address[] memory) {
354         return rounds[_round].winners;
355     }
356 
357     function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
358         return rounds[_round].winningTickets;
359     }
360 
361     function getRoundParticipants(uint _round) public view returns (address[] memory) {
362         return rounds[_round].participants;
363     }
364 
365     function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
366         return rounds[_round].winnersFunds[_winner];
367     }
368 
369     function getRoundFunds(uint _round) public view returns (uint) {
370         return rounds[_round].roundFunds;
371     }
372 
373     function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
374         return rounds[_round].participantFunds[_participant];
375     }
376 
377     function getCurrentRound() public view returns (uint) {
378         return currentRound;
379     }
380 
381     function getRoundStartTime(uint _round) public view returns (uint) {
382         return rounds[_round].startRoundTime;
383     }
384 
385     function _restartGame() internal {
386         uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
387         rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
388         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
389         emit RoundStateChanged(currentRound, rounds[currentRound].state);
390         iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
391     }
392 
393     function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
394         require(_fromRound <= _toRound, "");
395         require(_participant != address(0), "");
396 
397         uint funds;
398 
399         for (uint i = _fromRound; i <= _toRound; i++) {
400 
401             if (rounds[i].state == RoundState.SUCCESS
402             && rounds[i].sendGain[_participant] == false) {
403 
404                 rounds[i].sendGain[_participant] = true;
405                 funds = funds.add(getWinningFunds(i, _participant));
406             }
407         }
408 
409         require(funds > 0, "");
410         _participant.transfer(funds);
411         emit Withdraw(_participant, funds, _fromRound, _toRound);
412 
413     }
414 
415     // find participant who has winning ticket
416     // to start: _begin is 0, _end is last index in ticketsInterval array
417     function getWinner(
418         uint _round,
419         uint _beginInterval,
420         uint _endInterval,
421         uint _winningTicket
422     )
423         internal
424         returns (address)
425     {
426         if (_beginInterval == _endInterval) {
427             return rounds[_round].tickets[_beginInterval].participant;
428         }
429 
430         uint len = _endInterval.add(1).sub(_beginInterval);
431         uint mid = _beginInterval.add((len.div(2))).sub(1);
432         TicketsInterval memory interval = rounds[_round].tickets[mid];
433 
434         if (_winningTicket < interval.firstTicket) {
435             return getWinner(_round, _beginInterval, mid, _winningTicket);
436         } else if (_winningTicket > interval.lastTicket) {
437             return getWinner(_round, mid.add(1), _endInterval, _winningTicket);
438         } else {
439             return interval.participant;
440         }
441     }
442 
443     function addParticipant(address _participant, uint _ticketsCount) internal {
444         rounds[currentRound].participants.push(_participant);
445         uint currTicketsCount = rounds[currentRound].ticketsCount;
446         rounds[currentRound].ticketsCount = currTicketsCount.add(_ticketsCount);
447         rounds[currentRound].tickets.push(TicketsInterval(
448                 _participant,
449                 currTicketsCount,
450                 rounds[currentRound].ticketsCount.sub(1))
451         );
452         rounds[currentRound].nonce = rounds[currentRound].nonce + uint(keccak256(abi.encodePacked(_participant)));
453         emit ParticipantAdded(currentRound, _participant, _ticketsCount, _ticketsCount.mul(ticketPrice));
454     }
455 
456     function updateRoundTimeAndState() internal {
457         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
458             && rounds[currentRound].participantCount >= 10
459         ) {
460             rounds[currentRound].state = RoundState.WAIT_RESULT;
461             emit RoundStateChanged(currentRound, rounds[currentRound].state);
462             currentRound = currentRound.add(1);
463             rounds[currentRound].startRoundTime = rounds[currentRound-1].startRoundTime.add(period);
464             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
465             emit RoundStateChanged(currentRound, rounds[currentRound].state);
466         }
467     }
468 
469     function updateRoundFundsAndParticipants(address _participant, uint _funds) internal {
470 
471         if (rounds[currentRound].participantFunds[_participant] == 0) {
472             rounds[currentRound].participantCount = rounds[currentRound].participantCount.add(1);
473         }
474 
475         rounds[currentRound].participantFunds[_participant] =
476         rounds[currentRound].participantFunds[_participant].add(_funds);
477 
478         rounds[currentRound].roundFunds =
479         rounds[currentRound].roundFunds.add(_funds);
480     }
481 
482     function findWinners(uint _round) internal {
483         address winner;
484         uint fundsToWinner;
485         for (uint i = 0; i < NUMBER_OF_WINNERS; i++) {
486             winner = getWinner(
487                 _round,
488                 0,
489                 (rounds[_round].tickets.length).sub(1),
490                 rounds[_round].winningTickets[i]
491             );
492 
493             rounds[_round].winners.push(winner);
494             fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
495             rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
496         }
497     }
498 
499 
500 }
501 
502 
503 // Developer @gogol
504 // Design @chechenets
505 // Architect @tugush
506 
507 contract DailyGame is BaseGame {
508 
509     constructor(
510         address payable _rng,
511         uint _period
512     )
513         public
514         BaseGame(_rng, _period)
515     {
516 
517     }
518 
519 }
520 
521 // Developer @gogol
522 // Design @chechenets
523 // Architect @tugush