1 pragma solidity ^0.6.0;
2 
3 
4 // 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 // 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) { // Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 // 
445 /*
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with GSN meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address payable) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes memory) {
461         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
462         return msg.data;
463     }
464 }
465 
466 // 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor () internal {
488         address msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(_owner == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         emit OwnershipTransferred(_owner, address(0));
517         _owner = address(0);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 }
530 
531 interface IUniswapV2Router01 {
532     function factory() external pure returns (address);
533     function WETH() external pure returns (address);
534 
535     function addLiquidity(
536         address tokenA,
537         address tokenB,
538         uint amountADesired,
539         uint amountBDesired,
540         uint amountAMin,
541         uint amountBMin,
542         address to,
543         uint deadline
544     ) external returns (uint amountA, uint amountB, uint liquidity);
545     function addLiquidityETH(
546         address token,
547         uint amountTokenDesired,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline
552     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
553     function removeLiquidity(
554         address tokenA,
555         address tokenB,
556         uint liquidity,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountA, uint amountB);
562     function removeLiquidityETH(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountToken, uint amountETH);
570     function removeLiquidityWithPermit(
571         address tokenA,
572         address tokenB,
573         uint liquidity,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline,
578         bool approveMax, uint8 v, bytes32 r, bytes32 s
579     ) external returns (uint amountA, uint amountB);
580     function removeLiquidityETHWithPermit(
581         address token,
582         uint liquidity,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline,
587         bool approveMax, uint8 v, bytes32 r, bytes32 s
588     ) external returns (uint amountToken, uint amountETH);
589     function swapExactTokensForTokens(
590         uint amountIn,
591         uint amountOutMin,
592         address[] calldata path,
593         address to,
594         uint deadline
595     ) external returns (uint[] memory amounts);
596     function swapTokensForExactTokens(
597         uint amountOut,
598         uint amountInMax,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external returns (uint[] memory amounts);
603     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
604         external
605         payable
606         returns (uint[] memory amounts);
607     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
608         external
609         returns (uint[] memory amounts);
610     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
611         external
612         returns (uint[] memory amounts);
613     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
614         external
615         payable
616         returns (uint[] memory amounts);
617 
618     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
619     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
620     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
621     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
622     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
623 }
624 
625 interface IUniswapV2Router02 is IUniswapV2Router01 {
626     function removeLiquidityETHSupportingFeeOnTransferTokens(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline
633     ) external returns (uint amountETH);
634     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
635         address token,
636         uint liquidity,
637         uint amountTokenMin,
638         uint amountETHMin,
639         address to,
640         uint deadline,
641         bool approveMax, uint8 v, bytes32 r, bytes32 s
642     ) external returns (uint amountETH);
643 
644     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
645         uint amountIn,
646         uint amountOutMin,
647         address[] calldata path,
648         address to,
649         uint deadline
650     ) external;
651     function swapExactETHForTokensSupportingFeeOnTransferTokens(
652         uint amountOutMin,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external payable;
657     function swapExactTokensForETHSupportingFeeOnTransferTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external;
664 }
665 
666 // 
667 interface Pauseable {
668     function unpause() external; 
669 }
670 
671 /**
672  * @title TendiesCrowdsale
673  * @dev Crowdsale contract for $TEND. 
674  *      Contributions limited to whitelisted addresses during the first hour (1.5 ETH for Round 1, 3 ETH for Round 2), fcfs afterwards.
675  *      1 ETH = 20000 TEND (during the entire sale)
676  *      Hardcap = 150 ETH
677  *      Once hardcap is reached, all liquidity is added to Uniswap and locked automatically, 0% risk of rug pull.
678  *
679  * @author soulbar@protonmail.com
680  */
681 contract TendiesCrowdsale is Ownable {
682     using SafeMath for uint256;
683     using SafeERC20 for IERC20;
684 
685     // Caps
686     uint256 public constant ROUND_1_CAP = 1.5 ether;
687     uint256 public constant ROUND_2_CAP = 3 ether;
688     uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
689     uint256 public constant HARDCAP = 150 ether;
690 
691     // Start time (07/28/2020 @ 2:00pm (UTC))
692     uint256 public constant CROWDSALE_START_TIME = 1595944800;
693 
694     // End time
695     uint256 public constant CROWDSALE_END_TIME = CROWDSALE_START_TIME + 1 days;
696 
697     // 1 ETH = 20000 TEND
698     uint256 public constant TEND_PER_ETH = 20000;
699 
700     // Round 1 whitelist
701     mapping(address => uint256) public whitelistCapsRound1;
702 
703     // Round 2 whitelist
704     mapping(address => uint256) public whitelistCapsRound2;
705 
706     // Contributions state
707     mapping(address => uint256) public contributions;
708 
709     uint256 public weiRaised;
710 
711     bool public liquidityLocked = false;
712 
713     IERC20 public tendToken;
714 
715     IUniswapV2Router02 internal uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
716 
717     event TokenPurchase(address indexed beneficiary, uint256 weiAmount, uint256 tokenAmount);
718 
719     constructor(IERC20 _tendToken) Ownable() public {
720         tendToken = _tendToken;
721     }
722 
723     receive() payable external {
724         // Prevent owner from buying tokens, but allow them to add pre-sale ETH to the contract for Uniswap liquidity
725         if (owner() != msg.sender) {
726             _buyTokens(msg.sender);
727         }
728     }
729 
730     function _buyTokens(address beneficiary) internal {
731         uint256 weiToHardcap = HARDCAP.sub(weiRaised);
732         uint256 weiAmount = weiToHardcap < msg.value ? weiToHardcap : msg.value;
733 
734         _buyTokens(beneficiary, weiAmount);
735 
736         uint256 refund = msg.value.sub(weiAmount);
737         if (refund > 0) {
738             payable(beneficiary).transfer(refund);
739         }
740     }
741 
742     function _buyTokens(address beneficiary, uint256 weiAmount) internal {
743         _validatePurchase(beneficiary, weiAmount);
744 
745         // Update internal state
746         weiRaised = weiRaised.add(weiAmount);
747         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
748 
749         // Transfer tokens
750         uint256 tokenAmount = _getTokenAmount(weiAmount);
751         tendToken.safeTransfer(beneficiary, tokenAmount);
752 
753         emit TokenPurchase(beneficiary, weiAmount, tokenAmount);
754     }
755 
756     function _validatePurchase(address beneficiary, uint256 weiAmount) internal view {
757         require(beneficiary != address(0), "TendiesCrowdsale: beneficiary is the zero address");
758         require(isOpen(), "TendiesCrowdsale: sale did not start yet.");
759         require(!hasEnded(), "TendiesCrowdsale: sale is over.");
760         require(weiAmount >= MIN_CONTRIBUTION, "TendiesCrowdsale: weiAmount is smaller than min contribution.");
761         require(!isWithinCappedSaleWindow() ||
762             (contributions[beneficiary].add(weiAmount) <= whitelistCapsRound1[beneficiary] || 
763             contributions[beneficiary].add(weiAmount) <= whitelistCapsRound2[beneficiary]),
764             "TendiesCrowdsale: individual cap exceeded or not whitelisted"
765         );
766         this; // solidity being solidity doing solidity things, few understand this.
767     }
768 
769     function _getTokenAmount(uint256 weiAmount) internal pure returns (uint256) {
770         return weiAmount.mul(TEND_PER_ETH);
771     }
772 
773     function isOpen() public view returns (bool) {
774         return now >= CROWDSALE_START_TIME;
775     }
776 
777     function isWithinCappedSaleWindow() public view returns (bool) {
778         return now >= CROWDSALE_START_TIME && now <= (CROWDSALE_START_TIME + 1 hours);
779     }
780 
781     function hasEnded() public view returns (bool) {
782         return now >= CROWDSALE_END_TIME || weiRaised >= HARDCAP;
783     }
784 
785     // Whitelist
786 
787     function setWhitelist1(address[] calldata accounts) external onlyOwner {
788         for (uint256 i = 0; i < accounts.length; i++) {
789             whitelistCapsRound1[accounts[i]] = ROUND_1_CAP;
790         }
791     }
792 
793     function setWhitelist2(address[] calldata accounts) external onlyOwner {
794         for (uint256 i = 0; i < accounts.length; i++) {
795             whitelistCapsRound2[accounts[i]] = ROUND_2_CAP;
796         }
797     }
798 
799     // Uniswap
800 
801     function addAndLockLiquidity() external {
802         require(hasEnded(), "TendiesCrowdsale: can only send liquidity once hardcap is reached");
803 
804         uint256 amountEthForUniswap = address(this).balance;
805         uint256 amountTokensForUniswap = tendToken.balanceOf(address(this));
806 
807         // Unpause transfers forever
808         Pauseable(address(tendToken)).unpause();
809         // Send the entire balance and all tokens in the contract to Uniswap LP
810         tendToken.approve(address(uniswapRouter), amountTokensForUniswap);
811         uniswapRouter.addLiquidityETH
812         { value: amountEthForUniswap }
813         (
814             address(tendToken),
815             amountTokensForUniswap,
816             amountTokensForUniswap,
817             amountEthForUniswap,
818             address(0), // burn address
819             now
820         );
821         liquidityLocked = true;
822     }
823 }