1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
2 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
3 
4 pragma solidity ^0.4.8;
5 
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint a, uint b) internal returns (uint) {
18     assert(b > 0);
19     uint c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint a, uint b) internal returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint a, uint b) internal returns (uint) {
30     uint c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a >= b ? a : b;
37   }
38 
39   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a < b ? a : b;
41   }
42 
43   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a >= b ? a : b;
45   }
46 
47   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a < b ? a : b;
49   }
50 
51 }
52 
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   uint256 public totalSupply;
62   function balanceOf(address who) public constant returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
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
127  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
128  *
129  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
130  */
131 
132 
133 
134 /**
135  * Safe unsigned safe math.
136  *
137  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
138  *
139  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
140  *
141  * Maintained here until merged to mainline zeppelin-solidity.
142  *
143  */
144 library SafeMathLibExt {
145 
146   function times(uint a, uint b) returns (uint) {
147     uint c = a * b;
148     assert(a == 0 || c / a == b);
149     return c;
150   }
151 
152   function divides(uint a, uint b) returns (uint) {
153     assert(b > 0);
154     uint c = a / b;
155     assert(a == b * c + a % b);
156     return c;
157   }
158 
159   function minus(uint a, uint b) returns (uint) {
160     assert(b <= a);
161     return a - b;
162   }
163 
164   function plus(uint a, uint b) returns (uint) {
165     uint c = a + b;
166     assert(c>=a);
167     return c;
168   }
169 
170 }
171 
172 /**
173  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
174  *
175  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
176  */
177 
178 
179 
180 
181 
182 /*
183  * Haltable
184  *
185  * Abstract contract that allows children to implement an
186  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
187  *
188  *
189  * Originally envisioned in FirstBlood ICO contract.
190  */
191 contract Haltable is Ownable {
192   bool public halted;
193 
194   modifier stopInEmergency {
195     if (halted) throw;
196     _;
197   }
198 
199   modifier stopNonOwnersInEmergency {
200     if (halted && msg.sender != owner) throw;
201     _;
202   }
203 
204   modifier onlyInEmergency {
205     if (!halted) throw;
206     _;
207   }
208 
209   // called by the owner on emergency, triggers stopped state
210   function halt() external onlyOwner {
211     halted = true;
212   }
213 
214   // called by the owner on end of emergency, returns to normal state
215   function unhalt() external onlyOwner onlyInEmergency {
216     halted = false;
217   }
218 
219 }
220 
221 /**
222  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
223  *
224  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
225  */
226 
227 
228 
229 /**
230  * Interface for defining crowdsale pricing.
231  */
232 contract PricingStrategy {
233 
234   /** Interface declaration. */
235   function isPricingStrategy() public constant returns (bool) {
236     return true;
237   }
238 
239   /** Self check if all references are correctly set.
240    *
241    * Checks that pricing strategy matches crowdsale parameters.
242    */
243   function isSane(address crowdsale) public constant returns (bool) {
244     return true;
245   }
246 
247   /**
248    * @dev Pricing tells if this is a presale purchase or not.
249      @param purchaser Address of the purchaser
250      @return False by default, true if a presale purchaser
251    */
252   function isPresalePurchase(address purchaser) public constant returns (bool) {
253     return false;
254   }
255 
256   /**
257    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
258    *
259    *
260    * @param value - What is the value of the transaction send in as wei
261    * @param tokensSold - how much tokens have been sold this far
262    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
263    * @param msgSender - who is the investor of this transaction
264    * @param decimals - how many decimal units the token has
265    * @return Amount of tokens the investor receives
266    */
267   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
268 }
269 
270 /**
271  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
272  *
273  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
274  */
275 
276 
277 
278 /**
279  * Finalize agent defines what happens at the end of succeseful crowdsale.
280  *
281  * - Allocate tokens for founders, bounties and community
282  * - Make tokens transferable
283  * - etc.
284  */
285 contract FinalizeAgent {
286 
287   function isFinalizeAgent() public constant returns(bool) {
288     return true;
289   }
290 
291   /** Return true if we can run finalizeCrowdsale() properly.
292    *
293    * This is a safety check function that doesn't allow crowdsale to begin
294    * unless the finalizer has been set up properly.
295    */
296   function isSane() public constant returns (bool);
297 
298   /** Called once by crowdsale finalize() if the sale was success. */
299   function finalizeCrowdsale();
300 
301 }
302 
303 /**
304  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
305  *
306  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
307  */
308 
309 
310 
311 
312 
313 
314 
315 
316 
317 /**
318  * @title ERC20 interface
319  * @dev see https://github.com/ethereum/EIPs/issues/20
320  */
321 contract ERC20 is ERC20Basic {
322   function allowance(address owner, address spender) public constant returns (uint256);
323   function transferFrom(address from, address to, uint256 value) public returns (bool);
324   function approve(address spender, uint256 value) public returns (bool);
325   event Approval(address indexed owner, address indexed spender, uint256 value);
326 }
327 
328 
329 /**
330  * A token that defines fractional units as decimals.
331  */
332 contract FractionalERC20Ext is ERC20 {
333 
334   uint public decimals;
335   uint public minCap;
336 
337 }
338 
339 
340 
341 /**
342  * Abstract base contract for token sales.
343  *
344  * Handle
345  * - start and end dates
346  * - accepting investments
347  * - minimum funding goal and refund
348  * - various statistics during the crowdfund
349  * - different pricing strategies
350  * - different investment policies (require server side customer id, allow only whitelisted addresses)
351  *
352  */
353 contract CrowdsaleExt is Haltable {
354 
355   /* Max investment count when we are still allowed to change the multisig address */
356   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
357 
358   using SafeMathLibExt for uint;
359 
360   /* The token we are selling */
361   FractionalERC20Ext public token;
362 
363   /* How we are going to price our offering */
364   PricingStrategy public pricingStrategy;
365 
366   /* Post-success callback */
367   FinalizeAgent public finalizeAgent;
368 
369   /* tokens will be transfered from this address */
370   address public multisigWallet;
371 
372   /* if the funding goal is not reached, investors may withdraw their funds */
373   uint public minimumFundingGoal;
374 
375   /* the UNIX timestamp start date of the crowdsale */
376   uint public startsAt;
377 
378   /* the UNIX timestamp end date of the crowdsale */
379   uint public endsAt;
380 
381   /* the number of tokens already sold through this contract*/
382   uint public tokensSold = 0;
383 
384   /* How many wei of funding we have raised */
385   uint public weiRaised = 0;
386 
387   /* Calculate incoming funds from presale contracts and addresses */
388   uint public presaleWeiRaised = 0;
389 
390   /* How many distinct addresses have invested */
391   uint public investorCount = 0;
392 
393   /* How much wei we have returned back to the contract after a failed crowdfund. */
394   uint public loadedRefund = 0;
395 
396   /* How much wei we have given back to investors.*/
397   uint public weiRefunded = 0;
398 
399   /* Has this crowdsale been finalized */
400   bool public finalized;
401 
402   /* Do we need to have unique contributor id for each customer */
403   bool public requireCustomerId;
404 
405   bool public isWhiteListed;
406 
407   address[] public joinedCrowdsales;
408   uint public joinedCrowdsalesLen = 0;
409 
410   address public lastCrowdsale;
411 
412   /**
413     * Do we verify that contributor has been cleared on the server side (accredited investors only).
414     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
415     */
416   bool public requiredSignedAddress;
417 
418   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
419   address public signerAddress;
420 
421   /** How much ETH each address has invested to this crowdsale */
422   mapping (address => uint256) public investedAmountOf;
423 
424   /** How much tokens this crowdsale has credited for each investor address */
425   mapping (address => uint256) public tokenAmountOf;
426 
427   struct WhiteListData {
428     bool status;
429     uint minCap;
430     uint maxCap;
431   }
432 
433   //is crowdsale updatable
434   bool public isUpdatable;
435 
436   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
437   mapping (address => WhiteListData) public earlyParticipantWhitelist;
438 
439   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
440   uint public ownerTestValue;
441 
442   /** State machine
443    *
444    * - Preparing: All contract initialization calls and variables have not been set yet
445    * - Prefunding: We have not passed start time yet
446    * - Funding: Active crowdsale
447    * - Success: Minimum funding goal reached
448    * - Failure: Minimum funding goal not reached before ending time
449    * - Finalized: The finalized has been called and succesfully executed
450    * - Refunding: Refunds are loaded on the contract for reclaim.
451    */
452   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
453 
454   // A new investment was made
455   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
456 
457   // Refund was processed for a contributor
458   event Refund(address investor, uint weiAmount);
459 
460   // The rules were changed what kind of investments we accept
461   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
462 
463   // Address early participation whitelist status changed
464   event Whitelisted(address addr, bool status);
465 
466   // Crowdsale start time has been changed
467   event StartsAtChanged(uint newStartsAt);
468 
469   // Crowdsale end time has been changed
470   event EndsAtChanged(uint newEndsAt);
471 
472   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
473 
474     owner = msg.sender;
475 
476     token = FractionalERC20Ext(_token);
477 
478     setPricingStrategy(_pricingStrategy);
479 
480     multisigWallet = _multisigWallet;
481     if(multisigWallet == 0) {
482         throw;
483     }
484 
485     if(_start == 0) {
486         throw;
487     }
488 
489     startsAt = _start;
490 
491     if(_end == 0) {
492         throw;
493     }
494 
495     endsAt = _end;
496 
497     // Don't mess the dates
498     if(startsAt >= endsAt) {
499         throw;
500     }
501 
502     // Minimum funding goal can be zero
503     minimumFundingGoal = _minimumFundingGoal;
504 
505     isUpdatable = _isUpdatable;
506 
507     isWhiteListed = _isWhiteListed;
508   }
509 
510   /**
511    * Don't expect to just send in money and get tokens.
512    */
513   function() payable {
514     throw;
515   }
516 
517   /**
518    * Make an investment.
519    *
520    * Crowdsale must be running for one to invest.
521    * We must have not pressed the emergency brake.
522    *
523    * @param receiver The Ethereum address who receives the tokens
524    * @param customerId (optional) UUID v4 to track the successful payments on the server side
525    *
526    */
527   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
528 
529     // Determine if it's a good time to accept investment from this participant
530     if(getState() == State.PreFunding) {
531       // Are we whitelisted for early deposit
532       throw;
533     } else if(getState() == State.Funding) {
534       // Retail participants can only come in when the crowdsale is running
535       // pass
536       if(isWhiteListed) {
537         if(!earlyParticipantWhitelist[receiver].status) {
538           throw;
539         }
540       }
541     } else {
542       // Unwanted state
543       throw;
544     }
545 
546     uint weiAmount = msg.value;
547 
548     // Account presale sales separately, so that they do not count against pricing tranches
549     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
550 
551     if(tokenAmount == 0) {
552       // Dust transaction
553       throw;
554     }
555 
556     if(isWhiteListed) {
557       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
558         // tokenAmount < minCap for investor
559         throw;
560       }
561       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
562         // tokenAmount > maxCap for investor
563         throw;
564       }
565 
566       // Check that we did not bust the investor's cap
567       if (isBreakingInvestorCap(receiver, tokenAmount)) {
568         throw;
569       }
570     } else {
571       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
572         throw;
573       }
574     }
575 
576     if(investedAmountOf[receiver] == 0) {
577        // A new investor
578        investorCount++;
579     }
580 
581     // Update investor
582     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
583     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
584 
585     // Update totals
586     weiRaised = weiRaised.plus(weiAmount);
587     tokensSold = tokensSold.plus(tokenAmount);
588 
589     if(pricingStrategy.isPresalePurchase(receiver)) {
590         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
591     }
592 
593     // Check that we did not bust the cap
594     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
595       throw;
596     }
597 
598     assignTokens(receiver, tokenAmount);
599 
600     // Pocket the money
601     if(!multisigWallet.send(weiAmount)) throw;
602 
603     if (isWhiteListed) {
604       uint num = 0;
605       for (var i = 0; i < joinedCrowdsalesLen; i++) {
606         if (this == joinedCrowdsales[i]) 
607           num = i;
608       }
609 
610       if (num + 1 < joinedCrowdsalesLen) {
611         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
612           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
613           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
614         }
615       }
616     }
617 
618     // Tell us invest was success
619     Invested(receiver, weiAmount, tokenAmount, customerId);
620   }
621 
622   /**
623    * Preallocate tokens for the early investors.
624    *
625    * Preallocated tokens have been sold before the actual crowdsale opens.
626    * This function mints the tokens and moves the crowdsale needle.
627    *
628    * Investor count is not handled; it is assumed this goes for multiple investors
629    * and the token distribution happens outside the smart contract flow.
630    *
631    * No money is exchanged, as the crowdsale team already have received the payment.
632    *
633    * @param fullTokens tokens as full tokens - decimal places added internally
634    * @param weiPrice Price of a single full token in wei
635    *
636    */
637   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
638 
639     uint tokenAmount = fullTokens * 10**token.decimals();
640     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
641 
642     weiRaised = weiRaised.plus(weiAmount);
643     tokensSold = tokensSold.plus(tokenAmount);
644 
645     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
646     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
647 
648     assignTokens(receiver, tokenAmount);
649 
650     // Tell us invest was success
651     Invested(receiver, weiAmount, tokenAmount, 0);
652   }
653 
654   /**
655    * Allow anonymous contributions to this crowdsale.
656    */
657   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
658      bytes32 hash = sha256(addr);
659      if (ecrecover(hash, v, r, s) != signerAddress) throw;
660      if(customerId == 0) throw;  // UUIDv4 sanity check
661      investInternal(addr, customerId);
662   }
663 
664   /**
665    * Track who is the customer making the payment so we can send thank you email.
666    */
667   function investWithCustomerId(address addr, uint128 customerId) public payable {
668     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
669     if(customerId == 0) throw;  // UUIDv4 sanity check
670     investInternal(addr, customerId);
671   }
672 
673   /**
674    * Allow anonymous contributions to this crowdsale.
675    */
676   function invest(address addr) public payable {
677     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
678     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
679     investInternal(addr, 0);
680   }
681 
682   /**
683    * Invest to tokens, recognize the payer and clear his address.
684    *
685    */
686   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
687     investWithSignedAddress(msg.sender, customerId, v, r, s);
688   }
689 
690   /**
691    * Invest to tokens, recognize the payer.
692    *
693    */
694   function buyWithCustomerId(uint128 customerId) public payable {
695     investWithCustomerId(msg.sender, customerId);
696   }
697 
698   /**
699    * The basic entry point to participate the crowdsale process.
700    *
701    * Pay for funding, get invested tokens back in the sender address.
702    */
703   function buy() public payable {
704     invest(msg.sender);
705   }
706 
707   /**
708    * Finalize a succcesful crowdsale.
709    *
710    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
711    */
712   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
713 
714     // Already finalized
715     if(finalized) {
716       throw;
717     }
718 
719     // Finalizing is optional. We only call it if we are given a finalizing agent.
720     if(address(finalizeAgent) != 0) {
721       finalizeAgent.finalizeCrowdsale();
722     }
723 
724     finalized = true;
725   }
726 
727   /**
728    * Allow to (re)set finalize agent.
729    *
730    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
731    */
732   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
733     finalizeAgent = addr;
734 
735     // Don't allow setting bad agent
736     if(!finalizeAgent.isFinalizeAgent()) {
737       throw;
738     }
739   }
740 
741   /**
742    * Set policy do we need to have server-side customer ids for the investments.
743    *
744    */
745   function setRequireCustomerId(bool value) onlyOwner {
746     requireCustomerId = value;
747     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
748   }
749 
750   /**
751    * Set policy if all investors must be cleared on the server side first.
752    *
753    * This is e.g. for the accredited investor clearing.
754    *
755    */
756   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
757     requiredSignedAddress = value;
758     signerAddress = _signerAddress;
759     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
760   }
761 
762   /**
763    * Allow addresses to do early participation.
764    *
765    * TODO: Fix spelling error in the name
766    */
767   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
768     if (!isWhiteListed) throw;
769     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
770     Whitelisted(addr, status);
771   }
772 
773   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
774     if (!isWhiteListed) throw;
775     for (uint iterator = 0; iterator < addrs.length; iterator++) {
776       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
777     }
778   }
779 
780   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
781     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
782     if (!isWhiteListed) throw;
783     if (addr != msg.sender && contractAddr != msg.sender) throw;
784     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
785     newMaxCap = newMaxCap.minus(tokensBought);
786     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
787   }
788 
789   function updateJoinedCrowdsales(address addr) onlyOwner {
790     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
791   }
792 
793   function setLastCrowdsale(address addr) onlyOwner {
794     lastCrowdsale = addr;
795   }
796 
797   function clearJoinedCrowdsales() onlyOwner {
798     joinedCrowdsalesLen = 0;
799   }
800 
801   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
802     clearJoinedCrowdsales();
803     for (uint iter = 0; iter < addrs.length; iter++) {
804       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
805           joinedCrowdsales.length += 1;
806       }
807       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
808       if (iter == addrs.length - 1)
809         setLastCrowdsale(addrs[iter]);
810     }
811   }
812 
813   function setStartsAt(uint time) onlyOwner {
814     if (finalized) throw;
815 
816     if (!isUpdatable) throw;
817 
818     if(now > time) {
819       throw; // Don't change past
820     }
821 
822     if(time > endsAt) {
823       throw;
824     }
825 
826     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
827     if (lastCrowdsaleCntrct.finalized()) throw;
828 
829     startsAt = time;
830     StartsAtChanged(startsAt);
831   }
832 
833   /**
834    * Allow crowdsale owner to close early or extend the crowdsale.
835    *
836    * This is useful e.g. for a manual soft cap implementation:
837    * - after X amount is reached determine manual closing
838    *
839    * This may put the crowdsale to an invalid state,
840    * but we trust owners know what they are doing.
841    *
842    */
843   function setEndsAt(uint time) onlyOwner {
844     if (finalized) throw;
845 
846     if (!isUpdatable) throw;
847 
848     if(now > time) {
849       throw; // Don't change past
850     }
851 
852     if(startsAt > time) {
853       throw;
854     }
855 
856     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
857     if (lastCrowdsaleCntrct.finalized()) throw;
858 
859     uint num = 0;
860     for (var i = 0; i < joinedCrowdsalesLen; i++) {
861       if (this == joinedCrowdsales[i]) 
862         num = i;
863     }
864 
865     if (num + 1 < joinedCrowdsalesLen) {
866       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
867         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
868         if (time > crowdsale.startsAt()) throw;
869       }
870     }
871 
872     endsAt = time;
873     EndsAtChanged(endsAt);
874   }
875 
876   /**
877    * Allow to (re)set pricing strategy.
878    *
879    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
880    */
881   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
882     pricingStrategy = _pricingStrategy;
883 
884     // Don't allow setting bad agent
885     if(!pricingStrategy.isPricingStrategy()) {
886       throw;
887     }
888   }
889 
890   /**
891    * Allow to change the team multisig address in the case of emergency.
892    *
893    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
894    * (we have done only few test transactions). After the crowdsale is going
895    * then multisig address stays locked for the safety reasons.
896    */
897   function setMultisig(address addr) public onlyOwner {
898 
899     // Change
900     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
901       throw;
902     }
903 
904     multisigWallet = addr;
905   }
906 
907   /**
908    * Allow load refunds back on the contract for the refunding.
909    *
910    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
911    */
912   function loadRefund() public payable inState(State.Failure) {
913     if(msg.value == 0) throw;
914     loadedRefund = loadedRefund.plus(msg.value);
915   }
916 
917   /**
918    * Investors can claim refund.
919    *
920    * Note that any refunds from proxy buyers should be handled separately,
921    * and not through this contract.
922    */
923   function refund() public inState(State.Refunding) {
924     uint256 weiValue = investedAmountOf[msg.sender];
925     if (weiValue == 0) throw;
926     investedAmountOf[msg.sender] = 0;
927     weiRefunded = weiRefunded.plus(weiValue);
928     Refund(msg.sender, weiValue);
929     if (!msg.sender.send(weiValue)) throw;
930   }
931 
932   /**
933    * @return true if the crowdsale has raised enough money to be a successful.
934    */
935   function isMinimumGoalReached() public constant returns (bool reached) {
936     return weiRaised >= minimumFundingGoal;
937   }
938 
939   /**
940    * Check if the contract relationship looks good.
941    */
942   function isFinalizerSane() public constant returns (bool sane) {
943     return finalizeAgent.isSane();
944   }
945 
946   /**
947    * Check if the contract relationship looks good.
948    */
949   function isPricingSane() public constant returns (bool sane) {
950     return pricingStrategy.isSane(address(this));
951   }
952 
953   /**
954    * Crowdfund state machine management.
955    *
956    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
957    */
958   function getState() public constant returns (State) {
959     if(finalized) return State.Finalized;
960     else if (address(finalizeAgent) == 0) return State.Preparing;
961     else if (!finalizeAgent.isSane()) return State.Preparing;
962     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
963     else if (block.timestamp < startsAt) return State.PreFunding;
964     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
965     else if (isMinimumGoalReached()) return State.Success;
966     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
967     else return State.Failure;
968   }
969 
970   /** This is for manual testing of multisig wallet interaction */
971   function setOwnerTestValue(uint val) onlyOwner {
972     ownerTestValue = val;
973   }
974 
975   /** Interface marker. */
976   function isCrowdsale() public constant returns (bool) {
977     return true;
978   }
979 
980   //
981   // Modifiers
982   //
983 
984   /** Modified allowing execution only if the crowdsale is currently running.  */
985   modifier inState(State state) {
986     if(getState() != state) throw;
987     _;
988   }
989 
990 
991   //
992   // Abstract functions
993   //
994 
995   /**
996    * Check if the current invested breaks our cap rules.
997    *
998    *
999    * The child contract must define their own cap setting rules.
1000    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1001    * Called from invest().
1002    *
1003    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1004    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1005    * @param weiRaisedTotal What would be our total raised balance after this transaction
1006    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1007    *
1008    * @return true if taking this investment would break our cap rules
1009    */
1010   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1011 
1012   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
1013 
1014   /**
1015    * Check if the current crowdsale is full and we can no longer sell any tokens.
1016    */
1017   function isCrowdsaleFull() public constant returns (bool);
1018 
1019   /**
1020    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1021    */
1022   function assignTokens(address receiver, uint tokenAmount) private;
1023 }
1024 
1025 /**
1026  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1027  *
1028  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1029  */
1030 
1031 
1032 
1033 /**
1034  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1035  *
1036  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1037  */
1038 
1039 
1040 
1041 
1042 
1043 
1044 
1045 
1046 /**
1047  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
1048  *
1049  * Based on code by FirstBlood:
1050  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1051  */
1052 contract StandardToken is ERC20, SafeMath {
1053 
1054   /* Token supply got increased and a new owner received these tokens */
1055   event Minted(address receiver, uint amount);
1056 
1057   /* Actual balances of token holders */
1058   mapping(address => uint) balances;
1059 
1060   /* approve() allowances */
1061   mapping (address => mapping (address => uint)) allowed;
1062 
1063   /* Interface declaration */
1064   function isToken() public constant returns (bool weAre) {
1065     return true;
1066   }
1067 
1068   function transfer(address _to, uint _value) returns (bool success) {
1069     balances[msg.sender] = safeSub(balances[msg.sender], _value);
1070     balances[_to] = safeAdd(balances[_to], _value);
1071     Transfer(msg.sender, _to, _value);
1072     return true;
1073   }
1074 
1075   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
1076     uint _allowance = allowed[_from][msg.sender];
1077 
1078     balances[_to] = safeAdd(balances[_to], _value);
1079     balances[_from] = safeSub(balances[_from], _value);
1080     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1081     Transfer(_from, _to, _value);
1082     return true;
1083   }
1084 
1085   function balanceOf(address _owner) constant returns (uint balance) {
1086     return balances[_owner];
1087   }
1088 
1089   function approve(address _spender, uint _value) returns (bool success) {
1090 
1091     // To change the approve amount you first have to reduce the addresses`
1092     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1093     //  already 0 to mitigate the race condition described here:
1094     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1095     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1096 
1097     allowed[msg.sender][_spender] = _value;
1098     Approval(msg.sender, _spender, _value);
1099     return true;
1100   }
1101 
1102   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1103     return allowed[_owner][_spender];
1104   }
1105 
1106 }
1107 
1108 
1109 
1110 
1111 
1112 /**
1113  * A token that can increase its supply by another contract.
1114  *
1115  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1116  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1117  *
1118  */
1119 contract MintableTokenExt is StandardToken, Ownable {
1120 
1121   using SafeMathLibExt for uint;
1122 
1123   bool public mintingFinished = false;
1124 
1125   /** List of agents that are allowed to create new tokens */
1126   mapping (address => bool) public mintAgents;
1127 
1128   event MintingAgentChanged(address addr, bool state  );
1129 
1130   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1131   * For example, for reserved tokens in percents 2.54%
1132   * inPercentageUnit = 254
1133   * inPercentageDecimals = 2
1134   */
1135   struct ReservedTokensData {
1136     uint inTokens;
1137     uint inPercentageUnit;
1138     uint inPercentageDecimals;
1139   }
1140 
1141   mapping (address => ReservedTokensData) public reservedTokensList;
1142   address[] public reservedTokensDestinations;
1143   uint public reservedTokensDestinationsLen = 0;
1144 
1145   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) onlyOwner {
1146     reservedTokensDestinations.push(addr);
1147     reservedTokensDestinationsLen++;
1148     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
1149   }
1150 
1151   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
1152     return reservedTokensList[addr].inTokens;
1153   }
1154 
1155   function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
1156     return reservedTokensList[addr].inPercentageUnit;
1157   }
1158 
1159   function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
1160     return reservedTokensList[addr].inPercentageDecimals;
1161   }
1162 
1163   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) onlyOwner {
1164     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1165       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1166     }
1167   }
1168 
1169   /**
1170    * Create new tokens and allocate them to an address..
1171    *
1172    * Only callably by a crowdsale contract (mint agent).
1173    */
1174   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1175     totalSupply = totalSupply.plus(amount);
1176     balances[receiver] = balances[receiver].plus(amount);
1177 
1178     // This will make the mint transaction apper in EtherScan.io
1179     // We can remove this after there is a standardized minting event
1180     Transfer(0, receiver, amount);
1181   }
1182 
1183   /**
1184    * Owner can allow a crowdsale contract to mint new tokens.
1185    */
1186   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1187     mintAgents[addr] = state;
1188     MintingAgentChanged(addr, state);
1189   }
1190 
1191   modifier onlyMintAgent() {
1192     // Only crowdsale contracts are allowed to mint new tokens
1193     if(!mintAgents[msg.sender]) {
1194         throw;
1195     }
1196     _;
1197   }
1198 
1199   /** Make sure we are not done yet. */
1200   modifier canMint() {
1201     if(mintingFinished) throw;
1202     _;
1203   }
1204 }
1205 
1206 
1207 /**
1208  * ICO crowdsale contract that is capped by amout of tokens.
1209  *
1210  * - Tokens are dynamically created during the crowdsale
1211  *
1212  *
1213  */
1214 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1215 
1216   /* Maximum amount of tokens this crowdsale can sell. */
1217   uint public maximumSellableTokens;
1218 
1219   function MintedTokenCappedCrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1220     maximumSellableTokens = _maximumSellableTokens;
1221   }
1222 
1223   // Crowdsale maximumSellableTokens has been changed
1224   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1225 
1226   /**
1227    * Called from invest() to confirm if the curret investment does not break our cap rule.
1228    */
1229   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1230     return tokensSoldTotal > maximumSellableTokens;
1231   }
1232 
1233   function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
1234     if (!isWhiteListed) throw;
1235     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1236     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1237   }
1238 
1239   function isCrowdsaleFull() public constant returns (bool) {
1240     return tokensSold >= maximumSellableTokens;
1241   }
1242 
1243   /**
1244    * Dynamically create tokens and assign them to the investor.
1245    */
1246   function assignTokens(address receiver, uint tokenAmount) private {
1247     MintableTokenExt mintableToken = MintableTokenExt(token);
1248     mintableToken.mint(receiver, tokenAmount);
1249   }
1250 
1251   function setMaximumSellableTokens(uint tokens) onlyOwner {
1252     if (finalized) throw;
1253 
1254     if (!isUpdatable) throw;
1255 
1256     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1257     if (lastCrowdsaleCntrct.finalized()) throw;
1258 
1259     maximumSellableTokens = tokens;
1260     MaximumSellableTokensChanged(maximumSellableTokens);
1261   }
1262 }