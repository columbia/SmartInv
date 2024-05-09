1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445                 /// @solidity memory-safe-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/Context.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/access/Ownable.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 abstract contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor() {
513         _transferOwnership(_msgSender());
514     }
515 
516     /**
517      * @dev Throws if called by any account other than the owner.
518      */
519     modifier onlyOwner() {
520         _checkOwner();
521         _;
522     }
523 
524     /**
525      * @dev Returns the address of the current owner.
526      */
527     function owner() public view virtual returns (address) {
528         return _owner;
529     }
530 
531     /**
532      * @dev Throws if the sender is not the owner.
533      */
534     function _checkOwner() internal view virtual {
535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         _transferOwnership(address(0));
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public virtual onlyOwner {
554         require(newOwner != address(0), "Ownable: new owner is the zero address");
555         _transferOwnership(newOwner);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Internal function without access restriction.
561      */
562     function _transferOwnership(address newOwner) internal virtual {
563         address oldOwner = _owner;
564         _owner = newOwner;
565         emit OwnershipTransferred(oldOwner, newOwner);
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
570 
571 
572 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev Interface of the ERC20 standard as defined in the EIP.
578  */
579 interface IERC20 {
580     /**
581      * @dev Emitted when `value` tokens are moved from one account (`from`) to
582      * another (`to`).
583      *
584      * Note that `value` may be zero.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 value);
587 
588     /**
589      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
590      * a call to {approve}. `value` is the new allowance.
591      */
592     event Approval(address indexed owner, address indexed spender, uint256 value);
593 
594     /**
595      * @dev Returns the amount of tokens in existence.
596      */
597     function totalSupply() external view returns (uint256);
598 
599     /**
600      * @dev Returns the amount of tokens owned by `account`.
601      */
602     function balanceOf(address account) external view returns (uint256);
603 
604     /**
605      * @dev Moves `amount` tokens from the caller's account to `to`.
606      *
607      * Returns a boolean value indicating whether the operation succeeded.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transfer(address to, uint256 amount) external returns (bool);
612 
613     /**
614      * @dev Returns the remaining number of tokens that `spender` will be
615      * allowed to spend on behalf of `owner` through {transferFrom}. This is
616      * zero by default.
617      *
618      * This value changes when {approve} or {transferFrom} are called.
619      */
620     function allowance(address owner, address spender) external view returns (uint256);
621 
622     /**
623      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
624      *
625      * Returns a boolean value indicating whether the operation succeeded.
626      *
627      * IMPORTANT: Beware that changing an allowance with this method brings the risk
628      * that someone may use both the old and the new allowance by unfortunate
629      * transaction ordering. One possible solution to mitigate this race
630      * condition is to first reduce the spender's allowance to 0 and set the
631      * desired value afterwards:
632      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address spender, uint256 amount) external returns (bool);
637 
638     /**
639      * @dev Moves `amount` tokens from `from` to `to` using the
640      * allowance mechanism. `amount` is then deducted from the caller's
641      * allowance.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 amount
651     ) external returns (bool);
652 }
653 
654 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @dev Interface for the optional metadata functions from the ERC20 standard.
664  *
665  * _Available since v4.1._
666  */
667 interface IERC20Metadata is IERC20 {
668     /**
669      * @dev Returns the name of the token.
670      */
671     function name() external view returns (string memory);
672 
673     /**
674      * @dev Returns the symbol of the token.
675      */
676     function symbol() external view returns (string memory);
677 
678     /**
679      * @dev Returns the decimals places of the token.
680      */
681     function decimals() external view returns (uint8);
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
685 
686 
687 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 
693 
694 /**
695  * @dev Implementation of the {IERC20} interface.
696  *
697  * This implementation is agnostic to the way tokens are created. This means
698  * that a supply mechanism has to be added in a derived contract using {_mint}.
699  * For a generic mechanism see {ERC20PresetMinterPauser}.
700  *
701  * TIP: For a detailed writeup see our guide
702  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
703  * to implement supply mechanisms].
704  *
705  * We have followed general OpenZeppelin Contracts guidelines: functions revert
706  * instead returning `false` on failure. This behavior is nonetheless
707  * conventional and does not conflict with the expectations of ERC20
708  * applications.
709  *
710  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
711  * This allows applications to reconstruct the allowance for all accounts just
712  * by listening to said events. Other implementations of the EIP may not emit
713  * these events, as it isn't required by the specification.
714  *
715  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
716  * functions have been added to mitigate the well-known issues around setting
717  * allowances. See {IERC20-approve}.
718  */
719 contract ERC20 is Context, IERC20, IERC20Metadata {
720     mapping(address => uint256) private _balances;
721 
722     mapping(address => mapping(address => uint256)) private _allowances;
723 
724     uint256 private _totalSupply;
725 
726     string private _name;
727     string private _symbol;
728 
729     /**
730      * @dev Sets the values for {name} and {symbol}.
731      *
732      * The default value of {decimals} is 18. To select a different value for
733      * {decimals} you should overload it.
734      *
735      * All two of these values are immutable: they can only be set once during
736      * construction.
737      */
738     constructor(string memory name_, string memory symbol_) {
739         _name = name_;
740         _symbol = symbol_;
741     }
742 
743     /**
744      * @dev Returns the name of the token.
745      */
746     function name() public view virtual override returns (string memory) {
747         return _name;
748     }
749 
750     /**
751      * @dev Returns the symbol of the token, usually a shorter version of the
752      * name.
753      */
754     function symbol() public view virtual override returns (string memory) {
755         return _symbol;
756     }
757 
758     /**
759      * @dev Returns the number of decimals used to get its user representation.
760      * For example, if `decimals` equals `2`, a balance of `505` tokens should
761      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
762      *
763      * Tokens usually opt for a value of 18, imitating the relationship between
764      * Ether and Wei. This is the value {ERC20} uses, unless this function is
765      * overridden;
766      *
767      * NOTE: This information is only used for _display_ purposes: it in
768      * no way affects any of the arithmetic of the contract, including
769      * {IERC20-balanceOf} and {IERC20-transfer}.
770      */
771     function decimals() public view virtual override returns (uint8) {
772         return 18;
773     }
774 
775     /**
776      * @dev See {IERC20-totalSupply}.
777      */
778     function totalSupply() public view virtual override returns (uint256) {
779         return _totalSupply;
780     }
781 
782     /**
783      * @dev See {IERC20-balanceOf}.
784      */
785     function balanceOf(address account) public view virtual override returns (uint256) {
786         return _balances[account];
787     }
788 
789     /**
790      * @dev See {IERC20-transfer}.
791      *
792      * Requirements:
793      *
794      * - `to` cannot be the zero address.
795      * - the caller must have a balance of at least `amount`.
796      */
797     function transfer(address to, uint256 amount) public virtual override returns (bool) {
798         address owner = _msgSender();
799         _transfer(owner, to, amount);
800         return true;
801     }
802 
803     /**
804      * @dev See {IERC20-allowance}.
805      */
806     function allowance(address owner, address spender) public view virtual override returns (uint256) {
807         return _allowances[owner][spender];
808     }
809 
810     /**
811      * @dev See {IERC20-approve}.
812      *
813      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
814      * `transferFrom`. This is semantically equivalent to an infinite approval.
815      *
816      * Requirements:
817      *
818      * - `spender` cannot be the zero address.
819      */
820     function approve(address spender, uint256 amount) public virtual override returns (bool) {
821         address owner = _msgSender();
822         _approve(owner, spender, amount);
823         return true;
824     }
825 
826     /**
827      * @dev See {IERC20-transferFrom}.
828      *
829      * Emits an {Approval} event indicating the updated allowance. This is not
830      * required by the EIP. See the note at the beginning of {ERC20}.
831      *
832      * NOTE: Does not update the allowance if the current allowance
833      * is the maximum `uint256`.
834      *
835      * Requirements:
836      *
837      * - `from` and `to` cannot be the zero address.
838      * - `from` must have a balance of at least `amount`.
839      * - the caller must have allowance for ``from``'s tokens of at least
840      * `amount`.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 amount
846     ) public virtual override returns (bool) {
847         address spender = _msgSender();
848         _spendAllowance(from, spender, amount);
849         _transfer(from, to, amount);
850         return true;
851     }
852 
853     /**
854      * @dev Atomically increases the allowance granted to `spender` by the caller.
855      *
856      * This is an alternative to {approve} that can be used as a mitigation for
857      * problems described in {IERC20-approve}.
858      *
859      * Emits an {Approval} event indicating the updated allowance.
860      *
861      * Requirements:
862      *
863      * - `spender` cannot be the zero address.
864      */
865     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
866         address owner = _msgSender();
867         _approve(owner, spender, allowance(owner, spender) + addedValue);
868         return true;
869     }
870 
871     /**
872      * @dev Atomically decreases the allowance granted to `spender` by the caller.
873      *
874      * This is an alternative to {approve} that can be used as a mitigation for
875      * problems described in {IERC20-approve}.
876      *
877      * Emits an {Approval} event indicating the updated allowance.
878      *
879      * Requirements:
880      *
881      * - `spender` cannot be the zero address.
882      * - `spender` must have allowance for the caller of at least
883      * `subtractedValue`.
884      */
885     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
886         address owner = _msgSender();
887         uint256 currentAllowance = allowance(owner, spender);
888         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
889         unchecked {
890             _approve(owner, spender, currentAllowance - subtractedValue);
891         }
892 
893         return true;
894     }
895 
896     /**
897      * @dev Moves `amount` of tokens from `from` to `to`.
898      *
899      * This internal function is equivalent to {transfer}, and can be used to
900      * e.g. implement automatic token fees, slashing mechanisms, etc.
901      *
902      * Emits a {Transfer} event.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `from` must have a balance of at least `amount`.
909      */
910     function _transfer(
911         address from,
912         address to,
913         uint256 amount
914     ) internal virtual {
915         require(from != address(0), "ERC20: transfer from the zero address");
916         require(to != address(0), "ERC20: transfer to the zero address");
917 
918         _beforeTokenTransfer(from, to, amount);
919 
920         uint256 fromBalance = _balances[from];
921         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
922         unchecked {
923             _balances[from] = fromBalance - amount;
924         }
925         _balances[to] += amount;
926 
927         emit Transfer(from, to, amount);
928 
929         _afterTokenTransfer(from, to, amount);
930     }
931 
932     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
933      * the total supply.
934      *
935      * Emits a {Transfer} event with `from` set to the zero address.
936      *
937      * Requirements:
938      *
939      * - `account` cannot be the zero address.
940      */
941     function _mint(address account, uint256 amount) internal virtual {
942         require(account != address(0), "ERC20: mint to the zero address");
943 
944         _beforeTokenTransfer(address(0), account, amount);
945 
946         _totalSupply += amount;
947         _balances[account] += amount;
948         emit Transfer(address(0), account, amount);
949 
950         _afterTokenTransfer(address(0), account, amount);
951     }
952 
953     /**
954      * @dev Destroys `amount` tokens from `account`, reducing the
955      * total supply.
956      *
957      * Emits a {Transfer} event with `to` set to the zero address.
958      *
959      * Requirements:
960      *
961      * - `account` cannot be the zero address.
962      * - `account` must have at least `amount` tokens.
963      */
964     function _burn(address account, uint256 amount) internal virtual {
965         require(account != address(0), "ERC20: burn from the zero address");
966 
967         _beforeTokenTransfer(account, address(0), amount);
968 
969         uint256 accountBalance = _balances[account];
970         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
971         unchecked {
972             _balances[account] = accountBalance - amount;
973         }
974         _totalSupply -= amount;
975 
976         emit Transfer(account, address(0), amount);
977 
978         _afterTokenTransfer(account, address(0), amount);
979     }
980 
981     /**
982      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
983      *
984      * This internal function is equivalent to `approve`, and can be used to
985      * e.g. set automatic allowances for certain subsystems, etc.
986      *
987      * Emits an {Approval} event.
988      *
989      * Requirements:
990      *
991      * - `owner` cannot be the zero address.
992      * - `spender` cannot be the zero address.
993      */
994     function _approve(
995         address owner,
996         address spender,
997         uint256 amount
998     ) internal virtual {
999         require(owner != address(0), "ERC20: approve from the zero address");
1000         require(spender != address(0), "ERC20: approve to the zero address");
1001 
1002         _allowances[owner][spender] = amount;
1003         emit Approval(owner, spender, amount);
1004     }
1005 
1006     /**
1007      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1008      *
1009      * Does not update the allowance amount in case of infinite allowance.
1010      * Revert if not enough allowance is available.
1011      *
1012      * Might emit an {Approval} event.
1013      */
1014     function _spendAllowance(
1015         address owner,
1016         address spender,
1017         uint256 amount
1018     ) internal virtual {
1019         uint256 currentAllowance = allowance(owner, spender);
1020         if (currentAllowance != type(uint256).max) {
1021             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1022             unchecked {
1023                 _approve(owner, spender, currentAllowance - amount);
1024             }
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any transfer of tokens. This includes
1030      * minting and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1035      * will be transferred to `to`.
1036      * - when `from` is zero, `amount` tokens will be minted for `to`.
1037      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 amount
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Hook that is called after any transfer of tokens. This includes
1050      * minting and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1055      * has been transferred to `to`.
1056      * - when `from` is zero, `amount` tokens have been minted for `to`.
1057      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1058      * - `from` and `to` are never both zero.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _afterTokenTransfer(
1063         address from,
1064         address to,
1065         uint256 amount
1066     ) internal virtual {}
1067 }
1068 
1069 // File: contracts/ERC20/8_ERC20_EPAY.sol
1070 
1071 
1072 pragma solidity ^0.8.4;
1073 
1074 
1075 
1076 
1077 
1078 contract ERC20Base is Context, ERC20, Ownable {
1079     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){
1080         _mint(msg.sender, 20*(10**8)*(10**uint256(decimals())));
1081     }
1082 }
1083 
1084 contract EPAY is ERC20Base {
1085     constructor() ERC20Base("EPAY", "EPAY"){}
1086 }