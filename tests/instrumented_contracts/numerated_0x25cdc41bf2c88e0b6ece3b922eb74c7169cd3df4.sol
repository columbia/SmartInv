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
26     assert(c>=a && c>=b);
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
131   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender, uint decimals) public constant returns (uint tokenAmount);
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
205   using SafeMathLib for uint;
206 
207   /* The token we are selling */
208   FractionalERC20 public token;
209 
210   /* How we are going to price our offering */
211   PricingStrategy public pricingStrategy;
212 
213   /* Post-success callback */
214   FinalizeAgent public finalizeAgent;
215 
216   /* tokens will be transfered from this address */
217   address public multisigWallet;
218 
219   /* if the funding goal is not reached, investors may withdraw their funds */
220   uint public minimumFundingGoal;
221 
222   /* the UNIX timestamp start date of the crowdsale */
223   uint public startsAt;
224 
225   /* the UNIX timestamp end date of the crowdsale */
226   uint public endsAt;
227 
228   /* the number of tokens already sold through this contract*/
229   uint public tokensSold = 0;
230 
231   /* How many wei of funding we have raised */
232   uint public weiRaised = 0;
233 
234   /* How many distinct addresses have invested */
235   uint public investorCount = 0;
236 
237   /* How much wei we have returned back to the contract after a failed crowdfund. */
238   uint public loadedRefund = 0;
239 
240   /* How much wei we have given back to investors.*/
241   uint public weiRefunded = 0;
242 
243   /* Has this crowdsale been finalized */
244   bool public finalized;
245 
246   /* Do we need to have unique contributor id for each customer */
247   bool public requireCustomerId;
248 
249   /**
250     * Do we verify that contributor has been cleared on the server side (accredited investors only).
251     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
252     */
253   bool public requiredSignedAddress;
254 
255   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
256   address public signerAddress;
257 
258   /** How much ETH each address has invested to this crowdsale */
259   mapping (address => uint256) public investedAmountOf;
260 
261   /** How much tokens this crowdsale has credited for each investor address */
262   mapping (address => uint256) public tokenAmountOf;
263 
264   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
265   mapping (address => bool) public earlyParticipantWhitelist;
266 
267   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
268   uint public ownerTestValue;
269 
270   /** State machine
271    *
272    * - Preparing: All contract initialization calls and variables have not been set yet
273    * - Prefunding: We have not passed start time yet
274    * - Funding: Active crowdsale
275    * - Success: Minimum funding goal reached
276    * - Failure: Minimum funding goal not reached before ending time
277    * - Finalized: The finalized has been called and succesfully executed
278    * - Refunding: Refunds are loaded on the contract for reclaim.
279    */
280   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
281 
282   // A new investment was made
283   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
284 
285   // Refund was processed for a contributor
286   event Refund(address investor, uint weiAmount);
287 
288   // The rules were changed what kind of investments we accept
289   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
290 
291   // Address early participation whitelist status changed
292   event Whitelisted(address addr, bool status);
293 
294   // Crowdsale end time has been changed
295   event EndsAtChanged(uint endsAt);
296 
297   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
298 
299     if(_minimumFundingGoal != 0) {
300       // Mysterium specific fix to allow funding goal only be set in CHF
301     }
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
331   }
332 
333   /**
334    * Don't expect to just send in money and get tokens.
335    */
336   function() payable {
337     throw;
338   }
339 
340   /**
341    * Make an investment.
342    *
343    * Crowdsale must be running for one to invest.
344    * We must have not pressed the emergency brake.
345    *
346    * @param receiver The Ethereum address who receives the tokens
347    * @param customerId (optional) UUID v4 to track the successful payments on the server side
348    *
349    */
350   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
351 
352     // Determine if it's a good time to accept investment from this participant
353     if(getState() == State.PreFunding) {
354       // Are we whitelisted for early deposit
355       if(!earlyParticipantWhitelist[receiver]) {
356         throw;
357       }
358     } else if(getState() == State.Funding) {
359       // Retail participants can only come in when the crowdsale is running
360       // pass
361     } else {
362       // Unwanted state
363       throw;
364     }
365 
366     uint weiAmount = msg.value;
367     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
368 
369     if(tokenAmount == 0) {
370       // Dust transaction
371       throw;
372     }
373 
374     if(investedAmountOf[receiver] == 0) {
375        // A new investor
376        investorCount++;
377     }
378 
379     // Update investor
380     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
381     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
382 
383     // Update totals
384     weiRaised = weiRaised.plus(weiAmount);
385     tokensSold = tokensSold.plus(tokenAmount);
386 
387     // Check that we did not bust the cap
388     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
389       throw;
390     }
391 
392     assignTokens(receiver, tokenAmount);
393 
394     // Pocket the money
395     if(!multisigWallet.send(weiAmount)) throw;
396 
397     // Tell us invest was success
398     Invested(receiver, weiAmount, tokenAmount, customerId);
399 
400     // Call the invest hooks
401     onInvest();
402   }
403 
404   /**
405    * Track who is the customer making the payment so we can send thank you email.
406    */
407   function investWithCustomerId(address addr, uint128 customerId) public payable {
408     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
409     if(customerId == 0) throw;  // UUIDv4 sanity check
410     investInternal(addr, customerId);
411   }
412 
413   /**
414    * Allow anonymous contributions to this crowdsale.
415    */
416   function invest(address addr) public payable {
417     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
418     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
419     investInternal(addr, 0);
420   }
421 
422   /**
423    * Invest to tokens, recognize the payer.
424    *
425    */
426   function buyWithCustomerId(uint128 customerId) public payable {
427     investWithCustomerId(msg.sender, customerId);
428   }
429 
430   /**
431    * The basic entry point to participate the crowdsale process.
432    *
433    * Pay for funding, get invested tokens back in the sender address.
434    */
435   function buy() public payable {
436     invest(msg.sender);
437   }
438 
439   /**
440    * Finalize a succcesful crowdsale.
441    *
442    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
443    */
444   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
445 
446     // Already finalized
447     if(finalized) {
448       throw;
449     }
450 
451     // Finalizing is optional. We only call it if we are given a finalizing agent.
452     if(address(finalizeAgent) != 0) {
453       finalizeAgent.finalizeCrowdsale();
454     }
455 
456     finalized = true;
457   }
458 
459   /**
460    * Allow to (re)set finalize agent.
461    *
462    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
463    */
464   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
465     finalizeAgent = addr;
466 
467     // Don't allow setting bad agent
468     if(!finalizeAgent.isFinalizeAgent()) {
469       throw;
470     }
471   }
472 
473   /**
474    * Set policy do we need to have server-side customer ids for the investments.
475    *
476    */
477   function setRequireCustomerId(bool value) onlyOwner {
478     requireCustomerId = value;
479     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
480   }
481 
482   /**
483    * Allow addresses to do early participation.
484    *
485    * TODO: Fix spelling error in the name
486    */
487   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
488     earlyParticipantWhitelist[addr] = status;
489     Whitelisted(addr, status);
490   }
491 
492   /**
493    * Allow to (re)set pricing strategy.
494    *
495    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
496    */
497   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
498     pricingStrategy = _pricingStrategy;
499 
500     // Don't allow setting bad agent
501     if(!pricingStrategy.isPricingStrategy()) {
502       throw;
503     }
504   }
505 
506   /**
507    * Allow load refunds back on the contract for the refunding.
508    *
509    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
510    */
511   function loadRefund() public payable inState(State.Failure) {
512     if(msg.value == 0) throw;
513     loadedRefund = loadedRefund.plus(msg.value);
514   }
515 
516   /**
517    * Investors can claim refund.
518    */
519   function refund() public inState(State.Refunding) {
520     uint256 weiValue = investedAmountOf[msg.sender];
521     if (weiValue == 0) throw;
522     investedAmountOf[msg.sender] = 0;
523     weiRefunded = weiRefunded.plus(weiValue);
524     Refund(msg.sender, weiValue);
525     if (!msg.sender.send(weiValue)) throw;
526   }
527 
528   /**
529    * @return true if the crowdsale has raised enough money to be a succes
530    */
531   function isMinimumGoalReached() public constant returns (bool reached) {
532     return weiRaised >= minimumFundingGoal;
533   }
534 
535   /**
536    * Check if the contract relationship looks good.
537    */
538   function isFinalizerSane() public constant returns (bool sane) {
539     return finalizeAgent.isSane();
540   }
541 
542   /**
543    * Check if the contract relationship looks good.
544    */
545   function isPricingSane() public constant returns (bool sane) {
546     return pricingStrategy.isSane(address(this));
547   }
548 
549   /**
550    * Crowdfund state machine management.
551    *
552    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
553    */
554   function getState() public constant returns (State) {
555     if(finalized) return State.Finalized;
556     else if (address(finalizeAgent) == 0) return State.Preparing;
557     else if (!finalizeAgent.isSane()) return State.Preparing;
558     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
559     else if (block.timestamp < startsAt) return State.PreFunding;
560     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
561     else if (isMinimumGoalReached()) return State.Success;
562     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
563     else return State.Failure;
564   }
565 
566   /** This is for manual testing of multisig wallet interaction */
567   function setOwnerTestValue(uint val) onlyOwner {
568     ownerTestValue = val;
569   }
570 
571   /** Interface marker. */
572   function isCrowdsale() public constant returns (bool) {
573     return true;
574   }
575 
576 
577   /**
578    * Allow subcontracts to take extra actions on a successful invet.
579    */
580   function onInvest() internal {
581 
582   }
583 
584   //
585   // Modifiers
586   //
587 
588   /** Modified allowing execution only if the crowdsale is currently running.  */
589   modifier inState(State state) {
590     if(getState() != state) throw;
591     _;
592   }
593 
594   /**
595    * Allow crowdsale owner to close early or extend the crowdsale.
596    *
597    * This is useful e.g. for a manual soft cap implementation:
598    * - after X amount is reached determine manual closing
599    *
600    * This may put the crowdsale to an invalid state,
601    * but we trust owners know what they are doing.
602    *
603    */
604   function setEndsAt(uint time) onlyOwner {
605 
606     if(now > time) {
607       throw; // Don't change past
608     }
609 
610     endsAt = time;
611     EndsAtChanged(endsAt);
612   }
613 
614   //
615   // Abstract functions
616   //
617 
618   /**
619    * Check if the current invested breaks our cap rules.
620    *
621    *
622    * The child contract must define their own cap setting rules.
623    * We allow a lot of flexibility through different capping strategies (ETH, token count)
624    * Called from invest().
625    *
626    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
627    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
628    * @param weiRaisedTotal What would be our total raised balance after this transaction
629    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
630    *
631    * @return true if taking this investment would break our cap rules
632    */
633   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
634 
635   /**
636    * Check if the current crowdsale is full and we can no longer sell any tokens.
637    */
638   function isCrowdsaleFull() public constant returns (bool);
639 
640   /**
641    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
642    */
643   function assignTokens(address receiver, uint tokenAmount) private;
644 }
645 
646 
647 
648 
649 
650 
651 
652 /**
653  * Math operations with safety checks
654  */
655 contract SafeMath {
656   function safeMul(uint a, uint b) internal returns (uint) {
657     uint c = a * b;
658     assert(a == 0 || c / a == b);
659     return c;
660   }
661 
662   function safeDiv(uint a, uint b) internal returns (uint) {
663     assert(b > 0);
664     uint c = a / b;
665     assert(a == b * c + a % b);
666     return c;
667   }
668 
669   function safeSub(uint a, uint b) internal returns (uint) {
670     assert(b <= a);
671     return a - b;
672   }
673 
674   function safeAdd(uint a, uint b) internal returns (uint) {
675     uint c = a + b;
676     assert(c>=a && c>=b);
677     return c;
678   }
679 
680   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
681     return a >= b ? a : b;
682   }
683 
684   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
685     return a < b ? a : b;
686   }
687 
688   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
689     return a >= b ? a : b;
690   }
691 
692   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
693     return a < b ? a : b;
694   }
695 
696   function assert(bool assertion) internal {
697     if (!assertion) {
698       throw;
699     }
700   }
701 }
702 
703 
704 
705 /**
706  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
707  *
708  * Based on code by FirstBlood:
709  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
710  */
711 contract StandardToken is ERC20, SafeMath {
712 
713   /* Token supply got increased and a new owner received these tokens */
714   event Minted(address receiver, uint amount);
715 
716   /* Actual balances of token holders */
717   mapping(address => uint) balances;
718 
719   /* approve() allowances */
720   mapping (address => mapping (address => uint)) allowed;
721 
722   /**
723    *
724    * Fix for the ERC20 short address attack
725    *
726    * http://vessenes.com/the-erc20-short-address-attack-explained/
727    */
728   modifier onlyPayloadSize(uint size) {
729      if(msg.data.length != size + 4) {
730        throw;
731      }
732      _;
733   }
734 
735   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
736     balances[msg.sender] = safeSub(balances[msg.sender], _value);
737     balances[_to] = safeAdd(balances[_to], _value);
738     Transfer(msg.sender, _to, _value);
739     return true;
740   }
741 
742   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
743     uint _allowance = allowed[_from][msg.sender];
744 
745     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
746     // if (_value > _allowance) throw;
747 
748     balances[_to] = safeAdd(balances[_to], _value);
749     balances[_from] = safeSub(balances[_from], _value);
750     allowed[_from][msg.sender] = safeSub(_allowance, _value);
751     Transfer(_from, _to, _value);
752     return true;
753   }
754 
755   function balanceOf(address _owner) constant returns (uint balance) {
756     return balances[_owner];
757   }
758 
759   function approve(address _spender, uint _value) returns (bool success) {
760 
761     // To change the approve amount you first have to reduce the addresses`
762     //  allowance to zero by calling `approve(_spender, 0)` if it is not
763     //  already 0 to mitigate the race condition described here:
764     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
765     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
766 
767     allowed[msg.sender][_spender] = _value;
768     Approval(msg.sender, _spender, _value);
769     return true;
770   }
771 
772   function allowance(address _owner, address _spender) constant returns (uint remaining) {
773     return allowed[_owner][_spender];
774   }
775 
776   /**
777    * Atomic increment of approved spending
778    *
779    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
780    *
781    */
782   function addApproval(address _spender, uint _addedValue)
783   onlyPayloadSize(2 * 32)
784   returns (bool success) {
785       uint oldValue = allowed[msg.sender][_spender];
786       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
787       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
788       return true;
789   }
790 
791   /**
792    * Atomic decrement of approved spending.
793    *
794    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
795    */
796   function subApproval(address _spender, uint _subtractedValue)
797   onlyPayloadSize(2 * 32)
798   returns (bool success) {
799 
800       uint oldVal = allowed[msg.sender][_spender];
801 
802       if (_subtractedValue > oldVal) {
803           allowed[msg.sender][_spender] = 0;
804       } else {
805           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
806       }
807       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
808       return true;
809   }
810 
811 }
812 
813 
814 
815 
816 
817 /**
818  * Upgrade agent interface inspired by Lunyr.
819  *
820  * Upgrade agent transfers tokens to a new contract.
821  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
822  */
823 contract UpgradeAgent {
824 
825   uint public originalSupply;
826 
827   /** Interface marker */
828   function isUpgradeAgent() public constant returns (bool) {
829     return true;
830   }
831 
832   function upgradeFrom(address _from, uint256 _value) public;
833 
834 }
835 
836 
837 /**
838  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
839  *
840  * First envisioned by Golem and Lunyr projects.
841  */
842 contract UpgradeableToken is StandardToken {
843 
844   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
845   address public upgradeMaster;
846 
847   /** The next contract where the tokens will be migrated. */
848   UpgradeAgent public upgradeAgent;
849 
850   /** How many tokens we have upgraded by now. */
851   uint256 public totalUpgraded;
852 
853   /**
854    * Upgrade states.
855    *
856    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
857    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
858    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
859    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
860    *
861    */
862   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
863 
864   /**
865    * Somebody has upgraded some of his tokens.
866    */
867   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
868 
869   /**
870    * New upgrade agent available.
871    */
872   event UpgradeAgentSet(address agent);
873 
874   /**
875    * Do not allow construction without upgrade master set.
876    */
877   function UpgradeableToken(address _upgradeMaster) {
878     upgradeMaster = _upgradeMaster;
879   }
880 
881   /**
882    * Allow the token holder to upgrade some of their tokens to a new contract.
883    */
884   function upgrade(uint256 value) public {
885 
886       UpgradeState state = getUpgradeState();
887       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
888         // Called in a bad state
889         throw;
890       }
891 
892       // Validate input value.
893       if (value == 0) throw;
894 
895       balances[msg.sender] = safeSub(balances[msg.sender], value);
896 
897       // Take tokens out from circulation
898       totalSupply = safeSub(totalSupply, value);
899       totalUpgraded = safeAdd(totalUpgraded, value);
900 
901       // Upgrade agent reissues the tokens
902       upgradeAgent.upgradeFrom(msg.sender, value);
903       Upgrade(msg.sender, upgradeAgent, value);
904   }
905 
906   /**
907    * Set an upgrade agent that handles
908    */
909   function setUpgradeAgent(address agent) external {
910 
911       if(!canUpgrade()) {
912         // The token is not yet in a state that we could think upgrading
913         throw;
914       }
915 
916       if (agent == 0x0) throw;
917       // Only a master can designate the next agent
918       if (msg.sender != upgradeMaster) throw;
919       // Upgrade has already begun for an agent
920       if (getUpgradeState() == UpgradeState.Upgrading) throw;
921 
922       upgradeAgent = UpgradeAgent(agent);
923 
924       // Bad interface
925       if(!upgradeAgent.isUpgradeAgent()) throw;
926       // Make sure that token supplies match in source and target
927       if (upgradeAgent.originalSupply() != totalSupply) throw;
928 
929       UpgradeAgentSet(upgradeAgent);
930   }
931 
932   /**
933    * Get the state of the token upgrade.
934    */
935   function getUpgradeState() public constant returns(UpgradeState) {
936     if(!canUpgrade()) return UpgradeState.NotAllowed;
937     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
938     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
939     else return UpgradeState.Upgrading;
940   }
941 
942   /**
943    * Change the upgrade master.
944    *
945    * This allows us to set a new owner for the upgrade mechanism.
946    */
947   function setUpgradeMaster(address master) public {
948       if (master == 0x0) throw;
949       if (msg.sender != upgradeMaster) throw;
950       upgradeMaster = master;
951   }
952 
953   /**
954    * Child contract can enable to provide the condition when the upgrade can begun.
955    */
956   function canUpgrade() public constant returns(bool) {
957      return true;
958   }
959 
960 }
961 
962 
963 
964 
965 
966 
967 /**
968  * Define interface for releasing the token transfer after a successful crowdsale.
969  */
970 contract ReleasableToken is ERC20, Ownable {
971 
972   /* The finalizer contract that allows unlift the transfer limits on this token */
973   address public releaseAgent;
974 
975   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
976   bool public released = false;
977 
978   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
979   mapping (address => bool) public transferAgents;
980 
981   /**
982    * Limit token transfer until the crowdsale is over.
983    *
984    */
985   modifier canTransfer(address _sender) {
986 
987     if(!released) {
988         if(!transferAgents[_sender]) {
989             throw;
990         }
991     }
992 
993     _;
994   }
995 
996   /**
997    * Set the contract that can call release and make the token transferable.
998    *
999    * Design choice. Allow reset the release agent to fix fat finger mistakes.
1000    */
1001   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
1002 
1003     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
1004     releaseAgent = addr;
1005   }
1006 
1007   /**
1008    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
1009    */
1010   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
1011     transferAgents[addr] = state;
1012   }
1013 
1014   /**
1015    * One way function to release the tokens to the wild.
1016    *
1017    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
1018    */
1019   function releaseTokenTransfer() public onlyReleaseAgent {
1020     released = true;
1021   }
1022 
1023   /** The function can be called only before or after the tokens have been releasesd */
1024   modifier inReleaseState(bool releaseState) {
1025     if(releaseState != released) {
1026         throw;
1027     }
1028     _;
1029   }
1030 
1031   /** The function can be called only by a whitelisted release agent. */
1032   modifier onlyReleaseAgent() {
1033     if(msg.sender != releaseAgent) {
1034         throw;
1035     }
1036     _;
1037   }
1038 
1039   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
1040     // Call StandardToken.transfer()
1041    return super.transfer(_to, _value);
1042   }
1043 
1044   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
1045     // Call StandardToken.transferForm()
1046     return super.transferFrom(_from, _to, _value);
1047   }
1048 
1049 }
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 /**
1058  * A token that can increase its supply by another contract.
1059  *
1060  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1061  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1062  *
1063  */
1064 contract MintableToken is StandardToken, Ownable {
1065 
1066   using SafeMathLib for uint;
1067 
1068   bool public mintingFinished = false;
1069 
1070   /** List of agents that are allowed to create new tokens */
1071   mapping (address => bool) public mintAgents;
1072 
1073   /**
1074    * Create new tokens and allocate them to an address..
1075    *
1076    * Only callably by a crowdsale contract (mint agent).
1077    */
1078   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1079 
1080     if(amount == 0) {
1081       throw;
1082     }
1083 
1084     totalSupply = totalSupply.plus(amount);
1085     balances[receiver] = balances[receiver].plus(amount);
1086     Minted(receiver, amount);
1087   }
1088 
1089   /**
1090    * Owner can allow a crowdsale contract to mint new tokens.
1091    */
1092   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1093     mintAgents[addr] = state;
1094   }
1095 
1096   modifier onlyMintAgent() {
1097     // Only crowdsale contracts are allowed to mint new tokens
1098     if(!mintAgents[msg.sender]) {
1099         throw;
1100     }
1101     _;
1102   }
1103 
1104   /** Make sure we are not done yet. */
1105   modifier canMint() {
1106     if(mintingFinished) throw;
1107     _;
1108   }
1109 }
1110 
1111 
1112 
1113 
1114 /**
1115  * A crowdsaled token.
1116  *
1117  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1118  *
1119  * - The token transfer() is disabled until the crowdsale is over
1120  * - The token contract gives an opt-in upgrade path to a new contract
1121  * - The same token can be part of several crowdsales through approve() mechanism
1122  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1123  *
1124  */
1125 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
1126 
1127   event UpdatedTokenInformation(string newName, string newSymbol);
1128 
1129   string public name;
1130 
1131   string public symbol;
1132 
1133   uint public decimals;
1134 
1135   /**
1136    * Construct the token.
1137    *
1138    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1139    */
1140   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
1141     UpgradeableToken(msg.sender) {
1142 
1143     // Create any address, can be transferred
1144     // to team multisig via changeOwner(),
1145     // also remember to call setUpgradeMaster()
1146     owner = msg.sender;
1147 
1148     name = _name;
1149     symbol = _symbol;
1150 
1151     totalSupply = _initialSupply;
1152 
1153     decimals = _decimals;
1154 
1155     // Create initially all balance on the team multisig
1156     balances[owner] = totalSupply;
1157   }
1158 
1159   /**
1160    * When token is released to be transferable, enforce no new tokens can be created.
1161    */
1162   function releaseTokenTransfer() public onlyReleaseAgent {
1163     mintingFinished = true;
1164     super.releaseTokenTransfer();
1165   }
1166 
1167   /**
1168    * Allow upgrade agent functionality kick in only if the crowdsale was success.
1169    */
1170   function canUpgrade() public constant returns(bool) {
1171     return released;
1172   }
1173 
1174   /**
1175    * Owner can update token information here
1176    */
1177   function setTokenInformation(string _name, string _symbol) onlyOwner {
1178     name = _name;
1179     symbol = _symbol;
1180 
1181     UpdatedTokenInformation(name, symbol);
1182   }
1183 
1184 }
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 
1193 /**
1194  * Fixed crowdsale pricing - everybody gets the same price.
1195  */
1196 contract MysteriumPricing is PricingStrategy, Ownable {
1197 
1198   using SafeMathLib for uint;
1199 
1200   // The conversion rate: how many weis is 1 CHF
1201   // https://www.coingecko.com/en/price_charts/ethereum/chf
1202   // 120.34587901 is 1203458
1203   uint public chfRate;
1204 
1205   uint public chfScale = 10000;
1206 
1207   /* How many weis one token costs */
1208   uint public hardCapPrice = 12000;  // 1.2 * 10000 Expressed as CFH base points
1209 
1210   uint public softCapPrice = 10000;  // 1.0 * 10000 Expressed as CFH base points
1211 
1212   uint public softCapCHF = 6000000 * 10000; // Soft cap set in CHF
1213 
1214   //Address of the ICO contract:
1215   Crowdsale public crowdsale;
1216 
1217   function MysteriumPricing(uint initialChfRate) {
1218     chfRate = initialChfRate;
1219   }
1220 
1221   /// @dev Setting crowdsale for setConversionRate()
1222   /// @param _crowdsale The address of our ICO contract
1223   function setCrowdsale(Crowdsale _crowdsale) onlyOwner {
1224 
1225     if(!_crowdsale.isCrowdsale()) {
1226       throw;
1227     }
1228 
1229     crowdsale = _crowdsale;
1230   }
1231 
1232   /// @dev Here you can set the new CHF/ETH rate
1233   /// @param _chfRate The rate how many weis is one CHF
1234   function setConversionRate(uint _chfRate) onlyOwner {
1235     //Here check if ICO is active
1236     if(now > crowdsale.startsAt())
1237       throw;
1238 
1239     chfRate = _chfRate;
1240   }
1241 
1242   /**
1243    * Allow to set soft cap.
1244    */
1245   function setSoftCapCHF(uint _softCapCHF) onlyOwner {
1246     softCapCHF = _softCapCHF;
1247   }
1248 
1249   /**
1250    * Get CHF/ETH pair as an integer.
1251    *
1252    * Used in distribution calculations.
1253    */
1254   function getEthChfPrice() public constant returns (uint) {
1255     return chfRate / chfScale;
1256   }
1257 
1258   /**
1259    * Currency conversion
1260    *
1261    * @param  chf CHF price * 100000
1262    * @return wei price
1263    */
1264   function convertToWei(uint chf) public constant returns(uint) {
1265     return chf.times(10**18) / chfRate;
1266   }
1267 
1268   /// @dev Function which tranforms CHF softcap to weis
1269   function getSoftCapInWeis() public returns (uint) {
1270     return convertToWei(softCapCHF);
1271   }
1272 
1273   /**
1274    * Calculate the current price for buy in amount.
1275    *
1276    * @param  {uint amount} How many tokens we get
1277    */
1278   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1279 
1280     uint multiplier = 10 ** decimals;
1281     if (weiRaised > getSoftCapInWeis()) {
1282       //Here SoftCap is not active yet
1283       return value.times(multiplier) / convertToWei(hardCapPrice);
1284     } else {
1285       return value.times(multiplier) / convertToWei(softCapPrice);
1286     }
1287   }
1288 
1289 }
1290 
1291 
1292 
1293 /**
1294  * At the end of the successful crowdsale allocate % bonus of tokens and other parties.
1295  *
1296  * Unlock tokens.
1297  *
1298  */
1299 contract MysteriumTokenDistribution is FinalizeAgent, Ownable {
1300 
1301   using SafeMathLib for uint;
1302 
1303   CrowdsaleToken public token;
1304   Crowdsale public crowdsale;
1305 
1306   MysteriumPricing public mysteriumPricing;
1307 
1308   // Vaults:
1309   address futureRoundVault;
1310   address foundationWallet;
1311   address teamVault;
1312   address seedVault1; //  0
1313   address seedVault2; //  12 months
1314 
1315   // Expose the state of distribute for the examination
1316   uint public future_round_coins;
1317   uint public foundation_coins;
1318   uint public team_coins;
1319   uint public seed_coins_vault1;
1320   uint public seed_coins_vault2;
1321 
1322   function MysteriumTokenDistribution(CrowdsaleToken _token, Crowdsale _crowdsale, MysteriumPricing _mysteriumPricing) {
1323     token = _token;
1324     crowdsale = _crowdsale;
1325 
1326     // Interface check
1327     if(!crowdsale.isCrowdsale()) {
1328       throw;
1329     }
1330 
1331     mysteriumPricing = _mysteriumPricing;
1332   }
1333 
1334   /**
1335    * Post crowdsale distribution process.
1336    *
1337    * Exposed as public to make it testable.
1338    */
1339   function distribute(uint amount_raised_chf, uint eth_chf_price) {
1340 
1341     // Only crowdsale contract or owner (manually) can trigger the distribution
1342     if(!(msg.sender == address(crowdsale) || msg.sender == owner)) {
1343       throw;
1344     }
1345 
1346     // Distribute:
1347     // seed coins
1348     // foundation coins
1349     // team coins
1350     // future_round_coins
1351 
1352     future_round_coins = 486500484333000;
1353     foundation_coins = 291900290600000;
1354     team_coins = 324333656222000;
1355     seed_coins_vault1 = 122400000000000;
1356     seed_coins_vault2 = 489600000000000;
1357 
1358     token.mint(futureRoundVault, future_round_coins);
1359     token.mint(foundationWallet, foundation_coins);
1360     token.mint(teamVault, team_coins);
1361     token.mint(seedVault1, seed_coins_vault1);
1362     token.mint(seedVault2, seed_coins_vault2);
1363   }
1364 
1365   /// @dev Here you can set all the Vaults
1366   function setVaults(
1367     address _futureRoundVault,
1368     address _foundationWallet,
1369     address _teamVault,
1370     address _seedVault1,
1371     address _seedVault2
1372   ) onlyOwner {
1373     futureRoundVault = _futureRoundVault;
1374     foundationWallet = _foundationWallet;
1375     teamVault = _teamVault;
1376     seedVault1 = _seedVault1;
1377     seedVault2 = _seedVault2;
1378   }
1379 
1380   /* Can we run finalize properly */
1381   function isSane() public constant returns (bool) {
1382     // TODO: Check all vaults implement the correct vault interface
1383     return true;
1384   }
1385 
1386   function getDistributionFacts() public constant returns (uint chfRaised, uint chfRate) {
1387     uint _chfRate = mysteriumPricing.getEthChfPrice();
1388     return(crowdsale.weiRaised().times(_chfRate) / (10**18), _chfRate);
1389   }
1390 
1391   /** Called once by crowdsale finalize() if the sale was success. */
1392   function finalizeCrowdsale() public {
1393 
1394     if(msg.sender == address(crowdsale) || msg.sender == owner) {
1395       // The owner can distribute tokens for testing and in emergency
1396       // Crowdsale distributes tokens at the end of the crowdsale
1397       var (chfRaised, chfRate) = getDistributionFacts();
1398       distribute(chfRaised, chfRate);
1399     } else {
1400        throw;
1401     }
1402   }
1403 
1404 }