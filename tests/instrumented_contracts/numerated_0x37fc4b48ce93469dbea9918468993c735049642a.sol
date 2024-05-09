1 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: openzeppelin-solidity/contracts/utils/Address.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize, which returns 0 for contracts in
259         // construction, since the code is only stored at the end of the
260         // constructor execution.
261 
262         uint256 size;
263         assembly {
264             size := extcodesize(account)
265         }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 // File: openzeppelin-solidity/contracts/utils/Context.sol
450 
451 
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 abstract contract Context {
466     function _msgSender() internal view virtual returns (address) {
467         return msg.sender;
468     }
469 
470     function _msgData() internal view virtual returns (bytes calldata) {
471         return msg.data;
472     }
473 }
474 
475 // File: openzeppelin-solidity/contracts/access/Ownable.sol
476 
477 
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Contract module which provides a basic access control mechanism, where
484  * there is an account (an owner) that can be granted exclusive access to
485  * specific functions.
486  *
487  * By default, the owner account will be the one that deploys the contract. This
488  * can later be changed with {transferOwnership}.
489  *
490  * This module is used through inheritance. It will make available the modifier
491  * `onlyOwner`, which can be applied to your functions to restrict their use to
492  * the owner.
493  */
494 abstract contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
498 
499     /**
500      * @dev Initializes the contract setting the deployer as the initial owner.
501      */
502     constructor() {
503         _setOwner(_msgSender());
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view virtual returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         _setOwner(address(0));
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         _setOwner(newOwner);
539     }
540 
541     function _setOwner(address newOwner) private {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 // File: openzeppelin-solidity/contracts/security/Pausable.sol
549 
550 
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Contract module which allows children to implement an emergency stop
557  * mechanism that can be triggered by an authorized account.
558  *
559  * This module is used through inheritance. It will make available the
560  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
561  * the functions of your contract. Note that they will not be pausable by
562  * simply including this module, only once the modifiers are put in place.
563  */
564 abstract contract Pausable is Context {
565     /**
566      * @dev Emitted when the pause is triggered by `account`.
567      */
568     event Paused(address account);
569 
570     /**
571      * @dev Emitted when the pause is lifted by `account`.
572      */
573     event Unpaused(address account);
574 
575     bool private _paused;
576 
577     /**
578      * @dev Initializes the contract in unpaused state.
579      */
580     constructor() {
581         _paused = false;
582     }
583 
584     /**
585      * @dev Returns true if the contract is paused, and false otherwise.
586      */
587     function paused() public view virtual returns (bool) {
588         return _paused;
589     }
590 
591     /**
592      * @dev Modifier to make a function callable only when the contract is not paused.
593      *
594      * Requirements:
595      *
596      * - The contract must not be paused.
597      */
598     modifier whenNotPaused() {
599         require(!paused(), "Pausable: paused");
600         _;
601     }
602 
603     /**
604      * @dev Modifier to make a function callable only when the contract is paused.
605      *
606      * Requirements:
607      *
608      * - The contract must be paused.
609      */
610     modifier whenPaused() {
611         require(paused(), "Pausable: not paused");
612         _;
613     }
614 
615     /**
616      * @dev Triggers stopped state.
617      *
618      * Requirements:
619      *
620      * - The contract must not be paused.
621      */
622     function _pause() internal virtual whenNotPaused {
623         _paused = true;
624         emit Paused(_msgSender());
625     }
626 
627     /**
628      * @dev Returns to normal state.
629      *
630      * Requirements:
631      *
632      * - The contract must be paused.
633      */
634     function _unpause() internal virtual whenPaused {
635         _paused = false;
636         emit Unpaused(_msgSender());
637     }
638 }
639 
640 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
641 
642 
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev Interface of the ERC20 standard as defined in the EIP.
648  */
649 interface IERC20 {
650     /**
651      * @dev Returns the amount of tokens in existence.
652      */
653     function totalSupply() external view returns (uint256);
654 
655     /**
656      * @dev Returns the amount of tokens owned by `account`.
657      */
658     function balanceOf(address account) external view returns (uint256);
659 
660     /**
661      * @dev Moves `amount` tokens from the caller's account to `recipient`.
662      *
663      * Returns a boolean value indicating whether the operation succeeded.
664      *
665      * Emits a {Transfer} event.
666      */
667     function transfer(address recipient, uint256 amount) external returns (bool);
668 
669     /**
670      * @dev Returns the remaining number of tokens that `spender` will be
671      * allowed to spend on behalf of `owner` through {transferFrom}. This is
672      * zero by default.
673      *
674      * This value changes when {approve} or {transferFrom} are called.
675      */
676     function allowance(address owner, address spender) external view returns (uint256);
677 
678     /**
679      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
680      *
681      * Returns a boolean value indicating whether the operation succeeded.
682      *
683      * IMPORTANT: Beware that changing an allowance with this method brings the risk
684      * that someone may use both the old and the new allowance by unfortunate
685      * transaction ordering. One possible solution to mitigate this race
686      * condition is to first reduce the spender's allowance to 0 and set the
687      * desired value afterwards:
688      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
689      *
690      * Emits an {Approval} event.
691      */
692     function approve(address spender, uint256 amount) external returns (bool);
693 
694     /**
695      * @dev Moves `amount` tokens from `sender` to `recipient` using the
696      * allowance mechanism. `amount` is then deducted from the caller's
697      * allowance.
698      *
699      * Returns a boolean value indicating whether the operation succeeded.
700      *
701      * Emits a {Transfer} event.
702      */
703     function transferFrom(
704         address sender,
705         address recipient,
706         uint256 amount
707     ) external returns (bool);
708 
709     /**
710      * @dev Emitted when `value` tokens are moved from one account (`from`) to
711      * another (`to`).
712      *
713      * Note that `value` may be zero.
714      */
715     event Transfer(address indexed from, address indexed to, uint256 value);
716 
717     /**
718      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
719      * a call to {approve}. `value` is the new allowance.
720      */
721     event Approval(address indexed owner, address indexed spender, uint256 value);
722 }
723 
724 // File: openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol
725 
726 
727 
728 pragma solidity ^0.8.0;
729 
730 
731 
732 /**
733  * @title SafeERC20
734  * @dev Wrappers around ERC20 operations that throw on failure (when the token
735  * contract returns false). Tokens that return no value (and instead revert or
736  * throw on failure) are also supported, non-reverting calls are assumed to be
737  * successful.
738  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
739  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
740  */
741 library SafeERC20 {
742     using Address for address;
743 
744     function safeTransfer(
745         IERC20 token,
746         address to,
747         uint256 value
748     ) internal {
749         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
750     }
751 
752     function safeTransferFrom(
753         IERC20 token,
754         address from,
755         address to,
756         uint256 value
757     ) internal {
758         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
759     }
760 
761     /**
762      * @dev Deprecated. This function has issues similar to the ones found in
763      * {IERC20-approve}, and its usage is discouraged.
764      *
765      * Whenever possible, use {safeIncreaseAllowance} and
766      * {safeDecreaseAllowance} instead.
767      */
768     function safeApprove(
769         IERC20 token,
770         address spender,
771         uint256 value
772     ) internal {
773         // safeApprove should only be called when setting an initial allowance,
774         // or when resetting it to zero. To increase and decrease it, use
775         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
776         require(
777             (value == 0) || (token.allowance(address(this), spender) == 0),
778             "SafeERC20: approve from non-zero to non-zero allowance"
779         );
780         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
781     }
782 
783     function safeIncreaseAllowance(
784         IERC20 token,
785         address spender,
786         uint256 value
787     ) internal {
788         uint256 newAllowance = token.allowance(address(this), spender) + value;
789         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
790     }
791 
792     function safeDecreaseAllowance(
793         IERC20 token,
794         address spender,
795         uint256 value
796     ) internal {
797         unchecked {
798             uint256 oldAllowance = token.allowance(address(this), spender);
799             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
800             uint256 newAllowance = oldAllowance - value;
801             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
802         }
803     }
804 
805     /**
806      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
807      * on the return value: the return value is optional (but if data is returned, it must not be false).
808      * @param token The token targeted by the call.
809      * @param data The call data (encoded using abi.encode or one of its variants).
810      */
811     function _callOptionalReturn(IERC20 token, bytes memory data) private {
812         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
813         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
814         // the target address contains contract code and also asserts for success in the low-level call.
815 
816         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
817         if (returndata.length > 0) {
818             // Return data is optional
819             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
820         }
821     }
822 }
823 
824 // File: openzeppelin-solidity/contracts/token/ERC20/extensions/IERC20Metadata.sol
825 
826 
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @dev Interface for the optional metadata functions from the ERC20 standard.
833  *
834  * _Available since v4.1._
835  */
836 interface IERC20Metadata is IERC20 {
837     /**
838      * @dev Returns the name of the token.
839      */
840     function name() external view returns (string memory);
841 
842     /**
843      * @dev Returns the symbol of the token.
844      */
845     function symbol() external view returns (string memory);
846 
847     /**
848      * @dev Returns the decimals places of the token.
849      */
850     function decimals() external view returns (uint8);
851 }
852 
853 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
854 
855 
856 
857 pragma solidity ^0.8.0;
858 
859 
860 
861 
862 /**
863  * @dev Implementation of the {IERC20} interface.
864  *
865  * This implementation is agnostic to the way tokens are created. This means
866  * that a supply mechanism has to be added in a derived contract using {_mint}.
867  * For a generic mechanism see {ERC20PresetMinterPauser}.
868  *
869  * TIP: For a detailed writeup see our guide
870  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
871  * to implement supply mechanisms].
872  *
873  * We have followed general OpenZeppelin Contracts guidelines: functions revert
874  * instead returning `false` on failure. This behavior is nonetheless
875  * conventional and does not conflict with the expectations of ERC20
876  * applications.
877  *
878  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
879  * This allows applications to reconstruct the allowance for all accounts just
880  * by listening to said events. Other implementations of the EIP may not emit
881  * these events, as it isn't required by the specification.
882  *
883  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
884  * functions have been added to mitigate the well-known issues around setting
885  * allowances. See {IERC20-approve}.
886  */
887 contract ERC20 is Context, IERC20, IERC20Metadata {
888     mapping(address => uint256) private _balances;
889 
890     mapping(address => mapping(address => uint256)) private _allowances;
891 
892     uint256 private _totalSupply;
893 
894     string private _name;
895     string private _symbol;
896 
897     /**
898      * @dev Sets the values for {name} and {symbol}.
899      *
900      * The default value of {decimals} is 18. To select a different value for
901      * {decimals} you should overload it.
902      *
903      * All two of these values are immutable: they can only be set once during
904      * construction.
905      */
906     constructor(string memory name_, string memory symbol_) {
907         _name = name_;
908         _symbol = symbol_;
909     }
910 
911     /**
912      * @dev Returns the name of the token.
913      */
914     function name() public view virtual override returns (string memory) {
915         return _name;
916     }
917 
918     /**
919      * @dev Returns the symbol of the token, usually a shorter version of the
920      * name.
921      */
922     function symbol() public view virtual override returns (string memory) {
923         return _symbol;
924     }
925 
926     /**
927      * @dev Returns the number of decimals used to get its user representation.
928      * For example, if `decimals` equals `2`, a balance of `505` tokens should
929      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
930      *
931      * Tokens usually opt for a value of 18, imitating the relationship between
932      * Ether and Wei. This is the value {ERC20} uses, unless this function is
933      * overridden;
934      *
935      * NOTE: This information is only used for _display_ purposes: it in
936      * no way affects any of the arithmetic of the contract, including
937      * {IERC20-balanceOf} and {IERC20-transfer}.
938      */
939     function decimals() public view virtual override returns (uint8) {
940         return 18;
941     }
942 
943     /**
944      * @dev See {IERC20-totalSupply}.
945      */
946     function totalSupply() public view virtual override returns (uint256) {
947         return _totalSupply;
948     }
949 
950     /**
951      * @dev See {IERC20-balanceOf}.
952      */
953     function balanceOf(address account) public view virtual override returns (uint256) {
954         return _balances[account];
955     }
956 
957     /**
958      * @dev See {IERC20-transfer}.
959      *
960      * Requirements:
961      *
962      * - `recipient` cannot be the zero address.
963      * - the caller must have a balance of at least `amount`.
964      */
965     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
966         _transfer(_msgSender(), recipient, amount);
967         return true;
968     }
969 
970     /**
971      * @dev See {IERC20-allowance}.
972      */
973     function allowance(address owner, address spender) public view virtual override returns (uint256) {
974         return _allowances[owner][spender];
975     }
976 
977     /**
978      * @dev See {IERC20-approve}.
979      *
980      * Requirements:
981      *
982      * - `spender` cannot be the zero address.
983      */
984     function approve(address spender, uint256 amount) public virtual override returns (bool) {
985         _approve(_msgSender(), spender, amount);
986         return true;
987     }
988 
989     /**
990      * @dev See {IERC20-transferFrom}.
991      *
992      * Emits an {Approval} event indicating the updated allowance. This is not
993      * required by the EIP. See the note at the beginning of {ERC20}.
994      *
995      * Requirements:
996      *
997      * - `sender` and `recipient` cannot be the zero address.
998      * - `sender` must have a balance of at least `amount`.
999      * - the caller must have allowance for ``sender``'s tokens of at least
1000      * `amount`.
1001      */
1002     function transferFrom(
1003         address sender,
1004         address recipient,
1005         uint256 amount
1006     ) public virtual override returns (bool) {
1007         _transfer(sender, recipient, amount);
1008 
1009         uint256 currentAllowance = _allowances[sender][_msgSender()];
1010         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1011         unchecked {
1012             _approve(sender, _msgSender(), currentAllowance - amount);
1013         }
1014 
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev Atomically increases the allowance granted to `spender` by the caller.
1020      *
1021      * This is an alternative to {approve} that can be used as a mitigation for
1022      * problems described in {IERC20-approve}.
1023      *
1024      * Emits an {Approval} event indicating the updated allowance.
1025      *
1026      * Requirements:
1027      *
1028      * - `spender` cannot be the zero address.
1029      */
1030     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1031         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1032         return true;
1033     }
1034 
1035     /**
1036      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1037      *
1038      * This is an alternative to {approve} that can be used as a mitigation for
1039      * problems described in {IERC20-approve}.
1040      *
1041      * Emits an {Approval} event indicating the updated allowance.
1042      *
1043      * Requirements:
1044      *
1045      * - `spender` cannot be the zero address.
1046      * - `spender` must have allowance for the caller of at least
1047      * `subtractedValue`.
1048      */
1049     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1050         uint256 currentAllowance = _allowances[_msgSender()][spender];
1051         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1052         unchecked {
1053             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1054         }
1055 
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1061      *
1062      * This internal function is equivalent to {transfer}, and can be used to
1063      * e.g. implement automatic token fees, slashing mechanisms, etc.
1064      *
1065      * Emits a {Transfer} event.
1066      *
1067      * Requirements:
1068      *
1069      * - `sender` cannot be the zero address.
1070      * - `recipient` cannot be the zero address.
1071      * - `sender` must have a balance of at least `amount`.
1072      */
1073     function _transfer(
1074         address sender,
1075         address recipient,
1076         uint256 amount
1077     ) internal virtual {
1078         require(sender != address(0), "ERC20: transfer from the zero address");
1079         require(recipient != address(0), "ERC20: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(sender, recipient, amount);
1082 
1083         uint256 senderBalance = _balances[sender];
1084         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1085         unchecked {
1086             _balances[sender] = senderBalance - amount;
1087         }
1088         _balances[recipient] += amount;
1089 
1090         emit Transfer(sender, recipient, amount);
1091 
1092         _afterTokenTransfer(sender, recipient, amount);
1093     }
1094 
1095     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1096      * the total supply.
1097      *
1098      * Emits a {Transfer} event with `from` set to the zero address.
1099      *
1100      * Requirements:
1101      *
1102      * - `account` cannot be the zero address.
1103      */
1104     function _mint(address account, uint256 amount) internal virtual {
1105         require(account != address(0), "ERC20: mint to the zero address");
1106 
1107         _beforeTokenTransfer(address(0), account, amount);
1108 
1109         _totalSupply += amount;
1110         _balances[account] += amount;
1111         emit Transfer(address(0), account, amount);
1112 
1113         _afterTokenTransfer(address(0), account, amount);
1114     }
1115 
1116     /**
1117      * @dev Destroys `amount` tokens from `account`, reducing the
1118      * total supply.
1119      *
1120      * Emits a {Transfer} event with `to` set to the zero address.
1121      *
1122      * Requirements:
1123      *
1124      * - `account` cannot be the zero address.
1125      * - `account` must have at least `amount` tokens.
1126      */
1127     function _burn(address account, uint256 amount) internal virtual {
1128         require(account != address(0), "ERC20: burn from the zero address");
1129 
1130         _beforeTokenTransfer(account, address(0), amount);
1131 
1132         uint256 accountBalance = _balances[account];
1133         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1134         unchecked {
1135             _balances[account] = accountBalance - amount;
1136         }
1137         _totalSupply -= amount;
1138 
1139         emit Transfer(account, address(0), amount);
1140 
1141         _afterTokenTransfer(account, address(0), amount);
1142     }
1143 
1144     /**
1145      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1146      *
1147      * This internal function is equivalent to `approve`, and can be used to
1148      * e.g. set automatic allowances for certain subsystems, etc.
1149      *
1150      * Emits an {Approval} event.
1151      *
1152      * Requirements:
1153      *
1154      * - `owner` cannot be the zero address.
1155      * - `spender` cannot be the zero address.
1156      */
1157     function _approve(
1158         address owner,
1159         address spender,
1160         uint256 amount
1161     ) internal virtual {
1162         require(owner != address(0), "ERC20: approve from the zero address");
1163         require(spender != address(0), "ERC20: approve to the zero address");
1164 
1165         _allowances[owner][spender] = amount;
1166         emit Approval(owner, spender, amount);
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before any transfer of tokens. This includes
1171      * minting and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1176      * will be transferred to `to`.
1177      * - when `from` is zero, `amount` tokens will be minted for `to`.
1178      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _beforeTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 amount
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after any transfer of tokens. This includes
1191      * minting and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1196      * has been transferred to `to`.
1197      * - when `from` is zero, `amount` tokens have been minted for `to`.
1198      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1199      * - `from` and `to` are never both zero.
1200      *
1201      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1202      */
1203     function _afterTokenTransfer(
1204         address from,
1205         address to,
1206         uint256 amount
1207     ) internal virtual {}
1208 }
1209 
1210 // File: openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Pausable.sol
1211 
1212 
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 
1217 
1218 /**
1219  * @dev ERC20 token with pausable token transfers, minting and burning.
1220  *
1221  * Useful for scenarios such as preventing trades until the end of an evaluation
1222  * period, or having an emergency switch for freezing all token transfers in the
1223  * event of a large bug.
1224  */
1225 abstract contract ERC20Pausable is ERC20, Pausable {
1226     /**
1227      * @dev See {ERC20-_beforeTokenTransfer}.
1228      *
1229      * Requirements:
1230      *
1231      * - the contract must not be paused.
1232      */
1233     function _beforeTokenTransfer(
1234         address from,
1235         address to,
1236         uint256 amount
1237     ) internal virtual override {
1238         super._beforeTokenTransfer(from, to, amount);
1239 
1240         require(!paused(), "ERC20Pausable: token transfer while paused");
1241     }
1242 }
1243 
1244 // File: github/CropBytes/cropbytes-contracts/contracts/CropBytes.sol
1245 
1246 
1247 pragma solidity 0.8.0;
1248 
1249 
1250 
1251 
1252 
1253 
1254 
1255 
1256 
1257 
1258 contract CropBytes is Ownable, ERC20Pausable {
1259   // IEO	Swap 	Foundation	Product 	Marketing	Team 	Advisor	Mining
1260     
1261   /**
1262    * @dev Constructor that gives msg.sender all of existing tokens.
1263    */
1264   constructor ()  ERC20("CropBytes", "CBX") {
1265     _mint(msg.sender, 500000000 * (10 ** uint256(decimals())));
1266   }
1267   function pause() public virtual  onlyOwner {
1268        
1269         _pause();
1270     }
1271 
1272     /**
1273      * @dev Unpauses all token transfers.
1274      *
1275      * Requirements:
1276      *
1277      * - the caller must have the `PAUSER_ROLE`.
1278      */
1279     function unpause() public virtual onlyOwner {
1280         _unpause();
1281     }
1282 
1283 }