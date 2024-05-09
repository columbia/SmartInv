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
16 
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 /**
61  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
62  *
63  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
64  */
65 
66 
67 
68 /**
69  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
70  *
71  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
72  */
73 
74 
75 
76 /**
77  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
78  *
79  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
80  */
81 
82 
83 
84 /**
85  * Safe unsigned safe math.
86  *
87  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
88  *
89  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
90  *
91  * Maintained here until merged to mainline zeppelin-solidity.
92  *
93  */
94 library SafeMathLibExt {
95 
96   function times(uint a, uint b) returns (uint) {
97     uint c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function divides(uint a, uint b) returns (uint) {
103     assert(b > 0);
104     uint c = a / b;
105     assert(a == b * c + a % b);
106     return c;
107   }
108 
109   function minus(uint a, uint b) returns (uint) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function plus(uint a, uint b) returns (uint) {
115     uint c = a + b;
116     assert(c>=a);
117     return c;
118   }
119 
120 }
121 
122 /**
123  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
124  *
125  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
126  */
127 
128 
129 
130 
131 
132 /*
133  * Haltable
134  *
135  * Abstract contract that allows children to implement an
136  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
137  *
138  *
139  * Originally envisioned in FirstBlood ICO contract.
140  */
141 contract Haltable is Ownable {
142   bool public halted;
143 
144   modifier stopInEmergency {
145     if (halted) throw;
146     _;
147   }
148 
149   modifier stopNonOwnersInEmergency {
150     if (halted && msg.sender != owner) throw;
151     _;
152   }
153 
154   modifier onlyInEmergency {
155     if (!halted) throw;
156     _;
157   }
158 
159   // called by the owner on emergency, triggers stopped state
160   function halt() external onlyOwner {
161     halted = true;
162   }
163 
164   // called by the owner on end of emergency, returns to normal state
165   function unhalt() external onlyOwner onlyInEmergency {
166     halted = false;
167   }
168 
169 }
170 
171 /**
172  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
173  *
174  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
175  */
176 
177 
178 
179 /**
180  * Interface for defining crowdsale pricing.
181  */
182 contract PricingStrategy {
183 
184   address public tier;
185 
186   /** Interface declaration. */
187   function isPricingStrategy() public constant returns (bool) {
188     return true;
189   }
190 
191   /** Self check if all references are correctly set.
192    *
193    * Checks that pricing strategy matches crowdsale parameters.
194    */
195   function isSane(address crowdsale) public constant returns (bool) {
196     return true;
197   }
198 
199   /**
200    * @dev Pricing tells if this is a presale purchase or not.
201      @param purchaser Address of the purchaser
202      @return False by default, true if a presale purchaser
203    */
204   function isPresalePurchase(address purchaser) public constant returns (bool) {
205     return false;
206   }
207 
208   /* How many weis one token costs */
209   function updateRate(uint newOneTokenInWei) public;
210 
211   /**
212    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
213    *
214    *
215    * @param value - What is the value of the transaction send in as wei
216    * @param tokensSold - how much tokens have been sold this far
217    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
218    * @param msgSender - who is the investor of this transaction
219    * @param decimals - how many decimal units the token has
220    * @return Amount of tokens the investor receives
221    */
222   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
223 }
224 
225 /**
226  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
227  *
228  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
229  */
230 
231 
232 
233 /**
234  * Finalize agent defines what happens at the end of succeseful crowdsale.
235  *
236  * - Allocate tokens for founders, bounties and community
237  * - Make tokens transferable
238  * - etc.
239  */
240 contract FinalizeAgent {
241 
242   bool public reservedTokensAreDistributed = false;
243 
244   function isFinalizeAgent() public constant returns(bool) {
245     return true;
246   }
247 
248   /** Return true if we can run finalizeCrowdsale() properly.
249    *
250    * This is a safety check function that doesn't allow crowdsale to begin
251    * unless the finalizer has been set up properly.
252    */
253   function isSane() public constant returns (bool);
254 
255   function distributeReservedTokens(uint reservedTokensDistributionBatch);
256 
257   /** Called once by crowdsale finalize() if the sale was success. */
258   function finalizeCrowdsale();
259 
260 }
261 /**
262  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
263  *
264  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
265  */
266 
267 
268 
269 
270 
271 
272 
273 
274 
275 /**
276  * @title ERC20 interface
277  * @dev see https://github.com/ethereum/EIPs/issues/20
278  */
279 contract ERC20 is ERC20Basic {
280   function allowance(address owner, address spender) public constant returns (uint256);
281   function transferFrom(address from, address to, uint256 value) public returns (bool);
282   function approve(address spender, uint256 value) public returns (bool);
283   event Approval(address indexed owner, address indexed spender, uint256 value);
284 }
285 
286 
287 /**
288  * A token that defines fractional units as decimals.
289  */
290 contract FractionalERC20Ext is ERC20 {
291 
292   uint public decimals;
293   uint public minCap;
294 
295 }
296 
297 
298 
299 /**
300  * Abstract base contract for token sales.
301  *
302  * Handle
303  * - start and end dates
304  * - accepting investments
305  * - minimum funding goal and refund
306  * - various statistics during the crowdfund
307  * - different pricing strategies
308  * - different investment policies (require server side customer id, allow only whitelisted addresses)
309  *
310  */
311 contract CrowdsaleExt is Haltable {
312 
313   /* Max investment count when we are still allowed to change the multisig address */
314   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
315 
316   using SafeMathLibExt for uint;
317 
318   /* The token we are selling */
319   FractionalERC20Ext public token;
320 
321   /* How we are going to price our offering */
322   PricingStrategy public pricingStrategy;
323 
324   /* Post-success callback */
325   FinalizeAgent public finalizeAgent;
326 
327   /* name of the crowdsale tier */
328   string public name;
329 
330   /* tokens will be transfered from this address */
331   address public multisigWallet;
332 
333   /* if the funding goal is not reached, investors may withdraw their funds */
334   uint public minimumFundingGoal;
335 
336   /* the UNIX timestamp start date of the crowdsale */
337   uint public startsAt;
338 
339   /* the UNIX timestamp end date of the crowdsale */
340   uint public endsAt;
341 
342   /* the number of tokens already sold through this contract*/
343   uint public tokensSold = 0;
344 
345   /* How many wei of funding we have raised */
346   uint public weiRaised = 0;
347 
348   /* How many distinct addresses have invested */
349   uint public investorCount = 0;
350 
351   /* Has this crowdsale been finalized */
352   bool public finalized;
353 
354   bool public isWhiteListed;
355 
356   address[] public joinedCrowdsales;
357   uint8 public joinedCrowdsalesLen = 0;
358   uint8 public joinedCrowdsalesLenMax = 50;
359   struct JoinedCrowdsaleStatus {
360     bool isJoined;
361     uint8 position;
362   }
363   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
364 
365   /** How much ETH each address has invested to this crowdsale */
366   mapping (address => uint256) public investedAmountOf;
367 
368   /** How much tokens this crowdsale has credited for each investor address */
369   mapping (address => uint256) public tokenAmountOf;
370 
371   struct WhiteListData {
372     bool status;
373     uint minCap;
374     uint maxCap;
375   }
376 
377   //is crowdsale updatable
378   bool public isUpdatable;
379 
380   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
381   mapping (address => WhiteListData) public earlyParticipantWhitelist;
382 
383   /** List of whitelisted addresses */
384   address[] public whitelistedParticipants;
385 
386   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
387   uint public ownerTestValue;
388 
389   /** State machine
390    *
391    * - Preparing: All contract initialization calls and variables have not been set yet
392    * - Prefunding: We have not passed start time yet
393    * - Funding: Active crowdsale
394    * - Success: Minimum funding goal reached
395    * - Failure: Minimum funding goal not reached before ending time
396    * - Finalized: The finalized has been called and succesfully executed
397    */
398   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
399 
400   // A new investment was made
401   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
402 
403   // Address early participation whitelist status changed
404   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
405   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
406 
407   // Crowdsale start time has been changed
408   event StartsAtChanged(uint newStartsAt);
409 
410   // Crowdsale end time has been changed
411   event EndsAtChanged(uint newEndsAt);
412 
413   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
414 
415     owner = msg.sender;
416 
417     name = _name;
418 
419     token = FractionalERC20Ext(_token);
420 
421     setPricingStrategy(_pricingStrategy);
422 
423     multisigWallet = _multisigWallet;
424     if(multisigWallet == 0) {
425         throw;
426     }
427 
428     if(_start == 0) {
429         throw;
430     }
431 
432     startsAt = _start;
433 
434     if(_end == 0) {
435         throw;
436     }
437 
438     endsAt = _end;
439 
440     // Don't mess the dates
441     if(startsAt >= endsAt) {
442         throw;
443     }
444 
445     // Minimum funding goal can be zero
446     minimumFundingGoal = _minimumFundingGoal;
447 
448     isUpdatable = _isUpdatable;
449 
450     isWhiteListed = _isWhiteListed;
451   }
452 
453   /**
454    * Don't expect to just send in money and get tokens.
455    */
456   function() payable {
457     throw;
458   }
459 
460   /**
461    * Make an investment.
462    *
463    * Crowdsale must be running for one to invest.
464    * We must have not pressed the emergency brake.
465    *
466    * @param receiver The Ethereum address who receives the tokens
467    * @param customerId (optional) UUID v4 to track the successful payments on the server side
468    *
469    */
470   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
471 
472     // Determine if it's a good time to accept investment from this participant
473     if(getState() == State.PreFunding) {
474       // Are we whitelisted for early deposit
475       throw;
476     } else if(getState() == State.Funding) {
477       // Retail participants can only come in when the crowdsale is running
478       // pass
479       if(isWhiteListed) {
480         if(!earlyParticipantWhitelist[receiver].status) {
481           throw;
482         }
483       }
484     } else {
485       // Unwanted state
486       throw;
487     }
488 
489     uint weiAmount = msg.value;
490 
491     // Account presale sales separately, so that they do not count against pricing tranches
492     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
493 
494     if(tokenAmount == 0) {
495       // Dust transaction
496       throw;
497     }
498 
499     if(isWhiteListed) {
500       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
501         // tokenAmount < minCap for investor
502         throw;
503       }
504 
505       // Check that we did not bust the investor's cap
506       if (isBreakingInvestorCap(receiver, tokenAmount)) {
507         throw;
508       }
509 
510       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
511     } else {
512       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
513         throw;
514       }
515     }
516 
517     if(investedAmountOf[receiver] == 0) {
518        // A new investor
519        investorCount++;
520     }
521 
522     // Update investor
523     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
524     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
525 
526     // Update totals
527     weiRaised = weiRaised.plus(weiAmount);
528     tokensSold = tokensSold.plus(tokenAmount);
529 
530     // Check that we did not bust the cap
531     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
532       throw;
533     }
534 
535     assignTokens(receiver, tokenAmount);
536 
537     // Pocket the money
538     if(!multisigWallet.send(weiAmount)) throw;
539 
540     // Tell us invest was success
541     Invested(receiver, weiAmount, tokenAmount, customerId);
542   }
543 
544   /**
545    * Allow anonymous contributions to this crowdsale.
546    */
547   function invest(address addr) public payable {
548     investInternal(addr, 0);
549   }
550 
551   /**
552    * The basic entry point to participate the crowdsale process.
553    *
554    * Pay for funding, get invested tokens back in the sender address.
555    */
556   function buy() public payable {
557     invest(msg.sender);
558   }
559 
560   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
561     // Already finalized
562     if(finalized) {
563       throw;
564     }
565 
566     // Finalizing is optional. We only call it if we are given a finalizing agent.
567     if(address(finalizeAgent) != address(0)) {
568       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
569     }
570   }
571 
572   function areReservedTokensDistributed() public constant returns (bool) {
573     return finalizeAgent.reservedTokensAreDistributed();
574   }
575 
576   function canDistributeReservedTokens() public constant returns(bool) {
577     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
578     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
579     return false;
580   }
581 
582   /**
583    * Finalize a succcesful crowdsale.
584    *
585    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
586    */
587   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
588 
589     // Already finalized
590     if(finalized) {
591       throw;
592     }
593 
594     // Finalizing is optional. We only call it if we are given a finalizing agent.
595     if(address(finalizeAgent) != address(0)) {
596       finalizeAgent.finalizeCrowdsale();
597     }
598 
599     finalized = true;
600   }
601 
602   /**
603    * Allow to (re)set finalize agent.
604    *
605    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
606    */
607   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
608     assert(address(addr) != address(0));
609     assert(address(finalizeAgent) == address(0));
610     finalizeAgent = addr;
611 
612     // Don't allow setting bad agent
613     if(!finalizeAgent.isFinalizeAgent()) {
614       throw;
615     }
616   }
617 
618   /**
619    * Allow addresses to do early participation.
620    */
621   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
622     if (!isWhiteListed) throw;
623     assert(addr != address(0));
624     assert(maxCap > 0);
625     assert(minCap <= maxCap);
626     assert(now <= endsAt);
627 
628     if (!isAddressWhitelisted(addr)) {
629       whitelistedParticipants.push(addr);
630       Whitelisted(addr, status, minCap, maxCap);
631     } else {
632       WhitelistItemChanged(addr, status, minCap, maxCap);
633     }
634 
635     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
636   }
637 
638   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
639     if (!isWhiteListed) throw;
640     assert(now <= endsAt);
641     assert(addrs.length == statuses.length);
642     assert(statuses.length == minCaps.length);
643     assert(minCaps.length == maxCaps.length);
644     for (uint iterator = 0; iterator < addrs.length; iterator++) {
645       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
646     }
647   }
648 
649   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
650     if (!isWhiteListed) throw;
651     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
652 
653     uint8 tierPosition = getTierPosition(this);
654 
655     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
656       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
657       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
658     }
659   }
660 
661   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
662     if (!isWhiteListed) throw;
663     assert(addr != address(0));
664     assert(now <= endsAt);
665     assert(isTierJoined(msg.sender));
666     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
667     //if (addr != msg.sender && contractAddr != msg.sender) throw;
668     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
669     newMaxCap = newMaxCap.minus(tokensBought);
670     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
671   }
672 
673   function isAddressWhitelisted(address addr) public constant returns(bool) {
674     for (uint i = 0; i < whitelistedParticipants.length; i++) {
675       if (whitelistedParticipants[i] == addr) {
676         return true;
677         break;
678       }
679     }
680 
681     return false;
682   }
683 
684   function whitelistedParticipantsLength() public constant returns (uint) {
685     return whitelistedParticipants.length;
686   }
687 
688   function isTierJoined(address addr) public constant returns(bool) {
689     return joinedCrowdsaleState[addr].isJoined;
690   }
691 
692   function getTierPosition(address addr) public constant returns(uint8) {
693     return joinedCrowdsaleState[addr].position;
694   }
695 
696   function getLastTier() public constant returns(address) {
697     if (joinedCrowdsalesLen > 0)
698       return joinedCrowdsales[joinedCrowdsalesLen - 1];
699     else
700       return address(0);
701   }
702 
703   function setJoinedCrowdsales(address addr) private onlyOwner {
704     assert(addr != address(0));
705     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
706     assert(!isTierJoined(addr));
707     joinedCrowdsales.push(addr);
708     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
709       isJoined: true,
710       position: joinedCrowdsalesLen
711     });
712     joinedCrowdsalesLen++;
713   }
714 
715   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
716     assert(addrs.length > 0);
717     assert(joinedCrowdsalesLen == 0);
718     assert(addrs.length <= joinedCrowdsalesLenMax);
719     for (uint8 iter = 0; iter < addrs.length; iter++) {
720       setJoinedCrowdsales(addrs[iter]);
721     }
722   }
723 
724   function setStartsAt(uint time) onlyOwner {
725     assert(!finalized);
726     assert(isUpdatable);
727     assert(now <= time); // Don't change past
728     assert(time <= endsAt);
729     assert(now <= startsAt);
730 
731     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
732     if (lastTierCntrct.finalized()) throw;
733 
734     uint8 tierPosition = getTierPosition(this);
735 
736     //start time should be greater then end time of previous tiers
737     for (uint8 j = 0; j < tierPosition; j++) {
738       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
739       assert(time >= crowdsale.endsAt());
740     }
741 
742     startsAt = time;
743     StartsAtChanged(startsAt);
744   }
745 
746   /**
747    * Allow crowdsale owner to close early or extend the crowdsale.
748    *
749    * This is useful e.g. for a manual soft cap implementation:
750    * - after X amount is reached determine manual closing
751    *
752    * This may put the crowdsale to an invalid state,
753    * but we trust owners know what they are doing.
754    *
755    */
756   function setEndsAt(uint time) public onlyOwner {
757     assert(!finalized);
758     assert(isUpdatable);
759     assert(now <= time);// Don't change past
760     assert(startsAt <= time);
761     assert(now <= endsAt);
762 
763     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
764     if (lastTierCntrct.finalized()) throw;
765 
766 
767     uint8 tierPosition = getTierPosition(this);
768 
769     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
770       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
771       assert(time <= crowdsale.startsAt());
772     }
773 
774     endsAt = time;
775     EndsAtChanged(endsAt);
776   }
777 
778   /**
779    * Allow to (re)set pricing strategy.
780    *
781    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
782    */
783   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
784     assert(address(_pricingStrategy) != address(0));
785     assert(address(pricingStrategy) == address(0));
786     pricingStrategy = _pricingStrategy;
787 
788     // Don't allow setting bad agent
789     if(!pricingStrategy.isPricingStrategy()) {
790       throw;
791     }
792   }
793 
794   /**
795    * Allow to change the team multisig address in the case of emergency.
796    *
797    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
798    * (we have done only few test transactions). After the crowdsale is going
799    * then multisig address stays locked for the safety reasons.
800    */
801   function setMultisig(address addr) public onlyOwner {
802 
803     // Change
804     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
805       throw;
806     }
807 
808     multisigWallet = addr;
809   }
810 
811   /**
812    * @return true if the crowdsale has raised enough money to be a successful.
813    */
814   function isMinimumGoalReached() public constant returns (bool reached) {
815     return weiRaised >= minimumFundingGoal;
816   }
817 
818   /**
819    * Check if the contract relationship looks good.
820    */
821   function isFinalizerSane() public constant returns (bool sane) {
822     return finalizeAgent.isSane();
823   }
824 
825   /**
826    * Check if the contract relationship looks good.
827    */
828   function isPricingSane() public constant returns (bool sane) {
829     return pricingStrategy.isSane(address(this));
830   }
831 
832   /**
833    * Crowdfund state machine management.
834    *
835    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
836    */
837   function getState() public constant returns (State) {
838     if(finalized) return State.Finalized;
839     else if (address(finalizeAgent) == 0) return State.Preparing;
840     else if (!finalizeAgent.isSane()) return State.Preparing;
841     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
842     else if (block.timestamp < startsAt) return State.PreFunding;
843     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
844     else if (isMinimumGoalReached()) return State.Success;
845     else return State.Failure;
846   }
847 
848   /** Interface marker. */
849   function isCrowdsale() public constant returns (bool) {
850     return true;
851   }
852 
853   //
854   // Modifiers
855   //
856 
857   /** Modified allowing execution only if the crowdsale is currently running.  */
858   modifier inState(State state) {
859     if(getState() != state) throw;
860     _;
861   }
862 
863 
864   //
865   // Abstract functions
866   //
867 
868   /**
869    * Check if the current invested breaks our cap rules.
870    *
871    *
872    * The child contract must define their own cap setting rules.
873    * We allow a lot of flexibility through different capping strategies (ETH, token count)
874    * Called from invest().
875    *
876    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
877    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
878    * @param weiRaisedTotal What would be our total raised balance after this transaction
879    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
880    *
881    * @return true if taking this investment would break our cap rules
882    */
883   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
884 
885   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
886 
887   /**
888    * Check if the current crowdsale is full and we can no longer sell any tokens.
889    */
890   function isCrowdsaleFull() public constant returns (bool);
891 
892   /**
893    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
894    */
895   function assignTokens(address receiver, uint tokenAmount) private;
896 }
897 
898 /**
899  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
900  *
901  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
902  */
903 
904 
905 
906 
907 
908 
909 
910 /**
911  * Define interface for releasing the token transfer after a successful crowdsale.
912  */
913 contract ReleasableToken is ERC20, Ownable {
914 
915   /* The finalizer contract that allows unlift the transfer limits on this token */
916   address public releaseAgent;
917 
918   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
919   bool public released = false;
920 
921   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
922   mapping (address => bool) public transferAgents;
923 
924   /**
925    * Limit token transfer until the crowdsale is over.
926    *
927    */
928   modifier canTransfer(address _sender) {
929 
930     if(!released) {
931         if(!transferAgents[_sender]) {
932             throw;
933         }
934     }
935 
936     _;
937   }
938 
939   /**
940    * Set the contract that can call release and make the token transferable.
941    *
942    * Design choice. Allow reset the release agent to fix fat finger mistakes.
943    */
944   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
945 
946     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
947     releaseAgent = addr;
948   }
949 
950   /**
951    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
952    */
953   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
954     transferAgents[addr] = state;
955   }
956 
957   /**
958    * One way function to release the tokens to the wild.
959    *
960    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
961    */
962   function releaseTokenTransfer() public onlyReleaseAgent {
963     released = true;
964   }
965 
966   /** The function can be called only before or after the tokens have been releasesd */
967   modifier inReleaseState(bool releaseState) {
968     if(releaseState != released) {
969         throw;
970     }
971     _;
972   }
973 
974   /** The function can be called only by a whitelisted release agent. */
975   modifier onlyReleaseAgent() {
976     if(msg.sender != releaseAgent) {
977         throw;
978     }
979     _;
980   }
981 
982   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
983     // Call StandardToken.transfer()
984    return super.transfer(_to, _value);
985   }
986 
987   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
988     // Call StandardToken.transferForm()
989     return super.transferFrom(_from, _to, _value);
990   }
991 
992 }
993 
994 
995 /**
996  * A finalize agent that does nothing.
997  *
998  * - Token transfer must be manually released by the owner
999  */
1000 contract NullFinalizeAgentExt is FinalizeAgent {
1001 
1002   CrowdsaleExt public crowdsale;
1003 
1004   function NullFinalizeAgentExt(CrowdsaleExt _crowdsale) {
1005     crowdsale = _crowdsale;
1006   }
1007 
1008   /** Check that we can release the token */
1009   function isSane() public constant returns (bool) {
1010     return true;
1011   }
1012 
1013   function distributeReservedTokens(uint reservedTokensDistributionBatch) public {
1014   }
1015 
1016   /** Called once by crowdsale finalize() if the sale was success. */
1017   function finalizeCrowdsale() public {
1018   }
1019 
1020 }