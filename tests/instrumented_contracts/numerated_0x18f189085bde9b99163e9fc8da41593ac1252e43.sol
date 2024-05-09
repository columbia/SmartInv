1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMathLibrary {
8 
9     function max(uint256 a, uint256 b) internal pure returns (uint256) {
10         return a >= b ? a : b;
11     }
12 
13     function min(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a < b ? a : b;
15     }
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * @dev Integer module of two numbers, truncating the quotient.
41     */
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a % b;
44     }
45 
46     /**
47     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58         c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70     address public owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76      * account.
77      */
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     /**
91      * @dev Allows the current owner to transfer control of the contract to a newOwner.
92      * @param _newOwner The address to transfer ownership to.
93      */
94     function transferOwnership(address _newOwner) onlyOwner public {
95         require(_newOwner != address(0));
96         emit OwnershipTransferred(owner, _newOwner);
97         owner = _newOwner;
98     }
99 }
100 
101 /**
102  * @title Pausable
103  * @dev Base contract which allows children to implement an emergency stop mechanism.
104  */
105 contract Pausable is Ownable {
106     bool public paused = false;
107 
108     event Pause();
109 
110     event Unpause();
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is not paused.
114      */
115     modifier whenNotPaused() {
116         require(!paused);
117         _;
118     }
119 
120     /**
121      * @dev Modifier to make a function callable only when the contract is paused.
122      */
123     modifier whenPaused() {
124         require(paused);
125         _;
126     }
127 
128     /**
129      * @dev called by the owner to pause, triggers stopped state
130      */
131     function pause() onlyOwner whenNotPaused public {
132         paused = true;
133         emit Pause();
134     }
135 
136     /**
137      * @dev called by the owner to unpause, returns to normal state
138      */
139     function unpause() onlyOwner whenPaused public {
140         paused = false;
141         emit Unpause();
142     }
143 }
144 
145 contract Operator is Ownable {
146     mapping(address => bool) public operators;
147 
148     event OperatorAddressAdded(address addr);
149     event OperatorAddressRemoved(address addr);
150 
151     /**
152      * @dev Throws if called by any account that's not operator.
153      */
154     modifier onlyOperator() {
155         require(operators[msg.sender]);
156         _;
157     }
158 
159     /**
160      * @dev add an address to the operators
161      * @param addr address
162      * @return true if the address was added to the operators, false if the address was already in the operators
163      */
164     function addAddressToOperators(address addr) onlyOwner public returns(bool success) {
165         if (!operators[addr]) {
166             operators[addr] = true;
167             emit OperatorAddressAdded(addr);
168             success = true;
169         }
170     }
171 
172     /**
173      * @dev add addresses to the operators
174      * @param addrs addresses
175      * @return true if at least one address was added to the operators,
176      * false if all addresses were already in the operators
177      */
178     function addAddressesToOperators(address[] addrs) onlyOwner public returns(bool success) {
179         for (uint256 i = 0; i < addrs.length; i++) {
180             if (addAddressToOperators(addrs[i])) {
181                 success = true;
182             }
183         }
184     }
185 
186     /**
187      * @dev remove an address from the operators
188      * @param addr address
189      * @return true if the address was removed from the operators,
190      * false if the address wasn't in the operators in the first place
191      */
192     function removeAddressFromOperators(address addr) onlyOwner public returns(bool success) {
193         if (operators[addr]) {
194             operators[addr] = false;
195             emit OperatorAddressRemoved(addr);
196             success = true;
197         }
198     }
199 
200     /**
201      * @dev remove addresses from the operators
202      * @param addrs addresses
203      * @return true if at least one address was removed from the operators,
204      * false if all addresses weren't in the operators in the first place
205      */
206     function removeAddressesFromOperators(address[] addrs) onlyOwner public returns(bool success) {
207         for (uint256 i = 0; i < addrs.length; i++) {
208             if (removeAddressFromOperators(addrs[i])) {
209                 success = true;
210             }
211         }
212     }
213 }
214 
215 contract Whitelist is Operator {
216     mapping(address => bool) public whitelist;
217 
218     event WhitelistedAddressAdded(address addr);
219     event WhitelistedAddressRemoved(address addr);
220 
221     /**
222      * @dev Throws if called by any account that's not whitelisted.
223      */
224     modifier onlyWhitelisted() {
225         require(whitelist[msg.sender]);
226         _;
227     }
228 
229     /**
230      * @dev add an address to the whitelist
231      * @param addr address
232      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
233      */
234     function addAddressToWhitelist(address addr) onlyOperator public returns(bool success) {
235         if (!whitelist[addr]) {
236             whitelist[addr] = true;
237             emit WhitelistedAddressAdded(addr);
238             success = true;
239         }
240     }
241 
242     /**
243      * @dev add addresses to the whitelist
244      * @param addrs addresses
245      * @return true if at least one address was added to the whitelist,
246      * false if all addresses were already in the whitelist
247      */
248     function addAddressesToWhitelist(address[] addrs) onlyOperator public returns(bool success) {
249         for (uint256 i = 0; i < addrs.length; i++) {
250             if (addAddressToWhitelist(addrs[i])) {
251                 success = true;
252             }
253         }
254     }
255 
256     /**
257      * @dev remove an address from the whitelist
258      * @param addr address
259      * @return true if the address was removed from the whitelist,
260      * false if the address wasn't in the whitelist in the first place
261      */
262     function removeAddressFromWhitelist(address addr) onlyOperator public returns(bool success) {
263         if (whitelist[addr]) {
264             whitelist[addr] = false;
265             emit WhitelistedAddressRemoved(addr);
266             success = true;
267         }
268     }
269 
270     /**
271      * @dev remove addresses from the whitelist
272      * @param addrs addresses
273      * @return true if at least one address was removed from the whitelist,
274      * false if all addresses weren't in the whitelist in the first place
275      */
276     function removeAddressesFromWhitelist(address[] addrs) onlyOperator public returns(bool success) {
277         for (uint256 i = 0; i < addrs.length; i++) {
278             if (removeAddressFromWhitelist(addrs[i])) {
279                 success = true;
280             }
281         }
282     }
283 
284 }
285 
286 interface Token {
287     function transferFrom(address from, address to, uint amount) external returns(bool);
288 }
289 
290 contract Crowdsale is Pausable, Whitelist {
291     using SafeMathLibrary for uint;
292 
293     address private EMPTY_ADDRESS = address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
294 
295     Token public token;
296 
297     address public beneficiary;
298     address public pool;
299     
300     uint internal decimals = 10 ** 18;
301 
302     struct Funding {
303         address[] buyers;
304         address[] winners;
305         uint32 exchangeRatio;
306         uint8 minAccepting;
307         uint8 maxAccepting;
308         uint8 maxLotteryNumber;
309     }
310 
311     struct BuyerStage {
312         uint8 funded;
313         bool lotteryBonusWon;
314         bool ultimateBonusWon;
315         bool bonusReleased;
316     }
317 
318     struct Bonus {
319         uint32 buying;
320         uint32 lottery;
321         uint32 ultimate;
322     }
323 
324     struct Stage {
325         Bonus bonus;
326         address[] buyers;
327         address[] winners;
328         address ultimateBonusWinner;
329         uint32 openingTime;
330         uint16 fundGoal;
331         uint16 fundRaised;
332         uint16 nextLotteryRaised;
333     }
334 
335     Funding private funding;
336 
337     mapping(address => mapping(uint8 => BuyerStage)) private buyers;
338 
339     mapping(uint8 => Stage) private stages;
340 
341     event BuyerFunded(address indexed buyer, uint8 stageIndex, uint8 amount);
342     event BuyerLotteryBonusWon(address indexed buyer, uint8 stageIndex, uint8 lotteryNumber, uint16 fundRaised);
343     event BuyerUltimateBonusWon(address indexed buyer, uint8 stageIndex);
344     event StageOpeningTimeSet(uint8 index);
345     event StageGoalReached(uint8 index);
346     event FinalGoalReached();
347 
348     constructor (
349         address _tokenContractAddress,
350         address _beneficiary,
351         address _pool
352     ) public {
353         token = Token(_tokenContractAddress);
354         beneficiary = _beneficiary;
355         pool = _pool;
356 
357         funding.exchangeRatio = 75000;
358         funding.minAccepting = 1;
359         funding.maxAccepting = 10;
360         funding.maxLotteryNumber = 9;
361 
362         stages[1].openingTime = 1535500800;
363         stages[1].fundGoal = 3000;
364         stages[1].bonus.buying = 3600000; // 80%
365         stages[1].bonus.lottery = 450000; // 10%
366         stages[1].bonus.ultimate = 450000; // 10%
367 
368         stages[2].fundGoal = 3000;
369         stages[2].bonus.buying = 2250000; // 50%
370         stages[2].bonus.lottery = 1125000; // 25%
371         stages[2].bonus.ultimate = 1125000; // 25%
372 
373         stages[3].fundGoal = 3000;
374         stages[3].bonus.buying = 1350000; // 30%
375         stages[3].bonus.lottery = 1575000; // 35%
376         stages[3].bonus.ultimate = 1575000; // 35%
377 
378         stages[4].fundGoal = 3000;
379         stages[4].bonus.buying = 0; // 0%
380         stages[4].bonus.lottery = 2250000; // 50%
381         stages[4].bonus.ultimate = 2250000; // 50%
382 
383         for (uint8 i = 1; i <= 4; i++) {
384             stages[i].ultimateBonusWinner = EMPTY_ADDRESS;
385         }
386     }
387     
388     function getStageAverageBonus(uint8 _index) public view returns(
389         uint32 buying,
390         uint32 lottery,
391         uint32 ultimate
392     ) {
393         Stage storage stage = stages[_index];
394         buying = stage.bonus.buying > 0 ? stage.bonus.buying / stage.fundGoal : 0;
395         if (stageFundGoalReached(_index) == true) {
396             lottery = stage.bonus.lottery / uint16(stage.winners.length);
397             ultimate = stage.bonus.ultimate + (stage.bonus.lottery - lottery * uint16(stage.winners.length));
398         }
399     } 
400 
401     function getOpenedStageIndex() public view returns(uint8) {
402         for (uint8 i = 1; i <= 4; i++) {
403             if (stages[i].openingTime > 0 && now >= stages[i].openingTime && stages[i].fundRaised < stages[i].fundGoal) {
404                 return i;
405             }
406         }
407         return 0;
408     }
409 
410     function getRandomNumber(uint256 power) private view returns (uint256) {
411         uint256 ddb = uint256(blockhash(block.number - 1));
412         uint256 r = uint256(keccak256(abi.encodePacked(ddb - 1)));
413         while (r == 0) {
414             ddb += 256;
415             r = uint256(keccak256(abi.encodePacked(ddb - 1)));
416         }
417         return uint256(keccak256(abi.encodePacked(r, block.difficulty, now))) % power;
418     }
419 
420     function getTodayLotteryNumber() public view returns(uint8) {
421         return uint8(uint256(keccak256(abi.encodePacked(uint16(now / 1 days)))) % funding.maxLotteryNumber);
422     }
423 
424     function getSummary() public view returns(
425         uint32 exchangeRatio,
426         uint16 fundGoal,
427         uint32 bonus,
428         uint16 fundRaised,
429         uint16 buyersCount,
430         uint16 winnersCount,
431         uint8 minAccepting,
432         uint8 maxAccepting,
433         uint8 openedStageIndex,
434         uint8 todayLotteryNumber
435     ) {
436         for (uint8 i = 1; i <= 4; i++) {
437             fundGoal += stages[i].fundGoal;
438             fundRaised += stages[i].fundRaised;
439             bonus += stages[i].bonus.buying + stages[i].bonus.lottery + stages[i].bonus.ultimate;
440         }
441 
442         exchangeRatio = funding.exchangeRatio;
443         minAccepting = funding.minAccepting;
444         maxAccepting = funding.maxAccepting;
445         buyersCount = uint16(funding.buyers.length);
446         winnersCount = uint16(funding.winners.length);
447         openedStageIndex = getOpenedStageIndex();
448         todayLotteryNumber = getTodayLotteryNumber();
449     }
450 
451     function setStageOpeningTime(uint8 _index, uint32 _openingTime) public onlyOwner whenNotPaused returns(bool) {
452         if (stages[_index].openingTime > 0) {
453             require(stages[_index].openingTime > now, "Stage has been already opened.");
454         }
455         stages[_index].openingTime = _openingTime;
456         emit StageOpeningTimeSet(_index);
457         return true;
458     }
459 
460     function getStages() public view returns(
461         uint8[4] index,
462         uint32[4] openingTime,
463         uint32[4] buyingBonus,
464         uint32[4] lotteryBonus,
465         uint32[4] ultimateBonus,
466         uint16[4] fundGoal,
467         uint16[4] fundRaised,
468         uint16[4] buyersCount,
469         uint16[4] winnersCount,
470         address[4] ultimateBonusWinner
471     ) {
472         for (uint8 i = 1; i <= 4; i++) {
473             uint8 _i = i - 1;
474             index[_i] = i;
475             openingTime[_i] = stages[i].openingTime;
476             buyingBonus[_i] = stages[i].bonus.buying;
477             lotteryBonus[_i] = stages[i].bonus.lottery;
478             ultimateBonus[_i] = stages[i].bonus.ultimate;
479             fundGoal[_i] = stages[i].fundGoal;
480             fundRaised[_i] = stages[i].fundRaised;
481             buyersCount[_i] = uint16(stages[i].buyers.length);
482             winnersCount[_i] = uint16(stages[i].winners.length);
483             ultimateBonusWinner[_i] = stages[i].ultimateBonusWinner == EMPTY_ADDRESS ? address(0) : stages[i].ultimateBonusWinner;
484         }
485     }
486 
487     function getBuyers(uint16 _offset, uint8 _limit) public view returns(
488         uint16 total,
489         uint16 start,
490         uint16 end,
491         uint8 count,
492         address[] items
493     ) {
494         total = uint16(funding.buyers.length);
495         if (total > 0) {
496             start = _offset > total - 1 ? total - 1 : _offset;
497             end = (start + _limit > total) ? total - 1 : (start + _limit > 0 ? start + _limit - 1 : 0);
498             count = uint8(end - start + 1);
499         }
500 
501         if (count > 0) {
502             address[] memory _items = new address[](count);
503             uint8 j = 0;
504             for (uint16 i = start; i <= end; i++) {
505                 _items[j] = funding.buyers[i];
506                 j++;
507             }
508             items = _items;
509         }
510     }
511 
512     function getWinners(uint16 _offset, uint8 _limit) public view returns(
513         uint16 total,
514         uint16 start,
515         uint16 end,
516         uint8 count,
517         address[] items
518     ) {
519         total = uint16(funding.winners.length);
520         if (total > 0) {
521             start = _offset > total - 1 ? total - 1 : _offset;
522             end = (start + _limit > total) ? total - 1 : (start + _limit > 0 ? start + _limit - 1 : 0);
523             count = uint8(end - start + 1);
524         }
525 
526         if (count > 0) {
527             address[] memory _items = new address[](count);
528             uint8 j = 0;
529             for (uint16 i = start; i <= end; i++) {
530                 _items[j] = funding.winners[i];
531                 j++;
532             }
533             items = _items;
534         }
535     }
536 
537     function getStageBuyers(uint8 _index, uint16 _offset, uint8 _limit) public view returns(
538         uint16 total,
539         uint16 start,
540         uint16 end,
541         uint8 count,
542         address[] items
543     ) {
544         Stage storage stage = stages[_index];
545 
546         total = uint16(stage.buyers.length);
547         if (total > 0) {
548             start = _offset > total - 1 ? total - 1 : _offset;
549             end = (start + _limit > total) ? total - 1 : (start + _limit > 0 ? start + _limit - 1 : 0);
550             count = uint8(end - start + 1);
551         }
552 
553         if (count > 0) {
554             address[] memory _items = new address[](count);
555             uint8 j = 0;
556             for (uint16 i = start; i <= end; i++) {
557                 _items[j] = stage.buyers[i];
558                 j++;
559             }
560             items = _items;
561         }
562     }
563 
564     function getStageWinners(uint8 _index, uint16 _offset, uint8 _limit) public view returns(
565         uint16 total,
566         uint16 start,
567         uint16 end,
568         uint8 count,
569         address[] items
570     ) {
571         Stage storage stage = stages[_index];
572 
573         total = uint16(stage.winners.length);
574         if (total > 0) {
575             start = _offset > total - 1 ? total - 1 : _offset;
576             end = (start + _limit > total) ? total - 1 : (start + _limit > 0 ? start + _limit - 1 : 0);
577             count = uint8(end - start + 1);
578         }
579 
580         if (count > 0) {
581             address[] memory _items = new address[](count);
582             uint8 j = 0;
583             for (uint16 i = start; i <= end; i++) {
584                 _items[j] = stage.winners[i];
585                 j++;
586             }
587             items = _items;
588         }
589     }
590 
591     function getBuyer(address _buyer) public view returns(
592         uint8[4] funded,
593         uint32[4] buyingBonus,
594         uint32[4] lotteryBonus,
595         uint32[4] ultimateBonus,
596         bool[4] lotteryBonusWon,
597         bool[4] ultimateBonusWon,
598         bool[4] bonusReleasable,
599         bool[4] bonusReleased
600     ) {
601         for (uint8 i = 1; i <= 4; i++) {
602             BuyerStage storage buyerStage = buyers[_buyer][i];
603             funded[i - 1] = buyerStage.funded;
604             lotteryBonusWon[i - 1] = buyerStage.lotteryBonusWon;
605             ultimateBonusWon[i - 1] = buyerStage.ultimateBonusWon;
606             bonusReleasable[i - 1] = stageFundGoalReached(i);
607             bonusReleased[i - 1] = buyerStage.bonusReleased;
608 
609             uint32 _buyingBonus;
610             uint32 _lotteryBonus;
611             uint32 _ultimateBonus;
612 
613             (_buyingBonus, _lotteryBonus, _ultimateBonus) = getStageAverageBonus(i);
614             
615             buyingBonus[i - 1] = buyerStage.funded * _buyingBonus;
616 
617             if (buyerStage.lotteryBonusWon == true) {
618                 lotteryBonus[i - 1] = _lotteryBonus;
619             }
620             
621             if (buyerStage.ultimateBonusWon == true) {
622                 ultimateBonus[i - 1] = _ultimateBonus;
623             }
624         }
625     }
626 
627     function finalFundGoalReached() public view returns(bool) {
628         for (uint8 i = 1; i <= 4; i++) {
629             if (stageFundGoalReached(i) == false) {
630                 return false;
631             }
632         }
633         return true;
634     }
635 
636     function stageFundGoalReached(uint8 _index) public view returns(bool) {
637         Stage storage stage = stages[_index];
638         return (stage.openingTime > 0 && stage.openingTime <= now && stage.fundRaised >= stage.fundGoal);
639     }
640 
641     function tokenFallback(address _from, uint256 _value) public returns(bool) {
642         require(msg.sender == address(token));
643         return true;
644     }
645 
646     function releasableViewOrSend(address _buyer, bool _send) private returns(uint32) {
647         uint32 bonus;
648         for (uint8 i = 1; i <= 4; i++) {
649             BuyerStage storage buyerStage = buyers[_buyer][i];
650 
651             if (stageFundGoalReached(i) == false || buyerStage.bonusReleased == true) {
652                 continue;
653             }
654             
655             uint32 buyingBonus;
656             uint32 lotteryBonus;
657             uint32 ultimateBonus;
658 
659             (buyingBonus, lotteryBonus, ultimateBonus) = getStageAverageBonus(i);
660 
661             bonus += buyerStage.funded * buyingBonus;
662             if (buyerStage.lotteryBonusWon == true) {
663                 bonus += lotteryBonus;
664             }
665             if (buyerStage.ultimateBonusWon == true) {
666                 bonus += ultimateBonus;
667             }
668             
669             if (_send == true) {
670                 buyerStage.bonusReleased = true;
671             }
672         }
673         
674         if (_send == true) {
675             require(bonus > 0, "No bonus.");
676             token.transferFrom(pool, _buyer, uint256(bonus).mul(decimals));
677         }
678         
679         return bonus;
680     }
681 
682     function releasable(address _buyer) public view returns(uint32) {
683         return releasableViewOrSend(_buyer, false);
684     }
685 
686     function release(address _buyer) private {
687         releasableViewOrSend(_buyer, true);
688     }
689 
690     function getBuyerFunded(address _buyer) private view returns(uint8) {
691         uint8 funded;
692         for (uint8 i = 1; i <= 4; i++) {
693             funded += buyers[_buyer][i].funded;
694         }
695         return funded;
696     }
697 
698     function hasBuyerLotteryBonusWon(address _buyer) private view returns(bool) {
699         for (uint8 i = 1; i <= 4; i++) {
700             if (buyers[_buyer][i].lotteryBonusWon) {
701                 return true;
702             }
703         }
704         return false;
705     }
706 
707     function buy(address _buyer, uint256 value) private {
708         uint8 i = getOpenedStageIndex();
709         require(i > 0, "No opening stage found.");
710         require(value >= 1 ether, "The amount too low.");
711 
712         Stage storage stage = stages[i];
713 
714         uint16 remain;
715         uint16 funded = getBuyerFunded(_buyer);
716         uint256 amount = value.div(1 ether);
717         uint256 refund = value.sub(amount.mul(1 ether));
718 
719         remain = funding.maxAccepting - funded;
720         require(remain > 0, "Total amount too high.");
721         if (remain < amount) {
722             refund = refund.add(amount.sub(uint256(remain)).mul(1 ether));
723             amount = remain;
724         }
725 
726         remain = stage.fundGoal - stage.fundRaised;
727         require(remain > 0, "Stage funding goal reached.");
728         if (remain < amount) {
729             refund = refund.add(amount.sub(uint256(remain)).mul(1 ether));
730             amount = remain;
731         }
732 
733         if (refund > 0) {
734             require(_buyer.send(refund), "Refund failed.");
735         }
736 
737         BuyerStage storage buyerStage = buyers[_buyer][i];
738 
739         if (funded == 0) {
740             funding.buyers.push(_buyer);
741         }
742         if (buyerStage.funded == 0) {
743             stage.buyers.push(_buyer);
744         }
745         buyerStage.funded += uint8(amount);
746 
747         stage.fundRaised += uint16(amount);
748 
749         emit BuyerFunded(_buyer, i, uint8(amount));
750 
751         uint8 todayLotteryNumber = getTodayLotteryNumber();
752 
753         if (stage.nextLotteryRaised == 0) {
754             stage.nextLotteryRaised = todayLotteryNumber;
755         }
756         
757         uint8 mod;
758         if (stage.fundRaised > 10) {
759             mod = uint8(stage.fundRaised % 10);
760             if (mod == 0) {
761                 mod = 10;
762             }
763         } else {
764             mod = uint8(stage.fundRaised);
765         }
766         if (mod >= todayLotteryNumber && stage.fundRaised >= stage.nextLotteryRaised) {
767             if (hasBuyerLotteryBonusWon(_buyer) == false) {
768                 funding.winners.push(_buyer);
769             }
770             if (buyerStage.lotteryBonusWon == false) {
771                 buyerStage.lotteryBonusWon = true;
772                 stage.winners.push(_buyer);
773                 emit BuyerLotteryBonusWon(_buyer, i, todayLotteryNumber, stage.fundRaised);
774             }
775             stage.nextLotteryRaised += 10;
776         }
777 
778         if (stage.fundGoal == stage.fundRaised) {
779             stage.ultimateBonusWinner = stage.winners[uint16(getRandomNumber(stage.winners.length - 1))];
780             buyers[stage.ultimateBonusWinner][i].ultimateBonusWon = true;
781 
782             emit StageGoalReached(i);
783             emit BuyerUltimateBonusWon(_buyer, i);
784         }
785 
786         if (finalFundGoalReached() == true) {
787             emit FinalGoalReached();
788         }
789 
790         uint256 tokens = amount * funding.exchangeRatio;
791         require(beneficiary.send(amount.mul(1 ether)), "Send failed.");
792         require(token.transferFrom(pool, _buyer, tokens.mul(decimals)), "Deliver failed.");
793     }
794 
795     function () whenNotPaused onlyWhitelisted public payable {
796         require(beneficiary != msg.sender, "The beneficiary cannot buy CATT.");
797         if (msg.value == 0) {
798             release(msg.sender);
799         } else {
800             buy(msg.sender, msg.value);
801         }
802     }
803 }