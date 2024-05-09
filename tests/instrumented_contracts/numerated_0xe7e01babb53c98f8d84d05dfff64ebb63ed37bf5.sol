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
653  * Fixed crowdsale pricing - everybody gets the same price.
654  */
655 contract MysteriumPricing is PricingStrategy, Ownable {
656 
657   using SafeMathLib for uint;
658 
659   // The conversion rate: how many weis is 1 CHF
660   // https://www.coingecko.com/en/price_charts/ethereum/chf
661   // 120.34587901 is 1203458
662   uint public chfRate;
663 
664   uint public chfScale = 10000;
665 
666   /* How many weis one token costs */
667   uint public hardCapPrice = 12000;  // 1.2 * 10000 Expressed as CFH base points
668 
669   uint public softCapPrice = 10000;  // 1.0 * 10000 Expressed as CFH base points
670 
671   uint public softCapCHF = 6000000 * 10000; // Soft cap set in CHF
672 
673   //Address of the ICO contract:
674   Crowdsale public crowdsale;
675 
676   function MysteriumPricing(uint initialChfRate) {
677     chfRate = initialChfRate;
678   }
679 
680   /// @dev Setting crowdsale for setConversionRate()
681   /// @param _crowdsale The address of our ICO contract
682   function setCrowdsale(Crowdsale _crowdsale) onlyOwner {
683 
684     if(!_crowdsale.isCrowdsale()) {
685       throw;
686     }
687 
688     crowdsale = _crowdsale;
689   }
690 
691   /// @dev Here you can set the new CHF/ETH rate
692   /// @param _chfRate The rate how many weis is one CHF
693   function setConversionRate(uint _chfRate) onlyOwner {
694     //Here check if ICO is active
695     if(now > crowdsale.startsAt())
696       throw;
697 
698     chfRate = _chfRate;
699   }
700 
701   /**
702    * Allow to set soft cap.
703    */
704   function setSoftCapCHF(uint _softCapCHF) onlyOwner {
705     softCapCHF = _softCapCHF;
706   }
707 
708   /**
709    * Get CHF/ETH pair as an integer.
710    *
711    * Used in distribution calculations.
712    */
713   function getEthChfPrice() public constant returns (uint) {
714     return chfRate / chfScale;
715   }
716 
717   /**
718    * Currency conversion
719    *
720    * @param  chf CHF price * 100000
721    * @return wei price
722    */
723   function convertToWei(uint chf) public constant returns(uint) {
724     return chf.times(10**18) / chfRate;
725   }
726 
727   /// @dev Function which tranforms CHF softcap to weis
728   function getSoftCapInWeis() public returns (uint) {
729     return convertToWei(softCapCHF);
730   }
731 
732   /**
733    * Calculate the current price for buy in amount.
734    *
735    * @param  {uint amount} How many tokens we get
736    */
737   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
738 
739     uint multiplier = 10 ** decimals;
740     if (weiRaised > getSoftCapInWeis()) {
741       //Here SoftCap is not active yet
742       return value.times(multiplier) / convertToWei(hardCapPrice);
743     } else {
744       return value.times(multiplier) / convertToWei(softCapPrice);
745     }
746   }
747 
748 }
749 
750 
751 
752 
753 
754 
755 
756 
757 /**
758  * Math operations with safety checks
759  */
760 contract SafeMath {
761   function safeMul(uint a, uint b) internal returns (uint) {
762     uint c = a * b;
763     assert(a == 0 || c / a == b);
764     return c;
765   }
766 
767   function safeDiv(uint a, uint b) internal returns (uint) {
768     assert(b > 0);
769     uint c = a / b;
770     assert(a == b * c + a % b);
771     return c;
772   }
773 
774   function safeSub(uint a, uint b) internal returns (uint) {
775     assert(b <= a);
776     return a - b;
777   }
778 
779   function safeAdd(uint a, uint b) internal returns (uint) {
780     uint c = a + b;
781     assert(c>=a && c>=b);
782     return c;
783   }
784 
785   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
786     return a >= b ? a : b;
787   }
788 
789   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
790     return a < b ? a : b;
791   }
792 
793   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
794     return a >= b ? a : b;
795   }
796 
797   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
798     return a < b ? a : b;
799   }
800 
801   function assert(bool assertion) internal {
802     if (!assertion) {
803       throw;
804     }
805   }
806 }
807 
808 
809 
810 /**
811  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
812  *
813  * Based on code by FirstBlood:
814  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
815  */
816 contract StandardToken is ERC20, SafeMath {
817 
818   /* Token supply got increased and a new owner received these tokens */
819   event Minted(address receiver, uint amount);
820 
821   /* Actual balances of token holders */
822   mapping(address => uint) balances;
823 
824   /* approve() allowances */
825   mapping (address => mapping (address => uint)) allowed;
826 
827   /**
828    *
829    * Fix for the ERC20 short address attack
830    *
831    * http://vessenes.com/the-erc20-short-address-attack-explained/
832    */
833   modifier onlyPayloadSize(uint size) {
834      if(msg.data.length != size + 4) {
835        throw;
836      }
837      _;
838   }
839 
840   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
841     balances[msg.sender] = safeSub(balances[msg.sender], _value);
842     balances[_to] = safeAdd(balances[_to], _value);
843     Transfer(msg.sender, _to, _value);
844     return true;
845   }
846 
847   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
848     uint _allowance = allowed[_from][msg.sender];
849 
850     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
851     // if (_value > _allowance) throw;
852 
853     balances[_to] = safeAdd(balances[_to], _value);
854     balances[_from] = safeSub(balances[_from], _value);
855     allowed[_from][msg.sender] = safeSub(_allowance, _value);
856     Transfer(_from, _to, _value);
857     return true;
858   }
859 
860   function balanceOf(address _owner) constant returns (uint balance) {
861     return balances[_owner];
862   }
863 
864   function approve(address _spender, uint _value) returns (bool success) {
865 
866     // To change the approve amount you first have to reduce the addresses`
867     //  allowance to zero by calling `approve(_spender, 0)` if it is not
868     //  already 0 to mitigate the race condition described here:
869     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
870     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
871 
872     allowed[msg.sender][_spender] = _value;
873     Approval(msg.sender, _spender, _value);
874     return true;
875   }
876 
877   function allowance(address _owner, address _spender) constant returns (uint remaining) {
878     return allowed[_owner][_spender];
879   }
880 
881   /**
882    * Atomic increment of approved spending
883    *
884    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
885    *
886    */
887   function addApproval(address _spender, uint _addedValue)
888   onlyPayloadSize(2 * 32)
889   returns (bool success) {
890       uint oldValue = allowed[msg.sender][_spender];
891       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
892       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
893       return true;
894   }
895 
896   /**
897    * Atomic decrement of approved spending.
898    *
899    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
900    */
901   function subApproval(address _spender, uint _subtractedValue)
902   onlyPayloadSize(2 * 32)
903   returns (bool success) {
904 
905       uint oldVal = allowed[msg.sender][_spender];
906 
907       if (_subtractedValue > oldVal) {
908           allowed[msg.sender][_spender] = 0;
909       } else {
910           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
911       }
912       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
913       return true;
914   }
915 
916 }
917 
918 
919 
920 
921 /**
922  * A token that can increase its supply by another contract.
923  *
924  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
925  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
926  *
927  */
928 contract MintableToken is StandardToken, Ownable {
929 
930   using SafeMathLib for uint;
931 
932   bool public mintingFinished = false;
933 
934   /** List of agents that are allowed to create new tokens */
935   mapping (address => bool) public mintAgents;
936 
937   /**
938    * Create new tokens and allocate them to an address..
939    *
940    * Only callably by a crowdsale contract (mint agent).
941    */
942   function mint(address receiver, uint amount) onlyMintAgent canMint public {
943 
944     if(amount == 0) {
945       throw;
946     }
947 
948     totalSupply = totalSupply.plus(amount);
949     balances[receiver] = balances[receiver].plus(amount);
950     Minted(receiver, amount);
951   }
952 
953   /**
954    * Owner can allow a crowdsale contract to mint new tokens.
955    */
956   function setMintAgent(address addr, bool state) onlyOwner canMint public {
957     mintAgents[addr] = state;
958   }
959 
960   modifier onlyMintAgent() {
961     // Only crowdsale contracts are allowed to mint new tokens
962     if(!mintAgents[msg.sender]) {
963         throw;
964     }
965     _;
966   }
967 
968   /** Make sure we are not done yet. */
969   modifier canMint() {
970     if(mintingFinished) throw;
971     _;
972   }
973 }
974 
975 
976 
977 contract MysteriumCrowdsale is Crowdsale {
978   using SafeMathLib for uint;
979 
980   // Are we on the "end slope" (triggered after soft cap)
981   bool public softCapTriggered;
982 
983   // The default minimum funding limit 7,000,000 CHF
984   uint public minimumFundingCHF = 700000 * 10000;
985 
986   uint public hardCapCHF = 14000000 * 10000;
987 
988   function MysteriumCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end)
989     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, 0) {
990   }
991 
992   /// @dev triggerSoftCap triggers the earlier closing time
993   function triggerSoftCap() private {
994     if(softCapTriggered)
995       throw;
996 
997     uint softCap = MysteriumPricing(pricingStrategy).getSoftCapInWeis();
998 
999     if(softCap > weiRaised)
1000       throw;
1001 
1002     // When contracts are updated from upstream, you should use:
1003     // setEndsAt (now + 24 hours);
1004     endsAt = now + (3*24*3600);
1005     EndsAtChanged(endsAt);
1006 
1007     softCapTriggered = true;
1008   }
1009 
1010   /**
1011    * Hook in to provide the soft cap time bomb.
1012    */
1013   function onInvest() internal {
1014      if(!softCapTriggered) {
1015          uint softCap = MysteriumPricing(pricingStrategy).getSoftCapInWeis();
1016          if(weiRaised > softCap) {
1017            triggerSoftCap();
1018          }
1019      }
1020   }
1021 
1022   /**
1023    * Get minimum funding goal in wei.
1024    */
1025   function getMinimumFundingGoal() public constant returns (uint goalInWei) {
1026     return MysteriumPricing(pricingStrategy).convertToWei(minimumFundingCHF);
1027   }
1028 
1029   /**
1030    * Allow reset the threshold.
1031    */
1032   function setMinimumFundingLimit(uint chf) onlyOwner {
1033     minimumFundingCHF = chf;
1034   }
1035 
1036   /**
1037    * @return true if the crowdsale has raised enough money to be a succes
1038    */
1039   function isMinimumGoalReached() public constant returns (bool reached) {
1040     return weiRaised >= getMinimumFundingGoal();
1041   }
1042 
1043   function getHardCap() public constant returns (uint capInWei) {
1044     return MysteriumPricing(pricingStrategy).convertToWei(hardCapCHF);
1045   }
1046 
1047   /**
1048    * Reset hard cap.
1049    *
1050    * Give price in CHF * 10000
1051    */
1052   function setHardCapCHF(uint _hardCapCHF) onlyOwner {
1053     hardCapCHF = _hardCapCHF;
1054   }
1055 
1056   /**
1057    * Called from invest() to confirm if the curret investment does not break our cap rule.
1058    */
1059   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1060     return weiRaisedTotal > getHardCap();
1061   }
1062 
1063   function isCrowdsaleFull() public constant returns (bool) {
1064     return weiRaised >= getHardCap();
1065   }
1066 
1067   /**
1068    * @return true we have reached our soft cap
1069    */
1070   function isSoftCapReached() public constant returns (bool reached) {
1071     return weiRaised >= MysteriumPricing(pricingStrategy).getSoftCapInWeis();
1072   }
1073 
1074 
1075   /**
1076    * Dynamically create tokens and assign them to the investor.
1077    */
1078   function assignTokens(address receiver, uint tokenAmount) private {
1079     MintableToken mintableToken = MintableToken(token);
1080     mintableToken.mint(receiver, tokenAmount);
1081   }
1082 
1083 }