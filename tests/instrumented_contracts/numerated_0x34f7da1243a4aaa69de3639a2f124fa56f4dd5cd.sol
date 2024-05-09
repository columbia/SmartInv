1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-18
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 
8 pragma solidity 0.8.16;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 
90 /**
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         assembly {
208             size := extcodesize(account)
209         }
210         return size > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
366      * revert reason using the provided one.
367      *
368      * _Available since v4.3._
369      */
370     function verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) internal pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 
394 /**
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 
405 
406 // CAUTION
407 // This version of SafeMath should only be used with Solidity 0.8 or later,
408 // because it relies on the compiler's built in overflow checks.
409 
410 /**
411  * @dev Wrappers over Solidity's arithmetic operations.
412  *
413  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
414  * now has built in overflow checking.
415  */
416 library SafeMath {
417     /**
418      * @dev Returns the addition of two unsigned integers, with an overflow flag.
419      *
420      * _Available since v3.4._
421      */
422     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
423         unchecked {
424             uint256 c = a + b;
425             if (c < a) return (false, 0);
426             return (true, c);
427         }
428     }
429 
430     /**
431      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
432      *
433      * _Available since v3.4._
434      */
435     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
436         unchecked {
437             if (b > a) return (false, 0);
438             return (true, a - b);
439         }
440     }
441 
442     /**
443      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
444      *
445      * _Available since v3.4._
446      */
447     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
448         unchecked {
449             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
450             // benefit is lost if 'b' is also tested.
451             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
452             if (a == 0) return (true, 0);
453             uint256 c = a * b;
454             if (c / a != b) return (false, 0);
455             return (true, c);
456         }
457     }
458 
459     /**
460      * @dev Returns the division of two unsigned integers, with a division by zero flag.
461      *
462      * _Available since v3.4._
463      */
464     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
465         unchecked {
466             if (b == 0) return (false, 0);
467             return (true, a / b);
468         }
469     }
470 
471     /**
472      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
473      *
474      * _Available since v3.4._
475      */
476     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
477         unchecked {
478             if (b == 0) return (false, 0);
479             return (true, a % b);
480         }
481     }
482 
483     /**
484      * @dev Returns the addition of two unsigned integers, reverting on
485      * overflow.
486      *
487      * Counterpart to Solidity's `+` operator.
488      *
489      * Requirements:
490      *
491      * - Addition cannot overflow.
492      */
493     function add(uint256 a, uint256 b) internal pure returns (uint256) {
494         return a + b;
495     }
496 
497     /**
498      * @dev Returns the subtraction of two unsigned integers, reverting on
499      * overflow (when the result is negative).
500      *
501      * Counterpart to Solidity's `-` operator.
502      *
503      * Requirements:
504      *
505      * - Subtraction cannot overflow.
506      */
507     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
508         return a - b;
509     }
510 
511     /**
512      * @dev Returns the multiplication of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `*` operator.
516      *
517      * Requirements:
518      *
519      * - Multiplication cannot overflow.
520      */
521     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522         return a * b;
523     }
524 
525     /**
526      * @dev Returns the integer division of two unsigned integers, reverting on
527      * division by zero. The result is rounded towards zero.
528      *
529      * Counterpart to Solidity's `/` operator.
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function div(uint256 a, uint256 b) internal pure returns (uint256) {
536         return a / b;
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
541      * reverting when dividing by zero.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
552         return a % b;
553     }
554 
555     /**
556      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
557      * overflow (when the result is negative).
558      *
559      * CAUTION: This function is deprecated because it requires allocating memory for the error
560      * message unnecessarily. For custom revert reasons use {trySub}.
561      *
562      * Counterpart to Solidity's `-` operator.
563      *
564      * Requirements:
565      *
566      * - Subtraction cannot overflow.
567      */
568     function sub(
569         uint256 a,
570         uint256 b,
571         string memory errorMessage
572     ) internal pure returns (uint256) {
573         unchecked {
574             require(b <= a, errorMessage);
575             return a - b;
576         }
577     }
578 
579     /**
580      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
581      * division by zero. The result is rounded towards zero.
582      *
583      * Counterpart to Solidity's `/` operator. Note: this function uses a
584      * `revert` opcode (which leaves remaining gas untouched) while Solidity
585      * uses an invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function div(
592         uint256 a,
593         uint256 b,
594         string memory errorMessage
595     ) internal pure returns (uint256) {
596         unchecked {
597             require(b > 0, errorMessage);
598             return a / b;
599         }
600     }
601 
602     /**
603      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
604      * reverting with custom message when dividing by zero.
605      *
606      * CAUTION: This function is deprecated because it requires allocating memory for the error
607      * message unnecessarily. For custom revert reasons use {tryMod}.
608      *
609      * Counterpart to Solidity's `%` operator. This function uses a `revert`
610      * opcode (which leaves remaining gas untouched) while Solidity uses an
611      * invalid opcode to revert (consuming all remaining gas).
612      *
613      * Requirements:
614      *
615      * - The divisor cannot be zero.
616      */
617     function mod(
618         uint256 a,
619         uint256 b,
620         string memory errorMessage
621     ) internal pure returns (uint256) {
622         unchecked {
623             require(b > 0, errorMessage);
624             return a % b;
625         }
626     }
627 }
628 
629 interface IUniswapV2Factory {
630     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
631 
632     function feeTo() external view returns (address);
633     function feeToSetter() external view returns (address);
634 
635     function getPair(address tokenA, address tokenB) external view returns (address pair);
636     function allPairs(uint) external view returns (address pair);
637     function allPairsLength() external view returns (uint);
638 
639     function createPair(address tokenA, address tokenB) external returns (address pair);
640 
641     function setFeeTo(address) external;
642     function setFeeToSetter(address) external;
643 }
644 
645 interface IUniswapV2Pair {
646     event Approval(address indexed owner, address indexed spender, uint value);
647     event Transfer(address indexed from, address indexed to, uint value);
648 
649     function name() external pure returns (string memory);
650     function symbol() external pure returns (string memory);
651     function decimals() external pure returns (uint8);
652     function totalSupply() external view returns (uint);
653     function balanceOf(address owner) external view returns (uint);
654     function allowance(address owner, address spender) external view returns (uint);
655 
656     function approve(address spender, uint value) external returns (bool);
657     function transfer(address to, uint value) external returns (bool);
658     function transferFrom(address from, address to, uint value) external returns (bool);
659 
660     function DOMAIN_SEPARATOR() external view returns (bytes32);
661     function PERMIT_TYPEHASH() external pure returns (bytes32);
662     function nonces(address owner) external view returns (uint);
663 
664     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
665 
666     event Mint(address indexed sender, uint amount0, uint amount1);
667     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
668     event Swap(
669         address indexed sender,
670         uint amount0In,
671         uint amount1In,
672         uint amount0Out,
673         uint amount1Out,
674         address indexed to
675     );
676     event Sync(uint112 reserve0, uint112 reserve1);
677 
678     function MINIMUM_LIQUIDITY() external pure returns (uint);
679     function factory() external view returns (address);
680     function token0() external view returns (address);
681     function token1() external view returns (address);
682     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
683     function price0CumulativeLast() external view returns (uint);
684     function price1CumulativeLast() external view returns (uint);
685     function kLast() external view returns (uint);
686 
687     function mint(address to) external returns (uint liquidity);
688     function burn(address to) external returns (uint amount0, uint amount1);
689     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
690     function skim(address to) external;
691     function sync() external;
692 
693     function initialize(address, address) external;
694 }
695 
696 interface IUniswapV2Router01 {
697     function factory() external pure returns (address);
698     function WETH() external pure returns (address);
699 
700     function addLiquidity(
701         address tokenA,
702         address tokenB,
703         uint amountADesired,
704         uint amountBDesired,
705         uint amountAMin,
706         uint amountBMin,
707         address to,
708         uint deadline
709     ) external returns (uint amountA, uint amountB, uint liquidity);
710     function addLiquidityETH(
711         address token,
712         uint amountTokenDesired,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline
717     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
718     function removeLiquidity(
719         address tokenA,
720         address tokenB,
721         uint liquidity,
722         uint amountAMin,
723         uint amountBMin,
724         address to,
725         uint deadline
726     ) external returns (uint amountA, uint amountB);
727     function removeLiquidityETH(
728         address token,
729         uint liquidity,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline
734     ) external returns (uint amountToken, uint amountETH);
735     function removeLiquidityWithPermit(
736         address tokenA,
737         address tokenB,
738         uint liquidity,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline,
743         bool approveMax, uint8 v, bytes32 r, bytes32 s
744     ) external returns (uint amountA, uint amountB);
745     function removeLiquidityETHWithPermit(
746         address token,
747         uint liquidity,
748         uint amountTokenMin,
749         uint amountETHMin,
750         address to,
751         uint deadline,
752         bool approveMax, uint8 v, bytes32 r, bytes32 s
753     ) external returns (uint amountToken, uint amountETH);
754     function swapExactTokensForTokens(
755         uint amountIn,
756         uint amountOutMin,
757         address[] calldata path,
758         address to,
759         uint deadline
760     ) external returns (uint[] memory amounts);
761     function swapTokensForExactTokens(
762         uint amountOut,
763         uint amountInMax,
764         address[] calldata path,
765         address to,
766         uint deadline
767     ) external returns (uint[] memory amounts);
768     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
769         external
770         payable
771         returns (uint[] memory amounts);
772     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
773         external
774         returns (uint[] memory amounts);
775     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
776         external
777         returns (uint[] memory amounts);
778     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
779         external
780         payable
781         returns (uint[] memory amounts);
782 
783     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
784     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
785     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
786     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
787     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
788 }
789 
790 interface IUniswapV2Router02 is IUniswapV2Router01 {
791     function removeLiquidityETHSupportingFeeOnTransferTokens(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline
798     ) external returns (uint amountETH);
799     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
800         address token,
801         uint liquidity,
802         uint amountTokenMin,
803         uint amountETHMin,
804         address to,
805         uint deadline,
806         bool approveMax, uint8 v, bytes32 r, bytes32 s
807     ) external returns (uint amountETH);
808 
809     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
810         uint amountIn,
811         uint amountOutMin,
812         address[] calldata path,
813         address to,
814         uint deadline
815     ) external;
816     function swapExactETHForTokensSupportingFeeOnTransferTokens(
817         uint amountOutMin,
818         address[] calldata path,
819         address to,
820         uint deadline
821     ) external payable;
822     function swapExactTokensForETHSupportingFeeOnTransferTokens(
823         uint amountIn,
824         uint amountOutMin,
825         address[] calldata path,
826         address to,
827         uint deadline
828     ) external;
829 }
830 
831 contract TESSERACT is Context, IERC20, Ownable {
832     using SafeMath for uint256;
833     using Address for address;
834 
835     mapping (address => uint256) private _rOwned;
836     mapping (address => uint256) private _tOwned;
837     mapping (address => mapping (address => uint256)) private _allowances;
838 
839     mapping (address => bool) private _isExcludedFromFee;
840     mapping (address => bool) private _isExcluded;
841     mapping(address => bool) private _isExcludedFromMaxTx;
842     address[] private _excluded;
843 
844     // Liquidity Pairs
845     mapping (address => bool) public _isPair;
846 
847     // Banned contracts
848     mapping (address => bool) public blackListAddress;
849  
850     uint256 private constant MAX = ~uint256(0);
851     uint256 private constant _tTotal = 5000000000 * 10**18;
852     uint256 private _rTotal = (MAX - (MAX % _tTotal));
853     uint256 private _tFeeTotal;
854 
855     string private constant _name = "TESSERACT";
856     string private constant _symbol = "TESS";
857     uint8 private constant _decimals = 18;
858 
859     // Wallets
860     address payable public _MarketingWalletAddress;
861     // Buy Fees
862     uint256 public _buyTaxFee = 2;
863     uint256 public _buyMarketingFee = 3;
864     uint256 public _buyLiquidityFee = 0;
865 
866     // Sell Fees
867     uint256 public _sellTaxFee = 0;
868     uint256 public _sellMarketingFee = 6;
869     uint256 public _sellLiquidityFee = 2;
870 
871     // Fees (Current)
872     uint256 private _taxFee;
873     uint256 private _MarketingFee;
874     uint256 private _liquidityFee;
875 
876     bool private _contractFeesEnabled = true;
877 
878     mapping (address => bool) private _isBlackListedBot;
879     address[] private _blackListedBots;
880 
881     function isBlacklisted(address account) public view returns (bool) {
882         return  _isBlackListedBot[account];
883     }
884 
885     IUniswapV2Router02 public uniswapV2Router;
886     address public uniswapV2Pair;
887     
888     bool private inSwapAndLiquify;
889     bool public swapAndLiquifyEnabled = true;
890     bool public swapEnabled = true;
891     
892     uint256 public _maxTxAmount = 200000000 * 10**18; // 10% of max supply 
893     uint256 public numTokensSellToAddToLiquidity = 5000000 *10**18;
894 
895     uint256 public maxWalletToken = 200000000 * (10**18); // 1%
896     uint256 public maxSellTransactionAmount = 50000000 * (10**18); //0.5 %
897     uint256 public maxBuyTransactionAmount = 50000000 * (10**18); // 0.6
898 
899     
900     // Events
901     event SwapAndLiquifyEnabledUpdated(bool enabled);
902     event SwapAndLiquify(
903         uint256 tokensSwapped,
904         uint256 ethReceived,
905         uint256 tokensIntoLiquidity
906     );
907     event NumTokensSellToAddToLiquidityUpdated(uint256 numTokensSellToAddToLiquidity);
908     event SetContractFeesEnabled(bool _bool);
909     event RouterSet(address _router);
910     event SetIsPair(address _address, bool _bool);
911     event SetIsBanned(address _address, bool _bool);
912     event SetSwapEnabled(bool enabled);
913     event SetMarketingWalletAddress(address _address);
914     event SetLiqWalletAddress(address _address);
915     event WithdrawalBNB(uint256 _amount, address to);
916     event WithdrawalToken(address _tokenAddr, uint256 _amount, address to);
917     
918     modifier lockTheSwap {
919         inSwapAndLiquify = true;
920         _;
921         inSwapAndLiquify = false;
922     }
923     
924     constructor() {
925         _rOwned[owner()] = _rTotal;
926         
927         _setRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
928         _MarketingWalletAddress = payable(0x788a6A12Ee53a87566f41e06b8f0FE09Acc2Cc3B);
929         
930         // Exclude owner, dev wallet, liq wallet, and this contract from fee
931         _isExcludedFromFee[owner()] = true;
932         _isExcludedFromFee[_MarketingWalletAddress] = true;
933         _isExcludedFromFee[address(this)] = true;
934 
935         // exclude from max tx
936         _isExcludedFromMaxTx[owner()] = true;
937         _isExcludedFromMaxTx[address(this)] = true;
938         _isExcludedFromMaxTx[_MarketingWalletAddress] = true;
939         
940         emit Transfer(address(0), owner(), _tTotal);
941     }
942 
943     function name() external pure returns (string memory) {
944         return _name;
945     }
946 
947     function symbol() external pure returns (string memory) {
948         return _symbol;
949     }
950 
951     function decimals() external pure returns (uint8) {
952         return _decimals;
953     }
954 
955     function totalSupply() external pure override returns (uint256) {
956         return _tTotal;
957     }
958 
959     function balanceOf(address account) public view override returns (uint256) {
960         if (_isExcluded[account]) return _tOwned[account];
961         return tokenFromReflection(_rOwned[account]);
962     }
963 
964     function transfer(address recipient, uint256 amount) external override returns (bool) {
965         require(!_isBlackListedBot[recipient], "You have no power here!");
966         require(!_isBlackListedBot[tx.origin], "You have no power here!");
967         _transfer(_msgSender(), recipient, amount);
968         return true;
969     }
970 
971     function allowance(address owner, address spender) external view override returns (uint256) {
972         return _allowances[owner][spender];
973     }
974 
975     function approve(address spender, uint256 amount) external override returns (bool) {
976         _approve(_msgSender(), spender, amount);
977         return true;
978     }
979 
980     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
981         require(!_isBlackListedBot[recipient], "You have no power here!");
982         require(!_isBlackListedBot[tx.origin], "You have no power here!");
983         _transfer(sender, recipient, amount);
984         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
985         return true;
986     }
987 
988     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
989         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
990         return true;
991     }
992 
993     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     function isExcludedFromReward(address account) external view returns (bool) {
999         return _isExcluded[account];
1000     }
1001 
1002     function totalFees() external view returns (uint256) {
1003         return _tFeeTotal;
1004     }
1005 
1006     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
1007         require(tAmount <= _tTotal, "Amount must be less than supply");
1008         if (!deductTransferFee) {
1009             (uint256 rAmount,,,,,,) = _getValues(tAmount);
1010             return rAmount;
1011         } else {
1012             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
1013             return rTransferAmount;
1014         }
1015     }
1016 
1017     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1018         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1019         uint256 currentRate =  _getRate();
1020         return rAmount.div(currentRate);
1021     }
1022 
1023     function excludeFromReward(address account) public onlyOwner() {
1024         require(!_isExcluded[account], "Account is already excluded");
1025         if(_rOwned[account] > 0) {
1026             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1027         }
1028         _isExcluded[account] = true;
1029         _excluded.push(account);
1030     }
1031 
1032     function includeInReward(address account) external onlyOwner() {
1033         require(_isExcluded[account], "Account is already included");
1034         for (uint256 i = 0; i < _excluded.length; i++) {
1035             if (_excluded[i] == account) {
1036                 _excluded[i] = _excluded[_excluded.length - 1];
1037                 _tOwned[account] = 0;
1038                 _isExcluded[account] = false;
1039                 _excluded.pop();
1040                 break;
1041             }
1042         }
1043     }
1044     
1045     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1046         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev) = _getValues(tAmount);
1047         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1048         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1049         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1050         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1051         _takeLiquidity(tLiquidity);
1052         _takedev(tdev);
1053         _reflectFee(rFee, tFee);
1054         emit Transfer(sender, recipient, tTransferAmount);
1055     }
1056     
1057     function excludeFromFee(address account) external onlyOwner {
1058         _isExcludedFromFee[account] = true;
1059     }
1060     
1061     function includeInFee(address account) external onlyOwner {
1062         _isExcludedFromFee[account] = false;
1063     }
1064 
1065     function setExcludeFromMaxTx(address _address, bool value) public onlyOwner { 
1066         _isExcludedFromMaxTx[_address] = value;
1067     }
1068 
1069     function isExcludedFromMaxTx(address account) public view returns(bool) {
1070         return _isExcludedFromMaxTx[account];
1071     }
1072     
1073     function setBuyFeePercent(uint256 taxFee, uint256 MarketingFee, uint256 liquidityFee) external onlyOwner() {
1074         _buyTaxFee = taxFee;
1075         _buyMarketingFee = MarketingFee;
1076         _buyLiquidityFee = liquidityFee;
1077     }
1078 
1079     function setSellFeePercent(uint256 taxFee, uint256 MarketingFee, uint256 liquidityFee) external onlyOwner() {
1080         _sellTaxFee = taxFee;
1081         _sellMarketingFee = MarketingFee;_sellMarketingFee = MarketingFee;
1082         _sellLiquidityFee = liquidityFee;
1083     }
1084 
1085     function setMaxWalletTokens(uint256 _maxToken) external onlyOwner {
1086   	    maxWalletToken = _maxToken * (10**18);
1087   	}
1088     
1089     function setMaxSelltx(uint256 _maxSellTxAmount) public onlyOwner {
1090         maxSellTransactionAmount = _maxSellTxAmount * 10**18;
1091     }
1092 
1093     function setMaxBuytx(uint256 _maxBuyTxAmount) public onlyOwner {
1094         maxBuyTransactionAmount = _maxBuyTxAmount * 10**18;
1095     }
1096 
1097     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner() {
1098         swapAndLiquifyEnabled = _enabled;
1099         emit SwapAndLiquifyEnabledUpdated(_enabled);
1100     }
1101     
1102     function setMarketingWalletAddress(address _address) external onlyOwner() {
1103         require(_address != address(0), "Error: MarketingWallet address cannot be zero address");
1104         _MarketingWalletAddress = payable(_address);
1105         emit SetMarketingWalletAddress(_address);
1106     }
1107     
1108     function setNumTokensSellToAddToLiquidity(uint256 _amount) external onlyOwner() {
1109         require(_amount > 0);
1110         numTokensSellToAddToLiquidity = _amount;
1111         emit NumTokensSellToAddToLiquidityUpdated(_amount);
1112     }
1113 
1114     
1115     function _setRouter(address _router) private {
1116         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1117         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1118         if(uniswapV2Pair == address(0))
1119             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1120         uniswapV2Router = _uniswapV2Router;
1121         setIsPair(uniswapV2Pair, true);
1122         emit RouterSet(_router);
1123     }
1124     
1125     function setRouter(address _router) external onlyOwner() {
1126         _setRouter(_router);
1127     }
1128     
1129     // to receive ETH from uniswapV2Router when swapping
1130     receive() external payable {}
1131 
1132     function _reflectFee(uint256 rFee, uint256 tFee) private {
1133         _rTotal = _rTotal.sub(rFee);
1134         _tFeeTotal = _tFeeTotal.add(tFee);
1135     }
1136 
1137     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1138         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev) = _getTValues(tAmount);
1139         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tdev, _getRate());
1140         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tdev);
1141     }
1142 
1143     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1144         uint256 tFee = calculateTaxFee(tAmount);
1145         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1146         uint256 tdev = calculateMarketingFee(tAmount);
1147         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tdev);
1148         return (tTransferAmount, tFee, tLiquidity, tdev);
1149     }
1150 
1151     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1152         uint256 rAmount = tAmount.mul(currentRate);
1153         uint256 rFee = tFee.mul(currentRate);
1154         uint256 rLiquidity = tLiquidity.mul(currentRate);
1155         uint256 rdev = tdev.mul(currentRate);
1156         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rdev);
1157         return (rAmount, rTransferAmount, rFee);
1158     }
1159 
1160     function _getRate() private view returns(uint256) {
1161         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1162         return rSupply.div(tSupply);
1163     }
1164 
1165     function _getCurrentSupply() private view returns(uint256, uint256) {
1166         uint256 rSupply = _rTotal;
1167         uint256 tSupply = _tTotal;      
1168         for (uint256 i = 0; i < _excluded.length; i++) {
1169             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1170             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1171             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1172         }
1173         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1174         return (rSupply, tSupply);
1175     }
1176     
1177     function _takeLiquidity(uint256 tLiquidity) private {
1178         uint256 currentRate =  _getRate();
1179         uint256 rLiquidity = tLiquidity.mul(currentRate);
1180         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1181         if(_isExcluded[address(this)])
1182             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1183     }
1184     
1185     function _takedev(uint256 tdev) private {
1186         uint256 currentRate =  _getRate();
1187         uint256 rdev = tdev.mul(currentRate);
1188         _rOwned[address(this)] = _rOwned[address(this)].add(rdev);
1189         if(_isExcluded[address(this)])
1190             _tOwned[address(this)] = _tOwned[address(this)].add(tdev);
1191     }
1192     
1193     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1194         return _amount.mul(_taxFee).div(
1195             10**2
1196         );
1197     }
1198 
1199     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1200         return _amount.mul(_MarketingFee).div(
1201             10**2
1202         );
1203     }
1204 
1205     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1206         return _amount.mul(_liquidityFee).div(
1207             10**2
1208         );
1209     }
1210     
1211     function removeAllFee() private {
1212         _taxFee = 0;
1213         _MarketingFee = 0;
1214         _liquidityFee = 0;
1215     }
1216     
1217     function isExcludedFromFee(address account) external view returns(bool) {
1218         return _isExcludedFromFee[account];
1219     }
1220 
1221     function _approve(address owner, address spender, uint256 amount) private {
1222         require(owner != address(0), "ERC20: approve from the zero address");
1223         require(spender != address(0), "ERC20: approve to the zero address");
1224 
1225         _allowances[owner][spender] = amount;
1226         emit Approval(owner, spender, amount);
1227     }
1228 
1229     function _transfer(
1230         address from,
1231         address to,
1232         uint256 amount
1233     ) private {
1234         require(from != address(0), "ERC20: transfer from the zero address");
1235         require(to != address(0), "ERC20: transfer to the zero address");
1236         require(amount > 0, "Transfer amount must be greater than zero");
1237         if(from != owner() && to != owner())
1238             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1239 
1240         if(blackListAddress[from] || blackListAddress[to]) {
1241             revert("Address is banned");
1242         }
1243 
1244         if (
1245             from != owner() &&
1246             to != owner() &&
1247             to != _MarketingWalletAddress &&
1248             to != address(0) &&
1249             to != address(0xdead) &&
1250             to != uniswapV2Pair
1251         ) {
1252 
1253             uint256 contractBalanceRecepient = balanceOf(to);
1254             require(
1255                 contractBalanceRecepient + amount <= maxWalletToken,
1256                 "Exceeds maximum wallet token amount."
1257             );
1258             
1259         }
1260 
1261         if(_isPair[from] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
1262             require(amount <= maxBuyTransactionAmount, "Buy transfer amount exceeds the maxBuyTransactionAmount.");
1263         }
1264 
1265         if(_isPair[to] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
1266             require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
1267         }
1268 
1269         // is the token balance of this contract address over the min number of
1270         // tokens that we need to initiate a swap + liquidity lock?
1271         // also, don't get caught in a circular liquidity event.
1272         // also, don't swap & liquify if sender is uniswap pair.
1273         uint256 contractTokenBalance = balanceOf(address(this));
1274         
1275         if(contractTokenBalance >= _maxTxAmount) {
1276             contractTokenBalance = _maxTxAmount;
1277         }
1278         
1279         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1280         if (
1281             overMinTokenBalance &&
1282             !inSwapAndLiquify &&
1283             _isPair[to] &&
1284             swapAndLiquifyEnabled &&
1285             !_isExcludedFromFee[from]
1286         ) {
1287             contractTokenBalance = numTokensSellToAddToLiquidity;
1288             swapAndLiquify(contractTokenBalance);
1289         }
1290         
1291         // Indicates if fee should be deducted from transfer
1292         bool takeFee = true;
1293 
1294         // Remove fees except for buying and selling
1295         if(!_isPair[from] && !_isPair[to]) {
1296             takeFee = false;
1297         }
1298 
1299         // Enable fees if contract fees are enabled and to or from is a contract
1300         if(_contractFeesEnabled && (from.isContract() || to.isContract())) {
1301             takeFee = true;
1302         }
1303 
1304         // If any account belongs to _isExcludedFromFee account then remove the fee
1305         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1306             takeFee = false;
1307         }
1308 
1309         // Set buy fees
1310         if(_isPair[from] || from.isContract()) {
1311             _taxFee = _buyTaxFee;
1312             _MarketingFee = _buyMarketingFee;
1313             _liquidityFee = _buyLiquidityFee;
1314         }
1315         
1316         // Set sell fees
1317         if(_isPair[to] || to.isContract()) {
1318             _taxFee = _sellTaxFee;
1319             _MarketingFee = _sellMarketingFee;
1320             _liquidityFee = _sellLiquidityFee;            
1321         }
1322         
1323         // Transfer amount, it will take tax, burn, liquidity fee
1324         _tokenTransfer(from,to,amount,takeFee);
1325     }
1326 
1327     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1328         uint256 combineFees = _liquidityFee.add(_MarketingFee);
1329         uint256 tokensForLiquidity = contractTokenBalance.mul(_liquidityFee).div(combineFees);
1330         uint256 tokensForMarketing = contractTokenBalance.sub(tokensForLiquidity);
1331         
1332         // split the contract balance into halves
1333         uint256 half = tokensForLiquidity.div(2);
1334         uint256 otherHalf = tokensForLiquidity.sub(half);
1335 
1336         // capture the contract's current ETH balance.
1337         // this is so that we can capture exactly the amount of ETH that the
1338         // swap creates, and not make the liquidity event include any ETH that
1339         // has been manually sent to the contract
1340         uint256 initialBalance = address(this).balance;
1341 
1342         // swap tokens for ETH
1343         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1344 
1345         // how much ETH did we just swap into?
1346         uint256 newBalance = address(this).balance.sub(initialBalance);
1347 
1348         // add liquidity to uniswap
1349         addLiquidity(otherHalf, newBalance);
1350         
1351         emit SwapAndLiquify(half, newBalance, otherHalf);
1352 
1353          uint256 contractBalance = address(this).balance;
1354         swapTokensForEth(tokensForMarketing);
1355         uint256 transferredBalance = address(this).balance.sub(contractBalance);
1356 
1357         payable(_MarketingWalletAddress).transfer(transferredBalance);
1358     }
1359 
1360     function swapTokensForEth(uint256 tokenAmount) private {
1361         // generate the uniswap pair path of token -> weth
1362         address[] memory path = new address[](2);
1363         path[0] = address(this);
1364         path[1] = uniswapV2Router.WETH();
1365 
1366         _approve(address(this), address(uniswapV2Router), tokenAmount);
1367 
1368         // make the swap
1369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1370             tokenAmount,
1371             0, // accept any amount of ETH
1372             path,
1373             address(this),
1374             block.timestamp
1375         );
1376     }
1377 
1378     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1379         // approve token transfer to cover all possible scenarios
1380         _approve(address(this), address(uniswapV2Router), tokenAmount);
1381 
1382         // add the liquidity
1383         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1384             address(this),
1385             tokenAmount,
1386             0, // slippage is unavoidable
1387             0, // slippage is unavoidable
1388             owner(),
1389             block.timestamp
1390         );
1391         emit Transfer(address(this), uniswapV2Pair, tokenAmount);
1392     }
1393 
1394     //this method is responsible for taking all fee, if takeFee is true
1395     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1396         if(!takeFee)
1397             removeAllFee();
1398         
1399         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1400             _transferFromExcluded(sender, recipient, amount);
1401         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1402             _transferToExcluded(sender, recipient, amount);
1403         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1404             _transferBothExcluded(sender, recipient, amount);
1405         } else {
1406             _transferStandard(sender, recipient, amount);
1407         }
1408     }
1409 
1410     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1411         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev) = _getValues(tAmount);
1412         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1413         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1414         _takeLiquidity(tLiquidity);
1415         _takedev(tdev);
1416         _reflectFee(rFee, tFee);
1417         emit Transfer(sender, recipient, tTransferAmount);
1418     }
1419 
1420     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1421         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev) = _getValues(tAmount);
1422         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1423         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1424         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1425         _takeLiquidity(tLiquidity);
1426         _takedev(tdev);
1427         _reflectFee(rFee, tFee);
1428         emit Transfer(sender, recipient, tTransferAmount);
1429     }
1430 
1431     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1432         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tdev) = _getValues(tAmount);
1433         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1434         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1435         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1436         _takeLiquidity(tLiquidity);
1437         _takedev(tdev);
1438         _reflectFee(rFee, tFee);
1439         emit Transfer(sender, recipient, tTransferAmount);
1440     }
1441 
1442     function setIsPair(address _address, bool value) public onlyOwner() {
1443         _isPair[_address] = value;
1444         emit SetIsPair(_address, value);
1445     }
1446 
1447     function setBlacklistAddress(address _address, bool value) external onlyOwner() {
1448         blackListAddress[_address] = value;
1449         emit SetIsBanned(_address, value);
1450     }
1451 
1452     function withdrawalToken(address _tokenAddr, uint _amount, address to) external onlyOwner() {
1453         IERC20 token = IERC20(_tokenAddr);
1454         token.transfer(to, _amount);
1455         emit WithdrawalToken(_tokenAddr, _amount, to);
1456     }
1457     
1458     function withdrawalstuckBalance(uint _amount, address to) external onlyOwner() {
1459         require(address(this).balance >= _amount);
1460         payable(to).transfer(_amount);
1461         
1462     }
1463 
1464     function setMaxTxAmount(uint256 _amount) external onlyOwner(){
1465         _maxTxAmount = _amount * (10**18);
1466     }
1467 
1468     /**
1469      * @dev Hook that is called before any transfer of tokens. This includes
1470      * minting and burning.
1471      *
1472      * Calling conditions:
1473      *
1474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1475      * will be to transferred to `to`.
1476      * - when `from` is zero, `amount` tokens will be minted for `to`.
1477      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1478      * - `from` and `to` are never both zero.
1479      *
1480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1481      */
1482     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1483     
1484 }