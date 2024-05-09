1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
47  *
48  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
49  */
50 /**
51  * Safe unsigned safe math.
52  *
53  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
54  *
55  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
56  *
57  * Maintained here until merged to mainline zeppelin-solidity.
58  *
59  */
60 library SafeMathLibExt {
61   function times(uint a, uint b) returns (uint) {
62     uint c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66   function divides(uint a, uint b) returns (uint) {
67     assert(b > 0);
68     uint c = a / b;
69     assert(a == b * c + a % b);
70     return c;
71   }
72   function minus(uint a, uint b) returns (uint) {
73     assert(b <= a);
74     return a - b;
75   }
76   function plus(uint a, uint b) returns (uint) {
77     uint c = a + b;
78     assert(c>=a);
79     return c;
80   }
81 }
82 /**
83  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
84  *
85  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
86  */
87 /**
88  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
89  *
90  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
91  */
92 /**
93  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
94  *
95  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
96  */
97 /*
98  * Haltable
99  *
100  * Abstract contract that allows children to implement an
101  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
102  *
103  *
104  * Originally envisioned in FirstBlood ICO contract.
105  */
106 contract Haltable is Ownable {
107   bool public halted;
108   modifier stopInEmergency {
109     if (halted) throw;
110     _;
111   }
112   modifier stopNonOwnersInEmergency {
113     if (halted && msg.sender != owner) throw;
114     _;
115   }
116   modifier onlyInEmergency {
117     if (!halted) throw;
118     _;
119   }
120   // called by the owner on emergency, triggers stopped state
121   function halt() external onlyOwner {
122     halted = true;
123   }
124   // called by the owner on end of emergency, returns to normal state
125   function unhalt() external onlyOwner onlyInEmergency {
126     halted = false;
127   }
128 }
129 /**
130  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
131  *
132  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
133  */
134 /**
135  * Finalize agent defines what happens at the end of succeseful crowdsale.
136  *
137  * - Allocate tokens for founders, bounties and community
138  * - Make tokens transferable
139  * - etc.
140  */
141 contract FinalizeAgent {
142   function isFinalizeAgent() public constant returns(bool) {
143     return true;
144   }
145   /** Return true if we can run finalizeCrowdsale() properly.
146    *
147    * This is a safety check function that doesn't allow crowdsale to begin
148    * unless the finalizer has been set up properly.
149    */
150   function isSane() public constant returns (bool);
151   /** Called once by crowdsale finalize() if the sale was success. */
152   function finalizeCrowdsale();
153 }
154 /**
155  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
156  *
157  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
158  */
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164   function allowance(address owner, address spender) public constant returns (uint256);
165   function transferFrom(address from, address to, uint256 value) public returns (bool);
166   function approve(address spender, uint256 value) public returns (bool);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 /**
170  * A token that defines fractional units as decimals.
171  */
172 contract FractionalERC20Ext is ERC20 {
173   uint public decimals;
174   uint public minCap;
175 }
176 /**
177  * Abstract base contract for token sales.
178  *
179  * Handle
180  * - start and end dates
181  * - accepting investments
182  * - minimum funding goal and refund
183  * - various statistics during the crowdfund
184  * - different pricing strategies
185  * - different investment policies (require server side customer id, allow only whitelisted addresses)
186  *
187  */
188 contract CrowdsaleExt is Haltable {
189   /* Max investment count when we are still allowed to change the multisig address */
190   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
191   using SafeMathLibExt for uint;
192   /* The token we are selling */
193   FractionalERC20Ext public token;
194   /* How we are going to price our offering */
195   PricingStrategy public pricingStrategy;
196   /* Post-success callback */
197   FinalizeAgent public finalizeAgent;
198   /* tokens will be transfered from this address */
199   address public multisigWallet;
200   /* if the funding goal is not reached, investors may withdraw their funds */
201   uint public minimumFundingGoal;
202   /* the UNIX timestamp start date of the crowdsale */
203   uint public startsAt;
204   /* the UNIX timestamp end date of the crowdsale */
205   uint public endsAt;
206   /* the number of tokens already sold through this contract*/
207   uint public tokensSold = 0;
208   /* How many wei of funding we have raised */
209   uint public weiRaised = 0;
210   /* Calculate incoming funds from presale contracts and addresses */
211   uint public presaleWeiRaised = 0;
212   /* How many distinct addresses have invested */
213   uint public investorCount = 0;
214   /* How much wei we have returned back to the contract after a failed crowdfund. */
215   uint public loadedRefund = 0;
216   /* How much wei we have given back to investors.*/
217   uint public weiRefunded = 0;
218   /* Has this crowdsale been finalized */
219   bool public finalized;
220   /* Do we need to have unique contributor id for each customer */
221   bool public requireCustomerId;
222   bool public isWhiteListed;
223   address[] public joinedCrowdsales;
224   uint public joinedCrowdsalesLen = 0;
225   address public lastCrowdsale;
226   /**
227     * Do we verify that contributor has been cleared on the server side (accredited investors only).
228     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
229     */
230   bool public requiredSignedAddress;
231   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
232   address public signerAddress;
233   /** How much ETH each address has invested to this crowdsale */
234   mapping (address => uint256) public investedAmountOf;
235   /** How much tokens this crowdsale has credited for each investor address */
236   mapping (address => uint256) public tokenAmountOf;
237   struct WhiteListData {
238     bool status;
239     uint minCap;
240     uint maxCap;
241   }
242   //is crowdsale updatable
243   bool public isUpdatable;
244   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
245   mapping (address => WhiteListData) public earlyParticipantWhitelist;
246   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
247   uint public ownerTestValue;
248   /** State machine
249    *
250    * - Preparing: All contract initialization calls and variables have not been set yet
251    * - Prefunding: We have not passed start time yet
252    * - Funding: Active crowdsale
253    * - Success: Minimum funding goal reached
254    * - Failure: Minimum funding goal not reached before ending time
255    * - Finalized: The finalized has been called and succesfully executed
256    * - Refunding: Refunds are loaded on the contract for reclaim.
257    */
258   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
259   // A new investment was made
260   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
261   // Refund was processed for a contributor
262   event Refund(address investor, uint weiAmount);
263   // The rules were changed what kind of investments we accept
264   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
265   // Address early participation whitelist status changed
266   event Whitelisted(address addr, bool status);
267   // Crowdsale start time has been changed
268   event StartsAtChanged(uint newStartsAt);
269   // Crowdsale end time has been changed
270   event EndsAtChanged(uint newEndsAt);
271   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
272     owner = msg.sender;
273     token = FractionalERC20Ext(_token);
274     setPricingStrategy(_pricingStrategy);
275     multisigWallet = _multisigWallet;
276     if(multisigWallet == 0) {
277         throw;
278     }
279     if(_start == 0) {
280         throw;
281     }
282     startsAt = _start;
283     if(_end == 0) {
284         throw;
285     }
286     endsAt = _end;
287     // Don't mess the dates
288     if(startsAt >= endsAt) {
289         throw;
290     }
291     // Minimum funding goal can be zero
292     minimumFundingGoal = _minimumFundingGoal;
293     isUpdatable = _isUpdatable;
294     isWhiteListed = _isWhiteListed;
295   }
296   /**
297    * Don't expect to just send in money and get tokens.
298    */
299   function() payable {
300     throw;
301   }
302   /**
303    * Make an investment.
304    *
305    * Crowdsale must be running for one to invest.
306    * We must have not pressed the emergency brake.
307    *
308    * @param receiver The Ethereum address who receives the tokens
309    * @param customerId (optional) UUID v4 to track the successful payments on the server side
310    *
311    */
312   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
313     // Determine if it's a good time to accept investment from this participant
314     if(getState() == State.PreFunding) {
315       // Are we whitelisted for early deposit
316       throw;
317     } else if(getState() == State.Funding) {
318       // Retail participants can only come in when the crowdsale is running
319       // pass
320       if(isWhiteListed) {
321         if(!earlyParticipantWhitelist[receiver].status) {
322           throw;
323         }
324       }
325     } else {
326       // Unwanted state
327       throw;
328     }
329     uint weiAmount = msg.value;
330     // Account presale sales separately, so that they do not count against pricing tranches
331     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
332     if(tokenAmount == 0) {
333       // Dust transaction
334       throw;
335     }
336     if(isWhiteListed) {
337       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
338         // tokenAmount < minCap for investor
339         throw;
340       }
341       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
342         // tokenAmount > maxCap for investor
343         throw;
344       }
345       // Check that we did not bust the investor's cap
346       if (isBreakingInvestorCap(receiver, tokenAmount)) {
347         throw;
348       }
349     } else {
350       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
351         throw;
352       }
353     }
354     // Check that we did not bust the cap
355     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
356       throw;
357     }
358     if(investedAmountOf[receiver] == 0) {
359        // A new investor
360        investorCount++;
361     }
362     // Update investor
363     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
364     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
365     // Update totals
366     weiRaised = weiRaised.plus(weiAmount);
367     tokensSold = tokensSold.plus(tokenAmount);
368     if(pricingStrategy.isPresalePurchase(receiver)) {
369         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
370     }
371     assignTokens(receiver, tokenAmount);
372     // Pocket the money
373     if(!multisigWallet.send(weiAmount)) throw;
374     if (isWhiteListed) {
375       uint num = 0;
376       for (var i = 0; i < joinedCrowdsalesLen; i++) {
377         if (this == joinedCrowdsales[i]) 
378           num = i;
379       }
380       if (num + 1 < joinedCrowdsalesLen) {
381         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
382           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
383           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
384         }
385       }
386     }
387     // Tell us invest was success
388     Invested(receiver, weiAmount, tokenAmount, customerId);
389   }
390   /**
391    * Preallocate tokens for the early investors.
392    *
393    * Preallocated tokens have been sold before the actual crowdsale opens.
394    * This function mints the tokens and moves the crowdsale needle.
395    *
396    * Investor count is not handled; it is assumed this goes for multiple investors
397    * and the token distribution happens outside the smart contract flow.
398    *
399    * No money is exchanged, as the crowdsale team already have received the payment.
400    *
401    * @param fullTokens tokens as full tokens - decimal places added internally
402    * @param weiPrice Price of a single full token in wei
403    *
404    */
405   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
406     uint tokenAmount = fullTokens * 10**token.decimals();
407     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
408     weiRaised = weiRaised.plus(weiAmount);
409     tokensSold = tokensSold.plus(tokenAmount);
410     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
411     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
412     assignTokens(receiver, tokenAmount);
413     // Tell us invest was success
414     Invested(receiver, weiAmount, tokenAmount, 0);
415   }
416   /**
417    * Allow anonymous contributions to this crowdsale.
418    */
419   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
420      bytes32 hash = sha256(addr);
421      if (ecrecover(hash, v, r, s) != signerAddress) throw;
422      if(customerId == 0) throw;  // UUIDv4 sanity check
423      investInternal(addr, customerId);
424   }
425   /**
426    * Track who is the customer making the payment so we can send thank you email.
427    */
428   function investWithCustomerId(address addr, uint128 customerId) public payable {
429     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
430     if(customerId == 0) throw;  // UUIDv4 sanity check
431     investInternal(addr, customerId);
432   }
433   /**
434    * Allow anonymous contributions to this crowdsale.
435    */
436   function invest(address addr) public payable {
437     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
438     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
439     investInternal(addr, 0);
440   }
441   /**
442    * Invest to tokens, recognize the payer and clear his address.
443    *
444    */
445   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
446     investWithSignedAddress(msg.sender, customerId, v, r, s);
447   }
448   /**
449    * Invest to tokens, recognize the payer.
450    *
451    */
452   function buyWithCustomerId(uint128 customerId) public payable {
453     investWithCustomerId(msg.sender, customerId);
454   }
455   /**
456    * The basic entry point to participate the crowdsale process.
457    *
458    * Pay for funding, get invested tokens back in the sender address.
459    */
460   function buy() public payable {
461     invest(msg.sender);
462   }
463   /**
464    * Finalize a succcesful crowdsale.
465    *
466    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
467    */
468   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
469     // Already finalized
470     if(finalized) {
471       throw;
472     }
473     // Finalizing is optional. We only call it if we are given a finalizing agent.
474     if(address(finalizeAgent) != 0) {
475       finalizeAgent.finalizeCrowdsale();
476     }
477     finalized = true;
478   }
479   /**
480    * Allow to (re)set finalize agent.
481    *
482    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
483    */
484   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
485     finalizeAgent = addr;
486     // Don't allow setting bad agent
487     if(!finalizeAgent.isFinalizeAgent()) {
488       throw;
489     }
490   }
491   /**
492    * Set policy do we need to have server-side customer ids for the investments.
493    *
494    */
495   function setRequireCustomerId(bool value) onlyOwner {
496     requireCustomerId = value;
497     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
498   }
499   /**
500    * Set policy if all investors must be cleared on the server side first.
501    *
502    * This is e.g. for the accredited investor clearing.
503    *
504    */
505   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
506     requiredSignedAddress = value;
507     signerAddress = _signerAddress;
508     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
509   }
510   /**
511    * Allow addresses to do early participation.
512    *
513    * TODO: Fix spelling error in the name
514    */
515   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
516     if (!isWhiteListed) throw;
517     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
518     Whitelisted(addr, status);
519   }
520   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
521     if (!isWhiteListed) throw;
522     for (uint iterator = 0; iterator < addrs.length; iterator++) {
523       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
524     }
525   }
526   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
527     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
528     if (!isWhiteListed) throw;
529     if (addr != msg.sender && contractAddr != msg.sender) throw;
530     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
531     newMaxCap = newMaxCap.minus(tokensBought);
532     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
533   }
534   function updateJoinedCrowdsales(address addr) onlyOwner {
535     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
536   }
537   function setLastCrowdsale(address addr) onlyOwner {
538     lastCrowdsale = addr;
539   }
540   function clearJoinedCrowdsales() onlyOwner {
541     joinedCrowdsalesLen = 0;
542   }
543   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
544     clearJoinedCrowdsales();
545     for (uint iter = 0; iter < addrs.length; iter++) {
546       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
547           joinedCrowdsales.length += 1;
548       }
549       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
550       if (iter == addrs.length - 1)
551         setLastCrowdsale(addrs[iter]);
552     }
553   }
554   function setStartsAt(uint time) onlyOwner {
555     if (finalized) throw;
556     if (!isUpdatable) throw;
557     if(now > time) {
558       throw; // Don't change past
559     }
560     if(time > endsAt) {
561       throw;
562     }
563     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
564     if (lastCrowdsaleCntrct.finalized()) throw;
565     startsAt = time;
566     StartsAtChanged(startsAt);
567   }
568   /**
569    * Allow crowdsale owner to close early or extend the crowdsale.
570    *
571    * This is useful e.g. for a manual soft cap implementation:
572    * - after X amount is reached determine manual closing
573    *
574    * This may put the crowdsale to an invalid state,
575    * but we trust owners know what they are doing.
576    *
577    */
578   function setEndsAt(uint time) onlyOwner {
579     if (finalized) throw;
580     if (!isUpdatable) throw;
581     if(now > time) {
582       throw; // Don't change past
583     }
584     if(startsAt > time) {
585       throw;
586     }
587     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
588     if (lastCrowdsaleCntrct.finalized()) throw;
589     uint num = 0;
590     for (var i = 0; i < joinedCrowdsalesLen; i++) {
591       if (this == joinedCrowdsales[i]) 
592         num = i;
593     }
594     if (num + 1 < joinedCrowdsalesLen) {
595       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
596         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
597         if (time > crowdsale.startsAt()) throw;
598       }
599     }
600     endsAt = time;
601     EndsAtChanged(endsAt);
602   }
603   /**
604    * Allow to (re)set pricing strategy.
605    *
606    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
607    */
608   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
609     pricingStrategy = _pricingStrategy;
610     // Don't allow setting bad agent
611     if(!pricingStrategy.isPricingStrategy()) {
612       throw;
613     }
614   }
615   /**
616    * Allow to change the team multisig address in the case of emergency.
617    *
618    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
619    * (we have done only few test transactions). After the crowdsale is going
620    * then multisig address stays locked for the safety reasons.
621    */
622   function setMultisig(address addr) public onlyOwner {
623     // Change
624     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
625       throw;
626     }
627     multisigWallet = addr;
628   }
629   /**
630    * Allow load refunds back on the contract for the refunding.
631    *
632    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
633    */
634   function loadRefund() public payable inState(State.Failure) {
635     if(msg.value == 0) throw;
636     loadedRefund = loadedRefund.plus(msg.value);
637   }
638   /**
639    * Investors can claim refund.
640    *
641    * Note that any refunds from proxy buyers should be handled separately,
642    * and not through this contract.
643    */
644   function refund() public inState(State.Refunding) {
645     uint256 weiValue = investedAmountOf[msg.sender];
646     if (weiValue == 0) throw;
647     investedAmountOf[msg.sender] = 0;
648     weiRefunded = weiRefunded.plus(weiValue);
649     Refund(msg.sender, weiValue);
650     if (!msg.sender.send(weiValue)) throw;
651   }
652   /**
653    * @return true if the crowdsale has raised enough money to be a successful.
654    */
655   function isMinimumGoalReached() public constant returns (bool reached) {
656     return weiRaised >= minimumFundingGoal;
657   }
658   /**
659    * Check if the contract relationship looks good.
660    */
661   function isFinalizerSane() public constant returns (bool sane) {
662     return finalizeAgent.isSane();
663   }
664   /**
665    * Check if the contract relationship looks good.
666    */
667   function isPricingSane() public constant returns (bool sane) {
668     return pricingStrategy.isSane(address(this));
669   }
670   /**
671    * Crowdfund state machine management.
672    *
673    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
674    */
675   function getState() public constant returns (State) {
676     if(finalized) return State.Finalized;
677     else if (address(finalizeAgent) == 0) return State.Preparing;
678     else if (!finalizeAgent.isSane()) return State.Preparing;
679     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
680     else if (block.timestamp < startsAt) return State.PreFunding;
681     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
682     else if (isMinimumGoalReached()) return State.Success;
683     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
684     else return State.Failure;
685   }
686   /** This is for manual testing of multisig wallet interaction */
687   function setOwnerTestValue(uint val) onlyOwner {
688     ownerTestValue = val;
689   }
690   /** Interface marker. */
691   function isCrowdsale() public constant returns (bool) {
692     return true;
693   }
694   //
695   // Modifiers
696   //
697   /** Modified allowing execution only if the crowdsale is currently running.  */
698   modifier inState(State state) {
699     if(getState() != state) throw;
700     _;
701   }
702   //
703   // Abstract functions
704   //
705   /**
706    * Check if the current invested breaks our cap rules.
707    *
708    *
709    * The child contract must define their own cap setting rules.
710    * We allow a lot of flexibility through different capping strategies (ETH, token count)
711    * Called from invest().
712    *
713    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
714    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
715    * @param weiRaisedTotal What would be our total raised balance after this transaction
716    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
717    *
718    * @return true if taking this investment would break our cap rules
719    */
720   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
721   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
722   /**
723    * Check if the current crowdsale is full and we can no longer sell any tokens.
724    */
725   function isCrowdsaleFull() public constant returns (bool);
726   /**
727    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
728    */
729   function assignTokens(address receiver, uint tokenAmount) private;
730 }
731 /**
732  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
733  *
734  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
735  */
736 /**
737  * Interface for defining crowdsale pricing.
738  */
739 contract PricingStrategy {
740   /** Interface declaration. */
741   function isPricingStrategy() public constant returns (bool) {
742     return true;
743   }
744   /** Self check if all references are correctly set.
745    *
746    * Checks that pricing strategy matches crowdsale parameters.
747    */
748   function isSane(address crowdsale) public constant returns (bool) {
749     return true;
750   }
751   /**
752    * @dev Pricing tells if this is a presale purchase or not.
753      @param purchaser Address of the purchaser
754      @return False by default, true if a presale purchaser
755    */
756   function isPresalePurchase(address purchaser) public constant returns (bool) {
757     return false;
758   }
759   /**
760    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
761    *
762    *
763    * @param value - What is the value of the transaction send in as wei
764    * @param tokensSold - how much tokens have been sold this far
765    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
766    * @param msgSender - who is the investor of this transaction
767    * @param decimals - how many decimal units the token has
768    * @return Amount of tokens the investor receives
769    */
770   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
771 }
772 /**
773  * Fixed crowdsale pricing - everybody gets the same price.
774  */
775 contract FlatPricingExt is PricingStrategy, Ownable {
776   using SafeMathLibExt for uint;
777   /* How many weis one token costs */
778   uint public oneTokenInWei;
779   bool public isUpdatable;
780   address public lastCrowdsale;
781   // Crowdsale rate has been changed
782   event RateChanged(uint newOneTokenInWei);
783   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
784     require(_oneTokenInWei > 0);
785     oneTokenInWei = _oneTokenInWei;
786     isUpdatable = _isUpdatable;
787   }
788   function setLastCrowdsale(address addr) onlyOwner {
789     lastCrowdsale = addr;
790   }
791   function updateRate(uint newOneTokenInWei) onlyOwner {
792     if (!isUpdatable) throw;
793     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
794     if (lastCrowdsaleCntrct.finalized()) throw;
795     oneTokenInWei = newOneTokenInWei;
796     RateChanged(newOneTokenInWei);
797   }
798   /**
799    * Calculate the current price for buy in amount.
800    *
801    */
802   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
803     uint multiplier = 10 ** decimals;
804     return value.times(multiplier) / oneTokenInWei;
805   }
806 }