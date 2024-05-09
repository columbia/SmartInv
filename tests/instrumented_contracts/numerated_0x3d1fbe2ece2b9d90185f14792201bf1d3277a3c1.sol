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
23  * Safe unsigned safe math.
24  *
25  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
26  *
27  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
28  *
29  * Maintained here until merged to mainline zeppelin-solidity.
30  *
31  */
32 library SafeMathLib {
33 
34   function times(uint a, uint b) returns (uint) {
35     uint c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function minus(uint a, uint b) returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function plus(uint a, uint b) returns (uint) {
46     uint c = a + b;
47     assert(c>=a);
48     return c;
49   }
50 
51 }
52 
53 /**
54  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
55  *
56  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
57  */
58 
59 
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner {
94     require(newOwner != address(0));      
95     owner = newOwner;
96   }
97 
98 }
99 
100 
101 /*
102  * Haltable
103  *
104  * Abstract contract that allows children to implement an
105  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
106  *
107  *
108  * Originally envisioned in FirstBlood ICO contract.
109  */
110 contract Haltable is Ownable {
111   bool public halted;
112 
113   modifier stopInEmergency {
114     if (halted) throw;
115     _;
116   }
117 
118   modifier stopNonOwnersInEmergency {
119     if (halted && msg.sender != owner) throw;
120     _;
121   }
122 
123   modifier onlyInEmergency {
124     if (!halted) throw;
125     _;
126   }
127 
128   // called by the owner on emergency, triggers stopped state
129   function halt() external onlyOwner {
130     halted = true;
131   }
132 
133   // called by the owner on end of emergency, returns to normal state
134   function unhalt() external onlyOwner onlyInEmergency {
135     halted = false;
136   }
137 
138 }
139 
140 /**
141  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
142  *
143  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
144  */
145 
146 
147 /**
148  * Interface for defining crowdsale pricing.
149  */
150 contract PricingStrategy {
151 
152   /** Interface declaration. */
153   function isPricingStrategy() public constant returns (bool) {
154     return true;
155   }
156 
157   /** Self check if all references are correctly set.
158    *
159    * Checks that pricing strategy matches crowdsale parameters.
160    */
161   function isSane(address crowdsale) public constant returns (bool) {
162     return true;
163   }
164 
165   /**
166    * @dev Pricing tells if this is a presale purchase or not.
167      @param purchaser Address of the purchaser
168      @return False by default, true if a presale purchaser
169    */
170   function isPresalePurchase(address purchaser) public constant returns (bool) {
171     return false;
172   }
173 
174   /**
175    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
176    *
177    *
178    * @param value - What is the value of the transaction send in as wei
179    * @param tokensSold - how much tokens have been sold this far
180    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
181    * @param msgSender - who is the investor of this transaction
182    * @param decimals - how many decimal units the token has
183    * @return Amount of tokens the investor receives
184    */
185   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
186 }
187 
188 /**
189  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
190  *
191  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
192  */
193 
194 
195 /**
196  * Finalize agent defines what happens at the end of succeseful crowdsale.
197  *
198  * - Allocate tokens for founders, bounties and community
199  * - Make tokens transferable
200  * - etc.
201  */
202 contract FinalizeAgent {
203 
204   function isFinalizeAgent() public constant returns(bool) {
205     return true;
206   }
207 
208   /** Return true if we can run finalizeCrowdsale() properly.
209    *
210    * This is a safety check function that doesn't allow crowdsale to begin
211    * unless the finalizer has been set up properly.
212    */
213   function isSane() public constant returns (bool);
214 
215   /** Called once by crowdsale finalize() if the sale was success. */
216   function finalizeCrowdsale();
217 
218 }
219 
220 /**
221  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
222  *
223  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
224  */
225 
226 
227 
228 
229 
230 
231 /**
232  * @title ERC20Basic
233  * @dev Simpler version of ERC20 interface
234  * @dev see https://github.com/ethereum/EIPs/issues/179
235  */
236 contract ERC20Basic {
237   uint256 public totalSupply;
238   function balanceOf(address who) constant returns (uint256);
239   function transfer(address to, uint256 value) returns (bool);
240   event Transfer(address indexed from, address indexed to, uint256 value);
241 }
242 
243 
244 
245 /**
246  * @title ERC20 interface
247  * @dev see https://github.com/ethereum/EIPs/issues/20
248  */
249 contract ERC20 is ERC20Basic {
250   function allowance(address owner, address spender) constant returns (uint256);
251   function transferFrom(address from, address to, uint256 value) returns (bool);
252   function approve(address spender, uint256 value) returns (bool);
253   event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 
257 /**
258  * A token that defines fractional units as decimals.
259  */
260 contract FractionalERC20 is ERC20 {
261 
262   uint public decimals;
263 
264 }
265 
266 
267 
268 /**
269  * Abstract base contract for token sales.
270  *
271  * Handle
272  * - start and end dates
273  * - accepting investments
274  * - minimum funding goal and refund
275  * - various statistics during the crowdfund
276  * - different pricing strategies
277  * - different investment policies (require server side customer id, allow only whitelisted addresses)
278  *
279  */
280 contract Crowdsale is Haltable {
281 
282   /* Max investment count when we are still allowed to change the multisig address */
283   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
284 
285   using SafeMathLib for uint;
286 
287   /* The token we are selling */
288   FractionalERC20 public token;
289 
290   /* How we are going to price our offering */
291   PricingStrategy public pricingStrategy;
292 
293   /* Post-success callback */
294   FinalizeAgent public finalizeAgent;
295 
296   /* tokens will be transfered from this address */
297   address public multisigWallet;
298 
299   /* if the funding goal is not reached, investors may withdraw their funds */
300   uint public minimumFundingGoal;
301 
302   /* the UNIX timestamp start date of the crowdsale */
303   uint public startsAt;
304 
305   /* the UNIX timestamp end date of the crowdsale */
306   uint public endsAt;
307 
308   /* the number of tokens already sold through this contract*/
309   uint public tokensSold = 0;
310 
311   /* How many wei of funding we have raised */
312   uint public weiRaised = 0;
313 
314   /* Calculate incoming funds from presale contracts and addresses */
315   uint public presaleWeiRaised = 0;
316 
317   /* How many distinct addresses have invested */
318   uint public investorCount = 0;
319 
320   /* How much wei we have returned back to the contract after a failed crowdfund. */
321   uint public loadedRefund = 0;
322 
323   /* How much wei we have given back to investors.*/
324   uint public weiRefunded = 0;
325 
326   /* Has this crowdsale been finalized */
327   bool public finalized;
328 
329   /* Do we need to have unique contributor id for each customer */
330   bool public requireCustomerId;
331 
332   /**
333     * Do we verify that contributor has been cleared on the server side (accredited investors only).
334     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
335     */
336   bool public requiredSignedAddress;
337 
338   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
339   address public signerAddress;
340 
341   /** How much ETH each address has invested to this crowdsale */
342   mapping (address => uint256) public investedAmountOf;
343 
344   /** How much tokens this crowdsale has credited for each investor address */
345   mapping (address => uint256) public tokenAmountOf;
346 
347   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
348   mapping (address => bool) public earlyParticipantWhitelist;
349 
350   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
351   uint public ownerTestValue;
352 
353   /** State machine
354    *
355    * - Preparing: All contract initialization calls and variables have not been set yet
356    * - Prefunding: We have not passed start time yet
357    * - Funding: Active crowdsale
358    * - Success: Minimum funding goal reached
359    * - Failure: Minimum funding goal not reached before ending time
360    * - Finalized: The finalized has been called and succesfully executed
361    * - Refunding: Refunds are loaded on the contract for reclaim.
362    */
363   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
364 
365   // A new investment was made
366   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
367 
368   // Refund was processed for a contributor
369   event Refund(address investor, uint weiAmount);
370 
371   // The rules were changed what kind of investments we accept
372   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
373 
374   // Address early participation whitelist status changed
375   event Whitelisted(address addr, bool status);
376 
377   // Crowdsale end time has been changed
378   event EndsAtChanged(uint newEndsAt);
379 
380   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
381 
382     owner = msg.sender;
383 
384     token = FractionalERC20(_token);
385 
386     setPricingStrategy(_pricingStrategy);
387 
388     multisigWallet = _multisigWallet;
389     if(multisigWallet == 0) {
390         throw;
391     }
392 
393     if(_start == 0) {
394         throw;
395     }
396 
397     startsAt = _start;
398 
399     if(_end == 0) {
400         throw;
401     }
402 
403     endsAt = _end;
404 
405     // Don't mess the dates
406     if(startsAt >= endsAt) {
407         throw;
408     }
409 
410     // Minimum funding goal can be zero
411     minimumFundingGoal = _minimumFundingGoal;
412   }
413 
414   /**
415    * Don't expect to just send in money and get tokens.
416    */
417   function() payable {
418     throw;
419   }
420 
421   /**
422    * Make an investment.
423    *
424    * Crowdsale must be running for one to invest.
425    * We must have not pressed the emergency brake.
426    *
427    * @param receiver The Ethereum address who receives the tokens
428    * @param customerId (optional) UUID v4 to track the successful payments on the server side
429    *
430    */
431   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
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
452     if(tokenAmount == 0) {
453       // Dust transaction
454       throw;
455     }
456 
457     if(investedAmountOf[receiver] == 0) {
458        // A new investor
459        investorCount++;
460     }
461 
462     // Update investor
463     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
464     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
465 
466     // Update totals
467     weiRaised = weiRaised.plus(weiAmount);
468     tokensSold = tokensSold.plus(tokenAmount);
469 
470     if(pricingStrategy.isPresalePurchase(receiver)) {
471         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
472     }
473 
474     // Check that we did not bust the cap
475     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
476       throw;
477     }
478 
479     assignTokens(receiver, tokenAmount);
480 
481     // Pocket the money
482     if(!multisigWallet.send(weiAmount)) throw;
483 
484     // Tell us invest was success
485     Invested(receiver, weiAmount, tokenAmount, customerId);
486   }
487 
488   /**
489    * Preallocate tokens for the early investors.
490    *
491    * Preallocated tokens have been sold before the actual crowdsale opens.
492    * This function mints the tokens and moves the crowdsale needle.
493    *
494    * Investor count is not handled; it is assumed this goes for multiple investors
495    * and the token distribution happens outside the smart contract flow.
496    *
497    * No money is exchanged, as the crowdsale team already have received the payment.
498    *
499    * @param fullTokens tokens as full tokens - decimal places added internally
500    * @param weiPrice Price of a single full token in wei
501    *
502    */
503   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
504 
505     uint tokenAmount = fullTokens * 10**token.decimals();
506     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
507 
508     weiRaised = weiRaised.plus(weiAmount);
509     tokensSold = tokensSold.plus(tokenAmount);
510 
511     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
512     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
513 
514     assignTokens(receiver, tokenAmount);
515 
516     // Tell us invest was success
517     Invested(receiver, weiAmount, tokenAmount, 0);
518   }
519 
520   /**
521    * Allow anonymous contributions to this crowdsale.
522    */
523   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
524      bytes32 hash = sha256(addr);
525      if (ecrecover(hash, v, r, s) != signerAddress) throw;
526      if(customerId == 0) throw;  // UUIDv4 sanity check
527      investInternal(addr, customerId);
528   }
529 
530   /**
531    * Track who is the customer making the payment so we can send thank you email.
532    */
533   function investWithCustomerId(address addr, uint128 customerId) public payable {
534     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
535     if(customerId == 0) throw;  // UUIDv4 sanity check
536     investInternal(addr, customerId);
537   }
538 
539   /**
540    * Allow anonymous contributions to this crowdsale.
541    */
542   function invest(address addr) public payable {
543     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
544     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
545     investInternal(addr, 0);
546   }
547 
548   /**
549    * Invest to tokens, recognize the payer and clear his address.
550    *
551    */
552   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
553     investWithSignedAddress(msg.sender, customerId, v, r, s);
554   }
555 
556   /**
557    * Invest to tokens, recognize the payer.
558    *
559    */
560   function buyWithCustomerId(uint128 customerId) public payable {
561     investWithCustomerId(msg.sender, customerId);
562   }
563 
564   /**
565    * The basic entry point to participate the crowdsale process.
566    *
567    * Pay for funding, get invested tokens back in the sender address.
568    */
569   function buy() public payable {
570     invest(msg.sender);
571   }
572 
573   /**
574    * Finalize a succcesful crowdsale.
575    *
576    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
577    */
578   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
579 
580     // Already finalized
581     if(finalized) {
582       throw;
583     }
584 
585     // Finalizing is optional. We only call it if we are given a finalizing agent.
586     if(address(finalizeAgent) != 0) {
587       finalizeAgent.finalizeCrowdsale();
588     }
589 
590     finalized = true;
591   }
592 
593   /**
594    * Allow to (re)set finalize agent.
595    *
596    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
597    */
598   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
599     finalizeAgent = addr;
600 
601     // Don't allow setting bad agent
602     if(!finalizeAgent.isFinalizeAgent()) {
603       throw;
604     }
605   }
606 
607   /**
608    * Set policy do we need to have server-side customer ids for the investments.
609    *
610    */
611   function setRequireCustomerId(bool value) onlyOwner {
612     requireCustomerId = value;
613     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
614   }
615 
616   /**
617    * Set policy if all investors must be cleared on the server side first.
618    *
619    * This is e.g. for the accredited investor clearing.
620    *
621    */
622   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
623     requiredSignedAddress = value;
624     signerAddress = _signerAddress;
625     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
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
638   /**
639    * Allow crowdsale owner to close early or extend the crowdsale.
640    *
641    * This is useful e.g. for a manual soft cap implementation:
642    * - after X amount is reached determine manual closing
643    *
644    * This may put the crowdsale to an invalid state,
645    * but we trust owners know what they are doing.
646    *
647    */
648   function setEndsAt(uint time) onlyOwner {
649 
650     if(now > time) {
651       throw; // Don't change past
652     }
653 
654     endsAt = time;
655     EndsAtChanged(endsAt);
656   }
657 
658   /**
659    * Allow to (re)set pricing strategy.
660    *
661    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
662    */
663   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
664     pricingStrategy = _pricingStrategy;
665 
666     // Don't allow setting bad agent
667     if(!pricingStrategy.isPricingStrategy()) {
668       throw;
669     }
670   }
671 
672   /**
673    * Allow to change the team multisig address in the case of emergency.
674    *
675    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
676    * (we have done only few test transactions). After the crowdsale is going
677    * then multisig address stays locked for the safety reasons.
678    */
679   function setMultisig(address addr) public onlyOwner {
680 
681     // Change
682     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
683       throw;
684     }
685 
686     multisigWallet = addr;
687   }
688 
689   /**
690    * Allow load refunds back on the contract for the refunding.
691    *
692    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
693    */
694   function loadRefund() public payable inState(State.Failure) {
695     if(msg.value == 0) throw;
696     loadedRefund = loadedRefund.plus(msg.value);
697   }
698 
699   /**
700    * Investors can claim refund.
701    *
702    * Note that any refunds from proxy buyers should be handled separately,
703    * and not through this contract.
704    */
705   function refund() public inState(State.Refunding) {
706     uint256 weiValue = investedAmountOf[msg.sender];
707     if (weiValue == 0) throw;
708     investedAmountOf[msg.sender] = 0;
709     weiRefunded = weiRefunded.plus(weiValue);
710     Refund(msg.sender, weiValue);
711     if (!msg.sender.send(weiValue)) throw;
712   }
713 
714   /**
715    * @return true if the crowdsale has raised enough money to be a successful.
716    */
717   function isMinimumGoalReached() public constant returns (bool reached) {
718     return weiRaised >= minimumFundingGoal;
719   }
720 
721   /**
722    * Check if the contract relationship looks good.
723    */
724   function isFinalizerSane() public constant returns (bool sane) {
725     return finalizeAgent.isSane();
726   }
727 
728   /**
729    * Check if the contract relationship looks good.
730    */
731   function isPricingSane() public constant returns (bool sane) {
732     return pricingStrategy.isSane(address(this));
733   }
734 
735   /**
736    * Crowdfund state machine management.
737    *
738    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
739    */
740   function getState() public constant returns (State) {
741     if(finalized) return State.Finalized;
742     else if (address(finalizeAgent) == 0) return State.Preparing;
743     else if (!finalizeAgent.isSane()) return State.Preparing;
744     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
745     else if (block.timestamp < startsAt) return State.PreFunding;
746     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
747     else if (isMinimumGoalReached()) return State.Success;
748     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
749     else return State.Failure;
750   }
751 
752   /** This is for manual testing of multisig wallet interaction */
753   function setOwnerTestValue(uint val) onlyOwner {
754     ownerTestValue = val;
755   }
756 
757   /** Interface marker. */
758   function isCrowdsale() public constant returns (bool) {
759     return true;
760   }
761 
762   //
763   // Modifiers
764   //
765 
766   /** Modified allowing execution only if the crowdsale is currently running.  */
767   modifier inState(State state) {
768     if(getState() != state) throw;
769     _;
770   }
771 
772 
773   //
774   // Abstract functions
775   //
776 
777   /**
778    * Check if the current invested breaks our cap rules.
779    *
780    *
781    * The child contract must define their own cap setting rules.
782    * We allow a lot of flexibility through different capping strategies (ETH, token count)
783    * Called from invest().
784    *
785    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
786    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
787    * @param weiRaisedTotal What would be our total raised balance after this transaction
788    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
789    *
790    * @return true if taking this investment would break our cap rules
791    */
792   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
793 
794   /**
795    * Check if the current crowdsale is full and we can no longer sell any tokens.
796    */
797   function isCrowdsaleFull() public constant returns (bool);
798 
799   /**
800    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
801    */
802   function assignTokens(address receiver, uint tokenAmount) private;
803 }
804 
805 
806 /**
807  * A crowdsale that is selling tokens from a preallocated pool
808  *
809  *
810  * - Tokens have precreated supply "premined"
811  *
812  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
813  *
814  */
815 contract AllocatedCrowdsale is Crowdsale {
816 
817   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
818   address public beneficiary;
819 
820   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
821     beneficiary = _beneficiary;
822   }
823 
824   /**
825    * Called from invest() to confirm if the curret investment does not break our cap rule.
826    */
827   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
828     if(tokenAmount > getTokensLeft()) {
829       return true;
830     } else {
831       return false;
832     }
833   }
834 
835   /**
836    * We are sold out when our approve pool becomes empty.
837    */
838   function isCrowdsaleFull() public constant returns (bool) {
839     return getTokensLeft() == 0;
840   }
841 
842   /**
843    * Get the amount of unsold tokens allocated to this contract;
844    */
845   function getTokensLeft() public constant returns (uint) {
846     return token.allowance(owner, this);
847   }
848 
849   /**
850    * Transfer tokens from approve() pool to the buyer.
851    *
852    * Use approve() given to this crowdsale to distribute the tokens.
853    */
854   function assignTokens(address receiver, uint tokenAmount) private {
855     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
856   }
857 }