1 // Sources flattened with hardhat v2.10.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
4 
5 // -License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216                 /// @solidity memory-safe-assembly
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
230 
231 // -License-Identifier: MIT
232 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 
257 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
258 
259 // -License-Identifier: MIT
260 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP.
266  */
267 interface IERC20 {
268     /**
269      * @dev Emitted when `value` tokens are moved from one account (`from`) to
270      * another (`to`).
271      *
272      * Note that `value` may be zero.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     /**
277      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
278      * a call to {approve}. `value` is the new allowance.
279      */
280     event Approval(address indexed owner, address indexed spender, uint256 value);
281 
282     /**
283      * @dev Returns the amount of tokens in existence.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns the amount of tokens owned by `account`.
289      */
290     function balanceOf(address account) external view returns (uint256);
291 
292     /**
293      * @dev Moves `amount` tokens from the caller's account to `to`.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transfer(address to, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Returns the remaining number of tokens that `spender` will be
303      * allowed to spend on behalf of `owner` through {transferFrom}. This is
304      * zero by default.
305      *
306      * This value changes when {approve} or {transferFrom} are called.
307      */
308     function allowance(address owner, address spender) external view returns (uint256);
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * IMPORTANT: Beware that changing an allowance with this method brings the risk
316      * that someone may use both the old and the new allowance by unfortunate
317      * transaction ordering. One possible solution to mitigate this race
318      * condition is to first reduce the spender's allowance to 0 and set the
319      * desired value afterwards:
320      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address spender, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Moves `amount` tokens from `from` to `to` using the
328      * allowance mechanism. `amount` is then deducted from the caller's
329      * allowance.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(
336         address from,
337         address to,
338         uint256 amount
339     ) external returns (bool);
340 }
341 
342 
343 // File @openzeppelin/contracts/interfaces/IERC20.sol@v4.7.3
344 
345 // -License-Identifier: MIT
346 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 
351 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.3
352 
353 // -License-Identifier: MIT
354 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 // CAUTION
359 // This version of SafeMath should only be used with Solidity 0.8 or later,
360 // because it relies on the compiler's built in overflow checks.
361 
362 /**
363  * @dev Wrappers over Solidity's arithmetic operations.
364  *
365  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
366  * now has built in overflow checking.
367  */
368 library SafeMath {
369     /**
370      * @dev Returns the addition of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         unchecked {
376             uint256 c = a + b;
377             if (c < a) return (false, 0);
378             return (true, c);
379         }
380     }
381 
382     /**
383      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         unchecked {
389             if (b > a) return (false, 0);
390             return (true, a - b);
391         }
392     }
393 
394     /**
395      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
400         unchecked {
401             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
402             // benefit is lost if 'b' is also tested.
403             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
404             if (a == 0) return (true, 0);
405             uint256 c = a * b;
406             if (c / a != b) return (false, 0);
407             return (true, c);
408         }
409     }
410 
411     /**
412      * @dev Returns the division of two unsigned integers, with a division by zero flag.
413      *
414      * _Available since v3.4._
415      */
416     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         unchecked {
418             if (b == 0) return (false, 0);
419             return (true, a / b);
420         }
421     }
422 
423     /**
424      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         unchecked {
430             if (b == 0) return (false, 0);
431             return (true, a % b);
432         }
433     }
434 
435     /**
436      * @dev Returns the addition of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `+` operator.
440      *
441      * Requirements:
442      *
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         return a + b;
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      *
457      * - Subtraction cannot overflow.
458      */
459     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
460         return a - b;
461     }
462 
463     /**
464      * @dev Returns the multiplication of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `*` operator.
468      *
469      * Requirements:
470      *
471      * - Multiplication cannot overflow.
472      */
473     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474         return a * b;
475     }
476 
477     /**
478      * @dev Returns the integer division of two unsigned integers, reverting on
479      * division by zero. The result is rounded towards zero.
480      *
481      * Counterpart to Solidity's `/` operator.
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(uint256 a, uint256 b) internal pure returns (uint256) {
488         return a / b;
489     }
490 
491     /**
492      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
493      * reverting when dividing by zero.
494      *
495      * Counterpart to Solidity's `%` operator. This function uses a `revert`
496      * opcode (which leaves remaining gas untouched) while Solidity uses an
497      * invalid opcode to revert (consuming all remaining gas).
498      *
499      * Requirements:
500      *
501      * - The divisor cannot be zero.
502      */
503     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504         return a % b;
505     }
506 
507     /**
508      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
509      * overflow (when the result is negative).
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {trySub}.
513      *
514      * Counterpart to Solidity's `-` operator.
515      *
516      * Requirements:
517      *
518      * - Subtraction cannot overflow.
519      */
520     function sub(
521         uint256 a,
522         uint256 b,
523         string memory errorMessage
524     ) internal pure returns (uint256) {
525         unchecked {
526             require(b <= a, errorMessage);
527             return a - b;
528         }
529     }
530 
531     /**
532      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
533      * division by zero. The result is rounded towards zero.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(
544         uint256 a,
545         uint256 b,
546         string memory errorMessage
547     ) internal pure returns (uint256) {
548         unchecked {
549             require(b > 0, errorMessage);
550             return a / b;
551         }
552     }
553 
554     /**
555      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
556      * reverting with custom message when dividing by zero.
557      *
558      * CAUTION: This function is deprecated because it requires allocating memory for the error
559      * message unnecessarily. For custom revert reasons use {tryMod}.
560      *
561      * Counterpart to Solidity's `%` operator. This function uses a `revert`
562      * opcode (which leaves remaining gas untouched) while Solidity uses an
563      * invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function mod(
570         uint256 a,
571         uint256 b,
572         string memory errorMessage
573     ) internal pure returns (uint256) {
574         unchecked {
575             require(b > 0, errorMessage);
576             return a % b;
577         }
578     }
579 }
580 
581 
582 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
583 
584 // -License-Identifier: MIT
585 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Contract module which provides a basic access control mechanism, where
591  * there is an account (an owner) that can be granted exclusive access to
592  * specific functions.
593  *
594  * By default, the owner account will be the one that deploys the contract. This
595  * can later be changed with {transferOwnership}.
596  *
597  * This module is used through inheritance. It will make available the modifier
598  * `onlyOwner`, which can be applied to your functions to restrict their use to
599  * the owner.
600  */
601 abstract contract Ownable is Context {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605 
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor() {
610         _transferOwnership(_msgSender());
611     }
612 
613     /**
614      * @dev Throws if called by any account other than the owner.
615      */
616     modifier onlyOwner() {
617         _checkOwner();
618         _;
619     }
620 
621     /**
622      * @dev Returns the address of the current owner.
623      */
624     function owner() public view virtual returns (address) {
625         return _owner;
626     }
627 
628     /**
629      * @dev Throws if the sender is not the owner.
630      */
631     function _checkOwner() internal view virtual {
632         require(owner() == _msgSender(), "Ownable: caller is not the owner");
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         _transferOwnership(address(0));
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         _transferOwnership(newOwner);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      * Internal function without access restriction.
658      */
659     function _transferOwnership(address newOwner) internal virtual {
660         address oldOwner = _owner;
661         _owner = newOwner;
662         emit OwnershipTransferred(oldOwner, newOwner);
663     }
664 }
665 
666 
667 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
668 
669 pragma solidity >=0.6.2;
670 
671 interface IUniswapV2Router01 {
672     function factory() external pure returns (address);
673     function WETH() external pure returns (address);
674 
675     function addLiquidity(
676         address tokenA,
677         address tokenB,
678         uint amountADesired,
679         uint amountBDesired,
680         uint amountAMin,
681         uint amountBMin,
682         address to,
683         uint deadline
684     ) external returns (uint amountA, uint amountB, uint liquidity);
685     function addLiquidityETH(
686         address token,
687         uint amountTokenDesired,
688         uint amountTokenMin,
689         uint amountETHMin,
690         address to,
691         uint deadline
692     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
693     function removeLiquidity(
694         address tokenA,
695         address tokenB,
696         uint liquidity,
697         uint amountAMin,
698         uint amountBMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountA, uint amountB);
702     function removeLiquidityETH(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline
709     ) external returns (uint amountToken, uint amountETH);
710     function removeLiquidityWithPermit(
711         address tokenA,
712         address tokenB,
713         uint liquidity,
714         uint amountAMin,
715         uint amountBMin,
716         address to,
717         uint deadline,
718         bool approveMax, uint8 v, bytes32 r, bytes32 s
719     ) external returns (uint amountA, uint amountB);
720     function removeLiquidityETHWithPermit(
721         address token,
722         uint liquidity,
723         uint amountTokenMin,
724         uint amountETHMin,
725         address to,
726         uint deadline,
727         bool approveMax, uint8 v, bytes32 r, bytes32 s
728     ) external returns (uint amountToken, uint amountETH);
729     function swapExactTokensForTokens(
730         uint amountIn,
731         uint amountOutMin,
732         address[] calldata path,
733         address to,
734         uint deadline
735     ) external returns (uint[] memory amounts);
736     function swapTokensForExactTokens(
737         uint amountOut,
738         uint amountInMax,
739         address[] calldata path,
740         address to,
741         uint deadline
742     ) external returns (uint[] memory amounts);
743     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
744         external
745         payable
746         returns (uint[] memory amounts);
747     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
748         external
749         returns (uint[] memory amounts);
750     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
751         external
752         returns (uint[] memory amounts);
753     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
754         external
755         payable
756         returns (uint[] memory amounts);
757 
758     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
759     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
760     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
761     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
762     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
763 }
764 
765 
766 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
767 
768 pragma solidity >=0.6.2;
769 
770 interface IUniswapV2Router02 is IUniswapV2Router01 {
771     function removeLiquidityETHSupportingFeeOnTransferTokens(
772         address token,
773         uint liquidity,
774         uint amountTokenMin,
775         uint amountETHMin,
776         address to,
777         uint deadline
778     ) external returns (uint amountETH);
779     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountETH);
788 
789     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
790         uint amountIn,
791         uint amountOutMin,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external;
796     function swapExactETHForTokensSupportingFeeOnTransferTokens(
797         uint amountOutMin,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external payable;
802     function swapExactTokensForETHSupportingFeeOnTransferTokens(
803         uint amountIn,
804         uint amountOutMin,
805         address[] calldata path,
806         address to,
807         uint deadline
808     ) external;
809 }
810 
811 
812 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.0
813 
814 pragma solidity >=0.5.0;
815 
816 interface IUniswapV2Factory {
817     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
818 
819     function feeTo() external view returns (address);
820     function feeToSetter() external view returns (address);
821 
822     function getPair(address tokenA, address tokenB) external view returns (address pair);
823     function allPairs(uint) external view returns (address pair);
824     function allPairsLength() external view returns (uint);
825 
826     function createPair(address tokenA, address tokenB) external returns (address pair);
827 
828     function setFeeTo(address) external;
829     function setFeeToSetter(address) external;
830 }
831 
832 
833 // File @uniswap/v2-periphery/contracts/interfaces/IWETH.sol@v1.1.0-beta.0
834 
835 pragma solidity >=0.5.0;
836 
837 interface IWETH {
838     function deposit() external payable;
839     function transfer(address to, uint value) external returns (bool);
840     function withdraw(uint) external;
841 }
842 
843 
844 // File contracts/LuckyToad.sol
845 
846 /*
847  * 
848  *  __         __  __     ______     __  __     __  __        ______   ______     ______     _____    
849  * /\ \       /\ \/\ \   /\  ___\   /\ \/ /    /\ \_\ \      /\__  _\ /\  __ \   /\  __ \   /\  __-.  
850  * \ \ \____  \ \ \_\ \  \ \ \____  \ \  _"-.  \ \____ \     \/_/\ \/ \ \ \/\ \  \ \  __ \  \ \ \/\ \ 
851  *  \ \_____\  \ \_____\  \ \_____\  \ \_\ \_\  \/\_____\       \ \_\  \ \_____\  \ \_\ \_\  \ \____- 
852  *   \/_____/   \/_____/   \/_____/   \/_/\/_/   \/_____/        \/_/   \/_____/   \/_/\/_/   \/____/ 
853  *
854  *
855  *                                                                                                
856  * https://t.me/LuckyToad
857  */
858 //SPDX-License-Identifier: UNLICENSED
859 
860 pragma solidity ^0.8.11;
861 // Seriously if you audit this and ping it for "no safemath used" you're gonna out yourself as an idiot
862 // SafeMath is by default included in solidity 0.8, I've only included it for the transferFrom
863 
864 contract LuckyToad is Context, IERC20, Ownable {
865 
866     
867     using SafeMath for uint256;
868     // Constants
869     string private constant _name = "LuckyToad";
870     string private constant _symbol = "TOAD";
871     // 0, 1, 2
872     uint8 private constant _bl = 2;
873     // Standard decimals 
874     uint8 private constant _decimals = 9;
875     // 1 quad
876     uint256 private constant _tTotal = 1000000000000000 * 10**9;
877     
878     // Mappings
879     mapping(address => uint256) private tokensOwned;
880     mapping(address => mapping(address => uint256)) private _allowances;
881 
882     struct mappingStructs {
883         bool _isExcludedFromFee;
884         bool _isExcludedFromRaffle;
885         bool _bots;
886         bool _isInRaffleList;
887         uint32 _lastTxBlock;
888         uint32 botBlock;
889     }
890     mapping(address => mappingStructs) mappedAddresses;
891 
892     mapping(address => uint256) private botBalance;
893     mapping(address => uint256) private airdropTokens;
894 
895 
896 
897     // Arrays
898     address[] private airdropPrivateList;
899     // List of those excluded from raffles
900     address[] private raffleExclusions;
901     // Gives us a list of where to put people in the "raffle", basically
902     address[] private tokenDistribution;
903 
904 
905     // Global variables
906   
907 
908     // Block of 256 bits
909         address payable private _feeAddrWallet1;
910         // Storage for opening block
911         uint32 private openBlock;
912         // Tax controls - how much to swap - .1% by default
913         uint32 private swapPerDivisor = 1000;
914         // Excess gas that triggers a tax sell
915         uint32 private taxGasThreshold = 400000;
916     // Storage block closed
917 
918     // Block of 256 bits
919         address payable private _feeAddrWallet2;
920         // Tax distribution ratios
921         uint32 private devRatio = 3000;
922         uint32 private marketingRatio = 3000;
923         bool private cooldownEnabled = false;
924         bool private transferCooldownEnabled = false;
925         // 16 bits remaining
926     // Storage block closed
927 
928     // Block of 256 bits
929         address payable private _feeAddrWallet3;
930         // Another tax disti ratio
931         uint32 private creatorRatio = 2000;
932         uint32 private raffleBuyTax = 0;
933         uint32 private raffleSellTax = 8000;
934     // Storage block closed
935 
936     // Block of 256 bits
937         address private uniswapV2Pair;
938         uint32 private buyTax = 8000;
939         uint32 private sellTax = 0;
940         uint32 private transferTax = 0;
941     // Storage block closed
942 
943     
944     // Block of 256 bits
945         address private _controller;
946         uint32 private maxTxDivisor = 1;
947         uint32 private maxWalletDivisor = 1;
948         bool private isBot;
949         bool private tradingOpen;
950         bool private inSwap = false;
951         bool private swapEnabled = false;
952     // Storage block closed
953     
954 
955     IUniswapV2Router02 private uniswapV2Router;
956 
957     event MaxTxAmountUpdated(uint256 _maxTxAmount);
958     // Jackpot win event
959     event JackpotWin(address indexed winner, uint256 indexed amount);
960 
961     modifier taxHolderOnly() {
962         require(
963             _msgSender() == _feeAddrWallet1 ||
964             _msgSender() == _feeAddrWallet2 ||
965             _msgSender() == _feeAddrWallet3 ||
966             _msgSender() == owner()
967         );
968         _;
969     }
970 
971     modifier onlyERC20Controller() {
972         require(
973             _controller == _msgSender(),
974             "TokenClawback: caller is not the ERC20 controller."
975         );
976         _;
977     }
978     modifier onlyDev() {
979         require(_msgSender() == _feeAddrWallet2, "LUCKY: Only developer can set this.");
980         _;
981     }
982     
983 
984     constructor() {
985         // ERC20 controller
986         _controller = payable(0x4Cdd1d9EaF9Ff87ED8235Bb5190c92EA4454D435);
987         // Marketing TODO
988         _feeAddrWallet1 = payable(0xA1588d0b520d634092bB1a13358c4522bDd6b888);
989         // Developer
990         _feeAddrWallet2 = payable(0x4Cdd1d9EaF9Ff87ED8235Bb5190c92EA4454D435);
991         // Creator TODO
992         _feeAddrWallet3 = payable(0x9c9F6c443A67a322e2682b82e720dee187F16263);
993         tokensOwned[_msgSender()] = _tTotal;
994         // Set the struct values
995         mappedAddresses[_msgSender()] = mappingStructs({_isExcludedFromFee: true, _isExcludedFromRaffle: true, _bots: false, _isInRaffleList: false, _lastTxBlock: 0, botBlock: 0});
996         mappedAddresses[address(this)] = mappingStructs({_isExcludedFromFee: true, _isExcludedFromRaffle: true, _bots: false, _isInRaffleList: false, _lastTxBlock: 0, botBlock: 0});
997         mappedAddresses[_feeAddrWallet1] = mappingStructs({_isExcludedFromFee: true, _isExcludedFromRaffle: true, _bots: false, _isInRaffleList: false, _lastTxBlock: 0, botBlock: 0});
998         mappedAddresses[_feeAddrWallet2] = mappingStructs({_isExcludedFromFee: true, _isExcludedFromRaffle: true, _bots: false, _isInRaffleList: false, _lastTxBlock: 0, botBlock: 0});
999         mappedAddresses[_feeAddrWallet3] = mappingStructs({_isExcludedFromFee: true, _isExcludedFromRaffle: true, _bots: false, _isInRaffleList: false, _lastTxBlock: 0, botBlock: 0});
1000         // Push raffle exclusions
1001         raffleExclusions.push(_msgSender());
1002         raffleExclusions.push(address(this));
1003         raffleExclusions.push(_feeAddrWallet1);
1004         raffleExclusions.push(_feeAddrWallet2);
1005         raffleExclusions.push(_feeAddrWallet3);
1006         emit Transfer(address(0), _msgSender(), _tTotal);
1007     }
1008 
1009     function name() public pure returns (string memory) {
1010         return _name;
1011     }
1012 
1013     function symbol() public pure returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     function decimals() public pure returns (uint8) {
1018         return _decimals;
1019     }
1020 
1021     function totalSupply() public pure override returns (uint256) {
1022         return _tTotal;
1023     }
1024 
1025     function balanceOf(address account) public view override returns (uint256) {
1026         return abBalance(account);
1027     }
1028 
1029     function transfer(address recipient, uint256 amount)
1030         public
1031         override
1032         returns (bool)
1033     {
1034         _transfer(_msgSender(), recipient, amount);
1035         return true;
1036     }
1037 
1038     function allowance(address owner, address spender)
1039         public
1040         view
1041         override
1042         returns (uint256)
1043     {
1044         return _allowances[owner][spender];
1045     }
1046 
1047     function approve(address spender, uint256 amount)
1048         public
1049         override
1050         returns (bool)
1051     {
1052         _approve(_msgSender(), spender, amount);
1053         return true;
1054     }
1055 
1056     function transferFrom(
1057         address sender,
1058         address recipient,
1059         uint256 amount
1060     ) public override returns (bool) {
1061         _transfer(sender, recipient, amount);
1062         _approve(
1063             sender,
1064             _msgSender(),
1065             _allowances[sender][_msgSender()].sub(
1066                 amount,
1067                 "ERC20: transfer amount exceeds allowance"
1068             )
1069         );
1070         return true;
1071     }
1072 
1073     /// @notice Sets cooldown status. Only callable by owner.
1074     /// @param onoff The boolean to set.
1075     function setCooldownEnabled(bool onoff) external onlyOwner {
1076         cooldownEnabled = onoff;
1077     }
1078 
1079     function _approve(
1080         address owner,
1081         address spender,
1082         uint256 amount
1083     ) private {
1084         require(owner != address(0), "ERC20: approve from the zero address");
1085         require(spender != address(0), "ERC20: approve to the zero address");
1086         _allowances[owner][spender] = amount;
1087         emit Approval(owner, spender, amount);
1088     }
1089 
1090 
1091     function _transfer(
1092         address from,
1093         address to,
1094         uint256 amount
1095     ) private {
1096         require(from != address(0), "ERC20: transfer from the zero address");
1097         require(to != address(0), "ERC20: transfer to the zero address");
1098         require(amount > 0, "Transfer amount must be greater than zero");
1099         isBot = false;
1100         uint32 _taxAmt;
1101         uint32 _raffleAmt;
1102 
1103         if (
1104             from != owner() &&
1105             to != owner() &&
1106             from != address(this) &&
1107             !mappedAddresses[to]._isExcludedFromFee &&
1108             !mappedAddresses[from]._isExcludedFromFee
1109         ) {
1110             require(!mappedAddresses[to]._bots && !mappedAddresses[from]._bots, "No bots.");
1111 
1112             // Buys
1113             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
1114                 
1115                 
1116                 _taxAmt = buyTax;
1117                 _raffleAmt = raffleBuyTax;
1118                 if(cooldownEnabled) {
1119                     // Check if last tx occurred this block - prevents sandwich attacks
1120                     require(mappedAddresses[to]._lastTxBlock != block.number, "LUCKY: One tx per block.");
1121                     mappedAddresses[to]._lastTxBlock = uint32(block.number);
1122                 }
1123                 // Set it now
1124                 
1125                 if(openBlock + _bl > block.number) {
1126                     // Bot
1127                     isBot = true;
1128                 } else {
1129                     checkTxMax(to, amount);
1130                 }
1131             } else if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
1132                 // Sells
1133 
1134                 // Check max tx - can't do elsewhere
1135                 require(amount <= _tTotal/maxTxDivisor, "LUCKY: Over max transaction amount.");
1136                 // Check if last tx occurred this block - prevents sandwich attacks
1137                 if(cooldownEnabled) {
1138                     require(mappedAddresses[from]._lastTxBlock != block.number, "LUCKY: One tx per block.");
1139                     mappedAddresses[from]._lastTxBlock == block.number;
1140                 }
1141                 
1142                 // Check for tax sells
1143 
1144                 {
1145                     uint256 contractTokenBalance = trueBalance(address(this));
1146 
1147                     bool canSwap = contractTokenBalance >= _tTotal/swapPerDivisor;
1148                     if (swapEnabled && canSwap && !inSwap && taxGasCheck()) {
1149                         uint32 oldTax = _taxAmt;
1150                         doTaxes(_tTotal/swapPerDivisor);
1151                         _taxAmt = oldTax;
1152                     }
1153                 }
1154                 // Sells
1155                 _taxAmt = sellTax;
1156                 _raffleAmt = raffleSellTax;
1157 
1158                 
1159             } else {
1160                 _taxAmt = transferTax;
1161                 _raffleAmt = 0;
1162             }
1163         } else {
1164             // Only make it here if it's from or to owner or from contract address.
1165             _taxAmt = 0;
1166             _raffleAmt = 0;
1167         }
1168 
1169         _tokenTransfer(from, to, amount, _taxAmt, _raffleAmt);
1170     }
1171 
1172     /// @notice Sets tax swap boolean. Only callable by owner.
1173     /// @param enabled If tax sell is enabled.
1174     function swapAndLiquifyEnabled(bool enabled) external onlyOwner {
1175         swapEnabled = enabled;
1176     }
1177 
1178     /// @notice Set the tax amount to swap per sell. Only callable by owner.
1179     /// @param divisor the divisor to set
1180     function setSwapPerSellAmount(uint32 divisor) external onlyOwner {
1181         swapPerDivisor = divisor;
1182     }
1183     
1184 
1185     function doTaxes(uint256 tokenAmount) private {
1186         inSwap = true;
1187         address[] memory path = new address[](2);
1188         path[0] = address(this);
1189         path[1] = uniswapV2Router.WETH();
1190         _approve(address(this), address(uniswapV2Router), tokenAmount);
1191 
1192         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1193             tokenAmount,
1194             0,
1195             path,
1196             address(this),
1197             block.timestamp
1198         );
1199         
1200         sendETHToFee(address(this).balance);
1201         inSwap = false;
1202     }
1203 
1204     function sellRaffle(uint256 tokenAmount) private returns (uint256 ethValue) {
1205 
1206         inSwap = true;
1207         address[] memory path = new address[](2);
1208         path[0] = address(this);
1209         path[1] = uniswapV2Router.WETH();
1210         _approve(address(this), address(uniswapV2Router), tokenAmount);
1211         uint256 oldBal = address(this).balance;
1212         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1213             tokenAmount,
1214             0,
1215             path,
1216             address(this),
1217             block.timestamp
1218         );
1219         ethValue = address(this).balance - oldBal;
1220         inSwap = false;
1221 
1222     }
1223 
1224     function sendETHToFee(uint256 amount) private {
1225         // This fixes gas reprice issues - reentrancy is not an issue as the fee wallets are trusted.
1226         uint32 divisor = marketingRatio + devRatio + creatorRatio;
1227         // Marketing
1228         Address.sendValue(_feeAddrWallet1, amount*marketingRatio/divisor);
1229         // Dev
1230         Address.sendValue(_feeAddrWallet2, amount*devRatio/divisor);
1231         // Creator
1232         Address.sendValue(_feeAddrWallet3, amount*creatorRatio/divisor);
1233     }
1234 
1235     /// @notice Sets new max tx amount. Only callable by owner.
1236     /// @param divisor The new amount to set, without 0's.
1237     function setMaxTxDivisor(uint32 divisor) external onlyOwner {
1238         maxTxDivisor = divisor;
1239     }
1240     /// @notice Sets new max wallet amount. Only callable by owner.
1241     /// @param divisor The new amount to set, without 0's.
1242     function setMaxWalletDivisor(uint32 divisor) external onlyOwner {
1243         maxWalletDivisor = divisor;
1244     }
1245 
1246     function checkTxMax(address to, uint256 amount) private view {
1247         // Not over max tx amount
1248         require(amount <= _tTotal/maxTxDivisor, "LUCKY: Over max transaction amount.");
1249         // Max wallet
1250         require(
1251             trueBalance(to) + amount <= _tTotal/maxWalletDivisor,
1252             "LUCKY: Over max wallet amount."
1253         );
1254     }
1255     /// @notice Changes wallet 1 address. Only callable by owner.
1256     /// @param newWallet The address to set as wallet 1.
1257     function changeWallet1(address newWallet) external onlyOwner {
1258         _feeAddrWallet1 = payable(newWallet);
1259     }
1260     /// @notice Changes wallet 2 address. Only callable by the ERC20 controller.
1261     /// @param newWallet The address to set as wallet 2.
1262     function changeWallet2(address newWallet) external onlyERC20Controller {
1263         _feeAddrWallet2 = payable(newWallet);
1264     }
1265 
1266     /// @notice Changes ERC20 controller address. Only callable by dev.
1267     /// @param newWallet the address to set as the controller.
1268     function changeERC20Controller(address newWallet) external onlyDev {
1269         _controller = payable(newWallet);
1270     }
1271 
1272     /// @notice Starts trading. Only callable by owner.
1273     function openTrading() public onlyOwner {
1274         require(!tradingOpen, "trading is already open");
1275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1276             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1277         );
1278         uniswapV2Router = _uniswapV2Router;
1279         _approve(address(this), address(uniswapV2Router), _tTotal);
1280         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1281             .createPair(address(this), _uniswapV2Router.WETH());
1282         // Exclude from reward
1283         mappedAddresses[address(uniswapV2Pair)]._isExcludedFromRaffle = true;
1284         raffleExclusions.push(address(uniswapV2Pair));
1285         // Exclude the uniswap router from rewards, too
1286         mappedAddresses[address(_uniswapV2Router)]._isExcludedFromRaffle = true;
1287         raffleExclusions.push(address(_uniswapV2Router));
1288         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1289             address(this),
1290             balanceOf(address(this)),
1291             0,
1292             0,
1293             owner(),
1294             block.timestamp
1295         );
1296         swapEnabled = true;
1297         cooldownEnabled = true;
1298 
1299         // No max tx
1300         maxTxDivisor = 40;
1301         // No max wallet
1302         maxWalletDivisor = 1;
1303         tradingOpen = true;
1304         openBlock = uint32(block.number);
1305         IERC20(uniswapV2Pair).approve(
1306             address(uniswapV2Router),
1307             type(uint256).max
1308         );
1309     }
1310 
1311     function doAirdropPrivate() external onlyOwner {
1312         // Do the same for private presale
1313         uint privListLen = airdropPrivateList.length;
1314         if(privListLen > 0) {
1315             isBot = false;
1316             for(uint i = 0; i < privListLen; i++) {
1317                 
1318                 address addr = airdropPrivateList[i];
1319                 _tokenTransfer(msg.sender, addr, airdropTokens[addr], 0, 0);
1320                 airdropTokens[addr] = 0;
1321             }
1322             delete airdropPrivateList;
1323         }
1324     }
1325 
1326 
1327     /// @notice Sets bot flag. Only callable by owner.
1328     /// @param theBot The address to block.
1329     function addBot(address theBot) external onlyOwner {
1330         mappedAddresses[theBot]._bots = true;
1331     }
1332 
1333     /// @notice Unsets bot flag. Only callable by owner.
1334     /// @param notbot The address to unblock.
1335     function delBot(address notbot) external onlyOwner {
1336         mappedAddresses[notbot]._bots = false;
1337     }
1338 
1339     function taxGasCheck() private view returns (bool) {
1340         // Checks we've got enough gas to swap our tax
1341         return gasleft() >= taxGasThreshold;
1342     }
1343 
1344     /// @notice Sets tax sell tax threshold. Only callable by owner.
1345     /// @param newAmt The new threshold.
1346     function setTaxGas(uint32 newAmt) external onlyOwner {
1347         taxGasThreshold = newAmt;
1348     }
1349 
1350     receive() external payable {}
1351 
1352     /// @notice Swaps total/divisor of supply in taxes for ETH. Only executable by the tax holder. Also sends them.
1353     /// @param divisor the divisor to divide supply by. 200 is .5%, 1000 is .1%.
1354     function manualSwap(uint256 divisor) external taxHolderOnly {
1355         // Get max of .5% or tokens
1356         uint256 sell;
1357         if (trueBalance(address(this)) > _tTotal/divisor) {
1358             sell = _tTotal/divisor;
1359         } else {
1360             sell = trueBalance(address(this));
1361         }
1362         doTaxes(sell);
1363     }
1364 
1365 
1366     function abBalance(address who) private view returns (uint256) {
1367         if (mappedAddresses[who].botBlock == block.number) {
1368             return botBalance[who];
1369         } else {
1370             return trueBalance(who);
1371         }
1372     }
1373 
1374     function trueBalance(address who) private view returns (uint256) {
1375         return tokensOwned[who];
1376     }
1377 
1378 
1379     //this method is responsible for taking all fee, if takeFee is true
1380     function _tokenTransfer(
1381         address sender,
1382         address recipient,
1383         uint256 amount,
1384         uint32 _taxAmt,
1385         uint32 _raffleAmt
1386     ) private {
1387         uint256 receiverAmount;
1388         uint256 taxAmount;
1389         uint256 raffleAmount;
1390         // Check bot flag
1391         if (isBot) {
1392             // Set the amounts to send around
1393             receiverAmount = 1;
1394             taxAmount = amount-receiverAmount;
1395             // Set the fake amounts
1396             mappedAddresses[recipient].botBlock = uint32(block.number);
1397             botBalance[recipient] = tokensOwned[recipient] + receiverAmount;
1398         } else {
1399             // Do the normal tax setup
1400             (taxAmount, raffleAmount) = calculateTaxesFee(amount, _taxAmt, _raffleAmt);
1401 
1402             receiverAmount = amount-taxAmount-raffleAmount;
1403             
1404         }
1405         // Actually send tokens - use helpers to do holder counts
1406         subtractTokens(sender, amount);
1407         
1408         if(raffleAmount > 0) {
1409             // Transfer the raffle amount to us or it won't actually work, since we can't sell tokens we don't have
1410             tokensOwned[address(this)] = tokensOwned[address(this)] + raffleAmount;
1411             emit Transfer(sender, address(this), raffleAmount);
1412             // Don't bother emitting a transfer as we sell it straight out
1413             // Sell raffle takings
1414             uint256 winnings = sellRaffle(raffleAmount);
1415             // Work out who won
1416 
1417             address winner = raffleWinnings(sender, receiverAmount);
1418 
1419             // We need to be careful here for reentrancy, but don't care if it fails - too bad they tried to reentrancy us or something and we're not failing a sell for it
1420             (bool success,) = winner.call{gas: 50000, value: winnings}("");
1421             if(success) {
1422                 emit JackpotWin(winner, winnings);
1423             }
1424             
1425             
1426         }
1427         // Have to add tokens AFTER, or we mess with Uniswap
1428         addTokens(recipient, receiverAmount);
1429         if(taxAmount > 0) {
1430             tokensOwned[address(this)] = tokensOwned[address(this)] + amount;
1431             emit Transfer(sender, address(this), amount);
1432         }
1433 
1434 
1435         // Emit transfers, because the specs say to
1436         emit Transfer(sender, recipient, receiverAmount);
1437         
1438     }
1439     /// @dev Does holder count maths 
1440     function subtractTokens(address account, uint256 amount) private {
1441         tokensOwned[account] = tokensOwned[account] - amount;
1442     }
1443     /// @dev Does holder count maths and adds to the raffle list if a new buyer
1444     function addTokens(address account, uint256 amount) private {
1445         if(!mappedAddresses[account]._isInRaffleList) {
1446             // Pick a slot, put yourself there, put who was there in the end
1447             // Should shuffle without huge gas - only if more than one
1448             if(tokenDistribution.length > 1) {
1449                 uint256 slot = generateNumber() % (tokenDistribution.length-1);
1450                 tokenDistribution.push(tokenDistribution[slot]);
1451                 tokenDistribution[slot] = account;
1452             } else {
1453                 // Under 10
1454                 tokenDistribution.push(account);
1455             }
1456             // Set that we're in the raffle list
1457             mappedAddresses[account]._isInRaffleList = true;
1458         }
1459         tokensOwned[account] = tokensOwned[account] + amount;
1460     }
1461 
1462     function calculateTaxesFee(uint256 _amount, uint32 _taxAmt, uint32 _raffleAmt) private pure returns (uint256 tax, uint256 raffle) {
1463         tax = _amount*_taxAmt/100000;
1464         raffle = _amount*_raffleAmt/100000;
1465     }
1466     /// @notice Returns if an account is excluded from fees.
1467     /// @param account the account to check
1468     function isExcludedFromFee(address account) public view returns (bool) {
1469         return mappedAddresses[account]._isExcludedFromFee;
1470     }
1471 
1472     /// @notice Excludes an account from fees.
1473     /// @param account the account to exclude
1474     function excludeFromFee(address account) public onlyOwner {
1475         mappedAddresses[account]._isExcludedFromFee = true;
1476     }
1477     /// @notice Includes an account in fees.
1478     /// @param account the account to include
1479     function includeInFee(address account) public onlyOwner {
1480         mappedAddresses[account]._isExcludedFromFee = false;
1481     }
1482 
1483     /// @notice Excludes an account from jackpots
1484     /// @param account the account to exclude
1485     function excludeFromRaffle(address account) public onlyOwner {
1486         require(!mappedAddresses[account]._isExcludedFromRaffle, "LuckyToad: Already excluded.");
1487         mappedAddresses[account]._isExcludedFromRaffle = true;
1488         raffleExclusions.push(account);
1489         
1490     }
1491     /// @notice Includes an account in jackpots
1492     /// @param account the account to include
1493     function includeInRaffle(address account) public onlyOwner {
1494         require(mappedAddresses[account]._isExcludedFromRaffle, "LuckyToad: Not excluded.");
1495         for (uint256 i = 0; i < raffleExclusions.length; i++) {
1496             if (raffleExclusions[i] == account) {
1497                 // Overwrite the array item containing this address with the last array item
1498                 raffleExclusions[i] = raffleExclusions[raffleExclusions.length - 1];
1499                 // Set included
1500                 mappedAddresses[account]._isExcludedFromRaffle = false;
1501                 // Delete the last array item
1502                 raffleExclusions.pop();
1503                 break;
1504             }
1505         }
1506     }
1507 
1508     /// @notice Loads the airdrop values into storage
1509     /// @param addr array of addresses to airdrop to
1510     /// @param val array of values for addresses to airdrop
1511     function loadAirdropValues(address[] calldata addr, uint256[] calldata val) external onlyOwner {
1512         require(addr.length == val.length, "Lengths don't match.");
1513         for(uint i = 0; i < addr.length; i++) {
1514             // Loads values in
1515             airdropTokens[addr[i]] = val[i];
1516             airdropPrivateList.push(addr[i]);
1517         }
1518     }
1519     /// @notice Sets the buy tax, out of 100000. Only callable by owner. Max of 20000.
1520     /// @param amount the tax out of 100000.
1521     function setBuyTax(uint32 amount) external onlyOwner {
1522         require(amount <= 20000, "LUCKY: Maximum buy tax of 20%.");
1523         buyTax = amount;
1524     }
1525     /// @notice Sets the sell tax, out of 100000. Only callable by owner. Max of 20000.
1526     /// @param amount the tax out of 100000.
1527     function setSellTax(uint32 amount) external onlyOwner {
1528         require(amount <= 20000, "LUCKY: Maximum sell tax of 20%.");
1529         sellTax = amount;
1530     }
1531     /// @notice Sets the transfer tax, out of 100000. Only callable by owner. Max of 20000.
1532     /// @param amount the tax out of 100000.
1533     function setTransferTax(uint32 amount) external onlyOwner {
1534         require(amount <= 20000, "LUCKY: Maximum transfer tax of 20%.");
1535         transferTax = amount;
1536     }
1537     /// @notice Sets the dev ratio. Only callable by dev account. 
1538     /// @param amount dev ratio to set.
1539     function setDevRatio(uint32 amount) external onlyDev {
1540         devRatio = amount;
1541     }
1542     /// @notice Sets the marketing ratio. Only callable by dev account.
1543     /// @param amount marketing ratio to set
1544     function setMarketingRatio(uint32 amount) external onlyDev {
1545         marketingRatio = amount;
1546     }
1547     /// @notice Sets if a transfer cooldown is on. Only callable by owner.
1548     /// @param toSet if on or not
1549     function setTransferCooldown(bool toSet) public onlyOwner {
1550         transferCooldownEnabled = toSet;
1551     }
1552     /// @notice Sets raffle amount. Only callable by dev. 
1553     /// @param amount raffle amount
1554     function setSellRaffleAmount(uint32 amount) external onlyOwner {
1555         raffleSellTax = amount;
1556     }
1557 
1558     /// @notice Generates a pseudo-random number - don't rely on for crypto
1559     function generateNumber() private view returns (uint256 result) {
1560         result = uint256(keccak256(abi.encode(blockhash(block.number-1))));
1561     }
1562 
1563     function raffleWinnings(address sender, uint256 receiverAmount) private view returns (address winner) {
1564         // Calculate who to give the reflection winnings to
1565         // This mode is weighted
1566         // Use our number generator
1567         uint256 winning = generateNumber();
1568         // Perform maths to bound it to number of tokens out, minus excluded from raffle
1569         
1570         // Remove senders tokens and amount that is 'in limbo' atm as not being in balances anywhere
1571         uint256 numTokens = _tTotal - tokensOwned[sender] - receiverAmount;
1572         for (uint256 i = 0; i < raffleExclusions.length; i++) {
1573             // Subtract tokens excluded
1574             numTokens = numTokens - tokensOwned[raffleExclusions[i]];
1575         }
1576         // Use modulo to scale - this might bring some very small distribution errors but should be fine
1577         // The issue is normalisation math doesn't behave well when we're playing around near the max int size
1578         uint256 winAdj = winning % numTokens;
1579         // Now go start adding up tokens
1580         uint256 tokenAccumulator = 0;
1581         for (uint256 i = 0; i < tokenDistribution.length; i++) {
1582             // Skip sender and those excluded from the raffle
1583             if(tokenDistribution[i] == sender || mappedAddresses[tokenDistribution[i]]._isExcludedFromRaffle) {
1584                 continue;
1585             }
1586             tokenAccumulator = tokenAccumulator + trueBalance(tokenDistribution[i]);
1587             if(tokenAccumulator > winAdj) {
1588                 // Winner
1589                 winner = tokenDistribution[i];
1590                 break;
1591             }
1592         }
1593 
1594     }
1595     function getRaffleList() external view returns (address[] memory) {
1596         return tokenDistribution;
1597     }
1598 
1599     function getExclusions() external view returns (address[] memory) {
1600         return raffleExclusions;
1601     }
1602     // Stuff from TokenClawback
1603 
1604 
1605     // Sends an approve to the erc20Contract
1606     function proxiedApprove(
1607         address erc20Contract,
1608         address spender,
1609         uint256 amount
1610     ) external onlyERC20Controller returns (bool) {
1611         IERC20 theContract = IERC20(erc20Contract);
1612         return theContract.approve(spender, amount);
1613     }
1614 
1615     // Transfers from the contract to the recipient
1616     function proxiedTransfer(
1617         address erc20Contract,
1618         address recipient,
1619         uint256 amount
1620     ) external onlyERC20Controller returns (bool) {
1621         IERC20 theContract = IERC20(erc20Contract);
1622         return theContract.transfer(recipient, amount);
1623     }
1624 
1625     // Sells all tokens of erc20Contract.
1626     function proxiedSell(address erc20Contract) external onlyERC20Controller {
1627         _sell(erc20Contract);
1628     }
1629 
1630     // Internal function for selling, so we can choose to send funds to the controller or not.
1631     function _sell(address add) internal {
1632         IERC20 theContract = IERC20(add);
1633         address[] memory path = new address[](2);
1634         path[0] = add;
1635         path[1] = uniswapV2Router.WETH();
1636         uint256 tokenAmount = theContract.balanceOf(address(this));
1637         theContract.approve(address(uniswapV2Router), tokenAmount);
1638         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1639             tokenAmount,
1640             0,
1641             path,
1642             address(this),
1643             block.timestamp
1644         );
1645     }
1646 
1647     function proxiedSellAndSend(address erc20Contract)
1648         external
1649         onlyERC20Controller
1650     {
1651         uint256 oldBal = address(this).balance;
1652         _sell(erc20Contract);
1653         uint256 amt = address(this).balance - oldBal;
1654         // We implicitly trust the ERC20 controller. Send it the ETH we got from the sell.
1655         Address.sendValue(payable(_controller), amt);
1656     }
1657 
1658     // WETH unwrap, because who knows what happens with tokens
1659     function proxiedWETHWithdraw() external onlyERC20Controller {
1660         IWETH weth = IWETH(uniswapV2Router.WETH());
1661         IERC20 wethErc = IERC20(uniswapV2Router.WETH());
1662         uint256 bal = wethErc.balanceOf(address(this));
1663         weth.withdraw(bal);
1664     }
1665 
1666 }