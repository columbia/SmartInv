1 /**
2  * Interface for defining crowdsale pricing.
3  */
4 contract PricingStrategy {
5 
6   /** Interface declaration. */
7   function isPricingStrategy() public constant returns (bool) {
8     return true;
9   }
10 
11   /** Self check if all references are correctly set.
12    *
13    * Checks that pricing strategy matches crowdsale parameters.
14    */
15   function isSane(address crowdsale) public constant returns (bool) {
16     return true;
17   }
18 
19   /**
20    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
21    *
22    *
23    * @param value - What is the value of the transaction send in as wei
24    * @param tokensSold - how much tokens have been sold this far
25    * @param weiRaised - how much money has been raised this far
26    * @param msgSender - who is the investor of this transaction
27    * @param decimals - how many decimal units the token has
28    * @return Amount of tokens the investor receives
29    */
30   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
31 }
32 
33 
34 
35 /**
36  * Safe unsigned safe math.
37  *
38  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
39  *
40  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
41  *
42  * Maintained here until merged to mainline zeppelin-solidity.
43  *
44  */
45 library SafeMathLib {
46 
47   function times(uint a, uint b) returns (uint) {
48     uint c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function minus(uint a, uint b) returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function plus(uint a, uint b) returns (uint) {
59     uint c = a + b;
60     assert(c>=a);
61     return c;
62   }
63 
64   function assert(bool assertion) private {
65     if (!assertion) throw;
66   }
67 }
68 
69 
70 
71 
72 /*
73  * Ownable
74  *
75  * Base contract with an owner.
76  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
77  */
78 contract Ownable {
79   address public owner;
80 
81   function Ownable() {
82     owner = msg.sender;
83   }
84 
85   modifier onlyOwner() {
86     if (msg.sender != owner) {
87       throw;
88     }
89     _;
90   }
91 
92   function transferOwnership(address newOwner) onlyOwner {
93     if (newOwner != address(0)) {
94       owner = newOwner;
95     }
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
135 
136 
137 /**
138  * Finalize agent defines what happens at the end of succeseful crowdsale.
139  *
140  * - Allocate tokens for founders, bounties and community
141  * - Make tokens transferable
142  * - etc.
143  */
144 contract FinalizeAgent {
145 
146   function isFinalizeAgent() public constant returns(bool) {
147     return true;
148   }
149 
150   /** Return true if we can run finalizeCrowdsale() properly.
151    *
152    * This is a safety check function that doesn't allow crowdsale to begin
153    * unless the finalizer has been set up properly.
154    */
155   function isSane() public constant returns (bool);
156 
157   /** Called once by crowdsale finalize() if the sale was success. */
158   function finalizeCrowdsale();
159 
160 }
161 
162 
163 
164 
165 /*
166  * ERC20 interface
167  * see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 {
170   uint public totalSupply;
171   function balanceOf(address who) constant returns (uint);
172   function allowance(address owner, address spender) constant returns (uint);
173 
174   function transfer(address to, uint value) returns (bool ok);
175   function transferFrom(address from, address to, uint value) returns (bool ok);
176   function approve(address spender, uint value) returns (bool ok);
177   event Transfer(address indexed from, address indexed to, uint value);
178   event Approval(address indexed owner, address indexed spender, uint value);
179 }
180 
181 
182 /**
183  * A token that defines fractional units as decimals.
184  */
185 contract FractionalERC20 is ERC20 {
186 
187   uint public decimals;
188 
189 }
190 
191 
192 
193 /**
194  * Abstract base contract for token sales.
195  *
196  * Handle
197  * - start and end dates
198  * - accepting investments
199  * - minimum funding goal and refund
200  * - various statistics during the crowdfund
201  * - different pricing strategies
202  * - different investment policies (require server side customer id, allow only whitelisted addresses)
203  *
204  */
205 contract Crowdsale is Haltable {
206 
207   /* Max investment count when we are still allowed to change the multisig address */
208   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
209 
210   using SafeMathLib for uint;
211 
212   /* The token we are selling */
213   FractionalERC20 public token;
214 
215   /* How we are going to price our offering */
216   PricingStrategy public pricingStrategy;
217 
218   /* Post-success callback */
219   FinalizeAgent public finalizeAgent;
220 
221   /* tokens will be transfered from this address */
222   address public multisigWallet;
223 
224   /* if the funding goal is not reached, investors may withdraw their funds */
225   uint public minimumFundingGoal;
226 
227   /* the UNIX timestamp start date of the crowdsale */
228   uint public startsAt;
229 
230   /* the UNIX timestamp end date of the crowdsale */
231   uint public endsAt;
232 
233   /* the number of tokens already sold through this contract*/
234   uint public tokensSold = 0;
235 
236   /* How many wei of funding we have raised */
237   uint public weiRaised = 0;
238 
239   /* How many distinct addresses have invested */
240   uint public investorCount = 0;
241 
242   /* How much wei we have returned back to the contract after a failed crowdfund. */
243   uint public loadedRefund = 0;
244 
245   /* How much wei we have given back to investors.*/
246   uint public weiRefunded = 0;
247 
248   /* Has this crowdsale been finalized */
249   bool public finalized;
250 
251   /* Do we need to have unique contributor id for each customer */
252   bool public requireCustomerId;
253 
254   /**
255     * Do we verify that contributor has been cleared on the server side (accredited investors only).
256     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
257     */
258   bool public requiredSignedAddress;
259 
260   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
261   address public signerAddress;
262 
263   /** How much ETH each address has invested to this crowdsale */
264   mapping (address => uint256) public investedAmountOf;
265 
266   /** How much tokens this crowdsale has credited for each investor address */
267   mapping (address => uint256) public tokenAmountOf;
268 
269   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
270   mapping (address => bool) public earlyParticipantWhitelist;
271 
272   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
273   uint public ownerTestValue;
274 
275   /** State machine
276    *
277    * - Preparing: All contract initialization calls and variables have not been set yet
278    * - Prefunding: We have not passed start time yet
279    * - Funding: Active crowdsale
280    * - Success: Minimum funding goal reached
281    * - Failure: Minimum funding goal not reached before ending time
282    * - Finalized: The finalized has been called and succesfully executed
283    * - Refunding: Refunds are loaded on the contract for reclaim.
284    */
285   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
286 
287   // A new investment was made
288   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
289 
290   // Refund was processed for a contributor
291   event Refund(address investor, uint weiAmount);
292 
293   // The rules were changed what kind of investments we accept
294   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
295 
296   // Address early participation whitelist status changed
297   event Whitelisted(address addr, bool status);
298 
299   // Crowdsale end time has been changed
300   event EndsAtChanged(uint endsAt);
301 
302   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
303 
304     owner = msg.sender;
305 
306     token = FractionalERC20(_token);
307 
308     setPricingStrategy(_pricingStrategy);
309 
310     multisigWallet = _multisigWallet;
311     if(multisigWallet == 0) {
312         throw;
313     }
314 
315     if(_start == 0) {
316         throw;
317     }
318 
319     startsAt = _start;
320 
321     if(_end == 0) {
322         throw;
323     }
324 
325     endsAt = _end;
326 
327     // Don't mess the dates
328     if(startsAt >= endsAt) {
329         throw;
330     }
331 
332     // Minimum funding goal can be zero
333     minimumFundingGoal = _minimumFundingGoal;
334   }
335 
336   /**
337    * Don't expect to just send in money and get tokens.
338    */
339   function() payable {
340     throw;
341   }
342 
343   /**
344    * Make an investment.
345    *
346    * Crowdsale must be running for one to invest.
347    * We must have not pressed the emergency brake.
348    *
349    * @param receiver The Ethereum address who receives the tokens
350    * @param customerId (optional) UUID v4 to track the successful payments on the server side
351    *
352    */
353   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
354 
355     // Determine if it's a good time to accept investment from this participant
356     if(getState() == State.PreFunding) {
357       // Are we whitelisted for early deposit
358       if(!earlyParticipantWhitelist[receiver]) {
359         throw;
360       }
361     } else if(getState() == State.Funding) {
362       // Retail participants can only come in when the crowdsale is running
363       // pass
364     } else {
365       // Unwanted state
366       throw;
367     }
368 
369     uint weiAmount = msg.value;
370     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
371 
372     if(tokenAmount == 0) {
373       // Dust transaction
374       throw;
375     }
376 
377     if(investedAmountOf[receiver] == 0) {
378        // A new investor
379        investorCount++;
380     }
381 
382     // Update investor
383     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
384     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
385 
386     // Update totals
387     weiRaised = weiRaised.plus(weiAmount);
388     tokensSold = tokensSold.plus(tokenAmount);
389 
390 
391     // Check that we did not bust the cap
392     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
393       throw;
394     }
395 
396     assignTokens(receiver, tokenAmount);
397 
398     // Pocket the money
399     if(!multisigWallet.send(weiAmount)) throw;
400 
401     // Tell us invest was success
402     Invested(receiver, weiAmount, tokenAmount, customerId);
403 
404   }
405 
406   /**
407    * Preallocate tokens for the early investors.
408    *
409    * Preallocated tokens have been sold before the actual crowdsale opens.
410    * This function mints the tokens and moves the crowdsale needle.
411    *
412    * Investor count is not handled; it is assumed this goes for multiple investors
413    * and the token distribution happens outside the smart contract flow.
414    *
415    * No money is exchanged, as the crowdsale team already have received the payment.
416    *
417    * @param fullTokens tokens as full tokens - decimal places added internally
418    * @param weiPrice Price of a single full token in wei
419    *
420    */
421   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
422 
423     uint tokenAmount = fullTokens * 10**token.decimals();
424     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
425 
426     weiRaised = weiRaised.plus(weiAmount);
427     tokensSold = tokensSold.plus(tokenAmount);
428 
429     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
430     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
431 
432     assignTokens(receiver, tokenAmount);
433 
434     // Tell us invest was success
435     Invested(receiver, weiAmount, tokenAmount, 0);
436   }
437 
438   /**
439    * Allow anonymous contributions to this crowdsale.
440    */
441   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
442      bytes32 hash = sha256(addr);
443      if (ecrecover(hash, v, r, s) != signerAddress) throw;
444      if(customerId == 0) throw;  // UUIDv4 sanity check
445      investInternal(addr, customerId);
446   }
447 
448   /**
449    * Track who is the customer making the payment so we can send thank you email.
450    */
451   function investWithCustomerId(address addr, uint128 customerId) public payable {
452     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
453     if(customerId == 0) throw;  // UUIDv4 sanity check
454     investInternal(addr, customerId);
455   }
456 
457   /**
458    * Allow anonymous contributions to this crowdsale.
459    */
460   function invest(address addr) public payable {
461     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
462     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
463     investInternal(addr, 0);
464   }
465 
466   /**
467    * Invest to tokens, recognize the payer and clear his address.
468    *
469    */
470   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
471     investWithSignedAddress(msg.sender, customerId, v, r, s);
472   }
473 
474   /**
475    * Invest to tokens, recognize the payer.
476    *
477    */
478   function buyWithCustomerId(uint128 customerId) public payable {
479     investWithCustomerId(msg.sender, customerId);
480   }
481 
482   /**
483    * The basic entry point to participate the crowdsale process.
484    *
485    * Pay for funding, get invested tokens back in the sender address.
486    */
487   function buy() public payable {
488     invest(msg.sender);
489   }
490 
491   /**
492    * Finalize a succcesful crowdsale.
493    *
494    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
495    */
496   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
497 
498     // Already finalized
499     if(finalized) {
500       throw;
501     }
502 
503     // Finalizing is optional. We only call it if we are given a finalizing agent.
504     if(address(finalizeAgent) != 0) {
505       finalizeAgent.finalizeCrowdsale();
506     }
507 
508     finalized = true;
509   }
510 
511   /**
512    * Allow to (re)set finalize agent.
513    *
514    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
515    */
516   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
517     finalizeAgent = addr;
518 
519     // Don't allow setting bad agent
520     if(!finalizeAgent.isFinalizeAgent()) {
521       throw;
522     }
523   }
524 
525   /**
526    * Set policy do we need to have server-side customer ids for the investments.
527    *
528    */
529   function setRequireCustomerId(bool value) onlyOwner {
530     requireCustomerId = value;
531     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
532   }
533 
534   /**
535    * Set policy if all investors must be cleared on the server side first.
536    *
537    * This is e.g. for the accredited investor clearing.
538    *
539    */
540   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
541     requiredSignedAddress = value;
542     signerAddress = _signerAddress;
543     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
544   }
545 
546   /**
547    * Allow addresses to do early participation.
548    *
549    * TODO: Fix spelling error in the name
550    */
551   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
552     earlyParticipantWhitelist[addr] = status;
553     Whitelisted(addr, status);
554   }
555 
556   /**
557    * Allow crowdsale owner to close early or extend the crowdsale.
558    *
559    * This is useful e.g. for a manual soft cap implementation:
560    * - after X amount is reached determine manual closing
561    *
562    * This may put the crowdsale to an invalid state,
563    * but we trust owners know what they are doing.
564    *
565    */
566   function setEndsAt(uint time) onlyOwner {
567 
568     if(now > time) {
569       throw; // Don't change past
570     }
571 
572     endsAt = time;
573     EndsAtChanged(endsAt);
574   }
575 
576   /**
577    * Allow to (re)set pricing strategy.
578    *
579    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
580    */
581   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
582     pricingStrategy = _pricingStrategy;
583 
584     // Don't allow setting bad agent
585     if(!pricingStrategy.isPricingStrategy()) {
586       throw;
587     }
588   }
589 
590   /**
591    * Allow to change the team multisig address in the case of emergency.
592    *
593    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
594    * (we have done only few test transactions). After the crowdsale is going
595    * then multisig address stays locked for the safety reasons.
596    */
597   function setMultisig(address addr) public onlyOwner {
598 
599     // Change
600     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
601       throw;
602     }
603 
604     multisigWallet = addr;
605   }
606 
607   /**
608    * Allow load refunds back on the contract for the refunding.
609    *
610    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
611    */
612   function loadRefund() public payable inState(State.Failure) {
613     if(msg.value == 0) throw;
614     loadedRefund = loadedRefund.plus(msg.value);
615   }
616 
617   /**
618    * Investors can claim refund.
619    *
620    * Note that any refunds from proxy buyers should be handled separately,
621    * and not through this contract.
622    */
623   function refund() public inState(State.Refunding) {
624     uint256 weiValue = investedAmountOf[msg.sender];
625     if (weiValue == 0) throw;
626     investedAmountOf[msg.sender] = 0;
627     weiRefunded = weiRefunded.plus(weiValue);
628     Refund(msg.sender, weiValue);
629     if (!msg.sender.send(weiValue)) throw;
630   }
631 
632   /**
633    * @return true if the crowdsale has raised enough money to be a successful.
634    */
635   function isMinimumGoalReached() public constant returns (bool reached) {
636     return weiRaised >= minimumFundingGoal;
637   }
638 
639   /**
640    * Check if the contract relationship looks good.
641    */
642   function isFinalizerSane() public constant returns (bool sane) {
643     return finalizeAgent.isSane();
644   }
645 
646   /**
647    * Check if the contract relationship looks good.
648    */
649   function isPricingSane() public constant returns (bool sane) {
650     return pricingStrategy.isSane(address(this));
651   }
652 
653   /**
654    * Crowdfund state machine management.
655    *
656    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
657    */
658   function getState() public constant returns (State) {
659     if(finalized) return State.Finalized;
660     else if (address(finalizeAgent) == 0) return State.Preparing;
661     else if (!finalizeAgent.isSane()) return State.Preparing;
662     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
663     else if (block.timestamp < startsAt) return State.PreFunding;
664     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
665     else if (isMinimumGoalReached()) return State.Success;
666     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
667     else return State.Failure;
668   }
669 
670   /** This is for manual testing of multisig wallet interaction */
671   function setOwnerTestValue(uint val) onlyOwner {
672     ownerTestValue = val;
673   }
674 
675   /** Interface marker. */
676   function isCrowdsale() public constant returns (bool) {
677     return true;
678   }
679 
680   //
681   // Modifiers
682   //
683 
684   /** Modified allowing execution only if the crowdsale is currently running.  */
685   modifier inState(State state) {
686     if(getState() != state) throw;
687     _;
688   }
689 
690 
691   //
692   // Abstract functions
693   //
694 
695   /**
696    * Check if the current invested breaks our cap rules.
697    *
698    *
699    * The child contract must define their own cap setting rules.
700    * We allow a lot of flexibility through different capping strategies (ETH, token count)
701    * Called from invest().
702    *
703    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
704    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
705    * @param weiRaisedTotal What would be our total raised balance after this transaction
706    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
707    *
708    * @return true if taking this investment would break our cap rules
709    */
710   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
711 
712   /**
713    * Check if the current crowdsale is full and we can no longer sell any tokens.
714    */
715   function isCrowdsaleFull() public constant returns (bool);
716 
717   /**
718    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
719    */
720   function assignTokens(address receiver, uint tokenAmount) private;
721 }
722 
723 
724 
725 
726 /// @dev Tranche based pricing with special support for pre-ico deals.
727 ///      Implementing "first price" tranches, meaning, that if byers order is
728 ///      covering more than one tranche, the price of the lowest tranche will apply
729 ///      to the whole order.
730 contract EthTranchePricing is PricingStrategy, Ownable {
731 
732   using SafeMathLib for uint;
733 
734   uint public constant MAX_TRANCHES = 10;
735 
736   // This contains all pre-ICO addresses, and their prices (weis per token)
737   mapping (address => uint) public preicoAddresses;
738 
739   /**
740   * Define pricing schedule using tranches.
741   */
742   struct Tranche {
743 
744       // Amount in weis when this tranche becomes active
745       uint amount;
746 
747       // How many tokens per satoshi you will get while this tranche is active
748       uint price;
749   }
750 
751   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
752   // Tranche 0 is always (0, 0)
753   // (TODO: change this when we confirm dynamic arrays are explorable)
754   Tranche[10] public tranches;
755 
756   // How many active tranches we have
757   uint public trancheCount;
758 
759   /// @dev Contruction, creating a list of tranches
760   /// @param _tranches uint[] tranches Pairs of (start amount, price)
761   function EthTranchePricing(uint[] _tranches) {
762     // Need to have tuples, length check
763     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
764       throw;
765     }
766 
767     trancheCount = _tranches.length / 2;
768 
769     uint highestAmount = 0;
770 
771     for(uint i=0; i<_tranches.length/2; i++) {
772       tranches[i].amount = _tranches[i*2];
773       tranches[i].price = _tranches[i*2+1];
774 
775       // No invalid steps
776       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
777         throw;
778       }
779 
780       highestAmount = tranches[i].amount;
781     }
782 
783     // We need to start from zero, otherwise we blow up our deployment
784     if(tranches[0].amount != 0) {
785       throw;
786     }
787 
788     // Last tranche price must be zero, terminating the crowdale
789     if(tranches[trancheCount-1].price != 0) {
790       throw;
791     }
792   }
793 
794   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
795   ///      to 0 to disable
796   /// @param preicoAddress PresaleFundCollector address
797   /// @param pricePerToken How many weis one token cost for pre-ico investors
798   function setPreicoAddress(address preicoAddress, uint pricePerToken)
799     public
800     onlyOwner
801   {
802     preicoAddresses[preicoAddress] = pricePerToken;
803   }
804 
805   /// @dev Iterate through tranches. You reach end of tranches when price = 0
806   /// @return tuple (time, price)
807   function getTranche(uint n) public constant returns (uint, uint) {
808     return (tranches[n].amount, tranches[n].price);
809   }
810 
811   function getFirstTranche() private constant returns (Tranche) {
812     return tranches[0];
813   }
814 
815   function getLastTranche() private constant returns (Tranche) {
816     return tranches[trancheCount-1];
817   }
818 
819   function getPricingStartsAt() public constant returns (uint) {
820     return getFirstTranche().amount;
821   }
822 
823   function getPricingEndsAt() public constant returns (uint) {
824     return getLastTranche().amount;
825   }
826 
827   function isSane(address _crowdsale) public constant returns(bool) {
828     // Our tranches are not bound by time, so we can't really check are we sane
829     // so we presume we are ;)
830     // In the future we could save and track raised tokens, and compare it to
831     // the Crowdsale contract.
832     return true;
833   }
834 
835   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
836   /// @param weiRaised total amount of weis raised, for calculating the current tranche
837   /// @return {[type]} [description]
838   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
839     uint i;
840 
841     for(i=0; i < tranches.length; i++) {
842       if(weiRaised < tranches[i].amount) {
843         return tranches[i-1];
844       }
845     }
846   }
847 
848   /// @dev Get the current price.
849   /// @param weiRaised total amount of weis raised, for calculating the current tranche
850   /// @return The current price or 0 if we are outside trache ranges
851   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
852     return getCurrentTranche(weiRaised).price;
853   }
854 
855   /// @dev Calculate the current price for buy in amount.
856   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
857 
858     uint multiplier = 10 ** decimals;
859 
860     // This investor is coming through pre-ico
861     if(preicoAddresses[msgSender] > 0) {
862       return value.times(multiplier) / preicoAddresses[msgSender];
863     }
864 
865     uint price = getCurrentPrice(weiRaised);
866     return value.times(multiplier) / price;
867   }
868 
869   function() payable {
870     throw; // No money on this contract
871   }
872 
873 }