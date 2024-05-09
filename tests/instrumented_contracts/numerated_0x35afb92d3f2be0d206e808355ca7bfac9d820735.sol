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
814 /**
815  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
816  *
817  * - Collect funds from pre-sale investors
818  * - Send funds to the crowdsale when it opens
819  * - Allow owner to set the crowdsale
820  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
821  * - Allow unlimited investors
822  *
823  */
824 contract MultiVault is Ownable {
825 
826   using SafeMathLib for uint;
827 
828   /** How many investors we have now */
829   uint public investorCount;
830 
831   /** How many wei we have raised total. We use this as the distribution total amount. However because investors are added by hand this can be direct percentages too. */
832   uint public weiRaisedTotal;
833 
834   /** Who are our investors (iterable) */
835   address[] public investors;
836 
837   /** How much they have invested */
838   mapping(address => uint) public balances;
839 
840   /** How many tokens investors have claimed */
841   mapping(address => uint) public claimed;
842 
843   /** When our claim freeze is over (UNIT timestamp) */
844   uint public freezeEndsAt;
845 
846   /** Our ICO contract where we will move the funds */
847   Crowdsale public crowdsale;
848 
849   /** We can also define our own token, which will override the ICO one ***/
850   FractionalERC20 public token;
851 
852   /** How many tokens were deposited on the vautl */
853   uint public initialTokenBalance;
854 
855   /* Has owner set the initial balance */
856   bool public initialTokenBalanceFetched;
857 
858   /** What is our current state. */
859   enum State{Unknown, Holding, Distributing}
860 
861   /** Somebody loaded their investment money */
862   event Invested(address investor, uint value);
863 
864   /** We distributed tokens to an investor */
865   event Distributed(address investors, uint count);
866 
867   /**
868    * Create presale contract where lock up period is given days
869    */
870   function MultiVault(address _owner, uint _freezeEndsAt) {
871 
872     owner = _owner;
873 
874     // Give argument
875     if(_freezeEndsAt == 0) {
876       throw;
877     }
878 
879     freezeEndsAt = _freezeEndsAt;
880   }
881 
882   /**
883    * Get the token we are distributing.
884    */
885   function getToken() public constant returns(FractionalERC20) {
886     if (address(token) > 0)
887       return token;
888 
889     if(address(crowdsale) == 0)  {
890       throw;
891     }
892 
893     return crowdsale.token();
894   }
895 
896   /**
897    * Participate to a presale.
898    */
899   function addInvestor(address investor, uint amount) public onlyOwner {
900 
901     // Cannot invest anymore through crowdsale when moving has begun
902     if(getState() != State.Holding) throw;
903 
904     if(amount == 0) throw; // No empty buys
905 
906     bool existing = balances[investor] > 0;
907 
908     if(existing) {
909       // Guarantee data load against race conditiosn
910       // and fat fingers, so that we can load one investor only once
911       throw;
912     }
913 
914     balances[investor] = balances[investor].plus(amount);
915 
916     // This is a new investor
917     if(!existing) {
918       investors.push(investor);
919       investorCount++;
920     }
921 
922     weiRaisedTotal = weiRaisedTotal.plus(amount);
923 
924     Invested(investor, amount);
925   }
926 
927   /**
928    * How may tokens each investor gets.
929    */
930   function getClaimAmount(address investor) public constant returns (uint) {
931 
932     if(!initialTokenBalanceFetched) {
933       throw;
934     }
935 
936     return initialTokenBalance.times(balances[investor]) / weiRaisedTotal;
937   }
938 
939   /**
940    * How many tokens remain unclaimed for an investor.
941    */
942   function getClaimLeft(address investor) public constant returns (uint) {
943     return getClaimAmount(investor).minus(claimed[investor]);
944   }
945 
946   /**
947    * Claim all remaining tokens for this investor.
948    */
949   function claimAll() {
950     claim(getClaimLeft(msg.sender));
951   }
952 
953   /**
954    * Only owner is allowed to set the vault initial token balance.
955    *
956    * Because only owner can guarantee that the all tokens have been moved
957    * to the vault and it can begin disribution. Otherwise somecone can
958    * call this too early and lock the balance to zero or some other bad value.
959    */
960   function fetchTokenBalance() onlyOwner {
961     // Caching fetched token amount:
962     if (!initialTokenBalanceFetched) {
963         initialTokenBalance = getToken().balanceOf(address(this));
964         if(initialTokenBalance == 0) throw; // Somehow in invalid state
965         initialTokenBalanceFetched = true;
966     } else {
967       throw;
968     }
969   }
970 
971   /**
972    * Claim N bought tokens to the investor as the msg sender.
973    *
974    */
975   function claim(uint amount) {
976     address investor = msg.sender;
977 
978     if(!initialTokenBalanceFetched) {
979       // We need to have the balance before we start
980       throw;
981     }
982 
983     if(getState() != State.Distributing) {
984       // We are not distributing yet
985       throw;
986     }
987 
988     if(getClaimLeft(investor) < amount) {
989       // Woops we cannot get more than we have left
990       throw;
991     }
992 
993     claimed[investor] = claimed[investor].plus(amount);
994     getToken().transfer(investor, amount);
995 
996     Distributed(investor, amount);
997   }
998 
999   /**
1000    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1001    */
1002   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1003     crowdsale = _crowdsale;
1004   }
1005 
1006   /**
1007    * Set the target token, which overrides the ICO token.
1008    */
1009   function setToken(FractionalERC20 _token) public onlyOwner {
1010     token = _token;
1011   }
1012 
1013   /**
1014    * Resolve the contract umambigious state.
1015    */
1016   function getState() public returns(State) {
1017     if(now > freezeEndsAt && initialTokenBalanceFetched) {
1018       return State.Distributing;
1019     } else {
1020       return State.Holding;
1021     }
1022   }
1023 
1024   /** Explicitly call function from your wallet. */
1025   function() payable {
1026     throw;
1027   }
1028 }