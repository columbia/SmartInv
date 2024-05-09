1 /*
2     Token Name : Vibe to Earn 
3     SYMBOL : VIBE
4     Vibe uses Postmint’s natively integrated refer-to-earn system to fuel its growth.
5     Buy/sell/transfer Tax 5/5/5 
6     Treasury : 1% 
7     Liquidity Pool : 0.5%
8     Referral Rewards : 3%
9     Postmint : 0.5%
10     website : https://vibetoearn.com
11     twitter : https://twitter.com/vibetoearn420
12     Telegram https://t.me/Vibe2Earn
13 */
14 // SPDX-License-Identifier: MIT
15 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
16 
17 
18 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
19 
20 // pragma solidity >=0.6.2;
21 
22 interface IUniswapV2Router01 {
23     function factory() external pure returns (address);
24 
25     function WETH() external pure returns (address);
26 
27     function addLiquidity(
28         address tokenA,
29         address tokenB,
30         uint256 amountADesired,
31         uint256 amountBDesired,
32         uint256 amountAMin,
33         uint256 amountBMin,
34         address to,
35         uint256 deadline
36     )
37         external
38         returns (
39             uint256 amountA,
40             uint256 amountB,
41             uint256 liquidity
42         );
43 
44     function addLiquidityETH(
45         address token,
46         uint256 amountTokenDesired,
47         uint256 amountTokenMin,
48         uint256 amountETHMin,
49         address to,
50         uint256 deadline
51     )
52         external
53         payable
54         returns (
55             uint256 amountToken,
56             uint256 amountETH,
57             uint256 liquidity
58         );
59 
60     function removeLiquidity(
61         address tokenA,
62         address tokenB,
63         uint256 liquidity,
64         uint256 amountAMin,
65         uint256 amountBMin,
66         address to,
67         uint256 deadline
68     ) external returns (uint256 amountA, uint256 amountB);
69 
70     function removeLiquidityETH(
71         address token,
72         uint256 liquidity,
73         uint256 amountTokenMin,
74         uint256 amountETHMin,
75         address to,
76         uint256 deadline
77     ) external returns (uint256 amountToken, uint256 amountETH);
78 
79     function removeLiquidityWithPermit(
80         address tokenA,
81         address tokenB,
82         uint256 liquidity,
83         uint256 amountAMin,
84         uint256 amountBMin,
85         address to,
86         uint256 deadline,
87         bool approveMax,
88         uint8 v,
89         bytes32 r,
90         bytes32 s
91     ) external returns (uint256 amountA, uint256 amountB);
92 
93     function removeLiquidityETHWithPermit(
94         address token,
95         uint256 liquidity,
96         uint256 amountTokenMin,
97         uint256 amountETHMin,
98         address to,
99         uint256 deadline,
100         bool approveMax,
101         uint8 v,
102         bytes32 r,
103         bytes32 s
104     ) external returns (uint256 amountToken, uint256 amountETH);
105 
106     function swapExactTokensForTokens(
107         uint256 amountIn,
108         uint256 amountOutMin,
109         address[] calldata path,
110         address to,
111         uint256 deadline
112     ) external returns (uint256[] memory amounts);
113 
114     function swapTokensForExactTokens(
115         uint256 amountOut,
116         uint256 amountInMax,
117         address[] calldata path,
118         address to,
119         uint256 deadline
120     ) external returns (uint256[] memory amounts);
121 
122     function swapExactETHForTokens(
123         uint256 amountOutMin,
124         address[] calldata path,
125         address to,
126         uint256 deadline
127     ) external payable returns (uint256[] memory amounts);
128 
129     function swapTokensForExactETH(
130         uint256 amountOut,
131         uint256 amountInMax,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external returns (uint256[] memory amounts);
136 
137     function swapExactTokensForETH(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external returns (uint256[] memory amounts);
144 
145     function swapETHForExactTokens(
146         uint256 amountOut,
147         address[] calldata path,
148         address to,
149         uint256 deadline
150     ) external payable returns (uint256[] memory amounts);
151 
152     function quote(
153         uint256 amountA,
154         uint256 reserveA,
155         uint256 reserveB
156     ) external pure returns (uint256 amountB);
157 
158     function getAmountOut(
159         uint256 amountIn,
160         uint256 reserveIn,
161         uint256 reserveOut
162     ) external pure returns (uint256 amountOut);
163 
164     function getAmountIn(
165         uint256 amountOut,
166         uint256 reserveIn,
167         uint256 reserveOut
168     ) external pure returns (uint256 amountIn);
169 
170     function getAmountsOut(uint256 amountIn, address[] calldata path)
171         external
172         view
173         returns (uint256[] memory amounts);
174 
175     function getAmountsIn(uint256 amountOut, address[] calldata path)
176         external
177         view
178         returns (uint256[] memory amounts);
179 }
180 
181 interface IUniswapV2Router02 is IUniswapV2Router01 {
182     function removeLiquidityETHSupportingFeeOnTransferTokens(
183         address token,
184         uint256 liquidity,
185         uint256 amountTokenMin,
186         uint256 amountETHMin,
187         address to,
188         uint256 deadline
189     ) external returns (uint256 amountETH);
190 
191     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
192         address token,
193         uint256 liquidity,
194         uint256 amountTokenMin,
195         uint256 amountETHMin,
196         address to,
197         uint256 deadline,
198         bool approveMax,
199         uint8 v,
200         bytes32 r,
201         bytes32 s
202     ) external returns (uint256 amountETH);
203 
204     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
205         uint256 amountIn,
206         uint256 amountOutMin,
207         address[] calldata path,
208         address to,
209         uint256 deadline
210     ) external;
211 
212     function swapExactETHForTokensSupportingFeeOnTransferTokens(
213         uint256 amountOutMin,
214         address[] calldata path,
215         address to,
216         uint256 deadline
217     ) external payable;
218 
219     function swapExactTokensForETHSupportingFeeOnTransferTokens(
220         uint256 amountIn,
221         uint256 amountOutMin,
222         address[] calldata path,
223         address to,
224         uint256 deadline
225     ) external;
226 }
227 
228 
229 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
230 
231 // pragma solidity >=0.5.0;
232 
233 interface IUniswapV2Factory {
234     event PairCreated(
235         address indexed token0,
236         address indexed token1,
237         address pair,
238         uint256
239     );
240 
241     function feeTo() external view returns (address);
242 
243     function feeToSetter() external view returns (address);
244 
245     function getPair(address tokenA, address tokenB)
246         external
247         view
248         returns (address pair);
249 
250     function allPairs(uint256) external view returns (address pair);
251 
252     function allPairsLength() external view returns (uint256);
253 
254     function createPair(address tokenA, address tokenB)
255         external
256         returns (address pair);
257 
258     function setFeeTo(address) external;
259 
260     function setFeeToSetter(address) external;
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
267 
268 pragma solidity ^0.8.1;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      *
291      * [IMPORTANT]
292      * ====
293      * You shouldn't rely on `isContract` to protect against flash loan attacks!
294      *
295      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
296      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
297      * constructor.
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize/address.code.length, which returns 0
302         // for contracts in construction, since the code is only stored at the end
303         // of the constructor execution.
304 
305         return account.code.length > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
455      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
456      *
457      * _Available since v4.8._
458      */
459     function verifyCallResultFromTarget(
460         address target,
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         if (success) {
466             if (returndata.length == 0) {
467                 // only check isContract if the call was successful and the return data is empty
468                 // otherwise we already know that it was a contract
469                 require(isContract(target), "Address: call to non-contract");
470             }
471             return returndata;
472         } else {
473             _revert(returndata, errorMessage);
474         }
475     }
476 
477     /**
478      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
479      * revert reason or using the provided one.
480      *
481      * _Available since v4.3._
482      */
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             _revert(returndata, errorMessage);
492         }
493     }
494 
495     function _revert(bytes memory returndata, string memory errorMessage) private pure {
496         // Look for revert reason and bubble it up if present
497         if (returndata.length > 0) {
498             // The easiest way to bubble the revert reason is using memory via assembly
499             /// @solidity memory-safe-assembly
500             assembly {
501                 let returndata_size := mload(returndata)
502                 revert(add(32, returndata), returndata_size)
503             }
504         } else {
505             revert(errorMessage);
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 // CAUTION
518 // This version of SafeMath should only be used with Solidity 0.8 or later,
519 // because it relies on the compiler's built in overflow checks.
520 
521 /**
522  * @dev Wrappers over Solidity's arithmetic operations.
523  *
524  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
525  * now has built in overflow checking.
526  */
527 library SafeMath {
528     /**
529      * @dev Returns the addition of two unsigned integers, with an overflow flag.
530      *
531      * _Available since v3.4._
532      */
533     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
534         unchecked {
535             uint256 c = a + b;
536             if (c < a) return (false, 0);
537             return (true, c);
538         }
539     }
540 
541     /**
542      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
543      *
544      * _Available since v3.4._
545      */
546     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
547         unchecked {
548             if (b > a) return (false, 0);
549             return (true, a - b);
550         }
551     }
552 
553     /**
554      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
555      *
556      * _Available since v3.4._
557      */
558     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
561             // benefit is lost if 'b' is also tested.
562             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
563             if (a == 0) return (true, 0);
564             uint256 c = a * b;
565             if (c / a != b) return (false, 0);
566             return (true, c);
567         }
568     }
569 
570     /**
571      * @dev Returns the division of two unsigned integers, with a division by zero flag.
572      *
573      * _Available since v3.4._
574      */
575     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
576         unchecked {
577             if (b == 0) return (false, 0);
578             return (true, a / b);
579         }
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
584      *
585      * _Available since v3.4._
586      */
587     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
588         unchecked {
589             if (b == 0) return (false, 0);
590             return (true, a % b);
591         }
592     }
593 
594     /**
595      * @dev Returns the addition of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `+` operator.
599      *
600      * Requirements:
601      *
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         return a + b;
606     }
607 
608     /**
609      * @dev Returns the subtraction of two unsigned integers, reverting on
610      * overflow (when the result is negative).
611      *
612      * Counterpart to Solidity's `-` operator.
613      *
614      * Requirements:
615      *
616      * - Subtraction cannot overflow.
617      */
618     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a - b;
620     }
621 
622     /**
623      * @dev Returns the multiplication of two unsigned integers, reverting on
624      * overflow.
625      *
626      * Counterpart to Solidity's `*` operator.
627      *
628      * Requirements:
629      *
630      * - Multiplication cannot overflow.
631      */
632     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a * b;
634     }
635 
636     /**
637      * @dev Returns the integer division of two unsigned integers, reverting on
638      * division by zero. The result is rounded towards zero.
639      *
640      * Counterpart to Solidity's `/` operator.
641      *
642      * Requirements:
643      *
644      * - The divisor cannot be zero.
645      */
646     function div(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a / b;
648     }
649 
650     /**
651      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
652      * reverting when dividing by zero.
653      *
654      * Counterpart to Solidity's `%` operator. This function uses a `revert`
655      * opcode (which leaves remaining gas untouched) while Solidity uses an
656      * invalid opcode to revert (consuming all remaining gas).
657      *
658      * Requirements:
659      *
660      * - The divisor cannot be zero.
661      */
662     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a % b;
664     }
665 
666     /**
667      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
668      * overflow (when the result is negative).
669      *
670      * CAUTION: This function is deprecated because it requires allocating memory for the error
671      * message unnecessarily. For custom revert reasons use {trySub}.
672      *
673      * Counterpart to Solidity's `-` operator.
674      *
675      * Requirements:
676      *
677      * - Subtraction cannot overflow.
678      */
679     function sub(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b <= a, errorMessage);
686             return a - b;
687         }
688     }
689 
690     /**
691      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
692      * division by zero. The result is rounded towards zero.
693      *
694      * Counterpart to Solidity's `/` operator. Note: this function uses a
695      * `revert` opcode (which leaves remaining gas untouched) while Solidity
696      * uses an invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function div(
703         uint256 a,
704         uint256 b,
705         string memory errorMessage
706     ) internal pure returns (uint256) {
707         unchecked {
708             require(b > 0, errorMessage);
709             return a / b;
710         }
711     }
712 
713     /**
714      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
715      * reverting with custom message when dividing by zero.
716      *
717      * CAUTION: This function is deprecated because it requires allocating memory for the error
718      * message unnecessarily. For custom revert reasons use {tryMod}.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(
729         uint256 a,
730         uint256 b,
731         string memory errorMessage
732     ) internal pure returns (uint256) {
733         unchecked {
734             require(b > 0, errorMessage);
735             return a % b;
736         }
737     }
738 }
739 
740 // File: @openzeppelin/contracts/utils/Context.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 /**
748  * @dev Provides information about the current execution context, including the
749  * sender of the transaction and its data. While these are generally available
750  * via msg.sender and msg.data, they should not be accessed in such a direct
751  * manner, since when dealing with meta-transactions the account sending and
752  * paying for execution may not be the actual sender (as far as an application
753  * is concerned).
754  *
755  * This contract is only required for intermediate, library-like contracts.
756  */
757 abstract contract Context {
758     function _msgSender() internal view virtual returns (address) {
759         return msg.sender;
760     }
761 
762     function _msgData() internal view virtual returns (bytes calldata) {
763         return msg.data;
764     }
765 }
766 
767 // File: @openzeppelin/contracts/access/Ownable.sol
768 
769 
770 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @dev Contract module which provides a basic access control mechanism, where
777  * there is an account (an owner) that can be granted exclusive access to
778  * specific functions.
779  *
780  * By default, the owner account will be the one that deploys the contract. This
781  * can later be changed with {transferOwnership}.
782  *
783  * This module is used through inheritance. It will make available the modifier
784  * `onlyOwner`, which can be applied to your functions to restrict their use to
785  * the owner.
786  */
787 abstract contract Ownable is Context {
788     address private _owner;
789 
790     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
791 
792     /**
793      * @dev Initializes the contract setting the deployer as the initial owner.
794      */
795     constructor() {
796         _transferOwnership(_msgSender());
797     }
798 
799     /**
800      * @dev Throws if called by any account other than the owner.
801      */
802     modifier onlyOwner() {
803         _checkOwner();
804         _;
805     }
806 
807     /**
808      * @dev Returns the address of the current owner.
809      */
810     function owner() public view virtual returns (address) {
811         return _owner;
812     }
813 
814     /**
815      * @dev Throws if the sender is not the owner.
816      */
817     function _checkOwner() internal view virtual {
818         require(owner() == _msgSender(), "Ownable: caller is not the owner");
819     }
820 
821     /**
822      * @dev Leaves the contract without owner. It will not be possible to call
823      * `onlyOwner` functions anymore. Can only be called by the current owner.
824      *
825      * NOTE: Renouncing ownership will leave the contract without an owner,
826      * thereby removing any functionality that is only available to the owner.
827      */
828     function renounceOwnership() public virtual onlyOwner {
829         _transferOwnership(address(0));
830     }
831 
832     /**
833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
834      * Can only be called by the current owner.
835      */
836     function transferOwnership(address newOwner) public virtual onlyOwner {
837         require(newOwner != address(0), "Ownable: new owner is the zero address");
838         _transferOwnership(newOwner);
839     }
840 
841     /**
842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
843      * Internal function without access restriction.
844      */
845     function _transferOwnership(address newOwner) internal virtual {
846         address oldOwner = _owner;
847         _owner = newOwner;
848         emit OwnershipTransferred(oldOwner, newOwner);
849     }
850 }
851 
852 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
853 
854 
855 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 /**
860  * @dev Interface of the ERC20 standard as defined in the EIP.
861  */
862 interface IERC20 {
863     /**
864      * @dev Emitted when `value` tokens are moved from one account (`from`) to
865      * another (`to`).
866      *
867      * Note that `value` may be zero.
868      */
869     event Transfer(address indexed from, address indexed to, uint256 value);
870 
871     /**
872      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
873      * a call to {approve}. `value` is the new allowance.
874      */
875     event Approval(address indexed owner, address indexed spender, uint256 value);
876 
877     /**
878      * @dev Returns the amount of tokens in existence.
879      */
880     function totalSupply() external view returns (uint256);
881 
882     /**
883      * @dev Returns the amount of tokens owned by `account`.
884      */
885     function balanceOf(address account) external view returns (uint256);
886 
887     /**
888      * @dev Moves `amount` tokens from the caller's account to `to`.
889      *
890      * Returns a boolean value indicating whether the operation succeeded.
891      *
892      * Emits a {Transfer} event.
893      */
894     function transfer(address to, uint256 amount) external returns (bool);
895 
896     /**
897      * @dev Returns the remaining number of tokens that `spender` will be
898      * allowed to spend on behalf of `owner` through {transferFrom}. This is
899      * zero by default.
900      *
901      * This value changes when {approve} or {transferFrom} are called.
902      */
903     function allowance(address owner, address spender) external view returns (uint256);
904 
905     /**
906      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
907      *
908      * Returns a boolean value indicating whether the operation succeeded.
909      *
910      * IMPORTANT: Beware that changing an allowance with this method brings the risk
911      * that someone may use both the old and the new allowance by unfortunate
912      * transaction ordering. One possible solution to mitigate this race
913      * condition is to first reduce the spender's allowance to 0 and set the
914      * desired value afterwards:
915      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
916      *
917      * Emits an {Approval} event.
918      */
919     function approve(address spender, uint256 amount) external returns (bool);
920 
921     /**
922      * @dev Moves `amount` tokens from `from` to `to` using the
923      * allowance mechanism. `amount` is then deducted from the caller's
924      * allowance.
925      *
926      * Returns a boolean value indicating whether the operation succeeded.
927      *
928      * Emits a {Transfer} event.
929      */
930     function transferFrom(
931         address from,
932         address to,
933         uint256 amount
934     ) external returns (bool);
935 }
936 
937 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
938 
939 
940 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 
945 /**
946  * @dev Interface for the optional metadata functions from the ERC20 standard.
947  *
948  * _Available since v4.1._
949  */
950 interface IERC20Metadata is IERC20 {
951     /**
952      * @dev Returns the name of the token.
953      */
954     function name() external view returns (string memory);
955 
956     /**
957      * @dev Returns the symbol of the token.
958      */
959     function symbol() external view returns (string memory);
960 
961     /**
962      * @dev Returns the decimals places of the token.
963      */
964     function decimals() external view returns (uint8);
965 }
966 
967 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
968 
969 
970 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
971 
972 pragma solidity ^0.8.0;
973 
974 
975 
976 
977 /**
978  * @dev Implementation of the {IERC20} interface.
979  *
980  * This implementation is agnostic to the way tokens are created. This means
981  * that a supply mechanism has to be added in a derived contract using {_mint}.
982  * For a generic mechanism see {ERC20PresetMinterPauser}.
983  *
984  * TIP: For a detailed writeup see our guide
985  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
986  * to implement supply mechanisms].
987  *
988  * We have followed general OpenZeppelin Contracts guidelines: functions revert
989  * instead returning `false` on failure. This behavior is nonetheless
990  * conventional and does not conflict with the expectations of ERC20
991  * applications.
992  *
993  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
994  * This allows applications to reconstruct the allowance for all accounts just
995  * by listening to said events. Other implementations of the EIP may not emit
996  * these events, as it isn't required by the specification.
997  *
998  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
999  * functions have been added to mitigate the well-known issues around setting
1000  * allowances. See {IERC20-approve}.
1001  */
1002 contract ERC20 is Context, IERC20, IERC20Metadata {
1003     mapping(address => uint256) private _balances;
1004 
1005     mapping(address => mapping(address => uint256)) private _allowances;
1006 
1007     uint256 private _totalSupply;
1008 
1009     string private _name;
1010     string private _symbol;
1011 
1012     /**
1013      * @dev Sets the values for {name} and {symbol}.
1014      *
1015      * The default value of {decimals} is 18. To select a different value for
1016      * {decimals} you should overload it.
1017      *
1018      * All two of these values are immutable: they can only be set once during
1019      * construction.
1020      */
1021     constructor(string memory name_, string memory symbol_) {
1022         _name = name_;
1023         _symbol = symbol_;
1024     }
1025 
1026     /**
1027      * @dev Returns the name of the token.
1028      */
1029     function name() public view virtual override returns (string memory) {
1030         return _name;
1031     }
1032 
1033     /**
1034      * @dev Returns the symbol of the token, usually a shorter version of the
1035      * name.
1036      */
1037     function symbol() public view virtual override returns (string memory) {
1038         return _symbol;
1039     }
1040 
1041     /**
1042      * @dev Returns the number of decimals used to get its user representation.
1043      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1044      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1045      *
1046      * Tokens usually opt for a value of 18, imitating the relationship between
1047      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1048      * overridden;
1049      *
1050      * NOTE: This information is only used for _display_ purposes: it in
1051      * no way affects any of the arithmetic of the contract, including
1052      * {IERC20-balanceOf} and {IERC20-transfer}.
1053      */
1054     function decimals() public view virtual override returns (uint8) {
1055         return 18;
1056     }
1057 
1058     /**
1059      * @dev See {IERC20-totalSupply}.
1060      */
1061     function totalSupply() public view virtual override returns (uint256) {
1062         return _totalSupply;
1063     }
1064 
1065     /**
1066      * @dev See {IERC20-balanceOf}.
1067      */
1068     function balanceOf(address account) public view virtual override returns (uint256) {
1069         return _balances[account];
1070     }
1071 
1072     /**
1073      * @dev See {IERC20-transfer}.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - the caller must have a balance of at least `amount`.
1079      */
1080     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1081         address owner = _msgSender();
1082         _transfer(owner, to, amount);
1083         return true;
1084     }
1085 
1086     /**
1087      * @dev See {IERC20-allowance}.
1088      */
1089     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1090         return _allowances[owner][spender];
1091     }
1092 
1093     /**
1094      * @dev See {IERC20-approve}.
1095      *
1096      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1097      * `transferFrom`. This is semantically equivalent to an infinite approval.
1098      *
1099      * Requirements:
1100      *
1101      * - `spender` cannot be the zero address.
1102      */
1103     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1104         address owner = _msgSender();
1105         _approve(owner, spender, amount);
1106         return true;
1107     }
1108 
1109     /**
1110      * @dev See {IERC20-transferFrom}.
1111      *
1112      * Emits an {Approval} event indicating the updated allowance. This is not
1113      * required by the EIP. See the note at the beginning of {ERC20}.
1114      *
1115      * NOTE: Does not update the allowance if the current allowance
1116      * is the maximum `uint256`.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` and `to` cannot be the zero address.
1121      * - `from` must have a balance of at least `amount`.
1122      * - the caller must have allowance for ``from``'s tokens of at least
1123      * `amount`.
1124      */
1125     function transferFrom(
1126         address from,
1127         address to,
1128         uint256 amount
1129     ) public virtual override returns (bool) {
1130         address spender = _msgSender();
1131         _spendAllowance(from, spender, amount);
1132         _transfer(from, to, amount);
1133         return true;
1134     }
1135 
1136     /**
1137      * @dev Atomically increases the allowance granted to `spender` by the caller.
1138      *
1139      * This is an alternative to {approve} that can be used as a mitigation for
1140      * problems described in {IERC20-approve}.
1141      *
1142      * Emits an {Approval} event indicating the updated allowance.
1143      *
1144      * Requirements:
1145      *
1146      * - `spender` cannot be the zero address.
1147      */
1148     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1149         address owner = _msgSender();
1150         _approve(owner, spender, allowance(owner, spender) + addedValue);
1151         return true;
1152     }
1153 
1154     /**
1155      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1156      *
1157      * This is an alternative to {approve} that can be used as a mitigation for
1158      * problems described in {IERC20-approve}.
1159      *
1160      * Emits an {Approval} event indicating the updated allowance.
1161      *
1162      * Requirements:
1163      *
1164      * - `spender` cannot be the zero address.
1165      * - `spender` must have allowance for the caller of at least
1166      * `subtractedValue`.
1167      */
1168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1169         address owner = _msgSender();
1170         uint256 currentAllowance = allowance(owner, spender);
1171         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1172         unchecked {
1173             _approve(owner, spender, currentAllowance - subtractedValue);
1174         }
1175 
1176         return true;
1177     }
1178 
1179     /**
1180      * @dev Moves `amount` of tokens from `from` to `to`.
1181      *
1182      * This internal function is equivalent to {transfer}, and can be used to
1183      * e.g. implement automatic token fees, slashing mechanisms, etc.
1184      *
1185      * Emits a {Transfer} event.
1186      *
1187      * Requirements:
1188      *
1189      * - `from` cannot be the zero address.
1190      * - `to` cannot be the zero address.
1191      * - `from` must have a balance of at least `amount`.
1192      */
1193     function _transfer(
1194         address from,
1195         address to,
1196         uint256 amount
1197     ) internal virtual {
1198         require(from != address(0), "ERC20: transfer from the zero address");
1199         require(to != address(0), "ERC20: transfer to the zero address");
1200 
1201         _beforeTokenTransfer(from, to, amount);
1202 
1203         uint256 fromBalance = _balances[from];
1204         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1205         unchecked {
1206             _balances[from] = fromBalance - amount;
1207             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1208             // decrementing then incrementing.
1209             _balances[to] += amount;
1210         }
1211 
1212         emit Transfer(from, to, amount);
1213 
1214         _afterTokenTransfer(from, to, amount);
1215     }
1216 
1217     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1218      * the total supply.
1219      *
1220      * Emits a {Transfer} event with `from` set to the zero address.
1221      *
1222      * Requirements:
1223      *
1224      * - `account` cannot be the zero address.
1225      */
1226     function _mint(address account, uint256 amount) internal virtual {
1227         require(account != address(0), "ERC20: mint to the zero address");
1228 
1229         _beforeTokenTransfer(address(0), account, amount);
1230 
1231         _totalSupply += amount;
1232         unchecked {
1233             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1234             _balances[account] += amount;
1235         }
1236         emit Transfer(address(0), account, amount);
1237 
1238         _afterTokenTransfer(address(0), account, amount);
1239     }
1240 
1241     /**
1242      * @dev Destroys `amount` tokens from `account`, reducing the
1243      * total supply.
1244      *
1245      * Emits a {Transfer} event with `to` set to the zero address.
1246      *
1247      * Requirements:
1248      *
1249      * - `account` cannot be the zero address.
1250      * - `account` must have at least `amount` tokens.
1251      */
1252     function _burn(address account, uint256 amount) internal virtual {
1253         require(account != address(0), "ERC20: burn from the zero address");
1254 
1255         _beforeTokenTransfer(account, address(0), amount);
1256 
1257         uint256 accountBalance = _balances[account];
1258         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1259         unchecked {
1260             _balances[account] = accountBalance - amount;
1261             // Overflow not possible: amount <= accountBalance <= totalSupply.
1262             _totalSupply -= amount;
1263         }
1264 
1265         emit Transfer(account, address(0), amount);
1266 
1267         _afterTokenTransfer(account, address(0), amount);
1268     }
1269 
1270     /**
1271      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1272      *
1273      * This internal function is equivalent to `approve`, and can be used to
1274      * e.g. set automatic allowances for certain subsystems, etc.
1275      *
1276      * Emits an {Approval} event.
1277      *
1278      * Requirements:
1279      *
1280      * - `owner` cannot be the zero address.
1281      * - `spender` cannot be the zero address.
1282      */
1283     function _approve(
1284         address owner,
1285         address spender,
1286         uint256 amount
1287     ) internal virtual {
1288         require(owner != address(0), "ERC20: approve from the zero address");
1289         require(spender != address(0), "ERC20: approve to the zero address");
1290 
1291         _allowances[owner][spender] = amount;
1292         emit Approval(owner, spender, amount);
1293     }
1294 
1295     /**
1296      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1297      *
1298      * Does not update the allowance amount in case of infinite allowance.
1299      * Revert if not enough allowance is available.
1300      *
1301      * Might emit an {Approval} event.
1302      */
1303     function _spendAllowance(
1304         address owner,
1305         address spender,
1306         uint256 amount
1307     ) internal virtual {
1308         uint256 currentAllowance = allowance(owner, spender);
1309         if (currentAllowance != type(uint256).max) {
1310             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1311             unchecked {
1312                 _approve(owner, spender, currentAllowance - amount);
1313             }
1314         }
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before any transfer of tokens. This includes
1319      * minting and burning.
1320      *
1321      * Calling conditions:
1322      *
1323      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1324      * will be transferred to `to`.
1325      * - when `from` is zero, `amount` tokens will be minted for `to`.
1326      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1327      * - `from` and `to` are never both zero.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 amount
1335     ) internal virtual {}
1336 
1337     /**
1338      * @dev Hook that is called after any transfer of tokens. This includes
1339      * minting and burning.
1340      *
1341      * Calling conditions:
1342      *
1343      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1344      * has been transferred to `to`.
1345      * - when `from` is zero, `amount` tokens have been minted for `to`.
1346      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1347      * - `from` and `to` are never both zero.
1348      *
1349      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1350      */
1351     function _afterTokenTransfer(
1352         address from,
1353         address to,
1354         uint256 amount
1355     ) internal virtual {}
1356 }
1357 
1358 interface IPostMintCampaign {
1359     struct Funds {
1360         IERC20 token;
1361         uint256 amount;
1362     }
1363 
1364     function addFunds(Funds[] calldata funds) external;
1365     function uploadRoot(bytes32 _merkleRoot) external returns (uint256 epochId);
1366     function updateRootUploader(address rootUploader, bool active) external;
1367     function pause() external;
1368     function unpause() external;
1369     function transferERC20(IERC20 token, address to, uint256 amount) external;
1370     function seedNewAllocations(bytes32 _merkleRoot, Funds[] calldata funds) external returns (uint256 epochId);
1371     function transferOwnership(address newOwner) external;
1372 }
1373 
1374 interface ICampaignFactory {
1375     function createEpochCampaign(IERC20[] calldata tokens) external  returns (address);
1376     function predictCampaignAddress(IERC20[] calldata tokens, address deployer) external view returns (address);
1377 }
1378 
1379 interface IWETH {
1380     function deposit() external payable;
1381     function transfer(address to, uint256 value) external returns (bool);
1382 }
1383 
1384 contract VibetoEarn is ERC20, Ownable {
1385     using SafeMath for uint256;
1386 
1387     mapping (address => uint256) private _balances;
1388     mapping (address => mapping (address => uint256)) private _allowances;
1389 
1390     mapping (address => bool) private _isExcludedFromFee;
1391     
1392     address private _thisAddress = address(this);
1393     uint256 constant PERCENT = 1000;
1394 
1395     uint256 private _tTotal = 420420420420420 * 10**18;
1396 
1397     string private _name = "Vibe to Earn";
1398     string private _symbol = "VIBE";
1399     uint8 private _decimals = 18;
1400 
1401     uint256 public _postMintFee = 35;
1402 
1403     uint256 public _teamFee = 15;
1404     address payable private teamWallet;
1405 
1406     uint256 public maxHoldingPercent;
1407 
1408     IPostMintCampaign public postMintCampaign;
1409     ICampaignFactory public campaignFactory;
1410     address public WETH_ADDRESS;
1411     IWETH private weth;
1412     IERC20 private WETH;
1413 
1414     IUniswapV2Router02 public immutable uniswapV2Router;
1415     address public immutable uniswapV2Pair;
1416     
1417     bool inSwapAndLiquify;
1418     bool public swapAndLiquifyEnabled = true;
1419 
1420     uint256 public _maxTxAmount = 420420420420420 * 10**18;
1421     uint256 public constant  MAX_BUY = 840840840840 * 10**18;
1422 
1423     /** Number of blocks to count as dead land */
1424     uint256 public constant   DEADBLOCK_COUNT = 3;
1425 
1426     /** List of available pools */
1427     mapping(address => bool) private poolList;
1428     /** Used to watch for sandwiches */
1429     mapping(address => uint) private _lastBlockTransfer;
1430 
1431     /** Deadblock start blocknum */
1432     uint256 private deadblockStart;
1433     /** Block contracts? */
1434     bool private _blockContracts;
1435     /** Limit buys? */
1436     bool private _limitBuys;
1437     /** Crowd control measures? */
1438     bool private _unrestricted;
1439 
1440     /** Emit on LP address set */
1441     event LiquidityPoolSet(address);
1442 
1443     /** Amount must be greater than zero */
1444     error NoZeroTransfers();
1445     /** Amount exceeds max transaction */
1446     error LimitExceeded();
1447     /** Not allowed */
1448     error NotAllowed();
1449     /** Reserve + Distribution must equal Total Supply (sanity check) */
1450     error IncorrectSum();
1451     
1452     event SwapAndLiquifyEnabledUpdated(bool enabled);
1453     event SwapAndLiquify(
1454         uint256 tokensSwapped,
1455         uint256 ethReceived,
1456         uint256 tokensIntoLiquidity
1457     );
1458     event SwapTokensForETH(uint256 amountIn, address[] path, uint256 amountOut);
1459     event ETHTransferredToCA(
1460     address indexed sender,
1461     uint256 ethReceived);
1462     event EthDepositedToWETH(
1463     address indexed sender,
1464     uint256 ethDeposited
1465     );
1466     event ETHAndWETHDistributed(
1467     address indexed sender,
1468     uint256 teamAmountETH,
1469     uint256 postMintETH);
1470 
1471     
1472     modifier lockTheSwap {
1473         inSwapAndLiquify = true;
1474         _;
1475         inSwapAndLiquify = false;
1476     }
1477     
1478     constructor (
1479         address _rounter,
1480         address payable _team,
1481         ICampaignFactory _campaignFactory,
1482         address _wToken
1483     ) ERC20(_name, _symbol) {
1484         _balances[_msgSender()] = _tTotal;
1485 
1486         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_rounter);
1487         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1488             .createPair(address(this), _uniswapV2Router.WETH());
1489 
1490         WETH_ADDRESS = _wToken;
1491         weth = IWETH(WETH_ADDRESS);
1492         WETH = IERC20(_wToken);
1493 
1494         campaignFactory = _campaignFactory;
1495         
1496         uniswapV2Router = _uniswapV2Router;
1497 
1498         teamWallet = _team;
1499         maxHoldingPercent = 2;
1500 
1501         _isExcludedFromFee[owner()] = true;
1502         _isExcludedFromFee[address(this)] = true;
1503         _isExcludedFromFee[_team] = true;
1504 
1505         IERC20[] memory tokenArray = new IERC20[](2);
1506         tokenArray[0] = IERC20(address(this));
1507         tokenArray[1] = WETH;
1508         address campaignAddress = campaignFactory.createEpochCampaign(tokenArray);
1509         _isExcludedFromFee[campaignAddress] = true;
1510         postMintCampaign = IPostMintCampaign(campaignAddress);
1511 
1512         emit Transfer(address(0), _msgSender(), _tTotal);
1513     }
1514 
1515     function name() public view override returns (string memory) {
1516         return _name;
1517     }
1518 
1519     function symbol() public view override returns (string memory) {
1520         return _symbol;
1521     }
1522 
1523     function decimals() public view override returns (uint8) {
1524         return _decimals;
1525     }
1526 
1527     function totalSupply() public view override returns (uint256) {
1528         return _tTotal;
1529     }
1530 
1531     function balanceOf(address account) public view override returns (uint256) {
1532         return _balances[account];
1533     }
1534 
1535     function transfer(address recipient, uint256 amount) public override returns (bool) {
1536         _transfer(_msgSender(), recipient, amount);
1537         return true;
1538     }
1539 
1540     function allowance(address owner, address spender) public view override returns (uint256) {
1541         return _allowances[owner][spender];
1542     }
1543 
1544     function approve(address spender, uint256 amount) public override returns (bool) {
1545         _approve(_msgSender(), spender, amount);
1546         return true;
1547     }
1548 
1549     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1550         _transfer(sender, recipient, amount);
1551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1552         return true;
1553     }
1554 
1555     function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
1556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1557         return true;
1558     }
1559 
1560     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
1561         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1562         return true;
1563     }
1564 
1565     function isExcludedFromFee(address account) public view returns (bool) {
1566         return _isExcludedFromFee[account];
1567     }
1568 
1569     function _approve(address owner, address spender, uint256 amount) internal override{
1570         require(owner != address(0), "ERC20: approve from the zero address");
1571         require(spender != address(0), "ERC20: approve to the zero address");
1572 
1573         _allowances[owner][spender] = amount;
1574         emit Approval(owner, spender, amount);
1575     }
1576 
1577     function _transfer(
1578         address from,
1579         address to,
1580         uint256 amount
1581         ) internal override {
1582         _beforeTokenTransfer(from, to, amount);
1583 
1584         require(from != address(0), "ERC20: transfer from the zero address");
1585         require(to != address(0), "ERC20: transfer to the zero address");
1586 
1587         uint256 totalFeePercent = _teamFee.add(_postMintFee);
1588         uint256 feeAmount = amount.mul(totalFeePercent).div(PERCENT);
1589         uint256 transferAmount = amount.sub(feeAmount);
1590 
1591         bool isFeeExcluded = _isExcludedFromFee[from] || _isExcludedFromFee[to];
1592 
1593         if (isFeeExcluded) {
1594             transferAmount = amount;
1595             feeAmount = 0;
1596         }
1597 
1598         bool isSwapAndLiquify = !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && to == uniswapV2Pair;
1599 
1600         if (isSwapAndLiquify && feeAmount > 0) {
1601              _balances[address(this)] = _balances[address(this)].add(feeAmount);
1602              if(_balances[address(this)] > 0){
1603                 swapTokensForEth(min(amount, min(feeAmount, _maxTxAmount)));
1604                 uint256 contractETHBalance = address(this).balance;
1605                 emit ETHTransferredToCA(from, contractETHBalance);
1606                     if (contractETHBalance > 0) {
1607                         sendETHToFee(contractETHBalance);
1608                     }
1609              }
1610         } else if (feeAmount > 0) {
1611             _applyFees(from, feeAmount, totalFeePercent);
1612         }
1613 
1614         // Update balances after all other operations to minimize state changes
1615         _balances[from] = _balances[from].sub(amount);
1616         _balances[to] = _balances[to].add(transferAmount);
1617         emit Transfer(from, to, transferAmount);
1618     }
1619 
1620     function _applyFees(address from, uint256 feeAmount, uint256 totalFeePercent) private {
1621         uint256 teamAmount = feeAmount.mul(_teamFee).div(totalFeePercent);
1622         uint256 postMintAmount = feeAmount.sub(teamAmount);
1623 
1624         // Add liquidityAmount to the teamWallet balance
1625         _balances[teamWallet] = _balances[teamWallet].add(teamAmount);
1626         
1627         // Only postMintAmount is added to the contract's address now
1628         _balances[address(this)] = _balances[address(this)].add(postMintAmount);
1629 
1630         // Emit the transfer events
1631         emit Transfer(from, teamWallet, teamAmount);
1632         emit Transfer(from, address(this), postMintAmount);
1633 
1634         // Approve the postMintCampaign to use the postMintAmount tokens from this contract
1635         ERC20(address(this)).approve(address(postMintCampaign), postMintAmount);
1636 
1637         IPostMintCampaign.Funds[] memory funds = new IPostMintCampaign.Funds[](1);
1638         funds[0] = IPostMintCampaign.Funds(ERC20(address(this)), postMintAmount);
1639 
1640         postMintCampaign.addFunds(funds);
1641     }
1642 
1643     function min(uint256 a, uint256 b) private pure returns (uint256){
1644       return (a>b)?b:a;
1645     }
1646 
1647     receive() external payable {}
1648 
1649     function swapTokensForEth(uint256 tokenAmount) private {
1650         address[] memory path = new address[](2);
1651         path[0] = address(this);
1652         path[1] = uniswapV2Router.WETH();
1653 
1654         _approve(address(this), address(uniswapV2Router), tokenAmount);
1655 
1656         uint256 initialBalance = address(this).balance;
1657 
1658         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1659             tokenAmount,
1660             0,
1661             path,
1662             address(this),
1663             block.timestamp
1664         );
1665 
1666         uint256 ethReceived = address(this).balance - initialBalance;
1667 
1668         emit SwapTokensForETH(tokenAmount, path, ethReceived);
1669     }
1670 
1671     function sendETHToFee(uint256 totalETH) private {
1672         uint256 feetotal = _teamFee.add(_postMintFee);
1673         uint256 teamAmountETH = totalETH.mul(_teamFee).div(feetotal);
1674         uint256 postMintETH = totalETH.sub(teamAmountETH);
1675 
1676         teamWallet.transfer(teamAmountETH);
1677 
1678         weth.deposit{value: postMintETH}();
1679         uint256 wethBalance = WETH.balanceOf(address(this));
1680 
1681         WETH.approve(address(postMintCampaign), wethBalance);
1682         
1683         IPostMintCampaign.Funds[] memory funds = new IPostMintCampaign.Funds[](1);
1684         funds[0] = IPostMintCampaign.Funds(WETH, wethBalance);
1685         postMintCampaign.addFunds(funds);
1686 
1687         emit EthDepositedToWETH(address(this), wethBalance);
1688         emit ETHAndWETHDistributed(address(this), teamAmountETH, wethBalance);
1689     }
1690 
1691     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1692         swapAndLiquifyEnabled = _enabled;
1693         emit SwapAndLiquifyEnabledUpdated(_enabled);
1694     }
1695 
1696     function excludeFromFee(address account) public onlyOwner {
1697         _isExcludedFromFee[account] = true;
1698     }
1699 
1700     function includeInFee(address account) public onlyOwner {
1701         _isExcludedFromFee[account] = false;
1702     }
1703 
1704     function updateMaxHoldingPercent (uint256 newAmount) external onlyOwner {
1705         maxHoldingPercent = newAmount;
1706     }
1707 
1708     /**
1709      * Campaign contract functions
1710      * @dev Callable by contract owner
1711      */
1712     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1713         _maxTxAmount = maxTxAmount;
1714     }
1715 
1716     function setUpdateRootUploader(address[] memory _newAddresses, bool status) external onlyOwner {
1717         for (uint256 i = 0; i < _newAddresses.length; i++) {
1718             postMintCampaign.updateRootUploader(_newAddresses[i], status);
1719         }
1720     }
1721 
1722     function campaignTransferOwnership (address _newOwner) external onlyOwner {
1723         postMintCampaign.transferOwnership(_newOwner);
1724     }
1725 
1726     function campaignTransferERC20 (IERC20 _token, address _to, uint256  amount) external onlyOwner {
1727         postMintCampaign.transferERC20(_token, _to, amount);
1728     }
1729 
1730     function campaignPause () external onlyOwner {
1731         postMintCampaign.pause();
1732     }
1733 
1734     function campaignUnPause () external onlyOwner {
1735         postMintCampaign.unpause();
1736     }
1737 
1738     function setIPostMintCampaign (IPostMintCampaign _csc) external onlyOwner {
1739         postMintCampaign = _csc;
1740     }
1741 
1742     function setWETHAddress (address newWeth) external onlyOwner {
1743         WETH_ADDRESS = newWeth;
1744         weth = IWETH(WETH_ADDRESS);
1745         WETH = IERC20(newWeth);
1746     }
1747 
1748     /**
1749      * @notice Recover BNB/ETH inside the contract
1750      * @dev Callable by contract owner
1751      */
1752     function recover(address payable _newadd,uint256 amount) external onlyOwner {
1753         
1754         (bool success, ) = address(_newadd).call{ value: amount }("");
1755         require(success, "Address: unable to send value");    
1756     }
1757 
1758     /**
1759      * @notice Recover specific token inside the contract
1760      * @dev Callable by contract owner
1761      */
1762     function recoverToken(address _token, uint256 _amount) external onlyOwner {
1763         ERC20(_token).transfer(address(msg.sender), _amount);
1764     }
1765 
1766     /**
1767     * Checks if address is contract
1768     * @param _address Address in question
1769     * @dev Contract will have codesize
1770     */
1771     function _isContract(address _address) internal view returns (bool) {
1772         uint32 size;
1773         assembly {
1774             size := extcodesize(_address)
1775         }
1776         return (size > 0);
1777     }
1778 
1779     /**
1780     * Checks if address has inhuman reflexes or if it's a contract
1781     * @param _address Address in question
1782     */
1783     function _checkIfBot(address _address) internal view returns (bool) {
1784         return (block.number < DEADBLOCK_COUNT + deadblockStart || _isContract(_address));
1785     }
1786 
1787      /**
1788    * @dev Hook that is called before any transfer of tokens.  This includes
1789    * minting and burning.
1790    *
1791    * Checks:
1792    * - transfer amount is non-zero
1793    * - buy/sell are not executed during the same block to help alleviate sandwiches
1794    * - buy amount does not exceed max buy during limited period
1795    * - check for bots to alleviate snipes
1796    */
1797   function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal override {
1798     if (amount == 0) { revert NoZeroTransfers(); }
1799     super._beforeTokenTransfer(sender, recipient, amount);
1800 
1801     if (_unrestricted) { return; }
1802 
1803     // Watch for sandwich
1804     if (block.number == _lastBlockTransfer[sender] || block.number == _lastBlockTransfer[recipient]) {
1805       revert NotAllowed();
1806     }
1807 
1808     bool isBuy = poolList[sender];
1809     bool isSell = poolList[recipient];
1810 
1811     if (isBuy) {
1812       // Watch for bots
1813       if (_blockContracts && _checkIfBot(recipient)) { revert NotAllowed(); }
1814       // Watch for buys exceeding max during limited period
1815       if (_limitBuys && amount > MAX_BUY) { revert LimitExceeded(); }
1816       _lastBlockTransfer[recipient] = block.number;
1817     } else if (isSell) {
1818       _lastBlockTransfer[sender] = block.number;
1819     }
1820   }
1821 
1822 }