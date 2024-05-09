1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
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
38 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 pragma solidity ^0.4.24;
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address private _owner;
49 
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   constructor() internal {
60     _owner = msg.sender;
61     emit OwnershipTransferred(address(0), _owner);
62   }
63 
64   /**
65    * @return the address of the owner.
66    */
67   function owner() public view returns(address) {
68     return _owner;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(isOwner());
76     _;
77   }
78 
79   /**
80    * @return true if `msg.sender` is the owner of the contract.
81    */
82   function isOwner() public view returns(bool) {
83     return msg.sender == _owner;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    * @notice Renouncing to ownership will leave the contract without an owner.
89    * It will not be possible to call the functions with the `onlyOwner`
90    * modifier anymore.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipTransferred(_owner, address(0));
94     _owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) public onlyOwner {
102     _transferOwnership(newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address newOwner) internal {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(_owner, newOwner);
112     _owner = newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
117 
118 pragma solidity ^0.4.24;
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that revert on error
123  */
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, reverts on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
133     if (a == 0) {
134       return 0;
135     }
136 
137     uint256 c = a * b;
138     require(c / a == b);
139 
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b > 0); // Solidity only automatically asserts when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     uint256 c = a - b;
160 
161     return c;
162   }
163 
164   /**
165   * @dev Adds two numbers, reverts on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256) {
168     uint256 c = a + b;
169     require(c >= a);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
176   * reverts when dividing by zero.
177   */
178   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179     require(b != 0);
180     return a % b;
181   }
182 }
183 
184 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
185 
186 pragma solidity ^0.4.24;
187 
188 
189 
190 /**
191  * @title SafeERC20
192  * @dev Wrappers around ERC20 operations that throw on failure.
193  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
194  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
195  */
196 library SafeERC20 {
197 
198   using SafeMath for uint256;
199 
200   function safeTransfer(
201     IERC20 token,
202     address to,
203     uint256 value
204   )
205     internal
206   {
207     require(token.transfer(to, value));
208   }
209 
210   function safeTransferFrom(
211     IERC20 token,
212     address from,
213     address to,
214     uint256 value
215   )
216     internal
217   {
218     require(token.transferFrom(from, to, value));
219   }
220 
221   function safeApprove(
222     IERC20 token,
223     address spender,
224     uint256 value
225   )
226     internal
227   {
228     // safeApprove should only be called when setting an initial allowance, 
229     // or when resetting it to zero. To increase and decrease it, use 
230     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
231     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
232     require(token.approve(spender, value));
233   }
234 
235   function safeIncreaseAllowance(
236     IERC20 token,
237     address spender,
238     uint256 value
239   )
240     internal
241   {
242     uint256 newAllowance = token.allowance(address(this), spender).add(value);
243     require(token.approve(spender, newAllowance));
244   }
245 
246   function safeDecreaseAllowance(
247     IERC20 token,
248     address spender,
249     uint256 value
250   )
251     internal
252   {
253     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
254     require(token.approve(spender, newAllowance));
255   }
256 }
257 
258 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
259 
260 pragma solidity ^0.4.24;
261 
262 /**
263  * @title Helps contracts guard against reentrancy attacks.
264  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
265  * @dev If you mark a function `nonReentrant`, you should also
266  * mark it `external`.
267  */
268 contract ReentrancyGuard {
269 
270   /// @dev counter to allow mutex lock with only one SSTORE operation
271   uint256 private _guardCounter;
272 
273   constructor() internal {
274     // The counter starts at one to prevent changing it from zero to a non-zero
275     // value, which is a more expensive operation.
276     _guardCounter = 1;
277   }
278 
279   /**
280    * @dev Prevents a contract from calling itself, directly or indirectly.
281    * Calling a `nonReentrant` function from another `nonReentrant`
282    * function is not supported. It is possible to prevent this from happening
283    * by making the `nonReentrant` function external, and make it call a
284    * `private` function that does the actual work.
285    */
286   modifier nonReentrant() {
287     _guardCounter += 1;
288     uint256 localCounter = _guardCounter;
289     _;
290     require(localCounter == _guardCounter);
291   }
292 
293 }
294 
295 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
296 
297 pragma solidity ^0.4.24;
298 
299 
300 
301 
302 
303 /**
304  * @title Crowdsale
305  * @dev Crowdsale is a base contract for managing a token crowdsale,
306  * allowing investors to purchase tokens with ether. This contract implements
307  * such functionality in its most fundamental form and can be extended to provide additional
308  * functionality and/or custom behavior.
309  * The external interface represents the basic interface for purchasing tokens, and conform
310  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
311  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
312  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
313  * behavior.
314  */
315 contract Crowdsale is ReentrancyGuard {
316   using SafeMath for uint256;
317   using SafeERC20 for IERC20;
318 
319   // The token being sold
320   IERC20 private _token;
321 
322   // Address where funds are collected
323   address private _wallet;
324 
325   // How many token units a buyer gets per wei.
326   // The rate is the conversion between wei and the smallest and indivisible token unit.
327   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
328   // 1 wei will give you 1 unit, or 0.001 TOK.
329   uint256 private _rate;
330 
331   // Amount of wei raised
332   uint256 private _weiRaised;
333 
334   /**
335    * Event for token purchase logging
336    * @param purchaser who paid for the tokens
337    * @param beneficiary who got the tokens
338    * @param value weis paid for purchase
339    * @param amount amount of tokens purchased
340    */
341   event TokensPurchased(
342     address indexed purchaser,
343     address indexed beneficiary,
344     uint256 value,
345     uint256 amount
346   );
347 
348   /**
349    * @param rate Number of token units a buyer gets per wei
350    * @dev The rate is the conversion between wei and the smallest and indivisible
351    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
352    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
353    * @param wallet Address where collected funds will be forwarded to
354    * @param token Address of the token being sold
355    */
356   constructor(uint256 rate, address wallet, IERC20 token) internal {
357     require(rate > 0);
358     require(wallet != address(0));
359     require(token != address(0));
360 
361     _rate = rate;
362     _wallet = wallet;
363     _token = token;
364   }
365 
366   // -----------------------------------------
367   // Crowdsale external interface
368   // -----------------------------------------
369 
370   /**
371    * @dev fallback function ***DO NOT OVERRIDE***
372    * Note that other contracts will transfer fund with a base gas stipend
373    * of 2300, which is not enough to call buyTokens. Consider calling
374    * buyTokens directly when purchasing tokens from a contract.
375    */
376   function () external payable {
377     buyTokens(msg.sender);
378   }
379 
380   /**
381    * @return the token being sold.
382    */
383   function token() public view returns(IERC20) {
384     return _token;
385   }
386 
387   /**
388    * @return the address where funds are collected.
389    */
390   function wallet() public view returns(address) {
391     return _wallet;
392   }
393 
394   /**
395    * @return the number of token units a buyer gets per wei.
396    */
397   function rate() public view returns(uint256) {
398     return _rate;
399   }
400 
401   /**
402    * @return the amount of wei raised.
403    */
404   function weiRaised() public view returns (uint256) {
405     return _weiRaised;
406   }
407 
408   /**
409    * @dev low level token purchase ***DO NOT OVERRIDE***
410    * This function has a non-reentrancy guard, so it shouldn't be called by
411    * another `nonReentrant` function.
412    * @param beneficiary Recipient of the token purchase
413    */
414   function buyTokens(address beneficiary) public nonReentrant payable {
415 
416     uint256 weiAmount = msg.value;
417     _preValidatePurchase(beneficiary, weiAmount);
418 
419     // calculate token amount to be created
420     uint256 tokens = _getTokenAmount(weiAmount);
421 
422     // update state
423     _weiRaised = _weiRaised.add(weiAmount);
424 
425     _processPurchase(beneficiary, tokens);
426     emit TokensPurchased(
427       msg.sender,
428       beneficiary,
429       weiAmount,
430       tokens
431     );
432 
433     _updatePurchasingState(beneficiary, weiAmount);
434 
435     _forwardFunds();
436     _postValidatePurchase(beneficiary, weiAmount);
437   }
438 
439   // -----------------------------------------
440   // Internal interface (extensible)
441   // -----------------------------------------
442 
443   /**
444    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
445    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
446    *   super._preValidatePurchase(beneficiary, weiAmount);
447    *   require(weiRaised().add(weiAmount) <= cap);
448    * @param beneficiary Address performing the token purchase
449    * @param weiAmount Value in wei involved in the purchase
450    */
451   function _preValidatePurchase(
452     address beneficiary,
453     uint256 weiAmount
454   )
455     internal
456     view
457   {
458     require(beneficiary != address(0));
459     require(weiAmount != 0);
460   }
461 
462   /**
463    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
464    * @param beneficiary Address performing the token purchase
465    * @param weiAmount Value in wei involved in the purchase
466    */
467   function _postValidatePurchase(
468     address beneficiary,
469     uint256 weiAmount
470   )
471     internal
472     view
473   {
474     // optional override
475   }
476 
477   /**
478    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
479    * @param beneficiary Address performing the token purchase
480    * @param tokenAmount Number of tokens to be emitted
481    */
482   function _deliverTokens(
483     address beneficiary,
484     uint256 tokenAmount
485   )
486     internal
487   {
488     _token.safeTransfer(beneficiary, tokenAmount);
489   }
490 
491   /**
492    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
493    * @param beneficiary Address receiving the tokens
494    * @param tokenAmount Number of tokens to be purchased
495    */
496   function _processPurchase(
497     address beneficiary,
498     uint256 tokenAmount
499   )
500     internal
501   {
502     _deliverTokens(beneficiary, tokenAmount);
503   }
504 
505   /**
506    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
507    * @param beneficiary Address receiving the tokens
508    * @param weiAmount Value in wei involved in the purchase
509    */
510   function _updatePurchasingState(
511     address beneficiary,
512     uint256 weiAmount
513   )
514     internal
515   {
516     // optional override
517   }
518 
519   /**
520    * @dev Override to extend the way in which ether is converted to tokens.
521    * @param weiAmount Value in wei to be converted into tokens
522    * @return Number of tokens that can be purchased with the specified _weiAmount
523    */
524   function _getTokenAmount(uint256 weiAmount)
525     internal view returns (uint256)
526   {
527     return weiAmount.mul(_rate);
528   }
529 
530   /**
531    * @dev Determines how ETH is stored/forwarded on purchases.
532    */
533   function _forwardFunds() internal {
534     _wallet.transfer(msg.value);
535   }
536 }
537 
538 // File: contracts/Presale.sol
539 
540 pragma solidity ^0.4.24;
541 
542 
543 
544 
545 /**
546  * @title Tip Token Presale
547  */
548 contract Presale is Crowdsale, Ownable  {
549   IERC20 private _token;
550   mapping(address => bool) public whitelisted;
551 
552   constructor(uint256 rate, address wallet, address token)
553   Crowdsale(rate, wallet, IERC20(token))
554   public {
555     _token = IERC20(token);
556   }
557 
558   function _getTokenAmount(uint256 weiAmount)
559     internal view returns (uint256)
560   {
561     return rate().mul(weiAmount).div(10**13);
562   }
563 
564   function whitelist(address [] investors) public onlyOwner  {
565     for(uint i = 0; i < investors.length; i++) {
566       address investor = investors[i];
567       whitelisted[investor] = true;
568     }
569   }
570 
571   function _preValidatePurchase(
572     address beneficiary,
573     uint256 weiAmount
574   )
575     internal
576     view
577   {
578     require(beneficiary != address(0));
579     require(weiAmount != 0);
580     // if not whitelisted then check weiAmount
581     if (!whitelisted[beneficiary]) {
582       require(weiAmount <= 10 ether);
583     }
584   }
585 
586   function recoverToken(address _tokenAddress) public onlyOwner {
587     IERC20 token = IERC20(_tokenAddress);
588     uint balance = token.balanceOf(this);
589     token.transfer(msg.sender, balance);
590   }
591 }