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
387    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
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
412 
413 
414   /**
415    * Allow load refunds back on the contract for the refunding.
416    *
417    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
418    */
419   function loadRefund() public payable inState(State.Failure) {
420     if(msg.value == 0) throw;
421     loadedRefund = loadedRefund.plus(msg.value);
422   }
423 
424   /**
425    * Investors can claim refund.
426    */
427   function refund() public inState(State.Refunding) {
428     uint256 weiValue = investedAmountOf[msg.sender];
429     if (weiValue == 0) throw;
430     investedAmountOf[msg.sender] = 0;
431     weiRefunded = weiRefunded.plus(weiValue);
432     Refund(msg.sender, weiValue);
433     if (!msg.sender.send(weiValue)) throw;
434   }
435 
436   /**
437    * @return true if the crowdsale has raised enough money to be a succes
438    */
439   function isMinimumGoalReached() public constant returns (bool reached) {
440     return weiRaised >= minimumFundingGoal;
441   }
442 
443   /**
444    * Crowdfund state machine management.
445    *
446    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
447    */
448   function getState() public constant returns (State) {
449     if(finalized) return State.Finalized;
450     else if (address(finalizeAgent) == 0) return State.Preparing;
451     else if (!finalizeAgent.isSane()) return State.Preparing;
452     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
453     else if (block.timestamp < startsAt) return State.PreFunding;
454     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
455     else if (isMinimumGoalReached()) return State.Success;
456     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
457     else return State.Failure;
458   }
459 
460   /** This is for manual testing of multisig wallet interaction */
461   function setOwnerTestValue(uint val) onlyOwner {
462     ownerTestValue = val;
463   }
464 
465   //
466   // Modifiers
467   //
468 
469   /** Modified allowing execution only if the crowdsale is currently running.  */
470   modifier inState(State state) {
471     if(getState() != state) throw;
472     _;
473   }
474 
475 
476   //
477   // Abstract functions
478   //
479 
480   /**
481    * Check if the current invested breaks our cap rules.
482    *
483    *
484    * The child contract must define their own cap setting rules.
485    * We allow a lot of flexibility through different capping strategies (ETH, token count)
486    * Called from invest().
487    *
488    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
489    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
490    * @param weiRaisedTotal What would be our total raised balance after this transaction
491    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
492    *
493    * @return true if taking this investment would break our cap rules
494    */
495   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
496 
497   /**
498    * Check if the current crowdsale is full and we can no longer sell any tokens.
499    */
500   function isCrowdsaleFull() public constant returns (bool);
501 
502   /**
503    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
504    */
505   function assignTokens(address receiver, uint tokenAmount) private;
506 }
507 
508 
509 
510 /**
511  * Collect funds from presale investors to be send to the crowdsale smart contract later.
512  *
513  * - Collect funds from pre-sale investors
514  * - Send funds to the crowdsale when it opens
515  * - Allow owner to set the crowdsale
516  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
517  *
518  */
519 contract PresaleFundCollector is Ownable {
520 
521   using SafeMathLib for uint;
522 
523   /** How many investors when can carry per a single contract */
524   uint public MAX_INVESTORS = 32;
525 
526   /** How many investors we have now */
527   uint public investorCount;
528 
529   /** Who are our investors (iterable) */
530   address[] public investors;
531 
532   /** How much they have invested */
533   mapping(address => uint) public balances;
534 
535   /** When our refund freeze is over (UNIT timestamp) */
536   uint public freezeEndsAt;
537 
538   /** What is the minimum buy in */
539   uint public weiMinimumLimit;
540 
541   /** Have we begun to move funds */
542   bool public moving;
543 
544   /** Our ICO contract where we will move the funds */
545   Crowdsale public crowdsale;
546 
547   event Invested(address investor, uint value);
548   event Refunded(address investor, uint value);
549 
550   /**
551    * Create presale contract where lock up period is given days
552    */
553   function PresaleFundCollector(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit) {
554 
555     owner = _owner;
556 
557     // Give argument
558     if(_freezeEndsAt == 0) {
559       throw;
560     }
561 
562     // Give argument
563     if(_weiMinimumLimit == 0) {
564       throw;
565     }
566 
567     weiMinimumLimit = _weiMinimumLimit;
568     freezeEndsAt = _freezeEndsAt;
569   }
570 
571   /**
572    * Participate to a presale.
573    */
574   function invest() public payable {
575 
576     // Cannot invest anymore through crowdsale when moving has begun
577     if(moving) throw;
578 
579     address investor = msg.sender;
580 
581     bool existing = balances[investor] > 0;
582 
583     balances[investor] = balances[investor].plus(msg.value);
584 
585     // Need to fulfill minimum limit
586     if(balances[investor] < weiMinimumLimit) {
587       throw;
588     }
589 
590     // This is a new investor
591     if(!existing) {
592 
593       // Limit number of investors to prevent too long loops
594       if(investorCount >= MAX_INVESTORS) throw;
595 
596       investors.push(investor);
597       investorCount++;
598     }
599 
600     Invested(investor, msg.value);
601   }
602 
603   /**
604    * Load funds to the crowdsale for a single investor.
605    */
606   function parcipateCrowdsaleInvestor(address investor) public {
607 
608     // Crowdsale not yet set
609     if(address(crowdsale) == 0) throw;
610 
611     moving = true;
612 
613     if(balances[investor] > 0) {
614       uint amount = balances[investor];
615       delete balances[investor];
616       crowdsale.invest.value(amount)(investor);
617     }
618   }
619 
620   /**
621    * Load funds to the crowdsale for all investor.
622    *
623    */
624   function parcipateCrowdsaleAll() public {
625 
626     // We might hit a max gas limit in this loop,
627     // and in this case you can simply call parcipateCrowdsaleInvestor() for all investors
628     for(uint i=0; i<investors.length; i++) {
629        parcipateCrowdsaleInvestor(investors[i]);
630     }
631   }
632 
633   /**
634    * ICO never happened. Allow refund.
635    */
636   function refund() {
637 
638     // Trying to ask refund too soon
639     if(now < freezeEndsAt) throw;
640 
641     // We have started to move funds
642     moving = true;
643 
644     address investor = msg.sender;
645     if(balances[investor] == 0) throw;
646     uint amount = balances[investor];
647     delete balances[investor];
648     if(!investor.send(amount)) throw;
649     Refunded(investor, amount);
650   }
651 
652   /**
653    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
654    */
655   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
656      crowdsale = _crowdsale;
657   }
658 
659   /** Explicitly call function from your wallet. */
660   function() payable {
661     throw;
662   }
663 }