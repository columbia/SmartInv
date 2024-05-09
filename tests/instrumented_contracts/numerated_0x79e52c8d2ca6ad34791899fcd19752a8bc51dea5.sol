1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.0;
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
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Interface for the optional metadata functions from the ERC20 standard.
80  */
81 interface IERC20Metadata is IERC20 {
82     /**
83      * @dev Returns the name of the token.
84      */
85     function name() external view returns (string memory);
86 
87     /**
88      * @dev Returns the symbol of the token.
89      */
90     function symbol() external view returns (string memory);
91 
92     /**
93      * @dev Returns the decimals places of the token.
94      */
95     function decimals() external view returns (uint8);
96 }
97 
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
115         return msg.data;
116     }
117 }
118 
119 /**
120  * @dev Contract module which provides a basic access control mechanism, where
121  * there is an account (an owner) that can be granted exclusive access to
122  * specific functions.
123  *
124  * By default, the owner account will be the one that deploys the contract. This
125  * can later be changed with {transferOwnership}.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor () {
140         address msgSender = _msgSender();
141         _owner = msgSender;
142         emit OwnershipTransferred(address(0), msgSender);
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         emit OwnershipTransferred(_owner, newOwner);
179         _owner = newOwner;
180     }
181 }
182 
183 /**
184  * @dev Contract module which allows children to implement an emergency stop
185  * mechanism that can be triggered by an authorized account.
186  *
187  * This module is used through inheritance. It will make available the
188  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
189  * the functions of your contract. Note that they will not be pausable by
190  * simply including this module, only once the modifiers are put in place.
191  */
192 abstract contract Pausable is Context {
193     /**
194      * @dev Emitted when the pause is triggered by `account`.
195      */
196     event Paused(address account);
197 
198     /**
199      * @dev Emitted when the pause is lifted by `account`.
200      */
201     event Unpaused(address account);
202 
203     bool private _paused;
204 
205     /**
206      * @dev Initializes the contract in unpaused state.
207      */
208     constructor () {
209         _paused = false;
210     }
211 
212     /**
213      * @dev Returns true if the contract is paused, and false otherwise.
214      */
215     function paused() public view virtual returns (bool) {
216         return _paused;
217     }
218 
219     /**
220      * @dev Modifier to make a function callable only when the contract is not paused.
221      *
222      * Requirements:
223      *
224      * - The contract must not be paused.
225      */
226     modifier whenNotPaused() {
227         require(!paused(), "Pausable: paused");
228         _;
229     }
230 
231     /**
232      * @dev Modifier to make a function callable only when the contract is paused.
233      *
234      * Requirements:
235      *
236      * - The contract must be paused.
237      */
238     modifier whenPaused() {
239         require(paused(), "Pausable: not paused");
240         _;
241     }
242 
243     /**
244      * @dev Triggers stopped state.
245      *
246      * Requirements:
247      *
248      * - The contract must not be paused.
249      */
250     function _pause() internal virtual whenNotPaused {
251         _paused = true;
252         emit Paused(_msgSender());
253     }
254 
255     /**
256      * @dev Returns to normal state.
257      *
258      * Requirements:
259      *
260      * - The contract must be paused.
261      */
262     function _unpause() internal virtual whenPaused {
263         _paused = false;
264         emit Unpaused(_msgSender());
265     }
266 }
267 
268 /**
269  * @dev Wrappers over Solidity's arithmetic operations.
270  *
271  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
272  * now has built in overflow checking.
273  */
274 library SafeMath {
275     /**
276      * @dev Returns the addition of two unsigned integers, with an overflow flag.
277      *
278      * _Available since v3.4._
279      */
280     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             uint256 c = a + b;
283             if (c < a) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     /**
289      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
290      *
291      * _Available since v3.4._
292      */
293     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b > a) return (false, 0);
296             return (true, a - b);
297         }
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
302      *
303      * _Available since v3.4._
304      */
305     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
306         unchecked {
307             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
308             // benefit is lost if 'b' is also tested.
309             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
310             if (a == 0) return (true, 0);
311             uint256 c = a * b;
312             if (c / a != b) return (false, 0);
313             return (true, c);
314         }
315     }
316 
317     /**
318      * @dev Returns the division of two unsigned integers, with a division by zero flag.
319      *
320      * _Available since v3.4._
321      */
322     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
323         unchecked {
324             if (b == 0) return (false, 0);
325             return (true, a / b);
326         }
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
331      *
332      * _Available since v3.4._
333      */
334     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
335         unchecked {
336             if (b == 0) return (false, 0);
337             return (true, a % b);
338         }
339     }
340 
341     /**
342      * @dev Returns the addition of two unsigned integers, reverting on
343      * overflow.
344      *
345      * Counterpart to Solidity's `+` operator.
346      *
347      * Requirements:
348      *
349      * - Addition cannot overflow.
350      */
351     function add(uint256 a, uint256 b) internal pure returns (uint256) {
352         return a + b;
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting on
357      * overflow (when the result is negative).
358      *
359      * Counterpart to Solidity's `-` operator.
360      *
361      * Requirements:
362      *
363      * - Subtraction cannot overflow.
364      */
365     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a - b;
367     }
368 
369     /**
370      * @dev Returns the multiplication of two unsigned integers, reverting on
371      * overflow.
372      *
373      * Counterpart to Solidity's `*` operator.
374      *
375      * Requirements:
376      *
377      * - Multiplication cannot overflow.
378      */
379     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
380         return a * b;
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers, reverting on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator.
388      *
389      * Requirements:
390      *
391      * - The divisor cannot be zero.
392      */
393     function div(uint256 a, uint256 b) internal pure returns (uint256) {
394         return a / b;
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
399      * reverting when dividing by zero.
400      *
401      * Counterpart to Solidity's `%` operator. This function uses a `revert`
402      * opcode (which leaves remaining gas untouched) while Solidity uses an
403      * invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
410         return a % b;
411     }
412 
413     /**
414      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
415      * overflow (when the result is negative).
416      *
417      * CAUTION: This function is deprecated because it requires allocating memory for the error
418      * message unnecessarily. For custom revert reasons use {trySub}.
419      *
420      * Counterpart to Solidity's `-` operator.
421      *
422      * Requirements:
423      *
424      * - Subtraction cannot overflow.
425      */
426     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         unchecked {
428             require(b <= a, errorMessage);
429             return a - b;
430         }
431     }
432 
433     /**
434      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
435      * division by zero. The result is rounded towards zero.
436      *
437      * Counterpart to Solidity's `/` operator. Note: this function uses a
438      * `revert` opcode (which leaves remaining gas untouched) while Solidity
439      * uses an invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         unchecked {
447             require(b > 0, errorMessage);
448             return a / b;
449         }
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * reverting with custom message when dividing by zero.
455      *
456      * CAUTION: This function is deprecated because it requires allocating memory for the error
457      * message unnecessarily. For custom revert reasons use {tryMod}.
458      *
459      * Counterpart to Solidity's `%` operator. This function uses a `revert`
460      * opcode (which leaves remaining gas untouched) while Solidity uses an
461      * invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
468         unchecked {
469             require(b > 0, errorMessage);
470             return a % b;
471         }
472     }
473 }
474 
475 /**
476  * @dev Collection of functions related to the address type
477  */
478 library Address {
479     /**
480      * @dev Returns true if `account` is a contract.
481      *
482      * [IMPORTANT]
483      * ====
484      * It is unsafe to assume that an address for which this function returns
485      * false is an externally-owned account (EOA) and not a contract.
486      *
487      * Among others, `isContract` will return false for the following
488      * types of addresses:
489      *
490      *  - an externally-owned account
491      *  - a contract in construction
492      *  - an address where a contract will be created
493      *  - an address where a contract lived, but was destroyed
494      * ====
495      */
496     function isContract(address account) internal view returns (bool) {
497         // This method relies on extcodesize, which returns 0 for contracts in
498         // construction, since the code is only stored at the end of the
499         // constructor execution.
500 
501         uint256 size;
502         // solhint-disable-next-line no-inline-assembly
503         assembly { size := extcodesize(account) }
504         return size > 0;
505     }
506 
507     /**
508      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
509      * `recipient`, forwarding all available gas and reverting on errors.
510      *
511      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
512      * of certain opcodes, possibly making contracts go over the 2300 gas limit
513      * imposed by `transfer`, making them unable to receive funds via
514      * `transfer`. {sendValue} removes this limitation.
515      *
516      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
517      *
518      * IMPORTANT: because control is transferred to `recipient`, care must be
519      * taken to not create reentrancy vulnerabilities. Consider using
520      * {ReentrancyGuard} or the
521      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
522      */
523     function sendValue(address payable recipient, uint256 amount) internal {
524         require(address(this).balance >= amount, "Address: insufficient balance");
525 
526         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
527         (bool success, ) = recipient.call{ value: amount }("");
528         require(success, "Address: unable to send value, recipient may have reverted");
529     }
530 
531     /**
532      * @dev Performs a Solidity function call using a low level `call`. A
533      * plain`call` is an unsafe replacement for a function call: use this
534      * function instead.
535      *
536      * If `target` reverts with a revert reason, it is bubbled up by this
537      * function (like regular Solidity function calls).
538      *
539      * Returns the raw returned data. To convert to the expected return value,
540      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
541      *
542      * Requirements:
543      *
544      * - `target` must be a contract.
545      * - calling `target` with `data` must not revert.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
550       return functionCall(target, data, "Address: low-level call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
555      * `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, 0, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but also transferring `value` wei to `target`.
566      *
567      * Requirements:
568      *
569      * - the calling contract must have an ETH balance of at least `value`.
570      * - the called Solidity function must be `payable`.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
580      * with `errorMessage` as a fallback revert reason when `target` reverts.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         // solhint-disable-next-line avoid-low-level-calls
589         (bool success, bytes memory returndata) = target.call{ value: value }(data);
590         return _verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
600         return functionStaticCall(target, data, "Address: low-level static call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
610         require(isContract(target), "Address: static call to non-contract");
611 
612         // solhint-disable-next-line avoid-low-level-calls
613         (bool success, bytes memory returndata) = target.staticcall(data);
614         return _verifyCallResult(success, returndata, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
624         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
634         require(isContract(target), "Address: delegate call to non-contract");
635 
636         // solhint-disable-next-line avoid-low-level-calls
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return _verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
642         if (success) {
643             return returndata;
644         } else {
645             // Look for revert reason and bubble it up if present
646             if (returndata.length > 0) {
647                 // The easiest way to bubble the revert reason is using memory via assembly
648 
649                 // solhint-disable-next-line no-inline-assembly
650                 assembly {
651                     let returndata_size := mload(returndata)
652                     revert(add(32, returndata), returndata_size)
653                 }
654             } else {
655                 revert(errorMessage);
656             }
657         }
658     }
659 }
660 
661 interface IUniswapV2Factory {
662     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
663 
664     function feeTo() external view returns (address);
665     function feeToSetter() external view returns (address);
666 
667     function getPair(address tokenA, address tokenB) external view returns (address pair);
668     function allPairs(uint) external view returns (address pair);
669     function allPairsLength() external view returns (uint);
670 
671     function createPair(address tokenA, address tokenB) external returns (address pair);
672 
673     function setFeeTo(address) external;
674     function setFeeToSetter(address) external;
675 }
676 
677 interface IUniswapV2Router01 {
678     function factory() external pure returns (address);
679     function WETH() external pure returns (address);
680 
681     function addLiquidity(
682         address tokenA,
683         address tokenB,
684         uint amountADesired,
685         uint amountBDesired,
686         uint amountAMin,
687         uint amountBMin,
688         address to,
689         uint deadline
690     ) external returns (uint amountA, uint amountB, uint liquidity);
691     function addLiquidityETH(
692         address token,
693         uint amountTokenDesired,
694         uint amountTokenMin,
695         uint amountETHMin,
696         address to,
697         uint deadline
698     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
699     function removeLiquidity(
700         address tokenA,
701         address tokenB,
702         uint liquidity,
703         uint amountAMin,
704         uint amountBMin,
705         address to,
706         uint deadline
707     ) external returns (uint amountA, uint amountB);
708     function removeLiquidityETH(
709         address token,
710         uint liquidity,
711         uint amountTokenMin,
712         uint amountETHMin,
713         address to,
714         uint deadline
715     ) external returns (uint amountToken, uint amountETH);
716     function removeLiquidityWithPermit(
717         address tokenA,
718         address tokenB,
719         uint liquidity,
720         uint amountAMin,
721         uint amountBMin,
722         address to,
723         uint deadline,
724         bool approveMax, uint8 v, bytes32 r, bytes32 s
725     ) external returns (uint amountA, uint amountB);
726     function removeLiquidityETHWithPermit(
727         address token,
728         uint liquidity,
729         uint amountTokenMin,
730         uint amountETHMin,
731         address to,
732         uint deadline,
733         bool approveMax, uint8 v, bytes32 r, bytes32 s
734     ) external returns (uint amountToken, uint amountETH);
735     function swapExactTokensForTokens(
736         uint amountIn,
737         uint amountOutMin,
738         address[] calldata path,
739         address to,
740         uint deadline
741     ) external returns (uint[] memory amounts);
742     function swapTokensForExactTokens(
743         uint amountOut,
744         uint amountInMax,
745         address[] calldata path,
746         address to,
747         uint deadline
748     ) external returns (uint[] memory amounts);
749     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
750         external
751         payable
752         returns (uint[] memory amounts);
753     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
754         external
755         returns (uint[] memory amounts);
756     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
757         external
758         returns (uint[] memory amounts);
759     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
760         external
761         payable
762         returns (uint[] memory amounts);
763 
764     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
765     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
766     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
767     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
768     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
769 }
770 
771 interface IUniswapV2Router02 is IUniswapV2Router01 {
772     function removeLiquidityETHSupportingFeeOnTransferTokens(
773         address token,
774         uint liquidity,
775         uint amountTokenMin,
776         uint amountETHMin,
777         address to,
778         uint deadline
779     ) external returns (uint amountETH);
780     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline,
787         bool approveMax, uint8 v, bytes32 r, bytes32 s
788     ) external returns (uint amountETH);
789 
790     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
791         uint amountIn,
792         uint amountOutMin,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external;
797     function swapExactETHForTokensSupportingFeeOnTransferTokens(
798         uint amountOutMin,
799         address[] calldata path,
800         address to,
801         uint deadline
802     ) external payable;
803     function swapExactTokensForETHSupportingFeeOnTransferTokens(
804         uint amountIn,
805         uint amountOutMin,
806         address[] calldata path,
807         address to,
808         uint deadline
809     ) external;
810 }
811 
812 /**
813  * @dev Implementation of the {IERC20} interface.
814  *
815  * This implementation is agnostic to the way tokens are created. This means
816  * that a supply mechanism has to be added in a derived contract using {_mint}.
817  * For a generic mechanism see {ERC20PresetMinterPauser}.
818  *
819  * TIP: For a detailed writeup see our guide
820  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
821  * to implement supply mechanisms].
822  *
823  * We have followed general OpenZeppelin guidelines: functions revert instead
824  * of returning `false` on failure. This behavior is nonetheless conventional
825  * and does not conflict with the expectations of ERC20 applications.
826  *
827  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
828  * This allows applications to reconstruct the allowance for all accounts just
829  * by listening to said events. Other implementations of the EIP may not emit
830  * these events, as it isn't required by the specification.
831  *
832  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
833  * functions have been added to mitigate the well-known issues around setting
834  * allowances. See {IERC20-approve}.
835  */
836 contract WempToken is Context, IERC20, IERC20Metadata, Ownable, Pausable {
837     using SafeMath for uint256;
838     using Address for address;
839 
840     mapping (address => uint256) private _rOwned;
841     mapping (address => uint256) private _tOwned;
842     mapping (address => mapping (address => uint256)) private _allowances;
843     mapping (address => bool) private pausedAddress;
844     mapping (address => bool) private _isExcluded;
845     mapping (address => bool) private _isExcludedFromDexFee;
846     mapping (address => bool) private _isIncludedInFee; // Tax Flag
847     address[] private _excluded;
848    
849     uint256 private constant MAX = ~uint256(0);
850     uint256 private constant initialSupply = 1000000 * 10**9 * 10**18;   // initial supply
851     uint256 private _tTotal = initialSupply - (initialSupply * 40 / 100);   // supply after deflation
852     uint256 private _rTotal = (MAX - (MAX % _tTotal));
853     uint256 private _tFeeTotal;
854 
855     string private constant _name = "Women Empowerment Token";
856     string private constant _symbol = "WEMP";
857     uint8 private constant _decimals = 18;
858     
859     uint256 public taxFee = 2;
860     uint256 private previousTaxFee = taxFee;
861 
862     uint256 public liquidityFee = 1;
863     uint256 private previousLiquidityFee = liquidityFee;
864     
865     uint256 public transactionBurn = 1;
866     uint256 private previousTransactionBurn = transactionBurn;
867 
868     uint256 public charityFee = 1;
869     uint256 private previousCharityFee = charityFee;
870 
871     uint256 public womenWelfareFee = 1;
872     uint256 private previousWomenWelfareFee = womenWelfareFee;
873 
874     bool public enableFee = true;
875     bool private inSwapAndLiquify;
876     bool public swapAndLiquifyEnabled = true;
877  
878     uint256 private _amount_burnt;
879     uint256 public liquidityFeeBalance;
880     uint256 public constant liquidityFeeToSell = 10000 * 10**18;
881 
882     IUniswapV2Router02 public immutable uniswapV2Router;
883     address private constant UNISWAPV2ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
884     address public uniswapV2Pair;
885     address public charityWallet;
886     address public welfareWallet;
887 
888     event FeeEnable(bool enableFee);
889     event SetMaxTxPercent(uint256 maxPercent);
890     event SetCharityAddress(address indexed charityAddress);
891     event SetCharityFeePercent(uint256 chartyFeePercent);
892     event SetBurnPercent(uint256 burnPercent);
893     event SetTaxFeePercent(uint256 taxFeePercent);
894     event SetLiquidityFeePercent(uint256 liquidityFeePercent);
895     event ExcludeFromFee(address indexed account, bool includeInFee);
896     event IncludeInFee(address indexed account, bool includeInFee);
897     event ExcludeFromDexFee(address indexed account, bool includeInDexFee);
898     event IncludeInDexFee(address indexed account, bool includeInDexFee);
899     event SwapAndLiquifyEnabledUpdated(bool enabled);
900     event SwapAndLiquify(
901         uint256 tokensSwapped,
902         uint256 ethReceived,
903         uint256 tokensIntoLiqudity
904     );
905     event ExternalTokenTransfered(address indexed externalAddress,address indexed toAddress, uint amount);
906     event EthFromContractTransferred(uint amount);
907     event LiquidityAddedFromSwap(uint amountToken,uint amountEth,uint liquidity);
908 
909     modifier lockTheSwap {
910         inSwapAndLiquify = true;
911         _;
912         inSwapAndLiquify = false;
913     }
914 
915     constructor (address _charityWallet, address _welfareWallet) {
916         require ( _charityWallet != address ( 0 ) , "WempToken: _charityWallet is a zero address") ;
917         require ( _welfareWallet != address ( 0 ) , "WempToken: _welfareWallet is a zero address") ;
918 
919         _rOwned[_msgSender()] = _rTotal;
920         charityWallet = _charityWallet;
921         welfareWallet = _welfareWallet;
922         emit Transfer(address(0), _msgSender(), initialSupply);
923 
924         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPV2ROUTER);
925         // Create a uniswap pair for this new token
926         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
927             .createPair(address(this), _uniswapV2Router.WETH());
928 
929         // set the rest of the contract variables
930         uniswapV2Router = _uniswapV2Router;
931         tokenDeflation();       
932     }
933 
934     /**
935      * @dev Returns the name of the token.
936      */
937     function name() external view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev Returns the symbol of the token, usually a shorter version of the
943      * name.
944      */
945     function symbol() external view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev Returns the number of decimals used to get its user representation.
951      * For example, if `decimals` equals `2`, a balance of `505` tokens should
952      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
953      *
954      * Tokens usually opt for a value of 18, imitating the relationship between
955      * Ether and Wei. This is the value {ERC20} uses, unless this function is
956      * overridden;
957      *
958      * NOTE: This information is only used for _display_ purposes: it in
959      * no way affects any of the arithmetic of the contract, including
960      * {IERC20-balanceOf} and {IERC20-transfer}.
961      */
962     function decimals() external view virtual override returns (uint8) {
963         return _decimals;
964     }
965 
966     /**
967      * @dev See {IERC20-totalSupply}.
968      */
969     function totalSupply() external view virtual override returns (uint256) {
970         return _tTotal - _amount_burnt;
971     }
972 
973     /**
974      * @dev See {IERC20-balanceOf}.
975      */
976     function balanceOf(address account) public view virtual override returns (uint256) {
977         if (_isExcluded[account]) return _tOwned[account];
978         return tokenFromReflection(_rOwned[account]);
979     }
980 
981     /**
982      * @dev See {IERC20-transfer}.
983      *
984      * Requirements:
985      *
986      * - `recipient` cannot be the zero address.
987      * - the caller must have a balance of at least `amount`.
988      */
989     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
990         _transfer(_msgSender(), recipient, amount);
991         return true;
992     }
993 
994     /**
995      * @dev See {IERC20-allowance}.
996      */
997     function allowance(address owner, address spender) external view virtual override returns (uint256) {
998         return _allowances[owner][spender];
999     }
1000 
1001     /**
1002      * @dev See {IERC20-approve}.
1003      *
1004      * Requirements:
1005      *
1006      * - `spender` cannot be the zero address.
1007      */
1008     function approve(address spender, uint256 amount) external virtual override returns (bool) {
1009         _approve(_msgSender(), spender, amount);
1010         return true;
1011     }
1012 
1013     /**
1014      * @dev See {IERC20-transferFrom}.
1015      *
1016      * Emits an {Approval} event indicating the updated allowance. This is not
1017      * required by the EIP. See the note at the beginning of {ERC20}.
1018      *
1019      * Requirements:
1020      *
1021      * - `sender` and `recipient` cannot be the zero address.
1022      * - `sender` must have a balance of at least `amount`.
1023      * - the caller must have allowance for ``sender``'s tokens of at least
1024      * `amount`.
1025      */
1026     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
1027         _transfer(sender, recipient, amount);
1028 
1029         uint256 currentAllowance = _allowances[sender][_msgSender()];
1030         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1031         _approve(sender, _msgSender(), currentAllowance - amount);
1032 
1033         return true;
1034     }
1035 
1036     /**
1037      * @dev Atomically increases the allowance granted to `spender` by the caller.
1038      *
1039      * This is an alternative to {approve} that can be used as a mitigation for
1040      * problems described in {IERC20-approve}.
1041      *
1042      * Emits an {Approval} event indicating the updated allowance.
1043      *
1044      * Requirements:
1045      *
1046      * - `spender` cannot be the zero address.
1047      */
1048     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
1049         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1050         return true;
1051     }
1052 
1053     /**
1054      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1055      *
1056      * This is an alternative to {approve} that can be used as a mitigation for
1057      * problems described in {IERC20-approve}.
1058      *
1059      * Emits an {Approval} event indicating the updated allowance.
1060      *
1061      * Requirements:
1062      *
1063      * - `spender` cannot be the zero address.
1064      * - `spender` must have allowance for the caller of at least
1065      * `subtractedValue`.
1066      */
1067     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
1068         uint256 currentAllowance = _allowances[_msgSender()][spender];
1069         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1070         unchecked {
1071             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1072         }
1073 
1074         return true;
1075     }
1076 
1077     /**
1078      * @dev Pause `contract` - pause events.
1079      *
1080      * See {ERC20Pausable-_pause}.
1081      */
1082     function pauseContract() external virtual onlyOwner {
1083         _pause();
1084     }
1085     
1086     /**
1087      * @dev Pause `contract` - pause events.
1088      *
1089      * See {ERC20Pausable-_pause}.
1090      */
1091     function unPauseContract() external virtual onlyOwner {
1092         _unpause();
1093     }
1094 
1095     /**
1096      * @dev Pause `contract` - pause events.
1097      *
1098      * See {ERC20Pausable-_pause}.
1099      */
1100     function pauseAddress(address account) external virtual onlyOwner {
1101         excludeFromReward(account);
1102         pausedAddress[account] = true;
1103     }
1104     
1105     /**
1106      * @dev Pause `contract` - pause events.
1107      *
1108      * See {ERC20Pausable-_pause}.
1109      */
1110     function unPauseAddress(address account) external virtual onlyOwner {
1111         includeInReward(account);
1112         pausedAddress[account] = false;
1113     }
1114     
1115     /**
1116      * @dev Returns true if the address is paused, and false otherwise.
1117      */
1118     function isAddressPaused(address account) external view virtual returns (bool) {
1119         return pausedAddress[account];
1120     }
1121 
1122     function tokenDeflation() internal {
1123         uint256 deflationAmount = initialSupply * 40 / 100;
1124         emit Transfer(_msgSender(), address(0), deflationAmount);
1125     }
1126 
1127     function totalFees() external view returns (uint256) {
1128         return _tFeeTotal;
1129     }
1130 
1131     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1132         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1133         uint256 currentRate =  getRate();
1134         return rAmount.div(currentRate);
1135     }
1136 
1137     function excludeFromReward(address account) public onlyOwner {
1138         require(!_isExcluded[account], "Account is already excluded");
1139         if(_rOwned[account] > 0) {
1140             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1141         }
1142         _isExcluded[account] = true;
1143         _excluded.push(account);
1144     }
1145 
1146     function includeInReward(address account) public onlyOwner {
1147         require(_isExcluded[account], "Account is not excluded");
1148         for (uint256 i = 0; i < _excluded.length; i++) {
1149             if (_excluded[i] == account) {
1150                 _excluded[i] = _excluded[_excluded.length - 1];
1151                 _tOwned[account] = 0;
1152                 _isExcluded[account] = false;
1153                 _excluded.pop();
1154                 break;
1155             }
1156         }
1157     }
1158 
1159     function isExcludedFromReward(address account) external view returns (bool) {
1160         return _isExcluded[account];
1161     }
1162     
1163     function excludeFromDexFee(address account) external onlyOwner {
1164         _isExcludedFromDexFee[account] = true;
1165         emit ExcludeFromDexFee(account, true);
1166     }
1167     
1168     function includeInDexFee(address account) external onlyOwner {
1169         _isExcludedFromDexFee[account] = false;
1170         emit IncludeInDexFee(account, false);
1171     }
1172 
1173     function isExcludedFromDexFee(address account) external view returns(bool) {
1174         return _isExcludedFromDexFee[account];
1175     }
1176 
1177     function excludeFromFee(address account) external onlyOwner {
1178         _isIncludedInFee[account] = false;
1179         emit ExcludeFromFee(account, false);
1180     }
1181     
1182     function includeInFee(address account) external onlyOwner {
1183         _isIncludedInFee[account] = true;
1184         emit IncludeInFee(account, true);
1185     }
1186 
1187     function isIncludedInFee(address account) external view returns(bool) {
1188         return _isIncludedInFee[account];
1189     }
1190     
1191     function setTaxFeePercent(uint256 fee) external onlyOwner {
1192         require((fee + liquidityFee + transactionBurn + charityFee + womenWelfareFee) < 100, "Total fees should be less than 100%");
1193         taxFee = fee;
1194         emit SetTaxFeePercent(taxFee);
1195     }
1196 
1197     function setLiquidityFeePercent(uint256 fee) external onlyOwner {
1198         require((taxFee + fee + transactionBurn + charityFee + womenWelfareFee) < 100, "Total fees should be less than 100%");
1199         liquidityFee = fee;
1200         emit SetLiquidityFeePercent(liquidityFee);
1201     }
1202 
1203     function setBurnPercent(uint256 burn_percentage) external onlyOwner {
1204         require((taxFee + liquidityFee + burn_percentage + charityFee + womenWelfareFee) < 100, "Total fees should be less than 100%");
1205         transactionBurn = burn_percentage;
1206         emit SetBurnPercent(burn_percentage);
1207     }
1208 
1209     function setCharityFeePercent(uint256 fee) external onlyOwner {
1210         require((taxFee + liquidityFee + transactionBurn + fee + womenWelfareFee) < 100, "Total fees should be less than 100%");
1211         charityFee = fee;
1212         emit SetCharityFeePercent(charityFee);
1213     }
1214 
1215     function setWomenWelfareFeePercent(uint256 fee) external onlyOwner {
1216         require((taxFee + liquidityFee + transactionBurn + charityFee + fee) < 100, "Total fees should be less than 100%");
1217         womenWelfareFee = fee;
1218         emit SetCharityFeePercent(womenWelfareFee);
1219     }
1220 
1221     function updateCharityWallet(address _charityWallet) external onlyOwner {
1222         require(_charityWallet != address(0), "ERC20: Charity address cannot be a zero address");
1223         charityWallet = _charityWallet;
1224         emit SetCharityAddress(_charityWallet);
1225     }
1226 
1227     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1228         swapAndLiquifyEnabled = _enabled;
1229         emit SwapAndLiquifyEnabledUpdated(_enabled);
1230     }
1231 
1232     function setEnableFee(bool enableTax) external onlyOwner {
1233         enableFee = enableTax;
1234         emit FeeEnable(enableTax);
1235     }
1236 
1237     function takeReflectionFee(uint256 rFee, uint256 tFee) internal {
1238         _rTotal = _rTotal.sub(rFee);
1239         _tFeeTotal = _tFeeTotal.add(tFee);
1240     }
1241 
1242     function getTValues(uint256 amount) internal view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1243         uint256 tAmount = amount;
1244         uint256 tFee = calculateTaxFee(tAmount);
1245         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1246         uint256 tCharityFee = calculateCharityFee(tAmount);
1247         uint256 tWelfareFee = calculateWomenWelfareFee(tAmount);
1248         uint256 tBurn = calculateTransactionBurn(tAmount);
1249         {
1250             uint256 amt = tAmount;
1251             uint256 tTransferAmount = amt.sub(tFee).sub(tLiquidity).sub(tBurn).sub(tCharityFee).sub(tWelfareFee);
1252             return (tTransferAmount, tFee, tLiquidity, tBurn, tCharityFee, tWelfareFee);
1253         }
1254     }
1255 
1256     function getRValues(uint256 amount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 tCharityFee, uint256 tWelfareFee) internal view returns (uint256, uint256, uint256) {
1257         uint256 currentRate = getRate();
1258         uint256 tAmount = amount;
1259         uint256 rAmount = tAmount.mul(currentRate);
1260         uint256 rFee = tFee.mul(currentRate);
1261         uint256 rliquidity = tLiquidity.mul(currentRate);
1262         uint256 rCharityFee = tCharityFee.mul(currentRate);
1263         uint256 rWelfareFee = tWelfareFee.mul(currentRate);
1264         uint256 rBurn = tBurn.mul(currentRate);
1265         {
1266             uint256 amt = rAmount;
1267             uint256 rTransferAmount = amt.sub(rFee).sub(rliquidity).sub(rBurn).sub(rCharityFee).sub(rWelfareFee);
1268             return (rAmount, rTransferAmount, rFee);
1269         }
1270     }
1271 
1272     function getRate() internal view returns(uint256) {
1273         (uint256 rSupply, uint256 tSupply) = getCurrentSupply();
1274         return rSupply.div(tSupply);
1275     }
1276 
1277     function getCurrentSupply() internal view returns(uint256, uint256) {
1278         uint256 rSupply = _rTotal;
1279         uint256 tSupply = _tTotal;      
1280         for (uint256 i = 0; i < _excluded.length; i++) {
1281             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1282             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1283             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1284         }
1285         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1286         return (rSupply, tSupply);
1287     }
1288 
1289     function takeCharityFee(address sender, uint256 tCharityFee) internal {
1290         uint256 currentRate =  getRate();
1291         uint256 rCharityFee = tCharityFee.mul(currentRate);
1292         _rOwned[charityWallet] = _rOwned[charityWallet].add(rCharityFee);
1293         if(_isExcluded[charityWallet])
1294             _tOwned[charityWallet] = _tOwned[charityWallet].add(tCharityFee);
1295         
1296         if(tCharityFee > 0) emit Transfer(sender, charityWallet, tCharityFee);
1297     }
1298 
1299     function takeWomenWelfareFee(address sender, uint256 tWelfareFee) internal {
1300         uint256 currentRate =  getRate();
1301         uint256 rWelfareFee = tWelfareFee.mul(currentRate);
1302         _rOwned[welfareWallet] = _rOwned[welfareWallet].add(rWelfareFee);
1303         if(_isExcluded[welfareWallet])
1304             _tOwned[welfareWallet] = _tOwned[welfareWallet].add(tWelfareFee);
1305         
1306         if(tWelfareFee > 0) emit Transfer(sender, welfareWallet, tWelfareFee);
1307     }
1308 
1309     function takeLiquidityFee(address sender, uint256 tLiquidity) internal {
1310         uint256 currentRate =  getRate();
1311         uint256 rLiquidity = tLiquidity.mul(currentRate);
1312         liquidityFeeBalance += tLiquidity;
1313         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1314         if(_isExcluded[address(this)])
1315             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1316         
1317         if(tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
1318     }
1319     
1320     function calculateTaxFee(uint256 _amount) internal view returns (uint256) {
1321         return _amount.mul(taxFee).div(
1322             10**2
1323         );
1324     }
1325 
1326     function calculateLiquidityFee(uint256 _amount) internal view returns (uint256) {
1327         return _amount.mul(liquidityFee).div(
1328             10**2
1329         );
1330     }
1331 
1332     function calculateTransactionBurn(uint256 _amount) internal view returns (uint256) {
1333         return _amount.mul(transactionBurn).div(
1334             10**2
1335         );
1336     }
1337 
1338     function calculateCharityFee(uint256 _amount) internal view returns (uint256) {
1339         return _amount.mul(charityFee).div(
1340             10**2
1341         );
1342     }
1343 
1344     function calculateWomenWelfareFee(uint256 _amount) internal view returns (uint256) {
1345         return _amount.mul(womenWelfareFee).div(
1346             10**2
1347         );
1348     }
1349     
1350     function removeAllFee() internal {
1351         if(taxFee == 0 && liquidityFee == 0 && transactionBurn == 0 && charityFee == 0 && womenWelfareFee == 0) return;
1352         
1353         previousTaxFee = taxFee;
1354         previousLiquidityFee = liquidityFee;
1355         previousTransactionBurn = transactionBurn;
1356         previousCharityFee = charityFee;
1357         previousWomenWelfareFee = womenWelfareFee;
1358         
1359         taxFee = 0;
1360         liquidityFee = 0;
1361         transactionBurn = 0;
1362         charityFee = 0;
1363         womenWelfareFee = 0;
1364     }
1365  
1366     function restoreAllFee() internal {
1367         taxFee = previousTaxFee;
1368         liquidityFee = previousLiquidityFee;
1369         transactionBurn = previousTransactionBurn;
1370         charityFee = previousCharityFee;
1371         womenWelfareFee = previousWomenWelfareFee;
1372     }
1373 
1374     //to recieve ETH from uniswapV2Router when swaping
1375     receive() external payable {}
1376 
1377     /**
1378      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1379      *
1380      * This internal function is equivalent to `approve`, and can be used to
1381      * e.g. set automatic allowances for certain subsystems, etc.
1382      *
1383      * Emits an {Approval} event.
1384      *
1385      * Requirements:
1386      *
1387      * - `owner` cannot be the zero address.
1388      * - `spender` cannot be the zero address.
1389      */
1390     function _approve(address owner, address spender, uint256 amount) internal virtual {
1391         require(owner != address(0), "ERC20: approve from the zero address");
1392         require(spender != address(0), "ERC20: approve to the zero address");
1393 
1394         _allowances[owner][spender] = amount;
1395         emit Approval(owner, spender, amount);
1396     }
1397 
1398     /**
1399      * @dev Moves tokens `amount` from `sender` to `recipient`.
1400      *
1401      * This is internal function is equivalent to {transfer}, and can be used to
1402      * e.g. implement automatic token fees, slashing mechanisms, etc.
1403      *
1404      * Emits a {Transfer} event.
1405      *
1406      * Requirements:
1407      *
1408      * - `sender` cannot be the zero address.
1409      * - `recipient` cannot be the zero address.
1410      * - `sender` must have a balance of at least `amount`.
1411      */
1412     function _transfer(
1413         address from,
1414         address to,
1415         uint256 amount
1416     ) internal {
1417         require(from != address(0), "ERC20: transfer from the zero address");
1418         require(to != address(0), "ERC20: transfer to the zero address");
1419         require(amount > 0, "Transfer amount must be greater than zero");
1420         
1421         _beforeTokenTransfer(from, to);
1422         
1423         uint256 senderBalance = balanceOf(from);
1424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1425 
1426         //indicates if fee should be deducted from transfer
1427         bool takeFee = false;
1428         
1429         //if any account belongs to _isIncludedInFee account then take fee
1430         //else remove fee
1431         if(enableFee && (_isIncludedInFee[from] || _isIncludedInFee[to])){
1432             if((from == uniswapV2Pair && _isExcludedFromDexFee[to]) || (to == uniswapV2Pair && _isExcludedFromDexFee[from])) takeFee = false;
1433             else takeFee = true;
1434         }
1435         if(takeFee) _swapAndLiquify(from);
1436          
1437          //transfer amount, it will take tax, burn and charity amount
1438         _tokenTransfer(from,to,amount,takeFee);
1439     }
1440 
1441     //this method is responsible for taking all fee, if takeFee is true
1442     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) internal {
1443         if(!takeFee)
1444             removeAllFee();
1445         
1446         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1447             _transferFromExcluded(sender, recipient, amount);
1448         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1449             _transferToExcluded(sender, recipient, amount);
1450         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1451             _transferBothExcluded(sender, recipient, amount);
1452         } else {
1453             _transferStandard(sender, recipient, amount);
1454         }
1455         
1456         if(!takeFee)
1457             restoreAllFee();
1458     }
1459   
1460     function _transferStandard(address sender, address recipient, uint256 tAmount) internal {
1461         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 tCharityFee, uint256 tWelfareFee) = getTValues(tAmount);
1462         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tLiquidity, tBurn, tCharityFee, tWelfareFee);
1463 
1464         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1465         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1466         takeReflectionFee(rFee, tFee);
1467         takeLiquidityFee(sender, tLiquidity);
1468         takeCharityFee(sender, tCharityFee);
1469         takeWomenWelfareFee(sender, tWelfareFee);
1470         if(tBurn > 0) {
1471             _amount_burnt += tBurn;
1472             emit Transfer(sender, address(0), tBurn);
1473         }
1474         emit Transfer(sender, recipient, tTransferAmount);
1475     }
1476     
1477     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) internal {
1478         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 tCharityFee, uint256 tWelfareFee) = getTValues(tAmount);
1479         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tLiquidity, tBurn, tCharityFee, tWelfareFee);
1480         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1481         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1482         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1483         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1484         takeReflectionFee(rFee, tFee);
1485         takeLiquidityFee(sender, tLiquidity);
1486         takeCharityFee(sender, tCharityFee);
1487         takeWomenWelfareFee(sender, tWelfareFee);
1488         if(tBurn > 0) {
1489             _amount_burnt += tBurn;
1490             emit Transfer(sender, address(0), tBurn);
1491         }
1492         emit Transfer(sender, recipient, tTransferAmount);
1493     }
1494     
1495     function _transferToExcluded(address sender, address recipient, uint256 tAmount) internal {
1496         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 tCharityFee, uint256 tWelfareFee) = getTValues(tAmount);
1497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tLiquidity, tBurn, tCharityFee, tWelfareFee);
1498         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1499         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1500         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1501         takeReflectionFee(rFee, tFee);
1502         takeLiquidityFee(sender, tLiquidity);
1503         takeCharityFee(sender, tCharityFee);
1504         takeWomenWelfareFee(sender, tWelfareFee);
1505         if(tBurn > 0) {
1506             _amount_burnt += tBurn;
1507             emit Transfer(sender, address(0), tBurn);
1508         }
1509         emit Transfer(sender, recipient, tTransferAmount);
1510     }
1511 
1512     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) internal {
1513         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 tCharityFee, uint256 tWelfareFee) = getTValues(tAmount);
1514         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tLiquidity, tBurn, tCharityFee, tWelfareFee);
1515         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1516         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1517         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1518         takeReflectionFee(rFee, tFee);
1519         takeLiquidityFee(sender, tLiquidity);
1520         takeCharityFee(sender, tCharityFee);
1521         takeWomenWelfareFee(sender, tWelfareFee);
1522         if(tBurn > 0) {
1523             _amount_burnt += tBurn;
1524             emit Transfer(sender, address(0), tBurn);
1525         }
1526         emit Transfer(sender, recipient, tTransferAmount);
1527     }
1528 
1529     function _swapAndLiquify(address from) internal {
1530         if(from != uniswapV2Pair && liquidityFeeBalance >= liquidityFeeToSell) {
1531             bool initialFeeState = enableFee;
1532             // remove fee if initialFeeState was true
1533             if(initialFeeState) enableFee = false;
1534 
1535             // is the token balance of this contract address over the min number of
1536             // tokens that we need to initiate a swap + liquidity lock?
1537             // also, don't get caught in a circular liquidity event.
1538             // also, don't swap & liquify if sender is uniswap pair.
1539             if(!inSwapAndLiquify && swapAndLiquifyEnabled && liquidityFeeBalance >= liquidityFeeToSell) {
1540                 uint256 fee = liquidityFeeBalance;
1541                 liquidityFeeBalance = 0;
1542                 //add liquidity
1543                 swapAndLiquify(fee, owner());
1544             }
1545 
1546             // enable fee if initialFeeState was true
1547             if(initialFeeState) enableFee = true;
1548         }
1549     }
1550 
1551     function swapAndLiquify(uint256 contractTokenBalance, address account) internal lockTheSwap {
1552         // split the contract balance into halves
1553         uint256 half = contractTokenBalance.div(2);
1554         uint256 otherHalf = contractTokenBalance.sub(half);
1555 
1556         // capture the contract's current ETH balance.
1557         // this is so that we can capture exactly the amount of ETH that the
1558         // swap creates, and not make the liquidity event include any ETH that
1559         // has been manually sent to the contract
1560         uint256 initialBalance = address(this).balance;
1561 
1562         // swap tokens for ETH
1563         swapTokensForEth(half, address(this)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1564 
1565         // how much ETH did we just swap into?
1566         uint256 newBalance = address(this).balance.sub(initialBalance);
1567 
1568         // add liquidity to uniswap
1569         addLiquidity(otherHalf, newBalance, account);
1570         
1571         emit SwapAndLiquify(half, newBalance, otherHalf);
1572     }
1573 
1574     function swapTokensForEth(uint256 tokenAmount, address swapAddress) internal {
1575         // generate the uniswap pair path of token -> weth
1576         address[] memory path = new address[](2);
1577         path[0] = address(this);
1578         path[1] = uniswapV2Router.WETH();
1579 
1580         _approve(address(this), address(uniswapV2Router), tokenAmount);
1581 
1582         // make the swap
1583         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1584             tokenAmount,
1585             0, // accept any amount of ETH
1586             path,
1587             swapAddress,
1588             block.timestamp
1589         );
1590     }
1591 
1592     function addLiquidity(uint256 tokenAmount, uint256 ethAmount, address account) internal {
1593         // approve token transfer to cover all possible scenarios
1594         _approve(address(this), address(uniswapV2Router), tokenAmount);
1595 
1596         // add the liquidity
1597         (uint amountToken, uint amountETH, uint liquidity) = uniswapV2Router.addLiquidityETH{value: ethAmount}(
1598             address(this),
1599             tokenAmount,
1600             0, // slippage is unavoidable
1601             0, // slippage is unavoidable
1602             account,
1603             block.timestamp
1604         );
1605         emit LiquidityAddedFromSwap(amountToken,amountETH,liquidity);
1606     }
1607 
1608     function withdrawToken(address _tokenContract, uint256 _amount) external onlyOwner {
1609         require(_tokenContract != address(0), "Address cant be zero address");
1610         IERC20 tokenContract = IERC20(_tokenContract);
1611         tokenContract.transfer(msg.sender, _amount);
1612         emit ExternalTokenTransfered(_tokenContract, msg.sender, _amount);
1613     }
1614 
1615     function getBalance() public view returns (uint256) {
1616         return address(this).balance;
1617     }
1618 
1619     function withdrawEthFromContract(uint256 amount) public onlyOwner {
1620         require(amount <= getBalance());
1621         address payable _owner = payable(owner());
1622         _owner.transfer(amount);
1623         emit EthFromContractTransferred(amount);
1624     }
1625     
1626     /**
1627      * @dev Hook that is called before any transfer of tokens. This includes
1628      * minting and burning.
1629      *
1630      * Calling conditions:
1631      *
1632      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1633      * will be to transferred to `to`.
1634      * - when `from` is zero, `amount` tokens will be minted for `to`.
1635      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1636      * - `from` and `to` are never both zero.
1637      *
1638      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1639      */
1640     function _beforeTokenTransfer(address from, address to) internal virtual { 
1641         require(!paused(), "ERC20Pausable: token transfer while contract paused");
1642         require(!pausedAddress[from], "ERC20Pausable: token transfer while from-address paused");
1643         require(!pausedAddress[to], "ERC20Pausable: token transfer while to-address paused");
1644     }
1645 }