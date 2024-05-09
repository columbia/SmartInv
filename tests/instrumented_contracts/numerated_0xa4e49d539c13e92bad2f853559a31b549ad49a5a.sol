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
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 
58 /*
59  * Haltable
60  *
61  * Abstract contract that allows children to implement an
62  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
63  *
64  *
65  * Originally envisioned in FirstBlood ICO contract.
66  */
67 contract Haltable is Ownable {
68   bool public halted;
69 
70   modifier stopInEmergency {
71     if (halted) throw;
72     _;
73   }
74 
75   modifier stopNonOwnersInEmergency {
76     if (halted && msg.sender != owner) throw;
77     _;
78   }
79 
80   modifier onlyInEmergency {
81     if (!halted) throw;
82     _;
83   }
84 
85   // called by the owner on emergency, triggers stopped state
86   function halt() external onlyOwner {
87     halted = true;
88   }
89 
90   // called by the owner on end of emergency, returns to normal state
91   function unhalt() external onlyOwner onlyInEmergency {
92     halted = false;
93   }
94 
95 }
96 
97 /**
98  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
99  *
100  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
101  */
102 
103 
104 /**
105  * Safe unsigned safe math.
106  *
107  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
108  *
109  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
110  *
111  * Maintained here until merged to mainline zeppelin-solidity.
112  *
113  */
114 library SafeMathLib {
115 
116   function times(uint a, uint b) returns (uint) {
117     uint c = a * b;
118     assert(a == 0 || c / a == b);
119     return c;
120   }
121 
122   function minus(uint a, uint b) returns (uint) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   function plus(uint a, uint b) returns (uint) {
128     uint c = a + b;
129     assert(c>=a);
130     return c;
131   }
132 
133 }
134 
135 /**
136  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
137  *
138  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
139  */
140 
141 
142 
143 
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/179
149  */
150 contract ERC20Basic {
151   function totalSupply() public view returns (uint256);
152   function balanceOf(address who) public view returns (uint256);
153   function transfer(address to, uint256 value) public returns (bool);
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164   function allowance(address owner, address spender) public view returns (uint256);
165   function transferFrom(address from, address to, uint256 value) public returns (bool);
166   function approve(address spender, uint256 value) public returns (bool);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 
171 /**
172  * A token that defines fractional units as decimals.
173  */
174 contract FractionalERC20 is ERC20 {
175 
176   uint public decimals;
177 
178 }
179 
180 /**
181  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
182  *
183  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
184  */
185 
186 
187 /**
188  * Interface for defining crowdsale pricing.
189  */
190 contract PricingStrategy {
191 
192   /** Interface declaration. */
193   function isPricingStrategy() public constant returns (bool) {
194     return true;
195   }
196 
197   /** Self check if all references are correctly set.
198    *
199    * Checks that pricing strategy matches crowdsale parameters.
200    */
201   function isSane(address crowdsale) public constant returns (bool) {
202     return true;
203   }
204 
205   /**
206    * @dev Pricing tells if this is a presale purchase or not.
207      @param purchaser Address of the purchaser
208      @return False by default, true if a presale purchaser
209    */
210   function isPresalePurchase(address purchaser) public constant returns (bool) {
211     return false;
212   }
213 
214   /**
215    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
216    *
217    *
218    * @param value - What is the value of the transaction send in as wei
219    * @param tokensSold - how much tokens have been sold this far
220    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
221    * @param msgSender - who is the investor of this transaction
222    * @param decimals - how many decimal units the token has
223    * @return Amount of tokens the investor receives
224    */
225   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
226 }
227 
228 /**
229  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
230  *
231  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
232  */
233 
234 
235 /**
236  * Finalize agent defines what happens at the end of succeseful crowdsale.
237  *
238  * - Allocate tokens for founders, bounties and community
239  * - Make tokens transferable
240  * - etc.
241  */
242 contract FinalizeAgent {
243 
244   function isFinalizeAgent() public constant returns(bool) {
245     return true;
246   }
247 
248   /** Return true if we can run finalizeCrowdsale() properly.
249    *
250    * This is a safety check function that doesn't allow crowdsale to begin
251    * unless the finalizer has been set up properly.
252    */
253   function isSane() public constant returns (bool);
254 
255   /** Called once by crowdsale finalize() if the sale was success. */
256   function finalizeCrowdsale();
257 
258 }
259 
260 
261 
262 /**
263  * Crowdsale state machine without buy functionality.
264  *
265  * Implements basic state machine logic, but leaves out all buy functions,
266  * so that subclasses can implement their own buying logic.
267  *
268  *
269  * For the default buy() implementation see Crowdsale.sol.
270  */
271 contract CrowdsaleBase is Haltable {
272 
273   /* Max investment count when we are still allowed to change the multisig address */
274   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
275 
276   using SafeMathLib for uint;
277 
278   /* The token we are selling */
279   FractionalERC20 public token;
280 
281   /* How we are going to price our offering */
282   PricingStrategy public pricingStrategy;
283 
284   /* Post-success callback */
285   FinalizeAgent public finalizeAgent;
286 
287   /* tokens will be transfered from this address */
288   address public multisigWallet;
289 
290   /* if the funding goal is not reached, investors may withdraw their funds */
291   uint public minimumFundingGoal;
292 
293   /* the UNIX timestamp start date of the crowdsale */
294   uint public startsAt;
295 
296   /* the UNIX timestamp end date of the crowdsale */
297   uint public endsAt;
298 
299   /* the number of tokens already sold through this contract*/
300   uint public tokensSold = 0;
301 
302   /* How many wei of funding we have raised */
303   uint public weiRaised = 0;
304 
305   /* Calculate incoming funds from presale contracts and addresses */
306   uint public presaleWeiRaised = 0;
307 
308   /* How many distinct addresses have invested */
309   uint public investorCount = 0;
310 
311   /* How much wei we have returned back to the contract after a failed crowdfund. */
312   uint public loadedRefund = 0;
313 
314   /* How much wei we have given back to investors.*/
315   uint public weiRefunded = 0;
316 
317   /* Has this crowdsale been finalized */
318   bool public finalized;
319 
320   /** How much ETH each address has invested to this crowdsale */
321   mapping (address => uint256) public investedAmountOf;
322 
323   /** How much tokens this crowdsale has credited for each investor address */
324   mapping (address => uint256) public tokenAmountOf;
325 
326   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
327   mapping (address => bool) public earlyParticipantWhitelist;
328 
329   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
330   uint public ownerTestValue;
331 
332   /** State machine
333    *
334    * - Preparing: All contract initialization calls and variables have not been set yet
335    * - Prefunding: We have not passed start time yet
336    * - Funding: Active crowdsale
337    * - Success: Minimum funding goal reached
338    * - Failure: Minimum funding goal not reached before ending time
339    * - Finalized: The finalized has been called and succesfully executed
340    * - Refunding: Refunds are loaded on the contract for reclaim.
341    */
342   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
343 
344   // A new investment was made
345   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
346 
347   // Refund was processed for a contributor
348   event Refund(address investor, uint weiAmount);
349 
350   // The rules were changed what kind of investments we accept
351   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
352 
353   // Address early participation whitelist status changed
354   event Whitelisted(address addr, bool status);
355 
356   // Crowdsale end time has been changed
357   event EndsAtChanged(uint newEndsAt);
358 
359   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
360 
361     owner = msg.sender;
362 
363     token = FractionalERC20(_token);
364     setPricingStrategy(_pricingStrategy);
365 
366     multisigWallet = _multisigWallet;
367     if(multisigWallet == 0) {
368         throw;
369     }
370 
371     if(_start == 0) {
372         throw;
373     }
374 
375     startsAt = _start;
376 
377     if(_end == 0) {
378         throw;
379     }
380 
381     endsAt = _end;
382 
383     // Don't mess the dates
384     if(startsAt >= endsAt) {
385         throw;
386     }
387 
388     // Minimum funding goal can be zero
389     minimumFundingGoal = _minimumFundingGoal;
390   }
391 
392   /**
393    * Don't expect to just send in money and get tokens.
394    */
395   function() payable {
396     throw;
397   }
398 
399   /**
400    * Make an investment.
401    *
402    * Crowdsale must be running for one to invest.
403    * We must have not pressed the emergency brake.
404    *
405    * @param receiver The Ethereum address who receives the tokens
406    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
407    *
408    * @return tokenAmount How mony tokens were bought
409    */
410   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
411 
412     // Determine if it's a good time to accept investment from this participant
413     if(getState() == State.PreFunding) {
414       // Are we whitelisted for early deposit
415       if(!earlyParticipantWhitelist[receiver]) {
416         throw;
417       }
418     } else if(getState() == State.Funding) {
419       // Retail participants can only come in when the crowdsale is running
420       // pass
421     } else {
422       // Unwanted state
423       throw;
424     }
425 
426     uint weiAmount = msg.value;
427 
428     // Account presale sales separately, so that they do not count against pricing tranches
429     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
430 
431     // Dust transaction
432     require(tokenAmount != 0);
433 
434     if(investedAmountOf[receiver] == 0) {
435        // A new investor
436        investorCount++;
437     }
438 
439     // Update investor
440     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
441     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
442 
443     // Update totals
444     weiRaised = weiRaised.plus(weiAmount);
445     tokensSold = tokensSold.plus(tokenAmount);
446 
447     if(pricingStrategy.isPresalePurchase(receiver)) {
448         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
449     }
450 
451     // Check that we did not bust the cap
452     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
453 
454     assignTokens(receiver, tokenAmount);
455 
456     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
457     if(!multisigWallet.send(weiAmount)) throw;
458 
459     // Tell us invest was success
460     Invested(receiver, weiAmount, tokenAmount, customerId);
461 
462     return tokenAmount;
463   }
464 
465   /**
466    * Finalize a succcesful crowdsale.
467    *
468    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
469    */
470   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
471 
472     // Already finalized
473     if(finalized) {
474       throw;
475     }
476 
477     // Finalizing is optional. We only call it if we are given a finalizing agent.
478     if(address(finalizeAgent) != 0) {
479       finalizeAgent.finalizeCrowdsale();
480     }
481 
482     finalized = true;
483   }
484 
485   /**
486    * Allow to (re)set finalize agent.
487    *
488    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
489    */
490   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
491     finalizeAgent = addr;
492 
493     // Don't allow setting bad agent
494     if(!finalizeAgent.isFinalizeAgent()) {
495       throw;
496     }
497   }
498 
499   /**
500    * Allow crowdsale owner to close early or extend the crowdsale.
501    *
502    * This is useful e.g. for a manual soft cap implementation:
503    * - after X amount is reached determine manual closing
504    *
505    * This may put the crowdsale to an invalid state,
506    * but we trust owners know what they are doing.
507    *
508    */
509   function setEndsAt(uint time) onlyOwner {
510 
511     if(now > time) {
512       throw; // Don't change past
513     }
514 
515     if(startsAt > time) {
516       throw; // Prevent human mistakes
517     }
518 
519     endsAt = time;
520     EndsAtChanged(endsAt);
521   }
522 
523   /**
524    * Allow to (re)set pricing strategy.
525    *
526    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
527    */
528   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
529     pricingStrategy = _pricingStrategy;
530 
531     // Don't allow setting bad agent
532     if(!pricingStrategy.isPricingStrategy()) {
533       throw;
534     }
535   }
536 
537   /**
538    * Allow to change the team multisig address in the case of emergency.
539    *
540    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
541    * (we have done only few test transactions). After the crowdsale is going
542    * then multisig address stays locked for the safety reasons.
543    */
544   function setMultisig(address addr) public onlyOwner {
545 
546     // Change
547     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
548       throw;
549     }
550 
551     multisigWallet = addr;
552   }
553 
554   /**
555    * Allow load refunds back on the contract for the refunding.
556    *
557    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
558    */
559   function loadRefund() public payable inState(State.Failure) {
560     if(msg.value == 0) throw;
561     loadedRefund = loadedRefund.plus(msg.value);
562   }
563 
564   /**
565    * Investors can claim refund.
566    *
567    * Note that any refunds from proxy buyers should be handled separately,
568    * and not through this contract.
569    */
570   function refund() public inState(State.Refunding) {
571     uint256 weiValue = investedAmountOf[msg.sender];
572     if (weiValue == 0) throw;
573     investedAmountOf[msg.sender] = 0;
574     weiRefunded = weiRefunded.plus(weiValue);
575     Refund(msg.sender, weiValue);
576     if (!msg.sender.send(weiValue)) throw;
577   }
578 
579   /**
580    * @return true if the crowdsale has raised enough money to be a successful.
581    */
582   function isMinimumGoalReached() public constant returns (bool reached) {
583     return weiRaised >= minimumFundingGoal;
584   }
585 
586   /**
587    * Check if the contract relationship looks good.
588    */
589   function isFinalizerSane() public constant returns (bool sane) {
590     return finalizeAgent.isSane();
591   }
592 
593   /**
594    * Check if the contract relationship looks good.
595    */
596   function isPricingSane() public constant returns (bool sane) {
597     return pricingStrategy.isSane(address(this));
598   }
599 
600   /**
601    * Crowdfund state machine management.
602    *
603    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
604    */
605   function getState() public constant returns (State) {
606     if(finalized) return State.Finalized;
607     else if (address(finalizeAgent) == 0) return State.Preparing;
608     else if (!finalizeAgent.isSane()) return State.Preparing;
609     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
610     else if (block.timestamp < startsAt) return State.PreFunding;
611     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
612     else if (isMinimumGoalReached()) return State.Success;
613     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
614     else return State.Failure;
615   }
616 
617   /** This is for manual testing of multisig wallet interaction */
618   function setOwnerTestValue(uint val) onlyOwner {
619     ownerTestValue = val;
620   }
621 
622   /**
623    * Allow addresses to do early participation.
624    *
625    * TODO: Fix spelling error in the name
626    */
627   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
628     earlyParticipantWhitelist[addr] = status;
629     Whitelisted(addr, status);
630   }
631 
632 
633   /** Interface marker. */
634   function isCrowdsale() public constant returns (bool) {
635     return true;
636   }
637 
638   //
639   // Modifiers
640   //
641 
642   /** Modified allowing execution only if the crowdsale is currently running.  */
643   modifier inState(State state) {
644     if(getState() != state) throw;
645     _;
646   }
647 
648 
649   //
650   // Abstract functions
651   //
652 
653   /**
654    * Check if the current invested breaks our cap rules.
655    *
656    *
657    * The child contract must define their own cap setting rules.
658    * We allow a lot of flexibility through different capping strategies (ETH, token count)
659    * Called from invest().
660    *
661    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
662    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
663    * @param weiRaisedTotal What would be our total raised balance after this transaction
664    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
665    *
666    * @return true if taking this investment would break our cap rules
667    */
668   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
669 
670   /**
671    * Check if the current crowdsale is full and we can no longer sell any tokens.
672    */
673   function isCrowdsaleFull() public constant returns (bool);
674 
675   /**
676    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
677    */
678   function assignTokens(address receiver, uint tokenAmount) internal;
679 }
680 
681 /**
682  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
683  *
684  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
685  */
686 
687 
688 /**
689  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
690  *
691  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
692  */
693 
694 /**
695  * Deserialize bytes payloads.
696  *
697  * Values are in big-endian byte order.
698  *
699  */
700 library BytesDeserializer {
701 
702   /**
703    * Extract 256-bit worth of data from the bytes stream.
704    */
705   function slice32(bytes b, uint offset) constant returns (bytes32) {
706     bytes32 out;
707 
708     for (uint i = 0; i < 32; i++) {
709       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
710     }
711     return out;
712   }
713 
714   /**
715    * Extract Ethereum address worth of data from the bytes stream.
716    */
717   function sliceAddress(bytes b, uint offset) constant returns (address) {
718     bytes32 out;
719 
720     for (uint i = 0; i < 20; i++) {
721       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
722     }
723     return address(uint(out));
724   }
725 
726   /**
727    * Extract 128-bit worth of data from the bytes stream.
728    */
729   function slice16(bytes b, uint offset) constant returns (bytes16) {
730     bytes16 out;
731 
732     for (uint i = 0; i < 16; i++) {
733       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
734     }
735     return out;
736   }
737 
738   /**
739    * Extract 32-bit worth of data from the bytes stream.
740    */
741   function slice4(bytes b, uint offset) constant returns (bytes4) {
742     bytes4 out;
743 
744     for (uint i = 0; i < 4; i++) {
745       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
746     }
747     return out;
748   }
749 
750   /**
751    * Extract 16-bit worth of data from the bytes stream.
752    */
753   function slice2(bytes b, uint offset) constant returns (bytes2) {
754     bytes2 out;
755 
756     for (uint i = 0; i < 2; i++) {
757       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
758     }
759     return out;
760   }
761 
762 
763 
764 }
765 
766 
767 /**
768  * A mix-in contract to decode different signed KYC payloads.
769  *
770  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we currently use this as a helper method mix-in.
771  */
772 contract KYCPayloadDeserializer {
773 
774   using BytesDeserializer for bytes;
775 
776   // @notice this struct describes what kind of data we include in the payload, we do not use this directly
777   // The bytes payload set on the server side
778   // total 56 bytes
779   struct KYCPayload {
780 
781     /** Customer whitelisted address where the deposit can come from */
782     address whitelistedAddress; // 20 bytes
783 
784     /** Customer id, UUID v4 */
785     uint128 customerId; // 16 bytes
786 
787     /**
788      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
789      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
790      */
791     uint32 minETH; // 4 bytes
792 
793     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
794     uint32 maxETH; // 4 bytes
795 
796     /**
797      * Information about the price promised for this participant. It can be pricing tier id or directly one token price in weis.
798      * @notice This is a later addition and not supported in all scenarios yet.
799      */
800     uint256 pricingInfo;
801   }
802 
803   /**
804    * Same as above, does not seem to cause any issue.
805    */
806   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
807     address _whitelistedAddress = dataframe.sliceAddress(0);
808     uint128 _customerId = uint128(dataframe.slice16(20));
809     uint32 _minETH = uint32(dataframe.slice4(36));
810     uint32 _maxETH = uint32(dataframe.slice4(40));
811     return (_whitelistedAddress, _customerId, _minETH, _maxETH);
812   }
813 
814   /**
815    * Same as above, but with pricing information included in the payload as the last integer.
816    *
817    * @notice In a long run, deprecate the legacy methods above and only use this payload.
818    */
819   function getKYCPresalePayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth, uint256 pricingInfo) {
820     address _whitelistedAddress = dataframe.sliceAddress(0);
821     uint128 _customerId = uint128(dataframe.slice16(20));
822     uint32 _minETH = uint32(dataframe.slice4(36));
823     uint32 _maxETH = uint32(dataframe.slice4(40));
824     uint256 _pricingInfo = uint256(dataframe.slice32(44));
825     return (_whitelistedAddress, _customerId, _minETH, _maxETH, _pricingInfo);
826   }
827 
828 }
829 
830 
831 /**
832  * A presale smart contract that collects money from SAFT/SAFTE agreed buyers.
833  *
834  * Presale contract where we collect money for the token that does not exist yet.
835  * The same KYC rules apply as in KYCCrowdsale. No tokens are issued in this point,
836  * but they are delivered to the buyers after the token sale is over.
837  *
838  */
839 contract KYCPresale is CrowdsaleBase, KYCPayloadDeserializer {
840 
841   /** The cap of this presale contract in wei */
842   uint256 public saleWeiCap;
843 
844   /** Server holds the private key to this address to decide if the AML payload is valid or not. */
845   address public signerAddress;
846 
847   /** A new server-side signer key was set to be effective */
848   event SignerChanged(address signer);
849 
850   /** An user made a prepurchase through KYC'ed interface. The money has been moved to the token sale multisig wallet. The buyer will receive their tokens in an airdrop after the token sale is over. */
851   event Prepurchased(address investor, uint weiAmount, uint tokenAmount, uint128 customerId, uint256 pricingInfo);
852 
853   /** The owner changes the presale ETH cap during the sale */
854   event CapUpdated(uint256 newCap);
855 
856   /**
857    * Constructor.
858    *
859    * Presale does not know about token or pricing strategy, as they will be only available during the future airdrop.
860    *
861    * @dev The parent contract has some unnecessary variables for our use case. For this round of development, we chose to use null value for token and pricing strategy. In the future versions have a parent sale contract that does not assume an existing token.
862    */
863   function KYCPresale(address _multisigWallet, uint _start, uint _end, uint _saleWeiCap) CrowdsaleBase(FractionalERC20(address(1)), PricingStrategy(address(0)), _multisigWallet, _start, _end, 0) {
864     saleWeiCap = _saleWeiCap;
865   }
866 
867   /**
868    * A token purchase with anti-money laundering
869    *
870    * ©return tokenAmount How many tokens where bought
871    */
872   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
873 
874     // Presale ended / emergency abort
875     require(!halted);
876 
877     bytes32 hash = sha256(dataframe);
878     var (whitelistedAddress, customerId, minETH, maxETH, pricingInfo) = getKYCPresalePayload(dataframe);
879     uint multiplier = 10 ** 18;
880     address receiver = msg.sender;
881     uint weiAmount = msg.value;
882 
883     // The payload was created by token sale server
884     require(ecrecover(hash, v, r, s) == signerAddress);
885 
886     // Determine if it's a good time to accept investment from this participant
887     if(getState() == State.PreFunding) {
888       // Are we whitelisted for early deposit
889       require(earlyParticipantWhitelist[receiver]);
890     } else if(getState() == State.Funding) {
891       // Retail participants can only come in when the crowdsale is running
892       // pass
893     } else {
894       // Unwanted state
895       revert;
896     }
897 
898     if(investedAmountOf[receiver] == 0) {
899        // A new investor
900        investorCount++;
901     }
902 
903     // Update per investor amount
904     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
905 
906     // Update totals
907     weiRaised = weiRaised.plus(weiAmount);
908 
909     // Check that we did not bust the cap
910     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
911 
912     require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
913     require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
914 
915     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
916     require(multisigWallet.send(weiAmount));
917 
918     // Tell us invest was success
919     Prepurchased(receiver, weiAmount, tokenAmount, customerId, pricingInfo);
920 
921     return 0; // In presale we do not issue actual tokens tyet
922   }
923 
924   /// @dev This function can set the server side address
925   /// @param _signerAddress The address derived from server's private key
926   function setSignerAddress(address _signerAddress) onlyOwner {
927     signerAddress = _signerAddress;
928     SignerChanged(signerAddress);
929   }
930 
931   /**
932    * Called from invest() to confirm if the curret investment does not break our cap rule.
933    */
934   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
935     if(weiRaisedTotal > saleWeiCap) {
936       return true;
937     } else {
938       return false;
939     }
940   }
941 
942   /**
943    * We are sold out when our approve pool becomes empty.
944    */
945   function isCrowdsaleFull() public constant returns (bool) {
946     return weiRaised >= saleWeiCap;
947   }
948 
949   /**
950    * Allow owner to adjust the cap during the presale.
951    *
952    * This allows e.g. US dollar pegged caps.
953    */
954   function setWeiCap(uint newCap) public onlyOwner {
955     saleWeiCap = newCap;
956     CapUpdated(newCap);
957   }
958 
959   /**
960    * Because this is a presale, we do not issue any tokens yet.
961    *
962    * @dev Have this taken away from the parent contract?
963    */
964   function assignTokens(address receiver, uint tokenAmount) internal {
965     revert;
966   }
967 
968   /**
969    * Allow to (re)set pricing strategy.
970    *
971    * @dev Because we do not have token price set in presale, we do nothing. This will be removed in the future versions.
972    */
973   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
974   }
975 
976   /**
977    * Presale state machine management.
978    *
979    * Presale cannot fail; it is running until manually ended.
980    *
981    */
982   function getState() public constant returns (State) {
983     if (block.timestamp < startsAt) {
984       return State.PreFunding;
985     } else {
986       return State.Funding;
987     }
988   }
989 
990 }