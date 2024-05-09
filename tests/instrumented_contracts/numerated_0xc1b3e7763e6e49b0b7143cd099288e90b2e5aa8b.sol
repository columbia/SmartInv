1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.15;
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) public view returns (uint256);
28   function transferFrom(address from, address to, uint256 value) public returns (bool);
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 /**
34  * A token that defines fractional units as decimals.
35  */
36 contract FractionalERC20 is ERC20 {
37 
38   uint public decimals;
39 
40 }
41 
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 /**
86  * Abstract base contract for token sales.
87  *
88  * Handle
89  * - start and end dates
90  * - accepting investments
91  * - minimum funding goal and refund
92  * - various statistics during the crowdfund
93  * - different pricing strategies
94  * - different investment policies (require server side customer id, allow only whitelisted addresses)
95  *
96  */
97 contract Crowdsale is Ownable {
98   /* Max investment count when we are still allowed to change the multisig address */
99   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
100 
101   using SafeMath for uint;
102 
103   /* The token we are selling */
104   FractionalERC20 public token;
105 
106   /* How we are going to price our offering */
107   PricingStrategy public pricingStrategy;
108 
109   /* Post-success callback */
110   FinalizeAgent public finalizeAgent;
111 
112   /* tokens will be transfered from this address */
113   address public multisigWallet;
114 
115   /* if the funding goal is not reached, investors may withdraw their funds */
116   uint public minimumFundingGoal;
117 
118   /* the UNIX timestamp start date of the crowdsale */
119   uint public startsAt;
120 
121   /* the UNIX timestamp end date of the crowdsale */
122   uint public endsAt;
123 
124   /* the number of tokens already sold through this contract*/
125   uint public tokensSold = 0;
126 
127   /* How many wei of funding we have raised */
128   uint public weiRaised = 0;
129 
130   /* Calculate incoming funds from presale contracts and addresses */
131   uint public presaleWeiRaised = 0;
132 
133   /* How many distinct addresses have invested */
134   uint public investorCount = 0;
135 
136   /* How much wei we have returned back to the contract after a failed crowdfund. */
137   uint public loadedRefund = 0;
138 
139   /* How much wei we have given back to investors.*/
140   uint public weiRefunded = 0;
141 
142   /* Has this crowdsale been finalized */
143   bool public finalized;
144 
145   /* Do we need to have unique contributor id for each customer */
146   bool public requireCustomerId;
147 
148   /**
149     * Do we verify that contributor has been cleared on the server side (accredited investors only).
150     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
151     */
152   bool public requiredSignedAddress;
153 
154   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
155   address public signerAddress;
156 
157   /** How much ETH each address has invested to this crowdsale */
158   mapping (address => uint256) public investedAmountOf;
159 
160   /** How much tokens this crowdsale has credited for each investor address */
161   mapping (address => uint256) public tokenAmountOf;
162 
163   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
164   mapping (address => bool) public earlyParticipantWhitelist;
165 
166   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
167   uint public ownerTestValue;
168 
169   /** State machine
170    *
171    * - Preparing: All contract initialization calls and variables have not been set yet
172    * - Prefunding: We have not passed start time yet
173    * - Funding: Active crowdsale
174    * - Success: Minimum funding goal reached
175    * - Failure: Minimum funding goal not reached before ending time
176    * - Finalized: The finalized has been called and succesfully executed
177    * - Refunding: Refunds are loaded on the contract for reclaim.
178    */
179   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
180 
181   // A new investment was made
182   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
183 
184   // Refund was processed for a contributor
185   event Refund(address investor, uint weiAmount);
186 
187   // The rules were changed what kind of investments we accept
188   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
189 
190   // Address early participation whitelist status changed
191   event Whitelisted(address addr, bool status);
192 
193   // Crowdsale end time has been changed
194   event EndsAtChanged(uint newEndsAt);
195 
196   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
197 
198     owner = msg.sender;
199 
200     token = FractionalERC20(_token);
201 
202     setPricingStrategy(_pricingStrategy);
203 
204     multisigWallet = _multisigWallet;
205     if (multisigWallet == 0) {
206         revert();
207     }
208 
209     if (_start == 0) {
210         revert();
211     }
212 
213     startsAt = _start;
214 
215     if (_end == 0) {
216         revert();
217     }
218 
219     endsAt = _end;
220 
221     // Don't mess the dates
222     if (startsAt >= endsAt) {
223         revert();
224     }
225 
226     // Minimum funding goal can be zero
227     minimumFundingGoal = _minimumFundingGoal;
228   }
229 
230   function() payable {
231     buy();
232   }
233 
234   /**
235    * Make an investment.
236    *
237    * Crowdsale must be running for one to invest.
238    * We must have not pressed the emergency brake.
239    *
240    * @param receiver The Ethereum address who receives the tokens
241    * @param customerId (optional) UUID v4 to track the successful payments on the server side
242    *
243    */
244   function investInternal(address receiver, uint128 customerId) private {
245     
246     // Determine if it's a good time to accept investment from this participant
247     if (getState() == State.PreFunding) {
248       // Are we whitelisted for early deposit
249       if (!earlyParticipantWhitelist[receiver]) {
250         revert();
251       }
252     } else if (getState() == State.Funding) {
253       // Retail participants can only come in when the crowdsale is running
254       // pass
255     } else {
256       // Unwanted state
257       revert();
258     }
259     
260     uint weiAmount = msg.value;
261 
262     // Account presale sales separately, so that they do not count against pricing tranches
263     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
264 
265     if (tokenAmount == 0) {
266       // Dust transaction
267       revert();
268     }
269 
270     if (investedAmountOf[receiver] == 0) {
271        // A new investor
272        investorCount++;
273     }
274 
275     // Update investor
276     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
277 
278     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
279 
280     
281     // Update totals
282     weiRaised = weiRaised.add(weiAmount);
283     tokensSold = tokensSold.add(tokenAmount);
284 
285     if (pricingStrategy.isPresalePurchase(receiver)) {
286         presaleWeiRaised = presaleWeiRaised.add(weiAmount);
287     }
288 
289     // Check that we did not bust the cap
290     if (isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
291       revert();
292     }
293 
294     assignTokens(receiver, tokenAmount);
295   
296     // Pocket the money
297     if (!multisigWallet.send(weiAmount)) 
298       revert();
299   
300     // Tell us invest was success
301     Invested(receiver, weiAmount, tokenAmount, customerId);
302     
303   }
304 
305   /**
306    * Preallocate tokens for the early investors.
307    *
308    * Preallocated tokens have been sold before the actual crowdsale opens.
309    * This function mints the tokens and moves the crowdsale needle.
310    *
311    * Investor count is not handled; it is assumed this goes for multiple investors
312    * and the token distribution happens outside the smart contract flow.
313    *
314    * No money is exchanged, as the crowdsale team already have received the payment.
315    *
316    * @param fullTokens tokens as full tokens - decimal places added internally
317    * @param weiPrice Price of a single full token in wei
318    *
319    */
320   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
321 
322     uint tokenAmount = fullTokens * 10**token.decimals();
323     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
324 
325     weiRaised = weiRaised.add(weiAmount);
326     tokensSold = tokensSold.add(tokenAmount);
327 
328     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
329     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
330 
331     assignTokens(receiver, tokenAmount);
332 
333     // Tell us invest was success
334     Invested(receiver, weiAmount, tokenAmount, 0);
335   }
336 
337   /**
338    * Allow anonymous contributions to this crowdsale.
339    */
340   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
341      bytes32 hash = sha256(addr);
342      if (ecrecover(hash, v, r, s) != signerAddress) 
343       revert();
344      if (customerId == 0) 
345       revert();  // UUIDv4 sanity check
346      investInternal(addr, customerId);
347   }
348 
349   /**
350    * Track who is the customer making the payment so we can send thank you email.
351    */
352   function investWithCustomerId(address addr, uint128 customerId) public payable {
353     if (requiredSignedAddress) 
354       revert(); // Crowdsale allows only server-side signed participants
355     if (customerId == 0) 
356       revert();  // UUIDv4 sanity check
357     investInternal(addr, customerId);
358   }
359 
360   /**
361    * Allow anonymous contributions to this crowdsale.
362    */
363   function invest(address addr) public payable {
364     if (requireCustomerId) 
365       revert(); // Crowdsale needs to track partipants for thank you email
366     if (requiredSignedAddress) 
367       revert(); // Crowdsale allows only server-side signed participants
368     investInternal(addr, 0);
369   }
370 
371   /**
372    * Invest to tokens, recognize the payer and clear his address.
373    *
374    */
375   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
376     investWithSignedAddress(msg.sender, customerId, v, r, s);
377   }
378 
379   /**
380    * Invest to tokens, recognize the payer.
381    *
382    */
383   function buyWithCustomerId(uint128 customerId) public payable {
384     investWithCustomerId(msg.sender, customerId);
385   }
386 
387   /**
388    * The basic entry point to participate the crowdsale process.
389    *
390    * Pay for funding, get invested tokens back in the sender address.
391    */
392   function buy() public payable {
393     invest(msg.sender);
394   }
395 
396   /**
397    * Finalize a succcesful crowdsale.
398    *
399    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
400    */
401   function finalize() public inState(State.Success) onlyOwner {
402 
403     // Already finalized
404     if (finalized) {
405       revert();
406     }
407 
408     // Finalizing is optional. We only call it if we are given a finalizing agent.
409     if (address(finalizeAgent) != 0) {
410       finalizeAgent.finalizeCrowdsale();
411     }
412 
413     finalized = true;
414   }
415 
416   /**
417    * Allow to (re)set finalize agent.
418    *
419    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
420    */
421   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
422     finalizeAgent = addr;
423 
424     // Don't allow setting bad agent
425     if (!finalizeAgent.isFinalizeAgent()) {
426       revert();
427     }
428   }
429 
430   /**
431    * Set policy do we need to have server-side customer ids for the investments.
432    *
433    */
434   function setRequireCustomerId(bool value) onlyOwner {
435     requireCustomerId = value;
436     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
437   }
438 
439   /**
440    * Set policy if all investors must be cleared on the server side first.
441    *
442    * This is e.g. for the accredited investor clearing.
443    *
444    */
445   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
446     requiredSignedAddress = value;
447     signerAddress = _signerAddress;
448     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
449   }
450 
451   /**
452    * Allow addresses to do early participation.
453    */
454   function setEarlyParticipantWhitelist(address addr, bool status) onlyOwner {
455     earlyParticipantWhitelist[addr] = status;
456     Whitelisted(addr, status);
457   }
458 
459   /**
460    * Allow crowdsale owner to close early or extend the crowdsale.
461    *
462    * This is useful e.g. for a manual soft cap implementation:
463    * - after X amount is reached determine manual closing
464    *
465    * This may put the crowdsale to an invalid state,
466    * but we trust owners know what they are doing.
467    *
468    */
469   function setEndsAt(uint time) onlyOwner {
470     if (now > time) {
471       revert(); // Don't change past
472     }
473 
474     endsAt = time;
475     EndsAtChanged(endsAt);
476   }
477 
478   /**
479    * Allow to (re)set pricing strategy.
480    *
481    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
482    */
483   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
484     pricingStrategy = _pricingStrategy;
485 
486     // Don't allow setting bad agent
487     if (!pricingStrategy.isPricingStrategy()) {
488       revert();
489     }
490   }
491 
492   /**
493    * Allow to change the team multisig address in the case of emergency.
494    *
495    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
496    * (we have done only few test transactions). After the crowdsale is going
497    * then multisig address stays locked for the safety reasons.
498    */
499   function setMultisig(address addr) public onlyOwner {
500 
501     // Change
502     if (investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
503       revert();
504     }
505 
506     multisigWallet = addr;
507   }
508 
509   /**
510    * Allow load refunds back on the contract for the refunding.
511    *
512    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
513    */
514   function loadRefund() public payable inState(State.Failure) {
515     if (msg.value == 0) 
516       revert();
517     loadedRefund = loadedRefund.add(msg.value);
518   }
519 
520   /**
521    * Investors can claim refund.
522    *
523    * Note that any refunds from proxy buyers should be handled separately,
524    * and not through this contract.
525    */
526   function refund() public inState(State.Refunding) {
527     uint256 weiValue = investedAmountOf[msg.sender];
528     if (weiValue == 0) 
529       revert();
530     investedAmountOf[msg.sender] = 0;
531     weiRefunded = weiRefunded.add(weiValue);
532     Refund(msg.sender, weiValue);
533     if (!msg.sender.send(weiValue)) 
534       revert();
535   }
536 
537   /**
538    * @return true if the crowdsale has raised enough money to be a successful.
539    */
540   function isMinimumGoalReached() public constant returns (bool reached) {
541     return weiRaised >= minimumFundingGoal;
542   }
543 
544   /**
545    * Check if the contract relationship looks good.
546    */
547   function isFinalizerSane() public constant returns (bool sane) {
548     return finalizeAgent.isSane();
549   }
550 
551   /**
552    * Check if the contract relationship looks good.
553    */
554   function isPricingSane() public constant returns (bool sane) {
555     return pricingStrategy.isSane(address(this));
556   }
557 
558   /**
559    * Crowdfund state machine management.
560    *
561    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
562    */
563   function getState() public constant returns (State) {
564     if (finalized) 
565       return State.Finalized;
566     else if (address(finalizeAgent) == 0) 
567       return State.Preparing;
568     else if (!finalizeAgent.isSane()) 
569       return State.Preparing;
570     else if (!pricingStrategy.isSane(address(this))) 
571       return State.Preparing;
572     else if (block.timestamp < startsAt) 
573       return State.PreFunding;
574     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) 
575       return State.Funding;
576     else if (isMinimumGoalReached()) 
577       return State.Success;
578     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) 
579       return State.Refunding;
580     else 
581       return State.Failure;
582   }
583 
584   /** This is for manual testing of multisig wallet interaction */
585   function setOwnerTestValue(uint val) onlyOwner {
586     ownerTestValue = val;
587   }
588 
589   /** Interface marker. */
590   function isCrowdsale() public constant returns (bool) {
591     return true;
592   }
593 
594   //
595   // Modifiers
596   //
597 
598   /** Modified allowing execution only if the crowdsale is currently running.  */
599   modifier inState(State state) {
600     if (getState() != state) 
601       revert();
602     _;
603   }
604 
605 
606   //
607   // Abstract functions
608   //
609 
610   /**
611    * Check if the current invested breaks our cap rules.
612    *
613    *
614    * The child contract must define their own cap setting rules.
615    * We allow a lot of flexibility through different capping strategies (ETH, token count)
616    * Called from invest().
617    *
618    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
619    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
620    * @param weiRaisedTotal What would be our total raised balance after this transaction
621    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
622    *
623    * @return true if taking this investment would break our cap rules
624    */
625   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
626 
627   /**
628    * Check if the current crowdsale is full and we can no longer sell any tokens.
629    */
630   function isCrowdsaleFull() public constant returns (bool);
631 
632   /**
633    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
634    */
635   function assignTokens(address receiver, uint tokenAmount) private;
636 }
637 
638 /**
639  * Interface for defining crowdsale pricing.
640  */
641 contract PricingStrategy {
642 
643   /** Interface declaration. */
644   function isPricingStrategy() public constant returns (bool) {
645     return true;
646   }
647 
648   /** Self check if all references are correctly set.
649    *
650    * Checks that pricing strategy matches crowdsale parameters.
651    */
652   function isSane(address crowdsale) public constant returns (bool) {
653     return true;
654   }
655 
656   /**
657    * @dev Pricing tells if this is a presale purchase or not.
658      @param purchaser Address of the purchaser
659      @return False by default, true if a presale purchaser
660    */
661   function isPresalePurchase(address purchaser) public constant returns (bool) {
662     return false;
663   }
664 
665   /**
666    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
667    *
668    *
669    * @param value - What is the value of the transaction send in as wei
670    * @param tokensSold - how much tokens have been sold this far
671    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
672    * @param msgSender - who is the investor of this transaction
673    * @param decimals - how many decimal units the token has
674    * @return Amount of tokens the investor receives
675    */
676   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
677 }
678 
679 /**
680  * A crowdsale that is selling tokens from a preallocated pool
681  *
682  *
683  * - Tokens have precreated supply "premined"
684  *
685  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
686  *
687  */
688 contract AllocatedCrowdsale is Crowdsale {
689 
690   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
691   address public beneficiary;
692 
693   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) 
694     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
695     beneficiary = _beneficiary;
696   }
697 
698   /**
699    * Called from invest() to confirm if the curret investment does not break our cap rule.
700    */
701   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
702     if (tokenAmount > getTokensLeft()) {
703       return true;
704     } else {
705       return false;
706     }
707   }
708 
709   /**
710    * We are sold out when our approve pool becomes empty.
711    */
712   function isCrowdsaleFull() public constant returns (bool) {
713     return getTokensLeft() == 0;
714   }
715 
716   /**
717    * Get the amount of unsold tokens allocated to this contract;
718    */
719   function getTokensLeft() public constant returns (uint) {
720     return token.allowance(owner, this);
721   }
722 
723   /**
724    * Transfer tokens from approve() pool to the buyer.
725    *
726    * Use approve() given to this crowdsale to distribute the tokens.
727    */
728   function assignTokens(address receiver, uint tokenAmount) private {
729     if (!token.transferFrom(beneficiary, receiver, tokenAmount)) 
730       revert();
731   }
732 }
733 
734 
735 /**
736  * Finalize agent defines what happens at the end of succeseful crowdsale.
737  *
738  * - Allocate tokens for founders, bounties and community
739  * - Make tokens transferable
740  * - etc.
741  */
742 contract FinalizeAgent {
743 
744   function isFinalizeAgent() public constant returns(bool) {
745     return true;
746   }
747 
748   /** Return true if we can run finalizeCrowdsale() properly.
749    *
750    * This is a safety check function that doesn't allow crowdsale to begin
751    * unless the finalizer has been set up properly.
752    */
753   function isSane() public constant returns (bool);
754 
755   /** Called once by crowdsale finalize() if the sale was success. */
756   function finalizeCrowdsale();
757 
758 }
759 
760 
761 
762 /**
763  * @title SafeMath
764  * @dev Math operations with safety checks that throw on error
765  */
766 library SafeMath {
767   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
768     if (a == 0) {
769       return 0;
770     }
771     uint256 c = a * b;
772     assert(c / a == b);
773     return c;
774   }
775 
776   function div(uint256 a, uint256 b) internal pure returns (uint256) {
777     // assert(b > 0); // Solidity automatically throws when dividing by 0
778     uint256 c = a / b;
779     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
780     return c;
781   }
782 
783   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
784     assert(b <= a);
785     return a - b;
786   }
787 
788   function add(uint256 a, uint256 b) internal pure returns (uint256) {
789     uint256 c = a + b;
790     assert(c >= a);
791     return c;
792   }
793 }