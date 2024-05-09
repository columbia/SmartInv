1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/math/SafeMath.sol
97 
98 
99 pragma solidity >=0.6.0 <0.8.0;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/math/SignedSafeMath.sol
258 
259 
260 pragma solidity >=0.6.0 <0.8.0;
261 
262 /**
263  * @title SignedSafeMath
264  * @dev Signed math operations with safety checks that revert on error.
265  */
266 library SignedSafeMath {
267     int256 constant private _INT256_MIN = -2**255;
268 
269     /**
270      * @dev Returns the multiplication of two signed integers, reverting on
271      * overflow.
272      *
273      * Counterpart to Solidity's `*` operator.
274      *
275      * Requirements:
276      *
277      * - Multiplication cannot overflow.
278      */
279     function mul(int256 a, int256 b) internal pure returns (int256) {
280         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
281         // benefit is lost if 'b' is also tested.
282         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
283         if (a == 0) {
284             return 0;
285         }
286 
287         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
288 
289         int256 c = a * b;
290         require(c / a == b, "SignedSafeMath: multiplication overflow");
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the integer division of two signed integers. Reverts on
297      * division by zero. The result is rounded towards zero.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function div(int256 a, int256 b) internal pure returns (int256) {
308         require(b != 0, "SignedSafeMath: division by zero");
309         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
310 
311         int256 c = a / b;
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the subtraction of two signed integers, reverting on
318      * overflow.
319      *
320      * Counterpart to Solidity's `-` operator.
321      *
322      * Requirements:
323      *
324      * - Subtraction cannot overflow.
325      */
326     function sub(int256 a, int256 b) internal pure returns (int256) {
327         int256 c = a - b;
328         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the addition of two signed integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `+` operator.
338      *
339      * Requirements:
340      *
341      * - Addition cannot overflow.
342      */
343     function add(int256 a, int256 b) internal pure returns (int256) {
344         int256 c = a + b;
345         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
346 
347         return c;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
352 
353 
354 pragma solidity >=0.6.0 <0.8.0;
355 
356 /**
357  * @dev Interface of the ERC20 standard as defined in the EIP.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: @openzeppelin/contracts/utils/Address.sol
431 
432 
433 pragma solidity >=0.6.2 <0.8.0;
434 
435 /**
436  * @dev Collection of functions related to the address type
437  */
438 library Address {
439     /**
440      * @dev Returns true if `account` is a contract.
441      *
442      * [IMPORTANT]
443      * ====
444      * It is unsafe to assume that an address for which this function returns
445      * false is an externally-owned account (EOA) and not a contract.
446      *
447      * Among others, `isContract` will return false for the following
448      * types of addresses:
449      *
450      *  - an externally-owned account
451      *  - a contract in construction
452      *  - an address where a contract will be created
453      *  - an address where a contract lived, but was destroyed
454      * ====
455      */
456     function isContract(address account) internal view returns (bool) {
457         // This method relies on extcodesize, which returns 0 for contracts in
458         // construction, since the code is only stored at the end of the
459         // constructor execution.
460 
461         uint256 size;
462         // solhint-disable-next-line no-inline-assembly
463         assembly { size := extcodesize(account) }
464         return size > 0;
465     }
466 
467     /**
468      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
469      * `recipient`, forwarding all available gas and reverting on errors.
470      *
471      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
472      * of certain opcodes, possibly making contracts go over the 2300 gas limit
473      * imposed by `transfer`, making them unable to receive funds via
474      * `transfer`. {sendValue} removes this limitation.
475      *
476      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
477      *
478      * IMPORTANT: because control is transferred to `recipient`, care must be
479      * taken to not create reentrancy vulnerabilities. Consider using
480      * {ReentrancyGuard} or the
481      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
482      */
483     function sendValue(address payable recipient, uint256 amount) internal {
484         require(address(this).balance >= amount, "Address: insufficient balance");
485 
486         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
487         (bool success, ) = recipient.call{ value: amount }("");
488         require(success, "Address: unable to send value, recipient may have reverted");
489     }
490 
491     /**
492      * @dev Performs a Solidity function call using a low level `call`. A
493      * plain`call` is an unsafe replacement for a function call: use this
494      * function instead.
495      *
496      * If `target` reverts with a revert reason, it is bubbled up by this
497      * function (like regular Solidity function calls).
498      *
499      * Returns the raw returned data. To convert to the expected return value,
500      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
501      *
502      * Requirements:
503      *
504      * - `target` must be a contract.
505      * - calling `target` with `data` must not revert.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
510       return functionCall(target, data, "Address: low-level call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
515      * `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
520         return functionCallWithValue(target, data, 0, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but also transferring `value` wei to `target`.
526      *
527      * Requirements:
528      *
529      * - the calling contract must have an ETH balance of at least `value`.
530      * - the called Solidity function must be `payable`.
531      *
532      * _Available since v3.1._
533      */
534     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
540      * with `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         // solhint-disable-next-line avoid-low-level-calls
549         (bool success, bytes memory returndata) = target.call{ value: value }(data);
550         return _verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         // solhint-disable-next-line avoid-low-level-calls
573         (bool success, bytes memory returndata) = target.staticcall(data);
574         return _verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             // Look for revert reason and bubble it up if present
582             if (returndata.length > 0) {
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585                 // solhint-disable-next-line no-inline-assembly
586                 assembly {
587                     let returndata_size := mload(returndata)
588                     revert(add(32, returndata), returndata_size)
589                 }
590             } else {
591                 revert(errorMessage);
592             }
593         }
594     }
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
598 
599 
600 pragma solidity >=0.6.0 <0.8.0;
601 
602 
603 
604 
605 /**
606  * @title SafeERC20
607  * @dev Wrappers around ERC20 operations that throw on failure (when the token
608  * contract returns false). Tokens that return no value (and instead revert or
609  * throw on failure) are also supported, non-reverting calls are assumed to be
610  * successful.
611  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
612  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
613  */
614 library SafeERC20 {
615     using SafeMath for uint256;
616     using Address for address;
617 
618     function safeTransfer(IERC20 token, address to, uint256 value) internal {
619         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
620     }
621 
622     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
623         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
624     }
625 
626     /**
627      * @dev Deprecated. This function has issues similar to the ones found in
628      * {IERC20-approve}, and its usage is discouraged.
629      *
630      * Whenever possible, use {safeIncreaseAllowance} and
631      * {safeDecreaseAllowance} instead.
632      */
633     function safeApprove(IERC20 token, address spender, uint256 value) internal {
634         // safeApprove should only be called when setting an initial allowance,
635         // or when resetting it to zero. To increase and decrease it, use
636         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
637         // solhint-disable-next-line max-line-length
638         require((value == 0) || (token.allowance(address(this), spender) == 0),
639             "SafeERC20: approve from non-zero to non-zero allowance"
640         );
641         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
642     }
643 
644     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
645         uint256 newAllowance = token.allowance(address(this), spender).add(value);
646         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
647     }
648 
649     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
650         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
651         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
652     }
653 
654     /**
655      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
656      * on the return value: the return value is optional (but if data is returned, it must not be false).
657      * @param token The token targeted by the call.
658      * @param data The call data (encoded using abi.encode or one of its variants).
659      */
660     function _callOptionalReturn(IERC20 token, bytes memory data) private {
661         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
662         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
663         // the target address contains contract code and also asserts for success in the low-level call.
664 
665         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
666         if (returndata.length > 0) { // Return data is optional
667             // solhint-disable-next-line max-line-length
668             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
669         }
670     }
671 }
672 
673 // File: contracts/Uniswap.sol
674 
675 
676 pragma solidity 0.6.12;
677 
678 
679 interface IUniswapV2Pair {
680     function getReserves() external view returns (uint112 r0, uint112 r1, uint32 blockTimestampLast);
681     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
682 }
683 
684 interface IUniswapV2Factory {
685     function getPair(address a, address b) external view returns (address p);
686 }
687 
688 interface IUniswapV2Router02 {
689     function WETH() external returns (address);
690 
691     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
692         uint amountIn,
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external;
698 }
699 
700 library UniswapV2Library {
701     using SafeMath for uint;
702 
703     // returns sorted token addresses, used to handle return values from pairs sorted in this order
704     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
705         require(tokenA != tokenB, 'UV2: IDENTICAL_ADDRESSES');
706         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
707         require(token0 != address(0), 'UV2: ZERO_ADDRESS');
708     }
709     
710     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
711     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
712         require(amountIn > 0, 'UV2: INSUFFICIENT_INPUT_AMOUNT');
713         require(reserveIn > 0 && reserveOut > 0, 'UV2: INSUFFICIENT_LIQUIDITY');
714         uint amountInWithFee = amountIn.mul(997);
715         uint numerator = amountInWithFee.mul(reserveOut);
716         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
717         amountOut = numerator / denominator;
718     }
719 }
720 
721 // File: contracts/UniMexStaking.sol
722 
723 // SPDX-License-Identifier: UNLICENSED
724 
725 pragma solidity 0.6.12;
726 
727 
728 
729 
730 
731 
732 
733 contract UniMexStaking is Ownable {
734     using SignedSafeMath for int256;
735     using SafeMath for uint256;
736     using SafeERC20 for IERC20;
737 
738     uint256 private constant FLOAT_SCALAR = 2**64;
739 
740     uint256 public stakersBalance;
741     uint256 public trustSwapStakersBalance;
742     uint256 public yieldxStakersBalance;
743     uint256 public teamPlusLiquidationReserve;
744 
745     uint256 public percentFactor = 1e3;
746     uint256 public trustSwapPercentScaled = 125; //12.5%
747     uint256 public yieldxStakersPercentScaled = 125; //12.5%
748     uint256 public teamPercentScaled = 125; //12.5%
749 
750     address public trustSwapAddress;
751     address public yieldxStakersAddress;
752     address public teamAddress;
753 
754     address public uniswapRouter;
755 
756     struct User {
757         uint256 balance;
758         int256 scaledPayout;
759     }
760 
761     IERC20 public token;
762     IERC20 public WETH;
763     uint256 public divPerShare;
764 
765     mapping(address => User) public users;
766 
767     event OnDeposit(address indexed from, uint256 amount);
768     event OnWithdraw(address indexed from, uint256 amount);
769     event OnClaim(address indexed from, uint256 amount);
770     event OnTransfer(address indexed from, address indexed to, uint256 amount);
771     
772     constructor(address _uniswapRouter, address _weth, address _trustSwap, address _yieldxStakers, address _team) public {
773         require(_uniswapRouter != address(0) && _weth != address(0) && _trustSwap != address(0) &&
774             _yieldxStakers != address(0) && _team != address(0), "ZERO_ADDRESS");
775         WETH = IERC20(_weth);
776         uniswapRouter = _uniswapRouter;
777         trustSwapAddress = _trustSwap;
778         yieldxStakersAddress = _yieldxStakers;
779         teamAddress = _team;
780     }
781 
782     function setToken(address _token) external onlyOwner {
783         require(address(token) == address(0));
784         token = IERC20(_token);
785     }
786 
787     function totalSupply() private view returns (uint256) {
788         return token.balanceOf(address(this));
789     }
790 
791     function setTrustSwapAddress(address _newAddr) public onlyOwner {
792         require(_newAddr != address(0));
793         trustSwapAddress = _newAddr;
794     }
795 
796     function setYieldXAddress(address _newAddr) public onlyOwner {
797         require(_newAddr != address(0));
798         yieldxStakersAddress = _newAddr;
799     }
800 
801     function setTeamAddress(address _newAddr) public onlyOwner {
802         require(_newAddr != address(0));
803         teamAddress = _newAddr;
804     }
805 
806     //@dev deposit dust token upon deployment to prevent division by zero 
807     function distribute(uint256 _amount) external returns(bool) {
808         WETH.safeTransferFrom(address(msg.sender), address(this), _amount);
809 
810         uint256 trustSwapPart = _amount.mul(trustSwapPercentScaled).div(percentFactor);
811         trustSwapStakersBalance = trustSwapStakersBalance.add(trustSwapPart);
812 
813         uint256 yieldxStakersPart = _amount.mul(yieldxStakersPercentScaled).div(percentFactor);
814         yieldxStakersBalance = yieldxStakersBalance.add(yieldxStakersPart);
815 
816         uint256 teamPart = _amount.mul(teamPercentScaled).div(percentFactor);
817         teamPlusLiquidationReserve = teamPlusLiquidationReserve.add(teamPart);
818 
819         uint256 stakersPart = _amount.sub(trustSwapPart).sub(yieldxStakersPart).sub(teamPart);
820 
821         divPerShare = divPerShare.add((stakersPart.mul(FLOAT_SCALAR)).div(totalSupply()));
822     }
823 
824     function distributeDivs() external returns(bool) {
825         uint256 trustSwapBalanceCopy = trustSwapStakersBalance;
826         trustSwapStakersBalance = 0;
827         uint256 teamBalanceCopy = teamPlusLiquidationReserve;
828         teamPlusLiquidationReserve = 0;
829         uint256 yieldxBalanceCopy = yieldxStakersBalance;
830         yieldxStakersBalance = 0;
831 
832         WETH.safeTransfer(yieldxStakersAddress, yieldxBalanceCopy);
833         WETH.safeTransfer(teamAddress, teamBalanceCopy);
834         WETH.safeTransfer(trustSwapAddress, trustSwapBalanceCopy);
835         return true;
836     }
837 
838     function deposit(uint256 _amount) external {
839         token.safeTransferFrom(msg.sender, address(this), _amount);
840         depositFrom(_amount);
841     }
842     
843     function depositFrom(uint256 _amount) private {
844         users[msg.sender].balance = users[msg.sender].balance.add(_amount);
845         users[msg.sender].scaledPayout = users[msg.sender].scaledPayout.add(
846             int256(_amount.mul(divPerShare))
847         );
848         emit OnDeposit(msg.sender, _amount);
849     }
850 
851     function withdraw(uint256 _amount) external {
852         require(balanceOf(msg.sender) >= _amount);
853         users[msg.sender].balance = users[msg.sender].balance.sub(_amount);
854         users[msg.sender].scaledPayout = users[msg.sender].scaledPayout.sub(
855             int256(_amount.mul(divPerShare))
856         );
857         token.safeTransfer(msg.sender, _amount);
858         emit OnWithdraw(msg.sender, _amount);
859     }
860 
861     function claim() external {
862         uint256 _dividends = dividendsOf(msg.sender);
863         require(_dividends > 0);
864         users[msg.sender].scaledPayout = users[msg.sender].scaledPayout.add(
865             int256(_dividends.mul(FLOAT_SCALAR))
866         );
867         WETH.safeTransfer(address(msg.sender), _dividends);
868         emit OnClaim(msg.sender, _dividends);
869     }
870 
871     function reinvestWithMinimalAmountOut(uint256 delay, uint256 minimalAmountOut) public {
872         uint256 dividends = dividendsOf(msg.sender);
873         require(dividends > 0);
874         users[msg.sender].scaledPayout = users[msg.sender].scaledPayout.add(
875             int256(dividends.mul(FLOAT_SCALAR))
876         );
877         WETH.approve(address(uniswapRouter), dividends);
878 
879         uint256 balanceBefore = IERC20(token).balanceOf(address(this));
880 
881         address[] memory path = new address[](2);
882         path[0] = address(WETH);
883         path[1] = address(token);
884 
885         IUniswapV2Router02(uniswapRouter)
886             .swapExactTokensForTokensSupportingFeeOnTransferTokens(
887                 dividends,
888                 minimalAmountOut,
889                 path,
890                 address(this),
891                 block.timestamp.add(delay)
892             );
893         uint256 balanceAfter = IERC20(token).balanceOf(address(this));
894         uint convertedTokens = balanceAfter.sub(balanceBefore);
895         require(convertedTokens > 0, "ZERO_CONVERT");
896         depositFrom(convertedTokens);
897     }
898 
899     function reinvest(uint256 delay) external {
900         reinvestWithMinimalAmountOut(delay, 0);
901     }
902 
903     function transfer(address _to, uint256 _amount) external returns (bool) {
904         return _transfer(msg.sender, _to, _amount);
905     }
906 
907     function balanceOf(address _user) public view returns (uint256) {
908         return users[_user].balance;
909     }
910 
911     function dividendsOf(address _user) public view returns (uint256) {
912         return
913             uint256(
914                 int256(divPerShare.mul(balanceOf(_user))).sub(
915                     users[_user].scaledPayout
916                 )
917             )
918                 .div(FLOAT_SCALAR);
919     }
920 
921     function _transfer(
922         address _from,
923         address _to,
924         uint256 _amount
925     ) internal returns (bool) {
926         require(users[_from].balance >= _amount);
927         users[_from].balance = users[_from].balance.sub(_amount);
928         users[_from].scaledPayout = users[_from].scaledPayout.sub(
929             int256(_amount.mul(divPerShare))
930         );
931         users[_to].balance = users[_to].balance.add(_amount);
932         users[_to].scaledPayout = users[_to].scaledPayout.add(
933             int256(_amount.mul(divPerShare))
934         );
935         emit OnTransfer(msg.sender, _to, _amount);
936     }
937 }