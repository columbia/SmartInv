1 //          
2 //              &&&&
3 //              &&&&
4 //              &&&&
5 //              &&&&  &&&&&&&&&       &&&&&&&&&&&&          &&&&&&&&&&/   &&&&.&&&&&&&&&
6 //              &&&&&&&&&   &&&&&   &&&&&&     &&&&&,     &&&&&    &&&&&  &&&&&&&&   &&&&
7 //               &&&&&&      &&&&  &&&&#         &&&&   &&&&&       &&&&& &&&&&&     &&&&&
8 //               &&&&&       &&&&/ &&&&           &&&& #&&&&        &&&&  &&&&&
9 //               &&&&         &&&& &&&&&         &&&&  &&&&        &&&&&  &&&&&
10 //               %%%%        /%%%%   %%%%%%   %%%%%%   %%%%  %%%%%%%%%    %%%%%
11 //              %%%%%        %%%%      %%%%%%%%%%%    %%%%   %%%%%%       %%%%
12 //                                                    %%%%
13 //                                                    %%%%
14 //                                                    %%%%
15 //
16 
17 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
18 
19 pragma solidity >=0.5.0;
20 
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31 
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35 
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39 
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41 
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53 
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62 
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68 
69     function initialize(address, address) external;
70 }
71 
72 
73 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.0
74 
75 pragma solidity >=0.6.0 <0.8.0;
76 
77 /**
78  * @dev Interface of the ERC20 standard as defined in the EIP.
79  */
80 interface IERC20 {
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90 
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `recipient`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Returns the remaining number of tokens that `spender` will be
102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
103      * zero by default.
104      *
105      * This value changes when {approve} or {transferFrom} are called.
106      */
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     /**
110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
115      * that someone may use both the old and the new allowance by unfortunate
116      * transaction ordering. One possible solution to mitigate this race
117      * condition is to first reduce the spender's allowance to 0 and set the
118      * desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address spender, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Moves `amount` tokens from `sender` to `recipient` using the
127      * allowance mechanism. `amount` is then deducted from the caller's
128      * allowance.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
138      * another (`to`).
139      *
140      * Note that `value` may be zero.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /**
145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
146      * a call to {approve}. `value` is the new allowance.
147      */
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
153 
154 pragma solidity >=0.6.0 <0.8.0;
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations with added overflow
158  * checks.
159  *
160  * Arithmetic operations in Solidity wrap on overflow. This can easily result
161  * in bugs, because programmers usually assume that an overflow raises an
162  * error, which is the standard behavior in high level programming languages.
163  * `SafeMath` restores this intuition by reverting the transaction when an
164  * operation overflows.
165  *
166  * Using this library instead of the unchecked operations eliminates an entire
167  * class of bugs, so it's recommended to use it always.
168  */
169 library SafeMath {
170     /**
171      * @dev Returns the addition of two unsigned integers, with an overflow flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         uint256 c = a + b;
177         if (c < a) return (false, 0);
178         return (true, c);
179     }
180 
181     /**
182      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
183      *
184      * _Available since v3.4._
185      */
186     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         if (b > a) return (false, 0);
188         return (true, a - b);
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
193      *
194      * _Available since v3.4._
195      */
196     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) return (true, 0);
201         uint256 c = a * b;
202         if (c / a != b) return (false, 0);
203         return (true, c);
204     }
205 
206     /**
207      * @dev Returns the division of two unsigned integers, with a division by zero flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         if (b == 0) return (false, 0);
213         return (true, a / b);
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         if (b == 0) return (false, 0);
223         return (true, a % b);
224     }
225 
226     /**
227      * @dev Returns the addition of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `+` operator.
231      *
232      * Requirements:
233      *
234      * - Addition cannot overflow.
235      */
236     function add(uint256 a, uint256 b) internal pure returns (uint256) {
237         uint256 c = a + b;
238         require(c >= a, "SafeMath: addition overflow");
239         return c;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         require(b <= a, "SafeMath: subtraction overflow");
254         return a - b;
255     }
256 
257     /**
258      * @dev Returns the multiplication of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `*` operator.
262      *
263      * Requirements:
264      *
265      * - Multiplication cannot overflow.
266      */
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         if (a == 0) return 0;
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271         return c;
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         require(b > 0, "SafeMath: division by zero");
288         return a / b;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * reverting when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         require(b > 0, "SafeMath: modulo by zero");
305         return a % b;
306     }
307 
308     /**
309      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
310      * overflow (when the result is negative).
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {trySub}.
314      *
315      * Counterpart to Solidity's `-` operator.
316      *
317      * Requirements:
318      *
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b <= a, errorMessage);
323         return a - b;
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
328      * division by zero. The result is rounded towards zero.
329      *
330      * CAUTION: This function is deprecated because it requires allocating memory for the error
331      * message unnecessarily. For custom revert reasons use {tryDiv}.
332      *
333      * Counterpart to Solidity's `/` operator. Note: this function uses a
334      * `revert` opcode (which leaves remaining gas untouched) while Solidity
335      * uses an invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b > 0, errorMessage);
343         return a / b;
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * reverting with custom message when dividing by zero.
349      *
350      * CAUTION: This function is deprecated because it requires allocating memory for the error
351      * message unnecessarily. For custom revert reasons use {tryMod}.
352      *
353      * Counterpart to Solidity's `%` operator. This function uses a `revert`
354      * opcode (which leaves remaining gas untouched) while Solidity uses an
355      * invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      *
359      * - The divisor cannot be zero.
360      */
361     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
362         require(b > 0, errorMessage);
363         return a % b;
364     }
365 }
366 
367 
368 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
369 
370 pragma solidity >=0.6.2 <0.8.0;
371 
372 /**
373  * @dev Collection of functions related to the address type
374  */
375 library Address {
376     /**
377      * @dev Returns true if `account` is a contract.
378      *
379      * [IMPORTANT]
380      * ====
381      * It is unsafe to assume that an address for which this function returns
382      * false is an externally-owned account (EOA) and not a contract.
383      *
384      * Among others, `isContract` will return false for the following
385      * types of addresses:
386      *
387      *  - an externally-owned account
388      *  - a contract in construction
389      *  - an address where a contract will be created
390      *  - an address where a contract lived, but was destroyed
391      * ====
392      */
393     function isContract(address account) internal view returns (bool) {
394         // This method relies on extcodesize, which returns 0 for contracts in
395         // construction, since the code is only stored at the end of the
396         // constructor execution.
397 
398         uint256 size;
399         // solhint-disable-next-line no-inline-assembly
400         assembly { size := extcodesize(account) }
401         return size > 0;
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(address(this).balance >= amount, "Address: insufficient balance");
422 
423         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
424         (bool success, ) = recipient.call{ value: amount }("");
425         require(success, "Address: unable to send value, recipient may have reverted");
426     }
427 
428     /**
429      * @dev Performs a Solidity function call using a low level `call`. A
430      * plain`call` is an unsafe replacement for a function call: use this
431      * function instead.
432      *
433      * If `target` reverts with a revert reason, it is bubbled up by this
434      * function (like regular Solidity function calls).
435      *
436      * Returns the raw returned data. To convert to the expected return value,
437      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
438      *
439      * Requirements:
440      *
441      * - `target` must be a contract.
442      * - calling `target` with `data` must not revert.
443      *
444      * _Available since v3.1._
445      */
446     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
447       return functionCall(target, data, "Address: low-level call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
452      * `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
477      * with `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
482         require(address(this).balance >= value, "Address: insufficient balance for call");
483         require(isContract(target), "Address: call to non-contract");
484 
485         // solhint-disable-next-line avoid-low-level-calls
486         (bool success, bytes memory returndata) = target.call{ value: value }(data);
487         return _verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         // solhint-disable-next-line avoid-low-level-calls
510         (bool success, bytes memory returndata) = target.staticcall(data);
511         return _verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but performing a delegate call.
517      *
518      * _Available since v3.4._
519      */
520     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
521         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
526      * but performing a delegate call.
527      *
528      * _Available since v3.4._
529      */
530     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         // solhint-disable-next-line avoid-low-level-calls
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return _verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
539         if (success) {
540             return returndata;
541         } else {
542             // Look for revert reason and bubble it up if present
543             if (returndata.length > 0) {
544                 // The easiest way to bubble the revert reason is using memory via assembly
545 
546                 // solhint-disable-next-line no-inline-assembly
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 
559 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.0
560 
561 pragma solidity >=0.6.0 <0.8.0;
562 
563 /**
564  * @title SafeERC20
565  * @dev Wrappers around ERC20 operations that throw on failure (when the token
566  * contract returns false). Tokens that return no value (and instead revert or
567  * throw on failure) are also supported, non-reverting calls are assumed to be
568  * successful.
569  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
570  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
571  */
572 library SafeERC20 {
573     using SafeMath for uint256;
574     using Address for address;
575 
576     function safeTransfer(IERC20 token, address to, uint256 value) internal {
577         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
578     }
579 
580     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
581         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
582     }
583 
584     /**
585      * @dev Deprecated. This function has issues similar to the ones found in
586      * {IERC20-approve}, and its usage is discouraged.
587      *
588      * Whenever possible, use {safeIncreaseAllowance} and
589      * {safeDecreaseAllowance} instead.
590      */
591     function safeApprove(IERC20 token, address spender, uint256 value) internal {
592         // safeApprove should only be called when setting an initial allowance,
593         // or when resetting it to zero. To increase and decrease it, use
594         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
595         // solhint-disable-next-line max-line-length
596         require((value == 0) || (token.allowance(address(this), spender) == 0),
597             "SafeERC20: approve from non-zero to non-zero allowance"
598         );
599         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
600     }
601 
602     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
603         uint256 newAllowance = token.allowance(address(this), spender).add(value);
604         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
605     }
606 
607     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
608         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
609         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
610     }
611 
612     /**
613      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
614      * on the return value: the return value is optional (but if data is returned, it must not be false).
615      * @param token The token targeted by the call.
616      * @param data The call data (encoded using abi.encode or one of its variants).
617      */
618     function _callOptionalReturn(IERC20 token, bytes memory data) private {
619         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
620         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
621         // the target address contains contract code and also asserts for success in the low-level call.
622 
623         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
624         if (returndata.length > 0) { // Return data is optional
625             // solhint-disable-next-line max-line-length
626             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
627         }
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/math/Math.sol@v3.4.0
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 /**
637  * @dev Standard math utilities missing in the Solidity language.
638  */
639 library Math {
640     /**
641      * @dev Returns the largest of two numbers.
642      */
643     function max(uint256 a, uint256 b) internal pure returns (uint256) {
644         return a >= b ? a : b;
645     }
646 
647     /**
648      * @dev Returns the smallest of two numbers.
649      */
650     function min(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a < b ? a : b;
652     }
653 
654     /**
655      * @dev Returns the average of two numbers. The result is rounded towards
656      * zero.
657      */
658     function average(uint256 a, uint256 b) internal pure returns (uint256) {
659         // (a + b) / 2 can overflow, so we distribute
660         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/Arrays.sol@v3.4.0
666 
667 pragma solidity >=0.6.0 <0.8.0;
668 
669 /**
670  * @dev Collection of functions related to array types.
671  */
672 library Arrays {
673    /**
674      * @dev Searches a sorted `array` and returns the first index that contains
675      * a value greater or equal to `element`. If no such index exists (i.e. all
676      * values in the array are strictly less than `element`), the array length is
677      * returned. Time complexity O(log n).
678      *
679      * `array` is expected to be sorted in ascending order, and to contain no
680      * repeated elements.
681      */
682     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
683         if (array.length == 0) {
684             return 0;
685         }
686 
687         uint256 low = 0;
688         uint256 high = array.length;
689 
690         while (low < high) {
691             uint256 mid = Math.average(low, high);
692 
693             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
694             // because Math.average rounds down (it does integer division with truncation).
695             if (array[mid] > element) {
696                 high = mid;
697             } else {
698                 low = mid + 1;
699             }
700         }
701 
702         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
703         if (low > 0 && array[low - 1] == element) {
704             return low - 1;
705         } else {
706             return low;
707         }
708     }
709 }
710 
711 
712 // File @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol@v3.4.0
713 
714 pragma solidity >=0.6.0 <0.8.0;
715 
716 /**
717  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
718  *
719  * Accounts can be notified of {IERC777} tokens being sent to them by having a
720  * contract implement this interface (contract holders can be their own
721  * implementer) and registering it on the
722  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
723  *
724  * See {IERC1820Registry} and {ERC1820Implementer}.
725  */
726 interface IERC777Recipient {
727     /**
728      * @dev Called by an {IERC777} token contract whenever tokens are being
729      * moved or created into a registered account (`to`). The type of operation
730      * is conveyed by `from` being the zero address or not.
731      *
732      * This call occurs _after_ the token contract's state is updated, so
733      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
734      *
735      * This function may revert to prevent the operation from being executed.
736      */
737     function tokensReceived(
738         address operator,
739         address from,
740         address to,
741         uint256 amount,
742         bytes calldata userData,
743         bytes calldata operatorData
744     ) external;
745 }
746 
747 
748 // File @openzeppelin/contracts/introspection/IERC1820Registry.sol@v3.4.0
749 
750 pragma solidity >=0.6.0 <0.8.0;
751 
752 /**
753  * @dev Interface of the global ERC1820 Registry, as defined in the
754  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
755  * implementers for interfaces in this registry, as well as query support.
756  *
757  * Implementers may be shared by multiple accounts, and can also implement more
758  * than a single interface for each account. Contracts can implement interfaces
759  * for themselves, but externally-owned accounts (EOA) must delegate this to a
760  * contract.
761  *
762  * {IERC165} interfaces can also be queried via the registry.
763  *
764  * For an in-depth explanation and source code analysis, see the EIP text.
765  */
766 interface IERC1820Registry {
767     /**
768      * @dev Sets `newManager` as the manager for `account`. A manager of an
769      * account is able to set interface implementers for it.
770      *
771      * By default, each account is its own manager. Passing a value of `0x0` in
772      * `newManager` will reset the manager to this initial state.
773      *
774      * Emits a {ManagerChanged} event.
775      *
776      * Requirements:
777      *
778      * - the caller must be the current manager for `account`.
779      */
780     function setManager(address account, address newManager) external;
781 
782     /**
783      * @dev Returns the manager for `account`.
784      *
785      * See {setManager}.
786      */
787     function getManager(address account) external view returns (address);
788 
789     /**
790      * @dev Sets the `implementer` contract as ``account``'s implementer for
791      * `interfaceHash`.
792      *
793      * `account` being the zero address is an alias for the caller's address.
794      * The zero address can also be used in `implementer` to remove an old one.
795      *
796      * See {interfaceHash} to learn how these are created.
797      *
798      * Emits an {InterfaceImplementerSet} event.
799      *
800      * Requirements:
801      *
802      * - the caller must be the current manager for `account`.
803      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
804      * end in 28 zeroes).
805      * - `implementer` must implement {IERC1820Implementer} and return true when
806      * queried for support, unless `implementer` is the caller. See
807      * {IERC1820Implementer-canImplementInterfaceForAddress}.
808      */
809     function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;
810 
811     /**
812      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
813      * implementer is registered, returns the zero address.
814      *
815      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
816      * zeroes), `account` will be queried for support of it.
817      *
818      * `account` being the zero address is an alias for the caller's address.
819      */
820     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
821 
822     /**
823      * @dev Returns the interface hash for an `interfaceName`, as defined in the
824      * corresponding
825      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
826      */
827     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
828 
829     /**
830      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
831      *  @param account Address of the contract for which to update the cache.
832      *  @param interfaceId ERC165 interface for which to update the cache.
833      */
834     function updateERC165Cache(address account, bytes4 interfaceId) external;
835 
836     /**
837      *  @notice Checks whether a contract implements an ERC165 interface or not.
838      *  If the result is not cached a direct lookup on the contract address is performed.
839      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
840      *  {updateERC165Cache} with the contract address.
841      *  @param account Address of the contract to check.
842      *  @param interfaceId ERC165 interface to check.
843      *  @return True if `account` implements `interfaceId`, false otherwise.
844      */
845     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
846 
847     /**
848      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
849      *  @param account Address of the contract to check.
850      *  @param interfaceId ERC165 interface to check.
851      *  @return True if `account` implements `interfaceId`, false otherwise.
852      */
853     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
854 
855     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
856 
857     event ManagerChanged(address indexed account, address indexed newManager);
858 }
859 
860 
861 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.0
862 
863 pragma solidity >=0.6.0 <0.8.0;
864 
865 /**
866  * @dev Contract module that helps prevent reentrant calls to a function.
867  *
868  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
869  * available, which can be applied to functions to make sure there are no nested
870  * (reentrant) calls to them.
871  *
872  * Note that because there is a single `nonReentrant` guard, functions marked as
873  * `nonReentrant` may not call one another. This can be worked around by making
874  * those functions `private`, and then adding `external` `nonReentrant` entry
875  * points to them.
876  *
877  * TIP: If you would like to learn more about reentrancy and alternative ways
878  * to protect against it, check out our blog post
879  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
880  */
881 abstract contract ReentrancyGuard {
882     // Booleans are more expensive than uint256 or any type that takes up a full
883     // word because each write operation emits an extra SLOAD to first read the
884     // slot's contents, replace the bits taken up by the boolean, and then write
885     // back. This is the compiler's defense against contract upgrades and
886     // pointer aliasing, and it cannot be disabled.
887 
888     // The values being non-zero value makes deployment a bit more expensive,
889     // but in exchange the refund on every call to nonReentrant will be lower in
890     // amount. Since refunds are capped to a percentage of the total
891     // transaction's gas, it is best to keep them low in cases like this one, to
892     // increase the likelihood of the full refund coming into effect.
893     uint256 private constant _NOT_ENTERED = 1;
894     uint256 private constant _ENTERED = 2;
895 
896     uint256 private _status;
897 
898     constructor () internal {
899         _status = _NOT_ENTERED;
900     }
901 
902     /**
903      * @dev Prevents a contract from calling itself, directly or indirectly.
904      * Calling a `nonReentrant` function from another `nonReentrant`
905      * function is not supported. It is possible to prevent this from happening
906      * by making the `nonReentrant` function external, and make it call a
907      * `private` function that does the actual work.
908      */
909     modifier nonReentrant() {
910         // On the first call to nonReentrant, _notEntered will be true
911         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
912 
913         // Any calls to nonReentrant after this point will fail
914         _status = _ENTERED;
915 
916         _;
917 
918         // By storing the original value once again, a refund is triggered (see
919         // https://eips.ethereum.org/EIPS/eip-2200)
920         _status = _NOT_ENTERED;
921     }
922 }
923 
924 
925 // File contracts/HoprFarm.sol
926 
927 // SPDX-License-Identifier: GPL-3.0-only
928 
929 pragma solidity 0.6.12;
930 
931 /**
932  * 5 million HOPR tokens are allocated as incentive for liquidity providers on uniswap.
933  * This incentive will be distributed on an approx. weekly-basis over 3 months (13 weeks) 
934  * Liquidity providers (LPs) can deposit their LP-tokens (UniswapV2Pair token for HOPR-DAI)
935  * to this HoprFarm contract for at least 1 week (minimum deposit period) to receive rewards. 
936  */
937 contract HoprFarm is IERC777Recipient, ReentrancyGuard {
938     using SafeERC20 for IERC20;
939     using SafeMath for uint256;
940     using Arrays for uint256[];
941 
942     uint256 public constant TOTAL_INCENTIVE = 5000000 ether;
943     uint256 public constant WEEKLY_BLOCK_NUMBER = 44800; // Taking 13.5 s/block as average block time. thus 7*24*60*60/13.5 = 44800 blocks per week. 
944     uint256 public constant TOTAL_CLAIM_PERIOD = 13; // Incentives are released over a period of 13 weeks. 
945     uint256 public constant WEEKLY_INCENTIVE = 384615384615384615384615; // 5000000/13 weeks There is very small amount of remainder for the last week (+5 wei)
946 
947     // setup ERC1820
948     IERC1820Registry private constant ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
949     bytes32 private constant TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
950 
951     struct LiquidityProvider {
952         mapping(uint256=>uint256) eligibleBalance; // Amount of liquidity tokens
953         uint256 claimedUntil; // the last period where the liquidity provider has claimed tokens
954         uint256 currentBalance;
955     }
956 
957     // an ascending block numbers of start/end of each farming interval. 
958     // E.g. the first farming interval is (distributionBlocks[0], distributionBlocks[1]].
959     uint256[] public distributionBlocks;
960     mapping(uint256=>uint256) public eligibleLiquidityPerPeriod;
961     mapping(address=>LiquidityProvider) public liquidityProviders;
962     uint256 public totalPoolBalance;
963     uint256 public claimedIncentive;
964     address public multisig;
965     IERC20 public pool; 
966     IERC20 public hopr; 
967 
968     event TokenAdded(address indexed provider, uint256 indexed period, uint256 amount);
969     event TokenRemoved(address indexed provider, uint256 indexed period, uint256 amount);
970     event IncentiveClaimed(address indexed provider, uint256 indexed until, uint256 amount);
971 
972     /**
973      * @dev Modifier to check address is multisig
974      */
975     modifier onlyMultisig(address adr) {
976         require(adr == multisig, "HoprFarm: Only DAO multisig");
977         _;
978     }
979 
980     /**
981      * @dev provides the farming schedule.
982      * @param _pool address Address of the HOPR-DAI uniswap pool.
983      * @param _token address Address of the HOPR token.
984      * @param _multisig address Address of the HOPR DAO multisig.
985      */
986     constructor(address _pool, address _token, address _multisig) public {
987         require(IUniswapV2Pair(_pool).token0() == _token || IUniswapV2Pair(_pool).token1() == _token, "HoprFarm: wrong token address");
988         pool = IERC20(_pool);
989         hopr = IERC20(_token);
990         multisig = _multisig;
991         distributionBlocks.push(0);
992         ERC1820_REGISTRY.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
993     }
994 
995     /**
996      * @dev ERC777 hook triggered when multisig send HOPR token to this contract.
997      * @param operator address operator requesting the transfer
998      * @param from address token holder address
999      * @param to address recipient address
1000      * @param amount uint256 amount of tokens to transfer
1001      * @param userData bytes hex string of the starting block number. e.g. "0xb66bbd" for 11955133. It should not be longer than 3 bytes
1002      * @param operatorData bytes extra information provided by the operator (if any)
1003      */
1004     function tokensReceived(
1005         address operator,
1006         address from,
1007         address to,
1008         uint256 amount,
1009         bytes calldata userData,
1010         // solhint-disable-next-line no-unused-vars
1011         bytes calldata operatorData
1012     ) external override onlyMultisig(from) nonReentrant {
1013         require(msg.sender == address(hopr), "HoprFarm: Sender must be HOPR token");
1014         require(to == address(this), "HoprFarm: Must be sending tokens to HOPR farm");
1015         require(amount == TOTAL_INCENTIVE, "HoprFarm: Only accept 5 million HOPR token");
1016         // take block number from userData, varies from 0x000000 to 0xffffff.
1017         // This value is sufficient as 0xffff will be in March 2023.
1018         require(userData.length == 3, "HoprFarm: Start block number needs to have three bytes");
1019         require(distributionBlocks[0] == 0, "HoprFarm: Not initialized yet.");
1020         bytes32 m;
1021         assembly {
1022             // it first loads the userData at the position 228 = 4 + 32 * 7, 
1023             // where 4 is the method signature and 7 is the storage of userData
1024             // Then bit shift the right-padded bytes32 to remove all the padded zeros
1025             // Given the blocknumber is not longer than 3 bytes, bitwise it needs to shift
1026             // log2(16) * (32 - 3) * 2 = 232
1027             m := shr(232, calldataload(228))
1028         }
1029         // update distribution blocks
1030         uint256 startBlock = uint256(m);
1031         require(startBlock >= block.number, "HoprFarm: Start block number should be in the future");
1032         distributionBlocks[0] = startBlock;
1033         for (uint256 i = 1; i <= TOTAL_CLAIM_PERIOD; i++) {
1034             distributionBlocks.push(startBlock + i * WEEKLY_BLOCK_NUMBER);
1035         }
1036     }
1037 
1038     /**
1039      * @dev Multisig can recover tokens (pool tokens/hopr tokens/any other random tokens)
1040      * @param token Address of the token to be recovered.
1041      */
1042     function recoverToken(address token) external onlyMultisig(msg.sender) nonReentrant {
1043         if (token == address(hopr)) {
1044             hopr.safeTransfer(multisig, hopr.balanceOf(address(this)).add(claimedIncentive).sub(TOTAL_INCENTIVE));
1045         } else if (token == address(pool)) {
1046             pool.safeTransfer(multisig, pool.balanceOf(address(this)).sub(totalPoolBalance));
1047         } else {
1048             IERC20(token).safeTransfer(multisig, IERC20(token).balanceOf(address(this)));
1049         }
1050     }
1051 
1052     /**
1053      * @dev Claim incenvtives for an account. Update total claimed incentive.
1054      * @param provider Account of liquidity provider
1055      */
1056     function claimFor(address provider) external nonReentrant {
1057         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1058         _claimFor(currentPeriod, provider);
1059     }
1060 
1061     /**
1062      * @dev liquidity provider deposits their Uniswap HOPR-DAI tokens to the contract
1063      * It updates the current balance and the eligible farming balance
1064      * Thanks to `permit` function of UNI token (see below, link to source code), 
1065      * https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol
1066      * LPs do not need to call `approve` seperately. `spender` is this farm contract. 
1067      * This function can be called by anyone with a valid signature of liquidity provider.
1068      * @param amount Amount of pool token to be staked into the contract. It is also the amount in the signature.
1069      * @param owner Address of the liquidity provider.
1070      * @param deadline Timestamp after which the signature is no longer valid.
1071      * @param v ECDSA signature.
1072      * @param r ECDSA signature.
1073      * @param s ECDSA signature.
1074      */
1075     function openFarmWithPermit(uint256 amount, address owner, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
1076         IUniswapV2Pair(address(pool)).permit(owner, address(this), amount, deadline, v, r, s);
1077         _openFarm(amount, owner);
1078     }
1079 
1080     /**
1081      * @dev Called by liquidty provider to deposit their Uniswap HOPR-DAI tokens to the contract
1082      * It updates the current balance and the eligible farming balance
1083      * @notice An `apprpove(<farm contract>, amount)` needs to be called prior to `openFarm`
1084      * @param amount Amount of pool token to be staked into the contract.
1085      */
1086     function openFarm(uint256 amount) external nonReentrant {
1087         _openFarm(amount, msg.sender);
1088     }
1089 
1090     /**
1091      * @dev Claims all the reward until current block number and close the farm.
1092      */
1093     function claimAndClose() external nonReentrant {
1094         // get current farm period
1095         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1096         _claimFor(currentPeriod, msg.sender);
1097         _closeFarm(currentPeriod, msg.sender, liquidityProviders[msg.sender].currentBalance);
1098     }
1099 
1100     /**
1101      * @dev liquidity provider removes their Uniswap HOPR-DAI tokens to the contract
1102      * It updates the current balance and the eligible farming balance
1103      * @param amount Amount of pool token to be removed from the contract.
1104      */
1105     function closeFarm(uint256 amount) external nonReentrant {
1106         // update balance to the right phase
1107         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1108         _closeFarm(currentPeriod, msg.sender, amount);
1109     }
1110 
1111     /**
1112      * @dev returns the first index that contains a value greater or equal to the current `block.number`
1113      * If all numbers are strictly below block.number, returns array length.
1114      * @notice get the current farm period. 0 means "not started", 1 means "1st period", ...
1115      * If the returned value is larger than `maxFarmPeriod`, it means farming is "closed"
1116      */
1117     function currentFarmPeriod() public view returns (uint256) {
1118         return distributionBlocks.findUpperBound(block.number);
1119     }
1120 
1121     /**
1122      * @dev calculate virtual return based on current staking. Amount of tokens one can claim in the next period.
1123      * @param amountToStake Amount of pool token that a liquidity provider would stake
1124      */
1125     function currentFarmIncentive(uint256 amountToStake) public view returns (uint256) {
1126         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1127         if (currentPeriod >= TOTAL_CLAIM_PERIOD) {
1128             return 0;            
1129         }
1130         return WEEKLY_INCENTIVE.mul(amountToStake).div(eligibleLiquidityPerPeriod[currentPeriod+1].add(amountToStake));
1131     }
1132 
1133     /**
1134      * @dev Get the total amount of incentive to be claimed by the liquidity provider.
1135      * @param provider Account of liquidity provider
1136      */
1137     function incentiveToBeClaimed(address provider) public view returns (uint256) {
1138         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1139         return _incentiveToBeClaimed(currentPeriod, provider);
1140     }
1141 
1142     /**
1143      * @dev update the liquidity token balance, of which is used for calculating the result of farming
1144      * It updates the balance for the following periods. For the previous period, if the balance reduces 
1145      * the eligible balance of the previous round reduces. If the balance increases, it only affects the
1146      * following rounds.
1147      * @param account Address of the liquidity provider
1148      * @param newBalance Latest balance
1149      * @param currentPeriod Index of the farming period at current block number.
1150      */
1151     function updateEligibleBalance(address account, uint256 newBalance, uint256 currentPeriod) internal {
1152         if (currentPeriod > 0) {
1153             uint256 balanceFromLastPeriod = liquidityProviders[account].eligibleBalance[currentPeriod - 1];
1154             if (balanceFromLastPeriod > newBalance) {
1155                 liquidityProviders[account].eligibleBalance[currentPeriod - 1] = newBalance;
1156                 eligibleLiquidityPerPeriod[currentPeriod - 1] = eligibleLiquidityPerPeriod[currentPeriod - 1].sub(balanceFromLastPeriod).add(newBalance);
1157             }
1158         }
1159         uint256 newEligibleLiquidityPerPeriod = eligibleLiquidityPerPeriod[currentPeriod].sub(liquidityProviders[account].eligibleBalance[currentPeriod]).add(newBalance);
1160         for (uint256 i = currentPeriod; i < TOTAL_CLAIM_PERIOD; i++) {
1161             liquidityProviders[account].eligibleBalance[i] = newBalance;
1162             eligibleLiquidityPerPeriod[i] = newEligibleLiquidityPerPeriod;
1163         }
1164     }
1165 
1166     /**
1167      * @dev liquidity provider deposits their Uniswap HOPR-DAI tokens to the contract
1168      * It updates the current balance and the eligible farming balance
1169      * @param amount Amount of pool token to be staked into the contract.
1170      * @param provider Address of the liquidity provider.
1171      */
1172     function _openFarm(uint256 amount, address provider) internal {
1173         // update balance to the right phase
1174         uint256 currentPeriod = distributionBlocks.findUpperBound(block.number);
1175         require(currentPeriod < TOTAL_CLAIM_PERIOD, "HoprFarm: Farming ended");
1176         // always add currentBalance
1177         uint256 newBalance = liquidityProviders[provider].currentBalance.add(amount);
1178         liquidityProviders[provider].currentBalance = newBalance;
1179         totalPoolBalance = totalPoolBalance.add(amount);      
1180         // update eligible balance
1181         updateEligibleBalance(provider, newBalance, currentPeriod);
1182         // transfer token
1183         pool.safeTransferFrom(provider, address(this), amount);
1184         // emit event
1185         emit TokenAdded(provider, currentPeriod, amount);
1186     }
1187 
1188     /**
1189      * @dev Claim incenvtives for an account. Update total claimed incentive.
1190      * @param currentPeriod Current farm period
1191      * @param provider Account of liquidity provider
1192      */
1193     function _claimFor(uint256 currentPeriod, address provider) internal {
1194         require(currentPeriod > 1, "HoprFarm: Too early to claim");
1195         uint256 farmed = _incentiveToBeClaimed(currentPeriod, provider);
1196         require(farmed > 0, "HoprFarm: Nothing to claim");
1197         liquidityProviders[provider].claimedUntil = currentPeriod - 1;
1198         claimedIncentive = claimedIncentive.add(farmed);
1199         // transfer farmed tokens to the provider
1200         hopr.safeTransfer(provider, farmed);
1201         emit IncentiveClaimed(provider, currentPeriod - 1, farmed);
1202     }
1203 
1204     /**
1205      * @dev liquidity provider removes their Uniswap HOPR-DAI tokens to the contract
1206      * It updates the current balance and the eligible farming balance
1207      * @param currentPeriod Current farm period
1208      * @param provider Account of liquidity provider
1209      * @param amount Amount of pool token to be removed from the contract.
1210      */
1211     function _closeFarm(uint256 currentPeriod, address provider, uint256 amount) internal {
1212         // always add currentBalance
1213         uint256 newBalance = liquidityProviders[provider].currentBalance.sub(amount);
1214         liquidityProviders[provider].currentBalance = newBalance;
1215         totalPoolBalance = totalPoolBalance.sub(amount);      
1216         // update eligible balance
1217         updateEligibleBalance(provider, newBalance, currentPeriod);
1218         // transfer token
1219         pool.safeTransfer(provider, amount);
1220         // emit event
1221         emit TokenRemoved(provider, currentPeriod, amount);
1222     }
1223 
1224     /**
1225      * @dev Private function that gets the total amount of incentive to be claimed by the liquidity provider.
1226      * @param currentPeriod Current farm period
1227      * @param provider Account of liquidity provider
1228      */
1229     function _incentiveToBeClaimed(uint256 currentPeriod, address provider) private view returns (uint256) {
1230         uint256 claimedPeriod = liquidityProviders[provider].claimedUntil;
1231         if (currentPeriod < 1 || claimedPeriod >= currentPeriod) {
1232             return 0;            
1233         }
1234         uint256 farmed;
1235         for (uint256 i = claimedPeriod; i < currentPeriod - 1; i++) {
1236             if (eligibleLiquidityPerPeriod[i] > 0) {
1237                 farmed = farmed.add(WEEKLY_INCENTIVE.mul(liquidityProviders[provider].eligibleBalance[i]).div(eligibleLiquidityPerPeriod[i]));
1238             }
1239         }
1240         return farmed;
1241     }
1242 }