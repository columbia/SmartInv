1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Crowdsale
7  * @dev Crowdsale is a base contract for managing a token crowdsale,
8  * allowing investors to purchase tokens with ether. This contract implements
9  * such functionality in its most fundamental form and can be extended to provide additional
10  * functionality and/or custom behavior.
11  * The external interface represents the basic interface for purchasing tokens, and conform
12  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
13  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
14  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
15  * behavior.
16  */
17 contract Crowdsale {
18   using SafeMath for uint256;
19   using SafeERC20 for ERC20;
20 
21   // The token being sold
22   ERC20 public token;
23 
24   // Address where funds are collected
25   address public wallet;
26 
27   // How many token units a buyer gets per wei.
28   // The rate is the conversion between wei and the smallest and indivisible token unit.
29   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
30   // 1 wei will give you 1 unit, or 0.001 TOK.
31   uint256 public rate;
32 
33   // Amount of wei raised
34   uint256 public weiRaised;
35 
36   /**
37    * Event for token purchase logging
38    * @param purchaser who paid for the tokens
39    * @param beneficiary who got the tokens
40    * @param value weis paid for purchase
41    * @param amount amount of tokens purchased
42    */
43   event TokenPurchase(
44     address indexed purchaser,
45     address indexed beneficiary,
46     uint256 value,
47     uint256 amount
48   );
49 
50   /**
51    * @param _rate Number of token units a buyer gets per wei
52    * @param _wallet Address where collected funds will be forwarded to
53    * @param _token Address of the token being sold
54    */
55   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
56     require(_rate > 0);
57     require(_wallet != address(0));
58     require(_token != address(0));
59 
60     rate = _rate;
61     wallet = _wallet;
62     token = _token;
63   }
64 
65   // -----------------------------------------
66   // Crowdsale external interface
67   // -----------------------------------------
68 
69   /**
70    * @dev fallback function ***DO NOT OVERRIDE***
71    */
72   function () external payable {
73     buyTokens(msg.sender);
74   }
75 
76   /**
77    * @dev low level token purchase ***DO NOT OVERRIDE***
78    * @param _beneficiary Address performing the token purchase
79    */
80   function buyTokens(address _beneficiary) public payable {
81 
82     uint256 weiAmount = msg.value;
83     _preValidatePurchase(_beneficiary, weiAmount);
84 
85     // calculate token amount to be created
86     uint256 tokens = _getTokenAmount(weiAmount);
87 
88     // update state
89     weiRaised = weiRaised.add(weiAmount);
90 
91     _processPurchase(_beneficiary, tokens);
92     emit TokenPurchase(
93       msg.sender,
94       _beneficiary,
95       weiAmount,
96       tokens
97     );
98 
99     _updatePurchasingState(_beneficiary, weiAmount);
100 
101     _forwardFunds();
102     _postValidatePurchase(_beneficiary, weiAmount);
103   }
104 
105   // -----------------------------------------
106   // Internal interface (extensible)
107   // -----------------------------------------
108 
109   /**
110    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
111    * @param _beneficiary Address performing the token purchase
112    * @param _weiAmount Value in wei involved in the purchase
113    */
114   function _preValidatePurchase(
115     address _beneficiary,
116     uint256 _weiAmount
117   )
118     internal
119   {
120     require(_beneficiary != address(0));
121     require(_weiAmount != 0);
122   }
123 
124   /**
125    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
126    * @param _beneficiary Address performing the token purchase
127    * @param _weiAmount Value in wei involved in the purchase
128    */
129   function _postValidatePurchase(
130     address _beneficiary,
131     uint256 _weiAmount
132   )
133     internal
134   {
135     // optional override
136   }
137 
138   /**
139    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
140    * @param _beneficiary Address performing the token purchase
141    * @param _tokenAmount Number of tokens to be emitted
142    */
143   function _deliverTokens(
144     address _beneficiary,
145     uint256 _tokenAmount
146   )
147     internal
148   {
149     token.safeTransfer(_beneficiary, _tokenAmount);
150   }
151 
152   /**
153    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
154    * @param _beneficiary Address receiving the tokens
155    * @param _tokenAmount Number of tokens to be purchased
156    */
157   function _processPurchase(
158     address _beneficiary,
159     uint256 _tokenAmount
160   )
161     internal
162   {
163     _deliverTokens(_beneficiary, _tokenAmount);
164   }
165 
166   /**
167    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
168    * @param _beneficiary Address receiving the tokens
169    * @param _weiAmount Value in wei involved in the purchase
170    */
171   function _updatePurchasingState(
172     address _beneficiary,
173     uint256 _weiAmount
174   )
175     internal
176   {
177     // optional override
178   }
179 
180   /**
181    * @dev Override to extend the way in which ether is converted to tokens.
182    * @param _weiAmount Value in wei to be converted into tokens
183    * @return Number of tokens that can be purchased with the specified _weiAmount
184    */
185   function _getTokenAmount(uint256 _weiAmount)
186     internal view returns (uint256)
187   {
188     return _weiAmount.mul(rate);
189   }
190 
191   /**
192    * @dev Determines how ETH is stored/forwarded on purchases.
193    */
194   function _forwardFunds() internal {
195     wallet.transfer(msg.value);
196   }
197 }
198 
199 
200 
201 /**
202  * @title AllowanceCrowdsale
203  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
204  */
205 contract AllowanceCrowdsale is Crowdsale {
206   using SafeMath for uint256;
207   using SafeERC20 for ERC20;
208 
209   address public tokenWallet;
210 
211   /**
212    * @dev Constructor, takes token wallet address.
213    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
214    */
215   constructor(address _tokenWallet) public {
216     require(_tokenWallet != address(0));
217     tokenWallet = _tokenWallet;
218   }
219 
220   /**
221    * @dev Checks the amount of tokens left in the allowance.
222    * @return Amount of tokens left in the allowance
223    */
224   function remainingTokens() public view returns (uint256) {
225     return token.allowance(tokenWallet, this);
226   }
227 
228   /**
229    * @dev Overrides parent behavior by transferring tokens from wallet.
230    * @param _beneficiary Token purchaser
231    * @param _tokenAmount Amount of tokens purchased
232    */
233   function _deliverTokens(
234     address _beneficiary,
235     uint256 _tokenAmount
236   )
237     internal
238   {
239     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
240   }
241 }
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249   address public owner;
250 
251 
252   event OwnershipRenounced(address indexed previousOwner);
253   event OwnershipTransferred(
254     address indexed previousOwner,
255     address indexed newOwner
256   );
257 
258 
259   /**
260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
261    * account.
262    */
263   constructor() public {
264     owner = msg.sender;
265   }
266 
267   /**
268    * @dev Throws if called by any account other than the owner.
269    */
270   modifier onlyOwner() {
271     require(msg.sender == owner);
272     _;
273   }
274 
275   /**
276    * @dev Allows the current owner to relinquish control of the contract.
277    * @notice Renouncing to ownership will leave the contract without an owner.
278    * It will not be possible to call the functions with the `onlyOwner`
279    * modifier anymore.
280    */
281   function renounceOwnership() public onlyOwner {
282     emit OwnershipRenounced(owner);
283     owner = address(0);
284   }
285 
286   /**
287    * @dev Allows the current owner to transfer control of the contract to a newOwner.
288    * @param _newOwner The address to transfer ownership to.
289    */
290   function transferOwnership(address _newOwner) public onlyOwner {
291     _transferOwnership(_newOwner);
292   }
293 
294   /**
295    * @dev Transfers control of the contract to a newOwner.
296    * @param _newOwner The address to transfer ownership to.
297    */
298   function _transferOwnership(address _newOwner) internal {
299     require(_newOwner != address(0));
300     emit OwnershipTransferred(owner, _newOwner);
301     owner = _newOwner;
302   }
303 }
304 
305 
306 /**
307  * @title SafeMath
308  * @dev Math operations with safety checks that throw on error
309  */
310 library SafeMath {
311 
312   /**
313   * @dev Multiplies two numbers, throws on overflow.
314   */
315   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
316     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
317     // benefit is lost if 'b' is also tested.
318     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
319     if (a == 0) {
320       return 0;
321     }
322 
323     c = a * b;
324     assert(c / a == b);
325     return c;
326   }
327 
328   /**
329   * @dev Integer division of two numbers, truncating the quotient.
330   */
331   function div(uint256 a, uint256 b) internal pure returns (uint256) {
332     // assert(b > 0); // Solidity automatically throws when dividing by 0
333     // uint256 c = a / b;
334     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
335     return a / b;
336   }
337 
338   /**
339   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
340   */
341   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342     assert(b <= a);
343     return a - b;
344   }
345 
346   /**
347   * @dev Adds two numbers, throws on overflow.
348   */
349   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
350     c = a + b;
351     assert(c >= a);
352     return c;
353   }
354 }
355 
356 
357 
358 /**
359  * @title ERC20Basic
360  * @dev Simpler version of ERC20 interface
361  * @dev see https://github.com/ethereum/EIPs/issues/179
362  */
363 contract ERC20Basic {
364   function totalSupply() public view returns (uint256);
365   function balanceOf(address who) public view returns (uint256);
366   function transfer(address to, uint256 value) public returns (bool);
367   event Transfer(address indexed from, address indexed to, uint256 value);
368 }
369 
370 
371 /**
372  * @title ERC20 interface
373  * @dev see https://github.com/ethereum/EIPs/issues/20
374  */
375 contract ERC20 is ERC20Basic {
376   function allowance(address owner, address spender)
377     public view returns (uint256);
378 
379   function transferFrom(address from, address to, uint256 value)
380     public returns (bool);
381 
382   function approve(address spender, uint256 value) public returns (bool);
383   event Approval(
384     address indexed owner,
385     address indexed spender,
386     uint256 value
387   );
388 }
389 
390 
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure.
395  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
396  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
397  */
398 library SafeERC20 {
399   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
400     require(token.transfer(to, value));
401   }
402 
403   function safeTransferFrom(
404     ERC20 token,
405     address from,
406     address to,
407     uint256 value
408   )
409     internal
410   {
411     require(token.transferFrom(from, to, value));
412   }
413 
414   function safeApprove(ERC20 token, address spender, uint256 value) internal {
415     require(token.approve(spender, value));
416   }
417 }
418 
419 
420 
421 /**
422  * @title TimedCrowdsale
423  * @dev Crowdsale accepting contributions only within a time frame.
424  */
425 contract TimedCrowdsale is Crowdsale {
426   using SafeMath for uint256;
427 
428   uint256 public openingTime;
429   uint256 public closingTime;
430 
431   /**
432    * @dev Reverts if not in crowdsale time range.
433    */
434   modifier onlyWhileOpen {
435     // solium-disable-next-line security/no-block-members
436     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
437     _;
438   }
439 
440   /**
441    * @dev Constructor, takes crowdsale opening and closing times.
442    * @param _openingTime Crowdsale opening time
443    * @param _closingTime Crowdsale closing time
444    */
445   constructor(uint256 _openingTime, uint256 _closingTime) public {
446     // solium-disable-next-line security/no-block-members
447     require(_openingTime >= block.timestamp);
448     require(_closingTime >= _openingTime);
449 
450     openingTime = _openingTime;
451     closingTime = _closingTime;
452   }
453 
454   /**
455    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
456    * @return Whether crowdsale period has elapsed
457    */
458   function hasClosed() public view returns (bool) {
459     // solium-disable-next-line security/no-block-members
460     return block.timestamp > closingTime;
461   }
462 
463   /**
464    * @dev Extend parent behavior requiring to be within contributing period
465    * @param _beneficiary Token purchaser
466    * @param _weiAmount Amount of wei contributed
467    */
468   function _preValidatePurchase(
469     address _beneficiary,
470     uint256 _weiAmount
471   )
472     internal
473     onlyWhileOpen
474   {
475     super._preValidatePurchase(_beneficiary, _weiAmount);
476   }
477 
478 }
479 
480 
481 
482 /**
483  * @title FinalizableCrowdsale
484  * @dev Extension of Crowdsale where an owner can do extra work
485  * after finishing.
486  */
487 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
488   using SafeMath for uint256;
489 
490   bool public isFinalized = false;
491 
492   event Finalized();
493 
494   /**
495    * @dev Must be called after crowdsale ends, to do some extra finalization
496    * work. Calls the contract's finalization function.
497    */
498   function finalize() onlyOwner public {
499     require(!isFinalized);
500     require(hasClosed());
501 
502     finalization();
503     emit Finalized();
504 
505     isFinalized = true;
506   }
507 
508   /**
509    * @dev Can be overridden to add finalization logic. The overriding function
510    * should call super.finalization() to ensure the chain of finalization is
511    * executed entirely.
512    */
513   function finalization() internal {
514   }
515 
516 }
517 
518 
519 
520 
521 
522 
523 
524 // Flattened VolAirCoin contract for etherscan validation
525 // This file should not be modified
526 
527 
528 
529 /**
530  * @title Basic token
531  * @dev Basic version of StandardToken, with no allowances.
532  */
533 contract BasicToken is ERC20Basic {
534   using SafeMath for uint256;
535 
536   mapping(address => uint256) balances;
537 
538   uint256 totalSupply_;
539 
540   /**
541   * @dev total number of tokens in existence
542   */
543   function totalSupply() public view returns (uint256) {
544     return totalSupply_;
545   }
546 
547   /**
548   * @dev transfer token for a specified address
549   * @param _to The address to transfer to.
550   * @param _value The amount to be transferred.
551   */
552   function transfer(address _to, uint256 _value) public returns (bool) {
553     require(_to != address(0));
554     require(_value <= balances[msg.sender]);
555 
556     balances[msg.sender] = balances[msg.sender].sub(_value);
557     balances[_to] = balances[_to].add(_value);
558     emit Transfer(msg.sender, _to, _value);
559     return true;
560   }
561 
562   /**
563   * @dev Gets the balance of the specified address.
564   * @param _owner The address to query the the balance of.
565   * @return An uint256 representing the amount owned by the passed address.
566   */
567   function balanceOf(address _owner) public view returns (uint256) {
568     return balances[_owner];
569   }
570 
571 }
572 
573 
574 /**
575  * @title Standard ERC20 token
576  *
577  * @dev Implementation of the basic standard token.
578  * @dev https://github.com/ethereum/EIPs/issues/20
579  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
580  */
581 contract StandardToken is ERC20, BasicToken {
582 
583   mapping (address => mapping (address => uint256)) internal allowed;
584 
585 
586   /**
587    * @dev Transfer tokens from one address to another
588    * @param _from address The address which you want to send tokens from
589    * @param _to address The address which you want to transfer to
590    * @param _value uint256 the amount of tokens to be transferred
591    */
592   function transferFrom(
593     address _from,
594     address _to,
595     uint256 _value
596   )
597     public
598     returns (bool)
599   {
600     require(_to != address(0));
601     require(_value <= balances[_from]);
602     require(_value <= allowed[_from][msg.sender]);
603 
604     balances[_from] = balances[_from].sub(_value);
605     balances[_to] = balances[_to].add(_value);
606     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
607     emit Transfer(_from, _to, _value);
608     return true;
609   }
610 
611   /**
612    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
613    *
614    * Beware that changing an allowance with this method brings the risk that someone may use both the old
615    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
616    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
617    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
618    * @param _spender The address which will spend the funds.
619    * @param _value The amount of tokens to be spent.
620    */
621   function approve(address _spender, uint256 _value) public returns (bool) {
622     allowed[msg.sender][_spender] = _value;
623     emit Approval(msg.sender, _spender, _value);
624     return true;
625   }
626 
627   /**
628    * @dev Function to check the amount of tokens that an owner allowed to a spender.
629    * @param _owner address The address which owns the funds.
630    * @param _spender address The address which will spend the funds.
631    * @return A uint256 specifying the amount of tokens still available for the spender.
632    */
633   function allowance(
634     address _owner,
635     address _spender
636    )
637     public
638     view
639     returns (uint256)
640   {
641     return allowed[_owner][_spender];
642   }
643 
644   /**
645    * @dev Increase the amount of tokens that an owner allowed to a spender.
646    *
647    * approve should be called when allowed[_spender] == 0. To increment
648    * allowed value is better to use this function to avoid 2 calls (and wait until
649    * the first transaction is mined)
650    * From MonolithDAO Token.sol
651    * @param _spender The address which will spend the funds.
652    * @param _addedValue The amount of tokens to increase the allowance by.
653    */
654   function increaseApproval(
655     address _spender,
656     uint _addedValue
657   )
658     public
659     returns (bool)
660   {
661     allowed[msg.sender][_spender] = (
662       allowed[msg.sender][_spender].add(_addedValue));
663     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
664     return true;
665   }
666 
667   /**
668    * @dev Decrease the amount of tokens that an owner allowed to a spender.
669    *
670    * approve should be called when allowed[_spender] == 0. To decrement
671    * allowed value is better to use this function to avoid 2 calls (and wait until
672    * the first transaction is mined)
673    * From MonolithDAO Token.sol
674    * @param _spender The address which will spend the funds.
675    * @param _subtractedValue The amount of tokens to decrease the allowance by.
676    */
677   function decreaseApproval(
678     address _spender,
679     uint _subtractedValue
680   )
681     public
682     returns (bool)
683   {
684     uint oldValue = allowed[msg.sender][_spender];
685     if (_subtractedValue > oldValue) {
686       allowed[msg.sender][_spender] = 0;
687     } else {
688       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
689     }
690     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
691     return true;
692   }
693 
694 }
695 
696 
697 contract VolAirCoin is StandardToken {
698     string public name = "VolAir Coin"; 
699     string public symbol = "VOL";
700     uint public decimals = 18;
701     uint public INITIAL_SUPPLY = 500000000 * (10 ** decimals);
702 
703     constructor() public {
704         totalSupply_ = INITIAL_SUPPLY;
705         balances[msg.sender] = INITIAL_SUPPLY;
706         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
707     }
708 }
709 
710 contract VolAirCoinCrowdsale is AllowanceCrowdsale, TimedCrowdsale {    
711     constructor (uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, VolAirCoin _token, address _tokenWallet) public 
712         Crowdsale(_rate, _wallet, _token)
713         AllowanceCrowdsale(_tokenWallet)
714         TimedCrowdsale(_openingTime, _closingTime)
715     {
716     }
717 }