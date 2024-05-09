1 /**
2 Multi-Chain Capital Inu: $MCCInu
3 
4 
5 Tokenomics:
6 5% of each buy/sell goes to existing holders.
7 5% of each buy/sell goes into farming development
8 
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 pragma solidity ^0.8.4;
13 
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 pragma solidity ^0.8.0;
95 
96 // CAUTION
97 // This version of SafeMath should only be used with Solidity 0.8 or later,
98 // because it relies on the compiler's built in overflow checks.
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations.
102  *
103  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
104  * now has built in overflow checking.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, with an overflow flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             uint256 c = a + b;
115             if (c < a) return (false, 0);
116             return (true, c);
117         }
118     }
119 
120     /**
121      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             if (b > a) return (false, 0);
128             return (true, a - b);
129         }
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140             // benefit is lost if 'b' is also tested.
141             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
142             if (a == 0) return (true, 0);
143             uint256 c = a * b;
144             if (c / a != b) return (false, 0);
145             return (true, c);
146         }
147     }
148 
149     /**
150      * @dev Returns the division of two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         unchecked {
156             if (b == 0) return (false, 0);
157             return (true, a / b);
158         }
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
163      *
164      * _Available since v3.4._
165      */
166     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         unchecked {
168             if (b == 0) return (false, 0);
169             return (true, a % b);
170         }
171     }
172 
173     /**
174      * @dev Returns the addition of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `+` operator.
178      *
179      * Requirements:
180      *
181      * - Addition cannot overflow.
182      */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a + b;
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting on
189      * overflow (when the result is negative).
190      *
191      * Counterpart to Solidity's `-` operator.
192      *
193      * Requirements:
194      *
195      * - Subtraction cannot overflow.
196      */
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a - b;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a * b;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers, reverting on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator.
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a / b;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * reverting when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return a % b;
243     }
244 
245     /**
246      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
247      * overflow (when the result is negative).
248      *
249      * CAUTION: This function is deprecated because it requires allocating memory for the error
250      * message unnecessarily. For custom revert reasons use {trySub}.
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      *
256      * - Subtraction cannot overflow.
257      */
258     function sub(
259         uint256 a,
260         uint256 b,
261         string memory errorMessage
262     ) internal pure returns (uint256) {
263         unchecked {
264             require(b <= a, errorMessage);
265             return a - b;
266         }
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(
282         uint256 a,
283         uint256 b,
284         string memory errorMessage
285     ) internal pure returns (uint256) {
286         unchecked {
287             require(b > 0, errorMessage);
288             return a / b;
289         }
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
294      * reverting with custom message when dividing by zero.
295      *
296      * CAUTION: This function is deprecated because it requires allocating memory for the error
297      * message unnecessarily. For custom revert reasons use {tryMod}.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         unchecked {
313             require(b > 0, errorMessage);
314             return a % b;
315         }
316     }
317 }
318 
319 /*
320  * @dev Provides information about the current execution context, including the
321  * sender of the transaction and its data. While these are generally available
322  * via msg.sender and msg.data, they should not be accessed in such a direct
323  * manner, since when dealing with meta-transactions the account sending and
324  * paying for execution may not be the actual sender (as far as an application
325  * is concerned).
326  *
327  * This contract is only required for intermediate, library-like contracts.
328  */
329 abstract contract Context {
330     function _msgSender() internal view virtual returns (address) {
331         return msg.sender;
332     }
333 
334     function _msgData() internal view virtual returns (bytes calldata) {
335         return msg.data;
336     }
337 }
338 
339 /**
340  * @dev Contract module which provides a basic access control mechanism, where
341  * there is an account (an owner) that can be granted exclusive access to
342  * specific functions.
343  *
344  * By default, the owner account will be the one that deploys the contract. This
345  * can later be changed with {transferOwnership}.
346  *
347  * This module is used through inheritance. It will make available the modifier
348  * `onlyOwner`, which can be applied to your functions to restrict their use to
349  * the owner.
350  */
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     /**
357      * @dev Initializes the contract setting the deployer as the initial owner.
358      */
359     constructor() {
360         _setOwner(_msgSender());
361     }
362 
363     /**
364      * @dev Returns the address of the current owner.
365      */
366     function owner() public view virtual returns (address) {
367         return _owner;
368     }
369 
370     /**
371      * @dev Throws if called by any account other than the owner.
372      */
373     modifier onlyOwner() {
374         require(owner() == _msgSender(), "Ownable: caller is not the owner");
375         _;
376     }
377 
378     /**
379      * @dev Leaves the contract without owner. It will not be possible to call
380      * `onlyOwner` functions anymore. Can only be called by the current owner.
381      *
382      * NOTE: Renouncing ownership will leave the contract without an owner,
383      * thereby removing any functionality that is only available to the owner.
384      */
385     function renounceOwnership() public virtual onlyOwner {
386         _setOwner(address(0));
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      * Can only be called by the current owner.
392      */
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         _setOwner(newOwner);
396     }
397 
398     function _setOwner(address newOwner) private {
399         address oldOwner = _owner;
400         _owner = newOwner;
401         emit OwnershipTransferred(oldOwner, newOwner);
402     }
403 }
404 
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize, which returns 0 for contracts in
431         // construction, since the code is only stored at the end of the
432         // constructor execution.
433 
434         uint256 size;
435         assembly {
436             size := extcodesize(account)
437         }
438         return size > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         (bool success, ) = recipient.call{value: amount}("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(address(this).balance >= value, "Address: insufficient balance for call");
532         require(isContract(target), "Address: call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.call{value: value}(data);
535         return _verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return _verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return _verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     function _verifyCallResult(
593         bool success,
594         bytes memory returndata,
595         string memory errorMessage
596     ) private pure returns (bytes memory) {
597         if (success) {
598             return returndata;
599         } else {
600             // Look for revert reason and bubble it up if present
601             if (returndata.length > 0) {
602                 // The easiest way to bubble the revert reason is using memory via assembly
603 
604                 assembly {
605                     let returndata_size := mload(returndata)
606                     revert(add(32, returndata), returndata_size)
607                 }
608             } else {
609                 revert(errorMessage);
610             }
611         }
612     }
613 }
614 
615 pragma solidity >=0.5.0;
616 
617 interface IUniswapV2Factory {
618     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
619 
620     function feeTo() external view returns (address);
621     function feeToSetter() external view returns (address);
622 
623     function getPair(address tokenA, address tokenB) external view returns (address pair);
624     function allPairs(uint) external view returns (address pair);
625     function allPairsLength() external view returns (uint);
626 
627     function createPair(address tokenA, address tokenB) external returns (address pair);
628 
629     function setFeeTo(address) external;
630     function setFeeToSetter(address) external;
631 }
632 
633 pragma solidity >=0.5.0;
634 
635 interface IUniswapV2Pair {
636     event Approval(address indexed owner, address indexed spender, uint value);
637     event Transfer(address indexed from, address indexed to, uint value);
638 
639     function name() external pure returns (string memory);
640     function symbol() external pure returns (string memory);
641     function decimals() external pure returns (uint8);
642     function totalSupply() external view returns (uint);
643     function balanceOf(address owner) external view returns (uint);
644     function allowance(address owner, address spender) external view returns (uint);
645 
646     function approve(address spender, uint value) external returns (bool);
647     function transfer(address to, uint value) external returns (bool);
648     function transferFrom(address from, address to, uint value) external returns (bool);
649 
650     function DOMAIN_SEPARATOR() external view returns (bytes32);
651     function PERMIT_TYPEHASH() external pure returns (bytes32);
652     function nonces(address owner) external view returns (uint);
653 
654     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
655 
656     event Mint(address indexed sender, uint amount0, uint amount1);
657     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
658     event Swap(
659         address indexed sender,
660         uint amount0In,
661         uint amount1In,
662         uint amount0Out,
663         uint amount1Out,
664         address indexed to
665     );
666     event Sync(uint112 reserve0, uint112 reserve1);
667 
668     function MINIMUM_LIQUIDITY() external pure returns (uint);
669     function factory() external view returns (address);
670     function token0() external view returns (address);
671     function token1() external view returns (address);
672     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
673     function price0CumulativeLast() external view returns (uint);
674     function price1CumulativeLast() external view returns (uint);
675     function kLast() external view returns (uint);
676 
677     function mint(address to) external returns (uint liquidity);
678     function burn(address to) external returns (uint amount0, uint amount1);
679     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
680     function skim(address to) external;
681     function sync() external;
682 
683     function initialize(address, address) external;
684 }
685 
686 pragma solidity >=0.6.2;
687 
688 interface IUniswapV2Router01 {
689     function factory() external pure returns (address);
690     function WETH() external pure returns (address);
691 
692     function addLiquidity(
693         address tokenA,
694         address tokenB,
695         uint amountADesired,
696         uint amountBDesired,
697         uint amountAMin,
698         uint amountBMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountA, uint amountB, uint liquidity);
702     function addLiquidityETH(
703         address token,
704         uint amountTokenDesired,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline
709     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
710     function removeLiquidity(
711         address tokenA,
712         address tokenB,
713         uint liquidity,
714         uint amountAMin,
715         uint amountBMin,
716         address to,
717         uint deadline
718     ) external returns (uint amountA, uint amountB);
719     function removeLiquidityETH(
720         address token,
721         uint liquidity,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline
726     ) external returns (uint amountToken, uint amountETH);
727     function removeLiquidityWithPermit(
728         address tokenA,
729         address tokenB,
730         uint liquidity,
731         uint amountAMin,
732         uint amountBMin,
733         address to,
734         uint deadline,
735         bool approveMax, uint8 v, bytes32 r, bytes32 s
736     ) external returns (uint amountA, uint amountB);
737     function removeLiquidityETHWithPermit(
738         address token,
739         uint liquidity,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline,
744         bool approveMax, uint8 v, bytes32 r, bytes32 s
745     ) external returns (uint amountToken, uint amountETH);
746     function swapExactTokensForTokens(
747         uint amountIn,
748         uint amountOutMin,
749         address[] calldata path,
750         address to,
751         uint deadline
752     ) external returns (uint[] memory amounts);
753     function swapTokensForExactTokens(
754         uint amountOut,
755         uint amountInMax,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external returns (uint[] memory amounts);
760     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
761         external
762         payable
763         returns (uint[] memory amounts);
764     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
765         external
766         returns (uint[] memory amounts);
767     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
768         external
769         returns (uint[] memory amounts);
770     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
771         external
772         payable
773         returns (uint[] memory amounts);
774 
775     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
776     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
777     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
778     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
779     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
780 }
781 
782 interface IUniswapV2Router02 is IUniswapV2Router01 {
783     function removeLiquidityETHSupportingFeeOnTransferTokens(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline
790     ) external returns (uint amountETH);
791     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountETH);
800 
801     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
802         uint amountIn,
803         uint amountOutMin,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external;
808     function swapExactETHForTokensSupportingFeeOnTransferTokens(
809         uint amountOutMin,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external payable;
814     function swapExactTokensForETHSupportingFeeOnTransferTokens(
815         uint amountIn,
816         uint amountOutMin,
817         address[] calldata path,
818         address to,
819         uint deadline
820     ) external;
821 }
822 
823 // Contract implementation
824 contract MultiChainCapitalInu is Context, IERC20, Ownable {
825   using SafeMath for uint256;
826   using Address for address;
827 
828   mapping(address => uint256) private _rOwned;
829   mapping(address => uint256) private _tOwned;
830   mapping(address => mapping(address => uint256)) private _allowances;
831 
832   mapping(address => bool) private _isExcludedFromFee;
833 
834   mapping(address => bool) private _isExcluded;
835   address[] private _excluded;
836 
837   uint256 private constant MAX = ~uint256(0);
838   uint256 private _tTotal = 4206900000000 * 10**9;
839   uint256 private _rTotal = (MAX - (MAX % _tTotal));
840   uint256 private _tFeeTotal;
841 
842   string private _name = 'Multi-Chain Capital Inu';
843   string private _symbol = '$MCCINU';
844   uint8 private _decimals = 9;
845 
846   uint256 private _taxFee = 5;
847   uint256 private _teamFee = 5;
848   uint256 private _previousTaxFee = _taxFee;
849   uint256 private _previousTeamFee = _teamFee;
850 
851   address payable public _TeamWalletAddress;
852   address payable public _marketingWalletAddress;
853 
854   IUniswapV2Router02 public immutable uniswapV2Router;
855   address public immutable uniswapV2Pair;
856   mapping(address => bool) private _isUniswapPair;
857 
858   bool inSwap = false;
859   bool public swapEnabled = true;
860 
861   uint8 _sellTaxMultiplier = 1;
862 
863   uint256 private _maxTxAmount = 300000000000000e9;
864   // We will set a minimum amount of tokens to be swaped => 5M
865   uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
866 
867   struct AirdropReceiver {
868     address addy;
869     uint256 amount;
870   }
871 
872   event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
873   event SwapEnabledUpdated(bool enabled);
874 
875   modifier lockTheSwap() {
876     inSwap = true;
877     _;
878     inSwap = false;
879   }
880 
881   constructor(
882     address payable TeamWalletAddress,
883     address payable marketingWalletAddress
884   ) {
885     _TeamWalletAddress = TeamWalletAddress;
886     _marketingWalletAddress = marketingWalletAddress;
887     _rOwned[_msgSender()] = _rTotal;
888 
889     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
890       0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
891     ); // UniswapV2 for Ethereum network
892     // Create a uniswap pair for this new token
893     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
894       address(this),
895       _uniswapV2Router.WETH()
896     );
897 
898     // set the rest of the contract variables
899     uniswapV2Router = _uniswapV2Router;
900 
901     // Exclude owner and this contract from fee
902     _isExcludedFromFee[owner()] = true;
903     _isExcludedFromFee[address(this)] = true;
904 
905     emit Transfer(address(0), _msgSender(), _tTotal);
906   }
907 
908   function name() public view returns (string memory) {
909     return _name;
910   }
911 
912   function symbol() public view returns (string memory) {
913     return _symbol;
914   }
915 
916   function decimals() public view returns (uint8) {
917     return _decimals;
918   }
919 
920   function totalSupply() public view override returns (uint256) {
921     return _tTotal;
922   }
923 
924   function balanceOf(address account) public view override returns (uint256) {
925     if (_isExcluded[account]) return _tOwned[account];
926     return tokenFromReflection(_rOwned[account]);
927   }
928 
929   function transfer(address recipient, uint256 amount)
930     public
931     override
932     returns (bool)
933   {
934     _transfer(_msgSender(), recipient, amount);
935     return true;
936   }
937 
938   function allowance(address owner, address spender)
939     public
940     view
941     override
942     returns (uint256)
943   {
944     return _allowances[owner][spender];
945   }
946 
947   function approve(address spender, uint256 amount)
948     public
949     override
950     returns (bool)
951   {
952     _approve(_msgSender(), spender, amount);
953     return true;
954   }
955 
956   function transferFrom(
957     address sender,
958     address recipient,
959     uint256 amount
960   ) public override returns (bool) {
961     _transfer(sender, recipient, amount);
962     _approve(
963       sender,
964       _msgSender(),
965       _allowances[sender][_msgSender()].sub(
966         amount,
967         'ERC20: transfer amount exceeds allowance'
968       )
969     );
970     return true;
971   }
972 
973   function increaseAllowance(address spender, uint256 addedValue)
974     public
975     virtual
976     returns (bool)
977   {
978     _approve(
979       _msgSender(),
980       spender,
981       _allowances[_msgSender()][spender].add(addedValue)
982     );
983     return true;
984   }
985 
986   function decreaseAllowance(address spender, uint256 subtractedValue)
987     public
988     virtual
989     returns (bool)
990   {
991     _approve(
992       _msgSender(),
993       spender,
994       _allowances[_msgSender()][spender].sub(
995         subtractedValue,
996         'ERC20: decreased allowance below zero'
997       )
998     );
999     return true;
1000   }
1001 
1002   function isExcluded(address account) public view returns (bool) {
1003     return _isExcluded[account];
1004   }
1005 
1006   function setExcludeFromFee(address account, bool excluded)
1007     external
1008     onlyOwner
1009   {
1010     _isExcludedFromFee[account] = excluded;
1011   }
1012 
1013   function totalFees() public view returns (uint256) {
1014     return _tFeeTotal;
1015   }
1016 
1017   function deliver(uint256 tAmount) public {
1018     address sender = _msgSender();
1019     require(
1020       !_isExcluded[sender],
1021       'Excluded addresses cannot call this function'
1022     );
1023     (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1024     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1025     _rTotal = _rTotal.sub(rAmount);
1026     _tFeeTotal = _tFeeTotal.add(tAmount);
1027   }
1028 
1029   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1030     public
1031     view
1032     returns (uint256)
1033   {
1034     require(tAmount <= _tTotal, 'Amount must be less than supply');
1035     if (!deductTransferFee) {
1036       (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1037       return rAmount;
1038     } else {
1039       (, uint256 rTransferAmount, , , , ) = _getValues(tAmount, false);
1040       return rTransferAmount;
1041     }
1042   }
1043 
1044   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1045     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1046     uint256 currentRate = _getRate();
1047     return rAmount.div(currentRate);
1048   }
1049 
1050   function excludeAccount(address account) external onlyOwner {
1051     require(
1052       account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1053       'We can not exclude Uniswap router.'
1054     );
1055     require(!_isExcluded[account], 'Account is already excluded');
1056     if (_rOwned[account] > 0) {
1057       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1058     }
1059     _isExcluded[account] = true;
1060     _excluded.push(account);
1061   }
1062 
1063   function includeAccount(address account) external onlyOwner {
1064     require(_isExcluded[account], 'Account is already excluded');
1065     for (uint256 i = 0; i < _excluded.length; i++) {
1066       if (_excluded[i] == account) {
1067         _excluded[i] = _excluded[_excluded.length - 1];
1068         _tOwned[account] = 0;
1069         _isExcluded[account] = false;
1070         _excluded.pop();
1071         break;
1072       }
1073     }
1074   }
1075 
1076   function removeAllFee() private {
1077     if (_taxFee == 0 && _teamFee == 0) return;
1078 
1079     _previousTaxFee = _taxFee;
1080     _previousTeamFee = _teamFee;
1081 
1082     _taxFee = 0;
1083     _teamFee = 0;
1084   }
1085 
1086   function restoreAllFee() private {
1087     _taxFee = _previousTaxFee;
1088     _teamFee = _previousTeamFee;
1089   }
1090 
1091   function isExcludedFromFee(address account) public view returns (bool) {
1092     return _isExcludedFromFee[account];
1093   }
1094 
1095   function _approve(
1096     address owner,
1097     address spender,
1098     uint256 amount
1099   ) private {
1100     require(owner != address(0), 'ERC20: approve from the zero address');
1101     require(spender != address(0), 'ERC20: approve to the zero address');
1102 
1103     _allowances[owner][spender] = amount;
1104     emit Approval(owner, spender, amount);
1105   }
1106 
1107   function _transfer(
1108     address sender,
1109     address recipient,
1110     uint256 amount
1111   ) private {
1112     require(sender != address(0), 'ERC20: transfer from the zero address');
1113     require(recipient != address(0), 'ERC20: transfer to the zero address');
1114     require(amount > 0, 'Transfer amount must be greater than zero');
1115 
1116     if (sender != owner() && recipient != owner())
1117       require(
1118         amount <= _maxTxAmount,
1119         'Transfer amount exceeds the maxTxAmount.'
1120       );
1121 
1122     // is the token balance of this contract address over the min number of
1123     // tokens that we need to initiate a swap?
1124     // also, don't get caught in a circular team event.
1125     // also, don't swap if sender is uniswap pair.
1126     uint256 contractTokenBalance = balanceOf(address(this));
1127 
1128     if (contractTokenBalance >= _maxTxAmount) {
1129       contractTokenBalance = _maxTxAmount;
1130     }
1131 
1132     bool overMinTokenBalance = contractTokenBalance >=
1133       _numOfTokensToExchangeForTeam;
1134     if (
1135       !inSwap &&
1136       swapEnabled &&
1137       overMinTokenBalance &&
1138       (recipient == uniswapV2Pair || _isUniswapPair[recipient])
1139     ) {
1140       // We need to swap the current tokens to ETH and send to the team wallet
1141       swapTokensForEth(contractTokenBalance);
1142 
1143       uint256 contractETHBalance = address(this).balance;
1144       if (contractETHBalance > 0) {
1145         sendETHToTeam(address(this).balance);
1146       }
1147     }
1148 
1149     // indicates if fee should be deducted from transfer
1150     bool takeFee = false;
1151 
1152     // take fee only on swaps
1153     if (
1154       (sender == uniswapV2Pair ||
1155         recipient == uniswapV2Pair ||
1156         _isUniswapPair[recipient] ||
1157         _isUniswapPair[sender]) &&
1158       !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1159     ) {
1160       takeFee = true;
1161     }
1162 
1163     //transfer amount, it will take tax and team fee
1164     _tokenTransfer(sender, recipient, amount, takeFee);
1165   }
1166 
1167   function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1168     // generate the uniswap pair path of token -> weth
1169     address[] memory path = new address[](2);
1170     path[0] = address(this);
1171     path[1] = uniswapV2Router.WETH();
1172 
1173     _approve(address(this), address(uniswapV2Router), tokenAmount);
1174 
1175     // make the swap
1176     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1177       tokenAmount,
1178       0, // accept any amount of ETH
1179       path,
1180       address(this),
1181       block.timestamp
1182     );
1183   }
1184 
1185   function sendETHToTeam(uint256 amount) private {
1186     _TeamWalletAddress.call{ value: amount.div(2) }('');
1187     _marketingWalletAddress.call{ value: amount.div(2) }('');
1188   }
1189 
1190   // We are exposing these functions to be able to manual swap and send
1191   // in case the token is highly valued and 5M becomes too much
1192   function manualSwap() external onlyOwner {
1193     uint256 contractBalance = balanceOf(address(this));
1194     swapTokensForEth(contractBalance);
1195   }
1196 
1197   function manualSend() external onlyOwner {
1198     uint256 contractETHBalance = address(this).balance;
1199     sendETHToTeam(contractETHBalance);
1200   }
1201 
1202   function setSwapEnabled(bool enabled) external onlyOwner {
1203     swapEnabled = enabled;
1204   }
1205 
1206   function _tokenTransfer(
1207     address sender,
1208     address recipient,
1209     uint256 amount,
1210     bool takeFee
1211   ) private {
1212     if (!takeFee) removeAllFee();
1213 
1214     if (_isExcluded[sender] && !_isExcluded[recipient]) {
1215       _transferFromExcluded(sender, recipient, amount);
1216     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1217       _transferToExcluded(sender, recipient, amount);
1218     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1219       _transferBothExcluded(sender, recipient, amount);
1220     } else {
1221       _transferStandard(sender, recipient, amount);
1222     }
1223 
1224     if (!takeFee) restoreAllFee();
1225   }
1226 
1227   function _transferStandard(
1228     address sender,
1229     address recipient,
1230     uint256 tAmount
1231   ) private {
1232     (
1233       uint256 rAmount,
1234       uint256 rTransferAmount,
1235       uint256 rFee,
1236       uint256 tTransferAmount,
1237       uint256 tFee,
1238       uint256 tTeam
1239     ) = _getValues(tAmount, _isSelling(recipient));
1240     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1242     _takeTeam(tTeam);
1243     _reflectFee(rFee, tFee);
1244     emit Transfer(sender, recipient, tTransferAmount);
1245   }
1246 
1247   function _transferToExcluded(
1248     address sender,
1249     address recipient,
1250     uint256 tAmount
1251   ) private {
1252     (
1253       uint256 rAmount,
1254       uint256 rTransferAmount,
1255       uint256 rFee,
1256       uint256 tTransferAmount,
1257       uint256 tFee,
1258       uint256 tTeam
1259     ) = _getValues(tAmount, _isSelling(recipient));
1260     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1261     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1262     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1263     _takeTeam(tTeam);
1264     _reflectFee(rFee, tFee);
1265     emit Transfer(sender, recipient, tTransferAmount);
1266   }
1267 
1268   function _transferFromExcluded(
1269     address sender,
1270     address recipient,
1271     uint256 tAmount
1272   ) private {
1273     (
1274       uint256 rAmount,
1275       uint256 rTransferAmount,
1276       uint256 rFee,
1277       uint256 tTransferAmount,
1278       uint256 tFee,
1279       uint256 tTeam
1280     ) = _getValues(tAmount, _isSelling(recipient));
1281     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1282     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1283     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1284     _takeTeam(tTeam);
1285     _reflectFee(rFee, tFee);
1286     emit Transfer(sender, recipient, tTransferAmount);
1287   }
1288 
1289   function _transferBothExcluded(
1290     address sender,
1291     address recipient,
1292     uint256 tAmount
1293   ) private {
1294     (
1295       uint256 rAmount,
1296       uint256 rTransferAmount,
1297       uint256 rFee,
1298       uint256 tTransferAmount,
1299       uint256 tFee,
1300       uint256 tTeam
1301     ) = _getValues(tAmount, _isSelling(recipient));
1302     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1303     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1304     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1305     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1306     _takeTeam(tTeam);
1307     _reflectFee(rFee, tFee);
1308     emit Transfer(sender, recipient, tTransferAmount);
1309   }
1310 
1311   function _takeTeam(uint256 tTeam) private {
1312     uint256 currentRate = _getRate();
1313     uint256 rTeam = tTeam.mul(currentRate);
1314     _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1315     if (_isExcluded[address(this)])
1316       _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1317   }
1318 
1319   function _reflectFee(uint256 rFee, uint256 tFee) private {
1320     _rTotal = _rTotal.sub(rFee);
1321     _tFeeTotal = _tFeeTotal.add(tFee);
1322   }
1323 
1324   //to recieve ETH from uniswapV2Router when swaping
1325   receive() external payable {}
1326 
1327   function _getValues(uint256 tAmount, bool isSelling)
1328     private
1329     view
1330     returns (
1331       uint256,
1332       uint256,
1333       uint256,
1334       uint256,
1335       uint256,
1336       uint256
1337     )
1338   {
1339     (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
1340       tAmount,
1341       _taxFee,
1342       _teamFee,
1343       isSelling
1344     );
1345     uint256 currentRate = _getRate();
1346     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1347       tAmount,
1348       tFee,
1349       tTeam,
1350       currentRate
1351     );
1352     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1353   }
1354 
1355   function _getTValues(
1356     uint256 tAmount,
1357     uint256 taxFee,
1358     uint256 teamFee,
1359     bool isSelling
1360   )
1361     private
1362     view
1363     returns (
1364       uint256,
1365       uint256,
1366       uint256
1367     )
1368   {
1369     uint256 finalTax = isSelling ? taxFee.mul(_sellTaxMultiplier) : taxFee;
1370     uint256 finalTeam = isSelling ? teamFee.mul(_sellTaxMultiplier) : teamFee;
1371 
1372     uint256 tFee = tAmount.mul(finalTax).div(100);
1373     uint256 tTeam = tAmount.mul(finalTeam).div(100);
1374     uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1375     return (tTransferAmount, tFee, tTeam);
1376   }
1377 
1378   function _getRValues(
1379     uint256 tAmount,
1380     uint256 tFee,
1381     uint256 tTeam,
1382     uint256 currentRate
1383   )
1384     private
1385     pure
1386     returns (
1387       uint256,
1388       uint256,
1389       uint256
1390     )
1391   {
1392     uint256 rAmount = tAmount.mul(currentRate);
1393     uint256 rFee = tFee.mul(currentRate);
1394     uint256 rTeam = tTeam.mul(currentRate);
1395     uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1396     return (rAmount, rTransferAmount, rFee);
1397   }
1398 
1399   function _getRate() private view returns (uint256) {
1400     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1401     return rSupply.div(tSupply);
1402   }
1403 
1404   function _getCurrentSupply() private view returns (uint256, uint256) {
1405     uint256 rSupply = _rTotal;
1406     uint256 tSupply = _tTotal;
1407     for (uint256 i = 0; i < _excluded.length; i++) {
1408       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1409         return (_rTotal, _tTotal);
1410       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1411       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1412     }
1413     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1414     return (rSupply, tSupply);
1415   }
1416 
1417   function _getTaxFee() private view returns (uint256) {
1418     return _taxFee;
1419   }
1420 
1421   function _getMaxTxAmount() private view returns (uint256) {
1422     return _maxTxAmount;
1423   }
1424 
1425   function _isSelling(address recipient) private view returns (bool) {
1426     return recipient == uniswapV2Pair || _isUniswapPair[recipient];
1427   }
1428 
1429   function _getETHBalance() public view returns (uint256 balance) {
1430     return address(this).balance;
1431   }
1432 
1433   function _setTaxFee(uint256 taxFee) external onlyOwner {
1434     require(taxFee <= 5, 'taxFee should be in 0 - 5');
1435     _taxFee = taxFee;
1436   }
1437 
1438   function _setTeamFee(uint256 teamFee) external onlyOwner {
1439     require(teamFee <= 5, 'teamFee should be in 0 - 5');
1440     _teamFee = teamFee;
1441   }
1442 
1443   function _setSellTaxMultiplier(uint8 mult) external onlyOwner {
1444     require(mult >= 1 && mult <= 3, 'multiplier should be in 1 - 3');
1445     _sellTaxMultiplier = mult;
1446   }
1447 
1448   function _setTeamWallet(address payable TeamWalletAddress) external onlyOwner {
1449     _TeamWalletAddress = TeamWalletAddress;
1450   }
1451 
1452   function _setMarketingWallet(address payable marketingWalletAddress)
1453     external
1454     onlyOwner
1455   {
1456     _marketingWalletAddress = marketingWalletAddress;
1457   }
1458 
1459   function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1460     require(
1461       maxTxAmount >= 100000000000000e9,
1462       'maxTxAmount should be greater than 100000000000000e9'
1463     );
1464     _maxTxAmount = maxTxAmount;
1465   }
1466 
1467   function isUniswapPair(address _pair) external view returns (bool) {
1468     if (_pair == uniswapV2Pair) return true;
1469     return _isUniswapPair[_pair];
1470   }
1471 
1472   function addUniswapPair(address _pair) external onlyOwner {
1473     _isUniswapPair[_pair] = true;
1474   }
1475 
1476   function removeUniswapPair(address _pair) external onlyOwner {
1477     _isUniswapPair[_pair] = false;
1478   }
1479 
1480   function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner {
1481     for (uint256 _i = 0; _i < recipients.length; _i++) {
1482       AirdropReceiver memory _user = recipients[_i];
1483       transferFrom(msg.sender, _user.addy, _user.amount);
1484     }
1485   }
1486 }