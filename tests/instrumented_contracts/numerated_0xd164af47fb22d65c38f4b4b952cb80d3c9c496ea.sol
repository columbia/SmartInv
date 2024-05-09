1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // CAUTION
83 // This version of SafeMath should only be used with Solidity 0.8 or later,
84 // because it relies on the compiler's built in overflow checks.
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations.
88  *
89  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
90  * now has built in overflow checking.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, with an overflow flag.
95      *
96      * _Available since v3.4._
97      */
98     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
99         unchecked {
100             uint256 c = a + b;
101             if (c < a) return (false, 0);
102             return (true, c);
103         }
104     }
105 
106     /**
107      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
108      *
109      * _Available since v3.4._
110      */
111     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             if (b > a) return (false, 0);
114             return (true, a - b);
115         }
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         unchecked {
125             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126             // benefit is lost if 'b' is also tested.
127             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
128             if (a == 0) return (true, 0);
129             uint256 c = a * b;
130             if (c / a != b) return (false, 0);
131             return (true, c);
132         }
133     }
134 
135     /**
136      * @dev Returns the division of two unsigned integers, with a division by zero flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         unchecked {
142             if (b == 0) return (false, 0);
143             return (true, a / b);
144         }
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             if (b == 0) return (false, 0);
155             return (true, a % b);
156         }
157     }
158 
159     /**
160      * @dev Returns the addition of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `+` operator.
164      *
165      * Requirements:
166      *
167      * - Addition cannot overflow.
168      */
169     function add(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a + b;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a - b;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a * b;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator.
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a / b;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * reverting when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a % b;
229     }
230 
231     /**
232      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
233      * overflow (when the result is negative).
234      *
235      * CAUTION: This function is deprecated because it requires allocating memory for the error
236      * message unnecessarily. For custom revert reasons use {trySub}.
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      *
242      * - Subtraction cannot overflow.
243      */
244     function sub(
245         uint256 a,
246         uint256 b,
247         string memory errorMessage
248     ) internal pure returns (uint256) {
249         unchecked {
250             require(b <= a, errorMessage);
251             return a - b;
252         }
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(
268         uint256 a,
269         uint256 b,
270         string memory errorMessage
271     ) internal pure returns (uint256) {
272         unchecked {
273             require(b > 0, errorMessage);
274             return a / b;
275         }
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting with custom message when dividing by zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryMod}.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a % b;
301         }
302     }
303 }
304 
305 /**
306  * @dev Provides information about the current execution context, including the
307  * sender of the transaction and its data. While these are generally available
308  * via msg.sender and msg.data, they should not be accessed in such a direct
309  * manner, since when dealing with meta-transactions the account sending and
310  * paying for execution may not be the actual sender (as far as an application
311  * is concerned).
312  *
313  * This contract is only required for intermediate, library-like contracts.
314  */
315 abstract contract Context {
316     function _msgSender() internal view virtual returns (address) {
317         return msg.sender;
318     }
319 
320     function _msgData() internal view virtual returns (bytes calldata) {
321         return msg.data;
322     }
323 }
324 
325 /**
326  * @dev Contract module which provides a basic access control mechanism, where
327  * there is an account (an owner) that can be granted exclusive access to
328  * specific functions.
329  *
330  * By default, the owner account will be the one that deploys the contract. This
331  * can later be changed with {transferOwnership}.
332  *
333  * This module is used through inheritance. It will make available the modifier
334  * `onlyOwner`, which can be applied to your functions to restrict their use to
335  * the owner.
336  */
337 abstract contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev Initializes the contract setting the deployer as the initial owner.
344      */
345     constructor() {
346         _setOwner(_msgSender());
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if called by any account other than the owner.
358      */
359     modifier onlyOwner() {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361         _;
362     }
363 
364     /**
365      * @dev Leaves the contract without owner. It will not be possible to call
366      * `onlyOwner` functions anymore. Can only be called by the current owner.
367      *
368      * NOTE: Renouncing ownership will leave the contract without an owner,
369      * thereby removing any functionality that is only available to the owner.
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _setOwner(newOwner);
382     }
383 
384     function _setOwner(address newOwner) private {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 /**
392  * @dev Collection of functions related to the address type
393  */
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * [IMPORTANT]
399      * ====
400      * It is unsafe to assume that an address for which this function returns
401      * false is an externally-owned account (EOA) and not a contract.
402      *
403      * Among others, `isContract` will return false for the following
404      * types of addresses:
405      *
406      *  - an externally-owned account
407      *  - a contract in construction
408      *  - an address where a contract will be created
409      *  - an address where a contract lived, but was destroyed
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize, which returns 0 for contracts in
414         // construction, since the code is only stored at the end of the
415         // constructor execution.
416 
417         uint256 size;
418         assembly {
419             size := extcodesize(account)
420         }
421         return size > 0;
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      */
440     function sendValue(address payable recipient, uint256 amount) internal {
441         require(address(this).balance >= amount, "Address: insufficient balance");
442 
443         (bool success, ) = recipient.call{value: amount}("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 
447     /**
448      * @dev Performs a Solidity function call using a low level `call`. A
449      * plain `call` is an unsafe replacement for a function call: use this
450      * function instead.
451      *
452      * If `target` reverts with a revert reason, it is bubbled up by this
453      * function (like regular Solidity function calls).
454      *
455      * Returns the raw returned data. To convert to the expected return value,
456      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
457      *
458      * Requirements:
459      *
460      * - `target` must be a contract.
461      * - calling `target` with `data` must not revert.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
504      * with `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 value,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(address(this).balance >= value, "Address: insufficient balance for call");
515         require(isContract(target), "Address: call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.call{value: value}(data);
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
528         return functionStaticCall(target, data, "Address: low-level static call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal view returns (bytes memory) {
542         require(isContract(target), "Address: static call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.staticcall(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
555         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(isContract(target), "Address: delegate call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.delegatecall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
577      * revert reason using the provided one.
578      *
579      * _Available since v4.3._
580      */
581     function verifyCallResult(
582         bool success,
583         bytes memory returndata,
584         string memory errorMessage
585     ) internal pure returns (bytes memory) {
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 interface IUniswapV2Pair {
605     event Approval(address indexed owner, address indexed spender, uint value);
606     event Transfer(address indexed from, address indexed to, uint value);
607 
608     function name() external pure returns (string memory);
609     function symbol() external pure returns (string memory);
610     function decimals() external pure returns (uint8);
611     function totalSupply() external view returns (uint);
612     function balanceOf(address owner) external view returns (uint);
613     function allowance(address owner, address spender) external view returns (uint);
614 
615     function approve(address spender, uint value) external returns (bool);
616     function transfer(address to, uint value) external returns (bool);
617     function transferFrom(address from, address to, uint value) external returns (bool);
618 
619     function DOMAIN_SEPARATOR() external view returns (bytes32);
620     function PERMIT_TYPEHASH() external pure returns (bytes32);
621     function nonces(address owner) external view returns (uint);
622 
623     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
624 
625     event Mint(address indexed sender, uint amount0, uint amount1);
626     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
627     event Swap(
628         address indexed sender,
629         uint amount0In,
630         uint amount1In,
631         uint amount0Out,
632         uint amount1Out,
633         address indexed to
634     );
635     event Sync(uint112 reserve0, uint112 reserve1);
636 
637     function MINIMUM_LIQUIDITY() external pure returns (uint);
638     function factory() external view returns (address);
639     function token0() external view returns (address);
640     function token1() external view returns (address);
641     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
642     function price0CumulativeLast() external view returns (uint);
643     function price1CumulativeLast() external view returns (uint);
644     function kLast() external view returns (uint);
645 
646     function mint(address to) external returns (uint liquidity);
647     function burn(address to) external returns (uint amount0, uint amount1);
648     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
649     function skim(address to) external;
650     function sync() external;
651 
652     function initialize(address, address) external;
653 }
654 
655 interface IUniswapV2Factory {
656     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
657 
658     function feeTo() external view returns (address);
659     function feeToSetter() external view returns (address);
660 
661     function getPair(address tokenA, address tokenB) external view returns (address pair);
662     function allPairs(uint) external view returns (address pair);
663     function allPairsLength() external view returns (uint);
664 
665     function createPair(address tokenA, address tokenB) external returns (address pair);
666 
667     function setFeeTo(address) external;
668     function setFeeToSetter(address) external;
669 }
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
765 interface IUniswapV2Router02 is IUniswapV2Router01 {
766     function removeLiquidityETHSupportingFeeOnTransferTokens(
767         address token,
768         uint liquidity,
769         uint amountTokenMin,
770         uint amountETHMin,
771         address to,
772         uint deadline
773     ) external returns (uint amountETH);
774     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
775         address token,
776         uint liquidity,
777         uint amountTokenMin,
778         uint amountETHMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountETH);
783 
784     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
785         uint amountIn,
786         uint amountOutMin,
787         address[] calldata path,
788         address to,
789         uint deadline
790     ) external;
791     function swapExactETHForTokensSupportingFeeOnTransferTokens(
792         uint amountOutMin,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external payable;
797     function swapExactTokensForETHSupportingFeeOnTransferTokens(
798         uint amountIn,
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external;
804 }
805 
806 /**
807  * @dev Interface for the Buy Back Reward contract that can be used to build
808  * custom logic to elevate user rewards
809  */
810 interface IConditional {
811   /**
812    * @dev Returns whether a wallet passes the test.
813    */
814   function passesTest(address wallet) external view returns (bool);
815 }
816 
817 contract RewardDABB is Context, IERC20, Ownable {
818   using SafeMath for uint256;
819   using Address for address;
820 
821   address payable public treasuryWallet =
822     payable(0x026777F93789aC717bd87746617760BDfd67AeDD);
823   address public constant deadAddress =
824     0x000000000000000000000000000000000000dEaD;
825 
826   mapping(address => uint256) private _rOwned;
827   mapping(address => uint256) private _tOwned;
828   mapping(address => mapping(address => uint256)) private _allowances;
829   mapping(address => bool) private _isSniper;
830   address[] private _confirmedSnipers;
831 
832   uint256 public rewardsClaimTimeSeconds = 60 * 60 * 24 * 7;  // 1 week
833 
834   mapping(address => uint256) private _rewardsLastClaim;
835 
836   mapping(address => bool) private _isExcludedFee;
837   mapping(address => bool) private _isExcludedReward;
838   address[] private _excluded;
839 
840   string private constant _name = 'Reward DABB';
841   string private constant _symbol = 'REDABB';
842   uint8 private constant _decimals = 9;
843 
844   uint256 private constant MAX = ~uint256(0);
845   uint256 private constant _tTotal = 1e5 * 10**_decimals;
846   uint256 private _rTotal = (MAX - (MAX % _tTotal));
847   uint256 private _tFeeTotal;
848 
849   uint256 public reflectionFee = 0;
850   uint256 private _previousReflectFee = reflectionFee;
851 
852   uint256 public treasuryFee = 5;
853   uint256 private _previousTreasuryFee = treasuryFee;
854 
855   uint256 public ethRewardsFee = 0;
856   uint256 private _previousETHRewardsFee = ethRewardsFee;
857   uint256 public ethRewardsBalance;
858 
859   uint256 public buybackFee = 0;
860   uint256 private _previousBuybackFee = buybackFee;
861   address public buybackTokenAddress = 0x82F729d6fbc640f99f3dB63512835fA8F7be4BE1;
862   address public buybackReceiver = address(this);
863 
864   uint256 public feeSellMultiplier = 5;
865   uint256 public feeRate = 10;
866   uint256 public launchTime;
867 
868   uint256 public boostRewardsPercent = 50;
869 
870   address public boostRewardsContract;
871   address public feeExclusionContract;
872 
873   IUniswapV2Router02 public uniswapV2Router;
874   address public uniswapV2Pair;
875   mapping(address => bool) private _isUniswapPair;
876 
877   // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
878   // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
879   address private constant _uniswapRouterAddress =
880     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
881 
882   bool private _inSwapAndLiquify;
883   bool private _isSelling;
884   bool private _tradingOpen = false;
885   bool private _isMaxBuyActivated = true;
886 
887   uint256 public _maxTxAmount = _tTotal.mul(2).div(100); // 2%
888   uint256 public _maxWalletSize = _tTotal.mul(2).div(100); // 2%
889   uint256 public _maximumBuyAmount = _tTotal.mul(2).div(100); // 2%
890 
891   event MaxTxAmountUpdated(uint256 _maxTxAmount);
892   event MaxWalletSizeUpdated(uint256 _maxWalletSize);
893   event SendETHRewards(address to, uint256 amountETH);
894   event SendTokenRewards(address to, address token, uint256 amount);
895   event SwapETHForTokens(address whereTo, uint256 amountIn, address[] path);
896   event SwapTokensForETH(uint256 amountIn, address[] path);
897   event SwapAndLiquify(
898     uint256 tokensSwappedForEth,
899     uint256 ethAddedForLp,
900     uint256 tokensAddedForLp
901   );
902 
903   modifier lockTheSwap() {
904     _inSwapAndLiquify = true;
905     _;
906     _inSwapAndLiquify = false;
907   }
908 
909   constructor() {
910     _rOwned[_msgSender()] = _rTotal;
911     emit Transfer(address(0), _msgSender(), _tTotal);
912   }
913 
914   function initContract() external onlyOwner {
915     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
916       _uniswapRouterAddress
917     );
918     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
919       address(this),
920       _uniswapV2Router.WETH()
921     );
922 
923     uniswapV2Router = _uniswapV2Router;
924 
925     _isExcludedFee[owner()] = true;
926     _isExcludedFee[address(this)] = true;
927     _isExcludedFee[treasuryWallet] = true;
928   }
929 
930   function openTrading() external onlyOwner {
931     treasuryFee = _previousTreasuryFee;
932     ethRewardsFee = _previousETHRewardsFee;
933     reflectionFee = _previousReflectFee;
934     buybackFee = _previousBuybackFee;
935     _tradingOpen = true;
936     launchTime = block.timestamp;
937   }
938 
939   function name() external pure returns (string memory) {
940     return _name;
941   }
942 
943   function symbol() external pure returns (string memory) {
944     return _symbol;
945   }
946 
947   function decimals() external pure returns (uint8) {
948     return _decimals;
949   }
950 
951   function totalSupply() external pure override returns (uint256) {
952     return _tTotal;
953   }
954 
955   function MaxTXAmount() external view returns (uint256) {
956     return _maxTxAmount;
957   }
958 
959   function MaxWalletSize() external view returns (uint256) {
960     return _maxWalletSize;
961   }
962 
963   function balanceOf(address account) public view override returns (uint256) {
964     if (_isExcludedReward[account]) return _tOwned[account];
965     return tokenFromReflection(_rOwned[account]);
966   }
967 
968   function transfer(address recipient, uint256 amount)
969     external
970     override
971     returns (bool)
972   {
973     _transfer(_msgSender(), recipient, amount);
974     return true;
975   }
976 
977   function allowance(address owner, address spender)
978     external
979     view
980     override
981     returns (uint256)
982   {
983     return _allowances[owner][spender];
984   }
985 
986   function approve(address spender, uint256 amount)
987     external
988     override
989     returns (bool)
990   {
991     _approve(_msgSender(), spender, amount);
992     return true;
993   }
994 
995   function transferFrom(
996     address sender,
997     address recipient,
998     uint256 amount
999   ) external override returns (bool) {
1000     _transfer(sender, recipient, amount);
1001     _approve(
1002       sender,
1003       _msgSender(),
1004       _allowances[sender][_msgSender()].sub(
1005         amount,
1006         'ERC20: transfer amount exceeds allowance'
1007       )
1008     );
1009     return true;
1010   }
1011 
1012   function increaseAllowance(address spender, uint256 addedValue)
1013     external
1014     virtual
1015     returns (bool)
1016   {
1017     _approve(
1018       _msgSender(),
1019       spender,
1020       _allowances[_msgSender()][spender].add(addedValue)
1021     );
1022     return true;
1023   }
1024 
1025   function decreaseAllowance(address spender, uint256 subtractedValue)
1026     external
1027     virtual
1028     returns (bool)
1029   {
1030     _approve(
1031       _msgSender(),
1032       spender,
1033       _allowances[_msgSender()][spender].sub(
1034         subtractedValue,
1035         'ERC20: decreased allowance below zero'
1036       )
1037     );
1038     return true;
1039   }
1040 
1041   function setMaxTxnAmount(uint256 maxTxAmountPercetange) external onlyOwner{
1042     require(maxTxAmountPercetange < 1000, "Maximum amount per transaction must be lower than 100%");
1043     require(maxTxAmountPercetange > 1, "Maximum amount per transaction must be higher than 0.1%");
1044     _maxTxAmount = _tTotal.mul(maxTxAmountPercetange).div(1000);
1045     emit MaxTxAmountUpdated(_maxTxAmount);
1046   }
1047 
1048   function setMaxWalletSize(uint256 maxWalletSizePercentage) external onlyOwner{
1049     require(maxWalletSizePercentage < 1000, "Maximum wallet size must be lower than 100%");
1050     require(maxWalletSizePercentage > 10, "Maximum wallet size must be higher than 1%");
1051     _maxWalletSize = _tTotal.mul(maxWalletSizePercentage).div(1000);
1052     emit MaxWalletSizeUpdated(_maxWalletSize);
1053   }
1054 
1055   function getLastETHRewardsClaim(address wallet)
1056     external
1057     view
1058     returns (uint256)
1059   {
1060     return _rewardsLastClaim[wallet];
1061   }
1062 
1063   function totalFees() external view returns (uint256) {
1064     return _tFeeTotal;
1065   }
1066 
1067   function deliver(uint256 tAmount) external {
1068     address sender = _msgSender();
1069     require(
1070       !_isExcludedReward[sender],
1071       'Excluded addresses cannot call this function'
1072     );
1073     (uint256 rAmount, , , , , ) = _getValues(sender, tAmount);
1074     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1075     _rTotal = _rTotal.sub(rAmount);
1076     _tFeeTotal = _tFeeTotal.add(tAmount);
1077   }
1078 
1079   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1080     external
1081     view
1082     returns (uint256)
1083   {
1084     require(tAmount <= _tTotal, 'Amount must be less than supply');
1085     if (!deductTransferFee) {
1086       (uint256 rAmount, , , , , ) = _getValues(address(0), tAmount);
1087       return rAmount;
1088     } else {
1089       (, uint256 rTransferAmount, , , , ) = _getValues(address(0), tAmount);
1090       return rTransferAmount;
1091     }
1092   }
1093 
1094   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1095     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1096     uint256 currentRate = _getRate();
1097     return rAmount.div(currentRate);
1098   }
1099 
1100   function excludeFromReward(address account) external onlyOwner {
1101     require(!_isExcludedReward[account], 'Account is already excluded');
1102     if (_rOwned[account] > 0) {
1103       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1104     }
1105     _isExcludedReward[account] = true;
1106     _excluded.push(account);
1107   }
1108 
1109   function includeInReward(address account) external onlyOwner {
1110     require(_isExcludedReward[account], 'Account is already included');
1111     for (uint256 i = 0; i < _excluded.length; i++) {
1112       if (_excluded[i] == account) {
1113         _excluded[i] = _excluded[_excluded.length - 1];
1114         _tOwned[account] = 0;
1115         _isExcludedReward[account] = false;
1116         _excluded.pop();
1117         break;
1118       }
1119     }
1120   }
1121 
1122   function _approve(
1123     address owner,
1124     address spender,
1125     uint256 amount
1126   ) private {
1127     require(owner != address(0), 'ERC20: approve from the zero address');
1128     require(spender != address(0), 'ERC20: approve to the zero address');
1129 
1130     _allowances[owner][spender] = amount;
1131     emit Approval(owner, spender, amount);
1132   }
1133 
1134   function _transfer(
1135     address from,
1136     address to,
1137     uint256 amount
1138   ) private {
1139     require(from != address(0), 'ERC20: transfer from the zero address');
1140     require(to != address(0), 'ERC20: transfer to the zero address');
1141     require(amount > 0, 'Transfer amount must be greater than zero');
1142     require(!_isSniper[to], 'Stop sniping!');
1143     require(!_isSniper[from], 'Stop sniping!');
1144     require(!_isSniper[_msgSender()], 'Stop sniping!');
1145 
1146     //check transaction amount only when selling
1147     if (
1148       (to == uniswapV2Pair || _isUniswapPair[to]) && 
1149       from != address(uniswapV2Router) &&
1150       !isExcludedFromFee(to) &&
1151       !isExcludedFromFee(from)
1152     ) {
1153         require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
1154     }
1155 
1156     if (
1157       to != uniswapV2Pair &&
1158       !_isUniswapPair[to] &&
1159       !isExcludedFromFee(to) && 
1160       !isExcludedFromFee(from)
1161       ) {
1162       require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
1163       if (_isMaxBuyActivated) {
1164         if (block.timestamp <= launchTime + 30 minutes) {
1165           require(amount <= _maximumBuyAmount, "Amount too much");
1166         }
1167       }
1168     }
1169 
1170     // reset receiver's timer to prevent users buying and
1171     // immmediately transferring to buypass timer
1172     _rewardsLastClaim[to] = block.timestamp;
1173 
1174     bool excludedFromFee = false;
1175 
1176     // buy
1177     if (
1178       (from == uniswapV2Pair || _isUniswapPair[from]) &&
1179       to != address(uniswapV2Router)
1180     ) {
1181       // normal buy, check for snipers
1182       if (!isExcludedFromFee(to)) {
1183         require(_tradingOpen, 'Trading not yet enabled.');
1184 
1185         // antibot
1186         if (block.timestamp == launchTime) {
1187           _isSniper[to] = true;
1188           _confirmedSnipers.push(to);
1189         }
1190         _rewardsLastClaim[from] = block.timestamp;
1191       } else {
1192         // set excluded flag for takeFee below since buyer is excluded
1193         excludedFromFee = true;
1194       }
1195     }
1196 
1197     // sell
1198     if (
1199       !_inSwapAndLiquify &&
1200       _tradingOpen &&
1201       (to == uniswapV2Pair || _isUniswapPair[to])
1202     ) {
1203       uint256 _contractTokenBalance = balanceOf(address(this));
1204       if (_contractTokenBalance > 0) {
1205         if (
1206           _contractTokenBalance > balanceOf(uniswapV2Pair).mul(feeRate).div(100)
1207         ) {
1208           _contractTokenBalance = balanceOf(uniswapV2Pair).mul(feeRate).div(
1209             100
1210           );
1211         }
1212         _swapTokens(_contractTokenBalance);
1213       }
1214       _rewardsLastClaim[from] = block.timestamp;
1215       _isSelling = true;
1216       excludedFromFee = isExcludedFromFee(from);
1217     }
1218 
1219     bool takeFee = false;
1220 
1221     // take fee only on swaps
1222     if (
1223       (from == uniswapV2Pair ||
1224         to == uniswapV2Pair ||
1225         _isUniswapPair[to] ||
1226         _isUniswapPair[from]) && !excludedFromFee
1227     ) {
1228       takeFee = true;
1229     }
1230 
1231     _tokenTransfer(from, to, amount, takeFee);
1232     _isSelling = false;
1233   }
1234 
1235   function _swapTokens(uint256 _contractTokenBalance) private lockTheSwap {
1236     uint256 ethBalanceBefore = address(this).balance;
1237     _swapTokensForEth(_contractTokenBalance);
1238     uint256 ethBalanceAfter = address(this).balance;
1239     uint256 ethBalanceUpdate = ethBalanceAfter.sub(ethBalanceBefore);
1240     uint256 _liquidityFeeTotal = _liquidityFeeAggregate(address(0));
1241 
1242     ethRewardsBalance += ethBalanceUpdate.mul(ethRewardsFee).div(
1243       _liquidityFeeTotal
1244     );
1245 
1246     // send ETH to treasury address
1247     uint256 treasuryETHBalance = ethBalanceUpdate.mul(treasuryFee).div(
1248       _liquidityFeeTotal
1249     );
1250     if (treasuryETHBalance > 0) {
1251       _sendETHToTreasury(treasuryETHBalance);
1252     }
1253 
1254     // buy back
1255     uint256 buybackETHBalance = ethBalanceUpdate.mul(buybackFee).div(
1256       _liquidityFeeTotal
1257     );
1258     if (buybackETHBalance > 0) {
1259       _buyBackTokens(buybackETHBalance);
1260     }
1261   }
1262 
1263   function _sendETHToTreasury(uint256 amount) private {
1264     treasuryWallet.call{ value: amount }('');
1265   }
1266 
1267   function _buyBackTokens(uint256 amount) private {
1268     // generate the uniswap pair path of token -> weth
1269     address[] memory path = new address[](2);
1270     path[0] = uniswapV2Router.WETH();
1271     path[1] = buybackTokenAddress;
1272 
1273     // make the swap
1274     uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1275       value: amount
1276     }(
1277       0, // accept any amount of tokens
1278       path,
1279       buybackReceiver,
1280       block.timestamp
1281     );
1282 
1283     emit SwapETHForTokens(buybackReceiver, amount, path);
1284   }
1285 
1286   function _swapTokensForEth(uint256 tokenAmount) private {
1287     // generate the uniswap pair path of token -> weth
1288     address[] memory path = new address[](2);
1289     path[0] = address(this);
1290     path[1] = uniswapV2Router.WETH();
1291 
1292     _approve(address(this), address(uniswapV2Router), tokenAmount);
1293 
1294     // make the swap
1295     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1296       tokenAmount,
1297       0, // accept any amount of ETH
1298       path,
1299       address(this), // the contract
1300       block.timestamp
1301     );
1302 
1303     emit SwapTokensForETH(tokenAmount, path);
1304   }
1305 
1306   function _tokenTransfer(
1307     address sender,
1308     address recipient,
1309     uint256 amount,
1310     bool takeFee
1311   ) private {
1312     if (!takeFee) _removeAllFee();
1313 
1314     if (_isExcludedReward[sender] && !_isExcludedReward[recipient]) {
1315       _transferFromExcluded(sender, recipient, amount);
1316     } else if (!_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1317       _transferToExcluded(sender, recipient, amount);
1318     } else if (_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1319       _transferBothExcluded(sender, recipient, amount);
1320     } else {
1321       _transferStandard(sender, recipient, amount);
1322     }
1323 
1324     if (!takeFee) _restoreAllFee();
1325   }
1326 
1327   function _transferStandard(
1328     address sender,
1329     address recipient,
1330     uint256 tAmount
1331   ) private {
1332     (
1333       uint256 rAmount,
1334       uint256 rTransferAmount,
1335       uint256 rFee,
1336       uint256 tTransferAmount,
1337       uint256 tFee,
1338       uint256 tLiquidity
1339     ) = _getValues(sender, tAmount);
1340     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1341     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1342     _takeLiquidity(tLiquidity);
1343     _reflectFee(rFee, tFee);
1344     emit Transfer(sender, recipient, tTransferAmount);
1345   }
1346 
1347   function _transferToExcluded(
1348     address sender,
1349     address recipient,
1350     uint256 tAmount
1351   ) private {
1352     (
1353       uint256 rAmount,
1354       uint256 rTransferAmount,
1355       uint256 rFee,
1356       uint256 tTransferAmount,
1357       uint256 tFee,
1358       uint256 tLiquidity
1359     ) = _getValues(sender, tAmount);
1360     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1361     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1362     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1363     _takeLiquidity(tLiquidity);
1364     _reflectFee(rFee, tFee);
1365     emit Transfer(sender, recipient, tTransferAmount);
1366   }
1367 
1368   function _transferFromExcluded(
1369     address sender,
1370     address recipient,
1371     uint256 tAmount
1372   ) private {
1373     (
1374       uint256 rAmount,
1375       uint256 rTransferAmount,
1376       uint256 rFee,
1377       uint256 tTransferAmount,
1378       uint256 tFee,
1379       uint256 tLiquidity
1380     ) = _getValues(sender, tAmount);
1381     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1382     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1383     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1384     _takeLiquidity(tLiquidity);
1385     _reflectFee(rFee, tFee);
1386     emit Transfer(sender, recipient, tTransferAmount);
1387   }
1388 
1389   function _transferBothExcluded(
1390     address sender,
1391     address recipient,
1392     uint256 tAmount
1393   ) private {
1394     (
1395       uint256 rAmount,
1396       uint256 rTransferAmount,
1397       uint256 rFee,
1398       uint256 tTransferAmount,
1399       uint256 tFee,
1400       uint256 tLiquidity
1401     ) = _getValues(sender, tAmount);
1402     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1403     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1404     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1405     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1406     _takeLiquidity(tLiquidity);
1407     _reflectFee(rFee, tFee);
1408     emit Transfer(sender, recipient, tTransferAmount);
1409   }
1410 
1411   function _reflectFee(uint256 rFee, uint256 tFee) private {
1412     _rTotal = _rTotal.sub(rFee);
1413     _tFeeTotal = _tFeeTotal.add(tFee);
1414   }
1415 
1416   function _getValues(address seller, uint256 tAmount)
1417     private
1418     view
1419     returns (
1420       uint256,
1421       uint256,
1422       uint256,
1423       uint256,
1424       uint256,
1425       uint256
1426     )
1427   {
1428     (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
1429       seller,
1430       tAmount
1431     );
1432     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1433       tAmount,
1434       tFee,
1435       tLiquidity,
1436       _getRate()
1437     );
1438     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1439   }
1440 
1441   function _getTValues(address seller, uint256 tAmount)
1442     private
1443     view
1444     returns (
1445       uint256,
1446       uint256,
1447       uint256
1448     )
1449   {
1450     uint256 tFee = _calculateReflectFee(tAmount);
1451     uint256 tLiquidity = _calculateLiquidityFee(seller, tAmount);
1452     uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1453     return (tTransferAmount, tFee, tLiquidity);
1454   }
1455 
1456   function _getRValues(
1457     uint256 tAmount,
1458     uint256 tFee,
1459     uint256 tLiquidity,
1460     uint256 currentRate
1461   )
1462     private
1463     pure
1464     returns (
1465       uint256,
1466       uint256,
1467       uint256
1468     )
1469   {
1470     uint256 rAmount = tAmount.mul(currentRate);
1471     uint256 rFee = tFee.mul(currentRate);
1472     uint256 rLiquidity = tLiquidity.mul(currentRate);
1473     uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1474     return (rAmount, rTransferAmount, rFee);
1475   }
1476 
1477   function _getRate() private view returns (uint256) {
1478     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1479     return rSupply.div(tSupply);
1480   }
1481 
1482   function _getCurrentSupply() private view returns (uint256, uint256) {
1483     uint256 rSupply = _rTotal;
1484     uint256 tSupply = _tTotal;
1485     for (uint256 i = 0; i < _excluded.length; i++) {
1486       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1487         return (_rTotal, _tTotal);
1488       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1489       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1490     }
1491     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1492     return (rSupply, tSupply);
1493   }
1494 
1495   function _takeLiquidity(uint256 tLiquidity) private {
1496     uint256 currentRate = _getRate();
1497     uint256 rLiquidity = tLiquidity.mul(currentRate);
1498     _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1499     if (_isExcludedReward[address(this)])
1500       _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1501   }
1502 
1503   function _calculateReflectFee(uint256 _amount)
1504     private
1505     view
1506     returns (uint256)
1507   {
1508     return _amount.mul(reflectionFee).div(10**2);
1509   }
1510 
1511   function _liquidityFeeAggregate(address seller)
1512     private
1513     view
1514     returns (uint256)
1515   {
1516     uint256 feeMultiplier = _isSelling && !canClaimRewards(seller)
1517       ? feeSellMultiplier
1518       : 1;
1519     return (treasuryFee.add(ethRewardsFee).add(buybackFee)).mul(feeMultiplier);
1520   }
1521 
1522   function _calculateLiquidityFee(address seller, uint256 _amount)
1523     private
1524     view
1525     returns (uint256)
1526   {
1527     return _amount.mul(_liquidityFeeAggregate(seller)).div(10**2);
1528   }
1529 
1530   function _removeAllFee() private {
1531     if (
1532       reflectionFee == 0 &&
1533       treasuryFee == 0 &&
1534       ethRewardsFee == 0 &&
1535       buybackFee == 0
1536     ) return;
1537 
1538     _previousReflectFee = reflectionFee;
1539     _previousTreasuryFee = treasuryFee;
1540     _previousETHRewardsFee = ethRewardsFee;
1541     _previousBuybackFee = buybackFee;
1542 
1543     reflectionFee = 0;
1544     treasuryFee = 0;
1545     ethRewardsFee = 0;
1546     buybackFee = 0;
1547   }
1548 
1549   function _restoreAllFee() private {
1550     reflectionFee = _previousReflectFee;
1551     treasuryFee = _previousTreasuryFee;
1552     ethRewardsFee = _previousETHRewardsFee;
1553     buybackFee = _previousBuybackFee;
1554   }
1555 
1556   function getSellSlippage(address seller) external view returns (uint256) {
1557     uint256 feeAgg = treasuryFee.add(ethRewardsFee).add(buybackFee);
1558     return
1559       isExcludedFromFee(seller) ? 0 : !canClaimRewards(seller)
1560         ? feeAgg.mul(feeSellMultiplier)
1561         : feeAgg;
1562   }
1563 
1564   function isUniswapPair(address _pair) external view returns (bool) {
1565     if (_pair == uniswapV2Pair) return true;
1566     return _isUniswapPair[_pair];
1567   }
1568 
1569   function eligibleForRewardBooster(address wallet) public view returns (bool) {
1570     return
1571       boostRewardsContract != address(0) &&
1572       IConditional(boostRewardsContract).passesTest(wallet);
1573   }
1574 
1575   function isExcludedFromFee(address account) public view returns (bool) {
1576     return
1577       _isExcludedFee[account] ||
1578       (feeExclusionContract != address(0) &&
1579         IConditional(feeExclusionContract).passesTest(account));
1580   }
1581 
1582   function isExcludedFromReward(address account) external view returns (bool) {
1583     return _isExcludedReward[account];
1584   }
1585 
1586   function excludeFromFee(address account) external onlyOwner {
1587     _isExcludedFee[account] = true;
1588   }
1589 
1590   function includeInFee(address account) external onlyOwner {
1591     _isExcludedFee[account] = false;
1592   }
1593 
1594   function setRewardsClaimTimeSeconds(uint256 _seconds) external onlyOwner {
1595     require(_seconds >= 0 &&_seconds <= 60 * 60 * 24 * 8, 'claim time delay must be greater or equal to 0 seconds and less than or equal to 8 days');
1596     rewardsClaimTimeSeconds = _seconds;
1597   }
1598   
1599   // tax can be raised to maximum 10% - buy and 20% - sell
1600   function setNewFeesPercentages(uint256 _reflectionNewFee, uint256 _treasuryNewFee, uint256 _ethRewardsNewFee, uint256 _buybackRewardsNewFee) external onlyOwner {
1601     require(_reflectionNewFee + _treasuryNewFee + _ethRewardsNewFee + _buybackRewardsNewFee <= 30, 'Tax cannot be higher than 30%');
1602     reflectionFee = _reflectionNewFee;
1603     treasuryFee = _treasuryNewFee;
1604     ethRewardsFee = _ethRewardsNewFee;
1605     buybackFee = _buybackRewardsNewFee;
1606   }
1607 
1608   function setFeeSellMultiplier(uint256 multiplier) external onlyOwner {
1609     require(multiplier <= 7, 'must be less than or equal to 7');
1610     feeSellMultiplier = multiplier;
1611   }
1612 
1613   function setTreasuryAddress(address _treasuryWallet) external onlyOwner {
1614     treasuryWallet = payable(_treasuryWallet);
1615     _isExcludedFee[treasuryWallet] = true;
1616   }
1617 
1618   function setIsMaxBuyActivated(bool _value) public onlyOwner {
1619     _isMaxBuyActivated = _value;
1620   }
1621 
1622   function setBuybackTokenAddress(address _tokenAddress) external onlyOwner {
1623     buybackTokenAddress = _tokenAddress;
1624   }
1625 
1626   function setBuybackReceiver(address _receiver) external onlyOwner {
1627     buybackReceiver = _receiver;
1628   }
1629 
1630   function addUniswapPair(address _pair) external onlyOwner {
1631     _isUniswapPair[_pair] = true;
1632   }
1633 
1634   function removeUniswapPair(address _pair) external onlyOwner {
1635     _isUniswapPair[_pair] = false;
1636   }
1637 
1638   function setBoostRewardsPercent(uint256 perc) external onlyOwner {
1639     boostRewardsPercent = perc;
1640   }
1641 
1642   function setBoostRewardsContract(address _contract) external onlyOwner {
1643     if (_contract != address(0)) {
1644       IConditional _contCheck = IConditional(_contract);
1645       // allow setting to zero address to effectively turn off check logic
1646       require(
1647         _contCheck.passesTest(address(0)) == true ||
1648           _contCheck.passesTest(address(0)) == false,
1649         'contract does not implement interface'
1650       );
1651     }
1652     boostRewardsContract = _contract;
1653   }
1654 
1655   function setFeeExclusionContract(address _contract) external onlyOwner {
1656     if (_contract != address(0)) {
1657       IConditional _contCheck = IConditional(_contract);
1658       // allow setting to zero address to effectively turn off check logic
1659       require(
1660         _contCheck.passesTest(address(0)) == true ||
1661           _contCheck.passesTest(address(0)) == false,
1662         'contract does not implement interface'
1663       );
1664     }
1665     feeExclusionContract = _contract;
1666   }
1667 
1668   function isRemovedSniper(address account) external view returns (bool) {
1669     return _isSniper[account];
1670   }
1671 
1672   function removeSniper(address account) external onlyOwner {
1673     require(account != _uniswapRouterAddress, 'We can not blacklist Uniswap');
1674     require(!_isSniper[account], 'Account is already blacklisted');
1675     _isSniper[account] = true;
1676     _confirmedSnipers.push(account);
1677   }
1678 
1679   function amnestySniper(address account) external onlyOwner {
1680     require(_isSniper[account], 'Account is not blacklisted');
1681     for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1682       if (_confirmedSnipers[i] == account) {
1683         _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1684         _isSniper[account] = false;
1685         _confirmedSnipers.pop();
1686         break;
1687       }
1688     }
1689   }
1690 
1691   function calculateETHRewards(address wallet) public view returns (uint256) {
1692     uint256 baseRewards = ethRewardsBalance.mul(balanceOf(wallet)).div(
1693       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1694     );
1695     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1696       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1697       : baseRewards;
1698     return
1699       rewardsWithBooster > ethRewardsBalance ? baseRewards : rewardsWithBooster;
1700   }
1701 
1702   function calculateTokenRewards(address wallet, address tokenAddress)
1703     public
1704     view
1705     returns (uint256)
1706   {
1707     IERC20 token = IERC20(tokenAddress);
1708     uint256 contractTokenBalance = token.balanceOf(address(this));
1709     uint256 baseRewards = contractTokenBalance.mul(balanceOf(wallet)).div(
1710       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1711     );
1712     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1713       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1714       : baseRewards;
1715     return
1716       rewardsWithBooster > contractTokenBalance
1717         ? baseRewards
1718         : rewardsWithBooster;
1719   }
1720 
1721   function claimETHRewards() external {
1722     require(
1723       balanceOf(_msgSender()) > 0,
1724       'You must have a balance to claim ETH rewards'
1725     );
1726     require(
1727       canClaimRewards(_msgSender()),
1728       'Must wait claim period before claiming rewards'
1729     );
1730     _rewardsLastClaim[_msgSender()] = block.timestamp;
1731 
1732     uint256 rewardsSent = calculateETHRewards(_msgSender());
1733     ethRewardsBalance -= rewardsSent;
1734     _msgSender().call{ value: rewardsSent }('');
1735     emit SendETHRewards(_msgSender(), rewardsSent);
1736   }
1737 
1738   function canClaimRewards(address user) public view returns (bool) {
1739     if (_rewardsLastClaim[user] == 0) {
1740       return
1741         block.timestamp > launchTime.add(rewardsClaimTimeSeconds);
1742     }
1743     else {
1744       return
1745         block.timestamp > _rewardsLastClaim[user].add(rewardsClaimTimeSeconds);
1746     }
1747   }
1748 
1749   function claimTokenRewards(address token) external {
1750     require(
1751       balanceOf(_msgSender()) > 0,
1752       'You must have a balance to claim rewards'
1753     );
1754     require(
1755       IERC20(token).balanceOf(address(this)) > 0,
1756       'We must have a token balance to claim rewards'
1757     );
1758     require(
1759       canClaimRewards(_msgSender()),
1760       'Must wait claim period before claiming rewards'
1761     );
1762     _rewardsLastClaim[_msgSender()] = block.timestamp;
1763 
1764     uint256 rewardsSent = calculateTokenRewards(_msgSender(), token);
1765     IERC20(token).transfer(_msgSender(), rewardsSent);
1766     emit SendTokenRewards(_msgSender(), token, rewardsSent);
1767   }
1768 
1769   function setFeeRate(uint256 _rate) external onlyOwner {
1770     feeRate = _rate;
1771   }
1772 
1773   function manualswap(uint256 amount) external onlyOwner {
1774     require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1775     _swapTokens(amount);
1776   }
1777 
1778   function emergencyWithdraw() external onlyOwner {
1779     payable(owner()).send(address(this).balance);
1780   }
1781 
1782   // to recieve ETH from uniswapV2Router when swaping
1783   receive() external payable {}
1784 }