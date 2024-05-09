1 // (C) 2017 TokenMarket Ltd. (https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt) Commit: d9e308ff22556a8f40909b1f89ec0f759d1337e0
2 /**
3  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
4  *
5  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
6  */
7 
8 
9 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
10 
11 
12 
13 /**
14  * Math operations with safety checks
15  */
16 contract SafeMath {
17   function safeMul(uint a, uint b) internal returns (uint) {
18     uint c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function safeDiv(uint a, uint b) internal returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29 
30   function safeSub(uint a, uint b) internal returns (uint) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function safeAdd(uint a, uint b) internal returns (uint) {
36     uint c = a + b;
37     assert(c>=a && c>=b);
38     return c;
39   }
40 
41   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56 
57 }
58 
59 /**
60  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
61  *
62  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
63  */
64 
65 
66 /**
67  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
68  *
69  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
70  */
71 
72 
73 /**
74  * Safe unsigned safe math.
75  *
76  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
77  *
78  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
79  *
80  * Maintained here until merged to mainline zeppelin-solidity.
81  *
82  */
83 library SafeMathLib {
84 
85   function times(uint a, uint b) returns (uint) {
86     uint c = a * b;
87     assert(a == 0 || c / a == b);
88     return c;
89   }
90 
91   function minus(uint a, uint b) returns (uint) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   function plus(uint a, uint b) returns (uint) {
97     uint c = a + b;
98     assert(c>=a);
99     return c;
100   }
101 
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
113 /**
114  * @title Ownable
115  * @dev The Ownable contract has an owner address, and provides basic authorization control
116  * functions, this simplifies the implementation of "user permissions".
117  */
118 contract Ownable {
119   address public owner;
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
144   function transferOwnership(address newOwner) onlyOwner {
145     require(newOwner != address(0));      
146     owner = newOwner;
147   }
148 
149 }
150 
151 
152 /*
153  * Haltable
154  *
155  * Abstract contract that allows children to implement an
156  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
157  *
158  *
159  * Originally envisioned in FirstBlood ICO contract.
160  */
161 contract Haltable is Ownable {
162   bool public halted;
163 
164   modifier stopInEmergency {
165     if (halted) throw;
166     _;
167   }
168 
169   modifier stopNonOwnersInEmergency {
170     if (halted && msg.sender != owner) throw;
171     _;
172   }
173 
174   modifier onlyInEmergency {
175     if (!halted) throw;
176     _;
177   }
178 
179   // called by the owner on emergency, triggers stopped state
180   function halt() external onlyOwner {
181     halted = true;
182   }
183 
184   // called by the owner on end of emergency, returns to normal state
185   function unhalt() external onlyOwner onlyInEmergency {
186     halted = false;
187   }
188 
189 }
190 
191 /**
192  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
193  *
194  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
195  */
196 
197 
198 /**
199  * Interface for defining crowdsale pricing.
200  */
201 contract PricingStrategy {
202 
203   /** Interface declaration. */
204   function isPricingStrategy() public constant returns (bool) {
205     return true;
206   }
207 
208   /** Self check if all references are correctly set.
209    *
210    * Checks that pricing strategy matches crowdsale parameters.
211    */
212   function isSane(address crowdsale) public constant returns (bool) {
213     return true;
214   }
215 
216   /**
217    * @dev Pricing tells if this is a presale purchase or not.
218      @param purchaser Address of the purchaser
219      @return False by default, true if a presale purchaser
220    */
221   function isPresalePurchase(address purchaser) public constant returns (bool) {
222     return false;
223   }
224 
225   /**
226    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
227    *
228    *
229    * @param value - What is the value of the transaction send in as wei
230    * @param tokensSold - how much tokens have been sold this far
231    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
232    * @param msgSender - who is the investor of this transaction
233    * @param decimals - how many decimal units the token has
234    * @return Amount of tokens the investor receives
235    */
236   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
237 }
238 
239 /**
240  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
241  *
242  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
243  */
244 
245 
246 /**
247  * Finalize agent defines what happens at the end of succeseful crowdsale.
248  *
249  * - Allocate tokens for founders, bounties and community
250  * - Make tokens transferable
251  * - etc.
252  */
253 contract FinalizeAgent {
254 
255   function isFinalizeAgent() public constant returns(bool) {
256     return true;
257   }
258 
259   /** Return true if we can run finalizeCrowdsale() properly.
260    *
261    * This is a safety check function that doesn't allow crowdsale to begin
262    * unless the finalizer has been set up properly.
263    */
264   function isSane() public constant returns (bool);
265 
266   /** Called once by crowdsale finalize() if the sale was success. */
267   function finalizeCrowdsale();
268 
269 }
270 
271 /**
272  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
273  *
274  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
275  */
276 
277 
278 
279 
280 
281 
282 /**
283  * @title ERC20Basic
284  * @dev Simpler version of ERC20 interface
285  * @dev see https://github.com/ethereum/EIPs/issues/179
286  */
287 contract ERC20Basic {
288   uint256 public totalSupply;
289   function balanceOf(address who) constant returns (uint256);
290   function transfer(address to, uint256 value) returns (bool);
291   event Transfer(address indexed from, address indexed to, uint256 value);
292 }
293 
294 
295 
296 /**
297  * @title ERC20 interface
298  * @dev see https://github.com/ethereum/EIPs/issues/20
299  */
300 contract ERC20 is ERC20Basic {
301   function allowance(address owner, address spender) constant returns (uint256);
302   function transferFrom(address from, address to, uint256 value) returns (bool);
303   function approve(address spender, uint256 value) returns (bool);
304   event Approval(address indexed owner, address indexed spender, uint256 value);
305 }
306 
307 
308 /**
309  * A token that defines fractional units as decimals.
310  */
311 contract FractionalERC20 is ERC20 {
312 
313   uint public decimals;
314 
315 }
316 
317 
318 
319 /**
320  * Abstract base contract for token sales.
321  *
322  * Handle
323  * - start and end dates
324  * - accepting investments
325  * - minimum funding goal and refund
326  * - various statistics during the crowdfund
327  * - different pricing strategies
328  * - different investment policies (require server side customer id, allow only whitelisted addresses)
329  *
330  */
331 contract Crowdsale is Haltable {
332 
333   /* Max investment count when we are still allowed to change the multisig address */
334   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
335 
336   using SafeMathLib for uint;
337 
338   /* The token we are selling */
339   FractionalERC20 public token;
340 
341   /* How we are going to price our offering */
342   PricingStrategy public pricingStrategy;
343 
344   /* Post-success callback */
345   FinalizeAgent public finalizeAgent;
346 
347   /* tokens will be transfered from this address */
348   address public multisigWallet;
349 
350   /* if the funding goal is not reached, investors may withdraw their funds */
351   uint public minimumFundingGoal;
352 
353   /* the UNIX timestamp start date of the crowdsale */
354   uint public startsAt;
355 
356   /* the UNIX timestamp end date of the crowdsale */
357   uint public endsAt;
358 
359   /* the number of tokens already sold through this contract*/
360   uint public tokensSold = 0;
361 
362   /* How many wei of funding we have raised */
363   uint public weiRaised = 0;
364 
365   /* Calculate incoming funds from presale contracts and addresses */
366   uint public presaleWeiRaised = 0;
367 
368   /* How many distinct addresses have invested */
369   uint public investorCount = 0;
370 
371   /* How much wei we have returned back to the contract after a failed crowdfund. */
372   uint public loadedRefund = 0;
373 
374   /* How much wei we have given back to investors.*/
375   uint public weiRefunded = 0;
376 
377   /* Has this crowdsale been finalized */
378   bool public finalized;
379 
380   /* Do we need to have unique contributor id for each customer */
381   bool public requireCustomerId;
382 
383   /**
384     * Do we verify that contributor has been cleared on the server side (accredited investors only).
385     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
386     */
387   bool public requiredSignedAddress;
388 
389   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
390   address public signerAddress;
391 
392   /** How much ETH each address has invested to this crowdsale */
393   mapping (address => uint256) public investedAmountOf;
394 
395   /** How much tokens this crowdsale has credited for each investor address */
396   mapping (address => uint256) public tokenAmountOf;
397 
398   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
399   mapping (address => bool) public earlyParticipantWhitelist;
400 
401   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
402   uint public ownerTestValue;
403 
404   /** State machine
405    *
406    * - Preparing: All contract initialization calls and variables have not been set yet
407    * - Prefunding: We have not passed start time yet
408    * - Funding: Active crowdsale
409    * - Success: Minimum funding goal reached
410    * - Failure: Minimum funding goal not reached before ending time
411    * - Finalized: The finalized has been called and succesfully executed
412    * - Refunding: Refunds are loaded on the contract for reclaim.
413    */
414   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
415 
416   // A new investment was made
417   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
418 
419   // Refund was processed for a contributor
420   event Refund(address investor, uint weiAmount);
421 
422   // The rules were changed what kind of investments we accept
423   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
424 
425   // Address early participation whitelist status changed
426   event Whitelisted(address addr, bool status);
427 
428   // Crowdsale end time has been changed
429   event EndsAtChanged(uint newEndsAt);
430 
431   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
432 
433     owner = msg.sender;
434 
435     token = FractionalERC20(_token);
436 
437     setPricingStrategy(_pricingStrategy);
438 
439     multisigWallet = _multisigWallet;
440     if(multisigWallet == 0) {
441         throw;
442     }
443 
444     if(_start == 0) {
445         throw;
446     }
447 
448     startsAt = _start;
449 
450     if(_end == 0) {
451         throw;
452     }
453 
454     endsAt = _end;
455 
456     // Don't mess the dates
457     if(startsAt >= endsAt) {
458         throw;
459     }
460 
461     // Minimum funding goal can be zero
462     minimumFundingGoal = _minimumFundingGoal;
463   }
464 
465   /**
466    * Don't expect to just send in money and get tokens.
467    */
468   function() payable {
469     throw;
470   }
471 
472   /**
473    * Make an investment.
474    *
475    * Crowdsale must be running for one to invest.
476    * We must have not pressed the emergency brake.
477    *
478    * @param receiver The Ethereum address who receives the tokens
479    * @param customerId (optional) UUID v4 to track the successful payments on the server side
480    *
481    */
482   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
483 
484     // Determine if it's a good time to accept investment from this participant
485     if(getState() == State.PreFunding) {
486       // Are we whitelisted for early deposit
487       if(!earlyParticipantWhitelist[receiver]) {
488         throw;
489       }
490     } else if(getState() == State.Funding) {
491       // Retail participants can only come in when the crowdsale is running
492       // pass
493     } else {
494       // Unwanted state
495       throw;
496     }
497 
498     uint weiAmount = msg.value;
499 
500     // Account presale sales separately, so that they do not count against pricing tranches
501     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
502 
503     if(tokenAmount == 0) {
504       // Dust transaction
505       throw;
506     }
507 
508     if(investedAmountOf[receiver] == 0) {
509        // A new investor
510        investorCount++;
511     }
512 
513     // Update investor
514     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
515     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
516 
517     // Update totals
518     weiRaised = weiRaised.plus(weiAmount);
519     tokensSold = tokensSold.plus(tokenAmount);
520 
521     if(pricingStrategy.isPresalePurchase(receiver)) {
522         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
523     }
524 
525     // Check that we did not bust the cap
526     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
527       throw;
528     }
529 
530     assignTokens(receiver, tokenAmount);
531 
532     // Pocket the money
533     if(!multisigWallet.send(weiAmount)) throw;
534 
535     // Tell us invest was success
536     Invested(receiver, weiAmount, tokenAmount, customerId);
537   }
538 
539   /**
540    * Preallocate tokens for the early investors.
541    *
542    * Preallocated tokens have been sold before the actual crowdsale opens.
543    * This function mints the tokens and moves the crowdsale needle.
544    *
545    * Investor count is not handled; it is assumed this goes for multiple investors
546    * and the token distribution happens outside the smart contract flow.
547    *
548    * No money is exchanged, as the crowdsale team already have received the payment.
549    *
550    * @param fullTokens tokens as full tokens - decimal places added internally
551    * @param weiPrice Price of a single full token in wei
552    *
553    */
554   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
555 
556     uint tokenAmount = fullTokens * 10**token.decimals();
557     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
558 
559     weiRaised = weiRaised.plus(weiAmount);
560     tokensSold = tokensSold.plus(tokenAmount);
561 
562     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
563     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
564 
565     assignTokens(receiver, tokenAmount);
566 
567     // Tell us invest was success
568     Invested(receiver, weiAmount, tokenAmount, 0);
569   }
570 
571   /**
572    * Allow anonymous contributions to this crowdsale.
573    */
574   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
575      bytes32 hash = sha256(addr);
576      if (ecrecover(hash, v, r, s) != signerAddress) throw;
577      if(customerId == 0) throw;  // UUIDv4 sanity check
578      investInternal(addr, customerId);
579   }
580 
581   /**
582    * Track who is the customer making the payment so we can send thank you email.
583    */
584   function investWithCustomerId(address addr, uint128 customerId) public payable {
585     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
586     if(customerId == 0) throw;  // UUIDv4 sanity check
587     investInternal(addr, customerId);
588   }
589 
590   /**
591    * Allow anonymous contributions to this crowdsale.
592    */
593   function invest(address addr) public payable {
594     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
595     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
596     investInternal(addr, 0);
597   }
598 
599   /**
600    * Invest to tokens, recognize the payer and clear his address.
601    *
602    */
603   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
604     investWithSignedAddress(msg.sender, customerId, v, r, s);
605   }
606 
607   /**
608    * Invest to tokens, recognize the payer.
609    *
610    */
611   function buyWithCustomerId(uint128 customerId) public payable {
612     investWithCustomerId(msg.sender, customerId);
613   }
614 
615   /**
616    * The basic entry point to participate the crowdsale process.
617    *
618    * Pay for funding, get invested tokens back in the sender address.
619    */
620   function buy() public payable {
621     invest(msg.sender);
622   }
623 
624   /**
625    * Finalize a succcesful crowdsale.
626    *
627    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
628    */
629   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
630 
631     // Already finalized
632     if(finalized) {
633       throw;
634     }
635 
636     // Finalizing is optional. We only call it if we are given a finalizing agent.
637     if(address(finalizeAgent) != 0) {
638       finalizeAgent.finalizeCrowdsale();
639     }
640 
641     finalized = true;
642   }
643 
644   /**
645    * Allow to (re)set finalize agent.
646    *
647    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
648    */
649   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
650     finalizeAgent = addr;
651 
652     // Don't allow setting bad agent
653     if(!finalizeAgent.isFinalizeAgent()) {
654       throw;
655     }
656   }
657 
658   /**
659    * Set policy do we need to have server-side customer ids for the investments.
660    *
661    */
662   function setRequireCustomerId(bool value) onlyOwner {
663     requireCustomerId = value;
664     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
665   }
666 
667   /**
668    * Set policy if all investors must be cleared on the server side first.
669    *
670    * This is e.g. for the accredited investor clearing.
671    *
672    */
673   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
674     requiredSignedAddress = value;
675     signerAddress = _signerAddress;
676     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
677   }
678 
679   /**
680    * Allow addresses to do early participation.
681    *
682    * TODO: Fix spelling error in the name
683    */
684   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
685     earlyParticipantWhitelist[addr] = status;
686     Whitelisted(addr, status);
687   }
688 
689   /**
690    * Allow crowdsale owner to close early or extend the crowdsale.
691    *
692    * This is useful e.g. for a manual soft cap implementation:
693    * - after X amount is reached determine manual closing
694    *
695    * This may put the crowdsale to an invalid state,
696    * but we trust owners know what they are doing.
697    *
698    */
699   function setEndsAt(uint time) onlyOwner {
700 
701     if(now > time) {
702       throw; // Don't change past
703     }
704 
705     endsAt = time;
706     EndsAtChanged(endsAt);
707   }
708 
709   /**
710    * Allow to (re)set pricing strategy.
711    *
712    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
713    */
714   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
715     pricingStrategy = _pricingStrategy;
716 
717     // Don't allow setting bad agent
718     if(!pricingStrategy.isPricingStrategy()) {
719       throw;
720     }
721   }
722 
723   /**
724    * Allow to change the team multisig address in the case of emergency.
725    *
726    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
727    * (we have done only few test transactions). After the crowdsale is going
728    * then multisig address stays locked for the safety reasons.
729    */
730   function setMultisig(address addr) public onlyOwner {
731 
732     // Change
733     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
734       throw;
735     }
736 
737     multisigWallet = addr;
738   }
739 
740   /**
741    * Allow load refunds back on the contract for the refunding.
742    *
743    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
744    */
745   function loadRefund() public payable inState(State.Failure) {
746     if(msg.value == 0) throw;
747     loadedRefund = loadedRefund.plus(msg.value);
748   }
749 
750   /**
751    * Investors can claim refund.
752    *
753    * Note that any refunds from proxy buyers should be handled separately,
754    * and not through this contract.
755    */
756   function refund() public inState(State.Refunding) {
757     uint256 weiValue = investedAmountOf[msg.sender];
758     if (weiValue == 0) throw;
759     investedAmountOf[msg.sender] = 0;
760     weiRefunded = weiRefunded.plus(weiValue);
761     Refund(msg.sender, weiValue);
762     if (!msg.sender.send(weiValue)) throw;
763   }
764 
765   /**
766    * @return true if the crowdsale has raised enough money to be a successful.
767    */
768   function isMinimumGoalReached() public constant returns (bool reached) {
769     return weiRaised >= minimumFundingGoal;
770   }
771 
772   /**
773    * Check if the contract relationship looks good.
774    */
775   function isFinalizerSane() public constant returns (bool sane) {
776     return finalizeAgent.isSane();
777   }
778 
779   /**
780    * Check if the contract relationship looks good.
781    */
782   function isPricingSane() public constant returns (bool sane) {
783     return pricingStrategy.isSane(address(this));
784   }
785 
786   /**
787    * Crowdfund state machine management.
788    *
789    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
790    */
791   function getState() public constant returns (State) {
792     if(finalized) return State.Finalized;
793     else if (address(finalizeAgent) == 0) return State.Preparing;
794     else if (!finalizeAgent.isSane()) return State.Preparing;
795     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
796     else if (block.timestamp < startsAt) return State.PreFunding;
797     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
798     else if (isMinimumGoalReached()) return State.Success;
799     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
800     else return State.Failure;
801   }
802 
803   /** This is for manual testing of multisig wallet interaction */
804   function setOwnerTestValue(uint val) onlyOwner {
805     ownerTestValue = val;
806   }
807 
808   /** Interface marker. */
809   function isCrowdsale() public constant returns (bool) {
810     return true;
811   }
812 
813   //
814   // Modifiers
815   //
816 
817   /** Modified allowing execution only if the crowdsale is currently running.  */
818   modifier inState(State state) {
819     if(getState() != state) throw;
820     _;
821   }
822 
823 
824   //
825   // Abstract functions
826   //
827 
828   /**
829    * Check if the current invested breaks our cap rules.
830    *
831    *
832    * The child contract must define their own cap setting rules.
833    * We allow a lot of flexibility through different capping strategies (ETH, token count)
834    * Called from invest().
835    *
836    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
837    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
838    * @param weiRaisedTotal What would be our total raised balance after this transaction
839    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
840    *
841    * @return true if taking this investment would break our cap rules
842    */
843   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
844 
845   /**
846    * Check if the current crowdsale is full and we can no longer sell any tokens.
847    */
848   function isCrowdsaleFull() public constant returns (bool);
849 
850   /**
851    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
852    */
853   function assignTokens(address receiver, uint tokenAmount) private;
854 }
855 
856 /**
857  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
858  *
859  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
860  */
861 
862 
863 
864 
865 
866 
867 
868 /**
869  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
870  *
871  * Based on code by FirstBlood:
872  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
873  */
874 contract StandardToken is ERC20, SafeMath {
875 
876   /* Token supply got increased and a new owner received these tokens */
877   event Minted(address receiver, uint amount);
878 
879   /* Actual balances of token holders */
880   mapping(address => uint) balances;
881 
882   /* approve() allowances */
883   mapping (address => mapping (address => uint)) allowed;
884 
885   /* Interface declaration */
886   function isToken() public constant returns (bool weAre) {
887     return true;
888   }
889 
890   function transfer(address _to, uint _value) returns (bool success) {
891     balances[msg.sender] = safeSub(balances[msg.sender], _value);
892     balances[_to] = safeAdd(balances[_to], _value);
893     Transfer(msg.sender, _to, _value);
894     return true;
895   }
896 
897   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
898     uint _allowance = allowed[_from][msg.sender];
899 
900     balances[_to] = safeAdd(balances[_to], _value);
901     balances[_from] = safeSub(balances[_from], _value);
902     allowed[_from][msg.sender] = safeSub(_allowance, _value);
903     Transfer(_from, _to, _value);
904     return true;
905   }
906 
907   function balanceOf(address _owner) constant returns (uint balance) {
908     return balances[_owner];
909   }
910 
911   function approve(address _spender, uint _value) returns (bool success) {
912 
913     // To change the approve amount you first have to reduce the addresses`
914     //  allowance to zero by calling `approve(_spender, 0)` if it is not
915     //  already 0 to mitigate the race condition described here:
916     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
917     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
918 
919     allowed[msg.sender][_spender] = _value;
920     Approval(msg.sender, _spender, _value);
921     return true;
922   }
923 
924   function allowance(address _owner, address _spender) constant returns (uint remaining) {
925     return allowed[_owner][_spender];
926   }
927 
928 }
929 
930 
931 
932 /**
933  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
934  *
935  * - Collect funds from pre-sale investors
936  * - Send funds to the crowdsale when it opens
937  * - Allow owner to set the crowdsale
938  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
939  * - Allow unlimited investors
940  * - Tokens are distributed on PreICOProxyBuyer smart contract first
941  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
942  * - All functions can be halted by owner if something goes wrong
943  *
944  */
945 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
946 
947   /** How many investors we have now */
948   uint public investorCount;
949 
950   /** How many wei we have raised totla. */
951   uint public weiRaised;
952 
953   /** Who are our investors (iterable) */
954   address[] public investors;
955 
956   /** How much they have invested */
957   mapping(address => uint) public balances;
958 
959   /** How many tokens investors have claimed */
960   mapping(address => uint) public claimed;
961 
962   /** When our refund freeze is over (UNIT timestamp) */
963   uint public freezeEndsAt;
964 
965   /** What is the minimum buy in */
966   uint public weiMinimumLimit;
967 
968   /** What is the maximum buy in */
969   uint public weiMaximumLimit;
970 
971   /** How many weis total we are allowed to collect. */
972   uint public weiCap;
973 
974   /** How many tokens were bought */
975   uint public tokensBought;
976 
977    /** How many investors have claimed their tokens */
978   uint public claimCount;
979 
980   uint public totalClaimed;
981 
982   /** This is used to signal that we want the refund **/
983   bool public forcedRefund;
984 
985   /** Our ICO contract where we will move the funds */
986   Crowdsale public crowdsale;
987 
988   /** What is our current state. */
989   enum State{Unknown, Funding, Distributing, Refunding}
990 
991   /** Somebody loaded their investment money */
992   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
993 
994   /** Refund claimed */
995   event Refunded(address investor, uint value);
996 
997   /** We executed our buy */
998   event TokensBoughts(uint count);
999 
1000   /** We distributed tokens to an investor */
1001   event Distributed(address investor, uint count);
1002 
1003   /**
1004    * Create presale contract where lock up period is given days
1005    */
1006   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
1007 
1008     owner = _owner;
1009 
1010     // Give argument
1011     if(_freezeEndsAt == 0) {
1012       throw;
1013     }
1014 
1015     // Give argument
1016     if(_weiMinimumLimit == 0) {
1017       throw;
1018     }
1019 
1020     if(_weiMaximumLimit == 0) {
1021       throw;
1022     }
1023 
1024     weiMinimumLimit = _weiMinimumLimit;
1025     weiMaximumLimit = _weiMaximumLimit;
1026     weiCap = _weiCap;
1027     freezeEndsAt = _freezeEndsAt;
1028   }
1029 
1030   /**
1031    * Get the token we are distributing.
1032    */
1033   function getToken() public constant returns(FractionalERC20) {
1034     if(address(crowdsale) == 0)  {
1035       throw;
1036     }
1037 
1038     return crowdsale.token();
1039   }
1040 
1041   /**
1042    * Participate to a presale.
1043    */
1044   function invest(uint128 customerId) private {
1045 
1046     // Cannot invest anymore through crowdsale when moving has begun
1047     if(getState() != State.Funding) throw;
1048 
1049     if(msg.value == 0) throw; // No empty buys
1050 
1051     address investor = msg.sender;
1052 
1053     bool existing = balances[investor] > 0;
1054 
1055     balances[investor] = safeAdd(balances[investor], msg.value);
1056 
1057     // Need to satisfy minimum and maximum limits
1058     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1059       throw;
1060     }
1061 
1062     // This is a new investor
1063     if(!existing) {
1064       investors.push(investor);
1065       investorCount++;
1066     }
1067 
1068     weiRaised = safeAdd(weiRaised, msg.value);
1069     if(weiRaised > weiCap) {
1070       throw;
1071     }
1072 
1073     // We will use the same event form the Crowdsale for compatibility reasons
1074     // despite not having a token amount.
1075     Invested(investor, msg.value, 0, customerId);
1076   }
1077 
1078   function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
1079     invest(customerId);
1080   }
1081 
1082   function buy() public stopInEmergency payable {
1083     invest(0x0);
1084   }
1085 
1086 
1087   /**
1088    * Load funds to the crowdsale for all investors.
1089    *
1090    *
1091    */
1092   function buyForEverybody() stopNonOwnersInEmergency public {
1093 
1094     if(getState() != State.Funding) {
1095       // Only allow buy once
1096       throw;
1097     }
1098 
1099     // Crowdsale not yet set
1100     if(address(crowdsale) == 0) throw;
1101 
1102     // Buy tokens on the contract
1103     crowdsale.invest.value(weiRaised)(address(this));
1104 
1105     // Record how many tokens we got
1106     tokensBought = getToken().balanceOf(address(this));
1107 
1108     if(tokensBought == 0) {
1109       // Did not get any tokens
1110       throw;
1111     }
1112 
1113     TokensBoughts(tokensBought);
1114   }
1115 
1116   /**
1117    * How may tokens each investor gets.
1118    */
1119   function getClaimAmount(address investor) public constant returns (uint) {
1120 
1121     // Claims can be only made if we manage to buy tokens
1122     if(getState() != State.Distributing) {
1123       throw;
1124     }
1125     return safeMul(balances[investor], tokensBought) / weiRaised;
1126   }
1127 
1128   /**
1129    * How many tokens remain unclaimed for an investor.
1130    */
1131   function getClaimLeft(address investor) public constant returns (uint) {
1132     return safeSub(getClaimAmount(investor), claimed[investor]);
1133   }
1134 
1135   /**
1136    * Claim all remaining tokens for this investor.
1137    */
1138   function claimAll() {
1139     claim(getClaimLeft(msg.sender));
1140   }
1141 
1142   /**
1143    * Claim N bought tokens to the investor as the msg sender.
1144    *
1145    */
1146   function claim(uint amount) stopInEmergency {
1147     address investor = msg.sender;
1148 
1149     if(amount == 0) {
1150       throw;
1151     }
1152 
1153     if(getClaimLeft(investor) < amount) {
1154       // Woops we cannot get more than we have left
1155       throw;
1156     }
1157 
1158     // We track who many investor have (partially) claimed their tokens
1159     if(claimed[investor] == 0) {
1160       claimCount++;
1161     }
1162 
1163     claimed[investor] = safeAdd(claimed[investor], amount);
1164     totalClaimed = safeAdd(totalClaimed, amount);
1165     getToken().transfer(investor, amount);
1166 
1167     Distributed(investor, amount);
1168   }
1169 
1170   /**
1171    * ICO never happened. Allow refund.
1172    */
1173   function refund() stopInEmergency {
1174 
1175     // Trying to ask refund too soon
1176     if(getState() != State.Refunding) throw;
1177 
1178     address investor = msg.sender;
1179     if(balances[investor] == 0) throw;
1180     uint amount = balances[investor];
1181     delete balances[investor];
1182     if(!(investor.call.value(amount)())) throw;
1183     Refunded(investor, amount);
1184   }
1185 
1186   /**
1187    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1188    */
1189   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1190     crowdsale = _crowdsale;
1191 
1192     // Check interface
1193     if(!crowdsale.isCrowdsale()) true;
1194   }
1195 
1196   /// @dev This is used in the first case scenario, this will force the state
1197   ///      to refunding. This can be also used when the ICO fails to meet the cap.
1198   function forceRefund() public onlyOwner {
1199     forcedRefund = true;
1200   }
1201 
1202   /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
1203   ///      we can't use Crowdsale's refund, since our default function does not
1204   ///      accept money in.
1205   function loadRefund() public payable {
1206     if(getState() != State.Refunding) throw;
1207   }
1208 
1209   /**
1210    * Resolve the contract umambigious state.
1211    */
1212   function getState() public returns(State) {
1213     if (forcedRefund)
1214       return State.Refunding;
1215 
1216     if(tokensBought == 0) {
1217       if(now >= freezeEndsAt) {
1218          return State.Refunding;
1219       } else {
1220         return State.Funding;
1221       }
1222     } else {
1223       return State.Distributing;
1224     }
1225   }
1226 
1227   /** Interface marker. */
1228   function isPresale() public constant returns (bool) {
1229     return true;
1230   }
1231 
1232   /** Explicitly call function from your wallet. */
1233   function() payable {
1234     throw;
1235   }
1236 }