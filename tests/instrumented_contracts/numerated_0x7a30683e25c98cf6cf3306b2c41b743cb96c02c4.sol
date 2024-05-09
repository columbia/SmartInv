1 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
2 
3 pragma solidity ^0.4.8;
4 
5 
6 /**
7  * Math operations with safety checks
8  */
9 contract SafeMath {
10   function safeMul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint a, uint b) internal returns (uint) {
17     assert(b > 0);
18     uint c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23   function safeSub(uint a, uint b) internal returns (uint) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function safeAdd(uint a, uint b) internal returns (uint) {
29     uint c = a + b;
30     assert(c>=a && c>=b);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50 }
51 
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) public constant returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address public owner;
75 
76 
77   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   function Ownable() {
85     owner = msg.sender;
86   }
87 
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) onlyOwner public {
103     require(newOwner != address(0));
104     OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108 }
109 /**
110  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
111  */
112 
113 
114 
115 /**
116  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
117  */
118 
119 
120 
121 /**
122  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
123  */
124 
125 
126 
127 /**
128  * Safe unsigned safe math.
129  *
130  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
131  *
132  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
133  *
134  * Maintained here until merged to mainline zeppelin-solidity.
135  *
136  */
137 library SafeMathLibExt {
138 
139   function times(uint a, uint b) returns (uint) {
140     uint c = a * b;
141     assert(a == 0 || c / a == b);
142     return c;
143   }
144 
145   function divides(uint a, uint b) returns (uint) {
146     assert(b > 0);
147     uint c = a / b;
148     assert(a == b * c + a % b);
149     return c;
150   }
151 
152   function minus(uint a, uint b) returns (uint) {
153     assert(b <= a);
154     return a - b;
155   }
156 
157   function plus(uint a, uint b) returns (uint) {
158     uint c = a + b;
159     assert(c>=a);
160     return c;
161   }
162 
163 }
164 
165 /**
166  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
167  */
168 
169 
170 
171 
172 
173 /*
174  * Haltable
175  *
176  * Abstract contract that allows children to implement an
177  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
178  *
179  *
180  * Originally envisioned in FirstBlood ICO contract.
181  */
182 contract Haltable is Ownable {
183   bool public halted;
184 
185   modifier stopInEmergency {
186     if (halted) throw;
187     _;
188   }
189 
190   modifier stopNonOwnersInEmergency {
191     if (halted && msg.sender != owner) throw;
192     _;
193   }
194 
195   modifier onlyInEmergency {
196     if (!halted) throw;
197     _;
198   }
199 
200   // called by the owner on emergency, triggers stopped state
201   function halt() external onlyOwner {
202     halted = true;
203   }
204 
205   // called by the owner on end of emergency, returns to normal state
206   function unhalt() external onlyOwner onlyInEmergency {
207     halted = false;
208   }
209 
210 }
211 
212 /**
213  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
214  */
215 
216 
217 
218 /**
219  * Interface for defining crowdsale pricing.
220  */
221 contract PricingStrategy {
222 
223   address public tier;
224 
225   /** Interface declaration. */
226   function isPricingStrategy() public constant returns (bool) {
227     return true;
228   }
229 
230   /** Self check if all references are correctly set.
231    *
232    * Checks that pricing strategy matches crowdsale parameters.
233    */
234   function isSane(address crowdsale) public constant returns (bool) {
235     return true;
236   }
237 
238   /**
239    * @dev Pricing tells if this is a presale purchase or not.
240      @param purchaser Address of the purchaser
241      @return False by default, true if a presale purchaser
242    */
243   function isPresalePurchase(address purchaser) public constant returns (bool) {
244     return false;
245   }
246 
247   /* How many weis one token costs */
248   function updateRate(uint newOneTokenInWei) public;
249 
250   /**
251    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
252    *
253    *
254    * @param value - What is the value of the transaction send in as wei
255    * @param tokensSold - how much tokens have been sold this far
256    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
257    * @param msgSender - who is the investor of this transaction
258    * @param decimals - how many decimal units the token has
259    * @return Amount of tokens the investor receives
260    */
261   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
262 }
263 
264 /**
265  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
266  */
267 
268 
269 
270 /**
271  * Finalize agent defines what happens at the end of succeseful crowdsale.
272  *
273  * - Allocate tokens for founders, bounties and community
274  * - Make tokens transferable
275  * - etc.
276  */
277 contract FinalizeAgent {
278 
279   bool public reservedTokensAreDistributed = false;
280 
281   function isFinalizeAgent() public constant returns(bool) {
282     return true;
283   }
284 
285   /** Return true if we can run finalizeCrowdsale() properly.
286    *
287    * This is a safety check function that doesn't allow crowdsale to begin
288    * unless the finalizer has been set up properly.
289    */
290   function isSane() public constant returns (bool);
291 
292   function distributeReservedTokens(uint reservedTokensDistributionBatch);
293 
294   /** Called once by crowdsale finalize() if the sale was success. */
295   function finalizeCrowdsale();
296 
297 }
298 /**
299  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
300  */
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 /**
311  * @title ERC20 interface
312  * @dev see https://github.com/ethereum/EIPs/issues/20
313  */
314 contract ERC20 is ERC20Basic {
315   function allowance(address owner, address spender) public constant returns (uint256);
316   function transferFrom(address from, address to, uint256 value) public returns (bool);
317   function approve(address spender, uint256 value) public returns (bool);
318   event Approval(address indexed owner, address indexed spender, uint256 value);
319 }
320 
321 
322 /**
323  * A token that defines fractional units as decimals.
324  */
325 contract FractionalERC20Ext is ERC20 {
326 
327   uint public decimals;
328   uint public minCap;
329 
330 }
331 
332 
333 
334 /**
335  * Abstract base contract for token sales.
336  *
337  * Handle
338  * - start and end dates
339  * - accepting investments
340  * - minimum funding goal and refund
341  * - various statistics during the crowdfund
342  * - different pricing strategies
343  * - different investment policies (require server side customer id, allow only whitelisted addresses)
344  *
345  */
346 contract CrowdsaleExt is Haltable {
347 
348   /* Max investment count when we are still allowed to change the multisig address */
349   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
350 
351   using SafeMathLibExt for uint;
352 
353   /* The token we are selling */
354   FractionalERC20Ext public token;
355 
356   /* How we are going to price our offering */
357   PricingStrategy public pricingStrategy;
358 
359   /* Post-success callback */
360   FinalizeAgent public finalizeAgent;
361 
362   /* name of the crowdsale tier */
363   string public name;
364 
365   /* tokens will be transfered from this address */
366   address public multisigWallet;
367 
368   /* if the funding goal is not reached, investors may withdraw their funds */
369   uint public minimumFundingGoal;
370 
371   /* the UNIX timestamp start date of the crowdsale */
372   uint public startsAt;
373 
374   /* the UNIX timestamp end date of the crowdsale */
375   uint public endsAt;
376 
377   /* the number of tokens already sold through this contract*/
378   uint public tokensSold = 0;
379 
380   /* How many wei of funding we have raised */
381   uint public weiRaised = 0;
382 
383   /* How many distinct addresses have invested */
384   uint public investorCount = 0;
385 
386   /* Has this crowdsale been finalized */
387   bool public finalized;
388 
389   bool public isWhiteListed;
390 
391   address[] public joinedCrowdsales;
392   uint8 public joinedCrowdsalesLen = 0;
393   uint8 public joinedCrowdsalesLenMax = 50;
394   struct JoinedCrowdsaleStatus {
395     bool isJoined;
396     uint8 position;
397   }
398   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
399 
400   /** How much ETH each address has invested to this crowdsale */
401   mapping (address => uint256) public investedAmountOf;
402 
403   /** How much tokens this crowdsale has credited for each investor address */
404   mapping (address => uint256) public tokenAmountOf;
405 
406   struct WhiteListData {
407     bool status;
408     uint minCap;
409     uint maxCap;
410   }
411 
412   //is crowdsale updatable
413   bool public isUpdatable;
414 
415   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
416   mapping (address => WhiteListData) public earlyParticipantWhitelist;
417 
418   /** List of whitelisted addresses */
419   address[] public whitelistedParticipants;
420 
421   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
422   uint public ownerTestValue;
423 
424   /** State machine
425    *
426    * - Preparing: All contract initialization calls and variables have not been set yet
427    * - Prefunding: We have not passed start time yet
428    * - Funding: Active crowdsale
429    * - Success: Minimum funding goal reached
430    * - Failure: Minimum funding goal not reached before ending time
431    * - Finalized: The finalized has been called and succesfully executed
432    */
433   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
434 
435   // A new investment was made
436   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
437 
438   // Address early participation whitelist status changed
439   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
440   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
441 
442   // Crowdsale start time has been changed
443   event StartsAtChanged(uint newStartsAt);
444 
445   // Crowdsale end time has been changed
446   event EndsAtChanged(uint newEndsAt);
447 
448   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
449 
450     owner = msg.sender;
451 
452     name = _name;
453 
454     token = FractionalERC20Ext(_token);
455 
456     setPricingStrategy(_pricingStrategy);
457 
458     multisigWallet = _multisigWallet;
459     if(multisigWallet == 0) {
460         throw;
461     }
462 
463     if(_start == 0) {
464         throw;
465     }
466 
467     startsAt = _start;
468 
469     if(_end == 0) {
470         throw;
471     }
472 
473     endsAt = _end;
474 
475     // Don't mess the dates
476     if(startsAt >= endsAt) {
477         throw;
478     }
479 
480     // Minimum funding goal can be zero
481     minimumFundingGoal = _minimumFundingGoal;
482 
483     isUpdatable = _isUpdatable;
484 
485     isWhiteListed = _isWhiteListed;
486   }
487 
488   /**
489    * Don't expect to just send in money and get tokens.
490    */
491   function() payable {
492     throw;
493   }
494 
495   /**
496    * Make an investment.
497    *
498    * Crowdsale must be running for one to invest.
499    * We must have not pressed the emergency brake.
500    *
501    * @param receiver The Ethereum address who receives the tokens
502    * @param customerId (optional) UUID v4 to track the successful payments on the server side
503    *
504    */
505   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
506 
507     // Determine if it's a good time to accept investment from this participant
508     if(getState() == State.PreFunding) {
509       // Are we whitelisted for early deposit
510       throw;
511     } else if(getState() == State.Funding) {
512       // Retail participants can only come in when the crowdsale is running
513       // pass
514       if(isWhiteListed) {
515         if(!earlyParticipantWhitelist[receiver].status) {
516           throw;
517         }
518       }
519     } else {
520       // Unwanted state
521       throw;
522     }
523 
524     uint weiAmount = msg.value;
525 
526     // Account presale sales separately, so that they do not count against pricing tranches
527     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
528 
529     if(tokenAmount == 0) {
530       // Dust transaction
531       throw;
532     }
533 
534     if(isWhiteListed) {
535       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
536         // tokenAmount < minCap for investor
537         throw;
538       }
539 
540       // Check that we did not bust the investor's cap
541       if (isBreakingInvestorCap(receiver, tokenAmount)) {
542         throw;
543       }
544 
545       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
546     } else {
547       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
548         throw;
549       }
550     }
551 
552     if(investedAmountOf[receiver] == 0) {
553        // A new investor
554        investorCount++;
555     }
556 
557     // Update investor
558     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
559     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
560 
561     // Update totals
562     weiRaised = weiRaised.plus(weiAmount);
563     tokensSold = tokensSold.plus(tokenAmount);
564 
565     // Check that we did not bust the cap
566     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
567       throw;
568     }
569 
570     assignTokens(receiver, tokenAmount);
571 
572     // Pocket the money
573     if(!multisigWallet.send(weiAmount)) throw;
574 
575     // Tell us invest was success
576     Invested(receiver, weiAmount, tokenAmount, customerId);
577   }
578 
579   /**
580    * Allow anonymous contributions to this crowdsale.
581    */
582   function invest(address addr) public payable {
583     investInternal(addr, 0);
584   }
585 
586   /**
587    * The basic entry point to participate the crowdsale process.
588    *
589    * Pay for funding, get invested tokens back in the sender address.
590    */
591   function buy() public payable {
592     invest(msg.sender);
593   }
594 
595   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
596     // Already finalized
597     if(finalized) {
598       throw;
599     }
600 
601     // Finalizing is optional. We only call it if we are given a finalizing agent.
602     if(address(finalizeAgent) != address(0)) {
603       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
604     }
605   }
606 
607   function areReservedTokensDistributed() public constant returns (bool) {
608     return finalizeAgent.reservedTokensAreDistributed();
609   }
610 
611   function canDistributeReservedTokens() public constant returns(bool) {
612     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
613     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
614     return false;
615   }
616 
617   /**
618    * Finalize a succcesful crowdsale.
619    *
620    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
621    */
622   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
623 
624     // Already finalized
625     if(finalized) {
626       throw;
627     }
628 
629     // Finalizing is optional. We only call it if we are given a finalizing agent.
630     if(address(finalizeAgent) != address(0)) {
631       finalizeAgent.finalizeCrowdsale();
632     }
633 
634     finalized = true;
635   }
636 
637   /**
638    * Allow to (re)set finalize agent.
639    *
640    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
641    */
642   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
643     assert(address(addr) != address(0));
644     assert(address(finalizeAgent) == address(0));
645     finalizeAgent = addr;
646 
647     // Don't allow setting bad agent
648     if(!finalizeAgent.isFinalizeAgent()) {
649       throw;
650     }
651   }
652 
653   /**
654    * Allow addresses to do early participation.
655    */
656   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
657     if (!isWhiteListed) throw;
658     assert(addr != address(0));
659     assert(maxCap > 0);
660     assert(minCap <= maxCap);
661     assert(now <= endsAt);
662 
663     if (!isAddressWhitelisted(addr)) {
664       whitelistedParticipants.push(addr);
665       Whitelisted(addr, status, minCap, maxCap);
666     } else {
667       WhitelistItemChanged(addr, status, minCap, maxCap);
668     }
669 
670     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
671   }
672 
673   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
674     if (!isWhiteListed) throw;
675     assert(now <= endsAt);
676     assert(addrs.length == statuses.length);
677     assert(statuses.length == minCaps.length);
678     assert(minCaps.length == maxCaps.length);
679     for (uint iterator = 0; iterator < addrs.length; iterator++) {
680       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
681     }
682   }
683 
684   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
685     if (!isWhiteListed) throw;
686     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
687 
688     uint8 tierPosition = getTierPosition(this);
689 
690     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
691       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
692       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
693     }
694   }
695 
696   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
697     if (!isWhiteListed) throw;
698     assert(addr != address(0));
699     assert(now <= endsAt);
700     assert(isTierJoined(msg.sender));
701     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
702     //if (addr != msg.sender && contractAddr != msg.sender) throw;
703     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
704     newMaxCap = newMaxCap.minus(tokensBought);
705     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
706   }
707 
708   function isAddressWhitelisted(address addr) public constant returns(bool) {
709     for (uint i = 0; i < whitelistedParticipants.length; i++) {
710       if (whitelistedParticipants[i] == addr) {
711         return true;
712         break;
713       }
714     }
715 
716     return false;
717   }
718 
719   function whitelistedParticipantsLength() public constant returns (uint) {
720     return whitelistedParticipants.length;
721   }
722 
723   function isTierJoined(address addr) public constant returns(bool) {
724     return joinedCrowdsaleState[addr].isJoined;
725   }
726 
727   function getTierPosition(address addr) public constant returns(uint8) {
728     return joinedCrowdsaleState[addr].position;
729   }
730 
731   function getLastTier() public constant returns(address) {
732     if (joinedCrowdsalesLen > 0)
733       return joinedCrowdsales[joinedCrowdsalesLen - 1];
734     else
735       return address(0);
736   }
737 
738   function setJoinedCrowdsales(address addr) private onlyOwner {
739     assert(addr != address(0));
740     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
741     assert(!isTierJoined(addr));
742     joinedCrowdsales.push(addr);
743     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
744       isJoined: true,
745       position: joinedCrowdsalesLen
746     });
747     joinedCrowdsalesLen++;
748   }
749 
750   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
751     assert(addrs.length > 0);
752     assert(joinedCrowdsalesLen == 0);
753     assert(addrs.length <= joinedCrowdsalesLenMax);
754     for (uint8 iter = 0; iter < addrs.length; iter++) {
755       setJoinedCrowdsales(addrs[iter]);
756     }
757   }
758 
759   function setStartsAt(uint time) onlyOwner {
760     assert(!finalized);
761     assert(isUpdatable);
762     assert(now <= time); // Don't change past
763     assert(time <= endsAt);
764     assert(now <= startsAt);
765 
766     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
767     if (lastTierCntrct.finalized()) throw;
768 
769     uint8 tierPosition = getTierPosition(this);
770 
771     //start time should be greater then end time of previous tiers
772     for (uint8 j = 0; j < tierPosition; j++) {
773       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
774       assert(time >= crowdsale.endsAt());
775     }
776 
777     startsAt = time;
778     StartsAtChanged(startsAt);
779   }
780 
781   /**
782    * Allow crowdsale owner to close early or extend the crowdsale.
783    *
784    * This is useful e.g. for a manual soft cap implementation:
785    * - after X amount is reached determine manual closing
786    *
787    * This may put the crowdsale to an invalid state,
788    * but we trust owners know what they are doing.
789    *
790    */
791   function setEndsAt(uint time) public onlyOwner {
792     assert(!finalized);
793     assert(isUpdatable);
794     assert(now <= time);// Don't change past
795     assert(startsAt <= time);
796     assert(now <= endsAt);
797 
798     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
799     if (lastTierCntrct.finalized()) throw;
800 
801 
802     uint8 tierPosition = getTierPosition(this);
803 
804     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
805       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
806       assert(time <= crowdsale.startsAt());
807     }
808 
809     endsAt = time;
810     EndsAtChanged(endsAt);
811   }
812 
813   /**
814    * Allow to (re)set pricing strategy.
815    *
816    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
817    */
818   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
819     assert(address(_pricingStrategy) != address(0));
820     assert(address(pricingStrategy) == address(0));
821     pricingStrategy = _pricingStrategy;
822 
823     // Don't allow setting bad agent
824     if(!pricingStrategy.isPricingStrategy()) {
825       throw;
826     }
827   }
828 
829   /**
830    * Allow to change the team multisig address in the case of emergency.
831    *
832    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
833    * (we have done only few test transactions). After the crowdsale is going
834    * then multisig address stays locked for the safety reasons.
835    */
836   function setMultisig(address addr) public onlyOwner {
837 
838     // Change
839     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
840       throw;
841     }
842 
843     multisigWallet = addr;
844   }
845 
846   /**
847    * @return true if the crowdsale has raised enough money to be a successful.
848    */
849   function isMinimumGoalReached() public constant returns (bool reached) {
850     return weiRaised >= minimumFundingGoal;
851   }
852 
853   /**
854    * Check if the contract relationship looks good.
855    */
856   function isFinalizerSane() public constant returns (bool sane) {
857     return finalizeAgent.isSane();
858   }
859 
860   /**
861    * Check if the contract relationship looks good.
862    */
863   function isPricingSane() public constant returns (bool sane) {
864     return pricingStrategy.isSane(address(this));
865   }
866 
867   /**
868    * Crowdfund state machine management.
869    *
870    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
871    */
872   function getState() public constant returns (State) {
873     if(finalized) return State.Finalized;
874     else if (address(finalizeAgent) == 0) return State.Preparing;
875     else if (!finalizeAgent.isSane()) return State.Preparing;
876     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
877     else if (block.timestamp < startsAt) return State.PreFunding;
878     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
879     else if (isMinimumGoalReached()) return State.Success;
880     else return State.Failure;
881   }
882 
883   /** Interface marker. */
884   function isCrowdsale() public constant returns (bool) {
885     return true;
886   }
887 
888   //
889   // Modifiers
890   //
891 
892   /** Modified allowing execution only if the crowdsale is currently running.  */
893   modifier inState(State state) {
894     if(getState() != state) throw;
895     _;
896   }
897 
898 
899   //
900   // Abstract functions
901   //
902 
903   /**
904    * Check if the current invested breaks our cap rules.
905    *
906    *
907    * The child contract must define their own cap setting rules.
908    * We allow a lot of flexibility through different capping strategies (ETH, token count)
909    * Called from invest().
910    *
911    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
912    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
913    * @param weiRaisedTotal What would be our total raised balance after this transaction
914    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
915    *
916    * @return true if taking this investment would break our cap rules
917    */
918   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
919 
920   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
921 
922   /**
923    * Check if the current crowdsale is full and we can no longer sell any tokens.
924    */
925   function isCrowdsaleFull() public constant returns (bool);
926 
927   /**
928    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
929    */
930   function assignTokens(address receiver, uint tokenAmount) private;
931 }
932 
933 /**
934  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
935  *
936  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
937  */
938 
939 
940 
941 /**
942  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
943  *
944  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
945  */
946 
947 
948 
949 
950 
951 
952 
953 
954 /**
955  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
956  *
957  * Based on code by FirstBlood:
958  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
959  */
960 contract StandardToken is ERC20, SafeMath {
961 
962   /* Token supply got increased and a new owner received these tokens */
963   event Minted(address receiver, uint amount);
964 
965   /* Actual balances of token holders */
966   mapping(address => uint) balances;
967 
968   /* approve() allowances */
969   mapping (address => mapping (address => uint)) allowed;
970 
971   /* Interface declaration */
972   function isToken() public constant returns (bool weAre) {
973     return true;
974   }
975 
976   function transfer(address _to, uint _value) returns (bool success) {
977     balances[msg.sender] = safeSub(balances[msg.sender], _value);
978     balances[_to] = safeAdd(balances[_to], _value);
979     Transfer(msg.sender, _to, _value);
980     return true;
981   }
982 
983   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
984     uint _allowance = allowed[_from][msg.sender];
985 
986     balances[_to] = safeAdd(balances[_to], _value);
987     balances[_from] = safeSub(balances[_from], _value);
988     allowed[_from][msg.sender] = safeSub(_allowance, _value);
989     Transfer(_from, _to, _value);
990     return true;
991   }
992 
993   function balanceOf(address _owner) constant returns (uint balance) {
994     return balances[_owner];
995   }
996 
997   function approve(address _spender, uint _value) returns (bool success) {
998 
999     // To change the approve amount you first have to reduce the addresses`
1000     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1001     //  already 0 to mitigate the race condition described here:
1002     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1003     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
1004 
1005     allowed[msg.sender][_spender] = _value;
1006     Approval(msg.sender, _spender, _value);
1007     return true;
1008   }
1009 
1010   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1011     return allowed[_owner][_spender];
1012   }
1013 
1014 }
1015 
1016 
1017 
1018 
1019 
1020 /**
1021  * A token that can increase its supply by another contract.
1022  *
1023  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1024  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1025  *
1026  */
1027 contract MintableTokenExt is StandardToken, Ownable {
1028 
1029   using SafeMathLibExt for uint;
1030 
1031   bool public mintingFinished = false;
1032 
1033   /** List of agents that are allowed to create new tokens */
1034   mapping (address => bool) public mintAgents;
1035 
1036   event MintingAgentChanged(address addr, bool state  );
1037 
1038   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1039   * For example, for reserved tokens in percents 2.54%
1040   * inPercentageUnit = 254
1041   * inPercentageDecimals = 2
1042   */
1043   struct ReservedTokensData {
1044     uint inTokens;
1045     uint inPercentageUnit;
1046     uint inPercentageDecimals;
1047     bool isReserved;
1048     bool isDistributed;
1049   }
1050 
1051   mapping (address => ReservedTokensData) public reservedTokensList;
1052   address[] public reservedTokensDestinations;
1053   uint public reservedTokensDestinationsLen = 0;
1054   bool reservedTokensDestinationsAreSet = false;
1055 
1056   modifier onlyMintAgent() {
1057     // Only crowdsale contracts are allowed to mint new tokens
1058     if(!mintAgents[msg.sender]) {
1059         throw;
1060     }
1061     _;
1062   }
1063 
1064   /** Make sure we are not done yet. */
1065   modifier canMint() {
1066     if(mintingFinished) throw;
1067     _;
1068   }
1069 
1070   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1071     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1072     reservedTokensData.isDistributed = true;
1073   }
1074 
1075   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1076     return reservedTokensList[addr].isReserved;
1077   }
1078 
1079   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1080     return reservedTokensList[addr].isDistributed;
1081   }
1082 
1083   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1084     return reservedTokensList[addr].inTokens;
1085   }
1086 
1087   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1088     return reservedTokensList[addr].inPercentageUnit;
1089   }
1090 
1091   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1092     return reservedTokensList[addr].inPercentageDecimals;
1093   }
1094 
1095   function setReservedTokensListMultiple(
1096     address[] addrs, 
1097     uint[] inTokens, 
1098     uint[] inPercentageUnit, 
1099     uint[] inPercentageDecimals
1100   ) public canMint onlyOwner {
1101     assert(!reservedTokensDestinationsAreSet);
1102     assert(addrs.length == inTokens.length);
1103     assert(inTokens.length == inPercentageUnit.length);
1104     assert(inPercentageUnit.length == inPercentageDecimals.length);
1105     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1106       if (addrs[iterator] != address(0)) {
1107         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1108       }
1109     }
1110     reservedTokensDestinationsAreSet = true;
1111   }
1112 
1113   /**
1114    * Create new tokens and allocate them to an address..
1115    *
1116    * Only callably by a crowdsale contract (mint agent).
1117    */
1118   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1119     totalSupply = totalSupply.plus(amount);
1120     balances[receiver] = balances[receiver].plus(amount);
1121 
1122     // This will make the mint transaction apper in EtherScan.io
1123     // We can remove this after there is a standardized minting event
1124     Transfer(0, receiver, amount);
1125   }
1126 
1127   /**
1128    * Owner can allow a crowdsale contract to mint new tokens.
1129    */
1130   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1131     mintAgents[addr] = state;
1132     MintingAgentChanged(addr, state);
1133   }
1134 
1135   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1136     assert(addr != address(0));
1137     if (!isAddressReserved(addr)) {
1138       reservedTokensDestinations.push(addr);
1139       reservedTokensDestinationsLen++;
1140     }
1141 
1142     reservedTokensList[addr] = ReservedTokensData({
1143       inTokens: inTokens, 
1144       inPercentageUnit: inPercentageUnit, 
1145       inPercentageDecimals: inPercentageDecimals,
1146       isReserved: true,
1147       isDistributed: false
1148     });
1149   }
1150 }
1151 
1152 /**
1153  * ICO crowdsale contract that is capped by amout of tokens.
1154  *
1155  * - Tokens are dynamically created during the crowdsale
1156  *
1157  *
1158  */
1159 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1160 
1161   /* Maximum amount of tokens this crowdsale can sell. */
1162   uint public maximumSellableTokens;
1163 
1164   function MintedTokenCappedCrowdsaleExt(
1165     string _name, 
1166     address _token, 
1167     PricingStrategy _pricingStrategy, 
1168     address _multisigWallet, 
1169     uint _start, uint _end, 
1170     uint _minimumFundingGoal, 
1171     uint _maximumSellableTokens, 
1172     bool _isUpdatable, 
1173     bool _isWhiteListed
1174   ) CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1175     maximumSellableTokens = _maximumSellableTokens;
1176   }
1177 
1178   // Crowdsale maximumSellableTokens has been changed
1179   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1180 
1181   /**
1182    * Called from invest() to confirm if the curret investment does not break our cap rule.
1183    */
1184   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
1185     return tokensSoldTotal > maximumSellableTokens;
1186   }
1187 
1188   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
1189     assert(isWhiteListed);
1190     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1191     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1192   }
1193 
1194   function isCrowdsaleFull() public constant returns (bool) {
1195     return tokensSold >= maximumSellableTokens;
1196   }
1197 
1198   function setMaximumSellableTokens(uint tokens) public onlyOwner {
1199     assert(!finalized);
1200     assert(isUpdatable);
1201     assert(now <= startsAt);
1202 
1203     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1204     assert(!lastTierCntrct.finalized());
1205 
1206     maximumSellableTokens = tokens;
1207     MaximumSellableTokensChanged(maximumSellableTokens);
1208   }
1209 
1210   function updateRate(uint newOneTokenInWei) public onlyOwner {
1211     assert(!finalized);
1212     assert(isUpdatable);
1213     assert(now <= startsAt);
1214 
1215     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1216     assert(!lastTierCntrct.finalized());
1217 
1218     pricingStrategy.updateRate(newOneTokenInWei);
1219   }
1220 
1221   /**
1222    * Dynamically create tokens and assign them to the investor.
1223    */
1224   function assignTokens(address receiver, uint tokenAmount) private {
1225     MintableTokenExt mintableToken = MintableTokenExt(token);
1226     mintableToken.mint(receiver, tokenAmount);
1227   }
1228 }