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
101 /**
102  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
103  *
104  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
105  */
106 
107 
108 
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116   address public owner;
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   function Ownable() {
124     owner = msg.sender;
125   }
126 
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address newOwner) onlyOwner {
142     require(newOwner != address(0));      
143     owner = newOwner;
144   }
145 
146 }
147 
148 
149 /*
150  * Haltable
151  *
152  * Abstract contract that allows children to implement an
153  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
154  *
155  *
156  * Originally envisioned in FirstBlood ICO contract.
157  */
158 contract Haltable is Ownable {
159   bool public halted;
160 
161   modifier stopInEmergency {
162     if (halted) throw;
163     _;
164   }
165 
166   modifier onlyInEmergency {
167     if (!halted) throw;
168     _;
169   }
170 
171   // called by the owner on emergency, triggers stopped state
172   function halt() external onlyOwner {
173     halted = true;
174   }
175 
176   // called by the owner on end of emergency, returns to normal state
177   function unhalt() external onlyOwner onlyInEmergency {
178     halted = false;
179   }
180 
181 }
182 
183 
184 /**
185  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
186  *
187  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
188  */
189 
190 
191 /**
192  * Finalize agent defines what happens at the end of succeseful crowdsale.
193  *
194  * - Allocate tokens for founders, bounties and community
195  * - Make tokens transferable
196  * - etc.
197  */
198 contract FinalizeAgent {
199 
200   function isFinalizeAgent() public constant returns(bool) {
201     return true;
202   }
203 
204   /** Return true if we can run finalizeCrowdsale() properly.
205    *
206    * This is a safety check function that doesn't allow crowdsale to begin
207    * unless the finalizer has been set up properly.
208    */
209   function isSane() public constant returns (bool);
210 
211   /** Called once by crowdsale finalize() if the sale was success. */
212   function finalizeCrowdsale();
213 
214 }
215 
216 /**
217  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
218  *
219  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
220  */
221 
222 
223 
224 
225 
226 
227 /**
228  * @title ERC20Basic
229  * @dev Simpler version of ERC20 interface
230  * @dev see https://github.com/ethereum/EIPs/issues/179
231  */
232 contract ERC20Basic {
233   uint256 public totalSupply;
234   function balanceOf(address who) constant returns (uint256);
235   function transfer(address to, uint256 value) returns (bool);
236   event Transfer(address indexed from, address indexed to, uint256 value);
237 }
238 
239 
240 
241 /**
242  * @title ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/20
244  */
245 contract ERC20 is ERC20Basic {
246   function allowance(address owner, address spender) constant returns (uint256);
247   function transferFrom(address from, address to, uint256 value) returns (bool);
248   function approve(address spender, uint256 value) returns (bool);
249   event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 
253 /**
254  * A token that defines fractional units as decimals.
255  */
256 contract FractionalERC20 is ERC20 {
257 
258   uint public decimals;
259 
260 }
261 
262 
263 
264 /**
265  * Abstract base contract for token sales.
266  *
267  * Handle
268  * - start and end dates
269  * - accepting investments
270  * - minimum funding goal and refund
271  * - various statistics during the crowdfund
272  * - different pricing strategies
273  * - different investment policies (require server side customer id, allow only whitelisted addresses)
274  *
275  */
276 contract Crowdsale is Haltable {
277 
278   /* Max investment count when we are still allowed to change the multisig address */
279   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
280 
281   using SafeMathLib for uint;
282 
283   /* The token we are selling */
284   FractionalERC20 public token;
285 
286   /* How we are going to price our offering */
287   PricingStrategy public pricingStrategy;
288 
289   /* Post-success callback */
290   FinalizeAgent public finalizeAgent;
291 
292   /* tokens will be transfered from this address */
293   address public multisigWallet;
294 
295   /* if the funding goal is not reached, investors may withdraw their funds */
296   uint public minimumFundingGoal;
297 
298   /* the UNIX timestamp start date of the crowdsale */
299   uint public startsAt;
300 
301   /* the UNIX timestamp end date of the crowdsale */
302   uint public endsAt;
303 
304   /* the number of tokens already sold through this contract*/
305   uint public tokensSold = 0;
306 
307   /* How many wei of funding we have raised */
308   uint public weiRaised = 0;
309 
310   /* Calculate incoming funds from presale contracts and addresses */
311   uint public presaleWeiRaised = 0;
312 
313   /* How many distinct addresses have invested */
314   uint public investorCount = 0;
315 
316   /* How much wei we have returned back to the contract after a failed crowdfund. */
317   uint public loadedRefund = 0;
318 
319   /* How much wei we have given back to investors.*/
320   uint public weiRefunded = 0;
321 
322   /* Has this crowdsale been finalized */
323   bool public finalized;
324 
325   /* Do we need to have unique contributor id for each customer */
326   bool public requireCustomerId;
327 
328   /**
329     * Do we verify that contributor has been cleared on the server side (accredited investors only).
330     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
331     */
332   bool public requiredSignedAddress;
333 
334   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
335   address public signerAddress;
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
376   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
377 
378     owner = msg.sender;
379 
380     token = FractionalERC20(_token);
381 
382     setPricingStrategy(_pricingStrategy);
383 
384     multisigWallet = _multisigWallet;
385     if(multisigWallet == 0) {
386         throw;
387     }
388 
389     if(_start == 0) {
390         throw;
391     }
392 
393     startsAt = _start;
394 
395     if(_end == 0) {
396         throw;
397     }
398 
399     endsAt = _end;
400 
401     // Don't mess the dates
402     if(startsAt >= endsAt) {
403         throw;
404     }
405 
406     // Minimum funding goal can be zero
407     minimumFundingGoal = _minimumFundingGoal;
408   }
409 
410   /**
411    * Don't expect to just send in money and get tokens.
412    */
413   function() payable {
414     throw;
415   }
416 
417   /**
418    * Make an investment.
419    *
420    * Crowdsale must be running for one to invest.
421    * We must have not pressed the emergency brake.
422    *
423    * @param receiver The Ethereum address who receives the tokens
424    * @param customerId (optional) UUID v4 to track the successful payments on the server side
425    *
426    */
427   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
428 
429     // Determine if it's a good time to accept investment from this participant
430     if(getState() == State.PreFunding) {
431       // Are we whitelisted for early deposit
432       if(!earlyParticipantWhitelist[receiver]) {
433         throw;
434       }
435     } else if(getState() == State.Funding) {
436       // Retail participants can only come in when the crowdsale is running
437       // pass
438     } else {
439       // Unwanted state
440       throw;
441     }
442 
443     uint weiAmount = msg.value;
444 
445     // Account presale sales separately, so that they do not count against pricing tranches
446     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
447 
448     if(tokenAmount == 0) {
449       // Dust transaction
450       throw;
451     }
452 
453     if(investedAmountOf[receiver] == 0) {
454        // A new investor
455        investorCount++;
456     }
457 
458     // Update investor
459     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
460     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
461 
462     // Update totals
463     weiRaised = weiRaised.plus(weiAmount);
464     tokensSold = tokensSold.plus(tokenAmount);
465 
466     if(pricingStrategy.isPresalePurchase(receiver)) {
467         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
468     }
469 
470     // Check that we did not bust the cap
471     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
472       throw;
473     }
474 
475     assignTokens(receiver, tokenAmount);
476 
477     // Pocket the money
478     if(!multisigWallet.send(weiAmount)) throw;
479 
480     // Tell us invest was success
481     Invested(receiver, weiAmount, tokenAmount, customerId);
482   }
483 
484   /**
485    * Preallocate tokens for the early investors.
486    *
487    * Preallocated tokens have been sold before the actual crowdsale opens.
488    * This function mints the tokens and moves the crowdsale needle.
489    *
490    * Investor count is not handled; it is assumed this goes for multiple investors
491    * and the token distribution happens outside the smart contract flow.
492    *
493    * No money is exchanged, as the crowdsale team already have received the payment.
494    *
495    * @param fullTokens tokens as full tokens - decimal places added internally
496    * @param weiPrice Price of a single full token in wei
497    *
498    */
499   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
500 
501     uint tokenAmount = fullTokens * 10**token.decimals();
502     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
503 
504     weiRaised = weiRaised.plus(weiAmount);
505     tokensSold = tokensSold.plus(tokenAmount);
506 
507     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
508     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
509 
510     assignTokens(receiver, tokenAmount);
511 
512     // Tell us invest was success
513     Invested(receiver, weiAmount, tokenAmount, 0);
514   }
515 
516   /**
517    * Allow anonymous contributions to this crowdsale.
518    */
519   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
520      bytes32 hash = sha256(addr);
521      if (ecrecover(hash, v, r, s) != signerAddress) throw;
522      if(customerId == 0) throw;  // UUIDv4 sanity check
523      investInternal(addr, customerId);
524   }
525 
526   /**
527    * Track who is the customer making the payment so we can send thank you email.
528    */
529   function investWithCustomerId(address addr, uint128 customerId) public payable {
530     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
531     if(customerId == 0) throw;  // UUIDv4 sanity check
532     investInternal(addr, customerId);
533   }
534 
535   /**
536    * Allow anonymous contributions to this crowdsale.
537    */
538   function invest(address addr) public payable {
539     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
540     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
541     investInternal(addr, 0);
542   }
543 
544   /**
545    * Invest to tokens, recognize the payer and clear his address.
546    *
547    */
548   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
549     investWithSignedAddress(msg.sender, customerId, v, r, s);
550   }
551 
552   /**
553    * Invest to tokens, recognize the payer.
554    *
555    */
556   function buyWithCustomerId(uint128 customerId) public payable {
557     investWithCustomerId(msg.sender, customerId);
558   }
559 
560   /**
561    * The basic entry point to participate the crowdsale process.
562    *
563    * Pay for funding, get invested tokens back in the sender address.
564    */
565   function buy() public payable {
566     invest(msg.sender);
567   }
568 
569   /**
570    * Finalize a succcesful crowdsale.
571    *
572    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
573    */
574   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
575 
576     // Already finalized
577     if(finalized) {
578       throw;
579     }
580 
581     // Finalizing is optional. We only call it if we are given a finalizing agent.
582     if(address(finalizeAgent) != 0) {
583       finalizeAgent.finalizeCrowdsale();
584     }
585 
586     finalized = true;
587   }
588 
589   /**
590    * Allow to (re)set finalize agent.
591    *
592    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
593    */
594   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
595     finalizeAgent = addr;
596 
597     // Don't allow setting bad agent
598     if(!finalizeAgent.isFinalizeAgent()) {
599       throw;
600     }
601   }
602 
603   /**
604    * Set policy do we need to have server-side customer ids for the investments.
605    *
606    */
607   function setRequireCustomerId(bool value) onlyOwner {
608     requireCustomerId = value;
609     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
610   }
611 
612   /**
613    * Set policy if all investors must be cleared on the server side first.
614    *
615    * This is e.g. for the accredited investor clearing.
616    *
617    */
618   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
619     requiredSignedAddress = value;
620     signerAddress = _signerAddress;
621     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
622   }
623 
624   /**
625    * Allow addresses to do early participation.
626    *
627    * TODO: Fix spelling error in the name
628    */
629   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
630     earlyParticipantWhitelist[addr] = status;
631     Whitelisted(addr, status);
632   }
633 
634   /**
635    * Allow crowdsale owner to close early or extend the crowdsale.
636    *
637    * This is useful e.g. for a manual soft cap implementation:
638    * - after X amount is reached determine manual closing
639    *
640    * This may put the crowdsale to an invalid state,
641    * but we trust owners know what they are doing.
642    *
643    */
644   function setEndsAt(uint time) onlyOwner {
645 
646     if(now > time) {
647       throw; // Don't change past
648     }
649 
650     endsAt = time;
651     EndsAtChanged(endsAt);
652   }
653 
654   /**
655    * Allow to (re)set pricing strategy.
656    *
657    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
658    */
659   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
660     pricingStrategy = _pricingStrategy;
661 
662     // Don't allow setting bad agent
663     if(!pricingStrategy.isPricingStrategy()) {
664       throw;
665     }
666   }
667 
668   /**
669    * Allow to change the team multisig address in the case of emergency.
670    *
671    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
672    * (we have done only few test transactions). After the crowdsale is going
673    * then multisig address stays locked for the safety reasons.
674    */
675   function setMultisig(address addr) public onlyOwner {
676 
677     // Change
678     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
679       throw;
680     }
681 
682     multisigWallet = addr;
683   }
684 
685   /**
686    * Allow load refunds back on the contract for the refunding.
687    *
688    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
689    */
690   function loadRefund() public payable inState(State.Failure) {
691     if(msg.value == 0) throw;
692     loadedRefund = loadedRefund.plus(msg.value);
693   }
694 
695   /**
696    * Investors can claim refund.
697    *
698    * Note that any refunds from proxy buyers should be handled separately,
699    * and not through this contract.
700    */
701   function refund() public inState(State.Refunding) {
702     uint256 weiValue = investedAmountOf[msg.sender];
703     if (weiValue == 0) throw;
704     investedAmountOf[msg.sender] = 0;
705     weiRefunded = weiRefunded.plus(weiValue);
706     Refund(msg.sender, weiValue);
707     if (!msg.sender.send(weiValue)) throw;
708   }
709 
710   /**
711    * @return true if the crowdsale has raised enough money to be a successful.
712    */
713   function isMinimumGoalReached() public constant returns (bool reached) {
714     return weiRaised >= minimumFundingGoal;
715   }
716 
717   /**
718    * Check if the contract relationship looks good.
719    */
720   function isFinalizerSane() public constant returns (bool sane) {
721     return finalizeAgent.isSane();
722   }
723 
724   /**
725    * Check if the contract relationship looks good.
726    */
727   function isPricingSane() public constant returns (bool sane) {
728     return pricingStrategy.isSane(address(this));
729   }
730 
731   /**
732    * Crowdfund state machine management.
733    *
734    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
735    */
736   function getState() public constant returns (State) {
737     if(finalized) return State.Finalized;
738     else if (address(finalizeAgent) == 0) return State.Preparing;
739     else if (!finalizeAgent.isSane()) return State.Preparing;
740     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
741     else if (block.timestamp < startsAt) return State.PreFunding;
742     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
743     else if (isMinimumGoalReached()) return State.Success;
744     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
745     else return State.Failure;
746   }
747 
748   /** This is for manual testing of multisig wallet interaction */
749   function setOwnerTestValue(uint val) onlyOwner {
750     ownerTestValue = val;
751   }
752 
753   /** Interface marker. */
754   function isCrowdsale() public constant returns (bool) {
755     return true;
756   }
757 
758   //
759   // Modifiers
760   //
761 
762   /** Modified allowing execution only if the crowdsale is currently running.  */
763   modifier inState(State state) {
764     if(getState() != state) throw;
765     _;
766   }
767 
768 
769   //
770   // Abstract functions
771   //
772 
773   /**
774    * Check if the current invested breaks our cap rules.
775    *
776    *
777    * The child contract must define their own cap setting rules.
778    * We allow a lot of flexibility through different capping strategies (ETH, token count)
779    * Called from invest().
780    *
781    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
782    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
783    * @param weiRaisedTotal What would be our total raised balance after this transaction
784    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
785    *
786    * @return true if taking this investment would break our cap rules
787    */
788   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
789 
790   /**
791    * Check if the current crowdsale is full and we can no longer sell any tokens.
792    */
793   function isCrowdsaleFull() public constant returns (bool);
794 
795   /**
796    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
797    */
798   function assignTokens(address receiver, uint tokenAmount) private;
799 }
800 
801 
802 
803 
804 /// @dev Tranche based pricing with special support for pre-ico deals.
805 ///      Implementing "first price" tranches, meaning, that if byers order is
806 ///      covering more than one tranche, the price of the lowest tranche will apply
807 ///      to the whole order.
808 contract EthTranchePricing is PricingStrategy, Ownable {
809 
810   using SafeMathLib for uint;
811 
812   uint public constant MAX_TRANCHES = 10;
813 
814   // This contains all pre-ICO addresses, and their prices (weis per token)
815   mapping (address => uint) public preicoAddresses;
816 
817   /**
818   * Define pricing schedule using tranches.
819   */
820   struct Tranche {
821 
822       // Amount in weis when this tranche becomes active
823       uint amount;
824 
825       // How many tokens per satoshi you will get while this tranche is active
826       uint price;
827   }
828 
829   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
830   // Tranche 0 is always (0, 0)
831   // (TODO: change this when we confirm dynamic arrays are explorable)
832   Tranche[10] public tranches;
833 
834   // How many active tranches we have
835   uint public trancheCount;
836 
837   /// @dev Contruction, creating a list of tranches
838   /// @param _tranches uint[] tranches Pairs of (start amount, price)
839   function EthTranchePricing(uint[] _tranches) {
840     // Need to have tuples, length check
841     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
842       throw;
843     }
844 
845     trancheCount = _tranches.length / 2;
846 
847     uint highestAmount = 0;
848 
849     for(uint i=0; i<_tranches.length/2; i++) {
850       tranches[i].amount = _tranches[i*2];
851       tranches[i].price = _tranches[i*2+1];
852 
853       // No invalid steps
854       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
855         throw;
856       }
857 
858       highestAmount = tranches[i].amount;
859     }
860 
861     // We need to start from zero, otherwise we blow up our deployment
862     if(tranches[0].amount != 0) {
863       throw;
864     }
865 
866     // Last tranche price must be zero, terminating the crowdale
867     if(tranches[trancheCount-1].price != 0) {
868       throw;
869     }
870   }
871 
872   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
873   ///      to 0 to disable
874   /// @param preicoAddress PresaleFundCollector address
875   /// @param pricePerToken How many weis one token cost for pre-ico investors
876   function setPreicoAddress(address preicoAddress, uint pricePerToken)
877     public
878     onlyOwner
879   {
880     preicoAddresses[preicoAddress] = pricePerToken;
881   }
882 
883   /// @dev Iterate through tranches. You reach end of tranches when price = 0
884   /// @return tuple (time, price)
885   function getTranche(uint n) public constant returns (uint, uint) {
886     return (tranches[n].amount, tranches[n].price);
887   }
888 
889   function getFirstTranche() private constant returns (Tranche) {
890     return tranches[0];
891   }
892 
893   function getLastTranche() private constant returns (Tranche) {
894     return tranches[trancheCount-1];
895   }
896 
897   function getPricingStartsAt() public constant returns (uint) {
898     return getFirstTranche().amount;
899   }
900 
901   function getPricingEndsAt() public constant returns (uint) {
902     return getLastTranche().amount;
903   }
904 
905   function isSane(address _crowdsale) public constant returns(bool) {
906     // Our tranches are not bound by time, so we can't really check are we sane
907     // so we presume we are ;)
908     // In the future we could save and track raised tokens, and compare it to
909     // the Crowdsale contract.
910     return true;
911   }
912 
913   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
914   /// @param weiRaised total amount of weis raised, for calculating the current tranche
915   /// @return {[type]} [description]
916   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
917     uint i;
918 
919     for(i=0; i < tranches.length; i++) {
920       if(weiRaised < tranches[i].amount) {
921         return tranches[i-1];
922       }
923     }
924   }
925 
926   /// @dev Get the current price.
927   /// @param weiRaised total amount of weis raised, for calculating the current tranche
928   /// @return The current price or 0 if we are outside trache ranges
929   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
930     return getCurrentTranche(weiRaised).price;
931   }
932 
933   function isPresalePurchase(address purchaser) public constant returns (bool) {
934     if(preicoAddresses[purchaser] > 0)
935       return true;
936     else
937       return false;
938   }
939 
940   /// @dev Calculate the current price for buy in amount.
941   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
942 
943     uint multiplier = 10 ** decimals;
944 
945     // This investor is coming through pre-ico
946     if(preicoAddresses[msgSender] > 0) {
947       return value.times(multiplier) / preicoAddresses[msgSender];
948     }
949 
950     uint price = getCurrentPrice(weiRaised);
951     return value.times(multiplier) / price;
952   }
953 
954   function() payable {
955     throw; // No money on this contract
956   }
957 
958 }