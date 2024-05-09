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
299     owner = msg.sender;
300 
301     token = FractionalERC20(_token);
302 
303     setPricingStrategy(_pricingStrategy);
304 
305     multisigWallet = _multisigWallet;
306     if(multisigWallet == 0) {
307         throw;
308     }
309 
310     if(_start == 0) {
311         throw;
312     }
313 
314     startsAt = _start;
315 
316     if(_end == 0) {
317         throw;
318     }
319 
320     endsAt = _end;
321 
322     // Don't mess the dates
323     if(startsAt >= endsAt) {
324         throw;
325     }
326 
327     // Minimum funding goal can be zero
328     minimumFundingGoal = _minimumFundingGoal;
329   }
330 
331   /**
332    * Don't expect to just send in money and get tokens.
333    */
334   function() payable {
335     throw;
336   }
337 
338   /**
339    * Make an investment.
340    *
341    * Crowdsale must be running for one to invest.
342    * We must have not pressed the emergency brake.
343    *
344    * @param receiver The Ethereum address who receives the tokens
345    * @param customerId (optional) UUID v4 to track the successful payments on the server side
346    *
347    */
348   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
349 
350     // Determine if it's a good time to accept investment from this participant
351     if(getState() == State.PreFunding) {
352       // Are we whitelisted for early deposit
353       if(!earlyParticipantWhitelist[receiver]) {
354         throw;
355       }
356     } else if(getState() == State.Funding) {
357       // Retail participants can only come in when the crowdsale is running
358       // pass
359     } else {
360       // Unwanted state
361       throw;
362     }
363 
364     uint weiAmount = msg.value;
365     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
366 
367     if(tokenAmount == 0) {
368       // Dust transaction
369       throw;
370     }
371 
372     if(investedAmountOf[receiver] == 0) {
373        // A new investor
374        investorCount++;
375     }
376 
377     // Update investor
378     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
379     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
380 
381     // Update totals
382     weiRaised = weiRaised.plus(weiAmount);
383     tokensSold = tokensSold.plus(tokenAmount);
384 
385     // Check that we did not bust the cap
386     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
387       throw;
388     }
389 
390     assignTokens(receiver, tokenAmount);
391 
392     // Pocket the money
393     if(!multisigWallet.send(weiAmount)) throw;
394 
395     // Tell us invest was success
396     Invested(receiver, weiAmount, tokenAmount, customerId);
397   }
398 
399   /**
400    * Allow anonymous contributions to this crowdsale.
401    */
402   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
403      bytes32 hash = sha256(addr);
404      if (ecrecover(hash, v, r, s) != signerAddress) throw;
405      if(customerId == 0) throw;  // UUIDv4 sanity check
406      investInternal(addr, customerId);
407   }
408 
409   /**
410    * Track who is the customer making the payment so we can send thank you email.
411    */
412   function investWithCustomerId(address addr, uint128 customerId) public payable {
413     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
414     if(customerId == 0) throw;  // UUIDv4 sanity check
415     investInternal(addr, customerId);
416   }
417 
418   /**
419    * Allow anonymous contributions to this crowdsale.
420    */
421   function invest(address addr) public payable {
422     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
423     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
424     investInternal(addr, 0);
425   }
426 
427   /**
428    * Invest to tokens, recognize the payer and clear his address.
429    *
430    */
431   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
432     investWithSignedAddress(msg.sender, customerId, v, r, s);
433   }
434 
435   /**
436    * Invest to tokens, recognize the payer.
437    *
438    */
439   function buyWithCustomerId(uint128 customerId) public payable {
440     investWithCustomerId(msg.sender, customerId);
441   }
442 
443   /**
444    * The basic entry point to participate the crowdsale process.
445    *
446    * Pay for funding, get invested tokens back in the sender address.
447    */
448   function buy() public payable {
449     invest(msg.sender);
450   }
451 
452   /**
453    * Finalize a succcesful crowdsale.
454    *
455    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
456    */
457   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
458 
459     // Already finalized
460     if(finalized) {
461       throw;
462     }
463 
464     // Finalizing is optional. We only call it if we are given a finalizing agent.
465     if(address(finalizeAgent) != 0) {
466       finalizeAgent.finalizeCrowdsale();
467     }
468 
469     finalized = true;
470   }
471 
472   /**
473    * Allow to (re)set finalize agent.
474    *
475    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
476    */
477   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
478     finalizeAgent = addr;
479 
480     // Don't allow setting bad agent
481     if(!finalizeAgent.isFinalizeAgent()) {
482       throw;
483     }
484   }
485 
486   /**
487    * Set policy do we need to have server-side customer ids for the investments.
488    *
489    */
490   function setRequireCustomerId(bool value) onlyOwner {
491     requireCustomerId = value;
492     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
493   }
494 
495   /**
496    * Set policy if all investors must be cleared on the server side first.
497    *
498    * This is e.g. for the accredited investor clearing.
499    *
500    */
501   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
502     requiredSignedAddress = value;
503     signerAddress = _signerAddress;
504     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
505   }
506 
507   /**
508    * Allow addresses to do early participation.
509    *
510    * TODO: Fix spelling error in the name
511    */
512   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
513     earlyParticipantWhitelist[addr] = status;
514     Whitelisted(addr, status);
515   }
516 
517   /**
518    * Allow crowdsale owner to close early or extend the crowdsale.
519    *
520    * This is useful e.g. for a manual soft cap implementation:
521    * - after X amount is reached determine manual closing
522    *
523    * This may put the crowdsale to an invalid state,
524    * but we trust owners know what they are doing.
525    *
526    */
527   function setEndsAt(uint time) onlyOwner {
528 
529     if(now > time) {
530       throw; // Don't change past
531     }
532 
533     endsAt = time;
534     EndsAtChanged(endsAt);
535   }
536 
537   /**
538    * Allow to (re)set pricing strategy.
539    *
540    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
541    */
542   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
543     pricingStrategy = _pricingStrategy;
544 
545     // Don't allow setting bad agent
546     if(!pricingStrategy.isPricingStrategy()) {
547       throw;
548     }
549   }
550 
551   /**
552    * Allow load refunds back on the contract for the refunding.
553    *
554    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
555    */
556   function loadRefund() public payable inState(State.Failure) {
557     if(msg.value == 0) throw;
558     loadedRefund = loadedRefund.plus(msg.value);
559   }
560 
561   /**
562    * Investors can claim refund.
563    */
564   function refund() public inState(State.Refunding) {
565     uint256 weiValue = investedAmountOf[msg.sender];
566     if (weiValue == 0) throw;
567     investedAmountOf[msg.sender] = 0;
568     weiRefunded = weiRefunded.plus(weiValue);
569     Refund(msg.sender, weiValue);
570     if (!msg.sender.send(weiValue)) throw;
571   }
572 
573   /**
574    * @return true if the crowdsale has raised enough money to be a succes
575    */
576   function isMinimumGoalReached() public constant returns (bool reached) {
577     return weiRaised >= minimumFundingGoal;
578   }
579 
580   /**
581    * Crowdfund state machine management.
582    *
583    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
584    */
585   function getState() public constant returns (State) {
586     if(finalized) return State.Finalized;
587     else if (address(finalizeAgent) == 0) return State.Preparing;
588     else if (!finalizeAgent.isSane()) return State.Preparing;
589     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
590     else if (block.timestamp < startsAt) return State.PreFunding;
591     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
592     else if (isMinimumGoalReached()) return State.Success;
593     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
594     else return State.Failure;
595   }
596 
597   /** This is for manual testing of multisig wallet interaction */
598   function setOwnerTestValue(uint val) onlyOwner {
599     ownerTestValue = val;
600   }
601 
602   //
603   // Modifiers
604   //
605 
606   /** Modified allowing execution only if the crowdsale is currently running.  */
607   modifier inState(State state) {
608     if(getState() != state) throw;
609     _;
610   }
611 
612 
613   //
614   // Abstract functions
615   //
616 
617   /**
618    * Check if the current invested breaks our cap rules.
619    *
620    *
621    * The child contract must define their own cap setting rules.
622    * We allow a lot of flexibility through different capping strategies (ETH, token count)
623    * Called from invest().
624    *
625    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
626    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
627    * @param weiRaisedTotal What would be our total raised balance after this transaction
628    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
629    *
630    * @return true if taking this investment would break our cap rules
631    */
632   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
633 
634   /**
635    * Check if the current crowdsale is full and we can no longer sell any tokens.
636    */
637   function isCrowdsaleFull() public constant returns (bool);
638 
639   /**
640    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
641    */
642   function assignTokens(address receiver, uint tokenAmount) private;
643 }
644 
645 
646 
647 /**
648  * Collect funds from presale investors to be send to the crowdsale smart contract later.
649  *
650  * - Collect funds from pre-sale investors
651  * - Send funds to the crowdsale when it opens
652  * - Allow owner to set the crowdsale
653  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
654  *
655  */
656 contract PresaleFundCollector is Ownable {
657 
658   using SafeMathLib for uint;
659 
660   /** How many investors when can carry per a single contract */
661   uint public MAX_INVESTORS = 32;
662 
663   /** How many investors we have now */
664   uint public investorCount;
665 
666   /** Who are our investors (iterable) */
667   address[] public investors;
668 
669   /** How much they have invested */
670   mapping(address => uint) public balances;
671 
672   /** When our refund freeze is over (UNIT timestamp) */
673   uint public freezeEndsAt;
674 
675   /** What is the minimum buy in */
676   uint public weiMinimumLimit;
677 
678   /** Have we begun to move funds */
679   bool public moving;
680 
681   /** Our ICO contract where we will move the funds */
682   Crowdsale public crowdsale;
683 
684   event Invested(address investor, uint value);
685   event Refunded(address investor, uint value);
686 
687   /**
688    * Create presale contract where lock up period is given days
689    */
690   function PresaleFundCollector(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit) {
691 
692     owner = _owner;
693 
694     // Give argument
695     if(_freezeEndsAt == 0) {
696       throw;
697     }
698 
699     // Give argument
700     if(_weiMinimumLimit == 0) {
701       throw;
702     }
703 
704     weiMinimumLimit = _weiMinimumLimit;
705     freezeEndsAt = _freezeEndsAt;
706   }
707 
708   /**
709    * Participate to a presale.
710    */
711   function invest() public payable {
712 
713     // Cannot invest anymore through crowdsale when moving has begun
714     if(moving) throw;
715 
716     address investor = msg.sender;
717 
718     bool existing = balances[investor] > 0;
719 
720     balances[investor] = balances[investor].plus(msg.value);
721 
722     // Need to fulfill minimum limit
723     if(balances[investor] < weiMinimumLimit) {
724       throw;
725     }
726 
727     // This is a new investor
728     if(!existing) {
729 
730       // Limit number of investors to prevent too long loops
731       if(investorCount >= MAX_INVESTORS) throw;
732 
733       investors.push(investor);
734       investorCount++;
735     }
736 
737     Invested(investor, msg.value);
738   }
739 
740   /**
741    * Load funds to the crowdsale for a single investor.
742    */
743   function parcipateCrowdsaleInvestor(address investor) public {
744 
745     // Crowdsale not yet set
746     if(address(crowdsale) == 0) throw;
747 
748     moving = true;
749 
750     if(balances[investor] > 0) {
751       uint amount = balances[investor];
752       delete balances[investor];
753       crowdsale.invest.value(amount)(investor);
754     }
755   }
756 
757   /**
758    * Load funds to the crowdsale for all investor.
759    *
760    */
761   function parcipateCrowdsaleAll() public {
762 
763     // We might hit a max gas limit in this loop,
764     // and in this case you can simply call parcipateCrowdsaleInvestor() for all investors
765     for(uint i=0; i<investors.length; i++) {
766        parcipateCrowdsaleInvestor(investors[i]);
767     }
768   }
769 
770   /**
771    * ICO never happened. Allow refund.
772    */
773   function refund() {
774 
775     // Trying to ask refund too soon
776     if(now < freezeEndsAt) throw;
777 
778     // We have started to move funds
779     moving = true;
780 
781     address investor = msg.sender;
782     if(balances[investor] == 0) throw;
783     uint amount = balances[investor];
784     delete balances[investor];
785     if(!investor.send(amount)) throw;
786     Refunded(investor, amount);
787   }
788 
789   /**
790    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
791    */
792   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
793      crowdsale = _crowdsale;
794   }
795 
796   /** Explicitly call function from your wallet. */
797   function() payable {
798     throw;
799   }
800 }