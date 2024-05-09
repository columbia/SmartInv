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
250   bool public requireCustomerId = false;
251 
252   /**
253     * Do we verify that contributor has been cleared on the server side (accredited investors only).
254     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
255     */
256   bool public requiredSignedAddress = false;
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
297   // Crowdsale start/end time has been changed
298   event EndsAtChanged(uint endsAt);
299   event StartsAtChanged(uint startsAt);
300 
301   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
302 
303     owner = msg.sender;
304 
305     token = FractionalERC20(_token);
306 
307     setPricingStrategy(_pricingStrategy);
308 
309     multisigWallet = _multisigWallet;
310     if(multisigWallet == 0) {
311         throw;
312     }
313 
314     if(_start == 0) {
315         throw;
316     }
317 
318     startsAt = _start;
319 
320     if(_end == 0) {
321         throw;
322     }
323 
324     endsAt = _end;
325 
326     // Don't mess the dates
327     if(startsAt >= endsAt) {
328         throw;
329     }
330 
331     // Minimum funding goal can be zero
332     minimumFundingGoal = _minimumFundingGoal;
333   }
334 
335   /**
336    * Don't expect to just send in money and get tokens.
337    */
338   function() payable {
339     throw;
340   }
341 
342   /**
343    * Make an investment.
344    *
345    * Crowdsale must be running for one to invest.
346    * We must have not pressed the emergency brake.
347    *
348    * @param receiver The Ethereum address who receives the tokens
349    * @param customerId (optional) UUID v4 to track the successful payments on the server side
350    *
351    */
352   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
353 
354     // Determine if it's a good time to accept investment from this participant
355     State state = getState();
356     if (state == State.Funding) {
357       // Retail participants can only come in when the crowdsale is running
358     } else if (state == State.PreFunding) {
359       // Are we whitelisted for early deposit
360       if (!earlyParticipantWhitelist[receiver]) {
361         throw;
362       }
363     } else {
364       // Unwanted state
365       throw;
366     }
367 
368     uint weiAmount = msg.value;
369     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
370 
371     if (tokenAmount == 0) {
372       // Dust transaction
373       throw;
374     }
375 
376     if (investedAmountOf[receiver] == 0) {
377        // A new investor
378        investorCount++;
379     }
380 
381     // Update investor
382     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
383     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
384 
385     // Update totals
386     weiRaised = weiRaised.plus(weiAmount);
387     tokensSold = tokensSold.plus(tokenAmount);
388 
389     // Check that we did not bust the cap
390     if (isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
391       throw;
392     }
393 
394     assignTokens(receiver, tokenAmount);
395 
396     // Pocket the money
397     if (!multisigWallet.send(weiAmount)) throw;
398 
399     // Tell us invest was success
400     Invested(receiver, weiAmount, tokenAmount, customerId);
401   }
402 
403   /**
404    * Preallocate tokens for the early investors.
405    *
406    * Preallocated tokens have been sold before the actual crowdsale opens.
407    * This function mints the tokens and moves the crowdsale needle.
408    *
409    * Investor count is not handled; it is assumed this goes for multiple investors
410    * and the token distribution happens outside the smart contract flow.
411    *
412    * No money is exchanged, as the crowdsale team already have received the payment.
413    *
414    * @param tokenAmount Tokens (in "atomic units") allocated to the contributor
415    * @param weiAmount Contribution in wei
416    *
417    */
418   function preallocate(address receiver, uint tokenAmount, uint weiAmount) public onlyOwner {
419     // Free pre-allocations don't count as "sold tokens"
420     if (weiAmount == 0) {
421       tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
422       assignTokens(receiver, tokenAmount);
423     } else {
424       weiRaised = weiRaised.plus(weiAmount);
425       tokensSold = tokensSold.plus(tokenAmount);
426       investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
427       tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
428       investorCount++;
429 
430       assignTokens(receiver, tokenAmount);
431 
432       Invested(receiver, weiAmount, tokenAmount, 0);
433     }
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
546    */
547   function setEarlyParticipantWhitelist(address addr, bool status) onlyOwner {
548     earlyParticipantWhitelist[addr] = status;
549     Whitelisted(addr, status);
550   }
551 
552   /**
553    * Allow crowdsale owner to postpone the start of the crowdsale
554    */
555   function setStartsAt(uint time) onlyOwner {
556 
557     // Don't put into past
558     if (time < now) { throw; }
559 
560     // Change endsAt first...
561     if (time > endsAt) { throw; }
562 
563     // If crowdsale has already started, the start can't be postponed anymore
564     if (startsAt < now) { throw; }
565 
566     startsAt = time;
567     StartsAtChanged(endsAt);
568   }
569 
570   /**
571    * Allow crowdsale owner to close early or extend the crowdsale.
572    *
573    * This is useful e.g. for a manual soft cap implementation:
574    * - after X amount is reached determine manual closing
575    *
576    * This may put the crowdsale to an invalid state,
577    * but we trust owners know what they are doing.
578    *
579    */
580   function setEndsAt(uint time) onlyOwner {
581 
582     if (now > time) {
583       throw; // Don't change past
584     }
585 
586     endsAt = time;
587     EndsAtChanged(endsAt);
588   }
589 
590   /**
591    * Allow to (re)set pricing strategy.
592    *
593    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
594    */
595   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
596     pricingStrategy = _pricingStrategy;
597 
598     // Don't allow setting bad agent
599     if(!pricingStrategy.isPricingStrategy()) {
600       throw;
601     }
602   }
603 
604   /**
605    * Allow to change the team multisig address in the case of emergency.
606    *
607    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
608    * (we have done only few test transactions). After the crowdsale is going
609    * then multisig address stays locked for the safety reasons.
610    */
611   function setMultisig(address addr) public onlyOwner {
612 
613     // Change
614     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
615       throw;
616     }
617 
618     multisigWallet = addr;
619   }
620 
621   /**
622    * Allow load refunds back on the contract for the refunding.
623    *
624    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
625    */
626   function loadRefund() public payable inState(State.Failure) {
627     if(msg.value == 0) throw;
628     loadedRefund = loadedRefund.plus(msg.value);
629   }
630 
631   /**
632    * Investors can claim refund.
633    *
634    * Note that any refunds from proxy buyers should be handled separately,
635    * and not through this contract.
636    */
637   function refund() public inState(State.Refunding) {
638     uint256 weiValue = investedAmountOf[msg.sender];
639     if (weiValue == 0) throw;
640     investedAmountOf[msg.sender] = 0;
641     weiRefunded = weiRefunded.plus(weiValue);
642     Refund(msg.sender, weiValue);
643     if (!msg.sender.send(weiValue)) throw;
644   }
645 
646   /**
647    * @return true if the crowdsale has raised enough money to be a successful.
648    */
649   function isMinimumGoalReached() public constant returns (bool reached) {
650     return weiRaised >= minimumFundingGoal;
651   }
652 
653   /**
654    * Check if the contract relationship looks good.
655    */
656   function isFinalizerSane() public constant returns (bool sane) {
657     return finalizeAgent.isSane();
658   }
659 
660   /**
661    * Check if the contract relationship looks good.
662    */
663   function isPricingSane() public constant returns (bool sane) {
664     return pricingStrategy.isSane(address(this));
665   }
666 
667   /**
668    * Crowdfund state machine management.
669    *
670    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
671    */
672   function getState() public constant returns (State) {
673     if(finalized) return State.Finalized;
674     else if (address(finalizeAgent) == 0) return State.Preparing;
675     else if (!finalizeAgent.isSane()) return State.Preparing;
676     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
677     else if (block.timestamp < startsAt) return State.PreFunding;
678     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
679     else if (isMinimumGoalReached()) return State.Success;
680     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
681     else return State.Failure;
682   }
683 
684   /** This is for manual testing of multisig wallet interaction */
685   function setOwnerTestValue(uint val) onlyOwner {
686     ownerTestValue = val;
687   }
688 
689   /** Interface marker. */
690   function isCrowdsale() public constant returns (bool) {
691     return true;
692   }
693 
694   //
695   // Modifiers
696   //
697 
698   /** Modified allowing execution only if the crowdsale is currently running.  */
699   modifier inState(State state) {
700     if(getState() != state) throw;
701     _;
702   }
703 
704 
705   //
706   // Abstract functions
707   //
708 
709   /**
710    * Check if the current invested breaks our cap rules.
711    *
712    *
713    * The child contract must define their own cap setting rules.
714    * We allow a lot of flexibility through different capping strategies (ETH, token count)
715    * Called from invest().
716    *
717    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
718    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
719    * @param weiRaisedTotal What would be our total raised balance after this transaction
720    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
721    *
722    * @return true if taking this investment would break our cap rules
723    */
724   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
725 
726   /**
727    * Check if the current crowdsale is full and we can no longer sell any tokens.
728    */
729   function isCrowdsaleFull() public constant returns (bool);
730 
731   /**
732    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
733    */
734   function assignTokens(address receiver, uint tokenAmount) private;
735 }
736 
737 
738 
739 
740 
741 
742 
743 
744 /**
745  * Math operations with safety checks
746  */
747 contract SafeMath {
748   function safeMul(uint a, uint b) internal returns (uint) {
749     uint c = a * b;
750     assert(a == 0 || c / a == b);
751     return c;
752   }
753 
754   function safeDiv(uint a, uint b) internal returns (uint) {
755     assert(b > 0);
756     uint c = a / b;
757     assert(a == b * c + a % b);
758     return c;
759   }
760 
761   function safeSub(uint a, uint b) internal returns (uint) {
762     assert(b <= a);
763     return a - b;
764   }
765 
766   function safeAdd(uint a, uint b) internal returns (uint) {
767     uint c = a + b;
768     assert(c>=a && c>=b);
769     return c;
770   }
771 
772   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
773     return a >= b ? a : b;
774   }
775 
776   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
777     return a < b ? a : b;
778   }
779 
780   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
781     return a >= b ? a : b;
782   }
783 
784   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
785     return a < b ? a : b;
786   }
787 
788   function assert(bool assertion) internal {
789     if (!assertion) {
790       throw;
791     }
792   }
793 }
794 
795 
796 
797 /**
798  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
799  *
800  * Based on code by FirstBlood:
801  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
802  */
803 contract StandardToken is ERC20, SafeMath {
804 
805   /* Token supply got increased and a new owner received these tokens */
806   event Minted(address receiver, uint amount);
807 
808   /* Actual balances of token holders */
809   mapping(address => uint) balances;
810 
811   /* approve() allowances */
812   mapping (address => mapping (address => uint)) allowed;
813 
814   /* Interface declaration */
815   function isToken() public constant returns (bool weAre) {
816     return true;
817   }
818 
819   function transfer(address _to, uint _value) returns (bool success) {
820     balances[msg.sender] = safeSub(balances[msg.sender], _value);
821     balances[_to] = safeAdd(balances[_to], _value);
822     Transfer(msg.sender, _to, _value);
823     return true;
824   }
825 
826   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
827     uint _allowance = allowed[_from][msg.sender];
828 
829     balances[_to] = safeAdd(balances[_to], _value);
830     balances[_from] = safeSub(balances[_from], _value);
831     allowed[_from][msg.sender] = safeSub(_allowance, _value);
832     Transfer(_from, _to, _value);
833     return true;
834   }
835 
836   function balanceOf(address _owner) constant returns (uint balance) {
837     return balances[_owner];
838   }
839 
840   function approve(address _spender, uint _value) returns (bool success) {
841 
842     // To change the approve amount you first have to reduce the addresses`
843     //  allowance to zero by calling `approve(_spender, 0)` if it is not
844     //  already 0 to mitigate the race condition described here:
845     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
846     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
847 
848     allowed[msg.sender][_spender] = _value;
849     Approval(msg.sender, _spender, _value);
850     return true;
851   }
852 
853   function allowance(address _owner, address _spender) constant returns (uint remaining) {
854     return allowed[_owner][_spender];
855   }
856 
857 }
858 
859 
860 
861 
862 /**
863  * A token that can increase its supply by another contract.
864  *
865  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
866  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
867  *
868  */
869 contract MintableToken is StandardToken, Ownable {
870 
871   using SafeMathLib for uint;
872 
873   bool public mintingFinished = false;
874 
875   /** List of agents that are allowed to create new tokens */
876   mapping (address => bool) public mintAgents;
877 
878   event MintingAgentChanged(address addr, bool state  );
879 
880   /**
881    * Create new tokens and allocate them to an address..
882    *
883    * Only callably by a crowdsale contract (mint agent).
884    */
885   function mint(address receiver, uint amount) onlyMintAgent canMint public {
886     totalSupply = totalSupply.plus(amount);
887     balances[receiver] = balances[receiver].plus(amount);
888 
889     // This will make the mint transaction apper in EtherScan.io
890     // We can remove this after there is a standardized minting event
891     Transfer(0, receiver, amount);
892   }
893 
894   /**
895    * Owner can allow a crowdsale contract to mint new tokens.
896    */
897   function setMintAgent(address addr, bool state) onlyOwner canMint public {
898     mintAgents[addr] = state;
899     MintingAgentChanged(addr, state);
900   }
901 
902   modifier onlyMintAgent() {
903     // Only crowdsale contracts are allowed to mint new tokens
904     if(!mintAgents[msg.sender]) {
905         throw;
906     }
907     _;
908   }
909 
910   /** Make sure we are not done yet. */
911   modifier canMint() {
912     if(mintingFinished) throw;
913     _;
914   }
915 }
916 
917 
918 /**
919  * ICO crowdsale contract that is capped by amout of tokens.
920  *
921  * - Tokens are dynamically created during the crowdsale
922  *
923  *
924  */
925 contract MintedTokenCappedCrowdsale is Crowdsale {
926 
927   /* Maximum amount of tokens this crowdsale can sell. */
928   uint public maximumSellableTokens;
929 
930   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
931     maximumSellableTokens = _maximumSellableTokens;
932   }
933 
934   /**
935    * Called from invest() to confirm if the curret investment does not break our cap rule.
936    */
937   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
938     return tokensSoldTotal > maximumSellableTokens;
939   }
940 
941   function isCrowdsaleFull() public constant returns (bool) {
942     return tokensSold >= maximumSellableTokens;
943   }
944 
945   /**
946    * Dynamically create tokens and assign them to the investor.
947    */
948   function assignTokens(address receiver, uint tokenAmount) private {
949     MintableToken mintableToken = MintableToken(token);
950     mintableToken.mint(receiver, tokenAmount);
951   }
952 }