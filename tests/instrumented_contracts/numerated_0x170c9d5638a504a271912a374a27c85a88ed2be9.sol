1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 /**
23  * Safe unsigned safe math.
24  *
25  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
26  *
27  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
28  *
29  * Maintained here until merged to mainline zeppelin-solidity.
30  *
31  */
32 library SafeMathLib {
33 
34   function times(uint a, uint b) returns (uint) {
35     uint c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function minus(uint a, uint b) returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function plus(uint a, uint b) returns (uint) {
46     uint c = a + b;
47     assert(c>=a);
48     return c;
49   }
50 
51   function assert(bool assertion) private {
52     if (!assertion) throw;
53   }
54 }
55 
56 /**
57  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
58  *
59  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
60  */
61 
62 
63 
64 
65 /*
66  * Ownable
67  *
68  * Base contract with an owner.
69  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
70  */
71 contract Ownable {
72   address public owner;
73 
74   function Ownable() {
75     owner = msg.sender;
76   }
77 
78   modifier onlyOwner() {
79     if (msg.sender != owner) {
80       throw;
81     }
82     _;
83   }
84 
85   function transferOwnership(address newOwner) onlyOwner {
86     if (newOwner != address(0)) {
87       owner = newOwner;
88     }
89   }
90 
91 }
92 
93 
94 /*
95  * Haltable
96  *
97  * Abstract contract that allows children to implement an
98  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
99  *
100  *
101  * Originally envisioned in FirstBlood ICO contract.
102  */
103 contract Haltable is Ownable {
104   bool public halted;
105 
106   modifier stopInEmergency {
107     if (halted) throw;
108     _;
109   }
110 
111   modifier onlyInEmergency {
112     if (!halted) throw;
113     _;
114   }
115 
116   // called by the owner on emergency, triggers stopped state
117   function halt() external onlyOwner {
118     halted = true;
119   }
120 
121   // called by the owner on end of emergency, returns to normal state
122   function unhalt() external onlyOwner onlyInEmergency {
123     halted = false;
124   }
125 
126 }
127 
128 /**
129  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
130  *
131  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
132  */
133 
134 
135 /**
136  * Interface for defining crowdsale pricing.
137  */
138 contract PricingStrategy {
139 
140   /** Interface declaration. */
141   function isPricingStrategy() public constant returns (bool) {
142     return true;
143   }
144 
145   /** Self check if all references are correctly set.
146    *
147    * Checks that pricing strategy matches crowdsale parameters.
148    */
149   function isSane(address crowdsale) public constant returns (bool) {
150     return true;
151   }
152 
153   /**
154    * @dev Pricing tells if this is a presale purchase or not.
155      @param purchaser Address of the purchaser
156      @return False by default, true if a presale purchaser
157    */
158   function isPresalePurchase(address purchaser) public constant returns (bool) {
159     return false;
160   }
161 
162   /**
163    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
164    *
165    *
166    * @param value - What is the value of the transaction send in as wei
167    * @param tokensSold - how much tokens have been sold this far
168    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
169    * @param msgSender - who is the investor of this transaction
170    * @param decimals - how many decimal units the token has
171    * @return Amount of tokens the investor receives
172    */
173   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
174 }
175 
176 /**
177  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
178  *
179  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
180  */
181 
182 
183 /**
184  * Finalize agent defines what happens at the end of succeseful crowdsale.
185  *
186  * - Allocate tokens for founders, bounties and community
187  * - Make tokens transferable
188  * - etc.
189  */
190 contract FinalizeAgent {
191 
192   function isFinalizeAgent() public constant returns(bool) {
193     return true;
194   }
195 
196   /** Return true if we can run finalizeCrowdsale() properly.
197    *
198    * This is a safety check function that doesn't allow crowdsale to begin
199    * unless the finalizer has been set up properly.
200    */
201   function isSane() public constant returns (bool);
202 
203   /** Called once by crowdsale finalize() if the sale was success. */
204   function finalizeCrowdsale();
205 
206 }
207 
208 /**
209  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
210  *
211  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
212  */
213 
214 
215 
216 
217 /*
218  * ERC20 interface
219  * see https://github.com/ethereum/EIPs/issues/20
220  */
221 contract ERC20 {
222   uint public totalSupply;
223   function balanceOf(address who) constant returns (uint);
224   function allowance(address owner, address spender) constant returns (uint);
225 
226   function transfer(address to, uint value) returns (bool ok);
227   function transferFrom(address from, address to, uint value) returns (bool ok);
228   function approve(address spender, uint value) returns (bool ok);
229   event Transfer(address indexed from, address indexed to, uint value);
230   event Approval(address indexed owner, address indexed spender, uint value);
231 }
232 
233 
234 /**
235  * A token that defines fractional units as decimals.
236  */
237 contract FractionalERC20 is ERC20 {
238 
239   uint public decimals;
240 
241 }
242 
243 
244 
245 /**
246  * Abstract base contract for token sales.
247  *
248  * Handle
249  * - start and end dates
250  * - accepting investments
251  * - minimum funding goal and refund
252  * - various statistics during the crowdfund
253  * - different pricing strategies
254  * - different investment policies (require server side customer id, allow only whitelisted addresses)
255  *
256  */
257 contract Crowdsale is Haltable {
258 
259   /* Max investment count when we are still allowed to change the multisig address */
260   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
261 
262   using SafeMathLib for uint;
263 
264   /* The token we are selling */
265   FractionalERC20 public token;
266 
267   /* How we are going to price our offering */
268   PricingStrategy public pricingStrategy;
269 
270   /* Post-success callback */
271   FinalizeAgent public finalizeAgent;
272 
273   /* tokens will be transfered from this address */
274   address public multisigWallet;
275 
276   /* if the funding goal is not reached, investors may withdraw their funds */
277   uint public minimumFundingGoal;
278 
279   /* the UNIX timestamp start date of the crowdsale */
280   uint public startsAt;
281 
282   /* the UNIX timestamp end date of the crowdsale */
283   uint public endsAt;
284 
285   /* the number of tokens already sold through this contract*/
286   uint public tokensSold = 0;
287 
288   /* How many wei of funding we have raised */
289   uint public weiRaised = 0;
290 
291   /* Calculate incoming funds from presale contracts and addresses */
292   uint public presaleWeiRaised = 0;
293 
294   /* How many distinct addresses have invested */
295   uint public investorCount = 0;
296 
297   /* How much wei we have returned back to the contract after a failed crowdfund. */
298   uint public loadedRefund = 0;
299 
300   /* How much wei we have given back to investors.*/
301   uint public weiRefunded = 0;
302 
303   /* Has this crowdsale been finalized */
304   bool public finalized;
305 
306   /* Do we need to have unique contributor id for each customer */
307   bool public requireCustomerId;
308 
309   /**
310     * Do we verify that contributor has been cleared on the server side (accredited investors only).
311     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
312     */
313   bool public requiredSignedAddress;
314 
315   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
316   address public signerAddress;
317 
318   /** How much ETH each address has invested to this crowdsale */
319   mapping (address => uint256) public investedAmountOf;
320 
321   /** How much tokens this crowdsale has credited for each investor address */
322   mapping (address => uint256) public tokenAmountOf;
323 
324   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
325   mapping (address => bool) public earlyParticipantWhitelist;
326 
327   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
328   uint public ownerTestValue;
329 
330   /** State machine
331    *
332    * - Preparing: All contract initialization calls and variables have not been set yet
333    * - Prefunding: We have not passed start time yet
334    * - Funding: Active crowdsale
335    * - Success: Minimum funding goal reached
336    * - Failure: Minimum funding goal not reached before ending time
337    * - Finalized: The finalized has been called and succesfully executed
338    * - Refunding: Refunds are loaded on the contract for reclaim.
339    */
340   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
341 
342   // A new investment was made
343   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
344 
345   // Refund was processed for a contributor
346   event Refund(address investor, uint weiAmount);
347 
348   // The rules were changed what kind of investments we accept
349   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
350 
351   // Address early participation whitelist status changed
352   event Whitelisted(address addr, bool status);
353 
354   // Crowdsale end time has been changed
355   event EndsAtChanged(uint endsAt);
356 
357   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
358 
359     owner = msg.sender;
360 
361     token = FractionalERC20(_token);
362 
363     setPricingStrategy(_pricingStrategy);
364 
365     multisigWallet = _multisigWallet;
366     if(multisigWallet == 0) {
367         throw;
368     }
369 
370     if(_start == 0) {
371         throw;
372     }
373 
374     startsAt = _start;
375 
376     if(_end == 0) {
377         throw;
378     }
379 
380     endsAt = _end;
381 
382     // Don't mess the dates
383     if(startsAt >= endsAt) {
384         throw;
385     }
386 
387     // Minimum funding goal can be zero
388     minimumFundingGoal = _minimumFundingGoal;
389   }
390 
391   /**
392    * Don't expect to just send in money and get tokens.
393    */
394   function() payable {
395     throw;
396   }
397 
398   /**
399    * Make an investment.
400    *
401    * Crowdsale must be running for one to invest.
402    * We must have not pressed the emergency brake.
403    *
404    * @param receiver The Ethereum address who receives the tokens
405    * @param customerId (optional) UUID v4 to track the successful payments on the server side
406    *
407    */
408   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
409 
410     // Determine if it's a good time to accept investment from this participant
411     if(getState() == State.PreFunding) {
412       // Are we whitelisted for early deposit
413       if(!earlyParticipantWhitelist[receiver]) {
414         throw;
415       }
416     } else if(getState() == State.Funding) {
417       // Retail participants can only come in when the crowdsale is running
418       // pass
419     } else {
420       // Unwanted state
421       throw;
422     }
423 
424     uint weiAmount = msg.value;
425 
426     // Account presale sales separately, so that they do not count against pricing tranches
427     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
428 
429     if(tokenAmount == 0) {
430       // Dust transaction
431       throw;
432     }
433 
434     if(investedAmountOf[receiver] == 0) {
435        // A new investor
436        investorCount++;
437     }
438 
439     // Update investor
440     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
441     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
442 
443     // Update totals
444     weiRaised = weiRaised.plus(weiAmount);
445     tokensSold = tokensSold.plus(tokenAmount);
446 
447     if(pricingStrategy.isPresalePurchase(receiver)) {
448         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
449     }
450 
451     // Check that we did not bust the cap
452     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
453       throw;
454     }
455 
456     assignTokens(receiver, tokenAmount);
457 
458     // Pocket the money
459     if(!multisigWallet.send(weiAmount)) throw;
460 
461     // Tell us invest was success
462     Invested(receiver, weiAmount, tokenAmount, customerId);
463   }
464 
465   /**
466    * Preallocate tokens for the early investors.
467    *
468    * Preallocated tokens have been sold before the actual crowdsale opens.
469    * This function mints the tokens and moves the crowdsale needle.
470    *
471    * Investor count is not handled; it is assumed this goes for multiple investors
472    * and the token distribution happens outside the smart contract flow.
473    *
474    * No money is exchanged, as the crowdsale team already have received the payment.
475    *
476    * @param fullTokens tokens as full tokens - decimal places added internally
477    * @param weiPrice Price of a single full token in wei
478    *
479    */
480   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
481 
482     uint tokenAmount = fullTokens * 10**token.decimals();
483     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
484 
485     weiRaised = weiRaised.plus(weiAmount);
486     tokensSold = tokensSold.plus(tokenAmount);
487 
488     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
489     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
490 
491     assignTokens(receiver, tokenAmount);
492 
493     // Tell us invest was success
494     Invested(receiver, weiAmount, tokenAmount, 0);
495   }
496 
497   /**
498    * Allow anonymous contributions to this crowdsale.
499    */
500   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
501      bytes32 hash = sha256(addr);
502      if (ecrecover(hash, v, r, s) != signerAddress) throw;
503      if(customerId == 0) throw;  // UUIDv4 sanity check
504      investInternal(addr, customerId);
505   }
506 
507   /**
508    * Track who is the customer making the payment so we can send thank you email.
509    */
510   function investWithCustomerId(address addr, uint128 customerId) public payable {
511     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
512     if(customerId == 0) throw;  // UUIDv4 sanity check
513     investInternal(addr, customerId);
514   }
515 
516   /**
517    * Allow anonymous contributions to this crowdsale.
518    */
519   function invest(address addr) public payable {
520     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
521     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
522     investInternal(addr, 0);
523   }
524 
525   /**
526    * Invest to tokens, recognize the payer and clear his address.
527    *
528    */
529   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
530     investWithSignedAddress(msg.sender, customerId, v, r, s);
531   }
532 
533   /**
534    * Invest to tokens, recognize the payer.
535    *
536    */
537   function buyWithCustomerId(uint128 customerId) public payable {
538     investWithCustomerId(msg.sender, customerId);
539   }
540 
541   /**
542    * The basic entry point to participate the crowdsale process.
543    *
544    * Pay for funding, get invested tokens back in the sender address.
545    */
546   function buy() public payable {
547     invest(msg.sender);
548   }
549 
550   /**
551    * Finalize a succcesful crowdsale.
552    *
553    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
554    */
555   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
556 
557     // Already finalized
558     if(finalized) {
559       throw;
560     }
561 
562     // Finalizing is optional. We only call it if we are given a finalizing agent.
563     if(address(finalizeAgent) != 0) {
564       finalizeAgent.finalizeCrowdsale();
565     }
566 
567     finalized = true;
568   }
569 
570   /**
571    * Allow to (re)set finalize agent.
572    *
573    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
574    */
575   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
576     finalizeAgent = addr;
577 
578     // Don't allow setting bad agent
579     if(!finalizeAgent.isFinalizeAgent()) {
580       throw;
581     }
582   }
583 
584   /**
585    * Set policy do we need to have server-side customer ids for the investments.
586    *
587    */
588   function setRequireCustomerId(bool value) onlyOwner {
589     requireCustomerId = value;
590     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
591   }
592 
593   /**
594    * Set policy if all investors must be cleared on the server side first.
595    *
596    * This is e.g. for the accredited investor clearing.
597    *
598    */
599   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
600     requiredSignedAddress = value;
601     signerAddress = _signerAddress;
602     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
603   }
604 
605   /**
606    * Allow addresses to do early participation.
607    *
608    * TODO: Fix spelling error in the name
609    */
610   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
611     earlyParticipantWhitelist[addr] = status;
612     Whitelisted(addr, status);
613   }
614 
615   /**
616    * Allow crowdsale owner to close early or extend the crowdsale.
617    *
618    * This is useful e.g. for a manual soft cap implementation:
619    * - after X amount is reached determine manual closing
620    *
621    * This may put the crowdsale to an invalid state,
622    * but we trust owners know what they are doing.
623    *
624    */
625   function setEndsAt(uint time) onlyOwner {
626 
627     if(now > time) {
628       throw; // Don't change past
629     }
630 
631     endsAt = time;
632     EndsAtChanged(endsAt);
633   }
634 
635   /**
636    * Allow to (re)set pricing strategy.
637    *
638    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
639    */
640   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
641     pricingStrategy = _pricingStrategy;
642 
643     // Don't allow setting bad agent
644     if(!pricingStrategy.isPricingStrategy()) {
645       throw;
646     }
647   }
648 
649   /**
650    * Allow to change the team multisig address in the case of emergency.
651    *
652    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
653    * (we have done only few test transactions). After the crowdsale is going
654    * then multisig address stays locked for the safety reasons.
655    */
656   function setMultisig(address addr) public onlyOwner {
657 
658     // Change
659     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
660       throw;
661     }
662 
663     multisigWallet = addr;
664   }
665 
666   /**
667    * Allow load refunds back on the contract for the refunding.
668    *
669    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
670    */
671   function loadRefund() public payable inState(State.Failure) {
672     if(msg.value == 0) throw;
673     loadedRefund = loadedRefund.plus(msg.value);
674   }
675 
676   /**
677    * Investors can claim refund.
678    *
679    * Note that any refunds from proxy buyers should be handled separately,
680    * and not through this contract.
681    */
682   function refund() public inState(State.Refunding) {
683     uint256 weiValue = investedAmountOf[msg.sender];
684     if (weiValue == 0) throw;
685     investedAmountOf[msg.sender] = 0;
686     weiRefunded = weiRefunded.plus(weiValue);
687     Refund(msg.sender, weiValue);
688     if (!msg.sender.send(weiValue)) throw;
689   }
690 
691   /**
692    * @return true if the crowdsale has raised enough money to be a successful.
693    */
694   function isMinimumGoalReached() public constant returns (bool reached) {
695     return weiRaised >= minimumFundingGoal;
696   }
697 
698   /**
699    * Check if the contract relationship looks good.
700    */
701   function isFinalizerSane() public constant returns (bool sane) {
702     return finalizeAgent.isSane();
703   }
704 
705   /**
706    * Check if the contract relationship looks good.
707    */
708   function isPricingSane() public constant returns (bool sane) {
709     return pricingStrategy.isSane(address(this));
710   }
711 
712   /**
713    * Crowdfund state machine management.
714    *
715    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
716    */
717   function getState() public constant returns (State) {
718     if(finalized) return State.Finalized;
719     else if (address(finalizeAgent) == 0) return State.Preparing;
720     else if (!finalizeAgent.isSane()) return State.Preparing;
721     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
722     else if (block.timestamp < startsAt) return State.PreFunding;
723     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
724     else if (isMinimumGoalReached()) return State.Success;
725     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
726     else return State.Failure;
727   }
728 
729   /** This is for manual testing of multisig wallet interaction */
730   function setOwnerTestValue(uint val) onlyOwner {
731     ownerTestValue = val;
732   }
733 
734   /** Interface marker. */
735   function isCrowdsale() public constant returns (bool) {
736     return true;
737   }
738 
739   //
740   // Modifiers
741   //
742 
743   /** Modified allowing execution only if the crowdsale is currently running.  */
744   modifier inState(State state) {
745     if(getState() != state) throw;
746     _;
747   }
748 
749 
750   //
751   // Abstract functions
752   //
753 
754   /**
755    * Check if the current invested breaks our cap rules.
756    *
757    *
758    * The child contract must define their own cap setting rules.
759    * We allow a lot of flexibility through different capping strategies (ETH, token count)
760    * Called from invest().
761    *
762    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
763    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
764    * @param weiRaisedTotal What would be our total raised balance after this transaction
765    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
766    *
767    * @return true if taking this investment would break our cap rules
768    */
769   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
770 
771   /**
772    * Check if the current crowdsale is full and we can no longer sell any tokens.
773    */
774   function isCrowdsaleFull() public constant returns (bool);
775 
776   /**
777    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
778    */
779   function assignTokens(address receiver, uint tokenAmount) private;
780 }
781 
782 
783 /**
784  * A crowdsale that is selling tokens from a preallocated pool
785  *
786  *
787  * - Tokens have precreated supply "premined"
788  *
789  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
790  *
791  */
792 contract AllocatedCrowdsale is Crowdsale {
793 
794   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
795   address public beneficiary;
796 
797   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
798     beneficiary = _beneficiary;
799   }
800 
801   /**
802    * Called from invest() to confirm if the curret investment does not break our cap rule.
803    */
804   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
805     if(tokenAmount > getTokensLeft()) {
806       return true;
807     } else {
808       return false;
809     }
810   }
811 
812   /**
813    * We are sold out when our approve pool becomes empty.
814    */
815   function isCrowdsaleFull() public constant returns (bool) {
816     return getTokensLeft() == 0;
817   }
818 
819   /**
820    * Get the amount of unsold tokens allocated to this contract;
821    */
822   function getTokensLeft() public constant returns (uint) {
823     return token.allowance(owner, this);
824   }
825 
826   /**
827    * Transfer tokens from approve() pool to the buyer.
828    *
829    * Use approve() given to this crowdsale to distribute the tokens.
830    */
831   function assignTokens(address receiver, uint tokenAmount) private {
832     if(!token.transferFrom(beneficiary, receiver, tokenAmount)) throw;
833   }
834 }