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
66 /**
67  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
68  *
69  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
70  */
71 
72 
73 
74 /**
75  * Safe unsigned safe math.
76  *
77  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
78  *
79  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
80  *
81  * Maintained here until merged to mainline zeppelin-solidity.
82  *
83  */
84 library SafeMathLibExt {
85 
86   function times(uint a, uint b) returns (uint) {
87     uint c = a * b;
88     assert(a == 0 || c / a == b);
89     return c;
90   }
91 
92   function divides(uint a, uint b) returns (uint) {
93     assert(b > 0);
94     uint c = a / b;
95     assert(a == b * c + a % b);
96     return c;
97   }
98 
99   function minus(uint a, uint b) returns (uint) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   function plus(uint a, uint b) returns (uint) {
105     uint c = a + b;
106     assert(c>=a);
107     return c;
108   }
109 
110 }
111 
112 
113 
114 /**
115  * @title Ownable
116  * @dev The Ownable contract has an owner address, and provides basic authorization control
117  * functions, this simplifies the implementation of "user permissions".
118  */
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   function Ownable() {
131     owner = msg.sender;
132   }
133 
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) onlyOwner public {
149     require(newOwner != address(0));
150     OwnershipTransferred(owner, newOwner);
151     owner = newOwner;
152   }
153 
154 }
155 /**
156  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
157  *
158  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
159  */
160 
161 
162 
163 /**
164  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
165  *
166  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
167  */
168 
169 
170 
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
554 
555       // Check that we did not bust the investor's cap
556       if (isBreakingInvestorCap(receiver, tokenAmount)) {
557         throw;
558       }
559 
560       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
561     } else {
562       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
563         throw;
564       }
565     }
566 
567     if(investedAmountOf[receiver] == 0) {
568        // A new investor
569        investorCount++;
570     }
571 
572     // Update investor
573     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
574     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
575 
576     // Update totals
577     weiRaised = weiRaised.plus(weiAmount);
578     tokensSold = tokensSold.plus(tokenAmount);
579 
580     // Check that we did not bust the cap
581     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
582       throw;
583     }
584 
585     assignTokens(receiver, tokenAmount);
586 
587     // Pocket the money
588     if(!multisigWallet.send(weiAmount)) throw;
589 
590     // Tell us invest was success
591     Invested(receiver, weiAmount, tokenAmount, customerId);
592   }
593 
594   /**
595    * Allow anonymous contributions to this crowdsale.
596    */
597   function invest(address addr) public payable {
598     investInternal(addr, 0);
599   }
600 
601   /**
602    * The basic entry point to participate the crowdsale process.
603    *
604    * Pay for funding, get invested tokens back in the sender address.
605    */
606   function buy() public payable {
607     invest(msg.sender);
608   }
609 
610   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
611     // Already finalized
612     if(finalized) {
613       throw;
614     }
615 
616     // Finalizing is optional. We only call it if we are given a finalizing agent.
617     if(address(finalizeAgent) != address(0)) {
618       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
619     }
620   }
621 
622   function areReservedTokensDistributed() public constant returns (bool) {
623     return finalizeAgent.reservedTokensAreDistributed();
624   }
625 
626   function canDistributeReservedTokens() public constant returns(bool) {
627     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
628     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
629     return false;
630   }
631 
632   /**
633    * Finalize a succcesful crowdsale.
634    *
635    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
636    */
637   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
638 
639     // Already finalized
640     if(finalized) {
641       throw;
642     }
643 
644     // Finalizing is optional. We only call it if we are given a finalizing agent.
645     if(address(finalizeAgent) != address(0)) {
646       finalizeAgent.finalizeCrowdsale();
647     }
648 
649     finalized = true;
650   }
651 
652   /**
653    * Allow to (re)set finalize agent.
654    *
655    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
656    */
657   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
658     assert(address(addr) != address(0));
659     assert(address(finalizeAgent) == address(0));
660     finalizeAgent = addr;
661 
662     // Don't allow setting bad agent
663     if(!finalizeAgent.isFinalizeAgent()) {
664       throw;
665     }
666   }
667 
668   /**
669    * Allow addresses to do early participation.
670    */
671   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
672     if (!isWhiteListed) throw;
673     assert(addr != address(0));
674     assert(maxCap > 0);
675     assert(minCap <= maxCap);
676     assert(now <= endsAt);
677 
678     if (!isAddressWhitelisted(addr)) {
679       whitelistedParticipants.push(addr);
680       Whitelisted(addr, status, minCap, maxCap);
681     } else {
682       WhitelistItemChanged(addr, status, minCap, maxCap);
683     }
684 
685     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
686   }
687 
688   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
689     if (!isWhiteListed) throw;
690     assert(now <= endsAt);
691     assert(addrs.length == statuses.length);
692     assert(statuses.length == minCaps.length);
693     assert(minCaps.length == maxCaps.length);
694     for (uint iterator = 0; iterator < addrs.length; iterator++) {
695       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
696     }
697   }
698 
699   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
700     if (!isWhiteListed) throw;
701     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
702 
703     uint8 tierPosition = getTierPosition(this);
704 
705     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
706       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
707       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
708     }
709   }
710 
711   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
712     if (!isWhiteListed) throw;
713     assert(addr != address(0));
714     assert(now <= endsAt);
715     assert(isTierJoined(msg.sender));
716     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
717     //if (addr != msg.sender && contractAddr != msg.sender) throw;
718     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
719     newMaxCap = newMaxCap.minus(tokensBought);
720     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
721   }
722 
723   function isAddressWhitelisted(address addr) public constant returns(bool) {
724     for (uint i = 0; i < whitelistedParticipants.length; i++) {
725       if (whitelistedParticipants[i] == addr) {
726         return true;
727         break;
728       }
729     }
730 
731     return false;
732   }
733 
734   function whitelistedParticipantsLength() public constant returns (uint) {
735     return whitelistedParticipants.length;
736   }
737 
738   function isTierJoined(address addr) public constant returns(bool) {
739     return joinedCrowdsaleState[addr].isJoined;
740   }
741 
742   function getTierPosition(address addr) public constant returns(uint8) {
743     return joinedCrowdsaleState[addr].position;
744   }
745 
746   function getLastTier() public constant returns(address) {
747     if (joinedCrowdsalesLen > 0)
748       return joinedCrowdsales[joinedCrowdsalesLen - 1];
749     else
750       return address(0);
751   }
752 
753   function setJoinedCrowdsales(address addr) private onlyOwner {
754     assert(addr != address(0));
755     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
756     assert(!isTierJoined(addr));
757     joinedCrowdsales.push(addr);
758     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
759       isJoined: true,
760       position: joinedCrowdsalesLen
761     });
762     joinedCrowdsalesLen++;
763   }
764 
765   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
766     assert(addrs.length > 0);
767     assert(joinedCrowdsalesLen == 0);
768     assert(addrs.length <= joinedCrowdsalesLenMax);
769     for (uint8 iter = 0; iter < addrs.length; iter++) {
770       setJoinedCrowdsales(addrs[iter]);
771     }
772   }
773 
774   function setStartsAt(uint time) onlyOwner {
775     assert(!finalized);
776     assert(isUpdatable);
777     assert(now <= time); // Don't change past
778     assert(time <= endsAt);
779     assert(now <= startsAt);
780 
781     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
782     if (lastTierCntrct.finalized()) throw;
783 
784     uint8 tierPosition = getTierPosition(this);
785 
786     //start time should be greater then end time of previous tiers
787     for (uint8 j = 0; j < tierPosition; j++) {
788       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
789       assert(time >= crowdsale.endsAt());
790     }
791 
792     startsAt = time;
793     StartsAtChanged(startsAt);
794   }
795 
796   /**
797    * Allow crowdsale owner to close early or extend the crowdsale.
798    *
799    * This is useful e.g. for a manual soft cap implementation:
800    * - after X amount is reached determine manual closing
801    *
802    * This may put the crowdsale to an invalid state,
803    * but we trust owners know what they are doing.
804    *
805    */
806   function setEndsAt(uint time) public onlyOwner {
807     assert(!finalized);
808     assert(isUpdatable);
809     assert(now <= time);// Don't change past
810     assert(startsAt <= time);
811     assert(now <= endsAt);
812 
813     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
814     if (lastTierCntrct.finalized()) throw;
815 
816 
817     uint8 tierPosition = getTierPosition(this);
818 
819     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
820       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
821       assert(time <= crowdsale.startsAt());
822     }
823 
824     endsAt = time;
825     EndsAtChanged(endsAt);
826   }
827 
828   /**
829    * Allow to (re)set pricing strategy.
830    *
831    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
832    */
833   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
834     assert(address(_pricingStrategy) != address(0));
835     assert(address(pricingStrategy) == address(0));
836     pricingStrategy = _pricingStrategy;
837 
838     // Don't allow setting bad agent
839     if(!pricingStrategy.isPricingStrategy()) {
840       throw;
841     }
842   }
843 
844   /**
845    * Allow to change the team multisig address in the case of emergency.
846    *
847    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
848    * (we have done only few test transactions). After the crowdsale is going
849    * then multisig address stays locked for the safety reasons.
850    */
851   function setMultisig(address addr) public onlyOwner {
852 
853     // Change
854     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
855       throw;
856     }
857 
858     multisigWallet = addr;
859   }
860 
861   /**
862    * @return true if the crowdsale has raised enough money to be a successful.
863    */
864   function isMinimumGoalReached() public constant returns (bool reached) {
865     return weiRaised >= minimumFundingGoal;
866   }
867 
868   /**
869    * Check if the contract relationship looks good.
870    */
871   function isFinalizerSane() public constant returns (bool sane) {
872     return finalizeAgent.isSane();
873   }
874 
875   /**
876    * Check if the contract relationship looks good.
877    */
878   function isPricingSane() public constant returns (bool sane) {
879     return pricingStrategy.isSane(address(this));
880   }
881 
882   /**
883    * Crowdfund state machine management.
884    *
885    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
886    */
887   function getState() public constant returns (State) {
888     if(finalized) return State.Finalized;
889     else if (address(finalizeAgent) == 0) return State.Preparing;
890     else if (!finalizeAgent.isSane()) return State.Preparing;
891     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
892     else if (block.timestamp < startsAt) return State.PreFunding;
893     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
894     else if (isMinimumGoalReached()) return State.Success;
895     else return State.Failure;
896   }
897 
898   /** Interface marker. */
899   function isCrowdsale() public constant returns (bool) {
900     return true;
901   }
902 
903   //
904   // Modifiers
905   //
906 
907   /** Modified allowing execution only if the crowdsale is currently running.  */
908   modifier inState(State state) {
909     if(getState() != state) throw;
910     _;
911   }
912 
913 
914   //
915   // Abstract functions
916   //
917 
918   /**
919    * Check if the current invested breaks our cap rules.
920    *
921    *
922    * The child contract must define their own cap setting rules.
923    * We allow a lot of flexibility through different capping strategies (ETH, token count)
924    * Called from invest().
925    *
926    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
927    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
928    * @param weiRaisedTotal What would be our total raised balance after this transaction
929    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
930    *
931    * @return true if taking this investment would break our cap rules
932    */
933   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
934 
935   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
936 
937   /**
938    * Check if the current crowdsale is full and we can no longer sell any tokens.
939    */
940   function isCrowdsaleFull() public constant returns (bool);
941 
942   /**
943    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
944    */
945   function assignTokens(address receiver, uint tokenAmount) private;
946 }
947 
948 /**
949  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
950  *
951  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
952  */
953 
954 
955 
956 /**
957  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
958  *
959  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
960  */
961 
962 
963 
964 
965 
966 
967 
968 
969 /**
970  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
971  *
972  * Based on code by FirstBlood:
973  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
974  */
975 contract StandardToken is ERC20, SafeMath {
976 
977   /* Token supply got increased and a new owner received these tokens */
978   event Minted(address receiver, uint amount);
979 
980   /* Actual balances of token holders */
981   mapping(address => uint) balances;
982 
983   /* approve() allowances */
984   mapping (address => mapping (address => uint)) allowed;
985 
986   /* Interface declaration */
987   function isToken() public constant returns (bool weAre) {
988     return true;
989   }
990 
991   function transfer(address _to, uint _value) returns (bool success) {
992     balances[msg.sender] = safeSub(balances[msg.sender], _value);
993     balances[_to] = safeAdd(balances[_to], _value);
994     Transfer(msg.sender, _to, _value);
995     return true;
996   }
997 
998   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
999     uint _allowance = allowed[_from][msg.sender];
1000 
1001     balances[_to] = safeAdd(balances[_to], _value);
1002     balances[_from] = safeSub(balances[_from], _value);
1003     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1004     Transfer(_from, _to, _value);
1005     return true;
1006   }
1007 
1008   function balanceOf(address _owner) constant returns (uint balance) {
1009     return balances[_owner];
1010   }
1011 
1012   function approve(address _spender, uint _value) returns (bool success) {
1013 
1014     // To change the approve amount you first have to reduce the addresses`
1015     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1016     //  already 0 to mitigate the race condition described here:
1017     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1018     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1019 
1020     allowed[msg.sender][_spender] = _value;
1021     Approval(msg.sender, _spender, _value);
1022     return true;
1023   }
1024 
1025   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1026     return allowed[_owner][_spender];
1027   }
1028 
1029 }
1030 
1031 
1032 
1033 
1034 
1035 /**
1036  * A token that can increase its supply by another contract.
1037  *
1038  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1039  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1040  *
1041  */
1042 contract MintableTokenExt is StandardToken, Ownable {
1043 
1044   using SafeMathLibExt for uint;
1045 
1046   bool public mintingFinished = false;
1047 
1048   /** List of agents that are allowed to create new tokens */
1049   mapping (address => bool) public mintAgents;
1050 
1051   event MintingAgentChanged(address addr, bool state  );
1052 
1053   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1054   * For example, for reserved tokens in percents 2.54%
1055   * inPercentageUnit = 254
1056   * inPercentageDecimals = 2
1057   */
1058   struct ReservedTokensData {
1059     uint inTokens;
1060     uint inPercentageUnit;
1061     uint inPercentageDecimals;
1062     bool isReserved;
1063     bool isDistributed;
1064   }
1065 
1066   mapping (address => ReservedTokensData) public reservedTokensList;
1067   address[] public reservedTokensDestinations;
1068   uint public reservedTokensDestinationsLen = 0;
1069   bool reservedTokensDestinationsAreSet = false;
1070 
1071   modifier onlyMintAgent() {
1072     // Only crowdsale contracts are allowed to mint new tokens
1073     if(!mintAgents[msg.sender]) {
1074         throw;
1075     }
1076     _;
1077   }
1078 
1079   /** Make sure we are not done yet. */
1080   modifier canMint() {
1081     if(mintingFinished) throw;
1082     _;
1083   }
1084 
1085   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1086     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1087     reservedTokensData.isDistributed = true;
1088   }
1089 
1090   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1091     return reservedTokensList[addr].isReserved;
1092   }
1093 
1094   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1095     return reservedTokensList[addr].isDistributed;
1096   }
1097 
1098   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1099     return reservedTokensList[addr].inTokens;
1100   }
1101 
1102   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1103     return reservedTokensList[addr].inPercentageUnit;
1104   }
1105 
1106   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1107     return reservedTokensList[addr].inPercentageDecimals;
1108   }
1109 
1110   function setReservedTokensListMultiple(
1111     address[] addrs, 
1112     uint[] inTokens, 
1113     uint[] inPercentageUnit, 
1114     uint[] inPercentageDecimals
1115   ) public canMint onlyOwner {
1116     assert(!reservedTokensDestinationsAreSet);
1117     assert(addrs.length == inTokens.length);
1118     assert(inTokens.length == inPercentageUnit.length);
1119     assert(inPercentageUnit.length == inPercentageDecimals.length);
1120     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1121       if (addrs[iterator] != address(0)) {
1122         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1123       }
1124     }
1125     reservedTokensDestinationsAreSet = true;
1126   }
1127 
1128   /**
1129    * Create new tokens and allocate them to an address..
1130    *
1131    * Only callably by a crowdsale contract (mint agent).
1132    */
1133   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1134     totalSupply = totalSupply.plus(amount);
1135     balances[receiver] = balances[receiver].plus(amount);
1136 
1137     // This will make the mint transaction apper in EtherScan.io
1138     // We can remove this after there is a standardized minting event
1139     Transfer(0, receiver, amount);
1140   }
1141 
1142   /**
1143    * Owner can allow a crowdsale contract to mint new tokens.
1144    */
1145   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1146     mintAgents[addr] = state;
1147     MintingAgentChanged(addr, state);
1148   }
1149 
1150   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1151     assert(addr != address(0));
1152     if (!isAddressReserved(addr)) {
1153       reservedTokensDestinations.push(addr);
1154       reservedTokensDestinationsLen++;
1155     }
1156 
1157     reservedTokensList[addr] = ReservedTokensData({
1158       inTokens: inTokens, 
1159       inPercentageUnit: inPercentageUnit, 
1160       inPercentageDecimals: inPercentageDecimals,
1161       isReserved: true,
1162       isDistributed: false
1163     });
1164   }
1165 }
1166 
1167 /**
1168  * ICO crowdsale contract that is capped by amout of tokens.
1169  *
1170  * - Tokens are dynamically created during the crowdsale
1171  *
1172  *
1173  */
1174 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1175 
1176   /* Maximum amount of tokens this crowdsale can sell. */
1177   uint public maximumSellableTokens;
1178 
1179   function MintedTokenCappedCrowdsaleExt(
1180     string _name, 
1181     address _token, 
1182     PricingStrategy _pricingStrategy, 
1183     address _multisigWallet, 
1184     uint _start, uint _end, 
1185     uint _minimumFundingGoal, 
1186     uint _maximumSellableTokens, 
1187     bool _isUpdatable, 
1188     bool _isWhiteListed
1189   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1190     maximumSellableTokens = _maximumSellableTokens;
1191   }
1192 
1193   // Crowdsale maximumSellableTokens has been changed
1194   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1195 
1196   /**
1197    * Called from invest() to confirm if the curret investment does not break our cap rule.
1198    */
1199   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1200     return tokensSoldTotal > maximumSellableTokens;
1201   }
1202 
1203   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1204     assert(isWhiteListed);
1205     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1206     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1207   }
1208 
1209   function isCrowdsaleFull() public constant returns (bool) {
1210     return tokensSold >= maximumSellableTokens;
1211   }
1212 
1213   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1214     assert(!finalized);
1215     assert(isUpdatable);
1216     assert(now <= startsAt);
1217 
1218     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1219     assert(!lastTierCntrct.finalized());
1220 
1221     maximumSellableTokens = tokens;
1222     MaximumSellableTokensChanged(maximumSellableTokens);
1223   }
1224 
1225   function updateRate(uint newOneTokenInWei) public onlyOwner {
1226     assert(!finalized);
1227     assert(isUpdatable);
1228     assert(now <= startsAt);
1229 
1230     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1231     assert(!lastTierCntrct.finalized());
1232 
1233     pricingStrategy.updateRate(newOneTokenInWei);
1234   }
1235 
1236   /**
1237    * Dynamically create tokens and assign them to the investor.
1238    */
1239   function assignTokens(address receiver, uint tokenAmount) private {
1240     MintableTokenExt mintableToken = MintableTokenExt(token);
1241     mintableToken.mint(receiver, tokenAmount);
1242   }
1243 }