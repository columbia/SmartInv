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
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   function Ownable() {
79     owner = msg.sender;
80   }
81 
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) onlyOwner public {
97     require(newOwner != address(0));
98     OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102 }
103 
104 
105 /*
106  * Haltable
107  *
108  * Abstract contract that allows children to implement an
109  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
110  *
111  *
112  * Originally envisioned in FirstBlood ICO contract.
113  */
114 contract Haltable is Ownable {
115   bool public halted;
116 
117   modifier stopInEmergency {
118     if (halted) throw;
119     _;
120   }
121 
122   modifier stopNonOwnersInEmergency {
123     if (halted && msg.sender != owner) throw;
124     _;
125   }
126 
127   modifier onlyInEmergency {
128     if (!halted) throw;
129     _;
130   }
131 
132   // called by the owner on emergency, triggers stopped state
133   function halt() external onlyOwner {
134     halted = true;
135   }
136 
137   // called by the owner on end of emergency, returns to normal state
138   function unhalt() external onlyOwner onlyInEmergency {
139     halted = false;
140   }
141 
142 }
143 
144 /**
145  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
146  *
147  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
148  */
149 
150 
151 /**
152  * Interface for defining crowdsale pricing.
153  */
154 contract PricingStrategy {
155 
156   /** Interface declaration. */
157   function isPricingStrategy() public constant returns (bool) {
158     return true;
159   }
160 
161   /** Self check if all references are correctly set.
162    *
163    * Checks that pricing strategy matches crowdsale parameters.
164    */
165   function isSane(address crowdsale) public constant returns (bool) {
166     return true;
167   }
168 
169   /**
170    * @dev Pricing tells if this is a presale purchase or not.
171      @param purchaser Address of the purchaser
172      @return False by default, true if a presale purchaser
173    */
174   function isPresalePurchase(address purchaser) public constant returns (bool) {
175     return false;
176   }
177 
178   /**
179    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
180    *
181    *
182    * @param value - What is the value of the transaction send in as wei
183    * @param tokensSold - how much tokens have been sold this far
184    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
185    * @param msgSender - who is the investor of this transaction
186    * @param decimals - how many decimal units the token has
187    * @return Amount of tokens the investor receives
188    */
189   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
190 }
191 
192 /**
193  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
194  *
195  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
196  */
197 
198 
199 /**
200  * Finalize agent defines what happens at the end of succeseful crowdsale.
201  *
202  * - Allocate tokens for founders, bounties and community
203  * - Make tokens transferable
204  * - etc.
205  */
206 contract FinalizeAgent {
207 
208   function isFinalizeAgent() public constant returns(bool) {
209     return true;
210   }
211 
212   /** Return true if we can run finalizeCrowdsale() properly.
213    *
214    * This is a safety check function that doesn't allow crowdsale to begin
215    * unless the finalizer has been set up properly.
216    */
217   function isSane() public constant returns (bool);
218 
219   /** Called once by crowdsale finalize() if the sale was success. */
220   function finalizeCrowdsale();
221 
222 }
223 
224 /**
225  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
226  *
227  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
228  */
229 
230 
231 
232 
233 
234 
235 /**
236  * @title ERC20Basic
237  * @dev Simpler version of ERC20 interface
238  * @dev see https://github.com/ethereum/EIPs/issues/179
239  */
240 contract ERC20Basic {
241   uint256 public totalSupply;
242   function balanceOf(address who) public constant returns (uint256);
243   function transfer(address to, uint256 value) public returns (bool);
244   event Transfer(address indexed from, address indexed to, uint256 value);
245 }
246 
247 
248 
249 /**
250  * @title ERC20 interface
251  * @dev see https://github.com/ethereum/EIPs/issues/20
252  */
253 contract ERC20 is ERC20Basic {
254   function allowance(address owner, address spender) public constant returns (uint256);
255   function transferFrom(address from, address to, uint256 value) public returns (bool);
256   function approve(address spender, uint256 value) public returns (bool);
257   event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 
261 /**
262  * A token that defines fractional units as decimals.
263  */
264 contract FractionalERC20 is ERC20 {
265 
266   uint public decimals;
267 
268 }
269 
270 
271 
272 /**
273  * Abstract base contract for token sales.
274  *
275  * Handle
276  * - start and end dates
277  * - accepting investments
278  * - minimum funding goal and refund
279  * - various statistics during the crowdfund
280  * - different pricing strategies
281  * - different investment policies (require server side customer id, allow only whitelisted addresses)
282  *
283  */
284 contract Crowdsale is Haltable {
285 
286   /* Max investment count when we are still allowed to change the multisig address */
287   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
288 
289   using SafeMathLib for uint;
290 
291   /* The token we are selling */
292   FractionalERC20 public token;
293 
294   /* How we are going to price our offering */
295   PricingStrategy public pricingStrategy;
296 
297   /* Post-success callback */
298   FinalizeAgent public finalizeAgent;
299 
300   /* tokens will be transfered from this address */
301   address public multisigWallet;
302 
303   /* if the funding goal is not reached, investors may withdraw their funds */
304   uint public minimumFundingGoal;
305 
306   /* the UNIX timestamp start date of the crowdsale */
307   uint public startsAt;
308 
309   /* the UNIX timestamp end date of the crowdsale */
310   uint public endsAt;
311 
312   /* the number of tokens already sold through this contract*/
313   uint public tokensSold = 0;
314 
315   /* How many wei of funding we have raised */
316   uint public weiRaised = 0;
317 
318   /* Calculate incoming funds from presale contracts and addresses */
319   uint public presaleWeiRaised = 0;
320 
321   /* How many distinct addresses have invested */
322   uint public investorCount = 0;
323 
324   /* How much wei we have returned back to the contract after a failed crowdfund. */
325   uint public loadedRefund = 0;
326 
327   /* How much wei we have given back to investors.*/
328   uint public weiRefunded = 0;
329 
330   /* Has this crowdsale been finalized */
331   bool public finalized;
332 
333   /* Do we need to have unique contributor id for each customer */
334   bool public requireCustomerId;
335 
336   /**
337     * Do we verify that contributor has been cleared on the server side (accredited investors only).
338     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
339     */
340   bool public requiredSignedAddress;
341 
342   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
343   address public signerAddress;
344 
345   /** How much ETH each address has invested to this crowdsale */
346   mapping (address => uint256) public investedAmountOf;
347 
348   /** How much tokens this crowdsale has credited for each investor address */
349   mapping (address => uint256) public tokenAmountOf;
350 
351   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
352   mapping (address => bool) public earlyParticipantWhitelist;
353 
354   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
355   uint public ownerTestValue;
356 
357   /** State machine
358    *
359    * - Preparing: All contract initialization calls and variables have not been set yet
360    * - Prefunding: We have not passed start time yet
361    * - Funding: Active crowdsale
362    * - Success: Minimum funding goal reached
363    * - Failure: Minimum funding goal not reached before ending time
364    * - Finalized: The finalized has been called and succesfully executed
365    * - Refunding: Refunds are loaded on the contract for reclaim.
366    */
367   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
368 
369   // A new investment was made
370   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
371 
372   // Refund was processed for a contributor
373   event Refund(address investor, uint weiAmount);
374 
375   // The rules were changed what kind of investments we accept
376   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
377 
378   // Address early participation whitelist status changed
379   event Whitelisted(address addr, bool status);
380 
381   // Crowdsale end time has been changed
382   event EndsAtChanged(uint newEndsAt);
383 
384   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
385 
386     owner = msg.sender;
387 
388     token = FractionalERC20(_token);
389 
390     setPricingStrategy(_pricingStrategy);
391 
392     multisigWallet = _multisigWallet;
393     if(multisigWallet == 0) {
394         throw;
395     }
396 
397     if(_start == 0) {
398         throw;
399     }
400 
401     startsAt = _start;
402 
403     if(_end == 0) {
404         throw;
405     }
406 
407     endsAt = _end;
408 
409     // Don't mess the dates
410     if(startsAt >= endsAt) {
411         throw;
412     }
413 
414     // Minimum funding goal can be zero
415     minimumFundingGoal = _minimumFundingGoal;
416   }
417 
418   /**
419    * Don't expect to just send in money and get tokens.
420    */
421   function() payable {
422     throw;
423   }
424 
425   /**
426    * Make an investment.
427    *
428    * Crowdsale must be running for one to invest.
429    * We must have not pressed the emergency brake.
430    *
431    * @param receiver The Ethereum address who receives the tokens
432    * @param customerId (optional) UUID v4 to track the successful payments on the server side
433    *
434    */
435   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
436 
437     // Determine if it's a good time to accept investment from this participant
438     if(getState() == State.PreFunding) {
439       // Are we whitelisted for early deposit
440       if(!earlyParticipantWhitelist[receiver]) {
441         throw;
442       }
443     } else if(getState() == State.Funding) {
444       // Retail participants can only come in when the crowdsale is running
445       // pass
446     } else {
447       // Unwanted state
448       throw;
449     }
450 
451     uint weiAmount = msg.value;
452 
453     // Account presale sales separately, so that they do not count against pricing tranches
454     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
455 
456     if(tokenAmount == 0) {
457       // Dust transaction
458       throw;
459     }
460 
461     if(investedAmountOf[receiver] == 0) {
462        // A new investor
463        investorCount++;
464     }
465 
466     // Update investor
467     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
468     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
469 
470     // Update totals
471     weiRaised = weiRaised.plus(weiAmount);
472     tokensSold = tokensSold.plus(tokenAmount);
473 
474     if(pricingStrategy.isPresalePurchase(receiver)) {
475         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
476     }
477 
478     // Check that we did not bust the cap
479     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
480       throw;
481     }
482 
483     assignTokens(receiver, tokenAmount);
484 
485     // Pocket the money
486     if(!multisigWallet.send(weiAmount)) throw;
487 
488     // Tell us invest was success
489     Invested(receiver, weiAmount, tokenAmount, customerId);
490   }
491 
492   /**
493    * Preallocate tokens for the early investors.
494    *
495    * Preallocated tokens have been sold before the actual crowdsale opens.
496    * This function mints the tokens and moves the crowdsale needle.
497    *
498    * Investor count is not handled; it is assumed this goes for multiple investors
499    * and the token distribution happens outside the smart contract flow.
500    *
501    * No money is exchanged, as the crowdsale team already have received the payment.
502    *
503    * @param fullTokens tokens as full tokens - decimal places added internally
504    * @param weiPrice Price of a single full token in wei
505    *
506    */
507   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
508 
509     uint tokenAmount = fullTokens * 10**token.decimals();
510     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
511 
512     weiRaised = weiRaised.plus(weiAmount);
513     tokensSold = tokensSold.plus(tokenAmount);
514 
515     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
516     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
517 
518     assignTokens(receiver, tokenAmount);
519 
520     // Tell us invest was success
521     Invested(receiver, weiAmount, tokenAmount, 0);
522   }
523 
524   /**
525    * Allow anonymous contributions to this crowdsale.
526    */
527   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
528      bytes32 hash = sha256(addr);
529      if (ecrecover(hash, v, r, s) != signerAddress) throw;
530      if(customerId == 0) throw;  // UUIDv4 sanity check
531      investInternal(addr, customerId);
532   }
533 
534   /**
535    * Track who is the customer making the payment so we can send thank you email.
536    */
537   function investWithCustomerId(address addr, uint128 customerId) public payable {
538     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
539     if(customerId == 0) throw;  // UUIDv4 sanity check
540     investInternal(addr, customerId);
541   }
542 
543   /**
544    * Allow anonymous contributions to this crowdsale.
545    */
546   function invest(address addr) public payable {
547     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
548     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
549     investInternal(addr, 0);
550   }
551 
552   /**
553    * Invest to tokens, recognize the payer and clear his address.
554    *
555    */
556   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
557     investWithSignedAddress(msg.sender, customerId, v, r, s);
558   }
559 
560   /**
561    * Invest to tokens, recognize the payer.
562    *
563    */
564   function buyWithCustomerId(uint128 customerId) public payable {
565     investWithCustomerId(msg.sender, customerId);
566   }
567 
568   /**
569    * The basic entry point to participate the crowdsale process.
570    *
571    * Pay for funding, get invested tokens back in the sender address.
572    */
573   function buy() public payable {
574     invest(msg.sender);
575   }
576 
577   /**
578    * Finalize a succcesful crowdsale.
579    *
580    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
581    */
582   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
583 
584     // Already finalized
585     if(finalized) {
586       throw;
587     }
588 
589     // Finalizing is optional. We only call it if we are given a finalizing agent.
590     if(address(finalizeAgent) != 0) {
591       finalizeAgent.finalizeCrowdsale();
592     }
593 
594     finalized = true;
595   }
596 
597   /**
598    * Allow to (re)set finalize agent.
599    *
600    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
601    */
602   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
603     finalizeAgent = addr;
604 
605     // Don't allow setting bad agent
606     if(!finalizeAgent.isFinalizeAgent()) {
607       throw;
608     }
609   }
610 
611   /**
612    * Set policy do we need to have server-side customer ids for the investments.
613    *
614    */
615   function setRequireCustomerId(bool value) onlyOwner {
616     requireCustomerId = value;
617     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
618   }
619 
620   /**
621    * Set policy if all investors must be cleared on the server side first.
622    *
623    * This is e.g. for the accredited investor clearing.
624    *
625    */
626   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
627     requiredSignedAddress = value;
628     signerAddress = _signerAddress;
629     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
630   }
631 
632   /**
633    * Allow addresses to do early participation.
634    *
635    * TODO: Fix spelling error in the name
636    */
637   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
638     earlyParticipantWhitelist[addr] = status;
639     Whitelisted(addr, status);
640   }
641 
642   /**
643    * Allow crowdsale owner to close early or extend the crowdsale.
644    *
645    * This is useful e.g. for a manual soft cap implementation:
646    * - after X amount is reached determine manual closing
647    *
648    * This may put the crowdsale to an invalid state,
649    * but we trust owners know what they are doing.
650    *
651    */
652   function setEndsAt(uint time) onlyOwner {
653 
654     if(now > time) {
655       throw; // Don't change past
656     }
657 
658     endsAt = time;
659     EndsAtChanged(endsAt);
660   }
661 
662   /**
663    * Allow to (re)set pricing strategy.
664    *
665    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
666    */
667   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
668     pricingStrategy = _pricingStrategy;
669 
670     // Don't allow setting bad agent
671     if(!pricingStrategy.isPricingStrategy()) {
672       throw;
673     }
674   }
675 
676   /**
677    * Allow to change the team multisig address in the case of emergency.
678    *
679    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
680    * (we have done only few test transactions). After the crowdsale is going
681    * then multisig address stays locked for the safety reasons.
682    */
683   function setMultisig(address addr) public onlyOwner {
684 
685     // Change
686     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
687       throw;
688     }
689 
690     multisigWallet = addr;
691   }
692 
693   /**
694    * Allow load refunds back on the contract for the refunding.
695    *
696    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
697    */
698   function loadRefund() public payable inState(State.Failure) {
699     if(msg.value == 0) throw;
700     loadedRefund = loadedRefund.plus(msg.value);
701   }
702 
703   /**
704    * Investors can claim refund.
705    *
706    * Note that any refunds from proxy buyers should be handled separately,
707    * and not through this contract.
708    */
709   function refund() public inState(State.Refunding) {
710     uint256 weiValue = investedAmountOf[msg.sender];
711     if (weiValue == 0) throw;
712     investedAmountOf[msg.sender] = 0;
713     weiRefunded = weiRefunded.plus(weiValue);
714     Refund(msg.sender, weiValue);
715     if (!msg.sender.send(weiValue)) throw;
716   }
717 
718   /**
719    * @return true if the crowdsale has raised enough money to be a successful.
720    */
721   function isMinimumGoalReached() public constant returns (bool reached) {
722     return weiRaised >= minimumFundingGoal;
723   }
724 
725   /**
726    * Check if the contract relationship looks good.
727    */
728   function isFinalizerSane() public constant returns (bool sane) {
729     return finalizeAgent.isSane();
730   }
731 
732   /**
733    * Check if the contract relationship looks good.
734    */
735   function isPricingSane() public constant returns (bool sane) {
736     return pricingStrategy.isSane(address(this));
737   }
738 
739   /**
740    * Crowdfund state machine management.
741    *
742    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
743    */
744   function getState() public constant returns (State) {
745     if(finalized) return State.Finalized;
746     else if (address(finalizeAgent) == 0) return State.Preparing;
747     else if (!finalizeAgent.isSane()) return State.Preparing;
748     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
749     else if (block.timestamp < startsAt) return State.PreFunding;
750     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
751     else if (isMinimumGoalReached()) return State.Success;
752     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
753     else return State.Failure;
754   }
755 
756   /** This is for manual testing of multisig wallet interaction */
757   function setOwnerTestValue(uint val) onlyOwner {
758     ownerTestValue = val;
759   }
760 
761   /** Interface marker. */
762   function isCrowdsale() public constant returns (bool) {
763     return true;
764   }
765 
766   //
767   // Modifiers
768   //
769 
770   /** Modified allowing execution only if the crowdsale is currently running.  */
771   modifier inState(State state) {
772     if(getState() != state) throw;
773     _;
774   }
775 
776 
777   //
778   // Abstract functions
779   //
780 
781   /**
782    * Check if the current invested breaks our cap rules.
783    *
784    *
785    * The child contract must define their own cap setting rules.
786    * We allow a lot of flexibility through different capping strategies (ETH, token count)
787    * Called from invest().
788    *
789    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
790    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
791    * @param weiRaisedTotal What would be our total raised balance after this transaction
792    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
793    *
794    * @return true if taking this investment would break our cap rules
795    */
796   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
797 
798   /**
799    * Check if the current crowdsale is full and we can no longer sell any tokens.
800    */
801   function isCrowdsaleFull() public constant returns (bool);
802 
803   /**
804    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
805    */
806   function assignTokens(address receiver, uint tokenAmount) private;
807 }
808 
809 
810 /**
811  * A crowdsale that is selling tokens from a preallocated pool
812  *
813  *
814  * - Tokens have precreated supply "premined"
815  *
816  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
817  *
818  */
819 contract AllocatedCrowdsale is Crowdsale {
820 
821   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
822   address public beneficiary;
823 
824   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
825     beneficiary = _beneficiary;
826   }
827 
828   /**
829    * Called from invest() to confirm if the curret investment does not break our cap rule.
830    */
831   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
832     if(tokenAmount > getTokensLeft()) {
833       return true;
834     } else {
835       return false;
836     }
837   }
838 
839   /**
840    * We are sold out when our approve pool becomes empty.
841    */
842   function isCrowdsaleFull() public constant returns (bool) {
843     return getTokensLeft() == 0;
844   }
845 
846   /**
847    * Get the amount of unsold tokens allocated to this contract;
848    */
849   function getTokensLeft() public constant returns (uint) {
850     return token.allowance(owner, this);
851   }
852 
853   /**
854    * Transfer tokens from approve() pool to the buyer.
855    *
856    * Use approve() given to this crowdsale to distribute the tokens.
857    */
858   function assignTokens(address receiver, uint tokenAmount) private {
859     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
860   }
861 }