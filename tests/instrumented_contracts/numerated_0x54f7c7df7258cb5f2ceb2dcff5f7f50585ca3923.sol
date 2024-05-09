1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(
36         address indexed from,
37         address indexed to,
38         uint256 indexed tokenId
39     );
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(
45         address indexed owner,
46         address indexed approved,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(
54         address indexed owner,
55         address indexed operator,
56         bool approved
57     );
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId)
136         external
137         view
138         returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator)
158         external
159         view
160         returns (bool);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 }
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 pragma solidity ^0.8.1;
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      *
254      * [IMPORTANT]
255      * ====
256      * You shouldn't rely on `isContract` to protect against flash loan attacks!
257      *
258      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
259      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
260      * constructor.
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // This method relies on extcodesize/address.code.length, which returns 0
265         // for contracts in construction, since the code is only stored at the end
266         // of the constructor execution.
267 
268         return account.code.length > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(
289             address(this).balance >= amount,
290             "Address: insufficient balance"
291         );
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(
295             success,
296             "Address: unable to send value, recipient may have reverted"
297         );
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
318     function functionCall(address target, bytes memory data)
319         internal
320         returns (bytes memory)
321     {
322         return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value
354     ) internal returns (bytes memory) {
355         return
356             functionCallWithValue(
357                 target,
358                 data,
359                 value,
360                 "Address: low-level call with value failed"
361             );
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(
377             address(this).balance >= value,
378             "Address: insufficient balance for call"
379         );
380         require(isContract(target), "Address: call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.call{value: value}(
383             data
384         );
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data)
395         internal
396         view
397         returns (bytes memory)
398     {
399         return
400             functionStaticCall(
401                 target,
402                 data,
403                 "Address: low-level static call failed"
404             );
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data)
431         internal
432         returns (bytes memory)
433     {
434         return
435             functionDelegateCall(
436                 target,
437                 data,
438                 "Address: low-level delegate call failed"
439             );
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes calldata) {
506         return msg.data;
507     }
508 }
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev String operations.
514  */
515 library Strings {
516     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
520      */
521     function toString(uint256 value) internal pure returns (string memory) {
522         // Inspired by OraclizeAPI's implementation - MIT licence
523         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
524 
525         if (value == 0) {
526             return "0";
527         }
528         uint256 temp = value;
529         uint256 digits;
530         while (temp != 0) {
531             digits++;
532             temp /= 10;
533         }
534         bytes memory buffer = new bytes(digits);
535         while (value != 0) {
536             digits -= 1;
537             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
538             value /= 10;
539         }
540         return string(buffer);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
545      */
546     function toHexString(uint256 value) internal pure returns (string memory) {
547         if (value == 0) {
548             return "0x00";
549         }
550         uint256 temp = value;
551         uint256 length = 0;
552         while (temp != 0) {
553             length++;
554             temp >>= 8;
555         }
556         return toHexString(value, length);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
561      */
562     function toHexString(uint256 value, uint256 length)
563         internal
564         pure
565         returns (string memory)
566     {
567         bytes memory buffer = new bytes(2 * length + 2);
568         buffer[0] = "0";
569         buffer[1] = "x";
570         for (uint256 i = 2 * length + 1; i > 1; --i) {
571             buffer[i] = _HEX_SYMBOLS[value & 0xf];
572             value >>= 4;
573         }
574         require(value == 0, "Strings: hex length insufficient");
575         return string(buffer);
576     }
577 }
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Implementation of the {IERC165} interface.
583  *
584  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
585  * for the additional interface id that will be supported. For example:
586  *
587  * ```solidity
588  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
590  * }
591  * ```
592  *
593  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
594  */
595 abstract contract ERC165 is IERC165 {
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId)
600         public
601         view
602         virtual
603         override
604         returns (bool)
605     {
606         return interfaceId == type(IERC165).interfaceId;
607     }
608 }
609 
610 pragma solidity ^0.8.4;
611 
612 error ApprovalCallerNotOwnerNorApproved();
613 error ApprovalQueryForNonexistentToken();
614 error ApproveToCaller();
615 error ApprovalToCurrentOwner();
616 error BalanceQueryForZeroAddress();
617 error MintToZeroAddress();
618 error MintZeroQuantity();
619 error OwnerQueryForNonexistentToken();
620 error TransferCallerNotOwnerNorApproved();
621 error TransferFromIncorrectOwner();
622 error TransferToNonERC721ReceiverImplementer();
623 error TransferToZeroAddress();
624 error URIQueryForNonexistentToken();
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata extension. Built to optimize for lower gas during batch mints.
629  *
630  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
631  *
632  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
633  *
634  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
635  */
636 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Compiler will pack this into a single 256bit word.
641     struct TokenOwnership {
642         // The address of the owner.
643         address addr;
644         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
645         uint64 startTimestamp;
646         // Whether the token has been burned.
647         bool burned;
648     }
649 
650     // Compiler will pack this into a single 256bit word.
651     struct AddressData {
652         // Realistically, 2**64-1 is more than enough.
653         uint64 balance;
654         // Keeps track of mint count with minimal overhead for tokenomics.
655         uint64 numberMinted;
656         // Keeps track of burn count with minimal overhead for tokenomics.
657         uint64 numberBurned;
658         // For miscellaneous variable(s) pertaining to the address
659         // (e.g. number of whitelist mint slots used).
660         // If there are multiple variables, please pack them into a uint64.
661         uint64 aux;
662     }
663 
664     // The tokenId of the next token to be minted.
665     uint256 internal _currentIndex;
666 
667     // The number of tokens burned.
668     uint256 internal _burnCounter;
669 
670     // Token name
671     string private _name;
672 
673     // Token symbol
674     string private _symbol;
675 
676     // Mapping from token ID to ownership details
677     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
678     mapping(uint256 => TokenOwnership) internal _ownerships;
679 
680     // Mapping owner address to address data
681     mapping(address => AddressData) private _addressData;
682 
683     // Mapping from token ID to approved address
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692         _currentIndex = _startTokenId();
693     }
694 
695     /**
696      * To change the starting tokenId, please override this function.
697      */
698     function _startTokenId() internal view virtual returns (uint256) {
699         return 0;
700     }
701 
702     /**
703      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
704      */
705     function totalSupply() public view returns (uint256) {
706         // Counter underflow is impossible as _burnCounter cannot be incremented
707         // more than _currentIndex - _startTokenId() times
708         unchecked {
709             return _currentIndex - _burnCounter - _startTokenId();
710         }
711     }
712 
713     /**
714      * Returns the total amount of tokens minted in the contract.
715      */
716     function _totalMinted() internal view returns (uint256) {
717         // Counter underflow is impossible as _currentIndex does not decrement,
718         // and it is initialized to _startTokenId()
719         unchecked {
720             return _currentIndex - _startTokenId();
721         }
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId)
728         public
729         view
730         virtual
731         override(ERC165, IERC165)
732         returns (bool)
733     {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view override returns (uint256) {
744         if (owner == address(0)) revert BalanceQueryForZeroAddress();
745         return uint256(_addressData[owner].balance);
746     }
747 
748     /**
749      * Returns the number of tokens minted by `owner`.
750      */
751     function _numberMinted(address owner) internal view returns (uint256) {
752         return uint256(_addressData[owner].numberMinted);
753     }
754 
755     /**
756      * Returns the number of tokens burned by or on behalf of `owner`.
757      */
758     function _numberBurned(address owner) internal view returns (uint256) {
759         return uint256(_addressData[owner].numberBurned);
760     }
761 
762     /**
763      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      */
765     function _getAux(address owner) internal view returns (uint64) {
766         return _addressData[owner].aux;
767     }
768 
769     /**
770      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
771      * If there are multiple variables, please pack them into a uint64.
772      */
773     function _setAux(address owner, uint64 aux) internal {
774         _addressData[owner].aux = aux;
775     }
776 
777     /**
778      * Gas spent here starts off proportional to the maximum mint batch size.
779      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
780      */
781     function _ownershipOf(uint256 tokenId)
782         internal
783         view
784         returns (TokenOwnership memory)
785     {
786         uint256 curr = tokenId;
787 
788         unchecked {
789             if (_startTokenId() <= curr && curr < _currentIndex) {
790                 TokenOwnership memory ownership = _ownerships[curr];
791                 if (!ownership.burned) {
792                     if (ownership.addr != address(0)) {
793                         return ownership;
794                     }
795                     // Invariant:
796                     // There will always be an ownership that has an address and is not burned
797                     // before an ownership that does not have an address and is not burned.
798                     // Hence, curr will not underflow.
799                     while (true) {
800                         curr--;
801                         ownership = _ownerships[curr];
802                         if (ownership.addr != address(0)) {
803                             return ownership;
804                         }
805                     }
806                 }
807             }
808         }
809         revert OwnerQueryForNonexistentToken();
810     }
811 
812     /**
813      * @dev See {IERC721-ownerOf}.
814      */
815     function ownerOf(uint256 tokenId) public view override returns (address) {
816         return _ownershipOf(tokenId).addr;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-name}.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-symbol}.
828      */
829     function symbol() public view virtual override returns (string memory) {
830         return _symbol;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-tokenURI}.
835      */
836     function tokenURI(uint256 tokenId)
837         public
838         view
839         virtual
840         override
841         returns (string memory)
842     {
843         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
844 
845         string memory baseURI = _baseURI();
846         return
847             bytes(baseURI).length != 0
848                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
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
868         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
869             revert ApprovalCallerNotOwnerNorApproved();
870         }
871 
872         _approve(to, tokenId, owner);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId)
879         public
880         view
881         override
882         returns (address)
883     {
884         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved)
893         public
894         virtual
895         override
896     {
897         if (operator == _msgSender()) revert ApproveToCaller();
898 
899         _operatorApprovals[_msgSender()][operator] = approved;
900         emit ApprovalForAll(_msgSender(), operator, approved);
901     }
902 
903     /**
904      * @dev See {IERC721-isApprovedForAll}.
905      */
906     function isApprovedForAll(address owner, address operator)
907         public
908         view
909         virtual
910         override
911         returns (bool)
912     {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, "");
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public virtual override {
947         _transfer(from, to, tokenId);
948         if (
949             to.isContract() &&
950             !_checkContractOnERC721Received(from, to, tokenId, _data)
951         ) {
952             revert TransferToNonERC721ReceiverImplementer();
953         }
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      */
963     function _exists(uint256 tokenId) internal view returns (bool) {
964         return
965             _startTokenId() <= tokenId &&
966             tokenId < _currentIndex &&
967             !_ownerships[tokenId].burned;
968     }
969 
970     function _safeMint(address to, uint256 quantity) internal {
971         _safeMint(to, quantity, "");
972     }
973 
974     /**
975      * @dev Safely mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
980      * - `quantity` must be greater than 0.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(
985         address to,
986         uint256 quantity,
987         bytes memory _data
988     ) internal {
989         _mint(to, quantity, _data, true);
990     }
991 
992     /**
993      * @dev Mints `quantity` tokens and transfers them to `to`.
994      *
995      * Requirements:
996      *
997      * - `to` cannot be the zero address.
998      * - `quantity` must be greater than 0.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _mint(
1003         address to,
1004         uint256 quantity,
1005         bytes memory _data,
1006         bool safe
1007     ) internal {
1008         uint256 startTokenId = _currentIndex;
1009         if (to == address(0)) revert MintToZeroAddress();
1010         if (quantity == 0) revert MintZeroQuantity();
1011 
1012         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1013 
1014         // Overflows are incredibly unrealistic.
1015         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1016         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1017         unchecked {
1018             _addressData[to].balance += uint64(quantity);
1019             _addressData[to].numberMinted += uint64(quantity);
1020 
1021             _ownerships[startTokenId].addr = to;
1022             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1023 
1024             uint256 updatedIndex = startTokenId;
1025             uint256 end = updatedIndex + quantity;
1026 
1027             if (safe && to.isContract()) {
1028                 do {
1029                     emit Transfer(address(0), to, updatedIndex);
1030                     if (
1031                         !_checkContractOnERC721Received(
1032                             address(0),
1033                             to,
1034                             updatedIndex++,
1035                             _data
1036                         )
1037                     ) {
1038                         revert TransferToNonERC721ReceiverImplementer();
1039                     }
1040                 } while (updatedIndex != end);
1041                 // Reentrancy protection
1042                 if (_currentIndex != startTokenId) revert();
1043             } else {
1044                 do {
1045                     emit Transfer(address(0), to, updatedIndex++);
1046                 } while (updatedIndex != end);
1047             }
1048             _currentIndex = updatedIndex;
1049         }
1050         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1051     }
1052 
1053     /**
1054      * @dev Transfers `tokenId` from `from` to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) private {
1068         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1069 
1070         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1071 
1072         bool isApprovedOrOwner = (_msgSender() == from ||
1073             isApprovedForAll(from, _msgSender()) ||
1074             getApproved(tokenId) == _msgSender());
1075 
1076         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1077         if (to == address(0)) revert TransferToZeroAddress();
1078 
1079         _beforeTokenTransfers(from, to, tokenId, 1);
1080 
1081         // Clear approvals from the previous owner
1082         _approve(address(0), tokenId, from);
1083 
1084         // Underflow of the sender's balance is impossible because we check for
1085         // ownership above and the recipient's balance can't realistically overflow.
1086         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1087         unchecked {
1088             _addressData[from].balance -= 1;
1089             _addressData[to].balance += 1;
1090 
1091             TokenOwnership storage currSlot = _ownerships[tokenId];
1092             currSlot.addr = to;
1093             currSlot.startTimestamp = uint64(block.timestamp);
1094 
1095             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1096             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1097             uint256 nextTokenId = tokenId + 1;
1098             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1099             if (nextSlot.addr == address(0)) {
1100                 // This will suffice for checking _exists(nextTokenId),
1101                 // as a burned slot cannot contain the zero address.
1102                 if (nextTokenId != _currentIndex) {
1103                     nextSlot.addr = from;
1104                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1105                 }
1106             }
1107         }
1108 
1109         emit Transfer(from, to, tokenId);
1110         _afterTokenTransfers(from, to, tokenId, 1);
1111     }
1112 
1113     /**
1114      * @dev This is equivalent to _burn(tokenId, false)
1115      */
1116     function _burn(uint256 tokenId) internal virtual {
1117         _burn(tokenId, false);
1118     }
1119 
1120     /**
1121      * @dev Destroys `tokenId`.
1122      * The approval is cleared when the token is burned.
1123      *
1124      * Requirements:
1125      *
1126      * - `tokenId` must exist.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1131         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1132 
1133         address from = prevOwnership.addr;
1134 
1135         if (approvalCheck) {
1136             bool isApprovedOrOwner = (_msgSender() == from ||
1137                 isApprovedForAll(from, _msgSender()) ||
1138                 getApproved(tokenId) == _msgSender());
1139 
1140             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1141         }
1142 
1143         _beforeTokenTransfers(from, address(0), tokenId, 1);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId, from);
1147 
1148         // Underflow of the sender's balance is impossible because we check for
1149         // ownership above and the recipient's balance can't realistically overflow.
1150         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1151         unchecked {
1152             AddressData storage addressData = _addressData[from];
1153             addressData.balance -= 1;
1154             addressData.numberBurned += 1;
1155 
1156             // Keep track of who burned the token, and the timestamp of burning.
1157             TokenOwnership storage currSlot = _ownerships[tokenId];
1158             currSlot.addr = from;
1159             currSlot.startTimestamp = uint64(block.timestamp);
1160             currSlot.burned = true;
1161 
1162             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1163             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1164             uint256 nextTokenId = tokenId + 1;
1165             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1166             if (nextSlot.addr == address(0)) {
1167                 // This will suffice for checking _exists(nextTokenId),
1168                 // as a burned slot cannot contain the zero address.
1169                 if (nextTokenId != _currentIndex) {
1170                     nextSlot.addr = from;
1171                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, address(0), tokenId);
1177         _afterTokenTransfers(from, address(0), tokenId, 1);
1178 
1179         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1180         unchecked {
1181             _burnCounter++;
1182         }
1183     }
1184 
1185     /**
1186      * @dev Approve `to` to operate on `tokenId`
1187      *
1188      * Emits a {Approval} event.
1189      */
1190     function _approve(
1191         address to,
1192         uint256 tokenId,
1193         address owner
1194     ) private {
1195         _tokenApprovals[tokenId] = to;
1196         emit Approval(owner, to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1201      *
1202      * @param from address representing the previous owner of the given token ID
1203      * @param to target address that will receive the tokens
1204      * @param tokenId uint256 ID of the token to be transferred
1205      * @param _data bytes optional data to send along with the call
1206      * @return bool whether the call correctly returned the expected magic value
1207      */
1208     function _checkContractOnERC721Received(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) private returns (bool) {
1214         try
1215             IERC721Receiver(to).onERC721Received(
1216                 _msgSender(),
1217                 from,
1218                 tokenId,
1219                 _data
1220             )
1221         returns (bytes4 retval) {
1222             return retval == IERC721Receiver(to).onERC721Received.selector;
1223         } catch (bytes memory reason) {
1224             if (reason.length == 0) {
1225                 revert TransferToNonERC721ReceiverImplementer();
1226             } else {
1227                 assembly {
1228                     revert(add(32, reason), mload(reason))
1229                 }
1230             }
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1236      * And also called before burning one token.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, `tokenId` will be burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _beforeTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1258      * minting.
1259      * And also called after one token has been burned.
1260      *
1261      * startTokenId - the first token id to be transferred
1262      * quantity - the amount to be transferred
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` has been minted for `to`.
1269      * - When `to` is zero, `tokenId` has been burned by `from`.
1270      * - `from` and `to` are never both zero.
1271      */
1272     function _afterTokenTransfers(
1273         address from,
1274         address to,
1275         uint256 startTokenId,
1276         uint256 quantity
1277     ) internal virtual {}
1278 }
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 /**
1283  * @dev Contract module which provides a basic access control mechanism, where
1284  * there is an account (an owner) that can be granted exclusive access to
1285  * specific functions.
1286  *
1287  * By default, the owner account will be the one that deploys the contract. This
1288  * can later be changed with {transferOwnership}.
1289  *
1290  * This module is used through inheritance. It will make available the modifier
1291  * `onlyOwner`, which can be applied to your functions to restrict their use to
1292  * the owner.
1293  */
1294 abstract contract Ownable is Context {
1295     address private _owner;
1296 
1297     event OwnershipTransferred(
1298         address indexed previousOwner,
1299         address indexed newOwner
1300     );
1301 
1302     /**
1303      * @dev Initializes the contract setting the deployer as the initial owner.
1304      */
1305     constructor() {
1306         _transferOwnership(_msgSender());
1307     }
1308 
1309     /**
1310      * @dev Returns the address of the current owner.
1311      */
1312     function owner() public view virtual returns (address) {
1313         return _owner;
1314     }
1315 
1316     /**
1317      * @dev Throws if called by any account other than the owner.
1318      */
1319     modifier onlyOwner() {
1320         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1321         _;
1322     }
1323 
1324     /**
1325      * @dev Leaves the contract without owner. It will not be possible to call
1326      * `onlyOwner` functions anymore. Can only be called by the current owner.
1327      *
1328      * NOTE: Renouncing ownership will leave the contract without an owner,
1329      * thereby removing any functionality that is only available to the owner.
1330      */
1331     function renounceOwnership() public virtual onlyOwner {
1332         _transferOwnership(address(0));
1333     }
1334 
1335     /**
1336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1337      * Can only be called by the current owner.
1338      */
1339     function transferOwnership(address newOwner) public virtual onlyOwner {
1340         require(
1341             newOwner != address(0),
1342             "Ownable: new owner is the zero address"
1343         );
1344         _transferOwnership(newOwner);
1345     }
1346 
1347     /**
1348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1349      * Internal function without access restriction.
1350      */
1351     function _transferOwnership(address newOwner) internal virtual {
1352         address oldOwner = _owner;
1353         _owner = newOwner;
1354         emit OwnershipTransferred(oldOwner, newOwner);
1355     }
1356 }
1357 
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 /**
1362  * @dev Contract module that helps prevent reentrant calls to a function.
1363  *
1364  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1365  * available, which can be applied to functions to make sure there are no nested
1366  * (reentrant) calls to them.
1367  *
1368  * Note that because there is a single `nonReentrant` guard, functions marked as
1369  * `nonReentrant` may not call one another. This can be worked around by making
1370  * those functions `private`, and then adding `external` `nonReentrant` entry
1371  * points to them.
1372  *
1373  * TIP: If you would like to learn more about reentrancy and alternative ways
1374  * to protect against it, check out our blog post
1375  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1376  */
1377 abstract contract ReentrancyGuard {
1378     // Booleans are more expensive than uint256 or any type that takes up a full
1379     // word because each write operation emits an extra SLOAD to first read the
1380     // slot's contents, replace the bits taken up by the boolean, and then write
1381     // back. This is the compiler's defense against contract upgrades and
1382     // pointer aliasing, and it cannot be disabled.
1383 
1384     // The values being non-zero value makes deployment a bit more expensive,
1385     // but in exchange the refund on every call to nonReentrant will be lower in
1386     // amount. Since refunds are capped to a percentage of the total
1387     // transaction's gas, it is best to keep them low in cases like this one, to
1388     // increase the likelihood of the full refund coming into effect.
1389     uint256 private constant _NOT_ENTERED = 1;
1390     uint256 private constant _ENTERED = 2;
1391 
1392     uint256 private _status;
1393 
1394     constructor() {
1395         _status = _NOT_ENTERED;
1396     }
1397 
1398     /**
1399      * @dev Prevents a contract from calling itself, directly or indirectly.
1400      * Calling a `nonReentrant` function from another `nonReentrant`
1401      * function is not supported. It is possible to prevent this from happening
1402      * by making the `nonReentrant` function external, and making it call a
1403      * `private` function that does the actual work.
1404      */
1405     modifier nonReentrant() {
1406         // On the first call to nonReentrant, _notEntered will be true
1407         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1408 
1409         // Any calls to nonReentrant after this point will fail
1410         _status = _ENTERED;
1411 
1412         _;
1413 
1414         // By storing the original value once again, a refund is triggered (see
1415         // https://eips.ethereum.org/EIPS/eip-2200)
1416         _status = _NOT_ENTERED;
1417     }
1418 }
1419 
1420 // Welp you made it here finally. We really don't have anything smart to write honestly. We're bunch of stupid people you know. But Bishop is not.
1421 
1422 pragma solidity >=0.7.0 <0.9.0;
1423 
1424 contract Teddies is ERC721A, Ownable, ReentrancyGuard {
1425     using Strings for uint256;
1426 
1427     string uriPrefix = "";
1428     string public uriSuffix = ".json";
1429     string public hiddenMetadataUri =
1430         "ipfs://QmPgPYF95x7asTA5mUQP6Kw1hnvs187n4MCjJFMajF14w2/teddies_hidden.json";
1431     uint256 public cost = 0.08 ether;
1432     uint256 public maxSupply = 10000;
1433     uint256 public maxMintAmountPerTx = 20;
1434     bool public paused = true;
1435     bool public revealed = false;
1436 
1437     constructor(string memory _uriPrefix) ERC721A("Teddies", "TED") {
1438         uriPrefix = _uriPrefix;
1439     }
1440 
1441     modifier mintCompliance(uint256 _mintAmount) {
1442         require(!paused, "The minting is paused");
1443         require(_mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
1444         require(
1445             totalSupply() + _mintAmount <= maxSupply,
1446             "Max supply exceeded!"
1447         );
1448         _;
1449     }
1450 
1451     function mintTeddies(uint256 _mintAmount)
1452         public
1453         payable
1454         mintCompliance(_mintAmount)
1455     {
1456         if (msg.sender != owner()) {
1457             require(msg.value >= cost * _mintAmount, "Insufficient funds");
1458         }
1459         _safeMint(msg.sender, _mintAmount);
1460     }
1461 
1462     function minter(address _user, uint256 _amount) private mintCompliance(_amount) {
1463         _safeMint(_user, _amount);
1464     }
1465 
1466     function airdropTeddies(address[] calldata _users, uint256[] calldata _mintAmounts) public onlyOwner {
1467         for (uint256 i = 0; i < _users.length; i++) {
1468             minter(_users[i], _mintAmounts[i]);
1469         }
1470     }
1471 
1472     function walletOfOwner(address _owner)
1473         public
1474         view
1475         returns (uint256[] memory)
1476     {
1477         uint256 ownerTokenCount = balanceOf(_owner);
1478         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1479         uint256 currentTokenId = 1;
1480         uint256 ownedTokenIndex = 0;
1481 
1482         while (
1483             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1484         ) {
1485             address currentTokenOwner = ownerOf(currentTokenId);
1486 
1487             if (currentTokenOwner == _owner) {
1488                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1489 
1490                 ownedTokenIndex++;
1491             }
1492 
1493             currentTokenId++;
1494         }
1495 
1496         return ownedTokenIds;
1497     }
1498 
1499     function tokenURI(uint256 _tokenId)
1500         public
1501         view
1502         virtual
1503         override
1504         returns (string memory)
1505     {
1506         require(
1507             _exists(_tokenId),
1508             "ERC721Metadata: URI query for nonexistent token"
1509         );
1510 
1511         if (revealed == false) {
1512             return hiddenMetadataUri;
1513         }
1514 
1515         string memory currentBaseURI = _baseURI();
1516         return
1517             bytes(currentBaseURI).length > 0
1518                 ? string(
1519                     abi.encodePacked(
1520                         currentBaseURI,
1521                         _tokenId.toString(),
1522                         uriSuffix
1523                     )
1524                 )
1525                 : "";
1526     }
1527 
1528     function setRevealed(bool _state) public onlyOwner {
1529         revealed = _state;
1530     }
1531 
1532     function setCost(uint256 _cost) public onlyOwner {
1533         cost = _cost;
1534     }
1535 
1536 
1537     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1538         public
1539         onlyOwner
1540     {
1541         maxMintAmountPerTx = _maxMintAmountPerTx;
1542     }
1543 
1544     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1545         uriPrefix = _uriPrefix;
1546     }
1547 
1548     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1549         uriSuffix = _uriSuffix;
1550     }
1551 
1552     function setPaused(bool _state) public onlyOwner {
1553         paused = _state;
1554     }
1555 
1556     function withdraw() public onlyOwner {
1557         (bool bs, ) = payable(owner()).call{value: address(this).balance}("");
1558         require(bs);
1559     }
1560 
1561     function _baseURI() internal view virtual override returns (string memory) {
1562         return uriPrefix;
1563     }
1564 }
1565 
1566 //