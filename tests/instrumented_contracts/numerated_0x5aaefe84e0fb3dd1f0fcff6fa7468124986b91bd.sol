1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15   public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20   public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23   public returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     uint256 c = _a * _b;
58     require(c / _a == _b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     require(_b > 0);
68     // Solidity only automatically asserts when dividing by 0
69     uint256 c = _a / _b;
70     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     require(_b <= _a);
80     uint256 c = _a - _b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     uint256 c = _a + _b;
90     require(c >= _a);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0);
101     return a % b;
102   }
103 }
104 
105 // File: contracts/StandardToken.sol
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
112  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20 {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) private balances;
118 
119   mapping(address => mapping(address => uint256)) private allowed;
120 
121   uint256 private totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256) {
136     return balances[_owner];
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_value <= balances[msg.sender]);
156     require(_to != address(0));
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188     require(_to != address(0));
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = (
208     allowed[msg.sender][_spender].add(_addedValue));
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   /**
214    * @dev Decrease the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To decrement
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _subtractedValue The amount of tokens to decrease the allowance by.
221    */
222   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
223     uint256 oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue >= oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Internal function that mints an amount of the token and assigns it to
235    * an account. This encapsulates the modification of balances such that the
236    * proper events are emitted.
237    * @param _account The account that will receive the created tokens.
238    * @param _amount The amount that will be created.
239    */
240   function _mint(address _account, uint256 _amount) internal {
241     require(_account != 0);
242     totalSupply_ = totalSupply_.add(_amount);
243     balances[_account] = balances[_account].add(_amount);
244     emit Transfer(address(0), _account, _amount);
245   }
246 
247   /**
248    * @dev Internal function that burns an amount of the token of a given
249    * account.
250    * @param _account The account whose tokens will be burnt.
251    * @param _amount The amount that will be burnt.
252    */
253   function _burn(address _account, uint256 _amount) internal {
254     require(_account != 0);
255     require(_amount <= balances[_account]);
256 
257     totalSupply_ = totalSupply_.sub(_amount);
258     balances[_account] = balances[_account].sub(_amount);
259     emit Transfer(_account, address(0), _amount);
260   }
261 
262   /**
263    * @dev Internal function that burns an amount of the token of a given
264    * account, deducting from the sender's allowance for said account. Uses the
265    * internal _burn function.
266    * @param _account The account whose tokens will be burnt.
267    * @param _amount The amount that will be burnt.
268    */
269   function _burnFrom(address _account, uint256 _amount) internal {
270     require(_amount <= allowed[_account][msg.sender]);
271 
272     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
273     // this function needs to emit an event with the updated approval.
274     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
275     _burn(_account, _amount);
276   }
277 }
278 
279 // File: contracts/BurnableToken.sol
280 
281 /**
282  * @title Burnable Token
283  * @dev Token that can be irreversibly burned (destroyed).
284  */
285 contract BurnableToken is StandardToken {
286 
287   event Burn(address indexed burner, uint256 value);
288 
289   /**
290    * @dev Burns a specific amount of tokens.
291    * @param _value The amount of token to be burned.
292    */
293   function burn(uint256 _value) public {
294     _burn(msg.sender, _value);
295   }
296 
297   /**
298    * @dev Burns a specific amount of tokens from the target address and decrements allowance
299    * @param _from address The address which you want to send tokens from
300    * @param _value uint256 The amount of token to be burned
301    */
302   function burnFrom(address _from, uint256 _value) public {
303     _burnFrom(_from, _value);
304   }
305 
306   /**
307    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
308    * an additional Burn event.
309    */
310   function _burn(address _who, uint256 _value) internal {
311     super._burn(_who, _value);
312     emit Burn(_who, _value);
313   }
314 }
315 
316 // File: contracts/SafeERC20.sol
317 
318 /**
319  * @title SafeERC20
320  * @dev Wrappers around ERC20 operations that throw on failure.
321  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
322  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
323  */
324 library SafeERC20 {
325   function safeTransfer(
326     ERC20 _token,
327     address _to,
328     uint256 _value
329   )
330   internal
331   {
332     require(_token.transfer(_to, _value));
333   }
334 
335   function safeTransferFrom(
336     ERC20 _token,
337     address _from,
338     address _to,
339     uint256 _value
340   )
341   internal
342   {
343     require(_token.transferFrom(_from, _to, _value));
344   }
345 
346   function safeApprove(
347     ERC20 _token,
348     address _spender,
349     uint256 _value
350   )
351   internal
352   {
353     require(_token.approve(_spender, _value));
354   }
355 }
356 
357 // File: contracts/Crowdsale.sol
358 
359 /**
360  * @title Crowdsale
361  * @dev Crowdsale is a base contract for managing a token crowdsale,
362  * allowing investors to purchase tokens with ether. This contract implements
363  * such functionality in its most fundamental form and can be extended to provide additional
364  * functionality and/or custom behavior.
365  * The external interface represents the basic interface for purchasing tokens, and conform
366  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
367  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
368  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
369  * behavior.
370  */
371 contract Crowdsale {
372   using SafeMath for uint256;
373   using SafeERC20 for ERC20;
374 
375   // The token being sold
376   ERC20 public token;
377 
378   // Address where funds are collected
379   address public wallet;
380 
381   // How many token units a buyer gets per wei.
382   // The rate is the conversion between wei and the smallest and indivisible token unit.
383   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
384   // 1 wei will give you 1 unit, or 0.001 TOK.
385   uint256 public rate;
386 
387   // Amount of wei raised
388   uint256 public weiRaised;
389 
390   /**
391    * Event for token purchase logging
392    * @param purchaser who paid for the tokens
393    * @param beneficiary who got the tokens
394    * @param value weis paid for purchase
395    * @param amount amount of tokens purchased
396    */
397   event TokenPurchase(
398     address indexed purchaser,
399     address indexed beneficiary,
400     uint256 value,
401     uint256 amount
402   );
403 
404   /**
405    * @param _rate Number of token units a buyer gets per wei
406    * @param _wallet Address where collected funds will be forwarded to
407    * @param _token Address of the token being sold
408    */
409   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
410     require(_rate > 0);
411     require(_wallet != address(0));
412     require(_token != address(0));
413 
414     rate = _rate;
415     wallet = _wallet;
416     token = _token;
417   }
418 
419   /**
420    * @dev fallback function ***DO NOT OVERRIDE***
421    */
422   function() external payable {
423     buyTokens(msg.sender);
424   }
425 
426   /**
427    * @dev low level token purchase ***DO NOT OVERRIDE***
428    * @param _beneficiary Address performing the token purchase
429    */
430   function buyTokens(address _beneficiary) public payable {
431 
432     uint256 weiAmount = msg.value;
433     _preValidatePurchase(_beneficiary, weiAmount);
434 
435     // calculate token amount to be created
436     uint256 tokens = _getTokenAmount(weiAmount);
437 
438     // update state
439     weiRaised = weiRaised.add(weiAmount);
440 
441     _processPurchase(_beneficiary, tokens);
442     emit TokenPurchase(
443       msg.sender,
444       _beneficiary,
445       weiAmount,
446       tokens
447     );
448 
449     _updatePurchasingState(_beneficiary, weiAmount);
450 
451     _forwardFunds();
452     _postValidatePurchase(_beneficiary, weiAmount);
453   }
454 
455   /**
456    * @dev Validation of an incoming purchase.
457    * Use require statements to revert state when conditions are not met.
458    * Use `super` in contracts that inherit from Crowdsale to extend their validations.
459    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
460    *   super._preValidatePurchase(_beneficiary, _weiAmount);
461    *   require(weiRaised.add(_weiAmount) <= cap);
462    * @param _beneficiary Address performing the token purchase
463    * @param _weiAmount Value in wei involved in the purchase
464    */
465   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
466     require(_beneficiary != address(0));
467     require(_weiAmount != 0);
468   }
469 
470   /**
471    * @dev Validation of an executed purchase.
472    * Observe state and use revert statements to undo rollback when valid conditions are not met.
473    * @param _beneficiary Address performing the token purchase
474    * @param _weiAmount Value in wei involved in the purchase
475    */
476   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
477     // optional override
478   }
479 
480   /**
481    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its
482    * tokens.
483    * @param _beneficiary Address performing the token purchase
484    * @param _tokenAmount Number of tokens to be emitted
485    */
486   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
487     token.safeTransfer(_beneficiary, _tokenAmount);
488   }
489 
490   /**
491    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
492    * @param _beneficiary Address receiving the tokens
493    * @param _tokenAmount Number of tokens to be purchased
494    */
495   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
496     _deliverTokens(_beneficiary, _tokenAmount);
497   }
498 
499   /**
500    * @dev Override for extensions that require an internal state to check for validity(current user contributions, etc.)
501    * @param _beneficiary Address receiving the tokens
502    * @param _weiAmount Value in wei involved in the purchase
503    */
504   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
505     // optional override
506   }
507 
508   /**
509    * @dev Override to extend the way in which ether is converted to tokens.
510    * @param _weiAmount Value in wei to be converted into tokens
511    * @return Number of tokens that can be purchased with the specified _weiAmount
512    */
513   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
514     return _weiAmount.mul(rate);
515   }
516 
517   /**
518    * @dev Determines how ETH is stored/forwarded on purchases.
519    */
520   function _forwardFunds() internal {
521     wallet.transfer(msg.value);
522   }
523 }
524 
525 // File: contracts/Ownable.sol
526 
527 /**
528  * @title Ownable
529  * @dev The Ownable contract has an owner address, and provides basic authorization control
530  * functions, this simplifies the implementation of "user permissions".
531  */
532 contract Ownable {
533   address public owner;
534 
535   event OwnershipRenounced(address indexed previousOwner);
536 
537   event OwnershipTransferred(
538     address indexed previousOwner,
539     address indexed newOwner
540   );
541 
542   /**
543    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
544    * account.
545    */
546   constructor() public {
547     owner = msg.sender;
548   }
549 
550   /**
551    * @dev Throws if called by any account other than the owner.
552    */
553   modifier onlyOwner() {
554     require(msg.sender == owner);
555     _;
556   }
557 
558   /**
559    * @dev Allows the current owner to relinquish control of the contract.
560    * @notice Renouncing to ownership will leave the contract without an owner.
561    * It will not be possible to call the functions with the `onlyOwner`
562    * modifier anymore.
563    */
564   function renounceOwnership() public onlyOwner {
565     emit OwnershipRenounced(owner);
566     owner = address(0);
567   }
568 
569   /**
570    * @dev Allows the current owner to transfer control of the contract to a newOwner.
571    * @param _newOwner The address to transfer ownership to.
572    */
573   function transferOwnership(address _newOwner) public onlyOwner {
574     _transferOwnership(_newOwner);
575   }
576 
577   /**
578    * @dev Transfers control of the contract to a newOwner.
579    * @param _newOwner The address to transfer ownership to.
580    */
581   function _transferOwnership(address _newOwner) internal {
582     require(_newOwner != address(0));
583     emit OwnershipTransferred(owner, _newOwner);
584     owner = _newOwner;
585   }
586 }
587 
588 // File: contracts/EvedoToken.sol
589 
590 /**
591  * The Smart contract for Evedo Token. Based on OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity
592  */
593 contract EvedoToken is BurnableToken {
594 
595   string public name = "Evedo Token";
596   string public symbol = "EVED";
597   uint8 public decimals = 18;
598 
599   constructor(uint initialBalance) public {
600     _mint(msg.sender, initialBalance);
601   }
602 }
603 
604 // File: contracts/EvedoCrowdSale.sol
605 
606 contract EvedoCrowdSale is Crowdsale, Ownable {
607 
608   using SafeMath for uint;
609 
610   // 160M tokens at 2000 per eth is 80 000 ETH
611   uint public constant ETH_CAP = 80000 * (10 ** 18);
612 
613   struct Stage {
614     uint stageRate; // tokens for one ETH
615     uint stageCap; // max ETH to be raised at this stage
616     uint stageRaised; // amount raised in ETH
617   }
618 
619   Stage[7] public stages;
620 
621   uint public currentStage = 0;
622 
623   bool private isOpen = true;
624 
625   modifier isSaleOpen() {
626     require(isOpen);
627     _;
628   }
629 
630   /**
631   * @param _rate is the amount of tokens for 1ETH at the main event
632   * @param _wallet the address of the owner
633   * @param _token the address of the token contract
634   */
635   constructor(uint256 _rate, address _wallet, EvedoToken _token) public Crowdsale(_rate, _wallet, _token) {
636     // hardcode stages
637     stages[0] = Stage(2600, 6000 * (10 ** 18), 0);
638     stages[1] = Stage(2600, 6000 * (10 ** 18), 0);
639     stages[2] = Stage(2400, ETH_CAP, 0);
640     stages[3] = Stage(2300, ETH_CAP, 0);
641     stages[4] = Stage(2200, ETH_CAP, 0);
642     stages[5] = Stage(2100, ETH_CAP, 0);
643     stages[6] = Stage(2000, ETH_CAP, 0);
644 
645     // call superclass constructor and set rate at current stage
646     currentStage = 0;
647   }
648 
649   /**
650   * Set new crowdsale stage
651   */
652   function setStage(uint _stage) public onlyOwner {
653     require(_stage > currentStage);
654     currentStage = _stage;
655     rate = stages[currentStage].stageRate;
656   }
657 
658   function open() public onlyOwner {
659     isOpen = true;
660   }
661 
662   function close() public onlyOwner {
663     isOpen = false;
664   }
665 
666   /**
667   * Closes the sale
668   */
669   function finalize() public onlyOwner {
670     isOpen = false;
671   }
672 
673   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isSaleOpen {
674     // make sure we don't raise more than cap for each stage
675     require(stages[currentStage].stageRaised < stages[currentStage].stageCap, "Stage Cap reached");
676     stages[currentStage].stageRaised = stages[currentStage].stageRaised.add(_weiAmount);
677     super._preValidatePurchase(_beneficiary, _weiAmount);
678   }
679 }
680 
681 // File: contracts/EvedoExclusiveSale.sol
682 
683 /**
684 * Contract for the Exclusive crowd sale only
685 */
686 contract EvedoExclusiveSale is Crowdsale, Ownable {
687 
688   using SafeMath for uint;
689 
690   uint public constant ETH_CAP = 2000 * (10 ** 18);
691 
692   bool private isOpen = true;
693 
694   modifier isSaleOpen() {
695     require(isOpen);
696     _;
697   }
698 
699   /**
700   * @param _rate is the amount of tokens for 1ETH at the main event
701   * @param _wallet the address of the owner
702   * @param _token the address of the token contract
703   */
704   constructor(uint256 _rate, address _wallet, EvedoToken _token) public Crowdsale(_rate, _wallet, _token) {
705 
706   }
707 
708   function open() public onlyOwner {
709     isOpen = true;
710   }
711 
712   function close() public onlyOwner {
713     isOpen = false;
714   }
715 
716   /**
717   * Closes the sale and returns unsold tokens
718   */
719   function finalize() public onlyOwner {
720     isOpen = false;
721     token.safeTransfer(owner, token.balanceOf(this));
722   }
723 
724   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isSaleOpen {
725     // make sure we don't raise more than cap
726     require(weiRaised < ETH_CAP, "Sale Cap reached");
727     super._preValidatePurchase(_beneficiary, _weiAmount);
728   }
729 }