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
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 /**
60  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
61  *
62  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
63  */
64 
65 
66 
67 /**
68  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
69  *
70  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
71  */
72 
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
84 
85 
86 /*
87  * Haltable
88  *
89  * Abstract contract that allows children to implement an
90  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
91  *
92  *
93  * Originally envisioned in FirstBlood ICO contract.
94  */
95 contract Haltable is Ownable {
96   bool public halted;
97 
98   modifier stopInEmergency {
99     if (halted) throw;
100     _;
101   }
102 
103   modifier stopNonOwnersInEmergency {
104     if (halted && msg.sender != owner) throw;
105     _;
106   }
107 
108   modifier onlyInEmergency {
109     if (!halted) throw;
110     _;
111   }
112 
113   // called by the owner on emergency, triggers stopped state
114   function halt() external onlyOwner {
115     halted = true;
116   }
117 
118   // called by the owner on end of emergency, returns to normal state
119   function unhalt() external onlyOwner onlyInEmergency {
120     halted = false;
121   }
122 
123 }
124 
125 
126 /**
127  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
128  *
129  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
130  */
131 
132 
133 
134 /**
135  * Finalize agent defines what happens at the end of succeseful crowdsale.
136  *
137  * - Allocate tokens for founders, bounties and community
138  * - Make tokens transferable
139  * - etc.
140  */
141 contract FinalizeAgent {
142 
143   function isFinalizeAgent() public constant returns(bool) {
144     return true;
145   }
146 
147   /** Return true if we can run finalizeCrowdsale() properly.
148    *
149    * This is a safety check function that doesn't allow crowdsale to begin
150    * unless the finalizer has been set up properly.
151    */
152   function isSane() public constant returns (bool);
153 
154   /** Called once by crowdsale finalize() if the sale was success. */
155   function finalizeCrowdsale();
156 
157 }
158 
159 /**
160  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
161  *
162  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
163  */
164 
165 
166 
167 
168 
169 
170 
171 
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public constant returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 
185 /**
186  * A token that defines fractional units as decimals.
187  */
188 contract FractionalERC20Ext is ERC20 {
189 
190   uint public decimals;
191   uint public minCap;
192 
193 }
194 
195 
196 
197 /**
198  * Abstract base contract for token sales.
199  *
200  * Handle
201  * - start and end dates
202  * - accepting investments
203  * - minimum funding goal and refund
204  * - various statistics during the crowdfund
205  * - different pricing strategies
206  * - different investment policies (require server side customer id, allow only whitelisted addresses)
207  *
208  */
209 contract CrowdsaleExt is Haltable {
210 
211   /* Max investment count when we are still allowed to change the multisig address */
212   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
213 
214   using SafeMathLibExt for uint;
215 
216   /* The token we are selling */
217   FractionalERC20Ext public token;
218 
219   /* How we are going to price our offering */
220   PricingStrategy public pricingStrategy;
221 
222   /* Post-success callback */
223   FinalizeAgent public finalizeAgent;
224 
225   /* name of the crowdsale tier */
226   string public name;
227 
228   /* tokens will be transfered from this address */
229   address public multisigWallet;
230 
231   /* if the funding goal is not reached, investors may withdraw their funds */
232   uint public minimumFundingGoal;
233 
234   /* the UNIX timestamp start date of the crowdsale */
235   uint public startsAt;
236 
237   /* the UNIX timestamp end date of the crowdsale */
238   uint public endsAt;
239 
240   /* the number of tokens already sold through this contract*/
241   uint public tokensSold = 0;
242 
243   /* How many wei of funding we have raised */
244   uint public weiRaised = 0;
245 
246   /* Calculate incoming funds from presale contracts and addresses */
247   uint public presaleWeiRaised = 0;
248 
249   /* How many distinct addresses have invested */
250   uint public investorCount = 0;
251 
252   /* How much wei we have returned back to the contract after a failed crowdfund. */
253   uint public loadedRefund = 0;
254 
255   /* How much wei we have given back to investors.*/
256   uint public weiRefunded = 0;
257 
258   /* Has this crowdsale been finalized */
259   bool public finalized;
260 
261   /* Do we need to have unique contributor id for each customer */
262   bool public requireCustomerId;
263 
264   bool public isWhiteListed;
265 
266   address[] public joinedCrowdsales;
267   uint public joinedCrowdsalesLen = 0;
268 
269   address public lastCrowdsale;
270 
271   /**
272     * Do we verify that contributor has been cleared on the server side (accredited investors only).
273     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
274     */
275   bool public requiredSignedAddress;
276 
277   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
278   address public signerAddress;
279 
280   /** How much ETH each address has invested to this crowdsale */
281   mapping (address => uint256) public investedAmountOf;
282 
283   /** How much tokens this crowdsale has credited for each investor address */
284   mapping (address => uint256) public tokenAmountOf;
285 
286   struct WhiteListData {
287     bool status;
288     uint minCap;
289     uint maxCap;
290   }
291 
292   //is crowdsale updatable
293   bool public isUpdatable;
294 
295   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
296   mapping (address => WhiteListData) public earlyParticipantWhitelist;
297 
298   /** List of whitelisted addresses */
299   address[] public whitelistedParticipants;
300 
301   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
302   uint public ownerTestValue;
303 
304   /** State machine
305    *
306    * - Preparing: All contract initialization calls and variables have not been set yet
307    * - Prefunding: We have not passed start time yet
308    * - Funding: Active crowdsale
309    * - Success: Minimum funding goal reached
310    * - Failure: Minimum funding goal not reached before ending time
311    * - Finalized: The finalized has been called and succesfully executed
312    * - Refunding: Refunds are loaded on the contract for reclaim.
313    */
314   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
315 
316   // A new investment was made
317   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
318 
319   // Refund was processed for a contributor
320   event Refund(address investor, uint weiAmount);
321 
322   // The rules were changed what kind of investments we accept
323   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
324 
325   // Address early participation whitelist status changed
326   event Whitelisted(address addr, bool status);
327 
328   // Crowdsale start time has been changed
329   event StartsAtChanged(uint newStartsAt);
330 
331   // Crowdsale end time has been changed
332   event EndsAtChanged(uint newEndsAt);
333 
334   function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
335 
336     owner = msg.sender;
337 
338     name = _name;
339 
340     token = FractionalERC20Ext(_token);
341 
342     setPricingStrategy(_pricingStrategy);
343 
344     multisigWallet = _multisigWallet;
345     if(multisigWallet == 0) {
346         throw;
347     }
348 
349     if(_start == 0) {
350         throw;
351     }
352 
353     startsAt = _start;
354 
355     if(_end == 0) {
356         throw;
357     }
358 
359     endsAt = _end;
360 
361     // Don't mess the dates
362     if(startsAt >= endsAt) {
363         throw;
364     }
365 
366     // Minimum funding goal can be zero
367     minimumFundingGoal = _minimumFundingGoal;
368 
369     isUpdatable = _isUpdatable;
370 
371     isWhiteListed = _isWhiteListed;
372   }
373 
374   /**
375    * Don't expect to just send in money and get tokens.
376    */
377   function() payable {
378     throw;
379   }
380 
381   /**
382    * Make an investment.
383    *
384    * Crowdsale must be running for one to invest.
385    * We must have not pressed the emergency brake.
386    *
387    * @param receiver The Ethereum address who receives the tokens
388    * @param customerId (optional) UUID v4 to track the successful payments on the server side
389    *
390    */
391   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
392 
393     // Determine if it's a good time to accept investment from this participant
394     if(getState() == State.PreFunding) {
395       // Are we whitelisted for early deposit
396       throw;
397     } else if(getState() == State.Funding) {
398       // Retail participants can only come in when the crowdsale is running
399       // pass
400       if(isWhiteListed) {
401         if(!earlyParticipantWhitelist[receiver].status) {
402           throw;
403         }
404       }
405     } else {
406       // Unwanted state
407       throw;
408     }
409 
410     uint weiAmount = msg.value;
411 
412     // Account presale sales separately, so that they do not count against pricing tranches
413     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
414 
415     if(tokenAmount == 0) {
416       // Dust transaction
417       throw;
418     }
419 
420     if(isWhiteListed) {
421       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
422         // tokenAmount < minCap for investor
423         throw;
424       }
425       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
426         // tokenAmount > maxCap for investor
427         throw;
428       }
429 
430       // Check that we did not bust the investor's cap
431       if (isBreakingInvestorCap(receiver, tokenAmount)) {
432         throw;
433       }
434     } else {
435       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
436         throw;
437       }
438     }
439 
440     if(investedAmountOf[receiver] == 0) {
441        // A new investor
442        investorCount++;
443     }
444 
445     // Update investor
446     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
447     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
448 
449     // Update totals
450     weiRaised = weiRaised.plus(weiAmount);
451     tokensSold = tokensSold.plus(tokenAmount);
452 
453     if(pricingStrategy.isPresalePurchase(receiver)) {
454         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
455     }
456 
457     // Check that we did not bust the cap
458     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
459       throw;
460     }
461 
462     assignTokens(receiver, tokenAmount);
463 
464     // Pocket the money
465     if(!multisigWallet.send(weiAmount)) throw;
466 
467     if (isWhiteListed) {
468       uint num = 0;
469       for (var i = 0; i < joinedCrowdsalesLen; i++) {
470         if (this == joinedCrowdsales[i])
471           num = i;
472       }
473 
474       if (num + 1 < joinedCrowdsalesLen) {
475         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
476           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
477           crowdsale.updateEarlyParticipantWhitelist(msg.sender, this, tokenAmount);
478         }
479       }
480     }
481 
482     // Tell us invest was success
483     Invested(receiver, weiAmount, tokenAmount, customerId);
484   }
485 
486   /**
487    * Preallocate tokens for the early investors.
488    *
489    * Preallocated tokens have been sold before the actual crowdsale opens.
490    * This function mints the tokens and moves the crowdsale needle.
491    *
492    * Investor count is not handled; it is assumed this goes for multiple investors
493    * and the token distribution happens outside the smart contract flow.
494    *
495    * No money is exchanged, as the crowdsale team already have received the payment.
496    *
497    * @param fullTokens tokens as full tokens - decimal places added internally
498    * @param weiPrice Price of a single full token in wei
499    *
500    */
501   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
502 
503     uint tokenAmount = fullTokens * 10**token.decimals();
504     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
505 
506     weiRaised = weiRaised.plus(weiAmount);
507     tokensSold = tokensSold.plus(tokenAmount);
508 
509     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
510     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
511 
512     assignTokens(receiver, tokenAmount);
513 
514     // Tell us invest was success
515     Invested(receiver, weiAmount, tokenAmount, 0);
516   }
517 
518   /**
519    * Allow anonymous contributions to this crowdsale.
520    */
521   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
522      bytes32 hash = sha256(addr);
523      if (ecrecover(hash, v, r, s) != signerAddress) throw;
524      if(customerId == 0) throw;  // UUIDv4 sanity check
525      investInternal(addr, customerId);
526   }
527 
528   /**
529    * Track who is the customer making the payment so we can send thank you email.
530    */
531   function investWithCustomerId(address addr, uint128 customerId) public payable {
532     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
533     if(customerId == 0) throw;  // UUIDv4 sanity check
534     investInternal(addr, customerId);
535   }
536 
537   /**
538    * Allow anonymous contributions to this crowdsale.
539    */
540   function invest(address addr) public payable {
541     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
542     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
543     investInternal(addr, 0);
544   }
545 
546   /**
547    * Invest to tokens, recognize the payer and clear his address.
548    *
549    */
550   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
551     investWithSignedAddress(msg.sender, customerId, v, r, s);
552   }
553 
554   /**
555    * Invest to tokens, recognize the payer.
556    *
557    */
558   function buyWithCustomerId(uint128 customerId) public payable {
559     investWithCustomerId(msg.sender, customerId);
560   }
561 
562   /**
563    * The basic entry point to participate the crowdsale process.
564    *
565    * Pay for funding, get invested tokens back in the sender address.
566    */
567   function buy() public payable {
568     invest(msg.sender);
569   }
570 
571   /**
572    * Finalize a succcesful crowdsale.
573    *
574    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
575    */
576   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
577 
578     // Already finalized
579     if(finalized) {
580       throw;
581     }
582 
583     // Finalizing is optional. We only call it if we are given a finalizing agent.
584     if(address(finalizeAgent) != 0) {
585       finalizeAgent.finalizeCrowdsale();
586     }
587 
588     finalized = true;
589   }
590 
591   /**
592    * Allow to (re)set finalize agent.
593    *
594    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
595    */
596   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
597     finalizeAgent = addr;
598 
599     // Don't allow setting bad agent
600     if(!finalizeAgent.isFinalizeAgent()) {
601       throw;
602     }
603   }
604 
605   /**
606    * Set policy do we need to have server-side customer ids for the investments.
607    *
608    */
609   function setRequireCustomerId(bool value) onlyOwner {
610     requireCustomerId = value;
611     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
612   }
613 
614   /**
615    * Set policy if all investors must be cleared on the server side first.
616    *
617    * This is e.g. for the accredited investor clearing.
618    *
619    */
620   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
621     requiredSignedAddress = value;
622     signerAddress = _signerAddress;
623     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
624   }
625 
626   /**
627    * Allow addresses to do early participation.
628    */
629   function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
630     if (!isWhiteListed) throw;
631     assert(addr != address(0));
632     assert(maxCap > 0);
633     assert(minCap <= maxCap);
634 
635     if (earlyParticipantWhitelist[addr].maxCap == 0) {
636       earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
637       whitelistedParticipants.push(addr);
638       Whitelisted(addr, status);
639     }
640   }
641 
642   function setEarlyParticipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
643     if (!isWhiteListed) throw;
644     for (uint iterator = 0; iterator < addrs.length; iterator++) {
645       setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
646     }
647   }
648 
649   function updateEarlyParticipantWhitelist(address addr, address contractAddr, uint tokensBought) {
650     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
651     if (!isWhiteListed) throw;
652     if (addr != msg.sender && contractAddr != msg.sender) throw;
653     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
654     newMaxCap = newMaxCap.minus(tokensBought);
655     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
656   }
657 
658   function updateJoinedCrowdsales(address addr) onlyOwner {
659     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
660   }
661 
662   function setLastCrowdsale(address addr) onlyOwner {
663     lastCrowdsale = addr;
664   }
665 
666   function clearJoinedCrowdsales() onlyOwner {
667     joinedCrowdsalesLen = 0;
668   }
669 
670   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
671     clearJoinedCrowdsales();
672     for (uint iter = 0; iter < addrs.length; iter++) {
673       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
674           joinedCrowdsales.length += 1;
675       }
676       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
677       if (iter == addrs.length - 1)
678         setLastCrowdsale(addrs[iter]);
679     }
680   }
681 
682   function setStartsAt(uint time) onlyOwner {
683     if (finalized) throw;
684 
685     if (!isUpdatable) throw;
686 
687     if(now > time) {
688       throw; // Don't change past
689     }
690 
691     if(time > endsAt) {
692       throw;
693     }
694 
695     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
696     if (lastCrowdsaleCntrct.finalized()) throw;
697 
698     startsAt = time;
699     StartsAtChanged(startsAt);
700   }
701 
702   /**
703    * Allow crowdsale owner to close early or extend the crowdsale.
704    *
705    * This is useful e.g. for a manual soft cap implementation:
706    * - after X amount is reached determine manual closing
707    *
708    * This may put the crowdsale to an invalid state,
709    * but we trust owners know what they are doing.
710    *
711    */
712   function setEndsAt(uint time) onlyOwner {
713     if (finalized) throw;
714 
715     if (!isUpdatable) throw;
716 
717     if(now > time) {
718       throw; // Don't change past
719     }
720 
721     if(startsAt > time) {
722       throw;
723     }
724 
725     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
726     if (lastCrowdsaleCntrct.finalized()) throw;
727 
728     uint num = 0;
729     for (var i = 0; i < joinedCrowdsalesLen; i++) {
730       if (this == joinedCrowdsales[i])
731         num = i;
732     }
733 
734     if (num + 1 < joinedCrowdsalesLen) {
735       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
736         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
737         if (time > crowdsale.startsAt()) throw;
738       }
739     }
740 
741     endsAt = time;
742     EndsAtChanged(endsAt);
743   }
744 
745   /**
746    * Allow to (re)set pricing strategy.
747    *
748    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
749    */
750   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
751     pricingStrategy = _pricingStrategy;
752 
753     // Don't allow setting bad agent
754     if(!pricingStrategy.isPricingStrategy()) {
755       throw;
756     }
757   }
758 
759   /**
760    * Allow to change the team multisig address in the case of emergency.
761    *
762    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
763    * (we have done only few test transactions). After the crowdsale is going
764    * then multisig address stays locked for the safety reasons.
765    */
766   function setMultisig(address addr) public onlyOwner {
767 
768     // Change
769     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
770       throw;
771     }
772 
773     multisigWallet = addr;
774   }
775 
776   /**
777    * Allow load refunds back on the contract for the refunding.
778    *
779    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
780    */
781   function loadRefund() public payable inState(State.Failure) {
782     if(msg.value == 0) throw;
783     loadedRefund = loadedRefund.plus(msg.value);
784   }
785 
786   /**
787    * Investors can claim refund.
788    *
789    * Note that any refunds from proxy buyers should be handled separately,
790    * and not through this contract.
791    */
792   function refund() public inState(State.Refunding) {
793     uint256 weiValue = investedAmountOf[msg.sender];
794     if (weiValue == 0) throw;
795     investedAmountOf[msg.sender] = 0;
796     weiRefunded = weiRefunded.plus(weiValue);
797     Refund(msg.sender, weiValue);
798     if (!msg.sender.send(weiValue)) throw;
799   }
800 
801   /**
802    * @return true if the crowdsale has raised enough money to be a successful.
803    */
804   function isMinimumGoalReached() public constant returns (bool reached) {
805     return weiRaised >= minimumFundingGoal;
806   }
807 
808   /**
809    * Check if the contract relationship looks good.
810    */
811   function isFinalizerSane() public constant returns (bool sane) {
812     return finalizeAgent.isSane();
813   }
814 
815   /**
816    * Check if the contract relationship looks good.
817    */
818   function isPricingSane() public constant returns (bool sane) {
819     return pricingStrategy.isSane(address(this));
820   }
821 
822   /**
823    * Crowdfund state machine management.
824    *
825    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
826    */
827   function getState() public constant returns (State) {
828     if(finalized) return State.Finalized;
829     else if (address(finalizeAgent) == 0) return State.Preparing;
830     else if (!finalizeAgent.isSane()) return State.Preparing;
831     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
832     else if (block.timestamp < startsAt) return State.PreFunding;
833     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
834     else if (isMinimumGoalReached()) return State.Success;
835     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
836     else return State.Failure;
837   }
838 
839   /** This is for manual testing of multisig wallet interaction */
840   function setOwnerTestValue(uint val) onlyOwner {
841     ownerTestValue = val;
842   }
843 
844   /** Interface marker. */
845   function isCrowdsale() public constant returns (bool) {
846     return true;
847   }
848 
849   //
850   // Modifiers
851   //
852 
853   /** Modified allowing execution only if the crowdsale is currently running.  */
854   modifier inState(State state) {
855     if(getState() != state) throw;
856     _;
857   }
858 
859 
860   //
861   // Abstract functions
862   //
863 
864   /**
865    * Check if the current invested breaks our cap rules.
866    *
867    *
868    * The child contract must define their own cap setting rules.
869    * We allow a lot of flexibility through different capping strategies (ETH, token count)
870    * Called from invest().
871    *
872    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
873    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
874    * @param weiRaisedTotal What would be our total raised balance after this transaction
875    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
876    *
877    * @return true if taking this investment would break our cap rules
878    */
879   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
880 
881   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
882 
883   /**
884    * Check if the current crowdsale is full and we can no longer sell any tokens.
885    */
886   function isCrowdsaleFull() public constant returns (bool);
887 
888   /**
889    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
890    */
891   function assignTokens(address receiver, uint tokenAmount) private;
892 
893   function whitelistedParticipantsLength() public constant returns (uint) {
894     return whitelistedParticipants.length;
895   }
896 }
897 
898 
899 /**
900  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
901  *
902  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
903  */
904 
905 
906 
907 /**
908  * Interface for defining crowdsale pricing.
909  */
910 contract PricingStrategy {
911 
912   /** Interface declaration. */
913   function isPricingStrategy() public constant returns (bool) {
914     return true;
915   }
916 
917   /** Self check if all references are correctly set.
918    *
919    * Checks that pricing strategy matches crowdsale parameters.
920    */
921   function isSane(address crowdsale) public constant returns (bool) {
922     return true;
923   }
924 
925   /**
926    * @dev Pricing tells if this is a presale purchase or not.
927      @param purchaser Address of the purchaser
928      @return False by default, true if a presale purchaser
929    */
930   function isPresalePurchase(address purchaser) public constant returns (bool) {
931     return false;
932   }
933 
934   /**
935    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
936    *
937    *
938    * @param value - What is the value of the transaction send in as wei
939    * @param tokensSold - how much tokens have been sold this far
940    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
941    * @param msgSender - who is the investor of this transaction
942    * @param decimals - how many decimal units the token has
943    * @return Amount of tokens the investor receives
944    */
945   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
946 }
947 
948 /**
949  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
950  *
951  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
952  */
953 
954 
955 
956 /**
957  * Safe unsigned safe math.
958  *
959  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
960  *
961  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
962  *
963  * Maintained here until merged to mainline zeppelin-solidity.
964  *
965  */
966 library SafeMathLibExt {
967 
968   function times(uint a, uint b) returns (uint) {
969     uint c = a * b;
970     assert(a == 0 || c / a == b);
971     return c;
972   }
973 
974   function divides(uint a, uint b) returns (uint) {
975     assert(b > 0);
976     uint c = a / b;
977     assert(a == b * c + a % b);
978     return c;
979   }
980 
981   function minus(uint a, uint b) returns (uint) {
982     assert(b <= a);
983     return a - b;
984   }
985 
986   function plus(uint a, uint b) returns (uint) {
987     uint c = a + b;
988     assert(c>=a);
989     return c;
990   }
991 
992 }
993 
994 
995 /**
996  * Fixed crowdsale pricing - everybody gets the same price.
997  */
998 contract FlatPricingExt is PricingStrategy, Ownable {
999 
1000   using SafeMathLibExt for uint;
1001 
1002   /* How many weis one token costs */
1003   uint public oneTokenInWei;
1004 
1005   bool public isUpdatable;
1006 
1007   address public lastCrowdsale;
1008 
1009   // Crowdsale rate has been changed
1010   event RateChanged(uint newOneTokenInWei);
1011 
1012   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
1013     require(_oneTokenInWei > 0);
1014     oneTokenInWei = _oneTokenInWei;
1015 
1016     isUpdatable = _isUpdatable;
1017   }
1018 
1019   function setLastCrowdsale(address addr) onlyOwner {
1020     lastCrowdsale = addr;
1021   }
1022 
1023   function updateRate(uint newOneTokenInWei) onlyOwner {
1024     if (!isUpdatable) throw;
1025 
1026     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1027     if (lastCrowdsaleCntrct.finalized()) throw;
1028 
1029     oneTokenInWei = newOneTokenInWei;
1030     RateChanged(newOneTokenInWei);
1031   }
1032 
1033   /**
1034    * Calculate the current price for buy in amount.
1035    *
1036    */
1037   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1038     uint multiplier = 10 ** decimals;
1039     return value.times(multiplier) / oneTokenInWei;
1040   }
1041 
1042 }