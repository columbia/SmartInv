1 // Created using ICO Wizard https://github.com/poanetwork/ico-wizard by POA Network 
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
369   /* name of the crowdsale tier */
370   string public name;
371 
372   /* tokens will be transfered from this address */
373   address public multisigWallet;
374 
375   /* if the funding goal is not reached, investors may withdraw their funds */
376   uint public minimumFundingGoal;
377 
378   /* the UNIX timestamp start date of the crowdsale */
379   uint public startsAt;
380 
381   /* the UNIX timestamp end date of the crowdsale */
382   uint public endsAt;
383 
384   /* the number of tokens already sold through this contract*/
385   uint public tokensSold = 0;
386 
387   /* How many wei of funding we have raised */
388   uint public weiRaised = 0;
389 
390   /* Calculate incoming funds from presale contracts and addresses */
391   uint public presaleWeiRaised = 0;
392 
393   /* How many distinct addresses have invested */
394   uint public investorCount = 0;
395 
396   /* How much wei we have returned back to the contract after a failed crowdfund. */
397   uint public loadedRefund = 0;
398 
399   /* How much wei we have given back to investors.*/
400   uint public weiRefunded = 0;
401 
402   /* Has this crowdsale been finalized */
403   bool public finalized;
404 
405   /* Do we need to have unique contributor id for each customer */
406   bool public requireCustomerId;
407 
408   bool public isWhiteListed;
409 
410   address[] public joinedCrowdsales;
411   uint public joinedCrowdsalesLen = 0;
412 
413   address public lastCrowdsale;
414 
415   /**
416     * Do we verify that contributor has been cleared on the server side (accredited investors only).
417     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
418     */
419   bool public requiredSignedAddress;
420 
421   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
422   address public signerAddress;
423 
424   /** How much ETH each address has invested to this crowdsale */
425   mapping (address => uint256) public investedAmountOf;
426 
427   /** How much tokens this crowdsale has credited for each investor address */
428   mapping (address => uint256) public tokenAmountOf;
429 
430   struct WhiteListData {
431     bool status;
432     uint minCap;
433     uint maxCap;
434   }
435 
436   //is crowdsale updatable
437   bool public isUpdatable;
438 
439   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
440   mapping (address => WhiteListData) public earlyParticipantWhitelist;
441 
442   /** List of whitelisted addresses */
443   address[] public whitelistedParticipants;
444 
445   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
446   uint public ownerTestValue;
447 
448   /** State machine
449    *
450    * - Preparing: All contract initialization calls and variables have not been set yet
451    * - Prefunding: We have not passed start time yet
452    * - Funding: Active crowdsale
453    * - Success: Minimum funding goal reached
454    * - Failure: Minimum funding goal not reached before ending time
455    * - Finalized: The finalized has been called and succesfully executed
456    * - Refunding: Refunds are loaded on the contract for reclaim.
457    */
458   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
459 
460   // A new investment was made
461   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
462 
463   // Refund was processed for a contributor
464   event Refund(address investor, uint weiAmount);
465 
466   // The rules were changed what kind of investments we accept
467   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
468 
469   // Address early participation whitelist status changed
470   event Whitelisted(address addr, bool status);
471 
472   // Crowdsale start time has been changed
473   event StartsAtChanged(uint newStartsAt);
474 
475   // Crowdsale end time has been changed
476   event EndsAtChanged(uint newEndsAt);
477 
478   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
479 
480     owner = msg.sender;
481 
482     name = _name;
483 
484     token = FractionalERC20Ext(_token);
485 
486     setPricingStrategy(_pricingStrategy);
487 
488     multisigWallet = _multisigWallet;
489     if(multisigWallet == 0) {
490         throw;
491     }
492 
493     if(_start == 0) {
494         throw;
495     }
496 
497     startsAt = _start;
498 
499     if(_end == 0) {
500         throw;
501     }
502 
503     endsAt = _end;
504 
505     // Don't mess the dates
506     if(startsAt >= endsAt) {
507         throw;
508     }
509 
510     // Minimum funding goal can be zero
511     minimumFundingGoal = _minimumFundingGoal;
512 
513     isUpdatable = _isUpdatable;
514 
515     isWhiteListed = _isWhiteListed;
516   }
517 
518   /**
519    * Don't expect to just send in money and get tokens.
520    */
521   function() payable {
522     throw;
523   }
524 
525   /**
526    * Make an investment.
527    *
528    * Crowdsale must be running for one to invest.
529    * We must have not pressed the emergency brake.
530    *
531    * @param receiver The Ethereum address who receives the tokens
532    * @param customerId (optional) UUID v4 to track the successful payments on the server side
533    *
534    */
535   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
536 
537     // Determine if it's a good time to accept investment from this participant
538     if(getState() == State.PreFunding) {
539       // Are we whitelisted for early deposit
540       throw;
541     } else if(getState() == State.Funding) {
542       // Retail participants can only come in when the crowdsale is running
543       // pass
544       if(isWhiteListed) {
545         if(!earlyParticipantWhitelist[receiver].status) {
546           throw;
547         }
548       }
549     } else {
550       // Unwanted state
551       throw;
552     }
553 
554     uint weiAmount = msg.value;
555 
556     // Account presale sales separately, so that they do not count against pricing tranches
557     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
558 
559     if(tokenAmount == 0) {
560       // Dust transaction
561       throw;
562     }
563 
564     if(isWhiteListed) {
565       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
566         // tokenAmount < minCap for investor
567         throw;
568       }
569       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
570         // tokenAmount > maxCap for investor
571         throw;
572       }
573 
574       // Check that we did not bust the investor's cap
575       if (isBreakingInvestorCap(receiver, tokenAmount)) {
576         throw;
577       }
578     } else {
579       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
580         throw;
581       }
582     }
583 
584     if(investedAmountOf[receiver] == 0) {
585        // A new investor
586        investorCount++;
587     }
588 
589     // Update investor
590     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
591     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
592 
593     // Update totals
594     weiRaised = weiRaised.plus(weiAmount);
595     tokensSold = tokensSold.plus(tokenAmount);
596 
597     if(pricingStrategy.isPresalePurchase(receiver)) {
598         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
599     }
600 
601     // Check that we did not bust the cap
602     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
603       throw;
604     }
605 
606     assignTokens(receiver, tokenAmount);
607 
608     // Pocket the money
609     if(!multisigWallet.send(weiAmount)) throw;
610 
611     if (isWhiteListed) {
612       uint num = 0;
613       for (var i = 0; i < joinedCrowdsalesLen; i++) {
614         if (this == joinedCrowdsales[i])
615           num = i;
616       }
617 
618       if (num + 1 < joinedCrowdsalesLen) {
619         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
620           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
621           crowdsale.updateEarlyParticipantWhitelist(msg.sender, this, tokenAmount);
622         }
623       }
624     }
625 
626     // Tell us invest was success
627     Invested(receiver, weiAmount, tokenAmount, customerId);
628   }
629 
630   /**
631    * Preallocate tokens for the early investors.
632    *
633    * Preallocated tokens have been sold before the actual crowdsale opens.
634    * This function mints the tokens and moves the crowdsale needle.
635    *
636    * Investor count is not handled; it is assumed this goes for multiple investors
637    * and the token distribution happens outside the smart contract flow.
638    *
639    * No money is exchanged, as the crowdsale team already have received the payment.
640    *
641    * @param fullTokens tokens as full tokens - decimal places added internally
642    * @param weiPrice Price of a single full token in wei
643    *
644    */
645   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
646 
647     uint tokenAmount = fullTokens * 10**token.decimals();
648     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
649 
650     weiRaised = weiRaised.plus(weiAmount);
651     tokensSold = tokensSold.plus(tokenAmount);
652 
653     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
654     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
655 
656     assignTokens(receiver, tokenAmount);
657 
658     // Tell us invest was success
659     Invested(receiver, weiAmount, tokenAmount, 0);
660   }
661 
662   /**
663    * Allow anonymous contributions to this crowdsale.
664    */
665   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
666      bytes32 hash = sha256(addr);
667      if (ecrecover(hash, v, r, s) != signerAddress) throw;
668      if(customerId == 0) throw;  // UUIDv4 sanity check
669      investInternal(addr, customerId);
670   }
671 
672   /**
673    * Track who is the customer making the payment so we can send thank you email.
674    */
675   function investWithCustomerId(address addr, uint128 customerId) public payable {
676     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
677     if(customerId == 0) throw;  // UUIDv4 sanity check
678     investInternal(addr, customerId);
679   }
680 
681   /**
682    * Allow anonymous contributions to this crowdsale.
683    */
684   function invest(address addr) public payable {
685     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
686     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
687     investInternal(addr, 0);
688   }
689 
690   /**
691    * Invest to tokens, recognize the payer and clear his address.
692    *
693    */
694   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
695     investWithSignedAddress(msg.sender, customerId, v, r, s);
696   }
697 
698   /**
699    * Invest to tokens, recognize the payer.
700    *
701    */
702   function buyWithCustomerId(uint128 customerId) public payable {
703     investWithCustomerId(msg.sender, customerId);
704   }
705 
706   /**
707    * The basic entry point to participate the crowdsale process.
708    *
709    * Pay for funding, get invested tokens back in the sender address.
710    */
711   function buy() public payable {
712     invest(msg.sender);
713   }
714 
715   /**
716    * Finalize a succcesful crowdsale.
717    *
718    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
719    */
720   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
721 
722     // Already finalized
723     if(finalized) {
724       throw;
725     }
726 
727     // Finalizing is optional. We only call it if we are given a finalizing agent.
728     if(address(finalizeAgent) != 0) {
729       finalizeAgent.finalizeCrowdsale();
730     }
731 
732     finalized = true;
733   }
734 
735   /**
736    * Allow to (re)set finalize agent.
737    *
738    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
739    */
740   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
741     finalizeAgent = addr;
742 
743     // Don't allow setting bad agent
744     if(!finalizeAgent.isFinalizeAgent()) {
745       throw;
746     }
747   }
748 
749   /**
750    * Set policy do we need to have server-side customer ids for the investments.
751    *
752    */
753   function setRequireCustomerId(bool value) onlyOwner {
754     requireCustomerId = value;
755     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
756   }
757 
758   /**
759    * Set policy if all investors must be cleared on the server side first.
760    *
761    * This is e.g. for the accredited investor clearing.
762    *
763    */
764   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
765     requiredSignedAddress = value;
766     signerAddress = _signerAddress;
767     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
768   }
769 
770   /**
771    * Allow addresses to do early participation.
772    */
773   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
774     if (!isWhiteListed) throw;
775     assert(addr != address(0));
776     assert(maxCap > 0);
777     assert(minCap <= maxCap);
778 
779     if (earlyParticipantWhitelist[addr].maxCap == 0) {
780       earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
781       whitelistedParticipants.push(addr);
782       Whitelisted(addr, status);
783     }
784   }
785 
786   function setEarlyParticipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
787     if (!isWhiteListed) throw;
788     for (uint iterator = 0; iterator < addrs.length; iterator++) {
789       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
790     }
791   }
792 
793   function updateEarlyParticipantWhitelist(address addr, address contractAddr, uint tokensBought) {
794     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
795     if (!isWhiteListed) throw;
796     if (addr != msg.sender && contractAddr != msg.sender) throw;
797     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
798     newMaxCap = newMaxCap.minus(tokensBought);
799     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
800   }
801 
802   function updateJoinedCrowdsales(address addr) onlyOwner {
803     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
804   }
805 
806   function setLastCrowdsale(address addr) onlyOwner {
807     lastCrowdsale = addr;
808   }
809 
810   function clearJoinedCrowdsales() onlyOwner {
811     joinedCrowdsalesLen = 0;
812   }
813 
814   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
815     clearJoinedCrowdsales();
816     for (uint iter = 0; iter < addrs.length; iter++) {
817       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
818           joinedCrowdsales.length += 1;
819       }
820       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
821       if (iter == addrs.length - 1)
822         setLastCrowdsale(addrs[iter]);
823     }
824   }
825 
826   function setStartsAt(uint time) onlyOwner {
827     if (finalized) throw;
828 
829     if (!isUpdatable) throw;
830 
831     if(now > time) {
832       throw; // Don't change past
833     }
834 
835     if(time > endsAt) {
836       throw;
837     }
838 
839     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
840     if (lastCrowdsaleCntrct.finalized()) throw;
841 
842     startsAt = time;
843     StartsAtChanged(startsAt);
844   }
845 
846   /**
847    * Allow crowdsale owner to close early or extend the crowdsale.
848    *
849    * This is useful e.g. for a manual soft cap implementation:
850    * - after X amount is reached determine manual closing
851    *
852    * This may put the crowdsale to an invalid state,
853    * but we trust owners know what they are doing.
854    *
855    */
856   function setEndsAt(uint time) onlyOwner {
857     if (finalized) throw;
858 
859     if (!isUpdatable) throw;
860 
861     if(now > time) {
862       throw; // Don't change past
863     }
864 
865     if(startsAt > time) {
866       throw;
867     }
868 
869     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
870     if (lastCrowdsaleCntrct.finalized()) throw;
871 
872     uint num = 0;
873     for (var i = 0; i < joinedCrowdsalesLen; i++) {
874       if (this == joinedCrowdsales[i])
875         num = i;
876     }
877 
878     if (num + 1 < joinedCrowdsalesLen) {
879       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
880         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
881         if (time > crowdsale.startsAt()) throw;
882       }
883     }
884 
885     endsAt = time;
886     EndsAtChanged(endsAt);
887   }
888 
889   /**
890    * Allow to (re)set pricing strategy.
891    *
892    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
893    */
894   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
895     pricingStrategy = _pricingStrategy;
896 
897     // Don't allow setting bad agent
898     if(!pricingStrategy.isPricingStrategy()) {
899       throw;
900     }
901   }
902 
903   /**
904    * Allow to change the team multisig address in the case of emergency.
905    *
906    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
907    * (we have done only few test transactions). After the crowdsale is going
908    * then multisig address stays locked for the safety reasons.
909    */
910   function setMultisig(address addr) public onlyOwner {
911 
912     // Change
913     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
914       throw;
915     }
916 
917     multisigWallet = addr;
918   }
919 
920   /**
921    * Allow load refunds back on the contract for the refunding.
922    *
923    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
924    */
925   function loadRefund() public payable inState(State.Failure) {
926     if(msg.value == 0) throw;
927     loadedRefund = loadedRefund.plus(msg.value);
928   }
929 
930   /**
931    * Investors can claim refund.
932    *
933    * Note that any refunds from proxy buyers should be handled separately,
934    * and not through this contract.
935    */
936   function refund() public inState(State.Refunding) {
937     uint256 weiValue = investedAmountOf[msg.sender];
938     if (weiValue == 0) throw;
939     investedAmountOf[msg.sender] = 0;
940     weiRefunded = weiRefunded.plus(weiValue);
941     Refund(msg.sender, weiValue);
942     if (!msg.sender.send(weiValue)) throw;
943   }
944 
945   /**
946    * @return true if the crowdsale has raised enough money to be a successful.
947    */
948   function isMinimumGoalReached() public constant returns (bool reached) {
949     return weiRaised >= minimumFundingGoal;
950   }
951 
952   /**
953    * Check if the contract relationship looks good.
954    */
955   function isFinalizerSane() public constant returns (bool sane) {
956     return finalizeAgent.isSane();
957   }
958 
959   /**
960    * Check if the contract relationship looks good.
961    */
962   function isPricingSane() public constant returns (bool sane) {
963     return pricingStrategy.isSane(address(this));
964   }
965 
966   /**
967    * Crowdfund state machine management.
968    *
969    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
970    */
971   function getState() public constant returns (State) {
972     if(finalized) return State.Finalized;
973     else if (address(finalizeAgent) == 0) return State.Preparing;
974     else if (!finalizeAgent.isSane()) return State.Preparing;
975     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
976     else if (block.timestamp < startsAt) return State.PreFunding;
977     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
978     else if (isMinimumGoalReached()) return State.Success;
979     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
980     else return State.Failure;
981   }
982 
983   /** This is for manual testing of multisig wallet interaction */
984   function setOwnerTestValue(uint val) onlyOwner {
985     ownerTestValue = val;
986   }
987 
988   /** Interface marker. */
989   function isCrowdsale() public constant returns (bool) {
990     return true;
991   }
992 
993   //
994   // Modifiers
995   //
996 
997   /** Modified allowing execution only if the crowdsale is currently running.  */
998   modifier inState(State state) {
999     if(getState() != state) throw;
1000     _;
1001   }
1002 
1003 
1004   //
1005   // Abstract functions
1006   //
1007 
1008   /**
1009    * Check if the current invested breaks our cap rules.
1010    *
1011    *
1012    * The child contract must define their own cap setting rules.
1013    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1014    * Called from invest().
1015    *
1016    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1017    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1018    * @param weiRaisedTotal What would be our total raised balance after this transaction
1019    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1020    *
1021    * @return true if taking this investment would break our cap rules
1022    */
1023   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1024 
1025   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
1026 
1027   /**
1028    * Check if the current crowdsale is full and we can no longer sell any tokens.
1029    */
1030   function isCrowdsaleFull() public constant returns (bool);
1031 
1032   /**
1033    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1034    */
1035   function assignTokens(address receiver, uint tokenAmount) private;
1036 
1037   function whitelistedParticipantsLength() public constant returns (uint) {
1038     return whitelistedParticipants.length;
1039   }
1040 }
1041 
1042 /**
1043  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1044  *
1045  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1046  */
1047 
1048 
1049 
1050 /**
1051  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1052  *
1053  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1054  */
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 /**
1064  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
1065  *
1066  * Based on code by FirstBlood:
1067  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1068  */
1069 contract StandardToken is ERC20, SafeMath {
1070 
1071   /* Token supply got increased and a new owner received these tokens */
1072   event Minted(address receiver, uint amount);
1073 
1074   /* Actual balances of token holders */
1075   mapping(address => uint) balances;
1076 
1077   /* approve() allowances */
1078   mapping (address => mapping (address => uint)) allowed;
1079 
1080   /* Interface declaration */
1081   function isToken() public constant returns (bool weAre) {
1082     return true;
1083   }
1084 
1085   function transfer(address _to, uint _value) returns (bool success) {
1086     balances[msg.sender] = safeSub(balances[msg.sender], _value);
1087     balances[_to] = safeAdd(balances[_to], _value);
1088     Transfer(msg.sender, _to, _value);
1089     return true;
1090   }
1091 
1092   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
1093     uint _allowance = allowed[_from][msg.sender];
1094 
1095     balances[_to] = safeAdd(balances[_to], _value);
1096     balances[_from] = safeSub(balances[_from], _value);
1097     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1098     Transfer(_from, _to, _value);
1099     return true;
1100   }
1101 
1102   function balanceOf(address _owner) constant returns (uint balance) {
1103     return balances[_owner];
1104   }
1105 
1106   function approve(address _spender, uint _value) returns (bool success) {
1107 
1108     // To change the approve amount you first have to reduce the addresses`
1109     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1110     //  already 0 to mitigate the race condition described here:
1111     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1112     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1113 
1114     allowed[msg.sender][_spender] = _value;
1115     Approval(msg.sender, _spender, _value);
1116     return true;
1117   }
1118 
1119   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1120     return allowed[_owner][_spender];
1121   }
1122 
1123 }
1124 
1125 
1126 
1127 
1128 
1129 /**
1130  * A token that can increase its supply by another contract.
1131  *
1132  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1133  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1134  *
1135  */
1136 contract MintableTokenExt is StandardToken, Ownable {
1137 
1138   using SafeMathLibExt for uint;
1139 
1140   bool public mintingFinished = false;
1141 
1142   /** List of agents that are allowed to create new tokens */
1143   mapping (address => bool) public mintAgents;
1144 
1145   event MintingAgentChanged(address addr, bool state  );
1146 
1147   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1148   * For example, for reserved tokens in percents 2.54%
1149   * inPercentageUnit = 254
1150   * inPercentageDecimals = 2
1151   */
1152   struct ReservedTokensData {
1153     uint inTokens;
1154     uint inPercentageUnit;
1155     uint inPercentageDecimals;
1156   }
1157 
1158   mapping (address => ReservedTokensData) public reservedTokensList;
1159   address[] public reservedTokensDestinations;
1160   uint public reservedTokensDestinationsLen = 0;
1161 
1162   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) canMint onlyOwner {
1163     assert(addr != address(0));
1164     if (reservedTokensList[addr].inTokens == 0 && reservedTokensList[addr].inPercentageUnit == 0) {
1165       reservedTokensDestinations.push(addr);
1166       reservedTokensDestinationsLen++;
1167     }
1168 
1169     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
1170   }
1171 
1172   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
1173     return reservedTokensList[addr].inTokens;
1174   }
1175 
1176   function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
1177     return reservedTokensList[addr].inPercentageUnit;
1178   }
1179 
1180   function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
1181     return reservedTokensList[addr].inPercentageDecimals;
1182   }
1183 
1184   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) canMint onlyOwner {
1185     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1186       if (addrs[iterator] != address(0)) {
1187         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1188       }
1189     }
1190   }
1191 
1192   /**
1193    * Create new tokens and allocate them to an address..
1194    *
1195    * Only callably by a crowdsale contract (mint agent).
1196    */
1197   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1198     totalSupply = totalSupply.plus(amount);
1199     balances[receiver] = balances[receiver].plus(amount);
1200 
1201     // This will make the mint transaction apper in EtherScan.io
1202     // We can remove this after there is a standardized minting event
1203     Transfer(0, receiver, amount);
1204   }
1205 
1206   /**
1207    * Owner can allow a crowdsale contract to mint new tokens.
1208    */
1209   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1210     mintAgents[addr] = state;
1211     MintingAgentChanged(addr, state);
1212   }
1213 
1214   modifier onlyMintAgent() {
1215     // Only crowdsale contracts are allowed to mint new tokens
1216     if(!mintAgents[msg.sender]) {
1217         throw;
1218     }
1219     _;
1220   }
1221 
1222   /** Make sure we are not done yet. */
1223   modifier canMint() {
1224     if(mintingFinished) throw;
1225     _;
1226   }
1227 }
1228 
1229 
1230 /**
1231  * ICO crowdsale contract that is capped by amout of tokens.
1232  *
1233  * - Tokens are dynamically created during the crowdsale
1234  *
1235  *
1236  */
1237 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1238 
1239   /* Maximum amount of tokens this crowdsale can sell. */
1240   uint public maximumSellableTokens;
1241 
1242   function MintedTokenCappedCrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1243     maximumSellableTokens = _maximumSellableTokens;
1244   }
1245 
1246   // Crowdsale maximumSellableTokens has been changed
1247   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1248 
1249   /**
1250    * Called from invest() to confirm if the curret investment does not break our cap rule.
1251    */
1252   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1253     return tokensSoldTotal > maximumSellableTokens;
1254   }
1255 
1256   function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
1257     if (!isWhiteListed) throw;
1258     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1259     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1260   }
1261 
1262   function isCrowdsaleFull() public constant returns (bool) {
1263     return tokensSold >= maximumSellableTokens;
1264   }
1265 
1266   /**
1267    * Dynamically create tokens and assign them to the investor.
1268    */
1269   function assignTokens(address receiver, uint tokenAmount) private {
1270     MintableTokenExt mintableToken = MintableTokenExt(token);
1271     mintableToken.mint(receiver, tokenAmount);
1272   }
1273 
1274   function setMaximumSellableTokens(uint tokens) onlyOwner {
1275     if (finalized) throw;
1276 
1277     if (!isUpdatable) throw;
1278 
1279     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1280     if (lastCrowdsaleCntrct.finalized()) throw;
1281 
1282     maximumSellableTokens = tokens;
1283     MaximumSellableTokensChanged(maximumSellableTokens);
1284   }
1285 }