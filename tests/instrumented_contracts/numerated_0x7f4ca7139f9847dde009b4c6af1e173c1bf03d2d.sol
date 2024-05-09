1 pragma solidity ^0.4.13;
2 
3 contract HexBoard3 {
4 
5   // To ease iteration
6   uint8 constant public minTileId= 1;
7   uint8 constant public maxTileId = 19;
8   uint8 constant public numTiles = 19;
9 
10   // Any 0s in the neighbor array represent non-neighbors. There might be a better way to do this, but w/e
11   mapping(uint8 => uint8[6]) public tileToNeighbors;
12   uint8 constant public nullNeighborValue = 0;
13 
14   // TODO: Add neighbor calculation in if we want to use neighbors in jackpot calculation
15   constructor() public {
16   }
17 }
18 
19 contract JackpotRules {
20   using SafeMath for uint256;
21 
22   constructor() public {}
23 
24   // NOTE: The next methods *must* add up to 100%
25 
26   // 50%
27   function _winnerJackpot(uint256 jackpot) public pure returns (uint256) {
28     return jackpot.div(2);
29   }
30 
31   // 40%
32   function _landholderJackpot(uint256 jackpot) public pure returns (uint256) {
33     return (jackpot.mul(2)).div(5);
34   }
35 
36   // 5%
37   function _nextPotJackpot(uint256 jackpot) public pure returns (uint256) {
38     return jackpot.div(20);
39   }
40 
41   // 5%
42   function _teamJackpot(uint256 jackpot) public pure returns (uint256) {
43     return jackpot.div(20);
44   }
45 }
46 
47 library Math {
48   /**
49   * @dev Returns the largest of two numbers.
50   */
51   function max(uint256 a, uint256 b) internal pure returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   /**
56   * @dev Returns the smallest of two numbers.
57   */
58   function min(uint256 a, uint256 b) internal pure returns (uint256) {
59     return a < b ? a : b;
60   }
61 
62   /**
63   * @dev Calculates the average of two numbers. Since these are integers,
64   * averages of an even and odd number cannot be represented, and will be
65   * rounded down.
66   */
67   function average(uint256 a, uint256 b) internal pure returns (uint256) {
68     // (a + b) / 2 can overflow, so we distribute
69     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
70   }
71 }
72 
73 contract Ownable {
74     address public owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         require(newOwner != address(0));
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102     }
103 }
104 
105 contract PullPayment {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) public payments;
109     uint256 public totalPayments;
110 
111     /**
112      * @dev Withdraw accumulated balance, called by payee.
113      */
114     function withdrawPayments() public {
115         address payee = msg.sender;
116         uint256 payment = payments[payee];
117 
118         require(payment != 0);
119         require(address(this).balance >= payment);
120 
121         totalPayments = totalPayments.sub(payment);
122         payments[payee] = 0;
123 
124         payee.transfer(payment);
125     }
126 
127     /**
128      * @dev Called by the payer to store the sent amount as credit to be pulled.
129      * @param dest The destination address of the funds.
130      * @param amount The amount to transfer.
131      */
132     function asyncSend(address dest, uint256 amount) internal {
133         payments[dest] = payments[dest].add(amount);
134         totalPayments = totalPayments.add(amount);
135     }
136 }
137 
138 library SafeMath {
139 
140     /**
141      * @dev Multiplies two numbers, reverts on overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b);
153 
154         return c;
155     }
156 
157     /**
158      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b > 0); // Solidity only automatically asserts when dividing by 0
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
170      */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         require(b <= a);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Adds two numbers, reverts on overflow.
180      */
181     function add(uint256 a, uint256 b) internal pure returns (uint256) {
182         uint256 c = a + b;
183         require(c >= a);
184 
185         return c;
186     }
187 
188     /**
189      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
190      * reverts when dividing by zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b != 0);
194         return a % b;
195     }
196 }
197 
198 contract TaxRules {
199     using SafeMath for uint256;
200 
201     constructor() public {}
202 
203     // 10%
204     function _priceToTax(uint256 price) public pure returns (uint256) {
205         return price.div(10);
206     }
207 
208     // NOTE: The next methods *must* add up to 100%
209 
210     // 40%
211     function _jackpotTax(uint256 tax) public pure returns (uint256) {
212         return (tax.mul(2)).div(5);
213     }
214 
215     // 38%
216     function _totalLandholderTax(uint256 tax) public pure returns (uint256) {
217         return (tax.mul(19)).div(50);
218     }
219 
220     // 17%/12%
221     function _teamTax(uint256 tax, bool hasReferrer) public pure returns (uint256) {
222         if (hasReferrer) {
223             return (tax.mul(3)).div(25);
224         } else {
225             return (tax.mul(17)).div(100);
226         }
227     }
228 
229     // 5% although only invoked if _teamTax is lower value
230     function _referrerTax(uint256 tax, bool hasReferrer)  public pure returns (uint256) {
231         if (hasReferrer) {
232             return tax.div(20);
233         } else {
234             return 0;
235         }
236     }
237 
238     // 5%
239     function _nextPotTax(uint256 tax) public pure returns (uint256) {
240         return tax.div(20);
241     }
242 }
243 
244 contract Microverse is
245     HexBoard3,
246     PullPayment,
247     Ownable,
248     TaxRules,
249     JackpotRules {
250     using SafeMath for uint256;
251     using Math for uint256;
252 
253     // states this contract progresses through
254     enum Stage {
255         DutchAuction,
256         GameRounds
257     }
258     Stage public stage = Stage.DutchAuction;
259 
260     modifier atStage(Stage _stage) {
261         require(
262             stage == _stage,
263             "Function cannot be called at this time."
264         );
265         _;
266     }
267 
268     // NOTE: stage arg for debugging purposes only! Should just be set to 0 by default
269     constructor(uint startingStage) public {
270         if (startingStage == uint(Stage.GameRounds)) {
271             stage = Stage.GameRounds;
272             _startGameRound();
273         } else {
274             _startAuction();
275         }
276     }
277 
278     mapping(uint8 => address) public tileToOwner;
279     mapping(uint8 => uint256) public tileToPrice;
280     uint256 public totalTileValue;
281 
282     function _changeTilePrice(uint8 tileId, uint256 newPrice) private {
283         uint256 oldPrice = tileToPrice[tileId];
284         tileToPrice[tileId] = newPrice;
285         totalTileValue = (totalTileValue.sub(oldPrice)).add(newPrice);
286     }
287 
288     event TileOwnerChanged(
289         uint8 indexed tileId,
290         address indexed oldOwner,
291         address indexed newOwner,
292         uint256 oldPrice,
293         uint256 newPrice
294     );
295 
296     /////////////
297     // Team stuff
298     /////////////
299 
300     // The muscle behind microverse
301     address public teamAddress1 = 0xcB46219bA114245c3A18761E4f7891f9C4BeF8c0;
302     address public teamAddress2 = 0xF2AFb5c2D205B36F22BE528A1300393B1C399E79;
303     address public teamAddress3 = 0x22FC59B3878F0Aa2e43F7f3388c1e20D83Cf8ba2;
304 
305     function _sendToTeam(uint256 amount) private {
306         uint256 perTeamMemberFee = amount.div(3);
307 
308         asyncSend(teamAddress1, perTeamMemberFee);
309         asyncSend(teamAddress2, perTeamMemberFee);
310         asyncSend(teamAddress3, perTeamMemberFee);
311     }
312 
313     function withdrawContractBalance() external onlyOwner {
314         uint256 contractBalance = address(this).balance;
315         uint256 withdrawableBalance = contractBalance.sub(totalPayments);
316 
317         // No withdrawal necessary if <= 0 balance
318         require(withdrawableBalance > 0);
319 
320         asyncSend(msg.sender, withdrawableBalance);
321     }
322 
323     //////////
324     // Auction
325     //////////
326 
327     event AuctionStarted(
328         uint256 startingAuctionPrice,
329         uint256 endingAuctionPrice,
330         uint256 auctionDuration,
331         uint256 startTime
332     );
333 
334     event AuctionEnded(
335         uint256 endTime
336     );
337 
338     uint256 constant public startingAuctionPrice = 1 ether;
339     uint256 constant public endingAuctionPrice = 0.05 ether;
340     uint256 constant public auctionDuration = 5 days; // period over which land price decreases linearly
341 
342     uint256 public numBoughtTiles;
343     uint256 public auctionStartTime;
344 
345     function buyTileAuction(uint8 tileId, uint256 newPrice, address referrer) public payable atStage(Stage.DutchAuction) {
346         require(
347             tileToOwner[tileId] == address(0) && tileToPrice[tileId] == 0,
348             "Can't buy a tile that's already been auctioned off"
349         );
350 
351         uint256 tax = _priceToTax(newPrice);
352         uint256 price = getTilePriceAuction();
353 
354         require(
355             msg.value >= tax.add(price),
356             "Must pay the full price and tax for a tile on auction"
357         );
358 
359         // NOTE: *entire* payment distributed as Game taxes
360         _distributeAuctionTax(msg.value, referrer);
361 
362         tileToOwner[tileId] = msg.sender;
363         _changeTilePrice(tileId, newPrice);
364 
365         numBoughtTiles = numBoughtTiles.add(1);
366 
367         emit TileOwnerChanged(tileId, address(0), msg.sender, price, newPrice);
368 
369         if (numBoughtTiles >= numTiles) {
370             endAuction();
371         }
372     }
373 
374     // NOTE: Some common logic with _distributeTax
375     function _distributeAuctionTax(uint256 tax, address referrer) private {
376         _distributeLandholderTax(_totalLandholderTax(tax));
377 
378         // NOTE: Because no notion of 'current jackpot', everything added to next pot
379         uint256 totalJackpotTax = _jackpotTax(tax).add(_nextPotTax(tax));
380         nextJackpot = nextJackpot.add(totalJackpotTax);
381 
382         // NOTE: referrer tax comes out of dev team tax
383         bool hasReferrer = referrer != address(0);
384         _sendToTeam(_teamTax(tax, hasReferrer));
385         asyncSend(referrer, _referrerTax(tax, hasReferrer));
386     }
387 
388     function getTilePriceAuction() public view atStage(Stage.DutchAuction) returns (uint256) {
389         uint256 secondsPassed = 0;
390 
391         // This should always be the case...
392         if (now > auctionStartTime) {
393             secondsPassed = now.sub(auctionStartTime);
394         }
395 
396         if (secondsPassed >= auctionDuration) {
397             return endingAuctionPrice;
398         } else {
399             uint256 maxPriceDelta = startingAuctionPrice.sub(endingAuctionPrice);
400             uint256 actualPriceDelta = (maxPriceDelta.mul(secondsPassed)).div(auctionDuration);
401 
402             return startingAuctionPrice.sub(actualPriceDelta);
403         }
404     }
405 
406     function endAuction() private {
407         require(
408             numBoughtTiles >= numTiles,
409             "Can't end auction if are unbought tiles"
410         );
411 
412         stage = Stage.GameRounds;
413         _startGameRound();
414 
415         emit AuctionEnded(now);
416     }
417 
418     function _startAuction() private {
419         auctionStartTime = now;
420         numBoughtTiles = 0;
421 
422         emit AuctionStarted(startingAuctionPrice,
423                             endingAuctionPrice,
424                             auctionDuration,
425                             auctionStartTime);
426     }
427 
428     ///////
429     // Game
430     ///////
431 
432     uint256 constant public startingRoundExtension = 12 hours;
433     uint256 constant public halvingVolume = 10 ether; // tx volume before next duration halving
434     uint256 constant public minRoundExtension = 10 seconds; // could set to 1 second
435 
436     uint256 public roundNumber = 0;
437 
438     uint256 public curExtensionVolume;
439     uint256 public curRoundExtension;
440 
441     uint256 public roundEndTime;
442 
443     uint256 public jackpot;
444     uint256 public nextJackpot;
445 
446     // Only emitted if owner doesn't *also* change
447     event TilePriceChanged(
448         uint8 indexed tileId,
449         address indexed owner,
450         uint256 oldPrice,
451         uint256 newPrice
452     );
453 
454     event GameRoundStarted(
455         uint256 initJackpot,
456         uint256 endTime,
457         uint256 roundNumber
458     );
459 
460     event GameRoundExtended(
461         uint256 endTime
462     );
463 
464     event GameRoundEnded(
465         uint256 jackpot
466     );
467 
468     ////////////////////////////////////
469     // [Game] Round extension management
470     ////////////////////////////////////
471 
472     function roundTimeRemaining() public view atStage(Stage.GameRounds) returns (uint256)  {
473         if (_roundOver()) {
474             return 0;
475         } else {
476             return roundEndTime.sub(now);
477         }
478     }
479 
480     function _extendRound() private {
481         roundEndTime = roundEndTime.max(now.add(curRoundExtension));
482 
483         emit GameRoundExtended(roundEndTime);
484     }
485 
486     function _startGameRound() private {
487         curExtensionVolume = 0 ether;
488         curRoundExtension = startingRoundExtension;
489 
490         jackpot = nextJackpot;
491         nextJackpot = 0;
492 
493         roundNumber = roundNumber.add(1);
494 
495         _extendRound();
496 
497         emit GameRoundStarted(jackpot, roundEndTime, roundNumber);
498     }
499 
500     function _roundOver() private view returns (bool) {
501         return now >= roundEndTime;
502     }
503 
504     modifier duringRound() {
505         require(
506             !_roundOver(),
507             "Round can't be over!"
508         );
509         _;
510     }
511 
512     // NOTE: Must be called for all volume we want to count towards round extension halving
513     function _logRoundExtensionVolume(uint256 amount) private {
514         curExtensionVolume = curExtensionVolume.add(amount);
515 
516         if (curExtensionVolume >= halvingVolume) {
517             curRoundExtension = curRoundExtension.div(2).max(minRoundExtension);
518             curExtensionVolume = 0 ether;
519         }
520     }
521 
522     ////////////////////////
523     // [Game] Player actions
524     ////////////////////////
525 
526     function endGameRound() public atStage(Stage.GameRounds) {
527         require(
528             _roundOver(),
529             "Round must be over!"
530         );
531 
532         _distributeJackpot();
533 
534         emit GameRoundEnded(jackpot);
535 
536         _startGameRound();
537     }
538 
539     function setTilePrice(uint8 tileId, uint256 newPrice, address referrer)
540         public
541         payable
542         atStage(Stage.GameRounds)
543         duringRound {
544         require(
545             tileToOwner[tileId] == msg.sender,
546             "Can't set tile price for a tile you don't own!"
547         );
548 
549         uint256 tax = _priceToTax(newPrice);
550 
551         require(
552             msg.value >= tax,
553             "Must pay tax on new tile price!"
554         );
555 
556         uint256 oldPrice = tileToPrice[tileId];
557         _distributeTax(msg.value, referrer);
558         _changeTilePrice(tileId, newPrice);
559 
560         // NOTE: Currently we extend round for 'every' tile price change. Alternatively could do only on
561         // increases or decreases or changes exceeding some magnitude
562         _extendRound();
563         _logRoundExtensionVolume(msg.value);
564 
565         emit TilePriceChanged(tileId, tileToOwner[tileId], oldPrice, newPrice);
566     }
567 
568     function buyTile(uint8 tileId, uint256 newPrice, address referrer)
569         public
570         payable
571         atStage(Stage.GameRounds)
572         duringRound {
573         address oldOwner = tileToOwner[tileId];
574         require(
575             oldOwner != msg.sender,
576             "Can't buy a tile you already own"
577         );
578 
579         uint256 tax = _priceToTax(newPrice);
580 
581         uint256 oldPrice = tileToPrice[tileId];
582         require(
583             msg.value >= tax.add(oldPrice),
584             "Must pay full price and tax for tile"
585         );
586 
587         // pay seller
588         asyncSend(oldOwner, tileToPrice[tileId]);
589         tileToOwner[tileId] = msg.sender;
590 
591         uint256 actualTax = msg.value.sub(oldPrice);
592         _distributeTax(actualTax, referrer);
593 
594         _changeTilePrice(tileId, newPrice);
595         _extendRound();
596         _logRoundExtensionVolume(msg.value);
597 
598         emit TileOwnerChanged(tileId, oldOwner, msg.sender, oldPrice, newPrice);
599     }
600 
601     ///////////////////////////////////////
602     // [Game] Dividend/jackpot distribution
603     ///////////////////////////////////////
604 
605     function _distributeJackpot() private {
606         uint256 winnerJackpot = _winnerJackpot(jackpot);
607         uint256 landholderJackpot = _landholderJackpot(jackpot);
608         _distributeWinnerAndLandholderJackpot(winnerJackpot, landholderJackpot);
609 
610         _sendToTeam(_teamJackpot(jackpot));
611         nextJackpot = nextJackpot.add(_nextPotJackpot(jackpot));
612     }
613 
614     function _calculatePriceComplement(uint8 tileId) private view returns (uint256) {
615         return totalTileValue.sub(tileToPrice[tileId]);
616     }
617 
618     // NOTE: These are bundled together so that we only have to compute complements once
619     function _distributeWinnerAndLandholderJackpot(uint256 winnerJackpot, uint256 landholderJackpot) private {
620         uint256[] memory complements = new uint256[](numTiles + 1); // inc necessary b/c tiles are 1-indexed
621         uint256 totalPriceComplement = 0;
622 
623         uint256 bestComplement = 0;
624         uint8 lastWinningTileId = 0;
625         for (uint8 i = minTileId; i <= maxTileId; i++) {
626             uint256 priceComplement = _calculatePriceComplement(i);
627 
628             // update winner
629             if (bestComplement == 0 || priceComplement > bestComplement) {
630                 bestComplement = priceComplement;
631                 lastWinningTileId = i;
632             }
633 
634             complements[i] = priceComplement;
635             totalPriceComplement = totalPriceComplement.add(priceComplement);
636         }
637         uint256 numWinners = 0;
638         for (i = minTileId; i <= maxTileId; i++) {
639             if (_calculatePriceComplement(i) == bestComplement) {
640                 numWinners++;
641             }
642         }
643 
644         // distribute jackpot among all winners. save time on the majority (1-winner) case
645         if (numWinners == 1) {
646             asyncSend(tileToOwner[lastWinningTileId], winnerJackpot);
647         } else {
648             for (i = minTileId; i <= maxTileId; i++) {
649                 if (_calculatePriceComplement(i) == bestComplement) {
650                     asyncSend(tileToOwner[i], winnerJackpot.div(numWinners));
651                 }
652             }
653         }
654 
655         // distribute landholder things
656         for (i = minTileId; i <= maxTileId; i++) {
657             // NOTE: We don't exclude the jackpot winner(s) here, so the winner(s) is paid 'twice'
658             uint256 landholderAllocation = complements[i].mul(landholderJackpot).div(totalPriceComplement);
659 
660             asyncSend(tileToOwner[i], landholderAllocation);
661         }
662     }
663 
664     function _distributeTax(uint256 tax, address referrer) private {
665         jackpot = jackpot.add(_jackpotTax(tax));
666 
667         _distributeLandholderTax(_totalLandholderTax(tax));
668         nextJackpot = nextJackpot.add(_nextPotTax(tax));
669 
670         // NOTE: referrer tax comes out of dev team tax
671         bool hasReferrer = referrer != address(0);
672         _sendToTeam(_teamTax(tax, hasReferrer));
673         asyncSend(referrer, _referrerTax(tax, hasReferrer));
674     }
675 
676     function _distributeLandholderTax(uint256 tax) private {
677         for (uint8 tile = minTileId; tile <= maxTileId; tile++) {
678             if (tileToOwner[tile] != address(0) && tileToPrice[tile] != 0) {
679                 uint256 tilePrice = tileToPrice[tile];
680                 uint256 allocation = tax.mul(tilePrice).div(totalTileValue);
681 
682                 asyncSend(tileToOwner[tile], allocation);
683             }
684         }
685     }
686 }