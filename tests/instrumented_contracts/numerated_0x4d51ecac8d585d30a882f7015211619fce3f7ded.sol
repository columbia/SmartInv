1 // SPDX-License-Identifier: GNU
2 
3 
4 // AE T H E R 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
7 
8 pragma solidity 0.8.7; 
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
237 
238 pragma solidity 0.8.7;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/utils/Context.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
457 
458 pragma solidity 0.8.7;
459 
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 // File: contracts/Akylles/paymentsplitter.sol
481 
482 
483 
484 pragma solidity 0.8.7;
485 
486 
487 
488 
489 /**
490  * @title PaymentSplitter
491  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
492  * that the Ether will be split in this way, since it is handled transparently by the contract.
493  *
494  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
495  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
496  * an amount proportional to the percentage of total shares they were assigned.
497  *
498  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
499  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
500  * function.
501  */
502 contract PaymentSplitter is Context {
503      using SafeMath for uint;
504     event PayeeAdded(address account, uint256 shares);
505     event PaymentReleased(address to, uint256 amount);
506     
507     uint256 private _totalShares;
508     uint256 private _totalReleased;
509 
510     mapping(address => uint256) private _shares;
511     mapping(address => uint256) private _released;
512     address[] private _payees;
513 
514     /**
515      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
516      * the matching position in the `shares` array.
517      *
518      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
519      * duplicates in `payees`.
520      */
521     constructor(address[] memory payees, uint256[] memory shares_) payable {
522         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
523         require(payees.length > 0, "PaymentSplitter: no payees");
524 
525         for (uint256 i = 0; i < payees.length; i++) {
526             _addPayee(payees[i], shares_[i]);
527         }
528     }
529 
530     /**
531      * @dev Getter for the amount of shares held by an account.
532      */
533     function shares(address account) public view returns (uint256) {
534         return _shares[account];
535     }
536 
537     /**
538      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
539      * total shares and their previous withdrawals.
540      */
541     function release(address payable account) public virtual {
542         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
543 
544         uint256 totalReceived = address(this).balance + _totalReleased;
545         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
546 
547         require(payment != 0, "PaymentSplitter: account is not due payment");
548 
549         _released[account] = _released[account] + payment;
550         _totalReleased = _totalReleased + payment;
551 
552         Address.sendValue(account, payment);
553         emit PaymentReleased(account, payment);
554     }
555 
556     /**
557      * @dev Add a new payee to the contract.
558      * @param account The address of the payee to add.
559      * @param shares_ The number of shares owned by the payee.
560      */
561     function _addPayee(address account, uint256 shares_) internal virtual  {
562 
563         //  a certain percentage of shares will be given to the first 1000 who mint nfts , that is why  we will add shares to the first via the purchase function 
564         require(account != address(0), "PaymentSplitter: account is the zero address");
565         require(shares_ > 0, "PaymentSplitter: shares are 0");
566         // if _shares of the account is already initialized either by the initial constructor OR minting a nft added add the number of shares based on the amount of nfts minted
567         
568         if( _shares[account] > 0) {
569 
570             _shares[account] = _shares[account] +  shares_ ;
571              _totalShares = _totalShares + shares_;
572 
573              emit PayeeAdded(account, shares_);
574         }   
575 
576         // if not a new payee will be added
577         else {
578             
579           _payees.push(account);
580           _shares[account]  = shares_;
581           _totalShares = _totalShares + shares_;
582           emit PayeeAdded(account, shares_);
583         }
584         
585         
586        
587         
588     } 
589 }
590 // File: @openzeppelin/contracts/security/Pausable.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
594 
595 pragma solidity 0.8.7;
596 
597 
598 /**
599  * @dev Contract module which allows children to implement an emergency stop
600  * mechanism that can be triggered by an authorized account.
601  *
602  * This module is used through inheritance. It will make available the
603  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
604  * the functions of your contract. Note that they will not be pausable by
605  * simply including this module, only once the modifiers are put in place.
606  */
607 abstract contract Pausable is Context {
608     /**
609      * @dev Emitted when the pause is triggered by `account`.
610      */
611     event Paused(address account);
612 
613     /**
614      * @dev Emitted when the pause is lifted by `account`.
615      */
616     event Unpaused(address account);
617 
618     bool private _paused;
619 
620     /**
621      * @dev Initializes the contract in unpaused state.
622      */
623     constructor() {
624         _paused = true;
625     }
626 
627     /**
628      * @dev Returns true if the contract is paused, and false otherwise.
629      */
630     function paused() public view virtual returns (bool) {
631         return _paused;
632     }
633 
634     /**
635      * @dev Modifier to make a function callable only when the contract is not paused.
636      *
637      * Requirements:
638      *
639      * - The contract must not be paused.
640      */
641     modifier whenNotPaused() {
642         require(!paused(), "Pausable: paused");
643         _;
644     }
645 
646     /**
647      * @dev Modifier to make a function callable only when the contract is paused.
648      *
649      * Requirements:
650      *
651      * - The contract must be paused.
652      */
653     modifier whenPaused() {
654         require(paused(), "Pausable: not paused");
655         _;
656     }
657 
658     /**
659      * @dev Triggers stopped state.
660      *
661      * Requirements:
662      *
663      * - The contract must not be paused.
664      */
665     function _pause() internal virtual whenNotPaused {
666         _paused = true;
667         emit Paused(_msgSender());
668     }
669 
670     /**
671      * @dev Returns to normal state.
672      *
673      * Requirements:
674      *
675      * - The contract must be paused.
676      */
677     function _unpause() internal virtual whenPaused {
678         _paused = false;
679         
680         emit Unpaused(_msgSender());
681     }
682 }
683 
684 // File: @openzeppelin/contracts/access/Ownable.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
688 
689 pragma solidity 0.8.7;
690 
691 
692 /**
693  * @dev Contract module which provides a basic access control mechanism, where
694  * there is an account (an owner) that can be granted exclusive access to
695  * specific functions.
696  *
697  * By default, the owner account will be the one that deploys the contract. This
698  * can later be changed with {transferOwnership}.
699  *
700  * This module is used through inheritance. It will make available the modifier
701  * `onlyOwner`, which can be applied to your functions to restrict their use to
702  * the owner.
703  */
704 abstract contract Ownable is Context {
705     address private _owner;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor() {
713         _transferOwnership(_msgSender());
714     }
715 
716     /**
717      * @dev Returns the address of the current owner.
718      */
719     function owner() public view virtual returns (address) {
720         return _owner;
721     }
722 
723     /**
724      * @dev Throws if called by any account other than the owner.
725      */
726     modifier onlyOwner() {
727         require(owner() == _msgSender(), "Ownable: caller is not the owner");
728         _;
729     }
730 
731     /**
732      * @dev Leaves the contract without owner. It will not be possible to call
733      * `onlyOwner` functions anymore. Can only be called by the current owner.
734      *
735      * NOTE: Renouncing ownership will leave the contract without an owner,
736      * thereby removing any functionality that is only available to the owner.
737      */
738     function renounceOwnership() public virtual onlyOwner {
739         _transferOwnership(address(0));
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Can only be called by the current owner.
745      */
746     function transferOwnership(address newOwner) public virtual onlyOwner {
747         require(newOwner != address(0), "Ownable: new owner is the zero address");
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Internal function without access restriction.
754      */
755     function _transferOwnership(address newOwner) internal virtual {
756         address oldOwner = _owner;
757         _owner = newOwner;
758         emit OwnershipTransferred(oldOwner, newOwner);
759     }
760 }
761 
762 // File: @openzeppelin/contracts/utils/Strings.sol
763 
764 
765 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
766 
767 pragma solidity 0.8.7;
768 
769 /**
770  * @dev String operations.
771  */
772 library Strings {
773     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
774 
775     /**
776      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
777      */
778     function toString(uint256 value) internal pure returns (string memory) {
779         // Inspired by OraclizeAPI's implementation - MIT licence
780         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
781 
782         if (value == 0) {
783             return "0";
784         }
785         uint256 temp = value;
786         uint256 digits;
787         while (temp != 0) {
788             digits++;
789             temp /= 10;
790         }
791         bytes memory buffer = new bytes(digits);
792         while (value != 0) {
793             digits -= 1;
794             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
795             value /= 10;
796         }
797         return string(buffer);
798     }
799 
800     /**
801      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
802      */
803     function toHexString(uint256 value) internal pure returns (string memory) {
804         if (value == 0) {
805             return "0x00";
806         }
807         uint256 temp = value;
808         uint256 length = 0;
809         while (temp != 0) {
810             length++;
811             temp >>= 8;
812         }
813         return toHexString(value, length);
814     }
815 
816     /**
817      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
818      */
819     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
820         bytes memory buffer = new bytes(2 * length + 2);
821         buffer[0] = "0";
822         buffer[1] = "x";
823         for (uint256 i = 2 * length + 1; i > 1; --i) {
824             buffer[i] = _HEX_SYMBOLS[value & 0xf];
825             value >>= 4;
826         }
827         require(value == 0, "Strings: hex length insufficient");
828         return string(buffer);
829     }
830 }
831 
832 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
833 
834 
835 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
836 
837 pragma solidity 0.8.7;
838 
839 /**
840  * @dev These functions deal with verification of Merkle Trees proofs.
841  *
842  * The proofs can be generated using the JavaScript library
843  * https://github.com/miguelmota/merkletreejs[merkletreejs].
844  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
845  *
846  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
847  */
848 library MerkleProof {
849     /**
850      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
851      * defined by `root`. For this, a `proof` must be provided, containing
852      * sibling hashes on the branch from the leaf to the root of the tree. Each
853      * pair of leaves and each pair of pre-images are assumed to be sorted.
854      */
855     function verify(
856         bytes32[] memory proof,
857         bytes32 root,
858         bytes32 leaf
859     ) internal pure returns (bool) {
860         return processProof(proof, leaf) == root;
861     }
862 
863     /**
864      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
865      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
866      * hash matches the root of the tree. When processing the proof, the pairs
867      * of leafs & pre-images are assumed to be sorted.
868      *
869      * _Available since v4.4._
870      */
871     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
872         bytes32 computedHash = leaf;
873         for (uint256 i = 0; i < proof.length; i++) {
874             bytes32 proofElement = proof[i];
875             if (computedHash <= proofElement) {
876                 // Hash(current computed hash + current element of the proof)
877                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
878             } else {
879                 // Hash(current element of the proof + current computed hash)
880                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
881             }
882         }
883         return computedHash;
884     }
885 }
886 
887 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
891 
892 pragma solidity 0.8.7;
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
919 
920 pragma solidity 0.8.7;
921 
922 
923 /**
924  * @dev Implementation of the {IERC165} interface.
925  *
926  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
927  * for the additional interface id that will be supported. For example:
928  *
929  * ```solidity
930  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
931  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
932  * }
933  * ```
934  *
935  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
936  */
937 abstract contract ERC165 is IERC165 {
938     /**
939      * @dev See {IERC165-supportsInterface}.
940      */
941     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
942         return interfaceId == type(IERC165).interfaceId;
943     }
944 }
945 
946 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
950 
951 pragma solidity 0.8.7;
952 
953 
954 /**
955  * @dev _Available since v3.1._
956  */
957 interface IERC1155Receiver is IERC165 {
958     /**
959         @dev Handles the receipt of a single ERC1155 token type. This function is
960         called at the end of a `safeTransferFrom` after the balance has been updated.
961         To accept the transfer, this must return
962         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
963         (i.e. 0xf23a6e61, or its own function selector).
964         @param operator The address which initiated the transfer (i.e. msg.sender)
965         @param from The address which previously owned the token
966         @param id The ID of the token being transferred
967         @param value The amount of tokens being transferred
968         @param data Additional data with no specified format
969         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
970     */
971     function onERC1155Received(
972         address operator,
973         address from,
974         uint256 id,
975         uint256 value,
976         bytes calldata data
977     ) external returns (bytes4);
978 
979     /**
980         @dev Handles the receipt of a multiple ERC1155 token types. This function
981         is called at the end of a `safeBatchTransferFrom` after the balances have
982         been updated. To accept the transfer(s), this must return
983         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
984         (i.e. 0xbc197c81, or its own function selector).
985         @param operator The address which initiated the batch transfer (i.e. msg.sender)
986         @param from The address which previously owned the token
987         @param ids An array containing ids of each token being transferred (order and length must match values array)
988         @param values An array containing amounts of each token being transferred (order and length must match ids array)
989         @param data Additional data with no specified format
990         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
991     */
992     function onERC1155BatchReceived(
993         address operator,
994         address from,
995         uint256[] calldata ids,
996         uint256[] calldata values,
997         bytes calldata data
998     ) external returns (bytes4);
999 }
1000 
1001 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1002 
1003 
1004 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1005 
1006 pragma solidity 0.8.7;
1007 
1008 
1009 /**
1010  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1011  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1012  *
1013  * _Available since v3.1._
1014  */
1015 interface IERC1155 is IERC165 {
1016     /**
1017      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1018      */
1019     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1020 
1021     /**
1022      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1023      * transfers.
1024      */
1025     event TransferBatch(
1026         address indexed operator,
1027         address indexed from,
1028         address indexed to,
1029         uint256[] ids,
1030         uint256[] values
1031     );
1032 
1033     /**
1034      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1035      * `approved`.
1036      */
1037     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1038 
1039     /**
1040      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1041      *
1042      * If an {URI} event was emitted for `id`, the standard
1043      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1044      * returned by {IERC1155MetadataURI-uri}.
1045      */
1046     event URI(string value, uint256 indexed id);
1047 
1048     /**
1049      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1050      *
1051      * Requirements:
1052      *
1053      * - `account` cannot be the zero address.
1054      */
1055     function balanceOf(address account, uint256 id) external view returns (uint256);
1056 
1057     /**
1058      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1059      *
1060      * Requirements:
1061      *
1062      * - `accounts` and `ids` must have the same length.
1063      */
1064     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1065         external
1066         view
1067         returns (uint256[] memory);
1068 
1069     /**
1070      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1071      *
1072      * Emits an {ApprovalForAll} event.
1073      *
1074      * Requirements:
1075      *
1076      * - `operator` cannot be the caller.
1077      */
1078     function setApprovalForAll(address operator, bool approved) external;
1079 
1080     /**
1081      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1082      *
1083      * See {setApprovalForAll}.
1084      */
1085     function isApprovedForAll(address account, address operator) external view returns (bool);
1086 
1087     /**
1088      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1089      *
1090      * Emits a {TransferSingle} event.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1096      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1097      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1098      * acceptance magic value.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 id,
1104         uint256 amount,
1105         bytes calldata data
1106     ) external;
1107 
1108     /**
1109      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1110      *
1111      * Emits a {TransferBatch} event.
1112      *
1113      * Requirements:
1114      *
1115      * - `ids` and `amounts` must have the same length.
1116      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1117      * acceptance magic value.
1118      */
1119     function safeBatchTransferFrom(
1120         address from,
1121         address to,
1122         uint256[] calldata ids,
1123         uint256[] calldata amounts,
1124         bytes calldata data
1125     ) external;
1126 }
1127 
1128 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1129 
1130 
1131 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1132 
1133 pragma solidity 0.8.7;
1134 
1135 
1136 /**
1137  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1138  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1139  *
1140  * _Available since v3.1._
1141  */
1142 interface IERC1155MetadataURI is IERC1155 {
1143     /**
1144      * @dev Returns the URI for token type `id`.
1145      *
1146      * If the `\{id\}` substring is present in the URI, it must be replaced by
1147      * clients with the actual token type ID.
1148      */
1149     function uri(uint256 id) external view returns (string memory);
1150 }
1151 
1152 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1153 
1154 
1155 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1156 
1157 pragma solidity 0.8.7;
1158 
1159 
1160 
1161 
1162 
1163 
1164 
1165 /**
1166  * @dev Implementation of the basic standard multi-token.
1167  * See https://eips.ethereum.org/EIPS/eip-1155
1168  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1169  *
1170  * _Available since v3.1._
1171  */
1172 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1173     using Address for address;
1174 
1175     // Mapping from token ID to account balances
1176     mapping(uint256 => mapping(address => uint256)) private _balances;
1177 
1178     // Mapping from account to operator approvals
1179     mapping(address => mapping(address => bool)) private _operatorApprovals;
1180 
1181     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1182     string private _uri;
1183 
1184     /**
1185      * @dev See {_setURI}.
1186      */
1187     constructor(string memory uri_) {
1188         _setURI(uri_);
1189     }
1190 
1191     /**
1192      * @dev See {IERC165-supportsInterface}.
1193      */
1194     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1195         return
1196             interfaceId == type(IERC1155).interfaceId ||
1197             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1198             super.supportsInterface(interfaceId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC1155MetadataURI-uri}.
1203      *
1204      * This implementation returns the same URI for *all* token types. It relies
1205      * on the token type ID substitution mechanism
1206      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1207      *
1208      * Clients calling this function must replace the `\{id\}` substring with the
1209      * actual token type ID.
1210      */
1211     function uri(uint256) public view virtual override returns (string memory) {
1212         return _uri;
1213     }
1214 
1215     /**
1216      * @dev See {IERC1155-balanceOf}.
1217      *
1218      * Requirements:
1219      *
1220      * - `account` cannot be the zero address.
1221      */
1222     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1223         require(account != address(0), "ERC1155: balance query for the zero address");
1224         return _balances[id][account];
1225     }
1226 
1227     /**
1228      * @dev See {IERC1155-balanceOfBatch}.
1229      *
1230      * Requirements:
1231      *
1232      * - `accounts` and `ids` must have the same length.
1233      */
1234     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1235         public
1236         view
1237         virtual
1238         override
1239         returns (uint256[] memory)
1240     {
1241         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1242 
1243         uint256[] memory batchBalances = new uint256[](accounts.length);
1244 
1245         for (uint256 i = 0; i < accounts.length; ++i) {
1246             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1247         }
1248 
1249         return batchBalances;
1250     }
1251 
1252     /**
1253      * @dev See {IERC1155-setApprovalForAll}.
1254      */
1255     function setApprovalForAll(address operator, bool approved) public virtual override {
1256         _setApprovalForAll(_msgSender(), operator, approved);
1257     }
1258 
1259     /**
1260      * @dev See {IERC1155-isApprovedForAll}.
1261      */
1262     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1263         return _operatorApprovals[account][operator];
1264     }
1265 
1266     /**
1267      * @dev See {IERC1155-safeTransferFrom}.
1268      */
1269     function safeTransferFrom(
1270         address from,
1271         address to,
1272         uint256 id,
1273         uint256 amount,
1274         bytes memory data
1275     ) public virtual override {
1276         require(
1277             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1278             "ERC1155: caller is not owner nor approved"
1279         );
1280         _safeTransferFrom(from, to, id, amount, data);
1281     }
1282 
1283     /**
1284      * @dev See {IERC1155-safeBatchTransferFrom}.
1285      */
1286     function safeBatchTransferFrom(
1287         address from,
1288         address to,
1289         uint256[] memory ids,
1290         uint256[] memory amounts,
1291         bytes memory data
1292     ) public virtual override {
1293         require(
1294             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1295             "ERC1155: transfer caller is not owner nor approved"
1296         );
1297         _safeBatchTransferFrom(from, to, ids, amounts, data);
1298     }
1299 
1300     /**
1301      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1302      *
1303      * Emits a {TransferSingle} event.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1309      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1310      * acceptance magic value.
1311      */
1312     function _safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 id,
1316         uint256 amount,
1317         bytes memory data
1318     ) internal virtual {
1319         require(to != address(0), "ERC1155: transfer to the zero address");
1320 
1321         address operator = _msgSender();
1322 
1323         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1324 
1325         uint256 fromBalance = _balances[id][from];
1326         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1327         unchecked {
1328             _balances[id][from] = fromBalance - amount;
1329         }
1330         _balances[id][to] += amount;
1331 
1332         emit TransferSingle(operator, from, to, id, amount);
1333 
1334         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1335     }
1336 
1337     /**
1338      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1339      *
1340      * Emits a {TransferBatch} event.
1341      *
1342      * Requirements:
1343      *
1344      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1345      * acceptance magic value.
1346      */
1347     function _safeBatchTransferFrom(
1348         address from,
1349         address to,
1350         uint256[] memory ids,
1351         uint256[] memory amounts,
1352         bytes memory data
1353     ) internal virtual {
1354         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1355         require(to != address(0), "ERC1155: transfer to the zero address");
1356 
1357         address operator = _msgSender();
1358 
1359         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1360 
1361         for (uint256 i = 0; i < ids.length; ++i) {
1362             uint256 id = ids[i];
1363             uint256 amount = amounts[i];
1364 
1365             uint256 fromBalance = _balances[id][from];
1366             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1367             unchecked {
1368                 _balances[id][from] = fromBalance - amount;
1369             }
1370             _balances[id][to] += amount;
1371         }
1372 
1373         emit TransferBatch(operator, from, to, ids, amounts);
1374 
1375         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1376     }
1377 
1378     /**
1379      * @dev Sets a new URI for all token types, by relying on the token type ID
1380      * substitution mechanism
1381      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1382      *
1383      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1384      * URI or any of the amounts in the JSON file at said URI will be replaced by
1385      * clients with the token type ID.
1386      *
1387      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1388      * interpreted by clients as
1389      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1390      * for token type ID 0x4cce0.
1391      *
1392      * See {uri}.
1393      *
1394      * Because these URIs cannot be meaningfully represented by the {URI} event,
1395      * this function emits no events.
1396      */
1397     function _setURI(string memory newuri) internal virtual {
1398         _uri = newuri;
1399     }
1400 
1401     /**
1402      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1403      *
1404      * Emits a {TransferSingle} event.
1405      *
1406      * Requirements:
1407      *
1408      * - `to` cannot be the zero address.
1409      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1410      * acceptance magic value.
1411      */
1412     function _mint(
1413         address to,
1414         uint256 id,
1415         uint256 amount,
1416         bytes memory data
1417     ) internal virtual {
1418         require(to != address(0), "ERC1155: mint to the zero address");
1419 
1420         address operator = _msgSender();
1421 
1422         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1423 
1424         _balances[id][to] += amount;
1425         emit TransferSingle(operator, address(0), to, id, amount);
1426 
1427         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1428     }
1429 
1430     /**
1431      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1432      *
1433      * Requirements:
1434      *
1435      * - `ids` and `amounts` must have the same length.
1436      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1437      * acceptance magic value.
1438      */
1439      // changed here each value to one for unique nfts.
1440     function _mintBatch(
1441         address to,
1442         uint256[] memory ids,
1443         uint256[] memory amounts,
1444         bytes memory data
1445     ) internal virtual {
1446         require(to != address(0), "ERC1155: mint to the zero address");
1447         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1448 
1449         address operator = _msgSender();
1450 
1451         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1452 
1453         for (uint256 i = 0; i < ids.length; i++) {
1454             _balances[ids[i]][to] += amounts[i];
1455         }
1456 
1457         emit TransferBatch(operator, address(0), to, ids, amounts);
1458 
1459         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1460     }
1461 
1462     /**
1463      * @dev Destroys `amount` tokens of token type `id` from `from`
1464      *
1465      * Requirements:
1466      *
1467      * - `from` cannot be the zero address.
1468      * - `from` must have at least `amount` tokens of token type `id`.
1469      */
1470     function _burn(
1471         address from,
1472         uint256 id,
1473         uint256 amount
1474     ) internal virtual {
1475         require(from != address(0), "ERC1155: burn from the zero address");
1476 
1477         address operator = _msgSender();
1478 
1479         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1480 
1481         uint256 fromBalance = _balances[id][from];
1482         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1483         unchecked {
1484             _balances[id][from] = fromBalance - amount;
1485         }
1486 
1487         emit TransferSingle(operator, from, address(0), id, amount);
1488     }
1489 
1490     /**
1491      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1492      *
1493      * Requirements:
1494      *
1495      * - `ids` and `amounts` must have the same length.
1496      */
1497     function _burnBatch(
1498         address from,
1499         uint256[] memory ids,
1500         uint256[] memory amounts
1501     ) internal virtual {
1502         require(from != address(0), "ERC1155: burn from the zero address");
1503         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1504 
1505         address operator = _msgSender();
1506 
1507         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1508 
1509         for (uint256 i = 0; i < ids.length; i++) {
1510             uint256 id = ids[i];
1511             uint256 amount = amounts[i];
1512 
1513             uint256 fromBalance = _balances[id][from];
1514             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1515             unchecked {
1516                 _balances[id][from] = fromBalance - amount;
1517             }
1518         }
1519 
1520         emit TransferBatch(operator, from, address(0), ids, amounts);
1521     }
1522 
1523     /**
1524      * @dev Approve `operator` to operate on all of `owner` tokens
1525      *
1526      * Emits a {ApprovalForAll} event.
1527      */
1528     function _setApprovalForAll(
1529         address owner,
1530         address operator,
1531         bool approved
1532     ) internal virtual {
1533         require(owner != operator, "ERC1155: setting approval status for self");
1534         _operatorApprovals[owner][operator] = approved;
1535         emit ApprovalForAll(owner, operator, approved);
1536     }
1537 
1538     /**
1539      * @dev Hook that is called before any token transfer. This includes minting
1540      * and burning, as well as batched variants.
1541      *
1542      * The same hook is called on both single and batched variants. For single
1543      * transfers, the length of the `id` and `amount` arrays will be 1.
1544      *
1545      * Calling conditions (for each `id` and `amount` pair):
1546      *
1547      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1548      * of token type `id` will be  transferred to `to`.
1549      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1550      * for `to`.
1551      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1552      * will be burned.
1553      * - `from` and `to` are never both zero.
1554      * - `ids` and `amounts` have the same, non-zero length.
1555      *
1556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1557      */
1558     function _beforeTokenTransfer(
1559         address operator,
1560         address from,
1561         address to,
1562         uint256[] memory ids,
1563         uint256[] memory amounts,
1564         bytes memory data
1565     ) internal virtual {}
1566 
1567     function _doSafeTransferAcceptanceCheck(
1568         address operator,
1569         address from,
1570         address to,
1571         uint256 id,
1572         uint256 amount,
1573         bytes memory data
1574     ) private {
1575         if (to.isContract()) {
1576             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1577                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1578                     revert("ERC1155: ERC1155Receiver rejected tokens");
1579                 }
1580             } catch Error(string memory reason) {
1581                 revert(reason);
1582             } catch {
1583                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1584             }
1585         }
1586     }
1587 
1588     function _doSafeBatchTransferAcceptanceCheck(
1589         address operator,
1590         address from,
1591         address to,
1592         uint256[] memory ids,
1593         uint256[] memory amounts,
1594         bytes memory data
1595     ) private {
1596         if (to.isContract()) {
1597             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1598                 bytes4 response
1599             ) {
1600                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1601                     revert("ERC1155: ERC1155Receiver rejected tokens");
1602                 }
1603             } catch Error(string memory reason) {
1604                 revert(reason);
1605             } catch {
1606                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1607             }
1608         }
1609     }
1610 
1611     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1612         uint256[] memory array = new uint256[](1);
1613         array[0] = element;
1614 
1615         return array;
1616     }
1617 }
1618 
1619 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1620 
1621 
1622 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1623 
1624 pragma solidity 0.8.7;
1625 
1626 
1627 
1628 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1629 
1630 
1631 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1632 
1633 pragma solidity 0.8.7;
1634 
1635 
1636 /**
1637  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1638  * own tokens and those that they have been approved to use.
1639  *
1640  * _Available since v3.1._
1641  */
1642 abstract contract ERC1155Burnable is ERC1155 {
1643     function burn(
1644         address account,
1645         uint256 id,
1646         uint256 value
1647     ) public virtual {
1648         require(
1649             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1650             "ERC1155: caller is not owner nor approved"
1651         );
1652 
1653         _burn(account, id, value);
1654     }
1655 
1656     function burnBatch(
1657         address account,
1658         uint256[] memory ids,
1659         uint256[] memory values
1660     ) public virtual {
1661         require(
1662             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1663             "ERC1155: caller is not owner nor approved"
1664         );
1665 
1666         _burnBatch(account, ids, values);
1667     }
1668 }
1669 
1670 // File: contracts/Akylles/AbstractERC1155Factory.sol
1671 
1672 
1673 
1674 pragma solidity 0.8.7;
1675 
1676 
1677 
1678 
1679 
1680 abstract contract AbstractERC1155Factory is Pausable,  ERC1155Burnable, Ownable {
1681 
1682     string name_;
1683     string symbol_;   
1684     string _obscurumuri;
1685     bool public  frozen   = false;
1686     string extension;
1687 
1688     
1689     function pause() external onlyOwner {
1690         _pause();
1691     }
1692 
1693     function unpause() external onlyOwner {
1694         _unpause();
1695     }    
1696 
1697     function setURI(string memory baseURI) external onlyOwner {
1698         require(frozen == false);
1699         _setURI(baseURI);
1700     }    
1701 
1702     function name() public view returns (string memory) {
1703         return name_;
1704     }
1705 
1706     function symbol() public view returns (string memory) {
1707         return symbol_;
1708     }          
1709 
1710   
1711 }
1712 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1713 
1714 
1715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1716 
1717 pragma solidity 0.8.7;
1718 
1719 
1720 /**
1721  * @dev Required interface of an ERC721 compliant contract.
1722  */
1723 interface IERC721 is IERC165 {
1724     /**
1725      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1726      */
1727     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1728 
1729     /**
1730      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1731      */
1732     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1733 
1734     /**
1735      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1736      */
1737     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1738 
1739     /**
1740      * @dev Returns the number of tokens in ``owner``'s account.
1741      */
1742     function balanceOf(address owner) external view returns (uint256 balance);
1743 
1744     /** 
1745      * @dev Returns the owner of the `tokenId` token.
1746      *
1747      * Requirements:
1748      *
1749      * - `tokenId` must exist.
1750      */
1751     function ownerOf(uint256 tokenId) external view returns (address owner);
1752 
1753     /**
1754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1756      *
1757      * Requirements:
1758      *
1759      * - `from` cannot be the zero address.
1760      * - `to` cannot be the zero address.
1761      * - `tokenId` token must exist and be owned by `from`.
1762      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1764      *
1765      * Emits a {Transfer} event.
1766      */
1767     function safeTransferFrom(
1768         address from,
1769         address to,
1770         uint256 tokenId
1771     ) external;
1772 
1773     /**
1774      * @dev Transfers `tokenId` token from `from` to `to`.
1775      *
1776      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1777      *
1778      * Requirements:
1779      *
1780      * - `from` cannot be the zero address.
1781      * - `to` cannot be the zero address.
1782      * - `tokenId` token must be owned by `from`.
1783      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1784      *
1785      * Emits a {Transfer} event.
1786      */
1787     function transferFrom(
1788         address from,
1789         address to,
1790         uint256 tokenId
1791     ) external;
1792 
1793     /**
1794      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1795      * The approval is cleared when the token is transferred.
1796      *
1797      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1798      *
1799      * Requirements:
1800      *
1801      * - The caller must own the token or be an approved operator.
1802      * - `tokenId` must exist.
1803      *
1804      * Emits an {Approval} event.
1805      */
1806     function approve(address to, uint256 tokenId) external;
1807 
1808     /**
1809      * @dev Returns the account approved for `tokenId` token.
1810      *
1811      * Requirements:
1812      *
1813      * - `tokenId` must exist.
1814      */
1815     function getApproved(uint256 tokenId) external view returns (address operator);
1816 
1817     /**
1818      * @dev Approve or remove `operator` as an operator for the caller.
1819      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1820      *
1821      * Requirements:
1822      *
1823      * - The `operator` cannot be the caller.
1824      *
1825      * Emits an {ApprovalForAll} event.
1826      */
1827     function setApprovalForAll(address operator, bool _approved) external;
1828 
1829     /**
1830      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1831      *
1832      * See {setApprovalForAll}
1833      */
1834     function isApprovedForAll(address owner, address operator) external view returns (bool);
1835 
1836     /**
1837      * @dev Safely transfers `tokenId` token from `from` to `to`.
1838      *
1839      * Requirements:
1840      *
1841      * - `from` cannot be the zero address.
1842      * - `to` cannot be the zero address.
1843      * - `tokenId` token must exist and be owned by `from`.
1844      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1846      *
1847      * Emits a {Transfer} event.
1848      */
1849     function safeTransferFrom(
1850         address from,
1851         address to,
1852         uint256 tokenId,
1853         bytes calldata data
1854     ) external;
1855 }
1856 
1857 // File: @openzeppelin/contracts/utils/Counters.sol
1858 
1859 
1860 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1861 
1862 pragma solidity 0.8.7;
1863 
1864 /**
1865  * @title Counters
1866  * @author Matt Condon (@shrugs)
1867  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1868  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1869  *
1870  * Include with `using Counters for Counters.Counter;`
1871  */
1872 library Counters {
1873     struct Counter {
1874         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1875         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1876         // this feature: see https://github.com/ethereum/solidity/issues/4637
1877         uint256 _value; // default: 0
1878     }
1879 
1880     function current(Counter storage counter) internal view returns (uint256) {
1881         return counter._value;
1882     }
1883 
1884     function increment(Counter storage counter) internal {
1885         unchecked {
1886             counter._value += 1;
1887         }
1888     }
1889 
1890     function decrement(Counter storage counter) internal {
1891         uint256 value = counter._value;
1892         require(value > 0, "Counter: decrement overflow");
1893         unchecked {
1894             counter._value = value - 1;
1895         }
1896     }
1897 
1898     function reset(Counter storage counter) internal {
1899         counter._value = 0;
1900     }
1901 }
1902 
1903 // File: contracts/Akylles/Akylles.sol
1904 
1905 
1906 
1907 
1908 
1909 
1910 //  A E T H E R  
1911 
1912 
1913 
1914 
1915 pragma solidity 0.8.7;
1916 
1917 
1918 
1919 
1920 
1921 
1922 
1923 
1924 
1925 contract Yellownauts is AbstractERC1155Factory, PaymentSplitter  {
1926 
1927     using SafeMath for uint;
1928     uint256 constant public MAX_SUPPLY = 2026;
1929     uint256 maxPerTx = 3;
1930     uint256 maxperaddress = 3;
1931     uint256 public mintPrice = 50000000000000000;
1932     uint256 public Idx = 0;
1933     bool public presaleActivated = false;
1934     bool public  revealed = false;
1935     bytes32 public merkleRoot;
1936     string public _uri;
1937     mapping(address => uint256) public purchaseTxs;
1938     
1939     event Purchased(uint256 indexed index, address indexed account, uint256 amount);
1940    
1941     constructor(
1942         string memory _name,
1943         string memory _symbol,
1944         string memory obscurumuri,
1945         string memory _extension,
1946         bytes32 _merkleRoot,
1947         address[] memory payees,
1948         uint256[] memory shares_
1949     ) ERC1155(_uri)  PaymentSplitter(payees, shares_) {
1950         name_ = _name;
1951         symbol_ = _symbol;
1952         _obscurumuri = obscurumuri;
1953         merkleRoot = _merkleRoot;
1954         extension = _extension;
1955         
1956     }
1957 
1958 
1959    
1960 
1961 // unpause and remove all restrictions public sale ready   0.07 eth there is not max per address or max per transaction in the public sale
1962 function setPhase2() external  onlyOwner {
1963         // after unpausing we will set no limits to transactions
1964         mintPrice = 70000000000000000;
1965        
1966         _unpause();
1967      
1968      
1969      
1970      }
1971      
1972      
1973 
1974 
1975 function ownerOf(uint256 tokenId) external view returns (bool) {
1976     return balanceOf(msg.sender, tokenId) != 0;
1977 }
1978 
1979    /** set merkle root for efficient   whitelisted addresses verification 
1980             *
1981             
1982             */
1983     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1984         merkleRoot = _merkleRoot;
1985     }
1986     
1987 
1988 
1989     function setPrice(uint256 _mintPrice) external onlyOwner {
1990         mintPrice = _mintPrice;
1991     }
1992     // locking metadata 4 life 
1993 
1994     function freezemeta() external onlyOwner {
1995 
1996         frozen = true;
1997     }
1998 
1999     /**
2000     * @notice edit sale restrictions
2001     *
2002     * @param _maxPerTx the new max amount of tokens allowed to buy in one tx
2003     
2004     */
2005     function editSaleRestrictions(uint8 _maxPerTx) external onlyOwner {
2006         maxPerTx = _maxPerTx;
2007         
2008     }
2009     function setPresale(bool _choice) external onlyOwner {
2010 
2011 
2012      presaleActivated = _choice;
2013 
2014                             }
2015 
2016 
2017 
2018 
2019 
2020     function reveal() external onlyOwner {
2021         revealed = true; 
2022    }
2023     
2024 
2025     /**
2026     early access sale purchase using merkle trees to verify that a address is whitelisted 
2027     */
2028     function whitelistPreSale(
2029         uint256 amount,
2030         bytes32[] calldata merkleProof
2031     ) external payable  {
2032         
2033 
2034         require( presaleActivated , "Early access: not available yet ");
2035         require(amount > 0 && amount <= maxPerTx, "Purchase: amount prohibited");
2036         require(purchaseTxs[msg.sender] + amount  <= maxperaddress); // require every address on the whitelist to mint a maximum of their address .
2037         bytes32 node = keccak256(abi.encodePacked(msg.sender));
2038         require(
2039             MerkleProof.verify(merkleProof, merkleRoot, node),
2040             "MerkleDistributor: Invalid proof."
2041         );
2042         
2043         
2044       if(amount > 1) {
2045           
2046            _bulkpurchase(amount);
2047        }
2048       else { 
2049           _purchase(amount);
2050           } 
2051     
2052        
2053     }
2054 
2055 
2056 
2057 
2058  
2059     function purchase(uint256 amount) external payable whenNotPaused {
2060         
2061        
2062         if(amount > 1) {
2063            
2064            
2065             
2066            _bulkpurchase(amount);
2067        }
2068       else { 
2069           
2070           _purchase(amount);
2071           } 
2072 
2073 
2074     }
2075 
2076     /**
2077     * @notice global purchase function 
2078     
2079     used in early access and public sale
2080     *
2081     * @param amount the amount of tokens to purchase
2082     */
2083 
2084 
2085     
2086     // during opening of the public sale theres no limit  for minting and owning tokens in transactions.
2087 
2088     function _purchase(uint256 amount ) private {
2089         
2090       
2091         require(amount > 0 , "amount cant be zero ");
2092         require(Idx + amount <= MAX_SUPPLY , "Purchase: Max supply of 2026 reached");
2093         require(msg.value == amount * mintPrice, "Purchase: Incorrect payment");
2094         Idx += 1;
2095         purchaseTxs[msg.sender] += 1;
2096         _mint(msg.sender,Idx, amount, "");
2097         emit Purchased(Idx, msg.sender, amount);
2098     }
2099 
2100 // this function is used to bulk purchase Unique nfts.
2101       function _bulkpurchase(uint256 amount ) private {
2102         require(Idx + amount <= MAX_SUPPLY, "Purchase: Max supply reached ");
2103         require(msg.value == amount * mintPrice, "Purchase: Incorrect payment XX");
2104         uint256[] memory ids = new uint256[](amount);
2105         uint256[] memory values = new uint256[](amount);
2106         Idx += amount; 
2107         uint256  iterator =  Idx;
2108 
2109         for(uint i = 0 ; i < amount; i++){
2110 
2111             ids[i] = iterator; // line up Unique NFTs ID in  a array.   
2112 
2113             iterator = iterator-1; 
2114 
2115             values[i] = 1; // for Unique Nfts  Supply of every ID MUST be one .1   to be injected in the _mintBatch function     
2116         }
2117         
2118          purchaseTxs[msg.sender] += amount;
2119         _mintBatch(msg.sender, ids,values, "");
2120         
2121          emit Purchased(Idx, msg.sender, amount);
2122         
2123         
2124     }
2125     // airdrop nft function for owner only to be able to  airdrop Unique nfts 
2126    function airdrop(address payable reciever, uint256 amount ) external onlyOwner() {
2127        
2128        require(Idx + amount <= MAX_SUPPLY, "Max supply of 2026 reached");
2129        require(amount >= 1, "nonzero err");
2130         
2131          if(amount == 1)  {
2132             Idx += 1;
2133            _mint(reciever, Idx, 1 , "");
2134 
2135        } 
2136        else {
2137            
2138         uint256[] memory ids = new uint256[](amount);
2139         uint256[] memory values = new uint256[](amount);
2140         Idx += amount; 
2141         uint256  iterator =  Idx;
2142 
2143         for(uint i = 0 ; i < amount; i++){
2144 
2145             ids[i] = iterator; // line up Unique NFTs ID in  a array.   
2146            
2147             iterator = iterator-1; 
2148 
2149             values[i] = 1; // for Unique Nfts  Supply of every ID MUST be one .1   to be injected in the _mintBatch function     
2150         }
2151         
2152        
2153         _mintBatch(reciever, ids,values, "");
2154        }
2155        
2156        
2157    }
2158     
2159    
2160     function release(address payable account) public override {
2161         require(msg.sender == account || msg.sender == owner(), "Release: no permission");
2162 
2163         super.release(account);
2164 
2165     }
2166 
2167     function sethiddenuri(string memory huri) external onlyOwner() {
2168         _obscurumuri = huri;
2169 
2170     }
2171     function uri(uint256 _id) public view override returns (string memory) {
2172                 require(_id <= Idx, "Id deos not exist " );
2173                 return revealed ? string(abi.encodePacked(super.uri(_id),Strings.toString(_id)  , extension)) : _obscurumuri ;
2174 
2175     }
2176 }