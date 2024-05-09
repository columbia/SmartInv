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
200  *
201  */
202 contract Crowdsale is Haltable {
203 
204   using SafeMathLib for uint;
205 
206   /* The token we are selling */
207   FractionalERC20 public token;
208 
209   /* How we are going to price our offering */
210   PricingStrategy public pricingStrategy;
211 
212   /* Post-success callback */
213   FinalizeAgent public finalizeAgent;
214 
215   /* tokens will be transfered from this address */
216   address public multisigWallet;
217 
218   /* if the funding goal is not reached, investors may withdraw their funds */
219   uint public minimumFundingGoal;
220 
221   /* the UNIX timestamp start date of the crowdsale */
222   uint public startsAt;
223 
224   /* the UNIX timestamp end date of the crowdsale */
225   uint public endsAt;
226 
227   /* the number of tokens already sold through this contract*/
228   uint public tokensSold = 0;
229 
230   /* How many wei of funding we have raised */
231   uint public weiRaised = 0;
232 
233   /* How many distinct addresses have invested */
234   uint public investorCount = 0;
235 
236   /* How much wei we have returned back to the contract after a failed crowdfund. */
237   uint public loadedRefund = 0;
238 
239   /* How much wei we have given back to investors.*/
240   uint public weiRefunded = 0;
241 
242   /* Has this crowdsale been finalized */
243   bool public finalized;
244 
245   /** How much ETH each address has invested to this crowdsale */
246   mapping (address => uint256) public investedAmountOf;
247 
248   /** How much tokens this crowdsale has credited for each investor address */
249   mapping (address => uint256) public tokenAmountOf;
250 
251   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
252   uint public ownerTestValue;
253 
254   /** State machine
255    *
256    * - Preparing: All contract initialization calls and variables have not been set yet
257    * - Prefunding: We have not passed start time yet
258    * - Funding: Active crowdsale
259    * - Success: Minimum funding goal reached
260    * - Failure: Minimum funding goal not reached before ending time
261    * - Finalized: The finalized has been called and succesfully executed
262    * - Refunding: Refunds are loaded on the contract for reclaim.
263    */
264   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
265 
266   event Invested(address investor, uint weiAmount, uint tokenAmount);
267   event Refund(address investor, uint weiAmount);
268 
269   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
270 
271     owner = msg.sender;
272 
273     token = FractionalERC20(_token);
274 
275     setPricingStrategy(_pricingStrategy);
276 
277     multisigWallet = _multisigWallet;
278     if(multisigWallet == 0) {
279         throw;
280     }
281 
282     if(_start == 0) {
283         throw;
284     }
285 
286     startsAt = _start;
287 
288     if(_end == 0) {
289         throw;
290     }
291 
292     endsAt = _end;
293 
294     // Don't mess the dates
295     if(startsAt >= endsAt) {
296         throw;
297     }
298 
299     // Minimum funding goal can be zero
300     minimumFundingGoal = _minimumFundingGoal;
301   }
302 
303   /**
304    * Don't expect to just send in money and get tokens.
305    */
306   function() payable {
307     throw;
308   }
309 
310   /**
311    * Make an investment.
312    *
313    * Crowdsale must be running for one to invest.
314    * We must have not pressed the emergency brake.
315    *
316    *
317    */
318   function invest(address receiver) inState(State.Funding) stopInEmergency payable public {
319 
320     uint weiAmount = msg.value;
321     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
322 
323     if(tokenAmount == 0) {
324       // Dust transaction
325       throw;
326     }
327 
328     if(investedAmountOf[receiver] == 0) {
329        // A new investor
330        investorCount++;
331     }
332 
333     // Update investor
334     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
335     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
336 
337     // Update totals
338     weiRaised = weiRaised.plus(weiAmount);
339     tokensSold = tokensSold.plus(tokenAmount);
340 
341     // Check that we did not bust the cap
342     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
343       throw;
344     }
345 
346     assignTokens(receiver, tokenAmount);
347 
348     // Pocket the money
349     if(!multisigWallet.send(weiAmount)) throw;
350 
351     // Tell us invest was success
352     Invested(receiver, weiAmount, tokenAmount);
353   }
354 
355   /**
356    * The basic entry point to participate the crowdsale process.
357    *
358    * Pay for funding, get invested tokens back in the sender address.
359    */
360   function buy() public payable {
361     invest(msg.sender);
362   }
363 
364   /**
365    * Finalize a succcesful crowdsale.
366    *
367    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
368    */
369   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
370 
371     // Already finalized
372     if(finalized) {
373       throw;
374     }
375 
376     // Finalizing is optional. We only call it if we are given a finalizing agent.
377     if(address(finalizeAgent) != 0) {
378       finalizeAgent.finalizeCrowdsale();
379     }
380 
381     finalized = true;
382   }
383 
384   /**
385    * Allow to (re)set finalize agent.
386    *
387    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
388    */
389   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
390     finalizeAgent = addr;
391 
392     // Don't allow setting bad agent
393     if(!finalizeAgent.isFinalizeAgent()) {
394       throw;
395     }
396   }
397 
398   /**
399    * Allow to (re)set pricing strategy.
400    *
401    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
402    */
403   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
404     pricingStrategy = _pricingStrategy;
405 
406     // Don't allow setting bad agent
407     if(!pricingStrategy.isPricingStrategy()) {
408       throw;
409     }
410   }
411 
412   /**
413    * Allow load refunds back on the contract for the refunding.
414    *
415    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
416    */
417   function loadRefund() public payable inState(State.Failure) {
418     if(msg.value == 0) throw;
419     loadedRefund = loadedRefund.plus(msg.value);
420   }
421 
422   /**
423    * Investors can claim refund.
424    */
425   function refund() public inState(State.Refunding) {
426     uint256 weiValue = investedAmountOf[msg.sender];
427     if (weiValue == 0) throw;
428     investedAmountOf[msg.sender] = 0;
429     weiRefunded = weiRefunded.plus(weiValue);
430     Refund(msg.sender, weiValue);
431     if (!msg.sender.send(weiValue)) throw;
432   }
433 
434   /**
435    * @return true if the crowdsale has raised enough money to be a succes
436    */
437   function isMinimumGoalReached() public constant returns (bool reached) {
438     return weiRaised >= minimumFundingGoal;
439   }
440 
441   /**
442    * Crowdfund state machine management.
443    *
444    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
445    */
446   function getState() public constant returns (State) {
447     if(finalized) return State.Finalized;
448     else if (address(finalizeAgent) == 0) return State.Preparing;
449     else if (!finalizeAgent.isSane()) return State.Preparing;
450     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
451     else if (block.timestamp < startsAt) return State.PreFunding;
452     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
453     else if (isMinimumGoalReached()) return State.Success;
454     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
455     else return State.Failure;
456   }
457 
458   /** This is for manual testing of multisig wallet interaction */
459   function setOwnerTestValue(uint val) onlyOwner {
460     ownerTestValue = val;
461   }
462 
463   //
464   // Modifiers
465   //
466 
467   /** Modified allowing execution only if the crowdsale is currently running.  */
468   modifier inState(State state) {
469     if(getState() != state) throw;
470     _;
471   }
472 
473 
474   //
475   // Abstract functions
476   //
477 
478   /**
479    * Check if the current invested breaks our cap rules.
480    *
481    *
482    * The child contract must define their own cap setting rules.
483    * We allow a lot of flexibility through different capping strategies (ETH, token count)
484    * Called from invest().
485    *
486    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
487    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
488    * @param weiRaisedTotal What would be our total raised balance after this transaction
489    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
490    *
491    * @return true if taking this investment would break our cap rules
492    */
493   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
494 
495   /**
496    * Check if the current crowdsale is full and we can no longer sell any tokens.
497    */
498   function isCrowdsaleFull() public constant returns (bool);
499 
500   /**
501    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
502    */
503   function assignTokens(address receiver, uint tokenAmount) private;
504 }
505 
506 
507 
508 
509 
510 
511 
512 
513 /**
514  * Math operations with safety checks
515  */
516 contract SafeMath {
517   function safeMul(uint a, uint b) internal returns (uint) {
518     uint c = a * b;
519     assert(a == 0 || c / a == b);
520     return c;
521   }
522 
523   function safeDiv(uint a, uint b) internal returns (uint) {
524     assert(b > 0);
525     uint c = a / b;
526     assert(a == b * c + a % b);
527     return c;
528   }
529 
530   function safeSub(uint a, uint b) internal returns (uint) {
531     assert(b <= a);
532     return a - b;
533   }
534 
535   function safeAdd(uint a, uint b) internal returns (uint) {
536     uint c = a + b;
537     assert(c>=a && c>=b);
538     return c;
539   }
540 
541   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
542     return a >= b ? a : b;
543   }
544 
545   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
546     return a < b ? a : b;
547   }
548 
549   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
550     return a >= b ? a : b;
551   }
552 
553   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
554     return a < b ? a : b;
555   }
556 
557   function assert(bool assertion) internal {
558     if (!assertion) {
559       throw;
560     }
561   }
562 }
563 
564 
565 
566 /**
567  * Standard ERC20 token
568  *
569  * https://github.com/ethereum/EIPs/issues/20
570  * Based on code by FirstBlood:
571  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
572  */
573 contract StandardToken is ERC20, SafeMath {
574 
575   mapping(address => uint) balances;
576   mapping (address => mapping (address => uint)) allowed;
577 
578   function transfer(address _to, uint _value) returns (bool success) {
579     balances[msg.sender] = safeSub(balances[msg.sender], _value);
580     balances[_to] = safeAdd(balances[_to], _value);
581     Transfer(msg.sender, _to, _value);
582     return true;
583   }
584 
585   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
586     var _allowance = allowed[_from][msg.sender];
587 
588     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
589     // if (_value > _allowance) throw;
590 
591     balances[_to] = safeAdd(balances[_to], _value);
592     balances[_from] = safeSub(balances[_from], _value);
593     allowed[_from][msg.sender] = safeSub(_allowance, _value);
594     Transfer(_from, _to, _value);
595     return true;
596   }
597 
598   function balanceOf(address _owner) constant returns (uint balance) {
599     return balances[_owner];
600   }
601 
602   function approve(address _spender, uint _value) returns (bool success) {
603     allowed[msg.sender][_spender] = _value;
604     Approval(msg.sender, _spender, _value);
605     return true;
606   }
607 
608   function allowance(address _owner, address _spender) constant returns (uint remaining) {
609     return allowed[_owner][_spender];
610   }
611 
612 }
613 
614 
615 
616 
617 /**
618  * A token that can increase its supply by another contract.
619  *
620  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
621  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
622  *
623  */
624 contract MintableToken is StandardToken, Ownable {
625 
626   using SafeMathLib for uint;
627 
628   bool public mintingFinished = false;
629 
630   /** List of agents that are allowed to create new tokens */
631   mapping (address => bool) public mintAgents;
632 
633   /**
634    * Create new tokens and allocate them to an address..
635    *
636    * Only callably by a crowdsale contract (mint agent).
637    */
638   function mint(address receiver, uint amount) onlyMintAgent canMint public {
639     totalSupply = totalSupply.plus(amount);
640     balances[receiver] = balances[receiver].plus(amount);
641     Transfer(0, receiver, amount);
642   }
643 
644   /**
645    * Owner can allow a crowdsale contract to mint new tokens.
646    */
647   function setMintAgent(address addr, bool state) onlyOwner canMint public {
648     mintAgents[addr] = state;
649   }
650 
651   modifier onlyMintAgent() {
652     // Only crowdsale contracts are allowed to mint new tokens
653     if(!mintAgents[msg.sender]) {
654         throw;
655     }
656     _;
657   }
658 
659   /** Make sure we are not done yet. */
660   modifier canMint() {
661     if(mintingFinished) throw;
662     _;
663   }
664 }
665 
666 
667 /**
668  * ICO crowdsale contract that is capped by amout of tokens.
669  *
670  * - Tokens are dynamically created during the crowdsale
671  *
672  *
673  */
674 contract MintedTokenCappedCrowdsale is Crowdsale {
675 
676   /* Maximum amount of tokens this crowdsale can sell. */
677   uint public maximumSellableTokens;
678 
679   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
680     maximumSellableTokens = _maximumSellableTokens;
681   }
682 
683   /**
684    * Called from invest() to confirm if the curret investment does not break our cap rule.
685    */
686   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
687     return tokensSoldTotal > maximumSellableTokens;
688   }
689 
690   function isCrowdsaleFull() public constant returns (bool) {
691     return tokensSold >= maximumSellableTokens;
692   }
693 
694   /**
695    * Dynamically create tokens and assign them to the investor.
696    */
697   function assignTokens(address receiver, uint tokenAmount) private {
698     MintableToken mintableToken = MintableToken(token);
699     mintableToken.mint(receiver, tokenAmount);
700   }
701 }
702 
703 
704 
705 /**
706  * A crowdsale that retains the previous token, but changes some parameters.
707  *
708  * Investor data can be manually fed in.
709  *
710  * Mostly useful as a hot fix.
711  *
712  */
713 contract RelaunchedCrowdsale is MintedTokenCappedCrowdsale {
714 
715   // This transaction was restored from a previous crowdsale
716   event RestoredInvestment(address addr, uint originalTxHash);
717 
718   mapping(uint => bool) public reissuedTransactions;
719 
720   function RelaunchedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) MintedTokenCappedCrowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _maximumSellableTokens) {
721   }
722 
723   /**
724    * Check if a particular transaction has already been written.
725    */
726   function getRestoredTransactionStatus(uint _originalTxHash) public constant returns(bool) {
727     return reissuedTransactions[_originalTxHash];
728   }
729 
730   /**
731    * Rebuild the previous invest data back to the crowdsale.
732    */
733   function setInvestorData(address _addr, uint _weiAmount, uint _tokenAmount, uint _originalTxHash) onlyOwner public {
734 
735     if(investedAmountOf[_addr] == 0) {
736       investorCount++;
737     }
738 
739     investedAmountOf[_addr] += _weiAmount;
740     tokenAmountOf[_addr] += _tokenAmount;
741 
742     weiRaised += _weiAmount;
743     tokensSold += _tokenAmount;
744 
745     Invested(_addr, _weiAmount, _tokenAmount);
746     RestoredInvestment(_addr, _originalTxHash);
747   }
748 
749   /**
750    * Rebuild the previous invest data and do a token reissuance.
751    */
752   function setInvestorDataAndIssueNewToken(address _addr, uint _weiAmount, uint _tokenAmount, uint _originalTxHash) onlyOwner public {
753 
754     // This transaction has already been rebuild
755     if(reissuedTransactions[_originalTxHash]) {
756       throw;
757     }
758 
759     setInvestorData(_addr, _weiAmount, _tokenAmount, _originalTxHash);
760 
761     // Check that we did not bust the cap in the restoration process
762     if(isBreakingCap(_tokenAmount, _weiAmount, weiRaised, tokensSold)) {
763       throw;
764     }
765 
766     // Mark transaction processed
767     reissuedTransactions[_originalTxHash] = true;
768 
769     // Mint new token to give it to the original investor
770     MintableToken mintableToken = MintableToken(token);
771     mintableToken.mint(_addr, _tokenAmount);
772   }
773 
774 }