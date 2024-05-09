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
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner {
49     require(newOwner != address(0));      
50     owner = newOwner;
51   }
52 
53 }
54 
55 
56 /*
57  * Haltable
58  *
59  * Abstract contract that allows children to implement an
60  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
61  *
62  *
63  * Originally envisioned in FirstBlood ICO contract.
64  */
65 contract Haltable is Ownable {
66   bool public halted;
67 
68   modifier stopInEmergency {
69     if (halted) throw;
70     _;
71   }
72 
73   modifier stopNonOwnersInEmergency {
74     if (halted && msg.sender != owner) throw;
75     _;
76   }
77 
78   modifier onlyInEmergency {
79     if (!halted) throw;
80     _;
81   }
82 
83   // called by the owner on emergency, triggers stopped state
84   function halt() external onlyOwner {
85     halted = true;
86   }
87 
88   // called by the owner on end of emergency, returns to normal state
89   function unhalt() external onlyOwner onlyInEmergency {
90     halted = false;
91   }
92 
93 }
94 
95 /**
96  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
97  *
98  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
99  */
100 
101 
102 /**
103  * Safe unsigned safe math.
104  *
105  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
106  *
107  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
108  *
109  * Maintained here until merged to mainline zeppelin-solidity.
110  *
111  */
112 library SafeMathLib {
113 
114   function times(uint a, uint b) returns (uint) {
115     uint c = a * b;
116     assert(a == 0 || c / a == b);
117     return c;
118   }
119 
120   function minus(uint a, uint b) returns (uint) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function plus(uint a, uint b) returns (uint) {
126     uint c = a + b;
127     assert(c>=a);
128     return c;
129   }
130 
131 }
132 
133 /**
134  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
135  *
136  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
137  */
138 
139 
140 
141 
142 
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/179
148  */
149 contract ERC20Basic {
150   uint256 public totalSupply;
151   function balanceOf(address who) constant returns (uint256);
152   function transfer(address to, uint256 value) returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) constant returns (uint256);
164   function transferFrom(address from, address to, uint256 value) returns (bool);
165   function approve(address spender, uint256 value) returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 
170 /**
171  * A token that defines fractional units as decimals.
172  */
173 contract FractionalERC20 is ERC20 {
174 
175   uint public decimals;
176 
177 }
178 
179 /**
180  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
181  *
182  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
183  */
184 
185 
186 /**
187  * Interface for defining crowdsale pricing.
188  */
189 contract PricingStrategy {
190 
191   /** Interface declaration. */
192   function isPricingStrategy() public constant returns (bool) {
193     return true;
194   }
195 
196   /** Self check if all references are correctly set.
197    *
198    * Checks that pricing strategy matches crowdsale parameters.
199    */
200   function isSane(address crowdsale) public constant returns (bool) {
201     return true;
202   }
203 
204   /**
205    * @dev Pricing tells if this is a presale purchase or not.
206      @param purchaser Address of the purchaser
207      @return False by default, true if a presale purchaser
208    */
209   function isPresalePurchase(address purchaser) public constant returns (bool) {
210     return false;
211   }
212 
213   /**
214    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
215    *
216    *
217    * @param value - What is the value of the transaction send in as wei
218    * @param tokensSold - how much tokens have been sold this far
219    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
220    * @param msgSender - who is the investor of this transaction
221    * @param decimals - how many decimal units the token has
222    * @return Amount of tokens the investor receives
223    */
224   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
225 }
226 
227 /**
228  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
229  *
230  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
231  */
232 
233 
234 /**
235  * Finalize agent defines what happens at the end of succeseful crowdsale.
236  *
237  * - Allocate tokens for founders, bounties and community
238  * - Make tokens transferable
239  * - etc.
240  */
241 contract FinalizeAgent {
242 
243   function isFinalizeAgent() public constant returns(bool) {
244     return true;
245   }
246 
247   /** Return true if we can run finalizeCrowdsale() properly.
248    *
249    * This is a safety check function that doesn't allow crowdsale to begin
250    * unless the finalizer has been set up properly.
251    */
252   function isSane() public constant returns (bool);
253 
254   /** Called once by crowdsale finalize() if the sale was success. */
255   function finalizeCrowdsale();
256 
257 }
258 
259 
260 
261 /**
262  * Crowdsale state machine without buy functionality.
263  *
264  * Implements basic state machine logic, but leaves out all buy functions,
265  * so that subclasses can implement their own buying logic.
266  *
267  *
268  * For the default buy() implementation see Crowdsale.sol.
269  */
270 contract CrowdsaleBase is Haltable {
271 
272   /* Max investment count when we are still allowed to change the multisig address */
273   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
274 
275   using SafeMathLib for uint;
276 
277   /* The token we are selling */
278   FractionalERC20 public token;
279 
280   /* How we are going to price our offering */
281   PricingStrategy public pricingStrategy;
282 
283   /* Post-success callback */
284   FinalizeAgent public finalizeAgent;
285 
286   /* tokens will be transfered from this address */
287   address public multisigWallet;
288 
289   /* if the funding goal is not reached, investors may withdraw their funds */
290   uint public minimumFundingGoal;
291 
292   /* the UNIX timestamp start date of the crowdsale */
293   uint public startsAt;
294 
295   /* the UNIX timestamp end date of the crowdsale */
296   uint public endsAt;
297 
298   /* the number of tokens already sold through this contract*/
299   uint public tokensSold = 0;
300 
301   /* How many wei of funding we have raised */
302   uint public weiRaised = 0;
303 
304   /* Calculate incoming funds from presale contracts and addresses */
305   uint public presaleWeiRaised = 0;
306 
307   /* How many distinct addresses have invested */
308   uint public investorCount = 0;
309 
310   /* How much wei we have returned back to the contract after a failed crowdfund. */
311   uint public loadedRefund = 0;
312 
313   /* How much wei we have given back to investors.*/
314   uint public weiRefunded = 0;
315 
316   /* Has this crowdsale been finalized */
317   bool public finalized;
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
350   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
351 
352   // Address early participation whitelist status changed
353   event Whitelisted(address addr, bool status);
354 
355   // Crowdsale end time has been changed
356   event EndsAtChanged(uint newEndsAt);
357 
358   State public testState;
359 
360   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
361 
362     owner = msg.sender;
363 
364     token = FractionalERC20(_token);
365 
366     setPricingStrategy(_pricingStrategy);
367 
368     multisigWallet = _multisigWallet;
369     if(multisigWallet == 0) {
370         throw;
371     }
372 
373     if(_start == 0) {
374         throw;
375     }
376 
377     startsAt = _start;
378 
379     if(_end == 0) {
380         throw;
381     }
382 
383     endsAt = _end;
384 
385     // Don't mess the dates
386     if(startsAt >= endsAt) {
387         throw;
388     }
389 
390     // Minimum funding goal can be zero
391     minimumFundingGoal = _minimumFundingGoal;
392   }
393 
394   /**
395    * Don't expect to just send in money and get tokens.
396    */
397   function() payable {
398     throw;
399   }
400 
401   /**
402    * Make an investment.
403    *
404    * Crowdsale must be running for one to invest.
405    * We must have not pressed the emergency brake.
406    *
407    * @param receiver The Ethereum address who receives the tokens
408    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
409    *
410    * @return tokenAmount How mony tokens were bought
411    */
412   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
413 
414     // Determine if it's a good time to accept investment from this participant
415     if(getState() == State.PreFunding) {
416       // Are we whitelisted for early deposit
417       if(!earlyParticipantWhitelist[receiver]) {
418         throw;
419       }
420     } else if(getState() == State.Funding) {
421       // Retail participants can only come in when the crowdsale is running
422       // pass
423     } else {
424       // Unwanted state
425       throw;
426     }
427 
428     uint weiAmount = msg.value;
429 
430     // Account presale sales separately, so that they do not count against pricing tranches
431     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
432 
433     // Dust transaction
434     require(tokenAmount != 0);
435 
436     if(investedAmountOf[receiver] == 0) {
437        // A new investor
438        investorCount++;
439     }
440 
441     // Update investor
442     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
443     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
444 
445     // Update totals
446     weiRaised = weiRaised.plus(weiAmount);
447     tokensSold = tokensSold.plus(tokenAmount);
448 
449     if(pricingStrategy.isPresalePurchase(receiver)) {
450         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
451     }
452 
453     // Check that we did not bust the cap
454     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
455 
456     assignTokens(receiver, tokenAmount);
457 
458     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
459     if(!multisigWallet.send(weiAmount)) throw;
460 
461     // Tell us invest was success
462     Invested(receiver, weiAmount, tokenAmount, customerId);
463 
464     return tokenAmount;
465   }
466 
467   /**
468    * Finalize a succcesful crowdsale.
469    *
470    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
471    */
472   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
473 
474     // Already finalized
475     if(finalized) {
476       throw;
477     }
478 
479     // Finalizing is optional. We only call it if we are given a finalizing agent.
480     if(address(finalizeAgent) != 0) {
481       finalizeAgent.finalizeCrowdsale();
482     }
483 
484     finalized = true;
485   }
486 
487   /**
488    * Allow to (re)set finalize agent.
489    *
490    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
491    */
492   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
493     finalizeAgent = addr;
494 
495     // Don't allow setting bad agent
496     if(!finalizeAgent.isFinalizeAgent()) {
497       throw;
498     }
499   }
500 
501   /**
502    * Allow crowdsale owner to close early or extend the crowdsale.
503    *
504    * This is useful e.g. for a manual soft cap implementation:
505    * - after X amount is reached determine manual closing
506    *
507    * This may put the crowdsale to an invalid state,
508    * but we trust owners know what they are doing.
509    *
510    */
511   function setEndsAt(uint time) onlyOwner {
512 
513     if(now > time) {
514       throw; // Don't change past
515     }
516 
517     if(startsAt > time) {
518       throw; // Prevent human mistakes
519     }
520 
521     endsAt = time;
522     EndsAtChanged(endsAt);
523   }
524 
525   /**
526    * Allow to (re)set pricing strategy.
527    *
528    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
529    */
530   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
531     pricingStrategy = _pricingStrategy;
532 
533     // Don't allow setting bad agent
534     if(!pricingStrategy.isPricingStrategy()) {
535       throw;
536     }
537   }
538 
539   /**
540    * Allow to change the team multisig address in the case of emergency.
541    *
542    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
543    * (we have done only few test transactions). After the crowdsale is going
544    * then multisig address stays locked for the safety reasons.
545    */
546   function setMultisig(address addr) public onlyOwner {
547 
548     // Change
549     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
550       throw;
551     }
552 
553     multisigWallet = addr;
554   }
555 
556   /**
557    * Allow load refunds back on the contract for the refunding.
558    *
559    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
560    */
561   function loadRefund() public payable inState(State.Failure) {
562     if(msg.value == 0) throw;
563     loadedRefund = loadedRefund.plus(msg.value);
564   }
565 
566   /**
567    * Investors can claim refund.
568    *
569    * Note that any refunds from proxy buyers should be handled separately,
570    * and not through this contract.
571    */
572   function refund() public inState(State.Refunding) {
573     uint256 weiValue = investedAmountOf[msg.sender];
574     if (weiValue == 0) throw;
575     investedAmountOf[msg.sender] = 0;
576     weiRefunded = weiRefunded.plus(weiValue);
577     Refund(msg.sender, weiValue);
578     if (!msg.sender.send(weiValue)) throw;
579   }
580 
581   /**
582    * @return true if the crowdsale has raised enough money to be a successful.
583    */
584   function isMinimumGoalReached() public constant returns (bool reached) {
585     return weiRaised >= minimumFundingGoal;
586   }
587 
588   /**
589    * Check if the contract relationship looks good.
590    */
591   function isFinalizerSane() public constant returns (bool sane) {
592     return finalizeAgent.isSane();
593   }
594 
595   /**
596    * Check if the contract relationship looks good.
597    */
598   function isPricingSane() public constant returns (bool sane) {
599     return pricingStrategy.isSane(address(this));
600   }
601 
602   /**
603    * Crowdfund state machine management.
604    *
605    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
606    */
607   function getState() public constant returns (State) {
608     if(finalized) return State.Finalized;
609     else if (address(finalizeAgent) == 0) return State.Preparing;
610     else if (!finalizeAgent.isSane()) return State.Preparing;
611     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
612     else if (block.timestamp < startsAt) return State.PreFunding;
613     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
614     else if (isMinimumGoalReached()) return State.Success;
615     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
616     else return State.Failure;
617   }
618 
619   /** This is for manual testing of multisig wallet interaction */
620   function setOwnerTestValue(uint val) onlyOwner {
621     ownerTestValue = val;
622   }
623 
624   /**
625    * Allow addresses to do early participation.
626    *
627    * TODO: Fix spelling error in the name
628    */
629   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
630     earlyParticipantWhitelist[addr] = status;
631     Whitelisted(addr, status);
632   }
633 
634 
635   /** Interface marker. */
636   function isCrowdsale() public constant returns (bool) {
637     return true;
638   }
639 
640   //
641   // Modifiers
642   //
643 
644   /** Modified allowing execution only if the crowdsale is currently running.  */
645   modifier inState(State state) {
646     if(getState() != state) throw;
647     _;
648   }
649 
650 
651   //
652   // Abstract functions
653   //
654 
655   /**
656    * Check if the current invested breaks our cap rules.
657    *
658    *
659    * The child contract must define their own cap setting rules.
660    * We allow a lot of flexibility through different capping strategies (ETH, token count)
661    * Called from invest().
662    *
663    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
664    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
665    * @param weiRaisedTotal What would be our total raised balance after this transaction
666    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
667    *
668    * @return true if taking this investment would break our cap rules
669    */
670   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
671 
672   /**
673    * Check if the current crowdsale is full and we can no longer sell any tokens.
674    */
675   function isCrowdsaleFull() public constant returns (bool);
676 
677   /**
678    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
679    */
680   function assignTokens(address receiver, uint tokenAmount) internal;
681 }
682 
683 /**
684  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
685  *
686  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
687  */
688 
689 
690 
691 
692 /**
693  * A mixin that is selling tokens from a preallocated pool
694  *
695  * - Tokens have precreated supply "premined"
696  *
697  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
698  *
699  * - The mixin does not implement buy entry point.
700  *
701  */
702 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
703 
704   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
705   address public beneficiary;
706 
707   /**
708    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
709    *
710    */
711   function AllocatedCrowdsaleMixin(address _beneficiary) {
712     beneficiary = _beneficiary;
713   }
714 
715   /**
716    * Called from invest() to confirm if the curret investment does not break our cap rule.
717    */
718   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
719     if(tokenAmount > getTokensLeft()) {
720       return true;
721     } else {
722       return false;
723     }
724   }
725 
726   /**
727    * We are sold out when our approve pool becomes empty.
728    */
729   function isCrowdsaleFull() public constant returns (bool) {
730     return getTokensLeft() == 0;
731   }
732 
733   /**
734    * Get the amount of unsold tokens allocated to this contract;
735    */
736   function getTokensLeft() public constant returns (uint) {
737     return token.allowance(owner, this);
738   }
739 
740   /**
741    * Transfer tokens from approve() pool to the buyer.
742    *
743    * Use approve() given to this crowdsale to distribute the tokens.
744    */
745   function assignTokens(address receiver, uint tokenAmount) internal {
746     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
747   }
748 }
749 
750 /**
751  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
752  *
753  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
754  */
755 
756 
757 /**
758  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
759  *
760  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
761  */
762 
763 /**
764  * Deserialize bytes payloads.
765  *
766  * Values are in big-endian byte order.
767  *
768  */
769 library BytesDeserializer {
770 
771   /**
772    * Extract 256-bit worth of data from the bytes stream.
773    */
774   function slice32(bytes b, uint offset) constant returns (bytes32) {
775     bytes32 out;
776 
777     for (uint i = 0; i < 32; i++) {
778       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
779     }
780     return out;
781   }
782 
783   /**
784    * Extract Ethereum address worth of data from the bytes stream.
785    */
786   function sliceAddress(bytes b, uint offset) constant returns (address) {
787     bytes32 out;
788 
789     for (uint i = 0; i < 20; i++) {
790       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
791     }
792     return address(uint(out));
793   }
794 
795   /**
796    * Extract 128-bit worth of data from the bytes stream.
797    */
798   function slice16(bytes b, uint offset) constant returns (bytes16) {
799     bytes16 out;
800 
801     for (uint i = 0; i < 16; i++) {
802       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
803     }
804     return out;
805   }
806 
807   /**
808    * Extract 32-bit worth of data from the bytes stream.
809    */
810   function slice4(bytes b, uint offset) constant returns (bytes4) {
811     bytes4 out;
812 
813     for (uint i = 0; i < 4; i++) {
814       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
815     }
816     return out;
817   }
818 
819   /**
820    * Extract 16-bit worth of data from the bytes stream.
821    */
822   function slice2(bytes b, uint offset) constant returns (bytes2) {
823     bytes2 out;
824 
825     for (uint i = 0; i < 2; i++) {
826       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
827     }
828     return out;
829   }
830 
831 
832 
833 }
834 
835 
836 /**
837  * A mix-in contract to decode different AML payloads.
838  *
839  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we put this as a mix-in.
840  */
841 contract KYCPayloadDeserializer {
842 
843   using BytesDeserializer for bytes;
844 
845   // The bytes payload set on the server side
846   // total 56 bytes
847 
848   struct KYCPayload {
849 
850     /** Customer whitelisted address where the deposit can come from */
851     address whitelistedAddress; // 20 bytes
852 
853     /** Customer id, UUID v4 */
854     uint128 customerId; // 16 bytes
855 
856     /**
857      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
858      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
859      */
860     uint32 minETH; // 4 bytes
861 
862     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
863     uint32 maxETH; // 4 bytes
864   }
865 
866   /**
867    * Deconstruct server-side byte data to structured data.
868    */
869 
870   function deserializeKYCPayload(bytes dataframe) internal constant returns(KYCPayload decodedPayload) {
871     KYCPayload payload;
872     payload.whitelistedAddress = dataframe.sliceAddress(0);
873     payload.customerId = uint128(dataframe.slice16(20));
874     payload.minETH = uint32(dataframe.slice4(36));
875     payload.maxETH = uint32(dataframe.slice4(40));
876     return payload;
877   }
878 
879   /**
880    * Helper function to allow us to return the decoded payload to an external caller for testing.
881    *
882    * TODO: Some sort of compiler issue (?) with memory keyword. Tested with solc 0.4.16 and solc 0.4.18.
883    * If used, makes KYCCrowdsale to set itself to a bad state getState() returns 5 (Failure). Overrides some memory?
884    */
885   /*
886   function broken_getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
887     KYCPayload memory payload = deserializeKYCPayload(dataframe);
888     payload.whitelistedAddress = dataframe.sliceAddress(0);
889     payload.customerId = uint128(dataframe.slice16(20));
890     payload.minETH = uint32(dataframe.slice4(36));
891     payload.maxETH = uint32(dataframe.slice4(40));
892     return (payload.whitelistedAddress, payload.customerId, payload.minETH, payload.maxETH);
893   }*/
894 
895   /**
896    * Same as above, does not seem to cause any issue.
897    */
898   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
899     address _whitelistedAddress = dataframe.sliceAddress(0);
900     uint128 _customerId = uint128(dataframe.slice16(20));
901     uint32 _minETH = uint32(dataframe.slice4(36));
902     uint32 _maxETH = uint32(dataframe.slice4(40));
903     return (_whitelistedAddress, _customerId, _minETH, _maxETH);
904   }
905 
906 }
907 
908 
909 /**
910  * A crowdsale that allows only signed payload with server-side specified buy in limits.
911  *
912  *
913  * The token distribution happens as in the allocated crowdsale.
914  *
915  */
916 contract KYCCrowdsale is AllocatedCrowdsaleMixin, KYCPayloadDeserializer {
917 
918   /* Server holds the private key to this address to decide if the AML payload is valid or not. */
919   address public signerAddress;
920 
921   /* A new server-side signer key was set to be effective */
922   event SignerChanged(address signer);
923 
924   /**
925    * Constructor.
926    */
927   function KYCCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
928 
929   }
930 
931   /**
932    * A token purchase with anti-money laundering
933    *
934    * ©return tokenAmount How many tokens where bought
935    */
936   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
937 
938     uint _tokenAmount;
939     uint multiplier = 10 ** 18;
940 
941     // Perform signature check for normal addresses
942     // (not deployment accounts, etc.)
943     if(earlyParticipantWhitelist[msg.sender]) {
944       // For test purchases use this faux customer id
945       _tokenAmount = investInternal(msg.sender, 0x1000);
946 
947     } else {
948 
949       bytes32 hash = sha256(dataframe);
950 
951       var (whitelistedAddress, customerId, minETH, maxETH) = getKYCPayload(dataframe);
952 
953       // Check that the KYC data is signed by our server
954       require(ecrecover(hash, v, r, s) == signerAddress);
955 
956       // Only whitelisted address can participate the transaction
957       require(whitelistedAddress == msg.sender);
958 
959       _tokenAmount = investInternal(msg.sender, customerId);
960 
961     }
962 
963     if(!earlyParticipantWhitelist[msg.sender]) {
964       // We assume there is no serious min and max fluctuations for the customer, unless
965       // especially set in the server side per customer manual override.
966       // Otherwise the customer can reuse old data payload with different min or max value
967       // to work around the per customer cap.
968       require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
969       require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
970     }
971 
972     return _tokenAmount;
973   }
974 
975   /// @dev This function can set the server side address
976   /// @param _signerAddress The address derived from server's private key
977   function setSignerAddress(address _signerAddress) onlyOwner {
978     signerAddress = _signerAddress;
979     SignerChanged(signerAddress);
980   }
981 
982 }