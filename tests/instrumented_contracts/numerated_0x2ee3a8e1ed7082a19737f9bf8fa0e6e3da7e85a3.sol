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
127   function calculatePrice(uint value, uint tokensSold, uint weiRaised) public constant returns (uint tokenAmount);
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
144   /** Called once by crowdsale finalize() if the sale was success. */
145   function finalizeCrowdsale();
146 
147 }
148 
149 
150 
151 /**
152  * Abstract base contract for token sales.
153  *
154  * Handle
155  * - start and end dates
156  * - accepting investments
157  * - minimum funding goal and refund
158  * - various statistics during the crowdfund
159  * - different pricing strategies
160  *
161  */
162 contract Crowdsale is Haltable {
163 
164   using SafeMathLib for uint;
165 
166   /* The token we are selling */
167   ERC20 public token;
168 
169   /* How we are going to price our offering */
170   PricingStrategy public pricingStrategy;
171 
172   /* Post-success callback */
173   FinalizeAgent public finalizeAgent;
174 
175   /* tokens will be transfered from this address */
176   address public multisigWallet;
177 
178   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
179   address public beneficiary;
180 
181   /* if the funding goal is not reached, investors may withdraw their funds */
182   uint public minimumFundingGoal;
183 
184   /* the UNIX timestamp start date of the crowdsale */
185   uint public startsAt;
186 
187   /* the UNIX timestamp end date of the crowdsale */
188   uint public endsAt;
189 
190   /* the number of tokens already sold through this contract*/
191   uint public tokensSold = 0;
192 
193   /* How many wei of funding we have raised */
194   uint public weiRaised = 0;
195 
196   /* How many distinct addresses have invested */
197   uint public investorCount = 0;
198 
199   /* How much wei we have returned back to the contract after a failed crowdfund. */
200   uint public loadedRefund = 0;
201 
202   /* How much wei we have given back to investors.*/
203   uint public weiRefunded = 0;
204 
205   /* Has this crowdsale been finalized */
206   bool public finalized;
207 
208   /** How much ETH each address has invested to this crowdsale */
209   mapping (address => uint256) public investedAmountOf;
210 
211   /** How much tokens this crowdsale has credited for each investor address */
212   mapping (address => uint256) public tokenAmountOf;
213 
214   /** State machine
215    *
216    * - Prefunding: We have not started yet
217    * - Funding: Active crowdsale
218    * - Success: Minimum funding goal reached
219    * - Failure: Minimum funding goal not reached before ending time
220    * - Finalized: The finalized has been called and succesfully executed
221    * - Refunding: Refunds are loaded on the contract for reclaim.
222    */
223   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
224 
225   event Invested(address investor, uint weiAmount, uint tokenAmount);
226   event Refund(address investor, uint weiAmount);
227 
228   function Crowdsale(address _token, address _pricingStrategy, address _multisigWallet, address _beneficiary, uint _start, uint _end, uint _minimumFundingGoal) {
229 
230     owner = msg.sender;
231 
232     token = ERC20(_token);
233 
234     pricingStrategy = PricingStrategy(_pricingStrategy);
235 
236     multisigWallet = _multisigWallet;
237     if(multisigWallet == 0) {
238         throw;
239     }
240 
241     // TODO: remove beneficiary from the base class
242     beneficiary = _beneficiary;
243     if(beneficiary == 0) {
244         throw;
245     }
246 
247     if(_start == 0) {
248         throw;
249     }
250 
251     startsAt = _start;
252 
253     if(_end == 0) {
254         throw;
255     }
256 
257     endsAt = _end;
258 
259     // Don't mess the dates
260     if(startsAt >= endsAt) {
261         throw;
262     }
263 
264     // Minimum funding goal can be zero
265     minimumFundingGoal = _minimumFundingGoal;
266   }
267 
268   /**
269    * Don't expect to just send in money and get tokens.
270    */
271   function() payable {
272     throw;
273   }
274 
275   /**
276    * Make an investment.
277    *
278    * Crowdsale must be running for one to invest.
279    * We must have not pressed the emergency brake.
280    *
281    *
282    */
283   function invest(address receiver) inState(State.Funding) stopInEmergency payable public {
284 
285     uint weiAmount = msg.value;
286     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold);
287 
288     if(tokenAmount == 0) {
289       // Dust transaction
290       throw;
291     }
292 
293     if(investedAmountOf[receiver] != 0) {
294        // A new investor
295        investorCount++;
296     }
297 
298     // Update investor
299     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
300     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
301 
302     // Update totals
303     weiRaised = weiRaised.plus(weiAmount);
304     tokensSold = tokensSold.plus(tokenAmount);
305 
306     // Check that we did not bust the cap
307     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
308       throw;
309     }
310 
311     assignTokens(receiver, tokenAmount);
312 
313     // Pocket the money
314     if(!multisigWallet.send(weiAmount)) throw;
315 
316     // Tell us invest was success
317     Invested(receiver, weiAmount, tokenAmount);
318   }
319 
320   /**
321    * The basic entry point to participate the crowdsale process.
322    *
323    * Pay for funding, get invested tokens back in the sender address.
324    */
325   function buy() public payable {
326     invest(msg.sender);
327   }
328 
329   /**
330    * Finalize a succcesful crowdsale.
331    *
332    * Anybody can call to trigger the end of the crowdsale.
333    *
334    * Call the contract that provides post-crowdsale actions, like releasing the tokens.
335    */
336   function finalize() public inState(State.Success) stopInEmergency {
337 
338     // Already finalized
339     if(finalized) {
340       throw;
341     }
342 
343     // Finalizing is optional. We only call it if we are given a finalizing agent.
344     if(address(finalizeAgent) != 0) {
345       finalizeAgent.finalizeCrowdsale();
346     }
347 
348     finalized = true;
349   }
350 
351   function setFinalizeAgent(FinalizeAgent addr) onlyOwner inState(State.PreFunding) {
352     finalizeAgent = addr;
353 
354     // Don't allow setting bad agent
355     if(!finalizeAgent.isFinalizeAgent()) {
356       throw;
357     }
358   }
359 
360   /**
361    * Allow load refunds back on the contract for the refunding.
362    *
363    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
364    */
365   function loadRefund() public payable inState(State.Failure) {
366     if(msg.value == 0) throw;
367     loadedRefund = loadedRefund.plus(msg.value);
368   }
369 
370   /**
371    * Investors can claim refund.
372    */
373   function refund() public inState(State.Refunding) {
374     uint256 weiValue = investedAmountOf[msg.sender];
375     if (weiValue == 0) throw;
376     investedAmountOf[msg.sender] = 0;
377     weiRefunded = weiRefunded.plus(weiValue);
378     Refund(msg.sender, weiValue);
379     if (!msg.sender.send(weiValue)) throw;
380   }
381 
382   /**
383    * @return true if the crowdsale has raised enough money to be a succes
384    */
385   function isMinimumGoalReached() public constant returns (bool reached) {
386     return weiRaised >= minimumFundingGoal;
387   }
388 
389   /**
390    * Crowdfund state machine management.
391    *
392    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
393    */
394   function getState() public constant returns (State) {
395     if(finalized) return State.Finalized;
396     else if (block.timestamp < startsAt) return State.PreFunding;
397     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
398     else if (isMinimumGoalReached()) return State.Success;
399     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
400     else return State.Failure;
401   }
402 
403   //
404   // Modifiers
405   //
406 
407   /** Modified allowing execution only if the crowdsale is currently running.  */
408   modifier inState(State state) {
409     if(getState() != state) throw;
410     _;
411   }
412 
413   //
414   // Abstract functions
415   //
416 
417   /**
418    * Check if the current invested breaks our cap rules.
419    *
420    *
421    * The child contract must define their own cap setting rules.
422    * We allow a lot of flexibility through different capping strategies (ETH, token count)
423    * Called from invest().
424    *
425    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
426    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
427    * @param weiRaisedTotal What would be our total raised balance after this transaction
428    * @param tokensSoldTotal What would be our total sold tokens countafter this transaction
429    *
430    * @return true if taking this investment would break our cap rules
431    */
432   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
433 
434   /**
435    * Check if the current crowdsale is full and we can no longer sell any tokens.
436    */
437   function isCrowdsaleFull() public constant returns (bool);
438 
439   /**
440    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
441    */
442   function assignTokens(address receiver, uint tokenAmount) private;
443 }
444 
445 
446 
447 /**
448  * Collect funds from presale investors to be send to the crowdsale smart contract later.
449  *
450  * - Collect funds from pre-sale investors
451  * - Send funds to the crowdsale when it opens
452  * - Allow owner to set the crowdsale
453  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
454  *
455  */
456 contract PresaleFundCollector is Ownable {
457 
458   using SafeMathLib for uint;
459 
460   /** How many investors when can carry per a single contract */
461   uint public MAX_INVESTORS = 32;
462 
463   /** How many investors we have now */
464   uint public investorCount;
465 
466   /** Who are our investors (iterable) */
467   address[] public investors;
468 
469   /** How much they have invested */
470   mapping(address => uint) public balances;
471 
472   /** When our refund freeze is over (UNIT timestamp) */
473   uint public freezeEndsAt;
474 
475   /** What is the minimum buy in */
476   uint public weiMinimumLimit;
477 
478   /** Have we begun to move funds */
479   bool public moving;
480 
481   /** Our ICO contract where we will move the funds */
482   Crowdsale public crowdsale;
483 
484   event Invested(address investor, uint value);
485   event Refunded(address investor, uint value);
486 
487   /**
488    * Create presale contract where lock up period is given days
489    */
490   function PresaleFundCollector(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit) {
491 
492     owner = _owner;
493 
494     // Give argument
495     if(_freezeEndsAt == 0) {
496       throw;
497     }
498 
499     // Give argument
500     if(_weiMinimumLimit == 0) {
501       throw;
502     }
503 
504     weiMinimumLimit = _weiMinimumLimit;
505     freezeEndsAt = _freezeEndsAt;
506   }
507 
508   /**
509    * Participate to a presale.
510    */
511   function invest() public payable {
512 
513     // Cannot invest anymore through crowdsale when moving has begun
514     if(moving) throw;
515 
516     address investor = msg.sender;
517 
518     bool existing = balances[investor] > 0;
519 
520     balances[investor] = balances[investor].plus(msg.value);
521 
522     // Need to fulfill minimum limit
523     if(balances[investor] < weiMinimumLimit) {
524       throw;
525     }
526 
527     // This is a new investor
528     if(!existing) {
529 
530       // Limit number of investors to prevent too long loops
531       if(investorCount >= MAX_INVESTORS) throw;
532 
533       investors.push(investor);
534       investorCount++;
535     }
536 
537     Invested(investor, msg.value);
538   }
539 
540   /**
541    * Load funds to the crowdsale for a single investor.
542    */
543   function parcipateCrowdsaleInvestor(address investor) public {
544 
545     // Crowdsale not yet set
546     if(address(crowdsale) == 0) throw;
547 
548     moving = true;
549 
550     if(balances[investor] > 0) {
551       uint amount = balances[investor];
552       delete balances[investor];
553       crowdsale.invest.value(amount)(investor);
554     }
555   }
556 
557   /**
558    * Load funds to the crowdsale for all investor.
559    *
560    */
561   function parcipateCrowdsaleAll() public {
562 
563     // We might hit a max gas limit in this loop,
564     // and in this case you can simply call parcipateCrowdsaleInvestor() for all investors
565     for(uint i=0; i<investors.length; i++) {
566        parcipateCrowdsaleInvestor(investors[i]);
567     }
568   }
569 
570   /**
571    * ICO never happened. Allow refund.
572    */
573   function refund() {
574 
575     // Trying to ask refund too soon
576     if(now < freezeEndsAt) throw;
577 
578     // We have started to move funds
579     moving = true;
580 
581     address investor = msg.sender;
582     if(balances[investor] == 0) throw;
583     uint amount = balances[investor];
584     delete balances[investor];
585     if(!investor.send(amount)) throw;
586     Refunded(investor, amount);
587   }
588 
589   /**
590    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
591    */
592   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
593      crowdsale = _crowdsale;
594   }
595 
596   /** Explicitly call function from your wallet. */
597   function() payable {
598     throw;
599   }
600 }