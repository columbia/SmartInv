1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
16 
17 
18 
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeMul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function safeDiv(uint a, uint b) internal returns (uint) {
31     assert(b > 0);
32     uint c = a / b;
33     assert(a == b * c + a % b);
34     return c;
35   }
36 
37   function safeSub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function safeAdd(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 
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
109 
110 
111 /**
112  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
113  */
114 
115 
116 
117 /**
118  * Safe unsigned safe math.
119  *
120  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
121  *
122  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
123  *
124  * Maintained here until merged to mainline zeppelin-solidity.
125  *
126  */
127 library SafeMathLibExt {
128 
129   function times(uint a, uint b) returns (uint) {
130     uint c = a * b;
131     assert(a == 0 || c / a == b);
132     return c;
133   }
134 
135   function divides(uint a, uint b) returns (uint) {
136     assert(b > 0);
137     uint c = a / b;
138     assert(a == b * c + a % b);
139     return c;
140   }
141 
142   function minus(uint a, uint b) returns (uint) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   function plus(uint a, uint b) returns (uint) {
148     uint c = a + b;
149     assert(c>=a);
150     return c;
151   }
152 
153 }
154 
155 /**
156  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
157  */
158 
159 
160 
161 
162 /**
163  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
164  */
165 
166 
167 
168 
169 
170 /*
171  * Haltable
172  *
173  * Abstract contract that allows children to implement an
174  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
175  *
176  *
177  * Originally envisioned in FirstBlood ICO contract.
178  */
179 contract Haltable is Ownable {
180   bool public halted;
181 
182   modifier stopInEmergency {
183     if (halted) throw;
184     _;
185   }
186 
187   modifier stopNonOwnersInEmergency {
188     if (halted && msg.sender != owner) throw;
189     _;
190   }
191 
192   modifier onlyInEmergency {
193     if (!halted) throw;
194     _;
195   }
196 
197   // called by the owner on emergency, triggers stopped state
198   function halt() external onlyOwner {
199     halted = true;
200   }
201 
202   // called by the owner on end of emergency, returns to normal state
203   function unhalt() external onlyOwner onlyInEmergency {
204     halted = false;
205   }
206 
207 }
208 
209 /**
210  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
211  */
212 
213 
214 
215 /**
216  * Interface for defining crowdsale pricing.
217  */
218 contract PricingStrategy {
219 
220   address public tier;
221 
222   /** Interface declaration. */
223   function isPricingStrategy() public constant returns (bool) {
224     return true;
225   }
226 
227   /** Self check if all references are correctly set.
228    *
229    * Checks that pricing strategy matches crowdsale parameters.
230    */
231   function isSane(address crowdsale) public constant returns (bool) {
232     return true;
233   }
234 
235   /**
236    * @dev Pricing tells if this is a presale purchase or not.
237      @param purchaser Address of the purchaser
238      @return False by default, true if a presale purchaser
239    */
240   function isPresalePurchase(address purchaser) public constant returns (bool) {
241     return false;
242   }
243 
244   /* How many weis one token costs */
245   function updateRate(uint newOneTokenInWei) public;
246 
247   /**
248    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
249    *
250    *
251    * @param value - What is the value of the transaction send in as wei
252    * @param tokensSold - how much tokens have been sold this far
253    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
254    * @param msgSender - who is the investor of this transaction
255    * @param decimals - how many decimal units the token has
256    * @return Amount of tokens the investor receives
257    */
258   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
259 }
260 
261 /**
262  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
263  */
264 
265 
266 
267 /**
268  * Finalize agent defines what happens at the end of succeseful crowdsale.
269  *
270  * - Allocate tokens for founders, bounties and community
271  * - Make tokens transferable
272  * - etc.
273  */
274 contract FinalizeAgent {
275 
276   bool public reservedTokensAreDistributed = false;
277 
278   function isFinalizeAgent() public constant returns(bool) {
279     return true;
280   }
281 
282   /** Return true if we can run finalizeCrowdsale() properly.
283    *
284    * This is a safety check function that doesn't allow crowdsale to begin
285    * unless the finalizer has been set up properly.
286    */
287   function isSane() public constant returns (bool);
288 
289   function distributeReservedTokens(uint reservedTokensDistributionBatch);
290 
291   /** Called once by crowdsale finalize() if the sale was success. */
292   function finalizeCrowdsale();
293 
294 }
295 /**
296  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
297  */
298 
299 
300 
301 
302 
303 
304 
305 
306 
307 /**
308  * @title ERC20 interface
309  * @dev see https://github.com/ethereum/EIPs/issues/20
310  */
311 contract ERC20 is ERC20Basic {
312   function allowance(address owner, address spender) public constant returns (uint256);
313   function transferFrom(address from, address to, uint256 value) public returns (bool);
314   function approve(address spender, uint256 value) public returns (bool);
315   event Approval(address indexed owner, address indexed spender, uint256 value);
316 }
317 
318 
319 /**
320  * A token that defines fractional units as decimals.
321  */
322 contract FractionalERC20Ext is ERC20 {
323 
324   uint public decimals;
325   uint public minCap;
326 
327 }
328 
329 
330 
331 /**
332  * Abstract base contract for token sales.
333  *
334  * Handle
335  * - start and end dates
336  * - accepting investments
337  * - minimum funding goal and refund
338  * - various statistics during the crowdfund
339  * - different pricing strategies
340  * - different investment policies (require server side customer id, allow only whitelisted addresses)
341  *
342  */
343 contract CrowdsaleExt is Haltable {
344 
345   /* Max investment count when we are still allowed to change the multisig address */
346   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
347 
348   using SafeMathLibExt for uint;
349 
350   /* The token we are selling */
351   FractionalERC20Ext public token;
352 
353   /* How we are going to price our offering */
354   PricingStrategy public pricingStrategy;
355 
356   /* Post-success callback */
357   FinalizeAgent public finalizeAgent;
358 
359   /* name of the crowdsale tier */
360   string public name;
361 
362   /* tokens will be transfered from this address */
363   address public multisigWallet;
364 
365   /* if the funding goal is not reached, investors may withdraw their funds */
366   uint public minimumFundingGoal;
367 
368   /* the UNIX timestamp start date of the crowdsale */
369   uint public startsAt;
370 
371   /* the UNIX timestamp end date of the crowdsale */
372   uint public endsAt;
373 
374   /* the number of tokens already sold through this contract*/
375   uint public tokensSold = 0;
376 
377   /* How many wei of funding we have raised */
378   uint public weiRaised = 0;
379 
380   /* How many distinct addresses have invested */
381   uint public investorCount = 0;
382 
383   /* Has this crowdsale been finalized */
384   bool public finalized;
385 
386   bool public isWhiteListed;
387 
388   address[] public joinedCrowdsales;
389   uint8 public joinedCrowdsalesLen = 0;
390   uint8 public joinedCrowdsalesLenMax = 50;
391   struct JoinedCrowdsaleStatus {
392     bool isJoined;
393     uint8 position;
394   }
395   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
396 
397   /** How much ETH each address has invested to this crowdsale */
398   mapping (address => uint256) public investedAmountOf;
399 
400   /** How much tokens this crowdsale has credited for each investor address */
401   mapping (address => uint256) public tokenAmountOf;
402 
403   struct WhiteListData {
404     bool status;
405     uint minCap;
406     uint maxCap;
407   }
408 
409   //is crowdsale updatable
410   bool public isUpdatable;
411 
412   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
413   mapping (address => WhiteListData) public earlyParticipantWhitelist;
414 
415   /** List of whitelisted addresses */
416   address[] public whitelistedParticipants;
417 
418   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
419   uint public ownerTestValue;
420 
421   /** State machine
422    *
423    * - Preparing: All contract initialization calls and variables have not been set yet
424    * - Prefunding: We have not passed start time yet
425    * - Funding: Active crowdsale
426    * - Success: Minimum funding goal reached
427    * - Failure: Minimum funding goal not reached before ending time
428    * - Finalized: The finalized has been called and succesfully executed
429    */
430   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
431 
432   // A new investment was made
433   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
434 
435   // Address early participation whitelist status changed
436   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
437   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
438 
439   // Crowdsale start time has been changed
440   event StartsAtChanged(uint newStartsAt);
441 
442   // Crowdsale end time has been changed
443   event EndsAtChanged(uint newEndsAt);
444 
445   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
446 
447     owner = msg.sender;
448 
449     name = _name;
450 
451     token = FractionalERC20Ext(_token);
452 
453     setPricingStrategy(_pricingStrategy);
454 
455     multisigWallet = _multisigWallet;
456     if(multisigWallet == 0) {
457         throw;
458     }
459 
460     if(_start == 0) {
461         throw;
462     }
463 
464     startsAt = _start;
465 
466     if(_end == 0) {
467         throw;
468     }
469 
470     endsAt = _end;
471 
472     // Don't mess the dates
473     if(startsAt >= endsAt) {
474         throw;
475     }
476 
477     // Minimum funding goal can be zero
478     minimumFundingGoal = _minimumFundingGoal;
479 
480     isUpdatable = _isUpdatable;
481 
482     isWhiteListed = _isWhiteListed;
483   }
484 
485   /**
486    * Don't expect to just send in money and get tokens.
487    */
488   function() payable {
489     throw;
490   }
491 
492   /**
493    * Make an investment.
494    *
495    * Crowdsale must be running for one to invest.
496    * We must have not pressed the emergency brake.
497    *
498    * @param receiver The Ethereum address who receives the tokens
499    * @param customerId (optional) UUID v4 to track the successful payments on the server side
500    *
501    */
502   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
503 
504     // Determine if it's a good time to accept investment from this participant
505     if(getState() == State.PreFunding) {
506       // Are we whitelisted for early deposit
507       throw;
508     } else if(getState() == State.Funding) {
509       // Retail participants can only come in when the crowdsale is running
510       // pass
511       if(isWhiteListed) {
512         if(!earlyParticipantWhitelist[receiver].status) {
513           throw;
514         }
515       }
516     } else {
517       // Unwanted state
518       throw;
519     }
520 
521     uint weiAmount = msg.value;
522 
523     // Account presale sales separately, so that they do not count against pricing tranches
524     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
525 
526     if(tokenAmount == 0) {
527       // Dust transaction
528       throw;
529     }
530 
531     if(isWhiteListed) {
532       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
533         // tokenAmount < minCap for investor
534         throw;
535       }
536 
537       // Check that we did not bust the investor's cap
538       if (isBreakingInvestorCap(receiver, tokenAmount)) {
539         throw;
540       }
541 
542       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
543     } else {
544       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
545         throw;
546       }
547     }
548 
549     if(investedAmountOf[receiver] == 0) {
550        // A new investor
551        investorCount++;
552     }
553 
554     // Update investor
555     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
556     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
557 
558     // Update totals
559     weiRaised = weiRaised.plus(weiAmount);
560     tokensSold = tokensSold.plus(tokenAmount);
561 
562     // Check that we did not bust the cap
563     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
564       throw;
565     }
566 
567     assignTokens(receiver, tokenAmount);
568 
569     // Pocket the money
570     if(!multisigWallet.send(weiAmount)) throw;
571 
572     // Tell us invest was success
573     Invested(receiver, weiAmount, tokenAmount, customerId);
574   }
575 
576   /**
577    * Allow anonymous contributions to this crowdsale.
578    */
579   function invest(address addr) public payable {
580     investInternal(addr, 0);
581   }
582 
583   /**
584    * The basic entry point to participate the crowdsale process.
585    *
586    * Pay for funding, get invested tokens back in the sender address.
587    */
588   function buy() public payable {
589     invest(msg.sender);
590   }
591 
592   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
593     // Already finalized
594     if(finalized) {
595       throw;
596     }
597 
598     // Finalizing is optional. We only call it if we are given a finalizing agent.
599     if(address(finalizeAgent) != address(0)) {
600       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
601     }
602   }
603 
604   function areReservedTokensDistributed() public constant returns (bool) {
605     return finalizeAgent.reservedTokensAreDistributed();
606   }
607 
608   function canDistributeReservedTokens() public constant returns(bool) {
609     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
610     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
611     return false;
612   }
613 
614   /**
615    * Finalize a succcesful crowdsale.
616    *
617    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
618    */
619   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
620 
621     // Already finalized
622     if(finalized) {
623       throw;
624     }
625 
626     // Finalizing is optional. We only call it if we are given a finalizing agent.
627     if(address(finalizeAgent) != address(0)) {
628       finalizeAgent.finalizeCrowdsale();
629     }
630 
631     finalized = true;
632   }
633 
634   /**
635    * Allow to (re)set finalize agent.
636    *
637    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
638    */
639   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
640     assert(address(addr) != address(0));
641     assert(address(finalizeAgent) == address(0));
642     finalizeAgent = addr;
643 
644     // Don't allow setting bad agent
645     if(!finalizeAgent.isFinalizeAgent()) {
646       throw;
647     }
648   }
649 
650   /**
651    * Allow addresses to do early participation.
652    */
653   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
654     if (!isWhiteListed) throw;
655     assert(addr != address(0));
656     assert(maxCap > 0);
657     assert(minCap <= maxCap);
658     assert(now <= endsAt);
659 
660     if (!isAddressWhitelisted(addr)) {
661       whitelistedParticipants.push(addr);
662       Whitelisted(addr, status, minCap, maxCap);
663     } else {
664       WhitelistItemChanged(addr, status, minCap, maxCap);
665     }
666 
667     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
668   }
669 
670   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
671     if (!isWhiteListed) throw;
672     assert(now <= endsAt);
673     assert(addrs.length == statuses.length);
674     assert(statuses.length == minCaps.length);
675     assert(minCaps.length == maxCaps.length);
676     for (uint iterator = 0; iterator < addrs.length; iterator++) {
677       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
678     }
679   }
680 
681   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
682     if (!isWhiteListed) throw;
683     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
684 
685     uint8 tierPosition = getTierPosition(this);
686 
687     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
688       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
689       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
690     }
691   }
692 
693   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
694     if (!isWhiteListed) throw;
695     assert(addr != address(0));
696     assert(now <= endsAt);
697     assert(isTierJoined(msg.sender));
698     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
699     //if (addr != msg.sender && contractAddr != msg.sender) throw;
700     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
701     newMaxCap = newMaxCap.minus(tokensBought);
702     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
703   }
704 
705   function isAddressWhitelisted(address addr) public constant returns(bool) {
706     for (uint i = 0; i < whitelistedParticipants.length; i++) {
707       if (whitelistedParticipants[i] == addr) {
708         return true;
709         break;
710       }
711     }
712 
713     return false;
714   }
715 
716   function whitelistedParticipantsLength() public constant returns (uint) {
717     return whitelistedParticipants.length;
718   }
719 
720   function isTierJoined(address addr) public constant returns(bool) {
721     return joinedCrowdsaleState[addr].isJoined;
722   }
723 
724   function getTierPosition(address addr) public constant returns(uint8) {
725     return joinedCrowdsaleState[addr].position;
726   }
727 
728   function getLastTier() public constant returns(address) {
729     if (joinedCrowdsalesLen > 0)
730       return joinedCrowdsales[joinedCrowdsalesLen - 1];
731     else
732       return address(0);
733   }
734 
735   function setJoinedCrowdsales(address addr) private onlyOwner {
736     assert(addr != address(0));
737     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
738     assert(!isTierJoined(addr));
739     joinedCrowdsales.push(addr);
740     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
741       isJoined: true,
742       position: joinedCrowdsalesLen
743     });
744     joinedCrowdsalesLen++;
745   }
746 
747   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
748     assert(addrs.length > 0);
749     assert(joinedCrowdsalesLen == 0);
750     assert(addrs.length <= joinedCrowdsalesLenMax);
751     for (uint8 iter = 0; iter < addrs.length; iter++) {
752       setJoinedCrowdsales(addrs[iter]);
753     }
754   }
755 
756   function setStartsAt(uint time) onlyOwner {
757     assert(!finalized);
758     assert(isUpdatable);
759     assert(now <= time); // Don't change past
760     assert(time <= endsAt);
761     assert(now <= startsAt);
762 
763     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
764     if (lastTierCntrct.finalized()) throw;
765 
766     uint8 tierPosition = getTierPosition(this);
767 
768     //start time should be greater then end time of previous tiers
769     for (uint8 j = 0; j < tierPosition; j++) {
770       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
771       assert(time >= crowdsale.endsAt());
772     }
773 
774     startsAt = time;
775     StartsAtChanged(startsAt);
776   }
777 
778   /**
779    * Allow crowdsale owner to close early or extend the crowdsale.
780    *
781    * This is useful e.g. for a manual soft cap implementation:
782    * - after X amount is reached determine manual closing
783    *
784    * This may put the crowdsale to an invalid state,
785    * but we trust owners know what they are doing.
786    *
787    */
788   function setEndsAt(uint time) public onlyOwner {
789     assert(!finalized);
790     assert(isUpdatable);
791     assert(now <= time);// Don't change past
792     assert(startsAt <= time);
793     assert(now <= endsAt);
794 
795     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
796     if (lastTierCntrct.finalized()) throw;
797 
798 
799     uint8 tierPosition = getTierPosition(this);
800 
801     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
802       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
803       assert(time <= crowdsale.startsAt());
804     }
805 
806     endsAt = time;
807     EndsAtChanged(endsAt);
808   }
809 
810   /**
811    * Allow to (re)set pricing strategy.
812    *
813    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
814    */
815   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
816     assert(address(_pricingStrategy) != address(0));
817     assert(address(pricingStrategy) == address(0));
818     pricingStrategy = _pricingStrategy;
819 
820     // Don't allow setting bad agent
821     if(!pricingStrategy.isPricingStrategy()) {
822       throw;
823     }
824   }
825 
826   /**
827    * Allow to change the team multisig address in the case of emergency.
828    *
829    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
830    * (we have done only few test transactions). After the crowdsale is going
831    * then multisig address stays locked for the safety reasons.
832    */
833   function setMultisig(address addr) public onlyOwner {
834 
835     // Change
836     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
837       throw;
838     }
839 
840     multisigWallet = addr;
841   }
842 
843   /**
844    * @return true if the crowdsale has raised enough money to be a successful.
845    */
846   function isMinimumGoalReached() public constant returns (bool reached) {
847     return weiRaised >= minimumFundingGoal;
848   }
849 
850   /**
851    * Check if the contract relationship looks good.
852    */
853   function isFinalizerSane() public constant returns (bool sane) {
854     return finalizeAgent.isSane();
855   }
856 
857   /**
858    * Check if the contract relationship looks good.
859    */
860   function isPricingSane() public constant returns (bool sane) {
861     return pricingStrategy.isSane(address(this));
862   }
863 
864   /**
865    * Crowdfund state machine management.
866    *
867    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
868    */
869   function getState() public constant returns (State) {
870     if(finalized) return State.Finalized;
871     else if (address(finalizeAgent) == 0) return State.Preparing;
872     else if (!finalizeAgent.isSane()) return State.Preparing;
873     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
874     else if (block.timestamp < startsAt) return State.PreFunding;
875     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
876     else if (isMinimumGoalReached()) return State.Success;
877     else return State.Failure;
878   }
879 
880   /** Interface marker. */
881   function isCrowdsale() public constant returns (bool) {
882     return true;
883   }
884 
885   //
886   // Modifiers
887   //
888 
889   /** Modified allowing execution only if the crowdsale is currently running.  */
890   modifier inState(State state) {
891     if(getState() != state) throw;
892     _;
893   }
894 
895 
896   //
897   // Abstract functions
898   //
899 
900   /**
901    * Check if the current invested breaks our cap rules.
902    *
903    *
904    * The child contract must define their own cap setting rules.
905    * We allow a lot of flexibility through different capping strategies (ETH, token count)
906    * Called from invest().
907    *
908    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
909    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
910    * @param weiRaisedTotal What would be our total raised balance after this transaction
911    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
912    *
913    * @return true if taking this investment would break our cap rules
914    */
915   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
916 
917   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
918 
919   /**
920    * Check if the current crowdsale is full and we can no longer sell any tokens.
921    */
922   function isCrowdsaleFull() public constant returns (bool);
923 
924   /**
925    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
926    */
927   function assignTokens(address receiver, uint tokenAmount) private;
928 }
929 
930 /**
931  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
932  */
933 
934 
935 
936 /**
937  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
938  */
939 
940 
941 
942 
943 
944 
945 
946 
947 /**
948  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
949  *
950  * Based on code by FirstBlood:
951  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
952  */
953 contract StandardToken is ERC20, SafeMath {
954 
955   /* Token supply got increased and a new owner received these tokens */
956   event Minted(address receiver, uint amount);
957 
958   /* Actual balances of token holders */
959   mapping(address => uint) balances;
960 
961   /* approve() allowances */
962   mapping (address => mapping (address => uint)) allowed;
963 
964   /* Interface declaration */
965   function isToken() public constant returns (bool weAre) {
966     return true;
967   }
968 
969   function transfer(address _to, uint _value) returns (bool success) {
970     balances[msg.sender] = safeSub(balances[msg.sender], _value);
971     balances[_to] = safeAdd(balances[_to], _value);
972     Transfer(msg.sender, _to, _value);
973     return true;
974   }
975 
976   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
977     uint _allowance = allowed[_from][msg.sender];
978 
979     balances[_to] = safeAdd(balances[_to], _value);
980     balances[_from] = safeSub(balances[_from], _value);
981     allowed[_from][msg.sender] = safeSub(_allowance, _value);
982     Transfer(_from, _to, _value);
983     return true;
984   }
985 
986   function balanceOf(address _owner) constant returns (uint balance) {
987     return balances[_owner];
988   }
989 
990   function approve(address _spender, uint _value) returns (bool success) {
991 
992     // To change the approve amount you first have to reduce the addresses`
993     //  allowance to zero by calling `approve(_spender, 0)` if it is not
994     //  already 0 to mitigate the race condition described here:
995     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
996     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
997 
998     allowed[msg.sender][_spender] = _value;
999     Approval(msg.sender, _spender, _value);
1000     return true;
1001   }
1002 
1003   function allowance(address _owner, address _spender) constant returns (uint remaining) {
1004     return allowed[_owner][_spender];
1005   }
1006 
1007 }
1008 
1009 /**
1010  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
1011  */
1012 
1013 
1014 
1015 
1016 
1017 /**
1018  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
1019  */
1020 
1021 
1022 
1023 /**
1024  * Upgrade agent interface inspired by Lunyr.
1025  *
1026  * Upgrade agent transfers tokens to a new contract.
1027  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
1028  */
1029 contract UpgradeAgent {
1030 
1031   uint public originalSupply;
1032 
1033   /** Interface marker */
1034   function isUpgradeAgent() public constant returns (bool) {
1035     return true;
1036   }
1037 
1038   function upgradeFrom(address _from, uint256 _value) public;
1039 
1040 }
1041 
1042 
1043 /**
1044  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
1045  *
1046  * First envisioned by Golem and Lunyr projects.
1047  */
1048 contract UpgradeableToken is StandardToken {
1049 
1050   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
1051   address public upgradeMaster;
1052 
1053   /** The next contract where the tokens will be migrated. */
1054   UpgradeAgent public upgradeAgent;
1055 
1056   /** How many tokens we have upgraded by now. */
1057   uint256 public totalUpgraded;
1058 
1059   /**
1060    * Upgrade states.
1061    *
1062    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
1063    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
1064    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
1065    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
1066    *
1067    */
1068   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
1069 
1070   /**
1071    * Somebody has upgraded some of his tokens.
1072    */
1073   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1074 
1075   /**
1076    * New upgrade agent available.
1077    */
1078   event UpgradeAgentSet(address agent);
1079 
1080   /**
1081    * Do not allow construction without upgrade master set.
1082    */
1083   function UpgradeableToken(address _upgradeMaster) {
1084     upgradeMaster = _upgradeMaster;
1085   }
1086 
1087   /**
1088    * Allow the token holder to upgrade some of their tokens to a new contract.
1089    */
1090   function upgrade(uint256 value) public {
1091 
1092       UpgradeState state = getUpgradeState();
1093       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
1094         // Called in a bad state
1095         throw;
1096       }
1097 
1098       // Validate input value.
1099       if (value == 0) throw;
1100 
1101       balances[msg.sender] = safeSub(balances[msg.sender], value);
1102 
1103       // Take tokens out from circulation
1104       totalSupply = safeSub(totalSupply, value);
1105       totalUpgraded = safeAdd(totalUpgraded, value);
1106 
1107       // Upgrade agent reissues the tokens
1108       upgradeAgent.upgradeFrom(msg.sender, value);
1109       Upgrade(msg.sender, upgradeAgent, value);
1110   }
1111 
1112   /**
1113    * Set an upgrade agent that handles
1114    */
1115   function setUpgradeAgent(address agent) external {
1116 
1117       if(!canUpgrade()) {
1118         // The token is not yet in a state that we could think upgrading
1119         throw;
1120       }
1121 
1122       if (agent == 0x0) throw;
1123       // Only a master can designate the next agent
1124       if (msg.sender != upgradeMaster) throw;
1125       // Upgrade has already begun for an agent
1126       if (getUpgradeState() == UpgradeState.Upgrading) throw;
1127 
1128       upgradeAgent = UpgradeAgent(agent);
1129 
1130       // Bad interface
1131       if(!upgradeAgent.isUpgradeAgent()) throw;
1132       // Make sure that token supplies match in source and target
1133       if (upgradeAgent.originalSupply() != totalSupply) throw;
1134 
1135       UpgradeAgentSet(upgradeAgent);
1136   }
1137 
1138   /**
1139    * Get the state of the token upgrade.
1140    */
1141   function getUpgradeState() public constant returns(UpgradeState) {
1142     if(!canUpgrade()) return UpgradeState.NotAllowed;
1143     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
1144     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1145     else return UpgradeState.Upgrading;
1146   }
1147 
1148   /**
1149    * Change the upgrade master.
1150    *
1151    * This allows us to set a new owner for the upgrade mechanism.
1152    */
1153   function setUpgradeMaster(address master) public {
1154       if (master == 0x0) throw;
1155       if (msg.sender != upgradeMaster) throw;
1156       upgradeMaster = master;
1157   }
1158 
1159   /**
1160    * Child contract can enable to provide the condition when the upgrade can begun.
1161    */
1162   function canUpgrade() public constant returns(bool) {
1163      return true;
1164   }
1165 
1166 }
1167 
1168 /**
1169  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
1170  */
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 /**
1179  * Define interface for releasing the token transfer after a successful crowdsale.
1180  */
1181 contract ReleasableToken is ERC20, Ownable {
1182 
1183   /* The finalizer contract that allows unlift the transfer limits on this token */
1184   address public releaseAgent;
1185 
1186   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
1187   bool public released = false;
1188 
1189   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
1190   mapping (address => bool) public transferAgents;
1191 
1192   /**
1193    * Limit token transfer until the crowdsale is over.
1194    *
1195    */
1196   modifier canTransfer(address _sender) {
1197 
1198     if(!released) {
1199         if(!transferAgents[_sender]) {
1200             throw;
1201         }
1202     }
1203 
1204     _;
1205   }
1206 
1207   /**
1208    * Set the contract that can call release and make the token transferable.
1209    *
1210    * Design choice. Allow reset the release agent to fix fat finger mistakes.
1211    */
1212   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
1213 
1214     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
1215     releaseAgent = addr;
1216   }
1217 
1218   /**
1219    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
1220    */
1221   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
1222     transferAgents[addr] = state;
1223   }
1224 
1225   /**
1226    * One way function to release the tokens to the wild.
1227    *
1228    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
1229    */
1230   function releaseTokenTransfer() public onlyReleaseAgent {
1231     released = true;
1232   }
1233 
1234   /** The function can be called only before or after the tokens have been releasesd */
1235   modifier inReleaseState(bool releaseState) {
1236     if(releaseState != released) {
1237         throw;
1238     }
1239     _;
1240   }
1241 
1242   /** The function can be called only by a whitelisted release agent. */
1243   modifier onlyReleaseAgent() {
1244     if(msg.sender != releaseAgent) {
1245         throw;
1246     }
1247     _;
1248   }
1249 
1250   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
1251     // Call StandardToken.transfer()
1252    return super.transfer(_to, _value);
1253   }
1254 
1255   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
1256     // Call StandardToken.transferForm()
1257     return super.transferFrom(_from, _to, _value);
1258   }
1259 
1260 }
1261 
1262 /**
1263  * This smart contract code is Copyright 2018 K Systems Ltd. For more information see https://ksystems.io
1264  */
1265 
1266 
1267 
1268 
1269 
1270 
1271 
1272 
1273 /**
1274  * A token that can increase its supply by another contract.
1275  *
1276  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1277  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1278  *
1279  */
1280 contract MintableTokenExt is StandardToken, Ownable {
1281 
1282   using SafeMathLibExt for uint;
1283 
1284   bool public mintingFinished = false;
1285 
1286   /** List of agents that are allowed to create new tokens */
1287   mapping (address => bool) public mintAgents;
1288 
1289   event MintingAgentChanged(address addr, bool state  );
1290 
1291   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1292   * For example, for reserved tokens in percents 2.54%
1293   * inPercentageUnit = 254
1294   * inPercentageDecimals = 2
1295   */
1296   struct ReservedTokensData {
1297     uint inTokens;
1298     uint inPercentageUnit;
1299     uint inPercentageDecimals;
1300     bool isReserved;
1301     bool isDistributed;
1302   }
1303 
1304   mapping (address => ReservedTokensData) public reservedTokensList;
1305   address[] public reservedTokensDestinations;
1306   uint public reservedTokensDestinationsLen = 0;
1307   bool reservedTokensDestinationsAreSet = false;
1308 
1309   modifier onlyMintAgent() {
1310     // Only crowdsale contracts are allowed to mint new tokens
1311     if(!mintAgents[msg.sender]) {
1312         throw;
1313     }
1314     _;
1315   }
1316 
1317   /** Make sure we are not done yet. */
1318   modifier canMint() {
1319     if(mintingFinished) throw;
1320     _;
1321   }
1322 
1323   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1324     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1325     reservedTokensData.isDistributed = true;
1326   }
1327 
1328   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1329     return reservedTokensList[addr].isReserved;
1330   }
1331 
1332   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1333     return reservedTokensList[addr].isDistributed;
1334   }
1335 
1336   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1337     return reservedTokensList[addr].inTokens;
1338   }
1339 
1340   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1341     return reservedTokensList[addr].inPercentageUnit;
1342   }
1343 
1344   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1345     return reservedTokensList[addr].inPercentageDecimals;
1346   }
1347 
1348   function setReservedTokensListMultiple(
1349     address[] addrs, 
1350     uint[] inTokens, 
1351     uint[] inPercentageUnit, 
1352     uint[] inPercentageDecimals
1353   ) public canMint onlyOwner {
1354     assert(!reservedTokensDestinationsAreSet);
1355     assert(addrs.length == inTokens.length);
1356     assert(inTokens.length == inPercentageUnit.length);
1357     assert(inPercentageUnit.length == inPercentageDecimals.length);
1358     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1359       if (addrs[iterator] != address(0)) {
1360         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1361       }
1362     }
1363     reservedTokensDestinationsAreSet = true;
1364   }
1365 
1366   /**
1367    * Create new tokens and allocate them to an address..
1368    *
1369    * Only callably by a crowdsale contract (mint agent).
1370    */
1371   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1372     totalSupply = totalSupply.plus(amount);
1373     balances[receiver] = balances[receiver].plus(amount);
1374 
1375     // This will make the mint transaction apper in EtherScan.io
1376     // We can remove this after there is a standardized minting event
1377     Transfer(0, receiver, amount);
1378   }
1379 
1380   /**
1381    * Owner can allow a crowdsale contract to mint new tokens.
1382    */
1383   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1384     mintAgents[addr] = state;
1385     MintingAgentChanged(addr, state);
1386   }
1387 
1388   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1389     assert(addr != address(0));
1390     if (!isAddressReserved(addr)) {
1391       reservedTokensDestinations.push(addr);
1392       reservedTokensDestinationsLen++;
1393     }
1394 
1395     reservedTokensList[addr] = ReservedTokensData({
1396       inTokens: inTokens, 
1397       inPercentageUnit: inPercentageUnit, 
1398       inPercentageDecimals: inPercentageDecimals,
1399       isReserved: true,
1400       isDistributed: false
1401     });
1402   }
1403 }
1404 
1405 
1406 /**
1407  * A crowdsaled token.
1408  *
1409  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1410  *
1411  * - The token transfer() is disabled until the crowdsale is over
1412  * - The token contract gives an opt-in upgrade path to a new contract
1413  * - The same token can be part of several crowdsales through approve() mechanism
1414  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1415  *
1416  */
1417 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
1418 
1419   /** Name and symbol were updated. */
1420   event UpdatedTokenInformation(string newName, string newSymbol);
1421 
1422   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1423 
1424   string public name;
1425 
1426   string public symbol;
1427 
1428   uint public decimals;
1429 
1430   /* Minimum ammount of tokens every buyer can buy. */
1431   uint public minCap;
1432 
1433   /**
1434    * Construct the token.
1435    *
1436    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1437    *
1438    * @param _name Token name
1439    * @param _symbol Token symbol - should be all caps
1440    * @param _initialSupply How many tokens we start with
1441    * @param _decimals Number of decimal places
1442    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
1443    */
1444   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
1445     UpgradeableToken(msg.sender) {
1446 
1447     // Create any address, can be transferred
1448     // to team multisig via changeOwner(),
1449     // also remember to call setUpgradeMaster()
1450     owner = msg.sender;
1451 
1452     name = _name;
1453     symbol = _symbol;
1454 
1455     totalSupply = _initialSupply;
1456 
1457     decimals = _decimals;
1458 
1459     minCap = _globalMinCap;
1460 
1461     // Create initially all balance on the team multisig
1462     balances[owner] = totalSupply;
1463 
1464     if(totalSupply > 0) {
1465       Minted(owner, totalSupply);
1466     }
1467 
1468     // No more new supply allowed after the token creation
1469     if(!_mintable) {
1470       mintingFinished = true;
1471       if(totalSupply == 0) {
1472         throw; // Cannot create a token without supply and no minting
1473       }
1474     }
1475   }
1476 
1477   /**
1478    * When token is released to be transferable, enforce no new tokens can be created.
1479    */
1480   function releaseTokenTransfer() public onlyReleaseAgent {
1481     mintingFinished = true;
1482     super.releaseTokenTransfer();
1483   }
1484 
1485   /**
1486    * Allow upgrade agent functionality kick in only if the crowdsale was success.
1487    */
1488   function canUpgrade() public constant returns(bool) {
1489     return released && super.canUpgrade();
1490   }
1491 
1492   /**
1493    * Owner can update token information here.
1494    *
1495    * It is often useful to conceal the actual token association, until
1496    * the token operations, like central issuance or reissuance have been completed.
1497    *
1498    * This function allows the token owner to rename the token after the operations
1499    * have been completed and then point the audience to use the token contract.
1500    */
1501   function setTokenInformation(string _name, string _symbol) onlyOwner {
1502     name = _name;
1503     symbol = _symbol;
1504 
1505     UpdatedTokenInformation(name, symbol);
1506   }
1507 
1508   /**
1509    * Claim tokens that were accidentally sent to this contract.
1510    *
1511    * @param _token The address of the token contract that you want to recover.
1512    */
1513   function claimTokens(address _token) public onlyOwner {
1514     require(_token != address(0));
1515 
1516     ERC20 token = ERC20(_token);
1517     uint balance = token.balanceOf(this);
1518     token.transfer(owner, balance);
1519 
1520     ClaimedTokens(_token, owner, balance);
1521   }
1522 
1523 }
1524 
1525 
1526 /**
1527  * The default behavior for the crowdsale end.
1528  *
1529  * Unlock tokens.
1530  */
1531 contract ReservedTokensFinalizeAgent is FinalizeAgent {
1532   using SafeMathLibExt for uint;
1533   CrowdsaleTokenExt public token;
1534   CrowdsaleExt public crowdsale;
1535 
1536   uint public distributedReservedTokensDestinationsLen = 0;
1537 
1538   function ReservedTokensFinalizeAgent(CrowdsaleTokenExt _token, CrowdsaleExt _crowdsale) public {
1539     token = _token;
1540     crowdsale = _crowdsale;
1541   }
1542 
1543   /** Check that we can release the token */
1544   function isSane() public constant returns (bool) {
1545     return (token.releaseAgent() == address(this));
1546   }
1547 
1548   //distributes reserved tokens. Should be called before finalization
1549   function distributeReservedTokens(uint reservedTokensDistributionBatch) public {
1550     assert(msg.sender == address(crowdsale));
1551 
1552     assert(reservedTokensDistributionBatch > 0);
1553     assert(!reservedTokensAreDistributed);
1554     assert(distributedReservedTokensDestinationsLen < token.reservedTokensDestinationsLen());
1555 
1556 
1557     // How many % of tokens the founders and others get
1558     uint tokensSold = 0;
1559     for (uint8 i = 0; i < crowdsale.joinedCrowdsalesLen(); i++) {
1560       CrowdsaleExt tier = CrowdsaleExt(crowdsale.joinedCrowdsales(i));
1561       tokensSold = tokensSold.plus(tier.tokensSold());
1562     }
1563 
1564     uint startLooping = distributedReservedTokensDestinationsLen;
1565     uint batch = token.reservedTokensDestinationsLen().minus(distributedReservedTokensDestinationsLen);
1566     if (batch >= reservedTokensDistributionBatch) {
1567       batch = reservedTokensDistributionBatch;
1568     }
1569     uint endLooping = startLooping + batch;
1570 
1571     // move reserved tokens
1572     for (uint j = startLooping; j < endLooping; j++) {
1573       address reservedAddr = token.reservedTokensDestinations(j);
1574       if (!token.areTokensDistributedForAddress(reservedAddr)) {
1575         uint allocatedBonusInPercentage;
1576         uint allocatedBonusInTokens = token.getReservedTokens(reservedAddr);
1577         uint percentsOfTokensUnit = token.getReservedPercentageUnit(reservedAddr);
1578         uint percentsOfTokensDecimals = token.getReservedPercentageDecimals(reservedAddr);
1579 
1580         if (percentsOfTokensUnit > 0) {
1581           allocatedBonusInPercentage = tokensSold * percentsOfTokensUnit / 10**percentsOfTokensDecimals / 100;
1582           token.mint(reservedAddr, allocatedBonusInPercentage);
1583         }
1584 
1585         if (allocatedBonusInTokens > 0) {
1586           token.mint(reservedAddr, allocatedBonusInTokens);
1587         }
1588 
1589         token.finalizeReservedAddress(reservedAddr);
1590         distributedReservedTokensDestinationsLen++;
1591       }
1592     }
1593 
1594     if (distributedReservedTokensDestinationsLen == token.reservedTokensDestinationsLen()) {
1595       reservedTokensAreDistributed = true;
1596     }
1597   }
1598 
1599   /** Called once by crowdsale finalize() if the sale was success. */
1600   function finalizeCrowdsale() public {
1601     assert(msg.sender == address(crowdsale));
1602 
1603     if (token.reservedTokensDestinationsLen() > 0) {
1604       assert(reservedTokensAreDistributed);
1605     }
1606 
1607     token.releaseTokenTransfer();
1608   }
1609 
1610 }