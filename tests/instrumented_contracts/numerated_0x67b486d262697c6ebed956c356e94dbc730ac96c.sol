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
285 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
286 
287 /**
288  * @title TimedCrowdsale
289  * @dev Crowdsale accepting contributions only within a time frame.
290  */
291 contract TimedCrowdsale is Crowdsale {
292   using SafeMath for uint256;
293 
294   uint256 public openingTime;
295   uint256 public closingTime;
296 
297   /**
298    * @dev Reverts if not in crowdsale time range.
299    */
300   modifier onlyWhileOpen {
301     // solium-disable-next-line security/no-block-members
302     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
303     _;
304   }
305 
306   /**
307    * @dev Constructor, takes crowdsale opening and closing times.
308    * @param _openingTime Crowdsale opening time
309    * @param _closingTime Crowdsale closing time
310    */
311   constructor(uint256 _openingTime, uint256 _closingTime) public {
312     // solium-disable-next-line security/no-block-members
313     require(_openingTime >= block.timestamp);
314     require(_closingTime >= _openingTime);
315 
316     openingTime = _openingTime;
317     closingTime = _closingTime;
318   }
319 
320   /**
321    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
322    * @return Whether crowdsale period has elapsed
323    */
324   function hasClosed() public view returns (bool) {
325     // solium-disable-next-line security/no-block-members
326     return block.timestamp > closingTime;
327   }
328 
329   /**
330    * @dev Extend parent behavior requiring to be within contributing period
331    * @param _beneficiary Token purchaser
332    * @param _weiAmount Amount of wei contributed
333    */
334   function _preValidatePurchase(
335     address _beneficiary,
336     uint256 _weiAmount
337   )
338     internal
339     onlyWhileOpen
340   {
341     super._preValidatePurchase(_beneficiary, _weiAmount);
342   }
343 
344 }
345 
346 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
347 
348 /**
349  * @title Ownable
350  * @dev The Ownable contract has an owner address, and provides basic authorization control
351  * functions, this simplifies the implementation of "user permissions".
352  */
353 contract Ownable {
354   address public owner;
355 
356 
357   event OwnershipRenounced(address indexed previousOwner);
358   event OwnershipTransferred(
359     address indexed previousOwner,
360     address indexed newOwner
361   );
362 
363 
364   /**
365    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
366    * account.
367    */
368   constructor() public {
369     owner = msg.sender;
370   }
371 
372   /**
373    * @dev Throws if called by any account other than the owner.
374    */
375   modifier onlyOwner() {
376     require(msg.sender == owner);
377     _;
378   }
379 
380   /**
381    * @dev Allows the current owner to relinquish control of the contract.
382    */
383   function renounceOwnership() public onlyOwner {
384     emit OwnershipRenounced(owner);
385     owner = address(0);
386   }
387 
388   /**
389    * @dev Allows the current owner to transfer control of the contract to a newOwner.
390    * @param _newOwner The address to transfer ownership to.
391    */
392   function transferOwnership(address _newOwner) public onlyOwner {
393     _transferOwnership(_newOwner);
394   }
395 
396   /**
397    * @dev Transfers control of the contract to a newOwner.
398    * @param _newOwner The address to transfer ownership to.
399    */
400   function _transferOwnership(address _newOwner) internal {
401     require(_newOwner != address(0));
402     emit OwnershipTransferred(owner, _newOwner);
403     owner = _newOwner;
404   }
405 }
406 
407 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
408 
409 /**
410  * @title Basic token
411  * @dev Basic version of StandardToken, with no allowances.
412  */
413 contract BasicToken is ERC20Basic {
414   using SafeMath for uint256;
415 
416   mapping(address => uint256) balances;
417 
418   uint256 totalSupply_;
419 
420   /**
421   * @dev total number of tokens in existence
422   */
423   function totalSupply() public view returns (uint256) {
424     return totalSupply_;
425   }
426 
427   /**
428   * @dev transfer token for a specified address
429   * @param _to The address to transfer to.
430   * @param _value The amount to be transferred.
431   */
432   function transfer(address _to, uint256 _value) public returns (bool) {
433     require(_to != address(0));
434     require(_value <= balances[msg.sender]);
435 
436     balances[msg.sender] = balances[msg.sender].sub(_value);
437     balances[_to] = balances[_to].add(_value);
438     emit Transfer(msg.sender, _to, _value);
439     return true;
440   }
441 
442   /**
443   * @dev Gets the balance of the specified address.
444   * @param _owner The address to query the the balance of.
445   * @return An uint256 representing the amount owned by the passed address.
446   */
447   function balanceOf(address _owner) public view returns (uint256) {
448     return balances[_owner];
449   }
450 
451 }
452 
453 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
454 
455 /**
456  * @title Burnable Token
457  * @dev Token that can be irreversibly burned (destroyed).
458  */
459 contract BurnableToken is BasicToken {
460 
461   event Burn(address indexed burner, uint256 value);
462 
463   /**
464    * @dev Burns a specific amount of tokens.
465    * @param _value The amount of token to be burned.
466    */
467   function burn(uint256 _value) public {
468     _burn(msg.sender, _value);
469   }
470 
471   function _burn(address _who, uint256 _value) internal {
472     require(_value <= balances[_who]);
473     // no need to require value <= totalSupply, since that would imply the
474     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
475 
476     balances[_who] = balances[_who].sub(_value);
477     totalSupply_ = totalSupply_.sub(_value);
478     emit Burn(_who, _value);
479     emit Transfer(_who, address(0), _value);
480   }
481 }
482 
483 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
484 
485 /**
486  * @title Standard ERC20 token
487  *
488  * @dev Implementation of the basic standard token.
489  * @dev https://github.com/ethereum/EIPs/issues/20
490  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
491  */
492 contract StandardToken is ERC20, BasicToken {
493 
494   mapping (address => mapping (address => uint256)) internal allowed;
495 
496 
497   /**
498    * @dev Transfer tokens from one address to another
499    * @param _from address The address which you want to send tokens from
500    * @param _to address The address which you want to transfer to
501    * @param _value uint256 the amount of tokens to be transferred
502    */
503   function transferFrom(
504     address _from,
505     address _to,
506     uint256 _value
507   )
508     public
509     returns (bool)
510   {
511     require(_to != address(0));
512     require(_value <= balances[_from]);
513     require(_value <= allowed[_from][msg.sender]);
514 
515     balances[_from] = balances[_from].sub(_value);
516     balances[_to] = balances[_to].add(_value);
517     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
518     emit Transfer(_from, _to, _value);
519     return true;
520   }
521 
522   /**
523    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
524    *
525    * Beware that changing an allowance with this method brings the risk that someone may use both the old
526    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
527    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
528    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
529    * @param _spender The address which will spend the funds.
530    * @param _value The amount of tokens to be spent.
531    */
532   function approve(address _spender, uint256 _value) public returns (bool) {
533     allowed[msg.sender][_spender] = _value;
534     emit Approval(msg.sender, _spender, _value);
535     return true;
536   }
537 
538   /**
539    * @dev Function to check the amount of tokens that an owner allowed to a spender.
540    * @param _owner address The address which owns the funds.
541    * @param _spender address The address which will spend the funds.
542    * @return A uint256 specifying the amount of tokens still available for the spender.
543    */
544   function allowance(
545     address _owner,
546     address _spender
547    )
548     public
549     view
550     returns (uint256)
551   {
552     return allowed[_owner][_spender];
553   }
554 
555   /**
556    * @dev Increase the amount of tokens that an owner allowed to a spender.
557    *
558    * approve should be called when allowed[_spender] == 0. To increment
559    * allowed value is better to use this function to avoid 2 calls (and wait until
560    * the first transaction is mined)
561    * From MonolithDAO Token.sol
562    * @param _spender The address which will spend the funds.
563    * @param _addedValue The amount of tokens to increase the allowance by.
564    */
565   function increaseApproval(
566     address _spender,
567     uint _addedValue
568   )
569     public
570     returns (bool)
571   {
572     allowed[msg.sender][_spender] = (
573       allowed[msg.sender][_spender].add(_addedValue));
574     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
575     return true;
576   }
577 
578   /**
579    * @dev Decrease the amount of tokens that an owner allowed to a spender.
580    *
581    * approve should be called when allowed[_spender] == 0. To decrement
582    * allowed value is better to use this function to avoid 2 calls (and wait until
583    * the first transaction is mined)
584    * From MonolithDAO Token.sol
585    * @param _spender The address which will spend the funds.
586    * @param _subtractedValue The amount of tokens to decrease the allowance by.
587    */
588   function decreaseApproval(
589     address _spender,
590     uint _subtractedValue
591   )
592     public
593     returns (bool)
594   {
595     uint oldValue = allowed[msg.sender][_spender];
596     if (_subtractedValue > oldValue) {
597       allowed[msg.sender][_spender] = 0;
598     } else {
599       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
600     }
601     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
602     return true;
603   }
604 
605 }
606 
607 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
608 
609 /**
610  * @title Standard Burnable Token
611  * @dev Adds burnFrom method to ERC20 implementations
612  */
613 contract StandardBurnableToken is BurnableToken, StandardToken {
614 
615   /**
616    * @dev Burns a specific amount of tokens from the target address and decrements allowance
617    * @param _from address The address which you want to send tokens from
618    * @param _value uint256 The amount of token to be burned
619    */
620   function burnFrom(address _from, uint256 _value) public {
621     require(_value <= allowed[_from][msg.sender]);
622     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
623     // this function needs to emit an event with the updated approval.
624     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
625     _burn(_from, _value);
626   }
627 }
628 
629 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
630 
631 /**
632  * @title DetailedERC20 token
633  * @dev The decimals are only for visualization purposes.
634  * All the operations are done using the smallest and indivisible token unit,
635  * just as on Ethereum all the operations are done in wei.
636  */
637 contract DetailedERC20 is ERC20 {
638   string public name;
639   string public symbol;
640   uint8 public decimals;
641 
642   constructor(string _name, string _symbol, uint8 _decimals) public {
643     name = _name;
644     symbol = _symbol;
645     decimals = _decimals;
646   }
647 }
648 
649 // File: contracts/SudanGoldCoinToken.sol
650 
651 contract SudanGoldCoinToken is StandardBurnableToken, DetailedERC20, Ownable {
652   uint8 public constant decimals = 18;
653 
654   uint256 public TOKENS_NOT_FOR_SALE = 7700000 * (10 ** uint256(decimals));
655   uint256 public MAX_SUPPLY = 25000000 * (10 ** uint256(decimals));
656   uint256 public usedTokens = 0;
657 
658   constructor() public DetailedERC20('Sudan Gold Coin', 'SGC', decimals) {
659     totalSupply_ = MAX_SUPPLY;
660     sendTokens(msg.sender, TOKENS_NOT_FOR_SALE);
661   }
662 
663   function sendTokens(address addr, uint256 tokens) public onlyOwner returns (bool) {
664     require(addr != address(0));
665     require(tokens > 0);
666 
667     usedTokens = usedTokens.add(tokens);
668     require(usedTokens <= MAX_SUPPLY);
669 
670     balances[addr] = balances[addr].add(tokens);
671     emit Transfer(address(0), addr, tokens);
672 
673     return true;
674   }
675 }
676 
677 // File: contracts/SudanGoldCoinCrowdsale.sol
678 
679 contract SudanGoldCoinCrowdsale is TimedCrowdsale, Ownable {
680   SudanGoldCoinToken public sgcToken;
681 
682   constructor(uint256 _rate, address _wallet, SudanGoldCoinToken _token, uint256 _openingTime, uint256 _closingTime)
683     public Crowdsale(_rate, _wallet, _token) TimedCrowdsale(_openingTime, _closingTime) {
684       sgcToken = _token;
685   }
686 
687   function sendTokens(address addr, uint256 tokens) public onlyWhileOpen onlyOwner {
688     _deliverTokens(addr, tokens);
689   }
690 
691   function setRate(uint256 _rate) public onlyWhileOpen onlyOwner {
692     require(_rate > 0);
693     rate = _rate;
694   }
695 
696   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
697     sgcToken.sendTokens(_beneficiary, _tokenAmount);
698   }
699 }