1 pragma solidity ^0.4.25;
2 
3 contract GameBoard {
4 
5   uint8 constant public minSquareId = 1;
6   uint8 constant public maxSquareId = 24;
7   uint8 constant public numSquares = 24;
8 }
9 
10 contract JackpotRules {
11   using SafeMath for uint256;
12 
13   constructor() public {}
14 
15   // NOTE: The next methods *must* add up to 100%
16 
17   // 50%
18   function _winnerJackpot(uint256 jackpot) public pure returns (uint256) {
19     return jackpot.div(2);
20   }
21 
22   // 40%
23   function _landholderJackpot(uint256 jackpot) public pure returns (uint256) {
24     return (jackpot.mul(2)).div(5);
25   }
26 
27   // 5%
28   function _nextPotJackpot(uint256 jackpot) public pure returns (uint256) {
29     return jackpot.div(20);
30   }
31 
32   // 5%
33   function _teamJackpot(uint256 jackpot) public pure returns (uint256) {
34     return jackpot.div(20);
35   }
36 }
37 
38 library Math {
39   /**
40   * @dev Returns the largest of two numbers.
41   */
42   function max(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   /**
47   * @dev Returns the smallest of two numbers.
48   */
49   function min(uint256 a, uint256 b) internal pure returns (uint256) {
50     return a < b ? a : b;
51   }
52 
53   /**
54   * @dev Calculates the average of two numbers. Since these are integers,
55   * averages of an even and odd number cannot be represented, and will be
56   * rounded down.
57   */
58   function average(uint256 a, uint256 b) internal pure returns (uint256) {
59     // (a + b) / 2 can overflow, so we distribute
60     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
61   }
62 }
63 
64 contract Ownable {
65     address public owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71      * account.
72      */
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address newOwner) public onlyOwner {
90         require(newOwner != address(0));
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93     }
94 }
95 
96 contract PullPayment {
97     using SafeMath for uint256;
98 
99     mapping(address => uint256) public payments;
100     uint256 public totalPayments;
101 
102     /**
103      * @dev Withdraw accumulated balance, called by payee.
104      */
105     function withdrawPayments() public {
106         address payee = msg.sender;
107         uint256 payment = payments[payee];
108 
109         require(payment != 0);
110         require(address(this).balance >= payment);
111 
112         totalPayments = totalPayments.sub(payment);
113         payments[payee] = 0;
114 
115         payee.transfer(payment);
116     }
117 
118     /**
119      * @dev Called by the payer to store the sent amount as credit to be pulled.
120      * @param dest The destination address of the funds.
121      * @param amount The amount to transfer.
122      */
123     function asyncSend(address dest, uint256 amount) internal {
124         payments[dest] = payments[dest].add(amount);
125         totalPayments = totalPayments.add(amount);
126     }
127 }
128 
129 library SafeMath {
130 
131     /**
132      * @dev Multiplies two numbers, reverts on overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b);
144 
145         return c;
146     }
147 
148     /**
149      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b > 0); // Solidity only automatically asserts when dividing by 0
153         uint256 c = a / b;
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 
156         return c;
157     }
158 
159     /**
160      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b <= a);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Adds two numbers, reverts on overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a);
175 
176         return c;
177     }
178 
179     /**
180      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
181      * reverts when dividing by zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b != 0);
185         return a % b;
186     }
187 }
188 
189 contract TaxRules {
190     using SafeMath for uint256;
191 
192     constructor() public {}
193 
194     // 10%
195     function _priceToTax(uint256 price) public pure returns (uint256) {
196         return price.div(10);
197     }
198 
199     // NOTE: The next methods *must* add up to 100%
200 
201     // 40%
202     function _jackpotTax(uint256 tax) public pure returns (uint256) {
203         return (tax.mul(2)).div(5);
204     }
205 
206     // 38%
207     function _totalLandholderTax(uint256 tax) public pure returns (uint256) {
208         return (tax.mul(19)).div(50);
209     }
210 
211     // 17%/12%
212     function _teamTax(uint256 tax, bool hasReferrer) public pure returns (uint256) {
213         if (hasReferrer) {
214             return (tax.mul(3)).div(25);
215         } else {
216             return (tax.mul(17)).div(100);
217         }
218     }
219     
220     // sell 25% of tokens
221     function _p3dSellPercentage(uint256 tokens) public pure returns (uint256) {
222         return tokens.div(4);
223     }
224 
225     // 5% although only invoked if _teamTax is lower value
226     function _referrerTax(uint256 tax, bool hasReferrer)  public pure returns (uint256) {
227         if (hasReferrer) {
228             return tax.div(20);
229         } else {
230             return 0;
231         }
232     }
233 
234     // 5%
235     function _nextPotTax(uint256 tax) public pure returns (uint256) {
236         return tax.div(20);
237     }
238 }
239 
240 contract Commercializ3d is
241     GameBoard,
242     PullPayment,
243     Ownable,
244     TaxRules,
245     JackpotRules {
246     using SafeMath for uint256;
247     using Math for uint256;
248 
249     enum Stage {
250         DutchAuction,
251         GameRounds
252     }
253     Stage public stage = Stage.DutchAuction;
254 
255     modifier atStage(Stage _stage) {
256         require(
257             stage == _stage,
258             "Function cannot be called at this stage."
259         );
260         _;
261     }
262 
263     constructor(uint startingStage) public {
264         if (startingStage == uint(Stage.GameRounds)) {
265             stage = Stage.GameRounds;
266             _startGameRound();
267         } else {
268             _startAuction();
269         }
270     }
271 
272     mapping(uint8 => address) public squareToOwner;
273     mapping(uint8 => uint256) public squareToPrice;
274     uint256 public totalSquareValue;
275 
276     function _changeSquarePrice(uint8 squareId, uint256 newPrice) private {
277         uint256 oldPrice = squareToPrice[squareId];
278         squareToPrice[squareId] = newPrice;
279         totalSquareValue = (totalSquareValue.sub(oldPrice)).add(newPrice);
280     }
281 
282     event SquareOwnerChanged(
283         uint8 indexed squareId,
284         address indexed oldOwner,
285         address indexed newOwner,
286         uint256 oldPrice,
287         uint256 newPrice
288     );
289 
290     HourglassInterface constant P3DContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
291     
292     function _buyP3D(uint256 amount) private {
293         P3DContract.buy.value(amount)(0xB111DaBb8EdD8260B5c1E471945A62bE2eE24470);
294     }
295     
296     function _sendP3D(address to, uint256 amount) private {
297         P3DContract.transfer(to, amount);
298     }
299     
300     function getP3DBalance() view public returns(uint256) {
301         return (P3DContract.balanceOf(address(this)));
302     }
303     
304     function getDivsBalance() view public returns(uint256) {
305         return (P3DContract.dividendsOf(address(this)));
306     }
307     
308     function withdrawContractBalance() external onlyOwner {
309         uint256 contractBalance = address(this).balance;
310         uint256 withdrawableBalance = contractBalance.sub(totalPayments);
311 
312         // No withdrawal necessary if <= 0 balance
313         require(withdrawableBalance > 0);
314 
315         asyncSend(msg.sender, withdrawableBalance);
316     }
317 
318     event AuctionStarted(
319         uint256 startingAuctionPrice,
320         uint256 endingAuctionPrice,
321         uint256 auctionDuration,
322         uint256 startTime
323     );
324 
325     event AuctionEnded(
326         uint256 endTime
327     );
328 
329     uint256 constant public startingAuctionPrice = 0.1 ether;
330     uint256 constant public endingAuctionPrice = 0.05 ether;
331     uint256 constant public auctionDuration = 5 days; // period over which land price decreases linearly
332 
333     uint256 public numBoughtSquares;
334     uint256 public auctionStartTime;
335 
336     function buySquareAtAuction(uint8 squareId, uint256 newPrice, address referrer) public payable atStage(Stage.DutchAuction) {
337         require(
338             squareToOwner[squareId] == address(0) && squareToPrice[squareId] == 0,
339             "This square has already been auctioned off"
340         );
341 
342         uint256 tax = _priceToTax(newPrice);
343         uint256 price = getSquarePriceAuction();
344 
345         require(
346             msg.value >= tax.add(price),
347             "Must pay the full price and tax for a square on auction"
348         );
349 
350         _distributeAuctionTax(msg.value, referrer);
351 
352         squareToOwner[squareId] = msg.sender;
353         _changeSquarePrice(squareId, newPrice);
354 
355         numBoughtSquares = numBoughtSquares.add(1);
356 
357         emit SquareOwnerChanged(squareId, address(0), msg.sender, price, newPrice);
358 
359         if (numBoughtSquares >= numSquares) {
360             endAuction();
361         }
362     }
363 
364     function _distributeAuctionTax(uint256 tax, address referrer) private {
365         _distributeLandholderTax(_totalLandholderTax(tax));
366 
367         uint256 totalJackpotTax = _jackpotTax(tax).add(_nextPotTax(tax));
368         nextJackpot = nextJackpot.add(totalJackpotTax);
369 
370         // NOTE: referrer tax comes out of p3d tax
371         bool hasReferrer = referrer != address(0);
372         _buyP3D(_teamTax(tax, hasReferrer));
373         asyncSend(referrer, _referrerTax(tax, hasReferrer));
374     }
375 
376     function getSquarePriceAuction() public view atStage(Stage.DutchAuction) returns (uint256) {
377         return endingAuctionPrice;
378     }
379 
380     function endAuction() private {
381         require(
382             numBoughtSquares >= numSquares,
383             "All squares must be purchased to end round"
384         );
385 
386         stage = Stage.GameRounds;
387         _startGameRound();
388 
389         emit AuctionEnded(now);
390     }
391 
392     function _startAuction() private {
393         auctionStartTime = now;
394         numBoughtSquares = 0;
395 
396         emit AuctionStarted(startingAuctionPrice,
397                             endingAuctionPrice,
398                             auctionDuration,
399                             auctionStartTime);
400     }
401 
402     uint256 constant public startingRoundExtension = 24 hours;
403     uint256 constant public halvingVolume = 10 ether;
404     uint256 constant public minRoundExtension = 10 seconds;
405 
406     uint256 public roundNumber = 0;
407 
408     uint256 public curExtensionVolume;
409     uint256 public curRoundExtension;
410 
411     uint256 public roundEndTime;
412 
413     uint256 public jackpot;
414     uint256 public nextJackpot;
415 
416     event SquarePriceChanged(
417         uint8 indexed squareId,
418         address indexed owner,
419         uint256 oldPrice,
420         uint256 newPrice
421     );
422 
423     event GameRoundStarted(
424         uint256 initJackpot,
425         uint256 endTime,
426         uint256 roundNumber
427     );
428 
429     event GameRoundExtended(
430         uint256 endTime
431     );
432 
433     event GameRoundEnded(
434         uint256 jackpot
435     );
436 
437     function roundTimeRemaining() public view atStage(Stage.GameRounds) returns (uint256)  {
438         if (_roundOver()) {
439             return 0;
440         } else {
441             return roundEndTime.sub(now);
442         }
443     }
444 
445     function _extendRound() private {
446         roundEndTime = roundEndTime.max(now.add(curRoundExtension));
447 
448         emit GameRoundExtended(roundEndTime);
449     }
450 
451     function _startGameRound() private {
452         curExtensionVolume = 0 ether;
453         curRoundExtension = startingRoundExtension;
454 
455         jackpot = nextJackpot;
456         nextJackpot = 0;
457 
458         roundNumber = roundNumber.add(1);
459 
460         _extendRound();
461 
462         emit GameRoundStarted(jackpot, roundEndTime, roundNumber);
463     }
464 
465     function _roundOver() private view returns (bool) {
466         return now >= roundEndTime;
467     }
468 
469     modifier duringRound() {
470         require(
471             !_roundOver(),
472             "Round is over"
473         );
474         _;
475     }
476 
477     // needed for round extension halving
478     function _logRoundExtensionVolume(uint256 amount) private {
479         curExtensionVolume = curExtensionVolume.add(amount);
480 
481         if (curExtensionVolume >= halvingVolume) {
482             curRoundExtension = curRoundExtension.div(2).max(minRoundExtension);
483             curExtensionVolume = 0 ether;
484         }
485     }
486 
487     function endGameRound() public atStage(Stage.GameRounds) {
488         require(
489             _roundOver(),
490             "Round must be over!"
491         );
492 
493         _distributeJackpot();
494 
495         emit GameRoundEnded(jackpot);
496 
497         _startGameRound();
498     }
499 
500     function setSquarePrice(uint8 squareId, uint256 newPrice, address referrer)
501         public
502         payable
503         atStage(Stage.GameRounds)
504         duringRound {
505         require(
506             squareToOwner[squareId] == msg.sender,
507             "Can't set square price for a square you don't own!"
508         );
509 
510         uint256 tax = _priceToTax(newPrice);
511 
512         require(
513             msg.value >= tax,
514             "Must pay tax on new square price!"
515         );
516 
517         uint256 oldPrice = squareToPrice[squareId];
518         _distributeTax(msg.value, referrer);
519         _changeSquarePrice(squareId, newPrice);
520 
521         // NOTE: Currently we extend round for 'every' square price change. Alternatively could do only on
522         // increases or decreases or changes exceeding some magnitude
523         _extendRound();
524         _logRoundExtensionVolume(msg.value);
525 
526         emit SquarePriceChanged(squareId, squareToOwner[squareId], oldPrice, newPrice);
527     }
528 
529     function buySquare(uint8 squareId, uint256 newPrice, address referrer)
530         public
531         payable
532         atStage(Stage.GameRounds)
533         duringRound {
534         address oldOwner = squareToOwner[squareId];
535         require(
536             oldOwner != msg.sender,
537             "Can't buy a square you already own"
538         );
539 
540         uint256 tax = _priceToTax(newPrice);
541 
542         uint256 oldPrice = squareToPrice[squareId];
543         require(
544             msg.value >= tax.add(oldPrice),
545             "Must pay full price and tax for square"
546         );
547 
548         // pay seller
549         asyncSend(oldOwner, squareToPrice[squareId]);
550         squareToOwner[squareId] = msg.sender;
551 
552         uint256 actualTax = msg.value.sub(oldPrice);
553         _distributeTax(actualTax, referrer);
554 
555         _changeSquarePrice(squareId, newPrice);
556         _extendRound();
557         _logRoundExtensionVolume(msg.value);
558 
559         emit SquareOwnerChanged(squareId, oldOwner, msg.sender, oldPrice, newPrice);
560     }
561 
562     function _distributeJackpot() private {
563         uint256 winnerJackpot = _winnerJackpot(jackpot);
564         uint256 landholderJackpot = _landholderJackpot(jackpot);
565         
566         // get divs
567         uint256 divs = getDivsBalance();
568         if (divs > 0) {
569             P3DContract.withdraw();
570         }
571         
572         // add divs to landholderJackpot
573         landholderJackpot = landholderJackpot.add(divs);
574         
575         _distributeWinnerAndLandholderJackpot(winnerJackpot, landholderJackpot);
576 
577         _buyP3D(_teamJackpot(jackpot));
578         
579         nextJackpot = nextJackpot.add(_nextPotJackpot(jackpot));
580     }
581 
582     function _calculatePriceComplement(uint8 squareId) private view returns (uint256) {
583         return totalSquareValue.sub(squareToPrice[squareId]);
584     }
585 
586     // NOTE: These are bundled together so that we only have to compute complements once
587     function _distributeWinnerAndLandholderJackpot(uint256 winnerJackpot, uint256 landholderJackpot) private {
588         uint256[] memory complements = new uint256[](numSquares + 1); // inc necessary b/c squares are 1-indexed
589         uint256 totalPriceComplement = 0;
590 
591         uint256 bestComplement = 0;
592         uint8 lastWinningSquareId = 0;
593         for (uint8 i = minSquareId; i <= maxSquareId; i++) {
594             uint256 priceComplement = _calculatePriceComplement(i);
595 
596             // update winner
597             if (bestComplement == 0 || priceComplement > bestComplement) {
598                 bestComplement = priceComplement;
599                 lastWinningSquareId = i;
600             }
601 
602             complements[i] = priceComplement;
603             totalPriceComplement = totalPriceComplement.add(priceComplement);
604         }
605         uint256 numWinners = 0;
606         for (i = minSquareId; i <= maxSquareId; i++) {
607             if (_calculatePriceComplement(i) == bestComplement) {
608                 numWinners++;
609             }
610         }
611         
612         // transfer some % P3D tokens to (why? see )
613         uint256 p3dTokens = getP3DBalance();
614     
615         // distribute jackpot among all winners. save time on the majority (1-winner) case
616         if (numWinners == 1) {
617             asyncSend(squareToOwner[lastWinningSquareId], winnerJackpot);
618             
619             if (p3dTokens > 0) {
620                 _sendP3D(squareToOwner[lastWinningSquareId], _p3dSellPercentage(p3dTokens));
621             }
622         } else {
623             for (i = minSquareId; i <= maxSquareId; i++) {
624                 if (_calculatePriceComplement(i) == bestComplement) {
625                     asyncSend(squareToOwner[i], winnerJackpot.div(numWinners));
626                     
627                     if (p3dTokens > 0) {
628                         _sendP3D(squareToOwner[i], _p3dSellPercentage(p3dTokens));
629                     }
630                 }
631             }
632         }
633 
634         // distribute landholder things
635         for (i = minSquareId; i <= maxSquareId; i++) {
636             // NOTE: We don't exclude the jackpot winner(s) here, so the winner(s) is paid 'twice'
637             uint256 landholderAllocation = complements[i].mul(landholderJackpot).div(totalPriceComplement);
638 
639             asyncSend(squareToOwner[i], landholderAllocation);
640         }
641     }
642 
643     function _distributeTax(uint256 tax, address referrer) private {
644         jackpot = jackpot.add(_jackpotTax(tax));
645 
646         _distributeLandholderTax(_totalLandholderTax(tax));
647         nextJackpot = nextJackpot.add(_nextPotTax(tax));
648 
649         // NOTE: referrer tax comes out of p3d tax
650         bool hasReferrer = referrer != address(0);
651         _buyP3D(_teamTax(tax, hasReferrer));
652         asyncSend(referrer, _referrerTax(tax, hasReferrer));
653     }
654 
655     function _distributeLandholderTax(uint256 tax) private {
656         for (uint8 square = minSquareId; square <= maxSquareId; square++) {
657             if (squareToOwner[square] != address(0) && squareToPrice[square] != 0) {
658                 uint256 squarePrice = squareToPrice[square];
659                 uint256 allocation = tax.mul(squarePrice).div(totalSquareValue);
660 
661                 asyncSend(squareToOwner[square], allocation);
662             }
663         }
664     }
665     
666     function() payable {}
667 }
668 
669 interface HourglassInterface  {
670     function() payable external;
671     function buy(address _playerAddress) payable external returns(uint256);
672     function sell(uint256 _amountOfTokens) external;
673     function reinvest() external;
674     function withdraw() external;
675     function exit() external;
676     function dividendsOf(address _playerAddress) external view returns(uint256);
677     function balanceOf(address _playerAddress) external view returns(uint256);
678     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
679     function stakingRequirement() external view returns(uint256);
680 }