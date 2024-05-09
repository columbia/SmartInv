1 pragma solidity ^0.4.6;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /*
55  * Ownable
56  *
57  * Base contract with an owner.
58  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
59  */
60 contract Ownable {
61   address public owner;
62 
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67   modifier onlyOwner() {
68     if (msg.sender != owner) {
69       throw;
70     }
71     _;
72   }
73 
74   function transferOwnership(address newOwner) onlyOwner {
75     if (newOwner != address(0)) {
76       owner = newOwner;
77     }
78   }
79 
80 }
81 
82 
83 /*
84  * Haltable
85  *
86  * Abstract contract that allows children to implement an
87  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
88  *
89  *
90  * Originally envisioned in FirstBlood ICO contract.
91  */
92 contract Haltable is Ownable {
93   bool public halted;
94 
95   modifier stopInEmergency {
96     if (halted) throw;
97     _;
98   }
99 
100   modifier onlyInEmergency {
101     if (!halted) throw;
102     _;
103   }
104 
105   // called by the owner on emergency, triggers stopped state
106   function halt() external onlyOwner {
107     halted = true;
108   }
109 
110   // called by the owner on end of emergency, returns to normal state
111   function unhalt() external onlyOwner onlyInEmergency {
112     halted = false;
113   }
114 
115 }
116 
117 /**
118  * Interface for defining crowdsale pricing.
119  */
120 contract PricingStrategy {
121 
122   /** Interface declaration. */
123   function isPricingStrategy() public constant returns (bool) {
124     return true;
125   }
126 
127   /** Self check if all references are correctly set.
128    *
129    * Checks that pricing strategy matches crowdsale parameters.
130    */
131   function isSane(address crowdsale) public constant returns (bool) {
132     return true;
133   }
134 
135   /**
136    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
137    *
138    *
139    * @param value - What is the value of the transaction send in as wei
140    * @param tokensSold - how much tokens have been sold this far
141    * @param weiRaised - how much money has been raised this far
142    * @param msgSender - who is the investor of this transaction
143    * @param decimals - how many decimal units the token has
144    * @return Amount of tokens the investor receives
145    */
146   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
147 }
148 
149 /**
150  * Finalize agent defines what happens at the end of succeseful crowdsale.
151  *
152  * - Allocate tokens for founders, bounties and community
153  * - Make tokens transferable
154  * - etc.
155  */
156 contract FinalizeAgent {
157 
158   function isFinalizeAgent() public constant returns(bool) {
159     return true;
160   }
161 
162   /** Return true if we can run finalizeCrowdsale() properly.
163    *
164    * This is a safety check function that doesn't allow crowdsale to begin
165    * unless the finalizer has been set up properly.
166    */
167   function isSane() public constant returns (bool);
168 
169   /** Called once by crowdsale finalize() if the sale was success. */
170   function finalizeCrowdsale();
171 
172 }
173 
174 /*
175  * ERC20 interface
176  * see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 {
179   uint public totalSupply;
180   function balanceOf(address who) constant returns (uint);
181   function allowance(address owner, address spender) constant returns (uint);
182 
183   function transfer(address to, uint value) returns (bool ok);
184   function transferFrom(address from, address to, uint value) returns (bool ok);
185   function approve(address spender, uint value) returns (bool ok);
186   event Transfer(address indexed from, address indexed to, uint value);
187   event Approval(address indexed owner, address indexed spender, uint value);
188 }
189 
190 
191 /**
192  * A token that defines fractional units as decimals.
193  */
194 contract FractionalERC20 is ERC20 {
195 
196   uint public decimals;
197 
198 }
199 
200 
201 /**
202  * Abstract base contract for token sales.
203  *
204  * Handle
205  * - start and end dates
206  * - accepting investments
207  * - minimum funding goal and refund
208  * - various statistics during the crowdfund
209  *
210  */
211 contract Crowdsale is Haltable, SafeMath {
212 
213   /* Max investment count when we are still allowed to change the multisig address */
214   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
215 
216   /* The token we are selling */
217   FractionalERC20 public token;
218 
219   /* How we are going to price our offering */
220   PricingStrategy public pricingStrategy;
221 
222   /* Post-success callback */
223   FinalizeAgent public finalizeAgent;
224 
225   /* tokens will be transfered from this address */
226   address public multisigWallet;
227 
228   /* if the funding goal is not reached, investors may withdraw their funds */
229   uint public minimumFundingGoal;
230 
231   /* the UNIX timestamp start date of the crowdsale */
232   uint public startsAt;
233 
234   /* the UNIX timestamp end date of the crowdsale */
235   uint public endsAt;
236 
237   /* the number of tokens already sold through this contract*/
238   uint public tokensSold = 0;
239 
240   /* How many wei of funding we have raised */
241   uint public weiRaised = 0;
242 
243   /* How many distinct addresses have invested */
244   uint public investorCount = 0;
245 
246   /* How much wei we have returned back to the contract after a failed crowdfund. */
247   uint public loadedRefund = 0;
248 
249   /* How much wei we have given back to investors.*/
250   uint public weiRefunded = 0;
251 
252   /* Has this crowdsale been finalized */
253   bool public finalized;
254 
255   /** How much ETH each address has invested to this crowdsale */
256   mapping (address => uint256) public investedAmountOf;
257 
258   /** How much tokens this crowdsale has credited for each investor address */
259   mapping (address => uint256) public tokenAmountOf;
260 
261   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
262   mapping (address => bool) public earlyParticipantWhitelist;
263 
264   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
265   uint public ownerTestValue;
266 
267   /** State machine
268    *
269    * - Preparing: All contract initialization calls and variables have not been set yet
270    * - Prefunding: We have not passed start time yet
271    * - Funding: Active crowdsale
272    * - Success: Minimum funding goal reached
273    * - Failure: Minimum funding goal not reached before ending time
274    * - Finalized: The finalized has been called and succesfully executed
275    * - Refunding: Refunds are loaded on the contract for reclaim.
276    */
277   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
278 
279   // A new investment was made
280   event Invested(address investor, uint weiAmount, uint tokenAmount);
281 
282   // Refund was processed for a contributor
283   event Refund(address investor, uint weiAmount);
284 
285   // Address early participation whitelist status changed
286   event Whitelisted(address addr, bool status);
287 
288   // Crowdsale end time has been changed
289   event EndsAtChanged(uint endsAt);
290 
291   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
292 
293     owner = msg.sender;
294 
295     token = FractionalERC20(_token);
296 
297     setPricingStrategy(_pricingStrategy);
298 
299     multisigWallet = _multisigWallet;
300     if(multisigWallet == 0) {
301         throw;
302     }
303 
304     if(_start == 0) {
305         throw;
306     }
307 
308     startsAt = _start;
309 
310     if(_end == 0) {
311         throw;
312     }
313 
314     endsAt = _end;
315 
316     // Don't mess the dates
317     if(startsAt >= endsAt) {
318         throw;
319     }
320 
321     // Minimum funding goal can be zero
322     minimumFundingGoal = _minimumFundingGoal;
323   }
324 
325   /**
326    * Send in money and get tokens.
327    */
328   function() payable {
329     investInternal(msg.sender);
330   }
331 
332   /**
333    * Make an investment.
334    *
335    * Crowdsale must be running for one to invest.
336    * We must have not pressed the emergency brake.
337    *
338    * @param receiver The Ethereum address who receives the tokens
339    *
340    */
341   function investInternal(address receiver) stopInEmergency private {
342 
343     // Determine if it's a good time to accept investment from this participant
344     if(getState() == State.PreFunding) {
345       // Are we whitelisted for early deposit
346       if(!earlyParticipantWhitelist[receiver]) {
347         throw;
348       }
349     } else if(getState() == State.Funding) {
350       // Retail participants can only come in when the crowdsale is running
351       // pass
352     } else {
353       // Unwanted state
354       throw;
355     }
356 
357     uint weiAmount = msg.value;
358     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
359 
360     if(tokenAmount == 0) {
361       // Dust transaction
362       throw;
363     }
364 
365     if(investedAmountOf[receiver] == 0) {
366        // A new investor
367        investorCount++;
368     }
369 
370     // Update investor
371     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
372     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
373 
374     // Update totals
375     weiRaised = safeAdd(weiRaised, weiAmount);
376     tokensSold = safeAdd(tokensSold, tokenAmount);
377 
378     // Check that we did not bust the cap
379     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
380       throw;
381     }
382 
383     assignTokens(receiver, tokenAmount);
384 
385     // Pocket the money
386     if(!multisigWallet.send(weiAmount)) throw;
387 
388     // Tell us invest was success
389     Invested(receiver, weiAmount, tokenAmount);
390   }
391 
392   /**
393    * Finalize a succcesful crowdsale.
394    *
395    * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
396    */
397   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
398 
399     // Already finalized
400     if(finalized) {
401       throw;
402     }
403 
404     // Finalizing is optional. We only call it if we are given a finalizing agent.
405     if(address(finalizeAgent) != 0) {
406       finalizeAgent.finalizeCrowdsale();
407     }
408 
409     finalized = true;
410   }
411 
412   /**
413    * Allow to (re)set finalize agent.
414    *
415    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
416    */
417   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
418     finalizeAgent = addr;
419 
420     // Don't allow setting bad agent
421     if(!finalizeAgent.isFinalizeAgent()) {
422       throw;
423     }
424   }
425 
426   /**
427    * Allow addresses to do early participation.
428    *
429    * TODO: Fix spelling error in the name
430    */
431   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
432     earlyParticipantWhitelist[addr] = status;
433     Whitelisted(addr, status);
434   }
435 
436   /**
437    * Allow crowdsale owner to close early or extend the crowdsale.
438    *
439    * This is useful e.g. for a manual soft cap implementation:
440    * - after X amount is reached determine manual closing
441    *
442    * This may put the crowdsale to an invalid state,
443    * but we trust owners know what they are doing.
444    *
445    */
446   function setEndsAt(uint time) onlyOwner {
447 
448     if(now > time) {
449       throw; // Don't change past
450     }
451 
452     endsAt = time;
453     EndsAtChanged(endsAt);
454   }
455 
456   /**
457    * Allow to (re)set pricing strategy.
458    *
459    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
460    */
461   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
462     pricingStrategy = _pricingStrategy;
463 
464     // Don't allow setting bad agent
465     if(!pricingStrategy.isPricingStrategy()) {
466       throw;
467     }
468   }
469 
470   /**
471    * Allow to change the team multisig address in the case of emergency.
472    *
473    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
474    * (we have done only few test transactions). After the crowdsale is going
475    * then multisig address stays locked for the safety reasons.
476    */
477   function setMultisig(address addr) public onlyOwner {
478 
479     // Change
480     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
481       throw;
482     }
483 
484     multisigWallet = addr;
485   }
486 
487   /**
488    * Allow load refunds back on the contract for the refunding.
489    *
490    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
491    */
492   function loadRefund() public payable inState(State.Failure) {
493     if(msg.value == 0) throw;
494     loadedRefund = safeAdd(loadedRefund, msg.value);
495   }
496 
497   /**
498    * Investors can claim refund.
499    *
500    * Note that any refunds from proxy buyers should be handled separately,
501    * and not through this contract.
502    */
503   function refund() public inState(State.Refunding) {
504     uint256 weiValue = investedAmountOf[msg.sender];
505     if (weiValue == 0) throw;
506     investedAmountOf[msg.sender] = 0;
507     weiRefunded = safeAdd(weiRefunded, weiValue);
508     Refund(msg.sender, weiValue);
509     if (!msg.sender.send(weiValue)) throw;
510   }
511 
512   /**
513    * @return true if the crowdsale has raised enough money to be a successful.
514    */
515   function isMinimumGoalReached() public constant returns (bool reached) {
516     return weiRaised >= minimumFundingGoal;
517   }
518 
519   /**
520    * Check if the contract relationship looks good.
521    */
522   function isFinalizerSane() public constant returns (bool sane) {
523     return finalizeAgent.isSane();
524   }
525 
526   /**
527    * Check if the contract relationship looks good.
528    */
529   function isPricingSane() public constant returns (bool sane) {
530     return pricingStrategy.isSane(address(this));
531   }
532 
533   /**
534    * Crowdfund state machine management.
535    *
536    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
537    */
538   function getState() public constant returns (State) {
539     if(finalized) return State.Finalized;
540     else if (address(finalizeAgent) == 0) return State.Preparing;
541     else if (!finalizeAgent.isSane()) return State.Preparing;
542     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
543     else if (block.timestamp < startsAt) return State.PreFunding;
544     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
545     else if (isMinimumGoalReached()) return State.Success;
546     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
547     else return State.Failure;
548   }
549 
550   /** This is for manual testing of multisig wallet interaction */
551   function setOwnerTestValue(uint val) onlyOwner {
552     ownerTestValue = val;
553   }
554 
555   /** Interface marker. */
556   function isCrowdsale() public constant returns (bool) {
557     return true;
558   }
559 
560   //
561   // Modifiers
562   //
563 
564   /** Modified allowing execution only if the crowdsale is currently running.  */
565   modifier inState(State state) {
566     if(getState() != state) throw;
567     _;
568   }
569 
570 
571   //
572   // Abstract functions
573   //
574 
575   /**
576    * Check if the current invested breaks our cap rules.
577    *
578    *
579    * The child contract must define their own cap setting rules.
580    * We allow a lot of flexibility through different capping strategies (ETH, token count)
581    * Called from invest().
582    *
583    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
584    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
585    * @param weiRaisedTotal What would be our total raised balance after this transaction
586    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
587    *
588    * @return true if taking this investment would break our cap rules
589    */
590   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
591 
592   /**
593    * Check if the current crowdsale is full and we can no longer sell any tokens.
594    */
595   function isCrowdsaleFull() public constant returns (bool);
596 
597   /**
598    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
599    */
600   function assignTokens(address receiver, uint tokenAmount) private;
601 }
602 
603 /**
604  * Fixed crowdsale pricing - everybody gets the same price.
605  */
606 contract WWAMPricingStrategy is PricingStrategy, Ownable, SafeMath {
607 
608   uint round1BeginsAt;
609   uint round2BeginsAt;
610   uint finalRoundBeginsAt;
611   uint baseRate = 5000000000000; //wei per WWAM
612   
613   enum CurrentRound { Round1, Round2, Final }
614   
615   function WWAMPricingStrategy(uint _round1BeginsAt, uint _round2BeginsAt, uint _finalRoundBeginsAt) {
616 	round1BeginsAt = _round1BeginsAt;
617 	round2BeginsAt = _round2BeginsAt;
618 	finalRoundBeginsAt = _finalRoundBeginsAt;
619   }
620   
621   function getCurrentRound() public returns (CurrentRound){
622 	  if (now < round2BeginsAt)
623 		  return CurrentRound.Round1;
624 	  else if (now < finalRoundBeginsAt)
625 		  return CurrentRound.Round2;
626 	  return CurrentRound.Final;
627   }
628   
629   function tokensToWei(uint tokens) public constant returns (uint) {
630 	return safeMul(tokens, baseRate);
631   }
632   
633   /**
634    * Calculate the current price for buy in amount.
635    *
636    */
637   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
638 	//Minimum investment is 10 finney
639 	if (value < 10 finney) 
640 		return 0;
641 	//15% Bonus for Round1 investors
642 	if (getCurrentRound() == CurrentRound.Round1)
643 		return safeMul(safeDiv(safeDiv(value, baseRate), 100), 115);
644 	//10% Bonus for Round2 investors
645 	else if (getCurrentRound() == CurrentRound.Round2)
646 		return safeMul(safeDiv(safeDiv(value, baseRate), 100), 110);
647 	//Base rate for Final Round investors
648 	return value / baseRate;
649   }
650 
651 }
652 
653 
654 /**
655  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
656  *
657  * Based on code by FirstBlood:
658  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
659  */
660 contract StandardToken is ERC20, SafeMath {
661 
662   /* Token supply got increased and a new owner received these tokens */
663   event Minted(address receiver, uint amount);
664 
665   /* Actual balances of token holders */
666   mapping(address => uint) balances;
667 
668   /* approve() allowances */
669   mapping (address => mapping (address => uint)) allowed;
670 
671   /* Interface declaration */
672   function isToken() public constant returns (bool weAre) {
673     return true;
674   }
675 
676   function transfer(address _to, uint _value) returns (bool success) {
677     balances[msg.sender] = safeSub(balances[msg.sender], _value);
678     balances[_to] = safeAdd(balances[_to], _value);
679     Transfer(msg.sender, _to, _value);
680     return true;
681   }
682 
683   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
684     uint _allowance = allowed[_from][msg.sender];
685 
686     balances[_to] = safeAdd(balances[_to], _value);
687     balances[_from] = safeSub(balances[_from], _value);
688     allowed[_from][msg.sender] = safeSub(_allowance, _value);
689     Transfer(_from, _to, _value);
690     return true;
691   }
692 
693   function balanceOf(address _owner) constant returns (uint balance) {
694     return balances[_owner];
695   }
696 
697   function approve(address _spender, uint _value) returns (bool success) {
698 
699     // To change the approve amount you first have to reduce the addresses`
700     //  allowance to zero by calling `approve(_spender, 0)` if it is not
701     //  already 0 to mitigate the race condition described here:
702     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
703     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
704 
705     allowed[msg.sender][_spender] = _value;
706     Approval(msg.sender, _spender, _value);
707     return true;
708   }
709 
710   function allowance(address _owner, address _spender) constant returns (uint remaining) {
711     return allowed[_owner][_spender];
712   }
713 
714 }
715 
716 /**
717  * A token that can be revoked before then end of the crowdsale.
718  */
719 contract WWAMBountyToken is StandardToken, Ownable {
720 
721   /** List of agents that are allowed to revoke tokens */
722   mapping (address => bool) public bountyAgents;
723   
724   event BountyAgentChanged(address addr, bool state  );
725   
726   /*
727   * Function to revoke tokens in case the terms and conditions of the bounty campaign are violated by an user after tokens were assigned
728   */
729   function revokeTokens(address receiver, uint tokenAmount) onlyBountyAgent {
730       if (balances[receiver] >= tokenAmount) {
731 	    totalSupply = safeSub(totalSupply, tokenAmount);
732 	    balances[receiver] = safeSub(balances[receiver], tokenAmount);
733       }
734   }
735   
736    /**
737    * Owner can allow a crowdsale contract to revoke tokens.
738    */
739   function setBountyAgent(address addr, bool state) onlyOwner public {
740     bountyAgents[addr] = state;
741     BountyAgentChanged(addr, state);
742   }
743   
744   modifier onlyBountyAgent() {
745     // Only crowdsale contracts are allowed to revoke tokens
746     if(!bountyAgents[msg.sender]) {
747         throw;
748     }
749     _;
750   }
751   
752 }
753 
754 /**
755  * A token that can increase its supply by another contract.
756  *
757  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
758  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
759  *
760  */
761 contract MintableToken is StandardToken, Ownable {
762 
763 
764   bool public mintingFinished = false;
765 
766   /** List of agents that are allowed to create new tokens */
767   mapping (address => bool) public mintAgents;
768 
769   event MintingAgentChanged(address addr, bool state  );
770 
771   /**
772    * Create new tokens and allocate them to an address..
773    *
774    * Only callably by a crowdsale contract (mint agent).
775    */
776   function mint(address receiver, uint amount) onlyMintAgent canMint public {
777     totalSupply = safeAdd(totalSupply, amount);
778     balances[receiver] = safeAdd(balances[receiver], amount);
779 
780     // This will make the mint transaction appear in EtherScan.io
781     // We can remove this after there is a standardized minting event
782     Transfer(0, receiver, amount);
783   }
784 
785   /**
786    * Owner can allow a crowdsale contract to mint new tokens.
787    */
788   function setMintAgent(address addr, bool state) onlyOwner canMint public {
789     mintAgents[addr] = state;
790     MintingAgentChanged(addr, state);
791   }
792 
793   modifier onlyMintAgent() {
794     // Only crowdsale contracts are allowed to mint new tokens
795     if(!mintAgents[msg.sender]) {
796         throw;
797     }
798     _;
799   }
800 
801   /** Make sure we are not done yet. */
802   modifier canMint() {
803     if(mintingFinished) throw;
804     _;
805   }
806 }
807 
808 
809 contract WWAMCrowdsale is Crowdsale {
810   
811   /* The maximum amount the crowdsale can raise */
812   uint investmentCapInWei = 500000000000000000000000; // 500000 ETH 
813   
814   /* The number of tokens awarded for bounty campaign */
815   uint public bountyTokens = 0;
816   
817   /* Public list of bounty rewards */
818   mapping (address => uint256) public bountyRewards;
819 	
820   function WWAMCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end)
821     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, 500000000000000000000) { //Minimum funding goal of 500 ETH
822   }
823 
824    /**
825    * Function allowing to credit tokens to participant in the bounty campaign
826    */
827   function assignBountyTokens(address receiver, uint tokenAmount) onlyOwner {
828 	  uint bountyWeiAmount = WWAMPricingStrategy(pricingStrategy).tokensToWei(tokenAmount);
829 	  uint totalBountyWeiAmount = WWAMPricingStrategy(pricingStrategy).tokensToWei(bountyTokens);
830 	  
831 	  //Making sure we do not exceed the 1% of maximum investment allocated for the bounty campaign
832 	  if (safeAdd(bountyWeiAmount, totalBountyWeiAmount) >= (investmentCapInWei / 100))
833 		  throw;
834 	  
835 	  bountyRewards[receiver] = safeAdd(bountyRewards[receiver], tokenAmount);
836 	  bountyTokens = safeAdd(bountyTokens, tokenAmount);
837 	  
838 	  assignTokens(receiver, tokenAmount);
839   }
840   
841   /*
842   * Function to revoke tokens in case the terms and conditions of the bounty campaign are violated by an user after tokens were assigned
843   */
844   function revokeBountyTokens(address receiver, uint tokenAmount) onlyOwner {
845 	  //Checking that we can only revoke tokens of a bounty campaign participant. Also making sure that we do not end up with a negative blaance
846 	  if (bountyRewards[receiver] < tokenAmount)
847 		  throw;
848 	  bountyTokens = safeSub(bountyTokens, tokenAmount);
849 	  bountyRewards[receiver] = safeSub(bountyRewards[receiver], tokenAmount);
850 	  
851 	  WWAMBountyToken bountyToken = WWAMBountyToken(token);
852 	  bountyToken.revokeTokens(receiver, tokenAmount);
853   }
854   
855   /**
856    * Checking that we do not exceed the investment cap.
857    */
858   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool) {
859     return weiRaisedTotal > investmentCapInWei;
860   }
861 
862   /**
863    * Condition is the same as above
864    */
865   function isCrowdsaleFull() public constant returns (bool) {
866     return weiRaised >= investmentCapInWei;
867   }
868 
869   /**
870    * Creating new tokens for the investor and assigning them
871    */
872   function assignTokens(address receiver, uint tokenAmount) private {
873     MintableToken mintableToken = MintableToken(token);
874     mintableToken.mint(receiver, tokenAmount);
875   }
876 
877 }