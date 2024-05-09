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
400    * @dev Make an investment.
401    *
402    * Crowdsale must be running for one to invest.
403    * We must have not pressed the emergency brake.
404    *
405    * @param receiver The Ethereum address who receives the tokens
406    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
407    * @param tokenAmount Amount of tokens which be credited to receiver
408    *
409    * @return tokensBought How mony tokens were bought
410    */
411   function buyTokens(address receiver, uint128 customerId, uint256 tokenAmount) stopInEmergency internal returns(uint tokensBought) {
412 
413     // Determine if it's a good time to accept investment from this participant
414     if(getState() == State.PreFunding) {
415       // Are we whitelisted for early deposit
416       if(!earlyParticipantWhitelist[receiver]) {
417         throw;
418       }
419     } else if(getState() == State.Funding) {
420       // Retail participants can only come in when the crowdsale is running
421       // pass
422     } else {
423       // Unwanted state
424       throw;
425     }
426 
427     uint weiAmount = msg.value;
428 
429     // Dust transaction
430     require(tokenAmount != 0);
431 
432     if(investedAmountOf[receiver] == 0) {
433        // A new investor
434        investorCount++;
435     }
436 
437     // Update investor
438     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
439     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
440 
441     // Update totals
442     weiRaised = weiRaised.plus(weiAmount);
443     tokensSold = tokensSold.plus(tokenAmount);
444 
445     if(pricingStrategy.isPresalePurchase(receiver)) {
446         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
447     }
448 
449     // Check that we did not bust the cap
450     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
451 
452     assignTokens(receiver, tokenAmount);
453 
454     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
455     if(!multisigWallet.send(weiAmount)) throw;
456 
457     // Tell us invest was success
458     Invested(receiver, weiAmount, tokenAmount, customerId);
459 
460     return tokenAmount;
461   }
462 
463   /**
464    * @dev Make an investment based on pricing strategy
465    *
466    * This is a wrapper for buyTokens(), but the amount of tokens receiver will
467    * have depends on the pricing strategy used.
468    *
469    * @param receiver The Ethereum address who receives the tokens
470    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
471    *
472    * @return tokensBought How mony tokens were bought
473    */
474   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
475     return buyTokens(receiver, customerId, pricingStrategy.calculatePrice(msg.value, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals()));
476   }
477 
478   /**
479    * @dev Calculate tokens user will have for theirr purchase
480    *
481    * @param weisTotal How much ethers (in wei) the user putssssss in
482    * @param pricePerToken What is the price for one token
483    *
484    * @return tokensTotal which is weisTotal divided by pricePerToken
485    */
486   function calculateTokens(uint256 weisTotal, uint256 pricePerToken) public constant returns(uint tokensTotal) {
487     return weisTotal/pricePerToken;
488   }
489 
490   /**
491    * Finalize a succcesful crowdsale.
492    *
493    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
494    */
495   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
496 
497     // Already finalized
498     if(finalized) {
499       throw;
500     }
501 
502     // Finalizing is optional. We only call it if we are given a finalizing agent.
503     if(address(finalizeAgent) != 0) {
504       finalizeAgent.finalizeCrowdsale();
505     }
506 
507     finalized = true;
508   }
509 
510   /**
511    * Allow to (re)set finalize agent.
512    *
513    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
514    */
515   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
516     finalizeAgent = addr;
517 
518     // Don't allow setting bad agent
519     if(!finalizeAgent.isFinalizeAgent()) {
520       throw;
521     }
522   }
523 
524   /**
525    * Allow crowdsale owner to close early or extend the crowdsale.
526    *
527    * This is useful e.g. for a manual soft cap implementation:
528    * - after X amount is reached determine manual closing
529    *
530    * This may put the crowdsale to an invalid state,
531    * but we trust owners know what they are doing.
532    *
533    */
534   function setEndsAt(uint time) onlyOwner {
535 
536     if(now > time) {
537       throw; // Don't change past
538     }
539 
540     if(startsAt > time) {
541       throw; // Prevent human mistakes
542     }
543 
544     endsAt = time;
545     EndsAtChanged(endsAt);
546   }
547 
548   /**
549    * Allow to (re)set pricing strategy.
550    *
551    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
552    */
553   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
554     pricingStrategy = _pricingStrategy;
555 
556     // Don't allow setting bad agent
557     if(!pricingStrategy.isPricingStrategy()) {
558       throw;
559     }
560   }
561 
562   /**
563    * Allow to change the team multisig address in the case of emergency.
564    *
565    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
566    * (we have done only few test transactions). After the crowdsale is going
567    * then multisig address stays locked for the safety reasons.
568    */
569   function setMultisig(address addr) public onlyOwner {
570 
571     // Change
572     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
573       throw;
574     }
575 
576     multisigWallet = addr;
577   }
578 
579   /**
580    * Allow load refunds back on the contract for the refunding.
581    *
582    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
583    */
584   function loadRefund() public payable inState(State.Failure) {
585     if(msg.value == 0) throw;
586     loadedRefund = loadedRefund.plus(msg.value);
587   }
588 
589   /**
590    * Investors can claim refund.
591    *
592    * Note that any refunds from proxy buyers should be handled separately,
593    * and not through this contract.
594    */
595   function refund() public inState(State.Refunding) {
596     uint256 weiValue = investedAmountOf[msg.sender];
597     if (weiValue == 0) throw;
598     investedAmountOf[msg.sender] = 0;
599     weiRefunded = weiRefunded.plus(weiValue);
600     Refund(msg.sender, weiValue);
601     if (!msg.sender.send(weiValue)) throw;
602   }
603 
604   /**
605    * @return true if the crowdsale has raised enough money to be a successful.
606    */
607   function isMinimumGoalReached() public constant returns (bool reached) {
608     return weiRaised >= minimumFundingGoal;
609   }
610 
611   /**
612    * Check if the contract relationship looks good.
613    */
614   function isFinalizerSane() public constant returns (bool sane) {
615     return finalizeAgent.isSane();
616   }
617 
618   /**
619    * Check if the contract relationship looks good.
620    */
621   function isPricingSane() public constant returns (bool sane) {
622     return pricingStrategy.isSane(address(this));
623   }
624 
625   /**
626    * Crowdfund state machine management.
627    *
628    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
629    */
630   function getState() public constant returns (State) {
631     if(finalized) return State.Finalized;
632     else if (address(finalizeAgent) == 0) return State.Preparing;
633     else if (!finalizeAgent.isSane()) return State.Preparing;
634     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
635     else if (block.timestamp < startsAt) return State.PreFunding;
636     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
637     else if (isMinimumGoalReached()) return State.Success;
638     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
639     else return State.Failure;
640   }
641 
642   /** This is for manual testing of multisig wallet interaction */
643   function setOwnerTestValue(uint val) onlyOwner {
644     ownerTestValue = val;
645   }
646 
647   /**
648    * Allow addresses to do early participation.
649    *
650    * TODO: Fix spelling error in the name
651    */
652   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
653     earlyParticipantWhitelist[addr] = status;
654     Whitelisted(addr, status);
655   }
656 
657 
658   /** Interface marker. */
659   function isCrowdsale() public constant returns (bool) {
660     return true;
661   }
662 
663   //
664   // Modifiers
665   //
666 
667   /** Modified allowing execution only if the crowdsale is currently running.  */
668   modifier inState(State state) {
669     if(getState() != state) throw;
670     _;
671   }
672 
673 
674   //
675   // Abstract functions
676   //
677 
678   /**
679    * Check if the current invested breaks our cap rules.
680    *
681    *
682    * The child contract must define their own cap setting rules.
683    * We allow a lot of flexibility through different capping strategies (ETH, token count)
684    * Called from invest().
685    *
686    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
687    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
688    * @param weiRaisedTotal What would be our total raised balance after this transaction
689    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
690    *
691    * @return true if taking this investment would break our cap rules
692    */
693   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
694 
695   /**
696    * Check if the current crowdsale is full and we can no longer sell any tokens.
697    */
698   function isCrowdsaleFull() public constant returns (bool);
699 
700   /**
701    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
702    */
703   function assignTokens(address receiver, uint tokenAmount) internal;
704 }
705 
706 /**
707  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
708  *
709  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
710  */
711 
712 
713 /**
714  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
715  *
716  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
717  */
718 
719 /**
720  * Deserialize bytes payloads.
721  *
722  * Values are in big-endian byte order.
723  *
724  */
725 library BytesDeserializer {
726 
727   /**
728    * Extract 256-bit worth of data from the bytes stream.
729    */
730   function slice32(bytes b, uint offset) constant returns (bytes32) {
731     bytes32 out;
732 
733     for (uint i = 0; i < 32; i++) {
734       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
735     }
736     return out;
737   }
738 
739   /**
740    * Extract Ethereum address worth of data from the bytes stream.
741    */
742   function sliceAddress(bytes b, uint offset) constant returns (address) {
743     bytes32 out;
744 
745     for (uint i = 0; i < 20; i++) {
746       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
747     }
748     return address(uint(out));
749   }
750 
751   /**
752    * Extract 128-bit worth of data from the bytes stream.
753    */
754   function slice16(bytes b, uint offset) constant returns (bytes16) {
755     bytes16 out;
756 
757     for (uint i = 0; i < 16; i++) {
758       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
759     }
760     return out;
761   }
762 
763   /**
764    * Extract 32-bit worth of data from the bytes stream.
765    */
766   function slice4(bytes b, uint offset) constant returns (bytes4) {
767     bytes4 out;
768 
769     for (uint i = 0; i < 4; i++) {
770       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
771     }
772     return out;
773   }
774 
775   /**
776    * Extract 16-bit worth of data from the bytes stream.
777    */
778   function slice2(bytes b, uint offset) constant returns (bytes2) {
779     bytes2 out;
780 
781     for (uint i = 0; i < 2; i++) {
782       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
783     }
784     return out;
785   }
786 
787 
788 
789 }
790 
791 
792 /**
793  * A mix-in contract to decode different signed KYC payloads.
794  *
795  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we currently use this as a helper method mix-in.
796  */
797 contract KYCPayloadDeserializer {
798 
799   using BytesDeserializer for bytes;
800 
801   // @notice this struct describes what kind of data we include in the payload, we do not use this directly
802   // The bytes payload set on the server side
803   // total 56 bytes
804   struct KYCPayload {
805 
806     /** Customer whitelisted address where the deposit can come from */
807     address whitelistedAddress; // 20 bytes
808 
809     /** Customer id, UUID v4 */
810     uint128 customerId; // 16 bytes
811 
812     /**
813      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
814      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
815      */
816     uint32 minETH; // 4 bytes
817 
818     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
819     uint32 maxETH; // 4 bytes
820 
821     /**
822      * Information about the price promised for this participant. It can be pricing tier id or directly one token price in weis.
823      * @notice This is a later addition and not supported in all scenarios yet.
824      */
825     uint256 pricingInfo;
826   }
827 
828 
829   /**
830    * Same as above, but with pricing information included in the payload as the last integer.
831    *
832    * @notice In a long run, deprecate the legacy methods above and only use this payload.
833    */
834   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth, uint256 pricingInfo) {
835     address _whitelistedAddress = dataframe.sliceAddress(0);
836     uint128 _customerId = uint128(dataframe.slice16(20));
837     uint32 _minETH = uint32(dataframe.slice4(36));
838     uint32 _maxETH = uint32(dataframe.slice4(40));
839     uint256 _pricingInfo = uint256(dataframe.slice32(44));
840     return (_whitelistedAddress, _customerId, _minETH, _maxETH, _pricingInfo);
841   }
842 
843 }
844 
845 
846 /**
847  * A presale smart contract that collects money from SAFT/SAFTE agreed buyers.
848  *
849  * Presale contract where we collect money for the token that does not exist yet.
850  * The same KYC rules apply as in KYCCrowdsale. No tokens are issued in this point,
851  * but they are delivered to the buyers after the token sale is over.
852  *
853  */
854 contract KYCPresale is CrowdsaleBase, KYCPayloadDeserializer {
855 
856   /** The cap of this presale contract in wei */
857   uint256 public saleWeiCap;
858 
859   /** Server holds the private key to this address to decide if the AML payload is valid or not. */
860   address public signerAddress;
861 
862   /** A new server-side signer key was set to be effective */
863   event SignerChanged(address signer);
864 
865   /** An user made a prepurchase through KYC'ed interface. The money has been moved to the token sale multisig wallet. The buyer will receive their tokens in an airdrop after the token sale is over. */
866   event Prepurchased(address investor, uint weiAmount, uint tokenAmount, uint128 customerId, uint256 pricingInfo);
867 
868   /** The owner changes the presale ETH cap during the sale */
869   event CapUpdated(uint256 newCap);
870 
871   /**
872    * Constructor.
873    *
874    * Presale does not know about token or pricing strategy, as they will be only available during the future airdrop.
875    *
876    * @dev The parent contract has some unnecessary variables for our use case. For this round of development, we chose to use null value for token and pricing strategy. In the future versions have a parent sale contract that does not assume an existing token.
877    */
878   function KYCPresale(address _multisigWallet, uint _start, uint _end, uint _saleWeiCap) CrowdsaleBase(FractionalERC20(address(1)), PricingStrategy(address(0)), _multisigWallet, _start, _end, 0) {
879     saleWeiCap = _saleWeiCap;
880   }
881 
882   /**
883    * A token purchase with anti-money laundering
884    *
885    * ©return tokenAmount How many tokens where bought
886    */
887   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
888 
889     // Presale ended / emergency abort
890     require(!halted);
891 
892     bytes32 hash = sha256(dataframe);
893     var (whitelistedAddress, customerId, minETH, maxETH, pricingInfo) = getKYCPayload(dataframe);
894     uint multiplier = 10 ** 18;
895     address receiver = msg.sender;
896     uint weiAmount = msg.value;
897 
898     // The payload was created by token sale server
899     require(ecrecover(hash, v, r, s) == signerAddress);
900 
901     // Determine if it's a good time to accept investment from this participant
902     if(getState() == State.PreFunding) {
903       // Are we whitelisted for early deposit
904       require(earlyParticipantWhitelist[receiver]);
905     } else if(getState() == State.Funding) {
906       // Retail participants can only come in when the crowdsale is running
907       // pass
908     } else {
909       // Unwanted state
910       revert;
911     }
912 
913     if(investedAmountOf[receiver] == 0) {
914        // A new investor
915        investorCount++;
916     }
917 
918     // Update per investor amount
919     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
920 
921     // Update totals
922     weiRaised = weiRaised.plus(weiAmount);
923 
924     // Check that we did not bust the cap
925     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
926 
927     require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
928     require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
929 
930     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
931     require(multisigWallet.send(weiAmount));
932 
933     // Tell us invest was success
934     Prepurchased(receiver, weiAmount, tokenAmount, customerId, pricingInfo);
935 
936     return 0; // In presale we do not issue actual tokens tyet
937   }
938 
939   /// @dev This function can set the server side address
940   /// @param _signerAddress The address derived from server's private key
941   function setSignerAddress(address _signerAddress) onlyOwner {
942     signerAddress = _signerAddress;
943     SignerChanged(signerAddress);
944   }
945 
946   /**
947    * Called from invest() to confirm if the curret investment does not break our cap rule.
948    */
949   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
950     if(weiRaisedTotal > saleWeiCap) {
951       return true;
952     } else {
953       return false;
954     }
955   }
956 
957   /**
958    * We are sold out when our approve pool becomes empty.
959    */
960   function isCrowdsaleFull() public constant returns (bool) {
961     return weiRaised >= saleWeiCap;
962   }
963 
964   /**
965    * Allow owner to adjust the cap during the presale.
966    *
967    * This allows e.g. US dollar pegged caps.
968    */
969   function setWeiCap(uint newCap) public onlyOwner {
970     saleWeiCap = newCap;
971     CapUpdated(newCap);
972   }
973 
974   /**
975    * Because this is a presale, we do not issue any tokens yet.
976    *
977    * @dev Have this taken away from the parent contract?
978    */
979   function assignTokens(address receiver, uint tokenAmount) internal {
980     revert;
981   }
982 
983   /**
984    * Allow to (re)set pricing strategy.
985    *
986    * @dev Because we do not have token price set in presale, we do nothing. This will be removed in the future versions.
987    */
988   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
989   }
990 
991   /**
992    * Presale state machine management.
993    *
994    * Presale cannot fail; it is running until manually ended.
995    *
996    */
997   function getState() public constant returns (State) {
998     if (block.timestamp < startsAt) {
999       return State.PreFunding;
1000     } else {
1001       return State.Funding;
1002     }
1003   }
1004 
1005 }