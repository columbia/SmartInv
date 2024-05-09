1 // File: IUniswapV2Factory.sol
2 
3 
4 pragma solidity >=0.5.0;
5 
6 interface IUniswapV2Factory {
7     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
8 
9     function feeTo() external view returns (address);
10     function feeToSetter() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20 }
21 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
22 
23 pragma solidity >=0.6.2;
24 
25 interface IUniswapV2Router01 {
26     function factory() external pure returns (address);
27     function WETH() external pure returns (address);
28 
29     function addLiquidity(
30         address tokenA,
31         address tokenB,
32         uint amountADesired,
33         uint amountBDesired,
34         uint amountAMin,
35         uint amountBMin,
36         address to,
37         uint deadline
38     ) external returns (uint amountA, uint amountB, uint liquidity);
39     function addLiquidityETH(
40         address token,
41         uint amountTokenDesired,
42         uint amountTokenMin,
43         uint amountETHMin,
44         address to,
45         uint deadline
46     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
47     function removeLiquidity(
48         address tokenA,
49         address tokenB,
50         uint liquidity,
51         uint amountAMin,
52         uint amountBMin,
53         address to,
54         uint deadline
55     ) external returns (uint amountA, uint amountB);
56     function removeLiquidityETH(
57         address token,
58         uint liquidity,
59         uint amountTokenMin,
60         uint amountETHMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountToken, uint amountETH);
64     function removeLiquidityWithPermit(
65         address tokenA,
66         address tokenB,
67         uint liquidity,
68         uint amountAMin,
69         uint amountBMin,
70         address to,
71         uint deadline,
72         bool approveMax, uint8 v, bytes32 r, bytes32 s
73     ) external returns (uint amountA, uint amountB);
74     function removeLiquidityETHWithPermit(
75         address token,
76         uint liquidity,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline,
81         bool approveMax, uint8 v, bytes32 r, bytes32 s
82     ) external returns (uint amountToken, uint amountETH);
83     function swapExactTokensForTokens(
84         uint amountIn,
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external returns (uint[] memory amounts);
90     function swapTokensForExactTokens(
91         uint amountOut,
92         uint amountInMax,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external returns (uint[] memory amounts);
97     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
98         external
99         payable
100         returns (uint[] memory amounts);
101     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
102         external
103         returns (uint[] memory amounts);
104     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
105         external
106         returns (uint[] memory amounts);
107     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
108         external
109         payable
110         returns (uint[] memory amounts);
111 
112     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
113     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
114     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
115     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
116     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
117 }
118 
119 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
120 
121 pragma solidity >=0.6.2;
122 
123 
124 interface IUniswapV2Router02 is IUniswapV2Router01 {
125     function removeLiquidityETHSupportingFeeOnTransferTokens(
126         address token,
127         uint liquidity,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external returns (uint amountETH);
133     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline,
140         bool approveMax, uint8 v, bytes32 r, bytes32 s
141     ) external returns (uint amountETH);
142 
143     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 }
164 
165 // File: @openzeppelin/contracts@4.7.3/utils/Address.sol
166 
167 
168 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
169 
170 pragma solidity ^0.8.1;
171 
172 /**
173  * @dev Collection of functions related to the address type
174  */
175 library Address {
176     /**
177      * @dev Returns true if `account` is a contract.
178      *
179      * [IMPORTANT]
180      * ====
181      * It is unsafe to assume that an address for which this function returns
182      * false is an externally-owned account (EOA) and not a contract.
183      *
184      * Among others, `isContract` will return false for the following
185      * types of addresses:
186      *
187      *  - an externally-owned account
188      *  - a contract in construction
189      *  - an address where a contract will be created
190      *  - an address where a contract lived, but was destroyed
191      * ====
192      *
193      * [IMPORTANT]
194      * ====
195      * You shouldn't rely on `isContract` to protect against flash loan attacks!
196      *
197      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
198      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
199      * constructor.
200      * ====
201      */
202     function isContract(address account) internal view returns (bool) {
203         // This method relies on extcodesize/address.code.length, which returns 0
204         // for contracts in construction, since the code is only stored at the end
205         // of the constructor execution.
206 
207         return account.code.length > 0;
208     }
209 
210     /**
211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
212      * `recipient`, forwarding all available gas and reverting on errors.
213      *
214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
216      * imposed by `transfer`, making them unable to receive funds via
217      * `transfer`. {sendValue} removes this limitation.
218      *
219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
220      *
221      * IMPORTANT: because control is transferred to `recipient`, care must be
222      * taken to not create reentrancy vulnerabilities. Consider using
223      * {ReentrancyGuard} or the
224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
225      */
226     function sendValue(address payable recipient, uint256 amount) internal {
227         require(address(this).balance >= amount, "Address: insufficient balance");
228 
229         (bool success, ) = recipient.call{value: amount}("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain `call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, 0, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but also transferring `value` wei to `target`.
272      *
273      * Requirements:
274      *
275      * - the calling contract must have an ETH balance of at least `value`.
276      * - the called Solidity function must be `payable`.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
290      * with `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(address(this).balance >= value, "Address: insufficient balance for call");
301         require(isContract(target), "Address: call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.call{value: value}(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a static call.
310      *
311      * _Available since v3.3._
312      */
313     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
314         return functionStaticCall(target, data, "Address: low-level static call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal view returns (bytes memory) {
328         require(isContract(target), "Address: static call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.staticcall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a delegate call.
337      *
338      * _Available since v3.4._
339      */
340     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(isContract(target), "Address: delegate call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.delegatecall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
363      * revert reason using the provided one.
364      *
365      * _Available since v4.3._
366      */
367     function verifyCallResult(
368         bool success,
369         bytes memory returndata,
370         string memory errorMessage
371     ) internal pure returns (bytes memory) {
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts@4.7.3/utils/math/SafeMath.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 // CAUTION
398 // This version of SafeMath should only be used with Solidity 0.8 or later,
399 // because it relies on the compiler's built in overflow checks.
400 
401 /**
402  * @dev Wrappers over Solidity's arithmetic operations.
403  *
404  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
405  * now has built in overflow checking.
406  */
407 library SafeMath {
408     /**
409      * @dev Returns the addition of two unsigned integers, with an overflow flag.
410      *
411      * _Available since v3.4._
412      */
413     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414         unchecked {
415             uint256 c = a + b;
416             if (c < a) return (false, 0);
417             return (true, c);
418         }
419     }
420 
421     /**
422      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
423      *
424      * _Available since v3.4._
425      */
426     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
427         unchecked {
428             if (b > a) return (false, 0);
429             return (true, a - b);
430         }
431     }
432 
433     /**
434      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
439         unchecked {
440             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
441             // benefit is lost if 'b' is also tested.
442             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
443             if (a == 0) return (true, 0);
444             uint256 c = a * b;
445             if (c / a != b) return (false, 0);
446             return (true, c);
447         }
448     }
449 
450     /**
451      * @dev Returns the division of two unsigned integers, with a division by zero flag.
452      *
453      * _Available since v3.4._
454      */
455     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
456         unchecked {
457             if (b == 0) return (false, 0);
458             return (true, a / b);
459         }
460     }
461 
462     /**
463      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
464      *
465      * _Available since v3.4._
466      */
467     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
468         unchecked {
469             if (b == 0) return (false, 0);
470             return (true, a % b);
471         }
472     }
473 
474     /**
475      * @dev Returns the addition of two unsigned integers, reverting on
476      * overflow.
477      *
478      * Counterpart to Solidity's `+` operator.
479      *
480      * Requirements:
481      *
482      * - Addition cannot overflow.
483      */
484     function add(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a + b;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return a - b;
500     }
501 
502     /**
503      * @dev Returns the multiplication of two unsigned integers, reverting on
504      * overflow.
505      *
506      * Counterpart to Solidity's `*` operator.
507      *
508      * Requirements:
509      *
510      * - Multiplication cannot overflow.
511      */
512     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
513         return a * b;
514     }
515 
516     /**
517      * @dev Returns the integer division of two unsigned integers, reverting on
518      * division by zero. The result is rounded towards zero.
519      *
520      * Counterpart to Solidity's `/` operator.
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function div(uint256 a, uint256 b) internal pure returns (uint256) {
527         return a / b;
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * reverting when dividing by zero.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
543         return a % b;
544     }
545 
546     /**
547      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
548      * overflow (when the result is negative).
549      *
550      * CAUTION: This function is deprecated because it requires allocating memory for the error
551      * message unnecessarily. For custom revert reasons use {trySub}.
552      *
553      * Counterpart to Solidity's `-` operator.
554      *
555      * Requirements:
556      *
557      * - Subtraction cannot overflow.
558      */
559     function sub(
560         uint256 a,
561         uint256 b,
562         string memory errorMessage
563     ) internal pure returns (uint256) {
564         unchecked {
565             require(b <= a, errorMessage);
566             return a - b;
567         }
568     }
569 
570     /**
571      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
572      * division by zero. The result is rounded towards zero.
573      *
574      * Counterpart to Solidity's `/` operator. Note: this function uses a
575      * `revert` opcode (which leaves remaining gas untouched) while Solidity
576      * uses an invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function div(
583         uint256 a,
584         uint256 b,
585         string memory errorMessage
586     ) internal pure returns (uint256) {
587         unchecked {
588             require(b > 0, errorMessage);
589             return a / b;
590         }
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * reverting with custom message when dividing by zero.
596      *
597      * CAUTION: This function is deprecated because it requires allocating memory for the error
598      * message unnecessarily. For custom revert reasons use {tryMod}.
599      *
600      * Counterpart to Solidity's `%` operator. This function uses a `revert`
601      * opcode (which leaves remaining gas untouched) while Solidity uses an
602      * invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function mod(
609         uint256 a,
610         uint256 b,
611         string memory errorMessage
612     ) internal pure returns (uint256) {
613         unchecked {
614             require(b > 0, errorMessage);
615             return a % b;
616         }
617     }
618 }
619 
620 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Provides information about the current execution context, including the
629  * sender of the transaction and its data. While these are generally available
630  * via msg.sender and msg.data, they should not be accessed in such a direct
631  * manner, since when dealing with meta-transactions the account sending and
632  * paying for execution may not be the actual sender (as far as an application
633  * is concerned).
634  *
635  * This contract is only required for intermediate, library-like contracts.
636  */
637 abstract contract Context {
638     function _msgSender() internal view virtual returns (address) {
639         return msg.sender;
640     }
641 
642     function _msgData() internal view virtual returns (bytes calldata) {
643         return msg.data;
644     }
645 }
646 
647 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Contract module which provides a basic access control mechanism, where
657  * there is an account (an owner) that can be granted exclusive access to
658  * specific functions.
659  *
660  * By default, the owner account will be the one that deploys the contract. This
661  * can later be changed with {transferOwnership}.
662  *
663  * This module is used through inheritance. It will make available the modifier
664  * `onlyOwner`, which can be applied to your functions to restrict their use to
665  * the owner.
666  */
667 abstract contract Ownable is Context {
668     address private _owner;
669 
670     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
671 
672     /**
673      * @dev Initializes the contract setting the deployer as the initial owner.
674      */
675     constructor() {
676         _transferOwnership(_msgSender());
677     }
678 
679     /**
680      * @dev Throws if called by any account other than the owner.
681      */
682     modifier onlyOwner() {
683         _checkOwner();
684         _;
685     }
686 
687     /**
688      * @dev Returns the address of the current owner.
689      */
690     function owner() public view virtual returns (address) {
691         return _owner;
692     }
693 
694     /**
695      * @dev Throws if the sender is not the owner.
696      */
697     function _checkOwner() internal view virtual {
698         require(owner() == _msgSender(), "Ownable: caller is not the owner");
699     }
700 
701     /**
702      * @dev Leaves the contract without owner. It will not be possible to call
703      * `onlyOwner` functions anymore. Can only be called by the current owner.
704      *
705      * NOTE: Renouncing ownership will leave the contract without an owner,
706      * thereby removing any functionality that is only available to the owner.
707      */
708     function renounceOwnership() public virtual onlyOwner {
709         _transferOwnership(address(0));
710     }
711 
712     /**
713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
714      * Can only be called by the current owner.
715      */
716     function transferOwnership(address newOwner) public virtual onlyOwner {
717         require(newOwner != address(0), "Ownable: new owner is the zero address");
718         _transferOwnership(newOwner);
719     }
720 
721     /**
722      * @dev Transfers ownership of the contract to a new account (`newOwner`).
723      * Internal function without access restriction.
724      */
725     function _transferOwnership(address newOwner) internal virtual {
726         address oldOwner = _owner;
727         _owner = newOwner;
728         emit OwnershipTransferred(oldOwner, newOwner);
729     }
730 }
731 
732 // File: @openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol
733 
734 
735 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 /**
740  * @dev Interface of the ERC20 standard as defined in the EIP.
741  */
742 interface IERC20 {
743     /**
744      * @dev Emitted when `value` tokens are moved from one account (`from`) to
745      * another (`to`).
746      *
747      * Note that `value` may be zero.
748      */
749     event Transfer(address indexed from, address indexed to, uint256 value);
750 
751     /**
752      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
753      * a call to {approve}. `value` is the new allowance.
754      */
755     event Approval(address indexed owner, address indexed spender, uint256 value);
756 
757     /**
758      * @dev Returns the amount of tokens in existence.
759      */
760     function totalSupply() external view returns (uint256);
761 
762     /**
763      * @dev Returns the amount of tokens owned by `account`.
764      */
765     function balanceOf(address account) external view returns (uint256);
766 
767     /**
768      * @dev Moves `amount` tokens from the caller's account to `to`.
769      *
770      * Returns a boolean value indicating whether the operation succeeded.
771      *
772      * Emits a {Transfer} event.
773      */
774     function transfer(address to, uint256 amount) external returns (bool);
775 
776     /**
777      * @dev Returns the remaining number of tokens that `spender` will be
778      * allowed to spend on behalf of `owner` through {transferFrom}. This is
779      * zero by default.
780      *
781      * This value changes when {approve} or {transferFrom} are called.
782      */
783     function allowance(address owner, address spender) external view returns (uint256);
784 
785     /**
786      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
787      *
788      * Returns a boolean value indicating whether the operation succeeded.
789      *
790      * IMPORTANT: Beware that changing an allowance with this method brings the risk
791      * that someone may use both the old and the new allowance by unfortunate
792      * transaction ordering. One possible solution to mitigate this race
793      * condition is to first reduce the spender's allowance to 0 and set the
794      * desired value afterwards:
795      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
796      *
797      * Emits an {Approval} event.
798      */
799     function approve(address spender, uint256 amount) external returns (bool);
800 
801     /**
802      * @dev Moves `amount` tokens from `from` to `to` using the
803      * allowance mechanism. `amount` is then deducted from the caller's
804      * allowance.
805      *
806      * Returns a boolean value indicating whether the operation succeeded.
807      *
808      * Emits a {Transfer} event.
809      */
810     function transferFrom(
811         address from,
812         address to,
813         uint256 amount
814     ) external returns (bool);
815 }
816 
817 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/IERC20Metadata.sol
818 
819 
820 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 /**
826  * @dev Interface for the optional metadata functions from the ERC20 standard.
827  *
828  * _Available since v4.1._
829  */
830 interface IERC20Metadata is IERC20 {
831     /**
832      * @dev Returns the name of the token.
833      */
834     function name() external view returns (string memory);
835 
836     /**
837      * @dev Returns the symbol of the token.
838      */
839     function symbol() external view returns (string memory);
840 
841     /**
842      * @dev Returns the decimals places of the token.
843      */
844     function decimals() external view returns (uint8);
845 }
846 
847 // File: @openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol
848 
849 
850 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 
855 
856 
857 /**
858  * @dev Implementation of the {IERC20} interface.
859  *
860  * This implementation is agnostic to the way tokens are created. This means
861  * that a supply mechanism has to be added in a derived contract using {_mint}.
862  * For a generic mechanism see {ERC20PresetMinterPauser}.
863  *
864  * TIP: For a detailed writeup see our guide
865  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
866  * to implement supply mechanisms].
867  *
868  * We have followed general OpenZeppelin Contracts guidelines: functions revert
869  * instead returning `false` on failure. This behavior is nonetheless
870  * conventional and does not conflict with the expectations of ERC20
871  * applications.
872  *
873  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
874  * This allows applications to reconstruct the allowance for all accounts just
875  * by listening to said events. Other implementations of the EIP may not emit
876  * these events, as it isn't required by the specification.
877  *
878  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
879  * functions have been added to mitigate the well-known issues around setting
880  * allowances. See {IERC20-approve}.
881  */
882 contract ERC20 is Context, IERC20, IERC20Metadata {
883     mapping(address => uint256) private _balances;
884 
885     mapping(address => mapping(address => uint256)) private _allowances;
886 
887     uint256 private _totalSupply;
888 
889     string private _name;
890     string private _symbol;
891 
892     /**
893      * @dev Sets the values for {name} and {symbol}.
894      *
895      * The default value of {decimals} is 18. To select a different value for
896      * {decimals} you should overload it.
897      *
898      * All two of these values are immutable: they can only be set once during
899      * construction.
900      */
901     constructor(string memory name_, string memory symbol_) {
902         _name = name_;
903         _symbol = symbol_;
904     }
905 
906     /**
907      * @dev Returns the name of the token.
908      */
909     function name() public view virtual override returns (string memory) {
910         return _name;
911     }
912 
913     /**
914      * @dev Returns the symbol of the token, usually a shorter version of the
915      * name.
916      */
917     function symbol() public view virtual override returns (string memory) {
918         return _symbol;
919     }
920 
921     /**
922      * @dev Returns the number of decimals used to get its user representation.
923      * For example, if `decimals` equals `2`, a balance of `505` tokens should
924      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
925      *
926      * Tokens usually opt for a value of 18, imitating the relationship between
927      * Ether and Wei. This is the value {ERC20} uses, unless this function is
928      * overridden;
929      *
930      * NOTE: This information is only used for _display_ purposes: it in
931      * no way affects any of the arithmetic of the contract, including
932      * {IERC20-balanceOf} and {IERC20-transfer}.
933      */
934     function decimals() public view virtual override returns (uint8) {
935         return 18;
936     }
937 
938     /**
939      * @dev See {IERC20-totalSupply}.
940      */
941     function totalSupply() public view virtual override returns (uint256) {
942         return _totalSupply;
943     }
944 
945     /**
946      * @dev See {IERC20-balanceOf}.
947      */
948     function balanceOf(address account) public view virtual override returns (uint256) {
949         return _balances[account];
950     }
951 
952     /**
953      * @dev See {IERC20-transfer}.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - the caller must have a balance of at least `amount`.
959      */
960     function transfer(address to, uint256 amount) public virtual override returns (bool) {
961         address owner = _msgSender();
962         _transfer(owner, to, amount);
963         return true;
964     }
965 
966     /**
967      * @dev See {IERC20-allowance}.
968      */
969     function allowance(address owner, address spender) public view virtual override returns (uint256) {
970         return _allowances[owner][spender];
971     }
972 
973     /**
974      * @dev See {IERC20-approve}.
975      *
976      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
977      * `transferFrom`. This is semantically equivalent to an infinite approval.
978      *
979      * Requirements:
980      *
981      * - `spender` cannot be the zero address.
982      */
983     function approve(address spender, uint256 amount) public virtual override returns (bool) {
984         address owner = _msgSender();
985         _approve(owner, spender, amount);
986         return true;
987     }
988 
989     /**
990      * @dev See {IERC20-transferFrom}.
991      *
992      * Emits an {Approval} event indicating the updated allowance. This is not
993      * required by the EIP. See the note at the beginning of {ERC20}.
994      *
995      * NOTE: Does not update the allowance if the current allowance
996      * is the maximum `uint256`.
997      *
998      * Requirements:
999      *
1000      * - `from` and `to` cannot be the zero address.
1001      * - `from` must have a balance of at least `amount`.
1002      * - the caller must have allowance for ``from``'s tokens of at least
1003      * `amount`.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) public virtual override returns (bool) {
1010         address spender = _msgSender();
1011         _spendAllowance(from, spender, amount);
1012         _transfer(from, to, amount);
1013         return true;
1014     }
1015 
1016     /**
1017      * @dev Atomically increases the allowance granted to `spender` by the caller.
1018      *
1019      * This is an alternative to {approve} that can be used as a mitigation for
1020      * problems described in {IERC20-approve}.
1021      *
1022      * Emits an {Approval} event indicating the updated allowance.
1023      *
1024      * Requirements:
1025      *
1026      * - `spender` cannot be the zero address.
1027      */
1028     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1029         address owner = _msgSender();
1030         _approve(owner, spender, allowance(owner, spender) + addedValue);
1031         return true;
1032     }
1033 
1034     /**
1035      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1036      *
1037      * This is an alternative to {approve} that can be used as a mitigation for
1038      * problems described in {IERC20-approve}.
1039      *
1040      * Emits an {Approval} event indicating the updated allowance.
1041      *
1042      * Requirements:
1043      *
1044      * - `spender` cannot be the zero address.
1045      * - `spender` must have allowance for the caller of at least
1046      * `subtractedValue`.
1047      */
1048     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1049         address owner = _msgSender();
1050         uint256 currentAllowance = allowance(owner, spender);
1051         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1052         unchecked {
1053             _approve(owner, spender, currentAllowance - subtractedValue);
1054         }
1055 
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev Moves `amount` of tokens from `from` to `to`.
1061      *
1062      * This internal function is equivalent to {transfer}, and can be used to
1063      * e.g. implement automatic token fees, slashing mechanisms, etc.
1064      *
1065      * Emits a {Transfer} event.
1066      *
1067      * Requirements:
1068      *
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      * - `from` must have a balance of at least `amount`.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 amount
1077     ) internal virtual {
1078         require(from != address(0), "ERC20: transfer from the zero address");
1079         require(to != address(0), "ERC20: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(from, to, amount);
1082 
1083         uint256 fromBalance = _balances[from];
1084         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1085         unchecked {
1086             _balances[from] = fromBalance - amount;
1087         }
1088         _balances[to] += amount;
1089 
1090         emit Transfer(from, to, amount);
1091 
1092         _afterTokenTransfer(from, to, amount);
1093     }
1094 
1095     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1096      * the total supply.
1097      *
1098      * Emits a {Transfer} event with `from` set to the zero address.
1099      *
1100      * Requirements:
1101      *
1102      * - `account` cannot be the zero address.
1103      */
1104     function _mint(address account, uint256 amount) internal virtual {
1105         require(account != address(0), "ERC20: mint to the zero address");
1106 
1107         _beforeTokenTransfer(address(0), account, amount);
1108 
1109         _totalSupply += amount;
1110         _balances[account] += amount;
1111         emit Transfer(address(0), account, amount);
1112 
1113         _afterTokenTransfer(address(0), account, amount);
1114     }
1115 
1116     /**
1117      * @dev Destroys `amount` tokens from `account`, reducing the
1118      * total supply.
1119      *
1120      * Emits a {Transfer} event with `to` set to the zero address.
1121      *
1122      * Requirements:
1123      *
1124      * - `account` cannot be the zero address.
1125      * - `account` must have at least `amount` tokens.
1126      */
1127     function _burn(address account, uint256 amount) internal virtual {
1128         require(account != address(0), "ERC20: burn from the zero address");
1129 
1130         _beforeTokenTransfer(account, address(0), amount);
1131 
1132         uint256 accountBalance = _balances[account];
1133         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1134         unchecked {
1135             _balances[account] = accountBalance - amount;
1136         }
1137         _totalSupply -= amount;
1138 
1139         emit Transfer(account, address(0), amount);
1140 
1141         _afterTokenTransfer(account, address(0), amount);
1142     }
1143 
1144     /**
1145      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1146      *
1147      * This internal function is equivalent to `approve`, and can be used to
1148      * e.g. set automatic allowances for certain subsystems, etc.
1149      *
1150      * Emits an {Approval} event.
1151      *
1152      * Requirements:
1153      *
1154      * - `owner` cannot be the zero address.
1155      * - `spender` cannot be the zero address.
1156      */
1157     function _approve(
1158         address owner,
1159         address spender,
1160         uint256 amount
1161     ) internal virtual {
1162         require(owner != address(0), "ERC20: approve from the zero address");
1163         require(spender != address(0), "ERC20: approve to the zero address");
1164 
1165         _allowances[owner][spender] = amount;
1166         emit Approval(owner, spender, amount);
1167     }
1168 
1169     /**
1170      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1171      *
1172      * Does not update the allowance amount in case of infinite allowance.
1173      * Revert if not enough allowance is available.
1174      *
1175      * Might emit an {Approval} event.
1176      */
1177     function _spendAllowance(
1178         address owner,
1179         address spender,
1180         uint256 amount
1181     ) internal virtual {
1182         uint256 currentAllowance = allowance(owner, spender);
1183         if (currentAllowance != type(uint256).max) {
1184             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1185             unchecked {
1186                 _approve(owner, spender, currentAllowance - amount);
1187             }
1188         }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before any transfer of tokens. This includes
1193      * minting and burning.
1194      *
1195      * Calling conditions:
1196      *
1197      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1198      * will be transferred to `to`.
1199      * - when `from` is zero, `amount` tokens will be minted for `to`.
1200      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1201      * - `from` and `to` are never both zero.
1202      *
1203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1204      */
1205     function _beforeTokenTransfer(
1206         address from,
1207         address to,
1208         uint256 amount
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after any transfer of tokens. This includes
1213      * minting and burning.
1214      *
1215      * Calling conditions:
1216      *
1217      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1218      * has been transferred to `to`.
1219      * - when `from` is zero, `amount` tokens have been minted for `to`.
1220      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1221      * - `from` and `to` are never both zero.
1222      *
1223      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1224      */
1225     function _afterTokenTransfer(
1226         address from,
1227         address to,
1228         uint256 amount
1229     ) internal virtual {}
1230 }
1231 
1232 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/ERC20Burnable.sol
1233 
1234 
1235 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 
1240 
1241 /**
1242  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1243  * tokens and those that they have an allowance for, in a way that can be
1244  * recognized off-chain (via event analysis).
1245  */
1246 abstract contract ERC20Burnable is Context, ERC20 {
1247     /**
1248      * @dev Destroys `amount` tokens from the caller.
1249      *
1250      * See {ERC20-_burn}.
1251      */
1252     function burn(uint256 amount) public virtual {
1253         _burn(_msgSender(), amount);
1254     }
1255 
1256     /**
1257      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1258      * allowance.
1259      *
1260      * See {ERC20-_burn} and {ERC20-allowance}.
1261      *
1262      * Requirements:
1263      *
1264      * - the caller must have allowance for ``accounts``'s tokens of at least
1265      * `amount`.
1266      */
1267     function burnFrom(address account, uint256 amount) public virtual {
1268         _spendAllowance(account, _msgSender(), amount);
1269         _burn(account, amount);
1270     }
1271 }
1272 
1273 // File: contract-014ea2ceca.sol
1274 
1275 
1276 pragma solidity ^0.8.4;
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 
1285 contract SigilToken is ERC20, ERC20Burnable, Ownable {
1286     using SafeMath for uint256;
1287     using Address for address;
1288 
1289     mapping(address => uint256) private _balances;
1290     mapping(address => bool) private _taxExemptList;
1291     mapping(address => mapping(address => uint256)) private _allowances;
1292 
1293     
1294     uint256 private _totalSupply;
1295     string private _name;
1296     string private _symbol;
1297 
1298     uint256 public _lpFee = 10000000000000000;
1299     uint256 public _projectFee = 20000000000000000;
1300     uint256 public _feeThreshold = 5000000 * 10**18;
1301     bool private _addingToLiq = false;
1302     bool public _feesEnabled = true;
1303     address public immutable _projectWallet;
1304     address public _stakingPool = address(0);
1305 
1306     IUniswapV2Router02 public immutable uniswapV2Router;
1307     address public immutable uniswapV2Pair;
1308 
1309     event SwapAndLiquify(
1310         uint256 tokensSwapped,
1311         uint256 ethReceived,
1312         uint256 tokensIntoLiqudity
1313     );
1314 
1315     constructor() ERC20("Sigil Finance", "SIGIL") {
1316         _mint(msg.sender,  1000000000 * 10**18);
1317         _name = "Sigil Finance";
1318         _symbol = "SIGIL";
1319 
1320          IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1321          // Create a uniswap pair for this new token
1322         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1323             .createPair(address(this), _uniswapV2Router.WETH());
1324 
1325         uniswapV2Router = _uniswapV2Router;
1326 
1327         _taxExemptList[owner()] = true;
1328         _taxExemptList[address(this)] = true;
1329         _taxExemptList[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
1330         _projectWallet = msg.sender;
1331         
1332     }
1333 
1334     function name() public view virtual override returns (string memory) {
1335         return _name;
1336     }
1337 
1338     function symbol() public view virtual override returns (string memory) {
1339         return _symbol;
1340     }
1341 
1342     function decimals() public view virtual override returns (uint8) {
1343         return 18;
1344     }
1345 
1346     function totalSupply() public view virtual override returns (uint256) {
1347         return _totalSupply;
1348     }
1349 
1350     function balanceOf(address account) public view virtual override returns (uint256) {
1351         return _balances[account];
1352     }
1353 
1354     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1355         address owner = _msgSender();
1356         _transfer(owner, to, amount);
1357         return true;
1358     }
1359 
1360     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1361         return _allowances[owner][spender];
1362     }
1363 
1364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1365         address owner = _msgSender();
1366         _approve(owner, spender, amount);
1367         return true;
1368     }
1369 
1370     function taxExempt(address account) public view returns (bool) {
1371         return _taxExemptList[account];
1372     }
1373 
1374     function addToTaxExemptList(address account) public onlyOwner {
1375         _taxExemptList[account] = true;
1376     }
1377 
1378     function contractBalance() public view returns (uint256) {
1379         return _balances[address(this)];
1380     }
1381 
1382     function disableFees() public onlyOwner {
1383         _feesEnabled = false;
1384     }
1385 
1386     function changeStakingPoolAddress(address _address) public onlyOwner {
1387         _stakingPool = _address;
1388     }
1389 
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 amount
1394     ) public virtual override returns (bool) {
1395         address spender = _msgSender();
1396         _spendAllowance(from, spender, amount);
1397         _transfer(from, to, amount);
1398         return true;
1399     }
1400 
1401     function increaseAllowance(address spender, uint256 addedValue) public override virtual returns (bool) {
1402         address owner = _msgSender();
1403         _approve(owner, spender, allowance(owner, spender) + addedValue);
1404         return true;
1405     }
1406 
1407 
1408     function decreaseAllowance(address spender, uint256 subtractedValue) public override virtual returns (bool) {
1409         address owner = _msgSender();
1410         uint256 currentAllowance = allowance(owner, spender);
1411         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1412         unchecked {
1413             _approve(owner, spender, currentAllowance - subtractedValue);
1414         }
1415 
1416         return true;
1417     }
1418 
1419     function _transfer(
1420         address from,
1421         address to,
1422         uint256 amount
1423     ) internal override virtual {
1424         require(from != address(0), "ERC20: transfer from the zero address");
1425         require(to != address(0), "ERC20: transfer to the zero address");
1426         uint256 fromBalance = _balances[from];
1427         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1428         if(_taxExemptList[to] == false && from != _stakingPool){
1429             require(balanceOf(to) + amount < 10000000 * 10**18, "Transfer exceeds maximum wallet size");
1430         }
1431         unchecked {
1432             _balances[from] = fromBalance - amount;
1433         }
1434 
1435         bool overMinTokenBalance = _balances[address(this)] >= _feeThreshold;
1436         if (
1437             overMinTokenBalance &&
1438             !_addingToLiq &&
1439             from != uniswapV2Pair
1440         ) {
1441             _addingToLiq = true;
1442             swapAndLiquify(_feeThreshold);
1443             _addingToLiq = false;
1444         }
1445 
1446         bool isTaxExempt = (_taxExemptList[from] == true && _taxExemptList[to] == true);
1447         
1448         if(from == _stakingPool || to == _stakingPool || isTaxExempt || _feesEnabled == false){
1449             _balances[to] += amount;
1450         } else {
1451             uint256 feeAmount =  amount * (_lpFee + _projectFee) / 10**18;
1452             _balances[to] += amount - feeAmount;     
1453             _balances[address(this)] += feeAmount;
1454         }
1455  
1456         
1457         emit Transfer(from, to, amount);
1458     }
1459 
1460     function _mint(address account, uint256 amount) internal override virtual {
1461         require(account != address(0), "ERC20: mint to the zero address");
1462 
1463         _beforeTokenTransfer(address(0), account, amount);
1464 
1465         _totalSupply += amount;
1466         _balances[account] += amount;
1467         emit Transfer(address(0), account, amount);
1468 
1469         _afterTokenTransfer(address(0), account, amount);
1470     }
1471 
1472     function _burn(address account, uint256 amount) internal override virtual {
1473         require(account != address(0), "ERC20: burn from the zero address");
1474 
1475         _beforeTokenTransfer(account, address(0), amount);
1476 
1477         uint256 accountBalance = _balances[account];
1478         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1479         unchecked {
1480             _balances[account] = accountBalance - amount;
1481         }
1482         _totalSupply -= amount;
1483 
1484         emit Transfer(account, address(0), amount);
1485 
1486         _afterTokenTransfer(account, address(0), amount);
1487     }
1488 
1489     function _approve(
1490         address owner,
1491         address spender,
1492         uint256 amount
1493     ) internal override virtual {
1494         require(owner != address(0), "ERC20: approve from the zero address");
1495         require(spender != address(0), "ERC20: approve to the zero address");
1496 
1497         _allowances[owner][spender] = amount;
1498         emit Approval(owner, spender, amount);
1499     }
1500 
1501     function _spendAllowance(
1502         address owner,
1503         address spender,
1504         uint256 amount
1505     ) internal override virtual {
1506         uint256 currentAllowance = allowance(owner, spender);
1507         if (currentAllowance != type(uint256).max) {
1508             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1509             unchecked {
1510                 _approve(owner, spender, currentAllowance - amount);
1511             }
1512         }
1513     }
1514 
1515     receive() payable external {}
1516 
1517    function swapAndLiquify(uint256 contractTokenBalance) private {
1518 
1519         uint256 quater = contractTokenBalance / 4;
1520         uint256 threeQuaters = contractTokenBalance - quater;
1521 
1522         uint256 initialBalance = address(this).balance;
1523 
1524         swapTokensForEth(threeQuaters);
1525 
1526         uint256 newBalance = address(this).balance - initialBalance;
1527 
1528         uint256 newBalanceQuater = newBalance / 3;
1529 
1530         addLiquidity(quater, newBalanceQuater);
1531         _projectWallet.call{value: newBalance - newBalanceQuater}("");
1532 
1533         emit SwapAndLiquify(threeQuaters / 3, newBalanceQuater, quater);
1534 
1535     }
1536 
1537     function swapTokensForEth(uint256 tokenAmount) internal {
1538         address[] memory path = new address[](2);
1539         path[0] = address(this);
1540         path[1] = uniswapV2Router.WETH();
1541 
1542         _approve(address(this), 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, tokenAmount);
1543         _approve(address(this), uniswapV2Pair, tokenAmount);
1544 
1545         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1546             tokenAmount,
1547             0, 
1548             path,
1549             address(this),
1550             block.timestamp
1551         );
1552     }
1553 
1554     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1555 
1556         _approve(address(this), 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, tokenAmount);
1557         _approve(address(this), uniswapV2Pair, tokenAmount);
1558 
1559 
1560         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1561             address(this),
1562             tokenAmount,
1563             0, 
1564             0, 
1565             0x000000000000000000000000000000000000dEaD,
1566             block.timestamp
1567         );
1568     }
1569 
1570 }