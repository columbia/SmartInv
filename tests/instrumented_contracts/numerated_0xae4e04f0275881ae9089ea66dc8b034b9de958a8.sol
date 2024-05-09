1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  *
6  ** Code Modified by : TokenMagic
7  ** Change Log: 
8  *** Solidity version upgraded from 0.4.8 to 0.4.23
9  */
10  
11  
12 pragma solidity ^0.4.23;
13 
14 /*
15 * Ownable Contract
16 * Added by : TokenMagic
17 */ 
18 contract Ownable {
19   
20   address public owner;
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 /*
52 * Haltable Contract
53 * Added by : TokenMagic
54 */
55 contract Haltable is Ownable {
56   bool public halted;
57 
58   modifier stopInEmergency {
59     require(!halted);
60     _;
61   }
62 
63   modifier stopNonOwnersInEmergency {
64     require(!halted && msg.sender == owner);
65     _;
66   }
67 
68   modifier onlyInEmergency {
69     require(halted);
70     _;
71   }
72 
73   // called by the owner on emergency, triggers stopped state
74   function halt() external onlyOwner {
75     halted = true;
76   }
77 
78   // called by the owner on end of emergency, returns to normal state
79   function unhalt() external onlyOwner onlyInEmergency {
80     halted = false;
81   }
82 
83 }
84 
85 /*
86 * SafeMathLib Library
87 * Added by : TokenMagic
88 */
89 library SafeMathLib {
90 
91   function times(uint a, uint b) public pure returns (uint) {
92     uint c = a * b;
93     assert(a == 0 || c / a == b);
94     return c;
95   }
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135   
136 }
137 
138 
139 /*
140 * Token Contract 
141 * Added by : TokenMagic
142 */
143 contract FractionalERC20 {
144 
145   uint public decimals;
146 
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 
152   function totalSupply() public view returns (uint256);
153   function balanceOf(address who) public view returns (uint256);
154   function transfer(address to, uint256 value) public returns (bool);
155   event Transfer(address indexed from, address indexed to, uint256 value);
156 }
157 
158 
159 /*
160 * Crowdsale Contract
161 * Added by : TokenMagic
162 */
163 contract HoardCrowdsale is Haltable {
164 
165   using SafeMathLib for uint;
166 
167   /* The token we are selling */
168   FractionalERC20 public token;
169 
170   /* tokens will be transfered from this address */
171   address public multisigWallet;
172   
173   /* Founders team MultiSig Wallet address */
174   address public foundersTeamMultisig;
175   
176   /* if the funding goal is not reached, investors may withdraw their funds */
177   uint public minimumFundingGoal = 1000000000000000; // 0.001 ETH in Wei
178 
179   /* the UNIX timestamp start date of the crowdsale */
180   uint public startsAt;
181 
182   /* the UNIX timestamp end date of the crowdsale */
183   uint public endsAt;
184 
185   /* the number of tokens already sold through this contract*/
186   uint public tokensSold = 0;
187 
188   /* the number of tokens already sold through this contract for presale*/
189   uint public presaleTokensSold = 0;
190 
191   /* the number of tokens already sold before presale*/
192   uint public prePresaleTokensSold = 0;
193 
194   /* Maximum number tokens that presale can assign*/ 
195   uint public presaleTokenLimit = 80000000000000000000000000; //80,000,000 token
196 
197   /* Maximum number tokens that crowdsale can assign*/ 
198   uint public crowdsaleTokenLimit = 120000000000000000000000000; //120,000,000 token
199   
200   /** Total percent of tokens allocated to the founders team multiSig wallet at the end of the sale */
201   uint public percentageOfSoldTokensForFounders = 50; // 50% of solded token as bonus to founders team multiSig wallet
202   
203   /* How much bonus tokens we allocated */
204   uint public tokensForFoundingBoardWallet;
205   
206   /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
207   address public beneficiary;
208   
209   /* How many wei of funding we have raised */
210   uint public weiRaised = 0;
211 
212   /* Calculate incoming funds from presale contracts and addresses */
213   uint public presaleWeiRaised = 0;
214 
215   /* How many distinct addresses have invested */
216   uint public investorCount = 0;
217 
218   /* How much wei we have returned back to the contract after a failed crowdfund. */
219   uint public loadedRefund = 0;
220 
221   /* How much wei we have given back to investors.*/
222   uint public weiRefunded = 0;
223 
224   /* Has this crowdsale been finalized */
225   bool public finalized;
226 
227   /** How much ETH each address has invested to this crowdsale */
228   mapping (address => uint256) public investedAmountOf;
229 
230   /** How much tokens this crowdsale has credited for each investor address */
231   mapping (address => uint256) public tokenAmountOf;
232 
233   /** Presale Addresses that are allowed to invest. */
234   mapping (address => bool) public presaleWhitelist;
235 
236   /** Addresses that are allowed to invest. */
237   mapping (address => bool) public participantWhitelist;
238 
239   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
240   uint public ownerTestValue;
241 
242   uint public oneTokenInWei;
243 
244   /** State machine
245    *
246    * - Preparing: All contract initialization calls and variables have not been set yet
247    * - Prefunding: We have not passed start time yet
248    * - Funding: Active crowdsale
249    * - Success: Minimum funding goal reached
250    * - Failure: Minimum funding goal not reached before ending time
251    * - Finalized: The finalized has been called and succesfully executed
252    * - Refunding: Refunds are loaded on the contract for reclaim.
253    */
254   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
255 
256   // A new investment was made
257   event Invested(address investor, uint weiAmount, uint tokenAmount);
258 
259   // Refund was processed for a contributor
260   event Refund(address investor, uint weiAmount);
261 
262   // Address participation whitelist status changed
263   event Whitelisted(address[] addr, bool status);
264 
265   // Presale Address participation whitelist status changed
266   event PresaleWhitelisted(address addr, bool status);
267     
268   // Crowdsale start time has been changed
269   event StartsAtChanged(uint newStartsAt);
270       
271   // Crowdsale end time has been changed
272   event EndsAtChanged(uint newEndsAt);
273   
274   // Crowdsale token price has been changed
275   event TokenPriceChanged(uint tokenPrice);
276     
277   // Crowdsale multisig address has been changed    
278   event MultiSigChanged(address newAddr);
279   
280   // Crowdsale beneficiary address has been changed    
281   event BeneficiaryChanged(address newAddr);
282   
283   // Founders Team Wallet Address Changed 
284   event FoundersWalletChanged(address newAddr);
285   
286   // Founders Team Token Allocation Percentage Changed 
287   event FoundersTokenAllocationChanged(uint newValue);
288   
289   // Pre-Presale Tokens Value Changed
290   event PrePresaleTokensValueChanged(uint newValue);
291 
292   constructor(address _token, uint _oneTokenInWei, address _multisigWallet, uint _start, uint _end, address _beneficiary, address _foundersTeamMultisig) public {
293 
294     require(_multisigWallet != address(0) && _start != 0 && _end != 0 && _start <= _end);
295     owner = msg.sender;
296 
297     token = FractionalERC20(_token);
298     oneTokenInWei = _oneTokenInWei;
299 
300     multisigWallet = _multisigWallet;
301     startsAt = _start;
302     endsAt = _end;
303 
304     beneficiary = _beneficiary;
305     foundersTeamMultisig = _foundersTeamMultisig;
306   }
307   
308   /**
309    * Just send in money and get tokens.
310    * Modified by : TokenMagic
311    */
312   function() payable public {
313     investInternal(msg.sender,0);
314   }
315   
316   /** 
317   * Pre-sale contract call this function and get tokens 
318   * Modified by : TokenMagic
319   */
320   function invest(address addr,uint tokenAmount) public payable {
321     investInternal(addr,tokenAmount);
322   }
323   
324   /**
325    * Make an investment.
326    *
327    * Crowdsale must be running for one to invest.
328    * We must have not pressed the emergency brake.
329    *
330    * @param receiver The Ethereum address who receives the tokens
331    *
332    * @return tokenAmount How mony tokens were bought
333    *
334    * Modified by : TokenMagic
335    */
336   function investInternal(address receiver, uint tokens) stopInEmergency internal returns(uint tokensBought) {
337 
338     uint weiAmount = msg.value;
339     uint tokenAmount = tokens;
340     if(getState() == State.PreFunding || getState() == State.Funding) {
341       if(presaleWhitelist[msg.sender]){
342         // Allow presale particaipants
343         presaleWeiRaised = presaleWeiRaised.add(weiAmount);
344         presaleTokensSold = presaleTokensSold.add(tokenAmount);
345         require(presaleTokensSold <= presaleTokenLimit); 
346       }
347       else if(participantWhitelist[receiver]){
348         uint multiplier = 10 ** token.decimals();
349         tokenAmount = weiAmount.times(multiplier) / oneTokenInWei;
350         // Allow whitelisted participants    
351       }
352       else {
353         revert();
354       }
355     } else {
356       // Unwanted state
357       revert();
358     }
359     
360     // Dust transaction
361     require(tokenAmount != 0);
362 
363     if(investedAmountOf[receiver] == 0) {
364       // A new investor
365       investorCount++;
366     }
367 
368     // Update investor
369     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
370     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
371 
372     // Update totals
373     weiRaised = weiRaised.add(weiAmount);
374     tokensSold = tokensSold.add(tokenAmount);
375     
376     require(tokensSold.sub(presaleTokensSold) <= crowdsaleTokenLimit);
377     
378     // Check that we did not bust the cap
379     require(!isBreakingCap(tokenAmount));
380     require(token.transferFrom(beneficiary, receiver, tokenAmount));
381 
382     emit Invested(receiver, weiAmount, tokenAmount);
383     multisigWallet.transfer(weiAmount);
384     return tokenAmount;
385   }
386 
387   /**
388    * Finalize a succcesful crowdsale.
389    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
390    * Added by : TokenMagic
391    */
392   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
393     require(!finalized); // Not already finalized
394     
395     // How many % of tokens the founders and others get
396     tokensForFoundingBoardWallet = tokensSold.times(percentageOfSoldTokensForFounders) / 100;
397     tokensForFoundingBoardWallet = tokensForFoundingBoardWallet.add(prePresaleTokensSold);
398     require(token.transferFrom(beneficiary, foundersTeamMultisig, tokensForFoundingBoardWallet));
399     
400     finalized = true;
401   }
402 
403   /**
404    * Allow owner to change the percentage value of solded tokens to founders team wallet after finalize. Default value is 50.
405    * Added by : TokenMagic
406    */ 
407   function setFoundersTokenAllocation(uint _percentageOfSoldTokensForFounders) public onlyOwner{
408     percentageOfSoldTokensForFounders = _percentageOfSoldTokensForFounders;
409     emit FoundersTokenAllocationChanged(percentageOfSoldTokensForFounders);
410   }
411 
412   /**
413    * Allow crowdsale owner to close early or extend the crowdsale.
414    *
415    * This is useful e.g. for a manual soft cap implementation:
416    * - after X amount is reached determine manual closing
417    *
418    * This may put the crowdsale to an invalid state,
419    * but we trust owners know what they are doing.
420    *
421    */
422   function setEndsAt(uint time) onlyOwner public {
423     require(now < time && startsAt < time);
424     endsAt = time;
425     emit EndsAtChanged(endsAt);
426   }
427   
428   /**
429    * Allow owner to change crowdsale startsAt data.
430    * Added by : TokenMagic
431    **/ 
432   function setStartsAt(uint time) onlyOwner public {
433     require(time < endsAt);
434     startsAt = time;
435     emit StartsAtChanged(startsAt);
436   }
437 
438   /**
439    * Allow to change the team multisig address in the case of emergency.
440    *
441    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
442    * (we have done only few test transactions). After the crowdsale is going
443    * then multisig address stays locked for the safety reasons.
444    */
445   function setMultisig(address addr) public onlyOwner {
446     multisigWallet = addr;
447     emit MultiSigChanged(addr);
448   }
449 
450   /**
451    * Allow load refunds back on the contract for the refunding.
452    *
453    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
454    */
455   function loadRefund() public payable inState(State.Failure) {
456     require(msg.value > 0);
457     loadedRefund = loadedRefund.add(msg.value);
458   }
459 
460   /**
461    * Investors can claim refund.
462    *
463    * Note that any refunds from proxy buyers should be handled separately,
464    * and not through this contract.
465    */
466   function refund() public inState(State.Refunding) {
467     // require(token.transferFrom(msg.sender,address(this),tokenAmountOf[msg.sender])); user should approve their token to this contract before this.
468     uint256 weiValue = investedAmountOf[msg.sender];
469     require(weiValue > 0);
470     investedAmountOf[msg.sender] = 0;
471     weiRefunded = weiRefunded.add(weiValue);
472     emit Refund(msg.sender, weiValue);
473     msg.sender.transfer(weiValue);
474   }
475 
476   /**
477    * @return true if the crowdsale has raised enough money to be a successful.
478    */
479   function isMinimumGoalReached() public view  returns (bool reached) {
480     return weiRaised >= minimumFundingGoal;
481   }
482 
483 
484   /**
485    * Crowdfund state machine management.
486    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
487    * Modified by : TokenMagic
488    */
489   function getState() public view returns (State) {
490     if(finalized) return State.Finalized;
491     else if (block.timestamp < startsAt) return State.PreFunding;
492     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
493     else if (isMinimumGoalReached()) return State.Success;
494     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
495     else return State.Failure;
496   }
497 
498   /** This is for manual testing of multisig wallet interaction */
499   function setOwnerTestValue(uint val) onlyOwner public {
500     ownerTestValue = val;
501   }
502 
503   /**
504   * Allow owner to change PrePresaleTokensSold value 
505   * Added by : TokenMagic
506   **/
507   function setPrePresaleTokens(uint _value) onlyOwner public {
508     prePresaleTokensSold = _value;
509     emit PrePresaleTokensValueChanged(_value);
510   }
511 
512   /**
513    * Allow addresses to do participation.
514    * Modified by : TokenMagic
515   */
516   function setParticipantWhitelist(address[] addr, bool status) onlyOwner public {
517     for(uint i = 0; i < addr.length; i++ ){
518       participantWhitelist[addr[i]] = status;
519     }
520     emit Whitelisted(addr, status);
521   }
522 
523   /**
524    * Allow presale to do participation.
525    * Added by : TokenMagic
526   */
527   function setPresaleWhitelist(address addr, bool status) onlyOwner public {
528     presaleWhitelist[addr] = status;
529     emit PresaleWhitelisted(addr, status);
530   }
531   
532   /**
533    * Allow crowdsale owner to change the crowdsale token price.
534    * Added by : TokenMagic
535   */
536   function setPricing(uint _oneTokenInWei) onlyOwner public{
537     oneTokenInWei = _oneTokenInWei;
538     emit TokenPriceChanged(oneTokenInWei);
539   } 
540   
541   /**
542    * Allow crowdsale owner to change the crowdsale beneficiary address.
543    * Added by : TokenMagic
544   */
545   function changeBeneficiary(address _beneficiary) onlyOwner public{
546     beneficiary = _beneficiary; 
547     emit BeneficiaryChanged(beneficiary);
548   }
549   
550   /**
551    * Allow crowdsale owner to change the crowdsale founders team address.
552    * Added by : TokenMagic
553   */
554   function changeFoundersWallet(address _foundersTeamMultisig) onlyOwner public{
555     foundersTeamMultisig = _foundersTeamMultisig;
556     emit FoundersWalletChanged(foundersTeamMultisig);
557   } 
558   
559   /** Interface marker. */
560   function isCrowdsale() public pure returns (bool) {
561     return true;
562   }
563 
564   //
565   // Modifiers
566   //
567 
568   /** Modified allowing execution only if the crowdsale is currently running.  */
569   modifier inState(State state) {
570     require(getState() == state);
571     _;
572   }
573 
574  /**
575    * Called from invest() to confirm if the curret investment does not break our cap rule.
576    */
577   function isBreakingCap(uint tokenAmount) public view returns (bool limitBroken)  {
578     if(tokenAmount > getTokensLeft()) {
579       return true;
580     } else {
581       return false;
582     }
583   }
584 
585   /**
586    * We are sold out when our approve pool becomes empty.
587    */
588   function isCrowdsaleFull() public view returns (bool) {
589     return getTokensLeft() == 0;
590   }
591 
592   /**
593    * Get the amount of unsold tokens allocated to this contract;
594    */
595   function getTokensLeft() public view returns (uint) {
596     return token.allowance(beneficiary, this);
597   }
598 
599 }