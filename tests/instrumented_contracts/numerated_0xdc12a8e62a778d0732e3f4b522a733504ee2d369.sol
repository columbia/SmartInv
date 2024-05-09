1 // Created using Token Wizard by Ludos Protocol 
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
233 
234 
235 
236 
237 
238 
239 /**
240  * @title ERC20 interface
241  * @dev see https://github.com/ethereum/EIPs/issues/20
242  */
243 contract ERC20 is ERC20Basic {
244   function allowance(address owner, address spender) public constant returns (uint256);
245   function transferFrom(address from, address to, uint256 value) public returns (bool);
246   function approve(address spender, uint256 value) public returns (bool);
247   event Approval(address indexed owner, address indexed spender, uint256 value);
248 }
249 
250 
251 /**
252  * A token that defines fractional units as decimals.
253  */
254 contract ERC20Ext is ERC20 {
255 
256   uint public decimals;
257   string public name;
258   string public symbol;
259 
260 }
261 
262 
263 
264 /**
265  * Abstract base contract for token sales.
266  *
267  * Handle
268  * - start and end dates
269  * - accepting investments
270  * - minimum funding goal and refund
271  * - various statistics during the crowdfund
272  * - different pricing strategies
273  * - different investment policies (require server side customer id, allow only whitelisted addresses)
274  *
275  */
276 contract CrowdsaleExt2 is Haltable {
277 
278   /* Max investment count when we are still allowed to change the multisig address */
279   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
280 
281   using SafeMathLibExt for uint;
282 
283   /* The token we are selling */
284   ERC20Ext public token;
285 
286   /* How we are going to price our offering */
287   PricingStrategy public pricingStrategy;
288 
289   /* name of the crowdsale tier */
290   string public name;
291 
292   /* tokens will be transfered from this address */
293   address public multisigWallet;
294 
295   /* if the funding goal is not reached, investors may withdraw their funds */
296   uint public minimumFundingGoal;
297 
298   /* the UNIX timestamp start date of the crowdsale */
299   uint public startsAt;
300 
301   /* the UNIX timestamp end date of the crowdsale */
302   uint public endsAt;
303 
304   /* the number of tokens already sold through this contract*/
305   uint public tokensSold = 0;
306 
307   /* How many wei of funding we have raised */
308   uint public weiRaised = 0;
309 
310   /* How many distinct addresses have invested */
311   uint public investorCount = 0;
312 
313   /* Has this crowdsale been finalized */
314   bool public finalized;
315 
316   bool public isWhiteListed;
317 
318   address[] public joinedCrowdsales;
319   uint8 public joinedCrowdsalesLen = 0;
320   uint8 public joinedCrowdsalesLenMax = 50;
321   struct JoinedCrowdsaleStatus {
322     bool isJoined;
323     uint8 position;
324   }
325   mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;
326 
327   /** How much ETH each address has invested to this crowdsale */
328   mapping (address => uint256) public investedAmountOf;
329 
330   /** How much tokens this crowdsale has credited for each investor address */
331   mapping (address => uint256) public tokenAmountOf;
332 
333   struct WhiteListData {
334     bool status;
335     uint minCap;
336     uint maxCap;
337   }
338 
339   //is crowdsale updatable
340   bool public isUpdatable;
341 
342   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
343   mapping (address => WhiteListData) public earlyParticipantWhitelist;
344 
345   /** List of whitelisted addresses */
346   address[] public whitelistedParticipants;
347 
348   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
349   uint public ownerTestValue;
350 
351   /** State machine
352    *
353    * - Preparing: All contract initialization calls and variables have not been set yet
354    * - Prefunding: We have not passed start time yet
355    * - Funding: Active crowdsale
356    * - Success: Minimum funding goal reached
357    * - Failure: Minimum funding goal not reached before ending time
358    * - Finalized: The finalized has been called and succesfully executed
359    */
360   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}
361 
362   // A new investment was made
363   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
364 
365   // Address early participation whitelist status changed
366   event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
367   event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
368 
369   // Crowdsale start time has been changed
370   event StartsAtChanged(uint newStartsAt);
371 
372   // Crowdsale end time has been changed
373   event EndsAtChanged(uint newEndsAt);
374 
375   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
376 
377   function CrowdsaleExt2(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
378 
379     owner = msg.sender;
380 
381     name = _name;
382 
383     token = ERC20Ext(_token);
384 
385     setPricingStrategy(_pricingStrategy);
386 
387     multisigWallet = _multisigWallet;
388     if(multisigWallet == 0) {
389         throw;
390     }
391 
392     if(_start == 0) {
393         throw;
394     }
395 
396     startsAt = _start;
397 
398     if(_end == 0) {
399         throw;
400     }
401 
402     endsAt = _end;
403 
404     // Don't mess the dates
405     if(startsAt >= endsAt) {
406         throw;
407     }
408 
409     // Minimum funding goal can be zero
410     minimumFundingGoal = _minimumFundingGoal;
411 
412     isUpdatable = _isUpdatable;
413 
414     isWhiteListed = _isWhiteListed;
415   }
416 
417   /**
418    * Don't expect to just send in money and get tokens.
419    */
420   function() payable {
421     throw;
422   }
423 
424   /**
425    * Make an investment.
426    *
427    * Crowdsale must be running for one to invest.
428    * We must have not pressed the emergency brake.
429    *
430    * @param receiver The Ethereum address who receives the tokens
431    * @param customerId (optional) UUID v4 to track the successful payments on the server side
432    *
433    */
434   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
435 
436     // Determine if it's a good time to accept investment from this participant
437     if(getState() == State.PreFunding) {
438       // Are we whitelisted for early deposit
439       throw;
440     } else if(getState() == State.Funding) {
441       // Retail participants can only come in when the crowdsale is running
442       // pass
443       if(isWhiteListed) {
444         if(!earlyParticipantWhitelist[receiver].status) {
445           throw;
446         }
447       }
448     } else {
449       // Unwanted state
450       throw;
451     }
452 
453     uint weiAmount = msg.value;
454 
455     // Account presale sales separately, so that they do not count against pricing tranches
456     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
457 
458     if(tokenAmount == 0) {
459       // Dust transaction
460       throw;
461     }
462 
463     if(isWhiteListed) {
464       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
465         // tokenAmount < minCap for investor
466         throw;
467       }
468 
469       // Check that we did not bust the investor's cap
470       if (isBreakingInvestorCap(receiver, tokenAmount)) {
471         throw;
472       }
473 
474       updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);
475     } else {
476       // if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
477       //   throw;
478       // }
479     }
480 
481     if(investedAmountOf[receiver] == 0) {
482        // A new investor
483        investorCount++;
484     }
485 
486     // Update investor
487     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
488     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
489 
490     // Update totals
491     weiRaised = weiRaised.plus(weiAmount);
492     tokensSold = tokensSold.plus(tokenAmount);
493 
494     // Check that we did not bust the cap
495     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
496       throw;
497     }
498 
499     assignTokens(receiver, tokenAmount);
500 
501     // Pocket the money
502     if(!multisigWallet.send(weiAmount)) throw;
503 
504     // Tell us invest was success
505     Invested(receiver, weiAmount, tokenAmount, customerId);
506   }
507 
508   /**
509    * Allow anonymous contributions to this crowdsale.
510    */
511   function invest(address addr) public payable {
512     investInternal(addr, 0);
513   }
514 
515   /**
516    * The basic entry point to participate the crowdsale process.
517    *
518    * Pay for funding, get invested tokens back in the sender address.
519    */
520   function buy() public payable {
521     invest(msg.sender);
522   }
523 
524   /**
525    * Finalize a succcesful crowdsale.
526    *
527    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
528    */
529   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
530 
531     // Already finalized
532     if(finalized) {
533       throw;
534     }
535 
536     finalized = true;
537   }
538 
539   /**
540    * Allow addresses to do early participation.
541    */
542   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
543     if (!isWhiteListed) throw;
544     assert(addr != address(0));
545     assert(maxCap > 0);
546     assert(minCap <= maxCap);
547     assert(now <= endsAt);
548 
549     if (!isAddressWhitelisted(addr)) {
550       whitelistedParticipants.push(addr);
551       Whitelisted(addr, status, minCap, maxCap);
552     } else {
553       WhitelistItemChanged(addr, status, minCap, maxCap);
554     }
555 
556     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
557   }
558 
559   function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {
560     if (!isWhiteListed) throw;
561     assert(now <= endsAt);
562     assert(addrs.length == statuses.length);
563     assert(statuses.length == minCaps.length);
564     assert(minCaps.length == maxCaps.length);
565     for (uint iterator = 0; iterator < addrs.length; iterator++) {
566       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
567     }
568   }
569 
570   function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {
571     if (!isWhiteListed) throw;
572     if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;
573 
574     uint8 tierPosition = getTierPosition(this);
575 
576     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
577       CrowdsaleExt2 crowdsale = CrowdsaleExt2(joinedCrowdsales[j]);
578       crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);
579     }
580   }
581 
582   function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {
583     if (!isWhiteListed) throw;
584     assert(addr != address(0));
585     assert(now <= endsAt);
586     assert(isTierJoined(msg.sender));
587     if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;
588     //if (addr != msg.sender && contractAddr != msg.sender) throw;
589     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
590     newMaxCap = newMaxCap.minus(tokensBought);
591     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
592   }
593 
594   function isAddressWhitelisted(address addr) public constant returns(bool) {
595     for (uint i = 0; i < whitelistedParticipants.length; i++) {
596       if (whitelistedParticipants[i] == addr) {
597         return true;
598         break;
599       }
600     }
601 
602     return false;
603   }
604 
605   function whitelistedParticipantsLength() public constant returns (uint) {
606     return whitelistedParticipants.length;
607   }
608 
609   function isTierJoined(address addr) public constant returns(bool) {
610     return joinedCrowdsaleState[addr].isJoined;
611   }
612 
613   function getTierPosition(address addr) public constant returns(uint8) {
614     return joinedCrowdsaleState[addr].position;
615   }
616 
617   function getLastTier() public constant returns(address) {
618     if (joinedCrowdsalesLen > 0)
619       return joinedCrowdsales[joinedCrowdsalesLen - 1];
620     else
621       return address(0);
622   }
623 
624   function setJoinedCrowdsales(address addr) private onlyOwner {
625     assert(addr != address(0));
626     assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
627     assert(!isTierJoined(addr));
628     joinedCrowdsales.push(addr);
629     joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
630       isJoined: true,
631       position: joinedCrowdsalesLen
632     });
633     joinedCrowdsalesLen++;
634   }
635 
636   function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
637     assert(addrs.length > 0);
638     assert(joinedCrowdsalesLen == 0);
639     assert(addrs.length <= joinedCrowdsalesLenMax);
640     for (uint8 iter = 0; iter < addrs.length; iter++) {
641       setJoinedCrowdsales(addrs[iter]);
642     }
643   }
644 
645   function setStartsAt(uint time) onlyOwner {
646     assert(!finalized);
647     assert(isUpdatable);
648     assert(now <= time); // Don't change past
649     assert(time <= endsAt);
650     assert(now <= startsAt);
651 
652     CrowdsaleExt2 lastTierCntrct = CrowdsaleExt2(getLastTier());
653     if (lastTierCntrct.finalized()) throw;
654 
655     uint8 tierPosition = getTierPosition(this);
656 
657     //start time should be greater then end time of previous tiers
658     for (uint8 j = 0; j < tierPosition; j++) {
659       CrowdsaleExt2 crowdsale = CrowdsaleExt2(joinedCrowdsales[j]);
660       assert(time >= crowdsale.endsAt());
661     }
662 
663     startsAt = time;
664     StartsAtChanged(startsAt);
665   }
666 
667   /**
668    * Allow crowdsale owner to close early or extend the crowdsale.
669    *
670    * This is useful e.g. for a manual soft cap implementation:
671    * - after X amount is reached determine manual closing
672    *
673    * This may put the crowdsale to an invalid state,
674    * but we trust owners know what they are doing.
675    *
676    */
677   function setEndsAt(uint time) public onlyOwner {
678     assert(!finalized);
679     assert(isUpdatable);
680     assert(now <= time);// Don't change past
681     assert(startsAt <= time);
682     assert(now <= endsAt);
683 
684     CrowdsaleExt2 lastTierCntrct = CrowdsaleExt2(getLastTier());
685     if (lastTierCntrct.finalized()) throw;
686 
687 
688     uint8 tierPosition = getTierPosition(this);
689 
690     for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
691       CrowdsaleExt2 crowdsale = CrowdsaleExt2(joinedCrowdsales[j]);
692       assert(time <= crowdsale.startsAt());
693     }
694 
695     endsAt = time;
696     EndsAtChanged(endsAt);
697   }
698 
699   /**
700    * Allow to (re)set pricing strategy.
701    *
702    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
703    */
704   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
705     assert(address(_pricingStrategy) != address(0));
706     assert(address(pricingStrategy) == address(0));
707     pricingStrategy = _pricingStrategy;
708 
709     // Don't allow setting bad agent
710     if(!pricingStrategy.isPricingStrategy()) {
711       throw;
712     }
713   }
714 
715   /**
716    * Allow to change the team multisig address in the case of emergency.
717    *
718    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
719    * (we have done only few test transactions). After the crowdsale is going
720    * then multisig address stays locked for the safety reasons.
721    */
722   function setMultisig(address addr) public onlyOwner {
723 
724     // Change
725     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
726       throw;
727     }
728 
729     multisigWallet = addr;
730   }
731 
732   /**
733    * @return true if the crowdsale has raised enough money to be a successful.
734    */
735   function isMinimumGoalReached() public constant returns (bool reached) {
736     return weiRaised >= minimumFundingGoal;
737   }
738 
739   /**
740    * Check if the contract relationship looks good.
741    */
742   function isPricingSane() public constant returns (bool sane) {
743     return pricingStrategy.isSane(address(this));
744   }
745 
746   /**
747    * Crowdfund state machine management.
748    *
749    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
750    */
751   function getState() public constant returns (State) {
752     if(finalized) return State.Finalized;
753     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
754     else if (block.timestamp < startsAt) return State.PreFunding;
755     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
756     else if (isMinimumGoalReached()) return State.Success;
757     else return State.Failure;
758   }
759 
760   /** Interface marker. */
761   function isCrowdsale() public constant returns (bool) {
762     return true;
763   }
764 
765   //
766   // Modifiers
767   //
768 
769   /** Modified allowing execution only if the crowdsale is currently running.  */
770   modifier inState(State state) {
771     if(getState() != state) throw;
772     _;
773   }
774 
775   /**
776    * Claim tokens that were accidentally sent to this contract.
777    *
778    * @param _token The address of the token contract that you want to recover.
779    */
780   function claimTokens(address _token) public onlyOwner {
781     require(_token != address(0));
782 
783     ERC20Ext token = ERC20Ext(_token);
784     uint balance = token.balanceOf(this);
785     token.transfer(owner, balance);
786 
787     ClaimedTokens(_token, owner, balance);
788   }
789 
790 
791   //
792   // Abstract functions
793   //
794 
795   /**
796    * Check if the current invested breaks our cap rules.
797    *
798    *
799    * The child contract must define their own cap setting rules.
800    * We allow a lot of flexibility through different capping strategies (ETH, token count)
801    * Called from invest().
802    *
803    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
804    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
805    * @param weiRaisedTotal What would be our total raised balance after this transaction
806    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
807    *
808    * @return true if taking this investment would break our cap rules
809    */
810   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
811 
812   function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);
813 
814   /**
815    * Check if the current crowdsale is full and we can no longer sell any tokens.
816    */
817   function isCrowdsaleFull() public constant returns (bool);
818 
819   /**
820    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
821    */
822   function assignTokens(address receiver, uint tokenAmount) private;
823 }
824 
825 
826 /**
827  * ICO crowdsale contract that is capped by amout of tokens.
828  *
829  * - Tokens are dynamically created during the crowdsale
830  *
831  *
832  */
833 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt2 {
834 
835   /* Maximum amount of tokens this crowdsale can sell. */
836   uint public maximumSellableTokens;
837   address public salespool;
838 
839   function MintedTokenCappedCrowdsaleExt(
840     string _name, 
841     address _token, 
842     PricingStrategy _pricingStrategy, 
843     address _multisigWallet, 
844     uint _start, uint _end, 
845     uint _minimumFundingGoal, 
846     uint _maximumSellableTokens, 
847     bool _isUpdatable, 
848     bool _isWhiteListed
849   ) CrowdsaleExt2(_name, _token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
850     salespool = msg.sender;
851     maximumSellableTokens = _maximumSellableTokens;
852   }
853 
854   // Crowdsale maximumSellableTokens has been changed
855   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
856 
857   /**
858    * Called from invest() to confirm if the curret investment does not break our cap rule.
859    */
860   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken) {
861     return tokensSoldTotal > maximumSellableTokens;
862   }
863 
864   function isBreakingInvestorCap(address addr, uint tokenAmount) public constant returns (bool limitBroken) {
865     assert(isWhiteListed);
866     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
867     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
868   }
869 
870   function isCrowdsaleFull() public constant returns (bool) {
871     return tokensSold >= maximumSellableTokens;
872   }
873 
874   function setMaximumSellableTokens(uint tokens) public onlyOwner {
875     assert(!finalized);
876     assert(isUpdatable);
877     // assert(now <= startsAt);
878 
879     CrowdsaleExt2 lastTierCntrct = CrowdsaleExt2(getLastTier());
880     assert(!lastTierCntrct.finalized());
881 
882     maximumSellableTokens = tokens;
883     MaximumSellableTokensChanged(maximumSellableTokens);
884   }
885 
886   function updateRate(uint newOneTokenInWei) public onlyOwner {
887     assert(!finalized);
888     assert(isUpdatable);
889     // assert(now <= startsAt);
890 
891     CrowdsaleExt2 lastTierCntrct = CrowdsaleExt2(getLastTier());
892     assert(!lastTierCntrct.finalized());
893 
894     pricingStrategy.updateRate(newOneTokenInWei);
895   }
896 
897   // set crowdsale token source address
898   function setSalesPool(address addr) public onlyOwner {
899     require(addr != 0x0);
900     salespool = addr;
901   }
902 
903   /**
904    * Dynamically create tokens and assign them to the investor.
905    */
906   function assignTokens(address receiver, uint tokenAmount) private {
907     token.transferFrom(salespool, receiver, tokenAmount);
908   }
909 }