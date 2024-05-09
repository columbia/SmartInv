1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function safeDiv(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function safeSub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function safeAdd(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36 }
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 /**
49  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
50  *
51  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
52  */
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) returns (bool);
60   function approve(address spender, uint256 value) returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() {
75     owner = msg.sender;
76   }
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 }
94 /**
95  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
96  *
97  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
98  */
99 /**
100  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
101  *
102  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
103  */
104 /**
105  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
106  *
107  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
108  */
109 /*
110  * Haltable
111  *
112  * Abstract contract that allows children to implement an
113  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
114  *
115  *
116  * Originally envisioned in FirstBlood ICO contract.
117  */
118 contract Haltable is Ownable {
119   bool public halted;
120   modifier stopInEmergency {
121     if (halted) throw;
122     _;
123   }
124   modifier stopNonOwnersInEmergency {
125     if (halted && msg.sender != owner) throw;
126     _;
127   }
128   modifier onlyInEmergency {
129     if (!halted) throw;
130     _;
131   }
132   // called by the owner on emergency, triggers stopped state
133   function halt() external onlyOwner {
134     halted = true;
135   }
136   // called by the owner on end of emergency, returns to normal state
137   function unhalt() external onlyOwner onlyInEmergency {
138     halted = false;
139   }
140 }
141 /**
142  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
143  *
144  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
145  */
146 /**
147  * Interface for defining crowdsale pricing.
148  */
149 contract PricingStrategy {
150   /** Interface declaration. */
151   function isPricingStrategy() public constant returns (bool) {
152     return true;
153   }
154   /** Self check if all references are correctly set.
155    *
156    * Checks that pricing strategy matches crowdsale parameters.
157    */
158   function isSane(address crowdsale) public constant returns (bool) {
159     return true;
160   }
161   /**
162    * @dev Pricing tells if this is a presale purchase or not.
163      @param purchaser Address of the purchaser
164      @return False by default, true if a presale purchaser
165    */
166   function isPresalePurchase(address purchaser) public constant returns (bool) {
167     return false;
168   }
169   /**
170    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
171    *
172    *
173    * @param value - What is the value of the transaction send in as wei
174    * @param tokensSold - how much tokens have been sold this far
175    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
176    * @param msgSender - who is the investor of this transaction
177    * @param decimals - how many decimal units the token has
178    * @return Amount of tokens the investor receives
179    */
180   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
181 }
182 /**
183  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
184  *
185  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
186  */
187 /**
188  * Finalize agent defines what happens at the end of succeseful crowdsale.
189  *
190  * - Allocate tokens for founders, bounties and community
191  * - Make tokens transferable
192  * - etc.
193  */
194 contract FinalizeAgent {
195   function isFinalizeAgent() public constant returns(bool) {
196     return true;
197   }
198   /** Return true if we can run finalizeCrowdsale() properly.
199    *
200    * This is a safety check function that doesn't allow crowdsale to begin
201    * unless the finalizer has been set up properly.
202    */
203   function isSane() public constant returns (bool);
204   /** Called once by crowdsale finalize() if the sale was success. */
205   function finalizeCrowdsale();
206 }
207 /**
208  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
209  *
210  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
211  */
212 /**
213  * A token that defines fractional units as decimals.
214  */
215 contract FractionalERC20 is ERC20 {
216   uint public decimals;
217 }
218 /**
219  * Abstract base contract for token sales.
220  *
221  * Handle
222  * - start and end dates
223  * - accepting investments
224  * - minimum funding goal and refund
225  * - various statistics during the crowdfund
226  * - different pricing strategies
227  * - different investment policies (require server side customer id, allow only whitelisted addresses)
228  *
229  */
230 contract Crowdsale is Haltable {
231   /* Max investment count when we are still allowed to change the multisig address */
232   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
233   using SafeMathLib for uint;
234   /* The token we are selling */
235   FractionalERC20 public token;
236   /* How we are going to price our offering */
237   PricingStrategy public pricingStrategy;
238   /* Post-success callback */
239   FinalizeAgent public finalizeAgent;
240   /* tokens will be transfered from this address */
241   address public multisigWallet;
242   /* if the funding goal is not reached, investors may withdraw their funds */
243   uint public minimumFundingGoal;
244   /* the UNIX timestamp start date of the crowdsale */
245   uint public startsAt;
246   /* the UNIX timestamp end date of the crowdsale */
247   uint public endsAt;
248   /* the number of tokens already sold through this contract*/
249   uint public tokensSold = 0;
250   /* How many wei of funding we have raised */
251   uint public weiRaised = 0;
252   /* Calculate incoming funds from presale contracts and addresses */
253   uint public presaleWeiRaised = 0;
254   /* How many distinct addresses have invested */
255   uint public investorCount = 0;
256   /* How much wei we have returned back to the contract after a failed crowdfund. */
257   uint public loadedRefund = 0;
258   /* How much wei we have given back to investors.*/
259   uint public weiRefunded = 0;
260   /* Has this crowdsale been finalized */
261   bool public finalized;
262   /* Do we need to have unique contributor id for each customer */
263   bool public requireCustomerId;
264   /**
265     * Do we verify that contributor has been cleared on the server side (accredited investors only).
266     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
267     */
268   bool public requiredSignedAddress;
269   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
270   address public signerAddress;
271   /** How much ETH each address has invested to this crowdsale */
272   mapping (address => uint256) public investedAmountOf;
273   /** How much tokens this crowdsale has credited for each investor address */
274   mapping (address => uint256) public tokenAmountOf;
275   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
276   mapping (address => bool) public earlyParticipantWhitelist;
277   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
278   uint public ownerTestValue;
279   /** State machine
280    *
281    * - Preparing: All contract initialization calls and variables have not been set yet
282    * - Prefunding: We have not passed start time yet
283    * - Funding: Active crowdsale
284    * - Success: Minimum funding goal reached
285    * - Failure: Minimum funding goal not reached before ending time
286    * - Finalized: The finalized has been called and succesfully executed
287    * - Refunding: Refunds are loaded on the contract for reclaim.
288    */
289   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
290   // A new investment was made
291   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
292   // Refund was processed for a contributor
293   event Refund(address investor, uint weiAmount);
294   // The rules were changed what kind of investments we accept
295   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
296   // Address early participation whitelist status changed
297   event Whitelisted(address addr, bool status);
298   // Crowdsale end time has been changed
299   event EndsAtChanged(uint newEndsAt);
300   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
301     owner = msg.sender;
302     token = FractionalERC20(_token);
303     setPricingStrategy(_pricingStrategy);
304     multisigWallet = _multisigWallet;
305     if(multisigWallet == 0) {
306         throw;
307     }
308     if(_start == 0) {
309         throw;
310     }
311     startsAt = _start;
312     if(_end == 0) {
313         throw;
314     }
315     endsAt = _end;
316     // Don't mess the dates
317     if(startsAt >= endsAt) {
318         throw;
319     }
320     // Minimum funding goal can be zero
321     minimumFundingGoal = _minimumFundingGoal;
322   }
323   /**
324    * Don't expect to just send in money and get tokens.
325    */
326   function() payable {
327     throw;
328   }
329   /**
330    * Make an investment.
331    *
332    * Crowdsale must be running for one to invest.
333    * We must have not pressed the emergency brake.
334    *
335    * @param receiver The Ethereum address who receives the tokens
336    * @param customerId (optional) UUID v4 to track the successful payments on the server side
337    *
338    */
339   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
340     // Determine if it's a good time to accept investment from this participant
341     if(getState() == State.PreFunding) {
342       // Are we whitelisted for early deposit
343       if(!earlyParticipantWhitelist[receiver]) {
344         throw;
345       }
346     } else if(getState() == State.Funding) {
347       // Retail participants can only come in when the crowdsale is running
348       // pass
349     } else {
350       // Unwanted state
351       throw;
352     }
353     uint weiAmount = msg.value;
354     // Account presale sales separately, so that they do not count against pricing tranches
355     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
356     if(tokenAmount == 0) {
357       // Dust transaction
358       throw;
359     }
360     if(investedAmountOf[receiver] == 0) {
361        // A new investor
362        investorCount++;
363     }
364     // Update investor
365     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
366     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
367     // Update totals
368     weiRaised = weiRaised.plus(weiAmount);
369     tokensSold = tokensSold.plus(tokenAmount);
370     if(pricingStrategy.isPresalePurchase(receiver)) {
371         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
372     }
373     // Check that we did not bust the cap
374     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
375       throw;
376     }
377     assignTokens(receiver, tokenAmount);
378     // Pocket the money
379     if(!multisigWallet.send(weiAmount)) throw;
380     // Tell us invest was success
381     Invested(receiver, weiAmount, tokenAmount, customerId);
382   }
383   /**
384    * Preallocate tokens for the early investors.
385    *
386    * Preallocated tokens have been sold before the actual crowdsale opens.
387    * This function mints the tokens and moves the crowdsale needle.
388    *
389    * Investor count is not handled; it is assumed this goes for multiple investors
390    * and the token distribution happens outside the smart contract flow.
391    *
392    * No money is exchanged, as the crowdsale team already have received the payment.
393    *
394    * @param fullTokens tokens as full tokens - decimal places added internally
395    * @param weiPrice Price of a single full token in wei
396    *
397    */
398   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
399     uint tokenAmount = fullTokens * 10**token.decimals();
400     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
401     weiRaised = weiRaised.plus(weiAmount);
402     tokensSold = tokensSold.plus(tokenAmount);
403     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
404     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
405     assignTokens(receiver, tokenAmount);
406     // Tell us invest was success
407     Invested(receiver, weiAmount, tokenAmount, 0);
408   }
409   /**
410    * Allow anonymous contributions to this crowdsale.
411    */
412   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
413      bytes32 hash = sha256(addr);
414      if (ecrecover(hash, v, r, s) != signerAddress) throw;
415      if(customerId == 0) throw;  // UUIDv4 sanity check
416      investInternal(addr, customerId);
417   }
418   /**
419    * Track who is the customer making the payment so we can send thank you email.
420    */
421   function investWithCustomerId(address addr, uint128 customerId) public payable {
422     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
423     if(customerId == 0) throw;  // UUIDv4 sanity check
424     investInternal(addr, customerId);
425   }
426   /**
427    * Allow anonymous contributions to this crowdsale.
428    */
429   function invest(address addr) public payable {
430     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
431     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
432     investInternal(addr, 0);
433   }
434   /**
435    * Invest to tokens, recognize the payer and clear his address.
436    *
437    */
438   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
439     investWithSignedAddress(msg.sender, customerId, v, r, s);
440   }
441   /**
442    * Invest to tokens, recognize the payer.
443    *
444    */
445   function buyWithCustomerId(uint128 customerId) public payable {
446     investWithCustomerId(msg.sender, customerId);
447   }
448   /**
449    * The basic entry point to participate the crowdsale process.
450    *
451    * Pay for funding, get invested tokens back in the sender address.
452    */
453   function buy() public payable {
454     invest(msg.sender);
455   }
456   /**
457    * Finalize a succcesful crowdsale.
458    *
459    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
460    */
461   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
462     // Already finalized
463     if(finalized) {
464       throw;
465     }
466     // Finalizing is optional. We only call it if we are given a finalizing agent.
467     if(address(finalizeAgent) != 0) {
468       finalizeAgent.finalizeCrowdsale();
469     }
470     finalized = true;
471   }
472   /**
473    * Allow to (re)set finalize agent.
474    *
475    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
476    */
477   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
478     finalizeAgent = addr;
479     // Don't allow setting bad agent
480     if(!finalizeAgent.isFinalizeAgent()) {
481       throw;
482     }
483   }
484   /**
485    * Set policy do we need to have server-side customer ids for the investments.
486    *
487    */
488   function setRequireCustomerId(bool value) onlyOwner {
489     requireCustomerId = value;
490     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
491   }
492   /**
493    * Set policy if all investors must be cleared on the server side first.
494    *
495    * This is e.g. for the accredited investor clearing.
496    *
497    */
498   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
499     requiredSignedAddress = value;
500     signerAddress = _signerAddress;
501     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
502   }
503   /**
504    * Allow addresses to do early participation.
505    *
506    * TODO: Fix spelling error in the name
507    */
508   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
509     earlyParticipantWhitelist[addr] = status;
510     Whitelisted(addr, status);
511   }
512   /**
513    * Allow crowdsale owner to close early or extend the crowdsale.
514    *
515    * This is useful e.g. for a manual soft cap implementation:
516    * - after X amount is reached determine manual closing
517    *
518    * This may put the crowdsale to an invalid state,
519    * but we trust owners know what they are doing.
520    *
521    */
522   function setEndsAt(uint time) onlyOwner {
523     if(now > time) {
524       throw; // Don't change past
525     }
526     endsAt = time;
527     EndsAtChanged(endsAt);
528   }
529   /**
530    * Allow to (re)set pricing strategy.
531    *
532    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
533    */
534   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
535     pricingStrategy = _pricingStrategy;
536     // Don't allow setting bad agent
537     if(!pricingStrategy.isPricingStrategy()) {
538       throw;
539     }
540   }
541   /**
542    * Allow to change the team multisig address in the case of emergency.
543    *
544    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
545    * (we have done only few test transactions). After the crowdsale is going
546    * then multisig address stays locked for the safety reasons.
547    */
548   function setMultisig(address addr) public onlyOwner {
549     // Change
550     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
551       throw;
552     }
553     multisigWallet = addr;
554   }
555   /**
556    * Allow load refunds back on the contract for the refunding.
557    *
558    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
559    */
560   function loadRefund() public payable inState(State.Failure) {
561     if(msg.value == 0) throw;
562     loadedRefund = loadedRefund.plus(msg.value);
563   }
564   /**
565    * Investors can claim refund.
566    *
567    * Note that any refunds from proxy buyers should be handled separately,
568    * and not through this contract.
569    */
570   function refund() public inState(State.Refunding) {
571     uint256 weiValue = investedAmountOf[msg.sender];
572     if (weiValue == 0) throw;
573     investedAmountOf[msg.sender] = 0;
574     weiRefunded = weiRefunded.plus(weiValue);
575     Refund(msg.sender, weiValue);
576     if (!msg.sender.send(weiValue)) throw;
577   }
578   /**
579    * @return true if the crowdsale has raised enough money to be a successful.
580    */
581   function isMinimumGoalReached() public constant returns (bool reached) {
582     return weiRaised >= minimumFundingGoal;
583   }
584   /**
585    * Check if the contract relationship looks good.
586    */
587   function isFinalizerSane() public constant returns (bool sane) {
588     return finalizeAgent.isSane();
589   }
590   /**
591    * Check if the contract relationship looks good.
592    */
593   function isPricingSane() public constant returns (bool sane) {
594     return pricingStrategy.isSane(address(this));
595   }
596   /**
597    * Crowdfund state machine management.
598    *
599    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
600    */
601   function getState() public constant returns (State) {
602     if(finalized) return State.Finalized;
603     else if (address(finalizeAgent) == 0) return State.Preparing;
604     else if (!finalizeAgent.isSane()) return State.Preparing;
605     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
606     else if (block.timestamp < startsAt) return State.PreFunding;
607     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
608     else if (isMinimumGoalReached()) return State.Success;
609     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
610     else return State.Failure;
611   }
612   /** This is for manual testing of multisig wallet interaction */
613   function setOwnerTestValue(uint val) onlyOwner {
614     ownerTestValue = val;
615   }
616   /** Interface marker. */
617   function isCrowdsale() public constant returns (bool) {
618     return true;
619   }
620   //
621   // Modifiers
622   //
623   /** Modified allowing execution only if the crowdsale is currently running.  */
624   modifier inState(State state) {
625     if(getState() != state) throw;
626     _;
627   }
628   //
629   // Abstract functions
630   //
631   /**
632    * Check if the current invested breaks our cap rules.
633    *
634    *
635    * The child contract must define their own cap setting rules.
636    * We allow a lot of flexibility through different capping strategies (ETH, token count)
637    * Called from invest().
638    *
639    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
640    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
641    * @param weiRaisedTotal What would be our total raised balance after this transaction
642    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
643    *
644    * @return true if taking this investment would break our cap rules
645    */
646   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
647   /**
648    * Check if the current crowdsale is full and we can no longer sell any tokens.
649    */
650   function isCrowdsaleFull() public constant returns (bool);
651   /**
652    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
653    */
654   function assignTokens(address receiver, uint tokenAmount) private;
655 }
656 /**
657  * ICO crowdsale contract that is capped by amout of tokens.
658  *
659  * - Tokens are dynamically created during the crowdsale
660  *
661  *
662  */
663 contract MintedTokenCappedCrowdsale is Crowdsale {
664   /* Maximum amount of tokens this crowdsale can sell. */
665   uint public maximumSellableTokens;
666   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
667     maximumSellableTokens = _maximumSellableTokens;
668   }
669   /**
670    * Called from invest() to confirm if the curret investment does not break our cap rule.
671    */
672   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
673     return tokensSoldTotal > maximumSellableTokens;
674   }
675   function isCrowdsaleFull() public constant returns (bool) {
676     return tokensSold >= maximumSellableTokens;
677   }
678   /**
679    * Dynamically create tokens and assign them to the investor.
680    */
681   function assignTokens(address receiver, uint tokenAmount) private {
682     MintableToken mintableToken = MintableToken(token);
683     mintableToken.mint(receiver, tokenAmount);
684   }
685 }
686 
687 /**
688  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
689  *
690  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
691  */
692 /**
693  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
694  *
695  * Based on code by FirstBlood:
696  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
697  */
698 contract StandardToken is ERC20, SafeMath {
699   /* Token supply got increased and a new owner received these tokens */
700   event Minted(address receiver, uint amount);
701   /* Actual balances of token holders */
702   mapping(address => uint) balances;
703   /* approve() allowances */
704   mapping (address => mapping (address => uint)) allowed;
705   /* Interface declaration */
706   function isToken() public constant returns (bool weAre) {
707     return true;
708   }
709   function transfer(address _to, uint _value) returns (bool success) {
710     balances[msg.sender] = safeSub(balances[msg.sender], _value);
711     balances[_to] = safeAdd(balances[_to], _value);
712     Transfer(msg.sender, _to, _value);
713     return true;
714   }
715   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
716     uint _allowance = allowed[_from][msg.sender];
717     balances[_to] = safeAdd(balances[_to], _value);
718     balances[_from] = safeSub(balances[_from], _value);
719     allowed[_from][msg.sender] = safeSub(_allowance, _value);
720     Transfer(_from, _to, _value);
721     return true;
722   }
723   function balanceOf(address _owner) constant returns (uint balance) {
724     return balances[_owner];
725   }
726   function approve(address _spender, uint _value) returns (bool success) {
727     // To change the approve amount you first have to reduce the addresses`
728     //  allowance to zero by calling `approve(_spender, 0)` if it is not
729     //  already 0 to mitigate the race condition described here:
730     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
731     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
732     allowed[msg.sender][_spender] = _value;
733     Approval(msg.sender, _spender, _value);
734     return true;
735   }
736   function allowance(address _owner, address _spender) constant returns (uint remaining) {
737     return allowed[_owner][_spender];
738   }
739 }
740 /**
741  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
742  *
743  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
744  */
745 /**
746  * Safe unsigned safe math.
747  *
748  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
749  *
750  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
751  *
752  * Maintained here until merged to mainline zeppelin-solidity.
753  *
754  */
755 library SafeMathLib {
756   function times(uint a, uint b) returns (uint) {
757     uint c = a * b;
758     assert(a == 0 || c / a == b);
759     return c;
760   }
761   function minus(uint a, uint b) returns (uint) {
762     assert(b <= a);
763     return a - b;
764   }
765   function plus(uint a, uint b) returns (uint) {
766     uint c = a + b;
767     assert(c>=a);
768     return c;
769   }
770 }
771 /**
772  * A token that can increase its supply by another contract.
773  *
774  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
775  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
776  *
777  */
778 contract MintableToken is StandardToken, Ownable {
779   using SafeMathLib for uint;
780   bool public mintingFinished = false;
781   /** List of agents that are allowed to create new tokens */
782   mapping (address => bool) public mintAgents;
783   event MintingAgentChanged(address addr, bool state  );
784   /**
785    * Create new tokens and allocate them to an address..
786    *
787    * Only callably by a crowdsale contract (mint agent).
788    */
789   function mint(address receiver, uint amount) onlyMintAgent canMint public {
790     totalSupply = totalSupply.plus(amount);
791     balances[receiver] = balances[receiver].plus(amount);
792     // This will make the mint transaction apper in EtherScan.io
793     // We can remove this after there is a standardized minting event
794     Transfer(0, receiver, amount);
795   }
796   /**
797    * Owner can allow a crowdsale contract to mint new tokens.
798    */
799   function setMintAgent(address addr, bool state) onlyOwner canMint public {
800     mintAgents[addr] = state;
801     MintingAgentChanged(addr, state);
802   }
803   modifier onlyMintAgent() {
804     // Only crowdsale contracts are allowed to mint new tokens
805     if(!mintAgents[msg.sender]) {
806         throw;
807     }
808     _;
809   }
810   /** Make sure we are not done yet. */
811   modifier canMint() {
812     if(mintingFinished) throw;
813     _;
814   }
815 }
816 contract GetWhitelist is Ownable {
817     using SafeMathLib for uint;
818     event NewEntry(address whitelisted);
819     event NewBatch();
820     event EdittedEntry(address whitelisted, uint tier);
821     event WhitelisterChange(address whitelister, bool iswhitelister);
822     struct WhitelistInfo {
823         uint presaleAmount;
824         uint tier1Amount;
825         uint tier2Amount;
826         uint tier3Amount;
827         uint tier4Amount;
828         bool isWhitelisted;
829     }
830     mapping (address => bool) public whitelisters;
831     
832     mapping (address => WhitelistInfo) public entries;
833     uint presaleCap;
834     uint tier1Cap;
835     uint tier2Cap;
836     uint tier3Cap;
837     uint tier4Cap;
838     modifier onlyWhitelister() {
839         require(whitelisters[msg.sender]);
840         _;
841     }
842     function GetWhitelist(uint _presaleCap, uint _tier1Cap, uint _tier2Cap, uint _tier3Cap, uint _tier4Cap) {
843         presaleCap = _presaleCap;
844         tier1Cap = _tier1Cap;
845         tier2Cap = _tier2Cap;
846         tier3Cap = _tier3Cap;
847         tier4Cap = _tier4Cap;
848     }
849     function isGetWhiteList() constant returns (bool) {
850         return true;
851     }
852     function acceptBatched(address[] _addresses, bool _isEarly) onlyWhitelister {
853         // trying to save up some gas here
854         uint _presaleCap;
855         if (_isEarly) {
856             _presaleCap = presaleCap;
857         } else {
858             _presaleCap = 0;
859         }
860         for (uint i=0; i<_addresses.length; i++) {
861             entries[_addresses[i]] = WhitelistInfo(
862                 _presaleCap,
863                 tier1Cap,
864                 tier2Cap,
865                 tier3Cap,
866                 tier4Cap,
867                 true
868             );
869         }
870         NewBatch();
871     }
872     function accept(address _address, bool _isEarly) onlyWhitelister {
873         require(!entries[_address].isWhitelisted);
874         uint _presaleCap;
875         if (_isEarly) {
876             _presaleCap = presaleCap;
877         } else {
878             _presaleCap = 0;
879         }
880         entries[_address] = WhitelistInfo(_presaleCap, tier1Cap, tier2Cap, tier3Cap, tier4Cap, true);
881         NewEntry(_address);
882     }
883     function subtractAmount(address _address, uint _tier, uint _amount) onlyWhitelister {
884         require(_amount > 0);
885         require(entries[_address].isWhitelisted);
886         if (_tier == 0) {
887             entries[_address].presaleAmount = entries[_address].presaleAmount.minus(_amount);
888             EdittedEntry(_address, 0);
889             return;
890         }else if (_tier == 1) {
891             entries[_address].tier1Amount = entries[_address].tier1Amount.minus(_amount);
892             EdittedEntry(_address, 1);
893             return;
894         }else if (_tier == 2) {
895             entries[_address].tier2Amount = entries[_address].tier2Amount.minus(_amount);
896             EdittedEntry(_address, 2);
897             return;
898         }else if (_tier == 3) {
899             entries[_address].tier3Amount = entries[_address].tier3Amount.minus(_amount);
900             EdittedEntry(_address, 3);
901             return;
902         }else if (_tier == 4) {
903             entries[_address].tier4Amount = entries[_address].tier4Amount.minus(_amount);
904             EdittedEntry(_address, 4);
905             return;
906         }
907         revert();
908     }
909     function setWhitelister(address _whitelister, bool _isWhitelister) onlyOwner {
910         whitelisters[_whitelister] = _isWhitelister;
911         WhitelisterChange(_whitelister, _isWhitelister);
912     }
913     function setCaps(uint _presaleCap, uint _tier1Cap, uint _tier2Cap, uint _tier3Cap, uint _tier4Cap) onlyOwner {
914         presaleCap = _presaleCap;
915         tier1Cap = _tier1Cap;
916         tier2Cap = _tier2Cap;
917         tier3Cap = _tier3Cap;
918         tier4Cap = _tier4Cap;
919     }
920     function() payable {
921         revert();
922     }
923 }
924 contract GetCrowdsale is MintedTokenCappedCrowdsale {
925     uint public lockTime;
926     FinalizeAgent presaleFinalizeAgent;
927     event PresaleUpdated(uint weiAmount, uint tokenAmount);
928     function GetCrowdsale(
929         uint _lockTime, FinalizeAgent _presaleFinalizeAgent,
930         address _token, PricingStrategy _pricingStrategy, address _multisigWallet,
931         uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens)
932         MintedTokenCappedCrowdsale(_token, _pricingStrategy, _multisigWallet,
933             _start, _end, _minimumFundingGoal, _maximumSellableTokens)
934     {
935         require(_presaleFinalizeAgent.isSane());
936         require(_lockTime > 0);
937         lockTime = _lockTime;
938         presaleFinalizeAgent = _presaleFinalizeAgent;
939     }
940     function logPresaleResults(uint tokenAmount, uint weiAmount) returns (bool) {
941         require(msg.sender == address(presaleFinalizeAgent));
942         weiRaised = weiRaised.plus(weiAmount);
943         tokensSold = tokensSold.plus(tokenAmount);
944         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
945         PresaleUpdated(weiAmount, tokenAmount);
946         return true;
947     }
948     // overriden because presaleWeiRaised was not altered and would mess with the TranchePricing
949     function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
950         uint tokenAmount = fullTokens * 10**token.decimals();
951         uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
952         weiRaised = weiRaised.plus(weiAmount);
953         tokensSold = tokensSold.plus(tokenAmount);
954         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
955         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
956         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
957         assignTokens(receiver, tokenAmount);
958         // Tell us invest was success
959         Invested(receiver, weiAmount, tokenAmount, 0);
960     }
961     function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
962         // We don't need this function, we have external whitelist
963         revert();
964     }
965     // added this here because it was not visible by preallocate
966     function assignTokens(address receiver, uint tokenAmount) private {
967         MintableToken mintableToken = MintableToken(token);
968         mintableToken.mint(receiver, tokenAmount);
969     }
970     function finalize() public inState(State.Success) onlyOwner stopInEmergency {
971         require(now > endsAt + lockTime);
972         super.finalize();
973     }
974     function() payable {
975         invest(msg.sender);
976     }
977 }