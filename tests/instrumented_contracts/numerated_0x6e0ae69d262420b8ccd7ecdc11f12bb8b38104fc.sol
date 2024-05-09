1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
42  *
43  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
44  */
45 
46 
47 /**
48  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
49  *
50  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
51  */
52 
53 
54 /**
55  * Safe unsigned safe math.
56  *
57  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
58  *
59  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
60  *
61  * Maintained here until merged to mainline zeppelin-solidity.
62  *
63  */
64 library SafeMathLib {
65 
66   function times(uint a, uint b) returns (uint) {
67     uint c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function minus(uint a, uint b) returns (uint) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function plus(uint a, uint b) returns (uint) {
78     uint c = a + b;
79     assert(c>=a);
80     return c;
81   }
82 
83 }
84 
85 /**
86  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
87  *
88  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
89  */
90 
91 
92 /**
93  * Interface for defining crowdsale pricing.
94  */
95 contract PricingStrategy {
96 
97   /** Interface declaration. */
98   function isPricingStrategy() public constant returns (bool) {
99     return true;
100   }
101 
102   /** Self check if all references are correctly set.
103    *
104    * Checks that pricing strategy matches crowdsale parameters.
105    */
106   function isSane(address crowdsale) public constant returns (bool) {
107     return true;
108   }
109 
110   /**
111    * @dev Pricing tells if this is a presale purchase or not.
112      @param purchaser Address of the purchaser
113      @return False by default, true if a presale purchaser
114    */
115   function isPresalePurchase(address purchaser) public constant returns (bool) {
116     return false;
117   }
118 
119   /**
120    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
121    *
122    *
123    * @param value - What is the value of the transaction send in as wei
124    * @param tokensSold - how much tokens have been sold this far
125    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
126    * @param msgSender - who is the investor of this transaction
127    * @param decimals - how many decimal units the token has
128    * @return Amount of tokens the investor receives
129    */
130   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
131 }
132 
133 /**
134  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
135  *
136  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
137  */
138 
139 
140 /**
141  * Finalize agent defines what happens at the end of succeseful crowdsale.
142  *
143  * - Allocate tokens for founders, bounties and community
144  * - Make tokens transferable
145  * - etc.
146  */
147 contract FinalizeAgent {
148 
149   function isFinalizeAgent() public constant returns(bool) {
150     return true;
151   }
152 
153   /** Return true if we can run finalizeCrowdsale() properly.
154    *
155    * This is a safety check function that doesn't allow crowdsale to begin
156    * unless the finalizer has been set up properly.
157    */
158   function isSane() public constant returns (bool);
159 
160   /** Called once by crowdsale finalize() if the sale was success. */
161   function finalizeCrowdsale();
162 
163 }
164 
165 /**
166  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
167  *
168  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
169  */
170 
171 
172 
173 
174 
175 
176 /**
177  * @title ERC20Basic
178  * @dev Simpler version of ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/179
180  */
181 contract ERC20Basic {
182   uint256 public totalSupply;
183   function balanceOf(address who) constant returns (uint256);
184   function transfer(address to, uint256 value) returns (bool);
185   event Transfer(address indexed from, address indexed to, uint256 value);
186 }
187 
188 
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) constant returns (uint256);
196   function transferFrom(address from, address to, uint256 value) returns (bool);
197   function approve(address spender, uint256 value) returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 
202 /**
203  * A token that defines fractional units as decimals.
204  */
205 contract FractionalERC20 is ERC20 {
206 
207   uint public decimals;
208 
209 }
210 
211 /**
212  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
213  *
214  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
215  */
216 
217 
218 /**
219  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
220  *
221  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
222  */
223 
224 
225 
226 
227 /**
228  * @title Ownable
229  * @dev The Ownable contract has an owner address, and provides basic authorization control
230  * functions, this simplifies the implementation of "user permissions".
231  */
232 contract Ownable {
233   address public owner;
234 
235 
236   /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   function Ownable() {
241     owner = msg.sender;
242   }
243 
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) onlyOwner {
259     require(newOwner != address(0));      
260     owner = newOwner;
261   }
262 
263 }
264 
265 
266 /*
267  * Haltable
268  *
269  * Abstract contract that allows children to implement an
270  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
271  *
272  *
273  * Originally envisioned in FirstBlood ICO contract.
274  */
275 contract Haltable is Ownable {
276   bool public halted;
277 
278   modifier stopInEmergency {
279     if (halted) throw;
280     _;
281   }
282 
283   modifier stopNonOwnersInEmergency {
284     if (halted && msg.sender != owner) throw;
285     _;
286   }
287 
288   modifier onlyInEmergency {
289     if (!halted) throw;
290     _;
291   }
292 
293   // called by the owner on emergency, triggers stopped state
294   function halt() external onlyOwner {
295     halted = true;
296   }
297 
298   // called by the owner on end of emergency, returns to normal state
299   function unhalt() external onlyOwner onlyInEmergency {
300     halted = false;
301   }
302 
303 }
304 
305 
306 
307 
308 
309 
310 
311 /**
312  * Crowdsale state machine without buy functionality.
313  *
314  * Implements basic state machine logic, but leaves out all buy functions,
315  * so that subclasses can implement their own buying logic.
316  *
317  *
318  * For the default buy() implementation see Crowdsale.sol.
319  */
320 contract CrowdsaleBase is Haltable {
321 
322   /* Max investment count when we are still allowed to change the multisig address */
323   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
324 
325   using SafeMathLib for uint;
326 
327   /* The token we are selling */
328   FractionalERC20 public token;
329 
330   /* How we are going to price our offering */
331   PricingStrategy public pricingStrategy;
332 
333   /* Post-success callback */
334   FinalizeAgent public finalizeAgent;
335 
336   /* tokens will be transfered from this address */
337   address public multisigWallet;
338 
339   /* if the funding goal is not reached, investors may withdraw their funds */
340   uint public minimumFundingGoal;
341 
342   /* the UNIX timestamp start date of the crowdsale */
343   uint public startsAt;
344 
345   /* the UNIX timestamp end date of the crowdsale */
346   uint public endsAt;
347 
348   /* the number of tokens already sold through this contract*/
349   uint public tokensSold = 0;
350 
351   /* How many wei of funding we have raised */
352   uint public weiRaised = 0;
353 
354   /* Calculate incoming funds from presale contracts and addresses */
355   uint public presaleWeiRaised = 0;
356 
357   /* How many distinct addresses have invested */
358   uint public investorCount = 0;
359 
360   /* How much wei we have returned back to the contract after a failed crowdfund. */
361   uint public loadedRefund = 0;
362 
363   /* How much wei we have given back to investors.*/
364   uint public weiRefunded = 0;
365 
366   /* Has this crowdsale been finalized */
367   bool public finalized;
368 
369   /** How much ETH each address has invested to this crowdsale */
370   mapping (address => uint256) public investedAmountOf;
371 
372   /** How much tokens this crowdsale has credited for each investor address */
373   mapping (address => uint256) public tokenAmountOf;
374 
375   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
376   mapping (address => bool) public earlyParticipantWhitelist;
377 
378   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
379   uint public ownerTestValue;
380 
381   /** State machine
382    *
383    * - Preparing: All contract initialization calls and variables have not been set yet
384    * - Prefunding: We have not passed start time yet
385    * - Funding: Active crowdsale
386    * - Success: Minimum funding goal reached
387    * - Failure: Minimum funding goal not reached before ending time
388    * - Finalized: The finalized has been called and succesfully executed
389    * - Refunding: Refunds are loaded on the contract for reclaim.
390    */
391   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
392 
393   // A new investment was made
394   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
395 
396   // Refund was processed for a contributor
397   event Refund(address investor, uint weiAmount);
398 
399   // The rules were changed what kind of investments we accept
400   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
401 
402   // Address early participation whitelist status changed
403   event Whitelisted(address addr, bool status);
404 
405   // Crowdsale end time has been changed
406   event EndsAtChanged(uint newEndsAt);
407 
408   State public testState;
409 
410   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
411 
412     owner = msg.sender;
413 
414     token = FractionalERC20(_token);
415 
416     setPricingStrategy(_pricingStrategy);
417 
418     multisigWallet = _multisigWallet;
419     if(multisigWallet == 0) {
420         throw;
421     }
422 
423     if(_start == 0) {
424         throw;
425     }
426 
427     startsAt = _start;
428 
429     if(_end == 0) {
430         throw;
431     }
432 
433     endsAt = _end;
434 
435     // Don't mess the dates
436     if(startsAt >= endsAt) {
437         throw;
438     }
439 
440     // Minimum funding goal can be zero
441     minimumFundingGoal = _minimumFundingGoal;
442   }
443 
444   /**
445    * Don't expect to just send in money and get tokens.
446    */
447   function() payable {
448     throw;
449   }
450 
451   /**
452    * Make an investment.
453    *
454    * Crowdsale must be running for one to invest.
455    * We must have not pressed the emergency brake.
456    *
457    * @param receiver The Ethereum address who receives the tokens
458    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
459    *
460    * @return tokenAmount How mony tokens were bought
461    */
462   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
463 
464     // Determine if it's a good time to accept investment from this participant
465     if(getState() == State.PreFunding) {
466       // Are we whitelisted for early deposit
467       if(!earlyParticipantWhitelist[receiver]) {
468         throw;
469       }
470     } else if(getState() == State.Funding) {
471       // Retail participants can only come in when the crowdsale is running
472       // pass
473     } else {
474       // Unwanted state
475       throw;
476     }
477 
478     uint weiAmount = msg.value;
479 
480     // Account presale sales separately, so that they do not count against pricing tranches
481     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
482 
483     // Dust transaction
484     require(tokenAmount != 0);
485 
486     if(investedAmountOf[receiver] == 0) {
487        // A new investor
488        investorCount++;
489     }
490 
491     // Update investor
492     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
493     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
494 
495     // Update totals
496     weiRaised = weiRaised.plus(weiAmount);
497     tokensSold = tokensSold.plus(tokenAmount);
498 
499     if(pricingStrategy.isPresalePurchase(receiver)) {
500         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
501     }
502 
503     // Check that we did not bust the cap
504     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
505 
506     assignTokens(receiver, tokenAmount);
507 
508     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
509     if(!multisigWallet.send(weiAmount)) throw;
510 
511     // Tell us invest was success
512     Invested(receiver, weiAmount, tokenAmount, customerId);
513 
514     return tokenAmount;
515   }
516 
517   /**
518    * Finalize a succcesful crowdsale.
519    *
520    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
521    */
522   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
523 
524     // Already finalized
525     if(finalized) {
526       throw;
527     }
528 
529     // Finalizing is optional. We only call it if we are given a finalizing agent.
530     if(address(finalizeAgent) != 0) {
531       finalizeAgent.finalizeCrowdsale();
532     }
533 
534     finalized = true;
535   }
536 
537   /**
538    * Allow to (re)set finalize agent.
539    *
540    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
541    */
542   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
543     finalizeAgent = addr;
544 
545     // Don't allow setting bad agent
546     if(!finalizeAgent.isFinalizeAgent()) {
547       throw;
548     }
549   }
550 
551   /**
552    * Allow crowdsale owner to close early or extend the crowdsale.
553    *
554    * This is useful e.g. for a manual soft cap implementation:
555    * - after X amount is reached determine manual closing
556    *
557    * This may put the crowdsale to an invalid state,
558    * but we trust owners know what they are doing.
559    *
560    */
561   function setEndsAt(uint time) onlyOwner {
562 
563     if(now > time) {
564       throw; // Don't change past
565     }
566 
567     if(startsAt > time) {
568       throw; // Prevent human mistakes
569     }
570 
571     endsAt = time;
572     EndsAtChanged(endsAt);
573   }
574 
575   /**
576    * Allow to (re)set pricing strategy.
577    *
578    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
579    */
580   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
581     pricingStrategy = _pricingStrategy;
582 
583     // Don't allow setting bad agent
584     if(!pricingStrategy.isPricingStrategy()) {
585       throw;
586     }
587   }
588 
589   /**
590    * Allow to change the team multisig address in the case of emergency.
591    *
592    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
593    * (we have done only few test transactions). After the crowdsale is going
594    * then multisig address stays locked for the safety reasons.
595    */
596   function setMultisig(address addr) public onlyOwner {
597 
598     // Change
599     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
600       throw;
601     }
602 
603     multisigWallet = addr;
604   }
605 
606   /**
607    * Allow load refunds back on the contract for the refunding.
608    *
609    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
610    */
611   function loadRefund() public payable inState(State.Failure) {
612     if(msg.value == 0) throw;
613     loadedRefund = loadedRefund.plus(msg.value);
614   }
615 
616   /**
617    * Investors can claim refund.
618    *
619    * Note that any refunds from proxy buyers should be handled separately,
620    * and not through this contract.
621    */
622   function refund() public inState(State.Refunding) {
623     uint256 weiValue = investedAmountOf[msg.sender];
624     if (weiValue == 0) throw;
625     investedAmountOf[msg.sender] = 0;
626     weiRefunded = weiRefunded.plus(weiValue);
627     Refund(msg.sender, weiValue);
628     if (!msg.sender.send(weiValue)) throw;
629   }
630 
631   /**
632    * @return true if the crowdsale has raised enough money to be a successful.
633    */
634   function isMinimumGoalReached() public constant returns (bool reached) {
635     return weiRaised >= minimumFundingGoal;
636   }
637 
638   /**
639    * Check if the contract relationship looks good.
640    */
641   function isFinalizerSane() public constant returns (bool sane) {
642     return finalizeAgent.isSane();
643   }
644 
645   /**
646    * Check if the contract relationship looks good.
647    */
648   function isPricingSane() public constant returns (bool sane) {
649     return pricingStrategy.isSane(address(this));
650   }
651 
652   /**
653    * Crowdfund state machine management.
654    *
655    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
656    */
657   function getState() public constant returns (State) {
658     if(finalized) return State.Finalized;
659     else if (address(finalizeAgent) == 0) return State.Preparing;
660     else if (!finalizeAgent.isSane()) return State.Preparing;
661     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
662     else if (block.timestamp < startsAt) return State.PreFunding;
663     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
664     else if (isMinimumGoalReached()) return State.Success;
665     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
666     else return State.Failure;
667   }
668 
669   /** This is for manual testing of multisig wallet interaction */
670   function setOwnerTestValue(uint val) onlyOwner {
671     ownerTestValue = val;
672   }
673 
674   /**
675    * Allow addresses to do early participation.
676    *
677    * TODO: Fix spelling error in the name
678    */
679   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
680     earlyParticipantWhitelist[addr] = status;
681     Whitelisted(addr, status);
682   }
683 
684 
685   /** Interface marker. */
686   function isCrowdsale() public constant returns (bool) {
687     return true;
688   }
689 
690   //
691   // Modifiers
692   //
693 
694   /** Modified allowing execution only if the crowdsale is currently running.  */
695   modifier inState(State state) {
696     if(getState() != state) throw;
697     _;
698   }
699 
700 
701   //
702   // Abstract functions
703   //
704 
705   /**
706    * Check if the current invested breaks our cap rules.
707    *
708    *
709    * The child contract must define their own cap setting rules.
710    * We allow a lot of flexibility through different capping strategies (ETH, token count)
711    * Called from invest().
712    *
713    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
714    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
715    * @param weiRaisedTotal What would be our total raised balance after this transaction
716    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
717    *
718    * @return true if taking this investment would break our cap rules
719    */
720   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
721 
722   /**
723    * Check if the current crowdsale is full and we can no longer sell any tokens.
724    */
725   function isCrowdsaleFull() public constant returns (bool);
726 
727   /**
728    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
729    */
730   function assignTokens(address receiver, uint tokenAmount) internal;
731 }
732 
733 
734 
735 /**
736  * Abstract base contract for token sales with the default buy entry points.
737  *
738  * Handle
739  * - start and end dates
740  * - accepting investments
741  * - minimum funding goal and refund
742  * - various statistics during the crowdfund
743  * - different pricing strategies
744  * - different investment policies (require server side customer id, allow only whitelisted addresses)
745  *
746  * Does not Handle
747  *
748  * - Token allocation (minting vs. transfer)
749  * - Cap rules
750  *
751  */
752 contract Crowdsale is CrowdsaleBase {
753 
754   /* Do we need to have unique contributor id for each customer */
755   bool public requireCustomerId;
756 
757   /**
758     * Do we verify that contributor has been cleared on the server side (accredited investors only).
759     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
760     */
761   bool public requiredSignedAddress;
762 
763   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
764   address public signerAddress;
765 
766   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
767   }
768 
769   /**
770    * Preallocate tokens for the early investors.
771    *
772    * Preallocated tokens have been sold before the actual crowdsale opens.
773    * This function mints the tokens and moves the crowdsale needle.
774    *
775    * Investor count is not handled; it is assumed this goes for multiple investors
776    * and the token distribution happens outside the smart contract flow.
777    *
778    * No money is exchanged, as the crowdsale team already have received the payment.
779    *
780    * @param fullTokens tokens as full tokens - decimal places added internally
781    * @param weiPrice Price of a single full token in wei
782    *
783    */
784   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
785 
786     uint tokenAmount = fullTokens * 10**token.decimals();
787     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
788 
789     weiRaised = weiRaised.plus(weiAmount);
790     tokensSold = tokensSold.plus(tokenAmount);
791 
792     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
793     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
794 
795     assignTokens(receiver, tokenAmount);
796 
797     // Tell us invest was success
798     Invested(receiver, weiAmount, tokenAmount, 0);
799   }
800 
801   /**
802    * Allow anonymous contributions to this crowdsale.
803    */
804   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
805      bytes32 hash = sha256(addr);
806      if (ecrecover(hash, v, r, s) != signerAddress) throw;
807      if(customerId == 0) throw;  // UUIDv4 sanity check
808      investInternal(addr, customerId);
809   }
810 
811   /**
812    * Track who is the customer making the payment so we can send thank you email.
813    */
814   function investWithCustomerId(address addr, uint128 customerId) public payable {
815     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
816     if(customerId == 0) throw;  // UUIDv4 sanity check
817     investInternal(addr, customerId);
818   }
819 
820   /**
821    * Allow anonymous contributions to this crowdsale.
822    */
823   function invest(address addr) public payable {
824     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
825     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
826     investInternal(addr, 0);
827   }
828 
829   /**
830    * Invest to tokens, recognize the payer and clear his address.
831    *
832    */
833   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
834     investWithSignedAddress(msg.sender, customerId, v, r, s);
835   }
836 
837   /**
838    * Invest to tokens, recognize the payer.
839    *
840    */
841   function buyWithCustomerId(uint128 customerId) public payable {
842     investWithCustomerId(msg.sender, customerId);
843   }
844 
845   /**
846    * The basic entry point to participate the crowdsale process.
847    *
848    * Pay for funding, get invested tokens back in the sender address.
849    */
850   function buy() public payable {
851     invest(msg.sender);
852   }
853 
854   /**
855    * Set policy do we need to have server-side customer ids for the investments.
856    *
857    */
858   function setRequireCustomerId(bool value) onlyOwner {
859     requireCustomerId = value;
860     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
861   }
862 
863   /**
864    * Set policy if all investors must be cleared on the server side first.
865    *
866    * This is e.g. for the accredited investor clearing.
867    *
868    */
869   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
870     requiredSignedAddress = value;
871     signerAddress = _signerAddress;
872     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
873   }
874 
875 }
876 
877 
878 
879 /**
880  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
881  *
882  * - Collect funds from pre-sale investors
883  * - Send funds to the crowdsale when it opens
884  * - Allow owner to set the crowdsale
885  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
886  * - Allow unlimited investors
887  * - Tokens are distributed on PreICOProxyBuyer smart contract first
888  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
889  * - All functions can be halted by owner if something goes wrong
890  *
891  */
892 contract PreICOProxyBuyer is Ownable, Haltable {
893   using SafeMath for uint;
894 
895   /** How many investors we have now */
896   uint public investorCount;
897 
898   /** How many wei we have raised totla. */
899   uint public weiRaised;
900 
901   /** Who are our investors (iterable) */
902   address[] public investors;
903 
904   /** How much they have invested */
905   mapping(address => uint) public balances;
906 
907   /** How many tokens investors have claimed */
908   mapping(address => uint) public claimed;
909 
910   /** When our refund freeze is over (UNIT timestamp) */
911   uint public freezeEndsAt;
912 
913   /** What is the minimum buy in */
914   uint public weiMinimumLimit;
915 
916   /** What is the maximum buy in */
917   uint public weiMaximumLimit;
918 
919   /** How many weis total we are allowed to collect. */
920   uint public weiCap;
921 
922   /** How many tokens were bought */
923   uint public tokensBought;
924 
925    /** How many investors have claimed their tokens */
926   uint public claimCount;
927 
928   uint public totalClaimed;
929 
930   /** If timeLock > 0, claiming is possible only after the time has passed **/
931   uint public timeLock;
932 
933   /** This is used to signal that we want the refund **/
934   bool public forcedRefund;
935 
936   /** Our ICO contract where we will move the funds */
937   Crowdsale public crowdsale;
938 
939   /** What is our current state. */
940   enum State{Unknown, Funding, Distributing, Refunding}
941 
942   /** Somebody loaded their investment money */
943   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
944 
945   /** Refund claimed */
946   event Refunded(address investor, uint value);
947 
948   /** We executed our buy */
949   event TokensBoughts(uint count);
950 
951   /** We distributed tokens to an investor */
952   event Distributed(address investor, uint count);
953 
954   /**
955    * Create presale contract where lock up period is given days
956    */
957   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
958 
959     owner = _owner;
960 
961     // Give argument
962     if(_freezeEndsAt == 0) {
963       throw;
964     }
965 
966     // Give argument
967     if(_weiMinimumLimit == 0) {
968       throw;
969     }
970 
971     if(_weiMaximumLimit == 0) {
972       throw;
973     }
974 
975     weiMinimumLimit = _weiMinimumLimit;
976     weiMaximumLimit = _weiMaximumLimit;
977     weiCap = _weiCap;
978     freezeEndsAt = _freezeEndsAt;
979   }
980 
981   /**
982    * Get the token we are distributing.
983    */
984   function getToken() public constant returns(FractionalERC20) {
985     if(address(crowdsale) == 0)  {
986       throw;
987     }
988 
989     return crowdsale.token();
990   }
991 
992   /**
993    * Participate to a presale.
994    */
995   function invest(uint128 customerId) private {
996 
997     // Cannot invest anymore through crowdsale when moving has begun
998     if(getState() != State.Funding) throw;
999 
1000     if(msg.value == 0) throw; // No empty buys
1001 
1002     address investor = msg.sender;
1003 
1004     bool existing = balances[investor] > 0;
1005 
1006     balances[investor] = balances[investor].add(msg.value);
1007 
1008     // Need to satisfy minimum and maximum limits
1009     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1010       throw;
1011     }
1012 
1013     // This is a new investor
1014     if(!existing) {
1015       investors.push(investor);
1016       investorCount++;
1017     }
1018 
1019     weiRaised = weiRaised.add(msg.value);
1020     if(weiRaised > weiCap) {
1021       throw;
1022     }
1023 
1024     // We will use the same event form the Crowdsale for compatibility reasons
1025     // despite not having a token amount.
1026     Invested(investor, msg.value, 0, customerId);
1027   }
1028 
1029   function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
1030     invest(customerId);
1031   }
1032 
1033   function buy() public stopInEmergency payable {
1034     invest(0x0);
1035   }
1036 
1037 
1038   /**
1039    * Load funds to the crowdsale for all investors.
1040    *
1041    *
1042    */
1043   function buyForEverybody() stopNonOwnersInEmergency public {
1044 
1045     if(getState() != State.Funding) {
1046       // Only allow buy once
1047       throw;
1048     }
1049 
1050     // Crowdsale not yet set
1051     if(address(crowdsale) == 0) throw;
1052 
1053     // Buy tokens on the contract
1054     crowdsale.invest.value(weiRaised)(address(this));
1055 
1056     // Record how many tokens we got
1057     tokensBought = getToken().balanceOf(address(this));
1058 
1059     if(tokensBought == 0) {
1060       // Did not get any tokens
1061       throw;
1062     }
1063 
1064     TokensBoughts(tokensBought);
1065   }
1066 
1067   /**
1068    * How may tokens each investor gets.
1069    */
1070   function getClaimAmount(address investor) public constant returns (uint) {
1071 
1072     // Claims can be only made if we manage to buy tokens
1073     if(getState() != State.Distributing) {
1074       throw;
1075     }
1076     return balances[investor].mul(tokensBought) / weiRaised;
1077   }
1078 
1079   /**
1080    * How many tokens remain unclaimed for an investor.
1081    */
1082   function getClaimLeft(address investor) public constant returns (uint) {
1083     return getClaimAmount(investor).sub(claimed[investor]);
1084   }
1085 
1086   /**
1087    * Claim all remaining tokens for this investor.
1088    */
1089   function claimAll() {
1090     claim(getClaimLeft(msg.sender));
1091   }
1092 
1093   /**
1094    * Claim N bought tokens to the investor as the msg sender.
1095    *
1096    */
1097   function claim(uint amount) stopInEmergency {
1098     require (now > timeLock);
1099 
1100     address investor = msg.sender;
1101 
1102     if(amount == 0) {
1103       throw;
1104     }
1105 
1106     if(getClaimLeft(investor) < amount) {
1107       // Woops we cannot get more than we have left
1108       throw;
1109     }
1110 
1111     // We track who many investor have (partially) claimed their tokens
1112     if(claimed[investor] == 0) {
1113       claimCount++;
1114     }
1115 
1116     claimed[investor] = claimed[investor].add(amount);
1117     totalClaimed = totalClaimed.add(amount);
1118     getToken().transfer(investor, amount);
1119 
1120     Distributed(investor, amount);
1121   }
1122 
1123   /**
1124    * ICO never happened. Allow refund.
1125    */
1126   function refund() stopInEmergency {
1127 
1128     // Trying to ask refund too soon
1129     if(getState() != State.Refunding) throw;
1130 
1131     address investor = msg.sender;
1132     if(balances[investor] == 0) throw;
1133     uint amount = balances[investor];
1134     delete balances[investor];
1135     if(!(investor.call.value(amount)())) throw;
1136     Refunded(investor, amount);
1137   }
1138 
1139   /**
1140    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1141    */
1142   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1143     crowdsale = _crowdsale;
1144 
1145     // Check interface
1146     if(!crowdsale.isCrowdsale()) true;
1147   }
1148 
1149   /// @dev Setting timelock (delay) for claiming
1150   /// @param _timeLock Time after which claiming is possible
1151   function setTimeLock(uint _timeLock) public onlyOwner {
1152     timeLock = _timeLock;
1153   }
1154 
1155   /// @dev This is used in the first case scenario, this will force the state
1156   ///      to refunding. This can be also used when the ICO fails to meet the cap.
1157   function forceRefund() public onlyOwner {
1158     forcedRefund = true;
1159   }
1160 
1161   /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
1162   ///      we can't use Crowdsale's refund, since our default function does not
1163   ///      accept money in.
1164   function loadRefund() public payable {
1165     if(getState() != State.Refunding) throw;
1166   }
1167 
1168   /**
1169    * Resolve the contract umambigious state.
1170    */
1171   function getState() public returns(State) {
1172     if (forcedRefund)
1173       return State.Refunding;
1174 
1175     if(tokensBought == 0) {
1176       if(now >= freezeEndsAt) {
1177          return State.Refunding;
1178       } else {
1179         return State.Funding;
1180       }
1181     } else {
1182       return State.Distributing;
1183     }
1184   }
1185 
1186   /** Interface marker. */
1187   function isPresale() public constant returns (bool) {
1188     return true;
1189   }
1190 
1191   /** Explicitly call function from your wallet. */
1192   function() payable {
1193     throw;
1194   }
1195 }