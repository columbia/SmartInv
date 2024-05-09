1 // File: Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: Ownable.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Contract module which provides a basic access control mechanism, where
80  * there is an account (an owner) that can be granted exclusive access to
81  * specific functions.
82  *
83  * By default, the owner account will be the one that deploys the contract. This
84  * can later be changed with {transferOwnership}.
85  *
86  * This module is used through inheritance. It will make available the modifier
87  * `onlyOwner`, which can be applied to your functions to restrict their use to
88  * the owner.
89  */
90 abstract contract Ownable {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Initializes the contract setting the deployer as the initial owner.
97      */
98     constructor() {
99         _transferOwnership(msg.sender);
100     }
101 
102     function OwnableInit() internal {
103         _transferOwnership(msg.sender);
104     }
105 
106     /**
107      * @dev Returns the address of the current owner.
108      */
109     function owner() public view virtual returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(owner() == msg.sender, "Ownable: caller is not the owner");
118         _;
119     }
120 
121     /**
122      * @dev Leaves the contract without owner. It will not be possible to call
123      * `onlyOwner` functions anymore. Can only be called by the current owner.
124      *
125      * NOTE: Renouncing ownership will leave the contract without an owner,
126      * thereby removing any functionality that is only available to the owner.
127      */
128     function renounceOwnership() public virtual onlyOwner {
129         _transferOwnership(address(0));
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Can only be called by the current owner.
135      */
136     function transferOwnership(address newOwner) public virtual onlyOwner {
137         require(newOwner != address(0), "Ownable: new owner is the zero address");
138         _transferOwnership(newOwner);
139     }
140 
141     /**
142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
143      * Internal function without access restriction.
144      */
145     function _transferOwnership(address newOwner) internal virtual {
146         address oldOwner = _owner;
147         _owner = newOwner;
148         emit OwnershipTransferred(oldOwner, newOwner);
149     }
150 }
151 
152 // File: Address.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Collection of functions related to the address type
161  */
162 library Address {
163     /**
164      * @dev Returns true if `account` is a contract.
165      *
166      * [IMPORTANT]
167      * ====
168      * It is unsafe to assume that an address for which this function returns
169      * false is an externally-owned account (EOA) and not a contract.
170      *
171      * Among others, `isContract` will return false for the following
172      * types of addresses:
173      *
174      *  - an externally-owned account
175      *  - a contract in construction
176      *  - an address where a contract will be created
177      *  - an address where a contract lived, but was destroyed
178      * ====
179      *
180      * [IMPORTANT]
181      * ====
182      * You shouldn't rely on `isContract` to protect against flash loan attacks!
183      *
184      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
185      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
186      * constructor.
187      * ====
188      */
189     function isContract(address account) internal view returns (bool) {
190         // This method relies on extcodesize/address.code.length, which returns 0
191         // for contracts in construction, since the code is only stored at the end
192         // of the constructor execution.
193 
194         return account.code.length > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         (bool success, ) = recipient.call{value: amount}("");
217         require(success, "Address: unable to send value, recipient may have reverted");
218     }
219 
220     /**
221      * @dev Performs a Solidity function call using a low level `call`. A
222      * plain `call` is an unsafe replacement for a function call: use this
223      * function instead.
224      *
225      * If `target` reverts with a revert reason, it is bubbled up by this
226      * function (like regular Solidity function calls).
227      *
228      * Returns the raw returned data. To convert to the expected return value,
229      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
230      *
231      * Requirements:
232      *
233      * - `target` must be a contract.
234      * - calling `target` with `data` must not revert.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionCall(target, data, "Address: low-level call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
244      * `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, 0, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but also transferring `value` wei to `target`.
259      *
260      * Requirements:
261      *
262      * - the calling contract must have an ETH balance of at least `value`.
263      * - the called Solidity function must be `payable`.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
277      * with `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         require(isContract(target), "Address: call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.call{value: value}(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
301         return functionStaticCall(target, data, "Address: low-level static call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal view returns (bytes memory) {
315         require(isContract(target), "Address: static call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.staticcall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(isContract(target), "Address: delegate call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.delegatecall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
350      * revert reason using the provided one.
351      *
352      * _Available since v4.3._
353      */
354     function verifyCallResult(
355         bool success,
356         bytes memory returndata,
357         string memory errorMessage
358     ) internal pure returns (bytes memory) {
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // File: PaymentSplitter.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @title PaymentSplitter
387  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
388  * that the Ether will be split in this way, since it is handled transparently by the contract.
389  *
390  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
391  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
392  * an amount proportional to the percentage of total shares they were assigned.
393  *
394  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
395  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
396  * function.
397  *
398  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
399  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
400  * to run tests before sending real value to this contract.
401  */
402 contract PaymentSplitter {
403     event PayeeAdded(address account, uint256 shares);
404     event PaymentReleased(address to, uint256 amount);
405     event PaymentReceived(address from, uint256 amount);
406 
407     uint256 private _totalShares;
408     uint256 private _totalReleased;
409 
410     mapping(address => uint256) private _shares;
411     mapping(address => uint256) private _released;
412     address[] private _payees;
413 
414     /**
415      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
416      * the matching position in the `shares` array.
417      *
418      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
419      * duplicates in `payees`.
420      */
421     function SplitterInit(address[] memory payees, uint256[] memory shares_) internal {
422         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
423         require(payees.length > 0, "PaymentSplitter: no payees");
424 
425         for (uint256 i = 0; i < payees.length; i++) {
426             _addPayee(payees[i], shares_[i]);
427         }
428     }
429 
430     /**
431      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
432      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
433      * reliability of the events, and not the actual splitting of Ether.
434      *
435      * To learn more about this see the Solidity documentation for
436      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
437      * functions].
438      */
439     receive() external payable virtual {
440         emit PaymentReceived(msg.sender, msg.value);
441     }
442 
443     /**
444      * @dev Getter for the total shares held by payees.
445      */
446     function totalShares() public view returns (uint256) {
447         return _totalShares;
448     }
449 
450     /**
451      * @dev Getter for the total amount of Ether already released.
452      */
453     function totalReleased() public view returns (uint256) {
454         return _totalReleased;
455     }
456 
457     /**
458      * @dev Getter for the amount of shares held by an account.
459      */
460     function shares(address account) public view returns (uint256) {
461         return _shares[account];
462     }
463 
464     /**
465      * @dev Getter for the amount of Ether already released to a payee.
466      */
467     function released(address account) public view returns (uint256) {
468         return _released[account];
469     }
470 
471     /**
472      * @dev Getter for the address of the payee number `index`.
473      */
474     function payee(uint256 index) public view returns (address) {
475         return _payees[index];
476     }
477 
478     /**
479      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
480      * total shares and their previous withdrawals.
481      */
482     function release(address payable account) public virtual {
483         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
484 
485         uint256 totalReceived = address(this).balance + totalReleased();
486         uint256 payment = _pendingPayment(account, totalReceived, released(account));
487 
488         require(payment != 0, "PaymentSplitter: account is not due payment");
489 
490         _released[account] += payment;
491         _totalReleased += payment;
492 
493         Address.sendValue(account, payment);
494         emit PaymentReleased(account, payment);
495     }
496 
497     /**
498      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
499      * already released amounts.
500      */
501     function _pendingPayment(
502         address account,
503         uint256 totalReceived,
504         uint256 alreadyReleased
505     ) private view returns (uint256) {
506         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
507     }
508 
509     /**
510      * @dev Add a new payee to the contract.
511      * @param account The address of the payee to add.
512      * @param shares_ The number of shares owned by the payee.
513      */
514     function _addPayee(address account, uint256 shares_) private {
515         require(account != address(0), "PaymentSplitter: account is the zero address");
516         require(shares_ > 0, "PaymentSplitter: shares are 0");
517         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
518 
519         _payees.push(account);
520         _shares[account] = shares_;
521         _totalShares = _totalShares + shares_;
522         emit PayeeAdded(account, shares_);
523     }
524 }
525 
526 // File: IERC721Receiver.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
547      */
548     function onERC721Received(
549         address operator,
550         address from,
551         uint256 tokenId,
552         bytes calldata data
553     ) external returns (bytes4);
554 }
555 
556 // File: IERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Interface of the ERC165 standard, as defined in the
565  * https://eips.ethereum.org/EIPS/eip-165[EIP].
566  *
567  * Implementers can declare support of contract interfaces, which can then be
568  * queried by others ({ERC165Checker}).
569  *
570  * For an implementation, see {ERC165}.
571  */
572 interface IERC165 {
573     /**
574      * @dev Returns true if this contract implements the interface defined by
575      * `interfaceId`. See the corresponding
576      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
577      * to learn more about how these ids are created.
578      *
579      * This function call must use less than 30 000 gas.
580      */
581     function supportsInterface(bytes4 interfaceId) external view returns (bool);
582 }
583 
584 // File: ERC165.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 // File: IERC721.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Required interface of an ERC721 compliant contract.
625  */
626 interface IERC721 is IERC165 {
627     /**
628      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
629      */
630     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
631 
632     /**
633      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
634      */
635     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
639      */
640     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
641 
642     /**
643      * @dev Returns the number of tokens in ``owner``'s account.
644      */
645     function balanceOf(address owner) external view returns (uint256 balance);
646 
647     /**
648      * @dev Returns the owner of the `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function ownerOf(uint256 tokenId) external view returns (address owner);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
658      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Transfers `tokenId` token from `from` to `to`.
678      *
679      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Approve or remove `operator` as an operator for the caller.
722      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
734      *
735      * See {setApprovalForAll}
736      */
737     function isApprovedForAll(address owner, address operator) external view returns (bool);
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`.
741      *
742      * Requirements:
743      *
744      * - `from` cannot be the zero address.
745      * - `to` cannot be the zero address.
746      * - `tokenId` token must exist and be owned by `from`.
747      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes calldata data
757     ) external;
758 }
759 
760 // File: IERC721Metadata.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 }
788 
789 // File: ERC721.sol
790 
791 
792 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
793 
794 /**
795  * Minimalist iteration of the OpenZeppelin ERC721 Contract. Consolidates functionality,
796  * abandons before and after token transfer hooks, and eliminates unnecessary features
797  * which are not officially part of the standard.
798  * 
799  * Some changes made to variable visibility to minimize overrides in main contract.
800  */
801 
802 pragma solidity ^0.8.0;
803 
804 
805 
806 
807 
808 
809 contract ERC721 is ERC165, IERC721, IERC721Metadata {
810     using Address for address;
811 
812     // Token Index
813     uint256 _tokenIndex;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to owner address
822     mapping(uint256 => address) public _owners;
823 
824     // Mapping owner address to token count
825     mapping(address => uint256) public _balances;
826 
827     // Mapping owner address to minted count
828     mapping(address => uint256) public _minted;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     // Freeze event for metadata
837     event PermanentURI(string _value, uint256 indexed _id);
838 
839     /**
840      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
841      */
842     function ERC721Init(string memory name_, string memory symbol_) internal {
843         _name = name_;
844         _symbol = symbol_;
845     }
846 
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
851         return
852             interfaceId == type(IERC721).interfaceId ||
853             interfaceId == type(IERC721Metadata).interfaceId ||
854             super.supportsInterface(interfaceId);
855     }
856 
857     function totalSupply() public view returns (uint256) {
858         return _tokenIndex;
859     }
860 
861     /**
862      * @dev See {IERC721-balanceOf}.
863      */
864     function balanceOf(address owner) public view virtual override returns (uint256) {
865         require(owner != address(0), "ERC721: balance query for the zero address");
866         return _balances[owner];
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
873         address owner = _owners[tokenId];
874         require(owner != address(0), "ERC721: owner query for nonexistent token");
875         return owner;
876     }
877 
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
880         return "";
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-name}.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-symbol}.
892      */
893     function symbol() public view virtual override returns (string memory) {
894         return _symbol;
895     }
896 
897     // Overridden ownerOf
898     function approve(address to, uint256 tokenId) public virtual override {
899         address owner = ownerOf(tokenId);
900         require(to != owner, "ERC721: approval to current owner");
901 
902         require(
903             msg.sender == owner || isApprovedForAll(owner, msg.sender),
904             "ERC721: approve caller is not owner nor approved for all"
905         );
906 
907         _approve(to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view virtual override returns (address) {
914         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         _setApprovalForAll(msg.sender, operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     function _exists(uint256 tokenId) internal view virtual returns (bool) {
934         return 0 < tokenId && tokenId < 4013;
935     }
936 
937     // Removed ERC721 specifier to use overridden ownerOf function
938     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
939         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
940         address owner = ownerOf(tokenId);
941         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
942     }
943 
944     // Owner Of changed to use overridden function
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Approve `operator` to operate on all of `owner` tokens
952      *
953      * Emits a {ApprovalForAll} event.
954      */
955     function _setApprovalForAll(
956         address owner,
957         address operator,
958         bool approved
959     ) internal virtual {
960         require(owner != operator, "ERC721: approve to caller");
961         _operatorApprovals[owner][operator] = approved;
962         emit ApprovalForAll(owner, operator, approved);
963     }
964 
965     // OpenZeppelin _mint function overriden to support quantity. This reduces
966     // writes to storage and simplifies code.
967     //
968     // Flag added to allow selection between "safe" and "unsafe" mint with one
969     // function.
970 
971     function _mint(address to, uint256 quantity, uint256 safeMint, bytes memory data) internal virtual {
972         require(to != address(0), "ERC721: mint to the zero address");
973 
974         // Reading tokenIndex into memory, and then updating
975         // balances and stored index one time is more gas
976         // efficient.
977         uint256 mintIndex = _tokenIndex;
978         _minted[to] += quantity;
979         _tokenIndex += quantity;
980 
981         // Mint new tokens.
982         for (uint256 i = 0; i < quantity; i++) {
983             mintIndex++;
984             _owners[mintIndex] = to;
985             emit Transfer(address(0), to, mintIndex);
986             emit PermanentURI("https://frenlyflyz.io/ffmp-token-metadata/", mintIndex);
987 
988             if (safeMint == 1) {
989                 require(
990                     _checkOnERC721Received(address(0), to, mintIndex, data),
991                     "ERC721: transfer to non ERC721Receiver implementer"
992                 );
993             }
994         }
995     }
996 
997     /**
998      * @dev See {IERC721-transferFrom}.
999      */
1000     function transferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) public virtual override {
1005         //solhint-disable-next-line max-line-length
1006         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1007 
1008         _transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, "");
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public virtual override {
1031         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1032         _safeTransfer(from, to, tokenId, _data);
1033     }
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1040      *
1041      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1042      * implement alternative mechanisms to perform token transfer, such as signature-based.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must exist and be owned by `from`.
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) internal virtual {
1059         _transfer(from, to, tokenId);
1060         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1061     }
1062 
1063     //Function overridden in main contract.
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual {
1069         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1070         require(to != address(0), "ERC721: transfer to the zero address");
1071 
1072         // Clear approvals from the previous owner
1073         _approve(address(0), tokenId);
1074 
1075         _balances[from] -= 1;
1076         _balances[to] += 1;
1077         _owners[tokenId] = to;
1078 
1079         emit Transfer(from, to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1084      * The call is not executed if the target address is not a contract.
1085      *
1086      * @param from address representing the previous owner of the given token ID
1087      * @param to target address that will receive the tokens
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @param _data bytes optional data to send along with the call
1090      * @return bool whether the call correctly returned the expected magic value
1091      */
1092     function _checkOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         if (to.isContract()) {
1099             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1100                 return retval == IERC721Receiver.onERC721Received.selector;
1101             } catch (bytes memory reason) {
1102                 if (reason.length == 0) {
1103                     revert("ERC721: transfer to non ERC721Receiver implementer");
1104                 } else {
1105                     assembly {
1106                         revert(add(32, reason), mload(reason))
1107                     }
1108                 }
1109             }
1110         } else {
1111             return true;
1112         }
1113     }
1114 }
1115 
1116 // File: ECDSA.sol
1117 
1118 
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 /**
1123  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1124  *
1125  * These functions can be used to verify that a message was signed by the holder
1126  * of the private keys of a given address.
1127  */
1128 library ECDSA {
1129     enum RecoverError {
1130         NoError,
1131         InvalidSignature,
1132         InvalidSignatureLength,
1133         InvalidSignatureS,
1134         InvalidSignatureV
1135     }
1136 
1137     function _throwError(RecoverError error) private pure {
1138         if (error == RecoverError.NoError) {
1139             return; // no error: do nothing
1140         } else if (error == RecoverError.InvalidSignature) {
1141             revert("ECDSA: invalid signature");
1142         } else if (error == RecoverError.InvalidSignatureLength) {
1143             revert("ECDSA: invalid signature length");
1144         } else if (error == RecoverError.InvalidSignatureS) {
1145             revert("ECDSA: invalid signature 's' value");
1146         } else if (error == RecoverError.InvalidSignatureV) {
1147             revert("ECDSA: invalid signature 'v' value");
1148         }
1149     }
1150 
1151     /**
1152      * @dev Returns the address that signed a hashed message (`hash`) with
1153      * `signature` or error string. This address can then be used for verification purposes.
1154      *
1155      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1156      * this function rejects them by requiring the `s` value to be in the lower
1157      * half order, and the `v` value to be either 27 or 28.
1158      *
1159      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1160      * verification to be secure: it is possible to craft signatures that
1161      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1162      * this is by receiving a hash of the original message (which may otherwise
1163      * be too long), and then calling {toEthSignedMessageHash} on it.
1164      *
1165      * Documentation for signature generation:
1166      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1167      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1168      *
1169      * _Available since v4.3._
1170      */
1171     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1172         // Check the signature length
1173         // - case 65: r,s,v signature (standard)
1174         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1175         if (signature.length == 65) {
1176             bytes32 r;
1177             bytes32 s;
1178             uint8 v;
1179             // ecrecover takes the signature parameters, and the only way to get them
1180             // currently is to use assembly.
1181             assembly {
1182                 r := mload(add(signature, 0x20))
1183                 s := mload(add(signature, 0x40))
1184                 v := byte(0, mload(add(signature, 0x60)))
1185             }
1186             return tryRecover(hash, v, r, s);
1187         } else if (signature.length == 64) {
1188             bytes32 r;
1189             bytes32 vs;
1190             // ecrecover takes the signature parameters, and the only way to get them
1191             // currently is to use assembly.
1192             assembly {
1193                 r := mload(add(signature, 0x20))
1194                 vs := mload(add(signature, 0x40))
1195             }
1196             return tryRecover(hash, r, vs);
1197         } else {
1198             return (address(0), RecoverError.InvalidSignatureLength);
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns the address that signed a hashed message (`hash`) with
1204      * `signature`. This address can then be used for verification purposes.
1205      *
1206      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1207      * this function rejects them by requiring the `s` value to be in the lower
1208      * half order, and the `v` value to be either 27 or 28.
1209      *
1210      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1211      * verification to be secure: it is possible to craft signatures that
1212      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1213      * this is by receiving a hash of the original message (which may otherwise
1214      * be too long), and then calling {toEthSignedMessageHash} on it.
1215      */
1216     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1217         (address recovered, RecoverError error) = tryRecover(hash, signature);
1218         _throwError(error);
1219         return recovered;
1220     }
1221 
1222     /**
1223      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1224      *
1225      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1226      *
1227      * _Available since v4.3._
1228      */
1229     function tryRecover(
1230         bytes32 hash,
1231         bytes32 r,
1232         bytes32 vs
1233     ) internal pure returns (address, RecoverError) {
1234         bytes32 s;
1235         uint8 v;
1236         assembly {
1237             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1238             v := add(shr(255, vs), 27)
1239         }
1240         return tryRecover(hash, v, r, s);
1241     }
1242 
1243     /**
1244      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1245      *
1246      * _Available since v4.2._
1247      */
1248     function recover(
1249         bytes32 hash,
1250         bytes32 r,
1251         bytes32 vs
1252     ) internal pure returns (address) {
1253         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1254         _throwError(error);
1255         return recovered;
1256     }
1257 
1258     /**
1259      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1260      * `r` and `s` signature fields separately.
1261      *
1262      * _Available since v4.3._
1263      */
1264     function tryRecover(
1265         bytes32 hash,
1266         uint8 v,
1267         bytes32 r,
1268         bytes32 s
1269     ) internal pure returns (address, RecoverError) {
1270         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1271         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1272         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1273         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1274         //
1275         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1276         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1277         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1278         // these malleable signatures as well.
1279         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1280             return (address(0), RecoverError.InvalidSignatureS);
1281         }
1282         if (v != 27 && v != 28) {
1283             return (address(0), RecoverError.InvalidSignatureV);
1284         }
1285 
1286         // If the signature is valid (and not malleable), return the signer address
1287         address signer = ecrecover(hash, v, r, s);
1288         if (signer == address(0)) {
1289             return (address(0), RecoverError.InvalidSignature);
1290         }
1291 
1292         return (signer, RecoverError.NoError);
1293     }
1294 
1295     /**
1296      * @dev Overload of {ECDSA-recover} that receives the `v`,
1297      * `r` and `s` signature fields separately.
1298      */
1299     function recover(
1300         bytes32 hash,
1301         uint8 v,
1302         bytes32 r,
1303         bytes32 s
1304     ) internal pure returns (address) {
1305         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1306         _throwError(error);
1307         return recovered;
1308     }
1309 
1310     /**
1311      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1312      * produces hash corresponding to the one signed with the
1313      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1314      * JSON-RPC method as part of EIP-191.
1315      *
1316      * See {recover}.
1317      */
1318     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1319         // 32 is the length in bytes of hash,
1320         // enforced by the type signature above
1321         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1322     }
1323 
1324     /**
1325      * @dev Returns an Ethereum Signed Typed Data, created from a
1326      * `domainSeparator` and a `structHash`. This produces hash corresponding
1327      * to the one signed with the
1328      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1329      * JSON-RPC method as part of EIP-712.
1330      *
1331      * See {recover}.
1332      */
1333     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1334         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1335     }
1336 }
1337 // File: FrenlyFlyzFlyDrop.sol
1338 
1339 
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 
1344 
1345 
1346 
1347 
1348 contract OwnableDelegateProxy { }
1349 
1350 contract ProxyRegistry {
1351     mapping(address => OwnableDelegateProxy) public proxies;
1352 }
1353 
1354 contract FLYDrop is ERC721, Ownable, PaymentSplitter {
1355     // Libraries
1356     using ECDSA for bytes32;
1357     using Strings for uint256;
1358 
1359     bool private _airdropDone;
1360     address _openSea;
1361     ERC721 _ffmp;
1362 
1363     address[] foundingFlyz;
1364     uint256[] foundingShares;
1365 
1366     constructor()
1367     {
1368         OwnableInit();
1369         ERC721Init("Frenly Flyz", "FLYZ");
1370         _ffmp = ERC721(0x38CA49B6dfA820bCa917A60995cC07b88Db7dC4D);
1371         _openSea = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1372 
1373         foundingFlyz = [
1374             0xeE24c06ae9469E29Fc0107048C2B4e806970ecdA,
1375             0x7d6F7FB391CD36BAde7baa7465581d9826a8D97D,
1376             0x665C5C08465E7c52DCD869a5998E11D8A6CdE361,
1377             0x9A665fb3fFB5906F47C438716D1E009767F96BBD,
1378             0x60916B17F8B0B9194baa5eCA43b7E1583b99A714,
1379             0xDAcb094be451A45D6C54fB18Eed1931D04F5793c,
1380             0xc2DfCFa2Bf1C871cB5af60b7eFBd95864984129D,
1381             0x155a3b74c26955Ca5174500A8f83947d7793bDd2,
1382             0xbB599fbd3BB5ce9326EA50dE38D09D5B946B24C1 
1383         ];
1384 
1385         foundingShares = [
1386             20,
1387             23,
1388             15,
1389             15,
1390             9,
1391             9,
1392             6,
1393             5,
1394             3
1395         ];
1396 
1397         SplitterInit(foundingFlyz,foundingShares);
1398     }
1399 
1400     function contractURI() public pure returns (string memory) {
1401         return "https://frenlyflyz.io/ff-collection-metadata/";
1402     }
1403 
1404     // *********************************************************************************************
1405     // Begin overrides to accomodate virtual owners information until owners are committed to state.
1406     // *********************************************************************************************
1407     function tokenURI(uint256 tokenId) public pure override(ERC721) returns (string memory) {
1408         // Since _owners starts empty but this contract represents 4012 NFTs, change the
1409         // exists check for tokenURI.
1410         require(0 < tokenId && tokenId < 4013, "Doesn't exist!");
1411         return string(abi.encodePacked("ipfs://QmSgeFjJWkUkGRMvGDZHGd52VTi1L8yjMMtQaBxXXaC9nV/", tokenId.toString(), ".json"));
1412     }
1413 
1414     function ownerOf(uint256 tokenId) public view virtual override(ERC721) returns (address) {
1415         // Since _owners starts empty but this contract represents 4012 NFTs, change the
1416         // exists check for tokenURI.
1417         require(0 < tokenId && tokenId < 4013, "Doesn't exist!");
1418 
1419         address owner = _owners[tokenId];
1420         if (owner != address(0)) {
1421             return owner;
1422         } else {
1423             return _ffmp.ownerOf(tokenId);
1424         }
1425     }
1426 
1427     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual override(ERC721) returns (bool) {
1428         require(0 < tokenId && tokenId < 4013, "ERC721: operator query for nonexistent token");
1429         address owner = ownerOf(tokenId);
1430         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1431     }
1432 
1433     // Free OS Listings
1434     function isApprovedForAll(
1435         address owner,
1436         address operator
1437     )
1438         public
1439         view
1440         override(ERC721)
1441         returns (bool)
1442     {
1443         // Whitelist OpenSea proxy contract for easy trading.
1444         ProxyRegistry proxyRegistry = ProxyRegistry(_openSea);
1445         if (address(proxyRegistry.proxies(owner)) == operator) {
1446             return true;
1447         }
1448         
1449         return ERC721.isApprovedForAll(owner, operator);
1450     }
1451 
1452     function _transfer(
1453         address from,
1454         address to,
1455         uint256 tokenId
1456     ) internal virtual override (ERC721) {
1457         require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1458         require(to != address(0), "ERC721: transfer to the zero address");
1459 
1460         // If _balances not yet set from airdrop, then set balance
1461         // equal to balance of mint pass.
1462         if (_balances[from] == 0) {
1463             _balances[from] = _ffmp.balanceOf(from);
1464         }
1465 
1466         // Clear approvals from the previous owner
1467         _approve(address(0), tokenId);
1468 
1469         _balances[from] -= 1;
1470         _balances[to] += 1;
1471         _owners[tokenId] = to;
1472 
1473         emit Transfer(from, to, tokenId);
1474     }
1475 
1476     function transferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId
1480     ) public virtual override(ERC721) {
1481         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1482 
1483         _transfer(from, to, tokenId);
1484     }
1485 
1486     function safeTransferFrom(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) public virtual override(ERC721) {
1491         safeTransferFrom(from, to, tokenId, "");
1492     }
1493 
1494     function safeTransferFrom(
1495         address from,
1496         address to,
1497         uint256 tokenId,
1498         bytes memory _data
1499     ) public virtual override(ERC721) {
1500         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1501         _safeTransfer(from, to, tokenId, _data);
1502     }
1503 
1504     // If _balances for owner is not set in this contract, return balances from mint pass
1505     // contract.
1506     function balanceOf(address owner) public view virtual override(ERC721) returns (uint256) {
1507         require(owner != address(0), "ERC721: balance query for the zero address");
1508         if (_balances[owner] == 0) {
1509             return _ffmp.balanceOf(owner);
1510         } else {
1511             return _balances[owner];
1512         }
1513     }
1514     // *************
1515     // End Overrides
1516     // *************
1517 
1518     function recoverLostFly(uint256 flyId, bytes memory signature) public {
1519         // Take a signed message from frenlyflyz.io server to confirm sender
1520         // was the owner of a pass during the snapshot. If sender was owner,
1521         // and internal _owners check still returns 0 address, then recover
1522         // the lost fly.
1523         //
1524         // If fly is transferred or sold by the new owner of a pass, it cannot
1525         // be recovered to protect future buyers.
1526 
1527         require(_owners[flyId] == address(0), "Cannot recover after transfer :(");
1528 
1529         bytes32 hash = keccak256(abi.encodePacked(
1530                 "\x19Ethereum Signed Message:\n32",
1531                 keccak256(abi.encodePacked(msg.sender, flyId))
1532             ));
1533 
1534         // Value hard coded to reduce SLOAD.
1535         require(
1536             hash.recover(signature) == 0x87A7219276164F5740302c24f5D709830f4Ed91F,
1537                 "Mint not signed!");
1538         
1539         if (_balances[msg.sender] == 0) {
1540             if (ownerOf(flyId) == msg.sender) {
1541                 // For flyz which have not been lost, use the mint pass balance.
1542                 _balances[msg.sender] = _ffmp.balanceOf(msg.sender);
1543             } else {
1544                 // For flyz which were lost, use mint pass balance plus one.
1545                 _balances[msg.sender] = _ffmp.balanceOf(msg.sender) + 1;
1546             }
1547         }
1548 
1549         _owners[flyId] = msg.sender;
1550     }
1551 
1552     function airdrop(uint256 start, uint256 end) public onlyOwner {
1553         uint256 i;
1554         for (i = start; i < end; i++) {
1555             emit Transfer(address(0), _ffmp.ownerOf(i), i);
1556         }
1557     }
1558 
1559     // To restore to previous state after migration.
1560     function adminTransfer(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public onlyOwner {
1565         require(!_airdropDone, "Can't transfer after airdrop is done.");
1566         _transfer(from, to, tokenId);
1567     }
1568 
1569     function finishAirdrop() public onlyOwner {
1570         _airdropDone = true;
1571     }
1572 }