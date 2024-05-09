1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
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
226   /* tokens will be transfered from this address */
227   address public multisigWallet;
228 
229   /* if the funding goal is not reached, investors may withdraw their funds */
230   uint public minimumFundingGoal;
231 
232   /* the UNIX timestamp start date of the crowdsale */
233   uint public startsAt;
234 
235   /* the UNIX timestamp end date of the crowdsale */
236   uint public endsAt;
237 
238   /* the number of tokens already sold through this contract*/
239   uint public tokensSold = 0;
240 
241   /* How many wei of funding we have raised */
242   uint public weiRaised = 0;
243 
244   /* Calculate incoming funds from presale contracts and addresses */
245   uint public presaleWeiRaised = 0;
246 
247   /* How many distinct addresses have invested */
248   uint public investorCount = 0;
249 
250   /* How much wei we have returned back to the contract after a failed crowdfund. */
251   uint public loadedRefund = 0;
252 
253   /* How much wei we have given back to investors.*/
254   uint public weiRefunded = 0;
255 
256   /* Has this crowdsale been finalized */
257   bool public finalized;
258 
259   /* Do we need to have unique contributor id for each customer */
260   bool public requireCustomerId;
261 
262   bool public isWhiteListed;
263 
264   address[] public joinedCrowdsales;
265   uint public joinedCrowdsalesLen = 0;
266 
267   address public lastCrowdsale;
268 
269   /**
270     * Do we verify that contributor has been cleared on the server side (accredited investors only).
271     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
272     */
273   bool public requiredSignedAddress;
274 
275   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
276   address public signerAddress;
277 
278   /** How much ETH each address has invested to this crowdsale */
279   mapping (address => uint256) public investedAmountOf;
280 
281   /** How much tokens this crowdsale has credited for each investor address */
282   mapping (address => uint256) public tokenAmountOf;
283 
284   struct WhiteListData {
285     bool status;
286     uint minCap;
287     uint maxCap;
288   }
289 
290   //is crowdsale updatable
291   bool public isUpdatable;
292 
293   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
294   mapping (address => WhiteListData) public earlyParticipantWhitelist;
295 
296   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
297   uint public ownerTestValue;
298 
299   /** State machine
300    *
301    * - Preparing: All contract initialization calls and variables have not been set yet
302    * - Prefunding: We have not passed start time yet
303    * - Funding: Active crowdsale
304    * - Success: Minimum funding goal reached
305    * - Failure: Minimum funding goal not reached before ending time
306    * - Finalized: The finalized has been called and succesfully executed
307    * - Refunding: Refunds are loaded on the contract for reclaim.
308    */
309   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
310 
311   // A new investment was made
312   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
313 
314   // Refund was processed for a contributor
315   event Refund(address investor, uint weiAmount);
316 
317   // The rules were changed what kind of investments we accept
318   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
319 
320   // Address early participation whitelist status changed
321   event Whitelisted(address addr, bool status);
322 
323   // Crowdsale start time has been changed
324   event StartsAtChanged(uint newStartsAt);
325 
326   // Crowdsale end time has been changed
327   event EndsAtChanged(uint newEndsAt);
328 
329   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
330 
331     owner = msg.sender;
332 
333     token = FractionalERC20Ext(_token);
334 
335     setPricingStrategy(_pricingStrategy);
336 
337     multisigWallet = _multisigWallet;
338     if(multisigWallet == 0) {
339         throw;
340     }
341 
342     if(_start == 0) {
343         throw;
344     }
345 
346     startsAt = _start;
347 
348     if(_end == 0) {
349         throw;
350     }
351 
352     endsAt = _end;
353 
354     // Don't mess the dates
355     if(startsAt >= endsAt) {
356         throw;
357     }
358 
359     // Minimum funding goal can be zero
360     minimumFundingGoal = _minimumFundingGoal;
361 
362     isUpdatable = _isUpdatable;
363 
364     isWhiteListed = _isWhiteListed;
365   }
366 
367   /**
368    * Don't expect to just send in money and get tokens.
369    */
370   function() payable {
371     throw;
372   }
373 
374   /**
375    * Make an investment.
376    *
377    * Crowdsale must be running for one to invest.
378    * We must have not pressed the emergency brake.
379    *
380    * @param receiver The Ethereum address who receives the tokens
381    * @param customerId (optional) UUID v4 to track the successful payments on the server side
382    *
383    */
384   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
385 
386     // Determine if it's a good time to accept investment from this participant
387     if(getState() == State.PreFunding) {
388       // Are we whitelisted for early deposit
389       throw;
390     } else if(getState() == State.Funding) {
391       // Retail participants can only come in when the crowdsale is running
392       // pass
393       if(isWhiteListed) {
394         if(!earlyParticipantWhitelist[receiver].status) {
395           throw;
396         }
397       }
398     } else {
399       // Unwanted state
400       throw;
401     }
402 
403     uint weiAmount = msg.value;
404 
405     // Account presale sales separately, so that they do not count against pricing tranches
406     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
407 
408     if(tokenAmount == 0) {
409       // Dust transaction
410       throw;
411     }
412 
413     if(isWhiteListed) {
414       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
415         // tokenAmount < minCap for investor
416         throw;
417       }
418       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
419         // tokenAmount > maxCap for investor
420         throw;
421       }
422 
423       // Check that we did not bust the investor's cap
424       if (isBreakingInvestorCap(receiver, tokenAmount)) {
425         throw;
426       }
427     } else {
428       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
429         throw;
430       }
431     }
432 
433     if(investedAmountOf[receiver] == 0) {
434        // A new investor
435        investorCount++;
436     }
437 
438     // Update investor
439     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
440     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
441 
442     // Update totals
443     weiRaised = weiRaised.plus(weiAmount);
444     tokensSold = tokensSold.plus(tokenAmount);
445 
446     if(pricingStrategy.isPresalePurchase(receiver)) {
447         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
448     }
449 
450     // Check that we did not bust the cap
451     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
452       throw;
453     }
454 
455     assignTokens(receiver, tokenAmount);
456 
457     // Pocket the money
458     if(!multisigWallet.send(weiAmount)) throw;
459 
460     if (isWhiteListed) {
461       uint num = 0;
462       for (var i = 0; i < joinedCrowdsalesLen; i++) {
463         if (this == joinedCrowdsales[i]) 
464           num = i;
465       }
466 
467       if (num + 1 < joinedCrowdsalesLen) {
468         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
469           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
470           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
471         }
472       }
473     }
474 
475     // Tell us invest was success
476     Invested(receiver, weiAmount, tokenAmount, customerId);
477   }
478 
479   /**
480    * Preallocate tokens for the early investors.
481    *
482    * Preallocated tokens have been sold before the actual crowdsale opens.
483    * This function mints the tokens and moves the crowdsale needle.
484    *
485    * Investor count is not handled; it is assumed this goes for multiple investors
486    * and the token distribution happens outside the smart contract flow.
487    *
488    * No money is exchanged, as the crowdsale team already have received the payment.
489    *
490    * @param fullTokens tokens as full tokens - decimal places added internally
491    * @param weiPrice Price of a single full token in wei
492    *
493    */
494   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
495 
496     uint tokenAmount = fullTokens * 10**token.decimals();
497     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
498 
499     weiRaised = weiRaised.plus(weiAmount);
500     tokensSold = tokensSold.plus(tokenAmount);
501 
502     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
503     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
504 
505     assignTokens(receiver, tokenAmount);
506 
507     // Tell us invest was success
508     Invested(receiver, weiAmount, tokenAmount, 0);
509   }
510 
511   /**
512    * Allow anonymous contributions to this crowdsale.
513    */
514   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
515      bytes32 hash = sha256(addr);
516      if (ecrecover(hash, v, r, s) != signerAddress) throw;
517      if(customerId == 0) throw;  // UUIDv4 sanity check
518      investInternal(addr, customerId);
519   }
520 
521   /**
522    * Track who is the customer making the payment so we can send thank you email.
523    */
524   function investWithCustomerId(address addr, uint128 customerId) public payable {
525     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
526     if(customerId == 0) throw;  // UUIDv4 sanity check
527     investInternal(addr, customerId);
528   }
529 
530   /**
531    * Allow anonymous contributions to this crowdsale.
532    */
533   function invest(address addr) public payable {
534     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
535     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
536     investInternal(addr, 0);
537   }
538 
539   /**
540    * Invest to tokens, recognize the payer and clear his address.
541    *
542    */
543   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
544     investWithSignedAddress(msg.sender, customerId, v, r, s);
545   }
546 
547   /**
548    * Invest to tokens, recognize the payer.
549    *
550    */
551   function buyWithCustomerId(uint128 customerId) public payable {
552     investWithCustomerId(msg.sender, customerId);
553   }
554 
555   /**
556    * The basic entry point to participate the crowdsale process.
557    *
558    * Pay for funding, get invested tokens back in the sender address.
559    */
560   function buy() public payable {
561     invest(msg.sender);
562   }
563 
564   /**
565    * Finalize a succcesful crowdsale.
566    *
567    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
568    */
569   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
570 
571     // Already finalized
572     if(finalized) {
573       throw;
574     }
575 
576     // Finalizing is optional. We only call it if we are given a finalizing agent.
577     if(address(finalizeAgent) != 0) {
578       finalizeAgent.finalizeCrowdsale();
579     }
580 
581     finalized = true;
582   }
583 
584   /**
585    * Allow to (re)set finalize agent.
586    *
587    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
588    */
589   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
590     finalizeAgent = addr;
591 
592     // Don't allow setting bad agent
593     if(!finalizeAgent.isFinalizeAgent()) {
594       throw;
595     }
596   }
597 
598   /**
599    * Set policy do we need to have server-side customer ids for the investments.
600    *
601    */
602   function setRequireCustomerId(bool value) onlyOwner {
603     requireCustomerId = value;
604     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
605   }
606 
607   /**
608    * Set policy if all investors must be cleared on the server side first.
609    *
610    * This is e.g. for the accredited investor clearing.
611    *
612    */
613   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
614     requiredSignedAddress = value;
615     signerAddress = _signerAddress;
616     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
617   }
618 
619   /**
620    * Allow addresses to do early participation.
621    *
622    * TODO: Fix spelling error in the name
623    */
624   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
625     if (!isWhiteListed) throw;
626     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
627     Whitelisted(addr, status);
628   }
629 
630   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
631     if (!isWhiteListed) throw;
632     for (uint iterator = 0; iterator < addrs.length; iterator++) {
633       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
634     }
635   }
636 
637   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
638     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
639     if (!isWhiteListed) throw;
640     if (addr != msg.sender && contractAddr != msg.sender) throw;
641     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
642     newMaxCap = newMaxCap.minus(tokensBought);
643     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
644   }
645 
646   function updateJoinedCrowdsales(address addr) onlyOwner {
647     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
648   }
649 
650   function setLastCrowdsale(address addr) onlyOwner {
651     lastCrowdsale = addr;
652   }
653 
654   function clearJoinedCrowdsales() onlyOwner {
655     joinedCrowdsalesLen = 0;
656   }
657 
658   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
659     clearJoinedCrowdsales();
660     for (uint iter = 0; iter < addrs.length; iter++) {
661       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
662           joinedCrowdsales.length += 1;
663       }
664       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
665       if (iter == addrs.length - 1)
666         setLastCrowdsale(addrs[iter]);
667     }
668   }
669 
670   function setStartsAt(uint time) onlyOwner {
671     if (finalized) throw;
672 
673     if (!isUpdatable) throw;
674 
675     if(now > time) {
676       throw; // Don't change past
677     }
678 
679     if(time > endsAt) {
680       throw;
681     }
682 
683     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
684     if (lastCrowdsaleCntrct.finalized()) throw;
685 
686     startsAt = time;
687     StartsAtChanged(startsAt);
688   }
689 
690   /**
691    * Allow crowdsale owner to close early or extend the crowdsale.
692    *
693    * This is useful e.g. for a manual soft cap implementation:
694    * - after X amount is reached determine manual closing
695    *
696    * This may put the crowdsale to an invalid state,
697    * but we trust owners know what they are doing.
698    *
699    */
700   function setEndsAt(uint time) onlyOwner {
701     if (finalized) throw;
702 
703     if (!isUpdatable) throw;
704 
705     if(now > time) {
706       throw; // Don't change past
707     }
708 
709     if(startsAt > time) {
710       throw;
711     }
712 
713     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
714     if (lastCrowdsaleCntrct.finalized()) throw;
715 
716     uint num = 0;
717     for (var i = 0; i < joinedCrowdsalesLen; i++) {
718       if (this == joinedCrowdsales[i]) 
719         num = i;
720     }
721 
722     if (num + 1 < joinedCrowdsalesLen) {
723       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
724         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
725         if (time > crowdsale.startsAt()) throw;
726       }
727     }
728 
729     endsAt = time;
730     EndsAtChanged(endsAt);
731   }
732 
733   /**
734    * Allow to (re)set pricing strategy.
735    *
736    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
737    */
738   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
739     pricingStrategy = _pricingStrategy;
740 
741     // Don't allow setting bad agent
742     if(!pricingStrategy.isPricingStrategy()) {
743       throw;
744     }
745   }
746 
747   /**
748    * Allow to change the team multisig address in the case of emergency.
749    *
750    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
751    * (we have done only few test transactions). After the crowdsale is going
752    * then multisig address stays locked for the safety reasons.
753    */
754   function setMultisig(address addr) public onlyOwner {
755 
756     // Change
757     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
758       throw;
759     }
760 
761     multisigWallet = addr;
762   }
763 
764   /**
765    * Allow load refunds back on the contract for the refunding.
766    *
767    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
768    */
769   function loadRefund() public payable inState(State.Failure) {
770     if(msg.value == 0) throw;
771     loadedRefund = loadedRefund.plus(msg.value);
772   }
773 
774   /**
775    * Investors can claim refund.
776    *
777    * Note that any refunds from proxy buyers should be handled separately,
778    * and not through this contract.
779    */
780   function refund() public inState(State.Refunding) {
781     uint256 weiValue = investedAmountOf[msg.sender];
782     if (weiValue == 0) throw;
783     investedAmountOf[msg.sender] = 0;
784     weiRefunded = weiRefunded.plus(weiValue);
785     Refund(msg.sender, weiValue);
786     if (!msg.sender.send(weiValue)) throw;
787   }
788 
789   /**
790    * @return true if the crowdsale has raised enough money to be a successful.
791    */
792   function isMinimumGoalReached() public constant returns (bool reached) {
793     return weiRaised >= minimumFundingGoal;
794   }
795 
796   /**
797    * Check if the contract relationship looks good.
798    */
799   function isFinalizerSane() public constant returns (bool sane) {
800     return finalizeAgent.isSane();
801   }
802 
803   /**
804    * Check if the contract relationship looks good.
805    */
806   function isPricingSane() public constant returns (bool sane) {
807     return pricingStrategy.isSane(address(this));
808   }
809 
810   /**
811    * Crowdfund state machine management.
812    *
813    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
814    */
815   function getState() public constant returns (State) {
816     if(finalized) return State.Finalized;
817     else if (address(finalizeAgent) == 0) return State.Preparing;
818     else if (!finalizeAgent.isSane()) return State.Preparing;
819     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
820     else if (block.timestamp < startsAt) return State.PreFunding;
821     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
822     else if (isMinimumGoalReached()) return State.Success;
823     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
824     else return State.Failure;
825   }
826 
827   /** This is for manual testing of multisig wallet interaction */
828   function setOwnerTestValue(uint val) onlyOwner {
829     ownerTestValue = val;
830   }
831 
832   /** Interface marker. */
833   function isCrowdsale() public constant returns (bool) {
834     return true;
835   }
836 
837   //
838   // Modifiers
839   //
840 
841   /** Modified allowing execution only if the crowdsale is currently running.  */
842   modifier inState(State state) {
843     if(getState() != state) throw;
844     _;
845   }
846 
847 
848   //
849   // Abstract functions
850   //
851 
852   /**
853    * Check if the current invested breaks our cap rules.
854    *
855    *
856    * The child contract must define their own cap setting rules.
857    * We allow a lot of flexibility through different capping strategies (ETH, token count)
858    * Called from invest().
859    *
860    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
861    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
862    * @param weiRaisedTotal What would be our total raised balance after this transaction
863    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
864    *
865    * @return true if taking this investment would break our cap rules
866    */
867   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
868 
869   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
870 
871   /**
872    * Check if the current crowdsale is full and we can no longer sell any tokens.
873    */
874   function isCrowdsaleFull() public constant returns (bool);
875 
876   /**
877    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
878    */
879   function assignTokens(address receiver, uint tokenAmount) private;
880 }
881 
882 
883 /**
884  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
885  *
886  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
887  */
888 
889 
890 
891 /**
892  * Interface for defining crowdsale pricing.
893  */
894 contract PricingStrategy {
895 
896   /** Interface declaration. */
897   function isPricingStrategy() public constant returns (bool) {
898     return true;
899   }
900 
901   /** Self check if all references are correctly set.
902    *
903    * Checks that pricing strategy matches crowdsale parameters.
904    */
905   function isSane(address crowdsale) public constant returns (bool) {
906     return true;
907   }
908 
909   /**
910    * @dev Pricing tells if this is a presale purchase or not.
911      @param purchaser Address of the purchaser
912      @return False by default, true if a presale purchaser
913    */
914   function isPresalePurchase(address purchaser) public constant returns (bool) {
915     return false;
916   }
917 
918   /**
919    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
920    *
921    *
922    * @param value - What is the value of the transaction send in as wei
923    * @param tokensSold - how much tokens have been sold this far
924    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
925    * @param msgSender - who is the investor of this transaction
926    * @param decimals - how many decimal units the token has
927    * @return Amount of tokens the investor receives
928    */
929   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
930 }
931 
932 /**
933  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
934  *
935  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
936  */
937 
938 
939 
940 /**
941  * Safe unsigned safe math.
942  *
943  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
944  *
945  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
946  *
947  * Maintained here until merged to mainline zeppelin-solidity.
948  *
949  */
950 library SafeMathLibExt {
951 
952   function times(uint a, uint b) returns (uint) {
953     uint c = a * b;
954     assert(a == 0 || c / a == b);
955     return c;
956   }
957 
958   function divides(uint a, uint b) returns (uint) {
959     assert(b > 0);
960     uint c = a / b;
961     assert(a == b * c + a % b);
962     return c;
963   }
964 
965   function minus(uint a, uint b) returns (uint) {
966     assert(b <= a);
967     return a - b;
968   }
969 
970   function plus(uint a, uint b) returns (uint) {
971     uint c = a + b;
972     assert(c>=a);
973     return c;
974   }
975 
976 }
977 
978 
979 /**
980  * Fixed crowdsale pricing - everybody gets the same price.
981  */
982 contract FlatPricingExt is PricingStrategy, Ownable {
983 
984   using SafeMathLibExt for uint;
985 
986   /* How many weis one token costs */
987   uint public oneTokenInWei;
988 
989   bool public isUpdatable;
990 
991   address public lastCrowdsale;
992 
993   // Crowdsale rate has been changed
994   event RateChanged(uint newOneTokenInWei);
995 
996   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
997     require(_oneTokenInWei > 0);
998     oneTokenInWei = _oneTokenInWei;
999 
1000     isUpdatable = _isUpdatable;
1001   }
1002 
1003   function setLastCrowdsale(address addr) onlyOwner {
1004     lastCrowdsale = addr;
1005   }
1006 
1007   function updateRate(uint newOneTokenInWei) onlyOwner {
1008     if (!isUpdatable) throw;
1009 
1010     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1011     if (lastCrowdsaleCntrct.finalized()) throw;
1012 
1013     oneTokenInWei = newOneTokenInWei;
1014     RateChanged(newOneTokenInWei);
1015   }
1016 
1017   /**
1018    * Calculate the current price for buy in amount.
1019    *
1020    */
1021   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1022     uint multiplier = 10 ** decimals;
1023     return value.times(multiplier) / oneTokenInWei;
1024   }
1025 
1026 }