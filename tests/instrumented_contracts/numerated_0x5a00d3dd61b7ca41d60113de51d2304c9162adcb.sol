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
549 /**
550  * @title Crowdsale contract - Starbase crowdsale to create STAR.
551  * @author Starbase PTE. LTD. - <info@starbase.co>
552  */
553 contract StarbaseCrowdsale is Ownable {
554     using SafeMath for uint256;
555     /*
556      *  Events
557      */
558     event CrowdsaleEnded(uint256 endedAt);
559     event StarbasePurchasedWithEth(address purchaser, uint256 amount, uint256 rawAmount, uint256 cnyEthRate);
560     event CnyEthRateUpdated(uint256 cnyEthRate);
561     event CnyBtcRateUpdated(uint256 cnyBtcRate);
562     event QualifiedPartnerAddress(address qualifiedPartner);
563 
564     /**
565      *  External contracts
566      */
567     AbstractStarbaseToken public starbaseToken;
568     StarbaseEarlyPurchaseAmendment public starbaseEpAmendment;
569 
570     /**
571      *  Constants
572      */
573     uint256 constant public crowdsaleTokenAmount = 125000000e18;
574     uint256 constant public earlyPurchaseTokenAmount = 50000000e18;
575     uint256 constant public MIN_INVESTMENT = 1; // min is 1 Wei
576     uint256 constant public MAX_CAP = 67000000; // in CNY. approximately 10M USD. (includes raised amount from both EP and CS)
577     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';  // Chinese Yuan
578 
579     /**
580      * Types
581      */
582     struct CrowdsalePurchase {
583         address purchaser;
584         uint256 amount;        // CNY based amount with bonus
585         uint256 rawAmount;     // CNY based amount no bonus
586         uint256 purchasedAt;   // timestamp
587     }
588 
589     struct QualifiedPartners {
590         uint256 amountCap;
591         uint256 amountRaised;
592         bool    bonaFide;
593         uint256 commissionFeePercentage; // example 5 will calculate the percentage as 5%
594     }
595 
596     /*
597      *  Enums
598      */
599     enum BonusMilestones {
600         First,
601         Second,
602         Third,
603         Fourth,
604         Fifth
605     }
606 
607     // Initialize bonusMilestones
608     BonusMilestones public bonusMilestones = BonusMilestones.First;
609 
610     /**
611      *  Storage
612      */
613     uint public numOfDeliveredCrowdsalePurchases;  // index to keep the number of crowdsale purchases have already been processed by `withdrawPurchasedTokens`
614     uint public numOfDeliveredEarlyPurchases;  // index to keep the number of early purchases have already been processed by `withdrawPurchasedTokens`
615     uint256 public numOfLoadedEarlyPurchases; // index to keep the number of early purchases that have already been loaded by `loadEarlyPurchases`
616 
617     // early purchase
618     address[] public earlyPurchasers;
619     mapping (address => uint256) public earlyPurchasedAmountBy; // early purchased amount in CNY per purchasers' address
620     bool public earlyPurchasesLoaded = false;  // returns whether all early purchases are loaded into this contract
621     uint256 public totalAmountOfEarlyPurchasesInCny;
622 
623     // crowdsale
624     uint256 public maxCrowdsaleCap;     // = 67M CNY - (total raised amount from EP)
625     uint256 public totalAmountOfPurchasesInCny; // totalPreSale + totalCrowdsale
626     mapping (address => QualifiedPartners) public qualifiedPartners;
627     uint256 public purchaseStartBlock;  // crowdsale purchases can be accepted from this block number
628     uint256 public startDate;
629     uint256 public endedAt;
630     CrowdsalePurchase[] public crowdsalePurchases;
631     mapping (address => uint256) public crowdsalePurchaseAmountBy; // crowdsale purchase amount in CNY per purchasers' address
632     uint256 public cnyBtcRate; // this rate won't be used from a smart contract function but external system
633     uint256 public cnyEthRate;
634 
635     // bonus milestones
636     uint256 public firstBonusEnds;
637     uint256 public secondBonusEnds;
638     uint256 public thirdBonusEnds;
639     uint256 public fourthBonusEnds;
640 
641     // after the crowdsale
642     mapping (address => uint256) public numOfPurchasedTokensOnCsBy;    // the number of tokens purchased on the crowdsale by a purchaser
643     mapping (address => uint256) public numOfPurchasedTokensOnEpBy;    // the number of tokens early purchased by a purchaser
644 
645     /**
646      *  Modifiers
647      */
648     modifier minInvestment() {
649         // User has to send at least the ether value of one token.
650         assert(msg.value >= MIN_INVESTMENT);
651         _;
652     }
653 
654     modifier whenEnded() {
655         assert(isEnded());
656         _;
657     }
658 
659     modifier hasBalance() {
660         assert(this.balance > 0);
661         _;
662     }
663     modifier rateIsSet(uint256 _rate) {
664         assert(_rate != 0);
665         _;
666     }
667 
668     modifier whenNotEnded() {
669         assert(!isEnded());
670         _;
671     }
672 
673     modifier tokensNotDelivered() {
674         assert(numOfDeliveredCrowdsalePurchases == 0);
675         assert(numOfDeliveredEarlyPurchases == 0);
676         _;
677     }
678 
679     modifier onlyFundraiser() {
680         assert(address(starbaseToken) != 0);
681         assert(starbaseToken.isFundraiser(msg.sender));
682         _;
683     }
684 
685     modifier onlyQualifiedPartner() {
686         assert(qualifiedPartners[msg.sender].bonaFide);
687         _;
688     }
689 
690     /**
691      * Contract functions
692      */
693     /**
694      * @dev Contract constructor function sets owner address and
695      *      address of StarbaseEarlyPurchaseAmendment contract.
696      * @param starbaseEpAddr The address that holds the early purchasers Star tokens
697      */
698     function StarbaseCrowdsale(address starbaseEpAddr) {
699         require(starbaseEpAddr != 0);
700         owner = msg.sender;
701         starbaseEpAmendment = StarbaseEarlyPurchaseAmendment(starbaseEpAddr);
702     }
703 
704     /**
705      * @dev Fallback accepts payment for Star tokens with Eth
706      */
707     function() payable {
708         redirectToPurchase();
709     }
710 
711     /**
712      * External functions
713      */
714 
715     /**
716      * @dev Setup function sets external contracts' addresses and set the max crowdsale cap
717      * @param starbaseTokenAddress Token address.
718      * @param _purchaseStartBlock Block number to start crowdsale
719      */
720     function setup(address starbaseTokenAddress, uint256 _purchaseStartBlock)
721         external
722         onlyOwner
723         returns (bool)
724     {
725         require(starbaseTokenAddress != address(0));
726         require(address(starbaseToken) == 0);
727         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
728         purchaseStartBlock = _purchaseStartBlock;
729 
730         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
731 
732         // set the max cap of this crowdsale
733         maxCrowdsaleCap = MAX_CAP.sub(totalAmountOfEarlyPurchasesInCny);
734 
735         assert(maxCrowdsaleCap > 0);
736 
737         return true;
738     }
739 
740     /**
741      * @dev Transfers raised funds to company's wallet address at any given time.
742      */
743     function withdrawForCompany()
744         external
745         onlyFundraiser
746         hasBalance
747     {
748         address company = starbaseToken.company();
749         require(company != address(0));
750         company.transfer(this.balance);
751     }
752 
753     /**
754      * @dev Update the CNY/ETH rate to record purchases in CNY
755      */
756     function updateCnyEthRate(uint256 rate)
757         external
758         onlyFundraiser
759         returns (bool)
760     {
761         cnyEthRate = rate;
762         CnyEthRateUpdated(cnyEthRate);
763         return true;
764     }
765 
766     /**
767      * @dev Update the CNY/BTC rate to record purchases in CNY
768      */
769     function updateCnyBtcRate(uint256 rate)
770         external
771         onlyFundraiser
772         returns (bool)
773     {
774         cnyBtcRate = rate;
775         CnyBtcRateUpdated(cnyBtcRate);
776         return true;
777     }
778 
779     /**
780      * @dev Allow for the possibility for contract owner to start crowdsale
781      */
782     function ownerStartsCrowdsale(uint256 timestamp)
783         external
784         onlyOwner
785     {
786         assert(startDate == 0 && block.number >= purchaseStartBlock);   // overwriting startDate is not permitted and it should be after the crowdsale start block
787         startCrowdsale(timestamp);
788     }
789 
790     /**
791      * @dev Ends crowdsale
792      * @param timestamp Timestamp at the crowdsale ended
793      */
794     function endCrowdsale(uint256 timestamp)
795         external
796         onlyOwner
797     {
798         assert(timestamp > 0 && timestamp <= now);
799         assert(block.number > purchaseStartBlock && endedAt == 0);   // cannot end before it starts and overwriting time is not permitted
800         endedAt = timestamp;
801         totalAmountOfEarlyPurchasesInCny = totalAmountOfEarlyPurchases();
802         totalAmountOfPurchasesInCny = totalRaisedAmountInCny();
803         CrowdsaleEnded(endedAt);
804     }
805 
806     /**
807      * @dev Deliver tokens to purchasers according to their purchase amount in CNY
808      */
809     function withdrawPurchasedTokens()
810         external
811         whenEnded
812         returns (bool)
813     {
814         assert(earlyPurchasesLoaded);
815         assert(address(starbaseToken) != 0);
816 
817         /*
818          * “Value” refers to the contribution of the User:
819          *  {crowdsale_purchaser_token_amount} =
820          *  {crowdsale_token_amount} * {crowdsalePurchase_value} / {earlypurchase_value} + {crowdsale_value}.
821          *
822          * Example: If a User contributes during the Contribution Period 100 CNY (including applicable
823          * Bonus, if any) and the total amount early purchases amounts to 6’000’000 CNY
824          * and total amount raised during the Contribution Period is 30’000’000, then he will get
825          * 347.22 STAR = 125’000’000 STAR * 100 CNY / 30’000’000 CNY + 6’000’000 CNY.
826         */
827 
828         if (crowdsalePurchaseAmountBy[msg.sender] > 0) {
829             uint256 crowdsalePurchaseValue = crowdsalePurchaseAmountBy[msg.sender];
830             crowdsalePurchaseAmountBy[msg.sender] = 0;
831 
832             uint256 tokenCount =
833                 SafeMath.mul(crowdsaleTokenAmount, crowdsalePurchaseValue) /
834                 totalAmountOfPurchasesInCny;
835 
836             numOfPurchasedTokensOnCsBy[msg.sender] =
837                 SafeMath.add(numOfPurchasedTokensOnCsBy[msg.sender], tokenCount);
838             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, tokenCount));
839             numOfDeliveredCrowdsalePurchases++;
840         }
841 
842         /*
843          * “Value” refers to the contribution of the User:
844          * {earlypurchaser_token_amount} =
845          * {earlypurchaser_token_amount} * ({earlypurchase_value} / {total_earlypurchase_value})
846          *  + {crowdsale_token_amount} * ({earlypurchase_value} / {earlypurchase_value} + {crowdsale_value}).
847          *
848          * Example: If an Early Purchaser contributes 100 CNY (including Bonus of 20%) and the
849          * total amount of early purchases amounts to 6’000’000 CNY and the total amount raised
850          * during the Contribution Period is 30’000’000 CNY, then he will get 1180.55 STAR =
851          * 50’000’000 STAR * 100 CNY / 6’000’000 CNY + 125’000’000 STAR * 100 CNY /
852          * 30’000’000 CNY + 6’000’000 CNY
853          */
854 
855         if (earlyPurchasedAmountBy[msg.sender] > 0) {  // skip if is not an early purchaser
856             uint256 earlyPurchaserPurchaseValue = earlyPurchasedAmountBy[msg.sender];
857             earlyPurchasedAmountBy[msg.sender] = 0;
858 
859             uint256 epTokenCalculationFromEPTokenAmount = SafeMath.mul(earlyPurchaseTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfEarlyPurchasesInCny;
860 
861             uint256 epTokenCalculationFromCrowdsaleTokenAmount = SafeMath.mul(crowdsaleTokenAmount, earlyPurchaserPurchaseValue) / totalAmountOfPurchasesInCny;
862 
863             uint256 epTokenCount = SafeMath.add(epTokenCalculationFromEPTokenAmount, epTokenCalculationFromCrowdsaleTokenAmount);
864 
865             numOfPurchasedTokensOnEpBy[msg.sender] = SafeMath.add(numOfPurchasedTokensOnEpBy[msg.sender], epTokenCount);
866             assert(starbaseToken.allocateToCrowdsalePurchaser(msg.sender, epTokenCount));
867             numOfDeliveredEarlyPurchases++;
868         }
869 
870         return true;
871     }
872 
873     /**
874      * @dev Load early purchases from the contract keeps track of them
875      */
876     function loadEarlyPurchases() external onlyOwner returns (bool) {
877         if (earlyPurchasesLoaded) {
878             return false;    // all EPs have already been loaded
879         }
880 
881         uint256 numOfOrigEp = starbaseEpAmendment
882             .starbaseEarlyPurchase()
883             .numberOfEarlyPurchases();
884 
885         for (uint256 i = numOfLoadedEarlyPurchases; i < numOfOrigEp && msg.gas > 200000; i++) {
886             if (starbaseEpAmendment.isInvalidEarlyPurchase(i)) {
887                 numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
888                 continue;
889             }
890             var (purchaser, amount,) =
891                 starbaseEpAmendment.isAmendedEarlyPurchase(i)
892                 ? starbaseEpAmendment.amendedEarlyPurchases(i)
893                 : starbaseEpAmendment.earlyPurchases(i);
894             if (amount > 0) {
895                 if (earlyPurchasedAmountBy[purchaser] == 0) {
896                     earlyPurchasers.push(purchaser);
897                 }
898                 // each early purchaser receives 20% bonus
899                 uint256 bonus = SafeMath.mul(amount, 20) / 100;
900                 uint256 amountWithBonus = SafeMath.add(amount, bonus);
901 
902                 earlyPurchasedAmountBy[purchaser] = SafeMath.add(earlyPurchasedAmountBy[purchaser], amountWithBonus);
903             }
904 
905             numOfLoadedEarlyPurchases = SafeMath.add(numOfLoadedEarlyPurchases, 1);
906         }
907 
908         assert(numOfLoadedEarlyPurchases <= numOfOrigEp);
909         if (numOfLoadedEarlyPurchases == numOfOrigEp) {
910             earlyPurchasesLoaded = true;    // enable the flag
911         }
912         return true;
913     }
914 
915     /**
916       * @dev Set qualified crowdsale partner i.e. Bitcoin Suisse address
917       * @param _qualifiedPartner Address of the qualified partner that can purchase during crowdsale
918       * @param _amountCap Ether value which partner is able to contribute
919       * @param _commissionFeePercentage Integer that represents the fee to pay qualified partner 5 is 5%
920       */
921     function setQualifiedPartner(address _qualifiedPartner, uint256 _amountCap, uint256 _commissionFeePercentage)
922         external
923         onlyOwner
924     {
925         assert(!qualifiedPartners[_qualifiedPartner].bonaFide);
926         qualifiedPartners[_qualifiedPartner].bonaFide = true;
927         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
928         qualifiedPartners[_qualifiedPartner].commissionFeePercentage = _commissionFeePercentage;
929         QualifiedPartnerAddress(_qualifiedPartner);
930     }
931 
932     /**
933      * @dev Remove address from qualified partners list.
934      * @param _qualifiedPartner Address to be removed from the list.
935      */
936     function unlistQualifiedPartner(address _qualifiedPartner) external onlyOwner {
937         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
938         qualifiedPartners[_qualifiedPartner].bonaFide = false;
939     }
940 
941     /**
942      * @dev Update whitelisted address amount allowed to raise during the presale.
943      * @param _qualifiedPartner Qualified Partner address to be updated.
944      * @param _amountCap Amount that the address is able to raise during the presale.
945      */
946     function updateQualifiedPartnerCapAmount(address _qualifiedPartner, uint256 _amountCap) external onlyOwner {
947         assert(qualifiedPartners[_qualifiedPartner].bonaFide);
948         qualifiedPartners[_qualifiedPartner].amountCap = _amountCap;
949     }
950 
951     /**
952      * Public functions
953      */
954 
955     /**
956      * @dev Returns boolean for whether crowdsale has ended
957      */
958     function isEnded() constant public returns (bool) {
959         return (endedAt > 0 && endedAt <= now);
960     }
961 
962     /**
963      * @dev Returns number of purchases to date.
964      */
965     function numOfPurchases() constant public returns (uint256) {
966         return crowdsalePurchases.length;
967     }
968 
969     /**
970      * @dev Calculates total amount of tokens purchased includes bonus tokens.
971      */
972     function totalAmountOfCrowdsalePurchases() constant public returns (uint256 amount) {
973         for (uint256 i; i < crowdsalePurchases.length; i++) {
974             amount = SafeMath.add(amount, crowdsalePurchases[i].amount);
975         }
976     }
977 
978     /**
979      * @dev Calculates total amount of tokens purchased without bonus conversion.
980      */
981     function totalAmountOfCrowdsalePurchasesWithoutBonus() constant public returns (uint256 amount) {
982         for (uint256 i; i < crowdsalePurchases.length; i++) {
983             amount = SafeMath.add(amount, crowdsalePurchases[i].rawAmount);
984         }
985     }
986 
987     /**
988      * @dev Returns total raised amount in CNY (includes EP) and bonuses
989      */
990     function totalRaisedAmountInCny() constant public returns (uint256) {
991         return SafeMath.add(totalAmountOfEarlyPurchases(), totalAmountOfCrowdsalePurchases());
992     }
993 
994     /**
995      * @dev Returns total amount of early purchases in CNY
996      */
997     function totalAmountOfEarlyPurchases() constant public returns(uint256) {
998        return starbaseEpAmendment.totalAmountOfEarlyPurchases();
999     }
1000 
1001     /**
1002      * @dev Allows qualified crowdsale partner to purchase Star Tokens
1003      */
1004     function purchaseAsQualifiedPartner()
1005         payable
1006         public
1007         rateIsSet(cnyEthRate)
1008         onlyQualifiedPartner
1009         returns (bool)
1010     {
1011         require(msg.value > 0);
1012         qualifiedPartners[msg.sender].amountRaised = SafeMath.add(msg.value, qualifiedPartners[msg.sender].amountRaised);
1013 
1014         assert(qualifiedPartners[msg.sender].amountRaised <= qualifiedPartners[msg.sender].amountCap);
1015 
1016         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1017         recordPurchase(msg.sender, rawAmount, now);
1018 
1019         if (qualifiedPartners[msg.sender].commissionFeePercentage > 0) {
1020             sendQualifiedPartnerCommissionFee(msg.sender, msg.value);
1021         }
1022 
1023         return true;
1024     }
1025 
1026     /**
1027      * @dev Allows user to purchase STAR tokens with Ether
1028      */
1029     function purchaseWithEth()
1030         payable
1031         public
1032         minInvestment
1033         whenNotEnded
1034         rateIsSet(cnyEthRate)
1035         onlyQualifiedPartner
1036         returns (bool)
1037     {
1038         require(purchaseStartBlock > 0 && block.number >= purchaseStartBlock);
1039 
1040         if (startDate == 0) {
1041             startCrowdsale(block.timestamp);
1042         }
1043 
1044         uint256 rawAmount = SafeMath.mul(msg.value, cnyEthRate) / 1e18;
1045         recordPurchase(msg.sender, rawAmount, now);
1046 
1047         return true;
1048     }
1049 
1050     /**
1051      * Internal functions
1052      */
1053 
1054     /**
1055      * @dev Initializes Starbase crowdsale
1056      */
1057     function startCrowdsale(uint256 timestamp) internal {
1058         startDate = timestamp;
1059         uint256 presaleAmount = totalAmountOfCrowdsalePurchasesWithoutBonus();
1060         if (maxCrowdsaleCap > presaleAmount) {
1061             uint256 mainSaleCap = maxCrowdsaleCap.sub(presaleAmount);
1062             uint256 twentyPercentOfCrowdsalePurchase = mainSaleCap.mul(20).div(100);
1063 
1064             // set token bonus milestones in cny total crowdsale purchase
1065             firstBonusEnds =  twentyPercentOfCrowdsalePurchase;
1066             secondBonusEnds = firstBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1067             thirdBonusEnds =  secondBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1068             fourthBonusEnds = thirdBonusEnds.add(twentyPercentOfCrowdsalePurchase);
1069         }
1070     }
1071 
1072     /**
1073      * @dev Abstract record of a purchase to Tokens
1074      * @param purchaser Address of the buyer
1075      * @param rawAmount Amount in CNY as per the CNY/ETH rate used
1076      * @param timestamp Timestamp at the purchase made
1077      */
1078     function recordPurchase(
1079         address purchaser,
1080         uint256 rawAmount,
1081         uint256 timestamp
1082     )
1083         internal
1084         returns(uint256 amount)
1085     {
1086         amount = rawAmount; // amount to check reach of max cap. it does not care for bonus tokens here
1087 
1088         // presale transfers which occurs before the crowdsale ignores the crowdsale hard cap
1089         if (block.number >= purchaseStartBlock) {
1090             require(totalAmountOfCrowdsalePurchasesWithoutBonus() < maxCrowdsaleCap);   // check if the amount has already reached the cap
1091 
1092             uint256 crowdsaleTotalAmountAfterPurchase =
1093                 SafeMath.add(totalAmountOfCrowdsalePurchasesWithoutBonus(), amount);
1094 
1095             // check whether purchase goes over the cap and send the difference back to the purchaser.
1096             if (crowdsaleTotalAmountAfterPurchase > maxCrowdsaleCap) {
1097               uint256 difference = SafeMath.sub(crowdsaleTotalAmountAfterPurchase, maxCrowdsaleCap);
1098               uint256 ethValueToReturn = SafeMath.mul(difference, 1e18) / cnyEthRate;
1099               purchaser.transfer(ethValueToReturn);
1100               amount = SafeMath.sub(amount, difference);
1101               rawAmount = amount;
1102             }
1103 
1104         }
1105 
1106         amount = getBonusAmountCalculation(amount); // at this point amount bonus is calculated
1107 
1108         CrowdsalePurchase memory purchase = CrowdsalePurchase(purchaser, amount, rawAmount, timestamp);
1109         crowdsalePurchases.push(purchase);
1110         StarbasePurchasedWithEth(msg.sender, amount, rawAmount, cnyEthRate);
1111         crowdsalePurchaseAmountBy[purchaser] = SafeMath.add(crowdsalePurchaseAmountBy[purchaser], amount);
1112         return amount;
1113     }
1114 
1115     /**
1116      * @dev Calculates amount with bonus for bonus milestones
1117      */
1118     function calculateBonus
1119         (
1120             BonusMilestones nextMilestone,
1121             uint256 amount,
1122             uint256 bonusRange,
1123             uint256 bonusTier,
1124             uint256 results
1125         )
1126         internal
1127         returns (uint256 result, uint256 newAmount)
1128     {
1129         uint256 bonusCalc;
1130 
1131         if (amount <= bonusRange) {
1132             bonusCalc = amount.mul(bonusTier).div(100);
1133 
1134             if (amount.add(totalAmountOfCrowdsalePurchasesWithoutBonus()) >= bonusRange)
1135                 bonusMilestones = nextMilestone;
1136 
1137             result = results.add(amount).add(bonusCalc);
1138             newAmount = 0;
1139 
1140         } else {
1141             bonusCalc = bonusRange.mul(bonusTier).div(100);
1142             bonusMilestones = nextMilestone;
1143             result = results.add(bonusRange).add(bonusCalc);
1144             newAmount = amount.sub(bonusRange);
1145         }
1146     }
1147 
1148     /**
1149      * @dev Fetchs Bonus tier percentage per bonus milestones
1150      */
1151     function getBonusAmountCalculation(uint256 amount) internal returns (uint256) {
1152         if (block.number < purchaseStartBlock) {
1153             uint256 bonusFromAmount = amount.mul(30).div(100); // presale has 30% bonus
1154             return amount.add(bonusFromAmount);
1155         }
1156 
1157         // range of each bonus milestones
1158         uint256 firstBonusRange = firstBonusEnds;
1159         uint256 secondBonusRange = secondBonusEnds.sub(firstBonusEnds);
1160         uint256 thirdBonusRange = thirdBonusEnds.sub(secondBonusEnds);
1161         uint256 fourthBonusRange = fourthBonusEnds.sub(thirdBonusEnds);
1162         uint256 result;
1163 
1164         if (bonusMilestones == BonusMilestones.First)
1165             (result, amount) = calculateBonus(BonusMilestones.Second, amount, firstBonusRange, 20, result);
1166 
1167         if (bonusMilestones == BonusMilestones.Second)
1168             (result, amount) = calculateBonus(BonusMilestones.Third, amount, secondBonusRange, 15, result);
1169 
1170         if (bonusMilestones == BonusMilestones.Third)
1171             (result, amount) = calculateBonus(BonusMilestones.Fourth, amount, thirdBonusRange, 10, result);
1172 
1173         if (bonusMilestones == BonusMilestones.Fourth)
1174             (result, amount) = calculateBonus(BonusMilestones.Fifth, amount, fourthBonusRange, 5, result);
1175 
1176         return result.add(amount);
1177     }
1178 
1179     /**
1180      * @dev Fetchs Bonus tier percentage per bonus milestones
1181      * @dev qualifiedPartner Address of partners that participated in pre sale
1182      * @dev amountSent Value sent by qualified partner
1183      */
1184     function sendQualifiedPartnerCommissionFee(address qualifiedPartner, uint256 amountSent) internal {
1185         //calculate the commission fee to send to qualified partner
1186         uint256 commissionFeePercentageCalculationAmount = SafeMath.mul(amountSent, qualifiedPartners[qualifiedPartner].commissionFeePercentage) / 100;
1187 
1188         // send commission fee amount
1189         qualifiedPartner.transfer(commissionFeePercentageCalculationAmount);
1190     }
1191 
1192     /**
1193      * @dev redirectToPurchase Redirect to adequate purchase function within the smart contract
1194      */
1195     function redirectToPurchase() internal {
1196         if (block.number < purchaseStartBlock) {
1197             purchaseAsQualifiedPartner();
1198         } else {
1199             purchaseWithEth();
1200         }
1201     }
1202 }