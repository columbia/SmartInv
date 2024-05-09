1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8 
9     function toString(uint256 value) internal pure returns (string memory) {
10         if (value == 0) {
11             return "0";
12         }
13         uint256 temp = value;
14         uint256 digits;
15         while (temp != 0) {
16             digits++;
17             temp /= 10;
18         }
19         bytes memory buffer = new bytes(digits);
20         while (value != 0) {
21             digits -= 1;
22             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
23             value /= 10;
24         }
25         return string(buffer);
26     }
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
30      */
31     function toHexString(uint256 value) internal pure returns (string memory) {
32         if (value == 0) {
33             return "0x00";
34         }
35         uint256 temp = value;
36         uint256 length = 0;
37         while (temp != 0) {
38             length++;
39             temp >>= 8;
40         }
41         return toHexString(value, length);
42     }
43 
44     function toHexString(uint256 value, uint256 length)
45         internal
46         pure
47         returns (string memory)
48     {
49         bytes memory buffer = new bytes(2 * length + 2);
50         buffer[0] = "0";
51         buffer[1] = "x";
52         for (uint256 i = 2 * length + 1; i > 1; --i) {
53             buffer[i] = _HEX_SYMBOLS[value & 0xf];
54             value >>= 4;
55         }
56         require(value == 0, "Strings: hex length insufficient");
57         return string(buffer);
58     }
59 }
60 
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 library Address {
72     function isContract(address account) internal view returns (bool) {
73         return account.code.length > 0;
74     }
75 
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(
78             address(this).balance >= amount,
79             "Address: insufficient balance"
80         );
81 
82         (bool success, ) = recipient.call{value: amount}("");
83         require(
84             success,
85             "Address: unable to send value, recipient may have reverted"
86         );
87     }
88 
89     function functionCall(address target, bytes memory data)
90         internal
91         returns (bytes memory)
92     {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     function functionCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103 
104     function functionCallWithValue(
105         address target,
106         bytes memory data,
107         uint256 value
108     ) internal returns (bytes memory) {
109         return
110             functionCallWithValue(
111                 target,
112                 data,
113                 value,
114                 "Address: low-level call with value failed"
115             );
116     }
117 
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value,
122         string memory errorMessage
123     ) internal returns (bytes memory) {
124         require(
125             address(this).balance >= value,
126             "Address: insufficient balance for call"
127         );
128         require(isContract(target), "Address: call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.call{value: value}(
131             data
132         );
133         return verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     function functionStaticCall(address target, bytes memory data)
137         internal
138         view
139         returns (bytes memory)
140     {
141         return
142             functionStaticCall(
143                 target,
144                 data,
145                 "Address: low-level static call failed"
146             );
147     }
148 
149     function functionStaticCall(
150         address target,
151         bytes memory data,
152         string memory errorMessage
153     ) internal view returns (bytes memory) {
154         require(isContract(target), "Address: static call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.staticcall(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     }
159 
160     function functionDelegateCall(address target, bytes memory data)
161         internal
162         returns (bytes memory)
163     {
164         return
165             functionDelegateCall(
166                 target,
167                 data,
168                 "Address: low-level delegate call failed"
169             );
170     }
171 
172     function functionDelegateCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         require(isContract(target), "Address: delegate call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.delegatecall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     function verifyCallResult(
184         bool success,
185         bytes memory returndata,
186         string memory errorMessage
187     ) internal pure returns (bytes memory) {
188         if (success) {
189             return returndata;
190         } else {
191             // Look for revert reason and bubble it up if present
192             if (returndata.length > 0) {
193                 // The easiest way to bubble the revert reason is using memory via assembly
194 
195                 assembly {
196                     let returndata_size := mload(returndata)
197                     revert(add(32, returndata), returndata_size)
198                 }
199             } else {
200                 revert(errorMessage);
201             }
202         }
203     }
204 }
205 
206 interface IERC165 {
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 }
209 
210 abstract contract ERC165 is IERC165 {
211     /**
212      * @dev See {IERC165-supportsInterface}.
213      */
214     function supportsInterface(bytes4 interfaceId)
215         public
216         view
217         virtual
218         override
219         returns (bool)
220     {
221         return interfaceId == type(IERC165).interfaceId;
222     }
223 }
224 
225 // IERC721.SOL
226 //IERC721
227 
228 interface IERC721 is IERC165 {
229     /**
230      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
231      */
232     event Transfer(
233         address indexed from,
234         address indexed to,
235         uint256 indexed tokenId
236     );
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(
242         address indexed owner,
243         address indexed approved,
244         uint256 indexed tokenId
245     );
246 
247     /**
248      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
249      */
250     event ApprovalForAll(
251         address indexed owner,
252         address indexed operator,
253         bool approved
254     );
255 
256     /**
257      * @dev Returns the number of tokens in ``owner``'s account.
258      */
259     function balanceOf(address owner) external view returns (uint256 balance);
260 
261     /**
262      * @dev Returns the owner of the `tokenId` token.
263      *
264      * Requirements:
265      *
266      * - `tokenId` must exist.
267      */
268     function ownerOf(uint256 tokenId) external view returns (address owner);
269 
270     /**
271      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
272      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must exist and be owned by `from`.
279      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId
288     ) external;
289 
290     /**
291      * @dev Transfers `tokenId` token from `from` to `to`.
292      *
293      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must be owned by `from`.
300      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 tokenId
308     ) external;
309 
310     /**
311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
312      * The approval is cleared when the token is transferred.
313      *
314      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
315      *
316      * Requirements:
317      *
318      * - The caller must own the token or be an approved operator.
319      * - `tokenId` must exist.
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address to, uint256 tokenId) external;
324 
325     /**
326      * @dev Returns the account approved for `tokenId` token.
327      *
328      * Requirements:
329      *
330      * - `tokenId` must exist.
331      */
332     function getApproved(uint256 tokenId)
333         external
334         view
335         returns (address operator);
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
351      *
352      * See {setApprovalForAll}
353      */
354     function isApprovedForAll(address owner, address operator)
355         external
356         view
357         returns (bool);
358 
359     /**
360      * @dev Safely transfers `tokenId` token from `from` to `to`.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId,
376         bytes calldata data
377     ) external;
378 }
379 
380 // IERC721Enumerable.sol
381 
382 interface IERC721Enumerable is IERC721 {
383     /**
384      * @dev Returns the total amount of tokens stored by the contract.
385      */
386     function totalSupply() external view returns (uint256);
387 
388     /**
389      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
390      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
391      */
392     function tokenOfOwnerByIndex(address owner, uint256 index)
393         external
394         view
395         returns (uint256);
396 
397     /**
398      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
399      * Use along with {totalSupply} to enumerate all tokens.
400      */
401     function tokenByIndex(uint256 index) external view returns (uint256);
402 }
403 
404 /**
405  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
406  * @dev See https://eips.ethereum.org/EIPS/eip-721
407  */
408 interface IERC721Metadata is IERC721 {
409     /**
410      * @dev Returns the token collection name.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the token collection symbol.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
421      */
422     function tokenURI(uint256 tokenId) external view returns (string memory);
423 }
424 
425 // IERC721Reciver.sol
426 /**
427  * @title ERC721 token receiver interface
428  * @dev Interface for any contract that wants to support safeTransfers
429  * from ERC721 asset contracts.
430  */
431 interface IERC721Receiver {
432     /**
433      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
434      * by `operator` from `from`, this function is called.
435      *
436      * It must return its Solidity selector to confirm the token transfer.
437      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
438      *
439      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
440      */
441     function onERC721Received(
442         address operator,
443         address from,
444         uint256 tokenId,
445         bytes calldata data
446     ) external returns (bytes4);
447 }
448 
449 error ApprovalCallerNotOwnerNorApproved();
450 error ApprovalQueryForNonexistentToken();
451 error ApproveToCaller();
452 error ApprovalToCurrentOwner();
453 error BalanceQueryForZeroAddress();
454 error MintedQueryForZeroAddress();
455 error MintToZeroAddress();
456 error MintZeroQuantity();
457 error OwnerIndexOutOfBounds();
458 error OwnerQueryForNonexistentToken();
459 error TokenIndexOutOfBounds();
460 error TransferCallerNotOwnerNorApproved();
461 error TransferFromIncorrectOwner();
462 error TransferToNonERC721ReceiverImplementer();
463 error TransferToZeroAddress();
464 error UnableDetermineTokenOwner();
465 error URIQueryForNonexistentToken();
466 
467 /**
468  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
469  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
470  *
471  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
472  *
473  * Does not support burning tokens to address(0).
474  *
475  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
476  */
477 contract ERC721A is
478     Context,
479     ERC165,
480     IERC721,
481     IERC721Metadata,
482     IERC721Enumerable
483 {
484     using Address for address;
485     using Strings for uint256;
486 
487     struct TokenOwnership {
488         address addr;
489         uint64 startTimestamp;
490     }
491 
492     struct AddressData {
493         uint128 balance;
494         uint128 numberMinted;
495     }
496 
497     uint256 internal _currentIndex;
498 
499     // Token name
500     string private _name;
501 
502     // Token symbol
503     string private _symbol;
504 
505     // Mapping from token ID to ownership details
506     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
507     mapping(uint256 => TokenOwnership) internal _ownerships;
508 
509     // Mapping owner address to address data
510     mapping(address => AddressData) private _addressData;
511 
512     // Mapping from token ID to approved address
513     mapping(uint256 => address) private _tokenApprovals;
514 
515     // Mapping from owner to operator approvals
516     mapping(address => mapping(address => bool)) private _operatorApprovals;
517 
518     constructor(string memory name_, string memory symbol_) {
519         _name = name_;
520         _symbol = symbol_;
521     }
522 
523     /**
524      * @dev See {IERC721Enumerable-totalSupply}.
525      */
526     function totalSupply() public view override returns (uint256) {
527         return _currentIndex;
528     }
529 
530     /**
531      * @dev See {IERC721Enumerable-tokenByIndex}.
532      */
533     function tokenByIndex(uint256 index)
534         public
535         view
536         override
537         returns (uint256)
538     {
539         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
540         return index;
541     }
542 
543     /**
544      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
545      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
546      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
547      */
548     function tokenOfOwnerByIndex(address owner, uint256 index)
549         public
550         view
551         override
552         returns (uint256 a)
553     {
554         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
555         uint256 numMintedSoFar = totalSupply();
556         uint256 tokenIdsIdx;
557         address currOwnershipAddr;
558 
559         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
560         unchecked {
561             for (uint256 i; i < numMintedSoFar; i++) {
562                 TokenOwnership memory ownership = _ownerships[i];
563                 if (ownership.addr != address(0)) {
564                     currOwnershipAddr = ownership.addr;
565                 }
566                 if (currOwnershipAddr == owner) {
567                     if (tokenIdsIdx == index) {
568                         return i;
569                     }
570                     tokenIdsIdx++;
571                 }
572             }
573         }
574 
575         // Execution should never reach this point.
576         assert(false);
577     }
578 
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId)
583         public
584         view
585         virtual
586         override(ERC165, IERC165)
587         returns (bool)
588     {
589         return
590             interfaceId == type(IERC721).interfaceId ||
591             interfaceId == type(IERC721Metadata).interfaceId ||
592             interfaceId == type(IERC721Enumerable).interfaceId ||
593             super.supportsInterface(interfaceId);
594     }
595 
596     /**
597      * @dev See {IERC721-balanceOf}.
598      */
599     function balanceOf(address owner) public view override returns (uint256) {
600         if (owner == address(0)) revert BalanceQueryForZeroAddress();
601         return uint256(_addressData[owner].balance);
602     }
603 
604     function _numberMinted(address owner) internal view returns (uint256) {
605         if (owner == address(0)) revert MintedQueryForZeroAddress();
606         return uint256(_addressData[owner].numberMinted);
607     }
608 
609     /**
610      * Gas spent here starts off proportional to the maximum mint batch size.
611      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
612      */
613     function ownershipOf(uint256 tokenId)
614         internal
615         view
616         returns (TokenOwnership memory)
617     {
618         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
619 
620         unchecked {
621             for (uint256 curr = tokenId; curr >= 0; curr--) {
622                 TokenOwnership memory ownership = _ownerships[curr];
623                 if (ownership.addr != address(0)) {
624                     return ownership;
625                 }
626             }
627         }
628 
629         revert UnableDetermineTokenOwner();
630     }
631 
632     /**
633      * @dev See {IERC721-ownerOf}.
634      */
635     function ownerOf(uint256 tokenId) public view override returns (address) {
636         return ownershipOf(tokenId).addr;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-name}.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-symbol}.
648      */
649     function symbol() public view virtual override returns (string memory) {
650         return _symbol;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-tokenURI}.
655      */
656     function tokenURI(uint256 tokenId)
657         public
658         view
659         virtual
660         override
661         returns (string memory)
662     {
663         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
664 
665         string memory baseURI = _baseURI();
666         return
667             bytes(baseURI).length != 0
668                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ""))
669                 : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public override {
685         address owner = ERC721A.ownerOf(tokenId);
686         if (to == owner) revert ApprovalToCurrentOwner();
687 
688         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
689             revert ApprovalCallerNotOwnerNorApproved();
690 
691         _approve(to, tokenId, owner);
692     }
693 
694     /**
695      * @dev See {IERC721-getApproved}.
696      */
697     function getApproved(uint256 tokenId)
698         public
699         view
700         override
701         returns (address)
702     {
703         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
704 
705         return _tokenApprovals[tokenId];
706     }
707 
708     /**
709      * @dev See {IERC721-setApprovalForAll}.
710      */
711     function setApprovalForAll(address operator, bool approved)
712         public
713         override
714     {
715         if (operator == _msgSender()) revert ApproveToCaller();
716 
717         _operatorApprovals[_msgSender()][operator] = approved;
718         emit ApprovalForAll(_msgSender(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator)
725         public
726         view
727         virtual
728         override
729         returns (bool)
730     {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) public override {
765         _transfer(from, to, tokenId);
766         if (!_checkOnERC721Received(from, to, tokenId, _data))
767             revert TransferToNonERC721ReceiverImplementer();
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      */
777     function _exists(uint256 tokenId) internal view returns (bool) {
778         return tokenId < _currentIndex;
779     }
780 
781     function _safeMint(address to, uint256 quantity) internal {
782         _safeMint(to, quantity, "");
783     }
784 
785     /**
786      * @dev Safely mints `quantity` tokens and transfers them to `to`.
787      *
788      * Requirements:
789      *
790      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
791      * - `quantity` must be greater than 0.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeMint(
796         address to,
797         uint256 quantity,
798         bytes memory _data
799     ) internal {
800         _mint(to, quantity, _data, true);
801     }
802 
803     /**
804      * @dev Mints `quantity` tokens and transfers them to `to`.
805      *
806      * Requirements:
807      *
808      * - `to` cannot be the zero address.
809      * - `quantity` must be greater than 0.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _mint(
814         address to,
815         uint256 quantity,
816         bytes memory _data,
817         bool safe
818     ) internal {
819         uint256 startTokenId = _currentIndex;
820         if (to == address(0)) revert MintToZeroAddress();
821         // if (quantity == 0) revert MintZeroQuantity();
822 
823         //_beforeTokenTransfers(address(0), to, startTokenId, quantity);
824 
825         // Overflows are incredibly unrealistic.
826         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
827         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
828         unchecked {
829             _addressData[to].balance += uint128(quantity);
830             _addressData[to].numberMinted += uint128(quantity);
831 
832             _ownerships[startTokenId].addr = to;
833             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
834 
835             uint256 updatedIndex = startTokenId;
836 
837             for (uint256 i; i < quantity; i++) {
838                 emit Transfer(address(0), to, updatedIndex);
839                 if (
840                     safe &&
841                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
842                 ) {
843                     revert TransferToNonERC721ReceiverImplementer();
844                 }
845 
846                 updatedIndex++;
847             }
848 
849             _currentIndex = updatedIndex;
850         }
851 
852         _afterTokenTransfers(address(0), to, startTokenId, quantity);
853     }
854 
855     /**
856      * @dev Transfers `tokenId` from `from` to `to`.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must be owned by `from`.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _transfer(
866         address from,
867         address to,
868         uint256 tokenId
869     ) private {
870         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
871 
872         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
873             getApproved(tokenId) == _msgSender() ||
874             isApprovedForAll(prevOwnership.addr, _msgSender()));
875 
876         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
877         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
878         if (to == address(0)) revert TransferToZeroAddress();
879 
880         // _beforeTokenTransfers(from, to, tokenId, 1);
881 
882         // Clear approvals from the previous owner
883         _approve(address(0), tokenId, prevOwnership.addr);
884 
885         // Underflow of the sender's balance is impossible because we check for
886         // ownership above and the recipient's balance can't realistically overflow.
887         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
888         unchecked {
889             _addressData[from].balance -= 1;
890             _addressData[to].balance += 1;
891 
892             _ownerships[tokenId].addr = to;
893             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
894 
895             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
896             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
897             uint256 nextTokenId = tokenId + 1;
898             if (_ownerships[nextTokenId].addr == address(0)) {
899                 if (_exists(nextTokenId)) {
900                     _ownerships[nextTokenId].addr = prevOwnership.addr;
901                     _ownerships[nextTokenId].startTimestamp = prevOwnership
902                         .startTimestamp;
903                 }
904             }
905         }
906 
907         emit Transfer(from, to, tokenId);
908         _afterTokenTransfers(from, to, tokenId, 1);
909     }
910 
911     /**
912      * @dev Approve `to` to operate on `tokenId`
913      *
914      * Emits a {Approval} event.
915      */
916     function _approve(
917         address to,
918         uint256 tokenId,
919         address owner
920     ) private {
921         _tokenApprovals[tokenId] = to;
922         emit Approval(owner, to, tokenId);
923     }
924 
925     /**
926      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
927      * The call is not executed if the target address is not a contract.
928      *
929      * @param from address representing the previous owner of the given token ID
930      * @param to target address that will receive the tokens
931      * @param tokenId uint256 ID of the token to be transferred
932      * @param _data bytes optional data to send along with the call
933      * @return bool whether the call correctly returned the expected magic value
934      */
935     function _checkOnERC721Received(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) private returns (bool) {
941         if (to.isContract()) {
942             try
943                 IERC721Receiver(to).onERC721Received(
944                     _msgSender(),
945                     from,
946                     tokenId,
947                     _data
948                 )
949             returns (bytes4 retval) {
950                 return retval == IERC721Receiver(to).onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0)
953                     revert TransferToNonERC721ReceiverImplementer();
954                 else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
967      *
968      * startTokenId - the first token id to be transferred
969      * quantity - the amount to be transferred
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      */
977     function _beforeTokenTransfers(
978         address from,
979         address to,
980         uint256 startTokenId,
981         uint256 quantity
982     ) internal virtual {}
983 
984     /**
985      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
986      * minting.
987      *
988      * startTokenId - the first token id to be transferred
989      * quantity - the amount to be transferred
990      *
991      * Calling conditions:
992      *
993      * - when `from` and `to` are both non-zero.
994      * - `from` and `to` are never both zero.
995      */
996     function _afterTokenTransfers(
997         address from,
998         address to,
999         uint256 startTokenId,
1000         uint256 quantity
1001     ) internal virtual {}
1002 }
1003 
1004 abstract contract Ownable is Context {
1005     address private _owner;
1006 
1007     event OwnershipTransferred(
1008         address indexed previousOwner,
1009         address indexed newOwner
1010     );
1011 
1012     /**
1013      * @dev Initializes the contract setting the deployer as the initial owner.
1014      */
1015     constructor() {
1016         _transferOwnership(_msgSender());
1017     }
1018 
1019     /**
1020      * @dev Returns the address of the current owner.
1021      */
1022     function owner() public view virtual returns (address) {
1023         return _owner;
1024     }
1025 
1026     /**
1027      * @dev Throws if called by any account other than the owner.
1028      */
1029     modifier onlyOwner() {
1030         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1031         _;
1032     }
1033 
1034     /**
1035      * @dev Leaves the contract without owner. It will not be possible to call
1036      * `onlyOwner` functions anymore. Can only be called by the current owner.
1037      *
1038      * NOTE: Renouncing ownership will leave the contract without an owner,
1039      * thereby removing any functionality that is only available to the owner.
1040      */
1041     function renounceOwnership() public virtual onlyOwner {
1042         _transferOwnership(address(0));
1043     }
1044 
1045     /**
1046      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1047      * Can only be called by the current owner.
1048      */
1049     function transferOwnership(address newOwner) public virtual onlyOwner {
1050         require(
1051             newOwner != address(0),
1052             "Ownable: new owner is the zero address"
1053         );
1054         _transferOwnership(newOwner);
1055     }
1056 
1057     /**
1058      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1059      * Internal function without access restriction.
1060      */
1061     function _transferOwnership(address newOwner) internal virtual {
1062         address oldOwner = _owner;
1063         _owner = newOwner;
1064         emit OwnershipTransferred(oldOwner, newOwner);
1065     }
1066 }
1067 
1068 library MerkleProof {
1069     /**
1070      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1071      * defined by `root`. For this, a `proof` must be provided, containing
1072      * sibling hashes on the branch from the leaf to the root of the tree. Each
1073      * pair of leaves and each pair of pre-images are assumed to be sorted.
1074      */
1075     function verify(
1076         bytes32[] memory proof,
1077         bytes32 root,
1078         bytes32 leaf
1079     ) internal pure returns (bool) {
1080         return processProof(proof, leaf) == root;
1081     }
1082 
1083     /**
1084      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1085      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1086      * hash matches the root of the tree. When processing the proof, the pairs
1087      * of leafs & pre-images are assumed to be sorted.
1088      *
1089      * _Available since v4.4._
1090      */
1091     function processProof(bytes32[] memory proof, bytes32 leaf)
1092         internal
1093         pure
1094         returns (bytes32)
1095     {
1096         bytes32 computedHash = leaf;
1097         for (uint256 i = 0; i < proof.length; i++) {
1098             bytes32 proofElement = proof[i];
1099             if (computedHash <= proofElement) {
1100                 // Hash(current computed hash + current element of the proof)
1101                 computedHash = _efficientHash(computedHash, proofElement);
1102             } else {
1103                 // Hash(current element of the proof + current computed hash)
1104                 computedHash = _efficientHash(proofElement, computedHash);
1105             }
1106         }
1107         return computedHash;
1108     }
1109 
1110     function _efficientHash(bytes32 a, bytes32 b)
1111         private
1112         pure
1113         returns (bytes32 value)
1114     {
1115         assembly {
1116             mstore(0x00, a)
1117             mstore(0x20, b)
1118             value := keccak256(0x00, 0x40)
1119         }
1120     }
1121 }
1122 
1123 contract Bad_Guys_by_RPF is ERC721A, Ownable {
1124     // variables
1125     using Strings for uint256;
1126 
1127     constructor(
1128         bytes32 finalRootHash,
1129         string memory _NotRevealedUri
1130     ) ERC721A("Bad Guys by RPF", "BGRPF") {
1131         rootHash = finalRootHash;
1132         setNotRevealedURI(_NotRevealedUri);
1133     }
1134 
1135     uint256 public maxsupply = 1221;
1136     uint256 public reserve = 100;
1137 
1138     bool public isPaused = true;
1139     string public _baseURI1;
1140     bytes32 private rootHash;
1141     // revealed uri variables
1142     
1143     bool public revealed = false;
1144     string public notRevealedUri;
1145 
1146 
1147     function flipPauseMinting() public onlyOwner {
1148         isPaused = !isPaused;
1149     }
1150 
1151     function setRootHash(bytes32 _updatedRootHash) public onlyOwner {
1152         rootHash = _updatedRootHash;
1153     }
1154 
1155     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1156         _baseURI1 = _newBaseURI;
1157     }
1158 
1159     function _baseURI() internal view virtual override returns (string memory) {
1160         return _baseURI1;
1161     }
1162 
1163     function setReserve(uint256 _reserve) public onlyOwner {
1164         require(_reserve <= maxsupply, "the quantity exceeds");
1165         reserve = _reserve;
1166     }
1167         
1168     // set reaveal uri just in case
1169 
1170     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1171         notRevealedUri = _notRevealedURI;
1172     }
1173 
1174     // setting reaveal only time can possible
1175     //only owner
1176     function reveal() public onlyOwner {
1177         revealed = !revealed;
1178     }
1179 
1180     function mintReservedTokens(uint256 quantity) public onlyOwner {
1181         require(quantity <= reserve, "All reserve tokens have bene minted");
1182         reserve -= quantity;
1183         _safeMint(msg.sender, quantity);
1184     }
1185 
1186     function WhiteListMint(bytes32[] calldata _merkleProof, uint256 chosenAmount)
1187         public
1188     {
1189         require(_numberMinted(msg.sender)<1, "Already Claimed");
1190         require(isPaused == false, "turn on minting");
1191         require(
1192             chosenAmount > 0,
1193             "Number Of Tokens Can Not Be Less Than Or Equal To 0"
1194         );
1195         require(
1196             totalSupply() + chosenAmount <= maxsupply - reserve,
1197             "all tokens have been minted"
1198         );
1199         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1200         require(
1201             MerkleProof.verify(_merkleProof, rootHash, leaf),
1202             "Invalid Proof"
1203         );
1204         _safeMint(msg.sender, chosenAmount);
1205     }
1206 
1207     // setting up the reaveal functionality
1208 
1209     function tokenURI(uint256 tokenId)
1210         public
1211         view
1212         virtual
1213         override
1214         returns (string memory)
1215     {
1216         require(
1217             _exists(tokenId),
1218             "ERC721Metadata: URI query for nonexistent token"
1219         );
1220 
1221         if (revealed == false) {
1222             return notRevealedUri;
1223         }
1224 
1225         string memory currentBaseURI = _baseURI();
1226         return
1227             bytes(currentBaseURI).length > 0
1228                 ? string(
1229                     abi.encodePacked(
1230                         currentBaseURI,
1231                         tokenId.toString(),
1232                         ".json"
1233                     )
1234                 )
1235                 : "";
1236     }
1237 
1238    function withdraw() public onlyOwner {
1239         uint balance = address(this).balance;
1240         payable(msg.sender).transfer(balance);
1241     }
1242 }