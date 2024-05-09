1 library SafeMathLib {
2 
3   function times(uint a, uint b) returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function minus(uint a, uint b) returns (uint) {
10     assert(b <= a);
11     return a - b;
12   }
13 
14   function plus(uint a, uint b) returns (uint) {
15     uint c = a + b;
16     assert(c>=a);
17     return c;
18   }
19 
20 }
21 
22 contract ERC20Basic {
23   uint256 public totalSupply;
24   function balanceOf(address who) constant returns (uint256);
25   function transfer(address to, uint256 value) returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 
30 contract ERC20 is ERC20Basic {
31   function allowance(address owner, address spender) constant returns (uint256);
32   function transferFrom(address from, address to, uint256 value) returns (bool);
33   function approve(address spender, uint256 value) returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 contract FractionalERC20 is ERC20 {
38 
39   uint public decimals;
40 
41 }
42 
43 contract FinalizeAgent {
44 
45   function isFinalizeAgent() public constant returns(bool) {
46     return true;
47   }
48 
49   /** Return true if we can run finalizeCrowdsale() properly.
50    *
51    * This is a safety check function that doesn't allow crowdsale to begin
52    * unless the finalizer has been set up properly.
53    */
54   function isSane() public constant returns (bool);
55 
56   /** Called once by crowdsale finalize() if the sale was success. */
57   function finalizeCrowdsale();
58 
59 }
60 
61 contract PricingStrategy {
62 
63   /** Interface declaration. */
64   function isPricingStrategy() public constant returns (bool) {
65     return true;
66   }
67 
68   /** Self check if all references are correctly set.
69    *
70    * Checks that pricing strategy matches crowdsale parameters.
71    */
72   function isSane(address crowdsale) public constant returns (bool) {
73     return true;
74   }
75 
76   /**
77    * @dev Pricing tells if this is a presale purchase or not.
78      @param purchaser Address of the purchaser
79      @return False by default, true if a presale purchaser
80    */
81   function isPresalePurchase(address purchaser) public constant returns (bool) {
82     return false;
83   }
84 
85   /**
86    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
87    *
88    *
89    * @param value - What is the value of the transaction send in as wei
90    * @param tokensSold - how much tokens have been sold this far
91    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
92    * @param msgSender - who is the investor of this transaction
93    * @param decimals - how many decimal units the token has
94    * @return Amount of tokens the investor receives
95    */
96   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
97 }
98 
99 
100 
101 contract Ownable {
102   address public owner;
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   function Ownable() {
110     owner = msg.sender;
111   }
112 
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) onlyOwner {
128     if (newOwner != address(0)) {
129       owner = newOwner;
130     }
131   }
132 
133 }
134 
135 contract Haltable is Ownable {
136   bool public halted;
137 
138   modifier stopInEmergency {
139     if (halted) throw;
140     _;
141   }
142 
143   modifier stopNonOwnersInEmergency {
144     if (halted && msg.sender != owner) throw;
145     _;
146   }
147 
148   modifier onlyInEmergency {
149     if (!halted) throw;
150     _;
151   }
152 
153   // called by the owner on emergency, triggers stopped state
154   function halt() external onlyOwner {
155     halted = true;
156   }
157 
158   // called by the owner on end of emergency, returns to normal state
159   function unhalt() external onlyOwner onlyInEmergency {
160     halted = false;
161   }
162 
163 }
164 contract SafeMath {
165   function safeMul(uint a, uint b) internal returns (uint) {
166     uint c = a * b;
167     assert(a == 0 || c / a == b);
168     return c;
169   }
170 
171   function safeDiv(uint a, uint b) internal returns (uint) {
172     assert(b > 0);
173     uint c = a / b;
174     assert(a == b * c + a % b);
175     return c;
176   }
177 
178   function safeSub(uint a, uint b) internal returns (uint) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   function safeAdd(uint a, uint b) internal returns (uint) {
184     uint c = a + b;
185     assert(c>=a && c>=b);
186     return c;
187   }
188 
189   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
190     return a >= b ? a : b;
191   }
192 
193   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
194     return a < b ? a : b;
195   }
196 
197   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
198     return a >= b ? a : b;
199   }
200 
201   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
202     return a < b ? a : b;
203   }
204 
205 }
206 
207 
208 contract StandardToken is ERC20, SafeMath {
209 
210   /* Token supply got increased and a new owner received these tokens */
211   event Minted(address receiver, uint amount);
212 
213   /* Actual balances of token holders */
214   mapping(address => uint) balances;
215 
216   /* approve() allowances */
217   mapping (address => mapping (address => uint)) allowed;
218 
219   /* Interface declaration */
220   function isToken() public constant returns (bool weAre) {
221     return true;
222   }
223 
224   function transfer(address _to, uint _value) returns (bool success) {
225     balances[msg.sender] = safeSub(balances[msg.sender], _value);
226     balances[_to] = safeAdd(balances[_to], _value);
227     Transfer(msg.sender, _to, _value);
228     return true;
229   }
230 
231   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
232     uint _allowance = allowed[_from][msg.sender];
233 
234     balances[_to] = safeAdd(balances[_to], _value);
235     balances[_from] = safeSub(balances[_from], _value);
236     allowed[_from][msg.sender] = safeSub(_allowance, _value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   function balanceOf(address _owner) constant returns (uint balance) {
242     return balances[_owner];
243   }
244 
245   function approve(address _spender, uint _value) returns (bool success) {
246 
247     // To change the approve amount you first have to reduce the addresses`
248     //  allowance to zero by calling `approve(_spender, 0)` if it is not
249     //  already 0 to mitigate the race condition described here:
250     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
252 
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   function allowance(address _owner, address _spender) constant returns (uint remaining) {
259     return allowed[_owner][_spender];
260   }
261 
262 }
263 
264 contract MintableToken is StandardToken, Ownable {
265 
266   using SafeMathLib for uint;
267 
268   bool public mintingFinished = false;
269 
270   /** List of agents that are allowed to create new tokens */
271   mapping (address => bool) public mintAgents;
272 
273   event MintingAgentChanged(address addr, bool state  );
274 
275   /**
276    * Create new tokens and allocate them to an address..
277    *
278    * Only callably by a crowdsale contract (mint agent).
279    */
280   function mint(address receiver, uint amount) onlyMintAgent canMint public {
281     totalSupply = totalSupply.plus(amount);
282     balances[receiver] = balances[receiver].plus(amount);
283 
284     // This will make the mint transaction apper in EtherScan.io
285     // We can remove this after there is a standardized minting event
286     Transfer(0, receiver, amount);
287   }
288 
289   /**
290    * Owner can allow a crowdsale contract to mint new tokens.
291    */
292   function setMintAgent(address addr, bool state) onlyOwner canMint public {
293     mintAgents[addr] = state;
294     MintingAgentChanged(addr, state);
295   }
296 
297   modifier onlyMintAgent() {
298     // Only crowdsale contracts are allowed to mint new tokens
299     if(!mintAgents[msg.sender]) {
300         throw;
301     }
302     _;
303   }
304 
305   /** Make sure we are not done yet. */
306   modifier canMint() {
307     if(mintingFinished) throw;
308     _;
309   }
310 }
311 
312 
313 contract Crowdsale is Haltable {
314 
315   /* Max investment count when we are still allowed to change the multisig address */
316   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
317 
318   using SafeMathLib for uint;
319 
320   /* The token we are selling */
321   FractionalERC20 public token;
322 
323   /* How we are going to price our offering */
324   PricingStrategy public pricingStrategy;
325 
326   /* Post-success callback */
327   FinalizeAgent public finalizeAgent;
328 
329   /* tokens will be transfered from this address */
330   address public multisigWallet;
331 
332   /* if the funding goal is not reached, investors may withdraw their funds */
333   uint public minimumFundingGoal;
334 
335   /* the UNIX timestamp start date of the crowdsale */
336   uint public startsAt;
337 
338   /* the UNIX timestamp end date of the crowdsale */
339   uint public endsAt;
340 
341   /* the number of tokens already sold through this contract*/
342   uint public tokensSold = 0;
343 
344   /* How many wei of funding we have raised */
345   uint public weiRaised = 0;
346 
347   /* Calculate incoming funds from presale contracts and addresses */
348   uint public presaleWeiRaised = 0;
349 
350   /* How many distinct addresses have invested */
351   uint public investorCount = 0;
352 
353   /* How much wei we have returned back to the contract after a failed crowdfund. */
354   uint public loadedRefund = 0;
355 
356   /* How much wei we have given back to investors.*/
357   uint public weiRefunded = 0;
358 
359   /* Has this crowdsale been finalized */
360   bool public finalized;
361 
362   /* Do we need to have unique contributor id for each customer */
363   bool public requireCustomerId;
364 
365   /**
366     * Do we verify that contributor has been cleared on the server side (accredited investors only).
367     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
368     */
369   bool public requiredSignedAddress;
370 
371   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
372   address public signerAddress;
373 
374   /** How much ETH each address has invested to this crowdsale */
375   mapping (address => uint256) public investedAmountOf;
376 
377   /** How much tokens this crowdsale has credited for each investor address */
378   mapping (address => uint256) public tokenAmountOf;
379 
380   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
381   mapping (address => bool) public earlyParticipantWhitelist;
382 
383   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
384   uint public ownerTestValue;
385 
386   /** State machine
387    *
388    * - Preparing: All contract initialization calls and variables have not been set yet
389    * - Prefunding: We have not passed start time yet
390    * - Funding: Active crowdsale
391    * - Success: Minimum funding goal reached
392    * - Failure: Minimum funding goal not reached before ending time
393    * - Finalized: The finalized has been called and succesfully executed
394    * - Refunding: Refunds are loaded on the contract for reclaim.
395    */
396   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
397 
398   // A new investment was made
399   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
400 
401   // Refund was processed for a contributor
402   event Refund(address investor, uint weiAmount);
403 
404   // The rules were changed what kind of investments we accept
405   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
406 
407   // Address early participation whitelist status changed
408   event Whitelisted(address addr, bool status);
409 
410   // Crowdsale end time has been changed
411   event EndsAtChanged(uint newEndsAt);
412 
413   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
414 
415     owner = msg.sender;
416 
417     token = FractionalERC20(_token);
418 
419     setPricingStrategy(_pricingStrategy);
420 
421     multisigWallet = _multisigWallet;
422     if(multisigWallet == 0) {
423         throw;
424     }
425 
426     if(_start == 0) {
427         throw;
428     }
429 
430     startsAt = _start;
431 
432     if(_end == 0) {
433         throw;
434     }
435 
436     endsAt = _end;
437 
438     // Don't mess the dates
439     if(startsAt >= endsAt) {
440         throw;
441     }
442 
443     // Minimum funding goal can be zero
444     minimumFundingGoal = _minimumFundingGoal;
445   }
446 
447   /**
448    * Don't expect to just send in money and get tokens.
449    */
450   function() payable {
451     throw;
452   }
453 
454   /**
455    * Make an investment.
456    *
457    * Crowdsale must be running for one to invest.
458    * We must have not pressed the emergency brake.
459    *
460    * @param receiver The Ethereum address who receives the tokens
461    * @param customerId (optional) UUID v4 to track the successful payments on the server side
462    *
463    */
464   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
465 
466     // Determine if it's a good time to accept investment from this participant
467     if(getState() == State.PreFunding) {
468       // Are we whitelisted for early deposit
469       if(!earlyParticipantWhitelist[receiver]) {
470         throw;
471       }
472     } else if(getState() == State.Funding) {
473       // Retail participants can only come in when the crowdsale is running
474       // pass
475     } else {
476       // Unwanted state
477       throw;
478     }
479 
480     uint weiAmount = msg.value;
481 
482     // Account presale sales separately, so that they do not count against pricing tranches
483     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
484 
485     if(tokenAmount == 0) {
486       // Dust transaction
487       throw;
488     }
489 
490     if(investedAmountOf[receiver] == 0) {
491        // A new investor
492        investorCount++;
493     }
494 
495     // Update investor
496     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
497     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
498 
499     // Update totals
500     weiRaised = weiRaised.plus(weiAmount);
501     tokensSold = tokensSold.plus(tokenAmount);
502 
503     if(pricingStrategy.isPresalePurchase(receiver)) {
504         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
505     }
506 
507     // Check that we did not bust the cap
508     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
509       throw;
510     }
511 
512     assignTokens(receiver, tokenAmount);
513 
514     // Pocket the money
515     if(!multisigWallet.send(weiAmount)) throw;
516 
517     // Tell us invest was success
518     Invested(receiver, weiAmount, tokenAmount, customerId);
519   }
520 
521   /**
522    * Preallocate tokens for the early investors.
523    *
524    * Preallocated tokens have been sold before the actual crowdsale opens.
525    * This function mints the tokens and moves the crowdsale needle.
526    *
527    * Investor count is not handled; it is assumed this goes for multiple investors
528    * and the token distribution happens outside the smart contract flow.
529    *
530    * No money is exchanged, as the crowdsale team already have received the payment.
531    *
532    * @param fullTokens tokens as full tokens - decimal places added internally
533    * @param weiPrice Price of a single full token in wei
534    *
535    */
536   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
537 
538     uint tokenAmount = fullTokens * 10**token.decimals();
539     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
540 
541     weiRaised = weiRaised.plus(weiAmount);
542     tokensSold = tokensSold.plus(tokenAmount);
543 
544     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
545     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
546 
547     assignTokens(receiver, tokenAmount);
548 
549     // Tell us invest was success
550     Invested(receiver, weiAmount, tokenAmount, 0);
551   }
552 
553   /**
554    * Allow anonymous contributions to this crowdsale.
555    */
556   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
557      bytes32 hash = sha256(addr);
558      if (ecrecover(hash, v, r, s) != signerAddress) throw;
559      if(customerId == 0) throw;  // UUIDv4 sanity check
560      investInternal(addr, customerId);
561   }
562 
563   /**
564    * Track who is the customer making the payment so we can send thank you email.
565    */
566   function investWithCustomerId(address addr, uint128 customerId) public payable {
567     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
568     if(customerId == 0) throw;  // UUIDv4 sanity check
569     investInternal(addr, customerId);
570   }
571 
572   /**
573    * Allow anonymous contributions to this crowdsale.
574    */
575   function invest(address addr) public payable {
576     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
577     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
578     investInternal(addr, 0);
579   }
580 
581   /**
582    * Invest to tokens, recognize the payer and clear his address.
583    *
584    */
585   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
586     investWithSignedAddress(msg.sender, customerId, v, r, s);
587   }
588 
589   /**
590    * Invest to tokens, recognize the payer.
591    *
592    */
593   function buyWithCustomerId(uint128 customerId) public payable {
594     investWithCustomerId(msg.sender, customerId);
595   }
596 
597   /**
598    * The basic entry point to participate the crowdsale process.
599    *
600    * Pay for funding, get invested tokens back in the sender address.
601    */
602   function buy() public payable {
603     invest(msg.sender);
604   }
605 
606   /**
607    * Finalize a succcesful crowdsale.
608    *
609    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
610    */
611   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
612 
613     // Already finalized
614     if(finalized) {
615       throw;
616     }
617 
618     // Finalizing is optional. We only call it if we are given a finalizing agent.
619     if(address(finalizeAgent) != 0) {
620       finalizeAgent.finalizeCrowdsale();
621     }
622 
623     finalized = true;
624   }
625 
626   /**
627    * Allow to (re)set finalize agent.
628    *
629    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
630    */
631   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
632     finalizeAgent = addr;
633 
634     // Don't allow setting bad agent
635     if(!finalizeAgent.isFinalizeAgent()) {
636       throw;
637     }
638   }
639 
640   /**
641    * Set policy do we need to have server-side customer ids for the investments.
642    *
643    */
644   function setRequireCustomerId(bool value) onlyOwner {
645     requireCustomerId = value;
646     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
647   }
648 
649   /**
650    * Set policy if all investors must be cleared on the server side first.
651    *
652    * This is e.g. for the accredited investor clearing.
653    *
654    */
655   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
656     requiredSignedAddress = value;
657     signerAddress = _signerAddress;
658     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
659   }
660 
661   /**
662    * Allow addresses to do early participation.
663    *
664    * TODO: Fix spelling error in the name
665    */
666   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
667     earlyParticipantWhitelist[addr] = status;
668     Whitelisted(addr, status);
669   }
670 
671   /**
672    * Allow crowdsale owner to close early or extend the crowdsale.
673    *
674    * This is useful e.g. for a manual soft cap implementation:
675    * - after X amount is reached determine manual closing
676    *
677    * This may put the crowdsale to an invalid state,
678    * but we trust owners know what they are doing.
679    *
680    */
681   function setEndsAt(uint time) onlyOwner {
682 
683     if(now > time) {
684       throw; // Don't change past
685     }
686 
687     endsAt = time;
688     EndsAtChanged(endsAt);
689   }
690 
691   /**
692    * Allow to (re)set pricing strategy.
693    *
694    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
695    */
696   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
697     pricingStrategy = _pricingStrategy;
698 
699     // Don't allow setting bad agent
700     if(!pricingStrategy.isPricingStrategy()) {
701       throw;
702     }
703   }
704 
705   /**
706    * Allow to change the team multisig address in the case of emergency.
707    *
708    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
709    * (we have done only few test transactions). After the crowdsale is going
710    * then multisig address stays locked for the safety reasons.
711    */
712   function setMultisig(address addr) public onlyOwner {
713 
714     // Change
715     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
716       throw;
717     }
718 
719     multisigWallet = addr;
720   }
721 
722   /**
723    * Allow load refunds back on the contract for the refunding.
724    *
725    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
726    */
727   function loadRefund() public payable inState(State.Failure) {
728     if(msg.value == 0) throw;
729     loadedRefund = loadedRefund.plus(msg.value);
730   }
731 
732   /**
733    * Investors can claim refund.
734    *
735    * Note that any refunds from proxy buyers should be handled separately,
736    * and not through this contract.
737    */
738   function refund() public inState(State.Refunding) {
739     uint256 weiValue = investedAmountOf[msg.sender];
740     if (weiValue == 0) throw;
741     investedAmountOf[msg.sender] = 0;
742     weiRefunded = weiRefunded.plus(weiValue);
743     Refund(msg.sender, weiValue);
744     if (!msg.sender.send(weiValue)) throw;
745   }
746 
747   /**
748    * @return true if the crowdsale has raised enough money to be a successful.
749    */
750   function isMinimumGoalReached() public constant returns (bool reached) {
751     return weiRaised >= minimumFundingGoal;
752   }
753 
754   /**
755    * Check if the contract relationship looks good.
756    */
757   function isFinalizerSane() public constant returns (bool sane) {
758     return finalizeAgent.isSane();
759   }
760 
761   /**
762    * Check if the contract relationship looks good.
763    */
764   function isPricingSane() public constant returns (bool sane) {
765     return pricingStrategy.isSane(address(this));
766   }
767 
768   /**
769    * Crowdfund state machine management.
770    *
771    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
772    */
773   function getState() public constant returns (State) {
774     if(finalized) return State.Finalized;
775     else if (address(finalizeAgent) == 0) return State.Preparing;
776     else if (!finalizeAgent.isSane()) return State.Preparing;
777     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
778     else if (block.timestamp < startsAt) return State.PreFunding;
779     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
780     else if (isMinimumGoalReached()) return State.Success;
781     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
782     else return State.Failure;
783   }
784 
785   /** This is for manual testing of multisig wallet interaction */
786   function setOwnerTestValue(uint val) onlyOwner {
787     ownerTestValue = val;
788   }
789 
790   /** Interface marker. */
791   function isCrowdsale() public constant returns (bool) {
792     return true;
793   }
794 
795   //
796   // Modifiers
797   //
798 
799   /** Modified allowing execution only if the crowdsale is currently running.  */
800   modifier inState(State state) {
801     if(getState() != state) throw;
802     _;
803   }
804 
805 
806   //
807   // Abstract functions
808   //
809 
810   /**
811    * Check if the current invested breaks our cap rules.
812    *
813    *
814    * The child contract must define their own cap setting rules.
815    * We allow a lot of flexibility through different capping strategies (ETH, token count)
816    * Called from invest().
817    *
818    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
819    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
820    * @param weiRaisedTotal What would be our total raised balance after this transaction
821    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
822    *
823    * @return true if taking this investment would break our cap rules
824    */
825   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
826 
827   /**
828    * Check if the current crowdsale is full and we can no longer sell any tokens.
829    */
830   function isCrowdsaleFull() public constant returns (bool);
831 
832   /**
833    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
834    */
835   function assignTokens(address receiver, uint tokenAmount) private;
836 }
837 
838 contract MintedTokenCappedCrowdsale is Crowdsale {
839 
840   /* Maximum amount of tokens this crowdsale can sell. */
841   uint public maximumSellableTokens;
842 
843   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
844     maximumSellableTokens = _maximumSellableTokens;
845   }
846 
847   /**
848    * Called from invest() to confirm if the curret investment does not break our cap rule.
849    */
850   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
851     return tokensSoldTotal > maximumSellableTokens;
852   }
853 
854   function isCrowdsaleFull() public constant returns (bool) {
855     return tokensSold >= maximumSellableTokens;
856   }
857 
858   /**
859    * Dynamically create tokens and assign them to the investor.
860    */
861   function assignTokens(address receiver, uint tokenAmount) private {
862     MintableToken mintableToken = MintableToken(token);
863     mintableToken.mint(receiver, tokenAmount);
864   }
865 }
866 
867 contract GetPreCrowdsale is MintedTokenCappedCrowdsale {
868 
869     function GetPreCrowdsale(
870         address _token, PricingStrategy _pricingStrategy, address _multisigWallet,
871         uint _start, uint _end, uint _maximumSellableTokens)
872         MintedTokenCappedCrowdsale(_token, _pricingStrategy, _multisigWallet,
873             _start, _end, 0, _maximumSellableTokens)
874     {
875     }
876 
877     function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
878         // We don't need this function, we have external whitelist
879         revert();
880     }
881 
882     function() payable {
883         invest(msg.sender);
884     }
885 }