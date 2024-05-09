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
124   /**
125    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
126    */
127   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender) public constant returns (uint tokenAmount);
128 }
129 
130 
131 /**
132  * Finalize agent defines what happens at the end of succeseful crowdsale.
133  *
134  * - Allocate tokens for founders, bounties and community
135  * - Make tokens transferable
136  * - etc.
137  */
138 contract FinalizeAgent {
139 
140   function isFinalizeAgent() public constant returns(bool) {
141     return true;
142   }
143 
144   /** Return true if we can run finalizeCrowdsale() properly.
145    *
146    * This is a safety check function that doesn't allow crowdsale to begin
147    * unless the finalizer has been set up properly.
148    */
149   function isSane() public constant returns (bool);
150 
151   /** Called once by crowdsale finalize() if the sale was success. */
152   function finalizeCrowdsale();
153 
154 }
155 
156 
157 
158 /**
159  * Abstract base contract for token sales.
160  *
161  * Handle
162  * - start and end dates
163  * - accepting investments
164  * - minimum funding goal and refund
165  * - various statistics during the crowdfund
166  * - different pricing strategies
167  *
168  */
169 contract Crowdsale is Haltable {
170 
171   using SafeMathLib for uint;
172 
173   /* The token we are selling */
174   ERC20 public token;
175 
176   /* How we are going to price our offering */
177   PricingStrategy public pricingStrategy;
178 
179   /* Post-success callback */
180   FinalizeAgent public finalizeAgent;
181 
182   /* tokens will be transfered from this address */
183   address public multisigWallet;
184 
185   /* if the funding goal is not reached, investors may withdraw their funds */
186   uint public minimumFundingGoal;
187 
188   /* the UNIX timestamp start date of the crowdsale */
189   uint public startsAt;
190 
191   /* the UNIX timestamp end date of the crowdsale */
192   uint public endsAt;
193 
194   /* the number of tokens already sold through this contract*/
195   uint public tokensSold = 0;
196 
197   /* How many wei of funding we have raised */
198   uint public weiRaised = 0;
199 
200   /* How many distinct addresses have invested */
201   uint public investorCount = 0;
202 
203   /* How much wei we have returned back to the contract after a failed crowdfund. */
204   uint public loadedRefund = 0;
205 
206   /* How much wei we have given back to investors.*/
207   uint public weiRefunded = 0;
208 
209   /* Has this crowdsale been finalized */
210   bool public finalized;
211 
212   /** How much ETH each address has invested to this crowdsale */
213   mapping (address => uint256) public investedAmountOf;
214 
215   /** How much tokens this crowdsale has credited for each investor address */
216   mapping (address => uint256) public tokenAmountOf;
217 
218   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
219   uint public ownerTestValue;
220 
221   /** State machine
222    *
223    * - Preparing: All contract initialization calls and variables have not been set yet
224    * - Prefunding: We have not passed start time yet
225    * - Funding: Active crowdsale
226    * - Success: Minimum funding goal reached
227    * - Failure: Minimum funding goal not reached before ending time
228    * - Finalized: The finalized has been called and succesfully executed
229    * - Refunding: Refunds are loaded on the contract for reclaim.
230    */
231   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
232 
233   event Invested(address investor, uint weiAmount, uint tokenAmount);
234   event Refund(address investor, uint weiAmount);
235 
236   function Crowdsale(address _token, address _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
237 
238     owner = msg.sender;
239 
240     token = ERC20(_token);
241 
242     pricingStrategy = PricingStrategy(_pricingStrategy);
243 
244     multisigWallet = _multisigWallet;
245     if(multisigWallet == 0) {
246         throw;
247     }
248 
249     if(_start == 0) {
250         throw;
251     }
252 
253     startsAt = _start;
254 
255     if(_end == 0) {
256         throw;
257     }
258 
259     endsAt = _end;
260 
261     // Don't mess the dates
262     if(startsAt >= endsAt) {
263         throw;
264     }
265 
266     // Minimum funding goal can be zero
267     minimumFundingGoal = _minimumFundingGoal;
268   }
269 
270   /**
271    * Don't expect to just send in money and get tokens.
272    */
273   function() payable {
274     throw;
275   }
276 
277   /**
278    * Make an investment.
279    *
280    * Crowdsale must be running for one to invest.
281    * We must have not pressed the emergency brake.
282    *
283    *
284    */
285   function invest(address receiver) inState(State.Funding) stopInEmergency payable public {
286 
287     uint weiAmount = msg.value;
288     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender);
289 
290     if(tokenAmount == 0) {
291       // Dust transaction
292       throw;
293     }
294 
295     if(investedAmountOf[receiver] == 0) {
296        // A new investor
297        investorCount++;
298     }
299 
300     // Update investor
301     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
302     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
303 
304     // Update totals
305     weiRaised = weiRaised.plus(weiAmount);
306     tokensSold = tokensSold.plus(tokenAmount);
307 
308     // Check that we did not bust the cap
309     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
310       throw;
311     }
312 
313     assignTokens(receiver, tokenAmount);
314 
315     // Pocket the money
316     if(!multisigWallet.send(weiAmount)) throw;
317 
318     // Tell us invest was success
319     Invested(receiver, weiAmount, tokenAmount);
320   }
321 
322   /**
323    * The basic entry point to participate the crowdsale process.
324    *
325    * Pay for funding, get invested tokens back in the sender address.
326    */
327   function buy() public payable {
328     invest(msg.sender);
329   }
330 
331   /**
332    * Finalize a succcesful crowdsale.
333    *
334    * Anybody can call to trigger the end of the crowdsale.
335    *
336    * Call the contract that provides post-crowdsale actions, like releasing the tokens.
337    */
338   function finalize() public inState(State.Success) stopInEmergency {
339 
340     // Already finalized
341     if(finalized) {
342       throw;
343     }
344 
345     // Finalizing is optional. We only call it if we are given a finalizing agent.
346     if(address(finalizeAgent) != 0) {
347       finalizeAgent.finalizeCrowdsale();
348     }
349 
350     finalized = true;
351   }
352 
353   function setFinalizeAgent(FinalizeAgent addr) onlyOwner inState(State.Preparing) {
354     finalizeAgent = addr;
355 
356     // Don't allow setting bad agent
357     if(!finalizeAgent.isFinalizeAgent()) {
358       throw;
359     }
360   }
361 
362   /**
363    * Allow load refunds back on the contract for the refunding.
364    *
365    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
366    */
367   function loadRefund() public payable inState(State.Failure) {
368     if(msg.value == 0) throw;
369     loadedRefund = loadedRefund.plus(msg.value);
370   }
371 
372   /**
373    * Investors can claim refund.
374    */
375   function refund() public inState(State.Refunding) {
376     uint256 weiValue = investedAmountOf[msg.sender];
377     if (weiValue == 0) throw;
378     investedAmountOf[msg.sender] = 0;
379     weiRefunded = weiRefunded.plus(weiValue);
380     Refund(msg.sender, weiValue);
381     if (!msg.sender.send(weiValue)) throw;
382   }
383 
384   /**
385    * @return true if the crowdsale has raised enough money to be a succes
386    */
387   function isMinimumGoalReached() public constant returns (bool reached) {
388     return weiRaised >= minimumFundingGoal;
389   }
390 
391   /**
392    * Crowdfund state machine management.
393    *
394    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
395    */
396   function getState() public constant returns (State) {
397     if(finalized) return State.Finalized;
398     else if (address(finalizeAgent) == 0) return State.Preparing;
399     else if (!finalizeAgent.isSane()) return State.Preparing;
400     else if (block.timestamp < startsAt) return State.PreFunding;
401     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
402     else if (isMinimumGoalReached()) return State.Success;
403     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
404     else return State.Failure;
405   }
406 
407   /** This is for manual testing of multisig wallet interaction */
408   function setOwnerTestValue(uint val) onlyOwner {
409     ownerTestValue = val;
410   }
411 
412   //
413   // Modifiers
414   //
415 
416   /** Modified allowing execution only if the crowdsale is currently running.  */
417   modifier inState(State state) {
418     if(getState() != state) throw;
419     _;
420   }
421 
422 
423   //
424   // Abstract functions
425   //
426 
427   /**
428    * Check if the current invested breaks our cap rules.
429    *
430    *
431    * The child contract must define their own cap setting rules.
432    * We allow a lot of flexibility through different capping strategies (ETH, token count)
433    * Called from invest().
434    *
435    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
436    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
437    * @param weiRaisedTotal What would be our total raised balance after this transaction
438    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
439    *
440    * @return true if taking this investment would break our cap rules
441    */
442   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
443 
444   /**
445    * Check if the current crowdsale is full and we can no longer sell any tokens.
446    */
447   function isCrowdsaleFull() public constant returns (bool);
448 
449   /**
450    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
451    */
452   function assignTokens(address receiver, uint tokenAmount) private;
453 }
454 
455 
456 
457 
458 
459 
460 
461 
462 /**
463  * Math operations with safety checks
464  */
465 contract SafeMath {
466   function safeMul(uint a, uint b) internal returns (uint) {
467     uint c = a * b;
468     assert(a == 0 || c / a == b);
469     return c;
470   }
471 
472   function safeDiv(uint a, uint b) internal returns (uint) {
473     assert(b > 0);
474     uint c = a / b;
475     assert(a == b * c + a % b);
476     return c;
477   }
478 
479   function safeSub(uint a, uint b) internal returns (uint) {
480     assert(b <= a);
481     return a - b;
482   }
483 
484   function safeAdd(uint a, uint b) internal returns (uint) {
485     uint c = a + b;
486     assert(c>=a && c>=b);
487     return c;
488   }
489 
490   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
491     return a >= b ? a : b;
492   }
493 
494   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
495     return a < b ? a : b;
496   }
497 
498   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
499     return a >= b ? a : b;
500   }
501 
502   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
503     return a < b ? a : b;
504   }
505 
506   function assert(bool assertion) internal {
507     if (!assertion) {
508       throw;
509     }
510   }
511 }
512 
513 
514 
515 /**
516  * Standard ERC20 token
517  *
518  * https://github.com/ethereum/EIPs/issues/20
519  * Based on code by FirstBlood:
520  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
521  */
522 contract StandardToken is ERC20, SafeMath {
523 
524   mapping(address => uint) balances;
525   mapping (address => mapping (address => uint)) allowed;
526 
527   function transfer(address _to, uint _value) returns (bool success) {
528     balances[msg.sender] = safeSub(balances[msg.sender], _value);
529     balances[_to] = safeAdd(balances[_to], _value);
530     Transfer(msg.sender, _to, _value);
531     return true;
532   }
533 
534   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
535     var _allowance = allowed[_from][msg.sender];
536 
537     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
538     // if (_value > _allowance) throw;
539 
540     balances[_to] = safeAdd(balances[_to], _value);
541     balances[_from] = safeSub(balances[_from], _value);
542     allowed[_from][msg.sender] = safeSub(_allowance, _value);
543     Transfer(_from, _to, _value);
544     return true;
545   }
546 
547   function balanceOf(address _owner) constant returns (uint balance) {
548     return balances[_owner];
549   }
550 
551   function approve(address _spender, uint _value) returns (bool success) {
552     allowed[msg.sender][_spender] = _value;
553     Approval(msg.sender, _spender, _value);
554     return true;
555   }
556 
557   function allowance(address _owner, address _spender) constant returns (uint remaining) {
558     return allowed[_owner][_spender];
559   }
560 
561 }
562 
563 
564 
565 
566 /**
567  * A token that can increase its supply by another contract.
568  *
569  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
570  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
571  *
572  */
573 contract MintableToken is StandardToken, Ownable {
574 
575   using SafeMathLib for uint;
576 
577   bool public mintingFinished = false;
578 
579   /** List of agents that are allowed to create new tokens */
580   mapping (address => bool) public mintAgents;
581 
582   /**
583    * Create new tokens and allocate them to an address..
584    *
585    * Only callably by a crowdsale contract (mint agent).
586    */
587   function mint(address receiver, uint amount) onlyMintAgent canMint public {
588     totalSupply = totalSupply.plus(amount);
589     balances[receiver] = balances[receiver].plus(amount);
590     Transfer(0, receiver, amount);
591   }
592 
593   /**
594    * Owner can allow a crowdsale contract to mint new tokens.
595    */
596   function setMintAgent(address addr, bool state) onlyOwner canMint public {
597     mintAgents[addr] = state;
598   }
599 
600   modifier onlyMintAgent() {
601     // Only crowdsale contracts are allowed to mint new tokens
602     if(!mintAgents[msg.sender]) {
603         throw;
604     }
605     _;
606   }
607 
608   /** Make sure we are not done yet. */
609   modifier canMint() {
610     if(mintingFinished) throw;
611     _;
612   }
613 }
614 
615 
616 /**
617  * ICO crowdsale contract that is capped by amout of tokens.
618  *
619  * - Tokens are dynamically created during the crowdsale
620  *
621  *
622  */
623 contract MintedTokenCappedCrowdsale is Crowdsale {
624 
625   /* Maximum amount of tokens this crowdsale can sell. */
626   uint public maximumSellableTokens;
627 
628   function MintedTokenCappedCrowdsale(address _token, address _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
629     maximumSellableTokens = _maximumSellableTokens;
630   }
631 
632   /**
633    * Called from invest() to confirm if the curret investment does not break our cap rule.
634    */
635   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
636     return tokensSoldTotal > maximumSellableTokens;
637   }
638 
639   function isCrowdsaleFull() public constant returns (bool) {
640     return tokensSold >= maximumSellableTokens;
641   }
642 
643   /**
644    * Dynamically create tokens and assign them to the investor.
645    */
646   function assignTokens(address receiver, uint tokenAmount) private {
647     MintableToken mintableToken = MintableToken(token);
648     mintableToken.mint(receiver, tokenAmount);
649   }
650 }