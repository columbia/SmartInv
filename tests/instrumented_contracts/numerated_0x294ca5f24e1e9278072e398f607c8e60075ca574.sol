1 pragma solidity =0.6.6;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 // 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 // 
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure (when the token
377  * contract returns false). Tokens that return no value (and instead revert or
378  * throw on failure) are also supported, non-reverting calls are assumed to be
379  * successful.
380  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384     using SafeMath for uint256;
385     using Address for address;
386 
387     function safeTransfer(IERC20 token, address to, uint256 value) internal {
388         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
389     }
390 
391     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
393     }
394 
395     /**
396      * @dev Deprecated. This function has issues similar to the ones found in
397      * {IERC20-approve}, and its usage is discouraged.
398      *
399      * Whenever possible, use {safeIncreaseAllowance} and
400      * {safeDecreaseAllowance} instead.
401      */
402     function safeApprove(IERC20 token, address spender, uint256 value) internal {
403         // safeApprove should only be called when setting an initial allowance,
404         // or when resetting it to zero. To increase and decrease it, use
405         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
406         // solhint-disable-next-line max-line-length
407         require((value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
411     }
412 
413     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
414         uint256 newAllowance = token.allowance(address(this), spender).add(value);
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
416     }
417 
418     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     /**
424      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
425      * on the return value: the return value is optional (but if data is returned, it must not be false).
426      * @param token The token targeted by the call.
427      * @param data The call data (encoded using abi.encode or one of its variants).
428      */
429     function _callOptionalReturn(IERC20 token, bytes memory data) private {
430         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
431         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
432         // the target address contains contract code and also asserts for success in the low-level call.
433 
434         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
435         if (returndata.length > 0) { // Return data is optional
436             // solhint-disable-next-line max-line-length
437             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
438         }
439     }
440 }
441 
442 // 
443 /*
444  * @dev Provides information about the current execution context, including the
445  * sender of the transaction and its data. While these are generally available
446  * via msg.sender and msg.data, they should not be accessed in such a direct
447  * manner, since when dealing with GSN meta-transactions the account sending and
448  * paying for execution may not be the actual sender (as far as an application
449  * is concerned).
450  *
451  * This contract is only required for intermediate, library-like contracts.
452  */
453 abstract contract Context {
454     function _msgSender() internal view virtual returns (address payable) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view virtual returns (bytes memory) {
459         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
460         return msg.data;
461     }
462 }
463 
464 // 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor () internal {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(_owner == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(newOwner != address(0), "Ownable: new owner is the zero address");
524         emit OwnershipTransferred(_owner, newOwner);
525         _owner = newOwner;
526     }
527 }
528 
529 interface IUniswapV2Router01 {
530     function factory() external pure returns (address);
531     function WETH() external pure returns (address);
532 
533     function addLiquidity(
534         address tokenA,
535         address tokenB,
536         uint amountADesired,
537         uint amountBDesired,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB, uint liquidity);
543     function addLiquidityETH(
544         address token,
545         uint amountTokenDesired,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
551     function removeLiquidity(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB);
560     function removeLiquidityETH(
561         address token,
562         uint liquidity,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountToken, uint amountETH);
568     function removeLiquidityWithPermit(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline,
576         bool approveMax, uint8 v, bytes32 r, bytes32 s
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETHWithPermit(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountToken, uint amountETH);
587     function swapExactTokensForTokens(
588         uint amountIn,
589         uint amountOutMin,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external returns (uint[] memory amounts);
594     function swapTokensForExactTokens(
595         uint amountOut,
596         uint amountInMax,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
602         external
603         payable
604         returns (uint[] memory amounts);
605     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
606         external
607         returns (uint[] memory amounts);
608     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
609         external
610         returns (uint[] memory amounts);
611     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615 
616     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
617     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
618     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
619     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
620     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
621 }
622 
623 interface IUniswapV2Router02 is IUniswapV2Router01 {
624     function removeLiquidityETHSupportingFeeOnTransferTokens(
625         address token,
626         uint liquidity,
627         uint amountTokenMin,
628         uint amountETHMin,
629         address to,
630         uint deadline
631     ) external returns (uint amountETH);
632     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline,
639         bool approveMax, uint8 v, bytes32 r, bytes32 s
640     ) external returns (uint amountETH);
641 
642     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
643         uint amountIn,
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external;
649     function swapExactETHForTokensSupportingFeeOnTransferTokens(
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external payable;
655     function swapExactTokensForETHSupportingFeeOnTransferTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external;
662 }
663 
664 interface IChadsToken {
665     function unpause() external; 
666     function initializeTwap() external;
667 }
668 
669 // @&#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
670 // @&@@%&@@&&&&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
671 // @@&@(....,*#&@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
672 // @@@@&/..........*(%@@@&%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
673 // @@@&&%*..............,*(#%&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
674 // @@@@&@#......................*#&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
675 // @@@@&%@(..........................,(&@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
676 // @@@@@&&@(,.............................*/#@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
677 // @@@@@@@&@(,.................................*#&@@%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
678 // @@@@@@@&&@#,....................................,/%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
679 // @@@@@@@@@&@#,.......................................,*#&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
680 // @@@@@@@@@@&@(............................................,(&@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
681 // @@@@@@@@@@@@@/...............................................,/#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
682 // @@@@@@@@@@@@&@(..................................................*#%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
683 // @@@@@@@@@@@@@&@/......................................................,/&@&@@@@@@@@@@@@@@@@@@@@@@@@@
684 // @@@@@@@@@@@@@%&@/.........................................................,/#%%%&@@@@@@@@@@@@@@@@@@@
685 // @@@@@@@@@@@@@@%@@(......................................,**/((((((((((((/*,....*(%&@@@@@@@@@@@@@@@@@
686 // @@@@@@@@@@@@@@@#@@*............................,,/%&&@@@@&#(/*,,,,,,,,,,/#&@@%((/*%@@#@@@@@@@@@@@@@@
687 // @@@@@@@@@@@@@@@&%@#.................,,/#%&@@@@@&%#/*,,,.,,,,,,,,,,,,,,,,,,,,.,,*(%&@@@@@&@@@@@@@@@@@
688 // @@@@@@@@@@@@@@@@@%@*.........*(#&@@@&%#/*,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..*(&@@%@@@@@@@@@
689 // @@@@@@@@@@@@@@@@@&&@*....(&@@@%*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@&@@@@@@@@
690 // @@@@@@@@@@@@@@@@@@%@@@@@@@@(,,,,,,,,,,,.....,,,,...,,,,,,,,,,,,,,,,,,,,,,,,(&/.,,,,,,,,,,,*&&&@@@@@@
691 // @@@@@@@@@@@@@@@@@@@@@@@@@&&@(,,,,,*(%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,*%@(,,,,,,,,,,,,,,*#@@@@@@@
692 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%@@@@@@&#/*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@(,,,,,,,,,,,,,,,,*%&@@@@@
693 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,,,./%@@&%/,,,,,,,,,,,,,,,,,,,,,,,,,,.*(#@@(,,,,,,,,,,,,,,,,,,*%@@@@@
694 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,*&@@@%#######(*,,,,,,,,,,,,,,,,,,,,.(@%/*.,,,,,,,,,,,,,,,,,,,.(@%@@@
695 // @@@@@@@@@@@@@@@@@@@@@@@@@@&@&*/%@@@@@%/%@@@@%(&&&@@&#,,,,,,,,,,,,,,.&@*,,,,,,,,,,,,,,,,,,,,,,.*%@&@@
696 // @@@@@@@@@@@@@@@@@@@@@@@@@&@%*.*%@&,,#@%//(##(#&/.*#@&*,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
697 // @@@@@@@@@@@@@@@@@@@@@@@@@@%*,,,.*%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
698 // @@@@@@@@@@@@@@@@@@@@@@%&@#,,,,,,,,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
699 // @@@@@@@@@@@@@@@@@@@@@&@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
700 // @@@@@@@@@@@@@@@@@@@&@&*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%@@@@@&/,,,,,,,,,,,,,,.(&&@@
701 // @@@@@@@@@@@@@@@@@#@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*&@%/,,..,*%@#,,,,,,,,,,,,.(&&@@
702 // @@@@@@@@@@@@@@@&%@%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,./@#.,#&%(,.,%@*,,,,,,,,,,,,(@&@@
703 // @@@@@@@@@@@@@@&&@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*@&*/@(*&%*,#@*,,,,,,,,,,.*&&@@@
704 // @@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#%/.,*&%*,#@*,,,,,,,,,,*%&&@@@
705 // @@@@@@@@@@&&@%/,,,,,,,,(%&&%(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/*,,,,,,,,*/*/&%*,#@*,,,,,,,,,,(@&@@@@
706 // @@@@@@@@@%&@(,,,,,,,,/&%*.,#@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@/,,,,,*&@@@#,,,#@*,,,,,,,,,(@@@@@@@
707 // @@@@@@@@&&%,.,,,,,,,,,,,,,,,(@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#@%,,,,*(/.,,,./&&*,,,,,,,*%@@@@@@@@
708 // @@@@@@@@@&@@(*,,,,,,,*#&&&(,,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@%.,,,,,,/%&&@&/,,,,,,,*&@((@@@@@@
709 // @@@@@@@@@@@@%&@@@@@@@@&%&@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@/.,,,,,,....,,,,,,,.(@%*.*%@@&&%
710 // @@@@@@@@@@@@@@@@@@@@@@@&@&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@(.,,,,,,,*,,,,,,,./#/,,.*%@@@@@
711 // @@@@@@@@@@@@@@@@@@@@&&@@@@&#*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(@#.,,,,,,/&%*,,,,,,,,,,,,.(@@@@@
712 // @@@@@@@@@@@@@@@@@%@@%*,,,,,*/,,(%(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@#.,,,,,,,(@#,,,,,,,,,,,,.*%&@@@
713 // @@@@@@@@@@@@@@@@%@&,,,,,,,,,,,,,#@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,.*(&@#.,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
714 // @@@@@@@@@@@@@@@@#@&##&@@@@@@@@@@&&@%,,,,,,,,,,,,,,,,,,,,,,,,,*(&@%*,,,,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
715 // @@@@@@@@@@@@@@@@@@%@@%*,,,,,,,,,,,(/,,,,,,,,,,,,,,,,,,,,,,*%@%/,,,,,,,,,,,,,,./&#,,,,,,,,,,,,.*%&&@@
716 // @@@@@@@@@@@@@@@@@@&@@@#*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@&(,,,,,,,,,,,,,,,,,,/&#,,,,,,,,,,,,,,(&&@@
717 // @@@@@@@@@@@@@@@@@@@@&@@@&@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,,,#@(,,,,,,,,,,,,,.(&&@@
718 // @@@@@@@@@@@@@@@@@@@@@&&@(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@%*,,,,,,,,,,,,,.(&&@@
719 // @@@@@@@@@@@@@@@@@@@@@&&&/.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,*(#&&#*.,,,,,,,,,,,,,,.(&&@@
720 // @@@@@@@@@@@@@@@@@&%@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@@@&(*,.,,,,,,,,,,,,,,,,,.(@%@@
721 // @@@@@@@@@@@@@@&@@%/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/#&@@@&#/*,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
722 // @@@@@@@@@@@@@%@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/(%@@@%(*,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
723 // @@@@@@@@@@@@&@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,/%&@@@@&/*,,.,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,*%&@@
724 // @@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,*#&@@&%%@@@@@(.,,,,,,,,,,,,,,,,,,,,(@(.,,,,,,,,,,,,,,,,*%@&@
725 // @@@@@@@@@@@@@%&@&%/,,,,,,,,,,,,,,,,,,*#@@&@@@@@@@@@@@%,,,,,,,,,,,,,,,,,,,,*%@/.,,,,,,,,,,,,,,,,.(&&@
726 // @@@@@@@@@@@@@@@@@&%@@%(///*,......*%@@&&@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,/@&/,,,,,,,,,,,,,,,,,,.(@&@
727 // @@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&%@@@@@@@@@@@@@@@@@&&&(,,,,,,,,,,,,,,,(@%*,,,,,,,,,,,,,,,,,,,.*%&@
728 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@%,,,,,,,,,,,,#@&/.,,,,,,,,,,,,,,,,,.*//(&&@
729 // $CHADS Liquidity Pool / 28M tokens up for grabs + 20M for uniswap (chads.vc)
730 // @dev airblush@protonmail.com (virgin@protonmail.com was taken)
731 contract ChadsLiquidityPool is Ownable {
732     using SafeMath for uint256;
733     using SafeERC20 for IERC20;
734 
735     uint256 public constant INDIVIDUAL_CAP = 1.5 ether;
736 
737     uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
738 
739     uint256 public immutable hardCap;
740 
741     uint256 public immutable startTime;
742 
743     uint256 public immutable endTime;
744 
745     uint256 public immutable tokensPerEth;
746 
747     mapping(address => uint256) public chadlists;
748 
749     mapping(address => uint256) public contributions;
750 
751     uint256 public weiRaised;
752 
753     IERC20 public token;
754 
755     IUniswapV2Router02 internal uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
756 
757     event TokenPurchase(address indexed beneficiary, uint256 weiAmount, uint256 tokenAmount);
758 
759     constructor(
760         uint256 _hardCap,
761         uint256 _tokensPerEth,
762         uint256 _startTime,
763         uint256 _duration
764     )
765     Ownable()
766     public 
767     {
768         hardCap = _hardCap;
769         tokensPerEth = _tokensPerEth;
770         startTime = _startTime;
771         endTime = _startTime.add(_duration);
772     }
773 
774     receive() payable external {
775         _buyTokens(msg.sender);
776     }
777 
778     function setToken(IERC20 _token) external onlyOwner {
779         token = _token;
780     }
781 
782     function addChadlists(address[] calldata accounts) external onlyOwner {
783         for (uint256 i = 0; i < accounts.length; i++) {
784             chadlists[accounts[i]] = INDIVIDUAL_CAP;
785         }
786     }
787 
788     function addAndLockLiquidity() external onlyOwner {
789         require(hasEnded(), "ChadsLiquidityPool: can only send liquidity once hardcap is reached");
790 
791         uint256 amountEthForUniswap = address(this).balance;
792         uint256 amountTokensForUniswap = token.balanceOf(address(this));
793 
794         IChadsToken(address(token)).unpause();
795         token.approve(address(uniswapRouter), amountTokensForUniswap);
796         uniswapRouter.addLiquidityETH
797         { value: amountEthForUniswap }
798         (
799             address(token),
800             amountTokensForUniswap,
801             amountTokensForUniswap,
802             amountEthForUniswap,
803             address(0x0),
804             now
805         );
806         IChadsToken(address(token)).initializeTwap();
807     }
808 
809     function _buyTokens(address beneficiary) internal {
810         uint256 weiToHardcap = hardCap.sub(weiRaised);
811         uint256 weiAmount = weiToHardcap < msg.value ? weiToHardcap : msg.value;
812 
813         _buyTokens(beneficiary, weiAmount);
814 
815         uint256 refund = msg.value.sub(weiAmount);
816         if (refund > 0) {
817             payable(beneficiary).transfer(refund);
818         }
819     }
820 
821     function _buyTokens(address beneficiary, uint256 weiAmount) internal {
822         _validatePurchase(beneficiary, weiAmount);
823 
824         // Update internal state
825         weiRaised = weiRaised.add(weiAmount);
826         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
827 
828         // Transfer tokens
829         uint256 tokenAmount = _getTokenAmount(weiAmount);
830         token.safeTransfer(beneficiary, tokenAmount);
831 
832         emit TokenPurchase(beneficiary, weiAmount, tokenAmount);
833     }
834 
835     function _validatePurchase(address beneficiary, uint256 weiAmount) internal view {
836         require(beneficiary != address(0), "ChadsLiquidityPool: beneficiary is the zero address");
837         require(isOpen(), "ChadsLiquidityPool: sale did not start yet.");
838         require(!hasEnded(), "ChadsLiquidityPool: sale is over.");
839         require(weiAmount >= MIN_CONTRIBUTION, "ChadsLiquidityPool: weiAmount is smaller than min contribution.");
840         require(!isWithinCappedSaleWindow() || (contributions[beneficiary].add(weiAmount) <= chadlists[beneficiary]),
841             "ChadsLiquidityPool: individual cap exceeded or not whitelisted"
842         );
843         this;
844     }
845 
846     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
847         return weiAmount.mul(tokensPerEth);
848     }
849 
850     function isOpen() public view returns (bool) {
851         return now >= startTime;
852     }
853 
854     function isWithinCappedSaleWindow() public view returns (bool) {
855         return now >= startTime && now <= (startTime + 6 hours);
856     }
857 
858     function hasEnded() public view returns (bool) {
859         return now >= endTime || weiRaised >= hardCap;
860     }
861 }