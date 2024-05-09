1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 pragma solidity ^0.8.0;
84 
85 // CAUTION
86 // This version of SafeMath should only be used with Solidity 0.8 or later,
87 // because it relies on the compiler's built in overflow checks.
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations.
91  *
92  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
93  * now has built in overflow checking.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             uint256 c = a + b;
104             if (c < a) return (false, 0);
105             return (true, c);
106         }
107     }
108 
109     /**
110      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             if (b > a) return (false, 0);
117             return (true, a - b);
118         }
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129             // benefit is lost if 'b' is also tested.
130             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131             if (a == 0) return (true, 0);
132             uint256 c = a * b;
133             if (c / a != b) return (false, 0);
134             return (true, c);
135         }
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b == 0) return (false, 0);
146             return (true, a / b);
147         }
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             if (b == 0) return (false, 0);
158             return (true, a % b);
159         }
160     }
161 
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a + b;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a - b;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a * b;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers, reverting on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator.
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a % b;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {trySub}.
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         unchecked {
253             require(b <= a, errorMessage);
254             return a - b;
255         }
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         unchecked {
276             require(b > 0, errorMessage);
277             return a / b;
278         }
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * reverting with custom message when dividing by zero.
284      *
285      * CAUTION: This function is deprecated because it requires allocating memory for the error
286      * message unnecessarily. For custom revert reasons use {tryMod}.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b > 0, errorMessage);
303             return a % b;
304         }
305     }
306 }
307 
308 pragma solidity ^0.8.0;
309 
310 /*
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         return msg.data;
327     }
328 }
329 
330 pragma solidity ^0.8.0;
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
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Collection of functions related to the address type
402  */
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies on extcodesize, which returns 0 for contracts in
423         // construction, since the code is only stored at the end of the
424         // constructor execution.
425 
426         uint256 size;
427         assembly {
428             size := extcodesize(account)
429         }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         (bool success, ) = recipient.call{value: amount}("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionCall(target, data, "Address: low-level call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
480      * `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(address(this).balance >= value, "Address: insufficient balance for call");
524         require(isContract(target), "Address: call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.call{value: value}(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return _verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         require(isContract(target), "Address: delegate call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.delegatecall(data);
581         return _verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     function _verifyCallResult(
585         bool success,
586         bytes memory returndata,
587         string memory errorMessage
588     ) private pure returns (bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 assembly {
597                     let returndata_size := mload(returndata)
598                     revert(add(32, returndata), returndata_size)
599                 }
600             } else {
601                 revert(errorMessage);
602             }
603         }
604     }
605 }
606 
607 pragma solidity >=0.5.0;
608 
609 interface IUniswapV2Factory {
610     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
611 
612     function feeTo() external view returns (address);
613     function feeToSetter() external view returns (address);
614 
615     function getPair(address tokenA, address tokenB) external view returns (address pair);
616     function allPairs(uint) external view returns (address pair);
617     function allPairsLength() external view returns (uint);
618 
619     function createPair(address tokenA, address tokenB) external returns (address pair);
620 
621     function setFeeTo(address) external;
622     function setFeeToSetter(address) external;
623 }
624 
625 pragma solidity >=0.5.0;
626 
627 interface IUniswapV2Pair {
628     event Approval(address indexed owner, address indexed spender, uint value);
629     event Transfer(address indexed from, address indexed to, uint value);
630 
631     function name() external pure returns (string memory);
632     function symbol() external pure returns (string memory);
633     function decimals() external pure returns (uint8);
634     function totalSupply() external view returns (uint);
635     function balanceOf(address owner) external view returns (uint);
636     function allowance(address owner, address spender) external view returns (uint);
637 
638     function approve(address spender, uint value) external returns (bool);
639     function transfer(address to, uint value) external returns (bool);
640     function transferFrom(address from, address to, uint value) external returns (bool);
641 
642     function DOMAIN_SEPARATOR() external view returns (bytes32);
643     function PERMIT_TYPEHASH() external pure returns (bytes32);
644     function nonces(address owner) external view returns (uint);
645 
646     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
647 
648     event Mint(address indexed sender, uint amount0, uint amount1);
649     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
650     event Swap(
651         address indexed sender,
652         uint amount0In,
653         uint amount1In,
654         uint amount0Out,
655         uint amount1Out,
656         address indexed to
657     );
658     event Sync(uint112 reserve0, uint112 reserve1);
659 
660     function MINIMUM_LIQUIDITY() external pure returns (uint);
661     function factory() external view returns (address);
662     function token0() external view returns (address);
663     function token1() external view returns (address);
664     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
665     function price0CumulativeLast() external view returns (uint);
666     function price1CumulativeLast() external view returns (uint);
667     function kLast() external view returns (uint);
668 
669     function mint(address to) external returns (uint liquidity);
670     function burn(address to) external returns (uint amount0, uint amount1);
671     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
672     function skim(address to) external;
673     function sync() external;
674 
675     function initialize(address, address) external;
676 }
677 
678 pragma solidity >=0.6.2;
679 
680 interface IUniswapV2Router01 {
681     function factory() external pure returns (address);
682     function WETH() external pure returns (address);
683 
684     function addLiquidity(
685         address tokenA,
686         address tokenB,
687         uint amountADesired,
688         uint amountBDesired,
689         uint amountAMin,
690         uint amountBMin,
691         address to,
692         uint deadline
693     ) external returns (uint amountA, uint amountB, uint liquidity);
694     function addLiquidityETH(
695         address token,
696         uint amountTokenDesired,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
702     function removeLiquidity(
703         address tokenA,
704         address tokenB,
705         uint liquidity,
706         uint amountAMin,
707         uint amountBMin,
708         address to,
709         uint deadline
710     ) external returns (uint amountA, uint amountB);
711     function removeLiquidityETH(
712         address token,
713         uint liquidity,
714         uint amountTokenMin,
715         uint amountETHMin,
716         address to,
717         uint deadline
718     ) external returns (uint amountToken, uint amountETH);
719     function removeLiquidityWithPermit(
720         address tokenA,
721         address tokenB,
722         uint liquidity,
723         uint amountAMin,
724         uint amountBMin,
725         address to,
726         uint deadline,
727         bool approveMax, uint8 v, bytes32 r, bytes32 s
728     ) external returns (uint amountA, uint amountB);
729     function removeLiquidityETHWithPermit(
730         address token,
731         uint liquidity,
732         uint amountTokenMin,
733         uint amountETHMin,
734         address to,
735         uint deadline,
736         bool approveMax, uint8 v, bytes32 r, bytes32 s
737     ) external returns (uint amountToken, uint amountETH);
738     function swapExactTokensForTokens(
739         uint amountIn,
740         uint amountOutMin,
741         address[] calldata path,
742         address to,
743         uint deadline
744     ) external returns (uint[] memory amounts);
745     function swapTokensForExactTokens(
746         uint amountOut,
747         uint amountInMax,
748         address[] calldata path,
749         address to,
750         uint deadline
751     ) external returns (uint[] memory amounts);
752     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
753         external
754         payable
755         returns (uint[] memory amounts);
756     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
757         external
758         returns (uint[] memory amounts);
759     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
760         external
761         returns (uint[] memory amounts);
762     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
763         external
764         payable
765         returns (uint[] memory amounts);
766 
767     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
768     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
769     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
770     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
771     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
772 }
773 
774 
775 
776 pragma solidity >=0.6.2;
777 
778 interface IUniswapV2Router02 is IUniswapV2Router01 {
779     function removeLiquidityETHSupportingFeeOnTransferTokens(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline
786     ) external returns (uint amountETH);
787     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
788         address token,
789         uint liquidity,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline,
794         bool approveMax, uint8 v, bytes32 r, bytes32 s
795     ) external returns (uint amountETH);
796 
797     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
798         uint amountIn,
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external;
804     function swapExactETHForTokensSupportingFeeOnTransferTokens(
805         uint amountOutMin,
806         address[] calldata path,
807         address to,
808         uint deadline
809     ) external payable;
810     function swapExactTokensForETHSupportingFeeOnTransferTokens(
811         uint amountIn,
812         uint amountOutMin,
813         address[] calldata path,
814         address to,
815         uint deadline
816     ) external;
817 }
818 
819 
820 
821 
822 pragma solidity ^0.8.4;
823 
824 contract Gotham is Context, IERC20, Ownable {
825     using SafeMath for uint256;
826     using Address for address;
827 
828     address payable public marketingAddress =
829     payable(0x8bA347Fdec5dd67e4Ae8D17267E50483a3355f94); // Marketing Address
830     address payable public treasuryAddress =
831     payable(0x449c5516Cbc556071dA417f072cC58D3D0f4651A); // Marketing Address
832     
833     address public immutable deadAddress =
834     0x000000000000000000000000000000000000dEaD;
835     mapping(address => uint256) private _rOwned;
836     mapping(address => uint256) private _tOwned;
837     mapping(address => mapping(address => uint256)) private _allowances;
838     mapping(address => bool) private _isSniper;
839     address[] private _confirmedSnipers;
840 
841     mapping(address => bool) private _isExcludedFromFee;
842     mapping(address => bool) private _isExcluded;
843     address[] private _excluded;
844 
845     uint256 private constant MAX = ~uint256(0);
846     uint256 private _tTotal = 1000000000 * 10**9;
847     uint256 private _rTotal = (MAX - (MAX % _tTotal));
848     uint256 private _tFeeTotal;
849 
850     string private _name = 'Gotham';
851     string private _symbol = 'Gotham';
852     uint8 private _decimals = 9;
853     
854     uint256 public buyTotalFees;
855     uint256 public buyMarketingFee;
856     uint256 public buyLiquidityFee;
857     uint256 public buyTreasuryFee;
858     uint256 private _previousbuyTotalFees;
859     uint256 private _previousbuyMarketingFee;
860     uint256 private _previousbuyLiquidityFee;
861     uint256 private _previousbuyTreasuryFee;
862 
863     uint256 public sellTotalFees;
864     uint256 public sellMarketingFee;
865     uint256 public sellLiquidityFee;
866     uint256 public sellTreasuryFee;
867     uint256 private _previoussellTotalFees;
868     uint256 private _previoussellMarketingFee;
869     uint256 private _previoussellLiquidityFee;
870     uint256 private _previoussellTreasuryFee;
871 
872     uint256 public tokensForMarketing;
873     uint256 public tokensForLiquidity;
874     uint256 public tokensForTreasury;
875 
876     uint256 public _taxFee = 5;
877     uint256 private _previousTaxFee = _taxFee;
878 
879     uint256 launchTime;
880     mapping (address => bool) public _isExcludedMaxTransactionAmount;
881     bool public limitsInEffect = true;
882   
883     uint256 public maxTransactionAmount;
884     uint256 public maxWallet;
885   
886 
887     IUniswapV2Router02 public uniswapV2Router;
888     address public uniswapV2Pair;
889 
890     bool inSwapAndLiquify;
891 
892     bool tradingOpen = false;
893 
894     event SwapETHForTokens(uint256 amountIn, address[] path);
895 
896     event SwapTokensForETH(uint256 amountIn, address[] path);
897 
898     modifier lockTheSwap() {
899         inSwapAndLiquify = true;
900         _;
901         inSwapAndLiquify = false;
902     }
903 
904     constructor() {
905         _rOwned[_msgSender()] = _rTotal;
906         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
907         maxWallet = _tTotal * 10 / 1000; // 1% maxWallet
908 
909         uint256 _buyMarketingFee = 2;
910         uint256 _buyLiquidityFee = 4;
911         uint256 _buyTreasuryFee = 1;
912 
913         uint256 _sellMarketingFee = 5;
914         uint256 _sellLiquidityFee = 4;
915         uint256 _sellTreasuryFee = 1;
916 
917         buyMarketingFee = _buyMarketingFee;
918         buyLiquidityFee = _buyLiquidityFee;
919         buyTreasuryFee = _buyTreasuryFee;
920         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
921 
922         sellMarketingFee = _sellMarketingFee;
923         sellLiquidityFee = _sellLiquidityFee;
924         sellTreasuryFee = _sellTreasuryFee;
925         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
926 
927 
928         emit Transfer(address(0), _msgSender(), _tTotal);
929     }
930 
931 
932     // remove limits after token is stable
933     function removeLimits() external onlyOwner returns (bool){
934         limitsInEffect = false;
935         return true;
936     }
937 
938     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
939         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
940         maxTransactionAmount = newNum * (10**9);
941     }
942 
943     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFees, uint256 _treasuryFee) external onlyOwner {
944         buyMarketingFee = _marketingFee;
945         buyLiquidityFee = _liquidityFees;
946         buyTreasuryFee = _treasuryFee;
947         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
948     }
949     
950     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFees, uint256 _treasuryFee) external onlyOwner {
951         sellMarketingFee = _marketingFee;
952         sellLiquidityFee = _liquidityFees;
953         sellTreasuryFee = _treasuryFee;
954         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
955     }
956 
957 
958     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
959         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
960         maxWallet = newNum * (10**9);
961     }
962 
963     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
964         _isExcludedMaxTransactionAmount[updAds] = isEx;
965     }
966 
967 
968     function initContract() external onlyOwner {
969         // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
970         // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
971         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
972             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
973         );
974         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
975             address(this),
976             _uniswapV2Router.WETH()
977         );
978 
979         uniswapV2Router = _uniswapV2Router;
980 
981         _isExcludedFromFee[owner()] = true;
982         _isExcludedFromFee[address(this)] = true;
983     }
984 
985     function openTrading() external onlyOwner {
986         _taxFee = _previousTaxFee;
987         tradingOpen = true;
988         launchTime = block.timestamp;
989     }
990 
991     function pauseTrading() external onlyOwner {
992         tradingOpen = false;
993     }
994 
995     function resumeTrading() external onlyOwner {
996         tradingOpen = true;
997     }
998 
999     function name() public view returns (string memory) {
1000         return _name;
1001     }
1002 
1003     function symbol() public view returns (string memory) {
1004         return _symbol;
1005     }
1006 
1007     function decimals() public view returns (uint8) {
1008         return _decimals;
1009     }
1010 
1011     function totalSupply() public view override returns (uint256) {
1012         return _tTotal;
1013     }
1014 
1015     function balanceOf(address account) public view override returns (uint256) {
1016         if (_isExcluded[account]) return _tOwned[account];
1017         return tokenFromReflection(_rOwned[account]);
1018     }
1019 
1020     function transfer(address recipient, uint256 amount)
1021         public
1022         override
1023         returns (bool)
1024     {
1025         _transfer(_msgSender(), recipient, amount);
1026         return true;
1027     }
1028 
1029     function allowance(
1030         address owner,
1031         address spender
1032     )
1033         public
1034         view
1035         override
1036         returns (uint256)
1037     {
1038         return _allowances[owner][spender];
1039     }
1040 
1041     function approve(
1042         address spender,
1043         uint256 amount
1044     )
1045         public
1046         override
1047         returns (bool)
1048     {
1049         _approve(_msgSender(), spender, amount);
1050         return true;
1051     }
1052 
1053     function transferFrom(
1054         address sender,
1055         address recipient,
1056         uint256 amount
1057     )
1058         public
1059         override
1060         returns (bool)
1061     {
1062         _transfer(sender, recipient, amount);
1063         _approve(
1064             sender,
1065             _msgSender(),
1066             _allowances[sender][_msgSender()].sub(
1067                 amount,
1068                 'ERC20: transfer amount exceeds allowance'
1069             )
1070         );
1071         return true;
1072     }
1073 
1074     function increaseAllowance(
1075         address spender,
1076         uint256 addedValue
1077     )
1078         public
1079         virtual
1080         returns (bool)
1081     {
1082         _approve(
1083             _msgSender(),
1084             spender,
1085             _allowances[_msgSender()][spender].add(addedValue)
1086         );
1087         return true;
1088     }
1089 
1090     function decreaseAllowance(address spender, uint256 subtractedValue)
1091     public
1092     virtual
1093     returns (bool)
1094     {
1095         _approve(
1096             _msgSender(),
1097             spender,
1098             _allowances[_msgSender()][spender].sub(
1099                 subtractedValue,
1100                 'ERC20: decreased allowance below zero'
1101             )
1102         );
1103         return true;
1104     }
1105 
1106     function isExcludedFromReward(address account) public view returns (bool) {
1107         return _isExcluded[account];
1108     }
1109 
1110     function totalFees() public view returns (uint256) {
1111         return _tFeeTotal;
1112     }
1113 
1114     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1115         require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1116         uint256 currentRate = _getRate();
1117         return rAmount.div(currentRate);
1118     }
1119 
1120     function excludeFromReward(address account) public onlyOwner {
1121         require(!_isExcluded[account], 'Account is already excluded');
1122         if (_rOwned[account] > 0) {
1123             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1124         }
1125         _isExcluded[account] = true;
1126         _excluded.push(account);
1127     }
1128 
1129     function includeInReward(address account) external onlyOwner {
1130         require(_isExcluded[account], 'Account is already excluded');
1131         for (uint256 i = 0; i < _excluded.length; i++) {
1132             if (_excluded[i] == account) {
1133                 _excluded[i] = _excluded[_excluded.length - 1];
1134                 _tOwned[account] = 0;
1135                 _isExcluded[account] = false;
1136                 _excluded.pop();
1137                 break;
1138             }
1139         }
1140     }
1141 
1142     function _approve(
1143         address owner,
1144         address spender,
1145         uint256 amount
1146     ) private {
1147         require(owner != address(0), 'ERC20: approve from the zero address');
1148         require(spender != address(0), 'ERC20: approve to the zero address');
1149 
1150         _allowances[owner][spender] = amount;
1151         emit Approval(owner, spender, amount);
1152     }
1153 
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 amount
1158     ) private {
1159         require(from != address(0), 'ERC20: transfer from the zero address');
1160         require(to != address(0), 'ERC20: transfer to the zero address');
1161         require(amount > 0, 'Transfer amount must be greater than zero');
1162         require(!_isSniper[to], 'You have no power here!');
1163         require(!_isSniper[msg.sender], 'You have no power here!');
1164 
1165 
1166         // buy
1167         if (
1168             from == uniswapV2Pair &&
1169             to != address(uniswapV2Router) &&
1170             !_isExcludedFromFee[to]
1171         ) {
1172             require(tradingOpen, 'Trading not yet enabled.');
1173 
1174             //antibot
1175             if (block.timestamp == launchTime) {
1176                 _isSniper[to] = true;
1177                 _confirmedSnipers.push(to);
1178             }
1179         }
1180 
1181         if(limitsInEffect){
1182             if (
1183                 from != owner() &&
1184                 to != owner() &&
1185                 to != address(0) &&
1186                 to != address(0xdead)
1187             ){
1188                 if(!tradingOpen){
1189                     require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active.");
1190                 }
1191 
1192                 //when buy
1193                 if (from == uniswapV2Pair && !_isExcludedMaxTransactionAmount[to]) {
1194                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1195                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1196                 }
1197 
1198                 //when sell
1199                 else if (to == uniswapV2Pair && !_isExcludedMaxTransactionAmount[from]) {
1200                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1201                 }
1202 
1203                 else if(!_isExcludedMaxTransactionAmount[to]){
1204                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1205                 }
1206             }
1207         }
1208 
1209         uint256 contractTokenBalance = balanceOf(address(this));
1210 
1211         //sell
1212 
1213         if (!inSwapAndLiquify && tradingOpen && to == uniswapV2Pair) {
1214             if (contractTokenBalance > 0) {       
1215                 swapTokens(contractTokenBalance);
1216             }
1217         }
1218 
1219         bool takeFee = false;
1220 
1221         //take fee only on swaps
1222         if (
1223             (from == uniswapV2Pair || to == uniswapV2Pair) &&
1224             !(_isExcludedFromFee[from] || _isExcludedFromFee[to])
1225         ) {
1226             takeFee = true;
1227         }
1228 
1229         //sell
1230         uint256 fees = 0;
1231         if (to == uniswapV2Pair){
1232             if (takeFee && tradingOpen){
1233                 fees = amount.mul(sellTotalFees).div(100);
1234                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1235                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
1236                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1237 
1238             }
1239             
1240             _tokenTransfer(from, to, amount, takeFee, true);
1241         }
1242         else{
1243             if (takeFee && tradingOpen){
1244                 fees = amount.mul(buyTotalFees).div(100);
1245                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1246                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
1247                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1248     
1249             }
1250             
1251             _tokenTransfer(from, to, amount, takeFee, false);
1252         }
1253     }
1254 
1255     function swapTokens(uint256 contractBalance) private lockTheSwap{
1256         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForTreasury;
1257         bool success;
1258         
1259         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1260         
1261         if(contractBalance > totalSupply() * 5 / 10000 * 20){
1262           contractBalance = totalSupply() * 5 / 10000 * 20;
1263         }
1264         // Halve the amount of liquidity tokens
1265         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1266         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1267         
1268         uint256 initialETHBalance = address(this).balance;
1269 
1270         swapTokensForEth(amountToSwapForETH); 
1271         
1272 
1273         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1274         
1275 
1276         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1277         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1278         
1279         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTreasury;
1280 
1281         
1282         tokensForLiquidity = 0;
1283         tokensForMarketing = 0;
1284         tokensForTreasury = 0;
1285         
1286         (success,) = address(treasuryAddress).call{value: ethForTreasury}("");
1287         
1288         if(liquidityTokens > 0 && ethForLiquidity > 0){
1289             addLiquidity(liquidityTokens, ethForLiquidity);
1290         }
1291         
1292         
1293         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1294     }
1295 
1296 
1297     function swapTokensForEth(uint256 tokenAmount) private {
1298         // generate the uniswap pair path of token -> weth
1299         address[] memory path = new address[](2);
1300         path[0] = address(this);
1301         path[1] = uniswapV2Router.WETH();
1302 
1303         _approve(address(this), address(uniswapV2Router), tokenAmount);
1304 
1305         // make the swap
1306         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1307             tokenAmount,
1308             0, // accept any amount of ETH
1309             path,
1310             address(this), // The contract
1311             block.timestamp
1312         );
1313 
1314         emit SwapTokensForETH(tokenAmount, path);
1315     }
1316 
1317     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1318         // approve token transfer to cover all possible scenarios
1319         _approve(address(this), address(uniswapV2Router), tokenAmount);
1320 
1321         // add the liquidity
1322         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
1323             address(this),
1324             tokenAmount,
1325             0, // slippage is unavoidable
1326             0, // slippage is unavoidable
1327             owner(),
1328             block.timestamp
1329         );
1330     }
1331 
1332     function _tokenTransfer(
1333         address sender,
1334         address recipient,
1335         uint256 amount,
1336         bool takeFee,
1337         bool isSell
1338     ) private {
1339         if (!takeFee) removeAllFee();
1340 
1341         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1342             _transferFromExcluded(sender, recipient, amount, isSell);
1343         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1344             _transferToExcluded(sender, recipient, amount, isSell);
1345         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1346             _transferBothExcluded(sender, recipient, amount, isSell);
1347         } else {
1348             _transferStandard(sender, recipient, amount, isSell);
1349         }
1350 
1351         if (!takeFee) restoreAllFee();
1352     }
1353 
1354     function _transferStandard(
1355         address sender,
1356         address recipient,
1357         uint256 tAmount,
1358         bool isSell
1359     ) private {
1360         (
1361         uint256 rAmount,
1362         uint256 rTransferAmount,
1363         uint256 rFee,
1364         uint256 tTransferAmount,
1365         uint256 tFee,
1366         uint256 tLiquidity
1367         ) = _getValues(tAmount, isSell);
1368         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1369         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1370         _takeLiquidity(tLiquidity);
1371         _reflectFee(rFee, tFee);
1372         emit Transfer(sender, recipient, tTransferAmount);
1373     }
1374 
1375     function _transferToExcluded(
1376         address sender,
1377         address recipient,
1378         uint256 tAmount,
1379         bool isSell
1380     ) private {
1381         (
1382         uint256 rAmount,
1383         uint256 rTransferAmount,
1384         uint256 rFee,
1385         uint256 tTransferAmount,
1386         uint256 tFee,
1387         uint256 tLiquidity
1388         ) = _getValues(tAmount, isSell);
1389         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1390         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1391         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1392         _takeLiquidity(tLiquidity);
1393         _reflectFee(rFee, tFee);
1394         emit Transfer(sender, recipient, tTransferAmount);
1395     }
1396 
1397     function _transferFromExcluded(
1398         address sender,
1399         address recipient,
1400         uint256 tAmount,
1401         bool isSell
1402     ) private {
1403         (
1404         uint256 rAmount,
1405         uint256 rTransferAmount,
1406         uint256 rFee,
1407         uint256 tTransferAmount,
1408         uint256 tFee,
1409         uint256 tLiquidity
1410         ) = _getValues(tAmount, isSell);
1411         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1412         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1413         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1414         _takeLiquidity(tLiquidity);
1415         _reflectFee(rFee, tFee);
1416         emit Transfer(sender, recipient, tTransferAmount);
1417     }
1418 
1419     function _transferBothExcluded(
1420         address sender,
1421         address recipient,
1422         uint256 tAmount,
1423         bool isSell
1424     ) private {
1425         (
1426         uint256 rAmount,
1427         uint256 rTransferAmount,
1428         uint256 rFee,
1429         uint256 tTransferAmount,
1430         uint256 tFee,
1431         uint256 tLiquidity
1432         ) = _getValues(tAmount, isSell);
1433         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1434         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1435         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1436         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1437         _takeLiquidity(tLiquidity);
1438         _reflectFee(rFee, tFee);
1439         emit Transfer(sender, recipient, tTransferAmount);
1440     }
1441 
1442     function _reflectFee(uint256 rFee, uint256 tFee) private {
1443         _rTotal = _rTotal.sub(rFee);
1444         _tFeeTotal = _tFeeTotal.add(tFee);
1445     }
1446 
1447     function _getValues(uint256 tAmount, bool isSell)
1448     private
1449     view
1450     returns (
1451         uint256,
1452         uint256,
1453         uint256,
1454         uint256,
1455         uint256,
1456         uint256
1457     )
1458     {
1459         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
1460             tAmount, isSell
1461         );
1462         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1463             tAmount,
1464             tFee,
1465             tLiquidity,
1466             _getRate()
1467         );
1468         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1469     }
1470 
1471     function _getTValues(uint256 tAmount, bool isSell)
1472     private
1473     view
1474     returns (
1475         uint256,
1476         uint256,
1477         uint256
1478     )
1479     {
1480         uint256 tFee = calculateTaxFee(tAmount);
1481         uint256 tLiquidity = calculateFee(tAmount, isSell);
1482         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1483         return (tTransferAmount, tFee, tLiquidity);
1484     }
1485 
1486     function _getRValues(
1487         uint256 tAmount,
1488         uint256 tFee,
1489         uint256 tLiquidity,
1490         uint256 currentRate
1491     )
1492     private
1493     pure
1494     returns (
1495         uint256,
1496         uint256,
1497         uint256
1498     )
1499     {
1500         uint256 rAmount = tAmount.mul(currentRate);
1501         uint256 rFee = tFee.mul(currentRate);
1502         uint256 rLiquidity = tLiquidity.mul(currentRate);
1503         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1504         return (rAmount, rTransferAmount, rFee);
1505     }
1506 
1507     function _getRate() private view returns (uint256) {
1508         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1509         return rSupply.div(tSupply);
1510     }
1511 
1512     function _getCurrentSupply() private view returns (uint256, uint256) {
1513         uint256 rSupply = _rTotal;
1514         uint256 tSupply = _tTotal;
1515         for (uint256 i = 0; i < _excluded.length; i++) {
1516             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1517                 return (_rTotal, _tTotal);
1518             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1519             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1520         }
1521         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1522         return (rSupply, tSupply);
1523     }
1524 
1525     function _takeLiquidity(uint256 tLiquidity) private {
1526         uint256 currentRate = _getRate();
1527         uint256 rLiquidity = tLiquidity.mul(currentRate);
1528         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1529         if (_isExcluded[address(this)])
1530             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1531     }
1532 
1533     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1534         return _amount.mul(_taxFee).div(10**2);
1535     }
1536 
1537     function calculateFee(uint256 _amount, bool isSell)
1538     private
1539     view
1540     returns (uint256)
1541     {
1542         if (isSell){
1543                 return _amount.mul(sellTotalFees).div(100);
1544         }
1545         else{
1546                 return _amount.mul(buyTotalFees).div(100);
1547         }
1548     }
1549 
1550     function removeAllFee() private {
1551 
1552         _previousbuyTotalFees = buyTotalFees;
1553         _previoussellTotalFees = sellTotalFees;
1554         _previousbuyLiquidityFee = buyLiquidityFee;
1555         _previoussellLiquidityFee = sellLiquidityFee;
1556         _previousbuyTreasuryFee = buyTreasuryFee;
1557         _previoussellTreasuryFee = sellTreasuryFee;
1558         _previousbuyMarketingFee = buyMarketingFee;
1559         _previoussellMarketingFee = sellMarketingFee;
1560 
1561         _previousTaxFee = _taxFee;
1562 
1563         _taxFee = 0;
1564         buyTotalFees = 0;
1565         sellTotalFees = 0;
1566         buyLiquidityFee = 0;
1567         sellLiquidityFee = 0;
1568         buyTreasuryFee = 0;
1569         sellTreasuryFee = 0;
1570         buyMarketingFee = 0;
1571         sellMarketingFee = 0;
1572     }
1573 
1574     function restoreAllFee() private {
1575         _taxFee = _previousTaxFee;
1576         
1577         buyTotalFees = _previousbuyTotalFees;
1578         sellTotalFees = _previoussellTotalFees;
1579         buyLiquidityFee = _previousbuyLiquidityFee;
1580         sellLiquidityFee = _previoussellLiquidityFee;
1581         buyTreasuryFee = _previousbuyTreasuryFee;
1582         sellTreasuryFee = _previoussellTreasuryFee;
1583         buyMarketingFee = _previousbuyMarketingFee;
1584         sellMarketingFee = _previoussellMarketingFee;
1585     }
1586 
1587     function isExcludedFromFee(address account) public view returns (bool) {
1588         return _isExcludedFromFee[account];
1589     }
1590 
1591     function excludeFromFee(address account) public onlyOwner {
1592         _isExcludedFromFee[account] = true;
1593     }
1594 
1595     function includeInFee(address account) public onlyOwner {
1596         _isExcludedFromFee[account] = false;
1597     }
1598 
1599     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1600         _taxFee = taxFee;
1601     }
1602 
1603 
1604     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1605         marketingAddress = payable(_marketingAddress);
1606     }
1607 
1608     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1609         treasuryAddress = payable(_treasuryAddress);
1610     }
1611 
1612 
1613     function isRemovedSniper(address account) public view returns (bool) {
1614         return _isSniper[account];
1615     }
1616 
1617     function _removeSniper(address account) external onlyOwner {
1618         require(
1619             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1620             'We can not blacklist Uniswap'
1621         );
1622         require(!_isSniper[account], 'Account is already blacklisted');
1623         _isSniper[account] = true;
1624         _confirmedSnipers.push(account);
1625     }
1626 
1627     function _amnestySniper(address account) external onlyOwner {
1628         require(_isSniper[account], 'Account is not blacklisted');
1629         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1630             if (_confirmedSnipers[i] == account) {
1631                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1632                 _isSniper[account] = false;
1633                 _confirmedSnipers.pop();
1634                 break;
1635             }
1636         }
1637     }
1638 
1639     //to recieve ETH from uniswapV2Router when swaping
1640     receive() external payable {}
1641 
1642     // Withdraw ETH that gets stuck in contract by accident
1643     function emergencyWithdraw() external onlyOwner {
1644         payable(owner()).send(address(this).balance);
1645     }
1646 }