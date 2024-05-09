1 pragma solidity 0.8.0;
2 // SPDX-License-Identifier: Unlicensed
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @dev Contract module which provides a basic access control mechanism, where
98  * there is an account (an owner) that can be granted exclusive access to
99  * specific functions.
100  *
101  * By default, the owner account will be the one that deploys the contract. This
102  * can later be changed with {transferOwnership}.
103  *
104  * This module is used through inheritance. It will make available the modifier
105  * `onlyOwner`, which can be applied to your functions to restrict their use to
106  * the owner.
107  */
108 abstract contract Ownable is Context {
109     address private _owner;
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113     /**
114      * @dev Initializes the contract setting the deployer as the initial owner.
115      */
116     constructor () {
117         address msgSender = _msgSender();
118         _owner = msgSender;
119         emit OwnershipTransferred(address(0), msgSender);
120     }
121 
122     /**
123      * @dev Returns the address of the current owner.
124      */
125     function owner() public view virtual returns (address) {
126         return _owner;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     /**
138      * @dev Leaves the contract without owner. It will not be possible to call
139      * `onlyOwner` functions anymore. Can only be called by the current owner.
140      *
141      * NOTE: Renouncing ownership will leave the contract without an owner,
142      * thereby removing any functionality that is only available to the owner.
143      */
144     function renounceOwnership() public virtual onlyOwner {
145         emit OwnershipTransferred(_owner, address(0));
146         _owner = address(0);
147     }
148 
149     /**
150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
151      * Can only be called by the current owner.
152      */
153     function transferOwnership(address newOwner) public virtual onlyOwner {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         emit OwnershipTransferred(_owner, newOwner);
156         _owner = newOwner;
157     }
158 }
159 
160 /**
161  * @dev Wrappers over Solidity's arithmetic operations.
162  *
163  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
164  * now has built in overflow checking.
165  */
166 library SafeMath {
167     /**
168      * @dev Returns the addition of two unsigned integers, with an overflow flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         unchecked {
174             uint256 c = a + b;
175             if (c < a) return (false, 0);
176             return (true, c);
177         }
178     }
179 
180     /**
181      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
182      *
183      * _Available since v3.4._
184      */
185     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
186         unchecked {
187             if (b > a) return (false, 0);
188             return (true, a - b);
189         }
190     }
191 
192     /**
193      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200             // benefit is lost if 'b' is also tested.
201             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202             if (a == 0) return (true, 0);
203             uint256 c = a * b;
204             if (c / a != b) return (false, 0);
205             return (true, c);
206         }
207     }
208 
209     /**
210      * @dev Returns the division of two unsigned integers, with a division by zero flag.
211      *
212      * _Available since v3.4._
213      */
214     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         unchecked {
216             if (b == 0) return (false, 0);
217             return (true, a / b);
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b == 0) return (false, 0);
229             return (true, a % b);
230         }
231     }
232 
233     /**
234      * @dev Returns the addition of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `+` operator.
238      *
239      * Requirements:
240      *
241      * - Addition cannot overflow.
242      */
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a + b;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a - b;
259     }
260 
261     /**
262      * @dev Returns the multiplication of two unsigned integers, reverting on
263      * overflow.
264      *
265      * Counterpart to Solidity's `*` operator.
266      *
267      * Requirements:
268      *
269      * - Multiplication cannot overflow.
270      */
271     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a * b;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers, reverting on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator.
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function div(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a / b;
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a % b;
303     }
304 
305     /**
306      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
307      * overflow (when the result is negative).
308      *
309      * CAUTION: This function is deprecated because it requires allocating memory for the error
310      * message unnecessarily. For custom revert reasons use {trySub}.
311      *
312      * Counterpart to Solidity's `-` operator.
313      *
314      * Requirements:
315      *
316      * - Subtraction cannot overflow.
317      */
318     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         unchecked {
320             require(b <= a, errorMessage);
321             return a - b;
322         }
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
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
342         unchecked {
343             require(b > 0, errorMessage);
344             return a / b;
345         }
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * reverting with custom message when dividing by zero.
351      *
352      * CAUTION: This function is deprecated because it requires allocating memory for the error
353      * message unnecessarily. For custom revert reasons use {tryMod}.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         unchecked {
365             require(b > 0, errorMessage);
366             return a % b;
367         }
368     }
369 }
370 
371 
372 
373 /**
374  * @dev Collection of functions related to the address type
375  */
376 library Address {
377     /**
378      * @dev Returns true if `account` is a contract.
379      *
380      * [IMPORTANT]
381      * ====
382      * It is unsafe to assume that an address for which this function returns
383      * false is an externally-owned account (EOA) and not a contract.
384      *
385      * Among others, `isContract` will return false for the following
386      * types of addresses:
387      *
388      *  - an externally-owned account
389      *  - a contract in construction
390      *  - an address where a contract will be created
391      *  - an address where a contract lived, but was destroyed
392      * ====
393      */
394     function isContract(address account) internal view returns (bool) {
395         // This method relies on extcodesize, which returns 0 for contracts in
396         // construction, since the code is only stored at the end of the
397         // constructor execution.
398 
399         uint256 size;
400         // solhint-disable-next-line no-inline-assembly
401         assembly { size := extcodesize(account) }
402         return size > 0;
403     }
404 
405     /**
406      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
407      * `recipient`, forwarding all available gas and reverting on errors.
408      *
409      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
410      * of certain opcodes, possibly making contracts go over the 2300 gas limit
411      * imposed by `transfer`, making them unable to receive funds via
412      * `transfer`. {sendValue} removes this limitation.
413      *
414      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
415      *
416      * IMPORTANT: because control is transferred to `recipient`, care must be
417      * taken to not create reentrancy vulnerabilities. Consider using
418      * {ReentrancyGuard} or the
419      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
420      */
421     function sendValue(address payable recipient, uint256 amount) internal {
422         require(address(this).balance >= amount, "Address: insufficient balance");
423 
424         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
425         (bool success, ) = recipient.call{ value: amount }("");
426         require(success, "Address: unable to send value, recipient may have reverted");
427     }
428 
429     /**
430      * @dev Performs a Solidity function call using a low level `call`. A
431      * plain`call` is an unsafe replacement for a function call: use this
432      * function instead.
433      *
434      * If `target` reverts with a revert reason, it is bubbled up by this
435      * function (like regular Solidity function calls).
436      *
437      * Returns the raw returned data. To convert to the expected return value,
438      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
439      *
440      * Requirements:
441      *
442      * - `target` must be a contract.
443      * - calling `target` with `data` must not revert.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
448       return functionCall(target, data, "Address: low-level call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
453      * `errorMessage` as a fallback revert reason when `target` reverts.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         require(isContract(target), "Address: call to non-contract");
485 
486         // solhint-disable-next-line avoid-low-level-calls
487         (bool success, bytes memory returndata) = target.call{ value: value }(data);
488         return _verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a static call.
494      *
495      * _Available since v3.3._
496      */
497     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
498         return functionStaticCall(target, data, "Address: low-level static call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a static call.
504      *
505      * _Available since v3.3._
506      */
507     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
508         require(isContract(target), "Address: static call to non-contract");
509 
510         // solhint-disable-next-line avoid-low-level-calls
511         (bool success, bytes memory returndata) = target.staticcall(data);
512         return _verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a delegate call.
518      *
519      * _Available since v3.4._
520      */
521     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
522         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a delegate call.
528      *
529      * _Available since v3.4._
530      */
531     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.delegatecall(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 // solhint-disable-next-line no-inline-assembly
548                 assembly {
549                     let returndata_size := mload(returndata)
550                     revert(add(32, returndata), returndata_size)
551                 }
552             } else {
553                 revert(errorMessage);
554             }
555         }
556     }
557 }
558 
559 
560 interface IUniswapV2Router01 {
561     function factory() external pure returns (address);
562     function WETH() external pure returns (address);
563 
564     function addLiquidity(
565         address tokenA,
566         address tokenB,
567         uint amountADesired,
568         uint amountBDesired,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountA, uint amountB, uint liquidity);
574     function addLiquidityETH(
575         address token,
576         uint amountTokenDesired,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
582     function removeLiquidity(
583         address tokenA,
584         address tokenB,
585         uint liquidity,
586         uint amountAMin,
587         uint amountBMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETH(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountToken, uint amountETH);
599     function removeLiquidityWithPermit(
600         address tokenA,
601         address tokenB,
602         uint liquidity,
603         uint amountAMin,
604         uint amountBMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountA, uint amountB);
609     function removeLiquidityETHWithPermit(
610         address token,
611         uint liquidity,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline,
616         bool approveMax, uint8 v, bytes32 r, bytes32 s
617     ) external returns (uint amountToken, uint amountETH);
618     function swapExactTokensForTokens(
619         uint amountIn,
620         uint amountOutMin,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external returns (uint[] memory amounts);
625     function swapTokensForExactTokens(
626         uint amountOut,
627         uint amountInMax,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external returns (uint[] memory amounts);
632     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
637         external
638         returns (uint[] memory amounts);
639     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
640         external
641         returns (uint[] memory amounts);
642     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
643         external
644         payable
645         returns (uint[] memory amounts);
646 
647     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
648     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
649     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
650     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
651     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
652 }
653 
654 
655 interface IUniswapV2Router02 is IUniswapV2Router01 {
656     function removeLiquidityETHSupportingFeeOnTransferTokens(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline
663     ) external returns (uint amountETH);
664     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountETH);
673 
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681     function swapExactETHForTokensSupportingFeeOnTransferTokens(
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external payable;
687     function swapExactTokensForETHSupportingFeeOnTransferTokens(
688         uint amountIn,
689         uint amountOutMin,
690         address[] calldata path,
691         address to,
692         uint deadline
693     ) external;
694 }
695 
696 
697 interface IUniswapV2Factory {
698     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
699 
700     function feeTo() external view returns (address);
701     function feeToSetter() external view returns (address);
702 
703     function getPair(address tokenA, address tokenB) external view returns (address pair);
704     function allPairs(uint) external view returns (address pair);
705     function allPairsLength() external view returns (uint);
706 
707     function createPair(address tokenA, address tokenB) external returns (address pair);
708 
709     function setFeeTo(address) external;
710     function setFeeToSetter(address) external;
711 }
712 
713 
714 contract MansionCashToken is Context, Ownable, IERC20 {
715 
716     // Libraries
717 	using SafeMath for uint256;
718     using Address for address;
719     
720     // Attributes for ERC-20 token
721     string private _name = "MansionCash";
722     string private _symbol = "MSC";
723     uint8 private _decimals = 9;
724     
725     mapping (address => uint256) private _balance;
726     mapping (address => mapping (address => uint256)) private _allowances;
727     
728     uint256 private _total = 100000000 * 10**6 * 10**9; // cap 100,000B 
729     uint256 private maxTxAmount = 3450000 * 10**6 * 10**9;
730     uint256 private numTokensSellToAddToLiquidity = 345000 * 10**6 * 10**9;
731     uint256 private minHoldingThreshold = 50000 * 10**6 * 10**9; // 50B
732     
733     // MansionCash attributes
734     uint8 public mansionTax = 6;
735     uint8 public burnableFundRate = 3;
736     uint8 public operationalFundRate = 1;
737     
738     uint256 public mansionFund;
739     uint256 public burnableFund;
740     uint256 public operationalFund;
741     
742     uint256 private largePrizeTotal = 0;
743     uint256 private mediumPrizeTotal = 0;
744     uint256 private smallPrizeTotal = 0;
745     
746     bool inSwapAndLiquify;
747     bool public swapAndLiquifyEnabled = true;
748     bool public transactionFee = false;
749 
750     IUniswapV2Router02 public immutable uniSwapV2Router;
751     address public immutable uniswapV2Pair;
752 
753 	struct Entity {
754 		address _key;
755 		bool _isValid;
756 		uint256 _createdAt;
757 	}
758 	mapping (address => uint256) private addressToIndex;
759 	mapping (uint256 => Entity) private indexToEntity;
760 	uint256 private lastIndexUsed = 0;
761 	uint256 private lastEntryAllowed = 0;
762 	
763 	uint32 public perBatchSize = 100;
764 	
765 	event GrandPrizeReceivedAddresses (
766     	address addressReceived,
767     	uint256 amount
768     );
769 
770     event MediumPrizeReceivedAddresses (
771     	address[] addressesReceived,
772     	uint256 amount
773     );
774     
775     event SmallPrizePayoutComplete (
776     	uint256 amount
777     );
778     
779     event SwapAndLiquifyEnabledUpdated(bool enabled);
780     event TransactionFeeEnableUpdated(bool enabled );
781     event SwapAndLiquify(
782         uint256 tokensSwapped,
783         uint256 ethReceived,
784         uint256 tokensIntoLiqudity
785     );
786     
787     event OperationalFundWithdrawn(
788         uint256 amount,
789         address recepient,
790         string reason
791     );
792     
793     event StartMansion (
794         uint256 largePrizeTotal,
795         uint256 mediumPrizeTotal,
796         uint256 lowPrizeTotal
797     );
798 
799     constructor () {
800 	    _balance[_msgSender()] = _total;
801 	    addEntity(_msgSender());
802 	    
803 	    mansionFund = 0;
804         burnableFund = 0;
805         operationalFund = 0;
806         inSwapAndLiquify = false;
807 	    
808 	    IUniswapV2Router02 _UniSwapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
809         uniswapV2Pair = IUniswapV2Factory(_UniSwapV2Router.factory())
810             .createPair(address(this), _UniSwapV2Router.WETH());
811             
812         uniSwapV2Router = _UniSwapV2Router;
813         
814         emit Transfer(address(0), _msgSender(), _total);
815     }
816     
817     modifier lockTheSwap {
818         inSwapAndLiquify = true;
819         _;
820         inSwapAndLiquify = false;
821     }
822     
823     // --- section 1 --- : Standard ERC 20 functions
824 
825     function name() public view returns (string memory) {
826         return _name;
827     }
828 
829     function symbol() public view returns (string memory) {
830         return _symbol;
831     }
832 
833     function decimals() public view returns (uint8) {
834         return _decimals;
835     }
836     
837     function totalSupply() public view override returns (uint256) {
838         return _total;
839     }
840 
841     function balanceOf(address account) public view override returns (uint256) {
842         return _balance[account];
843     }
844     
845     function approve(address spender, uint256 amount) public override returns (bool) {
846         _approve(_msgSender(), spender, amount);
847         return true;
848     }
849     
850     function transfer(address recipient, uint256 amount) public override returns (bool) {
851         _transfer(_msgSender(), recipient, amount);
852         return true;
853     }
854 
855     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
856         _transfer(sender, recipient, amount);
857         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
858         return true;
859     }
860 
861     function allowance(address owner, address spender) public view override returns (uint256) {
862         return _allowances[owner][spender];
863     }
864 
865     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
866         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
867         return true;
868     }
869 
870     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
871         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
872         return true;
873     }
874     
875     // --- section 2 --- : MansionCash specific logics
876     
877     function burnToken(uint256 amount) public onlyOwner virtual {
878         require(amount <= _balance[address(this)], "Cannot burn more than avilable balancec");
879         require(amount <= burnableFund, "Cannot burn more than burn fund");
880 
881         _balance[address(this)] = _balance[address(this)].sub(amount);
882         _total = _total.sub(amount);
883         burnableFund = burnableFund.sub(amount);
884 
885         emit Transfer(address(this), address(0), amount);
886     }
887     
888     function getCommunityMansionCashFund() public view returns (uint256) {
889     	uint256 communityFund = burnableFund.add(mansionFund).add(operationalFund);
890     	return communityFund;
891     }
892     
893     function getminHoldingThreshold() public view returns (uint256) {
894         return minHoldingThreshold;
895     }
896     
897     function getMaxTxnAmount() public view returns (uint256) {
898         return maxTxAmount;
899     }
900 
901     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
902     	swapAndLiquifyEnabled = _enabled;
903         emit SwapAndLiquifyEnabledUpdated(_enabled);
904     }
905 
906     function setTransactionFee(bool _enabled) public onlyOwner {
907     	transactionFee = _enabled;
908         emit TransactionFeeEnableUpdated(_enabled);
909     }
910     
911     function setminHoldingThreshold(uint256 amount) public onlyOwner {
912         minHoldingThreshold = amount;
913     }
914     
915     function setMaxTxnAmount(uint256 amount) public onlyOwner {
916         maxTxAmount = amount;
917     }
918     
919     function setBatchSize(uint32 newSize) public onlyOwner {
920         perBatchSize = newSize;
921     }
922 
923     function withdrawOperationFund(uint256 amount, address walletAddress, string memory reason) public onlyOwner() {
924         require(amount < operationalFund, "You cannot withdraw more funds that you have in mansion fund");
925     	require(amount <= _balance[address(this)], "You cannot withdraw more funds that you have in operation fund");
926     	
927     	// track operation fund after withdrawal
928     	operationalFund = operationalFund.sub(amount);
929     	_balance[address(this)] = _balance[address(this)].sub(amount);
930     	_balance[walletAddress] = _balance[walletAddress].add(amount);
931     	
932     	emit OperationalFundWithdrawn(amount, walletAddress, reason);
933     }
934     
935     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
936         uint256 half = contractTokenBalance.div(2);
937         uint256 otherHalf = contractTokenBalance.sub(half);
938 
939         uint256 initialBalance = address(this).balance;
940         swapTokensForEth(half);
941         uint256 newBalance = address(this).balance.sub(initialBalance);
942 
943         addLiquidity(otherHalf, newBalance);
944         
945         emit SwapAndLiquify(half, newBalance, otherHalf);
946     }
947 
948     function swapTokensForEth(uint256 tokenAmount) private {
949         address[] memory path = new address[](2);
950         path[0] = address(this);
951         path[1] = uniSwapV2Router.WETH();
952 
953         _approve(address(this), address(uniSwapV2Router), tokenAmount);
954 
955         // make the swap
956         uniSwapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
957             tokenAmount,
958             0, // accept any amount of ETH
959             path,
960             address(this),
961             block.timestamp
962         );
963     }
964 
965     //to recieve WETH from Uniswap when swaping
966     receive() external payable {}
967 
968     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
969         // approve token transfer to cover all possible scenarios
970         _approve(address(this), address(uniSwapV2Router), tokenAmount);
971 
972         // add the liquidity
973         uniSwapV2Router.addLiquidityETH{value: ethAmount}(
974             address(this),
975             tokenAmount,
976             0, // slippage is unavoidable
977             0, // slippage is unavoidable
978             owner(),
979             block.timestamp
980         );
981     }
982     
983     // --- section 3 --- : Executions
984     
985     function _approve(address owner, address spender, uint256 amount) private {
986         require(owner != address(0), "ERC20: approve from the zero address");
987         require(spender != address(0), "ERC20: approve to the zero address");
988 
989         _allowances[owner][spender] = amount;
990 
991         emit Approval(owner, spender, amount);
992     }
993     
994     function _transfer(address fromAddress, address toAddress, uint256 amount) private {
995         require(fromAddress != address(0) && toAddress != address(0), "ERC20: transfer from/to the zero address");
996         require(amount > 0 && amount <= _balance[fromAddress], "Transfer amount invalid");
997         if(fromAddress != owner() && toAddress != owner())
998             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
999 
1000         // This is contract's balance without any reserved funds such as mansion Fund
1001         uint256 contractTokenBalance = balanceOf(address(this)).sub(getCommunityMansionCashFund());
1002         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1003         
1004         // Dynamically hydrate LP. Standard practice in recent altcoin
1005         if (
1006             overMinTokenBalance &&
1007             !inSwapAndLiquify &&
1008             fromAddress != uniswapV2Pair &&
1009             swapAndLiquifyEnabled
1010         ) {
1011             contractTokenBalance = numTokensSellToAddToLiquidity;
1012             swapAndLiquify(contractTokenBalance);
1013         }
1014         
1015         _balance[fromAddress] = _balance[fromAddress].sub(amount);
1016         uint256 transactionTokenAmount = _getValues(amount);
1017         _balance[toAddress] = _balance[toAddress].add(transactionTokenAmount);
1018 
1019         // Add and remove wallet address from MANSION eligibility
1020         if (_balance[toAddress] >= minHoldingThreshold && toAddress != address(this)){
1021         	addEntity(toAddress);
1022         }
1023         if (_balance[fromAddress] < minHoldingThreshold && fromAddress != address(this)) {
1024         	removeEntity(fromAddress);
1025         }
1026         
1027         shuffleEntities(amount, transactionTokenAmount);
1028 
1029         emit Transfer(fromAddress, toAddress, transactionTokenAmount);
1030     }
1031 
1032     function _getValues(uint256 amount) private returns (uint256) {
1033     	// if not charge fee transaction.
1034         if (!transactionFee ){
1035             return amount ;
1036         }
1037     	uint256 mansionTaxFee = _extractMansionFund(amount);
1038         uint256 operationalTax = _extractOperationalFund(amount);
1039     	uint256 burnableFundTax = _extractBurnableFund(amount);
1040 
1041     	uint256 businessTax = operationalTax.add(burnableFundTax).add(mansionTaxFee);
1042     	uint256 transactionAmount = amount.sub(businessTax);
1043         
1044 		return transactionAmount;
1045     }
1046 
1047     function _extractMansionFund(uint256 amount) private returns (uint256) {
1048     	uint256 mansionFundContribution = _getExtractableFund(amount, mansionTax);
1049     	mansionFund = mansionFund.add(mansionFundContribution);
1050     	_balance[address(this)] = _balance[address(this)].add(mansionFundContribution);
1051     	return mansionFundContribution;
1052     }
1053 
1054     function _extractOperationalFund(uint256 amount) private returns (uint256) {
1055         (uint256 operationalFundContribution) = _getExtractableFund(amount, operationalFundRate);
1056     	operationalFund = operationalFund.add(operationalFundContribution);
1057     	_balance[address(this)] = _balance[address(this)].add(operationalFundContribution);
1058     	return operationalFundContribution;
1059     }
1060 
1061     function _extractBurnableFund(uint256 amount) private returns (uint256) {
1062     	(uint256 burnableFundContribution) = _getExtractableFund(amount, burnableFundRate);
1063     	burnableFund = burnableFund.add(burnableFundContribution);
1064     	_balance[address(this)] = _balance[address(this)].add(burnableFundContribution);
1065     	return burnableFundContribution;
1066     }
1067 
1068     function _getExtractableFund(uint256 amount, uint8 rate) private pure returns (uint256) {
1069     	return amount.mul(rate).div(10**2);
1070     }
1071     
1072     // --- Section 4 --- : MANSION functions. 
1073     // Off-chain bot calls payoutLargeRedistribution, payoutMediumRedistribution, payoutSmallRedistribution in order
1074     
1075     function startMansion() public onlyOwner returns (bool success) {
1076         require (mansionFund > 0, "fund too small");
1077         largePrizeTotal = mansionFund.div(4);
1078         mediumPrizeTotal = mansionFund.div(2);
1079         smallPrizeTotal = mansionFund.sub(largePrizeTotal).sub(mediumPrizeTotal);
1080         lastEntryAllowed = lastIndexUsed;
1081         
1082         emit StartMansion(largePrizeTotal, mediumPrizeTotal, smallPrizeTotal);
1083         
1084         return true;
1085     }
1086     
1087     function payoutLargeRedistribution() public onlyOwner() returns (bool success) {
1088         require (lastEntryAllowed != 0, "MANSION must be initiated before this function can be called.");
1089         uint256 seed = 48;
1090         uint256 largePrize = largePrizeTotal;
1091         
1092         // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1093         uint randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1094         
1095         Entity memory bigPrizeEligibleEntity = getEntity(randNum, false);
1096         while (bigPrizeEligibleEntity._isValid != true) {
1097             // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1098             randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1099             bigPrizeEligibleEntity = getEntity(randNum, false);
1100         }
1101         
1102         address bigPrizeEligibleAddress = bigPrizeEligibleEntity._key;
1103         
1104         mansionFund = mansionFund.sub(largePrize);
1105         _balance[bigPrizeEligibleAddress] = _balance[bigPrizeEligibleAddress].add(largePrize);
1106         _balance[address(this)] = _balance[address(this)].sub(largePrize);
1107         largePrizeTotal = 0;
1108         
1109         emit GrandPrizeReceivedAddresses(bigPrizeEligibleAddress, largePrize);
1110         
1111         return true;
1112     }
1113     
1114     function payoutMediumRedistribution() public onlyOwner() returns (bool success) {
1115         require (lastEntryAllowed != 0, "MANSION must be initiated before this function can be called.");
1116         // Should be executed after grand prize is received
1117         uint256 mediumPrize = mediumPrizeTotal;
1118         uint256 eligibleHolderCount = 100;
1119         uint256 totalDisbursed = 0;
1120         uint256 seed = 48;
1121         address[] memory eligibleAddresses = new address[](100);
1122         uint8 counter = 0;
1123         
1124         // Not likely scenarios where there are less than 100 eligible accounts
1125         if (lastEntryAllowed <= 100) {
1126             //  If eligible acccount counts are less than 100, evenly split
1127     		eligibleHolderCount = lastEntryAllowed;
1128     		mediumPrize = mediumPrize.div(eligibleHolderCount);
1129     		while (counter < eligibleHolderCount) {
1130     	    
1131         	    if (indexToEntity[counter + 1]._isValid) {
1132         	        eligibleAddresses[counter] = indexToEntity[counter + 1]._key;
1133         	        totalDisbursed = totalDisbursed.add(mediumPrize);
1134         	        _balance[indexToEntity[counter + 1]._key] = _balance[indexToEntity[counter + 1]._key].add(mediumPrize);
1135         	        counter++;
1136         	    }
1137         	    seed = seed.add(1);
1138         	}
1139         	
1140         	mansionFund = mansionFund.sub(totalDisbursed);
1141         	_balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1142         	// This  may be different from totalDisbursed depending on number of eligible accounts.
1143         	// The primary use of this attribute is more of a flag to indicate the medium prize is disbursed fully.
1144         	mediumPrizeTotal = 0;
1145         	
1146         	emit MediumPrizeReceivedAddresses(eligibleAddresses, mediumPrize);
1147         	
1148         	return true;
1149     	}
1150     	
1151     	mediumPrize = mediumPrize.div(eligibleHolderCount);
1152     	
1153     	// Max iteration should never be comparably larger than 100 due to how the addresses and indexes are used.
1154     	while (counter < eligibleHolderCount) {
1155     	    
1156     	    // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1157     	    uint randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1158     	    
1159     	    if (indexToEntity[randNum]._isValid) {
1160     	        eligibleAddresses[counter] = indexToEntity[randNum]._key;
1161     	        totalDisbursed = totalDisbursed.add(mediumPrize);
1162     	        _balance[indexToEntity[randNum]._key] = _balance[indexToEntity[randNum]._key].add(mediumPrize);
1163     	        counter++;
1164     	    }
1165     	    seed = seed.add(1);
1166     	}
1167     	
1168     	mansionFund = mansionFund.sub(totalDisbursed);
1169         _balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1170         // This  may be different from totalDisbursed depending on number of eligible accounts.
1171         // The primary use of this attribute is more of a flag to indicate the medium prize is disbursed fully.
1172         mediumPrizeTotal = 0;
1173     	
1174     	emit MediumPrizeReceivedAddresses(eligibleAddresses, mediumPrize);
1175 		
1176 		return true;
1177     }
1178     
1179     function payoutSmallRedistribution(uint256 startIndex) public onlyOwner() returns (bool success) {
1180         require (lastEntryAllowed != 0 && startIndex > 0, "Medium prize must be disbursed before this one");
1181         
1182         uint256 rewardAmount = smallPrizeTotal.div(lastEntryAllowed);
1183         uint256 totalDisbursed = 0;
1184         
1185         for (uint256 i = startIndex; i < startIndex + perBatchSize; i++) {
1186             if  (mansionFund < rewardAmount) {
1187                 break;
1188             }
1189             // Timestamp being used to prevent duplicate rewards
1190             if (indexToEntity[i]._isValid == true) {
1191                 _balance[indexToEntity[i]._key] = _balance[indexToEntity[i]._key].add(rewardAmount);
1192                 totalDisbursed = totalDisbursed.add(rewardAmount);
1193             }
1194             if (i == lastEntryAllowed) {
1195                 emit SmallPrizePayoutComplete(rewardAmount);
1196                 smallPrizeTotal = 0;
1197                 break;
1198             }
1199         }
1200         
1201         mansionFund = mansionFund.sub(totalDisbursed);
1202         _balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1203         
1204         return true;
1205     }
1206     
1207     function EndMansion() public onlyOwner returns (bool success) {
1208         // Checking this equates to ALL redistribution events are completed.
1209         require (lastEntryAllowed != 0, "All prizes must be disbursed before being able to close MANSION");
1210         smallPrizeTotal = 0;
1211         mediumPrizeTotal = 0;
1212         largePrizeTotal = 0;
1213         lastEntryAllowed = 0;
1214         
1215         return true;
1216     }
1217     
1218     // --- Section 5 ---
1219     function addEntity (address walletAddress) private {
1220         if (addressToIndex[walletAddress] != 0) {
1221             return;
1222         }
1223         uint256 index = lastIndexUsed.add(1);
1224         
1225 		indexToEntity[index] = Entity({
1226 		    _key: walletAddress,
1227 		    _isValid: true, 
1228 		    _createdAt: block.timestamp
1229 		});
1230 		
1231 		addressToIndex[walletAddress] = index;
1232 		lastIndexUsed = index;
1233 	}
1234 
1235 	function removeEntity (address walletAddress) private {
1236 	    if (addressToIndex[walletAddress] == 0) {
1237             return;
1238         }
1239         uint256 index = addressToIndex[walletAddress];
1240         addressToIndex[walletAddress] = 0;
1241         
1242         if (index != lastIndexUsed) {
1243             indexToEntity[index] = indexToEntity[lastIndexUsed];
1244             addressToIndex[indexToEntity[lastIndexUsed]._key] = index;
1245         }
1246         indexToEntity[lastIndexUsed]._isValid = false;
1247         lastIndexUsed = lastIndexUsed.sub(1);
1248 	}
1249 	
1250 	function shuffleEntities(uint256 intA, uint256 intB) private {
1251 	    // Interval of 1 to lastIndexUsed - 1
1252 	    intA = intA.mod(lastIndexUsed - 1) + 1;
1253 	    intB = intB.mod(lastIndexUsed - 1) + 1;
1254 	    
1255 	    Entity memory entityA = indexToEntity[intA];
1256 	    Entity memory entityB = indexToEntity[intB];
1257 	    
1258 	    if (entityA._isValid && entityB._isValid) {
1259 	        addressToIndex[entityA._key] = intB;
1260 	        addressToIndex[entityB._key] = intA;
1261 	        
1262 	        indexToEntity[intA] = entityB;
1263 	        indexToEntity[intB] = entityA;
1264 	    }
1265 	}
1266 	
1267 	function getEntityListLength () public view returns (uint256) {
1268 	    return lastIndexUsed;
1269 	}
1270 	
1271 	function getEntity (uint256 index, bool shouldReject) private view returns (Entity memory) {
1272 	    if (shouldReject == true) {
1273 	        require(index <= getEntityListLength(), "Index out of range");
1274 	    }
1275 	    return indexToEntity[index];
1276 	}
1277 	
1278 	function getEntityTimeStamp (address walletAddress) public view returns (uint256) {
1279 	    require (addressToIndex[walletAddress] != 0, "Empty!");
1280 	    return indexToEntity[addressToIndex[walletAddress]]._createdAt;
1281 	}
1282 
1283 }