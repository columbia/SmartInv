1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 /**
19  * Safe unsigned safe math.
20  *
21  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
22  *
23  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
24  *
25  * Maintained here until merged to mainline zeppelin-solidity.
26  *
27  */
28 library SafeMathLib {
29 
30   function times(uint a, uint b) returns (uint) {
31     uint c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function minus(uint a, uint b) returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function plus(uint a, uint b) returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function assert(bool assertion) private {
48     if (!assertion) throw;
49   }
50 }
51 
52 
53 
54 
55 /*
56  * Ownable
57  *
58  * Base contract with an owner.
59  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
60  */
61 contract Ownable {
62   address public owner;
63 
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68   modifier onlyOwner() {
69     if (msg.sender != owner) {
70       throw;
71     }
72     _;
73   }
74 
75   function transferOwnership(address newOwner) onlyOwner {
76     if (newOwner != address(0)) {
77       owner = newOwner;
78     }
79   }
80 
81 }
82 
83 
84 /*
85  * Haltable
86  *
87  * Abstract contract that allows children to implement an
88  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
89  *
90  *
91  * Originally envisioned in FirstBlood ICO contract.
92  */
93 contract Haltable is Ownable {
94   bool public halted;
95 
96   modifier stopInEmergency {
97     if (halted) throw;
98     _;
99   }
100 
101   modifier onlyInEmergency {
102     if (!halted) throw;
103     _;
104   }
105 
106   // called by the owner on emergency, triggers stopped state
107   function halt() external onlyOwner {
108     halted = true;
109   }
110 
111   // called by the owner on end of emergency, returns to normal state
112   function unhalt() external onlyOwner onlyInEmergency {
113     halted = false;
114   }
115 
116 }
117 
118 
119 /**
120  * Interface for defining crowdsale pricing.
121  */
122 contract PricingStrategy {
123 
124   /** Interface declaration. */
125   function isPricingStrategy() public constant returns (bool) {
126     return true;
127   }
128 
129   /** Self check if all references are correctly set.
130    *
131    * Checks that pricing strategy matches crowdsale parameters.
132    */
133   function isSane(address crowdsale) public constant returns (bool) {
134     return true;
135   }
136 
137   /**
138    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
139    */
140   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender) public constant returns (uint tokenAmount);
141 }
142 
143 
144 /**
145  * Finalize agent defines what happens at the end of succeseful crowdsale.
146  *
147  * - Allocate tokens for founders, bounties and community
148  * - Make tokens transferable
149  * - etc.
150  */
151 contract FinalizeAgent {
152 
153   function isFinalizeAgent() public constant returns(bool) {
154     return true;
155   }
156 
157   /** Return true if we can run finalizeCrowdsale() properly.
158    *
159    * This is a safety check function that doesn't allow crowdsale to begin
160    * unless the finalizer has been set up properly.
161    */
162   function isSane() public constant returns (bool);
163 
164   /** Called once by crowdsale finalize() if the sale was success. */
165   function finalizeCrowdsale();
166 
167 }
168 
169 
170 
171 /**
172  * Abstract base contract for token sales.
173  *
174  * Handle
175  * - start and end dates
176  * - accepting investments
177  * - minimum funding goal and refund
178  * - various statistics during the crowdfund
179  * - different pricing strategies
180  *
181  */
182 contract Crowdsale is Haltable {
183 
184   using SafeMathLib for uint;
185 
186   /* The token we are selling */
187   ERC20 public token;
188 
189   /* How we are going to price our offering */
190   PricingStrategy public pricingStrategy;
191 
192   /* Post-success callback */
193   FinalizeAgent public finalizeAgent;
194 
195   /* tokens will be transfered from this address */
196   address public multisigWallet;
197 
198   /* if the funding goal is not reached, investors may withdraw their funds */
199   uint public minimumFundingGoal;
200 
201   /* the UNIX timestamp start date of the crowdsale */
202   uint public startsAt;
203 
204   /* the UNIX timestamp end date of the crowdsale */
205   uint public endsAt;
206 
207   /* the number of tokens already sold through this contract*/
208   uint public tokensSold = 0;
209 
210   /* How many wei of funding we have raised */
211   uint public weiRaised = 0;
212 
213   /* How many distinct addresses have invested */
214   uint public investorCount = 0;
215 
216   /* How much wei we have returned back to the contract after a failed crowdfund. */
217   uint public loadedRefund = 0;
218 
219   /* How much wei we have given back to investors.*/
220   uint public weiRefunded = 0;
221 
222   /* Has this crowdsale been finalized */
223   bool public finalized;
224 
225   /** How much ETH each address has invested to this crowdsale */
226   mapping (address => uint256) public investedAmountOf;
227 
228   /** How much tokens this crowdsale has credited for each investor address */
229   mapping (address => uint256) public tokenAmountOf;
230 
231   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
232   uint public ownerTestValue;
233 
234   /** State machine
235    *
236    * - Preparing: All contract initialization calls and variables have not been set yet
237    * - Prefunding: We have not passed start time yet
238    * - Funding: Active crowdsale
239    * - Success: Minimum funding goal reached
240    * - Failure: Minimum funding goal not reached before ending time
241    * - Finalized: The finalized has been called and succesfully executed
242    * - Refunding: Refunds are loaded on the contract for reclaim.
243    */
244   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
245 
246   event Invested(address investor, uint weiAmount, uint tokenAmount);
247   event Refund(address investor, uint weiAmount);
248 
249   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
250 
251     owner = msg.sender;
252 
253     token = ERC20(_token);
254 
255     setPricingStrategy(_pricingStrategy);
256 
257     multisigWallet = _multisigWallet;
258     if(multisigWallet == 0) {
259         throw;
260     }
261 
262     if(_start == 0) {
263         throw;
264     }
265 
266     startsAt = _start;
267 
268     if(_end == 0) {
269         throw;
270     }
271 
272     endsAt = _end;
273 
274     // Don't mess the dates
275     if(startsAt >= endsAt) {
276         throw;
277     }
278 
279     // Minimum funding goal can be zero
280     minimumFundingGoal = _minimumFundingGoal;
281   }
282 
283   /**
284    * Don't expect to just send in money and get tokens.
285    */
286   function() payable {
287     throw;
288   }
289 
290   /**
291    * Make an investment.
292    *
293    * Crowdsale must be running for one to invest.
294    * We must have not pressed the emergency brake.
295    *
296    *
297    */
298   function invest(address receiver) inState(State.Funding) stopInEmergency payable public {
299 
300     uint weiAmount = msg.value;
301     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender);
302 
303     if(tokenAmount == 0) {
304       // Dust transaction
305       throw;
306     }
307 
308     if(investedAmountOf[receiver] == 0) {
309        // A new investor
310        investorCount++;
311     }
312 
313     // Update investor
314     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
315     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
316 
317     // Update totals
318     weiRaised = weiRaised.plus(weiAmount);
319     tokensSold = tokensSold.plus(tokenAmount);
320 
321     // Check that we did not bust the cap
322     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
323       throw;
324     }
325 
326     assignTokens(receiver, tokenAmount);
327 
328     // Pocket the money
329     if(!multisigWallet.send(weiAmount)) throw;
330 
331     // Tell us invest was success
332     Invested(receiver, weiAmount, tokenAmount);
333   }
334 
335   /**
336    * The basic entry point to participate the crowdsale process.
337    *
338    * Pay for funding, get invested tokens back in the sender address.
339    */
340   function buy() public payable {
341     invest(msg.sender);
342   }
343 
344   /**
345    * Finalize a succcesful crowdsale.
346    *
347    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
348    */
349   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
350 
351     // Already finalized
352     if(finalized) {
353       throw;
354     }
355 
356     // Finalizing is optional. We only call it if we are given a finalizing agent.
357     if(address(finalizeAgent) != 0) {
358       finalizeAgent.finalizeCrowdsale();
359     }
360 
361     finalized = true;
362   }
363 
364   /**
365    * Allow to (re)set finalize agent.
366    *
367    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
368    */
369   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
370     finalizeAgent = addr;
371 
372     // Don't allow setting bad agent
373     if(!finalizeAgent.isFinalizeAgent()) {
374       throw;
375     }
376   }
377 
378   /**
379    * Allow to (re)set pricing strategy.
380    *
381    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
382    */
383   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
384     pricingStrategy = _pricingStrategy;
385 
386     // Don't allow setting bad agent
387     if(!pricingStrategy.isPricingStrategy()) {
388       throw;
389     }
390   }
391 
392 
393 
394   /**
395    * Allow load refunds back on the contract for the refunding.
396    *
397    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
398    */
399   function loadRefund() public payable inState(State.Failure) {
400     if(msg.value == 0) throw;
401     loadedRefund = loadedRefund.plus(msg.value);
402   }
403 
404   /**
405    * Investors can claim refund.
406    */
407   function refund() public inState(State.Refunding) {
408     uint256 weiValue = investedAmountOf[msg.sender];
409     if (weiValue == 0) throw;
410     investedAmountOf[msg.sender] = 0;
411     weiRefunded = weiRefunded.plus(weiValue);
412     Refund(msg.sender, weiValue);
413     if (!msg.sender.send(weiValue)) throw;
414   }
415 
416   /**
417    * @return true if the crowdsale has raised enough money to be a succes
418    */
419   function isMinimumGoalReached() public constant returns (bool reached) {
420     return weiRaised >= minimumFundingGoal;
421   }
422 
423   /**
424    * Crowdfund state machine management.
425    *
426    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
427    */
428   function getState() public constant returns (State) {
429     if(finalized) return State.Finalized;
430     else if (address(finalizeAgent) == 0) return State.Preparing;
431     else if (!finalizeAgent.isSane()) return State.Preparing;
432     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
433     else if (block.timestamp < startsAt) return State.PreFunding;
434     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
435     else if (isMinimumGoalReached()) return State.Success;
436     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
437     else return State.Failure;
438   }
439 
440   /** This is for manual testing of multisig wallet interaction */
441   function setOwnerTestValue(uint val) onlyOwner {
442     ownerTestValue = val;
443   }
444 
445   //
446   // Modifiers
447   //
448 
449   /** Modified allowing execution only if the crowdsale is currently running.  */
450   modifier inState(State state) {
451     if(getState() != state) throw;
452     _;
453   }
454 
455 
456   //
457   // Abstract functions
458   //
459 
460   /**
461    * Check if the current invested breaks our cap rules.
462    *
463    *
464    * The child contract must define their own cap setting rules.
465    * We allow a lot of flexibility through different capping strategies (ETH, token count)
466    * Called from invest().
467    *
468    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
469    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
470    * @param weiRaisedTotal What would be our total raised balance after this transaction
471    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
472    *
473    * @return true if taking this investment would break our cap rules
474    */
475   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
476 
477   /**
478    * Check if the current crowdsale is full and we can no longer sell any tokens.
479    */
480   function isCrowdsaleFull() public constant returns (bool);
481 
482   /**
483    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
484    */
485   function assignTokens(address receiver, uint tokenAmount) private;
486 }
487 
488 
489 
490 
491 
492 
493 
494 
495 /**
496  * Math operations with safety checks
497  */
498 contract SafeMath {
499   function safeMul(uint a, uint b) internal returns (uint) {
500     uint c = a * b;
501     assert(a == 0 || c / a == b);
502     return c;
503   }
504 
505   function safeDiv(uint a, uint b) internal returns (uint) {
506     assert(b > 0);
507     uint c = a / b;
508     assert(a == b * c + a % b);
509     return c;
510   }
511 
512   function safeSub(uint a, uint b) internal returns (uint) {
513     assert(b <= a);
514     return a - b;
515   }
516 
517   function safeAdd(uint a, uint b) internal returns (uint) {
518     uint c = a + b;
519     assert(c>=a && c>=b);
520     return c;
521   }
522 
523   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
524     return a >= b ? a : b;
525   }
526 
527   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
528     return a < b ? a : b;
529   }
530 
531   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
532     return a >= b ? a : b;
533   }
534 
535   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
536     return a < b ? a : b;
537   }
538 
539   function assert(bool assertion) internal {
540     if (!assertion) {
541       throw;
542     }
543   }
544 }
545 
546 
547 
548 /**
549  * Standard ERC20 token
550  *
551  * https://github.com/ethereum/EIPs/issues/20
552  * Based on code by FirstBlood:
553  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
554  */
555 contract StandardToken is ERC20, SafeMath {
556 
557   mapping(address => uint) balances;
558   mapping (address => mapping (address => uint)) allowed;
559 
560   function transfer(address _to, uint _value) returns (bool success) {
561     balances[msg.sender] = safeSub(balances[msg.sender], _value);
562     balances[_to] = safeAdd(balances[_to], _value);
563     Transfer(msg.sender, _to, _value);
564     return true;
565   }
566 
567   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
568     var _allowance = allowed[_from][msg.sender];
569 
570     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
571     // if (_value > _allowance) throw;
572 
573     balances[_to] = safeAdd(balances[_to], _value);
574     balances[_from] = safeSub(balances[_from], _value);
575     allowed[_from][msg.sender] = safeSub(_allowance, _value);
576     Transfer(_from, _to, _value);
577     return true;
578   }
579 
580   function balanceOf(address _owner) constant returns (uint balance) {
581     return balances[_owner];
582   }
583 
584   function approve(address _spender, uint _value) returns (bool success) {
585     allowed[msg.sender][_spender] = _value;
586     Approval(msg.sender, _spender, _value);
587     return true;
588   }
589 
590   function allowance(address _owner, address _spender) constant returns (uint remaining) {
591     return allowed[_owner][_spender];
592   }
593 
594 }
595 
596 
597 
598 
599 /**
600  * A token that can increase its supply by another contract.
601  *
602  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
603  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
604  *
605  */
606 contract MintableToken is StandardToken, Ownable {
607 
608   using SafeMathLib for uint;
609 
610   bool public mintingFinished = false;
611 
612   /** List of agents that are allowed to create new tokens */
613   mapping (address => bool) public mintAgents;
614 
615   /**
616    * Create new tokens and allocate them to an address..
617    *
618    * Only callably by a crowdsale contract (mint agent).
619    */
620   function mint(address receiver, uint amount) onlyMintAgent canMint public {
621     totalSupply = totalSupply.plus(amount);
622     balances[receiver] = balances[receiver].plus(amount);
623     Transfer(0, receiver, amount);
624   }
625 
626   /**
627    * Owner can allow a crowdsale contract to mint new tokens.
628    */
629   function setMintAgent(address addr, bool state) onlyOwner canMint public {
630     mintAgents[addr] = state;
631   }
632 
633   modifier onlyMintAgent() {
634     // Only crowdsale contracts are allowed to mint new tokens
635     if(!mintAgents[msg.sender]) {
636         throw;
637     }
638     _;
639   }
640 
641   /** Make sure we are not done yet. */
642   modifier canMint() {
643     if(mintingFinished) throw;
644     _;
645   }
646 }
647 
648 
649 /**
650  * ICO crowdsale contract that is capped by amout of tokens.
651  *
652  * - Tokens are dynamically created during the crowdsale
653  *
654  *
655  */
656 contract MintedTokenCappedCrowdsale is Crowdsale {
657 
658   /* Maximum amount of tokens this crowdsale can sell. */
659   uint public maximumSellableTokens;
660 
661   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
662     maximumSellableTokens = _maximumSellableTokens;
663   }
664 
665   /**
666    * Called from invest() to confirm if the curret investment does not break our cap rule.
667    */
668   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
669     return tokensSoldTotal > maximumSellableTokens;
670   }
671 
672   function isCrowdsaleFull() public constant returns (bool) {
673     return tokensSold >= maximumSellableTokens;
674   }
675 
676   /**
677    * Dynamically create tokens and assign them to the investor.
678    */
679   function assignTokens(address receiver, uint tokenAmount) private {
680     MintableToken mintableToken = MintableToken(token);
681     mintableToken.mint(receiver, tokenAmount);
682   }
683 }
684 
685 
686 
687 /**
688  * A crowdsale that retains the previous token, but changes some parameters.
689  *
690  * Investor data can be manually fed in.
691  *
692  * Mostly useful as a hot fix.
693  *
694  */
695 contract RelaunchedCrowdsale is MintedTokenCappedCrowdsale {
696 
697   function RelaunchedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) MintedTokenCappedCrowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _maximumSellableTokens) {
698 
699   }
700 
701   /**
702    * Rebuild invest data back to the crowdsale.
703    */
704   function setInvestorData(address _addr, uint _weiAmount, uint _tokenAmount) onlyOwner public {
705     investedAmountOf[_addr] = _weiAmount;
706     tokenAmountOf[_addr] = _tokenAmount;
707     weiRaised += _weiAmount;
708     tokensSold += _tokenAmount;
709     investorCount++;
710     Invested(_addr, _weiAmount, _tokenAmount);
711   }
712 
713 
714 }