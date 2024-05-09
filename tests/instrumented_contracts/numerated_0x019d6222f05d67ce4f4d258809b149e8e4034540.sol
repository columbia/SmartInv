1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender)
174     public view returns (uint256);
175 
176   function transferFrom(address from, address to, uint256 value)
177     public returns (bool);
178 
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(
181     address indexed owner,
182     address indexed spender,
183     uint256 value
184   );
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasMintPermission() {
328     require(msg.sender == owner);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(
339     address _to,
340     uint256 _amount
341   )
342     hasMintPermission
343     canMint
344     public
345     returns (bool)
346   {
347     totalSupply_ = totalSupply_.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     emit Mint(_to, _amount);
350     emit Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     emit MintFinished();
361     return true;
362   }
363 }
364 
365 /**
366  * @title Crowdsale
367  * @dev Crowdsale is a base contract for managing a token crowdsale,
368  * allowing investors to purchase tokens with ether. This contract implements
369  * such functionality in its most fundamental form and can be extended to provide additional
370  * functionality and/or custom behavior.
371  * The external interface represents the basic interface for purchasing tokens, and conform
372  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
373  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
374  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
375  * behavior.
376  */
377 contract Crowdsale {
378   using SafeMath for uint256;
379 
380   // The token being sold
381   ERC20 public token;
382 
383   // Address where funds are collected
384   address public wallet;
385 
386   // How many token units a buyer gets per wei.
387   // The rate is the conversion between wei and the smallest and indivisible token unit.
388   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
389   // 1 wei will give you 1 unit, or 0.001 TOK.
390   uint256 public rate;
391 
392   // Amount of wei raised
393   uint256 public weiRaised;
394 
395   /**
396    * Event for token purchase logging
397    * @param purchaser who paid for the tokens
398    * @param beneficiary who got the tokens
399    * @param value weis paid for purchase
400    * @param amount amount of tokens purchased
401    */
402   event TokenPurchase(
403     address indexed purchaser,
404     address indexed beneficiary,
405     uint256 value,
406     uint256 amount
407   );
408 
409   /**
410    * @param _rate Number of token units a buyer gets per wei
411    * @param _wallet Address where collected funds will be forwarded to
412    * @param _token Address of the token being sold
413    */
414   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
415     require(_rate > 0);
416     require(_wallet != address(0));
417     require(_token != address(0));
418 
419     rate = _rate;
420     wallet = _wallet;
421     token = _token;
422   }
423 
424   // -----------------------------------------
425   // Crowdsale external interface
426   // -----------------------------------------
427 
428   /**
429    * @dev fallback function ***DO NOT OVERRIDE***
430    */
431   function () external payable {
432     buyTokens(msg.sender);
433   }
434 
435   /**
436    * @dev low level token purchase ***DO NOT OVERRIDE***
437    * @param _beneficiary Address performing the token purchase
438    */
439   function buyTokens(address _beneficiary) public payable {
440 
441     uint256 weiAmount = msg.value;
442     _preValidatePurchase(_beneficiary, weiAmount);
443 
444     // calculate token amount to be created
445     uint256 tokens = _getTokenAmount(weiAmount);
446 
447     // update state
448     weiRaised = weiRaised.add(weiAmount);
449 
450     _processPurchase(_beneficiary, tokens);
451     emit TokenPurchase(
452       msg.sender,
453       _beneficiary,
454       weiAmount,
455       tokens
456     );
457 
458     _updatePurchasingState(_beneficiary, weiAmount);
459 
460     _forwardFunds();
461     _postValidatePurchase(_beneficiary, weiAmount);
462   }
463 
464   // -----------------------------------------
465   // Internal interface (extensible)
466   // -----------------------------------------
467 
468   /**
469    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
470    * @param _beneficiary Address performing the token purchase
471    * @param _weiAmount Value in wei involved in the purchase
472    */
473   function _preValidatePurchase(
474     address _beneficiary,
475     uint256 _weiAmount
476   )
477     internal
478   {
479     require(_beneficiary != address(0));
480     require(_weiAmount != 0);
481   }
482 
483   /**
484    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
485    * @param _beneficiary Address performing the token purchase
486    * @param _weiAmount Value in wei involved in the purchase
487    */
488   function _postValidatePurchase(
489     address _beneficiary,
490     uint256 _weiAmount
491   )
492     internal
493   {
494     // optional override
495   }
496 
497   /**
498    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
499    * @param _beneficiary Address performing the token purchase
500    * @param _tokenAmount Number of tokens to be emitted
501    */
502   function _deliverTokens(
503     address _beneficiary,
504     uint256 _tokenAmount
505   )
506     internal
507   {
508     token.transfer(_beneficiary, _tokenAmount);
509   }
510 
511   /**
512    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
513    * @param _beneficiary Address receiving the tokens
514    * @param _tokenAmount Number of tokens to be purchased
515    */
516   function _processPurchase(
517     address _beneficiary,
518     uint256 _tokenAmount
519   )
520     internal
521   {
522     _deliverTokens(_beneficiary, _tokenAmount);
523   }
524 
525   /**
526    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
527    * @param _beneficiary Address receiving the tokens
528    * @param _weiAmount Value in wei involved in the purchase
529    */
530   function _updatePurchasingState(
531     address _beneficiary,
532     uint256 _weiAmount
533   )
534     internal
535   {
536     // optional override
537   }
538 
539   /**
540    * @dev Override to extend the way in which ether is converted to tokens.
541    * @param _weiAmount Value in wei to be converted into tokens
542    * @return Number of tokens that can be purchased with the specified _weiAmount
543    */
544   function _getTokenAmount(uint256 _weiAmount)
545     internal view returns (uint256)
546   {
547     return _weiAmount.mul(rate);
548   }
549 
550   /**
551    * @dev Determines how ETH is stored/forwarded on purchases.
552    */
553   function _forwardFunds() internal {
554     wallet.transfer(msg.value);
555   }
556 }
557 
558 /**
559  * @title MintedCrowdsale
560  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
561  * Token ownership should be transferred to MintedCrowdsale for minting.
562  */
563 contract MintedCrowdsale is Crowdsale {
564 
565   /**
566    * @dev Overrides delivery by minting tokens upon purchase.
567    * @param _beneficiary Token purchaser
568    * @param _tokenAmount Number of tokens to be minted
569    */
570   function _deliverTokens(
571     address _beneficiary,
572     uint256 _tokenAmount
573   )
574     internal
575   {
576     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
577   }
578 }
579 
580 /**
581  * @title Pausable
582  * @dev Base contract which allows children to implement an emergency stop mechanism.
583  */
584 contract Pausable is Ownable {
585   event Pause();
586   event Unpause();
587 
588   bool public paused = false;
589 
590 
591   /**
592    * @dev Modifier to make a function callable only when the contract is not paused.
593    */
594   modifier whenNotPaused() {
595     require(!paused);
596     _;
597   }
598 
599   /**
600    * @dev Modifier to make a function callable only when the contract is paused.
601    */
602   modifier whenPaused() {
603     require(paused);
604     _;
605   }
606 
607   /**
608    * @dev called by the owner to pause, triggers stopped state
609    */
610   function pause() onlyOwner whenNotPaused public {
611     paused = true;
612     emit Pause();
613   }
614 
615   /**
616    * @dev called by the owner to unpause, returns to normal state
617    */
618   function unpause() onlyOwner whenPaused public {
619     paused = false;
620     emit Unpause();
621   }
622 }
623 
624 /**
625  * @title TokenDestructible:
626  * @author Remco Bloemen <remco@2π.com>
627  * @dev Base contract that can be destroyed by owner. All funds in contract including
628  * listed tokens will be sent to the owner.
629  */
630 contract TokenDestructible is Ownable {
631 
632   constructor() public payable { }
633 
634   /**
635    * @notice Terminate contract and refund to owner
636    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
637    refund.
638    * @notice The called token contracts could try to re-enter this contract. Only
639    supply token contracts you trust.
640    */
641   function destroy(address[] tokens) onlyOwner public {
642 
643     // Transfer tokens to owner
644     for (uint256 i = 0; i < tokens.length; i++) {
645       ERC20Basic token = ERC20Basic(tokens[i]);
646       uint256 balance = token.balanceOf(this);
647       token.transfer(owner, balance);
648     }
649 
650     // Transfer Eth to owner and terminate contract
651     selfdestruct(owner);
652   }
653 }
654 
655 /// @title EverGold Crowdsale.
656 /// @dev Crowsale inside the game.
657 contract EverGoldCrowdsale is MintedCrowdsale, Pausable, TokenDestructible {
658 
659   constructor(uint256 _rate, address _wallet, ERC20 _token)
660     public
661     Crowdsale(_rate, _wallet, _token)
662   {
663   }
664 
665   /**
666    * @dev Override to extend the way in which ether is converted to tokens.
667    * @param _weiAmount Value in wei to be converted into tokens
668    * @return Number of tokens that can be purchased with the specified _weiAmount
669    */
670   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
671     uint256 weigold = _weiAmount.mul(rate);
672     uint256 gold = weigold.div(10 ** 15);
673     if (gold >= 10000) {
674       gold += 2500;
675     } else if (gold >= 5000) {
676       gold += 1000;
677     } else if (gold >= 3000) {
678       gold += 300;
679     } else if (gold >= 1000) {
680       gold += 100;
681     }
682     return gold;
683   }
684 }