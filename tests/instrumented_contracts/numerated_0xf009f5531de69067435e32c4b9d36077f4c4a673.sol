1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/GSN/Context.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: @openzeppelin/contracts/math/SafeMath.sol
115 
116 pragma solidity >=0.6.0 <0.8.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         uint256 c = a + b;
139         if (c < a) return (false, 0);
140         return (true, c);
141     }
142 
143     /**
144      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b > a) return (false, 0);
150         return (true, a - b);
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) return (true, 0);
163         uint256 c = a * b;
164         if (c / a != b) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the division of two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a / b);
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         if (b == 0) return (false, 0);
185         return (true, a % b);
186     }
187 
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b <= a, "SafeMath: subtraction overflow");
216         return a - b;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         if (a == 0) return 0;
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b > 0, "SafeMath: division by zero");
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: modulo by zero");
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         require(b <= a, errorMessage);
289         return a - b;
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * CAUTION: This function is deprecated because it requires allocating memory for the error
297      * message unnecessarily. For custom revert reasons use {tryDiv}.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function div(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         require(b > 0, errorMessage);
313         return a / b;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting with custom message when dividing by zero.
319      *
320      * CAUTION: This function is deprecated because it requires allocating memory for the error
321      * message unnecessarily. For custom revert reasons use {tryMod}.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         require(b > 0, errorMessage);
337         return a % b;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Address.sol
342 
343 pragma solidity >=0.6.2 <0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         // solhint-disable-next-line no-inline-assembly
373         assembly {
374             size := extcodesize(account)
375         }
376         return size > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{value: amount}("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, 0, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but also transferring `value` wei to `target`.
442      *
443      * Requirements:
444      *
445      * - the calling contract must have an ETH balance of at least `value`.
446      * - the called Solidity function must be `payable`.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value
454     ) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
460      * with `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(
465         address target,
466         bytes memory data,
467         uint256 value,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         require(address(this).balance >= value, "Address: insufficient balance for call");
471         require(isContract(target), "Address: call to non-contract");
472 
473         // solhint-disable-next-line avoid-low-level-calls
474         (bool success, bytes memory returndata) = target.call{value: value}(data);
475         return _verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
485         return functionStaticCall(target, data, "Address: low-level static call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a static call.
491      *
492      * _Available since v3.3._
493      */
494     function functionStaticCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal view returns (bytes memory) {
499         require(isContract(target), "Address: static call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) = target.staticcall(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a delegate call.
519      *
520      * _Available since v3.4._
521      */
522     function functionDelegateCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(isContract(target), "Address: delegate call to non-contract");
528 
529         // solhint-disable-next-line avoid-low-level-calls
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     function _verifyCallResult(
535         bool success,
536         bytes memory returndata,
537         string memory errorMessage
538     ) private pure returns (bytes memory) {
539         if (success) {
540             return returndata;
541         } else {
542             // Look for revert reason and bubble it up if present
543             if (returndata.length > 0) {
544                 // The easiest way to bubble the revert reason is using memory via assembly
545 
546                 // solhint-disable-next-line no-inline-assembly
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/access/Ownable.sol
559 
560 pragma solidity >=0.6.0 <0.8.0;
561 
562 /**
563  * @dev Contract module which provides a basic access control mechanism, where
564  * there is an account (an owner) that can be granted exclusive access to
565  * specific functions.
566  *
567  * By default, the owner account will be the one that deploys the contract. This
568  * can later be changed with {transferOwnership}.
569  *
570  * This module is used through inheritance. It will make available the modifier
571  * `onlyOwner`, which can be applied to your functions to restrict their use to
572  * the owner.
573  */
574 abstract contract Ownable is Context {
575     address private _owner;
576 
577     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
578 
579     /**
580      * @dev Initializes the contract setting the deployer as the initial owner.
581      */
582     constructor() internal {
583         address msgSender = _msgSender();
584         _owner = msgSender;
585         emit OwnershipTransferred(address(0), msgSender);
586     }
587 
588     /**
589      * @dev Returns the address of the current owner.
590      */
591     function owner() public view virtual returns (address) {
592         return _owner;
593     }
594 
595     /**
596      * @dev Throws if called by any account other than the owner.
597      */
598     modifier onlyOwner() {
599         require(owner() == _msgSender(), "Ownable: caller is not the owner");
600         _;
601     }
602 
603     /**
604      * @dev Leaves the contract without owner. It will not be possible to call
605      * `onlyOwner` functions anymore. Can only be called by the current owner.
606      *
607      * NOTE: Renouncing ownership will leave the contract without an owner,
608      * thereby removing any functionality that is only available to the owner.
609      */
610     function renounceOwnership() public virtual onlyOwner {
611         emit OwnershipTransferred(_owner, address(0));
612         _owner = address(0);
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         emit OwnershipTransferred(_owner, newOwner);
622         _owner = newOwner;
623     }
624 }
625 
626 // File: contracts/external/IUniswapV2Router01.sol
627 
628 pragma solidity >=0.6.2;
629 
630 interface IUniswapV2Router01 {
631     function factory() external pure returns (address);
632 
633     function WETH() external pure returns (address);
634 
635     function addLiquidity(
636         address tokenA,
637         address tokenB,
638         uint256 amountADesired,
639         uint256 amountBDesired,
640         uint256 amountAMin,
641         uint256 amountBMin,
642         address to,
643         uint256 deadline
644     )
645         external
646         returns (
647             uint256 amountA,
648             uint256 amountB,
649             uint256 liquidity
650         );
651 
652     function addLiquidityETH(
653         address token,
654         uint256 amountTokenDesired,
655         uint256 amountTokenMin,
656         uint256 amountETHMin,
657         address to,
658         uint256 deadline
659     )
660         external
661         payable
662         returns (
663             uint256 amountToken,
664             uint256 amountETH,
665             uint256 liquidity
666         );
667 
668     function removeLiquidity(
669         address tokenA,
670         address tokenB,
671         uint256 liquidity,
672         uint256 amountAMin,
673         uint256 amountBMin,
674         address to,
675         uint256 deadline
676     ) external returns (uint256 amountA, uint256 amountB);
677 
678     function removeLiquidityETH(
679         address token,
680         uint256 liquidity,
681         uint256 amountTokenMin,
682         uint256 amountETHMin,
683         address to,
684         uint256 deadline
685     ) external returns (uint256 amountToken, uint256 amountETH);
686 
687     function removeLiquidityWithPermit(
688         address tokenA,
689         address tokenB,
690         uint256 liquidity,
691         uint256 amountAMin,
692         uint256 amountBMin,
693         address to,
694         uint256 deadline,
695         bool approveMax,
696         uint8 v,
697         bytes32 r,
698         bytes32 s
699     ) external returns (uint256 amountA, uint256 amountB);
700 
701     function removeLiquidityETHWithPermit(
702         address token,
703         uint256 liquidity,
704         uint256 amountTokenMin,
705         uint256 amountETHMin,
706         address to,
707         uint256 deadline,
708         bool approveMax,
709         uint8 v,
710         bytes32 r,
711         bytes32 s
712     ) external returns (uint256 amountToken, uint256 amountETH);
713 
714     function swapExactTokensForTokens(
715         uint256 amountIn,
716         uint256 amountOutMin,
717         address[] calldata path,
718         address to,
719         uint256 deadline
720     ) external returns (uint256[] memory amounts);
721 
722     function swapTokensForExactTokens(
723         uint256 amountOut,
724         uint256 amountInMax,
725         address[] calldata path,
726         address to,
727         uint256 deadline
728     ) external returns (uint256[] memory amounts);
729 
730     function swapExactETHForTokens(
731         uint256 amountOutMin,
732         address[] calldata path,
733         address to,
734         uint256 deadline
735     ) external payable returns (uint256[] memory amounts);
736 
737     function swapTokensForExactETH(
738         uint256 amountOut,
739         uint256 amountInMax,
740         address[] calldata path,
741         address to,
742         uint256 deadline
743     ) external returns (uint256[] memory amounts);
744 
745     function swapExactTokensForETH(
746         uint256 amountIn,
747         uint256 amountOutMin,
748         address[] calldata path,
749         address to,
750         uint256 deadline
751     ) external returns (uint256[] memory amounts);
752 
753     function swapETHForExactTokens(
754         uint256 amountOut,
755         address[] calldata path,
756         address to,
757         uint256 deadline
758     ) external payable returns (uint256[] memory amounts);
759 
760     function quote(
761         uint256 amountA,
762         uint256 reserveA,
763         uint256 reserveB
764     ) external pure returns (uint256 amountB);
765 
766     function getAmountOut(
767         uint256 amountIn,
768         uint256 reserveIn,
769         uint256 reserveOut
770     ) external pure returns (uint256 amountOut);
771 
772     function getAmountIn(
773         uint256 amountOut,
774         uint256 reserveIn,
775         uint256 reserveOut
776     ) external pure returns (uint256 amountIn);
777 
778     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
779 
780     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
781 }
782 
783 // File: contracts/external/IUniswapV2Router02.sol
784 
785 pragma solidity >=0.6.2;
786 
787 interface IUniswapV2Router02 is IUniswapV2Router01 {
788     function removeLiquidityETHSupportingFeeOnTransferTokens(
789         address token,
790         uint256 liquidity,
791         uint256 amountTokenMin,
792         uint256 amountETHMin,
793         address to,
794         uint256 deadline
795     ) external returns (uint256 amountETH);
796 
797     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
798         address token,
799         uint256 liquidity,
800         uint256 amountTokenMin,
801         uint256 amountETHMin,
802         address to,
803         uint256 deadline,
804         bool approveMax,
805         uint8 v,
806         bytes32 r,
807         bytes32 s
808     ) external returns (uint256 amountETH);
809 
810     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
811         uint256 amountIn,
812         uint256 amountOutMin,
813         address[] calldata path,
814         address to,
815         uint256 deadline
816     ) external;
817 
818     function swapExactETHForTokensSupportingFeeOnTransferTokens(
819         uint256 amountOutMin,
820         address[] calldata path,
821         address to,
822         uint256 deadline
823     ) external payable;
824 
825     function swapExactTokensForETHSupportingFeeOnTransferTokens(
826         uint256 amountIn,
827         uint256 amountOutMin,
828         address[] calldata path,
829         address to,
830         uint256 deadline
831     ) external;
832 }
833 
834 // File: contracts/external/IUniswapV2Factory.sol
835 
836 pragma solidity >=0.5.0;
837 
838 interface IUniswapV2Factory {
839     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
840 
841     function feeTo() external view returns (address);
842 
843     function feeToSetter() external view returns (address);
844 
845     function getPair(address tokenA, address tokenB) external view returns (address pair);
846 
847     function allPairs(uint256) external view returns (address pair);
848 
849     function allPairsLength() external view returns (uint256);
850 
851     function createPair(address tokenA, address tokenB) external returns (address pair);
852 
853     function setFeeTo(address) external;
854 
855     function setFeeToSetter(address) external;
856 }
857 
858 // File: contracts/VestedToken.sol
859 
860 pragma solidity ^0.6.12;
861 
862 contract UNV is Context, IERC20, Ownable {
863     using SafeMath for uint256;
864     using Address for address;
865 
866     string private constant _name = "Unvest";
867     string private constant _symbol = "UNV";
868     uint8 private constant _decimals = 18;
869 
870     uint256 private constant _unlockMultiple = 5 * 10**3;
871     uint256 private constant _maxLock = 10 days;
872 
873     uint256 _totalSupply = 10**9 * 10**18;
874     mapping(address => uint256) _balances;
875     mapping(address => mapping(address => uint256)) _allowances;
876 
877     IUniswapV2Router02 public constant uniRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
878     IUniswapV2Factory public constant uniFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
879     address public launchPool;
880 
881     uint256 private _tradingTime;
882     uint256 private _restrictionLiftTime;
883     uint256 private _maxRestrictionAmount;
884     uint256 private _restrictionGas;
885     uint256 private _launchPrice;
886     mapping(address => bool) private _isWhitelisted;
887     mapping(address => bool) private _openSender;
888     mapping(address => bool) private _lastTx;
889     mapping(address => uint256) public lockTime;
890     mapping(address => uint256) public lockedAmount;
891 
892     constructor(uint256 _gas, uint256 _amount) public {
893         launchPool = uniFactory.createPair(address(uniRouter.WETH()), address(this));
894         _maxRestrictionAmount = _amount;
895         _restrictionGas = _gas;
896         _isWhitelisted[address(uniRouter)] = true;
897         _isWhitelisted[launchPool] = true;
898         _balances[owner()] = _totalSupply;
899         emit Transfer(address(0), owner(), _totalSupply);
900     }
901 
902     function name() public pure returns (string memory) {
903         return _name;
904     }
905 
906     function symbol() public pure returns (string memory) {
907         return _symbol;
908     }
909 
910     function decimals() public pure returns (uint8) {
911         return _decimals;
912     }
913 
914     function totalSupply() public view override returns (uint256) {
915         return _totalSupply;
916     }
917 
918     function balanceOf(address account) public view override returns (uint256) {
919         return _balances[account];
920     }
921 
922     function transfer(address recipient, uint256 amount) public override returns (bool) {
923         _transfer(_msgSender(), recipient, amount);
924         return true;
925     }
926 
927     function allowance(address owner, address spender) public view override returns (uint256) {
928         return _allowances[owner][spender];
929     }
930 
931     function approve(address spender, uint256 amount) public override returns (bool) {
932         _approve(_msgSender(), spender, amount);
933         return true;
934     }
935 
936     function transferFrom(
937         address sender,
938         address recipient,
939         uint256 amount
940     ) public override returns (bool) {
941         _transfer(sender, recipient, amount);
942         _approve(
943             sender,
944             _msgSender(),
945             _allowances[sender][_msgSender()].sub(amount, "UNV: transfer amount exceeds allowance")
946         );
947         return true;
948     }
949 
950     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
951         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
952         return true;
953     }
954 
955     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
956         _approve(
957             _msgSender(),
958             spender,
959             _allowances[_msgSender()][spender].sub(subtractedValue, "UNV: decreased allowance below zero")
960         );
961         return true;
962     }
963 
964     function _transfer(
965         address sender,
966         address recipient,
967         uint256 amount
968     ) private launchRestrict(sender, recipient, amount) {
969         require(sender != address(0), "UNV: transfer from the zero address");
970         require(recipient != address(0), "UNV: transfer to the zero address");
971 
972         _balances[sender] = _balances[sender].sub(amount, "UNV: transfer amount exceeds balance");
973         _balances[recipient] = _balances[recipient].add(amount);
974         emit Transfer(sender, recipient, amount);
975     }
976 
977     function _approve(
978         address owner,
979         address spender,
980         uint256 amount
981     ) private {
982         require(owner != address(0), "UNV: approve from the zero address");
983         require(spender != address(0), "UNV: approve to the zero address");
984 
985         _allowances[owner][spender] = amount;
986         emit Approval(owner, spender, amount);
987     }
988 
989     function setRestrictionAmount(uint256 amount) external onlyOwner {
990         _maxRestrictionAmount = amount;
991     }
992 
993     function setRestrictionGas(uint256 price) external onlyOwner {
994         _restrictionGas = price;
995     }
996 
997     function addSender(address account) external onlyOwner {
998         _openSender[account] = true;
999     }
1000 
1001     function setLaunchPrice(uint256 price) external onlyOwner {
1002         _launchPrice = price;
1003     }
1004 
1005     function lockBot(address account, uint256 unlockBotTime) external onlyOwner {
1006         lockTime[account] = unlockBotTime;
1007     }
1008 
1009     modifier launchRestrict(
1010         address sender,
1011         address recipient,
1012         uint256 amount
1013     ) {
1014         if (_tradingTime == 0) {
1015             require(_openSender[sender], "UNV: transfers are disabled");
1016             if (recipient == launchPool) {
1017                 _tradingTime = now;
1018                 _restrictionLiftTime = now.add(3 minutes);
1019             }
1020         } else if (_tradingTime == now) {
1021             revert("UNV: no transactions allowed");
1022         } else if (_tradingTime < now && _restrictionLiftTime > now) {
1023             require(amount <= _maxRestrictionAmount, "UNV: amount greater than max limit");
1024             require(tx.gasprice <= _restrictionGas, "UNV: gas price above limit");
1025             if (!_isWhitelisted[sender] && !_isWhitelisted[recipient]) {
1026                 require(
1027                     !_lastTx[sender] && !_lastTx[recipient] && !_lastTx[tx.origin],
1028                     "UNV: only one tx in restricted time"
1029                 );
1030                 _lastTx[sender] = true;
1031                 _lastTx[recipient] = true;
1032                 _lastTx[tx.origin] = true;
1033             } else if (!_isWhitelisted[recipient]) {
1034                 require(!_lastTx[recipient] && !_lastTx[tx.origin], "UNV: only one tx in restricted time");
1035                 _lastTx[recipient] = true;
1036                 _lastTx[tx.origin] = true;
1037             } else if (!_isWhitelisted[sender]) {
1038                 require(!_lastTx[sender] && !_lastTx[tx.origin], "UNV: only one tx in restricted time");
1039                 _lastTx[sender] = true;
1040                 _lastTx[tx.origin] = true;
1041             }
1042 
1043             // If 100 ETH : 8000 Tokens were in pool, price before buy = 0.0125. If 110 ETH : 7200 Tokens
1044             // after the purchase, price after buy = 0.0153. The ETH will be in the pool by the time of this function
1045             // execution, but tokens won't decrease yet, so we get to understand the actual execution price here
1046             // 110 ETH : 8000 Tokens = 0.01375. This logic will be used to understand the multiple and execute vesting
1047             // accordingly.
1048             if (sender == launchPool) {
1049                 require(
1050                     (_isWhitelisted[recipient] || _isWhitelisted[msg.sender]) && !Address.isContract(tx.origin),
1051                     "UNV: only uniswap router allowed"
1052                 );
1053                 uint256 ethBal = IERC20(address(uniRouter.WETH())).balanceOf(launchPool);
1054                 uint256 tokenBal = balanceOf(launchPool);
1055                 uint256 curPriceMultiple = ethBal.mul(10**18).div(tokenBal).mul(10**3).div(_launchPrice);
1056                 uint256 timeDelay = _maxLock.mul(curPriceMultiple).div(_unlockMultiple);
1057                 if (timeDelay <= _maxLock) {
1058                     lockTime[recipient] = now.add(_maxLock.sub(timeDelay));
1059                 }
1060                 uint256 unlockAmount = amount.mul(curPriceMultiple).div(_unlockMultiple);
1061                 if (unlockAmount <= amount) {
1062                     lockedAmount[recipient] = amount.sub(unlockAmount);
1063                 }
1064             }
1065         } else {
1066             if (!_isWhitelisted[sender] && lockTime[sender] >= now) {
1067                 require(amount.add(lockedAmount[sender]) <= _balances[sender], "UNV: locked balance");
1068             }
1069         }
1070         _;
1071     }
1072 }