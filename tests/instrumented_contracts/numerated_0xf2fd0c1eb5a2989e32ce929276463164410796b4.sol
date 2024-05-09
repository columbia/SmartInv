1 /**
2  * Math operations with safety checks
3  */
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 
53 
54 /**
55  * Safe unsigned safe math.
56  *
57  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
58  *
59  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
60  *
61  * Maintained here until merged to mainline zeppelin-solidity.
62  *
63  */
64 library SafeMathLib {
65 
66   function times(uint a, uint b) returns (uint) {
67     uint c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function minus(uint a, uint b) returns (uint) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function plus(uint a, uint b) returns (uint) {
78     uint c = a + b;
79     assert(c>=a);
80     return c;
81   }
82 
83   function assert(bool assertion) private {
84     if (!assertion) throw;
85   }
86 }
87 
88 
89 
90 
91 /*
92  * Ownable
93  *
94  * Base contract with an owner.
95  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
96  */
97 contract Ownable {
98   address public owner;
99 
100   function Ownable() {
101     owner = msg.sender;
102   }
103 
104   modifier onlyOwner() {
105     if (msg.sender != owner) {
106       throw;
107     }
108     _;
109   }
110 
111   function transferOwnership(address newOwner) onlyOwner {
112     if (newOwner != address(0)) {
113       owner = newOwner;
114     }
115   }
116 
117 }
118 
119 
120 /*
121  * Haltable
122  *
123  * Abstract contract that allows children to implement an
124  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
125  *
126  *
127  * Originally envisioned in FirstBlood ICO contract.
128  */
129 contract Haltable is Ownable {
130   bool public halted;
131 
132   modifier stopInEmergency {
133     if (halted) throw;
134     _;
135   }
136 
137   modifier onlyInEmergency {
138     if (!halted) throw;
139     _;
140   }
141 
142   // called by the owner on emergency, triggers stopped state
143   function halt() external onlyOwner {
144     halted = true;
145   }
146 
147   // called by the owner on end of emergency, returns to normal state
148   function unhalt() external onlyOwner onlyInEmergency {
149     halted = false;
150   }
151 
152 }
153 
154 
155 /**
156  * Interface for defining crowdsale pricing.
157  */
158 contract PricingStrategy {
159 
160   /** Interface declaration. */
161   function isPricingStrategy() public constant returns (bool) {
162     return true;
163   }
164 
165   /** Self check if all references are correctly set.
166    *
167    * Checks that pricing strategy matches crowdsale parameters.
168    */
169   function isSane(address crowdsale) public constant returns (bool) {
170     return true;
171   }
172 
173   /**
174    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
175    *
176    *
177    * @param value - What is the value of the transaction send in as wei
178    * @param tokensSold - how much tokens have been sold this far
179    * @param weiRaised - how much money has been raised this far
180    * @param msgSender - who is the investor of this transaction
181    * @param decimals - how many decimal units the token has
182    * @return Amount of tokens the investor receives
183    */
184   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
185 }
186 
187 
188 /**
189  * Finalize agent defines what happens at the end of succeseful crowdsale.
190  *
191  * - Allocate tokens for founders, bounties and community
192  * - Make tokens transferable
193  * - etc.
194  */
195 contract FinalizeAgent {
196 
197   function isFinalizeAgent() public constant returns(bool) {
198     return true;
199   }
200 
201   /** Return true if we can run finalizeCrowdsale() properly.
202    *
203    * This is a safety check function that doesn't allow crowdsale to begin
204    * unless the finalizer has been set up properly.
205    */
206   function isSane() public constant returns (bool);
207 
208   /** Called once by crowdsale finalize() if the sale was success. */
209   function finalizeCrowdsale();
210 
211 }
212 
213 
214 
215 
216 /*
217  * ERC20 interface
218  * see https://github.com/ethereum/EIPs/issues/20
219  */
220 contract ERC20 {
221   uint public totalSupply;
222   function balanceOf(address who) constant returns (uint);
223   function allowance(address owner, address spender) constant returns (uint);
224 
225   function transfer(address to, uint value) returns (bool ok);
226   function transferFrom(address from, address to, uint value) returns (bool ok);
227   function approve(address spender, uint value) returns (bool ok);
228   event Transfer(address indexed from, address indexed to, uint value);
229   event Approval(address indexed owner, address indexed spender, uint value);
230 }
231 
232 
233 /**
234  * A token that defines fractional units as decimals.
235  */
236 contract FractionalERC20 is ERC20 {
237 
238   uint public decimals;
239 
240 }
241 
242 
243 
244 /**
245  * Abstract base contract for token sales.
246  *
247  * Handle
248  * - start and end dates
249  * - accepting investments
250  * - minimum funding goal and refund
251  * - various statistics during the crowdfund
252  * - different pricing strategies
253  * - different investment policies (require server side customer id, allow only whitelisted addresses)
254  *
255  */
256 contract Crowdsale is Haltable {
257 
258   using SafeMathLib for uint;
259 
260   /* The token we are selling */
261   FractionalERC20 public token;
262 
263   /* How we are going to price our offering */
264   PricingStrategy public pricingStrategy;
265 
266   /* Post-success callback */
267   FinalizeAgent public finalizeAgent;
268 
269   /* tokens will be transfered from this address */
270   address public multisigWallet;
271 
272   /* if the funding goal is not reached, investors may withdraw their funds */
273   uint public minimumFundingGoal;
274 
275   /* the UNIX timestamp start date of the crowdsale */
276   uint public startsAt;
277 
278   /* the UNIX timestamp end date of the crowdsale */
279   uint public endsAt;
280 
281   /* the number of tokens already sold through this contract*/
282   uint public tokensSold = 0;
283 
284   /* How many wei of funding we have raised */
285   uint public weiRaised = 0;
286 
287   /* How many distinct addresses have invested */
288   uint public investorCount = 0;
289 
290   /* How much wei we have returned back to the contract after a failed crowdfund. */
291   uint public loadedRefund = 0;
292 
293   /* How much wei we have given back to investors.*/
294   uint public weiRefunded = 0;
295 
296   /* Has this crowdsale been finalized */
297   bool public finalized;
298 
299   /* Do we need to have unique contributor id for each customer */
300   bool public requireCustomerId;
301 
302   /**
303     * Do we verify that contributor has been cleared on the server side (accredited investors only).
304     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
305     */
306   bool public requiredSignedAddress;
307 
308   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
309   address public signerAddress;
310 
311   /** How much ETH each address has invested to this crowdsale */
312   mapping (address => uint256) public investedAmountOf;
313 
314   /** How much tokens this crowdsale has credited for each investor address */
315   mapping (address => uint256) public tokenAmountOf;
316 
317   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
318   mapping (address => bool) public earlyParticipantWhitelist;
319 
320   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
321   uint public ownerTestValue;
322 
323   /** State machine
324    *
325    * - Preparing: All contract initialization calls and variables have not been set yet
326    * - Prefunding: We have not passed start time yet
327    * - Funding: Active crowdsale
328    * - Success: Minimum funding goal reached
329    * - Failure: Minimum funding goal not reached before ending time
330    * - Finalized: The finalized has been called and succesfully executed
331    * - Refunding: Refunds are loaded on the contract for reclaim.
332    */
333   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
334 
335   // A new investment was made
336   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
337 
338   // Refund was processed for a contributor
339   event Refund(address investor, uint weiAmount);
340 
341   // The rules were changed what kind of investments we accept
342   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
343 
344   // Address early participation whitelist status changed
345   event Whitelisted(address addr, bool status);
346 
347   // Crowdsale end time has been changed
348   event EndsAtChanged(uint endsAt);
349 
350   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
351 
352     owner = msg.sender;
353 
354     token = FractionalERC20(_token);
355 
356     setPricingStrategy(_pricingStrategy);
357 
358     multisigWallet = _multisigWallet;
359     if(multisigWallet == 0) {
360         throw;
361     }
362 
363     if(_start == 0) {
364         throw;
365     }
366 
367     startsAt = _start;
368 
369     if(_end == 0) {
370         throw;
371     }
372 
373     endsAt = _end;
374 
375     // Don't mess the dates
376     if(startsAt >= endsAt) {
377         throw;
378     }
379 
380     // Minimum funding goal can be zero
381     minimumFundingGoal = _minimumFundingGoal;
382   }
383 
384   /**
385    * Don't expect to just send in money and get tokens.
386    */
387   function() payable {
388     throw;
389   }
390 
391   /**
392    * Make an investment.
393    *
394    * Crowdsale must be running for one to invest.
395    * We must have not pressed the emergency brake.
396    *
397    * @param receiver The Ethereum address who receives the tokens
398    * @param customerId (optional) UUID v4 to track the successful payments on the server side
399    *
400    */
401   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
402 
403     // Determine if it's a good time to accept investment from this participant
404     if(getState() == State.PreFunding) {
405       // Are we whitelisted for early deposit
406       if(!earlyParticipantWhitelist[receiver]) {
407         throw;
408       }
409     } else if(getState() == State.Funding) {
410       // Retail participants can only come in when the crowdsale is running
411       // pass
412     } else {
413       // Unwanted state
414       throw;
415     }
416 
417     uint weiAmount = msg.value;
418     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
419 
420     if(tokenAmount == 0) {
421       // Dust transaction
422       throw;
423     }
424 
425     if(investedAmountOf[receiver] == 0) {
426        // A new investor
427        investorCount++;
428     }
429 
430     // Update investor
431     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
432     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
433 
434     // Update totals
435     weiRaised = weiRaised.plus(weiAmount);
436     tokensSold = tokensSold.plus(tokenAmount);
437 
438     // Check that we did not bust the cap
439     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
440       throw;
441     }
442 
443     assignTokens(receiver, tokenAmount);
444 
445     // Pocket the money
446     if(!multisigWallet.send(weiAmount)) throw;
447 
448     // Tell us invest was success
449     Invested(receiver, weiAmount, tokenAmount, customerId);
450   }
451 
452   /**
453    * Preallocate tokens for the early investors.
454    *
455    * Preallocated tokens have been sold before the actual crowdsale opens.
456    * This function mints the tokens and moves the crowdsale needle.
457    *
458    * Investor count is not handled; it is assumed this goes for multiple investors
459    * and the token distribution happens outside the smart contract flow.
460    *
461    * No money is exchanged, as the crowdsale team already have received the payment.
462    *
463    * @param fullTokens tokens as full tokens - decimal places added internally
464    * @param weiPrice Price of a single full token in wei
465    *
466    */
467   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
468 
469     uint tokenAmount = fullTokens * 10**token.decimals();
470     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
471 
472     weiRaised = weiRaised.plus(weiAmount);
473     tokensSold = tokensSold.plus(tokenAmount);
474 
475     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
476     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
477 
478     assignTokens(receiver, tokenAmount);
479 
480     // Tell us invest was success
481     Invested(receiver, weiAmount, tokenAmount, 0);
482   }
483 
484   /**
485    * Allow anonymous contributions to this crowdsale.
486    */
487   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
488      bytes32 hash = sha256(addr);
489      if (ecrecover(hash, v, r, s) != signerAddress) throw;
490      if(customerId == 0) throw;  // UUIDv4 sanity check
491      investInternal(addr, customerId);
492   }
493 
494   /**
495    * Track who is the customer making the payment so we can send thank you email.
496    */
497   function investWithCustomerId(address addr, uint128 customerId) public payable {
498     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
499     if(customerId == 0) throw;  // UUIDv4 sanity check
500     investInternal(addr, customerId);
501   }
502 
503   /**
504    * Allow anonymous contributions to this crowdsale.
505    */
506   function invest(address addr) public payable {
507     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
508     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
509     investInternal(addr, 0);
510   }
511 
512   /**
513    * Invest to tokens, recognize the payer and clear his address.
514    *
515    */
516   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
517     investWithSignedAddress(msg.sender, customerId, v, r, s);
518   }
519 
520   /**
521    * Invest to tokens, recognize the payer.
522    *
523    */
524   function buyWithCustomerId(uint128 customerId) public payable {
525     investWithCustomerId(msg.sender, customerId);
526   }
527 
528   /**
529    * The basic entry point to participate the crowdsale process.
530    *
531    * Pay for funding, get invested tokens back in the sender address.
532    */
533   function buy() public payable {
534     invest(msg.sender);
535   }
536 
537   /**
538    * Finalize a succcesful crowdsale.
539    *
540    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
541    */
542   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
543 
544     // Already finalized
545     if(finalized) {
546       throw;
547     }
548 
549     // Finalizing is optional. We only call it if we are given a finalizing agent.
550     if(address(finalizeAgent) != 0) {
551       finalizeAgent.finalizeCrowdsale();
552     }
553 
554     finalized = true;
555   }
556 
557   /**
558    * Allow to (re)set finalize agent.
559    *
560    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
561    */
562   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
563     finalizeAgent = addr;
564 
565     // Don't allow setting bad agent
566     if(!finalizeAgent.isFinalizeAgent()) {
567       throw;
568     }
569   }
570 
571   /**
572    * Set policy do we need to have server-side customer ids for the investments.
573    *
574    */
575   function setRequireCustomerId(bool value) onlyOwner {
576     requireCustomerId = value;
577     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
578   }
579 
580   /**
581    * Set policy if all investors must be cleared on the server side first.
582    *
583    * This is e.g. for the accredited investor clearing.
584    *
585    */
586   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
587     requiredSignedAddress = value;
588     signerAddress = _signerAddress;
589     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
590   }
591 
592   /**
593    * Allow addresses to do early participation.
594    *
595    * TODO: Fix spelling error in the name
596    */
597   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
598     earlyParticipantWhitelist[addr] = status;
599     Whitelisted(addr, status);
600   }
601 
602   /**
603    * Allow crowdsale owner to close early or extend the crowdsale.
604    *
605    * This is useful e.g. for a manual soft cap implementation:
606    * - after X amount is reached determine manual closing
607    *
608    * This may put the crowdsale to an invalid state,
609    * but we trust owners know what they are doing.
610    *
611    */
612   function setEndsAt(uint time) onlyOwner {
613 
614     if(now > time) {
615       throw; // Don't change past
616     }
617 
618     endsAt = time;
619     EndsAtChanged(endsAt);
620   }
621 
622   /**
623    * Allow to (re)set pricing strategy.
624    *
625    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
626    */
627   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
628     pricingStrategy = _pricingStrategy;
629 
630     // Don't allow setting bad agent
631     if(!pricingStrategy.isPricingStrategy()) {
632       throw;
633     }
634   }
635 
636   /**
637    * Allow load refunds back on the contract for the refunding.
638    *
639    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
640    */
641   function loadRefund() public payable inState(State.Failure) {
642     if(msg.value == 0) throw;
643     loadedRefund = loadedRefund.plus(msg.value);
644   }
645 
646   /**
647    * Investors can claim refund.
648    */
649   function refund() public inState(State.Refunding) {
650     uint256 weiValue = investedAmountOf[msg.sender];
651     if (weiValue == 0) throw;
652     investedAmountOf[msg.sender] = 0;
653     weiRefunded = weiRefunded.plus(weiValue);
654     Refund(msg.sender, weiValue);
655     if (!msg.sender.send(weiValue)) throw;
656   }
657 
658   /**
659    * @return true if the crowdsale has raised enough money to be a succes
660    */
661   function isMinimumGoalReached() public constant returns (bool reached) {
662     return weiRaised >= minimumFundingGoal;
663   }
664 
665   /**
666    * Check if the contract relationship looks good.
667    */
668   function isFinalizerSane() public constant returns (bool sane) {
669     return finalizeAgent.isSane();
670   }
671 
672   /**
673    * Check if the contract relationship looks good.
674    */
675   function isPricingSane() public constant returns (bool sane) {
676     return pricingStrategy.isSane(address(this));
677   }
678 
679   /**
680    * Crowdfund state machine management.
681    *
682    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
683    */
684   function getState() public constant returns (State) {
685     if(finalized) return State.Finalized;
686     else if (address(finalizeAgent) == 0) return State.Preparing;
687     else if (!finalizeAgent.isSane()) return State.Preparing;
688     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
689     else if (block.timestamp < startsAt) return State.PreFunding;
690     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
691     else if (isMinimumGoalReached()) return State.Success;
692     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
693     else return State.Failure;
694   }
695 
696   /** This is for manual testing of multisig wallet interaction */
697   function setOwnerTestValue(uint val) onlyOwner {
698     ownerTestValue = val;
699   }
700 
701   /** Interface marker. */
702   function isCrowdsale() public constant returns (bool) {
703     return true;
704   }
705 
706   //
707   // Modifiers
708   //
709 
710   /** Modified allowing execution only if the crowdsale is currently running.  */
711   modifier inState(State state) {
712     if(getState() != state) throw;
713     _;
714   }
715 
716 
717   //
718   // Abstract functions
719   //
720 
721   /**
722    * Check if the current invested breaks our cap rules.
723    *
724    *
725    * The child contract must define their own cap setting rules.
726    * We allow a lot of flexibility through different capping strategies (ETH, token count)
727    * Called from invest().
728    *
729    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
730    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
731    * @param weiRaisedTotal What would be our total raised balance after this transaction
732    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
733    *
734    * @return true if taking this investment would break our cap rules
735    */
736   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
737 
738   /**
739    * Check if the current crowdsale is full and we can no longer sell any tokens.
740    */
741   function isCrowdsaleFull() public constant returns (bool);
742 
743   /**
744    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
745    */
746   function assignTokens(address receiver, uint tokenAmount) private;
747 }
748 
749 
750 
751 
752 
753 
754 
755 /**
756  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
757  *
758  * Based on code by FirstBlood:
759  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
760  */
761 contract StandardToken is ERC20, SafeMath {
762 
763   /* Token supply got increased and a new owner received these tokens */
764   event Minted(address receiver, uint amount);
765 
766   /* Actual balances of token holders */
767   mapping(address => uint) balances;
768 
769   /* approve() allowances */
770   mapping (address => mapping (address => uint)) allowed;
771 
772   /**
773    *
774    * Fix for the ERC20 short address attack
775    *
776    * http://vessenes.com/the-erc20-short-address-attack-explained/
777    */
778   modifier onlyPayloadSize(uint size) {
779      if(msg.data.length != size + 4) {
780        throw;
781      }
782      _;
783   }
784 
785   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
786     balances[msg.sender] = safeSub(balances[msg.sender], _value);
787     balances[_to] = safeAdd(balances[_to], _value);
788     Transfer(msg.sender, _to, _value);
789     return true;
790   }
791 
792   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
793     uint _allowance = allowed[_from][msg.sender];
794 
795     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
796     // if (_value > _allowance) throw;
797 
798     balances[_to] = safeAdd(balances[_to], _value);
799     balances[_from] = safeSub(balances[_from], _value);
800     allowed[_from][msg.sender] = safeSub(_allowance, _value);
801     Transfer(_from, _to, _value);
802     return true;
803   }
804 
805   function balanceOf(address _owner) constant returns (uint balance) {
806     return balances[_owner];
807   }
808 
809   function approve(address _spender, uint _value) returns (bool success) {
810 
811     // To change the approve amount you first have to reduce the addresses`
812     //  allowance to zero by calling `approve(_spender, 0)` if it is not
813     //  already 0 to mitigate the race condition described here:
814     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
815     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
816 
817     allowed[msg.sender][_spender] = _value;
818     Approval(msg.sender, _spender, _value);
819     return true;
820   }
821 
822   function allowance(address _owner, address _spender) constant returns (uint remaining) {
823     return allowed[_owner][_spender];
824   }
825 
826   /**
827    * Atomic increment of approved spending
828    *
829    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
830    *
831    */
832   function addApproval(address _spender, uint _addedValue)
833   onlyPayloadSize(2 * 32)
834   returns (bool success) {
835       uint oldValue = allowed[msg.sender][_spender];
836       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
837       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
838       return true;
839   }
840 
841   /**
842    * Atomic decrement of approved spending.
843    *
844    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
845    */
846   function subApproval(address _spender, uint _subtractedValue)
847   onlyPayloadSize(2 * 32)
848   returns (bool success) {
849 
850       uint oldVal = allowed[msg.sender][_spender];
851 
852       if (_subtractedValue > oldVal) {
853           allowed[msg.sender][_spender] = 0;
854       } else {
855           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
856       }
857       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
858       return true;
859   }
860 
861 }
862 
863 
864 
865 /**
866  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
867  *
868  * - Collect funds from pre-sale investors
869  * - Send funds to the crowdsale when it opens
870  * - Allow owner to set the crowdsale
871  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
872  * - Allow unlimited investors
873  * - Tokens are distributed on PreICOProxyBuyer smart contract first
874  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
875  * - All functions can be halted by owner if something goes wrong
876  *
877  */
878 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
879 
880   /** How many investors we have now */
881   uint public investorCount;
882 
883   /** How many wei we have raised totla. */
884   uint public weiRaisedTotal;
885 
886   /** Who are our investors (iterable) */
887   address[] public investors;
888 
889   /** How much they have invested */
890   mapping(address => uint) public balances;
891 
892   /** How many tokens investors have claimed */
893   mapping(address => uint) public claimed;
894 
895   /** When our refund freeze is over (UNIT timestamp) */
896   uint public freezeEndsAt;
897 
898   /** What is the minimum buy in */
899   uint public weiMinimumLimit;
900 
901   /** How many weis total we are allowed to collect. */
902   uint public weiCap;
903 
904   /** How many tokens were bought */
905   uint public tokensBought;
906 
907    /** How many investors have claimed their tokens */
908   uint public claimCount;
909 
910   uint public totalClaimed;
911 
912   /** Our ICO contract where we will move the funds */
913   Crowdsale public crowdsale;
914 
915   /** What is our current state. */
916   enum State{Unknown, Funding, Distributing, Refunding}
917 
918   /** Somebody loaded their investment money */
919   event Invested(address investor, uint value);
920 
921   /** Refund claimed */
922   event Refunded(address investor, uint value);
923 
924   /** We executed our buy */
925   event TokensBoughts(uint count);
926 
927   /** We distributed tokens to an investor */
928   event Distributed(address investors, uint count);
929 
930   /**
931    * Create presale contract where lock up period is given days
932    */
933   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiCap) {
934 
935     owner = _owner;
936 
937     // Give argument
938     if(_freezeEndsAt == 0) {
939       throw;
940     }
941 
942     // Give argument
943     if(_weiMinimumLimit == 0) {
944       throw;
945     }
946 
947     weiMinimumLimit = _weiMinimumLimit;
948     weiCap = _weiCap;
949     freezeEndsAt = _freezeEndsAt;
950   }
951 
952   /**
953    * Get the token we are distributing.
954    */
955   function getToken() public constant returns(FractionalERC20) {
956     if(address(crowdsale) == 0)  {
957       throw;
958     }
959 
960     return crowdsale.token();
961   }
962 
963   /**
964    * Participate to a presale.
965    */
966   function invest() public stopInEmergency payable {
967 
968     // Cannot invest anymore through crowdsale when moving has begun
969     if(getState() != State.Funding) throw;
970 
971     if(msg.value == 0) throw; // No empty buys
972 
973     address investor = msg.sender;
974 
975     bool existing = balances[investor] > 0;
976 
977     balances[investor] = safeAdd(balances[investor], msg.value);
978 
979     // Need to fulfill minimum limit
980     if(balances[investor] < weiMinimumLimit) {
981       throw;
982     }
983 
984     // This is a new investor
985     if(!existing) {
986       investors.push(investor);
987       investorCount++;
988     }
989 
990     weiRaisedTotal = safeAdd(weiRaisedTotal, msg.value);
991     if(weiRaisedTotal > weiCap) {
992       throw;
993     }
994 
995     Invested(investor, msg.value);
996   }
997 
998   /**
999    * Load funds to the crowdsale for all investors.
1000    *
1001    *
1002    */
1003   function buyForEverybody() stopInEmergency public {
1004 
1005     if(getState() != State.Funding) {
1006       // Only allow buy once
1007       throw;
1008     }
1009 
1010     // Crowdsale not yet set
1011     if(address(crowdsale) == 0) throw;
1012 
1013     // Buy tokens on the contract
1014     crowdsale.invest.value(weiRaisedTotal)(address(this));
1015 
1016     // Record how many tokens we got
1017     tokensBought = getToken().balanceOf(address(this));
1018 
1019     if(tokensBought == 0) {
1020       // Did not get any tokens
1021       throw;
1022     }
1023 
1024     TokensBoughts(tokensBought);
1025   }
1026 
1027   /**
1028    * How may tokens each investor gets.
1029    */
1030   function getClaimAmount(address investor) public constant returns (uint) {
1031 
1032     // Claims can be only made if we manage to buy tokens
1033     if(getState() != State.Distributing) {
1034       throw;
1035     }
1036     return safeMul(balances[investor], tokensBought) / weiRaisedTotal;
1037   }
1038 
1039   /**
1040    * How many tokens remain unclaimed for an investor.
1041    */
1042   function getClaimLeft(address investor) public constant returns (uint) {
1043     return safeSub(getClaimAmount(investor), claimed[investor]);
1044   }
1045 
1046   /**
1047    * Claim all remaining tokens for this investor.
1048    */
1049   function claimAll() {
1050     claim(getClaimLeft(msg.sender));
1051   }
1052 
1053   /**
1054    * Claim N bought tokens to the investor as the msg sender.
1055    *
1056    */
1057   function claim(uint amount) stopInEmergency {
1058     address investor = msg.sender;
1059 
1060     if(amount == 0) {
1061       throw;
1062     }
1063 
1064     if(getClaimLeft(investor) < amount) {
1065       // Woops we cannot get more than we have left
1066       throw;
1067     }
1068 
1069     // We track who many investor have (partially) claimed their tokens
1070     if(claimed[investor] == 0) {
1071       claimCount++;
1072     }
1073 
1074     claimed[investor] = safeAdd(claimed[investor], amount);
1075     totalClaimed = safeAdd(totalClaimed, amount);
1076     getToken().transfer(investor, amount);
1077 
1078     Distributed(investor, amount);
1079   }
1080 
1081   /**
1082    * ICO never happened. Allow refund.
1083    */
1084   function refund() stopInEmergency {
1085 
1086     // Trying to ask refund too soon
1087     if(getState() != State.Refunding) throw;
1088 
1089     address investor = msg.sender;
1090     if(balances[investor] == 0) throw;
1091     uint amount = balances[investor];
1092     delete balances[investor];
1093     if(!investor.send(amount)) throw;
1094     Refunded(investor, amount);
1095   }
1096 
1097   /**
1098    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1099    */
1100   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1101     crowdsale = _crowdsale;
1102 
1103     // Check interface
1104     if(!crowdsale.isCrowdsale()) true;
1105   }
1106 
1107   /**
1108    * Resolve the contract umambigious state.
1109    */
1110   function getState() public returns(State) {
1111     if(tokensBought == 0) {
1112       if(now >= freezeEndsAt) {
1113          return State.Refunding;
1114       } else {
1115         return State.Funding;
1116       }
1117     } else {
1118       return State.Distributing;
1119     }
1120   }
1121 
1122   /** Explicitly call function from your wallet. */
1123   function() payable {
1124     throw;
1125   }
1126 }