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
54 
55   function getCurrentTrancheVolume(uint tokensSold) public constant returns (uint);
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
103 
104 /**
105  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
106  *
107  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
108  */
109 
110 
111 /**
112  * Finalize agent defines what happens at the end of succeseful crowdsale.
113  *
114  * - Allocate tokens for founders, bounties and community
115  * - Make tokens transferable
116  * - etc.
117  */
118 contract FinalizeAgent {
119 
120   function isFinalizeAgent() public constant returns(bool) {
121     return true;
122   }
123 
124   /** Return true if we can run finalizeCrowdsale() properly.
125    *
126    * This is a safety check function that doesn't allow crowdsale to begin
127    * unless the finalizer has been set up properly.
128    */
129   function isSane() public constant returns (bool);
130 
131   /** Called once by crowdsale finalize() if the sale was success. */
132   function finalizeCrowdsale();
133 
134 }
135 
136 /**
137  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
138  *
139  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
140  */
141 
142 
143 
144 
145 
146 
147 /**
148  * @title ERC20Basic
149  * @dev Simpler version of ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/179
151  */
152 contract ERC20Basic {
153   uint256 public totalSupply;
154   function balanceOf(address who) constant returns (uint256);
155   function transfer(address to, uint256 value) returns (bool);
156   event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 is ERC20Basic {
166   function allowance(address owner, address spender) constant returns (uint256);
167   function transferFrom(address from, address to, uint256 value) returns (bool);
168   function approve(address spender, uint256 value) returns (bool);
169   event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 
173 /**
174  * A token that defines fractional units as decimals.
175  */
176 contract FractionalERC20 is ERC20 {
177 
178   uint public decimals;
179 
180 }
181 
182 /**
183  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
184  *
185  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
186  */
187 
188 
189 /**
190  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
191  *
192  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
193  */
194 
195 
196 
197 
198 /**
199  * @title Ownable
200  * @dev The Ownable contract has an owner address, and provides basic authorization control
201  * functions, this simplifies the implementation of "user permissions".
202  */
203 contract Ownable {
204   address public owner;
205 
206 
207   /**
208    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209    * account.
210    */
211   function Ownable() {
212     owner = msg.sender;
213   }
214 
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222   }
223 
224 
225   /**
226    * @dev Allows the current owner to transfer control of the contract to a newOwner.
227    * @param newOwner The address to transfer ownership to.
228    */
229   function transferOwnership(address newOwner) onlyOwner {
230     require(newOwner != address(0));      
231     owner = newOwner;
232   }
233 
234 }
235 
236 
237 /*
238  * Haltable
239  *
240  * Abstract contract that allows children to implement an
241  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
242  *
243  *
244  * Originally envisioned in FirstBlood ICO contract.
245  */
246 contract Haltable is Ownable {
247   bool public halted;
248 
249   modifier stopInEmergency {
250     if (halted) throw;
251     _;
252   }
253 
254   modifier stopNonOwnersInEmergency {
255     if (halted && msg.sender != owner) throw;
256     _;
257   }
258 
259   modifier onlyInEmergency {
260     if (!halted) throw;
261     _;
262   }
263 
264   // called by the owner on emergency, triggers stopped state
265   function halt() external onlyOwner {
266     halted = true;
267   }
268 
269   // called by the owner on end of emergency, returns to normal state
270   function unhalt() external onlyOwner onlyInEmergency {
271     halted = false;
272   }
273 
274 }
275 
276 
277 
278 
279 
280 
281 
282 /**
283  * Crowdsale state machine without buy functionality.
284  *
285  * Implements basic state machine logic, but leaves out all buy functions,
286  * so that subclasses can implement their own buying logic.
287  *
288  *
289  * For the default buy() implementation see Crowdsale.sol.
290  */
291 contract CrowdsaleBase is Haltable {
292 
293   /* Max investment count when we are still allowed to change the multisig address */
294   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
295 
296   using SafeMathLib for uint;
297 
298   /* The token we are selling */
299   FractionalERC20 public token;
300 
301   /* How we are going to price our offering */
302   PricingStrategy public pricingStrategy;
303 
304   /* Post-success callback */
305   FinalizeAgent public finalizeAgent;
306 
307   /* tokens will be transfered from this address */
308   address public multisigWallet;
309 
310   /* if the funding goal is not reached, investors may withdraw their funds */
311   uint public minimumFundingGoal;
312 
313   /* the UNIX timestamp start date of the crowdsale */
314   uint public startsAt;
315 
316   /* the UNIX timestamp end date of the crowdsale */
317   uint public endsAt;
318 
319   /* the number of tokens already sold through this contract*/
320   uint public tokensSold = 0;
321 
322   /* How many wei of funding we have raised */
323   uint public weiRaised = 0;
324 
325   /* Calculate incoming funds from presale contracts and addresses */
326   uint public presaleWeiRaised = 0;
327 
328   /* How many distinct addresses have invested */
329   uint public investorCount = 0;
330 
331   /* How much wei we have returned back to the contract after a failed crowdfund. */
332   uint public loadedRefund = 0;
333 
334   /* How much wei we have given back to investors.*/
335   uint public weiRefunded = 0;
336 
337   /* Has this crowdsale been finalized */
338   bool public finalized;
339 
340   /** How much ETH each address has invested to this crowdsale */
341   mapping (address => uint256) public investedAmountOf;
342 
343   /** How much tokens this crowdsale has credited for each investor address */
344   mapping (address => uint256) public tokenAmountOf;
345 
346   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
347   mapping (address => bool) public earlyParticipantWhitelist;
348 
349   /** Addresses that are allowed to participate at any stage */
350   mapping (address => bool) public isKycWhitelist;
351 
352   /** Addresses that are allowed to call automated management functions */
353   mapping (address => bool) public isManagement;
354 
355   /** Minimum number of transactions in a tranche (protects against large purchases breaking tranche barriers by too much */
356   uint public trancheMinTx = 0;
357 
358   /** Maximum that any single address can purchase (1 / max * totalSupply) */
359   uint public maximumPurchaseFraction = 0;
360 
361   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
362   uint public ownerTestValue;
363 
364   /** State machine
365    *
366    * - Preparing: All contract initialization calls and variables have not been set yet
367    * - Prefunding: We have not passed start time yet
368    * - Funding: Active crowdsale
369    * - Success: Minimum funding goal reached
370    * - Failure: Minimum funding goal not reached before ending time
371    * - Finalized: The finalized has been called and succesfully executed
372    * - Refunding: Refunds are loaded on the contract for reclaim.
373    */
374   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
375 
376   // A new investment was made
377   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
378 
379   // Refund was processed for a contributor
380   event Refund(address investor, uint weiAmount);
381 
382   // The rules were changed what kind of investments we accept
383   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
384 
385   // Address early participation whitelist status changed
386   event Whitelisted(address addr, bool status);
387   event KycWhitelisted(address addr, bool status);
388   event ManagementWhitelisted(address addr, bool status);
389 
390   // Crowdsale end time has been changed
391   event EndsAtChanged(uint newEndsAt);
392 
393   State public testState;
394 
395   modifier onlyWhitelist() {
396     require(isKycWhitelist[msg.sender]);
397     _;
398   }
399   modifier onlyManagement() {
400     require(isManagement[msg.sender]);
401     _;
402   }
403 
404   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
405 
406     owner = msg.sender;
407 
408     token = FractionalERC20(_token);
409 
410     setPricingStrategy(_pricingStrategy);
411 
412     multisigWallet = _multisigWallet;
413     if(multisigWallet == 0) {
414         throw;
415     }
416 
417     if(_start == 0) {
418         throw;
419     }
420 
421     startsAt = _start;
422 
423     if(_end == 0) {
424         throw;
425     }
426 
427     endsAt = _end;
428 
429     // Don't mess the dates
430     if(startsAt >= endsAt) {
431         throw;
432     }
433 
434     // Minimum funding goal can be zero
435     minimumFundingGoal = _minimumFundingGoal;
436   }
437 
438   /**
439    * Don't expect to just send in money and get tokens.
440    */
441   function() payable {
442     throw;
443   }
444 
445   /**
446    * Whitelist manegement
447    */
448   function setKycWhitelist(address _address, bool _state) public onlyManagement {
449     isKycWhitelist[_address] = _state;
450     KycWhitelisted(_address, _state);
451   }
452   /**
453    * Management list manegement
454    */
455   function setManagement(address _address, bool _state) public onlyOwner {
456     isManagement[_address] = _state;
457     ManagementWhitelisted(_address, _state);
458   }
459 
460   /**
461    * Tranche TX minimums
462    */
463   function setTrancheMinTx(uint _minimum) public onlyOwner {
464     trancheMinTx = _minimum;
465   }
466 
467   /**
468    * Total allowable purchase of tokens per address
469    */
470   function setMaximumPurchaseFraction(uint _maximum) public onlyOwner {
471     maximumPurchaseFraction = _maximum;
472   }
473 
474   /**
475    * Make an investment.
476    *
477    * Crowdsale must be running for one to invest.
478    * We must have not pressed the emergency brake.
479    *
480    * @param receiver The Ethereum address who receives the tokens
481    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
482    *
483    * @return tokenAmount How mony tokens were bought
484    */
485   function investInternal(address receiver, uint128 customerId) stopInEmergency onlyWhitelist internal returns(uint tokensBought) {
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
506     // Dust transaction
507     require(tokenAmount != 0);
508 
509     // Check that the tx is a reasonable volume for the tranche
510     if (trancheMinTx > 0) {
511       uint trancheVolume = pricingStrategy.getCurrentTrancheVolume(tokensSold);
512       uint maxVolume = trancheVolume / trancheMinTx;
513       require(tokenAmount <= maxVolume);
514     }
515 
516     if(maximumPurchaseFraction > 0) {
517       uint256 maximumPurchase = token.totalSupply() / maximumPurchaseFraction;
518       uint256 willHaveTokens = tokenAmountOf[receiver] + tokenAmount;
519       require(willHaveTokens <= maximumPurchase);
520     }
521 
522     if(investedAmountOf[receiver] == 0) {
523        // A new investor
524        investorCount++;
525     }
526 
527     // Update investor
528     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
529     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
530 
531     // Update totals
532     weiRaised = weiRaised.plus(weiAmount);
533     tokensSold = tokensSold.plus(tokenAmount);
534 
535     if(pricingStrategy.isPresalePurchase(receiver)) {
536         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
537     }
538 
539     // Check that we did not bust the cap
540     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
541 
542     assignTokens(receiver, tokenAmount);
543 
544     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
545     if(!multisigWallet.send(weiAmount)) throw;
546 
547     // Tell us invest was success
548     Invested(receiver, weiAmount, tokenAmount, customerId);
549 
550     return tokenAmount;
551   }
552 
553   /**
554    * Finalize a succcesful crowdsale.
555    *
556    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
557    */
558   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
559 
560     // Already finalized
561     if(finalized) {
562       throw;
563     }
564 
565     // Finalizing is optional. We only call it if we are given a finalizing agent.
566     if(address(finalizeAgent) != 0) {
567       finalizeAgent.finalizeCrowdsale();
568     }
569 
570     finalized = true;
571   }
572 
573   /**
574    * Allow to (re)set finalize agent.
575    *
576    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
577    */
578   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
579     finalizeAgent = addr;
580 
581     // Don't allow setting bad agent
582     if(!finalizeAgent.isFinalizeAgent()) {
583       throw;
584     }
585   }
586 
587   /**
588    * Allow crowdsale owner to close early or extend the crowdsale.
589    *
590    * This is useful e.g. for a manual soft cap implementation:
591    * - after X amount is reached determine manual closing
592    *
593    * This may put the crowdsale to an invalid state,
594    * but we trust owners know what they are doing.
595    *
596    */
597   function setEndsAt(uint time) onlyOwner {
598 
599     if(now > time) {
600       throw; // Don't change past
601     }
602 
603     if(startsAt > time) {
604       throw; // Prevent human mistakes
605     }
606 
607     endsAt = time;
608     EndsAtChanged(endsAt);
609   }
610 
611   /**
612    * Allow to (re)set pricing strategy.
613    *
614    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
615    */
616   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
617     pricingStrategy = _pricingStrategy;
618 
619     // Don't allow setting bad agent
620     if(!pricingStrategy.isPricingStrategy()) {
621       throw;
622     }
623   }
624 
625   /**
626    * Allow to change the team multisig address in the case of emergency.
627    *
628    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
629    * (we have done only few test transactions). After the crowdsale is going
630    * then multisig address stays locked for the safety reasons.
631    */
632   function setMultisig(address addr) public onlyOwner {
633 
634     // Change
635     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
636       throw;
637     }
638 
639     multisigWallet = addr;
640   }
641 
642   /**
643    * Allow load refunds back on the contract for the refunding.
644    *
645    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
646    */
647   function loadRefund() public payable inState(State.Failure) {
648     if(msg.value == 0) throw;
649     loadedRefund = loadedRefund.plus(msg.value);
650   }
651 
652   /**
653    * Investors can claim refund.
654    *
655    * Note that any refunds from proxy buyers should be handled separately,
656    * and not through this contract.
657    */
658   function refund() public inState(State.Refunding) {
659     uint256 weiValue = investedAmountOf[msg.sender];
660     if (weiValue == 0) throw;
661     investedAmountOf[msg.sender] = 0;
662     weiRefunded = weiRefunded.plus(weiValue);
663     Refund(msg.sender, weiValue);
664     if (!msg.sender.send(weiValue)) throw;
665   }
666 
667   /**
668    * @return true if the crowdsale has raised enough money to be a successful.
669    */
670   function isMinimumGoalReached() public constant returns (bool reached) {
671     return weiRaised >= minimumFundingGoal;
672   }
673 
674   /**
675    * Check if the contract relationship looks good.
676    */
677   function isFinalizerSane() public constant returns (bool sane) {
678     return finalizeAgent.isSane();
679   }
680 
681   /**
682    * Check if the contract relationship looks good.
683    */
684   function isPricingSane() public constant returns (bool sane) {
685     return pricingStrategy.isSane(address(this));
686   }
687 
688   /**
689    * Crowdfund state machine management.
690    *
691    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
692    */
693   function getState() public constant returns (State) {
694     if(finalized) return State.Finalized;
695     else if (address(finalizeAgent) == 0) return State.Preparing;
696     else if (!finalizeAgent.isSane()) return State.Preparing;
697     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
698     else if (block.timestamp < startsAt) return State.PreFunding;
699     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
700     else if (isMinimumGoalReached()) return State.Success;
701     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
702     else return State.Failure;
703   }
704 
705   /** This is for manual testing of multisig wallet interaction */
706   function setOwnerTestValue(uint val) onlyOwner {
707     ownerTestValue = val;
708   }
709 
710   /**
711    * Allow addresses to do early participation.
712    *
713    * TODO: Fix spelling error in the name
714    */
715   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
716     earlyParticipantWhitelist[addr] = status;
717     Whitelisted(addr, status);
718   }
719 
720 
721   /** Interface marker. */
722   function isCrowdsale() public constant returns (bool) {
723     return true;
724   }
725 
726   //
727   // Modifiers
728   //
729 
730   /** Modified allowing execution only if the crowdsale is currently running.  */
731   modifier inState(State state) {
732     if(getState() != state) throw;
733     _;
734   }
735 
736 
737   //
738   // Abstract functions
739   //
740 
741   /**
742    * Check if the current invested breaks our cap rules.
743    *
744    *
745    * The child contract must define their own cap setting rules.
746    * We allow a lot of flexibility through different capping strategies (ETH, token count)
747    * Called from invest().
748    *
749    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
750    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
751    * @param weiRaisedTotal What would be our total raised balance after this transaction
752    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
753    *
754    * @return true if taking this investment would break our cap rules
755    */
756   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
757 
758   /**
759    * Check if the current crowdsale is full and we can no longer sell any tokens.
760    */
761   function isCrowdsaleFull() public constant returns (bool);
762 
763   /**
764    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
765    */
766   function assignTokens(address receiver, uint tokenAmount) internal;
767 }
768 
769 
770 
771 /**
772  * Abstract base contract for token sales with the default buy entry points.
773  *
774  * Handle
775  * - start and end dates
776  * - accepting investments
777  * - minimum funding goal and refund
778  * - various statistics during the crowdfund
779  * - different pricing strategies
780  * - different investment policies (require server side customer id, allow only whitelisted addresses)
781  *
782  * Does not Handle
783  *
784  * - Token allocation (minting vs. transfer)
785  * - Cap rules
786  *
787  */
788 contract Crowdsale is CrowdsaleBase {
789 
790   /* Do we need to have unique contributor id for each customer */
791   bool public requireCustomerId;
792 
793   /**
794     * Do we verify that contributor has been cleared on the server side (accredited investors only).
795     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
796     */
797   bool public requiredSignedAddress;
798 
799   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
800   address public signerAddress;
801 
802   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
803   }
804 
805   /**
806    * Preallocate tokens for the early investors.
807    *
808    * Preallocated tokens have been sold before the actual crowdsale opens.
809    * This function mints the tokens and moves the crowdsale needle.
810    *
811    * Investor count is not handled; it is assumed this goes for multiple investors
812    * and the token distribution happens outside the smart contract flow.
813    *
814    * No money is exchanged, as the crowdsale team already have received the payment.
815    *
816    * @param fullTokens tokens as full tokens - decimal places added internally
817    * @param weiPrice Price of a single full token in wei
818    *
819    */
820   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
821 
822     uint tokenAmount = fullTokens * 10**token.decimals();
823     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
824 
825     weiRaised = weiRaised.plus(weiAmount);
826     tokensSold = tokensSold.plus(tokenAmount);
827 
828     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
829     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
830 
831     assignTokens(receiver, tokenAmount);
832 
833     // Tell us invest was success
834     Invested(receiver, weiAmount, tokenAmount, 0);
835   }
836 
837   /**
838    * Allow anonymous contributions to this crowdsale.
839    */
840   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
841      bytes32 hash = sha256(addr);
842      if (ecrecover(hash, v, r, s) != signerAddress) throw;
843      if(customerId == 0) throw;  // UUIDv4 sanity check
844      investInternal(addr, customerId);
845   }
846 
847   /**
848    * Track who is the customer making the payment so we can send thank you email.
849    */
850   function investWithCustomerId(address addr, uint128 customerId) public payable {
851     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
852     if(customerId == 0) throw;  // UUIDv4 sanity check
853     investInternal(addr, customerId);
854   }
855 
856   /**
857    * Allow anonymous contributions to this crowdsale.
858    */
859   function invest(address addr) public payable {
860     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
861     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
862     investInternal(addr, 0);
863   }
864 
865   /**
866    * Invest to tokens, recognize the payer and clear his address.
867    *
868    */
869   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
870     investWithSignedAddress(msg.sender, customerId, v, r, s);
871   }
872 
873   /**
874    * Invest to tokens, recognize the payer.
875    *
876    */
877   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
878     // see customerid.py
879     if (bytes1(sha3(customerId)) != checksum) throw;
880     investWithCustomerId(msg.sender, customerId);
881   }
882 
883   /**
884    * Legacy API signature.
885    */
886   function buyWithCustomerId(uint128 customerId) public payable {
887     investWithCustomerId(msg.sender, customerId);
888   }
889 
890   /**
891    * The basic entry point to participate the crowdsale process.
892    *
893    * Pay for funding, get invested tokens back in the sender address.
894    */
895   function buy() public payable {
896     invest(msg.sender);
897   }
898   function() payable {
899     buy();
900   }
901 
902   /**
903    * Set policy do we need to have server-side customer ids for the investments.
904    *
905    */
906   function setRequireCustomerId(bool value) onlyOwner {
907     requireCustomerId = value;
908     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
909   }
910 
911   /**
912    * Set policy if all investors must be cleared on the server side first.
913    *
914    * This is e.g. for the accredited investor clearing.
915    *
916    */
917   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
918     requiredSignedAddress = value;
919     signerAddress = _signerAddress;
920     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
921   }
922 
923 }
924 
925 
926 
927 
928 /// @dev Tranche based pricing with special support for pre-ico deals.
929 ///      Implementing "first price" tranches, meaning, that if buyers order is
930 ///      covering more than one tranche, the price of the lowest tranche will apply
931 ///      to the whole order.
932 contract TokenTranchePricing is PricingStrategy, Ownable {
933 
934   using SafeMathLib for uint;
935 
936   uint public constant MAX_TRANCHES = 10;
937 
938   // This contains all pre-ICO addresses, and their prices (weis per token)
939   mapping (address => uint) public preicoAddresses;
940 
941   /**
942   * Define pricing schedule using tranches.
943   */
944   struct Tranche {
945 
946       // Amount in weis when this tranche becomes active
947       uint amount;
948 
949       // How many tokens per satoshi you will get while this tranche is active
950       uint price;
951   }
952 
953   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
954   // Tranche 0 is always (0, 0)
955   // (TODO: change this when we confirm dynamic arrays are explorable)
956   Tranche[10] public tranches;
957 
958   // How many active tranches we have
959   uint public trancheCount;
960 
961   /// @dev Contruction, creating a list of tranches
962   /// @param _tranches uint[] tranches Pairs of (start amount, price)
963   function TokenTranchePricing(uint[] _tranches) {
964     // Need to have tuples, length check
965     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
966       throw;
967     }
968 
969     trancheCount = _tranches.length / 2;
970 
971     uint highestAmount = 0;
972 
973     for(uint i=0; i<_tranches.length/2; i++) {
974       tranches[i].amount = _tranches[i*2];
975       tranches[i].price = _tranches[i*2+1];
976 
977       // No invalid steps
978       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
979         throw;
980       }
981 
982       highestAmount = tranches[i].amount;
983     }
984 
985     // Last tranche price must be zero, terminating the crowdale
986     if(tranches[trancheCount-1].price != 0) {
987       throw;
988     }
989   }
990 
991   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
992   ///      to 0 to disable
993   /// @param preicoAddress PresaleFundCollector address
994   /// @param pricePerToken How many weis one token cost for pre-ico investors
995   function setPreicoAddress(address preicoAddress, uint pricePerToken)
996     public
997     onlyOwner
998   {
999     preicoAddresses[preicoAddress] = pricePerToken;
1000   }
1001 
1002   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1003   /// @return tuple (time, price)
1004   function getTranche(uint n) public constant returns (uint, uint) {
1005     return (tranches[n].amount, tranches[n].price);
1006   }
1007 
1008   function getFirstTranche() private constant returns (Tranche) {
1009     return tranches[0];
1010   }
1011 
1012   function getLastTranche() private constant returns (Tranche) {
1013     return tranches[trancheCount-1];
1014   }
1015 
1016   function getPricingStartsAt() public constant returns (uint) {
1017     return getFirstTranche().amount;
1018   }
1019 
1020   function getPricingEndsAt() public constant returns (uint) {
1021     return getLastTranche().amount;
1022   }
1023 
1024   function isSane(address _crowdsale) public constant returns(bool) {
1025     // Our tranches are not bound by time, so we can't really check are we sane
1026     // so we presume we are ;)
1027     // In the future we could save and track raised tokens, and compare it to
1028     // the Crowdsale contract.
1029     return true;
1030   }
1031 
1032   /// @dev Get the index of the current tranche or bail out if we are not in the tranche periods.
1033   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1034   /// @return {uint} Index of the current tranche struct in the tranches array
1035   function getCurrentTrancheIdx(uint tokensSold) public constant returns (uint) {
1036     uint i;
1037 
1038     for(i=0; i < tranches.length; i++) {
1039       if(tokensSold < tranches[i].amount) {
1040         return i - 1;
1041       }
1042     }
1043   }
1044   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1045   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1046   /// @return {[type]} [description]
1047   function getCurrentTranche(uint tokensSold) public constant returns (Tranche) {
1048     return tranches[getCurrentTrancheIdx(tokensSold)];
1049   }
1050   /// @dev Get the total volume to be sold in the current tranche or bail out if we are not in the tranche periods.
1051   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1052   /// @return {uint} Number of tokens to be sold in the current tranche
1053   function getCurrentTrancheVolume(uint tokensSold) public constant returns (uint) {
1054     uint idx = getCurrentTrancheIdx(tokensSold);
1055 
1056     uint currAmount = tranches[idx].amount;
1057     uint nextAmount = tranches[idx + 1].amount;
1058     return nextAmount - currAmount;
1059   }
1060 
1061   /// @dev Get the current price.
1062   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1063   /// @return The current price or 0 if we are outside trache ranges
1064   function getCurrentPrice(uint tokensSold) public constant returns (uint result) {
1065     return getCurrentTranche(tokensSold).price;
1066   }
1067 
1068   /// @dev Calculate the current price for buy in amount.
1069   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1070 
1071     uint multiplier = 10 ** decimals;
1072 
1073     // This investor is coming through pre-ico
1074     if(preicoAddresses[msgSender] > 0) {
1075       return value.times(multiplier) / preicoAddresses[msgSender];
1076     }
1077 
1078     uint price = getCurrentPrice(tokensSold);
1079     return value.times(multiplier) / price;
1080   }
1081 
1082   function() payable {
1083     throw; // No money on this contract
1084   }
1085 
1086 }