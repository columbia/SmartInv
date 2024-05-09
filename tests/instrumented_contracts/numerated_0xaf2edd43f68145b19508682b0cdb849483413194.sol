1 pragma solidity ^0.4.18;
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract QuantstampSale is Pausable {
121 
122     using SafeMath for uint256;
123 
124     // The beneficiary is the future recipient of the funds
125     address public beneficiary;
126 
127     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
128     uint public fundingCap;
129     uint public minContribution;
130     bool public fundingCapReached = false;
131     bool public saleClosed = false;
132 
133     // Whitelist data
134     mapping(address => bool) public registry;
135 
136     // For each user, specifies the cap (in wei) that can be contributed for each tier
137     // Tiers are filled in the order 3, 2, 1, 4
138     mapping(address => uint256) public cap1;        // 100% bonus
139     mapping(address => uint256) public cap2;        // 40% bonus
140     mapping(address => uint256) public cap3;        // 20% bonus
141     mapping(address => uint256) public cap4;        // 0% bonus
142 
143     // Stores the amount contributed for each tier for a given address
144     mapping(address => uint256) public contributed1;
145     mapping(address => uint256) public contributed2;
146     mapping(address => uint256) public contributed3;
147     mapping(address => uint256) public contributed4;
148 
149 
150     // Conversion rate by tier (QSP : ETHER)
151     uint public rate1 = 10000;
152     uint public rate2 = 7000;
153     uint public rate3 = 6000;
154     uint public rate4 = 5000;
155 
156     // Time period of sale (UNIX timestamps)
157     uint public startTime;
158     uint public endTime;
159 
160     // Keeps track of the amount of wei raised
161     uint public amountRaised;
162 
163     // prevent certain functions from being recursively called
164     bool private rentrancy_lock = false;
165 
166     // The token being sold
167     // QuantstampToken public tokenReward;
168 
169     // A map that tracks the amount of wei contributed by address
170     mapping(address => uint256) public balanceOf;
171 
172     // A map that tracks the amount of QSP tokens that should be allocated to each address
173     mapping(address => uint256) public tokenBalanceOf;
174 
175 
176     // Events
177     event CapReached(address _beneficiary, uint _amountRaised);
178     event FundTransfer(address _backer, uint _amount, bool _isContribution);
179     event RegistrationStatusChanged(address target, bool isRegistered, uint c1, uint c2, uint c3, uint c4);
180 
181 
182     // Modifiers
183     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
184     // modifier afterDeadline()    { require (currentTime() >= endTime); _; } no longer used without fundingGoal
185     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
186 
187     modifier saleNotClosed()    { require (!saleClosed); _; }
188 
189     modifier nonReentrant() {
190         require(!rentrancy_lock);
191         rentrancy_lock = true;
192         _;
193         rentrancy_lock = false;
194     }
195 
196     /**
197      * Constructor for a crowdsale of QuantstampToken tokens.
198      *
199      * @param ifSuccessfulSendTo            the beneficiary of the fund
200      * @param fundingCapInEthers            the cap (maximum) size of the fund
201      * @param minimumContributionInWei      minimum contribution (in wei)
202      * @param start                         the start time (UNIX timestamp)
203      * @param durationInMinutes             the duration of the crowdsale in minutes
204      */
205     function QuantstampSale(
206         address ifSuccessfulSendTo,
207         uint fundingCapInEthers,
208         uint minimumContributionInWei,
209         uint start,
210         uint durationInMinutes
211         // address addressOfTokenUsedAsReward
212     ) {
213         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
214         //require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
215         require(durationInMinutes > 0);
216         beneficiary = ifSuccessfulSendTo;
217         fundingCap = fundingCapInEthers * 1 ether;
218         minContribution = minimumContributionInWei;
219         startTime = start;
220         endTime = start + (durationInMinutes * 1 minutes);
221         // tokenReward = QuantstampToken(addressOfTokenUsedAsReward);
222     }
223 
224     /**
225      * This function is called whenever Ether is sent to the
226      * smart contract. It can only be executed when the crowdsale is
227      * not paused, not closed, and before the deadline has been reached.
228      *
229      * This function will update state variables for whether or not the
230      * funding goal or cap have been reached. It also ensures that the
231      * tokens are transferred to the sender, and that the correct
232      * number of tokens are sent according to the current rate.
233      */
234     function () payable {
235         buy();
236     }
237 
238     function buy ()
239         payable public
240         whenNotPaused
241         beforeDeadline
242         afterStartTime
243         saleNotClosed
244         nonReentrant
245     {
246         require(msg.value >= minContribution);
247         uint amount = msg.value;
248 
249         // ensure that the user adheres to whitelist restrictions
250         require(registry[msg.sender]);
251 
252         uint numTokens = computeTokenAmount(msg.sender, amount);
253         assert(numTokens > 0);
254 
255         // update the total amount raised
256         amountRaised = amountRaised.add(amount);
257         require(amountRaised <= fundingCap);
258 
259         // update the sender's balance of wei contributed
260         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
261         // add to the token balance of the sender
262         tokenBalanceOf[msg.sender] = tokenBalanceOf[msg.sender].add(numTokens);
263 
264         FundTransfer(msg.sender, amount, true);
265         updateFundingCap();
266     }
267 
268     /**
269     * Computes the amount of QSP that should be issued for the given transaction.
270     * Contribution tiers are filled up in the order 3, 2, 1, 4.
271     * @param addr      The wallet address of the contributor
272     * @param amount    Amount of wei for payment
273     */
274     function computeTokenAmount(address addr, uint amount) internal
275         returns (uint){
276         require(amount > 0);
277 
278         uint r3 = cap3[addr].sub(contributed3[addr]);
279         uint r2 = cap2[addr].sub(contributed2[addr]);
280         uint r1 = cap1[addr].sub(contributed1[addr]);
281         uint r4 = cap4[addr].sub(contributed4[addr]);
282         uint numTokens = 0;
283 
284         // cannot contribute more than the remaining sum
285         assert(amount <= r3.add(r2).add(r1).add(r4));
286 
287         // Compute tokens for tier 3
288         if(r3 > 0){
289             if(amount <= r3){
290                 contributed3[addr] = contributed3[addr].add(amount);
291                 return rate3.mul(amount);
292             }
293             else{
294                 numTokens = rate3.mul(r3);
295                 amount = amount.sub(r3);
296                 contributed3[addr] = cap3[addr];
297             }
298         }
299         // Compute tokens for tier 2
300         if(r2 > 0){
301             if(amount <= r2){
302                 contributed2[addr] = contributed2[addr].add(amount);
303                 return numTokens.add(rate2.mul(amount));
304             }
305             else{
306                 numTokens = numTokens.add(rate2.mul(r2));
307                 amount = amount.sub(r2);
308                 contributed2[addr] = cap2[addr];
309             }
310         }
311         // Compute tokens for tier 1
312         if(r1 > 0){
313             if(amount <= r1){
314                 contributed1[addr] = contributed1[addr].add(amount);
315                 return numTokens.add(rate1.mul(amount));
316             }
317             else{
318                 numTokens = numTokens.add(rate1.mul(r1));
319                 amount = amount.sub(r1);
320                 contributed1[addr] = cap1[addr];
321             }
322         }
323         // Compute tokens for tier 4 (overflow)
324         contributed4[addr] = contributed4[addr].add(amount);
325         return numTokens.add(rate4.mul(amount));
326     }
327 
328     /**
329      * @dev Check if a contributor was at any point registered.
330      *
331      * @param contributor Address that will be checked.
332      */
333     function hasPreviouslyRegistered(address contributor)
334         internal
335         constant
336         onlyOwner returns (bool)
337     {
338         // if caps for this customer exist, then the customer has previously been registered
339         return (cap1[contributor].add(cap2[contributor]).add(cap3[contributor]).add(cap4[contributor])) > 0;
340     }
341 
342     /*
343     * If the user was already registered, ensure that the new caps do not conflict previous contributions
344     *
345     * NOTE: cannot use SafeMath here, because it exceeds the local variable stack limit.
346     * Should be ok since it is onlyOwner, and conditionals should guard the subtractions from underflow.
347     */
348     function validateUpdatedRegistration(address addr, uint c1, uint c2, uint c3, uint c4)
349         internal
350         constant
351         onlyOwner returns(bool)
352     {
353         return (contributed3[addr] <= c3) && (contributed2[addr] <= c2)
354             && (contributed1[addr] <= c1) && (contributed4[addr] <= c4);
355     }
356 
357     /**
358      * @dev Sets registration status of an address for participation.
359      *
360      * @param contributor Address that will be registered/deregistered.
361      * @param c1 The maximum amount of wei that the user can contribute in tier 1.
362      * @param c2 The maximum amount of wei that the user can contribute in tier 2.
363      * @param c3 The maximum amount of wei that the user can contribute in tier 3.
364      * @param c4 The maximum amount of wei that the user can contribute in tier 4.
365      */
366     function registerUser(address contributor, uint c1, uint c2, uint c3, uint c4)
367         public
368         onlyOwner
369     {
370         require(contributor != address(0));
371         // if the user was already registered ensure that the new caps do not contradict their current contributions
372         if(hasPreviouslyRegistered(contributor)){
373             require(validateUpdatedRegistration(contributor, c1, c2, c3, c4));
374         }
375         require(c1.add(c2).add(c3).add(c4) >= minContribution);
376         registry[contributor] = true;
377         cap1[contributor] = c1;
378         cap2[contributor] = c2;
379         cap3[contributor] = c3;
380         cap4[contributor] = c4;
381         RegistrationStatusChanged(contributor, true, c1, c2, c3, c4);
382     }
383 
384      /**
385      * @dev Remove registration status of an address for participation.
386      *
387      * NOTE: if the user made initial contributions to the crowdsale,
388      *       this will not return the previously allotted tokens.
389      *
390      * @param contributor Address to be unregistered.
391      */
392     function deactivate(address contributor)
393         public
394         onlyOwner
395     {
396         require(registry[contributor]);
397         registry[contributor] = false;
398         RegistrationStatusChanged(contributor, false, cap1[contributor], cap2[contributor], cap3[contributor], cap4[contributor]);
399 
400     }
401 
402     /**
403      * @dev Re-registers an already existing contributor
404      *
405      * @param contributor Address to be unregistered.
406      */
407     function reactivate(address contributor)
408         public
409         onlyOwner
410     {
411         require(hasPreviouslyRegistered(contributor));
412         registry[contributor] = true;
413         RegistrationStatusChanged(contributor, true, cap1[contributor], cap2[contributor], cap3[contributor], cap4[contributor]);
414 
415     }
416 
417     /**
418      * @dev Sets registration statuses of addresses for participation.
419      * @param contributors Addresses that will be registered/deregistered.
420      * @param caps1 The maximum amount of wei that each user can contribute to cap1, in the same order as the addresses.
421      * @param caps2 The maximum amount of wei that each user can contribute to cap2, in the same order as the addresses.
422      * @param caps3 The maximum amount of wei that each user can contribute to cap3, in the same order as the addresses.
423      * @param caps4 The maximum amount of wei that each user can contribute to cap4, in the same order as the addresses.
424      */
425     function registerUsers(address[] contributors,
426                            uint[] caps1,
427                            uint[] caps2,
428                            uint[] caps3,
429                            uint[] caps4)
430         external
431         onlyOwner
432     {
433         // check that all arrays have the same length
434         require(contributors.length == caps1.length);
435         require(contributors.length == caps2.length);
436         require(contributors.length == caps3.length);
437         require(contributors.length == caps4.length);
438 
439         for (uint i = 0; i < contributors.length; i++) {
440             registerUser(contributors[i], caps1[i], caps2[i], caps3[i], caps4[i]);
441         }
442     }
443 
444     /**
445      * The owner can terminate the crowdsale at any time.
446      */
447     function terminate() external onlyOwner {
448         saleClosed = true;
449     }
450 
451     /**
452      * The owner can allocate the specified amount of tokens from the
453      * crowdsale allowance to the recipient addresses.
454      *
455      * NOTE: be extremely careful to get the amounts correct, which
456      * are in units of wei and mini-QSP. Every digit counts.
457      *
458      * @param addrs          the recipient addresses
459      * @param weiAmounts     the amounts contributed in wei
460      * @param miniQspAmounts the amounts of tokens transferred in mini-QSP
461      */
462     function ownerAllocateTokensForList(address[] addrs, uint[] weiAmounts, uint[] miniQspAmounts)
463             external onlyOwner
464     {
465         require(addrs.length == weiAmounts.length);
466         require(addrs.length == miniQspAmounts.length);
467         for(uint i = 0; i < addrs.length; i++){
468             ownerAllocateTokens(addrs[i], weiAmounts[i], miniQspAmounts[i]);
469         }
470     }
471 
472     /**
473      *
474      * The owner can allocate the specified amount of tokens from the
475      * crowdsale allowance to the recipient (_to).
476      *
477      *
478      *
479      * NOTE: be extremely careful to get the amounts correct, which
480      * are in units of wei and mini-QSP. Every digit counts.
481      *
482      * @param _to            the recipient of the tokens
483      * @param amountWei     the amount contributed in wei
484      * @param amountMiniQsp the amount of tokens transferred in mini-QSP
485      */
486     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniQsp)
487             onlyOwner nonReentrant
488     {
489         // don't allocate tokens for the admin
490         // require(tokenReward.adminAddr() != _to);
491 
492         amountRaised = amountRaised.add(amountWei);
493         require(amountRaised <= fundingCap);
494 
495         tokenBalanceOf[_to] = tokenBalanceOf[_to].add(amountMiniQsp);
496         balanceOf[_to] = balanceOf[_to].add(amountWei);
497 
498         FundTransfer(_to, amountWei, true);
499         updateFundingCap();
500     }
501 
502 
503     /**
504      * The owner can call this function to withdraw the funds that
505      * have been sent to this contract for the crowdsale subject to
506      * the funding goal having been reached. The funds will be sent
507      * to the beneficiary specified when the crowdsale was created.
508      */
509     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
510         uint balanceToSend = this.balance;
511         beneficiary.transfer(balanceToSend);
512         FundTransfer(beneficiary, balanceToSend, false);
513     }
514 
515 
516     /**
517      * Checks if the funding cap has been reached. If it has, then
518      * the CapReached event is triggered.
519      */
520     function updateFundingCap() internal {
521         assert (amountRaised <= fundingCap);
522         if (amountRaised == fundingCap) {
523             // Check if the funding cap has been reached
524             fundingCapReached = true;
525             saleClosed = true;
526             CapReached(beneficiary, amountRaised);
527         }
528     }
529 
530     /**
531      * Returns the current time.
532      * Useful to abstract calls to "now" for tests.
533     */
534     function currentTime() constant returns (uint _currentTime) {
535         return now;
536     }
537 }
538 
539 /**
540  * The ExtendedQuantstampSale smart contract is used for selling QuantstampToken
541  * tokens (QSP). It does so by converting ETH received into a quantity of
542  * tokens that are transferred to the contributor via the ERC20-compatible
543  * transferFrom() function.
544  */
545 contract ExtendedQuantstampSale is Pausable {
546 
547     using SafeMath for uint256;
548     address public beneficiary;
549     uint public fundingCap;
550     uint public minContribution;
551     bool public fundingCapReached = false;
552     bool public saleClosed = false;
553 
554     // Whitelist data
555     mapping(address => bool) public registry;
556     mapping(address => uint256) public cap;
557 
558     // Time period of sale (UNIX timestamps)
559     uint public startTime;
560     uint public endTime;
561 
562     // Keeps track of the amount of wei raised
563     uint public amountRaised;
564 
565     // prevent certain functions from being recursively called
566     bool private rentrancy_lock = false;
567 
568     // A map that tracks the amount of wei contributed by address
569     mapping(address => uint256) public balanceOf;
570 
571     // Previously created contract
572     QuantstampSale public previousContract;
573 
574     // Events
575     event CapReached(address _beneficiary, uint _amountRaised);
576     event FundTransfer(address _backer, uint _amount, bool _isContribution);
577     event RegistrationStatusChanged(address target, bool isRegistered, uint c);
578 
579     // Modifiers
580     modifier beforeDeadline()   {  require (currentTime() < endTime); _;     }
581     modifier afterStartTime()   {  require (currentTime() >= startTime); _;  }
582     modifier saleNotClosed()    {  require (!saleClosed); _;                 }
583 
584     modifier nonReentrant() {
585         require(!rentrancy_lock);
586         rentrancy_lock = true;
587         _;
588         rentrancy_lock = false;
589     }
590 
591     /**
592      * Constructor for a crowdsale of QuantstampToken tokens.
593      *
594      * @param ifSuccessfulSendTo            the beneficiary of the fund
595      * @param fundingCapInEthers            the cap (maximum) size of the fund
596      * @param minimumContributionInWei      minimum contribution (in wei)
597      * @param start                         the start time (UNIX timestamp)
598      * @param durationInMinutes             the duration of the crowdsale in minutes
599      */
600     function ExtendedQuantstampSale(
601         address ifSuccessfulSendTo,
602         uint fundingCapInEthers,
603         uint minimumContributionInWei,
604         uint start,
605         uint durationInMinutes,
606         address previousContractAddress
607     ) {
608         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
609         require(durationInMinutes > 0);
610         beneficiary = ifSuccessfulSendTo;
611         fundingCap = fundingCapInEthers * 1 ether;
612         minContribution = minimumContributionInWei;
613         startTime = start;
614         endTime = start + (durationInMinutes * 1 minutes);
615         previousContract = QuantstampSale(previousContractAddress);
616     }
617 
618     /**
619      * Fallback function that is payable and calls "buy" to purchase tokens.
620      */
621     function () payable {
622         buy();
623     }
624 
625     /**
626      * Buy tokens, subject to the descriptive constraints specified by modifiers.
627      */
628     function buy ()
629         payable public
630         whenNotPaused
631         beforeDeadline
632         afterStartTime
633         saleNotClosed
634         nonReentrant
635     {
636         uint amount = msg.value;
637         require(amount >= minContribution);
638 
639         // ensure that the user adheres to whitelist restrictions
640         require(registry[msg.sender]);
641 
642         // update the amount raised
643         amountRaised = amountRaised.add(amount);
644         require(getTotalAmountRaised() <= fundingCap);
645 
646         // update the sender's balance of wei contributed
647         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
648         require(getUserBalance(msg.sender) <= cap[msg.sender]);
649 
650         FundTransfer(msg.sender, amount, true);
651         updateFundingCap();
652     }
653 
654     function getTotalAmountRaised() public constant returns (uint) {
655         return amountRaised.add(previousContract.amountRaised());
656     }
657 
658     function getUserBalance(address user) public constant returns (uint) {
659         return balanceOf[user].add(previousContract.balanceOf(user));
660     }
661 
662     function setEndTime(uint timestamp) public onlyOwner {
663         endTime = timestamp;
664     }
665 
666     /**
667      * @dev Check if a contributor was at any point registered.
668      *
669      * @param contributor Address that will be checked.
670      */
671     function hasPreviouslyRegistered(address contributor)
672         internal
673         constant
674         returns (bool)
675     {
676         // if a cap for this customer exist, then the customer has previously been registered
677         // we skip the caps from the previous contract
678         return cap[contributor] > 0;
679     }
680 
681     /*
682      * If the user was already registered, ensure that the new caps do not conflict previous contributions
683      */
684     function validateUpdatedRegistration(address addr, uint _cap)
685         internal
686         constant
687         returns(bool)
688     {
689         return (getUserBalance(addr) <= _cap);
690     }
691 
692     /**
693      * @dev Sets registration status of an address for participation.
694      *
695      * @param contributor Address that will be registered/deregistered.
696      * @param _cap The maximum amount of wei that the user can contribute
697      */
698     function registerUser(address contributor, uint _cap)
699         public
700         onlyOwner
701     {
702         require(contributor != address(0));
703         // if the user was already registered ensure that the new caps do not contradict their current contributions
704         if(hasPreviouslyRegistered(contributor)){
705             require(validateUpdatedRegistration(contributor, _cap));
706         }
707         require(_cap >= minContribution);
708         registry[contributor] = true;
709         cap[contributor] = _cap;
710         RegistrationStatusChanged(contributor, true, _cap);
711     }
712 
713      /**
714      * @dev Remove registration status of an address for participation.
715      *
716      * NOTE: if the user made initial contributions to the crowdsale,
717      *       this will not return the previously allotted tokens.
718      *
719      * @param contributor Address to be unregistered.
720      */
721     function deactivate(address contributor)
722         public
723         onlyOwner
724     {
725         require(registry[contributor]);
726         registry[contributor] = false;
727         RegistrationStatusChanged(contributor, false, cap[contributor]);
728 
729     }
730 
731     /**
732      * @dev Re-registers an already existing contributor
733      *
734      * @param contributor Address to be unregistered.
735      */
736     function reactivate(address contributor)
737         public
738         onlyOwner
739     {
740         require(hasPreviouslyRegistered(contributor));
741         registry[contributor] = true;
742         RegistrationStatusChanged(contributor, true, cap[contributor]);
743     }
744 
745     /**
746      * @dev Sets registration statuses of addresses for participation.
747      * @param contributors Addresses that will be registered/deregistered.
748      * @param caps The maximum amount of wei that each user can contribute to cap, in the same order as the addresses.
749      */
750     function registerUsers(address[] contributors, uint[] caps) external
751         onlyOwner
752     {
753         // check that all arrays have the same length
754         require(contributors.length == caps.length);
755 
756         for (uint i = 0; i < contributors.length; i++) {
757             registerUser(contributors[i], caps[i]);
758         }
759     }
760 
761     /**
762      * The owner can terminate the crowdsale at any time.
763      */
764     function terminate() external
765         onlyOwner
766     {
767         saleClosed = true;
768     }
769 
770     /**
771      *
772      * The owner can allocate the specified amount.
773      *
774      * @param _to            the recipient of the tokens
775      * @param amountWei     the amount contributed in wei
776      */
777     function ownerAllocate(address _to, uint amountWei) public
778         onlyOwner
779         nonReentrant
780     {
781         amountRaised = amountRaised.add(amountWei);
782         require(getTotalAmountRaised() <= fundingCap);
783 
784         balanceOf[_to] = balanceOf[_to].add(amountWei);
785 
786         FundTransfer(_to, amountWei, true);
787         updateFundingCap();
788     }
789 
790 
791     /**
792      * The owner can call this function to withdraw the funds that
793      * have been sent to this contract for the crowdsale subject to
794      * the funding goal having been reached. The funds will be sent
795      * to the beneficiary specified when the crowdsale was created.
796      */
797     function ownerSafeWithdrawal() external
798         onlyOwner
799         nonReentrant
800     {
801         uint balanceToSend = this.balance;
802         beneficiary.transfer(balanceToSend);
803         FundTransfer(beneficiary, balanceToSend, false);
804     }
805 
806 
807     /**
808      * Checks if the funding cap has been reached. If it has, then
809      * the CapReached event is triggered.
810      */
811     function updateFundingCap() internal
812     {
813         uint amount = getTotalAmountRaised();
814         assert (amount <= fundingCap);
815         if (amount == fundingCap) {
816             // Check if the funding cap has been reached
817             fundingCapReached = true;
818             saleClosed = true;
819             CapReached(beneficiary, amount);
820         }
821     }
822 
823     /**
824      * Returns the current time.
825      * Useful to abstract calls to "now" for tests.
826     */
827     function currentTime() public constant returns (uint _currentTime)
828     {
829         return now;
830     }
831 }