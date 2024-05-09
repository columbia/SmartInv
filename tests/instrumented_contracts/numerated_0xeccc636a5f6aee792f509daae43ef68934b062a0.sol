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
314   /* How many distinct addresses have invested */
315   uint public investorCount = 0;
316 
317   /* How much wei we have returned back to the contract after a failed crowdfund. */
318   uint public loadedRefund = 0;
319 
320   /* How much wei we have given back to investors.*/
321   uint public weiRefunded = 0;
322 
323   /* Has this crowdsale been finalized */
324   bool public finalized;
325 
326   /* Do we need to have unique contributor id for each customer */
327   bool public requireCustomerId;
328 
329   /**
330     * Do we verify that contributor has been cleared on the server side (accredited investors only).
331     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
332     */
333   bool public requiredSignedAddress;
334 
335   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
336   address public signerAddress;
337 
338   /** How much ETH each address has invested to this crowdsale */
339   mapping (address => uint256) public investedAmountOf;
340 
341   /** How much tokens this crowdsale has credited for each investor address */
342   mapping (address => uint256) public tokenAmountOf;
343 
344   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
345   uint public ownerTestValue;
346 
347   /** State machine
348    *
349    * - Preparing: All contract initialization calls and variables have not been set yet
350    * - Prefunding: We have not passed start time yet
351    * - Funding: Active crowdsale
352    * - Success: Minimum funding goal reached
353    * - Failure: Minimum funding goal not reached before ending time
354    * - Finalized: The finalized has been called and succesfully executed
355    * - Refunding: Refunds are loaded on the contract for reclaim.
356    */
357   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
358 
359   // A new investment was made
360   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
361 
362   // Refund was processed for a contributor
363   event Refund(address investor, uint weiAmount);
364 
365   // The rules were changed what kind of investments we accept
366   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
367 
368   // Crowdsale end time has been changed
369   event EndsAtChanged(uint newEndsAt);
370 
371   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
372 
373     owner = msg.sender;
374 
375     token = FractionalERC20(_token);
376 
377     setPricingStrategy(_pricingStrategy);
378 
379     multisigWallet = _multisigWallet;
380     if(multisigWallet == 0) {
381         throw;
382     }
383 
384     if(_start == 0) {
385         throw;
386     }
387 
388     startsAt = _start;
389 
390     if(_end == 0) {
391         throw;
392     }
393 
394     endsAt = _end;
395 
396     // Don't mess the dates
397     if(startsAt >= endsAt) {
398         throw;
399     }
400 
401     // Minimum funding goal can be zero
402     minimumFundingGoal = _minimumFundingGoal;
403   }
404 
405   /**
406    * Don't expect to just send in money and get tokens.
407    */
408   function() payable {
409     invest(msg.sender);
410   }
411 
412   function buyWithReferral(uint128 customerId) payable {
413     investWithCustomerId(msg.sender, customerId);
414   }
415 
416   /**
417    * Make an investment.
418    *
419    * Crowdsale must be running for one to invest.
420    * We must have not pressed the emergency brake.
421    *
422    * @param receiver The Ethereum address who receives the tokens
423    * @param customerId (optional) UUID v4 to track the successful payments on the server side
424    *
425    */
426   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
427 
428     // Determine if it's a good time to accept investment from this participant
429     if(getState() == State.Funding) {
430       // Retail participants can only come in when the crowdsale is running
431       // pass
432     } else {
433       // Unwanted state
434       throw;
435     }
436 
437     uint weiAmount = msg.value;
438 
439     // Account presale sales separately, so that they do not count against pricing tranches
440     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
441 
442     if(tokenAmount == 0) {
443       // Dust transaction
444       throw;
445     }
446 
447     if (investedAmountOf[receiver] == 0) {
448        // A new investor
449        investorCount++;
450     }
451 
452     // Update investor
453     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
454     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
455 
456     // Update totals
457     weiRaised = weiRaised.plus(weiAmount);
458     tokensSold = tokensSold.plus(tokenAmount);
459 
460     // Check that we did not bust the cap
461     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
462       throw;
463     }
464 
465     assignTokens(receiver, tokenAmount);
466 
467     // Pocket the money
468     if(!multisigWallet.send(weiAmount)) throw;
469 
470     // Tell us invest was success
471     Invested(receiver, weiAmount, tokenAmount, customerId);
472   }
473 
474   /**
475    * Preallocate tokens for the early investors.
476    *
477    * Preallocated tokens have been sold before the actual crowdsale opens.
478    * This function mints the tokens and moves the crowdsale needle.
479    *
480    * Investor count is not handled; it is assumed this goes for multiple investors
481    * and the token distribution happens outside the smart contract flow.
482    *
483    * No money is exchanged, as the crowdsale team already have received the payment.
484    *
485    * @param fullTokens tokens as full tokens - decimal places added internally
486    * @param weiPrice Price of a single full token in wei
487    *
488    */
489   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
490 
491     uint tokenAmount = fullTokens * 10**token.decimals();
492     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
493 
494     weiRaised = weiRaised.plus(weiAmount);
495     tokensSold = tokensSold.plus(tokenAmount);
496 
497     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
498     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
499 
500     assignTokens(receiver, tokenAmount);
501 
502     // Tell us invest was success
503     Invested(receiver, weiAmount, tokenAmount, 0);
504   }
505 
506   /**
507    * Allow anonymous contributions to this crowdsale.
508    */
509   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
510      bytes32 hash = sha256(addr);
511      if (ecrecover(hash, v, r, s) != signerAddress) throw;
512      if(customerId == 0) throw;  // UUIDv4 sanity check
513      investInternal(addr, customerId);
514   }
515 
516   /**
517    * Track who is the customer making the payment so we can send thank you email.
518    */
519   function investWithCustomerId(address addr, uint128 customerId) public payable {
520     if (requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
521     if (customerId == 0) throw;  // UUIDv4 sanity check
522     investInternal(addr, customerId);
523   }
524 
525   /**
526    * Allow anonymous contributions to this crowdsale.
527    */
528   function invest(address addr) public payable {
529     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
530     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
531     investInternal(addr, 0);
532   }
533 
534   /**
535    * Invest to tokens, recognize the payer and clear his address.
536    *
537    */
538   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
539     investWithSignedAddress(msg.sender, customerId, v, r, s);
540   }
541 
542   /**
543    * Invest to tokens, recognize the payer.
544    *
545    */
546   function buyWithCustomerId(uint128 customerId) public payable {
547     investWithCustomerId(msg.sender, customerId);
548   }
549 
550   /**
551    * The basic entry point to participate the crowdsale process.
552    *
553    * Pay for funding, get invested tokens back in the sender address.
554    */
555   function buy() public payable {
556     invest(msg.sender);
557   }
558 
559   /**
560    * Finalize a succcesful crowdsale.
561    *
562    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
563    */
564   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
565 
566     // Already finalized
567     if(finalized) {
568       throw;
569     }
570 
571     // Finalizing is optional. We only call it if we are given a finalizing agent.
572     if(address(finalizeAgent) != 0) {
573       finalizeAgent.finalizeCrowdsale();
574     }
575 
576     finalized = true;
577   }
578 
579   /**
580    * Allow to (re)set finalize agent.
581    *
582    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
583    */
584   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
585     finalizeAgent = addr;
586 
587     // Don't allow setting bad agent
588     if(!finalizeAgent.isFinalizeAgent()) {
589       throw;
590     }
591   }
592 
593   /**
594    * Set policy do we need to have server-side customer ids for the investments.
595    *
596    */
597   function setRequireCustomerId(bool value) onlyOwner {
598     requireCustomerId = value;
599     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
600   }
601 
602   /**
603    * Set policy if all investors must be cleared on the server side first.
604    *
605    * This is e.g. for the accredited investor clearing.
606    *
607    */
608   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
609     requiredSignedAddress = value;
610     signerAddress = _signerAddress;
611     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
612   }
613 
614   /**
615    * Allow crowdsale owner to close early or extend the crowdsale.
616    *
617    * This is useful e.g. for a manual soft cap implementation:
618    * - after X amount is reached determine manual closing
619    *
620    * This may put the crowdsale to an invalid state,
621    * but we trust owners know what they are doing.
622    *
623    */
624   function setEndsAt(uint time) onlyOwner {
625 
626     if(now > time) {
627       throw; // Don't change past
628     }
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
640     pricingStrategy = _pricingStrategy;
641 
642     // Don't allow setting bad agent
643     if(!pricingStrategy.isPricingStrategy()) {
644       throw;
645     }
646   }
647 
648   /**
649    * Allow to change the team multisig address in the case of emergency.
650    *
651    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
652    * (we have done only few test transactions). After the crowdsale is going
653    * then multisig address stays locked for the safety reasons.
654    */
655   function setMultisig(address addr) public onlyOwner {
656 
657     // Change
658     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
659       throw;
660     }
661 
662     multisigWallet = addr;
663   }
664 
665   /**
666    * Allow load refunds back on the contract for the refunding.
667    *
668    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
669    */
670   function loadRefund() public payable inState(State.Failure) {
671     if(msg.value == 0) throw;
672     loadedRefund = loadedRefund.plus(msg.value);
673   }
674 
675   /**
676    * Investors can claim refund.
677    *
678    * Note that any refunds from proxy buyers should be handled separately,
679    * and not through this contract.
680    */
681   function refund() public inState(State.Refunding) {
682     uint256 weiValue = investedAmountOf[msg.sender];
683     if (weiValue == 0) throw;
684     investedAmountOf[msg.sender] = 0;
685     weiRefunded = weiRefunded.plus(weiValue);
686     Refund(msg.sender, weiValue);
687     if (!msg.sender.send(weiValue)) throw;
688   }
689 
690   /**
691    * @return true if the crowdsale has raised enough money to be a successful.
692    */
693   function isMinimumGoalReached() public constant returns (bool reached) {
694     return weiRaised >= minimumFundingGoal;
695   }
696 
697   /**
698    * Check if the contract relationship looks good.
699    */
700   function isFinalizerSane() public constant returns (bool sane) {
701     return finalizeAgent.isSane();
702   }
703 
704   /**
705    * Check if the contract relationship looks good.
706    */
707   function isPricingSane() public constant returns (bool sane) {
708     return pricingStrategy.isSane(address(this));
709   }
710 
711   /**
712    * Crowdfund state machine management.
713    *
714    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
715    */
716   function getState() public constant returns (State) {
717     if(finalized) return State.Finalized;
718     else if (address(finalizeAgent) == 0) return State.Preparing;
719     else if (!finalizeAgent.isSane()) return State.Preparing;
720     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
721     else if (block.timestamp < startsAt) return State.PreFunding;
722     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
723     else if (isMinimumGoalReached()) return State.Success;
724     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
725     else return State.Failure;
726   }
727 
728   /** This is for manual testing of multisig wallet interaction */
729   function setOwnerTestValue(uint val) onlyOwner {
730     ownerTestValue = val;
731   }
732 
733   /** Interface marker. */
734   function isCrowdsale() public constant returns (bool) {
735     return true;
736   }
737 
738   //
739   // Modifiers
740   //
741 
742   /** Modified allowing execution only if the crowdsale is currently running.  */
743   modifier inState(State state) {
744     if(getState() != state) throw;
745     _;
746   }
747 
748 
749   //
750   // Abstract functions
751   //
752 
753   /**
754    * Check if the current invested breaks our cap rules.
755    *
756    *
757    * The child contract must define their own cap setting rules.
758    * We allow a lot of flexibility through different capping strategies (ETH, token count)
759    * Called from invest().
760    *
761    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
762    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
763    * @param weiRaisedTotal What would be our total raised balance after this transaction
764    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
765    *
766    * @return true if taking this investment would break our cap rules
767    */
768   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
769 
770   /**
771    * Check if the current crowdsale is full and we can no longer sell any tokens.
772    */
773   function isCrowdsaleFull() public constant returns (bool);
774 
775   /**
776    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
777    */
778   function assignTokens(address receiver, uint tokenAmount) private;
779 }
780 
781 /**
782  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
783  *
784  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
785  */
786 
787 
788 
789 /**
790  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
791  *
792  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
793  */
794 
795 
796 
797 
798 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
799 
800 
801 
802 /**
803  * Math operations with safety checks
804  */
805 contract SafeMath {
806   function safeMul(uint a, uint b) internal returns (uint) {
807     uint c = a * b;
808     assert(a == 0 || c / a == b);
809     return c;
810   }
811 
812   function safeDiv(uint a, uint b) internal returns (uint) {
813     assert(b > 0);
814     uint c = a / b;
815     assert(a == b * c + a % b);
816     return c;
817   }
818 
819   function safeSub(uint a, uint b) internal returns (uint) {
820     assert(b <= a);
821     return a - b;
822   }
823 
824   function safeAdd(uint a, uint b) internal returns (uint) {
825     uint c = a + b;
826     assert(c>=a && c>=b);
827     return c;
828   }
829 
830   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
831     return a >= b ? a : b;
832   }
833 
834   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
835     return a < b ? a : b;
836   }
837 
838   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
839     return a >= b ? a : b;
840   }
841 
842   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
843     return a < b ? a : b;
844   }
845 
846 }
847 
848 
849 
850 /**
851  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
852  *
853  * Based on code by FirstBlood:
854  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
855  */
856 contract StandardToken is ERC20, SafeMath {
857 
858   /* Token supply got increased and a new owner received these tokens */
859   event Minted(address receiver, uint amount);
860 
861   /* Actual balances of token holders */
862   mapping(address => uint) balances;
863 
864   /* approve() allowances */
865   mapping (address => mapping (address => uint)) allowed;
866 
867   /* Interface declaration */
868   function isToken() public constant returns (bool weAre) {
869     return true;
870   }
871 
872   function transfer(address _to, uint _value) returns (bool success) {
873     balances[msg.sender] = safeSub(balances[msg.sender], _value);
874     balances[_to] = safeAdd(balances[_to], _value);
875     Transfer(msg.sender, _to, _value);
876     return true;
877   }
878 
879   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
880     uint _allowance = allowed[_from][msg.sender];
881 
882     balances[_to] = safeAdd(balances[_to], _value);
883     balances[_from] = safeSub(balances[_from], _value);
884     allowed[_from][msg.sender] = safeSub(_allowance, _value);
885     Transfer(_from, _to, _value);
886     return true;
887   }
888 
889   function balanceOf(address _owner) constant returns (uint balance) {
890     return balances[_owner];
891   }
892 
893   function approve(address _spender, uint _value) returns (bool success) {
894 
895     // To change the approve amount you first have to reduce the addresses`
896     //  allowance to zero by calling `approve(_spender, 0)` if it is not
897     //  already 0 to mitigate the race condition described here:
898     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
899     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
900 
901     allowed[msg.sender][_spender] = _value;
902     Approval(msg.sender, _spender, _value);
903     return true;
904   }
905 
906   function allowance(address _owner, address _spender) constant returns (uint remaining) {
907     return allowed[_owner][_spender];
908   }
909 
910 }
911 
912 
913 
914 
915 /**
916  * A token that can increase its supply by another contract.
917  *
918  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
919  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
920  *
921  */
922 contract MintableToken is StandardToken, Ownable {
923 
924   using SafeMathLib for uint;
925 
926   bool public mintingFinished = false;
927 
928   /** List of agents that are allowed to create new tokens */
929   mapping (address => bool) public mintAgents;
930 
931   event MintingAgentChanged(address addr, bool state  );
932 
933   /**
934    * Create new tokens and allocate them to an address..
935    *
936    * Only callably by a crowdsale contract (mint agent).
937    */
938   function mint(address receiver, uint amount) onlyMintAgent canMint public {
939     totalSupply = totalSupply.plus(amount);
940     balances[receiver] = balances[receiver].plus(amount);
941 
942     // This will make the mint transaction apper in EtherScan.io
943     // We can remove this after there is a standardized minting event
944     Transfer(0, receiver, amount);
945   }
946 
947   /**
948    * Owner can allow a crowdsale contract to mint new tokens.
949    */
950   function setMintAgent(address addr, bool state) onlyOwner canMint public {
951     mintAgents[addr] = state;
952     MintingAgentChanged(addr, state);
953   }
954 
955   modifier onlyMintAgent() {
956     // Only crowdsale contracts are allowed to mint new tokens
957     if(!mintAgents[msg.sender]) {
958         throw;
959     }
960     _;
961   }
962 
963   /** Make sure we are not done yet. */
964   modifier canMint() {
965     if(mintingFinished) throw;
966     _;
967   }
968 }
969 
970 
971 /**
972  * ICO crowdsale contract that is capped by amout of ETH.
973  *
974  * - Tokens are dynamically created during the crowdsale
975  *
976  *
977  */
978 contract MintedEthCappedCrowdsale is Crowdsale {
979 
980   /* Maximum amount of wei this crowdsale can raise. */
981   uint public weiCap;
982 
983   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
984     weiCap = _weiCap;
985   }
986 
987   /**
988    * Called from invest() to confirm if the curret investment does not break our cap rule.
989    */
990   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
991     return weiRaisedTotal > weiCap;
992   }
993 
994   function isCrowdsaleFull() public constant returns (bool) {
995     return weiRaised >= weiCap;
996   }
997 
998   /**
999    * Dynamically create tokens and assign them to the investor.
1000    */
1001   function assignTokens(address receiver, uint tokenAmount) private {
1002     MintableToken mintableToken = MintableToken(token);
1003     mintableToken.mint(receiver, tokenAmount);
1004   }
1005 }