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
479    * @dev Calculate tokens user will have for their purchase
480    *
481    * @param weisTotal How much ethers (in wei) the user putssssss in
482    * @param pricePerToken What is the price for one token
483    *
484    * @return tokensTotal which is received tokens, token decimals included
485    */
486   function calculateTokens(uint256 weisTotal, uint256 pricePerToken) public constant returns(uint tokensTotal) {
487     // pricePerToken is how many full tokens, token decimal place included, you get for wei amount.
488     // Because, in theory, decimal amount can vary, we do the exponent calculation here,
489     // though gas wise using 10**18 constant would be much simpler.
490     // Furthermore we could use rough amounts and take in raw wei per tokens amount,
491     // but we lose too much accuracy for generic calculations, thus all these are
492     // practically implemented as 10**18 fixed points.
493     uint multiplier = 10 ** token.decimals();
494     return weisTotal.times(multiplier)/pricePerToken;
495   }
496 
497   /**
498    * Finalize a succcesful crowdsale.
499    *
500    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
501    */
502   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
503 
504     // Already finalized
505     if(finalized) {
506       throw;
507     }
508 
509     // Finalizing is optional. We only call it if we are given a finalizing agent.
510     if(address(finalizeAgent) != 0) {
511       finalizeAgent.finalizeCrowdsale();
512     }
513 
514     finalized = true;
515   }
516 
517   /**
518    * Allow to (re)set finalize agent.
519    *
520    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
521    */
522   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
523     finalizeAgent = addr;
524 
525     // Don't allow setting bad agent
526     if(!finalizeAgent.isFinalizeAgent()) {
527       throw;
528     }
529   }
530 
531   /**
532    * Allow crowdsale owner to close early or extend the crowdsale.
533    *
534    * This is useful e.g. for a manual soft cap implementation:
535    * - after X amount is reached determine manual closing
536    *
537    * This may put the crowdsale to an invalid state,
538    * but we trust owners know what they are doing.
539    *
540    */
541   function setEndsAt(uint time) onlyOwner {
542 
543     if(now > time) {
544       throw; // Don't change past
545     }
546 
547     if(startsAt > time) {
548       throw; // Prevent human mistakes
549     }
550 
551     endsAt = time;
552     EndsAtChanged(endsAt);
553   }
554 
555   /**
556    * Allow to (re)set pricing strategy.
557    *
558    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
559    */
560   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
561     pricingStrategy = _pricingStrategy;
562 
563     // Don't allow setting bad agent
564     if(!pricingStrategy.isPricingStrategy()) {
565       throw;
566     }
567   }
568 
569   /**
570    * Allow to change the team multisig address in the case of emergency.
571    *
572    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
573    * (we have done only few test transactions). After the crowdsale is going
574    * then multisig address stays locked for the safety reasons.
575    */
576   function setMultisig(address addr) public onlyOwner {
577 
578     // Change
579     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
580       throw;
581     }
582 
583     multisigWallet = addr;
584   }
585 
586   /**
587    * Allow load refunds back on the contract for the refunding.
588    *
589    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
590    */
591   function loadRefund() public payable inState(State.Failure) {
592     if(msg.value == 0) throw;
593     loadedRefund = loadedRefund.plus(msg.value);
594   }
595 
596   /**
597    * Investors can claim refund.
598    *
599    * Note that any refunds from proxy buyers should be handled separately,
600    * and not through this contract.
601    */
602   function refund() public inState(State.Refunding) {
603     uint256 weiValue = investedAmountOf[msg.sender];
604     if (weiValue == 0) throw;
605     investedAmountOf[msg.sender] = 0;
606     weiRefunded = weiRefunded.plus(weiValue);
607     Refund(msg.sender, weiValue);
608     if (!msg.sender.send(weiValue)) throw;
609   }
610 
611   /**
612    * @return true if the crowdsale has raised enough money to be a successful.
613    */
614   function isMinimumGoalReached() public constant returns (bool reached) {
615     return weiRaised >= minimumFundingGoal;
616   }
617 
618   /**
619    * Check if the contract relationship looks good.
620    */
621   function isFinalizerSane() public constant returns (bool sane) {
622     return finalizeAgent.isSane();
623   }
624 
625   /**
626    * Check if the contract relationship looks good.
627    */
628   function isPricingSane() public constant returns (bool sane) {
629     return pricingStrategy.isSane(address(this));
630   }
631 
632   /**
633    * Crowdfund state machine management.
634    *
635    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
636    */
637   function getState() public constant returns (State) {
638     if(finalized) return State.Finalized;
639     else if (address(finalizeAgent) == 0) return State.Preparing;
640     else if (!finalizeAgent.isSane()) return State.Preparing;
641     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
642     else if (block.timestamp < startsAt) return State.PreFunding;
643     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
644     else if (isMinimumGoalReached()) return State.Success;
645     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
646     else return State.Failure;
647   }
648 
649   /** This is for manual testing of multisig wallet interaction */
650   function setOwnerTestValue(uint val) onlyOwner {
651     ownerTestValue = val;
652   }
653 
654   /**
655    * Allow addresses to do early participation.
656    *
657    * TODO: Fix spelling error in the name
658    */
659   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
660     earlyParticipantWhitelist[addr] = status;
661     Whitelisted(addr, status);
662   }
663 
664 
665   /** Interface marker. */
666   function isCrowdsale() public constant returns (bool) {
667     return true;
668   }
669 
670   //
671   // Modifiers
672   //
673 
674   /** Modified allowing execution only if the crowdsale is currently running.  */
675   modifier inState(State state) {
676     if(getState() != state) throw;
677     _;
678   }
679 
680 
681   //
682   // Abstract functions
683   //
684 
685   /**
686    * Check if the current invested breaks our cap rules.
687    *
688    *
689    * The child contract must define their own cap setting rules.
690    * We allow a lot of flexibility through different capping strategies (ETH, token count)
691    * Called from invest().
692    *
693    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
694    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
695    * @param weiRaisedTotal What would be our total raised balance after this transaction
696    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
697    *
698    * @return true if taking this investment would break our cap rules
699    */
700   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
701 
702   /**
703    * Check if the current crowdsale is full and we can no longer sell any tokens.
704    */
705   function isCrowdsaleFull() public constant returns (bool);
706 
707   /**
708    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
709    */
710   function assignTokens(address receiver, uint tokenAmount) internal;
711 }
712 
713 /**
714  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
715  *
716  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
717  */
718 
719 
720 
721 
722 /**
723  * A mixin that is selling tokens from a preallocated pool
724  *
725  * - Tokens have precreated supply "premined"
726  *
727  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
728  *
729  * - The mixin does not implement buy entry point.
730  *
731  */
732 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
733 
734   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
735   address public beneficiary;
736 
737   /**
738    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
739    *
740    */
741   function AllocatedCrowdsaleMixin(address _beneficiary) {
742     beneficiary = _beneficiary;
743   }
744 
745   /**
746    * Called from invest() to confirm if the curret investment does not break our cap rule.
747    */
748   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
749     if(tokenAmount > getTokensLeft()) {
750       return true;
751     } else {
752       return false;
753     }
754   }
755 
756   /**
757    * We are sold out when our approve pool becomes empty.
758    */
759   function isCrowdsaleFull() public constant returns (bool) {
760     return getTokensLeft() == 0;
761   }
762 
763   /**
764    * Get the amount of unsold tokens allocated to this contract;
765    */
766   function getTokensLeft() public constant returns (uint) {
767     return token.allowance(owner, this);
768   }
769 
770   /**
771    * Transfer tokens from approve() pool to the buyer.
772    *
773    * Use approve() given to this crowdsale to distribute the tokens.
774    */
775   function assignTokens(address receiver, uint tokenAmount) internal {
776     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
777   }
778 }
779 
780 /**
781  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
782  *
783  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
784  */
785 
786 
787 /**
788  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
789  *
790  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
791  */
792 
793 /**
794  * Deserialize bytes payloads.
795  *
796  * Values are in big-endian byte order.
797  *
798  */
799 library BytesDeserializer {
800 
801   /**
802    * Extract 256-bit worth of data from the bytes stream.
803    */
804   function slice32(bytes b, uint offset) constant returns (bytes32) {
805     bytes32 out;
806 
807     for (uint i = 0; i < 32; i++) {
808       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
809     }
810     return out;
811   }
812 
813   /**
814    * Extract Ethereum address worth of data from the bytes stream.
815    */
816   function sliceAddress(bytes b, uint offset) constant returns (address) {
817     bytes32 out;
818 
819     for (uint i = 0; i < 20; i++) {
820       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
821     }
822     return address(uint(out));
823   }
824 
825   /**
826    * Extract 128-bit worth of data from the bytes stream.
827    */
828   function slice16(bytes b, uint offset) constant returns (bytes16) {
829     bytes16 out;
830 
831     for (uint i = 0; i < 16; i++) {
832       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
833     }
834     return out;
835   }
836 
837   /**
838    * Extract 32-bit worth of data from the bytes stream.
839    */
840   function slice4(bytes b, uint offset) constant returns (bytes4) {
841     bytes4 out;
842 
843     for (uint i = 0; i < 4; i++) {
844       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
845     }
846     return out;
847   }
848 
849   /**
850    * Extract 16-bit worth of data from the bytes stream.
851    */
852   function slice2(bytes b, uint offset) constant returns (bytes2) {
853     bytes2 out;
854 
855     for (uint i = 0; i < 2; i++) {
856       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
857     }
858     return out;
859   }
860 
861 
862 
863 }
864 
865 
866 /**
867  * A mix-in contract to decode different signed KYC payloads.
868  *
869  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we currently use this as a helper method mix-in.
870  */
871 contract KYCPayloadDeserializer {
872 
873   using BytesDeserializer for bytes;
874 
875   // @notice this struct describes what kind of data we include in the payload, we do not use this directly
876   // The bytes payload set on the server side
877   // total 56 bytes
878   struct KYCPayload {
879 
880     /** Customer whitelisted address where the deposit can come from */
881     address whitelistedAddress; // 20 bytes
882 
883     /** Customer id, UUID v4 */
884     uint128 customerId; // 16 bytes
885 
886     /**
887      * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
888      * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
889      */
890     uint32 minETH; // 4 bytes
891 
892     /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
893     uint32 maxETH; // 4 bytes
894 
895     /**
896      * Information about the price promised for this participant. It can be pricing tier id or directly one token price in weis.
897      * @notice This is a later addition and not supported in all scenarios yet.
898      */
899     uint256 pricingInfo;
900   }
901 
902 
903   /**
904    * Same as above, but with pricing information included in the payload as the last integer.
905    *
906    * @notice In a long run, deprecate the legacy methods above and only use this payload.
907    */
908   function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth, uint256 pricingInfo) {
909     address _whitelistedAddress = dataframe.sliceAddress(0);
910     uint128 _customerId = uint128(dataframe.slice16(20));
911     uint32 _minETH = uint32(dataframe.slice4(36));
912     uint32 _maxETH = uint32(dataframe.slice4(40));
913     uint256 _pricingInfo = uint256(dataframe.slice32(44));
914     return (_whitelistedAddress, _customerId, _minETH, _maxETH, _pricingInfo);
915   }
916 
917 }
918 
919 
920 /**
921  * A crowdsale that allows buys only from signed payload with server-side specified limits and price.
922  *
923  * The token distribution happens as in the allocated crowdsale.
924  *
925  */
926 contract KYCCrowdsale is AllocatedCrowdsaleMixin, KYCPayloadDeserializer {
927 
928   /* Server holds the private key to this address to sign incoming buy payloads to signal we have KYC records in the books for these users. */
929   address public signerAddress;
930 
931   /* A new server-side signer key was set to be effective */
932   event SignerChanged(address signer);
933 
934   /**
935    * Constructor.
936    */
937   function KYCCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
938 
939   }
940 
941   /**
942    * A token purchase with anti-money laundering
943    *
944    * ©return tokenAmount How many tokens where bought
945    */
946   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable returns(uint tokenAmount) {
947 
948     uint _tokenAmount;
949     uint multiplier = 10 ** 18;
950 
951     // Perform signature check for normal addresses
952     // (not deployment accounts, etc.)
953     if(earlyParticipantWhitelist[msg.sender]) {
954       // Deployment provided early participant list is for deployment and diagnostics
955       // For test purchases use this faux customer id 0x1000
956       _tokenAmount = investInternal(msg.sender, 0x1000);
957 
958     } else {
959       // User comes through the server, check that the signature to ensure ther server
960       // side KYC has passed for this customer id and whitelisted Ethereum address
961 
962       bytes32 hash = sha256(dataframe);
963 
964       var (whitelistedAddress, customerId, minETH, maxETH, pricingInfo) = getKYCPayload(dataframe);
965 
966       // Check that the KYC data is signed by our server
967       require(ecrecover(hash, v, r, s) == signerAddress);
968 
969       // Only whitelisted address can participate the transaction
970       require(whitelistedAddress == msg.sender);
971 
972       // Server gives us information what is the buy price for this user
973       uint256 tokensTotal = calculateTokens(msg.value, pricingInfo);
974 
975       _tokenAmount = buyTokens(msg.sender, customerId, tokensTotal);
976     }
977 
978     if(!earlyParticipantWhitelist[msg.sender]) {
979       // We assume there is no serious min and max fluctuations for the customer, unless
980       // especially set in the server side per customer manual override.
981       // Otherwise the customer can reuse old data payload with different min or max value
982       // to work around the per customer cap.
983       require(investedAmountOf[msg.sender] >= minETH * multiplier / 10000);
984       require(investedAmountOf[msg.sender] <= maxETH * multiplier / 10000);
985     }
986 
987     return _tokenAmount;
988   }
989 
990   /// @dev This function can set the server side address
991   /// @param _signerAddress The address derived from server's private key
992   function setSignerAddress(address _signerAddress) onlyOwner {
993     signerAddress = _signerAddress;
994     SignerChanged(signerAddress);
995   }
996 
997 }