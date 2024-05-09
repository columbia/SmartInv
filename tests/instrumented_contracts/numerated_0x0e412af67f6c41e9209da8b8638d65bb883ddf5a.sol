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
668    */
669   function refund() public inState(State.Refunding) {
670     uint256 weiValue = investedAmountOf[msg.sender];
671     if (weiValue == 0) throw;
672     investedAmountOf[msg.sender] = 0;
673     weiRefunded = weiRefunded.plus(weiValue);
674     Refund(msg.sender, weiValue);
675     if (!msg.sender.send(weiValue)) throw;
676   }
677 
678   /**
679    * @return true if the crowdsale has raised enough money to be a succes
680    */
681   function isMinimumGoalReached() public constant returns (bool reached) {
682     return weiRaised >= minimumFundingGoal;
683   }
684 
685   /**
686    * Check if the contract relationship looks good.
687    */
688   function isFinalizerSane() public constant returns (bool sane) {
689     return finalizeAgent.isSane();
690   }
691 
692   /**
693    * Check if the contract relationship looks good.
694    */
695   function isPricingSane() public constant returns (bool sane) {
696     return pricingStrategy.isSane(address(this));
697   }
698 
699   /**
700    * Crowdfund state machine management.
701    *
702    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
703    */
704   function getState() public constant returns (State) {
705     if(finalized) return State.Finalized;
706     else if (address(finalizeAgent) == 0) return State.Preparing;
707     else if (!finalizeAgent.isSane()) return State.Preparing;
708     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
709     else if (block.timestamp < startsAt) return State.PreFunding;
710     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
711     else if (isMinimumGoalReached()) return State.Success;
712     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
713     else return State.Failure;
714   }
715 
716   /** This is for manual testing of multisig wallet interaction */
717   function setOwnerTestValue(uint val) onlyOwner {
718     ownerTestValue = val;
719   }
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
766   function assignTokens(address receiver, uint tokenAmount) private;
767 }
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
777  *
778  * Based on code by FirstBlood:
779  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
780  */
781 contract StandardToken is ERC20, SafeMath {
782 
783   /* Token supply got increased and a new owner received these tokens */
784   event Minted(address receiver, uint amount);
785 
786   /* Actual balances of token holders */
787   mapping(address => uint) balances;
788 
789   /* approve() allowances */
790   mapping (address => mapping (address => uint)) allowed;
791 
792   /* Interface declaration */
793   function isToken() public constant returns (bool weAre) {
794     return true;
795   }
796 
797   /**
798    *
799    * Fix for the ERC20 short address attack
800    *
801    * http://vessenes.com/the-erc20-short-address-attack-explained/
802    */
803   modifier onlyPayloadSize(uint size) {
804      if(msg.data.length < size + 4) {
805        throw;
806      }
807      _;
808   }
809 
810   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
811     balances[msg.sender] = safeSub(balances[msg.sender], _value);
812     balances[_to] = safeAdd(balances[_to], _value);
813     Transfer(msg.sender, _to, _value);
814     return true;
815   }
816 
817   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
818     uint _allowance = allowed[_from][msg.sender];
819 
820     balances[_to] = safeAdd(balances[_to], _value);
821     balances[_from] = safeSub(balances[_from], _value);
822     allowed[_from][msg.sender] = safeSub(_allowance, _value);
823     Transfer(_from, _to, _value);
824     return true;
825   }
826 
827   function balanceOf(address _owner) constant returns (uint balance) {
828     return balances[_owner];
829   }
830 
831   function approve(address _spender, uint _value) returns (bool success) {
832 
833     // To change the approve amount you first have to reduce the addresses`
834     //  allowance to zero by calling `approve(_spender, 0)` if it is not
835     //  already 0 to mitigate the race condition described here:
836     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
837     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
838 
839     allowed[msg.sender][_spender] = _value;
840     Approval(msg.sender, _spender, _value);
841     return true;
842   }
843 
844   function allowance(address _owner, address _spender) constant returns (uint remaining) {
845     return allowed[_owner][_spender];
846   }
847 
848 }
849 
850 
851 
852 /**
853  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
854  *
855  * - Collect funds from pre-sale investors
856  * - Send funds to the crowdsale when it opens
857  * - Allow owner to set the crowdsale
858  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
859  * - Allow unlimited investors
860  * - Tokens are distributed on PreICOProxyBuyer smart contract first
861  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
862  * - All functions can be halted by owner if something goes wrong
863  *
864  */
865 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
866 
867   /** How many investors we have now */
868   uint public investorCount;
869 
870   /** How many wei we have raised totla. */
871   uint public weiRaisedTotal;
872 
873   /** Who are our investors (iterable) */
874   address[] public investors;
875 
876   /** How much they have invested */
877   mapping(address => uint) public balances;
878 
879   /** How many tokens investors have claimed */
880   mapping(address => uint) public claimed;
881 
882   /** When our refund freeze is over (UNIT timestamp) */
883   uint public freezeEndsAt;
884 
885   /** What is the minimum buy in */
886   uint public weiMinimumLimit;
887 
888   /** How many weis total we are allowed to collect. */
889   uint public weiCap;
890 
891   /** How many tokens were bought */
892   uint public tokensBought;
893 
894    /** How many investors have claimed their tokens */
895   uint public claimCount;
896 
897   uint public totalClaimed;
898 
899   /** Our ICO contract where we will move the funds */
900   Crowdsale public crowdsale;
901 
902   /** What is our current state. */
903   enum State{Unknown, Funding, Distributing, Refunding}
904 
905   /** Somebody loaded their investment money */
906   event Invested(address investor, uint value);
907 
908   /** Refund claimed */
909   event Refunded(address investor, uint value);
910 
911   /** We executed our buy */
912   event TokensBoughts(uint count);
913 
914   /** We distributed tokens to an investor */
915   event Distributed(address investors, uint count);
916 
917   /**
918    * Create presale contract where lock up period is given days
919    */
920   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiCap) {
921 
922     owner = _owner;
923 
924     // Give argument
925     if(_freezeEndsAt == 0) {
926       throw;
927     }
928 
929     // Give argument
930     if(_weiMinimumLimit == 0) {
931       throw;
932     }
933 
934     weiMinimumLimit = _weiMinimumLimit;
935     weiCap = _weiCap;
936     freezeEndsAt = _freezeEndsAt;
937   }
938 
939   /**
940    * Get the token we are distributing.
941    */
942   function getToken() public constant returns(FractionalERC20) {
943     if(address(crowdsale) == 0)  {
944       throw;
945     }
946 
947     return crowdsale.token();
948   }
949 
950   /**
951    * Participate to a presale.
952    */
953   function invest() public stopInEmergency payable {
954 
955     // Cannot invest anymore through crowdsale when moving has begun
956     if(getState() != State.Funding) throw;
957 
958     if(msg.value == 0) throw; // No empty buys
959 
960     address investor = msg.sender;
961 
962     bool existing = balances[investor] > 0;
963 
964     balances[investor] = safeAdd(balances[investor], msg.value);
965 
966     // Need to fulfill minimum limit
967     if(balances[investor] < weiMinimumLimit) {
968       throw;
969     }
970 
971     // This is a new investor
972     if(!existing) {
973       investors.push(investor);
974       investorCount++;
975     }
976 
977     weiRaisedTotal = safeAdd(weiRaisedTotal, msg.value);
978     if(weiRaisedTotal > weiCap) {
979       throw;
980     }
981 
982     Invested(investor, msg.value);
983   }
984 
985   /**
986    * Load funds to the crowdsale for all investors.
987    *
988    *
989    */
990   function buyForEverybody() stopInEmergency public {
991 
992     if(getState() != State.Funding) {
993       // Only allow buy once
994       throw;
995     }
996 
997     // Crowdsale not yet set
998     if(address(crowdsale) == 0) throw;
999 
1000     // Buy tokens on the contract
1001     crowdsale.invest.value(weiRaisedTotal)(address(this));
1002 
1003     // Record how many tokens we got
1004     tokensBought = getToken().balanceOf(address(this));
1005 
1006     if(tokensBought == 0) {
1007       // Did not get any tokens
1008       throw;
1009     }
1010 
1011     TokensBoughts(tokensBought);
1012   }
1013 
1014   /**
1015    * How may tokens each investor gets.
1016    */
1017   function getClaimAmount(address investor) public constant returns (uint) {
1018 
1019     // Claims can be only made if we manage to buy tokens
1020     if(getState() != State.Distributing) {
1021       throw;
1022     }
1023     return safeMul(balances[investor], tokensBought) / weiRaisedTotal;
1024   }
1025 
1026   /**
1027    * How many tokens remain unclaimed for an investor.
1028    */
1029   function getClaimLeft(address investor) public constant returns (uint) {
1030     return safeSub(getClaimAmount(investor), claimed[investor]);
1031   }
1032 
1033   /**
1034    * Claim all remaining tokens for this investor.
1035    */
1036   function claimAll() {
1037     claim(getClaimLeft(msg.sender));
1038   }
1039 
1040   /**
1041    * Claim N bought tokens to the investor as the msg sender.
1042    *
1043    */
1044   function claim(uint amount) stopInEmergency {
1045     address investor = msg.sender;
1046 
1047     if(amount == 0) {
1048       throw;
1049     }
1050 
1051     if(getClaimLeft(investor) < amount) {
1052       // Woops we cannot get more than we have left
1053       throw;
1054     }
1055 
1056     // We track who many investor have (partially) claimed their tokens
1057     if(claimed[investor] == 0) {
1058       claimCount++;
1059     }
1060 
1061     claimed[investor] = safeAdd(claimed[investor], amount);
1062     totalClaimed = safeAdd(totalClaimed, amount);
1063     getToken().transfer(investor, amount);
1064 
1065     Distributed(investor, amount);
1066   }
1067 
1068   /**
1069    * ICO never happened. Allow refund.
1070    */
1071   function refund() stopInEmergency {
1072 
1073     // Trying to ask refund too soon
1074     if(getState() != State.Refunding) throw;
1075 
1076     address investor = msg.sender;
1077     if(balances[investor] == 0) throw;
1078     uint amount = balances[investor];
1079     delete balances[investor];
1080     // This was originally "send()" but was replaced with call.value()() to
1081     // forward gas, if there happens to be a complicated multisig implementation
1082     // which would need more gas than the gas stipend:
1083     if(!(investor.call.value(amount)())) throw;
1084     Refunded(investor, amount);
1085   }
1086 
1087   /**
1088    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1089    */
1090   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1091     crowdsale = _crowdsale;
1092 
1093     // Check interface
1094     if(!crowdsale.isCrowdsale()) true;
1095   }
1096 
1097   /**
1098    * Resolve the contract umambigious state.
1099    */
1100   function getState() public returns(State) {
1101     if(tokensBought == 0) {
1102       if(now >= freezeEndsAt) {
1103          return State.Refunding;
1104       } else {
1105         return State.Funding;
1106       }
1107     } else {
1108       return State.Distributing;
1109     }
1110   }
1111 
1112   /** Explicitly call function from your wallet. */
1113   function() payable {
1114     throw;
1115   }
1116 }