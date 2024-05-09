1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(
41         address indexed from,
42         address indexed to,
43         uint256 indexed tokenId
44     );
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(
50         address indexed owner,
51         address indexed approved,
52         uint256 indexed tokenId
53     );
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(
59         address indexed owner,
60         address indexed operator,
61         bool approved
62     );
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(
137         uint256 tokenId
138     ) external view returns (address operator);
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
157     function isApprovedForAll(
158         address owner,
159         address operator
160     ) external view returns (bool);
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
183 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
184 
185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
186 
187 /**
188  * @title ERC721 token receiver interface
189  * @dev Interface for any contract that wants to support safeTransfers
190  * from ERC721 asset contracts.
191  */
192 interface IERC721Receiver {
193     /**
194      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
195      * by `operator` from `from`, this function is called.
196      *
197      * It must return its Solidity selector to confirm the token transfer.
198      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
199      *
200      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
201      */
202     function onERC721Received(
203         address operator,
204         address from,
205         uint256 tokenId,
206         bytes calldata data
207     ) external returns (bytes4);
208 }
209 
210 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
238 
239 pragma solidity ^0.8.1;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      *
262      * [IMPORTANT]
263      * ====
264      * You shouldn't rely on `isContract` to protect against flash loan attacks!
265      *
266      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
267      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
268      * constructor.
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize/address.code.length, which returns 0
273         // for contracts in construction, since the code is only stored at the end
274         // of the constructor execution.
275 
276         return account.code.length > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(
297             address(this).balance >= amount,
298             "Address: insufficient balance"
299         );
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(
303             success,
304             "Address: unable to send value, recipient may have reverted"
305         );
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(
327         address target,
328         bytes memory data
329     ) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return
364             functionCallWithValue(
365                 target,
366                 data,
367                 value,
368                 "Address: low-level call with value failed"
369             );
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(
385             address(this).balance >= value,
386             "Address: insufficient balance for call"
387         );
388         require(isContract(target), "Address: call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.call{value: value}(
391             data
392         );
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(
403         address target,
404         bytes memory data
405     ) internal view returns (bytes memory) {
406         return
407             functionStaticCall(
408                 target,
409                 data,
410                 "Address: low-level static call failed"
411             );
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal view returns (bytes memory) {
425         require(isContract(target), "Address: static call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(
438         address target,
439         bytes memory data
440     ) internal returns (bytes memory) {
441         return
442             functionDelegateCall(
443                 target,
444                 data,
445                 "Address: low-level delegate call failed"
446             );
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/utils/Context.sol
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 /**
500  * @dev Provides information about the current execution context, including the
501  * sender of the transaction and its data. While these are generally available
502  * via msg.sender and msg.data, they should not be accessed in such a direct
503  * manner, since when dealing with meta-transactions the account sending and
504  * paying for execution may not be the actual sender (as far as an application
505  * is concerned).
506  *
507  * This contract is only required for intermediate, library-like contracts.
508  */
509 abstract contract Context {
510     function _msgSender() internal view virtual returns (address) {
511         return msg.sender;
512     }
513 
514     function _msgData() internal view virtual returns (bytes calldata) {
515         return msg.data;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Strings.sol
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
522 
523 /**
524  * @dev String operations.
525  */
526 library Strings {
527     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
531      */
532     function toString(uint256 value) internal pure returns (string memory) {
533         // Inspired by OraclizeAPI's implementation - MIT licence
534         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
535 
536         if (value == 0) {
537             return "0";
538         }
539         uint256 temp = value;
540         uint256 digits;
541         while (temp != 0) {
542             digits++;
543             temp /= 10;
544         }
545         bytes memory buffer = new bytes(digits);
546         while (value != 0) {
547             digits -= 1;
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549             value /= 10;
550         }
551         return string(buffer);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
556      */
557     function toHexString(uint256 value) internal pure returns (string memory) {
558         if (value == 0) {
559             return "0x00";
560         }
561         uint256 temp = value;
562         uint256 length = 0;
563         while (temp != 0) {
564             length++;
565             temp >>= 8;
566         }
567         return toHexString(value, length);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
572      */
573     function toHexString(
574         uint256 value,
575         uint256 length
576     ) internal pure returns (string memory) {
577         bytes memory buffer = new bytes(2 * length + 2);
578         buffer[0] = "0";
579         buffer[1] = "x";
580         for (uint256 i = 2 * length + 1; i > 1; --i) {
581             buffer[i] = _HEX_SYMBOLS[value & 0xf];
582             value >>= 4;
583         }
584         require(value == 0, "Strings: hex length insufficient");
585         return string(buffer);
586     }
587 }
588 
589 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
592 
593 /**
594  * @dev Implementation of the {IERC165} interface.
595  *
596  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
597  * for the additional interface id that will be supported. For example:
598  *
599  * ```solidity
600  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
602  * }
603  * ```
604  *
605  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
606  */
607 abstract contract ERC165 is IERC165 {
608     /**
609      * @dev See {IERC165-supportsInterface}.
610      */
611     function supportsInterface(
612         bytes4 interfaceId
613     ) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
619 
620 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension, but not including the Enumerable extension, which is available separately as
625  * {ERC721Enumerable}.
626  */
627 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
628     using Address for address;
629     using Strings for uint256;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to owner address
638     mapping(uint256 => address) private _owners;
639 
640     // Mapping owner address to token count
641     mapping(address => uint256) private _balances;
642 
643     // Mapping from token ID to approved address
644     mapping(uint256 => address) private _tokenApprovals;
645 
646     // Mapping from owner to operator approvals
647     mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649     /**
650      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
651      */
652     constructor(string memory name_, string memory symbol_) {
653         _name = name_;
654         _symbol = symbol_;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(
661         bytes4 interfaceId
662     ) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664             interfaceId == type(IERC721).interfaceId ||
665             interfaceId == type(IERC721Metadata).interfaceId ||
666             super.supportsInterface(interfaceId);
667     }
668 
669     /**
670      * @dev See {IERC721-balanceOf}.
671      */
672     function balanceOf(
673         address owner
674     ) public view virtual override returns (uint256) {
675         require(
676             owner != address(0),
677             "ERC721: balance query for the zero address"
678         );
679         return _balances[owner];
680     }
681 
682     /**
683      * @dev See {IERC721-ownerOf}.
684      */
685     function ownerOf(
686         uint256 tokenId
687     ) public view virtual override returns (address) {
688         address owner = _owners[tokenId];
689         require(
690             owner != address(0),
691             "ERC721: owner query for nonexistent token"
692         );
693         return owner;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-name}.
698      */
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-symbol}.
705      */
706     function symbol() public view virtual override returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-tokenURI}.
712      */
713     function tokenURI(
714         uint256 tokenId
715     ) public view virtual override returns (string memory) {
716         require(
717             _exists(tokenId),
718             "ERC721Metadata: URI query for nonexistent token"
719         );
720 
721         string memory baseURI = _baseURI();
722         return
723             bytes(baseURI).length > 0
724                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
725                 : "";
726     }
727 
728     /**
729      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
730      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
731      * by default, can be overriden in child contracts.
732      */
733     function _baseURI() internal view virtual returns (string memory) {
734         return "";
735     }
736 
737     /**
738      * @dev See {IERC721-approve}.
739      */
740     function approve(address to, uint256 tokenId) public virtual override {
741         address owner = ERC721.ownerOf(tokenId);
742         require(to != owner, "ERC721: approval to current owner");
743 
744         require(
745             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
746             "ERC721: approve caller is not owner nor approved for all"
747         );
748 
749         _approve(to, tokenId);
750     }
751 
752     /**
753      * @dev See {IERC721-getApproved}.
754      */
755     function getApproved(
756         uint256 tokenId
757     ) public view virtual override returns (address) {
758         require(
759             _exists(tokenId),
760             "ERC721: approved query for nonexistent token"
761         );
762 
763         return _tokenApprovals[tokenId];
764     }
765 
766     /**
767      * @dev See {IERC721-setApprovalForAll}.
768      */
769     function setApprovalForAll(
770         address operator,
771         bool approved
772     ) public virtual override {
773         _setApprovalForAll(_msgSender(), operator, approved);
774     }
775 
776     /**
777      * @dev See {IERC721-isApprovedForAll}.
778      */
779     function isApprovedForAll(
780         address owner,
781         address operator
782     ) public view virtual override returns (bool) {
783         return _operatorApprovals[owner][operator];
784     }
785 
786     /**
787      * @dev See {IERC721-transferFrom}.
788      */
789     function transferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) public virtual override {
794         //solhint-disable-next-line max-line-length
795         require(
796             _isApprovedOrOwner(_msgSender(), tokenId),
797             "ERC721: transfer caller is not owner nor approved"
798         );
799 
800         _transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         safeTransferFrom(from, to, tokenId, "");
812     }
813 
814     /**
815      * @dev See {IERC721-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) public virtual override {
823         require(
824             _isApprovedOrOwner(_msgSender(), tokenId),
825             "ERC721: transfer caller is not owner nor approved"
826         );
827         _safeTransfer(from, to, tokenId, _data);
828     }
829 
830     /**
831      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
832      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
833      *
834      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
835      *
836      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
837      * implement alternative mechanisms to perform token transfer, such as signature-based.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must exist and be owned by `from`.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _safeTransfer(
849         address from,
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _transfer(from, to, tokenId);
855         require(
856             _checkOnERC721Received(from, to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Returns whether `tokenId` exists.
863      *
864      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
865      *
866      * Tokens start existing when they are minted (`_mint`),
867      * and stop existing when they are burned (`_burn`).
868      */
869     function _exists(uint256 tokenId) internal view virtual returns (bool) {
870         return _owners[tokenId] != address(0);
871     }
872 
873     /**
874      * @dev Returns whether `spender` is allowed to manage `tokenId`.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      */
880     function _isApprovedOrOwner(
881         address spender,
882         uint256 tokenId
883     ) internal view virtual returns (bool) {
884         require(
885             _exists(tokenId),
886             "ERC721: operator query for nonexistent token"
887         );
888         address owner = ERC721.ownerOf(tokenId);
889         return (spender == owner ||
890             getApproved(tokenId) == spender ||
891             isApprovedForAll(owner, spender));
892     }
893 
894     /**
895      * @dev Safely mints `tokenId` and transfers it to `to`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907 
908     /**
909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
911      */
912     function _safeMint(
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _mint(to, tokenId);
918         require(
919             _checkOnERC721Received(address(0), to, tokenId, _data),
920             "ERC721: transfer to non ERC721Receiver implementer"
921         );
922     }
923 
924     /**
925      * @dev Mints `tokenId` and transfers it to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - `to` cannot be the zero address.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(address to, uint256 tokenId) internal virtual {
937         require(to != address(0), "ERC721: mint to the zero address");
938         require(!_exists(tokenId), "ERC721: token already minted");
939 
940         _beforeTokenTransfer(address(0), to, tokenId);
941 
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(address(0), to, tokenId);
946 
947         _afterTokenTransfer(address(0), to, tokenId);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         address owner = ERC721.ownerOf(tokenId);
962 
963         _beforeTokenTransfer(owner, address(0), tokenId);
964 
965         // Clear approvals
966         _approve(address(0), tokenId);
967 
968         _balances[owner] -= 1;
969         delete _owners[tokenId];
970 
971         emit Transfer(owner, address(0), tokenId);
972 
973         _afterTokenTransfer(owner, address(0), tokenId);
974     }
975 
976     /**
977      * @dev Transfers `tokenId` from `from` to `to`.
978      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must be owned by `from`.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _transfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {
992         require(
993             ERC721.ownerOf(tokenId) == from,
994             "ERC721: transfer from incorrect owner"
995         );
996         require(to != address(0), "ERC721: transfer to the zero address");
997 
998         _beforeTokenTransfer(from, to, tokenId);
999 
1000         // Clear approvals from the previous owner
1001         _approve(address(0), tokenId);
1002 
1003         _balances[from] -= 1;
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(from, to, tokenId);
1008 
1009         _afterTokenTransfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `to` to operate on `tokenId`
1014      *
1015      * Emits a {Approval} event.
1016      */
1017     function _approve(address to, uint256 tokenId) internal virtual {
1018         _tokenApprovals[tokenId] = to;
1019         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `operator` to operate on all of `owner` tokens
1024      *
1025      * Emits a {ApprovalForAll} event.
1026      */
1027     function _setApprovalForAll(
1028         address owner,
1029         address operator,
1030         bool approved
1031     ) internal virtual {
1032         require(owner != operator, "ERC721: approve to caller");
1033         _operatorApprovals[owner][operator] = approved;
1034         emit ApprovalForAll(owner, operator, approved);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try
1055                 IERC721Receiver(to).onERC721Received(
1056                     _msgSender(),
1057                     from,
1058                     tokenId,
1059                     _data
1060                 )
1061             returns (bytes4 retval) {
1062                 return retval == IERC721Receiver.onERC721Received.selector;
1063             } catch (bytes memory reason) {
1064                 if (reason.length == 0) {
1065                     revert(
1066                         "ERC721: transfer to non ERC721Receiver implementer"
1067                     );
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after any transfer of tokens. This includes
1101      * minting and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero.
1106      * - `from` and `to` are never both zero.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _afterTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {}
1115 }
1116 
1117 // File: @openzeppelin/contracts/access/Ownable.sol
1118 
1119 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1120 
1121 /**
1122  * @dev Contract module which provides a basic access control mechanism, where
1123  * there is an account (an owner) that can be granted exclusive access to
1124  * specific functions.
1125  *
1126  * By default, the owner account will be the one that deploys the contract. This
1127  * can later be changed with {transferOwnership}.
1128  *
1129  * This module is used through inheritance. It will make available the modifier
1130  * `onlyOwner`, which can be applied to your functions to restrict their use to
1131  * the owner.
1132  */
1133 abstract contract Ownable is Context {
1134     address private _owner;
1135 
1136     event OwnershipTransferred(
1137         address indexed previousOwner,
1138         address indexed newOwner
1139     );
1140 
1141     /**
1142      * @dev Initializes the contract setting the deployer as the initial owner.
1143      */
1144     constructor() {
1145         _transferOwnership(_msgSender());
1146     }
1147 
1148     /**
1149      * @dev Returns the address of the current owner.
1150      */
1151     function owner() public view virtual returns (address) {
1152         return _owner;
1153     }
1154 
1155     /**
1156      * @dev Throws if called by any account other than the owner.
1157      */
1158     modifier onlyOwner() {
1159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1160         _;
1161     }
1162 
1163     /**
1164      * @dev Leaves the contract without owner. It will not be possible to call
1165      * `onlyOwner` functions anymore. Can only be called by the current owner.
1166      *
1167      * NOTE: Renouncing ownership will leave the contract without an owner,
1168      * thereby removing any functionality that is only available to the owner.
1169      */
1170     function renounceOwnership() public virtual onlyOwner {
1171         _transferOwnership(address(0));
1172     }
1173 
1174     /**
1175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1176      * Can only be called by the current owner.
1177      */
1178     function transferOwnership(address newOwner) public virtual onlyOwner {
1179         require(
1180             newOwner != address(0),
1181             "Ownable: new owner is the zero address"
1182         );
1183         _transferOwnership(newOwner);
1184     }
1185 
1186     /**
1187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1188      * Internal function without access restriction.
1189      */
1190     function _transferOwnership(address newOwner) internal virtual {
1191         address oldOwner = _owner;
1192         _owner = newOwner;
1193         emit OwnershipTransferred(oldOwner, newOwner);
1194     }
1195 }
1196 
1197 // File: contracts/BadApeKids.sol
1198 
1199 contract BadApeKids is ERC721, Ownable {
1200     using Strings for uint256;
1201 
1202     //NFT params
1203     string public baseURI;
1204     string public defaultURI = "https://www.badapekids.xyz/";
1205     string public mycontractURI;
1206     bool public finalizeBaseUri = false;
1207 
1208     //sale stages:
1209     //stage 0: init(no minting)
1210     //stage 1: burn mint
1211     //stage 2: free mint
1212     uint8 public stage = 0;
1213 
1214     event stageChanged(uint8 stage);
1215 
1216     address private deadAddress = 0x000000000000000000000000000000000000dEaD;
1217     IERC721 public apeKidsClubNFT;
1218     IERC721 public apeKidsPetNFT;
1219 
1220     mapping(uint256 => bool) public claimKidId;
1221     mapping(uint256 => bool) public claimPetId;
1222 
1223     // config
1224     // 1 - 350 mutant
1225     // 351 - 900 samurai
1226     // 901 - 1750 scifi
1227     // 1751 - 3000 gangster
1228     uint256 public mutantCount = 1;
1229     uint256 public samuraiCount = 1;
1230     uint256 public scifiCount = 1;
1231     uint256 public gangsterCount = 1;
1232 
1233     uint16 public constant maxMutantCount = 350;
1234     uint16 public constant maxSamuraiCount = 550;
1235     uint16 public constant maxScifiCount = 850;
1236     uint16 public constant maxGangsterCount = 1250;
1237     uint16 public constant maxSupply = 3000;
1238 
1239     bool public paused = false;
1240     uint256 public currentSupply;
1241 
1242     //royalty
1243     address public royaltyAddr = 0x808385e62d8Dbb230a39291B6e3B97120eD1Ee88;
1244     uint256 public royaltyBasis = 500;
1245 
1246     address[] public tier1Box;
1247     address[] public tier2Box;
1248     address[] public tier3Box;
1249     address[] public tier4Box;
1250 
1251     constructor(
1252         string memory _name,
1253         string memory _symbol,
1254         string memory _initBaseURI,
1255         address _apeKidsClubNFT,
1256         address _apeKidsPetNFT
1257     ) ERC721(_name, _symbol) {
1258         setBaseURI(_initBaseURI);
1259         apeKidsClubNFT = IERC721(_apeKidsClubNFT);
1260         apeKidsPetNFT = IERC721(_apeKidsPetNFT);
1261     }
1262 
1263     function _baseURI() internal view virtual override returns (string memory) {
1264         return baseURI;
1265     }
1266 
1267     function supportsInterface(
1268         bytes4 interfaceId
1269     ) public view override(ERC721) returns (bool) {
1270         return
1271             interfaceId == type(IERC721).interfaceId ||
1272             interfaceId == 0xe8a3d485 /* contractURI() */ ||
1273             interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1274             super.supportsInterface(interfaceId);
1275     }
1276 
1277     function burnMint(
1278         uint8 _option,
1279         uint256[] memory _petIdsToBurn,
1280         uint256[] memory _kidIdToBurn
1281     ) public {
1282         require(!paused, "contract paused");
1283         require(stage == 1, "Invalid Stage");
1284         require(_option > 0 && _option <= 4, "Invalid option");
1285 
1286         if (_option == 1) {
1287             // burn 1 AKC, 1 PET , get 1 Mutant Bad Kid + T4 game box
1288             require(_kidIdToBurn.length >= 1, "Must burn 1 pets");
1289             require(_petIdsToBurn.length >= 1, "Must burn at least one pet");
1290             require(
1291                 _petIdsToBurn.length == _kidIdToBurn.length,
1292                 "Must burn the same amount"
1293             );
1294 
1295             for (uint8 i = 0; i < _kidIdToBurn.length; i++) {
1296                 require(
1297                     mutantCount <= maxMutantCount,
1298                     "Mint exceed max supply"
1299                 );
1300                 apeKidsClubNFT.transferFrom(
1301                     msg.sender,
1302                     deadAddress,
1303                     _kidIdToBurn[i]
1304                 );
1305                 apeKidsPetNFT.transferFrom(
1306                     msg.sender,
1307                     deadAddress,
1308                     _petIdsToBurn[i]
1309                 );
1310                 _mint(msg.sender, mutantCount);
1311                 mutantCount++;
1312                 tier4Box.push(msg.sender);
1313             }
1314         } else if (_option == 2) {
1315             // Burn 1 AKC, get 1 Samurai Bad Kid + T3 game box
1316             require(_kidIdToBurn.length >= 1, "Must burn at least one kid");
1317 
1318             for (uint8 i = 0; i < _kidIdToBurn.length; i++) {
1319                 require(
1320                     samuraiCount <= maxSamuraiCount,
1321                     "Mint exceed max supply"
1322                 );
1323 
1324                 apeKidsClubNFT.transferFrom(
1325                     msg.sender,
1326                     deadAddress,
1327                     _kidIdToBurn[i]
1328                 );
1329                 _mint(
1330                     msg.sender,
1331                     samuraiCount +
1332                         maxSupply -
1333                         maxGangsterCount -
1334                         maxScifiCount -
1335                         maxSamuraiCount
1336                 );
1337                 samuraiCount++;
1338                 tier3Box.push(msg.sender);
1339             }
1340         } else if (_option == 3) {
1341             // Burn 3 PET, get 1 Scifi Bad Kid  + T2 game box
1342             require(_petIdsToBurn.length >= 3, "Must burn at least 3 pets");
1343             require(
1344                 _petIdsToBurn.length % 3 == 0,
1345                 "Must burn 3 multiplier pets"
1346             );
1347 
1348             uint256 amount = _petIdsToBurn.length / 3;
1349 
1350             for (uint8 i = 0; i < _petIdsToBurn.length; i++) {
1351                 apeKidsPetNFT.transferFrom(
1352                     msg.sender,
1353                     deadAddress,
1354                     _petIdsToBurn[i]
1355                 );
1356             }
1357 
1358             for (uint8 i = 0; i < amount; i++) {
1359                 require(scifiCount <= maxScifiCount, "Mint exceed max supply");
1360                 _mint(
1361                     msg.sender,
1362                     scifiCount + maxSupply - maxGangsterCount - maxScifiCount
1363                 );
1364                 scifiCount++;
1365                 tier2Box.push(msg.sender);
1366             }
1367         } else if (_option == 4) {
1368             // Burn 2 PET, get 1 Gangsta Bad Kid + T1 game box
1369             require(_petIdsToBurn.length >= 2, "Must burn at least 2 pets");
1370             require(
1371                 _petIdsToBurn.length % 2 == 0,
1372                 "Must burn 2 multiplier pets"
1373             );
1374             uint256 amount = _petIdsToBurn.length / 2;
1375 
1376             for (uint8 i = 0; i < _petIdsToBurn.length; i++) {
1377                 apeKidsPetNFT.transferFrom(
1378                     msg.sender,
1379                     deadAddress,
1380                     _petIdsToBurn[i]
1381                 );
1382             }
1383             for (uint8 i = 0; i < amount; i++) {
1384                 require(
1385                     gangsterCount <= maxGangsterCount,
1386                     "Mint exceed max supply"
1387                 );
1388                 _mint(msg.sender, gangsterCount + maxSupply - maxGangsterCount);
1389                 gangsterCount++;
1390                 tier1Box.push(msg.sender);
1391             }
1392         }
1393         currentSupply++;
1394     }
1395 
1396     function freeMint(
1397         uint8 _option,
1398         uint256[] memory _kidId,
1399         uint256[] memory _petId
1400     ) public {
1401         require(stage == 2, "Invalid Stage");
1402         require(!paused, "contract paused");
1403         require(_option > 0 && _option <= 2, "Invalid option");
1404 
1405         if (_option == 1) {
1406             require(_petId.length >= 1, "must have a pet");
1407             require(_kidId.length >= 1, "must have a kid");
1408             require(_kidId.length == _petId.length, "incorrect length");
1409             // claim with 1 kid and pet for gangster
1410             for (uint8 i = 0; i < _kidId.length; i++) {
1411                 require(!claimKidId[_kidId[i]], "Kid already claimed");
1412                 require(!claimPetId[_petId[i]], "Pet already claimed");
1413                 require(
1414                     apeKidsClubNFT.ownerOf(_kidId[i]) == msg.sender,
1415                     "Invalid Owner"
1416                 );
1417                 require(
1418                     gangsterCount <= maxGangsterCount,
1419                     "Mint exceed max supply"
1420                 );
1421                 claimKidId[_kidId[i]] = true;
1422                 claimPetId[_petId[i]] = true;
1423                 _mint(tx.origin, gangsterCount + maxSupply - maxGangsterCount);
1424                 gangsterCount++;
1425                 tier1Box.push(msg.sender);
1426             }
1427         } else if (_option == 2) {
1428             require(_petId.length >= 2, "must have at least 2 pet");
1429             require(_kidId.length >= 1, "must have a kid");
1430             require(2 * _kidId.length == _petId.length, "incorrect length");
1431             require(scifiCount <= maxScifiCount, "Mint exceed max supply");
1432 
1433             for (uint8 i = 0; i < _petId.length; i++) {
1434                 require(!claimPetId[_petId[i]], "Pet already claimed");
1435                 require(
1436                     apeKidsPetNFT.ownerOf(_petId[i]) == msg.sender,
1437                     "Invalid Owner"
1438                 );
1439                 claimPetId[_petId[i]] = true;
1440             }
1441 
1442             for (uint8 i = 0; i < _kidId.length; i++) {
1443                 require(
1444                     apeKidsClubNFT.ownerOf(_kidId[i]) == msg.sender,
1445                     "Invalid Owner"
1446                 );
1447 
1448                 claimKidId[_kidId[i]] = true;
1449 
1450                 _mint(
1451                     tx.origin,
1452                     scifiCount + maxSupply - maxGangsterCount - maxScifiCount
1453                 );
1454                 scifiCount++;
1455                 tier1Box.push(msg.sender);
1456             }
1457         }
1458 
1459         currentSupply++;
1460     }
1461 
1462     function totalSupply() public view returns (uint256) {
1463         return currentSupply;
1464     }
1465 
1466     function tokensOfOwner(
1467         address _owner,
1468         uint256 startId,
1469         uint256 endId
1470     ) external view returns (uint256[] memory) {
1471         uint256 tokenCount = balanceOf(_owner);
1472         if (tokenCount == 0) {
1473             return new uint256[](0);
1474         } else {
1475             uint256[] memory result = new uint256[](tokenCount);
1476             uint256 index = 0;
1477 
1478             for (uint256 tokenId = startId; tokenId < endId; tokenId++) {
1479                 if (index == tokenCount) break;
1480 
1481                 if (ownerOf(tokenId) == _owner) {
1482                     result[index] = tokenId;
1483                     index++;
1484                 }
1485             }
1486 
1487             return result;
1488         }
1489     }
1490 
1491     function tokenURI(
1492         uint256 tokenId
1493     ) public view virtual override returns (string memory) {
1494         require(
1495             _exists(tokenId),
1496             "ERC721Metadata: URI query for nonexistent token"
1497         );
1498 
1499         string memory currentBaseURI = _baseURI();
1500         return
1501             bytes(currentBaseURI).length > 0
1502                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1503                 : defaultURI;
1504     }
1505 
1506     function contractURI() public view returns (string memory) {
1507         return string(abi.encodePacked(mycontractURI));
1508     }
1509 
1510     function royaltyInfo(
1511         uint256 _tokenId,
1512         uint256 _salePrice
1513     ) external view returns (address receiver, uint256 royaltyAmount) {
1514         return (royaltyAddr, (_salePrice * royaltyBasis) / 10000);
1515     }
1516 
1517     function nextStage() public onlyOwner {
1518         require(stage < 2, "Stage cannot be more than 2");
1519         stage++;
1520         emit stageChanged(stage);
1521     }
1522 
1523     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1524         require(!finalizeBaseUri);
1525         baseURI = _newBaseURI;
1526     }
1527 
1528     function finalizeBaseURI() public onlyOwner {
1529         finalizeBaseUri = true;
1530     }
1531 
1532     function setContractURI(string memory _contractURI) public onlyOwner {
1533         mycontractURI = _contractURI;
1534     }
1535 
1536     function setRoyalty(
1537         address _royaltyAddr,
1538         uint256 _royaltyBasis
1539     ) public onlyOwner {
1540         royaltyAddr = _royaltyAddr;
1541         royaltyBasis = _royaltyBasis;
1542     }
1543 
1544     function pause(bool _state) public onlyOwner {
1545         paused = _state;
1546     }
1547 
1548     function getAllBox(
1549         uint8 option
1550     ) public view returns (address[] memory entitledAddresses) {
1551         require(option >= 1 && option <= 4, "invalid option");
1552 
1553         if (option == 1) {
1554             return tier1Box;
1555         } else if (option == 2) {
1556             return tier2Box;
1557         } else if (option == 3) {
1558             return tier3Box;
1559         } else if (option == 4) {
1560             return tier4Box;
1561         }
1562     }
1563 }