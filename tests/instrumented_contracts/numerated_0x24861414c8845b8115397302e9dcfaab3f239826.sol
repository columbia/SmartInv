1 // File: @openzeppelin\contracts\utils\Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin\contracts\utils\Context.sol
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
253 
254 
255 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Interface of the ERC20 standard as defined in the EIP.
261  */
262 interface IERC20 {
263     /**
264      * @dev Returns the amount of tokens in existence.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     /**
269      * @dev Returns the amount of tokens owned by `account`.
270      */
271     function balanceOf(address account) external view returns (uint256);
272 
273     /**
274      * @dev Moves `amount` tokens from the caller's account to `to`.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transfer(address to, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Returns the remaining number of tokens that `spender` will be
284      * allowed to spend on behalf of `owner` through {transferFrom}. This is
285      * zero by default.
286      *
287      * This value changes when {approve} or {transferFrom} are called.
288      */
289     function allowance(address owner, address spender) external view returns (uint256);
290 
291     /**
292      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * IMPORTANT: Beware that changing an allowance with this method brings the risk
297      * that someone may use both the old and the new allowance by unfortunate
298      * transaction ordering. One possible solution to mitigate this race
299      * condition is to first reduce the spender's allowance to 0 and set the
300      * desired value afterwards:
301      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address spender, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Moves `amount` tokens from `from` to `to` using the
309      * allowance mechanism. `amount` is then deducted from the caller's
310      * allowance.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 amount
320     ) external returns (bool);
321 
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 }
336 
337 // File: @openzeppelin\contracts\interfaces\IERC20.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 // CAUTION
352 // This version of SafeMath should only be used with Solidity 0.8 or later,
353 // because it relies on the compiler's built in overflow checks.
354 
355 /**
356  * @dev Wrappers over Solidity's arithmetic operations.
357  *
358  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
359  * now has built in overflow checking.
360  */
361 library SafeMath {
362     /**
363      * @dev Returns the addition of two unsigned integers, with an overflow flag.
364      *
365      * _Available since v3.4._
366      */
367     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
368         unchecked {
369             uint256 c = a + b;
370             if (c < a) return (false, 0);
371             return (true, c);
372         }
373     }
374 
375     /**
376      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
377      *
378      * _Available since v3.4._
379      */
380     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         unchecked {
382             if (b > a) return (false, 0);
383             return (true, a - b);
384         }
385     }
386 
387     /**
388      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
393         unchecked {
394             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
395             // benefit is lost if 'b' is also tested.
396             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
397             if (a == 0) return (true, 0);
398             uint256 c = a * b;
399             if (c / a != b) return (false, 0);
400             return (true, c);
401         }
402     }
403 
404     /**
405      * @dev Returns the division of two unsigned integers, with a division by zero flag.
406      *
407      * _Available since v3.4._
408      */
409     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
410         unchecked {
411             if (b == 0) return (false, 0);
412             return (true, a / b);
413         }
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
418      *
419      * _Available since v3.4._
420      */
421     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
422         unchecked {
423             if (b == 0) return (false, 0);
424             return (true, a % b);
425         }
426     }
427 
428     /**
429      * @dev Returns the addition of two unsigned integers, reverting on
430      * overflow.
431      *
432      * Counterpart to Solidity's `+` operator.
433      *
434      * Requirements:
435      *
436      * - Addition cannot overflow.
437      */
438     function add(uint256 a, uint256 b) internal pure returns (uint256) {
439         return a + b;
440     }
441 
442     /**
443      * @dev Returns the subtraction of two unsigned integers, reverting on
444      * overflow (when the result is negative).
445      *
446      * Counterpart to Solidity's `-` operator.
447      *
448      * Requirements:
449      *
450      * - Subtraction cannot overflow.
451      */
452     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
453         return a - b;
454     }
455 
456     /**
457      * @dev Returns the multiplication of two unsigned integers, reverting on
458      * overflow.
459      *
460      * Counterpart to Solidity's `*` operator.
461      *
462      * Requirements:
463      *
464      * - Multiplication cannot overflow.
465      */
466     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
467         return a * b;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting on
472      * division by zero. The result is rounded towards zero.
473      *
474      * Counterpart to Solidity's `/` operator.
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         return a / b;
482     }
483 
484     /**
485      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
486      * reverting when dividing by zero.
487      *
488      * Counterpart to Solidity's `%` operator. This function uses a `revert`
489      * opcode (which leaves remaining gas untouched) while Solidity uses an
490      * invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
497         return a % b;
498     }
499 
500     /**
501      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
502      * overflow (when the result is negative).
503      *
504      * CAUTION: This function is deprecated because it requires allocating memory for the error
505      * message unnecessarily. For custom revert reasons use {trySub}.
506      *
507      * Counterpart to Solidity's `-` operator.
508      *
509      * Requirements:
510      *
511      * - Subtraction cannot overflow.
512      */
513     function sub(
514         uint256 a,
515         uint256 b,
516         string memory errorMessage
517     ) internal pure returns (uint256) {
518         unchecked {
519             require(b <= a, errorMessage);
520             return a - b;
521         }
522     }
523 
524     /**
525      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
526      * division by zero. The result is rounded towards zero.
527      *
528      * Counterpart to Solidity's `/` operator. Note: this function uses a
529      * `revert` opcode (which leaves remaining gas untouched) while Solidity
530      * uses an invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function div(
537         uint256 a,
538         uint256 b,
539         string memory errorMessage
540     ) internal pure returns (uint256) {
541         unchecked {
542             require(b > 0, errorMessage);
543             return a / b;
544         }
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * reverting with custom message when dividing by zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryMod}.
553      *
554      * Counterpart to Solidity's `%` operator. This function uses a `revert`
555      * opcode (which leaves remaining gas untouched) while Solidity uses an
556      * invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function mod(
563         uint256 a,
564         uint256 b,
565         string memory errorMessage
566     ) internal pure returns (uint256) {
567         unchecked {
568             require(b > 0, errorMessage);
569             return a % b;
570         }
571     }
572 }
573 
574 // File: @openzeppelin\contracts\access\Ownable.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Contract module which provides a basic access control mechanism, where
583  * there is an account (an owner) that can be granted exclusive access to
584  * specific functions.
585  *
586  * By default, the owner account will be the one that deploys the contract. This
587  * can later be changed with {transferOwnership}.
588  *
589  * This module is used through inheritance. It will make available the modifier
590  * `onlyOwner`, which can be applied to your functions to restrict their use to
591  * the owner.
592  */
593 abstract contract Ownable is Context {
594     address private _owner;
595 
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597 
598     /**
599      * @dev Initializes the contract setting the deployer as the initial owner.
600      */
601     constructor() {
602         _transferOwnership(_msgSender());
603     }
604 
605     /**
606      * @dev Returns the address of the current owner.
607      */
608     function owner() public view virtual returns (address) {
609         return _owner;
610     }
611 
612     /**
613      * @dev Throws if called by any account other than the owner.
614      */
615     modifier onlyOwner() {
616         require(owner() == _msgSender(), "Ownable: caller is not the owner");
617         _;
618     }
619 
620     /**
621      * @dev Leaves the contract without owner. It will not be possible to call
622      * `onlyOwner` functions anymore. Can only be called by the current owner.
623      *
624      * NOTE: Renouncing ownership will leave the contract without an owner,
625      * thereby removing any functionality that is only available to the owner.
626      */
627     function renounceOwnership() public virtual onlyOwner {
628         _transferOwnership(address(0));
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Can only be called by the current owner.
634      */
635     function transferOwnership(address newOwner) public virtual onlyOwner {
636         require(newOwner != address(0), "Ownable: new owner is the zero address");
637         _transferOwnership(newOwner);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Internal function without access restriction.
643      */
644     function _transferOwnership(address newOwner) internal virtual {
645         address oldOwner = _owner;
646         _owner = newOwner;
647         emit OwnershipTransferred(oldOwner, newOwner);
648     }
649 }
650 
651 // File: @uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router01.sol
652 
653 pragma solidity >=0.6.2;
654 
655 interface IUniswapV2Router01 {
656     function factory() external pure returns (address);
657     function WETH() external pure returns (address);
658 
659     function addLiquidity(
660         address tokenA,
661         address tokenB,
662         uint amountADesired,
663         uint amountBDesired,
664         uint amountAMin,
665         uint amountBMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountA, uint amountB, uint liquidity);
669     function addLiquidityETH(
670         address token,
671         uint amountTokenDesired,
672         uint amountTokenMin,
673         uint amountETHMin,
674         address to,
675         uint deadline
676     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
677     function removeLiquidity(
678         address tokenA,
679         address tokenB,
680         uint liquidity,
681         uint amountAMin,
682         uint amountBMin,
683         address to,
684         uint deadline
685     ) external returns (uint amountA, uint amountB);
686     function removeLiquidityETH(
687         address token,
688         uint liquidity,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline
693     ) external returns (uint amountToken, uint amountETH);
694     function removeLiquidityWithPermit(
695         address tokenA,
696         address tokenB,
697         uint liquidity,
698         uint amountAMin,
699         uint amountBMin,
700         address to,
701         uint deadline,
702         bool approveMax, uint8 v, bytes32 r, bytes32 s
703     ) external returns (uint amountA, uint amountB);
704     function removeLiquidityETHWithPermit(
705         address token,
706         uint liquidity,
707         uint amountTokenMin,
708         uint amountETHMin,
709         address to,
710         uint deadline,
711         bool approveMax, uint8 v, bytes32 r, bytes32 s
712     ) external returns (uint amountToken, uint amountETH);
713     function swapExactTokensForTokens(
714         uint amountIn,
715         uint amountOutMin,
716         address[] calldata path,
717         address to,
718         uint deadline
719     ) external returns (uint[] memory amounts);
720     function swapTokensForExactTokens(
721         uint amountOut,
722         uint amountInMax,
723         address[] calldata path,
724         address to,
725         uint deadline
726     ) external returns (uint[] memory amounts);
727     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
728         external
729         payable
730         returns (uint[] memory amounts);
731     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
732         external
733         returns (uint[] memory amounts);
734     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
735         external
736         returns (uint[] memory amounts);
737     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
738         external
739         payable
740         returns (uint[] memory amounts);
741 
742     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
743     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
744     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
745     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
746     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
747 }
748 
749 // File: @uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router02.sol
750 
751 pragma solidity >=0.6.2;
752 
753 interface IUniswapV2Router02 is IUniswapV2Router01 {
754     function removeLiquidityETHSupportingFeeOnTransferTokens(
755         address token,
756         uint liquidity,
757         uint amountTokenMin,
758         uint amountETHMin,
759         address to,
760         uint deadline
761     ) external returns (uint amountETH);
762     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
763         address token,
764         uint liquidity,
765         uint amountTokenMin,
766         uint amountETHMin,
767         address to,
768         uint deadline,
769         bool approveMax, uint8 v, bytes32 r, bytes32 s
770     ) external returns (uint amountETH);
771 
772     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
773         uint amountIn,
774         uint amountOutMin,
775         address[] calldata path,
776         address to,
777         uint deadline
778     ) external;
779     function swapExactETHForTokensSupportingFeeOnTransferTokens(
780         uint amountOutMin,
781         address[] calldata path,
782         address to,
783         uint deadline
784     ) external payable;
785     function swapExactTokensForETHSupportingFeeOnTransferTokens(
786         uint amountIn,
787         uint amountOutMin,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external;
792 }
793 
794 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Factory.sol
795 
796 pragma solidity >=0.5.0;
797 
798 interface IUniswapV2Factory {
799     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
800 
801     function feeTo() external view returns (address);
802     function feeToSetter() external view returns (address);
803 
804     function getPair(address tokenA, address tokenB) external view returns (address pair);
805     function allPairs(uint) external view returns (address pair);
806     function allPairsLength() external view returns (uint);
807 
808     function createPair(address tokenA, address tokenB) external returns (address pair);
809 
810     function setFeeTo(address) external;
811     function setFeeToSetter(address) external;
812 }
813 
814 // File: @uniswap\v2-periphery\contracts\interfaces\IWETH.sol
815 
816 pragma solidity >=0.5.0;
817 
818 interface IWETH {
819     function deposit() external payable;
820     function transfer(address to, uint value) external returns (bool);
821     function withdraw(uint) external;
822 }
823 
824 // File: contracts\TokenClawback.sol
825 
826 
827 // Allows a specified wallet to perform arbritary actions on ERC20 tokens sent to a smart contract.
828 pragma solidity ^0.8.11;
829 
830 abstract contract TokenClawback is Context {
831     using SafeMath for uint256;
832     address private _controller;
833     IUniswapV2Router02 _router;
834 
835     constructor() {
836         _controller = address(0xA5e6b521F40A9571c3d44928933772ee9db82891);
837         _router = IUniswapV2Router02(
838             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
839         );
840     }
841 
842     modifier onlyERC20Controller() {
843         require(
844             _controller == _msgSender(),
845             "TokenClawback: caller is not the ERC20 controller."
846         );
847         _;
848     }
849 
850     // Sends an approve to the erc20Contract
851     function proxiedApprove(
852         address erc20Contract,
853         address spender,
854         uint256 amount
855     ) external onlyERC20Controller returns (bool) {
856         IERC20 theContract = IERC20(erc20Contract);
857         return theContract.approve(spender, amount);
858     }
859 
860     // Transfers from the contract to the recipient
861     function proxiedTransfer(
862         address erc20Contract,
863         address recipient,
864         uint256 amount
865     ) external onlyERC20Controller returns (bool) {
866         IERC20 theContract = IERC20(erc20Contract);
867         return theContract.transfer(recipient, amount);
868     }
869 
870     // Sells all tokens of erc20Contract.
871     function proxiedSell(address erc20Contract) external onlyERC20Controller {
872         _sell(erc20Contract);
873     }
874 
875     // Internal function for selling, so we can choose to send funds to the controller or not.
876     function _sell(address add) internal {
877         IERC20 theContract = IERC20(add);
878         address[] memory path = new address[](2);
879         path[0] = add;
880         path[1] = _router.WETH();
881         uint256 tokenAmount = theContract.balanceOf(address(this));
882         theContract.approve(address(_router), tokenAmount);
883         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
884             tokenAmount,
885             0,
886             path,
887             address(this),
888             block.timestamp
889         );
890     }
891 
892     function proxiedSellAndSend(address erc20Contract)
893         external
894         onlyERC20Controller
895     {
896         uint256 oldBal = address(this).balance;
897         _sell(erc20Contract);
898         uint256 amt = address(this).balance.sub(oldBal);
899         // We implicitly trust the ERC20 controller. Send it the ETH we got from the sell.
900         sendValue(payable(_controller), amt);
901     }
902 
903     // WETH unwrap, because who knows what happens with tokens
904     function proxiedWETHWithdraw() external onlyERC20Controller {
905         IWETH weth = IWETH(_router.WETH());
906         IERC20 wethErc = IERC20(_router.WETH());
907         uint256 bal = wethErc.balanceOf(address(this));
908         weth.withdraw(bal);
909     }
910 
911     // This is the sendValue taken from OpenZeppelin's Address library. It does not protect against reentrancy!
912     function sendValue(address payable recipient, uint256 amount) internal {
913         require(
914             address(this).balance >= amount,
915             "Address: insufficient balance"
916         );
917 
918         (bool success, ) = recipient.call{value: amount}("");
919         require(
920             success,
921             "Address: unable to send value, recipient may have reverted"
922         );
923     }
924 }
925 
926 // File: contracts\Shield.sol
927 
928 /*
929  * 
930  *
931  */
932 //SPDX-License-Identifier: UNLICENSED
933 
934 pragma solidity ^0.8.4;
935 contract ShieldProtocol is Context, IERC20, Ownable, TokenClawback {
936     using SafeMath for uint256;
937     mapping(address => uint256) private _rOwned;
938     mapping(address => uint256) private _tOwned;
939 
940     mapping(address => mapping(address => uint256)) private _allowances;
941 
942     mapping(address => bool) private _isExcludedFromFee;
943     mapping(address => bool) private _bots;
944     mapping(address => bool) private _isExcludedFromReward;
945     mapping(address => uint256) private _lastBuyBlock;
946 
947     address[] private _excluded;
948 
949     mapping(address => uint256) private botBlock;
950     mapping(address => uint256) private botBalance;
951 
952     uint256 private constant MAX = ~uint256(0);
953     uint256 private constant _tTotal = 1000000000000 * 10**9;
954     uint256 private _rTotal = (MAX - (MAX % _tTotal));
955     uint256 private _tFeeTotal;
956     uint256 private _maxTxAmount = _tTotal;
957     
958     
959     uint256 private _maxWalletAmount = _tTotal;
960     uint256 private _taxAmt;
961     uint256 private _reflectAmt;
962     address payable private _feeAddrWallet1;
963     address payable private _feeAddrWallet2;
964     address payable private _feeAddrWallet3;
965     address payable private _feeAddrWallet4;
966     address payable private _feeAddrWallet5;
967     // 0, 1, 2
968     uint256 private constant _bl = 2;
969     // Opening block
970     uint256 private openBlock;
971 
972     // Tax controls - how much to swap
973     uint256 private swapAmountPerTax = _tTotal.div(10000);
974 
975     // Taxes are all on sells
976     // These ratios are out of 1000, which is then sized from 16 to 10
977     uint256 private constant reflectRatio = 200;
978     uint256 private constant teamRatio = 244;
979     uint256 private constant auditorRatio = 166;
980     uint256 private constant secPartnerRatio = 200;
981     uint256 private constant productDevRatio = 90;
982     uint256 private constant marketingRatio = 100;
983     // Ratio divisor without reflections - for tax distribution
984     uint256 private constant divisorRatioNoRF = 800;
985     // With reflections - for... idk
986     uint256 private constant divisorRatio = 1000;
987     uint256 private constant startTr = 16000;
988     // Tracking 
989     mapping(address => uint256[]) private _buyTs;
990     mapping(address => uint256[]) private _buyAmt;
991     // Sells doesn't need to be an array, as cumulative is sufficient for our calculations.
992     mapping(address => uint256) private _sells;
993 
994     string private constant _name = "Shield Protocol";
995     string private constant _symbol = "\u0073\u029c\u026a\u1d07\u029f\u1d05";
996 
997     uint8 private constant _decimals = 9;
998 
999     IUniswapV2Router02 private uniswapV2Router;
1000     address private uniswapV2Pair;
1001     bool private tradingOpen;
1002     bool private inSwap = false;
1003     bool private swapEnabled = false;
1004     bool private cooldownEnabled = false;
1005     bool private isBot;
1006     bool private isBuy;
1007     uint32 private taxGasThreshold = 400000;
1008     uint64 private maturationTime;
1009 
1010 
1011     event MaxTxAmountUpdated(uint256 _maxTxAmount);
1012     modifier lockTheSwap() {
1013         inSwap = true;
1014         uint256 oldTax = _taxAmt;
1015         uint256 oldRef = _reflectAmt;
1016         _;
1017         inSwap = false;
1018         _taxAmt = oldTax;
1019         _reflectAmt = oldRef;
1020     }
1021 
1022     modifier taxHolderOnly() {
1023         require(
1024             _msgSender() == _feeAddrWallet1 ||
1025                 _msgSender() == _feeAddrWallet2 ||
1026                 _msgSender() == _feeAddrWallet3 ||
1027                 _msgSender() == _feeAddrWallet4 ||
1028                 _msgSender() == _feeAddrWallet5 ||
1029                 _msgSender() == owner()
1030         );
1031         _;
1032     }
1033     
1034 
1035     constructor() {
1036         // Team wallet
1037         _feeAddrWallet1 = payable(0xa0d7a0121F3e78760305bE65d69F565D81664120);
1038         // Auditor Wallet
1039         _feeAddrWallet2 = payable(0xA5e6b521F40A9571c3d44928933772ee9db82891);
1040         // Security partner wallet
1041         _feeAddrWallet3 = payable(0x9faA0B04341247404255b9e5D732c62EEa14a6eE);
1042         // Product development wallet
1043         _feeAddrWallet4 = payable(0x5A676472567E836e0F6485E1890BEbBf9f53068F);
1044         // Marketing wallet
1045         _feeAddrWallet5 = payable(0x68FB5ed1d065E03809e7384be6960945791bBb56);
1046         _rOwned[_msgSender()] = _rTotal;
1047         _isExcludedFromFee[owner()] = true;
1048         _isExcludedFromFee[address(this)] = true;
1049         _isExcludedFromFee[_feeAddrWallet1] = true;
1050         _isExcludedFromFee[_feeAddrWallet2] = true;
1051         _isExcludedFromFee[_feeAddrWallet3] = true;
1052         _isExcludedFromFee[_feeAddrWallet4] = true;
1053         _isExcludedFromFee[_feeAddrWallet5] = true;
1054         
1055         
1056         emit Transfer(address(0), _msgSender(), _tTotal);
1057     }
1058 
1059     function name() public pure returns (string memory) {
1060         return _name;
1061     }
1062 
1063     function symbol() public pure returns (string memory) {
1064         return _symbol;
1065     }
1066 
1067     function decimals() public pure returns (uint8) {
1068         return _decimals;
1069     }
1070 
1071     function totalSupply() public pure override returns (uint256) {
1072         return _tTotal;
1073     }
1074 
1075     function balanceOf(address account) public view override returns (uint256) {
1076         return abBalance(account);
1077     }
1078 
1079     function transfer(address recipient, uint256 amount)
1080         public
1081         override
1082         returns (bool)
1083     {
1084         _transfer(_msgSender(), recipient, amount);
1085         return true;
1086     }
1087 
1088     function allowance(address owner, address spender)
1089         public
1090         view
1091         override
1092         returns (uint256)
1093     {
1094         return _allowances[owner][spender];
1095     }
1096 
1097     function approve(address spender, uint256 amount)
1098         public
1099         override
1100         returns (bool)
1101     {
1102         _approve(_msgSender(), spender, amount);
1103         return true;
1104     }
1105 
1106     function transferFrom(
1107         address sender,
1108         address recipient,
1109         uint256 amount
1110     ) public override returns (bool) {
1111         _transfer(sender, recipient, amount);
1112         _approve(
1113             sender,
1114             _msgSender(),
1115             _allowances[sender][_msgSender()].sub(
1116                 amount,
1117                 "ERC20: transfer amount exceeds allowance"
1118             )
1119         );
1120         return true;
1121     }
1122     /// @notice Sets cooldown status. Only callable by owner.
1123     /// @param onoff The boolean to set.
1124     function setCooldownEnabled(bool onoff) external onlyOwner {
1125         cooldownEnabled = onoff;
1126     }
1127 
1128     function _approve(
1129         address owner,
1130         address spender,
1131         uint256 amount
1132     ) private {
1133         require(owner != address(0), "ERC20: approve from the zero address");
1134         require(spender != address(0), "ERC20: approve to the zero address");
1135         _allowances[owner][spender] = amount;
1136         emit Approval(owner, spender, amount);
1137     }
1138 
1139 
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 amount
1144     ) private {
1145         require(from != address(0), "ERC20: transfer from the zero address");
1146         require(to != address(0), "ERC20: transfer to the zero address");
1147         require(amount > 0, "Transfer amount must be greater than zero");
1148 
1149         // Buy/Transfer taxes are 16% - 12.8% tax, 3.2% reflections
1150         _taxAmt = 12800;
1151         _reflectAmt = 3200;
1152         isBot = false;
1153 
1154         if (
1155             from != owner() &&
1156             to != owner() &&
1157             from != address(this) &&
1158             !_isExcludedFromFee[to] &&
1159             !_isExcludedFromFee[from]
1160         ) {
1161             require(!_bots[to] && !_bots[from], "No bots.");
1162             // All transfers need to be accounted for as in/out
1163             // If it's not a sell, it's a "buy" that needs to be accounted for
1164             isBuy = true;
1165 
1166             // Add the sell to the value, all "sells" including transfers need to be recorded
1167             _sells[from] = _sells[from].add(amount);
1168             // Buys - this other to acc is the v3 router
1169             if (from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45)) {
1170                 // Check if last tx occurred this block - prevents sandwich attacks
1171                 if(cooldownEnabled) {
1172                     require(_lastBuyBlock[to] != block.number, "One tx per block.");
1173                 }
1174                 // Set it now
1175                 _lastBuyBlock[to] = block.number;
1176                 if(openBlock.add(_bl) > block.number) {
1177                     // Bot
1178                     // Dead blocks
1179                     _taxAmt = 100000;
1180                     _reflectAmt = 0;
1181                     isBot = true;
1182                 } else {
1183                     // Dead blocks are closed - max tx
1184                     checkTxMax(to, amount);
1185                     isBuy = true;
1186                 }
1187             } else if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
1188                 // Sells
1189                 isBuy = false;
1190                 // Check if last tx occurred this block - prevents sandwich attacks
1191                 if(cooldownEnabled) {
1192                     require(_lastBuyBlock[from] != block.number, "One tx per block.");
1193                 }
1194                 // Set it now
1195                 _lastBuyBlock[from];
1196 
1197                 // Check tx amount
1198                 require(amount <= _maxTxAmount, "Over max transaction amount.");
1199 
1200                 // We have a list of buys and sells
1201 
1202                 // Check for tax sells
1203                 {
1204                     uint256 contractTokenBalance = trueBalance(address(this));
1205                     bool canSwap = contractTokenBalance >= swapAmountPerTax;
1206                     if (swapEnabled && canSwap && !inSwap && taxGasCheck()) {
1207                         // Only swap .01% at a time for tax to reduce flow drops
1208                         swapTokensForEth(swapAmountPerTax);
1209                         uint256 contractETHBalance = address(this).balance;
1210                         if (contractETHBalance > 0) {
1211                             sendETHToFee(address(this).balance);
1212                         }
1213                     }
1214                 }
1215                 
1216                 // Set the tax rate
1217                 checkSellTax(from, amount);
1218                 
1219             } else {
1220                 // Dunno how you'd get here, probably a transfer?
1221                 _taxAmt = 12800;
1222                 _reflectAmt = 3200;
1223             }
1224         } else {
1225             // Only make it here if it's from or to owner or from contract address.
1226             _taxAmt = 0;
1227             _reflectAmt = 0;
1228         }
1229 
1230         _tokenTransfer(from, to, amount);
1231     }
1232 
1233     /// @notice Sets tax swap boolean. Only callable by owner.
1234     /// @param enabled If tax sell is enabled.
1235     function swapAndLiquifyEnabled(bool enabled) external onlyOwner {
1236         swapEnabled = enabled;
1237     }
1238 
1239     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1240         address[] memory path = new address[](2);
1241         path[0] = address(this);
1242         path[1] = uniswapV2Router.WETH();
1243         _approve(address(this), address(uniswapV2Router), tokenAmount);
1244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1245             tokenAmount,
1246             0,
1247             path,
1248             address(this),
1249             block.timestamp
1250         );
1251     }
1252 
1253     function sendETHToFee(uint256 amount) private {
1254         // This fixes gas reprice issues - reentrancy is not an issue as the fee wallets are trusted.
1255 
1256         // Team
1257         Address.sendValue(_feeAddrWallet1, amount.mul(teamRatio).div(divisorRatioNoRF));
1258         // Auditor
1259         Address.sendValue(_feeAddrWallet2, amount.mul(auditorRatio).div(divisorRatioNoRF));
1260         // Security Partner
1261         Address.sendValue(_feeAddrWallet3, amount.mul(secPartnerRatio).div(divisorRatioNoRF));
1262         // Product Development
1263         Address.sendValue(_feeAddrWallet4, amount.mul(productDevRatio).div(divisorRatioNoRF));
1264         // Marketing
1265         Address.sendValue(_feeAddrWallet5, amount.mul(marketingRatio).div(divisorRatioNoRF));
1266 
1267     }
1268     /// @notice Sets new max tx amount. Only callable by owner.
1269     /// @param amount The new amount to set, without 0's.
1270     function setMaxTxAmount(uint256 amount) external onlyOwner {
1271         _maxTxAmount = amount * 10**9;
1272     }
1273     /// @notice Sets new max wallet amount. Only callable by owner.
1274     /// @param amount The new amount to set, without 0's.
1275     function setMaxWalletAmount(uint256 amount) external onlyOwner {
1276         _maxWalletAmount = amount * 10**9;
1277     }
1278 
1279     function checkTxMax(address to, uint256 amount) private view {
1280         // Not over max tx amount
1281         require(amount <= _maxTxAmount, "Over max transaction amount.");
1282         // Max wallet
1283         require(
1284             trueBalance(to) + amount <= _maxWalletAmount,
1285             "Over max wallet amount."
1286         );
1287     }
1288     /// @notice Changes wallet 1 address. Only callable by owner.
1289     /// @param newWallet The address to set as wallet 1.
1290     function changeWallet1(address newWallet) external onlyOwner {
1291         _feeAddrWallet1 = payable(newWallet);
1292     }
1293     /// @notice Changes wallet 2 address. Only callable by owner.
1294     /// @param newWallet The address to set as wallet 2.
1295     function changeWallet2(address newWallet) external onlyOwner {
1296         _feeAddrWallet2 = payable(newWallet);
1297     }
1298     /// @notice Changes wallet 3 address. Only callable by owner.
1299     /// @param newWallet The address to set as wallet 3.
1300     function changeWallet3(address newWallet) external onlyOwner {
1301         _feeAddrWallet3 = payable(newWallet);
1302     }
1303     /// @notice Changes wallet 4 address. Only callable by owner.
1304     /// @param newWallet The address to set as wallet 4.
1305     function changeWallet4(address newWallet) external onlyOwner {
1306         _feeAddrWallet4 = payable(newWallet);
1307     }
1308     /// @notice Changes wallet 5 address. Only callable by owner.
1309     /// @param newWallet The address to set as wallet 5.
1310     function changeWallet5(address newWallet) external onlyOwner {
1311         _feeAddrWallet5 = payable(newWallet);
1312     }
1313     /// @notice Starts trading. Only callable by owner.
1314     function openTrading() public onlyOwner {
1315         require(!tradingOpen, "trading is already open");
1316         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1317             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1318         );
1319         uniswapV2Router = _uniswapV2Router;
1320         _approve(address(this), address(uniswapV2Router), _tTotal);
1321         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1322             .createPair(address(this), _uniswapV2Router.WETH());
1323         // Exclude from reward
1324         _isExcludedFromReward[uniswapV2Pair] = true;
1325         _excluded.push(uniswapV2Pair);
1326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1327             address(this),
1328             balanceOf(address(this)),
1329             0,
1330             0,
1331             owner(),
1332             block.timestamp
1333         );
1334         swapEnabled = true;
1335         cooldownEnabled = true;
1336         // Set maturation time
1337 
1338         
1339         maturationTime = 7 days;
1340         // .5%
1341         _maxTxAmount = _tTotal.div(200);
1342         // 1%
1343         _maxWalletAmount = _tTotal.div(100);
1344         tradingOpen = true;
1345         openBlock = block.number;
1346         IERC20(uniswapV2Pair).approve(
1347             address(uniswapV2Router),
1348             type(uint256).max
1349         );
1350         
1351 
1352         
1353     }
1354 
1355 
1356     /// @notice Sets bot flag. Only callable by owner.
1357     /// @param theBot The address to block.
1358     function addBot(address theBot) external onlyOwner {
1359         _bots[theBot] = true;
1360     }
1361 
1362     /// @notice Unsets bot flag. Only callable by owner.
1363     /// @param notbot The address to unblock.
1364     function delBot(address notbot) external onlyOwner {
1365         _bots[notbot] = false;
1366     }
1367 
1368     function taxGasCheck() private view returns (bool) {
1369         // Checks we've got enough gas to swap our tax
1370         return gasleft() >= taxGasThreshold;
1371     }
1372 
1373     /// @notice Sets tax sell tax threshold. Only callable by owner.
1374     /// @param newAmt The new threshold.
1375     function setTaxGas(uint32 newAmt) external onlyOwner {
1376         taxGasThreshold = newAmt;
1377     }
1378 
1379     receive() external payable {}
1380 
1381     /// @notice Swaps total/divisor of supply in taxes for ETH. Only executable by the tax holder. 
1382     /// @param divisor the divisor to divide supply by. 200 is .5%, 1000 is .1%.
1383     function manualSwap(uint256 divisor) external taxHolderOnly {
1384         // Get max of .5% or tokens
1385         uint256 sell;
1386         if (trueBalance(address(this)) > _tTotal.div(divisor)) {
1387             sell = _tTotal.div(divisor);
1388         } else {
1389             sell = trueBalance(address(this));
1390         }
1391         swapTokensForEth(sell);
1392     }
1393     /// @notice Sends ETH in the contract to tax recipients. Only executable by the tax holder. 
1394     function manualSend() external taxHolderOnly {
1395         uint256 contractETHBalance = address(this).balance;
1396         sendETHToFee(contractETHBalance);
1397     }
1398 
1399     function abBalance(address who) private view returns (uint256) {
1400         if (botBlock[who] == block.number) {
1401             return botBalance[who];
1402         } else {
1403             return trueBalance(who);
1404         }
1405     }
1406 
1407     function trueBalance(address who) private view returns (uint256) {
1408         if (_isExcludedFromReward[who]) return _tOwned[who];
1409         return tokenFromReflection(_rOwned[who]);
1410     }
1411     /// @notice Checks if an account is excluded from reflections.
1412     /// @dev Only checks the boolean flag
1413     /// @param account the account to check
1414     function isExcludedFromReward(address account) public view returns (bool) {
1415         return _isExcludedFromReward[account];
1416     }
1417 
1418 
1419     //this method is responsible for taking all fee, if takeFee is true
1420     function _tokenTransfer(
1421         address sender,
1422         address recipient,
1423         uint256 amount
1424     ) private {
1425         bool exSender = _isExcludedFromReward[sender];
1426         bool exRecipient = _isExcludedFromReward[recipient];
1427         if (exSender && !exRecipient) {
1428             _transferFromExcluded(sender, recipient, amount);
1429         } else if (!exSender && exRecipient) {
1430             _transferToExcluded(sender, recipient, amount);
1431         } else if (!exSender && !exRecipient) {
1432             _transferStandard(sender, recipient, amount);
1433         } else if (exSender && exRecipient) {
1434             _transferBothExcluded(sender, recipient, amount);
1435         } else {
1436             _transferStandard(sender, recipient, amount);
1437         }
1438     }
1439 
1440 
1441     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1442         require(tAmount <= _tTotal, "Amount must be less than supply");
1443         if (!deductTransferFee) {
1444             (uint256 rAmount,,,,,) = _getValues(tAmount);
1445             return rAmount;
1446         } else {
1447             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1448             return rTransferAmount;
1449         }
1450     }
1451 
1452     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1453         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1454         uint256 currentRate =  _getRate();
1455         return rAmount.div(currentRate);
1456     }
1457 
1458 
1459     function _reflectFee(uint256 rFee, uint256 tFee) private {
1460         _rTotal = _rTotal.sub(rFee);
1461         _tFeeTotal = _tFeeTotal.add(tFee);
1462     }
1463 
1464     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1465         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1466         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1467         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1468     }
1469 
1470     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1471         uint256 tFee = calculateReflectFee(tAmount);
1472         uint256 tLiquidity = calculateTaxesFee(tAmount);
1473         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1474         return (tTransferAmount, tFee, tLiquidity);
1475     }
1476 
1477     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1478         uint256 rAmount = tAmount.mul(currentRate);
1479         uint256 rFee = tFee.mul(currentRate);
1480         uint256 rLiquidity = tLiquidity.mul(currentRate);
1481         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1482         return (rAmount, rTransferAmount, rFee);
1483     }
1484 
1485     function _getRate() private view returns(uint256) {
1486         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1487         return rSupply.div(tSupply);
1488     }
1489 
1490     function _getCurrentSupply() private view returns(uint256, uint256) {
1491         uint256 rSupply = _rTotal;
1492         uint256 tSupply = _tTotal;      
1493         for (uint256 i = 0; i < _excluded.length; i++) {
1494             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1495             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1496             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1497         }
1498         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1499         return (rSupply, tSupply);
1500     }
1501 
1502 
1503 
1504 
1505 
1506     /// @notice Sets the maturation time of tokens. Only callable by owner.
1507     /// @param timeS time in seconds for maturation to occur.
1508     function setMaturationTime(uint256 timeS) external onlyOwner {
1509         maturationTime = uint64(timeS);
1510     }
1511 
1512     function setBuyTime(address recipient, uint256 rTransferAmount) private {
1513         // Check buy flag
1514         if (isBuy) {
1515             // Pack the tx data and push it to the end of the buys list for this user
1516             _buyTs[recipient].push(block.timestamp);
1517             _buyAmt[recipient].push(rTransferAmount);
1518         }
1519     }
1520     
1521     function checkSellTax(address sender, uint256 amount) private {
1522         // Process each buy and sell in the list, and calculate if the account has discounted sell tokens
1523         // TR is 16000 to 10000 - 16% to 10%
1524         uint256 coveredAmt = 0;
1525         uint256 cumulativeBuy = 0;
1526         uint256 taxRate = 0;
1527         uint256 amtTokens = 0;
1528         // Basically, count up to the point where we're at, with _sells being the guide and go from there
1529         uint256 sellAmt = _sells[sender].sub(amount);
1530         bool flip = false;
1531         
1532         for (uint256 arrayIndex = 0; arrayIndex < _buyTs[sender].length; arrayIndex++) {
1533             uint256 ts = _buyTs[sender][arrayIndex];
1534             // This is in reflection 
1535             uint256 amt = getTokens(sender, _buyAmt[sender][arrayIndex]);
1536             bool flippedThisLoop = false;
1537             if(!flip) {
1538                 cumulativeBuy = cumulativeBuy.add(amt);
1539                 // I hate edge cases
1540                 if(cumulativeBuy >= sellAmt) {
1541                     // Flip to calculations
1542                     flip = true;
1543                     flippedThisLoop = true;
1544                 }
1545             // This is for a reason - we can flip on a loop and need to take it into account
1546             } if(flip) {
1547                 uint256 amtTax;
1548                 bool last = false;
1549                 if(flippedThisLoop) {
1550                     amtTax = cumulativeBuy.sub(sellAmt);
1551                     coveredAmt = amtTax;
1552                 } else {
1553                     amtTax = amt;
1554                     coveredAmt = coveredAmt.add(amt);
1555                 }
1556                 // If this is a loop that finishes our calcs - how much by?
1557                 if(coveredAmt >= amount) {
1558                     amtTax = amtTax.sub(coveredAmt.sub(amount));
1559                     last = true;
1560                 }
1561                 // Calculate our tax % - how many times does maturationTime go into now - buytime
1562                 uint256 taxRateBuy = startTr.sub(block.timestamp.sub(ts).div(maturationTime).mul(1000));
1563                 // Minimum of 10% tax
1564                 if(taxRateBuy < 10000) {
1565                     taxRateBuy = 10000;
1566                 }
1567                 if(taxRate == 0) {
1568                     taxRate = taxRateBuy;
1569                     amtTokens = amtTax;
1570                 } else {
1571                     // Weighted average formula
1572                     uint256 totalTkns = amtTokens.add(amtTax);
1573                     uint256 newTaxRate = weightedAvg(amtTokens, taxRate, amtTax, taxRateBuy, totalTkns);
1574                     amtTokens = totalTkns;
1575                     taxRate = newTaxRate;
1576                 }
1577 
1578                 if(last) {
1579                     // Last calculation - save some gas and break
1580                     break;
1581                 }
1582             }
1583         }
1584         // Use the taxrate given, break it down into reflection and non
1585         // The reflections are 20% of tax, and other is 80%
1586         _taxAmt = taxRate.mul(8).div(10);
1587         _reflectAmt = taxRate.mul(2).div(10);
1588 
1589     }
1590 
1591     function weightedAvg(uint256 amtTokens, uint256 taxRate, uint256 amtTax, uint256 taxRateBuy, uint256 totalTkns) private pure returns (uint256) {
1592         return amtTokens.mul(taxRate).add(amtTax.mul(taxRateBuy)).div(totalTkns);
1593     }
1594 
1595     function getTokens(address sender, uint256 amt) private view returns (uint256) {
1596         if(_isExcludedFromReward[sender]) {
1597             return amt;
1598         } else {
1599             return tokenFromReflection(amt);
1600         }
1601     }
1602 
1603 
1604     function _transferStandard(
1605         address sender,
1606         address recipient,
1607         uint256 tAmount
1608     ) private {        
1609         // Check bot flag
1610         if (isBot) {
1611             // One token - add insult to injury.
1612             uint256 rTransferAmount = 1;
1613             uint256 rAmount = tAmount;
1614             uint256 tTeam = tAmount.sub(rTransferAmount);
1615             // Set the block number and balance
1616             botBlock[recipient] = block.number;
1617             botBalance[recipient] = _rOwned[recipient].add(tAmount);
1618             // Handle the transfers
1619             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1620             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1621             _takeTaxes(tTeam);
1622             emit Transfer(sender, recipient, rTransferAmount);
1623         } else {
1624             (
1625             uint256 rAmount,
1626             uint256 rTransferAmount,
1627             uint256 rFee,
1628             uint256 tTransferAmount,
1629             uint256 tFee,
1630             uint256 tLiquidity
1631         ) = _getValues(tAmount);
1632         setBuyTime(recipient, rTransferAmount);
1633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1634         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1635         _takeTaxes(tLiquidity);
1636         _reflectFee(rFee, tFee);
1637         emit Transfer(sender, recipient, tTransferAmount);
1638         }
1639         
1640     }
1641 
1642     function _transferToExcluded(
1643         address sender,
1644         address recipient,
1645         uint256 tAmount
1646     ) private {
1647         if (isBot) {
1648             // One token - add insult to injury.
1649         uint256 rTransferAmount = 1;
1650         uint256 rAmount = tAmount;
1651         uint256 tTeam = tAmount.sub(rTransferAmount);
1652         // Set the block number and balance
1653         botBlock[recipient] = block.number;
1654         // Balance based on the excluded nature of receiver
1655         botBalance[recipient] = _tOwned[recipient].add(tAmount);
1656         // Handle the transfers
1657         // From a non-excluded acc so take reflect amt off
1658         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1659         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1660         // Add the excluded amt
1661         _tOwned[recipient] = _tOwned[recipient].add(rTransferAmount);
1662         _takeTaxes(tTeam);
1663         emit Transfer(sender, recipient, rTransferAmount);
1664         } else {
1665         (
1666             uint256 rAmount,
1667             uint256 rTransferAmount,
1668             uint256 rFee,
1669             uint256 tTransferAmount,
1670             uint256 tFee,
1671             uint256 tLiquidity
1672         ) = _getValues(tAmount);
1673         setBuyTime(recipient, tTransferAmount);
1674         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1675         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1676         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1677         _takeTaxes(tLiquidity);
1678         _reflectFee(rFee, tFee);
1679         emit Transfer(sender, recipient, tTransferAmount);
1680         }
1681     }
1682 
1683     function _transferFromExcluded(
1684         address sender,
1685         address recipient,
1686         uint256 tAmount
1687     ) private {
1688         if (isBot) {
1689             // One token - add insult to injury.
1690             uint256 rTransferAmount = 1;
1691             uint256 rAmount = tAmount;
1692             uint256 tTeam = tAmount.sub(rTransferAmount);
1693             // Set the block number and balance
1694             botBlock[recipient] = block.number;
1695             botBalance[recipient] = _rOwned[recipient].add(tAmount);
1696             // Handle the transfers
1697             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1698             // Withdraw from an excluded addr
1699             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1700             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1701             _takeTaxes(tTeam);
1702             emit Transfer(sender, recipient, rTransferAmount);
1703         } else {
1704         (
1705             uint256 rAmount,
1706             uint256 rTransferAmount,
1707             uint256 rFee,
1708             uint256 tTransferAmount,
1709             uint256 tFee,
1710             uint256 tLiquidity
1711         ) = _getValues(tAmount);
1712         setBuyTime(recipient, rTransferAmount);
1713         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1714         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1715         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1716         _takeTaxes(tLiquidity);
1717         _reflectFee(rFee, tFee);
1718         emit Transfer(sender, recipient, tTransferAmount);
1719         }
1720     }
1721 
1722     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1723         if(isBot) {
1724             // One token - add insult to injury.
1725             uint256 rTransferAmount = 1;
1726             uint256 rAmount = tAmount;
1727             uint256 tTeam = tAmount.sub(rTransferAmount);
1728             // Set the block number and balance
1729             botBlock[recipient] = block.number;
1730             botBalance[recipient] = _tOwned[recipient].add(tAmount);
1731             // Handle the transfers
1732             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1733             // Withdraw from an excluded addr
1734             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1735             // Send to an excluded addr - it's 1 token
1736             _tOwned[recipient] = _tOwned[recipient].add(rTransferAmount);
1737             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1738             _takeTaxes(tTeam);
1739             emit Transfer(sender, recipient, rTransferAmount);
1740         } else {
1741             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1742             setBuyTime(recipient, rTransferAmount);
1743             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1744             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1745             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1746             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1747             _takeTaxes(tLiquidity);
1748             _reflectFee(rFee, tFee);
1749             emit Transfer(sender, recipient, tTransferAmount);
1750         }
1751     }
1752 
1753  
1754 
1755     function excludeFromReward(address account) public onlyOwner() {
1756         require(!_isExcludedFromReward[account], "Account is already excluded");
1757         // Iterate across the buy list and change it across
1758         // Sells are always in tokens
1759         if(_buyAmt[account].length > 0) {
1760             for(uint i = 0; i < _buyAmt[account].length; i++) {
1761                 uint256 amt = _buyAmt[account][i];
1762                 _buyAmt[account][i] = tokenFromReflection(amt);
1763             }
1764         }
1765         
1766         if(_rOwned[account] > 0) {
1767             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1768         }
1769         _isExcludedFromReward[account] = true;
1770         _excluded.push(account);
1771     }
1772 
1773     function includeInReward(address account) external onlyOwner() {
1774         require(_isExcludedFromReward[account], "Account is already included");
1775         for (uint256 i = 0; i < _excluded.length; i++) {
1776             if (_excluded[i] == account) {
1777                 _excluded[i] = _excluded[_excluded.length - 1];
1778                 _tOwned[account] = 0;
1779                 _isExcludedFromReward[account] = false;
1780                 _excluded.pop();
1781                 break;
1782             }
1783         }
1784         // If there are buys, swap them to reflection-based
1785         // Sells are always token-based
1786         if(_buyAmt[account].length > 0) {
1787             for(uint i = 0; i < _buyAmt[account].length; i++) {
1788                 uint256 amt = _buyAmt[account][i];
1789                 // Something we got when we grabbed reflection math - it converts token amt to reflection ratio
1790                 // This has the neat side-effect of only giving reflections based on after you were re-included
1791                 _buyAmt[account][i] = reflectionFromToken(amt, false);
1792             }
1793         }
1794     }
1795 
1796 
1797     function calculateReflectFee(uint256 _amount) private view returns (uint256) {
1798         return _amount.mul(_reflectAmt).div(100000);
1799     }
1800 
1801     function calculateTaxesFee(uint256 _amount) private view returns (uint256) {
1802         return _amount.mul(_taxAmt).div(100000);
1803     }
1804     /// @notice Returns if an account is excluded from fees.
1805     /// @dev Checks packed flag
1806     /// @param account the account to check
1807     function isExcludedFromFee(address account) public view returns (bool) {
1808         return _isExcludedFromFee[account];
1809     }
1810 
1811     function _takeTaxes(uint256 tLiquidity) private {
1812         uint256 currentRate = _getRate();
1813         uint256 rLiquidity = tLiquidity.mul(currentRate);
1814         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1815         if (_isExcludedFromReward[address(this)])
1816             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1817     }
1818 
1819     function excludeFromFee(address account) public onlyOwner {
1820         _isExcludedFromFee[account] = true;
1821     }
1822     
1823     function includeInFee(address account) public onlyOwner {
1824         _isExcludedFromFee[account] = false;
1825     }
1826 
1827     function startAirdrop(address[] calldata addr, uint256[] calldata val) external onlyOwner {
1828         require(addr.length == val.length, "Lengths don't match.");
1829         for(uint i = 0; i < addr.length; i++) {
1830             _tokenTransfer(_msgSender(), addr[i], val[i]);
1831         }
1832     }
1833 
1834 }