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
568 /**
569  * @title Crowdsale contract - Starbase crowdsale to create STAR.
570  * @author Starbase PTE. LTD. - <info@starbase.co>
571  */
572 contract StarbaseCrowdsale is Ownable {
573     /*
574      *  Events
575      */
576     event CrowdsaleEnded(uint256 endedAt);
577     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate, uint256 bonusTokensPercentage);
578     event StarbasePurchasedOffChain(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyBtcRate, uint256 bonusTokensPercentage, string data);
579     event CnyEthRateUpdated(uint256 cnyEthRate);
580     event CnyBtcRateUpdated(uint256 cnyBtcRate);
581     event QualifiedPartnerAddress(address qualifiedPartner);
582 
583     /**
584      *  External contracts
585      */
586     AbstractStarbaseToken public starbaseToken;
587     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
588 
589     /**
590      *  Constants
591      */
592     uint256 constant public crowdsaleTokenAmount = 125000000e18;
593     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
594     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
595     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
596     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
597 
598     /**
599      * Types
600      */
601     struct CrowdsalePurchase {
602         address purchaser;
603         uint256 amount;        // CNY based amount with bonus
604         uint256 rawAmount;     // CNY based amount no bonus
605         uint256 purchasedAt;   // timestamp
606         string data;           // additional data (e.g. Tx ID of Bitcoin)
607         uint256 bonus;
608     }
609 
610     struct QualifiedPartners {
611         uint256 amountCap;
612         uint256 amountRaised;
613         bool    bonaFide;
614         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
615     }
616 
617     /**
618      *  Storage
619      */
620     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
621     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
622     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
623 
624     // early purchase
625     address[] public earlyPurchasers;
626     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
627     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
628     uint256 public totalAmountOfEarlyPurchasesInCny;
629 
630     // crowdsale
631     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
632     uint256 public totalAmountOfPurchasesInCny; // totalPreSale + totalCrowdsale
633     mapping (address => QualifiedPartners) public qualifiedPartners;
634     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
635     uint256 public startDate;
636     uint256 public endedAt;
637     CrowdsalePurchase[] public crowdsalePurchases;
638     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
639     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
640     uint256 public cnyEthRate;
641 
642     // bonus milestones
643     uint256 public firstBonusSalesEnds;
644     uint256 public secondBonusSalesEnds;
645     uint256 public thirdBonusSalesEnds;
646     uint256 public fourthBonusSalesEnds;
647     uint256 public fifthBonusSalesEnds;
648     uint256 public firstExtendedBonusSalesEnds;
649     uint256 public secondExtendedBonusSalesEnds;
650     uint256 public thirdExtendedBonusSalesEnds;
651     uint256 public fourthExtendedBonusSalesEnds;
652     uint256 public fifthExtendedBonusSalesEnds;
653     uint256 public sixthExtendedBonusSalesEnds;
654 
655     // after the crowdsale
656     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
657     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
658 
659     /**
660      *  Modifiers
661      */
662     modifier minInvestment() {
663         // User has to send at least the ether value of one token.
664         assert(msg.value >= MIN_INVESTMENT);
665         _;
666     }
667 
668     modifier whenEnded() {
669         assert(isEnded());
670         _;
671     }
672 
673     modifier hasBalance() {
674         assert(this.balance > 0);
675         _;
676     }
677     modifier rateIsSet(uint256 _rate) {
678         assert(_rate != 0);
679         _;
680     }
681 
682     modifier whenNotEnded() {
683         assert(!isEnded());
684         _;
685     }
686 
687     modifier tokensNotDelivered() {
688         assert(numOfDeliveredCrowdsalePurchases == 0);
689         assert(numOfDeliveredEarlyPurchases == 0);
690         _;
691     }
692 
693     modifier onlyFundraiser() {
694         assert(address(starbaseToken) != 0);
695         assert(starbaseToken.isFundraiser(msg.sender));
696         _;
697     }
698 
699     /**
700      * Contract functions
701      */
702     /**
703      * @dev Contract constructor function sets owner address and
704      *      address of StarbaseEarlyPurchaseAmendment contract.
705      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
706      */
707     function StarbaseCrowdsale(address starbaseEpAddr) {
708         require(starbaseEpAddr != 0);
709         owner = msg.sender;
710         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
711     }
712 
713     /**
714      * @dev Fallback accepts payment for Star tokens with Eth
715      */
716     function() payable {
717         redirectToPurchase();
718     }
719 
720     /**
721      * External functions
722      */
723 
724     /**
725      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
726      * @param starbaseTokenAddress Token address.
727      * @param _purchaseStartBlock Block number to start crowdsale
728      */
729     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
730         external
731         onlyOwner
732         returns (bool)
733     {
734         assert(address(starbaseToken) == 0);
735         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
736         purchaseStartBlock = _purchaseStartBlock;
737 
738         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
739         // set the max cap of this crowdsale
740         maxCrowdsaleCap = SafeMath.sub(MAX_CAP, totalAmountOfEarlyPurchasesInCny);
741         assert(maxCrowdsaleCap > 0);
742 
743         return true;
744     }
745 
746     /**
747      * @dev Allows owner to record a purchase made outside of Ethereum blockchain
748      * @param purchaser Address of a purchaser
749      * @param rawAmount Purchased amount in CNY
750      * @param purchasedAt Timestamp at the purchase made
751      * @param data Identifier as an evidence of the purchase (e.g. btc:1xyzxyz)
752      */
753     function recordOffchainPurchase(
754         address purchaser,
755         uint256 rawAmount,
756         uint256 purchasedAt,
757         string data
758     )
759         external
760         onlyFundraiser
761         whenNotEnded
762         rateIsSet(cnyBtcRate)
763         returns (bool)
764     {
765         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
766         if (startDate == 0) {
767             startCrowdsale(block.timestamp);
768         }
769 
770         uint256 bonusTier = getBonusTier();
771         uint amount = recordPurchase(purchaser, rawAmount, purchasedAt, data, bonusTier);
772 
773         StarbasePurchasedOffChain(purchaser, amount, rawAmount, cnyBtcRate, bonusTier, data);
774         return true;
775     }
776 
777     /**
778      * @dev Transfers raised funds to company's wallet address at any given time.
779      */
780     function withdrawForCompany()
781         external
782         onlyFundraiser
783         hasBalance
784     {
785         address company = starbaseToken.company();
786         require(company != address(0));
787         company.transfer(this.balance);
788     }
789 
790     /**
791      * @dev Update the CNY/ETH rate to record purchases in CNY
792      */
793     function updateCnyEthRate(uint256 rate)
794         external
795         onlyFundraiser
796         returns (bool)
797     {
798         cnyEthRate = rate;
799         CnyEthRateUpdated(cnyEthRate);
800         return true;
801     }
802 
803     /**
804      * @dev Update the CNY/BTC rate to record purchases in CNY
805      */
806     function updateCnyBtcRate(uint256 rate)
807         external
808         onlyFundraiser
809         returns (bool)
810     {
811         cnyBtcRate = rate;
812         CnyBtcRateUpdated(cnyBtcRate);
813         return true;
814     }
815 
816     /**
817      * @dev Allow for the possibility for contract owner to start crowdsale
818      */
819     function ownerStartsCrowdsale(uint256 timestamp)
820         external
821         onlyOwner
822     {
823         assert(startDate == 0 && block.number >= purchaseStartBlock);   // overwriting startDate is not permitted and it should be after the crowdsale start block
824         startCrowdsale(timestamp);
825 
826     }
827 
828     /**
829      * @dev Ends crowdsale
830      * @param timestamp Timestamp at the crowdsale ended
831      */
832     function endCrowdsale(uint256 timestamp)
833         external
834         onlyOwner
835     {
836         assert(timestamp > 0 && timestamp <= now);
837         assert(block.number > purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
838         endedAt = timestamp;
839         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
840         totalAmountOfPurchasesInCny = totalRaisedAmountInCny();
841         CrowdsaleEnded(endedAt);
842     }
843 
844     /**
845      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
846      */
847     function withdrawPurchasedTokens()
848         external
849         whenEnded
850         returns (bool)
851     {
852         assert(earlyPurchasesLoaded);
853         assert(address(starbaseToken) != 0);
854 
855         /*
856          * “Value” refers to the contribution of the User:
857          *  {crowdsale_purchaser_token_amount} =
858          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
859          *
860          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
861          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
862          * and total amount raised during the Contribution Period is 30’000’000, then he will get
863          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
864         */
865 
866         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
867             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
868             crowdsalePurchaseAmountBy[msg.sender] = 0;
869 
870             uint256 tokenCount =
871                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
872                 totalAmountOfPurchasesInCny;
873 
874             numOfPurchasedTokensOnCsBy[msg.sender] =
875                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
876             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
877             numOfDeliveredCrowdsalePurchases++;
878         }
879 
880         /*
881          * “Value” refers to the contribution of the User:
882          * {earlypurchaser_token_amount} =
883          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
884          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
885          *
886          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
887          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
888          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
889          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
890          * 30’000’000 CNY + 6’000’000 CNY
891          */
892 
893         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
894             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
895             earlyPurchasedAmountBy[msg.sender] = 0;
896 
897             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchasesInCny;
898 
899             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfPurchasesInCny;
900 
901             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
902 
903             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
904             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
905             numOfDeliveredEarlyPurchases++;
906         }
907 
908         return true;
909     }
910 
911     /**
912      * @dev Load early purchases from the contract keeps track of them
913      */
914     function loadEarlyPurchases() external onlyOwner returns (bool) {
915         if (earlyPurchasesLoaded) {
916             return false;    // all EPs have already been loaded
917         }
918 
919         uint256 numOfOrigEp = starbaseEpAmendment
920             .starbaseEarlyPurchase()
921             .numberOfEarlyPurchases();
922 
923         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
924             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
925                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
926                 continue;
927             }
928             var (purchaser, amount,) =
929                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
930                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
931                 : starbaseEpAmendment.earlyPurchases(i);
932             if (amount > 0) {
933                 if (earlyPurchasedAmountBy[purchaser] == 0) {
934                     earlyPurchasers.push(purchaser);
935                 }
936                 // each early purchaser receives 20% bonus
937                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
938                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
939 
940                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
941             }
942 
943             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
944         }
945 
946         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
947         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
948             earlyPurchasesLoaded = true;    // enable the flag
949         }
950         return true;
951     }
952 
953     /**
954       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
955       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
956       * @param _amountCap Ether value which partner is able to contribute
957       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
958       */
959     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
960         external
961         onlyOwner
962     {
963         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
964         qualifiedPartners[_qualifiedPartner].bonaFide = true;
965         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
966         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
967         QualifiedPartnerAddress(_qualifiedPartner);
968     }
969 
970     /**
971      * @dev Remove address from qualified partners list.
972      * @param _qualifiedPartner Address to be removed from the list.
973      */
974     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
975         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
976         qualifiedPartners[_qualifiedPartner].bonaFide = false;
977     }
978 
979     /**
980      * @dev Update whitelisted address amount allowed to raise during the presale.
981      * @param _qualifiedPartner Qualified Partner address to be updated.
982      * @param _amountCap Amount that the address is able to raise during the presale.
983      */
984     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
985         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
986         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
987     }
988 
989     /**
990      * Public functions
991      */
992 
993     /**
994      * @dev Returns boolean for whether crowdsale has ended
995      */
996     function isEnded() constant public returns (bool) {
997         return (endedAt > 0 && endedAt <= now);
998     }
999 
1000     /**
1001      * @dev Returns number of purchases to date.
1002      */
1003     function numOfPurchases() constant public returns (uint256) {
1004         return crowdsalePurchases.length;
1005     }
1006 
1007     /**
1008      * @dev Calculates total amount of tokens purchased includes bonus tokens.
1009      */
1010     function totalAmountOfCrowdsalePurchases() constant public returns (uint256 amount) {
1011         for (uint256 i; i < crowdsalePurchases.length; i++) {
1012             amount = SafeMath.add(amount, crowdsalePurchases[i].amount);
1013         }
1014     }
1015 
1016     /**
1017      * @dev Calculates total amount of tokens purchased without bonus conversion.
1018      */
1019     function totalAmountOfCrowdsalePurchasesWithoutBonus() constant public returns (uint256 amount) {
1020         for (uint256 i; i < crowdsalePurchases.length; i++) {
1021             amount = SafeMath.add(amount, crowdsalePurchases[i].rawAmount);
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1027      */
1028     function totalRaisedAmountInCny() constant public returns (uint256) {
1029         return SafeMath.add(totalAmountOfEarlyPurchases(), totalAmountOfCrowdsalePurchases());
1030     }
1031 
1032     /**
1033      * @dev Returns total amount of early purchases in CNY
1034      */
1035     function totalAmountOfEarlyPurchases() constant public returns(uint256) {
1036        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1037     }
1038 
1039     /**
1040      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1041      */
1042     function purchaseAsQualifiedPartner()
1043         payable
1044         public
1045         rateIsSet(cnyEthRate)
1046         returns (bool)
1047     {
1048         require(qualifiedPartners[msg.sender].bonaFide);
1049         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1050 
1051         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1052 
1053         uint256 bonusTier = 30; // Pre sale purchasers get 30 percent bonus
1054         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1055         uint amount = recordPurchase(msg.sender, rawAmount, now, '', bonusTier);
1056 
1057         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1058             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1059         }
1060 
1061         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate, bonusTier);
1062         return true;
1063     }
1064 
1065     /**
1066      * @dev Allows user to purchase STAR tokens with Ether
1067      */
1068     function purchaseWithEth()
1069         payable
1070         public
1071         minInvestment
1072         whenNotEnded
1073         rateIsSet(cnyEthRate)
1074         returns (bool)
1075     {
1076         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1077         if (startDate == 0) {
1078             startCrowdsale(block.timestamp);
1079         }
1080 
1081         uint256 bonusTier = getBonusTier();
1082 
1083         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1084         uint amount = recordPurchase(msg.sender, rawAmount, now, '', bonusTier);
1085 
1086         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate, bonusTier);
1087         return true;
1088     }
1089 
1090     /**
1091      * Internal functions
1092      */
1093 
1094     /**
1095      * @dev Initializes Starbase crowdsale
1096      */
1097     function startCrowdsale(uint256 timestamp) internal {
1098         startDate = timestamp;
1099 
1100         // set token bonus milestones
1101         firstBonusSalesEnds = startDate + 7 days;             // 1. 1st ~ 7th day
1102         secondBonusSalesEnds = firstBonusSalesEnds + 14 days; // 2. 8th ~ 21st day
1103         thirdBonusSalesEnds = secondBonusSalesEnds + 14 days; // 3. 22nd ~ 35th day
1104         fourthBonusSalesEnds = thirdBonusSalesEnds + 7 days;  // 4. 36th ~ 42nd day
1105         fifthBonusSalesEnds = fourthBonusSalesEnds + 3 days;  // 5. 43rd ~ 45th day
1106 
1107         // extended sales bonus milestones
1108         firstExtendedBonusSalesEnds = fifthBonusSalesEnds + 3 days;         // 1. 46th ~ 48th day
1109         secondExtendedBonusSalesEnds = firstExtendedBonusSalesEnds + 3 days; // 2. 49th ~ 51st day
1110         thirdExtendedBonusSalesEnds = secondExtendedBonusSalesEnds + 3 days; // 3. 52nd ~ 54th day
1111         fourthExtendedBonusSalesEnds = thirdExtendedBonusSalesEnds + 3 days; // 4. 55th ~ 57th day
1112         fifthExtendedBonusSalesEnds = fourthExtendedBonusSalesEnds + 3 days;  // 5. 58th ~ 60th day
1113         sixthExtendedBonusSalesEnds = fifthExtendedBonusSalesEnds + 60 days; // 6. 61st ~ 120th day
1114     }
1115 
1116     /**
1117      * @dev Abstract record of a purchase to Tokens
1118      * @param purchaser Address of the buyer
1119      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1120      * @param timestamp Timestamp at the purchase made
1121      * @param data Identifier as an evidence of the purchase (e.g. btc:1xyzxyz)
1122      * @param bonusTier bonus milestones of the purchase
1123      */
1124     function recordPurchase(
1125         address purchaser,
1126         uint256 rawAmount,
1127         uint256 timestamp,
1128         string data,
1129         uint256 bonusTier
1130     )
1131         internal
1132         returns(uint256 amount)
1133     {
1134         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1135 
1136         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1137         if (block.number >= purchaseStartBlock) {
1138 
1139             assert(totalAmountOfCrowdsalePurchasesWithoutBonus() <= maxCrowdsaleCap);
1140 
1141             uint256 crowdsaleTotalAmountAfterPurchase = SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus(), amount);
1142 
1143             // check whether purchase goes over the cap and send the difference back to the purchaser.
1144             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1145               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1146               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1147               purchaser.transfer(ethValueToReturn);
1148               amount = SafeMath.sub(amount, difference);
1149               rawAmount = amount;
1150             }
1151 
1152         }
1153 
1154         uint256 covertedAmountwWithBonus = SafeMath.mul(amount, bonusTier) / 100;
1155         amount = SafeMath.add(amount, covertedAmountwWithBonus); // at this point amount bonus is calculated
1156 
1157         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp, data, bonusTier);
1158         crowdsalePurchases.push(purchase);
1159         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1160         return amount;
1161     }
1162 
1163     /**
1164      * @dev Fetchs Bonus tier percentage per bonus milestones
1165      */
1166     function getBonusTier() internal returns (uint256) {
1167         bool firstBonusSalesPeriod = now >= startDate && now <= firstBonusSalesEnds; // 1st ~ 7th day get 20% bonus
1168         bool secondBonusSalesPeriod = now > firstBonusSalesEnds && now <= secondBonusSalesEnds; // 8th ~ 21st day get 15% bonus
1169         bool thirdBonusSalesPeriod = now > secondBonusSalesEnds && now <= thirdBonusSalesEnds; // 22nd ~ 35th day get 10% bonus
1170         bool fourthBonusSalesPeriod = now > thirdBonusSalesEnds && now <= fourthBonusSalesEnds; // 36th ~ 42nd day get 5% bonus
1171         bool fifthBonusSalesPeriod = now > fourthBonusSalesEnds && now <= fifthBonusSalesEnds; // 43rd and 45th day get 0% bonus
1172 
1173         // extended bonus sales
1174         bool firstExtendedBonusSalesPeriod = now > fifthBonusSalesEnds && now <= firstExtendedBonusSalesEnds; // extended sales 46th ~ 48th day get 20% bonus
1175         bool secondExtendedBonusSalesPeriod = now > firstExtendedBonusSalesEnds && now <= secondExtendedBonusSalesEnds; // 49th ~ 51st 15% bonus
1176         bool thirdExtendedBonusSalesPeriod = now > secondExtendedBonusSalesEnds && now <= thirdExtendedBonusSalesEnds; // 52nd ~ 54th day get 10% bonus
1177         bool fourthExtendedBonusSalesPeriod = now > thirdExtendedBonusSalesEnds && now <= fourthExtendedBonusSalesEnds; // 55th ~ 57th day day get 5% bonus
1178         bool fifthExtendedBonusSalesPeriod = now > fourthExtendedBonusSalesEnds && now <= fifthExtendedBonusSalesEnds; // 58th ~ 60th day get 0% bonus
1179         bool sixthExtendedBonusSalesPeriod = now > fifthExtendedBonusSalesEnds && now <= sixthExtendedBonusSalesEnds; // 61st ~ 120th day get {number_of_days} - 60 * 1% bonus
1180 
1181         if (firstBonusSalesPeriod || firstExtendedBonusSalesPeriod) return 20;
1182         if (secondBonusSalesPeriod || secondExtendedBonusSalesPeriod) return 15;
1183         if (thirdBonusSalesPeriod || thirdExtendedBonusSalesPeriod) return 10;
1184         if (fourthBonusSalesPeriod || fourthExtendedBonusSalesPeriod) return 5;
1185         if (fifthBonusSalesPeriod || fifthExtendedBonusSalesPeriod) return 0;
1186 
1187         if (sixthExtendedBonusSalesPeriod) {
1188           uint256 DAY_IN_SECONDS = 86400;
1189           uint256 secondsSinceStartDate = SafeMath.sub(now, startDate);
1190           uint256 numberOfDays = secondsSinceStartDate / DAY_IN_SECONDS;
1191 
1192           return SafeMath.sub(numberOfDays, 60);
1193         }
1194     }
1195 
1196     /**
1197      * @dev Fetchs Bonus tier percentage per bonus milestones
1198      * @dev qualifiedPartner Address of partners that participated in pre sale
1199      * @dev amountSent Value sent by qualified partner
1200      */
1201     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1202         //calculate the commission fee to send to qualified partner
1203         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1204 
1205         // send commission fee amount
1206         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1207     }
1208 
1209     /**
1210      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1211      */
1212     function redirectToPurchase() internal {
1213         if (block.number < purchaseStartBlock) {
1214             purchaseAsQualifiedPartner();
1215         } else {
1216             purchaseWithEth();
1217         }
1218     }
1219 }