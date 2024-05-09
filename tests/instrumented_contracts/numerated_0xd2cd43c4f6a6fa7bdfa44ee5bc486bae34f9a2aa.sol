1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 contract Haltable is Ownable {
37   bool public halted;
38 
39   modifier stopInEmergency {
40     if (halted) throw;
41     _;
42   }
43 
44   modifier stopNonOwnersInEmergency {
45     if (halted && msg.sender != owner) throw;
46     _;
47   }
48 
49   modifier onlyInEmergency {
50     if (!halted) throw;
51     _;
52   }
53 
54   // called by the owner on emergency, triggers stopped state
55   function halt() external onlyOwner {
56     halted = true;
57   }
58 
59   // called by the owner on end of emergency, returns to normal state
60   function unhalt() external onlyOwner onlyInEmergency {
61     halted = false;
62   }
63 
64 }
65 
66 contract PricingStrategy {
67 
68   /** Interface declaration. */
69   function isPricingStrategy() public constant returns (bool) {
70     return true;
71   }
72 
73   /** Self check if all references are correctly set.
74    *
75    * Checks that pricing strategy matches crowdsale parameters.
76    */
77   function isSane(address crowdsale) public constant returns (bool) {
78     return true;
79   }
80 
81   /**
82    * @dev Pricing tells if this is a presale purchase or not.
83      @param purchaser Address of the purchaser
84      @return False by default, true if a presale purchaser
85    */
86   function isPresalePurchase(address purchaser) public constant returns (bool) {
87     return false;
88   }
89 
90   /**
91    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
92    *
93    *
94    * @param value - What is the value of the transaction send in as wei
95    * @param tokensSold - how much tokens have been sold this far
96    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
97    * @param msgSender - who is the investor of this transaction
98    * @param decimals - how many decimal units the token has
99    * @return Amount of tokens the investor receives
100    */
101   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
102 }
103 
104 contract FinalizeAgent {
105 
106   function isFinalizeAgent() public constant returns(bool) {
107     return true;
108   }
109 
110   /** Return true if we can run finalizeCrowdsale() properly.
111    *
112    * This is a safety check function that doesn't allow crowdsale to begin
113    * unless the finalizer has been set up properly.
114    */
115   function isSane() public constant returns (bool);
116 
117   /** Called once by crowdsale finalize() if the sale was success. */
118   function finalizeCrowdsale();
119 
120 }
121 
122 contract ERC20Basic {
123   uint256 public totalSupply;
124   function balanceOf(address who) constant returns (uint256);
125   function transfer(address to, uint256 value) returns (bool);
126   event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 contract ERC20 is ERC20Basic {
130   function allowance(address owner, address spender) constant returns (uint256);
131   function transferFrom(address from, address to, uint256 value) returns (bool);
132   function approve(address spender, uint256 value) returns (bool);
133   event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 contract FractionalERC20 is ERC20 {
137 
138   uint public decimals;
139 
140 }
141 
142 library SafeMathLib {
143 
144   function times(uint a, uint b) returns (uint) {
145     uint c = a * b;
146     assert(a == 0 || c / a == b);
147     return c;
148   }
149 
150   function minus(uint a, uint b) returns (uint) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   function plus(uint a, uint b) returns (uint) {
156     uint c = a + b;
157     assert(c>=a);
158     return c;
159   }
160 
161 }
162 
163 contract CrowdsaleBase is Haltable {
164 
165   /* Max investment count when we are still allowed to change the multisig address */
166   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
167 
168   using SafeMathLib for uint;
169 
170   /* The token we are selling */
171   FractionalERC20 public token;
172 
173   /* How we are going to price our offering */
174   PricingStrategy public pricingStrategy;
175 
176   /* Post-success callback */
177   FinalizeAgent public finalizeAgent;
178 
179   /* tokens will be transfered from this address */
180   address public multisigWallet;
181 
182   /* if the funding goal is not reached, investors may withdraw their funds */
183   uint public minimumFundingGoal;
184 
185   /* the UNIX timestamp start date of the crowdsale */
186   uint public startsAt;
187 
188   /* the UNIX timestamp end date of the crowdsale */
189   uint public endsAt;
190 
191   /* the number of tokens already sold through this contract*/
192   uint public tokensSold = 0;
193 
194   /* How many wei of funding we have raised */
195   uint public weiRaised = 0;
196 
197   /* Calculate incoming funds from presale contracts and addresses */
198   uint public presaleWeiRaised = 0;
199 
200   /* How many distinct addresses have invested */
201   uint public investorCount = 0;
202 
203   /* How much wei we have returned back to the contract after a failed crowdfund. */
204   uint public loadedRefund = 0;
205 
206   /* How much wei we have given back to investors.*/
207   uint public weiRefunded = 0;
208 
209   /* Has this crowdsale been finalized */
210   bool public finalized;
211 
212   /** How much ETH each address has invested to this crowdsale */
213   mapping (address => uint256) public investedAmountOf;
214 
215   /** How much tokens this crowdsale has credited for each investor address */
216   mapping (address => uint256) public tokenAmountOf;
217 
218   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
219   mapping (address => bool) public earlyParticipantWhitelist;
220 
221   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
222   uint public ownerTestValue;
223 
224   /** State machine
225    *
226    * - Preparing: All contract initialization calls and variables have not been set yet
227    * - Prefunding: We have not passed start time yet
228    * - Funding: Active crowdsale
229    * - Success: Minimum funding goal reached
230    * - Failure: Minimum funding goal not reached before ending time
231    * - Finalized: The finalized has been called and succesfully executed
232    * - Refunding: Refunds are loaded on the contract for reclaim.
233    */
234   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
235 
236   // A new investment was made
237   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
238 
239   // Refund was processed for a contributor
240   event Refund(address investor, uint weiAmount);
241 
242   // The rules were changed what kind of investments we accept
243   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
244 
245   // Address early participation whitelist status changed
246   event Whitelisted(address addr, bool status);
247 
248   // Crowdsale end time has been changed
249   event EndsAtChanged(uint newEndsAt);
250 
251   State public testState;
252 
253   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
254 
255     owner = msg.sender;
256 
257     token = FractionalERC20(_token);
258 
259     setPricingStrategy(_pricingStrategy);
260 
261     multisigWallet = _multisigWallet;
262     if(multisigWallet == 0) {
263         throw;
264     }
265 
266     if(_start == 0) {
267         throw;
268     }
269 
270     startsAt = _start;
271 
272     if(_end == 0) {
273         throw;
274     }
275 
276     endsAt = _end;
277 
278     // Don't mess the dates
279     if(startsAt >= endsAt) {
280         throw;
281     }
282 
283     // Minimum funding goal can be zero
284     minimumFundingGoal = _minimumFundingGoal;
285   }
286 
287   /**
288    * Don't expect to just send in money and get tokens.
289    */
290   function() payable {
291     throw;
292   }
293 
294   /**
295    * Make an investment.
296    *
297    * Crowdsale must be running for one to invest.
298    * We must have not pressed the emergency brake.
299    *
300    * @param receiver The Ethereum address who receives the tokens
301    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
302    *
303    * @return tokenAmount How mony tokens were bought
304    */
305   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
306 
307     // Determine if it's a good time to accept investment from this participant
308     if(getState() == State.PreFunding) {
309       // Are we whitelisted for early deposit
310       if(!earlyParticipantWhitelist[receiver]) {
311         throw;
312       }
313     } else if(getState() == State.Funding) {
314       // Retail participants can only come in when the crowdsale is running
315       // pass
316     } else {
317       // Unwanted state
318       throw;
319     }
320 
321     uint weiAmount = msg.value;
322 
323     // Account presale sales separately, so that they do not count against pricing tranches
324     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
325 
326     // Dust transaction
327     require(tokenAmount != 0);
328 
329     if(investedAmountOf[receiver] == 0) {
330        // A new investor
331        investorCount++;
332     }
333 
334     // Update investor
335     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
336     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
337 
338     // Update totals
339     weiRaised = weiRaised.plus(weiAmount);
340     tokensSold = tokensSold.plus(tokenAmount);
341 
342     if(pricingStrategy.isPresalePurchase(receiver)) {
343         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
344     }
345 
346     // Check that we did not bust the cap
347     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
348 
349     assignTokens(receiver, tokenAmount);
350 
351     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
352     if(!multisigWallet.send(weiAmount)) throw;
353 
354     // Tell us invest was success
355     Invested(receiver, weiAmount, tokenAmount, customerId);
356 
357     return tokenAmount;
358   }
359 
360   /**
361    * Finalize a succcesful crowdsale.
362    *
363    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
364    */
365   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
366 
367     // Already finalized
368     if(finalized) {
369       throw;
370     }
371 
372     // Finalizing is optional. We only call it if we are given a finalizing agent.
373     if(address(finalizeAgent) != 0) {
374       finalizeAgent.finalizeCrowdsale();
375     }
376 
377     finalized = true;
378   }
379 
380   /**
381    * Allow to (re)set finalize agent.
382    *
383    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
384    */
385   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
386     finalizeAgent = addr;
387 
388     // Don't allow setting bad agent
389     if(!finalizeAgent.isFinalizeAgent()) {
390       throw;
391     }
392   }
393 
394   /**
395    * Allow crowdsale owner to close early or extend the crowdsale.
396    *
397    * This is useful e.g. for a manual soft cap implementation:
398    * - after X amount is reached determine manual closing
399    *
400    * This may put the crowdsale to an invalid state,
401    * but we trust owners know what they are doing.
402    *
403    */
404   function setEndsAt(uint time) onlyOwner {
405 
406     if(now > time) {
407       throw; // Don't change past
408     }
409 
410     if(startsAt > time) {
411       throw; // Prevent human mistakes
412     }
413 
414     endsAt = time;
415     EndsAtChanged(endsAt);
416   }
417 
418   /**
419    * Allow to (re)set pricing strategy.
420    *
421    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
422    */
423   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
424     pricingStrategy = _pricingStrategy;
425 
426     // Don't allow setting bad agent
427     if(!pricingStrategy.isPricingStrategy()) {
428       throw;
429     }
430   }
431 
432   /**
433    * Allow to change the team multisig address in the case of emergency.
434    *
435    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
436    * (we have done only few test transactions). After the crowdsale is going
437    * then multisig address stays locked for the safety reasons.
438    */
439   function setMultisig(address addr) public onlyOwner {
440 
441     // Change
442     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
443       throw;
444     }
445 
446     multisigWallet = addr;
447   }
448 
449   /**
450    * Allow load refunds back on the contract for the refunding.
451    *
452    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
453    */
454   function loadRefund() public payable inState(State.Failure) {
455     if(msg.value == 0) throw;
456     loadedRefund = loadedRefund.plus(msg.value);
457   }
458 
459   /**
460    * Investors can claim refund.
461    *
462    * Note that any refunds from proxy buyers should be handled separately,
463    * and not through this contract.
464    */
465   function refund() public inState(State.Refunding) {
466     uint256 weiValue = investedAmountOf[msg.sender];
467     if (weiValue == 0) throw;
468     investedAmountOf[msg.sender] = 0;
469     weiRefunded = weiRefunded.plus(weiValue);
470     Refund(msg.sender, weiValue);
471     if (!msg.sender.send(weiValue)) throw;
472   }
473 
474   /**
475    * @return true if the crowdsale has raised enough money to be a successful.
476    */
477   function isMinimumGoalReached() public constant returns (bool reached) {
478     return weiRaised >= minimumFundingGoal;
479   }
480 
481   /**
482    * Check if the contract relationship looks good.
483    */
484   function isFinalizerSane() public constant returns (bool sane) {
485     return finalizeAgent.isSane();
486   }
487 
488   /**
489    * Check if the contract relationship looks good.
490    */
491   function isPricingSane() public constant returns (bool sane) {
492     return pricingStrategy.isSane(address(this));
493   }
494 
495   /**
496    * Crowdfund state machine management.
497    *
498    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
499    */
500   function getState() public constant returns (State) {
501     if(finalized) return State.Finalized;
502     else if (address(finalizeAgent) == 0) return State.Preparing;
503     else if (!finalizeAgent.isSane()) return State.Preparing;
504     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
505     else if (block.timestamp < startsAt) return State.PreFunding;
506     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
507     else if (isMinimumGoalReached()) return State.Success;
508     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
509     else return State.Failure;
510   }
511 
512   /** This is for manual testing of multisig wallet interaction */
513   function setOwnerTestValue(uint val) onlyOwner {
514     ownerTestValue = val;
515   }
516 
517   /**
518    * Allow addresses to do early participation.
519    *
520    * TODO: Fix spelling error in the name
521    */
522   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
523     earlyParticipantWhitelist[addr] = status;
524     Whitelisted(addr, status);
525   }
526 
527 
528   /** Interface marker. */
529   function isCrowdsale() public constant returns (bool) {
530     return true;
531   }
532 
533   //
534   // Modifiers
535   //
536 
537   /** Modified allowing execution only if the crowdsale is currently running.  */
538   modifier inState(State state) {
539     if(getState() != state) throw;
540     _;
541   }
542 
543 
544   //
545   // Abstract functions
546   //
547 
548   /**
549    * Check if the current invested breaks our cap rules.
550    *
551    *
552    * The child contract must define their own cap setting rules.
553    * We allow a lot of flexibility through different capping strategies (ETH, token count)
554    * Called from invest().
555    *
556    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
557    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
558    * @param weiRaisedTotal What would be our total raised balance after this transaction
559    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
560    *
561    * @return true if taking this investment would break our cap rules
562    */
563   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
564 
565   /**
566    * Check if the current crowdsale is full and we can no longer sell any tokens.
567    */
568   function isCrowdsaleFull() public constant returns (bool);
569 
570   /**
571    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
572    */
573   function assignTokens(address receiver, uint tokenAmount) internal;
574 }
575 
576 contract Crowdsale is CrowdsaleBase {
577 
578   /* Do we need to have unique contributor id for each customer */
579   bool public requireCustomerId;
580 
581   /**
582     * Do we verify that contributor has been cleared on the server side (accredited investors only).
583     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
584     */
585   bool public requiredSignedAddress;
586 
587   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
588   address public signerAddress;
589 
590   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
591   }
592 
593   /**
594    * Preallocate tokens for the early investors.
595    *
596    * Preallocated tokens have been sold before the actual crowdsale opens.
597    * This function mints the tokens and moves the crowdsale needle.
598    *
599    * Investor count is not handled; it is assumed this goes for multiple investors
600    * and the token distribution happens outside the smart contract flow.
601    *
602    * No money is exchanged, as the crowdsale team already have received the payment.
603    *
604    * @param fullTokens tokens as full tokens - decimal places added internally
605    * @param weiPrice Price of a single full token in wei
606    *
607    */
608   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
609 
610     uint tokenAmount = fullTokens * 10**token.decimals();
611     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
612 
613     weiRaised = weiRaised.plus(weiAmount);
614     tokensSold = tokensSold.plus(tokenAmount);
615 
616     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
617     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
618 
619     assignTokens(receiver, tokenAmount);
620 
621     // Tell us invest was success
622     Invested(receiver, weiAmount, tokenAmount, 0);
623   }
624 
625   /**
626    * Allow anonymous contributions to this crowdsale.
627    */
628   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
629      bytes32 hash = sha256(addr);
630      if (ecrecover(hash, v, r, s) != signerAddress) throw;
631      if(customerId == 0) throw;  // UUIDv4 sanity check
632      investInternal(addr, customerId);
633   }
634 
635   /**
636    * Track who is the customer making the payment so we can send thank you email.
637    */
638   function investWithCustomerId(address addr, uint128 customerId) public payable {
639     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
640     if(customerId == 0) throw;  // UUIDv4 sanity check
641     investInternal(addr, customerId);
642   }
643 
644   /**
645    * Allow anonymous contributions to this crowdsale.
646    */
647   function invest(address addr) public payable {
648     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
649     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
650     investInternal(addr, 0);
651   }
652 
653   /**
654    * Invest to tokens, recognize the payer and clear his address.
655    *
656    */
657   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
658     investWithSignedAddress(msg.sender, customerId, v, r, s);
659   }
660 
661   /**
662    * Invest to tokens, recognize the payer.
663    *
664    */
665   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
666     // see customerid.py
667     if (bytes1(sha3(customerId)) != checksum) throw;
668     investWithCustomerId(msg.sender, customerId);
669   }
670 
671   /**
672    * Legacy API signature.
673    */
674   function buyWithCustomerId(uint128 customerId) public payable {
675     investWithCustomerId(msg.sender, customerId);
676   }
677 
678   /**
679    * The basic entry point to participate the crowdsale process.
680    *
681    * Pay for funding, get invested tokens back in the sender address.
682    */
683   function buy() public payable {
684     invest(msg.sender);
685   }
686 
687   /**
688    * Set policy do we need to have server-side customer ids for the investments.
689    *
690    */
691   function setRequireCustomerId(bool value) onlyOwner {
692     requireCustomerId = value;
693     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
694   }
695 
696   /**
697    * Set policy if all investors must be cleared on the server side first.
698    *
699    * This is e.g. for the accredited investor clearing.
700    *
701    */
702   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
703     requiredSignedAddress = value;
704     signerAddress = _signerAddress;
705     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
706   }
707 
708 }
709 
710 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
711 
712   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
713   address public beneficiary;
714 
715   /**
716    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
717    *
718    */
719   function AllocatedCrowdsaleMixin(address _beneficiary) {
720     beneficiary = _beneficiary;
721   }
722 
723   /**
724    * Called from invest() to confirm if the curret investment does not break our cap rule.
725    */
726   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
727     if(tokenAmount > getTokensLeft()) {
728       return true;
729     } else {
730       return false;
731     }
732   }
733 
734   /**
735    * We are sold out when our approve pool becomes empty.
736    */
737   function isCrowdsaleFull() public constant returns (bool) {
738     return getTokensLeft() == 0;
739   }
740 
741   /**
742    * Get the amount of unsold tokens allocated to this contract;
743    */
744   function getTokensLeft() public constant returns (uint) {
745     return token.allowance(owner, this);
746   }
747 
748   /**
749    * Transfer tokens from approve() pool to the buyer.
750    *
751    * Use approve() given to this crowdsale to distribute the tokens.
752    */
753   function assignTokens(address receiver, uint tokenAmount) internal {
754     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
755   }
756 }
757 
758 contract AllocatedCrowdsale is AllocatedCrowdsaleMixin, Crowdsale {
759 
760   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
761 
762   }
763 
764 }