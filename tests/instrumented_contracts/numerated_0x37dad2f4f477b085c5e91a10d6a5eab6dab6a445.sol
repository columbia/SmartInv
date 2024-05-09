1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 
9 
10 /**
11  * Math operations with safety checks
12  */
13 contract SafeMath {
14   function safeMul(uint a, uint b) internal returns (uint) {
15     uint c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function safeDiv(uint a, uint b) internal returns (uint) {
21     assert(b > 0);
22     uint c = a / b;
23     assert(a == b * c + a % b);
24     return c;
25   }
26 
27   function safeSub(uint a, uint b) internal returns (uint) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function safeAdd(uint a, uint b) internal returns (uint) {
33     uint c = a + b;
34     assert(c>=a && c>=b);
35     return c;
36   }
37 
38   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a >= b ? a : b;
40   }
41 
42   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a < b ? a : b;
44   }
45 
46   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a >= b ? a : b;
48   }
49 
50   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a < b ? a : b;
52   }
53 
54   function assert(bool assertion) internal {
55     if (!assertion) {
56       throw;
57     }
58   }
59 }
60 
61 /**
62  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
63  *
64  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
65  */
66 
67 
68 /**
69  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
70  *
71  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
72  */
73 
74 
75 /**
76  * Safe unsigned safe math.
77  *
78  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
79  *
80  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
81  *
82  * Maintained here until merged to mainline zeppelin-solidity.
83  *
84  */
85 library SafeMathLib {
86 
87   function times(uint a, uint b) returns (uint) {
88     uint c = a * b;
89     assert(a == 0 || c / a == b);
90     return c;
91   }
92 
93   function minus(uint a, uint b) returns (uint) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function plus(uint a, uint b) returns (uint) {
99     uint c = a + b;
100     assert(c>=a);
101     return c;
102   }
103 
104   function assert(bool assertion) private {
105     if (!assertion) throw;
106   }
107 }
108 
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 
117 
118 /*
119  * Ownable
120  *
121  * Base contract with an owner.
122  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
123  */
124 contract Ownable {
125   address public owner;
126 
127   function Ownable() {
128     owner = msg.sender;
129   }
130 
131   modifier onlyOwner() {
132     if (msg.sender != owner) {
133       throw;
134     }
135     _;
136   }
137 
138   function transferOwnership(address newOwner) onlyOwner {
139     if (newOwner != address(0)) {
140       owner = newOwner;
141     }
142   }
143 
144 }
145 
146 
147 /*
148  * Haltable
149  *
150  * Abstract contract that allows children to implement an
151  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
152  *
153  *
154  * Originally envisioned in FirstBlood ICO contract.
155  */
156 contract Haltable is Ownable {
157   bool public halted;
158 
159   modifier stopInEmergency {
160     if (halted) throw;
161     _;
162   }
163 
164   modifier onlyInEmergency {
165     if (!halted) throw;
166     _;
167   }
168 
169   // called by the owner on emergency, triggers stopped state
170   function halt() external onlyOwner {
171     halted = true;
172   }
173 
174   // called by the owner on end of emergency, returns to normal state
175   function unhalt() external onlyOwner onlyInEmergency {
176     halted = false;
177   }
178 
179 }
180 
181 /**
182  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
183  *
184  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
185  */
186 
187 
188 /**
189  * Interface for defining crowdsale pricing.
190  */
191 contract PricingStrategy {
192 
193   /** Interface declaration. */
194   function isPricingStrategy() public constant returns (bool) {
195     return true;
196   }
197 
198   /** Self check if all references are correctly set.
199    *
200    * Checks that pricing strategy matches crowdsale parameters.
201    */
202   function isSane(address crowdsale) public constant returns (bool) {
203     return true;
204   }
205 
206   /**
207    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
208    *
209    *
210    * @param value - What is the value of the transaction send in as wei
211    * @param tokensSold - how much tokens have been sold this far
212    * @param weiRaised - how much money has been raised this far
213    * @param msgSender - who is the investor of this transaction
214    * @param decimals - how many decimal units the token has
215    * @return Amount of tokens the investor receives
216    */
217   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
218 }
219 
220 /**
221  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
222  *
223  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
224  */
225 
226 
227 /**
228  * Finalize agent defines what happens at the end of succeseful crowdsale.
229  *
230  * - Allocate tokens for founders, bounties and community
231  * - Make tokens transferable
232  * - etc.
233  */
234 contract FinalizeAgent {
235 
236   function isFinalizeAgent() public constant returns(bool) {
237     return true;
238   }
239 
240   /** Return true if we can run finalizeCrowdsale() properly.
241    *
242    * This is a safety check function that doesn't allow crowdsale to begin
243    * unless the finalizer has been set up properly.
244    */
245   function isSane() public constant returns (bool);
246 
247   /** Called once by crowdsale finalize() if the sale was success. */
248   function finalizeCrowdsale();
249 
250 }
251 
252 /**
253  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
254  *
255  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
256  */
257 
258 
259 
260 
261 /*
262  * ERC20 interface
263  * see https://github.com/ethereum/EIPs/issues/20
264  */
265 contract ERC20 {
266   uint public totalSupply;
267   function balanceOf(address who) constant returns (uint);
268   function allowance(address owner, address spender) constant returns (uint);
269 
270   function transfer(address to, uint value) returns (bool ok);
271   function transferFrom(address from, address to, uint value) returns (bool ok);
272   function approve(address spender, uint value) returns (bool ok);
273   event Transfer(address indexed from, address indexed to, uint value);
274   event Approval(address indexed owner, address indexed spender, uint value);
275 }
276 
277 
278 /**
279  * A token that defines fractional units as decimals.
280  */
281 contract FractionalERC20 is ERC20 {
282 
283   uint public decimals;
284 
285 }
286 
287 
288 
289 /**
290  * Abstract base contract for token sales.
291  *
292  * Handle
293  * - start and end dates
294  * - accepting investments
295  * - minimum funding goal and refund
296  * - various statistics during the crowdfund
297  * - different pricing strategies
298  * - different investment policies (require server side customer id, allow only whitelisted addresses)
299  *
300  */
301 contract Crowdsale is Haltable {
302 
303   /* Max investment count when we are still allowed to change the multisig address */
304   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
305 
306   using SafeMathLib for uint;
307 
308   /* The token we are selling */
309   FractionalERC20 public token;
310 
311   /* How we are going to price our offering */
312   PricingStrategy public pricingStrategy;
313 
314   /* Post-success callback */
315   FinalizeAgent public finalizeAgent;
316 
317   /* tokens will be transfered from this address */
318   address public multisigWallet;
319 
320   /* if the funding goal is not reached, investors may withdraw their funds */
321   uint public minimumFundingGoal;
322 
323   /* the UNIX timestamp start date of the crowdsale */
324   uint public startsAt;
325 
326   /* the UNIX timestamp end date of the crowdsale */
327   uint public endsAt;
328 
329   /* the number of tokens already sold through this contract*/
330   uint public tokensSold = 0;
331 
332   /* How many wei of funding we have raised */
333   uint public weiRaised = 0;
334 
335   /* How many distinct addresses have invested */
336   uint public investorCount = 0;
337 
338   /* How much wei we have returned back to the contract after a failed crowdfund. */
339   uint public loadedRefund = 0;
340 
341   /* How much wei we have given back to investors.*/
342   uint public weiRefunded = 0;
343 
344   /* Has this crowdsale been finalized */
345   bool public finalized;
346 
347   /* Do we need to have unique contributor id for each customer */
348   bool public requireCustomerId;
349 
350   /**
351     * Do we verify that contributor has been cleared on the server side (accredited investors only).
352     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
353     */
354   bool public requiredSignedAddress;
355 
356   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
357   address public signerAddress;
358 
359   /** How much ETH each address has invested to this crowdsale */
360   mapping (address => uint256) public investedAmountOf;
361 
362   /** How much tokens this crowdsale has credited for each investor address */
363   mapping (address => uint256) public tokenAmountOf;
364 
365   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
366   mapping (address => bool) public earlyParticipantWhitelist;
367 
368   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
369   uint public ownerTestValue;
370 
371   /** State machine
372    *
373    * - Preparing: All contract initialization calls and variables have not been set yet
374    * - Prefunding: We have not passed start time yet
375    * - Funding: Active crowdsale
376    * - Success: Minimum funding goal reached
377    * - Failure: Minimum funding goal not reached before ending time
378    * - Finalized: The finalized has been called and succesfully executed
379    * - Refunding: Refunds are loaded on the contract for reclaim.
380    */
381   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
382 
383   // A new investment was made
384   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
385 
386   // Refund was processed for a contributor
387   event Refund(address investor, uint weiAmount);
388 
389   // The rules were changed what kind of investments we accept
390   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
391 
392   // Address early participation whitelist status changed
393   event Whitelisted(address addr, bool status);
394 
395   // Crowdsale end time has been changed
396   event EndsAtChanged(uint endsAt);
397 
398   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
399 
400     owner = msg.sender;
401 
402     token = FractionalERC20(_token);
403 
404     setPricingStrategy(_pricingStrategy);
405 
406     multisigWallet = _multisigWallet;
407     if(multisigWallet == 0) {
408         throw;
409     }
410 
411     if(_start == 0) {
412         throw;
413     }
414 
415     startsAt = _start;
416 
417     if(_end == 0) {
418         throw;
419     }
420 
421     endsAt = _end;
422 
423     // Don't mess the dates
424     if(startsAt >= endsAt) {
425         throw;
426     }
427 
428     // Minimum funding goal can be zero
429     minimumFundingGoal = _minimumFundingGoal;
430   }
431 
432   /**
433    * Don't expect to just send in money and get tokens.
434    */
435   function() payable {
436     throw;
437   }
438 
439   /**
440    * Make an investment.
441    *
442    * Crowdsale must be running for one to invest.
443    * We must have not pressed the emergency brake.
444    *
445    * @param receiver The Ethereum address who receives the tokens
446    * @param customerId (optional) UUID v4 to track the successful payments on the server side
447    *
448    */
449   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
450 
451     // Determine if it's a good time to accept investment from this participant
452     if(getState() == State.PreFunding) {
453       // Are we whitelisted for early deposit
454       if(!earlyParticipantWhitelist[receiver]) {
455         throw;
456       }
457     } else if(getState() == State.Funding) {
458       // Retail participants can only come in when the crowdsale is running
459       // pass
460     } else {
461       // Unwanted state
462       throw;
463     }
464 
465     uint weiAmount = msg.value;
466     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
467 
468     if(tokenAmount == 0) {
469       // Dust transaction
470       throw;
471     }
472 
473     if(investedAmountOf[receiver] == 0) {
474        // A new investor
475        investorCount++;
476     }
477 
478     // Update investor
479     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
480     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
481 
482     // Update totals
483     weiRaised = weiRaised.plus(weiAmount);
484     tokensSold = tokensSold.plus(tokenAmount);
485 
486     // Check that we did not bust the cap
487     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
488       throw;
489     }
490 
491     assignTokens(receiver, tokenAmount);
492 
493     // Pocket the money
494     if(!multisigWallet.send(weiAmount)) throw;
495 
496     // Tell us invest was success
497     Invested(receiver, weiAmount, tokenAmount, customerId);
498   }
499 
500   /**
501    * Preallocate tokens for the early investors.
502    *
503    * Preallocated tokens have been sold before the actual crowdsale opens.
504    * This function mints the tokens and moves the crowdsale needle.
505    *
506    * Investor count is not handled; it is assumed this goes for multiple investors
507    * and the token distribution happens outside the smart contract flow.
508    *
509    * No money is exchanged, as the crowdsale team already have received the payment.
510    *
511    * @param fullTokens tokens as full tokens - decimal places added internally
512    * @param weiPrice Price of a single full token in wei
513    *
514    */
515   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
516 
517     uint tokenAmount = fullTokens * 10**token.decimals();
518     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
519 
520     weiRaised = weiRaised.plus(weiAmount);
521     tokensSold = tokensSold.plus(tokenAmount);
522 
523     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
524     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
525 
526     assignTokens(receiver, tokenAmount);
527 
528     // Tell us invest was success
529     Invested(receiver, weiAmount, tokenAmount, 0);
530   }
531 
532   /**
533    * Allow anonymous contributions to this crowdsale.
534    */
535   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
536      bytes32 hash = sha256(addr);
537      if (ecrecover(hash, v, r, s) != signerAddress) throw;
538      if(customerId == 0) throw;  // UUIDv4 sanity check
539      investInternal(addr, customerId);
540   }
541 
542   /**
543    * Track who is the customer making the payment so we can send thank you email.
544    */
545   function investWithCustomerId(address addr, uint128 customerId) public payable {
546     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
547     if(customerId == 0) throw;  // UUIDv4 sanity check
548     investInternal(addr, customerId);
549   }
550 
551   /**
552    * Allow anonymous contributions to this crowdsale.
553    */
554   function invest(address addr) public payable {
555     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
556     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
557     investInternal(addr, 0);
558   }
559 
560   /**
561    * Invest to tokens, recognize the payer and clear his address.
562    *
563    */
564   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
565     investWithSignedAddress(msg.sender, customerId, v, r, s);
566   }
567 
568   /**
569    * Invest to tokens, recognize the payer.
570    *
571    */
572   function buyWithCustomerId(uint128 customerId) public payable {
573     investWithCustomerId(msg.sender, customerId);
574   }
575 
576   /**
577    * The basic entry point to participate the crowdsale process.
578    *
579    * Pay for funding, get invested tokens back in the sender address.
580    */
581   function buy() public payable {
582     invest(msg.sender);
583   }
584 
585   /**
586    * Finalize a succcesful crowdsale.
587    *
588    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
589    */
590   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
591 
592     // Already finalized
593     if(finalized) {
594       throw;
595     }
596 
597     // Finalizing is optional. We only call it if we are given a finalizing agent.
598     if(address(finalizeAgent) != 0) {
599       finalizeAgent.finalizeCrowdsale();
600     }
601 
602     finalized = true;
603   }
604 
605   /**
606    * Allow to (re)set finalize agent.
607    *
608    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
609    */
610   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
611     finalizeAgent = addr;
612 
613     // Don't allow setting bad agent
614     if(!finalizeAgent.isFinalizeAgent()) {
615       throw;
616     }
617   }
618 
619   /**
620    * Set policy do we need to have server-side customer ids for the investments.
621    *
622    */
623   function setRequireCustomerId(bool value) onlyOwner {
624     requireCustomerId = value;
625     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
626   }
627 
628   /**
629    * Set policy if all investors must be cleared on the server side first.
630    *
631    * This is e.g. for the accredited investor clearing.
632    *
633    */
634   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
635     requiredSignedAddress = value;
636     signerAddress = _signerAddress;
637     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
638   }
639 
640   /**
641    * Allow addresses to do early participation.
642    *
643    * TODO: Fix spelling error in the name
644    */
645   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
646     earlyParticipantWhitelist[addr] = status;
647     Whitelisted(addr, status);
648   }
649 
650   /**
651    * Allow crowdsale owner to close early or extend the crowdsale.
652    *
653    * This is useful e.g. for a manual soft cap implementation:
654    * - after X amount is reached determine manual closing
655    *
656    * This may put the crowdsale to an invalid state,
657    * but we trust owners know what they are doing.
658    *
659    */
660   function setEndsAt(uint time) onlyOwner {
661 
662     if(now > time) {
663       throw; // Don't change past
664     }
665 
666     endsAt = time;
667     EndsAtChanged(endsAt);
668   }
669 
670   /**
671    * Allow to (re)set pricing strategy.
672    *
673    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
674    */
675   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
676     pricingStrategy = _pricingStrategy;
677 
678     // Don't allow setting bad agent
679     if(!pricingStrategy.isPricingStrategy()) {
680       throw;
681     }
682   }
683 
684   /**
685    * Allow to change the team multisig address in the case of emergency.
686    *
687    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
688    * (we have done only few test transactions). After the crowdsale is going
689    * then multisig address stays locked for the safety reasons.
690    */
691   function setMultisig(address addr) public onlyOwner {
692 
693     // Change
694     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
695       throw;
696     }
697 
698     multisigWallet = addr;
699   }
700 
701   /**
702    * Allow load refunds back on the contract for the refunding.
703    *
704    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
705    */
706   function loadRefund() public payable inState(State.Failure) {
707     if(msg.value == 0) throw;
708     loadedRefund = loadedRefund.plus(msg.value);
709   }
710 
711   /**
712    * Investors can claim refund.
713    *
714    * Note that any refunds from proxy buyers should be handled separately,
715    * and not through this contract.
716    */
717   function refund() public inState(State.Refunding) {
718     uint256 weiValue = investedAmountOf[msg.sender];
719     if (weiValue == 0) throw;
720     investedAmountOf[msg.sender] = 0;
721     weiRefunded = weiRefunded.plus(weiValue);
722     Refund(msg.sender, weiValue);
723     if (!msg.sender.send(weiValue)) throw;
724   }
725 
726   /**
727    * @return true if the crowdsale has raised enough money to be a successful.
728    */
729   function isMinimumGoalReached() public constant returns (bool reached) {
730     return weiRaised >= minimumFundingGoal;
731   }
732 
733   /**
734    * Check if the contract relationship looks good.
735    */
736   function isFinalizerSane() public constant returns (bool sane) {
737     return finalizeAgent.isSane();
738   }
739 
740   /**
741    * Check if the contract relationship looks good.
742    */
743   function isPricingSane() public constant returns (bool sane) {
744     return pricingStrategy.isSane(address(this));
745   }
746 
747   /**
748    * Crowdfund state machine management.
749    *
750    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
751    */
752   function getState() public constant returns (State) {
753     if(finalized) return State.Finalized;
754     else if (address(finalizeAgent) == 0) return State.Preparing;
755     else if (!finalizeAgent.isSane()) return State.Preparing;
756     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
757     else if (block.timestamp < startsAt) return State.PreFunding;
758     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
759     else if (isMinimumGoalReached()) return State.Success;
760     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
761     else return State.Failure;
762   }
763 
764   /** This is for manual testing of multisig wallet interaction */
765   function setOwnerTestValue(uint val) onlyOwner {
766     ownerTestValue = val;
767   }
768 
769   /** Interface marker. */
770   function isCrowdsale() public constant returns (bool) {
771     return true;
772   }
773 
774   //
775   // Modifiers
776   //
777 
778   /** Modified allowing execution only if the crowdsale is currently running.  */
779   modifier inState(State state) {
780     if(getState() != state) throw;
781     _;
782   }
783 
784 
785   //
786   // Abstract functions
787   //
788 
789   /**
790    * Check if the current invested breaks our cap rules.
791    *
792    *
793    * The child contract must define their own cap setting rules.
794    * We allow a lot of flexibility through different capping strategies (ETH, token count)
795    * Called from invest().
796    *
797    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
798    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
799    * @param weiRaisedTotal What would be our total raised balance after this transaction
800    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
801    *
802    * @return true if taking this investment would break our cap rules
803    */
804   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
805 
806   /**
807    * Check if the current crowdsale is full and we can no longer sell any tokens.
808    */
809   function isCrowdsaleFull() public constant returns (bool);
810 
811   /**
812    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
813    */
814   function assignTokens(address receiver, uint tokenAmount) private;
815 }
816 
817 /**
818  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
819  *
820  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
821  */
822 
823 
824 
825 
826 
827 
828 
829 /**
830  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
831  *
832  * Based on code by FirstBlood:
833  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
834  */
835 contract StandardToken is ERC20, SafeMath {
836 
837   /* Token supply got increased and a new owner received these tokens */
838   event Minted(address receiver, uint amount);
839 
840   /* Actual balances of token holders */
841   mapping(address => uint) balances;
842 
843   /* approve() allowances */
844   mapping (address => mapping (address => uint)) allowed;
845 
846   /* Interface declaration */
847   function isToken() public constant returns (bool weAre) {
848     return true;
849   }
850 
851   function transfer(address _to, uint _value) returns (bool success) {
852     balances[msg.sender] = safeSub(balances[msg.sender], _value);
853     balances[_to] = safeAdd(balances[_to], _value);
854     Transfer(msg.sender, _to, _value);
855     return true;
856   }
857 
858   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
859     uint _allowance = allowed[_from][msg.sender];
860 
861     balances[_to] = safeAdd(balances[_to], _value);
862     balances[_from] = safeSub(balances[_from], _value);
863     allowed[_from][msg.sender] = safeSub(_allowance, _value);
864     Transfer(_from, _to, _value);
865     return true;
866   }
867 
868   function balanceOf(address _owner) constant returns (uint balance) {
869     return balances[_owner];
870   }
871 
872   function approve(address _spender, uint _value) returns (bool success) {
873 
874     // To change the approve amount you first have to reduce the addresses`
875     //  allowance to zero by calling `approve(_spender, 0)` if it is not
876     //  already 0 to mitigate the race condition described here:
877     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
878     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
879 
880     allowed[msg.sender][_spender] = _value;
881     Approval(msg.sender, _spender, _value);
882     return true;
883   }
884 
885   function allowance(address _owner, address _spender) constant returns (uint remaining) {
886     return allowed[_owner][_spender];
887   }
888 
889 }
890 
891 
892 
893 /**
894  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
895  *
896  * - Collect funds from pre-sale investors
897  * - Send funds to the crowdsale when it opens
898  * - Allow owner to set the crowdsale
899  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
900  * - Allow unlimited investors
901  * - Tokens are distributed on PreICOProxyBuyer smart contract first
902  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
903  * - All functions can be halted by owner if something goes wrong
904  *
905  */
906 contract PreICOProxyBuyer is Ownable, Haltable, SafeMath {
907 
908   /** How many investors we have now */
909   uint public investorCount;
910 
911   /** How many wei we have raised totla. */
912   uint public weiRaisedTotal;
913 
914   /** Who are our investors (iterable) */
915   address[] public investors;
916 
917   /** How much they have invested */
918   mapping(address => uint) public balances;
919 
920   /** How many tokens investors have claimed */
921   mapping(address => uint) public claimed;
922 
923   /** When our refund freeze is over (UNIT timestamp) */
924   uint public freezeEndsAt;
925 
926   /** What is the minimum buy in */
927   uint public weiMinimumLimit;
928 
929   /** What is the maximum buy in */
930   uint public weiMaximumLimit;
931 
932   /** How many weis total we are allowed to collect. */
933   uint public weiCap;
934 
935   /** How many tokens were bought */
936   uint public tokensBought;
937 
938    /** How many investors have claimed their tokens */
939   uint public claimCount;
940 
941   uint public totalClaimed;
942 
943   /** Our ICO contract where we will move the funds */
944   Crowdsale public crowdsale;
945 
946   /** What is our current state. */
947   enum State{Unknown, Funding, Distributing, Refunding}
948 
949   /** Somebody loaded their investment money */
950   event Invested(address investor, uint value, uint128 customerId);
951 
952   /** Refund claimed */
953   event Refunded(address investor, uint value);
954 
955   /** We executed our buy */
956   event TokensBoughts(uint count);
957 
958   /** We distributed tokens to an investor */
959   event Distributed(address investors, uint count);
960 
961   /**
962    * Create presale contract where lock up period is given days
963    */
964   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
965 
966     owner = _owner;
967 
968     // Give argument
969     if(_freezeEndsAt == 0) {
970       throw;
971     }
972 
973     // Give argument
974     if(_weiMinimumLimit == 0) {
975       throw;
976     }
977 
978     if(_weiMaximumLimit == 0) {
979       throw;
980     }
981 
982     weiMinimumLimit = _weiMinimumLimit;
983     weiMaximumLimit = _weiMaximumLimit;
984     weiCap = _weiCap;
985     freezeEndsAt = _freezeEndsAt;
986   }
987 
988   /**
989    * Get the token we are distributing.
990    */
991   function getToken() public constant returns(FractionalERC20) {
992     if(address(crowdsale) == 0)  {
993       throw;
994     }
995 
996     return crowdsale.token();
997   }
998 
999   /**
1000    * Participate to a presale.
1001    */
1002   function invest(uint128 customerId) private {
1003 
1004     // Cannot invest anymore through crowdsale when moving has begun
1005     if(getState() != State.Funding) throw;
1006 
1007     if(msg.value == 0) throw; // No empty buys
1008 
1009     address investor = msg.sender;
1010 
1011     bool existing = balances[investor] > 0;
1012 
1013     balances[investor] = safeAdd(balances[investor], msg.value);
1014 
1015     // Need to satisfy minimum and maximum limits
1016     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1017       throw;
1018     }
1019 
1020     // This is a new investor
1021     if(!existing) {
1022       investors.push(investor);
1023       investorCount++;
1024     }
1025 
1026     weiRaisedTotal = safeAdd(weiRaisedTotal, msg.value);
1027     if(weiRaisedTotal > weiCap) {
1028       throw;
1029     }
1030 
1031     Invested(investor, msg.value, customerId);
1032   }
1033 
1034   function investWithId(uint128 customerId) public stopInEmergency payable {
1035     invest(customerId);
1036   }
1037 
1038   function investWithoutId() public stopInEmergency payable {
1039     invest(0x0);
1040   }
1041 
1042 
1043   /**
1044    * Load funds to the crowdsale for all investors.
1045    *
1046    *
1047    */
1048   function buyForEverybody() stopInEmergency public {
1049 
1050     if(getState() != State.Funding) {
1051       // Only allow buy once
1052       throw;
1053     }
1054 
1055     // Crowdsale not yet set
1056     if(address(crowdsale) == 0) throw;
1057 
1058     // Buy tokens on the contract
1059     crowdsale.invest.value(weiRaisedTotal)(address(this));
1060 
1061     // Record how many tokens we got
1062     tokensBought = getToken().balanceOf(address(this));
1063 
1064     if(tokensBought == 0) {
1065       // Did not get any tokens
1066       throw;
1067     }
1068 
1069     TokensBoughts(tokensBought);
1070   }
1071 
1072   /**
1073    * How may tokens each investor gets.
1074    */
1075   function getClaimAmount(address investor) public constant returns (uint) {
1076 
1077     // Claims can be only made if we manage to buy tokens
1078     if(getState() != State.Distributing) {
1079       throw;
1080     }
1081     return safeMul(balances[investor], tokensBought) / weiRaisedTotal;
1082   }
1083 
1084   /**
1085    * How many tokens remain unclaimed for an investor.
1086    */
1087   function getClaimLeft(address investor) public constant returns (uint) {
1088     return safeSub(getClaimAmount(investor), claimed[investor]);
1089   }
1090 
1091   /**
1092    * Claim all remaining tokens for this investor.
1093    */
1094   function claimAll() {
1095     claim(getClaimLeft(msg.sender));
1096   }
1097 
1098   /**
1099    * Claim N bought tokens to the investor as the msg sender.
1100    *
1101    */
1102   function claim(uint amount) stopInEmergency {
1103     address investor = msg.sender;
1104 
1105     if(amount == 0) {
1106       throw;
1107     }
1108 
1109     if(getClaimLeft(investor) < amount) {
1110       // Woops we cannot get more than we have left
1111       throw;
1112     }
1113 
1114     // We track who many investor have (partially) claimed their tokens
1115     if(claimed[investor] == 0) {
1116       claimCount++;
1117     }
1118 
1119     claimed[investor] = safeAdd(claimed[investor], amount);
1120     totalClaimed = safeAdd(totalClaimed, amount);
1121     getToken().transfer(investor, amount);
1122 
1123     Distributed(investor, amount);
1124   }
1125 
1126   /**
1127    * ICO never happened. Allow refund.
1128    */
1129   function refund() stopInEmergency {
1130 
1131     // Trying to ask refund too soon
1132     if(getState() != State.Refunding) throw;
1133 
1134     address investor = msg.sender;
1135     if(balances[investor] == 0) throw;
1136     uint amount = balances[investor];
1137     delete balances[investor];
1138     if(!(investor.call.value(amount)())) throw;
1139     Refunded(investor, amount);
1140   }
1141 
1142   /**
1143    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
1144    */
1145   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
1146     crowdsale = _crowdsale;
1147 
1148     // Check interface
1149     if(!crowdsale.isCrowdsale()) true;
1150   }
1151 
1152   /**
1153    * Resolve the contract umambigious state.
1154    */
1155   function getState() public returns(State) {
1156     if(tokensBought == 0) {
1157       if(now >= freezeEndsAt) {
1158          return State.Refunding;
1159       } else {
1160         return State.Funding;
1161       }
1162     } else {
1163       return State.Distributing;
1164     }
1165   }
1166 
1167   /** Explicitly call function from your wallet. */
1168   function() payable {
1169     throw;
1170   }
1171 }