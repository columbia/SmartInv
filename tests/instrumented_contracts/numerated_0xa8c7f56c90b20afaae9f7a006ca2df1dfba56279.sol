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
388     // Check that we did not bust the cap
389     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
390       throw;
391     }
392 
393     assignTokens(receiver, tokenAmount);
394 
395     // Pocket the money
396     if(!multisigWallet.send(weiAmount)) throw;
397 
398     // Tell us invest was success
399     Invested(receiver, weiAmount, tokenAmount, customerId);
400   }
401 
402   /**
403    * Preallocate tokens for the early investors.
404    *
405    * Preallocated tokens have been sold before the actual crowdsale opens.
406    * This function mints the tokens and moves the crowdsale needle.
407    *
408    * Investor count is not handled; it is assumed this goes for multiple investors
409    * and the token distribution happens outside the smart contract flow.
410    *
411    * No money is exchanged, as the crowdsale team already have received the payment.
412    *
413    * @param fullTokens tokens as full tokens - decimal places added internally
414    * @param weiPrice Price of a single full token in wei
415    *
416    */
417   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
418 
419     uint tokenAmount = fullTokens * 10**token.decimals();
420     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
421 
422     weiRaised = weiRaised.plus(weiAmount);
423     tokensSold = tokensSold.plus(tokenAmount);
424 
425     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
426     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
427 
428     assignTokens(receiver, tokenAmount);
429 
430     // Tell us invest was success
431     Invested(receiver, weiAmount, tokenAmount, 0);
432   }
433 
434   /**
435    * Allow anonymous contributions to this crowdsale.
436    */
437   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
438      bytes32 hash = sha256(addr);
439      if (ecrecover(hash, v, r, s) != signerAddress) throw;
440      if(customerId == 0) throw;  // UUIDv4 sanity check
441      investInternal(addr, customerId);
442   }
443 
444   /**
445    * Track who is the customer making the payment so we can send thank you email.
446    */
447   function investWithCustomerId(address addr, uint128 customerId) public payable {
448     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
449     if(customerId == 0) throw;  // UUIDv4 sanity check
450     investInternal(addr, customerId);
451   }
452 
453   /**
454    * Allow anonymous contributions to this crowdsale.
455    */
456   function invest(address addr) public payable {
457     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
458     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
459     investInternal(addr, 0);
460   }
461 
462   /**
463    * Invest to tokens, recognize the payer and clear his address.
464    *
465    */
466   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
467     investWithSignedAddress(msg.sender, customerId, v, r, s);
468   }
469 
470   /**
471    * Invest to tokens, recognize the payer.
472    *
473    */
474   function buyWithCustomerId(uint128 customerId) public payable {
475     investWithCustomerId(msg.sender, customerId);
476   }
477 
478   /**
479    * The basic entry point to participate the crowdsale process.
480    *
481    * Pay for funding, get invested tokens back in the sender address.
482    */
483   function buy() public payable {
484     invest(msg.sender);
485   }
486 
487   /**
488    * Finalize a succcesful crowdsale.
489    *
490    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
491    */
492   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
493 
494     // Already finalized
495     if(finalized) {
496       throw;
497     }
498 
499     // Finalizing is optional. We only call it if we are given a finalizing agent.
500     if(address(finalizeAgent) != 0) {
501       finalizeAgent.finalizeCrowdsale();
502     }
503 
504     finalized = true;
505   }
506 
507   /**
508    * Allow to (re)set finalize agent.
509    *
510    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
511    */
512   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
513     finalizeAgent = addr;
514 
515     // Don't allow setting bad agent
516     if(!finalizeAgent.isFinalizeAgent()) {
517       throw;
518     }
519   }
520 
521   /**
522    * Set policy do we need to have server-side customer ids for the investments.
523    *
524    */
525   function setRequireCustomerId(bool value) onlyOwner {
526     requireCustomerId = value;
527     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
528   }
529 
530   /**
531    * Set policy if all investors must be cleared on the server side first.
532    *
533    * This is e.g. for the accredited investor clearing.
534    *
535    */
536   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
537     requiredSignedAddress = value;
538     signerAddress = _signerAddress;
539     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
540   }
541 
542   /**
543    * Allow addresses to do early participation.
544    *
545    * TODO: Fix spelling error in the name
546    */
547   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
548     earlyParticipantWhitelist[addr] = status;
549     Whitelisted(addr, status);
550   }
551 
552   /**
553    * Allow crowdsale owner to close early or extend the crowdsale.
554    *
555    * This is useful e.g. for a manual soft cap implementation:
556    * - after X amount is reached determine manual closing
557    *
558    * This may put the crowdsale to an invalid state,
559    * but we trust owners know what they are doing.
560    *
561    */
562   function setEndsAt(uint time) onlyOwner {
563 
564     if(now > time) {
565       throw; // Don't change past
566     }
567 
568     endsAt = time;
569     EndsAtChanged(endsAt);
570   }
571 
572   /**
573    * Allow to (re)set pricing strategy.
574    *
575    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
576    */
577   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
578     pricingStrategy = _pricingStrategy;
579 
580     // Don't allow setting bad agent
581     if(!pricingStrategy.isPricingStrategy()) {
582       throw;
583     }
584   }
585 
586   /**
587    * Allow to change the team multisig address in the case of emergency.
588    *
589    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
590    * (we have done only few test transactions). After the crowdsale is going
591    * then multisig address stays locked for the safety reasons.
592    */
593   function setMultisig(address addr) public onlyOwner {
594 
595     // Change
596     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
597       throw;
598     }
599 
600     multisigWallet = addr;
601   }
602 
603   /**
604    * Allow load refunds back on the contract for the refunding.
605    *
606    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
607    */
608   function loadRefund() public payable inState(State.Failure) {
609     if(msg.value == 0) throw;
610     loadedRefund = loadedRefund.plus(msg.value);
611   }
612 
613   /**
614    * Investors can claim refund.
615    */
616   function refund() public inState(State.Refunding) {
617     uint256 weiValue = investedAmountOf[msg.sender];
618     if (weiValue == 0) throw;
619     investedAmountOf[msg.sender] = 0;
620     weiRefunded = weiRefunded.plus(weiValue);
621     Refund(msg.sender, weiValue);
622     if (!msg.sender.send(weiValue)) throw;
623   }
624 
625   /**
626    * @return true if the crowdsale has raised enough money to be a succes
627    */
628   function isMinimumGoalReached() public constant returns (bool reached) {
629     return weiRaised >= minimumFundingGoal;
630   }
631 
632   /**
633    * Check if the contract relationship looks good.
634    */
635   function isFinalizerSane() public constant returns (bool sane) {
636     return finalizeAgent.isSane();
637   }
638 
639   /**
640    * Check if the contract relationship looks good.
641    */
642   function isPricingSane() public constant returns (bool sane) {
643     return pricingStrategy.isSane(address(this));
644   }
645 
646   /**
647    * Crowdfund state machine management.
648    *
649    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
650    */
651   function getState() public constant returns (State) {
652     if(finalized) return State.Finalized;
653     else if (address(finalizeAgent) == 0) return State.Preparing;
654     else if (!finalizeAgent.isSane()) return State.Preparing;
655     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
656     else if (block.timestamp < startsAt) return State.PreFunding;
657     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
658     else if (isMinimumGoalReached()) return State.Success;
659     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
660     else return State.Failure;
661   }
662 
663   /** This is for manual testing of multisig wallet interaction */
664   function setOwnerTestValue(uint val) onlyOwner {
665     ownerTestValue = val;
666   }
667 
668   /** Interface marker. */
669   function isCrowdsale() public constant returns (bool) {
670     return true;
671   }
672 
673   //
674   // Modifiers
675   //
676 
677   /** Modified allowing execution only if the crowdsale is currently running.  */
678   modifier inState(State state) {
679     if(getState() != state) throw;
680     _;
681   }
682 
683 
684   //
685   // Abstract functions
686   //
687 
688   /**
689    * Check if the current invested breaks our cap rules.
690    *
691    *
692    * The child contract must define their own cap setting rules.
693    * We allow a lot of flexibility through different capping strategies (ETH, token count)
694    * Called from invest().
695    *
696    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
697    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
698    * @param weiRaisedTotal What would be our total raised balance after this transaction
699    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
700    *
701    * @return true if taking this investment would break our cap rules
702    */
703   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
704 
705   /**
706    * Check if the current crowdsale is full and we can no longer sell any tokens.
707    */
708   function isCrowdsaleFull() public constant returns (bool);
709 
710   /**
711    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
712    */
713   function assignTokens(address receiver, uint tokenAmount) private;
714 }
715 
716 
717 
718 
719 
720 
721 
722 
723 /**
724  * Math operations with safety checks
725  */
726 contract SafeMath {
727   function safeMul(uint a, uint b) internal returns (uint) {
728     uint c = a * b;
729     assert(a == 0 || c / a == b);
730     return c;
731   }
732 
733   function safeDiv(uint a, uint b) internal returns (uint) {
734     assert(b > 0);
735     uint c = a / b;
736     assert(a == b * c + a % b);
737     return c;
738   }
739 
740   function safeSub(uint a, uint b) internal returns (uint) {
741     assert(b <= a);
742     return a - b;
743   }
744 
745   function safeAdd(uint a, uint b) internal returns (uint) {
746     uint c = a + b;
747     assert(c>=a && c>=b);
748     return c;
749   }
750 
751   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
752     return a >= b ? a : b;
753   }
754 
755   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
756     return a < b ? a : b;
757   }
758 
759   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
760     return a >= b ? a : b;
761   }
762 
763   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
764     return a < b ? a : b;
765   }
766 
767   function assert(bool assertion) internal {
768     if (!assertion) {
769       throw;
770     }
771   }
772 }
773 
774 
775 
776 /**
777  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
778  *
779  * Based on code by FirstBlood:
780  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
781  */
782 contract StandardToken is ERC20, SafeMath {
783 
784   /* Token supply got increased and a new owner received these tokens */
785   event Minted(address receiver, uint amount);
786 
787   /* Actual balances of token holders */
788   mapping(address => uint) balances;
789 
790   /* approve() allowances */
791   mapping (address => mapping (address => uint)) allowed;
792 
793   /* Interface declaration */
794   function isToken() public constant returns (bool weAre) {
795     return true;
796   }
797 
798   /**
799    *
800    * Fix for the ERC20 short address attack
801    *
802    * http://vessenes.com/the-erc20-short-address-attack-explained/
803    */
804   modifier onlyPayloadSize(uint size) {
805      if(msg.data.length < size + 4) {
806        throw;
807      }
808      _;
809   }
810 
811   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
812     balances[msg.sender] = safeSub(balances[msg.sender], _value);
813     balances[_to] = safeAdd(balances[_to], _value);
814     Transfer(msg.sender, _to, _value);
815     return true;
816   }
817 
818   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
819     uint _allowance = allowed[_from][msg.sender];
820 
821     balances[_to] = safeAdd(balances[_to], _value);
822     balances[_from] = safeSub(balances[_from], _value);
823     allowed[_from][msg.sender] = safeSub(_allowance, _value);
824     Transfer(_from, _to, _value);
825     return true;
826   }
827 
828   function balanceOf(address _owner) constant returns (uint balance) {
829     return balances[_owner];
830   }
831 
832   function approve(address _spender, uint _value) returns (bool success) {
833 
834     // To change the approve amount you first have to reduce the addresses`
835     //  allowance to zero by calling `approve(_spender, 0)` if it is not
836     //  already 0 to mitigate the race condition described here:
837     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
838     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
839 
840     allowed[msg.sender][_spender] = _value;
841     Approval(msg.sender, _spender, _value);
842     return true;
843   }
844 
845   function allowance(address _owner, address _spender) constant returns (uint remaining) {
846     return allowed[_owner][_spender];
847   }
848 
849 }
850 
851 
852 
853 
854 /**
855  * A token that can increase its supply by another contract.
856  *
857  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
858  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
859  *
860  */
861 contract MintableToken is StandardToken, Ownable {
862 
863   using SafeMathLib for uint;
864 
865   bool public mintingFinished = false;
866 
867   /** List of agents that are allowed to create new tokens */
868   mapping (address => bool) public mintAgents;
869 
870   event MintingAgentChanged(address addr, bool state  );
871 
872   /**
873    * Create new tokens and allocate them to an address..
874    *
875    * Only callably by a crowdsale contract (mint agent).
876    */
877   function mint(address receiver, uint amount) onlyMintAgent canMint public {
878     totalSupply = totalSupply.plus(amount);
879     balances[receiver] = balances[receiver].plus(amount);
880 
881     // This will make the mint transaction apper in EtherScan.io
882     // We can remove this after there is a standardized minting event
883     Transfer(0, receiver, amount);
884   }
885 
886   /**
887    * Owner can allow a crowdsale contract to mint new tokens.
888    */
889   function setMintAgent(address addr, bool state) onlyOwner canMint public {
890     mintAgents[addr] = state;
891     MintingAgentChanged(addr, state);
892   }
893 
894   modifier onlyMintAgent() {
895     // Only crowdsale contracts are allowed to mint new tokens
896     if(!mintAgents[msg.sender]) {
897         throw;
898     }
899     _;
900   }
901 
902   /** Make sure we are not done yet. */
903   modifier canMint() {
904     if(mintingFinished) throw;
905     _;
906   }
907 }
908 
909 
910 /**
911  * ICO crowdsale contract that is capped by amout of tokens.
912  *
913  * - Tokens are dynamically created during the crowdsale
914  *
915  *
916  */
917 contract MintedTokenCappedCrowdsale is Crowdsale {
918 
919   /* Maximum amount of tokens this crowdsale can sell. */
920   uint public maximumSellableTokens;
921 
922   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
923     maximumSellableTokens = _maximumSellableTokens;
924   }
925 
926   /**
927    * Called from invest() to confirm if the curret investment does not break our cap rule.
928    */
929   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
930     return tokensSoldTotal > maximumSellableTokens;
931   }
932 
933   function isCrowdsaleFull() public constant returns (bool) {
934     return tokensSold >= maximumSellableTokens;
935   }
936 
937   /**
938    * Dynamically create tokens and assign them to the investor.
939    */
940   function assignTokens(address receiver, uint tokenAmount) private {
941     MintableToken mintableToken = MintableToken(token);
942     mintableToken.mint(receiver, tokenAmount);
943   }
944 }
945 
946 
947 
948 /**
949  * A crowdsale that retains the previous token, but changes some parameters.
950  *
951  * Investor data can be manually fed in.
952  *
953  * Mostly useful as a hot fix.
954  *
955  */
956 contract RelaunchedCrowdsale is MintedTokenCappedCrowdsale {
957 
958   // This transaction was restored from a previous crowdsale
959   event RestoredInvestment(address addr, uint originalTxHash);
960 
961   mapping(uint => bool) public reissuedTransactions;
962 
963   function RelaunchedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) MintedTokenCappedCrowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _maximumSellableTokens) {
964   }
965 
966   /**
967    * Check if a particular transaction has already been written.
968    */
969   function getRestoredTransactionStatus(uint _originalTxHash) public constant returns(bool) {
970     return reissuedTransactions[_originalTxHash];
971   }
972 
973   /**
974    * Rebuild the previous invest data back to the crowdsale.
975    */
976   function setInvestorData(address _addr, uint _weiAmount, uint _tokenAmount, uint _originalTxHash) onlyOwner public {
977 
978     if(investedAmountOf[_addr] == 0) {
979       investorCount++;
980     }
981 
982     investedAmountOf[_addr] += _weiAmount;
983     tokenAmountOf[_addr] += _tokenAmount;
984 
985     weiRaised += _weiAmount;
986     tokensSold += _tokenAmount;
987 
988     Invested(_addr, _weiAmount, _tokenAmount, 0);
989     RestoredInvestment(_addr, _originalTxHash);
990   }
991 
992   /**
993    * Rebuild the previous invest data and do a token reissuance.
994    */
995   function setInvestorDataAndIssueNewToken(address _addr, uint _weiAmount, uint _tokenAmount, uint _originalTxHash) onlyOwner public {
996 
997     // This transaction has already been rebuild
998     if(reissuedTransactions[_originalTxHash]) {
999       throw;
1000     }
1001 
1002     setInvestorData(_addr, _weiAmount, _tokenAmount, _originalTxHash);
1003 
1004     // Check that we did not bust the cap in the restoration process
1005     if(isBreakingCap(_weiAmount, _tokenAmount, weiRaised, tokensSold)) {
1006       throw;
1007     }
1008 
1009     // Mark transaction processed
1010     reissuedTransactions[_originalTxHash] = true;
1011 
1012     // Mint new token to give it to the original investor
1013     MintableToken mintableToken = MintableToken(token);
1014     mintableToken.mint(_addr, _tokenAmount);
1015   }
1016 
1017 }