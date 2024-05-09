1 pragma solidity >=0.6.0;
2 
3 interface IPoolFactory {
4     function createNewPool(
5         address _rewardToken,
6         address _rover,
7         uint256 _duration,
8         address _distributor
9     ) external returns (address);
10 }
11 
12 
13 pragma solidity >=0.6.0;
14 
15 interface IBasedGod {
16     function getSellingSchedule() external view returns (uint256);
17     function weth() external view returns (address);
18     function susd() external view returns (address);
19     function based() external view returns (address);
20     function uniswapRouter() external view returns (address);
21     function moonbase() external view returns (address);
22     function deployer() external view returns (address);
23     function getRovers() external view returns (address[] memory);
24     function getTokenRovers(address token) external view returns (address[] memory);
25 }
26 
27 
28 
29 pragma solidity ^0.6.0;
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      *
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      *
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 
188 
189 pragma solidity ^0.6.0;
190 
191 /**
192  * @dev Interface of the ERC20 standard as defined in the EIP.
193  */
194 interface IERC20 {
195     /**
196      * @dev Returns the amount of tokens in existence.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns the amount of tokens owned by `account`.
202      */
203     function balanceOf(address account) external view returns (uint256);
204 
205     /**
206      * @dev Moves `amount` tokens from the caller's account to `recipient`.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transfer(address recipient, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Returns the remaining number of tokens that `spender` will be
216      * allowed to spend on behalf of `owner` through {transferFrom}. This is
217      * zero by default.
218      *
219      * This value changes when {approve} or {transferFrom} are called.
220      */
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     /**
224      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * IMPORTANT: Beware that changing an allowance with this method brings the risk
229      * that someone may use both the old and the new allowance by unfortunate
230      * transaction ordering. One possible solution to mitigate this race
231      * condition is to first reduce the spender's allowance to 0 and set the
232      * desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address spender, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Moves `amount` tokens from `sender` to `recipient` using the
241      * allowance mechanism. `amount` is then deducted from the caller's
242      * allowance.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Emitted when `value` tokens are moved from one account (`from`) to
252      * another (`to`).
253      *
254      * Note that `value` may be zero.
255      */
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 
258     /**
259      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
260      * a call to {approve}. `value` is the new allowance.
261      */
262     event Approval(address indexed owner, address indexed spender, uint256 value);
263 }
264 
265 
266 
267 pragma solidity ^0.6.2;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 
408 
409 pragma solidity ^0.6.0;
410 
411 
412 
413 
414 /**
415  * @title SafeERC20
416  * @dev Wrappers around ERC20 operations that throw on failure (when the token
417  * contract returns false). Tokens that return no value (and instead revert or
418  * throw on failure) are also supported, non-reverting calls are assumed to be
419  * successful.
420  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
422  */
423 library SafeERC20 {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     function safeTransfer(IERC20 token, address to, uint256 value) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
433     }
434 
435     /**
436      * @dev Deprecated. This function has issues similar to the ones found in
437      * {IERC20-approve}, and its usage is discouraged.
438      *
439      * Whenever possible, use {safeIncreaseAllowance} and
440      * {safeDecreaseAllowance} instead.
441      */
442     function safeApprove(IERC20 token, address spender, uint256 value) internal {
443         // safeApprove should only be called when setting an initial allowance,
444         // or when resetting it to zero. To increase and decrease it, use
445         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
446         // solhint-disable-next-line max-line-length
447         require((value == 0) || (token.allowance(address(this), spender) == 0),
448             "SafeERC20: approve from non-zero to non-zero allowance"
449         );
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
451     }
452 
453     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).add(value);
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     /**
464      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
465      * on the return value: the return value is optional (but if data is returned, it must not be false).
466      * @param token The token targeted by the call.
467      * @param data The call data (encoded using abi.encode or one of its variants).
468      */
469     function _callOptionalReturn(IERC20 token, bytes memory data) private {
470         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
471         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
472         // the target address contains contract code and also asserts for success in the low-level call.
473 
474         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
475         if (returndata.length > 0) { // Return data is optional
476             // solhint-disable-next-line max-line-length
477             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
478         }
479     }
480 }
481 
482 
483 
484 pragma solidity ^0.6.0;
485 
486 /*
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with GSN meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address payable) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes memory) {
502         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
503         return msg.data;
504     }
505 }
506 
507 
508 
509 pragma solidity ^0.6.0;
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor () internal {
532         address msgSender = _msgSender();
533         _owner = msgSender;
534         emit OwnershipTransferred(address(0), msgSender);
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if called by any account other than the owner.
546      */
547     modifier onlyOwner() {
548         require(_owner == _msgSender(), "Ownable: caller is not the owner");
549         _;
550     }
551 
552     /**
553      * @dev Leaves the contract without owner. It will not be possible to call
554      * `onlyOwner` functions anymore. Can only be called by the current owner.
555      *
556      * NOTE: Renouncing ownership will leave the contract without an owner,
557      * thereby removing any functionality that is only available to the owner.
558      */
559     function renounceOwnership() public virtual onlyOwner {
560         emit OwnershipTransferred(_owner, address(0));
561         _owner = address(0);
562     }
563 
564     /**
565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
566      * Can only be called by the current owner.
567      */
568     function transferOwnership(address newOwner) public virtual onlyOwner {
569         require(newOwner != address(0), "Ownable: new owner is the zero address");
570         emit OwnershipTransferred(_owner, newOwner);
571         _owner = newOwner;
572     }
573 }
574 
575 
576 pragma solidity >=0.6.2;
577 
578 interface IUniswapV2Router01 {
579     function factory() external pure returns (address);
580     function WETH() external pure returns (address);
581 
582     function addLiquidity(
583         address tokenA,
584         address tokenB,
585         uint amountADesired,
586         uint amountBDesired,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountA, uint amountB, uint liquidity);
592     function addLiquidityETH(
593         address token,
594         uint amountTokenDesired,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
600     function removeLiquidity(
601         address tokenA,
602         address tokenB,
603         uint liquidity,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline
608     ) external returns (uint amountA, uint amountB);
609     function removeLiquidityETH(
610         address token,
611         uint liquidity,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline
616     ) external returns (uint amountToken, uint amountETH);
617     function removeLiquidityWithPermit(
618         address tokenA,
619         address tokenB,
620         uint liquidity,
621         uint amountAMin,
622         uint amountBMin,
623         address to,
624         uint deadline,
625         bool approveMax, uint8 v, bytes32 r, bytes32 s
626     ) external returns (uint amountA, uint amountB);
627     function removeLiquidityETHWithPermit(
628         address token,
629         uint liquidity,
630         uint amountTokenMin,
631         uint amountETHMin,
632         address to,
633         uint deadline,
634         bool approveMax, uint8 v, bytes32 r, bytes32 s
635     ) external returns (uint amountToken, uint amountETH);
636     function swapExactTokensForTokens(
637         uint amountIn,
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external returns (uint[] memory amounts);
643     function swapTokensForExactTokens(
644         uint amountOut,
645         uint amountInMax,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external returns (uint[] memory amounts);
650     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
651         external
652         payable
653         returns (uint[] memory amounts);
654     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
655         external
656         returns (uint[] memory amounts);
657     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
658         external
659         returns (uint[] memory amounts);
660     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
661         external
662         payable
663         returns (uint[] memory amounts);
664 
665     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
666     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
667     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
668     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
669     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
670 }
671 
672 
673 pragma solidity >=0.6.2;
674 
675 
676 interface IUniswapV2Router02 is IUniswapV2Router01 {
677     function removeLiquidityETHSupportingFeeOnTransferTokens(
678         address token,
679         uint liquidity,
680         uint amountTokenMin,
681         uint amountETHMin,
682         address to,
683         uint deadline
684     ) external returns (uint amountETH);
685     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
686         address token,
687         uint liquidity,
688         uint amountTokenMin,
689         uint amountETHMin,
690         address to,
691         uint deadline,
692         bool approveMax, uint8 v, bytes32 r, bytes32 s
693     ) external returns (uint amountETH);
694 
695     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external;
702     function swapExactETHForTokensSupportingFeeOnTransferTokens(
703         uint amountOutMin,
704         address[] calldata path,
705         address to,
706         uint deadline
707     ) external payable;
708     function swapExactTokensForETHSupportingFeeOnTransferTokens(
709         uint amountIn,
710         uint amountOutMin,
711         address[] calldata path,
712         address to,
713         uint deadline
714     ) external;
715 }
716 
717 
718 pragma solidity >=0.6.0;
719 
720 interface ISwapModule {
721     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
722     function swapReward(uint256 amountIn, address receiver, address[] calldata path) external returns (uint256);
723 }
724 
725 
726 pragma solidity >=0.6.0;
727 
728 
729 
730 
731 
732 
733 
734 
735 contract Rover is Ownable {
736     using SafeMath for uint256;
737     using SafeERC20 for IERC20;
738 
739     uint256 public constant vestingTime = 365*24*60*60; // 1 year
740 
741     uint256 public roverStart;
742     uint256 public latestBalance;
743     uint256 public totalTokensReceived;
744     uint256 public totalTokensWithdrawn;
745     address[] public path;
746 
747     // prepare for v1.69 migration
748     address public marsColony;
749     bool public migrationCompleted;
750 
751     IBasedGod public basedGod;
752     IERC20 public immutable based;
753     IERC20 public immutable rewardToken;
754     address public immutable swapModule;
755 
756 
757     modifier updateBalance() {
758         sync();
759         _;
760         latestBalance = rewardToken.balanceOf(address(this));
761     }
762 
763     modifier onlyBasedDeployer() {
764         require(msg.sender == basedGod.deployer(), "Not a deployer");
765         _;
766     }
767 
768     modifier onlyMarsColony() {
769         require(msg.sender == marsColony, "Not a new moonbase");
770         _;
771     }
772 
773     /// @param _pair either "sUSD" or "WETH"
774     constructor (
775         address _rewardToken,
776         string memory _pair,
777         address _swapModule
778     )
779         public
780     {
781         basedGod = IBasedGod(msg.sender);
782         // set immutables
783         rewardToken = IERC20(_rewardToken);
784         based = IERC20(basedGod.based());
785         swapModule = _swapModule;
786 
787         address[] memory _path = new address[](3);
788         _path[0] = _rewardToken;
789         _path[2] = basedGod.based();
790 
791         if (keccak256(abi.encodePacked(_pair)) == keccak256(abi.encodePacked("WETH"))) {
792             _path[1] = basedGod.weth();
793         } else if (keccak256(abi.encodePacked(_pair)) == keccak256(abi.encodePacked("sUSD"))) {
794             _path[1] = basedGod.susd();
795         } else {
796             revert("must use a CERTIFIED OFFICIAL $BASED™ pair");
797         }
798 
799         // ensure that the path exists
800         uint[] memory amountsOut = ISwapModule(_swapModule).getAmountsOut(10**10, _path);
801         require(amountsOut[amountsOut.length - 1] >= 1, "Path does not exist");
802 
803         path = _path;
804     }
805 
806     function balance() public view returns (uint256) {
807         return rewardToken.balanceOf(address(this));
808     }
809 
810     function calculateReward() public view returns (uint256) {
811         uint256 timeElapsed = block.timestamp.sub(roverStart);
812         if (timeElapsed > vestingTime) timeElapsed = vestingTime;
813         uint256 maxClaimable = totalTokensReceived.mul(timeElapsed).div(vestingTime);
814         return maxClaimable.sub(totalTokensWithdrawn);
815     }
816 
817     function rugPull() public virtual updateBalance {
818         require(roverStart != 0, "Rover is not initialized");
819 
820         // Calculate how much reward can be swapped
821         uint256 availableReward = calculateReward();
822 
823         // Record that the tokens are being withdrawn
824         totalTokensWithdrawn = totalTokensWithdrawn.add(availableReward);
825         // Swap for BASED
826         (bool success, bytes memory result) = swapModule.delegatecall(
827             abi.encodeWithSignature(
828                 "swapReward(uint256,address,address[])",
829                 availableReward,
830                 address(this),
831                 path
832             )
833         );
834         require(success, "SwapModule: Swap failed");
835         uint256 basedReward = abi.decode(result, (uint256));
836 
837         // Split the reward between the caller and the moonbase contract
838         uint256 callerReward = basedReward.div(100);
839         uint256 moonbaseReward = basedReward.sub(callerReward);
840 
841         // Reward the caller
842         based.transfer(msg.sender, callerReward);
843         // Send to MoonBase
844         based.transfer(basedGod.moonbase(), moonbaseReward);
845     }
846 
847     function setMarsColony(address _marsColony) public onlyBasedDeployer {
848         marsColony = _marsColony;
849     }
850 
851     // WARNING: Alpha leak!
852     function migrateRoverBalanceToMarsColonyV1_69() external onlyMarsColony updateBalance {
853         require(migrationCompleted == false, "Migration completed");
854 
855         IERC20 moonbase = IERC20(basedGod.moonbase());
856         uint256 marsColonyShare = moonbase.balanceOf(msg.sender);
857         uint256 totalSupply = moonbase.totalSupply();
858         // withdraw amount is proportional to total supply share of mbBASED of msg.sender
859         uint256 amountToMigrate =
860             rewardToken.balanceOf(address(this)).mul(marsColonyShare).div(totalSupply);
861 
862         rewardToken.transfer(msg.sender, amountToMigrate);
863         migrationCompleted = true;
864 
865         // update rewards
866         totalTokensReceived = totalTokensReceived.sub(amountToMigrate);
867     }
868 
869     function init() internal updateBalance {
870         require(roverStart == 0, "Already initialized");
871         roverStart = block.timestamp;
872         renounceOwnership();
873     }
874 
875     function sync() internal {
876         uint256 currentBalance = rewardToken.balanceOf(address(this));
877         if (currentBalance > latestBalance) {
878             uint diff = currentBalance.sub(latestBalance);
879             totalTokensReceived = totalTokensReceived.add(diff);
880         }
881     }
882 }
883 
884 
885 pragma solidity >=0.6.0;
886 
887 
888 contract RoverVault is Rover {
889     constructor(address _rewardToken, string memory _pair, address _swapModule)
890         public
891         Rover(_rewardToken, _pair, _swapModule)
892     {}
893 
894     function startRover() public onlyOwner {
895         init();
896     }
897 }
898 
899 
900 
901 pragma solidity ^0.6.0;
902 
903 
904 
905 
906 
907 /**
908  * @dev Implementation of the {IERC20} interface.
909  *
910  * This implementation is agnostic to the way tokens are created. This means
911  * that a supply mechanism has to be added in a derived contract using {_mint}.
912  * For a generic mechanism see {ERC20PresetMinterPauser}.
913  *
914  * TIP: For a detailed writeup see our guide
915  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
916  * to implement supply mechanisms].
917  *
918  * We have followed general OpenZeppelin guidelines: functions revert instead
919  * of returning `false` on failure. This behavior is nonetheless conventional
920  * and does not conflict with the expectations of ERC20 applications.
921  *
922  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
923  * This allows applications to reconstruct the allowance for all accounts just
924  * by listening to said events. Other implementations of the EIP may not emit
925  * these events, as it isn't required by the specification.
926  *
927  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
928  * functions have been added to mitigate the well-known issues around setting
929  * allowances. See {IERC20-approve}.
930  */
931 contract ERC20 is Context, IERC20 {
932     using SafeMath for uint256;
933     using Address for address;
934 
935     mapping (address => uint256) private _balances;
936 
937     mapping (address => mapping (address => uint256)) private _allowances;
938 
939     uint256 private _totalSupply;
940 
941     string private _name;
942     string private _symbol;
943     uint8 private _decimals;
944 
945     /**
946      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
947      * a default value of 18.
948      *
949      * To select a different value for {decimals}, use {_setupDecimals}.
950      *
951      * All three of these values are immutable: they can only be set once during
952      * construction.
953      */
954     constructor (string memory name, string memory symbol) public {
955         _name = name;
956         _symbol = symbol;
957         _decimals = 18;
958     }
959 
960     /**
961      * @dev Returns the name of the token.
962      */
963     function name() public view returns (string memory) {
964         return _name;
965     }
966 
967     /**
968      * @dev Returns the symbol of the token, usually a shorter version of the
969      * name.
970      */
971     function symbol() public view returns (string memory) {
972         return _symbol;
973     }
974 
975     /**
976      * @dev Returns the number of decimals used to get its user representation.
977      * For example, if `decimals` equals `2`, a balance of `505` tokens should
978      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
979      *
980      * Tokens usually opt for a value of 18, imitating the relationship between
981      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
982      * called.
983      *
984      * NOTE: This information is only used for _display_ purposes: it in
985      * no way affects any of the arithmetic of the contract, including
986      * {IERC20-balanceOf} and {IERC20-transfer}.
987      */
988     function decimals() public view returns (uint8) {
989         return _decimals;
990     }
991 
992     /**
993      * @dev See {IERC20-totalSupply}.
994      */
995     function totalSupply() public view override returns (uint256) {
996         return _totalSupply;
997     }
998 
999     /**
1000      * @dev See {IERC20-balanceOf}.
1001      */
1002     function balanceOf(address account) public view override returns (uint256) {
1003         return _balances[account];
1004     }
1005 
1006     /**
1007      * @dev See {IERC20-transfer}.
1008      *
1009      * Requirements:
1010      *
1011      * - `recipient` cannot be the zero address.
1012      * - the caller must have a balance of at least `amount`.
1013      */
1014     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1015         _transfer(_msgSender(), recipient, amount);
1016         return true;
1017     }
1018 
1019     /**
1020      * @dev See {IERC20-allowance}.
1021      */
1022     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1023         return _allowances[owner][spender];
1024     }
1025 
1026     /**
1027      * @dev See {IERC20-approve}.
1028      *
1029      * Requirements:
1030      *
1031      * - `spender` cannot be the zero address.
1032      */
1033     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1034         _approve(_msgSender(), spender, amount);
1035         return true;
1036     }
1037 
1038     /**
1039      * @dev See {IERC20-transferFrom}.
1040      *
1041      * Emits an {Approval} event indicating the updated allowance. This is not
1042      * required by the EIP. See the note at the beginning of {ERC20};
1043      *
1044      * Requirements:
1045      * - `sender` and `recipient` cannot be the zero address.
1046      * - `sender` must have a balance of at least `amount`.
1047      * - the caller must have allowance for ``sender``'s tokens of at least
1048      * `amount`.
1049      */
1050     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1051         _transfer(sender, recipient, amount);
1052         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev Atomically increases the allowance granted to `spender` by the caller.
1058      *
1059      * This is an alternative to {approve} that can be used as a mitigation for
1060      * problems described in {IERC20-approve}.
1061      *
1062      * Emits an {Approval} event indicating the updated allowance.
1063      *
1064      * Requirements:
1065      *
1066      * - `spender` cannot be the zero address.
1067      */
1068     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1069         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1070         return true;
1071     }
1072 
1073     /**
1074      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1075      *
1076      * This is an alternative to {approve} that can be used as a mitigation for
1077      * problems described in {IERC20-approve}.
1078      *
1079      * Emits an {Approval} event indicating the updated allowance.
1080      *
1081      * Requirements:
1082      *
1083      * - `spender` cannot be the zero address.
1084      * - `spender` must have allowance for the caller of at least
1085      * `subtractedValue`.
1086      */
1087     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1088         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1089         return true;
1090     }
1091 
1092     /**
1093      * @dev Moves tokens `amount` from `sender` to `recipient`.
1094      *
1095      * This is internal function is equivalent to {transfer}, and can be used to
1096      * e.g. implement automatic token fees, slashing mechanisms, etc.
1097      *
1098      * Emits a {Transfer} event.
1099      *
1100      * Requirements:
1101      *
1102      * - `sender` cannot be the zero address.
1103      * - `recipient` cannot be the zero address.
1104      * - `sender` must have a balance of at least `amount`.
1105      */
1106     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1107         require(sender != address(0), "ERC20: transfer from the zero address");
1108         require(recipient != address(0), "ERC20: transfer to the zero address");
1109 
1110         _beforeTokenTransfer(sender, recipient, amount);
1111 
1112         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1113         _balances[recipient] = _balances[recipient].add(amount);
1114         emit Transfer(sender, recipient, amount);
1115     }
1116 
1117     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1118      * the total supply.
1119      *
1120      * Emits a {Transfer} event with `from` set to the zero address.
1121      *
1122      * Requirements
1123      *
1124      * - `to` cannot be the zero address.
1125      */
1126     function _mint(address account, uint256 amount) internal virtual {
1127         require(account != address(0), "ERC20: mint to the zero address");
1128 
1129         _beforeTokenTransfer(address(0), account, amount);
1130 
1131         _totalSupply = _totalSupply.add(amount);
1132         _balances[account] = _balances[account].add(amount);
1133         emit Transfer(address(0), account, amount);
1134     }
1135 
1136     /**
1137      * @dev Destroys `amount` tokens from `account`, reducing the
1138      * total supply.
1139      *
1140      * Emits a {Transfer} event with `to` set to the zero address.
1141      *
1142      * Requirements
1143      *
1144      * - `account` cannot be the zero address.
1145      * - `account` must have at least `amount` tokens.
1146      */
1147     function _burn(address account, uint256 amount) internal virtual {
1148         require(account != address(0), "ERC20: burn from the zero address");
1149 
1150         _beforeTokenTransfer(account, address(0), amount);
1151 
1152         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1153         _totalSupply = _totalSupply.sub(amount);
1154         emit Transfer(account, address(0), amount);
1155     }
1156 
1157     /**
1158      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1159      *
1160      * This is internal function is equivalent to `approve`, and can be used to
1161      * e.g. set automatic allowances for certain subsystems, etc.
1162      *
1163      * Emits an {Approval} event.
1164      *
1165      * Requirements:
1166      *
1167      * - `owner` cannot be the zero address.
1168      * - `spender` cannot be the zero address.
1169      */
1170     function _approve(address owner, address spender, uint256 amount) internal virtual {
1171         require(owner != address(0), "ERC20: approve from the zero address");
1172         require(spender != address(0), "ERC20: approve to the zero address");
1173 
1174         _allowances[owner][spender] = amount;
1175         emit Approval(owner, spender, amount);
1176     }
1177 
1178     /**
1179      * @dev Sets {decimals} to a value other than the default one of 18.
1180      *
1181      * WARNING: This function should only be called from the constructor. Most
1182      * applications that interact with token contracts will not expect
1183      * {decimals} to ever change, and may work incorrectly if it does.
1184      */
1185     function _setupDecimals(uint8 decimals_) internal {
1186         _decimals = decimals_;
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before any transfer of tokens. This includes
1191      * minting and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1196      * will be to transferred to `to`.
1197      * - when `from` is zero, `amount` tokens will be minted for `to`.
1198      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1199      * - `from` and `to` are never both zero.
1200      *
1201      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1202      */
1203     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1204 }
1205 
1206 
1207 
1208 pragma solidity ^0.6.0;
1209 
1210 /**
1211  * @dev Contract module that helps prevent reentrant calls to a function.
1212  *
1213  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1214  * available, which can be applied to functions to make sure there are no nested
1215  * (reentrant) calls to them.
1216  *
1217  * Note that because there is a single `nonReentrant` guard, functions marked as
1218  * `nonReentrant` may not call one another. This can be worked around by making
1219  * those functions `private`, and then adding `external` `nonReentrant` entry
1220  * points to them.
1221  *
1222  * TIP: If you would like to learn more about reentrancy and alternative ways
1223  * to protect against it, check out our blog post
1224  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1225  */
1226 contract ReentrancyGuard {
1227     // Booleans are more expensive than uint256 or any type that takes up a full
1228     // word because each write operation emits an extra SLOAD to first read the
1229     // slot's contents, replace the bits taken up by the boolean, and then write
1230     // back. This is the compiler's defense against contract upgrades and
1231     // pointer aliasing, and it cannot be disabled.
1232 
1233     // The values being non-zero value makes deployment a bit more expensive,
1234     // but in exchange the refund on every call to nonReentrant will be lower in
1235     // amount. Since refunds are capped to a percentage of the total
1236     // transaction's gas, it is best to keep them low in cases like this one, to
1237     // increase the likelihood of the full refund coming into effect.
1238     uint256 private constant _NOT_ENTERED = 1;
1239     uint256 private constant _ENTERED = 2;
1240 
1241     uint256 private _status;
1242 
1243     constructor () internal {
1244         _status = _NOT_ENTERED;
1245     }
1246 
1247     /**
1248      * @dev Prevents a contract from calling itself, directly or indirectly.
1249      * Calling a `nonReentrant` function from another `nonReentrant`
1250      * function is not supported. It is possible to prevent this from happening
1251      * by making the `nonReentrant` function external, and make it call a
1252      * `private` function that does the actual work.
1253      */
1254     modifier nonReentrant() {
1255         // On the first call to nonReentrant, _notEntered will be true
1256         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1257 
1258         // Any calls to nonReentrant after this point will fail
1259         _status = _ENTERED;
1260 
1261         _;
1262 
1263         // By storing the original value once again, a refund is triggered (see
1264         // https://eips.ethereum.org/EIPS/eip-2200)
1265         _status = _NOT_ENTERED;
1266     }
1267 }
1268 
1269 
1270 pragma solidity >=0.6.0;
1271 
1272 interface IPool {
1273     function getReward() external;
1274     function stake(uint256 amount) external;
1275     function earned(address account) external view returns (uint256);
1276 }
1277 
1278 
1279 pragma solidity >=0.6.0;
1280 
1281 
1282 
1283 
1284 
1285 contract FarmingRover is Rover, ERC20, ReentrancyGuard {
1286     IPool public rewardPool;
1287 
1288     /// @param _pair either "sUSD" or "WETH"
1289     constructor (
1290         address _rewardToken,
1291         string memory _pair,
1292         address _swapModule
1293     )
1294         public
1295         Rover(_rewardToken, _pair, _swapModule)
1296         ERC20(
1297             string(abi.encodePacked("Rover ", ERC20(_rewardToken).name())),
1298             string(abi.encodePacked("r", ERC20(_rewardToken).symbol()))
1299         )
1300     {
1301         // Mint the single token
1302         _mint(address(this), 1);
1303     }
1304 
1305     function earned() public view returns (uint256){
1306         return rewardPool.earned(address(this));
1307     }
1308 
1309     function startRover(address _rewardPool)
1310         public
1311         onlyOwner
1312     {
1313         init();
1314 
1315         this.approve(_rewardPool, 1);
1316         rewardPool = IPool(_rewardPool);
1317         rewardPool.stake(1);
1318     }
1319 
1320     function rugPull() public override nonReentrant {
1321         claimReward();
1322 
1323         // this couses reentracy
1324         super.rugPull();
1325     }
1326 
1327     function claimReward() internal {
1328         // ignore errors
1329         (bool success,) = address(rewardPool).call(abi.encodeWithSignature("getReward()"));
1330     }
1331 
1332     function _transfer(
1333         address sender,
1334         address recipient,
1335         uint256 amount
1336     ) internal override {
1337         require(balanceOf(address(this)) == 1, "NOT BASED: only one transfer allowed.");
1338         require(recipient == address(rewardPool),
1339             "NOT BASED: Recipient address must be equal to rewardPool address.");
1340         super._transfer(sender, recipient, amount);
1341     }
1342 }
1343 
1344 
1345 pragma solidity >=0.6.0;
1346 
1347 
1348 
1349 
1350 
1351 contract BasedGod {
1352     address[] public rovers;
1353     // rewardToken => rover address array
1354     mapping(address => address[]) public tokenRover;
1355     address public immutable moonbase;
1356     address public immutable based;
1357     address public immutable susd;
1358     address public immutable weth;
1359     // mainnet 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1360     address public immutable uniswapRouter;
1361     address public immutable poolFactory;
1362     address public immutable basedGodV1;
1363     address public immutable deployer;
1364 
1365     constructor (
1366         address _based,
1367         address _moonbase,
1368         address _susd,
1369         address _weth,
1370         address _uniswapRouter,
1371         address _poolFactory,
1372         address _basedGodV1
1373     ) public {
1374         susd = _susd;
1375         based = _based;
1376         moonbase = _moonbase;
1377         weth = _weth;
1378         uniswapRouter = _uniswapRouter;
1379         poolFactory = _poolFactory;
1380         basedGodV1 = _basedGodV1;
1381         deployer = msg.sender;
1382     }
1383 
1384     function getRovers() public view returns (address[] memory) {
1385         address[] memory legacyRovers = IBasedGod(basedGodV1).getRovers();
1386         return legacyRovers.length == 0 ? rovers : concatArrays(legacyRovers, rovers);
1387     }
1388 
1389     function getTokenRovers(address token) public view returns (address[] memory) {
1390         address[] memory legacyRovers = IBasedGod(basedGodV1).getTokenRovers(token);
1391         return legacyRovers.length == 0 ? tokenRover[token] : concatArrays(legacyRovers, tokenRover[token]);
1392     }
1393 
1394     /// @dev Use this Rover if you want to depoit tokens directly to Rover contract and you don't need to farm
1395     /// @param _rewardToken address of the reward token
1396     /// @param _pair through which pair do you want to sell reward tokens, either "sUSD" or "WETH"
1397     /// @param _swapModule contract address with swap implementation
1398     function createNewRoverVault(address _rewardToken, string calldata _pair, address _swapModule) external returns (RoverVault rover) {
1399         rover = new RoverVault(_rewardToken, _pair, _swapModule);
1400         rover.transferOwnership(msg.sender);
1401         _saveRover(_rewardToken, address(rover));
1402     }
1403 
1404     /// @dev Use this Rover if you have a reward pool and you want the Rover to farm it
1405     /// @param _rewardToken address of the reward token
1406     /// @param _pair either "sUSD" or "WETH"
1407     /// @param _swapModule contract address with swap implementation
1408     function createNewFarmingRover(address _rewardToken, string calldata _pair, address _swapModule) external returns (FarmingRover rover) {
1409         rover = new FarmingRover(_rewardToken, _pair, _swapModule);
1410         rover.transferOwnership(msg.sender);
1411         _saveRover(_rewardToken, address(rover));
1412     }
1413 
1414     /// @dev Use this if you want to deploy Farming Rover and Pool at once
1415     /// @param _distributor who can notify of rewards
1416     /// @param _swapModule contract address with swap implementation
1417     function createNewFarmingRoverAndPool(
1418         address _rewardToken,
1419         address _distributor,
1420         string calldata _pair,
1421         address _swapModule,
1422         uint256 _duration
1423     ) external returns (FarmingRover rover, address rewardsPool) {
1424         require(_distributor != address(0), "someone has to notify of rewards and it ain't us");
1425 
1426         rover = new FarmingRover(_rewardToken, _pair, _swapModule);
1427         _saveRover(_rewardToken, address(rover));
1428 
1429         rewardsPool = IPoolFactory(poolFactory).createNewPool(
1430             _rewardToken,
1431             address(rover),
1432             _duration,
1433             _distributor
1434         );
1435 
1436         rover.startRover(rewardsPool);
1437     }
1438 
1439     function _saveRover(address _rewardToken, address _rover) internal {
1440         rovers.push(address(_rover));
1441         tokenRover[_rewardToken].push(address(_rover));
1442     }
1443 
1444     function concatArrays(address[] memory arr1, address[] memory arr2) internal pure returns (address[] memory) {
1445         address[] memory resultArray = new address[](arr1.length + arr2.length);
1446         uint i=0;
1447         for (; i < arr1.length; i++) {
1448             resultArray[i] = arr1[i];
1449         }
1450 
1451         uint j=0;
1452         while (j < arr2.length) {
1453             resultArray[i++] = arr2[j++];
1454         }
1455         return resultArray;
1456     }
1457 }
1458 
1459 
1460 
1461 pragma solidity ^0.6.0;
1462 
1463 /**
1464  * @dev Standard math utilities missing in the Solidity language.
1465  */
1466 library Math {
1467     /**
1468      * @dev Returns the largest of two numbers.
1469      */
1470     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1471         return a >= b ? a : b;
1472     }
1473 
1474     /**
1475      * @dev Returns the smallest of two numbers.
1476      */
1477     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1478         return a < b ? a : b;
1479     }
1480 
1481     /**
1482      * @dev Returns the average of two numbers. The result is rounded towards
1483      * zero.
1484      */
1485     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1486         // (a + b) / 2 can overflow, so we distribute
1487         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1488     }
1489 }
1490 
1491 
1492 
1493 pragma solidity >=0.6.6;
1494 
1495 
1496 
1497 
1498 contract ERC20Migrator {
1499     using SafeMath for uint256;
1500 
1501     IERC20 public legacyToken;
1502     IERC20 public newToken;
1503 
1504     uint256 public totalMigrated;
1505 
1506     constructor (address _legacyToken, address _newToken) public {
1507         require(_legacyToken != address(0), "legacyToken address is required");
1508         require(_newToken != address(0), "_newToken address is required");
1509 
1510         legacyToken = IERC20(_legacyToken);
1511         newToken = IERC20(_newToken);
1512     }
1513 
1514     function migrate(address account, uint256 amount) internal {
1515         legacyToken.transferFrom(account, address(this), amount);
1516         newToken.transfer(account, amount);
1517         totalMigrated = totalMigrated.add(amount);
1518     }
1519 
1520     function migrateAll() public {
1521         address account = msg.sender;
1522         uint256 balance = legacyToken.balanceOf(account);
1523         uint256 allowance = legacyToken.allowance(account, address(this));
1524         uint256 amount = Math.min(balance, allowance);
1525         require(amount > 0, "ERC20Migrator::migrateAll: Approval and balance must be > 0");
1526         migrate(account, amount);
1527     }
1528 }
1529 
1530 
1531 /*
1532    ____            __   __        __   _
1533   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
1534  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
1535 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
1536      /___/
1537 
1538 * Synthetix: CurveRewards.sol
1539 *
1540 * Docs: https://docs.synthetix.io/
1541 *
1542 *
1543 * MIT License
1544 * ===========
1545 *
1546 * Copyright (c) 2020 Synthetix
1547 *
1548 * Permission is hereby granted, free of charge, to any person obtaining a copy
1549 * of this software and associated documentation files (the "Software"), to deal
1550 * in the Software without restriction, including without limitation the rights
1551 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1552 * copies of the Software, and to permit persons to whom the Software is
1553 * furnished to do so, subject to the following conditions:
1554 *
1555 * The above copyright notice and this permission notice shall be included in all
1556 * copies or substantial portions of the Software.
1557 *
1558 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1559 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1560 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1561 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1562 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1563 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1564 */
1565 
1566 
1567 pragma solidity ^0.6.0;
1568 
1569 
1570 
1571 
1572 
1573 
1574 
1575 abstract contract IRewardDistributionRecipient is Ownable {
1576     address rewardDistribution;
1577 
1578     constructor(address _rewardDistribution) public {
1579         rewardDistribution = _rewardDistribution;
1580     }
1581 
1582     function notifyRewardAmount(uint256 reward) virtual external;
1583 
1584     modifier onlyRewardDistribution() {
1585         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
1586         _;
1587     }
1588 
1589     function setRewardDistribution(address _rewardDistribution)
1590         external
1591         onlyOwner
1592     {
1593         rewardDistribution = _rewardDistribution;
1594     }
1595 }
1596 
1597 /*
1598 *   Changes made to the SynthetixReward contract
1599 *
1600 *   uni to lpToken, and make it as a parameter of the constructor instead of hardcoded.
1601 *
1602 *
1603 */
1604 
1605 contract LPTokenWrapper {
1606     using SafeMath for uint256;
1607     using SafeERC20 for IERC20;
1608 
1609     IERC20 public immutable lpToken;
1610 
1611     uint256 private _totalSupply;
1612     mapping(address => uint256) private _balances;
1613 
1614     constructor(address _lpToken) public {
1615         lpToken = IERC20(_lpToken);
1616     }
1617 
1618     function totalSupply() public view returns (uint256) {
1619         return _totalSupply;
1620     }
1621 
1622     function balanceOf(address account) public view returns (uint256) {
1623         return _balances[account];
1624     }
1625 
1626     function stake(uint256 amount) public virtual {
1627         _totalSupply = _totalSupply.add(amount);
1628         _balances[msg.sender] = _balances[msg.sender].add(amount);
1629         lpToken.safeTransferFrom(msg.sender, address(this), amount);
1630     }
1631 
1632     function withdraw(uint256 amount) public virtual {
1633         _totalSupply = _totalSupply.sub(amount);
1634         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1635         lpToken.safeTransfer(msg.sender, amount);
1636     }
1637 }
1638 
1639 /*
1640 *   [Hardwork]
1641 *   This pool doesn't mint.
1642 *   the rewards should be first transferred to this pool, then get "notified"
1643 *   by calling `notifyRewardAmount`
1644 */
1645 
1646 contract NoMintRewardPool is LPTokenWrapper, IRewardDistributionRecipient {
1647     IERC20 public immutable rewardToken;
1648     uint256 public immutable duration; // making it not a constant is less gas efficient, but portable
1649 
1650     uint256 public periodFinish = 0;
1651     uint256 public rewardRate = 0;
1652     uint256 public lastUpdateTime;
1653     uint256 public rewardPerTokenStored;
1654     mapping(address => uint256) public userRewardPerTokenPaid;
1655     mapping(address => uint256) public rewards;
1656 
1657     event RewardAdded(uint256 reward);
1658     event Staked(address indexed user, uint256 amount);
1659     event Withdrawn(address indexed user, uint256 amount);
1660     event RewardPaid(address indexed user, uint256 reward);
1661 
1662     modifier updateReward(address account) {
1663         rewardPerTokenStored = rewardPerToken();
1664         lastUpdateTime = lastTimeRewardApplicable();
1665         if (account != address(0)) {
1666             rewards[account] = earned(account);
1667             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1668         }
1669         _;
1670     }
1671 
1672     // [Hardwork] setting the reward, lpToken, duration, and rewardDistribution for each pool
1673     constructor(address _rewardToken,
1674         address _lpToken,
1675         uint256 _duration,
1676         address _rewardDistribution) public
1677     LPTokenWrapper(_lpToken)
1678     IRewardDistributionRecipient(_rewardDistribution)
1679     {
1680         rewardToken = IERC20(_rewardToken);
1681         duration = _duration;
1682     }
1683 
1684     function lastTimeRewardApplicable() public view returns (uint256) {
1685         return Math.min(block.timestamp, periodFinish);
1686     }
1687 
1688     function rewardPerToken() public view returns (uint256) {
1689         if (totalSupply() == 0) {
1690             return rewardPerTokenStored;
1691         }
1692         return
1693             rewardPerTokenStored.add(
1694                 lastTimeRewardApplicable()
1695                     .sub(lastUpdateTime)
1696                     .mul(rewardRate)
1697                     .mul(1e18)
1698                     .div(totalSupply())
1699             );
1700     }
1701 
1702     function earned(address account) public view returns (uint256) {
1703         return
1704             balanceOf(account)
1705                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1706                 .div(1e18)
1707                 .add(rewards[account]);
1708     }
1709 
1710     // stake visibility is public as overriding LPTokenWrapper's stake() function
1711     function stake(uint256 amount) public updateReward(msg.sender) override {
1712         require(amount > 0, "Cannot stake 0");
1713         super.stake(amount);
1714         emit Staked(msg.sender, amount);
1715     }
1716 
1717     function withdraw(uint256 amount) public updateReward(msg.sender) override {
1718         require(amount > 0, "Cannot withdraw 0");
1719         super.withdraw(amount);
1720         emit Withdrawn(msg.sender, amount);
1721     }
1722 
1723     function exit() external {
1724         withdraw(balanceOf(msg.sender));
1725         getReward();
1726     }
1727 
1728     function getReward() public updateReward(msg.sender) {
1729         uint256 reward = earned(msg.sender);
1730         if (reward > 0) {
1731             rewards[msg.sender] = 0;
1732             rewardToken.safeTransfer(msg.sender, reward);
1733             emit RewardPaid(msg.sender, reward);
1734         }
1735     }
1736 
1737     function notifyRewardAmount(uint256 reward)
1738         external
1739         override
1740         onlyRewardDistribution
1741         updateReward(address(0))
1742     {
1743         if (block.timestamp >= periodFinish) {
1744             rewardRate = reward.div(duration);
1745         } else {
1746             uint256 remaining = periodFinish.sub(block.timestamp);
1747             uint256 leftover = remaining.mul(rewardRate);
1748             rewardRate = reward.add(leftover).div(duration);
1749         }
1750         lastUpdateTime = block.timestamp;
1751         periodFinish = block.timestamp.add(duration);
1752         emit RewardAdded(reward);
1753     }
1754 }
1755 
1756 pragma solidity ^0.6.0;
1757 
1758 
1759 
1760 interface IMoonbaseTheGame {
1761     function mint(address receiver, uint id, string calldata hash) external;
1762 }
1763 
1764 contract MoonbaseNFTAirdrop is Ownable {
1765     using SafeMath for uint;
1766 
1767     uint immutable public nftTotalQuantity;
1768     uint constant public maxClaimable = 11;
1769 
1770     IMoonbaseTheGame public moonbaseNFTs;
1771 
1772     mapping(address => uint) public nftPerAddress;
1773 
1774     string[] public nftHashes = [
1775         "QmQcdWUE5W8nt2xFn8mDvkLXGuU5CXWiptDM9SpVSPYnHX",
1776         "QmQax93v7EE2im7zgMpHZo74NouV7mBLvuBUMNKBHWJBiQ",
1777         "QmVKBGC3CqtGPR71aUzHbXRqvjkakVKJnazncvqsMhYcuU",
1778         "QmekhiMwznE7KQyCbvLiqk2JDKpt9N4frXPSCYyZNoM8Kx",
1779         "QmP6VAYvrrRMr47rGroDAM2G2WeNYC6HLJVrTgsGQS8kVp",
1780         "QmVavHhCLnegWQBfFpeyd7ckLswxRDd2EXZD4TDMggPWm6",
1781         "Qmc7d8mewKNVeig1PrURebWtkY9r1sToXBwhfSZnVw1eWm",
1782         "QmYMgbnFEpxw7Vy8qMg2ZNNJaJCSQQwnapdTTzerXpR7Pi",
1783         "QmT66L5CKAqFKYQ1pfLkSX78PCsko2YUdRudFLwUafP7iU",
1784         "QmP5NEMpets81LFbsWxNfSpUS1AsHvU39KK62vqnsotTpE",
1785         "QmVvfPRWsJGHhTMGfiELm5Soom31hwprbjW8tHGy22oMDM",
1786         "QmQKXm5dApWd9zjXWKtjS9NC8H21dzi6BcivRuBf9UxHQp",
1787         "QmYwCdmvxTyk8KwHJ3idasxiJ5WBUNFFW9QnCwrA2johY4",
1788         "QmNr9rUpVWXz7gedn7qiAczZtjfDtEWC7nGxdzbwTvj6er",
1789         "Qmbp9sbxNtevBw5YfyrvwFcYDeMptHsPCF8kC9bG8DrvCD",
1790         "QmT3mxzduUMje77cY9R9PDmFKiVuXZUdsCcP9dAVRxw1xH",
1791         "QmVsaqbViMPTDTqo6f3nF8imgnGeohirKQpmxj8hJT7Kk3",
1792         "QmcqnGtd9Ympe6NCAnWu7KFKhSRJPZ2zdfefYsMgmWSHGn",
1793         "QmU3mKvzFq8oNTkxebGFSaf8BN2YyFJxAgUnBk4uuwTxaw",
1794         "QmTskfzmU31XDQfTXad34igq99NqNhntLogjbJQ2U4Po3i",
1795         "QmYfA3XE7cwqAySXt1thduruA1cC23GcBrVuA3w3cd1shC",
1796         "QmVm9XKy5v7KSj5Bce4dj15V51sbrXPcxxcxXGP8qEHhRn",
1797         "QmYf3oQSh93hpyFH9UfsUgASHeJd924pcAoMyC3UHBwfH4",
1798         "QmReLfWBGxu3xNBNd61nMxJsK7bbBsdxVB6VmLf6F13VQe",
1799         "QmNZPXjZcGdNEe8jckNCvSsycFsUReFDFg9rqetXAk5mAf",
1800         "QmcSsjVpSsgFs7wb6SSDiT3oHKkrKeagAFVAugHfq4DEQX",
1801         "QmX5RvgTFknVfahVSTVT937zwvQh9vQCZHhAKDa87EnaHG",
1802         "QmUFwYwLk3mk5e2aLK1THaj3AT4CjUCSWRxn8MBqUVqFU7",
1803         "QmNpZzYy5RiCE6m6tDSYXZAxCbHu6gFEaDRocLiyr3MpQu",
1804         "QmbRgXX9PKXKGw9WpnqTDzYze3JCb5GXU4YoXJLdy8wogn",
1805         "QmTTtser1BdJufeQMeT7Gu1yXjNDRMmXArjffyh7TKs5Gk",
1806         "QmRPcFUriMkTo1djS6TyyMwvZimX2dj1qrLgBc387bQ6eD",
1807         "QmVNd4tjwqPFGn69gjrHtyA8Pz1BuXnoDMoJA5Uov3c3Kv",
1808         "QmVUrqFTiQnrRmeAUHqTpXYp9cymT59vyC3zKFh7EQ3dT4",
1809         "QmbakLza9Y1WgT7HyxrQZkTE1cBcUAPRZvJY7CYXE1CfxY",
1810         "QmV9nyt4Nis3NkiRTnmmNRQLtg7uewq976uR3FdpsVeGk6",
1811         "QmeckwtMBbWgXUP4jT6Yqaap7KDG17ed1x6SWJ9bL7n2fH",
1812         "QmZjbZd9Jny2cHGfxTFZUkai4R7ngTaFdSqKcsZ3FiJUEs",
1813         "QmVgAwLCrsZtzdjc5H8CVqUEzJty29wZ3LZ6w1ZuMoShru",
1814         "QmQEiw5GVxYTRQcYiHB3vbCo7GeQgVRGc1Leq3M9XSphXy",
1815         "QmeTSAx6YTPpXv9ErEcGgCZqLhByQFzroBqTi5kQutwqwv",
1816         "QmS5H5FBReRhj1BkV9JpT47LhAPtTf5XqYJroFnrgSUaLC"
1817     ];
1818 
1819     uint[] public nftQuantities = [
1820         906, 905, 905, 905, 666, 666, 666, 666, 666, 666,
1821         666, 666, 666, 666, 666, 666, 666, 666, 666, 666,
1822         666, 420, 420, 420, 420, 420, 69, 69, 69, 69,
1823         69, 13, 13, 13, 13, 13, 13, 3, 3, 3,
1824         3, 1
1825     ];
1826 
1827     uint public nftIdCounter = 0;
1828 
1829     constructor () public {
1830         uint total = 0;
1831         for (uint i = 0; i < nftQuantities.length; i++) {
1832             total += nftQuantities[i];
1833         }
1834         nftTotalQuantity = total;
1835     }
1836 
1837     function init(address _moonbaseNFTs) public onlyOwner {
1838         require(address(moonbaseNFTs) == address(0), "Already initialized");
1839         moonbaseNFTs = IMoonbaseTheGame(_moonbaseNFTs);
1840     }
1841 
1842     function setAddresses(address[] memory _addresses) public onlyOwner {
1843         for (uint i = 0; i < _addresses.length; i++) {
1844             nftPerAddress[_addresses[i]] = maxClaimable;
1845         }
1846     }
1847 
1848     function claimMoonbaseNFT() public {
1849         require(nftPerAddress[msg.sender] > 0, "You got all your NFTs already");
1850 
1851         string memory ipfsHash = getRandomNFT(msg.sender);
1852         moonbaseNFTs.mint(msg.sender, nftIdCounter, ipfsHash);
1853         nftIdCounter += 1;
1854         nftPerAddress[msg.sender] = nftPerAddress[msg.sender].sub(1);
1855     }
1856 
1857     function getRandomNFT(address entropy) internal returns (string memory) {
1858         uint mod = 0;
1859         for (uint i = 0; i < nftQuantities.length; i++) {
1860             mod = mod.add(nftQuantities[i]);
1861         }
1862         int remainder = int((uint(entropy) + uint(blockhash(block.number))) % mod);
1863 
1864 	    uint index = 0;
1865         remainder -= int(nftQuantities[index]);
1866         while(remainder > 0) {
1867             index += 1;
1868             remainder -= int(nftQuantities[index]);
1869         }
1870 
1871         while(nftQuantities[index] == 0) {
1872             index += 1;
1873             if (index >= nftTotalQuantity) {
1874                 index = 0;
1875             }
1876         }
1877 
1878         nftQuantities[index] -= 1;
1879         return nftHashes[index];
1880     }
1881 }
1882 
1883 
1884 
1885 pragma solidity ^0.6.0;
1886 
1887 /**
1888  * @dev Interface of the ERC165 standard, as defined in the
1889  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1890  *
1891  * Implementers can declare support of contract interfaces, which can then be
1892  * queried by others ({ERC165Checker}).
1893  *
1894  * For an implementation, see {ERC165}.
1895  */
1896 interface IERC165 {
1897     /**
1898      * @dev Returns true if this contract implements the interface defined by
1899      * `interfaceId`. See the corresponding
1900      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1901      * to learn more about how these ids are created.
1902      *
1903      * This function call must use less than 30 000 gas.
1904      */
1905     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1906 }
1907 
1908 
1909 
1910 pragma solidity ^0.6.2;
1911 
1912 
1913 /**
1914  * @dev Required interface of an ERC721 compliant contract.
1915  */
1916 interface IERC721 is IERC165 {
1917     /**
1918      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
1919      */
1920     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1921 
1922     /**
1923      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1924      */
1925     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1926 
1927     /**
1928      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1929      */
1930     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1931 
1932     /**
1933      * @dev Returns the number of tokens in ``owner``'s account.
1934      */
1935     function balanceOf(address owner) external view returns (uint256 balance);
1936 
1937     /**
1938      * @dev Returns the owner of the `tokenId` token.
1939      *
1940      * Requirements:
1941      *
1942      * - `tokenId` must exist.
1943      */
1944     function ownerOf(uint256 tokenId) external view returns (address owner);
1945 
1946     /**
1947      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1948      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1949      *
1950      * Requirements:
1951      *
1952      * - `from` cannot be the zero address.
1953      * - `to` cannot be the zero address.
1954      * - `tokenId` token must exist and be owned by `from`.
1955      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1957      *
1958      * Emits a {Transfer} event.
1959      */
1960     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1961 
1962     /**
1963      * @dev Transfers `tokenId` token from `from` to `to`.
1964      *
1965      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1966      *
1967      * Requirements:
1968      *
1969      * - `from` cannot be the zero address.
1970      * - `to` cannot be the zero address.
1971      * - `tokenId` token must be owned by `from`.
1972      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1973      *
1974      * Emits a {Transfer} event.
1975      */
1976     function transferFrom(address from, address to, uint256 tokenId) external;
1977 
1978     /**
1979      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1980      * The approval is cleared when the token is transferred.
1981      *
1982      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1983      *
1984      * Requirements:
1985      *
1986      * - The caller must own the token or be an approved operator.
1987      * - `tokenId` must exist.
1988      *
1989      * Emits an {Approval} event.
1990      */
1991     function approve(address to, uint256 tokenId) external;
1992 
1993     /**
1994      * @dev Returns the account approved for `tokenId` token.
1995      *
1996      * Requirements:
1997      *
1998      * - `tokenId` must exist.
1999      */
2000     function getApproved(uint256 tokenId) external view returns (address operator);
2001 
2002     /**
2003      * @dev Approve or remove `operator` as an operator for the caller.
2004      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2005      *
2006      * Requirements:
2007      *
2008      * - The `operator` cannot be the caller.
2009      *
2010      * Emits an {ApprovalForAll} event.
2011      */
2012     function setApprovalForAll(address operator, bool _approved) external;
2013 
2014     /**
2015      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2016      *
2017      * See {setApprovalForAll}
2018      */
2019     function isApprovedForAll(address owner, address operator) external view returns (bool);
2020 
2021     /**
2022       * @dev Safely transfers `tokenId` token from `from` to `to`.
2023       *
2024       * Requirements:
2025       *
2026      * - `from` cannot be the zero address.
2027      * - `to` cannot be the zero address.
2028       * - `tokenId` token must exist and be owned by `from`.
2029       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2030       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2031       *
2032       * Emits a {Transfer} event.
2033       */
2034     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
2035 }
2036 
2037 
2038 
2039 pragma solidity ^0.6.2;
2040 
2041 
2042 /**
2043  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2044  * @dev See https://eips.ethereum.org/EIPS/eip-721
2045  */
2046 interface IERC721Metadata is IERC721 {
2047 
2048     /**
2049      * @dev Returns the token collection name.
2050      */
2051     function name() external view returns (string memory);
2052 
2053     /**
2054      * @dev Returns the token collection symbol.
2055      */
2056     function symbol() external view returns (string memory);
2057 
2058     /**
2059      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2060      */
2061     function tokenURI(uint256 tokenId) external view returns (string memory);
2062 }
2063 
2064 
2065 
2066 pragma solidity ^0.6.2;
2067 
2068 
2069 /**
2070  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2071  * @dev See https://eips.ethereum.org/EIPS/eip-721
2072  */
2073 interface IERC721Enumerable is IERC721 {
2074 
2075     /**
2076      * @dev Returns the total amount of tokens stored by the contract.
2077      */
2078     function totalSupply() external view returns (uint256);
2079 
2080     /**
2081      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2082      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2083      */
2084     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2085 
2086     /**
2087      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2088      * Use along with {totalSupply} to enumerate all tokens.
2089      */
2090     function tokenByIndex(uint256 index) external view returns (uint256);
2091 }
2092 
2093 
2094 
2095 pragma solidity ^0.6.0;
2096 
2097 /**
2098  * @title ERC721 token receiver interface
2099  * @dev Interface for any contract that wants to support safeTransfers
2100  * from ERC721 asset contracts.
2101  */
2102 interface IERC721Receiver {
2103     /**
2104      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2105      * by `operator` from `from`, this function is called.
2106      *
2107      * It must return its Solidity selector to confirm the token transfer.
2108      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2109      *
2110      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2111      */
2112     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
2113     external returns (bytes4);
2114 }
2115 
2116 
2117 
2118 pragma solidity ^0.6.0;
2119 
2120 
2121 /**
2122  * @dev Implementation of the {IERC165} interface.
2123  *
2124  * Contracts may inherit from this and call {_registerInterface} to declare
2125  * their support of an interface.
2126  */
2127 contract ERC165 is IERC165 {
2128     /*
2129      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
2130      */
2131     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
2132 
2133     /**
2134      * @dev Mapping of interface ids to whether or not it's supported.
2135      */
2136     mapping(bytes4 => bool) private _supportedInterfaces;
2137 
2138     constructor () internal {
2139         // Derived contracts need only register support for their own interfaces,
2140         // we register support for ERC165 itself here
2141         _registerInterface(_INTERFACE_ID_ERC165);
2142     }
2143 
2144     /**
2145      * @dev See {IERC165-supportsInterface}.
2146      *
2147      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
2148      */
2149     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
2150         return _supportedInterfaces[interfaceId];
2151     }
2152 
2153     /**
2154      * @dev Registers the contract as an implementer of the interface defined by
2155      * `interfaceId`. Support of the actual ERC165 interface is automatic and
2156      * registering its interface id is not required.
2157      *
2158      * See {IERC165-supportsInterface}.
2159      *
2160      * Requirements:
2161      *
2162      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
2163      */
2164     function _registerInterface(bytes4 interfaceId) internal virtual {
2165         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
2166         _supportedInterfaces[interfaceId] = true;
2167     }
2168 }
2169 
2170 
2171 
2172 pragma solidity ^0.6.0;
2173 
2174 /**
2175  * @dev Library for managing
2176  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2177  * types.
2178  *
2179  * Sets have the following properties:
2180  *
2181  * - Elements are added, removed, and checked for existence in constant time
2182  * (O(1)).
2183  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2184  *
2185  * ```
2186  * contract Example {
2187  *     // Add the library methods
2188  *     using EnumerableSet for EnumerableSet.AddressSet;
2189  *
2190  *     // Declare a set state variable
2191  *     EnumerableSet.AddressSet private mySet;
2192  * }
2193  * ```
2194  *
2195  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
2196  * (`UintSet`) are supported.
2197  */
2198 library EnumerableSet {
2199     // To implement this library for multiple types with as little code
2200     // repetition as possible, we write it in terms of a generic Set type with
2201     // bytes32 values.
2202     // The Set implementation uses private functions, and user-facing
2203     // implementations (such as AddressSet) are just wrappers around the
2204     // underlying Set.
2205     // This means that we can only create new EnumerableSets for types that fit
2206     // in bytes32.
2207 
2208     struct Set {
2209         // Storage of set values
2210         bytes32[] _values;
2211 
2212         // Position of the value in the `values` array, plus 1 because index 0
2213         // means a value is not in the set.
2214         mapping (bytes32 => uint256) _indexes;
2215     }
2216 
2217     /**
2218      * @dev Add a value to a set. O(1).
2219      *
2220      * Returns true if the value was added to the set, that is if it was not
2221      * already present.
2222      */
2223     function _add(Set storage set, bytes32 value) private returns (bool) {
2224         if (!_contains(set, value)) {
2225             set._values.push(value);
2226             // The value is stored at length-1, but we add 1 to all indexes
2227             // and use 0 as a sentinel value
2228             set._indexes[value] = set._values.length;
2229             return true;
2230         } else {
2231             return false;
2232         }
2233     }
2234 
2235     /**
2236      * @dev Removes a value from a set. O(1).
2237      *
2238      * Returns true if the value was removed from the set, that is if it was
2239      * present.
2240      */
2241     function _remove(Set storage set, bytes32 value) private returns (bool) {
2242         // We read and store the value's index to prevent multiple reads from the same storage slot
2243         uint256 valueIndex = set._indexes[value];
2244 
2245         if (valueIndex != 0) { // Equivalent to contains(set, value)
2246             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2247             // the array, and then remove the last element (sometimes called as 'swap and pop').
2248             // This modifies the order of the array, as noted in {at}.
2249 
2250             uint256 toDeleteIndex = valueIndex - 1;
2251             uint256 lastIndex = set._values.length - 1;
2252 
2253             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
2254             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
2255 
2256             bytes32 lastvalue = set._values[lastIndex];
2257 
2258             // Move the last value to the index where the value to delete is
2259             set._values[toDeleteIndex] = lastvalue;
2260             // Update the index for the moved value
2261             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
2262 
2263             // Delete the slot where the moved value was stored
2264             set._values.pop();
2265 
2266             // Delete the index for the deleted slot
2267             delete set._indexes[value];
2268 
2269             return true;
2270         } else {
2271             return false;
2272         }
2273     }
2274 
2275     /**
2276      * @dev Returns true if the value is in the set. O(1).
2277      */
2278     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2279         return set._indexes[value] != 0;
2280     }
2281 
2282     /**
2283      * @dev Returns the number of values on the set. O(1).
2284      */
2285     function _length(Set storage set) private view returns (uint256) {
2286         return set._values.length;
2287     }
2288 
2289    /**
2290     * @dev Returns the value stored at position `index` in the set. O(1).
2291     *
2292     * Note that there are no guarantees on the ordering of values inside the
2293     * array, and it may change when more values are added or removed.
2294     *
2295     * Requirements:
2296     *
2297     * - `index` must be strictly less than {length}.
2298     */
2299     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2300         require(set._values.length > index, "EnumerableSet: index out of bounds");
2301         return set._values[index];
2302     }
2303 
2304     // AddressSet
2305 
2306     struct AddressSet {
2307         Set _inner;
2308     }
2309 
2310     /**
2311      * @dev Add a value to a set. O(1).
2312      *
2313      * Returns true if the value was added to the set, that is if it was not
2314      * already present.
2315      */
2316     function add(AddressSet storage set, address value) internal returns (bool) {
2317         return _add(set._inner, bytes32(uint256(value)));
2318     }
2319 
2320     /**
2321      * @dev Removes a value from a set. O(1).
2322      *
2323      * Returns true if the value was removed from the set, that is if it was
2324      * present.
2325      */
2326     function remove(AddressSet storage set, address value) internal returns (bool) {
2327         return _remove(set._inner, bytes32(uint256(value)));
2328     }
2329 
2330     /**
2331      * @dev Returns true if the value is in the set. O(1).
2332      */
2333     function contains(AddressSet storage set, address value) internal view returns (bool) {
2334         return _contains(set._inner, bytes32(uint256(value)));
2335     }
2336 
2337     /**
2338      * @dev Returns the number of values in the set. O(1).
2339      */
2340     function length(AddressSet storage set) internal view returns (uint256) {
2341         return _length(set._inner);
2342     }
2343 
2344    /**
2345     * @dev Returns the value stored at position `index` in the set. O(1).
2346     *
2347     * Note that there are no guarantees on the ordering of values inside the
2348     * array, and it may change when more values are added or removed.
2349     *
2350     * Requirements:
2351     *
2352     * - `index` must be strictly less than {length}.
2353     */
2354     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2355         return address(uint256(_at(set._inner, index)));
2356     }
2357 
2358 
2359     // UintSet
2360 
2361     struct UintSet {
2362         Set _inner;
2363     }
2364 
2365     /**
2366      * @dev Add a value to a set. O(1).
2367      *
2368      * Returns true if the value was added to the set, that is if it was not
2369      * already present.
2370      */
2371     function add(UintSet storage set, uint256 value) internal returns (bool) {
2372         return _add(set._inner, bytes32(value));
2373     }
2374 
2375     /**
2376      * @dev Removes a value from a set. O(1).
2377      *
2378      * Returns true if the value was removed from the set, that is if it was
2379      * present.
2380      */
2381     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2382         return _remove(set._inner, bytes32(value));
2383     }
2384 
2385     /**
2386      * @dev Returns true if the value is in the set. O(1).
2387      */
2388     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2389         return _contains(set._inner, bytes32(value));
2390     }
2391 
2392     /**
2393      * @dev Returns the number of values on the set. O(1).
2394      */
2395     function length(UintSet storage set) internal view returns (uint256) {
2396         return _length(set._inner);
2397     }
2398 
2399    /**
2400     * @dev Returns the value stored at position `index` in the set. O(1).
2401     *
2402     * Note that there are no guarantees on the ordering of values inside the
2403     * array, and it may change when more values are added or removed.
2404     *
2405     * Requirements:
2406     *
2407     * - `index` must be strictly less than {length}.
2408     */
2409     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2410         return uint256(_at(set._inner, index));
2411     }
2412 }
2413 
2414 
2415 
2416 pragma solidity ^0.6.0;
2417 
2418 /**
2419  * @dev Library for managing an enumerable variant of Solidity's
2420  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
2421  * type.
2422  *
2423  * Maps have the following properties:
2424  *
2425  * - Entries are added, removed, and checked for existence in constant time
2426  * (O(1)).
2427  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
2428  *
2429  * ```
2430  * contract Example {
2431  *     // Add the library methods
2432  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
2433  *
2434  *     // Declare a set state variable
2435  *     EnumerableMap.UintToAddressMap private myMap;
2436  * }
2437  * ```
2438  *
2439  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
2440  * supported.
2441  */
2442 library EnumerableMap {
2443     // To implement this library for multiple types with as little code
2444     // repetition as possible, we write it in terms of a generic Map type with
2445     // bytes32 keys and values.
2446     // The Map implementation uses private functions, and user-facing
2447     // implementations (such as Uint256ToAddressMap) are just wrappers around
2448     // the underlying Map.
2449     // This means that we can only create new EnumerableMaps for types that fit
2450     // in bytes32.
2451 
2452     struct MapEntry {
2453         bytes32 _key;
2454         bytes32 _value;
2455     }
2456 
2457     struct Map {
2458         // Storage of map keys and values
2459         MapEntry[] _entries;
2460 
2461         // Position of the entry defined by a key in the `entries` array, plus 1
2462         // because index 0 means a key is not in the map.
2463         mapping (bytes32 => uint256) _indexes;
2464     }
2465 
2466     /**
2467      * @dev Adds a key-value pair to a map, or updates the value for an existing
2468      * key. O(1).
2469      *
2470      * Returns true if the key was added to the map, that is if it was not
2471      * already present.
2472      */
2473     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
2474         // We read and store the key's index to prevent multiple reads from the same storage slot
2475         uint256 keyIndex = map._indexes[key];
2476 
2477         if (keyIndex == 0) { // Equivalent to !contains(map, key)
2478             map._entries.push(MapEntry({ _key: key, _value: value }));
2479             // The entry is stored at length-1, but we add 1 to all indexes
2480             // and use 0 as a sentinel value
2481             map._indexes[key] = map._entries.length;
2482             return true;
2483         } else {
2484             map._entries[keyIndex - 1]._value = value;
2485             return false;
2486         }
2487     }
2488 
2489     /**
2490      * @dev Removes a key-value pair from a map. O(1).
2491      *
2492      * Returns true if the key was removed from the map, that is if it was present.
2493      */
2494     function _remove(Map storage map, bytes32 key) private returns (bool) {
2495         // We read and store the key's index to prevent multiple reads from the same storage slot
2496         uint256 keyIndex = map._indexes[key];
2497 
2498         if (keyIndex != 0) { // Equivalent to contains(map, key)
2499             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
2500             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
2501             // This modifies the order of the array, as noted in {at}.
2502 
2503             uint256 toDeleteIndex = keyIndex - 1;
2504             uint256 lastIndex = map._entries.length - 1;
2505 
2506             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
2507             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
2508 
2509             MapEntry storage lastEntry = map._entries[lastIndex];
2510 
2511             // Move the last entry to the index where the entry to delete is
2512             map._entries[toDeleteIndex] = lastEntry;
2513             // Update the index for the moved entry
2514             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
2515 
2516             // Delete the slot where the moved entry was stored
2517             map._entries.pop();
2518 
2519             // Delete the index for the deleted slot
2520             delete map._indexes[key];
2521 
2522             return true;
2523         } else {
2524             return false;
2525         }
2526     }
2527 
2528     /**
2529      * @dev Returns true if the key is in the map. O(1).
2530      */
2531     function _contains(Map storage map, bytes32 key) private view returns (bool) {
2532         return map._indexes[key] != 0;
2533     }
2534 
2535     /**
2536      * @dev Returns the number of key-value pairs in the map. O(1).
2537      */
2538     function _length(Map storage map) private view returns (uint256) {
2539         return map._entries.length;
2540     }
2541 
2542    /**
2543     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
2544     *
2545     * Note that there are no guarantees on the ordering of entries inside the
2546     * array, and it may change when more entries are added or removed.
2547     *
2548     * Requirements:
2549     *
2550     * - `index` must be strictly less than {length}.
2551     */
2552     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
2553         require(map._entries.length > index, "EnumerableMap: index out of bounds");
2554 
2555         MapEntry storage entry = map._entries[index];
2556         return (entry._key, entry._value);
2557     }
2558 
2559     /**
2560      * @dev Returns the value associated with `key`.  O(1).
2561      *
2562      * Requirements:
2563      *
2564      * - `key` must be in the map.
2565      */
2566     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
2567         return _get(map, key, "EnumerableMap: nonexistent key");
2568     }
2569 
2570     /**
2571      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
2572      */
2573     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
2574         uint256 keyIndex = map._indexes[key];
2575         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
2576         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
2577     }
2578 
2579     // UintToAddressMap
2580 
2581     struct UintToAddressMap {
2582         Map _inner;
2583     }
2584 
2585     /**
2586      * @dev Adds a key-value pair to a map, or updates the value for an existing
2587      * key. O(1).
2588      *
2589      * Returns true if the key was added to the map, that is if it was not
2590      * already present.
2591      */
2592     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
2593         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
2594     }
2595 
2596     /**
2597      * @dev Removes a value from a set. O(1).
2598      *
2599      * Returns true if the key was removed from the map, that is if it was present.
2600      */
2601     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
2602         return _remove(map._inner, bytes32(key));
2603     }
2604 
2605     /**
2606      * @dev Returns true if the key is in the map. O(1).
2607      */
2608     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
2609         return _contains(map._inner, bytes32(key));
2610     }
2611 
2612     /**
2613      * @dev Returns the number of elements in the map. O(1).
2614      */
2615     function length(UintToAddressMap storage map) internal view returns (uint256) {
2616         return _length(map._inner);
2617     }
2618 
2619    /**
2620     * @dev Returns the element stored at position `index` in the set. O(1).
2621     * Note that there are no guarantees on the ordering of values inside the
2622     * array, and it may change when more values are added or removed.
2623     *
2624     * Requirements:
2625     *
2626     * - `index` must be strictly less than {length}.
2627     */
2628     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
2629         (bytes32 key, bytes32 value) = _at(map._inner, index);
2630         return (uint256(key), address(uint256(value)));
2631     }
2632 
2633     /**
2634      * @dev Returns the value associated with `key`.  O(1).
2635      *
2636      * Requirements:
2637      *
2638      * - `key` must be in the map.
2639      */
2640     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
2641         return address(uint256(_get(map._inner, bytes32(key))));
2642     }
2643 
2644     /**
2645      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2646      */
2647     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
2648         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
2649     }
2650 }
2651 
2652 
2653 
2654 pragma solidity ^0.6.0;
2655 
2656 /**
2657  * @dev String operations.
2658  */
2659 library Strings {
2660     /**
2661      * @dev Converts a `uint256` to its ASCII `string` representation.
2662      */
2663     function toString(uint256 value) internal pure returns (string memory) {
2664         // Inspired by OraclizeAPI's implementation - MIT licence
2665         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2666 
2667         if (value == 0) {
2668             return "0";
2669         }
2670         uint256 temp = value;
2671         uint256 digits;
2672         while (temp != 0) {
2673             digits++;
2674             temp /= 10;
2675         }
2676         bytes memory buffer = new bytes(digits);
2677         uint256 index = digits - 1;
2678         temp = value;
2679         while (temp != 0) {
2680             buffer[index--] = byte(uint8(48 + temp % 10));
2681             temp /= 10;
2682         }
2683         return string(buffer);
2684     }
2685 }
2686 
2687 
2688 
2689 pragma solidity ^0.6.0;
2690 
2691 
2692 
2693 
2694 
2695 
2696 
2697 
2698 
2699 
2700 
2701 
2702 /**
2703  * @title ERC721 Non-Fungible Token Standard basic implementation
2704  * @dev see https://eips.ethereum.org/EIPS/eip-721
2705  */
2706 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
2707     using SafeMath for uint256;
2708     using Address for address;
2709     using EnumerableSet for EnumerableSet.UintSet;
2710     using EnumerableMap for EnumerableMap.UintToAddressMap;
2711     using Strings for uint256;
2712 
2713     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
2714     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
2715     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
2716 
2717     // Mapping from holder address to their (enumerable) set of owned tokens
2718     mapping (address => EnumerableSet.UintSet) private _holderTokens;
2719 
2720     // Enumerable mapping from token ids to their owners
2721     EnumerableMap.UintToAddressMap private _tokenOwners;
2722 
2723     // Mapping from token ID to approved address
2724     mapping (uint256 => address) private _tokenApprovals;
2725 
2726     // Mapping from owner to operator approvals
2727     mapping (address => mapping (address => bool)) private _operatorApprovals;
2728 
2729     // Token name
2730     string private _name;
2731 
2732     // Token symbol
2733     string private _symbol;
2734 
2735     // Optional mapping for token URIs
2736     mapping(uint256 => string) private _tokenURIs;
2737 
2738     // Base URI
2739     string private _baseURI;
2740 
2741     /*
2742      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
2743      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
2744      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
2745      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
2746      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
2747      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
2748      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
2749      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
2750      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
2751      *
2752      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
2753      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
2754      */
2755     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
2756 
2757     /*
2758      *     bytes4(keccak256('name()')) == 0x06fdde03
2759      *     bytes4(keccak256('symbol()')) == 0x95d89b41
2760      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
2761      *
2762      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
2763      */
2764     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
2765 
2766     /*
2767      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
2768      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
2769      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
2770      *
2771      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
2772      */
2773     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
2774 
2775     /**
2776      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2777      */
2778     constructor (string memory name, string memory symbol) public {
2779         _name = name;
2780         _symbol = symbol;
2781 
2782         // register the supported interfaces to conform to ERC721 via ERC165
2783         _registerInterface(_INTERFACE_ID_ERC721);
2784         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
2785         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
2786     }
2787 
2788     /**
2789      * @dev See {IERC721-balanceOf}.
2790      */
2791     function balanceOf(address owner) public view override returns (uint256) {
2792         require(owner != address(0), "ERC721: balance query for the zero address");
2793 
2794         return _holderTokens[owner].length();
2795     }
2796 
2797     /**
2798      * @dev See {IERC721-ownerOf}.
2799      */
2800     function ownerOf(uint256 tokenId) public view override returns (address) {
2801         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
2802     }
2803 
2804     /**
2805      * @dev See {IERC721Metadata-name}.
2806      */
2807     function name() public view override returns (string memory) {
2808         return _name;
2809     }
2810 
2811     /**
2812      * @dev See {IERC721Metadata-symbol}.
2813      */
2814     function symbol() public view override returns (string memory) {
2815         return _symbol;
2816     }
2817 
2818     /**
2819      * @dev See {IERC721Metadata-tokenURI}.
2820      */
2821     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2822         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2823 
2824         string memory _tokenURI = _tokenURIs[tokenId];
2825 
2826         // If there is no base URI, return the token URI.
2827         if (bytes(_baseURI).length == 0) {
2828             return _tokenURI;
2829         }
2830         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2831         if (bytes(_tokenURI).length > 0) {
2832             return string(abi.encodePacked(_baseURI, _tokenURI));
2833         }
2834         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2835         return string(abi.encodePacked(_baseURI, tokenId.toString()));
2836     }
2837 
2838     /**
2839     * @dev Returns the base URI set via {_setBaseURI}. This will be
2840     * automatically added as a prefix in {tokenURI} to each token's URI, or
2841     * to the token ID if no specific URI is set for that token ID.
2842     */
2843     function baseURI() public view returns (string memory) {
2844         return _baseURI;
2845     }
2846 
2847     /**
2848      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2849      */
2850     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
2851         return _holderTokens[owner].at(index);
2852     }
2853 
2854     /**
2855      * @dev See {IERC721Enumerable-totalSupply}.
2856      */
2857     function totalSupply() public view override returns (uint256) {
2858         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
2859         return _tokenOwners.length();
2860     }
2861 
2862     /**
2863      * @dev See {IERC721Enumerable-tokenByIndex}.
2864      */
2865     function tokenByIndex(uint256 index) public view override returns (uint256) {
2866         (uint256 tokenId, ) = _tokenOwners.at(index);
2867         return tokenId;
2868     }
2869 
2870     /**
2871      * @dev See {IERC721-approve}.
2872      */
2873     function approve(address to, uint256 tokenId) public virtual override {
2874         address owner = ownerOf(tokenId);
2875         require(to != owner, "ERC721: approval to current owner");
2876 
2877         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2878             "ERC721: approve caller is not owner nor approved for all"
2879         );
2880 
2881         _approve(to, tokenId);
2882     }
2883 
2884     /**
2885      * @dev See {IERC721-getApproved}.
2886      */
2887     function getApproved(uint256 tokenId) public view override returns (address) {
2888         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2889 
2890         return _tokenApprovals[tokenId];
2891     }
2892 
2893     /**
2894      * @dev See {IERC721-setApprovalForAll}.
2895      */
2896     function setApprovalForAll(address operator, bool approved) public virtual override {
2897         require(operator != _msgSender(), "ERC721: approve to caller");
2898 
2899         _operatorApprovals[_msgSender()][operator] = approved;
2900         emit ApprovalForAll(_msgSender(), operator, approved);
2901     }
2902 
2903     /**
2904      * @dev See {IERC721-isApprovedForAll}.
2905      */
2906     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
2907         return _operatorApprovals[owner][operator];
2908     }
2909 
2910     /**
2911      * @dev See {IERC721-transferFrom}.
2912      */
2913     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2914         //solhint-disable-next-line max-line-length
2915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2916 
2917         _transfer(from, to, tokenId);
2918     }
2919 
2920     /**
2921      * @dev See {IERC721-safeTransferFrom}.
2922      */
2923     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2924         safeTransferFrom(from, to, tokenId, "");
2925     }
2926 
2927     /**
2928      * @dev See {IERC721-safeTransferFrom}.
2929      */
2930     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2931         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2932         _safeTransfer(from, to, tokenId, _data);
2933     }
2934 
2935     /**
2936      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2937      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2938      *
2939      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2940      *
2941      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2942      * implement alternative mecanisms to perform token transfer, such as signature-based.
2943      *
2944      * Requirements:
2945      *
2946      * - `from` cannot be the zero address.
2947      * - `to` cannot be the zero address.
2948      * - `tokenId` token must exist and be owned by `from`.
2949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2950      *
2951      * Emits a {Transfer} event.
2952      */
2953     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2954         _transfer(from, to, tokenId);
2955         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2956     }
2957 
2958     /**
2959      * @dev Returns whether `tokenId` exists.
2960      *
2961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2962      *
2963      * Tokens start existing when they are minted (`_mint`),
2964      * and stop existing when they are burned (`_burn`).
2965      */
2966     function _exists(uint256 tokenId) internal view returns (bool) {
2967         return _tokenOwners.contains(tokenId);
2968     }
2969 
2970     /**
2971      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2972      *
2973      * Requirements:
2974      *
2975      * - `tokenId` must exist.
2976      */
2977     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
2978         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2979         address owner = ownerOf(tokenId);
2980         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2981     }
2982 
2983     /**
2984      * @dev Safely mints `tokenId` and transfers it to `to`.
2985      *
2986      * Requirements:
2987      d*
2988      * - `tokenId` must not exist.
2989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2990      *
2991      * Emits a {Transfer} event.
2992      */
2993     function _safeMint(address to, uint256 tokenId) internal virtual {
2994         _safeMint(to, tokenId, "");
2995     }
2996 
2997     /**
2998      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2999      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3000      */
3001     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
3002         _mint(to, tokenId);
3003         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
3004     }
3005 
3006     /**
3007      * @dev Mints `tokenId` and transfers it to `to`.
3008      *
3009      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3010      *
3011      * Requirements:
3012      *
3013      * - `tokenId` must not exist.
3014      * - `to` cannot be the zero address.
3015      *
3016      * Emits a {Transfer} event.
3017      */
3018     function _mint(address to, uint256 tokenId) internal virtual {
3019         require(to != address(0), "ERC721: mint to the zero address");
3020         require(!_exists(tokenId), "ERC721: token already minted");
3021 
3022         _beforeTokenTransfer(address(0), to, tokenId);
3023 
3024         _holderTokens[to].add(tokenId);
3025 
3026         _tokenOwners.set(tokenId, to);
3027 
3028         emit Transfer(address(0), to, tokenId);
3029     }
3030 
3031     /**
3032      * @dev Destroys `tokenId`.
3033      * The approval is cleared when the token is burned.
3034      *
3035      * Requirements:
3036      *
3037      * - `tokenId` must exist.
3038      *
3039      * Emits a {Transfer} event.
3040      */
3041     function _burn(uint256 tokenId) internal virtual {
3042         address owner = ownerOf(tokenId);
3043 
3044         _beforeTokenTransfer(owner, address(0), tokenId);
3045 
3046         // Clear approvals
3047         _approve(address(0), tokenId);
3048 
3049         // Clear metadata (if any)
3050         if (bytes(_tokenURIs[tokenId]).length != 0) {
3051             delete _tokenURIs[tokenId];
3052         }
3053 
3054         _holderTokens[owner].remove(tokenId);
3055 
3056         _tokenOwners.remove(tokenId);
3057 
3058         emit Transfer(owner, address(0), tokenId);
3059     }
3060 
3061     /**
3062      * @dev Transfers `tokenId` from `from` to `to`.
3063      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3064      *
3065      * Requirements:
3066      *
3067      * - `to` cannot be the zero address.
3068      * - `tokenId` token must be owned by `from`.
3069      *
3070      * Emits a {Transfer} event.
3071      */
3072     function _transfer(address from, address to, uint256 tokenId) internal virtual {
3073         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
3074         require(to != address(0), "ERC721: transfer to the zero address");
3075 
3076         _beforeTokenTransfer(from, to, tokenId);
3077 
3078         // Clear approvals from the previous owner
3079         _approve(address(0), tokenId);
3080 
3081         _holderTokens[from].remove(tokenId);
3082         _holderTokens[to].add(tokenId);
3083 
3084         _tokenOwners.set(tokenId, to);
3085 
3086         emit Transfer(from, to, tokenId);
3087     }
3088 
3089     /**
3090      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
3091      *
3092      * Requirements:
3093      *
3094      * - `tokenId` must exist.
3095      */
3096     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
3097         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
3098         _tokenURIs[tokenId] = _tokenURI;
3099     }
3100 
3101     /**
3102      * @dev Internal function to set the base URI for all token IDs. It is
3103      * automatically added as a prefix to the value returned in {tokenURI},
3104      * or to the token ID if {tokenURI} is empty.
3105      */
3106     function _setBaseURI(string memory baseURI_) internal virtual {
3107         _baseURI = baseURI_;
3108     }
3109 
3110     /**
3111      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3112      * The call is not executed if the target address is not a contract.
3113      *
3114      * @param from address representing the previous owner of the given token ID
3115      * @param to target address that will receive the tokens
3116      * @param tokenId uint256 ID of the token to be transferred
3117      * @param _data bytes optional data to send along with the call
3118      * @return bool whether the call correctly returned the expected magic value
3119      */
3120     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
3121         private returns (bool)
3122     {
3123         if (!to.isContract()) {
3124             return true;
3125         }
3126         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
3127             IERC721Receiver(to).onERC721Received.selector,
3128             _msgSender(),
3129             from,
3130             tokenId,
3131             _data
3132         ), "ERC721: transfer to non ERC721Receiver implementer");
3133         bytes4 retval = abi.decode(returndata, (bytes4));
3134         return (retval == _ERC721_RECEIVED);
3135     }
3136 
3137     function _approve(address to, uint256 tokenId) private {
3138         _tokenApprovals[tokenId] = to;
3139         emit Approval(ownerOf(tokenId), to, tokenId);
3140     }
3141 
3142     /**
3143      * @dev Hook that is called before any token transfer. This includes minting
3144      * and burning.
3145      *
3146      * Calling conditions:
3147      *
3148      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3149      * transferred to `to`.
3150      * - When `from` is zero, `tokenId` will be minted for `to`.
3151      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3152      * - `from` cannot be the zero address.
3153      * - `to` cannot be the zero address.
3154      *
3155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3156      */
3157     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
3158 }
3159 
3160 
3161 pragma solidity >=0.6.0;
3162 
3163 
3164 
3165 contract MoonbaseTheGameNFT is ERC721, Ownable {
3166     constructor (address moonbaseAirdrop) public ERC721("Moonbase: The Game", "MOONGAME") {
3167         transferOwnership(moonbaseAirdrop);
3168         _setBaseURI("ipfs://ipfs/");
3169     }
3170 
3171     function mint(address to, uint256 tokenId, string memory _tokenURI) public onlyOwner {
3172         _mint(to, tokenId);
3173         _setTokenURI(tokenId, _tokenURI);
3174     }
3175 }
3176 
3177 
3178 pragma solidity >=0.5.0;
3179 
3180 interface IUniswapV2Factory {
3181     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
3182 
3183     function feeTo() external view returns (address);
3184     function feeToSetter() external view returns (address);
3185 
3186     function getPair(address tokenA, address tokenB) external view returns (address pair);
3187     function allPairs(uint) external view returns (address pair);
3188     function allPairsLength() external view returns (uint);
3189 
3190     function createPair(address tokenA, address tokenB) external returns (address pair);
3191 
3192     function setFeeTo(address) external;
3193     function setFeeToSetter(address) external;
3194 }
3195 
3196 
3197 pragma solidity >=0.5.0;
3198 
3199 interface IUniswapV2Pair {
3200     event Approval(address indexed owner, address indexed spender, uint value);
3201     event Transfer(address indexed from, address indexed to, uint value);
3202 
3203     function name() external pure returns (string memory);
3204     function symbol() external pure returns (string memory);
3205     function decimals() external pure returns (uint8);
3206     function totalSupply() external view returns (uint);
3207     function balanceOf(address owner) external view returns (uint);
3208     function allowance(address owner, address spender) external view returns (uint);
3209 
3210     function approve(address spender, uint value) external returns (bool);
3211     function transfer(address to, uint value) external returns (bool);
3212     function transferFrom(address from, address to, uint value) external returns (bool);
3213 
3214     function DOMAIN_SEPARATOR() external view returns (bytes32);
3215     function PERMIT_TYPEHASH() external pure returns (bytes32);
3216     function nonces(address owner) external view returns (uint);
3217 
3218     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
3219 
3220     event Mint(address indexed sender, uint amount0, uint amount1);
3221     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
3222     event Swap(
3223         address indexed sender,
3224         uint amount0In,
3225         uint amount1In,
3226         uint amount0Out,
3227         uint amount1Out,
3228         address indexed to
3229     );
3230     event Sync(uint112 reserve0, uint112 reserve1);
3231 
3232     function MINIMUM_LIQUIDITY() external pure returns (uint);
3233     function factory() external view returns (address);
3234     function token0() external view returns (address);
3235     function token1() external view returns (address);
3236     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
3237     function price0CumulativeLast() external view returns (uint);
3238     function price1CumulativeLast() external view returns (uint);
3239     function kLast() external view returns (uint);
3240 
3241     function mint(address to) external returns (uint liquidity);
3242     function burn(address to) external returns (uint amount0, uint amount1);
3243     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
3244     function skim(address to) external;
3245     function sync() external;
3246 
3247     function initialize(address, address) external;
3248 }
3249 
3250 
3251 pragma solidity >=0.4.0;
3252 
3253 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
3254 library FixedPoint {
3255     // range: [0, 2**112 - 1]
3256     // resolution: 1 / 2**112
3257     struct uq112x112 {
3258         uint224 _x;
3259     }
3260 
3261     // range: [0, 2**144 - 1]
3262     // resolution: 1 / 2**112
3263     struct uq144x112 {
3264         uint _x;
3265     }
3266 
3267     uint8 private constant RESOLUTION = 112;
3268 
3269     // encode a uint112 as a UQ112x112
3270     function encode(uint112 x) internal pure returns (uq112x112 memory) {
3271         return uq112x112(uint224(x) << RESOLUTION);
3272     }
3273 
3274     // encodes a uint144 as a UQ144x112
3275     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
3276         return uq144x112(uint256(x) << RESOLUTION);
3277     }
3278 
3279     // divide a UQ112x112 by a uint112, returning a UQ112x112
3280     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
3281         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
3282         return uq112x112(self._x / uint224(x));
3283     }
3284 
3285     // multiply a UQ112x112 by a uint, returning a UQ144x112
3286     // reverts on overflow
3287     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
3288         uint z;
3289         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
3290         return uq144x112(z);
3291     }
3292 
3293     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
3294     // equivalent to encode(numerator).div(denominator)
3295     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
3296         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
3297         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
3298     }
3299 
3300     // decode a UQ112x112 into a uint112 by truncating after the radix point
3301     function decode(uq112x112 memory self) internal pure returns (uint112) {
3302         return uint112(self._x >> RESOLUTION);
3303     }
3304 
3305     // decode a UQ144x112 into a uint144 by truncating after the radix point
3306     function decode144(uq144x112 memory self) internal pure returns (uint144) {
3307         return uint144(self._x >> RESOLUTION);
3308     }
3309 }
3310 
3311 
3312 pragma solidity >=0.5.0;
3313 
3314 
3315 
3316 // library with helper methods for oracles that are concerned with computing average prices
3317 library UniswapV2OracleLibrary {
3318     using FixedPoint for *;
3319 
3320     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
3321     function currentBlockTimestamp() internal view returns (uint32) {
3322         return uint32(block.timestamp % 2 ** 32);
3323     }
3324 
3325     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
3326     function currentCumulativePrices(
3327         address pair
3328     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
3329         blockTimestamp = currentBlockTimestamp();
3330         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
3331         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
3332 
3333         // if time has elapsed since the last update on the pair, mock the accumulated price values
3334         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
3335         if (blockTimestampLast != blockTimestamp) {
3336             // subtraction overflow is desired
3337             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
3338             // addition overflow is desired
3339             // counterfactual
3340             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
3341             // counterfactual
3342             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
3343         }
3344     }
3345 }
3346 
3347 
3348 
3349 pragma solidity >=0.5.0;
3350 
3351 
3352 
3353 library UniswapV2Library {
3354     using SafeMath for uint;
3355 
3356     // returns sorted token addresses, used to handle return values from pairs sorted in this order
3357     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
3358         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
3359         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
3360         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
3361     }
3362 
3363     // calculates the CREATE2 address for a pair without making any external calls
3364     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
3365         (address token0, address token1) = sortTokens(tokenA, tokenB);
3366         pair = address(uint(keccak256(abi.encodePacked(
3367                 hex'ff',
3368                 factory,
3369                 keccak256(abi.encodePacked(token0, token1)),
3370                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
3371             ))));
3372     }
3373 
3374     // fetches and sorts the reserves for a pair
3375     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
3376         (address token0,) = sortTokens(tokenA, tokenB);
3377         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
3378         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
3379     }
3380 
3381     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
3382     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
3383         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
3384         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
3385         amountB = amountA.mul(reserveB) / reserveA;
3386     }
3387 
3388     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
3389     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
3390         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
3391         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
3392         uint amountInWithFee = amountIn.mul(997);
3393         uint numerator = amountInWithFee.mul(reserveOut);
3394         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
3395         amountOut = numerator / denominator;
3396     }
3397 
3398     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
3399     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
3400         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
3401         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
3402         uint numerator = reserveIn.mul(amountOut).mul(1000);
3403         uint denominator = reserveOut.sub(amountOut).mul(997);
3404         amountIn = (numerator / denominator).add(1);
3405     }
3406 
3407     // performs chained getAmountOut calculations on any number of pairs
3408     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
3409         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
3410         amounts = new uint[](path.length);
3411         amounts[0] = amountIn;
3412         for (uint i; i < path.length - 1; i++) {
3413             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
3414             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
3415         }
3416     }
3417 
3418     // performs chained getAmountIn calculations on any number of pairs
3419     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
3420         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
3421         amounts = new uint[](path.length);
3422         amounts[amounts.length - 1] = amountOut;
3423         for (uint i = path.length - 1; i > 0; i--) {
3424             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
3425             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
3426         }
3427     }
3428 }
3429 
3430 
3431 
3432 pragma solidity >=0.6.6;
3433 
3434 // Some code reproduced from
3435 // https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2Pair.sol
3436 
3437 
3438 
3439 
3440 
3441 
3442 interface IOracle {
3443     function getData() external returns (uint256, bool);
3444 }
3445 
3446 // fixed window oracle that recomputes the average price for the entire period once every period
3447 // note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
3448 contract ExampleOracleSimple {
3449     using FixedPoint for *;
3450 
3451     uint public PERIOD = 24 hours;
3452 
3453     IUniswapV2Pair immutable pair;
3454     address public immutable token0;
3455     address public immutable token1;
3456 
3457     uint    public price0CumulativeLast;
3458     uint    public price1CumulativeLast;
3459     uint32  public blockTimestampLast;
3460     FixedPoint.uq112x112 public price0Average;
3461     FixedPoint.uq112x112 public price1Average;
3462 
3463     constructor(address factory, address tokenA, address tokenB) public {
3464         IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
3465         pair = _pair;
3466         token0 = _pair.token0();
3467         token1 = _pair.token1();
3468         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
3469         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
3470         uint112 reserve0;
3471         uint112 reserve1;
3472         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
3473         // ensure that there's liquidity in the pair
3474         require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES');
3475     }
3476 
3477     function update() internal {
3478         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
3479             UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
3480         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
3481 
3482         // ensure that at least one full period has passed since the last update
3483         require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');
3484 
3485         // overflow is desired, casting never truncates
3486         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
3487         price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
3488         price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));
3489 
3490         price0CumulativeLast = price0Cumulative;
3491         price1CumulativeLast = price1Cumulative;
3492         blockTimestampLast = blockTimestamp;
3493     }
3494 
3495     // note this will always return 0 before update has been called successfully for the first time.
3496     function consult(address token, uint amountIn) internal view returns (uint amountOut) {
3497         if (token == token0) {
3498             amountOut = price0Average.mul(amountIn).decode144();
3499         } else {
3500             require(token == token1, 'ExampleOracleSimple: INVALID_TOKEN');
3501             amountOut = price1Average.mul(amountIn).decode144();
3502         }
3503     }
3504 }
3505 
3506 interface UFragmentsI {
3507     function monetaryPolicy() external view returns (address);
3508 }
3509 
3510 
3511 contract BASEDOracle is Ownable, ExampleOracleSimple, IOracle {
3512 
3513     uint256 constant SCALE = 10 ** 18;
3514     address based;
3515     address constant uniFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
3516 
3517     constructor(address based_, address susd_) public ExampleOracleSimple(uniFactory, based_, susd_) {
3518         PERIOD = 23 hours; // ensure that rebase can always call update
3519         based = based_;
3520     }
3521 
3522     // this must be called 24h before first rebase to get proper price
3523     function updateBeforeRebase() public onlyOwner {
3524         update();
3525     }
3526 
3527     function getData() override external returns (uint256, bool) {
3528         require(msg.sender == UFragmentsI(based).monetaryPolicy());
3529         update();
3530         uint256 price = consult(based, SCALE); // will return 1 BASED in sUSD
3531 
3532         if (price == 0) {
3533             return (0, false);
3534         }
3535 
3536         return (price, true);
3537     }
3538 }
3539 
3540 
3541 pragma solidity >=0.6.0;
3542 
3543 
3544 contract PoolFactory {
3545     function createNewPool(
3546         address _rewardToken,
3547         address _rover,
3548         uint256 _duration,
3549         address _distributor
3550     ) external returns (address) {
3551         _distributor = (_distributor != address(0)) ? _distributor : msg.sender;
3552 
3553         NoMintRewardPool rewardsPool = new NoMintRewardPool(
3554             _rewardToken,
3555             _rover,
3556             _duration,
3557             _distributor  // who can notify of rewards
3558         );
3559 
3560         return address(rewardsPool);
3561     }
3562 }
3563 
3564 
3565 pragma solidity >=0.6.2;
3566 
3567 interface ISakeSwapRouter {
3568     function factory() external pure returns (address);
3569 
3570     function WETH() external pure returns (address);
3571 
3572     function addLiquidity(
3573         address tokenA,
3574         address tokenB,
3575         uint256 amountADesired,
3576         uint256 amountBDesired,
3577         uint256 amountAMin,
3578         uint256 amountBMin,
3579         address to,
3580         uint256 deadline
3581     )
3582         external
3583         returns (
3584             uint256 amountA,
3585             uint256 amountB,
3586             uint256 liquidity
3587         );
3588 
3589     function addLiquidityETH(
3590         address token,
3591         uint256 amountTokenDesired,
3592         uint256 amountTokenMin,
3593         uint256 amountETHMin,
3594         address to,
3595         uint256 deadline
3596     )
3597         external
3598         payable
3599         returns (
3600             uint256 amountToken,
3601             uint256 amountETH,
3602             uint256 liquidity
3603         );
3604 
3605     function removeLiquidity(
3606         address tokenA,
3607         address tokenB,
3608         uint256 liquidity,
3609         uint256 amountAMin,
3610         uint256 amountBMin,
3611         address to,
3612         uint256 deadline
3613     )
3614         external
3615         returns (
3616             uint256 amountA,
3617             uint256 amountB
3618         );
3619 
3620     function removeLiquidityETH(
3621         address token,
3622         uint256 liquidity,
3623         uint256 amountTokenMin,
3624         uint256 amountETHMin,
3625         address to,
3626         uint256 deadline
3627     )
3628         external
3629         returns (
3630             uint256 amountToken,
3631             uint256 amountETH
3632         );
3633 
3634     function removeLiquidityWithPermit(
3635         address tokenA,
3636         address tokenB,
3637         uint256 liquidity,
3638         uint256 amountAMin,
3639         uint256 amountBMin,
3640         address to,
3641         uint256 deadline,
3642         bool approveMax,
3643         uint8 v,
3644         bytes32 r,
3645         bytes32 s
3646     )
3647         external
3648         returns (
3649             uint256 amountA,
3650             uint256 amountB
3651         );
3652 
3653     function removeLiquidityETHWithPermit(
3654         address token,
3655         uint256 liquidity,
3656         uint256 amountTokenMin,
3657         uint256 amountETHMin,
3658         address to,
3659         uint256 deadline,
3660         bool approveMax,
3661         uint8 v,
3662         bytes32 r,
3663         bytes32 s
3664     )
3665         external
3666         returns (
3667             uint256 amountToken,
3668             uint256 amountETH
3669         );
3670 
3671     function swapExactTokensForTokens(
3672         uint256 amountIn,
3673         uint256 amountOutMin,
3674         address[] calldata path,
3675         address to,
3676         uint256 deadline,
3677         bool ifmint
3678     ) external returns (uint256[] memory amounts);
3679 
3680     function swapTokensForExactTokens(
3681         uint256 amountOut,
3682         uint256 amountInMax,
3683         address[] calldata path,
3684         address to,
3685         uint256 deadline,
3686         bool ifmint
3687     ) external returns (uint256[] memory amounts);
3688 
3689     function swapExactETHForTokens(
3690         uint256 amountOutMin,
3691         address[] calldata path,
3692         address to,
3693         uint256 deadline,
3694         bool ifmint
3695     ) external payable returns (uint256[] memory amounts);
3696 
3697     function swapTokensForExactETH(
3698         uint256 amountOut,
3699         uint256 amountInMax,
3700         address[] calldata path,
3701         address to,
3702         uint256 deadline,
3703         bool ifmint
3704     ) external returns (uint256[] memory amounts);
3705 
3706     function swapExactTokensForETH(
3707         uint256 amountIn,
3708         uint256 amountOutMin,
3709         address[] calldata path,
3710         address to,
3711         uint256 deadline,
3712         bool ifmint
3713     ) external returns (uint256[] memory amounts);
3714 
3715     function swapETHForExactTokens(
3716         uint256 amountOut,
3717         address[] calldata path,
3718         address to,
3719         uint256 deadline,
3720         bool ifmint
3721     ) external payable returns (uint256[] memory amounts);
3722 
3723     function quote(
3724         uint256 amountA,
3725         uint256 reserveA,
3726         uint256 reserveB
3727     ) external pure returns (uint256 amountB);
3728 
3729     function getAmountOut(
3730         uint256 amountIn,
3731         uint256 reserveIn,
3732         uint256 reserveOut
3733     ) external pure returns (uint256 amountOut);
3734 
3735     function getAmountIn(
3736         uint256 amountOut,
3737         uint256 reserveIn,
3738         uint256 reserveOut
3739     ) external pure returns (uint256 amountIn);
3740 
3741     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
3742 
3743     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
3744 
3745     function removeLiquidityETHSupportingFeeOnTransferTokens(
3746         address token,
3747         uint256 liquidity,
3748         uint256 amountTokenMin,
3749         uint256 amountETHMin,
3750         address to,
3751         uint256 deadline
3752     ) external returns (uint256 amountETH);
3753 
3754     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
3755         address token,
3756         uint256 liquidity,
3757         uint256 amountTokenMin,
3758         uint256 amountETHMin,
3759         address to,
3760         uint256 deadline,
3761         bool approveMax,
3762         uint8 v,
3763         bytes32 r,
3764         bytes32 s
3765     ) external returns (uint256 amountETH);
3766 
3767     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
3768         uint256 amountIn,
3769         uint256 amountOutMin,
3770         address[] calldata path,
3771         address to,
3772         uint256 deadline,
3773         bool ifmint
3774     ) external;
3775 
3776     function swapExactETHForTokensSupportingFeeOnTransferTokens(
3777         uint256 amountOutMin,
3778         address[] calldata path,
3779         address to,
3780         uint256 deadline,
3781         bool ifmint
3782     ) external payable;
3783 
3784     function swapExactTokensForETHSupportingFeeOnTransferTokens(
3785         uint256 amountIn,
3786         uint256 amountOutMin,
3787         address[] calldata path,
3788         address to,
3789         uint256 deadline,
3790         bool ifmint
3791     ) external;
3792 }
3793 
3794 
3795 pragma solidity >=0.6.0;
3796 
3797 
3798 
3799 
3800 
3801 contract SakeSwapModule {
3802     using SafeERC20 for IERC20;
3803 
3804     address public immutable sakeSwapRouter;
3805     address public immutable uniswapRouter;
3806 
3807     constructor (address _uniswapRouter, address _sakeSwapRouter) public {
3808         uniswapRouter = _uniswapRouter;
3809         sakeSwapRouter = _sakeSwapRouter;
3810     }
3811 
3812     function getPaths(address[] memory path) public pure returns (address[] memory, address[] memory) {
3813         address[] memory sakePath = new address[](2);
3814         address[] memory uniswapPath = new address[](2);
3815         sakePath[0] = path[0];
3816         sakePath[1] = path[1];
3817         uniswapPath[0] = path[1];
3818         uniswapPath[1] = path[2];
3819         return (sakePath, uniswapPath);
3820     }
3821 
3822     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint256[] memory) {
3823         (address[] memory sakePath, address[] memory uniswapPath) = getPaths(path);
3824         uint256[] memory amounts = new uint256[](2);
3825         uint256[] memory sakeAmounts = ISakeSwapRouter(sakeSwapRouter).getAmountsOut(amountIn, sakePath);
3826         amounts[0] = sakeAmounts[sakeAmounts.length - 1];
3827         uint256[] memory uniswapAmounts = IUniswapV2Router02(uniswapRouter).getAmountsOut(amounts[0], uniswapPath);
3828         amounts[1] = uniswapAmounts[uniswapAmounts.length - 1];
3829         return amounts;
3830     }
3831 
3832     function swapReward(uint256 amountIn, address receiver, address[] memory path) public returns (uint256){
3833         (address[] memory sakePath, address[] memory uniswapPath) = getPaths(path);
3834 
3835         IERC20(path[0]).safeApprove(sakeSwapRouter, 0);
3836         IERC20(path[0]).safeApprove(sakeSwapRouter, amountIn);
3837         uint256 amountOutMin = 1;
3838         uint256[] memory amounts =
3839             ISakeSwapRouter(sakeSwapRouter).swapExactTokensForTokens(
3840                 amountIn,
3841                 amountOutMin,
3842                 sakePath,
3843                 receiver,
3844                 block.timestamp,
3845                 false
3846             );
3847         amountIn = amounts[amounts.length - 1];
3848 
3849         IERC20(path[1]).safeApprove(uniswapRouter, 0);
3850         IERC20(path[1]).safeApprove(uniswapRouter, amountIn);
3851         amounts =
3852             IUniswapV2Router02(uniswapRouter).swapExactTokensForTokens(
3853                 amountIn,
3854                 amountOutMin,
3855                 uniswapPath,
3856                 receiver,
3857                 block.timestamp
3858             );
3859         return amounts[amounts.length - 1];
3860     }
3861 }
3862 
3863 
3864 pragma solidity >=0.6.0;
3865 
3866 
3867 
3868 
3869 contract UniswapModule {
3870     using SafeERC20 for IERC20;
3871 
3872     address public immutable uniswapRouter;
3873 
3874     constructor (address _uniswapRouter) public {
3875         uniswapRouter = _uniswapRouter;
3876     }
3877     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory) {
3878         return IUniswapV2Router02(uniswapRouter).getAmountsOut(amountIn, path);
3879     }
3880 
3881     function swapReward(uint256 amountIn, address receiver, address[] memory path) public returns (uint256){
3882         // ensure we have no over-approval
3883         IERC20(path[0]).safeApprove(uniswapRouter, 0);
3884         IERC20(path[0]).safeApprove(uniswapRouter, amountIn);
3885         uint256 amountOutMin = 1;
3886         uint256[] memory amounts =
3887             IUniswapV2Router02(uniswapRouter).swapExactTokensForTokens(
3888                 amountIn,
3889                 amountOutMin,
3890                 path,
3891                 receiver,
3892                 block.timestamp
3893             );
3894         return amounts[amounts.length - 1];
3895     }
3896 }
3897 
3898 
3899 pragma solidity >=0.6.0;
3900 
3901 interface IMoonBase {
3902     function notifyRewardAmount(uint256 reward) external;
3903 }
3904 
3905 
3906 pragma solidity >=0.6.0;
3907 
3908 interface IRover {
3909     function transferOwnership(address newOwner) external;
3910 }
3911 
3912 
3913 pragma solidity >=0.6.0;
3914 
3915 interface IScheduleProvider {
3916     function getSchedule() external view returns (uint256);
3917 }