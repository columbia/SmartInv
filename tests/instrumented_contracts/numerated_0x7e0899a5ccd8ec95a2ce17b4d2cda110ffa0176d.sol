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
91 contract StarbaseEarlyPurchase {
92     /*
93      *  Constants
94      */
95     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
96     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
97     uint public constant PURCHASE_AMOUNT_CAP = 9000000;
98 
99     /*
100      *  Types
101      */
102     struct EarlyPurchase {
103         address purchaser;
104         uint amount;        // CNY based amount
105         uint purchasedAt;   // timestamp
106     }
107 
108     /*
109      *  External contracts
110      */
111     AbstractStarbaseCrowdsale public starbaseCrowdsale;
112 
113     /*
114      *  Storage
115      */
116     address public owner;
117     EarlyPurchase[] public earlyPurchases;
118     uint public earlyPurchaseClosedAt;
119 
120     /*
121      *  Modifiers
122      */
123     modifier noEther() {
124         if (msg.value > 0) {
125             throw;
126         }
127         _;
128     }
129 
130     modifier onlyOwner() {
131         if (msg.sender != owner) {
132             throw;
133         }
134         _;
135     }
136 
137     modifier onlyBeforeCrowdsale() {
138         if (address(starbaseCrowdsale) != 0 &&
139             starbaseCrowdsale.startDate() > 0)
140         {
141             throw;
142         }
143         _;
144     }
145 
146     modifier onlyEarlyPurchaseTerm() {
147         if (earlyPurchaseClosedAt > 0) {
148             throw;
149         }
150         _;
151     }
152 
153     /*
154      *  Contract functions
155      */
156     /// @dev Returns early purchased amount by purchaser's address
157     /// @param purchaser Purchaser address
158     function purchasedAmountBy(address purchaser)
159         external
160         constant
161         noEther
162         returns (uint amount)
163     {
164         for (uint i; i < earlyPurchases.length; i++) {
165             if (earlyPurchases[i].purchaser == purchaser) {
166                 amount += earlyPurchases[i].amount;
167             }
168         }
169     }
170 
171     /// @dev Returns total amount of raised funds by Early Purchasers
172     function totalAmountOfEarlyPurchases()
173         constant
174         noEther
175         returns (uint totalAmount)
176     {
177         for (uint i; i < earlyPurchases.length; i++) {
178             totalAmount += earlyPurchases[i].amount;
179         }
180     }
181 
182     /// @dev Returns number of early purchases
183     function numberOfEarlyPurchases()
184         external
185         constant
186         noEther
187         returns (uint)
188     {
189         return earlyPurchases.length;
190     }
191 
192     /// @dev Append an early purchase log
193     /// @param purchaser Purchaser address
194     /// @param amount Purchase amount
195     /// @param purchasedAt Timestamp of purchased date
196     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
197         external
198         noEther
199         onlyOwner
200         onlyBeforeCrowdsale
201         onlyEarlyPurchaseTerm
202         returns (bool)
203     {
204         if (amount == 0 ||
205             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
206         {
207             return false;
208         }
209 
210         if (purchasedAt == 0 || purchasedAt > now) {
211             throw;
212         }
213 
214         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
215         return true;
216     }
217 
218     /// @dev Close early purchase term
219     function closeEarlyPurchase()
220         external
221         noEther
222         onlyOwner
223         returns (bool)
224     {
225         earlyPurchaseClosedAt = now;
226     }
227 
228     /// @dev Setup function sets external contract's address
229     /// @param starbaseCrowdsaleAddress Token address
230     function setup(address starbaseCrowdsaleAddress)
231         external
232         noEther
233         onlyOwner
234         returns (bool)
235     {
236         if (address(starbaseCrowdsale) == 0) {
237             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
238             return true;
239         }
240         return false;
241     }
242 
243     /// @dev Contract constructor function
244     function StarbaseEarlyPurchase() noEther {
245         owner = msg.sender;
246     }
247 
248     /// @dev Fallback function always fails
249     function () {
250         throw;
251     }
252 }
253 
254 
255 contract StarbaseEarlyPurchaseAmendment {
256     /*
257      *  Events
258      */
259     event EarlyPurchaseInvalidated(uint epIdx);
260     event EarlyPurchaseAmended(uint epIdx);
261 
262     /*
263      *  External contracts
264      */
265     AbstractStarbaseCrowdsale public starbaseCrowdsale;
266     StarbaseEarlyPurchase public starbaseEarlyPurchase;
267 
268     /*
269      *  Storage
270      */
271     address public owner;
272     uint[] public invalidEarlyPurchaseIndexes;
273     uint[] public amendedEarlyPurchaseIndexes;
274     mapping (uint => StarbaseEarlyPurchase.EarlyPurchase) public amendedEarlyPurchases;
275 
276     /*
277      *  Modifiers
278      */
279     modifier noEther() {
280         if (msg.value > 0) {
281             throw;
282         }
283         _;
284     }
285 
286     modifier onlyOwner() {
287         if (msg.sender != owner) {
288             throw;
289         }
290         _;
291     }
292 
293     modifier onlyBeforeCrowdsale() {
294         if (address(starbaseCrowdsale) != 0 &&
295             starbaseCrowdsale.startDate() > 0)
296         {
297             throw;
298         }
299         _;
300     }
301 
302     modifier onlyEarlyPurchasesLoaded() {
303         if (address(starbaseEarlyPurchase) == 0) {
304             throw;
305         }
306         _;
307     }
308 
309     /*
310      *  Contract functions are compatible with original ones
311      */
312     /// @dev Returns an early purchase record
313     /// @param earlyPurchaseIndex Index number of an early purchase
314     function earlyPurchases(uint earlyPurchaseIndex)
315         external
316         constant
317         onlyEarlyPurchasesLoaded
318         returns (address purchaser, uint amount, uint purchasedAt)
319     {
320         return starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
321     }
322 
323     /// @dev Returns early purchased amount by purchaser's address
324     /// @param purchaser Purchaser address
325     function purchasedAmountBy(address purchaser)
326         external
327         constant
328         noEther
329         returns (uint amount)
330     {
331         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
332             normalizedEarlyPurchases();
333         for (uint i; i < normalizedEP.length; i++) {
334             if (normalizedEP[i].purchaser == purchaser) {
335                 amount += normalizedEP[i].amount;
336             }
337         }
338     }
339 
340     /// @dev Returns total amount of raised funds by Early Purchasers
341     function totalAmountOfEarlyPurchases()
342         constant
343         noEther
344         returns (uint totalAmount)
345     {
346         StarbaseEarlyPurchase.EarlyPurchase[] memory normalizedEP =
347             normalizedEarlyPurchases();
348         for (uint i; i < normalizedEP.length; i++) {
349             totalAmount += normalizedEP[i].amount;
350         }
351     }
352 
353     /// @dev Returns number of early purchases
354     function numberOfEarlyPurchases()
355         external
356         constant
357         noEther
358         returns (uint)
359     {
360         return normalizedEarlyPurchases().length;
361     }
362 
363     /// @dev Setup function sets external contract's address
364     /// @param starbaseCrowdsaleAddress Token address
365     function setup(address starbaseCrowdsaleAddress)
366         external
367         noEther
368         onlyOwner
369         returns (bool)
370     {
371         if (address(starbaseCrowdsale) == 0) {
372             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
373             return true;
374         }
375         return false;
376     }
377 
378     /*
379      *  Contract functions
380      */
381     function invalidateEarlyPurchase(uint earlyPurchaseIndex)
382         external
383         noEther
384         onlyOwner
385         onlyEarlyPurchasesLoaded
386         onlyBeforeCrowdsale
387         returns (bool)
388     {
389         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
390             throw;  // Array Index Out of Bounds Exception
391         }
392 
393         for (uint i; i < invalidEarlyPurchaseIndexes.length; i++) {
394             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
395                 throw;  // disallow duplicated invalidation
396             }
397         }
398 
399         invalidEarlyPurchaseIndexes.push(earlyPurchaseIndex);
400         EarlyPurchaseInvalidated(earlyPurchaseIndex);
401         return true;
402     }
403 
404     function isInvalidEarlyPurchase(uint earlyPurchaseIndex)
405         constant
406         noEther
407         returns (bool)
408     {
409         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
410             throw;  // Array Index Out of Bounds Exception
411         }
412 
413         for (uint i; i < invalidEarlyPurchaseIndexes.length; i++) {
414             if (invalidEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
415                 return true;
416             }
417         }
418         return false;
419     }
420 
421     function amendEarlyPurchase(uint earlyPurchaseIndex, address purchaser, uint amount, uint purchasedAt)
422         external
423         noEther
424         onlyOwner
425         onlyEarlyPurchasesLoaded
426         onlyBeforeCrowdsale
427         returns (bool)
428     {
429         if (purchasedAt == 0 || purchasedAt > now) {
430             throw;
431         }
432 
433         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
434             throw;  // Array Index Out of Bounds Exception
435         }
436 
437         if (isInvalidEarlyPurchase(earlyPurchaseIndex)) {
438             throw;  // Invalid early purchase cannot be amended
439         }
440 
441         if (!isAmendedEarlyPurchase(earlyPurchaseIndex)) {
442             amendedEarlyPurchaseIndexes.push(earlyPurchaseIndex);
443         }
444 
445         amendedEarlyPurchases[earlyPurchaseIndex] =
446             StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
447         EarlyPurchaseAmended(earlyPurchaseIndex);
448         return true;
449     }
450 
451     function isAmendedEarlyPurchase(uint earlyPurchaseIndex)
452         constant
453         noEther
454         returns (bool)
455     {
456         if (numberOfRawEarlyPurchases() <= earlyPurchaseIndex) {
457             throw;  // Array Index Out of Bounds Exception
458         }
459 
460         for (uint i; i < amendedEarlyPurchaseIndexes.length; i++) {
461             if (amendedEarlyPurchaseIndexes[i] == earlyPurchaseIndex) {
462                 return true;
463             }
464         }
465         return false;
466     }
467 
468     function loadStarbaseEarlyPurchases(address starbaseEarlyPurchaseAddress)
469         external
470         noEther
471         onlyOwner
472         onlyBeforeCrowdsale
473         returns (bool)
474     {
475         if (starbaseEarlyPurchaseAddress == 0 ||
476             address(starbaseEarlyPurchase) != 0)
477         {
478             throw;
479         }
480 
481         starbaseEarlyPurchase = StarbaseEarlyPurchase(starbaseEarlyPurchaseAddress);
482         if (starbaseEarlyPurchase.earlyPurchaseClosedAt() == 0) {
483             throw;   // the early purchase must be closed
484         }
485         return true;
486     }
487 
488     /// @dev Contract constructor function
489     function StarbaseEarlyPurchaseAmendment() noEther {
490         owner = msg.sender;
491     }
492 
493     /// @dev Fallback function always fails
494     function () {
495         throw;
496     }
497 
498     /**
499      * Internal functions
500      */
501     function normalizedEarlyPurchases()
502         constant
503         internal
504         returns (StarbaseEarlyPurchase.EarlyPurchase[] normalizedEP)
505     {
506         uint rawEPCount = numberOfRawEarlyPurchases();
507         normalizedEP = new StarbaseEarlyPurchase.EarlyPurchase[](
508             rawEPCount - invalidEarlyPurchaseIndexes.length);
509 
510         uint normalizedIdx;
511         for (uint i; i < rawEPCount; i++) {
512             if (isInvalidEarlyPurchase(i)) {
513                 continue;   // invalid early purchase should be ignored
514             }
515 
516             StarbaseEarlyPurchase.EarlyPurchase memory ep;
517             if (isAmendedEarlyPurchase(i)) {
518                 ep = amendedEarlyPurchases[i];  // amended early purchase should take a priority
519             } else {
520                 ep = getEarlyPurchase(i);
521             }
522 
523             normalizedEP[normalizedIdx] = ep;
524             normalizedIdx++;
525         }
526     }
527 
528     function getEarlyPurchase(uint earlyPurchaseIndex)
529         internal
530         constant
531         onlyEarlyPurchasesLoaded
532         returns (StarbaseEarlyPurchase.EarlyPurchase)
533     {
534         var (purchaser, amount, purchasedAt) =
535             starbaseEarlyPurchase.earlyPurchases(earlyPurchaseIndex);
536         return StarbaseEarlyPurchase.EarlyPurchase(purchaser, amount, purchasedAt);
537     }
538 
539     function numberOfRawEarlyPurchases()
540         internal
541         constant
542         onlyEarlyPurchasesLoaded
543         returns (uint)
544     {
545         return starbaseEarlyPurchase.numberOfEarlyPurchases();
546     }
547 }
548 
549 contract Certifier {
550 	event Confirmed(address indexed who);
551 	event Revoked(address indexed who);
552 	function certified(address) public constant returns (bool);
553 	function get(address, string) public constant returns (bytes32);
554 	function getAddress(address, string) public constant returns (address);
555 	function getUint(address, string) public constant returns (uint);
556 }
557 
558 /**
559  * @title Crowdsale contract - Starbase crowdsale to create STAR.
560  * @author Starbase PTE. LTD. - <info@starbase.co>
561  */
562 contract StarbaseCrowdsale is Ownable {
563     using SafeMath for uint256;
564     /*
565      *  Events
566      */
567     event CrowdsaleEnded(uint256 endedAt);
568     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate);
569     event CnyEthRateUpdated(uint256 cnyEthRate);
570     event CnyBtcRateUpdated(uint256 cnyBtcRate);
571     event QualifiedPartnerAddress(address qualifiedPartner);
572 
573     /**
574      *  External contracts
575      */
576     AbstractStarbaseToken public starbaseToken;
577     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
578     Certifier public picopsCertifier;
579 
580     /**
581      *  Constants
582      */
583     uint256 constant public crowdsaleTokenAmount = 125000000e18;
584     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
585     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
586     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
587     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
588 
589     /**
590      * Types
591      */
592     struct CrowdsalePurchase {
593         address purchaser;
594         uint256 amount;        // CNY based amount with bonus
595         uint256 rawAmount;     // CNY based amount no bonus
596         uint256 purchasedAt;   // timestamp
597     }
598 
599     struct QualifiedPartners {
600         uint256 amountCap;
601         uint256 amountRaised;
602         bool    bonaFide;
603         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
604     }
605 
606     /*
607      *  Enums
608      */
609     enum BonusMilestones {
610         First,
611         Second,
612         Third,
613         Fourth,
614         Fifth
615     }
616 
617     // Initialize bonusMilestones
618     BonusMilestones public bonusMilestones = BonusMilestones.First;
619 
620     /**
621      *  Storage
622      */
623     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
624     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
625     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
626 
627     // early purchase
628     address[] public earlyPurchasers;
629     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
630     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
631     uint256 public totalAmountOfEarlyPurchasesInCny; // including 20% bonus
632 
633     // crowdsale
634     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
635     uint256 public totalAmountOfPurchasesInCny; // totalEP + totalPreSale + totalCrowdsale (including bonuses)
636     mapping (address => QualifiedPartners) public qualifiedPartners;
637     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
638     uint256 public startDate;
639     uint256 public endedAt;
640     CrowdsalePurchase[] public crowdsalePurchases;
641     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
642     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
643     uint256 public cnyEthRate;
644 
645     // bonus milestones
646     uint256 public firstBonusEnds;
647     uint256 public secondBonusEnds;
648     uint256 public thirdBonusEnds;
649     uint256 public fourthBonusEnds;
650 
651     // after the crowdsale
652     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
653     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
654 
655     /**
656      *  Modifiers
657      */
658     modifier minInvestment() {
659         // User has to send at least the ether value of one token.
660         assert(msg.value >= MIN_INVESTMENT);
661         _;
662     }
663 
664     modifier whenEnded() {
665         assert(isEnded());
666         _;
667     }
668 
669     modifier hasBalance() {
670         assert(this.balance > 0);
671         _;
672     }
673     modifier rateIsSet(uint256 _rate) {
674         assert(_rate != 0);
675         _;
676     }
677 
678     modifier whenNotEnded() {
679         assert(!isEnded());
680         _;
681     }
682 
683     modifier tokensNotDelivered() {
684         assert(numOfDeliveredCrowdsalePurchases == 0);
685         assert(numOfDeliveredEarlyPurchases == 0);
686         _;
687     }
688 
689     modifier onlyFundraiser() {
690         assert(address(starbaseToken) != 0);
691         assert(starbaseToken.isFundraiser(msg.sender));
692         _;
693     }
694 
695     modifier onlyQualifiedPartner() {
696         assert(qualifiedPartners[msg.sender].bonaFide);
697         _;
698     }
699 
700     modifier onlyQualifiedPartnerORPicopsCertified() {
701         assert(qualifiedPartners[msg.sender].bonaFide || picopsCertifier.certified(msg.sender));
702         _;
703     }
704 
705     /**
706      * Contract functions
707      */
708     /**
709      * @dev Contract constructor function sets owner address and
710      *      address of StarbaseEarlyPurchaseAmendment contract.
711      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
712      * @param picopsCertifierAddr The address of the PICOPS certifier.
713      *                            See also https://picops.parity.io/#/details
714      */
715     function StarbaseCrowdsale(address starbaseEpAddr, address picopsCertifierAddr) {
716         require(starbaseEpAddr != 0 && picopsCertifierAddr != 0);
717         owner = msg.sender;
718         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
719         picopsCertifier = Certifier(picopsCertifierAddr);
720     }
721 
722     /**
723      * @dev Fallback accepts payment for Star tokens with Eth
724      */
725     function() payable {
726         redirectToPurchase();
727     }
728 
729     /**
730      * External functions
731      */
732 
733     /**
734      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
735      * @param starbaseTokenAddress Token address.
736      * @param _purchaseStartBlock Block number to start crowdsale
737      */
738     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
739         external
740         onlyOwner
741         returns (bool)
742     {
743         require(starbaseTokenAddress != address(0));
744         require(address(starbaseToken) == 0);
745         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
746         purchaseStartBlock = _purchaseStartBlock;
747 
748         // set the max cap of this crowdsale
749         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesWithoutBonus());
750 
751         assert(maxCrowdsaleCap > 0);
752 
753         return true;
754     }
755 
756     /**
757      * @dev Transfers raised funds to company's wallet address at any given time.
758      */
759     function withdrawForCompany()
760         external
761         onlyFundraiser
762         hasBalance
763     {
764         address company = starbaseToken.company();
765         require(company != address(0));
766         company.transfer(this.balance);
767     }
768 
769     /**
770      * @dev Update start block Number for the crowdsale
771      */
772     function updatePurchaseStartBlock(uint256 _purchaseStartBlock)
773         external
774         onlyFundraiser
775         returns (bool)
776     {
777         require(startDate == 0);
778         purchaseStartBlock = _purchaseStartBlock;
779         return true;
780     }
781 
782     /**
783      * @dev Update the CNY/ETH rate to record purchases in CNY
784      */
785     function updateCnyEthRate(uint256 rate)
786         external
787         onlyFundraiser
788         returns (bool)
789     {
790         cnyEthRate = rate;
791         CnyEthRateUpdated(cnyEthRate);
792         return true;
793     }
794 
795     /**
796      * @dev Update the CNY/BTC rate to record purchases in CNY
797      */
798     function updateCnyBtcRate(uint256 rate)
799         external
800         onlyFundraiser
801         returns (bool)
802     {
803         cnyBtcRate = rate;
804         CnyBtcRateUpdated(cnyBtcRate);
805         return true;
806     }
807 
808     /**
809      * @dev Allow for the possibility for contract owner to start crowdsale
810      */
811     function ownerStartsCrowdsale(uint256 timestamp)
812         external
813         onlyOwner
814     {
815         assert(startDate == 0 && block.number >= purchaseStartBlock);   // overwriting startDate is not permitted and it should be after the crowdsale start block
816         startCrowdsale(timestamp);
817     }
818 
819     /**
820      * @dev Ends crowdsale
821      * @param timestamp Timestamp at the crowdsale ended
822      */
823     function endCrowdsale(uint256 timestamp)
824         external
825         onlyOwner
826     {
827         assert(timestamp > 0 && timestamp <= now);
828         assert(block.number > purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
829         endedAt = timestamp;
830         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchasesWithBonus();
831         totalAmountOfPurchasesInCny = totalRaisedAmountInCny();
832         CrowdsaleEnded(endedAt);
833     }
834 
835     /**
836      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
837      */
838     function withdrawPurchasedTokens()
839         external
840         whenEnded
841         returns (bool)
842     {
843         assert(earlyPurchasesLoaded);
844         assert(address(starbaseToken) != 0);
845 
846         /*
847          * “Value” refers to the contribution of the User:
848          *  {crowdsale_purchaser_token_amount} =
849          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
850          *
851          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
852          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
853          * and total amount raised during the Contribution Period is 30’000’000, then he will get
854          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
855         */
856 
857         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
858             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
859             crowdsalePurchaseAmountBy[msg.sender] = 0;
860 
861             uint256 tokenCount =
862                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
863                 totalAmountOfPurchasesInCny;
864 
865             numOfPurchasedTokensOnCsBy[msg.sender] =
866                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
867             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
868             numOfDeliveredCrowdsalePurchases++;
869         }
870 
871         /*
872          * “Value” refers to the contribution of the User:
873          * {earlypurchaser_token_amount} =
874          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
875          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
876          *
877          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
878          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
879          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
880          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
881          * 30’000’000 CNY + 6’000’000 CNY
882          */
883 
884         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
885             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
886             earlyPurchasedAmountBy[msg.sender] = 0;
887 
888             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchasesInCny;
889 
890             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfPurchasesInCny;
891 
892             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
893 
894             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
895             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
896             numOfDeliveredEarlyPurchases++;
897         }
898 
899         return true;
900     }
901 
902     /**
903      * @dev Load early purchases from the contract keeps track of them
904      */
905     function loadEarlyPurchases() external onlyOwner returns (bool) {
906         if (earlyPurchasesLoaded) {
907             return false;    // all EPs have already been loaded
908         }
909 
910         uint256 numOfOrigEp = starbaseEpAmendment
911             .starbaseEarlyPurchase()
912             .numberOfEarlyPurchases();
913 
914         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
915             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
916                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
917                 continue;
918             }
919             var (purchaser, amount,) =
920                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
921                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
922                 : starbaseEpAmendment.earlyPurchases(i);
923             if (amount > 0) {
924                 if (earlyPurchasedAmountBy[purchaser] == 0) {
925                     earlyPurchasers.push(purchaser);
926                 }
927                 // each early purchaser receives 20% bonus
928                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
929                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
930 
931                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
932             }
933 
934             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
935         }
936 
937         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
938         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
939             earlyPurchasesLoaded = true;    // enable the flag
940         }
941         return true;
942     }
943 
944     /**
945       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
946       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
947       * @param _amountCap Ether value which partner is able to contribute
948       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
949       */
950     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
951         external
952         onlyOwner
953     {
954         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
955         qualifiedPartners[_qualifiedPartner].bonaFide = true;
956         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
957         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
958         QualifiedPartnerAddress(_qualifiedPartner);
959     }
960 
961     /**
962      * @dev Remove address from qualified partners list.
963      * @param _qualifiedPartner Address to be removed from the list.
964      */
965     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
966         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
967         qualifiedPartners[_qualifiedPartner].bonaFide = false;
968     }
969 
970     /**
971      * @dev Update whitelisted address amount allowed to raise during the presale.
972      * @param _qualifiedPartner Qualified Partner address to be updated.
973      * @param _amountCap Amount that the address is able to raise during the presale.
974      */
975     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
976         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
977         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
978     }
979 
980     /**
981      * Public functions
982      */
983 
984     /**
985      * @dev Returns boolean for whether crowdsale has ended
986      */
987     function isEnded() constant public returns (bool) {
988         return (endedAt > 0 && endedAt <= now);
989     }
990 
991     /**
992      * @dev Returns number of purchases to date.
993      */
994     function numOfPurchases() constant public returns (uint256) {
995         return crowdsalePurchases.length;
996     }
997 
998     /**
999      * @dev Calculates total amount of tokens purchased includes bonus tokens.
1000      */
1001     function totalAmountOfCrowdsalePurchases() constant public returns (uint256 amount) {
1002         for (uint256 i; i < crowdsalePurchases.length; i++) {
1003             amount = SafeMath.add(amount, crowdsalePurchases[i].amount);
1004         }
1005     }
1006 
1007     /**
1008      * @dev Calculates total amount of tokens purchased without bonus conversion.
1009      */
1010     function totalAmountOfCrowdsalePurchasesWithoutBonus() constant public returns (uint256 amount) {
1011         for (uint256 i; i < crowdsalePurchases.length; i++) {
1012             amount = SafeMath.add(amount, crowdsalePurchases[i].rawAmount);
1013         }
1014     }
1015 
1016     /**
1017      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1018      */
1019     function totalRaisedAmountInCny() constant public returns (uint256) {
1020         return SafeMath.add(totalAmountOfEarlyPurchasesWithBonus(), totalAmountOfCrowdsalePurchases());
1021     }
1022 
1023     /**
1024      * @dev Returns total amount of early purchases in CNY and bonuses
1025      */
1026     function totalAmountOfEarlyPurchasesWithBonus() constant public returns(uint256) {
1027        return starbaseEpAmendment.totalAmountOfEarlyPurchases().mul(120).div(100);
1028     }
1029 
1030     /**
1031      * @dev Returns total amount of early purchases in CNY
1032      */
1033     function totalAmountOfEarlyPurchasesWithoutBonus() constant public returns(uint256) {
1034        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1035     }
1036 
1037     /**
1038      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1039      */
1040     function purchaseAsQualifiedPartner()
1041         payable
1042         public
1043         rateIsSet(cnyEthRate)
1044         onlyQualifiedPartner
1045         returns (bool)
1046     {
1047         require(msg.value > 0);
1048         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1049 
1050         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1051 
1052         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1053         recordPurchase(msg.sender, rawAmount, now);
1054 
1055         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1056             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1057         }
1058 
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev Allows user to purchase STAR tokens with Ether
1064      */
1065     function purchaseWithEth()
1066         payable
1067         public
1068         minInvestment
1069         whenNotEnded
1070         rateIsSet(cnyEthRate)
1071         onlyQualifiedPartnerORPicopsCertified
1072         returns (bool)
1073     {
1074         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1075 
1076         if (startDate == 0) {
1077             startCrowdsale(block.timestamp);
1078         }
1079 
1080         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1081         recordPurchase(msg.sender, rawAmount, now);
1082 
1083         return true;
1084     }
1085 
1086     /**
1087      * Internal functions
1088      */
1089 
1090     /**
1091      * @dev Initializes Starbase crowdsale
1092      */
1093     function startCrowdsale(uint256 timestamp) internal {
1094         startDate = timestamp;
1095         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus();
1096         if (maxCrowdsaleCap > presaleAmount) {
1097             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1098             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1099 
1100             // set token bonus milestones in cny total crowdsale purchase
1101             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1102             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1103             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1104             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1105         }
1106     }
1107 
1108     /**
1109      * @dev Abstract record of a purchase to Tokens
1110      * @param purchaser Address of the buyer
1111      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1112      * @param timestamp Timestamp at the purchase made
1113      */
1114     function recordPurchase(
1115         address purchaser,
1116         uint256 rawAmount,
1117         uint256 timestamp
1118     )
1119         internal
1120         returns(uint256 amount)
1121     {
1122         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1123 
1124         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1125         if (block.number >= purchaseStartBlock) {
1126             require(totalAmountOfCrowdsalePurchasesWithoutBonus() < maxCrowdsaleCap);   // check if the amount has already reached the cap
1127 
1128             uint256 crowdsaleTotalAmountAfterPurchase =
1129                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus(), amount);
1130 
1131             // check whether purchase goes over the cap and send the difference back to the purchaser.
1132             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1133               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1134               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1135               purchaser.transfer(ethValueToReturn);
1136               amount = SafeMath.sub(amount, difference);
1137               rawAmount = amount;
1138             }
1139 
1140         }
1141 
1142         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1143 
1144         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1145         crowdsalePurchases.push(purchase);
1146         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1147         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1148         return amount;
1149     }
1150 
1151     /**
1152      * @dev Calculates amount with bonus for bonus milestones
1153      */
1154     function calculateBonus
1155         (
1156             BonusMilestones nextMilestone,
1157             uint256 amount,
1158             uint256 bonusRange,
1159             uint256 bonusTier,
1160             uint256 results
1161         )
1162         internal
1163         returns (uint256 result, uint256 newAmount)
1164     {
1165         uint256 bonusCalc;
1166 
1167         if (amount <= bonusRange) {
1168             bonusCalc = amount.mul(bonusTier).div(100);
1169 
1170             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus()) >= bonusRange)
1171                 bonusMilestones = nextMilestone;
1172 
1173             result = results.add(amount).add(bonusCalc);
1174             newAmount = 0;
1175 
1176         } else {
1177             bonusCalc = bonusRange.mul(bonusTier).div(100);
1178             bonusMilestones = nextMilestone;
1179             result = results.add(bonusRange).add(bonusCalc);
1180             newAmount = amount.sub(bonusRange);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Fetchs Bonus tier percentage per bonus milestones
1186      */
1187     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1188         if (block.number < purchaseStartBlock) {
1189             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1190             return amount.add(bonusFromAmount);
1191         }
1192 
1193         // range of each bonus milestones
1194         uint256 firstBonusRange = firstBonusEnds;
1195         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1196         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1197         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1198         uint256 result;
1199 
1200         if (bonusMilestones == BonusMilestones.First)
1201             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1202 
1203         if (bonusMilestones == BonusMilestones.Second)
1204             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1205 
1206         if (bonusMilestones == BonusMilestones.Third)
1207             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1208 
1209         if (bonusMilestones == BonusMilestones.Fourth)
1210             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1211 
1212         return result.add(amount);
1213     }
1214 
1215     /**
1216      * @dev Fetchs Bonus tier percentage per bonus milestones
1217      * @dev qualifiedPartner Address of partners that participated in pre sale
1218      * @dev amountSent Value sent by qualified partner
1219      */
1220     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1221         //calculate the commission fee to send to qualified partner
1222         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1223 
1224         // send commission fee amount
1225         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1226     }
1227 
1228     /**
1229      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1230      */
1231     function redirectToPurchase() internal {
1232         if (block.number < purchaseStartBlock) {
1233             purchaseAsQualifiedPartner();
1234         } else {
1235             purchaseWithEth();
1236         }
1237     }
1238 }