1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.15;
8 
9 // import "./Crowdsale.sol";
10 /**
11  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
12  *
13  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
14  */
15 
16 // pragma solidity ^0.4.15;
17 
18 // import 'zeppelin-solidity/contracts/math/SafeMath.sol';
19 // pragma solidity ^0.4.18;
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 // import "./Haltable.sol";
55 /**
56  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
57  *
58  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
59  */
60 
61 // pragma solidity ^0.4.15;
62 
63 // import "zeppelin-solidity/contracts/ownership/Ownable.sol";
64 // pragma solidity ^0.4.18;
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   function Ownable() public {
84     owner = msg.sender;
85   }
86 
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) public onlyOwner {
102     require(newOwner != address(0));
103     OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 
107 }
108 
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
120 
121   modifier stopInEmergency {
122     if (halted) revert();
123     _;
124   }
125 
126   modifier stopNonOwnersInEmergency {
127     if (halted && msg.sender != owner) revert();
128     _;
129   }
130 
131   modifier onlyInEmergency {
132     if (!halted) revert();
133     _;
134   }
135 
136   // called by the owner on emergency, triggers stopped state
137   function halt() external onlyOwner {
138     halted = true;
139   }
140 
141   // called by the owner on end of emergency, returns to normal state
142   function unhalt() external onlyOwner onlyInEmergency {
143     halted = false;
144   }
145 
146 }
147 
148 // import "./PricingStrategy.sol";
149 /**
150  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
151  *
152  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
153  */
154 
155 // pragma solidity ^0.4.15;
156 
157 // import "zeppelin-solidity/contracts/ownership/Ownable.sol";
158 
159 /**
160  * Interface for defining crowdsale pricing.
161  */
162 contract PricingStrategy is Ownable {
163 
164   /** Interface declaration. */
165   function isPricingStrategy() public constant returns (bool) {
166     return true;
167   }
168 
169   /** Self check if all references are correctly set.
170    *
171    * Checks that pricing strategy matches crowdsale parameters.
172    */
173   function isSane(address crowdsale) public constant returns (bool) {
174     return true;
175   }
176 
177   /**
178    * @dev Pricing tells if this is a presale purchase or not.
179      @param purchaser Address of the purchaser
180      @return False by default, true if a presale purchaser
181    */
182   function isPresalePurchase(address purchaser) public constant returns (bool) {
183     return false;
184   }
185 
186   /**
187    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
188    *
189    *
190    * @param value - What is the value of the transaction send in as wei
191    * @param tokensSold - how much tokens have been sold this far
192    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
193    * @param msgSender - who is the investor of this transaction
194    * @param decimals - how many decimal units the token has
195    * @return Amount of tokens the investor receives
196    */
197   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
198 }
199 
200 // import "./FinalizeAgent.sol";
201 /**
202  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
203  *
204  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
205  */
206 
207 // pragma solidity ^0.4.15;
208 
209 /**
210  * Finalize agent defines what happens at the end of succeseful crowdsale.
211  *
212  * - Allocate tokens for founders, bounties and community
213  * - Make tokens transferable
214  * - etc.
215  */
216 contract FinalizeAgent {
217 
218   function isFinalizeAgent() public constant returns(bool) {
219     return true;
220   }
221 
222   /** Return true if we can run finalizeCrowdsale() properly.
223    *
224    * This is a safety check function that doesn't allow crowdsale to begin
225    * unless the finalizer has been set up properly.
226    */
227   function isSane() public constant returns (bool);
228 
229   /** Called once by crowdsale finalize() if the sale was success. */
230   function finalizeCrowdsale();
231 
232 }
233 
234 // import "./FractionalERC20.sol";
235 /**
236  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
237  *
238  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
239  */
240 
241 // pragma solidity ^0.4.15;
242 
243 // import "zeppelin-solidity/contracts/token/ERC20.sol";
244 // pragma solidity ^0.4.18;
245 
246 
247 // import './ERC20Basic.sol';
248 // pragma solidity ^0.4.18;
249 
250 
251 /**
252  * @title ERC20Basic
253  * @dev Simpler version of ERC20 interface
254  * @dev see https://github.com/ethereum/EIPs/issues/179
255  */
256 contract ERC20Basic {
257   uint256 public totalSupply;
258   function balanceOf(address who) public view returns (uint256);
259   function transfer(address to, uint256 value) public returns (bool);
260   event Transfer(address indexed from, address indexed to, uint256 value);
261 }
262 
263 
264 /**
265  * @title ERC20 interface
266  * @dev see https://github.com/ethereum/EIPs/issues/20
267  */
268 contract ERC20 is ERC20Basic {
269   function allowance(address owner, address spender) public view returns (uint256);
270   function transferFrom(address from, address to, uint256 value) public returns (bool);
271   function approve(address spender, uint256 value) public returns (bool);
272   event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
274 
275 /**
276  * A token that defines fractional units as decimals.
277  */
278 contract FractionalERC20 is ERC20 {
279 
280   uint public decimals;
281 
282 }
283 
284 
285 
286 /**
287  * Abstract base contract for token sales.
288  *
289  * Handle
290  * - start and end dates
291  * - accepting investments
292  * - minimum funding goal and refund
293  * - various statistics during the crowdfund
294  * - different pricing strategies
295  * - different investment policies (require server side customer id, allow only whitelisted addresses)
296  *
297  */
298 contract Crowdsale is Haltable {
299   /* Time period to scale eth cap */
300   uint public constant TIME_PERIOD_IN_SEC = 1 days;
301 
302   /* Base eth cap */
303   uint public baseEthCap;
304 
305   /* Max eth per address */
306   uint public maxEthPerAddress;
307 
308   /* Max investment count when we are still allowed to change the multisig address */
309   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
310 
311   using SafeMath for uint;
312 
313   /* The token we are selling */
314   FractionalERC20 public token;
315 
316   /* How we are going to price our offering */
317   PricingStrategy public pricingStrategy;
318 
319   /* Post-success callback */
320   FinalizeAgent public finalizeAgent;
321 
322   /* tokens will be transfered from this address */
323   address public multisigWallet;
324 
325   /* if the funding goal is not reached, investors may withdraw their funds */
326   uint public minimumFundingGoal;
327 
328   /* the UNIX timestamp start date of the crowdsale */
329   uint public startsAt;
330 
331   /* the UNIX timestamp end date of the crowdsale */
332   uint public endsAt;
333 
334   /* the number of tokens already sold through this contract*/
335   uint256 public tokensSold = 0;
336 
337   /* How many wei of funding we have raised */
338   uint256 public weiRaised = 0;
339 
340   /* Calculate incoming funds from presale contracts and addresses */
341   uint public presaleWeiRaised = 0;
342 
343   /* How many distinct addresses have invested */
344   uint public investorCount = 0;
345 
346   /* How much wei we have returned back to the contract after a failed crowdfund. */
347   uint public loadedRefund = 0;
348 
349   /* How much wei we have given back to investors.*/
350   uint public weiRefunded = 0;
351 
352   /* Has this crowdsale been finalized */
353   bool public finalized;
354 
355   /* Do we need to have unique contributor id for each customer */
356   bool public requireCustomerId;
357 
358   /**
359     * Do we verify that contributor has been cleared on the server side (accredited investors only).
360     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
361     */
362   bool public requiredSignedAddress;
363 
364   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
365   address public signerAddress;
366 
367   /** How much ETH each address has invested to this crowdsale */
368   mapping (address => uint256) public investedAmountOf;
369 
370   /** How much tokens this crowdsale has credited for each investor address */
371   mapping (address => uint256) public tokenAmountOf;
372 
373   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
374   uint public ownerTestValue;
375 
376   /** State machine
377    *
378    * - Preparing: All contract initialization calls and variables have not been set yet
379    * - Prefunding: We have not passed start time yet
380    * - Funding: Active crowdsale
381    * - Success: Minimum funding goal reached
382    * - Failure: Minimum funding goal not reached before ending time
383    * - Finalized: The finalized has been called and succesfully executed
384    * - Refunding: Refunds are loaded on the contract for reclaim.
385    */
386   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
387 
388   // A new investment was made
389   event Invested(address investor, uint256 weiAmount, uint256 tokenAmount, uint128 customerId);
390 
391   // Refund was processed for a contributor
392   event Refund(address investor, uint weiAmount);
393 
394   // The rules were changed what kind of investments we accept
395   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
396 
397   // Crowdsale end time has been changed
398   event EndsAtChanged(uint newEndsAt);
399 
400   // Base eth cap has been changed
401   event BaseEthCapChanged(uint newBaseEthCap);
402 
403   // Max eth per address changed
404   event MaxEthPerAddressChanged(uint newMaxEthPerAddress);
405 
406   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _baseEthCap, uint _maxEthPerAddress) {
407 
408     owner = msg.sender;
409 
410     baseEthCap = _baseEthCap;
411 
412     maxEthPerAddress = _maxEthPerAddress;
413 
414     token = FractionalERC20(_token);
415 
416     setPricingStrategy(_pricingStrategy);
417 
418     multisigWallet = _multisigWallet;
419     if (multisigWallet == 0) {
420         revert();
421     }
422 
423     if (_start == 0) {
424         revert();
425     }
426 
427     startsAt = _start;
428 
429     if (_end == 0) {
430         revert();
431     }
432 
433     endsAt = _end;
434 
435     // Don't mess the dates
436     if (startsAt >= endsAt) {
437         revert();
438     }
439 
440     // Minimum funding goal can be zero
441     minimumFundingGoal = _minimumFundingGoal;
442   }
443 
444   function() payable {
445     buy();
446   }
447 
448   /**
449    * Make an investment.
450    *
451    * Crowdsale must be running for one to invest.
452    * We must have not pressed the emergency brake.
453    *
454    * @param receiver The Ethereum address who receives the tokens
455    * @param customerId (optional) UUID v4 to track the successful payments on the server side
456    *
457    */
458   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
459     uint weiAmount = msg.value;    
460 
461     // Account presale sales separately, so that they do not count against pricing tranches
462     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
463 
464     if (tokenAmount == 0) {
465       // Dust transaction
466       revert();
467     }
468 
469     //get the eth cap for the time period
470     uint currentFgcCap = getCurrentFgcCap();
471     if (tokenAmount > currentFgcCap) {
472       // We don't allow more than the current cap
473       revert();
474     }
475 
476     if (investedAmountOf[receiver] == 0) {
477        // A new investor
478        investorCount++;
479     }
480 
481     // Update investor
482     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
483     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);    
484     
485     // Update totals
486     weiRaised = weiRaised.add(weiAmount);
487     tokensSold = tokensSold.add(tokenAmount);
488 
489     if (pricingStrategy.isPresalePurchase(receiver)) {
490         presaleWeiRaised = presaleWeiRaised.add(weiAmount);
491     }
492 
493     // Check that we did not bust the cap
494     if (isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
495       revert();
496     }
497 
498     assignTokens(receiver, tokenAmount);
499 
500     // Pocket the money
501     if (!multisigWallet.send(weiAmount)) 
502       revert();
503 
504     // Tell us invest was success
505     Invested(receiver, weiAmount, tokenAmount, customerId);
506   }
507 
508   function getCurrentFgcCap() public constant returns (uint) {
509     if (block.timestamp < startsAt) 
510       return maxEthPerAddress;
511 
512     uint timeSinceStart = block.timestamp.sub(startsAt);
513     uint currentPeriod = timeSinceStart.div(TIME_PERIOD_IN_SEC).add(1);
514 
515     if (currentPeriod < 2) {
516       return 5000 * 10**token.decimals();
517     }
518     if (currentPeriod > 2 && currentPeriod < 5) {
519       return 1000 * 10**token.decimals();
520     }
521     if (currentPeriod > 4 && currentPeriod < 6) {
522       return 500 * 10**token.decimals();
523     }
524     if (currentPeriod > 5 && currentPeriod < 9) {
525       return 200 * 10**token.decimals();
526     }
527     if (currentPeriod > 8 && currentPeriod < 11) {
528       return 100 * 10**token.decimals();
529     }
530 
531     return maxEthPerAddress;
532   }
533 
534   /**
535    * Preallocate tokens for the early investors.
536    *
537    * Preallocated tokens have been sold before the actual crowdsale opens.
538    * This function mints the tokens and moves the crowdsale needle.
539    *
540    * Investor count is not handled; it is assumed this goes for multiple investors
541    * and the token distribution happens outside the smart contract flow.
542    *
543    * No money is exchanged, as the crowdsale team already have received the payment.
544    *
545    * @param fullTokens tokens as full tokens - decimal places added internally
546    * @param weiPrice Price of a single full token in wei
547    *
548    */
549   function preallocate(address receiver, uint256 fullTokens, uint256 weiPrice) public onlyOwner {
550 
551     uint256 tokenAmount = fullTokens;
552 	//uint256 tokenAmount = fullTokens * 10**token.decimals();
553     uint256 weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
554 
555     weiRaised = weiRaised.add(weiAmount);
556     tokensSold = tokensSold.add(tokenAmount);
557 
558     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
559     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
560 
561     assignTokens(receiver, tokenAmount);
562 
563     // Tell us invest was success
564     Invested(receiver, weiAmount, tokenAmount, 0);
565   }
566 
567   /**
568    * Allow anonymous contributions to this crowdsale.
569    */
570   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
571      bytes32 hash = sha256(addr);
572      if (ecrecover(hash, v, r, s) != signerAddress) 
573       revert();
574      if (customerId == 0) 
575       revert();  // UUIDv4 sanity check
576      investInternal(addr, customerId);
577   }
578 
579   /**
580    * Track who is the customer making the payment so we can send thank you email.
581    */
582   function investWithCustomerId(address addr, uint128 customerId) public payable {
583     if (requiredSignedAddress) 
584       revert(); // Crowdsale allows only server-side signed participants
585     if (customerId == 0) 
586       revert();  // UUIDv4 sanity check
587     investInternal(addr, customerId);
588   }
589 
590   /**
591    * Allow anonymous contributions to this crowdsale.
592    */
593   function invest(address addr) public payable {
594     if (requireCustomerId) 
595       revert(); // Crowdsale needs to track partipants for thank you email
596     if (requiredSignedAddress) 
597       revert(); // Crowdsale allows only server-side signed participants
598     investInternal(addr, 0);
599   }
600 
601   /**
602    * Invest to tokens, recognize the payer and clear his address.
603    *
604    */
605   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
606     investWithSignedAddress(msg.sender, customerId, v, r, s);
607   }
608 
609   /**
610    * Invest to tokens, recognize the payer.
611    *
612    */
613   function buyWithCustomerId(uint128 customerId) public payable {
614     investWithCustomerId(msg.sender, customerId);
615   }
616 
617   /**
618    * The basic entry point to participate the crowdsale process.
619    *
620    * Pay for funding, get invested tokens back in the sender address.
621    */
622   function buy() public payable {
623     invest(msg.sender);
624   }
625 
626   /**
627    * Finalize a succcesful crowdsale.
628    *
629    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
630    */
631   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
632 
633     // Already finalized
634     if (finalized) {
635       revert();
636     }
637 
638     // Finalizing is optional. We only call it if we are given a finalizing agent.
639     if (address(finalizeAgent) != 0) {
640       finalizeAgent.finalizeCrowdsale();
641     }
642 
643     finalized = true;
644   }
645 
646   /**
647    * Allow to (re)set finalize agent.
648    *
649    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
650    */
651   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
652     finalizeAgent = addr;
653 
654     // Don't allow setting bad agent
655     if (!finalizeAgent.isFinalizeAgent()) {
656       revert();
657     }
658   }
659 
660   /**
661    * Set policy do we need to have server-side customer ids for the investments.
662    *
663    */
664   function setRequireCustomerId(bool value) onlyOwner {
665     requireCustomerId = value;
666     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
667   }
668 
669   /**
670    * Set policy if all investors must be cleared on the server side first.
671    *
672    * This is e.g. for the accredited investor clearing.
673    *
674    */
675   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
676     requiredSignedAddress = value;
677     signerAddress = _signerAddress;
678     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
679   }
680 
681   /** 
682    * Set the base eth cap
683    */
684   function setBaseEthCap(uint _baseEthCap) onlyOwner {
685     if (_baseEthCap == 0) 
686       revert();
687     baseEthCap = _baseEthCap;
688     BaseEthCapChanged(baseEthCap);
689   }
690 
691   /**
692    * Set the max eth per address
693    */
694   function setMaxEthPerAddress(uint _maxEthPerAddress) onlyOwner {
695     if(_maxEthPerAddress == 0)
696       revert();
697     maxEthPerAddress = _maxEthPerAddress;
698     MaxEthPerAddressChanged(maxEthPerAddress);
699   }
700 
701   /**
702    * Allow crowdsale owner to close early or extend the crowdsale.
703    *
704    * This is useful e.g. for a manual soft cap implementation:
705    * - after X amount is reached determine manual closing
706    *
707    * This may put the crowdsale to an invalid state,
708    * but we trust owners know what they are doing.
709    *
710    */
711   function setEndsAt(uint time) onlyOwner {
712     if (now > time) {
713       revert(); // Don't change past
714     }
715 
716     endsAt = time;
717     EndsAtChanged(endsAt);
718   }
719 
720   /**
721    * Allow to (re)set pricing strategy.
722    *
723    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
724    */
725   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
726     pricingStrategy = _pricingStrategy;
727 
728     // Don't allow setting bad agent
729     if (!pricingStrategy.isPricingStrategy()) {
730       revert();
731     }
732   }
733 
734   /**
735    * Allow to change the team multisig address in the case of emergency.
736    *
737    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
738    * (we have done only few test transactions). After the crowdsale is going
739    * then multisig address stays locked for the safety reasons.
740    */
741   function setMultisig(address addr) public onlyOwner {
742 
743     // Change
744     if (investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
745       revert();
746     }
747 
748     multisigWallet = addr;
749   }
750 
751   /**
752    * Allow load refunds back on the contract for the refunding.
753    *
754    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
755    */
756   function loadRefund() public payable inState(State.Failure) {
757     if (msg.value == 0) 
758       revert();
759     loadedRefund = loadedRefund.add(msg.value);
760   }
761 
762   /**
763    * Investors can claim refund.
764    *
765    * Note that any refunds from proxy buyers should be handled separately,
766    * and not through this contract.
767    */
768   function refund() public inState(State.Refunding) {
769     uint256 weiValue = investedAmountOf[msg.sender];
770     if (weiValue == 0) 
771       revert();
772     investedAmountOf[msg.sender] = 0;
773     weiRefunded = weiRefunded.add(weiValue);
774     Refund(msg.sender, weiValue);
775     if (!msg.sender.send(weiValue)) 
776       revert();
777   }
778 
779   /**
780    * @return true if the crowdsale has raised enough money to be a successful.
781    */
782   function isMinimumGoalReached() public constant returns (bool reached) {
783     return weiRaised >= minimumFundingGoal;
784   }
785 
786   /**
787    * Check if the contract relationship looks good.
788    */
789   function isFinalizerSane() public constant returns (bool sane) {
790     return finalizeAgent.isSane();
791   }
792 
793   /**
794    * Check if the contract relationship looks good.
795    */
796   function isPricingSane() public constant returns (bool sane) {
797     return pricingStrategy.isSane(address(this));
798   }
799 
800   /**
801    * Crowdfund state machine management.
802    *
803    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
804    */
805   function getState() public constant returns (State) {
806     if (finalized) 
807       return State.Finalized;
808     else if (address(finalizeAgent) == 0) 
809       return State.Preparing;
810     else if (!finalizeAgent.isSane()) 
811       return State.Preparing;
812     else if (!pricingStrategy.isSane(address(this))) 
813       return State.Preparing;
814     else if (block.timestamp < startsAt) 
815       return State.PreFunding;
816     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) 
817       return State.Funding;
818     else if (isMinimumGoalReached()) 
819       return State.Success;
820     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) 
821       return State.Refunding;
822     else 
823       return State.Failure;
824   }
825 
826   /** This is for manual testing of multisig wallet interaction */
827   function setOwnerTestValue(uint val) onlyOwner {
828     ownerTestValue = val;
829   }
830 
831   /** Interface marker. */
832   function isCrowdsale() public constant returns (bool) {
833     return true;
834   }
835 
836   //
837   // Modifiers
838   //
839 
840   /** Modified allowing execution only if the crowdsale is currently running.  */
841   modifier inState(State state) {
842     if (getState() != state) 
843       revert();
844     _;
845   }
846 
847 
848   //
849   // Abstract functions
850   //
851 
852   /**
853    * Check if the current invested breaks our cap rules.
854    *
855    *
856    * The child contract must define their own cap setting rules.
857    * We allow a lot of flexibility through different capping strategies (ETH, token count)
858    * Called from invest().
859    *
860    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
861    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
862    * @param weiRaisedTotal What would be our total raised balance after this transaction
863    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
864    *
865    * @return true if taking this investment would break our cap rules
866    */
867   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
868 
869   /**
870    * Check if the current crowdsale is full and we can no longer sell any tokens.
871    */
872   function isCrowdsaleFull() public constant returns (bool);
873 
874   /**
875    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
876    */
877   function assignTokens(address receiver, uint tokenAmount) private;
878 }
879 
880 // import "./PricingStrategy.sol";
881 /**
882  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
883  *
884  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
885  */
886 
887 // pragma solidity ^0.4.15;
888 
889 // import "zeppelin-solidity/contracts/ownership/Ownable.sol";
890 
891 
892 /**
893  * A crowdsale that is selling tokens from a preallocated pool
894  *
895  *
896  * - Tokens have precreated supply "premined"
897  *
898  * - Token owner must transfer sellable tokens to the crowdsale contract using ERC20.approve()
899  *
900  */
901 contract AllocatedCrowdsale is Crowdsale {
902 
903   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
904   address public beneficiary;
905 
906   function AllocatedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, address _beneficiary, uint baseEthCap, uint maxEthPerAddress) 
907     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, baseEthCap, maxEthPerAddress) {
908     beneficiary = _beneficiary;
909   }
910 
911   /**
912    * Called from invest() to confirm if the curret investment does not break our cap rule.
913    */
914   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
915     if (tokenAmount > getTokensLeft()) {
916       return true;
917     } else {
918       return false;
919     }
920   }
921 
922   /**
923    * We are sold out when our approve pool becomes empty.
924    */
925   function isCrowdsaleFull() public constant returns (bool) {
926     return getTokensLeft() == 0;
927   }
928 
929   /**
930    * Get the amount of unsold tokens allocated to this contract;
931    */
932   function getTokensLeft() public constant returns (uint) {
933     return token.allowance(owner, this);
934   }
935 
936   /**
937    * Transfer tokens from approve() pool to the buyer.
938    *
939    * Use approve() given to this crowdsale to distribute the tokens.
940    */
941   function assignTokens(address receiver, uint256 tokenAmount) private {
942     if (!token.transferFrom(beneficiary, receiver, tokenAmount)) 
943       revert();
944   }
945 }