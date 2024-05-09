1 pragma solidity ^0.4.25;
2 
3 contract GameBoard {
4   uint8 constant public minSquareId = 1;
5   uint8 constant public maxSquareId = 24;
6   uint8 constant public numSquares = 24;
7 }
8 
9 contract JackpotRules {
10   using SafeMath for uint256;
11 
12   constructor() public {}
13 
14   // 50%
15   function _winnerJackpot(uint256 jackpot) public pure returns (uint256) {
16     return jackpot.div(2);
17   }
18 
19   // 40%
20   function _landholderJackpot(uint256 jackpot) public pure returns (uint256) {
21     return (jackpot.mul(2)).div(5);
22   }
23 
24   // 5%
25   function _nextPotJackpot(uint256 jackpot) public pure returns (uint256) {
26     return jackpot.div(20);
27   }
28 
29   // 5%
30   function _teamJackpot(uint256 jackpot) public pure returns (uint256) {
31     return jackpot.div(20);
32   }
33 }
34 
35 library Math {
36   /**
37   * @dev Returns the largest of two numbers.
38   */
39   function max(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   /**
44   * @dev Returns the smallest of two numbers.
45   */
46   function min(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50   /**
51   * @dev Calculates the average of two numbers. Since these are integers,
52   * averages of an even and odd number cannot be represented, and will be
53   * rounded down.
54   */
55   function average(uint256 a, uint256 b) internal pure returns (uint256) {
56     // (a + b) / 2 can overflow, so we distribute
57     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
58   }
59 }
60 
61 contract PullPayment {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) public payments;
65     uint256 public totalPayments;
66 
67     /**
68      * @dev Withdraw accumulated balance, called by payee.
69      */
70     function withdrawPayments() public {
71         address payee = msg.sender;
72         uint256 payment = payments[payee];
73 
74         require(payment != 0);
75         require(address(this).balance >= payment);
76 
77         totalPayments = totalPayments.sub(payment);
78         payments[payee] = 0;
79 
80         payee.transfer(payment);
81     }
82 
83     /**
84      * @dev Called by the payer to store the sent amount as credit to be pulled.
85      * @param dest The destination address of the funds.
86      * @param amount The amount to transfer.
87      */
88     function asyncSend(address dest, uint256 amount) internal {
89         payments[dest] = payments[dest].add(amount);
90         totalPayments = totalPayments.add(amount);
91     }
92 }
93 
94 library SafeMath {
95 
96     /**
97      * @dev Multiplies two numbers, reverts on overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b);
109 
110         return c;
111     }
112 
113     /**
114      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
115      */
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b > 0); // Solidity only automatically asserts when dividing by 0
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Adds two numbers, reverts on overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a);
140 
141         return c;
142     }
143 
144     /**
145      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
146      * reverts when dividing by zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         require(b != 0);
150         return a % b;
151     }
152 }
153 
154 contract TaxRules {
155     using SafeMath for uint256;
156 
157     constructor() public {}
158 
159     // 10%
160     function _priceToTax(uint256 price) public pure returns (uint256) {
161         return price.div(10);
162     }
163 
164     // NOTE: The next methods *must* add up to 100%
165 
166     // 40%
167     function _jackpotTax(uint256 tax) public pure returns (uint256) {
168         return (tax.mul(2)).div(5);
169     }
170 
171     // 38%
172     function _totalLandholderTax(uint256 tax) public pure returns (uint256) {
173         return (tax.mul(19)).div(50);
174     }
175 
176     // 17%/12%
177     function _teamTax(uint256 tax, bool hasReferrer) public pure returns (uint256) {
178         if (hasReferrer) {
179             return (tax.mul(3)).div(25);
180         } else {
181             return (tax.mul(17)).div(100);
182         }
183     }
184     
185     // sell 25% of tokens
186     function _p3dSellPercentage(uint256 tokens) public pure returns (uint256) {
187         return tokens.div(4);
188     }
189 
190     // 5% although only invoked if _teamTax is lower value
191     function _referrerTax(uint256 tax, bool hasReferrer)  public pure returns (uint256) {
192         if (hasReferrer) {
193             return tax.div(20);
194         } else {
195             return 0;
196         }
197     }
198 
199     // 5%
200     function _nextPotTax(uint256 tax) public pure returns (uint256) {
201         return tax.div(20);
202     }
203 }
204 
205 contract Commercializ3d is
206     GameBoard,
207     PullPayment,
208     TaxRules,
209     JackpotRules {
210     using SafeMath for uint256;
211     using Math for uint256;
212 
213     enum Stage {
214         DutchAuction,
215         GameRounds
216     }
217     
218     Stage public stage = Stage.DutchAuction;
219 
220     modifier atStage(Stage _stage) {
221         require(
222             stage == _stage,
223             "Function cannot be called at this stage."
224         );
225         _;
226     }
227 
228     constructor(uint startingStage) public {
229         if (startingStage == uint(Stage.GameRounds)) {
230             stage = Stage.GameRounds;
231             _startGameRound();
232         } else {
233             _startAuction();
234         }
235     }
236 
237     mapping(uint8 => address) public squareToOwner;
238     mapping(uint8 => uint256) public squareToPrice;
239     uint256 public totalSquareValue;
240 
241     function _changeSquarePrice(uint8 squareId, uint256 newPrice) private {
242         uint256 oldPrice = squareToPrice[squareId];
243         squareToPrice[squareId] = newPrice;
244         totalSquareValue = (totalSquareValue.sub(oldPrice)).add(newPrice);
245     }
246 
247     event SquareOwnerChanged(
248         uint8 indexed squareId,
249         address indexed oldOwner,
250         address indexed newOwner,
251         uint256 oldPrice,
252         uint256 newPrice
253     );
254 
255     HourglassInterface constant P3DContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
256     
257     function _buyP3D(uint256 amount) private {
258         P3DContract.buy.value(amount)(0xB111DaBb8EdD8260B5c1E471945A62bE2eE24470);
259     }
260     
261     function _sendP3D(address to, uint256 amount) private {
262         P3DContract.transfer(to, amount);
263     }
264     
265     function getP3DBalance() view public returns(uint256) {
266         return (P3DContract.balanceOf(address(this)));
267     }
268     
269     function getDivsBalance() view public returns(uint256) {
270         return (P3DContract.dividendsOf(address(this)));
271     }
272 
273     event AuctionStarted(
274         uint256 startingAuctionPrice,
275         uint256 endingAuctionPrice,
276         uint256 auctionDuration,
277         uint256 startTime
278     );
279 
280     event AuctionEnded(
281         uint256 endTime
282     );
283 
284     uint256 constant public startingAuctionPrice = 1 ether;
285     uint256 constant public endingAuctionPrice = 0.05 ether;
286     uint256 constant public auctionDuration = 5 days; // period over which land price decreases linearly
287 
288     uint256 public numBoughtSquares;
289     uint256 public auctionStartTime;
290 
291     function buySquareAtAuction(uint8 squareId, uint256 newPrice, address referrer) public payable atStage(Stage.DutchAuction) {
292         require(
293             squareToOwner[squareId] == address(0) && squareToPrice[squareId] == 0,
294             "This square has already been auctioned off"
295         );
296 
297         uint256 tax = _priceToTax(newPrice);
298         uint256 price = getSquarePriceAuction();
299 
300         require(
301             msg.value >= tax.add(price),
302             "Must pay the full price and tax for a square on auction"
303         );
304 
305         _distributeAuctionTax(msg.value, referrer);
306 
307         squareToOwner[squareId] = msg.sender;
308         _changeSquarePrice(squareId, newPrice);
309 
310         numBoughtSquares = numBoughtSquares.add(1);
311 
312         emit SquareOwnerChanged(squareId, address(0), msg.sender, price, newPrice);
313 
314         if (numBoughtSquares >= numSquares) {
315             endAuction();
316         }
317     }
318 
319     function _distributeAuctionTax(uint256 tax, address referrer) private {
320         _distributeLandholderTax(_totalLandholderTax(tax));
321 
322         uint256 totalJackpotTax = _jackpotTax(tax).add(_nextPotTax(tax));
323         nextJackpot = nextJackpot.add(totalJackpotTax);
324 
325         // NOTE: referrer tax comes out of p3d tax
326         bool hasReferrer = referrer != address(0);
327         _buyP3D(_teamTax(tax, hasReferrer));
328         asyncSend(referrer, _referrerTax(tax, hasReferrer));
329     }
330 
331     function getSquarePriceAuction() public view atStage(Stage.DutchAuction) returns (uint256) {
332         uint256 secondsPassed = 0;
333 
334         if (now > auctionStartTime) {
335             secondsPassed = now.sub(auctionStartTime);
336         }
337 
338         if (secondsPassed >= auctionDuration) {
339             return endingAuctionPrice;
340         } else {
341             uint256 maxPriceDelta = startingAuctionPrice.sub(endingAuctionPrice);
342             uint256 actualPriceDelta = (maxPriceDelta.mul(secondsPassed)).div(auctionDuration);
343 
344             return startingAuctionPrice.sub(actualPriceDelta);
345         }
346     }
347 
348     function endAuction() private {
349         require(
350             numBoughtSquares >= numSquares,
351             "All squares must be purchased to end round"
352         );
353 
354         stage = Stage.GameRounds;
355         _startGameRound();
356 
357         emit AuctionEnded(now);
358     }
359 
360     function _startAuction() private {
361         auctionStartTime = now;
362         numBoughtSquares = 0;
363 
364         emit AuctionStarted(startingAuctionPrice,
365                             endingAuctionPrice,
366                             auctionDuration,
367                             auctionStartTime);
368     }
369 
370     uint256 constant public startingRoundExtension = 12 hours;
371     uint256 constant public maxRoundExtension = 24 hours;
372     uint256 constant public roundExtension = 10 minutes;
373     
374     uint256 public roundNumber = 0;
375 
376     uint256 public roundEndTime;
377 
378     uint256 public jackpot;
379     uint256 public nextJackpot;
380 
381     event SquarePriceChanged(
382         uint8 indexed squareId,
383         address indexed owner,
384         uint256 oldPrice,
385         uint256 newPrice
386     );
387 
388     event GameRoundStarted(
389         uint256 initJackpot,
390         uint256 endTime,
391         uint256 roundNumber
392     );
393 
394     event GameRoundExtended(
395         uint256 endTime
396     );
397 
398     event GameRoundEnded(
399         uint256 jackpot
400     );
401 
402     function roundTimeRemaining() public view atStage(Stage.GameRounds) returns (uint256)  {
403         if (_roundOver()) {
404             return 0;
405         } else {
406             return roundEndTime.sub(now);
407         }
408     }
409 
410     function _extendRound() private {
411         if (roundEndTime.add(roundExtension).sub(now) < maxRoundExtension) {
412             roundEndTime = roundEndTime.add(roundExtension);
413         }
414 
415         emit GameRoundExtended(roundEndTime);
416     }
417 
418     function _startGameRound() private {
419         jackpot = nextJackpot;
420         nextJackpot = 0;
421 
422         roundNumber = roundNumber.add(1);
423 
424         _extendRound();
425 
426         emit GameRoundStarted(jackpot, roundEndTime, roundNumber);
427     }
428 
429     function _roundOver() private view returns (bool) {
430         return now >= roundEndTime;
431     }
432 
433     modifier duringRound() {
434         require(
435             !_roundOver(),
436             "Round is over"
437         );
438         _;
439     }
440 
441     function endGameRound() public atStage(Stage.GameRounds) {
442         require(
443             _roundOver(),
444             "Round must be over!"
445         );
446 
447         _distributeJackpot();
448 
449         emit GameRoundEnded(jackpot);
450 
451         _startGameRound();
452     }
453 
454     function setSquarePrice(uint8 squareId, uint256 newPrice, address referrer)
455         public
456         payable
457         atStage(Stage.GameRounds)
458         duringRound {
459         require(
460             squareToOwner[squareId] == msg.sender,
461             "Can't set square price for a square you don't own!"
462         );
463 
464         uint256 tax = _priceToTax(newPrice);
465 
466         require(
467             msg.value >= tax,
468             "Must pay tax on new square price!"
469         );
470 
471         uint256 oldPrice = squareToPrice[squareId];
472         _distributeTax(msg.value, referrer);
473         _changeSquarePrice(squareId, newPrice);
474 
475         _extendRound();
476 
477         emit SquarePriceChanged(squareId, squareToOwner[squareId], oldPrice, newPrice);
478     }
479 
480     function buySquare(uint8 squareId, uint256 newPrice, address referrer)
481         public
482         payable
483         atStage(Stage.GameRounds)
484         duringRound {
485         address oldOwner = squareToOwner[squareId];
486         require(
487             oldOwner != msg.sender,
488             "Can't buy a square you already own"
489         );
490 
491         uint256 tax = _priceToTax(newPrice);
492 
493         uint256 oldPrice = squareToPrice[squareId];
494         require(
495             msg.value >= tax.add(oldPrice),
496             "Must pay full price and tax for square"
497         );
498 
499         // pay seller
500         asyncSend(oldOwner, squareToPrice[squareId]);
501         squareToOwner[squareId] = msg.sender;
502 
503         uint256 actualTax = msg.value.sub(oldPrice);
504         _distributeTax(actualTax, referrer);
505 
506         _changeSquarePrice(squareId, newPrice);
507         _extendRound();
508 
509         emit SquareOwnerChanged(squareId, oldOwner, msg.sender, oldPrice, newPrice);
510     }
511 
512     function _distributeJackpot() private {
513         uint256 winnerJackpot = _winnerJackpot(jackpot);
514         uint256 landholderJackpot = _landholderJackpot(jackpot);
515         
516         // get divs
517         uint256 divs = getDivsBalance();
518         if (divs > 0) {
519             P3DContract.withdraw();
520         }
521         
522         // add divs to landholderJackpot
523         landholderJackpot = landholderJackpot.add(divs);
524         
525         _distributeWinnerAndLandholderJackpot(winnerJackpot, landholderJackpot);
526 
527         _buyP3D(_teamJackpot(jackpot));
528         
529         nextJackpot = nextJackpot.add(_nextPotJackpot(jackpot));
530     }
531 
532     function _calculatePriceComplement(uint8 squareId) private view returns (uint256) {
533         return totalSquareValue.sub(squareToPrice[squareId]);
534     }
535 
536     // NOTE: These are bundled together so that we only have to compute complements once
537     function _distributeWinnerAndLandholderJackpot(uint256 winnerJackpot, uint256 landholderJackpot) private {
538         uint256[] memory complements = new uint256[](numSquares + 1); // inc necessary b/c squares are 1-indexed
539         uint256 totalPriceComplement = 0;
540 
541         uint256 bestComplement = 0;
542         uint8 lastWinningSquareId = 0;
543         for (uint8 i = minSquareId; i <= maxSquareId; i++) {
544             uint256 priceComplement = _calculatePriceComplement(i);
545 
546             // update winner
547             if (bestComplement == 0 || priceComplement > bestComplement) {
548                 bestComplement = priceComplement;
549                 lastWinningSquareId = i;
550             }
551 
552             complements[i] = priceComplement;
553             totalPriceComplement = totalPriceComplement.add(priceComplement);
554         }
555         uint256 numWinners = 0;
556         for (i = minSquareId; i <= maxSquareId; i++) {
557             if (_calculatePriceComplement(i) == bestComplement) {
558                 numWinners++;
559             }
560         }
561         
562         // transfer some % P3D tokens to (why? see )
563         uint256 p3dTokens = getP3DBalance();
564     
565         // distribute jackpot among all winners. save time on the majority (1-winner) case
566         if (numWinners == 1) {
567             asyncSend(squareToOwner[lastWinningSquareId], winnerJackpot);
568             
569             if (p3dTokens > 0) {
570                 _sendP3D(squareToOwner[lastWinningSquareId], _p3dSellPercentage(p3dTokens));
571             }
572         } else {
573             for (i = minSquareId; i <= maxSquareId; i++) {
574                 if (_calculatePriceComplement(i) == bestComplement) {
575                     asyncSend(squareToOwner[i], winnerJackpot.div(numWinners));
576                     
577                     if (p3dTokens > 0) {
578                         _sendP3D(squareToOwner[i], _p3dSellPercentage(p3dTokens));
579                     }
580                 }
581             }
582         }
583 
584         // distribute landholder things
585         for (i = minSquareId; i <= maxSquareId; i++) {
586             // NOTE: We don't exclude the jackpot winner(s) here, so the winner(s) is paid 'twice'
587             uint256 landholderAllocation = complements[i].mul(landholderJackpot).div(totalPriceComplement);
588 
589             asyncSend(squareToOwner[i], landholderAllocation);
590         }
591     }
592 
593     function _distributeTax(uint256 tax, address referrer) private {
594         jackpot = jackpot.add(_jackpotTax(tax));
595 
596         _distributeLandholderTax(_totalLandholderTax(tax));
597         nextJackpot = nextJackpot.add(_nextPotTax(tax));
598 
599         // NOTE: referrer tax comes out of p3d tax
600         bool hasReferrer = referrer != address(0);
601         _buyP3D(_teamTax(tax, hasReferrer));
602         asyncSend(referrer, _referrerTax(tax, hasReferrer));
603     }
604 
605     function _distributeLandholderTax(uint256 tax) private {
606         for (uint8 square = minSquareId; square <= maxSquareId; square++) {
607             if (squareToOwner[square] != address(0) && squareToPrice[square] != 0) {
608                 uint256 squarePrice = squareToPrice[square];
609                 uint256 allocation = tax.mul(squarePrice).div(totalSquareValue);
610 
611                 asyncSend(squareToOwner[square], allocation);
612             }
613         }
614     }
615     
616     function() payable {}
617 }
618 
619 interface HourglassInterface  {
620     function() payable external;
621     function buy(address _playerAddress) payable external returns(uint256);
622     function sell(uint256 _amountOfTokens) external;
623     function reinvest() external;
624     function withdraw() external;
625     function exit() external;
626     function dividendsOf(address _playerAddress) external view returns(uint256);
627     function balanceOf(address _playerAddress) external view returns(uint256);
628     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
629     function stakingRequirement() external view returns(uint256);
630 }