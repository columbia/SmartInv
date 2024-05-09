1 // Created using ICO Wizard https://github.com/poanetwork/ico-wizard by POA Network 
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
76 
77 /**
78  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
79  *
80  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
81  */
82 
83 
84 
85 
86 
87 /*
88  * Haltable
89  *
90  * Abstract contract that allows children to implement an
91  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
92  *
93  *
94  * Originally envisioned in FirstBlood ICO contract.
95  */
96 contract Haltable is Ownable {
97   bool public halted;
98 
99   modifier stopInEmergency {
100     if (halted) throw;
101     _;
102   }
103 
104   modifier stopNonOwnersInEmergency {
105     if (halted && msg.sender != owner) throw;
106     _;
107   }
108 
109   modifier onlyInEmergency {
110     if (!halted) throw;
111     _;
112   }
113 
114   // called by the owner on emergency, triggers stopped state
115   function halt() external onlyOwner {
116     halted = true;
117   }
118 
119   // called by the owner on end of emergency, returns to normal state
120   function unhalt() external onlyOwner onlyInEmergency {
121     halted = false;
122   }
123 
124 }
125 
126 
127 /**
128  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
129  *
130  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
131  */
132 
133 
134 
135 /**
136  * Finalize agent defines what happens at the end of succeseful crowdsale.
137  *
138  * - Allocate tokens for founders, bounties and community
139  * - Make tokens transferable
140  * - etc.
141  */
142 contract FinalizeAgent {
143 
144   function isFinalizeAgent() public constant returns(bool) {
145     return true;
146   }
147 
148   /** Return true if we can run finalizeCrowdsale() properly.
149    *
150    * This is a safety check function that doesn't allow crowdsale to begin
151    * unless the finalizer has been set up properly.
152    */
153   function isSane() public constant returns (bool);
154 
155   /** Called once by crowdsale finalize() if the sale was success. */
156   function finalizeCrowdsale();
157 
158 }
159 
160 /**
161  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
162  *
163  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
164  */
165 
166 
167 
168 
169 
170 
171 
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) public constant returns (uint256);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 /**
187  * A token that defines fractional units as decimals.
188  */
189 contract FractionalERC20Ext is ERC20 {
190 
191   uint public decimals;
192   uint public minCap;
193 
194 }
195 
196 
197 
198 /**
199  * Abstract base contract for token sales.
200  *
201  * Handle
202  * - start and end dates
203  * - accepting investments
204  * - minimum funding goal and refund
205  * - various statistics during the crowdfund
206  * - different pricing strategies
207  * - different investment policies (require server side customer id, allow only whitelisted addresses)
208  *
209  */
210 contract CrowdsaleExt is Haltable {
211 
212   /* Max investment count when we are still allowed to change the multisig address */
213   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
214 
215   using SafeMathLibExt for uint;
216 
217   /* The token we are selling */
218   FractionalERC20Ext public token;
219 
220   /* How we are going to price our offering */
221   PricingStrategy public pricingStrategy;
222 
223   /* Post-success callback */
224   FinalizeAgent public finalizeAgent;
225 
226   /* name of the crowdsale tier */
227   string public name;
228 
229   /* tokens will be transfered from this address */
230   address public multisigWallet;
231 
232   /* if the funding goal is not reached, investors may withdraw their funds */
233   uint public minimumFundingGoal;
234 
235   /* the UNIX timestamp start date of the crowdsale */
236   uint public startsAt;
237 
238   /* the UNIX timestamp end date of the crowdsale */
239   uint public endsAt;
240 
241   /* the number of tokens already sold through this contract*/
242   uint public tokensSold = 0;
243 
244   /* How many wei of funding we have raised */
245   uint public weiRaised = 0;
246 
247   /* Calculate incoming funds from presale contracts and addresses */
248   uint public presaleWeiRaised = 0;
249 
250   /* How many distinct addresses have invested */
251   uint public investorCount = 0;
252 
253   /* How much wei we have returned back to the contract after a failed crowdfund. */
254   uint public loadedRefund = 0;
255 
256   /* How much wei we have given back to investors.*/
257   uint public weiRefunded = 0;
258 
259   /* Has this crowdsale been finalized */
260   bool public finalized;
261 
262   /* Do we need to have unique contributor id for each customer */
263   bool public requireCustomerId;
264 
265   bool public isWhiteListed;
266 
267   address[] public joinedCrowdsales;
268   uint public joinedCrowdsalesLen = 0;
269 
270   address public lastCrowdsale;
271 
272   /**
273     * Do we verify that contributor has been cleared on the server side (accredited investors only).
274     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
275     */
276   bool public requiredSignedAddress;
277 
278   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
279   address public signerAddress;
280 
281   /** How much ETH each address has invested to this crowdsale */
282   mapping (address => uint256) public investedAmountOf;
283 
284   /** How much tokens this crowdsale has credited for each investor address */
285   mapping (address => uint256) public tokenAmountOf;
286 
287   struct WhiteListData {
288     bool status;
289     uint minCap;
290     uint maxCap;
291   }
292 
293   //is crowdsale updatable
294   bool public isUpdatable;
295 
296   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
297   mapping (address => WhiteListData) public earlyParticipantWhitelist;
298 
299   /** List of whitelisted addresses */
300   address[] public whitelistedParticipants;
301 
302   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
303   uint public ownerTestValue;
304 
305   /** State machine
306    *
307    * - Preparing: All contract initialization calls and variables have not been set yet
308    * - Prefunding: We have not passed start time yet
309    * - Funding: Active crowdsale
310    * - Success: Minimum funding goal reached
311    * - Failure: Minimum funding goal not reached before ending time
312    * - Finalized: The finalized has been called and succesfully executed
313    * - Refunding: Refunds are loaded on the contract for reclaim.
314    */
315   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
316 
317   // A new investment was made
318   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
319 
320   // Refund was processed for a contributor
321   event Refund(address investor, uint weiAmount);
322 
323   // The rules were changed what kind of investments we accept
324   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
325 
326   // Address early participation whitelist status changed
327   event Whitelisted(address addr, bool status);
328 
329   // Crowdsale start time has been changed
330   event StartsAtChanged(uint newStartsAt);
331 
332   // Crowdsale end time has been changed
333   event EndsAtChanged(uint newEndsAt);
334 
335   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
336 
337     owner = msg.sender;
338 
339     name = _name;
340 
341     token = FractionalERC20Ext(_token);
342 
343     setPricingStrategy(_pricingStrategy);
344 
345     multisigWallet = _multisigWallet;
346     if(multisigWallet == 0) {
347         throw;
348     }
349 
350     if(_start == 0) {
351         throw;
352     }
353 
354     startsAt = _start;
355 
356     if(_end == 0) {
357         throw;
358     }
359 
360     endsAt = _end;
361 
362     // Don't mess the dates
363     if(startsAt >= endsAt) {
364         throw;
365     }
366 
367     // Minimum funding goal can be zero
368     minimumFundingGoal = _minimumFundingGoal;
369 
370     isUpdatable = _isUpdatable;
371 
372     isWhiteListed = _isWhiteListed;
373   }
374 
375   /**
376    * Don't expect to just send in money and get tokens.
377    */
378   function() payable {
379     throw;
380   }
381 
382   /**
383    * Make an investment.
384    *
385    * Crowdsale must be running for one to invest.
386    * We must have not pressed the emergency brake.
387    *
388    * @param receiver The Ethereum address who receives the tokens
389    * @param customerId (optional) UUID v4 to track the successful payments on the server side
390    *
391    */
392   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
393 
394     // Determine if it's a good time to accept investment from this participant
395     if(getState() == State.PreFunding) {
396       // Are we whitelisted for early deposit
397       throw;
398     } else if(getState() == State.Funding) {
399       // Retail participants can only come in when the crowdsale is running
400       // pass
401       if(isWhiteListed) {
402         if(!earlyParticipantWhitelist[receiver].status) {
403           throw;
404         }
405       }
406     } else {
407       // Unwanted state
408       throw;
409     }
410 
411     uint weiAmount = msg.value;
412 
413     // Account presale sales separately, so that they do not count against pricing tranches
414     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
415 
416     if(tokenAmount == 0) {
417       // Dust transaction
418       throw;
419     }
420 
421     if(isWhiteListed) {
422       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
423         // tokenAmount < minCap for investor
424         throw;
425       }
426       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
427         // tokenAmount > maxCap for investor
428         throw;
429       }
430 
431       // Check that we did not bust the investor's cap
432       if (isBreakingInvestorCap(receiver, tokenAmount)) {
433         throw;
434       }
435     } else {
436       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
437         throw;
438       }
439     }
440 
441     if(investedAmountOf[receiver] == 0) {
442        // A new investor
443        investorCount++;
444     }
445 
446     // Update investor
447     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
448     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
449 
450     // Update totals
451     weiRaised = weiRaised.plus(weiAmount);
452     tokensSold = tokensSold.plus(tokenAmount);
453 
454     if(pricingStrategy.isPresalePurchase(receiver)) {
455         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
456     }
457 
458     // Check that we did not bust the cap
459     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
460       throw;
461     }
462 
463     assignTokens(receiver, tokenAmount);
464 
465     // Pocket the money
466     if(!multisigWallet.send(weiAmount)) throw;
467 
468     if (isWhiteListed) {
469       uint num = 0;
470       for (var i = 0; i < joinedCrowdsalesLen; i++) {
471         if (this == joinedCrowdsales[i])
472           num = i;
473       }
474 
475       if (num + 1 < joinedCrowdsalesLen) {
476         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
477           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
478           crowdsale.updateEarlyParticipantWhitelist(msg.sender, this, tokenAmount);
479         }
480       }
481     }
482 
483     // Tell us invest was success
484     Invested(receiver, weiAmount, tokenAmount, customerId);
485   }
486 
487   /**
488    * Preallocate tokens for the early investors.
489    *
490    * Preallocated tokens have been sold before the actual crowdsale opens.
491    * This function mints the tokens and moves the crowdsale needle.
492    *
493    * Investor count is not handled; it is assumed this goes for multiple investors
494    * and the token distribution happens outside the smart contract flow.
495    *
496    * No money is exchanged, as the crowdsale team already have received the payment.
497    *
498    * @param fullTokens tokens as full tokens - decimal places added internally
499    * @param weiPrice Price of a single full token in wei
500    *
501    */
502   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
503 
504     uint tokenAmount = fullTokens * 10**token.decimals();
505     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
506 
507     weiRaised = weiRaised.plus(weiAmount);
508     tokensSold = tokensSold.plus(tokenAmount);
509 
510     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
511     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
512 
513     assignTokens(receiver, tokenAmount);
514 
515     // Tell us invest was success
516     Invested(receiver, weiAmount, tokenAmount, 0);
517   }
518 
519   /**
520    * Allow anonymous contributions to this crowdsale.
521    */
522   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
523      bytes32 hash = sha256(addr);
524      if (ecrecover(hash, v, r, s) != signerAddress) throw;
525      if(customerId == 0) throw;  // UUIDv4 sanity check
526      investInternal(addr, customerId);
527   }
528 
529   /**
530    * Track who is the customer making the payment so we can send thank you email.
531    */
532   function investWithCustomerId(address addr, uint128 customerId) public payable {
533     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
534     if(customerId == 0) throw;  // UUIDv4 sanity check
535     investInternal(addr, customerId);
536   }
537 
538   /**
539    * Allow anonymous contributions to this crowdsale.
540    */
541   function invest(address addr) public payable {
542     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
543     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
544     investInternal(addr, 0);
545   }
546 
547   /**
548    * Invest to tokens, recognize the payer and clear his address.
549    *
550    */
551   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
552     investWithSignedAddress(msg.sender, customerId, v, r, s);
553   }
554 
555   /**
556    * Invest to tokens, recognize the payer.
557    *
558    */
559   function buyWithCustomerId(uint128 customerId) public payable {
560     investWithCustomerId(msg.sender, customerId);
561   }
562 
563   /**
564    * The basic entry point to participate the crowdsale process.
565    *
566    * Pay for funding, get invested tokens back in the sender address.
567    */
568   function buy() public payable {
569     invest(msg.sender);
570   }
571 
572   /**
573    * Finalize a succcesful crowdsale.
574    *
575    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
576    */
577   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
578 
579     // Already finalized
580     if(finalized) {
581       throw;
582     }
583 
584     // Finalizing is optional. We only call it if we are given a finalizing agent.
585     if(address(finalizeAgent) != 0) {
586       finalizeAgent.finalizeCrowdsale();
587     }
588 
589     finalized = true;
590   }
591 
592   /**
593    * Allow to (re)set finalize agent.
594    *
595    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
596    */
597   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
598     finalizeAgent = addr;
599 
600     // Don't allow setting bad agent
601     if(!finalizeAgent.isFinalizeAgent()) {
602       throw;
603     }
604   }
605 
606   /**
607    * Set policy do we need to have server-side customer ids for the investments.
608    *
609    */
610   function setRequireCustomerId(bool value) onlyOwner {
611     requireCustomerId = value;
612     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
613   }
614 
615   /**
616    * Set policy if all investors must be cleared on the server side first.
617    *
618    * This is e.g. for the accredited investor clearing.
619    *
620    */
621   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
622     requiredSignedAddress = value;
623     signerAddress = _signerAddress;
624     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
625   }
626 
627   /**
628    * Allow addresses to do early participation.
629    */
630   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
631     if (!isWhiteListed) throw;
632     assert(addr != address(0));
633     assert(maxCap > 0);
634     assert(minCap <= maxCap);
635 
636     if (earlyParticipantWhitelist[addr].maxCap == 0) {
637       earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
638       whitelistedParticipants.push(addr);
639       Whitelisted(addr, status);
640     }
641   }
642 
643   function setEarlyParticipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
644     if (!isWhiteListed) throw;
645     for (uint iterator = 0; iterator < addrs.length; iterator++) {
646       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
647     }
648   }
649 
650   function updateEarlyParticipantWhitelist(address addr, address contractAddr, uint tokensBought) {
651     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
652     if (!isWhiteListed) throw;
653     if (addr != msg.sender && contractAddr != msg.sender) throw;
654     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
655     newMaxCap = newMaxCap.minus(tokensBought);
656     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
657   }
658 
659   function updateJoinedCrowdsales(address addr) onlyOwner {
660     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
661   }
662 
663   function setLastCrowdsale(address addr) onlyOwner {
664     lastCrowdsale = addr;
665   }
666 
667   function clearJoinedCrowdsales() onlyOwner {
668     joinedCrowdsalesLen = 0;
669   }
670 
671   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
672     clearJoinedCrowdsales();
673     for (uint iter = 0; iter < addrs.length; iter++) {
674       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
675           joinedCrowdsales.length += 1;
676       }
677       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
678       if (iter == addrs.length - 1)
679         setLastCrowdsale(addrs[iter]);
680     }
681   }
682 
683   function setStartsAt(uint time) onlyOwner {
684     if (finalized) throw;
685 
686     if (!isUpdatable) throw;
687 
688     if(now > time) {
689       throw; // Don't change past
690     }
691 
692     if(time > endsAt) {
693       throw;
694     }
695 
696     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
697     if (lastCrowdsaleCntrct.finalized()) throw;
698 
699     startsAt = time;
700     StartsAtChanged(startsAt);
701   }
702 
703   /**
704    * Allow crowdsale owner to close early or extend the crowdsale.
705    *
706    * This is useful e.g. for a manual soft cap implementation:
707    * - after X amount is reached determine manual closing
708    *
709    * This may put the crowdsale to an invalid state,
710    * but we trust owners know what they are doing.
711    *
712    */
713   function setEndsAt(uint time) onlyOwner {
714     if (finalized) throw;
715 
716     if (!isUpdatable) throw;
717 
718     if(now > time) {
719       throw; // Don't change past
720     }
721 
722     if(startsAt > time) {
723       throw;
724     }
725 
726     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
727     if (lastCrowdsaleCntrct.finalized()) throw;
728 
729     uint num = 0;
730     for (var i = 0; i < joinedCrowdsalesLen; i++) {
731       if (this == joinedCrowdsales[i])
732         num = i;
733     }
734 
735     if (num + 1 < joinedCrowdsalesLen) {
736       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
737         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
738         if (time > crowdsale.startsAt()) throw;
739       }
740     }
741 
742     endsAt = time;
743     EndsAtChanged(endsAt);
744   }
745 
746   /**
747    * Allow to (re)set pricing strategy.
748    *
749    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
750    */
751   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
752     pricingStrategy = _pricingStrategy;
753 
754     // Don't allow setting bad agent
755     if(!pricingStrategy.isPricingStrategy()) {
756       throw;
757     }
758   }
759 
760   /**
761    * Allow to change the team multisig address in the case of emergency.
762    *
763    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
764    * (we have done only few test transactions). After the crowdsale is going
765    * then multisig address stays locked for the safety reasons.
766    */
767   function setMultisig(address addr) public onlyOwner {
768 
769     // Change
770     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
771       throw;
772     }
773 
774     multisigWallet = addr;
775   }
776 
777   /**
778    * Allow load refunds back on the contract for the refunding.
779    *
780    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
781    */
782   function loadRefund() public payable inState(State.Failure) {
783     if(msg.value == 0) throw;
784     loadedRefund = loadedRefund.plus(msg.value);
785   }
786 
787   /**
788    * Investors can claim refund.
789    *
790    * Note that any refunds from proxy buyers should be handled separately,
791    * and not through this contract.
792    */
793   function refund() public inState(State.Refunding) {
794     uint256 weiValue = investedAmountOf[msg.sender];
795     if (weiValue == 0) throw;
796     investedAmountOf[msg.sender] = 0;
797     weiRefunded = weiRefunded.plus(weiValue);
798     Refund(msg.sender, weiValue);
799     if (!msg.sender.send(weiValue)) throw;
800   }
801 
802   /**
803    * @return true if the crowdsale has raised enough money to be a successful.
804    */
805   function isMinimumGoalReached() public constant returns (bool reached) {
806     return weiRaised >= minimumFundingGoal;
807   }
808 
809   /**
810    * Check if the contract relationship looks good.
811    */
812   function isFinalizerSane() public constant returns (bool sane) {
813     return finalizeAgent.isSane();
814   }
815 
816   /**
817    * Check if the contract relationship looks good.
818    */
819   function isPricingSane() public constant returns (bool sane) {
820     return pricingStrategy.isSane(address(this));
821   }
822 
823   /**
824    * Crowdfund state machine management.
825    *
826    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
827    */
828   function getState() public constant returns (State) {
829     if(finalized) return State.Finalized;
830     else if (address(finalizeAgent) == 0) return State.Preparing;
831     else if (!finalizeAgent.isSane()) return State.Preparing;
832     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
833     else if (block.timestamp < startsAt) return State.PreFunding;
834     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
835     else if (isMinimumGoalReached()) return State.Success;
836     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
837     else return State.Failure;
838   }
839 
840   /** This is for manual testing of multisig wallet interaction */
841   function setOwnerTestValue(uint val) onlyOwner {
842     ownerTestValue = val;
843   }
844 
845   /** Interface marker. */
846   function isCrowdsale() public constant returns (bool) {
847     return true;
848   }
849 
850   //
851   // Modifiers
852   //
853 
854   /** Modified allowing execution only if the crowdsale is currently running.  */
855   modifier inState(State state) {
856     if(getState() != state) throw;
857     _;
858   }
859 
860 
861   //
862   // Abstract functions
863   //
864 
865   /**
866    * Check if the current invested breaks our cap rules.
867    *
868    *
869    * The child contract must define their own cap setting rules.
870    * We allow a lot of flexibility through different capping strategies (ETH, token count)
871    * Called from invest().
872    *
873    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
874    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
875    * @param weiRaisedTotal What would be our total raised balance after this transaction
876    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
877    *
878    * @return true if taking this investment would break our cap rules
879    */
880   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
881 
882   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
883 
884   /**
885    * Check if the current crowdsale is full and we can no longer sell any tokens.
886    */
887   function isCrowdsaleFull() public constant returns (bool);
888 
889   /**
890    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
891    */
892   function assignTokens(address receiver, uint tokenAmount) private;
893 
894   function whitelistedParticipantsLength() public constant returns (uint) {
895     return whitelistedParticipants.length;
896   }
897 }
898 
899 
900 /**
901  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
902  *
903  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
904  */
905 
906 
907 
908 /**
909  * Interface for defining crowdsale pricing.
910  */
911 contract PricingStrategy {
912 
913   /** Interface declaration. */
914   function isPricingStrategy() public constant returns (bool) {
915     return true;
916   }
917 
918   /** Self check if all references are correctly set.
919    *
920    * Checks that pricing strategy matches crowdsale parameters.
921    */
922   function isSane(address crowdsale) public constant returns (bool) {
923     return true;
924   }
925 
926   /**
927    * @dev Pricing tells if this is a presale purchase or not.
928      @param purchaser Address of the purchaser
929      @return False by default, true if a presale purchaser
930    */
931   function isPresalePurchase(address purchaser) public constant returns (bool) {
932     return false;
933   }
934 
935   /**
936    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
937    *
938    *
939    * @param value - What is the value of the transaction send in as wei
940    * @param tokensSold - how much tokens have been sold this far
941    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
942    * @param msgSender - who is the investor of this transaction
943    * @param decimals - how many decimal units the token has
944    * @return Amount of tokens the investor receives
945    */
946   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
947 }
948 
949 /**
950  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
951  *
952  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
953  */
954 
955 
956 
957 /**
958  * Safe unsigned safe math.
959  *
960  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
961  *
962  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
963  *
964  * Maintained here until merged to mainline zeppelin-solidity.
965  *
966  */
967 library SafeMathLibExt {
968 
969   function times(uint a, uint b) returns (uint) {
970     uint c = a * b;
971     assert(a == 0 || c / a == b);
972     return c;
973   }
974 
975   function divides(uint a, uint b) returns (uint) {
976     assert(b > 0);
977     uint c = a / b;
978     assert(a == b * c + a % b);
979     return c;
980   }
981 
982   function minus(uint a, uint b) returns (uint) {
983     assert(b <= a);
984     return a - b;
985   }
986 
987   function plus(uint a, uint b) returns (uint) {
988     uint c = a + b;
989     assert(c>=a);
990     return c;
991   }
992 
993 }
994 
995 
996 /**
997  * Fixed crowdsale pricing - everybody gets the same price.
998  */
999 contract FlatPricingExt is PricingStrategy, Ownable {
1000 
1001   using SafeMathLibExt for uint;
1002 
1003   /* How many weis one token costs */
1004   uint public oneTokenInWei;
1005 
1006   bool public isUpdatable;
1007 
1008   address public lastCrowdsale;
1009 
1010   // Crowdsale rate has been changed
1011   event RateChanged(uint newOneTokenInWei);
1012 
1013   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
1014     require(_oneTokenInWei > 0);
1015     oneTokenInWei = _oneTokenInWei;
1016 
1017     isUpdatable = _isUpdatable;
1018   }
1019 
1020   function setLastCrowdsale(address addr) onlyOwner {
1021     lastCrowdsale = addr;
1022   }
1023 
1024   function updateRate(uint newOneTokenInWei) onlyOwner {
1025     if (!isUpdatable) throw;
1026 
1027     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1028     if (lastCrowdsaleCntrct.finalized()) throw;
1029 
1030     oneTokenInWei = newOneTokenInWei;
1031     RateChanged(newOneTokenInWei);
1032   }
1033 
1034   /**
1035    * Calculate the current price for buy in amount.
1036    *
1037    */
1038   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1039     uint multiplier = 10 ** decimals;
1040     return value.times(multiplier) / oneTokenInWei;
1041   }
1042 
1043 }