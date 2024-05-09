1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
2 pragma solidity ^0.4.11;
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() {
27     owner = msg.sender;
28   }
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) onlyOwner public {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 /**
47  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
48  *
49  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
50  */
51 /**
52  * Safe unsigned safe math.
53  *
54  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
55  *
56  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
57  *
58  * Maintained here until merged to mainline zeppelin-solidity.
59  *
60  */
61 library SafeMathLibExt {
62   function times(uint a, uint b) returns (uint) {
63     uint c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67   function divides(uint a, uint b) returns (uint) {
68     assert(b > 0);
69     uint c = a / b;
70     assert(a == b * c + a % b);
71     return c;
72   }
73   function minus(uint a, uint b) returns (uint) {
74     assert(b <= a);
75     return a - b;
76   }
77   function plus(uint a, uint b) returns (uint) {
78     uint c = a + b;
79     assert(c>=a);
80     return c;
81   }
82 }
83 /**
84  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
85  *
86  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
87  */
88 /**
89  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
90  *
91  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
92  */
93 /**
94  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
95  *
96  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
97  */
98 /*
99  * Haltable
100  *
101  * Abstract contract that allows children to implement an
102  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
103  *
104  *
105  * Originally envisioned in FirstBlood ICO contract.
106  */
107 contract Haltable is Ownable {
108   bool public halted;
109   modifier stopInEmergency {
110     if (halted) throw;
111     _;
112   }
113   modifier stopNonOwnersInEmergency {
114     if (halted && msg.sender != owner) throw;
115     _;
116   }
117   modifier onlyInEmergency {
118     if (!halted) throw;
119     _;
120   }
121   // called by the owner on emergency, triggers stopped state
122   function halt() external onlyOwner {
123     halted = true;
124   }
125   // called by the owner on end of emergency, returns to normal state
126   function unhalt() external onlyOwner onlyInEmergency {
127     halted = false;
128   }
129 }
130 /**
131  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
132  *
133  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
134  */
135 /**
136  * Finalize agent defines what happens at the end of succeseful crowdsale.
137  *
138  * - Allocate tokens for founders, bounties and community
139  * - Make tokens transferable
140  * - etc.
141  */
142 contract FinalizeAgent {
143   function isFinalizeAgent() public constant returns(bool) {
144     return true;
145   }
146   /** Return true if we can run finalizeCrowdsale() properly.
147    *
148    * This is a safety check function that doesn't allow crowdsale to begin
149    * unless the finalizer has been set up properly.
150    */
151   function isSane() public constant returns (bool);
152   /** Called once by crowdsale finalize() if the sale was success. */
153   function finalizeCrowdsale();
154 }
155 /**
156  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
157  *
158  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
159  */
160 /**
161  * @title ERC20 interface
162  * @dev see https://github.com/ethereum/EIPs/issues/20
163  */
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) public constant returns (uint256);
166   function transferFrom(address from, address to, uint256 value) public returns (bool);
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 /**
171  * A token that defines fractional units as decimals.
172  */
173 contract FractionalERC20Ext is ERC20 {
174   uint public decimals;
175   uint public minCap;
176 }
177 /**
178  * Abstract base contract for token sales.
179  *
180  * Handle
181  * - start and end dates
182  * - accepting investments
183  * - minimum funding goal and refund
184  * - various statistics during the crowdfund
185  * - different pricing strategies
186  * - different investment policies (require server side customer id, allow only whitelisted addresses)
187  *
188  */
189 contract CrowdsaleExt is Haltable {
190   /* Max investment count when we are still allowed to change the multisig address */
191   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
192   using SafeMathLibExt for uint;
193   /* The token we are selling */
194   FractionalERC20Ext public token;
195   /* How we are going to price our offering */
196   PricingStrategy public pricingStrategy;
197   /* Post-success callback */
198   FinalizeAgent public finalizeAgent;
199   /* tokens will be transfered from this address */
200   address public multisigWallet;
201   /* if the funding goal is not reached, investors may withdraw their funds */
202   uint public minimumFundingGoal;
203   /* the UNIX timestamp start date of the crowdsale */
204   uint public startsAt;
205   /* the UNIX timestamp end date of the crowdsale */
206   uint public endsAt;
207   /* the number of tokens already sold through this contract*/
208   uint public tokensSold = 0;
209   /* How many wei of funding we have raised */
210   uint public weiRaised = 0;
211   /* Calculate incoming funds from presale contracts and addresses */
212   uint public presaleWeiRaised = 0;
213   /* How many distinct addresses have invested */
214   uint public investorCount = 0;
215   /* How much wei we have returned back to the contract after a failed crowdfund. */
216   uint public loadedRefund = 0;
217   /* How much wei we have given back to investors.*/
218   uint public weiRefunded = 0;
219   /* Has this crowdsale been finalized */
220   bool public finalized;
221   /* Do we need to have unique contributor id for each customer */
222   bool public requireCustomerId;
223   bool public isWhiteListed;
224   address[] public joinedCrowdsales;
225   uint public joinedCrowdsalesLen = 0;
226   address public lastCrowdsale;
227   /**
228     * Do we verify that contributor has been cleared on the server side (accredited investors only).
229     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
230     */
231   bool public requiredSignedAddress;
232   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
233   address public signerAddress;
234   /** How much ETH each address has invested to this crowdsale */
235   mapping (address => uint256) public investedAmountOf;
236   /** How much tokens this crowdsale has credited for each investor address */
237   mapping (address => uint256) public tokenAmountOf;
238   struct WhiteListData {
239     bool status;
240     uint minCap;
241     uint maxCap;
242   }
243   //is crowdsale updatable
244   bool public isUpdatable;
245   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
246   mapping (address => WhiteListData) public earlyParticipantWhitelist;
247   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
248   uint public ownerTestValue;
249   /** State machine
250    *
251    * - Preparing: All contract initialization calls and variables have not been set yet
252    * - Prefunding: We have not passed start time yet
253    * - Funding: Active crowdsale
254    * - Success: Minimum funding goal reached
255    * - Failure: Minimum funding goal not reached before ending time
256    * - Finalized: The finalized has been called and succesfully executed
257    * - Refunding: Refunds are loaded on the contract for reclaim.
258    */
259   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
260   // A new investment was made
261   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
262   // Refund was processed for a contributor
263   event Refund(address investor, uint weiAmount);
264   // The rules were changed what kind of investments we accept
265   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
266   // Address early participation whitelist status changed
267   event Whitelisted(address addr, bool status);
268   // Crowdsale start time has been changed
269   event StartsAtChanged(uint newStartsAt);
270   // Crowdsale end time has been changed
271   event EndsAtChanged(uint newEndsAt);
272   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
273     owner = msg.sender;
274     token = FractionalERC20Ext(_token);
275     setPricingStrategy(_pricingStrategy);
276     multisigWallet = _multisigWallet;
277     if(multisigWallet == 0) {
278         throw;
279     }
280     if(_start == 0) {
281         throw;
282     }
283     startsAt = _start;
284     if(_end == 0) {
285         throw;
286     }
287     endsAt = _end;
288     // Don't mess the dates
289     if(startsAt >= endsAt) {
290         throw;
291     }
292     // Minimum funding goal can be zero
293     minimumFundingGoal = _minimumFundingGoal;
294     isUpdatable = _isUpdatable;
295     isWhiteListed = _isWhiteListed;
296   }
297   /**
298    * Don't expect to just send in money and get tokens.
299    */
300   function() payable {
301     throw;
302   }
303   /**
304    * Make an investment.
305    *
306    * Crowdsale must be running for one to invest.
307    * We must have not pressed the emergency brake.
308    *
309    * @param receiver The Ethereum address who receives the tokens
310    * @param customerId (optional) UUID v4 to track the successful payments on the server side
311    *
312    */
313   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
314     // Determine if it's a good time to accept investment from this participant
315     if(getState() == State.PreFunding) {
316       // Are we whitelisted for early deposit
317       throw;
318     } else if(getState() == State.Funding) {
319       // Retail participants can only come in when the crowdsale is running
320       // pass
321       if(isWhiteListed) {
322         if(!earlyParticipantWhitelist[receiver].status) {
323           throw;
324         }
325       }
326     } else {
327       // Unwanted state
328       throw;
329     }
330     uint weiAmount = msg.value;
331     // Account presale sales separately, so that they do not count against pricing tranches
332     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
333     if(tokenAmount == 0) {
334       // Dust transaction
335       throw;
336     }
337     if(isWhiteListed) {
338       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
339         // tokenAmount < minCap for investor
340         throw;
341       }
342       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
343         // tokenAmount > maxCap for investor
344         throw;
345       }
346       // Check that we did not bust the investor's cap
347       if (isBreakingInvestorCap(receiver, tokenAmount)) {
348         throw;
349       }
350     } else {
351       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
352         throw;
353       }
354     }
355     // Check that we did not bust the cap
356     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
357       throw;
358     }
359     if(investedAmountOf[receiver] == 0) {
360        // A new investor
361        investorCount++;
362     }
363     // Update investor
364     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
365     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
366     // Update totals
367     weiRaised = weiRaised.plus(weiAmount);
368     tokensSold = tokensSold.plus(tokenAmount);
369     if(pricingStrategy.isPresalePurchase(receiver)) {
370         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
371     }
372     assignTokens(receiver, tokenAmount);
373     // Pocket the money
374     if(!multisigWallet.send(weiAmount)) throw;
375     if (isWhiteListed) {
376       uint num = 0;
377       for (var i = 0; i < joinedCrowdsalesLen; i++) {
378         if (this == joinedCrowdsales[i]) 
379           num = i;
380       }
381       if (num + 1 < joinedCrowdsalesLen) {
382         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
383           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
384           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
385         }
386       }
387     }
388     // Tell us invest was success
389     Invested(receiver, weiAmount, tokenAmount, customerId);
390   }
391   /**
392    * Preallocate tokens for the early investors.
393    *
394    * Preallocated tokens have been sold before the actual crowdsale opens.
395    * This function mints the tokens and moves the crowdsale needle.
396    *
397    * Investor count is not handled; it is assumed this goes for multiple investors
398    * and the token distribution happens outside the smart contract flow.
399    *
400    * No money is exchanged, as the crowdsale team already have received the payment.
401    *
402    * @param fullTokens tokens as full tokens - decimal places added internally
403    * @param weiPrice Price of a single full token in wei
404    *
405    */
406   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
407     uint tokenAmount = fullTokens * 10**token.decimals();
408     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
409     weiRaised = weiRaised.plus(weiAmount);
410     tokensSold = tokensSold.plus(tokenAmount);
411     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
412     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
413     assignTokens(receiver, tokenAmount);
414     // Tell us invest was success
415     Invested(receiver, weiAmount, tokenAmount, 0);
416   }
417   /**
418    * Allow anonymous contributions to this crowdsale.
419    */
420   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
421      bytes32 hash = sha256(addr);
422      if (ecrecover(hash, v, r, s) != signerAddress) throw;
423      if(customerId == 0) throw;  // UUIDv4 sanity check
424      investInternal(addr, customerId);
425   }
426   /**
427    * Track who is the customer making the payment so we can send thank you email.
428    */
429   function investWithCustomerId(address addr, uint128 customerId) public payable {
430     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
431     if(customerId == 0) throw;  // UUIDv4 sanity check
432     investInternal(addr, customerId);
433   }
434   /**
435    * Allow anonymous contributions to this crowdsale.
436    */
437   function invest(address addr) public payable {
438     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
439     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
440     investInternal(addr, 0);
441   }
442   /**
443    * Invest to tokens, recognize the payer and clear his address.
444    *
445    */
446   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
447     investWithSignedAddress(msg.sender, customerId, v, r, s);
448   }
449   /**
450    * Invest to tokens, recognize the payer.
451    *
452    */
453   function buyWithCustomerId(uint128 customerId) public payable {
454     investWithCustomerId(msg.sender, customerId);
455   }
456   /**
457    * The basic entry point to participate the crowdsale process.
458    *
459    * Pay for funding, get invested tokens back in the sender address.
460    */
461   function buy() public payable {
462     invest(msg.sender);
463   }
464   /**
465    * Finalize a succcesful crowdsale.
466    *
467    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
468    */
469   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
470     // Already finalized
471     if(finalized) {
472       throw;
473     }
474     // Finalizing is optional. We only call it if we are given a finalizing agent.
475     if(address(finalizeAgent) != 0) {
476       finalizeAgent.finalizeCrowdsale();
477     }
478     finalized = true;
479   }
480   /**
481    * Allow to (re)set finalize agent.
482    *
483    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
484    */
485   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
486     finalizeAgent = addr;
487     // Don't allow setting bad agent
488     if(!finalizeAgent.isFinalizeAgent()) {
489       throw;
490     }
491   }
492   /**
493    * Set policy do we need to have server-side customer ids for the investments.
494    *
495    */
496   function setRequireCustomerId(bool value) onlyOwner {
497     requireCustomerId = value;
498     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
499   }
500   /**
501    * Set policy if all investors must be cleared on the server side first.
502    *
503    * This is e.g. for the accredited investor clearing.
504    *
505    */
506   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
507     requiredSignedAddress = value;
508     signerAddress = _signerAddress;
509     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
510   }
511   /**
512    * Allow addresses to do early participation.
513    *
514    * TODO: Fix spelling error in the name
515    */
516   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
517     if (!isWhiteListed) throw;
518     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
519     Whitelisted(addr, status);
520   }
521   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
522     if (!isWhiteListed) throw;
523     for (uint iterator = 0; iterator < addrs.length; iterator++) {
524       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
525     }
526   }
527   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
528     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
529     if (!isWhiteListed) throw;
530     if (addr != msg.sender && contractAddr != msg.sender) throw;
531     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
532     newMaxCap = newMaxCap.minus(tokensBought);
533     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
534   }
535   function updateJoinedCrowdsales(address addr) onlyOwner {
536     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
537   }
538   function setLastCrowdsale(address addr) onlyOwner {
539     lastCrowdsale = addr;
540   }
541   function clearJoinedCrowdsales() onlyOwner {
542     joinedCrowdsalesLen = 0;
543   }
544   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
545     clearJoinedCrowdsales();
546     for (uint iter = 0; iter < addrs.length; iter++) {
547       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
548           joinedCrowdsales.length += 1;
549       }
550       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
551       if (iter == addrs.length - 1)
552         setLastCrowdsale(addrs[iter]);
553     }
554   }
555   function setStartsAt(uint time) onlyOwner {
556     if (finalized) throw;
557     if (!isUpdatable) throw;
558     if(now > time) {
559       throw; // Don't change past
560     }
561     if(time > endsAt) {
562       throw;
563     }
564     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
565     if (lastCrowdsaleCntrct.finalized()) throw;
566     startsAt = time;
567     StartsAtChanged(startsAt);
568   }
569   /**
570    * Allow crowdsale owner to close early or extend the crowdsale.
571    *
572    * This is useful e.g. for a manual soft cap implementation:
573    * - after X amount is reached determine manual closing
574    *
575    * This may put the crowdsale to an invalid state,
576    * but we trust owners know what they are doing.
577    *
578    */
579   function setEndsAt(uint time) onlyOwner {
580     if (finalized) throw;
581     if (!isUpdatable) throw;
582     if(now > time) {
583       throw; // Don't change past
584     }
585     if(startsAt > time) {
586       throw;
587     }
588     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
589     if (lastCrowdsaleCntrct.finalized()) throw;
590     uint num = 0;
591     for (var i = 0; i < joinedCrowdsalesLen; i++) {
592       if (this == joinedCrowdsales[i]) 
593         num = i;
594     }
595     if (num + 1 < joinedCrowdsalesLen) {
596       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
597         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
598         if (time > crowdsale.startsAt()) throw;
599       }
600     }
601     endsAt = time;
602     EndsAtChanged(endsAt);
603   }
604   /**
605    * Allow to (re)set pricing strategy.
606    *
607    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
608    */
609   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
610     pricingStrategy = _pricingStrategy;
611     // Don't allow setting bad agent
612     if(!pricingStrategy.isPricingStrategy()) {
613       throw;
614     }
615   }
616   /**
617    * Allow to change the team multisig address in the case of emergency.
618    *
619    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
620    * (we have done only few test transactions). After the crowdsale is going
621    * then multisig address stays locked for the safety reasons.
622    */
623   function setMultisig(address addr) public onlyOwner {
624     // Change
625     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
626       throw;
627     }
628     multisigWallet = addr;
629   }
630   /**
631    * Allow load refunds back on the contract for the refunding.
632    *
633    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
634    */
635   function loadRefund() public payable inState(State.Failure) {
636     if(msg.value == 0) throw;
637     loadedRefund = loadedRefund.plus(msg.value);
638   }
639   /**
640    * Investors can claim refund.
641    *
642    * Note that any refunds from proxy buyers should be handled separately,
643    * and not through this contract.
644    */
645   function refund() public inState(State.Refunding) {
646     uint256 weiValue = investedAmountOf[msg.sender];
647     if (weiValue == 0) throw;
648     investedAmountOf[msg.sender] = 0;
649     weiRefunded = weiRefunded.plus(weiValue);
650     Refund(msg.sender, weiValue);
651     if (!msg.sender.send(weiValue)) throw;
652   }
653   /**
654    * @return true if the crowdsale has raised enough money to be a successful.
655    */
656   function isMinimumGoalReached() public constant returns (bool reached) {
657     return weiRaised >= minimumFundingGoal;
658   }
659   /**
660    * Check if the contract relationship looks good.
661    */
662   function isFinalizerSane() public constant returns (bool sane) {
663     return finalizeAgent.isSane();
664   }
665   /**
666    * Check if the contract relationship looks good.
667    */
668   function isPricingSane() public constant returns (bool sane) {
669     return pricingStrategy.isSane(address(this));
670   }
671   /**
672    * Crowdfund state machine management.
673    *
674    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
675    */
676   function getState() public constant returns (State) {
677     if(finalized) return State.Finalized;
678     else if (address(finalizeAgent) == 0) return State.Preparing;
679     else if (!finalizeAgent.isSane()) return State.Preparing;
680     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
681     else if (block.timestamp < startsAt) return State.PreFunding;
682     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
683     else if (isMinimumGoalReached()) return State.Success;
684     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
685     else return State.Failure;
686   }
687   /** This is for manual testing of multisig wallet interaction */
688   function setOwnerTestValue(uint val) onlyOwner {
689     ownerTestValue = val;
690   }
691   /** Interface marker. */
692   function isCrowdsale() public constant returns (bool) {
693     return true;
694   }
695   //
696   // Modifiers
697   //
698   /** Modified allowing execution only if the crowdsale is currently running.  */
699   modifier inState(State state) {
700     if(getState() != state) throw;
701     _;
702   }
703   //
704   // Abstract functions
705   //
706   /**
707    * Check if the current invested breaks our cap rules.
708    *
709    *
710    * The child contract must define their own cap setting rules.
711    * We allow a lot of flexibility through different capping strategies (ETH, token count)
712    * Called from invest().
713    *
714    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
715    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
716    * @param weiRaisedTotal What would be our total raised balance after this transaction
717    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
718    *
719    * @return true if taking this investment would break our cap rules
720    */
721   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
722   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
723   /**
724    * Check if the current crowdsale is full and we can no longer sell any tokens.
725    */
726   function isCrowdsaleFull() public constant returns (bool);
727   /**
728    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
729    */
730   function assignTokens(address receiver, uint tokenAmount) private;
731 }
732 /**
733  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
734  *
735  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
736  */
737 /**
738  * Interface for defining crowdsale pricing.
739  */
740 contract PricingStrategy {
741   /** Interface declaration. */
742   function isPricingStrategy() public constant returns (bool) {
743     return true;
744   }
745   /** Self check if all references are correctly set.
746    *
747    * Checks that pricing strategy matches crowdsale parameters.
748    */
749   function isSane(address crowdsale) public constant returns (bool) {
750     return true;
751   }
752   /**
753    * @dev Pricing tells if this is a presale purchase or not.
754      @param purchaser Address of the purchaser
755      @return False by default, true if a presale purchaser
756    */
757   function isPresalePurchase(address purchaser) public constant returns (bool) {
758     return false;
759   }
760   /**
761    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
762    *
763    *
764    * @param value - What is the value of the transaction send in as wei
765    * @param tokensSold - how much tokens have been sold this far
766    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
767    * @param msgSender - who is the investor of this transaction
768    * @param decimals - how many decimal units the token has
769    * @return Amount of tokens the investor receives
770    */
771   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
772 }
773 /**
774  * Fixed crowdsale pricing - everybody gets the same price.
775  */
776 contract FlatPricingExt is PricingStrategy, Ownable {
777   using SafeMathLibExt for uint;
778   /* How many weis one token costs */
779   uint public oneTokenInWei;
780   bool public isUpdatable;
781   address public lastCrowdsale;
782   // Crowdsale rate has been changed
783   event RateChanged(uint newOneTokenInWei);
784   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
785     require(_oneTokenInWei > 0);
786     oneTokenInWei = _oneTokenInWei;
787     isUpdatable = _isUpdatable;
788   }
789   function setLastCrowdsale(address addr) onlyOwner {
790     lastCrowdsale = addr;
791   }
792   function updateRate(uint newOneTokenInWei) onlyOwner {
793     if (!isUpdatable) throw;
794     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
795     if (lastCrowdsaleCntrct.finalized()) throw;
796     oneTokenInWei = newOneTokenInWei;
797     RateChanged(newOneTokenInWei);
798   }
799   /**
800    * Calculate the current price for buy in amount.
801    *
802    */
803   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
804     uint multiplier = 10 ** decimals;
805     return value.times(multiplier) / oneTokenInWei;
806   }
807 }