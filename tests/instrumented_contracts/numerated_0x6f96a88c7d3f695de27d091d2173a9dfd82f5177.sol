1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(
29     ERC20Basic _token,
30     address _to,
31     uint256 _value
32   )
33     internal
34   {
35     require(_token.transfer(_to, _value));
36   }
37 
38   function safeTransferFrom(
39     ERC20 _token,
40     address _from,
41     address _to,
42     uint256 _value
43   )
44     internal
45   {
46     require(_token.transferFrom(_from, _to, _value));
47   }
48 
49   function safeApprove(
50     ERC20 _token,
51     address _spender,
52     uint256 _value
53   )
54     internal
55   {
56     require(_token.approve(_spender, _value));
57   }
58 }
59 
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    * @notice Renouncing to ownership will leave the contract without an owner.
97    * It will not be possible to call the functions with the `onlyOwner`
98    * modifier anymore.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112 
113   /**
114    * @dev Transfers control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function _transferOwnership(address _newOwner) internal {
118     require(_newOwner != address(0));
119     emit OwnershipTransferred(owner, _newOwner);
120     owner = _newOwner;
121   }
122 }
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address _owner, address _spender)
138     public view returns (uint256);
139 
140   function transferFrom(address _from, address _to, uint256 _value)
141     public returns (bool);
142 
143   function approve(address _spender, uint256 _value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 
152 
153 
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that throw on error
157  */
158 library SafeMath {
159 
160   /**
161   * @dev Multiplies two numbers, throws on overflow.
162   */
163   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
164     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
165     // benefit is lost if 'b' is also tested.
166     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167     if (_a == 0) {
168       return 0;
169     }
170 
171     c = _a * _b;
172     assert(c / _a == _b);
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers, truncating the quotient.
178   */
179   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
180     // assert(_b > 0); // Solidity automatically throws when dividing by 0
181     // uint256 c = _a / _b;
182     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
183     return _a / _b;
184   }
185 
186   /**
187   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188   */
189   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
190     assert(_b <= _a);
191     return _a - _b;
192   }
193 
194   /**
195   * @dev Adds two numbers, throws on overflow.
196   */
197   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
198     c = _a + _b;
199     assert(c >= _a);
200     return c;
201   }
202 }
203 
204 
205 
206 
207 /**
208  * @title Crowdsale
209  * @dev Crowdsale is a base contract for managing a token crowdsale,
210  * allowing investors to purchase tokens with ether. This contract implements
211  * such functionality in its most fundamental form and can be extended to provide additional
212  * functionality and/or custom behavior.
213  * The external interface represents the basic interface for purchasing tokens, and conform
214  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
215  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
216  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
217  * behavior.
218  */
219 contract Crowdsale {
220   using SafeMath for uint256;
221   using SafeERC20 for ERC20;
222 
223   // The token being sold
224   ERC20 public token;
225 
226   // Address where funds are collected
227   address public wallet;
228 
229   // How many token units a buyer gets per wei.
230   // The rate is the conversion between wei and the smallest and indivisible token unit.
231   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
232   // 1 wei will give you 1 unit, or 0.001 TOK.
233   uint256 public rate;
234 
235   // Amount of wei raised
236   uint256 public weiRaised;
237 
238   /**
239    * Event for token purchase logging
240    * @param purchaser who paid for the tokens
241    * @param beneficiary who got the tokens
242    * @param value weis paid for purchase
243    * @param amount amount of tokens purchased
244    */
245   event TokenPurchase(
246     address indexed purchaser,
247     address indexed beneficiary,
248     uint256 value,
249     uint256 amount
250   );
251 
252   /**
253    * @param _rate Number of token units a buyer gets per wei
254    * @param _wallet Address where collected funds will be forwarded to
255    * @param _token Address of the token being sold
256    */
257   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
258     require(_rate > 0);
259     require(_wallet != address(0));
260     require(_token != address(0));
261 
262     rate = _rate;
263     wallet = _wallet;
264     token = _token;
265   }
266 
267   // -----------------------------------------
268   // Crowdsale external interface
269   // -----------------------------------------
270 
271   /**
272    * @dev fallback function ***DO NOT OVERRIDE***
273    */
274   function () external payable {
275     buyTokens(msg.sender);
276   }
277 
278   /**
279    * @dev low level token purchase ***DO NOT OVERRIDE***
280    * @param _beneficiary Address performing the token purchase
281    */
282   function buyTokens(address _beneficiary) public payable {
283 
284     uint256 weiAmount = msg.value;
285     _preValidatePurchase(_beneficiary, weiAmount);
286 
287     // calculate token amount to be created
288     uint256 tokens = _getTokenAmount(weiAmount);
289 
290     // update state
291     weiRaised = weiRaised.add(weiAmount);
292 
293     _processPurchase(_beneficiary, tokens);
294     emit TokenPurchase(
295       msg.sender,
296       _beneficiary,
297       weiAmount,
298       tokens
299     );
300 
301     _updatePurchasingState(_beneficiary, weiAmount);
302 
303     _forwardFunds();
304     _postValidatePurchase(_beneficiary, weiAmount);
305   }
306 
307   // -----------------------------------------
308   // Internal interface (extensible)
309   // -----------------------------------------
310 
311   /**
312    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
313    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
314    *   super._preValidatePurchase(_beneficiary, _weiAmount);
315    *   require(weiRaised.add(_weiAmount) <= cap);
316    * @param _beneficiary Address performing the token purchase
317    * @param _weiAmount Value in wei involved in the purchase
318    */
319   function _preValidatePurchase(
320     address _beneficiary,
321     uint256 _weiAmount
322   )
323     internal
324   {
325     require(_beneficiary != address(0));
326     require(_weiAmount != 0);
327   }
328 
329   /**
330    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
331    * @param _beneficiary Address performing the token purchase
332    * @param _weiAmount Value in wei involved in the purchase
333    */
334   function _postValidatePurchase(
335     address _beneficiary,
336     uint256 _weiAmount
337   )
338     internal
339   {
340     // optional override
341   }
342 
343   /**
344    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
345    * @param _beneficiary Address performing the token purchase
346    * @param _tokenAmount Number of tokens to be emitted
347    */
348   function _deliverTokens(
349     address _beneficiary,
350     uint256 _tokenAmount
351   )
352     internal
353   {
354     token.safeTransfer(_beneficiary, _tokenAmount);
355   }
356 
357   /**
358    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
359    * @param _beneficiary Address receiving the tokens
360    * @param _tokenAmount Number of tokens to be purchased
361    */
362   function _processPurchase(
363     address _beneficiary,
364     uint256 _tokenAmount
365   )
366     internal
367   {
368     _deliverTokens(_beneficiary, _tokenAmount);
369   }
370 
371   /**
372    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
373    * @param _beneficiary Address receiving the tokens
374    * @param _weiAmount Value in wei involved in the purchase
375    */
376   function _updatePurchasingState(
377     address _beneficiary,
378     uint256 _weiAmount
379   )
380     internal
381   {
382     // optional override
383   }
384 
385   /**
386    * @dev Override to extend the way in which ether is converted to tokens.
387    * @param _weiAmount Value in wei to be converted into tokens
388    * @return Number of tokens that can be purchased with the specified _weiAmount
389    */
390   function _getTokenAmount(uint256 _weiAmount)
391     internal view returns (uint256)
392   {
393     return _weiAmount.mul(rate);
394   }
395 
396   /**
397    * @dev Determines how ETH is stored/forwarded on purchases.
398    */
399   function _forwardFunds() internal {
400     wallet.transfer(msg.value);
401   }
402 }
403 
404 
405 
406 
407 
408 
409 
410 /**
411  * @title CappedCrowdsale
412  * @dev Crowdsale with a limit for total contributions.
413  */
414 contract CappedCrowdsale is Crowdsale {
415   using SafeMath for uint256;
416 
417   uint256 public cap;
418 
419   /**
420    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
421    * @param _cap Max amount of wei to be contributed
422    */
423   constructor(uint256 _cap) public {
424     require(_cap > 0);
425     cap = _cap;
426   }
427 
428   /**
429    * @dev Checks whether the cap has been reached.
430    * @return Whether the cap was reached
431    */
432   function capReached() public view returns (bool) {
433     return weiRaised >= cap;
434   }
435 
436   /**
437    * @dev Extend parent behavior requiring purchase to respect the funding cap.
438    * @param _beneficiary Token purchaser
439    * @param _weiAmount Amount of wei contributed
440    */
441   function _preValidatePurchase(
442     address _beneficiary,
443     uint256 _weiAmount
444   )
445     internal
446   {
447     super._preValidatePurchase(_beneficiary, _weiAmount);
448     require(weiRaised.add(_weiAmount) <= cap);
449   }
450 
451 }
452 
453 
454 
455 
456 
457 
458 
459 /**
460  * @title MintedCrowdsale
461  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
462  * Token ownership should be transferred to MintedCrowdsale for minting.
463  */
464 contract MintedCrowdsale is Crowdsale {
465 
466   /**
467    * @dev Overrides delivery by minting tokens upon purchase.
468    * @param _beneficiary Token purchaser
469    * @param _tokenAmount Number of tokens to be minted
470    */
471   function _deliverTokens(
472     address _beneficiary,
473     uint256 _tokenAmount
474   )
475     internal
476   {
477     // Potentially dangerous assumption about the type of the token.
478     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
479   }
480 }
481 
482 
483 
484 
485 
486 
487 
488 
489 
490 
491 
492 
493 
494 /**
495  * @title Basic token
496  * @dev Basic version of StandardToken, with no allowances.
497  */
498 contract BasicToken is ERC20Basic {
499   using SafeMath for uint256;
500 
501   mapping(address => uint256) internal balances;
502 
503   uint256 internal totalSupply_;
504 
505   /**
506   * @dev Total number of tokens in existence
507   */
508   function totalSupply() public view returns (uint256) {
509     return totalSupply_;
510   }
511 
512   /**
513   * @dev Transfer token for a specified address
514   * @param _to The address to transfer to.
515   * @param _value The amount to be transferred.
516   */
517   function transfer(address _to, uint256 _value) public returns (bool) {
518     require(_value <= balances[msg.sender]);
519     require(_to != address(0));
520 
521     balances[msg.sender] = balances[msg.sender].sub(_value);
522     balances[_to] = balances[_to].add(_value);
523     emit Transfer(msg.sender, _to, _value);
524     return true;
525   }
526 
527   /**
528   * @dev Gets the balance of the specified address.
529   * @param _owner The address to query the the balance of.
530   * @return An uint256 representing the amount owned by the passed address.
531   */
532   function balanceOf(address _owner) public view returns (uint256) {
533     return balances[_owner];
534   }
535 
536 }
537 
538 
539 
540 
541 /**
542  * @title Standard ERC20 token
543  *
544  * @dev Implementation of the basic standard token.
545  * https://github.com/ethereum/EIPs/issues/20
546  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
547  */
548 contract StandardToken is ERC20, BasicToken {
549 
550   mapping (address => mapping (address => uint256)) internal allowed;
551 
552 
553   /**
554    * @dev Transfer tokens from one address to another
555    * @param _from address The address which you want to send tokens from
556    * @param _to address The address which you want to transfer to
557    * @param _value uint256 the amount of tokens to be transferred
558    */
559   function transferFrom(
560     address _from,
561     address _to,
562     uint256 _value
563   )
564     public
565     returns (bool)
566   {
567     require(_value <= balances[_from]);
568     require(_value <= allowed[_from][msg.sender]);
569     require(_to != address(0));
570 
571     balances[_from] = balances[_from].sub(_value);
572     balances[_to] = balances[_to].add(_value);
573     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
574     emit Transfer(_from, _to, _value);
575     return true;
576   }
577 
578   /**
579    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
580    * Beware that changing an allowance with this method brings the risk that someone may use both the old
581    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
582    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
583    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584    * @param _spender The address which will spend the funds.
585    * @param _value The amount of tokens to be spent.
586    */
587   function approve(address _spender, uint256 _value) public returns (bool) {
588     allowed[msg.sender][_spender] = _value;
589     emit Approval(msg.sender, _spender, _value);
590     return true;
591   }
592 
593   /**
594    * @dev Function to check the amount of tokens that an owner allowed to a spender.
595    * @param _owner address The address which owns the funds.
596    * @param _spender address The address which will spend the funds.
597    * @return A uint256 specifying the amount of tokens still available for the spender.
598    */
599   function allowance(
600     address _owner,
601     address _spender
602    )
603     public
604     view
605     returns (uint256)
606   {
607     return allowed[_owner][_spender];
608   }
609 
610   /**
611    * @dev Increase the amount of tokens that an owner allowed to a spender.
612    * approve should be called when allowed[_spender] == 0. To increment
613    * allowed value is better to use this function to avoid 2 calls (and wait until
614    * the first transaction is mined)
615    * From MonolithDAO Token.sol
616    * @param _spender The address which will spend the funds.
617    * @param _addedValue The amount of tokens to increase the allowance by.
618    */
619   function increaseApproval(
620     address _spender,
621     uint256 _addedValue
622   )
623     public
624     returns (bool)
625   {
626     allowed[msg.sender][_spender] = (
627       allowed[msg.sender][_spender].add(_addedValue));
628     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632   /**
633    * @dev Decrease the amount of tokens that an owner allowed to a spender.
634    * approve should be called when allowed[_spender] == 0. To decrement
635    * allowed value is better to use this function to avoid 2 calls (and wait until
636    * the first transaction is mined)
637    * From MonolithDAO Token.sol
638    * @param _spender The address which will spend the funds.
639    * @param _subtractedValue The amount of tokens to decrease the allowance by.
640    */
641   function decreaseApproval(
642     address _spender,
643     uint256 _subtractedValue
644   )
645     public
646     returns (bool)
647   {
648     uint256 oldValue = allowed[msg.sender][_spender];
649     if (_subtractedValue >= oldValue) {
650       allowed[msg.sender][_spender] = 0;
651     } else {
652       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
653     }
654     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
655     return true;
656   }
657 
658 }
659 
660 
661 
662 
663 /**
664  * @title Mintable token
665  * @dev Simple ERC20 Token example, with mintable token creation
666  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
667  */
668 contract MintableToken is StandardToken, Ownable {
669   event Mint(address indexed to, uint256 amount);
670   event MintFinished();
671 
672   bool public mintingFinished = false;
673 
674 
675   modifier canMint() {
676     require(!mintingFinished);
677     _;
678   }
679 
680   modifier hasMintPermission() {
681     require(msg.sender == owner);
682     _;
683   }
684 
685   /**
686    * @dev Function to mint tokens
687    * @param _to The address that will receive the minted tokens.
688    * @param _amount The amount of tokens to mint.
689    * @return A boolean that indicates if the operation was successful.
690    */
691   function mint(
692     address _to,
693     uint256 _amount
694   )
695     public
696     hasMintPermission
697     canMint
698     returns (bool)
699   {
700     totalSupply_ = totalSupply_.add(_amount);
701     balances[_to] = balances[_to].add(_amount);
702     emit Mint(_to, _amount);
703     emit Transfer(address(0), _to, _amount);
704     return true;
705   }
706 
707   /**
708    * @dev Function to stop minting new tokens.
709    * @return True if the operation was successful.
710    */
711   function finishMinting() public onlyOwner canMint returns (bool) {
712     mintingFinished = true;
713     emit MintFinished();
714     return true;
715   }
716 }
717 
718 // import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
719 
720 
721 
722 // import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
723 
724 contract ALMToken is MintableToken {
725     
726     string public constant name = "Almee Token";
727     string public constant symbol = "ALM";
728     uint8 public constant decimals = 18;
729 
730     // constructor (string _name, string _symbol, uint8 _decimals)
731     // public {
732     //     // totalSupply_ = INITIAL_SUPPLY;
733     //     // balances[msg.sender] = INITIAL_SUPPLY;
734     // }
735 }
736 
737 contract ALMCrowdsale is CappedCrowdsale, MintedCrowdsale, Ownable {
738     constructor (uint256 _rate, address _wallet, MintableToken _token, uint256 _cap)
739         public
740         Crowdsale(_rate, _wallet, _token) 
741         CappedCrowdsale(_cap)
742     {
743         
744     }
745 
746     function createTokenContract() internal returns (MintableToken) {
747         return new ALMToken();
748     }
749 }