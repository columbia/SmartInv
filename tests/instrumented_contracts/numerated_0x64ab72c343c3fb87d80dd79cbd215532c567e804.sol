1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.7;
8 
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     function toString(uint256 value) internal pure returns (string memory) {
13         if (value == 0) {
14             return "0";
15         }
16         uint256 temp = value;
17         uint256 digits;
18         while (temp != 0) {
19             digits++;
20             temp /= 10;
21         }
22         bytes memory buffer = new bytes(digits);
23         while (value != 0) {
24             digits -= 1;
25             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
26             value /= 10;
27         }
28         return string(buffer);
29     }
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
33      */
34     function toHexString(uint256 value) internal pure returns (string memory) {
35         if (value == 0) {
36             return "0x00";
37         }
38         uint256 temp = value;
39         uint256 length = 0;
40         while (temp != 0) {
41             length++;
42             temp >>= 8;
43         }
44         return toHexString(value, length);
45     }
46 
47     function toHexString(uint256 value, uint256 length)
48         internal
49         pure
50         returns (string memory)
51     {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes calldata) {
70         return msg.data;
71     }
72 }
73 
74 library Address {
75     function isContract(address account) internal view returns (bool) {
76         return account.code.length > 0;
77     }
78 
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(
81             address(this).balance >= amount,
82             "Address: insufficient balance"
83         );
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(
87             success,
88             "Address: unable to send value, recipient may have reverted"
89         );
90     }
91 
92     function functionCall(address target, bytes memory data)
93         internal
94         returns (bytes memory)
95     {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     function functionCallWithValue(
108         address target,
109         bytes memory data,
110         uint256 value
111     ) internal returns (bytes memory) {
112         return
113             functionCallWithValue(
114                 target,
115                 data,
116                 value,
117                 "Address: low-level call with value failed"
118             );
119     }
120 
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value,
125         string memory errorMessage
126     ) internal returns (bytes memory) {
127         require(
128             address(this).balance >= value,
129             "Address: insufficient balance for call"
130         );
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: value}(
134             data
135         );
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     function functionStaticCall(address target, bytes memory data)
140         internal
141         view
142         returns (bytes memory)
143     {
144         return
145             functionStaticCall(
146                 target,
147                 data,
148                 "Address: low-level static call failed"
149             );
150     }
151 
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         require(isContract(target), "Address: static call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.staticcall(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function functionDelegateCall(address target, bytes memory data)
164         internal
165         returns (bytes memory)
166     {
167         return
168             functionDelegateCall(
169                 target,
170                 data,
171                 "Address: low-level delegate call failed"
172             );
173     }
174 
175     function functionDelegateCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(isContract(target), "Address: delegate call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.delegatecall(data);
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     function verifyCallResult(
187         bool success,
188         bytes memory returndata,
189         string memory errorMessage
190     ) internal pure returns (bytes memory) {
191         if (success) {
192             return returndata;
193         } else {
194             // Look for revert reason and bubble it up if present
195             if (returndata.length > 0) {
196                 // The easiest way to bubble the revert reason is using memory via assembly
197 
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208 
209 interface IERC165 {
210     function supportsInterface(bytes4 interfaceId) external view returns (bool);
211 }
212 
213 abstract contract ERC165 is IERC165 {
214     /**
215      * @dev See {IERC165-supportsInterface}.
216      */
217     function supportsInterface(bytes4 interfaceId)
218         public
219         view
220         virtual
221         override
222         returns (bool)
223     {
224         return interfaceId == type(IERC165).interfaceId;
225     }
226 }
227 
228 // IERC721.SOL
229 //IERC721
230 
231 interface IERC721 is IERC165 {
232     /**
233      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
234      */
235     event Transfer(
236         address indexed from,
237         address indexed to,
238         uint256 indexed tokenId
239     );
240 
241     /**
242      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
243      */
244     event Approval(
245         address indexed owner,
246         address indexed approved,
247         uint256 indexed tokenId
248     );
249 
250     /**
251      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
252      */
253     event ApprovalForAll(
254         address indexed owner,
255         address indexed operator,
256         bool approved
257     );
258 
259     /**
260      * @dev Returns the number of tokens in ``owner``'s account.
261      */
262     function balanceOf(address owner) external view returns (uint256 balance);
263 
264     /**
265      * @dev Returns the owner of the `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
275      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Transfers `tokenId` token from `from` to `to`.
295      *
296      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
297      *
298      * Requirements:
299      *
300      * - `from` cannot be the zero address.
301      * - `to` cannot be the zero address.
302      * - `tokenId` token must be owned by `from`.
303      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external;
312 
313     /**
314      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
315      * The approval is cleared when the token is transferred.
316      *
317      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
318      *
319      * Requirements:
320      *
321      * - The caller must own the token or be an approved operator.
322      * - `tokenId` must exist.
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address to, uint256 tokenId) external;
327 
328     /**
329      * @dev Returns the account approved for `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function getApproved(uint256 tokenId)
336         external
337         view
338         returns (address operator);
339 
340     /**
341      * @dev Approve or remove `operator` as an operator for the caller.
342      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
343      *
344      * Requirements:
345      *
346      * - The `operator` cannot be the caller.
347      *
348      * Emits an {ApprovalForAll} event.
349      */
350     function setApprovalForAll(address operator, bool _approved) external;
351 
352     /**
353      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
354      *
355      * See {setApprovalForAll}
356      */
357     function isApprovedForAll(address owner, address operator)
358         external
359         view
360         returns (bool);
361 
362     /**
363      * @dev Safely transfers `tokenId` token from `from` to `to`.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `tokenId` token must exist and be owned by `from`.
370      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
372      *
373      * Emits a {Transfer} event.
374      */
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId,
379         bytes calldata data
380     ) external;
381 }
382 
383 // IERC721Enumerable.sol
384 
385 interface IERC721Enumerable is IERC721 {
386     /**
387      * @dev Returns the total amount of tokens stored by the contract.
388      */
389     function totalSupply() external view returns (uint256);
390 
391     /**
392      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
393      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
394      */
395     function tokenOfOwnerByIndex(address owner, uint256 index)
396         external
397         view
398         returns (uint256);
399 
400     /**
401      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
402      * Use along with {totalSupply} to enumerate all tokens.
403      */
404     function tokenByIndex(uint256 index) external view returns (uint256);
405 }
406 
407 /**
408  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
409  * @dev See https://eips.ethereum.org/EIPS/eip-721
410  */
411 interface IERC721Metadata is IERC721 {
412     /**
413      * @dev Returns the token collection name.
414      */
415     function name() external view returns (string memory);
416 
417     /**
418      * @dev Returns the token collection symbol.
419      */
420     function symbol() external view returns (string memory);
421 
422     /**
423      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
424      */
425     function tokenURI(uint256 tokenId) external view returns (string memory);
426 }
427 
428 // IERC721Reciver.sol
429 /**
430  * @title ERC721 token receiver interface
431  * @dev Interface for any contract that wants to support safeTransfers
432  * from ERC721 asset contracts.
433  */
434 interface IERC721Receiver {
435     /**
436      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
437      * by `operator` from `from`, this function is called.
438      *
439      * It must return its Solidity selector to confirm the token transfer.
440      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
441      *
442      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
443      */
444     function onERC721Received(
445         address operator,
446         address from,
447         uint256 tokenId,
448         bytes calldata data
449     ) external returns (bytes4);
450 }
451 
452 error ApprovalCallerNotOwnerNorApproved();
453 error ApprovalQueryForNonexistentToken();
454 error ApproveToCaller();
455 error ApprovalToCurrentOwner();
456 error BalanceQueryForZeroAddress();
457 error MintedQueryForZeroAddress();
458 error MintToZeroAddress();
459 error MintZeroQuantity();
460 error OwnerIndexOutOfBounds();
461 error OwnerQueryForNonexistentToken();
462 error TokenIndexOutOfBounds();
463 error TransferCallerNotOwnerNorApproved();
464 error TransferFromIncorrectOwner();
465 error TransferToNonERC721ReceiverImplementer();
466 error TransferToZeroAddress();
467 error UnableDetermineTokenOwner();
468 error URIQueryForNonexistentToken();
469 
470 /**
471  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
472  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
473  *
474  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
475  *
476  * Does not support burning tokens to address(0).
477  *
478  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
479  */
480 contract ERC721A is
481     Context,
482     ERC165,
483     IERC721,
484     IERC721Metadata,
485     IERC721Enumerable
486 {
487     using Address for address;
488     using Strings for uint256;
489 
490     struct TokenOwnership {
491         address addr;
492         uint64 startTimestamp;
493     }
494 
495     struct AddressData {
496         uint128 balance;
497         uint128 numberMinted;
498     }
499 
500     uint256 internal _currentIndex;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
510     mapping(uint256 => TokenOwnership) internal _ownerships;
511 
512     // Mapping owner address to address data
513     mapping(address => AddressData) private _addressData;
514 
515     // Mapping from token ID to approved address
516     mapping(uint256 => address) private _tokenApprovals;
517 
518     // Mapping from owner to operator approvals
519     mapping(address => mapping(address => bool)) private _operatorApprovals;
520 
521     constructor(string memory name_, string memory symbol_) {
522         _name = name_;
523         _symbol = symbol_;
524     }
525 
526     /**
527      * @dev See {IERC721Enumerable-totalSupply}.
528      */
529     function totalSupply() public view override returns (uint256) {
530         return _currentIndex;
531     }
532 
533     /**
534      * @dev See {IERC721Enumerable-tokenByIndex}.
535      */
536     function tokenByIndex(uint256 index)
537         public
538         view
539         override
540         returns (uint256)
541     {
542         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
543         return index;
544     }
545 
546     /**
547      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
548      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
549      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
550      */
551     function tokenOfOwnerByIndex(address owner, uint256 index)
552         public
553         view
554         override
555         returns (uint256 a)
556     {
557         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
558         uint256 numMintedSoFar = totalSupply();
559         uint256 tokenIdsIdx;
560         address currOwnershipAddr;
561 
562         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
563         unchecked {
564             for (uint256 i; i < numMintedSoFar; i++) {
565                 TokenOwnership memory ownership = _ownerships[i];
566                 if (ownership.addr != address(0)) {
567                     currOwnershipAddr = ownership.addr;
568                 }
569                 if (currOwnershipAddr == owner) {
570                     if (tokenIdsIdx == index) {
571                         return i;
572                     }
573                     tokenIdsIdx++;
574                 }
575             }
576         }
577 
578         // Execution should never reach this point.
579         assert(false);
580     }
581 
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId)
586         public
587         view
588         virtual
589         override(ERC165, IERC165)
590         returns (bool)
591     {
592         return
593             interfaceId == type(IERC721).interfaceId ||
594             interfaceId == type(IERC721Metadata).interfaceId ||
595             interfaceId == type(IERC721Enumerable).interfaceId ||
596             super.supportsInterface(interfaceId);
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view override returns (uint256) {
603         if (owner == address(0)) revert BalanceQueryForZeroAddress();
604         return uint256(_addressData[owner].balance);
605     }
606 
607     function _numberMinted(address owner) internal view returns (uint256) {
608         if (owner == address(0)) revert MintedQueryForZeroAddress();
609         return uint256(_addressData[owner].numberMinted);
610     }
611 
612     /**
613      * Gas spent here starts off proportional to the maximum mint batch size.
614      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
615      */
616     function ownershipOf(uint256 tokenId)
617         internal
618         view
619         returns (TokenOwnership memory)
620     {
621         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
622 
623         unchecked {
624             for (uint256 curr = tokenId; curr >= 0; curr--) {
625                 TokenOwnership memory ownership = _ownerships[curr];
626                 if (ownership.addr != address(0)) {
627                     return ownership;
628                 }
629             }
630         }
631 
632         revert UnableDetermineTokenOwner();
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view override returns (address) {
639         return ownershipOf(tokenId).addr;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-name}.
644      */
645     function name() public view virtual override returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-symbol}.
651      */
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-tokenURI}.
658      */
659     function tokenURI(uint256 tokenId)
660         public
661         view
662         virtual
663         override
664         returns (string memory)
665     {
666         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
667 
668         string memory baseURI = _baseURI();
669         return
670             bytes(baseURI).length != 0
671                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ""))
672                 : "";
673     }
674 
675     /**
676      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
677      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
678      * by default, can be overriden in child contracts.
679      */
680     function _baseURI() internal view virtual returns (string memory) {
681         return "";
682     }
683 
684     /**
685      * @dev See {IERC721-approve}.
686      */
687     function approve(address to, uint256 tokenId) public override {
688         address owner = ERC721A.ownerOf(tokenId);
689         if (to == owner) revert ApprovalToCurrentOwner();
690 
691         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
692             revert ApprovalCallerNotOwnerNorApproved();
693 
694         _approve(to, tokenId, owner);
695     }
696 
697     /**
698      * @dev See {IERC721-getApproved}.
699      */
700     function getApproved(uint256 tokenId)
701         public
702         view
703         override
704         returns (address)
705     {
706         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev See {IERC721-setApprovalForAll}.
713      */
714     function setApprovalForAll(address operator, bool approved)
715         public
716         override
717     {
718         if (operator == _msgSender()) revert ApproveToCaller();
719 
720         _operatorApprovals[_msgSender()][operator] = approved;
721         emit ApprovalForAll(_msgSender(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator)
728         public
729         view
730         virtual
731         override
732         returns (bool)
733     {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public override {
768         _transfer(from, to, tokenId);
769         if (!_checkOnERC721Received(from, to, tokenId, _data))
770             revert TransferToNonERC721ReceiverImplementer();
771     }
772 
773     /**
774      * @dev Returns whether `tokenId` exists.
775      *
776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
777      *
778      * Tokens start existing when they are minted (`_mint`),
779      */
780     function _exists(uint256 tokenId) internal view returns (bool) {
781         return tokenId < _currentIndex;
782     }
783 
784     function _safeMint(address to, uint256 quantity) internal {
785         _safeMint(to, quantity, "");
786     }
787 
788     /**
789      * @dev Safely mints `quantity` tokens and transfers them to `to`.
790      *
791      * Requirements:
792      *
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
794      * - `quantity` must be greater than 0.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeMint(
799         address to,
800         uint256 quantity,
801         bytes memory _data
802     ) internal {
803         _mint(to, quantity, _data, true);
804     }
805 
806     /**
807      * @dev Mints `quantity` tokens and transfers them to `to`.
808      *
809      * Requirements:
810      *
811      * - `to` cannot be the zero address.
812      * - `quantity` must be greater than 0.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _mint(
817         address to,
818         uint256 quantity,
819         bytes memory _data,
820         bool safe
821     ) internal {
822         uint256 startTokenId = _currentIndex;
823         if (to == address(0)) revert MintToZeroAddress();
824         // if (quantity == 0) revert MintZeroQuantity();
825 
826         //_beforeTokenTransfers(address(0), to, startTokenId, quantity);
827 
828         // Overflows are incredibly unrealistic.
829         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
830         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
831         unchecked {
832             _addressData[to].balance += uint128(quantity);
833             _addressData[to].numberMinted += uint128(quantity);
834 
835             _ownerships[startTokenId].addr = to;
836             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
837 
838             uint256 updatedIndex = startTokenId;
839 
840             for (uint256 i; i < quantity; i++) {
841                 emit Transfer(address(0), to, updatedIndex);
842                 if (
843                     safe &&
844                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
845                 ) {
846                     revert TransferToNonERC721ReceiverImplementer();
847                 }
848 
849                 updatedIndex++;
850             }
851 
852             _currentIndex = updatedIndex;
853         }
854 
855         _afterTokenTransfers(address(0), to, startTokenId, quantity);
856     }
857 
858     /**
859      * @dev Transfers `tokenId` from `from` to `to`.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _transfer(
869         address from,
870         address to,
871         uint256 tokenId
872     ) private {
873         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
874 
875         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
876             getApproved(tokenId) == _msgSender() ||
877             isApprovedForAll(prevOwnership.addr, _msgSender()));
878 
879         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
880         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
881         if (to == address(0)) revert TransferToZeroAddress();
882 
883         // _beforeTokenTransfers(from, to, tokenId, 1);
884 
885         // Clear approvals from the previous owner
886         _approve(address(0), tokenId, prevOwnership.addr);
887 
888         // Underflow of the sender's balance is impossible because we check for
889         // ownership above and the recipient's balance can't realistically overflow.
890         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
891         unchecked {
892             _addressData[from].balance -= 1;
893             _addressData[to].balance += 1;
894 
895             _ownerships[tokenId].addr = to;
896             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
897 
898             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
899             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
900             uint256 nextTokenId = tokenId + 1;
901             if (_ownerships[nextTokenId].addr == address(0)) {
902                 if (_exists(nextTokenId)) {
903                     _ownerships[nextTokenId].addr = prevOwnership.addr;
904                     _ownerships[nextTokenId].startTimestamp = prevOwnership
905                         .startTimestamp;
906                 }
907             }
908         }
909 
910         emit Transfer(from, to, tokenId);
911         _afterTokenTransfers(from, to, tokenId, 1);
912     }
913 
914     /**
915      * @dev Approve `to` to operate on `tokenId`
916      *
917      * Emits a {Approval} event.
918      */
919     function _approve(
920         address to,
921         uint256 tokenId,
922         address owner
923     ) private {
924         _tokenApprovals[tokenId] = to;
925         emit Approval(owner, to, tokenId);
926     }
927 
928     /**
929      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
930      * The call is not executed if the target address is not a contract.
931      *
932      * @param from address representing the previous owner of the given token ID
933      * @param to target address that will receive the tokens
934      * @param tokenId uint256 ID of the token to be transferred
935      * @param _data bytes optional data to send along with the call
936      * @return bool whether the call correctly returned the expected magic value
937      */
938     function _checkOnERC721Received(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) private returns (bool) {
944         if (to.isContract()) {
945             try
946                 IERC721Receiver(to).onERC721Received(
947                     _msgSender(),
948                     from,
949                     tokenId,
950                     _data
951                 )
952             returns (bytes4 retval) {
953                 return retval == IERC721Receiver(to).onERC721Received.selector;
954             } catch (bytes memory reason) {
955                 if (reason.length == 0)
956                     revert TransferToNonERC721ReceiverImplementer();
957                 else {
958                     assembly {
959                         revert(add(32, reason), mload(reason))
960                     }
961                 }
962             }
963         } else {
964             return true;
965         }
966     }
967 
968     /**
969      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
970      *
971      * startTokenId - the first token id to be transferred
972      * quantity - the amount to be transferred
973      *
974      * Calling conditions:
975      *
976      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
977      * transferred to `to`.
978      * - When `from` is zero, `tokenId` will be minted for `to`.
979      */
980     function _beforeTokenTransfers(
981         address from,
982         address to,
983         uint256 startTokenId,
984         uint256 quantity
985     ) internal virtual {}
986 
987     /**
988      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
989      * minting.
990      *
991      * startTokenId - the first token id to be transferred
992      * quantity - the amount to be transferred
993      *
994      * Calling conditions:
995      *
996      * - when `from` and `to` are both non-zero.
997      * - `from` and `to` are never both zero.
998      */
999     function _afterTokenTransfers(
1000         address from,
1001         address to,
1002         uint256 startTokenId,
1003         uint256 quantity
1004     ) internal virtual {}
1005 }
1006 
1007 abstract contract Ownable is Context {
1008     address private _owner;
1009 
1010     event OwnershipTransferred(
1011         address indexed previousOwner,
1012         address indexed newOwner
1013     );
1014 
1015     /**
1016      * @dev Initializes the contract setting the deployer as the initial owner.
1017      */
1018     constructor() {
1019         _transferOwnership(_msgSender());
1020     }
1021 
1022     /**
1023      * @dev Returns the address of the current owner.
1024      */
1025     function owner() public view virtual returns (address) {
1026         return _owner;
1027     }
1028 
1029     /**
1030      * @dev Throws if called by any account other than the owner.
1031      */
1032     modifier onlyOwner() {
1033         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1034         _;
1035     }
1036 
1037     /**
1038      * @dev Leaves the contract without owner. It will not be possible to call
1039      * `onlyOwner` functions anymore. Can only be called by the current owner.
1040      *
1041      * NOTE: Renouncing ownership will leave the contract without an owner,
1042      * thereby removing any functionality that is only available to the owner.
1043      */
1044     function renounceOwnership() public virtual onlyOwner {
1045         _transferOwnership(address(0));
1046     }
1047 
1048     /**
1049      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1050      * Can only be called by the current owner.
1051      */
1052     function transferOwnership(address newOwner) public virtual onlyOwner {
1053         require(
1054             newOwner != address(0),
1055             "Ownable: new owner is the zero address"
1056         );
1057         _transferOwnership(newOwner);
1058     }
1059 
1060     /**
1061      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1062      * Internal function without access restriction.
1063      */
1064     function _transferOwnership(address newOwner) internal virtual {
1065         address oldOwner = _owner;
1066         _owner = newOwner;
1067         emit OwnershipTransferred(oldOwner, newOwner);
1068     }
1069 }
1070 
1071 library MerkleProof {
1072     /**
1073      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1074      * defined by `root`. For this, a `proof` must be provided, containing
1075      * sibling hashes on the branch from the leaf to the root of the tree. Each
1076      * pair of leaves and each pair of pre-images are assumed to be sorted.
1077      */
1078     function verify(
1079         bytes32[] memory proof,
1080         bytes32 root,
1081         bytes32 leaf
1082     ) internal pure returns (bool) {
1083         return processProof(proof, leaf) == root;
1084     }
1085 
1086     /**
1087      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1088      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1089      * hash matches the root of the tree. When processing the proof, the pairs
1090      * of leafs & pre-images are assumed to be sorted.
1091      *
1092      * _Available since v4.4._
1093      */
1094     function processProof(bytes32[] memory proof, bytes32 leaf)
1095         internal
1096         pure
1097         returns (bytes32)
1098     {
1099         bytes32 computedHash = leaf;
1100         for (uint256 i = 0; i < proof.length; i++) {
1101             bytes32 proofElement = proof[i];
1102             if (computedHash <= proofElement) {
1103                 // Hash(current computed hash + current element of the proof)
1104                 computedHash = _efficientHash(computedHash, proofElement);
1105             } else {
1106                 // Hash(current element of the proof + current computed hash)
1107                 computedHash = _efficientHash(proofElement, computedHash);
1108             }
1109         }
1110         return computedHash;
1111     }
1112 
1113     function _efficientHash(bytes32 a, bytes32 b)
1114         private
1115         pure
1116         returns (bytes32 value)
1117     {
1118         assembly {
1119             mstore(0x00, a)
1120             mstore(0x20, b)
1121             value := keccak256(0x00, 0x40)
1122         }
1123     }
1124 }
1125 
1126 contract MashMellows is ERC721A, Ownable {
1127     // variables
1128     using Strings for uint256;
1129 
1130     constructor(bytes32 finalRootHash, string memory _NotRevealedUri)
1131         ERC721A("MashMellows", "MASH")
1132     {
1133         rootHash = finalRootHash;
1134         setNotRevealedURI(_NotRevealedUri);
1135     }
1136 
1137     uint256 public maxsupply = 5000;
1138     uint256 public reserve = 100;
1139     uint256 public price = 0.045 ether;
1140     uint256 public SaleMaxQuantity = 3;
1141 
1142     bool public isHolderPaused = false;
1143     bool public isPublicPaused = true;
1144     string public _baseURI1;
1145     bytes32 private rootHash;
1146     // revealed uri variables
1147 
1148     bool public revealed = false;
1149     string public notRevealedUri;
1150 
1151     struct userAddress {
1152         address userAddress;
1153         uint256 counter;
1154     }
1155 
1156     mapping(address => userAddress) public _SaleAddresses;
1157     mapping(address => bool) public _SaleAddressExist;
1158 
1159     function flipHolderMintStatus() public onlyOwner {
1160         isHolderPaused = !isHolderPaused;
1161     }
1162 
1163     function flipPauseMintStatus() public onlyOwner {
1164         isPublicPaused = !isPublicPaused;
1165     }
1166 
1167     function setRootHash(bytes32 updatedRootHash) public onlyOwner {
1168         rootHash = updatedRootHash;
1169     }
1170 
1171     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1172         _baseURI1 = _newBaseURI;
1173     }
1174 
1175     function _baseURI() internal view virtual override returns (string memory) {
1176         return _baseURI1;
1177     }
1178 
1179     function setReserve(uint256 _reserve) public onlyOwner {
1180         require(_reserve <= maxsupply, "the quantity exceeds");
1181         reserve = _reserve;
1182     }
1183 
1184     function setPrice(uint256 _newCost) public onlyOwner {
1185         price = _newCost;
1186     }
1187 
1188     // set reaveal uri just in case
1189 
1190     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1191         notRevealedUri = _notRevealedURI;
1192     }
1193 
1194     // setting reaveal only time can possible
1195     //only owner
1196     function reveal() public onlyOwner {
1197         revealed = true;
1198     }
1199 
1200     function mintReservedTokens(uint256 quantity) public onlyOwner {
1201         require(quantity <= reserve, "All reserve tokens have bene minted");
1202         reserve -= quantity;
1203         _safeMint(msg.sender, quantity);
1204     }
1205 
1206     function HolderMint(bytes32[] calldata _merkleProof, uint256 chosenAmount)
1207         public
1208     {
1209         if (_SaleAddressExist[msg.sender] == false) {
1210             _SaleAddresses[msg.sender] = userAddress({
1211                 userAddress: msg.sender,
1212                 counter: 0
1213             });
1214             _SaleAddressExist[msg.sender] = true;
1215         }
1216         require(isHolderPaused == false, "turn on minting");
1217         require(
1218             chosenAmount > 0,
1219             "Number Of Tokens Can Not Be Less Than Or Equal To 0"
1220         );
1221         require(
1222             _SaleAddresses[msg.sender].counter + chosenAmount <=
1223                 SaleMaxQuantity,
1224             "Quantity Must Be Lesser Than Max Supply"
1225         );
1226         require(
1227             totalSupply() + chosenAmount <= maxsupply - reserve,
1228             "all tokens have been minted"
1229         );
1230         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1231         require(
1232             MerkleProof.verify(_merkleProof, rootHash, leaf),
1233             "Invalid Proof"
1234         );
1235 
1236         // require(
1237         //     presaleprice * chosenAmount == msg.value,
1238         //     "Sent Ether Value Is Incorrect"
1239         // );
1240 
1241         _safeMint(msg.sender, chosenAmount);
1242         _SaleAddresses[msg.sender].counter += chosenAmount;
1243     }
1244 
1245     function Mint(uint256 chosenAmount) public payable {
1246         require(isPublicPaused == false, "turn on minting");
1247         require(
1248             chosenAmount > 0,
1249             "Number Of Tokens Can Not Be Less Than Or Equal To 0"
1250         );
1251         require(
1252             totalSupply() + chosenAmount <= maxsupply - reserve,
1253             "all tokens have been minted"
1254         );
1255 
1256         require(
1257             price * chosenAmount == msg.value,
1258             "Sent Ether Value Is Incorrect"
1259         );
1260 
1261         _safeMint(msg.sender, chosenAmount);
1262     }
1263 
1264     // setting up the reaveal functionality
1265 
1266     function tokenURI(uint256 tokenId)
1267         public
1268         view
1269         virtual
1270         override
1271         returns (string memory)
1272     {
1273         require(
1274             _exists(tokenId),
1275             "ERC721Metadata: URI query for nonexistent token"
1276         );
1277 
1278         if (revealed == false) {
1279             return notRevealedUri;
1280         }
1281 
1282         string memory currentBaseURI = _baseURI();
1283         return
1284             bytes(currentBaseURI).length > 0
1285                 ? string(
1286                     abi.encodePacked(
1287                         currentBaseURI,
1288                         tokenId.toString(),
1289                         ".json"
1290                     )
1291                 )
1292                 : "";
1293     }
1294 
1295     function withdraw() public onlyOwner {
1296         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1297         require(hq);
1298     }
1299 }