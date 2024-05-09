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
166   modifier stopNonOwnersInEmergency {
167     if (halted && msg.sender != owner) throw;
168     _;
169   }
170 
171   modifier onlyInEmergency {
172     if (!halted) throw;
173     _;
174   }
175 
176   // called by the owner on emergency, triggers stopped state
177   function halt() external onlyOwner {
178     halted = true;
179   }
180 
181   // called by the owner on end of emergency, returns to normal state
182   function unhalt() external onlyOwner onlyInEmergency {
183     halted = false;
184   }
185 
186 }
187 
188 
189 /**
190  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
191  *
192  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
193  */
194 
195 
196 /**
197  * Finalize agent defines what happens at the end of succeseful crowdsale.
198  *
199  * - Allocate tokens for founders, bounties and community
200  * - Make tokens transferable
201  * - etc.
202  */
203 contract FinalizeAgent {
204 
205   function isFinalizeAgent() public constant returns(bool) {
206     return true;
207   }
208 
209   /** Return true if we can run finalizeCrowdsale() properly.
210    *
211    * This is a safety check function that doesn't allow crowdsale to begin
212    * unless the finalizer has been set up properly.
213    */
214   function isSane() public constant returns (bool);
215 
216   /** Called once by crowdsale finalize() if the sale was success. */
217   function finalizeCrowdsale();
218 
219 }
220 
221 /**
222  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
223  *
224  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
225  */
226 
227 
228 
229 
230 
231 
232 /**
233  * @title ERC20Basic
234  * @dev Simpler version of ERC20 interface
235  * @dev see https://github.com/ethereum/EIPs/issues/179
236  */
237 contract ERC20Basic {
238   uint256 public totalSupply;
239   function balanceOf(address who) constant returns (uint256);
240   function transfer(address to, uint256 value) returns (bool);
241   event Transfer(address indexed from, address indexed to, uint256 value);
242 }
243 
244 
245 
246 /**
247  * @title ERC20 interface
248  * @dev see https://github.com/ethereum/EIPs/issues/20
249  */
250 contract ERC20 is ERC20Basic {
251   function allowance(address owner, address spender) constant returns (uint256);
252   function transferFrom(address from, address to, uint256 value) returns (bool);
253   function approve(address spender, uint256 value) returns (bool);
254   event Approval(address indexed owner, address indexed spender, uint256 value);
255 }
256 
257 
258 /**
259  * A token that defines fractional units as decimals.
260  */
261 contract FractionalERC20 is ERC20 {
262 
263   uint public decimals;
264 
265 }
266 
267 
268 
269 /**
270  * Abstract base contract for token sales.
271  *
272  * Handle
273  * - start and end dates
274  * - accepting investments
275  * - minimum funding goal and refund
276  * - various statistics during the crowdfund
277  * - different pricing strategies
278  * - different investment policies (require server side customer id, allow only whitelisted addresses)
279  *
280  */
281 contract Crowdsale is Haltable {
282 
283   /* Max investment count when we are still allowed to change the multisig address */
284   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
285 
286   using SafeMathLib for uint;
287 
288   /* The token we are selling */
289   FractionalERC20 public token;
290 
291   /* How we are going to price our offering */
292   PricingStrategy public pricingStrategy;
293 
294   /* Post-success callback */
295   FinalizeAgent public finalizeAgent;
296 
297   /* tokens will be transfered from this address */
298   address public multisigWallet;
299 
300   /* if the funding goal is not reached, investors may withdraw their funds */
301   uint public minimumFundingGoal;
302 
303   /* the UNIX timestamp start date of the crowdsale */
304   uint public startsAt;
305 
306   /* the UNIX timestamp end date of the crowdsale */
307   uint public endsAt;
308 
309   /* the number of tokens already sold through this contract*/
310   uint public tokensSold = 0;
311 
312   /* How many wei of funding we have raised */
313   uint public weiRaised = 0;
314 
315   /* Calculate incoming funds from presale contracts and addresses */
316   uint public presaleWeiRaised = 0;
317 
318   /* How many distinct addresses have invested */
319   uint public investorCount = 0;
320 
321   /* How much wei we have returned back to the contract after a failed crowdfund. */
322   uint public loadedRefund = 0;
323 
324   /* How much wei we have given back to investors.*/
325   uint public weiRefunded = 0;
326 
327   /* Has this crowdsale been finalized */
328   bool public finalized;
329 
330   /* Do we need to have unique contributor id for each customer */
331   bool public requireCustomerId;
332 
333   /**
334     * Do we verify that contributor has been cleared on the server side (accredited investors only).
335     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
336     */
337   bool public requiredSignedAddress;
338 
339   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
340   address public signerAddress;
341 
342   /** How much ETH each address has invested to this crowdsale */
343   mapping (address => uint256) public investedAmountOf;
344 
345   /** How much tokens this crowdsale has credited for each investor address */
346   mapping (address => uint256) public tokenAmountOf;
347 
348   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
349   mapping (address => bool) public earlyParticipantWhitelist;
350 
351   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
352   uint public ownerTestValue;
353 
354   /** State machine
355    *
356    * - Preparing: All contract initialization calls and variables have not been set yet
357    * - Prefunding: We have not passed start time yet
358    * - Funding: Active crowdsale
359    * - Success: Minimum funding goal reached
360    * - Failure: Minimum funding goal not reached before ending time
361    * - Finalized: The finalized has been called and succesfully executed
362    * - Refunding: Refunds are loaded on the contract for reclaim.
363    */
364   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
365 
366   // A new investment was made
367   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
368 
369   // Refund was processed for a contributor
370   event Refund(address investor, uint weiAmount);
371 
372   // The rules were changed what kind of investments we accept
373   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
374 
375   // Address early participation whitelist status changed
376   event Whitelisted(address addr, bool status);
377 
378   // Crowdsale end time has been changed
379   event EndsAtChanged(uint newEndsAt);
380 
381   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
382 
383     owner = msg.sender;
384 
385     token = FractionalERC20(_token);
386 
387     setPricingStrategy(_pricingStrategy);
388 
389     multisigWallet = _multisigWallet;
390     if(multisigWallet == 0) {
391         throw;
392     }
393 
394     if(_start == 0) {
395         throw;
396     }
397 
398     startsAt = _start;
399 
400     if(_end == 0) {
401         throw;
402     }
403 
404     endsAt = _end;
405 
406     // Don't mess the dates
407     if(startsAt >= endsAt) {
408         throw;
409     }
410 
411     // Minimum funding goal can be zero
412     minimumFundingGoal = _minimumFundingGoal;
413   }
414 
415   /**
416    * Don't expect to just send in money and get tokens.
417    */
418   function() payable {
419     throw;
420   }
421 
422   /**
423    * Make an investment.
424    *
425    * Crowdsale must be running for one to invest.
426    * We must have not pressed the emergency brake.
427    *
428    * @param receiver The Ethereum address who receives the tokens
429    * @param customerId (optional) UUID v4 to track the successful payments on the server side
430    *
431    */
432   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
433 
434     // Determine if it's a good time to accept investment from this participant
435     if(getState() == State.PreFunding) {
436       // Are we whitelisted for early deposit
437       if(!earlyParticipantWhitelist[receiver]) {
438         throw;
439       }
440     } else if(getState() == State.Funding) {
441       // Retail participants can only come in when the crowdsale is running
442       // pass
443     } else {
444       // Unwanted state
445       throw;
446     }
447 
448     uint weiAmount = msg.value;
449 
450     // Account presale sales separately, so that they do not count against pricing tranches
451     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
452 
453     if(tokenAmount == 0) {
454       // Dust transaction
455       throw;
456     }
457 
458     if(investedAmountOf[receiver] == 0) {
459        // A new investor
460        investorCount++;
461     }
462 
463     // Update investor
464     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
465     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
466 
467     // Update totals
468     weiRaised = weiRaised.plus(weiAmount);
469     tokensSold = tokensSold.plus(tokenAmount);
470 
471     if(pricingStrategy.isPresalePurchase(receiver)) {
472         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
473     }
474 
475     // Check that we did not bust the cap
476     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
477       throw;
478     }
479 
480     assignTokens(receiver, tokenAmount);
481 
482     // Pocket the money
483     if(!multisigWallet.send(weiAmount)) throw;
484 
485     // Tell us invest was success
486     Invested(receiver, weiAmount, tokenAmount, customerId);
487   }
488 
489   /**
490    * Preallocate tokens for the early investors.
491    *
492    * Preallocated tokens have been sold before the actual crowdsale opens.
493    * This function mints the tokens and moves the crowdsale needle.
494    *
495    * Investor count is not handled; it is assumed this goes for multiple investors
496    * and the token distribution happens outside the smart contract flow.
497    *
498    * No money is exchanged, as the crowdsale team already have received the payment.
499    *
500    * @param fullTokens tokens as full tokens - decimal places added internally
501    * @param weiPrice Price of a single full token in wei
502    *
503    */
504   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
505 
506     uint tokenAmount = fullTokens * 10**token.decimals();
507     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
508 
509     weiRaised = weiRaised.plus(weiAmount);
510     tokensSold = tokensSold.plus(tokenAmount);
511 
512     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
513     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
514 
515     assignTokens(receiver, tokenAmount);
516 
517     // Tell us invest was success
518     Invested(receiver, weiAmount, tokenAmount, 0);
519   }
520 
521   /**
522    * Allow anonymous contributions to this crowdsale.
523    */
524   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
525      bytes32 hash = sha256(addr);
526      if (ecrecover(hash, v, r, s) != signerAddress) throw;
527      if(customerId == 0) throw;  // UUIDv4 sanity check
528      investInternal(addr, customerId);
529   }
530 
531   /**
532    * Track who is the customer making the payment so we can send thank you email.
533    */
534   function investWithCustomerId(address addr, uint128 customerId) public payable {
535     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
536     if(customerId == 0) throw;  // UUIDv4 sanity check
537     investInternal(addr, customerId);
538   }
539 
540   /**
541    * Allow anonymous contributions to this crowdsale.
542    */
543   function invest(address addr) public payable {
544     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
545     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
546     investInternal(addr, 0);
547   }
548 
549   /**
550    * Invest to tokens, recognize the payer and clear his address.
551    *
552    */
553   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
554     investWithSignedAddress(msg.sender, customerId, v, r, s);
555   }
556 
557   /**
558    * Invest to tokens, recognize the payer.
559    *
560    */
561   function buyWithCustomerId(uint128 customerId) public payable {
562     investWithCustomerId(msg.sender, customerId);
563   }
564 
565   /**
566    * The basic entry point to participate the crowdsale process.
567    *
568    * Pay for funding, get invested tokens back in the sender address.
569    */
570   function buy() public payable {
571     invest(msg.sender);
572   }
573 
574   /**
575    * Finalize a succcesful crowdsale.
576    *
577    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
578    */
579   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
580 
581     // Already finalized
582     if(finalized) {
583       throw;
584     }
585 
586     // Finalizing is optional. We only call it if we are given a finalizing agent.
587     if(address(finalizeAgent) != 0) {
588       finalizeAgent.finalizeCrowdsale();
589     }
590 
591     finalized = true;
592   }
593 
594   /**
595    * Allow to (re)set finalize agent.
596    *
597    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
598    */
599   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
600     finalizeAgent = addr;
601 
602     // Don't allow setting bad agent
603     if(!finalizeAgent.isFinalizeAgent()) {
604       throw;
605     }
606   }
607 
608   /**
609    * Set policy do we need to have server-side customer ids for the investments.
610    *
611    */
612   function setRequireCustomerId(bool value) onlyOwner {
613     requireCustomerId = value;
614     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
615   }
616 
617   /**
618    * Set policy if all investors must be cleared on the server side first.
619    *
620    * This is e.g. for the accredited investor clearing.
621    *
622    */
623   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
624     requiredSignedAddress = value;
625     signerAddress = _signerAddress;
626     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
627   }
628 
629   /**
630    * Allow addresses to do early participation.
631    *
632    * TODO: Fix spelling error in the name
633    */
634   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
635     earlyParticipantWhitelist[addr] = status;
636     Whitelisted(addr, status);
637   }
638 
639   /**
640    * Allow crowdsale owner to close early or extend the crowdsale.
641    *
642    * This is useful e.g. for a manual soft cap implementation:
643    * - after X amount is reached determine manual closing
644    *
645    * This may put the crowdsale to an invalid state,
646    * but we trust owners know what they are doing.
647    *
648    */
649   function setEndsAt(uint time) onlyOwner {
650 
651     if(now > time) {
652       throw; // Don't change past
653     }
654 
655     endsAt = time;
656     EndsAtChanged(endsAt);
657   }
658 
659   /**
660    * Allow to (re)set pricing strategy.
661    *
662    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
663    */
664   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
665     pricingStrategy = _pricingStrategy;
666 
667     // Don't allow setting bad agent
668     if(!pricingStrategy.isPricingStrategy()) {
669       throw;
670     }
671   }
672 
673   /**
674    * Allow to change the team multisig address in the case of emergency.
675    *
676    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
677    * (we have done only few test transactions). After the crowdsale is going
678    * then multisig address stays locked for the safety reasons.
679    */
680   function setMultisig(address addr) public onlyOwner {
681 
682     // Change
683     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
684       throw;
685     }
686 
687     multisigWallet = addr;
688   }
689 
690   /**
691    * Allow load refunds back on the contract for the refunding.
692    *
693    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
694    */
695   function loadRefund() public payable inState(State.Failure) {
696     if(msg.value == 0) throw;
697     loadedRefund = loadedRefund.plus(msg.value);
698   }
699 
700   /**
701    * Investors can claim refund.
702    *
703    * Note that any refunds from proxy buyers should be handled separately,
704    * and not through this contract.
705    */
706   function refund() public inState(State.Refunding) {
707     uint256 weiValue = investedAmountOf[msg.sender];
708     if (weiValue == 0) throw;
709     investedAmountOf[msg.sender] = 0;
710     weiRefunded = weiRefunded.plus(weiValue);
711     Refund(msg.sender, weiValue);
712     if (!msg.sender.send(weiValue)) throw;
713   }
714 
715   /**
716    * @return true if the crowdsale has raised enough money to be a successful.
717    */
718   function isMinimumGoalReached() public constant returns (bool reached) {
719     return weiRaised >= minimumFundingGoal;
720   }
721 
722   /**
723    * Check if the contract relationship looks good.
724    */
725   function isFinalizerSane() public constant returns (bool sane) {
726     return finalizeAgent.isSane();
727   }
728 
729   /**
730    * Check if the contract relationship looks good.
731    */
732   function isPricingSane() public constant returns (bool sane) {
733     return pricingStrategy.isSane(address(this));
734   }
735 
736   /**
737    * Crowdfund state machine management.
738    *
739    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
740    */
741   function getState() public constant returns (State) {
742     if(finalized) return State.Finalized;
743     else if (address(finalizeAgent) == 0) return State.Preparing;
744     else if (!finalizeAgent.isSane()) return State.Preparing;
745     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
746     else if (block.timestamp < startsAt) return State.PreFunding;
747     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
748     else if (isMinimumGoalReached()) return State.Success;
749     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
750     else return State.Failure;
751   }
752 
753   /** This is for manual testing of multisig wallet interaction */
754   function setOwnerTestValue(uint val) onlyOwner {
755     ownerTestValue = val;
756   }
757 
758   /** Interface marker. */
759   function isCrowdsale() public constant returns (bool) {
760     return true;
761   }
762 
763   //
764   // Modifiers
765   //
766 
767   /** Modified allowing execution only if the crowdsale is currently running.  */
768   modifier inState(State state) {
769     if(getState() != state) throw;
770     _;
771   }
772 
773 
774   //
775   // Abstract functions
776   //
777 
778   /**
779    * Check if the current invested breaks our cap rules.
780    *
781    *
782    * The child contract must define their own cap setting rules.
783    * We allow a lot of flexibility through different capping strategies (ETH, token count)
784    * Called from invest().
785    *
786    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
787    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
788    * @param weiRaisedTotal What would be our total raised balance after this transaction
789    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
790    *
791    * @return true if taking this investment would break our cap rules
792    */
793   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
794 
795   /**
796    * Check if the current crowdsale is full and we can no longer sell any tokens.
797    */
798   function isCrowdsaleFull() public constant returns (bool);
799 
800   /**
801    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
802    */
803   function assignTokens(address receiver, uint tokenAmount) private;
804 }
805 
806 
807 
808 
809 /// @dev Tranche based pricing with special support for pre-ico deals.
810 ///      Implementing "first price" tranches, meaning, that if byers order is
811 ///      covering more than one tranche, the price of the lowest tranche will apply
812 ///      to the whole order.
813 contract EthTranchePricing is PricingStrategy, Ownable {
814 
815   using SafeMathLib for uint;
816 
817   uint public constant MAX_TRANCHES = 10;
818 
819   // This contains all pre-ICO addresses, and their prices (weis per token)
820   mapping (address => uint) public preicoAddresses;
821 
822   /**
823   * Define pricing schedule using tranches.
824   */
825   struct Tranche {
826 
827       // Amount in weis when this tranche becomes active
828       uint amount;
829 
830       // How many tokens per satoshi you will get while this tranche is active
831       uint price;
832   }
833 
834   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
835   // Tranche 0 is always (0, 0)
836   // (TODO: change this when we confirm dynamic arrays are explorable)
837   Tranche[10] public tranches;
838 
839   // How many active tranches we have
840   uint public trancheCount;
841 
842   /// @dev Contruction, creating a list of tranches
843   /// @param _tranches uint[] tranches Pairs of (start amount, price)
844   function EthTranchePricing(uint[] _tranches) {
845     // Need to have tuples, length check
846     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
847       throw;
848     }
849 
850     trancheCount = _tranches.length / 2;
851 
852     uint highestAmount = 0;
853 
854     for(uint i=0; i<_tranches.length/2; i++) {
855       tranches[i].amount = _tranches[i*2];
856       tranches[i].price = _tranches[i*2+1];
857 
858       // No invalid steps
859       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
860         throw;
861       }
862 
863       highestAmount = tranches[i].amount;
864     }
865 
866     // We need to start from zero, otherwise we blow up our deployment
867     if(tranches[0].amount != 0) {
868       throw;
869     }
870 
871     // Last tranche price must be zero, terminating the crowdale
872     if(tranches[trancheCount-1].price != 0) {
873       throw;
874     }
875   }
876 
877   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
878   ///      to 0 to disable
879   /// @param preicoAddress PresaleFundCollector address
880   /// @param pricePerToken How many weis one token cost for pre-ico investors
881   function setPreicoAddress(address preicoAddress, uint pricePerToken)
882     public
883     onlyOwner
884   {
885     preicoAddresses[preicoAddress] = pricePerToken;
886   }
887 
888   /// @dev Iterate through tranches. You reach end of tranches when price = 0
889   /// @return tuple (time, price)
890   function getTranche(uint n) public constant returns (uint, uint) {
891     return (tranches[n].amount, tranches[n].price);
892   }
893 
894   function getFirstTranche() private constant returns (Tranche) {
895     return tranches[0];
896   }
897 
898   function getLastTranche() private constant returns (Tranche) {
899     return tranches[trancheCount-1];
900   }
901 
902   function getPricingStartsAt() public constant returns (uint) {
903     return getFirstTranche().amount;
904   }
905 
906   function getPricingEndsAt() public constant returns (uint) {
907     return getLastTranche().amount;
908   }
909 
910   function isSane(address _crowdsale) public constant returns(bool) {
911     // Our tranches are not bound by time, so we can't really check are we sane
912     // so we presume we are ;)
913     // In the future we could save and track raised tokens, and compare it to
914     // the Crowdsale contract.
915     return true;
916   }
917 
918   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
919   /// @param weiRaised total amount of weis raised, for calculating the current tranche
920   /// @return {[type]} [description]
921   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
922     uint i;
923 
924     for(i=0; i < tranches.length; i++) {
925       if(weiRaised < tranches[i].amount) {
926         return tranches[i-1];
927       }
928     }
929   }
930 
931   /// @dev Get the current price.
932   /// @param weiRaised total amount of weis raised, for calculating the current tranche
933   /// @return The current price or 0 if we are outside trache ranges
934   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
935     return getCurrentTranche(weiRaised).price;
936   }
937 
938   function isPresalePurchase(address purchaser) public constant returns (bool) {
939     if(preicoAddresses[purchaser] > 0)
940       return true;
941     else
942       return false;
943   }
944 
945   /// @dev Calculate the current price for buy in amount.
946   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
947 
948     uint multiplier = 10 ** decimals;
949 
950     // This investor is coming through pre-ico
951     if(preicoAddresses[msgSender] > 0) {
952       return value.times(multiplier) / preicoAddresses[msgSender];
953     }
954 
955     uint price = getCurrentPrice(weiRaised);
956     return value.times(multiplier) / price;
957   }
958 
959   function() payable {
960     throw; // No money on this contract
961   }
962 
963 }