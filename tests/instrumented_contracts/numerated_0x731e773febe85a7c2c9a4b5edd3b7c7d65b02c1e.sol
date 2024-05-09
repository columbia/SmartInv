1 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
2 pragma solidity ^0.4.8;
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function safeDiv(uint a, uint b) internal returns (uint) {
13     assert(b > 0);
14     uint c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a >= b ? a : b;
29   }
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a >= b ? a : b;
35   }
36   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a < b ? a : b;
38   }
39 }
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() {
64     owner = msg.sender;
65   }
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
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
98 /**
99  * Safe unsigned safe math.
100  *
101  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
102  *
103  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
104  *
105  * Maintained here until merged to mainline zeppelin-solidity.
106  *
107  */
108 library SafeMathLibExt {
109   function times(uint a, uint b) returns (uint) {
110     uint c = a * b;
111     assert(a == 0 || c / a == b);
112     return c;
113   }
114   function divides(uint a, uint b) returns (uint) {
115     assert(b > 0);
116     uint c = a / b;
117     assert(a == b * c + a % b);
118     return c;
119   }
120   function minus(uint a, uint b) returns (uint) {
121     assert(b <= a);
122     return a - b;
123   }
124   function plus(uint a, uint b) returns (uint) {
125     uint c = a + b;
126     assert(c>=a);
127     return c;
128   }
129 }
130 /**
131  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
132  *
133  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
134  */
135 /*
136  * Haltable
137  *
138  * Abstract contract that allows children to implement an
139  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
140  *
141  *
142  * Originally envisioned in FirstBlood ICO contract.
143  */
144 contract Haltable is Ownable {
145   bool public halted;
146   modifier stopInEmergency {
147     if (halted) throw;
148     _;
149   }
150   modifier stopNonOwnersInEmergency {
151     if (halted && msg.sender != owner) throw;
152     _;
153   }
154   modifier onlyInEmergency {
155     if (!halted) throw;
156     _;
157   }
158   // called by the owner on emergency, triggers stopped state
159   function halt() external onlyOwner {
160     halted = true;
161   }
162   // called by the owner on end of emergency, returns to normal state
163   function unhalt() external onlyOwner onlyInEmergency {
164     halted = false;
165   }
166 }
167 /**
168  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
169  *
170  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
171  */
172 /**
173  * Interface for defining crowdsale pricing.
174  */
175 contract PricingStrategy {
176   /** Interface declaration. */
177   function isPricingStrategy() public constant returns (bool) {
178     return true;
179   }
180   /** Self check if all references are correctly set.
181    *
182    * Checks that pricing strategy matches crowdsale parameters.
183    */
184   function isSane(address crowdsale) public constant returns (bool) {
185     return true;
186   }
187   /**
188    * @dev Pricing tells if this is a presale purchase or not.
189      @param purchaser Address of the purchaser
190      @return False by default, true if a presale purchaser
191    */
192   function isPresalePurchase(address purchaser) public constant returns (bool) {
193     return false;
194   }
195   /**
196    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
197    *
198    *
199    * @param value - What is the value of the transaction send in as wei
200    * @param tokensSold - how much tokens have been sold this far
201    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
202    * @param msgSender - who is the investor of this transaction
203    * @param decimals - how many decimal units the token has
204    * @return Amount of tokens the investor receives
205    */
206   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
207 }
208 /**
209  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
210  *
211  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
212  */
213 /**
214  * Finalize agent defines what happens at the end of succeseful crowdsale.
215  *
216  * - Allocate tokens for founders, bounties and community
217  * - Make tokens transferable
218  * - etc.
219  */
220 contract FinalizeAgent {
221   function isFinalizeAgent() public constant returns(bool) {
222     return true;
223   }
224   /** Return true if we can run finalizeCrowdsale() properly.
225    *
226    * This is a safety check function that doesn't allow crowdsale to begin
227    * unless the finalizer has been set up properly.
228    */
229   function isSane() public constant returns (bool);
230   /** Called once by crowdsale finalize() if the sale was success. */
231   function finalizeCrowdsale();
232 }
233 /**
234  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
235  *
236  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
237  */
238 /**
239  * @title ERC20 interface
240  * @dev see https://github.com/ethereum/EIPs/issues/20
241  */
242 contract ERC20 is ERC20Basic {
243   function allowance(address owner, address spender) public constant returns (uint256);
244   function transferFrom(address from, address to, uint256 value) public returns (bool);
245   function approve(address spender, uint256 value) public returns (bool);
246   event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 /**
249  * A token that defines fractional units as decimals.
250  */
251 contract FractionalERC20Ext is ERC20 {
252   uint public decimals;
253   uint public minCap;
254 }
255 /**
256  * Abstract base contract for token sales.
257  *
258  * Handle
259  * - start and end dates
260  * - accepting investments
261  * - minimum funding goal and refund
262  * - various statistics during the crowdfund
263  * - different pricing strategies
264  * - different investment policies (require server side customer id, allow only whitelisted addresses)
265  *
266  */
267 contract CrowdsaleExt is Haltable {
268   /* Max investment count when we are still allowed to change the multisig address */
269   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
270   using SafeMathLibExt for uint;
271   /* The token we are selling */
272   FractionalERC20Ext public token;
273   /* How we are going to price our offering */
274   PricingStrategy public pricingStrategy;
275   /* Post-success callback */
276   FinalizeAgent public finalizeAgent;
277   /* tokens will be transfered from this address */
278   address public multisigWallet;
279   /* if the funding goal is not reached, investors may withdraw their funds */
280   uint public minimumFundingGoal;
281   /* the UNIX timestamp start date of the crowdsale */
282   uint public startsAt;
283   /* the UNIX timestamp end date of the crowdsale */
284   uint public endsAt;
285   /* the number of tokens already sold through this contract*/
286   uint public tokensSold = 0;
287   /* How many wei of funding we have raised */
288   uint public weiRaised = 0;
289   /* Calculate incoming funds from presale contracts and addresses */
290   uint public presaleWeiRaised = 0;
291   /* How many distinct addresses have invested */
292   uint public investorCount = 0;
293   /* How much wei we have returned back to the contract after a failed crowdfund. */
294   uint public loadedRefund = 0;
295   /* How much wei we have given back to investors.*/
296   uint public weiRefunded = 0;
297   /* Has this crowdsale been finalized */
298   bool public finalized;
299   /* Do we need to have unique contributor id for each customer */
300   bool public requireCustomerId;
301   bool public isWhiteListed;
302   address[] public joinedCrowdsales;
303   uint public joinedCrowdsalesLen = 0;
304   address public lastCrowdsale;
305   /**
306     * Do we verify that contributor has been cleared on the server side (accredited investors only).
307     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
308     */
309   bool public requiredSignedAddress;
310   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
311   address public signerAddress;
312   /** How much ETH each address has invested to this crowdsale */
313   mapping (address => uint256) public investedAmountOf;
314   /** How much tokens this crowdsale has credited for each investor address */
315   mapping (address => uint256) public tokenAmountOf;
316   struct WhiteListData {
317     bool status;
318     uint minCap;
319     uint maxCap;
320   }
321   //is crowdsale updatable
322   bool public isUpdatable;
323   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
324   mapping (address => WhiteListData) public earlyParticipantWhitelist;
325   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
326   uint public ownerTestValue;
327   /** State machine
328    *
329    * - Preparing: All contract initialization calls and variables have not been set yet
330    * - Prefunding: We have not passed start time yet
331    * - Funding: Active crowdsale
332    * - Success: Minimum funding goal reached
333    * - Failure: Minimum funding goal not reached before ending time
334    * - Finalized: The finalized has been called and succesfully executed
335    * - Refunding: Refunds are loaded on the contract for reclaim.
336    */
337   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
338   // A new investment was made
339   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
340   // Refund was processed for a contributor
341   event Refund(address investor, uint weiAmount);
342   // The rules were changed what kind of investments we accept
343   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
344   // Address early participation whitelist status changed
345   event Whitelisted(address addr, bool status);
346   // Crowdsale start time has been changed
347   event StartsAtChanged(uint newStartsAt);
348   // Crowdsale end time has been changed
349   event EndsAtChanged(uint newEndsAt);
350   function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
351     owner = msg.sender;
352     token = FractionalERC20Ext(_token);
353     setPricingStrategy(_pricingStrategy);
354     multisigWallet = _multisigWallet;
355     if(multisigWallet == 0) {
356         throw;
357     }
358     if(_start == 0) {
359         throw;
360     }
361     startsAt = _start;
362     if(_end == 0) {
363         throw;
364     }
365     endsAt = _end;
366     // Don't mess the dates
367     if(startsAt >= endsAt) {
368         throw;
369     }
370     // Minimum funding goal can be zero
371     minimumFundingGoal = _minimumFundingGoal;
372     isUpdatable = _isUpdatable;
373     isWhiteListed = _isWhiteListed;
374   }
375   /**
376    * Don't expect to just send in money and get tokens.
377    */
378   function() payable {
379     throw;
380   }
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
392     // Determine if it's a good time to accept investment from this participant
393     if(getState() == State.PreFunding) {
394       // Are we whitelisted for early deposit
395       throw;
396     } else if(getState() == State.Funding) {
397       // Retail participants can only come in when the crowdsale is running
398       // pass
399       if(isWhiteListed) {
400         if(!earlyParticipantWhitelist[receiver].status) {
401           throw;
402         }
403       }
404     } else {
405       // Unwanted state
406       throw;
407     }
408     uint weiAmount = msg.value;
409     // Account presale sales separately, so that they do not count against pricing tranches
410     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
411     if(tokenAmount == 0) {
412       // Dust transaction
413       throw;
414     }
415     if(isWhiteListed) {
416       if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
417         // tokenAmount < minCap for investor
418         throw;
419       }
420       if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
421         // tokenAmount > maxCap for investor
422         throw;
423       }
424       // Check that we did not bust the investor's cap
425       if (isBreakingInvestorCap(receiver, tokenAmount)) {
426         throw;
427       }
428     } else {
429       if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
430         throw;
431       }
432     }
433     // Check that we did not bust the cap
434     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
435       throw;
436     }
437     // Update investor
438     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
439     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
440     // Update totals
441     weiRaised = weiRaised.plus(weiAmount);
442     tokensSold = tokensSold.plus(tokenAmount);
443     if(pricingStrategy.isPresalePurchase(receiver)) {
444         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
445     }
446     if(investedAmountOf[receiver] == 0) {
447        // A new investor
448        investorCount++;
449     }
450     assignTokens(receiver, tokenAmount);
451     // Pocket the money
452     if(!multisigWallet.send(weiAmount)) throw;
453     if (isWhiteListed) {
454       uint num = 0;
455       for (var i = 0; i < joinedCrowdsalesLen; i++) {
456         if (this == joinedCrowdsales[i]) 
457           num = i;
458       }
459       if (num + 1 < joinedCrowdsalesLen) {
460         for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
461           CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
462           crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
463         }
464       }
465     }
466     // Tell us invest was success
467     Invested(receiver, weiAmount, tokenAmount, customerId);
468   }
469   /**
470    * Preallocate tokens for the early investors.
471    *
472    * Preallocated tokens have been sold before the actual crowdsale opens.
473    * This function mints the tokens and moves the crowdsale needle.
474    *
475    * Investor count is not handled; it is assumed this goes for multiple investors
476    * and the token distribution happens outside the smart contract flow.
477    *
478    * No money is exchanged, as the crowdsale team already have received the payment.
479    *
480    * @param fullTokens tokens as full tokens - decimal places added internally
481    * @param weiPrice Price of a single full token in wei
482    *
483    */
484   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
485     uint tokenAmount = fullTokens * 10**token.decimals();
486     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
487     weiRaised = weiRaised.plus(weiAmount);
488     tokensSold = tokensSold.plus(tokenAmount);
489     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
490     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
491     assignTokens(receiver, tokenAmount);
492     // Tell us invest was success
493     Invested(receiver, weiAmount, tokenAmount, 0);
494   }
495   /**
496    * Allow anonymous contributions to this crowdsale.
497    */
498   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
499      bytes32 hash = sha256(addr);
500      if (ecrecover(hash, v, r, s) != signerAddress) throw;
501      if(customerId == 0) throw;  // UUIDv4 sanity check
502      investInternal(addr, customerId);
503   }
504   /**
505    * Track who is the customer making the payment so we can send thank you email.
506    */
507   function investWithCustomerId(address addr, uint128 customerId) public payable {
508     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
509     if(customerId == 0) throw;  // UUIDv4 sanity check
510     investInternal(addr, customerId);
511   }
512   /**
513    * Allow anonymous contributions to this crowdsale.
514    */
515   function invest(address addr) public payable {
516     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
517     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
518     investInternal(addr, 0);
519   }
520   /**
521    * Invest to tokens, recognize the payer and clear his address.
522    *
523    */
524   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
525     investWithSignedAddress(msg.sender, customerId, v, r, s);
526   }
527   /**
528    * Invest to tokens, recognize the payer.
529    *
530    */
531   function buyWithCustomerId(uint128 customerId) public payable {
532     investWithCustomerId(msg.sender, customerId);
533   }
534   /**
535    * The basic entry point to participate the crowdsale process.
536    *
537    * Pay for funding, get invested tokens back in the sender address.
538    */
539   function buy() public payable {
540     invest(msg.sender);
541   }
542   /**
543    * Finalize a succcesful crowdsale.
544    *
545    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
546    */
547   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
548     // Already finalized
549     if(finalized) {
550       throw;
551     }
552     // Finalizing is optional. We only call it if we are given a finalizing agent.
553     if(address(finalizeAgent) != 0) {
554       finalizeAgent.finalizeCrowdsale();
555     }
556     finalized = true;
557   }
558   /**
559    * Allow to (re)set finalize agent.
560    *
561    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
562    */
563   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
564     finalizeAgent = addr;
565     // Don't allow setting bad agent
566     if(!finalizeAgent.isFinalizeAgent()) {
567       throw;
568     }
569   }
570   /**
571    * Set policy do we need to have server-side customer ids for the investments.
572    *
573    */
574   function setRequireCustomerId(bool value) onlyOwner {
575     requireCustomerId = value;
576     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
577   }
578   /**
579    * Set policy if all investors must be cleared on the server side first.
580    *
581    * This is e.g. for the accredited investor clearing.
582    *
583    */
584   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
585     requiredSignedAddress = value;
586     signerAddress = _signerAddress;
587     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
588   }
589   /**
590    * Allow addresses to do early participation.
591    *
592    * TODO: Fix spelling error in the name
593    */
594   function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
595     if (!isWhiteListed) throw;
596     earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
597     Whitelisted(addr, status);
598   }
599   function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
600     if (!isWhiteListed) throw;
601     for (uint iterator = 0; iterator < addrs.length; iterator++) {
602       setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
603     }
604   }
605   function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
606     if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
607     if (!isWhiteListed) throw;
608     if (addr != msg.sender && contractAddr != msg.sender) throw;
609     uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
610     newMaxCap = newMaxCap.minus(tokensBought);
611     earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
612   }
613   function updateJoinedCrowdsales(address addr) onlyOwner {
614     joinedCrowdsales[joinedCrowdsalesLen++] = addr;
615   }
616   function setLastCrowdsale(address addr) onlyOwner {
617     lastCrowdsale = addr;
618   }
619   function clearJoinedCrowdsales() onlyOwner {
620     joinedCrowdsalesLen = 0;
621   }
622   function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
623     clearJoinedCrowdsales();
624     for (uint iter = 0; iter < addrs.length; iter++) {
625       if(joinedCrowdsalesLen == joinedCrowdsales.length) {
626           joinedCrowdsales.length += 1;
627       }
628       joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
629       if (iter == addrs.length - 1)
630         setLastCrowdsale(addrs[iter]);
631     }
632   }
633   function setStartsAt(uint time) onlyOwner {
634     if (finalized) throw;
635     if (!isUpdatable) throw;
636     if(now > time) {
637       throw; // Don't change past
638     }
639     if(time > endsAt) {
640       throw;
641     }
642     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
643     if (lastCrowdsaleCntrct.finalized()) throw;
644     startsAt = time;
645     StartsAtChanged(startsAt);
646   }
647   /**
648    * Allow crowdsale owner to close early or extend the crowdsale.
649    *
650    * This is useful e.g. for a manual soft cap implementation:
651    * - after X amount is reached determine manual closing
652    *
653    * This may put the crowdsale to an invalid state,
654    * but we trust owners know what they are doing.
655    *
656    */
657   function setEndsAt(uint time) onlyOwner {
658     if (finalized) throw;
659     if (!isUpdatable) throw;
660     if(now > time) {
661       throw; // Don't change past
662     }
663     if(startsAt > time) {
664       throw;
665     }
666     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
667     if (lastCrowdsaleCntrct.finalized()) throw;
668     uint num = 0;
669     for (var i = 0; i < joinedCrowdsalesLen; i++) {
670       if (this == joinedCrowdsales[i]) 
671         num = i;
672     }
673     if (num + 1 < joinedCrowdsalesLen) {
674       for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
675         CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
676         if (time > crowdsale.startsAt()) throw;
677       }
678     }
679     endsAt = time;
680     EndsAtChanged(endsAt);
681   }
682   /**
683    * Allow to (re)set pricing strategy.
684    *
685    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
686    */
687   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
688     pricingStrategy = _pricingStrategy;
689     // Don't allow setting bad agent
690     if(!pricingStrategy.isPricingStrategy()) {
691       throw;
692     }
693   }
694   /**
695    * Allow to change the team multisig address in the case of emergency.
696    *
697    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
698    * (we have done only few test transactions). After the crowdsale is going
699    * then multisig address stays locked for the safety reasons.
700    */
701   function setMultisig(address addr) public onlyOwner {
702     // Change
703     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
704       throw;
705     }
706     multisigWallet = addr;
707   }
708   /**
709    * Allow load refunds back on the contract for the refunding.
710    *
711    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
712    */
713   function loadRefund() public payable inState(State.Failure) {
714     if(msg.value == 0) throw;
715     loadedRefund = loadedRefund.plus(msg.value);
716   }
717   /**
718    * Investors can claim refund.
719    *
720    * Note that any refunds from proxy buyers should be handled separately,
721    * and not through this contract.
722    */
723   function refund() public inState(State.Refunding) {
724     uint256 weiValue = investedAmountOf[msg.sender];
725     if (weiValue == 0) throw;
726     investedAmountOf[msg.sender] = 0;
727     weiRefunded = weiRefunded.plus(weiValue);
728     Refund(msg.sender, weiValue);
729     if (!msg.sender.send(weiValue)) throw;
730   }
731   /**
732    * @return true if the crowdsale has raised enough money to be a successful.
733    */
734   function isMinimumGoalReached() public constant returns (bool reached) {
735     return weiRaised >= minimumFundingGoal;
736   }
737   /**
738    * Check if the contract relationship looks good.
739    */
740   function isFinalizerSane() public constant returns (bool sane) {
741     return finalizeAgent.isSane();
742   }
743   /**
744    * Check if the contract relationship looks good.
745    */
746   function isPricingSane() public constant returns (bool sane) {
747     return pricingStrategy.isSane(address(this));
748   }
749   /**
750    * Crowdfund state machine management.
751    *
752    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
753    */
754   function getState() public constant returns (State) {
755     if(finalized) return State.Finalized;
756     else if (address(finalizeAgent) == 0) return State.Preparing;
757     else if (!finalizeAgent.isSane()) return State.Preparing;
758     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
759     else if (block.timestamp < startsAt) return State.PreFunding;
760     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
761     else if (isMinimumGoalReached()) return State.Success;
762     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
763     else return State.Failure;
764   }
765   /** This is for manual testing of multisig wallet interaction */
766   function setOwnerTestValue(uint val) onlyOwner {
767     ownerTestValue = val;
768   }
769   /** Interface marker. */
770   function isCrowdsale() public constant returns (bool) {
771     return true;
772   }
773   //
774   // Modifiers
775   //
776   /** Modified allowing execution only if the crowdsale is currently running.  */
777   modifier inState(State state) {
778     if(getState() != state) throw;
779     _;
780   }
781   //
782   // Abstract functions
783   //
784   /**
785    * Check if the current invested breaks our cap rules.
786    *
787    *
788    * The child contract must define their own cap setting rules.
789    * We allow a lot of flexibility through different capping strategies (ETH, token count)
790    * Called from invest().
791    *
792    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
793    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
794    * @param weiRaisedTotal What would be our total raised balance after this transaction
795    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
796    *
797    * @return true if taking this investment would break our cap rules
798    */
799   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
800   function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
801   /**
802    * Check if the current crowdsale is full and we can no longer sell any tokens.
803    */
804   function isCrowdsaleFull() public constant returns (bool);
805   /**
806    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
807    */
808   function assignTokens(address receiver, uint tokenAmount) private;
809 }
810 /**
811  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
812  *
813  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
814  */
815 /**
816  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
817  *
818  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
819  */
820 /**
821  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
822  *
823  * Based on code by FirstBlood:
824  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
825  */
826 contract StandardToken is ERC20, SafeMath {
827   /* Token supply got increased and a new owner received these tokens */
828   event Minted(address receiver, uint amount);
829   /* Actual balances of token holders */
830   mapping(address => uint) balances;
831   /* approve() allowances */
832   mapping (address => mapping (address => uint)) allowed;
833   /* Interface declaration */
834   function isToken() public constant returns (bool weAre) {
835     return true;
836   }
837   function transfer(address _to, uint _value) returns (bool success) {
838     balances[msg.sender] = safeSub(balances[msg.sender], _value);
839     balances[_to] = safeAdd(balances[_to], _value);
840     Transfer(msg.sender, _to, _value);
841     return true;
842   }
843   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
844     uint _allowance = allowed[_from][msg.sender];
845     balances[_to] = safeAdd(balances[_to], _value);
846     balances[_from] = safeSub(balances[_from], _value);
847     allowed[_from][msg.sender] = safeSub(_allowance, _value);
848     Transfer(_from, _to, _value);
849     return true;
850   }
851   function balanceOf(address _owner) constant returns (uint balance) {
852     return balances[_owner];
853   }
854   function approve(address _spender, uint _value) returns (bool success) {
855     // To change the approve amount you first have to reduce the addresses`
856     //  allowance to zero by calling `approve(_spender, 0)` if it is not
857     //  already 0 to mitigate the race condition described here:
858     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
859     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
860     allowed[msg.sender][_spender] = _value;
861     Approval(msg.sender, _spender, _value);
862     return true;
863   }
864   function allowance(address _owner, address _spender) constant returns (uint remaining) {
865     return allowed[_owner][_spender];
866   }
867 }
868 /**
869  * A token that can increase its supply by another contract.
870  *
871  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
872  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
873  *
874  */
875 contract MintableTokenExt is StandardToken, Ownable {
876   using SafeMathLibExt for uint;
877   bool public mintingFinished = false;
878   /** List of agents that are allowed to create new tokens */
879   mapping (address => bool) public mintAgents;
880   event MintingAgentChanged(address addr, bool state  );
881   struct ReservedTokensData {
882     uint inTokens;
883     uint inPercentage;
884   }
885   mapping (address => ReservedTokensData) public reservedTokensList;
886   address[] public reservedTokensDestinations;
887   uint public reservedTokensDestinationsLen = 0;
888   function setReservedTokensList(address addr, uint inTokens, uint inPercentage) onlyOwner {
889     reservedTokensDestinations.push(addr);
890     reservedTokensDestinationsLen++;
891     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentage:inPercentage});
892   }
893   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
894     return reservedTokensList[addr].inTokens;
895   }
896   function getReservedTokensListValInPercentage(address addr) constant returns (uint inPercentage) {
897     return reservedTokensList[addr].inPercentage;
898   }
899   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentage) onlyOwner {
900     for (uint iterator = 0; iterator < addrs.length; iterator++) {
901       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentage[iterator]);
902     }
903   }
904   /**
905    * Create new tokens and allocate them to an address..
906    *
907    * Only callably by a crowdsale contract (mint agent).
908    */
909   function mint(address receiver, uint amount) onlyMintAgent canMint public {
910     totalSupply = totalSupply.plus(amount);
911     balances[receiver] = balances[receiver].plus(amount);
912     // This will make the mint transaction apper in EtherScan.io
913     // We can remove this after there is a standardized minting event
914     Transfer(0, receiver, amount);
915   }
916   /**
917    * Owner can allow a crowdsale contract to mint new tokens.
918    */
919   function setMintAgent(address addr, bool state) onlyOwner canMint public {
920     mintAgents[addr] = state;
921     MintingAgentChanged(addr, state);
922   }
923   modifier onlyMintAgent() {
924     // Only crowdsale contracts are allowed to mint new tokens
925     if(!mintAgents[msg.sender]) {
926         throw;
927     }
928     _;
929   }
930   /** Make sure we are not done yet. */
931   modifier canMint() {
932     if(mintingFinished) throw;
933     _;
934   }
935 }
936 /**
937  * ICO crowdsale contract that is capped by amout of tokens.
938  *
939  * - Tokens are dynamically created during the crowdsale
940  *
941  *
942  */
943 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
944   /* Maximum amount of tokens this crowdsale can sell. */
945   uint public maximumSellableTokens;
946   function MintedTokenCappedCrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
947     maximumSellableTokens = _maximumSellableTokens;
948   }
949   // Crowdsale maximumSellableTokens has been changed
950   event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
951   /**
952    * Called from invest() to confirm if the curret investment does not break our cap rule.
953    */
954   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
955     return tokensSoldTotal > maximumSellableTokens;
956   }
957   function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
958     if (!isWhiteListed) throw;
959     uint maxCap = earlyParticipantWhitelist[addr].maxCap;
960     return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
961   }
962   function isCrowdsaleFull() public constant returns (bool) {
963     return tokensSold >= maximumSellableTokens;
964   }
965   /**
966    * Dynamically create tokens and assign them to the investor.
967    */
968   function assignTokens(address receiver, uint tokenAmount) private {
969     MintableTokenExt mintableToken = MintableTokenExt(token);
970     mintableToken.mint(receiver, tokenAmount);
971   }
972   function setMaximumSellableTokens(uint tokens) onlyOwner {
973     if (finalized) throw;
974     if (!isUpdatable) throw;
975     CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
976     if (lastCrowdsaleCntrct.finalized()) throw;
977     maximumSellableTokens = tokens;
978     MaximumSellableTokensChanged(maximumSellableTokens);
979   }
980 }