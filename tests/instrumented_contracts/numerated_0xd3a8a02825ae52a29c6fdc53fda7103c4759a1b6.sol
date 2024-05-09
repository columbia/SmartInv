1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114   using SafeMath for uint256;
115 
116   function safeTransfer(
117     IERC20 token,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(
127     IERC20 token,
128     address from,
129     address to,
130     uint256 value
131   )
132     internal
133   {
134     require(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(
138     IERC20 token,
139     address spender,
140     uint256 value
141   )
142     internal
143   {
144     // safeApprove should only be called when setting an initial allowance, 
145     // or when resetting it to zero. To increase and decrease it, use 
146     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148     require(token.approve(spender, value));
149   }
150 
151   function safeIncreaseAllowance(
152     IERC20 token,
153     address spender,
154     uint256 value
155   )
156     internal
157   {
158     uint256 newAllowance = token.allowance(address(this), spender).add(value);
159     require(token.approve(spender, newAllowance));
160   }
161 
162   function safeDecreaseAllowance(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170     require(token.approve(spender, newAllowance));
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
175 
176 /**
177  * @title Helps contracts guard against reentrancy attacks.
178  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
179  * @dev If you mark a function `nonReentrant`, you should also
180  * mark it `external`.
181  */
182 contract ReentrancyGuard {
183 
184   /// @dev counter to allow mutex lock with only one SSTORE operation
185   uint256 private _guardCounter;
186 
187   constructor() internal {
188     // The counter starts at one to prevent changing it from zero to a non-zero
189     // value, which is a more expensive operation.
190     _guardCounter = 1;
191   }
192 
193   /**
194    * @dev Prevents a contract from calling itself, directly or indirectly.
195    * Calling a `nonReentrant` function from another `nonReentrant`
196    * function is not supported. It is possible to prevent this from happening
197    * by making the `nonReentrant` function external, and make it call a
198    * `private` function that does the actual work.
199    */
200   modifier nonReentrant() {
201     _guardCounter += 1;
202     uint256 localCounter = _guardCounter;
203     _;
204     require(localCounter == _guardCounter);
205   }
206 
207 }
208 
209 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
210 
211 /**
212  * @title Crowdsale
213  * @dev Crowdsale is a base contract for managing a token crowdsale,
214  * allowing investors to purchase tokens with ether. This contract implements
215  * such functionality in its most fundamental form and can be extended to provide additional
216  * functionality and/or custom behavior.
217  * The external interface represents the basic interface for purchasing tokens, and conform
218  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
219  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
220  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
221  * behavior.
222  */
223 contract Crowdsale is ReentrancyGuard {
224   using SafeMath for uint256;
225   using SafeERC20 for IERC20;
226 
227   // The token being sold
228   IERC20 private _token;
229 
230   // Address where funds are collected
231   address private _wallet;
232 
233   // How many token units a buyer gets per wei.
234   // The rate is the conversion between wei and the smallest and indivisible token unit.
235   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
236   // 1 wei will give you 1 unit, or 0.001 TOK.
237   uint256 private _rate;
238 
239   // Amount of wei raised
240   uint256 private _weiRaised;
241 
242   /**
243    * Event for token purchase logging
244    * @param purchaser who paid for the tokens
245    * @param beneficiary who got the tokens
246    * @param value weis paid for purchase
247    * @param amount amount of tokens purchased
248    */
249   event TokensPurchased(
250     address indexed purchaser,
251     address indexed beneficiary,
252     uint256 value,
253     uint256 amount
254   );
255 
256   /**
257    * @param rate Number of token units a buyer gets per wei
258    * @dev The rate is the conversion between wei and the smallest and indivisible
259    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
260    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
261    * @param wallet Address where collected funds will be forwarded to
262    * @param token Address of the token being sold
263    */
264   constructor(uint256 rate, address wallet, IERC20 token) internal {
265     require(rate > 0);
266     require(wallet != address(0));
267     require(token != address(0));
268 
269     _rate = rate;
270     _wallet = wallet;
271     _token = token;
272   }
273 
274   // -----------------------------------------
275   // Crowdsale external interface
276   // -----------------------------------------
277 
278   /**
279    * @dev fallback function ***DO NOT OVERRIDE***
280    * Note that other contracts will transfer fund with a base gas stipend
281    * of 2300, which is not enough to call buyTokens. Consider calling
282    * buyTokens directly when purchasing tokens from a contract.
283    */
284   function () external payable {
285     buyTokens(msg.sender);
286   }
287 
288   /**
289    * @return the token being sold.
290    */
291   function token() public view returns(IERC20) {
292     return _token;
293   }
294 
295   /**
296    * @return the address where funds are collected.
297    */
298   function wallet() public view returns(address) {
299     return _wallet;
300   }
301 
302   /**
303    * @return the number of token units a buyer gets per wei.
304    */
305   function rate() public view returns(uint256) {
306     return _rate;
307   }
308 
309   /**
310    * @return the amount of wei raised.
311    */
312   function weiRaised() public view returns (uint256) {
313     return _weiRaised;
314   }
315 
316   /**
317    * @dev low level token purchase ***DO NOT OVERRIDE***
318    * This function has a non-reentrancy guard, so it shouldn't be called by
319    * another `nonReentrant` function.
320    * @param beneficiary Recipient of the token purchase
321    */
322   function buyTokens(address beneficiary) public nonReentrant payable {
323 
324     uint256 weiAmount = msg.value;
325     _preValidatePurchase(beneficiary, weiAmount);
326 
327     // calculate token amount to be created
328     uint256 tokens = _getTokenAmount(weiAmount);
329 
330     // update state
331     _weiRaised = _weiRaised.add(weiAmount);
332 
333     _processPurchase(beneficiary, tokens);
334     emit TokensPurchased(
335       msg.sender,
336       beneficiary,
337       weiAmount,
338       tokens
339     );
340 
341     _updatePurchasingState(beneficiary, weiAmount);
342 
343     _forwardFunds();
344     _postValidatePurchase(beneficiary, weiAmount);
345   }
346 
347   // -----------------------------------------
348   // Internal interface (extensible)
349   // -----------------------------------------
350 
351   /**
352    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
353    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
354    *   super._preValidatePurchase(beneficiary, weiAmount);
355    *   require(weiRaised().add(weiAmount) <= cap);
356    * @param beneficiary Address performing the token purchase
357    * @param weiAmount Value in wei involved in the purchase
358    */
359   function _preValidatePurchase(
360     address beneficiary,
361     uint256 weiAmount
362   )
363     internal
364     view
365   {
366     require(beneficiary != address(0));
367     require(weiAmount != 0);
368   }
369 
370   /**
371    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
372    * @param beneficiary Address performing the token purchase
373    * @param weiAmount Value in wei involved in the purchase
374    */
375   function _postValidatePurchase(
376     address beneficiary,
377     uint256 weiAmount
378   )
379     internal
380     view
381   {
382     // optional override
383   }
384 
385   /**
386    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
387    * @param beneficiary Address performing the token purchase
388    * @param tokenAmount Number of tokens to be emitted
389    */
390   function _deliverTokens(
391     address beneficiary,
392     uint256 tokenAmount
393   )
394     internal
395   {
396     _token.safeTransfer(beneficiary, tokenAmount);
397   }
398 
399   /**
400    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
401    * @param beneficiary Address receiving the tokens
402    * @param tokenAmount Number of tokens to be purchased
403    */
404   function _processPurchase(
405     address beneficiary,
406     uint256 tokenAmount
407   )
408     internal
409   {
410     _deliverTokens(beneficiary, tokenAmount);
411   }
412 
413   /**
414    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
415    * @param beneficiary Address receiving the tokens
416    * @param weiAmount Value in wei involved in the purchase
417    */
418   function _updatePurchasingState(
419     address beneficiary,
420     uint256 weiAmount
421   )
422     internal
423   {
424     // optional override
425   }
426 
427   /**
428    * @dev Override to extend the way in which ether is converted to tokens.
429    * @param weiAmount Value in wei to be converted into tokens
430    * @return Number of tokens that can be purchased with the specified _weiAmount
431    */
432   function _getTokenAmount(uint256 weiAmount)
433     internal view returns (uint256)
434   {
435     return weiAmount.mul(_rate);
436   }
437 
438   /**
439    * @dev Determines how ETH is stored/forwarded on purchases.
440    */
441   function _forwardFunds() internal {
442     _wallet.transfer(msg.value);
443   }
444 }
445 
446 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
447 
448 /**
449  * @title Ownable
450  * @dev The Ownable contract has an owner address, and provides basic authorization control
451  * functions, this simplifies the implementation of "user permissions".
452  */
453 contract Ownable {
454   address private _owner;
455 
456   event OwnershipTransferred(
457     address indexed previousOwner,
458     address indexed newOwner
459   );
460 
461   /**
462    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
463    * account.
464    */
465   constructor() internal {
466     _owner = msg.sender;
467     emit OwnershipTransferred(address(0), _owner);
468   }
469 
470   /**
471    * @return the address of the owner.
472    */
473   function owner() public view returns(address) {
474     return _owner;
475   }
476 
477   /**
478    * @dev Throws if called by any account other than the owner.
479    */
480   modifier onlyOwner() {
481     require(isOwner());
482     _;
483   }
484 
485   /**
486    * @return true if `msg.sender` is the owner of the contract.
487    */
488   function isOwner() public view returns(bool) {
489     return msg.sender == _owner;
490   }
491 
492   /**
493    * @dev Allows the current owner to relinquish control of the contract.
494    * @notice Renouncing to ownership will leave the contract without an owner.
495    * It will not be possible to call the functions with the `onlyOwner`
496    * modifier anymore.
497    */
498   function renounceOwnership() public onlyOwner {
499     emit OwnershipTransferred(_owner, address(0));
500     _owner = address(0);
501   }
502 
503   /**
504    * @dev Allows the current owner to transfer control of the contract to a newOwner.
505    * @param newOwner The address to transfer ownership to.
506    */
507   function transferOwnership(address newOwner) public onlyOwner {
508     _transferOwnership(newOwner);
509   }
510 
511   /**
512    * @dev Transfers control of the contract to a newOwner.
513    * @param newOwner The address to transfer ownership to.
514    */
515   function _transferOwnership(address newOwner) internal {
516     require(newOwner != address(0));
517     emit OwnershipTransferred(_owner, newOwner);
518     _owner = newOwner;
519   }
520 }
521 
522 // File: contracts/Presale.sol
523 
524 /**
525  * @title Tip Token Presale
526  */
527 contract Presale is Crowdsale, Ownable  {
528   IERC20 private _token;
529   mapping(address => bool) public whitelisted;
530 
531   constructor(uint256 rate, address wallet, address token)
532   Crowdsale(rate, wallet, IERC20(token))
533   public {
534     _token = IERC20(token);
535   }
536 
537   function _getTokenAmount(uint256 weiAmount)
538     internal view returns (uint256)
539   {
540     return rate().mul(weiAmount).div(10**13);
541   }
542 
543   function whitelist(address [] investors) public onlyOwner  {
544     for(uint i = 0; i < investors.length; i++) {
545       address investor = investors[i];
546       whitelisted[investor] = true;
547     }
548   }
549 
550   function _preValidatePurchase(
551     address beneficiary,
552     uint256 weiAmount
553   )
554     internal
555     view
556   {
557     require(beneficiary != address(0));
558     require(weiAmount != 0);
559     // if not whitelisted then check weiAmount
560     if (!whitelisted[beneficiary]) {
561       require(weiAmount <= 100 finney);
562     }
563   }
564 
565   function recoverToken(address _tokenAddress) public onlyOwner {
566     IERC20 token = IERC20(_tokenAddress);
567     uint balance = token.balanceOf(this);
568     token.transfer(msg.sender, balance);
569   }
570 }