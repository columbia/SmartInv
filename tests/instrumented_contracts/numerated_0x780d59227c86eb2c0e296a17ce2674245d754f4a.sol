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
358   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
359 
360     owner = msg.sender;
361 
362     token = FractionalERC20(_token);
363     setPricingStrategy(_pricingStrategy);
364 
365     multisigWallet = _multisigWallet;
366     if(multisigWallet == 0) {
367         throw;
368     }
369 
370     if(_start == 0) {
371         throw;
372     }
373 
374     startsAt = _start;
375 
376     if(_end == 0) {
377         throw;
378     }
379 
380     endsAt = _end;
381 
382     // Don't mess the dates
383     if(startsAt >= endsAt) {
384         throw;
385     }
386 
387     // Minimum funding goal can be zero
388     minimumFundingGoal = _minimumFundingGoal;
389   }
390 
391   /**
392    * Don't expect to just send in money and get tokens.
393    */
394   function() payable {
395     throw;
396   }
397 
398   /**
399    * Make an investment.
400    *
401    * Crowdsale must be running for one to invest.
402    * We must have not pressed the emergency brake.
403    *
404    * @param receiver The Ethereum address who receives the tokens
405    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
406    *
407    * @return tokenAmount How mony tokens were bought
408    */
409   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
410 
411     // Determine if it's a good time to accept investment from this participant
412     if(getState() == State.PreFunding) {
413       // Are we whitelisted for early deposit
414       if(!earlyParticipantWhitelist[receiver]) {
415         throw;
416       }
417     } else if(getState() == State.Funding) {
418       // Retail participants can only come in when the crowdsale is running
419       // pass
420     } else {
421       // Unwanted state
422       throw;
423     }
424 
425     uint weiAmount = msg.value;
426 
427     // Account presale sales separately, so that they do not count against pricing tranches
428     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
429 
430     // Dust transaction
431     require(tokenAmount != 0);
432 
433     if(investedAmountOf[receiver] == 0) {
434        // A new investor
435        investorCount++;
436     }
437 
438     // Update investor
439     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
440     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
441 
442     // Update totals
443     weiRaised = weiRaised.plus(weiAmount);
444     tokensSold = tokensSold.plus(tokenAmount);
445 
446     if(pricingStrategy.isPresalePurchase(receiver)) {
447         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
448     }
449 
450     // Check that we did not bust the cap
451     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
452 
453     assignTokens(receiver, tokenAmount);
454 
455     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
456     if(!multisigWallet.send(weiAmount)) throw;
457 
458     // Tell us invest was success
459     Invested(receiver, weiAmount, tokenAmount, customerId);
460 
461     return tokenAmount;
462   }
463 
464   /**
465    * Finalize a succcesful crowdsale.
466    *
467    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
468    */
469   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
470 
471     // Already finalized
472     if(finalized) {
473       throw;
474     }
475 
476     // Finalizing is optional. We only call it if we are given a finalizing agent.
477     if(address(finalizeAgent) != 0) {
478       finalizeAgent.finalizeCrowdsale();
479     }
480 
481     finalized = true;
482   }
483 
484   /**
485    * Allow to (re)set finalize agent.
486    *
487    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
488    */
489   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
490     finalizeAgent = addr;
491 
492     // Don't allow setting bad agent
493     if(!finalizeAgent.isFinalizeAgent()) {
494       throw;
495     }
496   }
497 
498   /**
499    * Allow crowdsale owner to close early or extend the crowdsale.
500    *
501    * This is useful e.g. for a manual soft cap implementation:
502    * - after X amount is reached determine manual closing
503    *
504    * This may put the crowdsale to an invalid state,
505    * but we trust owners know what they are doing.
506    *
507    */
508   function setEndsAt(uint time) onlyOwner {
509 
510     if(now > time) {
511       throw; // Don't change past
512     }
513 
514     if(startsAt > time) {
515       throw; // Prevent human mistakes
516     }
517 
518     endsAt = time;
519     EndsAtChanged(endsAt);
520   }
521 
522   /**
523    * Allow to (re)set pricing strategy.
524    *
525    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
526    */
527   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
528     pricingStrategy = _pricingStrategy;
529 
530     // Don't allow setting bad agent
531     if(!pricingStrategy.isPricingStrategy()) {
532       throw;
533     }
534   }
535 
536   /**
537    * Allow to change the team multisig address in the case of emergency.
538    *
539    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
540    * (we have done only few test transactions). After the crowdsale is going
541    * then multisig address stays locked for the safety reasons.
542    */
543   function setMultisig(address addr) public onlyOwner {
544 
545     // Change
546     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
547       throw;
548     }
549 
550     multisigWallet = addr;
551   }
552 
553   /**
554    * Allow load refunds back on the contract for the refunding.
555    *
556    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
557    */
558   function loadRefund() public payable inState(State.Failure) {
559     if(msg.value == 0) throw;
560     loadedRefund = loadedRefund.plus(msg.value);
561   }
562 
563   /**
564    * Investors can claim refund.
565    *
566    * Note that any refunds from proxy buyers should be handled separately,
567    * and not through this contract.
568    */
569   function refund() public inState(State.Refunding) {
570     uint256 weiValue = investedAmountOf[msg.sender];
571     if (weiValue == 0) throw;
572     investedAmountOf[msg.sender] = 0;
573     weiRefunded = weiRefunded.plus(weiValue);
574     Refund(msg.sender, weiValue);
575     if (!msg.sender.send(weiValue)) throw;
576   }
577 
578   /**
579    * @return true if the crowdsale has raised enough money to be a successful.
580    */
581   function isMinimumGoalReached() public constant returns (bool reached) {
582     return weiRaised >= minimumFundingGoal;
583   }
584 
585   /**
586    * Check if the contract relationship looks good.
587    */
588   function isFinalizerSane() public constant returns (bool sane) {
589     return finalizeAgent.isSane();
590   }
591 
592   /**
593    * Check if the contract relationship looks good.
594    */
595   function isPricingSane() public constant returns (bool sane) {
596     return pricingStrategy.isSane(address(this));
597   }
598 
599   /**
600    * Crowdfund state machine management.
601    *
602    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
603    */
604   function getState() public constant returns (State) {
605     if(finalized) return State.Finalized;
606     else if (address(finalizeAgent) == 0) return State.Preparing;
607     else if (!finalizeAgent.isSane()) return State.Preparing;
608     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
609     else if (block.timestamp < startsAt) return State.PreFunding;
610     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
611     else if (isMinimumGoalReached()) return State.Success;
612     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
613     else return State.Failure;
614   }
615 
616   /** This is for manual testing of multisig wallet interaction */
617   function setOwnerTestValue(uint val) onlyOwner {
618     ownerTestValue = val;
619   }
620 
621   /**
622    * Allow addresses to do early participation.
623    *
624    * TODO: Fix spelling error in the name
625    */
626   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
627     earlyParticipantWhitelist[addr] = status;
628     Whitelisted(addr, status);
629   }
630 
631 
632   /** Interface marker. */
633   function isCrowdsale() public constant returns (bool) {
634     return true;
635   }
636 
637   //
638   // Modifiers
639   //
640 
641   /** Modified allowing execution only if the crowdsale is currently running.  */
642   modifier inState(State state) {
643     if(getState() != state) throw;
644     _;
645   }
646 
647 
648   //
649   // Abstract functions
650   //
651 
652   /**
653    * Check if the current invested breaks our cap rules.
654    *
655    *
656    * The child contract must define their own cap setting rules.
657    * We allow a lot of flexibility through different capping strategies (ETH, token count)
658    * Called from invest().
659    *
660    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
661    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
662    * @param weiRaisedTotal What would be our total raised balance after this transaction
663    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
664    *
665    * @return true if taking this investment would break our cap rules
666    */
667   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
668 
669   /**
670    * Check if the current crowdsale is full and we can no longer sell any tokens.
671    */
672   function isCrowdsaleFull() public constant returns (bool);
673 
674   /**
675    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
676    */
677   function assignTokens(address receiver, uint tokenAmount) internal;
678 }
679 
680 /**
681  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
682  *
683  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
684  */
685 
686 
687 /**
688  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
689  *
690  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
691  */
692 
693 /**
694  * Deserialize bytes payloads.
695  *
696  * Values are in big-endian byte order.
697  *
698  */
699 library BytesDeserializer {
700 
701   /**
702    * Extract 256-bit worth of data from the bytes stream.
703    */
704   function slice32(bytes b, uint offset) constant returns (bytes32) {
705     bytes32 out;
706 
707     for (uint i = 0; i < 32; i++) {
708       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
709     }
710     return out;
711   }
712 
713   /**
714    * Extract Ethereum address worth of data from the bytes stream.
715    */
716   function sliceAddress(bytes b, uint offset) constant returns (address) {
717     bytes32 out;
718 
719     for (uint i = 0; i < 20; i++) {
720       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
721     }
722     return address(uint(out));
723   }
724 
725   /**
726    * Extract 128-bit worth of data from the bytes stream.
727    */
728   function slice16(bytes b, uint offset) constant returns (bytes16) {
729     bytes16 out;
730 
731     for (uint i = 0; i < 16; i++) {
732       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
733     }
734     return out;
735   }
736 
737   /**
738    * Extract 32-bit worth of data from the bytes stream.
739    */
740   function slice4(bytes b, uint offset) constant returns (bytes4) {
741     bytes4 out;
742 
743     for (uint i = 0; i < 4; i++) {
744       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
745     }
746     return out;
747   }
748 
749   /**
750    * Extract 16-bit worth of data from the bytes stream.
751    */
752   function slice2(bytes b, uint offset) constant returns (bytes2) {
753     bytes2 out;
754 
755     for (uint i = 0; i < 2; i++) {
756       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
757     }
758     return out;
759   }
760 
761 
762 
763 }
764 
765 
766 /**
767  * A mix-in contract to decode different signed KYC payloads.
768  *
769  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we currently use this as a helper method mix-in.
770  */
771 contract KYCPayloadDeserializer {
772 
773   using BytesDeserializer for bytes;
774 
775   // @notice this struct describes what kind of data we include in the payload, we do not use this directly
776   // The bytes payload set on the server side
777   // total 56 bytes
778   struct KYCPayload {
779 
780     /** Customer whitelisted address where the deposit can come from */
781     address whitelistedAddress; // 20 bytes
782 
783     /** Customer id, UUID v4 */
784     uint128 customerId; // 16 bytes
785 
786     /**
787      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
788      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
789      */
790     uint32 minETH; // 4 bytes
791 
792     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
793     uint32 maxETH; // 4 bytes
794 
795     /**
796      * Information about the price promised for this participant. It can be pricing tier id or directly one token price in weis.
797      * @notice This is a later addition and not supported in all scenarios yet.
798      */
799     uint256 pricingInfo;
800   }
801 
802   /**
803    * Same as above, does not seem to cause any issue.
804    */
805   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
806     address _whitelistedAddress = dataframe.sliceAddress(0);
807     uint128 _customerId = uint128(dataframe.slice16(20));
808     uint32 _minETH = uint32(dataframe.slice4(36));
809     uint32 _maxETH = uint32(dataframe.slice4(40));
810     return (_whitelistedAddress, _customerId, _minETH, _maxETH);
811   }
812 
813   /**
814    * Same as above, but with pricing information included in the payload as the last integer.
815    *
816    * @notice In a long run, deprecate the legacy methods above and only use this payload.
817    */
818   function getKYCPresalePayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth, uint256 pricingInfo) {
819     address _whitelistedAddress = dataframe.sliceAddress(0);
820     uint128 _customerId = uint128(dataframe.slice16(20));
821     uint32 _minETH = uint32(dataframe.slice4(36));
822     uint32 _maxETH = uint32(dataframe.slice4(40));
823     uint256 _pricingInfo = uint256(dataframe.slice32(44));
824     return (_whitelistedAddress, _customerId, _minETH, _maxETH, _pricingInfo);
825   }
826 
827 }
828 
829 
830 /**
831  * A presale smart contract that collects money from SAFT/SAFTE agreed buyers.
832  *
833  * Presale contract where we collect money for the token that does not exist yet.
834  * The same KYC rules apply as in KYCCrowdsale. No tokens are issued in this point,
835  * but they are delivered to the buyers after the token sale is over.
836  *
837  */
838 contract KYCPresale is CrowdsaleBase, KYCPayloadDeserializer {
839 
840   /** The cap of this presale contract in wei */
841   uint256 public saleWeiCap;
842 
843   /** Server holds the private key to this address to decide if the AML payload is valid or not. */
844   address public signerAddress;
845 
846   /** A new server-side signer key was set to be effective */
847   event SignerChanged(address signer);
848 
849   /** An user made a prepurchase through KYC'ed interface. The money has been moved to the token sale multisig wallet. The buyer will receive their tokens in an airdrop after the token sale is over. */
850   event Prepurchased(address investor, uint weiAmount, uint tokenAmount, uint128 customerId, uint256 pricingInfo);
851 
852   /** The owner changes the presale ETH cap during the sale */
853   event CapUpdated(uint256 newCap);
854 
855   /**
856    * Constructor.
857    *
858    * Presale does not know about token or pricing strategy, as they will be only available during the future airdrop.
859    *
860    * @dev The parent contract has some unnecessary variables for our use case. For this round of development, we chose to use null value for token and pricing strategy. In the future versions have a parent sale contract that does not assume an existing token.
861    */
862   function KYCPresale(address _multisigWallet, uint _start, uint _end, uint _saleWeiCap) CrowdsaleBase(FractionalERC20(address(1)), PricingStrategy(address(0)), _multisigWallet, _start, _end, 0) {
863     saleWeiCap = _saleWeiCap;
864   }
865 
866   /**
867    * A token purchase with anti-money laundering
868    *
869    * ©return tokenAmount How many tokens where bought
870    */
871   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
872 
873     // Presale ended / emergency abort
874     require(!halted);
875 
876     bytes32 hash = sha256(dataframe);
877     var (whitelistedAddress, customerId, minETH, maxETH, pricingInfo) = getKYCPresalePayload(dataframe);
878     uint multiplier = 10 ** 18;
879     address receiver = msg.sender;
880     uint weiAmount = msg.value;
881 
882     // The payload was created by token sale server
883     require(ecrecover(hash, v, r, s) == signerAddress);
884 
885     // Determine if it's a good time to accept investment from this participant
886     if(getState() == State.PreFunding) {
887       // Are we whitelisted for early deposit
888       require(earlyParticipantWhitelist[receiver]);
889     } else if(getState() == State.Funding) {
890       // Retail participants can only come in when the crowdsale is running
891       // pass
892     } else {
893       // Unwanted state
894       revert;
895     }
896 
897     if(investedAmountOf[receiver] == 0) {
898        // A new investor
899        investorCount++;
900     }
901 
902     // Update per investor amount
903     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
904 
905     // Update totals
906     weiRaised = weiRaised.plus(weiAmount);
907 
908     // Check that we did not bust the cap
909     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
910 
911     require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
912     require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
913 
914     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
915     require(multisigWallet.send(weiAmount));
916 
917     // Tell us invest was success
918     Prepurchased(receiver, weiAmount, tokenAmount, customerId, pricingInfo);
919 
920     return 0; // In presale we do not issue actual tokens tyet
921   }
922 
923   /// @dev This function can set the server side address
924   /// @param _signerAddress The address derived from server's private key
925   function setSignerAddress(address _signerAddress) onlyOwner {
926     signerAddress = _signerAddress;
927     SignerChanged(signerAddress);
928   }
929 
930   /**
931    * Called from invest() to confirm if the curret investment does not break our cap rule.
932    */
933   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
934     if(weiRaisedTotal > saleWeiCap) {
935       return true;
936     } else {
937       return false;
938     }
939   }
940 
941   /**
942    * We are sold out when our approve pool becomes empty.
943    */
944   function isCrowdsaleFull() public constant returns (bool) {
945     return weiRaised >= saleWeiCap;
946   }
947 
948   /**
949    * Allow owner to adjust the cap during the presale.
950    *
951    * This allows e.g. US dollar pegged caps.
952    */
953   function setWeiCap(uint newCap) public onlyOwner {
954     saleWeiCap = newCap;
955     CapUpdated(newCap);
956   }
957 
958   /**
959    * Because this is a presale, we do not issue any tokens yet.
960    *
961    * @dev Have this taken away from the parent contract?
962    */
963   function assignTokens(address receiver, uint tokenAmount) internal {
964     revert;
965   }
966 
967   /**
968    * Allow to (re)set pricing strategy.
969    *
970    * @dev Because we do not have token price set in presale, we do nothing. This will be removed in the future versions.
971    */
972   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
973   }
974 
975   /**
976    * Presale state machine management.
977    *
978    * Presale cannot fail; it is running until manually ended.
979    *
980    */
981   function getState() public constant returns (State) {
982     if (block.timestamp < startsAt) {
983       return State.PreFunding;
984     } else {
985       return State.Funding;
986     }
987   }
988 
989 }