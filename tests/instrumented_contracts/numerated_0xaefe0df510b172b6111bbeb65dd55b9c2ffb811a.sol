1 // SPDX-License-Identifier: MIT
2 // Creator: Innerme's
3 
4 pragma solidity 0.8.7;
5 
6 //string.sol
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
58     function toHexString(uint256 value, uint256 length)
59         internal
60         pure
61         returns (string memory)
62     {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // context.sol
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 //Address.sol
97 /**
98  * @dev Collection of functions related to the address type
99  */
100 library Address {
101     /**
102      * @dev Returns true if `account` is a contract.
103      *
104      * [IMPORTANT]
105      * ====
106      * It is unsafe to assume that an address for which this function returns
107      * false is an externally-owned account (EOA) and not a contract.
108      *
109      * Among others, `isContract` will return false for the following
110      * types of addresses:
111      *
112      *  - an externally-owned account
113      *  - a contract in construction
114      *  - an address where a contract will be created
115      *  - an address where a contract lived, but was destroyed
116      * ====
117      *
118      * [IMPORTANT]
119      * ====
120      * You shouldn't rely on `isContract` to protect against flash loan attacks!
121      *
122      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
123      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
124      * constructor.
125      * ====
126      */
127     function isContract(address account) internal view returns (bool) {
128         // This method relies on extcodesize/address.code.length, which returns 0
129         // for contracts in construction, since the code is only stored at the end
130         // of the constructor execution.
131 
132         return account.code.length > 0;
133     }
134 
135     /**
136      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
137      * `recipient`, forwarding all available gas and reverting on errors.
138      *
139      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
140      * of certain opcodes, possibly making contracts go over the 2300 gas limit
141      * imposed by `transfer`, making them unable to receive funds via
142      * `transfer`. {sendValue} removes this limitation.
143      *
144      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
145      *
146      * IMPORTANT: because control is transferred to `recipient`, care must be
147      * taken to not create reentrancy vulnerabilities. Consider using
148      * {ReentrancyGuard} or the
149      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
150      */
151     function sendValue(address payable recipient, uint256 amount) internal {
152         require(
153             address(this).balance >= amount,
154             "Address: insufficient balance"
155         );
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(
159             success,
160             "Address: unable to send value, recipient may have reverted"
161         );
162     }
163 
164     /**
165      * @dev Performs a Solidity function call using a low level `call`. A
166      * plain `call` is an unsafe replacement for a function call: use this
167      * function instead.
168      *
169      * If `target` reverts with a revert reason, it is bubbled up by this
170      * function (like regular Solidity function calls).
171      *
172      * Returns the raw returned data. To convert to the expected return value,
173      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
174      *
175      * Requirements:
176      *
177      * - `target` must be a contract.
178      * - calling `target` with `data` must not revert.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(address target, bytes memory data)
183         internal
184         returns (bytes memory)
185     {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return
220             functionCallWithValue(
221                 target,
222                 data,
223                 value,
224                 "Address: low-level call with value failed"
225             );
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
230      * with `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         require(
241             address(this).balance >= value,
242             "Address: insufficient balance for call"
243         );
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(
247             data
248         );
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(address target, bytes memory data)
259         internal
260         view
261         returns (bytes memory)
262     {
263         return
264             functionStaticCall(
265                 target,
266                 data,
267                 "Address: low-level static call failed"
268             );
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal view returns (bytes memory) {
282         require(isContract(target), "Address: static call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.staticcall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(address target, bytes memory data)
295         internal
296         returns (bytes memory)
297     {
298         return
299             functionDelegateCall(
300                 target,
301                 data,
302                 "Address: low-level delegate call failed"
303             );
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(isContract(target), "Address: delegate call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.delegatecall(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
325      * revert reason using the provided one.
326      *
327      * _Available since v4.3._
328      */
329     function verifyCallResult(
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) internal pure returns (bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 assembly {
342                     let returndata_size := mload(returndata)
343                     revert(add(32, returndata), returndata_size)
344                 }
345             } else {
346                 revert(errorMessage);
347             }
348         }
349     }
350 }
351 
352 /**
353  * @dev Interface of the ERC165 standard, as defined in the
354  * https://eips.ethereum.org/EIPS/eip-165[EIP].
355  *
356  * Implementers can declare support of contract interfaces, which can then be
357  * queried by others ({ERC165Checker}).
358  *
359  * For an implementation, see {ERC165}.
360  */
361 interface IERC165 {
362     /**
363      * @dev Returns true if this contract implements the interface defined by
364      * `interfaceId`. See the corresponding
365      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
366      * to learn more about how these ids are created.
367      *
368      * This function call must use less than 30 000 gas.
369      */
370     function supportsInterface(bytes4 interfaceId) external view returns (bool);
371 }
372 
373 //erc165.sol
374 /**
375  * @dev Implementation of the {IERC165} interface.
376  *
377  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
378  * for the additional interface id that will be supported. For example:
379  *
380  * ```solidity
381  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
383  * }
384  * ```
385  *
386  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
387  */
388 abstract contract ERC165 is IERC165 {
389     /**
390      * @dev See {IERC165-supportsInterface}.
391      */
392     function supportsInterface(bytes4 interfaceId)
393         public
394         view
395         virtual
396         override
397         returns (bool)
398     {
399         return interfaceId == type(IERC165).interfaceId;
400     }
401 }
402 
403 // IERC721.SOL
404 //IERC721
405 
406 /**
407  * @dev Required interface of an ERC721 compliant contract.
408  */
409 interface IERC721 is IERC165 {
410     /**
411      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
412      */
413     event Transfer(
414         address indexed from,
415         address indexed to,
416         uint256 indexed tokenId
417     );
418 
419     /**
420      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
421      */
422     event Approval(
423         address indexed owner,
424         address indexed approved,
425         uint256 indexed tokenId
426     );
427 
428     /**
429      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
430      */
431     event ApprovalForAll(
432         address indexed owner,
433         address indexed operator,
434         bool approved
435     );
436 
437     /**
438      * @dev Returns the number of tokens in ``owner``'s account.
439      */
440     function balanceOf(address owner) external view returns (uint256 balance);
441 
442     /**
443      * @dev Returns the owner of the `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function ownerOf(uint256 tokenId) external view returns (address owner);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
453      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Transfers `tokenId` token from `from` to `to`.
473      *
474      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must be owned by `from`.
481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
493      * The approval is cleared when the token is transferred.
494      *
495      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
496      *
497      * Requirements:
498      *
499      * - The caller must own the token or be an approved operator.
500      * - `tokenId` must exist.
501      *
502      * Emits an {Approval} event.
503      */
504     function approve(address to, uint256 tokenId) external;
505 
506     /**
507      * @dev Returns the account approved for `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function getApproved(uint256 tokenId)
514         external
515         view
516         returns (address operator);
517 
518     /**
519      * @dev Approve or remove `operator` as an operator for the caller.
520      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator)
536         external
537         view
538         returns (bool);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes calldata data
558     ) external;
559 }
560 
561 // IERC721Enumerable.sol
562 
563 interface IERC721Enumerable is IERC721 {
564     /**
565      * @dev Returns the total amount of tokens stored by the contract.
566      */
567     function totalSupply() external view returns (uint256);
568 
569     /**
570      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
571      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
572      */
573     function tokenOfOwnerByIndex(address owner, uint256 index)
574         external
575         view
576         returns (uint256);
577 
578     /**
579      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
580      * Use along with {totalSupply} to enumerate all tokens.
581      */
582     function tokenByIndex(uint256 index) external view returns (uint256);
583 }
584 
585 /**
586  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
587  * @dev See https://eips.ethereum.org/EIPS/eip-721
588  */
589 interface IERC721Metadata is IERC721 {
590     /**
591      * @dev Returns the token collection name.
592      */
593     function name() external view returns (string memory);
594 
595     /**
596      * @dev Returns the token collection symbol.
597      */
598     function symbol() external view returns (string memory);
599 
600     /**
601      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
602      */
603     function tokenURI(uint256 tokenId) external view returns (string memory);
604 }
605 
606 // IERC721Reciver.sol
607 /**
608  * @title ERC721 token receiver interface
609  * @dev Interface for any contract that wants to support safeTransfers
610  * from ERC721 asset contracts.
611  */
612 interface IERC721Receiver {
613     /**
614      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
615      * by `operator` from `from`, this function is called.
616      *
617      * It must return its Solidity selector to confirm the token transfer.
618      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
619      *
620      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
621      */
622     function onERC721Received(
623         address operator,
624         address from,
625         uint256 tokenId,
626         bytes calldata data
627     ) external returns (bytes4);
628 }
629 
630 error ApprovalCallerNotOwnerNorApproved();
631 error ApprovalQueryForNonexistentToken();
632 error ApproveToCaller();
633 error ApprovalToCurrentOwner();
634 error BalanceQueryForZeroAddress();
635 error MintedQueryForZeroAddress();
636 error MintToZeroAddress();
637 error MintZeroQuantity();
638 error OwnerIndexOutOfBounds();
639 error OwnerQueryForNonexistentToken();
640 error TokenIndexOutOfBounds();
641 error TransferCallerNotOwnerNorApproved();
642 error TransferFromIncorrectOwner();
643 error TransferToNonERC721ReceiverImplementer();
644 error TransferToZeroAddress();
645 error UnableDetermineTokenOwner();
646 error URIQueryForNonexistentToken();
647 
648 /**
649  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
650  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
651  *
652  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
653  *
654  * Does not support burning tokens to address(0).
655  *
656  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
657  */
658 contract ERC721A is
659     Context,
660     ERC165,
661     IERC721,
662     IERC721Metadata,
663     IERC721Enumerable
664 {
665     using Address for address;
666     using Strings for uint256;
667 
668     struct TokenOwnership {
669         address addr;
670         uint64 startTimestamp;
671     }
672 
673     struct AddressData {
674         uint128 balance;
675         uint128 numberMinted;
676     }
677 
678     uint256 internal _currentIndex;
679 
680     // Token name
681     string private _name;
682 
683     // Token symbol
684     string private _symbol;
685 
686     // Mapping from token ID to ownership details
687     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
688     mapping(uint256 => TokenOwnership) internal _ownerships;
689 
690     // Mapping owner address to address data
691     mapping(address => AddressData) private _addressData;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC721Enumerable-totalSupply}.
706      */
707     function totalSupply() public view override returns (uint256) {
708         return _currentIndex;
709     }
710 
711     /**
712      * @dev See {IERC721Enumerable-tokenByIndex}.
713      */
714     function tokenByIndex(uint256 index)
715         public
716         view
717         override
718         returns (uint256)
719     {
720         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
721         return index;
722     }
723 
724     /**
725      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
726      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
727      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
728      */
729     function tokenOfOwnerByIndex(address owner, uint256 index)
730         public
731         view
732         override
733         returns (uint256 a)
734     {
735         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
736         uint256 numMintedSoFar = totalSupply();
737         uint256 tokenIdsIdx;
738         address currOwnershipAddr;
739 
740         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
741         unchecked {
742             for (uint256 i; i < numMintedSoFar; i++) {
743                 TokenOwnership memory ownership = _ownerships[i];
744                 if (ownership.addr != address(0)) {
745                     currOwnershipAddr = ownership.addr;
746                 }
747                 if (currOwnershipAddr == owner) {
748                     if (tokenIdsIdx == index) {
749                         return i;
750                     }
751                     tokenIdsIdx++;
752                 }
753             }
754         }
755 
756         // Execution should never reach this point.
757         assert(false);
758     }
759 
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId)
764         public
765         view
766         virtual
767         override(ERC165, IERC165)
768         returns (bool)
769     {
770         return
771             interfaceId == type(IERC721).interfaceId ||
772             interfaceId == type(IERC721Metadata).interfaceId ||
773             interfaceId == type(IERC721Enumerable).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view override returns (uint256) {
781         if (owner == address(0)) revert BalanceQueryForZeroAddress();
782         return uint256(_addressData[owner].balance);
783     }
784 
785     function _numberMinted(address owner) internal view returns (uint256) {
786         if (owner == address(0)) revert MintedQueryForZeroAddress();
787         return uint256(_addressData[owner].numberMinted);
788     }
789 
790     /**
791      * Gas spent here starts off proportional to the maximum mint batch size.
792      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
793      */
794     function ownershipOf(uint256 tokenId)
795         internal
796         view
797         returns (TokenOwnership memory)
798     {
799         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
800 
801         unchecked {
802             for (uint256 curr = tokenId; curr >= 0; curr--) {
803                 TokenOwnership memory ownership = _ownerships[curr];
804                 if (ownership.addr != address(0)) {
805                     return ownership;
806                 }
807             }
808         }
809 
810         revert UnableDetermineTokenOwner();
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view override returns (address) {
817         return ownershipOf(tokenId).addr;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-name}.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-symbol}.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-tokenURI}.
836      */
837     function tokenURI(uint256 tokenId)
838         public
839         view
840         override
841         returns (string memory)
842     {
843         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
844 
845         string memory baseURI = _baseURI();
846         return
847             bytes(baseURI).length != 0
848                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
849                 : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public override {
865         address owner = ERC721A.ownerOf(tokenId);
866         if (to == owner) revert ApprovalToCurrentOwner();
867 
868         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
869             revert ApprovalCallerNotOwnerNorApproved();
870 
871         _approve(to, tokenId, owner);
872     }
873 
874     /**
875      * @dev See {IERC721-getApproved}.
876      */
877     function getApproved(uint256 tokenId)
878         public
879         view
880         override
881         returns (address)
882     {
883         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
884 
885         return _tokenApprovals[tokenId];
886     }
887 
888     /**
889      * @dev See {IERC721-setApprovalForAll}.
890      */
891     function setApprovalForAll(address operator, bool approved)
892         public
893         override
894     {
895         if (operator == _msgSender()) revert ApproveToCaller();
896 
897         _operatorApprovals[_msgSender()][operator] = approved;
898         emit ApprovalForAll(_msgSender(), operator, approved);
899     }
900 
901     /**
902      * @dev See {IERC721-isApprovedForAll}.
903      */
904     function isApprovedForAll(address owner, address operator)
905         public
906         view
907         virtual
908         override
909         returns (bool)
910     {
911         return _operatorApprovals[owner][operator];
912     }
913 
914     /**
915      * @dev See {IERC721-transferFrom}.
916      */
917     function transferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public virtual override {
933         safeTransferFrom(from, to, tokenId, "");
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) public override {
945         _transfer(from, to, tokenId);
946         if (!_checkOnERC721Received(from, to, tokenId, _data))
947             revert TransferToNonERC721ReceiverImplementer();
948     }
949 
950     /**
951      * @dev Returns whether `tokenId` exists.
952      *
953      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
954      *
955      * Tokens start existing when they are minted (`_mint`),
956      */
957     function _exists(uint256 tokenId) internal view returns (bool) {
958         return tokenId < _currentIndex;
959     }
960 
961     function _safeMint(address to, uint256 quantity) internal {
962         _safeMint(to, quantity, "");
963     }
964 
965     /**
966      * @dev Safely mints `quantity` tokens and transfers them to `to`.
967      *
968      * Requirements:
969      *
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
971      * - `quantity` must be greater than 0.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _safeMint(
976         address to,
977         uint256 quantity,
978         bytes memory _data
979     ) internal {
980         _mint(to, quantity, _data, true);
981     }
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` must be greater than 0.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(
994         address to,
995         uint256 quantity,
996         bytes memory _data,
997         bool safe
998     ) internal {
999         uint256 startTokenId = _currentIndex;
1000         if (to == address(0)) revert MintToZeroAddress();
1001         // if (quantity == 0) revert MintZeroQuantity();
1002 
1003         //_beforeTokenTransfers(address(0), to, startTokenId, quantity);
1004 
1005         // Overflows are incredibly unrealistic.
1006         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1007         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1008         unchecked {
1009             _addressData[to].balance += uint128(quantity);
1010             _addressData[to].numberMinted += uint128(quantity);
1011 
1012             _ownerships[startTokenId].addr = to;
1013             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1014 
1015             uint256 updatedIndex = startTokenId;
1016 
1017             for (uint256 i; i < quantity; i++) {
1018                 emit Transfer(address(0), to, updatedIndex);
1019                 if (
1020                     safe &&
1021                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
1022                 ) {
1023                     revert TransferToNonERC721ReceiverImplementer();
1024                 }
1025 
1026                 updatedIndex++;
1027             }
1028 
1029             _currentIndex = updatedIndex;
1030         }
1031 
1032         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1033     }
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) private {
1050         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1051 
1052         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1053             getApproved(tokenId) == _msgSender() ||
1054             isApprovedForAll(prevOwnership.addr, _msgSender()));
1055 
1056         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1057         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1058         if (to == address(0)) revert TransferToZeroAddress();
1059 
1060         // _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             _addressData[from].balance -= 1;
1070             _addressData[to].balance += 1;
1071 
1072             _ownerships[tokenId].addr = to;
1073             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1074 
1075             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1076             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1077             uint256 nextTokenId = tokenId + 1;
1078             if (_ownerships[nextTokenId].addr == address(0)) {
1079                 if (_exists(nextTokenId)) {
1080                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1081                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1082                         .startTimestamp;
1083                 }
1084             }
1085         }
1086 
1087         emit Transfer(from, to, tokenId);
1088         _afterTokenTransfers(from, to, tokenId, 1);
1089     }
1090 
1091     /**
1092      * @dev Approve `to` to operate on `tokenId`
1093      *
1094      * Emits a {Approval} event.
1095      */
1096     function _approve(
1097         address to,
1098         uint256 tokenId,
1099         address owner
1100     ) private {
1101         _tokenApprovals[tokenId] = to;
1102         emit Approval(owner, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1107      * The call is not executed if the target address is not a contract.
1108      *
1109      * @param from address representing the previous owner of the given token ID
1110      * @param to target address that will receive the tokens
1111      * @param tokenId uint256 ID of the token to be transferred
1112      * @param _data bytes optional data to send along with the call
1113      * @return bool whether the call correctly returned the expected magic value
1114      */
1115     function _checkOnERC721Received(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) private returns (bool) {
1121         if (to.isContract()) {
1122             try
1123                 IERC721Receiver(to).onERC721Received(
1124                     _msgSender(),
1125                     from,
1126                     tokenId,
1127                     _data
1128                 )
1129             returns (bytes4 retval) {
1130                 return retval == IERC721Receiver(to).onERC721Received.selector;
1131             } catch (bytes memory reason) {
1132                 if (reason.length == 0)
1133                     revert TransferToNonERC721ReceiverImplementer();
1134                 else {
1135                     assembly {
1136                         revert(add(32, reason), mload(reason))
1137                     }
1138                 }
1139             }
1140         } else {
1141             return true;
1142         }
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1147      *
1148      * startTokenId - the first token id to be transferred
1149      * quantity - the amount to be transferred
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      */
1157     function _beforeTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 
1164     /**
1165      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1166      * minting.
1167      *
1168      * startTokenId - the first token id to be transferred
1169      * quantity - the amount to be transferred
1170      *
1171      * Calling conditions:
1172      *
1173      * - when `from` and `to` are both non-zero.
1174      * - `from` and `to` are never both zero.
1175      */
1176     function _afterTokenTransfers(
1177         address from,
1178         address to,
1179         uint256 startTokenId,
1180         uint256 quantity
1181     ) internal virtual {}
1182 }
1183 
1184 abstract contract Ownable is Context {
1185     address private _owner;
1186 
1187     event OwnershipTransferred(
1188         address indexed previousOwner,
1189         address indexed newOwner
1190     );
1191 
1192     /**
1193      * @dev Initializes the contract setting the deployer as the initial owner.
1194      */
1195     constructor() {
1196         _transferOwnership(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns the address of the current owner.
1201      */
1202     function owner() public view virtual returns (address) {
1203         return _owner;
1204     }
1205 
1206     /**
1207      * @dev Throws if called by any account other than the owner.
1208      */
1209     modifier onlyOwner() {
1210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1211         _;
1212     }
1213 
1214     /**
1215      * @dev Leaves the contract without owner. It will not be possible to call
1216      * `onlyOwner` functions anymore. Can only be called by the current owner.
1217      *
1218      * NOTE: Renouncing ownership will leave the contract without an owner,
1219      * thereby removing any functionality that is only available to the owner.
1220      */
1221     function renounceOwnership() public virtual onlyOwner {
1222         _transferOwnership(address(0));
1223     }
1224 
1225     /**
1226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1227      * Can only be called by the current owner.
1228      */
1229     function transferOwnership(address newOwner) public virtual onlyOwner {
1230         require(
1231             newOwner != address(0),
1232             "Ownable: new owner is the zero address"
1233         );
1234         _transferOwnership(newOwner);
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Internal function without access restriction.
1240      */
1241     function _transferOwnership(address newOwner) internal virtual {
1242         address oldOwner = _owner;
1243         _owner = newOwner;
1244         emit OwnershipTransferred(oldOwner, newOwner);
1245     }
1246 }
1247 
1248 
1249 contract INNERMES is ERC721A, Ownable {
1250     uint256 public maxSupply = 10000;
1251  
1252     uint256 public maxPerWallet =10;
1253     uint256 public maxPerTransaction = 5;
1254    
1255     string  public _baseURI1;
1256     bool    public isPaused =true;
1257     
1258    
1259 
1260     struct UserSaleCounter {    
1261         uint256 counter;
1262     }
1263 
1264     
1265 
1266     mapping(address => UserSaleCounter)  public  _SaleCounter;
1267     mapping(address => bool)             public  _SaleAddressExist;
1268    
1269     
1270     constructor(string memory baseUri) ERC721A("INNERMES", "INM") {
1271         _baseURI1= baseUri;
1272     }
1273 
1274     
1275     
1276     function setMaxPerWallet(uint256 quantity) public onlyOwner {
1277         maxPerWallet = quantity;
1278     }
1279     
1280     function setMaxPerTrasaction(uint256 quantity) public onlyOwner {
1281         maxPerTransaction = quantity;
1282     }
1283 
1284     function setBaseURI(string memory baseuri) public onlyOwner {
1285         _baseURI1 = baseuri;
1286     }
1287     
1288     function flipPauseStatus() public onlyOwner {
1289         isPaused = !isPaused;
1290     }
1291    
1292     function _baseURI()internal view override  returns (string memory){
1293         return _baseURI1;
1294     }
1295 
1296     function mint(uint256 quantity) public {
1297           if (_SaleAddressExist[msg.sender] == false) {
1298             _SaleCounter[msg.sender] = UserSaleCounter({
1299                 counter: 0
1300             });
1301             _SaleAddressExist[msg.sender] = true;
1302         }
1303         require(quantity > 0 ,"quantity should be greater than 0");
1304         require(isPaused==false,"minting is stopped");
1305         require(_SaleCounter[msg.sender].counter + quantity <= maxPerWallet, "Sorry can not mint more than maxwallet");
1306         require(quantity <=maxPerTransaction,"per transaction amount exceeds");
1307         require(totalSupply()+quantity<=maxSupply,"all tokens have been minted");
1308         // require(price*quantity == msg.value, "Sent ether value is incorrect");
1309         _safeMint(msg.sender, quantity);
1310         _SaleCounter[msg.sender].counter += quantity;
1311     }
1312 
1313 
1314     function tokensOfOwner(address _owner)public view returns (uint256[] memory) {
1315         uint256 count = balanceOf(_owner);
1316         uint256[] memory result = new uint256[](count);
1317         for (uint256 index = 0; index < count; index++) {
1318             result[index] = tokenOfOwnerByIndex(_owner, index);
1319         }
1320         return result;
1321     }
1322 
1323    
1324 }