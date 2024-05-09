1 library SafeMathLib {
2 
3   function times(uint a, uint b) returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function minus(uint a, uint b) returns (uint) {
10     assert(b <= a);
11     return a - b;
12   }
13 
14   function plus(uint a, uint b) returns (uint) {
15     uint c = a + b;
16     assert(c>=a);
17     return c;
18   }
19 
20 }
21 
22 
23 
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 
68 contract Haltable is Ownable {
69   bool public halted;
70 
71   modifier stopInEmergency {
72     require(!halted);
73     _;
74   }
75 
76   modifier stopNonOwnersInEmergency {
77     require(!halted || msg.sender == owner);
78     _;
79   }
80 
81   modifier onlyInEmergency {
82     require(halted);
83     _;
84   }
85 
86   // called by the owner on emergency, triggers stopped state
87   function halt() external onlyOwner {
88     halted = true;
89   }
90 
91   // called by the owner on end of emergency, returns to normal state
92   function unhalt() external onlyOwner onlyInEmergency {
93     halted = false;
94   }
95 
96 }
97 
98 
99 contract PricingStrategy {
100 
101   /** Interface declaration. */
102   function isPricingStrategy() public constant returns (bool) {
103     return true;
104   }
105 
106   /** Self check if all references are correctly set.
107    *
108    * Checks that pricing strategy matches crowdsale parameters.
109    */
110   function isSane(address crowdsale) public constant returns (bool) {
111     return true;
112   }
113 
114   /**
115    * @dev Pricing tells if this is a presale purchase or not.
116      @param purchaser Address of the purchaser
117      @return False by default, true if a presale purchaser
118    */
119   function isPresalePurchase(address purchaser) public constant returns (bool) {
120     return false;
121   }
122 
123   /**
124    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
125    *
126    *
127    * @param value - What is the value of the transaction send in as wei
128    * @param tokensSold - how much tokens have been sold this far
129    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
130    * @param msgSender - who is the investor of this transaction
131    * @param decimals - how many decimal units the token has
132    * @return Amount of tokens the investor receives
133    */
134   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
135 }
136 
137 
138 contract FinalizeAgent {
139 
140   function isFinalizeAgent() public constant returns(bool) {
141     return true;
142   }
143 
144   /** Return true if we can run finalizeCrowdsale() properly.
145    *
146    * This is a safety check function that doesn't allow crowdsale to begin
147    * unless the finalizer has been set up properly.
148    */
149   function isSane() public constant returns (bool);
150 
151   /** Called once by crowdsale finalize() if the sale was success. */
152   function finalizeCrowdsale();
153 
154 }
155 
156 
157 
158 
159 
160 
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167   uint256 public totalSupply;
168   function balanceOf(address who) public view returns (uint256);
169   function transfer(address to, uint256 value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender) public view returns (uint256);
181   function transferFrom(address from, address to, uint256 value) public returns (bool);
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 
187 /**
188  * A token that defines fractional units as decimals.
189  */
190 contract FractionalERC20 is ERC20 {
191 
192   uint public decimals;
193 
194 }
195 
196 
197 contract Crowdsale is Haltable {
198 
199   /* Max investment count when we are still allowed to change the multisig address */
200   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
201 
202   using SafeMathLib for uint;
203 
204   /* The token we are selling */
205   FractionalERC20 public token;
206 
207   /* How we are going to price our offering */
208   PricingStrategy public pricingStrategy;
209 
210   /* Post-success callback */
211   FinalizeAgent public finalizeAgent;
212 
213   /* tokens will be transfered from this address */
214   address public multisigWallet;
215 
216   /* if the funding goal is not reached, investors may withdraw their funds */
217   uint public minimumFundingGoal;
218 
219   /* the UNIX timestamp start date of the crowdsale */
220   uint public startsAt;
221 
222   /* the UNIX timestamp end date of the crowdsale */
223   uint public endsAt;
224 
225   /* the number of tokens already sold through this contract*/
226   uint public tokensSold = 0;
227 
228   /* How many wei of funding we have raised */
229   uint public weiRaised = 0;
230 
231   /* Calculate incoming funds from presale contracts and addresses */
232   uint public presaleWeiRaised = 0;
233 
234   /* How many distinct addresses have invested */
235   uint public investorCount = 0;
236 
237   /* How much wei we have returned back to the contract after a failed crowdfund. */
238   uint public loadedRefund = 0;
239 
240   /* How much wei we have given back to investors.*/
241   uint public weiRefunded = 0;
242 
243   /* Has this crowdsale been finalized */
244   bool public finalized;
245 
246   /* Do we need to have unique contributor id for each customer */
247   bool public requireCustomerId;
248 
249   /**
250     * Do we verify that contributor has been cleared on the server side (accredited investors only).
251     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
252     */
253   bool public requiredSignedAddress;
254 
255   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
256   address public signerAddress;
257 
258   /** How much ETH each address has invested to this crowdsale */
259   mapping (address => uint256) public investedAmountOf;
260 
261   /** How much tokens this crowdsale has credited for each investor address */
262   mapping (address => uint256) public tokenAmountOf;
263 
264   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
265   mapping (address => bool) public earlyParticipantWhitelist;
266 
267   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
268   uint public ownerTestValue;
269 
270   /** State machine
271    *
272    * - Preparing: All contract initialization calls and variables have not been set yet
273    * - Prefunding: We have not passed start time yet
274    * - Funding: Active crowdsale
275    * - Success: Minimum funding goal reached
276    * - Failure: Minimum funding goal not reached before ending time
277    * - Finalized: The finalized has been called and succesfully executed
278    * - Refunding: Refunds are loaded on the contract for reclaim.
279    */
280   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
281 
282   // A new investment was made
283   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
284 
285   // Refund was processed for a contributor
286   event Refund(address investor, uint weiAmount);
287 
288   // The rules were changed what kind of investments we accept
289   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
290 
291   // Address early participation whitelist status changed
292   event Whitelisted(address addr, bool status);
293 
294   // Crowdsale end time has been changed
295   event EndsAtChanged(uint newEndsAt);
296 
297   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
298 
299     require(_multisigWallet != 0);
300     require(_start != 0 && _end != 0);
301 
302     // Don't mess the dates
303     require(_start < _end);
304 
305     owner = msg.sender;
306 
307     token = FractionalERC20(_token);
308 
309     setPricingStrategy(_pricingStrategy);
310 
311     multisigWallet = _multisigWallet;
312     startsAt = _start;
313 
314     endsAt = _end;
315 
316     // Minimum funding goal can be zero
317     minimumFundingGoal = _minimumFundingGoal;
318   }
319 
320   /**
321    * Don't expect to just send in money and get tokens.
322    */
323   function() {
324   }
325 
326   /**
327    * Make an investment.
328    *
329    * Crowdsale must be running for one to invest.
330    * We must have not pressed the emergency brake.
331    *
332    * @param receiver The Ethereum address who receives the tokens
333    * @param customerId (optional) UUID v4 to track the successful payments on the server side
334    *
335    */
336   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
337 
338     // Determine if it's a good time to accept investment from this participant
339     if(getState() == State.PreFunding) {
340       // Are we whitelisted for early deposit
341       require(earlyParticipantWhitelist[receiver]);
342     } else if(getState() == State.Funding) {
343       // Retail participants can only come in when the crowdsale is running
344       // pass
345     } else {
346       // Unwanted state
347       revert();
348     }
349 
350     uint weiAmount = msg.value;
351 
352     // Account presale sales separately, so that they do not count against pricing tranches
353     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
354 
355     require(tokenAmount != 0); // Dust transaction
356 
357     if(investedAmountOf[receiver] == 0) {
358        // A new investor
359        investorCount++;
360     }
361 
362     // Update investor
363     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
364     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
365 
366     // Update totals
367     weiRaised = weiRaised.plus(weiAmount);
368     tokensSold = tokensSold.plus(tokenAmount);
369 
370     if(pricingStrategy.isPresalePurchase(receiver)) {
371         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
372     }
373 
374     // Check that we did not bust the cap
375     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
376 
377     assignTokens(receiver, tokenAmount);
378 
379     // Pocket the money
380     multisigWallet.transfer(weiAmount);
381 
382     // Tell us invest was success
383     Invested(receiver, weiAmount, tokenAmount, customerId);
384   }
385 
386   /**
387    * Preallocate tokens for the early investors.
388    *
389    * Preallocated tokens have been sold before the actual crowdsale opens.
390    * This function mints the tokens and moves the crowdsale needle.
391    *
392    * Investor count is not handled; it is assumed this goes for multiple investors
393    * and the token distribution happens outside the smart contract flow.
394    *
395    * No money is exchanged, as the crowdsale team already have received the payment.
396    *
397    * @param fullTokens tokens as full tokens - decimal places added internally
398    * @param weiPrice Price of a single full token in wei
399    *
400    */
401   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
402 
403     uint tokenAmount = fullTokens * 10**token.decimals();
404     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
405 
406     weiRaised = weiRaised.plus(weiAmount);
407     tokensSold = tokensSold.plus(tokenAmount);
408 
409     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
410     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
411 
412     assignTokens(receiver, tokenAmount);
413 
414     // Tell us invest was success
415     Invested(receiver, weiAmount, tokenAmount, 0);
416   }
417 
418   /**
419    * Allow anonymous contributions to this crowdsale.
420    */
421   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
422      bytes32 hash = sha256(addr);
423      require(ecrecover(hash, v, r, s) == signerAddress);
424      require(customerId != 0);  // UUIDv4 sanity check
425      investInternal(addr, customerId);
426   }
427 
428   /**
429    * Track who is the customer making the payment so we can send thank you email.
430    */
431   function investWithCustomerId(address addr, uint128 customerId) public payable {
432     require(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
433     require(customerId != 0);  // UUIDv4 sanity check
434     investInternal(addr, customerId);
435   }
436 
437   /**
438    * Allow anonymous contributions to this crowdsale.
439    */
440   function invest(address addr) public payable {
441     require(!requireCustomerId); // Crowdsale needs to track partipants for thank you email
442     require(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
443     investInternal(addr, 0);
444   }
445 
446   /**
447    * Invest to tokens, recognize the payer and clear his address.
448    *
449    */
450   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
451     investWithSignedAddress(msg.sender, customerId, v, r, s);
452   }
453 
454   /**
455    * Invest to tokens, recognize the payer.
456    *
457    */
458   function buyWithCustomerId(uint128 customerId) public payable {
459     investWithCustomerId(msg.sender, customerId);
460   }
461 
462   /**
463    * The basic entry point to participate the crowdsale process.
464    *
465    * Pay for funding, get invested tokens back in the sender address.
466    */
467   function buy() public payable {
468     invest(msg.sender);
469   }
470 
471   /**
472    * Finalize a succcesful crowdsale.
473    *
474    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
475    */
476   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
477 
478     // Already finalized
479     require(!finalized);
480 
481     // Finalizing is optional. We only call it if we are given a finalizing agent.
482     if(address(finalizeAgent) != 0) {
483       finalizeAgent.finalizeCrowdsale();
484     }
485 
486     finalized = true;
487   }
488 
489   /**
490    * Allow to (re)set finalize agent.
491    *
492    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
493    */
494   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
495 
496     // Don't allow setting bad agent
497     require(addr.isFinalizeAgent());
498     finalizeAgent = addr;
499   }
500 
501   /**
502    * Set policy do we need to have server-side customer ids for the investments.
503    *
504    */
505   function setRequireCustomerId(bool value) onlyOwner {
506     requireCustomerId = value;
507     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
508   }
509 
510   /**
511    * Set policy if all investors must be cleared on the server side first.
512    *
513    * This is e.g. for the accredited investor clearing.
514    *
515    */
516   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
517     requiredSignedAddress = value;
518     signerAddress = _signerAddress;
519     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
520   }
521 
522   /**
523    * Allow addresses to do early participation.
524    *
525    * TODO: Fix spelling error in the name
526    */
527   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
528     earlyParticipantWhitelist[addr] = status;
529     Whitelisted(addr, status);
530   }
531 
532   /**
533    * Allow crowdsale owner to close early or extend the crowdsale.
534    *
535    * This is useful e.g. for a manual soft cap implementation:
536    * - after X amount is reached determine manual closing
537    *
538    * This may put the crowdsale to an invalid state,
539    * but we trust owners know what they are doing.
540    *
541    */
542   function setEndsAt(uint time) onlyOwner {
543 
544     require(now <= time); // Don't change past
545     require(time > startsAt); // Don't allow to end before we start
546 
547     endsAt = time;
548     EndsAtChanged(endsAt);
549   }
550 
551   /**
552    * Allow to (re)set pricing strategy.
553    *
554    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
555    */
556   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
557 
558     // Don't allow setting bad agent
559     require(_pricingStrategy.isPricingStrategy());
560     pricingStrategy = _pricingStrategy;
561   }
562 
563   /**
564    * Allow to change the team multisig address in the case of emergency.
565    *
566    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
567    * (we have done only few test transactions). After the crowdsale is going
568    * then multisig address stays locked for the safety reasons.
569    */
570   function setMultisig(address addr) public onlyOwner {
571 
572     // Change
573     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
574 
575     multisigWallet = addr;
576   }
577 
578   /**
579    * Allow load refunds back on the contract for the refunding.
580    *
581    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
582    */
583   function loadRefund() public payable inState(State.Failure) {
584     require(msg.value != 0);
585     loadedRefund = loadedRefund.plus(msg.value);
586   }
587 
588   /**
589    * Investors can claim refund.
590    *
591    * Note that any refunds from proxy buyers should be handled separately,
592    * and not through this contract.
593    */
594   function refund() public inState(State.Refunding) {
595     uint256 weiValue = investedAmountOf[msg.sender];
596     require(weiValue != 0);
597     investedAmountOf[msg.sender] = 0;
598     weiRefunded = weiRefunded.plus(weiValue);
599     Refund(msg.sender, weiValue);
600     msg.sender.transfer(weiValue);
601   }
602 
603   /**
604    * @return true if the crowdsale has raised enough money to be a successful.
605    */
606   function isMinimumGoalReached() public constant returns (bool reached) {
607     return weiRaised >= minimumFundingGoal;
608   }
609 
610   /**
611    * Check if the contract relationship looks good.
612    */
613   function isFinalizerSane() public constant returns (bool sane) {
614     return finalizeAgent.isSane();
615   }
616 
617   /**
618    * Check if the contract relationship looks good.
619    */
620   function isPricingSane() public constant returns (bool sane) {
621     return pricingStrategy.isSane(address(this));
622   }
623 
624   /**
625    * Crowdfund state machine management.
626    *
627    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
628    */
629   function getState() public constant returns (State) {
630     if(finalized) return State.Finalized;
631     else if (address(finalizeAgent) == 0) return State.Preparing;
632     else if (!finalizeAgent.isSane()) return State.Preparing;
633     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
634     else if (block.timestamp < startsAt) return State.PreFunding;
635     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
636     else if (isMinimumGoalReached()) return State.Success;
637     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
638     else return State.Failure;
639   }
640 
641   /** This is for manual testing of multisig wallet interaction */
642   function setOwnerTestValue(uint val) onlyOwner {
643     ownerTestValue = val;
644   }
645 
646   /** Interface marker. */
647   function isCrowdsale() public constant returns (bool) {
648     return true;
649   }
650 
651   //
652   // Modifiers
653   //
654 
655   /** Modified allowing execution only if the crowdsale is currently running.  */
656   modifier inState(State state) {
657     require(getState() == state);
658     _;
659   }
660 
661 
662   //
663   // Abstract functions
664   //
665 
666   /**
667    * Check if the current invested breaks our cap rules.
668    *
669    *
670    * The child contract must define their own cap setting rules.
671    * We allow a lot of flexibility through different capping strategies (ETH, token count)
672    * Called from invest().
673    *
674    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
675    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
676    * @param weiRaisedTotal What would be our total raised balance after this transaction
677    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
678    *
679    * @return true if taking this investment would break our cap rules
680    */
681   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
682 
683   /**
684    * Check if the current crowdsale is full and we can no longer sell any tokens.
685    */
686   function isCrowdsaleFull() public constant returns (bool);
687 
688   /**
689    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
690    */
691   function assignTokens(address receiver, uint tokenAmount) private;
692 }
693 
694 
695 contract AllocatedCrowdsale is Crowdsale {
696 
697   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
698   address public beneficiary;
699 
700   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
701     beneficiary = _beneficiary;
702   }
703 
704   /**
705    * Called from invest() to confirm if the curret investment does not break our cap rule.
706    */
707   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
708     if(tokenAmount > getTokensLeft()) {
709       return true;
710     } else {
711       return false;
712     }
713   }
714 
715   /**
716    * We are sold out when our approve pool becomes empty.
717    */
718   function isCrowdsaleFull() public constant returns (bool) {
719     return getTokensLeft() == 0;
720   }
721 
722   /**
723    * Get the amount of unsold tokens allocated to this contract;
724    */
725   function getTokensLeft() public constant returns (uint) {
726     return token.allowance(owner, this);
727   }
728 
729   /**
730    * Transfer tokens from approve() pool to the buyer.
731    *
732    * Use approve() given to this crowdsale to distribute the tokens.
733    */
734   function assignTokens(address receiver, uint tokenAmount) private {
735     require(token.transferFrom(beneficiary, receiver, tokenAmount));
736   }
737 }