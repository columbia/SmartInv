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
99   function assert(bool assertion) private {
100     if (!assertion) throw;
101   }
102 }
103 
104 /**
105  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
106  *
107  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
108  */
109 
110 
111 
112 
113 /*
114  * Ownable
115  *
116  * Base contract with an owner.
117  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
118  */
119 contract Ownable {
120   address public owner;
121 
122   function Ownable() {
123     owner = msg.sender;
124   }
125 
126   modifier onlyOwner() {
127     if (msg.sender != owner) {
128       throw;
129     }
130     _;
131   }
132 
133   function transferOwnership(address newOwner) onlyOwner {
134     if (newOwner != address(0)) {
135       owner = newOwner;
136     }
137   }
138 
139 }
140 
141 
142 /*
143  * Haltable
144  *
145  * Abstract contract that allows children to implement an
146  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
147  *
148  *
149  * Originally envisioned in FirstBlood ICO contract.
150  */
151 contract Haltable is Ownable {
152   bool public halted;
153 
154   modifier stopInEmergency {
155     if (halted) throw;
156     _;
157   }
158 
159   modifier onlyInEmergency {
160     if (!halted) throw;
161     _;
162   }
163 
164   // called by the owner on emergency, triggers stopped state
165   function halt() external onlyOwner {
166     halted = true;
167   }
168 
169   // called by the owner on end of emergency, returns to normal state
170   function unhalt() external onlyOwner onlyInEmergency {
171     halted = false;
172   }
173 
174 }
175 
176 
177 /**
178  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
179  *
180  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
181  */
182 
183 
184 /**
185  * Finalize agent defines what happens at the end of succeseful crowdsale.
186  *
187  * - Allocate tokens for founders, bounties and community
188  * - Make tokens transferable
189  * - etc.
190  */
191 contract FinalizeAgent {
192 
193   function isFinalizeAgent() public constant returns(bool) {
194     return true;
195   }
196 
197   /** Return true if we can run finalizeCrowdsale() properly.
198    *
199    * This is a safety check function that doesn't allow crowdsale to begin
200    * unless the finalizer has been set up properly.
201    */
202   function isSane() public constant returns (bool);
203 
204   /** Called once by crowdsale finalize() if the sale was success. */
205   function finalizeCrowdsale();
206 
207 }
208 
209 /**
210  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
211  *
212  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
213  */
214 
215 
216 
217 
218 /*
219  * ERC20 interface
220  * see https://github.com/ethereum/EIPs/issues/20
221  */
222 contract ERC20 {
223   uint public totalSupply;
224   function balanceOf(address who) constant returns (uint);
225   function allowance(address owner, address spender) constant returns (uint);
226 
227   function transfer(address to, uint value) returns (bool ok);
228   function transferFrom(address from, address to, uint value) returns (bool ok);
229   function approve(address spender, uint value) returns (bool ok);
230   event Transfer(address indexed from, address indexed to, uint value);
231   event Approval(address indexed owner, address indexed spender, uint value);
232 }
233 
234 
235 /**
236  * A token that defines fractional units as decimals.
237  */
238 contract FractionalERC20 is ERC20 {
239 
240   uint public decimals;
241 
242 }
243 
244 
245 
246 /**
247  * Abstract base contract for token sales.
248  *
249  * Handle
250  * - start and end dates
251  * - accepting investments
252  * - minimum funding goal and refund
253  * - various statistics during the crowdfund
254  * - different pricing strategies
255  * - different investment policies (require server side customer id, allow only whitelisted addresses)
256  *
257  */
258 contract Crowdsale is Haltable {
259 
260   /* Max investment count when we are still allowed to change the multisig address */
261   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
262 
263   using SafeMathLib for uint;
264 
265   /* The token we are selling */
266   FractionalERC20 public token;
267 
268   /* How we are going to price our offering */
269   PricingStrategy public pricingStrategy;
270 
271   /* Post-success callback */
272   FinalizeAgent public finalizeAgent;
273 
274   /* tokens will be transfered from this address */
275   address public multisigWallet;
276 
277   /* if the funding goal is not reached, investors may withdraw their funds */
278   uint public minimumFundingGoal;
279 
280   /* the UNIX timestamp start date of the crowdsale */
281   uint public startsAt;
282 
283   /* the UNIX timestamp end date of the crowdsale */
284   uint public endsAt;
285 
286   /* the number of tokens already sold through this contract*/
287   uint public tokensSold = 0;
288 
289   /* How many wei of funding we have raised */
290   uint public weiRaised = 0;
291 
292   /* Calculate incoming funds from presale contracts and addresses */
293   uint public presaleWeiRaised = 0;
294 
295   /* How many distinct addresses have invested */
296   uint public investorCount = 0;
297 
298   /* How much wei we have returned back to the contract after a failed crowdfund. */
299   uint public loadedRefund = 0;
300 
301   /* How much wei we have given back to investors.*/
302   uint public weiRefunded = 0;
303 
304   /* Has this crowdsale been finalized */
305   bool public finalized;
306 
307   /* Do we need to have unique contributor id for each customer */
308   bool public requireCustomerId;
309 
310   /**
311     * Do we verify that contributor has been cleared on the server side (accredited investors only).
312     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
313     */
314   bool public requiredSignedAddress;
315 
316   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
317   address public signerAddress;
318 
319   /** How much ETH each address has invested to this crowdsale */
320   mapping (address => uint256) public investedAmountOf;
321 
322   /** How much tokens this crowdsale has credited for each investor address */
323   mapping (address => uint256) public tokenAmountOf;
324 
325   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
326   mapping (address => bool) public earlyParticipantWhitelist;
327 
328   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
329   uint public ownerTestValue;
330 
331   /** State machine
332    *
333    * - Preparing: All contract initialization calls and variables have not been set yet
334    * - Prefunding: We have not passed start time yet
335    * - Funding: Active crowdsale
336    * - Success: Minimum funding goal reached
337    * - Failure: Minimum funding goal not reached before ending time
338    * - Finalized: The finalized has been called and succesfully executed
339    * - Refunding: Refunds are loaded on the contract for reclaim.
340    */
341   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
342 
343   // A new investment was made
344   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
345 
346   // Refund was processed for a contributor
347   event Refund(address investor, uint weiAmount);
348 
349   // The rules were changed what kind of investments we accept
350   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
351 
352   // Address early participation whitelist status changed
353   event Whitelisted(address addr, bool status);
354 
355   // Crowdsale end time has been changed
356   event EndsAtChanged(uint endsAt);
357 
358   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
359 
360     owner = msg.sender;
361 
362     token = FractionalERC20(_token);
363 
364     setPricingStrategy(_pricingStrategy);
365 
366     multisigWallet = _multisigWallet;
367     if(multisigWallet == 0) {
368         throw;
369     }
370 
371     if(_start == 0) {
372         throw;
373     }
374 
375     startsAt = _start;
376 
377     if(_end == 0) {
378         throw;
379     }
380 
381     endsAt = _end;
382 
383     // Don't mess the dates
384     if(startsAt >= endsAt) {
385         throw;
386     }
387 
388     // Minimum funding goal can be zero
389     minimumFundingGoal = _minimumFundingGoal;
390   }
391 
392   /**
393    * Don't expect to just send in money and get tokens.
394    */
395   function() payable {
396     throw;
397   }
398 
399   /**
400    * Make an investment.
401    *
402    * Crowdsale must be running for one to invest.
403    * We must have not pressed the emergency brake.
404    *
405    * @param receiver The Ethereum address who receives the tokens
406    * @param customerId (optional) UUID v4 to track the successful payments on the server side
407    *
408    */
409   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
410 
411     // Determine if it's a good time to accept investment from this participant
412     if(getState() == State.PreFunding) {
413       // Are we whitelisted for early deposit
414       if(!earlyParticipantWhitelist[receiver]) {
415         throw;
416       }
417     } else if(getState() == State.Funding) {
418       // Retail participants can only come in when the crowdsale is running
419       // pass
420     } else {
421       // Unwanted state
422       throw;
423     }
424 
425     uint weiAmount = msg.value;
426 
427     // Account presale sales separately, so that they do not count against pricing tranches
428     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
429 
430     if(tokenAmount == 0) {
431       // Dust transaction
432       throw;
433     }
434 
435     if(investedAmountOf[receiver] == 0) {
436        // A new investor
437        investorCount++;
438     }
439 
440     // Update investor
441     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
442     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
443 
444     // Update totals
445     weiRaised = weiRaised.plus(weiAmount);
446     tokensSold = tokensSold.plus(tokenAmount);
447 
448     if(pricingStrategy.isPresalePurchase(receiver)) {
449         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
450     }
451 
452     // Check that we did not bust the cap
453     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
454       throw;
455     }
456 
457     assignTokens(receiver, tokenAmount);
458 
459     // Pocket the money
460     if(!multisigWallet.send(weiAmount)) throw;
461 
462     // Tell us invest was success
463     Invested(receiver, weiAmount, tokenAmount, customerId);
464   }
465 
466   /**
467    * Preallocate tokens for the early investors.
468    *
469    * Preallocated tokens have been sold before the actual crowdsale opens.
470    * This function mints the tokens and moves the crowdsale needle.
471    *
472    * Investor count is not handled; it is assumed this goes for multiple investors
473    * and the token distribution happens outside the smart contract flow.
474    *
475    * No money is exchanged, as the crowdsale team already have received the payment.
476    *
477    * @param fullTokens tokens as full tokens - decimal places added internally
478    * @param weiPrice Price of a single full token in wei
479    *
480    */
481   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
482 
483     uint tokenAmount = fullTokens * 10**token.decimals();
484     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
485 
486     weiRaised = weiRaised.plus(weiAmount);
487     tokensSold = tokensSold.plus(tokenAmount);
488 
489     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
490     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
491 
492     assignTokens(receiver, tokenAmount);
493 
494     // Tell us invest was success
495     Invested(receiver, weiAmount, tokenAmount, 0);
496   }
497 
498   /**
499    * Allow anonymous contributions to this crowdsale.
500    */
501   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
502      bytes32 hash = sha256(addr);
503      if (ecrecover(hash, v, r, s) != signerAddress) throw;
504      if(customerId == 0) throw;  // UUIDv4 sanity check
505      investInternal(addr, customerId);
506   }
507 
508   /**
509    * Track who is the customer making the payment so we can send thank you email.
510    */
511   function investWithCustomerId(address addr, uint128 customerId) public payable {
512     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
513     if(customerId == 0) throw;  // UUIDv4 sanity check
514     investInternal(addr, customerId);
515   }
516 
517   /**
518    * Allow anonymous contributions to this crowdsale.
519    */
520   function invest(address addr) public payable {
521     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
522     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
523     investInternal(addr, 0);
524   }
525 
526   /**
527    * Invest to tokens, recognize the payer and clear his address.
528    *
529    */
530   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
531     investWithSignedAddress(msg.sender, customerId, v, r, s);
532   }
533 
534   /**
535    * Invest to tokens, recognize the payer.
536    *
537    */
538   function buyWithCustomerId(uint128 customerId) public payable {
539     investWithCustomerId(msg.sender, customerId);
540   }
541 
542   /**
543    * The basic entry point to participate the crowdsale process.
544    *
545    * Pay for funding, get invested tokens back in the sender address.
546    */
547   function buy() public payable {
548     invest(msg.sender);
549   }
550 
551   /**
552    * Finalize a succcesful crowdsale.
553    *
554    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
555    */
556   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
557 
558     // Already finalized
559     if(finalized) {
560       throw;
561     }
562 
563     // Finalizing is optional. We only call it if we are given a finalizing agent.
564     if(address(finalizeAgent) != 0) {
565       finalizeAgent.finalizeCrowdsale();
566     }
567 
568     finalized = true;
569   }
570 
571   /**
572    * Allow to (re)set finalize agent.
573    *
574    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
575    */
576   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
577     finalizeAgent = addr;
578 
579     // Don't allow setting bad agent
580     if(!finalizeAgent.isFinalizeAgent()) {
581       throw;
582     }
583   }
584 
585   /**
586    * Set policy do we need to have server-side customer ids for the investments.
587    *
588    */
589   function setRequireCustomerId(bool value) onlyOwner {
590     requireCustomerId = value;
591     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
592   }
593 
594   /**
595    * Set policy if all investors must be cleared on the server side first.
596    *
597    * This is e.g. for the accredited investor clearing.
598    *
599    */
600   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
601     requiredSignedAddress = value;
602     signerAddress = _signerAddress;
603     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
604   }
605 
606   /**
607    * Allow addresses to do early participation.
608    *
609    * TODO: Fix spelling error in the name
610    */
611   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
612     earlyParticipantWhitelist[addr] = status;
613     Whitelisted(addr, status);
614   }
615 
616   /**
617    * Allow crowdsale owner to close early or extend the crowdsale.
618    *
619    * This is useful e.g. for a manual soft cap implementation:
620    * - after X amount is reached determine manual closing
621    *
622    * This may put the crowdsale to an invalid state,
623    * but we trust owners know what they are doing.
624    *
625    */
626   function setEndsAt(uint time) onlyOwner {
627 
628     if(now > time) {
629       throw; // Don't change past
630     }
631 
632     endsAt = time;
633     EndsAtChanged(endsAt);
634   }
635 
636   /**
637    * Allow to (re)set pricing strategy.
638    *
639    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
640    */
641   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
642     pricingStrategy = _pricingStrategy;
643 
644     // Don't allow setting bad agent
645     if(!pricingStrategy.isPricingStrategy()) {
646       throw;
647     }
648   }
649 
650   /**
651    * Allow to change the team multisig address in the case of emergency.
652    *
653    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
654    * (we have done only few test transactions). After the crowdsale is going
655    * then multisig address stays locked for the safety reasons.
656    */
657   function setMultisig(address addr) public onlyOwner {
658 
659     // Change
660     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
661       throw;
662     }
663 
664     multisigWallet = addr;
665   }
666 
667   /**
668    * Allow load refunds back on the contract for the refunding.
669    *
670    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
671    */
672   function loadRefund() public payable inState(State.Failure) {
673     if(msg.value == 0) throw;
674     loadedRefund = loadedRefund.plus(msg.value);
675   }
676 
677   /**
678    * Investors can claim refund.
679    *
680    * Note that any refunds from proxy buyers should be handled separately,
681    * and not through this contract.
682    */
683   function refund() public inState(State.Refunding) {
684     uint256 weiValue = investedAmountOf[msg.sender];
685     if (weiValue == 0) throw;
686     investedAmountOf[msg.sender] = 0;
687     weiRefunded = weiRefunded.plus(weiValue);
688     Refund(msg.sender, weiValue);
689     if (!msg.sender.send(weiValue)) throw;
690   }
691 
692   /**
693    * @return true if the crowdsale has raised enough money to be a successful.
694    */
695   function isMinimumGoalReached() public constant returns (bool reached) {
696     return weiRaised >= minimumFundingGoal;
697   }
698 
699   /**
700    * Check if the contract relationship looks good.
701    */
702   function isFinalizerSane() public constant returns (bool sane) {
703     return finalizeAgent.isSane();
704   }
705 
706   /**
707    * Check if the contract relationship looks good.
708    */
709   function isPricingSane() public constant returns (bool sane) {
710     return pricingStrategy.isSane(address(this));
711   }
712 
713   /**
714    * Crowdfund state machine management.
715    *
716    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
717    */
718   function getState() public constant returns (State) {
719     if(finalized) return State.Finalized;
720     else if (address(finalizeAgent) == 0) return State.Preparing;
721     else if (!finalizeAgent.isSane()) return State.Preparing;
722     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
723     else if (block.timestamp < startsAt) return State.PreFunding;
724     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
725     else if (isMinimumGoalReached()) return State.Success;
726     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
727     else return State.Failure;
728   }
729 
730   /** This is for manual testing of multisig wallet interaction */
731   function setOwnerTestValue(uint val) onlyOwner {
732     ownerTestValue = val;
733   }
734 
735   /** Interface marker. */
736   function isCrowdsale() public constant returns (bool) {
737     return true;
738   }
739 
740   //
741   // Modifiers
742   //
743 
744   /** Modified allowing execution only if the crowdsale is currently running.  */
745   modifier inState(State state) {
746     if(getState() != state) throw;
747     _;
748   }
749 
750 
751   //
752   // Abstract functions
753   //
754 
755   /**
756    * Check if the current invested breaks our cap rules.
757    *
758    *
759    * The child contract must define their own cap setting rules.
760    * We allow a lot of flexibility through different capping strategies (ETH, token count)
761    * Called from invest().
762    *
763    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
764    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
765    * @param weiRaisedTotal What would be our total raised balance after this transaction
766    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
767    *
768    * @return true if taking this investment would break our cap rules
769    */
770   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
771 
772   /**
773    * Check if the current crowdsale is full and we can no longer sell any tokens.
774    */
775   function isCrowdsaleFull() public constant returns (bool);
776 
777   /**
778    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
779    */
780   function assignTokens(address receiver, uint tokenAmount) private;
781 }
782 
783 
784 
785 
786 /// @dev Tranche based pricing with special support for pre-ico deals.
787 ///      Implementing "first price" tranches, meaning, that if byers order is
788 ///      covering more than one tranche, the price of the lowest tranche will apply
789 ///      to the whole order.
790 contract EthTranchePricing is PricingStrategy, Ownable {
791 
792   using SafeMathLib for uint;
793 
794   uint public constant MAX_TRANCHES = 10;
795 
796   // This contains all pre-ICO addresses, and their prices (weis per token)
797   mapping (address => uint) public preicoAddresses;
798 
799   /**
800   * Define pricing schedule using tranches.
801   */
802   struct Tranche {
803 
804       // Amount in weis when this tranche becomes active
805       uint amount;
806 
807       // How many tokens per satoshi you will get while this tranche is active
808       uint price;
809   }
810 
811   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
812   // Tranche 0 is always (0, 0)
813   // (TODO: change this when we confirm dynamic arrays are explorable)
814   Tranche[10] public tranches;
815 
816   // How many active tranches we have
817   uint public trancheCount;
818 
819   /// @dev Contruction, creating a list of tranches
820   /// @param _tranches uint[] tranches Pairs of (start amount, price)
821   function EthTranchePricing(uint[] _tranches) {
822     // Need to have tuples, length check
823     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
824       throw;
825     }
826 
827     trancheCount = _tranches.length / 2;
828 
829     uint highestAmount = 0;
830 
831     for(uint i=0; i<_tranches.length/2; i++) {
832       tranches[i].amount = _tranches[i*2];
833       tranches[i].price = _tranches[i*2+1];
834 
835       // No invalid steps
836       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
837         throw;
838       }
839 
840       highestAmount = tranches[i].amount;
841     }
842 
843     // We need to start from zero, otherwise we blow up our deployment
844     if(tranches[0].amount != 0) {
845       throw;
846     }
847 
848     // Last tranche price must be zero, terminating the crowdale
849     if(tranches[trancheCount-1].price != 0) {
850       throw;
851     }
852   }
853 
854   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
855   ///      to 0 to disable
856   /// @param preicoAddress PresaleFundCollector address
857   /// @param pricePerToken How many weis one token cost for pre-ico investors
858   function setPreicoAddress(address preicoAddress, uint pricePerToken)
859     public
860     onlyOwner
861   {
862     preicoAddresses[preicoAddress] = pricePerToken;
863   }
864 
865   /// @dev Iterate through tranches. You reach end of tranches when price = 0
866   /// @return tuple (time, price)
867   function getTranche(uint n) public constant returns (uint, uint) {
868     return (tranches[n].amount, tranches[n].price);
869   }
870 
871   function getFirstTranche() private constant returns (Tranche) {
872     return tranches[0];
873   }
874 
875   function getLastTranche() private constant returns (Tranche) {
876     return tranches[trancheCount-1];
877   }
878 
879   function getPricingStartsAt() public constant returns (uint) {
880     return getFirstTranche().amount;
881   }
882 
883   function getPricingEndsAt() public constant returns (uint) {
884     return getLastTranche().amount;
885   }
886 
887   function isSane(address _crowdsale) public constant returns(bool) {
888     // Our tranches are not bound by time, so we can't really check are we sane
889     // so we presume we are ;)
890     // In the future we could save and track raised tokens, and compare it to
891     // the Crowdsale contract.
892     return true;
893   }
894 
895   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
896   /// @param weiRaised total amount of weis raised, for calculating the current tranche
897   /// @return {[type]} [description]
898   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
899     uint i;
900 
901     for(i=0; i < tranches.length; i++) {
902       if(weiRaised < tranches[i].amount) {
903         return tranches[i-1];
904       }
905     }
906   }
907 
908   /// @dev Get the current price.
909   /// @param weiRaised total amount of weis raised, for calculating the current tranche
910   /// @return The current price or 0 if we are outside trache ranges
911   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
912     return getCurrentTranche(weiRaised).price;
913   }
914 
915   function isPresalePurchase(address purchaser) public constant returns (bool) {
916     if(preicoAddresses[purchaser] > 0)
917       return true;
918     else
919       return false;
920   }
921 
922   /// @dev Calculate the current price for buy in amount.
923   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
924 
925     uint multiplier = 10 ** decimals;
926 
927     // This investor is coming through pre-ico
928     if(preicoAddresses[msgSender] > 0) {
929       return value.times(multiplier) / preicoAddresses[msgSender];
930     }
931 
932     uint price = getCurrentPrice(weiRaised);
933     return value.times(multiplier) / price;
934   }
935 
936   function() payable {
937     throw; // No money on this contract
938   }
939 
940 }