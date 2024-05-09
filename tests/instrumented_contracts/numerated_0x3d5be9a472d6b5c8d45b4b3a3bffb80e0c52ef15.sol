1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
101     uint256 c = a * b;
102     assert(a == 0 || c / a == b);
103     return c;
104   }
105 
106   function div(uint256 a, uint256 b) internal constant returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 // File: zeppelin/contracts/ownership/HasNoEther.sol
126 
127 /**
128  * @title Contracts that should not own Ether
129  * @author Remco Bloemen <remco@2π.com>
130  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
131  * in the contract, it will allow the owner to reclaim this ether.
132  * @notice Ether can still be send to this contract by:
133  * calling functions labeled `payable`
134  * `selfdestruct(contract_address)`
135  * mining directly to the contract address
136 */
137 contract HasNoEther is Ownable {
138 
139   /**
140   * @dev Constructor that rejects incoming Ether
141   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
142   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
143   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
144   * we could use assembly to access msg.value.
145   */
146   function HasNoEther() payable {
147     require(msg.value == 0);
148   }
149 
150   /**
151    * @dev Disallows direct send by settings a default function without the `payable` flag.
152    */
153   function() external {
154   }
155 
156   /**
157    * @dev Transfer all Ether held by the contract to the owner.
158    */
159   function reclaimEther() external onlyOwner {
160     assert(owner.send(this.balance));
161   }
162 }
163 
164 // File: contracts/presale/AxiePresale.sol
165 
166 contract AxiePresale is HasNoEther, Pausable {
167   using SafeMath for uint256;
168 
169   // No Axies can be adopted after this end date: Friday, March 16, 2018 11:59:59 PM GMT.
170   uint256 constant public PRESALE_END_TIMESTAMP = 1521244799;
171 
172   uint8 constant public CLASS_BEAST = 0;
173   uint8 constant public CLASS_AQUATIC = 2;
174   uint8 constant public CLASS_PLANT = 4;
175 
176   uint256 constant public INITIAL_PRICE_INCREMENT = 1600 szabo; // 0.0016 Ether
177   uint256 constant public INITIAL_PRICE = INITIAL_PRICE_INCREMENT;
178   uint256 constant public REF_CREDITS_PER_AXIE = 5;
179 
180   mapping (uint8 => uint256) public currentPrices;
181   mapping (uint8 => uint256) public priceIncrements;
182 
183   mapping (uint8 => uint256) public totalAxiesAdopted;
184   mapping (address => mapping (uint8 => uint256)) public axiesAdopted;
185 
186   mapping (address => uint256) public referralCredits;
187   mapping (address => uint256) public axiesRewarded;
188   uint256 public totalAxiesRewarded;
189 
190   event AxiesAdopted(
191     address indexed adopter,
192     uint8 indexed clazz,
193     uint256 quantity,
194     address indexed referrer
195   );
196 
197   event AxiesRewarded(address indexed receiver, uint256 quantity);
198 
199   event AdoptedAxiesRedeemed(address indexed receiver, uint8 indexed clazz, uint256 quantity);
200   event RewardedAxiesRedeemed(address indexed receiver, uint256 quantity);
201 
202   function AxiePresale() public {
203     priceIncrements[CLASS_BEAST] = priceIncrements[CLASS_AQUATIC] = //
204       priceIncrements[CLASS_PLANT] = INITIAL_PRICE_INCREMENT;
205 
206     currentPrices[CLASS_BEAST] = currentPrices[CLASS_AQUATIC] = //
207       currentPrices[CLASS_PLANT] = INITIAL_PRICE;
208   }
209 
210   function axiesPrice(
211     uint256 beastQuantity,
212     uint256 aquaticQuantity,
213     uint256 plantQuantity
214   )
215     public
216     view
217     returns (uint256 totalPrice)
218   {
219     uint256 price;
220 
221     (price,,) = _axiesPrice(CLASS_BEAST, beastQuantity);
222     totalPrice = totalPrice.add(price);
223 
224     (price,,) = _axiesPrice(CLASS_AQUATIC, aquaticQuantity);
225     totalPrice = totalPrice.add(price);
226 
227     (price,,) = _axiesPrice(CLASS_PLANT, plantQuantity);
228     totalPrice = totalPrice.add(price);
229   }
230 
231   function adoptAxies(
232     uint256 beastQuantity,
233     uint256 aquaticQuantity,
234     uint256 plantQuantity,
235     address referrer
236   )
237     public
238     payable
239     whenNotPaused
240   {
241     require(now <= PRESALE_END_TIMESTAMP);
242 
243     require(beastQuantity <= 3);
244     require(aquaticQuantity <= 3);
245     require(plantQuantity <= 3);
246 
247     address adopter = msg.sender;
248     address actualReferrer = 0x0;
249 
250     // An adopter cannot be his/her own referrer.
251     if (referrer != adopter) {
252       actualReferrer = referrer;
253     }
254 
255     uint256 value = msg.value;
256     uint256 price;
257 
258     if (beastQuantity > 0) {
259       price = _adoptAxies(
260         adopter,
261         CLASS_BEAST,
262         beastQuantity,
263         actualReferrer
264       );
265 
266       require(value >= price);
267       value -= price;
268     }
269 
270     if (aquaticQuantity > 0) {
271       price = _adoptAxies(
272         adopter,
273         CLASS_AQUATIC,
274         aquaticQuantity,
275         actualReferrer
276       );
277 
278       require(value >= price);
279       value -= price;
280     }
281 
282     if (plantQuantity > 0) {
283       price = _adoptAxies(
284         adopter,
285         CLASS_PLANT,
286         plantQuantity,
287         actualReferrer
288       );
289 
290       require(value >= price);
291       value -= price;
292     }
293 
294     msg.sender.transfer(value);
295 
296     // The current referral is ignored if the referrer's address is 0x0.
297     if (actualReferrer != 0x0) {
298       uint256 numCredit = referralCredits[actualReferrer]
299         .add(beastQuantity)
300         .add(aquaticQuantity)
301         .add(plantQuantity);
302 
303       uint256 numReward = numCredit / REF_CREDITS_PER_AXIE;
304 
305       if (numReward > 0) {
306         referralCredits[actualReferrer] = numCredit % REF_CREDITS_PER_AXIE;
307         axiesRewarded[actualReferrer] = axiesRewarded[actualReferrer].add(numReward);
308         totalAxiesRewarded = totalAxiesRewarded.add(numReward);
309         AxiesRewarded(actualReferrer, numReward);
310       } else {
311         referralCredits[actualReferrer] = numCredit;
312       }
313     }
314   }
315 
316   function redeemAdoptedAxies(
317     address receiver,
318     uint256 beastQuantity,
319     uint256 aquaticQuantity,
320     uint256 plantQuantity
321   )
322     public
323     onlyOwner
324     returns (
325       uint256 /* remainingBeastQuantity */,
326       uint256 /* remainingAquaticQuantity */,
327       uint256 /* remainingPlantQuantity */
328     )
329   {
330     return (
331       _redeemAdoptedAxies(receiver, CLASS_BEAST, beastQuantity),
332       _redeemAdoptedAxies(receiver, CLASS_AQUATIC, aquaticQuantity),
333       _redeemAdoptedAxies(receiver, CLASS_PLANT, plantQuantity)
334     );
335   }
336 
337   function redeemRewardedAxies(
338     address receiver,
339     uint256 quantity
340   )
341     public
342     onlyOwner
343     returns (uint256 remainingQuantity)
344   {
345     remainingQuantity = axiesRewarded[receiver] = axiesRewarded[receiver].sub(quantity);
346 
347     if (quantity > 0) {
348       // This requires that rewarded Axies are always included in the total
349       // to make sure overflow won't happen.
350       totalAxiesRewarded -= quantity;
351 
352       RewardedAxiesRedeemed(receiver, quantity);
353     }
354   }
355 
356   /**
357    * @dev Calculate price of Axies from the same class.
358    * @param clazz The class of Axies.
359    * @param quantity Number of Axies to be calculated.
360    */
361   function _axiesPrice(
362     uint8 clazz,
363     uint256 quantity
364   )
365     private
366     view
367     returns (uint256 totalPrice, uint256 priceIncrement, uint256 currentPrice)
368   {
369     priceIncrement = priceIncrements[clazz];
370     currentPrice = currentPrices[clazz];
371 
372     uint256 nextPrice;
373 
374     for (uint256 i = 0; i < quantity; i++) {
375       totalPrice = totalPrice.add(currentPrice);
376       nextPrice = currentPrice.add(priceIncrement);
377 
378       if (nextPrice / 100 finney != currentPrice / 100 finney) {
379         priceIncrement >>= 1;
380       }
381 
382       currentPrice = nextPrice;
383     }
384   }
385 
386   /**
387    * @dev Adopt some Axies from the same class.
388    * @param adopter Address of the adopter.
389    * @param clazz The class of adopted Axies.
390    * @param quantity Number of Axies to be adopted, this should be positive.
391    * @param referrer Address of the referrer.
392    */
393   function _adoptAxies(
394     address adopter,
395     uint8 clazz,
396     uint256 quantity,
397     address referrer
398   )
399     private
400     returns (uint256 totalPrice)
401   {
402     (totalPrice, priceIncrements[clazz], currentPrices[clazz]) = _axiesPrice(clazz, quantity);
403 
404     axiesAdopted[adopter][clazz] = axiesAdopted[adopter][clazz].add(quantity);
405     totalAxiesAdopted[clazz] = totalAxiesAdopted[clazz].add(quantity);
406 
407     AxiesAdopted(
408       adopter,
409       clazz,
410       quantity,
411       referrer
412     );
413   }
414 
415   /**
416    * @dev Redeem adopted Axies from the same class.
417    * @param receiver Address of the receiver.
418    * @param clazz The class of adopted Axies.
419    * @param quantity Number of adopted Axies to be redeemed.
420    */
421   function _redeemAdoptedAxies(
422     address receiver,
423     uint8 clazz,
424     uint256 quantity
425   )
426     private
427     returns (uint256 remainingQuantity)
428   {
429     remainingQuantity = axiesAdopted[receiver][clazz] = axiesAdopted[receiver][clazz].sub(quantity);
430 
431     if (quantity > 0) {
432       // This requires that adopted Axies are always included in the total
433       // to make sure overflow won't happen.
434       totalAxiesAdopted[clazz] -= quantity;
435 
436       AdoptedAxiesRedeemed(receiver, clazz, quantity);
437     }
438   }
439 }
440 
441 // File: zeppelin/contracts/ownership/HasNoContracts.sol
442 
443 /**
444  * @title Contracts that should not own Contracts
445  * @author Remco Bloemen <remco@2π.com>
446  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
447  * of this contract to reclaim ownership of the contracts.
448  */
449 contract HasNoContracts is Ownable {
450 
451   /**
452    * @dev Reclaim ownership of Ownable contracts
453    * @param contractAddr The address of the Ownable to be reclaimed.
454    */
455   function reclaimContract(address contractAddr) external onlyOwner {
456     Ownable contractInst = Ownable(contractAddr);
457     contractInst.transferOwnership(owner);
458   }
459 }
460 
461 // File: contracts/presale/AxiePresaleExtended.sol
462 
463 contract AxiePresaleExtended is HasNoContracts, Pausable {
464   using SafeMath for uint256;
465 
466   // No Axies can be adopted after this end date: Monday, April 16, 2018 11:59:59 PM GMT.
467   uint256 constant public PRESALE_END_TIMESTAMP = 1523923199;
468 
469   // The total number of adopted Axies will be capped at 5250,
470   // so the number of Axies which have Mystic parts will be capped roughly at 2000.
471   uint256 constant public MAX_TOTAL_ADOPTED_AXIES = 5250;
472 
473   uint8 constant public CLASS_BEAST = 0;
474   uint8 constant public CLASS_AQUATIC = 2;
475   uint8 constant public CLASS_PLANT = 4;
476 
477   // The initial price increment and the initial price are for reference only
478   uint256 constant public INITIAL_PRICE_INCREMENT = 1600 szabo; // 0.0016 Ether
479   uint256 constant public INITIAL_PRICE = INITIAL_PRICE_INCREMENT;
480 
481   uint256 constant public REF_CREDITS_PER_AXIE = 5;
482 
483   AxiePresale public presaleContract;
484   address public redemptionAddress;
485 
486   mapping (uint8 => uint256) public currentPrice;
487   mapping (uint8 => uint256) public priceIncrement;
488 
489   mapping (uint8 => uint256) private _totalAdoptedAxies;
490   mapping (uint8 => uint256) private _totalDeductedAdoptedAxies;
491   mapping (address => mapping (uint8 => uint256)) private _numAdoptedAxies;
492   mapping (address => mapping (uint8 => uint256)) private _numDeductedAdoptedAxies;
493 
494   mapping (address => uint256) private _numRefCredits;
495   mapping (address => uint256) private _numDeductedRefCredits;
496   uint256 public numBountyCredits;
497 
498   uint256 private _totalRewardedAxies;
499   uint256 private _totalDeductedRewardedAxies;
500   mapping (address => uint256) private _numRewardedAxies;
501   mapping (address => uint256) private _numDeductedRewardedAxies;
502 
503   event AxiesAdopted(
504     address indexed _adopter,
505     uint8 indexed _class,
506     uint256 _quantity,
507     address indexed _referrer
508   );
509 
510   event AxiesRewarded(address indexed _receiver, uint256 _quantity);
511 
512   event AdoptedAxiesRedeemed(address indexed _receiver, uint8 indexed _class, uint256 _quantity);
513   event RewardedAxiesRedeemed(address indexed _receiver, uint256 _quantity);
514 
515   event RefCreditsMinted(address indexed _receiver, uint256 _numMintedCredits);
516 
517   function AxiePresaleExtended() public payable {
518     require(msg.value == 0);
519     paused = true;
520     numBountyCredits = 300;
521   }
522 
523   function () external payable {
524     require(msg.sender == address(presaleContract));
525   }
526 
527   modifier whenNotInitialized {
528     require(presaleContract == address(0));
529     _;
530   }
531 
532   modifier whenInitialized {
533     require(presaleContract != address(0));
534     _;
535   }
536 
537   modifier onlyRedemptionAddress {
538     require(msg.sender == redemptionAddress);
539     _;
540   }
541 
542   function reclaimEther() external onlyOwner whenInitialized {
543     presaleContract.reclaimEther();
544     owner.transfer(this.balance);
545   }
546 
547   /**
548    * @dev This must be called only once after the owner of the presale contract
549    *  has been updated to this contract.
550    */
551   function initialize(address _presaleAddress) external onlyOwner whenNotInitialized {
552     // Set the presale address.
553     presaleContract = AxiePresale(_presaleAddress);
554 
555     presaleContract.pause();
556 
557     // Restore price increments from the old contract.
558     priceIncrement[CLASS_BEAST] = presaleContract.priceIncrements(CLASS_BEAST);
559     priceIncrement[CLASS_AQUATIC] = presaleContract.priceIncrements(CLASS_AQUATIC);
560     priceIncrement[CLASS_PLANT] = presaleContract.priceIncrements(CLASS_PLANT);
561 
562     // Restore current prices from the old contract.
563     currentPrice[CLASS_BEAST] = presaleContract.currentPrices(CLASS_BEAST);
564     currentPrice[CLASS_AQUATIC] = presaleContract.currentPrices(CLASS_AQUATIC);
565     currentPrice[CLASS_PLANT] = presaleContract.currentPrices(CLASS_PLANT);
566 
567     paused = false;
568   }
569 
570   function setRedemptionAddress(address _redemptionAddress) external onlyOwner whenInitialized {
571     redemptionAddress = _redemptionAddress;
572   }
573 
574   function totalAdoptedAxies(
575     uint8 _class,
576     bool _deduction
577   )
578     external
579     view
580     whenInitialized
581     returns (uint256 _number)
582   {
583     _number = _totalAdoptedAxies[_class]
584       .add(presaleContract.totalAxiesAdopted(_class));
585 
586     if (_deduction) {
587       _number = _number.sub(_totalDeductedAdoptedAxies[_class]);
588     }
589   }
590 
591   function numAdoptedAxies(
592     address _owner,
593     uint8 _class,
594     bool _deduction
595   )
596     external
597     view
598     whenInitialized
599     returns (uint256 _number)
600   {
601     _number = _numAdoptedAxies[_owner][_class]
602       .add(presaleContract.axiesAdopted(_owner, _class));
603 
604     if (_deduction) {
605       _number = _number.sub(_numDeductedAdoptedAxies[_owner][_class]);
606     }
607   }
608 
609   function numRefCredits(
610     address _owner,
611     bool _deduction
612   )
613     external
614     view
615     whenInitialized
616     returns (uint256 _number)
617   {
618     _number = _numRefCredits[_owner]
619       .add(presaleContract.referralCredits(_owner));
620 
621     if (_deduction) {
622       _number = _number.sub(_numDeductedRefCredits[_owner]);
623     }
624   }
625 
626   function totalRewardedAxies(
627     bool _deduction
628   )
629     external
630     view
631     whenInitialized
632     returns (uint256 _number)
633   {
634     _number = _totalRewardedAxies
635       .add(presaleContract.totalAxiesRewarded());
636 
637     if (_deduction) {
638       _number = _number.sub(_totalDeductedRewardedAxies);
639     }
640   }
641 
642   function numRewardedAxies(
643     address _owner,
644     bool _deduction
645   )
646     external
647     view
648     whenInitialized
649     returns (uint256 _number)
650   {
651     _number = _numRewardedAxies[_owner]
652       .add(presaleContract.axiesRewarded(_owner));
653 
654     if (_deduction) {
655       _number = _number.sub(_numDeductedRewardedAxies[_owner]);
656     }
657   }
658 
659   function axiesPrice(
660     uint256 _beastQuantity,
661     uint256 _aquaticQuantity,
662     uint256 _plantQuantity
663   )
664     external
665     view
666     whenInitialized
667     returns (uint256 _totalPrice)
668   {
669     uint256 price;
670 
671     (price,,) = _sameClassAxiesPrice(CLASS_BEAST, _beastQuantity);
672     _totalPrice = _totalPrice.add(price);
673 
674     (price,,) = _sameClassAxiesPrice(CLASS_AQUATIC, _aquaticQuantity);
675     _totalPrice = _totalPrice.add(price);
676 
677     (price,,) = _sameClassAxiesPrice(CLASS_PLANT, _plantQuantity);
678     _totalPrice = _totalPrice.add(price);
679   }
680 
681   function adoptAxies(
682     uint256 _beastQuantity,
683     uint256 _aquaticQuantity,
684     uint256 _plantQuantity,
685     address _referrer
686   )
687     external
688     payable
689     whenInitialized
690     whenNotPaused
691   {
692     require(now <= PRESALE_END_TIMESTAMP);
693     require(_beastQuantity <= 3 && _aquaticQuantity <= 3 && _plantQuantity <= 3);
694 
695     uint256 _totalAdopted = this.totalAdoptedAxies(CLASS_BEAST, false)
696       .add(this.totalAdoptedAxies(CLASS_AQUATIC, false))
697       .add(this.totalAdoptedAxies(CLASS_PLANT, false))
698       .add(_beastQuantity)
699       .add(_aquaticQuantity)
700       .add(_plantQuantity);
701 
702     require(_totalAdopted <= MAX_TOTAL_ADOPTED_AXIES);
703 
704     address _adopter = msg.sender;
705     address _actualReferrer = 0x0;
706 
707     // An adopter cannot be his/her own referrer.
708     if (_referrer != _adopter) {
709       _actualReferrer = _referrer;
710     }
711 
712     uint256 _value = msg.value;
713     uint256 _price;
714 
715     if (_beastQuantity > 0) {
716       _price = _adoptSameClassAxies(
717         _adopter,
718         CLASS_BEAST,
719         _beastQuantity,
720         _actualReferrer
721       );
722 
723       require(_value >= _price);
724       _value -= _price;
725     }
726 
727     if (_aquaticQuantity > 0) {
728       _price = _adoptSameClassAxies(
729         _adopter,
730         CLASS_AQUATIC,
731         _aquaticQuantity,
732         _actualReferrer
733       );
734 
735       require(_value >= _price);
736       _value -= _price;
737     }
738 
739     if (_plantQuantity > 0) {
740       _price = _adoptSameClassAxies(
741         _adopter,
742         CLASS_PLANT,
743         _plantQuantity,
744         _actualReferrer
745       );
746 
747       require(_value >= _price);
748       _value -= _price;
749     }
750 
751     msg.sender.transfer(_value);
752 
753     // The current referral is ignored if the referrer's address is 0x0.
754     if (_actualReferrer != 0x0) {
755       _applyRefCredits(
756         _actualReferrer,
757         _beastQuantity.add(_aquaticQuantity).add(_plantQuantity)
758       );
759     }
760   }
761 
762   function mintRefCredits(
763     address _receiver,
764     uint256 _numMintedCredits
765   )
766     external
767     onlyOwner
768     whenInitialized
769     returns (uint256)
770   {
771     require(_receiver != address(0));
772     numBountyCredits = numBountyCredits.sub(_numMintedCredits);
773     _applyRefCredits(_receiver, _numMintedCredits);
774     RefCreditsMinted(_receiver, _numMintedCredits);
775     return numBountyCredits;
776   }
777 
778   function redeemAdoptedAxies(
779     address _receiver,
780     uint256 _beastQuantity,
781     uint256 _aquaticQuantity,
782     uint256 _plantQuantity
783   )
784     external
785     onlyRedemptionAddress
786     whenInitialized
787     returns (
788       uint256 /* remainingBeastQuantity */,
789       uint256 /* remainingAquaticQuantity */,
790       uint256 /* remainingPlantQuantity */
791     )
792   {
793     return (
794       _redeemSameClassAdoptedAxies(_receiver, CLASS_BEAST, _beastQuantity),
795       _redeemSameClassAdoptedAxies(_receiver, CLASS_AQUATIC, _aquaticQuantity),
796       _redeemSameClassAdoptedAxies(_receiver, CLASS_PLANT, _plantQuantity)
797     );
798   }
799 
800   function redeemRewardedAxies(
801     address _receiver,
802     uint256 _quantity
803   )
804     external
805     onlyRedemptionAddress
806     whenInitialized
807     returns (uint256 _remainingQuantity)
808   {
809     _remainingQuantity = this.numRewardedAxies(_receiver, true).sub(_quantity);
810 
811     if (_quantity > 0) {
812       _numDeductedRewardedAxies[_receiver] = _numDeductedRewardedAxies[_receiver].add(_quantity);
813       _totalDeductedRewardedAxies = _totalDeductedRewardedAxies.add(_quantity);
814 
815       RewardedAxiesRedeemed(_receiver, _quantity);
816     }
817   }
818 
819   /**
820    * @notice Calculate price of Axies from the same class.
821    * @param _class The class of Axies.
822    * @param _quantity Number of Axies to be calculated.
823    */
824   function _sameClassAxiesPrice(
825     uint8 _class,
826     uint256 _quantity
827   )
828     private
829     view
830     returns (
831       uint256 _totalPrice,
832       uint256 /* should be _subsequentIncrement */ _currentIncrement,
833       uint256 /* should be _subsequentPrice */ _currentPrice
834     )
835   {
836     _currentIncrement = priceIncrement[_class];
837     _currentPrice = currentPrice[_class];
838 
839     uint256 _nextPrice;
840 
841     for (uint256 i = 0; i < _quantity; i++) {
842       _totalPrice = _totalPrice.add(_currentPrice);
843       _nextPrice = _currentPrice.add(_currentIncrement);
844 
845       if (_nextPrice / 100 finney != _currentPrice / 100 finney) {
846         _currentIncrement >>= 1;
847       }
848 
849       _currentPrice = _nextPrice;
850     }
851   }
852 
853   /**
854    * @notice Adopt some Axies from the same class.
855    * @dev The quantity MUST be positive.
856    * @param _adopter Address of the adopter.
857    * @param _class The class of adopted Axies.
858    * @param _quantity Number of Axies to be adopted.
859    * @param _referrer Address of the referrer.
860    */
861   function _adoptSameClassAxies(
862     address _adopter,
863     uint8 _class,
864     uint256 _quantity,
865     address _referrer
866   )
867     private
868     returns (uint256 _totalPrice)
869   {
870     (_totalPrice, priceIncrement[_class], currentPrice[_class]) = _sameClassAxiesPrice(_class, _quantity);
871 
872     _numAdoptedAxies[_adopter][_class] = _numAdoptedAxies[_adopter][_class].add(_quantity);
873     _totalAdoptedAxies[_class] = _totalAdoptedAxies[_class].add(_quantity);
874 
875     AxiesAdopted(
876       _adopter,
877       _class,
878       _quantity,
879       _referrer
880     );
881   }
882 
883   function _applyRefCredits(address _receiver, uint256 _numAppliedCredits) private {
884     _numRefCredits[_receiver] = _numRefCredits[_receiver].add(_numAppliedCredits);
885 
886     uint256 _numCredits = this.numRefCredits(_receiver, true);
887     uint256 _numRewards = _numCredits / REF_CREDITS_PER_AXIE;
888 
889     if (_numRewards > 0) {
890       _numDeductedRefCredits[_receiver] = _numDeductedRefCredits[_receiver]
891         .add(_numRewards.mul(REF_CREDITS_PER_AXIE));
892 
893       _numRewardedAxies[_receiver] = _numRewardedAxies[_receiver].add(_numRewards);
894       _totalRewardedAxies = _totalRewardedAxies.add(_numRewards);
895 
896       AxiesRewarded(_receiver, _numRewards);
897     }
898   }
899 
900   /**
901    * @notice Redeem adopted Axies from the same class.
902    * @dev Emit the `AdoptedAxiesRedeemed` event if the quantity is positive.
903    * @param _receiver The address of the receiver.
904    * @param _class The class of adopted Axies.
905    * @param _quantity The number of adopted Axies to be redeemed.
906    */
907   function _redeemSameClassAdoptedAxies(
908     address _receiver,
909     uint8 _class,
910     uint256 _quantity
911   )
912     private
913     returns (uint256 _remainingQuantity)
914   {
915     _remainingQuantity = this.numAdoptedAxies(_receiver, _class, true).sub(_quantity);
916 
917     if (_quantity > 0) {
918       _numDeductedAdoptedAxies[_receiver][_class] = _numDeductedAdoptedAxies[_receiver][_class].add(_quantity);
919       _totalDeductedAdoptedAxies[_class] = _totalDeductedAdoptedAxies[_class].add(_quantity);
920 
921       AdoptedAxiesRedeemed(_receiver, _class, _quantity);
922     }
923   }
924 }