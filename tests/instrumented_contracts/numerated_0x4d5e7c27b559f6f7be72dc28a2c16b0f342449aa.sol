1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: zeppelin-solidity/contracts/token/ERC20.sol
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: zeppelin-solidity/contracts/token/StandardToken.sol
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * @dev Increase the amount of tokens that an owner allowed to a spender.
163    *
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    * @param _spender The address which will spend the funds.
169    * @param _addedValue The amount of tokens to increase the allowance by.
170    */
171   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   /**
178    * @dev Decrease the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To decrement
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _subtractedValue The amount of tokens to decrease the allowance by.
186    */
187   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
188     uint oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 // File: contracts/base/crowdsale/Crowdsale.sol
201 
202 /**
203  * @title Crowdsale
204  * @dev Crowdsale is a base contract for managing a token crowdsale.
205  * Crowdsales have a start and end timestamps, where investors can make
206  * token purchases and the crowdsale will assign them tokens based
207  * on a token per ETH rate. Funds collected are forwarded to a wallet
208  * as they arrive.
209  */
210 contract Crowdsale {
211   using SafeMath for uint256;
212 
213   // The token being sold
214   StandardToken public token;
215 
216   // start and end timestamps where investments are allowed (both inclusive)
217   uint256 public startTime;
218   uint256 public endTime;
219 
220   // address where funds are collected
221   address public wallet;
222 
223   // how many token units a buyer gets per wei
224   uint256 public rate;
225 
226   // amount of raised money in wei
227   uint256 public weiRaised;
228 
229   /**
230    * event for token purchase logging
231    * @param purchaser who paid for the tokens
232    * @param beneficiary who got the tokens
233    * @param value weis paid for purchase
234    * @param amount amount of tokens purchased
235    */
236   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
237 
238 
239   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, StandardToken _token) public {
240     require(_startTime >= now);
241     require(_endTime >= _startTime);
242     require(_rate > 0);
243     require(_wallet != address(0));
244     require(_token != address(0));
245 
246     token = _token;
247     startTime = _startTime;
248     endTime = _endTime;
249     rate = _rate;
250     wallet = _wallet;
251   }
252 
253 
254   // fallback function can be used to buy tokens
255   function () external payable {
256     buyTokens(msg.sender);
257   }
258 
259   // low level token purchase function
260   function buyTokens(address beneficiary) public payable {
261     require(beneficiary != address(0));
262     require(validPurchase());
263 
264     uint256 weiAmount = msg.value;
265 
266     // calculate token amount to be created
267     uint256 tokens = weiAmount.mul(rate);
268 
269     // update state
270     weiRaised = weiRaised.add(weiAmount);
271 
272     token.transfer(beneficiary, tokens);
273     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
274 
275     forwardFunds();
276   }
277 
278   // send ether to the fund collection wallet
279   // override to create custom fund forwarding mechanisms
280   function forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 
284   // @return true if the transaction can buy tokens
285   function validPurchase() internal view returns (bool) {
286     bool withinPeriod = now >= startTime && now <= endTime;
287     bool nonZeroPurchase = msg.value != 0;
288     return withinPeriod && nonZeroPurchase;
289   }
290 
291   // @return true if crowdsale event has ended
292   function hasEnded() public view returns (bool) {
293     return now > endTime;
294   }
295 
296 
297 }
298 
299 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
300 
301 /**
302  * @title Ownable
303  * @dev The Ownable contract has an owner address, and provides basic authorization control
304  * functions, this simplifies the implementation of "user permissions".
305  */
306 contract Ownable {
307   address public owner;
308 
309 
310   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312 
313   /**
314    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
315    * account.
316    */
317   function Ownable() public {
318     owner = msg.sender;
319   }
320 
321 
322   /**
323    * @dev Throws if called by any account other than the owner.
324    */
325   modifier onlyOwner() {
326     require(msg.sender == owner);
327     _;
328   }
329 
330 
331   /**
332    * @dev Allows the current owner to transfer control of the contract to a newOwner.
333    * @param newOwner The address to transfer ownership to.
334    */
335   function transferOwnership(address newOwner) public onlyOwner {
336     require(newOwner != address(0));
337     OwnershipTransferred(owner, newOwner);
338     owner = newOwner;
339   }
340 
341 }
342 
343 // File: contracts/base/crowdsale/FinalizableCrowdsale.sol
344 
345 /**
346  * @title FinalizableCrowdsale
347  * @dev Extension of Crowdsale where an owner can do extra work
348  * after finishing.
349  */
350 
351 
352 contract FinalizableCrowdsale is Crowdsale, Ownable {
353   using SafeMath for uint256;
354 
355   bool public isFinalized = false;
356 
357   event Finalized();
358 
359   /**
360    * @dev Must be called after crowdsale ends, to do some extra finalization
361    * work. Calls the contract's finalization function.
362    */
363   function finalize() onlyOwner public {
364     require(!isFinalized);
365     require(hasEnded());
366 
367     finalization();
368     Finalized();
369 
370     isFinalized = true;
371   }
372 
373   /**
374    * @dev Can be overridden to add finalization logic. The overriding function
375    * should call super.finalization() to ensure the chain of finalization is
376    * executed entirely.
377    */
378   function finalization() internal {
379   }
380 }
381 
382 // File: contracts/base/crowdsale/RefundVault.sol
383 
384 /**
385  * @title RefundVault
386  * @dev This contract is used for storing funds while a crowdsale
387  * is in progress. Supports refunding the money if crowdsale fails,
388  * and forwarding it if crowdsale is successful.
389  */
390 
391 
392 contract RefundVault is Ownable {
393   using SafeMath for uint256;
394 
395   enum State { Active, Refunding, Closed }
396 
397   mapping (address => uint256) public deposited;
398   address public wallet;
399   State public state;
400 
401   event Closed();
402   event RefundsEnabled();
403   event Refunded(address indexed beneficiary, uint256 weiAmount);
404 
405   function RefundVault(address _wallet) public {
406     require(_wallet != address(0));
407     wallet = _wallet;
408     state = State.Active;
409   }
410 
411   function deposit(address investor) onlyOwner public payable {
412     require(state == State.Active);
413     deposited[investor] = deposited[investor].add(msg.value);
414   }
415 
416   function close() onlyOwner public {
417     require(state == State.Active);
418     state = State.Closed;
419     Closed();
420     wallet.transfer(this.balance);
421   }
422 
423   function enableRefunds() onlyOwner public {
424     require(state == State.Active);
425     state = State.Refunding;
426     RefundsEnabled();
427   }
428 
429   function refund(address investor) public {
430     require(state == State.Refunding);
431     uint256 depositedValue = deposited[investor];
432     deposited[investor] = 0;
433     investor.transfer(depositedValue);
434     Refunded(investor, depositedValue);
435   }
436 }
437 
438 // File: contracts/base/crowdsale/RefundableCrowdsale.sol
439 
440 /**
441  * @title RefundableCrowdsale
442  * @dev Extension of Crowdsale contract that adds a funding goal, and
443  * the possibility of users getting a refund if goal is not met.
444  * Uses a RefundVault as the crowdsale's vault.
445  */
446 
447 
448 contract RefundableCrowdsale is FinalizableCrowdsale {
449   using SafeMath for uint256;
450 
451   // minimum amount of funds to be raised in weis
452   uint256 public goal;
453 
454   // refund vault used to hold funds while crowdsale is running
455   RefundVault public vault;
456 
457   function RefundableCrowdsale(uint256 _goal) public {
458     require(_goal > 0);
459     vault = new RefundVault(wallet);
460     goal = _goal;
461   }
462 
463   // We're overriding the fund forwarding from Crowdsale.
464   // In addition to sending the funds, we want to call
465   // the RefundVault deposit function
466   function forwardFunds() internal {
467     vault.deposit.value(msg.value)(msg.sender);
468   }
469 
470   // if crowdsale is unsuccessful, investors can claim refunds here
471   function claimRefund() public {
472     require(isFinalized);
473     require(!goalReached());
474 
475     vault.refund(msg.sender);
476   }
477 
478   // vault finalization task, called when owner calls finalize()
479   function finalization() internal {
480     if (goalReached()) {
481       vault.close();
482     } else {
483       vault.enableRefunds();
484     }
485 
486     super.finalization();
487   }
488 
489   function goalReached() public view returns (bool) {
490     return weiRaised >= goal;
491   }
492 
493 }
494 
495 // File: contracts/base/tokens/ReleasableToken.sol
496 
497 /**
498  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
499  *
500  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
501  */
502 
503 
504 
505 /**
506  * Define interface for releasing the token transfer after a successful crowdsale.
507  */
508 contract ReleasableToken is ERC20, Ownable {
509 
510   /* The finalizer contract that allows unlift the transfer limits on this token */
511   address public releaseAgent;
512 
513   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
514   bool public released = false;
515 
516   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
517   mapping (address => bool) public transferAgents;
518 
519   /**
520    * Limit token transfer until the crowdsale is over.
521    *
522    */
523   modifier canTransfer(address _sender) {
524     if (!released) {
525       require(transferAgents[_sender]);
526     }
527 
528     _;
529   }
530 
531   /**
532    * Set the contract that can call release and make the token transferable.
533    *
534    * Design choice. Allow reset the release agent to fix fat finger mistakes.
535    */
536   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
537 
538     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
539     releaseAgent = addr;
540   }
541 
542   /**
543    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
544    */
545   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
546     transferAgents[addr] = state;
547   }
548 
549   /**
550    * One way function to release the tokens to the wild.
551    *
552    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
553    */
554   function releaseTokenTransfer() public onlyReleaseAgent {
555     released = true;
556   }
557 
558   /** The function can be called only before or after the tokens have been released */
559   modifier inReleaseState(bool releaseState) {
560     require(releaseState == released);
561     _;
562   }
563 
564   /** The function can be called only by a whitelisted release agent. */
565   modifier onlyReleaseAgent() {
566     require(msg.sender == releaseAgent);
567     _;
568   }
569 
570   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
571     // Call StandardToken.transfer()
572     return super.transfer(_to, _value);
573   }
574 
575   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
576     // Call StandardToken.transferForm()
577     return super.transferFrom(_from, _to, _value);
578   }
579 
580 }
581 
582 // File: contracts/BRFToken/BRFToken.sol
583 
584 contract BRFToken is StandardToken, ReleasableToken {
585   string public constant name = "Bitrace Token";
586   string public constant symbol = "BRF";
587   uint8 public constant decimals = 18;
588 
589   function BRFToken() public {
590     totalSupply = 1000000000 * (10 ** uint256(decimals));
591     balances[msg.sender] = totalSupply;
592     setReleaseAgent(msg.sender);
593     setTransferAgent(msg.sender, true);
594   }
595 }
596 
597 // File: contracts/BRFToken/BRFCrowdsale.sol
598 
599 contract BRFCrowdsale is RefundableCrowdsale {
600 
601   uint256[3] public icoStartTimes;
602   uint256[3] public icoEndTimes;
603   uint256[3] public icoRates;
604   uint256[3] public icoCaps;
605   uint256 public managementTokenAllocation;
606   address public managementWalletAddress;
607   uint256 public bountyTokenAllocation;
608   address public bountyManagementWalletAddress;
609   bool public contractInitialized = false;
610   uint256 public constant MINIMUM_PURCHASE = 100;
611   mapping(uint256 => uint256) public totalTokensByStage;
612   bool public refundingComplete = false;
613   uint256 public refundingIndex = 0;
614   mapping(address => uint256) public directInvestors;
615   mapping(address => uint256) public indirectInvestors;
616   address[] private directInvestorsCollection;
617 
618   event TokenAllocated(address indexed beneficiary, uint256 tokensAllocated, uint256 amount);
619 
620   function BRFCrowdsale(
621     uint256[3] _icoStartTimes,
622     uint256[3] _icoEndTimes,
623     uint256[3] _icoRates,
624     uint256[3] _icoCaps,
625     address _wallet,
626     uint256 _goal,
627     uint256 _managementTokenAllocation,
628     address _managementWalletAddress,
629     uint256 _bountyTokenAllocation,
630     address _bountyManagementWalletAddress
631     ) public
632     Crowdsale(_icoStartTimes[0], _icoEndTimes[2], _icoRates[0], _wallet, new BRFToken())
633     RefundableCrowdsale(_goal)
634   {
635     require((_icoCaps[0] > 0) && (_icoCaps[1] > 0) && (_icoCaps[2] > 0));
636     require((_icoRates[0] > 0) && (_icoRates[1] > 0) && (_icoRates[2] > 0));
637     require((_icoEndTimes[0] > _icoStartTimes[0]) && (_icoEndTimes[1] > _icoStartTimes[1]) && (_icoEndTimes[2] > _icoStartTimes[2]));
638     require((_icoStartTimes[1] >= _icoEndTimes[0]) && (_icoStartTimes[2] >= _icoEndTimes[1]));
639     require(_managementWalletAddress != owner && _wallet != _managementWalletAddress);
640     require(_bountyManagementWalletAddress != owner && _wallet != _bountyManagementWalletAddress);
641     icoStartTimes = _icoStartTimes;
642     icoEndTimes = _icoEndTimes;
643     icoRates = _icoRates;
644     icoCaps = _icoCaps;
645     managementTokenAllocation = _managementTokenAllocation;
646     managementWalletAddress = _managementWalletAddress;
647     bountyTokenAllocation = _bountyTokenAllocation;
648     bountyManagementWalletAddress = _bountyManagementWalletAddress;
649   }
650 
651   // fallback function can be used to buy tokens
652   function () external payable {
653     require(contractInitialized);
654     buyTokens(msg.sender);
655   }
656 
657   function initializeContract() public onlyOwner {
658     require(!contractInitialized);
659     allocateTokens(managementWalletAddress, managementTokenAllocation, 0, 0);
660     allocateTokens(bountyManagementWalletAddress, bountyTokenAllocation, 0, 0);
661     BRFToken brfToken = BRFToken(token);
662     brfToken.setTransferAgent(managementWalletAddress, true);
663     brfToken.setTransferAgent(bountyManagementWalletAddress, true);
664     contractInitialized = true;
665   }
666 
667   // For Allocating PreSold and Reserved Tokens
668   function allocateTokens(address beneficiary, uint256 tokensToAllocate, uint256 stage, uint256 rate) public onlyOwner {
669     require(stage <= 5);
670     uint256 tokensWithDecimals = toBRFWEI(tokensToAllocate);
671     uint256 weiAmount = rate == 0 ? 0 : tokensWithDecimals.div(rate);
672     weiRaised = weiRaised.add(weiAmount);
673     if (weiAmount > 0) {
674       totalTokensByStage[stage] = totalTokensByStage[stage].add(tokensWithDecimals);
675       indirectInvestors[beneficiary] = indirectInvestors[beneficiary].add(tokensWithDecimals);
676     }
677     token.transfer(beneficiary, tokensWithDecimals);
678     TokenAllocated(beneficiary, tokensWithDecimals, weiAmount);
679   }
680 
681   function buyTokens(address beneficiary) public payable {
682     require(contractInitialized);
683     // update token rate
684     uint256 currTime = now;
685     uint256 stageCap = toBRFWEI(getStageCap(currTime));
686     rate = getTokenRate(currTime);
687     uint256 stage = getStage(currTime);
688     uint256 weiAmount = msg.value;
689     uint256 tokenToGet = weiAmount.mul(rate);
690     if (totalTokensByStage[stage].add(tokenToGet) > stageCap) {
691       stage = stage + 1;
692       rate = getRateByStage(stage);
693       tokenToGet = weiAmount.mul(rate);
694     }
695 
696     require((tokenToGet >= MINIMUM_PURCHASE));
697 
698     if (directInvestors[beneficiary] == 0) {
699       directInvestorsCollection.push(beneficiary);
700     }
701     directInvestors[beneficiary] = directInvestors[beneficiary].add(tokenToGet);
702     totalTokensByStage[stage] = totalTokensByStage[stage].add(tokenToGet);
703     super.buyTokens(beneficiary);
704   }
705 
706   function refundInvestors() public onlyOwner {
707     require(isFinalized);
708     require(!goalReached());
709     require(!refundingComplete);
710     for (uint256 i = 0; i < 20; i++) {
711       if (refundingIndex >= directInvestorsCollection.length) {
712         refundingComplete = true;
713         break;
714       }
715       vault.refund(directInvestorsCollection[refundingIndex]);
716       refundingIndex = refundingIndex.add(1);
717     }
718   }
719 
720   function advanceEndTime(uint256 newEndTime) public onlyOwner {
721     require(!isFinalized);
722     require(newEndTime > endTime);
723     endTime = newEndTime;
724   }
725 
726   function getTokenRate(uint256 currTime) public view returns (uint256) {
727     return getRateByStage(getStage(currTime));
728   }
729 
730   function getStageCap(uint256 currTime) public view returns (uint256) {
731     return getCapByStage(getStage(currTime));
732   }
733 
734   function getStage(uint256 currTime) public view returns (uint256) {
735     if (currTime < icoEndTimes[0]) {
736       return 0;
737     } else if ((currTime > icoEndTimes[0]) && (currTime <= icoEndTimes[1])) {
738       return 1;
739     } else {
740       return 2;
741     }
742   }
743 
744   function getCapByStage(uint256 stage) public view returns (uint256) {
745     return icoCaps[stage];
746   }
747 
748   function getRateByStage(uint256 stage) public view returns (uint256) {
749     return icoRates[stage];
750   }
751 
752   function allocateUnsold() internal {
753     require(hasEnded());
754     BRFToken brfToken = BRFToken(token);
755     uint256 leftOverTokens = brfToken.balanceOf(address(this));
756     if (leftOverTokens > 0) {
757       token.transfer(owner, leftOverTokens);
758     }
759   }
760 
761   function toBRFWEI(uint256 value) internal view returns (uint256) {
762     BRFToken brfToken = BRFToken(token);
763     return (value * (10 ** uint256(brfToken.decimals())));
764   }
765 
766   function finalization() internal {
767     super.finalization();
768     if (goalReached()) {
769       allocateUnsold();
770       BRFToken brfToken = BRFToken(token);
771       brfToken.releaseTokenTransfer();
772       brfToken.transferOwnership(owner);
773     }
774   }
775 
776 }