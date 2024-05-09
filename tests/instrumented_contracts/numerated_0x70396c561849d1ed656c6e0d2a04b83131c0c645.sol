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
441 
442     // Check that we did not bust the cap
443     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
444       throw;
445     }
446 
447     assignTokens(receiver, tokenAmount);
448 
449     // Pocket the money
450     if(!multisigWallet.send(weiAmount)) throw;
451 
452     // Tell us invest was success
453     Invested(receiver, weiAmount, tokenAmount, customerId);
454 
455   }
456 
457   /**
458    * Preallocate tokens for the early investors.
459    *
460    * Preallocated tokens have been sold before the actual crowdsale opens.
461    * This function mints the tokens and moves the crowdsale needle.
462    *
463    * Investor count is not handled; it is assumed this goes for multiple investors
464    * and the token distribution happens outside the smart contract flow.
465    *
466    * No money is exchanged, as the crowdsale team already have received the payment.
467    *
468    * @param fullTokens tokens as full tokens - decimal places added internally
469    * @param weiPrice Price of a single full token in wei
470    *
471    */
472   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
473 
474     uint tokenAmount = fullTokens * 10**token.decimals();
475     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
476 
477     weiRaised = weiRaised.plus(weiAmount);
478     tokensSold = tokensSold.plus(tokenAmount);
479 
480     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
481     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
482 
483     assignTokens(receiver, tokenAmount);
484 
485     // Tell us invest was success
486     Invested(receiver, weiAmount, tokenAmount, 0);
487   }
488 
489   /**
490    * Allow anonymous contributions to this crowdsale.
491    */
492   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
493      bytes32 hash = sha256(addr);
494      if (ecrecover(hash, v, r, s) != signerAddress) throw;
495      if(customerId == 0) throw;  // UUIDv4 sanity check
496      investInternal(addr, customerId);
497   }
498 
499   /**
500    * Track who is the customer making the payment so we can send thank you email.
501    */
502   function investWithCustomerId(address addr, uint128 customerId) public payable {
503     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
504     if(customerId == 0) throw;  // UUIDv4 sanity check
505     investInternal(addr, customerId);
506   }
507 
508   /**
509    * Allow anonymous contributions to this crowdsale.
510    */
511   function invest(address addr) public payable {
512     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
513     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
514     investInternal(addr, 0);
515   }
516 
517   /**
518    * Invest to tokens, recognize the payer and clear his address.
519    *
520    */
521   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
522     investWithSignedAddress(msg.sender, customerId, v, r, s);
523   }
524 
525   /**
526    * Invest to tokens, recognize the payer.
527    *
528    */
529   function buyWithCustomerId(uint128 customerId) public payable {
530     investWithCustomerId(msg.sender, customerId);
531   }
532 
533   /**
534    * The basic entry point to participate the crowdsale process.
535    *
536    * Pay for funding, get invested tokens back in the sender address.
537    */
538   function buy() public payable {
539     invest(msg.sender);
540   }
541 
542   /**
543    * Finalize a succcesful crowdsale.
544    *
545    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
546    */
547   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
548 
549     // Already finalized
550     if(finalized) {
551       throw;
552     }
553 
554     // Finalizing is optional. We only call it if we are given a finalizing agent.
555     if(address(finalizeAgent) != 0) {
556       finalizeAgent.finalizeCrowdsale();
557     }
558 
559     finalized = true;
560   }
561 
562   /**
563    * Allow to (re)set finalize agent.
564    *
565    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
566    */
567   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
568     finalizeAgent = addr;
569 
570     // Don't allow setting bad agent
571     if(!finalizeAgent.isFinalizeAgent()) {
572       throw;
573     }
574   }
575 
576   /**
577    * Set policy do we need to have server-side customer ids for the investments.
578    *
579    */
580   function setRequireCustomerId(bool value) onlyOwner {
581     requireCustomerId = value;
582     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
583   }
584 
585   /**
586    * Set policy if all investors must be cleared on the server side first.
587    *
588    * This is e.g. for the accredited investor clearing.
589    *
590    */
591   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
592     requiredSignedAddress = value;
593     signerAddress = _signerAddress;
594     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
595   }
596 
597   /**
598    * Allow addresses to do early participation.
599    *
600    * TODO: Fix spelling error in the name
601    */
602   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
603     earlyParticipantWhitelist[addr] = status;
604     Whitelisted(addr, status);
605   }
606 
607   /**
608    * Allow crowdsale owner to close early or extend the crowdsale.
609    *
610    * This is useful e.g. for a manual soft cap implementation:
611    * - after X amount is reached determine manual closing
612    *
613    * This may put the crowdsale to an invalid state,
614    * but we trust owners know what they are doing.
615    *
616    */
617   function setEndsAt(uint time) onlyOwner {
618 
619     if(now > time) {
620       throw; // Don't change past
621     }
622 
623     endsAt = time;
624     EndsAtChanged(endsAt);
625   }
626 
627   /**
628    * Allow to (re)set pricing strategy.
629    *
630    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
631    */
632   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
633     pricingStrategy = _pricingStrategy;
634 
635     // Don't allow setting bad agent
636     if(!pricingStrategy.isPricingStrategy()) {
637       throw;
638     }
639   }
640 
641   /**
642    * Allow to change the team multisig address in the case of emergency.
643    *
644    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
645    * (we have done only few test transactions). After the crowdsale is going
646    * then multisig address stays locked for the safety reasons.
647    */
648   function setMultisig(address addr) public onlyOwner {
649 
650     // Change
651     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
652       throw;
653     }
654 
655     multisigWallet = addr;
656   }
657 
658   /**
659    * Allow load refunds back on the contract for the refunding.
660    *
661    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
662    */
663   function loadRefund() public payable inState(State.Failure) {
664     if(msg.value == 0) throw;
665     loadedRefund = loadedRefund.plus(msg.value);
666   }
667 
668   /**
669    * Investors can claim refund.
670    *
671    * Note that any refunds from proxy buyers should be handled separately,
672    * and not through this contract.
673    */
674   function refund() public inState(State.Refunding) {
675     uint256 weiValue = investedAmountOf[msg.sender];
676     if (weiValue == 0) throw;
677     investedAmountOf[msg.sender] = 0;
678     weiRefunded = weiRefunded.plus(weiValue);
679     Refund(msg.sender, weiValue);
680     if (!msg.sender.send(weiValue)) throw;
681   }
682 
683   /**
684    * @return true if the crowdsale has raised enough money to be a successful.
685    */
686   function isMinimumGoalReached() public constant returns (bool reached) {
687     return weiRaised >= minimumFundingGoal;
688   }
689 
690   /**
691    * Check if the contract relationship looks good.
692    */
693   function isFinalizerSane() public constant returns (bool sane) {
694     return finalizeAgent.isSane();
695   }
696 
697   /**
698    * Check if the contract relationship looks good.
699    */
700   function isPricingSane() public constant returns (bool sane) {
701     return pricingStrategy.isSane(address(this));
702   }
703 
704   /**
705    * Crowdfund state machine management.
706    *
707    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
708    */
709   function getState() public constant returns (State) {
710     if(finalized) return State.Finalized;
711     else if (address(finalizeAgent) == 0) return State.Preparing;
712     else if (!finalizeAgent.isSane()) return State.Preparing;
713     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
714     else if (block.timestamp < startsAt) return State.PreFunding;
715     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
716     else if (isMinimumGoalReached()) return State.Success;
717     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
718     else return State.Failure;
719   }
720 
721   /** This is for manual testing of multisig wallet interaction */
722   function setOwnerTestValue(uint val) onlyOwner {
723     ownerTestValue = val;
724   }
725 
726   /** Interface marker. */
727   function isCrowdsale() public constant returns (bool) {
728     return true;
729   }
730 
731   //
732   // Modifiers
733   //
734 
735   /** Modified allowing execution only if the crowdsale is currently running.  */
736   modifier inState(State state) {
737     if(getState() != state) throw;
738     _;
739   }
740 
741 
742   //
743   // Abstract functions
744   //
745 
746   /**
747    * Check if the current invested breaks our cap rules.
748    *
749    *
750    * The child contract must define their own cap setting rules.
751    * We allow a lot of flexibility through different capping strategies (ETH, token count)
752    * Called from invest().
753    *
754    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
755    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
756    * @param weiRaisedTotal What would be our total raised balance after this transaction
757    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
758    *
759    * @return true if taking this investment would break our cap rules
760    */
761   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
762 
763   /**
764    * Check if the current crowdsale is full and we can no longer sell any tokens.
765    */
766   function isCrowdsaleFull() public constant returns (bool);
767 
768   /**
769    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
770    */
771   function assignTokens(address receiver, uint tokenAmount) private;
772 }
773 
774 
775 
776 
777 
778 
779 
780 /**
781  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
782  *
783  * Based on code by FirstBlood:
784  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
785  */
786 contract StandardToken is ERC20, SafeMath {
787 
788   /* Token supply got increased and a new owner received these tokens */
789   event Minted(address receiver, uint amount);
790 
791   /* Actual balances of token holders */
792   mapping(address => uint) balances;
793 
794   /* approve() allowances */
795   mapping (address => mapping (address => uint)) allowed;
796 
797   /* Interface declaration */
798   function isToken() public constant returns (bool weAre) {
799     return true;
800   }
801 
802   function transfer(address _to, uint _value) returns (bool success) {
803     balances[msg.sender] = safeSub(balances[msg.sender], _value);
804     balances[_to] = safeAdd(balances[_to], _value);
805     Transfer(msg.sender, _to, _value);
806     return true;
807   }
808 
809   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
810     uint _allowance = allowed[_from][msg.sender];
811 
812     balances[_to] = safeAdd(balances[_to], _value);
813     balances[_from] = safeSub(balances[_from], _value);
814     allowed[_from][msg.sender] = safeSub(_allowance, _value);
815     Transfer(_from, _to, _value);
816     return true;
817   }
818 
819   function balanceOf(address _owner) constant returns (uint balance) {
820     return balances[_owner];
821   }
822 
823   function approve(address _spender, uint _value) returns (bool success) {
824 
825     // To change the approve amount you first have to reduce the addresses`
826     //  allowance to zero by calling `approve(_spender, 0)` if it is not
827     //  already 0 to mitigate the race condition described here:
828     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
829     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
830 
831     allowed[msg.sender][_spender] = _value;
832     Approval(msg.sender, _spender, _value);
833     return true;
834   }
835 
836   function allowance(address _owner, address _spender) constant returns (uint remaining) {
837     return allowed[_owner][_spender];
838   }
839 
840 }
841 
842 
843 
844 /**
845  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
846  *
847  * - Collect funds from pre-sale investors
848  * - Send funds to the crowdsale when it opens
849  * - Allow owner to set the crowdsale
850  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
851  * - Allow unlimited investors
852  * - Tokens are distributed on PreICOProxyBuyer smart contract first
853  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
854  * - All functions can be halted by owner if something goes wrong
855  *
856  */
857 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
858 
859   /** How many investors we have now */
860   uint public investorCount;
861 
862   /** How many wei we have raised totla. */
863   uint public weiRaisedTotal;
864 
865   /** Who are our investors (iterable) */
866   address[] public investors;
867 
868   /** How much they have invested */
869   mapping(address => uint) public balances;
870 
871   /** How many tokens investors have claimed */
872   mapping(address => uint) public claimed;
873 
874   /** When our refund freeze is over (UNIT timestamp) */
875   uint public freezeEndsAt;
876 
877   /** What is the minimum buy in */
878   uint public weiMinimumLimit;
879 
880   /** What is the maximum buy in */
881   uint public weiMaximumLimit;
882 
883   /** How many weis total we are allowed to collect. */
884   uint public weiCap;
885 
886   /** How many tokens were bought */
887   uint public tokensBought;
888 
889    /** How many investors have claimed their tokens */
890   uint public claimCount;
891 
892   uint public totalClaimed;
893 
894   /** Our ICO contract where we will move the funds */
895   Crowdsale public crowdsale;
896 
897   /** What is our current state. */
898   enum State{Unknown, Funding, Distributing, Refunding}
899 
900   /** Somebody loaded their investment money */
901   event Invested(address investor, uint value, uint128 customerId);
902 
903   /** Refund claimed */
904   event Refunded(address investor, uint value);
905 
906   /** We executed our buy */
907   event TokensBoughts(uint count);
908 
909   /** We distributed tokens to an investor */
910   event Distributed(address investors, uint count);
911 
912   /**
913    * Create presale contract where lock up period is given days
914    */
915   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
916 
917     owner = _owner;
918 
919     // Give argument
920     if(_freezeEndsAt == 0) {
921       throw;
922     }
923 
924     // Give argument
925     if(_weiMinimumLimit == 0) {
926       throw;
927     }
928 
929     if(_weiMaximumLimit == 0) {
930       throw;
931     }
932 
933     weiMinimumLimit = _weiMinimumLimit;
934     weiMaximumLimit = _weiMaximumLimit;
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
953   function invest(uint128 customerId) private {
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
966     // Need to satisfy minimum and maximum limits
967     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
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
982     Invested(investor, msg.value, customerId);
983   }
984 
985   function investWithId(uint128 customerId) public stopInEmergency payable {
986     invest(customerId);
987   }
988 
989   function investWithoutId() public stopInEmergency payable {
990     invest(0x0);
991   }
992 
993 
994   /**
995    * Load funds to the crowdsale for all investors.
996    *
997    *
998    */
999   function buyForEverybody() stopInEmergency public {
1000 
1001     if(getState() != State.Funding) {
1002       // Only allow buy once
1003       throw;
1004     }
1005 
1006     // Crowdsale not yet set
1007     if(address(crowdsale) == 0) throw;
1008 
1009     // Buy tokens on the contract
1010     crowdsale.invest.value(weiRaisedTotal)(address(this));
1011 
1012     // Record how many tokens we got
1013     tokensBought = getToken().balanceOf(address(this));
1014 
1015     if(tokensBought == 0) {
1016       // Did not get any tokens
1017       throw;
1018     }
1019 
1020     TokensBoughts(tokensBought);
1021   }
1022 
1023   /**
1024    * How may tokens each investor gets.
1025    */
1026   function getClaimAmount(address investor) public constant returns (uint) {
1027 
1028     // Claims can be only made if we manage to buy tokens
1029     if(getState() != State.Distributing) {
1030       throw;
1031     }
1032     return safeMul(balances[investor], tokensBought) / weiRaisedTotal;
1033   }
1034 
1035   /**
1036    * How many tokens remain unclaimed for an investor.
1037    */
1038   function getClaimLeft(address investor) public constant returns (uint) {
1039     return safeSub(getClaimAmount(investor), claimed[investor]);
1040   }
1041 
1042   /**
1043    * Claim all remaining tokens for this investor.
1044    */
1045   function claimAll() {
1046     claim(getClaimLeft(msg.sender));
1047   }
1048 
1049   /**
1050    * Claim N bought tokens to the investor as the msg sender.
1051    *
1052    */
1053   function claim(uint amount) stopInEmergency {
1054     address investor = msg.sender;
1055 
1056     if(amount == 0) {
1057       throw;
1058     }
1059 
1060     if(getClaimLeft(investor) < amount) {
1061       // Woops we cannot get more than we have left
1062       throw;
1063     }
1064 
1065     // We track who many investor have (partially) claimed their tokens
1066     if(claimed[investor] == 0) {
1067       claimCount++;
1068     }
1069 
1070     claimed[investor] = safeAdd(claimed[investor], amount);
1071     totalClaimed = safeAdd(totalClaimed, amount);
1072     getToken().transfer(investor, amount);
1073 
1074     Distributed(investor, amount);
1075   }
1076 
1077   /**
1078    * ICO never happened. Allow refund.
1079    */
1080   function refund() stopInEmergency {
1081 
1082     // Trying to ask refund too soon
1083     if(getState() != State.Refunding) throw;
1084 
1085     address investor = msg.sender;
1086     if(balances[investor] == 0) throw;
1087     uint amount = balances[investor];
1088     delete balances[investor];
1089     // This was originally "send()" but was replaced with call.value()() to
1090     // forward gas, if there happens to be a complicated multisig implementation
1091     // which would need more gas than the gas stipend:
1092     if(!(investor.call.value(amount)())) throw;
1093     Refunded(investor, amount);
1094   }
1095 
1096   /**
1097    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1098    */
1099   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1100     crowdsale = _crowdsale;
1101 
1102     // Check interface
1103     if(!crowdsale.isCrowdsale()) true;
1104   }
1105 
1106   /**
1107    * Resolve the contract umambigious state.
1108    */
1109   function getState() public returns(State) {
1110     if(tokensBought == 0) {
1111       if(now >= freezeEndsAt) {
1112          return State.Refunding;
1113       } else {
1114         return State.Funding;
1115       }
1116     } else {
1117       return State.Distributing;
1118     }
1119   }
1120 
1121   /** Explicitly call function from your wallet. */
1122   function() payable {
1123     throw;
1124   }
1125 }