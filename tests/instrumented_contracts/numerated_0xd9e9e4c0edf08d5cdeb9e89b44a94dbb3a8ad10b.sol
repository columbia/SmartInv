1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
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
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 
221 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
222 
223 // SPDX-License-Identifier: MIT
224 
225 pragma solidity >=0.6.0 <0.8.0;
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP.
229  */
230 interface IERC20 {
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `recipient`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `sender` to `recipient` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 
302 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
303 
304 // SPDX-License-Identifier: MIT
305 
306 pragma solidity >=0.6.2 <0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { size := extcodesize(account) }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{ value: amount }("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383       return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{ value: value }(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.delegatecall(data);
471         return _verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 // solhint-disable-next-line no-inline-assembly
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
496 
497 // SPDX-License-Identifier: MIT
498 
499 pragma solidity >=0.6.0 <0.8.0;
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure (when the token
506  * contract returns false). Tokens that return no value (and instead revert or
507  * throw on failure) are also supported, non-reverting calls are assumed to be
508  * successful.
509  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
510  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
511  */
512 library SafeERC20 {
513     using SafeMath for uint256;
514     using Address for address;
515 
516     function safeTransfer(IERC20 token, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
518     }
519 
520     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
521         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
522     }
523 
524     /**
525      * @dev Deprecated. This function has issues similar to the ones found in
526      * {IERC20-approve}, and its usage is discouraged.
527      *
528      * Whenever possible, use {safeIncreaseAllowance} and
529      * {safeDecreaseAllowance} instead.
530      */
531     function safeApprove(IERC20 token, address spender, uint256 value) internal {
532         // safeApprove should only be called when setting an initial allowance,
533         // or when resetting it to zero. To increase and decrease it, use
534         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
535         // solhint-disable-next-line max-line-length
536         require((value == 0) || (token.allowance(address(this), spender) == 0),
537             "SafeERC20: approve from non-zero to non-zero allowance"
538         );
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
540     }
541 
542     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
543         uint256 newAllowance = token.allowance(address(this), spender).add(value);
544         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
545     }
546 
547     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
548         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
549         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
550     }
551 
552     /**
553      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
554      * on the return value: the return value is optional (but if data is returned, it must not be false).
555      * @param token The token targeted by the call.
556      * @param data The call data (encoded using abi.encode or one of its variants).
557      */
558     function _callOptionalReturn(IERC20 token, bytes memory data) private {
559         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
560         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
561         // the target address contains contract code and also asserts for success in the low-level call.
562 
563         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 
572 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
573 
574 pragma solidity >=0.5.0;
575 
576 interface IUniswapV2Pair {
577     event Approval(address indexed owner, address indexed spender, uint value);
578     event Transfer(address indexed from, address indexed to, uint value);
579 
580     function name() external pure returns (string memory);
581     function symbol() external pure returns (string memory);
582     function decimals() external pure returns (uint8);
583     function totalSupply() external view returns (uint);
584     function balanceOf(address owner) external view returns (uint);
585     function allowance(address owner, address spender) external view returns (uint);
586 
587     function approve(address spender, uint value) external returns (bool);
588     function transfer(address to, uint value) external returns (bool);
589     function transferFrom(address from, address to, uint value) external returns (bool);
590 
591     function DOMAIN_SEPARATOR() external view returns (bytes32);
592     function PERMIT_TYPEHASH() external pure returns (bytes32);
593     function nonces(address owner) external view returns (uint);
594 
595     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
596 
597     event Mint(address indexed sender, uint amount0, uint amount1);
598     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
599     event Swap(
600         address indexed sender,
601         uint amount0In,
602         uint amount1In,
603         uint amount0Out,
604         uint amount1Out,
605         address indexed to
606     );
607     event Sync(uint112 reserve0, uint112 reserve1);
608 
609     function MINIMUM_LIQUIDITY() external pure returns (uint);
610     function factory() external view returns (address);
611     function token0() external view returns (address);
612     function token1() external view returns (address);
613     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
614     function price0CumulativeLast() external view returns (uint);
615     function price1CumulativeLast() external view returns (uint);
616     function kLast() external view returns (uint);
617 
618     function mint(address to) external returns (uint liquidity);
619     function burn(address to) external returns (uint amount0, uint amount1);
620     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
621     function skim(address to) external;
622     function sync() external;
623 
624     function initialize(address, address) external;
625 }
626 
627 
628 // File contracts/external/UniswapV2Library.sol
629 
630 pragma solidity >=0.5.0;
631 
632 
633 library UniswapV2Library {
634     using SafeMath for uint256;
635 
636     // returns sorted token addresses, used to handle return values from pairs sorted in this order
637     function sortTokens(address tokenA, address tokenB)
638         internal
639         pure
640         returns (address token0, address token1)
641     {
642         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
643         (token0, token1) = tokenA < tokenB
644             ? (tokenA, tokenB)
645             : (tokenB, tokenA);
646         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
647     }
648 
649     // calculates the CREATE2 address for a pair without making any external calls
650     function pairFor(
651         address factory,
652         address tokenA,
653         address tokenB
654     ) internal pure returns (address pair) {
655         (address token0, address token1) = sortTokens(tokenA, tokenB);
656         pair = address(
657             uint256(
658                 keccak256(
659                     abi.encodePacked(
660                         hex"ff",
661                         factory,
662                         keccak256(abi.encodePacked(token0, token1)),
663                         hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
664                     )
665                 )
666             )
667         );
668     }
669 
670     // fetches and sorts the reserves for a pair
671     function getReserves(
672         address factory,
673         address tokenA,
674         address tokenB
675     ) internal view returns (uint256 reserveA, uint256 reserveB) {
676         (address token0, ) = sortTokens(tokenA, tokenB);
677         (uint256 reserve0, uint256 reserve1, ) =
678             IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
679         (reserveA, reserveB) = tokenA == token0
680             ? (reserve0, reserve1)
681             : (reserve1, reserve0);
682     }
683 
684     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
685     function quote(
686         uint256 amountA,
687         uint256 reserveA,
688         uint256 reserveB
689     ) internal pure returns (uint256 amountB) {
690         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
691         require(
692             reserveA > 0 && reserveB > 0,
693             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
694         );
695         amountB = amountA.mul(reserveB) / reserveA;
696     }
697 
698     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
699     function getAmountOut(
700         uint256 amountIn,
701         uint256 reserveIn,
702         uint256 reserveOut
703     ) internal pure returns (uint256 amountOut) {
704         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
705         require(
706             reserveIn > 0 && reserveOut > 0,
707             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
708         );
709         uint256 amountInWithFee = amountIn.mul(997);
710         uint256 numerator = amountInWithFee.mul(reserveOut);
711         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
712         amountOut = numerator / denominator;
713     }
714 
715     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
716     function getAmountIn(
717         uint256 amountOut,
718         uint256 reserveIn,
719         uint256 reserveOut
720     ) internal pure returns (uint256 amountIn) {
721         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
722         require(
723             reserveIn > 0 && reserveOut > 0,
724             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
725         );
726         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
727         uint256 denominator = reserveOut.sub(amountOut).mul(997);
728         amountIn = (numerator / denominator).add(1);
729     }
730 
731     // performs chained getAmountOut calculations on any number of pairs
732     function getAmountsOut(
733         address factory,
734         uint256 amountIn,
735         address[] memory path
736     ) internal view returns (uint256[] memory amounts) {
737         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
738         amounts = new uint256[](path.length);
739         amounts[0] = amountIn;
740         for (uint256 i; i < path.length - 1; i++) {
741             (uint256 reserveIn, uint256 reserveOut) =
742                 getReserves(factory, path[i], path[i + 1]);
743             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
744         }
745     }
746 
747     // performs chained getAmountIn calculations on any number of pairs
748     function getAmountsIn(
749         address factory,
750         uint256 amountOut,
751         address[] memory path
752     ) internal view returns (uint256[] memory amounts) {
753         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
754         amounts = new uint256[](path.length);
755         amounts[amounts.length - 1] = amountOut;
756         for (uint256 i = path.length - 1; i > 0; i--) {
757             (uint256 reserveIn, uint256 reserveOut) =
758                 getReserves(factory, path[i - 1], path[i]);
759             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
760         }
761     }
762 }
763 
764 
765 // File contracts/core/Constants.sol
766 
767 pragma solidity ^0.6.2;
768 
769 library Constants {
770     /* Pool */
771     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6;
772     uint256 private constant VESTING_DURATION = 14; //180 days (6 months)
773     uint32 private constant VESTING_INTERVAL = 2; //30 days (1 month)
774     uint256 private constant STAKE_LOCKUP_DURATION = 60; //30 days (1 month)
775 
776     /**
777      * Getters
778      */
779     function getInitialStakeMultiple() internal pure returns (uint256) {
780         return INITIAL_STAKE_MULTIPLE;
781     }
782 
783     function getVestingDuration() internal pure returns (uint256) {
784         return VESTING_DURATION;
785     }
786 
787     function getVestingInterval() internal pure returns (uint32) {
788         return VESTING_INTERVAL;
789     }
790 
791     function getStakeLockupDuration() internal pure returns (uint256) {
792         return STAKE_LOCKUP_DURATION;
793     }
794 }
795 
796 
797 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
798 
799 // SPDX-License-Identifier: MIT
800 
801 pragma solidity >=0.6.0 <0.8.0;
802 
803 /*
804  * @dev Provides information about the current execution context, including the
805  * sender of the transaction and its data. While these are generally available
806  * via msg.sender and msg.data, they should not be accessed in such a direct
807  * manner, since when dealing with GSN meta-transactions the account sending and
808  * paying for execution may not be the actual sender (as far as an application
809  * is concerned).
810  *
811  * This contract is only required for intermediate, library-like contracts.
812  */
813 abstract contract Context {
814     function _msgSender() internal view virtual returns (address payable) {
815         return msg.sender;
816     }
817 
818     function _msgData() internal view virtual returns (bytes memory) {
819         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
820         return msg.data;
821     }
822 }
823 
824 
825 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
826 
827 // SPDX-License-Identifier: MIT
828 
829 pragma solidity >=0.6.0 <0.8.0;
830 
831 
832 
833 /**
834  * @dev Implementation of the {IERC20} interface.
835  *
836  * This implementation is agnostic to the way tokens are created. This means
837  * that a supply mechanism has to be added in a derived contract using {_mint}.
838  * For a generic mechanism see {ERC20PresetMinterPauser}.
839  *
840  * TIP: For a detailed writeup see our guide
841  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
842  * to implement supply mechanisms].
843  *
844  * We have followed general OpenZeppelin guidelines: functions revert instead
845  * of returning `false` on failure. This behavior is nonetheless conventional
846  * and does not conflict with the expectations of ERC20 applications.
847  *
848  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
849  * This allows applications to reconstruct the allowance for all accounts just
850  * by listening to said events. Other implementations of the EIP may not emit
851  * these events, as it isn't required by the specification.
852  *
853  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
854  * functions have been added to mitigate the well-known issues around setting
855  * allowances. See {IERC20-approve}.
856  */
857 contract ERC20 is Context, IERC20 {
858     using SafeMath for uint256;
859 
860     mapping (address => uint256) private _balances;
861 
862     mapping (address => mapping (address => uint256)) private _allowances;
863 
864     uint256 private _totalSupply;
865 
866     string private _name;
867     string private _symbol;
868     uint8 private _decimals;
869 
870     /**
871      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
872      * a default value of 18.
873      *
874      * To select a different value for {decimals}, use {_setupDecimals}.
875      *
876      * All three of these values are immutable: they can only be set once during
877      * construction.
878      */
879     constructor (string memory name_, string memory symbol_) public {
880         _name = name_;
881         _symbol = symbol_;
882         _decimals = 18;
883     }
884 
885     /**
886      * @dev Returns the name of the token.
887      */
888     function name() public view virtual returns (string memory) {
889         return _name;
890     }
891 
892     /**
893      * @dev Returns the symbol of the token, usually a shorter version of the
894      * name.
895      */
896     function symbol() public view virtual returns (string memory) {
897         return _symbol;
898     }
899 
900     /**
901      * @dev Returns the number of decimals used to get its user representation.
902      * For example, if `decimals` equals `2`, a balance of `505` tokens should
903      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
904      *
905      * Tokens usually opt for a value of 18, imitating the relationship between
906      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
907      * called.
908      *
909      * NOTE: This information is only used for _display_ purposes: it in
910      * no way affects any of the arithmetic of the contract, including
911      * {IERC20-balanceOf} and {IERC20-transfer}.
912      */
913     function decimals() public view virtual returns (uint8) {
914         return _decimals;
915     }
916 
917     /**
918      * @dev See {IERC20-totalSupply}.
919      */
920     function totalSupply() public view virtual override returns (uint256) {
921         return _totalSupply;
922     }
923 
924     /**
925      * @dev See {IERC20-balanceOf}.
926      */
927     function balanceOf(address account) public view virtual override returns (uint256) {
928         return _balances[account];
929     }
930 
931     /**
932      * @dev See {IERC20-transfer}.
933      *
934      * Requirements:
935      *
936      * - `recipient` cannot be the zero address.
937      * - the caller must have a balance of at least `amount`.
938      */
939     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
940         _transfer(_msgSender(), recipient, amount);
941         return true;
942     }
943 
944     /**
945      * @dev See {IERC20-allowance}.
946      */
947     function allowance(address owner, address spender) public view virtual override returns (uint256) {
948         return _allowances[owner][spender];
949     }
950 
951     /**
952      * @dev See {IERC20-approve}.
953      *
954      * Requirements:
955      *
956      * - `spender` cannot be the zero address.
957      */
958     function approve(address spender, uint256 amount) public virtual override returns (bool) {
959         _approve(_msgSender(), spender, amount);
960         return true;
961     }
962 
963     /**
964      * @dev See {IERC20-transferFrom}.
965      *
966      * Emits an {Approval} event indicating the updated allowance. This is not
967      * required by the EIP. See the note at the beginning of {ERC20}.
968      *
969      * Requirements:
970      *
971      * - `sender` and `recipient` cannot be the zero address.
972      * - `sender` must have a balance of at least `amount`.
973      * - the caller must have allowance for ``sender``'s tokens of at least
974      * `amount`.
975      */
976     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
977         _transfer(sender, recipient, amount);
978         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
979         return true;
980     }
981 
982     /**
983      * @dev Atomically increases the allowance granted to `spender` by the caller.
984      *
985      * This is an alternative to {approve} that can be used as a mitigation for
986      * problems described in {IERC20-approve}.
987      *
988      * Emits an {Approval} event indicating the updated allowance.
989      *
990      * Requirements:
991      *
992      * - `spender` cannot be the zero address.
993      */
994     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
995         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
996         return true;
997     }
998 
999     /**
1000      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1001      *
1002      * This is an alternative to {approve} that can be used as a mitigation for
1003      * problems described in {IERC20-approve}.
1004      *
1005      * Emits an {Approval} event indicating the updated allowance.
1006      *
1007      * Requirements:
1008      *
1009      * - `spender` cannot be the zero address.
1010      * - `spender` must have allowance for the caller of at least
1011      * `subtractedValue`.
1012      */
1013     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1014         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev Moves tokens `amount` from `sender` to `recipient`.
1020      *
1021      * This is internal function is equivalent to {transfer}, and can be used to
1022      * e.g. implement automatic token fees, slashing mechanisms, etc.
1023      *
1024      * Emits a {Transfer} event.
1025      *
1026      * Requirements:
1027      *
1028      * - `sender` cannot be the zero address.
1029      * - `recipient` cannot be the zero address.
1030      * - `sender` must have a balance of at least `amount`.
1031      */
1032     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1033         require(sender != address(0), "ERC20: transfer from the zero address");
1034         require(recipient != address(0), "ERC20: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(sender, recipient, amount);
1037 
1038         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1039         _balances[recipient] = _balances[recipient].add(amount);
1040         emit Transfer(sender, recipient, amount);
1041     }
1042 
1043     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1044      * the total supply.
1045      *
1046      * Emits a {Transfer} event with `from` set to the zero address.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      */
1052     function _mint(address account, uint256 amount) internal virtual {
1053         require(account != address(0), "ERC20: mint to the zero address");
1054 
1055         _beforeTokenTransfer(address(0), account, amount);
1056 
1057         _totalSupply = _totalSupply.add(amount);
1058         _balances[account] = _balances[account].add(amount);
1059         emit Transfer(address(0), account, amount);
1060     }
1061 
1062     /**
1063      * @dev Destroys `amount` tokens from `account`, reducing the
1064      * total supply.
1065      *
1066      * Emits a {Transfer} event with `to` set to the zero address.
1067      *
1068      * Requirements:
1069      *
1070      * - `account` cannot be the zero address.
1071      * - `account` must have at least `amount` tokens.
1072      */
1073     function _burn(address account, uint256 amount) internal virtual {
1074         require(account != address(0), "ERC20: burn from the zero address");
1075 
1076         _beforeTokenTransfer(account, address(0), amount);
1077 
1078         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1079         _totalSupply = _totalSupply.sub(amount);
1080         emit Transfer(account, address(0), amount);
1081     }
1082 
1083     /**
1084      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1085      *
1086      * This internal function is equivalent to `approve`, and can be used to
1087      * e.g. set automatic allowances for certain subsystems, etc.
1088      *
1089      * Emits an {Approval} event.
1090      *
1091      * Requirements:
1092      *
1093      * - `owner` cannot be the zero address.
1094      * - `spender` cannot be the zero address.
1095      */
1096     function _approve(address owner, address spender, uint256 amount) internal virtual {
1097         require(owner != address(0), "ERC20: approve from the zero address");
1098         require(spender != address(0), "ERC20: approve to the zero address");
1099 
1100         _allowances[owner][spender] = amount;
1101         emit Approval(owner, spender, amount);
1102     }
1103 
1104     /**
1105      * @dev Sets {decimals} to a value other than the default one of 18.
1106      *
1107      * WARNING: This function should only be called from the constructor. Most
1108      * applications that interact with token contracts will not expect
1109      * {decimals} to ever change, and may work incorrectly if it does.
1110      */
1111     function _setupDecimals(uint8 decimals_) internal virtual {
1112         _decimals = decimals_;
1113     }
1114 
1115     /**
1116      * @dev Hook that is called before any transfer of tokens. This includes
1117      * minting and burning.
1118      *
1119      * Calling conditions:
1120      *
1121      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1122      * will be to transferred to `to`.
1123      * - when `from` is zero, `amount` tokens will be minted for `to`.
1124      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1125      * - `from` and `to` are never both zero.
1126      *
1127      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1128      */
1129     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1130 }
1131 
1132 
1133 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1134 
1135 // SPDX-License-Identifier: MIT
1136 
1137 pragma solidity >=0.6.0 <0.8.0;
1138 
1139 /**
1140  * @dev Contract module which provides a basic access control mechanism, where
1141  * there is an account (an owner) that can be granted exclusive access to
1142  * specific functions.
1143  *
1144  * By default, the owner account will be the one that deploys the contract. This
1145  * can later be changed with {transferOwnership}.
1146  *
1147  * This module is used through inheritance. It will make available the modifier
1148  * `onlyOwner`, which can be applied to your functions to restrict their use to
1149  * the owner.
1150  */
1151 abstract contract Ownable is Context {
1152     address private _owner;
1153 
1154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1155 
1156     /**
1157      * @dev Initializes the contract setting the deployer as the initial owner.
1158      */
1159     constructor () internal {
1160         address msgSender = _msgSender();
1161         _owner = msgSender;
1162         emit OwnershipTransferred(address(0), msgSender);
1163     }
1164 
1165     /**
1166      * @dev Returns the address of the current owner.
1167      */
1168     function owner() public view virtual returns (address) {
1169         return _owner;
1170     }
1171 
1172     /**
1173      * @dev Throws if called by any account other than the owner.
1174      */
1175     modifier onlyOwner() {
1176         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Leaves the contract without owner. It will not be possible to call
1182      * `onlyOwner` functions anymore. Can only be called by the current owner.
1183      *
1184      * NOTE: Renouncing ownership will leave the contract without an owner,
1185      * thereby removing any functionality that is only available to the owner.
1186      */
1187     function renounceOwnership() public virtual onlyOwner {
1188         emit OwnershipTransferred(_owner, address(0));
1189         _owner = address(0);
1190     }
1191 
1192     /**
1193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1194      * Can only be called by the current owner.
1195      */
1196     function transferOwnership(address newOwner) public virtual onlyOwner {
1197         require(newOwner != address(0), "Ownable: new owner is the zero address");
1198         emit OwnershipTransferred(_owner, newOwner);
1199         _owner = newOwner;
1200     }
1201 }
1202 
1203 
1204 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
1205 
1206 // SPDX-License-Identifier: MIT
1207 
1208 pragma solidity >=0.6.0 <0.8.0;
1209 
1210 /**
1211  * @dev Library for managing
1212  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1213  * types.
1214  *
1215  * Sets have the following properties:
1216  *
1217  * - Elements are added, removed, and checked for existence in constant time
1218  * (O(1)).
1219  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1220  *
1221  * ```
1222  * contract Example {
1223  *     // Add the library methods
1224  *     using EnumerableSet for EnumerableSet.AddressSet;
1225  *
1226  *     // Declare a set state variable
1227  *     EnumerableSet.AddressSet private mySet;
1228  * }
1229  * ```
1230  *
1231  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1232  * and `uint256` (`UintSet`) are supported.
1233  */
1234 library EnumerableSet {
1235     // To implement this library for multiple types with as little code
1236     // repetition as possible, we write it in terms of a generic Set type with
1237     // bytes32 values.
1238     // The Set implementation uses private functions, and user-facing
1239     // implementations (such as AddressSet) are just wrappers around the
1240     // underlying Set.
1241     // This means that we can only create new EnumerableSets for types that fit
1242     // in bytes32.
1243 
1244     struct Set {
1245         // Storage of set values
1246         bytes32[] _values;
1247 
1248         // Position of the value in the `values` array, plus 1 because index 0
1249         // means a value is not in the set.
1250         mapping (bytes32 => uint256) _indexes;
1251     }
1252 
1253     /**
1254      * @dev Add a value to a set. O(1).
1255      *
1256      * Returns true if the value was added to the set, that is if it was not
1257      * already present.
1258      */
1259     function _add(Set storage set, bytes32 value) private returns (bool) {
1260         if (!_contains(set, value)) {
1261             set._values.push(value);
1262             // The value is stored at length-1, but we add 1 to all indexes
1263             // and use 0 as a sentinel value
1264             set._indexes[value] = set._values.length;
1265             return true;
1266         } else {
1267             return false;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Removes a value from a set. O(1).
1273      *
1274      * Returns true if the value was removed from the set, that is if it was
1275      * present.
1276      */
1277     function _remove(Set storage set, bytes32 value) private returns (bool) {
1278         // We read and store the value's index to prevent multiple reads from the same storage slot
1279         uint256 valueIndex = set._indexes[value];
1280 
1281         if (valueIndex != 0) { // Equivalent to contains(set, value)
1282             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1283             // the array, and then remove the last element (sometimes called as 'swap and pop').
1284             // This modifies the order of the array, as noted in {at}.
1285 
1286             uint256 toDeleteIndex = valueIndex - 1;
1287             uint256 lastIndex = set._values.length - 1;
1288 
1289             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1290             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1291 
1292             bytes32 lastvalue = set._values[lastIndex];
1293 
1294             // Move the last value to the index where the value to delete is
1295             set._values[toDeleteIndex] = lastvalue;
1296             // Update the index for the moved value
1297             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1298 
1299             // Delete the slot where the moved value was stored
1300             set._values.pop();
1301 
1302             // Delete the index for the deleted slot
1303             delete set._indexes[value];
1304 
1305             return true;
1306         } else {
1307             return false;
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns true if the value is in the set. O(1).
1313      */
1314     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1315         return set._indexes[value] != 0;
1316     }
1317 
1318     /**
1319      * @dev Returns the number of values on the set. O(1).
1320      */
1321     function _length(Set storage set) private view returns (uint256) {
1322         return set._values.length;
1323     }
1324 
1325    /**
1326     * @dev Returns the value stored at position `index` in the set. O(1).
1327     *
1328     * Note that there are no guarantees on the ordering of values inside the
1329     * array, and it may change when more values are added or removed.
1330     *
1331     * Requirements:
1332     *
1333     * - `index` must be strictly less than {length}.
1334     */
1335     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1336         require(set._values.length > index, "EnumerableSet: index out of bounds");
1337         return set._values[index];
1338     }
1339 
1340     // Bytes32Set
1341 
1342     struct Bytes32Set {
1343         Set _inner;
1344     }
1345 
1346     /**
1347      * @dev Add a value to a set. O(1).
1348      *
1349      * Returns true if the value was added to the set, that is if it was not
1350      * already present.
1351      */
1352     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1353         return _add(set._inner, value);
1354     }
1355 
1356     /**
1357      * @dev Removes a value from a set. O(1).
1358      *
1359      * Returns true if the value was removed from the set, that is if it was
1360      * present.
1361      */
1362     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1363         return _remove(set._inner, value);
1364     }
1365 
1366     /**
1367      * @dev Returns true if the value is in the set. O(1).
1368      */
1369     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1370         return _contains(set._inner, value);
1371     }
1372 
1373     /**
1374      * @dev Returns the number of values in the set. O(1).
1375      */
1376     function length(Bytes32Set storage set) internal view returns (uint256) {
1377         return _length(set._inner);
1378     }
1379 
1380    /**
1381     * @dev Returns the value stored at position `index` in the set. O(1).
1382     *
1383     * Note that there are no guarantees on the ordering of values inside the
1384     * array, and it may change when more values are added or removed.
1385     *
1386     * Requirements:
1387     *
1388     * - `index` must be strictly less than {length}.
1389     */
1390     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1391         return _at(set._inner, index);
1392     }
1393 
1394     // AddressSet
1395 
1396     struct AddressSet {
1397         Set _inner;
1398     }
1399 
1400     /**
1401      * @dev Add a value to a set. O(1).
1402      *
1403      * Returns true if the value was added to the set, that is if it was not
1404      * already present.
1405      */
1406     function add(AddressSet storage set, address value) internal returns (bool) {
1407         return _add(set._inner, bytes32(uint256(uint160(value))));
1408     }
1409 
1410     /**
1411      * @dev Removes a value from a set. O(1).
1412      *
1413      * Returns true if the value was removed from the set, that is if it was
1414      * present.
1415      */
1416     function remove(AddressSet storage set, address value) internal returns (bool) {
1417         return _remove(set._inner, bytes32(uint256(uint160(value))));
1418     }
1419 
1420     /**
1421      * @dev Returns true if the value is in the set. O(1).
1422      */
1423     function contains(AddressSet storage set, address value) internal view returns (bool) {
1424         return _contains(set._inner, bytes32(uint256(uint160(value))));
1425     }
1426 
1427     /**
1428      * @dev Returns the number of values in the set. O(1).
1429      */
1430     function length(AddressSet storage set) internal view returns (uint256) {
1431         return _length(set._inner);
1432     }
1433 
1434    /**
1435     * @dev Returns the value stored at position `index` in the set. O(1).
1436     *
1437     * Note that there are no guarantees on the ordering of values inside the
1438     * array, and it may change when more values are added or removed.
1439     *
1440     * Requirements:
1441     *
1442     * - `index` must be strictly less than {length}.
1443     */
1444     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1445         return address(uint160(uint256(_at(set._inner, index))));
1446     }
1447 
1448 
1449     // UintSet
1450 
1451     struct UintSet {
1452         Set _inner;
1453     }
1454 
1455     /**
1456      * @dev Add a value to a set. O(1).
1457      *
1458      * Returns true if the value was added to the set, that is if it was not
1459      * already present.
1460      */
1461     function add(UintSet storage set, uint256 value) internal returns (bool) {
1462         return _add(set._inner, bytes32(value));
1463     }
1464 
1465     /**
1466      * @dev Removes a value from a set. O(1).
1467      *
1468      * Returns true if the value was removed from the set, that is if it was
1469      * present.
1470      */
1471     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1472         return _remove(set._inner, bytes32(value));
1473     }
1474 
1475     /**
1476      * @dev Returns true if the value is in the set. O(1).
1477      */
1478     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1479         return _contains(set._inner, bytes32(value));
1480     }
1481 
1482     /**
1483      * @dev Returns the number of values on the set. O(1).
1484      */
1485     function length(UintSet storage set) internal view returns (uint256) {
1486         return _length(set._inner);
1487     }
1488 
1489    /**
1490     * @dev Returns the value stored at position `index` in the set. O(1).
1491     *
1492     * Note that there are no guarantees on the ordering of values inside the
1493     * array, and it may change when more values are added or removed.
1494     *
1495     * Requirements:
1496     *
1497     * - `index` must be strictly less than {length}.
1498     */
1499     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1500         return uint256(_at(set._inner, index));
1501     }
1502 }
1503 
1504 
1505 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1
1506 
1507 // SPDX-License-Identifier: MIT
1508 
1509 pragma solidity >=0.6.0 <0.8.0;
1510 
1511 
1512 
1513 /**
1514  * @dev Contract module that allows children to implement role-based access
1515  * control mechanisms.
1516  *
1517  * Roles are referred to by their `bytes32` identifier. These should be exposed
1518  * in the external API and be unique. The best way to achieve this is by
1519  * using `public constant` hash digests:
1520  *
1521  * ```
1522  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1523  * ```
1524  *
1525  * Roles can be used to represent a set of permissions. To restrict access to a
1526  * function call, use {hasRole}:
1527  *
1528  * ```
1529  * function foo() public {
1530  *     require(hasRole(MY_ROLE, msg.sender));
1531  *     ...
1532  * }
1533  * ```
1534  *
1535  * Roles can be granted and revoked dynamically via the {grantRole} and
1536  * {revokeRole} functions. Each role has an associated admin role, and only
1537  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1538  *
1539  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1540  * that only accounts with this role will be able to grant or revoke other
1541  * roles. More complex role relationships can be created by using
1542  * {_setRoleAdmin}.
1543  *
1544  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1545  * grant and revoke this role. Extra precautions should be taken to secure
1546  * accounts that have been granted it.
1547  */
1548 abstract contract AccessControl is Context {
1549     using EnumerableSet for EnumerableSet.AddressSet;
1550     using Address for address;
1551 
1552     struct RoleData {
1553         EnumerableSet.AddressSet members;
1554         bytes32 adminRole;
1555     }
1556 
1557     mapping (bytes32 => RoleData) private _roles;
1558 
1559     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1560 
1561     /**
1562      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1563      *
1564      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1565      * {RoleAdminChanged} not being emitted signaling this.
1566      *
1567      * _Available since v3.1._
1568      */
1569     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1570 
1571     /**
1572      * @dev Emitted when `account` is granted `role`.
1573      *
1574      * `sender` is the account that originated the contract call, an admin role
1575      * bearer except when using {_setupRole}.
1576      */
1577     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1578 
1579     /**
1580      * @dev Emitted when `account` is revoked `role`.
1581      *
1582      * `sender` is the account that originated the contract call:
1583      *   - if using `revokeRole`, it is the admin role bearer
1584      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1585      */
1586     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1587 
1588     /**
1589      * @dev Returns `true` if `account` has been granted `role`.
1590      */
1591     function hasRole(bytes32 role, address account) public view returns (bool) {
1592         return _roles[role].members.contains(account);
1593     }
1594 
1595     /**
1596      * @dev Returns the number of accounts that have `role`. Can be used
1597      * together with {getRoleMember} to enumerate all bearers of a role.
1598      */
1599     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1600         return _roles[role].members.length();
1601     }
1602 
1603     /**
1604      * @dev Returns one of the accounts that have `role`. `index` must be a
1605      * value between 0 and {getRoleMemberCount}, non-inclusive.
1606      *
1607      * Role bearers are not sorted in any particular way, and their ordering may
1608      * change at any point.
1609      *
1610      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1611      * you perform all queries on the same block. See the following
1612      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1613      * for more information.
1614      */
1615     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1616         return _roles[role].members.at(index);
1617     }
1618 
1619     /**
1620      * @dev Returns the admin role that controls `role`. See {grantRole} and
1621      * {revokeRole}.
1622      *
1623      * To change a role's admin, use {_setRoleAdmin}.
1624      */
1625     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1626         return _roles[role].adminRole;
1627     }
1628 
1629     /**
1630      * @dev Grants `role` to `account`.
1631      *
1632      * If `account` had not been already granted `role`, emits a {RoleGranted}
1633      * event.
1634      *
1635      * Requirements:
1636      *
1637      * - the caller must have ``role``'s admin role.
1638      */
1639     function grantRole(bytes32 role, address account) public virtual {
1640         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1641 
1642         _grantRole(role, account);
1643     }
1644 
1645     /**
1646      * @dev Revokes `role` from `account`.
1647      *
1648      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1649      *
1650      * Requirements:
1651      *
1652      * - the caller must have ``role``'s admin role.
1653      */
1654     function revokeRole(bytes32 role, address account) public virtual {
1655         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1656 
1657         _revokeRole(role, account);
1658     }
1659 
1660     /**
1661      * @dev Revokes `role` from the calling account.
1662      *
1663      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1664      * purpose is to provide a mechanism for accounts to lose their privileges
1665      * if they are compromised (such as when a trusted device is misplaced).
1666      *
1667      * If the calling account had been granted `role`, emits a {RoleRevoked}
1668      * event.
1669      *
1670      * Requirements:
1671      *
1672      * - the caller must be `account`.
1673      */
1674     function renounceRole(bytes32 role, address account) public virtual {
1675         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1676 
1677         _revokeRole(role, account);
1678     }
1679 
1680     /**
1681      * @dev Grants `role` to `account`.
1682      *
1683      * If `account` had not been already granted `role`, emits a {RoleGranted}
1684      * event. Note that unlike {grantRole}, this function doesn't perform any
1685      * checks on the calling account.
1686      *
1687      * [WARNING]
1688      * ====
1689      * This function should only be called from the constructor when setting
1690      * up the initial roles for the system.
1691      *
1692      * Using this function in any other way is effectively circumventing the admin
1693      * system imposed by {AccessControl}.
1694      * ====
1695      */
1696     function _setupRole(bytes32 role, address account) internal virtual {
1697         _grantRole(role, account);
1698     }
1699 
1700     /**
1701      * @dev Sets `adminRole` as ``role``'s admin role.
1702      *
1703      * Emits a {RoleAdminChanged} event.
1704      */
1705     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1706         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1707         _roles[role].adminRole = adminRole;
1708     }
1709 
1710     function _grantRole(bytes32 role, address account) private {
1711         if (_roles[role].members.add(account)) {
1712             emit RoleGranted(role, account, _msgSender());
1713         }
1714     }
1715 
1716     function _revokeRole(bytes32 role, address account) private {
1717         if (_roles[role].members.remove(account)) {
1718             emit RoleRevoked(role, account, _msgSender());
1719         }
1720     }
1721 }
1722 
1723 
1724 // File contracts/core/PoolState.sol
1725 
1726 pragma solidity ^0.6.2;
1727 
1728 
1729 
1730 contract Account {
1731     struct State {
1732         uint256 staked; //LP or cook
1733         uint256 phantom;
1734         Vesting[] vestings;
1735         Vesting[] stakings;
1736         uint256 claimed; //cook
1737         // blacklisted beneficiary,
1738         // 1. the address won't be able to claim/harvest/zap rewarded cook,
1739         // 2. blacklisted address can withdraw their LP token immmediately
1740         // 3. blacklisted address won't receive anymore rewarded cook
1741         bool isBlacklisted;
1742     }
1743 }
1744 
1745 struct Vesting {
1746     uint256 start;
1747     uint256 amount; //cook
1748 }
1749 
1750 contract Storage {
1751     struct Provider {
1752         IERC20 cook;
1753         IERC20 univ2;
1754     }
1755 
1756     struct Balance {
1757         uint256 staked; //LP
1758         uint256 rewarded; //cook
1759         uint256 claimed; //cook
1760         uint256 vesting; //cook
1761         uint256 phantom;
1762     }
1763 
1764     struct State {
1765         Balance balance;
1766         Provider provider;
1767         uint256 lastRewardBlock;
1768         mapping(address => Account.State) accounts;
1769         // Fields for Admin
1770 
1771         // stop everyone from
1772         // 1. stop accepting more LP token into pool,
1773         // 2. stop take any zapping
1774         // 3. stop claim/harvest/zap rewarded cook
1775         // 4. stop distributing cook reward
1776         bool pauseMinig;
1777 
1778         // Mining cook reward per block
1779         uint256 REWARD_PER_BLOCK;
1780         // pool cap limit, 0 will be unlimited
1781         uint256 totalPoolCapLimit;
1782         // stake limit per address, 0 will be unlimited
1783         uint256 stakeLimitPerAddress;
1784     }
1785 }
1786 
1787 contract PoolState is Ownable, AccessControl {
1788     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER");
1789     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
1790     Storage.State _state;
1791 }
1792 
1793 
1794 // File contracts/core/PoolGetters.sol
1795 
1796 pragma solidity ^0.6.2;
1797 
1798 
1799 
1800 contract PoolGetters is PoolState {
1801     using SafeMath for uint256;
1802 
1803     uint32 private constant SECONDS_PER_DAY = 86400; /* 86400 seconds in a day */
1804 
1805     /**
1806      * Global
1807      */
1808     function cook() public view virtual returns (IERC20) {
1809         return _state.provider.cook;
1810     }
1811 
1812     function univ2() public view virtual returns (IERC20) {
1813         return _state.provider.univ2;
1814     }
1815 
1816     function totalStaked() public view returns (uint256) {
1817         return _state.balance.staked;
1818     }
1819 
1820     function totalRewarded() public view returns (uint256) {
1821         return _state.balance.rewarded;
1822     }
1823 
1824     function totalClaimed() public view returns (uint256) {
1825         return _state.balance.claimed;
1826     }
1827 
1828     function totalVesting() public view returns (uint256) {
1829         return _state.balance.vesting;
1830     }
1831 
1832     function totalPhantom() public view returns (uint256) {
1833         return _state.balance.phantom;
1834     }
1835 
1836     function lastRewardBlock() public view returns (uint256) {
1837         return _state.lastRewardBlock;
1838     }
1839 
1840     function getRewardPerBlock() public view virtual returns (uint256) {
1841         return _state.REWARD_PER_BLOCK;
1842     }
1843 
1844     // Overridable for testing
1845     function getStakeLockupDuration() public view virtual returns (uint256) {
1846         return Constants.getStakeLockupDuration();
1847     }
1848 
1849     function getVestingDuration() public view virtual returns (uint256) {
1850         return Constants.getVestingDuration();
1851     }
1852 
1853     function blockNumber() public view virtual returns (uint256) {
1854         return block.number;
1855     }
1856 
1857     function blockTimestamp() public view virtual returns (uint256) {
1858         return block.timestamp;
1859     }
1860 
1861     /**
1862      * Account
1863      */
1864     function balanceOfStaked(address account) public view returns (uint256) {
1865         return _state.accounts[account].staked;
1866     }
1867 
1868     function stakingScheduleStartTime(address account)
1869         public
1870         view
1871         returns (uint256[] memory)
1872     {
1873         uint256 stakingsLength = _state.accounts[account].stakings.length;
1874         uint256[] memory array = new uint256[](stakingsLength);
1875         for (uint256 i = 0; i < stakingsLength; i++) {
1876             array[i] = _state.accounts[account].stakings[i].start;
1877         }
1878         return array;
1879     }
1880 
1881     function stakingScheduleAmount(address account)
1882         public
1883         view
1884         returns (uint256[] memory)
1885     {
1886         uint256 stakingsLength = _state.accounts[account].stakings.length;
1887         uint256[] memory array = new uint256[](stakingsLength);
1888         for (uint256 i = 0; i < stakingsLength; i++) {
1889             array[i] = _state.accounts[account].stakings[i].amount;
1890         }
1891         return array;
1892     }
1893 
1894     function balanceOfUnstakable(address account)
1895         public
1896         view
1897         returns (uint256)
1898     {
1899         uint256 unstakable;
1900 
1901         for (uint256 i = 0; i < _state.accounts[account].stakings.length; i++) {
1902             uint256 totalStakingAmount =
1903                 _state.accounts[account].stakings[i].amount;
1904             uint256 start = _state.accounts[account].stakings[i].start;
1905 
1906             uint32 startDay = uint32(start / SECONDS_PER_DAY);
1907             uint32 today = uint32(blockTimestamp() / SECONDS_PER_DAY);
1908 
1909             // IF an address is blacklisted, the account can't claim/harvest/zap cook rewrad, hence the address can unstake completely
1910             if (
1911                 (today >= (startDay + getStakeLockupDuration())) ||
1912                 isAddrBlacklisted(account)
1913             ) {
1914                 unstakable = unstakable.add(totalStakingAmount); // If after end of staking lockup, then the unstakable amount is total amount.
1915             } else {
1916                 unstakable += 0; // If it's before the staking lockup then the unstakable amount is zero.
1917             }
1918         }
1919         return unstakable;
1920     }
1921 
1922     function balanceOfPhantom(address account) public view returns (uint256) {
1923         return _state.accounts[account].phantom;
1924     }
1925 
1926     function balanceOfRewarded(address account) public view returns (uint256) {
1927         uint256 totalStakedAmount = totalStaked();
1928         if (totalStakedAmount == 0) {
1929             return 0;
1930         }
1931         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1932         uint256 balanceOfRewardedWithPhantom =
1933             totalRewardedWithPhantom.mul(balanceOfStaked(account)).div(
1934                 totalStakedAmount
1935             );
1936 
1937         uint256 phantomBalance = balanceOfPhantom(account);
1938         if (balanceOfRewardedWithPhantom > phantomBalance) {
1939             return balanceOfRewardedWithPhantom.sub(phantomBalance);
1940         }
1941         return 0;
1942     }
1943 
1944     function balanceOfClaimed(address account) public view returns (uint256) {
1945         return _state.accounts[account].claimed;
1946     }
1947 
1948     function balanceOfVesting(address account) public view returns (uint256) {
1949         uint256 totalVestingAmount;
1950         for (uint256 i = 0; i < _state.accounts[account].vestings.length; i++) {
1951             totalVestingAmount = totalVestingAmount.add(_state.accounts[account].vestings[i].amount);
1952         }
1953         return totalVestingAmount;
1954     }
1955 
1956     function balanceOfClaimable(address account) public view returns (uint256) {
1957         uint256 claimable;
1958 
1959         for (uint256 i = 0; i < _state.accounts[account].vestings.length; i++) {
1960             uint256 totalVestingAmount =
1961                 _state.accounts[account].vestings[i].amount;
1962             uint256 start = _state.accounts[account].vestings[i].start;
1963 
1964             uint32 startDay = uint32(start.div(SECONDS_PER_DAY));
1965             uint32 today = uint32(blockTimestamp().div(SECONDS_PER_DAY));
1966             uint32 vestingInterval = Constants.getVestingInterval();
1967             uint256 vestingDuration = getVestingDuration();
1968 
1969             if (today >= (startDay + vestingDuration)) {
1970                 claimable = claimable.add(totalVestingAmount); // If after end of vesting, then the vested amount is total amount.
1971             } else if (today <= startDay) {
1972                 claimable += 0; // If it's before the vesting then the vested amount is zero.
1973             } else {
1974                 // Otherwise a fractional amount is vested.
1975                 // Compute the exact number of days vested.
1976                 uint32 daysVested = today - startDay;
1977                 // Adjust result rounding down to take into consideration the interval.
1978                 uint32 effectiveDaysVested =
1979                     (daysVested / vestingInterval) * vestingInterval;
1980                 uint256 vested =
1981                     totalVestingAmount.mul(effectiveDaysVested).div(
1982                         vestingDuration
1983                     );
1984                 claimable = claimable.add(vested);
1985             }
1986         }
1987         return claimable.sub(balanceOfClaimed(account));
1988     }
1989 
1990     function isMiningPaused() public view returns (bool) {
1991         return _state.pauseMinig;
1992     }
1993 
1994     function isFull() public view returns (bool) {
1995         return
1996             _state.totalPoolCapLimit != 0 &&
1997             _state.balance.staked >= _state.totalPoolCapLimit;
1998     }
1999 
2000     function isAddrBlacklisted(address addr) public view returns (bool) {
2001         return _state.accounts[addr].isBlacklisted;
2002     }
2003 
2004     function totalPoolCapLimit() public view returns (uint256) {
2005         return _state.totalPoolCapLimit;
2006     }
2007 
2008     function stakeLimitPerAddress() public view returns (uint256) {
2009         return _state.stakeLimitPerAddress;
2010     }
2011 
2012     function checkMiningPaused() public {
2013         require(
2014             isMiningPaused() == false,
2015             "liquidity mining program is paused"
2016         );
2017     }
2018 
2019     function ensureAddrNotBlacklisted(address addr) public {
2020         require(
2021             isAddrBlacklisted(addr) == false,
2022             "Your address is blacklisted"
2023         );
2024     }
2025 
2026     function checkPoolStakeCapLimit(uint256 amountToStake) public {
2027         require(
2028             (_state.totalPoolCapLimit == 0 || // no limit
2029                 (_state.balance.staked.add(amountToStake)) <=
2030                 _state.totalPoolCapLimit) == true,
2031             "Exceed pool limit"
2032         );
2033     }
2034 
2035     function checkPerAddrStakeLimit(uint256 amountToStake, address account)
2036         public
2037     {
2038         require(
2039             (_state.stakeLimitPerAddress == 0 || // no limit
2040                 (balanceOfStaked(account).add(amountToStake)) <=
2041                 _state.stakeLimitPerAddress) == true,
2042             "Exceed per address stake limit"
2043         );
2044     }
2045 }
2046 
2047 
2048 // File contracts/core/PoolSetters.sol
2049 
2050 pragma solidity ^0.6.2;
2051 
2052 
2053 
2054 contract PoolSetters is PoolState, PoolGetters {
2055     using SafeMath for uint256;
2056 
2057     /**
2058      * Global
2059      */
2060     function incrementTotalRewarded(uint256 amount) internal {
2061         _state.balance.rewarded = _state.balance.rewarded.add(amount);
2062     }
2063 
2064     function decrementTotalRewarded(uint256 amount, string memory reason)
2065         internal
2066     {
2067         _state.balance.rewarded = _state.balance.rewarded.sub(amount, reason);
2068     }
2069 
2070     function updateLastRewardBlock(uint256 lastRewardBlock) internal {
2071         _state.lastRewardBlock = lastRewardBlock;
2072     }
2073 
2074     /**
2075      * Account
2076      */
2077     function incrementBalanceOfStaked(address account, uint256 amount)
2078         internal
2079     {
2080         _state.accounts[account].staked = _state.accounts[account].staked.add(
2081             amount
2082         );
2083         _state.balance.staked = _state.balance.staked.add(amount);
2084 
2085         Vesting memory staking = Vesting(blockTimestamp(), amount);
2086         _state.accounts[account].stakings.push(staking);
2087     }
2088 
2089     function decrementBalanceOfStaked(
2090         address account,
2091         uint256 amount,
2092         string memory reason
2093     ) internal {
2094         _state.accounts[account].staked = _state.accounts[account].staked.sub(
2095             amount,
2096             reason
2097         );
2098         _state.balance.staked = _state.balance.staked.sub(amount, reason);
2099 
2100         uint256 remainingAmount = amount;
2101         for (uint256 i = 0; i < _state.accounts[account].stakings.length; i++) {
2102             if (remainingAmount == 0) {
2103                 break;
2104             }
2105             uint256 totalStakingAmount =
2106                 _state.accounts[account].stakings[i].amount;
2107 
2108             uint256 unstakeAmount =
2109                 totalStakingAmount > remainingAmount
2110                     ? remainingAmount
2111                     : totalStakingAmount;
2112             _state.accounts[account].stakings[i].amount = totalStakingAmount
2113                 .sub(unstakeAmount, reason);
2114             remainingAmount = remainingAmount.sub(unstakeAmount, reason);
2115         }
2116     }
2117 
2118     function incrementBalanceOfPhantom(address account, uint256 amount)
2119         internal
2120     {
2121         _state.accounts[account].phantom = _state.accounts[account].phantom.add(
2122             amount
2123         );
2124         _state.balance.phantom = _state.balance.phantom.add(amount);
2125     }
2126 
2127     function decrementBalanceOfPhantom(
2128         address account,
2129         uint256 amount,
2130         string memory reason
2131     ) internal {
2132         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(
2133             amount,
2134             reason
2135         );
2136         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
2137     }
2138 
2139     function incrementBalanceOfClaimed(address account, uint256 amount)
2140         internal
2141     {
2142         _state.accounts[account].claimed = _state.accounts[account].claimed.add(
2143             amount
2144         );
2145         _state.balance.claimed = _state.balance.claimed.add(amount);
2146     }
2147 
2148     function addToVestingSchdule(address account, uint256 amount) internal {
2149         Vesting memory vesting = Vesting(blockTimestamp(), amount);
2150         _state.accounts[account].vestings.push(vesting);
2151         _state.balance.vesting = _state.balance.vesting.add(amount);
2152     }
2153 
2154     // Admin Functions
2155     // Put an evil address into blacklist
2156     function blacklistAddress(address addr) public {
2157         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2158         _state.accounts[addr].isBlacklisted = true;
2159     }
2160 
2161     //Remove an address from blacklist
2162     function removeAddressFromBlacklist(address addr) public {
2163         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2164         _state.accounts[addr].isBlacklisted = false;
2165     }
2166 
2167     // Pause all liquidity mining program
2168     function pauseMinigReward() public {
2169         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2170         _state.pauseMinig = true;
2171         _state.REWARD_PER_BLOCK = 0;
2172     }
2173 
2174     // resume liquidity mining program
2175     function resumeMiningReward(uint256 rewardPerBlock) public {
2176         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2177         _state.pauseMinig = false;
2178         _state.REWARD_PER_BLOCK = rewardPerBlock;
2179     }
2180 
2181     function setTotalPoolCapLimit(uint256 totalPoolCapLimit) public {
2182         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2183         _state.totalPoolCapLimit = totalPoolCapLimit;
2184     }
2185 
2186     function setStakeLimitPerAddress(uint256 stakeLimitPerAddress) public {
2187         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2188         _state.stakeLimitPerAddress = stakeLimitPerAddress;
2189     }
2190 }
2191 
2192 
2193 // File contracts/core/IPool.sol
2194 
2195 /*
2196     Copyright 2020 Cook Finance Devs, based on the works of the Cook Finance Squad
2197 
2198     Licensed under the Apache License, Version 2.0 (the "License");
2199     you may not use this file except in compliance with the License.
2200     You may obtain a copy of the License at
2201 
2202     http://www.apache.org/licenses/LICENSE-2.0
2203 
2204     Unless required by applicable law or agreed to in writing, software
2205     distributed under the License is distributed on an "AS IS" BASIS,
2206     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2207     See the License for the specific language governing permissions and
2208     limitations under the License.
2209 */
2210 
2211 pragma solidity ^0.6.2;
2212 pragma experimental ABIEncoderV2;
2213 
2214 abstract contract IPool {
2215     function stake(uint256 value) external virtual;
2216 
2217     function unstake(uint256 value) external virtual;
2218 
2219     function harvest(uint256 value) public virtual;
2220 
2221     function claim(uint256 value) public virtual;
2222 
2223     function zapStake(uint256 value, address userAddress) external virtual;
2224 }
2225 
2226 
2227 // File contracts/oracle/IWETH.sol
2228 
2229 pragma solidity ^0.6.2;
2230 
2231 abstract contract IWETH {
2232     function deposit() public payable virtual;
2233 }
2234 
2235 
2236 // File contracts/core/CookPool.sol
2237 
2238 pragma solidity ^0.6.2;
2239 
2240 
2241 
2242 
2243 
2244 
2245 
2246 
2247 contract CookPool is PoolSetters, IPool {
2248     using SafeMath for uint256;
2249     using SafeERC20 for IERC20;
2250 
2251     constructor(
2252         address cook,
2253         uint256 cook_reward_per_block,
2254         uint256 totalPoolCapLimit,
2255         uint256 stakeLimitPerAddress
2256     ) public {
2257         require(cook != address(0), "Cook address can not be empty");
2258         require(
2259             cook_reward_per_block != 0,
2260             "cook_reward_per_block can not be zero"
2261         );
2262 
2263         _state.provider.cook = IERC20(cook); //COOK
2264         _state.pauseMinig = false;
2265         // 2e18 is 2 cook token perblock
2266         _state.REWARD_PER_BLOCK = cook_reward_per_block;
2267         _state.totalPoolCapLimit = totalPoolCapLimit;
2268         _state.stakeLimitPerAddress = stakeLimitPerAddress;
2269 
2270         // Make the deployer defaul admin role and manager role
2271         _setupRole(MANAGER_ROLE, msg.sender);
2272         _setupRole(ADMIN_ROLE, msg.sender);
2273         _setRoleAdmin(MANAGER_ROLE, ADMIN_ROLE);
2274     }
2275 
2276     event Stake(address indexed account, uint256 cookAmount);
2277     event Unstake(address indexed account, uint256 cookAmount);
2278     event Claim(address indexed account, uint256 cookAmount);
2279     event Harvest(address indexed account, uint256 cookAmount);
2280     event ZapCook(address indexed account, uint256 cookAmount);
2281 
2282     function stake(uint256 cookAmount) external override {
2283         checkMiningPaused();
2284         ensureAddrNotBlacklisted(msg.sender);
2285 
2286         checkPoolStakeCapLimit(cookAmount);
2287         checkPerAddrStakeLimit(cookAmount, msg.sender);
2288 
2289         updateStakeStates(cookAmount, msg.sender);
2290         cook().safeTransferFrom(msg.sender, address(this), cookAmount);
2291         cookBalanceCheck();
2292 
2293         emit Stake(msg.sender, cookAmount);
2294     }
2295 
2296     function updateStakeStates(uint256 cookAmount, address userAddress)
2297         internal
2298     {
2299         require(cookAmount > 0, "zero stake cook amount");
2300 
2301         calculateNewRewardSinceLastRewardBlock();
2302 
2303         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
2304         uint256 newPhantom =
2305             totalStaked() == 0
2306                 ? totalRewarded() == 0
2307                     ? Constants.getInitialStakeMultiple().mul(cookAmount)
2308                     : 0
2309                 : totalRewardedWithPhantom.mul(cookAmount).div(totalStaked());
2310 
2311         incrementBalanceOfStaked(userAddress, cookAmount);
2312         incrementBalanceOfPhantom(userAddress, newPhantom);
2313     }
2314 
2315     function zapStake(uint256 cookAmount, address userAddress)
2316         external
2317         override
2318     {
2319         checkMiningPaused();
2320         ensureAddrNotBlacklisted(userAddress);
2321 
2322         checkPoolStakeCapLimit(cookAmount);
2323         checkPerAddrStakeLimit(cookAmount, userAddress);
2324 
2325         updateStakeStates(cookAmount, userAddress);
2326         cook().safeTransferFrom(msg.sender, address(this), cookAmount);
2327         cookBalanceCheck();
2328 
2329         emit ZapCook(userAddress, cookAmount);
2330     }
2331 
2332     function calculateNewRewardSinceLastRewardBlock() internal virtual {
2333         uint256 lastRewardBlock = lastRewardBlock();
2334         uint256 blockNumber = blockNumber();
2335         if (blockNumber > lastRewardBlock) {
2336             if (totalStaked() != 0) {
2337                 uint256 currentBlock = blockNumber;
2338                 uint256 numOfBlocks = currentBlock.sub(lastRewardBlock);
2339                 uint256 rewardAmount = numOfBlocks.mul(getRewardPerBlock());
2340                 incrementTotalRewarded(rewardAmount);
2341             }
2342             updateLastRewardBlock(blockNumber);
2343         }
2344         cookBalanceCheck();
2345     }
2346 
2347     function unstake(uint256 cookAmount) external override {
2348         require(cookAmount > 0, "zero unstake cook amount");
2349 
2350         uint256 stakedBalance = balanceOfStaked(msg.sender);
2351         uint256 unstakableBalance = balanceOfUnstakable(msg.sender);
2352         require(
2353             unstakableBalance >= cookAmount,
2354             "insufficient unstakable balance"
2355         );
2356 
2357         calculateNewRewardSinceLastRewardBlock();
2358 
2359         uint256 newClaimable =
2360             balanceOfRewarded(msg.sender).mul(cookAmount).div(stakedBalance);
2361         uint256 lessPhantom =
2362             balanceOfPhantom(msg.sender).mul(cookAmount).div(stakedBalance);
2363 
2364         addToVestingSchdule(msg.sender, newClaimable);
2365         decrementTotalRewarded(newClaimable, "insufficient rewarded balance");
2366         decrementBalanceOfStaked(
2367             msg.sender,
2368             cookAmount,
2369             "insufficient staked balance"
2370         );
2371         decrementBalanceOfPhantom(
2372             msg.sender,
2373             lessPhantom,
2374             "insufficient phantom balance"
2375         );
2376 
2377         cook().transfer(msg.sender, cookAmount);
2378         cookBalanceCheck();
2379 
2380         emit Unstake(msg.sender, cookAmount);
2381     }
2382 
2383     function harvest(uint256 cookAmount) public override {
2384         ensureAddrNotBlacklisted(msg.sender);
2385 
2386         require(cookAmount > 0, "zero harvest amount");
2387 
2388         require(totalRewarded() > 0, "insufficient total rewarded");
2389 
2390         require(
2391             balanceOfRewarded(msg.sender) >= cookAmount,
2392             "insufficient rewarded balance"
2393         );
2394 
2395         addToVestingSchdule(msg.sender, cookAmount);
2396         decrementTotalRewarded(cookAmount, "insufficient rewarded balance");
2397         incrementBalanceOfPhantom(msg.sender, cookAmount);
2398 
2399         cookBalanceCheck();
2400 
2401         emit Harvest(msg.sender, cookAmount);
2402     }
2403 
2404     function claim(uint256 cookAmount) public override {
2405         ensureAddrNotBlacklisted(msg.sender);
2406 
2407         require(cookAmount > 0, "zero claim cook amount");
2408 
2409         require(
2410             balanceOfClaimable(msg.sender) >= cookAmount,
2411             "insufficient claimable cook balance"
2412         );
2413 
2414         cook().safeTransfer(msg.sender, cookAmount);
2415         incrementBalanceOfClaimed(msg.sender, cookAmount);
2416 
2417         emit Claim(msg.sender, cookAmount);
2418     }
2419 
2420     function _calWethAmountToPairCook(uint256 cookAmount)
2421         internal
2422         returns (uint256, address)
2423     {
2424         IUniswapV2Pair lpPair = IUniswapV2Pair(address(univ2()));
2425 
2426         uint256 reserve0;
2427         uint256 reserve1;
2428         address weth;
2429         if (lpPair.token0() == address(cook())) {
2430             (reserve0, reserve1, ) = lpPair.getReserves();
2431             weth = lpPair.token1();
2432         } else {
2433             (reserve1, reserve0, ) = lpPair.getReserves();
2434             weth = lpPair.token0();
2435         }
2436 
2437         uint256 wethAmount =
2438             (reserve0 == 0 && reserve1 == 0)
2439                 ? cookAmount
2440                 : UniswapV2Library.quote(cookAmount, reserve0, reserve1);
2441 
2442         return (wethAmount, weth);
2443     }
2444 
2445     function zapCook(uint256 cookAmount) external {
2446         require(cookAmount > 0, "zero zap amount");
2447 
2448         require(
2449             balanceOfClaimable(msg.sender) >= cookAmount,
2450             "insufficient claimable balance"
2451         );
2452 
2453         checkMiningPaused();
2454         ensureAddrNotBlacklisted(msg.sender);
2455 
2456         checkPoolStakeCapLimit(cookAmount);
2457         checkPerAddrStakeLimit(cookAmount, msg.sender);
2458 
2459         incrementBalanceOfClaimed(msg.sender, cookAmount);
2460         updateStakeStates(cookAmount, msg.sender);
2461         cookBalanceCheck();
2462 
2463         emit ZapCook(msg.sender, cookAmount);
2464     }
2465 
2466     function cookBalanceCheck() private view {
2467         require(
2468             cook().balanceOf(address(this)) >=
2469                 totalVesting().add(totalRewarded()).sub(totalClaimed()),
2470             "Inconsistent COOK balances"
2471         );
2472     }
2473 
2474     // admin emergency to transfer token to owner
2475     function emergencyWithdraw(uint256 amount) public onlyOwner {
2476         cook().safeTransfer(msg.sender, amount);
2477     }
2478 
2479     // set cook token reward per block
2480     function setRewardPerBlock(uint256 rewardPerBlock) public {
2481         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
2482         calculateNewRewardSinceLastRewardBlock();
2483         _state.REWARD_PER_BLOCK = rewardPerBlock;
2484     }
2485 }