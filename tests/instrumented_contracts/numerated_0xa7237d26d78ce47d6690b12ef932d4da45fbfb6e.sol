1 pragma solidity ^0.4.8;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   uint256 public totalSupply;
59   function balanceOf(address who) public constant returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) onlyOwner public {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 /**
108  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
109  *
110  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
111  */
112 
113 
114 
115 /**
116  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
117  *
118  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
119  */
120 
121 
122 
123 /**
124  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
125  *
126  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
127  */
128 
129 
130 
131 /**
132  * Safe unsigned safe math.
133  *
134  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
135  *
136  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
137  *
138  * Maintained here until merged to mainline zeppelin-solidity.
139  *
140  */
141 library SafeMathLibExt {
142 
143   function times(uint a, uint b) returns (uint) {
144     uint c = a * b;
145     assert(a == 0 || c / a == b);
146     return c;
147   }
148 
149   function divides(uint a, uint b) returns (uint) {
150     assert(b > 0);
151     uint c = a / b;
152     assert(a == b * c + a % b);
153     return c;
154   }
155 
156   function minus(uint a, uint b) returns (uint) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   function plus(uint a, uint b) returns (uint) {
162     uint c = a + b;
163     assert(c>=a);
164     return c;
165   }
166 
167 }
168 
169 /**
170  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
171  *
172  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
173  */
174 
175 
176 
177 
178 
179 /*
180  * Haltable
181  *
182  * Abstract contract that allows children to implement an
183  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
184  *
185  *
186  * Originally envisioned in FirstBlood ICO contract.
187  */
188 contract Haltable is Ownable {
189   bool public halted;
190 
191   modifier stopInEmergency {
192     if (halted) throw;
193     _;
194   }
195 
196   modifier stopNonOwnersInEmergency {
197     if (halted && msg.sender != owner) throw;
198     _;
199   }
200 
201   modifier onlyInEmergency {
202     if (!halted) throw;
203     _;
204   }
205 
206   // called by the owner on emergency, triggers stopped state
207   function halt() external onlyOwner {
208     halted = true;
209   }
210 
211   // called by the owner on end of emergency, returns to normal state
212   function unhalt() external onlyOwner onlyInEmergency {
213     halted = false;
214   }
215 
216 }
217 
218 /**
219  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
220  *
221  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
222  */
223 
224 
225 
226 /**
227  * Interface for defining crowdsale pricing.
228  */
229 contract PricingStrategy {
230 
231   address public tier;
232 
233   /** Interface declaration. */
234   function isPricingStrategy() public constant returns (bool) {
235     return true;
236   }
237 
238   /** Self check if all references are correctly set.
239    *
240    * Checks that pricing strategy matches crowdsale parameters.
241    */
242   function isSane(address crowdsale) public constant returns (bool) {
243     return true;
244   }
245 
246   /**
247    * @dev Pricing tells if this is a presale purchase or not.
248      @param purchaser Address of the purchaser
249      @return False by default, true if a presale purchaser
250    */
251   function isPresalePurchase(address purchaser) public constant returns (bool) {
252     return false;
253   }
254 
255   /* How many weis one token costs */
256   function updateRate(uint newOneTokenInWei) public;
257 
258   /**
259    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
260    *
261    *
262    * @param value - What is the value of the transaction send in as wei
263    * @param tokensSold - how much tokens have been sold this far
264    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
265    * @param msgSender - who is the investor of this transaction
266    * @param decimals - how many decimal units the token has
267    * @return Amount of tokens the investor receives
268    */
269   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
270 }
271 
272 /**
273  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
274  *
275  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
276  */
277 
278 
279 
280 /**
281  * Finalize agent defines what happens at the end of succeseful crowdsale.
282  *
283  * - Allocate tokens for founders, bounties and community
284  * - Make tokens transferable
285  * - etc.
286  */
287 contract FinalizeAgent {
288 
289   bool public reservedTokensAreDistributed = false;
290 
291   function isFinalizeAgent() public constant returns(bool) {
292     return true;
293   }
294 
295   /** Return true if we can run finalizeCrowdsale() properly.
296    *
297    * This is a safety check function that doesn't allow crowdsale to begin
298    * unless the finalizer has been set up properly.
299    */
300   function isSane() public constant returns (bool);
301 
302   function distributeReservedTokens(uint reservedTokensDistributionBatch);
303 
304   /** Called once by crowdsale finalize() if the sale was success. */
305   function finalizeCrowdsale();
306 
307 }
308 /**
309  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
310  *
311  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
312  */
313 
314 
315 
316 
317 
318 
319 
320 
321 
322 /**
323  * @title ERC20 interface
324  * @dev see https://github.com/ethereum/EIPs/issues/20
325  */
326 contract ERC20 is ERC20Basic {
327   function allowance(address owner, address spender) public constant returns (uint256);
328   function transferFrom(address from, address to, uint256 value) public returns (bool);
329   function approve(address spender, uint256 value) public returns (bool);
330   event Approval(address indexed owner, address indexed spender, uint256 value);
331 }
332 
333 
334 /**
335  * A token that defines fractional units as decimals.
336  */
337 contract FractionalERC20Ext is ERC20 {
338 
339   uint public decimals;
340   uint public minCap;
341 
342 }
343 
344 
345 
346 /**
347  * Abstract base contract for token sales.
348  *
349  * Handle
350  * - start and end dates
351  * - accepting investments
352  * - minimum funding goal and refund
353  * - various statistics during the crowdfund
354  * - different pricing strategies
355  * - different investment policies (require server side customer id, allow only whitelisted addresses)
356  *
357  */
358 contract CrowdsaleExt is Haltable {
359 
360   /* Max investment count when we are still allowed to change the multisig address */
361   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
362 
363   using SafeMathLibExt for uint;
364 
365   /* The token we are selling */
366   FractionalERC20Ext public token;
367 
368   /* How we are going to price our offering */
369   PricingStrategy public pricingStrategy;
370 
371   /* Post-success callback */
372   FinalizeAgent public finalizeAgent;
373 
374   /* name of the crowdsale tier */
375   string public name;
376 
377   /* tokens will be transfered from this address */
378   address public multisigWallet;
379 
380   /* if the funding goal is not reached, investors may withdraw their funds */
381   uint public minimumFundingGoal;
382 
383   /* the UNIX timestamp start date of the crowdsale */
384   uint public startsAt;
385 
386   /* the UNIX timestamp end date of the crowdsale */
387   uint public endsAt;
388 
389   /* the number of tokens already sold through this contract*/
390   uint public tokensSold = 0;
391 
392   /* How many wei of funding we have raised */
393   uint public weiRaised = 0;
394 
395   /* How many distinct addresses have invested */
396   uint public investorCount = 0;
397 
398   /* Has this crowdsale been finalized */
399   bool public finalized;
400 
401   bool public isWhiteListed;
402 
403   address[] public joinedCrowdsales;
404   uint8 public joinedCrowdsalesLen = 0;
405   uint8 public joinedCrowdsalesLenMax = 50;
406   struct JoinedCrowdsaleStatus {
407     bool isJoined;
408     uint8 position;
409   }
410   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
411 
412   /** How much ETH each address has invested to this crowdsale */
413   mapping (address => uint256) public investedAmountOf;
414 
415   /** How much tokens this crowdsale has credited for each investor address */
416   mapping (address => uint256) public tokenAmountOf;
417 
418   struct WhiteListData {
419     bool status;
420     uint minCap;
421     uint maxCap;
422   }
423 
424   //is crowdsale updatable
425   bool public isUpdatable;
426 
427   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
428   mapping (address => WhiteListData) public earlyParticipantWhitelist;
429 
430   /** List of whitelisted addresses */
431   address[] public whitelistedParticipants;
432 
433   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
434   uint public ownerTestValue;
435 
436   /** State machine
437    *
438    * - Preparing: All contract initialization calls and variables have not been set yet
439    * - Prefunding: We have not passed start time yet
440    * - Funding: Active crowdsale
441    * - Success: Minimum funding goal reached
442    * - Failure: Minimum funding goal not reached before ending time
443    * - Finalized: The finalized has been called and succesfully executed
444    */
445   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
446 
447   // A new investment was made
448   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
449 
450   // Address early participation whitelist status changed
451   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
452   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
453 
454   // Crowdsale start time has been changed
455   event StartsAtChanged(uint newStartsAt);
456 
457   // Crowdsale end time has been changed
458   event EndsAtChanged(uint newEndsAt);
459 
460   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
461 
462     owner = msg.sender;
463 
464     name = _name;
465 
466     token = FractionalERC20Ext(_token);
467 
468     setPricingStrategy(_pricingStrategy);
469 
470     multisigWallet = _multisigWallet;
471     if(multisigWallet == 0) {
472         throw;
473     }
474 
475     if(_start == 0) {
476         throw;
477     }
478 
479     startsAt = _start;
480 
481     if(_end == 0) {
482         throw;
483     }
484 
485     endsAt = _end;
486 
487     // Don't mess the dates
488     if(startsAt >= endsAt) {
489         throw;
490     }
491 
492     // Minimum funding goal can be zero
493     minimumFundingGoal = _minimumFundingGoal;
494 
495     isUpdatable = _isUpdatable;
496 
497     isWhiteListed = _isWhiteListed;
498   }
499 
500   /**
501    * Don't expect to just send in money and get tokens.
502    */
503   function() payable {
504     throw;
505   }
506 
507   /**
508    * Make an investment.
509    *
510    * Crowdsale must be running for one to invest.
511    * We must have not pressed the emergency brake.
512    *
513    * @param receiver The Ethereum address who receives the tokens
514    * @param customerId (optional) UUID v4 to track the successful payments on the server side
515    *
516    */
517   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
518 
519     // Determine if it's a good time to accept investment from this participant
520     if(getState() == State.PreFunding) {
521       // Are we whitelisted for early deposit
522       throw;
523     } else if(getState() == State.Funding) {
524       // Retail participants can only come in when the crowdsale is running
525       // pass
526       if(isWhiteListed) {
527         if(!earlyParticipantWhitelist[receiver].status) {
528           throw;
529         }
530       }
531     } else {
532       // Unwanted state
533       throw;
534     }
535 
536     uint weiAmount = msg.value;
537 
538     // Account presale sales separately, so that they do not count against pricing tranches
539     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
540 
541     if(tokenAmount == 0) {
542       // Dust transaction
543       throw;
544     }
545 
546     if(isWhiteListed) {
547       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
548         // tokenAmount < minCap for investor
549         throw;
550       }
551 
552       // Check that we did not bust the investor's cap
553       if (isBreakingInvestorCap(receiver, tokenAmount)) {
554         throw;
555       }
556 
557       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
558     } else {
559       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
560         throw;
561       }
562     }
563 
564     if(investedAmountOf[receiver] == 0) {
565        // A new investor
566        investorCount++;
567     }
568 
569     // Update investor
570     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
571     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
572 
573     // Update totals
574     weiRaised = weiRaised.plus(weiAmount);
575     tokensSold = tokensSold.plus(tokenAmount);
576 
577     // Check that we did not bust the cap
578     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
579       throw;
580     }
581 
582     assignTokens(receiver, tokenAmount);
583 
584     // Pocket the money
585     if(!multisigWallet.send(weiAmount)) throw;
586 
587     // Tell us invest was success
588     Invested(receiver, weiAmount, tokenAmount, customerId);
589   }
590 
591   /**
592    * Allow anonymous contributions to this crowdsale.
593    */
594   function invest(address addr) public payable {
595     investInternal(addr, 0);
596   }
597 
598   /**
599    * The basic entry point to participate the crowdsale process.
600    *
601    * Pay for funding, get invested tokens back in the sender address.
602    */
603   function buy() public payable {
604     invest(msg.sender);
605   }
606 
607   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
608     // Already finalized
609     if(finalized) {
610       throw;
611     }
612 
613     // Finalizing is optional. We only call it if we are given a finalizing agent.
614     if(address(finalizeAgent) != address(0)) {
615       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
616     }
617   }
618 
619   function areReservedTokensDistributed() public constant returns (bool) {
620     return finalizeAgent.reservedTokensAreDistributed();
621   }
622 
623   function canDistributeReservedTokens() public constant returns(bool) {
624     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
625     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
626     return false;
627   }
628 
629   /**
630    * Finalize a succcesful crowdsale.
631    *
632    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
633    */
634   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
635 
636     // Already finalized
637     if(finalized) {
638       throw;
639     }
640 
641     // Finalizing is optional. We only call it if we are given a finalizing agent.
642     if(address(finalizeAgent) != address(0)) {
643       finalizeAgent.finalizeCrowdsale();
644     }
645 
646     finalized = true;
647   }
648 
649   /**
650    * Allow to (re)set finalize agent.
651    *
652    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
653    */
654   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
655     assert(address(addr) != address(0));
656     assert(address(finalizeAgent) == address(0));
657     finalizeAgent = addr;
658 
659     // Don't allow setting bad agent
660     if(!finalizeAgent.isFinalizeAgent()) {
661       throw;
662     }
663   }
664 
665   /**
666    * Allow addresses to do early participation.
667    */
668   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
669     if (!isWhiteListed) throw;
670     assert(addr != address(0));
671     assert(maxCap > 0);
672     assert(minCap <= maxCap);
673     assert(now <= endsAt);
674 
675     if (!isAddressWhitelisted(addr)) {
676       whitelistedParticipants.push(addr);
677       Whitelisted(addr, status, minCap, maxCap);
678     } else {
679       WhitelistItemChanged(addr, status, minCap, maxCap);
680     }
681 
682     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
683   }
684 
685   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
686     if (!isWhiteListed) throw;
687     assert(now <= endsAt);
688     assert(addrs.length == statuses.length);
689     assert(statuses.length == minCaps.length);
690     assert(minCaps.length == maxCaps.length);
691     for (uint iterator = 0; iterator < addrs.length; iterator++) {
692       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
693     }
694   }
695 
696   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
697     if (!isWhiteListed) throw;
698     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
699 
700     uint8 tierPosition = getTierPosition(this);
701 
702     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
703       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
704       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
705     }
706   }
707 
708   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
709     if (!isWhiteListed) throw;
710     assert(addr != address(0));
711     assert(now <= endsAt);
712     assert(isTierJoined(msg.sender));
713     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
714     //if (addr != msg.sender && contractAddr != msg.sender) throw;
715     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
716     newMaxCap = newMaxCap.minus(tokensBought);
717     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
718   }
719 
720   function isAddressWhitelisted(address addr) public constant returns(bool) {
721     for (uint i = 0; i < whitelistedParticipants.length; i++) {
722       if (whitelistedParticipants[i] == addr) {
723         return true;
724         break;
725       }
726     }
727 
728     return false;
729   }
730 
731   function whitelistedParticipantsLength() public constant returns (uint) {
732     return whitelistedParticipants.length;
733   }
734 
735   function isTierJoined(address addr) public constant returns(bool) {
736     return joinedCrowdsaleState[addr].isJoined;
737   }
738 
739   function getTierPosition(address addr) public constant returns(uint8) {
740     return joinedCrowdsaleState[addr].position;
741   }
742 
743   function getLastTier() public constant returns(address) {
744     if (joinedCrowdsalesLen > 0)
745       return joinedCrowdsales[joinedCrowdsalesLen - 1];
746     else
747       return address(0);
748   }
749 
750   function setJoinedCrowdsales(address addr) private onlyOwner {
751     assert(addr != address(0));
752     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
753     assert(!isTierJoined(addr));
754     joinedCrowdsales.push(addr);
755     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
756       isJoined: true,
757       position: joinedCrowdsalesLen
758     });
759     joinedCrowdsalesLen++;
760   }
761 
762   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
763     assert(addrs.length > 0);
764     assert(joinedCrowdsalesLen == 0);
765     assert(addrs.length <= joinedCrowdsalesLenMax);
766     for (uint8 iter = 0; iter < addrs.length; iter++) {
767       setJoinedCrowdsales(addrs[iter]);
768     }
769   }
770 
771   function setStartsAt(uint time) onlyOwner {
772     assert(!finalized);
773     assert(isUpdatable);
774     assert(now <= time); // Don't change past
775     assert(time <= endsAt);
776     assert(now <= startsAt);
777 
778     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
779     if (lastTierCntrct.finalized()) throw;
780 
781     uint8 tierPosition = getTierPosition(this);
782 
783     //start time should be greater then end time of previous tiers
784     for (uint8 j = 0; j < tierPosition; j++) {
785       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
786       assert(time >= crowdsale.endsAt());
787     }
788 
789     startsAt = time;
790     StartsAtChanged(startsAt);
791   }
792 
793   /**
794    * Allow crowdsale owner to close early or extend the crowdsale.
795    *
796    * This is useful e.g. for a manual soft cap implementation:
797    * - after X amount is reached determine manual closing
798    *
799    * This may put the crowdsale to an invalid state,
800    * but we trust owners know what they are doing.
801    *
802    */
803   function setEndsAt(uint time) public onlyOwner {
804     assert(!finalized);
805     assert(isUpdatable);
806     assert(now <= time);// Don't change past
807     assert(startsAt <= time);
808     assert(now <= endsAt);
809 
810     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
811     if (lastTierCntrct.finalized()) throw;
812 
813 
814     uint8 tierPosition = getTierPosition(this);
815 
816     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
817       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
818       assert(time <= crowdsale.startsAt());
819     }
820 
821     endsAt = time;
822     EndsAtChanged(endsAt);
823   }
824 
825   /**
826    * Allow to (re)set pricing strategy.
827    *
828    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
829    */
830   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
831     assert(address(_pricingStrategy) != address(0));
832     assert(address(pricingStrategy) == address(0));
833     pricingStrategy = _pricingStrategy;
834 
835     // Don't allow setting bad agent
836     if(!pricingStrategy.isPricingStrategy()) {
837       throw;
838     }
839   }
840 
841   /**
842    * Allow to change the team multisig address in the case of emergency.
843    *
844    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
845    * (we have done only few test transactions). After the crowdsale is going
846    * then multisig address stays locked for the safety reasons.
847    */
848   function setMultisig(address addr) public onlyOwner {
849 
850     // Change
851     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
852       throw;
853     }
854 
855     multisigWallet = addr;
856   }
857 
858   /**
859    * @return true if the crowdsale has raised enough money to be a successful.
860    */
861   function isMinimumGoalReached() public constant returns (bool reached) {
862     return weiRaised >= minimumFundingGoal;
863   }
864 
865   /**
866    * Check if the contract relationship looks good.
867    */
868   function isFinalizerSane() public constant returns (bool sane) {
869     return finalizeAgent.isSane();
870   }
871 
872   /**
873    * Check if the contract relationship looks good.
874    */
875   function isPricingSane() public constant returns (bool sane) {
876     return pricingStrategy.isSane(address(this));
877   }
878 
879   /**
880    * Crowdfund state machine management.
881    *
882    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
883    */
884   function getState() public constant returns (State) {
885     if(finalized) return State.Finalized;
886     else if (address(finalizeAgent) == 0) return State.Preparing;
887     else if (!finalizeAgent.isSane()) return State.Preparing;
888     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
889     else if (block.timestamp < startsAt) return State.PreFunding;
890     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
891     else if (isMinimumGoalReached()) return State.Success;
892     else return State.Failure;
893   }
894 
895   /** Interface marker. */
896   function isCrowdsale() public constant returns (bool) {
897     return true;
898   }
899 
900   //
901   // Modifiers
902   //
903 
904   /** Modified allowing execution only if the crowdsale is currently running.  */
905   modifier inState(State state) {
906     if(getState() != state) throw;
907     _;
908   }
909 
910 
911   //
912   // Abstract functions
913   //
914 
915   /**
916    * Check if the current invested breaks our cap rules.
917    *
918    *
919    * The child contract must define their own cap setting rules.
920    * We allow a lot of flexibility through different capping strategies (ETH, token count)
921    * Called from invest().
922    *
923    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
924    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
925    * @param weiRaisedTotal What would be our total raised balance after this transaction
926    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
927    *
928    * @return true if taking this investment would break our cap rules
929    */
930   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
931 
932   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
933 
934   /**
935    * Check if the current crowdsale is full and we can no longer sell any tokens.
936    */
937   function isCrowdsaleFull() public constant returns (bool);
938 
939   /**
940    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
941    */
942   function assignTokens(address receiver, uint tokenAmount) private;
943 }
944 
945 /**
946  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
947  *
948  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
949  */
950 
951 
952 
953 /**
954  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
955  *
956  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
957  */
958 
959 
960 
961 
962 
963 
964 
965 
966 /**
967  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
968  *
969  * Based on code by FirstBlood:
970  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
971  */
972 contract StandardToken is ERC20, SafeMath {
973 
974   /* Token supply got increased and a new owner received these tokens */
975   event Minted(address receiver, uint amount);
976 
977   /* Actual balances of token holders */
978   mapping(address => uint) balances;
979 
980   /* approve() allowances */
981   mapping (address => mapping (address => uint)) allowed;
982 
983   /* Interface declaration */
984   function isToken() public constant returns (bool weAre) {
985     return true;
986   }
987 
988   function transfer(address _to, uint _value) returns (bool success) {
989     balances[msg.sender] = safeSub(balances[msg.sender], _value);
990     balances[_to] = safeAdd(balances[_to], _value);
991     Transfer(msg.sender, _to, _value);
992     return true;
993   }
994 
995   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
996     uint _allowance = allowed[_from][msg.sender];
997 
998     balances[_to] = safeAdd(balances[_to], _value);
999     balances[_from] = safeSub(balances[_from], _value);
1000     allowed[_from][msg.sender] = safeSub(_allowance, _value);
1001     Transfer(_from, _to, _value);
1002     return true;
1003   }
1004 
1005   function balanceOf(address _owner) constant returns (uint balance) {
1006     return balances[_owner];
1007   }
1008 
1009   function approve(address _spender, uint _value) returns (bool success) {
1010 
1011     // To change the approve amount you first have to reduce the addresses`
1012     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1013     //  already 0 to mitigate the race condition described here:
1014     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1015     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1016 
1017     allowed[msg.sender][_spender] = _value;
1018     Approval(msg.sender, _spender, _value);
1019     return true;
1020   }
1021 
1022   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1023     return allowed[_owner][_spender];
1024   }
1025 
1026 }
1027 
1028 
1029 
1030 
1031 
1032 /**
1033  * A token that can increase its supply by another contract.
1034  *
1035  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1036  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1037  *
1038  */
1039 contract MintableTokenExt is StandardToken, Ownable {
1040 
1041   using SafeMathLibExt for uint;
1042 
1043   bool public mintingFinished = false;
1044 
1045   /** List of agents that are allowed to create new tokens */
1046   mapping (address => bool) public mintAgents;
1047 
1048   event MintingAgentChanged(address addr, bool state  );
1049 
1050   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1051   * For example, for reserved tokens in percents 2.54%
1052   * inPercentageUnit = 254
1053   * inPercentageDecimals = 2
1054   */
1055   struct ReservedTokensData {
1056     uint inTokens;
1057     uint inPercentageUnit;
1058     uint inPercentageDecimals;
1059     bool isReserved;
1060     bool isDistributed;
1061   }
1062 
1063   mapping (address => ReservedTokensData) public reservedTokensList;
1064   address[] public reservedTokensDestinations;
1065   uint public reservedTokensDestinationsLen = 0;
1066   bool reservedTokensDestinationsAreSet = false;
1067 
1068   modifier onlyMintAgent() {
1069     // Only crowdsale contracts are allowed to mint new tokens
1070     if(!mintAgents[msg.sender]) {
1071         throw;
1072     }
1073     _;
1074   }
1075 
1076   /** Make sure we are not done yet. */
1077   modifier canMint() {
1078     if(mintingFinished) throw;
1079     _;
1080   }
1081 
1082   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1083     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1084     reservedTokensData.isDistributed = true;
1085   }
1086 
1087   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1088     return reservedTokensList[addr].isReserved;
1089   }
1090 
1091   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1092     return reservedTokensList[addr].isDistributed;
1093   }
1094 
1095   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1096     return reservedTokensList[addr].inTokens;
1097   }
1098 
1099   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1100     return reservedTokensList[addr].inPercentageUnit;
1101   }
1102 
1103   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1104     return reservedTokensList[addr].inPercentageDecimals;
1105   }
1106 
1107   function setReservedTokensListMultiple(
1108     address[] addrs, 
1109     uint[] inTokens, 
1110     uint[] inPercentageUnit, 
1111     uint[] inPercentageDecimals
1112   ) public canMint onlyOwner {
1113     assert(!reservedTokensDestinationsAreSet);
1114     assert(addrs.length == inTokens.length);
1115     assert(inTokens.length == inPercentageUnit.length);
1116     assert(inPercentageUnit.length == inPercentageDecimals.length);
1117     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1118       if (addrs[iterator] != address(0)) {
1119         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1120       }
1121     }
1122     reservedTokensDestinationsAreSet = true;
1123   }
1124 
1125   /**
1126    * Create new tokens and allocate them to an address..
1127    *
1128    * Only callably by a crowdsale contract (mint agent).
1129    */
1130   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1131     totalSupply = totalSupply.plus(amount);
1132     balances[receiver] = balances[receiver].plus(amount);
1133 
1134     // This will make the mint transaction apper in EtherScan.io
1135     // We can remove this after there is a standardized minting event
1136     Transfer(0, receiver, amount);
1137   }
1138 
1139   /**
1140    * Owner can allow a crowdsale contract to mint new tokens.
1141    */
1142   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1143     mintAgents[addr] = state;
1144     MintingAgentChanged(addr, state);
1145   }
1146 
1147   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1148     assert(addr != address(0));
1149     if (!isAddressReserved(addr)) {
1150       reservedTokensDestinations.push(addr);
1151       reservedTokensDestinationsLen++;
1152     }
1153 
1154     reservedTokensList[addr] = ReservedTokensData({
1155       inTokens: inTokens, 
1156       inPercentageUnit: inPercentageUnit, 
1157       inPercentageDecimals: inPercentageDecimals,
1158       isReserved: true,
1159       isDistributed: false
1160     });
1161   }
1162 }
1163 
1164 /**
1165  * ICO crowdsale contract that is capped by amout of tokens.
1166  *
1167  * - Tokens are dynamically created during the crowdsale
1168  *
1169  *
1170  */
1171 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1172 
1173   /* Maximum amount of tokens this crowdsale can sell. */
1174   uint public maximumSellableTokens;
1175 
1176   function MintedTokenCappedCrowdsaleExt(
1177     string _name, 
1178     address _token, 
1179     PricingStrategy _pricingStrategy, 
1180     address _multisigWallet, 
1181     uint _start, uint _end, 
1182     uint _minimumFundingGoal, 
1183     uint _maximumSellableTokens, 
1184     bool _isUpdatable, 
1185     bool _isWhiteListed
1186   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1187     maximumSellableTokens = _maximumSellableTokens;
1188   }
1189 
1190   // Crowdsale maximumSellableTokens has been changed
1191   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1192 
1193   /**
1194    * Called from invest() to confirm if the curret investment does not break our cap rule.
1195    */
1196   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1197     return tokensSoldTotal > maximumSellableTokens;
1198   }
1199 
1200   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1201     assert(isWhiteListed);
1202     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1203     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1204   }
1205 
1206   function isCrowdsaleFull() public constant returns (bool) {
1207     return tokensSold >= maximumSellableTokens;
1208   }
1209 
1210   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1211     assert(!finalized);
1212     assert(isUpdatable);
1213     assert(now <= startsAt);
1214 
1215     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1216     assert(!lastTierCntrct.finalized());
1217 
1218     maximumSellableTokens = tokens;
1219     MaximumSellableTokensChanged(maximumSellableTokens);
1220   }
1221 
1222   function updateRate(uint newOneTokenInWei) public onlyOwner {
1223     assert(!finalized);
1224     assert(isUpdatable);
1225     assert(now <= startsAt);
1226 
1227     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1228     assert(!lastTierCntrct.finalized());
1229 
1230     pricingStrategy.updateRate(newOneTokenInWei);
1231   }
1232 
1233   /**
1234    * Dynamically create tokens and assign them to the investor.
1235    */
1236   function assignTokens(address receiver, uint tokenAmount) private {
1237     MintableTokenExt mintableToken = MintableTokenExt(token);
1238     mintableToken.mint(receiver, tokenAmount);
1239   }
1240 }