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
15 
16 
17 /**
18  * Safe unsigned safe math.
19  *
20  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
21  *
22  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
23  *
24  * Maintained here until merged to mainline zeppelin-solidity.
25  *
26  */
27 library SafeMathLibExt {
28 
29   function times(uint a, uint b) returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function divides(uint a, uint b) returns (uint) {
36     assert(b > 0);
37     uint c = a / b;
38     assert(a == b * c + a % b);
39     return c;
40   }
41 
42   function minus(uint a, uint b) returns (uint) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function plus(uint a, uint b) returns (uint) {
48     uint c = a + b;
49     assert(c>=a);
50     return c;
51   }
52 
53 }
54 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
55 
56 
57 
58 
59 /**
60  * Math operations with safety checks
61  */
62 contract SafeMath {
63   function safeMul(uint a, uint b) internal returns (uint) {
64     uint c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function safeDiv(uint a, uint b) internal returns (uint) {
70     assert(b > 0);
71     uint c = a / b;
72     assert(a == b * c + a % b);
73     return c;
74   }
75 
76   function safeSub(uint a, uint b) internal returns (uint) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function safeAdd(uint a, uint b) internal returns (uint) {
82     uint c = a + b;
83     assert(c>=a && c>=b);
84     return c;
85   }
86 
87   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
88     return a >= b ? a : b;
89   }
90 
91   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
92     return a < b ? a : b;
93   }
94 
95   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
96     return a >= b ? a : b;
97   }
98 
99   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
100     return a < b ? a : b;
101   }
102 
103 }
104 
105 
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   function Ownable() {
124     owner = msg.sender;
125   }
126 
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address newOwner) onlyOwner public {
142     require(newOwner != address(0));
143     OwnershipTransferred(owner, newOwner);
144     owner = newOwner;
145   }
146 
147 }
148 
149 /*
150  * Haltable
151  *
152  * Abstract contract that allows children to implement an
153  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
154  *
155  *
156  * Originally envisioned in FirstBlood ICO contract.
157  */
158 contract Haltable is Ownable {
159   bool public halted;
160 
161   modifier stopInEmergency {
162     if (halted) throw;
163     _;
164   }
165 
166   modifier stopNonOwnersInEmergency {
167     if (halted && msg.sender != owner) throw;
168     _;
169   }
170 
171   modifier onlyInEmergency {
172     if (!halted) throw;
173     _;
174   }
175 
176   // called by the owner on emergency, triggers stopped state
177   function halt() external onlyOwner {
178     halted = true;
179   }
180 
181   // called by the owner on end of emergency, returns to normal state
182   function unhalt() external onlyOwner onlyInEmergency {
183     halted = false;
184   }
185 
186 }
187 
188 
189 
190 /**
191  * Interface for defining crowdsale pricing.
192  */
193 contract PricingStrategy {
194 
195   address public tier;
196 
197   /** Interface declaration. */
198   function isPricingStrategy() public constant returns (bool) {
199     return true;
200   }
201 
202   /** Self check if all references are correctly set.
203    *
204    * Checks that pricing strategy matches crowdsale parameters.
205    */
206   function isSane(address crowdsale) public constant returns (bool) {
207     return true;
208   }
209 
210   /**
211    * @dev Pricing tells if this is a presale purchase or not.
212      @param purchaser Address of the purchaser
213      @return False by default, true if a presale purchaser
214    */
215   function isPresalePurchase(address purchaser) public constant returns (bool) {
216     return false;
217   }
218 
219   /* How many weis one token costs */
220   function updateRate(uint newOneTokenInWei) public;
221 
222   /**
223    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
224    *
225    *
226    * @param value - What is the value of the transaction send in as wei
227    * @param tokensSold - how much tokens have been sold this far
228    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
229    * @param msgSender - who is the investor of this transaction
230    * @param decimals - how many decimal units the token has
231    * @return Amount of tokens the investor receives
232    */
233   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
234 }
235 
236 
237 /**
238  * Finalize agent defines what happens at the end of succeseful crowdsale.
239  *
240  * - Allocate tokens for founders, bounties and community
241  * - Make tokens transferable
242  * - etc.
243  */
244 contract FinalizeAgent {
245 
246   bool public reservedTokensAreDistributed = false;
247 
248   function isFinalizeAgent() public constant returns(bool) {
249     return true;
250   }
251 
252   /** Return true if we can run finalizeCrowdsale() properly.
253    *
254    * This is a safety check function that doesn't allow crowdsale to begin
255    * unless the finalizer has been set up properly.
256    */
257   function isSane() public constant returns (bool);
258 
259   function distributeReservedTokens(uint reservedTokensDistributionBatch);
260 
261   /** Called once by crowdsale finalize() if the sale was success. */
262   function finalizeCrowdsale();
263 
264 }
265 
266 
267 
268 
269 
270 
271 
272 
273 /**
274  * @title ERC20 interface
275  * @dev see https://github.com/ethereum/EIPs/issues/20
276  */
277 contract ERC20 is ERC20Basic {
278   function allowance(address owner, address spender) public constant returns (uint256);
279   function transferFrom(address from, address to, uint256 value) public returns (bool);
280   function approve(address spender, uint256 value) public returns (bool);
281   event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 
285 /**
286  * A token that defines fractional units as decimals.
287  */
288 contract FractionalERC20Ext is ERC20 {
289 
290   uint public decimals;
291   uint public minCap;
292 
293 }
294 
295 
296 
297 /**
298  * Abstract base contract for token sales.
299  *
300  * Handle
301  * - start and end dates
302  * - accepting investments
303  * - minimum funding goal and refund
304  * - various statistics during the crowdfund
305  * - different pricing strategies
306  * - different investment policies (require server side customer id, allow only whitelisted addresses)
307  *
308  */
309 contract CrowdsaleExt is Haltable {
310 
311   /* Max investment count when we are still allowed to change the multisig address */
312   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
313 
314   using SafeMathLibExt for uint;
315 
316   /* The token we are selling */
317   FractionalERC20Ext public token;
318 
319   /* How we are going to price our offering */
320   PricingStrategy public pricingStrategy;
321 
322   /* Post-success callback */
323   FinalizeAgent public finalizeAgent;
324 
325   /* name of the crowdsale tier */
326   string public name;
327 
328   /* tokens will be transfered from this address */
329   address public multisigWallet;
330 
331   /* if the funding goal is not reached, investors may withdraw their funds */
332   uint public minimumFundingGoal;
333 
334   /* the UNIX timestamp start date of the crowdsale */
335   uint public startsAt;
336 
337   /* the UNIX timestamp end date of the crowdsale */
338   uint public endsAt;
339 
340   /* the number of tokens already sold through this contract*/
341   uint public tokensSold = 0;
342 
343   /* How many wei of funding we have raised */
344   uint public weiRaised = 0;
345 
346   /* How many distinct addresses have invested */
347   uint public investorCount = 0;
348 
349   /* Has this crowdsale been finalized */
350   bool public finalized;
351 
352   bool public isWhiteListed;
353 
354   address[] public joinedCrowdsales;
355   uint8 public joinedCrowdsalesLen = 0;
356   uint8 public joinedCrowdsalesLenMax = 50;
357   struct JoinedCrowdsaleStatus {
358     bool isJoined;
359     uint8 position;
360   }
361   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
362 
363   /** How much ETH each address has invested to this crowdsale */
364   mapping (address => uint256) public investedAmountOf;
365 
366   /** How much tokens this crowdsale has credited for each investor address */
367   mapping (address => uint256) public tokenAmountOf;
368 
369   struct WhiteListData {
370     bool status;
371     uint minCap;
372     uint maxCap;
373   }
374 
375   //is crowdsale updatable
376   bool public isUpdatable;
377 
378   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
379   mapping (address => WhiteListData) public earlyParticipantWhitelist;
380 
381   /** List of whitelisted addresses */
382   address[] public whitelistedParticipants;
383 
384   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
385   uint public ownerTestValue;
386 
387   /** State machine
388    *
389    * - Preparing: All contract initialization calls and variables have not been set yet
390    * - Prefunding: We have not passed start time yet
391    * - Funding: Active crowdsale
392    * - Success: Minimum funding goal reached
393    * - Failure: Minimum funding goal not reached before ending time
394    * - Finalized: The finalized has been called and succesfully executed
395    */
396   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
397 
398   // A new investment was made
399   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
400 
401   // Address early participation whitelist status changed
402   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
403   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
404 
405   // Crowdsale start time has been changed
406   event StartsAtChanged(uint newStartsAt);
407 
408   // Crowdsale end time has been changed
409   event EndsAtChanged(uint newEndsAt);
410 
411   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
412 
413     owner = msg.sender;
414 
415     name = _name;
416 
417     token = FractionalERC20Ext(_token);
418 
419     setPricingStrategy(_pricingStrategy);
420 
421     multisigWallet = _multisigWallet;
422     if(multisigWallet == 0) {
423         throw;
424     }
425 
426     if(_start == 0) {
427         throw;
428     }
429 
430     startsAt = _start;
431 
432     if(_end == 0) {
433         throw;
434     }
435 
436     endsAt = _end;
437 
438     // Don't mess the dates
439     if(startsAt >= endsAt) {
440         throw;
441     }
442 
443     // Minimum funding goal can be zero
444     minimumFundingGoal = _minimumFundingGoal;
445 
446     isUpdatable = _isUpdatable;
447 
448     isWhiteListed = _isWhiteListed;
449   }
450 
451   /**
452    * Don't expect to just send in money and get tokens.
453    */
454   function() payable {
455     throw;
456   }
457 
458   /**
459    * Make an investment.
460    *
461    * Crowdsale must be running for one to invest.
462    * We must have not pressed the emergency brake.
463    *
464    * @param receiver The Ethereum address who receives the tokens
465    * @param customerId (optional) UUID v4 to track the successful payments on the server side
466    *
467    */
468   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
469 
470     // Determine if it's a good time to accept investment from this participant
471     if(getState() == State.PreFunding) {
472       // Are we whitelisted for early deposit
473       throw;
474     } else if(getState() == State.Funding) {
475       // Retail participants can only come in when the crowdsale is running
476       // pass
477       if(isWhiteListed) {
478         if(!earlyParticipantWhitelist[receiver].status) {
479           throw;
480         }
481       }
482     } else {
483       // Unwanted state
484       throw;
485     }
486 
487     uint weiAmount = msg.value;
488 
489     // Account presale sales separately, so that they do not count against pricing tranches
490     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
491 
492     if(tokenAmount == 0) {
493       // Dust transaction
494       throw;
495     }
496 
497     if(isWhiteListed) {
498       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
499         // tokenAmount < minCap for investor
500         throw;
501       }
502 
503       // Check that we did not bust the investor's cap
504       if (isBreakingInvestorCap(receiver, tokenAmount)) {
505         throw;
506       }
507 
508       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
509     } else {
510       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
511         throw;
512       }
513     }
514 
515     if(investedAmountOf[receiver] == 0) {
516        // A new investor
517        investorCount++;
518     }
519 
520     // Update investor
521     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
522     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
523 
524     // Update totals
525     weiRaised = weiRaised.plus(weiAmount);
526     tokensSold = tokensSold.plus(tokenAmount);
527 
528     // Check that we did not bust the cap
529     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
530       throw;
531     }
532 
533     assignTokens(receiver, tokenAmount);
534 
535     // Pocket the money
536     if(!multisigWallet.send(weiAmount)) throw;
537 
538     // Tell us invest was success
539     Invested(receiver, weiAmount, tokenAmount, customerId);
540   }
541 
542   /**
543    * Allow anonymous contributions to this crowdsale.
544    */
545   function invest(address addr) public payable {
546     investInternal(addr, 0);
547   }
548 
549   /**
550    * The basic entry point to participate the crowdsale process.
551    *
552    * Pay for funding, get invested tokens back in the sender address.
553    */
554   function buy() public payable {
555     invest(msg.sender);
556   }
557 
558   function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {
559     // Already finalized
560     if(finalized) {
561       throw;
562     }
563 
564     // Finalizing is optional. We only call it if we are given a finalizing agent.
565     if(address(finalizeAgent) != address(0)) {
566       finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
567     }
568   }
569 
570   function areReservedTokensDistributed() public constant returns (bool) {
571     return finalizeAgent.reservedTokensAreDistributed();
572   }
573 
574   function canDistributeReservedTokens() public constant returns(bool) {
575     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
576     if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;
577     return false;
578   }
579 
580   /**
581    * Finalize a succcesful crowdsale.
582    *
583    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
584    */
585   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
586 
587     // Already finalized
588     if(finalized) {
589       throw;
590     }
591 
592     // Finalizing is optional. We only call it if we are given a finalizing agent.
593     if(address(finalizeAgent) != address(0)) {
594       finalizeAgent.finalizeCrowdsale();
595     }
596 
597     finalized = true;
598   }
599 
600   /**
601    * Allow to (re)set finalize agent.
602    *
603    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
604    */
605   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
606     assert(address(addr) != address(0));
607     assert(address(finalizeAgent) == address(0));
608     finalizeAgent = addr;
609 
610     // Don't allow setting bad agent
611     if(!finalizeAgent.isFinalizeAgent()) {
612       throw;
613     }
614   }
615 
616   /**
617    * Allow addresses to do early participation.
618    */
619   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
620     if (!isWhiteListed) throw;
621     assert(addr != address(0));
622     assert(maxCap > 0);
623     assert(minCap <= maxCap);
624     assert(now <= endsAt);
625 
626     if (!isAddressWhitelisted(addr)) {
627       whitelistedParticipants.push(addr);
628       Whitelisted(addr, status, minCap, maxCap);
629     } else {
630       WhitelistItemChanged(addr, status, minCap, maxCap);
631     }
632 
633     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
634   }
635 
636   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
637     if (!isWhiteListed) throw;
638     assert(now <= endsAt);
639     assert(addrs.length == statuses.length);
640     assert(statuses.length == minCaps.length);
641     assert(minCaps.length == maxCaps.length);
642     for (uint iterator = 0; iterator < addrs.length; iterator++) {
643       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
644     }
645   }
646 
647   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
648     if (!isWhiteListed) throw;
649     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
650 
651     uint8 tierPosition = getTierPosition(this);
652 
653     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
654       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
655       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
656     }
657   }
658 
659   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
660     if (!isWhiteListed) throw;
661     assert(addr != address(0));
662     assert(now <= endsAt);
663     assert(isTierJoined(msg.sender));
664     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
665     //if (addr != msg.sender && contractAddr != msg.sender) throw;
666     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
667     newMaxCap = newMaxCap.minus(tokensBought);
668     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
669   }
670 
671   function isAddressWhitelisted(address addr) public constant returns(bool) {
672     for (uint i = 0; i < whitelistedParticipants.length; i++) {
673       if (whitelistedParticipants[i] == addr) {
674         return true;
675         break;
676       }
677     }
678 
679     return false;
680   }
681 
682   function whitelistedParticipantsLength() public constant returns (uint) {
683     return whitelistedParticipants.length;
684   }
685 
686   function isTierJoined(address addr) public constant returns(bool) {
687     return joinedCrowdsaleState[addr].isJoined;
688   }
689 
690   function getTierPosition(address addr) public constant returns(uint8) {
691     return joinedCrowdsaleState[addr].position;
692   }
693 
694   function getLastTier() public constant returns(address) {
695     if (joinedCrowdsalesLen > 0)
696       return joinedCrowdsales[joinedCrowdsalesLen - 1];
697     else
698       return address(0);
699   }
700 
701   function setJoinedCrowdsales(address addr) private onlyOwner {
702     assert(addr != address(0));
703     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
704     assert(!isTierJoined(addr));
705     joinedCrowdsales.push(addr);
706     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
707       isJoined: true,
708       position: joinedCrowdsalesLen
709     });
710     joinedCrowdsalesLen++;
711   }
712 
713   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
714     assert(addrs.length > 0);
715     assert(joinedCrowdsalesLen == 0);
716     assert(addrs.length <= joinedCrowdsalesLenMax);
717     for (uint8 iter = 0; iter < addrs.length; iter++) {
718       setJoinedCrowdsales(addrs[iter]);
719     }
720   }
721 
722   function setStartsAt(uint time) onlyOwner {
723     assert(!finalized);
724     assert(isUpdatable);
725     assert(now <= time); // Don't change past
726     assert(time <= endsAt);
727     assert(now <= startsAt);
728 
729     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
730     if (lastTierCntrct.finalized()) throw;
731 
732     uint8 tierPosition = getTierPosition(this);
733 
734     //start time should be greater then end time of previous tiers
735     for (uint8 j = 0; j < tierPosition; j++) {
736       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
737       assert(time >= crowdsale.endsAt());
738     }
739 
740     startsAt = time;
741     StartsAtChanged(startsAt);
742   }
743 
744   /**
745    * Allow crowdsale owner to close early or extend the crowdsale.
746    *
747    * This is useful e.g. for a manual soft cap implementation:
748    * - after X amount is reached determine manual closing
749    *
750    * This may put the crowdsale to an invalid state,
751    * but we trust owners know what they are doing.
752    *
753    */
754   function setEndsAt(uint time) public onlyOwner {
755     assert(!finalized);
756     assert(isUpdatable);
757     assert(now <= time);// Don't change past
758     assert(startsAt <= time);
759     assert(now <= endsAt);
760 
761     CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
762     if (lastTierCntrct.finalized()) throw;
763 
764 
765     uint8 tierPosition = getTierPosition(this);
766 
767     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
768       CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
769       assert(time <= crowdsale.startsAt());
770     }
771 
772     endsAt = time;
773     EndsAtChanged(endsAt);
774   }
775 
776   /**
777    * Allow to (re)set pricing strategy.
778    *
779    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
780    */
781   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
782     assert(address(_pricingStrategy) != address(0));
783     assert(address(pricingStrategy) == address(0));
784     pricingStrategy = _pricingStrategy;
785 
786     // Don't allow setting bad agent
787     if(!pricingStrategy.isPricingStrategy()) {
788       throw;
789     }
790   }
791 
792   /**
793    * Allow to change the team multisig address in the case of emergency.
794    *
795    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
796    * (we have done only few test transactions). After the crowdsale is going
797    * then multisig address stays locked for the safety reasons.
798    */
799   function setMultisig(address addr) public onlyOwner {
800 
801     // Change
802     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
803       throw;
804     }
805 
806     multisigWallet = addr;
807   }
808 
809   /**
810    * @return true if the crowdsale has raised enough money to be a successful.
811    */
812   function isMinimumGoalReached() public constant returns (bool reached) {
813     return weiRaised >= minimumFundingGoal;
814   }
815 
816   /**
817    * Check if the contract relationship looks good.
818    */
819   function isFinalizerSane() public constant returns (bool sane) {
820     return finalizeAgent.isSane();
821   }
822 
823   /**
824    * Check if the contract relationship looks good.
825    */
826   function isPricingSane() public constant returns (bool sane) {
827     return pricingStrategy.isSane(address(this));
828   }
829 
830   /**
831    * Crowdfund state machine management.
832    *
833    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
834    */
835   function getState() public constant returns (State) {
836     if(finalized) return State.Finalized;
837     else if (address(finalizeAgent) == 0) return State.Preparing;
838     else if (!finalizeAgent.isSane()) return State.Preparing;
839     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
840     else if (block.timestamp < startsAt) return State.PreFunding;
841     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
842     else if (isMinimumGoalReached()) return State.Success;
843     else return State.Failure;
844   }
845 
846   /** Interface marker. */
847   function isCrowdsale() public constant returns (bool) {
848     return true;
849   }
850 
851   //
852   // Modifiers
853   //
854 
855   /** Modified allowing execution only if the crowdsale is currently running.  */
856   modifier inState(State state) {
857     if(getState() != state) throw;
858     _;
859   }
860 
861 
862   //
863   // Abstract functions
864   //
865 
866   /**
867    * Check if the current invested breaks our cap rules.
868    *
869    *
870    * The child contract must define their own cap setting rules.
871    * We allow a lot of flexibility through different capping strategies (ETH, token count)
872    * Called from invest().
873    *
874    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
875    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
876    * @param weiRaisedTotal What would be our total raised balance after this transaction
877    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
878    *
879    * @return true if taking this investment would break our cap rules
880    */
881   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
882 
883   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
884 
885   /**
886    * Check if the current crowdsale is full and we can no longer sell any tokens.
887    */
888   function isCrowdsaleFull() public constant returns (bool);
889 
890   /**
891    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
892    */
893   function assignTokens(address receiver, uint tokenAmount) private;
894 }
895 
896 /**
897  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
898  *
899  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
900  */
901 
902 
903 
904 /**
905  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
906  *
907  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
908  */
909 
910 
911 
912 
913 
914 
915 
916 
917 /**
918  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
919  *
920  * Based on code by FirstBlood:
921  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
922  */
923 contract StandardToken is ERC20, SafeMath {
924 
925   /* Token supply got increased and a new owner received these tokens */
926   event Minted(address receiver, uint amount);
927 
928   /* Actual balances of token holders */
929   mapping(address => uint) balances;
930 
931   /* approve() allowances */
932   mapping (address => mapping (address => uint)) allowed;
933 
934   /* Interface declaration */
935   function isToken() public constant returns (bool weAre) {
936     return true;
937   }
938 
939   function transfer(address _to, uint _value) returns (bool success) {
940     balances[msg.sender] = safeSub(balances[msg.sender], _value);
941     balances[_to] = safeAdd(balances[_to], _value);
942     Transfer(msg.sender, _to, _value);
943     return true;
944   }
945 
946   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
947     uint _allowance = allowed[_from][msg.sender];
948 
949     balances[_to] = safeAdd(balances[_to], _value);
950     balances[_from] = safeSub(balances[_from], _value);
951     allowed[_from][msg.sender] = safeSub(_allowance, _value);
952     Transfer(_from, _to, _value);
953     return true;
954   }
955 
956   function balanceOf(address _owner) constant returns (uint balance) {
957     return balances[_owner];
958   }
959 
960   function approve(address _spender, uint _value) returns (bool success) {
961 
962     // To change the approve amount you first have to reduce the addresses`
963     //  allowance to zero by calling `approve(_spender, 0)` if it is not
964     //  already 0 to mitigate the race condition described here:
965     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
966     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
967 
968     allowed[msg.sender][_spender] = _value;
969     Approval(msg.sender, _spender, _value);
970     return true;
971   }
972 
973   function allowance(address _owner, address _spender) constant returns (uint remaining) {
974     return allowed[_owner][_spender];
975   }
976 
977 }
978 
979 /**
980  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
981  *
982  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
983  */
984 
985 
986 
987 
988 
989 /**
990  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
991  *
992  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
993  */
994 
995 
996 
997 /**
998  * Upgrade agent interface inspired by Lunyr.
999  *
1000  * Upgrade agent transfers tokens to a new contract.
1001  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
1002  */
1003 contract UpgradeAgent {
1004 
1005   uint public originalSupply;
1006 
1007   /** Interface marker */
1008   function isUpgradeAgent() public constant returns (bool) {
1009     return true;
1010   }
1011 
1012   function upgradeFrom(address _from, uint256 _value) public;
1013 
1014 }
1015 
1016 
1017 /**
1018  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
1019  *
1020  * First envisioned by Golem and Lunyr projects.
1021  */
1022 contract UpgradeableToken is StandardToken {
1023 
1024   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
1025   address public upgradeMaster;
1026 
1027   /** The next contract where the tokens will be migrated. */
1028   UpgradeAgent public upgradeAgent;
1029 
1030   /** How many tokens we have upgraded by now. */
1031   uint256 public totalUpgraded;
1032 
1033   /**
1034    * Upgrade states.
1035    *
1036    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
1037    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
1038    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
1039    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
1040    *
1041    */
1042   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
1043 
1044   /**
1045    * Somebody has upgraded some of his tokens.
1046    */
1047   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1048 
1049   /**
1050    * New upgrade agent available.
1051    */
1052   event UpgradeAgentSet(address agent);
1053 
1054   /**
1055    * Do not allow construction without upgrade master set.
1056    */
1057   function UpgradeableToken(address _upgradeMaster) {
1058     upgradeMaster = _upgradeMaster;
1059   }
1060 
1061   /**
1062    * Allow the token holder to upgrade some of their tokens to a new contract.
1063    */
1064   function upgrade(uint256 value) public {
1065 
1066       UpgradeState state = getUpgradeState();
1067       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
1068         // Called in a bad state
1069         throw;
1070       }
1071 
1072       // Validate input value.
1073       if (value == 0) throw;
1074 
1075       balances[msg.sender] = safeSub(balances[msg.sender], value);
1076 
1077       // Take tokens out from circulation
1078       totalSupply = safeSub(totalSupply, value);
1079       totalUpgraded = safeAdd(totalUpgraded, value);
1080 
1081       // Upgrade agent reissues the tokens
1082       upgradeAgent.upgradeFrom(msg.sender, value);
1083       Upgrade(msg.sender, upgradeAgent, value);
1084   }
1085 
1086   /**
1087    * Set an upgrade agent that handles
1088    */
1089   function setUpgradeAgent(address agent) external {
1090 
1091       if(!canUpgrade()) {
1092         // The token is not yet in a state that we could think upgrading
1093         throw;
1094       }
1095 
1096       if (agent == 0x0) throw;
1097       // Only a master can designate the next agent
1098       if (msg.sender != upgradeMaster) throw;
1099       // Upgrade has already begun for an agent
1100       if (getUpgradeState() == UpgradeState.Upgrading) throw;
1101 
1102       upgradeAgent = UpgradeAgent(agent);
1103 
1104       // Bad interface
1105       if(!upgradeAgent.isUpgradeAgent()) throw;
1106       // Make sure that token supplies match in source and target
1107       if (upgradeAgent.originalSupply() != totalSupply) throw;
1108 
1109       UpgradeAgentSet(upgradeAgent);
1110   }
1111 
1112   /**
1113    * Get the state of the token upgrade.
1114    */
1115   function getUpgradeState() public constant returns(UpgradeState) {
1116     if(!canUpgrade()) return UpgradeState.NotAllowed;
1117     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
1118     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1119     else return UpgradeState.Upgrading;
1120   }
1121 
1122   /**
1123    * Change the upgrade master.
1124    *
1125    * This allows us to set a new owner for the upgrade mechanism.
1126    */
1127   function setUpgradeMaster(address master) public {
1128       if (master == 0x0) throw;
1129       if (msg.sender != upgradeMaster) throw;
1130       upgradeMaster = master;
1131   }
1132 
1133   /**
1134    * Child contract can enable to provide the condition when the upgrade can begun.
1135    */
1136   function canUpgrade() public constant returns(bool) {
1137      return true;
1138   }
1139 
1140 }
1141 
1142 /**
1143  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1144  *
1145  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1146  */
1147 
1148 
1149 
1150 
1151 
1152 
1153 
1154 /**
1155  * Define interface for releasing the token transfer after a successful crowdsale.
1156  */
1157 contract ReleasableToken is ERC20, Ownable {
1158 
1159   /* The finalizer contract that allows unlift the transfer limits on this token */
1160   address public releaseAgent;
1161 
1162   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
1163   bool public released = false;
1164 
1165   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
1166   mapping (address => bool) public transferAgents;
1167 
1168   /**
1169    * Limit token transfer until the crowdsale is over.
1170    *
1171    */
1172   modifier canTransfer(address _sender) {
1173 
1174     if(!released) {
1175         if(!transferAgents[_sender]) {
1176             throw;
1177         }
1178     }
1179 
1180     _;
1181   }
1182 
1183   /**
1184    * Set the contract that can call release and make the token transferable.
1185    *
1186    * Design choice. Allow reset the release agent to fix fat finger mistakes.
1187    */
1188   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
1189 
1190     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
1191     releaseAgent = addr;
1192   }
1193 
1194   /**
1195    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
1196    */
1197   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
1198     transferAgents[addr] = state;
1199   }
1200 
1201   /**
1202    * One way function to release the tokens to the wild.
1203    *
1204    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
1205    */
1206   function releaseTokenTransfer() public onlyReleaseAgent {
1207     released = true;
1208   }
1209 
1210   /** The function can be called only before or after the tokens have been releasesd */
1211   modifier inReleaseState(bool releaseState) {
1212     if(releaseState != released) {
1213         throw;
1214     }
1215     _;
1216   }
1217 
1218   /** The function can be called only by a whitelisted release agent. */
1219   modifier onlyReleaseAgent() {
1220     if(msg.sender != releaseAgent) {
1221         throw;
1222     }
1223     _;
1224   }
1225 
1226   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
1227     // Call StandardToken.transfer()
1228    return super.transfer(_to, _value);
1229   }
1230 
1231   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
1232     // Call StandardToken.transferForm()
1233     return super.transferFrom(_from, _to, _value);
1234   }
1235 
1236 }
1237 
1238 /**
1239  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1240  *
1241  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1242  */
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 /**
1252  * A token that can increase its supply by another contract.
1253  *
1254  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1255  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1256  *
1257  */
1258 contract MintableTokenExt is StandardToken, Ownable {
1259 
1260   using SafeMathLibExt for uint;
1261 
1262   bool public mintingFinished = false;
1263 
1264   /** List of agents that are allowed to create new tokens */
1265   mapping (address => bool) public mintAgents;
1266 
1267   event MintingAgentChanged(address addr, bool state  );
1268 
1269   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1270   * For example, for reserved tokens in percents 2.54%
1271   * inPercentageUnit = 254
1272   * inPercentageDecimals = 2
1273   */
1274   struct ReservedTokensData {
1275     uint inTokens;
1276     uint inPercentageUnit;
1277     uint inPercentageDecimals;
1278     bool isReserved;
1279     bool isDistributed;
1280   }
1281 
1282   mapping (address => ReservedTokensData) public reservedTokensList;
1283   address[] public reservedTokensDestinations;
1284   uint public reservedTokensDestinationsLen = 0;
1285   bool reservedTokensDestinationsAreSet = false;
1286 
1287   modifier onlyMintAgent() {
1288     // Only crowdsale contracts are allowed to mint new tokens
1289     if(!mintAgents[msg.sender]) {
1290         throw;
1291     }
1292     _;
1293   }
1294 
1295   /** Make sure we are not done yet. */
1296   modifier canMint() {
1297     if(mintingFinished) throw;
1298     _;
1299   }
1300 
1301   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1302     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1303     reservedTokensData.isDistributed = true;
1304   }
1305 
1306   function isAddressReserved(address addr) public constant returns (bool isReserved) {
1307     return reservedTokensList[addr].isReserved;
1308   }
1309 
1310   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
1311     return reservedTokensList[addr].isDistributed;
1312   }
1313 
1314   function getReservedTokens(address addr) public constant returns (uint inTokens) {
1315     return reservedTokensList[addr].inTokens;
1316   }
1317 
1318   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
1319     return reservedTokensList[addr].inPercentageUnit;
1320   }
1321 
1322   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
1323     return reservedTokensList[addr].inPercentageDecimals;
1324   }
1325 
1326   function setReservedTokensListMultiple(
1327     address[] addrs, 
1328     uint[] inTokens, 
1329     uint[] inPercentageUnit, 
1330     uint[] inPercentageDecimals
1331   ) public canMint onlyOwner {
1332     assert(!reservedTokensDestinationsAreSet);
1333     assert(addrs.length == inTokens.length);
1334     assert(inTokens.length == inPercentageUnit.length);
1335     assert(inPercentageUnit.length == inPercentageDecimals.length);
1336     for (uint iterator = 0; iterator < addrs.length; iterator++) {
1337       if (addrs[iterator] != address(0)) {
1338         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
1339       }
1340     }
1341     reservedTokensDestinationsAreSet = true;
1342   }
1343 
1344   /**
1345    * Create new tokens and allocate them to an address..
1346    *
1347    * Only callably by a crowdsale contract (mint agent).
1348    */
1349   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1350     totalSupply = totalSupply.plus(amount);
1351     balances[receiver] = balances[receiver].plus(amount);
1352 
1353     // This will make the mint transaction apper in EtherScan.io
1354     // We can remove this after there is a standardized minting event
1355     Transfer(0, receiver, amount);
1356   }
1357 
1358   /**
1359    * Owner can allow a crowdsale contract to mint new tokens.
1360    */
1361   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1362     mintAgents[addr] = state;
1363     MintingAgentChanged(addr, state);
1364   }
1365 
1366   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
1367     assert(addr != address(0));
1368     if (!isAddressReserved(addr)) {
1369       reservedTokensDestinations.push(addr);
1370       reservedTokensDestinationsLen++;
1371     }
1372 
1373     reservedTokensList[addr] = ReservedTokensData({
1374       inTokens: inTokens, 
1375       inPercentageUnit: inPercentageUnit, 
1376       inPercentageDecimals: inPercentageDecimals,
1377       isReserved: true,
1378       isDistributed: false
1379     });
1380   }
1381 }
1382 
1383 
1384 /**
1385  * A crowdsaled token.
1386  *
1387  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1388  *
1389  * - The token transfer() is disabled until the crowdsale is over
1390  * - The token contract gives an opt-in upgrade path to a new contract
1391  * - The same token can be part of several crowdsales through approve() mechanism
1392  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1393  *
1394  */
1395 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
1396 
1397   /** Name and symbol were updated. */
1398   event UpdatedTokenInformation(string newName, string newSymbol);
1399 
1400   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1401 
1402   string public name;
1403 
1404   string public symbol;
1405 
1406   uint public decimals;
1407 
1408   /* Minimum ammount of tokens every buyer can buy. */
1409   uint public minCap;
1410 
1411   /**
1412    * Construct the token.
1413    *
1414    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1415    *
1416    * @param _name Token name
1417    * @param _symbol Token symbol - should be all caps
1418    * @param _initialSupply How many tokens we start with
1419    * @param _decimals Number of decimal places
1420    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
1421    */
1422   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
1423     UpgradeableToken(msg.sender) {
1424 
1425     // Create any address, can be transferred
1426     // to team multisig via changeOwner(),
1427     // also remember to call setUpgradeMaster()
1428     owner = msg.sender;
1429 
1430     name = _name;
1431     symbol = _symbol;
1432 
1433     totalSupply = _initialSupply;
1434 
1435     decimals = _decimals;
1436 
1437     minCap = _globalMinCap;
1438 
1439     // Create initially all balance on the team multisig
1440     balances[owner] = totalSupply;
1441 
1442     if(totalSupply > 0) {
1443       Minted(owner, totalSupply);
1444     }
1445 
1446     // No more new supply allowed after the token creation
1447     if(!_mintable) {
1448       mintingFinished = true;
1449       if(totalSupply == 0) {
1450         throw; // Cannot create a token without supply and no minting
1451       }
1452     }
1453   }
1454 
1455   /**
1456    * When token is released to be transferable, enforce no new tokens can be created.
1457    */
1458   function releaseTokenTransfer() public onlyReleaseAgent {
1459     mintingFinished = true;
1460     super.releaseTokenTransfer();
1461   }
1462 
1463   /**
1464    * Allow upgrade agent functionality kick in only if the crowdsale was success.
1465    */
1466   function canUpgrade() public constant returns(bool) {
1467     return released && super.canUpgrade();
1468   }
1469 
1470   /**
1471    * Owner can update token information here.
1472    *
1473    * It is often useful to conceal the actual token association, until
1474    * the token operations, like central issuance or reissuance have been completed.
1475    *
1476    * This function allows the token owner to rename the token after the operations
1477    * have been completed and then point the audience to use the token contract.
1478    */
1479   function setTokenInformation(string _name, string _symbol) onlyOwner {
1480     name = _name;
1481     symbol = _symbol;
1482 
1483     UpdatedTokenInformation(name, symbol);
1484   }
1485 
1486   /**
1487    * Claim tokens that were accidentally sent to this contract.
1488    *
1489    * @param _token The address of the token contract that you want to recover.
1490    */
1491   function claimTokens(address _token) public onlyOwner {
1492     require(_token != address(0));
1493 
1494     ERC20 token = ERC20(_token);
1495     uint balance = token.balanceOf(this);
1496     token.transfer(owner, balance);
1497 
1498     ClaimedTokens(_token, owner, balance);
1499   }
1500 
1501 }
1502 
1503 
1504 /**
1505  * The default behavior for the crowdsale end.
1506  *
1507  * Unlock tokens.
1508  */
1509 contract ReservedTokensFinalizeAgent is FinalizeAgent {
1510   using SafeMathLibExt for uint;
1511   CrowdsaleTokenExt public token;
1512   CrowdsaleExt public crowdsale;
1513 
1514   uint public distributedReservedTokensDestinationsLen = 0;
1515 
1516   function ReservedTokensFinalizeAgent(CrowdsaleTokenExt _token, CrowdsaleExt _crowdsale) public {
1517     token = _token;
1518     crowdsale = _crowdsale;
1519   }
1520 
1521   /** Check that we can release the token */
1522   function isSane() public constant returns (bool) {
1523     return (token.releaseAgent() == address(this));
1524   }
1525 
1526   //distributes reserved tokens. Should be called before finalization
1527   function distributeReservedTokens(uint reservedTokensDistributionBatch) public {
1528     assert(msg.sender == address(crowdsale));
1529 
1530     assert(reservedTokensDistributionBatch > 0);
1531     assert(!reservedTokensAreDistributed);
1532     assert(distributedReservedTokensDestinationsLen < token.reservedTokensDestinationsLen());
1533 
1534 
1535     // How many % of tokens the founders and others get
1536     uint tokensSold = 0;
1537     for (uint8 i = 0; i < crowdsale.joinedCrowdsalesLen(); i++) {
1538       CrowdsaleExt tier = CrowdsaleExt(crowdsale.joinedCrowdsales(i));
1539       tokensSold = tokensSold.plus(tier.tokensSold());
1540     }
1541 
1542     uint startLooping = distributedReservedTokensDestinationsLen;
1543     uint batch = token.reservedTokensDestinationsLen().minus(distributedReservedTokensDestinationsLen);
1544     if (batch >= reservedTokensDistributionBatch) {
1545       batch = reservedTokensDistributionBatch;
1546     }
1547     uint endLooping = startLooping + batch;
1548 
1549     // move reserved tokens
1550     for (uint j = startLooping; j < endLooping; j++) {
1551       address reservedAddr = token.reservedTokensDestinations(j);
1552       if (!token.areTokensDistributedForAddress(reservedAddr)) {
1553         uint allocatedBonusInPercentage;
1554         uint allocatedBonusInTokens = token.getReservedTokens(reservedAddr);
1555         uint percentsOfTokensUnit = token.getReservedPercentageUnit(reservedAddr);
1556         uint percentsOfTokensDecimals = token.getReservedPercentageDecimals(reservedAddr);
1557 
1558         if (percentsOfTokensUnit > 0) {
1559           allocatedBonusInPercentage = tokensSold * percentsOfTokensUnit / 10**percentsOfTokensDecimals / 100;
1560           token.mint(reservedAddr, allocatedBonusInPercentage);
1561         }
1562 
1563         if (allocatedBonusInTokens > 0) {
1564           token.mint(reservedAddr, allocatedBonusInTokens);
1565         }
1566 
1567         token.finalizeReservedAddress(reservedAddr);
1568         distributedReservedTokensDestinationsLen++;
1569       }
1570     }
1571 
1572     if (distributedReservedTokensDestinationsLen == token.reservedTokensDestinationsLen()) {
1573       reservedTokensAreDistributed = true;
1574     }
1575   }
1576 
1577   /** Called once by crowdsale finalize() if the sale was success. */
1578   function finalizeCrowdsale() public {
1579     assert(msg.sender == address(crowdsale));
1580 
1581     if (token.reservedTokensDestinationsLen() > 0) {
1582       assert(reservedTokensAreDistributed);
1583     }
1584 
1585     token.releaseTokenTransfer();
1586   }
1587 
1588 }