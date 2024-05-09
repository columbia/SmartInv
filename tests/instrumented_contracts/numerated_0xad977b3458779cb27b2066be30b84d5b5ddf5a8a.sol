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
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 
74 /*
75  * Haltable
76  *
77  * Abstract contract that allows children to implement an
78  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
79  *
80  *
81  * Originally envisioned in FirstBlood ICO contract.
82  */
83 contract Haltable is Ownable {
84   bool public halted;
85 
86   modifier stopInEmergency {
87     if (halted) throw;
88     _;
89   }
90 
91   modifier stopNonOwnersInEmergency {
92     if (halted && msg.sender != owner) throw;
93     _;
94   }
95 
96   modifier onlyInEmergency {
97     if (!halted) throw;
98     _;
99   }
100 
101   // called by the owner on emergency, triggers stopped state
102   function halt() external onlyOwner {
103     halted = true;
104   }
105 
106   // called by the owner on end of emergency, returns to normal state
107   function unhalt() external onlyOwner onlyInEmergency {
108     halted = false;
109   }
110 
111 }
112 
113 
114 /**
115  * Safe unsigned safe math.
116  *
117  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
118  *
119  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
120  *
121  * Maintained here until merged to mainline zeppelin-solidity.
122  *
123  */
124 library SafeMathLib {
125 
126   function times(uint a, uint b) returns (uint) {
127     uint c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131 
132   function minus(uint a, uint b) returns (uint) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   function plus(uint a, uint b) returns (uint) {
138     uint c = a + b;
139     assert(c>=a);
140     return c;
141   }
142 
143 }
144 
145 /**
146  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
147  *
148  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
149  */
150 
151 
152 
153 
154 
155 
156 /**
157  * @title ERC20Basic
158  * @dev Simpler version of ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/179
160  */
161 contract ERC20Basic {
162   uint256 public totalSupply;
163   function balanceOf(address who) public view returns (uint256);
164   function transfer(address to, uint256 value) public returns (bool);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 }
167 
168 
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) public view returns (uint256);
176   function transferFrom(address from, address to, uint256 value) public returns (bool);
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 /**
183  * A token that defines fractional units as decimals.
184  */
185 contract FractionalERC20 is ERC20 {
186 
187   uint public decimals;
188 
189 }
190 
191 /**
192  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
193  *
194  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
195  */
196 
197 
198 /**
199  * Interface for defining crowdsale pricing.
200  */
201 contract PricingStrategy {
202 
203   /** Interface declaration. */
204   function isPricingStrategy() public constant returns (bool) {
205     return true;
206   }
207 
208   /** Self check if all references are correctly set.
209    *
210    * Checks that pricing strategy matches crowdsale parameters.
211    */
212   function isSane(address crowdsale) public constant returns (bool) {
213     return true;
214   }
215 
216   /**
217    * @dev Pricing tells if this is a presale purchase or not.
218      @param purchaser Address of the purchaser
219      @return False by default, true if a presale purchaser
220    */
221   function isPresalePurchase(address purchaser) public constant returns (bool) {
222     return false;
223   }
224 
225   /**
226    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
227    *
228    *
229    * @param value - What is the value of the transaction send in as wei
230    * @param tokensSold - how much tokens have been sold this far
231    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
232    * @param msgSender - who is the investor of this transaction
233    * @param decimals - how many decimal units the token has
234    * @return Amount of tokens the investor receives
235    */
236   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
237 }
238 
239 /**
240  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
241  *
242  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
243  */
244 
245 
246 /**
247  * Finalize agent defines what happens at the end of succeseful crowdsale.
248  *
249  * - Allocate tokens for founders, bounties and community
250  * - Make tokens transferable
251  * - etc.
252  */
253 contract FinalizeAgent {
254 
255   function isFinalizeAgent() public constant returns(bool) {
256     return true;
257   }
258 
259   /** Return true if we can run finalizeCrowdsale() properly.
260    *
261    * This is a safety check function that doesn't allow crowdsale to begin
262    * unless the finalizer has been set up properly.
263    */
264   function isSane() public constant returns (bool);
265 
266   /** Called once by crowdsale finalize() if the sale was success. */
267   function finalizeCrowdsale();
268 
269 }
270 
271 
272 
273 /**
274  * Crowdsale state machine without buy functionality.
275  *
276  * Implements basic state machine logic, but leaves out all buy functions,
277  * so that subclasses can implement their own buying logic.
278  *
279  *
280  * For the default buy() implementation see Crowdsale.sol.
281  */
282 contract CrowdsaleBase is Haltable {
283 
284   /* Max investment count when we are still allowed to change the multisig address */
285   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
286 
287   using SafeMathLib for uint;
288 
289   /* The token we are selling */
290   FractionalERC20 public token;
291 
292   /* How we are going to price our offering */
293   PricingStrategy public pricingStrategy;
294 
295   /* Post-success callback */
296   FinalizeAgent public finalizeAgent;
297 
298   /* tokens will be transfered from this address */
299   address public multisigWallet;
300 
301   /* if the funding goal is not reached, investors may withdraw their funds */
302   uint public minimumFundingGoal;
303 
304   /* the UNIX timestamp start date of the crowdsale */
305   uint public startsAt;
306 
307   /* the UNIX timestamp end date of the crowdsale */
308   uint public endsAt;
309 
310   /* the number of tokens already sold through this contract*/
311   uint public tokensSold = 0;
312 
313   /* How many wei of funding we have raised */
314   uint public weiRaised = 0;
315 
316   /* Calculate incoming funds from presale contracts and addresses */
317   uint public presaleWeiRaised = 0;
318 
319   /* How many distinct addresses have invested */
320   uint public investorCount = 0;
321 
322   /* How much wei we have returned back to the contract after a failed crowdfund. */
323   uint public loadedRefund = 0;
324 
325   /* How much wei we have given back to investors.*/
326   uint public weiRefunded = 0;
327 
328   /* Has this crowdsale been finalized */
329   bool public finalized;
330 
331   /** How much ETH each address has invested to this crowdsale */
332   mapping (address => uint256) public investedAmountOf;
333 
334   /** How much tokens this crowdsale has credited for each investor address */
335   mapping (address => uint256) public tokenAmountOf;
336 
337   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
338   mapping (address => bool) public earlyParticipantWhitelist;
339 
340   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
341   uint public ownerTestValue;
342 
343   /** State machine
344    *
345    * - Preparing: All contract initialization calls and variables have not been set yet
346    * - Prefunding: We have not passed start time yet
347    * - Funding: Active crowdsale
348    * - Success: Minimum funding goal reached
349    * - Failure: Minimum funding goal not reached before ending time
350    * - Finalized: The finalized has been called and succesfully executed
351    * - Refunding: Refunds are loaded on the contract for reclaim.
352    */
353   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
354 
355   // A new investment was made
356   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
357 
358   // Refund was processed for a contributor
359   event Refund(address investor, uint weiAmount);
360 
361   // The rules were changed what kind of investments we accept
362   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
363 
364   // Address early participation whitelist status changed
365   event Whitelisted(address addr, bool status);
366 
367   // Crowdsale end time has been changed
368   event EndsAtChanged(uint newEndsAt);
369 
370   State public testState;
371 
372   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
373 
374     owner = msg.sender;
375 
376     token = FractionalERC20(_token);
377 
378     setPricingStrategy(_pricingStrategy);
379 
380     multisigWallet = _multisigWallet;
381     if(multisigWallet == 0) {
382         throw;
383     }
384 
385     if(_start == 0) {
386         throw;
387     }
388 
389     startsAt = _start;
390 
391     if(_end == 0) {
392         throw;
393     }
394 
395     endsAt = _end;
396 
397     // Don't mess the dates
398     if(startsAt >= endsAt) {
399         throw;
400     }
401 
402     // Minimum funding goal can be zero
403     minimumFundingGoal = _minimumFundingGoal;
404   }
405 
406   /**
407    * Don't expect to just send in money and get tokens.
408    */
409   function() payable {
410     throw;
411   }
412 
413   /**
414    * Make an investment.
415    *
416    * Crowdsale must be running for one to invest.
417    * We must have not pressed the emergency brake.
418    *
419    * @param receiver The Ethereum address who receives the tokens
420    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
421    *
422    * @return tokenAmount How mony tokens were bought
423    */
424   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
425 
426     // Determine if it's a good time to accept investment from this participant
427     if(getState() == State.PreFunding) {
428       // Are we whitelisted for early deposit
429       if(!earlyParticipantWhitelist[receiver]) {
430         throw;
431       }
432     } else if(getState() == State.Funding) {
433       // Retail participants can only come in when the crowdsale is running
434       // pass
435     } else {
436       // Unwanted state
437       throw;
438     }
439 
440     uint weiAmount = msg.value;
441 
442     // Account presale sales separately, so that they do not count against pricing tranches
443     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
444 
445     // Dust transaction
446     require(tokenAmount != 0);
447 
448     if(investedAmountOf[receiver] == 0) {
449        // A new investor
450        investorCount++;
451     }
452 
453     // Update investor
454     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
455     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
456 
457     // Update totals
458     weiRaised = weiRaised.plus(weiAmount);
459     tokensSold = tokensSold.plus(tokenAmount);
460 
461     if(pricingStrategy.isPresalePurchase(receiver)) {
462         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
463     }
464 
465     // Check that we did not bust the cap
466     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
467 
468     assignTokens(receiver, tokenAmount);
469 
470     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
471     if(!multisigWallet.send(weiAmount)) throw;
472 
473     // Tell us invest was success
474     Invested(receiver, weiAmount, tokenAmount, customerId);
475 
476     return tokenAmount;
477   }
478 
479   /**
480    * Finalize a succcesful crowdsale.
481    *
482    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
483    */
484   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
485 
486     // Already finalized
487     if(finalized) {
488       throw;
489     }
490 
491     // Finalizing is optional. We only call it if we are given a finalizing agent.
492     if(address(finalizeAgent) != 0) {
493       finalizeAgent.finalizeCrowdsale();
494     }
495 
496     finalized = true;
497   }
498 
499   /**
500    * Allow to (re)set finalize agent.
501    *
502    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
503    */
504   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
505     finalizeAgent = addr;
506 
507     // Don't allow setting bad agent
508     if(!finalizeAgent.isFinalizeAgent()) {
509       throw;
510     }
511   }
512 
513   /**
514    * Allow crowdsale owner to close early or extend the crowdsale.
515    *
516    * This is useful e.g. for a manual soft cap implementation:
517    * - after X amount is reached determine manual closing
518    *
519    * This may put the crowdsale to an invalid state,
520    * but we trust owners know what they are doing.
521    *
522    */
523   function setEndsAt(uint time) onlyOwner {
524 
525     if(now > time) {
526       throw; // Don't change past
527     }
528 
529     if(startsAt > time) {
530       throw; // Prevent human mistakes
531     }
532 
533     endsAt = time;
534     EndsAtChanged(endsAt);
535   }
536 
537   /**
538    * Allow to (re)set pricing strategy.
539    *
540    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
541    */
542   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
543     pricingStrategy = _pricingStrategy;
544 
545     // Don't allow setting bad agent
546     if(!pricingStrategy.isPricingStrategy()) {
547       throw;
548     }
549   }
550 
551   /**
552    * Allow to change the team multisig address in the case of emergency.
553    *
554    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
555    * (we have done only few test transactions). After the crowdsale is going
556    * then multisig address stays locked for the safety reasons.
557    */
558   function setMultisig(address addr) public onlyOwner {
559 
560     // Change
561     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
562       throw;
563     }
564 
565     multisigWallet = addr;
566   }
567 
568   /**
569    * Allow load refunds back on the contract for the refunding.
570    *
571    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
572    */
573   function loadRefund() public payable inState(State.Failure) {
574     if(msg.value == 0) throw;
575     loadedRefund = loadedRefund.plus(msg.value);
576   }
577 
578   /**
579    * Investors can claim refund.
580    *
581    * Note that any refunds from proxy buyers should be handled separately,
582    * and not through this contract.
583    */
584   function refund() public inState(State.Refunding) {
585     uint256 weiValue = investedAmountOf[msg.sender];
586     if (weiValue == 0) throw;
587     investedAmountOf[msg.sender] = 0;
588     weiRefunded = weiRefunded.plus(weiValue);
589     Refund(msg.sender, weiValue);
590     if (!msg.sender.send(weiValue)) throw;
591   }
592 
593   /**
594    * @return true if the crowdsale has raised enough money to be a successful.
595    */
596   function isMinimumGoalReached() public constant returns (bool reached) {
597     return weiRaised >= minimumFundingGoal;
598   }
599 
600   /**
601    * Check if the contract relationship looks good.
602    */
603   function isFinalizerSane() public constant returns (bool sane) {
604     return finalizeAgent.isSane();
605   }
606 
607   /**
608    * Check if the contract relationship looks good.
609    */
610   function isPricingSane() public constant returns (bool sane) {
611     return pricingStrategy.isSane(address(this));
612   }
613 
614   /**
615    * Crowdfund state machine management.
616    *
617    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
618    */
619   function getState() public constant returns (State) {
620     if(finalized) return State.Finalized;
621     else if (address(finalizeAgent) == 0) return State.Preparing;
622     else if (!finalizeAgent.isSane()) return State.Preparing;
623     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
624     else if (block.timestamp < startsAt) return State.PreFunding;
625     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
626     else if (isMinimumGoalReached()) return State.Success;
627     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
628     else return State.Failure;
629   }
630 
631   /** This is for manual testing of multisig wallet interaction */
632   function setOwnerTestValue(uint val) onlyOwner {
633     ownerTestValue = val;
634   }
635 
636   /**
637    * Allow addresses to do early participation.
638    *
639    * TODO: Fix spelling error in the name
640    */
641   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
642     earlyParticipantWhitelist[addr] = status;
643     Whitelisted(addr, status);
644   }
645 
646 
647   /** Interface marker. */
648   function isCrowdsale() public constant returns (bool) {
649     return true;
650   }
651 
652   //
653   // Modifiers
654   //
655 
656   /** Modified allowing execution only if the crowdsale is currently running.  */
657   modifier inState(State state) {
658     if(getState() != state) throw;
659     _;
660   }
661 
662 
663   //
664   // Abstract functions
665   //
666 
667   /**
668    * Check if the current invested breaks our cap rules.
669    *
670    *
671    * The child contract must define their own cap setting rules.
672    * We allow a lot of flexibility through different capping strategies (ETH, token count)
673    * Called from invest().
674    *
675    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
676    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
677    * @param weiRaisedTotal What would be our total raised balance after this transaction
678    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
679    *
680    * @return true if taking this investment would break our cap rules
681    */
682   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
683 
684   /**
685    * Check if the current crowdsale is full and we can no longer sell any tokens.
686    */
687   function isCrowdsaleFull() public constant returns (bool);
688 
689   /**
690    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
691    */
692   function assignTokens(address receiver, uint tokenAmount) internal;
693 }
694 
695 
696 /**
697  * A mixin that is selling tokens from a preallocated pool
698  *
699  * - Tokens have precreated supply "premined"
700  *
701  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
702  *
703  * - The mixin does not implement buy entry point.
704  *
705  */
706 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
707 
708   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
709   address public beneficiary;
710 
711   /**
712    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
713    *
714    */
715   function AllocatedCrowdsaleMixin(address _beneficiary) {
716     beneficiary = _beneficiary;
717   }
718 
719   /**
720    * Called from invest() to confirm if the curret investment does not break our cap rule.
721    */
722   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
723     if(tokenAmount > getTokensLeft()) {
724       return true;
725     } else {
726       return false;
727     }
728   }
729 
730   /**
731    * We are sold out when our approve pool becomes empty.
732    */
733   function isCrowdsaleFull() public constant returns (bool) {
734     return getTokensLeft() == 0;
735   }
736 
737   /**
738    * Get the amount of unsold tokens allocated to this contract;
739    */
740   function getTokensLeft() public constant returns (uint) {
741     return token.allowance(owner, this);
742   }
743 
744   /**
745    * Transfer tokens from approve() pool to the buyer.
746    *
747    * Use approve() given to this crowdsale to distribute the tokens.
748    */
749   function assignTokens(address receiver, uint tokenAmount) internal {
750     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
751   }
752 }
753 
754 /**
755  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
756  *
757  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
758  */
759 
760 
761 
762 
763 
764 
765 
766 
767 
768 /**
769  * Abstract base contract for token sales with the default buy entry points.
770  *
771  * Handle
772  * - start and end dates
773  * - accepting investments
774  * - minimum funding goal and refund
775  * - various statistics during the crowdfund
776  * - different pricing strategies
777  * - different investment policies (require server side customer id, allow only whitelisted addresses)
778  *
779  * Does not Handle
780  *
781  * - Token allocation (minting vs. transfer)
782  * - Cap rules
783  *
784  */
785 contract Crowdsale is CrowdsaleBase {
786 
787   /* Do we need to have unique contributor id for each customer */
788   bool public requireCustomerId;
789 
790   /**
791     * Do we verify that contributor has been cleared on the server side (accredited investors only).
792     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
793     */
794   bool public requiredSignedAddress;
795 
796   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
797   address public signerAddress;
798 
799   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
800   }
801 
802   /**
803    * Preallocate tokens for the early investors.
804    *
805    * Preallocated tokens have been sold before the actual crowdsale opens.
806    * This function mints the tokens and moves the crowdsale needle.
807    *
808    * Investor count is not handled; it is assumed this goes for multiple investors
809    * and the token distribution happens outside the smart contract flow.
810    *
811    * No money is exchanged, as the crowdsale team already have received the payment.
812    *
813    * @param fullTokens tokens as full tokens - decimal places added internally
814    * @param weiPrice Price of a single full token in wei
815    *
816    */
817   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
818 
819     uint tokenAmount = fullTokens * 10**token.decimals();
820     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
821 
822     weiRaised = weiRaised.plus(weiAmount);
823     tokensSold = tokensSold.plus(tokenAmount);
824 
825     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
826     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
827 
828     assignTokens(receiver, tokenAmount);
829 
830     // Tell us invest was success
831     Invested(receiver, weiAmount, tokenAmount, 0);
832   }
833 
834   /**
835    * Allow anonymous contributions to this crowdsale.
836    */
837   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
838      bytes32 hash = sha256(addr);
839      if (ecrecover(hash, v, r, s) != signerAddress) throw;
840      if(customerId == 0) throw;  // UUIDv4 sanity check
841      investInternal(addr, customerId);
842   }
843 
844   /**
845    * Track who is the customer making the payment so we can send thank you email.
846    */
847   function investWithCustomerId(address addr, uint128 customerId) public payable {
848     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
849     if(customerId == 0) throw;  // UUIDv4 sanity check
850     investInternal(addr, customerId);
851   }
852 
853   /**
854    * Allow anonymous contributions to this crowdsale.
855    */
856   function invest(address addr) public payable {
857     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
858     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
859     investInternal(addr, 0);
860   }
861 
862   /**
863    * Invest to tokens, recognize the payer and clear his address.
864    *
865    */
866   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
867     investWithSignedAddress(msg.sender, customerId, v, r, s);
868   }
869 
870   /**
871    * Invest to tokens, recognize the payer.
872    *
873    */
874   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
875     // see customerid.py
876     if (bytes1(sha3(customerId)) != checksum) throw;
877     investWithCustomerId(msg.sender, customerId);
878   }
879 
880   /**
881    * Legacy API signature.
882    */
883   function buyWithCustomerId(uint128 customerId) public payable {
884     investWithCustomerId(msg.sender, customerId);
885   }
886 
887   /**
888    * The basic entry point to participate the crowdsale process.
889    *
890    * Pay for funding, get invested tokens back in the sender address.
891    */
892   function buy() public payable {
893     invest(msg.sender);
894   }
895 
896   /**
897    * Set policy do we need to have server-side customer ids for the investments.
898    *
899    */
900   function setRequireCustomerId(bool value) onlyOwner {
901     requireCustomerId = value;
902     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
903   }
904 
905   /**
906    * Set policy if all investors must be cleared on the server side first.
907    *
908    * This is e.g. for the accredited investor clearing.
909    *
910    */
911   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
912     requiredSignedAddress = value;
913     signerAddress = _signerAddress;
914     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
915   }
916 
917 }
918 
919 
920 
921 /**
922  * An implementation of allocated crowdsale.
923  *
924  * This implementation does not have KYC logic (vs. KYCCrowdsale).
925  *
926  */
927 contract AllocatedCrowdsale is AllocatedCrowdsaleMixin, Crowdsale {
928 
929   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
930 
931   }
932 
933 }