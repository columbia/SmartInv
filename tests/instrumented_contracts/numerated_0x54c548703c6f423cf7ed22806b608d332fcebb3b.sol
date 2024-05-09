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
82 
83 contract AbstractStarbaseCrowdsale {
84     function startDate() constant returns (uint256) {}
85     function endedAt() constant returns (uint256) {}
86     function isEnded() constant returns (bool);
87     function totalRaisedAmountInCny() constant returns (uint256);
88     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
89     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
90 }
91 
92 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
93 /// @author Starbase PTE. LTD. - <info@starbase.co>
94 contract StarbaseEarlyPurchase {
95     /*
96      *  Constants
97      */
98     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
99     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
100     uint256 public constant PURCHASE_AMOUNT_CAP = 9000000;
101 
102     /*
103      *  Types
104      */
105     struct EarlyPurchase {
106         address purchaser;
107         uint256 amount;        // CNY based amount
108         uint256 purchasedAt;   // timestamp
109     }
110 
111     /*
112      *  External contracts
113      */
114     AbstractStarbaseCrowdsale public starbaseCrowdsale;
115 
116     /*
117      *  Storage
118      */
119     address public owner;
120     EarlyPurchase[] public earlyPurchases;
121     uint256 public earlyPurchaseClosedAt;
122 
123     /*
124      *  Modifiers
125      */
126     modifier noEther() {
127         require(msg.value == 0);
128         _;
129     }
130 
131     modifier onlyOwner() {
132         require(msg.sender == owner);
133         _;
134     }
135 
136     modifier onlyBeforeCrowdsale() {
137         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
138         _;
139     }
140 
141     modifier onlyEarlyPurchaseTerm() {
142         assert(earlyPurchaseClosedAt <= 0);
143         _;
144     }
145 
146     /*
147      *  Contract functions
148      */
149 
150     /**
151      * @dev Returns early purchased amount by purchaser's address
152      * @param purchaser Purchaser address
153      */
154     function purchasedAmountBy(address purchaser)
155         external
156         constant
157         noEther
158         returns (uint256 amount)
159     {
160         for (uint256 i; i < earlyPurchases.length; i++) {
161             if (earlyPurchases[i].purchaser == purchaser) {
162                 amount += earlyPurchases[i].amount;
163             }
164         }
165     }
166 
167     /**
168      * @dev Returns total amount of raised funds by Early Purchasers
169      */
170     function totalAmountOfEarlyPurchases()
171         constant
172         noEther
173         public
174         returns (uint256 totalAmount)
175     {
176         for (uint256 i; i < earlyPurchases.length; i++) {
177             totalAmount += earlyPurchases[i].amount;
178         }
179     }
180 
181     /**
182      * @dev Returns number of early purchases
183      */
184     function numberOfEarlyPurchases()
185         external
186         constant
187         noEther
188         returns (uint256)
189     {
190         return earlyPurchases.length;
191     }
192 
193     /**
194      * @dev Append an early purchase log
195      * @param purchaser Purchaser address
196      * @param amount Purchase amount
197      * @param purchasedAt Timestamp of purchased date
198      */
199     function appendEarlyPurchase(address purchaser, uint256 amount, uint256 purchasedAt)
200         external
201         noEther
202         onlyOwner
203         onlyBeforeCrowdsale
204         onlyEarlyPurchaseTerm
205         returns (bool)
206     {
207         if (amount == 0 ||
208             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
209         {
210             return false;
211         }
212 
213         assert(purchasedAt != 0 || purchasedAt <= now);
214 
215         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
216         return true;
217     }
218 
219     /**
220      * @dev Close early purchase term
221      */
222     function closeEarlyPurchase()
223         external
224         noEther
225         onlyOwner
226         returns (bool)
227     {
228         earlyPurchaseClosedAt = now;
229     }
230 
231     /**
232      * @dev Setup function sets external contract's address
233      * @param starbaseCrowdsaleAddress Token address
234      */
235     function setup(address starbaseCrowdsaleAddress)
236         external
237         noEther
238         onlyOwner
239         returns (bool)
240     {
241         if (address(starbaseCrowdsale) == 0) {
242             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
243             return true;
244         }
245         return false;
246     }
247 
248     /**
249      * @dev Contract constructor function
250      */
251     function StarbaseEarlyPurchase() noEther {
252         owner = msg.sender;
253     }
254 }
255 
256 /// @title EarlyPurchaseAmendment contract - Amend early purchase records of the original contract
257 /// @author Starbase PTE. LTD. - <support@starbase.co>
258 contract StarbaseEarlyPurchaseAmendment {
259     /*
260      *  Events
261      */
262     event EarlyPurchaseInvalidated(uint256 epIdx);
263     event EarlyPurchaseAmended(uint256 epIdx);
264 
265     /*
266      *  External contracts
267      */
268     AbstractStarbaseCrowdsale public starbaseCrowdsale;
269     StarbaseEarlyPurchase public starbaseEarlyPurchase;
270 
271     /*
272      *  Storage
273      */
274     address public owner;
275     uint256[] public invalidEarlyPurchaseIndexes;
276     uint256[] public amendedEarlyPurchaseIndexes;
277     mapping (uint256 => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
278 
279     /*
280      *  Modifiers
281      */
282     modifier noEther() {
283         require(msg.value == 0);
284         _;
285     }
286 
287     modifier onlyOwner() {
288         require(msg.sender == owner);
289         _;
290     }
291 
292     modifier onlyBeforeCrowdsale() {
293         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
294         _;
295     }
296 
297     modifier onlyEarlyPurchasesLoaded() {
298         assert(address(starbaseEarlyPurchase) != address(0));
299         _;
300     }
301 
302     /*
303      *  Functions below are compatible with starbaseEarlyPurchase contract
304      */
305 
306     /**
307      * @dev Returns an early purchase record
308      * @param earlyPurchaseIndex Index number of an early purchase
309      */
310     function earlyPurchases(uint256 earlyPurchaseIndex)
311         external
312         constant
313         onlyEarlyPurchasesLoaded
314         returns (address purchaser, uint256 amount, uint256 purchasedAt)
315     {
316         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
317     }
318 
319     /**
320      * @dev Returns early purchased amount by purchaser's address
321      * @param purchaser Purchaser address
322      */
323     function purchasedAmountBy(address purchaser)
324         external
325         constant
326         noEther
327         returns (uint256 amount)
328     {
329         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
330             normalizedEarlyPurchases();
331         for (uint256 i; i < normalizedEP.length; i++) {
332             if (normalizedEP[i].purchaser == purchaser) {
333                 amount += normalizedEP[i].amount;
334             }
335         }
336     }
337 
338     /**
339      * @dev Returns total amount of raised funds by Early Purchasers
340      */
341     function totalAmountOfEarlyPurchases()
342         constant
343         noEther
344         public
345         returns (uint256 totalAmount)
346     {
347         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
348             normalizedEarlyPurchases();
349         for (uint256 i; i < normalizedEP.length; i++) {
350             totalAmount += normalizedEP[i].amount;
351         }
352     }
353 
354     /**
355      * @dev Returns number of early purchases
356      */
357     function numberOfEarlyPurchases()
358         external
359         constant
360         noEther
361         returns (uint256)
362     {
363         return normalizedEarlyPurchases().length;
364     }
365 
366     /**
367      * @dev Sets up function sets external contract's address
368      * @param starbaseCrowdsaleAddress Token address
369      */
370     function setup(address starbaseCrowdsaleAddress)
371         external
372         noEther
373         onlyOwner
374         returns (bool)
375     {
376         if (address(starbaseCrowdsale) == 0) {
377             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
378             return true;
379         }
380         return false;
381     }
382 
383     /*
384      *  Contract functions unique to StarbaseEarlyPurchaseAmendment
385      */
386 
387      /**
388       * @dev Invalidate early purchase
389       * @param earlyPurchaseIndex Index number of the purchase
390       */
391     function invalidateEarlyPurchase(uint256 earlyPurchaseIndex)
392         external
393         noEther
394         onlyOwner
395         onlyEarlyPurchasesLoaded
396         onlyBeforeCrowdsale
397         returns (bool)
398     {
399         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
400 
401         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
402             assert(invalidEarlyPurchaseIndexes[i] != earlyPurchaseIndex);
403         }
404 
405         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
406         EarlyPurchaseInvalidated(earlyPurchaseIndex);
407         return true;
408     }
409 
410     /**
411      * @dev Checks whether early purchase is invalid
412      * @param earlyPurchaseIndex Index number of the purchase
413      */
414     function isInvalidEarlyPurchase(uint256 earlyPurchaseIndex)
415         constant
416         noEther
417         public
418         returns (bool)
419     {
420         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
421 
422 
423         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
424             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
425                 return true;
426             }
427         }
428         return false;
429     }
430 
431     /**
432      * @dev Amends a given early purchase with data
433      * @param earlyPurchaseIndex Index number of the purchase
434      * @param purchaser Purchaser's address
435      * @param amount Value of purchase
436      * @param purchasedAt Purchase timestamp
437      */
438     function amendEarlyPurchase(uint256 earlyPurchaseIndex, address purchaser, uint256 amount, uint256 purchasedAt)
439         external
440         noEther
441         onlyOwner
442         onlyEarlyPurchasesLoaded
443         onlyBeforeCrowdsale
444         returns (bool)
445     {
446         assert(purchasedAt != 0 || purchasedAt <= now);
447 
448         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex);
449 
450         assert(!isInvalidEarlyPurchase(earlyPurchaseIndex)); // Invalid early purchase cannot be amended
451 
452         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
453             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
454         }
455 
456         amendedEarlyPurchases[earlyPurchaseIndex] =
457             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
458         EarlyPurchaseAmended(earlyPurchaseIndex);
459         return true;
460     }
461 
462     /**
463      * @dev Checks whether early purchase is amended
464      * @param earlyPurchaseIndex Index number of the purchase
465      */
466     function isAmendedEarlyPurchase(uint256 earlyPurchaseIndex)
467         constant
468         noEther
469         returns (bool)
470     {
471         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
472 
473         for (uint256 i; i < amendedEarlyPurchaseIndexes.length; i++) {
474             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
475                 return true;
476             }
477         }
478         return false;
479     }
480 
481     /**
482      * @dev Loads early purchases data to StarbaseEarlyPurchaseAmendment contract
483      * @param starbaseEarlyPurchaseAddress Address from starbase early purchase
484      */
485     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
486         external
487         noEther
488         onlyOwner
489         onlyBeforeCrowdsale
490         returns (bool)
491     {
492         assert(starbaseEarlyPurchaseAddress != 0 ||
493             address(starbaseEarlyPurchase) == 0);
494 
495         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
496         assert(starbaseEarlyPurchase.earlyPurchaseClosedAt() != 0); // the early purchase must be closed
497 
498         return true;
499     }
500 
501     /**
502      * @dev Contract constructor function. It sets owner
503      */
504     function StarbaseEarlyPurchaseAmendment() noEther {
505         owner = msg.sender;
506     }
507 
508     /**
509      * Internal functions
510      */
511 
512     /**
513      * @dev Normalizes early purchases data
514      */
515     function normalizedEarlyPurchases()
516         constant
517         internal
518         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
519     {
520         uint256 rawEPCount = numberOfRawEarlyPurchases();
521         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
522             rawEPCount - invalidEarlyPurchaseIndexes.length);
523 
524         uint256 normalizedIdx;
525         for (uint256 i; i < rawEPCount; i++) {
526             if (isInvalidEarlyPurchase(i)) {
527                 continue;   // invalid early purchase should be ignored
528             }
529 
530             StarbaseEarlyPurchase.EarlyPurchase memory ep;
531             if (isAmendedEarlyPurchase(i)) {
532                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
533             } else {
534                 ep = getEarlyPurchase(i);
535             }
536 
537             normalizedEP[normalizedIdx] = ep;
538             normalizedIdx++;
539         }
540     }
541 
542     /**
543      * @dev Fetches early purchases data
544      */
545     function getEarlyPurchase(uint256 earlyPurchaseIndex)
546         internal
547         constant
548         onlyEarlyPurchasesLoaded
549         returns (StarbaseEarlyPurchase.EarlyPurchase)
550     {
551         var (purchaser, amount, purchasedAt) =
552             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
553         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
554     }
555 
556     /**
557      * @dev Returns raw number of early purchases
558      */
559     function numberOfRawEarlyPurchases()
560         internal
561         constant
562         onlyEarlyPurchasesLoaded
563         returns (uint256)
564     {
565         return starbaseEarlyPurchase.numberOfEarlyPurchases();
566     }
567 }
568 
569 
570 contract Certifier {
571 	event Confirmed(address indexed who);
572 	event Revoked(address indexed who);
573 	function certified(address) public constant returns (bool);
574 	function get(address, string) public constant returns (bytes32);
575 	function getAddress(address, string) public constant returns (address);
576 	function getUint(address, string) public constant returns (uint);
577 }
578 
579 /**
580  * @title Crowdsale contract - Starbase crowdsale to create STAR.
581  * @author Starbase PTE. LTD. - <info@starbase.co>
582  */
583 contract StarbaseCrowdsale is Ownable {
584     using SafeMath for uint256;
585     /*
586      *  Events
587      */
588     event CrowdsaleEnded(uint256 endedAt);
589     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate);
590     event CnyEthRateUpdated(uint256 cnyEthRate);
591     event CnyBtcRateUpdated(uint256 cnyBtcRate);
592     event QualifiedPartnerAddress(address qualifiedPartner);
593 
594     /**
595      *  External contracts
596      */
597     AbstractStarbaseToken public starbaseToken;
598     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
599     Certifier public picopsCertifier;
600 
601     /**
602      *  Constants
603      */
604     uint256 constant public crowdsaleTokenAmount = 125000000e18;
605     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
606     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
607     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
608     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
609 
610     /**
611      * Types
612      */
613     struct CrowdsalePurchase {
614         address purchaser;
615         uint256 amount;        // CNY based amount with bonus
616         uint256 rawAmount;     // CNY based amount no bonus
617         uint256 purchasedAt;   // timestamp
618     }
619 
620     struct QualifiedPartners {
621         uint256 amountCap;
622         uint256 amountRaised;
623         bool    bonaFide;
624         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
625     }
626 
627     /*
628      *  Enums
629      */
630     enum BonusMilestones {
631         First,
632         Second,
633         Third,
634         Fourth,
635         Fifth
636     }
637 
638     // Initialize bonusMilestones
639     BonusMilestones public bonusMilestones = BonusMilestones.First;
640 
641     /**
642      *  Storage
643      */
644     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
645     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
646     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
647 
648     // early purchase
649     address[] public earlyPurchasers;
650     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
651     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
652     uint256 public totalAmountOfEarlyPurchases; // including 20% bonus
653 
654     // crowdsale
655     bool public presalePurchasesLoaded = false; // returns whether all presale purchases are loaded into this contract
656     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
657     uint256 public totalAmountOfCrowdsalePurchases; // in CNY, including bonuses
658     uint256 public totalAmountOfCrowdsalePurchasesWithoutBonus; // in CNY
659     mapping (address => QualifiedPartners) public qualifiedPartners;
660     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
661     uint256 public startDate;
662     uint256 public endedAt;
663     CrowdsalePurchase[] public crowdsalePurchases;
664     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
665     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
666     uint256 public cnyEthRate;
667 
668     // bonus milestones
669     uint256 public firstBonusEnds;
670     uint256 public secondBonusEnds;
671     uint256 public thirdBonusEnds;
672     uint256 public fourthBonusEnds;
673 
674     // after the crowdsale
675     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
676     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
677 
678     /**
679      *  Modifiers
680      */
681     modifier minInvestment() {
682         // User has to send at least the ether value of one token.
683         assert(msg.value >= MIN_INVESTMENT);
684         _;
685     }
686 
687     modifier whenNotStarted() {
688         assert(startDate == 0);
689         _;
690     }
691 
692     modifier whenEnded() {
693         assert(isEnded());
694         _;
695     }
696 
697     modifier hasBalance() {
698         assert(this.balance > 0);
699         _;
700     }
701     modifier rateIsSet(uint256 _rate) {
702         assert(_rate != 0);
703         _;
704     }
705 
706     modifier whenNotEnded() {
707         assert(!isEnded());
708         _;
709     }
710 
711     modifier tokensNotDelivered() {
712         assert(numOfDeliveredCrowdsalePurchases == 0);
713         assert(numOfDeliveredEarlyPurchases == 0);
714         _;
715     }
716 
717     modifier onlyFundraiser() {
718         assert(address(starbaseToken) != 0);
719         assert(starbaseToken.isFundraiser(msg.sender));
720         _;
721     }
722 
723     modifier onlyQualifiedPartner() {
724         assert(qualifiedPartners[msg.sender].bonaFide);
725         _;
726     }
727 
728     modifier onlyQualifiedPartnerORPicopsCertified() {
729         assert(qualifiedPartners[msg.sender].bonaFide || picopsCertifier.certified(msg.sender));
730         _;
731     }
732 
733     /**
734      * Contract functions
735      */
736     /**
737      * @dev Contract constructor function sets owner address and
738      *      address of StarbaseEarlyPurchaseAmendment contract.
739      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
740      * @param picopsCertifierAddr The address of the PICOPS certifier.
741      *                            See also https://picops.parity.io/#/details
742      */
743     function StarbaseCrowdsale(address starbaseEpAddr, address picopsCertifierAddr) {
744         require(starbaseEpAddr != 0 && picopsCertifierAddr != 0);
745         owner = msg.sender;
746         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
747         picopsCertifier = Certifier(picopsCertifierAddr);
748     }
749 
750     /**
751      * @dev Fallback accepts payment for Star tokens with Eth
752      */
753     function() payable {
754         redirectToPurchase();
755     }
756 
757     /**
758      * External functions
759      */
760 
761     /**
762      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
763      * @param starbaseTokenAddress Token address.
764      * @param _purchaseStartBlock Block number to start crowdsale
765      */
766     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
767         external
768         onlyOwner
769         returns (bool)
770     {
771         require(starbaseTokenAddress != address(0));
772         require(address(starbaseToken) == 0);
773         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
774         purchaseStartBlock = _purchaseStartBlock;
775 
776         // set the max cap of this crowdsale
777         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesWithoutBonus());
778 
779         assert(maxCrowdsaleCap > 0);
780 
781         return true;
782     }
783 
784     /**
785      * @dev Transfers raised funds to company's wallet address at any given time.
786      */
787     function withdrawForCompany()
788         external
789         onlyFundraiser
790         hasBalance
791     {
792         address company = starbaseToken.company();
793         require(company != address(0));
794         company.transfer(this.balance);
795     }
796 
797     /**
798      * @dev Update start block Number for the crowdsale
799      */
800     function updatePurchaseStartBlock(uint256 _purchaseStartBlock)
801         external
802         whenNotStarted
803         onlyFundraiser
804         returns (bool)
805     {
806         purchaseStartBlock = _purchaseStartBlock;
807         return true;
808     }
809 
810     /**
811      * @dev Update the CNY/ETH rate to record purchases in CNY
812      */
813     function updateCnyEthRate(uint256 rate)
814         external
815         onlyFundraiser
816         returns (bool)
817     {
818         cnyEthRate = rate;
819         CnyEthRateUpdated(cnyEthRate);
820         return true;
821     }
822 
823     /**
824      * @dev Update the CNY/BTC rate to record purchases in CNY
825      */
826     function updateCnyBtcRate(uint256 rate)
827         external
828         onlyFundraiser
829         returns (bool)
830     {
831         cnyBtcRate = rate;
832         CnyBtcRateUpdated(cnyBtcRate);
833         return true;
834     }
835 
836     /**
837      * @dev Allow for the possibility for contract owner to start crowdsale
838      */
839     function ownerStartsCrowdsale(uint256 timestamp)
840         external
841         whenNotStarted
842         onlyOwner
843     {
844         assert(block.number >= purchaseStartBlock);   // this should be after the crowdsale start block
845         startCrowdsale(timestamp);
846     }
847 
848     /**
849      * @dev Ends crowdsale
850      *      This may be executed by an owner if the raised funds did not reach the map cap
851      * @param timestamp Timestamp at the crowdsale ended
852      */
853     function endCrowdsale(uint256 timestamp)
854         external
855         onlyOwner
856     {
857         assert(timestamp > 0 && timestamp <= now);
858         assert(block.number >= purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
859         endedAt = timestamp;
860         CrowdsaleEnded(endedAt);
861     }
862 
863     /**
864      * @dev Ends crowdsale
865      *      This may be executed by purchaseWithEth when the raised funds reach the map cap
866      */
867     function endCrowdsale() internal {
868         assert(block.number >= purchaseStartBlock && endedAt == 0);
869         endedAt = now;
870         CrowdsaleEnded(endedAt);
871     }
872 
873     /**
874      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
875      */
876     function withdrawPurchasedTokens()
877         external
878         whenEnded
879         returns (bool)
880     {
881         assert(earlyPurchasesLoaded);
882         assert(address(starbaseToken) != 0);
883 
884         /*
885          * “Value” refers to the contribution of the User:
886          *  {crowdsale_purchaser_token_amount} =
887          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
888          *
889          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
890          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
891          * and total amount raised during the Contribution Period is 30’000’000, then he will get
892          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
893         */
894 
895         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
896             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
897             crowdsalePurchaseAmountBy[msg.sender] = 0;
898 
899             uint256 tokenCount =
900                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
901                 totalRaisedAmountInCny();
902 
903             numOfPurchasedTokensOnCsBy[msg.sender] =
904                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
905             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
906             numOfDeliveredCrowdsalePurchases++;
907         }
908 
909         /*
910          * “Value” refers to the contribution of the User:
911          * {earlypurchaser_token_amount} =
912          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
913          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
914          *
915          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
916          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
917          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
918          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
919          * 30’000’000 CNY + 6’000’000 CNY
920          */
921 
922         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
923             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
924             earlyPurchasedAmountBy[msg.sender] = 0;
925 
926             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases;
927 
928             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalRaisedAmountInCny();
929 
930             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
931 
932             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
933             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
934             numOfDeliveredEarlyPurchases++;
935         }
936 
937         return true;
938     }
939 
940     /**
941      * @dev Load early purchases from the contract keeps track of them
942      */
943     function loadEarlyPurchases() external onlyOwner returns (bool) {
944         if (earlyPurchasesLoaded) {
945             return false;    // all EPs have already been loaded
946         }
947 
948         uint256 numOfOrigEp = starbaseEpAmendment
949             .starbaseEarlyPurchase()
950             .numberOfEarlyPurchases();
951 
952         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
953             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
954                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
955                 continue;
956             }
957             var (purchaser, amount,) =
958                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
959                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
960                 : starbaseEpAmendment.earlyPurchases(i);
961             if (amount > 0) {
962                 if (earlyPurchasedAmountBy[purchaser] == 0) {
963                     earlyPurchasers.push(purchaser);
964                 }
965                 // each early purchaser receives 20% bonus
966                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
967                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
968 
969                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
970                 totalAmountOfEarlyPurchases = totalAmountOfEarlyPurchases.add(amountWithBonus);
971             }
972 
973             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
974         }
975 
976         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
977         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
978             earlyPurchasesLoaded = true;    // enable the flag
979         }
980         return true;
981     }
982 
983     /**
984      * @dev Load presale purchases from the contract keeps track of them
985      * @param starbaseCrowdsalePresale Starbase presale contract address
986      */
987     function loadPresalePurchases(address starbaseCrowdsalePresale)
988         external
989         onlyOwner
990         whenNotEnded
991     {
992         require(starbaseCrowdsalePresale != 0);
993         require(!presalePurchasesLoaded);
994         StarbaseCrowdsale presale = StarbaseCrowdsale(starbaseCrowdsalePresale);
995         for (uint i; i < presale.numOfPurchases(); i++) {
996             var (purchaser, amount, rawAmount, purchasedAt) =
997                 presale.crowdsalePurchases(i);  // presale purchase
998             crowdsalePurchases.push(CrowdsalePurchase(purchaser, amount, rawAmount, purchasedAt));
999 
1000             // Increase the sums
1001             crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1002             totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1003             totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1004         }
1005         presalePurchasesLoaded = true;
1006     }
1007 
1008     /**
1009       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
1010       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
1011       * @param _amountCap Ether value which partner is able to contribute
1012       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
1013       */
1014     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
1015         external
1016         onlyOwner
1017     {
1018         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
1019         qualifiedPartners[_qualifiedPartner].bonaFide = true;
1020         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1021         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
1022         QualifiedPartnerAddress(_qualifiedPartner);
1023     }
1024 
1025     /**
1026      * @dev Remove address from qualified partners list.
1027      * @param _qualifiedPartner Address to be removed from the list.
1028      */
1029     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
1030         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1031         qualifiedPartners[_qualifiedPartner].bonaFide = false;
1032     }
1033 
1034     /**
1035      * @dev Update whitelisted address amount allowed to raise during the presale.
1036      * @param _qualifiedPartner Qualified Partner address to be updated.
1037      * @param _amountCap Amount that the address is able to raise during the presale.
1038      */
1039     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
1040         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1041         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1042     }
1043 
1044     /**
1045      * Public functions
1046      */
1047 
1048     /**
1049      * @dev Returns boolean for whether crowdsale has ended
1050      */
1051     function isEnded() constant public returns (bool) {
1052         return (endedAt > 0 && endedAt <= now);
1053     }
1054 
1055     /**
1056      * @dev Returns number of purchases to date.
1057      */
1058     function numOfPurchases() constant public returns (uint256) {
1059         return crowdsalePurchases.length;
1060     }
1061 
1062     /**
1063      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1064      */
1065     function totalRaisedAmountInCny() constant public returns (uint256) {
1066         return totalAmountOfEarlyPurchases.add(totalAmountOfCrowdsalePurchases);
1067     }
1068 
1069     /**
1070      * @dev Returns total amount of early purchases in CNY and bonuses
1071      */
1072     function totalAmountOfEarlyPurchasesWithBonus() constant public returns(uint256) {
1073        return starbaseEpAmendment.totalAmountOfEarlyPurchases().mul(120).div(100);
1074     }
1075 
1076     /**
1077      * @dev Returns total amount of early purchases in CNY
1078      */
1079     function totalAmountOfEarlyPurchasesWithoutBonus() constant public returns(uint256) {
1080        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1081     }
1082 
1083     /**
1084      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1085      */
1086     function purchaseAsQualifiedPartner()
1087         payable
1088         public
1089         rateIsSet(cnyEthRate)
1090         onlyQualifiedPartner
1091         returns (bool)
1092     {
1093         require(msg.value > 0);
1094         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1095 
1096         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1097 
1098         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1099         recordPurchase(msg.sender, rawAmount, now);
1100 
1101         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1102             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1103         }
1104 
1105         return true;
1106     }
1107 
1108     /**
1109      * @dev Allows user to purchase STAR tokens with Ether
1110      */
1111     function purchaseWithEth()
1112         payable
1113         public
1114         minInvestment
1115         whenNotEnded
1116         rateIsSet(cnyEthRate)
1117         onlyQualifiedPartnerORPicopsCertified
1118         returns (bool)
1119     {
1120         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1121 
1122         if (startDate == 0) {
1123             startCrowdsale(block.timestamp);
1124         }
1125 
1126         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1127         recordPurchase(msg.sender, rawAmount, now);
1128 
1129         if (totalAmountOfCrowdsalePurchasesWithoutBonus >= maxCrowdsaleCap) {
1130             endCrowdsale(); // ends this crowdsale automatically
1131         }
1132 
1133         return true;
1134     }
1135 
1136     /**
1137      * Internal functions
1138      */
1139 
1140     /**
1141      * @dev Initializes Starbase crowdsale
1142      */
1143     function startCrowdsale(uint256 timestamp) internal {
1144         startDate = timestamp;
1145         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus;
1146         if (maxCrowdsaleCap > presaleAmount) {
1147             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1148             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1149 
1150             // set token bonus milestones in cny total crowdsale purchase
1151             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1152             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1153             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1154             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Abstract record of a purchase to Tokens
1160      * @param purchaser Address of the buyer
1161      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1162      * @param timestamp Timestamp at the purchase made
1163      */
1164     function recordPurchase(
1165         address purchaser,
1166         uint256 rawAmount,
1167         uint256 timestamp
1168     )
1169         internal
1170         returns(uint256 amount)
1171     {
1172         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1173 
1174         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1175         if (block.number >= purchaseStartBlock) {
1176             require(totalAmountOfCrowdsalePurchasesWithoutBonus < maxCrowdsaleCap);   // check if the amount has already reached the cap
1177 
1178             uint256 crowdsaleTotalAmountAfterPurchase =
1179                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus, amount);
1180 
1181             // check whether purchase goes over the cap and send the difference back to the purchaser.
1182             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1183               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1184               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1185               purchaser.transfer(ethValueToReturn);
1186               amount = SafeMath.sub(amount, difference);
1187               rawAmount = amount;
1188             }
1189         }
1190 
1191         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1192 
1193         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1194         crowdsalePurchases.push(purchase);
1195         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1196         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1197         totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1198         totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1199         return amount;
1200     }
1201 
1202     /**
1203      * @dev Calculates amount with bonus for bonus milestones
1204      */
1205     function calculateBonus
1206         (
1207             BonusMilestones nextMilestone,
1208             uint256 amount,
1209             uint256 bonusRange,
1210             uint256 bonusTier,
1211             uint256 results
1212         )
1213         internal
1214         returns (uint256 result, uint256 newAmount)
1215     {
1216         uint256 bonusCalc;
1217 
1218         if (amount <= bonusRange) {
1219             bonusCalc = amount.mul(bonusTier).div(100);
1220 
1221             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus) >= bonusRange)
1222                 bonusMilestones = nextMilestone;
1223 
1224             result = results.add(amount).add(bonusCalc);
1225             newAmount = 0;
1226 
1227         } else {
1228             bonusCalc = bonusRange.mul(bonusTier).div(100);
1229             bonusMilestones = nextMilestone;
1230             result = results.add(bonusRange).add(bonusCalc);
1231             newAmount = amount.sub(bonusRange);
1232         }
1233     }
1234 
1235     /**
1236      * @dev Fetchs Bonus tier percentage per bonus milestones
1237      */
1238     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1239         if (block.number < purchaseStartBlock) {
1240             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1241             return amount.add(bonusFromAmount);
1242         }
1243 
1244         // range of each bonus milestones
1245         uint256 firstBonusRange = firstBonusEnds;
1246         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1247         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1248         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1249         uint256 result;
1250 
1251         if (bonusMilestones == BonusMilestones.First)
1252             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1253 
1254         if (bonusMilestones == BonusMilestones.Second)
1255             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1256 
1257         if (bonusMilestones == BonusMilestones.Third)
1258             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1259 
1260         if (bonusMilestones == BonusMilestones.Fourth)
1261             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1262 
1263         return result.add(amount);
1264     }
1265 
1266     /**
1267      * @dev Fetchs Bonus tier percentage per bonus milestones
1268      * @dev qualifiedPartner Address of partners that participated in pre sale
1269      * @dev amountSent Value sent by qualified partner
1270      */
1271     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1272         //calculate the commission fee to send to qualified partner
1273         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1274 
1275         // send commission fee amount
1276         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1277     }
1278 
1279     /**
1280      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1281      */
1282     function redirectToPurchase() internal {
1283         if (block.number < purchaseStartBlock) {
1284             purchaseAsQualifiedPartner();
1285         } else {
1286             purchaseWithEth();
1287         }
1288     }
1289 }
1290 
1291 /**
1292  * @title Starbase Crowdsale Contract Withdrawal contract - Provides an function
1293           to withdraw STAR token according to crowdsale results
1294  * @author Starbase PTE. LTD. - <info@starbase.co>
1295  */
1296 contract StarbaseCrowdsaleContractW is Ownable {
1297     using SafeMath for uint256;
1298 
1299     /*
1300      *  Events
1301      */
1302     event TokenWithdrawn(address purchaser, uint256 tokenCount);
1303     event CrowdsalePurchaseBonusLog(
1304         uint256 purchaseIdx, uint256 rawAmount, uint256 bonus);
1305 
1306     /**
1307      *  External contracts
1308      */
1309     AbstractStarbaseToken public starbaseToken;
1310     StarbaseCrowdsale public starbaseCrowdsale;
1311     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
1312 
1313     /**
1314      *  Constants
1315      */
1316     uint256 constant public crowdsaleTokenAmount = 125000000e18;
1317     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
1318 
1319     /**
1320      *  Storage
1321      */
1322 
1323     // early purchase
1324     address[] public earlyPurchasers;
1325     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
1326     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
1327     uint256 public totalAmountOfEarlyPurchases; // including bonus
1328     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
1329     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
1330 
1331     // crowdsale
1332     uint256 public totalAmountOfCrowdsalePurchases; // in CNY, including bonuses
1333     uint256 public totalAmountOfCrowdsalePurchasesWithoutBonus; // in CNY
1334     uint256 public startDate;
1335     uint256 public endedAt;
1336     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
1337     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
1338 
1339     // crowdsale contract withdrawal
1340     bool public crowdsalePurchasesLoaded = false;   // returns whether all crowdsale purchases are loaded into this contract
1341     uint256 public numOfLoadedCrowdsalePurchases; // index to keep the number of crowdsale purchases that have already been loaded by `loadCrowdsalePurchases`
1342     uint256 public totalAmountOfPresalePurchasesWithoutBonus;  // in CNY
1343 
1344     // after the crowdsale
1345     mapping (address => bool) public tokenWithdrawn;    // returns whether purchased tokens were withdrawn by a purchaser
1346     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
1347     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
1348 
1349     /**
1350      *  Modifiers
1351      */
1352     modifier whenEnded() {
1353         assert(isEnded());
1354         _;
1355     }
1356 
1357     /**
1358      * Contract functions
1359      */
1360 
1361     /**
1362      * @dev Reject all incoming Ether transfers
1363      */
1364     function () { revert(); }
1365 
1366     /**
1367      * External functions
1368      */
1369 
1370     /**
1371      * @dev Setup function sets external contracts' address
1372      * @param starbaseTokenAddress Token address.
1373      * @param StarbaseCrowdsaleAddress Token address.
1374      */
1375     function setup(address starbaseTokenAddress, address StarbaseCrowdsaleAddress)
1376         external
1377         onlyOwner
1378     {
1379         require(starbaseTokenAddress != address(0) && StarbaseCrowdsaleAddress != address(0));
1380         require(address(starbaseToken) == 0 && address(starbaseCrowdsale) == 0);
1381 
1382         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
1383         starbaseCrowdsale = StarbaseCrowdsale(StarbaseCrowdsaleAddress);
1384         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseCrowdsale.starbaseEpAmendment());
1385 
1386         require(starbaseCrowdsale.startDate() > 0);
1387         startDate = starbaseCrowdsale.startDate();
1388 
1389         require(starbaseCrowdsale.endedAt() > 0);
1390         endedAt = starbaseCrowdsale.endedAt();
1391     }
1392 
1393     /**
1394      * @dev Load crowdsale purchases from the contract keeps track of them
1395      * @param numOfPresalePurchases Number of presale purchase
1396      */
1397     function loadCrowdsalePurchases(uint256 numOfPresalePurchases)
1398         external
1399         onlyOwner
1400         whenEnded
1401     {
1402         require(!crowdsalePurchasesLoaded);
1403 
1404         uint256 numOfPurchases = starbaseCrowdsale.numOfPurchases();
1405 
1406         for (uint256 i = numOfLoadedCrowdsalePurchases; i < numOfPurchases && msg.gas > 200000; i++) {
1407             var (purchaser, amount, rawAmount,) =
1408                 starbaseCrowdsale.crowdsalePurchases(i);
1409 
1410             uint256 bonus;
1411             if (i < numOfPresalePurchases) {
1412                 bonus = rawAmount * 30 / 100;   // presale: 30% bonus
1413                 totalAmountOfPresalePurchasesWithoutBonus =
1414                     totalAmountOfPresalePurchasesWithoutBonus.add(rawAmount);
1415             } else {
1416                 bonus = calculateBonus(rawAmount); // mainsale: 20% ~ 0% bonus
1417             }
1418 
1419             // Update amount with bonus
1420             CrowdsalePurchaseBonusLog(i, rawAmount, bonus);
1421             amount = rawAmount + bonus;
1422 
1423             // Increase the sums
1424             crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1425             totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1426             totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1427 
1428             numOfLoadedCrowdsalePurchases++;    // Increase the index
1429         }
1430 
1431         assert(numOfLoadedCrowdsalePurchases <= numOfPurchases);
1432         if (numOfLoadedCrowdsalePurchases == numOfPurchases) {
1433             crowdsalePurchasesLoaded = true;    // enable the flag
1434         }
1435     }
1436 
1437     /**
1438      * @dev Add early purchases
1439      */
1440     function addEarlyPurchases() external onlyOwner returns (bool) {
1441         if (earlyPurchasesLoaded) {
1442             return false;    // all EPs have already been loaded
1443         }
1444 
1445         uint256 numOfOrigEp = starbaseEpAmendment
1446             .starbaseEarlyPurchase()
1447             .numberOfEarlyPurchases();
1448 
1449         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
1450             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
1451                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
1452                 continue;
1453             }
1454             var (purchaser, amount,) =
1455                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
1456                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
1457                 : starbaseEpAmendment.earlyPurchases(i);
1458             if (amount > 0) {
1459                 if (earlyPurchasedAmountBy[purchaser] == 0) {
1460                     earlyPurchasers.push(purchaser);
1461                 }
1462                 // each early purchaser receives 10% bonus
1463                 uint256 bonus = SafeMath.mul(amount, 10) / 100;
1464                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
1465 
1466                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
1467                 totalAmountOfEarlyPurchases = totalAmountOfEarlyPurchases.add(amountWithBonus);
1468             }
1469 
1470             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
1471         }
1472 
1473         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
1474         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
1475             earlyPurchasesLoaded = true;    // enable the flag
1476         }
1477 
1478         return true;
1479     }
1480 
1481     /**
1482      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
1483      */
1484     function withdrawPurchasedTokens()
1485         external
1486         whenEnded
1487     {
1488         require(crowdsalePurchasesLoaded);
1489         assert(earlyPurchasesLoaded);
1490         assert(address(starbaseToken) != 0);
1491 
1492         // prevent double withdrawal
1493         require(!tokenWithdrawn[msg.sender]);
1494         tokenWithdrawn[msg.sender] = true;
1495 
1496         /*
1497          * “Value” refers to the contribution of the User:
1498          *  {crowdsale_purchaser_token_amount} =
1499          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
1500          *
1501          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
1502          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
1503          * and total amount raised during the Contribution Period is 30’000’000, then he will get
1504          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
1505         */
1506 
1507         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
1508             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
1509             uint256 tokenCount =
1510                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
1511                 totalRaisedAmountInCny();
1512 
1513             numOfPurchasedTokensOnCsBy[msg.sender] =
1514                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
1515             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
1516             numOfDeliveredCrowdsalePurchases++;
1517             TokenWithdrawn(msg.sender, tokenCount);
1518         }
1519 
1520         /*
1521          * “Value” refers to the contribution of the User:
1522          * {earlypurchaser_token_amount} =
1523          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
1524          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
1525          *
1526          * Example: If an Early Purchaser contributes 100 CNY (including Bonus) and the
1527          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
1528          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
1529          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
1530          * 30’000’000 CNY + 6’000’000 CNY
1531          */
1532 
1533         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
1534             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
1535             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases;
1536             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalRaisedAmountInCny();
1537             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
1538 
1539             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
1540             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
1541             numOfDeliveredEarlyPurchases++;
1542             TokenWithdrawn(msg.sender, epTokenCount);
1543         }
1544     }
1545 
1546     /**
1547      * Public functions
1548      */
1549 
1550     /**
1551      * @dev Returns boolean for whether crowdsale has ended
1552      */
1553     function isEnded() constant public returns (bool) {
1554         return (starbaseCrowdsale != address(0) && endedAt > 0);
1555     }
1556 
1557     /**
1558      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1559      */
1560     function totalRaisedAmountInCny() constant public returns (uint256) {
1561         return totalAmountOfEarlyPurchases.add(totalAmountOfCrowdsalePurchases);
1562     }
1563 
1564     /**
1565      * Internal functions
1566      */
1567 
1568     /**
1569      * @dev Calculates bonus of a purchase
1570      */
1571     function calculateBonus(uint256 rawAmount)
1572         internal
1573         returns (uint256 bonus)
1574     {
1575         uint256 purchasedAmount =
1576             totalAmountOfCrowdsalePurchasesWithoutBonus
1577                 .sub(totalAmountOfPresalePurchasesWithoutBonus);
1578         uint256 e1 = starbaseCrowdsale.firstBonusEnds();
1579         uint256 e2 = starbaseCrowdsale.secondBonusEnds();
1580         uint256 e3 = starbaseCrowdsale.thirdBonusEnds();
1581         uint256 e4 = starbaseCrowdsale.fourthBonusEnds();
1582         return calculateBonusInRange(purchasedAmount, rawAmount, 0, e1, 20)
1583             .add(calculateBonusInRange(purchasedAmount, rawAmount, e1, e2, 15))
1584             .add(calculateBonusInRange(purchasedAmount, rawAmount, e2, e3, 10))
1585             .add(calculateBonusInRange(purchasedAmount, rawAmount, e3, e4, 5));
1586     }
1587 
1588     function calculateBonusInRange(
1589         uint256 purchasedAmount,
1590         uint256 rawAmount,
1591         uint256 bonusBegin,
1592         uint256 bonusEnd,
1593         uint256 bonusTier
1594     )
1595         public
1596         constant
1597         returns (uint256 bonus)
1598     {
1599         uint256 sum = purchasedAmount + rawAmount;
1600         if (purchasedAmount > bonusEnd || sum < bonusBegin) {
1601             return 0;   // out of this range
1602         }
1603 
1604         uint256 min = purchasedAmount <= bonusBegin ? bonusBegin : purchasedAmount;
1605         uint256 max = bonusEnd <= sum ? bonusEnd : sum;
1606         return max.sub(min) * bonusTier / 100;
1607     }
1608 }