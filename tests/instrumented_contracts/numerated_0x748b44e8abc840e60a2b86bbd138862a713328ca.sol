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
631     uint256 public totalAmountOfEarlyPurchasesInCny;
632 
633     // crowdsale
634     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
635     uint256 public totalAmountOfPurchasesInCny; // totalPreSale + totalCrowdsale
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
748         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
749 
750         // set the max cap of this crowdsale
751         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesInCny);
752 
753         assert(maxCrowdsaleCap > 0);
754 
755         return true;
756     }
757 
758     /**
759      * @dev Transfers raised funds to company's wallet address at any given time.
760      */
761     function withdrawForCompany()
762         external
763         onlyFundraiser
764         hasBalance
765     {
766         address company = starbaseToken.company();
767         require(company != address(0));
768         company.transfer(this.balance);
769     }
770 
771     /**
772      * @dev Update the CNY/ETH rate to record purchases in CNY
773      */
774     function updateCnyEthRate(uint256 rate)
775         external
776         onlyFundraiser
777         returns (bool)
778     {
779         cnyEthRate = rate;
780         CnyEthRateUpdated(cnyEthRate);
781         return true;
782     }
783 
784     /**
785      * @dev Update the CNY/BTC rate to record purchases in CNY
786      */
787     function updateCnyBtcRate(uint256 rate)
788         external
789         onlyFundraiser
790         returns (bool)
791     {
792         cnyBtcRate = rate;
793         CnyBtcRateUpdated(cnyBtcRate);
794         return true;
795     }
796 
797     /**
798      * @dev Allow for the possibility for contract owner to start crowdsale
799      */
800     function ownerStartsCrowdsale(uint256 timestamp)
801         external
802         onlyOwner
803     {
804         assert(startDate == 0 && block.number >= purchaseStartBlock);   // overwriting startDate is not permitted and it should be after the crowdsale start block
805         startCrowdsale(timestamp);
806     }
807 
808     /**
809      * @dev Ends crowdsale
810      * @param timestamp Timestamp at the crowdsale ended
811      */
812     function endCrowdsale(uint256 timestamp)
813         external
814         onlyOwner
815     {
816         assert(timestamp > 0 && timestamp <= now);
817         assert(block.number > purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
818         endedAt = timestamp;
819         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
820         totalAmountOfPurchasesInCny = totalRaisedAmountInCny();
821         CrowdsaleEnded(endedAt);
822     }
823 
824     /**
825      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
826      */
827     function withdrawPurchasedTokens()
828         external
829         whenEnded
830         returns (bool)
831     {
832         assert(earlyPurchasesLoaded);
833         assert(address(starbaseToken) != 0);
834 
835         /*
836          * “Value” refers to the contribution of the User:
837          *  {crowdsale_purchaser_token_amount} =
838          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
839          *
840          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
841          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
842          * and total amount raised during the Contribution Period is 30’000’000, then he will get
843          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
844         */
845 
846         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
847             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
848             crowdsalePurchaseAmountBy[msg.sender] = 0;
849 
850             uint256 tokenCount =
851                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
852                 totalAmountOfPurchasesInCny;
853 
854             numOfPurchasedTokensOnCsBy[msg.sender] =
855                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
856             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
857             numOfDeliveredCrowdsalePurchases++;
858         }
859 
860         /*
861          * “Value” refers to the contribution of the User:
862          * {earlypurchaser_token_amount} =
863          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
864          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
865          *
866          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
867          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
868          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
869          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
870          * 30’000’000 CNY + 6’000’000 CNY
871          */
872 
873         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
874             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
875             earlyPurchasedAmountBy[msg.sender] = 0;
876 
877             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchasesInCny;
878 
879             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfPurchasesInCny;
880 
881             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
882 
883             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
884             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
885             numOfDeliveredEarlyPurchases++;
886         }
887 
888         return true;
889     }
890 
891     /**
892      * @dev Load early purchases from the contract keeps track of them
893      */
894     function loadEarlyPurchases() external onlyOwner returns (bool) {
895         if (earlyPurchasesLoaded) {
896             return false;    // all EPs have already been loaded
897         }
898 
899         uint256 numOfOrigEp = starbaseEpAmendment
900             .starbaseEarlyPurchase()
901             .numberOfEarlyPurchases();
902 
903         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
904             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
905                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
906                 continue;
907             }
908             var (purchaser, amount,) =
909                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
910                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
911                 : starbaseEpAmendment.earlyPurchases(i);
912             if (amount > 0) {
913                 if (earlyPurchasedAmountBy[purchaser] == 0) {
914                     earlyPurchasers.push(purchaser);
915                 }
916                 // each early purchaser receives 20% bonus
917                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
918                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
919 
920                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
921             }
922 
923             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
924         }
925 
926         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
927         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
928             earlyPurchasesLoaded = true;    // enable the flag
929         }
930         return true;
931     }
932 
933     /**
934       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
935       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
936       * @param _amountCap Ether value which partner is able to contribute
937       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
938       */
939     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
940         external
941         onlyOwner
942     {
943         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
944         qualifiedPartners[_qualifiedPartner].bonaFide = true;
945         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
946         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
947         QualifiedPartnerAddress(_qualifiedPartner);
948     }
949 
950     /**
951      * @dev Remove address from qualified partners list.
952      * @param _qualifiedPartner Address to be removed from the list.
953      */
954     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
955         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
956         qualifiedPartners[_qualifiedPartner].bonaFide = false;
957     }
958 
959     /**
960      * @dev Update whitelisted address amount allowed to raise during the presale.
961      * @param _qualifiedPartner Qualified Partner address to be updated.
962      * @param _amountCap Amount that the address is able to raise during the presale.
963      */
964     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
965         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
966         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
967     }
968 
969     /**
970      * Public functions
971      */
972 
973     /**
974      * @dev Returns boolean for whether crowdsale has ended
975      */
976     function isEnded() constant public returns (bool) {
977         return (endedAt > 0 && endedAt <= now);
978     }
979 
980     /**
981      * @dev Returns number of purchases to date.
982      */
983     function numOfPurchases() constant public returns (uint256) {
984         return crowdsalePurchases.length;
985     }
986 
987     /**
988      * @dev Calculates total amount of tokens purchased includes bonus tokens.
989      */
990     function totalAmountOfCrowdsalePurchases() constant public returns (uint256 amount) {
991         for (uint256 i; i < crowdsalePurchases.length; i++) {
992             amount = SafeMath.add(amount, crowdsalePurchases[i].amount);
993         }
994     }
995 
996     /**
997      * @dev Calculates total amount of tokens purchased without bonus conversion.
998      */
999     function totalAmountOfCrowdsalePurchasesWithoutBonus() constant public returns (uint256 amount) {
1000         for (uint256 i; i < crowdsalePurchases.length; i++) {
1001             amount = SafeMath.add(amount, crowdsalePurchases[i].rawAmount);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns total raised amount in CNY (includes EP) and bonuses
1007      */
1008     function totalRaisedAmountInCny() constant public returns (uint256) {
1009         return SafeMath.add(totalAmountOfEarlyPurchases(), totalAmountOfCrowdsalePurchases());
1010     }
1011 
1012     /**
1013      * @dev Returns total amount of early purchases in CNY
1014      */
1015     function totalAmountOfEarlyPurchases() constant public returns(uint256) {
1016        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
1017     }
1018 
1019     /**
1020      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1021      */
1022     function purchaseAsQualifiedPartner()
1023         payable
1024         public
1025         rateIsSet(cnyEthRate)
1026         onlyQualifiedPartner
1027         returns (bool)
1028     {
1029         require(msg.value > 0);
1030         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1031 
1032         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1033 
1034         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1035         recordPurchase(msg.sender, rawAmount, now);
1036 
1037         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1038             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1039         }
1040 
1041         return true;
1042     }
1043 
1044     /**
1045      * @dev Allows user to purchase STAR tokens with Ether
1046      */
1047     function purchaseWithEth()
1048         payable
1049         public
1050         minInvestment
1051         whenNotEnded
1052         rateIsSet(cnyEthRate)
1053         onlyQualifiedPartnerORPicopsCertified
1054         returns (bool)
1055     {
1056         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1057 
1058         if (startDate == 0) {
1059             startCrowdsale(block.timestamp);
1060         }
1061 
1062         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1063         recordPurchase(msg.sender, rawAmount, now);
1064 
1065         return true;
1066     }
1067 
1068     /**
1069      * Internal functions
1070      */
1071 
1072     /**
1073      * @dev Initializes Starbase crowdsale
1074      */
1075     function startCrowdsale(uint256 timestamp) internal {
1076         startDate = timestamp;
1077         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus();
1078         if (maxCrowdsaleCap > presaleAmount) {
1079             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1080             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1081 
1082             // set token bonus milestones in cny total crowdsale purchase
1083             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1084             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1085             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1086             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1087         }
1088     }
1089 
1090     /**
1091      * @dev Abstract record of a purchase to Tokens
1092      * @param purchaser Address of the buyer
1093      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1094      * @param timestamp Timestamp at the purchase made
1095      */
1096     function recordPurchase(
1097         address purchaser,
1098         uint256 rawAmount,
1099         uint256 timestamp
1100     )
1101         internal
1102         returns(uint256 amount)
1103     {
1104         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1105 
1106         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1107         if (block.number >= purchaseStartBlock) {
1108             require(totalAmountOfCrowdsalePurchasesWithoutBonus() < maxCrowdsaleCap);   // check if the amount has already reached the cap
1109 
1110             uint256 crowdsaleTotalAmountAfterPurchase =
1111                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus(), amount);
1112 
1113             // check whether purchase goes over the cap and send the difference back to the purchaser.
1114             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1115               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1116               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1117               purchaser.transfer(ethValueToReturn);
1118               amount = SafeMath.sub(amount, difference);
1119               rawAmount = amount;
1120             }
1121 
1122         }
1123 
1124         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1125 
1126         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1127         crowdsalePurchases.push(purchase);
1128         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1129         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1130         return amount;
1131     }
1132 
1133     /**
1134      * @dev Calculates amount with bonus for bonus milestones
1135      */
1136     function calculateBonus
1137         (
1138             BonusMilestones nextMilestone,
1139             uint256 amount,
1140             uint256 bonusRange,
1141             uint256 bonusTier,
1142             uint256 results
1143         )
1144         internal
1145         returns (uint256 result, uint256 newAmount)
1146     {
1147         uint256 bonusCalc;
1148 
1149         if (amount <= bonusRange) {
1150             bonusCalc = amount.mul(bonusTier).div(100);
1151 
1152             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus()) >= bonusRange)
1153                 bonusMilestones = nextMilestone;
1154 
1155             result = results.add(amount).add(bonusCalc);
1156             newAmount = 0;
1157 
1158         } else {
1159             bonusCalc = bonusRange.mul(bonusTier).div(100);
1160             bonusMilestones = nextMilestone;
1161             result = results.add(bonusRange).add(bonusCalc);
1162             newAmount = amount.sub(bonusRange);
1163         }
1164     }
1165 
1166     /**
1167      * @dev Fetchs Bonus tier percentage per bonus milestones
1168      */
1169     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1170         if (block.number < purchaseStartBlock) {
1171             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1172             return amount.add(bonusFromAmount);
1173         }
1174 
1175         // range of each bonus milestones
1176         uint256 firstBonusRange = firstBonusEnds;
1177         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1178         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1179         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1180         uint256 result;
1181 
1182         if (bonusMilestones == BonusMilestones.First)
1183             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1184 
1185         if (bonusMilestones == BonusMilestones.Second)
1186             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1187 
1188         if (bonusMilestones == BonusMilestones.Third)
1189             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1190 
1191         if (bonusMilestones == BonusMilestones.Fourth)
1192             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1193 
1194         return result.add(amount);
1195     }
1196 
1197     /**
1198      * @dev Fetchs Bonus tier percentage per bonus milestones
1199      * @dev qualifiedPartner Address of partners that participated in pre sale
1200      * @dev amountSent Value sent by qualified partner
1201      */
1202     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1203         //calculate the commission fee to send to qualified partner
1204         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1205 
1206         // send commission fee amount
1207         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1208     }
1209 
1210     /**
1211      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1212      */
1213     function redirectToPurchase() internal {
1214         if (block.number < purchaseStartBlock) {
1215             purchaseAsQualifiedPartner();
1216         } else {
1217             purchaseWithEth();
1218         }
1219     }
1220 }