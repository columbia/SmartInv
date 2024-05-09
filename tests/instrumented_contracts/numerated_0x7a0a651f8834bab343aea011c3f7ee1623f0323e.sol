1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 contract AbstractStarbaseToken {
76     function isFundraiser(address fundraiserAddress) public returns (bool);
77     function company() public returns (address);
78     function allocateToCrowdsalePurchaser(address to, uint256 value) public returns (bool);
79     function allocateToMarketingSupporter(address to, uint256 value) public returns (bool);
80 }
81 
82 contract AbstractStarbaseCrowdsale {
83     function startDate() constant returns (uint256) {}
84     function endedAt() constant returns (uint256) {}
85     function isEnded() constant returns (bool);
86     function totalRaisedAmountInCny() constant returns (uint256);
87     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
88     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
89 }
90 
91 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
92 /// @author Starbase PTE. LTD. - <info@starbase.co>
93 contract StarbaseEarlyPurchase {
94     /*
95      *  Constants
96      */
97     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
98     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
99     uint256 public constant PURCHASE_AMOUNT_CAP = 9000000;
100 
101     /*
102      *  Types
103      */
104     struct EarlyPurchase {
105         address purchaser;
106         uint256 amount;        // CNY based amount
107         uint256 purchasedAt;   // timestamp
108     }
109 
110     /*
111      *  External contracts
112      */
113     AbstractStarbaseCrowdsale public starbaseCrowdsale;
114 
115     /*
116      *  Storage
117      */
118     address public owner;
119     EarlyPurchase[] public earlyPurchases;
120     uint256 public earlyPurchaseClosedAt;
121 
122     /*
123      *  Modifiers
124      */
125     modifier noEther() {
126         require(msg.value == 0);
127         _;
128     }
129 
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     modifier onlyBeforeCrowdsale() {
136         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
137         _;
138     }
139 
140     modifier onlyEarlyPurchaseTerm() {
141         assert(earlyPurchaseClosedAt <= 0);
142         _;
143     }
144 
145     /*
146      *  Contract functions
147      */
148 
149     /**
150      * @dev Returns early purchased amount by purchaser's address
151      * @param purchaser Purchaser address
152      */
153     function purchasedAmountBy(address purchaser)
154         external
155         constant
156         noEther
157         returns (uint256 amount)
158     {
159         for (uint256 i; i < earlyPurchases.length; i++) {
160             if (earlyPurchases[i].purchaser == purchaser) {
161                 amount += earlyPurchases[i].amount;
162             }
163         }
164     }
165 
166     /**
167      * @dev Returns total amount of raised funds by Early Purchasers
168      */
169     function totalAmountOfEarlyPurchases()
170         constant
171         noEther
172         public
173         returns (uint256 totalAmount)
174     {
175         for (uint256 i; i < earlyPurchases.length; i++) {
176             totalAmount += earlyPurchases[i].amount;
177         }
178     }
179 
180     /**
181      * @dev Returns number of early purchases
182      */
183     function numberOfEarlyPurchases()
184         external
185         constant
186         noEther
187         returns (uint256)
188     {
189         return earlyPurchases.length;
190     }
191 
192     /**
193      * @dev Append an early purchase log
194      * @param purchaser Purchaser address
195      * @param amount Purchase amount
196      * @param purchasedAt Timestamp of purchased date
197      */
198     function appendEarlyPurchase(address purchaser, uint256 amount, uint256 purchasedAt)
199         external
200         noEther
201         onlyOwner
202         onlyBeforeCrowdsale
203         onlyEarlyPurchaseTerm
204         returns (bool)
205     {
206         if (amount == 0 ||
207             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
208         {
209             return false;
210         }
211 
212         assert(purchasedAt != 0 || purchasedAt <= now);
213 
214         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
215         return true;
216     }
217 
218     /**
219      * @dev Close early purchase term
220      */
221     function closeEarlyPurchase()
222         external
223         noEther
224         onlyOwner
225         returns (bool)
226     {
227         earlyPurchaseClosedAt = now;
228     }
229 
230     /**
231      * @dev Setup function sets external contract's address
232      * @param starbaseCrowdsaleAddress Token address
233      */
234     function setup(address starbaseCrowdsaleAddress)
235         external
236         noEther
237         onlyOwner
238         returns (bool)
239     {
240         if (address(starbaseCrowdsale) == 0) {
241             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
242             return true;
243         }
244         return false;
245     }
246 
247     /**
248      * @dev Contract constructor function
249      */
250     function StarbaseEarlyPurchase() noEther {
251         owner = msg.sender;
252     }
253 }
254 
255 /// @title EarlyPurchaseAmendment contract - Amend early purchase records of the original contract
256 /// @author Starbase PTE. LTD. - <support@starbase.co>
257 contract StarbaseEarlyPurchaseAmendment {
258     /*
259      *  Events
260      */
261     event EarlyPurchaseInvalidated(uint256 epIdx);
262     event EarlyPurchaseAmended(uint256 epIdx);
263 
264     /*
265      *  External contracts
266      */
267     AbstractStarbaseCrowdsale public starbaseCrowdsale;
268     StarbaseEarlyPurchase public starbaseEarlyPurchase;
269 
270     /*
271      *  Storage
272      */
273     address public owner;
274     uint256[] public invalidEarlyPurchaseIndexes;
275     uint256[] public amendedEarlyPurchaseIndexes;
276     mapping (uint256 => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
277 
278     /*
279      *  Modifiers
280      */
281     modifier noEther() {
282         require(msg.value == 0);
283         _;
284     }
285 
286     modifier onlyOwner() {
287         require(msg.sender == owner);
288         _;
289     }
290 
291     modifier onlyBeforeCrowdsale() {
292         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
293         _;
294     }
295 
296     modifier onlyEarlyPurchasesLoaded() {
297         assert(address(starbaseEarlyPurchase) != address(0));
298         _;
299     }
300 
301     /*
302      *  Functions below are compatible with starbaseEarlyPurchase contract
303      */
304 
305     /**
306      * @dev Returns an early purchase record
307      * @param earlyPurchaseIndex Index number of an early purchase
308      */
309     function earlyPurchases(uint256 earlyPurchaseIndex)
310         external
311         constant
312         onlyEarlyPurchasesLoaded
313         returns (address purchaser, uint256 amount, uint256 purchasedAt)
314     {
315         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
316     }
317 
318     /**
319      * @dev Returns early purchased amount by purchaser's address
320      * @param purchaser Purchaser address
321      */
322     function purchasedAmountBy(address purchaser)
323         external
324         constant
325         noEther
326         returns (uint256 amount)
327     {
328         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
329             normalizedEarlyPurchases();
330         for (uint256 i; i < normalizedEP.length; i++) {
331             if (normalizedEP[i].purchaser == purchaser) {
332                 amount += normalizedEP[i].amount;
333             }
334         }
335     }
336 
337     /**
338      * @dev Returns total amount of raised funds by Early Purchasers
339      */
340     function totalAmountOfEarlyPurchases()
341         constant
342         noEther
343         public
344         returns (uint256 totalAmount)
345     {
346         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
347             normalizedEarlyPurchases();
348         for (uint256 i; i < normalizedEP.length; i++) {
349             totalAmount += normalizedEP[i].amount;
350         }
351     }
352 
353     /**
354      * @dev Returns number of early purchases
355      */
356     function numberOfEarlyPurchases()
357         external
358         constant
359         noEther
360         returns (uint256)
361     {
362         return normalizedEarlyPurchases().length;
363     }
364 
365     /**
366      * @dev Sets up function sets external contract's address
367      * @param starbaseCrowdsaleAddress Token address
368      */
369     function setup(address starbaseCrowdsaleAddress)
370         external
371         noEther
372         onlyOwner
373         returns (bool)
374     {
375         if (address(starbaseCrowdsale) == 0) {
376             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
377             return true;
378         }
379         return false;
380     }
381 
382     /*
383      *  Contract functions unique to StarbaseEarlyPurchaseAmendment
384      */
385 
386      /**
387       * @dev Invalidate early purchase
388       * @param earlyPurchaseIndex Index number of the purchase
389       */
390     function invalidateEarlyPurchase(uint256 earlyPurchaseIndex)
391         external
392         noEther
393         onlyOwner
394         onlyEarlyPurchasesLoaded
395         onlyBeforeCrowdsale
396         returns (bool)
397     {
398         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
399 
400         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
401             assert(invalidEarlyPurchaseIndexes[i] != earlyPurchaseIndex);
402         }
403 
404         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
405         EarlyPurchaseInvalidated(earlyPurchaseIndex);
406         return true;
407     }
408 
409     /**
410      * @dev Checks whether early purchase is invalid
411      * @param earlyPurchaseIndex Index number of the purchase
412      */
413     function isInvalidEarlyPurchase(uint256 earlyPurchaseIndex)
414         constant
415         noEther
416         public
417         returns (bool)
418     {
419         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
420 
421 
422         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
423             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
424                 return true;
425             }
426         }
427         return false;
428     }
429 
430     /**
431      * @dev Amends a given early purchase with data
432      * @param earlyPurchaseIndex Index number of the purchase
433      * @param purchaser Purchaser's address
434      * @param amount Value of purchase
435      * @param purchasedAt Purchase timestamp
436      */
437     function amendEarlyPurchase(uint256 earlyPurchaseIndex, address purchaser, uint256 amount, uint256 purchasedAt)
438         external
439         noEther
440         onlyOwner
441         onlyEarlyPurchasesLoaded
442         onlyBeforeCrowdsale
443         returns (bool)
444     {
445         assert(purchasedAt != 0 || purchasedAt <= now);
446 
447         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex);
448 
449         assert(!isInvalidEarlyPurchase(earlyPurchaseIndex)); // Invalid early purchase cannot be amended
450 
451         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
452             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
453         }
454 
455         amendedEarlyPurchases[earlyPurchaseIndex] =
456             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
457         EarlyPurchaseAmended(earlyPurchaseIndex);
458         return true;
459     }
460 
461     /**
462      * @dev Checks whether early purchase is amended
463      * @param earlyPurchaseIndex Index number of the purchase
464      */
465     function isAmendedEarlyPurchase(uint256 earlyPurchaseIndex)
466         constant
467         noEther
468         returns (bool)
469     {
470         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
471 
472         for (uint256 i; i < amendedEarlyPurchaseIndexes.length; i++) {
473             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
474                 return true;
475             }
476         }
477         return false;
478     }
479 
480     /**
481      * @dev Loads early purchases data to StarbaseEarlyPurchaseAmendment contract
482      * @param starbaseEarlyPurchaseAddress Address from starbase early purchase
483      */
484     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
485         external
486         noEther
487         onlyOwner
488         onlyBeforeCrowdsale
489         returns (bool)
490     {
491         assert(starbaseEarlyPurchaseAddress != 0 ||
492             address(starbaseEarlyPurchase) == 0);
493 
494         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
495         assert(starbaseEarlyPurchase.earlyPurchaseClosedAt() != 0); // the early purchase must be closed
496 
497         return true;
498     }
499 
500     /**
501      * @dev Contract constructor function. It sets owner
502      */
503     function StarbaseEarlyPurchaseAmendment() noEther {
504         owner = msg.sender;
505     }
506 
507     /**
508      * Internal functions
509      */
510 
511     /**
512      * @dev Normalizes early purchases data
513      */
514     function normalizedEarlyPurchases()
515         constant
516         internal
517         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
518     {
519         uint256 rawEPCount = numberOfRawEarlyPurchases();
520         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
521             rawEPCount - invalidEarlyPurchaseIndexes.length);
522 
523         uint256 normalizedIdx;
524         for (uint256 i; i < rawEPCount; i++) {
525             if (isInvalidEarlyPurchase(i)) {
526                 continue;   // invalid early purchase should be ignored
527             }
528 
529             StarbaseEarlyPurchase.EarlyPurchase memory ep;
530             if (isAmendedEarlyPurchase(i)) {
531                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
532             } else {
533                 ep = getEarlyPurchase(i);
534             }
535 
536             normalizedEP[normalizedIdx] = ep;
537             normalizedIdx++;
538         }
539     }
540 
541     /**
542      * @dev Fetches early purchases data
543      */
544     function getEarlyPurchase(uint256 earlyPurchaseIndex)
545         internal
546         constant
547         onlyEarlyPurchasesLoaded
548         returns (StarbaseEarlyPurchase.EarlyPurchase)
549     {
550         var (purchaser, amount, purchasedAt) =
551             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
552         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
553     }
554 
555     /**
556      * @dev Returns raw number of early purchases
557      */
558     function numberOfRawEarlyPurchases()
559         internal
560         constant
561         onlyEarlyPurchasesLoaded
562         returns (uint256)
563     {
564         return starbaseEarlyPurchase.numberOfEarlyPurchases();
565     }
566 }
567 
568 //! Certifier contract.
569 //! By Parity Technologies, 2017.
570 //! Released under the Apache Licence 2.
571 
572 contract Certifier {
573 	event Confirmed(address indexed who);
574 	event Revoked(address indexed who);
575 	function certified(address) public constant returns (bool);
576 	function get(address, string) public constant returns (bytes32);
577 	function getAddress(address, string) public constant returns (address);
578 	function getUint(address, string) public constant returns (uint);
579 }
580 
581 /**
582  * @title Crowdsale contract - Starbase crowdsale to create STAR.
583  * @author Starbase PTE. LTD. - <info@starbase.co>
584  */
585 contract StarbaseCrowdsale is Ownable {
586     using SafeMath for uint256;
587     /*
588      *  Events
589      */
590     event CrowdsaleEnded(uint256 endedAt);
591     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate);
592     event CnyEthRateUpdated(uint256 cnyEthRate);
593     event CnyBtcRateUpdated(uint256 cnyBtcRate);
594     event QualifiedPartnerAddress(address qualifiedPartner);
595 
596     /**
597      *  External contracts
598      */
599     AbstractStarbaseToken public starbaseToken;
600     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
601     Certifier public picopsCertifier;
602 
603     /**
604      *  Constants
605      */
606     uint256 constant public crowdsaleTokenAmount = 125000000e18;
607     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
608     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
609     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
610     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
611 
612     /**
613      * Types
614      */
615     struct CrowdsalePurchase {
616         address purchaser;
617         uint256 amount;        // CNY based amount with bonus
618         uint256 rawAmount;     // CNY based amount no bonus
619         uint256 purchasedAt;   // timestamp
620     }
621 
622     struct QualifiedPartners {
623         uint256 amountCap;
624         uint256 amountRaised;
625         bool    bonaFide;
626         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
627     }
628 
629     /*
630      *  Enums
631      */
632     enum BonusMilestones {
633         First,
634         Second,
635         Third,
636         Fourth,
637         Fifth
638     }
639 
640     // Initialize bonusMilestones
641     BonusMilestones public bonusMilestones = BonusMilestones.First;
642 
643     /**
644      *  Storage
645      */
646     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
647     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
648     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
649 
650     // early purchase
651     address[] public earlyPurchasers;
652     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
653     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
654     uint256 public totalAmountOfEarlyPurchases; // including 20% bonus
655 
656     // crowdsale
657     bool public presalePurchasesLoaded = false; // returns whether all presale purchases are loaded into this contract
658     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
659     uint256 public totalAmountOfCrowdsalePurchases; // in CNY, including bonuses
660     uint256 public totalAmountOfCrowdsalePurchasesWithoutBonus; // in CNY
661     mapping (address => QualifiedPartners) public qualifiedPartners;
662     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
663     uint256 public startDate;
664     uint256 public endedAt;
665     CrowdsalePurchase[] public crowdsalePurchases;
666     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
667     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
668     uint256 public cnyEthRate;
669 
670     // bonus milestones
671     uint256 public firstBonusEnds;
672     uint256 public secondBonusEnds;
673     uint256 public thirdBonusEnds;
674     uint256 public fourthBonusEnds;
675 
676     // after the crowdsale
677     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
678     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
679 
680     /**
681      *  Modifiers
682      */
683     modifier minInvestment() {
684         // User has to send at least the ether value of one token.
685         assert(msg.value >= MIN_INVESTMENT);
686         _;
687     }
688 
689     modifier whenNotStarted() {
690         assert(startDate == 0);
691         _;
692     }
693 
694     modifier whenEnded() {
695         assert(isEnded());
696         _;
697     }
698 
699     modifier hasBalance() {
700         assert(this.balance > 0);
701         _;
702     }
703     modifier rateIsSet(uint256 _rate) {
704         assert(_rate != 0);
705         _;
706     }
707 
708     modifier whenNotEnded() {
709         assert(!isEnded());
710         _;
711     }
712 
713     modifier tokensNotDelivered() {
714         assert(numOfDeliveredCrowdsalePurchases == 0);
715         assert(numOfDeliveredEarlyPurchases == 0);
716         _;
717     }
718 
719     modifier onlyFundraiser() {
720         assert(address(starbaseToken) != 0);
721         assert(starbaseToken.isFundraiser(msg.sender));
722         _;
723     }
724 
725     modifier onlyQualifiedPartner() {
726         assert(qualifiedPartners[msg.sender].bonaFide);
727         _;
728     }
729 
730     modifier onlyQualifiedPartnerORPicopsCertified() {
731         assert(qualifiedPartners[msg.sender].bonaFide || picopsCertifier.certified(msg.sender));
732         _;
733     }
734 
735     /**
736      * Contract functions
737      */
738     /**
739      * @dev Contract constructor function sets owner address and
740      *      address of StarbaseEarlyPurchaseAmendment contract.
741      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
742      * @param picopsCertifierAddr The address of the PICOPS certifier.
743      *                            See also https://picops.parity.io/#/details
744      */
745     function StarbaseCrowdsale(address starbaseEpAddr, address picopsCertifierAddr) {
746         require(starbaseEpAddr != 0 && picopsCertifierAddr != 0);
747         owner = msg.sender;
748         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
749         picopsCertifier = Certifier(picopsCertifierAddr);
750     }
751 
752     /**
753      * @dev Fallback accepts payment for Star tokens with Eth
754      */
755     function() payable {
756         redirectToPurchase();
757     }
758 
759     /**
760      * External functions
761      */
762 
763     /**
764      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
765      * @param starbaseTokenAddress Token address.
766      * @param _purchaseStartBlock Block number to start crowdsale
767      */
768     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
769         external
770         onlyOwner
771         returns (bool)
772     {
773         require(starbaseTokenAddress != address(0));
774         require(address(starbaseToken) == 0);
775         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
776         purchaseStartBlock = _purchaseStartBlock;
777 
778         // set the max cap of this crowdsale
779         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesWithoutBonus());
780 
781         assert(maxCrowdsaleCap > 0);
782 
783         return true;
784     }
785 
786     /**
787      * @dev Transfers raised funds to company's wallet address at any given time.
788      */
789     function withdrawForCompany()
790         external
791         onlyFundraiser
792         hasBalance
793     {
794         address company = starbaseToken.company();
795         require(company != address(0));
796         company.transfer(this.balance);
797     }
798 
799     /**
800      * @dev Update start block Number for the crowdsale
801      */
802     function updatePurchaseStartBlock(uint256 _purchaseStartBlock)
803         external
804         whenNotStarted
805         onlyFundraiser
806         returns (bool)
807     {
808         purchaseStartBlock = _purchaseStartBlock;
809         return true;
810     }
811 
812     /**
813      * @dev Update the CNY/ETH rate to record purchases in CNY
814      */
815     function updateCnyEthRate(uint256 rate)
816         external
817         onlyFundraiser
818         returns (bool)
819     {
820         cnyEthRate = rate;
821         CnyEthRateUpdated(cnyEthRate);
822         return true;
823     }
824 
825     /**
826      * @dev Update the CNY/BTC rate to record purchases in CNY
827      */
828     function updateCnyBtcRate(uint256 rate)
829         external
830         onlyFundraiser
831         returns (bool)
832     {
833         cnyBtcRate = rate;
834         CnyBtcRateUpdated(cnyBtcRate);
835         return true;
836     }
837 
838     /**
839      * @dev Allow for the possibility for contract owner to start crowdsale
840      */
841     function ownerStartsCrowdsale(uint256 timestamp)
842         external
843         whenNotStarted
844         onlyOwner
845     {
846         assert(block.number >= purchaseStartBlock);   // this should be after the crowdsale start block
847         startCrowdsale(timestamp);
848     }
849 
850     /**
851      * @dev Ends crowdsale
852      *      This may be executed by an owner if the raised funds did not reach the map cap
853      * @param timestamp Timestamp at the crowdsale ended
854      */
855     function endCrowdsale(uint256 timestamp)
856         external
857         onlyOwner
858     {
859         assert(timestamp > 0 && timestamp <= now);
860         assert(block.number >= purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
861         endedAt = timestamp;
862         CrowdsaleEnded(endedAt);
863     }
864 
865     /**
866      * @dev Ends crowdsale
867      *      This may be executed by purchaseWithEth when the raised funds reach the map cap
868      */
869     function endCrowdsale() internal {
870         assert(block.number >= purchaseStartBlock && endedAt == 0);
871         endedAt = now;
872         CrowdsaleEnded(endedAt);
873     }
874 
875     /**
876      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
877      */
878     function withdrawPurchasedTokens()
879         external
880         whenEnded
881         returns (bool)
882     {
883         assert(earlyPurchasesLoaded);
884         assert(address(starbaseToken) != 0);
885 
886         /*
887          * “Value” refers to the contribution of the User:
888          *  {crowdsale_purchaser_token_amount} =
889          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
890          *
891          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
892          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
893          * and total amount raised during the Contribution Period is 30’000’000, then he will get
894          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
895         */
896 
897         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
898             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
899             crowdsalePurchaseAmountBy[msg.sender] = 0;
900 
901             uint256 tokenCount =
902                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
903                 totalRaisedAmountInCny();
904 
905             numOfPurchasedTokensOnCsBy[msg.sender] =
906                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
907             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
908             numOfDeliveredCrowdsalePurchases++;
909         }
910 
911         /*
912          * “Value” refers to the contribution of the User:
913          * {earlypurchaser_token_amount} =
914          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
915          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
916          *
917          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
918          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
919          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
920          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
921          * 30’000’000 CNY + 6’000’000 CNY
922          */
923 
924         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
925             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
926             earlyPurchasedAmountBy[msg.sender] = 0;
927 
928             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases;
929 
930             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalRaisedAmountInCny();
931 
932             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
933 
934             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
935             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
936             numOfDeliveredEarlyPurchases++;
937         }
938 
939         return true;
940     }
941 
942     /**
943      * @dev Load early purchases from the contract keeps track of them
944      */
945     function loadEarlyPurchases() external onlyOwner returns (bool) {
946         if (earlyPurchasesLoaded) {
947             return false;    // all EPs have already been loaded
948         }
949 
950         uint256 numOfOrigEp = starbaseEpAmendment
951             .starbaseEarlyPurchase()
952             .numberOfEarlyPurchases();
953 
954         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
955             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
956                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
957                 continue;
958             }
959             var (purchaser, amount,) =
960                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
961                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
962                 : starbaseEpAmendment.earlyPurchases(i);
963             if (amount > 0) {
964                 if (earlyPurchasedAmountBy[purchaser] == 0) {
965                     earlyPurchasers.push(purchaser);
966                 }
967                 // each early purchaser receives 20% bonus
968                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
969                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
970 
971                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
972                 totalAmountOfEarlyPurchases = totalAmountOfEarlyPurchases.add(amountWithBonus);
973             }
974 
975             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
976         }
977 
978         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
979         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
980             earlyPurchasesLoaded = true;    // enable the flag
981         }
982         return true;
983     }
984 
985     /**
986      * @dev Load presale purchases from the contract keeps track of them
987      * @param starbaseCrowdsalePresale Starbase presale contract address
988      */
989     function loadPresalePurchases(address starbaseCrowdsalePresale)
990         external
991         onlyOwner
992         whenNotEnded
993     {
994         require(starbaseCrowdsalePresale != 0);
995         require(!presalePurchasesLoaded);
996         StarbaseCrowdsale presale = StarbaseCrowdsale(starbaseCrowdsalePresale);
997         for (uint i; i < presale.numOfPurchases(); i++) {
998             var (purchaser, amount, rawAmount, purchasedAt) =
999                 presale.crowdsalePurchases(i);  // presale purchase
1000             crowdsalePurchases.push(CrowdsalePurchase(purchaser, amount, rawAmount, purchasedAt));
1001 
1002             // Increase the sums
1003             crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1004             totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1005             totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1006         }
1007         presalePurchasesLoaded = true;
1008     }
1009 
1010     /**
1011       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
1012       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
1013       * @param _amountCap Ether value which partner is able to contribute
1014       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
1015       */
1016     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
1017         external
1018         onlyOwner
1019     {
1020         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
1021         qualifiedPartners[_qualifiedPartner].bonaFide = true;
1022         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1023         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
1024         QualifiedPartnerAddress(_qualifiedPartner);
1025     }
1026 
1027     /**
1028      * @dev Remove address from qualified partners list.
1029      * @param _qualifiedPartner Address to be removed from the list.
1030      */
1031     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
1032         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1033         qualifiedPartners[_qualifiedPartner].bonaFide = false;
1034     }
1035 
1036     /**
1037      * @dev Update whitelisted address amount allowed to raise during the presale.
1038      * @param _qualifiedPartner Qualified Partner address to be updated.
1039      * @param _amountCap Amount that the address is able to raise during the presale.
1040      */
1041     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
1042         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1043         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1044     }
1045 
1046     /**
1047      * Public functions
1048      */
1049 
1050     /**
1051      * @dev Returns boolean for whether crowdsale has ended
1052      */
1053     function isEnded() constant public returns (bool) {
1054         return (endedAt > 0 && endedAt <= now);
1055     }
1056 
1057     /**
1058      * @dev Returns number of purchases to date.
1059      */
1060     function numOfPurchases() constant public returns (uint256) {
1061         return crowdsalePurchases.length;
1062     }
1063 
1064     /**
1065      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1066      */
1067     function totalRaisedAmountInCny() constant public returns (uint256) {
1068         return totalAmountOfEarlyPurchases.add(totalAmountOfCrowdsalePurchases);
1069     }
1070 
1071     /**
1072      * @dev Returns total amount of early purchases in CNY and bonuses
1073      */
1074     function totalAmountOfEarlyPurchasesWithBonus() constant public returns(uint256) {
1075        return starbaseEpAmendment.totalAmountOfEarlyPurchases().mul(120).div(100);
1076     }
1077 
1078     /**
1079      * @dev Returns total amount of early purchases in CNY
1080      */
1081     function totalAmountOfEarlyPurchasesWithoutBonus() constant public returns(uint256) {
1082        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1083     }
1084 
1085     /**
1086      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1087      */
1088     function purchaseAsQualifiedPartner()
1089         payable
1090         public
1091         rateIsSet(cnyEthRate)
1092         onlyQualifiedPartner
1093         returns (bool)
1094     {
1095         require(msg.value > 0);
1096         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1097 
1098         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1099 
1100         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1101         recordPurchase(msg.sender, rawAmount, now);
1102 
1103         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1104             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1105         }
1106 
1107         return true;
1108     }
1109 
1110     /**
1111      * @dev Allows user to purchase STAR tokens with Ether
1112      */
1113     function purchaseWithEth()
1114         payable
1115         public
1116         minInvestment
1117         whenNotEnded
1118         rateIsSet(cnyEthRate)
1119         onlyQualifiedPartnerORPicopsCertified
1120         returns (bool)
1121     {
1122         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1123 
1124         if (startDate == 0) {
1125             startCrowdsale(block.timestamp);
1126         }
1127 
1128         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1129         recordPurchase(msg.sender, rawAmount, now);
1130 
1131         if (totalAmountOfCrowdsalePurchasesWithoutBonus >= maxCrowdsaleCap) {
1132             endCrowdsale(); // ends this crowdsale automatically
1133         }
1134 
1135         return true;
1136     }
1137 
1138     /**
1139      * Internal functions
1140      */
1141 
1142     /**
1143      * @dev Initializes Starbase crowdsale
1144      */
1145     function startCrowdsale(uint256 timestamp) internal {
1146         startDate = timestamp;
1147         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus;
1148         if (maxCrowdsaleCap > presaleAmount) {
1149             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1150             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1151 
1152             // set token bonus milestones in cny total crowdsale purchase
1153             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1154             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1155             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1156             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1157         }
1158     }
1159 
1160     /**
1161      * @dev Abstract record of a purchase to Tokens
1162      * @param purchaser Address of the buyer
1163      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1164      * @param timestamp Timestamp at the purchase made
1165      */
1166     function recordPurchase(
1167         address purchaser,
1168         uint256 rawAmount,
1169         uint256 timestamp
1170     )
1171         internal
1172         returns(uint256 amount)
1173     {
1174         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1175 
1176         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1177         if (block.number >= purchaseStartBlock) {
1178             require(totalAmountOfCrowdsalePurchasesWithoutBonus < maxCrowdsaleCap);   // check if the amount has already reached the cap
1179 
1180             uint256 crowdsaleTotalAmountAfterPurchase =
1181                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus, amount);
1182 
1183             // check whether purchase goes over the cap and send the difference back to the purchaser.
1184             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1185               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1186               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1187               purchaser.transfer(ethValueToReturn);
1188               amount = SafeMath.sub(amount, difference);
1189               rawAmount = amount;
1190             }
1191         }
1192 
1193         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1194 
1195         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1196         crowdsalePurchases.push(purchase);
1197         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1198         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1199         totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1200         totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1201         return amount;
1202     }
1203 
1204     /**
1205      * @dev Calculates amount with bonus for bonus milestones
1206      */
1207     function calculateBonus
1208         (
1209             BonusMilestones nextMilestone,
1210             uint256 amount,
1211             uint256 bonusRange,
1212             uint256 bonusTier,
1213             uint256 results
1214         )
1215         internal
1216         returns (uint256 result, uint256 newAmount)
1217     {
1218         uint256 bonusCalc;
1219 
1220         if (amount <= bonusRange) {
1221             bonusCalc = amount.mul(bonusTier).div(100);
1222 
1223             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus) >= bonusRange)
1224                 bonusMilestones = nextMilestone;
1225 
1226             result = results.add(amount).add(bonusCalc);
1227             newAmount = 0;
1228 
1229         } else {
1230             bonusCalc = bonusRange.mul(bonusTier).div(100);
1231             bonusMilestones = nextMilestone;
1232             result = results.add(bonusRange).add(bonusCalc);
1233             newAmount = amount.sub(bonusRange);
1234         }
1235     }
1236 
1237     /**
1238      * @dev Fetchs Bonus tier percentage per bonus milestones
1239      */
1240     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1241         if (block.number < purchaseStartBlock) {
1242             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1243             return amount.add(bonusFromAmount);
1244         }
1245 
1246         // range of each bonus milestones
1247         uint256 firstBonusRange = firstBonusEnds;
1248         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1249         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1250         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1251         uint256 result;
1252 
1253         if (bonusMilestones == BonusMilestones.First)
1254             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1255 
1256         if (bonusMilestones == BonusMilestones.Second)
1257             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1258 
1259         if (bonusMilestones == BonusMilestones.Third)
1260             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1261 
1262         if (bonusMilestones == BonusMilestones.Fourth)
1263             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1264 
1265         return result.add(amount);
1266     }
1267 
1268     /**
1269      * @dev Fetchs Bonus tier percentage per bonus milestones
1270      * @dev qualifiedPartner Address of partners that participated in pre sale
1271      * @dev amountSent Value sent by qualified partner
1272      */
1273     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1274         //calculate the commission fee to send to qualified partner
1275         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1276 
1277         // send commission fee amount
1278         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1279     }
1280 
1281     /**
1282      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1283      */
1284     function redirectToPurchase() internal {
1285         if (block.number < purchaseStartBlock) {
1286             purchaseAsQualifiedPartner();
1287         } else {
1288             purchaseWithEth();
1289         }
1290     }
1291 }
1292 
1293 /**
1294  * @title Starbase Crowdsale Contract Withdrawal contract - Provides an function
1295           to withdraw STAR token according to crowdsale results
1296  * @author Starbase PTE. LTD. - <info@starbase.co>
1297  */
1298 contract StarbaseCrowdsaleContractW is Ownable {
1299     using SafeMath for uint256;
1300 
1301     /*
1302      *  Events
1303      */
1304     event TokenWithdrawn(address purchaser, uint256 tokenCount);
1305     event CrowdsalePurchaseBonusLog(
1306         uint256 purchaseIdx, uint256 rawAmount, uint256 bonus);
1307 
1308     /**
1309      *  External contracts
1310      */
1311     AbstractStarbaseToken public starbaseToken;
1312     StarbaseCrowdsale public starbaseCrowdsale;
1313 
1314     /**
1315      *  Constants
1316      */
1317     uint256 constant public crowdsaleTokenAmount = 125000000e18;
1318     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
1319 
1320     /**
1321      *  Storage
1322      */
1323 
1324     // early purchase
1325     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
1326     uint256 public totalAmountOfEarlyPurchases; // including 20% bonus
1327     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
1328 
1329     // crowdsale
1330     uint256 public totalAmountOfCrowdsalePurchases; // in CNY, including bonuses
1331     uint256 public totalAmountOfCrowdsalePurchasesWithoutBonus; // in CNY
1332     uint256 public startDate;
1333     uint256 public endedAt;
1334     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
1335     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
1336 
1337     // crowdsale contract withdrawal
1338     bool public crowdsalePurchasesLoaded = false;   // returns whether all crowdsale purchases are loaded into this contract
1339     uint256 public numOfLoadedCrowdsalePurchases; // index to keep the number of crowdsale purchases that have already been loaded by `loadCrowdsalePurchases`
1340     uint256 public totalAmountOfPresalePurchasesWithoutBonus;  // in CNY
1341 
1342     // bonus milestones
1343     uint256 public firstBonusEnds;
1344     uint256 public secondBonusEnds;
1345     uint256 public thirdBonusEnds;
1346     uint256 public fourthBonusEnds;
1347 
1348     // after the crowdsale
1349     mapping (address => bool) public tokenWithdrawn;    // returns whether purchased tokens were withdrawn by a purchaser
1350     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
1351     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
1352 
1353     /**
1354      *  Modifiers
1355      */
1356     modifier whenEnded() {
1357         assert(isEnded());
1358         _;
1359     }
1360 
1361     /**
1362      * Contract functions
1363      */
1364 
1365     /**
1366      * @dev Reject all incoming Ether transfers
1367      */
1368     function () { revert(); }
1369 
1370     /**
1371      * External functions
1372      */
1373 
1374     /**
1375      * @dev Setup function sets external contracts' address
1376      * @param starbaseTokenAddress Token address.
1377      * @param StarbaseCrowdsaleAddress Token address.
1378      */
1379     function setup(address starbaseTokenAddress, address StarbaseCrowdsaleAddress)
1380         external
1381         onlyOwner
1382     {
1383         require(starbaseTokenAddress != address(0) && StarbaseCrowdsaleAddress != address(0));
1384         require(address(starbaseToken) == 0 && address(starbaseCrowdsale) == 0);
1385 
1386         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
1387         starbaseCrowdsale = StarbaseCrowdsale(StarbaseCrowdsaleAddress);
1388 
1389         require(starbaseCrowdsale.startDate() > 0);
1390         startDate = starbaseCrowdsale.startDate();
1391 
1392         require(starbaseCrowdsale.endedAt() > 0);
1393         endedAt = starbaseCrowdsale.endedAt();
1394 
1395         totalAmountOfEarlyPurchases = starbaseCrowdsale.totalAmountOfEarlyPurchases();
1396     }
1397 
1398     /**
1399      * @dev Load crowdsale purchases from the contract keeps track of them
1400      * @param numOfPresalePurchases Number of presale purchase
1401      */
1402     function loadCrowdsalePurchases(uint256 numOfPresalePurchases)
1403         external
1404         onlyOwner
1405         whenEnded
1406     {
1407         require(!crowdsalePurchasesLoaded);
1408 
1409         uint256 numOfPurchases = starbaseCrowdsale.numOfPurchases();
1410 
1411         for (uint256 i = numOfLoadedCrowdsalePurchases; i < numOfPurchases && msg.gas > 200000; i++) {
1412             var (purchaser, amount, rawAmount,) =
1413                 starbaseCrowdsale.crowdsalePurchases(i);
1414 
1415             uint256 bonus;
1416             if (i < numOfPresalePurchases) {
1417                 bonus = rawAmount * 30 / 100;   // presale: 30% bonus
1418                 totalAmountOfPresalePurchasesWithoutBonus =
1419                     totalAmountOfPresalePurchasesWithoutBonus.add(rawAmount);
1420             } else {
1421                 bonus = calculateBonus(rawAmount); // mainsale: 20% ~ 0% bonus
1422             }
1423 
1424             // Update amount with bonus
1425             CrowdsalePurchaseBonusLog(i, rawAmount, bonus);
1426             amount = rawAmount + bonus;
1427 
1428             // Increase the sums
1429             crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1430             totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1431             totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1432 
1433             numOfLoadedCrowdsalePurchases++;    // Increase the index
1434         }
1435 
1436         assert(numOfLoadedCrowdsalePurchases <= numOfPurchases);
1437         if (numOfLoadedCrowdsalePurchases == numOfPurchases) {
1438             crowdsalePurchasesLoaded = true;    // enable the flag
1439         }
1440     }
1441 
1442     /**
1443      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
1444      */
1445     function withdrawPurchasedTokens()
1446         external
1447         whenEnded
1448     {
1449         require(starbaseCrowdsale.earlyPurchasesLoaded());
1450         require(crowdsalePurchasesLoaded);
1451         assert(address(starbaseToken) != 0);
1452 
1453         // prevent double withdrawal
1454         require(!tokenWithdrawn[msg.sender]);
1455         tokenWithdrawn[msg.sender] = true;
1456 
1457         /*
1458          * “Value” refers to the contribution of the User:
1459          *  {crowdsale_purchaser_token_amount} =
1460          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
1461          *
1462          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
1463          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
1464          * and total amount raised during the Contribution Period is 30’000’000, then he will get
1465          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
1466         */
1467 
1468         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
1469             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
1470             uint256 tokenCount =
1471                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
1472                 totalRaisedAmountInCny();
1473 
1474             numOfPurchasedTokensOnCsBy[msg.sender] =
1475                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
1476             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
1477             numOfDeliveredCrowdsalePurchases++;
1478             TokenWithdrawn(msg.sender, tokenCount);
1479         }
1480 
1481         /*
1482          * “Value” refers to the contribution of the User:
1483          * {earlypurchaser_token_amount} =
1484          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
1485          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
1486          *
1487          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
1488          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
1489          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
1490          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
1491          * 30’000’000 CNY + 6’000’000 CNY
1492          */
1493 
1494         if (earlyPurchasedAmountBy(msg.sender) > 0) {  // skip if is not an early purchaser
1495             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy(msg.sender);
1496             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases;
1497             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalRaisedAmountInCny();
1498             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
1499 
1500             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
1501             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
1502             numOfDeliveredEarlyPurchases++;
1503             TokenWithdrawn(msg.sender, epTokenCount);
1504         }
1505     }
1506 
1507     /**
1508      * Public functions
1509      */
1510 
1511     /**
1512      * @dev Returns purchased amount by an early purchaser
1513      * @param purchaser Address of an early purchaser
1514      */
1515     function earlyPurchasedAmountBy(address purchaser)
1516         constant
1517         public
1518         returns (uint256)
1519     {
1520         return starbaseCrowdsale.earlyPurchasedAmountBy(purchaser);
1521     }
1522 
1523     /**
1524      * @dev Returns boolean for whether crowdsale has ended
1525      */
1526     function isEnded() constant public returns (bool) {
1527         return (starbaseCrowdsale != address(0) && endedAt > 0);
1528     }
1529 
1530     /**
1531      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1532      */
1533     function totalRaisedAmountInCny() constant public returns (uint256) {
1534         return totalAmountOfEarlyPurchases.add(totalAmountOfCrowdsalePurchases);
1535     }
1536 
1537     /**
1538      * Internal functions
1539      */
1540 
1541     /**
1542      * @dev Calculates bonus of a purchase
1543      */
1544     function calculateBonus(uint256 rawAmount)
1545         internal
1546         returns (uint256 bonus)
1547     {
1548         uint256 purchasedAmount =
1549             totalAmountOfCrowdsalePurchasesWithoutBonus
1550                 .sub(totalAmountOfPresalePurchasesWithoutBonus);
1551         uint256 e1 = starbaseCrowdsale.firstBonusEnds();
1552         uint256 e2 = starbaseCrowdsale.secondBonusEnds();
1553         uint256 e3 = starbaseCrowdsale.thirdBonusEnds();
1554         uint256 e4 = starbaseCrowdsale.fourthBonusEnds();
1555         return calculateBonusInRange(purchasedAmount, rawAmount, 0, e1, 20)
1556             .add(calculateBonusInRange(purchasedAmount, rawAmount, e1, e2, 15))
1557             .add(calculateBonusInRange(purchasedAmount, rawAmount, e2, e3, 10))
1558             .add(calculateBonusInRange(purchasedAmount, rawAmount, e3, e4, 5));
1559     }
1560 
1561     function calculateBonusInRange(
1562         uint256 purchasedAmount,
1563         uint256 rawAmount,
1564         uint256 bonusBegin,
1565         uint256 bonusEnd,
1566         uint256 bonusTier
1567     )
1568         public
1569         constant
1570         returns (uint256 bonus)
1571     {
1572         uint256 sum = purchasedAmount + rawAmount;
1573         if (purchasedAmount > bonusEnd || sum < bonusBegin) {
1574             return 0;   // out of this range
1575         }
1576 
1577         uint256 min = purchasedAmount <= bonusBegin ? bonusBegin : purchasedAmount;
1578         uint256 max = bonusEnd <= sum ? bonusEnd : sum;
1579         return max.sub(min) * bonusTier / 100;
1580     }
1581 }