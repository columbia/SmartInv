1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity 0.8.7;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and making it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 
165 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
166 pragma solidity ^0.8.0;
167 
168 // CAUTION
169 // This version of SafeMath should only be used with Solidity 0.8 or later,
170 // because it relies on the compiler's built in overflow checks.
171 
172 /**
173  * @dev Wrappers over Solidity's arithmetic operations.
174  *
175  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
176  * now has built in overflow checking.
177  */
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, with an overflow flag.
181      *
182      * _Available since v3.4._
183      */
184     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
185         unchecked {
186             uint256 c = a + b;
187             if (c < a) return (false, 0);
188             return (true, c);
189         }
190     }
191 
192     /**
193      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             if (b > a) return (false, 0);
200             return (true, a - b);
201         }
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212             // benefit is lost if 'b' is also tested.
213             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214             if (a == 0) return (true, 0);
215             uint256 c = a * b;
216             if (c / a != b) return (false, 0);
217             return (true, c);
218         }
219     }
220 
221     /**
222      * @dev Returns the division of two unsigned integers, with a division by zero flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b == 0) return (false, 0);
229             return (true, a / b);
230         }
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             if (b == 0) return (false, 0);
241             return (true, a % b);
242         }
243     }
244 
245     /**
246      * @dev Returns the addition of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `+` operator.
250      *
251      * Requirements:
252      *
253      * - Addition cannot overflow.
254      */
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a + b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the multiplication of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `*` operator.
278      *
279      * Requirements:
280      *
281      * - Multiplication cannot overflow.
282      */
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a * b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator.
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a / b;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * reverting when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a % b;
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {trySub}.
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b <= a, errorMessage);
337             return a - b;
338         }
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a / b;
361         }
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * reverting with custom message when dividing by zero.
367      *
368      * CAUTION: This function is deprecated because it requires allocating memory for the error
369      * message unnecessarily. For custom revert reasons use {tryMod}.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         unchecked {
385             require(b > 0, errorMessage);
386             return a % b;
387         }
388     }
389 }
390 
391 pragma solidity ^0.8.1;
392 
393 /**
394  * @dev Collection of functions related to the address type
395  */
396 library Address {
397     /**
398      * @dev Returns true if `account` is a contract.
399      *
400      * [IMPORTANT]
401      * ====
402      * It is unsafe to assume that an address for which this function returns
403      * false is an externally-owned account (EOA) and not a contract.
404      *
405      * Among others, `isContract` will return false for the following
406      * types of addresses:
407      *
408      *  - an externally-owned account
409      *  - a contract in construction
410      *  - an address where a contract will be created
411      *  - an address where a contract lived, but was destroyed
412      * ====
413      *
414      * [IMPORTANT]
415      * ====
416      * You shouldn't rely on `isContract` to protect against flash loan attacks!
417      *
418      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
419      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
420      * constructor.
421      * ====
422      */
423     function isContract(address account) internal view returns (bool) {
424         // This method relies on extcodesize/address.code.length, which returns 0
425         // for contracts in construction, since the code is only stored at the end
426         // of the constructor execution.
427 
428         return account.code.length > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(success, "Address: unable to send value, recipient may have reverted");
452     }
453 
454     /**
455      * @dev Performs a Solidity function call using a low level `call`. A
456      * plain `call` is an unsafe replacement for a function call: use this
457      * function instead.
458      *
459      * If `target` reverts with a revert reason, it is bubbled up by this
460      * function (like regular Solidity function calls).
461      *
462      * Returns the raw returned data. To convert to the expected return value,
463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
464      *
465      * Requirements:
466      *
467      * - `target` must be a contract.
468      * - calling `target` with `data` must not revert.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionCall(target, data, "Address: low-level call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
478      * `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         require(isContract(target), "Address: call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.delegatecall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584      * revert reason using the provided one.
585      *
586      * _Available since v4.3._
587      */
588     function verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) internal pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 
612 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Interface of the ERC20 standard as defined in the EIP.
620  */
621 interface IERC20 {
622     /**
623      * @dev Returns the amount of tokens in existence.
624      */
625     function totalSupply() external view returns (uint256);
626 
627     /**
628      * @dev Returns the amount of tokens owned by `account`.
629      */
630     function balanceOf(address account) external view returns (uint256);
631 
632     /**
633      * @dev Moves `amount` tokens from the caller's account to `to`.
634      *
635      * Returns a boolean value indicating whether the operation succeeded.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transfer(address to, uint256 amount) external returns (bool);
640 
641     /**
642      * @dev Returns the remaining number of tokens that `spender` will be
643      * allowed to spend on behalf of `owner` through {transferFrom}. This is
644      * zero by default.
645      *
646      * This value changes when {approve} or {transferFrom} are called.
647      */
648     function allowance(address owner, address spender) external view returns (uint256);
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
652      *
653      * Returns a boolean value indicating whether the operation succeeded.
654      *
655      * IMPORTANT: Beware that changing an allowance with this method brings the risk
656      * that someone may use both the old and the new allowance by unfortunate
657      * transaction ordering. One possible solution to mitigate this race
658      * condition is to first reduce the spender's allowance to 0 and set the
659      * desired value afterwards:
660      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
661      *
662      * Emits an {Approval} event.
663      */
664     function approve(address spender, uint256 amount) external returns (bool);
665 
666     /**
667      * @dev Moves `amount` tokens from `from` to `to` using the
668      * allowance mechanism. `amount` is then deducted from the caller's
669      * allowance.
670      *
671      * Returns a boolean value indicating whether the operation succeeded.
672      *
673      * Emits a {Transfer} event.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 amount
679     ) external returns (bool);
680 
681     /**
682      * @dev Emitted when `value` tokens are moved from one account (`from`) to
683      * another (`to`).
684      *
685      * Note that `value` may be zero.
686      */
687     event Transfer(address indexed from, address indexed to, uint256 value);
688 
689     /**
690      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
691      * a call to {approve}. `value` is the new allowance.
692      */
693     event Approval(address indexed owner, address indexed spender, uint256 value);
694 }
695 
696 
697 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Interface for the optional metadata functions from the ERC20 standard.
705  *
706  * _Available since v4.1._
707  */
708 interface IERC20Metadata is IERC20 {
709     /**
710      * @dev Returns the name of the token.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the symbol of the token.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the decimals places of the token.
721      */
722     function decimals() external view returns (uint8);
723 }
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev Implementation of the {IERC20} interface.
729  *
730  * This implementation is agnostic to the way tokens are created. This means
731  * that a supply mechanism has to be added in a derived contract using {_mint}.
732  * For a generic mechanism see {ERC20PresetMinterPauser}.
733  *
734  * TIP: For a detailed writeup see our guide
735  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
736  * to implement supply mechanisms].
737  *
738  * We have followed general OpenZeppelin Contracts guidelines: functions revert
739  * instead returning `false` on failure. This behavior is nonetheless
740  * conventional and does not conflict with the expectations of ERC20
741  * applications.
742  *
743  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
744  * This allows applications to reconstruct the allowance for all accounts just
745  * by listening to said events. Other implementations of the EIP may not emit
746  * these events, as it isn't required by the specification.
747  *
748  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
749  * functions have been added to mitigate the well-known issues around setting
750  * allowances. See {IERC20-approve}.
751  */
752 contract ERC20 is Context, IERC20, IERC20Metadata {
753     mapping(address => uint256) private _balances;
754 
755     mapping(address => mapping(address => uint256)) private _allowances;
756 
757     uint256 private _totalSupply;
758 
759     string private _name;
760     string private _symbol;
761 
762     /**
763      * @dev Sets the values for {name} and {symbol}.
764      *
765      * The default value of {decimals} is 18. To select a different value for
766      * {decimals} you should overload it.
767      *
768      * All two of these values are immutable: they can only be set once during
769      * construction.
770      */
771     constructor(string memory name_, string memory symbol_) {
772         _name = name_;
773         _symbol = symbol_;
774     }
775 
776     /**
777      * @dev Returns the name of the token.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev Returns the symbol of the token, usually a shorter version of the
785      * name.
786      */
787     function symbol() public view virtual override returns (string memory) {
788         return _symbol;
789     }
790 
791     /**
792      * @dev Returns the number of decimals used to get its user representation.
793      * For example, if `decimals` equals `2`, a balance of `505` tokens should
794      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
795      *
796      * Tokens usually opt for a value of 18, imitating the relationship between
797      * Ether and Wei. This is the value {ERC20} uses, unless this function is
798      * overridden;
799      *
800      * NOTE: This information is only used for _display_ purposes: it in
801      * no way affects any of the arithmetic of the contract, including
802      * {IERC20-balanceOf} and {IERC20-transfer}.
803      */
804     function decimals() public view virtual override returns (uint8) {
805         return 18;
806     }
807 
808     /**
809      * @dev See {IERC20-totalSupply}.
810      */
811     function totalSupply() public view virtual override returns (uint256) {
812         return _totalSupply;
813     }
814 
815     /**
816      * @dev See {IERC20-balanceOf}.
817      */
818     function balanceOf(address account) public view virtual override returns (uint256) {
819         return _balances[account];
820     }
821 
822     /**
823      * @dev See {IERC20-transfer}.
824      *
825      * Requirements:
826      *
827      * - `to` cannot be the zero address.
828      * - the caller must have a balance of at least `amount`.
829      */
830     function transfer(address to, uint256 amount) public virtual override returns (bool) {
831         address owner = _msgSender();
832         _transfer(owner, to, amount);
833         return true;
834     }
835 
836     /**
837      * @dev See {IERC20-allowance}.
838      */
839     function allowance(address owner, address spender) public view virtual override returns (uint256) {
840         return _allowances[owner][spender];
841     }
842 
843     /**
844      * @dev See {IERC20-approve}.
845      *
846      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
847      * `transferFrom`. This is semantically equivalent to an infinite approval.
848      *
849      * Requirements:
850      *
851      * - `spender` cannot be the zero address.
852      */
853     function approve(address spender, uint256 amount) public virtual override returns (bool) {
854         address owner = _msgSender();
855         _approve(owner, spender, amount);
856         return true;
857     }
858 
859     /**
860      * @dev See {IERC20-transferFrom}.
861      *
862      * Emits an {Approval} event indicating the updated allowance. This is not
863      * required by the EIP. See the note at the beginning of {ERC20}.
864      *
865      * NOTE: Does not update the allowance if the current allowance
866      * is the maximum `uint256`.
867      *
868      * Requirements:
869      *
870      * - `from` and `to` cannot be the zero address.
871      * - `from` must have a balance of at least `amount`.
872      * - the caller must have allowance for ``from``'s tokens of at least
873      * `amount`.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 amount
879     ) public virtual override returns (bool) {
880         address spender = _msgSender();
881         _spendAllowance(from, spender, amount);
882         _transfer(from, to, amount);
883         return true;
884     }
885 
886     /**
887      * @dev Atomically increases the allowance granted to `spender` by the caller.
888      *
889      * This is an alternative to {approve} that can be used as a mitigation for
890      * problems described in {IERC20-approve}.
891      *
892      * Emits an {Approval} event indicating the updated allowance.
893      *
894      * Requirements:
895      *
896      * - `spender` cannot be the zero address.
897      */
898     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
899         address owner = _msgSender();
900         _approve(owner, spender, _allowances[owner][spender] + addedValue);
901         return true;
902     }
903 
904     /**
905      * @dev Atomically decreases the allowance granted to `spender` by the caller.
906      *
907      * This is an alternative to {approve} that can be used as a mitigation for
908      * problems described in {IERC20-approve}.
909      *
910      * Emits an {Approval} event indicating the updated allowance.
911      *
912      * Requirements:
913      *
914      * - `spender` cannot be the zero address.
915      * - `spender` must have allowance for the caller of at least
916      * `subtractedValue`.
917      */
918     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
919         address owner = _msgSender();
920         uint256 currentAllowance = _allowances[owner][spender];
921         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
922         unchecked {
923             _approve(owner, spender, currentAllowance - subtractedValue);
924         }
925 
926         return true;
927     }
928 
929     /**
930      * @dev Moves `amount` of tokens from `sender` to `recipient`.
931      *
932      * This internal function is equivalent to {transfer}, and can be used to
933      * e.g. implement automatic token fees, slashing mechanisms, etc.
934      *
935      * Emits a {Transfer} event.
936      *
937      * Requirements:
938      *
939      * - `from` cannot be the zero address.
940      * - `to` cannot be the zero address.
941      * - `from` must have a balance of at least `amount`.
942      */
943     function _transfer(
944         address from,
945         address to,
946         uint256 amount
947     ) internal virtual {
948         require(from != address(0), "ERC20: transfer from the zero address");
949         require(to != address(0), "ERC20: transfer to the zero address");
950 
951         _beforeTokenTransfer(from, to, amount);
952 
953         uint256 fromBalance = _balances[from];
954         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
955         unchecked {
956             _balances[from] = fromBalance - amount;
957         }
958         _balances[to] += amount;
959 
960         emit Transfer(from, to, amount);
961 
962         _afterTokenTransfer(from, to, amount);
963     }
964 
965     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
966      * the total supply.
967      *
968      * Emits a {Transfer} event with `from` set to the zero address.
969      *
970      * Requirements:
971      *
972      * - `account` cannot be the zero address.
973      */
974     function _mint(address account, uint256 amount) internal virtual {
975         require(account != address(0), "ERC20: mint to the zero address");
976 
977         _beforeTokenTransfer(address(0), account, amount);
978 
979         _totalSupply += amount;
980         _balances[account] += amount;
981         emit Transfer(address(0), account, amount);
982 
983         _afterTokenTransfer(address(0), account, amount);
984     }
985 
986     /**
987      * @dev Destroys `amount` tokens from `account`, reducing the
988      * total supply.
989      *
990      * Emits a {Transfer} event with `to` set to the zero address.
991      *
992      * Requirements:
993      *
994      * - `account` cannot be the zero address.
995      * - `account` must have at least `amount` tokens.
996      */
997     function _burn(address account, uint256 amount) internal virtual {
998         require(account != address(0), "ERC20: burn from the zero address");
999 
1000         _beforeTokenTransfer(account, address(0), amount);
1001 
1002         uint256 accountBalance = _balances[account];
1003         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1004         unchecked {
1005             _balances[account] = accountBalance - amount;
1006         }
1007         _totalSupply -= amount;
1008 
1009         emit Transfer(account, address(0), amount);
1010 
1011         _afterTokenTransfer(account, address(0), amount);
1012     }
1013 
1014     /**
1015      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1016      *
1017      * This internal function is equivalent to `approve`, and can be used to
1018      * e.g. set automatic allowances for certain subsystems, etc.
1019      *
1020      * Emits an {Approval} event.
1021      *
1022      * Requirements:
1023      *
1024      * - `owner` cannot be the zero address.
1025      * - `spender` cannot be the zero address.
1026      */
1027     function _approve(
1028         address owner,
1029         address spender,
1030         uint256 amount
1031     ) internal virtual {
1032         require(owner != address(0), "ERC20: approve from the zero address");
1033         require(spender != address(0), "ERC20: approve to the zero address");
1034 
1035         _allowances[owner][spender] = amount;
1036         emit Approval(owner, spender, amount);
1037     }
1038 
1039     /**
1040      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1041      *
1042      * Does not update the allowance amount in case of infinite allowance.
1043      * Revert if not enough allowance is available.
1044      *
1045      * Might emit an {Approval} event.
1046      */
1047     function _spendAllowance(
1048         address owner,
1049         address spender,
1050         uint256 amount
1051     ) internal virtual {
1052         uint256 currentAllowance = allowance(owner, spender);
1053         if (currentAllowance != type(uint256).max) {
1054             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1055             unchecked {
1056                 _approve(owner, spender, currentAllowance - amount);
1057             }
1058         }
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any transfer of tokens. This includes
1063      * minting and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1068      * will be transferred to `to`.
1069      * - when `from` is zero, `amount` tokens will be minted for `to`.
1070      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1071      * - `from` and `to` are never both zero.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(
1076         address from,
1077         address to,
1078         uint256 amount
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Hook that is called after any transfer of tokens. This includes
1083      * minting and burning.
1084      *
1085      * Calling conditions:
1086      *
1087      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1088      * has been transferred to `to`.
1089      * - when `from` is zero, `amount` tokens have been minted for `to`.
1090      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1091      * - `from` and `to` are never both zero.
1092      *
1093      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1094      */
1095     function _afterTokenTransfer(
1096         address from,
1097         address to,
1098         uint256 amount
1099     ) internal virtual {}
1100 }
1101 
1102 
1103 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
1104 /**
1105  * @title SafeERC20
1106  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1107  * contract returns false). Tokens that return no value (and instead revert or
1108  * throw on failure) are also supported, non-reverting calls are assumed to be
1109  * successful.
1110  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1111  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1112  */
1113 library SafeERC20 {
1114     using Address for address;
1115 
1116     function safeTransfer(
1117         IERC20 token,
1118         address to,
1119         uint256 value
1120     ) internal {
1121         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1122     }
1123 
1124     function safeTransferFrom(
1125         IERC20 token,
1126         address from,
1127         address to,
1128         uint256 value
1129     ) internal {
1130         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1131     }
1132 
1133     /**
1134      * @dev Deprecated. This function has issues similar to the ones found in
1135      * {IERC20-approve}, and its usage is discouraged.
1136      *
1137      * Whenever possible, use {safeIncreaseAllowance} and
1138      * {safeDecreaseAllowance} instead.
1139      */
1140     function safeApprove(
1141         IERC20 token,
1142         address spender,
1143         uint256 value
1144     ) internal {
1145         // safeApprove should only be called when setting an initial allowance,
1146         // or when resetting it to zero. To increase and decrease it, use
1147         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1148         require(
1149             (value == 0) || (token.allowance(address(this), spender) == 0),
1150             "SafeERC20: approve from non-zero to non-zero allowance"
1151         );
1152         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1153     }
1154 
1155     function safeIncreaseAllowance(
1156         IERC20 token,
1157         address spender,
1158         uint256 value
1159     ) internal {
1160         uint256 newAllowance = token.allowance(address(this), spender) + value;
1161         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1162     }
1163 
1164     function safeDecreaseAllowance(
1165         IERC20 token,
1166         address spender,
1167         uint256 value
1168     ) internal {
1169         unchecked {
1170             uint256 oldAllowance = token.allowance(address(this), spender);
1171             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1172             uint256 newAllowance = oldAllowance - value;
1173             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1174         }
1175     }
1176 
1177     /**
1178      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1179      * on the return value: the return value is optional (but if data is returned, it must not be false).
1180      * @param token The token targeted by the call.
1181      * @param data The call data (encoded using abi.encode or one of its variants).
1182      */
1183     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1184         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1185         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1186         // the target address contains contract code and also asserts for success in the low-level call.
1187 
1188         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1189         if (returndata.length > 0) {
1190             // Return data is optional
1191             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1192         }
1193     }
1194 }
1195 
1196 contract MKongStaking is Ownable, ReentrancyGuard {
1197   using SafeMath for uint256;
1198   using SafeERC20 for IERC20;
1199 
1200   struct UserInfo {
1201     uint256 stakedAmount;     // How many MKONG tokens the user has provided.
1202     uint256 rewardDebt;       // number of reward token user will get got. it is cleared when user stake or unstake token.
1203     uint256 lastDepositTime;  // time when user deposited
1204     uint256 unstakeStartTime; // time when when user clicked unstake btn.
1205     uint256 pendingAmount;    // # of tokens that is pending of 9 days.
1206   }
1207 
1208   event TokenStaked(address user, uint256 amount);
1209   event TokenWithdraw(address user, uint256 amount);
1210   event ClaimToken(address user, uint256 receiveAmount);
1211   event RewardRateSet(uint256 value);
1212   event RewardReceived(address receiver, uint256 rewardAmount);
1213 
1214   address public mkongToken;
1215   mapping (address => UserInfo) public userInfos;
1216 
1217   uint256 public totalStakedAmount;
1218   uint256 public rewardRate;
1219   uint256 public UNSTAKE_TIMEOFF = 9 days;
1220 
1221   constructor(address _token) {
1222     require(_token != address(0), "Zero address: Token");
1223     mkongToken = _token;
1224     totalStakedAmount = 0;
1225     rewardRate = 18; // User will get 18% reward after lockup time.
1226   }
1227   
1228   function setRewardRate(uint256 _newRate) public onlyOwner {
1229     require(_newRate != 0, "rate should be over 1");
1230     rewardRate = _newRate;
1231     emit RewardRateSet(_newRate);
1232   }
1233 
1234   function stakeToken(uint256 _amount) external nonReentrant updateReward(msg.sender) {
1235 
1236     require(_amount > 0, "invalid deposit amount");
1237 
1238     userInfos[msg.sender].stakedAmount = userInfos[msg.sender].stakedAmount.add(_amount);
1239     userInfos[msg.sender].lastDepositTime = block.timestamp;
1240     IERC20(mkongToken).safeTransferFrom(msg.sender, address(this), _amount);
1241     totalStakedAmount = totalStakedAmount.add(_amount);
1242     emit TokenStaked(msg.sender, _amount);
1243   }
1244 
1245   /**
1246   9 days Timer will start
1247   **/
1248   function unstakeToken(uint256 _amount, bool isEmergency) external nonReentrant updateReward(msg.sender) {
1249     require(_amount > 0, "invalid deposit amount");
1250     require( userInfos[msg.sender].stakedAmount >= _amount, "unstake amount is bigger than you staked" );
1251 
1252     uint256 outAmount = _amount + userInfos[msg.sender].rewardDebt;
1253     
1254     if ( isEmergency == true) {
1255       outAmount = outAmount.mul(91).div(100);
1256     }
1257     
1258     userInfos[msg.sender].stakedAmount = userInfos[msg.sender].stakedAmount.sub(_amount);
1259     userInfos[msg.sender].rewardDebt = 0;
1260     userInfos[msg.sender].lastDepositTime = block.timestamp;
1261 
1262     if ( isEmergency == true) {
1263         // send token to msg.sender.
1264         IERC20(mkongToken).safeTransfer(msg.sender, outAmount);
1265         emit ClaimToken(msg.sender, outAmount);
1266         return;
1267     }
1268 
1269     userInfos[msg.sender].unstakeStartTime = block.timestamp;
1270     userInfos[msg.sender].pendingAmount = userInfos[msg.sender].pendingAmount + outAmount;
1271 
1272     emit TokenWithdraw(msg.sender, outAmount);
1273   }
1274   
1275   // this function will be called after 9 days. actual token transfer happens here.
1276   function claim() external nonReentrant {
1277         
1278     require((block.timestamp - userInfos[msg.sender].unstakeStartTime) >= UNSTAKE_TIMEOFF, "invalid time: must be greater than 9 days");
1279     uint256 receiveAmount = userInfos[msg.sender].pendingAmount;
1280     require( receiveAmount > 0, "no available amount" );
1281     require(IERC20(mkongToken).balanceOf(address(this)) >= receiveAmount, "staking contract has not enough mkong token");
1282 
1283     IERC20(mkongToken).safeTransfer(msg.sender, receiveAmount);
1284     totalStakedAmount = IERC20(mkongToken).balanceOf(address(this)).sub(receiveAmount);
1285     userInfos[msg.sender].pendingAmount = 0;
1286     userInfos[msg.sender].unstakeStartTime = block.timestamp;
1287     
1288     emit ClaimToken(msg.sender, receiveAmount);
1289   }
1290 
1291   function isClaimable(address user) external view returns (bool){
1292       if (userInfos[user].unstakeStartTime == 0)
1293         return false;
1294         
1295       return (block.timestamp - userInfos[user].unstakeStartTime  > UNSTAKE_TIMEOFF)? true : false;
1296   }
1297 
1298   function timeDiffForClaim(address user) external view returns (uint256) {
1299       return (userInfos[user].unstakeStartTime + UNSTAKE_TIMEOFF > block.timestamp) ? userInfos[user].unstakeStartTime + UNSTAKE_TIMEOFF - block.timestamp : 0 ;
1300   }
1301 
1302   function setUnstakeTimeoff(uint256 time_) external onlyOwner {
1303       UNSTAKE_TIMEOFF = time_;
1304   }
1305 
1306   function calcReward(address account) public view returns (uint256) {
1307     uint256 rewardVal = (block.timestamp - userInfos[account].lastDepositTime).mul(userInfos[account].stakedAmount).mul(rewardRate).div(365 days);
1308     return rewardVal.div(100).add(userInfos[account].rewardDebt);
1309   }
1310 
1311   modifier updateReward(address account) {
1312       if (account != address(0)) {
1313         if (userInfos[account].lastDepositTime == 0) {
1314           userInfos[account].lastDepositTime = block.timestamp;
1315           userInfos[account].rewardDebt = 0;
1316         }else {
1317           userInfos[account].rewardDebt = calcReward(account);  
1318         }
1319       }
1320       _;
1321   }
1322 }