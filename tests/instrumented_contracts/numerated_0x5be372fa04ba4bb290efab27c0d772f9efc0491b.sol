1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-12-10
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-11-18
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity ^0.8.7;
15 
16 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
17 
18 
19 /**
20  * @dev Interface of the ERC165 standard, as defined in the
21  * https://eips.ethereum.org/EIPS/eip-165[EIP].
22  *
23  * Implementers can declare support of contract interfaces, which can then be
24  * queried by others ({ERC165Checker}).
25  *
26  * For an implementation, see {ERC165}.
27  */
28 interface IERC165 {
29     /**
30      * @dev Returns true if this contract implements the interface defined by
31      * `interfaceId`. See the corresponding
32      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
33      * to learn more about how these ids are created.
34      *
35      * This function call must use less than 30 000 gas.
36      */
37     function supportsInterface(bytes4 interfaceId) external view returns (bool);
38 }
39 
40 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
41 
42 /**
43  * @dev Required interface of an ERC721 compliant contract.
44  */
45 interface IERC721 is IERC165 {
46     /**
47      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
48      */
49     event Transfer(
50         address indexed from,
51         address indexed to,
52         uint256 indexed tokenId
53     );
54 
55     /**
56      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
57      */
58     event Approval(
59         address indexed owner,
60         address indexed approved,
61         uint256 indexed tokenId
62     );
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(
68         address indexed owner,
69         address indexed operator,
70         bool approved
71     );
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId)
150         external
151         view
152         returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator)
172         external
173         view
174         returns (bool);
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId,
193         bytes calldata data
194     ) external;
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
198 
199 /**
200  * @title ERC721 token receiver interface
201  * @dev Interface for any contract that wants to support safeTransfers
202  * from ERC721 asset contracts.
203  */
204 interface IERC721Receiver {
205     /**
206      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
207      * by `operator` from `from`, this function is called.
208      *
209      * It must return its Solidity selector to confirm the token transfer.
210      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
211      *
212      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
213      */
214     function onERC721Received(
215         address operator,
216         address from,
217         uint256 tokenId,
218         bytes calldata data
219     ) external returns (bytes4);
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
226  * @dev See https://eips.ethereum.org/EIPS/eip-721
227  */
228 interface IERC721Metadata is IERC721 {
229     /**
230      * @dev Returns the token collection name.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the token collection symbol.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
241      */
242     function tokenURI(uint256 tokenId) external view returns (string memory);
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         assembly {
275             size := extcodesize(account)
276         }
277         return size > 0;
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(
298             address(this).balance >= amount,
299             "Address: insufficient balance"
300         );
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(
304             success,
305             "Address: unable to send value, recipient may have reverted"
306         );
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data)
328         internal
329         returns (bytes memory)
330     {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value
363     ) internal returns (bytes memory) {
364         return
365             functionCallWithValue(
366                 target,
367                 data,
368                 value,
369                 "Address: low-level call with value failed"
370             );
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(
386             address(this).balance >= value,
387             "Address: insufficient balance for call"
388         );
389         require(isContract(target), "Address: call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.call{value: value}(
392             data
393         );
394         return _verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data)
404         internal
405         view
406         returns (bytes memory)
407     {
408         return
409             functionStaticCall(
410                 target,
411                 data,
412                 "Address: low-level static call failed"
413             );
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return _verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data)
440         internal
441         returns (bytes memory)
442     {
443         return
444             functionDelegateCall(
445                 target,
446                 data,
447                 "Address: low-level delegate call failed"
448             );
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(isContract(target), "Address: delegate call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(
469         bool success,
470         bytes memory returndata,
471         string memory errorMessage
472     ) private pure returns (bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479 
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/utils/Context.sol
492 
493 pragma solidity ^0.8.0;
494 
495 /*
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes calldata) {
511         return msg.data;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/Strings.sol
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev String operations.
521  */
522 library Strings {
523     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
527      */
528     function toString(uint256 value) internal pure returns (string memory) {
529         // Inspired by OraclizeAPI's implementation - MIT licence
530         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
531 
532         if (value == 0) {
533             return "0";
534         }
535         uint256 temp = value;
536         uint256 digits;
537         while (temp != 0) {
538             digits++;
539             temp /= 10;
540         }
541         bytes memory buffer = new bytes(digits);
542         while (value != 0) {
543             digits -= 1;
544             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
545             value /= 10;
546         }
547         return string(buffer);
548     }
549 
550     /**
551      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
552      */
553     function toHexString(uint256 value) internal pure returns (string memory) {
554         if (value == 0) {
555             return "0x00";
556         }
557         uint256 temp = value;
558         uint256 length = 0;
559         while (temp != 0) {
560             length++;
561             temp >>= 8;
562         }
563         return toHexString(value, length);
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
568      */
569     function toHexString(uint256 value, uint256 length)
570         internal
571         pure
572         returns (string memory)
573     {
574         bytes memory buffer = new bytes(2 * length + 2);
575         buffer[0] = "0";
576         buffer[1] = "x";
577         for (uint256 i = 2 * length + 1; i > 1; --i) {
578             buffer[i] = _HEX_SYMBOLS[value & 0xf];
579             value >>= 4;
580         }
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
594  * for the additional interface id that will be supported. For example:
595  *
596  * ```solidity
597  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
599  * }
600  * ```
601  *
602  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
603  */
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId)
609         public
610         view
611         virtual
612         override
613         returns (bool)
614     {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
625  * the Metadata extension, but not including the Enumerable extension, which is available separately as
626  * {ERC721Enumerable}.
627  */
628 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
629     using Address for address;
630     using Strings for uint256;
631 
632     // Token name
633     string private _name;
634 
635     // Token symbol
636     string private _symbol;
637 
638     // Mapping from token ID to owner address
639     mapping(uint256 => address) private _owners;
640 
641     // Mapping owner address to token count
642     mapping(address => uint256) private _balances;
643 
644     // Mapping from token ID to approved address
645     mapping(uint256 => address) private _tokenApprovals;
646 
647     // Mapping from owner to operator approvals
648     mapping(address => mapping(address => bool)) private _operatorApprovals;
649 
650     /**
651      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
652      */
653     constructor(string memory name_, string memory symbol_) {
654         _name = name_;
655         _symbol = symbol_;
656     }
657 
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId)
662         public
663         view
664         virtual
665         override(ERC165, IERC165)
666         returns (bool)
667     {
668         return
669             interfaceId == type(IERC721).interfaceId ||
670             interfaceId == type(IERC721Metadata).interfaceId ||
671             super.supportsInterface(interfaceId);
672     }
673 
674     /**
675      * @dev See {IERC721-balanceOf}.
676      */
677     function balanceOf(address owner)
678         public
679         view
680         virtual
681         override
682         returns (uint256)
683     {
684         require(
685             owner != address(0),
686             "ERC721: balance query for the zero address"
687         );
688         return _balances[owner];
689     }
690 
691     /**
692      * @dev See {IERC721-ownerOf}.
693      */
694     function ownerOf(uint256 tokenId)
695         public
696         view
697         virtual
698         override
699         returns (address)
700     {
701         address owner = _owners[tokenId];
702         require(
703             owner != address(0),
704             "ERC721: owner query for nonexistent token"
705         );
706         return owner;
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-name}.
711      */
712     function name() public view virtual override returns (string memory) {
713         return _name;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-symbol}.
718      */
719     function symbol() public view virtual override returns (string memory) {
720         return _symbol;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-tokenURI}.
725      */
726     function tokenURI(uint256 tokenId)
727         public
728         view
729         virtual
730         override
731         returns (string memory)
732     {
733         require(
734             _exists(tokenId),
735             "ERC721Metadata: URI query for nonexistent token"
736         );
737 
738         string memory baseURI = _baseURI();
739         return
740             bytes(baseURI).length > 0
741                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
742                 : "";
743     }
744 
745     /**
746      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
747      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
748      * by default, can be overriden in child contracts.
749      */
750     function _baseURI() internal view virtual returns (string memory) {
751         return "";
752     }
753 
754     /**
755      * @dev See {IERC721-approve}.
756      */
757     function approve(address to, uint256 tokenId) public virtual override {
758         address owner = ERC721.ownerOf(tokenId);
759         require(to != owner, "ERC721: approval to current owner");
760 
761         require(
762             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
763             "ERC721: approve caller is not owner nor approved for all"
764         );
765 
766         _approve(to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-getApproved}.
771      */
772     function getApproved(uint256 tokenId)
773         public
774         view
775         virtual
776         override
777         returns (address)
778     {
779         require(
780             _exists(tokenId),
781             "ERC721: approved query for nonexistent token"
782         );
783 
784         return _tokenApprovals[tokenId];
785     }
786 
787     /**
788      * @dev See {IERC721-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved)
791         public
792         virtual
793         override
794     {
795         require(operator != _msgSender(), "ERC721: approve to caller");
796 
797         _operatorApprovals[_msgSender()][operator] = approved;
798         emit ApprovalForAll(_msgSender(), operator, approved);
799     }
800 
801     /**
802      * @dev See {IERC721-isApprovedForAll}.
803      */
804     function isApprovedForAll(address owner, address operator)
805         public
806         view
807         virtual
808         override
809         returns (bool)
810     {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         //solhint-disable-next-line max-line-length
823         require(
824             _isApprovedOrOwner(_msgSender(), tokenId),
825             "ERC721: transfer caller is not owner nor approved"
826         );
827 
828         _transfer(from, to, tokenId);
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public virtual override {
839         safeTransferFrom(from, to, tokenId, "");
840     }
841 
842     /**
843      * @dev See {IERC721-safeTransferFrom}.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) public virtual override {
851         require(
852             _isApprovedOrOwner(_msgSender(), tokenId),
853             "ERC721: transfer caller is not owner nor approved"
854         );
855         _safeTransfer(from, to, tokenId, _data);
856     }
857 
858     /**
859      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
860      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
861      *
862      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
863      *
864      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
865      * implement alternative mechanisms to perform token transfer, such as signature-based.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeTransfer(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) internal virtual {
882         _transfer(from, to, tokenId);
883         require(
884             _checkOnERC721Received(from, to, tokenId, _data),
885             "ERC721: transfer to non ERC721Receiver implementer"
886         );
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      * and stop existing when they are burned (`_burn`).
896      */
897     function _exists(uint256 tokenId) internal view virtual returns (bool) {
898         return _owners[tokenId] != address(0);
899     }
900 
901     /**
902      * @dev Returns whether `spender` is allowed to manage `tokenId`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function _isApprovedOrOwner(address spender, uint256 tokenId)
909         internal
910         view
911         virtual
912         returns (bool)
913     {
914         require(
915             _exists(tokenId),
916             "ERC721: operator query for nonexistent token"
917         );
918         address owner = ERC721.ownerOf(tokenId);
919         return (spender == owner ||
920             getApproved(tokenId) == spender ||
921             isApprovedForAll(owner, spender));
922     }
923 
924     /**
925      * @dev Safely mints `tokenId` and transfers it to `to`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must not exist.
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeMint(address to, uint256 tokenId) internal virtual {
935         _safeMint(to, tokenId, "");
936     }
937 
938     /**
939      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
940      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
941      */
942     function _safeMint(
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) internal virtual {
947         _mint(to, tokenId);
948         require(
949             _checkOnERC721Received(address(0), to, tokenId, _data),
950             "ERC721: transfer to non ERC721Receiver implementer"
951         );
952     }
953 
954     /**
955      * @dev Mints `tokenId` and transfers it to `to`.
956      *
957      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
958      *
959      * Requirements:
960      *
961      * - `tokenId` must not exist.
962      * - `to` cannot be the zero address.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _mint(address to, uint256 tokenId) internal virtual {
967         require(to != address(0), "ERC721: mint to the zero address");
968         require(!_exists(tokenId), "ERC721: token already minted");
969 
970         _beforeTokenTransfer(address(0), to, tokenId);
971 
972         _balances[to] += 1;
973         _owners[tokenId] = to;
974 
975         emit Transfer(address(0), to, tokenId);
976     }
977 
978     /**
979      * @dev Destroys `tokenId`.
980      * The approval is cleared when the token is burned.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must exist.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _burn(uint256 tokenId) internal virtual {
989         address owner = ERC721.ownerOf(tokenId);
990 
991         _beforeTokenTransfer(owner, address(0), tokenId);
992 
993         // Clear approvals
994         _approve(address(0), tokenId);
995 
996         _balances[owner] -= 1;
997         delete _owners[tokenId];
998 
999         emit Transfer(owner, address(0), tokenId);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal virtual {
1018         require(
1019             ERC721.ownerOf(tokenId) == from,
1020             "ERC721: transfer of token that is not own"
1021         );
1022         require(to != address(0), "ERC721: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(from, to, tokenId);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId);
1028 
1029         _balances[from] -= 1;
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(address to, uint256 tokenId) internal virtual {
1042         _tokenApprovals[tokenId] = to;
1043         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try
1064                 IERC721Receiver(to).onERC721Received(
1065                     _msgSender(),
1066                     from,
1067                     tokenId,
1068                     _data
1069                 )
1070             returns (bytes4 retval) {
1071                 return retval == IERC721Receiver(to).onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert(
1075                         "ERC721: transfer to non ERC721Receiver implementer"
1076                     );
1077                 } else {
1078                     assembly {
1079                         revert(add(32, reason), mload(reason))
1080                     }
1081                 }
1082             }
1083         } else {
1084             return true;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` and `to` are never both zero.
1099      *
1100      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1101      */
1102     function _beforeTokenTransfer(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) internal virtual {}
1107 }
1108 
1109 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 /**
1114  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1115  * @dev See https://eips.ethereum.org/EIPS/eip-721
1116  */
1117 interface IERC721Enumerable is IERC721 {
1118     /**
1119      * @dev Returns the total amount of tokens stored by the contract.
1120      */
1121     function totalSupply() external view returns (uint256);
1122 
1123     /**
1124      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1125      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1126      */
1127     function tokenOfOwnerByIndex(address owner, uint256 index)
1128         external
1129         view
1130         returns (uint256 tokenId);
1131 
1132     /**
1133      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1134      * Use along with {totalSupply} to enumerate all tokens.
1135      */
1136     function tokenByIndex(uint256 index) external view returns (uint256);
1137 }
1138 
1139 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 /**
1144  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1145  * enumerability of all the token ids in the contract as well as all token ids owned by each
1146  * account.
1147  */
1148 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1149     // Mapping from owner to list of owned token IDs
1150     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1151 
1152     // Mapping from token ID to index of the owner tokens list
1153     mapping(uint256 => uint256) private _ownedTokensIndex;
1154 
1155     // Array with all token ids, used for enumeration
1156     uint256[] private _allTokens;
1157 
1158     // Mapping from token id to position in the allTokens array
1159     mapping(uint256 => uint256) private _allTokensIndex;
1160 
1161     /**
1162      * @dev See {IERC165-supportsInterface}.
1163      */
1164     function supportsInterface(bytes4 interfaceId)
1165         public
1166         view
1167         virtual
1168         override(IERC165, ERC721)
1169         returns (bool)
1170     {
1171         return
1172             interfaceId == type(IERC721Enumerable).interfaceId ||
1173             super.supportsInterface(interfaceId);
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1178      */
1179     function tokenOfOwnerByIndex(address owner, uint256 index)
1180         public
1181         view
1182         virtual
1183         override
1184         returns (uint256)
1185     {
1186         require(
1187             index < ERC721.balanceOf(owner),
1188             "ERC721Enumerable: owner index out of bounds"
1189         );
1190         return _ownedTokens[owner][index];
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-totalSupply}.
1195      */
1196     function totalSupply() public view virtual override returns (uint256) {
1197         return _allTokens.length;
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Enumerable-tokenByIndex}.
1202      */
1203     function tokenByIndex(uint256 index)
1204         public
1205         view
1206         virtual
1207         override
1208         returns (uint256)
1209     {
1210         require(
1211             index < ERC721Enumerable.totalSupply(),
1212             "ERC721Enumerable: global index out of bounds"
1213         );
1214         return _allTokens[index];
1215     }
1216 
1217     /**
1218      * @dev Hook that is called before any token transfer. This includes minting
1219      * and burning.
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` will be minted for `to`.
1226      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1227      * - `from` cannot be the zero address.
1228      * - `to` cannot be the zero address.
1229      *
1230      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1231      */
1232     function _beforeTokenTransfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) internal virtual override {
1237         super._beforeTokenTransfer(from, to, tokenId);
1238 
1239         if (from == address(0)) {
1240             _addTokenToAllTokensEnumeration(tokenId);
1241         } else if (from != to) {
1242             _removeTokenFromOwnerEnumeration(from, tokenId);
1243         }
1244         if (to == address(0)) {
1245             _removeTokenFromAllTokensEnumeration(tokenId);
1246         } else if (to != from) {
1247             _addTokenToOwnerEnumeration(to, tokenId);
1248         }
1249     }
1250 
1251     /**
1252      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1253      * @param to address representing the new owner of the given token ID
1254      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1255      */
1256     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1257         uint256 length = ERC721.balanceOf(to);
1258         _ownedTokens[to][length] = tokenId;
1259         _ownedTokensIndex[tokenId] = length;
1260     }
1261 
1262     /**
1263      * @dev Private function to add a token to this extension's token tracking data structures.
1264      * @param tokenId uint256 ID of the token to be added to the tokens list
1265      */
1266     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1267         _allTokensIndex[tokenId] = _allTokens.length;
1268         _allTokens.push(tokenId);
1269     }
1270 
1271     /**
1272      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1273      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1274      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1275      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1276      * @param from address representing the previous owner of the given token ID
1277      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1278      */
1279     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1280         private
1281     {
1282         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1283         // then delete the last slot (swap and pop).
1284 
1285         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1286         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1287 
1288         // When the token to delete is the last token, the swap operation is unnecessary
1289         if (tokenIndex != lastTokenIndex) {
1290             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1291 
1292             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1293             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1294         }
1295 
1296         // This also deletes the contents at the last position of the array
1297         delete _ownedTokensIndex[tokenId];
1298         delete _ownedTokens[from][lastTokenIndex];
1299     }
1300 
1301     /**
1302      * @dev Private function to remove a token from this extension's token tracking data structures.
1303      * This has O(1) time complexity, but alters the order of the _allTokens array.
1304      * @param tokenId uint256 ID of the token to be removed from the tokens list
1305      */
1306     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1307         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1308         // then delete the last slot (swap and pop).
1309 
1310         uint256 lastTokenIndex = _allTokens.length - 1;
1311         uint256 tokenIndex = _allTokensIndex[tokenId];
1312 
1313         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1314         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1315         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1316         uint256 lastTokenId = _allTokens[lastTokenIndex];
1317 
1318         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1319         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1320 
1321         // This also deletes the contents at the last position of the array
1322         delete _allTokensIndex[tokenId];
1323         _allTokens.pop();
1324     }
1325 }
1326 
1327 // File: @openzeppelin/contracts/access/Ownable.sol
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 /**
1332  * @dev Contract module which provides a basic access control mechanism, where
1333  * there is an account (an owner) that can be granted exclusive access to
1334  * specific functions.
1335  *
1336  * By default, the owner account will be the one that deploys the contract. This
1337  * can later be changed with {transferOwnership}.
1338  *
1339  * This module is used through inheritance. It will make available the modifier
1340  * `onlyOwner`, which can be applied to your functions to restrict their use to
1341  * the owner.
1342  */
1343 abstract contract Ownable is Context {
1344     address private _owner;
1345 
1346     event OwnershipTransferred(
1347         address indexed previousOwner,
1348         address indexed newOwner
1349     );
1350 
1351     /**
1352      * @dev Initializes the contract setting the deployer as the initial owner.
1353      */
1354     constructor() {
1355         _setOwner(_msgSender());
1356     }
1357 
1358     /**
1359      * @dev Returns the address of the current owner.
1360      */
1361     function owner() public view virtual returns (address) {
1362         return _owner;
1363     }
1364 
1365     /**
1366      * @dev Throws if called by any account other than the owner.
1367      */
1368     modifier onlyOwner() {
1369         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1370         _;
1371     }
1372 
1373     /**
1374      * @dev Leaves the contract without owner. It will not be possible to call
1375      * `onlyOwner` functions anymore. Can only be called by the current owner.
1376      *
1377      * NOTE: Renouncing ownership will leave the contract without an owner,
1378      * thereby removing any functionality that is only available to the owner.
1379      */
1380     function renounceOwnership() public virtual onlyOwner {
1381         _setOwner(address(0));
1382     }
1383 
1384     /**
1385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1386      * Can only be called by the current owner.
1387      */
1388     function transferOwnership(address newOwner) public virtual onlyOwner {
1389         require(
1390             newOwner != address(0),
1391             "Ownable: new owner is the zero address"
1392         );
1393         _setOwner(newOwner);
1394     }
1395 
1396     function _setOwner(address newOwner) private {
1397         address oldOwner = _owner;
1398         _owner = newOwner;
1399         emit OwnershipTransferred(oldOwner, newOwner);
1400     }
1401 }
1402 
1403 contract FlashMintsYaasmynFula is ERC721, Ownable {
1404     bool public saleActive = false;
1405 
1406     string internal baseTokenURI = "https://flashmints.mypinata.cloud/ipfs/QmTBtWZp9XeDeV31tRGi5rstYNSJSCkZMz6HijFNEdP3w6/";
1407 
1408     uint256 public price = 0.1 ether;
1409     uint256 public totalSupply = 1004;
1410     uint256 public nonce = 0;
1411     uint256 public maxTx = 10;
1412 
1413     address public m1 = 0x7D58e81CeCf7F1B0071580CAB07d53EDE7858B17;
1414     address public m2 = 0x4f95219f13dC43641645B5ebE5259b040e38b281;
1415     address public m3 = 0x70184259C8CbF0B85C96e2A84ad74EB097759aeE;
1416     address public m4 = 0xdeF4274dA60CEF85402731F0013E5C67fC3D5c2e;
1417     address public m5 = 0x2027e0fE56278f671D174CbE4BCd7A42D25cc6a3;
1418     address public m6 = 0x57ccEFe8fDD9F2B17B9dD148061ae9a5f3a7e767;
1419     address public m7 = 0x80f039085f78fFF512a1edE6d25eC64927392888;
1420 
1421     address public a1 = 0x1E815a8188F1b84564577C1c998f7E6B4706B752;
1422     address public a2 = 0x607502216Cfe3bFe8407Ee5Ef62e9A4cFEfcb66C;
1423     address public a3 = 0x2E875DD72caa1E85EFe0A35A20418a0D683dB0A2;
1424 
1425     constructor() ERC721("Flash Mints (Yaasmyn Fula - The Untold Story of Tupac Amaru Shakur & Yaki 'Kadafi' Fula)", "FLASHMINTS-YAASMYNFULA") {}
1426 
1427     function _baseURI() internal override view returns (string memory) {
1428         return baseTokenURI;
1429     }
1430 
1431     function setPrice(uint256 newPrice) external onlyOwner {
1432         price = newPrice;
1433     }
1434 
1435     function setBaseTokenURI(string calldata uri) external onlyOwner {
1436         baseTokenURI = uri;
1437     }
1438 
1439     function setTotalSupply(uint256 newSupply) external onlyOwner {
1440         totalSupply = newSupply;
1441     }
1442 
1443     function setSaleActive(bool val) public onlyOwner {
1444         saleActive = val;
1445     }
1446 
1447     function setMembersAddresses(address[] memory _a) public onlyOwner {
1448         m1 = _a[0];
1449         m2 = _a[1];
1450         m3 = _a[2];
1451         m4 = _a[3];
1452         m5 = _a[4];
1453         m6 = _a[5];
1454         m7 = _a[6];
1455         a1 = _a[7];
1456         a2 = _a[8];
1457         a3 = _a[9];
1458     }
1459 
1460     function setMaxTx(uint256 newMax) external onlyOwner {
1461         maxTx = newMax;
1462     }
1463 
1464     function giveaway(address to, uint256 qty) external onlyOwner {
1465         require(qty + nonce <= totalSupply, "Value exceeds total supply");
1466         for (uint256 i = 0; i < qty; i++) {
1467             nonce++;
1468             uint256 tokenId = nonce;
1469             _safeMint(to, tokenId);
1470         }
1471     }
1472 
1473     function mint(uint256 qty) external payable {
1474         require(saleActive, "Sale isn't active");
1475         require(qty <= maxTx && qty > 0, "Qty of mints not allowed");
1476         require(qty + nonce <= totalSupply, "Value exceeds total supply");
1477         require(msg.value == price * qty, "Invalid value");
1478         for (uint256 i = 0; i < qty; i++) {
1479             nonce++;
1480             uint256 tokenId = nonce;
1481             _safeMint(msg.sender, tokenId);
1482         }
1483     }
1484 
1485     function withdrawTeam() external onlyOwner {
1486         uint256 balance = address(this).balance;
1487         uint256 mbTeam = (balance * 4) / 100;
1488 
1489         require(payable(m1).send((mbTeam * 5) / 100));
1490         require(payable(m2).send((mbTeam * 5) / 100));
1491         require(payable(m3).send((mbTeam * 5) / 100));
1492         require(payable(m4).send((mbTeam * 5) / 100));
1493         require(payable(m5).send((mbTeam * 5) / 100));
1494         require(payable(m6).send((mbTeam * 20) / 100));
1495         require(payable(m7).send((mbTeam * 55) / 100));
1496 
1497         require(payable(a1).send((balance * 75) / 1000));
1498         require(payable(a2).send((balance * 10) / 100));
1499         require(payable(a3).send((balance * 785) / 1000));
1500     }
1501 
1502     function withdrawOwner() external onlyOwner {
1503         payable(msg.sender).transfer(address(this).balance);
1504     }
1505 }