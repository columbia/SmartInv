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
386     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
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
400    * Preallocate tokens for the early investors.
401    *
402    * Preallocated tokens have been sold before the actual crowdsale opens.
403    * This function mints the tokens and moves the crowdsale needle.
404    *
405    * Investor count is not handled; it is assumed this goes for multiple investors
406    * and the token distribution happens outside the smart contract flow.
407    *
408    * No money is exchanged, as the crowdsale team already have received the payment.
409    *
410    * @param fullTokens tokens as full tokens - decimal places added internally
411    * @param weiPrice Price of a single full token in wei
412    *
413    */
414   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
415 
416     uint tokenAmount = fullTokens * 10**token.decimals();
417     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
418 
419     weiRaised = weiRaised.plus(weiAmount);
420     tokensSold = tokensSold.plus(tokenAmount);
421 
422     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
423     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
424 
425     assignTokens(receiver, tokenAmount);
426 
427     // Tell us invest was success
428     Invested(receiver, weiAmount, tokenAmount, 0);
429   }
430 
431   /**
432    * Allow anonymous contributions to this crowdsale.
433    */
434   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
435      bytes32 hash = sha256(addr);
436      if (ecrecover(hash, v, r, s) != signerAddress) throw;
437      if(customerId == 0) throw;  // UUIDv4 sanity check
438      investInternal(addr, customerId);
439   }
440 
441   /**
442    * Track who is the customer making the payment so we can send thank you email.
443    */
444   function investWithCustomerId(address addr, uint128 customerId) public payable {
445     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
446     if(customerId == 0) throw;  // UUIDv4 sanity check
447     investInternal(addr, customerId);
448   }
449 
450   /**
451    * Allow anonymous contributions to this crowdsale.
452    */
453   function invest(address addr) public payable {
454     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
455     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
456     investInternal(addr, 0);
457   }
458 
459   /**
460    * Invest to tokens, recognize the payer and clear his address.
461    *
462    */
463   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
464     investWithSignedAddress(msg.sender, customerId, v, r, s);
465   }
466 
467   /**
468    * Invest to tokens, recognize the payer.
469    *
470    */
471   function buyWithCustomerId(uint128 customerId) public payable {
472     investWithCustomerId(msg.sender, customerId);
473   }
474 
475   /**
476    * The basic entry point to participate the crowdsale process.
477    *
478    * Pay for funding, get invested tokens back in the sender address.
479    */
480   function buy() public payable {
481     invest(msg.sender);
482   }
483 
484   /**
485    * Finalize a succcesful crowdsale.
486    *
487    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
488    */
489   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
490 
491     // Already finalized
492     if(finalized) {
493       throw;
494     }
495 
496     // Finalizing is optional. We only call it if we are given a finalizing agent.
497     if(address(finalizeAgent) != 0) {
498       finalizeAgent.finalizeCrowdsale();
499     }
500 
501     finalized = true;
502   }
503 
504   /**
505    * Allow to (re)set finalize agent.
506    *
507    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
508    */
509   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
510     finalizeAgent = addr;
511 
512     // Don't allow setting bad agent
513     if(!finalizeAgent.isFinalizeAgent()) {
514       throw;
515     }
516   }
517 
518   /**
519    * Set policy do we need to have server-side customer ids for the investments.
520    *
521    */
522   function setRequireCustomerId(bool value) onlyOwner {
523     requireCustomerId = value;
524     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
525   }
526 
527   /**
528    * Set policy if all investors must be cleared on the server side first.
529    *
530    * This is e.g. for the accredited investor clearing.
531    *
532    */
533   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
534     requiredSignedAddress = value;
535     signerAddress = _signerAddress;
536     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
537   }
538 
539   /**
540    * Allow addresses to do early participation.
541    *
542    * TODO: Fix spelling error in the name
543    */
544   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
545     earlyParticipantWhitelist[addr] = status;
546     Whitelisted(addr, status);
547   }
548 
549   /**
550    * Allow crowdsale owner to close early or extend the crowdsale.
551    *
552    * This is useful e.g. for a manual soft cap implementation:
553    * - after X amount is reached determine manual closing
554    *
555    * This may put the crowdsale to an invalid state,
556    * but we trust owners know what they are doing.
557    *
558    */
559   function setEndsAt(uint time) onlyOwner {
560 
561     if(now > time) {
562       throw; // Don't change past
563     }
564 
565     endsAt = time;
566     EndsAtChanged(endsAt);
567   }
568 
569   /**
570    * Allow to (re)set pricing strategy.
571    *
572    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
573    */
574   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
575     pricingStrategy = _pricingStrategy;
576 
577     // Don't allow setting bad agent
578     if(!pricingStrategy.isPricingStrategy()) {
579       throw;
580     }
581   }
582 
583   /**
584    * Allow load refunds back on the contract for the refunding.
585    *
586    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
587    */
588   function loadRefund() public payable inState(State.Failure) {
589     if(msg.value == 0) throw;
590     loadedRefund = loadedRefund.plus(msg.value);
591   }
592 
593   /**
594    * Investors can claim refund.
595    */
596   function refund() public inState(State.Refunding) {
597     uint256 weiValue = investedAmountOf[msg.sender];
598     if (weiValue == 0) throw;
599     investedAmountOf[msg.sender] = 0;
600     weiRefunded = weiRefunded.plus(weiValue);
601     Refund(msg.sender, weiValue);
602     if (!msg.sender.send(weiValue)) throw;
603   }
604 
605   /**
606    * @return true if the crowdsale has raised enough money to be a succes
607    */
608   function isMinimumGoalReached() public constant returns (bool reached) {
609     return weiRaised >= minimumFundingGoal;
610   }
611 
612   /**
613    * Check if the contract relationship looks good.
614    */
615   function isFinalizerSane() public constant returns (bool sane) {
616     return finalizeAgent.isSane();
617   }
618 
619   /**
620    * Check if the contract relationship looks good.
621    */
622   function isPricingSane() public constant returns (bool sane) {
623     return pricingStrategy.isSane(address(this));
624   }
625 
626   /**
627    * Crowdfund state machine management.
628    *
629    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
630    */
631   function getState() public constant returns (State) {
632     if(finalized) return State.Finalized;
633     else if (address(finalizeAgent) == 0) return State.Preparing;
634     else if (!finalizeAgent.isSane()) return State.Preparing;
635     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
636     else if (block.timestamp < startsAt) return State.PreFunding;
637     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
638     else if (isMinimumGoalReached()) return State.Success;
639     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
640     else return State.Failure;
641   }
642 
643   /** This is for manual testing of multisig wallet interaction */
644   function setOwnerTestValue(uint val) onlyOwner {
645     ownerTestValue = val;
646   }
647 
648   /** Interface marker. */
649   function isCrowdsale() public constant returns (bool) {
650     return true;
651   }
652 
653   //
654   // Modifiers
655   //
656 
657   /** Modified allowing execution only if the crowdsale is currently running.  */
658   modifier inState(State state) {
659     if(getState() != state) throw;
660     _;
661   }
662 
663 
664   //
665   // Abstract functions
666   //
667 
668   /**
669    * Check if the current invested breaks our cap rules.
670    *
671    *
672    * The child contract must define their own cap setting rules.
673    * We allow a lot of flexibility through different capping strategies (ETH, token count)
674    * Called from invest().
675    *
676    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
677    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
678    * @param weiRaisedTotal What would be our total raised balance after this transaction
679    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
680    *
681    * @return true if taking this investment would break our cap rules
682    */
683   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
684 
685   /**
686    * Check if the current crowdsale is full and we can no longer sell any tokens.
687    */
688   function isCrowdsaleFull() public constant returns (bool);
689 
690   /**
691    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
692    */
693   function assignTokens(address receiver, uint tokenAmount) private;
694 }
695 
696 
697 /**
698  * A crowdsale that is selling tokens from a preallocated pool
699  *
700  *
701  * - Tokens have precreated supply "premined"
702  *
703  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
704  *
705  */
706 contract AllocatedCrowdsale is Crowdsale {
707 
708   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
709   address public beneficiary;
710 
711   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
712     beneficiary = _beneficiary;
713   }
714 
715   /**
716    * Called from invest() to confirm if the curret investment does not break our cap rule.
717    */
718   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
719     if(tokenAmount > getTokensLeft()) {
720       return true;
721     } else {
722       return false;
723     }
724   }
725 
726   /**
727    * We are sold out when our approve pool becomes empty.
728    */
729   function isCrowdsaleFull() public constant returns (bool) {
730     return getTokensLeft() == 0;
731   }
732 
733   /**
734    * Get the amount of unsold tokens allocated to this contract;
735    */
736   function getTokensLeft() public constant returns (uint) {
737     return token.allowance(owner, this);
738   }
739 
740   /**
741    * Transfer tokens from approve() pool to the buyer.
742    *
743    * Use approve() given to this crowdsale to distribute the tokens.
744    */
745   function assignTokens(address receiver, uint tokenAmount) private {
746     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
747   }
748 }