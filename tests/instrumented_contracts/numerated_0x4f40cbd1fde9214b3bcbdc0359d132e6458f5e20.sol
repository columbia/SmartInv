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
23  * Safe unsigned safe math.
24  *
25  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
26  *
27  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
28  *
29  * Maintained here until merged to mainline zeppelin-solidity.
30  *
31  */
32 library SafeMathLib {
33 
34   function times(uint a, uint b) returns (uint) {
35     uint c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function minus(uint a, uint b) returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function plus(uint a, uint b) returns (uint) {
46     uint c = a + b;
47     assert(c>=a);
48     return c;
49   }
50 
51 }
52 
53 /**
54  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
55  *
56  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
57  */
58 
59 
60 /**
61  * Interface for defining crowdsale pricing.
62  */
63 contract PricingStrategy {
64 
65   /** Interface declaration. */
66   function isPricingStrategy() public constant returns (bool) {
67     return true;
68   }
69 
70   /** Self check if all references are correctly set.
71    *
72    * Checks that pricing strategy matches crowdsale parameters.
73    */
74   function isSane(address crowdsale) public constant returns (bool) {
75     return true;
76   }
77 
78   /**
79    * @dev Pricing tells if this is a presale purchase or not.
80      @param purchaser Address of the purchaser
81      @return False by default, true if a presale purchaser
82    */
83   function isPresalePurchase(address purchaser) public constant returns (bool) {
84     return false;
85   }
86 
87   /**
88    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
89    *
90    *
91    * @param value - What is the value of the transaction send in as wei
92    * @param tokensSold - how much tokens have been sold this far
93    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
94    * @param msgSender - who is the investor of this transaction
95    * @param decimals - how many decimal units the token has
96    * @return Amount of tokens the investor receives
97    */
98   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
99 }
100 
101 /**
102  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
103  *
104  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
105  */
106 
107 
108 /**
109  * Finalize agent defines what happens at the end of succeseful crowdsale.
110  *
111  * - Allocate tokens for founders, bounties and community
112  * - Make tokens transferable
113  * - etc.
114  */
115 contract FinalizeAgent {
116 
117   function isFinalizeAgent() public constant returns(bool) {
118     return true;
119   }
120 
121   /** Return true if we can run finalizeCrowdsale() properly.
122    *
123    * This is a safety check function that doesn't allow crowdsale to begin
124    * unless the finalizer has been set up properly.
125    */
126   function isSane() public constant returns (bool);
127 
128   /** Called once by crowdsale finalize() if the sale was success. */
129   function finalizeCrowdsale();
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
187  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
188  *
189  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
190  */
191 
192 
193 
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201   address public owner;
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) onlyOwner {
227     require(newOwner != address(0));      
228     owner = newOwner;
229   }
230 
231 }
232 
233 
234 /*
235  * Haltable
236  *
237  * Abstract contract that allows children to implement an
238  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
239  *
240  *
241  * Originally envisioned in FirstBlood ICO contract.
242  */
243 contract Haltable is Ownable {
244   bool public halted;
245 
246   modifier stopInEmergency {
247     if (halted) throw;
248     _;
249   }
250 
251   modifier stopNonOwnersInEmergency {
252     if (halted && msg.sender != owner) throw;
253     _;
254   }
255 
256   modifier onlyInEmergency {
257     if (!halted) throw;
258     _;
259   }
260 
261   // called by the owner on emergency, triggers stopped state
262   function halt() external onlyOwner {
263     halted = true;
264   }
265 
266   // called by the owner on end of emergency, returns to normal state
267   function unhalt() external onlyOwner onlyInEmergency {
268     halted = false;
269   }
270 
271 }
272 
273 
274 
275 
276 
277 
278 
279 /**
280  * Crowdsale state machine without buy functionality.
281  *
282  * Implements basic state machine logic, but leaves out all buy functions,
283  * so that subclasses can implement their own buying logic.
284  *
285  *
286  * For the default buy() implementation see Crowdsale.sol.
287  */
288 contract CrowdsaleBase is Haltable {
289 
290   /* Max investment count when we are still allowed to change the multisig address */
291   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
292 
293   using SafeMathLib for uint;
294 
295   /* The token we are selling */
296   FractionalERC20 public token;
297 
298   /* How we are going to price our offering */
299   PricingStrategy public pricingStrategy;
300 
301   /* Post-success callback */
302   FinalizeAgent public finalizeAgent;
303 
304   /* tokens will be transfered from this address */
305   address public multisigWallet;
306 
307   /* if the funding goal is not reached, investors may withdraw their funds */
308   uint public minimumFundingGoal;
309 
310   /* the UNIX timestamp start date of the crowdsale */
311   uint public startsAt;
312 
313   /* the UNIX timestamp end date of the crowdsale */
314   uint public endsAt;
315 
316   /* the number of tokens already sold through this contract*/
317   uint public tokensSold = 0;
318 
319   /* How many wei of funding we have raised */
320   uint public weiRaised = 0;
321 
322   /* Calculate incoming funds from presale contracts and addresses */
323   uint public presaleWeiRaised = 0;
324 
325   /* How many distinct addresses have invested */
326   uint public investorCount = 0;
327 
328   /* How much wei we have returned back to the contract after a failed crowdfund. */
329   uint public loadedRefund = 0;
330 
331   /* How much wei we have given back to investors.*/
332   uint public weiRefunded = 0;
333 
334   /* Has this crowdsale been finalized */
335   bool public finalized;
336 
337   /** How much ETH each address has invested to this crowdsale */
338   mapping (address => uint256) public investedAmountOf;
339 
340   /** How much tokens this crowdsale has credited for each investor address */
341   mapping (address => uint256) public tokenAmountOf;
342 
343   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
344   mapping (address => bool) public earlyParticipantWhitelist;
345 
346   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
347   uint public ownerTestValue;
348 
349   /** State machine
350    *
351    * - Preparing: All contract initialization calls and variables have not been set yet
352    * - Prefunding: We have not passed start time yet
353    * - Funding: Active crowdsale
354    * - Success: Minimum funding goal reached
355    * - Failure: Minimum funding goal not reached before ending time
356    * - Finalized: The finalized has been called and succesfully executed
357    * - Refunding: Refunds are loaded on the contract for reclaim.
358    */
359   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
360 
361   // A new investment was made
362   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
363 
364   // Refund was processed for a contributor
365   event Refund(address investor, uint weiAmount);
366 
367   // The rules were changed what kind of investments we accept
368   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
369 
370   // Address early participation whitelist status changed
371   event Whitelisted(address addr, bool status);
372 
373   // Crowdsale end time has been changed
374   event EndsAtChanged(uint newEndsAt);
375 
376   State public testState;
377 
378   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
379 
380     owner = msg.sender;
381 
382     token = FractionalERC20(_token);
383 
384     setPricingStrategy(_pricingStrategy);
385 
386     multisigWallet = _multisigWallet;
387     if(multisigWallet == 0) {
388         throw;
389     }
390 
391     if(_start == 0) {
392         throw;
393     }
394 
395     startsAt = _start;
396 
397     if(_end == 0) {
398         throw;
399     }
400 
401     endsAt = _end;
402 
403     // Don't mess the dates
404     if(startsAt >= endsAt) {
405         throw;
406     }
407 
408     // Minimum funding goal can be zero
409     minimumFundingGoal = _minimumFundingGoal;
410   }
411 
412   /**
413    * Don't expect to just send in money and get tokens.
414    */
415   function() payable {
416     throw;
417   }
418 
419   /**
420    * Make an investment.
421    *
422    * Crowdsale must be running for one to invest.
423    * We must have not pressed the emergency brake.
424    *
425    * @param receiver The Ethereum address who receives the tokens
426    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
427    *
428    * @return tokenAmount How mony tokens were bought
429    */
430   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
431 
432     // Determine if it's a good time to accept investment from this participant
433     if(getState() == State.PreFunding) {
434       // Are we whitelisted for early deposit
435       if(!earlyParticipantWhitelist[receiver]) {
436         throw;
437       }
438     } else if(getState() == State.Funding) {
439       // Retail participants can only come in when the crowdsale is running
440       // pass
441     } else {
442       // Unwanted state
443       throw;
444     }
445 
446     uint weiAmount = msg.value;
447 
448     // Account presale sales separately, so that they do not count against pricing tranches
449     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
450 
451     // Dust transaction
452     require(tokenAmount != 0);
453 
454     if(investedAmountOf[receiver] == 0) {
455        // A new investor
456        investorCount++;
457     }
458 
459     // Update investor
460     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
461     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
462 
463     // Update totals
464     weiRaised = weiRaised.plus(weiAmount);
465     tokensSold = tokensSold.plus(tokenAmount);
466 
467     if(pricingStrategy.isPresalePurchase(receiver)) {
468         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
469     }
470 
471     // Check that we did not bust the cap
472     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
473 
474     assignTokens(receiver, tokenAmount);
475 
476     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
477     if(!multisigWallet.send(weiAmount)) throw;
478 
479     // Tell us invest was success
480     Invested(receiver, weiAmount, tokenAmount, customerId);
481 
482     return tokenAmount;
483   }
484 
485   /**
486    * Finalize a succcesful crowdsale.
487    *
488    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
489    */
490   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
491 
492     // Already finalized
493     if(finalized) {
494       throw;
495     }
496 
497     // Finalizing is optional. We only call it if we are given a finalizing agent.
498     if(address(finalizeAgent) != 0) {
499       finalizeAgent.finalizeCrowdsale();
500     }
501 
502     finalized = true;
503   }
504 
505   /**
506    * Allow to (re)set finalize agent.
507    *
508    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
509    */
510   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
511     finalizeAgent = addr;
512 
513     // Don't allow setting bad agent
514     if(!finalizeAgent.isFinalizeAgent()) {
515       throw;
516     }
517   }
518 
519   /**
520    * Allow crowdsale owner to close early or extend the crowdsale.
521    *
522    * This is useful e.g. for a manual soft cap implementation:
523    * - after X amount is reached determine manual closing
524    *
525    * This may put the crowdsale to an invalid state,
526    * but we trust owners know what they are doing.
527    *
528    */
529   function setEndsAt(uint time) onlyOwner {
530 
531     if(now > time) {
532       throw; // Don't change past
533     }
534 
535     if(startsAt > time) {
536       throw; // Prevent human mistakes
537     }
538 
539     endsAt = time;
540     EndsAtChanged(endsAt);
541   }
542 
543   /**
544    * Allow to (re)set pricing strategy.
545    *
546    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
547    */
548   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
549     pricingStrategy = _pricingStrategy;
550 
551     // Don't allow setting bad agent
552     if(!pricingStrategy.isPricingStrategy()) {
553       throw;
554     }
555   }
556 
557   /**
558    * Allow to change the team multisig address in the case of emergency.
559    *
560    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
561    * (we have done only few test transactions). After the crowdsale is going
562    * then multisig address stays locked for the safety reasons.
563    */
564   function setMultisig(address addr) public onlyOwner {
565 
566     // Change
567     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
568       throw;
569     }
570 
571     multisigWallet = addr;
572   }
573 
574   /**
575    * Allow load refunds back on the contract for the refunding.
576    *
577    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
578    */
579   function loadRefund() public payable inState(State.Failure) {
580     if(msg.value == 0) throw;
581     loadedRefund = loadedRefund.plus(msg.value);
582   }
583 
584   /**
585    * Investors can claim refund.
586    *
587    * Note that any refunds from proxy buyers should be handled separately,
588    * and not through this contract.
589    */
590   function refund() public inState(State.Refunding) {
591     uint256 weiValue = investedAmountOf[msg.sender];
592     if (weiValue == 0) throw;
593     investedAmountOf[msg.sender] = 0;
594     weiRefunded = weiRefunded.plus(weiValue);
595     Refund(msg.sender, weiValue);
596     if (!msg.sender.send(weiValue)) throw;
597   }
598 
599   /**
600    * @return true if the crowdsale has raised enough money to be a successful.
601    */
602   function isMinimumGoalReached() public constant returns (bool reached) {
603     return weiRaised >= minimumFundingGoal;
604   }
605 
606   /**
607    * Check if the contract relationship looks good.
608    */
609   function isFinalizerSane() public constant returns (bool sane) {
610     return finalizeAgent.isSane();
611   }
612 
613   /**
614    * Check if the contract relationship looks good.
615    */
616   function isPricingSane() public constant returns (bool sane) {
617     return pricingStrategy.isSane(address(this));
618   }
619 
620   /**
621    * Crowdfund state machine management.
622    *
623    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
624    */
625   function getState() public constant returns (State) {
626     if(finalized) return State.Finalized;
627     else if (address(finalizeAgent) == 0) return State.Preparing;
628     else if (!finalizeAgent.isSane()) return State.Preparing;
629     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
630     else if (block.timestamp < startsAt) return State.PreFunding;
631     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
632     else if (isMinimumGoalReached()) return State.Success;
633     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
634     else return State.Failure;
635   }
636 
637   /** This is for manual testing of multisig wallet interaction */
638   function setOwnerTestValue(uint val) onlyOwner {
639     ownerTestValue = val;
640   }
641 
642   /**
643    * Allow addresses to do early participation.
644    *
645    * TODO: Fix spelling error in the name
646    */
647   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
648     earlyParticipantWhitelist[addr] = status;
649     Whitelisted(addr, status);
650   }
651 
652 
653   /** Interface marker. */
654   function isCrowdsale() public constant returns (bool) {
655     return true;
656   }
657 
658   //
659   // Modifiers
660   //
661 
662   /** Modified allowing execution only if the crowdsale is currently running.  */
663   modifier inState(State state) {
664     if(getState() != state) throw;
665     _;
666   }
667 
668 
669   //
670   // Abstract functions
671   //
672 
673   /**
674    * Check if the current invested breaks our cap rules.
675    *
676    *
677    * The child contract must define their own cap setting rules.
678    * We allow a lot of flexibility through different capping strategies (ETH, token count)
679    * Called from invest().
680    *
681    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
682    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
683    * @param weiRaisedTotal What would be our total raised balance after this transaction
684    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
685    *
686    * @return true if taking this investment would break our cap rules
687    */
688   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
689 
690   /**
691    * Check if the current crowdsale is full and we can no longer sell any tokens.
692    */
693   function isCrowdsaleFull() public constant returns (bool);
694 
695   /**
696    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
697    */
698   function assignTokens(address receiver, uint tokenAmount) internal;
699 }
700 
701 
702 
703 /**
704  * Abstract base contract for token sales with the default buy entry points.
705  *
706  * Handle
707  * - start and end dates
708  * - accepting investments
709  * - minimum funding goal and refund
710  * - various statistics during the crowdfund
711  * - different pricing strategies
712  * - different investment policies (require server side customer id, allow only whitelisted addresses)
713  *
714  * Does not Handle
715  *
716  * - Token allocation (minting vs. transfer)
717  * - Cap rules
718  *
719  */
720 contract Crowdsale is CrowdsaleBase {
721 
722   /* Do we need to have unique contributor id for each customer */
723   bool public requireCustomerId;
724 
725   /**
726     * Do we verify that contributor has been cleared on the server side (accredited investors only).
727     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
728     */
729   bool public requiredSignedAddress;
730 
731   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
732   address public signerAddress;
733 
734   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
735   }
736 
737   /**
738    * Preallocate tokens for the early investors.
739    *
740    * Preallocated tokens have been sold before the actual crowdsale opens.
741    * This function mints the tokens and moves the crowdsale needle.
742    *
743    * Investor count is not handled; it is assumed this goes for multiple investors
744    * and the token distribution happens outside the smart contract flow.
745    *
746    * No money is exchanged, as the crowdsale team already have received the payment.
747    *
748    * @param fullTokens tokens as full tokens - decimal places added internally
749    * @param weiPrice Price of a single full token in wei
750    *
751    */
752   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
753 
754     uint tokenAmount = fullTokens * 10**token.decimals();
755     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
756 
757     weiRaised = weiRaised.plus(weiAmount);
758     tokensSold = tokensSold.plus(tokenAmount);
759 
760     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
761     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
762 
763     assignTokens(receiver, tokenAmount);
764 
765     // Tell us invest was success
766     Invested(receiver, weiAmount, tokenAmount, 0);
767   }
768 
769   /**
770    * Allow anonymous contributions to this crowdsale.
771    */
772   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
773      bytes32 hash = sha256(addr);
774      if (ecrecover(hash, v, r, s) != signerAddress) throw;
775      if(customerId == 0) throw;  // UUIDv4 sanity check
776      investInternal(addr, customerId);
777   }
778 
779   /**
780    * Track who is the customer making the payment so we can send thank you email.
781    */
782   function investWithCustomerId(address addr, uint128 customerId) public payable {
783     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
784     if(customerId == 0) throw;  // UUIDv4 sanity check
785     investInternal(addr, customerId);
786   }
787 
788   /**
789    * Allow anonymous contributions to this crowdsale.
790    */
791   function invest(address addr) public payable {
792     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
793     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
794     investInternal(addr, 0);
795   }
796 
797   /**
798    * Invest to tokens, recognize the payer and clear his address.
799    *
800    */
801   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
802     investWithSignedAddress(msg.sender, customerId, v, r, s);
803   }
804 
805   /**
806    * Invest to tokens, recognize the payer.
807    *
808    */
809   function buyWithCustomerId(uint128 customerId) public payable {
810     investWithCustomerId(msg.sender, customerId);
811   }
812 
813   /**
814    * The basic entry point to participate the crowdsale process.
815    *
816    * Pay for funding, get invested tokens back in the sender address.
817    */
818   function buy() public payable {
819     invest(msg.sender);
820   }
821 
822   /**
823    * Buy tokens as generic fallback
824    */
825   function() payable {
826     invest(msg.sender);
827   }
828 
829   /**
830    * Set policy do we need to have server-side customer ids for the investments.
831    *
832    */
833   function setRequireCustomerId(bool value) onlyOwner {
834     requireCustomerId = value;
835     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
836   }
837 
838   /**
839    * Set policy if all investors must be cleared on the server side first.
840    *
841    * This is e.g. for the accredited investor clearing.
842    *
843    */
844   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
845     requiredSignedAddress = value;
846     signerAddress = _signerAddress;
847     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
848   }
849 
850 }
851 
852 /**
853  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
854  *
855  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
856  */
857 
858 
859 
860 /**
861  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
862  *
863  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
864  */
865 
866 
867 
868 
869 
870 
871 
872 
873 
874 /**
875  * @title SafeMath
876  * @dev Math operations with safety checks that throw on error
877  */
878 library SafeMath {
879   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
880     uint256 c = a * b;
881     assert(a == 0 || c / a == b);
882     return c;
883   }
884 
885   function div(uint256 a, uint256 b) internal constant returns (uint256) {
886     // assert(b > 0); // Solidity automatically throws when dividing by 0
887     uint256 c = a / b;
888     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
889     return c;
890   }
891 
892   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
893     assert(b <= a);
894     return a - b;
895   }
896 
897   function add(uint256 a, uint256 b) internal constant returns (uint256) {
898     uint256 c = a + b;
899     assert(c >= a);
900     return c;
901   }
902 }
903 
904 
905 
906 /**
907  * @title Basic token
908  * @dev Basic version of StandardToken, with no allowances. 
909  */
910 contract BasicToken is ERC20Basic {
911   using SafeMath for uint256;
912 
913   mapping(address => uint256) balances;
914 
915   /**
916   * @dev transfer token for a specified address
917   * @param _to The address to transfer to.
918   * @param _value The amount to be transferred.
919   */
920   function transfer(address _to, uint256 _value) returns (bool) {
921     balances[msg.sender] = balances[msg.sender].sub(_value);
922     balances[_to] = balances[_to].add(_value);
923     Transfer(msg.sender, _to, _value);
924     return true;
925   }
926 
927   /**
928   * @dev Gets the balance of the specified address.
929   * @param _owner The address to query the the balance of. 
930   * @return An uint256 representing the amount owned by the passed address.
931   */
932   function balanceOf(address _owner) constant returns (uint256 balance) {
933     return balances[_owner];
934   }
935 
936 }
937 
938 
939 
940 
941 /**
942  * @title Standard ERC20 token
943  *
944  * @dev Implementation of the basic standard token.
945  * @dev https://github.com/ethereum/EIPs/issues/20
946  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
947  */
948 contract StandardToken is ERC20, BasicToken {
949 
950   mapping (address => mapping (address => uint256)) allowed;
951 
952 
953   /**
954    * @dev Transfer tokens from one address to another
955    * @param _from address The address which you want to send tokens from
956    * @param _to address The address which you want to transfer to
957    * @param _value uint256 the amout of tokens to be transfered
958    */
959   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
960     var _allowance = allowed[_from][msg.sender];
961 
962     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
963     // require (_value <= _allowance);
964 
965     balances[_to] = balances[_to].add(_value);
966     balances[_from] = balances[_from].sub(_value);
967     allowed[_from][msg.sender] = _allowance.sub(_value);
968     Transfer(_from, _to, _value);
969     return true;
970   }
971 
972   /**
973    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
974    * @param _spender The address which will spend the funds.
975    * @param _value The amount of tokens to be spent.
976    */
977   function approve(address _spender, uint256 _value) returns (bool) {
978 
979     // To change the approve amount you first have to reduce the addresses`
980     //  allowance to zero by calling `approve(_spender, 0)` if it is not
981     //  already 0 to mitigate the race condition described here:
982     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
983     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
984 
985     allowed[msg.sender][_spender] = _value;
986     Approval(msg.sender, _spender, _value);
987     return true;
988   }
989 
990   /**
991    * @dev Function to check the amount of tokens that an owner allowed to a spender.
992    * @param _owner address The address which owns the funds.
993    * @param _spender address The address which will spend the funds.
994    * @return A uint256 specifing the amount of tokens still available for the spender.
995    */
996   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
997     return allowed[_owner][_spender];
998   }
999 
1000 }
1001 
1002 
1003 
1004 /**
1005  * Standard EIP-20 token with an interface marker.
1006  *
1007  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
1008  *
1009  */
1010 contract StandardTokenExt is StandardToken {
1011 
1012   /* Interface declaration */
1013   function isToken() public constant returns (bool weAre) {
1014     return true;
1015   }
1016 }
1017 
1018 
1019 
1020 
1021 /**
1022  * A token that can increase its supply by another contract.
1023  *
1024  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1025  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1026  *
1027  */
1028 contract MintableToken is StandardTokenExt, Ownable {
1029 
1030   using SafeMathLib for uint;
1031 
1032   bool public mintingFinished = false;
1033 
1034   /** List of agents that are allowed to create new tokens */
1035   mapping (address => bool) public mintAgents;
1036 
1037   event MintingAgentChanged(address addr, bool state);
1038   event Minted(address receiver, uint amount);
1039 
1040   /**
1041    * Create new tokens and allocate them to an address..
1042    *
1043    * Only callably by a crowdsale contract (mint agent).
1044    */
1045   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1046     totalSupply = totalSupply.plus(amount);
1047     balances[receiver] = balances[receiver].plus(amount);
1048 
1049     // This will make the mint transaction apper in EtherScan.io
1050     // We can remove this after there is a standardized minting event
1051     Transfer(0, receiver, amount);
1052   }
1053 
1054   /**
1055    * Owner can allow a crowdsale contract to mint new tokens.
1056    */
1057   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1058     mintAgents[addr] = state;
1059     MintingAgentChanged(addr, state);
1060   }
1061 
1062   modifier onlyMintAgent() {
1063     // Only crowdsale contracts are allowed to mint new tokens
1064     if(!mintAgents[msg.sender]) {
1065         throw;
1066     }
1067     _;
1068   }
1069 
1070   /** Make sure we are not done yet. */
1071   modifier canMint() {
1072     if(mintingFinished) throw;
1073     _;
1074   }
1075 }
1076 
1077 
1078 /**
1079  * ICO crowdsale contract that is capped by amout of tokens.
1080  *
1081  * - Tokens are dynamically created during the crowdsale
1082  *
1083  *
1084  */
1085 contract MintedTokenCappedCrowdsale is Crowdsale {
1086 
1087   /* Maximum amount of tokens this crowdsale can sell. */
1088   uint public maximumSellableTokens;
1089 
1090   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
1091     maximumSellableTokens = _maximumSellableTokens;
1092   }
1093 
1094   /**
1095    * Called from invest() to confirm if the curret investment does not break our cap rule.
1096    */
1097   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1098     return tokensSoldTotal > maximumSellableTokens;
1099   }
1100 
1101   function isCrowdsaleFull() public constant returns (bool) {
1102     return tokensSold >= maximumSellableTokens;
1103   }
1104 
1105   /**
1106    * Dynamically create tokens and assign them to the investor.
1107    */
1108   function assignTokens(address receiver, uint tokenAmount) internal {
1109     MintableToken mintableToken = MintableToken(token);
1110     mintableToken.mint(receiver, tokenAmount);
1111   }
1112 }