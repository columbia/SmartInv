1 pragma solidity >0.4.99 <0.6.0;
2 
3 contract Parameters {
4 
5     uint public constant PRICE_OF_TOKEN = 0.01 ether;
6     uint public constant MAX_TOKENS_BUY = 80;
7     uint public constant MIN_TICKETS_BUY_FOR_ROUND = 80;
8 
9     uint public maxNumberStepCircle = 40;
10 
11     uint public currentRound;
12     uint public totalEthRaised;
13     uint public totalTicketBuyed;
14 
15     uint public uniquePlayer;
16 
17     uint public numberCurrentTwist;
18 
19     bool public isTwist;
20 
21     bool public isDemo;
22     uint public simulateDate;
23 
24 }
25 
26 library Zero {
27     function requireNotZero(address addr) internal pure {
28         require(addr != address(0), "require not zero address");
29     }
30 
31     function requireNotZero(uint val) internal pure {
32         require(val != 0, "require not zero value");
33     }
34 
35     function notZero(address addr) internal pure returns(bool) {
36         return !(addr == address(0));
37     }
38 
39     function isZero(address addr) internal pure returns(bool) {
40         return addr == address(0);
41     }
42 
43     function isZero(uint a) internal pure returns(bool) {
44         return a == 0;
45     }
46 
47     function notZero(uint a) internal pure returns(bool) {
48         return a != 0;
49     }
50 }
51 
52 library Address {
53     function toAddress(bytes memory source) internal pure returns(address addr) {
54         assembly { addr := mload(add(source,0x14)) }
55         return addr;
56     }
57 
58     function isNotContract(address addr) internal view returns(bool) {
59         uint length;
60         assembly { length := extcodesize(addr) }
61         return length == 0;
62     }
63 }
64 
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that revert on error
69  */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, reverts on overflow.
74     */
75     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
76         if (_a == 0) {
77             return 0;
78         }
79 
80         uint256 c = _a * _b;
81         require(c / _a == _b);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
88     */
89     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
90         require(_b > 0); // Solidity only automatically asserts when dividing by 0
91         uint256 c = _a / _b;
92         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
93 
94         return c;
95     }
96 
97     /**
98     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
99     */
100     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101         require(_b <= _a);
102         uint256 c = _a - _b;
103 
104         return c;
105     }
106 
107     /**
108     * @dev Adds two numbers, reverts on overflow.
109     */
110     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
111         uint256 c = _a + _b;
112         require(c >= _a);
113 
114         return c;
115     }
116 
117 }
118 
119 library Percent {
120     struct percent {
121         uint num;
122         uint den;
123     }
124 
125     function mul(percent storage p, uint a) internal view returns (uint) {
126         if (a == 0) {
127             return 0;
128         }
129         return a*p.num/p.den;
130     }
131 
132     function div(percent storage p, uint a) internal view returns (uint) {
133         return a/p.num*p.den;
134     }
135 
136     function sub(percent storage p, uint a) internal view returns (uint) {
137         uint b = mul(p, a);
138         if (b >= a) {
139             return 0;
140         }
141         return a - b;
142     }
143 
144     function add(percent storage p, uint a) internal view returns (uint) {
145         return a + mul(p, a);
146     }
147 
148     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
149         return Percent.percent(p.num, p.den);
150     }
151 
152     function mmul(percent memory p, uint a) internal pure returns (uint) {
153         if (a == 0) {
154             return 0;
155         }
156         return a*p.num/p.den;
157     }
158 
159     function mdiv(percent memory p, uint a) internal pure returns (uint) {
160         return a/p.num*p.den;
161     }
162 
163     function msub(percent memory p, uint a) internal pure returns (uint) {
164         uint b = mmul(p, a);
165         if (b >= a) {
166             return 0;
167         }
168         return a - b;
169     }
170 
171     function madd(percent memory p, uint a) internal pure returns (uint) {
172         return a + mmul(p, a);
173     }
174 }
175 
176 
177 contract Accessibility {
178     address private owner;
179     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
180 
181     modifier onlyOwner() {
182         require(msg.sender == owner, "access denied");
183         _;
184     }
185 
186     constructor() public {
187         owner = msg.sender;
188     }
189 
190     function changeOwner(address _newOwner) onlyOwner public {
191         require(_newOwner != address(0));
192         emit OwnerChanged(owner, _newOwner);
193         owner = _newOwner;
194     }
195 }
196 
197 
198 contract TicketsStorage is Accessibility, Parameters  {
199     using SafeMath for uint;
200     using Percent for Percent.percent;
201 
202     struct Ticket {
203         address payable wallet;
204         uint winnerRound;
205     }
206 
207     struct CountWinner {
208         uint countWinnerRound_1;
209         uint countWinnerRound_2;
210         uint countWinnerRound_3;
211         uint countWinnerRound_4;
212         uint countWinnerRound_5;
213     }
214 
215     struct PayEachWinner {
216         uint payEachWinner_1;
217         uint payEachWinner_2;
218         uint payEachWinner_3;
219         uint payEachWinner_4;
220         uint payEachWinner_5;
221     }
222 
223     uint private stepEntropy = 1;
224     uint private precisionPay = 4;
225 
226     uint private remainStepTS;
227     uint private countStepTS;
228 
229     mapping (uint => CountWinner) countWinner;
230     // currentRound -> CountWinner
231 
232     mapping (uint => PayEachWinner) payEachWinner;
233     // currentRound -> PayEachWinner
234 
235     mapping (uint => uint) private countTickets;
236     // currentRound -> number ticket
237 
238     mapping (uint => mapping (uint => Ticket)) private tickets;
239     // currentRound -> number ticket -> Ticket
240 
241     mapping (uint => mapping (address => uint)) private balancePlayer;
242     // currentRound -> wallet -> balance player
243 
244     mapping (uint => mapping (address => uint)) private balanceWinner;
245     // currentRound -> wallet -> balance winner
246 
247     mapping (uint => uint[]) private happyTickets;
248     // currentRound -> array happy tickets
249 
250     Percent.percent private percentTicketPrize_2 = Percent.percent(1,100);            // 1.0 %
251     Percent.percent private percentTicketPrize_3 = Percent.percent(4,100);            // 4.0 %
252     Percent.percent private percentTicketPrize_4 = Percent.percent(10,100);            // 10.0 %
253     Percent.percent private percentTicketPrize_5 = Percent.percent(35,100);            // 35.0 %
254 
255     Percent.percent private percentAmountPrize_1 = Percent.percent(1797,10000);            // 17.97%
256     Percent.percent private percentAmountPrize_2 = Percent.percent(1000,10000);            // 10.00%
257     Percent.percent private percentAmountPrize_3 = Percent.percent(1201,10000);            // 12.01%
258     Percent.percent private percentAmountPrize_4 = Percent.percent(2000,10000);            // 20.00%
259     Percent.percent private percentAmountPrize_5 = Percent.percent(3502,10000);            // 35.02%
260 
261 
262     event LogMakeDistribution(uint roundLottery, uint roundDistibution, uint countWinnerRound, uint payEachWinner);
263     event LogHappyTicket(uint roundLottery, uint roundDistibution, uint happyTicket);
264 
265     function isWinner(uint round, uint numberTicket) public view returns (bool) {
266         return tickets[round][numberTicket].winnerRound > 0;
267     }
268 
269     function getBalancePlayer(uint round, address wallet) public view returns (uint) {
270         return balancePlayer[round][wallet];
271     }
272 
273     function getBalanceWinner(uint round, address wallet) public view returns (uint) {
274         return balanceWinner[round][wallet];
275     }
276 
277     function ticketInfo(uint round, uint numberTicket) public view returns(address payable wallet, uint winnerRound) {
278         Ticket memory ticket = tickets[round][numberTicket];
279         wallet = ticket.wallet;
280         winnerRound = ticket.winnerRound;
281     }
282 
283     function newTicket(uint round, address payable wallet, uint priceOfToken) public onlyOwner {
284         countTickets[round]++;
285         Ticket storage ticket = tickets[round][countTickets[round]];
286         ticket.wallet = wallet;
287         balancePlayer[round][wallet] = balancePlayer[round][wallet].add(priceOfToken);
288     }
289 
290     function clearRound(uint round) public {
291         countTickets[round] = 0;
292         countWinner[round] = CountWinner(0,0,0,0,0);
293         payEachWinner[round] = PayEachWinner(0,0,0,0,0);
294         stepEntropy = 1;
295         remainStepTS = 0;
296         countStepTS = 0;
297     }
298 
299     function makeDistribution(uint round, uint priceOfToken) public onlyOwner {
300         uint count = countTickets[round];
301         uint amountEthCurrentRound = count.mul(priceOfToken);
302 
303         makeCountWinnerRound(round, count);
304         makePayEachWinner(round, amountEthCurrentRound);
305 
306         CountWinner memory cw = countWinner[round];
307         PayEachWinner memory pw = payEachWinner[round];
308 
309         emit LogMakeDistribution(round, 1, cw.countWinnerRound_1, pw.payEachWinner_1);
310         emit LogMakeDistribution(round, 2, cw.countWinnerRound_2, pw.payEachWinner_2);
311         emit LogMakeDistribution(round, 3, cw.countWinnerRound_3, pw.payEachWinner_3);
312         emit LogMakeDistribution(round, 4, cw.countWinnerRound_4, pw.payEachWinner_4);
313         emit LogMakeDistribution(round, 5, cw.countWinnerRound_5, pw.payEachWinner_5);
314 
315         if (happyTickets[round].length > 0) {
316             delete happyTickets[round];
317         }
318     }
319 
320     function makeCountWinnerRound(uint round, uint cntTickets) internal {
321         uint cw_1 = 1;
322         uint cw_2 = percentTicketPrize_2.mmul(cntTickets);
323         uint cw_3 = percentTicketPrize_3.mmul(cntTickets);
324         uint cw_4 = percentTicketPrize_4.mmul(cntTickets);
325         uint cw_5 = percentTicketPrize_5.mmul(cntTickets);
326 
327         countWinner[round] = CountWinner(cw_1, cw_2, cw_3, cw_4, cw_5);
328     }
329 
330     function makePayEachWinner(uint round, uint amountEth) internal {
331         CountWinner memory cw = countWinner[round];
332 
333         uint pw_1 = roundEth(percentAmountPrize_1.mmul(amountEth).div(cw.countWinnerRound_1), precisionPay);
334         uint pw_2 = roundEth(percentAmountPrize_2.mmul(amountEth).div(cw.countWinnerRound_2), precisionPay);
335         uint pw_3 = roundEth(percentAmountPrize_3.mmul(amountEth).div(cw.countWinnerRound_3), precisionPay);
336         uint pw_4 = roundEth(percentAmountPrize_4.mmul(amountEth).div(cw.countWinnerRound_4), precisionPay);
337         uint pw_5 = roundEth(percentAmountPrize_5.mmul(amountEth).div(cw.countWinnerRound_5), precisionPay);
338 
339         payEachWinner[round] = PayEachWinner(pw_1, pw_2, pw_3, pw_4, pw_5);
340 
341     }
342 
343     function getCountTickets(uint round) public view returns (uint) {
344         return countTickets[round];
345     }
346 
347     function getCountTwist(uint countsTickets, uint maxCountTicketByStep) public returns(uint countTwist) {
348         countTwist = countsTickets.div(2).div(maxCountTicketByStep);
349         if (countsTickets > countTwist.mul(2).mul(maxCountTicketByStep)) {
350             remainStepTS = countsTickets.sub(countTwist.mul(2).mul(maxCountTicketByStep));
351             countTwist++;
352         }
353         countStepTS = countTwist;
354 
355     }
356 
357     function getMemberArrayHappyTickets(uint round, uint index) public view returns (uint value) {
358         value =  happyTickets[round][index];
359     }
360 
361     function getLengthArrayHappyTickets(uint round) public view returns (uint length) {
362         length = happyTickets[round].length;
363     }
364 
365     function getStepTransfer() public view returns (uint stepTransfer, uint remainTicket) {
366         stepTransfer = countStepTS;
367         remainTicket = remainStepTS;
368     }
369 
370     function getCountWinnersDistrib(uint round) public view returns (uint countWinnerRound_1, uint countWinnerRound_2, uint countWinnerRound_3, uint countWinnerRound_4, uint countWinnerRound_5) {
371         CountWinner memory cw = countWinner[round];
372 
373         countWinnerRound_1 = cw.countWinnerRound_1;
374         countWinnerRound_2 = cw.countWinnerRound_2;
375         countWinnerRound_3 = cw.countWinnerRound_3;
376         countWinnerRound_4 = cw.countWinnerRound_4;
377         countWinnerRound_5 = cw.countWinnerRound_5;
378     }
379 
380     function getPayEachWinnersDistrib(uint round) public view returns (uint payEachWinner_1, uint payEachWinner_2, uint payEachWinner_3, uint payEachWinner_4, uint payEachWinner_5) {
381         PayEachWinner memory pw = payEachWinner[round];
382 
383         payEachWinner_1 = pw.payEachWinner_1;
384         payEachWinner_2 = pw.payEachWinner_2;
385         payEachWinner_3 = pw.payEachWinner_3;
386         payEachWinner_4 = pw.payEachWinner_4;
387         payEachWinner_5 = pw.payEachWinner_5;
388     }
389 
390     function addBalanceWinner(uint round, uint amountPrize, uint happyNumber) public onlyOwner {
391         balanceWinner[round][tickets[round][happyNumber].wallet] = balanceWinner[round][tickets[round][happyNumber].wallet].add(amountPrize);
392     }
393 
394     function setWinnerRountForTicket(uint round, uint winnerRound, uint happyNumber) public onlyOwner {
395         tickets[round][happyNumber].winnerRound = winnerRound;
396     }
397 
398     //            tickets[round][happyNumber].winnerRound = winnerRound;
399 
400     function addHappyNumber(uint round, uint numCurTwist, uint happyNumber) public onlyOwner {
401         happyTickets[round].push(happyNumber);
402         emit LogHappyTicket(round, numCurTwist, happyNumber);
403     }
404 
405     function findHappyNumber(uint round) public onlyOwner returns(uint) {
406         stepEntropy++;
407         uint happyNumber = getRandomNumberTicket(stepEntropy, round);
408         while (tickets[round][happyNumber].winnerRound > 0) {
409             stepEntropy++;
410             happyNumber++;
411             if (happyNumber > countTickets[round]) {
412                 happyNumber = 1;
413             }
414         }
415         return happyNumber;
416     }
417 
418     function getRandomNumberTicket(uint entropy, uint round) public view returns(uint) {
419         require(countTickets[round] > 0, "number of tickets must be greater than 0");
420         uint randomFirst = maxRandom(block.number, msg.sender).div(now);
421         uint randomNumber = randomFirst.mul(entropy) % (countTickets[round]);
422         if (randomNumber == 0) { randomNumber = 1;}
423         return randomNumber;
424     }
425 
426     function random(uint upper, uint blockn, address entropy) internal view returns (uint randomNumber) {
427         return maxRandom(blockn, entropy) % upper;
428     }
429 
430     function maxRandom(uint blockn, address entropy) internal view returns (uint randomNumber) {
431         return uint(keccak256(
432                 abi.encodePacked(
433                     blockhash(blockn),
434                     entropy)
435             ));
436     }
437 
438     function roundEth(uint numerator, uint precision) internal pure returns(uint round) {
439         if (precision > 0 && precision < 18) {
440             uint256 _numerator = numerator / 10 ** (18 - precision - 1);
441             //            _numerator = (_numerator + 5) / 10;
442             _numerator = (_numerator) / 10;
443             round = (_numerator) * 10 ** (18 - precision);
444         }
445     }
446 
447 
448 }
449 
450 contract SundayLottery is Accessibility, Parameters {
451     using SafeMath for uint;
452 
453     using Address for *;
454     using Zero for *;
455 
456     TicketsStorage private m_tickets;
457     mapping (address => bool) private notUnigue;
458 
459 
460     address payable public administrationWallet;
461 
462     uint private countWinnerRound_1;
463     uint private countWinnerRound_2;
464     uint private countWinnerRound_3;
465     uint private countWinnerRound_4;
466     uint private countWinnerRound_5;
467 
468     uint private payEachWinner_1;
469     uint private payEachWinner_2;
470     uint private payEachWinner_3;
471     uint private payEachWinner_4;
472     uint private payEachWinner_5;
473 
474     uint private remainStep;
475     uint private countStep;
476 
477     // more events for easy read from blockchain
478     event LogNewTicket(address indexed addr, uint when, uint round);
479     event LogBalanceChanged(uint when, uint balance);
480     event LogChangeTime(uint newDate, uint oldDate);
481     event LogRefundEth(address indexed player, uint value);
482     event LogWinnerDefine(uint roundLottery, uint typeWinner, uint step);
483     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
484     event SendToAdministrationWallet(uint balanceContract);
485     event Play(uint currentRound, uint numberCurrentTwist);
486 
487     modifier balanceChanged {
488         _;
489         emit LogBalanceChanged(getCurrentDate(), address(this).balance);
490     }
491 
492     modifier notFromContract() {
493         require(msg.sender.isNotContract(), "only externally accounts");
494         _;
495     }
496 
497     constructor(address payable _administrationWallet) public {
498         require(_administrationWallet != address(0));
499         administrationWallet = _administrationWallet;
500         m_tickets = new TicketsStorage();
501         currentRound = 1;
502         m_tickets.clearRound(currentRound);
503     }
504 
505     function() external payable {
506         if (msg.value >= PRICE_OF_TOKEN) {
507             buyTicket(msg.sender);
508         } else if (msg.value.isZero()) {
509             makeTwists();
510         } else {
511             refundEth(msg.sender, msg.value);
512         }
513     }
514 
515     function getMemberArrayHappyTickets(uint round, uint index) public view returns (uint value) {
516         value =  m_tickets.getMemberArrayHappyTickets(round, index);
517     }
518 
519     function getLengthArrayHappyTickets(uint round) public view returns (uint length) {
520         length =  m_tickets.getLengthArrayHappyTickets(round);
521     }
522 
523     function getTicketInfo(uint round, uint index) public view returns (address payable wallet, uint winnerRound) {
524         (wallet, winnerRound) =  m_tickets.ticketInfo(round, index);
525     }
526 
527     function getCountWinnersDistrib() public view returns (uint countWinRound_1, uint countWinRound_2,
528         uint countWinRound_3, uint countWinRound_4, uint countWinRound_5) {
529         (countWinRound_1, countWinRound_2, countWinRound_3,
530         countWinRound_4, countWinRound_5) = m_tickets.getCountWinnersDistrib(currentRound);
531     }
532 
533     function getPayEachWinnersDistrib() public view returns (uint payEachWin_1, uint payEachWin_2,
534         uint payEachWin_3, uint payEachWin_4, uint payEachWin_5) {
535         (payEachWin_1, payEachWin_2, payEachWin_3,
536         payEachWin_4, payEachWin_5) = m_tickets.getPayEachWinnersDistrib(currentRound);
537     }
538 
539     function getStepTransfer() public view returns (uint stepTransferVal, uint remainTicketVal) {
540         (stepTransferVal, remainTicketVal) = m_tickets.getStepTransfer();
541     }
542 
543     function loadWinnersPerRound() internal {
544         (countWinnerRound_1, countWinnerRound_2, countWinnerRound_3,
545         countWinnerRound_4, countWinnerRound_5) = getCountWinnersDistrib();
546     }
547 
548     function loadPayEachWinners() internal {
549         (payEachWinner_1, payEachWinner_2, payEachWinner_3,
550         payEachWinner_4, payEachWinner_5) = getPayEachWinnersDistrib();
551     }
552 
553     function loadCountStep() internal {
554         (countStep, remainStep) = m_tickets.getStepTransfer();
555     }
556 
557     function balanceETH() external view returns(uint) {
558         return address(this).balance;
559     }
560 
561     function refundEth(address payable _player, uint _value) internal returns (bool) {
562         require(_player.notZero());
563         _player.transfer(_value);
564         emit LogRefundEth(_player, _value);
565     }
566 
567     function buyTicket(address payable _addressPlayer) public payable notFromContract balanceChanged {
568         uint investment = msg.value;
569         require(investment >= PRICE_OF_TOKEN, "investment must be >= PRICE_OF_TOKEN");
570         require(!isTwist, "ticket purchase is prohibited during the twist");
571 
572         uint tickets = investment.div(PRICE_OF_TOKEN);
573         if (tickets > MAX_TOKENS_BUY) {
574             tickets = MAX_TOKENS_BUY;
575         }
576         uint requireEth = tickets.mul(PRICE_OF_TOKEN);
577         if (investment > requireEth) {
578             refundEth(msg.sender, investment.sub(requireEth));
579         }
580 
581         if (tickets > 0) {
582             uint currentDate = now;
583             while (tickets != 0) {
584                 m_tickets.newTicket(currentRound, _addressPlayer, PRICE_OF_TOKEN);
585                 emit LogNewTicket(_addressPlayer, currentDate, currentRound);
586                 currentDate++;
587                 totalTicketBuyed++;
588                 tickets--;
589             }
590         }
591 
592         if (!notUnigue[_addressPlayer]) {
593             notUnigue[_addressPlayer] = true;
594             uniquePlayer++;
595         }
596         totalEthRaised = totalEthRaised.add(requireEth);
597     }
598 
599     function makeTwists() public notFromContract {
600         uint countTickets = m_tickets.getCountTickets(currentRound);
601         require(countTickets > MIN_TICKETS_BUY_FOR_ROUND, "the number of tickets purchased must be >= MIN_TICKETS_BUY_FOR_ROUND");
602         require(isSunday(getCurrentDate()), "you can only play on Sunday");
603         if (!isTwist) {
604             numberCurrentTwist = m_tickets.getCountTwist(countTickets, maxNumberStepCircle);
605             m_tickets.makeDistribution(currentRound, PRICE_OF_TOKEN);
606             isTwist = true;
607             loadWinnersPerRound();
608             loadPayEachWinners();
609             loadCountStep();
610         } else {
611             if (numberCurrentTwist > 0) {
612                 play(currentRound, maxNumberStepCircle);
613                 emit Play(currentRound, numberCurrentTwist);
614                 numberCurrentTwist--;
615                 if (numberCurrentTwist == 0) {
616                     isTwist = false;
617                     currentRound++;
618                     m_tickets.clearRound(currentRound);
619                     sendToAdministration();
620                 }
621             }
622         }
623     }
624 
625     function play(uint round, uint maxCountTicketByStep) internal {
626         uint countTransfer = 0;
627         uint numberTransfer = 0;
628         if (remainStep > 0) {
629             if (countStep > 1) {
630                 countTransfer = maxCountTicketByStep;
631             } else {
632                 countTransfer = remainStep;
633             }
634         } else {
635             countTransfer = maxCountTicketByStep;
636         }
637 
638         if (countStep > 0) {
639             if (countWinnerRound_1 > 0 && numberTransfer < countTransfer) {
640                 if (transferPrize(payEachWinner_1, round, 1)) {
641                     countWinnerRound_1--;
642                     emit LogWinnerDefine(round, 1, numberTransfer);
643                 }
644                 numberTransfer++;
645             }
646             if (countWinnerRound_2 > 0 && numberTransfer < countTransfer) {
647                 while (numberTransfer < countTransfer && countWinnerRound_2 > 0) {
648                     if (transferPrize(payEachWinner_2, round, 2)) {
649                         countWinnerRound_2--;
650                         emit LogWinnerDefine(round, 2, numberTransfer);
651                     }
652                     numberTransfer++;
653                 }
654             }
655             if (countWinnerRound_3 > 0 && numberTransfer < countTransfer) {
656                 while (numberTransfer < countTransfer && countWinnerRound_3 > 0) {
657                     if (transferPrize(payEachWinner_3, round, 3)) {
658                         countWinnerRound_3--;
659                         emit LogWinnerDefine(round, 3, numberTransfer);
660                     }
661                     numberTransfer++;
662                 }
663             }
664             if (countWinnerRound_4 > 0 && numberTransfer < countTransfer) {
665                 while (numberTransfer < countTransfer && countWinnerRound_4 > 0) {
666                     if (transferPrize(payEachWinner_4, round, 4)) {
667                         countWinnerRound_4--;
668                         emit LogWinnerDefine(round, 4, numberTransfer);
669                     }
670                     numberTransfer++;
671                 }
672             }
673             if (countWinnerRound_5 > 0 && numberTransfer < countTransfer) {
674                 while (numberTransfer < countTransfer && countWinnerRound_5 > 0) {
675                     if (transferPrize(payEachWinner_5, round, 5)) {
676                         countWinnerRound_5--;
677                         emit LogWinnerDefine(round, 5, numberTransfer);
678                     }
679                     numberTransfer++;
680                 }
681             }
682 
683             countStep--;
684         }
685     }
686 
687     function transferPrize(uint amountPrize, uint round, uint winnerRound) internal returns(bool) {
688         if (address(this).balance > amountPrize) {
689             uint happyNumber = m_tickets.findHappyNumber(round);
690             m_tickets.addHappyNumber(currentRound, numberCurrentTwist, happyNumber);
691             m_tickets.addBalanceWinner(currentRound, amountPrize, happyNumber);
692             m_tickets.setWinnerRountForTicket(currentRound, winnerRound, happyNumber);
693             (address payable wallet, ) =  m_tickets.ticketInfo(round, happyNumber);
694             wallet.transfer(amountPrize);
695             return true;
696         } else {
697             return false;
698         }
699     }
700 
701     function setMaxNumberStepCircle(uint256 _number) external onlyOwner {
702         require(_number > 0);
703         maxNumberStepCircle = _number;
704     }
705 
706     function getBalancePlayer(uint round, address wallet) external view returns (uint) {
707         return m_tickets.getBalancePlayer(round, wallet);
708     }
709 
710     function getBalanceWinner(uint round, address wallet) external view returns (uint) {
711         return m_tickets.getBalanceWinner(round, wallet);
712     }
713 
714     function getCurrentDate() public view returns (uint) {
715         if (isDemo) {
716             return simulateDate;
717         }
718         return now;
719     }
720 
721     function setSimulateDate(uint _newDate) external onlyOwner {
722         if (isDemo) {
723             require(_newDate > simulateDate);
724             emit LogChangeTime(_newDate, simulateDate);
725             simulateDate = _newDate;
726         }
727     }
728 
729     function setDemo() external onlyOwner {
730         if (uniquePlayer == 0) {
731             isDemo = true;
732         }
733     }
734 
735     function isSunday(uint timestamp) public pure returns (bool) {
736         uint numberDay = (timestamp / (1 days) + 4) % 7;
737         if (numberDay == 0) {
738             return true;
739         } else {
740             return false;
741         }
742     }
743 
744     function getCountTickets(uint round) public view returns (uint countTickets) {
745         countTickets = m_tickets.getCountTickets(round);
746     }
747 
748     function setAdministrationWallet(address payable _newWallet) external onlyOwner {
749         require(_newWallet != address(0));
750         address payable _oldWallet = administrationWallet;
751         administrationWallet = _newWallet;
752         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
753     }
754 
755     function sendToAdministration() internal {
756         require(administrationWallet != address(0), "wallet address is not 0");
757         uint amount = address(this).balance;
758 
759         if (amount > 0) {
760             if (administrationWallet.send(amount)) {
761                 emit SendToAdministrationWallet(amount);
762             }
763         }
764     }
765 
766 }