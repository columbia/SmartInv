1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
2 pragma solidity ^0.4.11;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
17 
18 
19 
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 
65 }
66 
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   function Ownable() {
86     owner = msg.sender;
87   }
88 
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) onlyOwner public {
104     require(newOwner != address(0));
105     OwnershipTransferred(owner, newOwner);
106     owner = newOwner;
107   }
108 
109 }
110 /**
111  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
112  *
113  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
114  */
115 
116 
117 
118 /**
119  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
120  *
121  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
122  */
123 
124 
125 
126 /**
127  * Safe unsigned safe math.
128  *
129  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
130  *
131  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
132  *
133  * Maintained here until merged to mainline zeppelin-solidity.
134  *
135  */
136 library SafeMathLibExt {
137 
138   function times(uint a, uint b) returns (uint) {
139     uint c = a * b;
140     assert(a == 0 || c / a == b);
141     return c;
142   }
143 
144   function divides(uint a, uint b) returns (uint) {
145     assert(b > 0);
146     uint c = a / b;
147     assert(a == b * c + a % b);
148     return c;
149   }
150 
151   function minus(uint a, uint b) returns (uint) {
152     assert(b <= a);
153     return a - b;
154   }
155 
156   function plus(uint a, uint b) returns (uint) {
157     uint c = a + b;
158     assert(c>=a);
159     return c;
160   }
161 
162 }
163 
164 /**
165  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
166  *
167  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
168  */
169 
170 
171 
172 
173 /**
174  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
175  *
176  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
177  */
178 
179 
180 
181 
182 
183 /*
184  * Haltable
185  *
186  * Abstract contract that allows children to implement an
187  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
188  *
189  *
190  * Originally envisioned in FirstBlood ICO contract.
191  */
192 contract Haltable is Ownable {
193   bool public halted;
194 
195   modifier stopInEmergency {
196     if (halted) throw;
197     _;
198   }
199 
200   modifier stopNonOwnersInEmergency {
201     if (halted && msg.sender != owner) throw;
202     _;
203   }
204 
205   modifier onlyInEmergency {
206     if (!halted) throw;
207     _;
208   }
209 
210   // called by the owner on emergency, triggers stopped state
211   function halt() external onlyOwner {
212     halted = true;
213   }
214 
215   // called by the owner on end of emergency, returns to normal state
216   function unhalt() external onlyOwner onlyInEmergency {
217     halted = false;
218   }
219 
220 }
221 
222 /**
223  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
224  *
225  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
226  */
227 
228 
229 
230 /**
231  * Interface for defining crowdsale pricing.
232  */
233 contract PricingStrategy {
234 
235   /** Interface declaration. */
236   function isPricingStrategy() public constant returns (bool) {
237     return true;
238   }
239 
240   /** Self check if all references are correctly set.
241    *
242    * Checks that pricing strategy matches crowdsale parameters.
243    */
244   function isSane(address crowdsale) public constant returns (bool) {
245     return true;
246   }
247 
248   /**
249    * @dev Pricing tells if this is a presale purchase or not.
250      @param purchaser Address of the purchaser
251      @return False by default, true if a presale purchaser
252    */
253   function isPresalePurchase(address purchaser) public constant returns (bool) {
254     return false;
255   }
256 
257   /**
258    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
259    *
260    *
261    * @param value - What is the value of the transaction send in as wei
262    * @param tokensSold - how much tokens have been sold this far
263    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
264    * @param msgSender - who is the investor of this transaction
265    * @param decimals - how many decimal units the token has
266    * @return Amount of tokens the investor receives
267    */
268   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
269 }
270 
271 /**
272  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
273  *
274  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
275  */
276 
277 
278 
279 /**
280  * Finalize agent defines what happens at the end of succeseful crowdsale.
281  *
282  * - Allocate tokens for founders, bounties and community
283  * - Make tokens transferable
284  * - etc.
285  */
286 contract FinalizeAgent {
287 
288   function isFinalizeAgent() public constant returns(bool) {
289     return true;
290   }
291 
292   /** Return true if we can run finalizeCrowdsale() properly.
293    *
294    * This is a safety check function that doesn't allow crowdsale to begin
295    * unless the finalizer has been set up properly.
296    */
297   function isSane() public constant returns (bool);
298 
299   /** Called once by crowdsale finalize() if the sale was success. */
300   function finalizeCrowdsale();
301 
302 }
303 
304 /**
305  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
306  *
307  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
308  */
309 
310 
311 
312 
313 
314 
315 
316 
317 
318 /**
319  * @title ERC20 interface
320  * @dev see https://github.com/ethereum/EIPs/issues/20
321  */
322 contract ERC20 is ERC20Basic {
323   function allowance(address owner, address spender) public constant returns (uint256);
324   function transferFrom(address from, address to, uint256 value) public returns (bool);
325   function approve(address spender, uint256 value) public returns (bool);
326   event Approval(address indexed owner, address indexed spender, uint256 value);
327 }
328 
329 
330 /**
331  * A token that defines fractional units as decimals.
332  */
333 contract FractionalERC20Ext is ERC20 {
334 
335   uint public decimals;
336   uint public minCap;
337 
338 }
339 
340 
341 
342 /**
343  * Abstract base contract for token sales.
344  *
345  * Handle
346  * - start and end dates
347  * - accepting investments
348  * - minimum funding goal and refund
349  * - various statistics during the crowdfund
350  * - different pricing strategies
351  * - different investment policies (require server side customer id, allow only whitelisted addresses)
352  *
353  */
354 contract CrowdsaleExt is Haltable {
355 
356   /* Max investment count when we are still allowed to change the multisig address */
357   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
358 
359   using SafeMathLibExt for uint;
360 
361   /* The token we are selling */
362   FractionalERC20Ext public token;
363 
364   /* How we are going to price our offering */
365   PricingStrategy public pricingStrategy;
366 
367   /* Post-success callback */
368   FinalizeAgent public finalizeAgent;
369 
370   /* tokens will be transfered from this address */
371   address public multisigWallet;
372 
373   /* if the funding goal is not reached, investors may withdraw their funds */
374   uint public minimumFundingGoal;
375 
376   /* the UNIX timestamp start date of the crowdsale */
377   uint public startsAt;
378 
379   /* the UNIX timestamp end date of the crowdsale */
380   uint public endsAt;
381 
382   /* the number of tokens already sold through this contract*/
383   uint public tokensSold = 0;
384 
385   /* How many wei of funding we have raised */
386   uint public weiRaised = 0;
387 
388   /* Calculate incoming funds from presale contracts and addresses */
389   uint public presaleWeiRaised = 0;
390 
391   /* How many distinct addresses have invested */
392   uint public investorCount = 0;
393 
394   /* How much wei we have returned back to the contract after a failed crowdfund. */
395   uint public loadedRefund = 0;
396 
397   /* How much wei we have given back to investors.*/
398   uint public weiRefunded = 0;
399 
400   /* Has this crowdsale been finalized */
401   bool public finalized;
402 
403   /* Do we need to have unique contributor id for each customer */
404   bool public requireCustomerId;
405 
406   bool public isWhiteListed;
407 
408   address[] public joinedCrowdsales;
409   uint public joinedCrowdsalesLen = 0;
410 
411   address public lastCrowdsale;
412 
413   /**
414     * Do we verify that contributor has been cleared on the server side (accredited investors only).
415     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
416     */
417   bool public requiredSignedAddress;
418 
419   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
420   address public signerAddress;
421 
422   /** How much ETH each address has invested to this crowdsale */
423   mapping (address => uint256) public investedAmountOf;
424 
425   /** How much tokens this crowdsale has credited for each investor address */
426   mapping (address => uint256) public tokenAmountOf;
427 
428   struct WhiteListData {
429     bool status;
430     uint minCap;
431     uint maxCap;
432   }
433 
434   //is crowdsale updatable
435   bool public isUpdatable;
436 
437   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
438   mapping (address => WhiteListData) public earlyParticipantWhitelist;
439 
440   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
441   uint public ownerTestValue;
442 
443   /** State machine
444    *
445    * - Preparing: All contract initialization calls and variables have not been set yet
446    * - Prefunding: We have not passed start time yet
447    * - Funding: Active crowdsale
448    * - Success: Minimum funding goal reached
449    * - Failure: Minimum funding goal not reached before ending time
450    * - Finalized: The finalized has been called and succesfully executed
451    * - Refunding: Refunds are loaded on the contract for reclaim.
452    */
453   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
454 
455   // A new investment was made
456   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
457 
458   // Refund was processed for a contributor
459   event Refund(address investor, uint weiAmount);
460 
461   // The rules were changed what kind of investments we accept
462   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
463 
464   // Address early participation whitelist status changed
465   event Whitelisted(address addr, bool status);
466 
467   // Crowdsale start time has been changed
468   event StartsAtChanged(uint newStartsAt);
469 
470   // Crowdsale end time has been changed
471   event EndsAtChanged(uint newEndsAt);
472 
473   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
474 
475     owner = msg.sender;
476 
477     token = FractionalERC20Ext(_token);
478 
479     setPricingStrategy(_pricingStrategy);
480 
481     multisigWallet = _multisigWallet;
482     if(multisigWallet == 0) {
483         throw;
484     }
485 
486     if(_start == 0) {
487         throw;
488     }
489 
490     startsAt = _start;
491 
492     if(_end == 0) {
493         throw;
494     }
495 
496     endsAt = _end;
497 
498     // Don't mess the dates
499     if(startsAt >= endsAt) {
500         throw;
501     }
502 
503     // Minimum funding goal can be zero
504     minimumFundingGoal = _minimumFundingGoal;
505 
506     isUpdatable = _isUpdatable;
507 
508     isWhiteListed = _isWhiteListed;
509   }
510 
511   /**
512    * Don't expect to just send in money and get tokens.
513    */
514   function() payable {
515     throw;
516   }
517 
518   /**
519    * Make an investment.
520    *
521    * Crowdsale must be running for one to invest.
522    * We must have not pressed the emergency brake.
523    *
524    * @param receiver The Ethereum address who receives the tokens
525    * @param customerId (optional) UUID v4 to track the successful payments on the server side
526    *
527    */
528   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
529 
530     // Determine if it's a good time to accept investment from this participant
531     if(getState() == State.PreFunding) {
532       // Are we whitelisted for early deposit
533       throw;
534     } else if(getState() == State.Funding) {
535       // Retail participants can only come in when the crowdsale is running
536       // pass
537       if(isWhiteListed) {
538         if(!earlyParticipantWhitelist[receiver].status) {
539           throw;
540         }
541       }
542     } else {
543       // Unwanted state
544       throw;
545     }
546 
547     uint weiAmount = msg.value;
548 
549     // Account presale sales separately, so that they do not count against pricing tranches
550     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
551 
552     if(tokenAmount == 0) {
553       // Dust transaction
554       throw;
555     }
556 
557     if(isWhiteListed) {
558       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
559         // tokenAmount < minCap for investor
560         throw;
561       }
562       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
563         // tokenAmount > maxCap for investor
564         throw;
565       }
566 
567       // Check that we did not bust the investor's cap
568       if (isBreakingInvestorCap(receiver, tokenAmount)) {
569         throw;
570       }
571     } else {
572       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
573         throw;
574       }
575     }
576 
577     if(investedAmountOf[receiver] == 0) {
578        // A new investor
579        investorCount++;
580     }
581 
582     // Update investor
583     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
584     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
585 
586     // Update totals
587     weiRaised = weiRaised.plus(weiAmount);
588     tokensSold = tokensSold.plus(tokenAmount);
589 
590     if(pricingStrategy.isPresalePurchase(receiver)) {
591         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
592     }
593 
594     // Check that we did not bust the cap
595     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
596       throw;
597     }
598 
599     assignTokens(receiver, tokenAmount);
600 
601     // Pocket the money
602     if(!multisigWallet.send(weiAmount)) throw;
603 
604     if (isWhiteListed) {
605       uint num = 0;
606       for (var i = 0; i < joinedCrowdsalesLen; i++) {
607         if (this == joinedCrowdsales[i]) 
608           num = i;
609       }
610 
611       if (num + 1 < joinedCrowdsalesLen) {
612         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
613           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
614           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
615         }
616       }
617     }
618 
619     // Tell us invest was success
620     Invested(receiver, weiAmount, tokenAmount, customerId);
621   }
622 
623   /**
624    * Preallocate tokens for the early investors.
625    *
626    * Preallocated tokens have been sold before the actual crowdsale opens.
627    * This function mints the tokens and moves the crowdsale needle.
628    *
629    * Investor count is not handled; it is assumed this goes for multiple investors
630    * and the token distribution happens outside the smart contract flow.
631    *
632    * No money is exchanged, as the crowdsale team already have received the payment.
633    *
634    * @param fullTokens tokens as full tokens - decimal places added internally
635    * @param weiPrice Price of a single full token in wei
636    *
637    */
638   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
639 
640     uint tokenAmount = fullTokens * 10**token.decimals();
641     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
642 
643     weiRaised = weiRaised.plus(weiAmount);
644     tokensSold = tokensSold.plus(tokenAmount);
645 
646     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
647     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
648 
649     assignTokens(receiver, tokenAmount);
650 
651     // Tell us invest was success
652     Invested(receiver, weiAmount, tokenAmount, 0);
653   }
654 
655   /**
656    * Allow anonymous contributions to this crowdsale.
657    */
658   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
659      bytes32 hash = sha256(addr);
660      if (ecrecover(hash, v, r, s) != signerAddress) throw;
661      if(customerId == 0) throw;  // UUIDv4 sanity check
662      investInternal(addr, customerId);
663   }
664 
665   /**
666    * Track who is the customer making the payment so we can send thank you email.
667    */
668   function investWithCustomerId(address addr, uint128 customerId) public payable {
669     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
670     if(customerId == 0) throw;  // UUIDv4 sanity check
671     investInternal(addr, customerId);
672   }
673 
674   /**
675    * Allow anonymous contributions to this crowdsale.
676    */
677   function invest(address addr) public payable {
678     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
679     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
680     investInternal(addr, 0);
681   }
682 
683   /**
684    * Invest to tokens, recognize the payer and clear his address.
685    *
686    */
687   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
688     investWithSignedAddress(msg.sender, customerId, v, r, s);
689   }
690 
691   /**
692    * Invest to tokens, recognize the payer.
693    *
694    */
695   function buyWithCustomerId(uint128 customerId) public payable {
696     investWithCustomerId(msg.sender, customerId);
697   }
698 
699   /**
700    * The basic entry point to participate the crowdsale process.
701    *
702    * Pay for funding, get invested tokens back in the sender address.
703    */
704   function buy() public payable {
705     invest(msg.sender);
706   }
707 
708   /**
709    * Finalize a succcesful crowdsale.
710    *
711    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
712    */
713   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
714 
715     // Already finalized
716     if(finalized) {
717       throw;
718     }
719 
720     // Finalizing is optional. We only call it if we are given a finalizing agent.
721     if(address(finalizeAgent) != 0) {
722       finalizeAgent.finalizeCrowdsale();
723     }
724 
725     finalized = true;
726   }
727 
728   /**
729    * Allow to (re)set finalize agent.
730    *
731    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
732    */
733   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
734     finalizeAgent = addr;
735 
736     // Don't allow setting bad agent
737     if(!finalizeAgent.isFinalizeAgent()) {
738       throw;
739     }
740   }
741 
742   /**
743    * Set policy do we need to have server-side customer ids for the investments.
744    *
745    */
746   function setRequireCustomerId(bool value) onlyOwner {
747     requireCustomerId = value;
748     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
749   }
750 
751   /**
752    * Set policy if all investors must be cleared on the server side first.
753    *
754    * This is e.g. for the accredited investor clearing.
755    *
756    */
757   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
758     requiredSignedAddress = value;
759     signerAddress = _signerAddress;
760     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
761   }
762 
763   /**
764    * Allow addresses to do early participation.
765    *
766    * TODO: Fix spelling error in the name
767    */
768   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
769     if (!isWhiteListed) throw;
770     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
771     Whitelisted(addr, status);
772   }
773 
774   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
775     if (!isWhiteListed) throw;
776     for (uint iterator = 0; iterator < addrs.length; iterator++) {
777       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
778     }
779   }
780 
781   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
782     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
783     if (!isWhiteListed) throw;
784     if (addr != msg.sender && contractAddr != msg.sender) throw;
785     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
786     newMaxCap = newMaxCap.minus(tokensBought);
787     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
788   }
789 
790   function updateJoinedCrowdsales(address addr) onlyOwner {
791     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
792   }
793 
794   function setLastCrowdsale(address addr) onlyOwner {
795     lastCrowdsale = addr;
796   }
797 
798   function clearJoinedCrowdsales() onlyOwner {
799     joinedCrowdsalesLen = 0;
800   }
801 
802   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
803     clearJoinedCrowdsales();
804     for (uint iter = 0; iter < addrs.length; iter++) {
805       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
806           joinedCrowdsales.length += 1;
807       }
808       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
809       if (iter == addrs.length - 1)
810         setLastCrowdsale(addrs[iter]);
811     }
812   }
813 
814   function setStartsAt(uint time) onlyOwner {
815     if (finalized) throw;
816 
817     if (!isUpdatable) throw;
818 
819     if(now > time) {
820       throw; // Don't change past
821     }
822 
823     if(time > endsAt) {
824       throw;
825     }
826 
827     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
828     if (lastCrowdsaleCntrct.finalized()) throw;
829 
830     startsAt = time;
831     StartsAtChanged(startsAt);
832   }
833 
834   /**
835    * Allow crowdsale owner to close early or extend the crowdsale.
836    *
837    * This is useful e.g. for a manual soft cap implementation:
838    * - after X amount is reached determine manual closing
839    *
840    * This may put the crowdsale to an invalid state,
841    * but we trust owners know what they are doing.
842    *
843    */
844   function setEndsAt(uint time) onlyOwner {
845     if (finalized) throw;
846 
847     if (!isUpdatable) throw;
848 
849     if(now > time) {
850       throw; // Don't change past
851     }
852 
853     if(startsAt > time) {
854       throw;
855     }
856 
857     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
858     if (lastCrowdsaleCntrct.finalized()) throw;
859 
860     uint num = 0;
861     for (var i = 0; i < joinedCrowdsalesLen; i++) {
862       if (this == joinedCrowdsales[i]) 
863         num = i;
864     }
865 
866     if (num + 1 < joinedCrowdsalesLen) {
867       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
868         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
869         if (time > crowdsale.startsAt()) throw;
870       }
871     }
872 
873     endsAt = time;
874     EndsAtChanged(endsAt);
875   }
876 
877   /**
878    * Allow to (re)set pricing strategy.
879    *
880    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
881    */
882   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
883     pricingStrategy = _pricingStrategy;
884 
885     // Don't allow setting bad agent
886     if(!pricingStrategy.isPricingStrategy()) {
887       throw;
888     }
889   }
890 
891   /**
892    * Allow to change the team multisig address in the case of emergency.
893    *
894    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
895    * (we have done only few test transactions). After the crowdsale is going
896    * then multisig address stays locked for the safety reasons.
897    */
898   function setMultisig(address addr) public onlyOwner {
899 
900     // Change
901     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
902       throw;
903     }
904 
905     multisigWallet = addr;
906   }
907 
908   /**
909    * Allow load refunds back on the contract for the refunding.
910    *
911    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
912    */
913   function loadRefund() public payable inState(State.Failure) {
914     if(msg.value == 0) throw;
915     loadedRefund = loadedRefund.plus(msg.value);
916   }
917 
918   /**
919    * Investors can claim refund.
920    *
921    * Note that any refunds from proxy buyers should be handled separately,
922    * and not through this contract.
923    */
924   function refund() public inState(State.Refunding) {
925     uint256 weiValue = investedAmountOf[msg.sender];
926     if (weiValue == 0) throw;
927     investedAmountOf[msg.sender] = 0;
928     weiRefunded = weiRefunded.plus(weiValue);
929     Refund(msg.sender, weiValue);
930     if (!msg.sender.send(weiValue)) throw;
931   }
932 
933   /**
934    * @return true if the crowdsale has raised enough money to be a successful.
935    */
936   function isMinimumGoalReached() public constant returns (bool reached) {
937     return weiRaised >= minimumFundingGoal;
938   }
939 
940   /**
941    * Check if the contract relationship looks good.
942    */
943   function isFinalizerSane() public constant returns (bool sane) {
944     return finalizeAgent.isSane();
945   }
946 
947   /**
948    * Check if the contract relationship looks good.
949    */
950   function isPricingSane() public constant returns (bool sane) {
951     return pricingStrategy.isSane(address(this));
952   }
953 
954   /**
955    * Crowdfund state machine management.
956    *
957    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
958    */
959   function getState() public constant returns (State) {
960     if(finalized) return State.Finalized;
961     else if (address(finalizeAgent) == 0) return State.Preparing;
962     else if (!finalizeAgent.isSane()) return State.Preparing;
963     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
964     else if (block.timestamp < startsAt) return State.PreFunding;
965     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
966     else if (isMinimumGoalReached()) return State.Success;
967     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
968     else return State.Failure;
969   }
970 
971   /** This is for manual testing of multisig wallet interaction */
972   function setOwnerTestValue(uint val) onlyOwner {
973     ownerTestValue = val;
974   }
975 
976   /** Interface marker. */
977   function isCrowdsale() public constant returns (bool) {
978     return true;
979   }
980 
981   //
982   // Modifiers
983   //
984 
985   /** Modified allowing execution only if the crowdsale is currently running.  */
986   modifier inState(State state) {
987     if(getState() != state) throw;
988     _;
989   }
990 
991 
992   //
993   // Abstract functions
994   //
995 
996   /**
997    * Check if the current invested breaks our cap rules.
998    *
999    *
1000    * The child contract must define their own cap setting rules.
1001    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1002    * Called from invest().
1003    *
1004    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1005    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1006    * @param weiRaisedTotal What would be our total raised balance after this transaction
1007    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1008    *
1009    * @return true if taking this investment would break our cap rules
1010    */
1011   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1012 
1013   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
1014 
1015   /**
1016    * Check if the current crowdsale is full and we can no longer sell any tokens.
1017    */
1018   function isCrowdsaleFull() public constant returns (bool);
1019 
1020   /**
1021    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1022    */
1023   function assignTokens(address receiver, uint tokenAmount) private;
1024 }
1025 
1026 /**
1027  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1028  *
1029  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1030  */
1031 
1032 
1033 
1034 /**
1035  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1036  *
1037  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1038  */
1039 
1040 
1041 
1042 
1043 
1044 
1045 
1046 
1047 /**
1048  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
1049  *
1050  * Based on code by FirstBlood:
1051  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1052  */
1053 contract StandardToken is ERC20, SafeMath {
1054 
1055   /* Token supply got increased and a new owner received these tokens */
1056   event Minted(address receiver, uint amount);
1057 
1058   /* Actual balances of token holders */
1059   mapping(address => uint) balances;
1060 
1061   /* approve() allowances */
1062   mapping (address => mapping (address => uint)) allowed;
1063 
1064   /* Interface declaration */
1065   function isToken() public constant returns (bool weAre) {
1066     return true;
1067   }
1068 
1069   function transfer(address _to, uint _value) returns (bool success) {
1070     balances[msg.sender] = safeSub(balances[msg.sender], _value);
1071     balances[_to] = safeAdd(balances[_to], _value);
1072     Transfer(msg.sender, _to, _value);
1073     return true;
1074   }
1075 
1076   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
1077     uint _allowance = allowed[_from][msg.sender];
1078 
1079     balances[_to] = safeAdd(balances[_to], _value);
1080     balances[_from] = safeSub(balances[_from], _value);
1081     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1082     Transfer(_from, _to, _value);
1083     return true;
1084   }
1085 
1086   function balanceOf(address _owner) constant returns (uint balance) {
1087     return balances[_owner];
1088   }
1089 
1090   function approve(address _spender, uint _value) returns (bool success) {
1091 
1092     // To change the approve amount you first have to reduce the addresses`
1093     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1094     //  already 0 to mitigate the race condition described here:
1095     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1096     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1097 
1098     allowed[msg.sender][_spender] = _value;
1099     Approval(msg.sender, _spender, _value);
1100     return true;
1101   }
1102 
1103   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1104     return allowed[_owner][_spender];
1105   }
1106 
1107 }
1108 
1109 /**
1110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1111  *
1112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1113  */
1114 
1115 
1116 
1117 
1118 
1119 /**
1120  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1121  *
1122  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1123  */
1124 
1125 
1126 
1127 /**
1128  * Upgrade agent interface inspired by Lunyr.
1129  *
1130  * Upgrade agent transfers tokens to a new contract.
1131  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
1132  */
1133 contract UpgradeAgent {
1134 
1135   uint public originalSupply;
1136 
1137   /** Interface marker */
1138   function isUpgradeAgent() public constant returns (bool) {
1139     return true;
1140   }
1141 
1142   function upgradeFrom(address _from, uint256 _value) public;
1143 
1144 }
1145 
1146 
1147 /**
1148  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
1149  *
1150  * First envisioned by Golem and Lunyr projects.
1151  */
1152 contract UpgradeableToken is StandardToken {
1153 
1154   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
1155   address public upgradeMaster;
1156 
1157   /** The next contract where the tokens will be migrated. */
1158   UpgradeAgent public upgradeAgent;
1159 
1160   /** How many tokens we have upgraded by now. */
1161   uint256 public totalUpgraded;
1162 
1163   /**
1164    * Upgrade states.
1165    *
1166    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
1167    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
1168    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
1169    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
1170    *
1171    */
1172   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
1173 
1174   /**
1175    * Somebody has upgraded some of his tokens.
1176    */
1177   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1178 
1179   /**
1180    * New upgrade agent available.
1181    */
1182   event UpgradeAgentSet(address agent);
1183 
1184   /**
1185    * Do not allow construction without upgrade master set.
1186    */
1187   function UpgradeableToken(address _upgradeMaster) {
1188     upgradeMaster = _upgradeMaster;
1189   }
1190 
1191   /**
1192    * Allow the token holder to upgrade some of their tokens to a new contract.
1193    */
1194   function upgrade(uint256 value) public {
1195 
1196       UpgradeState state = getUpgradeState();
1197       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
1198         // Called in a bad state
1199         throw;
1200       }
1201 
1202       // Validate input value.
1203       if (value == 0) throw;
1204 
1205       balances[msg.sender] = safeSub(balances[msg.sender], value);
1206 
1207       // Take tokens out from circulation
1208       totalSupply = safeSub(totalSupply, value);
1209       totalUpgraded = safeAdd(totalUpgraded, value);
1210 
1211       // Upgrade agent reissues the tokens
1212       upgradeAgent.upgradeFrom(msg.sender, value);
1213       Upgrade(msg.sender, upgradeAgent, value);
1214   }
1215 
1216   /**
1217    * Set an upgrade agent that handles
1218    */
1219   function setUpgradeAgent(address agent) external {
1220 
1221       if(!canUpgrade()) {
1222         // The token is not yet in a state that we could think upgrading
1223         throw;
1224       }
1225 
1226       if (agent == 0x0) throw;
1227       // Only a master can designate the next agent
1228       if (msg.sender != upgradeMaster) throw;
1229       // Upgrade has already begun for an agent
1230       if (getUpgradeState() == UpgradeState.Upgrading) throw;
1231 
1232       upgradeAgent = UpgradeAgent(agent);
1233 
1234       // Bad interface
1235       if(!upgradeAgent.isUpgradeAgent()) throw;
1236       // Make sure that token supplies match in source and target
1237       if (upgradeAgent.originalSupply() != totalSupply) throw;
1238 
1239       UpgradeAgentSet(upgradeAgent);
1240   }
1241 
1242   /**
1243    * Get the state of the token upgrade.
1244    */
1245   function getUpgradeState() public constant returns(UpgradeState) {
1246     if(!canUpgrade()) return UpgradeState.NotAllowed;
1247     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
1248     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1249     else return UpgradeState.Upgrading;
1250   }
1251 
1252   /**
1253    * Change the upgrade master.
1254    *
1255    * This allows us to set a new owner for the upgrade mechanism.
1256    */
1257   function setUpgradeMaster(address master) public {
1258       if (master == 0x0) throw;
1259       if (msg.sender != upgradeMaster) throw;
1260       upgradeMaster = master;
1261   }
1262 
1263   /**
1264    * Child contract can enable to provide the condition when the upgrade can begun.
1265    */
1266   function canUpgrade() public constant returns(bool) {
1267      return true;
1268   }
1269 
1270 }
1271 
1272 /**
1273  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1274  *
1275  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1276  */
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 /**
1285  * Define interface for releasing the token transfer after a successful crowdsale.
1286  */
1287 contract ReleasableToken is ERC20, Ownable {
1288 
1289   /* The finalizer contract that allows unlift the transfer limits on this token */
1290   address public releaseAgent;
1291 
1292   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
1293   bool public released = false;
1294 
1295   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
1296   mapping (address => bool) public transferAgents;
1297 
1298   /**
1299    * Limit token transfer until the crowdsale is over.
1300    *
1301    */
1302   modifier canTransfer(address _sender) {
1303 
1304     if(!released) {
1305         if(!transferAgents[_sender]) {
1306             throw;
1307         }
1308     }
1309 
1310     _;
1311   }
1312 
1313   /**
1314    * Set the contract that can call release and make the token transferable.
1315    *
1316    * Design choice. Allow reset the release agent to fix fat finger mistakes.
1317    */
1318   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
1319 
1320     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
1321     releaseAgent = addr;
1322   }
1323 
1324   /**
1325    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
1326    */
1327   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
1328     transferAgents[addr] = state;
1329   }
1330 
1331   /**
1332    * One way function to release the tokens to the wild.
1333    *
1334    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
1335    */
1336   function releaseTokenTransfer() public onlyReleaseAgent {
1337     released = true;
1338   }
1339 
1340   /** The function can be called only before or after the tokens have been releasesd */
1341   modifier inReleaseState(bool releaseState) {
1342     if(releaseState != released) {
1343         throw;
1344     }
1345     _;
1346   }
1347 
1348   /** The function can be called only by a whitelisted release agent. */
1349   modifier onlyReleaseAgent() {
1350     if(msg.sender != releaseAgent) {
1351         throw;
1352     }
1353     _;
1354   }
1355 
1356   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
1357     // Call StandardToken.transfer()
1358    return super.transfer(_to, _value);
1359   }
1360 
1361   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
1362     // Call StandardToken.transferForm()
1363     return super.transferFrom(_from, _to, _value);
1364   }
1365 
1366 }
1367 
1368 /**
1369  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1370  *
1371  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1372  */
1373 
1374 
1375 
1376 
1377 
1378 
1379 
1380 
1381 /**
1382  * A token that can increase its supply by another contract.
1383  *
1384  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1385  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1386  *
1387  */
1388 contract MintableTokenExt is StandardToken, Ownable {
1389 
1390   using SafeMathLibExt for uint;
1391 
1392   bool public mintingFinished = false;
1393 
1394   /** List of agents that are allowed to create new tokens */
1395   mapping (address => bool) public mintAgents;
1396 
1397   event MintingAgentChanged(address addr, bool state  );
1398 
1399   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1400   * For example, for reserved tokens in percents 2.54%
1401   * inPercentageUnit = 254
1402   * inPercentageDecimals = 2
1403   */
1404   struct ReservedTokensData {
1405     uint inTokens;
1406     uint inPercentageUnit;
1407     uint inPercentageDecimals;
1408   }
1409 
1410   mapping (address => ReservedTokensData) public reservedTokensList;
1411   address[] public reservedTokensDestinations;
1412   uint public reservedTokensDestinationsLen = 0;
1413 
1414   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) onlyOwner {
1415     reservedTokensDestinations.push(addr);
1416     reservedTokensDestinationsLen++;
1417     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
1418   }
1419 
1420   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
1421     return reservedTokensList[addr].inTokens;
1422   }
1423 
1424   function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
1425     return reservedTokensList[addr].inPercentageUnit;
1426   }
1427 
1428   function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
1429     return reservedTokensList[addr].inPercentageDecimals;
1430   }
1431 
1432   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) onlyOwner {
1433     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1434       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1435     }
1436   }
1437 
1438   /**
1439    * Create new tokens and allocate them to an address..
1440    *
1441    * Only callably by a crowdsale contract (mint agent).
1442    */
1443   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1444     totalSupply = totalSupply.plus(amount);
1445     balances[receiver] = balances[receiver].plus(amount);
1446 
1447     // This will make the mint transaction apper in EtherScan.io
1448     // We can remove this after there is a standardized minting event
1449     Transfer(0, receiver, amount);
1450   }
1451 
1452   /**
1453    * Owner can allow a crowdsale contract to mint new tokens.
1454    */
1455   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1456     mintAgents[addr] = state;
1457     MintingAgentChanged(addr, state);
1458   }
1459 
1460   modifier onlyMintAgent() {
1461     // Only crowdsale contracts are allowed to mint new tokens
1462     if(!mintAgents[msg.sender]) {
1463         throw;
1464     }
1465     _;
1466   }
1467 
1468   /** Make sure we are not done yet. */
1469   modifier canMint() {
1470     if(mintingFinished) throw;
1471     _;
1472   }
1473 }
1474 
1475 
1476 
1477 /**
1478  * A crowdsaled token.
1479  *
1480  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1481  *
1482  * - The token transfer() is disabled until the crowdsale is over
1483  * - The token contract gives an opt-in upgrade path to a new contract
1484  * - The same token can be part of several crowdsales through approve() mechanism
1485  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1486  *
1487  */
1488 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
1489 
1490   /** Name and symbol were updated. */
1491   event UpdatedTokenInformation(string newName, string newSymbol);
1492 
1493   string public name;
1494 
1495   string public symbol;
1496 
1497   uint public decimals;
1498 
1499   /* Minimum ammount of tokens every buyer can buy. */
1500   uint public minCap;
1501 
1502   /**
1503    * Construct the token.
1504    *
1505    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1506    *
1507    * @param _name Token name
1508    * @param _symbol Token symbol - should be all caps
1509    * @param _initialSupply How many tokens we start with
1510    * @param _decimals Number of decimal places
1511    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
1512    */
1513   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
1514     UpgradeableToken(msg.sender) {
1515 
1516     // Create any address, can be transferred
1517     // to team multisig via changeOwner(),
1518     // also remember to call setUpgradeMaster()
1519     owner = msg.sender;
1520 
1521     name = _name;
1522     symbol = _symbol;
1523 
1524     totalSupply = _initialSupply;
1525 
1526     decimals = _decimals;
1527 
1528     minCap = _globalMinCap;
1529 
1530     // Create initially all balance on the team multisig
1531     balances[owner] = totalSupply;
1532 
1533     if(totalSupply > 0) {
1534       Minted(owner, totalSupply);
1535     }
1536 
1537     // No more new supply allowed after the token creation
1538     if(!_mintable) {
1539       mintingFinished = true;
1540       if(totalSupply == 0) {
1541         throw; // Cannot create a token without supply and no minting
1542       }
1543     }
1544   }
1545 
1546   /**
1547    * When token is released to be transferable, enforce no new tokens can be created.
1548    */
1549   function releaseTokenTransfer() public onlyReleaseAgent {
1550     mintingFinished = true;
1551     super.releaseTokenTransfer();
1552   }
1553 
1554   /**
1555    * Allow upgrade agent functionality kick in only if the crowdsale was success.
1556    */
1557   function canUpgrade() public constant returns(bool) {
1558     return released && super.canUpgrade();
1559   }
1560 
1561   /**
1562    * Owner can update token information here.
1563    *
1564    * It is often useful to conceal the actual token association, until
1565    * the token operations, like central issuance or reissuance have been completed.
1566    *
1567    * This function allows the token owner to rename the token after the operations
1568    * have been completed and then point the audience to use the token contract.
1569    */
1570   function setTokenInformation(string _name, string _symbol) onlyOwner {
1571     name = _name;
1572     symbol = _symbol;
1573 
1574     UpdatedTokenInformation(name, symbol);
1575   }
1576 
1577 }
1578 
1579 
1580 /**
1581  * The default behavior for the crowdsale end.
1582  *
1583  * Unlock tokens.
1584  */
1585 contract ReservedTokensFinalizeAgent is FinalizeAgent {
1586   using SafeMathLibExt for uint;
1587   CrowdsaleTokenExt public token;
1588   CrowdsaleExt public crowdsale;
1589 
1590   function ReservedTokensFinalizeAgent(CrowdsaleTokenExt _token, CrowdsaleExt _crowdsale) {
1591     token = _token;
1592     crowdsale = _crowdsale;
1593   }
1594 
1595   /** Check that we can release the token */
1596   function isSane() public constant returns (bool) {
1597     return (token.releaseAgent() == address(this));
1598   }
1599 
1600   /** Called once by crowdsale finalize() if the sale was success. */
1601   function finalizeCrowdsale() public {
1602     if(msg.sender != address(crowdsale)) {
1603       throw;
1604     }
1605 
1606     // How many % of tokens the founders and others get
1607     uint tokensSold = crowdsale.tokensSold();
1608 
1609     // move reserved tokens in percentage
1610     for (var j = 0; j < token.reservedTokensDestinationsLen(); j++) {
1611       uint allocatedBonusInPercentage;
1612       uint percentsOfTokensUnit = token.getReservedTokensListValInPercentageUnit(token.reservedTokensDestinations(j));
1613       uint percentsOfTokensDecimals = token.getReservedTokensListValInPercentageDecimals(token.reservedTokensDestinations(j));
1614       if (percentsOfTokensUnit > 0) {
1615         allocatedBonusInPercentage = tokensSold * percentsOfTokensUnit / 10**percentsOfTokensDecimals / 100;
1616         tokensSold = tokensSold.plus(allocatedBonusInPercentage);
1617         token.mint(token.reservedTokensDestinations(j), allocatedBonusInPercentage);
1618       }
1619     }
1620 
1621     // move reserved tokens in tokens
1622     for (var i = 0; i < token.reservedTokensDestinationsLen(); i++) {
1623       uint allocatedBonusInTokens = token.getReservedTokensListValInTokens(token.reservedTokensDestinations(i));
1624       if (allocatedBonusInTokens > 0) {
1625         tokensSold = tokensSold.plus(allocatedBonusInTokens);
1626         token.mint(token.reservedTokensDestinations(i), allocatedBonusInTokens);
1627       }
1628     }
1629 
1630     token.releaseTokenTransfer();
1631   }
1632 
1633 }