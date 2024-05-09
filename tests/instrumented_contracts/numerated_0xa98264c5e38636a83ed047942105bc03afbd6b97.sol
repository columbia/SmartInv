1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     function toString(uint256 value) internal pure returns (string memory) {
9         if (value == 0) {
10             return "0";
11         }
12         uint256 temp = value;
13         uint256 digits;
14         while (temp != 0) {
15             digits++;
16             temp /= 10;
17         }
18         bytes memory buffer = new bytes(digits);
19         while (value != 0) {
20             digits -= 1;
21             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
22             value /= 10;
23         }
24         return string(buffer);
25     }
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
29      */
30     function toHexString(uint256 value) internal pure returns (string memory) {
31         if (value == 0) {
32             return "0x00";
33         }
34         uint256 temp = value;
35         uint256 length = 0;
36         while (temp != 0) {
37             length++;
38             temp >>= 8;
39         }
40         return toHexString(value, length);
41     }
42 
43     function toHexString(uint256 value, uint256 length)
44         internal
45         pure
46         returns (string memory)
47     {
48         bytes memory buffer = new bytes(2 * length + 2);
49         buffer[0] = "0";
50         buffer[1] = "x";
51         for (uint256 i = 2 * length + 1; i > 1; --i) {
52             buffer[i] = _HEX_SYMBOLS[value & 0xf];
53             value >>= 4;
54         }
55         require(value == 0, "Strings: hex length insufficient");
56         return string(buffer);
57     }
58 }
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 library Address {
71     function isContract(address account) internal view returns (bool) {
72         return account.code.length > 0;
73     }
74 
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(
77             address(this).balance >= amount,
78             "Address: insufficient balance"
79         );
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(
83             success,
84             "Address: unable to send value, recipient may have reverted"
85         );
86     }
87 
88     function functionCall(address target, bytes memory data)
89         internal
90         returns (bytes memory)
91     {
92         return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     function functionCall(
96         address target,
97         bytes memory data,
98         string memory errorMessage
99     ) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(
104         address target,
105         bytes memory data,
106         uint256 value
107     ) internal returns (bytes memory) {
108         return
109             functionCallWithValue(
110                 target,
111                 data,
112                 value,
113                 "Address: low-level call with value failed"
114             );
115     }
116 
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         require(
124             address(this).balance >= value,
125             "Address: insufficient balance for call"
126         );
127         require(isContract(target), "Address: call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.call{value: value}(
130             data
131         );
132         return verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     function functionStaticCall(address target, bytes memory data)
136         internal
137         view
138         returns (bytes memory)
139     {
140         return
141             functionStaticCall(
142                 target,
143                 data,
144                 "Address: low-level static call failed"
145             );
146     }
147 
148     function functionStaticCall(
149         address target,
150         bytes memory data,
151         string memory errorMessage
152     ) internal view returns (bytes memory) {
153         require(isContract(target), "Address: static call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.staticcall(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     function functionDelegateCall(address target, bytes memory data)
160         internal
161         returns (bytes memory)
162     {
163         return
164             functionDelegateCall(
165                 target,
166                 data,
167                 "Address: low-level delegate call failed"
168             );
169     }
170 
171     function functionDelegateCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         require(isContract(target), "Address: delegate call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.delegatecall(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     function verifyCallResult(
183         bool success,
184         bytes memory returndata,
185         string memory errorMessage
186     ) internal pure returns (bytes memory) {
187         if (success) {
188             return returndata;
189         } else {
190             // Look for revert reason and bubble it up if present
191             if (returndata.length > 0) {
192                 // The easiest way to bubble the revert reason is using memory via assembly
193 
194                 assembly {
195                     let returndata_size := mload(returndata)
196                     revert(add(32, returndata), returndata_size)
197                 }
198             } else {
199                 revert(errorMessage);
200             }
201         }
202     }
203 }
204 
205 interface IERC165 {
206     function supportsInterface(bytes4 interfaceId) external view returns (bool);
207 }
208 
209 abstract contract ERC165 is IERC165 {
210     /**
211      * @dev See {IERC165-supportsInterface}.
212      */
213     function supportsInterface(bytes4 interfaceId)
214         public
215         view
216         virtual
217         override
218         returns (bool)
219     {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 // IERC721.SOL
225 //IERC721
226 
227 interface IERC721 is IERC165 {
228     /**
229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
230      */
231     event Transfer(
232         address indexed from,
233         address indexed to,
234         uint256 indexed tokenId
235     );
236 
237     /**
238      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
239      */
240     event Approval(
241         address indexed owner,
242         address indexed approved,
243         uint256 indexed tokenId
244     );
245 
246     /**
247      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(
250         address indexed owner,
251         address indexed operator,
252         bool approved
253     );
254 
255     /**
256      * @dev Returns the number of tokens in ``owner``'s account.
257      */
258     function balanceOf(address owner) external view returns (uint256 balance);
259 
260     /**
261      * @dev Returns the owner of the `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function ownerOf(uint256 tokenId) external view returns (address owner);
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
271      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must exist and be owned by `from`.
278      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external;
288 
289     /**
290      * @dev Transfers `tokenId` token from `from` to `to`.
291      *
292      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
311      * The approval is cleared when the token is transferred.
312      *
313      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
314      *
315      * Requirements:
316      *
317      * - The caller must own the token or be an approved operator.
318      * - `tokenId` must exist.
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address to, uint256 tokenId) external;
323 
324     /**
325      * @dev Returns the account approved for `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function getApproved(uint256 tokenId)
332         external
333         view
334         returns (address operator);
335 
336     /**
337      * @dev Approve or remove `operator` as an operator for the caller.
338      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
339      *
340      * Requirements:
341      *
342      * - The `operator` cannot be the caller.
343      *
344      * Emits an {ApprovalForAll} event.
345      */
346     function setApprovalForAll(address operator, bool _approved) external;
347 
348     /**
349      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
350      *
351      * See {setApprovalForAll}
352      */
353     function isApprovedForAll(address owner, address operator)
354         external
355         view
356         returns (bool);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must exist and be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
368      *
369      * Emits a {Transfer} event.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external;
377 }
378 
379 // IERC721Enumerable.sol
380 
381 interface IERC721Enumerable is IERC721 {
382     /**
383      * @dev Returns the total amount of tokens stored by the contract.
384      */
385     function totalSupply() external view returns (uint256);
386 
387     /**
388      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
389      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
390      */
391     function tokenOfOwnerByIndex(address owner, uint256 index)
392         external
393         view
394         returns (uint256);
395 
396     /**
397      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
398      * Use along with {totalSupply} to enumerate all tokens.
399      */
400     function tokenByIndex(uint256 index) external view returns (uint256);
401 }
402 
403 /**
404  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
405  * @dev See https://eips.ethereum.org/EIPS/eip-721
406  */
407 interface IERC721Metadata is IERC721 {
408     /**
409      * @dev Returns the token collection name.
410      */
411     function name() external view returns (string memory);
412 
413     /**
414      * @dev Returns the token collection symbol.
415      */
416     function symbol() external view returns (string memory);
417 
418     /**
419      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
420      */
421     function tokenURI(uint256 tokenId) external view returns (string memory);
422 }
423 
424 // IERC721Reciver.sol
425 /**
426  * @title ERC721 token receiver interface
427  * @dev Interface for any contract that wants to support safeTransfers
428  * from ERC721 asset contracts.
429  */
430 interface IERC721Receiver {
431     /**
432      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
433      * by `operator` from `from`, this function is called.
434      *
435      * It must return its Solidity selector to confirm the token transfer.
436      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
437      *
438      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
439      */
440     function onERC721Received(
441         address operator,
442         address from,
443         uint256 tokenId,
444         bytes calldata data
445     ) external returns (bytes4);
446 }
447 
448 error ApprovalCallerNotOwnerNorApproved();
449 error ApprovalQueryForNonexistentToken();
450 error ApproveToCaller();
451 error ApprovalToCurrentOwner();
452 error BalanceQueryForZeroAddress();
453 error MintedQueryForZeroAddress();
454 error MintToZeroAddress();
455 error MintZeroQuantity();
456 error OwnerIndexOutOfBounds();
457 error OwnerQueryForNonexistentToken();
458 error TokenIndexOutOfBounds();
459 error TransferCallerNotOwnerNorApproved();
460 error TransferFromIncorrectOwner();
461 error TransferToNonERC721ReceiverImplementer();
462 error TransferToZeroAddress();
463 error UnableDetermineTokenOwner();
464 error URIQueryForNonexistentToken();
465 
466 /**
467  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
468  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
469  *
470  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
471  *
472  * Does not support burning tokens to address(0).
473  *
474  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
475  */
476 contract ERC721A is
477     Context,
478     ERC165,
479     IERC721,
480     IERC721Metadata,
481     IERC721Enumerable
482 {
483     using Address for address;
484     using Strings for uint256;
485 
486     struct TokenOwnership {
487         address addr;
488         uint64 startTimestamp;
489     }
490 
491     struct AddressData {
492         uint128 balance;
493         uint128 numberMinted;
494     }
495 
496     uint256 internal _currentIndex;
497 
498     // Token name
499     string private _name;
500 
501     // Token symbol
502     string private _symbol;
503 
504     // Mapping from token ID to ownership details
505     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
506     mapping(uint256 => TokenOwnership) internal _ownerships;
507 
508     // Mapping owner address to address data
509     mapping(address => AddressData) private _addressData;
510 
511     // Mapping from token ID to approved address
512     mapping(uint256 => address) private _tokenApprovals;
513 
514     // Mapping from owner to operator approvals
515     mapping(address => mapping(address => bool)) private _operatorApprovals;
516 
517     constructor(string memory name_, string memory symbol_) {
518         _name = name_;
519         _symbol = symbol_;
520     }
521 
522     /**
523      * @dev See {IERC721Enumerable-totalSupply}.
524      */
525     function totalSupply() public view override returns (uint256) {
526         return _currentIndex;
527     }
528 
529     /**
530      * @dev See {IERC721Enumerable-tokenByIndex}.
531      */
532     function tokenByIndex(uint256 index)
533         public
534         view
535         override
536         returns (uint256)
537     {
538         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
539         return index;
540     }
541 
542     /**
543      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
544      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
545      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index)
548         public
549         view
550         override
551         returns (uint256 a)
552     {
553         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
554         uint256 numMintedSoFar = totalSupply();
555         uint256 tokenIdsIdx;
556         address currOwnershipAddr;
557 
558         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
559         unchecked {
560             for (uint256 i; i < numMintedSoFar; i++) {
561                 TokenOwnership memory ownership = _ownerships[i];
562                 if (ownership.addr != address(0)) {
563                     currOwnershipAddr = ownership.addr;
564                 }
565                 if (currOwnershipAddr == owner) {
566                     if (tokenIdsIdx == index) {
567                         return i;
568                     }
569                     tokenIdsIdx++;
570                 }
571             }
572         }
573 
574         // Execution should never reach this point.
575         assert(false);
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId)
582         public
583         view
584         virtual
585         override(ERC165, IERC165)
586         returns (bool)
587     {
588         return
589             interfaceId == type(IERC721).interfaceId ||
590             interfaceId == type(IERC721Metadata).interfaceId ||
591             interfaceId == type(IERC721Enumerable).interfaceId ||
592             super.supportsInterface(interfaceId);
593     }
594 
595     /**
596      * @dev See {IERC721-balanceOf}.
597      */
598     function balanceOf(address owner) public view override returns (uint256) {
599         if (owner == address(0)) revert BalanceQueryForZeroAddress();
600         return uint256(_addressData[owner].balance);
601     }
602 
603     function _numberMinted(address owner) internal view returns (uint256) {
604         if (owner == address(0)) revert MintedQueryForZeroAddress();
605         return uint256(_addressData[owner].numberMinted);
606     }
607 
608     /**
609      * Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
611      */
612     function ownershipOf(uint256 tokenId)
613         internal
614         view
615         returns (TokenOwnership memory)
616     {
617         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
618 
619         unchecked {
620             for (uint256 curr = tokenId; curr >= 0; curr--) {
621                 TokenOwnership memory ownership = _ownerships[curr];
622                 if (ownership.addr != address(0)) {
623                     return ownership;
624                 }
625             }
626         }
627 
628         revert UnableDetermineTokenOwner();
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view override returns (address) {
635         return ownershipOf(tokenId).addr;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-name}.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-symbol}.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-tokenURI}.
654      */
655     function tokenURI(uint256 tokenId)
656         public
657         view
658         virtual
659         override
660         returns (string memory)
661     {
662         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
663 
664         string memory baseURI = _baseURI();
665         return
666             bytes(baseURI).length != 0
667                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ""))
668                 : "";
669     }
670 
671     /**
672      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
673      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
674      * by default, can be overriden in child contracts.
675      */
676     function _baseURI() internal view virtual returns (string memory) {
677         return "";
678     }
679 
680     /**
681      * @dev See {IERC721-approve}.
682      */
683     function approve(address to, uint256 tokenId) public override {
684         address owner = ERC721A.ownerOf(tokenId);
685         if (to == owner) revert ApprovalToCurrentOwner();
686 
687         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
688             revert ApprovalCallerNotOwnerNorApproved();
689 
690         _approve(to, tokenId, owner);
691     }
692 
693     /**
694      * @dev See {IERC721-getApproved}.
695      */
696     function getApproved(uint256 tokenId)
697         public
698         view
699         override
700         returns (address)
701     {
702         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved)
711         public
712         override
713     {
714         if (operator == _msgSender()) revert ApproveToCaller();
715 
716         _operatorApprovals[_msgSender()][operator] = approved;
717         emit ApprovalForAll(_msgSender(), operator, approved);
718     }
719 
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator)
724         public
725         view
726         virtual
727         override
728         returns (bool)
729     {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-transferFrom}.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         _transfer(from, to, tokenId);
742     }
743 
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         safeTransferFrom(from, to, tokenId, "");
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) public override {
764         _transfer(from, to, tokenId);
765         if (!_checkOnERC721Received(from, to, tokenId, _data))
766             revert TransferToNonERC721ReceiverImplementer();
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         return tokenId < _currentIndex;
778     }
779 
780     function _safeMint(address to, uint256 quantity) internal {
781         _safeMint(to, quantity, "");
782     }
783 
784     /**
785      * @dev Safely mints `quantity` tokens and transfers them to `to`.
786      *
787      * Requirements:
788      *
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
790      * - `quantity` must be greater than 0.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _safeMint(
795         address to,
796         uint256 quantity,
797         bytes memory _data
798     ) internal {
799         _mint(to, quantity, _data, true);
800     }
801 
802     /**
803      * @dev Mints `quantity` tokens and transfers them to `to`.
804      *
805      * Requirements:
806      *
807      * - `to` cannot be the zero address.
808      * - `quantity` must be greater than 0.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _mint(
813         address to,
814         uint256 quantity,
815         bytes memory _data,
816         bool safe
817     ) internal {
818         uint256 startTokenId = _currentIndex;
819         if (to == address(0)) revert MintToZeroAddress();
820         // if (quantity == 0) revert MintZeroQuantity();
821 
822         //_beforeTokenTransfers(address(0), to, startTokenId, quantity);
823 
824         // Overflows are incredibly unrealistic.
825         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
826         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
827         unchecked {
828             _addressData[to].balance += uint128(quantity);
829             _addressData[to].numberMinted += uint128(quantity);
830 
831             _ownerships[startTokenId].addr = to;
832             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
833 
834             uint256 updatedIndex = startTokenId;
835 
836             for (uint256 i; i < quantity; i++) {
837                 emit Transfer(address(0), to, updatedIndex);
838                 if (
839                     safe &&
840                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
841                 ) {
842                     revert TransferToNonERC721ReceiverImplementer();
843                 }
844 
845                 updatedIndex++;
846             }
847 
848             _currentIndex = updatedIndex;
849         }
850 
851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
852     }
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(
865         address from,
866         address to,
867         uint256 tokenId
868     ) private {
869         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
870 
871         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
872             getApproved(tokenId) == _msgSender() ||
873             isApprovedForAll(prevOwnership.addr, _msgSender()));
874 
875         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
876         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
877         if (to == address(0)) revert TransferToZeroAddress();
878 
879         // _beforeTokenTransfers(from, to, tokenId, 1);
880 
881         // Clear approvals from the previous owner
882         _approve(address(0), tokenId, prevOwnership.addr);
883 
884         // Underflow of the sender's balance is impossible because we check for
885         // ownership above and the recipient's balance can't realistically overflow.
886         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
887         unchecked {
888             _addressData[from].balance -= 1;
889             _addressData[to].balance += 1;
890 
891             _ownerships[tokenId].addr = to;
892             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
893 
894             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
895             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
896             uint256 nextTokenId = tokenId + 1;
897             if (_ownerships[nextTokenId].addr == address(0)) {
898                 if (_exists(nextTokenId)) {
899                     _ownerships[nextTokenId].addr = prevOwnership.addr;
900                     _ownerships[nextTokenId].startTimestamp = prevOwnership
901                         .startTimestamp;
902                 }
903             }
904         }
905 
906         emit Transfer(from, to, tokenId);
907         _afterTokenTransfers(from, to, tokenId, 1);
908     }
909 
910     /**
911      * @dev Approve `to` to operate on `tokenId`
912      *
913      * Emits a {Approval} event.
914      */
915     function _approve(
916         address to,
917         uint256 tokenId,
918         address owner
919     ) private {
920         _tokenApprovals[tokenId] = to;
921         emit Approval(owner, to, tokenId);
922     }
923 
924     /**
925      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
926      * The call is not executed if the target address is not a contract.
927      *
928      * @param from address representing the previous owner of the given token ID
929      * @param to target address that will receive the tokens
930      * @param tokenId uint256 ID of the token to be transferred
931      * @param _data bytes optional data to send along with the call
932      * @return bool whether the call correctly returned the expected magic value
933      */
934     function _checkOnERC721Received(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) private returns (bool) {
940         if (to.isContract()) {
941             try
942                 IERC721Receiver(to).onERC721Received(
943                     _msgSender(),
944                     from,
945                     tokenId,
946                     _data
947                 )
948             returns (bytes4 retval) {
949                 return retval == IERC721Receiver(to).onERC721Received.selector;
950             } catch (bytes memory reason) {
951                 if (reason.length == 0)
952                     revert TransferToNonERC721ReceiverImplementer();
953                 else {
954                     assembly {
955                         revert(add(32, reason), mload(reason))
956                     }
957                 }
958             }
959         } else {
960             return true;
961         }
962     }
963 
964     /**
965      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
966      *
967      * startTokenId - the first token id to be transferred
968      * quantity - the amount to be transferred
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` will be minted for `to`.
975      */
976     function _beforeTokenTransfers(
977         address from,
978         address to,
979         uint256 startTokenId,
980         uint256 quantity
981     ) internal virtual {}
982 
983     /**
984      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
985      * minting.
986      *
987      * startTokenId - the first token id to be transferred
988      * quantity - the amount to be transferred
989      *
990      * Calling conditions:
991      *
992      * - when `from` and `to` are both non-zero.
993      * - `from` and `to` are never both zero.
994      */
995     function _afterTokenTransfers(
996         address from,
997         address to,
998         uint256 startTokenId,
999         uint256 quantity
1000     ) internal virtual {}
1001 }
1002 
1003 abstract contract Ownable is Context {
1004     address private _owner;
1005 
1006     event OwnershipTransferred(
1007         address indexed previousOwner,
1008         address indexed newOwner
1009     );
1010 
1011     /**
1012      * @dev Initializes the contract setting the deployer as the initial owner.
1013      */
1014     constructor() {
1015         _transferOwnership(_msgSender());
1016     }
1017 
1018     /**
1019      * @dev Returns the address of the current owner.
1020      */
1021     function owner() public view virtual returns (address) {
1022         return _owner;
1023     }
1024 
1025     /**
1026      * @dev Throws if called by any account other than the owner.
1027      */
1028     modifier onlyOwner() {
1029         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1030         _;
1031     }
1032 
1033     /**
1034      * @dev Leaves the contract without owner. It will not be possible to call
1035      * `onlyOwner` functions anymore. Can only be called by the current owner.
1036      *
1037      * NOTE: Renouncing ownership will leave the contract without an owner,
1038      * thereby removing any functionality that is only available to the owner.
1039      */
1040     function renounceOwnership() public virtual onlyOwner {
1041         _transferOwnership(address(0));
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1046      * Can only be called by the current owner.
1047      */
1048     function transferOwnership(address newOwner) public virtual onlyOwner {
1049         require(
1050             newOwner != address(0),
1051             "Ownable: new owner is the zero address"
1052         );
1053         _transferOwnership(newOwner);
1054     }
1055 
1056     /**
1057      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1058      * Internal function without access restriction.
1059      */
1060     function _transferOwnership(address newOwner) internal virtual {
1061         address oldOwner = _owner;
1062         _owner = newOwner;
1063         emit OwnershipTransferred(oldOwner, newOwner);
1064     }
1065 }
1066 
1067 library MerkleProof {
1068     /**
1069      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1070      * defined by `root`. For this, a `proof` must be provided, containing
1071      * sibling hashes on the branch from the leaf to the root of the tree. Each
1072      * pair of leaves and each pair of pre-images are assumed to be sorted.
1073      */
1074     function verify(
1075         bytes32[] memory proof,
1076         bytes32 root,
1077         bytes32 leaf
1078     ) internal pure returns (bool) {
1079         return processProof(proof, leaf) == root;
1080     }
1081 
1082     /**
1083      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1084      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1085      * hash matches the root of the tree. When processing the proof, the pairs
1086      * of leafs & pre-images are assumed to be sorted.
1087      *
1088      * _Available since v4.4._
1089      */
1090     function processProof(bytes32[] memory proof, bytes32 leaf)
1091         internal
1092         pure
1093         returns (bytes32)
1094     {
1095         bytes32 computedHash = leaf;
1096         for (uint256 i = 0; i < proof.length; i++) {
1097             bytes32 proofElement = proof[i];
1098             if (computedHash <= proofElement) {
1099                 // Hash(current computed hash + current element of the proof)
1100                 computedHash = _efficientHash(computedHash, proofElement);
1101             } else {
1102                 // Hash(current element of the proof + current computed hash)
1103                 computedHash = _efficientHash(proofElement, computedHash);
1104             }
1105         }
1106         return computedHash;
1107     }
1108 
1109     function _efficientHash(bytes32 a, bytes32 b)
1110         private
1111         pure
1112         returns (bytes32 value)
1113     {
1114         assembly {
1115             mstore(0x00, a)
1116             mstore(0x20, b)
1117             value := keccak256(0x00, 0x40)
1118         }
1119     }
1120 }
1121 
1122 contract WORLD_OF_FOOTBALL_NFT is ERC721A, Ownable {
1123     // variables
1124     using Strings for uint256;
1125 
1126     constructor(bytes32 finalRootHash, string memory _NotRevealedUri)
1127         ERC721A("World of Football NFT", "WoF")
1128     {
1129         rootHash = finalRootHash;
1130         setNotRevealedURI(_NotRevealedUri);
1131     }
1132 
1133     uint256 public maxsupply = 5555;
1134     uint256 public reserve = 55;
1135     uint256 public presaleprice = 0.17 ether;
1136     uint256 public price = 0.19 ether;
1137     uint256 public SaleMaxQuantity = 5;
1138 
1139     bool public isPreSalePaused = true;
1140     bool public isPaused = true;
1141     string public _baseURI1;
1142     bytes32 private rootHash;
1143     // revealed uri variables
1144     address private developerWallet =
1145         0xb40185164121A79A638A877b22042af58825cE0b;
1146     bool public revealed = false;
1147     string public notRevealedUri;
1148 
1149     struct userAddress {
1150         address userAddress;
1151         uint256 counter;
1152     }
1153 
1154     mapping(address => userAddress) public _SaleAddresses;
1155     mapping(address => bool) public _SaleAddressExist;
1156 
1157     function flipPreSaleMinting() public onlyOwner {
1158         isPreSalePaused = !isPreSalePaused;
1159     }
1160 
1161     function flipPauseMinting() public onlyOwner {
1162         isPaused = !isPaused;
1163     }
1164 
1165     function setRootHash(bytes32 updatedRootHash) public onlyOwner {
1166         rootHash = updatedRootHash;
1167     }
1168 
1169     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1170         _baseURI1 = _newBaseURI;
1171     }
1172 
1173     function _baseURI() internal view virtual override returns (string memory) {
1174         return _baseURI1;
1175     }
1176 
1177     function setReserve(uint256 _reserve) public onlyOwner {
1178         require(_reserve <= maxsupply, "the quantity exceeds");
1179         reserve = _reserve;
1180     }
1181 
1182     function setPreSalePrice(uint256 _newCost) public onlyOwner {
1183         presaleprice = _newCost;
1184     }
1185 
1186     function setPrice(uint256 _newCost) public onlyOwner {
1187         price = _newCost;
1188     }
1189 
1190     // set reaveal uri just in case
1191 
1192     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1193         notRevealedUri = _notRevealedURI;
1194     }
1195 
1196     // setting reaveal only time can possible
1197     //only owner
1198     function reveal() public onlyOwner {
1199         revealed = !revealed;
1200     }
1201 
1202     function mintReservedTokens(uint256 quantity) public onlyOwner {
1203         require(quantity <= reserve, "All reserve tokens have bene minted");
1204         reserve -= quantity;
1205         _safeMint(msg.sender, quantity);
1206     }
1207 
1208     function PreMint(bytes32[] calldata _merkleProof, uint256 chosenAmount)
1209         public
1210         payable
1211     {
1212         if (_SaleAddressExist[msg.sender] == false) {
1213             _SaleAddresses[msg.sender] = userAddress({
1214                 userAddress: msg.sender,
1215                 counter: 0
1216             });
1217             _SaleAddressExist[msg.sender] = true;
1218         }
1219         require(isPreSalePaused == false, "turn on minting");
1220         require(
1221             chosenAmount > 0,
1222             "Number Of Tokens Can Not Be Less Than Or Equal To 0"
1223         );
1224         require(
1225             _SaleAddresses[msg.sender].counter + chosenAmount <=
1226                 SaleMaxQuantity,
1227             "Quantity Must Be Lesser Than Max Supply"
1228         );
1229         require(
1230             totalSupply() + chosenAmount <= maxsupply - reserve,
1231             "all tokens have been minted"
1232         );
1233         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1234         require(
1235             MerkleProof.verify(_merkleProof, rootHash, leaf),
1236             "Invalid Proof"
1237         );
1238 
1239         require(
1240             presaleprice * chosenAmount == msg.value,
1241             "Sent Ether Value Is Incorrect"
1242         );
1243 
1244         _safeMint(msg.sender, chosenAmount);
1245         _SaleAddresses[msg.sender].counter += chosenAmount;
1246     }
1247 
1248     function Mint(uint256 chosenAmount) public payable {
1249         require(isPaused == false, "turn on minting");
1250         require(
1251             chosenAmount > 0,
1252             "Number Of Tokens Can Not Be Less Than Or Equal To 0"
1253         );
1254         require(
1255             totalSupply() + chosenAmount <= maxsupply - reserve,
1256             "all tokens have been minted"
1257         );
1258 
1259         require(
1260             price * chosenAmount == msg.value,
1261             "Sent Ether Value Is Incorrect"
1262         );
1263 
1264         _safeMint(msg.sender, chosenAmount);
1265     }
1266 
1267     // setting up the reaveal functionality
1268 
1269     function tokenURI(uint256 tokenId)
1270         public
1271         view
1272         virtual
1273         override
1274         returns (string memory)
1275     {
1276         require(
1277             _exists(tokenId),
1278             "ERC721Metadata: URI query for nonexistent token"
1279         );
1280 
1281         if (revealed == false) {
1282             return notRevealedUri;
1283         }
1284 
1285         string memory currentBaseURI = _baseURI();
1286         return
1287             bytes(currentBaseURI).length > 0
1288                 ? string(
1289                     abi.encodePacked(
1290                         currentBaseURI,
1291                         tokenId.toString(),
1292                         ".json"
1293                     )
1294                 )
1295                 : "";
1296     }
1297 
1298     function withdraw() public onlyOwner {
1299         uint256 totalbalance = address(this).balance;
1300         uint256 ownerBalance = (totalbalance * 99) / 100;
1301         uint256 developerBalance = (totalbalance * 1) / 100;
1302         payable(msg.sender).transfer(ownerBalance);
1303         payable(developerWallet).transfer(developerBalance);
1304     }
1305 }