1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() {
40     owner = msg.sender;
41   }
42 
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) onlyOwner public {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 
65 contract AbstractStarbaseCrowdsale {
66     function startDate() constant returns (uint256) {}
67     function endedAt() constant returns (uint256) {}
68     function isEnded() constant returns (bool);
69     function totalRaisedAmountInCny() constant returns (uint256);
70     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
71     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
72 }
73 
74 
75 contract AbstractStarbaseToken {
76     function isFundraiser(address fundraiserAddress) public returns (bool);
77     function company() public returns (address);
78     function allocateToCrowdsalePurchaser(address to, uint256 value) public returns (bool);
79     function allocateToMarketingSupporter(address to, uint256 value) public returns (bool);
80 }
81 
82 
83 contract StarbaseEarlyPurchase {
84     /*
85      *  Constants
86      */
87     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
88     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
89     uint256 public constant PURCHASE_AMOUNT_CAP = 9000000;
90 
91     /*
92      *  Types
93      */
94     struct EarlyPurchase {
95         address purchaser;
96         uint256 amount;        // CNY based amount
97         uint256 purchasedAt;   // timestamp
98     }
99 
100     /*
101      *  External contracts
102      */
103     AbstractStarbaseCrowdsale public starbaseCrowdsale;
104 
105     /*
106      *  Storage
107      */
108     address public owner;
109     EarlyPurchase[] public earlyPurchases;
110     uint256 public earlyPurchaseClosedAt;
111 
112     /*
113      *  Modifiers
114      */
115     modifier noEther() {
116         require(msg.value == 0);
117         _;
118     }
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     modifier onlyBeforeCrowdsale() {
126         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
127         _;
128     }
129 
130     modifier onlyEarlyPurchaseTerm() {
131         assert(earlyPurchaseClosedAt <= 0);
132         _;
133     }
134 
135     /*
136      *  Contract functions
137      */
138 
139     /**
140      * @dev Returns early purchased amount by purchaser's address
141      * @param purchaser Purchaser address
142      */
143     function purchasedAmountBy(address purchaser)
144         external
145         constant
146         noEther
147         returns (uint256 amount)
148     {
149         for (uint256 i; i < earlyPurchases.length; i++) {
150             if (earlyPurchases[i].purchaser == purchaser) {
151                 amount += earlyPurchases[i].amount;
152             }
153         }
154     }
155 
156     /**
157      * @dev Returns total amount of raised funds by Early Purchasers
158      */
159     function totalAmountOfEarlyPurchases()
160         constant
161         noEther
162         public
163         returns (uint256 totalAmount)
164     {
165         for (uint256 i; i < earlyPurchases.length; i++) {
166             totalAmount += earlyPurchases[i].amount;
167         }
168     }
169 
170     /**
171      * @dev Returns number of early purchases
172      */
173     function numberOfEarlyPurchases()
174         external
175         constant
176         noEther
177         returns (uint256)
178     {
179         return earlyPurchases.length;
180     }
181 
182     /**
183      * @dev Append an early purchase log
184      * @param purchaser Purchaser address
185      * @param amount Purchase amount
186      * @param purchasedAt Timestamp of purchased date
187      */
188     function appendEarlyPurchase(address purchaser, uint256 amount, uint256 purchasedAt)
189         external
190         noEther
191         onlyOwner
192         onlyBeforeCrowdsale
193         onlyEarlyPurchaseTerm
194         returns (bool)
195     {
196         if (amount == 0 ||
197             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
198         {
199             return false;
200         }
201 
202         assert(purchasedAt != 0 || purchasedAt <= now);
203 
204         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
205         return true;
206     }
207 
208     /**
209      * @dev Close early purchase term
210      */
211     function closeEarlyPurchase()
212         external
213         noEther
214         onlyOwner
215         returns (bool)
216     {
217         earlyPurchaseClosedAt = now;
218     }
219 
220     /**
221      * @dev Setup function sets external contract's address
222      * @param starbaseCrowdsaleAddress Token address
223      */
224     function setup(address starbaseCrowdsaleAddress)
225         external
226         noEther
227         onlyOwner
228         returns (bool)
229     {
230         if (address(starbaseCrowdsale) == 0) {
231             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
232             return true;
233         }
234         return false;
235     }
236 
237     /**
238      * @dev Contract constructor function
239      */
240     function StarbaseEarlyPurchase() noEther {
241         owner = msg.sender;
242     }
243 }
244 
245 
246 contract StarbaseEarlyPurchaseAmendment {
247     /*
248      *  Events
249      */
250     event EarlyPurchaseInvalidated(uint256 epIdx);
251     event EarlyPurchaseAmended(uint256 epIdx);
252 
253     /*
254      *  External contracts
255      */
256     AbstractStarbaseCrowdsale public starbaseCrowdsale;
257     StarbaseEarlyPurchase public starbaseEarlyPurchase;
258 
259     /*
260      *  Storage
261      */
262     address public owner;
263     uint256[] public invalidEarlyPurchaseIndexes;
264     uint256[] public amendedEarlyPurchaseIndexes;
265     mapping (uint256 => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
266 
267     /*
268      *  Modifiers
269      */
270     modifier noEther() {
271         require(msg.value == 0);
272         _;
273     }
274 
275     modifier onlyOwner() {
276         require(msg.sender == owner);
277         _;
278     }
279 
280     modifier onlyBeforeCrowdsale() {
281         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
282         _;
283     }
284 
285     modifier onlyEarlyPurchasesLoaded() {
286         assert(address(starbaseEarlyPurchase) != address(0));
287         _;
288     }
289 
290     /*
291      *  Functions below are compatible with starbaseEarlyPurchase contract
292      */
293 
294     /**
295      * @dev Returns an early purchase record
296      * @param earlyPurchaseIndex Index number of an early purchase
297      */
298     function earlyPurchases(uint256 earlyPurchaseIndex)
299         external
300         constant
301         onlyEarlyPurchasesLoaded
302         returns (address purchaser, uint256 amount, uint256 purchasedAt)
303     {
304         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
305     }
306 
307     /**
308      * @dev Returns early purchased amount by purchaser's address
309      * @param purchaser Purchaser address
310      */
311     function purchasedAmountBy(address purchaser)
312         external
313         constant
314         noEther
315         returns (uint256 amount)
316     {
317         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
318             normalizedEarlyPurchases();
319         for (uint256 i; i < normalizedEP.length; i++) {
320             if (normalizedEP[i].purchaser == purchaser) {
321                 amount += normalizedEP[i].amount;
322             }
323         }
324     }
325 
326     /**
327      * @dev Returns total amount of raised funds by Early Purchasers
328      */
329     function totalAmountOfEarlyPurchases()
330         constant
331         noEther
332         public
333         returns (uint256 totalAmount)
334     {
335         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
336             normalizedEarlyPurchases();
337         for (uint256 i; i < normalizedEP.length; i++) {
338             totalAmount += normalizedEP[i].amount;
339         }
340     }
341 
342     /**
343      * @dev Returns number of early purchases
344      */
345     function numberOfEarlyPurchases()
346         external
347         constant
348         noEther
349         returns (uint256)
350     {
351         return normalizedEarlyPurchases().length;
352     }
353 
354     /**
355      * @dev Sets up function sets external contract's address
356      * @param starbaseCrowdsaleAddress Token address
357      */
358     function setup(address starbaseCrowdsaleAddress)
359         external
360         noEther
361         onlyOwner
362         returns (bool)
363     {
364         if (address(starbaseCrowdsale) == 0) {
365             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
366             return true;
367         }
368         return false;
369     }
370 
371     /*
372      *  Contract functions unique to StarbaseEarlyPurchaseAmendment
373      */
374 
375      /**
376       * @dev Invalidate early purchase
377       * @param earlyPurchaseIndex Index number of the purchase
378       */
379     function invalidateEarlyPurchase(uint256 earlyPurchaseIndex)
380         external
381         noEther
382         onlyOwner
383         onlyEarlyPurchasesLoaded
384         onlyBeforeCrowdsale
385         returns (bool)
386     {
387         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
388 
389         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
390             assert(invalidEarlyPurchaseIndexes[i] != earlyPurchaseIndex);
391         }
392 
393         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
394         EarlyPurchaseInvalidated(earlyPurchaseIndex);
395         return true;
396     }
397 
398     /**
399      * @dev Checks whether early purchase is invalid
400      * @param earlyPurchaseIndex Index number of the purchase
401      */
402     function isInvalidEarlyPurchase(uint256 earlyPurchaseIndex)
403         constant
404         noEther
405         public
406         returns (bool)
407     {
408         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
409 
410 
411         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
412             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
413                 return true;
414             }
415         }
416         return false;
417     }
418 
419     /**
420      * @dev Amends a given early purchase with data
421      * @param earlyPurchaseIndex Index number of the purchase
422      * @param purchaser Purchaser's address
423      * @param amount Value of purchase
424      * @param purchasedAt Purchase timestamp
425      */
426     function amendEarlyPurchase(uint256 earlyPurchaseIndex, address purchaser, uint256 amount, uint256 purchasedAt)
427         external
428         noEther
429         onlyOwner
430         onlyEarlyPurchasesLoaded
431         onlyBeforeCrowdsale
432         returns (bool)
433     {
434         assert(purchasedAt != 0 || purchasedAt <= now);
435 
436         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex);
437 
438         assert(!isInvalidEarlyPurchase(earlyPurchaseIndex)); // Invalid early purchase cannot be amended
439 
440         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
441             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
442         }
443 
444         amendedEarlyPurchases[earlyPurchaseIndex] =
445             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
446         EarlyPurchaseAmended(earlyPurchaseIndex);
447         return true;
448     }
449 
450     /**
451      * @dev Checks whether early purchase is amended
452      * @param earlyPurchaseIndex Index number of the purchase
453      */
454     function isAmendedEarlyPurchase(uint256 earlyPurchaseIndex)
455         constant
456         noEther
457         returns (bool)
458     {
459         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
460 
461         for (uint256 i; i < amendedEarlyPurchaseIndexes.length; i++) {
462             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
463                 return true;
464             }
465         }
466         return false;
467     }
468 
469     /**
470      * @dev Loads early purchases data to StarbaseEarlyPurchaseAmendment contract
471      * @param starbaseEarlyPurchaseAddress Address from starbase early purchase
472      */
473     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
474         external
475         noEther
476         onlyOwner
477         onlyBeforeCrowdsale
478         returns (bool)
479     {
480         assert(starbaseEarlyPurchaseAddress != 0 ||
481             address(starbaseEarlyPurchase) == 0);
482 
483         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
484         assert(starbaseEarlyPurchase.earlyPurchaseClosedAt() != 0); // the early purchase must be closed
485 
486         return true;
487     }
488 
489     /**
490      * @dev Contract constructor function. It sets owner
491      */
492     function StarbaseEarlyPurchaseAmendment() noEther {
493         owner = msg.sender;
494     }
495 
496     /**
497      * Internal functions
498      */
499 
500     /**
501      * @dev Normalizes early purchases data
502      */
503     function normalizedEarlyPurchases()
504         constant
505         internal
506         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
507     {
508         uint256 rawEPCount = numberOfRawEarlyPurchases();
509         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
510             rawEPCount - invalidEarlyPurchaseIndexes.length);
511 
512         uint256 normalizedIdx;
513         for (uint256 i; i < rawEPCount; i++) {
514             if (isInvalidEarlyPurchase(i)) {
515                 continue;   // invalid early purchase should be ignored
516             }
517 
518             StarbaseEarlyPurchase.EarlyPurchase memory ep;
519             if (isAmendedEarlyPurchase(i)) {
520                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
521             } else {
522                 ep = getEarlyPurchase(i);
523             }
524 
525             normalizedEP[normalizedIdx] = ep;
526             normalizedIdx++;
527         }
528     }
529 
530     /**
531      * @dev Fetches early purchases data
532      */
533     function getEarlyPurchase(uint256 earlyPurchaseIndex)
534         internal
535         constant
536         onlyEarlyPurchasesLoaded
537         returns (StarbaseEarlyPurchase.EarlyPurchase)
538     {
539         var (purchaser, amount, purchasedAt) =
540             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
541         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
542     }
543 
544     /**
545      * @dev Returns raw number of early purchases
546      */
547     function numberOfRawEarlyPurchases()
548         internal
549         constant
550         onlyEarlyPurchasesLoaded
551         returns (uint256)
552     {
553         return starbaseEarlyPurchase.numberOfEarlyPurchases();
554     }
555 }
556 
557 
558 contract Certifier {
559 	event Confirmed(address indexed who);
560 	event Revoked(address indexed who);
561 	function certified(address) public constant returns (bool);
562 	function get(address, string) public constant returns (bytes32);
563 	function getAddress(address, string) public constant returns (address);
564 	function getUint(address, string) public constant returns (uint);
565 }
566 
567 
568 /**
569  * @title Crowdsale contract - Starbase crowdsale to create STAR.
570  * @author Starbase PTE. LTD. - <info@starbase.co>
571  */
572 contract StarbaseCrowdsale is Ownable {
573     using SafeMath for uint256;
574     /*
575      *  Events
576      */
577     event CrowdsaleEnded(uint256 endedAt);
578     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate);
579     event CnyEthRateUpdated(uint256 cnyEthRate);
580     event CnyBtcRateUpdated(uint256 cnyBtcRate);
581     event QualifiedPartnerAddress(address qualifiedPartner);
582 
583     /**
584      *  External contracts
585      */
586     AbstractStarbaseToken public starbaseToken;
587     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
588     Certifier public picopsCertifier;
589 
590     /**
591      *  Constants
592      */
593     uint256 constant public crowdsaleTokenAmount = 125000000e18;
594     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
595     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
596     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
597     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
598 
599     /**
600      * Types
601      */
602     struct CrowdsalePurchase {
603         address purchaser;
604         uint256 amount;        // CNY based amount with bonus
605         uint256 rawAmount;     // CNY based amount no bonus
606         uint256 purchasedAt;   // timestamp
607     }
608 
609     struct QualifiedPartners {
610         uint256 amountCap;
611         uint256 amountRaised;
612         bool    bonaFide;
613         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
614     }
615 
616     /*
617      *  Enums
618      */
619     enum BonusMilestones {
620         First,
621         Second,
622         Third,
623         Fourth,
624         Fifth
625     }
626 
627     // Initialize bonusMilestones
628     BonusMilestones public bonusMilestones = BonusMilestones.First;
629 
630     /**
631      *  Storage
632      */
633     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
634     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
635     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
636 
637     // early purchase
638     address[] public earlyPurchasers;
639     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
640     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
641     uint256 public totalAmountOfEarlyPurchases; // including 20% bonus
642 
643     // crowdsale
644     bool public presalePurchasesLoaded = false; // returns whether all presale purchases are loaded into this contract
645     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
646     uint256 public totalAmountOfCrowdsalePurchases; // in CNY, including bonuses
647     uint256 public totalAmountOfCrowdsalePurchasesWithoutBonus; // in CNY
648     mapping (address => QualifiedPartners) public qualifiedPartners;
649     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
650     uint256 public startDate;
651     uint256 public endedAt;
652     CrowdsalePurchase[] public crowdsalePurchases;
653     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
654     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
655     uint256 public cnyEthRate;
656 
657     // bonus milestones
658     uint256 public firstBonusEnds;
659     uint256 public secondBonusEnds;
660     uint256 public thirdBonusEnds;
661     uint256 public fourthBonusEnds;
662 
663     // after the crowdsale
664     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
665     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
666 
667     /**
668      *  Modifiers
669      */
670     modifier minInvestment() {
671         // User has to send at least the ether value of one token.
672         assert(msg.value >= MIN_INVESTMENT);
673         _;
674     }
675 
676     modifier whenNotStarted() {
677         assert(startDate == 0);
678         _;
679     }
680 
681     modifier whenEnded() {
682         assert(isEnded());
683         _;
684     }
685 
686     modifier hasBalance() {
687         assert(this.balance > 0);
688         _;
689     }
690     modifier rateIsSet(uint256 _rate) {
691         assert(_rate != 0);
692         _;
693     }
694 
695     modifier whenNotEnded() {
696         assert(!isEnded());
697         _;
698     }
699 
700     modifier tokensNotDelivered() {
701         assert(numOfDeliveredCrowdsalePurchases == 0);
702         assert(numOfDeliveredEarlyPurchases == 0);
703         _;
704     }
705 
706     modifier onlyFundraiser() {
707         assert(address(starbaseToken) != 0);
708         assert(starbaseToken.isFundraiser(msg.sender));
709         _;
710     }
711 
712     modifier onlyQualifiedPartner() {
713         assert(qualifiedPartners[msg.sender].bonaFide);
714         _;
715     }
716 
717     modifier onlyQualifiedPartnerORPicopsCertified() {
718         assert(qualifiedPartners[msg.sender].bonaFide || picopsCertifier.certified(msg.sender));
719         _;
720     }
721 
722     /**
723      * Contract functions
724      */
725     /**
726      * @dev Contract constructor function sets owner address and
727      *      address of StarbaseEarlyPurchaseAmendment contract.
728      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
729      * @param picopsCertifierAddr The address of the PICOPS certifier.
730      *                            See also https://picops.parity.io/#/details
731      */
732     function StarbaseCrowdsale(address starbaseEpAddr, address picopsCertifierAddr) {
733         require(starbaseEpAddr != 0 && picopsCertifierAddr != 0);
734         owner = msg.sender;
735         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
736         picopsCertifier = Certifier(picopsCertifierAddr);
737     }
738 
739     /**
740      * @dev Fallback accepts payment for Star tokens with Eth
741      */
742     function() payable {
743         redirectToPurchase();
744     }
745 
746     /**
747      * External functions
748      */
749 
750     /**
751      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
752      * @param starbaseTokenAddress Token address.
753      * @param _purchaseStartBlock Block number to start crowdsale
754      */
755     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
756         external
757         onlyOwner
758         returns (bool)
759     {
760         require(starbaseTokenAddress != address(0));
761         require(address(starbaseToken) == 0);
762         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
763         purchaseStartBlock = _purchaseStartBlock;
764 
765         // set the max cap of this crowdsale
766         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesWithoutBonus());
767 
768         assert(maxCrowdsaleCap > 0);
769 
770         return true;
771     }
772 
773     /**
774      * @dev Transfers raised funds to company's wallet address at any given time.
775      */
776     function withdrawForCompany()
777         external
778         onlyFundraiser
779         hasBalance
780     {
781         address company = starbaseToken.company();
782         require(company != address(0));
783         company.transfer(this.balance);
784     }
785 
786     /**
787      * @dev Update start block Number for the crowdsale
788      */
789     function updatePurchaseStartBlock(uint256 _purchaseStartBlock)
790         external
791         whenNotStarted
792         onlyFundraiser
793         returns (bool)
794     {
795         purchaseStartBlock = _purchaseStartBlock;
796         return true;
797     }
798 
799     /**
800      * @dev Update the CNY/ETH rate to record purchases in CNY
801      */
802     function updateCnyEthRate(uint256 rate)
803         external
804         onlyFundraiser
805         returns (bool)
806     {
807         cnyEthRate = rate;
808         CnyEthRateUpdated(cnyEthRate);
809         return true;
810     }
811 
812     /**
813      * @dev Update the CNY/BTC rate to record purchases in CNY
814      */
815     function updateCnyBtcRate(uint256 rate)
816         external
817         onlyFundraiser
818         returns (bool)
819     {
820         cnyBtcRate = rate;
821         CnyBtcRateUpdated(cnyBtcRate);
822         return true;
823     }
824 
825     /**
826      * @dev Allow for the possibility for contract owner to start crowdsale
827      */
828     function ownerStartsCrowdsale(uint256 timestamp)
829         external
830         whenNotStarted
831         onlyOwner
832     {
833         assert(block.number >= purchaseStartBlock);   // this should be after the crowdsale start block
834         startCrowdsale(timestamp);
835     }
836 
837     /**
838      * @dev Ends crowdsale
839      *      This may be executed by an owner if the raised funds did not reach the map cap
840      * @param timestamp Timestamp at the crowdsale ended
841      */
842     function endCrowdsale(uint256 timestamp)
843         external
844         onlyOwner
845     {
846         assert(timestamp > 0 && timestamp <= now);
847         assert(block.number >= purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
848         endedAt = timestamp;
849         CrowdsaleEnded(endedAt);
850     }
851 
852     /**
853      * @dev Ends crowdsale
854      *      This may be executed by purchaseWithEth when the raised funds reach the map cap
855      */
856     function endCrowdsale() internal {
857         assert(block.number >= purchaseStartBlock && endedAt == 0);
858         endedAt = now;
859         CrowdsaleEnded(endedAt);
860     }
861 
862     /**
863      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
864      */
865     function withdrawPurchasedTokens()
866         external
867         whenEnded
868         returns (bool)
869     {
870         assert(earlyPurchasesLoaded);
871         assert(address(starbaseToken) != 0);
872 
873         /*
874          * “Value” refers to the contribution of the User:
875          *  {crowdsale_purchaser_token_amount} =
876          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
877          *
878          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
879          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
880          * and total amount raised during the Contribution Period is 30’000’000, then he will get
881          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
882         */
883 
884         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
885             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
886             crowdsalePurchaseAmountBy[msg.sender] = 0;
887 
888             uint256 tokenCount =
889                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
890                 totalRaisedAmountInCny();
891 
892             numOfPurchasedTokensOnCsBy[msg.sender] =
893                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
894             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
895             numOfDeliveredCrowdsalePurchases++;
896         }
897 
898         /*
899          * “Value” refers to the contribution of the User:
900          * {earlypurchaser_token_amount} =
901          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
902          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
903          *
904          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
905          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
906          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
907          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
908          * 30’000’000 CNY + 6’000’000 CNY
909          */
910 
911         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
912             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
913             earlyPurchasedAmountBy[msg.sender] = 0;
914 
915             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases;
916 
917             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalRaisedAmountInCny();
918 
919             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
920 
921             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
922             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
923             numOfDeliveredEarlyPurchases++;
924         }
925 
926         return true;
927     }
928 
929     /**
930      * @dev Load early purchases from the contract keeps track of them
931      */
932     function loadEarlyPurchases() external onlyOwner returns (bool) {
933         if (earlyPurchasesLoaded) {
934             return false;    // all EPs have already been loaded
935         }
936 
937         uint256 numOfOrigEp = starbaseEpAmendment
938             .starbaseEarlyPurchase()
939             .numberOfEarlyPurchases();
940 
941         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
942             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
943                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
944                 continue;
945             }
946             var (purchaser, amount,) =
947                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
948                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
949                 : starbaseEpAmendment.earlyPurchases(i);
950             if (amount > 0) {
951                 if (earlyPurchasedAmountBy[purchaser] == 0) {
952                     earlyPurchasers.push(purchaser);
953                 }
954                 // each early purchaser receives 20% bonus
955                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
956                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
957 
958                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
959                 totalAmountOfEarlyPurchases = totalAmountOfEarlyPurchases.add(amountWithBonus);
960             }
961 
962             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
963         }
964 
965         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
966         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
967             earlyPurchasesLoaded = true;    // enable the flag
968         }
969         return true;
970     }
971 
972     /**
973      * @dev Load presale purchases from the contract keeps track of them
974      * @param starbaseCrowdsalePresale Starbase presale contract address
975      */
976     function loadPresalePurchases(address starbaseCrowdsalePresale)
977         external
978         onlyOwner
979         whenNotEnded
980     {
981         require(starbaseCrowdsalePresale != 0);
982         require(!presalePurchasesLoaded);
983         StarbaseCrowdsale presale = StarbaseCrowdsale(starbaseCrowdsalePresale);
984         for (uint i; i < presale.numOfPurchases(); i++) {
985             var (purchaser, amount, rawAmount, purchasedAt) =
986                 presale.crowdsalePurchases(i);  // presale purchase
987             crowdsalePurchases.push(CrowdsalePurchase(purchaser, amount, rawAmount, purchasedAt));
988 
989             // Increase the sums
990             crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
991             totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
992             totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
993         }
994         presalePurchasesLoaded = true;
995     }
996 
997     /**
998       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
999       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
1000       * @param _amountCap Ether value which partner is able to contribute
1001       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
1002       */
1003     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
1004         external
1005         onlyOwner
1006     {
1007         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
1008         qualifiedPartners[_qualifiedPartner].bonaFide = true;
1009         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1010         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
1011         QualifiedPartnerAddress(_qualifiedPartner);
1012     }
1013 
1014     /**
1015      * @dev Remove address from qualified partners list.
1016      * @param _qualifiedPartner Address to be removed from the list.
1017      */
1018     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
1019         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1020         qualifiedPartners[_qualifiedPartner].bonaFide = false;
1021     }
1022 
1023     /**
1024      * @dev Update whitelisted address amount allowed to raise during the presale.
1025      * @param _qualifiedPartner Qualified Partner address to be updated.
1026      * @param _amountCap Amount that the address is able to raise during the presale.
1027      */
1028     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
1029         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1030         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1031     }
1032 
1033     /**
1034      * Public functions
1035      */
1036 
1037     /**
1038      * @dev Returns boolean for whether crowdsale has ended
1039      */
1040     function isEnded() constant public returns (bool) {
1041         return (endedAt > 0 && endedAt <= now);
1042     }
1043 
1044     /**
1045      * @dev Returns number of purchases to date.
1046      */
1047     function numOfPurchases() constant public returns (uint256) {
1048         return crowdsalePurchases.length;
1049     }
1050 
1051     /**
1052      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1053      */
1054     function totalRaisedAmountInCny() constant public returns (uint256) {
1055         return totalAmountOfEarlyPurchases.add(totalAmountOfCrowdsalePurchases);
1056     }
1057 
1058     /**
1059      * @dev Returns total amount of early purchases in CNY and bonuses
1060      */
1061     function totalAmountOfEarlyPurchasesWithBonus() constant public returns(uint256) {
1062        return starbaseEpAmendment.totalAmountOfEarlyPurchases().mul(120).div(100);
1063     }
1064 
1065     /**
1066      * @dev Returns total amount of early purchases in CNY
1067      */
1068     function totalAmountOfEarlyPurchasesWithoutBonus() constant public returns(uint256) {
1069        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1070     }
1071 
1072     /**
1073      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1074      */
1075     function purchaseAsQualifiedPartner()
1076         payable
1077         public
1078         rateIsSet(cnyEthRate)
1079         onlyQualifiedPartner
1080         returns (bool)
1081     {
1082         require(msg.value > 0);
1083         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1084 
1085         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1086 
1087         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1088         recordPurchase(msg.sender, rawAmount, now);
1089 
1090         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1091             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1092         }
1093 
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev Allows user to purchase STAR tokens with Ether
1099      */
1100     function purchaseWithEth()
1101         payable
1102         public
1103         minInvestment
1104         whenNotEnded
1105         rateIsSet(cnyEthRate)
1106         onlyQualifiedPartnerORPicopsCertified
1107         returns (bool)
1108     {
1109         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1110 
1111         if (startDate == 0) {
1112             startCrowdsale(block.timestamp);
1113         }
1114 
1115         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1116         recordPurchase(msg.sender, rawAmount, now);
1117 
1118         if (totalAmountOfCrowdsalePurchasesWithoutBonus >= maxCrowdsaleCap) {
1119             endCrowdsale(); // ends this crowdsale automatically
1120         }
1121 
1122         return true;
1123     }
1124 
1125     /**
1126      * Internal functions
1127      */
1128 
1129     /**
1130      * @dev Initializes Starbase crowdsale
1131      */
1132     function startCrowdsale(uint256 timestamp) internal {
1133         startDate = timestamp;
1134         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus;
1135         if (maxCrowdsaleCap > presaleAmount) {
1136             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1137             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1138 
1139             // set token bonus milestones in cny total crowdsale purchase
1140             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1141             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1142             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1143             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1144         }
1145     }
1146 
1147     /**
1148      * @dev Abstract record of a purchase to Tokens
1149      * @param purchaser Address of the buyer
1150      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1151      * @param timestamp Timestamp at the purchase made
1152      */
1153     function recordPurchase(
1154         address purchaser,
1155         uint256 rawAmount,
1156         uint256 timestamp
1157     )
1158         internal
1159         returns(uint256 amount)
1160     {
1161         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1162 
1163         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1164         if (block.number >= purchaseStartBlock) {
1165             require(totalAmountOfCrowdsalePurchasesWithoutBonus < maxCrowdsaleCap);   // check if the amount has already reached the cap
1166 
1167             uint256 crowdsaleTotalAmountAfterPurchase =
1168                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus, amount);
1169 
1170             // check whether purchase goes over the cap and send the difference back to the purchaser.
1171             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1172               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1173               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1174               purchaser.transfer(ethValueToReturn);
1175               amount = SafeMath.sub(amount, difference);
1176               rawAmount = amount;
1177             }
1178         }
1179 
1180         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1181 
1182         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1183         crowdsalePurchases.push(purchase);
1184         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1185         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1186         totalAmountOfCrowdsalePurchases = totalAmountOfCrowdsalePurchases.add(amount);
1187         totalAmountOfCrowdsalePurchasesWithoutBonus = totalAmountOfCrowdsalePurchasesWithoutBonus.add(rawAmount);
1188         return amount;
1189     }
1190 
1191     /**
1192      * @dev Calculates amount with bonus for bonus milestones
1193      */
1194     function calculateBonus
1195         (
1196             BonusMilestones nextMilestone,
1197             uint256 amount,
1198             uint256 bonusRange,
1199             uint256 bonusTier,
1200             uint256 results
1201         )
1202         internal
1203         returns (uint256 result, uint256 newAmount)
1204     {
1205         uint256 bonusCalc;
1206 
1207         if (amount <= bonusRange) {
1208             bonusCalc = amount.mul(bonusTier).div(100);
1209 
1210             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus) >= bonusRange)
1211                 bonusMilestones = nextMilestone;
1212 
1213             result = results.add(amount).add(bonusCalc);
1214             newAmount = 0;
1215 
1216         } else {
1217             bonusCalc = bonusRange.mul(bonusTier).div(100);
1218             bonusMilestones = nextMilestone;
1219             result = results.add(bonusRange).add(bonusCalc);
1220             newAmount = amount.sub(bonusRange);
1221         }
1222     }
1223 
1224     /**
1225      * @dev Fetchs Bonus tier percentage per bonus milestones
1226      */
1227     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1228         if (block.number < purchaseStartBlock) {
1229             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1230             return amount.add(bonusFromAmount);
1231         }
1232 
1233         // range of each bonus milestones
1234         uint256 firstBonusRange = firstBonusEnds;
1235         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1236         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1237         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1238         uint256 result;
1239 
1240         if (bonusMilestones == BonusMilestones.First)
1241             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1242 
1243         if (bonusMilestones == BonusMilestones.Second)
1244             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1245 
1246         if (bonusMilestones == BonusMilestones.Third)
1247             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1248 
1249         if (bonusMilestones == BonusMilestones.Fourth)
1250             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1251 
1252         return result.add(amount);
1253     }
1254 
1255     /**
1256      * @dev Fetchs Bonus tier percentage per bonus milestones
1257      * @dev qualifiedPartner Address of partners that participated in pre sale
1258      * @dev amountSent Value sent by qualified partner
1259      */
1260     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1261         //calculate the commission fee to send to qualified partner
1262         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1263 
1264         // send commission fee amount
1265         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1266     }
1267 
1268     /**
1269      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1270      */
1271     function redirectToPurchase() internal {
1272         if (block.number < purchaseStartBlock) {
1273             purchaseAsQualifiedPartner();
1274         } else {
1275             purchaseWithEth();
1276         }
1277     }
1278 }