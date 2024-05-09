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
16  * Interface for defining crowdsale pricing.
17  */
18 contract PricingStrategy {
19 
20   /** Interface declaration. */
21   function isPricingStrategy() public constant returns (bool) {
22     return true;
23   }
24 
25   /** Self check if all references are correctly set.
26    *
27    * Checks that pricing strategy matches crowdsale parameters.
28    */
29   function isSane(address crowdsale) public constant returns (bool) {
30     return true;
31   }
32 
33   /**
34    * @dev Pricing tells if this is a presale purchase or not.
35      @param purchaser Address of the purchaser
36      @return False by default, true if a presale purchaser
37    */
38   function isPresalePurchase(address purchaser) public constant returns (bool) {
39     return false;
40   }
41 
42   /**
43    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
44    *
45    *
46    * @param value - What is the value of the transaction send in as wei
47    * @param tokensSold - how much tokens have been sold this far
48    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
49    * @param msgSender - who is the investor of this transaction
50    * @param decimals - how many decimal units the token has
51    * @return Amount of tokens the investor receives
52    */
53   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
54 }
55 
56 /**
57  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
58  *
59  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
60  */
61 
62 
63 /**
64  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
65  *
66  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
67  */
68 
69 
70 /**
71  * Safe unsigned safe math.
72  *
73  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
74  *
75  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
76  *
77  * Maintained here until merged to mainline zeppelin-solidity.
78  *
79  */
80 library SafeMathLib {
81 
82   function times(uint a, uint b) returns (uint) {
83     uint c = a * b;
84     assert(a == 0 || c / a == b);
85     return c;
86   }
87 
88   function minus(uint a, uint b) returns (uint) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function plus(uint a, uint b) returns (uint) {
94     uint c = a + b;
95     assert(c>=a);
96     return c;
97   }
98 
99 }
100 
101 
102 /**
103  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
104  *
105  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
106  */
107 
108 
109 /**
110  * Finalize agent defines what happens at the end of succeseful crowdsale.
111  *
112  * - Allocate tokens for founders, bounties and community
113  * - Make tokens transferable
114  * - etc.
115  */
116 contract FinalizeAgent {
117 
118   function isFinalizeAgent() public constant returns(bool) {
119     return true;
120   }
121 
122   /** Return true if we can run finalizeCrowdsale() properly.
123    *
124    * This is a safety check function that doesn't allow crowdsale to begin
125    * unless the finalizer has been set up properly.
126    */
127   function isSane() public constant returns (bool);
128 
129   /** Called once by crowdsale finalize() if the sale was success. */
130   function finalizeCrowdsale();
131 
132 }
133 
134 /**
135  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
136  *
137  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
138  */
139 
140 
141 
142 
143 
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/179
149  */
150 contract ERC20Basic {
151   uint256 public totalSupply;
152   function balanceOf(address who) constant returns (uint256);
153   function transfer(address to, uint256 value) returns (bool);
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164   function allowance(address owner, address spender) constant returns (uint256);
165   function transferFrom(address from, address to, uint256 value) returns (bool);
166   function approve(address spender, uint256 value) returns (bool);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 
171 /**
172  * A token that defines fractional units as decimals.
173  */
174 contract FractionalERC20 is ERC20 {
175 
176   uint public decimals;
177 
178 }
179 
180 /**
181  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
182  *
183  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
184  */
185 
186 
187 /**
188  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
189  *
190  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
191  */
192 
193 
194 
195 
196 /**
197  * @title Ownable
198  * @dev The Ownable contract has an owner address, and provides basic authorization control
199  * functions, this simplifies the implementation of "user permissions".
200  */
201 contract Ownable {
202   address public owner;
203 
204 
205   /**
206    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
207    * account.
208    */
209   function Ownable() {
210     owner = msg.sender;
211   }
212 
213 
214   /**
215    * @dev Throws if called by any account other than the owner.
216    */
217   modifier onlyOwner() {
218     require(msg.sender == owner);
219     _;
220   }
221 
222 
223   /**
224    * @dev Allows the current owner to transfer control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227   function transferOwnership(address newOwner) onlyOwner {
228     require(newOwner != address(0));      
229     owner = newOwner;
230   }
231 
232 }
233 
234 
235 /*
236  * Haltable
237  *
238  * Abstract contract that allows children to implement an
239  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
240  *
241  *
242  * Originally envisioned in FirstBlood ICO contract.
243  */
244 contract Haltable is Ownable {
245   bool public halted;
246 
247   modifier stopInEmergency {
248     if (halted) throw;
249     _;
250   }
251 
252   modifier stopNonOwnersInEmergency {
253     if (halted && msg.sender != owner) throw;
254     _;
255   }
256 
257   modifier onlyInEmergency {
258     if (!halted) throw;
259     _;
260   }
261 
262   // called by the owner on emergency, triggers stopped state
263   function halt() external onlyOwner {
264     halted = true;
265   }
266 
267   // called by the owner on end of emergency, returns to normal state
268   function unhalt() external onlyOwner onlyInEmergency {
269     halted = false;
270   }
271 
272 }
273 
274 
275 
276 
277 
278 
279 
280 /**
281  * Crowdsale state machine without buy functionality.
282  *
283  * Implements basic state machine logic, but leaves out all buy functions,
284  * so that subclasses can implement their own buying logic.
285  *
286  *
287  * For the default buy() implementation see Crowdsale.sol.
288  */
289 contract CrowdsaleBase is Haltable {
290 
291   /* Max investment count when we are still allowed to change the multisig address */
292   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
293 
294   using SafeMathLib for uint;
295 
296   /* The token we are selling */
297   FractionalERC20 public token;
298 
299   /* How we are going to price our offering */
300   PricingStrategy public pricingStrategy;
301 
302   /* Post-success callback */
303   FinalizeAgent public finalizeAgent;
304 
305   /* tokens will be transfered from this address */
306   address public multisigWallet;
307 
308   /* if the funding goal is not reached, investors may withdraw their funds */
309   uint public minimumFundingGoal;
310 
311   /* the UNIX timestamp start date of the crowdsale */
312   uint public startsAt;
313 
314   /* the UNIX timestamp end date of the crowdsale */
315   uint public endsAt;
316 
317   /* the number of tokens already sold through this contract*/
318   uint public tokensSold = 0;
319 
320   /* How many wei of funding we have raised */
321   uint public weiRaised = 0;
322 
323   /* Calculate incoming funds from presale contracts and addresses */
324   uint public presaleWeiRaised = 0;
325 
326   /* How many distinct addresses have invested */
327   uint public investorCount = 0;
328 
329   /* How much wei we have returned back to the contract after a failed crowdfund. */
330   uint public loadedRefund = 0;
331 
332   /* How much wei we have given back to investors.*/
333   uint public weiRefunded = 0;
334 
335   /* Has this crowdsale been finalized */
336   bool public finalized;
337 
338   /** How much ETH each address has invested to this crowdsale */
339   mapping (address => uint256) public investedAmountOf;
340 
341   /** How much tokens this crowdsale has credited for each investor address */
342   mapping (address => uint256) public tokenAmountOf;
343 
344   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
345   mapping (address => bool) public earlyParticipantWhitelist;
346 
347   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
348   uint public ownerTestValue;
349 
350   /** State machine
351    *
352    * - Preparing: All contract initialization calls and variables have not been set yet
353    * - Prefunding: We have not passed start time yet
354    * - Funding: Active crowdsale
355    * - Success: Minimum funding goal reached
356    * - Failure: Minimum funding goal not reached before ending time
357    * - Finalized: The finalized has been called and succesfully executed
358    * - Refunding: Refunds are loaded on the contract for reclaim.
359    */
360   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
361 
362   // A new investment was made
363   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
364 
365   // Refund was processed for a contributor
366   event Refund(address investor, uint weiAmount);
367 
368   // The rules were changed what kind of investments we accept
369   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
370 
371   // Address early participation whitelist status changed
372   event Whitelisted(address addr, bool status);
373 
374   // Crowdsale end time has been changed
375   event EndsAtChanged(uint newEndsAt);
376 
377   State public testState;
378 
379   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
380 
381     owner = msg.sender;
382 
383     token = FractionalERC20(_token);
384 
385     setPricingStrategy(_pricingStrategy);
386 
387     multisigWallet = _multisigWallet;
388     if(multisigWallet == 0) {
389         throw;
390     }
391 
392     if(_start == 0) {
393         throw;
394     }
395 
396     startsAt = _start;
397 
398     if(_end == 0) {
399         throw;
400     }
401 
402     endsAt = _end;
403 
404     // Don't mess the dates
405     if(startsAt >= endsAt) {
406         throw;
407     }
408 
409     // Minimum funding goal can be zero
410     minimumFundingGoal = _minimumFundingGoal;
411   }
412 
413   /**
414    * Don't expect to just send in money and get tokens.
415    */
416   function() payable {
417     throw;
418   }
419 
420   /**
421    * Make an investment.
422    *
423    * Crowdsale must be running for one to invest.
424    * We must have not pressed the emergency brake.
425    *
426    * @param receiver The Ethereum address who receives the tokens
427    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
428    *
429    * @return tokenAmount How mony tokens were bought
430    */
431   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
432 
433     // Determine if it's a good time to accept investment from this participant
434     if(getState() == State.PreFunding) {
435       // Are we whitelisted for early deposit
436       if(!earlyParticipantWhitelist[receiver]) {
437         throw;
438       }
439     } else if(getState() == State.Funding) {
440       // Retail participants can only come in when the crowdsale is running
441       // pass
442     } else {
443       // Unwanted state
444       throw;
445     }
446 
447     uint weiAmount = msg.value;
448 
449     // Account presale sales separately, so that they do not count against pricing tranches
450     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
451 
452     // Dust transaction
453     require(tokenAmount != 0);
454 
455     if(investedAmountOf[receiver] == 0) {
456        // A new investor
457        investorCount++;
458     }
459 
460     // Update investor
461     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
462     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
463 
464     // Update totals
465     weiRaised = weiRaised.plus(weiAmount);
466     tokensSold = tokensSold.plus(tokenAmount);
467 
468     if(pricingStrategy.isPresalePurchase(receiver)) {
469         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
470     }
471 
472     // Check that we did not bust the cap
473     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
474 
475     assignTokens(receiver, tokenAmount);
476 
477     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
478     if(!multisigWallet.send(weiAmount)) throw;
479 
480     // Tell us invest was success
481     Invested(receiver, weiAmount, tokenAmount, customerId);
482 
483     return tokenAmount;
484   }
485 
486   /**
487    * Finalize a succcesful crowdsale.
488    *
489    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
490    */
491   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
492 
493     // Already finalized
494     if(finalized) {
495       throw;
496     }
497 
498     // Finalizing is optional. We only call it if we are given a finalizing agent.
499     if(address(finalizeAgent) != 0) {
500       finalizeAgent.finalizeCrowdsale();
501     }
502 
503     finalized = true;
504   }
505 
506   /**
507    * Allow to (re)set finalize agent.
508    *
509    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
510    */
511   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
512     finalizeAgent = addr;
513 
514     // Don't allow setting bad agent
515     if(!finalizeAgent.isFinalizeAgent()) {
516       throw;
517     }
518   }
519 
520   /**
521    * Allow crowdsale owner to close early or extend the crowdsale.
522    *
523    * This is useful e.g. for a manual soft cap implementation:
524    * - after X amount is reached determine manual closing
525    *
526    * This may put the crowdsale to an invalid state,
527    * but we trust owners know what they are doing.
528    *
529    */
530   function setEndsAt(uint time) onlyOwner {
531 
532     if(now > time) {
533       throw; // Don't change past
534     }
535 
536     if(startsAt > time) {
537       throw; // Prevent human mistakes
538     }
539 
540     endsAt = time;
541     EndsAtChanged(endsAt);
542   }
543 
544   /**
545    * Allow to (re)set pricing strategy.
546    *
547    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
548    */
549   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
550     pricingStrategy = _pricingStrategy;
551 
552     // Don't allow setting bad agent
553     if(!pricingStrategy.isPricingStrategy()) {
554       throw;
555     }
556   }
557 
558   /**
559    * Allow to change the team multisig address in the case of emergency.
560    *
561    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
562    * (we have done only few test transactions). After the crowdsale is going
563    * then multisig address stays locked for the safety reasons.
564    */
565   function setMultisig(address addr) public onlyOwner {
566 
567     // Change
568     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
569       throw;
570     }
571 
572     multisigWallet = addr;
573   }
574 
575   /**
576    * Allow load refunds back on the contract for the refunding.
577    *
578    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
579    */
580   function loadRefund() public payable inState(State.Failure) {
581     if(msg.value == 0) throw;
582     loadedRefund = loadedRefund.plus(msg.value);
583   }
584 
585   /**
586    * Investors can claim refund.
587    *
588    * Note that any refunds from proxy buyers should be handled separately,
589    * and not through this contract.
590    */
591   function refund() public inState(State.Refunding) {
592     uint256 weiValue = investedAmountOf[msg.sender];
593     if (weiValue == 0) throw;
594     investedAmountOf[msg.sender] = 0;
595     weiRefunded = weiRefunded.plus(weiValue);
596     Refund(msg.sender, weiValue);
597     if (!msg.sender.send(weiValue)) throw;
598   }
599 
600   /**
601    * @return true if the crowdsale has raised enough money to be a successful.
602    */
603   function isMinimumGoalReached() public constant returns (bool reached) {
604     return weiRaised >= minimumFundingGoal;
605   }
606 
607   /**
608    * Check if the contract relationship looks good.
609    */
610   function isFinalizerSane() public constant returns (bool sane) {
611     return finalizeAgent.isSane();
612   }
613 
614   /**
615    * Check if the contract relationship looks good.
616    */
617   function isPricingSane() public constant returns (bool sane) {
618     return pricingStrategy.isSane(address(this));
619   }
620 
621   /**
622    * Crowdfund state machine management.
623    *
624    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
625    */
626   function getState() public constant returns (State) {
627     if(finalized) return State.Finalized;
628     else if (address(finalizeAgent) == 0) return State.Preparing;
629     else if (!finalizeAgent.isSane()) return State.Preparing;
630     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
631     else if (block.timestamp < startsAt) return State.PreFunding;
632     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
633     else if (isMinimumGoalReached()) return State.Success;
634     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
635     else return State.Failure;
636   }
637 
638   /** This is for manual testing of multisig wallet interaction */
639   function setOwnerTestValue(uint val) onlyOwner {
640     ownerTestValue = val;
641   }
642 
643   /**
644    * Allow addresses to do early participation.
645    *
646    * TODO: Fix spelling error in the name
647    */
648   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
649     earlyParticipantWhitelist[addr] = status;
650     Whitelisted(addr, status);
651   }
652 
653 
654   /** Interface marker. */
655   function isCrowdsale() public constant returns (bool) {
656     return true;
657   }
658 
659   //
660   // Modifiers
661   //
662 
663   /** Modified allowing execution only if the crowdsale is currently running.  */
664   modifier inState(State state) {
665     if(getState() != state) throw;
666     _;
667   }
668 
669 
670   //
671   // Abstract functions
672   //
673 
674   /**
675    * Check if the current invested breaks our cap rules.
676    *
677    *
678    * The child contract must define their own cap setting rules.
679    * We allow a lot of flexibility through different capping strategies (ETH, token count)
680    * Called from invest().
681    *
682    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
683    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
684    * @param weiRaisedTotal What would be our total raised balance after this transaction
685    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
686    *
687    * @return true if taking this investment would break our cap rules
688    */
689   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
690 
691   /**
692    * Check if the current crowdsale is full and we can no longer sell any tokens.
693    */
694   function isCrowdsaleFull() public constant returns (bool);
695 
696   /**
697    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
698    */
699   function assignTokens(address receiver, uint tokenAmount) internal;
700 }
701 
702 
703 
704 /**
705  * Abstract base contract for token sales with the default buy entry points.
706  *
707  * Handle
708  * - start and end dates
709  * - accepting investments
710  * - minimum funding goal and refund
711  * - various statistics during the crowdfund
712  * - different pricing strategies
713  * - different investment policies (require server side customer id, allow only whitelisted addresses)
714  *
715  * Does not Handle
716  *
717  * - Token allocation (minting vs. transfer)
718  * - Cap rules
719  *
720  */
721 contract Crowdsale is CrowdsaleBase {
722 
723   /* Do we need to have unique contributor id for each customer */
724   bool public requireCustomerId;
725 
726   /**
727     * Do we verify that contributor has been cleared on the server side (accredited investors only).
728     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
729     */
730   bool public requiredSignedAddress;
731 
732   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
733   address public signerAddress;
734 
735   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
736   }
737 
738   /**
739    * Preallocate tokens for the early investors.
740    *
741    * Preallocated tokens have been sold before the actual crowdsale opens.
742    * This function mints the tokens and moves the crowdsale needle.
743    *
744    * Investor count is not handled; it is assumed this goes for multiple investors
745    * and the token distribution happens outside the smart contract flow.
746    *
747    * No money is exchanged, as the crowdsale team already have received the payment.
748    *
749    * @param fullTokens tokens as full tokens - decimal places added internally
750    * @param weiPrice Price of a single full token in wei
751    *
752    */
753   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
754 
755     uint tokenAmount = fullTokens * 10**token.decimals();
756     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
757 
758     weiRaised = weiRaised.plus(weiAmount);
759     tokensSold = tokensSold.plus(tokenAmount);
760 
761     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
762     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
763 
764     assignTokens(receiver, tokenAmount);
765 
766     // Tell us invest was success
767     Invested(receiver, weiAmount, tokenAmount, 0);
768   }
769 
770   /**
771    * Allow anonymous contributions to this crowdsale.
772    */
773   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
774      bytes32 hash = sha256(addr);
775      if (ecrecover(hash, v, r, s) != signerAddress) throw;
776      if(customerId == 0) throw;  // UUIDv4 sanity check
777      investInternal(addr, customerId);
778   }
779 
780   /**
781    * Track who is the customer making the payment so we can send thank you email.
782    */
783   function investWithCustomerId(address addr, uint128 customerId) public payable {
784     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
785     if(customerId == 0) throw;  // UUIDv4 sanity check
786     investInternal(addr, customerId);
787   }
788 
789   /**
790    * Allow anonymous contributions to this crowdsale.
791    */
792   function invest(address addr) public payable {
793     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
794     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
795     investInternal(addr, 0);
796   }
797 
798   /**
799    * Invest to tokens, recognize the payer and clear his address.
800    *
801    */
802   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
803     investWithSignedAddress(msg.sender, customerId, v, r, s);
804   }
805 
806   /**
807    * Invest to tokens, recognize the payer.
808    *
809    */
810   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
811     // see customerid.py
812     if (bytes1(sha3(customerId)) != checksum) throw;
813     investWithCustomerId(msg.sender, customerId);
814   }
815 
816   /**
817    * Legacy API signature.
818    */
819   function buyWithCustomerId(uint128 customerId) public payable {
820     investWithCustomerId(msg.sender, customerId);
821   }
822 
823   /**
824    * The basic entry point to participate the crowdsale process.
825    *
826    * Pay for funding, get invested tokens back in the sender address.
827    */
828   function buy() public payable {
829     invest(msg.sender);
830   }
831 
832   /**
833    * Set policy do we need to have server-side customer ids for the investments.
834    *
835    */
836   function setRequireCustomerId(bool value) onlyOwner {
837     requireCustomerId = value;
838     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
839   }
840 
841   /**
842    * Set policy if all investors must be cleared on the server side first.
843    *
844    * This is e.g. for the accredited investor clearing.
845    *
846    */
847   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
848     requiredSignedAddress = value;
849     signerAddress = _signerAddress;
850     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
851   }
852 
853 }
854 
855 
856 
857 
858 
859 /// @dev Time milestone based pricing with special support for pre-ico deals.
860 contract MilestonePricing is PricingStrategy, Ownable {
861 
862   using SafeMathLib for uint;
863 
864   uint public constant MAX_MILESTONE = 10;
865 
866   // This contains all pre-ICO addresses, and their prices (weis per token)
867   mapping (address => uint) public preicoAddresses;
868 
869   /**
870   * Define pricing schedule using milestones.
871   */
872   struct Milestone {
873 
874       // UNIX timestamp when this milestone kicks in
875       uint time;
876 
877       // How many tokens per satoshi you will get after this milestone has been passed
878       uint price;
879   }
880 
881   // Store milestones in a fixed array, so that it can be seen in a blockchain explorer
882   // Milestone 0 is always (0, 0)
883   // (TODO: change this when we confirm dynamic arrays are explorable)
884   Milestone[10] public milestones;
885 
886   // How many active milestones we have
887   uint public milestoneCount;
888 
889   /// @dev Contruction, creating a list of milestones
890   /// @param _milestones uint[] milestones Pairs of (time, price)
891   function MilestonePricing(uint[] _milestones) {
892     // Need to have tuples, length check
893     if(_milestones.length % 2 == 1 || _milestones.length >= MAX_MILESTONE*2) {
894       throw;
895     }
896 
897     milestoneCount = _milestones.length / 2;
898 
899     uint lastTimestamp = 0;
900 
901     for(uint i=0; i<_milestones.length/2; i++) {
902       milestones[i].time = _milestones[i*2];
903       milestones[i].price = _milestones[i*2+1];
904 
905       // No invalid steps
906       if((lastTimestamp != 0) && (milestones[i].time <= lastTimestamp)) {
907         throw;
908       }
909 
910       lastTimestamp = milestones[i].time;
911     }
912 
913     // Last milestone price must be zero, terminating the crowdale
914     if(milestones[milestoneCount-1].price != 0) {
915       throw;
916     }
917   }
918 
919   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
920   ///      to 0 to disable
921   /// @param preicoAddress PresaleFundCollector address
922   /// @param pricePerToken How many weis one token cost for pre-ico investors
923   function setPreicoAddress(address preicoAddress, uint pricePerToken)
924     public
925     onlyOwner
926   {
927     preicoAddresses[preicoAddress] = pricePerToken;
928   }
929 
930   /// @dev Iterate through milestones. You reach end of milestones when price = 0
931   /// @return tuple (time, price)
932   function getMilestone(uint n) public constant returns (uint, uint) {
933     return (milestones[n].time, milestones[n].price);
934   }
935 
936   function getFirstMilestone() private constant returns (Milestone) {
937     return milestones[0];
938   }
939 
940   function getLastMilestone() private constant returns (Milestone) {
941     return milestones[milestoneCount-1];
942   }
943 
944   function getPricingStartsAt() public constant returns (uint) {
945     return getFirstMilestone().time;
946   }
947 
948   function getPricingEndsAt() public constant returns (uint) {
949     return getLastMilestone().time;
950   }
951 
952   function isSane(address _crowdsale) public constant returns(bool) {
953     Crowdsale crowdsale = Crowdsale(_crowdsale);
954     return crowdsale.startsAt() == getPricingStartsAt() && crowdsale.endsAt() == getPricingEndsAt();
955   }
956 
957   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
958   /// @return {[type]} [description]
959   function getCurrentMilestone() private constant returns (Milestone) {
960     uint i;
961 
962     for(i=0; i<milestones.length; i++) {
963       if(now < milestones[i].time) {
964         return milestones[i-1];
965       }
966     }
967   }
968 
969   /// @dev Get the current price.
970   /// @return The current price or 0 if we are outside milestone period
971   function getCurrentPrice() public constant returns (uint result) {
972     return getCurrentMilestone().price;
973   }
974 
975   /// @dev Calculate the current price for buy in amount.
976   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
977 
978     uint multiplier = 10 ** decimals;
979 
980     // This investor is coming through pre-ico
981     if(preicoAddresses[msgSender] > 0) {
982       return value.times(multiplier) / preicoAddresses[msgSender];
983     }
984 
985     uint price = getCurrentPrice();
986     return value.times(multiplier) / price;
987   }
988 
989   function isPresalePurchase(address purchaser) public constant returns (bool) {
990     if(preicoAddresses[purchaser] > 0)
991       return true;
992     else
993       return false;
994   }
995 
996   function() payable {
997     throw; // No money on this contract
998   }
999 
1000 }