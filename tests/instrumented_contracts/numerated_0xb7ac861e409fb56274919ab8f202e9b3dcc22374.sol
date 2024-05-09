1 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         assembly {
35             size := extcodesize(account)
36         }
37         return size > 0;
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         (bool success, ) = recipient.call{value: amount}("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain `call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(
92         address target,
93         bytes memory data,
94         string memory errorMessage
95     ) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(
111         address target,
112         bytes memory data,
113         uint256 value
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
120      * with `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value,
128         string memory errorMessage
129     ) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: value}(data);
134         return _verifyCallResult(success, returndata, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return _verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a delegate call.
167      *
168      * _Available since v3.4._
169      */
170     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(isContract(target), "Address: delegate call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     function _verifyCallResult(
192         bool success,
193         bytes memory returndata,
194         string memory errorMessage
195     ) private pure returns (bytes memory) {
196         if (success) {
197             return returndata;
198         } else {
199             // Look for revert reason and bubble it up if present
200             if (returndata.length > 0) {
201                 // The easiest way to bubble the revert reason is using memory via assembly
202 
203                 assembly {
204                     let returndata_size := mload(returndata)
205                     revert(add(32, returndata), returndata_size)
206                 }
207             } else {
208                 revert(errorMessage);
209             }
210         }
211     }
212 }
213 
214 
215 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
216 
217 pragma solidity ^0.8.0;
218 
219 /*
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 
240 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
241 
242 pragma solidity ^0.8.0;
243 
244 // CAUTION
245 // This version of SafeMath should only be used with Solidity 0.8 or later,
246 // because it relies on the compiler's built in overflow checks.
247 
248 /**
249  * @dev Wrappers over Solidity's arithmetic operations.
250  *
251  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
252  * now has built in overflow checking.
253  */
254 library SafeMath {
255     /**
256      * @dev Returns the addition of two unsigned integers, with an overflow flag.
257      *
258      * _Available since v3.4._
259      */
260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             uint256 c = a + b;
263             if (c < a) return (false, 0);
264             return (true, c);
265         }
266     }
267 
268     /**
269      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
270      *
271      * _Available since v3.4._
272      */
273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b > a) return (false, 0);
276             return (true, a - b);
277         }
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
282      *
283      * _Available since v3.4._
284      */
285     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
288             // benefit is lost if 'b' is also tested.
289             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
290             if (a == 0) return (true, 0);
291             uint256 c = a * b;
292             if (c / a != b) return (false, 0);
293             return (true, c);
294         }
295     }
296 
297     /**
298      * @dev Returns the division of two unsigned integers, with a division by zero flag.
299      *
300      * _Available since v3.4._
301      */
302     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         unchecked {
304             if (b == 0) return (false, 0);
305             return (true, a / b);
306         }
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
311      *
312      * _Available since v3.4._
313      */
314     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
315         unchecked {
316             if (b == 0) return (false, 0);
317             return (true, a % b);
318         }
319     }
320 
321     /**
322      * @dev Returns the addition of two unsigned integers, reverting on
323      * overflow.
324      *
325      * Counterpart to Solidity's `+` operator.
326      *
327      * Requirements:
328      *
329      * - Addition cannot overflow.
330      */
331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a + b;
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting on
337      * overflow (when the result is negative).
338      *
339      * Counterpart to Solidity's `-` operator.
340      *
341      * Requirements:
342      *
343      * - Subtraction cannot overflow.
344      */
345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a - b;
347     }
348 
349     /**
350      * @dev Returns the multiplication of two unsigned integers, reverting on
351      * overflow.
352      *
353      * Counterpart to Solidity's `*` operator.
354      *
355      * Requirements:
356      *
357      * - Multiplication cannot overflow.
358      */
359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a * b;
361     }
362 
363     /**
364      * @dev Returns the integer division of two unsigned integers, reverting on
365      * division by zero. The result is rounded towards zero.
366      *
367      * Counterpart to Solidity's `/` operator.
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a / b;
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * reverting when dividing by zero.
380      *
381      * Counterpart to Solidity's `%` operator. This function uses a `revert`
382      * opcode (which leaves remaining gas untouched) while Solidity uses an
383      * invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      *
387      * - The divisor cannot be zero.
388      */
389     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
390         return a % b;
391     }
392 
393     /**
394      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
395      * overflow (when the result is negative).
396      *
397      * CAUTION: This function is deprecated because it requires allocating memory for the error
398      * message unnecessarily. For custom revert reasons use {trySub}.
399      *
400      * Counterpart to Solidity's `-` operator.
401      *
402      * Requirements:
403      *
404      * - Subtraction cannot overflow.
405      */
406     function sub(
407         uint256 a,
408         uint256 b,
409         string memory errorMessage
410     ) internal pure returns (uint256) {
411         unchecked {
412             require(b <= a, errorMessage);
413             return a - b;
414         }
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
419      * division by zero. The result is rounded towards zero.
420      *
421      * Counterpart to Solidity's `/` operator. Note: this function uses a
422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
423      * uses an invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      *
427      * - The divisor cannot be zero.
428      */
429     function div(
430         uint256 a,
431         uint256 b,
432         string memory errorMessage
433     ) internal pure returns (uint256) {
434         unchecked {
435             require(b > 0, errorMessage);
436             return a / b;
437         }
438     }
439 
440     /**
441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
442      * reverting with custom message when dividing by zero.
443      *
444      * CAUTION: This function is deprecated because it requires allocating memory for the error
445      * message unnecessarily. For custom revert reasons use {tryMod}.
446      *
447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
448      * opcode (which leaves remaining gas untouched) while Solidity uses an
449      * invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function mod(
456         uint256 a,
457         uint256 b,
458         string memory errorMessage
459     ) internal pure returns (uint256) {
460         unchecked {
461             require(b > 0, errorMessage);
462             return a % b;
463         }
464     }
465 }
466 
467 
468 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.2.0
469 
470 pragma solidity ^0.8.0;
471 
472 
473 
474 /**
475  * @title PaymentSplitter
476  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
477  * that the Ether will be split in this way, since it is handled transparently by the contract.
478  *
479  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
480  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
481  * an amount proportional to the percentage of total shares they were assigned.
482  *
483  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
484  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
485  * function.
486  */
487 contract PaymentSplitter is Context {
488     event PayeeAdded(address account, uint256 shares);
489     event PaymentReleased(address to, uint256 amount);
490     event PaymentReceived(address from, uint256 amount);
491 
492     uint256 private _totalShares;
493     uint256 private _totalReleased;
494 
495     mapping(address => uint256) private _shares;
496     mapping(address => uint256) private _released;
497     address[] private _payees;
498 
499     /**
500      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
501      * the matching position in the `shares` array.
502      *
503      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
504      * duplicates in `payees`.
505      */
506     constructor(address[] memory payees, uint256[] memory shares_) payable {
507         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
508         require(payees.length > 0, "PaymentSplitter: no payees");
509 
510         for (uint256 i = 0; i < payees.length; i++) {
511             _addPayee(payees[i], shares_[i]);
512         }
513     }
514 
515     /**
516      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
517      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
518      * reliability of the events, and not the actual splitting of Ether.
519      *
520      * To learn more about this see the Solidity documentation for
521      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
522      * functions].
523      */
524     receive() external payable virtual {
525         emit PaymentReceived(_msgSender(), msg.value);
526     }
527 
528     /**
529      * @dev Getter for the total shares held by payees.
530      */
531     function totalShares() public view returns (uint256) {
532         return _totalShares;
533     }
534 
535     /**
536      * @dev Getter for the total amount of Ether already released.
537      */
538     function totalReleased() public view returns (uint256) {
539         return _totalReleased;
540     }
541 
542     /**
543      * @dev Getter for the amount of shares held by an account.
544      */
545     function shares(address account) public view returns (uint256) {
546         return _shares[account];
547     }
548 
549     /**
550      * @dev Getter for the amount of Ether already released to a payee.
551      */
552     function released(address account) public view returns (uint256) {
553         return _released[account];
554     }
555 
556     /**
557      * @dev Getter for the address of the payee number `index`.
558      */
559     function payee(uint256 index) public view returns (address) {
560         return _payees[index];
561     }
562 
563     /**
564      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
565      * total shares and their previous withdrawals.
566      */
567     function release(address payable account) public virtual {
568         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
569 
570         uint256 totalReceived = address(this).balance + _totalReleased;
571         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
572 
573         require(payment != 0, "PaymentSplitter: account is not due payment");
574 
575         _released[account] = _released[account] + payment;
576         _totalReleased = _totalReleased + payment;
577 
578         Address.sendValue(account, payment);
579         emit PaymentReleased(account, payment);
580     }
581 
582     /**
583      * @dev Add a new payee to the contract.
584      * @param account The address of the payee to add.
585      * @param shares_ The number of shares owned by the payee.
586      */
587     function _addPayee(address account, uint256 shares_) private {
588         require(account != address(0), "PaymentSplitter: account is the zero address");
589         require(shares_ > 0, "PaymentSplitter: shares are 0");
590         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
591 
592         _payees.push(account);
593         _shares[account] = shares_;
594         _totalShares = _totalShares + shares_;
595         emit PayeeAdded(account, shares_);
596     }
597 }
598 
599 
600 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
601 
602 
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev Interface of the ERC165 standard, as defined in the
608  * https://eips.ethereum.org/EIPS/eip-165[EIP].
609  *
610  * Implementers can declare support of contract interfaces, which can then be
611  * queried by others ({ERC165Checker}).
612  *
613  * For an implementation, see {ERC165}.
614  */
615 interface IERC165 {
616     /**
617      * @dev Returns true if this contract implements the interface defined by
618      * `interfaceId`. See the corresponding
619      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
620      * to learn more about how these ids are created.
621      *
622      * This function call must use less than 30 000 gas.
623      */
624     function supportsInterface(bytes4 interfaceId) external view returns (bool);
625 }
626 
627 
628 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
629 
630 
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Required interface of an ERC721 compliant contract.
636  */
637 interface IERC721 is IERC165 {
638     /**
639      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
640      */
641     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
645      */
646     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
647 
648     /**
649      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
650      */
651     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
652 
653     /**
654      * @dev Returns the number of tokens in ``owner``'s account.
655      */
656     function balanceOf(address owner) external view returns (uint256 balance);
657 
658     /**
659      * @dev Returns the owner of the `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function ownerOf(uint256 tokenId) external view returns (address owner);
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
669      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
670      *
671      * Requirements:
672      *
673      * - `from` cannot be the zero address.
674      * - `to` cannot be the zero address.
675      * - `tokenId` token must exist and be owned by `from`.
676      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Transfers `tokenId` token from `from` to `to`.
689      *
690      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      *
699      * Emits a {Transfer} event.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external;
706 
707     /**
708      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
709      * The approval is cleared when the token is transferred.
710      *
711      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) external;
721 
722     /**
723      * @dev Returns the account approved for `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function getApproved(uint256 tokenId) external view returns (address operator);
730 
731     /**
732      * @dev Approve or remove `operator` as an operator for the caller.
733      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
734      *
735      * Requirements:
736      *
737      * - The `operator` cannot be the caller.
738      *
739      * Emits an {ApprovalForAll} event.
740      */
741     function setApprovalForAll(address operator, bool _approved) external;
742 
743     /**
744      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
745      *
746      * See {setApprovalForAll}
747      */
748     function isApprovedForAll(address owner, address operator) external view returns (bool);
749 
750     /**
751      * @dev Safely transfers `tokenId` token from `from` to `to`.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must exist and be owned by `from`.
758      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes calldata data
768     ) external;
769 }
770 
771 
772 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
773 
774 
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @title ERC721 token receiver interface
780  * @dev Interface for any contract that wants to support safeTransfers
781  * from ERC721 asset contracts.
782  */
783 interface IERC721Receiver {
784     /**
785      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
786      * by `operator` from `from`, this function is called.
787      *
788      * It must return its Solidity selector to confirm the token transfer.
789      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
790      *
791      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
792      */
793     function onERC721Received(
794         address operator,
795         address from,
796         uint256 tokenId,
797         bytes calldata data
798     ) external returns (bytes4);
799 }
800 
801 
802 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
803 
804 
805 
806 pragma solidity ^0.8.0;
807 
808 /**
809  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
810  * @dev See https://eips.ethereum.org/EIPS/eip-721
811  */
812 interface IERC721Metadata is IERC721 {
813     /**
814      * @dev Returns the token collection name.
815      */
816     function name() external view returns (string memory);
817 
818     /**
819      * @dev Returns the token collection symbol.
820      */
821     function symbol() external view returns (string memory);
822 
823     /**
824      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
825      */
826     function tokenURI(uint256 tokenId) external view returns (string memory);
827 }
828 
829 
830 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
831 
832 
833 
834 pragma solidity ^0.8.0;
835 
836 /**
837  * @dev String operations.
838  */
839 library Strings {
840     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
841 
842     /**
843      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
844      */
845     function toString(uint256 value) internal pure returns (string memory) {
846         // Inspired by OraclizeAPI's implementation - MIT licence
847         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
848 
849         if (value == 0) {
850             return "0";
851         }
852         uint256 temp = value;
853         uint256 digits;
854         while (temp != 0) {
855             digits++;
856             temp /= 10;
857         }
858         bytes memory buffer = new bytes(digits);
859         while (value != 0) {
860             digits -= 1;
861             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
862             value /= 10;
863         }
864         return string(buffer);
865     }
866 
867     /**
868      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
869      */
870     function toHexString(uint256 value) internal pure returns (string memory) {
871         if (value == 0) {
872             return "0x00";
873         }
874         uint256 temp = value;
875         uint256 length = 0;
876         while (temp != 0) {
877             length++;
878             temp >>= 8;
879         }
880         return toHexString(value, length);
881     }
882 
883     /**
884      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
885      */
886     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
887         bytes memory buffer = new bytes(2 * length + 2);
888         buffer[0] = "0";
889         buffer[1] = "x";
890         for (uint256 i = 2 * length + 1; i > 1; --i) {
891             buffer[i] = _HEX_SYMBOLS[value & 0xf];
892             value >>= 4;
893         }
894         require(value == 0, "Strings: hex length insufficient");
895         return string(buffer);
896     }
897 }
898 
899 
900 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
901 
902 
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Implementation of the {IERC165} interface.
908  *
909  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
910  * for the additional interface id that will be supported. For example:
911  *
912  * ```solidity
913  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
914  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
915  * }
916  * ```
917  *
918  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
919  */
920 abstract contract ERC165 is IERC165 {
921     /**
922      * @dev See {IERC165-supportsInterface}.
923      */
924     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
925         return interfaceId == type(IERC165).interfaceId;
926     }
927 }
928 
929 
930 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
931 
932 
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 
942 /**
943  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
944  * the Metadata extension, but not including the Enumerable extension, which is available separately as
945  * {ERC721Enumerable}.
946  */
947 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
948     using Address for address;
949     using Strings for uint256;
950 
951     // Token name
952     string private _name;
953 
954     // Token symbol
955     string private _symbol;
956 
957     // Mapping from token ID to owner address
958     mapping(uint256 => address) private _owners;
959 
960     // Mapping owner address to token count
961     mapping(address => uint256) private _balances;
962 
963     // Mapping from token ID to approved address
964     mapping(uint256 => address) private _tokenApprovals;
965 
966     // Mapping from owner to operator approvals
967     mapping(address => mapping(address => bool)) private _operatorApprovals;
968 
969     /**
970      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
971      */
972     constructor(string memory name_, string memory symbol_) {
973         _name = name_;
974         _symbol = symbol_;
975     }
976 
977     /**
978      * @dev See {IERC165-supportsInterface}.
979      */
980     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
981         return
982             interfaceId == type(IERC721).interfaceId ||
983             interfaceId == type(IERC721Metadata).interfaceId ||
984             super.supportsInterface(interfaceId);
985     }
986 
987     /**
988      * @dev See {IERC721-balanceOf}.
989      */
990     function balanceOf(address owner) public view virtual override returns (uint256) {
991         require(owner != address(0), "ERC721: balance query for the zero address");
992         return _balances[owner];
993     }
994 
995     /**
996      * @dev See {IERC721-ownerOf}.
997      */
998     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
999         address owner = _owners[tokenId];
1000         require(owner != address(0), "ERC721: owner query for nonexistent token");
1001         return owner;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-name}.
1006      */
1007     function name() public view virtual override returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-symbol}.
1013      */
1014     function symbol() public view virtual override returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-tokenURI}.
1020      */
1021     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1022         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1023 
1024         string memory baseURI = _baseURI();
1025         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1026     }
1027 
1028     /**
1029      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1030      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1031      * by default, can be overriden in child contracts.
1032      */
1033     function _baseURI() internal view virtual returns (string memory) {
1034         return "";
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-approve}.
1039      */
1040     function approve(address to, uint256 tokenId) public virtual override {
1041         address owner = ERC721.ownerOf(tokenId);
1042         require(to != owner, "ERC721: approval to current owner");
1043 
1044         require(
1045             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1046             "ERC721: approve caller is not owner nor approved for all"
1047         );
1048 
1049         _approve(to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-getApproved}.
1054      */
1055     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1056         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1057 
1058         return _tokenApprovals[tokenId];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-setApprovalForAll}.
1063      */
1064     function setApprovalForAll(address operator, bool approved) public virtual override {
1065         require(operator != _msgSender(), "ERC721: approve to caller");
1066 
1067         _operatorApprovals[_msgSender()][operator] = approved;
1068         emit ApprovalForAll(_msgSender(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-isApprovedForAll}.
1073      */
1074     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1075         return _operatorApprovals[owner][operator];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-transferFrom}.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         //solhint-disable-next-line max-line-length
1087         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1088 
1089         _transfer(from, to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-safeTransferFrom}.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         safeTransferFrom(from, to, tokenId, "");
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) public virtual override {
1112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1113         _safeTransfer(from, to, tokenId, _data);
1114     }
1115 
1116     /**
1117      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1118      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1119      *
1120      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1121      *
1122      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1123      * implement alternative mechanisms to perform token transfer, such as signature-based.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must exist and be owned by `from`.
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _safeTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) internal virtual {
1140         _transfer(from, to, tokenId);
1141         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1142     }
1143 
1144     /**
1145      * @dev Returns whether `tokenId` exists.
1146      *
1147      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1148      *
1149      * Tokens start existing when they are minted (`_mint`),
1150      * and stop existing when they are burned (`_burn`).
1151      */
1152     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1153         return _owners[tokenId] != address(0);
1154     }
1155 
1156     /**
1157      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      */
1163     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1164         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1165         address owner = ERC721.ownerOf(tokenId);
1166         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1167     }
1168 
1169     /**
1170      * @dev Safely mints `tokenId` and transfers it to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must not exist.
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _safeMint(address to, uint256 tokenId) internal virtual {
1180         _safeMint(to, tokenId, "");
1181     }
1182 
1183     /**
1184      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1185      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1186      */
1187     function _safeMint(
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) internal virtual {
1192         _mint(to, tokenId);
1193         require(
1194             _checkOnERC721Received(address(0), to, tokenId, _data),
1195             "ERC721: transfer to non ERC721Receiver implementer"
1196         );
1197     }
1198 
1199     /**
1200      * @dev Mints `tokenId` and transfers it to `to`.
1201      *
1202      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must not exist.
1207      * - `to` cannot be the zero address.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _mint(address to, uint256 tokenId) internal virtual {
1212         require(to != address(0), "ERC721: mint to the zero address");
1213         require(!_exists(tokenId), "ERC721: token already minted");
1214 
1215         _beforeTokenTransfer(address(0), to, tokenId);
1216 
1217         _balances[to] += 1;
1218         _owners[tokenId] = to;
1219 
1220         emit Transfer(address(0), to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         address owner = ERC721.ownerOf(tokenId);
1235 
1236         _beforeTokenTransfer(owner, address(0), tokenId);
1237 
1238         // Clear approvals
1239         _approve(address(0), tokenId);
1240 
1241         _balances[owner] -= 1;
1242         delete _owners[tokenId];
1243 
1244         emit Transfer(owner, address(0), tokenId);
1245     }
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must be owned by `from`.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _transfer(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) internal virtual {
1263         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1264         require(to != address(0), "ERC721: transfer to the zero address");
1265 
1266         _beforeTokenTransfer(from, to, tokenId);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId);
1270 
1271         _balances[from] -= 1;
1272         _balances[to] += 1;
1273         _owners[tokenId] = to;
1274 
1275         emit Transfer(from, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Approve `to` to operate on `tokenId`
1280      *
1281      * Emits a {Approval} event.
1282      */
1283     function _approve(address to, uint256 tokenId) internal virtual {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1290      * The call is not executed if the target address is not a contract.
1291      *
1292      * @param from address representing the previous owner of the given token ID
1293      * @param to target address that will receive the tokens
1294      * @param tokenId uint256 ID of the token to be transferred
1295      * @param _data bytes optional data to send along with the call
1296      * @return bool whether the call correctly returned the expected magic value
1297      */
1298     function _checkOnERC721Received(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) private returns (bool) {
1304         if (to.isContract()) {
1305             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1306                 return retval == IERC721Receiver(to).onERC721Received.selector;
1307             } catch (bytes memory reason) {
1308                 if (reason.length == 0) {
1309                     revert("ERC721: transfer to non ERC721Receiver implementer");
1310                 } else {
1311                     assembly {
1312                         revert(add(32, reason), mload(reason))
1313                     }
1314                 }
1315             }
1316         } else {
1317             return true;
1318         }
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before any token transfer. This includes minting
1323      * and burning.
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1331      * - `from` and `to` are never both zero.
1332      *
1333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1334      */
1335     function _beforeTokenTransfer(
1336         address from,
1337         address to,
1338         uint256 tokenId
1339     ) internal virtual {}
1340 }
1341 
1342 
1343 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1344 
1345 
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 /**
1350  * @dev Contract module which provides a basic access control mechanism, where
1351  * there is an account (an owner) that can be granted exclusive access to
1352  * specific functions.
1353  *
1354  * By default, the owner account will be the one that deploys the contract. This
1355  * can later be changed with {transferOwnership}.
1356  *
1357  * This module is used through inheritance. It will make available the modifier
1358  * `onlyOwner`, which can be applied to your functions to restrict their use to
1359  * the owner.
1360  */
1361 abstract contract Ownable is Context {
1362     address private _owner;
1363 
1364     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1365 
1366     /**
1367      * @dev Initializes the contract setting the deployer as the initial owner.
1368      */
1369     constructor() {
1370         _setOwner(_msgSender());
1371     }
1372 
1373     /**
1374      * @dev Returns the address of the current owner.
1375      */
1376     function owner() public view virtual returns (address) {
1377         return _owner;
1378     }
1379 
1380     /**
1381      * @dev Throws if called by any account other than the owner.
1382      */
1383     modifier onlyOwner() {
1384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1385         _;
1386     }
1387 
1388     /**
1389      * @dev Leaves the contract without owner. It will not be possible to call
1390      * `onlyOwner` functions anymore. Can only be called by the current owner.
1391      *
1392      * NOTE: Renouncing ownership will leave the contract without an owner,
1393      * thereby removing any functionality that is only available to the owner.
1394      */
1395     function renounceOwnership() public virtual onlyOwner {
1396         _setOwner(address(0));
1397     }
1398 
1399     /**
1400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1401      * Can only be called by the current owner.
1402      */
1403     function transferOwnership(address newOwner) public virtual onlyOwner {
1404         require(newOwner != address(0), "Ownable: new owner is the zero address");
1405         _setOwner(newOwner);
1406     }
1407 
1408     function _setOwner(address newOwner) private {
1409         address oldOwner = _owner;
1410         _owner = newOwner;
1411         emit OwnershipTransferred(oldOwner, newOwner);
1412     }
1413 }
1414 
1415 
1416 // File contracts/MysticSisterhood.sol
1417 
1418 
1419 pragma solidity ^0.8.0;
1420 /**
1421  * @title MysticSisterhood contract
1422  */
1423 
1424 contract MysticSisterhood is Ownable, ERC721, PaymentSplitter {
1425 
1426     uint256 public tokenPrice = 0.05 ether;
1427     uint256 public totalSupply = 0;
1428     uint256 public constant MAX_TOKENS = 7777;
1429     uint public constant MAX_PURCHASE = 20;
1430 
1431     bool public saleIsActive;
1432     string private _baseTokenURI;
1433 
1434     address public proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1435 
1436     constructor(string memory baseURI, address[] memory payees, uint256[] memory shares_)
1437     ERC721("MysticSisterhood", "MYSTICSIS")
1438     PaymentSplitter(payees, shares_){
1439         _baseTokenURI = baseURI;
1440     }
1441 
1442     function reserveTokens(address to, uint numberOfTokens) public onlyOwner {
1443         uint supply = totalSupply;
1444         totalSupply += numberOfTokens;
1445         require(totalSupply <= MAX_TOKENS, "e1"); // Reserve would exceed max supply of Tokens
1446         for (uint i = 0; i < numberOfTokens; i++) {
1447             _safeMint(to, supply + i);
1448         }
1449     }
1450 
1451     function mint(uint256 numberOfTokens) external payable {
1452         require(saleIsActive, "e2"); // Sale must be active to mint Tokens
1453         require(numberOfTokens > 0 && numberOfTokens <= MAX_PURCHASE, "e3"); // must be greater than 0 and less than equal 20
1454 
1455         uint256 supply = totalSupply;
1456         totalSupply += numberOfTokens;
1457         require(totalSupply <= MAX_TOKENS, "e4"); // Purchase would exceed max supply of Tokens
1458         require(tokenPrice * numberOfTokens <= msg.value, "e5"); // Ether value sent is not correct
1459 
1460         for (uint256 i; i < numberOfTokens; i++) {
1461             _safeMint(msg.sender, supply + i);
1462         }
1463     }
1464 
1465     /**
1466      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1467      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1468      * by default, can be overriden in child contracts.
1469      */
1470     function _baseURI() internal view virtual override returns (string memory) {
1471         return _baseTokenURI;
1472     }
1473     /**
1474      * @dev Set the base token URI
1475      */
1476     function setBaseTokenURI(string memory baseURI) public onlyOwner {
1477         _baseTokenURI = baseURI;
1478     }
1479 
1480     /**
1481      * Pause sale if active, make active if paused
1482      */
1483     function flipSaleState() public onlyOwner {
1484         saleIsActive = !saleIsActive;
1485     }
1486 
1487     /**
1488     * Set price
1489     */
1490     function setPrice(uint256 price) public onlyOwner {
1491         tokenPrice = price;
1492     }
1493 
1494     function withdrawAll() public onlyOwner {
1495         require(payable(owner()).send(address(this).balance));
1496     }
1497 
1498     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1499         proxyRegistryAddress = _proxyRegistryAddress;
1500     }
1501 
1502     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1503         if (operator == proxyRegistryAddress) {
1504             return true;
1505         }
1506         return super.isApprovedForAll(_owner, operator);
1507     }
1508 }