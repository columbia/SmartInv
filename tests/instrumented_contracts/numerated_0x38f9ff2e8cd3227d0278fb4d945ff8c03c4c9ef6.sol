1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipRenounced(address indexed previousOwner);
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     emit OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250   /**
251    * @dev Allows the current owner to relinquish control of the contract.
252    */
253   function renounceOwnership() public onlyOwner {
254     emit OwnershipRenounced(owner);
255     owner = address(0);
256   }
257 }
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
263  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264  */
265 contract MintableToken is StandardToken, Ownable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply_ = totalSupply_.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     emit Mint(_to, _amount);
287     emit Transfer(address(0), _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner canMint public returns (bool) {
296     mintingFinished = true;
297     emit MintFinished();
298     return true;
299   }
300 }
301 
302 /**
303  * @title Crowdsale
304  * @dev Crowdsale is a base contract for managing a token crowdsale,
305  * allowing investors to purchase tokens with ether. This contract implements
306  * such functionality in its most fundamental form and can be extended to provide additional
307  * functionality and/or custom behavior.
308  * The external interface represents the basic interface for purchasing tokens, and conform
309  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
310  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
311  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
312  * behavior.
313  */
314 contract Crowdsale {
315   using SafeMath for uint256;
316 
317   // The token being sold
318   ERC20 public token;
319 
320   // Address where funds are collected
321   address public wallet;
322 
323   // How many token units a buyer gets per wei
324   uint256 public rate;
325 
326   // Amount of wei raised
327   uint256 public weiRaised;
328 
329   /**
330    * Event for token purchase logging
331    * @param purchaser who paid for the tokens
332    * @param beneficiary who got the tokens
333    * @param value weis paid for purchase
334    * @param amount amount of tokens purchased
335    */
336   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
337 
338   /**
339    * @param _rate Number of token units a buyer gets per wei
340    * @param _wallet Address where collected funds will be forwarded to
341    * @param _token Address of the token being sold
342    */
343   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
344     require(_rate > 0);
345     require(_wallet != address(0));
346     require(_token != address(0));
347 
348     rate = _rate;
349     wallet = _wallet;
350     token = _token;
351   }
352 
353   /**
354    * @dev fallback function ***DO NOT OVERRIDE***
355    */
356   function () external payable {
357     buyTokens(msg.sender);
358   }
359 
360   /**
361    * @dev low level token purchase ***DO NOT OVERRIDE***
362    * @param _beneficiary Address performing the token purchase
363    */
364   function buyTokens(address _beneficiary) public payable {
365 
366     uint256 weiAmount = msg.value;
367     _preValidatePurchase(_beneficiary, weiAmount);
368 
369     // calculate token amount to be created
370     uint256 tokens = _getTokenAmount(weiAmount);
371 
372     // update state
373     weiRaised = weiRaised.add(weiAmount);
374 
375     _processPurchase(_beneficiary, tokens);
376     emit TokenPurchase(
377       msg.sender,
378       _beneficiary,
379       weiAmount,
380       tokens
381     );
382 
383     _updatePurchasingState(_beneficiary, weiAmount);
384 
385     _forwardFunds();
386     _postValidatePurchase(_beneficiary, weiAmount);
387   }
388 
389   /**
390    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
391    * @param _beneficiary Address performing the token purchase
392    * @param _weiAmount Value in wei involved in the purchase
393    */
394   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
395     require(_beneficiary != address(0));
396     require(_weiAmount != 0);
397   }
398 
399   /**
400    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
401    * @param _beneficiary Address performing the token purchase
402    * @param _weiAmount Value in wei involved in the purchase
403    */
404   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
405     // optional override
406   }
407 
408   /**
409    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
410    * @param _beneficiary Address performing the token purchase
411    * @param _tokenAmount Number of tokens to be emitted
412    */
413   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
414     token.transfer(_beneficiary, _tokenAmount);
415   }
416 
417   /**
418    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
419    * @param _beneficiary Address receiving the tokens
420    * @param _tokenAmount Number of tokens to be purchased
421    */
422   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
423     _deliverTokens(_beneficiary, _tokenAmount);
424   }
425 
426   /**
427    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
428    * @param _beneficiary Address receiving the tokens
429    * @param _weiAmount Value in wei involved in the purchase
430    */
431   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
432     // optional override
433   }
434 
435   /**
436    * @dev Override to extend the way in which ether is converted to tokens.
437    * @param _weiAmount Value in wei to be converted into tokens
438    * @return Number of tokens that can be purchased with the specified _weiAmount
439    */
440   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
441     return _weiAmount.mul(rate);
442   }
443 
444   /**
445    * @dev Determines how ETH is stored/forwarded on purchases.
446    */
447   function _forwardFunds() internal {
448     wallet.transfer(msg.value);
449   }
450 }
451 
452 /**
453  * @title CappedCrowdsale
454  * @dev Crowdsale with a limit for total contributions.
455  */
456 contract CappedCrowdsale is Crowdsale {
457   using SafeMath for uint256;
458 
459   uint256 public cap;
460 
461   /**
462    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
463    * @param _cap Max amount of wei to be contributed
464    */
465   function CappedCrowdsale(uint256 _cap) public {
466     require(_cap > 0);
467     cap = _cap;
468   }
469 
470   /**
471    * @dev Checks whether the cap has been reached.
472    * @return Whether the cap was reached
473    */
474   function capReached() public view returns (bool) {
475     return weiRaised >= cap;
476   }
477 
478   /**
479    * @dev Extend parent behavior requiring purchase to respect the funding cap.
480    * @param _beneficiary Token purchaser
481    * @param _weiAmount Amount of wei contributed
482    */
483   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
484     super._preValidatePurchase(_beneficiary, _weiAmount);
485     require(weiRaised.add(_weiAmount) <= cap);
486   }
487 
488 }
489 
490 /**
491  * @title TimedCrowdsale
492  * @dev Crowdsale accepting contributions only within a time frame.
493  */
494 contract TimedCrowdsale is Crowdsale {
495   using SafeMath for uint256;
496 
497   uint256 public openingTime;
498   uint256 public closingTime;
499 
500   /**
501    * @dev Reverts if not in crowdsale time range.
502    */
503   modifier onlyWhileOpen {
504     // solium-disable-next-line security/no-block-members
505     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
506     _;
507   }
508 
509   /**
510    * @dev Constructor, takes crowdsale opening and closing times.
511    * @param _openingTime Crowdsale opening time
512    * @param _closingTime Crowdsale closing time
513    */
514   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
515     // solium-disable-next-line security/no-block-members
516     require(_openingTime >= block.timestamp);
517     require(_closingTime >= _openingTime);
518 
519     openingTime = _openingTime;
520     closingTime = _closingTime;
521   }
522 
523   /**
524    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
525    * @return Whether crowdsale period has elapsed
526    */
527   function hasClosed() public view returns (bool) {
528     // solium-disable-next-line security/no-block-members
529     return block.timestamp > closingTime;
530   }
531 
532   /**
533    * @dev Extend parent behavior requiring to be within contributing period
534    * @param _beneficiary Token purchaser
535    * @param _weiAmount Amount of wei contributed
536    */
537   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
538     super._preValidatePurchase(_beneficiary, _weiAmount);
539   }
540 
541 }
542 
543 /**
544  * @title MintedCrowdsale
545  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
546  * Token ownership should be transferred to MintedCrowdsale for minting.
547  */
548 contract MintedCrowdsale is Crowdsale {
549 
550   /**
551    * @dev Overrides delivery by minting tokens upon purchase.
552    * @param _beneficiary Token purchaser
553    * @param _tokenAmount Number of tokens to be minted
554    */
555   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
556     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
557   }
558 }
559 
560 /**
561  * @title GCC Token Sale
562  * @dev Extension of CappedCrowdsale, TimedCrowdsale, MintedCrowdsale, Ownable. Entry point for GCC Token Sale.
563  */
564 contract GCCTokenICO is CappedCrowdsale, TimedCrowdsale, MintedCrowdsale, Ownable {
565 
566   address private _tokenAddress;
567 
568   event TokenContractOwnershipTransferred(address indexed newOwner);
569 
570   function GCCTokenICO(
571     uint256 _openingTime,
572     uint256 _closingTime,
573     uint256 _rate,
574     address _wallet,
575     uint256 _cap,
576     MintableToken _token
577   )
578     public
579     Crowdsale(_rate, _wallet, _token)
580     CappedCrowdsale(_cap)
581     TimedCrowdsale(_openingTime, _closingTime)
582   {
583     _tokenAddress = _token;
584   }
585 
586   /**
587    * @dev Allows this contract to transfer control of token contract to a newOwner.
588    * @param newOwner The address to transfer ownership to.
589    */
590   function transferTokenContractOwnership(address newOwner) public onlyOwner {
591     require(newOwner != address(0));
592     Ownable(_tokenAddress).transferOwnership(newOwner);
593     emit TokenContractOwnershipTransferred(newOwner);
594   }
595 
596 }