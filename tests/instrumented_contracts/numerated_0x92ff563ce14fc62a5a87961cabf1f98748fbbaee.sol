1 // Sources flattened with hardhat v2.10.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `from` to `to` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) external returns (bool);
93 }
94 
95 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.3
96 
97 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 // CAUTION
102 // This version of SafeMath should only be used with Solidity 0.8 or later,
103 // because it relies on the compiler's built in overflow checks.
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations.
107  *
108  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
109  * now has built in overflow checking.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryAdd(uint256 a, uint256 b)
118         internal
119         pure
120         returns (bool, uint256)
121     {
122         unchecked {
123             uint256 c = a + b;
124             if (c < a) return (false, 0);
125             return (true, c);
126         }
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function trySub(uint256 a, uint256 b)
135         internal
136         pure
137         returns (bool, uint256)
138     {
139         unchecked {
140             if (b > a) return (false, 0);
141             return (true, a - b);
142         }
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMul(uint256 a, uint256 b)
151         internal
152         pure
153         returns (bool, uint256)
154     {
155         unchecked {
156             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157             // benefit is lost if 'b' is also tested.
158             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159             if (a == 0) return (true, 0);
160             uint256 c = a * b;
161             if (c / a != b) return (false, 0);
162             return (true, c);
163         }
164     }
165 
166     /**
167      * @dev Returns the division of two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryDiv(uint256 a, uint256 b)
172         internal
173         pure
174         returns (bool, uint256)
175     {
176         unchecked {
177             if (b == 0) return (false, 0);
178             return (true, a / b);
179         }
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryMod(uint256 a, uint256 b)
188         internal
189         pure
190         returns (bool, uint256)
191     {
192         unchecked {
193             if (b == 0) return (false, 0);
194             return (true, a % b);
195         }
196     }
197 
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a + b;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a - b;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a * b;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers, reverting on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator.
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a / b;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
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
288         unchecked {
289             require(b <= a, errorMessage);
290             return a - b;
291         }
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b > 0, errorMessage);
313             return a / b;
314         }
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * reverting with custom message when dividing by zero.
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {tryMod}.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a % b;
340         }
341     }
342 }
343 
344 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Provides information about the current execution context, including the
352  * sender of the transaction and its data. While these are generally available
353  * via msg.sender and msg.data, they should not be accessed in such a direct
354  * manner, since when dealing with meta-transactions the account sending and
355  * paying for execution may not be the actual sender (as far as an application
356  * is concerned).
357  *
358  * This contract is only required for intermediate, library-like contracts.
359  */
360 abstract contract Context {
361     function _msgSender() internal view virtual returns (address) {
362         return msg.sender;
363     }
364 
365     function _msgData() internal view virtual returns (bytes calldata) {
366         return msg.data;
367     }
368 }
369 
370 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
371 
372 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Contract module which provides a basic access control mechanism, where
378  * there is an account (an owner) that can be granted exclusive access to
379  * specific functions.
380  *
381  * By default, the owner account will be the one that deploys the contract. This
382  * can later be changed with {transferOwnership}.
383  *
384  * This module is used through inheritance. It will make available the modifier
385  * `onlyOwner`, which can be applied to your functions to restrict their use to
386  * the owner.
387  */
388 abstract contract Ownable is Context {
389     address private _owner;
390 
391     event OwnershipTransferred(
392         address indexed previousOwner,
393         address indexed newOwner
394     );
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor() {
400         _transferOwnership(_msgSender());
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         _checkOwner();
408         _;
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view virtual returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if the sender is not the owner.
420      */
421     function _checkOwner() internal view virtual {
422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         _transferOwnership(address(0));
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(
442             newOwner != address(0),
443             "Ownable: new owner is the zero address"
444         );
445         _transferOwnership(newOwner);
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Internal function without access restriction.
451      */
452     function _transferOwnership(address newOwner) internal virtual {
453         address oldOwner = _owner;
454         _owner = newOwner;
455         emit OwnershipTransferred(oldOwner, newOwner);
456     }
457 }
458 
459 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
460 
461 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
462 
463 pragma solidity ^0.8.1;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      *
486      * [IMPORTANT]
487      * ====
488      * You shouldn't rely on `isContract` to protect against flash loan attacks!
489      *
490      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
491      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
492      * constructor.
493      * ====
494      */
495     function isContract(address account) internal view returns (bool) {
496         // This method relies on extcodesize/address.code.length, which returns 0
497         // for contracts in construction, since the code is only stored at the end
498         // of the constructor execution.
499 
500         return account.code.length > 0;
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      */
519     function sendValue(address payable recipient, uint256 amount) internal {
520         require(
521             address(this).balance >= amount,
522             "Address: insufficient balance"
523         );
524 
525         (bool success, ) = recipient.call{value: amount}("");
526         require(
527             success,
528             "Address: unable to send value, recipient may have reverted"
529         );
530     }
531 
532     /**
533      * @dev Performs a Solidity function call using a low level `call`. A
534      * plain `call` is an unsafe replacement for a function call: use this
535      * function instead.
536      *
537      * If `target` reverts with a revert reason, it is bubbled up by this
538      * function (like regular Solidity function calls).
539      *
540      * Returns the raw returned data. To convert to the expected return value,
541      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
542      *
543      * Requirements:
544      *
545      * - `target` must be a contract.
546      * - calling `target` with `data` must not revert.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(address target, bytes memory data)
551         internal
552         returns (bytes memory)
553     {
554         return functionCall(target, data, "Address: low-level call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
559      * `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, 0, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but also transferring `value` wei to `target`.
574      *
575      * Requirements:
576      *
577      * - the calling contract must have an ETH balance of at least `value`.
578      * - the called Solidity function must be `payable`.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value
586     ) internal returns (bytes memory) {
587         return
588             functionCallWithValue(
589                 target,
590                 data,
591                 value,
592                 "Address: low-level call with value failed"
593             );
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(
609             address(this).balance >= value,
610             "Address: insufficient balance for call"
611         );
612         require(isContract(target), "Address: call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.call{value: value}(
615             data
616         );
617         return verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a static call.
623      *
624      * _Available since v3.3._
625      */
626     function functionStaticCall(address target, bytes memory data)
627         internal
628         view
629         returns (bytes memory)
630     {
631         return
632             functionStaticCall(
633                 target,
634                 data,
635                 "Address: low-level static call failed"
636             );
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
641      * but performing a static call.
642      *
643      * _Available since v3.3._
644      */
645     function functionStaticCall(
646         address target,
647         bytes memory data,
648         string memory errorMessage
649     ) internal view returns (bytes memory) {
650         require(isContract(target), "Address: static call to non-contract");
651 
652         (bool success, bytes memory returndata) = target.staticcall(data);
653         return verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(address target, bytes memory data)
663         internal
664         returns (bytes memory)
665     {
666         return
667             functionDelegateCall(
668                 target,
669                 data,
670                 "Address: low-level delegate call failed"
671             );
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
676      * but performing a delegate call.
677      *
678      * _Available since v3.4._
679      */
680     function functionDelegateCall(
681         address target,
682         bytes memory data,
683         string memory errorMessage
684     ) internal returns (bytes memory) {
685         require(isContract(target), "Address: delegate call to non-contract");
686 
687         (bool success, bytes memory returndata) = target.delegatecall(data);
688         return verifyCallResult(success, returndata, errorMessage);
689     }
690 
691     /**
692      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
693      * revert reason using the provided one.
694      *
695      * _Available since v4.3._
696      */
697     function verifyCallResult(
698         bool success,
699         bytes memory returndata,
700         string memory errorMessage
701     ) internal pure returns (bytes memory) {
702         if (success) {
703             return returndata;
704         } else {
705             // Look for revert reason and bubble it up if present
706             if (returndata.length > 0) {
707                 // The easiest way to bubble the revert reason is using memory via assembly
708                 /// @solidity memory-safe-assembly
709                 assembly {
710                     let returndata_size := mload(returndata)
711                     revert(add(32, returndata), returndata_size)
712                 }
713             } else {
714                 revert(errorMessage);
715             }
716         }
717     }
718 }
719 
720 // File contracts/IUniswapV2Factory.sol
721 
722 pragma solidity >=0.5.0;
723 
724 interface IUniswapV2Factory {
725     event PairCreated(
726         address indexed token0,
727         address indexed token1,
728         address pair,
729         uint
730     );
731 
732     function feeTo() external view returns (address);
733 
734     function feeToSetter() external view returns (address);
735 
736     function getPair(address tokenA, address tokenB)
737         external
738         view
739         returns (address pair);
740 
741     function allPairs(uint) external view returns (address pair);
742 
743     function allPairsLength() external view returns (uint);
744 
745     function createPair(address tokenA, address tokenB)
746         external
747         returns (address pair);
748 
749     function setFeeTo(address) external;
750 
751     function setFeeToSetter(address) external;
752 }
753 
754 // File contracts/IUniswapV2Pair.sol
755 
756 pragma solidity >=0.5.0;
757 
758 interface IUniswapV2Pair {
759     event Approval(address indexed owner, address indexed spender, uint value);
760     event Transfer(address indexed from, address indexed to, uint value);
761 
762     function name() external pure returns (string memory);
763 
764     function symbol() external pure returns (string memory);
765 
766     function decimals() external pure returns (uint8);
767 
768     function totalSupply() external view returns (uint);
769 
770     function balanceOf(address owner) external view returns (uint);
771 
772     function allowance(address owner, address spender)
773         external
774         view
775         returns (uint);
776 
777     function approve(address spender, uint value) external returns (bool);
778 
779     function transfer(address to, uint value) external returns (bool);
780 
781     function transferFrom(
782         address from,
783         address to,
784         uint value
785     ) external returns (bool);
786 
787     function DOMAIN_SEPARATOR() external view returns (bytes32);
788 
789     function PERMIT_TYPEHASH() external pure returns (bytes32);
790 
791     function nonces(address owner) external view returns (uint);
792 
793     function permit(
794         address owner,
795         address spender,
796         uint value,
797         uint deadline,
798         uint8 v,
799         bytes32 r,
800         bytes32 s
801     ) external;
802 
803     event Mint(address indexed sender, uint amount0, uint amount1);
804     event Burn(
805         address indexed sender,
806         uint amount0,
807         uint amount1,
808         address indexed to
809     );
810     event Swap(
811         address indexed sender,
812         uint amount0In,
813         uint amount1In,
814         uint amount0Out,
815         uint amount1Out,
816         address indexed to
817     );
818     event Sync(uint112 reserve0, uint112 reserve1);
819 
820     function MINIMUM_LIQUIDITY() external pure returns (uint);
821 
822     function factory() external view returns (address);
823 
824     function token0() external view returns (address);
825 
826     function token1() external view returns (address);
827 
828     function getReserves()
829         external
830         view
831         returns (
832             uint112 reserve0,
833             uint112 reserve1,
834             uint32 blockTimestampLast
835         );
836 
837     function price0CumulativeLast() external view returns (uint);
838 
839     function price1CumulativeLast() external view returns (uint);
840 
841     function kLast() external view returns (uint);
842 
843     function mint(address to) external returns (uint liquidity);
844 
845     function burn(address to) external returns (uint amount0, uint amount1);
846 
847     function swap(
848         uint amount0Out,
849         uint amount1Out,
850         address to,
851         bytes calldata data
852     ) external;
853 
854     function skim(address to) external;
855 
856     function sync() external;
857 
858     function initialize(address, address) external;
859 }
860 
861 // File contracts/IUniswapV2Router01.sol
862 
863 pragma solidity >=0.6.2;
864 
865 interface IUniswapV2Router01 {
866     function factory() external pure returns (address);
867 
868     function WETH() external pure returns (address);
869 
870     function addLiquidity(
871         address tokenA,
872         address tokenB,
873         uint amountADesired,
874         uint amountBDesired,
875         uint amountAMin,
876         uint amountBMin,
877         address to,
878         uint deadline
879     )
880         external
881         returns (
882             uint amountA,
883             uint amountB,
884             uint liquidity
885         );
886 
887     function addLiquidityETH(
888         address token,
889         uint amountTokenDesired,
890         uint amountTokenMin,
891         uint amountETHMin,
892         address to,
893         uint deadline
894     )
895         external
896         payable
897         returns (
898             uint amountToken,
899             uint amountETH,
900             uint liquidity
901         );
902 
903     function removeLiquidity(
904         address tokenA,
905         address tokenB,
906         uint liquidity,
907         uint amountAMin,
908         uint amountBMin,
909         address to,
910         uint deadline
911     ) external returns (uint amountA, uint amountB);
912 
913     function removeLiquidityETH(
914         address token,
915         uint liquidity,
916         uint amountTokenMin,
917         uint amountETHMin,
918         address to,
919         uint deadline
920     ) external returns (uint amountToken, uint amountETH);
921 
922     function removeLiquidityWithPermit(
923         address tokenA,
924         address tokenB,
925         uint liquidity,
926         uint amountAMin,
927         uint amountBMin,
928         address to,
929         uint deadline,
930         bool approveMax,
931         uint8 v,
932         bytes32 r,
933         bytes32 s
934     ) external returns (uint amountA, uint amountB);
935 
936     function removeLiquidityETHWithPermit(
937         address token,
938         uint liquidity,
939         uint amountTokenMin,
940         uint amountETHMin,
941         address to,
942         uint deadline,
943         bool approveMax,
944         uint8 v,
945         bytes32 r,
946         bytes32 s
947     ) external returns (uint amountToken, uint amountETH);
948 
949     function swapExactTokensForTokens(
950         uint amountIn,
951         uint amountOutMin,
952         address[] calldata path,
953         address to,
954         uint deadline
955     ) external returns (uint[] memory amounts);
956 
957     function swapTokensForExactTokens(
958         uint amountOut,
959         uint amountInMax,
960         address[] calldata path,
961         address to,
962         uint deadline
963     ) external returns (uint[] memory amounts);
964 
965     function swapExactETHForTokens(
966         uint amountOutMin,
967         address[] calldata path,
968         address to,
969         uint deadline
970     ) external payable returns (uint[] memory amounts);
971 
972     function swapTokensForExactETH(
973         uint amountOut,
974         uint amountInMax,
975         address[] calldata path,
976         address to,
977         uint deadline
978     ) external returns (uint[] memory amounts);
979 
980     function swapExactTokensForETH(
981         uint amountIn,
982         uint amountOutMin,
983         address[] calldata path,
984         address to,
985         uint deadline
986     ) external returns (uint[] memory amounts);
987 
988     function swapETHForExactTokens(
989         uint amountOut,
990         address[] calldata path,
991         address to,
992         uint deadline
993     ) external payable returns (uint[] memory amounts);
994 
995     function quote(
996         uint amountA,
997         uint reserveA,
998         uint reserveB
999     ) external pure returns (uint amountB);
1000 
1001     function getAmountOut(
1002         uint amountIn,
1003         uint reserveIn,
1004         uint reserveOut
1005     ) external pure returns (uint amountOut);
1006 
1007     function getAmountIn(
1008         uint amountOut,
1009         uint reserveIn,
1010         uint reserveOut
1011     ) external pure returns (uint amountIn);
1012 
1013     function getAmountsOut(uint amountIn, address[] calldata path)
1014         external
1015         view
1016         returns (uint[] memory amounts);
1017 
1018     function getAmountsIn(uint amountOut, address[] calldata path)
1019         external
1020         view
1021         returns (uint[] memory amounts);
1022 }
1023 
1024 // File contracts/IUniswapV2Router02.sol
1025 
1026 pragma solidity >=0.6.2;
1027 
1028 interface IUniswapV2Router02 is IUniswapV2Router01 {
1029     function removeLiquidityETHSupportingFeeOnTransferTokens(
1030         address token,
1031         uint liquidity,
1032         uint amountTokenMin,
1033         uint amountETHMin,
1034         address to,
1035         uint deadline
1036     ) external returns (uint amountETH);
1037 
1038     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1039         address token,
1040         uint liquidity,
1041         uint amountTokenMin,
1042         uint amountETHMin,
1043         address to,
1044         uint deadline,
1045         bool approveMax,
1046         uint8 v,
1047         bytes32 r,
1048         bytes32 s
1049     ) external returns (uint amountETH);
1050 
1051     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1052         uint amountIn,
1053         uint amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint deadline
1057     ) external;
1058 
1059     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1060         uint amountOutMin,
1061         address[] calldata path,
1062         address to,
1063         uint deadline
1064     ) external payable;
1065 
1066     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1067         uint amountIn,
1068         uint amountOutMin,
1069         address[] calldata path,
1070         address to,
1071         uint deadline
1072     ) external;
1073 }
1074 
1075 // File contracts/RAB.sol
1076 
1077 /**
1078 
1079 ÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔÇâÔÇâÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòùÔûæÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔûêÔòù
1080 ÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔÇâÔÇâÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòÉÔòØ
1081 ÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔòæÔÇâÔÇâÔûêÔûêÔûêÔûêÔûêÔûêÔòªÔòØÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔûêÔòùÔûæ
1082 ÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòæÔÇâÔÇâÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûæÔòÜÔòÉÔòÉÔòÉÔûêÔûêÔòù
1083 ÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔÇâÔÇâÔûêÔûêÔûêÔûêÔûêÔûêÔòªÔòØÔòÜÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØ
1084 ÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòØÔÇâÔÇâÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæ
1085 
1086                                         
1087                    ##                   
1088                   #####                 
1089                  #######                
1090                ##########   ##          
1091               ########### ###(          
1092             #####/ ###########          
1093            #####   ###########*         
1094            ####    #######  ####        
1095        #   ####     ######   ,###       
1096       ###  #####      #####    ###      
1097       ##### ####(        ####  /###     
1098        ###########         ###,###,     
1099         ###########    ##.  ######      
1100          ############   ### #####       
1101            ##########   ######          
1102                ####    ###             
1103 
1104 ­ƒöÑ Telegram: https://t.me/raburns
1105 
1106 ­ƒÉª Twitter: https://twitter.com/RABurnsToken
1107 
1108 ­ƒîÉ Website: https://raburns.xyz
1109 
1110 $RAB Features:
1111     - Buy tax : 6%
1112     - Sell tax : 6%
1113         - 2% Burn (tokens removed from circulation)
1114         - 2% Dev/Marketing (to ensure project longevity)
1115         - 1% Liquidity (Tokens not swapped, but injected directly into LP to inflate K-Score / ensure higher floors & less dumps)
1116         - 1% Reflection (Ra gives rewards to his loyals)
1117 
1118     - 1% of supply max Buy/Sell tax restriction in functions
1119     - Contract is renounced
1120     - LP is burned
1121  */
1122 
1123 pragma solidity 0.8.13;
1124 
1125 // import "hardhat/console.sol";
1126 
1127 contract RABurns is IERC20, Ownable {
1128     using SafeMath for uint256;
1129     using Address for address;
1130 
1131     mapping(address => uint256) private _rOwned;
1132     mapping(address => uint256) private _tOwned;
1133     mapping(address => mapping(address => uint256)) private _allowances;
1134 
1135     mapping(address => bool) private _isExcludedFromFee;
1136 
1137     mapping(address => bool) private _isExcludedFromRewards;
1138     address[] private _excluded;
1139 
1140     uint256 private constant MAX = ~uint256(0);
1141     uint256 public startSupply = 1e6 * 10**18;
1142     uint256 private _tTotal = 1e6 * 10**18;
1143     uint256 private _rTotal = (MAX - (MAX % _tTotal));
1144     uint256 private _tFeeTotal;
1145     address private constant deadAddress = address(0xdead);
1146 
1147     string private _name = "Ra Burns";
1148     string private _symbol = "RAB";
1149     uint8 private _decimals = 18;
1150 
1151     uint256 public _reflectionFee = 1;
1152     uint256 private _previousReflectionTaxFee = _reflectionFee;
1153 
1154     uint256 public _burnFee = 2;
1155     uint256 private _previousBurnFee = _burnFee;
1156 
1157     uint256 public _devFee = 2;
1158     uint256 private _previousDevFee = _devFee;
1159 
1160     uint256 public _liqFee = 1;
1161     uint256 private _previousLiqFee = _liqFee;
1162 
1163     IUniswapV2Router02 public immutable uniswapV2Router;
1164     address public immutable uniswapV2Pair;
1165 
1166     bool inSwap;
1167     bool public swapEnabled = true;
1168 
1169     uint256 public _maxTxAmount = (_tTotal * 1) / 100; //1%
1170     uint256 private numTokensSellToAddToLiquidityAndDev =
1171         (_tTotal * 10) / 100000; //0.01%
1172 
1173     address private dev1 = 0xd07b5a6819afA155E74c28c72fe30db926be6152;
1174     address private dev2 = 0x90C824A56E87376dD394b51bC0fdAF10F1bA81AB;
1175 
1176     struct TValues {
1177         uint256 tTransferAmount;
1178         uint256 tReflection;
1179         uint256 tDev;
1180         uint256 tBurn;
1181         uint256 tLiq;
1182     }
1183     struct RValues {
1184         uint256 rAmount;
1185         uint256 rTransferAmount;
1186         uint256 rReflection;
1187         uint256 rDev;
1188         uint256 rBurn;
1189         uint256 rLiq;
1190     }
1191 
1192     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1193     event SwapEnabledUpdated(bool enabled);
1194     event Swap(uint256 tokensSwapped, uint256 forDev, uint256 forLiq);
1195     event Burn(uint256 amount, uint256 newSupply);
1196     event Liquidity(uint256 amount);
1197 
1198     modifier lockTheSwap() {
1199         inSwap = true;
1200         _;
1201         inSwap = false;
1202     }
1203 
1204     constructor() {
1205         _rOwned[_msgSender()] = _rTotal;
1206 
1207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1208             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1209         );
1210         // Create a uniswap pair for this new token
1211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1212             .createPair(address(this), _uniswapV2Router.WETH());
1213 
1214         // set the rest of the contract variables
1215         uniswapV2Router = _uniswapV2Router;
1216 
1217         //exclude owner and this contract from fee
1218         _isExcludedFromFee[owner()] = true;
1219         _isExcludedFromFee[address(this)] = true;
1220         _isExcludedFromFee[address(0xdead)] = true;
1221         excludeFromReward(uniswapV2Pair);
1222         emit Transfer(address(0), _msgSender(), _tTotal);
1223     }
1224 
1225     function name() public view returns (string memory) {
1226         return _name;
1227     }
1228 
1229     function symbol() public view returns (string memory) {
1230         return _symbol;
1231     }
1232 
1233     function decimals() public view returns (uint8) {
1234         return _decimals;
1235     }
1236 
1237     function totalSupply() public view override returns (uint256) {
1238         return _tTotal;
1239     }
1240 
1241     function balanceOf(address account) public view override returns (uint256) {
1242         if (_isExcludedFromRewards[account]) return _tOwned[account];
1243         return tokenFromReflection(_rOwned[account]);
1244     }
1245 
1246     function transfer(address recipient, uint256 amount)
1247         public
1248         override
1249         returns (bool)
1250     {
1251         _transfer(_msgSender(), recipient, amount);
1252         return true;
1253     }
1254 
1255     function allowance(address owner, address spender)
1256         public
1257         view
1258         override
1259         returns (uint256)
1260     {
1261         return _allowances[owner][spender];
1262     }
1263 
1264     function approve(address spender, uint256 amount)
1265         public
1266         override
1267         returns (bool)
1268     {
1269         _approve(_msgSender(), spender, amount);
1270         return true;
1271     }
1272 
1273     function transferFrom(
1274         address sender,
1275         address recipient,
1276         uint256 amount
1277     ) public override returns (bool) {
1278         _transfer(sender, recipient, amount);
1279         _approve(
1280             sender,
1281             _msgSender(),
1282             _allowances[sender][_msgSender()].sub(
1283                 amount,
1284                 "ERC20: transfer amount exceeds allowance"
1285             )
1286         );
1287         return true;
1288     }
1289 
1290     function increaseAllowance(address spender, uint256 addedValue)
1291         public
1292         virtual
1293         returns (bool)
1294     {
1295         _approve(
1296             _msgSender(),
1297             spender,
1298             _allowances[_msgSender()][spender].add(addedValue)
1299         );
1300         return true;
1301     }
1302 
1303     function decreaseAllowance(address spender, uint256 subtractedValue)
1304         public
1305         virtual
1306         returns (bool)
1307     {
1308         _approve(
1309             _msgSender(),
1310             spender,
1311             _allowances[_msgSender()][spender].sub(
1312                 subtractedValue,
1313                 "ERC20: decreased allowance below zero"
1314             )
1315         );
1316         return true;
1317     }
1318 
1319     function isExcludedFromReward(address account) public view returns (bool) {
1320         return _isExcludedFromRewards[account];
1321     }
1322 
1323     function totalFees() public view returns (uint256) {
1324         return _tFeeTotal;
1325     }
1326 
1327     function deliver(uint256 tAmount) public {
1328         address sender = _msgSender();
1329         require(
1330             !_isExcludedFromRewards[sender],
1331             "Excluded addresses cannot call this function"
1332         );
1333         (, RValues memory rValues) = _getValues(tAmount);
1334         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
1335         _rTotal = _rTotal.sub(rValues.rAmount);
1336         _tFeeTotal = _tFeeTotal.add(tAmount);
1337     }
1338 
1339     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1340         public
1341         view
1342         returns (uint256)
1343     {
1344         require(tAmount <= _tTotal, "Amount must be less than supply");
1345         if (!deductTransferFee) {
1346             (, RValues memory rValues) = _getValues(tAmount);
1347             return rValues.rAmount;
1348         } else {
1349             (, RValues memory rValues) = _getValues(tAmount);
1350             return rValues.rTransferAmount;
1351         }
1352     }
1353 
1354     function tokenFromReflection(uint256 rAmount)
1355         public
1356         view
1357         returns (uint256)
1358     {
1359         require(
1360             rAmount <= _rTotal,
1361             "Amount must be less than total reflections"
1362         );
1363         uint256 currentRate = _getRate();
1364         return rAmount.div(currentRate);
1365     }
1366 
1367     function excludeFromReward(address account) public onlyOwner {
1368         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1369         require(
1370             !_isExcludedFromRewards[account],
1371             "Account is already excluded"
1372         );
1373         if (_rOwned[account] > 0) {
1374             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1375         }
1376         _isExcludedFromRewards[account] = true;
1377         _excluded.push(account);
1378     }
1379 
1380     function includeInReward(address account) external onlyOwner {
1381         require(_isExcludedFromRewards[account], "Account is already excluded");
1382         for (uint256 i = 0; i < _excluded.length; i++) {
1383             if (_excluded[i] == account) {
1384                 _excluded[i] = _excluded[_excluded.length - 1];
1385                 _tOwned[account] = 0;
1386                 _isExcludedFromRewards[account] = false;
1387                 _excluded.pop();
1388                 break;
1389             }
1390         }
1391     }
1392 
1393     function excludeFromFee(address account) public onlyOwner {
1394         _isExcludedFromFee[account] = true;
1395     }
1396 
1397     function includeInFee(address account) public onlyOwner {
1398         _isExcludedFromFee[account] = false;
1399     }
1400 
1401     function setBurnFeePercent(uint256 burnFee) external onlyOwner {
1402         _burnFee = burnFee;
1403     }
1404 
1405     function setDevFeePercent(uint256 devFee) external onlyOwner {
1406         _devFee = devFee;
1407     }
1408 
1409     function setReflectionFeePercent(uint256 reflectionFee) external onlyOwner {
1410         _reflectionFee = reflectionFee;
1411     }
1412 
1413     function setLiquidityFeePercent(uint256 liqFee) external onlyOwner {
1414         _liqFee = liqFee;
1415     }
1416 
1417     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1418         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1419     }
1420 
1421     function setSwapPercent(uint256 maxSwapPercent) external onlyOwner {
1422         numTokensSellToAddToLiquidityAndDev = _tTotal.mul(maxSwapPercent).div(
1423             10**5
1424         );
1425     }
1426 
1427     function setSwapEnabled(bool _enabled) public onlyOwner {
1428         swapEnabled = _enabled;
1429         emit SwapEnabledUpdated(_enabled);
1430     }
1431 
1432     function setDev1Address(address _dev1) external onlyOwner {
1433         dev1 = _dev1;
1434     }
1435 
1436     function setDev2Address(address _dev2) external onlyOwner {
1437         dev2 = _dev2;
1438     }
1439 
1440     //to recieve ETH from uniswapV2Router when swaping
1441     receive() external payable {}
1442 
1443     function _reflectFee(uint256 rFee, uint256 tFee) private {
1444         _rTotal = _rTotal.sub(rFee);
1445         _tFeeTotal = _tFeeTotal.add(tFee);
1446     }
1447 
1448     function _getValues(uint256 tAmount)
1449         private
1450         view
1451         returns (TValues memory tValues, RValues memory rValues)
1452     {
1453         tValues = _getTValues(tAmount);
1454         rValues = _getRValues(tAmount, tValues, _getRate());
1455     }
1456 
1457     function _getTValues(uint256 tAmount)
1458         private
1459         view
1460         returns (TValues memory tValues)
1461     {
1462         tValues.tReflection = calculateReflectionFee(tAmount);
1463         tValues.tDev = calculateDevFee(tAmount);
1464         tValues.tBurn = calculateBurnFee(tAmount);
1465         tValues.tLiq = calculateLiqFee(tAmount);
1466         tValues.tTransferAmount = tAmount
1467             .sub(tValues.tReflection)
1468             .sub(tValues.tDev)
1469             .sub(tValues.tBurn)
1470             .sub(tValues.tLiq);
1471     }
1472 
1473     function _getRValues(
1474         uint256 tAmount,
1475         TValues memory tValues,
1476         uint256 currentRate
1477     ) private pure returns (RValues memory rValues) {
1478         rValues.rAmount = tAmount.mul(currentRate);
1479         rValues.rReflection = tValues.tReflection.mul(currentRate);
1480         rValues.rDev = tValues.tDev.mul(currentRate);
1481         rValues.rBurn = tValues.tBurn.mul(currentRate);
1482         rValues.rLiq = tValues.tLiq.mul(currentRate);
1483         rValues.rTransferAmount = rValues
1484             .rAmount
1485             .sub(rValues.rReflection)
1486             .sub(rValues.rDev)
1487             .sub(rValues.rBurn)
1488             .sub(rValues.rLiq);
1489     }
1490 
1491     function _getRate() private view returns (uint256) {
1492         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1493         return rSupply.div(tSupply);
1494     }
1495 
1496     function _getCurrentSupply() private view returns (uint256, uint256) {
1497         uint256 rSupply = _rTotal;
1498         uint256 tSupply = _tTotal;
1499         for (uint256 i = 0; i < _excluded.length; i++) {
1500             if (
1501                 _rOwned[_excluded[i]] > rSupply ||
1502                 _tOwned[_excluded[i]] > tSupply
1503             ) return (_rTotal, _tTotal);
1504             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1505             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1506         }
1507         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1508         return (rSupply, tSupply);
1509     }
1510 
1511     function _takeLiquidityAndDev(uint256 tLiquidity, uint256 tDev) private {
1512         uint256 currentRate = _getRate();
1513         uint256 rLiquidity = tLiquidity.mul(currentRate);
1514         uint256 rDev = tDev.mul(currentRate);
1515         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity).add(
1516             rDev
1517         );
1518         if (_isExcludedFromRewards[address(this)])
1519             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity).add(
1520                 tDev
1521             );
1522     }
1523 
1524     function calculateReflectionFee(uint256 _amount)
1525         private
1526         view
1527         returns (uint256)
1528     {
1529         return _amount.mul(_reflectionFee).div(10**2);
1530     }
1531 
1532     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1533         return _amount.mul(_devFee).div(10**2);
1534     }
1535 
1536     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1537         return _amount.mul(_burnFee).div(10**2);
1538     }
1539 
1540     function calculateLiqFee(uint256 _amount) private view returns (uint256) {
1541         return _amount.mul(_liqFee).div(10**2);
1542     }
1543 
1544     function removeAllFee() private {
1545         if (_reflectionFee == 0 && _devFee == 0 && _burnFee == 0) return;
1546 
1547         _previousReflectionTaxFee = _reflectionFee;
1548         _previousBurnFee = _burnFee;
1549         _previousDevFee = _devFee;
1550         _previousLiqFee = _liqFee;
1551 
1552         _devFee = 0;
1553         _burnFee = 0;
1554         _reflectionFee = 0;
1555         _liqFee = 0;
1556     }
1557 
1558     function restoreAllFee() private {
1559         _devFee = _previousDevFee;
1560         _burnFee = _previousBurnFee;
1561         _reflectionFee = _previousReflectionTaxFee;
1562         _liqFee = _previousLiqFee;
1563     }
1564 
1565     function isExcludedFromFee(address account) public view returns (bool) {
1566         return _isExcludedFromFee[account];
1567     }
1568 
1569     function _approve(
1570         address owner,
1571         address spender,
1572         uint256 amount
1573     ) private {
1574         require(owner != address(0), "ERC20: approve from the zero address");
1575         require(spender != address(0), "ERC20: approve to the zero address");
1576 
1577         _allowances[owner][spender] = amount;
1578         emit Approval(owner, spender, amount);
1579     }
1580 
1581     function _transfer(
1582         address from,
1583         address to,
1584         uint256 amount
1585     ) private {
1586         require(from != address(0), "ERC20: transfer from the zero address");
1587         require(to != address(0), "ERC20: transfer to the zero address");
1588         require(amount > 0, "Transfer amount must be greater than zero");
1589         if (from != owner() && to != owner())
1590             require(
1591                 amount <= _maxTxAmount,
1592                 "Transfer amount exceeds the maxTxAmount."
1593             );
1594         // is the token balance of this contract address over the min number of
1595         // tokens that we need to initiate a swap + liquidity lock?
1596         // also, don't get caught in a circular liquidity event.
1597         // also, don't swap & liquify if sender is uniswap pair.
1598         uint256 contractTokenBalance = balanceOf(address(this));
1599 
1600         if (contractTokenBalance >= _maxTxAmount) {
1601             contractTokenBalance = _maxTxAmount;
1602         }
1603         bool overMinTokenBalance = contractTokenBalance >=
1604             numTokensSellToAddToLiquidityAndDev;
1605         if (
1606             overMinTokenBalance &&
1607             !inSwap &&
1608             from != uniswapV2Pair &&
1609             swapEnabled
1610         ) {
1611             contractTokenBalance = numTokensSellToAddToLiquidityAndDev;
1612             //add liquidity and dev fees
1613             swap(contractTokenBalance);
1614         }
1615 
1616         //indicates if fee should be deducted from transfer
1617         bool takeFee = true;
1618 
1619         //if any account belongs to _isExcludedFromFee account then remove the fee
1620         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1621             takeFee = false;
1622         }
1623 
1624         //transfer amount, it will take tax, burn, liquidity fee
1625         _tokenTransfer(from, to, amount, takeFee);
1626     }
1627 
1628     function _burn(uint256 tBurn, uint256 rBurn) internal {
1629         _rOwned[deadAddress] += rBurn;
1630         emit Burn(tBurn, _tTotal);
1631     }
1632 
1633     function _addLiquidity(uint256 _tLiq) internal {
1634         uint256 currentRate = _getRate();
1635         uint256 _rLiq = _tLiq.mul(currentRate);
1636         _rOwned[uniswapV2Pair] += _rLiq;
1637         _tOwned[uniswapV2Pair] += _tLiq;
1638         emit Liquidity(_tLiq);
1639     }
1640 
1641     function swap(uint256 contractTokenBalance) private lockTheSwap {
1642         // split the contract balance
1643 
1644         uint forDev = contractTokenBalance.mul(_devFee).div(_devFee + _liqFee);
1645         uint256 forLiq = contractTokenBalance.sub(forDev);
1646         // capture the contract's current ETH balance.
1647         // this is so that we can capture exactly the amount of ETH that the
1648         // swap creates, and not make the liquidity event include any ETH that
1649         // has been manually sent to the contract
1650         uint256 initialBalance = address(this).balance;
1651 
1652         if (forDev > 0) {
1653             swapTokensForEth(forDev);
1654             uint256 ethForDevs = address(this).balance.sub(initialBalance);
1655             uint256 ethForDev1 = ethForDevs.div(2);
1656             uint256 ethForDev2 = ethForDevs.sub(ethForDev1);
1657             (bool sent1, ) = payable(dev1).call{value: ethForDev1}("");
1658             (bool sent2, ) = payable(dev2).call{value: ethForDev2}("");
1659             require(sent1);
1660             require(sent2);
1661         }
1662 
1663         // add liquidity to uniswap
1664         if (forLiq > 0) {
1665             _addLiquidity(forLiq);
1666         }
1667         // emit Swap(half, newBalance, otherHalf);
1668     }
1669 
1670     function swapTokensForEth(uint256 tokenAmount) private {
1671         // generate the uniswap pair path of token -> weth
1672         address[] memory path = new address[](2);
1673         path[0] = address(this);
1674         path[1] = uniswapV2Router.WETH();
1675 
1676         _approve(address(this), address(uniswapV2Router), tokenAmount);
1677 
1678         // make the swap
1679         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1680             tokenAmount,
1681             0, // accept any amount of ETH
1682             path,
1683             address(this),
1684             block.timestamp
1685         );
1686     }
1687 
1688     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1689         // approve token transfer to cover all possible scenarios
1690         _approve(address(this), address(uniswapV2Router), tokenAmount);
1691 
1692         // add the liquidity
1693         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1694             address(this),
1695             tokenAmount,
1696             0, // slippage is unavoidable
1697             0, // slippage is unavoidable
1698             owner(),
1699             block.timestamp
1700         );
1701     }
1702 
1703     //this method is responsible for taking all fee, if takeFee is true
1704     function _tokenTransfer(
1705         address sender,
1706         address recipient,
1707         uint256 amount,
1708         bool takeFee
1709     ) private {
1710         if (!takeFee) removeAllFee();
1711 
1712         if (
1713             _isExcludedFromRewards[sender] && !_isExcludedFromRewards[recipient]
1714         ) {
1715             _transferFromExcluded(sender, recipient, amount);
1716         } else if (
1717             !_isExcludedFromRewards[sender] && _isExcludedFromRewards[recipient]
1718         ) {
1719             _transferToExcluded(sender, recipient, amount);
1720         } else if (
1721             !_isExcludedFromRewards[sender] &&
1722             !_isExcludedFromRewards[recipient]
1723         ) {
1724             _transferStandard(sender, recipient, amount);
1725         } else if (
1726             _isExcludedFromRewards[sender] && _isExcludedFromRewards[recipient]
1727         ) {
1728             _transferBothExcluded(sender, recipient, amount);
1729         } else {
1730             _transferStandard(sender, recipient, amount);
1731         }
1732 
1733         if (!takeFee) restoreAllFee();
1734     }
1735 
1736     function _transferFromExcluded(
1737         address sender,
1738         address recipient,
1739         uint256 tAmount
1740     ) private {
1741         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
1742         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1743         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
1744         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);
1745         _takeLiquidityAndDev(tValues.tLiq, tValues.tDev);
1746         _burn(tValues.tBurn, rValues.rBurn);
1747         _reflectFee(rValues.rReflection, tValues.tReflection);
1748         emit Transfer(sender, recipient, tValues.tTransferAmount);
1749     }
1750 
1751     function _transferToExcluded(
1752         address sender,
1753         address recipient,
1754         uint256 tAmount
1755     ) private {
1756         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
1757         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
1758         _tOwned[recipient] = _tOwned[recipient].add(tValues.tTransferAmount);
1759         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);
1760         _takeLiquidityAndDev(tValues.tLiq, tValues.tDev);
1761         _burn(tValues.tBurn, rValues.rBurn);
1762         _reflectFee(rValues.rReflection, tValues.tReflection);
1763         emit Transfer(sender, recipient, tValues.tTransferAmount);
1764     }
1765 
1766     function _transferStandard(
1767         address sender,
1768         address recipient,
1769         uint256 tAmount
1770     ) private {
1771         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
1772         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
1773         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);
1774         _takeLiquidityAndDev(tValues.tLiq, tValues.tDev);
1775         _burn(tValues.tBurn, rValues.rBurn);
1776         _reflectFee(rValues.rReflection, tValues.tReflection);
1777         emit Transfer(sender, recipient, tValues.tTransferAmount);
1778     }
1779 
1780     function _transferBothExcluded(
1781         address sender,
1782         address recipient,
1783         uint256 tAmount
1784     ) private {
1785         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
1786         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1787         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
1788         _tOwned[recipient] = _tOwned[recipient].add(tValues.tTransferAmount);
1789         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);
1790         _takeLiquidityAndDev(tValues.tLiq, tValues.tDev);
1791         _burn(tValues.tBurn, rValues.rBurn);
1792         _reflectFee(rValues.rReflection, tValues.tReflection);
1793         emit Transfer(sender, recipient, tValues.tTransferAmount);
1794     }
1795 }