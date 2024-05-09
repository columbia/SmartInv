1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/math/SafeMath.sol
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
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         }
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         }
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a % b;
218         }
219     }
220 }
221 
222 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Strings.sol
223 
224 
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev String operations.
230  */
231 library Strings {
232     bytes16 private constant alphabet = "0123456789abcdef";
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
236      */
237     function toString(uint256 value) internal pure returns (string memory) {
238         // Inspired by OraclizeAPI's implementation - MIT licence
239         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
240 
241         if (value == 0) {
242             return "0";
243         }
244         uint256 temp = value;
245         uint256 digits;
246         while (temp != 0) {
247             digits++;
248             temp /= 10;
249         }
250         bytes memory buffer = new bytes(digits);
251         while (value != 0) {
252             digits -= 1;
253             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
254             value /= 10;
255         }
256         return string(buffer);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
261      */
262     function toHexString(uint256 value) internal pure returns (string memory) {
263         if (value == 0) {
264             return "0x00";
265         }
266         uint256 temp = value;
267         uint256 length = 0;
268         while (temp != 0) {
269             length++;
270             temp >>= 8;
271         }
272         return toHexString(value, length);
273     }
274 
275     /**
276      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
277      */
278     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
279         bytes memory buffer = new bytes(2 * length + 2);
280         buffer[0] = "0";
281         buffer[1] = "x";
282         for (uint256 i = 2 * length + 1; i > 1; --i) {
283             buffer[i] = alphabet[value & 0xf];
284             value >>= 4;
285         }
286         require(value == 0, "Strings: hex length insufficient");
287         return string(buffer);
288     }
289 
290 }
291 
292 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Context.sol
293 
294 
295 
296 pragma solidity ^0.8.0;
297 
298 /*
299  * @dev Provides information about the current execution context, including the
300  * sender of the transaction and its data. While these are generally available
301  * via msg.sender and msg.data, they should not be accessed in such a direct
302  * manner, since when dealing with meta-transactions the account sending and
303  * paying for execution may not be the actual sender (as far as an application
304  * is concerned).
305  *
306  * This contract is only required for intermediate, library-like contracts.
307  */
308 abstract contract Context {
309     function _msgSender() internal view virtual returns (address) {
310         return msg.sender;
311     }
312 
313     function _msgData() internal view virtual returns (bytes calldata) {
314         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
315         return msg.data;
316     }
317 }
318 
319 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/access/Ownable.sol
320 
321 
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Contract module which provides a basic access control mechanism, where
327  * there is an account (an owner) that can be granted exclusive access to
328  * specific functions.
329  *
330  * By default, the owner account will be the one that deploys the contract. This
331  * can later be changed with {transferOwnership}.
332  *
333  * This module is used through inheritance. It will make available the modifier
334  * `onlyOwner`, which can be applied to your functions to restrict their use to
335  * the owner.
336  */
337 abstract contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev Initializes the contract setting the deployer as the initial owner.
344      */
345     constructor () {
346         address msgSender = _msgSender();
347         _owner = msgSender;
348         emit OwnershipTransferred(address(0), msgSender);
349     }
350 
351     /**
352      * @dev Returns the address of the current owner.
353      */
354     function owner() public view virtual returns (address) {
355         return _owner;
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         require(owner() == _msgSender(), "Ownable: caller is not the owner");
363         _;
364     }
365 
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         emit OwnershipTransferred(_owner, address(0));
375         _owner = address(0);
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Address.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies on extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         uint256 size;
422         // solhint-disable-next-line no-inline-assembly
423         assembly { size := extcodesize(account) }
424         return size > 0;
425     }
426 
427     /**
428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
429      * `recipient`, forwarding all available gas and reverting on errors.
430      *
431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
433      * imposed by `transfer`, making them unable to receive funds via
434      * `transfer`. {sendValue} removes this limitation.
435      *
436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
437      *
438      * IMPORTANT: because control is transferred to `recipient`, care must be
439      * taken to not create reentrancy vulnerabilities. Consider using
440      * {ReentrancyGuard} or the
441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
442      */
443     function sendValue(address payable recipient, uint256 amount) internal {
444         require(address(this).balance >= amount, "Address: insufficient balance");
445 
446         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
447         (bool success, ) = recipient.call{ value: amount }("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain`call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470       return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
505         require(address(this).balance >= value, "Address: insufficient balance for call");
506         require(isContract(target), "Address: call to non-contract");
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = target.call{ value: value }(data);
510         return _verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
520         return functionStaticCall(target, data, "Address: low-level static call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         // solhint-disable-next-line avoid-low-level-calls
533         (bool success, bytes memory returndata) = target.staticcall(data);
534         return _verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
554         require(isContract(target), "Address: delegate call to non-contract");
555 
556         // solhint-disable-next-line avoid-low-level-calls
557         (bool success, bytes memory returndata) = target.delegatecall(data);
558         return _verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
562         if (success) {
563             return returndata;
564         } else {
565             // Look for revert reason and bubble it up if present
566             if (returndata.length > 0) {
567                 // The easiest way to bubble the revert reason is using memory via assembly
568 
569                 // solhint-disable-next-line no-inline-assembly
570                 assembly {
571                     let returndata_size := mload(returndata)
572                     revert(add(32, returndata), returndata_size)
573                 }
574             } else {
575                 revert(errorMessage);
576             }
577         }
578     }
579 }
580 
581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/finance/PaymentSplitter.sol
582 
583 
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 
590 /**
591  * @title PaymentSplitter
592  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
593  * that the Ether will be split in this way, since it is handled transparently by the contract.
594  *
595  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
596  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
597  * an amount proportional to the percentage of total shares they were assigned.
598  *
599  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
600  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
601  * function.
602  */
603 contract PaymentSplitter is Context {
604     event PayeeAdded(address account, uint256 shares);
605     event PaymentReleased(address to, uint256 amount);
606     event PaymentReceived(address from, uint256 amount);
607 
608     uint256 private _totalShares;
609     uint256 private _totalReleased;
610 
611     mapping(address => uint256) private _shares;
612     mapping(address => uint256) private _released;
613     address[] private _payees;
614 
615     /**
616      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
617      * the matching position in the `shares` array.
618      *
619      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
620      * duplicates in `payees`.
621      */
622     constructor (address[] memory payees, uint256[] memory shares_) payable {
623         // solhint-disable-next-line max-line-length
624         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
625         require(payees.length > 0, "PaymentSplitter: no payees");
626 
627         for (uint256 i = 0; i < payees.length; i++) {
628             _addPayee(payees[i], shares_[i]);
629         }
630     }
631 
632     /**
633      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
634      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
635      * reliability of the events, and not the actual splitting of Ether.
636      *
637      * To learn more about this see the Solidity documentation for
638      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
639      * functions].
640      */
641     receive () external payable virtual {
642         emit PaymentReceived(_msgSender(), msg.value);
643     }
644 
645     /**
646      * @dev Getter for the total shares held by payees.
647      */
648     function totalShares() public view returns (uint256) {
649         return _totalShares;
650     }
651 
652     /**
653      * @dev Getter for the total amount of Ether already released.
654      */
655     function totalReleased() public view returns (uint256) {
656         return _totalReleased;
657     }
658 
659     /**
660      * @dev Getter for the amount of shares held by an account.
661      */
662     function shares(address account) public view returns (uint256) {
663         return _shares[account];
664     }
665 
666     /**
667      * @dev Getter for the amount of Ether already released to a payee.
668      */
669     function released(address account) public view returns (uint256) {
670         return _released[account];
671     }
672 
673     /**
674      * @dev Getter for the address of the payee number `index`.
675      */
676     function payee(uint256 index) public view returns (address) {
677         return _payees[index];
678     }
679 
680     /**
681      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
682      * total shares and their previous withdrawals.
683      */
684     function release(address payable account) public virtual {
685         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
686 
687         uint256 totalReceived = address(this).balance + _totalReleased;
688         uint256 payment = totalReceived * _shares[account] / _totalShares - _released[account];
689 
690         require(payment != 0, "PaymentSplitter: account is not due payment");
691 
692         _released[account] = _released[account] + payment;
693         _totalReleased = _totalReleased + payment;
694 
695         Address.sendValue(account, payment);
696         emit PaymentReleased(account, payment);
697     }
698 
699     /**
700      * @dev Add a new payee to the contract.
701      * @param account The address of the payee to add.
702      * @param shares_ The number of shares owned by the payee.
703      */
704     function _addPayee(address account, uint256 shares_) private {
705         require(account != address(0), "PaymentSplitter: account is the zero address");
706         require(shares_ > 0, "PaymentSplitter: shares are 0");
707         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
708 
709         _payees.push(account);
710         _shares[account] = shares_;
711         _totalShares = _totalShares + shares_;
712         emit PayeeAdded(account, shares_);
713     }
714 }
715 
716 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/IERC721Receiver.sol
717 
718 
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @title ERC721 token receiver interface
724  * @dev Interface for any contract that wants to support safeTransfers
725  * from ERC721 asset contracts.
726  */
727 interface IERC721Receiver {
728     /**
729      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
730      * by `operator` from `from`, this function is called.
731      *
732      * It must return its Solidity selector to confirm the token transfer.
733      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
734      *
735      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
736      */
737     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
738 }
739 
740 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/introspection/IERC165.sol
741 
742 
743 
744 pragma solidity ^0.8.0;
745 
746 /**
747  * @dev Interface of the ERC165 standard, as defined in the
748  * https://eips.ethereum.org/EIPS/eip-165[EIP].
749  *
750  * Implementers can declare support of contract interfaces, which can then be
751  * queried by others ({ERC165Checker}).
752  *
753  * For an implementation, see {ERC165}.
754  */
755 interface IERC165 {
756     /**
757      * @dev Returns true if this contract implements the interface defined by
758      * `interfaceId`. See the corresponding
759      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
760      * to learn more about how these ids are created.
761      *
762      * This function call must use less than 30 000 gas.
763      */
764     function supportsInterface(bytes4 interfaceId) external view returns (bool);
765 }
766 
767 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/introspection/ERC165.sol
768 
769 
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @dev Implementation of the {IERC165} interface.
776  *
777  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
778  * for the additional interface id that will be supported. For example:
779  *
780  * ```solidity
781  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
783  * }
784  * ```
785  *
786  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
787  */
788 abstract contract ERC165 is IERC165 {
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
793         return interfaceId == type(IERC165).interfaceId;
794     }
795 }
796 
797 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/IERC721.sol
798 
799 
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @dev Required interface of an ERC721 compliant contract.
806  */
807 interface IERC721 is IERC165 {
808     /**
809      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
810      */
811     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
812 
813     /**
814      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
815      */
816     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
817 
818     /**
819      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
820      */
821     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
822 
823     /**
824      * @dev Returns the number of tokens in ``owner``'s account.
825      */
826     function balanceOf(address owner) external view returns (uint256 balance);
827 
828     /**
829      * @dev Returns the owner of the `tokenId` token.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      */
835     function ownerOf(uint256 tokenId) external view returns (address owner);
836 
837     /**
838      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
839      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
840      *
841      * Requirements:
842      *
843      * - `from` cannot be the zero address.
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must exist and be owned by `from`.
846      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
847      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
848      *
849      * Emits a {Transfer} event.
850      */
851     function safeTransferFrom(address from, address to, uint256 tokenId) external;
852 
853     /**
854      * @dev Transfers `tokenId` token from `from` to `to`.
855      *
856      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
864      *
865      * Emits a {Transfer} event.
866      */
867     function transferFrom(address from, address to, uint256 tokenId) external;
868 
869     /**
870      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
871      * The approval is cleared when the token is transferred.
872      *
873      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
874      *
875      * Requirements:
876      *
877      * - The caller must own the token or be an approved operator.
878      * - `tokenId` must exist.
879      *
880      * Emits an {Approval} event.
881      */
882     function approve(address to, uint256 tokenId) external;
883 
884     /**
885      * @dev Returns the account approved for `tokenId` token.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function getApproved(uint256 tokenId) external view returns (address operator);
892 
893     /**
894      * @dev Approve or remove `operator` as an operator for the caller.
895      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
896      *
897      * Requirements:
898      *
899      * - The `operator` cannot be the caller.
900      *
901      * Emits an {ApprovalForAll} event.
902      */
903     function setApprovalForAll(address operator, bool _approved) external;
904 
905     /**
906      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
907      *
908      * See {setApprovalForAll}
909      */
910     function isApprovedForAll(address owner, address operator) external view returns (bool);
911 
912     /**
913       * @dev Safely transfers `tokenId` token from `from` to `to`.
914       *
915       * Requirements:
916       *
917       * - `from` cannot be the zero address.
918       * - `to` cannot be the zero address.
919       * - `tokenId` token must exist and be owned by `from`.
920       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
921       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922       *
923       * Emits a {Transfer} event.
924       */
925     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
926 }
927 
928 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/IERC721Enumerable.sol
929 
930 
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
937  * @dev See https://eips.ethereum.org/EIPS/eip-721
938  */
939 interface IERC721Enumerable is IERC721 {
940 
941     /**
942      * @dev Returns the total amount of tokens stored by the contract.
943      */
944     function totalSupply() external view returns (uint256);
945 
946     /**
947      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
948      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
949      */
950     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
951 
952     /**
953      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
954      * Use along with {totalSupply} to enumerate all tokens.
955      */
956     function tokenByIndex(uint256 index) external view returns (uint256);
957 }
958 
959 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/IERC721Metadata.sol
960 
961 
962 
963 pragma solidity ^0.8.0;
964 
965 
966 /**
967  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
968  * @dev See https://eips.ethereum.org/EIPS/eip-721
969  */
970 interface IERC721Metadata is IERC721 {
971 
972     /**
973      * @dev Returns the token collection name.
974      */
975     function name() external view returns (string memory);
976 
977     /**
978      * @dev Returns the token collection symbol.
979      */
980     function symbol() external view returns (string memory);
981 
982     /**
983      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
984      */
985     function tokenURI(uint256 tokenId) external view returns (string memory);
986 }
987 
988 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/ERC721.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 
996 
997 
998 
999 
1000 
1001 
1002 /**
1003  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1004  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1005  * {ERC721Enumerable}.
1006  */
1007 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1008     using Address for address;
1009     using Strings for uint256;
1010 
1011     // Token name
1012     string private _name;
1013 
1014     // Token symbol
1015     string private _symbol;
1016 
1017     // Mapping from token ID to owner address
1018     mapping (uint256 => address) private _owners;
1019 
1020     // Mapping owner address to token count
1021     mapping (address => uint256) private _balances;
1022 
1023     // Mapping from token ID to approved address
1024     mapping (uint256 => address) private _tokenApprovals;
1025 
1026     // Mapping from owner to operator approvals
1027     mapping (address => mapping (address => bool)) private _operatorApprovals;
1028 
1029     /**
1030      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1031      */
1032     constructor (string memory name_, string memory symbol_) {
1033         _name = name_;
1034         _symbol = symbol_;
1035     }
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1041         return interfaceId == type(IERC721).interfaceId
1042             || interfaceId == type(IERC721Metadata).interfaceId
1043             || super.supportsInterface(interfaceId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-balanceOf}.
1048      */
1049     function balanceOf(address owner) public view virtual override returns (uint256) {
1050         require(owner != address(0), "ERC721: balance query for the zero address");
1051         return _balances[owner];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-ownerOf}.
1056      */
1057     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1058         address owner = _owners[tokenId];
1059         require(owner != address(0), "ERC721: owner query for nonexistent token");
1060         return owner;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Metadata-name}.
1065      */
1066     function name() public view virtual override returns (string memory) {
1067         return _name;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-symbol}.
1072      */
1073     function symbol() public view virtual override returns (string memory) {
1074         return _symbol;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Metadata-tokenURI}.
1079      */
1080     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1081         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1082 
1083         string memory baseURI = _baseURI();
1084         return bytes(baseURI).length > 0
1085             ? string(abi.encodePacked(baseURI, tokenId.toString()))
1086             : '';
1087     }
1088 
1089     /**
1090      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
1091      * in child contracts.
1092      */
1093     function _baseURI() internal view virtual returns (string memory) {
1094         return "";
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-approve}.
1099      */
1100     function approve(address to, uint256 tokenId) public virtual override {
1101         address owner = ERC721.ownerOf(tokenId);
1102         require(to != owner, "ERC721: approval to current owner");
1103 
1104         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1105             "ERC721: approve caller is not owner nor approved for all"
1106         );
1107 
1108         _approve(to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-getApproved}.
1113      */
1114     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1115         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1116 
1117         return _tokenApprovals[tokenId];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-setApprovalForAll}.
1122      */
1123     function setApprovalForAll(address operator, bool approved) public virtual override {
1124         require(operator != _msgSender(), "ERC721: approve to caller");
1125 
1126         _operatorApprovals[_msgSender()][operator] = approved;
1127         emit ApprovalForAll(_msgSender(), operator, approved);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-isApprovedForAll}.
1132      */
1133     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1134         return _operatorApprovals[owner][operator];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-transferFrom}.
1139      */
1140     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1141         //solhint-disable-next-line max-line-length
1142         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1143 
1144         _transfer(from, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-safeTransferFrom}.
1149      */
1150     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1151         safeTransferFrom(from, to, tokenId, "");
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1158         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1159         _safeTransfer(from, to, tokenId, _data);
1160     }
1161 
1162     /**
1163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1165      *
1166      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1167      *
1168      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1169      * implement alternative mechanisms to perform token transfer, such as signature-based.
1170      *
1171      * Requirements:
1172      *
1173      * - `from` cannot be the zero address.
1174      * - `to` cannot be the zero address.
1175      * - `tokenId` token must exist and be owned by `from`.
1176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1181         _transfer(from, to, tokenId);
1182         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1183     }
1184 
1185     /**
1186      * @dev Returns whether `tokenId` exists.
1187      *
1188      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1189      *
1190      * Tokens start existing when they are minted (`_mint`),
1191      * and stop existing when they are burned (`_burn`).
1192      */
1193     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1194         return _owners[tokenId] != address(0);
1195     }
1196 
1197     /**
1198      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      */
1204     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1205         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1206         address owner = ERC721.ownerOf(tokenId);
1207         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1208     }
1209 
1210     /**
1211      * @dev Safely mints `tokenId` and transfers it to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must not exist.
1216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _safeMint(address to, uint256 tokenId) internal virtual {
1221         _safeMint(to, tokenId, "");
1222     }
1223 
1224     /**
1225      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1226      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1227      */
1228     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1229         _mint(to, tokenId);
1230         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1231     }
1232 
1233     /**
1234      * @dev Mints `tokenId` and transfers it to `to`.
1235      *
1236      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must not exist.
1241      * - `to` cannot be the zero address.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _mint(address to, uint256 tokenId) internal virtual {
1246         require(to != address(0), "ERC721: mint to the zero address");
1247         require(!_exists(tokenId), "ERC721: token already minted");
1248 
1249         _beforeTokenTransfer(address(0), to, tokenId);
1250 
1251         _balances[to] += 1;
1252         _owners[tokenId] = to;
1253 
1254         emit Transfer(address(0), to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Destroys `tokenId`.
1259      * The approval is cleared when the token is burned.
1260      *
1261      * Requirements:
1262      *
1263      * - `tokenId` must exist.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _burn(uint256 tokenId) internal virtual {
1268         address owner = ERC721.ownerOf(tokenId);
1269 
1270         _beforeTokenTransfer(owner, address(0), tokenId);
1271 
1272         // Clear approvals
1273         _approve(address(0), tokenId);
1274 
1275         _balances[owner] -= 1;
1276         delete _owners[tokenId];
1277 
1278         emit Transfer(owner, address(0), tokenId);
1279     }
1280 
1281     /**
1282      * @dev Transfers `tokenId` from `from` to `to`.
1283      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1284      *
1285      * Requirements:
1286      *
1287      * - `to` cannot be the zero address.
1288      * - `tokenId` token must be owned by `from`.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1293         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1294         require(to != address(0), "ERC721: transfer to the zero address");
1295 
1296         _beforeTokenTransfer(from, to, tokenId);
1297 
1298         // Clear approvals from the previous owner
1299         _approve(address(0), tokenId);
1300 
1301         _balances[from] -= 1;
1302         _balances[to] += 1;
1303         _owners[tokenId] = to;
1304 
1305         emit Transfer(from, to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Approve `to` to operate on `tokenId`
1310      *
1311      * Emits a {Approval} event.
1312      */
1313     function _approve(address to, uint256 tokenId) internal virtual {
1314         _tokenApprovals[tokenId] = to;
1315         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1320      * The call is not executed if the target address is not a contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1329         private returns (bool)
1330     {
1331         if (to.isContract()) {
1332             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1333                 return retval == IERC721Receiver(to).onERC721Received.selector;
1334             } catch (bytes memory reason) {
1335                 if (reason.length == 0) {
1336                     revert("ERC721: transfer to non ERC721Receiver implementer");
1337                 } else {
1338                     // solhint-disable-next-line no-inline-assembly
1339                     assembly {
1340                         revert(add(32, reason), mload(reason))
1341                     }
1342                 }
1343             }
1344         } else {
1345             return true;
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before any token transfer. This includes minting
1351      * and burning.
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1359      * - `from` cannot be the zero address.
1360      * - `to` cannot be the zero address.
1361      *
1362      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1363      */
1364     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1365 }
1366 
1367 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1368 
1369 
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 /**
1376  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1377  * enumerability of all the token ids in the contract as well as all token ids owned by each
1378  * account.
1379  */
1380 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1381     // Mapping from owner to list of owned token IDs
1382     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1383 
1384     // Mapping from token ID to index of the owner tokens list
1385     mapping(uint256 => uint256) private _ownedTokensIndex;
1386 
1387     // Array with all token ids, used for enumeration
1388     uint256[] private _allTokens;
1389 
1390     // Mapping from token id to position in the allTokens array
1391     mapping(uint256 => uint256) private _allTokensIndex;
1392 
1393     /**
1394      * @dev See {IERC165-supportsInterface}.
1395      */
1396     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1397         return interfaceId == type(IERC721Enumerable).interfaceId
1398             || super.supportsInterface(interfaceId);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1403      */
1404     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1405         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1406         return _ownedTokens[owner][index];
1407     }
1408 
1409     /**
1410      * @dev See {IERC721Enumerable-totalSupply}.
1411      */
1412     function totalSupply() public view virtual override returns (uint256) {
1413         return _allTokens.length;
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Enumerable-tokenByIndex}.
1418      */
1419     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1420         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1421         return _allTokens[index];
1422     }
1423 
1424     /**
1425      * @dev Hook that is called before any token transfer. This includes minting
1426      * and burning.
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` will be minted for `to`.
1433      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1434      * - `from` cannot be the zero address.
1435      * - `to` cannot be the zero address.
1436      *
1437      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1438      */
1439     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1440         super._beforeTokenTransfer(from, to, tokenId);
1441 
1442         if (from == address(0)) {
1443             _addTokenToAllTokensEnumeration(tokenId);
1444         } else if (from != to) {
1445             _removeTokenFromOwnerEnumeration(from, tokenId);
1446         }
1447         if (to == address(0)) {
1448             _removeTokenFromAllTokensEnumeration(tokenId);
1449         } else if (to != from) {
1450             _addTokenToOwnerEnumeration(to, tokenId);
1451         }
1452     }
1453 
1454     /**
1455      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1456      * @param to address representing the new owner of the given token ID
1457      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1458      */
1459     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1460         uint256 length = ERC721.balanceOf(to);
1461         _ownedTokens[to][length] = tokenId;
1462         _ownedTokensIndex[tokenId] = length;
1463     }
1464 
1465     /**
1466      * @dev Private function to add a token to this extension's token tracking data structures.
1467      * @param tokenId uint256 ID of the token to be added to the tokens list
1468      */
1469     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1470         _allTokensIndex[tokenId] = _allTokens.length;
1471         _allTokens.push(tokenId);
1472     }
1473 
1474     /**
1475      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1476      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1477      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1478      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1479      * @param from address representing the previous owner of the given token ID
1480      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1481      */
1482     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1483         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1484         // then delete the last slot (swap and pop).
1485 
1486         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1487         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1488 
1489         // When the token to delete is the last token, the swap operation is unnecessary
1490         if (tokenIndex != lastTokenIndex) {
1491             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1492 
1493             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1494             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1495         }
1496 
1497         // This also deletes the contents at the last position of the array
1498         delete _ownedTokensIndex[tokenId];
1499         delete _ownedTokens[from][lastTokenIndex];
1500     }
1501 
1502     /**
1503      * @dev Private function to remove a token from this extension's token tracking data structures.
1504      * This has O(1) time complexity, but alters the order of the _allTokens array.
1505      * @param tokenId uint256 ID of the token to be removed from the tokens list
1506      */
1507     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1508         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1509         // then delete the last slot (swap and pop).
1510 
1511         uint256 lastTokenIndex = _allTokens.length - 1;
1512         uint256 tokenIndex = _allTokensIndex[tokenId];
1513 
1514         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1515         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1516         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1517         uint256 lastTokenId = _allTokens[lastTokenIndex];
1518 
1519         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1520         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1521 
1522         // This also deletes the contents at the last position of the array
1523         delete _allTokensIndex[tokenId];
1524         _allTokens.pop();
1525     }
1526 }
1527 
1528 // File: contracts/SprayCans.sol
1529 
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 
1534 
1535 
1536 contract SprayCans is ERC721Enumerable, Ownable, PaymentSplitter {
1537   using Strings for uint256;
1538 
1539   string private _baseUri = "https://ipfs.io/ipfs/QmU4rmWZ3WVAXggx3BKswYFSFejTCeRh1tPnfmbAzwtNHy/";
1540   bool public _isMintingActive = true;
1541 
1542   uint256 public constant MAX_SUPPLY = 1111;
1543 
1544   mapping(address => uint256) private _buyers; //key is buying address, value is number they've minted
1545   mapping(address => uint256) private _whitelist_five_plus;
1546   mapping(address => uint256) private _whitelist_four;
1547   mapping(address => uint256) private _whitelist_three;
1548 
1549   uint256 public constant PRESALE_START = 1640023200; // Dec 20 2021 1pm ET
1550   uint256 public constant SALE_START = 1640109600; // Dec 21 2021 1pm ET
1551 
1552   uint256 private _mintCount = 0;
1553 
1554   event Mint(address _to, uint256 _amount);
1555 
1556   constructor(address[] memory payees, uint256[] memory shares) ERC721("SprayCans", "SC") PaymentSplitter(payees, shares) { 
1557     for (uint i = 0; i < 20; i++) {
1558       _mint(address(0xfB1e5420041f83623f166612686B53e9A3cCD9B1), _mintCount);
1559       _mintCount = _mintCount + 1;
1560     }
1561   }
1562 
1563   function addWhitelisted(address[] memory _addresses, uint256[] memory _balances) public onlyOwner {
1564     require(_addresses.length == _balances.length, "lengths must match");
1565     for (uint i = 0; i < _addresses.length; i++) {
1566       address _address = _addresses[i];
1567       uint256 _balance = _balances[i];
1568       if (_balance >= 5) {
1569         _whitelist_five_plus[_address] = 3;
1570       } else if (_balance == 4) {
1571         _whitelist_four[_address] = 2;
1572       } else if (_balance == 3) {
1573         _whitelist_three[_address] = 1;
1574       }
1575     }
1576   }
1577 
1578   function getPrice(address _address) public view returns (uint256) {
1579     if (block.timestamp >= SALE_START) {
1580       return 0.1 ether;
1581     } else if (_whitelist_five_plus[_address] > 0) {
1582       return 0.070 ether;
1583     } else if (_whitelist_four[_address] > 0) {
1584       return 0.075 ether;
1585     } else if (_whitelist_three[_address] > 0) {
1586       return 0.080 ether;
1587     } else {
1588       return 0.1 ether;
1589     }
1590   }
1591 
1592   function getAmountRemaining(address _address) public view returns (uint256) {
1593     if (block.timestamp >= SALE_START) {
1594       return 3 - _buyers[_address];
1595     } else if (_whitelist_five_plus[_address] > 0) {
1596       return _whitelist_five_plus[_address];
1597     } else if (_whitelist_four[_address] > 0) {
1598       return _whitelist_four[_address];
1599     } else if (_whitelist_three[_address] > 0) {
1600       return _whitelist_three[_address];
1601     } else {
1602       return 0;
1603     }
1604   }
1605 
1606   function mint(uint256 amount) public payable {
1607     require(_isMintingActive && block.timestamp >= PRESALE_START, "Museum: sale is not active");
1608     require(amount <= getAmountRemaining(msg.sender), "Museum: minting too many");
1609     require(_mintCount + amount <= MAX_SUPPLY, "Museum: exceeds max supply");
1610     require(amount * getPrice(msg.sender) == msg.value, "Museum: must send correct ETH amount");
1611 
1612     for (uint i = 0; i < amount; i++) {      
1613       _mint(msg.sender, _mintCount);
1614       _mintCount = _mintCount + 1;
1615     }
1616 
1617     if (block.timestamp >= SALE_START) {
1618       _buyers[msg.sender] = _buyers[msg.sender] + amount;
1619     } else if (_whitelist_five_plus[msg.sender] > 0) {
1620       _whitelist_five_plus[msg.sender] = _whitelist_five_plus[msg.sender] - amount;
1621     } else if (_whitelist_four[msg.sender] > 0) {
1622       _whitelist_four[msg.sender] = _whitelist_four[msg.sender] - amount;
1623     } else if (_whitelist_three[msg.sender] > 0) {
1624       _whitelist_three[msg.sender] = _whitelist_three[msg.sender] - amount;
1625     }
1626 
1627     emit Mint(msg.sender, amount);
1628   }
1629 
1630   function setBaseURI(string memory baseUri) public onlyOwner {
1631     _baseUri = baseUri;
1632   }
1633 
1634   function _baseURI() internal view virtual override returns (string memory) {
1635     return _baseUri;
1636   }
1637 
1638   function toggleMinting() public onlyOwner {
1639     _isMintingActive = !_isMintingActive;
1640   }
1641 
1642   function withdraw(address _target, uint256 amount) public onlyOwner {
1643     payable(_target).transfer(amount);
1644   }
1645 }