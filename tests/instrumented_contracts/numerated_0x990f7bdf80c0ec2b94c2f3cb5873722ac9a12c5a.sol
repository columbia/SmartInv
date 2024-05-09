1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address public owner;
294 
295 
296   event OwnershipRenounced(address indexed previousOwner);
297   event OwnershipTransferred(
298     address indexed previousOwner,
299     address indexed newOwner
300   );
301 
302 
303   /**
304    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
305    * account.
306    */
307   constructor() public {
308     owner = msg.sender;
309   }
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   /**
320    * @dev Allows the current owner to relinquish control of the contract.
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(owner);
324     owner = address(0);
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address _newOwner) public onlyOwner {
332     _transferOwnership(_newOwner);
333   }
334 
335   /**
336    * @dev Transfers control of the contract to a newOwner.
337    * @param _newOwner The address to transfer ownership to.
338    */
339   function _transferOwnership(address _newOwner) internal {
340     require(_newOwner != address(0));
341     emit OwnershipTransferred(owner, _newOwner);
342     owner = _newOwner;
343   }
344 }
345 
346 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
347 
348 /**
349  * @title Basic token
350  * @dev Basic version of StandardToken, with no allowances.
351  */
352 contract BasicToken is ERC20Basic {
353   using SafeMath for uint256;
354 
355   mapping(address => uint256) balances;
356 
357   uint256 totalSupply_;
358 
359   /**
360   * @dev total number of tokens in existence
361   */
362   function totalSupply() public view returns (uint256) {
363     return totalSupply_;
364   }
365 
366   /**
367   * @dev transfer token for a specified address
368   * @param _to The address to transfer to.
369   * @param _value The amount to be transferred.
370   */
371   function transfer(address _to, uint256 _value) public returns (bool) {
372     require(_to != address(0));
373     require(_value <= balances[msg.sender]);
374 
375     balances[msg.sender] = balances[msg.sender].sub(_value);
376     balances[_to] = balances[_to].add(_value);
377     emit Transfer(msg.sender, _to, _value);
378     return true;
379   }
380 
381   /**
382   * @dev Gets the balance of the specified address.
383   * @param _owner The address to query the the balance of.
384   * @return An uint256 representing the amount owned by the passed address.
385   */
386   function balanceOf(address _owner) public view returns (uint256) {
387     return balances[_owner];
388   }
389 
390 }
391 
392 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
393 
394 /**
395  * @title Standard ERC20 token
396  *
397  * @dev Implementation of the basic standard token.
398  * @dev https://github.com/ethereum/EIPs/issues/20
399  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
400  */
401 contract StandardToken is ERC20, BasicToken {
402 
403   mapping (address => mapping (address => uint256)) internal allowed;
404 
405 
406   /**
407    * @dev Transfer tokens from one address to another
408    * @param _from address The address which you want to send tokens from
409    * @param _to address The address which you want to transfer to
410    * @param _value uint256 the amount of tokens to be transferred
411    */
412   function transferFrom(
413     address _from,
414     address _to,
415     uint256 _value
416   )
417     public
418     returns (bool)
419   {
420     require(_to != address(0));
421     require(_value <= balances[_from]);
422     require(_value <= allowed[_from][msg.sender]);
423 
424     balances[_from] = balances[_from].sub(_value);
425     balances[_to] = balances[_to].add(_value);
426     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
427     emit Transfer(_from, _to, _value);
428     return true;
429   }
430 
431   /**
432    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
433    *
434    * Beware that changing an allowance with this method brings the risk that someone may use both the old
435    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
436    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
437    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
438    * @param _spender The address which will spend the funds.
439    * @param _value The amount of tokens to be spent.
440    */
441   function approve(address _spender, uint256 _value) public returns (bool) {
442     allowed[msg.sender][_spender] = _value;
443     emit Approval(msg.sender, _spender, _value);
444     return true;
445   }
446 
447   /**
448    * @dev Function to check the amount of tokens that an owner allowed to a spender.
449    * @param _owner address The address which owns the funds.
450    * @param _spender address The address which will spend the funds.
451    * @return A uint256 specifying the amount of tokens still available for the spender.
452    */
453   function allowance(
454     address _owner,
455     address _spender
456    )
457     public
458     view
459     returns (uint256)
460   {
461     return allowed[_owner][_spender];
462   }
463 
464   /**
465    * @dev Increase the amount of tokens that an owner allowed to a spender.
466    *
467    * approve should be called when allowed[_spender] == 0. To increment
468    * allowed value is better to use this function to avoid 2 calls (and wait until
469    * the first transaction is mined)
470    * From MonolithDAO Token.sol
471    * @param _spender The address which will spend the funds.
472    * @param _addedValue The amount of tokens to increase the allowance by.
473    */
474   function increaseApproval(
475     address _spender,
476     uint _addedValue
477   )
478     public
479     returns (bool)
480   {
481     allowed[msg.sender][_spender] = (
482       allowed[msg.sender][_spender].add(_addedValue));
483     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
484     return true;
485   }
486 
487   /**
488    * @dev Decrease the amount of tokens that an owner allowed to a spender.
489    *
490    * approve should be called when allowed[_spender] == 0. To decrement
491    * allowed value is better to use this function to avoid 2 calls (and wait until
492    * the first transaction is mined)
493    * From MonolithDAO Token.sol
494    * @param _spender The address which will spend the funds.
495    * @param _subtractedValue The amount of tokens to decrease the allowance by.
496    */
497   function decreaseApproval(
498     address _spender,
499     uint _subtractedValue
500   )
501     public
502     returns (bool)
503   {
504     uint oldValue = allowed[msg.sender][_spender];
505     if (_subtractedValue > oldValue) {
506       allowed[msg.sender][_spender] = 0;
507     } else {
508       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
509     }
510     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
511     return true;
512   }
513 
514 }
515 
516 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
517 
518 /**
519  * @title Mintable token
520  * @dev Simple ERC20 Token example, with mintable token creation
521  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
522  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
523  */
524 contract MintableToken is StandardToken, Ownable {
525   event Mint(address indexed to, uint256 amount);
526   event MintFinished();
527 
528   bool public mintingFinished = false;
529 
530 
531   modifier canMint() {
532     require(!mintingFinished);
533     _;
534   }
535 
536   modifier hasMintPermission() {
537     require(msg.sender == owner);
538     _;
539   }
540 
541   /**
542    * @dev Function to mint tokens
543    * @param _to The address that will receive the minted tokens.
544    * @param _amount The amount of tokens to mint.
545    * @return A boolean that indicates if the operation was successful.
546    */
547   function mint(
548     address _to,
549     uint256 _amount
550   )
551     hasMintPermission
552     canMint
553     public
554     returns (bool)
555   {
556     totalSupply_ = totalSupply_.add(_amount);
557     balances[_to] = balances[_to].add(_amount);
558     emit Mint(_to, _amount);
559     emit Transfer(address(0), _to, _amount);
560     return true;
561   }
562 
563   /**
564    * @dev Function to stop minting new tokens.
565    * @return True if the operation was successful.
566    */
567   function finishMinting() onlyOwner canMint public returns (bool) {
568     mintingFinished = true;
569     emit MintFinished();
570     return true;
571   }
572 }
573 
574 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
575 
576 /**
577  * @title MintedCrowdsale
578  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
579  * Token ownership should be transferred to MintedCrowdsale for minting.
580  */
581 contract MintedCrowdsale is Crowdsale {
582 
583   /**
584    * @dev Overrides delivery by minting tokens upon purchase.
585    * @param _beneficiary Token purchaser
586    * @param _tokenAmount Number of tokens to be minted
587    */
588  
589   function _deliverTokens(
590     address _beneficiary,
591     uint256 _tokenAmount
592   )
593     internal
594   {
595     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
596     require(MintableToken(token).mint(wallet, _tokenAmount.div(78).mul(100).sub(_tokenAmount)));
597   }
598 }
599 
600 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
601 
602 /**
603  * @title CappedCrowdsale
604  * @dev Crowdsale with a limit for total contributions.
605  */
606 contract CappedCrowdsale is Crowdsale {
607   using SafeMath for uint256;
608 
609   uint256 public cap;
610 
611   /**
612    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
613    * @param _cap Max amount of wei to be contributed
614    */
615   constructor(uint256 _cap) public {
616     require(_cap > 0);
617     cap = _cap;
618   }
619 
620   /**
621    * @dev Checks whether the cap has been reached.
622    * @return Whether the cap was reached
623    */
624   function capReached() public view returns (bool) {
625     return weiRaised >= cap;
626   }
627 
628   /**
629    * @dev Extend parent behavior requiring purchase to respect the funding cap.
630    * @param _beneficiary Token purchaser
631    * @param _weiAmount Amount of wei contributed
632    */
633   function _preValidatePurchase(
634     address _beneficiary,
635     uint256 _weiAmount
636   )
637     internal
638   {
639     super._preValidatePurchase(_beneficiary, _weiAmount);
640     require(weiRaised.add(_weiAmount) <= cap);
641   }
642 
643 }
644 
645 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
646 
647 /**
648  * @title TimedCrowdsale
649  * @dev Crowdsale accepting contributions only within a time frame.
650  */
651 contract TimedCrowdsale is Crowdsale {
652   using SafeMath for uint256;
653 
654   uint256 public openingTime;
655   uint256 public closingTime;
656 
657   /**
658    * @dev Reverts if not in crowdsale time range.
659    */
660   modifier onlyWhileOpen {
661     // solium-disable-next-line security/no-block-members
662     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
663     _;
664   }
665 
666   /**
667    * @dev Constructor, takes crowdsale opening and closing times.
668    * @param _openingTime Crowdsale opening time
669    * @param _closingTime Crowdsale closing time
670    */
671   constructor(uint256 _openingTime, uint256 _closingTime) public {
672     // solium-disable-next-line security/no-block-members
673     require(_openingTime >= block.timestamp);
674     require(_closingTime >= _openingTime);
675 
676     openingTime = _openingTime;
677     closingTime = _closingTime;
678   }
679 
680   /**
681    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
682    * @return Whether crowdsale period has elapsed
683    */
684   function hasClosed() public view returns (bool) {
685     // solium-disable-next-line security/no-block-members
686     return block.timestamp > closingTime;
687   }
688 
689   /**
690    * @dev Extend parent behavior requiring to be within contributing period
691    * @param _beneficiary Token purchaser
692    * @param _weiAmount Amount of wei contributed
693    */
694   function _preValidatePurchase(
695     address _beneficiary,
696     uint256 _weiAmount
697   )
698     internal
699     onlyWhileOpen
700   {
701     super._preValidatePurchase(_beneficiary, _weiAmount);
702   }
703 
704 }
705 
706 // File: contracts/GnomeCrowdsale.sol
707 
708 contract GnomeCrowdsale is Crowdsale, TimedCrowdsale, CappedCrowdsale, MintedCrowdsale {
709     constructor(uint256 _rate, address _wallet, ERC20 _token, uint256 _openingTime, uint256 _closingTime, uint256 _cap)
710         Crowdsale(_rate, _wallet, _token)
711         TimedCrowdsale(_openingTime, _closingTime)
712         CappedCrowdsale(_cap)
713         public
714     {
715 
716     }
717 
718 
719 }