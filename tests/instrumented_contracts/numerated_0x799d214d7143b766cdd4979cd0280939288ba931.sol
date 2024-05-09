1 // Created using Token Wizard https://github.com/poanetwork/token-wizard by POA Network 
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
110 
111 
112 /**
113  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
114  *
115  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
116  */
117 
118 
119 
120 /**
121  * Safe unsigned safe math.
122  *
123  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
124  *
125  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
126  *
127  * Maintained here until merged to mainline zeppelin-solidity.
128  *
129  */
130 library SafeMathLibExt {
131 
132   function times(uint a, uint b) returns (uint) {
133     uint c = a * b;
134     assert(a == 0 || c / a == b);
135     return c;
136   }
137 
138   function divides(uint a, uint b) returns (uint) {
139     assert(b > 0);
140     uint c = a / b;
141     assert(a == b * c + a % b);
142     return c;
143   }
144 
145   function minus(uint a, uint b) returns (uint) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   function plus(uint a, uint b) returns (uint) {
151     uint c = a + b;
152     assert(c>=a);
153     return c;
154   }
155 
156 }
157 
158 /**
159  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
160  *
161  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
162  */
163 
164 
165 
166 
167 /**
168  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
169  *
170  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
171  */
172 
173 
174 
175 
176 
177 /*
178  * Haltable
179  *
180  * Abstract contract that allows children to implement an
181  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
182  *
183  *
184  * Originally envisioned in FirstBlood ICO contract.
185  */
186 contract Haltable is Ownable {
187   bool public halted;
188 
189   modifier stopInEmergency {
190     if (halted) throw;
191     _;
192   }
193 
194   modifier stopNonOwnersInEmergency {
195     if (halted && msg.sender != owner) throw;
196     _;
197   }
198 
199   modifier onlyInEmergency {
200     if (!halted) throw;
201     _;
202   }
203 
204   // called by the owner on emergency, triggers stopped state
205   function halt() external onlyOwner {
206     halted = true;
207   }
208 
209   // called by the owner on end of emergency, returns to normal state
210   function unhalt() external onlyOwner onlyInEmergency {
211     halted = false;
212   }
213 
214 }
215 
216 /**
217  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
218  *
219  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
220  */
221 
222 
223 
224 /**
225  * Interface for defining crowdsale pricing.
226  */
227 contract PricingStrategy {
228 
229   address public tier;
230 
231   /** Interface declaration. */
232   function isPricingStrategy() public constant returns (bool) {
233     return true;
234   }
235 
236   /** Self check if all references are correctly set.
237    *
238    * Checks that pricing strategy matches crowdsale parameters.
239    */
240   function isSane(address crowdsale) public constant returns (bool) {
241     return true;
242   }
243 
244   /**
245    * @dev Pricing tells if this is a presale purchase or not.
246      @param purchaser Address of the purchaser
247      @return False by default, true if a presale purchaser
248    */
249   function isPresalePurchase(address purchaser) public constant returns (bool) {
250     return false;
251   }
252 
253   /* How many weis one token costs */
254   function updateRate(uint newOneTokenInWei) public;
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
287   bool public reservedTokensAreDistributed = false;
288 
289   function isFinalizeAgent() public constant returns(bool) {
290     return true;
291   }
292 
293   /** Return true if we can run finalizeCrowdsale() properly.
294    *
295    * This is a safety check function that doesn't allow crowdsale to begin
296    * unless the finalizer has been set up properly.
297    */
298   function isSane() public constant returns (bool);
299 
300   function distributeReservedTokens(uint reservedTokensDistributionBatch);
301 
302   /** Called once by crowdsale finalize() if the sale was success. */
303   function finalizeCrowdsale();
304 
305 }
306 /**
307  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
308  *
309  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
310  */
311 
312 
313 
314 
315 
316 
317 
318 
319 
320 /**
321  * @title ERC20 interface
322  * @dev see https://github.com/ethereum/EIPs/issues/20
323  */
324 contract ERC20 is ERC20Basic {
325   function allowance(address owner, address spender) public constant returns (uint256);
326   function transferFrom(address from, address to, uint256 value) public returns (bool);
327   function approve(address spender, uint256 value) public returns (bool);
328   event Approval(address indexed owner, address indexed spender, uint256 value);
329 }
330 
331 
332 /**
333  * A token that defines fractional units as decimals.
334  */
335 contract FractionalERC20Ext is ERC20 {
336 
337   uint public decimals;
338   uint public minCap;
339 
340 }
341 
342 
343 
344 /**
345  * Abstract base contract for token sales.
346  *
347  * Handle
348  * - start and end dates
349  * - accepting investments
350  * - minimum funding goal and refund
351  * - various statistics during the crowdfund
352  * - different pricing strategies
353  * - different investment policies (require server side customer id, allow only whitelisted addresses)
354  *
355  */
356 contract CrowdsaleExt is Haltable {
357 
358   /* Max investment count when we are still allowed to change the multisig address */
359   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
360 
361   using SafeMathLibExt for uint;
362 
363   /* The token we are selling */
364   FractionalERC20Ext public token;
365 
366   /* How we are going to price our offering */
367   PricingStrategy public pricingStrategy;
368 
369   /* Post-success callback */
370   FinalizeAgent public finalizeAgent;
371 
372   /* name of the crowdsale tier */
373   string public name;
374 
375   /* tokens will be transfered from this address */
376   address public multisigWallet;
377 
378   /* if the funding goal is not reached, investors may withdraw their funds */
379   uint public minimumFundingGoal;
380 
381   /* the UNIX timestamp start date of the crowdsale */
382   uint public startsAt;
383 
384   /* the UNIX timestamp end date of the crowdsale */
385   uint public endsAt;
386 
387   /* the number of tokens already sold through this contract*/
388   uint public tokensSold = 0;
389 
390   /* How many wei of funding we have raised */
391   uint public weiRaised = 0;
392 
393   /* How many distinct addresses have invested */
394   uint public investorCount = 0;
395 
396   /* Has this crowdsale been finalized */
397   bool public finalized;
398 
399   bool public isWhiteListed;
400 
401   address[] public joinedCrowdsales;
402   uint8 public joinedCrowdsalesLen = 0;
403   uint8 public joinedCrowdsalesLenMax = 50;
404   struct JoinedCrowdsaleStatus {
405     bool isJoined;
406     uint8 position;
407   }
408   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
409 
410   /** How much ETH each address has invested to this crowdsale */
411   mapping (address => uint256) public investedAmountOf;
412 
413   /** How much tokens this crowdsale has credited for each investor address */
414   mapping (address => uint256) public tokenAmountOf;
415 
416   struct WhiteListData {
417     bool status;
418     uint minCap;
419     uint maxCap;
420   }
421 
422   //is crowdsale updatable
423   bool public isUpdatable;
424 
425   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
426   mapping (address => WhiteListData) public earlyParticipantWhitelist;
427 
428   /** List of whitelisted addresses */
429   address[] public whitelistedParticipants;
430 
431   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
432   uint public ownerTestValue;
433 
434   /** State machine
435    *
436    * - Preparing: All contract initialization calls and variables have not been set yet
437    * - Prefunding: We have not passed start time yet
438    * - Funding: Active crowdsale
439    * - Success: Minimum funding goal reached
440    * - Failure: Minimum funding goal not reached before ending time
441    * - Finalized: The finalized has been called and succesfully executed
442    */
443   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
444 
445   // A new investment was made
446   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
447 
448   // Address early participation whitelist status changed
449   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
450   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
451 
452   // Crowdsale start time has been changed
453   event StartsAtChanged(uint newStartsAt);
454 
455   // Crowdsale end time has been changed
456   event EndsAtChanged(uint newEndsAt);
457 
458   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
459 
460     owner = msg.sender;
461 
462     name = _name;
463 
464     token = FractionalERC20Ext(_token);
465 
466     setPricingStrategy(_pricingStrategy);
467 
468     multisigWallet = _multisigWallet;
469     if(multisigWallet == 0) {
470         throw;
471     }
472 
473     if(_start == 0) {
474         throw;
475     }
476 
477     startsAt = _start;
478 
479     if(_end == 0) {
480         throw;
481     }
482 
483     endsAt = _end;
484 
485     // Don't mess the dates
486     if(startsAt >= endsAt) {
487         throw;
488     }
489 
490     // Minimum funding goal can be zero
491     minimumFundingGoal = _minimumFundingGoal;
492 
493     isUpdatable = _isUpdatable;
494 
495     isWhiteListed = _isWhiteListed;
496   }
497 
498   /**
499    * Don't expect to just send in money and get tokens.
500    */
501   function() payable {
502     throw;
503   }
504 
505   /**
506    * Make an investment.
507    *
508    * Crowdsale must be running for one to invest.
509    * We must have not pressed the emergency brake.
510    *
511    * @param receiver The Ethereum address who receives the tokens
512    * @param customerId (optional) UUID v4 to track the successful payments on the server side
513    *
514    */
515   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
516 
517     // Determine if it's a good time to accept investment from this participant
518     if(getState() == State.PreFunding) {
519       // Are we whitelisted for early deposit
520       throw;
521     } else if(getState() == State.Funding) {
522       // Retail participants can only come in when the crowdsale is running
523       // pass
524       if(isWhiteListed) {
525         if(!earlyParticipantWhitelist[receiver].status) {
526           throw;
527         }
528       }
529     } else {
530       // Unwanted state
531       throw;
532     }
533 
534     uint weiAmount = msg.value;
535 
536     // Account presale sales separately, so that they do not count against pricing tranches
537     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
538 
539     if(tokenAmount == 0) {
540       // Dust transaction
541       throw;
542     }
543 
544     if(isWhiteListed) {
545       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
546         // tokenAmount < minCap for investor
547         throw;
548       }
549 
550       // Check that we did not bust the investor's cap
551       if (isBreakingInvestorCap(receiver, tokenAmount)) {
552         throw;
553       }
554 
555       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
556     } else {
557       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
558         throw;
559       }
560     }
561 
562     if(investedAmountOf[receiver] == 0) {
563        // A new investor
564        investorCount++;
565     }
566 
567     // Update investor
568     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
569     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
570 
571     // Update totals
572     weiRaised = weiRaised.plus(weiAmount);
573     tokensSold = tokensSold.plus(tokenAmount);
574 
575     // Check that we did not bust the cap
576     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
577       throw;
578     }
579 
580     assignTokens(receiver, tokenAmount);
581 
582     // Pocket the money
583     if(!multisigWallet.send(weiAmount)) throw;
584 
585     // Tell us invest was success
586     Invested(receiver, weiAmount, tokenAmount, customerId);
587   }
588 
589   /**
590    * Allow anonymous contributions to this crowdsale.
591    */
592   function invest(address addr) public payable {
593     investInternal(addr, 0);
594   }
595 
596   /**
597    * The basic entry point to participate the crowdsale process.
598    *
599    * Pay for funding, get invested tokens back in the sender address.
600    */
601   function buy() public payable {
602     invest(msg.sender);
603   }
604 
605   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
606     // Already finalized
607     if(finalized) {
608       throw;
609     }
610 
611     // Finalizing is optional. We only call it if we are given a finalizing agent.
612     if(address(finalizeAgent) != address(0)) {
613       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
614     }
615   }
616 
617   function areReservedTokensDistributed() public constant returns (bool) {
618     return finalizeAgent.reservedTokensAreDistributed();
619   }
620 
621   function canDistributeReservedTokens() public constant returns(bool) {
622     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
623     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
624     return false;
625   }
626 
627   /**
628    * Finalize a succcesful crowdsale.
629    *
630    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
631    */
632   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
633 
634     // Already finalized
635     if(finalized) {
636       throw;
637     }
638 
639     // Finalizing is optional. We only call it if we are given a finalizing agent.
640     if(address(finalizeAgent) != address(0)) {
641       finalizeAgent.finalizeCrowdsale();
642     }
643 
644     finalized = true;
645   }
646 
647   /**
648    * Allow to (re)set finalize agent.
649    *
650    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
651    */
652   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
653     assert(address(addr) != address(0));
654     assert(address(finalizeAgent) == address(0));
655     finalizeAgent = addr;
656 
657     // Don't allow setting bad agent
658     if(!finalizeAgent.isFinalizeAgent()) {
659       throw;
660     }
661   }
662 
663   /**
664    * Allow addresses to do early participation.
665    */
666   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
667     if (!isWhiteListed) throw;
668     assert(addr != address(0));
669     assert(maxCap > 0);
670     assert(minCap <= maxCap);
671     assert(now <= endsAt);
672 
673     if (!isAddressWhitelisted(addr)) {
674       whitelistedParticipants.push(addr);
675       Whitelisted(addr, status, minCap, maxCap);
676     } else {
677       WhitelistItemChanged(addr, status, minCap, maxCap);
678     }
679 
680     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
681   }
682 
683   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
684     if (!isWhiteListed) throw;
685     assert(now <= endsAt);
686     assert(addrs.length == statuses.length);
687     assert(statuses.length == minCaps.length);
688     assert(minCaps.length == maxCaps.length);
689     for (uint iterator = 0; iterator < addrs.length; iterator++) {
690       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
691     }
692   }
693 
694   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
695     if (!isWhiteListed) throw;
696     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
697 
698     uint8 tierPosition = getTierPosition(this);
699 
700     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
701       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
702       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
703     }
704   }
705 
706   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
707     if (!isWhiteListed) throw;
708     assert(addr != address(0));
709     assert(now <= endsAt);
710     assert(isTierJoined(msg.sender));
711     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
712     //if (addr != msg.sender && contractAddr != msg.sender) throw;
713     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
714     newMaxCap = newMaxCap.minus(tokensBought);
715     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
716   }
717 
718   function isAddressWhitelisted(address addr) public constant returns(bool) {
719     for (uint i = 0; i < whitelistedParticipants.length; i++) {
720       if (whitelistedParticipants[i] == addr) {
721         return true;
722         break;
723       }
724     }
725 
726     return false;
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
1026 /**
1027  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1028  *
1029  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1030  */
1031 
1032 
1033 
1034 
1035 
1036 /**
1037  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1038  *
1039  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1040  */
1041 
1042 
1043 
1044 /**
1045  * Upgrade agent interface inspired by Lunyr.
1046  *
1047  * Upgrade agent transfers tokens to a new contract.
1048  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
1049  */
1050 contract UpgradeAgent {
1051 
1052   uint public originalSupply;
1053 
1054   /** Interface marker */
1055   function isUpgradeAgent() public constant returns (bool) {
1056     return true;
1057   }
1058 
1059   function upgradeFrom(address _from, uint256 _value) public;
1060 
1061 }
1062 
1063 
1064 /**
1065  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
1066  *
1067  * First envisioned by Golem and Lunyr projects.
1068  */
1069 contract UpgradeableToken is StandardToken {
1070 
1071   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
1072   address public upgradeMaster;
1073 
1074   /** The next contract where the tokens will be migrated. */
1075   UpgradeAgent public upgradeAgent;
1076 
1077   /** How many tokens we have upgraded by now. */
1078   uint256 public totalUpgraded;
1079 
1080   /**
1081    * Upgrade states.
1082    *
1083    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
1084    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
1085    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
1086    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
1087    *
1088    */
1089   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
1090 
1091   /**
1092    * Somebody has upgraded some of his tokens.
1093    */
1094   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1095 
1096   /**
1097    * New upgrade agent available.
1098    */
1099   event UpgradeAgentSet(address agent);
1100 
1101   /**
1102    * Do not allow construction without upgrade master set.
1103    */
1104   function UpgradeableToken(address _upgradeMaster) {
1105     upgradeMaster = _upgradeMaster;
1106   }
1107 
1108   /**
1109    * Allow the token holder to upgrade some of their tokens to a new contract.
1110    */
1111   function upgrade(uint256 value) public {
1112 
1113       UpgradeState state = getUpgradeState();
1114       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
1115         // Called in a bad state
1116         throw;
1117       }
1118 
1119       // Validate input value.
1120       if (value == 0) throw;
1121 
1122       balances[msg.sender] = safeSub(balances[msg.sender], value);
1123 
1124       // Take tokens out from circulation
1125       totalSupply = safeSub(totalSupply, value);
1126       totalUpgraded = safeAdd(totalUpgraded, value);
1127 
1128       // Upgrade agent reissues the tokens
1129       upgradeAgent.upgradeFrom(msg.sender, value);
1130       Upgrade(msg.sender, upgradeAgent, value);
1131   }
1132 
1133   /**
1134    * Set an upgrade agent that handles
1135    */
1136   function setUpgradeAgent(address agent) external {
1137 
1138       if(!canUpgrade()) {
1139         // The token is not yet in a state that we could think upgrading
1140         throw;
1141       }
1142 
1143       if (agent == 0x0) throw;
1144       // Only a master can designate the next agent
1145       if (msg.sender != upgradeMaster) throw;
1146       // Upgrade has already begun for an agent
1147       if (getUpgradeState() == UpgradeState.Upgrading) throw;
1148 
1149       upgradeAgent = UpgradeAgent(agent);
1150 
1151       // Bad interface
1152       if(!upgradeAgent.isUpgradeAgent()) throw;
1153       // Make sure that token supplies match in source and target
1154       if (upgradeAgent.originalSupply() != totalSupply) throw;
1155 
1156       UpgradeAgentSet(upgradeAgent);
1157   }
1158 
1159   /**
1160    * Get the state of the token upgrade.
1161    */
1162   function getUpgradeState() public constant returns(UpgradeState) {
1163     if(!canUpgrade()) return UpgradeState.NotAllowed;
1164     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
1165     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1166     else return UpgradeState.Upgrading;
1167   }
1168 
1169   /**
1170    * Change the upgrade master.
1171    *
1172    * This allows us to set a new owner for the upgrade mechanism.
1173    */
1174   function setUpgradeMaster(address master) public {
1175       if (master == 0x0) throw;
1176       if (msg.sender != upgradeMaster) throw;
1177       upgradeMaster = master;
1178   }
1179 
1180   /**
1181    * Child contract can enable to provide the condition when the upgrade can begun.
1182    */
1183   function canUpgrade() public constant returns(bool) {
1184      return true;
1185   }
1186 
1187 }
1188 
1189 /**
1190  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1191  *
1192  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1193  */
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 /**
1202  * Define interface for releasing the token transfer after a successful crowdsale.
1203  */
1204 contract ReleasableToken is ERC20, Ownable {
1205 
1206   /* The finalizer contract that allows unlift the transfer limits on this token */
1207   address public releaseAgent;
1208 
1209   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
1210   bool public released = false;
1211 
1212   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
1213   mapping (address => bool) public transferAgents;
1214 
1215   /**
1216    * Limit token transfer until the crowdsale is over.
1217    *
1218    */
1219   modifier canTransfer(address _sender) {
1220 
1221     if(!released) {
1222         if(!transferAgents[_sender]) {
1223             throw;
1224         }
1225     }
1226 
1227     _;
1228   }
1229 
1230   /**
1231    * Set the contract that can call release and make the token transferable.
1232    *
1233    * Design choice. Allow reset the release agent to fix fat finger mistakes.
1234    */
1235   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
1236 
1237     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
1238     releaseAgent = addr;
1239   }
1240 
1241   /**
1242    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
1243    */
1244   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
1245     transferAgents[addr] = state;
1246   }
1247 
1248   /**
1249    * One way function to release the tokens to the wild.
1250    *
1251    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
1252    */
1253   function releaseTokenTransfer() public onlyReleaseAgent {
1254     released = true;
1255   }
1256 
1257   /** The function can be called only before or after the tokens have been releasesd */
1258   modifier inReleaseState(bool releaseState) {
1259     if(releaseState != released) {
1260         throw;
1261     }
1262     _;
1263   }
1264 
1265   /** The function can be called only by a whitelisted release agent. */
1266   modifier onlyReleaseAgent() {
1267     if(msg.sender != releaseAgent) {
1268         throw;
1269     }
1270     _;
1271   }
1272 
1273   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
1274     // Call StandardToken.transfer()
1275    return super.transfer(_to, _value);
1276   }
1277 
1278   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
1279     // Call StandardToken.transferForm()
1280     return super.transferFrom(_from, _to, _value);
1281   }
1282 
1283 }
1284 
1285 /**
1286  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1287  *
1288  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1289  */
1290 
1291 
1292 
1293 
1294 
1295 
1296 
1297 
1298 /**
1299  * A token that can increase its supply by another contract.
1300  *
1301  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1302  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1303  *
1304  */
1305 contract MintableTokenExt is StandardToken, Ownable {
1306 
1307   using SafeMathLibExt for uint;
1308 
1309   bool public mintingFinished = false;
1310 
1311   /** List of agents that are allowed to create new tokens */
1312   mapping (address => bool) public mintAgents;
1313 
1314   event MintingAgentChanged(address addr, bool state  );
1315 
1316   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1317   * For example, for reserved tokens in percents 2.54%
1318   * inPercentageUnit = 254
1319   * inPercentageDecimals = 2
1320   */
1321   struct ReservedTokensData {
1322     uint inTokens;
1323     uint inPercentageUnit;
1324     uint inPercentageDecimals;
1325     bool isReserved;
1326     bool isDistributed;
1327   }
1328 
1329   mapping (address => ReservedTokensData) public reservedTokensList;
1330   address[] public reservedTokensDestinations;
1331   uint public reservedTokensDestinationsLen = 0;
1332   bool reservedTokensDestinationsAreSet = false;
1333 
1334   modifier onlyMintAgent() {
1335     // Only crowdsale contracts are allowed to mint new tokens
1336     if(!mintAgents[msg.sender]) {
1337         throw;
1338     }
1339     _;
1340   }
1341 
1342   /** Make sure we are not done yet. */
1343   modifier canMint() {
1344     if(mintingFinished) throw;
1345     _;
1346   }
1347 
1348   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1349     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1350     reservedTokensData.isDistributed = true;
1351   }
1352 
1353   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1354     return reservedTokensList[addr].isReserved;
1355   }
1356 
1357   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1358     return reservedTokensList[addr].isDistributed;
1359   }
1360 
1361   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1362     return reservedTokensList[addr].inTokens;
1363   }
1364 
1365   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1366     return reservedTokensList[addr].inPercentageUnit;
1367   }
1368 
1369   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1370     return reservedTokensList[addr].inPercentageDecimals;
1371   }
1372 
1373   function setReservedTokensListMultiple(
1374     address[] addrs, 
1375     uint[] inTokens, 
1376     uint[] inPercentageUnit, 
1377     uint[] inPercentageDecimals
1378   ) public canMint onlyOwner {
1379     assert(!reservedTokensDestinationsAreSet);
1380     assert(addrs.length == inTokens.length);
1381     assert(inTokens.length == inPercentageUnit.length);
1382     assert(inPercentageUnit.length == inPercentageDecimals.length);
1383     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1384       if (addrs[iterator] != address(0)) {
1385         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1386       }
1387     }
1388     reservedTokensDestinationsAreSet = true;
1389   }
1390 
1391   /**
1392    * Create new tokens and allocate them to an address..
1393    *
1394    * Only callably by a crowdsale contract (mint agent).
1395    */
1396   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1397     totalSupply = totalSupply.plus(amount);
1398     balances[receiver] = balances[receiver].plus(amount);
1399 
1400     // This will make the mint transaction apper in EtherScan.io
1401     // We can remove this after there is a standardized minting event
1402     Transfer(0, receiver, amount);
1403   }
1404 
1405   /**
1406    * Owner can allow a crowdsale contract to mint new tokens.
1407    */
1408   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1409     mintAgents[addr] = state;
1410     MintingAgentChanged(addr, state);
1411   }
1412 
1413   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1414     assert(addr != address(0));
1415     if (!isAddressReserved(addr)) {
1416       reservedTokensDestinations.push(addr);
1417       reservedTokensDestinationsLen++;
1418     }
1419 
1420     reservedTokensList[addr] = ReservedTokensData({
1421       inTokens: inTokens, 
1422       inPercentageUnit: inPercentageUnit, 
1423       inPercentageDecimals: inPercentageDecimals,
1424       isReserved: true,
1425       isDistributed: false
1426     });
1427   }
1428 }
1429 
1430 
1431 /**
1432  * A crowdsaled token.
1433  *
1434  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1435  *
1436  * - The token transfer() is disabled until the crowdsale is over
1437  * - The token contract gives an opt-in upgrade path to a new contract
1438  * - The same token can be part of several crowdsales through approve() mechanism
1439  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1440  *
1441  */
1442 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
1443 
1444   /** Name and symbol were updated. */
1445   event UpdatedTokenInformation(string newName, string newSymbol);
1446 
1447   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1448 
1449   string public name;
1450 
1451   string public symbol;
1452 
1453   uint public decimals;
1454 
1455   /* Minimum ammount of tokens every buyer can buy. */
1456   uint public minCap;
1457 
1458   /**
1459    * Construct the token.
1460    *
1461    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1462    *
1463    * @param _name Token name
1464    * @param _symbol Token symbol - should be all caps
1465    * @param _initialSupply How many tokens we start with
1466    * @param _decimals Number of decimal places
1467    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
1468    */
1469   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
1470     UpgradeableToken(msg.sender) {
1471 
1472     // Create any address, can be transferred
1473     // to team multisig via changeOwner(),
1474     // also remember to call setUpgradeMaster()
1475     owner = msg.sender;
1476 
1477     name = _name;
1478     symbol = _symbol;
1479 
1480     totalSupply = _initialSupply;
1481 
1482     decimals = _decimals;
1483 
1484     minCap = _globalMinCap;
1485 
1486     // Create initially all balance on the team multisig
1487     balances[owner] = totalSupply;
1488 
1489     if(totalSupply > 0) {
1490       Minted(owner, totalSupply);
1491     }
1492 
1493     // No more new supply allowed after the token creation
1494     if(!_mintable) {
1495       mintingFinished = true;
1496       if(totalSupply == 0) {
1497         throw; // Cannot create a token without supply and no minting
1498       }
1499     }
1500   }
1501 
1502   /**
1503    * When token is released to be transferable, enforce no new tokens can be created.
1504    */
1505   function releaseTokenTransfer() public onlyReleaseAgent {
1506     mintingFinished = true;
1507     super.releaseTokenTransfer();
1508   }
1509 
1510   /**
1511    * Allow upgrade agent functionality kick in only if the crowdsale was success.
1512    */
1513   function canUpgrade() public constant returns(bool) {
1514     return released && super.canUpgrade();
1515   }
1516 
1517   /**
1518    * Owner can update token information here.
1519    *
1520    * It is often useful to conceal the actual token association, until
1521    * the token operations, like central issuance or reissuance have been completed.
1522    *
1523    * This function allows the token owner to rename the token after the operations
1524    * have been completed and then point the audience to use the token contract.
1525    */
1526   function setTokenInformation(string _name, string _symbol) onlyOwner {
1527     name = _name;
1528     symbol = _symbol;
1529 
1530     UpdatedTokenInformation(name, symbol);
1531   }
1532 
1533   /**
1534    * Claim tokens that were accidentally sent to this contract.
1535    *
1536    * @param _token The address of the token contract that you want to recover.
1537    */
1538   function claimTokens(address _token) public onlyOwner {
1539     require(_token != address(0));
1540 
1541     ERC20 token = ERC20(_token);
1542     uint balance = token.balanceOf(this);
1543     token.transfer(owner, balance);
1544 
1545     ClaimedTokens(_token, owner, balance);
1546   }
1547 
1548 }
1549 
1550 
1551 /**
1552  * The default behavior for the crowdsale end.
1553  *
1554  * Unlock tokens.
1555  */
1556 contract ReservedTokensFinalizeAgent is FinalizeAgent {
1557   using SafeMathLibExt for uint;
1558   CrowdsaleTokenExt public token;
1559   CrowdsaleExt public crowdsale;
1560 
1561   uint public distributedReservedTokensDestinationsLen = 0;
1562 
1563   function ReservedTokensFinalizeAgent(CrowdsaleTokenExt _token, CrowdsaleExt _crowdsale) public {
1564     token = _token;
1565     crowdsale = _crowdsale;
1566   }
1567 
1568   /** Check that we can release the token */
1569   function isSane() public constant returns (bool) {
1570     return (token.releaseAgent() == address(this));
1571   }
1572 
1573   //distributes reserved tokens. Should be called before finalization
1574   function distributeReservedTokens(uint reservedTokensDistributionBatch) public {
1575     assert(msg.sender == address(crowdsale));
1576 
1577     assert(reservedTokensDistributionBatch > 0);
1578     assert(!reservedTokensAreDistributed);
1579     assert(distributedReservedTokensDestinationsLen < token.reservedTokensDestinationsLen());
1580 
1581 
1582     // How many % of tokens the founders and others get
1583     uint tokensSold = 0;
1584     for (uint8 i = 0; i < crowdsale.joinedCrowdsalesLen(); i++) {
1585       CrowdsaleExt tier = CrowdsaleExt(crowdsale.joinedCrowdsales(i));
1586       tokensSold = tokensSold.plus(tier.tokensSold());
1587     }
1588 
1589     uint startLooping = distributedReservedTokensDestinationsLen;
1590     uint batch = token.reservedTokensDestinationsLen().minus(distributedReservedTokensDestinationsLen);
1591     if (batch >= reservedTokensDistributionBatch) {
1592       batch = reservedTokensDistributionBatch;
1593     }
1594     uint endLooping = startLooping + batch;
1595 
1596     // move reserved tokens
1597     for (uint j = startLooping; j < endLooping; j++) {
1598       address reservedAddr = token.reservedTokensDestinations(j);
1599       if (!token.areTokensDistributedForAddress(reservedAddr)) {
1600         uint allocatedBonusInPercentage;
1601         uint allocatedBonusInTokens = token.getReservedTokens(reservedAddr);
1602         uint percentsOfTokensUnit = token.getReservedPercentageUnit(reservedAddr);
1603         uint percentsOfTokensDecimals = token.getReservedPercentageDecimals(reservedAddr);
1604 
1605         if (percentsOfTokensUnit > 0) {
1606           allocatedBonusInPercentage = tokensSold * percentsOfTokensUnit / 10**percentsOfTokensDecimals / 100;
1607           token.mint(reservedAddr, allocatedBonusInPercentage);
1608         }
1609 
1610         if (allocatedBonusInTokens > 0) {
1611           token.mint(reservedAddr, allocatedBonusInTokens);
1612         }
1613 
1614         token.finalizeReservedAddress(reservedAddr);
1615         distributedReservedTokensDestinationsLen++;
1616       }
1617     }
1618 
1619     if (distributedReservedTokensDestinationsLen == token.reservedTokensDestinationsLen()) {
1620       reservedTokensAreDistributed = true;
1621     }
1622   }
1623 
1624   /** Called once by crowdsale finalize() if the sale was success. */
1625   function finalizeCrowdsale() public {
1626     assert(msg.sender == address(crowdsale));
1627 
1628     if (token.reservedTokensDestinationsLen() > 0) {
1629       assert(reservedTokensAreDistributed);
1630     }
1631 
1632     token.releaseTokenTransfer();
1633   }
1634 
1635 }