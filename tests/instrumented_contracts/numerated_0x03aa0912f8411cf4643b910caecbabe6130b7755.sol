1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
146 
147 pragma solidity >=0.5.0;
148 
149 interface IUniswapV2Pair {
150     event Approval(address indexed owner, address indexed spender, uint value);
151     event Transfer(address indexed from, address indexed to, uint value);
152 
153     function name() external pure returns (string memory);
154     function symbol() external pure returns (string memory);
155     function decimals() external pure returns (uint8);
156     function totalSupply() external view returns (uint);
157     function balanceOf(address owner) external view returns (uint);
158     function allowance(address owner, address spender) external view returns (uint);
159 
160     function approve(address spender, uint value) external returns (bool);
161     function transfer(address to, uint value) external returns (bool);
162     function transferFrom(address from, address to, uint value) external returns (bool);
163 
164     function DOMAIN_SEPARATOR() external view returns (bytes32);
165     function PERMIT_TYPEHASH() external pure returns (bytes32);
166     function nonces(address owner) external view returns (uint);
167 
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
169 
170     event Mint(address indexed sender, uint amount0, uint amount1);
171     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
172     event Swap(
173         address indexed sender,
174         uint amount0In,
175         uint amount1In,
176         uint amount0Out,
177         uint amount1Out,
178         address indexed to
179     );
180     event Sync(uint112 reserve0, uint112 reserve1);
181 
182     function MINIMUM_LIQUIDITY() external pure returns (uint);
183     function factory() external view returns (address);
184     function token0() external view returns (address);
185     function token1() external view returns (address);
186     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
187     function price0CumulativeLast() external view returns (uint);
188     function price1CumulativeLast() external view returns (uint);
189     function kLast() external view returns (uint);
190 
191     function mint(address to) external returns (uint liquidity);
192     function burn(address to) external returns (uint amount0, uint amount1);
193     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
194     function skim(address to) external;
195     function sync() external;
196 
197     function initialize(address, address) external;
198 }
199 
200 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
201 
202 pragma solidity >=0.5.0;
203 
204 interface IUniswapV2Factory {
205     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
206 
207     function feeTo() external view returns (address);
208     function feeToSetter() external view returns (address);
209 
210     function getPair(address tokenA, address tokenB) external view returns (address pair);
211     function allPairs(uint) external view returns (address pair);
212     function allPairsLength() external view returns (uint);
213 
214     function createPair(address tokenA, address tokenB) external returns (address pair);
215 
216     function setFeeTo(address) external;
217     function setFeeToSetter(address) external;
218 }
219 
220 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 // CAUTION
228 // This version of SafeMath should only be used with Solidity 0.8 or later,
229 // because it relies on the compiler's built in overflow checks.
230 
231 /**
232  * @dev Wrappers over Solidity's arithmetic operations.
233  *
234  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
235  * now has built in overflow checking.
236  */
237 library SafeMath {
238     /**
239      * @dev Returns the addition of two unsigned integers, with an overflow flag.
240      *
241      * _Available since v3.4._
242      */
243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             uint256 c = a + b;
246             if (c < a) return (false, 0);
247             return (true, c);
248         }
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
253      *
254      * _Available since v3.4._
255      */
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271             // benefit is lost if 'b' is also tested.
272             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273             if (a == 0) return (true, 0);
274             uint256 c = a * b;
275             if (c / a != b) return (false, 0);
276             return (true, c);
277         }
278     }
279 
280     /**
281      * @dev Returns the division of two unsigned integers, with a division by zero flag.
282      *
283      * _Available since v3.4._
284      */
285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a / b);
289         }
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
294      *
295      * _Available since v3.4._
296      */
297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         unchecked {
299             if (b == 0) return (false, 0);
300             return (true, a % b);
301         }
302     }
303 
304     /**
305      * @dev Returns the addition of two unsigned integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `+` operator.
309      *
310      * Requirements:
311      *
312      * - Addition cannot overflow.
313      */
314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a + b;
316     }
317 
318     /**
319      * @dev Returns the subtraction of two unsigned integers, reverting on
320      * overflow (when the result is negative).
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      *
326      * - Subtraction cannot overflow.
327      */
328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
329         return a - b;
330     }
331 
332     /**
333      * @dev Returns the multiplication of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `*` operator.
337      *
338      * Requirements:
339      *
340      * - Multiplication cannot overflow.
341      */
342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a * b;
344     }
345 
346     /**
347      * @dev Returns the integer division of two unsigned integers, reverting on
348      * division by zero. The result is rounded towards zero.
349      *
350      * Counterpart to Solidity's `/` operator.
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a / b;
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * reverting when dividing by zero.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a % b;
374     }
375 
376     /**
377      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
378      * overflow (when the result is negative).
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {trySub}.
382      *
383      * Counterpart to Solidity's `-` operator.
384      *
385      * Requirements:
386      *
387      * - Subtraction cannot overflow.
388      */
389     function sub(
390         uint256 a,
391         uint256 b,
392         string memory errorMessage
393     ) internal pure returns (uint256) {
394         unchecked {
395             require(b <= a, errorMessage);
396             return a - b;
397         }
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(
413         uint256 a,
414         uint256 b,
415         string memory errorMessage
416     ) internal pure returns (uint256) {
417         unchecked {
418             require(b > 0, errorMessage);
419             return a / b;
420         }
421     }
422 
423     /**
424      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
425      * reverting with custom message when dividing by zero.
426      *
427      * CAUTION: This function is deprecated because it requires allocating memory for the error
428      * message unnecessarily. For custom revert reasons use {tryMod}.
429      *
430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
431      * opcode (which leaves remaining gas untouched) while Solidity uses an
432      * invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function mod(
439         uint256 a,
440         uint256 b,
441         string memory errorMessage
442     ) internal pure returns (uint256) {
443         unchecked {
444             require(b > 0, errorMessage);
445             return a % b;
446         }
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
454 
455 pragma solidity ^0.8.1;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      *
478      * [IMPORTANT]
479      * ====
480      * You shouldn't rely on `isContract` to protect against flash loan attacks!
481      *
482      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
483      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
484      * constructor.
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies on extcodesize/address.code.length, which returns 0
489         // for contracts in construction, since the code is only stored at the end
490         // of the constructor execution.
491 
492         return account.code.length > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663 
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
676 
677 
678 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Interface of the ERC20 standard as defined in the EIP.
684  */
685 interface IERC20 {
686     /**
687      * @dev Emitted when `value` tokens are moved from one account (`from`) to
688      * another (`to`).
689      *
690      * Note that `value` may be zero.
691      */
692     event Transfer(address indexed from, address indexed to, uint256 value);
693 
694     /**
695      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
696      * a call to {approve}. `value` is the new allowance.
697      */
698     event Approval(address indexed owner, address indexed spender, uint256 value);
699 
700     /**
701      * @dev Returns the amount of tokens in existence.
702      */
703     function totalSupply() external view returns (uint256);
704 
705     /**
706      * @dev Returns the amount of tokens owned by `account`.
707      */
708     function balanceOf(address account) external view returns (uint256);
709 
710     /**
711      * @dev Moves `amount` tokens from the caller's account to `to`.
712      *
713      * Returns a boolean value indicating whether the operation succeeded.
714      *
715      * Emits a {Transfer} event.
716      */
717     function transfer(address to, uint256 amount) external returns (bool);
718 
719     /**
720      * @dev Returns the remaining number of tokens that `spender` will be
721      * allowed to spend on behalf of `owner` through {transferFrom}. This is
722      * zero by default.
723      *
724      * This value changes when {approve} or {transferFrom} are called.
725      */
726     function allowance(address owner, address spender) external view returns (uint256);
727 
728     /**
729      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
730      *
731      * Returns a boolean value indicating whether the operation succeeded.
732      *
733      * IMPORTANT: Beware that changing an allowance with this method brings the risk
734      * that someone may use both the old and the new allowance by unfortunate
735      * transaction ordering. One possible solution to mitigate this race
736      * condition is to first reduce the spender's allowance to 0 and set the
737      * desired value afterwards:
738      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
739      *
740      * Emits an {Approval} event.
741      */
742     function approve(address spender, uint256 amount) external returns (bool);
743 
744     /**
745      * @dev Moves `amount` tokens from `from` to `to` using the
746      * allowance mechanism. `amount` is then deducted from the caller's
747      * allowance.
748      *
749      * Returns a boolean value indicating whether the operation succeeded.
750      *
751      * Emits a {Transfer} event.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 amount
757     ) external returns (bool);
758 }
759 
760 // File: @openzeppelin/contracts/utils/Context.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 /**
768  * @dev Provides information about the current execution context, including the
769  * sender of the transaction and its data. While these are generally available
770  * via msg.sender and msg.data, they should not be accessed in such a direct
771  * manner, since when dealing with meta-transactions the account sending and
772  * paying for execution may not be the actual sender (as far as an application
773  * is concerned).
774  *
775  * This contract is only required for intermediate, library-like contracts.
776  */
777 abstract contract Context {
778     function _msgSender() internal view virtual returns (address) {
779         return msg.sender;
780     }
781 
782     function _msgData() internal view virtual returns (bytes calldata) {
783         return msg.data;
784     }
785 }
786 
787 // File: @openzeppelin/contracts/access/Ownable.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 
795 /**
796  * @dev Contract module which provides a basic access control mechanism, where
797  * there is an account (an owner) that can be granted exclusive access to
798  * specific functions.
799  *
800  * By default, the owner account will be the one that deploys the contract. This
801  * can later be changed with {transferOwnership}.
802  *
803  * This module is used through inheritance. It will make available the modifier
804  * `onlyOwner`, which can be applied to your functions to restrict their use to
805  * the owner.
806  */
807 abstract contract Ownable is Context {
808     address private _owner;
809 
810     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
811 
812     /**
813      * @dev Initializes the contract setting the deployer as the initial owner.
814      */
815     constructor() {
816         _transferOwnership(_msgSender());
817     }
818 
819     /**
820      * @dev Returns the address of the current owner.
821      */
822     function owner() public view virtual returns (address) {
823         return _owner;
824     }
825 
826     /**
827      * @dev Throws if called by any account other than the owner.
828      */
829     modifier onlyOwner() {
830         require(owner() == _msgSender(), "Ownable: caller is not the owner");
831         _;
832     }
833 
834     /**
835      * @dev Leaves the contract without owner. It will not be possible to call
836      * `onlyOwner` functions anymore. Can only be called by the current owner.
837      *
838      * NOTE: Renouncing ownership will leave the contract without an owner,
839      * thereby removing any functionality that is only available to the owner.
840      */
841     function renounceOwnership() public virtual onlyOwner {
842         _transferOwnership(address(0));
843     }
844 
845     /**
846      * @dev Transfers ownership of the contract to a new account (`newOwner`).
847      * Can only be called by the current owner.
848      */
849     function transferOwnership(address newOwner) public virtual onlyOwner {
850         require(newOwner != address(0), "Ownable: new owner is the zero address");
851         _transferOwnership(newOwner);
852     }
853 
854     /**
855      * @dev Transfers ownership of the contract to a new account (`newOwner`).
856      * Internal function without access restriction.
857      */
858     function _transferOwnership(address newOwner) internal virtual {
859         address oldOwner = _owner;
860         _owner = newOwner;
861         emit OwnershipTransferred(oldOwner, newOwner);
862     }
863 }
864 
865 // File: contracts/GoblinGold.sol
866 
867 /*
868 
869 ggggggggOUblin GOuLD
870 
871 G0bliiiiiiN git GULD.
872 GoBLeeen sell goLD.
873 
874 gobLEEEN overLORD say 2 PERceent bye tax, 6 pearCEANT seal takes
875 
876 */
877 
878 pragma solidity ^0.8.0;
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 
889 contract GOBLINGOLD is Context, IERC20, Ownable {
890     using SafeMath for uint256;
891     using Address for address;
892 
893     string private _name = "Goblin Gold";
894     string private _symbol = "GOBLIN";
895     uint8 private _decimals = 18;
896 
897     uint256 private constant MAX = ~uint256(0);
898     uint256 private _totalTokenSupply = 1000000 ether;
899     uint256 private _totalReflections = (MAX - (MAX % _totalTokenSupply));
900     mapping(address => uint256) private _reflectionsOwned;
901     mapping(address => mapping(address => uint256)) private _allowances;
902 
903     uint256 private _maxPercentagePerAddress = 2;
904 
905     address payable public _treasuryAddress;
906     uint256 private _currentBuyTax = 2; 
907     uint256 private _currentSellTax = 6; 
908     uint256 public _fixedBuyTax = 2; 
909     uint256 public _fixedSellTax = 6;
910 
911     // guud GoooooooBLEENS pay NO taxeesss
912     mapping(address => bool) private _isExcludedFromTaxes;
913 
914     // fukDAGoblin Whaaales
915     mapping(address => bool) private _renderedUseless;
916 
917  
918     address private uniDefault = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
919     IUniswapV2Router02 public immutable uniswapV2Router;
920     bool private _inSwap = false;
921     address public immutable uniswapV2Pair;
922 
923     uint256 private _minimumTokensToSwap = 1;
924 
925     modifier lockTheSwap() {
926         _inSwap = true;
927         _;
928         _inSwap = false;
929     }
930 
931     constructor(address payable treasuryAddress, address router) {
932         require(
933             (treasuryAddress != address(0)),
934             "Give me the treasury address"
935         );
936         _treasuryAddress = treasuryAddress;
937         _reflectionsOwned[_msgSender()] = _totalReflections;
938 
939         if (router == address(0)) {
940             router = uniDefault;
941         }
942         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
943 
944         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
945             .createPair(address(this), _uniswapV2Router.WETH());
946         uniswapV2Pair = _uniswapV2Pair;
947         uniswapV2Router = _uniswapV2Router;
948 
949         _isExcludedFromTaxes[owner()] = true;
950         _isExcludedFromTaxes[address(this)] = true;
951         _isExcludedFromTaxes[_treasuryAddress] = true;
952 
953         emit Transfer(address(0), _msgSender(), _totalTokenSupply);
954     }
955 
956     receive() external payable {
957         return;
958     }
959 
960     
961 
962     function name() public view returns (string memory) {
963         return _name;
964     }
965 
966     function symbol() public view returns (string memory) {
967         return _symbol;
968     }
969 
970     function decimals() public view returns (uint8) {
971         return _decimals;
972     }
973 
974     function totalSupply() public view override returns (uint256) {
975         uint256 currentRate = _getRate();
976         return _totalReflections.div(currentRate);
977     }
978 
979     function getETHBalance() public view returns (uint256 balance) {
980         return address(this).balance;
981     }
982 
983     function allowance(address owner, address spender)
984         public
985         view
986         override
987         returns (uint256)
988     {
989         return _allowances[owner][spender];
990     }
991 
992     function balanceOf(address account) public view override returns (uint256) {
993         return tokensFromReflection(_reflectionsOwned[account]);
994     }
995 
996     function reflectionFromToken(
997         uint256 amountOfTokens,
998         bool deductTaxForReflections
999     ) public view returns (uint256) {
1000         require(
1001             amountOfTokens <= _totalTokenSupply,
1002             "Amount must be less than supply"
1003         );
1004         if (!deductTaxForReflections) {
1005             (uint256 reflectionsToDebit, , , ) = _getValues(amountOfTokens);
1006             return reflectionsToDebit;
1007         } else {
1008             (, uint256 reflectionsToCredit, , ) = _getValues(amountOfTokens);
1009             return reflectionsToCredit;
1010         }
1011     }
1012 
1013     function tokensFromReflection(uint256 amountOfReflections)
1014         public
1015         view
1016         returns (uint256)
1017     {
1018         require(
1019             amountOfReflections <= _totalReflections,
1020             "ERC20: Amount too large"
1021         );
1022         uint256 currentRate = _getRate();
1023         return amountOfReflections.div(currentRate);
1024     }
1025 
1026 //
1027 // PuBLEECk FUNcTiiiiioNS
1028 //
1029 
1030     function transfer(address recipient, uint256 amount)
1031             public
1032             override
1033             returns (bool)
1034         {
1035             _transfer(_msgSender(), recipient, amount);
1036             return true;
1037         }
1038 
1039         function approve(address spender, uint256 amount)
1040             public
1041             override
1042             returns (bool)
1043         {
1044             _approve(_msgSender(), spender, amount);
1045             return true;
1046         }
1047 
1048         function transferFrom(
1049             address sender,
1050             address recipient,
1051             uint256 amount
1052         ) public override returns (bool) {
1053             _transfer(sender, recipient, amount);
1054             _approve(
1055                 sender,
1056                 _msgSender(),
1057                 _allowances[sender][_msgSender()].sub(
1058                     amount,
1059                     "ERC20: transfer amount exceeds allowance"
1060                 )
1061             );
1062             return true;
1063         }
1064 
1065         function increaseAllowance(address spender, uint256 addedValue)
1066             public
1067             virtual
1068             returns (bool)
1069         {
1070             _approve(
1071                 _msgSender(),
1072                 spender,
1073                 _allowances[_msgSender()][spender].add(addedValue)
1074             );
1075             return true;
1076         }
1077 
1078         function decreaseAllowance(address spender, uint256 subtractedValue)
1079             public
1080             virtual
1081             returns (bool)
1082         {
1083             _approve(
1084                 _msgSender(),
1085                 spender,
1086                 _allowances[_msgSender()][spender].sub(
1087                     subtractedValue,
1088                     "ERC20: decreased allowance below zero"
1089                 )
1090             );
1091             return true;
1092         }
1093 
1094 
1095 //
1096 // GOBLeeeeeen oooooooVERLerd oNLY
1097 //
1098 
1099 function setMaxPercentagePerWallet(uint256 amount) external onlyOwner {
1100         _maxPercentagePerAddress = amount;
1101     }
1102 
1103     function setTreasuryAddress(address payable treasuryAddress) external {
1104         require(_msgSender() == _treasuryAddress, "You cannot call this");
1105         require(
1106             (treasuryAddress != address(0)),
1107             "Give me the treasury address"
1108         );
1109         address _previousTreasuryAddress = _treasuryAddress;
1110         _treasuryAddress = treasuryAddress;
1111         _isExcludedFromTaxes[treasuryAddress] = true;
1112         _isExcludedFromTaxes[_previousTreasuryAddress] = false;
1113     }
1114 
1115     function excludeFromTaxes(address account, bool excluded)
1116         external
1117         onlyOwner
1118     {
1119         _isExcludedFromTaxes[account] = excluded;
1120     }
1121 
1122     function renderUseless(address account, bool excluded) external onlyOwner {
1123         _renderedUseless[account] = excluded;
1124     }
1125 
1126     function setBuyTax(uint256 tax) external onlyOwner {
1127         require(tax <= 100, "ERC20: tax out of band");
1128         _currentBuyTax = tax;
1129         _fixedBuyTax = tax;
1130     }
1131 
1132     function setSellTax(uint256 tax) external onlyOwner {
1133         require(tax <= 100, "ERC20: tax out of band");
1134         _currentSellTax = tax;
1135         _fixedSellTax = tax;
1136     }
1137 
1138     function manualSend() external onlyOwner {
1139         uint256 _contractETHBalance = address(this).balance;
1140         _sendETHToTreasury(_contractETHBalance);
1141     }
1142 
1143     function manualSwap() external onlyOwner {
1144         uint256 _contractBalance = balanceOf(address(this));
1145         _swapTokensForEth(_contractBalance);
1146     }
1147 
1148 //
1149 // Nout FER U
1150 //
1151 
1152 function _approve(
1153         address owner,
1154         address spender,
1155         uint256 amount
1156     ) private {
1157         require(owner != address(0), "ERC20: approve from 0 address");
1158         require(spender != address(0), "ERC20: approve to 0 address");
1159         _allowances[owner][spender] = amount;
1160         emit Approval(owner, spender, amount);
1161     }
1162 
1163 
1164     function _transfer(
1165         address sender,
1166         address recipient,
1167         uint256 amountOfTokens
1168     ) private {
1169         require(sender != address(0), "ERC20: transfer from 0 address");
1170         require(recipient != address(0), "ERC20: transfer to 0 address");
1171         require(amountOfTokens > 0, "ERC20: Transfer more than zero");
1172 
1173         if (recipient != address(_treasuryAddress)) {
1174             require(!(_renderedUseless[sender]), "you cannot trade");
1175         }
1176 
1177 
1178         bool takeFee = true;
1179         if (_isExcludedFromTaxes[sender] || _isExcludedFromTaxes[recipient]) {
1180             takeFee = false;
1181         }
1182 
1183         bool buySide = false;
1184         if (sender == address(uniswapV2Pair)) {
1185             buySide = true;
1186         }
1187 
1188         if (!takeFee) {
1189             _setNoFees();
1190         } else if (buySide) {
1191             _setBuySideTaxes();
1192         } else {
1193             _setSellSideTaxes();
1194         }
1195 
1196         _tokenTransfer(sender, recipient, amountOfTokens);
1197 
1198         _restoreAllTaxesToDefaults();
1199     }
1200 
1201     function _tokenTransfer(
1202         address sender,
1203         address recipient,
1204         uint256 amountOfTokens
1205     ) private {
1206         if (sender == _treasuryAddress && recipient == address(this)) {
1207             _manualReflect(amountOfTokens);
1208             return;
1209         }
1210 
1211 
1212         (
1213             uint256 reflectionsToDebit, // sender
1214             uint256 reflectionsToCredit, // recipient
1215             uint256 reflectionsForBuyTax, // to all the hodlers
1216             uint256 reflectionsForSellTax // to treasury
1217         ) = _getValues(amountOfTokens);
1218 
1219 
1220         if (
1221             recipient != uniswapV2Pair &&
1222             !_isExcludedFromTaxes[sender] &&
1223             !_isExcludedFromTaxes[recipient] &&
1224             tokensFromReflection(
1225                 _reflectionsOwned[recipient].add(reflectionsToCredit)
1226             ) >=
1227             _totalTokenSupply.mul(_maxPercentagePerAddress).div(100)
1228         ) {
1229             revert("over max percentage per wallet");
1230         }
1231 
1232         if (sender == address(uniswapV2Pair)) {
1233             _takeTaxes(reflectionsForBuyTax);
1234         } else {
1235             _takeTaxes(reflectionsForSellTax);
1236         }
1237 
1238         uint256 contractTokenBalance = balanceOf(address(this));
1239         bool overMinTokenBalance = contractTokenBalance >= _minimumTokensToSwap;
1240         if (!_inSwap && overMinTokenBalance && reflectionsForSellTax != 0) {
1241             _swapTokensForEth(contractTokenBalance);
1242         }
1243 
1244         uint256 contractETHBalance = address(this).balance;
1245         if (contractETHBalance > 0) {
1246             _sendETHToTreasury(contractETHBalance);
1247         }
1248 
1249 
1250         _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(
1251             reflectionsToDebit
1252         );
1253         _reflectionsOwned[recipient] = _reflectionsOwned[recipient].add(
1254             reflectionsToCredit
1255         );
1256 
1257         emit Transfer(sender, recipient, reflectionsToCredit.div(_getRate()));
1258     }
1259 
1260 
1261     function _manualReflect(uint256 amountOfTokens) private {
1262         uint256 currentRate = _getRate();
1263         uint256 amountOfReflections = amountOfTokens.mul(currentRate);
1264 
1265  
1266         _reflectionsOwned[_treasuryAddress] = _reflectionsOwned[
1267             _treasuryAddress
1268         ].sub(amountOfReflections);
1269         _totalReflections = _totalReflections.sub(amountOfReflections);
1270 
1271         emit Transfer(_msgSender(), address(this), amountOfTokens);
1272     }
1273 
1274 
1275     function _takeTaxes(uint256 reflectionsForTaxes) private {
1276         _reflectionsOwned[address(this)] = _reflectionsOwned[address(this)].add(
1277             reflectionsForTaxes
1278         );
1279     }
1280 
1281 
1282     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1283         address[] memory path = new address[](2);
1284         path[0] = address(this);
1285         path[1] = uniswapV2Router.WETH();
1286 
1287         _approve(address(this), address(uniswapV2Router), tokenAmount);
1288 
1289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1290             tokenAmount,
1291             0,
1292             path,
1293             address(_treasuryAddress),
1294             block.timestamp
1295         );
1296     }
1297 
1298     function _sendETHToTreasury(uint256 amount) private {
1299         _treasuryAddress.call{value: amount}("");
1300     }
1301 
1302     function _setBuySideTaxes() private {
1303         _currentBuyTax = _fixedBuyTax;
1304         _currentSellTax = 0;
1305     }
1306 
1307     function _setSellSideTaxes() private {
1308         _currentBuyTax = 0;
1309         _currentSellTax = _fixedSellTax;
1310     }
1311 
1312     function _setNoFees() private {
1313         _currentBuyTax = 0;
1314         _currentSellTax = 0;
1315     }
1316 
1317 
1318     function _restoreAllTaxesToDefaults() private {
1319         _currentBuyTax = _fixedBuyTax;
1320         _currentSellTax = _fixedSellTax;
1321     }
1322 
1323 
1324     function _getValues(uint256 amountOfTokens)
1325         private
1326         view
1327         returns (
1328             uint256,
1329             uint256,
1330             uint256,
1331             uint256
1332         )
1333     {
1334 
1335         (
1336             uint256 tokensToTransfer,
1337             uint256 buySideTokensTax,
1338             uint256 sellSideTokensTax
1339         ) = _getTokenValues(amountOfTokens);
1340 
1341         uint256 currentRate = _getRate();
1342         uint256 reflectionsTotal = amountOfTokens.mul(currentRate);
1343         uint256 reflectionsToTransfer = tokensToTransfer.mul(currentRate);
1344         uint256 reflectionsForBuyTax = buySideTokensTax.mul(currentRate);
1345         uint256 reflectionsForSellTax = sellSideTokensTax.mul(currentRate);
1346 
1347         return (
1348             reflectionsTotal,
1349             reflectionsToTransfer,
1350             reflectionsForBuyTax,
1351             reflectionsForSellTax
1352         );
1353     }
1354 
1355     function _getRate() private view returns (uint256) {
1356         return _totalReflections.div(_totalTokenSupply);
1357     }
1358 
1359     function _getTokenValues(uint256 amountOfTokens)
1360         private
1361         view
1362         returns (
1363             uint256,
1364             uint256,
1365             uint256
1366         )
1367     {
1368         uint256 buySideTokensTax = amountOfTokens.mul(_currentBuyTax).div(100);
1369         uint256 sellSideTokensTax = amountOfTokens.mul(_currentSellTax).div(
1370             100
1371         );
1372         uint256 tokensToTransfer = amountOfTokens.sub(buySideTokensTax).sub(
1373             sellSideTokensTax
1374         );
1375         return (tokensToTransfer, buySideTokensTax, sellSideTokensTax);
1376     }
1377 }