1 pragma solidity 0.5.2;
2 
3 contract Ownable {
4     address public owner;
5     
6     constructor() public {
7         owner = msg.sender;
8     }
9     
10     modifier onlyOwner() {
11         require(msg.sender == owner, "");
12         _;
13     }
14     
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0), "");
17         owner = newOwner;
18     }
19     
20 }
21 
22 contract Manageable is Ownable {
23     mapping(address => bool) public listOfManagers;
24     
25     modifier onlyManager() {
26         require(listOfManagers[msg.sender], "");
27         _;
28     }
29     
30     function addManager(address _manager) public onlyOwner returns (bool success) {
31         if (!listOfManagers[_manager]) {
32             require(_manager != address(0), "");
33             listOfManagers[_manager] = true;
34             success = true;
35         }
36     }
37     
38     function removeManager(address _manager) public onlyOwner returns (bool success) {
39         if (listOfManagers[_manager]) {
40             listOfManagers[_manager] = false;
41             success = true;
42         }
43     }
44     
45     function getInfo(address _manager) public view returns (bool) {
46         return listOfManagers[_manager];
47     }
48 }
49 
50 library SafeMath {
51     
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         
57         uint256 c = a * b;
58         require(c / a == b, "");
59         
60         return c;
61     }
62     
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
65         uint256 c = a / b;
66         
67         return c;
68     }
69     
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a, "");
72         uint256 c = a - b;
73         
74         return c;
75     }
76     
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "");
80         
81         return c;
82     }
83     
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0, "");
86         return a % b;
87     }
88 }
89 
90 contract iRNG {
91     function update(uint roundNumber, uint additionalNonce, uint period) public payable;
92 }
93 
94 
95 contract iKYCWhitelist {
96     function isWhitelisted(address _participant) public view returns (bool);
97 }
98 
99 contract BaseLottery is Manageable {
100     using SafeMath for uint;
101     
102     enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
103     
104     struct Round {
105         RoundState state;
106         uint ticketsCount;
107         uint participantCount;
108         TicketsInterval[] tickets;
109         address[] participants;
110         uint random;
111         uint nonce; //xored participants addresses
112         uint startRoundTime;
113         uint[] winningTickets;
114         address[] winners;
115         uint roundFunds;
116         mapping(address => uint) winnersFunds;
117         mapping(address => uint) participantFunds;
118         mapping(address => bool) sendGain;
119     }
120     
121     struct TicketsInterval {
122         address participant;
123         uint firstTicket;
124         uint lastTicket;
125     }
126     
127     uint constant public NUMBER_OF_WINNERS = 10;
128     uint constant public SHARE_DENOMINATOR = 10000;
129     uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
130     uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
131     address payable public organiser;
132     uint constant public ORGANISER_PERCENT = 20;
133     uint constant public ROUND_FUND_PERCENT = 80;
134     
135     iKYCWhitelist public KYCWhitelist;
136     
137     uint public period;
138     address public mainLottery;
139     address public management;
140     address payable public rng;
141     
142     mapping (uint => Round) public rounds;
143     
144     uint public ticketPrice;
145     uint public currentRound;
146     
147     event LotteryStarted(uint start);
148     event RoundStateChanged(uint currentRound, RoundState state);
149     event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
150     event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
151     event RefundIsSuccess(uint round, address participant, uint funds);
152     event RefundIsFailed(uint round, address participant);
153     event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
154     event AddressIsNotAddedInKYC(address participant);
155     event TicketPriceChanged(uint price);
156     
157     modifier onlyRng {
158         require(msg.sender == address(rng), "");
159         _;
160     }
161     
162     modifier onlyLotteryContract {
163         require(msg.sender == address(mainLottery) || msg.sender == management, "");
164         _;
165     }
166     
167     constructor (address payable _rng, uint _period) public {
168         require(_rng != address(0), "");
169         require(_period >= 60, "");
170         
171         rng = _rng;
172         period = _period;
173     }
174     
175     function setContracts(address payable _rng, address _mainLottery, address _management) public onlyOwner {
176         require(_rng != address(0), "");
177         require(_mainLottery != address(0), "");
178         require(_management != address(0), "");
179         
180         rng = _rng;
181         mainLottery = _mainLottery;
182         management = _management;
183     }
184     
185     function startLottery(uint _startPeriod) public payable onlyLotteryContract {
186         currentRound = 1;
187         uint time = getCurrentTime().add(_startPeriod).sub(period);
188         rounds[currentRound].startRoundTime = time;
189         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
190         
191         iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
192         
193         emit LotteryStarted(time);
194     }
195     
196     function buyTickets(address _participant) public payable onlyLotteryContract {
197         uint funds = msg.value;
198         
199         updateRoundTimeAndState();
200         addParticipant(_participant, funds.div(ticketPrice));
201         updateRoundFundsAndParticipants(_participant, funds);
202         
203         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
204             rounds[currentRound].participantCount >= 10
205         ) {
206             _restartLottery();
207         }
208     }
209     
210     function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyLotteryContract {
211         updateRoundTimeAndState();
212         addParticipant(_participant, _ticketsCount);
213         updateRoundFundsAndParticipants(_participant, uint(0));
214         
215         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
216             rounds[currentRound].participantCount >= 10
217         ) {
218             _restartLottery();
219         }
220     }
221     
222     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
223         if (rounds[_round].winners.length != 0) {
224             return true;
225         }
226         
227         if (checkRoundState(_round) == RoundState.REFUND) {
228             return true;
229         }
230         
231         if (rounds[_round].participantCount < 10) {
232             rounds[_round].state = RoundState.ACCEPT_FUNDS;
233             emit RoundStateChanged(_round, rounds[_round].state);
234             return true;
235         }
236         
237         rounds[_round].random = _randomNumber;
238         findWinTickets(_round);
239         findWinners(_round);
240         rounds[_round].state = RoundState.SUCCESS;
241         emit RoundStateChanged(_round, rounds[_round].state);
242         
243         if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
244             currentRound = _round.add(1);
245             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
246             emit RoundStateChanged(currentRound, rounds[currentRound].state);
247         }
248         
249         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
250         getRandomNumber(_round + 1, rounds[_round].nonce);
251         return true;
252     }
253     
254     function restartLottery() public payable onlyOwner {
255         _restartLottery();
256     }
257     
258     function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
259         iRNG(rng).update(_round, _nonce, period);
260     }
261     
262     function setTicketPrice(uint _ticketPrice) public onlyLotteryContract {
263         require(_ticketPrice > 0, "");
264         
265         emit TicketPriceChanged(_ticketPrice);
266         ticketPrice = _ticketPrice;
267     }
268     
269     function findWinTickets(uint _round) public {
270         uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
271         
272         for (uint i = 0; i < 10; i++) {
273             rounds[_round].winningTickets.push(winners[i]);
274         }
275     }
276     
277     function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
278         uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
279         uint winnersNum = 10;
280         
281         uint[10] memory winTickets;
282         uint shift = uint(256).div(winnersNum);
283         
284         for (uint i = 0; i < 10; i++) {
285             winTickets[i] =
286             uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
287         }
288         
289         return winTickets;
290     }
291     
292     function refund(uint _round) public {
293         if (checkRoundState(_round) == RoundState.REFUND
294             && rounds[_round].participantFunds[msg.sender] > 0
295         ) {
296             uint amount = rounds[_round].participantFunds[msg.sender];
297             rounds[_round].participantFunds[msg.sender] = 0;
298             address(msg.sender).transfer(amount);
299             emit RefundIsSuccess(_round, msg.sender, amount);
300         } else {
301             emit RefundIsFailed(_round, msg.sender);
302         }
303     }
304     
305     function checkRoundState(uint _round) public returns (RoundState) {
306         if (rounds[_round].state == RoundState.WAIT_RESULT
307             && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
308         ) {
309             rounds[_round].state = RoundState.REFUND;
310             emit RoundStateChanged(_round, rounds[_round].state);
311         }
312         return rounds[_round].state;
313     }
314     
315     function setOrganiser(address payable _organiser) public onlyOwner {
316         require(_organiser != address(0), "");
317         
318         organiser = _organiser;
319     }
320     
321     function setKYCWhitelist(address _KYCWhitelist) public onlyOwner {
322         require(_KYCWhitelist != address(0), "");
323         
324         KYCWhitelist = iKYCWhitelist(_KYCWhitelist);
325     }
326     
327     function getGain(uint _fromRound, uint _toRound) public {
328         _transferGain(msg.sender, _fromRound, _toRound);
329     }
330     
331     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
332         _transferGain(_participant, _fromRound, _toRound);
333     }
334     
335     function getTicketsCount(uint _round) public view returns (uint) {
336         return rounds[_round].ticketsCount;
337     }
338     
339     function getTicketPrice() public view returns (uint) {
340         return ticketPrice;
341     }
342     
343     function getCurrentTime() public view returns (uint) {
344         return now;
345     }
346     
347     function getPeriod() public view returns (uint) {
348         return period;
349     }
350     
351     function getRoundWinners(uint _round) public view returns (address[] memory) {
352         return rounds[_round].winners;
353     }
354     
355     function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
356         return rounds[_round].winningTickets;
357     }
358     
359     function getRoundParticipants(uint _round) public view returns (address[] memory) {
360         return rounds[_round].participants;
361     }
362     
363     function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
364         return rounds[_round].winnersFunds[_winner];
365     }
366     
367     function getRoundFunds(uint _round) public view returns (uint) {
368         return rounds[_round].roundFunds;
369     }
370     
371     function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
372         return rounds[_round].participantFunds[_participant];
373     }
374     
375     function getCurrentRound() public view returns (uint) {
376         return currentRound;
377     }
378     
379     function getRoundStartTime(uint _round) public view returns (uint) {
380         return rounds[_round].startRoundTime;
381     }
382     
383     function _restartLottery() internal {
384         uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
385         rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
386         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
387         emit RoundStateChanged(currentRound, rounds[currentRound].state);
388         iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
389     }
390     
391     function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
392         require(_fromRound <= _toRound, "");
393         require(_participant != address(0), "");
394         
395         if (KYCWhitelist.isWhitelisted(_participant)) {
396             uint funds;
397             
398             for (uint i = _fromRound; i <= _toRound; i++) {
399                 
400                 if (rounds[i].state == RoundState.SUCCESS
401                     && rounds[i].sendGain[_participant] == false) {
402                     
403                     rounds[i].sendGain[_participant] = true;
404                 funds = funds.add(getWinningFunds(i, _participant));
405                     }
406             }
407             
408             require(funds > 0, "");
409             _participant.transfer(funds);
410             emit Withdraw(_participant, funds, _fromRound, _toRound);
411         } else {
412             emit AddressIsNotAddedInKYC(_participant);
413         }
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
424     internal
425     returns (address)
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
449             _participant,
450             currTicketsCount,
451             rounds[currentRound].ticketsCount.sub(1))
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
491                                rounds[_round].winningTickets[i]
492             );
493             
494             rounds[_round].winners.push(winner);
495             fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
496             rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
497         }
498     }
499     
500 }
501 
502 
503 contract YearlyLottery is BaseLottery {
504 
505     constructor(
506         address payable _rng,
507         uint _period
508     )
509         public
510         BaseLottery(_rng, _period) {
511 
512     }
513 }