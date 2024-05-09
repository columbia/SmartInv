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
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant returns (uint256);
80   function transfer(address to, uint256 value) returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) returns (bool);
91   function approve(address spender, uint256 value) returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract AbstractStarbaseToken is ERC20 {
96     function isFundraiser(address fundraiserAddress) public returns (bool);
97     function company() public returns (address);
98     function allocateToCrowdsalePurchaser(address to, uint256 value) public returns (bool);
99     function allocateToMarketingSupporter(address to, uint256 value) public returns (bool);
100 }
101 
102 contract AbstractStarbaseCrowdsale {
103     function workshop() constant returns (address) {}
104     function startDate() constant returns (uint256) {}
105     function endedAt() constant returns (uint256) {}
106     function isEnded() constant returns (bool);
107     function totalRaisedAmountInCny() constant returns (uint256);
108     function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);
109     function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);
110 }
111 
112 // @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
113 /// @author Starbase PTE. LTD. - <info@starbase.co>
114 contract StarbaseEarlyPurchase {
115     /*
116      *  Constants
117      */
118     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
119     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
120     uint256 public constant PURCHASE_AMOUNT_CAP = 9000000;
121 
122     /*
123      *  Types
124      */
125     struct EarlyPurchase {
126         address purchaser;
127         uint256 amount;        // CNY based amount
128         uint256 purchasedAt;   // timestamp
129     }
130 
131     /*
132      *  External contracts
133      */
134     AbstractStarbaseCrowdsale public starbaseCrowdsale;
135 
136     /*
137      *  Storage
138      */
139     address public owner;
140     EarlyPurchase[] public earlyPurchases;
141     uint256 public earlyPurchaseClosedAt;
142 
143     /*
144      *  Modifiers
145      */
146     modifier noEther() {
147         require(msg.value == 0);
148         _;
149     }
150 
151     modifier onlyOwner() {
152         require(msg.sender == owner);
153         _;
154     }
155 
156     modifier onlyBeforeCrowdsale() {
157         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
158         _;
159     }
160 
161     modifier onlyEarlyPurchaseTerm() {
162         assert(earlyPurchaseClosedAt <= 0);
163         _;
164     }
165 
166     /*
167      *  Contract functions
168      */
169 
170     /**
171      * @dev Returns early purchased amount by purchaser's address
172      * @param purchaser Purchaser address
173      */
174     function purchasedAmountBy(address purchaser)
175         external
176         constant
177         noEther
178         returns (uint256 amount)
179     {
180         for (uint256 i; i < earlyPurchases.length; i++) {
181             if (earlyPurchases[i].purchaser == purchaser) {
182                 amount += earlyPurchases[i].amount;
183             }
184         }
185     }
186 
187     /**
188      * @dev Returns total amount of raised funds by Early Purchasers
189      */
190     function totalAmountOfEarlyPurchases()
191         constant
192         noEther
193         public
194         returns (uint256 totalAmount)
195     {
196         for (uint256 i; i < earlyPurchases.length; i++) {
197             totalAmount += earlyPurchases[i].amount;
198         }
199     }
200 
201     /**
202      * @dev Returns number of early purchases
203      */
204     function numberOfEarlyPurchases()
205         external
206         constant
207         noEther
208         returns (uint256)
209     {
210         return earlyPurchases.length;
211     }
212 
213     /**
214      * @dev Append an early purchase log
215      * @param purchaser Purchaser address
216      * @param amount Purchase amount
217      * @param purchasedAt Timestamp of purchased date
218      */
219     function appendEarlyPurchase(address purchaser, uint256 amount, uint256 purchasedAt)
220         external
221         noEther
222         onlyOwner
223         onlyBeforeCrowdsale
224         onlyEarlyPurchaseTerm
225         returns (bool)
226     {
227         if (amount == 0 ||
228             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
229         {
230             return false;
231         }
232 
233         assert(purchasedAt != 0 || purchasedAt <= now);
234 
235         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
236         return true;
237     }
238 
239     /**
240      * @dev Close early purchase term
241      */
242     function closeEarlyPurchase()
243         external
244         noEther
245         onlyOwner
246         returns (bool)
247     {
248         earlyPurchaseClosedAt = now;
249     }
250 
251     /**
252      * @dev Setup function sets external contract's address
253      * @param starbaseCrowdsaleAddress Token address
254      */
255     function setup(address starbaseCrowdsaleAddress)
256         external
257         noEther
258         onlyOwner
259         returns (bool)
260     {
261         if (address(starbaseCrowdsale) == 0) {
262             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
263             return true;
264         }
265         return false;
266     }
267 
268     /**
269      * @dev Contract constructor function
270      */
271     function StarbaseEarlyPurchase() noEther {
272         owner = msg.sender;
273     }
274 }
275 
276 
277 /// @title EarlyPurchaseAmendment contract - Amend early purchase records of the original contract
278 /// @author Starbase PTE. LTD. - <support@starbase.co>
279 contract StarbaseEarlyPurchaseAmendment {
280     /*
281      *  Events
282      */
283     event EarlyPurchaseInvalidated(uint256 epIdx);
284     event EarlyPurchaseAmended(uint256 epIdx);
285 
286     /*
287      *  External contracts
288      */
289     AbstractStarbaseCrowdsale public starbaseCrowdsale;
290     StarbaseEarlyPurchase public starbaseEarlyPurchase;
291 
292     /*
293      *  Storage
294      */
295     address public owner;
296     uint256[] public invalidEarlyPurchaseIndexes;
297     uint256[] public amendedEarlyPurchaseIndexes;
298     mapping (uint256 => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
299 
300     /*
301      *  Modifiers
302      */
303     modifier noEther() {
304         require(msg.value == 0);
305         _;
306     }
307 
308     modifier onlyOwner() {
309         require(msg.sender == owner);
310         _;
311     }
312 
313     modifier onlyBeforeCrowdsale() {
314         assert(address(starbaseCrowdsale) == address(0) || starbaseCrowdsale.startDate() == 0);
315         _;
316     }
317 
318     modifier onlyEarlyPurchasesLoaded() {
319         assert(address(starbaseEarlyPurchase) != address(0));
320         _;
321     }
322 
323     /*
324      *  Functions below are compatible with starbaseEarlyPurchase contract
325      */
326 
327     /**
328      * @dev Returns an early purchase record
329      * @param earlyPurchaseIndex Index number of an early purchase
330      */
331     function earlyPurchases(uint256 earlyPurchaseIndex)
332         external
333         constant
334         onlyEarlyPurchasesLoaded
335         returns (address purchaser, uint256 amount, uint256 purchasedAt)
336     {
337         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
338     }
339 
340     /**
341      * @dev Returns early purchased amount by purchaser's address
342      * @param purchaser Purchaser address
343      */
344     function purchasedAmountBy(address purchaser)
345         external
346         constant
347         noEther
348         returns (uint256 amount)
349     {
350         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
351             normalizedEarlyPurchases();
352         for (uint256 i; i < normalizedEP.length; i++) {
353             if (normalizedEP[i].purchaser == purchaser) {
354                 amount += normalizedEP[i].amount;
355             }
356         }
357     }
358 
359     /**
360      * @dev Returns total amount of raised funds by Early Purchasers
361      */
362     function totalAmountOfEarlyPurchases()
363         constant
364         noEther
365         public
366         returns (uint256 totalAmount)
367     {
368         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
369             normalizedEarlyPurchases();
370         for (uint256 i; i < normalizedEP.length; i++) {
371             totalAmount += normalizedEP[i].amount;
372         }
373     }
374 
375     /**
376      * @dev Returns number of early purchases
377      */
378     function numberOfEarlyPurchases()
379         external
380         constant
381         noEther
382         returns (uint256)
383     {
384         return normalizedEarlyPurchases().length;
385     }
386 
387     /**
388      * @dev Sets up function sets external contract's address
389      * @param starbaseCrowdsaleAddress Token address
390      */
391     function setup(address starbaseCrowdsaleAddress)
392         external
393         noEther
394         onlyOwner
395         returns (bool)
396     {
397         if (address(starbaseCrowdsale) == 0) {
398             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
399             return true;
400         }
401         return false;
402     }
403 
404     /*
405      *  Contract functions unique to StarbaseEarlyPurchaseAmendment
406      */
407 
408      /**
409       * @dev Invalidate early purchase
410       * @param earlyPurchaseIndex Index number of the purchase
411       */
412     function invalidateEarlyPurchase(uint256 earlyPurchaseIndex)
413         external
414         noEther
415         onlyOwner
416         onlyEarlyPurchasesLoaded
417         onlyBeforeCrowdsale
418         returns (bool)
419     {
420         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
421 
422         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
423             assert(invalidEarlyPurchaseIndexes[i] != earlyPurchaseIndex);
424         }
425 
426         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
427         EarlyPurchaseInvalidated(earlyPurchaseIndex);
428         return true;
429     }
430 
431     /**
432      * @dev Checks whether early purchase is invalid
433      * @param earlyPurchaseIndex Index number of the purchase
434      */
435     function isInvalidEarlyPurchase(uint256 earlyPurchaseIndex)
436         constant
437         noEther
438         public
439         returns (bool)
440     {
441         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
442 
443 
444         for (uint256 i; i < invalidEarlyPurchaseIndexes.length; i++) {
445             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
446                 return true;
447             }
448         }
449         return false;
450     }
451 
452     /**
453      * @dev Amends a given early purchase with data
454      * @param earlyPurchaseIndex Index number of the purchase
455      * @param purchaser Purchaser's address
456      * @param amount Value of purchase
457      * @param purchasedAt Purchase timestamp
458      */
459     function amendEarlyPurchase(uint256 earlyPurchaseIndex, address purchaser, uint256 amount, uint256 purchasedAt)
460         external
461         noEther
462         onlyOwner
463         onlyEarlyPurchasesLoaded
464         onlyBeforeCrowdsale
465         returns (bool)
466     {
467         assert(purchasedAt != 0 || purchasedAt <= now);
468 
469         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex);
470 
471         assert(!isInvalidEarlyPurchase(earlyPurchaseIndex)); // Invalid early purchase cannot be amended
472 
473         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
474             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
475         }
476 
477         amendedEarlyPurchases[earlyPurchaseIndex] =
478             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
479         EarlyPurchaseAmended(earlyPurchaseIndex);
480         return true;
481     }
482 
483     /**
484      * @dev Checks whether early purchase is amended
485      * @param earlyPurchaseIndex Index number of the purchase
486      */
487     function isAmendedEarlyPurchase(uint256 earlyPurchaseIndex)
488         constant
489         noEther
490         returns (bool)
491     {
492         assert(numberOfRawEarlyPurchases() > earlyPurchaseIndex); // Array Index Out of Bounds Exception
493 
494         for (uint256 i; i < amendedEarlyPurchaseIndexes.length; i++) {
495             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
496                 return true;
497             }
498         }
499         return false;
500     }
501 
502     /**
503      * @dev Loads early purchases data to StarbaseEarlyPurchaseAmendment contract
504      * @param starbaseEarlyPurchaseAddress Address from starbase early purchase
505      */
506     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
507         external
508         noEther
509         onlyOwner
510         onlyBeforeCrowdsale
511         returns (bool)
512     {
513         assert(starbaseEarlyPurchaseAddress != 0 ||
514             address(starbaseEarlyPurchase) == 0);
515 
516         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
517         assert(starbaseEarlyPurchase.earlyPurchaseClosedAt() != 0); // the early purchase must be closed
518 
519         return true;
520     }
521 
522     /**
523      * @dev Contract constructor function. It sets owner
524      */
525     function StarbaseEarlyPurchaseAmendment() noEther {
526         owner = msg.sender;
527     }
528 
529     /**
530      * Internal functions
531      */
532 
533     /**
534      * @dev Normalizes early purchases data
535      */
536     function normalizedEarlyPurchases()
537         constant
538         internal
539         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
540     {
541         uint256 rawEPCount = numberOfRawEarlyPurchases();
542         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
543             rawEPCount - invalidEarlyPurchaseIndexes.length);
544 
545         uint256 normalizedIdx;
546         for (uint256 i; i < rawEPCount; i++) {
547             if (isInvalidEarlyPurchase(i)) {
548                 continue;   // invalid early purchase should be ignored
549             }
550 
551             StarbaseEarlyPurchase.EarlyPurchase memory ep;
552             if (isAmendedEarlyPurchase(i)) {
553                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
554             } else {
555                 ep = getEarlyPurchase(i);
556             }
557 
558             normalizedEP[normalizedIdx] = ep;
559             normalizedIdx++;
560         }
561     }
562 
563     /**
564      * @dev Fetches early purchases data
565      */
566     function getEarlyPurchase(uint256 earlyPurchaseIndex)
567         internal
568         constant
569         onlyEarlyPurchasesLoaded
570         returns (StarbaseEarlyPurchase.EarlyPurchase)
571     {
572         var (purchaser, amount, purchasedAt) =
573             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
574         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
575     }
576 
577     /**
578      * @dev Returns raw number of early purchases
579      */
580     function numberOfRawEarlyPurchases()
581         internal
582         constant
583         onlyEarlyPurchasesLoaded
584         returns (uint256)
585     {
586         return starbaseEarlyPurchase.numberOfEarlyPurchases();
587     }
588 }
589 
590 
591 /**
592  * @title Crowdsale contract - Starbase crowdsale to create STAR.
593  * @author Starbase PTE. LTD. - <info@starbase.co>
594  */
595 contract StarbaseCrowdsale is Ownable {
596     /*
597      *  Events
598      */
599     event CrowdsaleEnded(uint256 endedAt);
600     event StarBasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate, uint256 bonusTokensPercentage);
601     event StarBasePurchasedOffChain(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyBtcRate, uint256 bonusTokensPercentage, string data);
602     event CnyEthRateUpdated(uint256 cnyEthRate);
603     event CnyBtcRateUpdated(uint256 cnyBtcRate);
604     event QualifiedPartnerAddress(address qualifiedPartner);
605     event PurchaseInvalidated(uint256 purchaseIdx);
606     event PurchaseAmended(uint256 purchaseIdx);
607 
608     /**
609      *  External contracts
610      */
611     AbstractStarbaseToken public starbaseToken;
612     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
613 
614     /**
615      *  Constants
616      */
617     uint256 constant public crowdsaleTokenAmount = 125000000e18;
618     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
619     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
620     uint256 constant public MAX_CROWDSALE_CAP = 60000000; // approximately 9M USD for the crowdsale(CS). 1M (by EP) + 9M (by CS) = 10M (Total)
621     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
622 
623     /**
624      * Types
625      */
626     struct CrowdsalePurchase {
627         address purchaser;
628         uint256 amount;        // CNY based amount with bonus
629         uint256 rawAmount;     // CNY based amount no bonus
630         uint256 purchasedAt;   // timestamp
631         string data;           // additional data (e.g. Tx ID of Bitcoin)
632         uint256 bonus;
633     }
634 
635     struct QualifiedPartners {
636         uint256 amountCap;
637         uint256 amountRaised;
638         bool    bonaFide;
639         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
640     }
641 
642     /**
643      *  Storage
644      */
645     address public workshop; // holds undelivered STARs
646 
647     uint public numOfDeliveredCrowdsalePurchases = 0;  // index to keep the number of crowdsale purchases have already been processed by `deliverPurchasedTokens`
648     uint public numOfDeliveredEarlyPurchases = 0;  // index to keep the number of early purchases have already been processed by `deliverPurchasedTokens`
649     uint256 public numOfLoadedEarlyPurchases = 0; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
650 
651     address[] public earlyPurchasers;
652     mapping (address => QualifiedPartners) public qualifiedPartners;
653     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
654     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
655 
656     // crowdsale
657     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
658     uint256 public startDate;
659     uint256 public endedAt;
660     CrowdsalePurchase[] public crowdsalePurchases;
661     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
662     uint256 public cnyEthRate;
663 
664     // bonus milestones
665     uint256 public firstBonusSalesEnds;
666     uint256 public secondBonusSalesEnds;
667     uint256 public thirdBonusSalesEnds;
668     uint256 public fourthBonusSalesEnds;
669     uint256 public fifthBonusSalesEnds;
670     uint256 public firstExtendedBonusSalesEnds;
671     uint256 public secondExtendedBonusSalesEnds;
672     uint256 public thirdExtendedBonusSalesEnds;
673     uint256 public fourthExtendedBonusSalesEnds;
674     uint256 public fifthExtendedBonusSalesEnds;
675     uint256 public sixthExtendedBonusSalesEnds;
676 
677     // after the crowdsale
678     mapping(uint256 => CrowdsalePurchase) public invalidatedOrigPurchases;  // Original purchase which was invalidated by owner
679     mapping(uint256 => CrowdsalePurchase) public amendedOrigPurchases;      // Original purchase which was amended by owner
680 
681     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
682     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
683 
684     /**
685      *  Modifiers
686      */
687     modifier minInvestment() {
688         // User has to send at least the ether value of one token.
689         assert(msg.value >= MIN_INVESTMENT);
690         _;
691     }
692 
693     modifier whenEnded() {
694         assert(isEnded());
695         _;
696     }
697 
698     modifier hasBalance() {
699         assert(this.balance > 0);
700         _;
701     }
702     modifier rateIsSet(uint256 _rate) {
703         assert(_rate != 0);
704         _;
705     }
706 
707     modifier whenNotEnded() {
708         assert(!isEnded());
709         _;
710     }
711 
712     modifier tokensNotDelivered() {
713         assert(numOfDeliveredCrowdsalePurchases == 0);
714         assert(numOfDeliveredEarlyPurchases == 0);
715         _;
716     }
717 
718     modifier onlyFundraiser() {
719       assert(address(starbaseToken) != 0);
720       assert(starbaseToken.isFundraiser(msg.sender));
721       _;
722     }
723 
724     /**
725      * Contract functions
726      */
727 
728     /**
729      * @dev Contract constructor function sets owner and start date.
730      * @param workshopAddr The address that will hold undelivered Star tokens
731      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
732      */
733     function StarbaseCrowdsale(address workshopAddr, address starbaseEpAddr) {
734         require(workshopAddr != 0 && starbaseEpAddr != 0);
735 
736         owner = msg.sender;
737         workshop = workshopAddr;
738         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
739     }
740 
741     /**
742      * @dev Fallback accepts payment for Star tokens with Eth
743      */
744     function() payable {
745         redirectToPurchase();
746     }
747 
748     /**
749      * External functions
750      */
751 
752     /**
753      * @dev Setup function sets external contracts' addresses.
754      * @param starbaseTokenAddress Token address.
755      * @param _purchaseStartBlock Block number to start crowdsale
756      */
757     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
758         external
759         onlyOwner
760         returns (bool)
761     {
762         assert(address(starbaseToken) == 0);
763         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
764         purchaseStartBlock = _purchaseStartBlock;
765         return true;
766     }
767 
768     /**
769      * @dev Allows owner to record a purchase made outside of Ethereum blockchain
770      * @param purchaser Address of a purchaser
771      * @param rawAmount Purchased amount in CNY
772      * @param purchasedAt Timestamp at the purchase made
773      * @param data Identifier as an evidence of the purchase (e.g. btc:1xyzxyz)
774      */
775     function recordOffchainPurchase(
776         address purchaser,
777         uint256 rawAmount,
778         uint256 purchasedAt,
779         string data
780     )
781         external
782         onlyFundraiser
783         whenNotEnded
784         rateIsSet(cnyBtcRate)
785         returns (bool)
786     {
787         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
788         if (startDate == 0) {
789             startCrowdsale(block.timestamp);
790         }
791 
792         uint256 bonusTier = getBonusTier();
793         uint amount = recordPurchase(purchaser, rawAmount, purchasedAt, data, bonusTier);
794 
795         StarBasePurchasedOffChain(purchaser, amount, rawAmount, cnyBtcRate, bonusTier, data);
796         return true;
797     }
798 
799     /**
800      * @dev Transfers raised funds to company's wallet address at any given time.
801      */
802     function withdrawForCompany()
803         external
804         onlyFundraiser
805         hasBalance
806     {
807         address company = starbaseToken.company();
808         require(company != address(0));
809         company.transfer(this.balance);
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
839      * @dev Allow for the possibilyt for contract owner to start crowdsale
840      */
841     function ownerStartsCrowdsale(uint256 timestamp)
842         external
843         onlyOwner
844     {
845         assert(startDate == 0 && block.number >= purchaseStartBlock);   // overwriting startDate is not permitted and it should be after the crowdsale start block
846         startCrowdsale(timestamp);
847 
848     }
849 
850     /**
851      * @dev Ends crowdsale
852      * @param timestamp Timestamp at the crowdsale ended
853      */
854     function endCrowdsale(uint256 timestamp)
855         external
856         onlyOwner
857     {
858         assert(timestamp > 0 && timestamp <= now);
859         assert(endedAt == 0);   // overwriting time is not permitted
860         endedAt = timestamp;
861         CrowdsaleEnded(endedAt);
862     }
863 
864     /**
865      * @dev Invalidate a crowdsale purchase if something is wrong with it
866      * @param purchaseIdx Index number of the crowdsalePurchases to invalidate
867      */
868     function invalidatePurchase(uint256 purchaseIdx)
869         external
870         onlyOwner
871         whenEnded
872         tokensNotDelivered
873         returns (bool)
874     {
875         CrowdsalePurchase memory purchase = crowdsalePurchases[purchaseIdx];
876         assert(purchase.purchaser != 0 && purchase.amount != 0);
877 
878         crowdsalePurchases[purchaseIdx].amount = 0;
879         crowdsalePurchases[purchaseIdx].rawAmount = 0;
880         invalidatedOrigPurchases[purchaseIdx] = purchase;
881         PurchaseInvalidated(purchaseIdx);
882         return true;
883     }
884 
885     /**
886      * @dev Amend a crowdsale purchase if something is wrong with it
887      * @param purchaseIdx Index number of the crowdsalePurchases to invalidate
888      * @param purchaser Address of the buyer
889      * @param amount Purchased tokens as per the CNY rate used
890      * @param rawAmount Purchased tokens as per the CNY rate used without the bonus
891      * @param purchasedAt Timestamp at the purchase made
892      * @param data Identifier as an evidence of the purchase (e.g. btc:1xyzxyz)
893      * @param bonus bonus milestones of the purchase
894      */
895     function amendPurchase(
896         uint256 purchaseIdx,
897         address purchaser,
898         uint256 amount,
899         uint256 rawAmount,
900         uint256 purchasedAt,
901         string data,
902         uint256 bonus
903     )
904         external
905         onlyOwner
906         whenEnded
907         tokensNotDelivered
908         returns (bool)
909     {
910         CrowdsalePurchase memory purchase = crowdsalePurchases[purchaseIdx];
911         assert(purchase.purchaser != 0 && purchase.amount != 0);
912 
913         amendedOrigPurchases[purchaseIdx] = purchase;
914         crowdsalePurchases[purchaseIdx] =
915             CrowdsalePurchase(purchaser, amount, rawAmount, purchasedAt, data, bonus);
916         PurchaseAmended(purchaseIdx);
917         return true;
918     }
919 
920     /**
921      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
922      */
923     function deliverPurchasedTokens()
924         external
925         onlyOwner
926         whenEnded
927         returns (bool)
928     {
929         assert(earlyPurchasesLoaded);
930         assert(address(starbaseToken) != 0);
931 
932         uint256 totalAmountOfPurchasesInCny = totalRaisedAmountInCny(); // totalPreSale + totalCrowdsale
933 
934         for (uint256 i = numOfDeliveredCrowdsalePurchases; i < crowdsalePurchases.length && msg.gas > 200000; i++) {
935             CrowdsalePurchase memory purchase = crowdsalePurchases[i];
936             if (purchase.amount == 0) {
937                 continue;   // skip invalidated purchase
938             }
939 
940             /*
941              * “Value” refers to the contribution of the User:
942              *  {crowdsale_purchaser_token_amount} =
943              *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
944              *
945              * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
946              * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
947              * and total amount raised during the Contribution Period is 30’000’000, then he will get
948              * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
949             */
950 
951             uint256 crowdsalePurchaseValue = purchase.amount;
952             uint256 tokenCount = SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) / totalAmountOfPurchasesInCny;
953 
954             numOfPurchasedTokensOnCsBy[purchase.purchaser] = SafeMath.add(numOfPurchasedTokensOnCsBy[purchase.purchaser], tokenCount);
955             starbaseToken.allocateToCrowdsalePurchaser(purchase.purchaser, tokenCount);
956             numOfDeliveredCrowdsalePurchases = SafeMath.add(i, 1);
957         }
958 
959         for (uint256 j = numOfDeliveredEarlyPurchases; j < earlyPurchasers.length && msg.gas > 200000; j++) {
960             address earlyPurchaser = earlyPurchasers[j];
961 
962             /*
963              * “Value” refers to the contribution of the User:
964              * {earlypurchaser_token_amount} =
965              * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
966              *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
967              *
968              * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
969              * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
970              * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
971              * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
972              * 30’000’000 CNY + 6’000’000 CNY
973              */
974 
975             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[earlyPurchaser];
976 
977             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchases();
978 
979             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfPurchasesInCny;
980 
981             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
982 
983             numOfPurchasedTokensOnEpBy[earlyPurchaser] = SafeMath.add(numOfPurchasedTokensOnEpBy[earlyPurchaser], epTokenCount);
984             starbaseToken.allocateToCrowdsalePurchaser(earlyPurchaser, epTokenCount);
985             numOfDeliveredEarlyPurchases = SafeMath.add(j, 1);
986         }
987 
988         return true;
989     }
990 
991     /**
992      * @dev Load early purchases from the contract keeps track of them
993      */
994     function loadEarlyPurchases() external onlyOwner returns (bool) {
995         if (earlyPurchasesLoaded) {
996             return false;    // all EPs have already been loaded
997         }
998 
999         uint256 numOfOrigEp = starbaseEpAmendment
1000             .starbaseEarlyPurchase()
1001             .numberOfEarlyPurchases();
1002 
1003         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
1004             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
1005                 continue;
1006             }
1007             var (purchaser, amount,) =
1008                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
1009                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
1010                 : starbaseEpAmendment.earlyPurchases(i);
1011             if (amount > 0) {
1012                 if (earlyPurchasedAmountBy[purchaser] == 0) {
1013                     earlyPurchasers.push(purchaser);
1014                 }
1015                 // each early purchaser receives 20% bonus
1016                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
1017                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
1018 
1019                 earlyPurchasedAmountBy[purchaser] += amountWithBonus;
1020             }
1021         }
1022 
1023         numOfLoadedEarlyPurchases += i;
1024         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
1025         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
1026             earlyPurchasesLoaded = true;    // enable the flag
1027         }
1028         return true;
1029     }
1030 
1031     /**
1032       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
1033       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
1034       * @param _amountCap Ether value which partner is able to contribute
1035       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
1036       */
1037     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
1038         external
1039         onlyOwner
1040     {
1041         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
1042         qualifiedPartners[_qualifiedPartner].bonaFide = true;
1043         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1044         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
1045         QualifiedPartnerAddress(_qualifiedPartner);
1046     }
1047 
1048     /**
1049      * @dev Remove address from qualified partners list.
1050      * @param _qualifiedPartner Address to be removed from the list.
1051      */
1052     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
1053         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1054         qualifiedPartners[_qualifiedPartner].bonaFide = false;
1055     }
1056 
1057     /**
1058      * @dev Update whitelisted address amount allowed to raise during the presale.
1059      * @param _qualifiedPartner Qualified Partner address to be updated.
1060      * @param _amountCap Amount that the address is able to raise during the presale.
1061      */
1062     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
1063         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
1064         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
1065     }
1066 
1067     /**
1068      * Public functions
1069      */
1070 
1071     /**
1072      * @dev Returns boolean for whether crowdsale has ended
1073      */
1074     function isEnded() constant public returns (bool) {
1075         return (endedAt > 0 && endedAt <= now);
1076     }
1077 
1078     /**
1079      * @dev Returns number of purchases to date.
1080      */
1081     function numOfPurchases() constant public returns (uint256) {
1082         return crowdsalePurchases.length;
1083     }
1084 
1085     /**
1086      * @dev Calculates total amount of tokens purchased includes bonus tokens.
1087      */
1088     function totalAmountOfCrowdsalePurchases() constant public returns (uint256 amount) {
1089         for (uint256 i; i < crowdsalePurchases.length; i++) {
1090             amount = SafeMath.add(amount, crowdsalePurchases[i].amount);
1091         }
1092     }
1093 
1094     /**
1095      * @dev Calculates total amount of tokens purchased without bonus conversion.
1096      */
1097     function totalAmountOfCrowdsalePurchasesWithoutBonus() constant public returns (uint256 amount) {
1098         for (uint256 i; i < crowdsalePurchases.length; i++) {
1099             amount = SafeMath.add(amount, crowdsalePurchases[i].rawAmount);
1100         }
1101     }
1102 
1103     /**
1104      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1105      */
1106     function totalRaisedAmountInCny() constant public returns (uint256) {
1107         return SafeMath.add(totalAmountOfEarlyPurchases(), totalAmountOfCrowdsalePurchases());
1108     }
1109 
1110     /**
1111      * @dev Returns total amount of early purchases in CNY
1112      */
1113     function totalAmountOfEarlyPurchases() constant public returns(uint256) {
1114        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1115     }
1116 
1117     /**
1118      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1119      */
1120     function purchaseAsQualifiedPartner()
1121         payable
1122         public
1123         rateIsSet(cnyEthRate)
1124         returns (bool)
1125     {
1126         require(qualifiedPartners[msg.sender].bonaFide);
1127         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1128 
1129         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1130 
1131         uint256 bonusTier = 30; // Pre sale purchasers get 30 percent bonus
1132         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1133         uint amount = recordPurchase(msg.sender, rawAmount, now, '', bonusTier);
1134 
1135         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1136             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1137         }
1138 
1139         StarBasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate, bonusTier);
1140         return true;
1141     }
1142 
1143     /**
1144      * @dev Allows user to purchase STAR tokens with Ether
1145      */
1146     function purchaseWithEth()
1147         payable
1148         public
1149         minInvestment
1150         whenNotEnded
1151         rateIsSet(cnyEthRate)
1152         returns (bool)
1153     {
1154         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1155         if (startDate == 0) {
1156             startCrowdsale(block.timestamp);
1157         }
1158 
1159         uint256 bonusTier = getBonusTier();
1160 
1161         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1162         uint amount = recordPurchase(msg.sender, rawAmount, now, '', bonusTier);
1163 
1164         StarBasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate, bonusTier);
1165         return true;
1166     }
1167 
1168     /**
1169      * Internal functions
1170      */
1171 
1172     /**
1173      * @dev Initializes Starbase crowdsale
1174      */
1175     function startCrowdsale(uint256 timestamp) internal {
1176         startDate = timestamp;
1177 
1178         // set token bonus milestones
1179         firstBonusSalesEnds = startDate + 7 days;             // 1. 1st ~ 7th day
1180         secondBonusSalesEnds = firstBonusSalesEnds + 14 days; // 2. 8th ~ 21st day
1181         thirdBonusSalesEnds = secondBonusSalesEnds + 14 days; // 3. 22nd ~ 35th day
1182         fourthBonusSalesEnds = thirdBonusSalesEnds + 7 days;  // 4. 36th ~ 42nd day
1183         fifthBonusSalesEnds = fourthBonusSalesEnds + 3 days;  // 5. 43rd ~ 45th day
1184 
1185         // extended sales bonus milestones
1186         firstExtendedBonusSalesEnds = fifthBonusSalesEnds + 3 days;         // 1. 46th ~ 48th day
1187         secondExtendedBonusSalesEnds = firstExtendedBonusSalesEnds + 3 days; // 2. 49th ~ 51st day
1188         thirdExtendedBonusSalesEnds = secondExtendedBonusSalesEnds + 3 days; // 3. 52nd ~ 54th day
1189         fourthExtendedBonusSalesEnds = thirdExtendedBonusSalesEnds + 3 days; // 4. 55th ~ 57th day
1190         fifthExtendedBonusSalesEnds = fourthExtendedBonusSalesEnds + 3 days;  // 5. 58th ~ 60th day
1191         sixthExtendedBonusSalesEnds = fifthExtendedBonusSalesEnds + 60 days; // 6. 61st ~ 120th day
1192     }
1193 
1194     /**
1195      * @dev Abstract record of a purchase to Tokens
1196      * @param purchaser Address of the buyer
1197      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1198      * @param timestamp Timestamp at the purchase made
1199      * @param data Identifier as an evidence of the purchase (e.g. btc:1xyzxyz)
1200      * @param bonusTier bonus milestones of the purchase
1201      */
1202     function recordPurchase(
1203         address purchaser,
1204         uint256 rawAmount,
1205         uint256 timestamp,
1206         string data,
1207         uint256 bonusTier
1208     )
1209         internal
1210         returns(uint256 amount)
1211     {
1212         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1213 
1214         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1215         if (block.number >= purchaseStartBlock) {
1216 
1217             assert(totalAmountOfCrowdsalePurchasesWithoutBonus() <= MAX_CROWDSALE_CAP);
1218 
1219             uint256 crowdsaleTotalAmountAfterPurchase = SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus(), amount);
1220 
1221             // check whether purchase goes over the cap and send the difference back to the purchaser.
1222             if (crowdsaleTotalAmountAfterPurchase > MAX_CROWDSALE_CAP) {
1223               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, MAX_CROWDSALE_CAP);
1224               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1225               purchaser.transfer(ethValueToReturn);
1226               amount = SafeMath.sub(amount, difference);
1227               rawAmount = amount;
1228             }
1229 
1230         }
1231 
1232         uint256 covertedAmountwWithBonus = SafeMath.mul(amount, bonusTier) / 100;
1233         amount = SafeMath.add(amount, covertedAmountwWithBonus); // at this point amount bonus is calculated
1234 
1235         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp, data, bonusTier);
1236         crowdsalePurchases.push(purchase);
1237         return amount;
1238     }
1239 
1240     /**
1241      * @dev Fetchs Bonus tier percentage per bonus milestones
1242      */
1243     function getBonusTier() internal returns (uint256) {
1244         bool firstBonusSalesPeriod = now >= startDate && now <= firstBonusSalesEnds; // 1st ~ 7th day get 20% bonus
1245         bool secondBonusSalesPeriod = now > firstBonusSalesEnds && now <= secondBonusSalesEnds; // 8th ~ 21st day get 15% bonus
1246         bool thirdBonusSalesPeriod = now > secondBonusSalesEnds && now <= thirdBonusSalesEnds; // 22nd ~ 35th day get 10% bonus
1247         bool fourthBonusSalesPeriod = now > thirdBonusSalesEnds && now <= fourthBonusSalesEnds; // 36th ~ 42nd day get 5% bonus
1248         bool fifthBonusSalesPeriod = now > fourthBonusSalesEnds && now <= fifthBonusSalesEnds; // 43rd and 45th day get 0% bonus
1249 
1250         // extended bonus sales
1251         bool firstExtendedBonusSalesPeriod = now > fifthBonusSalesEnds && now <= firstExtendedBonusSalesEnds; // extended sales 46th ~ 48th day get 20% bonus
1252         bool secondExtendedBonusSalesPeriod = now > firstExtendedBonusSalesEnds && now <= secondExtendedBonusSalesEnds; // 49th ~ 51st 15% bonus
1253         bool thirdExtendedBonusSalesPeriod = now > secondExtendedBonusSalesEnds && now <= thirdExtendedBonusSalesEnds; // 52nd ~ 54th day get 10% bonus
1254         bool fourthExtendedBonusSalesPeriod = now > thirdExtendedBonusSalesEnds && now <= fourthExtendedBonusSalesEnds; // 55th ~ 57th day day get 5% bonus
1255         bool fifthExtendedBonusSalesPeriod = now > fourthExtendedBonusSalesEnds && now <= fifthExtendedBonusSalesEnds; // 58th ~ 60th day get 0% bonus
1256         bool sixthExtendedBonusSalesPeriod = now > fifthExtendedBonusSalesEnds && now <= sixthExtendedBonusSalesEnds; // 61st ~ 120th day get {number_of_days} - 60 * 1% bonus
1257 
1258         if (firstBonusSalesPeriod || firstExtendedBonusSalesPeriod) return 20;
1259         if (secondBonusSalesPeriod || secondExtendedBonusSalesPeriod) return 15;
1260         if (thirdBonusSalesPeriod || thirdExtendedBonusSalesPeriod) return 10;
1261         if (fourthBonusSalesPeriod || fourthExtendedBonusSalesPeriod) return 5;
1262         if (fifthBonusSalesPeriod || fifthExtendedBonusSalesPeriod) return 0;
1263 
1264         if (sixthExtendedBonusSalesPeriod) {
1265           uint256 DAY_IN_SECONDS = 86400;
1266           uint256 secondsSinceStartDate = SafeMath.sub(now, startDate);
1267           uint256 numberOfDays = secondsSinceStartDate / DAY_IN_SECONDS;
1268 
1269           return SafeMath.sub(numberOfDays, 60);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Fetchs Bonus tier percentage per bonus milestones
1275      * @dev qualifiedPartner Address of partners that participated in pre sale
1276      * @dev amountSent Value sent by qualified partner
1277      */
1278     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1279         //calculate the commission fee to send to qualified partner
1280         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1281 
1282         // send commission fee amount
1283         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1284     }
1285 
1286     /**
1287      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1288      */
1289     function redirectToPurchase() internal {
1290         if (block.number < purchaseStartBlock) {
1291             purchaseAsQualifiedPartner();
1292         } else {
1293             purchaseWithEth();
1294         }
1295     }
1296 }