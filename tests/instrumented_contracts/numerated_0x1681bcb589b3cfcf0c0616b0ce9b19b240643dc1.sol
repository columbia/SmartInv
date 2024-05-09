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
714 contract IslandToken is Context, Ownable, IERC20 {
715 
716     // Libraries
717 	using SafeMath for uint256;
718     using Address for address;
719     
720     // Attributes for ERC-20 token
721     string private _name = "Island";
722     string private _symbol = "ISLE";
723     uint8 private _decimals = 9;
724     
725     mapping (address => uint256) private _balance;
726     mapping (address => mapping (address => uint256)) private _allowances;
727     
728     uint256 private _total = 690000000 * 10**6 * 10**9;
729     uint256 private maxTxAmount = 3450000 * 10**6 * 10**9;
730     uint256 private numTokensSellToAddToLiquidity = 345000 * 10**6 * 10**9;
731     uint256 private minHoldingThreshold = 100 * 10**6 * 10**9;
732     
733     // Island attributes
734     uint8 public sandTax = 5;
735     uint8 public burnableFundRate = 5;
736     uint8 public operationalFundRate = 1;
737     
738     uint256 public sandFund;
739     uint256 public burnableFund;
740     uint256 public operationalFund;
741     
742     uint256 private largePrizeTotal = 0;
743     uint256 private mediumPrizeTotal = 0;
744     uint256 private smallPrizeTotal = 0;
745     
746     bool inSwapAndLiquify;
747     bool public swapAndLiquifyEnabled = true;
748 
749     IUniswapV2Router02 public immutable uniSwapV2Router;
750     address public immutable uniswapV2Pair;
751 
752 	struct Entity {
753 		address _key;
754 		bool _isValid;
755 		uint256 _createdAt;
756 	}
757 	mapping (address => uint256) private addressToIndex;
758 	mapping (uint256 => Entity) private indexToEntity;
759 	uint256 private lastIndexUsed = 0;
760 	uint256 private lastEntryAllowed = 0;
761 	
762 	uint32 public perBatchSize = 100;
763 	
764 	event GrandPrizeReceivedAddresses (
765     	address addressReceived,
766     	uint256 amount
767     );
768 
769     event MediumPrizeReceivedAddresses (
770     	address[] addressesReceived,
771     	uint256 amount
772     );
773     
774     event SmallPrizePayoutComplete (
775     	uint256 amount
776     );
777     
778     event SwapAndLiquifyEnabledUpdated(bool enabled);
779     event SwapAndLiquify(
780         uint256 tokensSwapped,
781         uint256 ethReceived,
782         uint256 tokensIntoLiqudity
783     );
784     
785     event OperationalFundWithdrawn(
786         uint256 amount,
787         address recepient,
788         string reason
789     );
790     
791     event StartSand (
792         uint256 largePrizeTotal,
793         uint256 mediumPrizeTotal,
794         uint256 lowPrizeTotal
795     );
796 
797     constructor () {
798 	    _balance[_msgSender()] = _total;
799 	    addEntity(_msgSender());
800 	    
801 	    sandFund = 0;
802         burnableFund = 0;
803         operationalFund = 0;
804         inSwapAndLiquify = false;
805 	    
806 	    IUniswapV2Router02 _UniSwapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
807         uniswapV2Pair = IUniswapV2Factory(_UniSwapV2Router.factory())
808             .createPair(address(this), _UniSwapV2Router.WETH());
809             
810         uniSwapV2Router = _UniSwapV2Router;
811         
812         emit Transfer(address(0), _msgSender(), _total);
813     }
814     
815     modifier lockTheSwap {
816         inSwapAndLiquify = true;
817         _;
818         inSwapAndLiquify = false;
819     }
820     
821     // --- section 1 --- : Standard ERC 20 functions
822 
823     function name() public view returns (string memory) {
824         return _name;
825     }
826 
827     function symbol() public view returns (string memory) {
828         return _symbol;
829     }
830 
831     function decimals() public view returns (uint8) {
832         return _decimals;
833     }
834     
835     function totalSupply() public view override returns (uint256) {
836         return _total;
837     }
838 
839     function balanceOf(address account) public view override returns (uint256) {
840         return _balance[account];
841     }
842     
843     function approve(address spender, uint256 amount) public override returns (bool) {
844         _approve(_msgSender(), spender, amount);
845         return true;
846     }
847     
848     function transfer(address recipient, uint256 amount) public override returns (bool) {
849         _transfer(_msgSender(), recipient, amount);
850         return true;
851     }
852 
853     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
854         _transfer(sender, recipient, amount);
855         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
856         return true;
857     }
858 
859     function allowance(address owner, address spender) public view override returns (uint256) {
860         return _allowances[owner][spender];
861     }
862 
863     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
864         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
865         return true;
866     }
867 
868     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
869         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
870         return true;
871     }
872     
873     // --- section 2 --- : Island specific logics
874     
875     function burnToken(uint256 amount) public onlyOwner virtual {
876         require(amount <= _balance[address(this)], "Cannot burn more than avilable balancec");
877         require(amount <= burnableFund, "Cannot burn more than burn fund");
878 
879         _balance[address(this)] = _balance[address(this)].sub(amount);
880         _total = _total.sub(amount);
881         burnableFund = burnableFund.sub(amount);
882 
883         emit Transfer(address(this), address(0), amount);
884     }
885     
886     function getCommunityIslandFund() public view returns (uint256) {
887     	uint256 communityFund = burnableFund.add(sandFund).add(operationalFund);
888     	return communityFund;
889     }
890     
891     function getminHoldingThreshold() public view returns (uint256) {
892         return minHoldingThreshold;
893     }
894     
895     function getMaxTxnAmount() public view returns (uint256) {
896         return maxTxAmount;
897     }
898 
899     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
900     	swapAndLiquifyEnabled = _enabled;
901         emit SwapAndLiquifyEnabledUpdated(_enabled);
902     }
903     
904     function setminHoldingThreshold(uint256 amount) public onlyOwner {
905         minHoldingThreshold = amount;
906     }
907     
908     function setMaxTxnAmount(uint256 amount) public onlyOwner {
909         maxTxAmount = amount;
910     }
911     
912     function setBatchSize(uint32 newSize) public onlyOwner {
913         perBatchSize = newSize;
914     }
915 
916     function withdrawOperationFund(uint256 amount, address walletAddress, string memory reason) public onlyOwner() {
917         require(amount < operationalFund, "You cannot withdraw more funds that you have in island fund");
918     	require(amount <= _balance[address(this)], "You cannot withdraw more funds that you have in operation fund");
919     	
920     	// track operation fund after withdrawal
921     	operationalFund = operationalFund.sub(amount);
922     	_balance[address(this)] = _balance[address(this)].sub(amount);
923     	_balance[walletAddress] = _balance[walletAddress].add(amount);
924     	
925     	emit OperationalFundWithdrawn(amount, walletAddress, reason);
926     }
927     
928     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
929         uint256 half = contractTokenBalance.div(2);
930         uint256 otherHalf = contractTokenBalance.sub(half);
931 
932         uint256 initialBalance = address(this).balance;
933         swapTokensForEth(half);
934         uint256 newBalance = address(this).balance.sub(initialBalance);
935 
936         addLiquidity(otherHalf, newBalance);
937         
938         emit SwapAndLiquify(half, newBalance, otherHalf);
939     }
940 
941     function swapTokensForEth(uint256 tokenAmount) private {
942         address[] memory path = new address[](2);
943         path[0] = address(this);
944         path[1] = uniSwapV2Router.WETH();
945 
946         _approve(address(this), address(uniSwapV2Router), tokenAmount);
947 
948         // make the swap
949         uniSwapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
950             tokenAmount,
951             0, // accept any amount of ETH
952             path,
953             address(this),
954             block.timestamp
955         );
956     }
957 
958     //to recieve WETH from Uniswap when swaping
959     receive() external payable {}
960 
961     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
962         // approve token transfer to cover all possible scenarios
963         _approve(address(this), address(uniSwapV2Router), tokenAmount);
964 
965         // add the liquidity
966         uniSwapV2Router.addLiquidityETH{value: ethAmount}(
967             address(this),
968             tokenAmount,
969             0, // slippage is unavoidable
970             0, // slippage is unavoidable
971             owner(),
972             block.timestamp
973         );
974     }
975     
976     // --- section 3 --- : Executions
977     
978     function _approve(address owner, address spender, uint256 amount) private {
979         require(owner != address(0), "ERC20: approve from the zero address");
980         require(spender != address(0), "ERC20: approve to the zero address");
981 
982         _allowances[owner][spender] = amount;
983 
984         emit Approval(owner, spender, amount);
985     }
986     
987     function _transfer(address fromAddress, address toAddress, uint256 amount) private {
988         require(fromAddress != address(0) && toAddress != address(0), "ERC20: transfer from/to the zero address");
989         require(amount > 0 && amount <= _balance[fromAddress], "Transfer amount invalid");
990         if(fromAddress != owner() && toAddress != owner())
991             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
992 
993         // This is contract's balance without any reserved funds such as island Fund
994         uint256 contractTokenBalance = balanceOf(address(this)).sub(getCommunityIslandFund());
995         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
996         
997         // Dynamically hydrate LP. Standard practice in recent altcoin
998         if (
999             overMinTokenBalance &&
1000             !inSwapAndLiquify &&
1001             fromAddress != uniswapV2Pair &&
1002             swapAndLiquifyEnabled
1003         ) {
1004             contractTokenBalance = numTokensSellToAddToLiquidity;
1005             swapAndLiquify(contractTokenBalance);
1006         }
1007         
1008         _balance[fromAddress] = _balance[fromAddress].sub(amount);
1009         uint256 transactionTokenAmount = _getValues(amount);
1010         _balance[toAddress] = _balance[toAddress].add(transactionTokenAmount);
1011 
1012         // Add and remove wallet address from SAND eligibility
1013         if (_balance[toAddress] >= minHoldingThreshold && toAddress != address(this)){
1014         	addEntity(toAddress);
1015         }
1016         if (_balance[fromAddress] < minHoldingThreshold && fromAddress != address(this)) {
1017         	removeEntity(fromAddress);
1018         }
1019         
1020         shuffleEntities(amount, transactionTokenAmount);
1021 
1022         emit Transfer(fromAddress, toAddress, transactionTokenAmount);
1023     }
1024 
1025     function _getValues(uint256 amount) private returns (uint256) {
1026     	uint256 sandTaxFee = _extractSandFund(amount);
1027         uint256 operationalTax = _extractOperationalFund(amount);
1028     	uint256 burnableFundTax = _extractBurnableFund(amount);
1029 
1030     	uint256 businessTax = operationalTax.add(burnableFundTax).add(sandTaxFee);
1031     	uint256 transactionAmount = amount.sub(businessTax);
1032 
1033 		return transactionAmount;
1034     }
1035 
1036     function _extractSandFund(uint256 amount) private returns (uint256) {
1037     	uint256 sandFundContribution = _getExtractableFund(amount, sandTax);
1038     	sandFund = sandFund.add(sandFundContribution);
1039     	_balance[address(this)] = _balance[address(this)].add(sandFundContribution);
1040     	return sandFundContribution;
1041     }
1042 
1043     function _extractOperationalFund(uint256 amount) private returns (uint256) {
1044         (uint256 operationalFundContribution) = _getExtractableFund(amount, operationalFundRate);
1045     	operationalFund = operationalFund.add(operationalFundContribution);
1046     	_balance[address(this)] = _balance[address(this)].add(operationalFundContribution);
1047     	return operationalFundContribution;
1048     }
1049 
1050     function _extractBurnableFund(uint256 amount) private returns (uint256) {
1051     	(uint256 burnableFundContribution) = _getExtractableFund(amount, burnableFundRate);
1052     	burnableFund = burnableFund.add(burnableFundContribution);
1053     	_balance[address(this)] = _balance[address(this)].add(burnableFundContribution);
1054     	return burnableFundContribution;
1055     }
1056 
1057     function _getExtractableFund(uint256 amount, uint8 rate) private pure returns (uint256) {
1058     	return amount.mul(rate).div(10**2);
1059     }
1060     
1061     // --- Section 4 --- : SAND functions. 
1062     // Off-chain bot calls payoutLargeRedistribution, payoutMediumRedistribution, payoutSmallRedistribution in order
1063     
1064     function startSand() public onlyOwner returns (bool success) {
1065         require (sandFund > 0, "fund too small");
1066         largePrizeTotal = sandFund.div(4);
1067         mediumPrizeTotal = sandFund.div(2);
1068         smallPrizeTotal = sandFund.sub(largePrizeTotal).sub(mediumPrizeTotal);
1069         lastEntryAllowed = lastIndexUsed;
1070         
1071         emit StartSand(largePrizeTotal, mediumPrizeTotal, smallPrizeTotal);
1072         
1073         return true;
1074     }
1075     
1076     function payoutLargeRedistribution() public onlyOwner() returns (bool success) {
1077         require (lastEntryAllowed != 0, "SAND must be initiated before this function can be called.");
1078         uint256 seed = 69;
1079         uint256 largePrize = largePrizeTotal;
1080         
1081         // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1082         uint randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1083         
1084         Entity memory bigPrizeEligibleEntity = getEntity(randNum, false);
1085         while (bigPrizeEligibleEntity._isValid != true) {
1086             // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1087             randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1088             bigPrizeEligibleEntity = getEntity(randNum, false);
1089         }
1090         
1091         address bigPrizeEligibleAddress = bigPrizeEligibleEntity._key;
1092         
1093         sandFund = sandFund.sub(largePrize);
1094         _balance[bigPrizeEligibleAddress] = _balance[bigPrizeEligibleAddress].add(largePrize);
1095         _balance[address(this)] = _balance[address(this)].sub(largePrize);
1096         largePrizeTotal = 0;
1097         
1098         emit GrandPrizeReceivedAddresses(bigPrizeEligibleAddress, largePrize);
1099         
1100         return true;
1101     }
1102     
1103     function payoutMediumRedistribution() public onlyOwner() returns (bool success) {
1104         require (lastEntryAllowed != 0, "SAND must be initiated before this function can be called.");
1105         // Should be executed after grand prize is received
1106         uint256 mediumPrize = mediumPrizeTotal;
1107         uint256 eligibleHolderCount = 100;
1108         uint256 totalDisbursed = 0;
1109         uint256 seed = 69;
1110         address[] memory eligibleAddresses = new address[](100);
1111         uint8 counter = 0;
1112         
1113         // Not likely scenarios where there are less than 100 eligible accounts
1114         if (lastEntryAllowed <= 100) {
1115             //  If eligible acccount counts are less than 100, evenly split
1116     		eligibleHolderCount = lastEntryAllowed;
1117     		mediumPrize = mediumPrize.div(eligibleHolderCount);
1118     		while (counter < eligibleHolderCount) {
1119     	    
1120         	    if (indexToEntity[counter + 1]._isValid) {
1121         	        eligibleAddresses[counter] = indexToEntity[counter + 1]._key;
1122         	        totalDisbursed = totalDisbursed.add(mediumPrize);
1123         	        _balance[indexToEntity[counter + 1]._key] = _balance[indexToEntity[counter + 1]._key].add(mediumPrize);
1124         	        counter++;
1125         	    }
1126         	    seed = seed.add(1);
1127         	}
1128         	
1129         	sandFund = sandFund.sub(totalDisbursed);
1130         	_balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1131         	// This  may be different from totalDisbursed depending on number of eligible accounts.
1132         	// The primary use of this attribute is more of a flag to indicate the medium prize is disbursed fully.
1133         	mediumPrizeTotal = 0;
1134         	
1135         	emit MediumPrizeReceivedAddresses(eligibleAddresses, mediumPrize);
1136         	
1137         	return true;
1138     	}
1139     	
1140     	mediumPrize = mediumPrize.div(eligibleHolderCount);
1141     	
1142     	// Max iteration should never be comparably larger than 100 due to how the addresses and indexes are used.
1143     	while (counter < eligibleHolderCount) {
1144     	    
1145     	    // Uses random number generator from timestamp. However, nobody should know what order addresses are stored due to shffle
1146     	    uint randNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % lastEntryAllowed;
1147     	    
1148     	    if (indexToEntity[randNum]._isValid) {
1149     	        eligibleAddresses[counter] = indexToEntity[randNum]._key;
1150     	        totalDisbursed = totalDisbursed.add(mediumPrize);
1151     	        _balance[indexToEntity[randNum]._key] = _balance[indexToEntity[randNum]._key].add(mediumPrize);
1152     	        counter++;
1153     	    }
1154     	    seed = seed.add(1);
1155     	}
1156     	
1157     	sandFund = sandFund.sub(totalDisbursed);
1158         _balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1159         // This  may be different from totalDisbursed depending on number of eligible accounts.
1160         // The primary use of this attribute is more of a flag to indicate the medium prize is disbursed fully.
1161         mediumPrizeTotal = 0;
1162     	
1163     	emit MediumPrizeReceivedAddresses(eligibleAddresses, mediumPrize);
1164 		
1165 		return true;
1166     }
1167     
1168     function payoutSmallRedistribution(uint256 startIndex) public onlyOwner() returns (bool success) {
1169         require (lastEntryAllowed != 0 && startIndex > 0, "Medium prize must be disbursed before this one");
1170         
1171         uint256 rewardAmount = smallPrizeTotal.div(lastEntryAllowed);
1172         uint256 totalDisbursed = 0;
1173         
1174         for (uint256 i = startIndex; i < startIndex + perBatchSize; i++) {
1175             if  (sandFund < rewardAmount) {
1176                 break;
1177             }
1178             // Timestamp being used to prevent duplicate rewards
1179             if (indexToEntity[i]._isValid == true) {
1180                 _balance[indexToEntity[i]._key] = _balance[indexToEntity[i]._key].add(rewardAmount);
1181                 totalDisbursed = totalDisbursed.add(rewardAmount);
1182             }
1183             if (i == lastEntryAllowed) {
1184                 emit SmallPrizePayoutComplete(rewardAmount);
1185                 smallPrizeTotal = 0;
1186                 break;
1187             }
1188         }
1189         
1190         sandFund = sandFund.sub(totalDisbursed);
1191         _balance[address(this)] = _balance[address(this)].sub(totalDisbursed);
1192         
1193         return true;
1194     }
1195     
1196     function EndSand() public onlyOwner returns (bool success) {
1197         // Checking this equates to ALL redistribution events are completed.
1198         require (lastEntryAllowed != 0, "All prizes must be disbursed before being able to close SAND");
1199         smallPrizeTotal = 0;
1200         mediumPrizeTotal = 0;
1201         largePrizeTotal = 0;
1202         lastEntryAllowed = 0;
1203         
1204         return true;
1205     }
1206     
1207     // --- Section 5 ---
1208     function addEntity (address walletAddress) private {
1209         if (addressToIndex[walletAddress] != 0) {
1210             return;
1211         }
1212         uint256 index = lastIndexUsed.add(1);
1213         
1214 		indexToEntity[index] = Entity({
1215 		    _key: walletAddress,
1216 		    _isValid: true, 
1217 		    _createdAt: block.timestamp
1218 		});
1219 		
1220 		addressToIndex[walletAddress] = index;
1221 		lastIndexUsed = index;
1222 	}
1223 
1224 	function removeEntity (address walletAddress) private {
1225 	    if (addressToIndex[walletAddress] == 0) {
1226             return;
1227         }
1228         uint256 index = addressToIndex[walletAddress];
1229         addressToIndex[walletAddress] = 0;
1230         
1231         if (index != lastIndexUsed) {
1232             indexToEntity[index] = indexToEntity[lastIndexUsed];
1233             addressToIndex[indexToEntity[lastIndexUsed]._key] = index;
1234         }
1235         indexToEntity[lastIndexUsed]._isValid = false;
1236         lastIndexUsed = lastIndexUsed.sub(1);
1237 	}
1238 	
1239 	function shuffleEntities(uint256 intA, uint256 intB) private {
1240 	    // Interval of 1 to lastIndexUsed - 1
1241 	    intA = intA.mod(lastIndexUsed - 1) + 1;
1242 	    intB = intB.mod(lastIndexUsed - 1) + 1;
1243 	    
1244 	    Entity memory entityA = indexToEntity[intA];
1245 	    Entity memory entityB = indexToEntity[intB];
1246 	    
1247 	    if (entityA._isValid && entityB._isValid) {
1248 	        addressToIndex[entityA._key] = intB;
1249 	        addressToIndex[entityB._key] = intA;
1250 	        
1251 	        indexToEntity[intA] = entityB;
1252 	        indexToEntity[intB] = entityA;
1253 	    }
1254 	}
1255 	
1256 	function getEntityListLength () public view returns (uint256) {
1257 	    return lastIndexUsed;
1258 	}
1259 	
1260 	function getEntity (uint256 index, bool shouldReject) private view returns (Entity memory) {
1261 	    if (shouldReject == true) {
1262 	        require(index <= getEntityListLength(), "Index out of range");
1263 	    }
1264 	    return indexToEntity[index];
1265 	}
1266 	
1267 	function getEntityTimeStamp (address walletAddress) public view returns (uint256) {
1268 	    require (addressToIndex[walletAddress] != 0, "Empty!");
1269 	    return indexToEntity[addressToIndex[walletAddress]]._createdAt;
1270 	}
1271 
1272 }