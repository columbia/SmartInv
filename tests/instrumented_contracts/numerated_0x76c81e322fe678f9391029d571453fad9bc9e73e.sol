1 // SPDX-License-Identifier: MIT
2 /**
3  * @dev Interface of the ERC20 standard as defined in the EIP.
4  */
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `to`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address to, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `from` to `to` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address from,
61         address to,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
84 
85 // pragma solidity ^0.8.0;
86 
87 // CAUTION
88 // This version of SafeMath should only be used with Solidity 0.8 or later,
89 // because it relies on the compiler's built in overflow checks.
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations.
93  *
94  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
95  * now has built in overflow checking.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             uint256 c = a + b;
106             if (c < a) return (false, 0);
107             return (true, c);
108         }
109     }
110 
111     /**
112      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b > a) return (false, 0);
119             return (true, a - b);
120         }
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         unchecked {
130             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131             // benefit is lost if 'b' is also tested.
132             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133             if (a == 0) return (true, 0);
134             uint256 c = a * b;
135             if (c / a != b) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141      * @dev Returns the division of two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b == 0) return (false, 0);
148             return (true, a / b);
149         }
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             if (b == 0) return (false, 0);
160             return (true, a % b);
161         }
162     }
163 
164     /**
165      * @dev Returns the addition of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `+` operator.
169      *
170      * Requirements:
171      *
172      * - Addition cannot overflow.
173      */
174     function add(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a + b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         return a - b;
190     }
191 
192     /**
193      * @dev Returns the multiplication of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `*` operator.
197      *
198      * Requirements:
199      *
200      * - Multiplication cannot overflow.
201      */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a * b;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator.
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a / b;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * reverting when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a % b;
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * CAUTION: This function is deprecated because it requires allocating memory for the error
241      * message unnecessarily. For custom revert reasons use {trySub}.
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      *
247      * - Subtraction cannot overflow.
248      */
249     function sub(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         unchecked {
255             require(b <= a, errorMessage);
256             return a - b;
257         }
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function div(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         unchecked {
278             require(b > 0, errorMessage);
279             return a / b;
280         }
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * reverting with custom message when dividing by zero.
286      *
287      * CAUTION: This function is deprecated because it requires allocating memory for the error
288      * message unnecessarily. For custom revert reasons use {tryMod}.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         unchecked {
304             require(b > 0, errorMessage);
305             return a % b;
306         }
307     }
308 }
309 
310 
311 // Dependency file: @openzeppelin/contracts/utils/Context.sol
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
314 
315 // pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Provides information about the current execution context, including the
319  * sender of the transaction and its data. While these are generally available
320  * via msg.sender and msg.data, they should not be accessed in such a direct
321  * manner, since when dealing with meta-transactions the account sending and
322  * paying for execution may not be the actual sender (as far as an application
323  * is concerned).
324  *
325  * This contract is only required for intermediate, library-like contracts.
326  */
327 abstract contract Context {
328     function _msgSender() internal view virtual returns (address) {
329         return msg.sender;
330     }
331 
332     function _msgData() internal view virtual returns (bytes calldata) {
333         return msg.data;
334     }
335 }
336 
337 
338 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
339 
340 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
341 
342 // pragma solidity ^0.8.0;
343 
344 // import "@openzeppelin/contracts/utils/Context.sol";
345 
346 /**
347  * @dev Contract module which provides a basic access control mechanism, where
348  * there is an account (an owner) that can be granted exclusive access to
349  * specific functions.
350  *
351  * By default, the owner account will be the one that deploys the contract. This
352  * can later be changed with {transferOwnership}.
353  *
354  * This module is used through inheritance. It will make available the modifier
355  * `onlyOwner`, which can be applied to your functions to restrict their use to
356  * the owner.
357  */
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     /**
364      * @dev Initializes the contract setting the deployer as the initial owner.
365      */
366     constructor() {
367         _transferOwnership(_msgSender());
368     }
369 
370     /**
371      * @dev Returns the address of the current owner.
372      */
373     function owner() public view virtual returns (address) {
374         return _owner;
375     }
376 
377     /**
378      * @dev Throws if called by any account other than the owner.
379      */
380     modifier onlyOwner() {
381         require(owner() == _msgSender(), "Ownable: caller is not the owner");
382         _;
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _transferOwnership(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Internal function without access restriction.
408      */
409     function _transferOwnership(address newOwner) internal virtual {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 
417 // Dependency file: @openzeppelin/contracts/utils/Address.sol
418 
419 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
420 
421 // pragma solidity ^0.8.1;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * [IMPORTANT]
431      * ====
432      * It is unsafe to assume that an address for which this function returns
433      * false is an externally-owned account (EOA) and not a contract.
434      *
435      * Among others, `isContract` will return false for the following
436      * types of addresses:
437      *
438      *  - an externally-owned account
439      *  - a contract in construction
440      *  - an address where a contract will be created
441      *  - an address where a contract lived, but was destroyed
442      * ====
443      *
444      * [IMPORTANT]
445      * ====
446      * You shouldn't rely on `isContract` to protect against flash loan attacks!
447      *
448      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
449      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
450      * constructor.
451      * ====
452      */
453     function isContract(address account) internal view returns (bool) {
454         // This method relies on extcodesize/address.code.length, which returns 0
455         // for contracts in construction, since the code is only stored at the end
456         // of the constructor execution.
457 
458         return account.code.length > 0;
459     }
460 
461     /**
462      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
463      * `recipient`, forwarding all available gas and reverting on errors.
464      *
465      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
466      * of certain opcodes, possibly making contracts go over the 2300 gas limit
467      * imposed by `transfer`, making them unable to receive funds via
468      * `transfer`. {sendValue} removes this limitation.
469      *
470      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
471      *
472      * IMPORTANT: because control is transferred to `recipient`, care must be
473      * taken to not create reentrancy vulnerabilities. Consider using
474      * {ReentrancyGuard} or the
475      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(address(this).balance >= amount, "Address: insufficient balance");
479 
480         (bool success, ) = recipient.call{value: amount}("");
481         require(success, "Address: unable to send value, recipient may have reverted");
482     }
483 
484     /**
485      * @dev Performs a Solidity function call using a low level `call`. A
486      * plain `call` is an unsafe replacement for a function call: use this
487      * function instead.
488      *
489      * If `target` reverts with a revert reason, it is bubbled up by this
490      * function (like regular Solidity function calls).
491      *
492      * Returns the raw returned data. To convert to the expected return value,
493      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
494      *
495      * Requirements:
496      *
497      * - `target` must be a contract.
498      * - calling `target` with `data` must not revert.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionCall(target, data, "Address: low-level call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
508      * `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, 0, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but also transferring `value` wei to `target`.
523      *
524      * Requirements:
525      *
526      * - the calling contract must have an ETH balance of at least `value`.
527      * - the called Solidity function must be `payable`.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value
535     ) internal returns (bytes memory) {
536         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
541      * with `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         require(address(this).balance >= value, "Address: insufficient balance for call");
552         require(isContract(target), "Address: call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.call{value: value}(data);
555         return verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
565         return functionStaticCall(target, data, "Address: low-level static call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal view returns (bytes memory) {
579         require(isContract(target), "Address: static call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.staticcall(data);
582         return verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
592         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(
602         address target,
603         bytes memory data,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(isContract(target), "Address: delegate call to non-contract");
607 
608         (bool success, bytes memory returndata) = target.delegatecall(data);
609         return verifyCallResult(success, returndata, errorMessage);
610     }
611 
612     /**
613      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
614      * revert reason using the provided one.
615      *
616      * _Available since v4.3._
617      */
618     function verifyCallResult(
619         bool success,
620         bytes memory returndata,
621         string memory errorMessage
622     ) internal pure returns (bytes memory) {
623         if (success) {
624             return returndata;
625         } else {
626             // Look for revert reason and bubble it up if present
627             if (returndata.length > 0) {
628                 // The easiest way to bubble the revert reason is using memory via assembly
629 
630                 assembly {
631                     let returndata_size := mload(returndata)
632                     revert(add(32, returndata), returndata_size)
633                 }
634             } else {
635                 revert(errorMessage);
636             }
637         }
638     }
639 }
640 
641 
642 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
643 
644 // pragma solidity >=0.5.0;
645 
646 interface IUniswapV2Factory {
647     event PairCreated(
648         address indexed token0,
649         address indexed token1,
650         address pair,
651         uint256
652     );
653 
654     function feeTo() external view returns (address);
655 
656     function feeToSetter() external view returns (address);
657 
658     function getPair(address tokenA, address tokenB)
659         external
660         view
661         returns (address pair);
662 
663     function allPairs(uint256) external view returns (address pair);
664 
665     function allPairsLength() external view returns (uint256);
666 
667     function createPair(address tokenA, address tokenB)
668         external
669         returns (address pair);
670 
671     function setFeeTo(address) external;
672 
673     function setFeeToSetter(address) external;
674 }
675 
676 
677 // Dependency file: contracts/interfaces/IUniswapV2Pair.sol
678 
679 // pragma solidity >=0.5.0;
680 
681 interface IUniswapV2Pair {
682     event Approval(
683         address indexed owner,
684         address indexed spender,
685         uint256 value
686     );
687     event Transfer(address indexed from, address indexed to, uint256 value);
688 
689     function name() external pure returns (string memory);
690 
691     function symbol() external pure returns (string memory);
692 
693     function decimals() external pure returns (uint8);
694 
695     function totalSupply() external view returns (uint256);
696 
697     function balanceOf(address owner) external view returns (uint256);
698 
699     function allowance(address owner, address spender)
700         external
701         view
702         returns (uint256);
703 
704     function approve(address spender, uint256 value) external returns (bool);
705 
706     function transfer(address to, uint256 value) external returns (bool);
707 
708     function transferFrom(
709         address from,
710         address to,
711         uint256 value
712     ) external returns (bool);
713 
714     function DOMAIN_SEPARATOR() external view returns (bytes32);
715 
716     function PERMIT_TYPEHASH() external pure returns (bytes32);
717 
718     function nonces(address owner) external view returns (uint256);
719 
720     function permit(
721         address owner,
722         address spender,
723         uint256 value,
724         uint256 deadline,
725         uint8 v,
726         bytes32 r,
727         bytes32 s
728     ) external;
729 
730     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
731     event Burn(
732         address indexed sender,
733         uint256 amount0,
734         uint256 amount1,
735         address indexed to
736     );
737     event Swap(
738         address indexed sender,
739         uint256 amount0In,
740         uint256 amount1In,
741         uint256 amount0Out,
742         uint256 amount1Out,
743         address indexed to
744     );
745     event Sync(uint112 reserve0, uint112 reserve1);
746 
747     function MINIMUM_LIQUIDITY() external pure returns (uint256);
748 
749     function factory() external view returns (address);
750 
751     function token0() external view returns (address);
752 
753     function token1() external view returns (address);
754 
755     function getReserves()
756         external
757         view
758         returns (
759             uint112 reserve0,
760             uint112 reserve1,
761             uint32 blockTimestampLast
762         );
763 
764     function price0CumulativeLast() external view returns (uint256);
765 
766     function price1CumulativeLast() external view returns (uint256);
767 
768     function kLast() external view returns (uint256);
769 
770     function mint(address to) external returns (uint256 liquidity);
771 
772     function burn(address to)
773         external
774         returns (uint256 amount0, uint256 amount1);
775 
776     function swap(
777         uint256 amount0Out,
778         uint256 amount1Out,
779         address to,
780         bytes calldata data
781     ) external;
782 
783     function skim(address to) external;
784 
785     function sync() external;
786 
787     function initialize(address, address) external;
788 }
789 
790 
791 // Dependency file: contracts/interfaces/IUniswapV2Router01.sol
792 
793 // pragma solidity >=0.6.2;
794 
795 interface IUniswapV2Router01 {
796     function factory() external pure returns (address);
797 
798     function WETH() external pure returns (address);
799 
800     function addLiquidity(
801         address tokenA,
802         address tokenB,
803         uint256 amountADesired,
804         uint256 amountBDesired,
805         uint256 amountAMin,
806         uint256 amountBMin,
807         address to,
808         uint256 deadline
809     )
810         external
811         returns (
812             uint256 amountA,
813             uint256 amountB,
814             uint256 liquidity
815         );
816 
817     function addLiquidityETH(
818         address token,
819         uint256 amountTokenDesired,
820         uint256 amountTokenMin,
821         uint256 amountETHMin,
822         address to,
823         uint256 deadline
824     )
825         external
826         payable
827         returns (
828             uint256 amountToken,
829             uint256 amountETH,
830             uint256 liquidity
831         );
832 
833     function removeLiquidity(
834         address tokenA,
835         address tokenB,
836         uint256 liquidity,
837         uint256 amountAMin,
838         uint256 amountBMin,
839         address to,
840         uint256 deadline
841     ) external returns (uint256 amountA, uint256 amountB);
842 
843     function removeLiquidityETH(
844         address token,
845         uint256 liquidity,
846         uint256 amountTokenMin,
847         uint256 amountETHMin,
848         address to,
849         uint256 deadline
850     ) external returns (uint256 amountToken, uint256 amountETH);
851 
852     function removeLiquidityWithPermit(
853         address tokenA,
854         address tokenB,
855         uint256 liquidity,
856         uint256 amountAMin,
857         uint256 amountBMin,
858         address to,
859         uint256 deadline,
860         bool approveMax,
861         uint8 v,
862         bytes32 r,
863         bytes32 s
864     ) external returns (uint256 amountA, uint256 amountB);
865 
866     function removeLiquidityETHWithPermit(
867         address token,
868         uint256 liquidity,
869         uint256 amountTokenMin,
870         uint256 amountETHMin,
871         address to,
872         uint256 deadline,
873         bool approveMax,
874         uint8 v,
875         bytes32 r,
876         bytes32 s
877     ) external returns (uint256 amountToken, uint256 amountETH);
878 
879     function swapExactTokensForTokens(
880         uint256 amountIn,
881         uint256 amountOutMin,
882         address[] calldata path,
883         address to,
884         uint256 deadline
885     ) external returns (uint256[] memory amounts);
886 
887     function swapTokensForExactTokens(
888         uint256 amountOut,
889         uint256 amountInMax,
890         address[] calldata path,
891         address to,
892         uint256 deadline
893     ) external returns (uint256[] memory amounts);
894 
895     function swapExactETHForTokens(
896         uint256 amountOutMin,
897         address[] calldata path,
898         address to,
899         uint256 deadline
900     ) external payable returns (uint256[] memory amounts);
901 
902     function swapTokensForExactETH(
903         uint256 amountOut,
904         uint256 amountInMax,
905         address[] calldata path,
906         address to,
907         uint256 deadline
908     ) external returns (uint256[] memory amounts);
909 
910     function swapExactTokensForETH(
911         uint256 amountIn,
912         uint256 amountOutMin,
913         address[] calldata path,
914         address to,
915         uint256 deadline
916     ) external returns (uint256[] memory amounts);
917 
918     function swapETHForExactTokens(
919         uint256 amountOut,
920         address[] calldata path,
921         address to,
922         uint256 deadline
923     ) external payable returns (uint256[] memory amounts);
924 
925     function quote(
926         uint256 amountA,
927         uint256 reserveA,
928         uint256 reserveB
929     ) external pure returns (uint256 amountB);
930 
931     function getAmountOut(
932         uint256 amountIn,
933         uint256 reserveIn,
934         uint256 reserveOut
935     ) external pure returns (uint256 amountOut);
936 
937     function getAmountIn(
938         uint256 amountOut,
939         uint256 reserveIn,
940         uint256 reserveOut
941     ) external pure returns (uint256 amountIn);
942 
943     function getAmountsOut(uint256 amountIn, address[] calldata path)
944         external
945         view
946         returns (uint256[] memory amounts);
947 
948     function getAmountsIn(uint256 amountOut, address[] calldata path)
949         external
950         view
951         returns (uint256[] memory amounts);
952 }
953 
954 
955 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
956 
957 // pragma solidity >=0.6.2;
958 
959 // import "contracts/interfaces/IUniswapV2Router01.sol";
960 
961 interface IUniswapV2Router02 is IUniswapV2Router01 {
962     function removeLiquidityETHSupportingFeeOnTransferTokens(
963         address token,
964         uint256 liquidity,
965         uint256 amountTokenMin,
966         uint256 amountETHMin,
967         address to,
968         uint256 deadline
969     ) external returns (uint256 amountETH);
970 
971     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
972         address token,
973         uint256 liquidity,
974         uint256 amountTokenMin,
975         uint256 amountETHMin,
976         address to,
977         uint256 deadline,
978         bool approveMax,
979         uint8 v,
980         bytes32 r,
981         bytes32 s
982     ) external returns (uint256 amountETH);
983 
984     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
985         uint256 amountIn,
986         uint256 amountOutMin,
987         address[] calldata path,
988         address to,
989         uint256 deadline
990     ) external;
991 
992     function swapExactETHForTokensSupportingFeeOnTransferTokens(
993         uint256 amountOutMin,
994         address[] calldata path,
995         address to,
996         uint256 deadline
997     ) external payable;
998 
999     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1000         uint256 amountIn,
1001         uint256 amountOutMin,
1002         address[] calldata path,
1003         address to,
1004         uint256 deadline
1005     ) external;
1006 }
1007 
1008 
1009 // Dependency file: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1010 
1011 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1012 
1013 // pragma solidity ^0.8.0;
1014 
1015 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1016 // import "@openzeppelin/contracts/utils/Address.sol";
1017 
1018 /**
1019  * @title SafeERC20
1020  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1021  * contract returns false). Tokens that return no value (and instead revert or
1022  * throw on failure) are also supported, non-reverting calls are assumed to be
1023  * successful.
1024  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1025  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1026  */
1027 library SafeERC20 {
1028     using Address for address;
1029 
1030     function safeTransfer(
1031         IERC20 token,
1032         address to,
1033         uint256 value
1034     ) internal {
1035         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1036     }
1037 
1038     function safeTransferFrom(
1039         IERC20 token,
1040         address from,
1041         address to,
1042         uint256 value
1043     ) internal {
1044         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1045     }
1046 
1047     /**
1048      * @dev Deprecated. This function has issues similar to the ones found in
1049      * {IERC20-approve}, and its usage is discouraged.
1050      *
1051      * Whenever possible, use {safeIncreaseAllowance} and
1052      * {safeDecreaseAllowance} instead.
1053      */
1054     function safeApprove(
1055         IERC20 token,
1056         address spender,
1057         uint256 value
1058     ) internal {
1059         // safeApprove should only be called when setting an initial allowance,
1060         // or when resetting it to zero. To increase and decrease it, use
1061         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1062         require(
1063             (value == 0) || (token.allowance(address(this), spender) == 0),
1064             "SafeERC20: approve from non-zero to non-zero allowance"
1065         );
1066         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1067     }
1068 
1069     function safeIncreaseAllowance(
1070         IERC20 token,
1071         address spender,
1072         uint256 value
1073     ) internal {
1074         uint256 newAllowance = token.allowance(address(this), spender) + value;
1075         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1076     }
1077 
1078     function safeDecreaseAllowance(
1079         IERC20 token,
1080         address spender,
1081         uint256 value
1082     ) internal {
1083         unchecked {
1084             uint256 oldAllowance = token.allowance(address(this), spender);
1085             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1086             uint256 newAllowance = oldAllowance - value;
1087             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1088         }
1089     }
1090 
1091     /**
1092      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1093      * on the return value: the return value is optional (but if data is returned, it must not be false).
1094      * @param token The token targeted by the call.
1095      * @param data The call data (encoded using abi.encode or one of its variants).
1096      */
1097     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1098         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1099         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1100         // the target address contains contract code and also asserts for success in the low-level call.
1101 
1102         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1103         if (returndata.length > 0) {
1104             // Return data is optional
1105             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1106         }
1107     }
1108 }
1109 
1110 
1111 // Dependency file: contracts/parts/Withdrawable.sol
1112 
1113 
1114 // pragma solidity ^0.8.9;
1115 
1116 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1117 // import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
1118 
1119 abstract contract Withdrawable {
1120     using SafeERC20 for IERC20;
1121     using Address for address;
1122 
1123     event WithdrawToken(address token, address recipient, uint256 amount);
1124     event Withdraw(address recipient, uint256 amount);
1125 
1126     function _deliverFunds(
1127         address _recipient,
1128         uint256 _value,
1129         string memory _message
1130     ) internal {
1131         (bool sent, ) = payable(_recipient).call{value: _value}("");
1132 
1133         require(sent, _message);
1134     }
1135 
1136     function _deliverTokens(
1137         address _token,
1138         address _recipient,
1139         uint256 _value
1140     ) internal {
1141         IERC20(_token).safeTransfer(_recipient, _value);
1142     }
1143 
1144     function _withdraw(address _recipient, uint256 _amount) internal virtual {
1145         require(_recipient != address(0x0), "Withdraw: address is zero");
1146         require(
1147             _amount <= address(this).balance,
1148             "Withdraw: not enought ETH balance"
1149         );
1150 
1151         _afterWithdraw(_recipient, _amount);
1152 
1153         _deliverFunds(_recipient, _amount, "Withdraw: Can't send ETH");
1154         emit Withdraw(_recipient, _amount);
1155     }
1156 
1157     function _afterWithdraw(address _recipient, uint256 _amount)
1158         internal
1159         virtual
1160     {}
1161 
1162     function _withdrawToken(
1163         address _token,
1164         address _recipient,
1165         uint256 _amount
1166     ) internal virtual {
1167         require(_recipient != address(0x0), "Withdraw: address is zero");
1168         require(
1169             _amount <= IERC20(_token).balanceOf(address(this)),
1170             "Withdraw: not enought token balance"
1171         );
1172 
1173         IERC20(_token).safeTransfer(_recipient, _amount);
1174 
1175         _afterWithdrawToken(_token, _recipient, _amount);
1176 
1177         emit WithdrawToken(_token, _recipient, _amount);
1178     }
1179 
1180     function _afterWithdrawToken(
1181         address _token,
1182         address _recipient,
1183         uint256 _amount
1184     ) internal virtual {}
1185 }
1186 
1187 
1188 // Root file: contracts/EdFi.sol
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1193 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
1194 // import "@openzeppelin/contracts/access/Ownable.sol";
1195 // import "@openzeppelin/contracts/utils/Address.sol";
1196 // import "contracts/interfaces/IUniswapV2Factory.sol";
1197 // import "contracts/interfaces/IUniswapV2Pair.sol";
1198 // import "contracts/interfaces/IUniswapV2Router02.sol";
1199 // import "contracts/parts/Withdrawable.sol";
1200 
1201 contract EdFi is Context, IERC20, Withdrawable, Ownable {
1202     using SafeMath for uint256;
1203     using Address for address;
1204 
1205     // dead address
1206     address internal constant DEAD_ADDRESS =
1207         0x000000000000000000000000000000000000dEaD;
1208 
1209     uint256 internal constant PRECISION = 1 ether;
1210 
1211     //user balances multiplied reward
1212     mapping(address => uint256) private _rOwned;
1213 
1214     //user original balances
1215     mapping(address => uint256) private _tOwned;
1216 
1217     //allowances
1218     mapping(address => mapping(address => uint256)) private _allowances;
1219 
1220     //bots
1221     mapping(address => bool) private _isSniper;
1222 
1223     address[] private _confirmedSnipers;
1224 
1225     //excluded from fees
1226     mapping(address => bool) private _isExcludedFee;
1227 
1228     //excluded from rewards
1229     mapping(address => bool) private _isExcludedReward;
1230 
1231     //excluded array
1232     address[] private _excluded;
1233 
1234     string private constant _name = "EdFi";
1235     string private constant _symbol = "EdFi";
1236     uint8 private constant _decimals = 18;
1237 
1238     //max uint256
1239     uint256 private constant MAX = ~uint256(0);
1240 
1241     //total supply
1242     uint256 private constant _tTotal = 1_000_000_000 ether;
1243 
1244     //total with rewards
1245     uint256 private _rTotal = (MAX - (MAX % _tTotal));
1246 
1247     //total fees
1248     uint256 private _tFeeTotal;
1249 
1250     //Fees
1251 
1252     //reflection fee
1253     uint256 public reflectionFee;
1254     uint256 private _previousReflectFee;
1255 
1256     //treasury fee
1257     uint256 public treasuryFee;
1258     uint256 private _previousTreasuryFee;
1259 
1260     //Liquify fee
1261     uint256 public liquidityFee;
1262     uint256 private _previousLiquidityFee;
1263 
1264     //fee rate for minimum fees balance
1265     uint256 public feeRate;
1266 
1267     //launch time
1268     uint256 public launchTime;
1269 
1270     //uint256
1271 
1272     IUniswapV2Router02 public uniswapRouter;
1273     address public uniswapPair;
1274     mapping(address => bool) private _isUniswapPair;
1275 
1276     address public treasuryWallet;
1277 
1278     //burn address
1279     address public buybackReceiver = DEAD_ADDRESS;
1280 
1281     bool private _isSelling;
1282     bool private _tradingOpen;
1283     bool private _transferOpen;
1284 
1285     bool private _takeFeeOnTransferEnabled;
1286     bool private _takeFeeOnBuyEnabled;
1287     bool private _takeFeeOnSellEnabled;
1288 
1289     uint256 public maxSellAmount = 5 ether;
1290 
1291     mapping(address => bool) public authorized;
1292 
1293     modifier isAuthorized() {
1294         require(
1295             (authorized[_msgSender()] || owner() == _msgSender()),
1296             "EdFi Token: not authorized user"
1297         );
1298         _;
1299     }
1300 
1301     event SwapETHForTokens(address whereTo, uint256 amountIn, address[] path);
1302     event SwapTokensForETH(uint256 amountIn, address[] path);
1303     event SwapAndLiquify(uint256 ETHAddedForLp, uint256 tokensAddedForLp);
1304     event Authorized(address user, bool isAuth);
1305 
1306     constructor() {
1307         //mint to tokens to sender
1308         _rOwned[_msgSender()] = _rTotal;
1309         emit Transfer(address(0), _msgSender(), _tTotal);
1310     }
1311 
1312     function init(
1313         address _routerAddress,
1314         address _treasuryAddress,
1315         uint256 _reflectionFee,
1316         uint256 _treasuryFee,
1317         uint256 _liquidityFee,
1318         uint256 _feeRate
1319     ) external onlyOwner {
1320         treasuryWallet = _treasuryAddress;
1321 
1322         IUniswapV2Router02 _uniswapRouter = IUniswapV2Router02(
1323             _routerAddress
1324         );
1325         uniswapPair = IUniswapV2Factory(_uniswapRouter.factory())
1326             .createPair(address(this), _uniswapRouter.WETH());
1327 
1328         uniswapRouter = _uniswapRouter;
1329 
1330         //exclude owner from fees
1331         _isExcludedFee[owner()] = true;
1332 
1333         //exclude this contract from fees
1334         _isExcludedFee[address(this)] = true;
1335 
1336         require(
1337             _reflectionFee <= 100 &&
1338             _treasuryFee <= 100 &&
1339             _liquidityFee <= 100 &&
1340             _feeRate <= 100,
1341             "fee cannot exceed 100%"
1342         );
1343 
1344         reflectionFee = _reflectionFee;
1345         _previousReflectFee = reflectionFee;
1346 
1347         treasuryFee = _treasuryFee;
1348         _previousTreasuryFee = treasuryFee;
1349 
1350         liquidityFee = _liquidityFee;
1351         _previousLiquidityFee = liquidityFee;
1352 
1353         feeRate = _feeRate;
1354     }
1355 
1356     /// @notice start trading
1357     function openTrading() external onlyOwner {
1358         _tradingOpen = true;
1359         _transferOpen = true;
1360         launchTime = block.timestamp;
1361 
1362         _takeFeeOnTransferEnabled = false;
1363         _takeFeeOnBuyEnabled = true;
1364         _takeFeeOnSellEnabled = true;
1365     }
1366 
1367     function authorize(address _user, bool _isAuth) external onlyOwner {
1368         authorized[_user] = _isAuth;
1369 
1370         emit Authorized(_user, _isAuth);
1371     }
1372 
1373     /// @notice token name
1374     function name() external pure returns (string memory) {
1375         return _name;
1376     }
1377 
1378     /// @notice symbol
1379     function symbol() external pure returns (string memory) {
1380         return _symbol;
1381     }
1382 
1383     /// @notice decimals
1384     function decimals() external pure returns (uint8) {
1385         return _decimals;
1386     }
1387 
1388     /// @notice total supply
1389     function totalSupply() external pure override returns (uint256) {
1390         return _tTotal;
1391     }
1392 
1393     /// @notice balance of
1394     function balanceOf(address account) public view override returns (uint256) {
1395         if (_isExcludedReward[account]) return _tOwned[account];
1396         return tokenFromReflection(_rOwned[account]); //return tokens with reflection
1397     }
1398 
1399     function transfer(address recipient, uint256 amount)
1400         external
1401         override
1402         returns (bool)
1403     {
1404         _transfer(_msgSender(), recipient, amount);
1405         return true;
1406     }
1407 
1408     function allowance(address owner, address spender)
1409         external
1410         view
1411         override
1412         returns (uint256)
1413     {
1414         return _allowances[owner][spender];
1415     }
1416 
1417     function approve(address spender, uint256 amount)
1418         external
1419         override
1420         returns (bool)
1421     {
1422         _approve(_msgSender(), spender, amount);
1423         return true;
1424     }
1425 
1426     function transferFrom(
1427         address sender,
1428         address recipient,
1429         uint256 amount
1430     ) external override returns (bool) {
1431         _transfer(sender, recipient, amount);
1432         _approve(
1433             sender,
1434             _msgSender(),
1435             _allowances[sender][_msgSender()].sub(
1436                 amount,
1437                 "BEP20: transfer amount exceeds allowance"
1438             )
1439         );
1440         return true;
1441     }
1442 
1443     function increaseAllowance(address spender, uint256 addedValue)
1444         external
1445         virtual
1446         returns (bool)
1447     {
1448         _approve(
1449             _msgSender(),
1450             spender,
1451             _allowances[_msgSender()][spender].add(addedValue)
1452         );
1453         return true;
1454     }
1455 
1456     function decreaseAllowance(address spender, uint256 subtractedValue)
1457         external
1458         virtual
1459         returns (bool)
1460     {
1461         _approve(
1462             _msgSender(),
1463             spender,
1464             _allowances[_msgSender()][spender].sub(
1465                 subtractedValue,
1466                 "BEP20: decreased allowance below zero"
1467             )
1468         );
1469         return true;
1470     }
1471 
1472     ///@notice total fees
1473     function totalFees() external view returns (uint256) {
1474         return _tFeeTotal;
1475     }
1476 
1477     ///@notice get amount with deduction fees or no
1478     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1479         external
1480         view
1481         returns (uint256)
1482     {
1483         require(tAmount <= _tTotal, "Amount must be less than supply");
1484         if (!deductTransferFee) {
1485             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1486             return rAmount;
1487         } else {
1488             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1489             return rTransferAmount;
1490         }
1491     }
1492 
1493     ///@notice get tokens from reflection
1494     function tokenFromReflection(uint256 rAmount)
1495         public
1496         view
1497         returns (uint256)
1498     {
1499         require(
1500             rAmount <= _rTotal,
1501             "Amount must be less than total reflections"
1502         );
1503         uint256 currentRate = _getRate();
1504         return rAmount.div(currentRate);
1505     }
1506 
1507     function excludeFromReward(address account) external onlyOwner {
1508         require(!_isExcludedReward[account], "Account is already excluded");
1509         if (_rOwned[account] > 0) {
1510             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1511         }
1512         _isExcludedReward[account] = true;
1513         _excluded.push(account);
1514     }
1515 
1516     function includeInReward(address account) external onlyOwner {
1517         require(_isExcludedReward[account], "Account is already included");
1518         for (uint256 i = 0; i < _excluded.length; i++) {
1519             if (_excluded[i] == account) {
1520                 _excluded[i] = _excluded[_excluded.length - 1];
1521                 _tOwned[account] = 0;
1522                 _isExcludedReward[account] = false;
1523                 _excluded.pop();
1524                 break;
1525             }
1526         }
1527     }
1528 
1529     function _approve(
1530         address owner,
1531         address spender,
1532         uint256 amount
1533     ) private {
1534         require(owner != address(0), "BEP20: approve from the zero address");
1535         require(spender != address(0), "BEP20: approve to the zero address");
1536 
1537         _allowances[owner][spender] = amount;
1538         emit Approval(owner, spender, amount);
1539     }
1540 
1541     function _transfer(
1542         address from,
1543         address to,
1544         uint256 amount
1545     ) private {
1546         require(from != address(0), "BEP20: transfer from the zero address");
1547         require(to != address(0), "BEP20: transfer to the zero address");
1548         require(amount > 0, "Transfer amount must be greater than zero");
1549         require(!_isSniper[to], "Stop sniping!");
1550         require(!_isSniper[from], "Stop sniping!");
1551         require(!_isSniper[_msgSender()], "Stop sniping!");
1552         require(
1553             _transferOpen || from == owner(),
1554             "transferring tokens is not currently allowed"
1555         );
1556 
1557         bool takeFee = true;
1558 
1559         bool isBuying;
1560         bool isSelling;
1561 
1562         // buy
1563         if (
1564             (from == uniswapPair || _isUniswapPair[from]) &&
1565             to != address(uniswapRouter) &&
1566             _tradingOpen
1567         ) {
1568             isBuying = true;
1569 
1570             // normal buy, check for snipers
1571             if (!isExcludedFromFee(to)) {
1572                 require(_tradingOpen, "Trading not yet enabled.");
1573 
1574                 // antibot
1575                 if (block.timestamp == launchTime) {
1576                     _isSniper[to] = true;
1577                     _confirmedSnipers.push(to);
1578                 }
1579             }
1580 
1581             if (!_takeFeeOnBuyEnabled) {
1582                 takeFee = false;
1583             }
1584         }
1585 
1586         // sell or transfer
1587         if (
1588             _tradingOpen &&
1589             from != uniswapPair &&
1590             !_isUniswapPair[from] &&
1591             from != address(uniswapRouter)
1592         ) {
1593             //if sell check max amount
1594             if (
1595                 to == uniswapPair ||
1596                 _isUniswapPair[to] ||
1597                 to == address(uniswapRouter)
1598             ) {
1599                 isSelling = true;
1600 
1601                 if (!_takeFeeOnSellEnabled) {
1602                     takeFee = false;
1603                 }
1604 
1605                 (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
1606                     uniswapPair
1607                 ).getReserves();
1608 
1609                 (reserve0, reserve1) = IUniswapV2Pair(uniswapPair)
1610                     .token0() == address(this)
1611                     ? (reserve0, reserve1)
1612                     : (reserve1, reserve0);
1613 
1614                 uint256 estimatedEquivalentETH = uniswapRouter.getAmountOut(
1615                     amount,
1616                     reserve0,
1617                     reserve1
1618                 );
1619 
1620                 require(
1621                     estimatedEquivalentETH <= maxSellAmount,
1622                     "the amount of the sale is more than the available one"
1623                 );
1624             }
1625         }
1626 
1627         if (!isSelling && !isBuying && !_takeFeeOnTransferEnabled) {
1628             takeFee = false;
1629         }
1630 
1631         if ((isExcludedFromFee(from) || isExcludedFromFee(to))) {
1632             takeFee = false;
1633         }
1634 
1635         _tokenTransfer(from, to, amount, takeFee);
1636     }
1637 
1638     function distribute() external isAuthorized {
1639         uint256 _contractTokenBalance = balanceOf(address(this));
1640 
1641         if (_contractTokenBalance > 0) {
1642             uint256 maxSwapAmount = balanceOf(uniswapPair)
1643                 .mul(feeRate)
1644                 .mul(PRECISION)
1645                 .div(100)
1646                 .div(PRECISION);
1647 
1648             if (_contractTokenBalance > maxSwapAmount) {
1649                 _contractTokenBalance = maxSwapAmount;
1650             }
1651             _distribute(_contractTokenBalance);
1652         }
1653     }
1654 
1655     function _distribute(uint256 _contractTokenBalance) private {
1656         uint256 ETHBalanceBefore = address(this).balance;
1657 
1658         uint256 _liquidityFeeTotal = _liquidityFeeAggregate(); //get fees without reflection fee
1659 
1660         uint256 liquidityFeeBalance = _contractTokenBalance
1661             .mul(liquidityFee)
1662             .div(_liquidityFeeTotal);
1663 
1664         _contractTokenBalance = _contractTokenBalance - liquidityFeeBalance;
1665 
1666         _distributeForETH(_contractTokenBalance);
1667 
1668         uint256 ETHBalanceAfter = address(this).balance;
1669         uint256 ETHBalanceUpdate = ETHBalanceAfter.sub(ETHBalanceBefore);
1670 
1671         // send ETH to treasury address
1672         uint256 treasuryETHBalance = ETHBalanceUpdate;
1673 
1674         if (treasuryETHBalance > 0) {
1675             _deliverFunds(
1676                 treasuryWallet,
1677                 treasuryETHBalance,
1678                 "Cant send ETH to wallet"
1679             );
1680         }
1681 
1682         if (liquidityFeeBalance > 0) {
1683             _liquifyTokens(liquidityFeeBalance);
1684         }
1685     }
1686 
1687     function _liquifyTokens(uint256 amount) private {
1688         // split the contract balance into halves
1689         uint256 half = amount.div(2);
1690         uint256 otherHalf = amount.sub(half);
1691 
1692         if (otherHalf > balanceOf(address(this))) {
1693             otherHalf = balanceOf(address(this));
1694         }
1695 
1696         uint256 initialBalance = address(this).balance;
1697 
1698         _distributeForETH(half);
1699 
1700         uint256 newBalance = address(this).balance.sub(initialBalance);
1701 
1702         _addLiquidity(otherHalf, newBalance);
1703     }
1704 
1705     function _addLiquidity(uint256 _tokenAmount, uint256 _ETHAmount) internal {
1706         // approve token transfer to cover all possible scenarios
1707         _approve(address(this), address(uniswapRouter), _tokenAmount);
1708 
1709         (bool success, ) = payable(address(uniswapRouter)).call{
1710             value: _ETHAmount
1711         }(
1712             abi.encodeWithSignature(
1713                 "addLiquidityETH(address,uint256,uint256,uint256,address,uint256)",
1714                 address(this),
1715                 _tokenAmount,
1716                 0, // slippage is unavoidable
1717                 0, // slippage is unavoidable,
1718                 buybackReceiver,
1719                 block.timestamp
1720             )
1721         );
1722 
1723         if (success) {
1724             emit SwapAndLiquify(_ETHAmount, _tokenAmount);
1725         }
1726     }
1727 
1728     function _distributeForETH(uint256 tokenAmount) private {
1729         // generate the uniswap pair path of token -> wETH
1730         address[] memory path = new address[](2);
1731         path[0] = address(this);
1732         path[1] = uniswapRouter.WETH();
1733 
1734         _approve(address(this), address(uniswapRouter), tokenAmount);
1735 
1736         (bool success, ) = payable(address(uniswapRouter)).call(
1737             abi.encodeWithSignature(
1738                 "swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)",
1739                 tokenAmount,
1740                 0, // accept any amount of ETH
1741                 path,
1742                 address(this), // the contract
1743                 block.timestamp
1744             )
1745         );
1746         if (success) {
1747             emit SwapTokensForETH(tokenAmount, path);
1748         }
1749     }
1750 
1751     function _tokenTransfer(
1752         address sender,
1753         address recipient,
1754         uint256 amount,
1755         bool takeFee
1756     ) private {
1757         if (!takeFee) {
1758             _removeAllFee();
1759         }
1760 
1761         if (_isExcludedReward[sender] && !_isExcludedReward[recipient]) {
1762             _transferFromExcluded(sender, recipient, amount);
1763         } else if (!_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1764             _transferToExcluded(sender, recipient, amount);
1765         } else if (_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1766             _transferBothExcluded(sender, recipient, amount);
1767         } else {
1768             _transferStandard(sender, recipient, amount);
1769         }
1770 
1771         if (!takeFee) _restoreAllFee();
1772     }
1773 
1774     function _transferStandard(
1775         address sender,
1776         address recipient,
1777         uint256 tAmount
1778     ) private {
1779         (
1780             uint256 rAmount,
1781             uint256 rTransferAmount,
1782             uint256 rFee,
1783             uint256 tTransferAmount,
1784             uint256 tFee,
1785             uint256 tLiquidity
1786         ) = _getValues(tAmount);
1787 
1788         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1789         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1790         _takeLiquidity(tLiquidity);
1791 
1792         _reflectFee(rFee, tFee);
1793         emit Transfer(sender, recipient, tTransferAmount);
1794     }
1795 
1796     function _transferToExcluded(
1797         address sender,
1798         address recipient,
1799         uint256 tAmount
1800     ) private {
1801         (
1802             uint256 rAmount,
1803             uint256 rTransferAmount,
1804             uint256 rFee,
1805             uint256 tTransferAmount,
1806             uint256 tFee,
1807             uint256 tLiquidity
1808         ) = _getValues(tAmount);
1809 
1810         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1811         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1812         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1813         _takeLiquidity(tLiquidity);
1814         _reflectFee(rFee, tFee);
1815         emit Transfer(sender, recipient, tTransferAmount);
1816     }
1817 
1818     function _transferFromExcluded(
1819         address sender,
1820         address recipient,
1821         uint256 tAmount
1822     ) private {
1823         (
1824             uint256 rAmount,
1825             uint256 rTransferAmount,
1826             uint256 rFee,
1827             uint256 tTransferAmount,
1828             uint256 tFee,
1829             uint256 tLiquidity
1830         ) = _getValues(tAmount);
1831 
1832         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1833         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1834         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1835         _takeLiquidity(tLiquidity);
1836         _reflectFee(rFee, tFee);
1837         emit Transfer(sender, recipient, tTransferAmount);
1838     }
1839 
1840     function _transferBothExcluded(
1841         address sender,
1842         address recipient,
1843         uint256 tAmount
1844     ) private {
1845         (
1846             uint256 rAmount,
1847             uint256 rTransferAmount,
1848             uint256 rFee,
1849             uint256 tTransferAmount,
1850             uint256 tFee,
1851             uint256 tLiquidity
1852         ) = _getValues(tAmount);
1853         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1854         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1855         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1856         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1857         _takeLiquidity(tLiquidity);
1858         _reflectFee(rFee, tFee);
1859         emit Transfer(sender, recipient, tTransferAmount);
1860     }
1861 
1862     function _reflectFee(uint256 rFee, uint256 tFee) private {
1863         _rTotal = _rTotal.sub(rFee);
1864         _tFeeTotal = _tFeeTotal.add(tFee);
1865     }
1866 
1867     function _getValues(uint256 tAmount)
1868         private
1869         view
1870         returns (
1871             uint256,
1872             uint256,
1873             uint256,
1874             uint256,
1875             uint256,
1876             uint256
1877         )
1878     {
1879         (
1880             uint256 tTransferAmount,
1881             uint256 tFee,
1882             uint256 tLiquidity
1883         ) = _getTValues(tAmount);
1884         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1885             tAmount,
1886             tFee,
1887             tLiquidity,
1888             _getRate()
1889         );
1890         return (
1891             rAmount,
1892             rTransferAmount,
1893             rFee,
1894             tTransferAmount,
1895             tFee,
1896             tLiquidity
1897         );
1898     }
1899 
1900     function _getTValues(uint256 tAmount)
1901         private
1902         view
1903         returns (
1904             uint256,
1905             uint256,
1906             uint256
1907         )
1908     {
1909         uint256 tFee = _calculateReflectFee(tAmount);
1910         uint256 tLiquidity = _calculateLiquidityFee(tAmount);
1911         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1912         return (tTransferAmount, tFee, tLiquidity);
1913     }
1914 
1915     function _getRValues(
1916         uint256 tAmount,
1917         uint256 tFee,
1918         uint256 tLiquidity,
1919         uint256 currentRate
1920     )
1921         private
1922         pure
1923         returns (
1924             uint256,
1925             uint256,
1926             uint256
1927         )
1928     {
1929         uint256 rAmount = tAmount.mul(currentRate);
1930         uint256 rFee = tFee.mul(currentRate);
1931         uint256 rLiquidity = tLiquidity.mul(currentRate);
1932         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1933         return (rAmount, rTransferAmount, rFee);
1934     }
1935 
1936     function _getRate() private view returns (uint256) {
1937         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1938         return rSupply.div(tSupply);
1939     }
1940 
1941     function _getCurrentSupply() private view returns (uint256, uint256) {
1942         uint256 rSupply = _rTotal;
1943         uint256 tSupply = _tTotal;
1944         for (uint256 i = 0; i < _excluded.length; i++) {
1945             if (
1946                 _rOwned[_excluded[i]] > rSupply ||
1947                 _tOwned[_excluded[i]] > tSupply
1948             ) return (_rTotal, _tTotal);
1949             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1950             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1951         }
1952         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1953         return (rSupply, tSupply);
1954     }
1955 
1956     function _takeLiquidity(uint256 tLiquidity) private {
1957         uint256 currentRate = _getRate();
1958         uint256 rLiquidity = tLiquidity.mul(currentRate);
1959         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1960         if (_isExcludedReward[address(this)])
1961             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1962     }
1963 
1964     function _calculateReflectFee(uint256 _amount)
1965         private
1966         view
1967         returns (uint256)
1968     {
1969         return
1970             _amount.mul(reflectionFee).mul(PRECISION).div(100).div(PRECISION);
1971     }
1972 
1973     function _liquidityFeeAggregate() private view returns (uint256) {
1974         return treasuryFee.add(liquidityFee);
1975     }
1976 
1977     function _calculateLiquidityFee(uint256 _amount)
1978         private
1979         view
1980         returns (uint256)
1981     {
1982         return
1983             _amount.mul(_liquidityFeeAggregate()).mul(PRECISION).div(100).div(
1984                 PRECISION
1985             );
1986     }
1987 
1988     function _removeAllFee() private {
1989         if (reflectionFee == 0 && treasuryFee == 0 && liquidityFee == 0) return;
1990 
1991         _previousReflectFee = reflectionFee;
1992         _previousTreasuryFee = treasuryFee;
1993         _previousLiquidityFee = liquidityFee;
1994 
1995         reflectionFee = 0;
1996         treasuryFee = 0;
1997         liquidityFee = 0;
1998     }
1999 
2000     function _restoreAllFee() private {
2001         reflectionFee = _previousReflectFee;
2002         treasuryFee = _previousTreasuryFee;
2003         liquidityFee = _previousLiquidityFee;
2004     }
2005 
2006     function getSellSlippage(address seller) external view returns (uint256) {
2007         uint256 feeAgg = treasuryFee.add(reflectionFee).add(liquidityFee);
2008 
2009         return isExcludedFromFee(seller) ? 0 : feeAgg;
2010     }
2011 
2012     function isuniswapPair(address _pair) external view returns (bool) {
2013         if (_pair == uniswapPair) return true;
2014         return _isUniswapPair[_pair];
2015     }
2016 
2017     function takeFeeOnTransferEnabled() external view returns (bool) {
2018         return _takeFeeOnTransferEnabled;
2019     }
2020 
2021     function takeFeeOnBuyEnabled() external view returns (bool) {
2022         return _takeFeeOnBuyEnabled;
2023     }
2024 
2025     function takeFeeOnSellEnabled() external view returns (bool) {
2026         return _takeFeeOnSellEnabled;
2027     }
2028 
2029     function isExcludedFromFee(address account) public view returns (bool) {
2030         return _isExcludedFee[account];
2031     }
2032 
2033     function isExcludedFromReward(address account)
2034         external
2035         view
2036         returns (bool)
2037     {
2038         return _isExcludedReward[account];
2039     }
2040 
2041     function excludeFromFee(address account) external onlyOwner {
2042         _isExcludedFee[account] = true;
2043     }
2044 
2045     function includeInFee(address account) external onlyOwner {
2046         _isExcludedFee[account] = false;
2047     }
2048 
2049     function setReflectionFeePercent(uint256 _newFee) external onlyOwner {
2050         require(_newFee <= 100, "fee cannot exceed 100%");
2051         reflectionFee = _newFee;
2052     }
2053 
2054     function setTreasuryFeePercent(uint256 _newFee) external onlyOwner {
2055         require(_newFee <= 100, "fee cannot exceed 100%");
2056         treasuryFee = _newFee;
2057     }
2058 
2059     function setLiquidityFeePercent(uint256 _newFee) external onlyOwner {
2060         require(_newFee <= 100, "fee cannot exceed 100%");
2061         liquidityFee = _newFee;
2062     }
2063 
2064     function setTreasuryAddress(address _treasuryWallet) external onlyOwner {
2065         treasuryWallet = payable(_treasuryWallet);
2066     }
2067 
2068     function setTakeFeeOnBuyEnabled(bool _enabled) external onlyOwner {
2069         _takeFeeOnBuyEnabled = _enabled;
2070     }
2071 
2072     function setTakeFeeOnSellEnabled(bool _enabled) external onlyOwner {
2073         _takeFeeOnSellEnabled = _enabled;
2074     }
2075 
2076     function setTakeFeeOnTransferEnabled(bool _enabled) external onlyOwner {
2077         _takeFeeOnTransferEnabled = _enabled;
2078     }
2079 
2080     function setMaxSellAmount(uint256 _maxSellAmount) external onlyOwner {
2081         maxSellAmount = _maxSellAmount;
2082     }
2083 
2084     function setuniswapRouter(address _uniswapRouterAddress)
2085         external
2086         onlyOwner
2087     {
2088         uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
2089     }
2090 
2091     function setBuybackReceiver(address _receiver) external onlyOwner {
2092         buybackReceiver = _receiver;
2093     }
2094 
2095     function adduniswapPair(address _pair) external onlyOwner {
2096         _isUniswapPair[_pair] = true;
2097     }
2098 
2099     function removeuniswapPair(address _pair) external onlyOwner {
2100         _isUniswapPair[_pair] = false;
2101     }
2102 
2103     function setCanTransfer(bool _canTransfer) external onlyOwner {
2104         _transferOpen = _canTransfer;
2105     }
2106 
2107     function isRemovedSniper(address account) external view returns (bool) {
2108         return _isSniper[account];
2109     }
2110 
2111     function removeSniper(address account) external onlyOwner {
2112         require(
2113             account != address(uniswapRouter),
2114             "We can not blacklist Uniswap"
2115         );
2116         require(!_isSniper[account], "Account is already blacklisted");
2117         _isSniper[account] = true;
2118         _confirmedSnipers.push(account);
2119     }
2120 
2121     function amnestySniper(address account) external onlyOwner {
2122         require(_isSniper[account], "Account is not blacklisted");
2123         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
2124             if (_confirmedSnipers[i] == account) {
2125                 _confirmedSnipers[i] = _confirmedSnipers[
2126                     _confirmedSnipers.length - 1
2127                 ];
2128                 _isSniper[account] = false;
2129                 _confirmedSnipers.pop();
2130                 break;
2131             }
2132         }
2133     }
2134 
2135     function setFeeRate(uint256 _rate) external onlyOwner {
2136         feeRate = _rate;
2137     }
2138 
2139     // to recieve ETH from uniswapRouter when swaping
2140     receive() external payable {}
2141 
2142     /// @notice management function
2143     function withdrawToken(address _token, address _recipient)
2144         external
2145         virtual
2146         onlyOwner
2147     {
2148         uint256 amount = IERC20(_token).balanceOf(address(this));
2149 
2150         _withdrawToken(_token, _recipient, amount);
2151         _afterWithdrawToken(_token, _recipient, amount);
2152     }
2153 
2154     /// @notice management function
2155     function withdrawSomeToken(
2156         address _token,
2157         address _recipient,
2158         uint256 _amount
2159     ) public virtual onlyOwner {
2160         _withdrawToken(_token, _recipient, _amount);
2161         _afterWithdrawToken(_token, _recipient, _amount);
2162     }
2163 
2164     ///@notice withdraw all ETH.
2165     function withdraw() external virtual onlyOwner {
2166         _withdraw(_msgSender(), address(this).balance);
2167     }
2168 
2169     ///@notice withdraw some ETH
2170     function withdrawSome(address _recipient, uint256 _amount)
2171         external
2172         virtual
2173         onlyOwner
2174     {
2175         _withdraw(_recipient, _amount);
2176     }
2177 }