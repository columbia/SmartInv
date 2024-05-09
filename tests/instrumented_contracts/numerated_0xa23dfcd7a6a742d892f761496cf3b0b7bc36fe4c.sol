1 /**
2  * Math operations with safety checks
3  */
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
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
83   function assert(bool assertion) private {
84     if (!assertion) throw;
85   }
86 }
87 
88 
89 
90 
91 /*
92  * Ownable
93  *
94  * Base contract with an owner.
95  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
96  */
97 contract Ownable {
98   address public owner;
99 
100   function Ownable() {
101     owner = msg.sender;
102   }
103 
104   modifier onlyOwner() {
105     if (msg.sender != owner) {
106       throw;
107     }
108     _;
109   }
110 
111   function transferOwnership(address newOwner) onlyOwner {
112     if (newOwner != address(0)) {
113       owner = newOwner;
114     }
115   }
116 
117 }
118 
119 
120 /*
121  * Haltable
122  *
123  * Abstract contract that allows children to implement an
124  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
125  *
126  *
127  * Originally envisioned in FirstBlood ICO contract.
128  */
129 contract Haltable is Ownable {
130   bool public halted;
131 
132   modifier stopInEmergency {
133     if (halted) throw;
134     _;
135   }
136 
137   modifier onlyInEmergency {
138     if (!halted) throw;
139     _;
140   }
141 
142   // called by the owner on emergency, triggers stopped state
143   function halt() external onlyOwner {
144     halted = true;
145   }
146 
147   // called by the owner on end of emergency, returns to normal state
148   function unhalt() external onlyOwner onlyInEmergency {
149     halted = false;
150   }
151 
152 }
153 
154 
155 /**
156  * Interface for defining crowdsale pricing.
157  */
158 contract PricingStrategy {
159 
160   /** Interface declaration. */
161   function isPricingStrategy() public constant returns (bool) {
162     return true;
163   }
164 
165   /** Self check if all references are correctly set.
166    *
167    * Checks that pricing strategy matches crowdsale parameters.
168    */
169   function isSane(address crowdsale) public constant returns (bool) {
170     return true;
171   }
172 
173   /**
174    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
175    *
176    *
177    * @param value - What is the value of the transaction send in as wei
178    * @param tokensSold - how much tokens have been sold this far
179    * @param weiRaised - how much money has been raised this far
180    * @param msgSender - who is the investor of this transaction
181    * @param decimals - how many decimal units the token has
182    * @return Amount of tokens the investor receives
183    */
184   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
185 }
186 
187 
188 /**
189  * Finalize agent defines what happens at the end of succeseful crowdsale.
190  *
191  * - Allocate tokens for founders, bounties and community
192  * - Make tokens transferable
193  * - etc.
194  */
195 contract FinalizeAgent {
196 
197   function isFinalizeAgent() public constant returns(bool) {
198     return true;
199   }
200 
201   /** Return true if we can run finalizeCrowdsale() properly.
202    *
203    * This is a safety check function that doesn't allow crowdsale to begin
204    * unless the finalizer has been set up properly.
205    */
206   function isSane() public constant returns (bool);
207 
208   /** Called once by crowdsale finalize() if the sale was success. */
209   function finalizeCrowdsale();
210 
211 }
212 
213 
214 
215 
216 /*
217  * ERC20 interface
218  * see https://github.com/ethereum/EIPs/issues/20
219  */
220 contract ERC20 {
221   uint public totalSupply;
222   function balanceOf(address who) constant returns (uint);
223   function allowance(address owner, address spender) constant returns (uint);
224 
225   function transfer(address to, uint value) returns (bool ok);
226   function transferFrom(address from, address to, uint value) returns (bool ok);
227   function approve(address spender, uint value) returns (bool ok);
228   event Transfer(address indexed from, address indexed to, uint value);
229   event Approval(address indexed owner, address indexed spender, uint value);
230 }
231 
232 
233 /**
234  * A token that defines fractional units as decimals.
235  */
236 contract FractionalERC20 is ERC20 {
237 
238   uint public decimals;
239 
240 }
241 
242 
243 
244 /**
245  * Abstract base contract for token sales.
246  *
247  * Handle
248  * - start and end dates
249  * - accepting investments
250  * - minimum funding goal and refund
251  * - various statistics during the crowdfund
252  * - different pricing strategies
253  * - different investment policies (require server side customer id, allow only whitelisted addresses)
254  *
255  */
256 contract Crowdsale is Haltable {
257 
258   /* Max investment count when we are still allowed to change the multisig address */
259   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
260 
261   using SafeMathLib for uint;
262 
263   /* The token we are selling */
264   FractionalERC20 public token;
265 
266   /* How we are going to price our offering */
267   PricingStrategy public pricingStrategy;
268 
269   /* Post-success callback */
270   FinalizeAgent public finalizeAgent;
271 
272   /* tokens will be transfered from this address */
273   address public multisigWallet;
274 
275   /* if the funding goal is not reached, investors may withdraw their funds */
276   uint public minimumFundingGoal;
277 
278   /* the UNIX timestamp start date of the crowdsale */
279   uint public startsAt;
280 
281   /* the UNIX timestamp end date of the crowdsale */
282   uint public endsAt;
283 
284   /* the number of tokens already sold through this contract*/
285   uint public tokensSold = 0;
286 
287   /* How many wei of funding we have raised */
288   uint public weiRaised = 0;
289 
290   /* How many distinct addresses have invested */
291   uint public investorCount = 0;
292 
293   /* How much wei we have returned back to the contract after a failed crowdfund. */
294   uint public loadedRefund = 0;
295 
296   /* How much wei we have given back to investors.*/
297   uint public weiRefunded = 0;
298 
299   /* Has this crowdsale been finalized */
300   bool public finalized;
301 
302   /* Do we need to have unique contributor id for each customer */
303   bool public requireCustomerId;
304 
305   /**
306     * Do we verify that contributor has been cleared on the server side (accredited investors only).
307     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
308     */
309   bool public requiredSignedAddress;
310 
311   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
312   address public signerAddress;
313 
314   /** How much ETH each address has invested to this crowdsale */
315   mapping (address => uint256) public investedAmountOf;
316 
317   /** How much tokens this crowdsale has credited for each investor address */
318   mapping (address => uint256) public tokenAmountOf;
319 
320   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
321   mapping (address => bool) public earlyParticipantWhitelist;
322 
323   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
324   uint public ownerTestValue;
325 
326   /** State machine
327    *
328    * - Preparing: All contract initialization calls and variables have not been set yet
329    * - Prefunding: We have not passed start time yet
330    * - Funding: Active crowdsale
331    * - Success: Minimum funding goal reached
332    * - Failure: Minimum funding goal not reached before ending time
333    * - Finalized: The finalized has been called and succesfully executed
334    * - Refunding: Refunds are loaded on the contract for reclaim.
335    */
336   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
337 
338   // A new investment was made
339   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
340 
341   // Refund was processed for a contributor
342   event Refund(address investor, uint weiAmount);
343 
344   // The rules were changed what kind of investments we accept
345   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
346 
347   // Address early participation whitelist status changed
348   event Whitelisted(address addr, bool status);
349 
350   // Crowdsale end time has been changed
351   event EndsAtChanged(uint endsAt);
352 
353   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
354 
355     owner = msg.sender;
356 
357     token = FractionalERC20(_token);
358 
359     setPricingStrategy(_pricingStrategy);
360 
361     multisigWallet = _multisigWallet;
362     if(multisigWallet == 0) {
363         throw;
364     }
365 
366     if(_start == 0) {
367         throw;
368     }
369 
370     startsAt = _start;
371 
372     if(_end == 0) {
373         throw;
374     }
375 
376     endsAt = _end;
377 
378     // Don't mess the dates
379     if(startsAt >= endsAt) {
380         throw;
381     }
382 
383     // Minimum funding goal can be zero
384     minimumFundingGoal = _minimumFundingGoal;
385   }
386 
387   /**
388    * Don't expect to just send in money and get tokens.
389    */
390   function() payable {
391     throw;
392   }
393 
394   /**
395    * Make an investment.
396    *
397    * Crowdsale must be running for one to invest.
398    * We must have not pressed the emergency brake.
399    *
400    * @param receiver The Ethereum address who receives the tokens
401    * @param customerId (optional) UUID v4 to track the successful payments on the server side
402    *
403    */
404   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
405 
406     // Determine if it's a good time to accept investment from this participant
407     if(getState() == State.PreFunding) {
408       // Are we whitelisted for early deposit
409       if(!earlyParticipantWhitelist[receiver]) {
410         throw;
411       }
412     } else if(getState() == State.Funding) {
413       // Retail participants can only come in when the crowdsale is running
414       // pass
415     } else {
416       // Unwanted state
417       throw;
418     }
419 
420     uint weiAmount = msg.value;
421     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
422 
423     if(tokenAmount == 0) {
424       // Dust transaction
425       throw;
426     }
427 
428     if(investedAmountOf[receiver] == 0) {
429        // A new investor
430        investorCount++;
431     }
432 
433     // Update investor
434     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
435     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
436 
437     // Update totals
438     weiRaised = weiRaised.plus(weiAmount);
439     tokensSold = tokensSold.plus(tokenAmount);
440 
441     // Check that we did not bust the cap
442     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
443       throw;
444     }
445 
446     assignTokens(receiver, tokenAmount);
447 
448     // Pocket the money
449     if(!multisigWallet.send(weiAmount)) throw;
450 
451     // Tell us invest was success
452     Invested(receiver, weiAmount, tokenAmount, customerId);
453   }
454 
455   /**
456    * Preallocate tokens for the early investors.
457    *
458    * Preallocated tokens have been sold before the actual crowdsale opens.
459    * This function mints the tokens and moves the crowdsale needle.
460    *
461    * Investor count is not handled; it is assumed this goes for multiple investors
462    * and the token distribution happens outside the smart contract flow.
463    *
464    * No money is exchanged, as the crowdsale team already have received the payment.
465    *
466    * @param fullTokens tokens as full tokens - decimal places added internally
467    * @param weiPrice Price of a single full token in wei
468    *
469    */
470   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
471 
472     uint tokenAmount = fullTokens * 10**token.decimals();
473     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
474 
475     weiRaised = weiRaised.plus(weiAmount);
476     tokensSold = tokensSold.plus(tokenAmount);
477 
478     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
479     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
480 
481     assignTokens(receiver, tokenAmount);
482 
483     // Tell us invest was success
484     Invested(receiver, weiAmount, tokenAmount, 0);
485   }
486 
487   /**
488    * Allow anonymous contributions to this crowdsale.
489    */
490   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
491      bytes32 hash = sha256(addr);
492      if (ecrecover(hash, v, r, s) != signerAddress) throw;
493      if(customerId == 0) throw;  // UUIDv4 sanity check
494      investInternal(addr, customerId);
495   }
496 
497   /**
498    * Track who is the customer making the payment so we can send thank you email.
499    */
500   function investWithCustomerId(address addr, uint128 customerId) public payable {
501     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
502     if(customerId == 0) throw;  // UUIDv4 sanity check
503     investInternal(addr, customerId);
504   }
505 
506   /**
507    * Allow anonymous contributions to this crowdsale.
508    */
509   function invest(address addr) public payable {
510     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
511     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
512     investInternal(addr, 0);
513   }
514 
515   /**
516    * Invest to tokens, recognize the payer and clear his address.
517    *
518    */
519   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
520     investWithSignedAddress(msg.sender, customerId, v, r, s);
521   }
522 
523   /**
524    * Invest to tokens, recognize the payer.
525    *
526    */
527   function buyWithCustomerId(uint128 customerId) public payable {
528     investWithCustomerId(msg.sender, customerId);
529   }
530 
531   /**
532    * The basic entry point to participate the crowdsale process.
533    *
534    * Pay for funding, get invested tokens back in the sender address.
535    */
536   function buy() public payable {
537     invest(msg.sender);
538   }
539 
540   /**
541    * Finalize a succcesful crowdsale.
542    *
543    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
544    */
545   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
546 
547     // Already finalized
548     if(finalized) {
549       throw;
550     }
551 
552     // Finalizing is optional. We only call it if we are given a finalizing agent.
553     if(address(finalizeAgent) != 0) {
554       finalizeAgent.finalizeCrowdsale();
555     }
556 
557     finalized = true;
558   }
559 
560   /**
561    * Allow to (re)set finalize agent.
562    *
563    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
564    */
565   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
566     finalizeAgent = addr;
567 
568     // Don't allow setting bad agent
569     if(!finalizeAgent.isFinalizeAgent()) {
570       throw;
571     }
572   }
573 
574   /**
575    * Set policy do we need to have server-side customer ids for the investments.
576    *
577    */
578   function setRequireCustomerId(bool value) onlyOwner {
579     requireCustomerId = value;
580     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
581   }
582 
583   /**
584    * Set policy if all investors must be cleared on the server side first.
585    *
586    * This is e.g. for the accredited investor clearing.
587    *
588    */
589   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
590     requiredSignedAddress = value;
591     signerAddress = _signerAddress;
592     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
593   }
594 
595   /**
596    * Allow addresses to do early participation.
597    *
598    * TODO: Fix spelling error in the name
599    */
600   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
601     earlyParticipantWhitelist[addr] = status;
602     Whitelisted(addr, status);
603   }
604 
605   /**
606    * Allow crowdsale owner to close early or extend the crowdsale.
607    *
608    * This is useful e.g. for a manual soft cap implementation:
609    * - after X amount is reached determine manual closing
610    *
611    * This may put the crowdsale to an invalid state,
612    * but we trust owners know what they are doing.
613    *
614    */
615   function setEndsAt(uint time) onlyOwner {
616 
617     if(now > time) {
618       throw; // Don't change past
619     }
620 
621     endsAt = time;
622     EndsAtChanged(endsAt);
623   }
624 
625   /**
626    * Allow to (re)set pricing strategy.
627    *
628    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
629    */
630   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
631     pricingStrategy = _pricingStrategy;
632 
633     // Don't allow setting bad agent
634     if(!pricingStrategy.isPricingStrategy()) {
635       throw;
636     }
637   }
638 
639   /**
640    * Allow to change the team multisig address in the case of emergency.
641    *
642    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
643    * (we have done only few test transactions). After the crowdsale is going
644    * then multisig address stays locked for the safety reasons.
645    */
646   function setMultisig(address addr) public onlyOwner {
647 
648     // Change
649     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
650       throw;
651     }
652 
653     multisigWallet = addr;
654   }
655 
656   /**
657    * Allow load refunds back on the contract for the refunding.
658    *
659    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
660    */
661   function loadRefund() public payable inState(State.Failure) {
662     if(msg.value == 0) throw;
663     loadedRefund = loadedRefund.plus(msg.value);
664   }
665 
666   /**
667    * Investors can claim refund.
668    *
669    * Note that any refunds from proxy buyers should be handled separately,
670    * and not through this contract.
671    */
672   function refund() public inState(State.Refunding) {
673     uint256 weiValue = investedAmountOf[msg.sender];
674     if (weiValue == 0) throw;
675     investedAmountOf[msg.sender] = 0;
676     weiRefunded = weiRefunded.plus(weiValue);
677     Refund(msg.sender, weiValue);
678     if (!msg.sender.send(weiValue)) throw;
679   }
680 
681   /**
682    * @return true if the crowdsale has raised enough money to be a successful.
683    */
684   function isMinimumGoalReached() public constant returns (bool reached) {
685     return weiRaised >= minimumFundingGoal;
686   }
687 
688   /**
689    * Check if the contract relationship looks good.
690    */
691   function isFinalizerSane() public constant returns (bool sane) {
692     return finalizeAgent.isSane();
693   }
694 
695   /**
696    * Check if the contract relationship looks good.
697    */
698   function isPricingSane() public constant returns (bool sane) {
699     return pricingStrategy.isSane(address(this));
700   }
701 
702   /**
703    * Crowdfund state machine management.
704    *
705    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
706    */
707   function getState() public constant returns (State) {
708     if(finalized) return State.Finalized;
709     else if (address(finalizeAgent) == 0) return State.Preparing;
710     else if (!finalizeAgent.isSane()) return State.Preparing;
711     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
712     else if (block.timestamp < startsAt) return State.PreFunding;
713     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
714     else if (isMinimumGoalReached()) return State.Success;
715     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
716     else return State.Failure;
717   }
718 
719   /** This is for manual testing of multisig wallet interaction */
720   function setOwnerTestValue(uint val) onlyOwner {
721     ownerTestValue = val;
722   }
723 
724   /** Interface marker. */
725   function isCrowdsale() public constant returns (bool) {
726     return true;
727   }
728 
729   //
730   // Modifiers
731   //
732 
733   /** Modified allowing execution only if the crowdsale is currently running.  */
734   modifier inState(State state) {
735     if(getState() != state) throw;
736     _;
737   }
738 
739 
740   //
741   // Abstract functions
742   //
743 
744   /**
745    * Check if the current invested breaks our cap rules.
746    *
747    *
748    * The child contract must define their own cap setting rules.
749    * We allow a lot of flexibility through different capping strategies (ETH, token count)
750    * Called from invest().
751    *
752    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
753    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
754    * @param weiRaisedTotal What would be our total raised balance after this transaction
755    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
756    *
757    * @return true if taking this investment would break our cap rules
758    */
759   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
760 
761   /**
762    * Check if the current crowdsale is full and we can no longer sell any tokens.
763    */
764   function isCrowdsaleFull() public constant returns (bool);
765 
766   /**
767    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
768    */
769   function assignTokens(address receiver, uint tokenAmount) private;
770 }
771 
772 
773 
774 
775 
776 
777 
778 /**
779  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
780  *
781  * Based on code by FirstBlood:
782  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
783  */
784 contract StandardToken is ERC20, SafeMath {
785 
786   /* Token supply got increased and a new owner received these tokens */
787   event Minted(address receiver, uint amount);
788 
789   /* Actual balances of token holders */
790   mapping(address => uint) balances;
791 
792   /* approve() allowances */
793   mapping (address => mapping (address => uint)) allowed;
794 
795   /* Interface declaration */
796   function isToken() public constant returns (bool weAre) {
797     return true;
798   }
799 
800   function transfer(address _to, uint _value) returns (bool success) {
801     balances[msg.sender] = safeSub(balances[msg.sender], _value);
802     balances[_to] = safeAdd(balances[_to], _value);
803     Transfer(msg.sender, _to, _value);
804     return true;
805   }
806 
807   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
808     uint _allowance = allowed[_from][msg.sender];
809 
810     balances[_to] = safeAdd(balances[_to], _value);
811     balances[_from] = safeSub(balances[_from], _value);
812     allowed[_from][msg.sender] = safeSub(_allowance, _value);
813     Transfer(_from, _to, _value);
814     return true;
815   }
816 
817   function balanceOf(address _owner) constant returns (uint balance) {
818     return balances[_owner];
819   }
820 
821   function approve(address _spender, uint _value) returns (bool success) {
822 
823     // To change the approve amount you first have to reduce the addresses`
824     //  allowance to zero by calling `approve(_spender, 0)` if it is not
825     //  already 0 to mitigate the race condition described here:
826     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
827     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
828 
829     allowed[msg.sender][_spender] = _value;
830     Approval(msg.sender, _spender, _value);
831     return true;
832   }
833 
834   function allowance(address _owner, address _spender) constant returns (uint remaining) {
835     return allowed[_owner][_spender];
836   }
837 
838 }
839 
840 
841 
842 /**
843  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
844  *
845  * - Collect funds from pre-sale investors
846  * - Send funds to the crowdsale when it opens
847  * - Allow owner to set the crowdsale
848  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
849  * - Allow unlimited investors
850  * - Tokens are distributed on PreICOProxyBuyer smart contract first
851  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
852  * - All functions can be halted by owner if something goes wrong
853  *
854  */
855 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
856 
857   /** How many investors we have now */
858   uint public investorCount;
859 
860   /** How many wei we have raised totla. */
861   uint public weiRaisedTotal;
862 
863   /** Who are our investors (iterable) */
864   address[] public investors;
865 
866   /** How much they have invested */
867   mapping(address => uint) public balances;
868 
869   /** How many tokens investors have claimed */
870   mapping(address => uint) public claimed;
871 
872   /** When our refund freeze is over (UNIT timestamp) */
873   uint public freezeEndsAt;
874 
875   /** What is the minimum buy in */
876   uint public weiMinimumLimit;
877 
878   /** What is the maximum buy in */
879   uint public weiMaximumLimit;
880 
881   /** How many weis total we are allowed to collect. */
882   uint public weiCap;
883 
884   /** How many tokens were bought */
885   uint public tokensBought;
886 
887    /** How many investors have claimed their tokens */
888   uint public claimCount;
889 
890   uint public totalClaimed;
891 
892   /** Our ICO contract where we will move the funds */
893   Crowdsale public crowdsale;
894 
895   /** What is our current state. */
896   enum State{Unknown, Funding, Distributing, Refunding}
897 
898   /** Somebody loaded their investment money */
899   event Invested(address investor, uint value, uint128 customerId);
900 
901   /** Refund claimed */
902   event Refunded(address investor, uint value);
903 
904   /** We executed our buy */
905   event TokensBoughts(uint count);
906 
907   /** We distributed tokens to an investor */
908   event Distributed(address investors, uint count);
909 
910   /**
911    * Create presale contract where lock up period is given days
912    */
913   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
914 
915     owner = _owner;
916 
917     // Give argument
918     if(_freezeEndsAt == 0) {
919       throw;
920     }
921 
922     // Give argument
923     if(_weiMinimumLimit == 0) {
924       throw;
925     }
926 
927     if(_weiMaximumLimit == 0) {
928       throw;
929     }
930 
931     weiMinimumLimit = _weiMinimumLimit;
932     weiMaximumLimit = _weiMaximumLimit;
933     weiCap = _weiCap;
934     freezeEndsAt = _freezeEndsAt;
935   }
936 
937   /**
938    * Get the token we are distributing.
939    */
940   function getToken() public constant returns(FractionalERC20) {
941     if(address(crowdsale) == 0)  {
942       throw;
943     }
944 
945     return crowdsale.token();
946   }
947 
948   /**
949    * Participate to a presale.
950    */
951   function invest(uint128 customerId) private {
952 
953     // Cannot invest anymore through crowdsale when moving has begun
954     if(getState() != State.Funding) throw;
955 
956     if(msg.value == 0) throw; // No empty buys
957 
958     address investor = msg.sender;
959 
960     bool existing = balances[investor] > 0;
961 
962     balances[investor] = safeAdd(balances[investor], msg.value);
963 
964     // Need to satisfy minimum and maximum limits
965     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
966       throw;
967     }
968 
969     // This is a new investor
970     if(!existing) {
971       investors.push(investor);
972       investorCount++;
973     }
974 
975     weiRaisedTotal = safeAdd(weiRaisedTotal, msg.value);
976     if(weiRaisedTotal > weiCap) {
977       throw;
978     }
979 
980     Invested(investor, msg.value, customerId);
981   }
982 
983   function investWithId(uint128 customerId) public stopInEmergency payable {
984     invest(customerId);
985   }
986 
987   function investWithoutId() public stopInEmergency payable {
988     invest(0x0);
989   }
990 
991 
992   /**
993    * Load funds to the crowdsale for all investors.
994    *
995    *
996    */
997   function buyForEverybody() stopInEmergency public {
998 
999     if(getState() != State.Funding) {
1000       // Only allow buy once
1001       throw;
1002     }
1003 
1004     // Crowdsale not yet set
1005     if(address(crowdsale) == 0) throw;
1006 
1007     // Buy tokens on the contract
1008     crowdsale.invest.value(weiRaisedTotal)(address(this));
1009 
1010     // Record how many tokens we got
1011     tokensBought = getToken().balanceOf(address(this));
1012 
1013     if(tokensBought == 0) {
1014       // Did not get any tokens
1015       throw;
1016     }
1017 
1018     TokensBoughts(tokensBought);
1019   }
1020 
1021   /**
1022    * How may tokens each investor gets.
1023    */
1024   function getClaimAmount(address investor) public constant returns (uint) {
1025 
1026     // Claims can be only made if we manage to buy tokens
1027     if(getState() != State.Distributing) {
1028       throw;
1029     }
1030     return safeMul(balances[investor], tokensBought) / weiRaisedTotal;
1031   }
1032 
1033   /**
1034    * How many tokens remain unclaimed for an investor.
1035    */
1036   function getClaimLeft(address investor) public constant returns (uint) {
1037     return safeSub(getClaimAmount(investor), claimed[investor]);
1038   }
1039 
1040   /**
1041    * Claim all remaining tokens for this investor.
1042    */
1043   function claimAll() {
1044     claim(getClaimLeft(msg.sender));
1045   }
1046 
1047   /**
1048    * Claim N bought tokens to the investor as the msg sender.
1049    *
1050    */
1051   function claim(uint amount) stopInEmergency {
1052     address investor = msg.sender;
1053 
1054     if(amount == 0) {
1055       throw;
1056     }
1057 
1058     if(getClaimLeft(investor) < amount) {
1059       // Woops we cannot get more than we have left
1060       throw;
1061     }
1062 
1063     // We track who many investor have (partially) claimed their tokens
1064     if(claimed[investor] == 0) {
1065       claimCount++;
1066     }
1067 
1068     claimed[investor] = safeAdd(claimed[investor], amount);
1069     totalClaimed = safeAdd(totalClaimed, amount);
1070     getToken().transfer(investor, amount);
1071 
1072     Distributed(investor, amount);
1073   }
1074 
1075   /**
1076    * ICO never happened. Allow refund.
1077    */
1078   function refund() stopInEmergency {
1079 
1080     // Trying to ask refund too soon
1081     if(getState() != State.Refunding) throw;
1082 
1083     address investor = msg.sender;
1084     if(balances[investor] == 0) throw;
1085     uint amount = balances[investor];
1086     delete balances[investor];
1087     if(!(investor.call.value(amount)())) throw;
1088     Refunded(investor, amount);
1089   }
1090 
1091   /**
1092    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1093    */
1094   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1095     crowdsale = _crowdsale;
1096 
1097     // Check interface
1098     if(!crowdsale.isCrowdsale()) true;
1099   }
1100 
1101   /**
1102    * Resolve the contract umambigious state.
1103    */
1104   function getState() public returns(State) {
1105     if(tokensBought == 0) {
1106       if(now >= freezeEndsAt) {
1107          return State.Refunding;
1108       } else {
1109         return State.Funding;
1110       }
1111     } else {
1112       return State.Distributing;
1113     }
1114   }
1115 
1116   /** Explicitly call function from your wallet. */
1117   function() payable {
1118     throw;
1119   }
1120 }