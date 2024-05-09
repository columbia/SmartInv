1 pragma solidity ^0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
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
38 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
277 
278 /**
279  * @title Crowdsale
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
316     require(_startTime >= now);
317     require(_endTime >= _startTime);
318     require(_rate > 0);
319     require(_wallet != address(0));
320 
321     token = createTokenContract();
322     startTime = _startTime;
323     endTime = _endTime;
324     rate = _rate;
325     wallet = _wallet;
326   }
327 
328   // creates the token to be sold.
329   // override this method to have crowdsale of a specific mintable token.
330   function createTokenContract() internal returns (MintableToken) {
331     return new MintableToken();
332   }
333 
334 
335   // fallback function can be used to buy tokens
336   function () external payable {
337     buyTokens(msg.sender);
338   }
339 
340   // low level token purchase function
341   function buyTokens(address beneficiary) public payable {
342     require(beneficiary != address(0));
343     require(validPurchase());
344 
345     uint256 weiAmount = msg.value;
346 
347     // calculate token amount to be created
348     uint256 tokens = weiAmount.mul(rate);
349 
350     // update state
351     weiRaised = weiRaised.add(weiAmount);
352 
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355 
356     forwardFunds();
357   }
358 
359   // send ether to the fund collection wallet
360   // override to create custom fund forwarding mechanisms
361   function forwardFunds() internal {
362     wallet.transfer(msg.value);
363   }
364 
365   // @return true if the transaction can buy tokens
366   function validPurchase() internal view returns (bool) {
367     bool withinPeriod = now >= startTime && now <= endTime;
368     bool nonZeroPurchase = msg.value != 0;
369     return withinPeriod && nonZeroPurchase;
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public view returns (bool) {
374     return now > endTime;
375   }
376 
377 
378 }
379 
380 // File: node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
381 
382 /**
383  * @title CappedCrowdsale
384  * @dev Extension of Crowdsale with a max amount of funds raised
385  */
386 contract CappedCrowdsale is Crowdsale {
387   using SafeMath for uint256;
388 
389   uint256 public cap;
390 
391   function CappedCrowdsale(uint256 _cap) public {
392     require(_cap > 0);
393     cap = _cap;
394   }
395 
396   // overriding Crowdsale#validPurchase to add extra cap logic
397   // @return true if investors can buy at the moment
398   function validPurchase() internal view returns (bool) {
399     bool withinCap = weiRaised.add(msg.value) <= cap;
400     return super.validPurchase() && withinCap;
401   }
402 
403   // overriding Crowdsale#hasEnded to add cap logic
404   // @return true if crowdsale event has ended
405   function hasEnded() public view returns (bool) {
406     bool capReached = weiRaised >= cap;
407     return super.hasEnded() || capReached;
408   }
409 
410 }
411 
412 // File: node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
413 
414 /**
415  * @title FinalizableCrowdsale
416  * @dev Extension of Crowdsale where an owner can do extra work
417  * after finishing.
418  */
419 contract FinalizableCrowdsale is Crowdsale, Ownable {
420   using SafeMath for uint256;
421 
422   bool public isFinalized = false;
423 
424   event Finalized();
425 
426   /**
427    * @dev Must be called after crowdsale ends, to do some extra finalization
428    * work. Calls the contract's finalization function.
429    */
430   function finalize() onlyOwner public {
431     require(!isFinalized);
432     require(hasEnded());
433 
434     finalization();
435     Finalized();
436 
437     isFinalized = true;
438   }
439 
440   /**
441    * @dev Can be overridden to add finalization logic. The overriding function
442    * should call super.finalization() to ensure the chain of finalization is
443    * executed entirely.
444    */
445   function finalization() internal {
446   }
447 }
448 
449 // File: node_modules/zeppelin-solidity/contracts/crowdsale/RefundVault.sol
450 
451 /**
452  * @title RefundVault
453  * @dev This contract is used for storing funds while a crowdsale
454  * is in progress. Supports refunding the money if crowdsale fails,
455  * and forwarding it if crowdsale is successful.
456  */
457 contract RefundVault is Ownable {
458   using SafeMath for uint256;
459 
460   enum State { Active, Refunding, Closed }
461 
462   mapping (address => uint256) public deposited;
463   address public wallet;
464   State public state;
465 
466   event Closed();
467   event RefundsEnabled();
468   event Refunded(address indexed beneficiary, uint256 weiAmount);
469 
470   function RefundVault(address _wallet) public {
471     require(_wallet != address(0));
472     wallet = _wallet;
473     state = State.Active;
474   }
475 
476   function deposit(address investor) onlyOwner public payable {
477     require(state == State.Active);
478     deposited[investor] = deposited[investor].add(msg.value);
479   }
480 
481   function close() onlyOwner public {
482     require(state == State.Active);
483     state = State.Closed;
484     Closed();
485     wallet.transfer(this.balance);
486   }
487 
488   function enableRefunds() onlyOwner public {
489     require(state == State.Active);
490     state = State.Refunding;
491     RefundsEnabled();
492   }
493 
494   function refund(address investor) public {
495     require(state == State.Refunding);
496     uint256 depositedValue = deposited[investor];
497     deposited[investor] = 0;
498     investor.transfer(depositedValue);
499     Refunded(investor, depositedValue);
500   }
501 }
502 
503 // File: node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol
504 
505 /**
506  * @title RefundableCrowdsale
507  * @dev Extension of Crowdsale contract that adds a funding goal, and
508  * the possibility of users getting a refund if goal is not met.
509  * Uses a RefundVault as the crowdsale's vault.
510  */
511 contract RefundableCrowdsale is FinalizableCrowdsale {
512   using SafeMath for uint256;
513 
514   // minimum amount of funds to be raised in weis
515   uint256 public goal;
516 
517   // refund vault used to hold funds while crowdsale is running
518   RefundVault public vault;
519 
520   function RefundableCrowdsale(uint256 _goal) public {
521     require(_goal > 0);
522     vault = new RefundVault(wallet);
523     goal = _goal;
524   }
525 
526   // We're overriding the fund forwarding from Crowdsale.
527   // In addition to sending the funds, we want to call
528   // the RefundVault deposit function
529   function forwardFunds() internal {
530     vault.deposit.value(msg.value)(msg.sender);
531   }
532 
533   // if crowdsale is unsuccessful, investors can claim refunds here
534   function claimRefund() public {
535     require(isFinalized);
536     require(!goalReached());
537 
538     vault.refund(msg.sender);
539   }
540 
541   // vault finalization task, called when owner calls finalize()
542   function finalization() internal {
543     if (goalReached()) {
544       vault.close();
545     } else {
546       vault.enableRefunds();
547     }
548 
549     super.finalization();
550   }
551 
552   function goalReached() public view returns (bool) {
553     return weiRaised >= goal;
554   }
555 
556 }
557 
558 // File: node_modules/zeppelin-solidity/contracts/math/Math.sol
559 
560 /**
561  * @title Math
562  * @dev Assorted math operations
563  */
564 
565 library Math {
566   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
567     return a >= b ? a : b;
568   }
569 
570   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
571     return a < b ? a : b;
572   }
573 
574   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
575     return a >= b ? a : b;
576   }
577 
578   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
579     return a < b ? a : b;
580   }
581 }
582 
583 // File: node_modules/zeppelin-solidity/contracts/token/SafeERC20.sol
584 
585 /**
586  * @title SafeERC20
587  * @dev Wrappers around ERC20 operations that throw on failure.
588  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
589  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
590  */
591 library SafeERC20 {
592   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
593     assert(token.transfer(to, value));
594   }
595 
596   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
597     assert(token.transferFrom(from, to, value));
598   }
599 
600   function safeApprove(ERC20 token, address spender, uint256 value) internal {
601     assert(token.approve(spender, value));
602   }
603 }
604 
605 // File: node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
606 
607 /**
608  * @title Contracts that should be able to recover tokens
609  * @author SylTi
610  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
611  * This will prevent any accidental loss of tokens.
612  */
613 contract CanReclaimToken is Ownable {
614   using SafeERC20 for ERC20Basic;
615 
616   /**
617    * @dev Reclaim all ERC20Basic compatible tokens
618    * @param token ERC20Basic The address of the token contract
619    */
620   function reclaimToken(ERC20Basic token) external onlyOwner {
621     uint256 balance = token.balanceOf(this);
622     token.safeTransfer(owner, balance);
623   }
624 
625 }
626 
627 // File: node_modules/zeppelin-solidity/contracts/ownership/HasNoTokens.sol
628 
629 /**
630  * @title Contracts that should not own Tokens
631  * @author Remco Bloemen <remco@2π.com>
632  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
633  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
634  * owner to reclaim the tokens.
635  */
636 contract HasNoTokens is CanReclaimToken {
637 
638  /**
639   * @dev Reject all ERC23 compatible tokens
640   * @param from_ address The address that is transferring the tokens
641   * @param value_ uint256 the amount of the specified token
642   * @param data_ Bytes The data passed from the caller.
643   */
644   function tokenFallback(address from_, uint256 value_, bytes data_) external {
645     from_;
646     value_;
647     data_;
648     revert();
649   }
650 
651 }
652 
653 // File: contracts/WinSale.sol
654 
655 /**
656  * @title WinSale
657  * @dev WinSale is a capped and refundable crowdsale.
658  * The mintable token to be sold must have been previously deployed and passed to the constructor.
659  * After construction the owner of the token contract must transfer ownership to WinSale so it can
660  * mint tokens during the sale.  Ownership of the token will be transferred to the owner of the WinSale
661  * when the sale is finalized.
662  *
663  * Tokens purchased during the sale are immediately minted and transferred to the purchaser.  The payments
664  * are held in a vault until the sale is finalized at which time the funds are either sent to the beneficiary
665  * wallet or refunds are enabled depending on whether the sale met its goal.
666  *
667  * A WinSale may be closed at any time by the owner, who must specify whether or not to enable refunds
668  * without regard to whether or not the original goal was met.  To end the sale naturally, call finalize
669  * rather than close.
670  */
671 contract WinSale is CappedCrowdsale, RefundableCrowdsale, HasNoTokens {
672   using Math for uint256;
673   using SafeMath for uint256;
674 
675   uint256 public minimumBuy;
676 
677   function WinSale(MintableToken _token, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _minimumBuy, uint256 _goal, uint256 _cap, address _wallet) public
678     CappedCrowdsale(_cap)
679     FinalizableCrowdsale()
680     RefundableCrowdsale(_goal)
681     Crowdsale(_startTime, _endTime, _rate, _wallet)
682   {
683     // As goal needs to be met for a successful crowdsale
684     // the value needs to less or equal than a cap which is limit for accepted funds
685     require(_goal <= _cap);
686     token = _token;
687     minimumBuy = _minimumBuy;
688   }
689 
690   // allows the owner to discontinue the token sale early and claim the contents of the vault
691   // @param refund true to enable refunds, false to send funds to beneficiary
692   function close(bool refund) onlyOwner public {
693     require(!isFinalized);
694     goal = refund ? goal.max256(weiRaised.add(1)) : goal.min256(weiRaised);
695     endTime = endTime.min256(now.sub(1));
696     finalize();
697   }
698 
699   // overriding Crowdsale#validPurchase to add extra minimum buy logic
700   // @return true if investors can buy with the value provided
701   function validPurchase() internal constant returns (bool) {
702     bool minSatisfied = msg.value >= minimumBuy;
703     return super.validPurchase() && minSatisfied;
704   }
705 
706   function createTokenContract() internal returns (MintableToken) {
707     return token;
708   }
709 
710   function finalization() internal {
711     token.transferOwnership(owner);
712     super.finalization();
713   }
714 }