1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 /**
23  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
24  *
25  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
26  */
27 
28 
29 
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));      
64     owner = newOwner;
65   }
66 
67 }
68 
69 
70 /*
71  * Haltable
72  *
73  * Abstract contract that allows children to implement an
74  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
75  *
76  *
77  * Originally envisioned in FirstBlood ICO contract.
78  */
79 contract Haltable is Ownable {
80   bool public halted;
81 
82   modifier stopInEmergency {
83     if (halted) throw;
84     _;
85   }
86 
87   modifier stopNonOwnersInEmergency {
88     if (halted && msg.sender != owner) throw;
89     _;
90   }
91 
92   modifier onlyInEmergency {
93     if (!halted) throw;
94     _;
95   }
96 
97   // called by the owner on emergency, triggers stopped state
98   function halt() external onlyOwner {
99     halted = true;
100   }
101 
102   // called by the owner on end of emergency, returns to normal state
103   function unhalt() external onlyOwner onlyInEmergency {
104     halted = false;
105   }
106 
107 }
108 
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 /**
117  * Safe unsigned safe math.
118  *
119  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
120  *
121  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
122  *
123  * Maintained here until merged to mainline zeppelin-solidity.
124  *
125  */
126 library SafeMathLib {
127 
128   function times(uint a, uint b) returns (uint) {
129     uint c = a * b;
130     assert(a == 0 || c / a == b);
131     return c;
132   }
133 
134   function minus(uint a, uint b) returns (uint) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   function plus(uint a, uint b) returns (uint) {
140     uint c = a + b;
141     assert(c>=a);
142     return c;
143   }
144 
145 }
146 
147 /**
148  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
149  *
150  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
151  */
152 
153 
154 
155 
156 
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   uint256 public totalSupply;
165   function balanceOf(address who) constant returns (uint256);
166   function transfer(address to, uint256 value) returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) constant returns (uint256);
178   function transferFrom(address from, address to, uint256 value) returns (bool);
179   function approve(address spender, uint256 value) returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 /**
185  * A token that defines fractional units as decimals.
186  */
187 contract FractionalERC20 is ERC20 {
188 
189   uint public decimals;
190 
191 }
192 
193 /**
194  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
195  *
196  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
197  */
198 
199 
200 /**
201  * Interface for defining crowdsale pricing.
202  */
203 contract PricingStrategy {
204 
205   /** Interface declaration. */
206   function isPricingStrategy() public constant returns (bool) {
207     return true;
208   }
209 
210   /** Self check if all references are correctly set.
211    *
212    * Checks that pricing strategy matches crowdsale parameters.
213    */
214   function isSane(address crowdsale) public constant returns (bool) {
215     return true;
216   }
217 
218   /**
219    * @dev Pricing tells if this is a presale purchase or not.
220      @param purchaser Address of the purchaser
221      @return False by default, true if a presale purchaser
222    */
223   function isPresalePurchase(address purchaser) public constant returns (bool) {
224     return false;
225   }
226 
227   /**
228    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
229    *
230    *
231    * @param value - What is the value of the transaction send in as wei
232    * @param tokensSold - how much tokens have been sold this far
233    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
234    * @param msgSender - who is the investor of this transaction
235    * @param decimals - how many decimal units the token has
236    * @return Amount of tokens the investor receives
237    */
238   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
239 }
240 
241 /**
242  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
243  *
244  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
245  */
246 
247 
248 /**
249  * Finalize agent defines what happens at the end of succeseful crowdsale.
250  *
251  * - Allocate tokens for founders, bounties and community
252  * - Make tokens transferable
253  * - etc.
254  */
255 contract FinalizeAgent {
256 
257   function isFinalizeAgent() public constant returns(bool) {
258     return true;
259   }
260 
261   /** Return true if we can run finalizeCrowdsale() properly.
262    *
263    * This is a safety check function that doesn't allow crowdsale to begin
264    * unless the finalizer has been set up properly.
265    */
266   function isSane() public constant returns (bool);
267 
268   /** Called once by crowdsale finalize() if the sale was success. */
269   function finalizeCrowdsale();
270 
271 }
272 
273 
274 
275 /**
276  * Crowdsale state machine without buy functionality.
277  *
278  * Implements basic state machine logic, but leaves out all buy functions,
279  * so that subclasses can implement their own buying logic.
280  *
281  *
282  * For the default buy() implementation see Crowdsale.sol.
283  */
284 contract CrowdsaleBase is Haltable {
285 
286   /* Max investment count when we are still allowed to change the multisig address */
287   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
288 
289   using SafeMathLib for uint;
290 
291   /* The token we are selling */
292   FractionalERC20 public token;
293 
294   /* How we are going to price our offering */
295   PricingStrategy public pricingStrategy;
296 
297   /* Post-success callback */
298   FinalizeAgent public finalizeAgent;
299 
300   /* tokens will be transfered from this address */
301   address public multisigWallet;
302 
303   /* if the funding goal is not reached, investors may withdraw their funds */
304   uint public minimumFundingGoal;
305 
306   /* the UNIX timestamp start date of the crowdsale */
307   uint public startsAt;
308 
309   /* the UNIX timestamp end date of the crowdsale */
310   uint public endsAt;
311 
312   /* the number of tokens already sold through this contract*/
313   uint public tokensSold = 0;
314 
315   /* How many wei of funding we have raised */
316   uint public weiRaised = 0;
317 
318   /* Calculate incoming funds from presale contracts and addresses */
319   uint public presaleWeiRaised = 0;
320 
321   /* How many distinct addresses have invested */
322   uint public investorCount = 0;
323 
324   /* How much wei we have returned back to the contract after a failed crowdfund. */
325   uint public loadedRefund = 0;
326 
327   /* How much wei we have given back to investors.*/
328   uint public weiRefunded = 0;
329 
330   /* Has this crowdsale been finalized */
331   bool public finalized;
332 
333   /** How much ETH each address has invested to this crowdsale */
334   mapping (address => uint256) public investedAmountOf;
335 
336   /** How much tokens this crowdsale has credited for each investor address */
337   mapping (address => uint256) public tokenAmountOf;
338 
339   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
340   mapping (address => bool) public earlyParticipantWhitelist;
341 
342   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
343   uint public ownerTestValue;
344 
345   /** State machine
346    *
347    * - Preparing: All contract initialization calls and variables have not been set yet
348    * - Prefunding: We have not passed start time yet
349    * - Funding: Active crowdsale
350    * - Success: Minimum funding goal reached
351    * - Failure: Minimum funding goal not reached before ending time
352    * - Finalized: The finalized has been called and succesfully executed
353    * - Refunding: Refunds are loaded on the contract for reclaim.
354    */
355   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
356 
357   // A new investment was made
358   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
359 
360   // Refund was processed for a contributor
361   event Refund(address investor, uint weiAmount);
362 
363   // The rules were changed what kind of investments we accept
364   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
365 
366   // Address early participation whitelist status changed
367   event Whitelisted(address addr, bool status);
368 
369   // Crowdsale end time has been changed
370   event EndsAtChanged(uint newEndsAt);
371 
372   State public testState;
373 
374   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
375 
376     owner = msg.sender;
377 
378     token = FractionalERC20(_token);
379 
380     setPricingStrategy(_pricingStrategy);
381 
382     multisigWallet = _multisigWallet;
383     if(multisigWallet == 0) {
384         throw;
385     }
386 
387     if(_start == 0) {
388         throw;
389     }
390 
391     startsAt = _start;
392 
393     if(_end == 0) {
394         throw;
395     }
396 
397     endsAt = _end;
398 
399     // Don't mess the dates
400     if(startsAt >= endsAt) {
401         throw;
402     }
403 
404     // Minimum funding goal can be zero
405     minimumFundingGoal = _minimumFundingGoal;
406   }
407 
408   /**
409    * Don't expect to just send in money and get tokens.
410    */
411   function() payable {
412     throw;
413   }
414 
415   /**
416    * Make an investment.
417    *
418    * Crowdsale must be running for one to invest.
419    * We must have not pressed the emergency brake.
420    *
421    * @param receiver The Ethereum address who receives the tokens
422    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
423    *
424    * @return tokenAmount How mony tokens were bought
425    */
426   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
427 
428     // Determine if it's a good time to accept investment from this participant
429     if(getState() == State.PreFunding) {
430       // Are we whitelisted for early deposit
431       if(!earlyParticipantWhitelist[receiver]) {
432         throw;
433       }
434     } else if(getState() == State.Funding) {
435       // Retail participants can only come in when the crowdsale is running
436       // pass
437     } else {
438       // Unwanted state
439       throw;
440     }
441 
442     uint weiAmount = msg.value;
443 
444     // Account presale sales separately, so that they do not count against pricing tranches
445     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
446 
447     // Dust transaction
448     require(tokenAmount != 0);
449 
450     if(investedAmountOf[receiver] == 0) {
451        // A new investor
452        investorCount++;
453     }
454 
455     // Update investor
456     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
457     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
458 
459     // Update totals
460     weiRaised = weiRaised.plus(weiAmount);
461     tokensSold = tokensSold.plus(tokenAmount);
462 
463     if(pricingStrategy.isPresalePurchase(receiver)) {
464         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
465     }
466 
467     // Check that we did not bust the cap
468     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
469 
470     assignTokens(receiver, tokenAmount);
471 
472     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
473     if(!multisigWallet.send(weiAmount)) throw;
474 
475     // Tell us invest was success
476     Invested(receiver, weiAmount, tokenAmount, customerId);
477 
478     return tokenAmount;
479   }
480 
481   /**
482    * Finalize a succcesful crowdsale.
483    *
484    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
485    */
486   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
487 
488     // Already finalized
489     if(finalized) {
490       throw;
491     }
492 
493     // Finalizing is optional. We only call it if we are given a finalizing agent.
494     if(address(finalizeAgent) != 0) {
495       finalizeAgent.finalizeCrowdsale();
496     }
497 
498     finalized = true;
499   }
500 
501   /**
502    * Allow to (re)set finalize agent.
503    *
504    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
505    */
506   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
507     finalizeAgent = addr;
508 
509     // Don't allow setting bad agent
510     if(!finalizeAgent.isFinalizeAgent()) {
511       throw;
512     }
513   }
514 
515   /**
516    * Allow crowdsale owner to close early or extend the crowdsale.
517    *
518    * This is useful e.g. for a manual soft cap implementation:
519    * - after X amount is reached determine manual closing
520    *
521    * This may put the crowdsale to an invalid state,
522    * but we trust owners know what they are doing.
523    *
524    */
525   function setEndsAt(uint time) onlyOwner {
526 
527     if(now > time) {
528       throw; // Don't change past
529     }
530 
531     if(startsAt > time) {
532       throw; // Prevent human mistakes
533     }
534 
535     endsAt = time;
536     EndsAtChanged(endsAt);
537   }
538 
539   /**
540    * Allow to (re)set pricing strategy.
541    *
542    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
543    */
544   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
545     pricingStrategy = _pricingStrategy;
546 
547     // Don't allow setting bad agent
548     if(!pricingStrategy.isPricingStrategy()) {
549       throw;
550     }
551   }
552 
553   /**
554    * Allow to change the team multisig address in the case of emergency.
555    *
556    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
557    * (we have done only few test transactions). After the crowdsale is going
558    * then multisig address stays locked for the safety reasons.
559    */
560   function setMultisig(address addr) public onlyOwner {
561 
562     // Change
563     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
564       throw;
565     }
566 
567     multisigWallet = addr;
568   }
569 
570   /**
571    * Allow load refunds back on the contract for the refunding.
572    *
573    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
574    */
575   function loadRefund() public payable inState(State.Failure) {
576     if(msg.value == 0) throw;
577     loadedRefund = loadedRefund.plus(msg.value);
578   }
579 
580   /**
581    * Investors can claim refund.
582    *
583    * Note that any refunds from proxy buyers should be handled separately,
584    * and not through this contract.
585    */
586   function refund() public inState(State.Refunding) {
587     uint256 weiValue = investedAmountOf[msg.sender];
588     if (weiValue == 0) throw;
589     investedAmountOf[msg.sender] = 0;
590     weiRefunded = weiRefunded.plus(weiValue);
591     Refund(msg.sender, weiValue);
592     if (!msg.sender.send(weiValue)) throw;
593   }
594 
595   /**
596    * @return true if the crowdsale has raised enough money to be a successful.
597    */
598   function isMinimumGoalReached() public constant returns (bool reached) {
599     return weiRaised >= minimumFundingGoal;
600   }
601 
602   /**
603    * Check if the contract relationship looks good.
604    */
605   function isFinalizerSane() public constant returns (bool sane) {
606     return finalizeAgent.isSane();
607   }
608 
609   /**
610    * Check if the contract relationship looks good.
611    */
612   function isPricingSane() public constant returns (bool sane) {
613     return pricingStrategy.isSane(address(this));
614   }
615 
616   /**
617    * Crowdfund state machine management.
618    *
619    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
620    */
621   function getState() public constant returns (State) {
622     if(finalized) return State.Finalized;
623     else if (address(finalizeAgent) == 0) return State.Preparing;
624     else if (!finalizeAgent.isSane()) return State.Preparing;
625     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
626     else if (block.timestamp < startsAt) return State.PreFunding;
627     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
628     else if (isMinimumGoalReached()) return State.Success;
629     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
630     else return State.Failure;
631   }
632 
633   /** This is for manual testing of multisig wallet interaction */
634   function setOwnerTestValue(uint val) onlyOwner {
635     ownerTestValue = val;
636   }
637 
638   /**
639    * Allow addresses to do early participation.
640    *
641    * TODO: Fix spelling error in the name
642    */
643   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
644     earlyParticipantWhitelist[addr] = status;
645     Whitelisted(addr, status);
646   }
647 
648 
649   /** Interface marker. */
650   function isCrowdsale() public constant returns (bool) {
651     return true;
652   }
653 
654   //
655   // Modifiers
656   //
657 
658   /** Modified allowing execution only if the crowdsale is currently running.  */
659   modifier inState(State state) {
660     if(getState() != state) throw;
661     _;
662   }
663 
664 
665   //
666   // Abstract functions
667   //
668 
669   /**
670    * Check if the current invested breaks our cap rules.
671    *
672    *
673    * The child contract must define their own cap setting rules.
674    * We allow a lot of flexibility through different capping strategies (ETH, token count)
675    * Called from invest().
676    *
677    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
678    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
679    * @param weiRaisedTotal What would be our total raised balance after this transaction
680    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
681    *
682    * @return true if taking this investment would break our cap rules
683    */
684   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
685 
686   /**
687    * Check if the current crowdsale is full and we can no longer sell any tokens.
688    */
689   function isCrowdsaleFull() public constant returns (bool);
690 
691   /**
692    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
693    */
694   function assignTokens(address receiver, uint tokenAmount) internal;
695 }
696 
697 
698 /**
699  * A mixin that is selling tokens from a preallocated pool
700  *
701  * - Tokens have precreated supply "premined"
702  *
703  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
704  *
705  * - The mixin does not implement buy entry point.
706  *
707  */
708 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
709 
710   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
711   address public beneficiary;
712 
713   /**
714    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
715    *
716    */
717   function AllocatedCrowdsaleMixin(address _beneficiary) {
718     beneficiary = _beneficiary;
719   }
720 
721   /**
722    * Called from invest() to confirm if the curret investment does not break our cap rule.
723    */
724   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
725     if(tokenAmount > getTokensLeft()) {
726       return true;
727     } else {
728       return false;
729     }
730   }
731 
732   /**
733    * We are sold out when our approve pool becomes empty.
734    */
735   function isCrowdsaleFull() public constant returns (bool) {
736     return getTokensLeft() == 0;
737   }
738 
739   /**
740    * Get the amount of unsold tokens allocated to this contract;
741    */
742   function getTokensLeft() public constant returns (uint) {
743     return token.allowance(owner, this);
744   }
745 
746   /**
747    * Transfer tokens from approve() pool to the buyer.
748    *
749    * Use approve() given to this crowdsale to distribute the tokens.
750    */
751   function assignTokens(address receiver, uint tokenAmount) internal {
752     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
753   }
754 }
755 
756 /**
757  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
758  *
759  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
760  */
761 
762 
763 
764 
765 
766 
767 
768 
769 
770 /**
771  * Abstract base contract for token sales with the default buy entry points.
772  *
773  * Handle
774  * - start and end dates
775  * - accepting investments
776  * - minimum funding goal and refund
777  * - various statistics during the crowdfund
778  * - different pricing strategies
779  * - different investment policies (require server side customer id, allow only whitelisted addresses)
780  *
781  * Does not Handle
782  *
783  * - Token allocation (minting vs. transfer)
784  * - Cap rules
785  *
786  */
787 contract Crowdsale is CrowdsaleBase {
788 
789   /* Do we need to have unique contributor id for each customer */
790   bool public requireCustomerId;
791 
792   /**
793     * Do we verify that contributor has been cleared on the server side (accredited investors only).
794     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
795     */
796   bool public requiredSignedAddress;
797 
798   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
799   address public signerAddress;
800 
801   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
802   }
803 
804   /**
805    * Preallocate tokens for the early investors.
806    *
807    * Preallocated tokens have been sold before the actual crowdsale opens.
808    * This function mints the tokens and moves the crowdsale needle.
809    *
810    * Investor count is not handled; it is assumed this goes for multiple investors
811    * and the token distribution happens outside the smart contract flow.
812    *
813    * No money is exchanged, as the crowdsale team already have received the payment.
814    *
815    * @param fullTokens tokens as full tokens - decimal places added internally
816    * @param weiPrice Price of a single full token in wei
817    *
818    */
819   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
820 
821     uint tokenAmount = fullTokens * 10**token.decimals();
822     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
823 
824     weiRaised = weiRaised.plus(weiAmount);
825     tokensSold = tokensSold.plus(tokenAmount);
826 
827     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
828     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
829 
830     assignTokens(receiver, tokenAmount);
831 
832     // Tell us invest was success
833     Invested(receiver, weiAmount, tokenAmount, 0);
834   }
835 
836   /**
837    * Allow anonymous contributions to this crowdsale.
838    */
839   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
840      bytes32 hash = sha256(addr);
841      if (ecrecover(hash, v, r, s) != signerAddress) throw;
842      if(customerId == 0) throw;  // UUIDv4 sanity check
843      investInternal(addr, customerId);
844   }
845 
846   /**
847    * Track who is the customer making the payment so we can send thank you email.
848    */
849   function investWithCustomerId(address addr, uint128 customerId) public payable {
850     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
851     if(customerId == 0) throw;  // UUIDv4 sanity check
852     investInternal(addr, customerId);
853   }
854 
855   /**
856    * Allow anonymous contributions to this crowdsale.
857    */
858   function invest(address addr) public payable {
859     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
860     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
861     investInternal(addr, 0);
862   }
863 
864   /**
865    * Invest to tokens, recognize the payer and clear his address.
866    *
867    */
868   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
869     investWithSignedAddress(msg.sender, customerId, v, r, s);
870   }
871 
872   /**
873    * Invest to tokens, recognize the payer.
874    *
875    */
876   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
877     // see customerid.py
878     if (bytes1(sha3(customerId)) != checksum) throw;
879     investWithCustomerId(msg.sender, customerId);
880   }
881 
882   /**
883    * Legacy API signature.
884    */
885   function buyWithCustomerId(uint128 customerId) public payable {
886     investWithCustomerId(msg.sender, customerId);
887   }
888 
889   /**
890    * The basic entry point to participate the crowdsale process.
891    *
892    * Pay for funding, get invested tokens back in the sender address.
893    */
894   function buy() public payable {
895     invest(msg.sender);
896   }
897 
898   /**
899    * Set policy do we need to have server-side customer ids for the investments.
900    *
901    */
902   function setRequireCustomerId(bool value) onlyOwner {
903     requireCustomerId = value;
904     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
905   }
906 
907   /**
908    * Set policy if all investors must be cleared on the server side first.
909    *
910    * This is e.g. for the accredited investor clearing.
911    *
912    */
913   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
914     requiredSignedAddress = value;
915     signerAddress = _signerAddress;
916     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
917   }
918 
919 }
920 
921 
922 
923 /**
924  * An implementation of allocated crowdsale.
925  *
926  * This implementation does not have KYC logic (vs. KYCCrowdsale).
927  *
928  */
929 contract AllocatedCrowdsale is AllocatedCrowdsaleMixin, Crowdsale {
930 
931   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
932 
933   }
934 
935 }