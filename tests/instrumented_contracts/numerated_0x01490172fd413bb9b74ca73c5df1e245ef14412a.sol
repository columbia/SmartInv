1 //
2 //    Prolly nothin...
3 //
4 //    https://t.me/SOTLerc20
5 //
6 //    Stealth launch
7 //
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // CAUTION
90 // This version of SafeMath should only be used with Solidity 0.8 or later,
91 // because it relies on the compiler's built in overflow checks.
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations.
95  *
96  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
97  * now has built in overflow checking.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             uint256 c = a + b;
108             if (c < a) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b > a) return (false, 0);
121             return (true, a - b);
122         }
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133             // benefit is lost if 'b' is also tested.
134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135             if (a == 0) return (true, 0);
136             uint256 c = a * b;
137             if (c / a != b) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b == 0) return (false, 0);
150             return (true, a / b);
151         }
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a % b);
163         }
164     }
165 
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      *
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a + b;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a - b;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a * b;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator.
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b <= a, errorMessage);
258             return a - b;
259         }
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a / b;
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * reverting with custom message when dividing by zero.
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {tryMod}.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a % b;
308         }
309     }
310 }
311 
312 /**
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 
332 /**
333  * @dev Contract module which provides a basic access control mechanism, where
334  * there is an account (an owner) that can be granted exclusive access to
335  * specific functions.
336  *
337  * By default, the owner account will be the one that deploys the contract. This
338  * can later be changed with {transferOwnership}.
339  *
340  * This module is used through inheritance. It will make available the modifier
341  * `onlyOwner`, which can be applied to your functions to restrict their use to
342  * the owner.
343  */
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     /**
350      * @dev Initializes the contract setting the deployer as the initial owner.
351      */
352     constructor() {
353         _setOwner(_msgSender());
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     /**
372      * @dev Leaves the contract without owner. It will not be possible to call
373      * `onlyOwner` functions anymore. Can only be called by the current owner.
374      *
375      * NOTE: Renouncing ownership will leave the contract without an owner,
376      * thereby removing any functionality that is only available to the owner.
377      */
378     function renounceOwnership() public virtual onlyOwner {
379         _setOwner(address(0));
380     }
381 
382     /**
383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
384      * Can only be called by the current owner.
385      */
386     function transferOwnership(address newOwner) public virtual onlyOwner {
387         require(newOwner != address(0), "Ownable: new owner is the zero address");
388         _setOwner(newOwner);
389     }
390 
391     function _setOwner(address newOwner) private {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 
398 /**
399  * @dev Collection of functions related to the address type
400  */
401 library Address {
402     /**
403      * @dev Returns true if `account` is a contract.
404      *
405      * [IMPORTANT]
406      * ====
407      * It is unsafe to assume that an address for which this function returns
408      * false is an externally-owned account (EOA) and not a contract.
409      *
410      * Among others, `isContract` will return false for the following
411      * types of addresses:
412      *
413      *  - an externally-owned account
414      *  - a contract in construction
415      *  - an address where a contract will be created
416      *  - an address where a contract lived, but was destroyed
417      * ====
418      */
419     function isContract(address account) internal view returns (bool) {
420         // This method relies on extcodesize, which returns 0 for contracts in
421         // construction, since the code is only stored at the end of the
422         // constructor execution.
423 
424         uint256 size;
425         assembly {
426             size := extcodesize(account)
427         }
428         return size > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(success, "Address: unable to send value, recipient may have reverted");
452     }
453 
454     /**
455      * @dev Performs a Solidity function call using a low level `call`. A
456      * plain `call` is an unsafe replacement for a function call: use this
457      * function instead.
458      *
459      * If `target` reverts with a revert reason, it is bubbled up by this
460      * function (like regular Solidity function calls).
461      *
462      * Returns the raw returned data. To convert to the expected return value,
463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
464      *
465      * Requirements:
466      *
467      * - `target` must be a contract.
468      * - calling `target` with `data` must not revert.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionCall(target, data, "Address: low-level call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
478      * `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         require(isContract(target), "Address: call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.delegatecall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584      * revert reason using the provided one.
585      *
586      * _Available since v4.3._
587      */
588     function verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) internal pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 interface IUniswapV2Pair {
612     event Approval(address indexed owner, address indexed spender, uint value);
613     event Transfer(address indexed from, address indexed to, uint value);
614 
615     function name() external pure returns (string memory);
616     function symbol() external pure returns (string memory);
617     function decimals() external pure returns (uint8);
618     function totalSupply() external view returns (uint);
619     function balanceOf(address owner) external view returns (uint);
620     function allowance(address owner, address spender) external view returns (uint);
621 
622     function approve(address spender, uint value) external returns (bool);
623     function transfer(address to, uint value) external returns (bool);
624     function transferFrom(address from, address to, uint value) external returns (bool);
625 
626     function DOMAIN_SEPARATOR() external view returns (bytes32);
627     function PERMIT_TYPEHASH() external pure returns (bytes32);
628     function nonces(address owner) external view returns (uint);
629 
630     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
631 
632     event Mint(address indexed sender, uint amount0, uint amount1);
633     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
634     event Swap(
635         address indexed sender,
636         uint amount0In,
637         uint amount1In,
638         uint amount0Out,
639         uint amount1Out,
640         address indexed to
641     );
642     event Sync(uint112 reserve0, uint112 reserve1);
643 
644     function MINIMUM_LIQUIDITY() external pure returns (uint);
645     function factory() external view returns (address);
646     function token0() external view returns (address);
647     function token1() external view returns (address);
648     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
649     function price0CumulativeLast() external view returns (uint);
650     function price1CumulativeLast() external view returns (uint);
651     function kLast() external view returns (uint);
652 
653     function mint(address to) external returns (uint liquidity);
654     function burn(address to) external returns (uint amount0, uint amount1);
655     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
656     function skim(address to) external;
657     function sync() external;
658 
659     function initialize(address, address) external;
660 }
661 
662 interface IUniswapV2Factory {
663     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
664 
665     function feeTo() external view returns (address);
666     function feeToSetter() external view returns (address);
667 
668     function getPair(address tokenA, address tokenB) external view returns (address pair);
669     function allPairs(uint) external view returns (address pair);
670     function allPairsLength() external view returns (uint);
671 
672     function createPair(address tokenA, address tokenB) external returns (address pair);
673 
674     function setFeeTo(address) external;
675     function setFeeToSetter(address) external;
676 }
677 
678 interface IUniswapV2Router01 {
679     function factory() external pure returns (address);
680     function WETH() external pure returns (address);
681 
682     function addLiquidity(
683         address tokenA,
684         address tokenB,
685         uint amountADesired,
686         uint amountBDesired,
687         uint amountAMin,
688         uint amountBMin,
689         address to,
690         uint deadline
691     ) external returns (uint amountA, uint amountB, uint liquidity);
692     function addLiquidityETH(
693         address token,
694         uint amountTokenDesired,
695         uint amountTokenMin,
696         uint amountETHMin,
697         address to,
698         uint deadline
699     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
700     function removeLiquidity(
701         address tokenA,
702         address tokenB,
703         uint liquidity,
704         uint amountAMin,
705         uint amountBMin,
706         address to,
707         uint deadline
708     ) external returns (uint amountA, uint amountB);
709     function removeLiquidityETH(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline
716     ) external returns (uint amountToken, uint amountETH);
717     function removeLiquidityWithPermit(
718         address tokenA,
719         address tokenB,
720         uint liquidity,
721         uint amountAMin,
722         uint amountBMin,
723         address to,
724         uint deadline,
725         bool approveMax, uint8 v, bytes32 r, bytes32 s
726     ) external returns (uint amountA, uint amountB);
727     function removeLiquidityETHWithPermit(
728         address token,
729         uint liquidity,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline,
734         bool approveMax, uint8 v, bytes32 r, bytes32 s
735     ) external returns (uint amountToken, uint amountETH);
736     function swapExactTokensForTokens(
737         uint amountIn,
738         uint amountOutMin,
739         address[] calldata path,
740         address to,
741         uint deadline
742     ) external returns (uint[] memory amounts);
743     function swapTokensForExactTokens(
744         uint amountOut,
745         uint amountInMax,
746         address[] calldata path,
747         address to,
748         uint deadline
749     ) external returns (uint[] memory amounts);
750     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
751         external
752         payable
753         returns (uint[] memory amounts);
754     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
755         external
756         returns (uint[] memory amounts);
757     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
758         external
759         returns (uint[] memory amounts);
760     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
761         external
762         payable
763         returns (uint[] memory amounts);
764 
765     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
766     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
767     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
768     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
769     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
770 }
771 
772 interface IUniswapV2Router02 is IUniswapV2Router01 {
773     function removeLiquidityETHSupportingFeeOnTransferTokens(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountETH);
781     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
782         address token,
783         uint liquidity,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external returns (uint amountETH);
790 
791     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
792         uint amountIn,
793         uint amountOutMin,
794         address[] calldata path,
795         address to,
796         uint deadline
797     ) external;
798     function swapExactETHForTokensSupportingFeeOnTransferTokens(
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external payable;
804     function swapExactTokensForETHSupportingFeeOnTransferTokens(
805         uint amountIn,
806         uint amountOutMin,
807         address[] calldata path,
808         address to,
809         uint deadline
810     ) external;
811 }
812 
813 /**
814  * @dev Interface for the Buy Back Reward contract that can be used to build
815  * custom logic to elevate user rewards
816  */
817 interface IConditional {
818   /**
819    * @dev Returns whether a wallet passes the test.
820    */
821   function passesTest(address wallet) external view returns (bool);
822 }
823 
824 contract SOTL is Context, IERC20, Ownable {
825   using SafeMath for uint256;
826   using Address for address;
827 
828   address payable public treasuryWallet =
829     payable(0x18c83D4aAcaDf3426C63a77fB4C4bfC7b69E1b70);
830   address public constant deadAddress =
831     0x000000000000000000000000000000000000dEaD;
832 
833   mapping(address => uint256) private _rOwned;
834   mapping(address => uint256) private _tOwned;
835   mapping(address => mapping(address => uint256)) private _allowances;
836   mapping(address => bool) private _isSniper;
837   address[] private _confirmedSnipers;
838 
839   uint256 public rewardsClaimTimeSeconds = 60 * 60; // 
840 
841   mapping(address => uint256) private _rewardsLastClaim;
842 
843   mapping(address => bool) private _isExcludedFee;
844   mapping(address => bool) private _isExcludedReward;
845   address[] private _excluded;
846 
847   string private constant _name = 'Seekers Of The Light';
848   string private constant _symbol = 'SOTL';
849   uint8 private constant _decimals = 9;
850 
851   uint256 private constant MAX = ~uint256(0);
852   uint256 private constant _tTotal = 1e5 * 10**_decimals;
853   uint256 private _rTotal = (MAX - (MAX % _tTotal));
854   uint256 private _tFeeTotal;
855 
856   uint256 public reflectionFee = 0;
857   uint256 private _previousReflectFee = reflectionFee;
858 
859   uint256 public treasuryFee = 5;
860   uint256 private _previousTreasuryFee = treasuryFee;
861 
862   uint256 public ethRewardsFee = 0;
863   uint256 private _previousETHRewardsFee = ethRewardsFee;
864   uint256 public ethRewardsBalance;
865 
866   uint256 public buybackFee = 0;
867   uint256 private _previousBuybackFee = buybackFee;
868   address public buybackTokenAddress = 0x69a4BA91b5a0603178B4d2BD9BBc5Cfcca0c33aC;
869   address public buybackReceiver = address(this);
870 
871   uint256 public feeSellMultiplier = 2;
872   uint256 public feeRate = 10;
873   uint256 public launchTime;
874 
875   uint256 public boostRewardsPercent = 50;
876 
877   address public boostRewardsContract;
878   address public feeExclusionContract;
879 
880   IUniswapV2Router02 public uniswapV2Router;
881   address public uniswapV2Pair;
882   mapping(address => bool) private _isUniswapPair;
883 
884   // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
885   // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
886   address private constant _uniswapRouterAddress =
887     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
888 
889   bool private _inSwapAndLiquify;
890   bool private _isSelling;
891   bool private _tradingOpen = false;
892   bool private _isMaxBuyActivated = true;
893 
894   uint256 public _maxTxAmount = _tTotal.mul(1).div(100); // 1.0%
895   uint256 public _maxWalletSize = _tTotal.mul(2).div(100); // 2.0%
896   uint256 public _maximumBuyAmount = _tTotal.mul(1).div(100); // 1.0%
897 
898   event MaxTxAmountUpdated(uint256 _maxTxAmount);
899   event MaxWalletSizeUpdated(uint256 _maxWalletSize);
900   event SendETHRewards(address to, uint256 amountETH);
901   event SendTokenRewards(address to, address token, uint256 amount);
902   event SwapETHForTokens(address whereTo, uint256 amountIn, address[] path);
903   event SwapTokensForETH(uint256 amountIn, address[] path);
904   event SwapAndLiquify(
905     uint256 tokensSwappedForEth,
906     uint256 ethAddedForLp,
907     uint256 tokensAddedForLp
908   );
909 
910   modifier lockTheSwap() {
911     _inSwapAndLiquify = true;
912     _;
913     _inSwapAndLiquify = false;
914   }
915 
916   constructor() {
917     _rOwned[_msgSender()] = _rTotal;
918     emit Transfer(address(0), _msgSender(), _tTotal);
919   }
920 
921   function initContract() external onlyOwner {
922     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
923       _uniswapRouterAddress
924     );
925     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
926       address(this),
927       _uniswapV2Router.WETH()
928     );
929 
930     uniswapV2Router = _uniswapV2Router;
931 
932     _isExcludedFee[owner()] = true;
933     _isExcludedFee[address(this)] = true;
934     _isExcludedFee[treasuryWallet] = true;
935   }
936 
937   function openTrading() external onlyOwner {
938     treasuryFee = _previousTreasuryFee;
939     ethRewardsFee = _previousETHRewardsFee;
940     reflectionFee = _previousReflectFee;
941     buybackFee = _previousBuybackFee;
942     _tradingOpen = true;
943     launchTime = block.timestamp;
944   }
945 
946   function name() external pure returns (string memory) {
947     return _name;
948   }
949 
950   function symbol() external pure returns (string memory) {
951     return _symbol;
952   }
953 
954   function decimals() external pure returns (uint8) {
955     return _decimals;
956   }
957 
958   function totalSupply() external pure override returns (uint256) {
959     return _tTotal;
960   }
961 
962   function MaxTXAmount() external view returns (uint256) {
963     return _maxTxAmount;
964   }
965 
966   function MaxWalletSize() external view returns (uint256) {
967     return _maxWalletSize;
968   }
969 
970   function balanceOf(address account) public view override returns (uint256) {
971     if (_isExcludedReward[account]) return _tOwned[account];
972     return tokenFromReflection(_rOwned[account]);
973   }
974 
975   function transfer(address recipient, uint256 amount)
976     external
977     override
978     returns (bool)
979   {
980     _transfer(_msgSender(), recipient, amount);
981     return true;
982   }
983 
984   function allowance(address owner, address spender)
985     external
986     view
987     override
988     returns (uint256)
989   {
990     return _allowances[owner][spender];
991   }
992 
993   function approve(address spender, uint256 amount)
994     external
995     override
996     returns (bool)
997   {
998     _approve(_msgSender(), spender, amount);
999     return true;
1000   }
1001 
1002   function transferFrom(
1003     address sender,
1004     address recipient,
1005     uint256 amount
1006   ) external override returns (bool) {
1007     _transfer(sender, recipient, amount);
1008     _approve(
1009       sender,
1010       _msgSender(),
1011       _allowances[sender][_msgSender()].sub(
1012         amount,
1013         'ERC20: transfer amount exceeds allowance'
1014       )
1015     );
1016     return true;
1017   }
1018 
1019   function increaseAllowance(address spender, uint256 addedValue)
1020     external
1021     virtual
1022     returns (bool)
1023   {
1024     _approve(
1025       _msgSender(),
1026       spender,
1027       _allowances[_msgSender()][spender].add(addedValue)
1028     );
1029     return true;
1030   }
1031 
1032   function decreaseAllowance(address spender, uint256 subtractedValue)
1033     external
1034     virtual
1035     returns (bool)
1036   {
1037     _approve(
1038       _msgSender(),
1039       spender,
1040       _allowances[_msgSender()][spender].sub(
1041         subtractedValue,
1042         'ERC20: decreased allowance below zero'
1043       )
1044     );
1045     return true;
1046   }
1047 
1048   function setMaxTxnAmount(uint256 maxTxAmountPercetange) external onlyOwner{
1049     require(maxTxAmountPercetange < 1000, "Maximum amount per transaction must be lower than 100%");
1050     require(maxTxAmountPercetange > 1, "Maximum amount per transaction must be higher than 0.1%");
1051     _maxTxAmount = _tTotal.mul(maxTxAmountPercetange).div(1000);
1052     emit MaxTxAmountUpdated(_maxTxAmount);
1053   }
1054 
1055   function setMaxWalletSize(uint256 maxWalletSizePercentage) external onlyOwner{
1056     require(maxWalletSizePercentage < 1000, "Maximum wallet size must be lower than 100%");
1057     require(maxWalletSizePercentage > 20, "Maximum wallet size must be higher than 2%");
1058     _maxWalletSize = _tTotal.mul(maxWalletSizePercentage).div(1000);
1059     emit MaxWalletSizeUpdated(_maxWalletSize);
1060   }
1061 
1062   function getLastETHRewardsClaim(address wallet)
1063     external
1064     view
1065     returns (uint256)
1066   {
1067     return _rewardsLastClaim[wallet];
1068   }
1069 
1070   function totalFees() external view returns (uint256) {
1071     return _tFeeTotal;
1072   }
1073 
1074   function deliver(uint256 tAmount) external {
1075     address sender = _msgSender();
1076     require(
1077       !_isExcludedReward[sender],
1078       'Excluded addresses cannot call this function'
1079     );
1080     (uint256 rAmount, , , , , ) = _getValues(sender, tAmount);
1081     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1082     _rTotal = _rTotal.sub(rAmount);
1083     _tFeeTotal = _tFeeTotal.add(tAmount);
1084   }
1085 
1086   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1087     external
1088     view
1089     returns (uint256)
1090   {
1091     require(tAmount <= _tTotal, 'Amount must be less than supply');
1092     if (!deductTransferFee) {
1093       (uint256 rAmount, , , , , ) = _getValues(address(0), tAmount);
1094       return rAmount;
1095     } else {
1096       (, uint256 rTransferAmount, , , , ) = _getValues(address(0), tAmount);
1097       return rTransferAmount;
1098     }
1099   }
1100 
1101   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1102     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1103     uint256 currentRate = _getRate();
1104     return rAmount.div(currentRate);
1105   }
1106 
1107   function excludeFromReward(address account) external onlyOwner {
1108     require(!_isExcludedReward[account], 'Account is already excluded');
1109     if (_rOwned[account] > 0) {
1110       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1111     }
1112     _isExcludedReward[account] = true;
1113     _excluded.push(account);
1114   }
1115 
1116   function includeInReward(address account) external onlyOwner {
1117     require(_isExcludedReward[account], 'Account is already included');
1118     for (uint256 i = 0; i < _excluded.length; i++) {
1119       if (_excluded[i] == account) {
1120         _excluded[i] = _excluded[_excluded.length - 1];
1121         _tOwned[account] = 0;
1122         _isExcludedReward[account] = false;
1123         _excluded.pop();
1124         break;
1125       }
1126     }
1127   }
1128 
1129   function _approve(
1130     address owner,
1131     address spender,
1132     uint256 amount
1133   ) private {
1134     require(owner != address(0), 'ERC20: approve from the zero address');
1135     require(spender != address(0), 'ERC20: approve to the zero address');
1136 
1137     _allowances[owner][spender] = amount;
1138     emit Approval(owner, spender, amount);
1139   }
1140 
1141   function _transfer(
1142     address from,
1143     address to,
1144     uint256 amount
1145   ) private {
1146     require(from != address(0), 'ERC20: transfer from the zero address');
1147     require(to != address(0), 'ERC20: transfer to the zero address');
1148     require(amount > 0, 'Transfer amount must be greater than zero');
1149     require(!_isSniper[to], 'Stop sniping!');
1150     require(!_isSniper[from], 'Stop sniping!');
1151     require(!_isSniper[_msgSender()], 'Stop sniping!');
1152 
1153     //check transaction amount only when selling
1154     if (
1155       (to == uniswapV2Pair || _isUniswapPair[to]) && 
1156       from != address(uniswapV2Router) &&
1157       !isExcludedFromFee(to) &&
1158       !isExcludedFromFee(from)
1159     ) {
1160         require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
1161     }
1162 
1163     if (
1164       to != uniswapV2Pair &&
1165       !_isUniswapPair[to] &&
1166       !isExcludedFromFee(to) && 
1167       !isExcludedFromFee(from)
1168       ) {
1169       require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
1170       if (_isMaxBuyActivated) {
1171         if (block.timestamp <= launchTime + 30 minutes) {
1172           require(amount <= _maximumBuyAmount, "Amount too much");
1173         }
1174       }
1175     }
1176 
1177     // reset receiver's timer to prevent users buying and
1178     // immmediately transferring to buypass timer
1179     _rewardsLastClaim[to] = block.timestamp;
1180 
1181     bool excludedFromFee = false;
1182 
1183     // buy
1184     if (
1185       (from == uniswapV2Pair || _isUniswapPair[from]) &&
1186       to != address(uniswapV2Router)
1187     ) {
1188       // normal buy, check for snipers
1189       if (!isExcludedFromFee(to)) {
1190         require(_tradingOpen, 'Trading not yet enabled.');
1191 
1192         // antibot
1193         if (block.timestamp == launchTime) {
1194           _isSniper[to] = true;
1195           _confirmedSnipers.push(to);
1196         }
1197         _rewardsLastClaim[from] = block.timestamp;
1198       } else {
1199         // set excluded flag for takeFee below since buyer is excluded
1200         excludedFromFee = true;
1201       }
1202     }
1203 
1204     // sell
1205     if (
1206       !_inSwapAndLiquify &&
1207       _tradingOpen &&
1208       (to == uniswapV2Pair || _isUniswapPair[to])
1209     ) {
1210       uint256 _contractTokenBalance = balanceOf(address(this));
1211       if (_contractTokenBalance > 0) {
1212         if (
1213           _contractTokenBalance > balanceOf(uniswapV2Pair).mul(feeRate).div(100)
1214         ) {
1215           _contractTokenBalance = balanceOf(uniswapV2Pair).mul(feeRate).div(
1216             100
1217           );
1218         }
1219         _swapTokens(_contractTokenBalance);
1220       }
1221       _rewardsLastClaim[from] = block.timestamp;
1222       _isSelling = true;
1223       excludedFromFee = isExcludedFromFee(from);
1224     }
1225 
1226     bool takeFee = false;
1227 
1228     // take fee only on swaps
1229     if (
1230       (from == uniswapV2Pair ||
1231         to == uniswapV2Pair ||
1232         _isUniswapPair[to] ||
1233         _isUniswapPair[from]) && !excludedFromFee
1234     ) {
1235       takeFee = true;
1236     }
1237 
1238     _tokenTransfer(from, to, amount, takeFee);
1239     _isSelling = false;
1240   }
1241 
1242   function _swapTokens(uint256 _contractTokenBalance) private lockTheSwap {
1243     uint256 ethBalanceBefore = address(this).balance;
1244     _swapTokensForEth(_contractTokenBalance);
1245     uint256 ethBalanceAfter = address(this).balance;
1246     uint256 ethBalanceUpdate = ethBalanceAfter.sub(ethBalanceBefore);
1247     uint256 _liquidityFeeTotal = _liquidityFeeAggregate(address(0));
1248 
1249     ethRewardsBalance += ethBalanceUpdate.mul(ethRewardsFee).div(
1250       _liquidityFeeTotal
1251     );
1252 
1253     // send ETH to treasury address
1254     uint256 treasuryETHBalance = ethBalanceUpdate.mul(treasuryFee).div(
1255       _liquidityFeeTotal
1256     );
1257     if (treasuryETHBalance > 0) {
1258       _sendETHToTreasury(treasuryETHBalance);
1259     }
1260 
1261     // buy back
1262     uint256 buybackETHBalance = ethBalanceUpdate.mul(buybackFee).div(
1263       _liquidityFeeTotal
1264     );
1265     if (buybackETHBalance > 0) {
1266       _buyBackTokens(buybackETHBalance);
1267     }
1268   }
1269 
1270   function _sendETHToTreasury(uint256 amount) private {
1271     treasuryWallet.call{ value: amount }('');
1272   }
1273 
1274   function _buyBackTokens(uint256 amount) private {
1275     // generate the uniswap pair path of token -> weth
1276     address[] memory path = new address[](2);
1277     path[0] = uniswapV2Router.WETH();
1278     path[1] = buybackTokenAddress;
1279 
1280     // make the swap
1281     uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1282       value: amount
1283     }(
1284       0, // accept any amount of tokens
1285       path,
1286       buybackReceiver,
1287       block.timestamp
1288     );
1289 
1290     emit SwapETHForTokens(buybackReceiver, amount, path);
1291   }
1292 
1293   function _swapTokensForEth(uint256 tokenAmount) private {
1294     // generate the uniswap pair path of token -> weth
1295     address[] memory path = new address[](2);
1296     path[0] = address(this);
1297     path[1] = uniswapV2Router.WETH();
1298 
1299     _approve(address(this), address(uniswapV2Router), tokenAmount);
1300 
1301     // make the swap
1302     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1303       tokenAmount,
1304       0, // accept any amount of ETH
1305       path,
1306       address(this), // the contract
1307       block.timestamp
1308     );
1309 
1310     emit SwapTokensForETH(tokenAmount, path);
1311   }
1312 
1313   function _tokenTransfer(
1314     address sender,
1315     address recipient,
1316     uint256 amount,
1317     bool takeFee
1318   ) private {
1319     if (!takeFee) _removeAllFee();
1320 
1321     if (_isExcludedReward[sender] && !_isExcludedReward[recipient]) {
1322       _transferFromExcluded(sender, recipient, amount);
1323     } else if (!_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1324       _transferToExcluded(sender, recipient, amount);
1325     } else if (_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1326       _transferBothExcluded(sender, recipient, amount);
1327     } else {
1328       _transferStandard(sender, recipient, amount);
1329     }
1330 
1331     if (!takeFee) _restoreAllFee();
1332   }
1333 
1334   function _transferStandard(
1335     address sender,
1336     address recipient,
1337     uint256 tAmount
1338   ) private {
1339     (
1340       uint256 rAmount,
1341       uint256 rTransferAmount,
1342       uint256 rFee,
1343       uint256 tTransferAmount,
1344       uint256 tFee,
1345       uint256 tLiquidity
1346     ) = _getValues(sender, tAmount);
1347     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1348     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1349     _takeLiquidity(tLiquidity);
1350     _reflectFee(rFee, tFee);
1351     emit Transfer(sender, recipient, tTransferAmount);
1352   }
1353 
1354   function _transferToExcluded(
1355     address sender,
1356     address recipient,
1357     uint256 tAmount
1358   ) private {
1359     (
1360       uint256 rAmount,
1361       uint256 rTransferAmount,
1362       uint256 rFee,
1363       uint256 tTransferAmount,
1364       uint256 tFee,
1365       uint256 tLiquidity
1366     ) = _getValues(sender, tAmount);
1367     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1368     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1369     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1370     _takeLiquidity(tLiquidity);
1371     _reflectFee(rFee, tFee);
1372     emit Transfer(sender, recipient, tTransferAmount);
1373   }
1374 
1375   function _transferFromExcluded(
1376     address sender,
1377     address recipient,
1378     uint256 tAmount
1379   ) private {
1380     (
1381       uint256 rAmount,
1382       uint256 rTransferAmount,
1383       uint256 rFee,
1384       uint256 tTransferAmount,
1385       uint256 tFee,
1386       uint256 tLiquidity
1387     ) = _getValues(sender, tAmount);
1388     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1389     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1390     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1391     _takeLiquidity(tLiquidity);
1392     _reflectFee(rFee, tFee);
1393     emit Transfer(sender, recipient, tTransferAmount);
1394   }
1395 
1396   function _transferBothExcluded(
1397     address sender,
1398     address recipient,
1399     uint256 tAmount
1400   ) private {
1401     (
1402       uint256 rAmount,
1403       uint256 rTransferAmount,
1404       uint256 rFee,
1405       uint256 tTransferAmount,
1406       uint256 tFee,
1407       uint256 tLiquidity
1408     ) = _getValues(sender, tAmount);
1409     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1410     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1411     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1412     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1413     _takeLiquidity(tLiquidity);
1414     _reflectFee(rFee, tFee);
1415     emit Transfer(sender, recipient, tTransferAmount);
1416   }
1417 
1418   function _reflectFee(uint256 rFee, uint256 tFee) private {
1419     _rTotal = _rTotal.sub(rFee);
1420     _tFeeTotal = _tFeeTotal.add(tFee);
1421   }
1422 
1423   function _getValues(address seller, uint256 tAmount)
1424     private
1425     view
1426     returns (
1427       uint256,
1428       uint256,
1429       uint256,
1430       uint256,
1431       uint256,
1432       uint256
1433     )
1434   {
1435     (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
1436       seller,
1437       tAmount
1438     );
1439     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1440       tAmount,
1441       tFee,
1442       tLiquidity,
1443       _getRate()
1444     );
1445     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1446   }
1447 
1448   function _getTValues(address seller, uint256 tAmount)
1449     private
1450     view
1451     returns (
1452       uint256,
1453       uint256,
1454       uint256
1455     )
1456   {
1457     uint256 tFee = _calculateReflectFee(tAmount);
1458     uint256 tLiquidity = _calculateLiquidityFee(seller, tAmount);
1459     uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1460     return (tTransferAmount, tFee, tLiquidity);
1461   }
1462 
1463   function _getRValues(
1464     uint256 tAmount,
1465     uint256 tFee,
1466     uint256 tLiquidity,
1467     uint256 currentRate
1468   )
1469     private
1470     pure
1471     returns (
1472       uint256,
1473       uint256,
1474       uint256
1475     )
1476   {
1477     uint256 rAmount = tAmount.mul(currentRate);
1478     uint256 rFee = tFee.mul(currentRate);
1479     uint256 rLiquidity = tLiquidity.mul(currentRate);
1480     uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1481     return (rAmount, rTransferAmount, rFee);
1482   }
1483 
1484   function _getRate() private view returns (uint256) {
1485     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1486     return rSupply.div(tSupply);
1487   }
1488 
1489   function _getCurrentSupply() private view returns (uint256, uint256) {
1490     uint256 rSupply = _rTotal;
1491     uint256 tSupply = _tTotal;
1492     for (uint256 i = 0; i < _excluded.length; i++) {
1493       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1494         return (_rTotal, _tTotal);
1495       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1496       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1497     }
1498     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1499     return (rSupply, tSupply);
1500   }
1501 
1502   function _takeLiquidity(uint256 tLiquidity) private {
1503     uint256 currentRate = _getRate();
1504     uint256 rLiquidity = tLiquidity.mul(currentRate);
1505     _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1506     if (_isExcludedReward[address(this)])
1507       _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1508   }
1509 
1510   function _calculateReflectFee(uint256 _amount)
1511     private
1512     view
1513     returns (uint256)
1514   {
1515     return _amount.mul(reflectionFee).div(10**2);
1516   }
1517 
1518   function _liquidityFeeAggregate(address seller)
1519     private
1520     view
1521     returns (uint256)
1522   {
1523     uint256 feeMultiplier = _isSelling && !canClaimRewards(seller)
1524       ? feeSellMultiplier
1525       : 1;
1526     return (treasuryFee.add(ethRewardsFee).add(buybackFee)).mul(feeMultiplier);
1527   }
1528 
1529   function _calculateLiquidityFee(address seller, uint256 _amount)
1530     private
1531     view
1532     returns (uint256)
1533   {
1534     return _amount.mul(_liquidityFeeAggregate(seller)).div(10**2);
1535   }
1536 
1537   function _removeAllFee() private {
1538     if (
1539       reflectionFee == 0 &&
1540       treasuryFee == 0 &&
1541       ethRewardsFee == 0 &&
1542       buybackFee == 0
1543     ) return;
1544 
1545     _previousReflectFee = reflectionFee;
1546     _previousTreasuryFee = treasuryFee;
1547     _previousETHRewardsFee = ethRewardsFee;
1548     _previousBuybackFee = buybackFee;
1549 
1550     reflectionFee = 0;
1551     treasuryFee = 0;
1552     ethRewardsFee = 0;
1553     buybackFee = 0;
1554   }
1555 
1556   function _restoreAllFee() private {
1557     reflectionFee = _previousReflectFee;
1558     treasuryFee = _previousTreasuryFee;
1559     ethRewardsFee = _previousETHRewardsFee;
1560     buybackFee = _previousBuybackFee;
1561   }
1562 
1563   function getSellSlippage(address seller) external view returns (uint256) {
1564     uint256 feeAgg = treasuryFee.add(ethRewardsFee).add(buybackFee);
1565     return
1566       isExcludedFromFee(seller) ? 0 : !canClaimRewards(seller)
1567         ? feeAgg.mul(feeSellMultiplier)
1568         : feeAgg;
1569   }
1570 
1571   function isUniswapPair(address _pair) external view returns (bool) {
1572     if (_pair == uniswapV2Pair) return true;
1573     return _isUniswapPair[_pair];
1574   }
1575 
1576   function eligibleForRewardBooster(address wallet) public view returns (bool) {
1577     return
1578       boostRewardsContract != address(0) &&
1579       IConditional(boostRewardsContract).passesTest(wallet);
1580   }
1581 
1582   function isExcludedFromFee(address account) public view returns (bool) {
1583     return
1584       _isExcludedFee[account] ||
1585       (feeExclusionContract != address(0) &&
1586         IConditional(feeExclusionContract).passesTest(account));
1587   }
1588 
1589   function isExcludedFromReward(address account) external view returns (bool) {
1590     return _isExcludedReward[account];
1591   }
1592 
1593   function excludeFromFee(address account) external onlyOwner {
1594     _isExcludedFee[account] = true;
1595   }
1596 
1597   function includeInFee(address account) external onlyOwner {
1598     _isExcludedFee[account] = false;
1599   }
1600 
1601   function setRewardsClaimTimeSeconds(uint256 _seconds) external onlyOwner {
1602     require(_seconds >= 0 &&_seconds <= 60 * 60 * 24 * 7, 'claim time delay must be greater or equal to 0 seconds and less than or equal to 7 days');
1603     rewardsClaimTimeSeconds = _seconds;
1604   }
1605   
1606   // tax can be raised to maximum 10% - buy and 20% - sell
1607   function setNewFeesPercentages(uint256 _reflectionNewFee, uint256 _treasuryNewFee, uint256 _ethRewardsNewFee, uint256 _buybackRewardsNewFee) external onlyOwner {
1608     require(_reflectionNewFee + _treasuryNewFee + _ethRewardsNewFee + _buybackRewardsNewFee <= 10, 'Tax cannot be higher than 10%');
1609     reflectionFee = _reflectionNewFee;
1610     treasuryFee = _treasuryNewFee;
1611     ethRewardsFee = _ethRewardsNewFee;
1612     buybackFee = _buybackRewardsNewFee;
1613   }
1614 
1615   function setFeeSellMultiplier(uint256 multiplier) external onlyOwner {
1616     require(multiplier <= 2, 'must be less than or equal to 2');
1617     feeSellMultiplier = multiplier;
1618   }
1619 
1620   function setTreasuryAddress(address _treasuryWallet) external onlyOwner {
1621     treasuryWallet = payable(_treasuryWallet);
1622     _isExcludedFee[treasuryWallet] = true;
1623   }
1624 
1625   function setIsMaxBuyActivated(bool _value) public onlyOwner {
1626     _isMaxBuyActivated = _value;
1627   }
1628 
1629   function setBuybackTokenAddress(address _tokenAddress) external onlyOwner {
1630     buybackTokenAddress = _tokenAddress;
1631   }
1632 
1633   function setBuybackReceiver(address _receiver) external onlyOwner {
1634     buybackReceiver = _receiver;
1635   }
1636 
1637   function addUniswapPair(address _pair) external onlyOwner {
1638     _isUniswapPair[_pair] = true;
1639   }
1640 
1641   function removeUniswapPair(address _pair) external onlyOwner {
1642     _isUniswapPair[_pair] = false;
1643   }
1644 
1645   function setBoostRewardsPercent(uint256 perc) external onlyOwner {
1646     boostRewardsPercent = perc;
1647   }
1648 
1649   function setBoostRewardsContract(address _contract) external onlyOwner {
1650     if (_contract != address(0)) {
1651       IConditional _contCheck = IConditional(_contract);
1652       // allow setting to zero address to effectively turn off check logic
1653       require(
1654         _contCheck.passesTest(address(0)) == true ||
1655           _contCheck.passesTest(address(0)) == false,
1656         'contract does not implement interface'
1657       );
1658     }
1659     boostRewardsContract = _contract;
1660   }
1661 
1662   function setFeeExclusionContract(address _contract) external onlyOwner {
1663     if (_contract != address(0)) {
1664       IConditional _contCheck = IConditional(_contract);
1665       // allow setting to zero address to effectively turn off check logic
1666       require(
1667         _contCheck.passesTest(address(0)) == true ||
1668           _contCheck.passesTest(address(0)) == false,
1669         'contract does not implement interface'
1670       );
1671     }
1672     feeExclusionContract = _contract;
1673   }
1674 
1675   function isRemovedSniper(address account) external view returns (bool) {
1676     return _isSniper[account];
1677   }
1678 
1679   function removeSniper(address account) external onlyOwner {
1680     require(account != _uniswapRouterAddress, 'We can not blacklist Uniswap');
1681     require(!_isSniper[account], 'Account is already blacklisted');
1682     _isSniper[account] = true;
1683     _confirmedSnipers.push(account);
1684   }
1685 
1686   function amnestySniper(address account) external onlyOwner {
1687     require(_isSniper[account], 'Account is not blacklisted');
1688     for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1689       if (_confirmedSnipers[i] == account) {
1690         _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1691         _isSniper[account] = false;
1692         _confirmedSnipers.pop();
1693         break;
1694       }
1695     }
1696   }
1697 
1698   function calculateETHRewards(address wallet) public view returns (uint256) {
1699     uint256 baseRewards = ethRewardsBalance.mul(balanceOf(wallet)).div(
1700       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1701     );
1702     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1703       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1704       : baseRewards;
1705     return
1706       rewardsWithBooster > ethRewardsBalance ? baseRewards : rewardsWithBooster;
1707   }
1708 
1709   function calculateTokenRewards(address wallet, address tokenAddress)
1710     public
1711     view
1712     returns (uint256)
1713   {
1714     IERC20 token = IERC20(tokenAddress);
1715     uint256 contractTokenBalance = token.balanceOf(address(this));
1716     uint256 baseRewards = contractTokenBalance.mul(balanceOf(wallet)).div(
1717       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1718     );
1719     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1720       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1721       : baseRewards;
1722     return
1723       rewardsWithBooster > contractTokenBalance
1724         ? baseRewards
1725         : rewardsWithBooster;
1726   }
1727 
1728   function claimETHRewards() external {
1729     require(
1730       balanceOf(_msgSender()) > 0,
1731       'You must have a balance to claim ETH rewards'
1732     );
1733     require(
1734       canClaimRewards(_msgSender()),
1735       'Must wait claim period before claiming rewards'
1736     );
1737     _rewardsLastClaim[_msgSender()] = block.timestamp;
1738 
1739     uint256 rewardsSent = calculateETHRewards(_msgSender());
1740     ethRewardsBalance -= rewardsSent;
1741     _msgSender().call{ value: rewardsSent }('');
1742     emit SendETHRewards(_msgSender(), rewardsSent);
1743   }
1744 
1745   function canClaimRewards(address user) public view returns (bool) {
1746     if (_rewardsLastClaim[user] == 0) {
1747       return
1748         block.timestamp > launchTime.add(rewardsClaimTimeSeconds);
1749     }
1750     else {
1751       return
1752         block.timestamp > _rewardsLastClaim[user].add(rewardsClaimTimeSeconds);
1753     }
1754   }
1755 
1756   function claimTokenRewards(address token) external {
1757     require(
1758       balanceOf(_msgSender()) > 0,
1759       'You must have a balance to claim rewards'
1760     );
1761     require(
1762       IERC20(token).balanceOf(address(this)) > 0,
1763       'We must have a token balance to claim rewards'
1764     );
1765     require(
1766       canClaimRewards(_msgSender()),
1767       'Must wait claim period before claiming rewards'
1768     );
1769     _rewardsLastClaim[_msgSender()] = block.timestamp;
1770 
1771     uint256 rewardsSent = calculateTokenRewards(_msgSender(), token);
1772     IERC20(token).transfer(_msgSender(), rewardsSent);
1773     emit SendTokenRewards(_msgSender(), token, rewardsSent);
1774   }
1775 
1776   function setFeeRate(uint256 _rate) external onlyOwner {
1777     feeRate = _rate;
1778   }
1779 
1780   function manualswap(uint256 amount) external onlyOwner {
1781     require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1782     _swapTokens(amount);
1783   }
1784 
1785   function emergencyWithdraw() external onlyOwner {
1786     payable(owner()).send(address(this).balance);
1787   }
1788 
1789   // to recieve ETH from uniswapV2Router when swaping
1790   receive() external payable {}
1791 }