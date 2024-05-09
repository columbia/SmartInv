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
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner {
94     require(newOwner != address(0));      
95     owner = newOwner;
96   }
97 
98 }
99 
100 
101 /*
102  * Haltable
103  *
104  * Abstract contract that allows children to implement an
105  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
106  *
107  *
108  * Originally envisioned in FirstBlood ICO contract.
109  */
110 contract Haltable is Ownable {
111   bool public halted;
112 
113   modifier stopInEmergency {
114     if (halted) throw;
115     _;
116   }
117 
118   modifier onlyInEmergency {
119     if (!halted) throw;
120     _;
121   }
122 
123   // called by the owner on emergency, triggers stopped state
124   function halt() external onlyOwner {
125     halted = true;
126   }
127 
128   // called by the owner on end of emergency, returns to normal state
129   function unhalt() external onlyOwner onlyInEmergency {
130     halted = false;
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
142 /**
143  * Interface for defining crowdsale pricing.
144  */
145 contract PricingStrategy {
146 
147   /** Interface declaration. */
148   function isPricingStrategy() public constant returns (bool) {
149     return true;
150   }
151 
152   /** Self check if all references are correctly set.
153    *
154    * Checks that pricing strategy matches crowdsale parameters.
155    */
156   function isSane(address crowdsale) public constant returns (bool) {
157     return true;
158   }
159 
160   /**
161    * @dev Pricing tells if this is a presale purchase or not.
162      @param purchaser Address of the purchaser
163      @return False by default, true if a presale purchaser
164    */
165   function isPresalePurchase(address purchaser) public constant returns (bool) {
166     return false;
167   }
168 
169   /**
170    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
171    *
172    *
173    * @param value - What is the value of the transaction send in as wei
174    * @param tokensSold - how much tokens have been sold this far
175    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
176    * @param msgSender - who is the investor of this transaction
177    * @param decimals - how many decimal units the token has
178    * @return Amount of tokens the investor receives
179    */
180   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
181 }
182 
183 /**
184  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
185  *
186  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
187  */
188 
189 
190 /**
191  * Finalize agent defines what happens at the end of succeseful crowdsale.
192  *
193  * - Allocate tokens for founders, bounties and community
194  * - Make tokens transferable
195  * - etc.
196  */
197 contract FinalizeAgent {
198 
199   function isFinalizeAgent() public constant returns(bool) {
200     return true;
201   }
202 
203   /** Return true if we can run finalizeCrowdsale() properly.
204    *
205    * This is a safety check function that doesn't allow crowdsale to begin
206    * unless the finalizer has been set up properly.
207    */
208   function isSane() public constant returns (bool);
209 
210   /** Called once by crowdsale finalize() if the sale was success. */
211   function finalizeCrowdsale();
212 
213 }
214 
215 /**
216  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
217  *
218  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
219  */
220 
221 
222 
223 
224 
225 
226 /**
227  * @title ERC20Basic
228  * @dev Simpler version of ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/179
230  */
231 contract ERC20Basic {
232   uint256 public totalSupply;
233   function balanceOf(address who) constant returns (uint256);
234   function transfer(address to, uint256 value) returns (bool);
235   event Transfer(address indexed from, address indexed to, uint256 value);
236 }
237 
238 
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 contract ERC20 is ERC20Basic {
245   function allowance(address owner, address spender) constant returns (uint256);
246   function transferFrom(address from, address to, uint256 value) returns (bool);
247   function approve(address spender, uint256 value) returns (bool);
248   event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 
252 /**
253  * A token that defines fractional units as decimals.
254  */
255 contract FractionalERC20 is ERC20 {
256 
257   uint public decimals;
258 
259 }
260 
261 
262 
263 /**
264  * Abstract base contract for token sales.
265  *
266  * Handle
267  * - start and end dates
268  * - accepting investments
269  * - minimum funding goal and refund
270  * - various statistics during the crowdfund
271  * - different pricing strategies
272  * - different investment policies (require server side customer id, allow only whitelisted addresses)
273  *
274  */
275 contract Crowdsale is Haltable {
276 
277   /* Max investment count when we are still allowed to change the multisig address */
278   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
279 
280   using SafeMathLib for uint;
281 
282   /* The token we are selling */
283   FractionalERC20 public token;
284 
285   /* How we are going to price our offering */
286   PricingStrategy public pricingStrategy;
287 
288   /* Post-success callback */
289   FinalizeAgent public finalizeAgent;
290 
291   /* tokens will be transfered from this address */
292   address public multisigWallet;
293 
294   /* if the funding goal is not reached, investors may withdraw their funds */
295   uint public minimumFundingGoal;
296 
297   /* the UNIX timestamp start date of the crowdsale */
298   uint public startsAt;
299 
300   /* the UNIX timestamp end date of the crowdsale */
301   uint public endsAt;
302 
303   /* the number of tokens already sold through this contract*/
304   uint public tokensSold = 0;
305 
306   /* How many wei of funding we have raised */
307   uint public weiRaised = 0;
308 
309   /* Calculate incoming funds from presale contracts and addresses */
310   uint public presaleWeiRaised = 0;
311 
312   /* How many distinct addresses have invested */
313   uint public investorCount = 0;
314 
315   /* How much wei we have returned back to the contract after a failed crowdfund. */
316   uint public loadedRefund = 0;
317 
318   /* How much wei we have given back to investors.*/
319   uint public weiRefunded = 0;
320 
321   /* Has this crowdsale been finalized */
322   bool public finalized;
323 
324   /* Do we need to have unique contributor id for each customer */
325   bool public requireCustomerId;
326 
327   /**
328     * Do we verify that contributor has been cleared on the server side (accredited investors only).
329     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
330     */
331   bool public requiredSignedAddress;
332 
333   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
334   address public signerAddress;
335 
336   /** How much ETH each address has invested to this crowdsale */
337   mapping (address => uint256) public investedAmountOf;
338 
339   /** How much tokens this crowdsale has credited for each investor address */
340   mapping (address => uint256) public tokenAmountOf;
341 
342   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
343   mapping (address => bool) public earlyParticipantWhitelist;
344 
345   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
346   uint public ownerTestValue;
347 
348   /** State machine
349    *
350    * - Preparing: All contract initialization calls and variables have not been set yet
351    * - Prefunding: We have not passed start time yet
352    * - Funding: Active crowdsale
353    * - Success: Minimum funding goal reached
354    * - Failure: Minimum funding goal not reached before ending time
355    * - Finalized: The finalized has been called and succesfully executed
356    * - Refunding: Refunds are loaded on the contract for reclaim.
357    */
358   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
359 
360   // A new investment was made
361   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
362 
363   // Refund was processed for a contributor
364   event Refund(address investor, uint weiAmount);
365 
366   // The rules were changed what kind of investments we accept
367   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
368 
369   // Address early participation whitelist status changed
370   event Whitelisted(address addr, bool status);
371 
372   // Crowdsale end time has been changed
373   event EndsAtChanged(uint newEndsAt);
374 
375   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
376 
377     owner = msg.sender;
378 
379     token = FractionalERC20(_token);
380 
381     setPricingStrategy(_pricingStrategy);
382 
383     multisigWallet = _multisigWallet;
384     if(multisigWallet == 0) {
385         throw;
386     }
387 
388     if(_start == 0) {
389         throw;
390     }
391 
392     startsAt = _start;
393 
394     if(_end == 0) {
395         throw;
396     }
397 
398     endsAt = _end;
399 
400     // Don't mess the dates
401     if(startsAt >= endsAt) {
402         throw;
403     }
404 
405     // Minimum funding goal can be zero
406     minimumFundingGoal = _minimumFundingGoal;
407   }
408 
409   /**
410    * Don't expect to just send in money and get tokens.
411    */
412   function() payable {
413     throw;
414   }
415 
416   /**
417    * Make an investment.
418    *
419    * Crowdsale must be running for one to invest.
420    * We must have not pressed the emergency brake.
421    *
422    * @param receiver The Ethereum address who receives the tokens
423    * @param customerId (optional) UUID v4 to track the successful payments on the server side
424    *
425    */
426   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
427 
428     // Determine if it's a good time to accept investment from this participant
429     if(getState() == State.PreFunding) {
430       // Are we whitelisted for early deposit
431       if(!earlyParticipantWhitelist[receiver]) {
432         throw;
433       }
434     } else if(getState() == State.Funding) {
435       // Retail participants can only come in when the crowdsale is running
436       // pass
437     } else {
438       // Unwanted state
439       throw;
440     }
441 
442     uint weiAmount = msg.value;
443 
444     // Account presale sales separately, so that they do not count against pricing tranches
445     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
446 
447     if(tokenAmount == 0) {
448       // Dust transaction
449       throw;
450     }
451 
452     if(investedAmountOf[receiver] == 0) {
453        // A new investor
454        investorCount++;
455     }
456 
457     // Update investor
458     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
459     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
460 
461     // Update totals
462     weiRaised = weiRaised.plus(weiAmount);
463     tokensSold = tokensSold.plus(tokenAmount);
464 
465     if(pricingStrategy.isPresalePurchase(receiver)) {
466         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
467     }
468 
469     // Check that we did not bust the cap
470     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
471       throw;
472     }
473 
474     assignTokens(receiver, tokenAmount);
475 
476     // Pocket the money
477     if(!multisigWallet.send(weiAmount)) throw;
478 
479     // Tell us invest was success
480     Invested(receiver, weiAmount, tokenAmount, customerId);
481   }
482 
483   /**
484    * Preallocate tokens for the early investors.
485    *
486    * Preallocated tokens have been sold before the actual crowdsale opens.
487    * This function mints the tokens and moves the crowdsale needle.
488    *
489    * Investor count is not handled; it is assumed this goes for multiple investors
490    * and the token distribution happens outside the smart contract flow.
491    *
492    * No money is exchanged, as the crowdsale team already have received the payment.
493    *
494    * @param fullTokens tokens as full tokens - decimal places added internally
495    * @param weiPrice Price of a single full token in wei
496    *
497    */
498   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
499 
500     uint tokenAmount = fullTokens * 10**token.decimals();
501     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
502 
503     weiRaised = weiRaised.plus(weiAmount);
504     tokensSold = tokensSold.plus(tokenAmount);
505 
506     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
507     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
508 
509     assignTokens(receiver, tokenAmount);
510 
511     // Tell us invest was success
512     Invested(receiver, weiAmount, tokenAmount, 0);
513   }
514 
515   /**
516    * Allow anonymous contributions to this crowdsale.
517    */
518   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
519      bytes32 hash = sha256(addr);
520      if (ecrecover(hash, v, r, s) != signerAddress) throw;
521      if(customerId == 0) throw;  // UUIDv4 sanity check
522      investInternal(addr, customerId);
523   }
524 
525   /**
526    * Track who is the customer making the payment so we can send thank you email.
527    */
528   function investWithCustomerId(address addr, uint128 customerId) public payable {
529     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
530     if(customerId == 0) throw;  // UUIDv4 sanity check
531     investInternal(addr, customerId);
532   }
533 
534   /**
535    * Allow anonymous contributions to this crowdsale.
536    */
537   function invest(address addr) public payable {
538     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
539     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
540     investInternal(addr, 0);
541   }
542 
543   /**
544    * Invest to tokens, recognize the payer and clear his address.
545    *
546    */
547   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
548     investWithSignedAddress(msg.sender, customerId, v, r, s);
549   }
550 
551   /**
552    * Invest to tokens, recognize the payer.
553    *
554    */
555   function buyWithCustomerId(uint128 customerId) public payable {
556     investWithCustomerId(msg.sender, customerId);
557   }
558 
559   /**
560    * The basic entry point to participate the crowdsale process.
561    *
562    * Pay for funding, get invested tokens back in the sender address.
563    */
564   function buy() public payable {
565     invest(msg.sender);
566   }
567 
568   /**
569    * Finalize a succcesful crowdsale.
570    *
571    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
572    */
573   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
574 
575     // Already finalized
576     if(finalized) {
577       throw;
578     }
579 
580     // Finalizing is optional. We only call it if we are given a finalizing agent.
581     if(address(finalizeAgent) != 0) {
582       finalizeAgent.finalizeCrowdsale();
583     }
584 
585     finalized = true;
586   }
587 
588   /**
589    * Allow to (re)set finalize agent.
590    *
591    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
592    */
593   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
594     finalizeAgent = addr;
595 
596     // Don't allow setting bad agent
597     if(!finalizeAgent.isFinalizeAgent()) {
598       throw;
599     }
600   }
601 
602   /**
603    * Set policy do we need to have server-side customer ids for the investments.
604    *
605    */
606   function setRequireCustomerId(bool value) onlyOwner {
607     requireCustomerId = value;
608     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
609   }
610 
611   /**
612    * Set policy if all investors must be cleared on the server side first.
613    *
614    * This is e.g. for the accredited investor clearing.
615    *
616    */
617   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
618     requiredSignedAddress = value;
619     signerAddress = _signerAddress;
620     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
621   }
622 
623   /**
624    * Allow addresses to do early participation.
625    *
626    * TODO: Fix spelling error in the name
627    */
628   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
629     earlyParticipantWhitelist[addr] = status;
630     Whitelisted(addr, status);
631   }
632 
633   /**
634    * Allow crowdsale owner to close early or extend the crowdsale.
635    *
636    * This is useful e.g. for a manual soft cap implementation:
637    * - after X amount is reached determine manual closing
638    *
639    * This may put the crowdsale to an invalid state,
640    * but we trust owners know what they are doing.
641    *
642    */
643   function setEndsAt(uint time) onlyOwner {
644 
645     if(now > time) {
646       throw; // Don't change past
647     }
648 
649     endsAt = time;
650     EndsAtChanged(endsAt);
651   }
652 
653   /**
654    * Allow to (re)set pricing strategy.
655    *
656    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
657    */
658   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
659     pricingStrategy = _pricingStrategy;
660 
661     // Don't allow setting bad agent
662     if(!pricingStrategy.isPricingStrategy()) {
663       throw;
664     }
665   }
666 
667   /**
668    * Allow to change the team multisig address in the case of emergency.
669    *
670    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
671    * (we have done only few test transactions). After the crowdsale is going
672    * then multisig address stays locked for the safety reasons.
673    */
674   function setMultisig(address addr) public onlyOwner {
675 
676     // Change
677     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
678       throw;
679     }
680 
681     multisigWallet = addr;
682   }
683 
684   /**
685    * Allow load refunds back on the contract for the refunding.
686    *
687    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
688    */
689   function loadRefund() public payable inState(State.Failure) {
690     if(msg.value == 0) throw;
691     loadedRefund = loadedRefund.plus(msg.value);
692   }
693 
694   /**
695    * Investors can claim refund.
696    *
697    * Note that any refunds from proxy buyers should be handled separately,
698    * and not through this contract.
699    */
700   function refund() public inState(State.Refunding) {
701     uint256 weiValue = investedAmountOf[msg.sender];
702     if (weiValue == 0) throw;
703     investedAmountOf[msg.sender] = 0;
704     weiRefunded = weiRefunded.plus(weiValue);
705     Refund(msg.sender, weiValue);
706     if (!msg.sender.send(weiValue)) throw;
707   }
708 
709   /**
710    * @return true if the crowdsale has raised enough money to be a successful.
711    */
712   function isMinimumGoalReached() public constant returns (bool reached) {
713     return weiRaised >= minimumFundingGoal;
714   }
715 
716   /**
717    * Check if the contract relationship looks good.
718    */
719   function isFinalizerSane() public constant returns (bool sane) {
720     return finalizeAgent.isSane();
721   }
722 
723   /**
724    * Check if the contract relationship looks good.
725    */
726   function isPricingSane() public constant returns (bool sane) {
727     return pricingStrategy.isSane(address(this));
728   }
729 
730   /**
731    * Crowdfund state machine management.
732    *
733    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
734    */
735   function getState() public constant returns (State) {
736     if(finalized) return State.Finalized;
737     else if (address(finalizeAgent) == 0) return State.Preparing;
738     else if (!finalizeAgent.isSane()) return State.Preparing;
739     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
740     else if (block.timestamp < startsAt) return State.PreFunding;
741     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
742     else if (isMinimumGoalReached()) return State.Success;
743     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
744     else return State.Failure;
745   }
746 
747   /** This is for manual testing of multisig wallet interaction */
748   function setOwnerTestValue(uint val) onlyOwner {
749     ownerTestValue = val;
750   }
751 
752   /** Interface marker. */
753   function isCrowdsale() public constant returns (bool) {
754     return true;
755   }
756 
757   //
758   // Modifiers
759   //
760 
761   /** Modified allowing execution only if the crowdsale is currently running.  */
762   modifier inState(State state) {
763     if(getState() != state) throw;
764     _;
765   }
766 
767 
768   //
769   // Abstract functions
770   //
771 
772   /**
773    * Check if the current invested breaks our cap rules.
774    *
775    *
776    * The child contract must define their own cap setting rules.
777    * We allow a lot of flexibility through different capping strategies (ETH, token count)
778    * Called from invest().
779    *
780    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
781    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
782    * @param weiRaisedTotal What would be our total raised balance after this transaction
783    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
784    *
785    * @return true if taking this investment would break our cap rules
786    */
787   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
788 
789   /**
790    * Check if the current crowdsale is full and we can no longer sell any tokens.
791    */
792   function isCrowdsaleFull() public constant returns (bool);
793 
794   /**
795    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
796    */
797   function assignTokens(address receiver, uint tokenAmount) private;
798 }
799 
800 
801 /**
802  * A crowdsale that is selling tokens from a preallocated pool
803  *
804  *
805  * - Tokens have precreated supply "premined"
806  *
807  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
808  *
809  */
810 contract AllocatedCrowdsale is Crowdsale {
811 
812   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
813   address public beneficiary;
814 
815   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
816     beneficiary = _beneficiary;
817   }
818 
819   /**
820    * Called from invest() to confirm if the curret investment does not break our cap rule.
821    */
822   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
823     if(tokenAmount > getTokensLeft()) {
824       return true;
825     } else {
826       return false;
827     }
828   }
829 
830   /**
831    * We are sold out when our approve pool becomes empty.
832    */
833   function isCrowdsaleFull() public constant returns (bool) {
834     return getTokensLeft() == 0;
835   }
836 
837   /**
838    * Get the amount of unsold tokens allocated to this contract;
839    */
840   function getTokensLeft() public constant returns (uint) {
841     return token.allowance(owner, this);
842   }
843 
844   /**
845    * Transfer tokens from approve() pool to the buyer.
846    *
847    * Use approve() given to this crowdsale to distribute the tokens.
848    */
849   function assignTokens(address receiver, uint tokenAmount) private {
850     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
851   }
852 }