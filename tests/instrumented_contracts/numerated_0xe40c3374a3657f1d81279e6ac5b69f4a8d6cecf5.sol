1 pragma solidity ^0.4.11;
2 
3 // File: contracts/FinalizeAgent.sol
4 
5 /**
6  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
7  *
8  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
9  */
10 
11 pragma solidity ^0.4.6;
12 
13 /**
14  * Finalize agent defines what happens at the end of succeseful crowdsale.
15  *
16  * - Allocate tokens for founders, bounties and community
17  * - Make tokens transferable
18  * - etc.
19  */
20 contract FinalizeAgent {
21 
22   function isFinalizeAgent() public constant returns(bool) {
23     return true;
24   }
25 
26   /** Return true if we can run finalizeCrowdsale() properly.
27    *
28    * This is a safety check function that doesn't allow crowdsale to begin
29    * unless the finalizer has been set up properly.
30    */
31   function isSane() public constant returns (bool);
32 
33   /** Called once by crowdsale finalize() if the sale was success. */
34   function finalizeCrowdsale();
35 
36 }
37 
38 // File: contracts/zeppelin/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) constant returns (uint256);
48   function transfer(address to, uint256 value) returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: contracts/zeppelin/contracts/token/ERC20.sol
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant returns (uint256);
60   function transferFrom(address from, address to, uint256 value) returns (bool);
61   function approve(address spender, uint256 value) returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 // File: contracts/FractionalERC20.sol
66 
67 /**
68  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
69  *
70  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
71  */
72 
73 pragma solidity ^0.4.8;
74 
75 
76 
77 /**
78  * A token that defines fractional units as decimals.
79  */
80 contract FractionalERC20 is ERC20 {
81 
82   uint public decimals;
83 
84 }
85 
86 // File: contracts/zeppelin/contracts/ownership/Ownable.sol
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   function Ownable() {
102     owner = msg.sender;
103   }
104 
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address newOwner) onlyOwner {
120     require(newOwner != address(0));
121     owner = newOwner;
122   }
123 
124 }
125 
126 // File: contracts/Haltable.sol
127 
128 /**
129  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
130  *
131  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
132  */
133 
134 pragma solidity ^0.4.6;
135 
136 
137 
138 /*
139  * Haltable
140  *
141  * Abstract contract that allows children to implement an
142  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
143  *
144  *
145  * Originally envisioned in FirstBlood ICO contract.
146  */
147 contract Haltable is Ownable {
148   bool public halted;
149 
150   modifier stopInEmergency {
151     if (halted) throw;
152     _;
153   }
154 
155   modifier stopNonOwnersInEmergency {
156     if (halted && msg.sender != owner) throw;
157     _;
158   }
159 
160   modifier onlyInEmergency {
161     if (!halted) throw;
162     _;
163   }
164 
165   // called by the owner on emergency, triggers stopped state
166   function halt() external onlyOwner {
167     halted = true;
168   }
169 
170   // called by the owner on end of emergency, returns to normal state
171   function unhalt() external onlyOwner onlyInEmergency {
172     halted = false;
173   }
174 
175 }
176 
177 // File: contracts/PricingStrategy.sol
178 
179 /**
180  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
181  *
182  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
183  */
184 
185 pragma solidity ^0.4.6;
186 
187 /**
188  * Interface for defining crowdsale pricing.
189  */
190 contract PricingStrategy {
191 
192   /** Interface declaration. */
193   function isPricingStrategy() public constant returns (bool) {
194     return true;
195   }
196 
197   /** Self check if all references are correctly set.
198    *
199    * Checks that pricing strategy matches crowdsale parameters.
200    */
201   function isSane(address crowdsale) public constant returns (bool) {
202     return true;
203   }
204 
205   /**
206    * @dev Pricing tells if this is a presale purchase or not.
207      @param purchaser Address of the purchaser
208      @return False by default, true if a presale purchaser
209    */
210   function isPresalePurchase(address purchaser) public constant returns (bool) {
211     return false;
212   }
213 
214   /**
215    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
216    *
217    *
218    * @param value - What is the value of the transaction send in as wei
219    * @param tokensSold - how much tokens have been sold this far
220    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
221    * @param msgSender - who is the investor of this transaction
222    * @param decimals - how many decimal units the token has
223    * @return Amount of tokens the investor receives
224    */
225   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
226 }
227 
228 // File: contracts/SafeMathLib.sol
229 
230 /**
231  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
232  *
233  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
234  */
235 
236 pragma solidity ^0.4.6;
237 
238 /**
239  * Safe unsigned safe math.
240  *
241  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
242  *
243  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
244  *
245  * Maintained here until merged to mainline zeppelin-solidity.
246  *
247  */
248 library SafeMathLib {
249 
250   function times(uint a, uint b) returns (uint) {
251     uint c = a * b;
252     assert(a == 0 || c / a == b);
253     return c;
254   }
255 
256   function minus(uint a, uint b) returns (uint) {
257     assert(b <= a);
258     return a - b;
259   }
260 
261   function plus(uint a, uint b) returns (uint) {
262     uint c = a + b;
263     assert(c>=a);
264     return c;
265   }
266 
267 }
268 
269 // File: contracts/CrowdsaleBase.sol
270 
271 /**
272  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
273  *
274  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
275  */
276 
277 
278 
279 
280 
281 
282 
283 
284 
285 /**
286  * Crowdsale state machine without buy functionality.
287  *
288  * Implements basic state machine logic, but leaves out all buy functions,
289  * so that subclasses can implement their own buying logic.
290  *
291  *
292  * For the default buy() implementation see Crowdsale.sol.
293  */
294 contract CrowdsaleBase is Haltable {
295 
296   /* Max investment count when we are still allowed to change the multisig address */
297   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
298 
299   using SafeMathLib for uint;
300 
301   /* The token we are selling */
302   FractionalERC20 public token;
303 
304   /* How we are going to price our offering */
305   PricingStrategy public pricingStrategy;
306 
307   /* Post-success callback */
308   FinalizeAgent public finalizeAgent;
309 
310   /* tokens will be transfered from this address */
311   address public multisigWallet;
312 
313   /* if the funding goal is not reached, investors may withdraw their funds */
314   uint public minimumFundingGoal;
315 
316   /* maximum investment per address */
317   uint public maximalInvestment = 0;
318 
319   /* Seconds since the start of the funding during which the maximalInvestemnt cap is enforced */
320   uint public maximalInvestmentTimeTreshold = 3*60*60;
321 
322   /* the UNIX timestamp start date of the crowdsale */
323   uint public startsAt;
324 
325   /* the UNIX timestamp end date of the crowdsale */
326   uint public endsAt;
327 
328   /* the number of tokens already sold through this contract*/
329   uint public tokensSold = 0;
330 
331   /* How many wei of funding we have raised */
332   uint public weiRaised = 0;
333 
334   /* Calculate incoming funds from presale contracts and addresses */
335   uint public presaleWeiRaised = 0;
336 
337   /* How many distinct addresses have invested */
338   uint public investorCount = 0;
339 
340   /* How much wei we have returned back to the contract after a failed crowdfund. */
341   uint public loadedRefund = 0;
342 
343   /* How much wei we have given back to investors.*/
344   uint public weiRefunded = 0;
345 
346   /* Has this crowdsale been finalized */
347   bool public finalized;
348 
349   /** How much ETH each address has invested to this crowdsale */
350   mapping (address => uint256) public investedAmountOf;
351 
352   /** How much tokens this crowdsale has credited for each investor address */
353   mapping (address => uint256) public tokenAmountOf;
354 
355   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
356   mapping (address => bool) public earlyParticipantWhitelist;
357 
358   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
359   uint public ownerTestValue;
360 
361   /** State machine
362    *
363    * - Preparing: All contract initialization calls and variables have not been set yet
364    * - Prefunding: We have not passed start time yet
365    * - Funding: Active crowdsale
366    * - Success: Minimum funding goal reached
367    * - Failure: Minimum funding goal not reached before ending time
368    * - Finalized: The finalized has been called and succesfully executed
369    * - Refunding: Refunds are loaded on the contract for reclaim.
370    */
371   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
372 
373   // A new investment was made
374   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
375 
376   // Refund was processed for a contributor
377   event Refund(address investor, uint weiAmount);
378 
379   // The rules were changed what kind of investments we accept
380   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, bool newRequireWhitelistedAddress, address newSignerAddress, address whitelisterAddress);
381 
382   // Address early participation whitelist status changed
383   event Whitelisted(address addr, bool status);
384 
385   // Crowdsale end time has been changed
386   event EndsAtChanged(uint newEndsAt);
387 
388   State public testState;
389 
390   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maxInvestment) {
391 
392     owner = msg.sender;
393 
394     token = FractionalERC20(_token);
395 
396     setPricingStrategy(_pricingStrategy);
397 
398     multisigWallet = _multisigWallet;
399     if(multisigWallet == 0) {
400         throw;
401     }
402 
403     if(_start == 0) {
404         throw;
405     }
406 
407     startsAt = _start;
408 
409     if(_end == 0) {
410         throw;
411     }
412 
413     endsAt = _end;
414 
415     // Don't mess the dates
416     if(startsAt >= endsAt) {
417         throw;
418     }
419 
420     // Minimum funding goal can be zero
421     minimumFundingGoal = _minimumFundingGoal;
422 
423     maximalInvestment = _maxInvestment;
424   }
425 
426   /**
427    * Don't expect to just send in money and get tokens.
428    */
429   function() payable {
430     throw;
431   }
432 
433   /**
434    * Make an investment.
435    *
436    * Crowdsale must be running for one to invest.
437    * We must have not pressed the emergency brake.
438    *
439    * @param receiver The Ethereum address who receives the tokens
440    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
441    *
442    * @return tokenAmount How mony tokens were bought
443    */
444   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
445 
446     // Determine if it's a good time to accept investment from this participant
447     if(getState() == State.PreFunding) {
448       // Are we whitelisted for early deposit
449       if(!earlyParticipantWhitelist[receiver]) {
450         throw;
451       }
452     } else if(getState() == State.Funding) {
453       // Retail participants can only come in when the crowdsale is running
454       // pass
455     } else {
456       // Unwanted state
457       throw;
458     }
459 
460     uint weiAmount = msg.value;
461 
462     // Account presale sales separately, so that they do not count against pricing tranches
463     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
464 
465     // Dust transaction
466     require(tokenAmount != 0);
467 
468     if(investedAmountOf[receiver] == 0) {
469        // A new investor
470        investorCount++;
471     }
472 
473     // Update investor
474     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
475 
476     if(maximalInvestment > 0 && now < (startsAt + maximalInvestmentTimeTreshold)) {
477       require(investedAmountOf[receiver] <= maximalInvestment);
478     }
479 
480     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
481 
482     // Update totals
483     weiRaised = weiRaised.plus(weiAmount);
484     tokensSold = tokensSold.plus(tokenAmount);
485 
486     if(pricingStrategy.isPresalePurchase(receiver)) {
487         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
488     }
489 
490     // Check that we did not bust the cap
491     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
492 
493     assignTokens(receiver, tokenAmount);
494 
495     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
496     if(!multisigWallet.send(weiAmount)) throw;
497 
498     // Tell us invest was success
499     Invested(receiver, weiAmount, tokenAmount, customerId);
500 
501     return tokenAmount;
502   }
503 
504   /**
505    * Finalize a succcesful crowdsale.
506    *
507    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
508    */
509   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
510 
511     // Already finalized
512     if(finalized) {
513       throw;
514     }
515 
516     // Finalizing is optional. We only call it if we are given a finalizing agent.
517     if(address(finalizeAgent) != 0) {
518       finalizeAgent.finalizeCrowdsale();
519     }
520 
521     finalized = true;
522   }
523 
524   /**
525    * Allow to (re)set finalize agent.
526    *
527    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
528    */
529   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
530     finalizeAgent = addr;
531 
532     // Don't allow setting bad agent
533     if(!finalizeAgent.isFinalizeAgent()) {
534       throw;
535     }
536   }
537 
538   /**
539    * Allow crowdsale owner to close early or extend the crowdsale.
540    *
541    * This is useful e.g. for a manual soft cap implementation:
542    * - after X amount is reached determine manual closing
543    *
544    * This may put the crowdsale to an invalid state,
545    * but we trust owners know what they are doing.
546    *
547    */
548   function setEndsAt(uint time) onlyOwner {
549 
550     if(now > time) {
551       throw; // Don't change past
552     }
553 
554     if(startsAt > time) {
555       throw; // Prevent human mistakes
556     }
557 
558     endsAt = time;
559     EndsAtChanged(endsAt);
560   }
561 
562   /**
563    * Allow to (re)set pricing strategy.
564    *
565    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
566    */
567   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
568     pricingStrategy = _pricingStrategy;
569 
570     // Don't allow setting bad agent
571     if(!pricingStrategy.isPricingStrategy()) {
572       throw;
573     }
574   }
575 
576   /**
577    * Allow to change the team multisig address in the case of emergency.
578    *
579    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
580    * (we have done only few test transactions). After the crowdsale is going
581    * then multisig address stays locked for the safety reasons.
582    */
583   function setMultisig(address addr) public onlyOwner {
584 
585     // Change
586     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
587       throw;
588     }
589 
590     multisigWallet = addr;
591   }
592 
593   /**
594    * Allow load refunds back on the contract for the refunding.
595    *
596    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
597    */
598   function loadRefund() public payable inState(State.Failure) {
599     if(msg.value == 0) throw;
600     loadedRefund = loadedRefund.plus(msg.value);
601   }
602 
603   /**
604    * Investors can claim refund.
605    *
606    * Note that any refunds from proxy buyers should be handled separately,
607    * and not through this contract.
608    */
609   function refund() public inState(State.Refunding) {
610     uint256 weiValue = investedAmountOf[msg.sender];
611     if (weiValue == 0) throw;
612     investedAmountOf[msg.sender] = 0;
613     weiRefunded = weiRefunded.plus(weiValue);
614     Refund(msg.sender, weiValue);
615     if (!msg.sender.send(weiValue)) throw;
616   }
617 
618   /**
619    * @return true if the crowdsale has raised enough money to be a successful.
620    */
621   function isMinimumGoalReached() public constant returns (bool reached) {
622     return weiRaised >= minimumFundingGoal;
623   }
624 
625   /**
626    * Check if the contract relationship looks good.
627    */
628   function isFinalizerSane() public constant returns (bool sane) {
629     return finalizeAgent.isSane();
630   }
631 
632   /**
633    * Check if the contract relationship looks good.
634    */
635   function isPricingSane() public constant returns (bool sane) {
636     return pricingStrategy.isSane(address(this));
637   }
638 
639   /**
640    * Crowdfund state machine management.
641    *
642    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
643    */
644   function getState() public constant returns (State) {
645     if(finalized) return State.Finalized;
646     else if (address(finalizeAgent) == 0) return State.Preparing;
647     else if (!finalizeAgent.isSane()) return State.Preparing;
648     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
649     else if (block.timestamp < startsAt) return State.PreFunding;
650     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
651     else if (isMinimumGoalReached()) return State.Success;
652     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
653     else return State.Failure;
654   }
655 
656   /** This is for manual testing of multisig wallet interaction */
657   function setOwnerTestValue(uint val) onlyOwner {
658     ownerTestValue = val;
659   }
660 
661   /**
662    * Allow addresses to do early participation.
663    *
664    * TODO: Fix spelling error in the name
665    */
666   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
667     earlyParticipantWhitelist[addr] = status;
668     Whitelisted(addr, status);
669   }
670 
671 
672   /** Interface marker. */
673   function isCrowdsale() public constant returns (bool) {
674     return true;
675   }
676 
677   //
678   // Modifiers
679   //
680 
681   /** Modified allowing execution only if the crowdsale is currently running.  */
682   modifier inState(State state) {
683     if(getState() != state) throw;
684     _;
685   }
686 
687 
688   //
689   // Abstract functions
690   //
691 
692   /**
693    * Check if the current invested breaks our cap rules.
694    *
695    *
696    * The child contract must define their own cap setting rules.
697    * We allow a lot of flexibility through different capping strategies (ETH, token count)
698    * Called from invest().
699    *
700    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
701    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
702    * @param weiRaisedTotal What would be our total raised balance after this transaction
703    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
704    *
705    * @return true if taking this investment would break our cap rules
706    */
707   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
708 
709   /**
710    * Check if the current crowdsale is full and we can no longer sell any tokens.
711    */
712   function isCrowdsaleFull() public constant returns (bool);
713 
714   /**
715    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
716    */
717   function assignTokens(address receiver, uint tokenAmount) internal;
718 }
719 
720 // File: contracts/Crowdsale.sol
721 
722 /**
723  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
724  *
725  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
726  */
727 
728 pragma solidity ^0.4.8;
729 
730 
731 
732 
733 
734 
735 
736 
737 /**
738  * Abstract base contract for token sales with the default buy entry points.
739  *
740  * Handle
741  * - start and end dates
742  * - accepting investments
743  * - minimum funding goal and refund
744  * - various statistics during the crowdfund
745  * - different pricing strategies
746  * - different investment policies (require server side customer id, allow only whitelisted addresses)
747  *
748  * Does not Handle
749  *
750  * - Token allocation (minting vs. transfer)
751  * - Cap rules
752  *
753  */
754 contract Crowdsale is CrowdsaleBase {
755 
756   /* Do we need to have unique contributor id for each customer */
757   bool public requireCustomerId;
758 
759   /**
760     * Do we verify that contributor has been cleared on the server side (accredited investors only).
761     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
762     */
763   bool public requiredSignedAddress;
764 
765   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
766   address public signerAddress;
767 
768   /* Do we need to have unique contributor id for each customer */
769   bool public requireWhitelistedAddress;
770 
771   /* Account that is allowed to whitelist addesses */
772   address public whitelisterAddress;
773 
774   /* Mapping of whitelisted accounts */
775   mapping (address => bool) whitelist;
776 
777 
778   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maxInvestment) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _maxInvestment) {
779   }
780 
781   /**
782    * Preallocate tokens for the early investors.
783    *
784    * Preallocated tokens have been sold before the actual crowdsale opens.
785    * This function mints the tokens and moves the crowdsale needle.
786    *
787    * Investor count is not handled; it is assumed this goes for multiple investors
788    * and the token distribution happens outside the smart contract flow.
789    *
790    * No money is exchanged, as the crowdsale team already have received the payment.
791    *
792    * @param fullTokens tokens as full tokens - decimal places added internally
793    * @param weiPrice Price of a single full token in wei
794    *
795    */
796   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
797 
798     uint tokenAmount = fullTokens * 10**token.decimals();
799     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
800 
801     weiRaised = weiRaised.plus(weiAmount);
802     tokensSold = tokensSold.plus(tokenAmount);
803 
804     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
805     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
806 
807     assignTokens(receiver, tokenAmount);
808 
809     // Tell us invest was success
810     Invested(receiver, weiAmount, tokenAmount, 0);
811   }
812 
813   /**
814    * Allow anonymous contributions to this crowdsale.
815    */
816   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
817     if(requireWhitelistedAddress) {
818       require(whitelist[addr]);
819     }
820 
821     bytes32 hash = sha256(addr);
822     if (ecrecover(hash, v, r, s) != signerAddress) throw;
823     if(customerId == 0) throw;  // UUIDv4 sanity check
824     investInternal(addr, customerId);
825   }
826 
827   /**
828    * Track who is the customer making the payment so we can send thank you email.
829    */
830   function investWithCustomerId(address addr, uint128 customerId) public payable {
831     if(requireWhitelistedAddress) {
832       require(whitelist[addr]);
833     }
834 
835     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
836     if(customerId == 0) throw;  // UUIDv4 sanity check
837     investInternal(addr, customerId);
838   }
839 
840   /**
841    * Allow anonymous contributions to this crowdsale.
842    */
843   function invest(address addr) public payable {
844     if(requireWhitelistedAddress) {
845       require(whitelist[addr]);
846     }
847 
848     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
849     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
850     investInternal(addr, 0);
851   }
852 
853   /**
854    * Invest to tokens, recognize the payer and clear his address.
855    *
856    */
857   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
858     investWithSignedAddress(msg.sender, customerId, v, r, s);
859   }
860 
861   /**
862    * Invest to tokens, recognize the payer.
863    *
864    */
865   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
866     // see customerid.py
867     if (bytes1(sha3(customerId)) != checksum) throw;
868     investWithCustomerId(msg.sender, customerId);
869   }
870 
871   /**
872    * Legacy API signature.
873    */
874   function buyWithCustomerId(uint128 customerId) public payable {
875     investWithCustomerId(msg.sender, customerId);
876   }
877 
878   /**
879    * The basic entry point to participate the crowdsale process.
880    *
881    * Pay for funding, get invested tokens back in the sender address.
882    */
883   function buy() public payable {
884     invest(msg.sender);
885   }
886 
887 
888   /*
889    * Allow sending ETH directyl to the contract
890    *
891    */
892   function () public payable {
893     buy();
894   }
895 
896 
897   /**
898    * Set policy do we need to have server-side customer ids for the investments.
899    *
900    */
901   function setRequireCustomerId(bool value) onlyOwner {
902     requireCustomerId = value;
903     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, requireWhitelistedAddress, signerAddress, whitelisterAddress);
904   }
905 
906   /**
907    * Set policy if all investors must be cleared on the server side first.
908    *
909    * This is e.g. for the accredited investor clearing.
910    *
911    */
912   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
913     requiredSignedAddress = value;
914     signerAddress = _signerAddress;
915     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, requireWhitelistedAddress, signerAddress, whitelisterAddress);
916   }
917 
918   /**
919    * Set policy do we need to work only with whitelisted accounts.
920    *
921    */
922   function setRequireWhitelistedAddress(bool value, address _whitelistAddress) onlyOwner {
923     requireWhitelistedAddress = value;
924     whitelisterAddress = _whitelistAddress;
925     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, requireWhitelistedAddress, signerAddress, whitelisterAddress);
926   }
927 
928   /*
929    * Add KYC'ed addresses to the whitelist
930    */
931   function addToWhitelist(address[] _addresses) public onlyWhitelister {
932      for (uint32 i = 0; i < _addresses.length; i++) {
933          whitelist[_addresses[i]] = true;
934      }
935   }
936 
937   function removeFromWhitelist(address[] _addresses) public onlyWhitelister {
938     for (uint32 i = 0; i < _addresses.length; i++) {
939         whitelist[_addresses[i]] = false;
940     }
941   }
942 
943   function isWhitelistedAddress(address _address) public constant returns(bool whitelisted) {
944     return whitelist[_address];
945   }
946 
947   modifier onlyWhitelister() {
948     require(msg.sender == whitelisterAddress);
949     _;
950   }
951 
952 }
953 
954 // File: contracts/MilestonePricing.sol
955 
956 /**
957  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
958  *
959  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
960  */
961 
962 pragma solidity ^0.4.6;
963 
964 
965 
966 
967 
968 
969 
970 /// @dev Time milestone based pricing with special support for pre-ico deals.
971 contract MilestonePricing is PricingStrategy, Ownable {
972 
973   using SafeMathLib for uint;
974 
975   uint public constant MAX_MILESTONE = 10;
976 
977   // This contains all pre-ICO addresses, and their prices (weis per token)
978   mapping (address => uint) public preicoAddresses;
979 
980   /**
981   * Define pricing schedule using milestones.
982   */
983   struct Milestone {
984 
985       // UNIX timestamp when this milestone kicks in
986       uint time;
987 
988       // How many tokens per satoshi you will get after this milestone has been passed
989       uint price;
990   }
991 
992   // Store milestones in a fixed array, so that it can be seen in a blockchain explorer
993   // Milestone 0 is always (0, 0)
994   // (TODO: change this when we confirm dynamic arrays are explorable)
995   Milestone[10] public milestones;
996 
997   // How many active milestones we have
998   uint public milestoneCount;
999 
1000   /// @dev Contruction, creating a list of milestones
1001   /// @param _milestones uint[] milestones Pairs of (time, price)
1002   function MilestonePricing(uint[] _milestones) {
1003     // Need to have tuples, length check
1004     if(_milestones.length % 2 == 1 || _milestones.length >= MAX_MILESTONE*2) {
1005       throw;
1006     }
1007 
1008     milestoneCount = _milestones.length / 2;
1009 
1010     uint lastTimestamp = 0;
1011 
1012     for(uint i=0; i<_milestones.length/2; i++) {
1013       milestones[i].time = _milestones[i*2];
1014       milestones[i].price = _milestones[i*2+1];
1015 
1016       // No invalid steps
1017       if((lastTimestamp != 0) && (milestones[i].time <= lastTimestamp)) {
1018         throw;
1019       }
1020 
1021       lastTimestamp = milestones[i].time;
1022     }
1023 
1024     // Last milestone price must be zero, terminating the crowdale
1025     if(milestones[milestoneCount-1].price != 0) {
1026       throw;
1027     }
1028   }
1029 
1030   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1031   ///      to 0 to disable
1032   /// @param preicoAddress PresaleFundCollector address
1033   /// @param pricePerToken How many weis one token cost for pre-ico investors
1034   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1035     public
1036     onlyOwner
1037   {
1038     preicoAddresses[preicoAddress] = pricePerToken;
1039   }
1040 
1041   /// @dev Iterate through milestones. You reach end of milestones when price = 0
1042   /// @return tuple (time, price)
1043   function getMilestone(uint n) public constant returns (uint, uint) {
1044     return (milestones[n].time, milestones[n].price);
1045   }
1046 
1047   function getFirstMilestone() private constant returns (Milestone) {
1048     return milestones[0];
1049   }
1050 
1051   function getLastMilestone() private constant returns (Milestone) {
1052     return milestones[milestoneCount-1];
1053   }
1054 
1055   function getPricingStartsAt() public constant returns (uint) {
1056     return getFirstMilestone().time;
1057   }
1058 
1059   function getPricingEndsAt() public constant returns (uint) {
1060     return getLastMilestone().time;
1061   }
1062 
1063   function isSane(address _crowdsale) public constant returns(bool) {
1064     Crowdsale crowdsale = Crowdsale(_crowdsale);
1065     return crowdsale.startsAt() == getPricingStartsAt() && crowdsale.endsAt() == getPricingEndsAt();
1066   }
1067 
1068   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
1069   /// @return {[type]} [description]
1070   function getCurrentMilestone() private constant returns (Milestone) {
1071     uint i;
1072 
1073     for(i=0; i<milestones.length; i++) {
1074       if(now < milestones[i].time) {
1075         return milestones[i-1];
1076       }
1077     }
1078   }
1079 
1080   /// @dev Get the current price.
1081   /// @return The current price or 0 if we are outside milestone period
1082   function getCurrentPrice() public constant returns (uint result) {
1083     return getCurrentMilestone().price;
1084   }
1085 
1086   /// @dev Calculate the current price for buy in amount.
1087   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1088 
1089     uint multiplier = 10 ** decimals;
1090 
1091     // This investor is coming through pre-ico
1092     if(preicoAddresses[msgSender] > 0) {
1093       return value.times(multiplier) / preicoAddresses[msgSender];
1094     }
1095 
1096     uint price = getCurrentPrice();
1097     return value.times(multiplier) / price;
1098   }
1099 
1100   function isPresalePurchase(address purchaser) public constant returns (bool) {
1101     if(preicoAddresses[purchaser] > 0)
1102       return true;
1103     else
1104       return false;
1105   }
1106 
1107   function() payable {
1108     throw; // No money on this contract
1109   }
1110 
1111 }