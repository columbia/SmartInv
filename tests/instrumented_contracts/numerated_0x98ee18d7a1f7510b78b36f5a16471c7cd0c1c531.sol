1 /**
2  * Safe unsigned safe math.
3  *
4  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
5  *
6  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
7  *
8  * Maintained here until merged to mainline zeppelin-solidity.
9  *
10  */
11 library SafeMathLib {
12 
13   function times(uint a, uint b) returns (uint) {
14     uint c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function minus(uint a, uint b) returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function plus(uint a, uint b) returns (uint) {
25     uint c = a + b;
26     assert(c>=a);
27     return c;
28   }
29 
30   function assert(bool assertion) private {
31     if (!assertion) throw;
32   }
33 }
34 
35 
36 
37 
38 /*
39  * Ownable
40  *
41  * Base contract with an owner.
42  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
43  */
44 contract Ownable {
45   address public owner;
46 
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51   modifier onlyOwner() {
52     if (msg.sender != owner) {
53       throw;
54     }
55     _;
56   }
57 
58   function transferOwnership(address newOwner) onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 
66 
67 /*
68  * Haltable
69  *
70  * Abstract contract that allows children to implement an
71  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
72  *
73  *
74  * Originally envisioned in FirstBlood ICO contract.
75  */
76 contract Haltable is Ownable {
77   bool public halted;
78 
79   modifier stopInEmergency {
80     if (halted) throw;
81     _;
82   }
83 
84   modifier onlyInEmergency {
85     if (!halted) throw;
86     _;
87   }
88 
89   // called by the owner on emergency, triggers stopped state
90   function halt() external onlyOwner {
91     halted = true;
92   }
93 
94   // called by the owner on end of emergency, returns to normal state
95   function unhalt() external onlyOwner onlyInEmergency {
96     halted = false;
97   }
98 
99 }
100 
101 
102 /**
103  * Interface for defining crowdsale pricing.
104  */
105 contract PricingStrategy {
106 
107   /** Interface declaration. */
108   function isPricingStrategy() public constant returns (bool) {
109     return true;
110   }
111 
112   /** Self check if all references are correctly set.
113    *
114    * Checks that pricing strategy matches crowdsale parameters.
115    */
116   function isSane(address crowdsale) public constant returns (bool) {
117     return true;
118   }
119 
120   /**
121    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
122    *
123    *
124    * @param value - What is the value of the transaction send in as wei
125    * @param tokensSold - how much tokens have been sold this far
126    * @param weiRaised - how much money has been raised this far
127    * @param msgSender - who is the investor of this transaction
128    * @param decimals - how many decimal units the token has
129    * @return Amount of tokens the investor receives
130    */
131   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
132 }
133 
134 
135 /**
136  * Finalize agent defines what happens at the end of succeseful crowdsale.
137  *
138  * - Allocate tokens for founders, bounties and community
139  * - Make tokens transferable
140  * - etc.
141  */
142 contract FinalizeAgent {
143 
144   function isFinalizeAgent() public constant returns(bool) {
145     return true;
146   }
147 
148   /** Return true if we can run finalizeCrowdsale() properly.
149    *
150    * This is a safety check function that doesn't allow crowdsale to begin
151    * unless the finalizer has been set up properly.
152    */
153   function isSane() public constant returns (bool);
154 
155   /** Called once by crowdsale finalize() if the sale was success. */
156   function finalizeCrowdsale();
157 
158 }
159 
160 
161 
162 
163 /*
164  * ERC20 interface
165  * see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 {
168   uint public totalSupply;
169   function balanceOf(address who) constant returns (uint);
170   function allowance(address owner, address spender) constant returns (uint);
171 
172   function transfer(address to, uint value) returns (bool ok);
173   function transferFrom(address from, address to, uint value) returns (bool ok);
174   function approve(address spender, uint value) returns (bool ok);
175   event Transfer(address indexed from, address indexed to, uint value);
176   event Approval(address indexed owner, address indexed spender, uint value);
177 }
178 
179 
180 /**
181  * A token that defines fractional units as decimals.
182  */
183 contract FractionalERC20 is ERC20 {
184 
185   uint public decimals;
186 
187 }
188 
189 
190 
191 /**
192  * Abstract base contract for token sales.
193  *
194  * Handle
195  * - start and end dates
196  * - accepting investments
197  * - minimum funding goal and refund
198  * - various statistics during the crowdfund
199  * - different pricing strategies
200  * - different investment policies (require server side customer id, allow only whitelisted addresses)
201  *
202  */
203 contract Crowdsale is Haltable {
204 
205   /* Max investment count when we are still allowed to change the multisig address */
206   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
207 
208   using SafeMathLib for uint;
209 
210   /* The token we are selling */
211   FractionalERC20 public token;
212 
213   /* How we are going to price our offering */
214   PricingStrategy public pricingStrategy;
215 
216   /* Post-success callback */
217   FinalizeAgent public finalizeAgent;
218 
219   /* tokens will be transfered from this address */
220   address public multisigWallet;
221 
222   /* if the funding goal is not reached, investors may withdraw their funds */
223   uint public minimumFundingGoal;
224 
225   /* the UNIX timestamp start date of the crowdsale */
226   uint public startsAt;
227 
228   /* the UNIX timestamp end date of the crowdsale */
229   uint public endsAt;
230 
231   /* the number of tokens already sold through this contract*/
232   uint public tokensSold = 0;
233 
234   /* How many wei of funding we have raised */
235   uint public weiRaised = 0;
236 
237   /* How many distinct addresses have invested */
238   uint public investorCount = 0;
239 
240   /* How much wei we have returned back to the contract after a failed crowdfund. */
241   uint public loadedRefund = 0;
242 
243   /* How much wei we have given back to investors.*/
244   uint public weiRefunded = 0;
245 
246   /* Has this crowdsale been finalized */
247   bool public finalized;
248 
249   /* Do we need to have unique contributor id for each customer */
250   bool public requireCustomerId;
251 
252   /**
253     * Do we verify that contributor has been cleared on the server side (accredited investors only).
254     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
255     */
256   bool public requiredSignedAddress;
257 
258   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
259   address public signerAddress;
260 
261   /** How much ETH each address has invested to this crowdsale */
262   mapping (address => uint256) public investedAmountOf;
263 
264   /** How much tokens this crowdsale has credited for each investor address */
265   mapping (address => uint256) public tokenAmountOf;
266 
267   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
268   mapping (address => bool) public earlyParticipantWhitelist;
269 
270   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
271   uint public ownerTestValue;
272 
273   /** State machine
274    *
275    * - Preparing: All contract initialization calls and variables have not been set yet
276    * - Prefunding: We have not passed start time yet
277    * - Funding: Active crowdsale
278    * - Success: Minimum funding goal reached
279    * - Failure: Minimum funding goal not reached before ending time
280    * - Finalized: The finalized has been called and succesfully executed
281    * - Refunding: Refunds are loaded on the contract for reclaim.
282    */
283   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
284 
285   // A new investment was made
286   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
287 
288   // Refund was processed for a contributor
289   event Refund(address investor, uint weiAmount);
290 
291   // The rules were changed what kind of investments we accept
292   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
293 
294   // Address early participation whitelist status changed
295   event Whitelisted(address addr, bool status);
296 
297   // Crowdsale end time has been changed
298   event EndsAtChanged(uint endsAt);
299 
300   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
301 
302     owner = msg.sender;
303 
304     token = FractionalERC20(_token);
305 
306     setPricingStrategy(_pricingStrategy);
307 
308     multisigWallet = _multisigWallet;
309     if(multisigWallet == 0) {
310         throw;
311     }
312 
313     if(_start == 0) {
314         throw;
315     }
316 
317     startsAt = _start;
318 
319     if(_end == 0) {
320         throw;
321     }
322 
323     endsAt = _end;
324 
325     // Don't mess the dates
326     if(startsAt >= endsAt) {
327         throw;
328     }
329 
330     // Minimum funding goal can be zero
331     minimumFundingGoal = _minimumFundingGoal;
332   }
333 
334   /**
335    * Don't expect to just send in money and get tokens.
336    */
337   function() payable {
338     throw;
339   }
340 
341   /**
342    * Make an investment.
343    *
344    * Crowdsale must be running for one to invest.
345    * We must have not pressed the emergency brake.
346    *
347    * @param receiver The Ethereum address who receives the tokens
348    * @param customerId (optional) UUID v4 to track the successful payments on the server side
349    *
350    */
351   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
352 
353     // Determine if it's a good time to accept investment from this participant
354     if(getState() == State.PreFunding) {
355       // Are we whitelisted for early deposit
356       if(!earlyParticipantWhitelist[receiver]) {
357         throw;
358       }
359     } else if(getState() == State.Funding) {
360       // Retail participants can only come in when the crowdsale is running
361       // pass
362     } else {
363       // Unwanted state
364       throw;
365     }
366 
367     uint weiAmount = msg.value;
368     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
369 
370     if(tokenAmount == 0) {
371       // Dust transaction
372       throw;
373     }
374 
375     if(investedAmountOf[receiver] == 0) {
376        // A new investor
377        investorCount++;
378     }
379 
380     // Update investor
381     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
382     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
383 
384     // Update totals
385     weiRaised = weiRaised.plus(weiAmount);
386     tokensSold = tokensSold.plus(tokenAmount);
387 
388 
389     // Check that we did not bust the cap
390     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
391       throw;
392     }
393 
394     assignTokens(receiver, tokenAmount);
395 
396     // Pocket the money
397     if(!multisigWallet.send(weiAmount)) throw;
398 
399     // Tell us invest was success
400     Invested(receiver, weiAmount, tokenAmount, customerId);
401 
402   }
403 
404   /**
405    * Preallocate tokens for the early investors.
406    *
407    * Preallocated tokens have been sold before the actual crowdsale opens.
408    * This function mints the tokens and moves the crowdsale needle.
409    *
410    * Investor count is not handled; it is assumed this goes for multiple investors
411    * and the token distribution happens outside the smart contract flow.
412    *
413    * No money is exchanged, as the crowdsale team already have received the payment.
414    *
415    * @param fullTokens tokens as full tokens - decimal places added internally
416    * @param weiPrice Price of a single full token in wei
417    *
418    */
419   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
420 
421     uint tokenAmount = fullTokens * 10**token.decimals();
422     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
423 
424     weiRaised = weiRaised.plus(weiAmount);
425     tokensSold = tokensSold.plus(tokenAmount);
426 
427     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
428     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
429 
430     assignTokens(receiver, tokenAmount);
431 
432     // Tell us invest was success
433     Invested(receiver, weiAmount, tokenAmount, 0);
434   }
435 
436   /**
437    * Allow anonymous contributions to this crowdsale.
438    */
439   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
440      bytes32 hash = sha256(addr);
441      if (ecrecover(hash, v, r, s) != signerAddress) throw;
442      if(customerId == 0) throw;  // UUIDv4 sanity check
443      investInternal(addr, customerId);
444   }
445 
446   /**
447    * Track who is the customer making the payment so we can send thank you email.
448    */
449   function investWithCustomerId(address addr, uint128 customerId) public payable {
450     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
451     if(customerId == 0) throw;  // UUIDv4 sanity check
452     investInternal(addr, customerId);
453   }
454 
455   /**
456    * Allow anonymous contributions to this crowdsale.
457    */
458   function invest(address addr) public payable {
459     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
460     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
461     investInternal(addr, 0);
462   }
463 
464   /**
465    * Invest to tokens, recognize the payer and clear his address.
466    *
467    */
468   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
469     investWithSignedAddress(msg.sender, customerId, v, r, s);
470   }
471 
472   /**
473    * Invest to tokens, recognize the payer.
474    *
475    */
476   function buyWithCustomerId(uint128 customerId) public payable {
477     investWithCustomerId(msg.sender, customerId);
478   }
479 
480   /**
481    * The basic entry point to participate the crowdsale process.
482    *
483    * Pay for funding, get invested tokens back in the sender address.
484    */
485   function buy() public payable {
486     invest(msg.sender);
487   }
488 
489   /**
490    * Finalize a succcesful crowdsale.
491    *
492    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
493    */
494   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
495 
496     // Already finalized
497     if(finalized) {
498       throw;
499     }
500 
501     // Finalizing is optional. We only call it if we are given a finalizing agent.
502     if(address(finalizeAgent) != 0) {
503       finalizeAgent.finalizeCrowdsale();
504     }
505 
506     finalized = true;
507   }
508 
509   /**
510    * Allow to (re)set finalize agent.
511    *
512    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
513    */
514   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
515     finalizeAgent = addr;
516 
517     // Don't allow setting bad agent
518     if(!finalizeAgent.isFinalizeAgent()) {
519       throw;
520     }
521   }
522 
523   /**
524    * Set policy do we need to have server-side customer ids for the investments.
525    *
526    */
527   function setRequireCustomerId(bool value) onlyOwner {
528     requireCustomerId = value;
529     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
530   }
531 
532   /**
533    * Set policy if all investors must be cleared on the server side first.
534    *
535    * This is e.g. for the accredited investor clearing.
536    *
537    */
538   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
539     requiredSignedAddress = value;
540     signerAddress = _signerAddress;
541     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
542   }
543 
544   /**
545    * Allow addresses to do early participation.
546    *
547    * TODO: Fix spelling error in the name
548    */
549   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
550     earlyParticipantWhitelist[addr] = status;
551     Whitelisted(addr, status);
552   }
553 
554   /**
555    * Allow crowdsale owner to close early or extend the crowdsale.
556    *
557    * This is useful e.g. for a manual soft cap implementation:
558    * - after X amount is reached determine manual closing
559    *
560    * This may put the crowdsale to an invalid state,
561    * but we trust owners know what they are doing.
562    *
563    */
564   function setEndsAt(uint time) onlyOwner {
565 
566     if(now > time) {
567       throw; // Don't change past
568     }
569 
570     endsAt = time;
571     EndsAtChanged(endsAt);
572   }
573 
574   /**
575    * Allow to (re)set pricing strategy.
576    *
577    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
578    */
579   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
580     pricingStrategy = _pricingStrategy;
581 
582     // Don't allow setting bad agent
583     if(!pricingStrategy.isPricingStrategy()) {
584       throw;
585     }
586   }
587 
588   /**
589    * Allow to change the team multisig address in the case of emergency.
590    *
591    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
592    * (we have done only few test transactions). After the crowdsale is going
593    * then multisig address stays locked for the safety reasons.
594    */
595   function setMultisig(address addr) public onlyOwner {
596 
597     // Change
598     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
599       throw;
600     }
601 
602     multisigWallet = addr;
603   }
604 
605   /**
606    * Allow load refunds back on the contract for the refunding.
607    *
608    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
609    */
610   function loadRefund() public payable inState(State.Failure) {
611     if(msg.value == 0) throw;
612     loadedRefund = loadedRefund.plus(msg.value);
613   }
614 
615   /**
616    * Investors can claim refund.
617    *
618    * Note that any refunds from proxy buyers should be handled separately,
619    * and not through this contract.
620    */
621   function refund() public inState(State.Refunding) {
622     uint256 weiValue = investedAmountOf[msg.sender];
623     if (weiValue == 0) throw;
624     investedAmountOf[msg.sender] = 0;
625     weiRefunded = weiRefunded.plus(weiValue);
626     Refund(msg.sender, weiValue);
627     if (!msg.sender.send(weiValue)) throw;
628   }
629 
630   /**
631    * @return true if the crowdsale has raised enough money to be a successful.
632    */
633   function isMinimumGoalReached() public constant returns (bool reached) {
634     return weiRaised >= minimumFundingGoal;
635   }
636 
637   /**
638    * Check if the contract relationship looks good.
639    */
640   function isFinalizerSane() public constant returns (bool sane) {
641     return finalizeAgent.isSane();
642   }
643 
644   /**
645    * Check if the contract relationship looks good.
646    */
647   function isPricingSane() public constant returns (bool sane) {
648     return pricingStrategy.isSane(address(this));
649   }
650 
651   /**
652    * Crowdfund state machine management.
653    *
654    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
655    */
656   function getState() public constant returns (State) {
657     if(finalized) return State.Finalized;
658     else if (address(finalizeAgent) == 0) return State.Preparing;
659     else if (!finalizeAgent.isSane()) return State.Preparing;
660     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
661     else if (block.timestamp < startsAt) return State.PreFunding;
662     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
663     else if (isMinimumGoalReached()) return State.Success;
664     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
665     else return State.Failure;
666   }
667 
668   /** This is for manual testing of multisig wallet interaction */
669   function setOwnerTestValue(uint val) onlyOwner {
670     ownerTestValue = val;
671   }
672 
673   /** Interface marker. */
674   function isCrowdsale() public constant returns (bool) {
675     return true;
676   }
677 
678   //
679   // Modifiers
680   //
681 
682   /** Modified allowing execution only if the crowdsale is currently running.  */
683   modifier inState(State state) {
684     if(getState() != state) throw;
685     _;
686   }
687 
688 
689   //
690   // Abstract functions
691   //
692 
693   /**
694    * Check if the current invested breaks our cap rules.
695    *
696    *
697    * The child contract must define their own cap setting rules.
698    * We allow a lot of flexibility through different capping strategies (ETH, token count)
699    * Called from invest().
700    *
701    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
702    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
703    * @param weiRaisedTotal What would be our total raised balance after this transaction
704    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
705    *
706    * @return true if taking this investment would break our cap rules
707    */
708   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
709 
710   /**
711    * Check if the current crowdsale is full and we can no longer sell any tokens.
712    */
713   function isCrowdsaleFull() public constant returns (bool);
714 
715   /**
716    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
717    */
718   function assignTokens(address receiver, uint tokenAmount) private;
719 }
720 
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * Math operations with safety checks
730  */
731 contract SafeMath {
732   function safeMul(uint a, uint b) internal returns (uint) {
733     uint c = a * b;
734     assert(a == 0 || c / a == b);
735     return c;
736   }
737 
738   function safeDiv(uint a, uint b) internal returns (uint) {
739     assert(b > 0);
740     uint c = a / b;
741     assert(a == b * c + a % b);
742     return c;
743   }
744 
745   function safeSub(uint a, uint b) internal returns (uint) {
746     assert(b <= a);
747     return a - b;
748   }
749 
750   function safeAdd(uint a, uint b) internal returns (uint) {
751     uint c = a + b;
752     assert(c>=a && c>=b);
753     return c;
754   }
755 
756   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
757     return a >= b ? a : b;
758   }
759 
760   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
761     return a < b ? a : b;
762   }
763 
764   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
765     return a >= b ? a : b;
766   }
767 
768   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
769     return a < b ? a : b;
770   }
771 
772   function assert(bool assertion) internal {
773     if (!assertion) {
774       throw;
775     }
776   }
777 }
778 
779 
780 
781 /**
782  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
783  *
784  * Based on code by FirstBlood:
785  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
786  */
787 contract StandardToken is ERC20, SafeMath {
788 
789   /* Token supply got increased and a new owner received these tokens */
790   event Minted(address receiver, uint amount);
791 
792   /* Actual balances of token holders */
793   mapping(address => uint) balances;
794 
795   /* approve() allowances */
796   mapping (address => mapping (address => uint)) allowed;
797 
798   /* Interface declaration */
799   function isToken() public constant returns (bool weAre) {
800     return true;
801   }
802 
803   function transfer(address _to, uint _value) returns (bool success) {
804     balances[msg.sender] = safeSub(balances[msg.sender], _value);
805     balances[_to] = safeAdd(balances[_to], _value);
806     Transfer(msg.sender, _to, _value);
807     return true;
808   }
809 
810   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
811     uint _allowance = allowed[_from][msg.sender];
812 
813     balances[_to] = safeAdd(balances[_to], _value);
814     balances[_from] = safeSub(balances[_from], _value);
815     allowed[_from][msg.sender] = safeSub(_allowance, _value);
816     Transfer(_from, _to, _value);
817     return true;
818   }
819 
820   function balanceOf(address _owner) constant returns (uint balance) {
821     return balances[_owner];
822   }
823 
824   function approve(address _spender, uint _value) returns (bool success) {
825 
826     // To change the approve amount you first have to reduce the addresses`
827     //  allowance to zero by calling `approve(_spender, 0)` if it is not
828     //  already 0 to mitigate the race condition described here:
829     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
830     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
831 
832     allowed[msg.sender][_spender] = _value;
833     Approval(msg.sender, _spender, _value);
834     return true;
835   }
836 
837   function allowance(address _owner, address _spender) constant returns (uint remaining) {
838     return allowed[_owner][_spender];
839   }
840 
841 }
842 
843 
844 
845 
846 /**
847  * A token that can increase its supply by another contract.
848  *
849  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
850  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
851  *
852  */
853 contract MintableToken is StandardToken, Ownable {
854 
855   using SafeMathLib for uint;
856 
857   bool public mintingFinished = false;
858 
859   /** List of agents that are allowed to create new tokens */
860   mapping (address => bool) public mintAgents;
861 
862   event MintingAgentChanged(address addr, bool state  );
863 
864   /**
865    * Create new tokens and allocate them to an address..
866    *
867    * Only callably by a crowdsale contract (mint agent).
868    */
869   function mint(address receiver, uint amount) onlyMintAgent canMint public {
870     totalSupply = totalSupply.plus(amount);
871     balances[receiver] = balances[receiver].plus(amount);
872 
873     // This will make the mint transaction apper in EtherScan.io
874     // We can remove this after there is a standardized minting event
875     Transfer(0, receiver, amount);
876   }
877 
878   /**
879    * Owner can allow a crowdsale contract to mint new tokens.
880    */
881   function setMintAgent(address addr, bool state) onlyOwner canMint public {
882     mintAgents[addr] = state;
883     MintingAgentChanged(addr, state);
884   }
885 
886   modifier onlyMintAgent() {
887     // Only crowdsale contracts are allowed to mint new tokens
888     if(!mintAgents[msg.sender]) {
889         throw;
890     }
891     _;
892   }
893 
894   /** Make sure we are not done yet. */
895   modifier canMint() {
896     if(mintingFinished) throw;
897     _;
898   }
899 }
900 
901 
902 /**
903  * ICO crowdsale contract that is capped by amout of ETH.
904  *
905  * - Tokens are dynamically created during the crowdsale
906  *
907  *
908  */
909 contract MintedEthCappedCrowdsale is Crowdsale {
910 
911   /* Maximum amount of wei this crowdsale can raise. */
912   uint public weiCap;
913 
914   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
915     weiCap = _weiCap;
916   }
917 
918   /**
919    * Called from invest() to confirm if the curret investment does not break our cap rule.
920    */
921   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
922     return weiRaisedTotal > weiCap;
923   }
924 
925   function isCrowdsaleFull() public constant returns (bool) {
926     return weiRaised >= weiCap;
927   }
928 
929   /**
930    * Dynamically create tokens and assign them to the investor.
931    */
932   function assignTokens(address receiver, uint tokenAmount) private {
933     MintableToken mintableToken = MintableToken(token);
934     mintableToken.mint(receiver, tokenAmount);
935   }
936 }