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
114     require(!halted);
115     _;
116   }
117 
118   modifier stopNonOwnersInEmergency {
119     require(!halted || msg.sender == owner);
120     _;
121   }
122 
123   modifier onlyInEmergency {
124     require(halted);
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
382     require(_multisigWallet != 0);
383     require(_start != 0 && _end != 0);
384 
385     // Don't mess the dates
386     require(_start < _end);
387 
388     owner = msg.sender;
389 
390     token = FractionalERC20(_token);
391 
392     setPricingStrategy(_pricingStrategy);
393 
394     multisigWallet = _multisigWallet;
395     startsAt = _start;
396 
397     endsAt = _end;
398 
399     // Minimum funding goal can be zero
400     minimumFundingGoal = _minimumFundingGoal;
401   }
402 
403   /**
404    * Do expect to just send in money and get tokens.
405    */
406   function() payable {
407     buy();
408   }
409 
410   /**
411    * Make an investment.
412    *
413    * Crowdsale must be running for one to invest.
414    * We must have not pressed the emergency brake.
415    *
416    * @param receiver The Ethereum address who receives the tokens
417    * @param customerId (optional) UUID v4 to track the successful payments on the server side
418    *
419    */
420   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
421 
422     // Determine if it's a good time to accept investment from this participant
423     if(getState() == State.PreFunding) {
424       // Are we whitelisted for early deposit
425       require(earlyParticipantWhitelist[receiver]);
426     } else if(getState() == State.Funding) {
427       // Retail participants can only come in when the crowdsale is running
428       // pass
429     } else {
430       // Unwanted state
431       assert(false);
432     }
433 
434     uint weiAmount = msg.value;
435 
436     // Account presale sales separately, so that they do not count against pricing tranches
437     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
438 
439     require(tokenAmount != 0); // Dust transaction
440 
441     if(investedAmountOf[receiver] == 0) {
442        // A new investor
443        investorCount++;
444     }
445 
446     // Update investor
447     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
448     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
449 
450     // Update totals
451     weiRaised = weiRaised.plus(weiAmount);
452     tokensSold = tokensSold.plus(tokenAmount);
453 
454     if(pricingStrategy.isPresalePurchase(receiver)) {
455         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
456     }
457 
458     // Check that we did not bust the cap
459     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
460 
461     assignTokens(receiver, tokenAmount);
462 
463     // Pocket the money
464     require(multisigWallet.send(weiAmount));
465 
466     // Tell us invest was success
467     Invested(receiver, weiAmount, tokenAmount, customerId);
468   }
469 
470   /**
471    * Preallocate tokens for the early investors.
472    *
473    * Preallocated tokens have been sold before the actual crowdsale opens.
474    * This function mints the tokens and moves the crowdsale needle.
475    *
476    * Investor count is not handled; it is assumed this goes for multiple investors
477    * and the token distribution happens outside the smart contract flow.
478    *
479    * No money is exchanged, as the crowdsale team already have received the payment.
480    *
481    * @param fullTokens tokens as full tokens - decimal places added internally
482    * @param weiPrice Price of a single full token in wei
483    *
484    */
485   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
486 
487     uint tokenAmount = fullTokens * 10**token.decimals();
488     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
489 
490     weiRaised = weiRaised.plus(weiAmount);
491     tokensSold = tokensSold.plus(tokenAmount);
492 
493     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
494     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
495 
496     assignTokens(receiver, tokenAmount);
497 
498     // Tell us invest was success
499     Invested(receiver, weiAmount, tokenAmount, 0);
500   }
501 
502   /**
503    * Allow anonymous contributions to this crowdsale.
504    */
505   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
506      bytes32 hash = sha256(addr);
507      require(ecrecover(hash, v, r, s) == signerAddress);
508      require(customerId != 0);  // UUIDv4 sanity check
509      investInternal(addr, customerId);
510   }
511 
512   /**
513    * Track who is the customer making the payment so we can send thank you email.
514    */
515   function investWithCustomerId(address addr, uint128 customerId) public payable {
516     require(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
517     require(customerId != 0);  // UUIDv4 sanity check
518     investInternal(addr, customerId);
519   }
520 
521   /**
522    * Allow anonymous contributions to this crowdsale.
523    */
524   function invest(address addr) public payable {
525     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
526     require(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
527     investInternal(addr, 0);
528   }
529 
530   /**
531    * Invest to tokens, recognize the payer and clear his address.
532    *
533    */
534   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
535     investWithSignedAddress(msg.sender, customerId, v, r, s);
536   }
537 
538   /**
539    * Invest to tokens, recognize the payer.
540    *
541    */
542   function buyWithCustomerId(uint128 customerId) public payable {
543     investWithCustomerId(msg.sender, customerId);
544   }
545 
546   /**
547    * The basic entry point to participate the crowdsale process.
548    *
549    * Pay for funding, get invested tokens back in the sender address.
550    */
551   function buy() public payable {
552     invest(msg.sender);
553   }
554 
555   /**
556    * Finalize a succcesful crowdsale.
557    *
558    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
559    */
560   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
561 
562     // Already finalized
563     require(!finalized);
564 
565     // Finalizing is optional. We only call it if we are given a finalizing agent.
566     if(address(finalizeAgent) != 0) {
567       finalizeAgent.finalizeCrowdsale();
568     }
569 
570     finalized = true;
571   }
572 
573   /**
574    * Allow to (re)set finalize agent.
575    *
576    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
577    */
578   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
579 
580     // Don't allow setting bad agent
581     require(addr.isFinalizeAgent());
582     finalizeAgent = addr;
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
628     require(now <= time); // Don't change past
629 
630     endsAt = time;
631     EndsAtChanged(endsAt);
632   }
633 
634   /**
635    * Allow to (re)set pricing strategy.
636    *
637    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
638    */
639   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
640 
641     // Don't allow setting bad agent
642     require(_pricingStrategy.isPricingStrategy());
643     pricingStrategy = _pricingStrategy;
644   }
645 
646   /**
647    * Allow to change the team multisig address in the case of emergency.
648    *
649    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
650    * (we have done only few test transactions). After the crowdsale is going
651    * then multisig address stays locked for the safety reasons.
652    */
653   function setMultisig(address addr) public onlyOwner {
654 
655     // Change
656     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
657 
658     multisigWallet = addr;
659   }
660 
661   /**
662    * Allow load refunds back on the contract for the refunding.
663    *
664    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
665    */
666   function loadRefund() public payable inState(State.Failure) {
667     require(msg.value != 0);
668     loadedRefund = loadedRefund.plus(msg.value);
669   }
670 
671   /**
672    * Investors can claim refund.
673    *
674    * Note that any refunds from proxy buyers should be handled separately,
675    * and not through this contract.
676    */
677   function refund() public inState(State.Refunding) {
678     uint256 weiValue = investedAmountOf[msg.sender];
679     require(weiValue != 0);
680     investedAmountOf[msg.sender] = 0;
681     weiRefunded = weiRefunded.plus(weiValue);
682     Refund(msg.sender, weiValue);
683     require(msg.sender.send(weiValue));
684   }
685 
686   /**
687    * @return true if the crowdsale has raised enough money to be a successful.
688    */
689   function isMinimumGoalReached() public constant returns (bool reached) {
690     return weiRaised >= minimumFundingGoal;
691   }
692 
693   /**
694    * Check if the contract relationship looks good.
695    */
696   function isFinalizerSane() public constant returns (bool sane) {
697     return finalizeAgent.isSane();
698   }
699 
700   /**
701    * Check if the contract relationship looks good.
702    */
703   function isPricingSane() public constant returns (bool sane) {
704     return pricingStrategy.isSane(address(this));
705   }
706 
707   /**
708    * Crowdfund state machine management.
709    *
710    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
711    */
712   function getState() public constant returns (State) {
713     if(finalized) return State.Finalized;
714     else if (address(finalizeAgent) == 0) return State.Preparing;
715     else if (!finalizeAgent.isSane()) return State.Preparing;
716     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
717     else if (block.timestamp < startsAt) return State.PreFunding;
718     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
719     else if (isMinimumGoalReached()) return State.Success;
720     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
721     else return State.Failure;
722   }
723 
724   /** This is for manual testing of multisig wallet interaction */
725   function setOwnerTestValue(uint val) onlyOwner {
726     ownerTestValue = val;
727   }
728 
729   /** Interface marker. */
730   function isCrowdsale() public constant returns (bool) {
731     return true;
732   }
733 
734   //
735   // Modifiers
736   //
737 
738   /** Modified allowing execution only if the crowdsale is currently running.  */
739   modifier inState(State state) {
740     require(getState() == state);
741     _;
742   }
743 
744 
745   //
746   // Abstract functions
747   //
748 
749   /**
750    * Check if the current invested breaks our cap rules.
751    *
752    *
753    * The child contract must define their own cap setting rules.
754    * We allow a lot of flexibility through different capping strategies (ETH, token count)
755    * Called from invest().
756    *
757    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
758    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
759    * @param weiRaisedTotal What would be our total raised balance after this transaction
760    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
761    *
762    * @return true if taking this investment would break our cap rules
763    */
764   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
765 
766   /**
767    * Check if the current crowdsale is full and we can no longer sell any tokens.
768    */
769   function isCrowdsaleFull() public constant returns (bool);
770 
771   /**
772    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
773    */
774   function assignTokens(address receiver, uint tokenAmount) private;
775 }
776 
777 
778 /**
779  * A crowdsale that is selling tokens from a preallocated pool
780  *
781  *
782  * - Tokens have precreated supply "premined"
783  *
784  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
785  *
786  */
787 contract AllocatedCrowdsale is Crowdsale {
788 
789   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
790   address public beneficiary;
791 
792   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
793     beneficiary = _beneficiary;
794   }
795 
796   /**
797    * Called from invest() to confirm if the curret investment does not break our cap rule.
798    */
799   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
800     if(tokenAmount > getTokensLeft()) {
801       return true;
802     } else {
803       return false;
804     }
805   }
806 
807   /**
808    * We are sold out when our approve pool becomes empty.
809    */
810   function isCrowdsaleFull() public constant returns (bool) {
811     return getTokensLeft() == 0;
812   }
813 
814   /**
815    * Get the amount of unsold tokens allocated to this contract;
816    */
817   function getTokensLeft() public constant returns (uint) {
818     return token.allowance(owner, this);
819   }
820 
821   /**
822    * Transfer tokens from approve() pool to the buyer.
823    *
824    * Use approve() given to this crowdsale to distribute the tokens.
825    */
826   function assignTokens(address receiver, uint tokenAmount) private {
827     require(token.transferFrom(beneficiary, receiver, tokenAmount));
828   }
829 }