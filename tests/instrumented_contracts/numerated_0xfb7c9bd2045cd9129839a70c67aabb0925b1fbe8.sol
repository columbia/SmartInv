1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
9 
10 
11 
12 /**
13  * Math operations with safety checks
14  */
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeDiv(uint a, uint b) internal returns (uint) {
23     assert(b > 0);
24     uint c = a / b;
25     assert(a == b * c + a % b);
26     return c;
27   }
28 
29   function safeSub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function safeAdd(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c>=a && c>=b);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56 }
57 
58 /**
59  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
60  *
61  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
62  */
63 
64 
65 /**
66  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
67  *
68  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
69  */
70 
71 
72 /**
73  * Safe unsigned safe math.
74  *
75  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
76  *
77  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
78  *
79  * Maintained here until merged to mainline zeppelin-solidity.
80  *
81  */
82 library SafeMathLib {
83 
84   function times(uint a, uint b) returns (uint) {
85     uint c = a * b;
86     assert(a == 0 || c / a == b);
87     return c;
88   }
89 
90   function minus(uint a, uint b) returns (uint) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function plus(uint a, uint b) returns (uint) {
96     uint c = a + b;
97     assert(c>=a);
98     return c;
99   }
100 
101 }
102 
103 /**
104  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
105  *
106  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
107  */
108 
109 
110 
111 
112 /**
113  * @title Ownable
114  * @dev The Ownable contract has an owner address, and provides basic authorization control
115  * functions, this simplifies the implementation of "user permissions".
116  */
117 contract Ownable {
118   address public owner;
119 
120 
121   /**
122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123    * account.
124    */
125   function Ownable() {
126     owner = msg.sender;
127   }
128 
129 
130   /**
131    * @dev Throws if called by any account other than the owner.
132    */
133   modifier onlyOwner() {
134     require(msg.sender == owner);
135     _;
136   }
137 
138 
139   /**
140    * @dev Allows the current owner to transfer control of the contract to a newOwner.
141    * @param newOwner The address to transfer ownership to.
142    */
143   function transferOwnership(address newOwner) onlyOwner {
144     require(newOwner != address(0));      
145     owner = newOwner;
146   }
147 
148 }
149 
150 
151 /*
152  * Haltable
153  *
154  * Abstract contract that allows children to implement an
155  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
156  *
157  *
158  * Originally envisioned in FirstBlood ICO contract.
159  */
160 contract Haltable is Ownable {
161   bool public halted;
162 
163   modifier stopInEmergency {
164     if (halted) throw;
165     _;
166   }
167 
168   modifier stopNonOwnersInEmergency {
169     if (halted && msg.sender != owner) throw;
170     _;
171   }
172 
173   modifier onlyInEmergency {
174     if (!halted) throw;
175     _;
176   }
177 
178   // called by the owner on emergency, triggers stopped state
179   function halt() external onlyOwner {
180     halted = true;
181   }
182 
183   // called by the owner on end of emergency, returns to normal state
184   function unhalt() external onlyOwner onlyInEmergency {
185     halted = false;
186   }
187 
188 }
189 
190 /**
191  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
192  *
193  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
194  */
195 
196 
197 /**
198  * Interface for defining crowdsale pricing.
199  */
200 contract PricingStrategy {
201 
202   /** Interface declaration. */
203   function isPricingStrategy() public constant returns (bool) {
204     return true;
205   }
206 
207   /** Self check if all references are correctly set.
208    *
209    * Checks that pricing strategy matches crowdsale parameters.
210    */
211   function isSane(address crowdsale) public constant returns (bool) {
212     return true;
213   }
214 
215   /**
216    * @dev Pricing tells if this is a presale purchase or not.
217      @param purchaser Address of the purchaser
218      @return False by default, true if a presale purchaser
219    */
220   function isPresalePurchase(address purchaser) public constant returns (bool) {
221     return false;
222   }
223 
224   /**
225    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
226    *
227    *
228    * @param value - What is the value of the transaction send in as wei
229    * @param tokensSold - how much tokens have been sold this far
230    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
231    * @param msgSender - who is the investor of this transaction
232    * @param decimals - how many decimal units the token has
233    * @return Amount of tokens the investor receives
234    */
235   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
236 }
237 
238 /**
239  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
240  *
241  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
242  */
243 
244 
245 /**
246  * Finalize agent defines what happens at the end of succeseful crowdsale.
247  *
248  * - Allocate tokens for founders, bounties and community
249  * - Make tokens transferable
250  * - etc.
251  */
252 contract FinalizeAgent {
253 
254   function isFinalizeAgent() public constant returns(bool) {
255     return true;
256   }
257 
258   /** Return true if we can run finalizeCrowdsale() properly.
259    *
260    * This is a safety check function that doesn't allow crowdsale to begin
261    * unless the finalizer has been set up properly.
262    */
263   function isSane() public constant returns (bool);
264 
265   /** Called once by crowdsale finalize() if the sale was success. */
266   function finalizeCrowdsale();
267 
268 }
269 
270 /**
271  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
272  *
273  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
274  */
275 
276 
277 
278 
279 
280 
281 /**
282  * @title ERC20Basic
283  * @dev Simpler version of ERC20 interface
284  * @dev see https://github.com/ethereum/EIPs/issues/179
285  */
286 contract ERC20Basic {
287   uint256 public totalSupply;
288   function balanceOf(address who) constant returns (uint256);
289   function transfer(address to, uint256 value) returns (bool);
290   event Transfer(address indexed from, address indexed to, uint256 value);
291 }
292 
293 
294 
295 /**
296  * @title ERC20 interface
297  * @dev see https://github.com/ethereum/EIPs/issues/20
298  */
299 contract ERC20 is ERC20Basic {
300   function allowance(address owner, address spender) constant returns (uint256);
301   function transferFrom(address from, address to, uint256 value) returns (bool);
302   function approve(address spender, uint256 value) returns (bool);
303   event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 
307 /**
308  * A token that defines fractional units as decimals.
309  */
310 contract FractionalERC20 is ERC20 {
311 
312   uint public decimals;
313 
314 }
315 
316 
317 
318 /**
319  * Abstract base contract for token sales.
320  *
321  * Handle
322  * - start and end dates
323  * - accepting investments
324  * - minimum funding goal and refund
325  * - various statistics during the crowdfund
326  * - different pricing strategies
327  * - different investment policies (require server side customer id, allow only whitelisted addresses)
328  *
329  */
330 contract Crowdsale is Haltable {
331 
332   /* Max investment count when we are still allowed to change the multisig address */
333   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
334 
335   using SafeMathLib for uint;
336 
337   /* The token we are selling */
338   FractionalERC20 public token;
339 
340   /* How we are going to price our offering */
341   PricingStrategy public pricingStrategy;
342 
343   /* Post-success callback */
344   FinalizeAgent public finalizeAgent;
345 
346   /* tokens will be transfered from this address */
347   address public multisigWallet;
348 
349   /* if the funding goal is not reached, investors may withdraw their funds */
350   uint public minimumFundingGoal;
351 
352   /* the UNIX timestamp start date of the crowdsale */
353   uint public startsAt;
354 
355   /* the UNIX timestamp end date of the crowdsale */
356   uint public endsAt;
357 
358   /* the number of tokens already sold through this contract*/
359   uint public tokensSold = 0;
360 
361   /* How many wei of funding we have raised */
362   uint public weiRaised = 0;
363 
364   /* Calculate incoming funds from presale contracts and addresses */
365   uint public presaleWeiRaised = 0;
366 
367   /* How many distinct addresses have invested */
368   uint public investorCount = 0;
369 
370   /* How much wei we have returned back to the contract after a failed crowdfund. */
371   uint public loadedRefund = 0;
372 
373   /* How much wei we have given back to investors.*/
374   uint public weiRefunded = 0;
375 
376   /* Has this crowdsale been finalized */
377   bool public finalized;
378 
379   /* Do we need to have unique contributor id for each customer */
380   bool public requireCustomerId;
381 
382   /**
383     * Do we verify that contributor has been cleared on the server side (accredited investors only).
384     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
385     */
386   bool public requiredSignedAddress;
387 
388   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
389   address public signerAddress;
390 
391   /** How much ETH each address has invested to this crowdsale */
392   mapping (address => uint256) public investedAmountOf;
393 
394   /** How much tokens this crowdsale has credited for each investor address */
395   mapping (address => uint256) public tokenAmountOf;
396 
397   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
398   mapping (address => bool) public earlyParticipantWhitelist;
399 
400   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
401   uint public ownerTestValue;
402 
403   /** State machine
404    *
405    * - Preparing: All contract initialization calls and variables have not been set yet
406    * - Prefunding: We have not passed start time yet
407    * - Funding: Active crowdsale
408    * - Success: Minimum funding goal reached
409    * - Failure: Minimum funding goal not reached before ending time
410    * - Finalized: The finalized has been called and succesfully executed
411    * - Refunding: Refunds are loaded on the contract for reclaim.
412    */
413   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
414 
415   // A new investment was made
416   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
417 
418   // Refund was processed for a contributor
419   event Refund(address investor, uint weiAmount);
420 
421   // The rules were changed what kind of investments we accept
422   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
423 
424   // Address early participation whitelist status changed
425   event Whitelisted(address addr, bool status);
426 
427   // Crowdsale end time has been changed
428   event EndsAtChanged(uint newEndsAt);
429 
430   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
431 
432     owner = msg.sender;
433 
434     token = FractionalERC20(_token);
435 
436     setPricingStrategy(_pricingStrategy);
437 
438     multisigWallet = _multisigWallet;
439     if(multisigWallet == 0) {
440         throw;
441     }
442 
443     if(_start == 0) {
444         throw;
445     }
446 
447     startsAt = _start;
448 
449     if(_end == 0) {
450         throw;
451     }
452 
453     endsAt = _end;
454 
455     // Don't mess the dates
456     if(startsAt >= endsAt) {
457         throw;
458     }
459 
460     // Minimum funding goal can be zero
461     minimumFundingGoal = _minimumFundingGoal;
462   }
463 
464   /**
465    * Don't expect to just send in money and get tokens.
466    */
467   function() payable {
468     throw;
469   }
470 
471   /**
472    * Make an investment.
473    *
474    * Crowdsale must be running for one to invest.
475    * We must have not pressed the emergency brake.
476    *
477    * @param receiver The Ethereum address who receives the tokens
478    * @param customerId (optional) UUID v4 to track the successful payments on the server side
479    *
480    */
481   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
482 
483     // Determine if it's a good time to accept investment from this participant
484     if(getState() == State.PreFunding) {
485       // Are we whitelisted for early deposit
486       if(!earlyParticipantWhitelist[receiver]) {
487         throw;
488       }
489     } else if(getState() == State.Funding) {
490       // Retail participants can only come in when the crowdsale is running
491       // pass
492     } else {
493       // Unwanted state
494       throw;
495     }
496 
497     uint weiAmount = msg.value;
498 
499     // Account presale sales separately, so that they do not count against pricing tranches
500     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
501 
502     if(tokenAmount == 0) {
503       // Dust transaction
504       throw;
505     }
506 
507     if(investedAmountOf[receiver] == 0) {
508        // A new investor
509        investorCount++;
510     }
511 
512     // Update investor
513     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
514     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
515 
516     // Update totals
517     weiRaised = weiRaised.plus(weiAmount);
518     tokensSold = tokensSold.plus(tokenAmount);
519 
520     if(pricingStrategy.isPresalePurchase(receiver)) {
521         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
522     }
523 
524     // Check that we did not bust the cap
525     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
526       throw;
527     }
528 
529     assignTokens(receiver, tokenAmount);
530 
531     // Pocket the money
532     if(!multisigWallet.send(weiAmount)) throw;
533 
534     // Tell us invest was success
535     Invested(receiver, weiAmount, tokenAmount, customerId);
536   }
537 
538   /**
539    * Preallocate tokens for the early investors.
540    *
541    * Preallocated tokens have been sold before the actual crowdsale opens.
542    * This function mints the tokens and moves the crowdsale needle.
543    *
544    * Investor count is not handled; it is assumed this goes for multiple investors
545    * and the token distribution happens outside the smart contract flow.
546    *
547    * No money is exchanged, as the crowdsale team already have received the payment.
548    *
549    * @param fullTokens tokens as full tokens - decimal places added internally
550    * @param weiPrice Price of a single full token in wei
551    *
552    */
553   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
554 
555     uint tokenAmount = fullTokens * 10**token.decimals();
556     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
557 
558     weiRaised = weiRaised.plus(weiAmount);
559     tokensSold = tokensSold.plus(tokenAmount);
560 
561     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
562     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
563 
564     assignTokens(receiver, tokenAmount);
565 
566     // Tell us invest was success
567     Invested(receiver, weiAmount, tokenAmount, 0);
568   }
569 
570   /**
571    * Allow anonymous contributions to this crowdsale.
572    */
573   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
574      bytes32 hash = sha256(addr);
575      if (ecrecover(hash, v, r, s) != signerAddress) throw;
576      if(customerId == 0) throw;  // UUIDv4 sanity check
577      investInternal(addr, customerId);
578   }
579 
580   /**
581    * Track who is the customer making the payment so we can send thank you email.
582    */
583   function investWithCustomerId(address addr, uint128 customerId) public payable {
584     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
585     if(customerId == 0) throw;  // UUIDv4 sanity check
586     investInternal(addr, customerId);
587   }
588 
589   /**
590    * Allow anonymous contributions to this crowdsale.
591    */
592   function invest(address addr) public payable {
593     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
594     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
595     investInternal(addr, 0);
596   }
597 
598   /**
599    * Invest to tokens, recognize the payer and clear his address.
600    *
601    */
602   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
603     investWithSignedAddress(msg.sender, customerId, v, r, s);
604   }
605 
606   /**
607    * Invest to tokens, recognize the payer.
608    *
609    */
610   function buyWithCustomerId(uint128 customerId) public payable {
611     investWithCustomerId(msg.sender, customerId);
612   }
613 
614   /**
615    * The basic entry point to participate the crowdsale process.
616    *
617    * Pay for funding, get invested tokens back in the sender address.
618    */
619   function buy() public payable {
620     invest(msg.sender);
621   }
622 
623   /**
624    * Finalize a succcesful crowdsale.
625    *
626    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
627    */
628   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
629 
630     // Already finalized
631     if(finalized) {
632       throw;
633     }
634 
635     // Finalizing is optional. We only call it if we are given a finalizing agent.
636     if(address(finalizeAgent) != 0) {
637       finalizeAgent.finalizeCrowdsale();
638     }
639 
640     finalized = true;
641   }
642 
643   /**
644    * Allow to (re)set finalize agent.
645    *
646    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
647    */
648   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
649     finalizeAgent = addr;
650 
651     // Don't allow setting bad agent
652     if(!finalizeAgent.isFinalizeAgent()) {
653       throw;
654     }
655   }
656 
657   /**
658    * Set policy do we need to have server-side customer ids for the investments.
659    *
660    */
661   function setRequireCustomerId(bool value) onlyOwner {
662     requireCustomerId = value;
663     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
664   }
665 
666   /**
667    * Set policy if all investors must be cleared on the server side first.
668    *
669    * This is e.g. for the accredited investor clearing.
670    *
671    */
672   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
673     requiredSignedAddress = value;
674     signerAddress = _signerAddress;
675     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
676   }
677 
678   /**
679    * Allow addresses to do early participation.
680    *
681    * TODO: Fix spelling error in the name
682    */
683   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
684     earlyParticipantWhitelist[addr] = status;
685     Whitelisted(addr, status);
686   }
687 
688   /**
689    * Allow crowdsale owner to close early or extend the crowdsale.
690    *
691    * This is useful e.g. for a manual soft cap implementation:
692    * - after X amount is reached determine manual closing
693    *
694    * This may put the crowdsale to an invalid state,
695    * but we trust owners know what they are doing.
696    *
697    */
698   function setEndsAt(uint time) onlyOwner {
699 
700     if(now > time) {
701       throw; // Don't change past
702     }
703 
704     endsAt = time;
705     EndsAtChanged(endsAt);
706   }
707 
708   /**
709    * Allow to (re)set pricing strategy.
710    *
711    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
712    */
713   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
714     pricingStrategy = _pricingStrategy;
715 
716     // Don't allow setting bad agent
717     if(!pricingStrategy.isPricingStrategy()) {
718       throw;
719     }
720   }
721 
722   /**
723    * Allow to change the team multisig address in the case of emergency.
724    *
725    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
726    * (we have done only few test transactions). After the crowdsale is going
727    * then multisig address stays locked for the safety reasons.
728    */
729   function setMultisig(address addr) public onlyOwner {
730 
731     // Change
732     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
733       throw;
734     }
735 
736     multisigWallet = addr;
737   }
738 
739   /**
740    * Allow load refunds back on the contract for the refunding.
741    *
742    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
743    */
744   function loadRefund() public payable inState(State.Failure) {
745     if(msg.value == 0) throw;
746     loadedRefund = loadedRefund.plus(msg.value);
747   }
748 
749   /**
750    * Investors can claim refund.
751    *
752    * Note that any refunds from proxy buyers should be handled separately,
753    * and not through this contract.
754    */
755   function refund() public inState(State.Refunding) {
756     uint256 weiValue = investedAmountOf[msg.sender];
757     if (weiValue == 0) throw;
758     investedAmountOf[msg.sender] = 0;
759     weiRefunded = weiRefunded.plus(weiValue);
760     Refund(msg.sender, weiValue);
761     if (!msg.sender.send(weiValue)) throw;
762   }
763 
764   /**
765    * @return true if the crowdsale has raised enough money to be a successful.
766    */
767   function isMinimumGoalReached() public constant returns (bool reached) {
768     return weiRaised >= minimumFundingGoal;
769   }
770 
771   /**
772    * Check if the contract relationship looks good.
773    */
774   function isFinalizerSane() public constant returns (bool sane) {
775     return finalizeAgent.isSane();
776   }
777 
778   /**
779    * Check if the contract relationship looks good.
780    */
781   function isPricingSane() public constant returns (bool sane) {
782     return pricingStrategy.isSane(address(this));
783   }
784 
785   /**
786    * Crowdfund state machine management.
787    *
788    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
789    */
790   function getState() public constant returns (State) {
791     if(finalized) return State.Finalized;
792     else if (address(finalizeAgent) == 0) return State.Preparing;
793     else if (!finalizeAgent.isSane()) return State.Preparing;
794     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
795     else if (block.timestamp < startsAt) return State.PreFunding;
796     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
797     else if (isMinimumGoalReached()) return State.Success;
798     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
799     else return State.Failure;
800   }
801 
802   /** This is for manual testing of multisig wallet interaction */
803   function setOwnerTestValue(uint val) onlyOwner {
804     ownerTestValue = val;
805   }
806 
807   /** Interface marker. */
808   function isCrowdsale() public constant returns (bool) {
809     return true;
810   }
811 
812   //
813   // Modifiers
814   //
815 
816   /** Modified allowing execution only if the crowdsale is currently running.  */
817   modifier inState(State state) {
818     if(getState() != state) throw;
819     _;
820   }
821 
822 
823   //
824   // Abstract functions
825   //
826 
827   /**
828    * Check if the current invested breaks our cap rules.
829    *
830    *
831    * The child contract must define their own cap setting rules.
832    * We allow a lot of flexibility through different capping strategies (ETH, token count)
833    * Called from invest().
834    *
835    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
836    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
837    * @param weiRaisedTotal What would be our total raised balance after this transaction
838    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
839    *
840    * @return true if taking this investment would break our cap rules
841    */
842   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
843 
844   /**
845    * Check if the current crowdsale is full and we can no longer sell any tokens.
846    */
847   function isCrowdsaleFull() public constant returns (bool);
848 
849   /**
850    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
851    */
852   function assignTokens(address receiver, uint tokenAmount) private;
853 }
854 
855 /**
856  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
857  *
858  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
859  */
860 
861 
862 
863 
864 
865 
866 
867 /**
868  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
869  *
870  * Based on code by FirstBlood:
871  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
872  */
873 contract StandardToken is ERC20, SafeMath {
874 
875   /* Token supply got increased and a new owner received these tokens */
876   event Minted(address receiver, uint amount);
877 
878   /* Actual balances of token holders */
879   mapping(address => uint) balances;
880 
881   /* approve() allowances */
882   mapping (address => mapping (address => uint)) allowed;
883 
884   /* Interface declaration */
885   function isToken() public constant returns (bool weAre) {
886     return true;
887   }
888 
889   function transfer(address _to, uint _value) returns (bool success) {
890     balances[msg.sender] = safeSub(balances[msg.sender], _value);
891     balances[_to] = safeAdd(balances[_to], _value);
892     Transfer(msg.sender, _to, _value);
893     return true;
894   }
895 
896   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
897     uint _allowance = allowed[_from][msg.sender];
898 
899     balances[_to] = safeAdd(balances[_to], _value);
900     balances[_from] = safeSub(balances[_from], _value);
901     allowed[_from][msg.sender] = safeSub(_allowance, _value);
902     Transfer(_from, _to, _value);
903     return true;
904   }
905 
906   function balanceOf(address _owner) constant returns (uint balance) {
907     return balances[_owner];
908   }
909 
910   function approve(address _spender, uint _value) returns (bool success) {
911 
912     // To change the approve amount you first have to reduce the addresses`
913     //  allowance to zero by calling `approve(_spender, 0)` if it is not
914     //  already 0 to mitigate the race condition described here:
915     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
916     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
917 
918     allowed[msg.sender][_spender] = _value;
919     Approval(msg.sender, _spender, _value);
920     return true;
921   }
922 
923   function allowance(address _owner, address _spender) constant returns (uint remaining) {
924     return allowed[_owner][_spender];
925   }
926 
927 }
928 
929 
930 
931 /**
932  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
933  *
934  * - Collect funds from pre-sale investors
935  * - Send funds to the crowdsale when it opens
936  * - Allow owner to set the crowdsale
937  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
938  * - Allow unlimited investors
939  * - Tokens are distributed on PreICOProxyBuyer smart contract first
940  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
941  * - All functions can be halted by owner if something goes wrong
942  *
943  */
944 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
945 
946   /** How many investors we have now */
947   uint public investorCount;
948 
949   /** How many wei we have raised totla. */
950   uint public weiRaised;
951 
952   /** Who are our investors (iterable) */
953   address[] public investors;
954 
955   /** How much they have invested */
956   mapping(address => uint) public balances;
957 
958   /** How many tokens investors have claimed */
959   mapping(address => uint) public claimed;
960 
961   /** When our refund freeze is over (UNIT timestamp) */
962   uint public freezeEndsAt;
963 
964   /** What is the minimum buy in */
965   uint public weiMinimumLimit;
966 
967   /** What is the maximum buy in */
968   uint public weiMaximumLimit;
969 
970   /** How many weis total we are allowed to collect. */
971   uint public weiCap;
972 
973   /** How many tokens were bought */
974   uint public tokensBought;
975 
976    /** How many investors have claimed their tokens */
977   uint public claimCount;
978 
979   uint public totalClaimed;
980 
981   /** This is used to signal that we want the refund **/
982   bool public forcedRefund;
983 
984   /** Our ICO contract where we will move the funds */
985   Crowdsale public crowdsale;
986 
987   /** What is our current state. */
988   enum State{Unknown, Funding, Distributing, Refunding}
989 
990   /** Somebody loaded their investment money */
991   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
992 
993   /** Refund claimed */
994   event Refunded(address investor, uint value);
995 
996   /** We executed our buy */
997   event TokensBoughts(uint count);
998 
999   /** We distributed tokens to an investor */
1000   event Distributed(address investor, uint count);
1001 
1002   /**
1003    * Create presale contract where lock up period is given days
1004    */
1005   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
1006 
1007     owner = _owner;
1008 
1009     // Give argument
1010     if(_freezeEndsAt == 0) {
1011       throw;
1012     }
1013 
1014     // Give argument
1015     if(_weiMinimumLimit == 0) {
1016       throw;
1017     }
1018 
1019     if(_weiMaximumLimit == 0) {
1020       throw;
1021     }
1022 
1023     weiMinimumLimit = _weiMinimumLimit;
1024     weiMaximumLimit = _weiMaximumLimit;
1025     weiCap = _weiCap;
1026     freezeEndsAt = _freezeEndsAt;
1027   }
1028 
1029   /**
1030    * Get the token we are distributing.
1031    */
1032   function getToken() public constant returns(FractionalERC20) {
1033     if(address(crowdsale) == 0)  {
1034       throw;
1035     }
1036 
1037     return crowdsale.token();
1038   }
1039 
1040   /**
1041    * Participate to a presale.
1042    */
1043   function invest(uint128 customerId) private {
1044 
1045     // Cannot invest anymore through crowdsale when moving has begun
1046     if(getState() != State.Funding) throw;
1047 
1048     if(msg.value == 0) throw; // No empty buys
1049 
1050     address investor = msg.sender;
1051 
1052     bool existing = balances[investor] > 0;
1053 
1054     balances[investor] = safeAdd(balances[investor], msg.value);
1055 
1056     // Need to satisfy minimum and maximum limits
1057     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1058       throw;
1059     }
1060 
1061     // This is a new investor
1062     if(!existing) {
1063       investors.push(investor);
1064       investorCount++;
1065     }
1066 
1067     weiRaised = safeAdd(weiRaised, msg.value);
1068     if(weiRaised > weiCap) {
1069       throw;
1070     }
1071 
1072     // We will use the same event form the Crowdsale for compatibility reasons
1073     // despite not having a token amount.
1074     Invested(investor, msg.value, 0, customerId);
1075   }
1076 
1077   function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
1078     invest(customerId);
1079   }
1080 
1081   function buy() public stopInEmergency payable {
1082     invest(0x0);
1083   }
1084 
1085 
1086   /**
1087    * Load funds to the crowdsale for all investors.
1088    *
1089    *
1090    */
1091   function buyForEverybody() stopNonOwnersInEmergency public {
1092 
1093     if(getState() != State.Funding) {
1094       // Only allow buy once
1095       throw;
1096     }
1097 
1098     // Crowdsale not yet set
1099     if(address(crowdsale) == 0) throw;
1100 
1101     // Buy tokens on the contract
1102     crowdsale.invest.value(weiRaised)(address(this));
1103 
1104     // Record how many tokens we got
1105     tokensBought = getToken().balanceOf(address(this));
1106 
1107     if(tokensBought == 0) {
1108       // Did not get any tokens
1109       throw;
1110     }
1111 
1112     TokensBoughts(tokensBought);
1113   }
1114 
1115   /**
1116    * How may tokens each investor gets.
1117    */
1118   function getClaimAmount(address investor) public constant returns (uint) {
1119 
1120     // Claims can be only made if we manage to buy tokens
1121     if(getState() != State.Distributing) {
1122       throw;
1123     }
1124     return safeMul(balances[investor], tokensBought) / weiRaised;
1125   }
1126 
1127   /**
1128    * How many tokens remain unclaimed for an investor.
1129    */
1130   function getClaimLeft(address investor) public constant returns (uint) {
1131     return safeSub(getClaimAmount(investor), claimed[investor]);
1132   }
1133 
1134   /**
1135    * Claim all remaining tokens for this investor.
1136    */
1137   function claimAll() {
1138     claim(getClaimLeft(msg.sender));
1139   }
1140 
1141   /**
1142    * Claim N bought tokens to the investor as the msg sender.
1143    *
1144    */
1145   function claim(uint amount) stopInEmergency {
1146     address investor = msg.sender;
1147 
1148     if(amount == 0) {
1149       throw;
1150     }
1151 
1152     if(getClaimLeft(investor) < amount) {
1153       // Woops we cannot get more than we have left
1154       throw;
1155     }
1156 
1157     // We track who many investor have (partially) claimed their tokens
1158     if(claimed[investor] == 0) {
1159       claimCount++;
1160     }
1161 
1162     claimed[investor] = safeAdd(claimed[investor], amount);
1163     totalClaimed = safeAdd(totalClaimed, amount);
1164     getToken().transfer(investor, amount);
1165 
1166     Distributed(investor, amount);
1167   }
1168 
1169   /**
1170    * ICO never happened. Allow refund.
1171    */
1172   function refund() stopInEmergency {
1173 
1174     // Trying to ask refund too soon
1175     if(getState() != State.Refunding) throw;
1176 
1177     address investor = msg.sender;
1178     if(balances[investor] == 0) throw;
1179     uint amount = balances[investor];
1180     delete balances[investor];
1181     if(!(investor.call.value(amount)())) throw;
1182     Refunded(investor, amount);
1183   }
1184 
1185   /**
1186    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1187    */
1188   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1189     crowdsale = _crowdsale;
1190 
1191     // Check interface
1192     if(!crowdsale.isCrowdsale()) true;
1193   }
1194 
1195   /// @dev This is used in the first case scenario, this will force the state
1196   ///      to refunding. This can be also used when the ICO fails to meet the cap.
1197   function forceRefund() public onlyOwner {
1198     forcedRefund = true;
1199   }
1200 
1201   /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
1202   ///      we can't use Crowdsale's refund, since our default function does not
1203   ///      accept money in.
1204   function loadRefund() public payable {
1205     if(getState() != State.Refunding) throw;
1206   }
1207 
1208   /**
1209    * Resolve the contract umambigious state.
1210    */
1211   function getState() public returns(State) {
1212     if (forcedRefund)
1213       return State.Refunding;
1214 
1215     if(tokensBought == 0) {
1216       if(now >= freezeEndsAt) {
1217          return State.Refunding;
1218       } else {
1219         return State.Funding;
1220       }
1221     } else {
1222       return State.Distributing;
1223     }
1224   }
1225 
1226   /** Interface marker. */
1227   function isPresale() public constant returns (bool) {
1228     return true;
1229   }
1230 
1231   /** Explicitly call function from your wallet. */
1232   function() payable {
1233     throw;
1234   }
1235 }