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
226   /// Event created on money deposit.
227   event Deposit (address recipient, uint value);
228   /**
229     * Do we verify that contributor has been cleared on the server side (accredited investors only).
230     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
231     */
232   bool public requiredSignedAddress;
233   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
234   address public signerAddress;
235   /** How much ETH each address has invested to this crowdsale */
236   mapping (address => uint256) public investedAmountOf;
237   /** How much tokens this crowdsale has credited for each investor address */
238   mapping (address => uint256) public tokenAmountOf;
239   struct WhiteListData {
240     bool status;
241     uint minCap;
242     uint maxCap;
243   }
244   //is crowdsale updatable
245   bool public isUpdatable;
246   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
247   mapping (address => WhiteListData) public earlyParticipantWhitelist;
248   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
249   uint public ownerTestValue;
250   /** State machine
251    *
252    * - Preparing: All contract initialization calls and variables have not been set yet
253    * - Prefunding: We have not passed start time yet
254    * - Funding: Active crowdsale
255    * - Success: Minimum funding goal reached
256    * - Failure: Minimum funding goal not reached before ending time
257    * - Finalized: The finalized has been called and succesfully executed
258    * - Refunding: Refunds are loaded on the contract for reclaim.
259    */
260   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
261   // A new investment was made
262   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
263   // Refund was processed for a contributor
264   event Refund(address investor, uint weiAmount);
265   // The rules were changed what kind of investments we accept
266   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
267   // Address early participation whitelist status changed
268   event Whitelisted(address addr, bool status);
269   // Crowdsale start time has been changed
270   event StartsAtChanged(uint newStartsAt);
271   // Crowdsale end time has been changed
272   event EndsAtChanged(uint newEndsAt);
273   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
274     owner = msg.sender;
275     token = FractionalERC20Ext(_token);
276     setPricingStrategy(_pricingStrategy);
277     multisigWallet = _multisigWallet;
278     if(multisigWallet == 0) {
279         throw;
280     }
281     if(_start == 0) {
282         throw;
283     }
284     startsAt = _start;
285     if(_end == 0) {
286         throw;
287     }
288     endsAt = _end;
289     // Don't mess the dates
290     if(startsAt >= endsAt) {
291         throw;
292     }
293     // Minimum funding goal can be zero
294     minimumFundingGoal = _minimumFundingGoal;
295     isUpdatable = _isUpdatable;
296     isWhiteListed = _isWhiteListed;
297   }
298   /**
299    * Don't expect to just send in money and get tokens.
300    */
301   function() payable {
302     throw;
303   }
304   /**
305    * Make an investment.
306    *
307    * Crowdsale must be running for one to invest.
308    * We must have not pressed the emergency brake.
309    *
310    * @param receiver The Ethereum address who receives the tokens
311    * @param customerId (optional) UUID v4 to track the successful payments on the server side
312    *
313    */
314   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
315     // Determine if it's a good time to accept investment from this participant
316     if(getState() == State.PreFunding) {
317       // Are we whitelisted for early deposit
318       throw;
319     } else if(getState() == State.Funding) {
320       // Retail participants can only come in when the crowdsale is running
321       // pass
322       if(isWhiteListed) {
323         if(!earlyParticipantWhitelist[receiver].status) {
324           throw;
325         }
326       }
327     } else {
328       // Unwanted state
329       throw;
330     }
331     uint weiAmount = msg.value;
332     // Account presale sales separately, so that they do not count against pricing tranches
333     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
334     if(tokenAmount == 0) {
335       // Dust transaction
336       throw;
337     }
338     if(isWhiteListed) {
339       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
340         // tokenAmount < minCap for investor
341         throw;
342       }
343       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
344         // tokenAmount > maxCap for investor
345         throw;
346       }
347       // Check that we did not bust the investor's cap
348       if (isBreakingInvestorCap(receiver, tokenAmount)) {
349         throw;
350       }
351     } else {
352       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
353         throw;
354       }
355     }
356     // Check that we did not bust the cap
357     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
358       throw;
359     }
360     // Update investor
361     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
362     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
363     // Update totals
364     weiRaised = weiRaised.plus(weiAmount);
365     tokensSold = tokensSold.plus(tokenAmount);
366     if(pricingStrategy.isPresalePurchase(receiver)) {
367         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
368     }
369     if(investedAmountOf[receiver] == 0) {
370        // A new investor
371        investorCount++;
372     }
373     assignTokens(receiver, tokenAmount);
374     // Pocket the money
375     if(!multisigWallet.send(weiAmount)) throw;
376     if (isWhiteListed) {
377       uint num = 0;
378       for (var i = 0; i < joinedCrowdsalesLen; i++) {
379         if (this == joinedCrowdsales[i]) 
380           num = i;
381       }
382       if (num + 1 < joinedCrowdsalesLen) {
383         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
384           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
385           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
386         }
387       }
388     }
389     // Tell us invest was success
390     Invested(receiver, weiAmount, tokenAmount, customerId);
391     Deposit(receiver, weiAmount);
392   }
393   /**
394    * Preallocate tokens for the early investors.
395    *
396    * Preallocated tokens have been sold before the actual crowdsale opens.
397    * This function mints the tokens and moves the crowdsale needle.
398    *
399    * Investor count is not handled; it is assumed this goes for multiple investors
400    * and the token distribution happens outside the smart contract flow.
401    *
402    * No money is exchanged, as the crowdsale team already have received the payment.
403    *
404    * @param fullTokens tokens as full tokens - decimal places added internally
405    * @param weiPrice Price of a single full token in wei
406    *
407    */
408   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
409     uint tokenAmount = fullTokens * 10**token.decimals();
410     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
411     weiRaised = weiRaised.plus(weiAmount);
412     tokensSold = tokensSold.plus(tokenAmount);
413     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
414     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
415     assignTokens(receiver, tokenAmount);
416     // Tell us invest was success
417     Invested(receiver, weiAmount, tokenAmount, 0);
418   }
419   /**
420    * Allow anonymous contributions to this crowdsale.
421    */
422   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
423      bytes32 hash = sha256(addr);
424      if (ecrecover(hash, v, r, s) != signerAddress) throw;
425      if(customerId == 0) throw;  // UUIDv4 sanity check
426      investInternal(addr, customerId);
427   }
428   /**
429    * Track who is the customer making the payment so we can send thank you email.
430    */
431   function investWithCustomerId(address addr, uint128 customerId) public payable {
432     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
433     if(customerId == 0) throw;  // UUIDv4 sanity check
434     investInternal(addr, customerId);
435   }
436   /**
437    * Allow anonymous contributions to this crowdsale.
438    */
439   function invest(address addr) public payable {
440     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
441     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
442     investInternal(addr, 0);
443   }
444   /**
445    * Invest to tokens, recognize the payer and clear his address.
446    *
447    */
448   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
449     investWithSignedAddress(msg.sender, customerId, v, r, s);
450   }
451   /**
452    * Invest to tokens, recognize the payer.
453    *
454    */
455   function buyWithCustomerId(uint128 customerId) public payable {
456     investWithCustomerId(msg.sender, customerId);
457   }
458   /**
459    * The basic entry point to participate the crowdsale process.
460    *
461    * Pay for funding, get invested tokens back in the sender address.
462    */
463   function buy() public payable {
464     invest(msg.sender);
465   }
466   /**
467    * Finalize a succcesful crowdsale.
468    *
469    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
470    */
471   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
472     // Already finalized
473     if(finalized) {
474       throw;
475     }
476     // Finalizing is optional. We only call it if we are given a finalizing agent.
477     if(address(finalizeAgent) != 0) {
478       finalizeAgent.finalizeCrowdsale();
479     }
480     finalized = true;
481   }
482   /**
483    * Allow to (re)set finalize agent.
484    *
485    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
486    */
487   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
488     finalizeAgent = addr;
489     // Don't allow setting bad agent
490     if(!finalizeAgent.isFinalizeAgent()) {
491       throw;
492     }
493   }
494   /**
495    * Set policy do we need to have server-side customer ids for the investments.
496    *
497    */
498   function setRequireCustomerId(bool value) onlyOwner {
499     requireCustomerId = value;
500     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
501   }
502   /**
503    * Set policy if all investors must be cleared on the server side first.
504    *
505    * This is e.g. for the accredited investor clearing.
506    *
507    */
508   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
509     requiredSignedAddress = value;
510     signerAddress = _signerAddress;
511     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
512   }
513   /**
514    * Allow addresses to do early participation.
515    *
516    * TODO: Fix spelling error in the name
517    */
518   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
519     if (!isWhiteListed) throw;
520     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
521     Whitelisted(addr, status);
522   }
523   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
524     if (!isWhiteListed) throw;
525     for (uint iterator = 0; iterator < addrs.length; iterator++) {
526       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
527     }
528   }
529   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
530     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
531     if (!isWhiteListed) throw;
532     if (addr != msg.sender && contractAddr != msg.sender) throw;
533     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
534     newMaxCap = newMaxCap.minus(tokensBought);
535     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
536   }
537   function updateJoinedCrowdsales(address addr) onlyOwner {
538     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
539   }
540   function setLastCrowdsale(address addr) onlyOwner {
541     lastCrowdsale = addr;
542   }
543   function clearJoinedCrowdsales() onlyOwner {
544     joinedCrowdsalesLen = 0;
545   }
546   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
547     clearJoinedCrowdsales();
548     for (uint iter = 0; iter < addrs.length; iter++) {
549       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
550           joinedCrowdsales.length += 1;
551       }
552       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
553       if (iter == addrs.length - 1)
554         setLastCrowdsale(addrs[iter]);
555     }
556   }
557   function setStartsAt(uint time) onlyOwner {
558     if (finalized) throw;
559     if (!isUpdatable) throw;
560     if(now > time) {
561       throw; // Don't change past
562     }
563     if(time > endsAt) {
564       throw;
565     }
566     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
567     if (lastCrowdsaleCntrct.finalized()) throw;
568     startsAt = time;
569     StartsAtChanged(startsAt);
570   }
571   /**
572    * Allow crowdsale owner to close early or extend the crowdsale.
573    *
574    * This is useful e.g. for a manual soft cap implementation:
575    * - after X amount is reached determine manual closing
576    *
577    * This may put the crowdsale to an invalid state,
578    * but we trust owners know what they are doing.
579    *
580    */
581   function setEndsAt(uint time) onlyOwner {
582     if (finalized) throw;
583     if (!isUpdatable) throw;
584     if(now > time) {
585       throw; // Don't change past
586     }
587     if(startsAt > time) {
588       throw;
589     }
590     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
591     if (lastCrowdsaleCntrct.finalized()) throw;
592     uint num = 0;
593     for (var i = 0; i < joinedCrowdsalesLen; i++) {
594       if (this == joinedCrowdsales[i]) 
595         num = i;
596     }
597     if (num + 1 < joinedCrowdsalesLen) {
598       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
599         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
600         if (time > crowdsale.startsAt()) throw;
601       }
602     }
603     endsAt = time;
604     EndsAtChanged(endsAt);
605   }
606   /**
607    * Allow to (re)set pricing strategy.
608    *
609    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
610    */
611   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
612     pricingStrategy = _pricingStrategy;
613     // Don't allow setting bad agent
614     if(!pricingStrategy.isPricingStrategy()) {
615       throw;
616     }
617   }
618   /**
619    * Allow to change the team multisig address in the case of emergency.
620    *
621    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
622    * (we have done only few test transactions). After the crowdsale is going
623    * then multisig address stays locked for the safety reasons.
624    */
625   function setMultisig(address addr) public onlyOwner {
626     // Change
627     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
628       throw;
629     }
630     multisigWallet = addr;
631   }
632   /**
633    * Allow load refunds back on the contract for the refunding.
634    *
635    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
636    */
637   function loadRefund() public payable inState(State.Failure) {
638     if(msg.value == 0) throw;
639     loadedRefund = loadedRefund.plus(msg.value);
640   }
641   /**
642    * Investors can claim refund.
643    *
644    * Note that any refunds from proxy buyers should be handled separately,
645    * and not through this contract.
646    */
647   function refund() public inState(State.Refunding) {
648     uint256 weiValue = investedAmountOf[msg.sender];
649     if (weiValue == 0) throw;
650     investedAmountOf[msg.sender] = 0;
651     weiRefunded = weiRefunded.plus(weiValue);
652     Refund(msg.sender, weiValue);
653     if (!msg.sender.send(weiValue)) throw;
654   }
655   /**
656    * @return true if the crowdsale has raised enough money to be a successful.
657    */
658   function isMinimumGoalReached() public constant returns (bool reached) {
659     return weiRaised >= minimumFundingGoal;
660   }
661   /**
662    * Check if the contract relationship looks good.
663    */
664   function isFinalizerSane() public constant returns (bool sane) {
665     return finalizeAgent.isSane();
666   }
667   /**
668    * Check if the contract relationship looks good.
669    */
670   function isPricingSane() public constant returns (bool sane) {
671     return pricingStrategy.isSane(address(this));
672   }
673   /**
674    * Crowdfund state machine management.
675    *
676    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
677    */
678   function getState() public constant returns (State) {
679     if(finalized) return State.Finalized;
680     else if (address(finalizeAgent) == 0) return State.Preparing;
681     else if (!finalizeAgent.isSane()) return State.Preparing;
682     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
683     else if (block.timestamp < startsAt) return State.PreFunding;
684     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
685     else if (isMinimumGoalReached()) return State.Success;
686     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
687     else return State.Failure;
688   }
689   /** This is for manual testing of multisig wallet interaction */
690   function setOwnerTestValue(uint val) onlyOwner {
691     ownerTestValue = val;
692   }
693   /** Interface marker. */
694   function isCrowdsale() public constant returns (bool) {
695     return true;
696   }
697   //
698   // Modifiers
699   //
700   /** Modified allowing execution only if the crowdsale is currently running.  */
701   modifier inState(State state) {
702     if(getState() != state) throw;
703     _;
704   }
705   //
706   // Abstract functions
707   //
708   /**
709    * Check if the current invested breaks our cap rules.
710    *
711    *
712    * The child contract must define their own cap setting rules.
713    * We allow a lot of flexibility through different capping strategies (ETH, token count)
714    * Called from invest().
715    *
716    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
717    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
718    * @param weiRaisedTotal What would be our total raised balance after this transaction
719    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
720    *
721    * @return true if taking this investment would break our cap rules
722    */
723   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
724   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
725   /**
726    * Check if the current crowdsale is full and we can no longer sell any tokens.
727    */
728   function isCrowdsaleFull() public constant returns (bool);
729   /**
730    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
731    */
732   function assignTokens(address receiver, uint tokenAmount) private;
733 }
734 /**
735  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
736  *
737  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
738  */
739 /**
740  * Interface for defining crowdsale pricing.
741  */
742 contract PricingStrategy {
743   /** Interface declaration. */
744   function isPricingStrategy() public constant returns (bool) {
745     return true;
746   }
747   /** Self check if all references are correctly set.
748    *
749    * Checks that pricing strategy matches crowdsale parameters.
750    */
751   function isSane(address crowdsale) public constant returns (bool) {
752     return true;
753   }
754   /**
755    * @dev Pricing tells if this is a presale purchase or not.
756      @param purchaser Address of the purchaser
757      @return False by default, true if a presale purchaser
758    */
759   function isPresalePurchase(address purchaser) public constant returns (bool) {
760     return false;
761   }
762   /**
763    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
764    *
765    *
766    * @param value - What is the value of the transaction send in as wei
767    * @param tokensSold - how much tokens have been sold this far
768    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
769    * @param msgSender - who is the investor of this transaction
770    * @param decimals - how many decimal units the token has
771    * @return Amount of tokens the investor receives
772    */
773   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
774 }
775 /**
776  * Fixed crowdsale pricing - everybody gets the same price.
777  */
778 contract FlatPricingExt is PricingStrategy, Ownable {
779   using SafeMathLibExt for uint;
780   /* How many weis one token costs */
781   uint public oneTokenInWei;
782   bool public isUpdatable;
783   address public lastCrowdsale;
784   // Crowdsale rate has been changed
785   event RateChanged(uint newOneTokenInWei);
786   function FlatPricingExt(uint _oneTokenInWei, bool _isUpdatable) onlyOwner {
787     require(_oneTokenInWei > 0);
788     oneTokenInWei = _oneTokenInWei;
789     isUpdatable = _isUpdatable;
790   }
791   function setLastCrowdsale(address addr) onlyOwner {
792     lastCrowdsale = addr;
793   }
794   function updateRate(uint newOneTokenInWei) onlyOwner {
795     if (!isUpdatable) throw;
796     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
797     if (lastCrowdsaleCntrct.finalized()) throw;
798     oneTokenInWei = newOneTokenInWei;
799     RateChanged(newOneTokenInWei);
800   }
801   /**
802    * Calculate the current price for buy in amount.
803    *
804    */
805   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
806     uint multiplier = 10 ** decimals;
807     return value.times(multiplier) / oneTokenInWei;
808   }
809 }