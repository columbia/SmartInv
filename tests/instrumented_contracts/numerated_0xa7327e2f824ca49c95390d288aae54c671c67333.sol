1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: openzeppelin-solidity/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * This test is non-exhaustive, and there may be false-negatives: during the
251      * execution of a contract's constructor, its address will be reported as
252      * not containing a contract.
253      *
254      * IMPORTANT: It is unsafe to assume that an address for which this
255      * function returns false is an externally-owned account (EOA) and not a
256      * contract.
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != 0x0 && codehash != accountHash);
271     }
272 
273     /**
274      * @dev Converts an `address` into `address payable`. Note that this is
275      * simply a type cast: the actual underlying value is not changed.
276      *
277      * _Available since v2.4.0._
278      */
279     function toPayable(address account) internal pure returns (address payable) {
280         return address(uint160(account));
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      *
299      * _Available since v2.4.0._
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-call-value
305         (bool success, ) = recipient.call.value(amount)("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 }
309 
310 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     function safeApprove(IERC20 token, address spender, uint256 value) internal {
339         // safeApprove should only be called when setting an initial allowance,
340         // or when resetting it to zero. To increase and decrease it, use
341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342         // solhint-disable-next-line max-line-length
343         require((value == 0) || (token.allowance(address(this), spender) == 0),
344             "SafeERC20: approve from non-zero to non-zero allowance"
345         );
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347     }
348 
349     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).add(value);
351         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357     }
358 
359     /**
360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361      * on the return value: the return value is optional (but if data is returned, it must not be false).
362      * @param token The token targeted by the call.
363      * @param data The call data (encoded using abi.encode or one of its variants).
364      */
365     function callOptionalReturn(IERC20 token, bytes memory data) private {
366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367         // we're implementing it ourselves.
368 
369         // A Solidity high level call has three parts:
370         //  1. The target address is checked to verify it contains contract code
371         //  2. The call itself is made, and success asserted
372         //  3. The return value is decoded, which in turn checks the size of the returned data.
373         // solhint-disable-next-line max-line-length
374         require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = address(token).call(data);
378         require(success, "SafeERC20: low-level call failed");
379 
380         if (returndata.length > 0) { // Return data is optional
381             // solhint-disable-next-line max-line-length
382             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383         }
384     }
385 }
386 
387 // File: contracts/Interfaces/Uniswap.sol
388 
389 pragma solidity ^0.5.0;
390 
391 interface IUniswapFactoryInterface {
392   // Public Variables
393   // address public exchangeTemplate;
394   // uint256 public tokenCount;
395   // Create Exchange
396   function createExchange(address token) external returns (address exchange);
397   // Get Exchange and Token Info
398   function getExchange(address token) external view returns (IUniswapExchangeInterface exchange);
399   function getToken(address exchange) external view returns (address token);
400   function getTokenWithId(uint256 tokenId) external view returns (address token);
401   // Never use
402   function initializeFactory(address template) external;
403 }
404 
405 contract IUniswapExchangeInterface {
406   // Address of ERC20 token sold on this exchange
407   function tokenAddress() external view returns (address token);
408   // Address of Uniswap Factory
409   function factoryAddress() external view returns (address factory);
410   // Provide Liquidity
411   function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
412   function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
413   // Get Prices
414   function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
415   function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
416   function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
417   function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
418   // Trade ETH to ERC20
419   function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
420   function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
421   function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
422   function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
423   // Trade ERC20 to ETH
424   function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
425   function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
426   function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
427   function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
428   // Trade ERC20 to ERC20
429   function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
430   function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
431   function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
432   function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
433   // Trade ERC20 to Custom Pool
434   function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
435   function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
436   function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
437   function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
438   // ERC20 comaptibility for liquidity tokens
439 //  bytes32 public name;
440 //  bytes32 public symbol;
441 //  uint256 public decimals;
442 //  function transfer(address _to, uint256 _value) external returns (bool);
443 //  function transferFrom(address _from, address _to, uint256 value) external returns (bool);
444 //  function approve(address _spender, uint256 _value) external returns (bool);
445 //  function allowance(address _owner, address _spender) external view returns (uint256);
446 //  function balanceOf(address _owner) external view returns (uint256);
447 //  function totalSupply() external view returns (uint256);
448 //  // Never use
449 //  function setup(address token_addr) external;
450 }
451 
452 // File: contracts/Interfaces/ISafeProxyERC20.sol
453 
454 pragma solidity ^0.5.0;
455 
456 /**
457  * @dev Interface to be safe with not so good proxy contracts.
458  */
459 interface ISafeProxyERC20 {
460 
461     /**
462      * @dev Returns the amount of tokens owned by `account`.
463      */
464     function balanceOf(address account) external returns (uint256);
465 
466     /**
467      * @dev Returns the remaining number of tokens that `spender` will be
468      * allowed to spend on behalf of `owner` through {transferFrom}. This is
469      * zero by default.
470      *
471      * This value changes when {approve} or {transferFrom} are called.
472      */
473     function allowance(address owner, address spender) external returns (uint256);
474 
475     /**
476      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
477      *
478      * Returns a boolean value indicating whether the operation succeeded.
479      *
480      * IMPORTANT: Beware that changing an allowance with this method brings the risk
481      * that someone may use both the old and the new allowance by unfortunate
482      * transaction ordering. One possible solution to mitigate this race
483      * condition is to first reduce the spender's allowance to 0 and set the
484      * desired value afterwards:
485      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address spender, uint256 amount) external returns (bool);
490 }
491 
492 // File: contracts/Library/SafeProxyERC20.sol
493 
494 pragma solidity ^0.5.0;
495 
496 
497 
498 
499 library SafeProxyERC20 {
500     using SafeMath for uint256;
501     using Address for address;
502 
503     function safeApprove(ISafeProxyERC20 token, address spender, uint256 value) internal {
504         // safeApprove should only be called when setting an initial allowance,
505         // or when resetting it to zero. To increase and decrease it, use
506         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
507         // solhint-disable-next-line max-line-length
508         require((value == 0) || (token.allowance(address(this), spender) == 0),
509             "SafeProxyERC20: approve from non-zero to non-zero allowance"
510         );
511         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
512     }
513 
514     /**
515      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
516      * on the return value: the return value is optional (but if data is returned, it must not be false).
517      * @param token The token targeted by the call.
518      * @param data The call data (encoded using abi.encode or one of its variants).
519      */
520     function callOptionalReturn(ISafeProxyERC20 token, bytes memory data) private {
521         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
522         // we're implementing it ourselves.
523 
524         // A Solidity high level call has three parts:
525         //  1. The target address is checked to verify it contains contract code
526         //  2. The call itself is made, and success asserted
527         //  3. The return value is decoded, which in turn checks the size of the returned data.
528         // solhint-disable-next-line max-line-length
529         require(address(token).isContract(), "SafeProxyERC20: call to non-contract");
530 
531         // solhint-disable-next-line avoid-low-level-calls
532         (bool success, bytes memory returndata) = address(token).call(data);
533         require(success, "SafeProxyERC20: low-level call failed");
534 
535         if (returndata.length > 0) { // Return data is optional
536             // solhint-disable-next-line max-line-length
537             require(abi.decode(returndata, (bool)), "SafeProxyERC20: ERC20 operation did not succeed");
538         }
539     }
540 }
541 
542 // File: openzeppelin-solidity/contracts/GSN/Context.sol
543 
544 pragma solidity ^0.5.0;
545 
546 /*
547  * @dev Provides information about the current execution context, including the
548  * sender of the transaction and its data. While these are generally available
549  * via msg.sender and msg.data, they should not be accessed in such a direct
550  * manner, since when dealing with GSN meta-transactions the account sending and
551  * paying for execution may not be the actual sender (as far as an application
552  * is concerned).
553  *
554  * This contract is only required for intermediate, library-like contracts.
555  */
556 contract Context {
557     // Empty internal constructor, to prevent people from mistakenly deploying
558     // an instance of this contract, which should be used via inheritance.
559     constructor () internal { }
560     // solhint-disable-previous-line no-empty-blocks
561 
562     function _msgSender() internal view returns (address payable) {
563         return msg.sender;
564     }
565 
566     function _msgData() internal view returns (bytes memory) {
567         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
568         return msg.data;
569     }
570 }
571 
572 // File: openzeppelin-solidity/contracts/Ownership/Ownable.sol
573 
574 pragma solidity ^0.5.0;
575 
576 /**
577  * @dev Contract module which provides a basic access control mechanism, where
578  * there is an account (an owner) that can be granted exclusive access to
579  * specific functions.
580  *
581  * This module is used through inheritance. It will make available the modifier
582  * `onlyOwner`, which can be applied to your functions to restrict their use to
583  * the owner.
584  */
585 contract Ownable is Context {
586     address private _owner;
587 
588     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
589 
590     /**
591      * @dev Initializes the contract setting the deployer as the initial owner.
592      */
593     constructor () internal {
594         _owner = _msgSender();
595         emit OwnershipTransferred(address(0), _owner);
596     }
597 
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(isOwner(), "Ownable: caller is not the owner");
610         _;
611     }
612 
613     /**
614      * @dev Returns true if the caller is the current owner.
615      */
616     function isOwner() public view returns (bool) {
617         return _msgSender() == _owner;
618     }
619 
620     /**
621      * @dev Leaves the contract without owner. It will not be possible to call
622      * `onlyOwner` functions anymore. Can only be called by the current owner.
623      *
624      * NOTE: Renouncing ownership will leave the contract without an owner,
625      * thereby removing any functionality that is only available to the owner.
626      */
627     function renounceOwnership() public onlyOwner {
628         emit OwnershipTransferred(_owner, address(0));
629         _owner = address(0);
630     }
631 
632     /**
633      * @dev Transfers ownership of the contract to a new account (`newOwner`).
634      * Can only be called by the current owner.
635      */
636     function transferOwnership(address newOwner) public onlyOwner {
637         _transferOwnership(newOwner);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      */
643     function _transferOwnership(address newOwner) internal {
644         require(newOwner != address(0), "Ownable: new owner is the zero address");
645         emit OwnershipTransferred(_owner, newOwner);
646         _owner = newOwner;
647     }
648 }
649 
650 // File: contracts/Utils/Destructible.sol
651 
652 pragma solidity >=0.5.0;
653 
654 
655 /**
656  * @title Destructible
657  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
658  */
659 contract Destructible is Ownable {
660   /**
661    * @dev Transfers the current balance to the owner and terminates the contract.
662    */
663   function destroy() public onlyOwner {
664     selfdestruct(address(bytes20(owner())));
665   }
666 
667   function destroyAndSend(address payable _recipient) public onlyOwner {
668     selfdestruct(_recipient);
669   }
670 }
671 
672 // File: contracts/Utils/Pausable.sol
673 
674 pragma solidity >=0.4.24;
675 
676 
677 /**
678  * @title Pausable
679  * @dev Base contract which allows children to implement an emergency stop mechanism.
680  */
681 contract Pausable is Ownable {
682   event Pause();
683   event Unpause();
684 
685   bool public paused = false;
686 
687 
688   /**
689    * @dev Modifier to make a function callable only when the contract is not paused.
690    */
691   modifier whenNotPaused() {
692     require(!paused, "The contract is paused");
693     _;
694   }
695 
696   /**
697    * @dev Modifier to make a function callable only when the contract is paused.
698    */
699   modifier whenPaused() {
700     require(paused, "The contract is not paused");
701     _;
702   }
703 
704   /**
705    * @dev called by the owner to pause, triggers stopped state
706    */
707   function pause() public onlyOwner whenNotPaused {
708     paused = true;
709     emit Pause();
710   }
711 
712   /**
713    * @dev called by the owner to unpause, returns to normal state
714    */
715   function unpause() public onlyOwner whenPaused {
716     paused = false;
717     emit Unpause();
718   }
719 }
720 
721 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
722 
723 pragma solidity ^0.5.0;
724 
725 
726 
727 
728 /**
729  * @dev Implementation of the {IERC20} interface.
730  *
731  * This implementation is agnostic to the way tokens are created. This means
732  * that a supply mechanism has to be added in a derived contract using {_mint}.
733  * For a generic mechanism see {ERC20Mintable}.
734  *
735  * TIP: For a detailed writeup see our guide
736  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
737  * to implement supply mechanisms].
738  *
739  * We have followed general OpenZeppelin guidelines: functions revert instead
740  * of returning `false` on failure. This behavior is nonetheless conventional
741  * and does not conflict with the expectations of ERC20 applications.
742  *
743  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
744  * This allows applications to reconstruct the allowance for all accounts just
745  * by listening to said events. Other implementations of the EIP may not emit
746  * these events, as it isn't required by the specification.
747  *
748  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
749  * functions have been added to mitigate the well-known issues around setting
750  * allowances. See {IERC20-approve}.
751  */
752 contract ERC20 is Context, IERC20 {
753     using SafeMath for uint256;
754 
755     mapping (address => uint256) private _balances;
756 
757     mapping (address => mapping (address => uint256)) private _allowances;
758 
759     uint256 private _totalSupply;
760 
761     /**
762      * @dev See {IERC20-totalSupply}.
763      */
764     function totalSupply() public view returns (uint256) {
765         return _totalSupply;
766     }
767 
768     /**
769      * @dev See {IERC20-balanceOf}.
770      */
771     function balanceOf(address account) public view returns (uint256) {
772         return _balances[account];
773     }
774 
775     /**
776      * @dev See {IERC20-transfer}.
777      *
778      * Requirements:
779      *
780      * - `recipient` cannot be the zero address.
781      * - the caller must have a balance of at least `amount`.
782      */
783     function transfer(address recipient, uint256 amount) public returns (bool) {
784         _transfer(_msgSender(), recipient, amount);
785         return true;
786     }
787 
788     /**
789      * @dev See {IERC20-allowance}.
790      */
791     function allowance(address owner, address spender) public view returns (uint256) {
792         return _allowances[owner][spender];
793     }
794 
795     /**
796      * @dev See {IERC20-approve}.
797      *
798      * Requirements:
799      *
800      * - `spender` cannot be the zero address.
801      */
802     function approve(address spender, uint256 amount) public returns (bool) {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     /**
808      * @dev See {IERC20-transferFrom}.
809      *
810      * Emits an {Approval} event indicating the updated allowance. This is not
811      * required by the EIP. See the note at the beginning of {ERC20};
812      *
813      * Requirements:
814      * - `sender` and `recipient` cannot be the zero address.
815      * - `sender` must have a balance of at least `amount`.
816      * - the caller must have allowance for `sender`'s tokens of at least
817      * `amount`.
818      */
819     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
820         _transfer(sender, recipient, amount);
821         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
822         return true;
823     }
824 
825     /**
826      * @dev Atomically increases the allowance granted to `spender` by the caller.
827      *
828      * This is an alternative to {approve} that can be used as a mitigation for
829      * problems described in {IERC20-approve}.
830      *
831      * Emits an {Approval} event indicating the updated allowance.
832      *
833      * Requirements:
834      *
835      * - `spender` cannot be the zero address.
836      */
837     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
838         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
839         return true;
840     }
841 
842     /**
843      * @dev Atomically decreases the allowance granted to `spender` by the caller.
844      *
845      * This is an alternative to {approve} that can be used as a mitigation for
846      * problems described in {IERC20-approve}.
847      *
848      * Emits an {Approval} event indicating the updated allowance.
849      *
850      * Requirements:
851      *
852      * - `spender` cannot be the zero address.
853      * - `spender` must have allowance for the caller of at least
854      * `subtractedValue`.
855      */
856     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
857         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
858         return true;
859     }
860 
861     /**
862      * @dev Moves tokens `amount` from `sender` to `recipient`.
863      *
864      * This is internal function is equivalent to {transfer}, and can be used to
865      * e.g. implement automatic token fees, slashing mechanisms, etc.
866      *
867      * Emits a {Transfer} event.
868      *
869      * Requirements:
870      *
871      * - `sender` cannot be the zero address.
872      * - `recipient` cannot be the zero address.
873      * - `sender` must have a balance of at least `amount`.
874      */
875     function _transfer(address sender, address recipient, uint256 amount) internal {
876         require(sender != address(0), "ERC20: transfer from the zero address");
877         require(recipient != address(0), "ERC20: transfer to the zero address");
878 
879         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
880         _balances[recipient] = _balances[recipient].add(amount);
881         emit Transfer(sender, recipient, amount);
882     }
883 
884     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
885      * the total supply.
886      *
887      * Emits a {Transfer} event with `from` set to the zero address.
888      *
889      * Requirements
890      *
891      * - `to` cannot be the zero address.
892      */
893     function _mint(address account, uint256 amount) internal {
894         require(account != address(0), "ERC20: mint to the zero address");
895 
896         _totalSupply = _totalSupply.add(amount);
897         _balances[account] = _balances[account].add(amount);
898         emit Transfer(address(0), account, amount);
899     }
900 
901      /**
902      * @dev Destroys `amount` tokens from `account`, reducing the
903      * total supply.
904      *
905      * Emits a {Transfer} event with `to` set to the zero address.
906      *
907      * Requirements
908      *
909      * - `account` cannot be the zero address.
910      * - `account` must have at least `amount` tokens.
911      */
912     function _burn(address account, uint256 amount) internal {
913         require(account != address(0), "ERC20: burn from the zero address");
914 
915         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
916         _totalSupply = _totalSupply.sub(amount);
917         emit Transfer(account, address(0), amount);
918     }
919 
920     /**
921      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
922      *
923      * This is internal function is equivalent to `approve`, and can be used to
924      * e.g. set automatic allowances for certain subsystems, etc.
925      *
926      * Emits an {Approval} event.
927      *
928      * Requirements:
929      *
930      * - `owner` cannot be the zero address.
931      * - `spender` cannot be the zero address.
932      */
933     function _approve(address owner, address spender, uint256 amount) internal {
934         require(owner != address(0), "ERC20: approve from the zero address");
935         require(spender != address(0), "ERC20: approve to the zero address");
936 
937         _allowances[owner][spender] = amount;
938         emit Approval(owner, spender, amount);
939     }
940 
941     /**
942      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
943      * from the caller's allowance.
944      *
945      * See {_burn} and {_approve}.
946      */
947     function _burnFrom(address account, uint256 amount) internal {
948         _burn(account, amount);
949         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
950     }
951 }
952 
953 // File: contracts/Utils/Withdrawable.sol
954 
955 pragma solidity >=0.4.24;
956 
957 
958 
959 
960 contract Withdrawable is Ownable {
961   using SafeERC20 for ERC20;
962   address constant ETHER = address(0);
963 
964   event LogWithdrawToken(
965     address indexed _from,
966     address indexed _token,
967     uint amount
968   );
969 
970   /**
971    * @dev Withdraw asset.
972    * @param _tokenAddress Asset to be withdrawed.
973    * @return bool.
974    */
975   function withdrawToken(address _tokenAddress) public onlyOwner {
976     uint tokenBalance;
977     if (_tokenAddress == ETHER) {
978       address self = address(this); // workaround for a possible solidity bug
979       tokenBalance = self.balance;
980       msg.sender.transfer(tokenBalance);
981     } else {
982       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
983       ERC20(_tokenAddress).safeTransfer(msg.sender, tokenBalance);
984     }
985     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
986   }
987 
988 }
989 
990 // File: contracts/Utils/WithFee.sol
991 
992 pragma solidity ^0.5.0;
993 
994 
995 
996 
997 
998 contract WithFee is Ownable {
999   using SafeERC20 for IERC20;
1000   using SafeMath for uint;
1001   address payable public feeWallet;
1002   uint public storedSpread;
1003   uint constant spreadDecimals = 6;
1004   uint constant spreadUnit = 10 ** spreadDecimals;
1005 
1006   event LogFee(address token, uint amount);
1007 
1008   constructor(address payable _wallet, uint _spread) public {
1009     require(_wallet != address(0), "_wallet == address(0)");
1010     require(_spread < spreadUnit, "spread >= spreadUnit");
1011     feeWallet = _wallet;
1012     storedSpread = _spread;
1013   }
1014 
1015   function setFeeWallet(address payable _wallet) external onlyOwner {
1016     require(_wallet != address(0), "_wallet == address(0)");
1017     feeWallet = _wallet;
1018   }
1019 
1020   function setSpread(uint _spread) external onlyOwner {
1021     storedSpread = _spread;
1022   }
1023 
1024   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
1025     return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
1026   }
1027 
1028   function _payFee(address feeToken, uint fee) internal {
1029     if (fee > 0) {
1030       if (feeToken == address(0)) {
1031         feeWallet.transfer(fee);
1032       } else {
1033         IERC20(feeToken).safeTransfer(feeWallet, fee);
1034       }
1035       emit LogFee(feeToken, fee);
1036     }
1037   }
1038 
1039 }
1040 
1041 // File: contracts/Interfaces/IErc20Swap.sol
1042 
1043 pragma solidity >=0.4.0;
1044 
1045 interface IErc20Swap {
1046     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
1047     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
1048 
1049     event LogTokenSwap(
1050         address indexed _userAddress,
1051         address indexed _userSentTokenAddress,
1052         uint _userSentTokenAmount,
1053         address indexed _userReceivedTokenAddress,
1054         uint _userReceivedTokenAmount
1055     );
1056 }
1057 
1058 // File: contracts/base/NetworkBasedTokenSwap.sol
1059 
1060 pragma solidity >=0.5.0;
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 
1070 
1071 contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
1072 {
1073   using SafeMath for uint;
1074   using SafeERC20 for IERC20;
1075   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1076 
1077   mapping (address => mapping (address => uint)) spreadCustom;
1078 
1079   event UnexpectedIntialBalance(address token, uint amount);
1080 
1081   constructor(
1082     address payable _wallet,
1083     uint _spread
1084   )
1085     public WithFee(_wallet, _spread)
1086   {}
1087 
1088   function() external payable {
1089     // can receive ethers
1090   }
1091 
1092   // spread value >= spreadUnit means no fee
1093   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
1094     uint value = spread > spreadUnit ? spreadUnit : spread;
1095     spreadCustom[tokenA][tokenB] = value;
1096     spreadCustom[tokenB][tokenA] = value;
1097   }
1098 
1099   function getSpread(address tokenA, address tokenB) public view returns(uint) {
1100     uint value = spreadCustom[tokenA][tokenB];
1101     if (value == 0) return storedSpread;
1102     if (value >= spreadUnit) return 0;
1103     else return value;
1104   }
1105 
1106   // kyber network style rate
1107   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);
1108 
1109   function getRate(address src, address dest, uint256 srcAmount) external view
1110     returns(uint expectedRate, uint slippageRate)
1111   {
1112     (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
1113     uint256 spread = getSpread(src, dest);
1114     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
1115     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
1116   }
1117 
1118   function _freeUnexpectedTokens(address token) private {
1119     uint256 unexpectedBalance = token == ETHER
1120       ? _myEthBalance().sub(msg.value)
1121       : ISafeProxyERC20(token).balanceOf(address(this));
1122     if (unexpectedBalance > 0) {
1123       _transfer(token, address(bytes20(owner())), unexpectedBalance);
1124       emit UnexpectedIntialBalance(token, unexpectedBalance);
1125     }
1126   }
1127 
1128   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
1129     require(src != dest, "src == dest");
1130     require(srcAmount > 0, "srcAmount == 0");
1131 
1132     // empty unexpected initial balances
1133     _freeUnexpectedTokens(src);
1134     _freeUnexpectedTokens(dest);
1135 
1136     if (src == ETHER) {
1137       require(msg.value == srcAmount, "msg.value != srcAmount");
1138     } else {
1139       require(
1140         ISafeProxyERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
1141         "ERC20 allowance < srcAmount"
1142       );
1143       // get user's tokens
1144       IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
1145     }
1146 
1147     uint256 spread = getSpread(src, dest);
1148 
1149     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
1150     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
1151     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
1152     uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);
1153 
1154     uint256 notTraded = _myBalance(src);
1155     uint256 srcTradedAmount = srcAmount.sub(notTraded);
1156     require(srcTradedAmount > 0, "no traded tokens");
1157     require(
1158       _myBalance(dest) >= destTradedAmount,
1159       "No enough dest tokens after trade"
1160     );
1161     // pay fee and user
1162     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
1163     _transfer(dest, msg.sender, toUserAmount);
1164     // returns not traded tokens if any
1165     if (notTraded > 0) {
1166       _transfer(src, msg.sender, notTraded);
1167     }
1168 
1169     emit LogTokenSwap(
1170       msg.sender,
1171       src,
1172       srcTradedAmount,
1173       dest,
1174       toUserAmount
1175     );
1176   }
1177 
1178   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);
1179 
1180   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
1181     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
1182     toUserAmount = destTradedAmount.sub(fee);
1183     // pay fee
1184     super._payFee(token == ETHER ? address(0) : token, fee);
1185   }
1186 
1187   // workaround for a solidity bug
1188   function _myEthBalance() private view returns(uint256) {
1189     address self = address(this);
1190     return self.balance;
1191   }
1192 
1193   function _myBalance(address token) private returns(uint256) {
1194     return token == ETHER
1195       ? _myEthBalance()
1196       : ISafeProxyERC20(token).balanceOf(address(this));
1197   }
1198 
1199   function _transfer(address token, address payable recipient, uint256 amount) private {
1200     if (token == ETHER) {
1201       recipient.transfer(amount);
1202     } else {
1203       IERC20(token).safeTransfer(recipient, amount);
1204     }
1205   }
1206 
1207 }
1208 
1209 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1210 
1211 pragma solidity ^0.5.0;
1212 
1213 
1214 /**
1215  * @dev Optional functions from the ERC20 standard.
1216  */
1217 contract ERC20Detailed is IERC20 {
1218     string private _name;
1219     string private _symbol;
1220     uint8 private _decimals;
1221 
1222     /**
1223      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1224      * these values are immutable: they can only be set once during
1225      * construction.
1226      */
1227     constructor (string memory name, string memory symbol, uint8 decimals) public {
1228         _name = name;
1229         _symbol = symbol;
1230         _decimals = decimals;
1231     }
1232 
1233     /**
1234      * @dev Returns the name of the token.
1235      */
1236     function name() public view returns (string memory) {
1237         return _name;
1238     }
1239 
1240     /**
1241      * @dev Returns the symbol of the token, usually a shorter version of the
1242      * name.
1243      */
1244     function symbol() public view returns (string memory) {
1245         return _symbol;
1246     }
1247 
1248     /**
1249      * @dev Returns the number of decimals used to get its user representation.
1250      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1251      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1252      *
1253      * Tokens usually opt for a value of 18, imitating the relationship between
1254      * Ether and Wei.
1255      *
1256      * NOTE: This information is only used for _display_ purposes: it in
1257      * no way affects any of the arithmetic of the contract, including
1258      * {IERC20-balanceOf} and {IERC20-transfer}.
1259      */
1260     function decimals() public view returns (uint8) {
1261         return _decimals;
1262     }
1263 }
1264 
1265 // File: contracts/Utils/LowLevel.sol
1266 
1267 pragma solidity ^0.5.0;
1268 
1269 library LowLevel {
1270   function callContractAddr(address target, bytes memory payload) internal view
1271     returns (bool success_, address result_)
1272   {
1273     (bool success, bytes memory result) = address(target).staticcall(payload);
1274     if (success && result.length == 32) {
1275       assembly {
1276         result_ := mload(add(result,32))
1277       }
1278       success_ = true;
1279     }
1280   }
1281 
1282   function callContractUint(address target, bytes memory payload) internal view
1283     returns (bool success_, uint result_)
1284   {
1285     (bool success, bytes memory result) = address(target).staticcall(payload);
1286     if (success && result.length == 32) {
1287       assembly {
1288         result_ := mload(add(result,32))
1289       }
1290       success_ = true;
1291     }
1292   }
1293 }
1294 
1295 // File: contracts/Utils/RateNormalization.sol
1296 
1297 pragma solidity ^0.5.0;
1298 
1299 
1300 
1301 
1302 
1303 contract RateNormalization is Ownable {
1304   using SafeMath for uint;
1305 
1306   struct RateAdjustment {
1307     uint factor;
1308     bool multiply;
1309   }
1310 
1311   mapping (address => mapping(address => RateAdjustment)) public rateAdjustment;
1312   mapping (address => uint) public forcedDecimals;
1313 
1314   // return normalized rate
1315   function normalizeRate(address src, address dest, uint256 rate) public view
1316     returns(uint)
1317   {
1318     RateAdjustment memory adj = rateAdjustment[src][dest];
1319     if (adj.factor == 0) {
1320       uint srcDecimals = _getDecimals(src);
1321       uint destDecimals = _getDecimals(dest);
1322       if (srcDecimals != destDecimals) {
1323         if (srcDecimals > destDecimals) {
1324           adj.multiply = true;
1325           adj.factor = 10 ** (srcDecimals - destDecimals);
1326         } else {
1327           adj.multiply = false;
1328           adj.factor = 10 ** (destDecimals - srcDecimals);
1329         }
1330       }
1331     }
1332     if (adj.factor > 1) {
1333       rate = adj.multiply
1334       ? rate.mul(adj.factor)
1335       : rate.div(adj.factor);
1336     }
1337     return rate;
1338   }
1339 
1340   function _getDecimals(address token) internal view returns(uint) {
1341     uint forced = forcedDecimals[token];
1342     if (forced > 0) return forced;
1343     bytes memory payload = abi.encodeWithSignature("decimals()");
1344     (bool success, uint decimals) = LowLevel.callContractUint(token, payload);
1345     require(success, "the token doesn't expose the decimals number");
1346     return decimals;
1347   }
1348 
1349   function setRateAdjustmentFactor(address src, address dest, uint factor, bool multiply) public onlyOwner {
1350     rateAdjustment[src][dest] = RateAdjustment(factor, multiply);
1351     rateAdjustment[dest][src] = RateAdjustment(factor, !multiply);
1352   }
1353 
1354   function setForcedDecimals(address token, uint decimals) public onlyOwner {
1355     forcedDecimals[token] = decimals;
1356   }
1357 
1358 }
1359 
1360 // File: contracts/UniswapTokenSwap.sol
1361 
1362 pragma solidity >=0.5.0;
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 contract UniswapTokenSwap is RateNormalization, NetworkBasedTokenSwap
1373 {
1374   using SafeMath for uint;
1375   using SafeERC20 for IERC20;
1376   using SafeProxyERC20 for ISafeProxyERC20;
1377   uint constant expScale = 1e18;
1378 
1379   IUniswapFactoryInterface public uniswapFactory;
1380 
1381   mapping (address => address) public exchangeAddressCustom;
1382 
1383   constructor(
1384     address _uniswapFactory,
1385     address payable _wallet,
1386     uint _spread
1387   )
1388     public NetworkBasedTokenSwap(_wallet, _spread)
1389   {
1390     setForcedDecimals(ETHER, 18);
1391     setUniswap(_uniswapFactory);
1392   }
1393 
1394   function setUniswap(address _uniswapFactory) public onlyOwner {
1395     require(_uniswapFactory != address(0), "_uniswapFactory == address(0)");
1396     uniswapFactory = IUniswapFactoryInterface(_uniswapFactory);
1397   }
1398 
1399   function setExchangeCustom(address token, address exchange) public onlyOwner {
1400     require(token != address(0), "exchange == address(0)");
1401     exchangeAddressCustom[token] = exchange;
1402   }
1403 
1404   function _getExchange(address token) private view returns(IUniswapExchangeInterface exchange) {
1405     address exchangeAddress = exchangeAddressCustom[token];
1406     exchange = exchangeAddress == address(0) ?
1407       uniswapFactory.getExchange(token) : IUniswapExchangeInterface(exchangeAddress);
1408   }
1409 
1410   function _getUniswapRate(address src, address dest, uint srcAmount) private view returns(uint rate, uint destAmount) {
1411     uint inputAmountB;
1412     if (src != ETHER) {
1413       IUniswapExchangeInterface exchangeA = _getExchange(src);
1414       inputAmountB = exchangeA.getTokenToEthInputPrice(srcAmount);
1415     } else {
1416       inputAmountB = srcAmount;
1417     }
1418     if (dest != ETHER) {
1419       IUniswapExchangeInterface exchangeB = _getExchange(dest);
1420       destAmount = exchangeB.getEthToTokenInputPrice(inputAmountB);
1421     } else {
1422       destAmount = inputAmountB;
1423     }
1424     rate = destAmount.mul(expScale).div(srcAmount);
1425   }
1426 
1427   function _calcRate(uint srcAmount, uint destAmount) private pure returns(uint) {
1428     return destAmount.mul(expScale).div(srcAmount);
1429   }
1430 
1431   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view
1432     returns(uint expectedRate, uint slippageRate)
1433   {
1434     (uint rate, ) = _getUniswapRate(src, dest, srcAmount);
1435     uint normalizedRate = normalizeRate(src, dest, rate);
1436     return (normalizedRate, normalizedRate);
1437   }
1438 
1439   function _approveWithReset(address token, address spender, uint amount) private {
1440     if (ISafeProxyERC20(token).allowance(address(this), spender) > 0) {
1441       ISafeProxyERC20(token).safeApprove(spender, 0);
1442     }
1443     ISafeProxyERC20(token).safeApprove(spender, amount);
1444   }
1445 
1446   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate)
1447     internal returns(uint256)
1448   {
1449     (uint rate, uint destAmount) = _getUniswapRate(src, dest, srcAmount);
1450     uint toTradeAmount = destAmount > maxDestAmount
1451       ? maxDestAmount.mul(expScale).div(rate)
1452       : srcAmount;
1453 
1454     uint tradedEthers;
1455     if (src != ETHER) {
1456       IUniswapExchangeInterface exchangeA = _getExchange(src);
1457       _approveWithReset(src, address(exchangeA), toTradeAmount);
1458       tradedEthers = exchangeA.tokenToEthSwapInput(toTradeAmount, 1, block.timestamp);
1459     } else {
1460       tradedEthers = toTradeAmount;
1461     }
1462 
1463     uint finalDestAmount;
1464     if (dest != ETHER) {
1465       IUniswapExchangeInterface exchangeB = _getExchange(dest);
1466       finalDestAmount = exchangeB.ethToTokenSwapInput.value(tradedEthers)(1, block.timestamp);
1467     } else {
1468       finalDestAmount = tradedEthers;
1469     }
1470     require(normalizeRate(src, dest, _calcRate(toTradeAmount, finalDestAmount)) >= minConversionRate, "cannot satisfy minConversionRate");
1471     return finalDestAmount;
1472   }
1473 
1474 }