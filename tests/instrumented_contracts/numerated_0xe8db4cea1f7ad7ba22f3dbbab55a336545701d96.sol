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
23  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
24  *
25  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
26  */
27 
28 
29 
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));      
64     owner = newOwner;
65   }
66 
67 }
68 
69 
70 /*
71  * Haltable
72  *
73  * Abstract contract that allows children to implement an
74  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
75  *
76  *
77  * Originally envisioned in FirstBlood ICO contract.
78  */
79 contract Haltable is Ownable {
80   bool public halted;
81 
82   modifier stopInEmergency {
83     if (halted) throw;
84     _;
85   }
86 
87   modifier stopNonOwnersInEmergency {
88     if (halted && msg.sender != owner) throw;
89     _;
90   }
91 
92   modifier onlyInEmergency {
93     if (!halted) throw;
94     _;
95   }
96 
97   // called by the owner on emergency, triggers stopped state
98   function halt() external onlyOwner {
99     halted = true;
100   }
101 
102   // called by the owner on end of emergency, returns to normal state
103   function unhalt() external onlyOwner onlyInEmergency {
104     halted = false;
105   }
106 
107 }
108 
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 /**
117  * Safe unsigned safe math.
118  *
119  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
120  *
121  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
122  *
123  * Maintained here until merged to mainline zeppelin-solidity.
124  *
125  */
126 library SafeMathLib {
127 
128   function times(uint a, uint b) returns (uint) {
129     uint c = a * b;
130     assert(a == 0 || c / a == b);
131     return c;
132   }
133 
134   function minus(uint a, uint b) returns (uint) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   function plus(uint a, uint b) returns (uint) {
140     uint c = a + b;
141     assert(c>=a);
142     return c;
143   }
144 
145 }
146 
147 /**
148  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
149  *
150  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
151  */
152 
153 
154 
155 
156 
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   uint256 public totalSupply;
165   function balanceOf(address who) constant returns (uint256);
166   function transfer(address to, uint256 value) returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) constant returns (uint256);
178   function transferFrom(address from, address to, uint256 value) returns (bool);
179   function approve(address spender, uint256 value) returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 /**
185  * A token that defines fractional units as decimals.
186  */
187 contract FractionalERC20 is ERC20 {
188 
189   uint public decimals;
190 
191 }
192 
193 /**
194  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
195  *
196  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
197  */
198 
199 
200 /**
201  * Interface for defining crowdsale pricing.
202  */
203 contract PricingStrategy {
204 
205   /** Interface declaration. */
206   function isPricingStrategy() public constant returns (bool) {
207     return true;
208   }
209 
210   /** Self check if all references are correctly set.
211    *
212    * Checks that pricing strategy matches crowdsale parameters.
213    */
214   function isSane(address crowdsale) public constant returns (bool) {
215     return true;
216   }
217 
218   /**
219    * @dev Pricing tells if this is a presale purchase or not.
220      @param purchaser Address of the purchaser
221      @return False by default, true if a presale purchaser
222    */
223   function isPresalePurchase(address purchaser) public constant returns (bool) {
224     return false;
225   }
226 
227   /**
228    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
229    *
230    *
231    * @param value - What is the value of the transaction send in as wei
232    * @param tokensSold - how much tokens have been sold this far
233    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
234    * @param msgSender - who is the investor of this transaction
235    * @param decimals - how many decimal units the token has
236    * @return Amount of tokens the investor receives
237    */
238   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
239 
240   function getCurrentTrancheVolume(uint tokensSold) public constant returns (uint);
241 }
242 
243 /**
244  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
245  *
246  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
247  */
248 
249 
250 /**
251  * Finalize agent defines what happens at the end of succeseful crowdsale.
252  *
253  * - Allocate tokens for founders, bounties and community
254  * - Make tokens transferable
255  * - etc.
256  */
257 contract FinalizeAgent {
258 
259   function isFinalizeAgent() public constant returns(bool) {
260     return true;
261   }
262 
263   /** Return true if we can run finalizeCrowdsale() properly.
264    *
265    * This is a safety check function that doesn't allow crowdsale to begin
266    * unless the finalizer has been set up properly.
267    */
268   function isSane() public constant returns (bool);
269 
270   /** Called once by crowdsale finalize() if the sale was success. */
271   function finalizeCrowdsale();
272 
273 }
274 
275 
276 
277 /**
278  * Crowdsale state machine without buy functionality.
279  *
280  * Implements basic state machine logic, but leaves out all buy functions,
281  * so that subclasses can implement their own buying logic.
282  *
283  *
284  * For the default buy() implementation see Crowdsale.sol.
285  */
286 contract CrowdsaleBase is Haltable {
287 
288   /* Max investment count when we are still allowed to change the multisig address */
289   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
290 
291   using SafeMathLib for uint;
292 
293   /* The token we are selling */
294   FractionalERC20 public token;
295 
296   /* How we are going to price our offering */
297   PricingStrategy public pricingStrategy;
298 
299   /* Post-success callback */
300   FinalizeAgent public finalizeAgent;
301 
302   /* tokens will be transfered from this address */
303   address public multisigWallet;
304 
305   /* if the funding goal is not reached, investors may withdraw their funds */
306   uint public minimumFundingGoal;
307 
308   /* the UNIX timestamp start date of the crowdsale */
309   uint public startsAt;
310 
311   /* the UNIX timestamp end date of the crowdsale */
312   uint public endsAt;
313 
314   /* the number of tokens already sold through this contract*/
315   uint public tokensSold = 0;
316 
317   /* How many wei of funding we have raised */
318   uint public weiRaised = 0;
319 
320   /* Calculate incoming funds from presale contracts and addresses */
321   uint public presaleWeiRaised = 0;
322 
323   /* How many distinct addresses have invested */
324   uint public investorCount = 0;
325 
326   /* How much wei we have returned back to the contract after a failed crowdfund. */
327   uint public loadedRefund = 0;
328 
329   /* How much wei we have given back to investors.*/
330   uint public weiRefunded = 0;
331 
332   /* Has this crowdsale been finalized */
333   bool public finalized;
334 
335   /** How much ETH each address has invested to this crowdsale */
336   mapping (address => uint256) public investedAmountOf;
337 
338   /** How much tokens this crowdsale has credited for each investor address */
339   mapping (address => uint256) public tokenAmountOf;
340 
341   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
342   mapping (address => bool) public earlyParticipantWhitelist;
343 
344   /** Addresses that are allowed to participate at any stage */
345   mapping (address => bool) public isKycWhitelist;
346 
347   /** Addresses that are allowed to call automated management functions */
348   mapping (address => bool) public isManagement;
349 
350   /** Minimum number of transactions in a tranche (protects against large purchases breaking tranche barriers by too much */
351   uint public trancheMinTx = 0;
352 
353   /** Maximum that any single address can purchase (1 / max * totalSupply) */
354   uint public maximumPurchaseFraction = 0;
355 
356   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
357   uint public ownerTestValue;
358 
359   /** State machine
360    *
361    * - Preparing: All contract initialization calls and variables have not been set yet
362    * - Prefunding: We have not passed start time yet
363    * - Funding: Active crowdsale
364    * - Success: Minimum funding goal reached
365    * - Failure: Minimum funding goal not reached before ending time
366    * - Finalized: The finalized has been called and succesfully executed
367    * - Refunding: Refunds are loaded on the contract for reclaim.
368    */
369   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
370 
371   // A new investment was made
372   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
373 
374   // Refund was processed for a contributor
375   event Refund(address investor, uint weiAmount);
376 
377   // The rules were changed what kind of investments we accept
378   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
379 
380   // Address early participation whitelist status changed
381   event Whitelisted(address addr, bool status);
382   event KycWhitelisted(address addr, bool status);
383   event ManagementWhitelisted(address addr, bool status);
384 
385   // Crowdsale end time has been changed
386   event EndsAtChanged(uint newEndsAt);
387 
388   State public testState;
389 
390   modifier onlyWhitelist() {
391     require(isKycWhitelist[msg.sender]);
392     _;
393   }
394   modifier onlyManagement() {
395     require(isManagement[msg.sender]);
396     _;
397   }
398 
399   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
400 
401     owner = msg.sender;
402 
403     token = FractionalERC20(_token);
404 
405     setPricingStrategy(_pricingStrategy);
406 
407     multisigWallet = _multisigWallet;
408     if(multisigWallet == 0) {
409         throw;
410     }
411 
412     if(_start == 0) {
413         throw;
414     }
415 
416     startsAt = _start;
417 
418     if(_end == 0) {
419         throw;
420     }
421 
422     endsAt = _end;
423 
424     // Don't mess the dates
425     if(startsAt >= endsAt) {
426         throw;
427     }
428 
429     // Minimum funding goal can be zero
430     minimumFundingGoal = _minimumFundingGoal;
431   }
432 
433   /**
434    * Don't expect to just send in money and get tokens.
435    */
436   function() payable {
437     throw;
438   }
439 
440   /**
441    * Whitelist manegement
442    */
443   function setKycWhitelist(address _address, bool _state) public onlyManagement {
444     isKycWhitelist[_address] = _state;
445     KycWhitelisted(_address, _state);
446   }
447   /**
448    * Management list manegement
449    */
450   function setManagement(address _address, bool _state) public onlyOwner {
451     isManagement[_address] = _state;
452     ManagementWhitelisted(_address, _state);
453   }
454 
455   /**
456    * Tranche TX minimums
457    */
458   function setTrancheMinTx(uint _minimum) public onlyOwner {
459     trancheMinTx = _minimum;
460   }
461 
462   /**
463    * Total allowable purchase of tokens per address
464    */
465   function setMaximumPurchaseFraction(uint _maximum) public onlyOwner {
466     maximumPurchaseFraction = _maximum;
467   }
468 
469   /**
470    * Make an investment.
471    *
472    * Crowdsale must be running for one to invest.
473    * We must have not pressed the emergency brake.
474    *
475    * @param receiver The Ethereum address who receives the tokens
476    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
477    *
478    * @return tokenAmount How mony tokens were bought
479    */
480   function investInternal(address receiver, uint128 customerId) stopInEmergency onlyWhitelist internal returns(uint tokensBought) {
481 
482     // Determine if it's a good time to accept investment from this participant
483     if(getState() == State.PreFunding) {
484       // Are we whitelisted for early deposit
485       if(!earlyParticipantWhitelist[receiver]) {
486         throw;
487       }
488     } else if(getState() == State.Funding) {
489       // Retail participants can only come in when the crowdsale is running
490       // pass
491     } else {
492       // Unwanted state
493       throw;
494     }
495 
496     uint weiAmount = msg.value;
497 
498     // Account presale sales separately, so that they do not count against pricing tranches
499     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
500 
501     // Dust transaction
502     require(tokenAmount != 0);
503 
504     // Check that the tx is a reasonable volume for the tranche
505     if (trancheMinTx > 0) {
506       uint trancheVolume = pricingStrategy.getCurrentTrancheVolume(tokensSold);
507       uint maxVolume = trancheVolume / trancheMinTx;
508       require(tokenAmount <= maxVolume);
509     }
510 
511     if(maximumPurchaseFraction > 0) {
512       uint256 maximumPurchase = token.totalSupply() / maximumPurchaseFraction;
513       uint256 willHaveTokens = tokenAmountOf[receiver] + tokenAmount;
514       require(willHaveTokens <= maximumPurchase);
515     }
516 
517     if(investedAmountOf[receiver] == 0) {
518        // A new investor
519        investorCount++;
520     }
521 
522     // Update investor
523     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
524     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
525 
526     // Update totals
527     weiRaised = weiRaised.plus(weiAmount);
528     tokensSold = tokensSold.plus(tokenAmount);
529 
530     if(pricingStrategy.isPresalePurchase(receiver)) {
531         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
532     }
533 
534     // Check that we did not bust the cap
535     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
536 
537     assignTokens(receiver, tokenAmount);
538 
539     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
540     if(!multisigWallet.send(weiAmount)) throw;
541 
542     // Tell us invest was success
543     Invested(receiver, weiAmount, tokenAmount, customerId);
544 
545     return tokenAmount;
546   }
547 
548   /**
549    * Finalize a succcesful crowdsale.
550    *
551    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
552    */
553   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
554 
555     // Already finalized
556     if(finalized) {
557       throw;
558     }
559 
560     // Finalizing is optional. We only call it if we are given a finalizing agent.
561     if(address(finalizeAgent) != 0) {
562       finalizeAgent.finalizeCrowdsale();
563     }
564 
565     finalized = true;
566   }
567 
568   /**
569    * Allow to (re)set finalize agent.
570    *
571    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
572    */
573   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
574     finalizeAgent = addr;
575 
576     // Don't allow setting bad agent
577     if(!finalizeAgent.isFinalizeAgent()) {
578       throw;
579     }
580   }
581 
582   /**
583    * Allow crowdsale owner to close early or extend the crowdsale.
584    *
585    * This is useful e.g. for a manual soft cap implementation:
586    * - after X amount is reached determine manual closing
587    *
588    * This may put the crowdsale to an invalid state,
589    * but we trust owners know what they are doing.
590    *
591    */
592   function setEndsAt(uint time) onlyOwner {
593 
594     if(now > time) {
595       throw; // Don't change past
596     }
597 
598     if(startsAt > time) {
599       throw; // Prevent human mistakes
600     }
601 
602     endsAt = time;
603     EndsAtChanged(endsAt);
604   }
605 
606   /**
607    * Allow to (re)set pricing strategy.
608    *
609    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
610    */
611   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
612     pricingStrategy = _pricingStrategy;
613 
614     // Don't allow setting bad agent
615     if(!pricingStrategy.isPricingStrategy()) {
616       throw;
617     }
618   }
619 
620   /**
621    * Allow to change the team multisig address in the case of emergency.
622    *
623    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
624    * (we have done only few test transactions). After the crowdsale is going
625    * then multisig address stays locked for the safety reasons.
626    */
627   function setMultisig(address addr) public onlyOwner {
628 
629     // Change
630     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
631       throw;
632     }
633 
634     multisigWallet = addr;
635   }
636 
637   /**
638    * Allow load refunds back on the contract for the refunding.
639    *
640    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
641    */
642   function loadRefund() public payable inState(State.Failure) {
643     if(msg.value == 0) throw;
644     loadedRefund = loadedRefund.plus(msg.value);
645   }
646 
647   /**
648    * Investors can claim refund.
649    *
650    * Note that any refunds from proxy buyers should be handled separately,
651    * and not through this contract.
652    */
653   function refund() public inState(State.Refunding) {
654     uint256 weiValue = investedAmountOf[msg.sender];
655     if (weiValue == 0) throw;
656     investedAmountOf[msg.sender] = 0;
657     weiRefunded = weiRefunded.plus(weiValue);
658     Refund(msg.sender, weiValue);
659     if (!msg.sender.send(weiValue)) throw;
660   }
661 
662   /**
663    * @return true if the crowdsale has raised enough money to be a successful.
664    */
665   function isMinimumGoalReached() public constant returns (bool reached) {
666     return weiRaised >= minimumFundingGoal;
667   }
668 
669   /**
670    * Check if the contract relationship looks good.
671    */
672   function isFinalizerSane() public constant returns (bool sane) {
673     return finalizeAgent.isSane();
674   }
675 
676   /**
677    * Check if the contract relationship looks good.
678    */
679   function isPricingSane() public constant returns (bool sane) {
680     return pricingStrategy.isSane(address(this));
681   }
682 
683   /**
684    * Crowdfund state machine management.
685    *
686    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
687    */
688   function getState() public constant returns (State) {
689     if(finalized) return State.Finalized;
690     else if (address(finalizeAgent) == 0) return State.Preparing;
691     else if (!finalizeAgent.isSane()) return State.Preparing;
692     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
693     else if (block.timestamp < startsAt) return State.PreFunding;
694     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
695     else if (isMinimumGoalReached()) return State.Success;
696     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
697     else return State.Failure;
698   }
699 
700   /** This is for manual testing of multisig wallet interaction */
701   function setOwnerTestValue(uint val) onlyOwner {
702     ownerTestValue = val;
703   }
704 
705   /**
706    * Allow addresses to do early participation.
707    *
708    * TODO: Fix spelling error in the name
709    */
710   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
711     earlyParticipantWhitelist[addr] = status;
712     Whitelisted(addr, status);
713   }
714 
715 
716   /** Interface marker. */
717   function isCrowdsale() public constant returns (bool) {
718     return true;
719   }
720 
721   //
722   // Modifiers
723   //
724 
725   /** Modified allowing execution only if the crowdsale is currently running.  */
726   modifier inState(State state) {
727     if(getState() != state) throw;
728     _;
729   }
730 
731 
732   //
733   // Abstract functions
734   //
735 
736   /**
737    * Check if the current invested breaks our cap rules.
738    *
739    *
740    * The child contract must define their own cap setting rules.
741    * We allow a lot of flexibility through different capping strategies (ETH, token count)
742    * Called from invest().
743    *
744    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
745    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
746    * @param weiRaisedTotal What would be our total raised balance after this transaction
747    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
748    *
749    * @return true if taking this investment would break our cap rules
750    */
751   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
752 
753   /**
754    * Check if the current crowdsale is full and we can no longer sell any tokens.
755    */
756   function isCrowdsaleFull() public constant returns (bool);
757 
758   /**
759    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
760    */
761   function assignTokens(address receiver, uint tokenAmount) internal;
762 }
763 
764 
765 /**
766  * A mixin that is selling tokens from a preallocated pool
767  *
768  * - Tokens have precreated supply "premined"
769  *
770  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
771  *
772  * - The mixin does not implement buy entry point.
773  *
774  */
775 contract AllocatedCrowdsaleMixin is CrowdsaleBase {
776 
777   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
778   address public beneficiary;
779 
780   /**
781    * @param _beneficiary The account who has performed approve() to allocate tokens for the token sale.
782    *
783    */
784   function AllocatedCrowdsaleMixin(address _beneficiary) {
785     beneficiary = _beneficiary;
786   }
787 
788   /**
789    * Called from invest() to confirm if the curret investment does not break our cap rule.
790    */
791   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
792     if(tokenAmount > getTokensLeft()) {
793       return true;
794     } else {
795       return false;
796     }
797   }
798 
799   /**
800    * We are sold out when our approve pool becomes empty.
801    */
802   function isCrowdsaleFull() public constant returns (bool) {
803     return getTokensLeft() == 0;
804   }
805 
806   /**
807    * Get the amount of unsold tokens allocated to this contract;
808    */
809   function getTokensLeft() public constant returns (uint) {
810     return token.allowance(owner, this);
811   }
812 
813   /**
814    * Transfer tokens from approve() pool to the buyer.
815    *
816    * Use approve() given to this crowdsale to distribute the tokens.
817    */
818   function assignTokens(address receiver, uint tokenAmount) internal {
819     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
820   }
821 }
822 
823 /**
824  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
825  *
826  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
827  */
828 
829 
830 
831 
832 
833 
834 
835 
836 
837 /**
838  * Abstract base contract for token sales with the default buy entry points.
839  *
840  * Handle
841  * - start and end dates
842  * - accepting investments
843  * - minimum funding goal and refund
844  * - various statistics during the crowdfund
845  * - different pricing strategies
846  * - different investment policies (require server side customer id, allow only whitelisted addresses)
847  *
848  * Does not Handle
849  *
850  * - Token allocation (minting vs. transfer)
851  * - Cap rules
852  *
853  */
854 contract Crowdsale is CrowdsaleBase {
855 
856   /* Do we need to have unique contributor id for each customer */
857   bool public requireCustomerId;
858 
859   /**
860     * Do we verify that contributor has been cleared on the server side (accredited investors only).
861     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
862     */
863   bool public requiredSignedAddress;
864 
865   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
866   address public signerAddress;
867 
868   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
869   }
870 
871   /**
872    * Preallocate tokens for the early investors.
873    *
874    * Preallocated tokens have been sold before the actual crowdsale opens.
875    * This function mints the tokens and moves the crowdsale needle.
876    *
877    * Investor count is not handled; it is assumed this goes for multiple investors
878    * and the token distribution happens outside the smart contract flow.
879    *
880    * No money is exchanged, as the crowdsale team already have received the payment.
881    *
882    * @param fullTokens tokens as full tokens - decimal places added internally
883    * @param weiPrice Price of a single full token in wei
884    *
885    */
886   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
887 
888     uint tokenAmount = fullTokens * 10**token.decimals();
889     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
890 
891     weiRaised = weiRaised.plus(weiAmount);
892     tokensSold = tokensSold.plus(tokenAmount);
893 
894     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
895     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
896 
897     assignTokens(receiver, tokenAmount);
898 
899     // Tell us invest was success
900     Invested(receiver, weiAmount, tokenAmount, 0);
901   }
902 
903   /**
904    * Allow anonymous contributions to this crowdsale.
905    */
906   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
907      bytes32 hash = sha256(addr);
908      if (ecrecover(hash, v, r, s) != signerAddress) throw;
909      if(customerId == 0) throw;  // UUIDv4 sanity check
910      investInternal(addr, customerId);
911   }
912 
913   /**
914    * Track who is the customer making the payment so we can send thank you email.
915    */
916   function investWithCustomerId(address addr, uint128 customerId) public payable {
917     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
918     if(customerId == 0) throw;  // UUIDv4 sanity check
919     investInternal(addr, customerId);
920   }
921 
922   /**
923    * Allow anonymous contributions to this crowdsale.
924    */
925   function invest(address addr) public payable {
926     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
927     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
928     investInternal(addr, 0);
929   }
930 
931   /**
932    * Invest to tokens, recognize the payer and clear his address.
933    *
934    */
935   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
936     investWithSignedAddress(msg.sender, customerId, v, r, s);
937   }
938 
939   /**
940    * Invest to tokens, recognize the payer.
941    *
942    */
943   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
944     // see customerid.py
945     if (bytes1(sha3(customerId)) != checksum) throw;
946     investWithCustomerId(msg.sender, customerId);
947   }
948 
949   /**
950    * Legacy API signature.
951    */
952   function buyWithCustomerId(uint128 customerId) public payable {
953     investWithCustomerId(msg.sender, customerId);
954   }
955 
956   /**
957    * The basic entry point to participate the crowdsale process.
958    *
959    * Pay for funding, get invested tokens back in the sender address.
960    */
961   function buy() public payable {
962     invest(msg.sender);
963   }
964   function() payable {
965     buy();
966   }
967 
968   /**
969    * Set policy do we need to have server-side customer ids for the investments.
970    *
971    */
972   function setRequireCustomerId(bool value) onlyOwner {
973     requireCustomerId = value;
974     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
975   }
976 
977   /**
978    * Set policy if all investors must be cleared on the server side first.
979    *
980    * This is e.g. for the accredited investor clearing.
981    *
982    */
983   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
984     requiredSignedAddress = value;
985     signerAddress = _signerAddress;
986     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
987   }
988 
989 }
990 
991 
992 
993 /**
994  * An implementation of allocated crowdsale.
995  *
996  * This implementation does not have KYC logic (vs. KYCCrowdsale).
997  *
998  */
999 contract AllocatedCrowdsale is AllocatedCrowdsaleMixin, Crowdsale {
1000 
1001   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) AllocatedCrowdsaleMixin(_beneficiary) {
1002 
1003   }
1004 
1005 }