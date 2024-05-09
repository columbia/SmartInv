1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   uint256 public totalSupply;
58   function balanceOf(address who) public constant returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   function Ownable() {
82     owner = msg.sender;
83   }
84 
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) onlyOwner public {
100     require(newOwner != address(0));
101     OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 
105 }
106 /**
107  * This smart contract code is Copyright 2018 BitFinance Ltd.
108  *
109  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
110  */
111 
112 
113 
114 /**
115  * This smart contract code is Copyright 2018 BitFinance Ltd.
116  *
117  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
118  */
119 
120 
121 
122 /**
123 * This smart contract code is Copyright 2018 BitFinance Ltd.
124  *
125  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
126  */
127 
128 
129 
130 /**
131  * Safe unsigned safe math.
132  *
133  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
134  *
135  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
136  *
137  * Maintained here until merged to mainline zeppelin-solidity.
138  *
139  */
140 library SafeMathLibExt {
141 
142   function times(uint a, uint b) returns (uint) {
143     uint c = a * b;
144     assert(a == 0 || c / a == b);
145     return c;
146   }
147 
148   function divides(uint a, uint b) returns (uint) {
149     assert(b > 0);
150     uint c = a / b;
151     assert(a == b * c + a % b);
152     return c;
153   }
154 
155   function minus(uint a, uint b) returns (uint) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   function plus(uint a, uint b) returns (uint) {
161     uint c = a + b;
162     assert(c>=a);
163     return c;
164   }
165 
166 }
167 
168 /**
169 * This smart contract code is Copyright 2018 BitFinance Ltd.
170  *
171  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
172  */
173 
174 
175 
176 
177 
178 /*
179  * Haltable
180  *
181  * Abstract contract that allows children to implement an
182  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
183  *
184  *
185  * Originally envisioned in FirstBlood ICO contract.
186  */
187 contract Haltable is Ownable {
188   bool public halted;
189 
190   modifier stopInEmergency {
191     if (halted) throw;
192     _;
193   }
194 
195   modifier stopNonOwnersInEmergency {
196     if (halted && msg.sender != owner) throw;
197     _;
198   }
199 
200   modifier onlyInEmergency {
201     if (!halted) throw;
202     _;
203   }
204 
205   // called by the owner on emergency, triggers stopped state
206   function halt() external onlyOwner {
207     halted = true;
208   }
209 
210   // called by the owner on end of emergency, returns to normal state
211   function unhalt() external onlyOwner onlyInEmergency {
212     halted = false;
213   }
214 
215 }
216 
217 /**
218  * This smart contract code is Copyright 2018 BitFinance Ltd.
219  *
220  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
221  */
222 
223 
224 
225 /**
226  * Interface for defining crowdsale pricing.
227  */
228 contract PricingStrategy {
229 
230   address public tier;
231 
232   /** Interface declaration. */
233   function isPricingStrategy() public constant returns (bool) {
234     return true;
235   }
236 
237   /** Self check if all references are correctly set.
238    *
239    * Checks that pricing strategy matches crowdsale parameters.
240    */
241   function isSane(address crowdsale) public constant returns (bool) {
242     return true;
243   }
244 
245   /**
246    * @dev Pricing tells if this is a presale purchase or not.
247      @param purchaser Address of the purchaser
248      @return False by default, true if a presale purchaser
249    */
250   function isPresalePurchase(address purchaser) public constant returns (bool) {
251     return false;
252   }
253 
254   /* How many weis one token costs */
255   function updateRate(uint newOneTokenInWei) public;
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
272 * This smart contract code is Copyright 2018 BitFinance Ltd.
273  *
274  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
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
288   bool public reservedTokensAreDistributed = false;
289 
290   function isFinalizeAgent() public constant returns(bool) {
291     return true;
292   }
293 
294   /** Return true if we can run finalizeCrowdsale() properly.
295    *
296    * This is a safety check function that doesn't allow crowdsale to begin
297    * unless the finalizer has been set up properly.
298    */
299   function isSane() public constant returns (bool);
300 
301   function distributeReservedTokens(uint reservedTokensDistributionBatch);
302 
303   /** Called once by crowdsale finalize() if the sale was success. */
304   function finalizeCrowdsale();
305 
306 }
307 /**
308  * This smart contract code is Copyright 2018 BitFinance Ltd.
309  *
310  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
311  */
312 
313 
314 
315 
316 
317 
318 
319 
320 
321 /**
322  * @title ERC20 interface
323  * @dev see https://github.com/ethereum/EIPs/issues/20
324  */
325 contract ERC20 is ERC20Basic {
326   function allowance(address owner, address spender) public constant returns (uint256);
327   function transferFrom(address from, address to, uint256 value) public returns (bool);
328   function approve(address spender, uint256 value) public returns (bool);
329   event Approval(address indexed owner, address indexed spender, uint256 value);
330 }
331 
332 
333 /**
334  * A token that defines fractional units as decimals.
335  */
336 contract FractionalERC20Ext is ERC20 {
337 
338   uint public decimals;
339   uint public minCap;
340 
341 }
342 
343 
344 
345 /**
346  * Abstract base contract for token sales.
347  *
348  * Handle
349  * - start and end dates
350  * - accepting investments
351  * - minimum funding goal and refund
352  * - various statistics during the crowdfund
353  * - different pricing strategies
354  * - different investment policies (require server side customer id, allow only whitelisted addresses)
355  *
356  */
357 contract CrowdsaleExt is Haltable {
358 
359   /* Max investment count when we are still allowed to change the multisig address */
360   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
361 
362   using SafeMathLibExt for uint;
363 
364   /* The token we are selling */
365   FractionalERC20Ext public token;
366 
367   /* How we are going to price our offering */
368   PricingStrategy public pricingStrategy;
369 
370   /* Post-success callback */
371   FinalizeAgent public finalizeAgent;
372 
373   /* name of the crowdsale tier */
374   string public name;
375 
376   /* tokens will be transfered from this address */
377   address public multisigWallet;
378 
379   /* if the funding goal is not reached, investors may withdraw their funds */
380   uint public minimumFundingGoal;
381 
382   /* the UNIX timestamp start date of the crowdsale */
383   uint public startsAt;
384 
385   /* the UNIX timestamp end date of the crowdsale */
386   uint public endsAt;
387 
388   /* the number of tokens already sold through this contract*/
389   uint public tokensSold = 0;
390 
391   /* How many wei of funding we have raised */
392   uint public weiRaised = 0;
393 
394   /* How many distinct addresses have invested */
395   uint public investorCount = 0;
396 
397   /* Has this crowdsale been finalized */
398   bool public finalized;
399 
400   bool public isWhiteListed;
401 
402   address[] public joinedCrowdsales;
403   uint8 public joinedCrowdsalesLen = 0;
404   uint8 public joinedCrowdsalesLenMax = 50;
405   struct JoinedCrowdsaleStatus {
406     bool isJoined;
407     uint8 position;
408   }
409   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
410 
411   /** How much ETH each address has invested to this crowdsale */
412   mapping (address => uint256) public investedAmountOf;
413 
414   /** How much tokens this crowdsale has credited for each investor address */
415   mapping (address => uint256) public tokenAmountOf;
416 
417   struct WhiteListData {
418     bool status;
419     uint minCap;
420     uint maxCap;
421   }
422 
423   //is crowdsale updatable
424   bool public isUpdatable;
425 
426   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
427   mapping (address => WhiteListData) public earlyParticipantWhitelist;
428 
429   /** List of whitelisted addresses */
430   address[] public whitelistedParticipants;
431 
432   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
433   uint public ownerTestValue;
434 
435   /** State machine
436    *
437    * - Preparing: All contract initialization calls and variables have not been set yet
438    * - Prefunding: We have not passed start time yet
439    * - Funding: Active crowdsale
440    * - Success: Minimum funding goal reached
441    * - Failure: Minimum funding goal not reached before ending time
442    * - Finalized: The finalized has been called and succesfully executed
443    */
444   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
445 
446   // A new investment was made
447   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
448 
449   // Address early participation whitelist status changed
450   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
451   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
452 
453   // Crowdsale start time has been changed
454   event StartsAtChanged(uint newStartsAt);
455 
456   // Crowdsale end time has been changed
457   event EndsAtChanged(uint newEndsAt);
458 
459   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
460 
461     owner = msg.sender;
462 
463     name = _name;
464 
465     token = FractionalERC20Ext(_token);
466 
467     setPricingStrategy(_pricingStrategy);
468 
469     multisigWallet = _multisigWallet;
470     if(multisigWallet == 0) {
471         throw;
472     }
473 
474     if(_start == 0) {
475         throw;
476     }
477 
478     startsAt = _start;
479 
480     if(_end == 0) {
481         throw;
482     }
483 
484     endsAt = _end;
485 
486     // Don't mess the dates
487     if(startsAt >= endsAt) {
488         throw;
489     }
490 
491     // Minimum funding goal can be zero
492     minimumFundingGoal = _minimumFundingGoal;
493 
494     isUpdatable = _isUpdatable;
495 
496     isWhiteListed = _isWhiteListed;
497   }
498 
499   /**
500    * Don't expect to just send in money and get tokens.
501    */
502   function() payable {
503     throw;
504   }
505 
506   /**
507    * Make an investment.
508    *
509    * Crowdsale must be running for one to invest.
510    * We must have not pressed the emergency brake.
511    *
512    * @param receiver The Ethereum address who receives the tokens
513    * @param customerId (optional) UUID v4 to track the successful payments on the server side
514    *
515    */
516   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
517 
518     // Determine if it's a good time to accept investment from this participant
519     if(getState() == State.PreFunding) {
520       // Are we whitelisted for early deposit
521       throw;
522     } else if(getState() == State.Funding) {
523       // Retail participants can only come in when the crowdsale is running
524       // pass
525       if(isWhiteListed) {
526         if(!earlyParticipantWhitelist[receiver].status) {
527           throw;
528         }
529       }
530     } else {
531       // Unwanted state
532       throw;
533     }
534 
535     uint weiAmount = msg.value;
536 
537     // Account presale sales separately, so that they do not count against pricing tranches
538     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
539 
540     if(tokenAmount == 0) {
541       // Dust transaction
542       throw;
543     }
544 
545     if(isWhiteListed) {
546       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
547         // tokenAmount < minCap for investor
548         throw;
549       }
550 
551       // Check that we did not bust the investor's cap
552       if (isBreakingInvestorCap(receiver, tokenAmount)) {
553         throw;
554       }
555 
556       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
557     } else {
558       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
559         throw;
560       }
561     }
562 
563     if(investedAmountOf[receiver] == 0) {
564        // A new investor
565        investorCount++;
566     }
567 
568     // Update investor
569     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
570     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
571 
572     // Update totals
573     weiRaised = weiRaised.plus(weiAmount);
574     tokensSold = tokensSold.plus(tokenAmount);
575 
576     // Check that we did not bust the cap
577     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
578       throw;
579     }
580 
581     assignTokens(receiver, tokenAmount);
582 
583     // Pocket the money
584     if(!multisigWallet.send(weiAmount)) throw;
585 
586     // Tell us invest was success
587     Invested(receiver, weiAmount, tokenAmount, customerId);
588   }
589 
590   /**
591    * Allow anonymous contributions to this crowdsale.
592    */
593   function invest(address addr) public payable {
594     investInternal(addr, 0);
595   }
596 
597   /**
598    * The basic entry point to participate the crowdsale process.
599    *
600    * Pay for funding, get invested tokens back in the sender address.
601    */
602   function buy() public payable {
603     invest(msg.sender);
604   }
605 
606   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
607     // Already finalized
608     if(finalized) {
609       throw;
610     }
611 
612     // Finalizing is optional. We only call it if we are given a finalizing agent.
613     if(address(finalizeAgent) != address(0)) {
614       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
615     }
616   }
617 
618   function areReservedTokensDistributed() public constant returns (bool) {
619     return finalizeAgent.reservedTokensAreDistributed();
620   }
621 
622   function canDistributeReservedTokens() public constant returns(bool) {
623     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
624     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
625     return false;
626   }
627 
628   /**
629    * Finalize a succcesful crowdsale.
630    *
631    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
632    */
633   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
634 
635     // Already finalized
636     if(finalized) {
637       throw;
638     }
639 
640     // Finalizing is optional. We only call it if we are given a finalizing agent.
641     if(address(finalizeAgent) != address(0)) {
642       finalizeAgent.finalizeCrowdsale();
643     }
644 
645     finalized = true;
646   }
647 
648   /**
649    * Allow to (re)set finalize agent.
650    *
651    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
652    */
653   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
654     assert(address(addr) != address(0));
655     assert(address(finalizeAgent) == address(0));
656     finalizeAgent = addr;
657 
658     // Don't allow setting bad agent
659     if(!finalizeAgent.isFinalizeAgent()) {
660       throw;
661     }
662   }
663 
664   /**
665    * Allow addresses to do early participation.
666    */
667   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
668     if (!isWhiteListed) throw;
669     assert(addr != address(0));
670     assert(maxCap > 0);
671     assert(minCap <= maxCap);
672     assert(now <= endsAt);
673 
674     if (!isAddressWhitelisted(addr)) {
675       whitelistedParticipants.push(addr);
676       Whitelisted(addr, status, minCap, maxCap);
677     } else {
678       WhitelistItemChanged(addr, status, minCap, maxCap);
679     }
680 
681     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
682   }
683 
684   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
685     if (!isWhiteListed) throw;
686     assert(now <= endsAt);
687     assert(addrs.length == statuses.length);
688     assert(statuses.length == minCaps.length);
689     assert(minCaps.length == maxCaps.length);
690     for (uint iterator = 0; iterator < addrs.length; iterator++) {
691       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
692     }
693   }
694 
695   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
696     if (!isWhiteListed) throw;
697     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
698 
699     uint8 tierPosition = getTierPosition(this);
700 
701     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
702       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
703       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
704     }
705   }
706 
707   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
708     if (!isWhiteListed) throw;
709     assert(addr != address(0));
710     assert(now <= endsAt);
711     assert(isTierJoined(msg.sender));
712     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
713     //if (addr != msg.sender && contractAddr != msg.sender) throw;
714     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
715     newMaxCap = newMaxCap.minus(tokensBought);
716     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
717   }
718 
719   function isAddressWhitelisted(address addr) public constant returns(bool) {
720     for (uint i = 0; i < whitelistedParticipants.length; i++) {
721       if (whitelistedParticipants[i] == addr) {
722         return true;
723         break;
724       }
725     }
726 
727     return false;
728   }
729 
730   function whitelistedParticipantsLength() public constant returns (uint) {
731     return whitelistedParticipants.length;
732   }
733 
734   function isTierJoined(address addr) public constant returns(bool) {
735     return joinedCrowdsaleState[addr].isJoined;
736   }
737 
738   function getTierPosition(address addr) public constant returns(uint8) {
739     return joinedCrowdsaleState[addr].position;
740   }
741 
742   function getLastTier() public constant returns(address) {
743     if (joinedCrowdsalesLen > 0)
744       return joinedCrowdsales[joinedCrowdsalesLen - 1];
745     else
746       return address(0);
747   }
748 
749   function setJoinedCrowdsales(address addr) private onlyOwner {
750     assert(addr != address(0));
751     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
752     assert(!isTierJoined(addr));
753     joinedCrowdsales.push(addr);
754     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
755       isJoined: true,
756       position: joinedCrowdsalesLen
757     });
758     joinedCrowdsalesLen++;
759   }
760 
761   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
762     assert(addrs.length > 0);
763     assert(joinedCrowdsalesLen == 0);
764     assert(addrs.length <= joinedCrowdsalesLenMax);
765     for (uint8 iter = 0; iter < addrs.length; iter++) {
766       setJoinedCrowdsales(addrs[iter]);
767     }
768   }
769 
770   function setStartsAt(uint time) onlyOwner {
771     assert(!finalized);
772     assert(isUpdatable);
773     assert(now <= time); // Don't change past
774     assert(time <= endsAt);
775     assert(now <= startsAt);
776 
777     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
778     if (lastTierCntrct.finalized()) throw;
779 
780     uint8 tierPosition = getTierPosition(this);
781 
782     //start time should be greater then end time of previous tiers
783     for (uint8 j = 0; j < tierPosition; j++) {
784       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
785       assert(time >= crowdsale.endsAt());
786     }
787 
788     startsAt = time;
789     StartsAtChanged(startsAt);
790   }
791 
792   /**
793    * Allow crowdsale owner to close early or extend the crowdsale.
794    *
795    * This is useful e.g. for a manual soft cap implementation:
796    * - after X amount is reached determine manual closing
797    *
798    * This may put the crowdsale to an invalid state,
799    * but we trust owners know what they are doing.
800    *
801    */
802   function setEndsAt(uint time) public onlyOwner {
803     assert(!finalized);
804     assert(isUpdatable);
805     assert(now <= time);// Don't change past
806     assert(startsAt <= time);
807     assert(now <= endsAt);
808 
809     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
810     if (lastTierCntrct.finalized()) throw;
811 
812 
813     uint8 tierPosition = getTierPosition(this);
814 
815     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
816       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
817       assert(time <= crowdsale.startsAt());
818     }
819 
820     endsAt = time;
821     EndsAtChanged(endsAt);
822   }
823 
824   /**
825    * Allow to (re)set pricing strategy.
826    *
827    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
828    */
829   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
830     assert(address(_pricingStrategy) != address(0));
831     assert(address(pricingStrategy) == address(0));
832     pricingStrategy = _pricingStrategy;
833 
834     // Don't allow setting bad agent
835     if(!pricingStrategy.isPricingStrategy()) {
836       throw;
837     }
838   }
839 
840   /**
841    * Allow to change the team multisig address in the case of emergency.
842    *
843    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
844    * (we have done only few test transactions). After the crowdsale is going
845    * then multisig address stays locked for the safety reasons.
846    */
847   function setMultisig(address addr) public onlyOwner {
848 
849     // Change
850     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
851       throw;
852     }
853 
854     multisigWallet = addr;
855   }
856 
857   /**
858    * @return true if the crowdsale has raised enough money to be a successful.
859    */
860   function isMinimumGoalReached() public constant returns (bool reached) {
861     return weiRaised >= minimumFundingGoal;
862   }
863 
864   /**
865    * Check if the contract relationship looks good.
866    */
867   function isFinalizerSane() public constant returns (bool sane) {
868     return finalizeAgent.isSane();
869   }
870 
871   /**
872    * Check if the contract relationship looks good.
873    */
874   function isPricingSane() public constant returns (bool sane) {
875     return pricingStrategy.isSane(address(this));
876   }
877 
878   /**
879    * Crowdfund state machine management.
880    *
881    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
882    */
883   function getState() public constant returns (State) {
884     if(finalized) return State.Finalized;
885     else if (address(finalizeAgent) == 0) return State.Preparing;
886     else if (!finalizeAgent.isSane()) return State.Preparing;
887     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
888     else if (block.timestamp < startsAt) return State.PreFunding;
889     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
890     else if (isMinimumGoalReached()) return State.Success;
891     else return State.Failure;
892   }
893 
894   /** Interface marker. */
895   function isCrowdsale() public constant returns (bool) {
896     return true;
897   }
898 
899   //
900   // Modifiers
901   //
902 
903   /** Modified allowing execution only if the crowdsale is currently running.  */
904   modifier inState(State state) {
905     if(getState() != state) throw;
906     _;
907   }
908 
909 
910   //
911   // Abstract functions
912   //
913 
914   /**
915    * Check if the current invested breaks our cap rules.
916    *
917    *
918    * The child contract must define their own cap setting rules.
919    * We allow a lot of flexibility through different capping strategies (ETH, token count)
920    * Called from invest().
921    *
922    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
923    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
924    * @param weiRaisedTotal What would be our total raised balance after this transaction
925    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
926    *
927    * @return true if taking this investment would break our cap rules
928    */
929   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
930 
931   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
932 
933   /**
934    * Check if the current crowdsale is full and we can no longer sell any tokens.
935    */
936   function isCrowdsaleFull() public constant returns (bool);
937 
938   /**
939    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
940    */
941   function assignTokens(address receiver, uint tokenAmount) private;
942 }
943 
944 /**
945  * This smart contract code is Copyright 2018 BitFinance Ltd.
946  *
947  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
948  */
949 
950 
951 
952 /**
953 * This smart contract code is Copyright 2018 BitFinance Ltd.
954  *
955  * Licensed under the Apache License, version 2.0: https://github.com/BitFinance/ico/blob/master/LICENSE.txt
956  */
957 
958 
959 
960 
961 
962 
963 
964 
965 /**
966  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
967  */
968 contract StandardToken is ERC20, SafeMath {
969 
970   /* Token supply got increased and a new owner received these tokens */
971   event Minted(address receiver, uint amount);
972 
973   /* Actual balances of token holders */
974   mapping(address => uint) balances;
975 
976   /* approve() allowances */
977   mapping (address => mapping (address => uint)) allowed;
978 
979   /* Interface declaration */
980   function isToken() public constant returns (bool weAre) {
981     return true;
982   }
983 
984   function transfer(address _to, uint _value) returns (bool success) {
985     balances[msg.sender] = safeSub(balances[msg.sender], _value);
986     balances[_to] = safeAdd(balances[_to], _value);
987     Transfer(msg.sender, _to, _value);
988     return true;
989   }
990 
991   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
992     uint _allowance = allowed[_from][msg.sender];
993 
994     balances[_to] = safeAdd(balances[_to], _value);
995     balances[_from] = safeSub(balances[_from], _value);
996     allowed[_from][msg.sender] = safeSub(_allowance, _value);
997     Transfer(_from, _to, _value);
998     return true;
999   }
1000 
1001   function balanceOf(address _owner) constant returns (uint balance) {
1002     return balances[_owner];
1003   }
1004 
1005   function approve(address _spender, uint _value) returns (bool success) {
1006 
1007     // To change the approve amount you first have to reduce the addresses`
1008     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1009     //  already 0 to mitigate the race condition described here:
1010     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1011     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1012 
1013     allowed[msg.sender][_spender] = _value;
1014     Approval(msg.sender, _spender, _value);
1015     return true;
1016   }
1017 
1018   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1019     return allowed[_owner][_spender];
1020   }
1021 
1022 }
1023 
1024 
1025 
1026 
1027 
1028 /**
1029  * A token that can increase its supply by another contract.
1030  *
1031  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1032  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1033  *
1034  */
1035 contract MintableTokenExt is StandardToken, Ownable {
1036 
1037   using SafeMathLibExt for uint;
1038 
1039   bool public mintingFinished = false;
1040 
1041   /** List of agents that are allowed to create new tokens */
1042   mapping (address => bool) public mintAgents;
1043 
1044   event MintingAgentChanged(address addr, bool state  );
1045 
1046   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1047   * For example, for reserved tokens in percents 2.54%
1048   * inPercentageUnit = 254
1049   * inPercentageDecimals = 2
1050   */
1051   struct ReservedTokensData {
1052     uint inTokens;
1053     uint inPercentageUnit;
1054     uint inPercentageDecimals;
1055     bool isReserved;
1056     bool isDistributed;
1057   }
1058 
1059   mapping (address => ReservedTokensData) public reservedTokensList;
1060   address[] public reservedTokensDestinations;
1061   uint public reservedTokensDestinationsLen = 0;
1062   bool reservedTokensDestinationsAreSet = false;
1063 
1064   modifier onlyMintAgent() {
1065     // Only crowdsale contracts are allowed to mint new tokens
1066     if(!mintAgents[msg.sender]) {
1067         throw;
1068     }
1069     _;
1070   }
1071 
1072   /** Make sure we are not done yet. */
1073   modifier canMint() {
1074     if(mintingFinished) throw;
1075     _;
1076   }
1077 
1078   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1079     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1080     reservedTokensData.isDistributed = true;
1081   }
1082 
1083   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1084     return reservedTokensList[addr].isReserved;
1085   }
1086 
1087   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1088     return reservedTokensList[addr].isDistributed;
1089   }
1090 
1091   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1092     return reservedTokensList[addr].inTokens;
1093   }
1094 
1095   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1096     return reservedTokensList[addr].inPercentageUnit;
1097   }
1098 
1099   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1100     return reservedTokensList[addr].inPercentageDecimals;
1101   }
1102 
1103   function setReservedTokensListMultiple(
1104     address[] addrs, 
1105     uint[] inTokens, 
1106     uint[] inPercentageUnit, 
1107     uint[] inPercentageDecimals
1108   ) public canMint onlyOwner {
1109     assert(!reservedTokensDestinationsAreSet);
1110     assert(addrs.length == inTokens.length);
1111     assert(inTokens.length == inPercentageUnit.length);
1112     assert(inPercentageUnit.length == inPercentageDecimals.length);
1113     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1114       if (addrs[iterator] != address(0)) {
1115         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1116       }
1117     }
1118     reservedTokensDestinationsAreSet = true;
1119   }
1120 
1121   /**
1122    * Create new tokens and allocate them to an address..
1123    *
1124    * Only callably by a crowdsale contract (mint agent).
1125    */
1126   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1127     totalSupply = totalSupply.plus(amount);
1128     balances[receiver] = balances[receiver].plus(amount);
1129 
1130     // This will make the mint transaction apper in EtherScan.io
1131     // We can remove this after there is a standardized minting event
1132     Transfer(0, receiver, amount);
1133   }
1134 
1135   /**
1136    * Owner can allow a crowdsale contract to mint new tokens.
1137    */
1138   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1139     mintAgents[addr] = state;
1140     MintingAgentChanged(addr, state);
1141   }
1142 
1143   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1144     assert(addr != address(0));
1145     if (!isAddressReserved(addr)) {
1146       reservedTokensDestinations.push(addr);
1147       reservedTokensDestinationsLen++;
1148     }
1149 
1150     reservedTokensList[addr] = ReservedTokensData({
1151       inTokens: inTokens, 
1152       inPercentageUnit: inPercentageUnit, 
1153       inPercentageDecimals: inPercentageDecimals,
1154       isReserved: true,
1155       isDistributed: false
1156     });
1157   }
1158 }
1159 
1160 /**
1161  * ICO crowdsale contract that is capped by amout of tokens.
1162  *
1163  * - Tokens are dynamically created during the crowdsale
1164  *
1165  *
1166  */
1167 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1168 
1169   /* Maximum amount of tokens this crowdsale can sell. */
1170   uint public maximumSellableTokens;
1171 
1172   function MintedTokenCappedCrowdsaleExt(
1173     string _name, 
1174     address _token, 
1175     PricingStrategy _pricingStrategy, 
1176     address _multisigWallet, 
1177     uint _start, uint _end, 
1178     uint _minimumFundingGoal, 
1179     uint _maximumSellableTokens, 
1180     bool _isUpdatable, 
1181     bool _isWhiteListed
1182   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1183     maximumSellableTokens = _maximumSellableTokens;
1184   }
1185 
1186   // Crowdsale maximumSellableTokens has been changed
1187   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1188 
1189   /**
1190    * Called from invest() to confirm if the curret investment does not break our cap rule.
1191    */
1192   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1193     return tokensSoldTotal > maximumSellableTokens;
1194   }
1195 
1196   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1197     assert(isWhiteListed);
1198     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1199     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1200   }
1201 
1202   function isCrowdsaleFull() public constant returns (bool) {
1203     return tokensSold >= maximumSellableTokens;
1204   }
1205 
1206   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1207     assert(!finalized);
1208     assert(isUpdatable);
1209     assert(now <= startsAt);
1210 
1211     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1212     assert(!lastTierCntrct.finalized());
1213 
1214     maximumSellableTokens = tokens;
1215     MaximumSellableTokensChanged(maximumSellableTokens);
1216   }
1217 
1218   function updateRate(uint newOneTokenInWei) public onlyOwner {
1219     assert(!finalized);
1220     assert(isUpdatable);
1221     assert(now <= startsAt);
1222 
1223     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1224     assert(!lastTierCntrct.finalized());
1225 
1226     pricingStrategy.updateRate(newOneTokenInWei);
1227   }
1228 
1229   /**
1230    * Dynamically create tokens and assign them to the investor.
1231    */
1232   function assignTokens(address receiver, uint tokenAmount) private {
1233     MintableTokenExt mintableToken = MintableTokenExt(token);
1234     mintableToken.mint(receiver, tokenAmount);
1235   }
1236 }