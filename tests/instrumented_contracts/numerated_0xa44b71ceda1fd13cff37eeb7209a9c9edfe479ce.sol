1 // File: moongodnight.sol
2 
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 
10 abstract contract ReentrancyGuard {
11     // Booleans are more expensive than uint256 or any type that takes up a full
12     // word because each write operation emits an extra SLOAD to first read the
13     // slot's contents, replace the bits taken up by the boolean, and then write
14     // back. This is the compiler's defense against contract upgrades and
15     // pointer aliasing, and it cannot be disabled.
16 
17     // The values being non-zero value makes deployment a bit more expensive,
18     // but in exchange the refund on every call to nonReentrant will be lower in
19     // amount. Since refunds are capped to a percentage of the total
20     // transaction's gas, it is best to keep them low in cases like this one, to
21     // increase the likelihood of the full refund coming into effect.
22     uint256 private constant _NOT_ENTERED = 1;
23     uint256 private constant _ENTERED = 2;
24 
25     uint256 private _status;
26 
27     constructor() {
28         _status = _NOT_ENTERED;
29     }
30 
31     /**
32      * @dev Prevents a contract from calling itself, directly or indirectly.
33      * Calling a `nonReentrant` function from another `nonReentrant`
34      * function is not supported. It is possible to prevent this from happening
35      * by making the `nonReentrant` function external, and making it call a
36      * `private` function that does the actual work.
37      */
38     modifier nonReentrant() {
39         // On the first call to nonReentrant, _notEntered will be true
40         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
41 
42         // Any calls to nonReentrant after this point will fail
43         _status = _ENTERED;
44 
45         _;
46 
47         // By storing the original value once again, a refund is triggered (see
48         // https://eips.ethereum.org/EIPS/eip-2200)
49         _status = _NOT_ENTERED;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/utils/Strings.sol
54 
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Context.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 abstract contract Context {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes calldata) {
146         return msg.data;
147     }
148 }
149 
150 // File: @openzeppelin/contracts/access/Ownable.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * By default, the owner account will be the one that deploys the contract. This
164  * can later be changed with {transferOwnership}.
165  *
166  * This module is used through inheritance. It will make available the modifier
167  * `onlyOwner`, which can be applied to your functions to restrict their use to
168  * the owner.
169  */
170 abstract contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     /**
176      * @dev Initializes the contract setting the deployer as the initial owner.
177      */
178     constructor() {
179         _transferOwnership(_msgSender());
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view virtual returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         _transferOwnership(address(0));
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Internal function without access restriction.
220      */
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Address.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
232 
233 pragma solidity ^0.8.1;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269 
270         return account.code.length > 0;
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
453 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 interface IERC721Receiver {
466     /**
467      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
468      * by `operator` from `from`, this function is called.
469      *
470      * It must return its Solidity selector to confirm the token transfer.
471      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
472      *
473      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
474      */
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Interface of the ERC165 standard, as defined in the
492  * https://eips.ethereum.org/EIPS/eip-165[EIP].
493  *
494  * Implementers can declare support of contract interfaces, which can then be
495  * queried by others ({ERC165Checker}).
496  *
497  * For an implementation, see {ERC165}.
498  */
499 interface IERC165 {
500     /**
501      * @dev Returns true if this contract implements the interface defined by
502      * `interfaceId`. See the corresponding
503      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
504      * to learn more about how these ids are created.
505      *
506      * This function call must use less than 30 000 gas.
507      */
508     function supportsInterface(bytes4 interfaceId) external view returns (bool);
509 }
510 
511 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Required interface of an ERC721 compliant contract.
552  */
553 interface IERC721 is IERC165 {
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
566      */
567     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
568 
569     /**
570      * @dev Returns the number of tokens in ``owner``'s account.
571      */
572     function balanceOf(address owner) external view returns (uint256 balance);
573 
574     /**
575      * @dev Returns the owner of the `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function ownerOf(uint256 tokenId) external view returns (address owner);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Transfers `tokenId` token from `from` to `to`.
605      *
606      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
628      *
629      * Requirements:
630      *
631      * - The caller must own the token or be an approved operator.
632      * - `tokenId` must exist.
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address to, uint256 tokenId) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
661      *
662      * See {setApprovalForAll}
663      */
664     function isApprovedForAll(address owner, address operator) external view returns (bool);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes calldata data
684     ) external;
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
697  * @dev See https://eips.ethereum.org/EIPS/eip-721
698  */
699 interface IERC721Metadata is IERC721 {
700     /**
701      * @dev Returns the token collection name.
702      */
703     function name() external view returns (string memory);
704 
705     /**
706      * @dev Returns the token collection symbol.
707      */
708     function symbol() external view returns (string memory);
709 
710     /**
711      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
712      */
713     function tokenURI(uint256 tokenId) external view returns (string memory);
714 }
715 
716 // File: contracts/ERC721A.sol
717 
718 
719 // Creator: Chiru Labs
720 
721 pragma solidity ^0.8.4;
722 
723 
724 
725 
726 
727 
728 
729 
730 error ApprovalCallerNotOwnerNorApproved();
731 error ApprovalQueryForNonexistentToken();
732 error ApproveToCaller();
733 error ApprovalToCurrentOwner();
734 error BalanceQueryForZeroAddress();
735 error MintToZeroAddress();
736 error MintZeroQuantity();
737 error OwnerQueryForNonexistentToken();
738 error TransferCallerNotOwnerNorApproved();
739 error TransferFromIncorrectOwner();
740 error TransferToNonERC721ReceiverImplementer();
741 error TransferToZeroAddress();
742 error URIQueryForNonexistentToken();
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension. Built to optimize for lower gas during batch mints.
747  *
748  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
749  *
750  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
751  *
752  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
753  */
754 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
755     using Address for address;
756     using Strings for uint256;
757 
758     // Compiler will pack this into a single 256bit word.
759     struct TokenOwnership {
760         // The address of the owner.
761         address addr;
762         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
763         uint64 startTimestamp;
764         // Whether the token has been burned.
765         bool burned;
766     }
767 
768     // Compiler will pack this into a single 256bit word.
769     struct AddressData {
770         // Realistically, 2**64-1 is more than enough.
771         uint64 balance;
772         // Keeps track of mint count with minimal overhead for tokenomics.
773         uint64 numberMinted;
774         // Keeps track of burn count with minimal overhead for tokenomics.
775         uint64 numberBurned;
776         // For miscellaneous variable(s) pertaining to the address
777         // (e.g. number of whitelist mint slots used).
778         // If there are multiple variables, please pack them into a uint64.
779         uint64 aux;
780     }
781 
782     // The tokenId of the next token to be minted.
783     uint256 internal _currentIndex;
784 
785     // The number of tokens burned.
786     uint256 internal _burnCounter;
787 
788     // Token name
789     string private _name;
790 
791     // Token symbol
792     string private _symbol;
793 
794     // Mapping from token ID to ownership details
795     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
796     mapping(uint256 => TokenOwnership) internal _ownerships;
797 
798     // Mapping owner address to address data
799     mapping(address => AddressData) private _addressData;
800 
801     // Mapping from token ID to approved address
802     mapping(uint256 => address) private _tokenApprovals;
803 
804     // Mapping from owner to operator approvals
805     mapping(address => mapping(address => bool)) private _operatorApprovals;
806 
807     constructor(string memory name_, string memory symbol_) {
808         _name = name_;
809         _symbol = symbol_;
810         _currentIndex = _startTokenId();
811     }
812 
813     /**
814      * To change the starting tokenId, please override this function.
815      */
816     function _startTokenId() internal view virtual returns (uint256) {
817         return 1;
818     }
819 
820     /**
821      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
822      */
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857         return uint256(_addressData[owner].balance);
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         return uint256(_addressData[owner].numberMinted);
865     }
866 
867     /**
868      * Returns the number of tokens burned by or on behalf of `owner`.
869      */
870     function _numberBurned(address owner) internal view returns (uint256) {
871         return uint256(_addressData[owner].numberBurned);
872     }
873 
874     /**
875      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
876      */
877     function _getAux(address owner) internal view returns (uint64) {
878         return _addressData[owner].aux;
879     }
880 
881     /**
882      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
883      * If there are multiple variables, please pack them into a uint64.
884      */
885     function _setAux(address owner, uint64 aux) internal {
886         _addressData[owner].aux = aux;
887     }
888 
889     /**
890      * Gas spent here starts off proportional to the maximum mint batch size.
891      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
892      */
893     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
894         uint256 curr = tokenId;
895 
896         unchecked {
897             if (_startTokenId() <= curr && curr < _currentIndex) {
898                 TokenOwnership memory ownership = _ownerships[curr];
899                 if (!ownership.burned) {
900                     if (ownership.addr != address(0)) {
901                         return ownership;
902                     }
903                     // Invariant:
904                     // There will always be an ownership that has an address and is not burned
905                     // before an ownership that does not have an address and is not burned.
906                     // Hence, curr will not underflow.
907                     while (true) {
908                         curr--;
909                         ownership = _ownerships[curr];
910                         if (ownership.addr != address(0)) {
911                             return ownership;
912                         }
913                     }
914                 }
915             }
916         }
917         revert OwnerQueryForNonexistentToken();
918     }
919 
920     /**
921      * @dev See {IERC721-ownerOf}.
922      */
923     function ownerOf(uint256 tokenId) public view override returns (address) {
924         return _ownershipOf(tokenId).addr;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-name}.
929      */
930     function name() public view virtual override returns (string memory) {
931         return _name;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-symbol}.
936      */
937     function symbol() public view virtual override returns (string memory) {
938         return _symbol;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-tokenURI}.
943      */
944     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
945         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
946 
947         string memory baseURI = _baseURI();
948         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
949     }
950 
951     /**
952      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
953      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
954      * by default, can be overriden in child contracts.
955      */
956     function _baseURI() internal view virtual returns (string memory) {
957         return '';
958     }
959 
960     /**
961      * @dev See {IERC721-approve}.
962      */
963     function approve(address to, uint256 tokenId) public override {
964         address owner = ERC721A.ownerOf(tokenId);
965         if (to == owner) revert ApprovalToCurrentOwner();
966 
967         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
968             revert ApprovalCallerNotOwnerNorApproved();
969         }
970 
971         _approve(to, tokenId, owner);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view override returns (address) {
978         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved) public virtual override {
987         if (operator == _msgSender()) revert ApproveToCaller();
988 
989         _operatorApprovals[_msgSender()][operator] = approved;
990         emit ApprovalForAll(_msgSender(), operator, approved);
991     }
992 
993     /**
994      * @dev See {IERC721-isApprovedForAll}.
995      */
996     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
997         return _operatorApprovals[owner][operator];
998     }
999 
1000     /**
1001      * @dev See {IERC721-transferFrom}.
1002      */
1003     function transferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
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
1019         safeTransferFrom(from, to, tokenId, '');
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
1031         _transfer(from, to, tokenId);
1032         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1033             revert TransferToNonERC721ReceiverImplementer();
1034         }
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      */
1044     function _exists(uint256 tokenId) internal view returns (bool) {
1045         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1046     }
1047 
1048     /**
1049      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1050      */
1051     function _safeMint(address to, uint256 quantity) internal {
1052         _safeMint(to, quantity, '');
1053     }
1054 
1055     /**
1056      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - If `to` refers to a smart contract, it must implement 
1061      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data
1070     ) internal {
1071         uint256 startTokenId = _currentIndex;
1072         if (to == address(0)) revert MintToZeroAddress();
1073         if (quantity == 0) revert MintZeroQuantity();
1074 
1075         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1076 
1077         // Overflows are incredibly unrealistic.
1078         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1079         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1080         unchecked {
1081             _addressData[to].balance += uint64(quantity);
1082             _addressData[to].numberMinted += uint64(quantity);
1083 
1084             _ownerships[startTokenId].addr = to;
1085             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1086 
1087             uint256 updatedIndex = startTokenId;
1088             uint256 end = updatedIndex + quantity;
1089 
1090             if (to.isContract()) {
1091                 do {
1092                     emit Transfer(address(0), to, updatedIndex);
1093                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1094                         revert TransferToNonERC721ReceiverImplementer();
1095                     }
1096                 } while (updatedIndex != end);
1097                 // Reentrancy protection
1098                 if (_currentIndex != startTokenId) revert();
1099             } else {
1100                 do {
1101                     emit Transfer(address(0), to, updatedIndex++);
1102                 } while (updatedIndex != end);
1103             }
1104             _currentIndex = updatedIndex;
1105         }
1106         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1107     }
1108 
1109     /**
1110      * @dev Mints `quantity` tokens and transfers them to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _mint(address to, uint256 quantity) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are incredibly unrealistic.
1127         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1128         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1129         unchecked {
1130             _addressData[to].balance += uint64(quantity);
1131             _addressData[to].numberMinted += uint64(quantity);
1132 
1133             _ownerships[startTokenId].addr = to;
1134             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1135 
1136             uint256 updatedIndex = startTokenId;
1137             uint256 end = updatedIndex + quantity;
1138 
1139             do {
1140                 emit Transfer(address(0), to, updatedIndex++);
1141             } while (updatedIndex != end);
1142 
1143             _currentIndex = updatedIndex;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) private {
1163         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1164 
1165         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1166 
1167         bool isApprovedOrOwner = (_msgSender() == from ||
1168             isApprovedForAll(from, _msgSender()) ||
1169             getApproved(tokenId) == _msgSender());
1170 
1171         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1172         if (to == address(0)) revert TransferToZeroAddress();
1173 
1174         _beforeTokenTransfers(from, to, tokenId, 1);
1175 
1176         // Clear approvals from the previous owner
1177         _approve(address(0), tokenId, from);
1178 
1179         // Underflow of the sender's balance is impossible because we check for
1180         // ownership above and the recipient's balance can't realistically overflow.
1181         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1182         unchecked {
1183             _addressData[from].balance -= 1;
1184             _addressData[to].balance += 1;
1185 
1186             TokenOwnership storage currSlot = _ownerships[tokenId];
1187             currSlot.addr = to;
1188             currSlot.startTimestamp = uint64(block.timestamp);
1189 
1190             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1191             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1192             uint256 nextTokenId = tokenId + 1;
1193             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1194             if (nextSlot.addr == address(0)) {
1195                 // This will suffice for checking _exists(nextTokenId),
1196                 // as a burned slot cannot contain the zero address.
1197                 if (nextTokenId != _currentIndex) {
1198                     nextSlot.addr = from;
1199                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      * @dev Equivalent to `_burn(tokenId, false)`.
1210      */
1211     function _burn(uint256 tokenId) internal virtual {
1212         _burn(tokenId, false);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1226         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1227 
1228         address from = prevOwnership.addr;
1229 
1230         if (approvalCheck) {
1231             bool isApprovedOrOwner = (_msgSender() == from ||
1232                 isApprovedForAll(from, _msgSender()) ||
1233                 getApproved(tokenId) == _msgSender());
1234 
1235             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1236         }
1237 
1238         _beforeTokenTransfers(from, address(0), tokenId, 1);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId, from);
1242 
1243         // Underflow of the sender's balance is impossible because we check for
1244         // ownership above and the recipient's balance can't realistically overflow.
1245         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1246         unchecked {
1247             AddressData storage addressData = _addressData[from];
1248             addressData.balance -= 1;
1249             addressData.numberBurned += 1;
1250 
1251             // Keep track of who burned the token, and the timestamp of burning.
1252             TokenOwnership storage currSlot = _ownerships[tokenId];
1253             currSlot.addr = from;
1254             currSlot.startTimestamp = uint64(block.timestamp);
1255             currSlot.burned = true;
1256 
1257             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1258             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1259             uint256 nextTokenId = tokenId + 1;
1260             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1261             if (nextSlot.addr == address(0)) {
1262                 // This will suffice for checking _exists(nextTokenId),
1263                 // as a burned slot cannot contain the zero address.
1264                 if (nextTokenId != _currentIndex) {
1265                     nextSlot.addr = from;
1266                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1267                 }
1268             }
1269         }
1270 
1271         emit Transfer(from, address(0), tokenId);
1272         _afterTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1275         unchecked {
1276             _burnCounter++;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(
1286         address to,
1287         uint256 tokenId,
1288         address owner
1289     ) private {
1290         _tokenApprovals[tokenId] = to;
1291         emit Approval(owner, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1296      *
1297      * @param from address representing the previous owner of the given token ID
1298      * @param to target address that will receive the tokens
1299      * @param tokenId uint256 ID of the token to be transferred
1300      * @param _data bytes optional data to send along with the call
1301      * @return bool whether the call correctly returned the expected magic value
1302      */
1303     function _checkContractOnERC721Received(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) private returns (bool) {
1309         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1310             return retval == IERC721Receiver(to).onERC721Received.selector;
1311         } catch (bytes memory reason) {
1312             if (reason.length == 0) {
1313                 revert TransferToNonERC721ReceiverImplementer();
1314             } else {
1315                 assembly {
1316                     revert(add(32, reason), mload(reason))
1317                 }
1318             }
1319         }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324      * And also called before burning one token.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, `tokenId` will be burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      * And also called after one token has been burned.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` has been minted for `to`.
1357      * - When `to` is zero, `tokenId` has been burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _afterTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 }
1367 // File: contracts/GossamerGods.sol
1368 
1369 
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 
1376 
1377 contract moongodnight is ERC721A, Ownable, ReentrancyGuard {
1378   using Address for address;
1379   using Strings for uint;
1380 
1381 
1382   string  public  baseTokenURI = "ipfs://QmZppB4efuou74BBNvyR4LtbHfTV7Zk2QnX5LcNyhwh74V//";
1383   uint256  public  maxSupply = 4444;
1384   uint256 public  MAX_MINTS_PER_TX = 10;
1385   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1386   uint256 public  NUM_FREE_MINTS = 3000;
1387   uint256 public  MAX_FREE_PER_WALLET = 1;
1388   uint256 public freeNFTAlreadyMinted = 0;
1389   bool public isPublicSaleActive = true;
1390 
1391   constructor() ERC721A("MOON GOD NIGHT", "MGN") {
1392   }
1393 
1394 
1395   function mint(uint256 numberOfTokens)
1396       external
1397       payable
1398   {
1399     require(isPublicSaleActive, "Sale is not open");
1400     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more left");
1401 
1402     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1403         require(
1404             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1405             "Incorrect ETH value sent"
1406         );
1407     } else {
1408         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1409         require(
1410             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1411             "Incorrect ETH value sent"
1412         );
1413         require(
1414             numberOfTokens <= MAX_MINTS_PER_TX,
1415             "Max mints per transaction exceeded"
1416         );
1417         } else {
1418             require(
1419                 numberOfTokens <= MAX_FREE_PER_WALLET,
1420                 "Max mints per transaction exceeded"
1421             );
1422             freeNFTAlreadyMinted += numberOfTokens;
1423         }
1424     }
1425     _safeMint(msg.sender, numberOfTokens);
1426   }
1427 
1428   function setBaseURI(string memory baseURI)
1429     public
1430     onlyOwner
1431   {
1432     baseTokenURI = baseURI;
1433   }
1434 
1435   function treasuryMint(uint quantity)
1436     public
1437     onlyOwner
1438   {
1439     require(
1440       quantity > 0,
1441       "Invalid mint amount"
1442     );
1443     require(
1444       totalSupply() + quantity <= maxSupply,
1445       "Maximum supply exceeded"
1446     );
1447     _safeMint(msg.sender, quantity);
1448   }
1449 
1450   function withdraw()
1451     public
1452     onlyOwner
1453     nonReentrant
1454   {
1455     Address.sendValue(payable(msg.sender), address(this).balance);
1456   }
1457 
1458   function tokenURI(uint _tokenId)
1459     public
1460     view
1461     virtual
1462     override
1463     returns (string memory)
1464   {
1465     require(
1466       _exists(_tokenId),
1467       "ERC721Metadata: URI query for nonexistent token"
1468     );
1469     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1470   }
1471 
1472   function _baseURI()
1473     internal
1474     view
1475     virtual
1476     override
1477     returns (string memory)
1478   {
1479     return baseTokenURI;
1480   }
1481 
1482   function setIsPublicSaleActive(bool _isPublicSaleActive)
1483       external
1484       onlyOwner
1485   {
1486       isPublicSaleActive = _isPublicSaleActive;
1487   }
1488 
1489   function setNumFreeMints(uint256 _numfreemints)
1490       external
1491       onlyOwner
1492   {
1493       NUM_FREE_MINTS = _numfreemints;
1494   }
1495 
1496   function setSalePrice(uint256 _price)
1497       external
1498       onlyOwner
1499   {
1500       PUBLIC_SALE_PRICE = _price;
1501   }
1502 
1503   function setMaxLimitPerTransaction(uint256 _limit)
1504       external
1505       onlyOwner
1506   {
1507       MAX_MINTS_PER_TX = _limit;
1508   }
1509 
1510   function setFreeLimitPerWallet(uint256 _limit)
1511       external
1512       onlyOwner
1513   {
1514       MAX_FREE_PER_WALLET = _limit;
1515   }
1516 }