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
119   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124    * account.
125    */
126   function Ownable() {
127     owner = msg.sender;
128   }
129 
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139 
140   /**
141    * @dev Allows the current owner to transfer control of the contract to a newOwner.
142    * @param newOwner The address to transfer ownership to.
143    */
144   function transferOwnership(address newOwner) onlyOwner public {
145     require(newOwner != address(0));
146     OwnershipTransferred(owner, newOwner);
147     owner = newOwner;
148   }
149 
150 }
151 
152 
153 /*
154  * Haltable
155  *
156  * Abstract contract that allows children to implement an
157  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
158  *
159  *
160  * Originally envisioned in FirstBlood ICO contract.
161  */
162 contract Haltable is Ownable {
163   bool public halted;
164 
165   modifier stopInEmergency {
166     if (halted) throw;
167     _;
168   }
169 
170   modifier stopNonOwnersInEmergency {
171     if (halted && msg.sender != owner) throw;
172     _;
173   }
174 
175   modifier onlyInEmergency {
176     if (!halted) throw;
177     _;
178   }
179 
180   // called by the owner on emergency, triggers stopped state
181   function halt() external onlyOwner {
182     halted = true;
183   }
184 
185   // called by the owner on end of emergency, returns to normal state
186   function unhalt() external onlyOwner onlyInEmergency {
187     halted = false;
188   }
189 
190 }
191 
192 
193 /**
194  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
195  *
196  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
197  */
198 
199 
200 /**
201  * Finalize agent defines what happens at the end of succeseful crowdsale.
202  *
203  * - Allocate tokens for founders, bounties and community
204  * - Make tokens transferable
205  * - etc.
206  */
207 contract FinalizeAgent {
208 
209   function isFinalizeAgent() public constant returns(bool) {
210     return true;
211   }
212 
213   /** Return true if we can run finalizeCrowdsale() properly.
214    *
215    * This is a safety check function that doesn't allow crowdsale to begin
216    * unless the finalizer has been set up properly.
217    */
218   function isSane() public constant returns (bool);
219 
220   /** Called once by crowdsale finalize() if the sale was success. */
221   function finalizeCrowdsale();
222 
223 }
224 
225 /**
226  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
227  *
228  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
229  */
230 
231 
232 
233 
234 
235 
236 /**
237  * @title ERC20Basic
238  * @dev Simpler version of ERC20 interface
239  * @dev see https://github.com/ethereum/EIPs/issues/179
240  */
241 contract ERC20Basic {
242   uint256 public totalSupply;
243   function balanceOf(address who) public constant returns (uint256);
244   function transfer(address to, uint256 value) public returns (bool);
245   event Transfer(address indexed from, address indexed to, uint256 value);
246 }
247 
248 
249 
250 /**
251  * @title ERC20 interface
252  * @dev see https://github.com/ethereum/EIPs/issues/20
253  */
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender) public constant returns (uint256);
256   function transferFrom(address from, address to, uint256 value) public returns (bool);
257   function approve(address spender, uint256 value) public returns (bool);
258   event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 
262 /**
263  * A token that defines fractional units as decimals.
264  */
265 contract FractionalERC20 is ERC20 {
266 
267   uint public decimals;
268 
269 }
270 
271 
272 
273 /**
274  * Abstract base contract for token sales.
275  *
276  * Handle
277  * - start and end dates
278  * - accepting investments
279  * - minimum funding goal and refund
280  * - various statistics during the crowdfund
281  * - different pricing strategies
282  * - different investment policies (require server side customer id, allow only whitelisted addresses)
283  *
284  */
285 contract Crowdsale is Haltable {
286 
287   /* Max investment count when we are still allowed to change the multisig address */
288   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
289 
290   using SafeMathLib for uint;
291 
292   /* The token we are selling */
293   FractionalERC20 public token;
294 
295   /* How we are going to price our offering */
296   PricingStrategy public pricingStrategy;
297 
298   /* Post-success callback */
299   FinalizeAgent public finalizeAgent;
300 
301   /* tokens will be transfered from this address */
302   address public multisigWallet;
303 
304   /* if the funding goal is not reached, investors may withdraw their funds */
305   uint public minimumFundingGoal;
306 
307   /* the UNIX timestamp start date of the crowdsale */
308   uint public startsAt;
309 
310   /* the UNIX timestamp end date of the crowdsale */
311   uint public endsAt;
312 
313   /* the number of tokens already sold through this contract*/
314   uint public tokensSold = 0;
315 
316   /* How many wei of funding we have raised */
317   uint public weiRaised = 0;
318 
319   /* Calculate incoming funds from presale contracts and addresses */
320   uint public presaleWeiRaised = 0;
321 
322   /* How many distinct addresses have invested */
323   uint public investorCount = 0;
324 
325   /* How much wei we have returned back to the contract after a failed crowdfund. */
326   uint public loadedRefund = 0;
327 
328   /* How much wei we have given back to investors.*/
329   uint public weiRefunded = 0;
330 
331   /* Has this crowdsale been finalized */
332   bool public finalized;
333 
334   /* Do we need to have unique contributor id for each customer */
335   bool public requireCustomerId;
336 
337   /**
338     * Do we verify that contributor has been cleared on the server side (accredited investors only).
339     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
340     */
341   bool public requiredSignedAddress;
342 
343   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
344   address public signerAddress;
345 
346   /** How much ETH each address has invested to this crowdsale */
347   mapping (address => uint256) public investedAmountOf;
348 
349   /** How much tokens this crowdsale has credited for each investor address */
350   mapping (address => uint256) public tokenAmountOf;
351 
352   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
353   mapping (address => bool) public earlyParticipantWhitelist;
354 
355   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
356   uint public ownerTestValue;
357 
358   /** State machine
359    *
360    * - Preparing: All contract initialization calls and variables have not been set yet
361    * - Prefunding: We have not passed start time yet
362    * - Funding: Active crowdsale
363    * - Success: Minimum funding goal reached
364    * - Failure: Minimum funding goal not reached before ending time
365    * - Finalized: The finalized has been called and succesfully executed
366    * - Refunding: Refunds are loaded on the contract for reclaim.
367    */
368   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
369 
370   // A new investment was made
371   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
372 
373   // Refund was processed for a contributor
374   event Refund(address investor, uint weiAmount);
375 
376   // The rules were changed what kind of investments we accept
377   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
378 
379   // Address early participation whitelist status changed
380   event Whitelisted(address addr, bool status);
381 
382   // Crowdsale end time has been changed
383   event EndsAtChanged(uint newEndsAt);
384 
385   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
386 
387     owner = msg.sender;
388 
389     token = FractionalERC20(_token);
390 
391     setPricingStrategy(_pricingStrategy);
392 
393     multisigWallet = _multisigWallet;
394     if(multisigWallet == 0) {
395         throw;
396     }
397 
398     if(_start == 0) {
399         throw;
400     }
401 
402     startsAt = _start;
403 
404     if(_end == 0) {
405         throw;
406     }
407 
408     endsAt = _end;
409 
410     // Don't mess the dates
411     if(startsAt >= endsAt) {
412         throw;
413     }
414 
415     // Minimum funding goal can be zero
416     minimumFundingGoal = _minimumFundingGoal;
417   }
418 
419   /**
420    * Don't expect to just send in money and get tokens.
421    */
422   function() payable {
423     throw;
424   }
425 
426   /**
427    * Make an investment.
428    *
429    * Crowdsale must be running for one to invest.
430    * We must have not pressed the emergency brake.
431    *
432    * @param receiver The Ethereum address who receives the tokens
433    * @param customerId (optional) UUID v4 to track the successful payments on the server side
434    *
435    */
436   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
437 
438     // Determine if it's a good time to accept investment from this participant
439     if(getState() == State.PreFunding) {
440       // Are we whitelisted for early deposit
441       if(!earlyParticipantWhitelist[receiver]) {
442         throw;
443       }
444     } else if(getState() == State.Funding) {
445       // Retail participants can only come in when the crowdsale is running
446       // pass
447     } else {
448       // Unwanted state
449       throw;
450     }
451 
452     uint weiAmount = msg.value;
453 
454     // Account presale sales separately, so that they do not count against pricing tranches
455     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
456 
457     if(tokenAmount == 0) {
458       // Dust transaction
459       throw;
460     }
461 
462     if(investedAmountOf[receiver] == 0) {
463        // A new investor
464        investorCount++;
465     }
466 
467     // Update investor
468     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
469     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
470 
471     // Update totals
472     weiRaised = weiRaised.plus(weiAmount);
473     tokensSold = tokensSold.plus(tokenAmount);
474 
475     if(pricingStrategy.isPresalePurchase(receiver)) {
476         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
477     }
478 
479     // Check that we did not bust the cap
480     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
481       throw;
482     }
483 
484     assignTokens(receiver, tokenAmount);
485 
486     // Pocket the money
487     if(!multisigWallet.send(weiAmount)) throw;
488 
489     // Tell us invest was success
490     Invested(receiver, weiAmount, tokenAmount, customerId);
491   }
492 
493   /**
494    * Preallocate tokens for the early investors.
495    *
496    * Preallocated tokens have been sold before the actual crowdsale opens.
497    * This function mints the tokens and moves the crowdsale needle.
498    *
499    * Investor count is not handled; it is assumed this goes for multiple investors
500    * and the token distribution happens outside the smart contract flow.
501    *
502    * No money is exchanged, as the crowdsale team already have received the payment.
503    *
504    * @param fullTokens tokens as full tokens - decimal places added internally
505    * @param weiPrice Price of a single full token in wei
506    *
507    */
508   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
509 
510     uint tokenAmount = fullTokens * 10**token.decimals();
511     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
512 
513     weiRaised = weiRaised.plus(weiAmount);
514     tokensSold = tokensSold.plus(tokenAmount);
515 
516     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
517     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
518 
519     assignTokens(receiver, tokenAmount);
520 
521     // Tell us invest was success
522     Invested(receiver, weiAmount, tokenAmount, 0);
523   }
524 
525   /**
526    * Allow anonymous contributions to this crowdsale.
527    */
528   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
529      bytes32 hash = sha256(addr);
530      if (ecrecover(hash, v, r, s) != signerAddress) throw;
531      if(customerId == 0) throw;  // UUIDv4 sanity check
532      investInternal(addr, customerId);
533   }
534 
535   /**
536    * Track who is the customer making the payment so we can send thank you email.
537    */
538   function investWithCustomerId(address addr, uint128 customerId) public payable {
539     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
540     if(customerId == 0) throw;  // UUIDv4 sanity check
541     investInternal(addr, customerId);
542   }
543 
544   /**
545    * Allow anonymous contributions to this crowdsale.
546    */
547   function invest(address addr) public payable {
548     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
549     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
550     investInternal(addr, 0);
551   }
552 
553   /**
554    * Invest to tokens, recognize the payer and clear his address.
555    *
556    */
557   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
558     investWithSignedAddress(msg.sender, customerId, v, r, s);
559   }
560 
561   /**
562    * Invest to tokens, recognize the payer.
563    *
564    */
565   function buyWithCustomerId(uint128 customerId) public payable {
566     investWithCustomerId(msg.sender, customerId);
567   }
568 
569   /**
570    * The basic entry point to participate the crowdsale process.
571    *
572    * Pay for funding, get invested tokens back in the sender address.
573    */
574   function buy() public payable {
575     invest(msg.sender);
576   }
577 
578   /**
579    * Finalize a succcesful crowdsale.
580    *
581    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
582    */
583   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
584 
585     // Already finalized
586     if(finalized) {
587       throw;
588     }
589 
590     // Finalizing is optional. We only call it if we are given a finalizing agent.
591     if(address(finalizeAgent) != 0) {
592       finalizeAgent.finalizeCrowdsale();
593     }
594 
595     finalized = true;
596   }
597 
598   /**
599    * Allow to (re)set finalize agent.
600    *
601    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
602    */
603   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
604     finalizeAgent = addr;
605 
606     // Don't allow setting bad agent
607     if(!finalizeAgent.isFinalizeAgent()) {
608       throw;
609     }
610   }
611 
612   /**
613    * Set policy do we need to have server-side customer ids for the investments.
614    *
615    */
616   function setRequireCustomerId(bool value) onlyOwner {
617     requireCustomerId = value;
618     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
619   }
620 
621   /**
622    * Set policy if all investors must be cleared on the server side first.
623    *
624    * This is e.g. for the accredited investor clearing.
625    *
626    */
627   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
628     requiredSignedAddress = value;
629     signerAddress = _signerAddress;
630     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
631   }
632 
633   /**
634    * Allow addresses to do early participation.
635    *
636    * TODO: Fix spelling error in the name
637    */
638   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
639     earlyParticipantWhitelist[addr] = status;
640     Whitelisted(addr, status);
641   }
642 
643   /**
644    * Allow crowdsale owner to close early or extend the crowdsale.
645    *
646    * This is useful e.g. for a manual soft cap implementation:
647    * - after X amount is reached determine manual closing
648    *
649    * This may put the crowdsale to an invalid state,
650    * but we trust owners know what they are doing.
651    *
652    */
653   function setEndsAt(uint time) onlyOwner {
654 
655     if(now > time) {
656       throw; // Don't change past
657     }
658 
659     endsAt = time;
660     EndsAtChanged(endsAt);
661   }
662 
663   /**
664    * Allow to (re)set pricing strategy.
665    *
666    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
667    */
668   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
669     pricingStrategy = _pricingStrategy;
670 
671     // Don't allow setting bad agent
672     if(!pricingStrategy.isPricingStrategy()) {
673       throw;
674     }
675   }
676 
677   /**
678    * Allow to change the team multisig address in the case of emergency.
679    *
680    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
681    * (we have done only few test transactions). After the crowdsale is going
682    * then multisig address stays locked for the safety reasons.
683    */
684   function setMultisig(address addr) public onlyOwner {
685 
686     // Change
687     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
688       throw;
689     }
690 
691     multisigWallet = addr;
692   }
693 
694   /**
695    * Allow load refunds back on the contract for the refunding.
696    *
697    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
698    */
699   function loadRefund() public payable inState(State.Failure) {
700     if(msg.value == 0) throw;
701     loadedRefund = loadedRefund.plus(msg.value);
702   }
703 
704   /**
705    * Investors can claim refund.
706    *
707    * Note that any refunds from proxy buyers should be handled separately,
708    * and not through this contract.
709    */
710   function refund() public inState(State.Refunding) {
711     uint256 weiValue = investedAmountOf[msg.sender];
712     if (weiValue == 0) throw;
713     investedAmountOf[msg.sender] = 0;
714     weiRefunded = weiRefunded.plus(weiValue);
715     Refund(msg.sender, weiValue);
716     if (!msg.sender.send(weiValue)) throw;
717   }
718 
719   /**
720    * @return true if the crowdsale has raised enough money to be a successful.
721    */
722   function isMinimumGoalReached() public constant returns (bool reached) {
723     return weiRaised >= minimumFundingGoal;
724   }
725 
726   /**
727    * Check if the contract relationship looks good.
728    */
729   function isFinalizerSane() public constant returns (bool sane) {
730     return finalizeAgent.isSane();
731   }
732 
733   /**
734    * Check if the contract relationship looks good.
735    */
736   function isPricingSane() public constant returns (bool sane) {
737     return pricingStrategy.isSane(address(this));
738   }
739 
740   /**
741    * Crowdfund state machine management.
742    *
743    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
744    */
745   function getState() public constant returns (State) {
746     if(finalized) return State.Finalized;
747     else if (address(finalizeAgent) == 0) return State.Preparing;
748     else if (!finalizeAgent.isSane()) return State.Preparing;
749     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
750     else if (block.timestamp < startsAt) return State.PreFunding;
751     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
752     else if (isMinimumGoalReached()) return State.Success;
753     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
754     else return State.Failure;
755   }
756 
757   /** This is for manual testing of multisig wallet interaction */
758   function setOwnerTestValue(uint val) onlyOwner {
759     ownerTestValue = val;
760   }
761 
762   /** Interface marker. */
763   function isCrowdsale() public constant returns (bool) {
764     return true;
765   }
766 
767   //
768   // Modifiers
769   //
770 
771   /** Modified allowing execution only if the crowdsale is currently running.  */
772   modifier inState(State state) {
773     if(getState() != state) throw;
774     _;
775   }
776 
777 
778   //
779   // Abstract functions
780   //
781 
782   /**
783    * Check if the current invested breaks our cap rules.
784    *
785    *
786    * The child contract must define their own cap setting rules.
787    * We allow a lot of flexibility through different capping strategies (ETH, token count)
788    * Called from invest().
789    *
790    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
791    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
792    * @param weiRaisedTotal What would be our total raised balance after this transaction
793    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
794    *
795    * @return true if taking this investment would break our cap rules
796    */
797   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
798 
799   /**
800    * Check if the current crowdsale is full and we can no longer sell any tokens.
801    */
802   function isCrowdsaleFull() public constant returns (bool);
803 
804   /**
805    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
806    */
807   function assignTokens(address receiver, uint tokenAmount) private;
808 }
809 
810 
811 
812 
813 
814 /// @dev Time milestone based pricing with special support for pre-ico deals.
815 contract MilestonePricing is PricingStrategy, Ownable {
816 
817   using SafeMathLib for uint;
818 
819   uint public constant MAX_MILESTONE = 10;
820 
821   // This contains all pre-ICO addresses, and their prices (weis per token)
822   mapping (address => uint) public preicoAddresses;
823 
824   /**
825   * Define pricing schedule using milestones.
826   */
827   struct Milestone {
828 
829       // UNIX timestamp when this milestone kicks in
830       uint time;
831 
832       // How many tokens per satoshi you will get after this milestone has been passed
833       uint price;
834   }
835 
836   // Store milestones in a fixed array, so that it can be seen in a blockchain explorer
837   // Milestone 0 is always (0, 0)
838   // (TODO: change this when we confirm dynamic arrays are explorable)
839   Milestone[10] public milestones;
840 
841   // How many active milestones we have
842   uint public milestoneCount;
843 
844   /// @dev Contruction, creating a list of milestones
845   /// @param _milestones uint[] milestones Pairs of (time, price)
846   function MilestonePricing(uint[] _milestones) {
847     // Need to have tuples, length check
848     if(_milestones.length % 2 == 1 || _milestones.length >= MAX_MILESTONE*2) {
849       throw;
850     }
851 
852     milestoneCount = _milestones.length / 2;
853 
854     uint lastTimestamp = 0;
855 
856     for(uint i=0; i<_milestones.length/2; i++) {
857       milestones[i].time = _milestones[i*2];
858       milestones[i].price = _milestones[i*2+1];
859 
860       // No invalid steps
861       if((lastTimestamp != 0) && (milestones[i].time <= lastTimestamp)) {
862         throw;
863       }
864 
865       lastTimestamp = milestones[i].time;
866     }
867 
868     // Last milestone price must be zero, terminating the crowdale
869     if(milestones[milestoneCount-1].price != 0) {
870       throw;
871     }
872   }
873 
874   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
875   ///      to 0 to disable
876   /// @param preicoAddress PresaleFundCollector address
877   /// @param pricePerToken How many weis one token cost for pre-ico investors
878   function setPreicoAddress(address preicoAddress, uint pricePerToken)
879     public
880     onlyOwner
881   {
882     preicoAddresses[preicoAddress] = pricePerToken;
883   }
884 
885   /// @dev Iterate through milestones. You reach end of milestones when price = 0
886   /// @return tuple (time, price)
887   function getMilestone(uint n) public constant returns (uint, uint) {
888     return (milestones[n].time, milestones[n].price);
889   }
890 
891   function getFirstMilestone() private constant returns (Milestone) {
892     return milestones[0];
893   }
894 
895   function getLastMilestone() private constant returns (Milestone) {
896     return milestones[milestoneCount-1];
897   }
898 
899   function getPricingStartsAt() public constant returns (uint) {
900     return getFirstMilestone().time;
901   }
902 
903   function getPricingEndsAt() public constant returns (uint) {
904     return getLastMilestone().time;
905   }
906 
907   function isSane(address _crowdsale) public constant returns(bool) {
908     Crowdsale crowdsale = Crowdsale(_crowdsale);
909     return crowdsale.startsAt() == getPricingStartsAt() && crowdsale.endsAt() == getPricingEndsAt();
910   }
911 
912   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
913   /// @return {[type]} [description]
914   function getCurrentMilestone() private constant returns (Milestone) {
915     uint i;
916 
917     for(i=0; i<milestones.length; i++) {
918       if(now < milestones[i].time) {
919         return milestones[i-1];
920       }
921     }
922   }
923 
924   /// @dev Get the current price.
925   /// @return The current price or 0 if we are outside milestone period
926   function getCurrentPrice() public constant returns (uint result) {
927     return getCurrentMilestone().price;
928   }
929 
930   /// @dev Calculate the current price for buy in amount.
931   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
932 
933     uint multiplier = 10 ** decimals;
934 
935     // This investor is coming through pre-ico
936     if(preicoAddresses[msgSender] > 0) {
937       return value.times(multiplier) / preicoAddresses[msgSender];
938     }
939 
940     uint price = getCurrentPrice();
941     return value.times(multiplier) / price;
942   }
943 
944   function isPresalePurchase(address purchaser) public constant returns (bool) {
945     if(preicoAddresses[purchaser] > 0)
946       return true;
947     else
948       return false;
949   }
950 
951   function() payable {
952     throw; // No money on this contract
953   }
954 
955 }