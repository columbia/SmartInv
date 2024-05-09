1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * ----------------------------------------------------------------------------
6  * 
7  * Deployed to : 0x28CEE43E00F79435804C11b49F774c193659D846
8  * Symbol : PDOG
9  * Name : Polkadog
10  * Total supply: 100,000,000
11  * Decimals : 18
12  * 
13  * 2% fee auto add to the liquidity pool
14  * 2% fee auto distribute to all holders
15  * 2% fee auto burn
16  * 
17  * Deployed by Polkadog.io Ecosystem
18  * 
19  * ----------------------------------------------------------------------------
20  */
21 
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 /*
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
134         return msg.data;
135     }
136 }
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * By default, the owner account will be the one that deploys the contract. This
144  * can later be changed with {transferOwnership}.
145  *
146  * This module is used through inheritance. It will make available the modifier
147  * `onlyOwner`, which can be applied to your functions to restrict their use to
148  * the owner.
149  */
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor () {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     /**
165      * @dev Returns the address of the current owner.
166      */
167     function owner() public view virtual returns (address) {
168         return _owner;
169     }
170 
171     /**
172      * @dev Throws if called by any account other than the owner.
173      */
174     modifier onlyOwner() {
175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
176         _;
177     }
178 }
179 
180 /**
181  * @dev Contract module which allows children to implement an emergency stop
182  * mechanism that can be triggered by an authorized account.
183  *
184  * This module is used through inheritance. It will make available the
185  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
186  * the functions of your contract. Note that they will not be pausable by
187  * simply including this module, only once the modifiers are put in place.
188  */
189 abstract contract Pausable is Context {
190     /**
191      * @dev Emitted when the pause is triggered by `account`.
192      */
193     event Paused(address account);
194 
195     /**
196      * @dev Emitted when the pause is lifted by `account`.
197      */
198     event Unpaused(address account);
199 
200     bool private _paused;
201 
202     /**
203      * @dev Initializes the contract in unpaused state.
204      */
205     constructor () {
206         _paused = false;
207     }
208 
209     /**
210      * @dev Returns true if the contract is paused, and false otherwise.
211      */
212     function paused() public view virtual returns (bool) {
213         return _paused;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is not paused.
218      *
219      * Requirements:
220      *
221      * - The contract must not be paused.
222      */
223     modifier whenNotPaused() {
224         require(!paused(), "Pausable: paused");
225         _;
226     }
227 
228     /**
229      * @dev Modifier to make a function callable only when the contract is paused.
230      *
231      * Requirements:
232      *
233      * - The contract must be paused.
234      */
235     modifier whenPaused() {
236         require(paused(), "Pausable: not paused");
237         _;
238     }
239 
240     /**
241      * @dev Triggers stopped state.
242      *
243      * Requirements:
244      *
245      * - The contract must not be paused.
246      */
247     function _pause() internal virtual whenNotPaused {
248         _paused = true;
249         emit Paused(_msgSender());
250     }
251 
252     /**
253      * @dev Returns to normal state.
254      *
255      * Requirements:
256      *
257      * - The contract must be paused.
258      */
259     function _unpause() internal virtual whenPaused {
260         _paused = false;
261         emit Unpaused(_msgSender());
262     }
263 }
264 
265 /**
266  * @dev Wrappers over Solidity's arithmetic operations.
267  *
268  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
269  * now has built in overflow checking.
270  */
271 library SafeMath {
272     /**
273      * @dev Returns the addition of two unsigned integers, with an overflow flag.
274      *
275      * _Available since v3.4._
276      */
277     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             uint256 c = a + b;
280             if (c < a) return (false, 0);
281             return (true, c);
282         }
283     }
284 
285     /**
286      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
287      *
288      * _Available since v3.4._
289      */
290     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b > a) return (false, 0);
293             return (true, a - b);
294         }
295     }
296 
297     /**
298      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
299      *
300      * _Available since v3.4._
301      */
302     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         unchecked {
304             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
305             // benefit is lost if 'b' is also tested.
306             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
307             if (a == 0) return (true, 0);
308             uint256 c = a * b;
309             if (c / a != b) return (false, 0);
310             return (true, c);
311         }
312     }
313 
314     /**
315      * @dev Returns the division of two unsigned integers, with a division by zero flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         unchecked {
321             if (b == 0) return (false, 0);
322             return (true, a / b);
323         }
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
328      *
329      * _Available since v3.4._
330      */
331     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
332         unchecked {
333             if (b == 0) return (false, 0);
334             return (true, a % b);
335         }
336     }
337 
338     /**
339      * @dev Returns the addition of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `+` operator.
343      *
344      * Requirements:
345      *
346      * - Addition cannot overflow.
347      */
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         return a + b;
350     }
351 
352     /**
353      * @dev Returns the subtraction of two unsigned integers, reverting on
354      * overflow (when the result is negative).
355      *
356      * Counterpart to Solidity's `-` operator.
357      *
358      * Requirements:
359      *
360      * - Subtraction cannot overflow.
361      */
362     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a - b;
364     }
365 
366     /**
367      * @dev Returns the multiplication of two unsigned integers, reverting on
368      * overflow.
369      *
370      * Counterpart to Solidity's `*` operator.
371      *
372      * Requirements:
373      *
374      * - Multiplication cannot overflow.
375      */
376     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a * b;
378     }
379 
380     /**
381      * @dev Returns the integer division of two unsigned integers, reverting on
382      * division by zero. The result is rounded towards zero.
383      *
384      * Counterpart to Solidity's `/` operator.
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(uint256 a, uint256 b) internal pure returns (uint256) {
391         return a / b;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * reverting when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return a % b;
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
412      * overflow (when the result is negative).
413      *
414      * CAUTION: This function is deprecated because it requires allocating memory for the error
415      * message unnecessarily. For custom revert reasons use {trySub}.
416      *
417      * Counterpart to Solidity's `-` operator.
418      *
419      * Requirements:
420      *
421      * - Subtraction cannot overflow.
422      */
423     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
424         unchecked {
425             require(b <= a, errorMessage);
426             return a - b;
427         }
428     }
429 
430     /**
431      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
432      * division by zero. The result is rounded towards zero.
433      *
434      * Counterpart to Solidity's `/` operator. Note: this function uses a
435      * `revert` opcode (which leaves remaining gas untouched) while Solidity
436      * uses an invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
443         unchecked {
444             require(b > 0, errorMessage);
445             return a / b;
446         }
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * reverting with custom message when dividing by zero.
452      *
453      * CAUTION: This function is deprecated because it requires allocating memory for the error
454      * message unnecessarily. For custom revert reasons use {tryMod}.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         unchecked {
466             require(b > 0, errorMessage);
467             return a % b;
468         }
469     }
470 }
471 
472 /**
473  * @dev Collection of functions related to the address type
474  */
475 library Address {
476     /**
477      * @dev Returns true if `account` is a contract.
478      *
479      * [IMPORTANT]
480      * ====
481      * It is unsafe to assume that an address for which this function returns
482      * false is an externally-owned account (EOA) and not a contract.
483      *
484      * Among others, `isContract` will return false for the following
485      * types of addresses:
486      *
487      *  - an externally-owned account
488      *  - a contract in construction
489      *  - an address where a contract will be created
490      *  - an address where a contract lived, but was destroyed
491      * ====
492      */
493     function isContract(address account) internal view returns (bool) {
494         // This method relies on extcodesize, which returns 0 for contracts in
495         // construction, since the code is only stored at the end of the
496         // constructor execution.
497 
498         uint256 size;
499         // solhint-disable-next-line no-inline-assembly
500         assembly { size := extcodesize(account) }
501         return size > 0;
502     }
503 
504     /**
505      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
506      * `recipient`, forwarding all available gas and reverting on errors.
507      *
508      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
509      * of certain opcodes, possibly making contracts go over the 2300 gas limit
510      * imposed by `transfer`, making them unable to receive funds via
511      * `transfer`. {sendValue} removes this limitation.
512      *
513      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
514      *
515      * IMPORTANT: because control is transferred to `recipient`, care must be
516      * taken to not create reentrancy vulnerabilities. Consider using
517      * {ReentrancyGuard} or the
518      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
519      */
520     function sendValue(address payable recipient, uint256 amount) internal {
521         require(address(this).balance >= amount, "Address: insufficient balance");
522 
523         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
524         (bool success, ) = recipient.call{ value: amount }("");
525         require(success, "Address: unable to send value, recipient may have reverted");
526     }
527 
528     /**
529      * @dev Performs a Solidity function call using a low level `call`. A
530      * plain`call` is an unsafe replacement for a function call: use this
531      * function instead.
532      *
533      * If `target` reverts with a revert reason, it is bubbled up by this
534      * function (like regular Solidity function calls).
535      *
536      * Returns the raw returned data. To convert to the expected return value,
537      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
538      *
539      * Requirements:
540      *
541      * - `target` must be a contract.
542      * - calling `target` with `data` must not revert.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
547       return functionCall(target, data, "Address: low-level call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
552      * `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, 0, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but also transferring `value` wei to `target`.
563      *
564      * Requirements:
565      *
566      * - the calling contract must have an ETH balance of at least `value`.
567      * - the called Solidity function must be `payable`.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
582         require(address(this).balance >= value, "Address: insufficient balance for call");
583         require(isContract(target), "Address: call to non-contract");
584 
585         // solhint-disable-next-line avoid-low-level-calls
586         (bool success, bytes memory returndata) = target.call{ value: value }(data);
587         return _verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
597         return functionStaticCall(target, data, "Address: low-level static call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
607         require(isContract(target), "Address: static call to non-contract");
608 
609         // solhint-disable-next-line avoid-low-level-calls
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return _verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         // solhint-disable-next-line avoid-low-level-calls
634         (bool success, bytes memory returndata) = target.delegatecall(data);
635         return _verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 // solhint-disable-next-line no-inline-assembly
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 interface IUniswapV2Factory {
659     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
660 
661     function feeTo() external view returns (address);
662     function feeToSetter() external view returns (address);
663 
664     function getPair(address tokenA, address tokenB) external view returns (address pair);
665     function allPairs(uint) external view returns (address pair);
666     function allPairsLength() external view returns (uint);
667 
668     function createPair(address tokenA, address tokenB) external returns (address pair);
669 
670     function setFeeTo(address) external;
671     function setFeeToSetter(address) external;
672 }
673 
674 interface IUniswapV2Pair {
675     event Approval(address indexed owner, address indexed spender, uint value);
676     event Transfer(address indexed from, address indexed to, uint value);
677 
678     function name() external pure returns (string memory);
679     function symbol() external pure returns (string memory);
680     function decimals() external pure returns (uint8);
681     function totalSupply() external view returns (uint);
682     function balanceOf(address owner) external view returns (uint);
683     function allowance(address owner, address spender) external view returns (uint);
684 
685     function approve(address spender, uint value) external returns (bool);
686     function transfer(address to, uint value) external returns (bool);
687     function transferFrom(address from, address to, uint value) external returns (bool);
688 
689     function DOMAIN_SEPARATOR() external view returns (bytes32);
690     function PERMIT_TYPEHASH() external pure returns (bytes32);
691     function nonces(address owner) external view returns (uint);
692 
693     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
694 
695     event Mint(address indexed sender, uint amount0, uint amount1);
696     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
697     event Swap(
698         address indexed sender,
699         uint amount0In,
700         uint amount1In,
701         uint amount0Out,
702         uint amount1Out,
703         address indexed to
704     );
705     event Sync(uint112 reserve0, uint112 reserve1);
706 
707     function MINIMUM_LIQUIDITY() external pure returns (uint);
708     function factory() external view returns (address);
709     function token0() external view returns (address);
710     function token1() external view returns (address);
711     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
712     function price0CumulativeLast() external view returns (uint);
713     function price1CumulativeLast() external view returns (uint);
714     function kLast() external view returns (uint);
715 
716     function mint(address to) external returns (uint liquidity);
717     function burn(address to) external returns (uint amount0, uint amount1);
718     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
719     function skim(address to) external;
720     function sync() external;
721 
722     function initialize(address, address) external;
723 }
724 
725 interface IUniswapV2Router01 {
726     function factory() external pure returns (address);
727     function WETH() external pure returns (address);
728 
729     function addLiquidity(
730         address tokenA,
731         address tokenB,
732         uint amountADesired,
733         uint amountBDesired,
734         uint amountAMin,
735         uint amountBMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountA, uint amountB, uint liquidity);
739     function addLiquidityETH(
740         address token,
741         uint amountTokenDesired,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline
746     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
747     function removeLiquidity(
748         address tokenA,
749         address tokenB,
750         uint liquidity,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB);
756     function removeLiquidityETH(
757         address token,
758         uint liquidity,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountToken, uint amountETH);
764     function removeLiquidityWithPermit(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline,
772         bool approveMax, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint amountA, uint amountB);
774     function removeLiquidityETHWithPermit(
775         address token,
776         uint liquidity,
777         uint amountTokenMin,
778         uint amountETHMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountToken, uint amountETH);
783     function swapExactTokensForTokens(
784         uint amountIn,
785         uint amountOutMin,
786         address[] calldata path,
787         address to,
788         uint deadline
789     ) external returns (uint[] memory amounts);
790     function swapTokensForExactTokens(
791         uint amountOut,
792         uint amountInMax,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external returns (uint[] memory amounts);
797     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
798         external
799         payable
800         returns (uint[] memory amounts);
801     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
802         external
803         returns (uint[] memory amounts);
804     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
805         external
806         returns (uint[] memory amounts);
807     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
808         external
809         payable
810         returns (uint[] memory amounts);
811 
812     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
813     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
814     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
815     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
816     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
817 }
818 
819 interface IUniswapV2Router02 is IUniswapV2Router01 {
820     function removeLiquidityETHSupportingFeeOnTransferTokens(
821         address token,
822         uint liquidity,
823         uint amountTokenMin,
824         uint amountETHMin,
825         address to,
826         uint deadline
827     ) external returns (uint amountETH);
828     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
829         address token,
830         uint liquidity,
831         uint amountTokenMin,
832         uint amountETHMin,
833         address to,
834         uint deadline,
835         bool approveMax, uint8 v, bytes32 r, bytes32 s
836     ) external returns (uint amountETH);
837 
838     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
839         uint amountIn,
840         uint amountOutMin,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external;
845     function swapExactETHForTokensSupportingFeeOnTransferTokens(
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external payable;
851     function swapExactTokensForETHSupportingFeeOnTransferTokens(
852         uint amountIn,
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external;
858 }
859 
860 /**
861  * @dev Implementation of the {IERC20} interface.
862  *
863  * This implementation is agnostic to the way tokens are created. This means
864  * that a supply mechanism has to be added in a derived contract using {_mint}.
865  * For a generic mechanism see {ERC20PresetMinterPauser}.
866  *
867  * TIP: For a detailed writeup see our guide
868  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
869  * to implement supply mechanisms].
870  *
871  * We have followed general OpenZeppelin guidelines: functions revert instead
872  * of returning `false` on failure. This behavior is nonetheless conventional
873  * and does not conflict with the expectations of ERC20 applications.
874  *
875  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
876  * This allows applications to reconstruct the allowance for all accounts just
877  * by listening to said events. Other implementations of the EIP may not emit
878  * these events, as it isn't required by the specification.
879  *
880  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
881  * functions have been added to mitigate the well-known issues around setting
882  * allowances. See {IERC20-approve}.
883  */
884 contract Polkadog is Context, IERC20, IERC20Metadata, Ownable, Pausable {
885     using SafeMath for uint256;
886     using Address for address;
887 
888     mapping (address => uint256) private _rOwned;
889     mapping (address => uint256) private _tOwned;
890     mapping (address => mapping (address => uint256)) private _allowances;
891     mapping (address => bool) private pausedAddress;
892     mapping (address => bool) private _isIncludedInFee;
893     mapping (address => bool) private _isExcludedFromMaxTx;
894     mapping (address => bool) private _isExcluded;
895     address[] private _excluded;
896     
897     address UNISWAPV2ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
898    
899     uint256 private constant MAX = ~uint256(0);
900     uint256 private _tTotal = 100000000 * 10**18;
901     uint256 private _rTotal = (MAX - (MAX % _tTotal));
902     uint256 private _tFeeTotal;
903 
904     string private constant _name = "Polkadog";
905     string private constant _symbol = "PDOG";
906     uint8 private constant _decimals = 18;
907     
908     uint256 public _taxFee = 2;
909     uint256 private _previousTaxFee = _taxFee;
910     
911     uint256 public _liquidityFee = 2;
912     uint256 private _previousLiquidityFee = _liquidityFee;
913     
914     uint256 public _transaction_burn = 2;
915     uint256 private _previousTransactionBurn = _transaction_burn;
916     
917     uint private _deploy_timstamp;
918     uint private constant _max_days = 21 days;
919 
920     IUniswapV2Router02 public immutable uniswapV2Router;
921     address public immutable uniswapV2Pair;
922     
923     bool inSwapAndLiquify;
924     bool public swapAndLiquifyEnabled = true;
925     bool public _enableFee = true;
926     
927     uint256 public _maxTxAmount = 50000 * 10**18;
928     uint256 private constant numTokensSellToAddToLiquidity = 10000 * 10**18;
929     
930     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
931     event SwapAndLiquifyEnabledUpdated(bool enabled);
932     event SwapAndLiquify(
933         uint256 tokensSwapped,
934         uint256 ethReceived,
935         uint256 tokensIntoLiqudity
936     );
937     
938     modifier lockTheSwap {
939         inSwapAndLiquify = true;
940         _;
941         inSwapAndLiquify = false;
942     }
943     
944     uint256 _amount_burnt = 0;
945     
946     constructor () {
947         _rOwned[_msgSender()] = _rTotal;
948         
949         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPV2ROUTER);
950          // Create a uniswap pair for this new token
951         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
952             .createPair(address(this), _uniswapV2Router.WETH());
953 
954         // set the rest of the contract variables
955         uniswapV2Router = _uniswapV2Router;
956         
957         // include in fee
958         includeInFee(UNISWAPV2ROUTER);
959         
960         _deploy_timstamp = _setDeployDate();
961         emit Transfer(address(0), _msgSender(), _tTotal);
962     }
963 
964     /**
965      * @dev Returns the name of the token.
966      */
967     function name() external view virtual override returns (string memory) {
968         return _name;
969     }
970 
971     /**
972      * @dev Returns the symbol of the token, usually a shorter version of the
973      * name.
974      */
975     function symbol() external view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev Returns the number of decimals used to get its user representation.
981      * For example, if `decimals` equals `2`, a balance of `505` tokens should
982      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
983      *
984      * Tokens usually opt for a value of 18, imitating the relationship between
985      * Ether and Wei. This is the value {ERC20} uses, unless this function is
986      * overridden;
987      *
988      * NOTE: This information is only used for _display_ purposes: it in
989      * no way affects any of the arithmetic of the contract, including
990      * {IERC20-balanceOf} and {IERC20-transfer}.
991      */
992     function decimals() external view virtual override returns (uint8) {
993         return 18;
994     }
995 
996     /**
997      * @dev See {IERC20-totalSupply}.
998      */
999     function totalSupply() external view virtual override returns (uint256) {
1000         return _tTotal - _amount_burnt;
1001     }
1002 
1003     /**
1004      * @dev See {IERC20-balanceOf}.
1005      */
1006     function balanceOf(address account) public view virtual override returns (uint256) {
1007         if (_isExcluded[account]) return _tOwned[account];
1008         return tokenFromReflection(_rOwned[account]);
1009     }
1010 
1011     /**
1012      * @dev See {IERC20-transfer}.
1013      *
1014      * Requirements:
1015      *
1016      * - `recipient` cannot be the zero address.
1017      * - the caller must have a balance of at least `amount`.
1018      */
1019     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
1020         _transfer(_msgSender(), recipient, amount);
1021         return true;
1022     }
1023     
1024     /**
1025      * @dev See {IERC20-transfer}.
1026      *
1027      * Requirements:
1028      *
1029      * - `recipient` cannot be the zero address.
1030      * - the caller must have a balance of at least `amount`.
1031      */
1032     function transferToDistributors(address recipient, uint256 amount) external virtual onlyOwner () {
1033         require(_msgSender() != address(0), "ERC20: transfer from the zero address");
1034         require(recipient != address(0), "ERC20: transfer to the zero address");
1035         require(amount > 0, "Transfer amount must be greater than zero");
1036 
1037         _beforeTokenTransfer(_msgSender(), recipient);
1038         
1039         uint256 senderBalance = balanceOf(_msgSender());
1040         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1041         
1042         _tokenTransfer(_msgSender(), recipient, amount, false);
1043     }
1044 
1045     /**
1046      * @dev See {IERC20-allowance}.
1047      */
1048     function allowance(address owner, address spender) external view virtual override returns (uint256) {
1049         return _allowances[owner][spender];
1050     }
1051 
1052     /**
1053      * @dev See {IERC20-approve}.
1054      *
1055      * Requirements:
1056      *
1057      * - `spender` cannot be the zero address.
1058      */
1059     function approve(address spender, uint256 amount) external virtual override returns (bool) {
1060         _approve(_msgSender(), spender, amount);
1061         return true;
1062     }
1063 
1064     /**
1065      * @dev See {IERC20-transferFrom}.
1066      *
1067      * Emits an {Approval} event indicating the updated allowance. This is not
1068      * required by the EIP. See the note at the beginning of {ERC20}.
1069      *
1070      * Requirements:
1071      *
1072      * - `sender` and `recipient` cannot be the zero address.
1073      * - `sender` must have a balance of at least `amount`.
1074      * - the caller must have allowance for ``sender``'s tokens of at least
1075      * `amount`.
1076      */
1077     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
1078         _transfer(sender, recipient, amount);
1079 
1080         uint256 currentAllowance = _allowances[sender][_msgSender()];
1081         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1082         _approve(sender, _msgSender(), currentAllowance - amount);
1083 
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev Atomically increases the allowance granted to `spender` by the caller.
1089      *
1090      * This is an alternative to {approve} that can be used as a mitigation for
1091      * problems described in {IERC20-approve}.
1092      *
1093      * Emits an {Approval} event indicating the updated allowance.
1094      *
1095      * Requirements:
1096      *
1097      * - `spender` cannot be the zero address.
1098      */
1099     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
1100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1101         return true;
1102     }
1103 
1104     /**
1105      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1106      *
1107      * This is an alternative to {approve} that can be used as a mitigation for
1108      * problems described in {IERC20-approve}.
1109      *
1110      * Emits an {Approval} event indicating the updated allowance.
1111      *
1112      * Requirements:
1113      *
1114      * - `spender` cannot be the zero address.
1115      * - `spender` must have allowance for the caller of at least
1116      * `subtractedValue`.
1117      */
1118     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
1119         uint256 currentAllowance = _allowances[_msgSender()][spender];
1120         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1121         unchecked {
1122             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1123         }
1124 
1125         return true;
1126     }
1127     
1128         /**
1129      * @dev Pause `contract` - pause events.
1130      *
1131      * See {ERC20Pausable-_pause}.
1132      */
1133     function pauseContract() external virtual onlyOwner {
1134         _pause();
1135     }
1136     
1137     /**
1138      * @dev Pause `contract` - pause events.
1139      *
1140      * See {ERC20Pausable-_pause}.
1141      */
1142     function unPauseContract() external virtual onlyOwner {
1143         _unpause();
1144     }
1145 
1146     /**
1147      * @dev Pause `contract` - pause events.
1148      *
1149      * See {ERC20Pausable-_pause}.
1150      */
1151     function pauseAddress(address account) external virtual onlyOwner {
1152         excludeFromReward(account);
1153         pausedAddress[account] = true;
1154     }
1155     
1156     /**
1157      * @dev Pause `contract` - pause events.
1158      *
1159      * See {ERC20Pausable-_pause}.
1160      */
1161     function unPauseAddress(address account) external virtual onlyOwner {
1162         includeInReward(account);
1163         pausedAddress[account] = false;
1164     }
1165     
1166     /**
1167      * @dev Returns true if the address is paused, and false otherwise.
1168      */
1169     function isAddressPaused(address account) external view virtual returns (bool) {
1170         return pausedAddress[account];
1171     }
1172     
1173     /**
1174      * @dev Get current date timestamp.
1175      */
1176     function _setDeployDate() internal virtual returns (uint) {
1177         uint date = block.timestamp;    
1178         return date;
1179     }
1180 
1181     function isExcludedFromReward(address account) external view returns (bool) {
1182         return _isExcluded[account];
1183     }
1184     
1185     function isExcludedFromMaxTx(address account) external view returns (bool) {
1186         return _isExcludedFromMaxTx[account];
1187     }
1188 
1189     function totalFees() external view returns (uint256) {
1190         return _tFeeTotal;
1191     }
1192 
1193     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
1194         require(tAmount <= _tTotal, "Amount must be less than supply");
1195         if (!deductTransferFee) {
1196             (uint256 rAmount,,,,,,) = _getValues(tAmount);
1197             return rAmount;
1198         } else {
1199             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
1200             return rTransferAmount;
1201         }
1202     }
1203 
1204     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1205         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1206         uint256 currentRate =  _getRate();
1207         return rAmount.div(currentRate);
1208     }
1209 
1210     function excludeFromReward(address account) public onlyOwner() {
1211         require(!_isExcluded[account], "Account is already excluded");
1212         if(_rOwned[account] > 0) {
1213             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1214         }
1215         _isExcluded[account] = true;
1216         _excluded.push(account);
1217     }
1218 
1219     function includeInReward(address account) public onlyOwner() {
1220         require(_isExcluded[account], "Account is already excluded");
1221         for (uint256 i = 0; i < _excluded.length; i++) {
1222             if (_excluded[i] == account) {
1223                 _excluded[i] = _excluded[_excluded.length - 1];
1224                 _tOwned[account] = 0;
1225                 _isExcluded[account] = false;
1226                 _excluded.pop();
1227                 break;
1228             }
1229         }
1230     }
1231 
1232     
1233     function excludeFromFee(address account) external onlyOwner {
1234         _isIncludedInFee[account] = false;
1235     }
1236     
1237     function includeInFee(address account) public onlyOwner {
1238         _isIncludedInFee[account] = true;
1239     }
1240     
1241     function excludeFromMaxTx(address account) external onlyOwner {
1242         _isExcludedFromMaxTx[account] = true;
1243     }
1244     
1245     function includeInMaxTx(address account) external onlyOwner {
1246         _isExcludedFromMaxTx[account] = false;
1247     }
1248     
1249     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1250         _taxFee = taxFee;
1251     }
1252     
1253     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1254         _liquidityFee = liquidityFee;
1255     }
1256     
1257     function setBurnPercent(uint256 burn_percentage) external onlyOwner() {
1258         _transaction_burn = burn_percentage;
1259     }
1260    
1261     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1262         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1263             10**2
1264         );
1265     }
1266 
1267     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1268         swapAndLiquifyEnabled = _enabled;
1269         emit SwapAndLiquifyEnabledUpdated(_enabled);
1270     }
1271     
1272     function enableFee(bool enableTax) external onlyOwner() {
1273         _enableFee = enableTax;
1274     }
1275     
1276      //to recieve ETH from uniswapV2Router when swaping
1277     receive() external payable {}
1278 
1279     function _reflectFee(uint256 rFee, uint256 tFee) private {
1280         _rTotal = _rTotal.sub(rFee);
1281         _tFeeTotal = _tFeeTotal.add(tFee);
1282     }
1283 
1284     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1285         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
1286         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tBurn, _getRate());
1287         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
1288     }
1289 
1290     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1291         uint256 tFee = calculateTaxFee(tAmount);
1292         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1293         uint256 tBurn = calculateTransactionBurn(tAmount);
1294         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
1295         return (tTransferAmount, tFee, tLiquidity, tBurn);
1296     }
1297 
1298     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1299         uint256 rAmount = tAmount.mul(currentRate);
1300         uint256 rFee = tFee.mul(currentRate);
1301         uint256 rLiquidity = tLiquidity.mul(currentRate);
1302         uint256 rBurn = tBurn.mul(currentRate);
1303         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
1304         return (rAmount, rTransferAmount, rFee);
1305     }
1306 
1307     function _getRate() private view returns(uint256) {
1308         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1309         return rSupply.div(tSupply);
1310     }
1311 
1312     function _getCurrentSupply() private view returns(uint256, uint256) {
1313         uint256 rSupply = _rTotal;
1314         uint256 tSupply = _tTotal;      
1315         for (uint256 i = 0; i < _excluded.length; i++) {
1316             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1317             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1318             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1319         }
1320         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1321         return (rSupply, tSupply);
1322     }
1323     
1324     function _takeLiquidity(uint256 tLiquidity) private {
1325         uint256 currentRate =  _getRate();
1326         uint256 rLiquidity = tLiquidity.mul(currentRate);
1327         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1328         if(_isExcluded[address(this)])
1329             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1330     }
1331     
1332     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1333         return _amount.mul(_taxFee).div(
1334             10**2
1335         );
1336     }
1337 
1338     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1339         return _amount.mul(_liquidityFee).div(
1340             10**2
1341         );
1342     }
1343     
1344     function calculateTransactionBurn(uint256 _amount) private view returns (uint256) {
1345         return _amount.mul(_transaction_burn).div(
1346             10**2
1347         );
1348     }
1349     
1350     function removeAllFee() private {
1351         if(_taxFee == 0 && _liquidityFee == 0 && _transaction_burn == 0) return;
1352         
1353         _previousTaxFee = _taxFee;
1354         _previousLiquidityFee = _liquidityFee;
1355         _previousTransactionBurn = _transaction_burn;
1356         
1357         _taxFee = 0;
1358         _liquidityFee = 0;
1359         _transaction_burn = 0;
1360     }
1361     
1362     function restoreAllFee() private {
1363         _taxFee = _previousTaxFee;
1364         _liquidityFee = _previousLiquidityFee;
1365         _transaction_burn = _previousTransactionBurn;
1366     }
1367     
1368     function isIncludedInFee(address account) external view returns(bool) {
1369         return _isIncludedInFee[account];
1370     }
1371 
1372     /**
1373      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1374      *
1375      * This internal function is equivalent to `approve`, and can be used to
1376      * e.g. set automatic allowances for certain subsystems, etc.
1377      *
1378      * Emits an {Approval} event.
1379      *
1380      * Requirements:
1381      *
1382      * - `owner` cannot be the zero address.
1383      * - `spender` cannot be the zero address.
1384      */
1385     function _approve(address owner, address spender, uint256 amount) internal virtual {
1386         require(owner != address(0), "ERC20: approve from the zero address");
1387         require(spender != address(0), "ERC20: approve to the zero address");
1388 
1389         _allowances[owner][spender] = amount;
1390         emit Approval(owner, spender, amount);
1391     }
1392 
1393     /**
1394      * @dev Moves tokens `amount` from `sender` to `recipient`.
1395      *
1396      * This is internal function is equivalent to {transfer}, and can be used to
1397      * e.g. implement automatic token fees, slashing mechanisms, etc.
1398      *
1399      * Emits a {Transfer} event.
1400      *
1401      * Requirements:
1402      *
1403      * - `sender` cannot be the zero address.
1404      * - `recipient` cannot be the zero address.
1405      * - `sender` must have a balance of at least `amount`.
1406      */
1407     function _transfer(
1408         address from,
1409         address to,
1410         uint256 amount
1411     ) private {
1412         require(from != address(0), "ERC20: transfer from the zero address");
1413         require(to != address(0), "ERC20: transfer to the zero address");
1414         require(amount > 0, "Transfer amount must be greater than zero");
1415 
1416         _beforeTokenTransfer(from, to);
1417         
1418         uint256 senderBalance = balanceOf(from);
1419         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1420         
1421         //indicates if fee should be deducted from transfer
1422         bool takeFee;
1423         
1424         //if any account belongs to _isIncludedInFee account then take fee
1425         //else remove fee
1426         if(_enableFee && (_isIncludedInFee[from] || _isIncludedInFee[to])){
1427             if (block.timestamp <= (_deploy_timstamp + _max_days)) {
1428                 uint256 recipientBalance = balanceOf(to);
1429                 require(amount <= _maxTxAmount, "ERC20: Transfer amount exceeds maxTxAmount");
1430                 if(!_isExcludedFromMaxTx[to])
1431                     require(recipientBalance + amount <= _maxTxAmount, "ERC20: Recipient amount exceeds maxTxAmount");
1432             }
1433             takeFee = true;
1434             _swapAndLiquify(from);
1435         } else {
1436             takeFee = false;
1437         }
1438         
1439         //transfer amount, it will take tax, burn, liquidity fee
1440         _tokenTransfer(from,to,amount,takeFee);
1441     }
1442 
1443     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1444         // split the contract balance into halves
1445         uint256 half = contractTokenBalance.div(2);
1446         uint256 otherHalf = contractTokenBalance.sub(half);
1447 
1448         // capture the contract's current ETH balance.
1449         // this is so that we can capture exactly the amount of ETH that the
1450         // swap creates, and not make the liquidity event include any ETH that
1451         // has been manually sent to the contract
1452         uint256 initialBalance = address(this).balance;
1453 
1454         // swap tokens for ETH
1455         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1456 
1457         // how much ETH did we just swap into?
1458         uint256 newBalance = address(this).balance.sub(initialBalance);
1459 
1460         // add liquidity to uniswap
1461         addLiquidity(otherHalf, newBalance);
1462         
1463         emit SwapAndLiquify(half, newBalance, otherHalf);
1464     }
1465 
1466     function swapTokensForEth(uint256 tokenAmount) private {
1467         // generate the uniswap pair path of token -> weth
1468         address[] memory path = new address[](2);
1469         path[0] = address(this);
1470         path[1] = uniswapV2Router.WETH();
1471 
1472         _approve(address(this), address(uniswapV2Router), tokenAmount);
1473 
1474         // make the swap
1475         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1476             tokenAmount,
1477             0, // accept any amount of ETH
1478             path,
1479             address(this),
1480             block.timestamp
1481         );
1482     }
1483 
1484     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1485         // approve token transfer to cover all possible scenarios
1486         _approve(address(this), address(uniswapV2Router), tokenAmount);
1487 
1488         // add the liquidity
1489         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1490             address(this),
1491             tokenAmount,
1492             0, // slippage is unavoidable
1493             0, // slippage is unavoidable
1494             owner(),
1495             block.timestamp
1496         );
1497     }
1498 
1499     //this method is responsible for taking all fee, if takeFee is true
1500     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1501         if(!takeFee)
1502             removeAllFee();
1503         
1504         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1505             _transferFromExcluded(sender, recipient, amount);
1506         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1507             _transferToExcluded(sender, recipient, amount);
1508         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1509             _transferStandard(sender, recipient, amount);
1510         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1511             _transferBothExcluded(sender, recipient, amount);
1512         } else {
1513             _transferStandard(sender, recipient, amount);
1514         }
1515         
1516         if(!takeFee)
1517             restoreAllFee();
1518     }
1519     
1520     function _swapAndLiquify(address from) private {
1521         // is the token balance of this contract address over the min number of
1522         // tokens that we need to initiate a swap + liquidity lock?
1523         // also, don't get caught in a circular liquidity event.
1524         // also, don't swap & liquify if sender is uniswap pair.
1525         uint256 contractTokenBalance = balanceOf(address(this));
1526         
1527         if(contractTokenBalance >= _maxTxAmount)
1528         {
1529             contractTokenBalance = _maxTxAmount;
1530         }
1531         
1532         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1533         if (
1534             overMinTokenBalance &&
1535             !inSwapAndLiquify &&
1536             from != uniswapV2Pair &&
1537             swapAndLiquifyEnabled
1538         ) {
1539             contractTokenBalance = numTokensSellToAddToLiquidity;
1540             //add liquidity
1541             swapAndLiquify(contractTokenBalance);
1542         }
1543     }
1544 
1545     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1546         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1547         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1548         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1549         _takeLiquidity(tLiquidity);
1550         _reflectFee(rFee, tFee);
1551         if(tBurn > 0) {
1552             _amount_burnt += tBurn;
1553             emit Transfer(sender, address(0), tBurn);
1554         }
1555         emit Transfer(sender, recipient, tTransferAmount);
1556     }
1557     
1558     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1559         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1560         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1561         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1562         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1563         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1564         _takeLiquidity(tLiquidity);
1565         _reflectFee(rFee, tFee);
1566         if(tBurn > 0) {
1567             _amount_burnt += tBurn;
1568             emit Transfer(sender, address(0), tBurn);
1569         }
1570         emit Transfer(sender, recipient, tTransferAmount);
1571     }
1572     
1573     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1574         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1575         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1576         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1577         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1578         _takeLiquidity(tLiquidity);
1579         _reflectFee(rFee, tFee);
1580         if(tBurn > 0) {
1581             _amount_burnt += tBurn;
1582             emit Transfer(sender, address(0), tBurn);
1583         }
1584         emit Transfer(sender, recipient, tTransferAmount);
1585     }
1586 
1587     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1588         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1589         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1590         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1591         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1592         _takeLiquidity(tLiquidity);
1593         _reflectFee(rFee, tFee);
1594         if(tBurn > 0) {
1595             _amount_burnt += tBurn;
1596             emit Transfer(sender, address(0), tBurn);
1597         }
1598         emit Transfer(sender, recipient, tTransferAmount);
1599     }
1600     
1601     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1602      * the total supply.
1603      *
1604      * Emits a {Transfer} event with `from` set to the zero address.
1605      *
1606      * Requirements:
1607      *
1608      * - `account` cannot be the zero address.
1609      */
1610     function _mint(address account, uint256 amount) internal virtual {
1611         require(account != address(0), "ERC20: mint to the zero address");
1612 
1613         _beforeTokenTransfer(address(0), account);
1614 
1615         _tTotal += amount;
1616         _rOwned[account] += amount;
1617         emit Transfer(address(0), account, amount);
1618     }
1619     
1620     /**
1621      * @dev Destroys `amount` tokens from `account`, reducing the
1622      * total supply.
1623      *
1624      * Emits a {Transfer} event with `to` set to the zero address.
1625      *
1626      * Requirements:
1627      *
1628      * - `account` cannot be the zero address.
1629      * - `account` must have at least `amount` tokens.
1630      */
1631     function _burn(address account, uint256 amount) internal virtual {
1632         require(account != address(0), "ERC20: burn from the zero address");
1633 
1634         _beforeTokenTransfer(account, address(0));
1635 
1636         uint256 accountBalance = _rOwned[account];
1637         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1638         unchecked {
1639             _rOwned[account] = accountBalance - amount;
1640         }
1641         _tTotal -= amount;
1642 
1643         emit Transfer(account, address(0), amount);
1644     }
1645     
1646     
1647     /**
1648      * @dev Hook that is called before any transfer of tokens. This includes
1649      * minting and burning.
1650      *
1651      * Calling conditions:
1652      *
1653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1654      * will be to transferred to `to`.
1655      * - when `from` is zero, `amount` tokens will be minted for `to`.
1656      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1657      * - `from` and `to` are never both zero.
1658      *
1659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1660      */
1661     function _beforeTokenTransfer(address from, address to) internal virtual { 
1662         require(!paused(), "ERC20Pausable: token transfer while contract paused");
1663         require(!pausedAddress[from], "ERC20Pausable: token transfer while from-address paused");
1664         require(!pausedAddress[to], "ERC20Pausable: token transfer while to-address paused");
1665     }
1666 
1667 }