1 // Created using Token Wizard https://github.com/poanetwork/token-wizard by POA Network 
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
234   address public tier;
235 
236   /** Interface declaration. */
237   function isPricingStrategy() public constant returns (bool) {
238     return true;
239   }
240 
241   /** Self check if all references are correctly set.
242    *
243    * Checks that pricing strategy matches crowdsale parameters.
244    */
245   function isSane(address crowdsale) public constant returns (bool) {
246     return true;
247   }
248 
249   /**
250    * @dev Pricing tells if this is a presale purchase or not.
251      @param purchaser Address of the purchaser
252      @return False by default, true if a presale purchaser
253    */
254   function isPresalePurchase(address purchaser) public constant returns (bool) {
255     return false;
256   }
257 
258   /* How many weis one token costs */
259   function updateRate(uint newOneTokenInWei) public;
260 
261   /**
262    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
263    *
264    *
265    * @param value - What is the value of the transaction send in as wei
266    * @param tokensSold - how much tokens have been sold this far
267    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
268    * @param msgSender - who is the investor of this transaction
269    * @param decimals - how many decimal units the token has
270    * @return Amount of tokens the investor receives
271    */
272   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
273 }
274 
275 /**
276  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
277  *
278  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
279  */
280 
281 
282 
283 /**
284  * Finalize agent defines what happens at the end of succeseful crowdsale.
285  *
286  * - Allocate tokens for founders, bounties and community
287  * - Make tokens transferable
288  * - etc.
289  */
290 contract FinalizeAgent {
291 
292   bool public reservedTokensAreDistributed = false;
293 
294   function isFinalizeAgent() public constant returns(bool) {
295     return true;
296   }
297 
298   /** Return true if we can run finalizeCrowdsale() properly.
299    *
300    * This is a safety check function that doesn't allow crowdsale to begin
301    * unless the finalizer has been set up properly.
302    */
303   function isSane() public constant returns (bool);
304 
305   function distributeReservedTokens(uint reservedTokensDistributionBatch);
306 
307   /** Called once by crowdsale finalize() if the sale was success. */
308   function finalizeCrowdsale();
309 
310 }
311 /**
312  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
313  *
314  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
315  */
316 
317 
318 
319 
320 
321 
322 
323 
324 
325 /**
326  * @title ERC20 interface
327  * @dev see https://github.com/ethereum/EIPs/issues/20
328  */
329 contract ERC20 is ERC20Basic {
330   function allowance(address owner, address spender) public constant returns (uint256);
331   function transferFrom(address from, address to, uint256 value) public returns (bool);
332   function approve(address spender, uint256 value) public returns (bool);
333   event Approval(address indexed owner, address indexed spender, uint256 value);
334 }
335 
336 
337 /**
338  * A token that defines fractional units as decimals.
339  */
340 contract FractionalERC20Ext is ERC20 {
341 
342   uint public decimals;
343   uint public minCap;
344 
345 }
346 
347 
348 
349 /**
350  * Abstract base contract for token sales.
351  *
352  * Handle
353  * - start and end dates
354  * - accepting investments
355  * - minimum funding goal and refund
356  * - various statistics during the crowdfund
357  * - different pricing strategies
358  * - different investment policies (require server side customer id, allow only whitelisted addresses)
359  *
360  */
361 contract CrowdsaleExt is Haltable {
362 
363   /* Max investment count when we are still allowed to change the multisig address */
364   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
365 
366   using SafeMathLibExt for uint;
367 
368   /* The token we are selling */
369   FractionalERC20Ext public token;
370 
371   /* How we are going to price our offering */
372   PricingStrategy public pricingStrategy;
373 
374   /* Post-success callback */
375   FinalizeAgent public finalizeAgent;
376 
377   /* name of the crowdsale tier */
378   string public name;
379 
380   /* tokens will be transfered from this address */
381   address public multisigWallet;
382 
383   /* if the funding goal is not reached, investors may withdraw their funds */
384   uint public minimumFundingGoal;
385 
386   /* the UNIX timestamp start date of the crowdsale */
387   uint public startsAt;
388 
389   /* the UNIX timestamp end date of the crowdsale */
390   uint public endsAt;
391 
392   /* the number of tokens already sold through this contract*/
393   uint public tokensSold = 0;
394 
395   /* How many wei of funding we have raised */
396   uint public weiRaised = 0;
397 
398   /* How many distinct addresses have invested */
399   uint public investorCount = 0;
400 
401   /* Has this crowdsale been finalized */
402   bool public finalized;
403 
404   bool public isWhiteListed;
405 
406   address[] public joinedCrowdsales;
407   uint8 public joinedCrowdsalesLen = 0;
408   uint8 public joinedCrowdsalesLenMax = 50;
409   struct JoinedCrowdsaleStatus {
410     bool isJoined;
411     uint8 position;
412   }
413   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
414 
415   /** How much ETH each address has invested to this crowdsale */
416   mapping (address => uint256) public investedAmountOf;
417 
418   /** How much tokens this crowdsale has credited for each investor address */
419   mapping (address => uint256) public tokenAmountOf;
420 
421   struct WhiteListData {
422     bool status;
423     uint minCap;
424     uint maxCap;
425   }
426 
427   //is crowdsale updatable
428   bool public isUpdatable;
429 
430   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
431   mapping (address => WhiteListData) public earlyParticipantWhitelist;
432 
433   /** List of whitelisted addresses */
434   address[] public whitelistedParticipants;
435 
436   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
437   uint public ownerTestValue;
438 
439   /** State machine
440    *
441    * - Preparing: All contract initialization calls and variables have not been set yet
442    * - Prefunding: We have not passed start time yet
443    * - Funding: Active crowdsale
444    * - Success: Minimum funding goal reached
445    * - Failure: Minimum funding goal not reached before ending time
446    * - Finalized: The finalized has been called and succesfully executed
447    */
448   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
449 
450   // A new investment was made
451   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
452 
453   // Address early participation whitelist status changed
454   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
455   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
456 
457   // Crowdsale start time has been changed
458   event StartsAtChanged(uint newStartsAt);
459 
460   // Crowdsale end time has been changed
461   event EndsAtChanged(uint newEndsAt);
462 
463   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
464 
465     owner = msg.sender;
466 
467     name = _name;
468 
469     token = FractionalERC20Ext(_token);
470 
471     setPricingStrategy(_pricingStrategy);
472 
473     multisigWallet = _multisigWallet;
474     if(multisigWallet == 0) {
475         throw;
476     }
477 
478     if(_start == 0) {
479         throw;
480     }
481 
482     startsAt = _start;
483 
484     if(_end == 0) {
485         throw;
486     }
487 
488     endsAt = _end;
489 
490     // Don't mess the dates
491     if(startsAt >= endsAt) {
492         throw;
493     }
494 
495     // Minimum funding goal can be zero
496     minimumFundingGoal = _minimumFundingGoal;
497 
498     isUpdatable = _isUpdatable;
499 
500     isWhiteListed = _isWhiteListed;
501   }
502 
503   /**
504    * Don't expect to just send in money and get tokens.
505    */
506   function() payable {
507     throw;
508   }
509 
510   /**
511    * Make an investment.
512    *
513    * Crowdsale must be running for one to invest.
514    * We must have not pressed the emergency brake.
515    *
516    * @param receiver The Ethereum address who receives the tokens
517    * @param customerId (optional) UUID v4 to track the successful payments on the server side
518    *
519    */
520   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
521 
522     // Determine if it's a good time to accept investment from this participant
523     if(getState() == State.PreFunding) {
524       // Are we whitelisted for early deposit
525       throw;
526     } else if(getState() == State.Funding) {
527       // Retail participants can only come in when the crowdsale is running
528       // pass
529       if(isWhiteListed) {
530         if(!earlyParticipantWhitelist[receiver].status) {
531           throw;
532         }
533       }
534     } else {
535       // Unwanted state
536       throw;
537     }
538 
539     uint weiAmount = msg.value;
540 
541     // Account presale sales separately, so that they do not count against pricing tranches
542     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
543 
544     if(tokenAmount == 0) {
545       // Dust transaction
546       throw;
547     }
548 
549     if(isWhiteListed) {
550       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
551         // tokenAmount < minCap for investor
552         throw;
553       }
554       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
555         // tokenAmount > maxCap for investor
556         throw;
557       }
558 
559       // Check that we did not bust the investor's cap
560       if (isBreakingInvestorCap(receiver, tokenAmount)) {
561         throw;
562       }
563     } else {
564       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
565         throw;
566       }
567     }
568 
569     if(investedAmountOf[receiver] == 0) {
570        // A new investor
571        investorCount++;
572     }
573 
574     // Update investor
575     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
576     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
577 
578     // Update totals
579     weiRaised = weiRaised.plus(weiAmount);
580     tokensSold = tokensSold.plus(tokenAmount);
581 
582     // Check that we did not bust the cap
583     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
584       throw;
585     }
586 
587     assignTokens(receiver, tokenAmount);
588 
589     // Pocket the money
590     if(!multisigWallet.send(weiAmount)) throw;
591 
592     if (isWhiteListed) {
593       updateInheritedEarlyParticipantWhitelist(tokenAmount);
594     }
595 
596     // Tell us invest was success
597     Invested(receiver, weiAmount, tokenAmount, customerId);
598   }
599 
600   /**
601    * Allow anonymous contributions to this crowdsale.
602    */
603   function invest(address addr) public payable {
604     investInternal(addr, 0);
605   }
606 
607   /**
608    * The basic entry point to participate the crowdsale process.
609    *
610    * Pay for funding, get invested tokens back in the sender address.
611    */
612   function buy() public payable {
613     invest(msg.sender);
614   }
615 
616   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
617     // Already finalized
618     if(finalized) {
619       throw;
620     }
621 
622     // Finalizing is optional. We only call it if we are given a finalizing agent.
623     if(address(finalizeAgent) != address(0)) {
624       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
625     }
626   }
627 
628   function areReservedTokensDistributed() public constant returns (bool) {
629     return finalizeAgent.reservedTokensAreDistributed();
630   }
631 
632   function canDistributeReservedTokens() public constant returns(bool) {
633     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
634     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
635     return false;
636   }
637 
638   /**
639    * Finalize a succcesful crowdsale.
640    *
641    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
642    */
643   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
644 
645     // Already finalized
646     if(finalized) {
647       throw;
648     }
649 
650     // Finalizing is optional. We only call it if we are given a finalizing agent.
651     if(address(finalizeAgent) != address(0)) {
652       finalizeAgent.finalizeCrowdsale();
653     }
654 
655     finalized = true;
656   }
657 
658   /**
659    * Allow to (re)set finalize agent.
660    *
661    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
662    */
663   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
664     assert(address(addr) != address(0));
665     assert(address(finalizeAgent) == address(0));
666     finalizeAgent = addr;
667 
668     // Don't allow setting bad agent
669     if(!finalizeAgent.isFinalizeAgent()) {
670       throw;
671     }
672   }
673 
674   /**
675    * Allow addresses to do early participation.
676    */
677   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
678     if (!isWhiteListed) throw;
679     assert(addr != address(0));
680     assert(maxCap > 0);
681     assert(minCap <= maxCap);
682     assert(now <= endsAt);
683 
684     if (earlyParticipantWhitelist[addr].maxCap == 0) {
685       whitelistedParticipants.push(addr);
686       Whitelisted(addr, status, minCap, maxCap);
687     } else {
688       WhitelistItemChanged(addr, status, minCap, maxCap);
689     }
690 
691     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
692   }
693 
694   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
695     if (!isWhiteListed) throw;
696     assert(now <= endsAt);
697     assert(addrs.length == statuses.length);
698     assert(statuses.length == minCaps.length);
699     assert(minCaps.length == maxCaps.length);
700     for (uint iterator = 0; iterator < addrs.length; iterator++) {
701       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
702     }
703   }
704 
705   function updateInheritedEarlyParticipantWhitelist(uint tokensBought) private {
706     if (!isWhiteListed) throw;
707     if (tokensBought < earlyParticipantWhitelist[msg.sender].minCap) throw;
708 
709     uint8 tierPosition = getTierPosition(this);
710 
711     for (uint8 j = tierPosition; j < joinedCrowdsalesLen; j++) {
712       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
713       crowdsale.updateEarlyParticipantWhitelist(msg.sender, tokensBought);
714     }
715   }
716 
717   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
718     if (!isWhiteListed) throw;
719     assert(addr != address(0));
720     assert(now <= endsAt);
721     assert(isTierJoined(msg.sender));
722     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
723     //if (addr != msg.sender && contractAddr != msg.sender) throw;
724     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
725     newMaxCap = newMaxCap.minus(tokensBought);
726     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
727   }
728 
729   function whitelistedParticipantsLength() public constant returns (uint) {
730     return whitelistedParticipants.length;
731   }
732 
733   function isTierJoined(address addr) public constant returns(bool) {
734     return joinedCrowdsaleState[addr].isJoined;
735   }
736 
737   function getTierPosition(address addr) public constant returns(uint8) {
738     return joinedCrowdsaleState[addr].position;
739   }
740 
741   function getLastTier() public constant returns(address) {
742     if (joinedCrowdsalesLen > 0)
743       return joinedCrowdsales[joinedCrowdsalesLen - 1];
744     else
745       return address(0);
746   }
747 
748   function setJoinedCrowdsales(address addr) private onlyOwner {
749     assert(addr != address(0));
750     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
751     assert(!isTierJoined(addr));
752     joinedCrowdsales.push(addr);
753     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
754       isJoined: true,
755       position: joinedCrowdsalesLen
756     });
757     joinedCrowdsalesLen++;
758   }
759 
760   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
761     assert(addrs.length > 0);
762     assert(joinedCrowdsalesLen == 0);
763     assert(addrs.length <= joinedCrowdsalesLenMax);
764     for (uint8 iter = 0; iter < addrs.length; iter++) {
765       setJoinedCrowdsales(addrs[iter]);
766     }
767   }
768 
769   function setStartsAt(uint time) onlyOwner {
770     assert(!finalized);
771     assert(isUpdatable);
772     assert(now <= time); // Don't change past
773     assert(time <= endsAt);
774     assert(now <= startsAt);
775 
776     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
777     if (lastTierCntrct.finalized()) throw;
778 
779     uint8 tierPosition = getTierPosition(this);
780 
781     //start time should be greater then end time of previous tiers
782     for (uint8 j = 0; j < tierPosition; j++) {
783       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
784       assert(time >= crowdsale.endsAt());
785     }
786 
787     startsAt = time;
788     StartsAtChanged(startsAt);
789   }
790 
791   /**
792    * Allow crowdsale owner to close early or extend the crowdsale.
793    *
794    * This is useful e.g. for a manual soft cap implementation:
795    * - after X amount is reached determine manual closing
796    *
797    * This may put the crowdsale to an invalid state,
798    * but we trust owners know what they are doing.
799    *
800    */
801   function setEndsAt(uint time) public onlyOwner {
802     assert(!finalized);
803     assert(isUpdatable);
804     assert(now <= time);// Don't change past
805     assert(startsAt <= time);
806     assert(now <= endsAt);
807 
808     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
809     if (lastTierCntrct.finalized()) throw;
810 
811 
812     uint8 tierPosition = getTierPosition(this);
813 
814     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
815       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
816       assert(time <= crowdsale.startsAt());
817     }
818 
819     endsAt = time;
820     EndsAtChanged(endsAt);
821   }
822 
823   /**
824    * Allow to (re)set pricing strategy.
825    *
826    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
827    */
828   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
829     assert(address(_pricingStrategy) != address(0));
830     assert(address(pricingStrategy) == address(0));
831     pricingStrategy = _pricingStrategy;
832 
833     // Don't allow setting bad agent
834     if(!pricingStrategy.isPricingStrategy()) {
835       throw;
836     }
837   }
838 
839   /**
840    * Allow to change the team multisig address in the case of emergency.
841    *
842    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
843    * (we have done only few test transactions). After the crowdsale is going
844    * then multisig address stays locked for the safety reasons.
845    */
846   function setMultisig(address addr) public onlyOwner {
847 
848     // Change
849     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
850       throw;
851     }
852 
853     multisigWallet = addr;
854   }
855 
856   /**
857    * @return true if the crowdsale has raised enough money to be a successful.
858    */
859   function isMinimumGoalReached() public constant returns (bool reached) {
860     return weiRaised >= minimumFundingGoal;
861   }
862 
863   /**
864    * Check if the contract relationship looks good.
865    */
866   function isFinalizerSane() public constant returns (bool sane) {
867     return finalizeAgent.isSane();
868   }
869 
870   /**
871    * Check if the contract relationship looks good.
872    */
873   function isPricingSane() public constant returns (bool sane) {
874     return pricingStrategy.isSane(address(this));
875   }
876 
877   /**
878    * Crowdfund state machine management.
879    *
880    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
881    */
882   function getState() public constant returns (State) {
883     if(finalized) return State.Finalized;
884     else if (address(finalizeAgent) == 0) return State.Preparing;
885     else if (!finalizeAgent.isSane()) return State.Preparing;
886     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
887     else if (block.timestamp < startsAt) return State.PreFunding;
888     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
889     else if (isMinimumGoalReached()) return State.Success;
890     else return State.Failure;
891   }
892 
893   /** Interface marker. */
894   function isCrowdsale() public constant returns (bool) {
895     return true;
896   }
897 
898   //
899   // Modifiers
900   //
901 
902   /** Modified allowing execution only if the crowdsale is currently running.  */
903   modifier inState(State state) {
904     if(getState() != state) throw;
905     _;
906   }
907 
908 
909   //
910   // Abstract functions
911   //
912 
913   /**
914    * Check if the current invested breaks our cap rules.
915    *
916    *
917    * The child contract must define their own cap setting rules.
918    * We allow a lot of flexibility through different capping strategies (ETH, token count)
919    * Called from invest().
920    *
921    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
922    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
923    * @param weiRaisedTotal What would be our total raised balance after this transaction
924    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
925    *
926    * @return true if taking this investment would break our cap rules
927    */
928   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
929 
930   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
931 
932   /**
933    * Check if the current crowdsale is full and we can no longer sell any tokens.
934    */
935   function isCrowdsaleFull() public constant returns (bool);
936 
937   /**
938    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
939    */
940   function assignTokens(address receiver, uint tokenAmount) private;
941 }
942 
943 /**
944  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
945  *
946  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
947  */
948 
949 
950 
951 /**
952  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
953  *
954  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
955  */
956 
957 
958 
959 
960 
961 
962 
963 
964 /**
965  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
966  *
967  * Based on code by FirstBlood:
968  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
969  */
970 contract StandardToken is ERC20, SafeMath {
971 
972   /* Token supply got increased and a new owner received these tokens */
973   event Minted(address receiver, uint amount);
974 
975   /* Actual balances of token holders */
976   mapping(address => uint) balances;
977 
978   /* approve() allowances */
979   mapping (address => mapping (address => uint)) allowed;
980 
981   /* Interface declaration */
982   function isToken() public constant returns (bool weAre) {
983     return true;
984   }
985 
986   function transfer(address _to, uint _value) returns (bool success) {
987     balances[msg.sender] = safeSub(balances[msg.sender], _value);
988     balances[_to] = safeAdd(balances[_to], _value);
989     Transfer(msg.sender, _to, _value);
990     return true;
991   }
992 
993   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
994     uint _allowance = allowed[_from][msg.sender];
995 
996     balances[_to] = safeAdd(balances[_to], _value);
997     balances[_from] = safeSub(balances[_from], _value);
998     allowed[_from][msg.sender] = safeSub(_allowance, _value);
999     Transfer(_from, _to, _value);
1000     return true;
1001   }
1002 
1003   function balanceOf(address _owner) constant returns (uint balance) {
1004     return balances[_owner];
1005   }
1006 
1007   function approve(address _spender, uint _value) returns (bool success) {
1008 
1009     // To change the approve amount you first have to reduce the addresses`
1010     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1011     //  already 0 to mitigate the race condition described here:
1012     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1013     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1014 
1015     allowed[msg.sender][_spender] = _value;
1016     Approval(msg.sender, _spender, _value);
1017     return true;
1018   }
1019 
1020   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1021     return allowed[_owner][_spender];
1022   }
1023 
1024 }
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * A token that can increase its supply by another contract.
1032  *
1033  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1034  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1035  *
1036  */
1037 contract MintableTokenExt is StandardToken, Ownable {
1038 
1039   using SafeMathLibExt for uint;
1040 
1041   bool public mintingFinished = false;
1042 
1043   /** List of agents that are allowed to create new tokens */
1044   mapping (address => bool) public mintAgents;
1045 
1046   event MintingAgentChanged(address addr, bool state  );
1047 
1048   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1049   * For example, for reserved tokens in percents 2.54%
1050   * inPercentageUnit = 254
1051   * inPercentageDecimals = 2
1052   */
1053   struct ReservedTokensData {
1054     uint inTokens;
1055     uint inPercentageUnit;
1056     uint inPercentageDecimals;
1057     bool isReserved;
1058     bool isDistributed;
1059   }
1060 
1061   mapping (address => ReservedTokensData) public reservedTokensList;
1062   address[] public reservedTokensDestinations;
1063   uint public reservedTokensDestinationsLen = 0;
1064   bool reservedTokensDestinationsAreSet = false;
1065 
1066   modifier onlyMintAgent() {
1067     // Only crowdsale contracts are allowed to mint new tokens
1068     if(!mintAgents[msg.sender]) {
1069         throw;
1070     }
1071     _;
1072   }
1073 
1074   /** Make sure we are not done yet. */
1075   modifier canMint() {
1076     if(mintingFinished) throw;
1077     _;
1078   }
1079 
1080   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1081     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1082     reservedTokensData.isDistributed = true;
1083   }
1084 
1085   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1086     return reservedTokensList[addr].isReserved;
1087   }
1088 
1089   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1090     return reservedTokensList[addr].isDistributed;
1091   }
1092 
1093   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1094     return reservedTokensList[addr].inTokens;
1095   }
1096 
1097   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1098     return reservedTokensList[addr].inPercentageUnit;
1099   }
1100 
1101   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1102     return reservedTokensList[addr].inPercentageDecimals;
1103   }
1104 
1105   function setReservedTokensListMultiple(
1106     address[] addrs, 
1107     uint[] inTokens, 
1108     uint[] inPercentageUnit, 
1109     uint[] inPercentageDecimals
1110   ) public canMint onlyOwner {
1111     assert(!reservedTokensDestinationsAreSet);
1112     assert(addrs.length == inTokens.length);
1113     assert(inTokens.length == inPercentageUnit.length);
1114     assert(inPercentageUnit.length == inPercentageDecimals.length);
1115     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1116       if (addrs[iterator] != address(0)) {
1117         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1118       }
1119     }
1120     reservedTokensDestinationsAreSet = true;
1121   }
1122 
1123   /**
1124    * Create new tokens and allocate them to an address..
1125    *
1126    * Only callably by a crowdsale contract (mint agent).
1127    */
1128   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1129     totalSupply = totalSupply.plus(amount);
1130     balances[receiver] = balances[receiver].plus(amount);
1131 
1132     // This will make the mint transaction apper in EtherScan.io
1133     // We can remove this after there is a standardized minting event
1134     Transfer(0, receiver, amount);
1135   }
1136 
1137   /**
1138    * Owner can allow a crowdsale contract to mint new tokens.
1139    */
1140   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1141     mintAgents[addr] = state;
1142     MintingAgentChanged(addr, state);
1143   }
1144 
1145   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1146     assert(addr != address(0));
1147     if (!isAddressReserved(addr)) {
1148       reservedTokensDestinations.push(addr);
1149       reservedTokensDestinationsLen++;
1150     }
1151 
1152     reservedTokensList[addr] = ReservedTokensData({
1153       inTokens: inTokens, 
1154       inPercentageUnit: inPercentageUnit, 
1155       inPercentageDecimals: inPercentageDecimals,
1156       isReserved: true,
1157       isDistributed: false
1158     });
1159   }
1160 }
1161 
1162 /**
1163  * ICO crowdsale contract that is capped by amout of tokens.
1164  *
1165  * - Tokens are dynamically created during the crowdsale
1166  *
1167  *
1168  */
1169 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1170 
1171   /* Maximum amount of tokens this crowdsale can sell. */
1172   uint public maximumSellableTokens;
1173 
1174   function MintedTokenCappedCrowdsaleExt(
1175     string _name, 
1176     address _token, 
1177     PricingStrategy _pricingStrategy, 
1178     address _multisigWallet, 
1179     uint _start, uint _end, 
1180     uint _minimumFundingGoal, 
1181     uint _maximumSellableTokens, 
1182     bool _isUpdatable, 
1183     bool _isWhiteListed
1184   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1185     maximumSellableTokens = _maximumSellableTokens;
1186   }
1187 
1188   // Crowdsale maximumSellableTokens has been changed
1189   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1190 
1191   /**
1192    * Called from invest() to confirm if the curret investment does not break our cap rule.
1193    */
1194   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1195     return tokensSoldTotal > maximumSellableTokens;
1196   }
1197 
1198   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1199     assert(isWhiteListed);
1200     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1201     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1202   }
1203 
1204   function isCrowdsaleFull() public constant returns (bool) {
1205     return tokensSold >= maximumSellableTokens;
1206   }
1207 
1208   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1209     assert(!finalized);
1210     assert(isUpdatable);
1211     assert(now <= startsAt);
1212 
1213     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1214     assert(!lastTierCntrct.finalized());
1215 
1216     maximumSellableTokens = tokens;
1217     MaximumSellableTokensChanged(maximumSellableTokens);
1218   }
1219 
1220   function updateRate(uint newOneTokenInWei) public onlyOwner {
1221     assert(!finalized);
1222     assert(isUpdatable);
1223     assert(now <= startsAt);
1224 
1225     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1226     assert(!lastTierCntrct.finalized());
1227 
1228     pricingStrategy.updateRate(newOneTokenInWei);
1229   }
1230 
1231   /**
1232    * Dynamically create tokens and assign them to the investor.
1233    */
1234   function assignTokens(address receiver, uint tokenAmount) private {
1235     MintableTokenExt mintableToken = MintableTokenExt(token);
1236     mintableToken.mint(receiver, tokenAmount);
1237   }
1238 }