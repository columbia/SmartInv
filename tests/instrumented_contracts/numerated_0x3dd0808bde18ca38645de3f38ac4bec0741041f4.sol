1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(
100     ERC20Basic _token,
101     address _to,
102     uint256 _value
103   )
104     internal
105   {
106     require(_token.transfer(_to, _value));
107   }
108 
109   function safeTransferFrom(
110     ERC20 _token,
111     address _from,
112     address _to,
113     uint256 _value
114   )
115     internal
116   {
117     require(_token.transferFrom(_from, _to, _value));
118   }
119 
120   function safeApprove(
121     ERC20 _token,
122     address _spender,
123     uint256 _value
124   )
125     internal
126   {
127     require(_token.approve(_spender, _value));
128   }
129 }
130 
131 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
132 
133 /**
134  * @title Crowdsale
135  * @dev Crowdsale is a base contract for managing a token crowdsale,
136  * allowing investors to purchase tokens with ether. This contract implements
137  * such functionality in its most fundamental form and can be extended to provide additional
138  * functionality and/or custom behavior.
139  * The external interface represents the basic interface for purchasing tokens, and conform
140  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
141  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
142  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
143  * behavior.
144  */
145 contract Crowdsale {
146   using SafeMath for uint256;
147   using SafeERC20 for ERC20;
148 
149   // The token being sold
150   ERC20 public token;
151 
152   // Address where funds are collected
153   address public wallet;
154 
155   // How many token units a buyer gets per wei.
156   // The rate is the conversion between wei and the smallest and indivisible token unit.
157   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
158   // 1 wei will give you 1 unit, or 0.001 TOK.
159   uint256 public rate;
160 
161   // Amount of wei raised
162   uint256 public weiRaised;
163 
164   /**
165    * Event for token purchase logging
166    * @param purchaser who paid for the tokens
167    * @param beneficiary who got the tokens
168    * @param value weis paid for purchase
169    * @param amount amount of tokens purchased
170    */
171   event TokenPurchase(
172     address indexed purchaser,
173     address indexed beneficiary,
174     uint256 value,
175     uint256 amount
176   );
177 
178   /**
179    * @param _rate Number of token units a buyer gets per wei
180    * @param _wallet Address where collected funds will be forwarded to
181    * @param _token Address of the token being sold
182    */
183   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
184     require(_rate > 0);
185     require(_wallet != address(0));
186     require(_token != address(0));
187 
188     rate = _rate;
189     wallet = _wallet;
190     token = _token;
191   }
192 
193   // -----------------------------------------
194   // Crowdsale external interface
195   // -----------------------------------------
196 
197   /**
198    * @dev fallback function ***DO NOT OVERRIDE***
199    */
200   function () external payable {
201     buyTokens(msg.sender);
202   }
203 
204   /**
205    * @dev low level token purchase ***DO NOT OVERRIDE***
206    * @param _beneficiary Address performing the token purchase
207    */
208   function buyTokens(address _beneficiary) public payable {
209 
210     uint256 weiAmount = msg.value;
211     _preValidatePurchase(_beneficiary, weiAmount);
212 
213     // calculate token amount to be created
214     uint256 tokens = _getTokenAmount(weiAmount);
215 
216     // update state
217     weiRaised = weiRaised.add(weiAmount);
218 
219     _processPurchase(_beneficiary, tokens);
220     emit TokenPurchase(
221       msg.sender,
222       _beneficiary,
223       weiAmount,
224       tokens
225     );
226 
227     _updatePurchasingState(_beneficiary, weiAmount);
228 
229     _forwardFunds();
230     _postValidatePurchase(_beneficiary, weiAmount);
231   }
232 
233   // -----------------------------------------
234   // Internal interface (extensible)
235   // -----------------------------------------
236 
237   /**
238    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
239    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
240    *   super._preValidatePurchase(_beneficiary, _weiAmount);
241    *   require(weiRaised.add(_weiAmount) <= cap);
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _preValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     require(_beneficiary != address(0));
252     require(_weiAmount != 0);
253   }
254 
255   /**
256    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
257    * @param _beneficiary Address performing the token purchase
258    * @param _weiAmount Value in wei involved in the purchase
259    */
260   function _postValidatePurchase(
261     address _beneficiary,
262     uint256 _weiAmount
263   )
264     internal
265   {
266     // optional override
267   }
268 
269   /**
270    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
271    * @param _beneficiary Address performing the token purchase
272    * @param _tokenAmount Number of tokens to be emitted
273    */
274   function _deliverTokens(
275     address _beneficiary,
276     uint256 _tokenAmount
277   )
278     internal
279   {
280     token.safeTransfer(_beneficiary, _tokenAmount);
281   }
282 
283   /**
284    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
285    * @param _beneficiary Address receiving the tokens
286    * @param _tokenAmount Number of tokens to be purchased
287    */
288   function _processPurchase(
289     address _beneficiary,
290     uint256 _tokenAmount
291   )
292     internal
293   {
294     _deliverTokens(_beneficiary, _tokenAmount);
295   }
296 
297   /**
298    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
299    * @param _beneficiary Address receiving the tokens
300    * @param _weiAmount Value in wei involved in the purchase
301    */
302   function _updatePurchasingState(
303     address _beneficiary,
304     uint256 _weiAmount
305   )
306     internal
307   {
308     // optional override
309   }
310 
311   /**
312    * @dev Override to extend the way in which ether is converted to tokens.
313    * @param _weiAmount Value in wei to be converted into tokens
314    * @return Number of tokens that can be purchased with the specified _weiAmount
315    */
316   function _getTokenAmount(uint256 _weiAmount)
317     internal view returns (uint256)
318   {
319     return _weiAmount.mul(rate);
320   }
321 
322   /**
323    * @dev Determines how ETH is stored/forwarded on purchases.
324    */
325   function _forwardFunds() internal {
326     wallet.transfer(msg.value);
327   }
328 }
329 
330 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
331 
332 /**
333  * @title TimedCrowdsale
334  * @dev Crowdsale accepting contributions only within a time frame.
335  */
336 contract TimedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public openingTime;
340   uint256 public closingTime;
341 
342   /**
343    * @dev Reverts if not in crowdsale time range.
344    */
345   modifier onlyWhileOpen {
346     // solium-disable-next-line security/no-block-members
347     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
348     _;
349   }
350 
351   /**
352    * @dev Constructor, takes crowdsale opening and closing times.
353    * @param _openingTime Crowdsale opening time
354    * @param _closingTime Crowdsale closing time
355    */
356   constructor(uint256 _openingTime, uint256 _closingTime) public {
357     // solium-disable-next-line security/no-block-members
358     require(_openingTime >= block.timestamp);
359     require(_closingTime >= _openingTime);
360 
361     openingTime = _openingTime;
362     closingTime = _closingTime;
363   }
364 
365   /**
366    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
367    * @return Whether crowdsale period has elapsed
368    */
369   function hasClosed() public view returns (bool) {
370     // solium-disable-next-line security/no-block-members
371     return block.timestamp > closingTime;
372   }
373 
374   /**
375    * @dev Extend parent behavior requiring to be within contributing period
376    * @param _beneficiary Token purchaser
377    * @param _weiAmount Amount of wei contributed
378    */
379   function _preValidatePurchase(
380     address _beneficiary,
381     uint256 _weiAmount
382   )
383     internal
384     onlyWhileOpen
385   {
386     super._preValidatePurchase(_beneficiary, _weiAmount);
387   }
388 
389 }
390 
391 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
392 
393 /**
394  * @title Basic token
395  * @dev Basic version of StandardToken, with no allowances.
396  */
397 contract BasicToken is ERC20Basic {
398   using SafeMath for uint256;
399 
400   mapping(address => uint256) internal balances;
401 
402   uint256 internal totalSupply_;
403 
404   /**
405   * @dev Total number of tokens in existence
406   */
407   function totalSupply() public view returns (uint256) {
408     return totalSupply_;
409   }
410 
411   /**
412   * @dev Transfer token for a specified address
413   * @param _to The address to transfer to.
414   * @param _value The amount to be transferred.
415   */
416   function transfer(address _to, uint256 _value) public returns (bool) {
417     require(_value <= balances[msg.sender]);
418     require(_to != address(0));
419 
420     balances[msg.sender] = balances[msg.sender].sub(_value);
421     balances[_to] = balances[_to].add(_value);
422     emit Transfer(msg.sender, _to, _value);
423     return true;
424   }
425 
426   /**
427   * @dev Gets the balance of the specified address.
428   * @param _owner The address to query the the balance of.
429   * @return An uint256 representing the amount owned by the passed address.
430   */
431   function balanceOf(address _owner) public view returns (uint256) {
432     return balances[_owner];
433   }
434 
435 }
436 
437 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
438 
439 /**
440  * @title Burnable Token
441  * @dev Token that can be irreversibly burned (destroyed).
442  */
443 contract BurnableToken is BasicToken {
444 
445   event Burn(address indexed burner, uint256 value);
446 
447   /**
448    * @dev Burns a specific amount of tokens.
449    * @param _value The amount of token to be burned.
450    */
451   function burn(uint256 _value) public {
452     _burn(msg.sender, _value);
453   }
454 
455   function _burn(address _who, uint256 _value) internal {
456     require(_value <= balances[_who]);
457     // no need to require value <= totalSupply, since that would imply the
458     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
459 
460     balances[_who] = balances[_who].sub(_value);
461     totalSupply_ = totalSupply_.sub(_value);
462     emit Burn(_who, _value);
463     emit Transfer(_who, address(0), _value);
464   }
465 }
466 
467 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
468 
469 /**
470  * @title Standard ERC20 token
471  *
472  * @dev Implementation of the basic standard token.
473  * https://github.com/ethereum/EIPs/issues/20
474  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
475  */
476 contract StandardToken is ERC20, BasicToken {
477 
478   mapping (address => mapping (address => uint256)) internal allowed;
479 
480 
481   /**
482    * @dev Transfer tokens from one address to another
483    * @param _from address The address which you want to send tokens from
484    * @param _to address The address which you want to transfer to
485    * @param _value uint256 the amount of tokens to be transferred
486    */
487   function transferFrom(
488     address _from,
489     address _to,
490     uint256 _value
491   )
492     public
493     returns (bool)
494   {
495     require(_value <= balances[_from]);
496     require(_value <= allowed[_from][msg.sender]);
497     require(_to != address(0));
498 
499     balances[_from] = balances[_from].sub(_value);
500     balances[_to] = balances[_to].add(_value);
501     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
502     emit Transfer(_from, _to, _value);
503     return true;
504   }
505 
506   /**
507    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
508    * Beware that changing an allowance with this method brings the risk that someone may use both the old
509    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
510    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
511    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
512    * @param _spender The address which will spend the funds.
513    * @param _value The amount of tokens to be spent.
514    */
515   function approve(address _spender, uint256 _value) public returns (bool) {
516     allowed[msg.sender][_spender] = _value;
517     emit Approval(msg.sender, _spender, _value);
518     return true;
519   }
520 
521   /**
522    * @dev Function to check the amount of tokens that an owner allowed to a spender.
523    * @param _owner address The address which owns the funds.
524    * @param _spender address The address which will spend the funds.
525    * @return A uint256 specifying the amount of tokens still available for the spender.
526    */
527   function allowance(
528     address _owner,
529     address _spender
530    )
531     public
532     view
533     returns (uint256)
534   {
535     return allowed[_owner][_spender];
536   }
537 
538   /**
539    * @dev Increase the amount of tokens that an owner allowed to a spender.
540    * approve should be called when allowed[_spender] == 0. To increment
541    * allowed value is better to use this function to avoid 2 calls (and wait until
542    * the first transaction is mined)
543    * From MonolithDAO Token.sol
544    * @param _spender The address which will spend the funds.
545    * @param _addedValue The amount of tokens to increase the allowance by.
546    */
547   function increaseApproval(
548     address _spender,
549     uint256 _addedValue
550   )
551     public
552     returns (bool)
553   {
554     allowed[msg.sender][_spender] = (
555       allowed[msg.sender][_spender].add(_addedValue));
556     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
557     return true;
558   }
559 
560   /**
561    * @dev Decrease the amount of tokens that an owner allowed to a spender.
562    * approve should be called when allowed[_spender] == 0. To decrement
563    * allowed value is better to use this function to avoid 2 calls (and wait until
564    * the first transaction is mined)
565    * From MonolithDAO Token.sol
566    * @param _spender The address which will spend the funds.
567    * @param _subtractedValue The amount of tokens to decrease the allowance by.
568    */
569   function decreaseApproval(
570     address _spender,
571     uint256 _subtractedValue
572   )
573     public
574     returns (bool)
575   {
576     uint256 oldValue = allowed[msg.sender][_spender];
577     if (_subtractedValue >= oldValue) {
578       allowed[msg.sender][_spender] = 0;
579     } else {
580       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
581     }
582     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
583     return true;
584   }
585 
586 }
587 
588 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
589 
590 /**
591  * @title Standard Burnable Token
592  * @dev Adds burnFrom method to ERC20 implementations
593  */
594 contract StandardBurnableToken is BurnableToken, StandardToken {
595 
596   /**
597    * @dev Burns a specific amount of tokens from the target address and decrements allowance
598    * @param _from address The address which you want to send tokens from
599    * @param _value uint256 The amount of token to be burned
600    */
601   function burnFrom(address _from, uint256 _value) public {
602     require(_value <= allowed[_from][msg.sender]);
603     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
604     // this function needs to emit an event with the updated approval.
605     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
606     _burn(_from, _value);
607   }
608 }
609 
610 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
611 
612 /**
613  * @title Ownable
614  * @dev The Ownable contract has an owner address, and provides basic authorization control
615  * functions, this simplifies the implementation of "user permissions".
616  */
617 contract Ownable {
618   address public owner;
619 
620 
621   event OwnershipRenounced(address indexed previousOwner);
622   event OwnershipTransferred(
623     address indexed previousOwner,
624     address indexed newOwner
625   );
626 
627 
628   /**
629    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
630    * account.
631    */
632   constructor() public {
633     owner = msg.sender;
634   }
635 
636   /**
637    * @dev Throws if called by any account other than the owner.
638    */
639   modifier onlyOwner() {
640     require(msg.sender == owner);
641     _;
642   }
643 
644   /**
645    * @dev Allows the current owner to relinquish control of the contract.
646    * @notice Renouncing to ownership will leave the contract without an owner.
647    * It will not be possible to call the functions with the `onlyOwner`
648    * modifier anymore.
649    */
650   function renounceOwnership() public onlyOwner {
651     emit OwnershipRenounced(owner);
652     owner = address(0);
653   }
654 
655   /**
656    * @dev Allows the current owner to transfer control of the contract to a newOwner.
657    * @param _newOwner The address to transfer ownership to.
658    */
659   function transferOwnership(address _newOwner) public onlyOwner {
660     _transferOwnership(_newOwner);
661   }
662 
663   /**
664    * @dev Transfers control of the contract to a newOwner.
665    * @param _newOwner The address to transfer ownership to.
666    */
667   function _transferOwnership(address _newOwner) internal {
668     require(_newOwner != address(0));
669     emit OwnershipTransferred(owner, _newOwner);
670     owner = _newOwner;
671   }
672 }
673 
674 // File: node_modules/openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
675 
676 /**
677  * @title Contracts that should be able to recover tokens
678  * @author SylTi
679  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
680  * This will prevent any accidental loss of tokens.
681  */
682 contract CanReclaimToken is Ownable {
683   using SafeERC20 for ERC20Basic;
684 
685   /**
686    * @dev Reclaim all ERC20Basic compatible tokens
687    * @param _token ERC20Basic The address of the token contract
688    */
689   function reclaimToken(ERC20Basic _token) external onlyOwner {
690     uint256 balance = _token.balanceOf(this);
691     _token.safeTransfer(owner, balance);
692   }
693 
694 }
695 
696 // File: contracts/SaiexSale.sol
697 
698 contract SaiexToken is StandardBurnableToken, Ownable {
699 
700   string public constant name = "Saiex Token";
701   string public constant symbol = "SAIEX";
702   uint8 public constant decimals = 18;
703 
704   constructor(uint _totalSupply, uint _crowdsaleSupply, uint _fundSupply, address _fundWallet) public {
705     totalSupply_ = _totalSupply;
706 
707     // Allocate fixed supply to token Creator
708     balances[msg.sender] = _crowdsaleSupply;
709     emit Transfer(address(0), msg.sender, _crowdsaleSupply);
710 
711     // Allocate fixed supply to main Wallet
712     balances[_fundWallet] = _fundSupply;
713     emit Transfer(address(0), _fundWallet, _fundSupply);
714   }
715 }
716 
717 
718 contract SaiexCrowdsale is TimedCrowdsale, CanReclaimToken {
719 
720   constructor(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _fundWallet, StandardBurnableToken _token, uint[] _timeBonus, uint[] _amountBonus) public
721     Crowdsale(_rate, _fundWallet, _token)
722     TimedCrowdsale(_openingTime, _closingTime)
723   {
724     // Setup time and amount bonus
725     TimeBonusPricing(_timeBonus);
726     AmountBonusPricing(_amountBonus);
727   }
728 
729   // Override to extend the way in which ether is converted to tokens.
730   function _getTokenAmount(uint256 _weiAmount)
731     internal view returns (uint256)
732   {
733     uint256 currentRate = getCurrentRate(_weiAmount);
734     return currentRate.mul(_weiAmount);
735   }
736 
737   // Returns the rate of tokens per wei depending on time and amount
738   function getCurrentRate(uint256 _weiAmount) public view returns (uint256) {
739     uint256 currentRate;
740     currentRate = rate;
741 
742     // Apply time bonus
743     uint256 timeBonusRate;
744     timeBonusRate = getCurrentTimeBonusRate();
745     currentRate = currentRate.mul(timeBonusRate).div(100);
746 
747     // Apply amount bonus
748     uint256 amountBonusRate;
749     amountBonusRate = getCurrentAmountBonusRate(_weiAmount);
750     currentRate = currentRate.mul(amountBonusRate).div(100);
751 
752     return currentRate;
753   }
754 
755 
756   struct Bonus {
757     // Timestamp/Amount for bonus
758     uint timeOrAmount;
759     // Bonus rate multiplier, for example rate=120 means 20% Bonus
760     uint rateMultiplier;
761   }
762 
763   // Store bonuses in a fixed array, so that it can be seen in a blockchain explorer
764   uint public constant MAX_BONUS = 10;
765   Bonus[10] public timeBonus;
766   Bonus[10] public amountBonus;
767 
768   // How many active time/amount Bonus we have
769   uint public timeBonusCount;
770   uint public amountBonusCount;
771 
772   // Get the current time bonus rateMultiplier
773   function getCurrentTimeBonusRate() private constant returns (uint) {
774     uint i;
775     for(i=0; i<timeBonus.length; i++) {
776       if(block.timestamp < timeBonus[i].timeOrAmount) {
777         return timeBonus[i].rateMultiplier;
778       }
779     }
780     return 100;
781   }
782 
783   // Get the current amount bonus rateMultiplier
784   // @param _weiAmount uint256 invested amount
785   function getCurrentAmountBonusRate(uint256 _weiAmount) private constant returns (uint) {
786     uint i;
787     for(i=0; i<amountBonus.length; i++) {
788       if(_weiAmount.mul(rate) >= amountBonus[i].timeOrAmount) {
789         return amountBonus[i].rateMultiplier;
790       }
791     }
792     return 100;
793   }
794 
795   // @dev Construction, creating a list of time-based bonuses
796   // @param _bonuses uint[] bonuses Pairs of (timeOrAmount, rateMultiplier)
797   function TimeBonusPricing(uint[] _bonuses) internal {
798     // Check array length, we need tuples
799     require(!(_bonuses.length % 2 == 1 || _bonuses.length >= MAX_BONUS*2));
800     timeBonusCount = _bonuses.length / 2;
801     uint lastTimeOrAmount = 0;
802 
803     for(uint i=0; i<_bonuses.length/2; i++) {
804       timeBonus[i].timeOrAmount  = _bonuses[i*2];
805       timeBonus[i].rateMultiplier = _bonuses[i*2+1];
806 
807       // Next timestamp should be either 0 or later than previous one
808       require(!((lastTimeOrAmount != 0) && (timeBonus[i].rateMultiplier != 100) && (timeBonus[i].timeOrAmount <= lastTimeOrAmount)));
809       lastTimeOrAmount = timeBonus[i].timeOrAmount;
810     }
811 
812     // Last rateMultiplier should be 100, indicating end of bonus
813     require(timeBonus[timeBonusCount-1].rateMultiplier == 100);
814   }
815 
816   // @dev Construction, creating a list of amount-based bonuses
817   // @param _bonuses uint[] bonuses Pairs of (timeOrAmount, rateMultiplier)
818   function AmountBonusPricing(uint[] _bonuses) internal {
819     // Check array length, we need tuples
820     require(!(_bonuses.length % 2 == 1 || _bonuses.length >= MAX_BONUS*2));
821     amountBonusCount = _bonuses.length / 2;
822     uint lastTimeOrAmount = 0;
823     for(uint i=0; i<_bonuses.length/2; i++) {
824       amountBonus[i].timeOrAmount  = _bonuses[i*2];
825       amountBonus[i].rateMultiplier = _bonuses[i*2+1];
826 
827       // Next amount should be 0 or smaller
828       require(!((lastTimeOrAmount != 0) && (amountBonus[i].timeOrAmount >= lastTimeOrAmount)));
829       lastTimeOrAmount = amountBonus[i].timeOrAmount;
830     }
831 
832     // Last rateMultiplier should be 100, indicating end of bonus
833     require(amountBonus[amountBonusCount-1].rateMultiplier == 100);
834   }
835 
836   // @dev allow Contract owner to change bonuses
837   // @param _timeBonus uint[] bonuses Pairs of (timestamp, rateMultiplier)
838   // @param _amountBonus uint[] bonuses Pairs of (wei amount, rateMultiplier)
839   function changeBonuses(uint[] _timeBonus, uint[] _amountBonus) external {
840     require(msg.sender == owner);
841     TimeBonusPricing(_timeBonus);
842     AmountBonusPricing(_amountBonus);
843   }
844 
845   // @dev allow Contract owner to change start/stop time
846   // @param _openingTime uint256  opening time
847   // @param _closingTime uint256  closing time
848   function changeOpeningClosingTime(uint256 _openingTime, uint256 _closingTime) external {
849     require(msg.sender == owner);
850     openingTime = _openingTime;
851     closingTime = _closingTime;
852   }
853 
854 	// @dev allow Contract owner to change rate
855   // @param _rate uint rate
856   function changeRate(uint _rate) external {
857     require(msg.sender == owner);
858     rate = _rate;
859   }
860 }