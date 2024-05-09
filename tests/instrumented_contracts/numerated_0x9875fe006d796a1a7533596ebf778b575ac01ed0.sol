1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
2 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
3 pragma solidity ^0.4.8;
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function safeDiv(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19   function safeSub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a < b ? a : b;
33   }
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a < b ? a : b;
39   }
40 }
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) public constant returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 }
84 /**
85  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
86  *
87  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
88  */
89 /**
90  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
91  *
92  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
93  */
94 /**
95  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
96  *
97  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
98  */
99 /**
100  * Safe unsigned safe math.
101  *
102  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
103  *
104  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
105  *
106  * Maintained here until merged to mainline zeppelin-solidity.
107  *
108  */
109 library SafeMathLibExt {
110   function times(uint a, uint b) returns (uint) {
111     uint c = a * b;
112     assert(a == 0 || c / a == b);
113     return c;
114   }
115   function divides(uint a, uint b) returns (uint) {
116     assert(b > 0);
117     uint c = a / b;
118     assert(a == b * c + a % b);
119     return c;
120   }
121   function minus(uint a, uint b) returns (uint) {
122     assert(b <= a);
123     return a - b;
124   }
125   function plus(uint a, uint b) returns (uint) {
126     uint c = a + b;
127     assert(c>=a);
128     return c;
129   }
130 }
131 /**
132  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
133  *
134  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
135  */
136 /*
137  * Haltable
138  *
139  * Abstract contract that allows children to implement an
140  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
141  *
142  *
143  * Originally envisioned in FirstBlood ICO contract.
144  */
145 contract Haltable is Ownable {
146   bool public halted;
147   modifier stopInEmergency {
148     if (halted) throw;
149     _;
150   }
151   modifier stopNonOwnersInEmergency {
152     if (halted && msg.sender != owner) throw;
153     _;
154   }
155   modifier onlyInEmergency {
156     if (!halted) throw;
157     _;
158   }
159   // called by the owner on emergency, triggers stopped state
160   function halt() external onlyOwner {
161     halted = true;
162   }
163   // called by the owner on end of emergency, returns to normal state
164   function unhalt() external onlyOwner onlyInEmergency {
165     halted = false;
166   }
167 }
168 /**
169  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
170  *
171  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
172  */
173 /**
174  * Interface for defining crowdsale pricing.
175  */
176 contract PricingStrategy {
177   /** Interface declaration. */
178   function isPricingStrategy() public constant returns (bool) {
179     return true;
180   }
181   /** Self check if all references are correctly set.
182    *
183    * Checks that pricing strategy matches crowdsale parameters.
184    */
185   function isSane(address crowdsale) public constant returns (bool) {
186     return true;
187   }
188   /**
189    * @dev Pricing tells if this is a presale purchase or not.
190      @param purchaser Address of the purchaser
191      @return False by default, true if a presale purchaser
192    */
193   function isPresalePurchase(address purchaser) public constant returns (bool) {
194     return false;
195   }
196   /**
197    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
198    *
199    *
200    * @param value - What is the value of the transaction send in as wei
201    * @param tokensSold - how much tokens have been sold this far
202    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
203    * @param msgSender - who is the investor of this transaction
204    * @param decimals - how many decimal units the token has
205    * @return Amount of tokens the investor receives
206    */
207   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
208 }
209 /**
210  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
211  *
212  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
213  */
214 /**
215  * Finalize agent defines what happens at the end of succeseful crowdsale.
216  *
217  * - Allocate tokens for founders, bounties and community
218  * - Make tokens transferable
219  * - etc.
220  */
221 contract FinalizeAgent {
222   function isFinalizeAgent() public constant returns(bool) {
223     return true;
224   }
225   /** Return true if we can run finalizeCrowdsale() properly.
226    *
227    * This is a safety check function that doesn't allow crowdsale to begin
228    * unless the finalizer has been set up properly.
229    */
230   function isSane() public constant returns (bool);
231   /** Called once by crowdsale finalize() if the sale was success. */
232   function finalizeCrowdsale();
233 }
234 /**
235  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
236  *
237  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
238  */
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
249 /**
250  * A token that defines fractional units as decimals.
251  */
252 contract FractionalERC20Ext is ERC20 {
253   uint public decimals;
254   uint public minCap;
255 }
256 /**
257  * Abstract base contract for token sales.
258  *
259  * Handle
260  * - start and end dates
261  * - accepting investments
262  * - minimum funding goal and refund
263  * - various statistics during the crowdfund
264  * - different pricing strategies
265  * - different investment policies (require server side customer id, allow only whitelisted addresses)
266  *
267  */
268 contract CrowdsaleExt is Haltable {
269   /* Max investment count when we are still allowed to change the multisig address */
270   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
271   using SafeMathLibExt for uint;
272   /* The token we are selling */
273   FractionalERC20Ext public token;
274   /* How we are going to price our offering */
275   PricingStrategy public pricingStrategy;
276   /* Post-success callback */
277   FinalizeAgent public finalizeAgent;
278   /* tokens will be transfered from this address */
279   address public multisigWallet;
280   /* if the funding goal is not reached, investors may withdraw their funds */
281   uint public minimumFundingGoal;
282   /* the UNIX timestamp start date of the crowdsale */
283   uint public startsAt;
284   /* the UNIX timestamp end date of the crowdsale */
285   uint public endsAt;
286   /* the number of tokens already sold through this contract*/
287   uint public tokensSold = 0;
288   /* How many wei of funding we have raised */
289   uint public weiRaised = 0;
290   /* Calculate incoming funds from presale contracts and addresses */
291   uint public presaleWeiRaised = 0;
292   /* How many distinct addresses have invested */
293   uint public investorCount = 0;
294   /* How much wei we have returned back to the contract after a failed crowdfund. */
295   uint public loadedRefund = 0;
296   /* How much wei we have given back to investors.*/
297   uint public weiRefunded = 0;
298   /* Has this crowdsale been finalized */
299   bool public finalized;
300   /* Do we need to have unique contributor id for each customer */
301   bool public requireCustomerId;
302   bool public isWhiteListed;
303   address[] public joinedCrowdsales;
304   uint public joinedCrowdsalesLen = 0;
305   address public lastCrowdsale;
306   /**
307     * Do we verify that contributor has been cleared on the server side (accredited investors only).
308     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
309     */
310   bool public requiredSignedAddress;
311   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
312   address public signerAddress;
313   /** How much ETH each address has invested to this crowdsale */
314   mapping (address => uint256) public investedAmountOf;
315   /** How much tokens this crowdsale has credited for each investor address */
316   mapping (address => uint256) public tokenAmountOf;
317   struct WhiteListData {
318     bool status;
319     uint minCap;
320     uint maxCap;
321   }
322   //is crowdsale updatable
323   bool public isUpdatable;
324   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
325   mapping (address => WhiteListData) public earlyParticipantWhitelist;
326   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
327   uint public ownerTestValue;
328   /** State machine
329    *
330    * - Preparing: All contract initialization calls and variables have not been set yet
331    * - Prefunding: We have not passed start time yet
332    * - Funding: Active crowdsale
333    * - Success: Minimum funding goal reached
334    * - Failure: Minimum funding goal not reached before ending time
335    * - Finalized: The finalized has been called and succesfully executed
336    * - Refunding: Refunds are loaded on the contract for reclaim.
337    */
338   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
339   // A new investment was made
340   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
341   // Refund was processed for a contributor
342   event Refund(address investor, uint weiAmount);
343   // The rules were changed what kind of investments we accept
344   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
345   // Address early participation whitelist status changed
346   event Whitelisted(address addr, bool status);
347   // Crowdsale start time has been changed
348   event StartsAtChanged(uint newStartsAt);
349   // Crowdsale end time has been changed
350   event EndsAtChanged(uint newEndsAt);
351   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
352     owner = msg.sender;
353     token = FractionalERC20Ext(_token);
354     setPricingStrategy(_pricingStrategy);
355     multisigWallet = _multisigWallet;
356     if(multisigWallet == 0) {
357         throw;
358     }
359     if(_start == 0) {
360         throw;
361     }
362     startsAt = _start;
363     if(_end == 0) {
364         throw;
365     }
366     endsAt = _end;
367     // Don't mess the dates
368     if(startsAt >= endsAt) {
369         throw;
370     }
371     // Minimum funding goal can be zero
372     minimumFundingGoal = _minimumFundingGoal;
373     isUpdatable = _isUpdatable;
374     isWhiteListed = _isWhiteListed;
375   }
376   /**
377    * Don't expect to just send in money and get tokens.
378    */
379   function() payable {
380     throw;
381   }
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
409     uint weiAmount = msg.value;
410     // Account presale sales separately, so that they do not count against pricing tranches
411     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
412     if(tokenAmount == 0) {
413       // Dust transaction
414       throw;
415     }
416     if(isWhiteListed) {
417       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
418         // tokenAmount < minCap for investor
419         throw;
420       }
421       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
422         // tokenAmount > maxCap for investor
423         throw;
424       }
425       // Check that we did not bust the investor's cap
426       if (isBreakingInvestorCap(receiver, tokenAmount)) {
427         throw;
428       }
429     } else {
430       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
431         throw;
432       }
433     }
434     // Check that we did not bust the cap
435     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
436       throw;
437     }
438     if(investedAmountOf[receiver] == 0) {
439        // A new investor
440        investorCount++;
441     }
442     // Update investor
443     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
444     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
445     // Update totals
446     weiRaised = weiRaised.plus(weiAmount);
447     tokensSold = tokensSold.plus(tokenAmount);
448     if(pricingStrategy.isPresalePurchase(receiver)) {
449         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
450     }
451     assignTokens(receiver, tokenAmount);
452     // Pocket the money
453     if(!multisigWallet.send(weiAmount)) throw;
454     if (isWhiteListed) {
455       uint num = 0;
456       for (var i = 0; i < joinedCrowdsalesLen; i++) {
457         if (this == joinedCrowdsales[i]) 
458           num = i;
459       }
460       if (num + 1 < joinedCrowdsalesLen) {
461         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
462           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
463           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
464         }
465       }
466     }
467     // Tell us invest was success
468     Invested(receiver, weiAmount, tokenAmount, customerId);
469   }
470   /**
471    * Preallocate tokens for the early investors.
472    *
473    * Preallocated tokens have been sold before the actual crowdsale opens.
474    * This function mints the tokens and moves the crowdsale needle.
475    *
476    * Investor count is not handled; it is assumed this goes for multiple investors
477    * and the token distribution happens outside the smart contract flow.
478    *
479    * No money is exchanged, as the crowdsale team already have received the payment.
480    *
481    * @param fullTokens tokens as full tokens - decimal places added internally
482    * @param weiPrice Price of a single full token in wei
483    *
484    */
485   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
486     uint tokenAmount = fullTokens * 10**token.decimals();
487     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
488     weiRaised = weiRaised.plus(weiAmount);
489     tokensSold = tokensSold.plus(tokenAmount);
490     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
491     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
492     assignTokens(receiver, tokenAmount);
493     // Tell us invest was success
494     Invested(receiver, weiAmount, tokenAmount, 0);
495   }
496   /**
497    * Allow anonymous contributions to this crowdsale.
498    */
499   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
500      bytes32 hash = sha256(addr);
501      if (ecrecover(hash, v, r, s) != signerAddress) throw;
502      if(customerId == 0) throw;  // UUIDv4 sanity check
503      investInternal(addr, customerId);
504   }
505   /**
506    * Track who is the customer making the payment so we can send thank you email.
507    */
508   function investWithCustomerId(address addr, uint128 customerId) public payable {
509     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
510     if(customerId == 0) throw;  // UUIDv4 sanity check
511     investInternal(addr, customerId);
512   }
513   /**
514    * Allow anonymous contributions to this crowdsale.
515    */
516   function invest(address addr) public payable {
517     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
518     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
519     investInternal(addr, 0);
520   }
521   /**
522    * Invest to tokens, recognize the payer and clear his address.
523    *
524    */
525   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
526     investWithSignedAddress(msg.sender, customerId, v, r, s);
527   }
528   /**
529    * Invest to tokens, recognize the payer.
530    *
531    */
532   function buyWithCustomerId(uint128 customerId) public payable {
533     investWithCustomerId(msg.sender, customerId);
534   }
535   /**
536    * The basic entry point to participate the crowdsale process.
537    *
538    * Pay for funding, get invested tokens back in the sender address.
539    */
540   function buy() public payable {
541     invest(msg.sender);
542   }
543   /**
544    * Finalize a succcesful crowdsale.
545    *
546    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
547    */
548   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
549     // Already finalized
550     if(finalized) {
551       throw;
552     }
553     // Finalizing is optional. We only call it if we are given a finalizing agent.
554     if(address(finalizeAgent) != 0) {
555       finalizeAgent.finalizeCrowdsale();
556     }
557     finalized = true;
558   }
559   /**
560    * Allow to (re)set finalize agent.
561    *
562    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
563    */
564   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
565     finalizeAgent = addr;
566     // Don't allow setting bad agent
567     if(!finalizeAgent.isFinalizeAgent()) {
568       throw;
569     }
570   }
571   /**
572    * Set policy do we need to have server-side customer ids for the investments.
573    *
574    */
575   function setRequireCustomerId(bool value) onlyOwner {
576     requireCustomerId = value;
577     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
578   }
579   /**
580    * Set policy if all investors must be cleared on the server side first.
581    *
582    * This is e.g. for the accredited investor clearing.
583    *
584    */
585   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
586     requiredSignedAddress = value;
587     signerAddress = _signerAddress;
588     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
589   }
590   /**
591    * Allow addresses to do early participation.
592    *
593    * TODO: Fix spelling error in the name
594    */
595   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
596     if (!isWhiteListed) throw;
597     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
598     Whitelisted(addr, status);
599   }
600   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
601     if (!isWhiteListed) throw;
602     for (uint iterator = 0; iterator < addrs.length; iterator++) {
603       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
604     }
605   }
606   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
607     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
608     if (!isWhiteListed) throw;
609     if (addr != msg.sender && contractAddr != msg.sender) throw;
610     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
611     newMaxCap = newMaxCap.minus(tokensBought);
612     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
613   }
614   function updateJoinedCrowdsales(address addr) onlyOwner {
615     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
616   }
617   function setLastCrowdsale(address addr) onlyOwner {
618     lastCrowdsale = addr;
619   }
620   function clearJoinedCrowdsales() onlyOwner {
621     joinedCrowdsalesLen = 0;
622   }
623   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
624     clearJoinedCrowdsales();
625     for (uint iter = 0; iter < addrs.length; iter++) {
626       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
627           joinedCrowdsales.length += 1;
628       }
629       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
630       if (iter == addrs.length - 1)
631         setLastCrowdsale(addrs[iter]);
632     }
633   }
634   function setStartsAt(uint time) onlyOwner {
635     if (finalized) throw;
636     if (!isUpdatable) throw;
637     if(now > time) {
638       throw; // Don't change past
639     }
640     if(time > endsAt) {
641       throw;
642     }
643     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
644     if (lastCrowdsaleCntrct.finalized()) throw;
645     startsAt = time;
646     StartsAtChanged(startsAt);
647   }
648   /**
649    * Allow crowdsale owner to close early or extend the crowdsale.
650    *
651    * This is useful e.g. for a manual soft cap implementation:
652    * - after X amount is reached determine manual closing
653    *
654    * This may put the crowdsale to an invalid state,
655    * but we trust owners know what they are doing.
656    *
657    */
658   function setEndsAt(uint time) onlyOwner {
659     if (finalized) throw;
660     if (!isUpdatable) throw;
661     if(now > time) {
662       throw; // Don't change past
663     }
664     if(startsAt > time) {
665       throw;
666     }
667     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
668     if (lastCrowdsaleCntrct.finalized()) throw;
669     uint num = 0;
670     for (var i = 0; i < joinedCrowdsalesLen; i++) {
671       if (this == joinedCrowdsales[i]) 
672         num = i;
673     }
674     if (num + 1 < joinedCrowdsalesLen) {
675       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
676         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
677         if (time > crowdsale.startsAt()) throw;
678       }
679     }
680     endsAt = time;
681     EndsAtChanged(endsAt);
682   }
683   /**
684    * Allow to (re)set pricing strategy.
685    *
686    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
687    */
688   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
689     pricingStrategy = _pricingStrategy;
690     // Don't allow setting bad agent
691     if(!pricingStrategy.isPricingStrategy()) {
692       throw;
693     }
694   }
695   /**
696    * Allow to change the team multisig address in the case of emergency.
697    *
698    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
699    * (we have done only few test transactions). After the crowdsale is going
700    * then multisig address stays locked for the safety reasons.
701    */
702   function setMultisig(address addr) public onlyOwner {
703     // Change
704     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
705       throw;
706     }
707     multisigWallet = addr;
708   }
709   /**
710    * Allow load refunds back on the contract for the refunding.
711    *
712    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
713    */
714   function loadRefund() public payable inState(State.Failure) {
715     if(msg.value == 0) throw;
716     loadedRefund = loadedRefund.plus(msg.value);
717   }
718   /**
719    * Investors can claim refund.
720    *
721    * Note that any refunds from proxy buyers should be handled separately,
722    * and not through this contract.
723    */
724   function refund() public inState(State.Refunding) {
725     uint256 weiValue = investedAmountOf[msg.sender];
726     if (weiValue == 0) throw;
727     investedAmountOf[msg.sender] = 0;
728     weiRefunded = weiRefunded.plus(weiValue);
729     Refund(msg.sender, weiValue);
730     if (!msg.sender.send(weiValue)) throw;
731   }
732   /**
733    * @return true if the crowdsale has raised enough money to be a successful.
734    */
735   function isMinimumGoalReached() public constant returns (bool reached) {
736     return weiRaised >= minimumFundingGoal;
737   }
738   /**
739    * Check if the contract relationship looks good.
740    */
741   function isFinalizerSane() public constant returns (bool sane) {
742     return finalizeAgent.isSane();
743   }
744   /**
745    * Check if the contract relationship looks good.
746    */
747   function isPricingSane() public constant returns (bool sane) {
748     return pricingStrategy.isSane(address(this));
749   }
750   /**
751    * Crowdfund state machine management.
752    *
753    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
754    */
755   function getState() public constant returns (State) {
756     if(finalized) return State.Finalized;
757     else if (address(finalizeAgent) == 0) return State.Preparing;
758     else if (!finalizeAgent.isSane()) return State.Preparing;
759     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
760     else if (block.timestamp < startsAt) return State.PreFunding;
761     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
762     else if (isMinimumGoalReached()) return State.Success;
763     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
764     else return State.Failure;
765   }
766   /** This is for manual testing of multisig wallet interaction */
767   function setOwnerTestValue(uint val) onlyOwner {
768     ownerTestValue = val;
769   }
770   /** Interface marker. */
771   function isCrowdsale() public constant returns (bool) {
772     return true;
773   }
774   //
775   // Modifiers
776   //
777   /** Modified allowing execution only if the crowdsale is currently running.  */
778   modifier inState(State state) {
779     if(getState() != state) throw;
780     _;
781   }
782   //
783   // Abstract functions
784   //
785   /**
786    * Check if the current invested breaks our cap rules.
787    *
788    *
789    * The child contract must define their own cap setting rules.
790    * We allow a lot of flexibility through different capping strategies (ETH, token count)
791    * Called from invest().
792    *
793    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
794    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
795    * @param weiRaisedTotal What would be our total raised balance after this transaction
796    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
797    *
798    * @return true if taking this investment would break our cap rules
799    */
800   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
801   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
802   /**
803    * Check if the current crowdsale is full and we can no longer sell any tokens.
804    */
805   function isCrowdsaleFull() public constant returns (bool);
806   /**
807    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
808    */
809   function assignTokens(address receiver, uint tokenAmount) private;
810 }
811 /**
812  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
813  *
814  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
815  */
816 /**
817  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
818  *
819  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
820  */
821 /**
822  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
823  *
824  * Based on code by FirstBlood:
825  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
826  */
827 contract StandardToken is ERC20, SafeMath {
828   /* Token supply got increased and a new owner received these tokens */
829   event Minted(address receiver, uint amount);
830   /* Actual balances of token holders */
831   mapping(address => uint) balances;
832   /* approve() allowances */
833   mapping (address => mapping (address => uint)) allowed;
834   /* Interface declaration */
835   function isToken() public constant returns (bool weAre) {
836     return true;
837   }
838   function transfer(address _to, uint _value) returns (bool success) {
839     balances[msg.sender] = safeSub(balances[msg.sender], _value);
840     balances[_to] = safeAdd(balances[_to], _value);
841     Transfer(msg.sender, _to, _value);
842     return true;
843   }
844   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
845     uint _allowance = allowed[_from][msg.sender];
846     balances[_to] = safeAdd(balances[_to], _value);
847     balances[_from] = safeSub(balances[_from], _value);
848     allowed[_from][msg.sender] = safeSub(_allowance, _value);
849     Transfer(_from, _to, _value);
850     return true;
851   }
852   function balanceOf(address _owner) constant returns (uint balance) {
853     return balances[_owner];
854   }
855   function approve(address _spender, uint _value) returns (bool success) {
856     // To change the approve amount you first have to reduce the addresses`
857     //  allowance to zero by calling `approve(_spender, 0)` if it is not
858     //  already 0 to mitigate the race condition described here:
859     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
860     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
861     allowed[msg.sender][_spender] = _value;
862     Approval(msg.sender, _spender, _value);
863     return true;
864   }
865   function allowance(address _owner, address _spender) constant returns (uint remaining) {
866     return allowed[_owner][_spender];
867   }
868 }
869 /**
870  * A token that can increase its supply by another contract.
871  *
872  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
873  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
874  *
875  */
876 contract MintableTokenExt is StandardToken, Ownable {
877   using SafeMathLibExt for uint;
878   bool public mintingFinished = false;
879   /** List of agents that are allowed to create new tokens */
880   mapping (address => bool) public mintAgents;
881   event MintingAgentChanged(address addr, bool state  );
882   struct ReservedTokensData {
883     uint inTokens;
884     uint inPercentage;
885   }
886   mapping (address => ReservedTokensData) public reservedTokensList;
887   address[] public reservedTokensDestinations;
888   uint public reservedTokensDestinationsLen = 0;
889   function setReservedTokensList(address addr, uint inTokens, uint inPercentage) onlyOwner {
890     reservedTokensDestinations.push(addr);
891     reservedTokensDestinationsLen++;
892     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentage:inPercentage});
893   }
894   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
895     return reservedTokensList[addr].inTokens;
896   }
897   function getReservedTokensListValInPercentage(address addr) constant returns (uint inPercentage) {
898     return reservedTokensList[addr].inPercentage;
899   }
900   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentage) onlyOwner {
901     for (uint iterator = 0; iterator < addrs.length; iterator++) {
902       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentage[iterator]);
903     }
904   }
905   /**
906    * Create new tokens and allocate them to an address..
907    *
908    * Only callably by a crowdsale contract (mint agent).
909    */
910   function mint(address receiver, uint amount) onlyMintAgent canMint public {
911     totalSupply = totalSupply.plus(amount);
912     balances[receiver] = balances[receiver].plus(amount);
913     // This will make the mint transaction apper in EtherScan.io
914     // We can remove this after there is a standardized minting event
915     Transfer(0, receiver, amount);
916   }
917   /**
918    * Owner can allow a crowdsale contract to mint new tokens.
919    */
920   function setMintAgent(address addr, bool state) onlyOwner canMint public {
921     mintAgents[addr] = state;
922     MintingAgentChanged(addr, state);
923   }
924   modifier onlyMintAgent() {
925     // Only crowdsale contracts are allowed to mint new tokens
926     if(!mintAgents[msg.sender]) {
927         throw;
928     }
929     _;
930   }
931   /** Make sure we are not done yet. */
932   modifier canMint() {
933     if(mintingFinished) throw;
934     _;
935   }
936 }
937 /**
938  * ICO crowdsale contract that is capped by amout of tokens.
939  *
940  * - Tokens are dynamically created during the crowdsale
941  *
942  *
943  */
944 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
945   /* Maximum amount of tokens this crowdsale can sell. */
946   uint public maximumSellableTokens;
947   function MintedTokenCappedCrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
948     maximumSellableTokens = _maximumSellableTokens;
949   }
950   // Crowdsale maximumSellableTokens has been changed
951   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
952   /**
953    * Called from invest() to confirm if the curret investment does not break our cap rule.
954    */
955   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
956     return tokensSoldTotal > maximumSellableTokens;
957   }
958   function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
959     if (!isWhiteListed) throw;
960     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
961     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
962   }
963   function isCrowdsaleFull() public constant returns (bool) {
964     return tokensSold >= maximumSellableTokens;
965   }
966   /**
967    * Dynamically create tokens and assign them to the investor.
968    */
969   function assignTokens(address receiver, uint tokenAmount) private {
970     MintableTokenExt mintableToken = MintableTokenExt(token);
971     mintableToken.mint(receiver, tokenAmount);
972   }
973   function setMaximumSellableTokens(uint tokens) onlyOwner {
974     if (finalized) throw;
975     if (!isUpdatable) throw;
976     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
977     if (lastCrowdsaleCntrct.finalized()) throw;
978     maximumSellableTokens = tokens;
979     MaximumSellableTokensChanged(maximumSellableTokens);
980   }
981 }