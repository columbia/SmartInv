1 // File: Ownable.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module which provides a basic access control mechanism, where
10  * there is an account (an owner) that can be granted exclusive access to
11  * specific functions.
12  *
13  * By default, the owner account will be the one that deploys the contract. This
14  * can later be changed with {transferOwnership}.
15  *
16  * This module is used through inheritance. It will make available the modifier
17  * `onlyOwner`, which can be applied to your functions to restrict their use to
18  * the owner.
19  */
20 abstract contract Ownable {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor() {
29         _transferOwnership(msg.sender);
30     }
31 
32     /**
33      * @dev Returns the address of the current owner.
34      */
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(owner() == msg.sender, "Ownable: caller is not the owner");
44         _;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * NOTE: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public virtual onlyOwner {
55         _transferOwnership(address(0));
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Internal function without access restriction.
70      */
71     function _transferOwnership(address newOwner) internal virtual {
72         address oldOwner = _owner;
73         _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75     }
76 }
77 
78 // File: Address.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      *
106      * [IMPORTANT]
107      * ====
108      * You shouldn't rely on `isContract` to protect against flash loan attacks!
109      *
110      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
111      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
112      * constructor.
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize/address.code.length, which returns 0
117         // for contracts in construction, since the code is only stored at the end
118         // of the constructor execution.
119 
120         return account.code.length > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 // File: PaymentSplitter.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @title PaymentSplitter
313  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
314  * that the Ether will be split in this way, since it is handled transparently by the contract.
315  *
316  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
317  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
318  * an amount proportional to the percentage of total shares they were assigned.
319  *
320  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
321  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
322  * function.
323  *
324  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
325  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
326  * to run tests before sending real value to this contract.
327  */
328 contract PaymentSplitter {
329     event PayeeAdded(address account, uint256 shares);
330     event PaymentReleased(address to, uint256 amount);
331     event PaymentReceived(address from, uint256 amount);
332 
333     uint256 private _totalShares;
334     uint256 private _totalReleased;
335 
336     mapping(address => uint256) private _shares;
337     mapping(address => uint256) private _released;
338     address[] private _payees;
339 
340     /**
341      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
342      * the matching position in the `shares` array.
343      *
344      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
345      * duplicates in `payees`.
346      */
347     constructor(address[] memory payees, uint256[] memory shares_) payable {
348         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
349         require(payees.length > 0, "PaymentSplitter: no payees");
350 
351         for (uint256 i = 0; i < payees.length; i++) {
352             _addPayee(payees[i], shares_[i]);
353         }
354     }
355 
356     /**
357      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
358      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
359      * reliability of the events, and not the actual splitting of Ether.
360      *
361      * To learn more about this see the Solidity documentation for
362      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
363      * functions].
364      */
365     receive() external payable virtual {
366         emit PaymentReceived(msg.sender, msg.value);
367     }
368 
369     /**
370      * @dev Getter for the total shares held by payees.
371      */
372     function totalShares() public view returns (uint256) {
373         return _totalShares;
374     }
375 
376     /**
377      * @dev Getter for the total amount of Ether already released.
378      */
379     function totalReleased() public view returns (uint256) {
380         return _totalReleased;
381     }
382 
383     /**
384      * @dev Getter for the amount of shares held by an account.
385      */
386     function shares(address account) public view returns (uint256) {
387         return _shares[account];
388     }
389 
390     /**
391      * @dev Getter for the amount of Ether already released to a payee.
392      */
393     function released(address account) public view returns (uint256) {
394         return _released[account];
395     }
396 
397     /**
398      * @dev Getter for the address of the payee number `index`.
399      */
400     function payee(uint256 index) public view returns (address) {
401         return _payees[index];
402     }
403 
404     /**
405      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
406      * total shares and their previous withdrawals.
407      */
408     function release(address payable account) public virtual {
409         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
410 
411         uint256 totalReceived = address(this).balance + totalReleased();
412         uint256 payment = _pendingPayment(account, totalReceived, released(account));
413 
414         require(payment != 0, "PaymentSplitter: account is not due payment");
415 
416         _released[account] += payment;
417         _totalReleased += payment;
418 
419         Address.sendValue(account, payment);
420         emit PaymentReleased(account, payment);
421     }
422 
423     /**
424      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
425      * already released amounts.
426      */
427     function _pendingPayment(
428         address account,
429         uint256 totalReceived,
430         uint256 alreadyReleased
431     ) private view returns (uint256) {
432         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
433     }
434 
435     /**
436      * @dev Add a new payee to the contract.
437      * @param account The address of the payee to add.
438      * @param shares_ The number of shares owned by the payee.
439      */
440     function _addPayee(address account, uint256 shares_) private {
441         require(account != address(0), "PaymentSplitter: account is the zero address");
442         require(shares_ > 0, "PaymentSplitter: shares are 0");
443         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
444 
445         _payees.push(account);
446         _shares[account] = shares_;
447         _totalShares = _totalShares + shares_;
448         emit PayeeAdded(account, shares_);
449     }
450 }
451 
452 // File: IERC721Receiver.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @title ERC721 token receiver interface
461  * @dev Interface for any contract that wants to support safeTransfers
462  * from ERC721 asset contracts.
463  */
464 interface IERC721Receiver {
465     /**
466      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
467      * by `operator` from `from`, this function is called.
468      *
469      * It must return its Solidity selector to confirm the token transfer.
470      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
471      *
472      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
473      */
474     function onERC721Received(
475         address operator,
476         address from,
477         uint256 tokenId,
478         bytes calldata data
479     ) external returns (bytes4);
480 }
481 
482 // File: IERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: ERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 // File: IERC721.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Required interface of an ERC721 compliant contract.
551  */
552 interface IERC721 is IERC165 {
553     /**
554      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
560      */
561     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
565      */
566     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Transfers `tokenId` token from `from` to `to`.
604      *
605      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
624      * The approval is cleared when the token is transferred.
625      *
626      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
627      *
628      * Requirements:
629      *
630      * - The caller must own the token or be an approved operator.
631      * - `tokenId` must exist.
632      *
633      * Emits an {Approval} event.
634      */
635     function approve(address to, uint256 tokenId) external;
636 
637     /**
638      * @dev Returns the account approved for `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function getApproved(uint256 tokenId) external view returns (address operator);
645 
646     /**
647      * @dev Approve or remove `operator` as an operator for the caller.
648      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
649      *
650      * Requirements:
651      *
652      * - The `operator` cannot be the caller.
653      *
654      * Emits an {ApprovalForAll} event.
655      */
656     function setApprovalForAll(address operator, bool _approved) external;
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}
662      */
663     function isApprovedForAll(address owner, address operator) external view returns (bool);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes calldata data
683     ) external;
684 }
685 
686 // File: IERC721Metadata.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Metadata is IERC721 {
699     /**
700      * @dev Returns the token collection name.
701      */
702     function name() external view returns (string memory);
703 
704     /**
705      * @dev Returns the token collection symbol.
706      */
707     function symbol() external view returns (string memory);
708 
709     /**
710      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
711      */
712     function tokenURI(uint256 tokenId) external view returns (string memory);
713 }
714 
715 // File: ERC721.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
719 
720 /**
721  * Minimalist iteration of the OpenZeppelin ERC721 Contract. Consolidates functionality,
722  * abandons before and after token transfer hooks, and eliminates unnecessary features
723  * which are not officially part of the standard.
724  *
725  * Some changes made to variable visibility to minimize overrides in main contract.
726  */
727 
728 pragma solidity ^0.8.0;
729 
730 
731 
732 
733 
734 
735 contract ERC721 is ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737 
738     // Token Index
739     uint256 _tokenIndex;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) public _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) public _balances;
752 
753     // Mapping owner address to minted count
754     mapping(address => uint256) public _minted;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     // Freeze event for metadata
763     event PermanentURI(string _value, uint256 indexed _id);
764 
765     /**
766      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
767      */
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771     }
772 
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return
778             interfaceId == type(IERC721).interfaceId ||
779             interfaceId == type(IERC721Metadata).interfaceId ||
780             super.supportsInterface(interfaceId);
781     }
782 
783     function totalSupply() public view returns (uint256) {
784         return _tokenIndex;
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view virtual override returns (uint256) {
791         require(owner != address(0), "ERC721: balance query for the zero address");
792         return _balances[owner];
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         address owner = _owners[tokenId];
800         require(owner != address(0), "ERC721: owner query for nonexistent token");
801         return owner;
802     }
803 
804     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
805         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
806         return "";
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             msg.sender == owner || isApprovedForAll(owner, msg.sender),
832             "ERC721: approve caller is not owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(msg.sender, operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
862         return _owners[tokenId] != address(0);
863     }
864 
865     /**
866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
873         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
874         address owner = ERC721.ownerOf(tokenId);
875         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
876     }
877 
878     /**
879      * @dev Approve `to` to operate on `tokenId`
880      *
881      * Emits a {Approval} event.
882      */
883     function _approve(address to, uint256 tokenId) internal virtual {
884         _tokenApprovals[tokenId] = to;
885         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
886     }
887 
888     /**
889      * @dev Approve `operator` to operate on all of `owner` tokens
890      *
891      * Emits a {ApprovalForAll} event.
892      */
893     function _setApprovalForAll(
894         address owner,
895         address operator,
896         bool approved
897     ) internal virtual {
898         require(owner != operator, "ERC721: approve to caller");
899         _operatorApprovals[owner][operator] = approved;
900         emit ApprovalForAll(owner, operator, approved);
901     }
902 
903     // OpenZeppelin _mint function overriden to support quantity. This reduces
904     // writes to storage and simplifies code.
905     //
906     // Flag added to allow selection between "safe" and "unsafe" mint with one
907     // function.
908 
909     function _mint(address to, uint256 quantity, uint256 safeMint, bytes memory data) internal virtual {
910         require(to != address(0), "ERC721: mint to the zero address");
911 
912         // Reading tokenIndex into memory, and then updating
913         // balances and stored index one time is more gas
914         // efficient.
915         uint256 mintIndex = _tokenIndex;
916         _minted[to] += quantity;
917         _tokenIndex += quantity;
918 
919         // Mint new tokens.
920         for (uint256 i = 0; i < quantity; i++) {
921             mintIndex++;
922             _owners[mintIndex] = to;
923             emit Transfer(address(0), to, mintIndex);
924             emit PermanentURI("https://frenlyflyz.io/ffmp-token-metadata/", mintIndex);
925 
926             if (safeMint == 1) {
927                 require(
928                     _checkOnERC721Received(address(0), to, mintIndex, data),
929                     "ERC721: transfer to non ERC721Receiver implementer"
930                 );
931             }
932         }
933     }
934 
935     /**
936      * @dev See {IERC721-transferFrom}.
937      */
938     function transferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         //solhint-disable-next-line max-line-length
944         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
945 
946         _transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         safeTransferFrom(from, to, tokenId, "");
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) public virtual override {
969         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
970         _safeTransfer(from, to, tokenId, _data);
971     }
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
975      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
976      *
977      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
978      *
979      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
980      * implement alternative mechanisms to perform token transfer, such as signature-based.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeTransfer(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _transfer(from, to, tokenId);
998         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) internal virtual {
1017         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1018         require(to != address(0), "ERC721: transfer to the zero address");
1019 
1020         // Clear approvals from the previous owner
1021         _approve(address(0), tokenId);
1022 
1023         _balances[from] -= 1;
1024         _balances[to] += 1;
1025         _owners[tokenId] = to;
1026 
1027         emit Transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1032      * The call is not executed if the target address is not a contract.
1033      *
1034      * @param from address representing the previous owner of the given token ID
1035      * @param to target address that will receive the tokens
1036      * @param tokenId uint256 ID of the token to be transferred
1037      * @param _data bytes optional data to send along with the call
1038      * @return bool whether the call correctly returned the expected magic value
1039      */
1040     function _checkOnERC721Received(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) private returns (bool) {
1046         if (to.isContract()) {
1047             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1048                 return retval == IERC721Receiver.onERC721Received.selector;
1049             } catch (bytes memory reason) {
1050                 if (reason.length == 0) {
1051                     revert("ERC721: transfer to non ERC721Receiver implementer");
1052                 } else {
1053                     assembly {
1054                         revert(add(32, reason), mload(reason))
1055                     }
1056                 }
1057             }
1058         } else {
1059             return true;
1060         }
1061     }
1062 }
1063 
1064 // File: ECDSA.sol
1065 
1066 
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 /**
1071  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1072  *
1073  * These functions can be used to verify that a message was signed by the holder
1074  * of the private keys of a given address.
1075  */
1076 library ECDSA {
1077     enum RecoverError {
1078         NoError,
1079         InvalidSignature,
1080         InvalidSignatureLength,
1081         InvalidSignatureS,
1082         InvalidSignatureV
1083     }
1084 
1085     function _throwError(RecoverError error) private pure {
1086         if (error == RecoverError.NoError) {
1087             return; // no error: do nothing
1088         } else if (error == RecoverError.InvalidSignature) {
1089             revert("ECDSA: invalid signature");
1090         } else if (error == RecoverError.InvalidSignatureLength) {
1091             revert("ECDSA: invalid signature length");
1092         } else if (error == RecoverError.InvalidSignatureS) {
1093             revert("ECDSA: invalid signature 's' value");
1094         } else if (error == RecoverError.InvalidSignatureV) {
1095             revert("ECDSA: invalid signature 'v' value");
1096         }
1097     }
1098 
1099     /**
1100      * @dev Returns the address that signed a hashed message (`hash`) with
1101      * `signature` or error string. This address can then be used for verification purposes.
1102      *
1103      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1104      * this function rejects them by requiring the `s` value to be in the lower
1105      * half order, and the `v` value to be either 27 or 28.
1106      *
1107      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1108      * verification to be secure: it is possible to craft signatures that
1109      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1110      * this is by receiving a hash of the original message (which may otherwise
1111      * be too long), and then calling {toEthSignedMessageHash} on it.
1112      *
1113      * Documentation for signature generation:
1114      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1115      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1116      *
1117      * _Available since v4.3._
1118      */
1119     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1120         // Check the signature length
1121         // - case 65: r,s,v signature (standard)
1122         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1123         if (signature.length == 65) {
1124             bytes32 r;
1125             bytes32 s;
1126             uint8 v;
1127             // ecrecover takes the signature parameters, and the only way to get them
1128             // currently is to use assembly.
1129             assembly {
1130                 r := mload(add(signature, 0x20))
1131                 s := mload(add(signature, 0x40))
1132                 v := byte(0, mload(add(signature, 0x60)))
1133             }
1134             return tryRecover(hash, v, r, s);
1135         } else if (signature.length == 64) {
1136             bytes32 r;
1137             bytes32 vs;
1138             // ecrecover takes the signature parameters, and the only way to get them
1139             // currently is to use assembly.
1140             assembly {
1141                 r := mload(add(signature, 0x20))
1142                 vs := mload(add(signature, 0x40))
1143             }
1144             return tryRecover(hash, r, vs);
1145         } else {
1146             return (address(0), RecoverError.InvalidSignatureLength);
1147         }
1148     }
1149 
1150     /**
1151      * @dev Returns the address that signed a hashed message (`hash`) with
1152      * `signature`. This address can then be used for verification purposes.
1153      *
1154      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1155      * this function rejects them by requiring the `s` value to be in the lower
1156      * half order, and the `v` value to be either 27 or 28.
1157      *
1158      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1159      * verification to be secure: it is possible to craft signatures that
1160      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1161      * this is by receiving a hash of the original message (which may otherwise
1162      * be too long), and then calling {toEthSignedMessageHash} on it.
1163      */
1164     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1165         (address recovered, RecoverError error) = tryRecover(hash, signature);
1166         _throwError(error);
1167         return recovered;
1168     }
1169 
1170     /**
1171      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1172      *
1173      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1174      *
1175      * _Available since v4.3._
1176      */
1177     function tryRecover(
1178         bytes32 hash,
1179         bytes32 r,
1180         bytes32 vs
1181     ) internal pure returns (address, RecoverError) {
1182         bytes32 s;
1183         uint8 v;
1184         assembly {
1185             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1186             v := add(shr(255, vs), 27)
1187         }
1188         return tryRecover(hash, v, r, s);
1189     }
1190 
1191     /**
1192      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1193      *
1194      * _Available since v4.2._
1195      */
1196     function recover(
1197         bytes32 hash,
1198         bytes32 r,
1199         bytes32 vs
1200     ) internal pure returns (address) {
1201         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1202         _throwError(error);
1203         return recovered;
1204     }
1205 
1206     /**
1207      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1208      * `r` and `s` signature fields separately.
1209      *
1210      * _Available since v4.3._
1211      */
1212     function tryRecover(
1213         bytes32 hash,
1214         uint8 v,
1215         bytes32 r,
1216         bytes32 s
1217     ) internal pure returns (address, RecoverError) {
1218         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1219         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1220         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1221         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1222         //
1223         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1224         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1225         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1226         // these malleable signatures as well.
1227         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1228             return (address(0), RecoverError.InvalidSignatureS);
1229         }
1230         if (v != 27 && v != 28) {
1231             return (address(0), RecoverError.InvalidSignatureV);
1232         }
1233 
1234         // If the signature is valid (and not malleable), return the signer address
1235         address signer = ecrecover(hash, v, r, s);
1236         if (signer == address(0)) {
1237             return (address(0), RecoverError.InvalidSignature);
1238         }
1239 
1240         return (signer, RecoverError.NoError);
1241     }
1242 
1243     /**
1244      * @dev Overload of {ECDSA-recover} that receives the `v`,
1245      * `r` and `s` signature fields separately.
1246      */
1247     function recover(
1248         bytes32 hash,
1249         uint8 v,
1250         bytes32 r,
1251         bytes32 s
1252     ) internal pure returns (address) {
1253         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1254         _throwError(error);
1255         return recovered;
1256     }
1257 
1258     /**
1259      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1260      * produces hash corresponding to the one signed with the
1261      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1262      * JSON-RPC method as part of EIP-191.
1263      *
1264      * See {recover}.
1265      */
1266     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1267         // 32 is the length in bytes of hash,
1268         // enforced by the type signature above
1269         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1270     }
1271 
1272     /**
1273      * @dev Returns an Ethereum Signed Typed Data, created from a
1274      * `domainSeparator` and a `structHash`. This produces hash corresponding
1275      * to the one signed with the
1276      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1277      * JSON-RPC method as part of EIP-712.
1278      *
1279      * See {recover}.
1280      */
1281     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1282         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1283     }
1284 }
1285 // File: FrenlyFlyz.sol
1286 
1287 
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 
1292 
1293 
1294 
1295 contract OwnableDelegateProxy { }
1296 
1297 contract ProxyRegistry {
1298     mapping(address => OwnableDelegateProxy) public proxies;
1299 }
1300 
1301 contract FlyPass is ERC721, Ownable, PaymentSplitter {
1302     // Libraries
1303     using ECDSA for bytes32;
1304 
1305     bool _stopMint;
1306 
1307     // Define critical mint parameters
1308     uint256 _walletLimit;
1309     uint256 _mintPrice;
1310     uint256 _startingBlock;
1311     uint256 _maxSupply;
1312 
1313     address _devWallet;
1314 
1315     address _openSea = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1316 
1317     address[] foundingFlyz = [
1318         0xeE24c06ae9469E29Fc0107048C2B4e806970ecdA,
1319         0x7d6F7FB391CD36BAde7baa7465581d9826a8D97D,
1320         0x665C5C08465E7c52DCD869a5998E11D8A6CdE361,
1321         0x9A665fb3fFB5906F47C438716D1E009767F96BBD,
1322         0x60916B17F8B0B9194baa5eCA43b7E1583b99A714,
1323         0xDAcb094be451A45D6C54fB18Eed1931D04F5793c,
1324         0xc2DfCFa2Bf1C871cB5af60b7eFBd95864984129D,
1325         0x155a3b74c26955Ca5174500A8f83947d7793bDd2,
1326         0xbB599fbd3BB5ce9326EA50dE38D09D5B946B24C1
1327     ];
1328 
1329     uint256[] foundingShares = [
1330         27,
1331         20,
1332         15,
1333         15,
1334         5,
1335         5,
1336         5,
1337         5,
1338         3
1339     ];
1340 
1341     // Constructor
1342     constructor
1343     (address devWallet)
1344     ERC721("FLY Pass", "FFMP")
1345     PaymentSplitter(foundingFlyz,foundingShares)
1346     {
1347         _devWallet = devWallet;
1348     }
1349 
1350     // Strictly for UI purposes.
1351     function maxSupply(uint256 startingBlock, uint256 currentBlock) internal view returns (uint256) {
1352         uint256 currentMaxSupply;
1353         if (startingBlock > currentBlock || _stopMint) {
1354             return 0;
1355         } else {
1356             uint256 blocksElapsed = currentBlock - startingBlock;
1357             if (blocksElapsed < 5760) {
1358                 currentMaxSupply = 2858;
1359             } else if (blocksElapsed < 7200) {
1360                 currentMaxSupply = 8888;
1361             } else if (blocksElapsed < 8640) {
1362                 currentMaxSupply = 7888;
1363             } else if (blocksElapsed < 10080) {
1364                 currentMaxSupply = 6888;
1365             } else if (blocksElapsed < 11520) {
1366                 currentMaxSupply = 5888;
1367             } else if (blocksElapsed < 12960) {
1368                 currentMaxSupply = 4888;
1369             } else if (blocksElapsed < 14400) {
1370                 currentMaxSupply = 3888;
1371             } else if (blocksElapsed < 15840) {
1372                 currentMaxSupply = 2888;
1373             } else if (blocksElapsed < 17280) {
1374                 currentMaxSupply = 1888;
1375             } else {
1376                 currentMaxSupply = 0;
1377             }
1378 
1379             return totalSupply() < currentMaxSupply ? currentMaxSupply : totalSupply();
1380         }
1381     }
1382 
1383     function getMaxSupply() public view returns (uint256) {
1384         return maxSupply(_startingBlock, block.number);
1385     }
1386 
1387     function contractURI() public pure returns (string memory) {
1388         return "https://frenlyflyz.io/ffmp-collection-metadata/";
1389     }
1390 
1391     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1392         require(_exists(tokenId), "Doesn't exist!");
1393         return "ipfs://QmQrcFTeEWWMr5QRzGUT7KqGFotLbsHscRV2HV5SEpuE3z";
1394     }
1395 
1396     // Free OS Listings
1397     function isApprovedForAll(
1398         address owner,
1399         address operator
1400     )
1401         public
1402         view
1403         override(ERC721)
1404         returns (bool)
1405     {
1406         // Whitelist OpenSea proxy contract for easy trading.
1407         ProxyRegistry proxyRegistry = ProxyRegistry(_openSea);
1408         if (address(proxyRegistry.proxies(owner)) == operator) {
1409             return true;
1410         }
1411 
1412         return ERC721.isApprovedForAll(owner, operator);
1413     }
1414 
1415     // To save on gas fees, we write new balances to _minted mapping at mint time.
1416     // On first transfer from account with non-zero _minted value, we copy _minted
1417     // to _balances. Likewise on first transfer to a non-zero minted value. We write
1418     // 10 to the minted count to prevent any further mints, and to signal that
1419     // balances have been synchronized with minted quantity.
1420     function _transfer(
1421         address from,
1422         address to,
1423         uint256 tokenId
1424     ) internal virtual override (ERC721) {
1425         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1426         require(to != address(0), "ERC721: transfer to the zero address");
1427 
1428         if (_minted[from] != 0 && _minted[from] != 10) {
1429             _balances[from] += _minted[from];
1430             _minted[from] = 10;
1431         }
1432 
1433         // Clear approvals from the previous owner
1434         _approve(address(0), tokenId);
1435 
1436         _balances[from] -= 1;
1437         _balances[to] += 1;
1438         _owners[tokenId] = to;
1439 
1440         emit Transfer(from, to, tokenId);
1441     }
1442 
1443     function balanceOf(address owner) public view virtual override(ERC721) returns (uint256) {
1444         require(owner != address(0), "ERC721: balance query for the zero address");
1445         if (_minted[owner] != 10) {
1446             return _balances[owner] + _minted[owner];
1447         } else {
1448             return _balances[owner];
1449         }
1450     }
1451 
1452     // Expected starting block is 14149694
1453     function startMint(uint256 startingBlock) public onlyOwner {
1454         require(totalSupply() == 0, "Cannot restart mint!");
1455         // We mint to dev wallet so we don't need to implement safe mint, which
1456         // causes more problems than not. Tokens will be transferred to gnosis
1457         // asap.
1458         _mint(_devWallet, 188, 1, "");
1459         _startingBlock = startingBlock;
1460     }
1461 
1462     function stopMint() public onlyOwner {
1463         _stopMint = true;
1464     }
1465 
1466     function mint(uint256 rawQuantity, uint256 mintType, bytes memory signature) public payable {
1467         // No total supply check on FL mint, since supply is artificially limited
1468         // to ensure FL members can obtain a maximum of 2500 NFTs in total. Supply
1469         // constraints achieved cryptographically by restricting entries on fly
1470         // and og lists.
1471         //
1472         // Passes acquired on secondary markets will count against total wallet
1473         // limit. See overridden balanceOf for comments and operation of wallet
1474         // limiting mechanic.
1475         //
1476         // Limit wallets and ensure sale has started.
1477         require(
1478             (block.number > _startingBlock) &&
1479             maxSupply(_startingBlock, block.number) > 0 &&
1480             (7 > balanceOf(msg.sender) + rawQuantity),
1481                 "Mint Not Allowed!");
1482 
1483         bytes32 hash = keccak256(abi.encodePacked(
1484             "\x19Ethereum Signed Message:\n32",
1485             keccak256(abi.encodePacked(msg.sender, mintType, rawQuantity)))
1486           );
1487 
1488         // Values hard coded to reduce SLOAD.
1489         require(
1490             hash.recover(signature) == 0x87A7219276164F5740302c24f5D709830f4Ed91F,
1491                 "Mint not signed!");
1492 
1493         uint256 quantity;
1494 
1495         // Mint type restriction will be imposed by WL administration system. After 24
1496         // hours, OG and Fly pass do not benefit from reduced price, 5 + 1 benefit, or
1497         // the supply check bypass.
1498         require(0 <= mintType && mintType <= 3,
1499             "Hmm");
1500         if (mintType == 0) {
1501             require(msg.value >= rawQuantity * 0.04 ether,
1502                 "Not enough eth");
1503             quantity = rawQuantity;
1504             // Strict supply check imposed on public mint.
1505             require((maxSupply(_startingBlock, block.number) > totalSupply() + quantity),
1506                 "Not enough Supply");
1507         } else if (mintType == 1) {
1508             require(msg.value >= rawQuantity * 0.03 ether,
1509                 "Not enough eth");
1510             // Credit one additional mint if paid for five
1511             quantity = rawQuantity == 5 ? 6 : rawQuantity;
1512         } else if (mintType == 2) {
1513             require(msg.value >= rawQuantity * 0.025 ether,
1514                 "Not enough eth");
1515             // Credit one additional mint if paid for five
1516             quantity = rawQuantity == 5 ? 6 : rawQuantity;
1517         }
1518 
1519         _mint(msg.sender, quantity, 0, "");
1520     }
1521 }