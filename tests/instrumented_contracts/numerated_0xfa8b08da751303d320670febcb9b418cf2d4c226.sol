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
121   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123 
124   /**
125    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126    * account.
127    */
128   function Ownable() {
129     owner = msg.sender;
130   }
131 
132 
133   /**
134    * @dev Throws if called by any account other than the owner.
135    */
136   modifier onlyOwner() {
137     require(msg.sender == owner);
138     _;
139   }
140 
141 
142   /**
143    * @dev Allows the current owner to transfer control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function transferOwnership(address newOwner) onlyOwner public {
147     require(newOwner != address(0));
148     OwnershipTransferred(owner, newOwner);
149     owner = newOwner;
150   }
151 
152 }
153 
154 
155 /*
156  * Haltable
157  *
158  * Abstract contract that allows children to implement an
159  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
160  *
161  *
162  * Originally envisioned in FirstBlood ICO contract.
163  */
164 contract Haltable is Ownable {
165   bool public halted;
166 
167   modifier stopInEmergency {
168     if (halted) throw;
169     _;
170   }
171 
172   modifier stopNonOwnersInEmergency {
173     if (halted && msg.sender != owner) throw;
174     _;
175   }
176 
177   modifier onlyInEmergency {
178     if (!halted) throw;
179     _;
180   }
181 
182   // called by the owner on emergency, triggers stopped state
183   function halt() external onlyOwner {
184     halted = true;
185   }
186 
187   // called by the owner on end of emergency, returns to normal state
188   function unhalt() external onlyOwner onlyInEmergency {
189     halted = false;
190   }
191 
192 }
193 
194 /**
195  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
196  *
197  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
198  */
199 
200 
201 /**
202  * Interface for defining crowdsale pricing.
203  */
204 contract PricingStrategy {
205 
206   /** Interface declaration. */
207   function isPricingStrategy() public constant returns (bool) {
208     return true;
209   }
210 
211   /** Self check if all references are correctly set.
212    *
213    * Checks that pricing strategy matches crowdsale parameters.
214    */
215   function isSane(address crowdsale) public constant returns (bool) {
216     return true;
217   }
218 
219   /**
220    * @dev Pricing tells if this is a presale purchase or not.
221      @param purchaser Address of the purchaser
222      @return False by default, true if a presale purchaser
223    */
224   function isPresalePurchase(address purchaser) public constant returns (bool) {
225     return false;
226   }
227 
228   /**
229    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
230    *
231    *
232    * @param value - What is the value of the transaction send in as wei
233    * @param tokensSold - how much tokens have been sold this far
234    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
235    * @param msgSender - who is the investor of this transaction
236    * @param decimals - how many decimal units the token has
237    * @return Amount of tokens the investor receives
238    */
239   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
240 }
241 
242 /**
243  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
244  *
245  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
246  */
247 
248 
249 /**
250  * Finalize agent defines what happens at the end of succeseful crowdsale.
251  *
252  * - Allocate tokens for founders, bounties and community
253  * - Make tokens transferable
254  * - etc.
255  */
256 contract FinalizeAgent {
257 
258   function isFinalizeAgent() public constant returns(bool) {
259     return true;
260   }
261 
262   /** Return true if we can run finalizeCrowdsale() properly.
263    *
264    * This is a safety check function that doesn't allow crowdsale to begin
265    * unless the finalizer has been set up properly.
266    */
267   function isSane() public constant returns (bool);
268 
269   /** Called once by crowdsale finalize() if the sale was success. */
270   function finalizeCrowdsale();
271 
272 }
273 
274 /**
275  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
276  *
277  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
278  */
279 
280 
281 
282 
283 
284 
285 /**
286  * @title ERC20Basic
287  * @dev Simpler version of ERC20 interface
288  * @dev see https://github.com/ethereum/EIPs/issues/179
289  */
290 contract ERC20Basic {
291   uint256 public totalSupply;
292   function balanceOf(address who) public constant returns (uint256);
293   function transfer(address to, uint256 value) public returns (bool);
294   event Transfer(address indexed from, address indexed to, uint256 value);
295 }
296 
297 
298 
299 /**
300  * @title ERC20 interface
301  * @dev see https://github.com/ethereum/EIPs/issues/20
302  */
303 contract ERC20 is ERC20Basic {
304   function allowance(address owner, address spender) public constant returns (uint256);
305   function transferFrom(address from, address to, uint256 value) public returns (bool);
306   function approve(address spender, uint256 value) public returns (bool);
307   event Approval(address indexed owner, address indexed spender, uint256 value);
308 }
309 
310 
311 /**
312  * A token that defines fractional units as decimals.
313  */
314 contract FractionalERC20 is ERC20 {
315 
316   uint public decimals;
317 
318 }
319 
320 
321 
322 /**
323  * Abstract base contract for token sales.
324  *
325  * Handle
326  * - start and end dates
327  * - accepting investments
328  * - minimum funding goal and refund
329  * - various statistics during the crowdfund
330  * - different pricing strategies
331  * - different investment policies (require server side customer id, allow only whitelisted addresses)
332  *
333  */
334 contract Crowdsale is Haltable {
335 
336   /* Max investment count when we are still allowed to change the multisig address */
337   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
338 
339   using SafeMathLib for uint;
340 
341   /* The token we are selling */
342   FractionalERC20 public token;
343 
344   /* How we are going to price our offering */
345   PricingStrategy public pricingStrategy;
346 
347   /* Post-success callback */
348   FinalizeAgent public finalizeAgent;
349 
350   /* tokens will be transfered from this address */
351   address public multisigWallet;
352 
353   /* if the funding goal is not reached, investors may withdraw their funds */
354   uint public minimumFundingGoal;
355 
356   /* the UNIX timestamp start date of the crowdsale */
357   uint public startsAt;
358 
359   /* the UNIX timestamp end date of the crowdsale */
360   uint public endsAt;
361 
362   /* the number of tokens already sold through this contract*/
363   uint public tokensSold = 0;
364 
365   /* How many wei of funding we have raised */
366   uint public weiRaised = 0;
367 
368   /* Calculate incoming funds from presale contracts and addresses */
369   uint public presaleWeiRaised = 0;
370 
371   /* How many distinct addresses have invested */
372   uint public investorCount = 0;
373 
374   /* How much wei we have returned back to the contract after a failed crowdfund. */
375   uint public loadedRefund = 0;
376 
377   /* How much wei we have given back to investors.*/
378   uint public weiRefunded = 0;
379 
380   /* Has this crowdsale been finalized */
381   bool public finalized;
382 
383   /* Do we need to have unique contributor id for each customer */
384   bool public requireCustomerId;
385 
386   /**
387     * Do we verify that contributor has been cleared on the server side (accredited investors only).
388     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
389     */
390   bool public requiredSignedAddress;
391 
392   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
393   address public signerAddress;
394 
395   /** How much ETH each address has invested to this crowdsale */
396   mapping (address => uint256) public investedAmountOf;
397 
398   /** How much tokens this crowdsale has credited for each investor address */
399   mapping (address => uint256) public tokenAmountOf;
400 
401   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
402   mapping (address => bool) public earlyParticipantWhitelist;
403 
404   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
405   uint public ownerTestValue;
406 
407   /** State machine
408    *
409    * - Preparing: All contract initialization calls and variables have not been set yet
410    * - Prefunding: We have not passed start time yet
411    * - Funding: Active crowdsale
412    * - Success: Minimum funding goal reached
413    * - Failure: Minimum funding goal not reached before ending time
414    * - Finalized: The finalized has been called and succesfully executed
415    * - Refunding: Refunds are loaded on the contract for reclaim.
416    */
417   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
418 
419   // A new investment was made
420   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
421 
422   // Refund was processed for a contributor
423   event Refund(address investor, uint weiAmount);
424 
425   // The rules were changed what kind of investments we accept
426   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
427 
428   // Address early participation whitelist status changed
429   event Whitelisted(address addr, bool status);
430 
431   // Crowdsale end time has been changed
432   event EndsAtChanged(uint newEndsAt);
433 
434   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
435 
436     owner = msg.sender;
437 
438     token = FractionalERC20(_token);
439 
440     setPricingStrategy(_pricingStrategy);
441 
442     multisigWallet = _multisigWallet;
443     if(multisigWallet == 0) {
444         throw;
445     }
446 
447     if(_start == 0) {
448         throw;
449     }
450 
451     startsAt = _start;
452 
453     if(_end == 0) {
454         throw;
455     }
456 
457     endsAt = _end;
458 
459     // Don't mess the dates
460     if(startsAt >= endsAt) {
461         throw;
462     }
463 
464     // Minimum funding goal can be zero
465     minimumFundingGoal = _minimumFundingGoal;
466   }
467 
468   /**
469    * Don't expect to just send in money and get tokens.
470    */
471   function() payable {
472     throw;
473   }
474 
475   /**
476    * Make an investment.
477    *
478    * Crowdsale must be running for one to invest.
479    * We must have not pressed the emergency brake.
480    *
481    * @param receiver The Ethereum address who receives the tokens
482    * @param customerId (optional) UUID v4 to track the successful payments on the server side
483    *
484    */
485   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
486 
487     // Determine if it's a good time to accept investment from this participant
488     if(getState() == State.PreFunding) {
489       // Are we whitelisted for early deposit
490       if(!earlyParticipantWhitelist[receiver]) {
491         throw;
492       }
493     } else if(getState() == State.Funding) {
494       // Retail participants can only come in when the crowdsale is running
495       // pass
496     } else {
497       // Unwanted state
498       throw;
499     }
500 
501     uint weiAmount = msg.value;
502 
503     // Account presale sales separately, so that they do not count against pricing tranches
504     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
505 
506     if(tokenAmount == 0) {
507       // Dust transaction
508       throw;
509     }
510 
511     if(investedAmountOf[receiver] == 0) {
512        // A new investor
513        investorCount++;
514     }
515 
516     // Update investor
517     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
518     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
519 
520     // Update totals
521     weiRaised = weiRaised.plus(weiAmount);
522     tokensSold = tokensSold.plus(tokenAmount);
523 
524     if(pricingStrategy.isPresalePurchase(receiver)) {
525         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
526     }
527 
528     // Check that we did not bust the cap
529     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
530       throw;
531     }
532 
533     assignTokens(receiver, tokenAmount);
534 
535     // Pocket the money
536     if(!multisigWallet.send(weiAmount)) throw;
537 
538     // Tell us invest was success
539     Invested(receiver, weiAmount, tokenAmount, customerId);
540   }
541 
542   /**
543    * Preallocate tokens for the early investors.
544    *
545    * Preallocated tokens have been sold before the actual crowdsale opens.
546    * This function mints the tokens and moves the crowdsale needle.
547    *
548    * Investor count is not handled; it is assumed this goes for multiple investors
549    * and the token distribution happens outside the smart contract flow.
550    *
551    * No money is exchanged, as the crowdsale team already have received the payment.
552    *
553    * @param fullTokens tokens as full tokens - decimal places added internally
554    * @param weiPrice Price of a single full token in wei
555    *
556    */
557   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
558 
559     uint tokenAmount = fullTokens * 10**token.decimals();
560     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
561 
562     weiRaised = weiRaised.plus(weiAmount);
563     tokensSold = tokensSold.plus(tokenAmount);
564 
565     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
566     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
567 
568     assignTokens(receiver, tokenAmount);
569 
570     // Tell us invest was success
571     Invested(receiver, weiAmount, tokenAmount, 0);
572   }
573 
574   /**
575    * Allow anonymous contributions to this crowdsale.
576    */
577   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
578      bytes32 hash = sha256(addr);
579      if (ecrecover(hash, v, r, s) != signerAddress) throw;
580      if(customerId == 0) throw;  // UUIDv4 sanity check
581      investInternal(addr, customerId);
582   }
583 
584   /**
585    * Track who is the customer making the payment so we can send thank you email.
586    */
587   function investWithCustomerId(address addr, uint128 customerId) public payable {
588     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
589     if(customerId == 0) throw;  // UUIDv4 sanity check
590     investInternal(addr, customerId);
591   }
592 
593   /**
594    * Allow anonymous contributions to this crowdsale.
595    */
596   function invest(address addr) public payable {
597     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
598     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
599     investInternal(addr, 0);
600   }
601 
602   /**
603    * Invest to tokens, recognize the payer and clear his address.
604    *
605    */
606   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
607     investWithSignedAddress(msg.sender, customerId, v, r, s);
608   }
609 
610   /**
611    * Invest to tokens, recognize the payer.
612    *
613    */
614   function buyWithCustomerId(uint128 customerId) public payable {
615     investWithCustomerId(msg.sender, customerId);
616   }
617 
618   /**
619    * The basic entry point to participate the crowdsale process.
620    *
621    * Pay for funding, get invested tokens back in the sender address.
622    */
623   function buy() public payable {
624     invest(msg.sender);
625   }
626 
627   /**
628    * Finalize a succcesful crowdsale.
629    *
630    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
631    */
632   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
633 
634     // Already finalized
635     if(finalized) {
636       throw;
637     }
638 
639     // Finalizing is optional. We only call it if we are given a finalizing agent.
640     if(address(finalizeAgent) != 0) {
641       finalizeAgent.finalizeCrowdsale();
642     }
643 
644     finalized = true;
645   }
646 
647   /**
648    * Allow to (re)set finalize agent.
649    *
650    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
651    */
652   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
653     finalizeAgent = addr;
654 
655     // Don't allow setting bad agent
656     if(!finalizeAgent.isFinalizeAgent()) {
657       throw;
658     }
659   }
660 
661   /**
662    * Set policy do we need to have server-side customer ids for the investments.
663    *
664    */
665   function setRequireCustomerId(bool value) onlyOwner {
666     requireCustomerId = value;
667     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
668   }
669 
670   /**
671    * Set policy if all investors must be cleared on the server side first.
672    *
673    * This is e.g. for the accredited investor clearing.
674    *
675    */
676   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
677     requiredSignedAddress = value;
678     signerAddress = _signerAddress;
679     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
680   }
681 
682   /**
683    * Allow addresses to do early participation.
684    *
685    * TODO: Fix spelling error in the name
686    */
687   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
688     earlyParticipantWhitelist[addr] = status;
689     Whitelisted(addr, status);
690   }
691 
692   /**
693    * Allow crowdsale owner to close early or extend the crowdsale.
694    *
695    * This is useful e.g. for a manual soft cap implementation:
696    * - after X amount is reached determine manual closing
697    *
698    * This may put the crowdsale to an invalid state,
699    * but we trust owners know what they are doing.
700    *
701    */
702   function setEndsAt(uint time) onlyOwner {
703 
704     if(now > time) {
705       throw; // Don't change past
706     }
707 
708     endsAt = time;
709     EndsAtChanged(endsAt);
710   }
711 
712   /**
713    * Allow to (re)set pricing strategy.
714    *
715    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
716    */
717   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
718     pricingStrategy = _pricingStrategy;
719 
720     // Don't allow setting bad agent
721     if(!pricingStrategy.isPricingStrategy()) {
722       throw;
723     }
724   }
725 
726   /**
727    * Allow to change the team multisig address in the case of emergency.
728    *
729    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
730    * (we have done only few test transactions). After the crowdsale is going
731    * then multisig address stays locked for the safety reasons.
732    */
733   function setMultisig(address addr) public onlyOwner {
734 
735     // Change
736     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
737       throw;
738     }
739 
740     multisigWallet = addr;
741   }
742 
743   /**
744    * Allow load refunds back on the contract for the refunding.
745    *
746    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
747    */
748   function loadRefund() public payable inState(State.Failure) {
749     if(msg.value == 0) throw;
750     loadedRefund = loadedRefund.plus(msg.value);
751   }
752 
753   /**
754    * Investors can claim refund.
755    *
756    * Note that any refunds from proxy buyers should be handled separately,
757    * and not through this contract.
758    */
759   function refund() public inState(State.Refunding) {
760     uint256 weiValue = investedAmountOf[msg.sender];
761     if (weiValue == 0) throw;
762     investedAmountOf[msg.sender] = 0;
763     weiRefunded = weiRefunded.plus(weiValue);
764     Refund(msg.sender, weiValue);
765     if (!msg.sender.send(weiValue)) throw;
766   }
767 
768   /**
769    * @return true if the crowdsale has raised enough money to be a successful.
770    */
771   function isMinimumGoalReached() public constant returns (bool reached) {
772     return weiRaised >= minimumFundingGoal;
773   }
774 
775   /**
776    * Check if the contract relationship looks good.
777    */
778   function isFinalizerSane() public constant returns (bool sane) {
779     return finalizeAgent.isSane();
780   }
781 
782   /**
783    * Check if the contract relationship looks good.
784    */
785   function isPricingSane() public constant returns (bool sane) {
786     return pricingStrategy.isSane(address(this));
787   }
788 
789   /**
790    * Crowdfund state machine management.
791    *
792    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
793    */
794   function getState() public constant returns (State) {
795     if(finalized) return State.Finalized;
796     else if (address(finalizeAgent) == 0) return State.Preparing;
797     else if (!finalizeAgent.isSane()) return State.Preparing;
798     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
799     else if (block.timestamp < startsAt) return State.PreFunding;
800     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
801     else if (isMinimumGoalReached()) return State.Success;
802     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
803     else return State.Failure;
804   }
805 
806   /** This is for manual testing of multisig wallet interaction */
807   function setOwnerTestValue(uint val) onlyOwner {
808     ownerTestValue = val;
809   }
810 
811   /** Interface marker. */
812   function isCrowdsale() public constant returns (bool) {
813     return true;
814   }
815 
816   //
817   // Modifiers
818   //
819 
820   /** Modified allowing execution only if the crowdsale is currently running.  */
821   modifier inState(State state) {
822     if(getState() != state) throw;
823     _;
824   }
825 
826 
827   //
828   // Abstract functions
829   //
830 
831   /**
832    * Check if the current invested breaks our cap rules.
833    *
834    *
835    * The child contract must define their own cap setting rules.
836    * We allow a lot of flexibility through different capping strategies (ETH, token count)
837    * Called from invest().
838    *
839    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
840    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
841    * @param weiRaisedTotal What would be our total raised balance after this transaction
842    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
843    *
844    * @return true if taking this investment would break our cap rules
845    */
846   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
847 
848   /**
849    * Check if the current crowdsale is full and we can no longer sell any tokens.
850    */
851   function isCrowdsaleFull() public constant returns (bool);
852 
853   /**
854    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
855    */
856   function assignTokens(address receiver, uint tokenAmount) private;
857 }
858 
859 /**
860  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
861  *
862  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
863  */
864 
865 
866 
867 
868 
869 
870 
871 /**
872  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
873  *
874  * Based on code by FirstBlood:
875  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
876  */
877 contract StandardToken is ERC20, SafeMath {
878 
879   /* Token supply got increased and a new owner received these tokens */
880   event Minted(address receiver, uint amount);
881 
882   /* Actual balances of token holders */
883   mapping(address => uint) balances;
884 
885   /* approve() allowances */
886   mapping (address => mapping (address => uint)) allowed;
887 
888   /* Interface declaration */
889   function isToken() public constant returns (bool weAre) {
890     return true;
891   }
892 
893   function transfer(address _to, uint _value) returns (bool success) {
894     balances[msg.sender] = safeSub(balances[msg.sender], _value);
895     balances[_to] = safeAdd(balances[_to], _value);
896     Transfer(msg.sender, _to, _value);
897     return true;
898   }
899 
900   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
901     uint _allowance = allowed[_from][msg.sender];
902 
903     balances[_to] = safeAdd(balances[_to], _value);
904     balances[_from] = safeSub(balances[_from], _value);
905     allowed[_from][msg.sender] = safeSub(_allowance, _value);
906     Transfer(_from, _to, _value);
907     return true;
908   }
909 
910   function balanceOf(address _owner) constant returns (uint balance) {
911     return balances[_owner];
912   }
913 
914   function approve(address _spender, uint _value) returns (bool success) {
915 
916     // To change the approve amount you first have to reduce the addresses`
917     //  allowance to zero by calling `approve(_spender, 0)` if it is not
918     //  already 0 to mitigate the race condition described here:
919     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
920     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
921 
922     allowed[msg.sender][_spender] = _value;
923     Approval(msg.sender, _spender, _value);
924     return true;
925   }
926 
927   function allowance(address _owner, address _spender) constant returns (uint remaining) {
928     return allowed[_owner][_spender];
929   }
930 
931 }
932 
933 
934 
935 /**
936  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
937  *
938  * - Collect funds from pre-sale investors
939  * - Send funds to the crowdsale when it opens
940  * - Allow owner to set the crowdsale
941  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
942  * - Allow unlimited investors
943  * - Tokens are distributed on PreICOProxyBuyer smart contract first
944  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
945  * - All functions can be halted by owner if something goes wrong
946  *
947  */
948 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
949 
950   /** How many investors we have now */
951   uint public investorCount;
952 
953   /** How many wei we have raised totla. */
954   uint public weiRaised;
955 
956   /** Who are our investors (iterable) */
957   address[] public investors;
958 
959   /** How much they have invested */
960   mapping(address => uint) public balances;
961 
962   /** How many tokens investors have claimed */
963   mapping(address => uint) public claimed;
964 
965   /** When our refund freeze is over (UNIT timestamp) */
966   uint public freezeEndsAt;
967 
968   /** What is the minimum buy in */
969   uint public weiMinimumLimit;
970 
971   /** What is the maximum buy in */
972   uint public weiMaximumLimit;
973 
974   /** How many weis total we are allowed to collect. */
975   uint public weiCap;
976 
977   /** How many tokens were bought */
978   uint public tokensBought;
979 
980    /** How many investors have claimed their tokens */
981   uint public claimCount;
982 
983   uint public totalClaimed;
984 
985   /** This is used to signal that we want the refund **/
986   bool public forcedRefund;
987 
988   /** Our ICO contract where we will move the funds */
989   Crowdsale public crowdsale;
990 
991   /** What is our current state. */
992   enum State{Unknown, Funding, Distributing, Refunding}
993 
994   /** Somebody loaded their investment money */
995   event Invested(address investor, uint value, uint128 customerId);
996 
997   /** Refund claimed */
998   event Refunded(address investor, uint value);
999 
1000   /** We executed our buy */
1001   event TokensBoughts(uint count);
1002 
1003   /** We distributed tokens to an investor */
1004   event Distributed(address investor, uint count);
1005 
1006   /**
1007    * Create presale contract where lock up period is given days
1008    */
1009   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
1010 
1011     owner = _owner;
1012 
1013     // Give argument
1014     if(_freezeEndsAt == 0) {
1015       throw;
1016     }
1017 
1018     // Give argument
1019     if(_weiMinimumLimit == 0) {
1020       throw;
1021     }
1022 
1023     if(_weiMaximumLimit == 0) {
1024       throw;
1025     }
1026 
1027     weiMinimumLimit = _weiMinimumLimit;
1028     weiMaximumLimit = _weiMaximumLimit;
1029     weiCap = _weiCap;
1030     freezeEndsAt = _freezeEndsAt;
1031   }
1032 
1033   /**
1034    * Get the token we are distributing.
1035    */
1036   function getToken() public constant returns(FractionalERC20) {
1037     if(address(crowdsale) == 0)  {
1038       throw;
1039     }
1040 
1041     return crowdsale.token();
1042   }
1043 
1044   /**
1045    * Participate to a presale.
1046    */
1047   function invest(uint128 customerId) private {
1048 
1049     // Cannot invest anymore through crowdsale when moving has begun
1050     if(getState() != State.Funding) throw;
1051 
1052     if(msg.value == 0) throw; // No empty buys
1053 
1054     address investor = msg.sender;
1055 
1056     bool existing = balances[investor] > 0;
1057 
1058     balances[investor] = safeAdd(balances[investor], msg.value);
1059 
1060     // Need to satisfy minimum and maximum limits
1061     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1062       throw;
1063     }
1064 
1065     // This is a new investor
1066     if(!existing) {
1067       investors.push(investor);
1068       investorCount++;
1069     }
1070 
1071     weiRaised = safeAdd(weiRaised, msg.value);
1072     if(weiRaised > weiCap) {
1073       throw;
1074     }
1075 
1076     // We will use the same event form the Crowdsale for compatibility reasons
1077     // despite not having a token amount.
1078     //Invested(investor, msg.value, 0, customerId);
1079   }
1080 
1081   function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
1082     invest(customerId);
1083   }
1084 
1085   function buy() public stopInEmergency payable {
1086     invest(0x0);
1087   }
1088 
1089 
1090   /**
1091    * Load funds to the crowdsale for all investors.
1092    *
1093    *
1094    */
1095   function buyForEverybody() stopNonOwnersInEmergency public {
1096 
1097     if(getState() != State.Funding) {
1098       // Only allow buy once
1099       throw;
1100     }
1101 
1102     // Crowdsale not yet set
1103     if(address(crowdsale) == 0) throw;
1104 
1105     // Buy tokens on the contract
1106     crowdsale.invest.value(weiRaised)(address(this));
1107 
1108     // Record how many tokens we got
1109     tokensBought = getToken().balanceOf(address(this));
1110 
1111     if(tokensBought == 0) {
1112       // Did not get any tokens
1113       throw;
1114     }
1115 
1116     TokensBoughts(tokensBought);
1117   }
1118 
1119   /**
1120    * How may tokens each investor gets.
1121    */
1122   function getClaimAmount(address investor) public constant returns (uint) {
1123 
1124     // Claims can be only made if we manage to buy tokens
1125     if(getState() != State.Distributing) {
1126       throw;
1127     }
1128     return safeMul(balances[investor], tokensBought) / weiRaised;
1129   }
1130 
1131   /**
1132    * How many tokens remain unclaimed for an investor.
1133    */
1134   function getClaimLeft(address investor) public constant returns (uint) {
1135     return safeSub(getClaimAmount(investor), claimed[investor]);
1136   }
1137 
1138   /**
1139    * Claim all remaining tokens for this investor.
1140    */
1141   function claimAll() {
1142     claim(getClaimLeft(msg.sender));
1143   }
1144 
1145   /**
1146    * Claim N bought tokens to the investor as the msg sender.
1147    *
1148    */
1149   function claim(uint amount) stopInEmergency {
1150     address investor = msg.sender;
1151 
1152     if(amount == 0) {
1153       throw;
1154     }
1155 
1156     if(getClaimLeft(investor) < amount) {
1157       // Woops we cannot get more than we have left
1158       throw;
1159     }
1160 
1161     // We track who many investor have (partially) claimed their tokens
1162     if(claimed[investor] == 0) {
1163       claimCount++;
1164     }
1165 
1166     claimed[investor] = safeAdd(claimed[investor], amount);
1167     totalClaimed = safeAdd(totalClaimed, amount);
1168     getToken().transfer(investor, amount);
1169 
1170     Distributed(investor, amount);
1171   }
1172 
1173   /**
1174    * ICO never happened. Allow refund.
1175    */
1176   function refund() stopInEmergency {
1177 
1178     // Trying to ask refund too soon
1179     if(getState() != State.Refunding) throw;
1180 
1181     address investor = msg.sender;
1182     if(balances[investor] == 0) throw;
1183     uint amount = balances[investor];
1184     delete balances[investor];
1185     if(!(investor.call.value(amount)())) throw;
1186     Refunded(investor, amount);
1187   }
1188 
1189   /**
1190    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1191    */
1192   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1193     crowdsale = _crowdsale;
1194 
1195     // Check interface
1196     if(!crowdsale.isCrowdsale()) true;
1197   }
1198 
1199   /// @dev This is used in the first case scenario, this will force the state
1200   ///      to refunding. This can be also used when the ICO fails to meet the cap.
1201   function forceRefund() public onlyOwner {
1202     forcedRefund = true;
1203   }
1204 
1205   /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
1206   ///      we can't use Crowdsale's refund, since our default function does not
1207   ///      accept money in.
1208   function loadRefund() public payable {
1209     if(getState() != State.Refunding) throw;
1210   }
1211 
1212   /**
1213    * Resolve the contract umambigious state.
1214    */
1215   function getState() public returns(State) {
1216     if (forcedRefund)
1217       return State.Refunding;
1218 
1219     if(tokensBought == 0) {
1220       if(now >= freezeEndsAt) {
1221          return State.Refunding;
1222       } else {
1223         return State.Funding;
1224       }
1225     } else {
1226       return State.Distributing;
1227     }
1228   }
1229 
1230   /** Interface marker. */
1231   function isPresale() public constant returns (bool) {
1232     return true;
1233   }
1234 
1235   /** Explicitly call function from your wallet. */
1236   function() payable {
1237     throw;
1238   }
1239 }