1 pragma solidity 0.5.2;
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
23 contract Manageable is Ownable {
24     mapping(address => bool) public listOfManagers;
25     
26     modifier onlyManager() {
27         require(listOfManagers[msg.sender], "");
28         _;
29     }
30     
31     function addManager(address _manager) public onlyOwner returns (bool success) {
32         if (!listOfManagers[_manager]) {
33             require(_manager != address(0), "");
34             listOfManagers[_manager] = true;
35             success = true;
36         }
37     }
38     
39     function removeManager(address _manager) public onlyOwner returns (bool success) {
40         if (listOfManagers[_manager]) {
41             listOfManagers[_manager] = false;
42             success = true;
43         }
44     }
45     
46     function getInfo(address _manager) public view returns (bool) {
47         return listOfManagers[_manager];
48     }
49 }
50 
51 library SafeMath {
52     
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         
58         uint256 c = a * b;
59         require(c / a == b, "");
60         
61         return c;
62     }
63     
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
66         uint256 c = a / b;
67         
68         return c;
69     }
70     
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a, "");
73         uint256 c = a - b;
74         
75         return c;
76     }
77     
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "");
81         
82         return c;
83     }
84     
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0, "");
87         return a % b;
88     }
89 }
90 
91 contract iRNG {
92     function update(uint roundNumber, uint additionalNonce, uint period) public payable;
93 }
94 
95 
96 contract iKYCWhitelist {
97     function isWhitelisted(address _participant) public view returns (bool);
98 }
99 
100 contract BaseLottery is Manageable {
101     using SafeMath for uint;
102     
103     enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
104     
105     struct Round {
106         RoundState state;
107         uint ticketsCount;
108         uint participantCount;
109         TicketsInterval[] tickets;
110         address[] participants;
111         uint random;
112         uint nonce; //xored participants addresses
113         uint startRoundTime;
114         uint[] winningTickets;
115         address[] winners;
116         uint roundFunds;
117         mapping(address => uint) winnersFunds;
118         mapping(address => uint) participantFunds;
119         mapping(address => bool) sendGain;
120     }
121     
122     struct TicketsInterval {
123         address participant;
124         uint firstTicket;
125         uint lastTicket;
126     }
127     
128     uint constant public NUMBER_OF_WINNERS = 10;
129     uint constant public SHARE_DENOMINATOR = 10000;
130     uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
131     uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
132     address payable public organiser;
133     uint constant public ORGANISER_PERCENT = 20;
134     uint constant public ROUND_FUND_PERCENT = 80;
135     
136     iKYCWhitelist public KYCWhitelist;
137     
138     uint public period;
139     address public mainLottery;
140     address public management;
141     address payable public rng;
142     
143     mapping (uint => Round) public rounds;
144     
145     uint public ticketPrice;
146     uint public currentRound;
147     
148     event LotteryStarted(uint start);
149     event RoundStateChanged(uint currentRound, RoundState state);
150     event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
151     event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
152     event RefundIsSuccess(uint round, address participant, uint funds);
153     event RefundIsFailed(uint round, address participant);
154     event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
155     event AddressIsNotAddedInKYC(address participant);
156     event TicketPriceChanged(uint price);
157     
158     modifier onlyRng {
159         require(msg.sender == address(rng), "");
160         _;
161     }
162     
163     modifier onlyLotteryContract {
164         require(msg.sender == address(mainLottery) || msg.sender == management, "");
165         _;
166     }
167     
168     constructor (address payable _rng, uint _period) public {
169         require(_rng != address(0), "");
170         require(_period >= 60, "");
171         
172         rng = _rng;
173         period = _period;
174     }
175     
176     function setContracts(address payable _rng, address _mainLottery, address _management) public onlyOwner {
177         require(_rng != address(0), "");
178         require(_mainLottery != address(0), "");
179         require(_management != address(0), "");
180         
181         rng = _rng;
182         mainLottery = _mainLottery;
183         management = _management;
184     }
185     
186     function startLottery(uint _startPeriod) public payable onlyLotteryContract {
187         currentRound = 1;
188         uint time = getCurrentTime().add(_startPeriod).sub(period);
189         rounds[currentRound].startRoundTime = time;
190         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
191         
192         iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
193         
194         emit LotteryStarted(time);
195     }
196     
197     function buyTickets(address _participant) public payable onlyLotteryContract {
198         uint funds = msg.value;
199         
200         updateRoundTimeAndState();
201         addParticipant(_participant, funds.div(ticketPrice));
202         updateRoundFundsAndParticipants(_participant, funds);
203         
204         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
205             rounds[currentRound].participantCount >= 10
206         ) {
207             _restartLottery();
208         }
209     }
210     
211     function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyLotteryContract {
212         updateRoundTimeAndState();
213         addParticipant(_participant, _ticketsCount);
214         updateRoundFundsAndParticipants(_participant, uint(0));
215         
216         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
217             rounds[currentRound].participantCount >= 10
218         ) {
219             _restartLottery();
220         }
221     }
222     
223     function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
224         if (rounds[_round].winners.length != 0) {
225             return true;
226         }
227         
228         if (checkRoundState(_round) == RoundState.REFUND) {
229             return true;
230         }
231         
232         if (rounds[_round].participantCount < 10) {
233             rounds[_round].state = RoundState.ACCEPT_FUNDS;
234             emit RoundStateChanged(_round, rounds[_round].state);
235             return true;
236         }
237         
238         rounds[_round].random = _randomNumber;
239         findWinTickets(_round);
240         findWinners(_round);
241         rounds[_round].state = RoundState.SUCCESS;
242         emit RoundStateChanged(_round, rounds[_round].state);
243         
244         if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
245             currentRound = _round.add(1);
246             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
247             emit RoundStateChanged(currentRound, rounds[currentRound].state);
248         }
249         
250         emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
251         getRandomNumber(_round + 1, rounds[_round].nonce);
252         return true;
253     }
254     
255     function restartLottery() public payable onlyOwner {
256         _restartLottery();
257     }
258     
259     function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
260         iRNG(rng).update(_round, _nonce, period);
261     }
262     
263     function setTicketPrice(uint _ticketPrice) public onlyLotteryContract {
264         require(_ticketPrice > 0, "");
265         
266         emit TicketPriceChanged(_ticketPrice);
267         ticketPrice = _ticketPrice;
268     }
269     
270     function findWinTickets(uint _round) public {
271         uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
272         
273         for (uint i = 0; i < 10; i++) {
274             rounds[_round].winningTickets.push(winners[i]);
275         }
276     }
277     
278     function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
279         uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
280         uint winnersNum = 10;
281         
282         uint[10] memory winTickets;
283         uint shift = uint(256).div(winnersNum);
284         
285         for (uint i = 0; i < 10; i++) {
286             winTickets[i] =
287             uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
288         }
289         
290         return winTickets;
291     }
292     
293     function refund(uint _round) public {
294         if (checkRoundState(_round) == RoundState.REFUND
295             && rounds[_round].participantFunds[msg.sender] > 0
296         ) {
297             uint amount = rounds[_round].participantFunds[msg.sender];
298             rounds[_round].participantFunds[msg.sender] = 0;
299             address(msg.sender).transfer(amount);
300             emit RefundIsSuccess(_round, msg.sender, amount);
301         } else {
302             emit RefundIsFailed(_round, msg.sender);
303         }
304     }
305     
306     function checkRoundState(uint _round) public returns (RoundState) {
307         if (rounds[_round].state == RoundState.WAIT_RESULT
308             && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
309         ) {
310             rounds[_round].state = RoundState.REFUND;
311             emit RoundStateChanged(_round, rounds[_round].state);
312         }
313         return rounds[_round].state;
314     }
315     
316     function setOrganiser(address payable _organiser) public onlyOwner {
317         require(_organiser != address(0), "");
318         
319         organiser = _organiser;
320     }
321     
322     function setKYCWhitelist(address _KYCWhitelist) public onlyOwner {
323         require(_KYCWhitelist != address(0), "");
324         
325         KYCWhitelist = iKYCWhitelist(_KYCWhitelist);
326     }
327     
328     function getGain(uint _fromRound, uint _toRound) public {
329         _transferGain(msg.sender, _fromRound, _toRound);
330     }
331     
332     function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
333         _transferGain(_participant, _fromRound, _toRound);
334     }
335     
336     function getTicketsCount(uint _round) public view returns (uint) {
337         return rounds[_round].ticketsCount;
338     }
339     
340     function getTicketPrice() public view returns (uint) {
341         return ticketPrice;
342     }
343     
344     function getCurrentTime() public view returns (uint) {
345         return now;
346     }
347     
348     function getPeriod() public view returns (uint) {
349         return period;
350     }
351     
352     function getRoundWinners(uint _round) public view returns (address[] memory) {
353         return rounds[_round].winners;
354     }
355     
356     function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
357         return rounds[_round].winningTickets;
358     }
359     
360     function getRoundParticipants(uint _round) public view returns (address[] memory) {
361         return rounds[_round].participants;
362     }
363     
364     function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
365         return rounds[_round].winnersFunds[_winner];
366     }
367     
368     function getRoundFunds(uint _round) public view returns (uint) {
369         return rounds[_round].roundFunds;
370     }
371     
372     function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
373         return rounds[_round].participantFunds[_participant];
374     }
375     
376     function getCurrentRound() public view returns (uint) {
377         return currentRound;
378     }
379     
380     function getRoundStartTime(uint _round) public view returns (uint) {
381         return rounds[_round].startRoundTime;
382     }
383     
384     function _restartLottery() internal {
385         uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
386         rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
387         rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
388         emit RoundStateChanged(currentRound, rounds[currentRound].state);
389         iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
390     }
391     
392     function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
393         require(_fromRound <= _toRound, "");
394         require(_participant != address(0), "");
395         
396         if (KYCWhitelist.isWhitelisted(_participant)) {
397             uint funds;
398             
399             for (uint i = _fromRound; i <= _toRound; i++) {
400                 
401                 if (rounds[i].state == RoundState.SUCCESS
402                     && rounds[i].sendGain[_participant] == false) {
403                     
404                     rounds[i].sendGain[_participant] = true;
405                 funds = funds.add(getWinningFunds(i, _participant));
406                     }
407             }
408             
409             require(funds > 0, "");
410             _participant.transfer(funds);
411             emit Withdraw(_participant, funds, _fromRound, _toRound);
412         } else {
413             emit AddressIsNotAddedInKYC(_participant);
414         }
415     }
416     
417     // find participant who has winning ticket
418     // to start: _begin is 0, _end is last index in ticketsInterval array
419     function getWinner(
420         uint _round,
421         uint _beginInterval,
422         uint _endInterval,
423         uint _winningTicket
424     )
425     internal
426     returns (address)
427     {
428         if (_beginInterval == _endInterval) {
429             return rounds[_round].tickets[_beginInterval].participant;
430         }
431         
432         uint len = _endInterval.add(1).sub(_beginInterval);
433         uint mid = _beginInterval.add((len.div(2))).sub(1);
434         TicketsInterval memory interval = rounds[_round].tickets[mid];
435         
436         if (_winningTicket < interval.firstTicket) {
437             return getWinner(_round, _beginInterval, mid, _winningTicket);
438         } else if (_winningTicket > interval.lastTicket) {
439             return getWinner(_round, mid.add(1), _endInterval, _winningTicket);
440         } else {
441             return interval.participant;
442         }
443     }
444     
445     function addParticipant(address _participant, uint _ticketsCount) internal {
446         rounds[currentRound].participants.push(_participant);
447         uint currTicketsCount = rounds[currentRound].ticketsCount;
448         rounds[currentRound].ticketsCount = currTicketsCount.add(_ticketsCount);
449         rounds[currentRound].tickets.push(TicketsInterval(
450             _participant,
451             currTicketsCount,
452             rounds[currentRound].ticketsCount.sub(1))
453         );
454         rounds[currentRound].nonce = rounds[currentRound].nonce + uint(keccak256(abi.encodePacked(_participant)));
455         emit ParticipantAdded(currentRound, _participant, _ticketsCount, _ticketsCount.mul(ticketPrice));
456     }
457     
458     function updateRoundTimeAndState() internal {
459         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
460             && rounds[currentRound].participantCount >= 10
461         ) {
462             rounds[currentRound].state = RoundState.WAIT_RESULT;
463             emit RoundStateChanged(currentRound, rounds[currentRound].state);
464             currentRound = currentRound.add(1);
465             rounds[currentRound].startRoundTime = rounds[currentRound-1].startRoundTime.add(period);
466             rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
467             emit RoundStateChanged(currentRound, rounds[currentRound].state);
468         }
469     }
470     
471     function updateRoundFundsAndParticipants(address _participant, uint _funds) internal {
472         
473         if (rounds[currentRound].participantFunds[_participant] == 0) {
474             rounds[currentRound].participantCount = rounds[currentRound].participantCount.add(1);
475         }
476         
477         rounds[currentRound].participantFunds[_participant] =
478         rounds[currentRound].participantFunds[_participant].add(_funds);
479         
480         rounds[currentRound].roundFunds =
481         rounds[currentRound].roundFunds.add(_funds);
482     }
483     
484     function findWinners(uint _round) internal {
485         address winner;
486         uint fundsToWinner;
487         for (uint i = 0; i < NUMBER_OF_WINNERS; i++) {
488             winner = getWinner(
489                 _round,
490                 0,
491                 (rounds[_round].tickets.length).sub(1),
492                                rounds[_round].winningTickets[i]
493             );
494             
495             rounds[_round].winners.push(winner);
496             fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
497             rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
498         }
499     }
500     
501 }
502 
503 contract iBaseLottery {
504     function getPeriod() public view returns (uint);
505     function buyTickets(address _participant) public payable;
506     function startLottery(uint _startPeriod) public payable;
507     function setTicketPrice(uint _ticketPrice) public;
508     function buyBonusTickets(address _participant, uint _ticketsCount) public;
509 }
510 
511 contract iJackPotChecker {
512     function getPrice() public view returns (uint);
513 }
514 
515 
516 contract MainLottery is BaseLottery {
517     address payable public checker;
518     uint public serviceMinBalance = 1 ether;
519 
520     uint public BET_PRICE;
521 
522     uint constant public HOURLY_LOTTERY_SHARE = 30;                         //30% to hourly lottery
523     uint constant public DAILY_LOTTERY_SHARE = 10;                          //10% to daily lottery
524     uint constant public WEEKLY_LOTTERY_SHARE = 5;                          //5% to weekly lottery
525     uint constant public MONTHLY_LOTTERY_SHARE = 5;                         //5% to monthly lottery
526     uint constant public YEARLY_LOTTERY_SHARE = 5;                          //5% to yearly lottery
527     uint constant public JACKPOT_LOTTERY_SHARE = 10;                        //10% to jackpot lottery
528     uint constant public SUPER_JACKPOT_LOTTERY_SHARE = 15;                  //15% to superJackpot lottery
529     uint constant public LOTTERY_ORGANISER_SHARE = 20;                      //20% to lottery organiser
530     uint constant public SHARE_DENOMINATOR = 100;                           //denominator for share
531 
532     bool public paused;
533 
534     address public dailyLottery;
535     address public weeklyLottery;
536     address public monthlyLottery;
537     address public yearlyLottery;
538     address public jackPot;
539     address public superJackPot;
540 
541     event TransferFunds(address to, uint funds);
542 
543     constructor (
544         address payable _rng,
545         uint _period,
546         address _dailyLottery,
547         address _weeklyLottery,
548         address _monthlyLottery,
549         address _yearlyLottery,
550         address _jackPot,
551         address _superJackPot
552     )
553         public
554         BaseLottery(_rng, _period)
555     {
556         require(_dailyLottery != address(0), "");
557         require(_weeklyLottery != address(0), "");
558         require(_monthlyLottery != address(0), "");
559         require(_yearlyLottery != address(0), "");
560         require(_jackPot != address(0), "");
561         require(_superJackPot != address(0), "");
562 
563         dailyLottery = _dailyLottery;
564         weeklyLottery = _weeklyLottery;
565         monthlyLottery = _monthlyLottery;
566         yearlyLottery = _yearlyLottery;
567         jackPot = _jackPot;
568         superJackPot = _superJackPot;
569     }
570 
571     function () external payable {
572         buyTickets(msg.sender);
573     }
574 
575     function buyTickets(address _participant) public payable {
576         require(!paused, "");
577         require(msg.value > 0, "");
578 
579         uint ETHinUSD = iJackPotChecker(checker).getPrice();
580         BET_PRICE = uint(100).mul(10**18).div(ETHinUSD);    // BET_PRICE is $1 in wei
581 
582         uint funds = msg.value;
583         uint extraFunds = funds.mod(BET_PRICE);
584 
585         if (extraFunds > 0) {
586             organiser.transfer(extraFunds);
587             emit TransferFunds(organiser, extraFunds);
588             funds = funds.sub(extraFunds);
589         }
590 
591         uint fundsToOrginiser = funds.mul(LOTTERY_ORGANISER_SHARE).div(SHARE_DENOMINATOR);
592 
593         fundsToOrginiser = transferToServices(rng, fundsToOrginiser, serviceMinBalance);
594         fundsToOrginiser = transferToServices(checker, fundsToOrginiser, serviceMinBalance);
595 
596         if (fundsToOrginiser > 0) {
597             organiser.transfer(fundsToOrginiser);
598             emit TransferFunds(organiser, fundsToOrginiser);
599         }
600 
601         updateRoundTimeAndState();
602         addParticipant(_participant, funds.div(BET_PRICE));
603         updateRoundFundsAndParticipants(_participant, funds.mul(HOURLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
604 
605         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
606             && rounds[currentRound].participantCount >= 10
607         ) {
608             _restartLottery();
609         }
610 
611         iBaseLottery(dailyLottery).buyTickets.value(funds.mul(DAILY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
612         iBaseLottery(weeklyLottery).buyTickets.value(funds.mul(WEEKLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
613         iBaseLottery(monthlyLottery).buyTickets.value(funds.mul(MONTHLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
614         iBaseLottery(yearlyLottery).buyTickets.value(funds.mul(YEARLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
615         iBaseLottery(jackPot).buyTickets.value(funds.mul(JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
616         iBaseLottery(superJackPot).buyTickets.value(funds.mul(SUPER_JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
617 
618     }
619 
620     function buyBonusTickets(
621         address _participant,
622         uint _mainTicketsCount,
623         uint _dailyTicketsCount,
624         uint _weeklyTicketsCount,
625         uint _monthlyTicketsCount,
626         uint _yearlyTicketsCount,
627         uint _jackPotTicketsCount,
628         uint _superJackPotTicketsCount
629     )
630         public
631         payable
632         onlyManager
633     {
634         require(!paused, "");
635 
636         updateRoundTimeAndState();
637         addParticipant(_participant, _mainTicketsCount);
638         updateRoundFundsAndParticipants(_participant, uint(0));
639 
640         if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
641             && rounds[currentRound].participantCount >= 10
642         ) {
643             _restartLottery();
644         }
645 
646         iBaseLottery(dailyLottery).buyBonusTickets(_participant, _dailyTicketsCount);
647         iBaseLottery(weeklyLottery).buyBonusTickets(_participant, _weeklyTicketsCount);
648         iBaseLottery(monthlyLottery).buyBonusTickets(_participant, _monthlyTicketsCount);
649         iBaseLottery(yearlyLottery).buyBonusTickets(_participant, _yearlyTicketsCount);
650         iBaseLottery(jackPot).buyBonusTickets(_participant, _jackPotTicketsCount);
651         iBaseLottery(superJackPot).buyBonusTickets(_participant, _superJackPotTicketsCount);
652     }
653 
654     function setChecker(address payable _checker) public onlyOwner {
655         require(_checker != address(0), "");
656 
657         checker = _checker;
658     }
659 
660     function setMinBalance(uint _minBalance) public onlyOwner {
661         require(_minBalance >= 1 ether, "");
662 
663         serviceMinBalance = _minBalance;
664     }
665 
666     function pause(bool _paused) public onlyOwner {
667         paused = _paused;
668     }
669 
670     function transferToServices(address payable _service, uint _funds, uint _minBalance) internal returns (uint) {
671         uint result = _funds;
672         if (_service.balance < _minBalance) {
673             uint lack = _minBalance.sub(_service.balance);
674             if (_funds > lack) {
675                 _service.transfer(lack);
676                 emit TransferFunds(_service, lack);
677                 result = result.sub(lack);
678             } else {
679                 _service.transfer(_funds);
680                 emit TransferFunds(_service, _funds);
681                 result = uint(0);
682             }
683         }
684         return result;
685     }
686 }