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
506   /*function() payable {
507     throw;
508   }*/
509   function () external payable {
510     invest(msg.sender);
511   }
512 
513   /**
514    * Make an investment.
515    *
516    * Crowdsale must be running for one to invest.
517    * We must have not pressed the emergency brake.
518    *
519    * @param receiver The Ethereum address who receives the tokens
520    * @param customerId (optional) UUID v4 to track the successful payments on the server side
521    *
522    */
523   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
524 
525     // Determine if it's a good time to accept investment from this participant
526     if(getState() == State.PreFunding) {
527       // Are we whitelisted for early deposit
528       throw;
529     } else if(getState() == State.Funding) {
530       // Retail participants can only come in when the crowdsale is running
531       // pass
532       if(isWhiteListed) {
533         if(!earlyParticipantWhitelist[receiver].status) {
534           throw;
535         }
536       }
537     } else {
538       // Unwanted state
539       throw;
540     }
541 
542     uint weiAmount = msg.value;
543 
544     // Account presale sales separately, so that they do not count against pricing tranches
545     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
546 
547     if(tokenAmount == 0) {
548       // Dust transaction
549       throw;
550     }
551 
552     if(isWhiteListed) {
553       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
554         // tokenAmount < minCap for investor
555         throw;
556       }
557 
558       // Check that we did not bust the investor's cap
559       if (isBreakingInvestorCap(receiver, tokenAmount)) {
560         throw;
561       }
562 
563       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
564     } else {
565       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
566         throw;
567       }
568     }
569 
570     if(investedAmountOf[receiver] == 0) {
571        // A new investor
572        investorCount++;
573     }
574 
575     // Update investor
576     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
577     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
578 
579     // Update totals
580     weiRaised = weiRaised.plus(weiAmount);
581     tokensSold = tokensSold.plus(tokenAmount);
582 
583     // Check that we did not bust the cap
584     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
585       throw;
586     }
587 
588     assignTokens(receiver, tokenAmount);
589 
590     // Pocket the money
591     if(!multisigWallet.send(weiAmount)) throw;
592 
593     // Tell us invest was success
594     Invested(receiver, weiAmount, tokenAmount, customerId);
595   }
596 
597   /**
598    * Allow anonymous contributions to this crowdsale.
599    */
600   function invest(address addr) public payable {
601     investInternal(addr, 0);
602   }
603 
604   /**
605    * The basic entry point to participate the crowdsale process.
606    *
607    * Pay for funding, get invested tokens back in the sender address.
608    */
609   function buy() public payable {
610     invest(msg.sender);
611   }
612 
613   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
614     // Already finalized
615     if(finalized) {
616       throw;
617     }
618 
619     // Finalizing is optional. We only call it if we are given a finalizing agent.
620     if(address(finalizeAgent) != address(0)) {
621       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
622     }
623   }
624 
625   function areReservedTokensDistributed() public constant returns (bool) {
626     return finalizeAgent.reservedTokensAreDistributed();
627   }
628 
629   function canDistributeReservedTokens() public constant returns(bool) {
630     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
631     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
632     return false;
633   }
634 
635   /**
636    * Finalize a succcesful crowdsale.
637    *
638    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
639    */
640   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
641 
642     // Already finalized
643     if(finalized) {
644       throw;
645     }
646 
647     // Finalizing is optional. We only call it if we are given a finalizing agent.
648     if(address(finalizeAgent) != address(0)) {
649       finalizeAgent.finalizeCrowdsale();
650     }
651 
652     finalized = true;
653   }
654 
655   /**
656    * Allow to (re)set finalize agent.
657    *
658    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
659    */
660   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
661     assert(address(addr) != address(0));
662     assert(address(finalizeAgent) == address(0));
663     finalizeAgent = addr;
664 
665     // Don't allow setting bad agent
666     if(!finalizeAgent.isFinalizeAgent()) {
667       throw;
668     }
669   }
670 
671   /**
672    * Allow addresses to do early participation.
673    */
674   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
675     if (!isWhiteListed) throw;
676     assert(addr != address(0));
677     assert(maxCap > 0);
678     assert(minCap <= maxCap);
679     assert(now <= endsAt);
680 
681     if (!isAddressWhitelisted(addr)) {
682       whitelistedParticipants.push(addr);
683       Whitelisted(addr, status, minCap, maxCap);
684     } else {
685       WhitelistItemChanged(addr, status, minCap, maxCap);
686     }
687 
688     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
689   }
690 
691   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
692     if (!isWhiteListed) throw;
693     assert(now <= endsAt);
694     assert(addrs.length == statuses.length);
695     assert(statuses.length == minCaps.length);
696     assert(minCaps.length == maxCaps.length);
697     for (uint iterator = 0; iterator < addrs.length; iterator++) {
698       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
699     }
700   }
701 
702   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
703     if (!isWhiteListed) throw;
704     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
705 
706     uint8 tierPosition = getTierPosition(this);
707 
708     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
709       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
710       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
711     }
712   }
713 
714   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
715     if (!isWhiteListed) throw;
716     assert(addr != address(0));
717     assert(now <= endsAt);
718     assert(isTierJoined(msg.sender));
719     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
720     //if (addr != msg.sender && contractAddr != msg.sender) throw;
721     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
722     newMaxCap = newMaxCap.minus(tokensBought);
723     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
724   }
725 
726   function isAddressWhitelisted(address addr) public constant returns(bool) {
727     for (uint i = 0; i < whitelistedParticipants.length; i++) {
728       if (whitelistedParticipants[i] == addr) {
729         return true;
730         break;
731       }
732     }
733 
734     return false;
735   }
736 
737   function whitelistedParticipantsLength() public constant returns (uint) {
738     return whitelistedParticipants.length;
739   }
740 
741   function isTierJoined(address addr) public constant returns(bool) {
742     return joinedCrowdsaleState[addr].isJoined;
743   }
744 
745   function getTierPosition(address addr) public constant returns(uint8) {
746     return joinedCrowdsaleState[addr].position;
747   }
748 
749   function getLastTier() public constant returns(address) {
750     if (joinedCrowdsalesLen > 0)
751       return joinedCrowdsales[joinedCrowdsalesLen - 1];
752     else
753       return address(0);
754   }
755 
756   function setJoinedCrowdsales(address addr) private onlyOwner {
757     assert(addr != address(0));
758     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
759     assert(!isTierJoined(addr));
760     joinedCrowdsales.push(addr);
761     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
762       isJoined: true,
763       position: joinedCrowdsalesLen
764     });
765     joinedCrowdsalesLen++;
766   }
767 
768   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
769     assert(addrs.length > 0);
770     assert(joinedCrowdsalesLen == 0);
771     assert(addrs.length <= joinedCrowdsalesLenMax);
772     for (uint8 iter = 0; iter < addrs.length; iter++) {
773       setJoinedCrowdsales(addrs[iter]);
774     }
775   }
776 
777   function setStartsAt(uint time) onlyOwner {
778     assert(!finalized);
779     assert(isUpdatable);
780     assert(now <= time); // Don't change past
781     assert(time <= endsAt);
782     assert(now <= startsAt);
783 
784     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
785     if (lastTierCntrct.finalized()) throw;
786 
787     uint8 tierPosition = getTierPosition(this);
788 
789     //start time should be greater then end time of previous tiers
790     for (uint8 j = 0; j < tierPosition; j++) {
791       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
792       assert(time >= crowdsale.endsAt());
793     }
794 
795     startsAt = time;
796     StartsAtChanged(startsAt);
797   }
798 
799   /**
800    * Allow crowdsale owner to close early or extend the crowdsale.
801    *
802    * This is useful e.g. for a manual soft cap implementation:
803    * - after X amount is reached determine manual closing
804    *
805    * This may put the crowdsale to an invalid state,
806    * but we trust owners know what they are doing.
807    *
808    */
809   function setEndsAt(uint time) public onlyOwner {
810     assert(!finalized);
811     assert(isUpdatable);
812     assert(now <= time);// Don't change past
813     assert(startsAt <= time);
814     assert(now <= endsAt);
815 
816     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
817     if (lastTierCntrct.finalized()) throw;
818 
819 
820     uint8 tierPosition = getTierPosition(this);
821 
822     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
823       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
824       assert(time <= crowdsale.startsAt());
825     }
826 
827     endsAt = time;
828     EndsAtChanged(endsAt);
829   }
830 
831   /**
832    * Allow to (re)set pricing strategy.
833    *
834    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
835    */
836   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
837     assert(address(_pricingStrategy) != address(0));
838     assert(address(pricingStrategy) == address(0));
839     pricingStrategy = _pricingStrategy;
840 
841     // Don't allow setting bad agent
842     if(!pricingStrategy.isPricingStrategy()) {
843       throw;
844     }
845   }
846 
847   /**
848    * Allow to change the team multisig address in the case of emergency.
849    *
850    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
851    * (we have done only few test transactions). After the crowdsale is going
852    * then multisig address stays locked for the safety reasons.
853    */
854   function setMultisig(address addr) public onlyOwner {
855 
856     // Change
857     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
858       throw;
859     }
860 
861     multisigWallet = addr;
862   }
863 
864   /**
865    * @return true if the crowdsale has raised enough money to be a successful.
866    */
867   function isMinimumGoalReached() public constant returns (bool reached) {
868     return weiRaised >= minimumFundingGoal;
869   }
870 
871   /**
872    * Check if the contract relationship looks good.
873    */
874   function isFinalizerSane() public constant returns (bool sane) {
875     return finalizeAgent.isSane();
876   }
877 
878   /**
879    * Check if the contract relationship looks good.
880    */
881   function isPricingSane() public constant returns (bool sane) {
882     return pricingStrategy.isSane(address(this));
883   }
884 
885   /**
886    * Crowdfund state machine management.
887    *
888    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
889    */
890   function getState() public constant returns (State) {
891     if(finalized) return State.Finalized;
892     else if (address(finalizeAgent) == 0) return State.Preparing;
893     else if (!finalizeAgent.isSane()) return State.Preparing;
894     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
895     else if (block.timestamp < startsAt) return State.PreFunding;
896     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
897     else if (isMinimumGoalReached()) return State.Success;
898     else return State.Failure;
899   }
900 
901   /** Interface marker. */
902   function isCrowdsale() public constant returns (bool) {
903     return true;
904   }
905 
906   //
907   // Modifiers
908   //
909 
910   /** Modified allowing execution only if the crowdsale is currently running.  */
911   modifier inState(State state) {
912     if(getState() != state) throw;
913     _;
914   }
915 
916 
917   //
918   // Abstract functions
919   //
920 
921   /**
922    * Check if the current invested breaks our cap rules.
923    *
924    *
925    * The child contract must define their own cap setting rules.
926    * We allow a lot of flexibility through different capping strategies (ETH, token count)
927    * Called from invest().
928    *
929    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
930    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
931    * @param weiRaisedTotal What would be our total raised balance after this transaction
932    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
933    *
934    * @return true if taking this investment would break our cap rules
935    */
936   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
937 
938   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
939 
940   /**
941    * Check if the current crowdsale is full and we can no longer sell any tokens.
942    */
943   function isCrowdsaleFull() public constant returns (bool);
944 
945   /**
946    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
947    */
948   function assignTokens(address receiver, uint tokenAmount) private;
949 }
950 
951 /**
952  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
953  *
954  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
955  */
956 
957 
958 
959 /**
960  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
961  *
962  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
963  */
964 
965 
966 
967 
968 
969 
970 
971 
972 /**
973  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
974  *
975  * Based on code by FirstBlood:
976  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
977  */
978 contract StandardToken is ERC20, SafeMath {
979 
980   /* Token supply got increased and a new owner received these tokens */
981   event Minted(address receiver, uint amount);
982 
983   /* Actual balances of token holders */
984   mapping(address => uint) balances;
985 
986   /* approve() allowances */
987   mapping (address => mapping (address => uint)) allowed;
988 
989   /* Interface declaration */
990   function isToken() public constant returns (bool weAre) {
991     return true;
992   }
993 
994   function transfer(address _to, uint _value) returns (bool success) {
995     balances[msg.sender] = safeSub(balances[msg.sender], _value);
996     balances[_to] = safeAdd(balances[_to], _value);
997     Transfer(msg.sender, _to, _value);
998     return true;
999   }
1000 
1001   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
1002     uint _allowance = allowed[_from][msg.sender];
1003 
1004     balances[_to] = safeAdd(balances[_to], _value);
1005     balances[_from] = safeSub(balances[_from], _value);
1006     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1007     Transfer(_from, _to, _value);
1008     return true;
1009   }
1010 
1011   function balanceOf(address _owner) constant returns (uint balance) {
1012     return balances[_owner];
1013   }
1014 
1015   function approve(address _spender, uint _value) returns (bool success) {
1016 
1017     // To change the approve amount you first have to reduce the addresses`
1018     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1019     //  already 0 to mitigate the race condition described here:
1020     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1021     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1022 
1023     allowed[msg.sender][_spender] = _value;
1024     Approval(msg.sender, _spender, _value);
1025     return true;
1026   }
1027 
1028   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1029     return allowed[_owner][_spender];
1030   }
1031 
1032 }
1033 
1034 
1035 
1036 
1037 
1038 /**
1039  * A token that can increase its supply by another contract.
1040  *
1041  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1042  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1043  *
1044  */
1045 contract MintableTokenExt is StandardToken, Ownable {
1046 
1047   using SafeMathLibExt for uint;
1048 
1049   bool public mintingFinished = false;
1050 
1051   /** List of agents that are allowed to create new tokens */
1052   mapping (address => bool) public mintAgents;
1053 
1054   event MintingAgentChanged(address addr, bool state  );
1055 
1056   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1057   * For example, for reserved tokens in percents 2.54%
1058   * inPercentageUnit = 254
1059   * inPercentageDecimals = 2
1060   */
1061   struct ReservedTokensData {
1062     uint inTokens;
1063     uint inPercentageUnit;
1064     uint inPercentageDecimals;
1065     bool isReserved;
1066     bool isDistributed;
1067   }
1068 
1069   mapping (address => ReservedTokensData) public reservedTokensList;
1070   address[] public reservedTokensDestinations;
1071   uint public reservedTokensDestinationsLen = 0;
1072   bool reservedTokensDestinationsAreSet = false;
1073 
1074   modifier onlyMintAgent() {
1075     // Only crowdsale contracts are allowed to mint new tokens
1076     if(!mintAgents[msg.sender]) {
1077         throw;
1078     }
1079     _;
1080   }
1081 
1082   /** Make sure we are not done yet. */
1083   modifier canMint() {
1084     if(mintingFinished) throw;
1085     _;
1086   }
1087 
1088   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1089     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1090     reservedTokensData.isDistributed = true;
1091   }
1092 
1093   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1094     return reservedTokensList[addr].isReserved;
1095   }
1096 
1097   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1098     return reservedTokensList[addr].isDistributed;
1099   }
1100 
1101   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1102     return reservedTokensList[addr].inTokens;
1103   }
1104 
1105   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1106     return reservedTokensList[addr].inPercentageUnit;
1107   }
1108 
1109   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1110     return reservedTokensList[addr].inPercentageDecimals;
1111   }
1112 
1113   function setReservedTokensListMultiple(
1114     address[] addrs, 
1115     uint[] inTokens, 
1116     uint[] inPercentageUnit, 
1117     uint[] inPercentageDecimals
1118   ) public canMint onlyOwner {
1119     assert(!reservedTokensDestinationsAreSet);
1120     assert(addrs.length == inTokens.length);
1121     assert(inTokens.length == inPercentageUnit.length);
1122     assert(inPercentageUnit.length == inPercentageDecimals.length);
1123     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1124       if (addrs[iterator] != address(0)) {
1125         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1126       }
1127     }
1128     reservedTokensDestinationsAreSet = true;
1129   }
1130 
1131   /**
1132    * Create new tokens and allocate them to an address..
1133    *
1134    * Only callably by a crowdsale contract (mint agent).
1135    */
1136   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1137     totalSupply = totalSupply.plus(amount);
1138     balances[receiver] = balances[receiver].plus(amount);
1139 
1140     // This will make the mint transaction apper in EtherScan.io
1141     // We can remove this after there is a standardized minting event
1142     Transfer(0, receiver, amount);
1143   }
1144 
1145   /**
1146    * Owner can allow a crowdsale contract to mint new tokens.
1147    */
1148   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1149     mintAgents[addr] = state;
1150     MintingAgentChanged(addr, state);
1151   }
1152 
1153   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1154     assert(addr != address(0));
1155     if (!isAddressReserved(addr)) {
1156       reservedTokensDestinations.push(addr);
1157       reservedTokensDestinationsLen++;
1158     }
1159 
1160     reservedTokensList[addr] = ReservedTokensData({
1161       inTokens: inTokens, 
1162       inPercentageUnit: inPercentageUnit, 
1163       inPercentageDecimals: inPercentageDecimals,
1164       isReserved: true,
1165       isDistributed: false
1166     });
1167   }
1168 }
1169 
1170 /**
1171  * ICO crowdsale contract that is capped by amout of tokens.
1172  *
1173  * - Tokens are dynamically created during the crowdsale
1174  *
1175  *
1176  */
1177 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1178 
1179   /* Maximum amount of tokens this crowdsale can sell. */
1180   uint public maximumSellableTokens;
1181 
1182   function MintedTokenCappedCrowdsaleExt(
1183     string _name, 
1184     address _token, 
1185     PricingStrategy _pricingStrategy, 
1186     address _multisigWallet, 
1187     uint _start, uint _end, 
1188     uint _minimumFundingGoal, 
1189     uint _maximumSellableTokens, 
1190     bool _isUpdatable, 
1191     bool _isWhiteListed
1192   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1193     maximumSellableTokens = _maximumSellableTokens;
1194   }
1195 
1196   // Crowdsale maximumSellableTokens has been changed
1197   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1198 
1199   /**
1200    * Called from invest() to confirm if the curret investment does not break our cap rule.
1201    */
1202   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1203     return tokensSoldTotal > maximumSellableTokens;
1204   }
1205 
1206   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1207     assert(isWhiteListed);
1208     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1209     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1210   }
1211 
1212   function isCrowdsaleFull() public constant returns (bool) {
1213     return tokensSold >= maximumSellableTokens;
1214   }
1215 
1216   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1217     assert(!finalized);
1218     assert(isUpdatable);
1219     assert(now <= startsAt);
1220 
1221     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1222     assert(!lastTierCntrct.finalized());
1223 
1224     maximumSellableTokens = tokens;
1225     MaximumSellableTokensChanged(maximumSellableTokens);
1226   }
1227 
1228   function updateRate(uint newOneTokenInWei) public onlyOwner {
1229     assert(!finalized);
1230     assert(isUpdatable);
1231     assert(now <= startsAt);
1232 
1233     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1234     assert(!lastTierCntrct.finalized());
1235 
1236     pricingStrategy.updateRate(newOneTokenInWei);
1237   }
1238 
1239   /**
1240    * Dynamically create tokens and assign them to the investor.
1241    */
1242   function assignTokens(address receiver, uint tokenAmount) private {
1243     MintableTokenExt mintableToken = MintableTokenExt(token);
1244     mintableToken.mint(receiver, tokenAmount);
1245   }
1246 }