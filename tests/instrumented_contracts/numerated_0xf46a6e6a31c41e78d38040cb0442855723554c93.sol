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
47   function Ownable() {
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
65   function transferOwnership(address newOwner) onlyOwner public {
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
113 /**
114  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
115  *
116  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
117  */
118 
119 
120 /**
121  * Safe unsigned safe math.
122  *
123  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
124  *
125  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
126  *
127  * Maintained here until merged to mainline zeppelin-solidity.
128  *
129  */
130 library SafeMathLib {
131 
132   function times(uint a, uint b) returns (uint) {
133     uint c = a * b;
134     assert(a == 0 || c / a == b);
135     return c;
136   }
137 
138   function minus(uint a, uint b) returns (uint) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   function plus(uint a, uint b) returns (uint) {
144     uint c = a + b;
145     assert(c>=a);
146     return c;
147   }
148 
149 }
150 
151 /**
152  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
153  *
154  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
155  */
156 
157 
158 
159 
160 
161 
162 /**
163  * @title ERC20Basic
164  * @dev Simpler version of ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/179
166  */
167 contract ERC20Basic {
168   uint256 public totalSupply;
169   function balanceOf(address who) public constant returns (uint256);
170   function transfer(address to, uint256 value) public returns (bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender) public constant returns (uint256);
182   function transferFrom(address from, address to, uint256 value) public returns (bool);
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 
188 /**
189  * A token that defines fractional units as decimals.
190  */
191 contract FractionalERC20 is ERC20 {
192 
193   uint public decimals;
194 
195 }
196 
197 /**
198  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
199  *
200  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
201  */
202 
203 
204 /**
205  * Interface for defining crowdsale pricing.
206  */
207 contract PricingStrategy {
208 
209   /** Interface declaration. */
210   function isPricingStrategy() public constant returns (bool) {
211     return true;
212   }
213 
214   /** Self check if all references are correctly set.
215    *
216    * Checks that pricing strategy matches crowdsale parameters.
217    */
218   function isSane(address crowdsale) public constant returns (bool) {
219     return true;
220   }
221 
222   /**
223    * @dev Pricing tells if this is a presale purchase or not.
224      @param purchaser Address of the purchaser
225      @return False by default, true if a presale purchaser
226    */
227   function isPresalePurchase(address purchaser) public constant returns (bool) {
228     return false;
229   }
230 
231   /**
232    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
233    *
234    *
235    * @param value - What is the value of the transaction send in as wei
236    * @param tokensSold - how much tokens have been sold this far
237    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
238    * @param msgSender - who is the investor of this transaction
239    * @param decimals - how many decimal units the token has
240    * @return Amount of tokens the investor receives
241    */
242   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
243 }
244 
245 /**
246  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
247  *
248  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
249  */
250 
251 
252 /**
253  * Finalize agent defines what happens at the end of succeseful crowdsale.
254  *
255  * - Allocate tokens for founders, bounties and community
256  * - Make tokens transferable
257  * - etc.
258  */
259 contract FinalizeAgent {
260 
261   function isFinalizeAgent() public constant returns(bool) {
262     return true;
263   }
264 
265   /** Return true if we can run finalizeCrowdsale() properly.
266    *
267    * This is a safety check function that doesn't allow crowdsale to begin
268    * unless the finalizer has been set up properly.
269    */
270   function isSane() public constant returns (bool);
271 
272   /** Called once by crowdsale finalize() if the sale was success. */
273   function finalizeCrowdsale();
274 
275 }
276 
277 
278 
279 /**
280  * Crowdsale state machine without buy functionality.
281  *
282  * Implements basic state machine logic, but leaves out all buy functions,
283  * so that subclasses can implement their own buying logic.
284  *
285  *
286  * For the default buy() implementation see Crowdsale.sol.
287  */
288 contract CrowdsaleBase is Haltable {
289 
290   /* Max investment count when we are still allowed to change the multisig address */
291   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
292 
293   using SafeMathLib for uint;
294 
295   /* The token we are selling */
296   FractionalERC20 public token;
297 
298   /* How we are going to price our offering */
299   PricingStrategy public pricingStrategy;
300 
301   /* Post-success callback */
302   FinalizeAgent public finalizeAgent;
303 
304   /* tokens will be transfered from this address */
305   address public multisigWallet;
306 
307   /* if the funding goal is not reached, investors may withdraw their funds */
308   uint public minimumFundingGoal;
309 
310   /* the UNIX timestamp start date of the crowdsale */
311   uint public startsAt;
312 
313   /* the UNIX timestamp end date of the crowdsale */
314   uint public endsAt;
315 
316   /* the number of tokens already sold through this contract*/
317   uint public tokensSold = 0;
318 
319   /* How many wei of funding we have raised */
320   uint public weiRaised = 0;
321 
322   /* Calculate incoming funds from presale contracts and addresses */
323   uint public presaleWeiRaised = 0;
324 
325   /* How many distinct addresses have invested */
326   uint public investorCount = 0;
327 
328   /* How much wei we have returned back to the contract after a failed crowdfund. */
329   uint public loadedRefund = 0;
330 
331   /* How much wei we have given back to investors.*/
332   uint public weiRefunded = 0;
333 
334   /* Has this crowdsale been finalized */
335   bool public finalized;
336 
337   /** How much ETH each address has invested to this crowdsale */
338   mapping (address => uint256) public investedAmountOf;
339 
340   /** How much tokens this crowdsale has credited for each investor address */
341   mapping (address => uint256) public tokenAmountOf;
342 
343   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
344   mapping (address => bool) public earlyParticipantWhitelist;
345 
346   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
347   uint public ownerTestValue;
348 
349   /** State machine
350    *
351    * - Preparing: All contract initialization calls and variables have not been set yet
352    * - Prefunding: We have not passed start time yet
353    * - Funding: Active crowdsale
354    * - Success: Minimum funding goal reached
355    * - Failure: Minimum funding goal not reached before ending time
356    * - Finalized: The finalized has been called and succesfully executed
357    * - Refunding: Refunds are loaded on the contract for reclaim.
358    */
359   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
360 
361   // A new investment was made
362   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
363 
364   // Refund was processed for a contributor
365   event Refund(address investor, uint weiAmount);
366 
367   // The rules were changed what kind of investments we accept
368   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
369 
370   // Address early participation whitelist status changed
371   event Whitelisted(address addr, bool status);
372 
373   // Crowdsale end time has been changed
374   event EndsAtChanged(uint newEndsAt);
375 
376   State public testState;
377 
378   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
379 
380     owner = msg.sender;
381 
382     token = FractionalERC20(_token);
383 
384     setPricingStrategy(_pricingStrategy);
385 
386     multisigWallet = _multisigWallet;
387     if(multisigWallet == 0) {
388         throw;
389     }
390 
391     if(_start == 0) {
392         throw;
393     }
394 
395     startsAt = _start;
396 
397     if(_end == 0) {
398         throw;
399     }
400 
401     endsAt = _end;
402 
403     // Don't mess the dates
404     if(startsAt >= endsAt) {
405         throw;
406     }
407 
408     // Minimum funding goal can be zero
409     minimumFundingGoal = _minimumFundingGoal;
410   }
411 
412   /**
413    * Don't expect to just send in money and get tokens.
414    */
415   function() payable {
416     throw;
417   }
418 
419   /**
420    * Make an investment.
421    *
422    * Crowdsale must be running for one to invest.
423    * We must have not pressed the emergency brake.
424    *
425    * @param receiver The Ethereum address who receives the tokens
426    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
427    *
428    * @return tokenAmount How mony tokens were bought
429    */
430   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
431 
432     // Determine if it's a good time to accept investment from this participant
433     if(getState() == State.PreFunding) {
434       // Are we whitelisted for early deposit
435       if(!earlyParticipantWhitelist[receiver]) {
436         throw;
437       }
438     } else if(getState() == State.Funding) {
439       // Retail participants can only come in when the crowdsale is running
440       // pass
441     } else {
442       // Unwanted state
443       throw;
444     }
445 
446     uint weiAmount = msg.value;
447 
448     // Account presale sales separately, so that they do not count against pricing tranches
449     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
450 
451     // Dust transaction
452     require(tokenAmount != 0);
453 
454     if(investedAmountOf[receiver] == 0) {
455        // A new investor
456        investorCount++;
457     }
458 
459     // Update investor
460     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
461     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
462 
463     // Update totals
464     weiRaised = weiRaised.plus(weiAmount);
465     tokensSold = tokensSold.plus(tokenAmount);
466 
467     if(pricingStrategy.isPresalePurchase(receiver)) {
468         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
469     }
470 
471     // Check that we did not bust the cap
472     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
473 
474     assignTokens(receiver, tokenAmount);
475 
476     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
477     if(!multisigWallet.send(weiAmount)) throw;
478 
479     // Tell us invest was success
480     Invested(receiver, weiAmount, tokenAmount, customerId);
481 
482     return tokenAmount;
483   }
484 
485   /**
486    * Finalize a succcesful crowdsale.
487    *
488    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
489    */
490   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
491 
492     // Already finalized
493     if(finalized) {
494       throw;
495     }
496 
497     // Finalizing is optional. We only call it if we are given a finalizing agent.
498     if(address(finalizeAgent) != 0) {
499       finalizeAgent.finalizeCrowdsale();
500     }
501 
502     finalized = true;
503   }
504 
505   /**
506    * Allow to (re)set finalize agent.
507    *
508    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
509    */
510   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
511     finalizeAgent = addr;
512 
513     // Don't allow setting bad agent
514     if(!finalizeAgent.isFinalizeAgent()) {
515       throw;
516     }
517   }
518 
519   /**
520    * Allow crowdsale owner to close early or extend the crowdsale.
521    *
522    * This is useful e.g. for a manual soft cap implementation:
523    * - after X amount is reached determine manual closing
524    *
525    * This may put the crowdsale to an invalid state,
526    * but we trust owners know what they are doing.
527    *
528    */
529   function setEndsAt(uint time) onlyOwner {
530 
531     if(now > time) {
532       throw; // Don't change past
533     }
534 
535     if(startsAt > time) {
536       throw; // Prevent human mistakes
537     }
538 
539     endsAt = time;
540     EndsAtChanged(endsAt);
541   }
542 
543   /**
544    * Allow to (re)set pricing strategy.
545    *
546    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
547    */
548   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
549     pricingStrategy = _pricingStrategy;
550 
551     // Don't allow setting bad agent
552     if(!pricingStrategy.isPricingStrategy()) {
553       throw;
554     }
555   }
556 
557   /**
558    * Allow to change the team multisig address in the case of emergency.
559    *
560    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
561    * (we have done only few test transactions). After the crowdsale is going
562    * then multisig address stays locked for the safety reasons.
563    */
564   function setMultisig(address addr) public onlyOwner {
565 
566     // Change
567     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
568       throw;
569     }
570 
571     multisigWallet = addr;
572   }
573 
574   /**
575    * Allow load refunds back on the contract for the refunding.
576    *
577    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
578    */
579   function loadRefund() public payable inState(State.Failure) {
580     if(msg.value == 0) throw;
581     loadedRefund = loadedRefund.plus(msg.value);
582   }
583 
584   /**
585    * Investors can claim refund.
586    *
587    * Note that any refunds from proxy buyers should be handled separately,
588    * and not through this contract.
589    */
590   function refund() public inState(State.Refunding) {
591     uint256 weiValue = investedAmountOf[msg.sender];
592     if (weiValue == 0) throw;
593     investedAmountOf[msg.sender] = 0;
594     weiRefunded = weiRefunded.plus(weiValue);
595     Refund(msg.sender, weiValue);
596     if (!msg.sender.send(weiValue)) throw;
597   }
598 
599   /**
600    * @return true if the crowdsale has raised enough money to be a successful.
601    */
602   function isMinimumGoalReached() public constant returns (bool reached) {
603     return weiRaised >= minimumFundingGoal;
604   }
605 
606   /**
607    * Check if the contract relationship looks good.
608    */
609   function isFinalizerSane() public constant returns (bool sane) {
610     return finalizeAgent.isSane();
611   }
612 
613   /**
614    * Check if the contract relationship looks good.
615    */
616   function isPricingSane() public constant returns (bool sane) {
617     return pricingStrategy.isSane(address(this));
618   }
619 
620   /**
621    * Crowdfund state machine management.
622    *
623    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
624    */
625   function getState() public constant returns (State) {
626     if(finalized) return State.Finalized;
627     else if (address(finalizeAgent) == 0) return State.Preparing;
628     else if (!finalizeAgent.isSane()) return State.Preparing;
629     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
630     else if (block.timestamp < startsAt) return State.PreFunding;
631     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
632     else if (isMinimumGoalReached()) return State.Success;
633     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
634     else return State.Failure;
635   }
636 
637   /** This is for manual testing of multisig wallet interaction */
638   function setOwnerTestValue(uint val) onlyOwner {
639     ownerTestValue = val;
640   }
641 
642   /**
643    * Allow addresses to do early participation.
644    *
645    * TODO: Fix spelling error in the name
646    */
647   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
648     earlyParticipantWhitelist[addr] = status;
649     Whitelisted(addr, status);
650   }
651 
652 
653   /** Interface marker. */
654   function isCrowdsale() public constant returns (bool) {
655     return true;
656   }
657 
658   //
659   // Modifiers
660   //
661 
662   /** Modified allowing execution only if the crowdsale is currently running.  */
663   modifier inState(State state) {
664     if(getState() != state) throw;
665     _;
666   }
667 
668 
669   //
670   // Abstract functions
671   //
672 
673   /**
674    * Check if the current invested breaks our cap rules.
675    *
676    *
677    * The child contract must define their own cap setting rules.
678    * We allow a lot of flexibility through different capping strategies (ETH, token count)
679    * Called from invest().
680    *
681    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
682    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
683    * @param weiRaisedTotal What would be our total raised balance after this transaction
684    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
685    *
686    * @return true if taking this investment would break our cap rules
687    */
688   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
689 
690   /**
691    * Check if the current crowdsale is full and we can no longer sell any tokens.
692    */
693   function isCrowdsaleFull() public constant returns (bool);
694 
695   /**
696    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
697    */
698   function assignTokens(address receiver, uint tokenAmount) internal;
699 }
700 
701 
702 /**
703  * A mixin that is selling tokens from a preallocated pool
704  *
705  * - Tokens have precreated supply "premined"
706  *
707  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
708  *
709  * - The mixin does not implement buy entry point.
710  *
711  */
712 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
713 
714   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
715   address public beneficiary;
716 
717   /**
718    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
719    *
720    */
721   function AllocatedCrowdsaleMixin(address _beneficiary) {
722     beneficiary = _beneficiary;
723   }
724 
725   /**
726    * Called from invest() to confirm if the curret investment does not break our cap rule.
727    */
728   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
729     if(tokenAmount > getTokensLeft()) {
730       return true;
731     } else {
732       return false;
733     }
734   }
735 
736   /**
737    * We are sold out when our approve pool becomes empty.
738    */
739   function isCrowdsaleFull() public constant returns (bool) {
740     return getTokensLeft() == 0;
741   }
742 
743   /**
744    * Get the amount of unsold tokens allocated to this contract;
745    */
746   function getTokensLeft() public constant returns (uint) {
747     return token.allowance(owner, this);
748   }
749 
750   /**
751    * Transfer tokens from approve() pool to the buyer.
752    *
753    * Use approve() given to this crowdsale to distribute the tokens.
754    */
755   function assignTokens(address receiver, uint tokenAmount) internal {
756     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
757   }
758 }
759 
760 /**
761  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
762  *
763  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
764  */
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 /**
775  * Abstract base contract for token sales with the default buy entry points.
776  *
777  * Handle
778  * - start and end dates
779  * - accepting investments
780  * - minimum funding goal and refund
781  * - various statistics during the crowdfund
782  * - different pricing strategies
783  * - different investment policies (require server side customer id, allow only whitelisted addresses)
784  *
785  * Does not Handle
786  *
787  * - Token allocation (minting vs. transfer)
788  * - Cap rules
789  *
790  */
791 contract Crowdsale is CrowdsaleBase {
792 
793   /* Do we need to have unique contributor id for each customer */
794   bool public requireCustomerId;
795 
796   /**
797     * Do we verify that contributor has been cleared on the server side (accredited investors only).
798     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
799     */
800   bool public requiredSignedAddress;
801 
802   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
803   address public signerAddress;
804 
805   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
806   }
807 
808   /**
809    * Preallocate tokens for the early investors.
810    *
811    * Preallocated tokens have been sold before the actual crowdsale opens.
812    * This function mints the tokens and moves the crowdsale needle.
813    *
814    * Investor count is not handled; it is assumed this goes for multiple investors
815    * and the token distribution happens outside the smart contract flow.
816    *
817    * No money is exchanged, as the crowdsale team already have received the payment.
818    *
819    * @param fullTokens tokens as full tokens - decimal places added internally
820    * @param weiPrice Price of a single full token in wei
821    *
822    */
823   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
824 
825     uint tokenAmount = fullTokens * 10**token.decimals();
826     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
827 
828     weiRaised = weiRaised.plus(weiAmount);
829     tokensSold = tokensSold.plus(tokenAmount);
830 
831     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
832     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
833 
834     assignTokens(receiver, tokenAmount);
835 
836     // Tell us invest was success
837     Invested(receiver, weiAmount, tokenAmount, 0);
838   }
839 
840   /**
841    * Allow anonymous contributions to this crowdsale.
842    */
843   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
844      bytes32 hash = sha256(addr);
845      if (ecrecover(hash, v, r, s) != signerAddress) throw;
846      if(customerId == 0) throw;  // UUIDv4 sanity check
847      investInternal(addr, customerId);
848   }
849 
850   /**
851    * Track who is the customer making the payment so we can send thank you email.
852    */
853   function investWithCustomerId(address addr, uint128 customerId) public payable {
854     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
855     if(customerId == 0) throw;  // UUIDv4 sanity check
856     investInternal(addr, customerId);
857   }
858 
859   /**
860    * Allow anonymous contributions to this crowdsale.
861    */
862   function invest(address addr) public payable {
863     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
864     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
865     investInternal(addr, 0);
866   }
867 
868   /**
869    * Invest to tokens, recognize the payer and clear his address.
870    *
871    */
872   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
873     investWithSignedAddress(msg.sender, customerId, v, r, s);
874   }
875 
876   /**
877    * Invest to tokens, recognize the payer.
878    *
879    */
880   function buyWithCustomerId(uint128 customerId) public payable {
881     investWithCustomerId(msg.sender, customerId);
882   }
883 
884   /**
885    * The basic entry point to participate the crowdsale process.
886    *
887    * Pay for funding, get invested tokens back in the sender address.
888    */
889   function buy() public payable {
890     invest(msg.sender);
891   }
892 
893   /**
894    * Set policy do we need to have server-side customer ids for the investments.
895    *
896    */
897   function setRequireCustomerId(bool value) onlyOwner {
898     requireCustomerId = value;
899     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
900   }
901 
902   /**
903    * Set policy if all investors must be cleared on the server side first.
904    *
905    * This is e.g. for the accredited investor clearing.
906    *
907    */
908   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
909     requiredSignedAddress = value;
910     signerAddress = _signerAddress;
911     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
912   }
913 
914 }
915 
916 
917 
918 /**
919  * An implementation of allocated crowdsale.
920  *
921  * This implementation does not have KYC logic (vs. KYCCrowdsale).
922  *
923  */
924 contract AllocatedCrowdsale is AllocatedCrowdsaleMixin, Crowdsale {
925 
926   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
927 
928   }
929 
930 }