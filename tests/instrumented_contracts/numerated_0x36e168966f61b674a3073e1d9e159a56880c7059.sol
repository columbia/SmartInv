1 /**
2  *  Streamr Network AG crowd contribution
3  *  By contributing ETH to this smart contract you agree to the following terms and conditions:
4  *  https://s3.amazonaws.com/streamr-public/Governance+Terms+-+Crowdcontribution.pdf
5  */
6 
7 
8 
9 /**
10  * Math operations with safety checks
11  */
12 contract SafeMath {
13   function safeMul(uint a, uint b) internal returns (uint) {
14     uint c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function safeDiv(uint a, uint b) internal returns (uint) {
20     assert(b > 0);
21     uint c = a / b;
22     assert(a == b * c + a % b);
23     return c;
24   }
25 
26   function safeSub(uint a, uint b) internal returns (uint) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function safeAdd(uint a, uint b) internal returns (uint) {
32     uint c = a + b;
33     assert(c>=a && c>=b);
34     return c;
35   }
36 
37   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a >= b ? a : b;
39   }
40 
41   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a < b ? a : b;
43   }
44 
45   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a >= b ? a : b;
47   }
48 
49   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a < b ? a : b;
51   }
52 
53   function assert(bool assertion) internal {
54     if (!assertion) {
55       throw;
56     }
57   }
58 }
59 
60 
61 
62 
63 /*
64  * Ownable
65  *
66  * Base contract with an owner.
67  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
68  */
69 contract Ownable {
70   address public owner;
71 
72   function Ownable() {
73     owner = msg.sender;
74   }
75 
76   modifier onlyOwner() {
77     if (msg.sender != owner) {
78       throw;
79     }
80     _;
81   }
82 
83   function transferOwnership(address newOwner) onlyOwner {
84     if (newOwner != address(0)) {
85       owner = newOwner;
86     }
87   }
88 
89 }
90 
91 
92 /*
93  * Haltable
94  *
95  * Abstract contract that allows children to implement an
96  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
97  *
98  *
99  * Originally envisioned in FirstBlood ICO contract.
100  */
101 contract Haltable is Ownable {
102   bool public halted;
103 
104   modifier stopInEmergency {
105     if (halted) throw;
106     _;
107   }
108 
109   modifier onlyInEmergency {
110     if (!halted) throw;
111     _;
112   }
113 
114   // called by the owner on emergency, triggers stopped state
115   function halt() external onlyOwner {
116     halted = true;
117   }
118 
119   // called by the owner on end of emergency, returns to normal state
120   function unhalt() external onlyOwner onlyInEmergency {
121     halted = false;
122   }
123 
124 }
125 
126 
127 /**
128  * Interface for defining crowdsale pricing.
129  */
130 contract PricingStrategy {
131 
132   /** Interface declaration. */
133   function isPricingStrategy() public constant returns (bool) {
134     return true;
135   }
136 
137   /** Self check if all references are correctly set.
138    *
139    * Checks that pricing strategy matches crowdsale parameters.
140    */
141   function isSane(address crowdsale) public constant returns (bool) {
142     return true;
143   }
144 
145   /**
146    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
147    *
148    *
149    * @param value - What is the value of the transaction send in as wei
150    * @param tokensSold - how much tokens have been sold this far
151    * @param weiRaised - how much money has been raised this far
152    * @param msgSender - who is the investor of this transaction
153    * @param decimals - how many decimal units the token has
154    * @return Amount of tokens the investor receives
155    */
156   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
157 }
158 
159 
160 /**
161  * Finalize agent defines what happens at the end of succeseful crowdsale.
162  *
163  * - Allocate tokens for founders, bounties and community
164  * - Make tokens transferable
165  * - etc.
166  */
167 contract FinalizeAgent {
168 
169   function isFinalizeAgent() public constant returns(bool) {
170     return true;
171   }
172 
173   /** Return true if we can run finalizeCrowdsale() properly.
174    *
175    * This is a safety check function that doesn't allow crowdsale to begin
176    * unless the finalizer has been set up properly.
177    */
178   function isSane() public constant returns (bool);
179 
180   /** Called once by crowdsale finalize() if the sale was success. */
181   function finalizeCrowdsale();
182 
183 }
184 
185 
186 
187 
188 /*
189  * ERC20 interface
190  * see https://github.com/ethereum/EIPs/issues/20
191  */
192 contract ERC20 {
193   uint public totalSupply;
194   function balanceOf(address who) constant returns (uint);
195   function allowance(address owner, address spender) constant returns (uint);
196 
197   function transfer(address to, uint value) returns (bool ok);
198   function transferFrom(address from, address to, uint value) returns (bool ok);
199   function approve(address spender, uint value) returns (bool ok);
200   event Transfer(address indexed from, address indexed to, uint value);
201   event Approval(address indexed owner, address indexed spender, uint value);
202 }
203 
204 
205 /**
206  * A token that defines fractional units as decimals.
207  */
208 contract FractionalERC20 is ERC20 {
209 
210   uint public decimals;
211 
212 }
213 
214 
215 /**
216  * Abstract base contract for token sales.
217  *
218  * Handle
219  * - start and end dates
220  * - accepting investments
221  * - minimum funding goal and refund
222  * - various statistics during the crowdfund
223  * - different pricing strategies
224  * - different investment policies (require server side customer id, allow only whitelisted addresses)
225  *
226  * Changes:
227  * - Whitelisting also for the State.Funding phase, with individual limits
228  */
229 contract Crowdsale is Haltable, SafeMath {
230 
231   /* Max investment count when we are still allowed to change the multisig address */
232   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
233 
234   /* The token we are selling */
235   FractionalERC20 public token;
236 
237   /* How we are going to price our offering */
238   PricingStrategy public pricingStrategy;
239 
240   /* Post-success callback */
241   FinalizeAgent public finalizeAgent;
242 
243   /* tokens will be transfered from this address */
244   address public multisigWallet;
245 
246   /* if the funding goal is not reached, investors may withdraw their funds */
247   uint public minimumFundingGoal;
248 
249   /* the UNIX timestamp start date of the crowdsale; CHANGE: small-cap limits apply */
250   uint public startsAt;
251 
252   /* CHANGE: Seconds after start of the crowdsale when the large-cap limit applies (added on top of small-cap limit) */
253   uint public largeCapDelay = 24 * 60 * 60;
254 
255   /* the UNIX timestamp end date of the crowdsale */
256   uint public endsAt;
257 
258   /* the number of tokens already sold through this contract*/
259   uint public tokensSold = 0;
260 
261   /* How many wei of funding we have raised */
262   uint public weiRaised = 0;
263 
264   /* How many distinct addresses have invested */
265   uint public investorCount = 0;
266 
267   /* How much wei we have returned back to the contract after a failed crowdfund. */
268   uint public loadedRefund = 0;
269 
270   /* How much wei we have given back to investors.*/
271   uint public weiRefunded = 0;
272 
273   /* Has this crowdsale been finalized */
274   bool public finalized;
275 
276   /* Do we need to have unique contributor id for each customer */
277   bool public requireCustomerId = false;
278 
279   /**
280     * Do we verify that contributor has been cleared on the server side (accredited investors only).
281     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
282     */
283   bool public requiredSignedAddress = false;
284 
285   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
286   address public signerAddress;
287 
288   /** How much ETH each address has invested to this crowdsale */
289   mapping (address => uint256) public investedAmountOf;
290 
291   /** How much tokens this crowdsale has credited for each investor address */
292   mapping (address => uint256) public tokenAmountOf;
293 
294   /** Addresses that are allowed to invest, and their individual limit (in wei) */
295   mapping (address => uint256) public smallCapLimitOf;
296 
297   /** Addresses that are allowed to invest after a largeCapDelay, and their individual large-cap limit (in wei, possibly in addition to smallCapLimitOf their account) */
298   mapping (address => uint256) public largeCapLimitOf;
299 
300   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
301   mapping (address => bool) public earlyParticipantWhitelist;
302 
303   /** Addresses that are allowed to add participants to the LimitOf whitelists */
304   mapping (address => bool) public isWhitelistAgent;
305 
306   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
307   uint public ownerTestValue;
308 
309   /** State machine
310    *
311    * - Preparing: All contract initialization calls and variables have not been set yet
312    * - Prefunding: We have not passed start time yet
313    * - Funding: Active crowdsale
314    * - Success: Minimum funding goal reached
315    * - Failure: Minimum funding goal not reached before ending time
316    * - Finalized: The finalized has been called and succesfully executed
317    * - Refunding: Refunds are loaded on the contract for reclaim.
318    */
319   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
320 
321   // A new investment was made
322   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
323 
324   // Refund was processed for a contributor
325   event Refund(address investor, uint weiAmount);
326 
327   // The rules were changed what kind of investments we accept
328   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
329 
330   // Whitelist status and/or wei limit changed
331   event WhitelistedEarlyParticipant(address addr, bool status);
332   event WhitelistedSmallCap(address addr, uint256 limit);
333   event WhitelistedLargeCap(address addr, uint256 limit);
334 
335   // Crowdsale start/end time has been changed
336   event EndsAtChanged(uint endsAt);
337   event StartsAtChanged(uint startsAt);
338   event LargeCapStartTimeChanged(uint startsAt);
339 
340   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
341 
342     owner = msg.sender;
343 
344     token = FractionalERC20(_token);
345 
346     setPricingStrategy(_pricingStrategy);
347 
348     multisigWallet = _multisigWallet;
349     if(multisigWallet == 0) {
350         throw;
351     }
352 
353     if(_start == 0) {
354         throw;
355     }
356 
357     startsAt = _start;
358 
359     if(_end == 0) {
360         throw;
361     }
362 
363     endsAt = _end;
364 
365     // Don't mess the dates
366     if(startsAt >= endsAt) {
367         throw;
368     }
369 
370     // owner and multisig are able to whitelist participants by default
371     isWhitelistAgent[owner] = true;
372     isWhitelistAgent[multisigWallet] = true;
373 
374     // Minimum funding goal can be zero
375     minimumFundingGoal = _minimumFundingGoal;
376   }
377 
378   /**
379    * Receiving money is ok, because that's what this contract is for. Sending money to Crowdsale is equivalent to buy().
380    */
381   function() payable {
382     invest(msg.sender);
383   }
384 
385   /**
386    * Make an investment.
387    *
388    * Crowdsale must be running for one to invest.
389    * We must have not pressed the emergency brake.
390    *
391    * @param receiver The Ethereum address who receives the tokens
392    * @param customerId (optional) UUID v4 to track the successful payments on the server side
393    *
394    */
395   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
396 
397     // Determine if it's a good time to accept investment from this participant
398     State state = getState();
399     if (state == State.Funding) {
400       // Retail participants can only come in when the crowdsale is running
401     } else if (state == State.PreFunding) {
402       // Are we whitelisted for early deposit
403       if (!earlyParticipantWhitelist[receiver]) {
404         throw;
405       }
406     } else {
407       // Unwanted state
408       throw;
409     }
410 
411     uint weiAmount = msg.value;
412     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
413 
414     if (tokenAmount == 0) {
415       // Dust transaction
416       throw;
417     }
418 
419     if (investedAmountOf[receiver] == 0) {
420        // A new investor
421        investorCount++;
422     }
423 
424     // Update investor
425     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
426     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
427 
428     // Check individual token limit (also acts as crowdsale whitelist)
429     uint256 personalWeiLimit = smallCapLimitOf[receiver];
430     if (block.timestamp > startsAt + largeCapDelay) {
431       personalWeiLimit = safeAdd(personalWeiLimit, largeCapLimitOf[receiver]);
432     }
433     if (investedAmountOf[receiver] > personalWeiLimit) {
434       throw;
435     }
436 
437     // Update totals
438     weiRaised = safeAdd(weiRaised, weiAmount);
439     tokensSold = safeAdd(tokensSold, tokenAmount);
440 
441     // Check that we did not bust the cap
442     if (isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
443       throw;
444     }
445 
446     assignTokens(receiver, tokenAmount);
447 
448     // Pocket the money
449     if (!multisigWallet.send(weiAmount)) throw;
450 
451     // Tell us invest was success
452     Invested(receiver, weiAmount, tokenAmount, customerId);
453   }
454 
455   /**
456    * Preallocate tokens for the early investors.
457    *
458    * Preallocated tokens have been sold before the actual crowdsale opens.
459    * This function mints the tokens and moves the crowdsale needle.
460    *
461    * Investor count is not handled; it is assumed this goes for multiple investors
462    * and the token distribution happens outside the smart contract flow.
463    *
464    * No money is exchanged, as the crowdsale team already have received the payment.
465    *
466    * @param tokenAmount Tokens (in "atomic units") allocated to the contributor
467    * @param weiAmount Contribution in wei
468    *
469    */
470   function preallocate(address receiver, uint tokenAmount, uint weiAmount) public onlyOwner {
471     if (getState() != State.PreFunding) { throw; }
472 
473     // Free pre-allocations don't count as "sold tokens"
474     if (weiAmount == 0) {
475       tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
476       assignTokens(receiver, tokenAmount);
477     } else {
478 
479       // new investor
480       if (investedAmountOf[receiver] == 0) {
481         investorCount++;
482       }
483 
484       weiRaised = safeAdd(weiRaised, weiAmount);
485       tokensSold = safeAdd(tokensSold, tokenAmount);
486       investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
487       tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
488 
489       assignTokens(receiver, tokenAmount);
490 
491       Invested(receiver, weiAmount, tokenAmount, 0);
492     }
493   }
494 
495   /**
496    * Allow anonymous contributions to this crowdsale.
497    */
498   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
499      bytes32 hash = sha256(addr);
500      if (ecrecover(hash, v, r, s) != signerAddress) throw;
501      if(customerId == 0) throw;  // UUIDv4 sanity check
502      investInternal(addr, customerId);
503   }
504 
505   /**
506    * Track who is the customer making the payment so we can send thank you email.
507    */
508   function investWithCustomerId(address addr, uint128 customerId) public payable {
509     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
510     if(customerId == 0) throw;  // UUIDv4 sanity check
511     investInternal(addr, customerId);
512   }
513 
514   /**
515    * Allow anonymous contributions to this crowdsale.
516    */
517   function invest(address addr) public payable {
518     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
519     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
520     investInternal(addr, 0);
521   }
522 
523   /**
524    * Invest to tokens, recognize the payer and clear his address.
525    *
526    */
527   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
528     investWithSignedAddress(msg.sender, customerId, v, r, s);
529   }
530 
531   /**
532    * Invest to tokens, recognize the payer.
533    *
534    */
535   function buyWithCustomerId(uint128 customerId) public payable {
536     investWithCustomerId(msg.sender, customerId);
537   }
538 
539   /**
540    * The basic entry point to participate the crowdsale process.
541    *
542    * Pay for funding, get invested tokens back in the sender address.
543    */
544   function buy() public payable {
545     invest(msg.sender);
546   }
547 
548   /**
549    * Finalize a succcesful crowdsale.
550    *
551    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
552    */
553   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
554 
555     // Already finalized
556     if(finalized) {
557       throw;
558     }
559 
560     // Finalizing is optional. We only call it if we are given a finalizing agent.
561     if(address(finalizeAgent) != 0) {
562       finalizeAgent.finalizeCrowdsale();
563     }
564 
565     finalized = true;
566   }
567 
568   /**
569    * Allow to (re)set finalize agent.
570    *
571    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
572    */
573   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
574     finalizeAgent = addr;
575 
576     // Don't allow setting bad agent
577     if(!finalizeAgent.isFinalizeAgent()) {
578       throw;
579     }
580   }
581 
582   /**
583    * Set policy do we need to have server-side customer ids for the investments.
584    *
585    */
586   function setRequireCustomerId(bool value) onlyOwner {
587     requireCustomerId = value;
588     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
589   }
590 
591   /**
592    * Set policy if all investors must be cleared on the server side first.
593    *
594    * This is e.g. for the accredited investor clearing.
595    *
596    */
597   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
598     requiredSignedAddress = value;
599     signerAddress = _signerAddress;
600     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
601   }
602 
603   /**
604    * Allow addresses to do early participation.
605    */
606   function setEarlyParticipantWhitelist(address addr, bool status) onlyOwner {
607     earlyParticipantWhitelist[addr] = status;
608     WhitelistedEarlyParticipant(addr, status);
609   }
610 
611   /**
612    * Change to original: require all participants to be whitelisted, with individual token limits
613    */
614   function setSmallCapWhitelistParticipant(address addr, uint256 weiLimit) {
615     if (isWhitelistAgent[msg.sender]) {
616       smallCapLimitOf[addr] = weiLimit;
617       WhitelistedSmallCap(addr, weiLimit);
618     }
619   }
620   function setSmallCapWhitelistParticipants(address[] addrs, uint256 weiLimit) {
621     if (isWhitelistAgent[msg.sender]) {
622       for (uint i = 0; i < addrs.length; i++) {
623         var addr = addrs[i];
624         smallCapLimitOf[addr] = weiLimit;
625         WhitelistedSmallCap(addr, weiLimit);
626       }
627     }
628   }
629   function setSmallCapWhitelistParticipants(address[] addrs, uint256[] weiLimits) {
630     if (addrs.length != weiLimits.length) {
631       throw;
632     }
633     if (isWhitelistAgent[msg.sender]) {
634       for (uint i = 0; i < addrs.length; i++) {
635         var addr = addrs[i];
636         var weiLimit = weiLimits[i];
637         smallCapLimitOf[addr] = weiLimit;
638         WhitelistedSmallCap(addr, weiLimit);
639       }
640     }
641   }
642 
643   function setLargeCapWhitelistParticipant(address addr, uint256 weiLimit) {
644     if (isWhitelistAgent[msg.sender]) {
645       largeCapLimitOf[addr] = weiLimit;
646       WhitelistedLargeCap(addr, weiLimit);
647     }
648   }
649   function setLargeCapWhitelistParticipants(address[] addrs, uint256 weiLimit) {
650     if (isWhitelistAgent[msg.sender]) {
651       for (uint i = 0; i < addrs.length; i++) {
652         var addr = addrs[i];
653         largeCapLimitOf[addr] = weiLimit;
654         WhitelistedLargeCap(addr, weiLimit);
655       }
656     }
657   }
658   function setLargeCapWhitelistParticipants(address[] addrs, uint256[] weiLimits) {
659     if (addrs.length != weiLimits.length) {
660       throw;
661     }
662     if (isWhitelistAgent[msg.sender]) {
663       for (uint i = 0; i < addrs.length; i++) {
664         var addr = addrs[i];
665         var weiLimit = weiLimits[i];
666         largeCapLimitOf[addr] = weiLimit;
667         WhitelistedLargeCap(addr, weiLimit);
668       }
669     }
670   }
671 
672   function setWhitelistAgent(address addr, bool status) onlyOwner {
673     isWhitelistAgent[addr] = status;
674   }
675 
676   /**
677    * Allow crowdsale owner to postpone the start of the crowdsale
678    */
679   function setStartsAt(uint time) onlyOwner {
680 
681     // Don't put into past
682     if (time < now) { throw; }
683 
684     // Change endsAt first...
685     if (time > endsAt) { throw; }
686 
687     // If crowdsale has already started, the start can't be postponed anymore
688     if (startsAt < now) { throw; }
689 
690     startsAt = time;
691     StartsAtChanged(endsAt);
692   }
693 
694   function setLargeCapDelay(uint secs) onlyOwner {
695     if (secs < 0) { throw; }
696 
697     // Change endsAt first...
698     if (startsAt + secs > endsAt) { throw; }
699 
700     // If large-cap sale has already started, the start can't be postponed anymore
701     if (startsAt + largeCapDelay < now) { throw; }
702 
703     largeCapDelay = secs;
704     LargeCapStartTimeChanged(startsAt + largeCapDelay);
705   }
706 
707   /**
708    * Allow crowdsale owner to close early or extend the crowdsale.
709    *
710    * This is useful e.g. for a manual soft cap implementation:
711    * - after X amount is reached determine manual closing
712    *
713    * This may put the crowdsale to an invalid state,
714    * but we trust owners know what they are doing.
715    *
716    */
717   function setEndsAt(uint time) onlyOwner {
718 
719     if (now > time) {
720       throw; // Don't change past
721     }
722 
723     endsAt = time;
724     EndsAtChanged(endsAt);
725   }
726 
727   /**
728    * Allow to (re)set pricing strategy.
729    *
730    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
731    */
732   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
733     pricingStrategy = _pricingStrategy;
734 
735     // Don't allow setting bad agent
736     if(!pricingStrategy.isPricingStrategy()) {
737       throw;
738     }
739   }
740 
741   /**
742    * Allow to change the team multisig address in the case of emergency.
743    *
744    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
745    * (we have done only few test transactions). After the crowdsale is going
746    * then multisig address stays locked for the safety reasons.
747    */
748   function setMultisig(address addr) public onlyOwner {
749 
750     // Change
751     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
752       throw;
753     }
754 
755     multisigWallet = addr;
756   }
757 
758   /**
759    * Allow load refunds back on the contract for the refunding.
760    *
761    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
762    */
763   function loadRefund() public payable inState(State.Failure) {
764     if(msg.value == 0) throw;
765     loadedRefund = safeAdd(loadedRefund, msg.value);
766   }
767 
768   /**
769    * Investors can claim refund.
770    *
771    * Note that any refunds from proxy buyers should be handled separately,
772    * and not through this contract.
773    */
774   function refund() public inState(State.Refunding) {
775     uint256 weiValue = investedAmountOf[msg.sender];
776     if (weiValue == 0) throw;
777     investedAmountOf[msg.sender] = 0;
778     weiRefunded = safeAdd(weiRefunded, weiValue);
779     Refund(msg.sender, weiValue);
780     if (!msg.sender.send(weiValue)) throw;
781   }
782 
783   /**
784    * @return true if the crowdsale has raised enough money to be a successful.
785    */
786   function isMinimumGoalReached() public constant returns (bool reached) {
787     return weiRaised >= minimumFundingGoal;
788   }
789 
790   /**
791    * Check if the contract relationship looks good.
792    */
793   function isFinalizerSane() public constant returns (bool sane) {
794     return finalizeAgent.isSane();
795   }
796 
797   /**
798    * Check if the contract relationship looks good.
799    */
800   function isPricingSane() public constant returns (bool sane) {
801     return pricingStrategy.isSane(address(this));
802   }
803 
804   /**
805    * Crowdfund state machine management.
806    *
807    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
808    */
809   function getState() public constant returns (State) {
810     if(finalized) return State.Finalized;
811     else if (address(finalizeAgent) == 0) return State.Preparing;
812     else if (!finalizeAgent.isSane()) return State.Preparing;
813     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
814     else if (block.timestamp < startsAt) return State.PreFunding;
815     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
816     else if (isMinimumGoalReached()) return State.Success;
817     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
818     else return State.Failure;
819   }
820 
821   /** This is for manual testing of multisig wallet interaction */
822   function setOwnerTestValue(uint val) onlyOwner {
823     ownerTestValue = val;
824   }
825 
826   /** Interface marker. */
827   function isCrowdsale() public constant returns (bool) {
828     return true;
829   }
830 
831   //
832   // Modifiers
833   //
834 
835   /** Modified allowing execution only if the crowdsale is currently running.  */
836   modifier inState(State state) {
837     if(getState() != state) throw;
838     _;
839   }
840 
841 
842   //
843   // Abstract functions
844   //
845 
846   /**
847    * Check if the current invested breaks our cap rules.
848    *
849    *
850    * The child contract must define their own cap setting rules.
851    * We allow a lot of flexibility through different capping strategies (ETH, token count)
852    * Called from invest().
853    *
854    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
855    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
856    * @param weiRaisedTotal What would be our total raised balance after this transaction
857    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
858    *
859    * @return true if taking this investment would break our cap rules
860    */
861   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
862 
863   /**
864    * Check if the current crowdsale is full and we can no longer sell any tokens.
865    */
866   function isCrowdsaleFull() public constant returns (bool);
867 
868   /**
869    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
870    */
871   function assignTokens(address receiver, uint tokenAmount) private;
872 }
873 
874 
875 
876 
877 
878 
879 
880 
881 
882 /**
883  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
884  *
885  * Based on code by FirstBlood:
886  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
887  */
888 contract StandardToken is ERC20, SafeMath {
889 
890   /* Token supply got increased and a new owner received these tokens */
891   event Minted(address receiver, uint amount);
892 
893   /* Actual balances of token holders */
894   mapping(address => uint) balances;
895 
896   /* approve() allowances */
897   mapping (address => mapping (address => uint)) allowed;
898 
899   /* Interface declaration */
900   function isToken() public constant returns (bool weAre) {
901     return true;
902   }
903 
904   function transfer(address _to, uint _value) returns (bool success) {
905     balances[msg.sender] = safeSub(balances[msg.sender], _value);
906     balances[_to] = safeAdd(balances[_to], _value);
907     Transfer(msg.sender, _to, _value);
908     return true;
909   }
910 
911   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
912     uint _allowance = allowed[_from][msg.sender];
913 
914     balances[_to] = safeAdd(balances[_to], _value);
915     balances[_from] = safeSub(balances[_from], _value);
916     allowed[_from][msg.sender] = safeSub(_allowance, _value);
917     Transfer(_from, _to, _value);
918     return true;
919   }
920 
921   function balanceOf(address _owner) constant returns (uint balance) {
922     return balances[_owner];
923   }
924 
925   function approve(address _spender, uint _value) returns (bool success) {
926 
927     // To change the approve amount you first have to reduce the addresses`
928     //  allowance to zero by calling `approve(_spender, 0)` if it is not
929     //  already 0 to mitigate the race condition described here:
930     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
931     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
932 
933     allowed[msg.sender][_spender] = _value;
934     Approval(msg.sender, _spender, _value);
935     return true;
936   }
937 
938   function allowance(address _owner, address _spender) constant returns (uint remaining) {
939     return allowed[_owner][_spender];
940   }
941 
942 }
943 
944 
945 
946 /**
947  * A token that can increase its supply by another contract.
948  *
949  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
950  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
951  *
952  */
953 contract MintableToken is StandardToken, Ownable {
954 
955   bool public mintingFinished = false;
956 
957   /** List of agents that are allowed to create new tokens */
958   mapping (address => bool) public mintAgents;
959 
960   event MintingAgentChanged(address addr, bool state);
961 
962   /**
963    * Create new tokens and allocate them to an address..
964    *
965    * Only callably by a crowdsale contract (mint agent).
966    */
967   function mint(address receiver, uint amount) onlyMintAgent canMint public {
968     totalSupply = safeAdd(totalSupply, amount);
969     balances[receiver] = safeAdd(balances[receiver], amount);
970 
971     // This will make the mint transaction apper in EtherScan.io
972     // We can remove this after there is a standardized minting event
973     Transfer(0, receiver, amount);
974   }
975 
976   /**
977    * Owner can allow a crowdsale contract to mint new tokens.
978    */
979   function setMintAgent(address addr, bool state) onlyOwner canMint public {
980     mintAgents[addr] = state;
981     MintingAgentChanged(addr, state);
982   }
983 
984   modifier onlyMintAgent() {
985     // Only crowdsale contracts are allowed to mint new tokens
986     if(!mintAgents[msg.sender]) {
987         throw;
988     }
989     _;
990   }
991 
992   /** Make sure we are not done yet. */
993   modifier canMint() {
994     if(mintingFinished) throw;
995     _;
996   }
997 }
998 
999 
1000 /**
1001  * ICO crowdsale contract that is capped by amout of tokens.
1002  *
1003  * - Tokens are dynamically created during the crowdsale
1004  *
1005  *
1006  */
1007 contract MintedTokenCappedCrowdsale is Crowdsale {
1008 
1009   /* Maximum amount of tokens this crowdsale can sell. */
1010   uint public maximumSellableTokens;
1011 
1012   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
1013     maximumSellableTokens = _maximumSellableTokens;
1014   }
1015 
1016   /**
1017    * Called from invest() to confirm if the curret investment does not break our cap rule.
1018    */
1019   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1020     return tokensSoldTotal > maximumSellableTokens;
1021   }
1022 
1023   function isCrowdsaleFull() public constant returns (bool) {
1024     return tokensSold >= maximumSellableTokens;
1025   }
1026 
1027   /**
1028    * Dynamically create tokens and assign them to the investor.
1029    */
1030   function assignTokens(address receiver, uint tokenAmount) private {
1031     MintableToken mintableToken = MintableToken(token);
1032     mintableToken.mint(receiver, tokenAmount);
1033   }
1034 }