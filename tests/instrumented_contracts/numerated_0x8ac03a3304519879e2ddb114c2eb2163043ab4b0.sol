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
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 /*
61  * Haltable
62  *
63  * Abstract contract that allows children to implement an
64  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
65  *
66  *
67  * Originally envisioned in FirstBlood ICO contract.
68  */
69 contract Haltable is Ownable {
70   bool public halted;
71 
72   modifier stopInEmergency {
73     if (halted) throw;
74     _;
75   }
76 
77   modifier stopNonOwnersInEmergency {
78     if (halted && msg.sender != owner) throw;
79     _;
80   }
81 
82   modifier onlyInEmergency {
83     if (!halted) throw;
84     _;
85   }
86 
87   // called by the owner on emergency, triggers stopped state
88   function halt() external onlyOwner {
89     halted = true;
90   }
91 
92   // called by the owner on end of emergency, returns to normal state
93   function unhalt() external onlyOwner onlyInEmergency {
94     halted = false;
95   }
96 
97 }
98 
99 /**
100  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
101  *
102  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
103  */
104 
105 
106 /**
107  * Safe unsigned safe math.
108  *
109  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
110  *
111  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
112  *
113  * Maintained here until merged to mainline zeppelin-solidity.
114  *
115  */
116 library SafeMathLib {
117 
118   function times(uint a, uint b) returns (uint) {
119     uint c = a * b;
120     assert(a == 0 || c / a == b);
121     return c;
122   }
123 
124   function minus(uint a, uint b) returns (uint) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   function plus(uint a, uint b) returns (uint) {
130     uint c = a + b;
131     assert(c>=a);
132     return c;
133   }
134 
135 }
136 
137 /**
138  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
139  *
140  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
141  */
142 
143 
144 
145 
146 
147 
148 /**
149  * @title ERC20Basic
150  * @dev Simpler version of ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/179
152  */
153 contract ERC20Basic {
154   uint256 public totalSupply;
155   function balanceOf(address who) public constant returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
160 
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public constant returns (uint256);
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 
174 /**
175  * A token that defines fractional units as decimals.
176  */
177 contract FractionalERC20 is ERC20 {
178 
179   uint public decimals;
180 
181 }
182 
183 /**
184  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
185  *
186  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
187  */
188 
189 
190 /**
191  * Interface for defining crowdsale pricing.
192  */
193 contract PricingStrategy {
194 
195   /** Interface declaration. */
196   function isPricingStrategy() public constant returns (bool) {
197     return true;
198   }
199 
200   /** Self check if all references are correctly set.
201    *
202    * Checks that pricing strategy matches crowdsale parameters.
203    */
204   function isSane(address crowdsale) public constant returns (bool) {
205     return true;
206   }
207 
208   /**
209    * @dev Pricing tells if this is a presale purchase or not.
210      @param purchaser Address of the purchaser
211      @return False by default, true if a presale purchaser
212    */
213   function isPresalePurchase(address purchaser) public constant returns (bool) {
214     return false;
215   }
216 
217   /**
218    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
219    *
220    *
221    * @param value - What is the value of the transaction send in as wei
222    * @param tokensSold - how much tokens have been sold this far
223    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
224    * @param msgSender - who is the investor of this transaction
225    * @param decimals - how many decimal units the token has
226    * @return Amount of tokens the investor receives
227    */
228   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
229 }
230 
231 /**
232  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
233  *
234  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
235  */
236 
237 
238 /**
239  * Finalize agent defines what happens at the end of succeseful crowdsale.
240  *
241  * - Allocate tokens for founders, bounties and community
242  * - Make tokens transferable
243  * - etc.
244  */
245 contract FinalizeAgent {
246 
247   function isFinalizeAgent() public constant returns(bool) {
248     return true;
249   }
250 
251   /** Return true if we can run finalizeCrowdsale() properly.
252    *
253    * This is a safety check function that doesn't allow crowdsale to begin
254    * unless the finalizer has been set up properly.
255    */
256   function isSane() public constant returns (bool);
257 
258   /** Called once by crowdsale finalize() if the sale was success. */
259   function finalizeCrowdsale();
260 
261 }
262 
263 
264 
265 /**
266  * Crowdsale state machine without buy functionality.
267  *
268  * Implements basic state machine logic, but leaves out all buy functions,
269  * so that subclasses can implement their own buying logic.
270  *
271  *
272  * For the default buy() implementation see Crowdsale.sol.
273  */
274 contract CrowdsaleBase is Haltable {
275 
276   /* Max investment count when we are still allowed to change the multisig address */
277   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
278 
279   using SafeMathLib for uint;
280 
281   /* The token we are selling */
282   FractionalERC20 public token;
283 
284   /* How we are going to price our offering */
285   PricingStrategy public pricingStrategy;
286 
287   /* Post-success callback */
288   FinalizeAgent public finalizeAgent;
289 
290   /* tokens will be transfered from this address */
291   address public multisigWallet;
292 
293   /* if the funding goal is not reached, investors may withdraw their funds */
294   uint public minimumFundingGoal;
295 
296   /* the UNIX timestamp start date of the crowdsale */
297   uint public startsAt;
298 
299   /* the UNIX timestamp end date of the crowdsale */
300   uint public endsAt;
301 
302   /* the number of tokens already sold through this contract*/
303   uint public tokensSold = 0;
304 
305   /* How many wei of funding we have raised */
306   uint public weiRaised = 0;
307 
308   /* Calculate incoming funds from presale contracts and addresses */
309   uint public presaleWeiRaised = 0;
310 
311   /* How many distinct addresses have invested */
312   uint public investorCount = 0;
313 
314   /* How much wei we have returned back to the contract after a failed crowdfund. */
315   uint public loadedRefund = 0;
316 
317   /* How much wei we have given back to investors.*/
318   uint public weiRefunded = 0;
319 
320   /* Has this crowdsale been finalized */
321   bool public finalized;
322 
323   /** How much ETH each address has invested to this crowdsale */
324   mapping (address => uint256) public investedAmountOf;
325 
326   /** How much tokens this crowdsale has credited for each investor address */
327   mapping (address => uint256) public tokenAmountOf;
328 
329   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
330   mapping (address => bool) public earlyParticipantWhitelist;
331 
332   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
333   uint public ownerTestValue;
334 
335   /** State machine
336    *
337    * - Preparing: All contract initialization calls and variables have not been set yet
338    * - Prefunding: We have not passed start time yet
339    * - Funding: Active crowdsale
340    * - Success: Minimum funding goal reached
341    * - Failure: Minimum funding goal not reached before ending time
342    * - Finalized: The finalized has been called and succesfully executed
343    * - Refunding: Refunds are loaded on the contract for reclaim.
344    */
345   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
346 
347   // A new investment was made
348   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
349 
350   // Refund was processed for a contributor
351   event Refund(address investor, uint weiAmount);
352 
353   // The rules were changed what kind of investments we accept
354   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
355 
356   // Address early participation whitelist status changed
357   event Whitelisted(address addr, bool status);
358 
359   // Crowdsale end time has been changed
360   event EndsAtChanged(uint newEndsAt);
361 
362   State public testState;
363 
364   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
365 
366     owner = msg.sender;
367 
368     token = FractionalERC20(_token);
369 
370     setPricingStrategy(_pricingStrategy);
371 
372     multisigWallet = _multisigWallet;
373     if(multisigWallet == 0) {
374         throw;
375     }
376 
377     if(_start == 0) {
378         throw;
379     }
380 
381     startsAt = _start;
382 
383     if(_end == 0) {
384         throw;
385     }
386 
387     endsAt = _end;
388 
389     // Don't mess the dates
390     if(startsAt >= endsAt) {
391         throw;
392     }
393 
394     // Minimum funding goal can be zero
395     minimumFundingGoal = _minimumFundingGoal;
396   }
397 
398   /**
399    * Don't expect to just send in money and get tokens.
400    */
401   function() payable {
402     throw;
403   }
404 
405   /**
406    * Make an investment.
407    *
408    * Crowdsale must be running for one to invest.
409    * We must have not pressed the emergency brake.
410    *
411    * @param receiver The Ethereum address who receives the tokens
412    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
413    *
414    * @return tokenAmount How mony tokens were bought
415    */
416   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
417 
418     // Determine if it's a good time to accept investment from this participant
419     if(getState() == State.PreFunding) {
420       // Are we whitelisted for early deposit
421       if(!earlyParticipantWhitelist[receiver]) {
422         throw;
423       }
424     } else if(getState() == State.Funding) {
425       // Retail participants can only come in when the crowdsale is running
426       // pass
427     } else {
428       // Unwanted state
429       throw;
430     }
431 
432     uint weiAmount = msg.value;
433 
434     // Account presale sales separately, so that they do not count against pricing tranches
435     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
436 
437     // Dust transaction
438     require(tokenAmount != 0);
439 
440     if(investedAmountOf[receiver] == 0) {
441        // A new investor
442        investorCount++;
443     }
444 
445     // Update investor
446     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
447     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
448 
449     // Update totals
450     weiRaised = weiRaised.plus(weiAmount);
451     tokensSold = tokensSold.plus(tokenAmount);
452 
453     if(pricingStrategy.isPresalePurchase(receiver)) {
454         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
455     }
456 
457     // Check that we did not bust the cap
458     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
459 
460     assignTokens(receiver, tokenAmount);
461 
462     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
463     if(!multisigWallet.send(weiAmount)) throw;
464 
465     // Tell us invest was success
466     Invested(receiver, weiAmount, tokenAmount, customerId);
467 
468     return tokenAmount;
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
479     if(finalized) {
480       throw;
481     }
482 
483     // Finalizing is optional. We only call it if we are given a finalizing agent.
484     if(address(finalizeAgent) != 0) {
485       finalizeAgent.finalizeCrowdsale();
486     }
487 
488     finalized = true;
489   }
490 
491   /**
492    * Allow to (re)set finalize agent.
493    *
494    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
495    */
496   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
497     finalizeAgent = addr;
498 
499     // Don't allow setting bad agent
500     if(!finalizeAgent.isFinalizeAgent()) {
501       throw;
502     }
503   }
504 
505   /**
506    * Allow crowdsale owner to close early or extend the crowdsale.
507    *
508    * This is useful e.g. for a manual soft cap implementation:
509    * - after X amount is reached determine manual closing
510    *
511    * This may put the crowdsale to an invalid state,
512    * but we trust owners know what they are doing.
513    *
514    */
515   function setEndsAt(uint time) onlyOwner {
516 
517     if(now > time) {
518       throw; // Don't change past
519     }
520 
521     if(startsAt > time) {
522       throw; // Prevent human mistakes
523     }
524 
525     endsAt = time;
526     EndsAtChanged(endsAt);
527   }
528 
529   /**
530    * Allow to (re)set pricing strategy.
531    *
532    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
533    */
534   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
535     pricingStrategy = _pricingStrategy;
536 
537     // Don't allow setting bad agent
538     if(!pricingStrategy.isPricingStrategy()) {
539       throw;
540     }
541   }
542 
543   /**
544    * Allow to change the team multisig address in the case of emergency.
545    *
546    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
547    * (we have done only few test transactions). After the crowdsale is going
548    * then multisig address stays locked for the safety reasons.
549    */
550   function setMultisig(address addr) public onlyOwner {
551 
552     // Change
553     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
554       throw;
555     }
556 
557     multisigWallet = addr;
558   }
559 
560   /**
561    * Allow load refunds back on the contract for the refunding.
562    *
563    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
564    */
565   function loadRefund() public payable inState(State.Failure) {
566     if(msg.value == 0) throw;
567     loadedRefund = loadedRefund.plus(msg.value);
568   }
569 
570   /**
571    * Investors can claim refund.
572    *
573    * Note that any refunds from proxy buyers should be handled separately,
574    * and not through this contract.
575    */
576   function refund() public inState(State.Refunding) {
577     uint256 weiValue = investedAmountOf[msg.sender];
578     if (weiValue == 0) throw;
579     investedAmountOf[msg.sender] = 0;
580     weiRefunded = weiRefunded.plus(weiValue);
581     Refund(msg.sender, weiValue);
582     if (!msg.sender.send(weiValue)) throw;
583   }
584 
585   /**
586    * @return true if the crowdsale has raised enough money to be a successful.
587    */
588   function isMinimumGoalReached() public constant returns (bool reached) {
589     return weiRaised >= minimumFundingGoal;
590   }
591 
592   /**
593    * Check if the contract relationship looks good.
594    */
595   function isFinalizerSane() public constant returns (bool sane) {
596     return finalizeAgent.isSane();
597   }
598 
599   /**
600    * Check if the contract relationship looks good.
601    */
602   function isPricingSane() public constant returns (bool sane) {
603     return pricingStrategy.isSane(address(this));
604   }
605 
606   /**
607    * Crowdfund state machine management.
608    *
609    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
610    */
611   function getState() public constant returns (State) {
612     if(finalized) return State.Finalized;
613     else if (address(finalizeAgent) == 0) return State.Preparing;
614     else if (!finalizeAgent.isSane()) return State.Preparing;
615     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
616     else if (block.timestamp < startsAt) return State.PreFunding;
617     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
618     else if (isMinimumGoalReached()) return State.Success;
619     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
620     else return State.Failure;
621   }
622 
623   /** This is for manual testing of multisig wallet interaction */
624   function setOwnerTestValue(uint val) onlyOwner {
625     ownerTestValue = val;
626   }
627 
628   /**
629    * Allow addresses to do early participation.
630    *
631    * TODO: Fix spelling error in the name
632    */
633   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
634     earlyParticipantWhitelist[addr] = status;
635     Whitelisted(addr, status);
636   }
637 
638 
639   /** Interface marker. */
640   function isCrowdsale() public constant returns (bool) {
641     return true;
642   }
643 
644   //
645   // Modifiers
646   //
647 
648   /** Modified allowing execution only if the crowdsale is currently running.  */
649   modifier inState(State state) {
650     if(getState() != state) throw;
651     _;
652   }
653 
654 
655   //
656   // Abstract functions
657   //
658 
659   /**
660    * Check if the current invested breaks our cap rules.
661    *
662    *
663    * The child contract must define their own cap setting rules.
664    * We allow a lot of flexibility through different capping strategies (ETH, token count)
665    * Called from invest().
666    *
667    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
668    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
669    * @param weiRaisedTotal What would be our total raised balance after this transaction
670    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
671    *
672    * @return true if taking this investment would break our cap rules
673    */
674   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
675 
676   /**
677    * Check if the current crowdsale is full and we can no longer sell any tokens.
678    */
679   function isCrowdsaleFull() public constant returns (bool);
680 
681   /**
682    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
683    */
684   function assignTokens(address receiver, uint tokenAmount) internal;
685 }
686 
687 /**
688  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
689  *
690  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
691  */
692 
693 
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
761 /**
762  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
763  *
764  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
765  */
766 
767 /**
768  * Deserialize bytes payloads.
769  *
770  * Values are in big-endian byte order.
771  *
772  */
773 library BytesDeserializer {
774 
775   /**
776    * Extract 256-bit worth of data from the bytes stream.
777    */
778   function slice32(bytes b, uint offset) constant returns (bytes32) {
779     bytes32 out;
780 
781     for (uint i = 0; i < 32; i++) {
782       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
783     }
784     return out;
785   }
786 
787   /**
788    * Extract Ethereum address worth of data from the bytes stream.
789    */
790   function sliceAddress(bytes b, uint offset) constant returns (address) {
791     bytes32 out;
792 
793     for (uint i = 0; i < 20; i++) {
794       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
795     }
796     return address(uint(out));
797   }
798 
799   /**
800    * Extract 128-bit worth of data from the bytes stream.
801    */
802   function slice16(bytes b, uint offset) constant returns (bytes16) {
803     bytes16 out;
804 
805     for (uint i = 0; i < 16; i++) {
806       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
807     }
808     return out;
809   }
810 
811   /**
812    * Extract 32-bit worth of data from the bytes stream.
813    */
814   function slice4(bytes b, uint offset) constant returns (bytes4) {
815     bytes4 out;
816 
817     for (uint i = 0; i < 4; i++) {
818       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
819     }
820     return out;
821   }
822 
823   /**
824    * Extract 16-bit worth of data from the bytes stream.
825    */
826   function slice2(bytes b, uint offset) constant returns (bytes2) {
827     bytes2 out;
828 
829     for (uint i = 0; i < 2; i++) {
830       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
831     }
832     return out;
833   }
834 
835 
836 
837 }
838 
839 
840 /**
841  * A mix-in contract to decode different AML payloads.
842  *
843  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we put this as a mix-in.
844  */
845 contract KYCPayloadDeserializer {
846 
847   using BytesDeserializer for bytes;
848 
849   // The bytes payload set on the server side
850   // total 56 bytes
851 
852   struct KYCPayload {
853 
854     /** Customer whitelisted address where the deposit can come from */
855     address whitelistedAddress; // 20 bytes
856 
857     /** Customer id, UUID v4 */
858     uint128 customerId; // 16 bytes
859 
860     /**
861      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
862      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
863      */
864     uint32 minETH; // 4 bytes
865 
866     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
867     uint32 maxETH; // 4 bytes
868   }
869 
870   /**
871    * Deconstruct server-side byte data to structured data.
872    */
873 
874   function deserializeKYCPayload(bytes dataframe) internal constant returns(KYCPayload decodedPayload) {
875     KYCPayload payload;
876     payload.whitelistedAddress = dataframe.sliceAddress(0);
877     payload.customerId = uint128(dataframe.slice16(20));
878     payload.minETH = uint32(dataframe.slice4(36));
879     payload.maxETH = uint32(dataframe.slice4(40));
880     return payload;
881   }
882 
883   /**
884    * Helper function to allow us to return the decoded payload to an external caller for testing.
885    *
886    * TODO: Some sort of compiler issue (?) with memory keyword. Tested with solc 0.4.16 and solc 0.4.18.
887    * If used, makes KYCCrowdsale to set itself to a bad state getState() returns 5 (Failure). Overrides some memory?
888    */
889   /*
890   function broken_getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
891     KYCPayload memory payload = deserializeKYCPayload(dataframe);
892     payload.whitelistedAddress = dataframe.sliceAddress(0);
893     payload.customerId = uint128(dataframe.slice16(20));
894     payload.minETH = uint32(dataframe.slice4(36));
895     payload.maxETH = uint32(dataframe.slice4(40));
896     return (payload.whitelistedAddress, payload.customerId, payload.minETH, payload.maxETH);
897   }*/
898 
899   /**
900    * Same as above, does not seem to cause any issue.
901    */
902   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
903     address _whitelistedAddress = dataframe.sliceAddress(0);
904     uint128 _customerId = uint128(dataframe.slice16(20));
905     uint32 _minETH = uint32(dataframe.slice4(36));
906     uint32 _maxETH = uint32(dataframe.slice4(40));
907     return (_whitelistedAddress, _customerId, _minETH, _maxETH);
908   }
909 
910 }
911 
912 
913 /**
914  * A crowdsale that allows only signed payload with server-side specified buy in limits.
915  *
916  *
917  * The token distribution happens as in the allocated crowdsale.
918  *
919  */
920 contract KYCCrowdsale is AllocatedCrowdsaleMixin, KYCPayloadDeserializer {
921 
922   /* Server holds the private key to this address to decide if the AML payload is valid or not. */
923   address public signerAddress;
924 
925   /* A new server-side signer key was set to be effective */
926   event SignerChanged(address signer);
927 
928   /**
929    * Constructor.
930    */
931   function KYCCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
932 
933   }
934 
935   /**
936    * A token purchase with anti-money laundering
937    *
938    * ©return tokenAmount How many tokens where bought
939    */
940   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
941 
942     uint _tokenAmount;
943     uint multiplier = 10 ** 18;
944 
945     // Perform signature check for normal addresses
946     // (not deployment accounts, etc.)
947     if(earlyParticipantWhitelist[msg.sender]) {
948       // For test purchases use this faux customer id
949       _tokenAmount = investInternal(msg.sender, 0x1000);
950 
951     } else {
952 
953       bytes32 hash = sha256(dataframe);
954 
955       var (whitelistedAddress, customerId, minETH, maxETH) = getKYCPayload(dataframe);
956 
957       // Check that the KYC data is signed by our server
958       require(ecrecover(hash, v, r, s) == signerAddress);
959 
960       // Only whitelisted address can participate the transaction
961       require(whitelistedAddress == msg.sender);
962 
963       _tokenAmount = investInternal(msg.sender, customerId);
964 
965     }
966 
967     if(!earlyParticipantWhitelist[msg.sender]) {
968       // We assume there is no serious min and max fluctuations for the customer, unless
969       // especially set in the server side per customer manual override.
970       // Otherwise the customer can reuse old data payload with different min or max value
971       // to work around the per customer cap.
972       require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
973       require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
974     }
975 
976     return _tokenAmount;
977   }
978 
979   /// @dev This function can set the server side address
980   /// @param _signerAddress The address derived from server's private key
981   function setSignerAddress(address _signerAddress) onlyOwner {
982     signerAddress = _signerAddress;
983     SignerChanged(signerAddress);
984   }
985 
986 }