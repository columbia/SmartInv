1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.3;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length)
53         internal
54         pure
55         returns (string memory)
56     {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 library Address {
70     function isContract(address account) internal view returns (bool) {
71         uint256 size;
72         assembly {
73             size := extcodesize(account)
74         }
75         return size > 0;
76     }
77 
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(
80             address(this).balance >= amount,
81             "Address: insufficient balance"
82         );
83 
84         (bool success, ) = recipient.call{value: amount}("");
85         require(
86             success,
87             "Address: unable to send value, recipient may have reverted"
88         );
89     }
90 
91     function functionCall(address target, bytes memory data)
92         internal
93         returns (bytes memory)
94     {
95         return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     function functionCallWithValue(
107         address target,
108         bytes memory data,
109         uint256 value
110     ) internal returns (bytes memory) {
111         return
112             functionCallWithValue(
113                 target,
114                 data,
115                 value,
116                 "Address: low-level call with value failed"
117             );
118     }
119 
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value,
124         string memory errorMessage
125     ) internal returns (bytes memory) {
126         require(
127             address(this).balance >= value,
128             "Address: insufficient balance for call"
129         );
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(
133             data
134         );
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     function functionStaticCall(address target, bytes memory data)
139         internal
140         view
141         returns (bytes memory)
142     {
143         return
144             functionStaticCall(
145                 target,
146                 data,
147                 "Address: low-level static call failed"
148             );
149     }
150 
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     function functionDelegateCall(address target, bytes memory data)
163         internal
164         returns (bytes memory)
165     {
166         return
167             functionDelegateCall(
168                 target,
169                 data,
170                 "Address: low-level delegate call failed"
171             );
172     }
173 
174     function functionDelegateCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(isContract(target), "Address: delegate call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.delegatecall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     function verifyCallResult(
186         bool success,
187         bytes memory returndata,
188         string memory errorMessage
189     ) internal pure returns (bytes memory) {
190         if (success) {
191             return returndata;
192         } else {
193             // Look for revert reason and bubble it up if present
194             if (returndata.length > 0) {
195                 // The easiest way to bubble the revert reason is using memory via assembly
196 
197                 assembly {
198                     let returndata_size := mload(returndata)
199                     revert(add(32, returndata), returndata_size)
200                 }
201             } else {
202                 revert(errorMessage);
203             }
204         }
205     }
206 }
207 
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 
213     function _msgData() internal view virtual returns (bytes calldata) {
214         return msg.data;
215     }
216 }
217 
218 abstract contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor() {
227         _transferOwnership(_msgSender());
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public virtual onlyOwner {
253         _transferOwnership(address(0));
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Can only be called by the current owner.
259      */
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         _transferOwnership(newOwner);
263     }
264 
265     /**
266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
267      * Internal function without access restriction.
268      */
269     function _transferOwnership(address newOwner) internal virtual {
270         address oldOwner = _owner;
271         _owner = newOwner;
272         emit OwnershipTransferred(oldOwner, newOwner);
273     }
274 }
275 
276 interface IERC165 {
277     /**
278      * @dev Returns true if this contract implements the interface defined by
279      * `interfaceId`. See the corresponding
280      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
281      * to learn more about how these ids are created.
282      *
283      * This function call must use less than 30 000 gas.
284      */
285     function supportsInterface(bytes4 interfaceId) external view returns (bool);
286 }
287 
288 interface IERC721 is IERC165 {
289     /**
290      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
293 
294     /**
295      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
296      */
297     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
298 
299     /**
300      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
301      */
302     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
303 
304     /**
305      * @dev Returns the number of tokens in ``owner``'s account.
306      */
307     function balanceOf(address owner) external view returns (uint256 balance);
308 
309     /**
310      * @dev Returns the owner of the `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function ownerOf(uint256 tokenId) external view returns (address owner);
317 
318     /**
319      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
320      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId
336     ) external;
337 
338     /**
339      * @dev Transfers `tokenId` token from `from` to `to`.
340      *
341      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must be owned by `from`.
348      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transferFrom(
353         address from,
354         address to,
355         uint256 tokenId
356     ) external;
357 
358     /**
359      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
360      * The approval is cleared when the token is transferred.
361      *
362      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
363      *
364      * Requirements:
365      *
366      * - The caller must own the token or be an approved operator.
367      * - `tokenId` must exist.
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address to, uint256 tokenId) external;
372 
373     /**
374      * @dev Returns the account approved for `tokenId` token.
375      *
376      * Requirements:
377      *
378      * - `tokenId` must exist.
379      */
380     function getApproved(uint256 tokenId) external view returns (address operator);
381 
382     /**
383      * @dev Approve or remove `operator` as an operator for the caller.
384      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
385      *
386      * Requirements:
387      *
388      * - The `operator` cannot be the caller.
389      *
390      * Emits an {ApprovalForAll} event.
391      */
392     function setApprovalForAll(address operator, bool _approved) external;
393 
394     /**
395      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
396      *
397      * See {setApprovalForAll}
398      */
399     function isApprovedForAll(address owner, address operator) external view returns (bool);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId,
418         bytes calldata data
419     ) external;
420 }
421 
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 interface IERC721Metadata is IERC721 {
441     /**
442      * @dev Returns the token collection name.
443      */
444     function name() external view returns (string memory);
445 
446     /**
447      * @dev Returns the token collection symbol.
448      */
449     function symbol() external view returns (string memory);
450 
451     /**
452      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
453      */
454     function tokenURI(uint256 tokenId) external view returns (string memory);
455 }
456 
457 interface IERC721Enumerable is IERC721 {
458     /**
459      * @dev Returns the total amount of tokens stored by the contract.
460      */
461     function totalSupply() external view returns (uint256);
462 
463     /**
464      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
465      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
466      */
467     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
468 
469     /**
470      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
471      * Use along with {totalSupply} to enumerate all tokens.
472      */
473     function tokenByIndex(uint256 index) external view returns (uint256);
474 }
475 
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 library MerkleProof {
486     /**
487      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
488      * defined by `root`. For this, a `proof` must be provided, containing
489      * sibling hashes on the branch from the leaf to the root of the tree. Each
490      * pair of leaves and each pair of pre-images are assumed to be sorted.
491      */
492     function verify(
493         bytes32[] memory proof,
494         bytes32 root,
495         bytes32 leaf
496     ) internal pure returns (bool) {
497         return processProof(proof, leaf) == root;
498     }
499 
500     /**
501      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
502      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
503      * hash matches the root of the tree. When processing the proof, the pairs
504      * of leafs & pre-images are assumed to be sorted.
505      *
506      * _Available since v4.4._
507      */
508     function processProof(bytes32[] memory proof, bytes32 leaf)
509         internal
510         pure
511         returns (bytes32)
512     {
513         bytes32 computedHash = leaf;
514         for (uint256 i = 0; i < proof.length; i++) {
515             bytes32 proofElement = proof[i];
516             if (computedHash <= proofElement) {
517                 // Hash(current computed hash + current element of the proof)
518                 computedHash = keccak256(
519                     abi.encodePacked(computedHash, proofElement)
520                 );
521             } else {
522                 // Hash(current element of the proof + current computed hash)
523                 computedHash = keccak256(
524                     abi.encodePacked(proofElement, computedHash)
525                 );
526             }
527         }
528         return computedHash;
529     }
530 }
531 
532 contract ERC721A is
533     Context,
534     ERC165,
535     IERC721,
536     IERC721Metadata,
537     IERC721Enumerable
538 {
539     using Address for address;
540     using Strings for uint256;
541 
542     struct TokenOwnership {
543         address addr;
544         uint64 startTimestamp;
545     }
546 
547     struct AddressData {
548         uint128 balance;
549         uint128 numberMinted;
550     }
551 
552     uint256 private currentIndex = 0;
553 
554     uint256 internal immutable collectionSize;
555     uint256 internal immutable maxBatchSize;
556 
557     // Token name
558     string private _name;
559 
560     // Token symbol
561     string private _symbol;
562 
563     // Mapping from token ID to ownership details
564     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
565     mapping(uint256 => TokenOwnership) private _ownerships;
566 
567     // Mapping owner address to address data
568     mapping(address => AddressData) private _addressData;
569 
570     // Mapping from token ID to approved address
571     mapping(uint256 => address) private _tokenApprovals;
572 
573     // Mapping from owner to operator approvals
574     mapping(address => mapping(address => bool)) private _operatorApprovals;
575 
576     /**
577      * @dev
578      * `maxBatchSize` refers to how much a minter can mint at a time.
579      * `collectionSize_` refers to how many tokens are in the collection.
580      */
581     constructor(
582         string memory name_,
583         string memory symbol_,
584         uint256 maxBatchSize_,
585         uint256 collectionSize_
586     ) {
587         require(
588             collectionSize_ > 0,
589             "ERC721A: collection must have a nonzero supply"
590         );
591         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
592         _name = name_;
593         _symbol = symbol_;
594         maxBatchSize = maxBatchSize_;
595         collectionSize = collectionSize_;
596     }
597 
598     /**
599      * @dev See {IERC721Enumerable-totalSupply}.
600      */
601     function totalSupply() public view override returns (uint256) {
602         return currentIndex;
603     }
604 
605     /**
606      * @dev See {IERC721Enumerable-tokenByIndex}.
607      */
608     function tokenByIndex(uint256 index)
609         public
610         view
611         override
612         returns (uint256)
613     {
614         require(index < totalSupply(), "ERC721A: global index out of bounds");
615         return index;
616     }
617 
618     /**
619      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
620      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
621      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
622      */
623     function tokenOfOwnerByIndex(address owner, uint256 index)
624         public
625         view
626         override
627         returns (uint256)
628     {
629         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
630         uint256 numMintedSoFar = totalSupply();
631         uint256 tokenIdsIdx = 0;
632         address currOwnershipAddr = address(0);
633         for (uint256 i = 0; i < numMintedSoFar; i++) {
634             TokenOwnership memory ownership = _ownerships[i];
635             if (ownership.addr != address(0)) {
636                 currOwnershipAddr = ownership.addr;
637             }
638             if (currOwnershipAddr == owner) {
639                 if (tokenIdsIdx == index) {
640                     return i;
641                 }
642                 tokenIdsIdx++;
643             }
644         }
645         revert("ERC721A: unable to get token of owner by index");
646     }
647 
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      */
651     function supportsInterface(bytes4 interfaceId)
652         public
653         view
654         virtual
655         override(ERC165, IERC165)
656         returns (bool)
657     {
658         return
659             interfaceId == type(IERC721).interfaceId ||
660             interfaceId == type(IERC721Metadata).interfaceId ||
661             interfaceId == type(IERC721Enumerable).interfaceId ||
662             super.supportsInterface(interfaceId);
663     }
664 
665     /**
666      * @dev See {IERC721-balanceOf}.
667      */
668     function balanceOf(address owner) public view override returns (uint256) {
669         require(
670             owner != address(0),
671             "ERC721A: balance query for the zero address"
672         );
673         return uint256(_addressData[owner].balance);
674     }
675 
676     function _numberMinted(address owner) internal view returns (uint256) {
677         require(
678             owner != address(0),
679             "ERC721A: number minted query for the zero address"
680         );
681         return uint256(_addressData[owner].numberMinted);
682     }
683 
684     function ownershipOf(uint256 tokenId)
685         internal
686         view
687         returns (TokenOwnership memory)
688     {
689         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
690 
691         uint256 lowestTokenToCheck;
692         if (tokenId >= maxBatchSize) {
693             lowestTokenToCheck = tokenId - maxBatchSize + 1;
694         }
695 
696         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
697             TokenOwnership memory ownership = _ownerships[curr];
698             if (ownership.addr != address(0)) {
699                 return ownership;
700             }
701         }
702 
703         revert("ERC721A: unable to determine the owner of token");
704     }
705 
706     /**
707      * @dev See {IERC721-ownerOf}.
708      */
709     function ownerOf(uint256 tokenId) public view override returns (address) {
710         return ownershipOf(tokenId).addr;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-name}.
715      */
716     function name() public view virtual override returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev See {IERC721Metadata-symbol}.
722      */
723     function symbol() public view virtual override returns (string memory) {
724         return _symbol;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-tokenURI}.
729      */
730     function tokenURI(uint256 tokenId)
731         public
732         view
733         virtual
734         override
735         returns (string memory)
736     {
737         require(
738             _exists(tokenId),
739             "ERC721Metadata: URI query for nonexistent token"
740         );
741 
742         string memory baseURI = _baseURI();
743         return
744             bytes(baseURI).length > 0
745                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
746                 : "";
747     }
748 
749     /**
750      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
751      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
752      * by default, can be overriden in child contracts.
753      */
754     function _baseURI() internal view virtual returns (string memory) {
755         return "";
756     }
757 
758     /**
759      * @dev See {IERC721-approve}.
760      */
761     function approve(address to, uint256 tokenId) public override {
762         address owner = ERC721A.ownerOf(tokenId);
763         require(to != owner, "ERC721A: approval to current owner");
764 
765         require(
766             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
767             "ERC721A: approve caller is not owner nor approved for all"
768         );
769 
770         _approve(to, tokenId, owner);
771     }
772 
773     /**
774      * @dev See {IERC721-getApproved}.
775      */
776     function getApproved(uint256 tokenId)
777         public
778         view
779         override
780         returns (address)
781     {
782         require(
783             _exists(tokenId),
784             "ERC721A: approved query for nonexistent token"
785         );
786 
787         return _tokenApprovals[tokenId];
788     }
789 
790     /**
791      * @dev See {IERC721-setApprovalForAll}.
792      */
793     function setApprovalForAll(address operator, bool approved)
794         public
795         override
796     {
797         require(operator != _msgSender(), "ERC721A: approve to caller");
798 
799         _operatorApprovals[_msgSender()][operator] = approved;
800         emit ApprovalForAll(_msgSender(), operator, approved);
801     }
802 
803     /**
804      * @dev See {IERC721-isApprovedForAll}.
805      */
806     function isApprovedForAll(address owner, address operator)
807         public
808         view
809         virtual
810         override
811         returns (bool)
812     {
813         return _operatorApprovals[owner][operator];
814     }
815 
816     /**
817      * @dev See {IERC721-transferFrom}.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public override {
824         _transfer(from, to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public override {
835         safeTransferFrom(from, to, tokenId, "");
836     }
837 
838     /**
839      * @dev See {IERC721-safeTransferFrom}.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) public override {
847         _transfer(from, to, tokenId);
848         require(
849             _checkOnERC721Received(from, to, tokenId, _data),
850             "ERC721A: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Returns whether `tokenId` exists.
856      *
857      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
858      *
859      * Tokens start existing when they are minted (`_mint`),
860      */
861     function _exists(uint256 tokenId) internal view returns (bool) {
862         return tokenId < currentIndex;
863     }
864 
865     function _safeMint(address to, uint256 quantity) internal {
866         _safeMint(to, quantity, "");
867     }
868 
869     /**
870      * @dev Mints `quantity` tokens and transfers them to `to`.
871      *
872      * Requirements:
873      *
874      * - there must be `quantity` tokens remaining unminted in the total collection.
875      * - `to` cannot be the zero address.
876      * - `quantity` cannot be larger than the max batch size.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeMint(
881         address to,
882         uint256 quantity,
883         bytes memory _data
884     ) internal {
885         uint256 startTokenId = currentIndex;
886         require(to != address(0), "ERC721A: mint to the zero address");
887         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
888         require(!_exists(startTokenId), "ERC721A: token already minted");
889         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
890 
891         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
892 
893         AddressData memory addressData = _addressData[to];
894         _addressData[to] = AddressData(
895             addressData.balance + uint128(quantity),
896             addressData.numberMinted + uint128(quantity)
897         );
898         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
899 
900         uint256 updatedIndex = startTokenId;
901 
902         for (uint256 i = 0; i < quantity; i++) {
903             emit Transfer(address(0), to, updatedIndex);
904             require(
905                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
906                 "ERC721A: transfer to non ERC721Receiver implementer"
907             );
908             updatedIndex++;
909         }
910 
911         currentIndex = updatedIndex;
912         _afterTokenTransfers(address(0), to, startTokenId, quantity);
913     }
914 
915     /**
916      * @dev Transfers `tokenId` from `from` to `to`.
917      *
918      * Requirements:
919      *
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must be owned by `from`.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _transfer(
926         address from,
927         address to,
928         uint256 tokenId
929     ) private {
930         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
931 
932         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
933             getApproved(tokenId) == _msgSender() ||
934             isApprovedForAll(prevOwnership.addr, _msgSender()));
935 
936         require(
937             isApprovedOrOwner,
938             "ERC721A: transfer caller is not owner nor approved"
939         );
940 
941         require(
942             prevOwnership.addr == from,
943             "ERC721A: transfer from incorrect owner"
944         );
945         require(to != address(0), "ERC721A: transfer to the zero address");
946 
947         _beforeTokenTransfers(from, to, tokenId, 1);
948 
949         // Clear approvals from the previous owner
950         _approve(address(0), tokenId, prevOwnership.addr);
951 
952         _addressData[from].balance -= 1;
953         _addressData[to].balance += 1;
954         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
955 
956         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
957         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
958         uint256 nextTokenId = tokenId + 1;
959         if (_ownerships[nextTokenId].addr == address(0)) {
960             if (_exists(nextTokenId)) {
961                 _ownerships[nextTokenId] = TokenOwnership(
962                     prevOwnership.addr,
963                     prevOwnership.startTimestamp
964                 );
965             }
966         }
967 
968         emit Transfer(from, to, tokenId);
969         _afterTokenTransfers(from, to, tokenId, 1);
970     }
971 
972     /**
973      * @dev Approve `to` to operate on `tokenId`
974      *
975      * Emits a {Approval} event.
976      */
977     function _approve(
978         address to,
979         uint256 tokenId,
980         address owner
981     ) private {
982         _tokenApprovals[tokenId] = to;
983         emit Approval(owner, to, tokenId);
984     }
985 
986     uint256 public nextOwnerToExplicitlySet = 0;
987 
988     /**
989      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
990      */
991     function _setOwnersExplicit(uint256 quantity) internal {
992         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
993         require(quantity > 0, "quantity must be nonzero");
994         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
995         if (endIndex > collectionSize - 1) {
996             endIndex = collectionSize - 1;
997         }
998         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
999         require(_exists(endIndex), "not enough minted yet for this cleanup");
1000         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1001             if (_ownerships[i].addr == address(0)) {
1002                 TokenOwnership memory ownership = ownershipOf(i);
1003                 _ownerships[i] = TokenOwnership(
1004                     ownership.addr,
1005                     ownership.startTimestamp
1006                 );
1007             }
1008         }
1009         nextOwnerToExplicitlySet = endIndex + 1;
1010     }
1011 
1012     /**
1013      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1014      * The call is not executed if the target address is not a contract.
1015      *
1016      * @param from address representing the previous owner of the given token ID
1017      * @param to target address that will receive the tokens
1018      * @param tokenId uint256 ID of the token to be transferred
1019      * @param _data bytes optional data to send along with the call
1020      * @return bool whether the call correctly returned the expected magic value
1021      */
1022     function _checkOnERC721Received(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) private returns (bool) {
1028         if (to.isContract()) {
1029             try
1030                 IERC721Receiver(to).onERC721Received(
1031                     _msgSender(),
1032                     from,
1033                     tokenId,
1034                     _data
1035                 )
1036             returns (bytes4 retval) {
1037                 return retval == IERC721Receiver(to).onERC721Received.selector;
1038             } catch (bytes memory reason) {
1039                 if (reason.length == 0) {
1040                     revert(
1041                         "ERC721A: transfer to non ERC721Receiver implementer"
1042                     );
1043                 } else {
1044                     assembly {
1045                         revert(add(32, reason), mload(reason))
1046                     }
1047                 }
1048             }
1049         } else {
1050             return true;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1056      *
1057      * startTokenId - the first token id to be transferred
1058      * quantity - the amount to be transferred
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      */
1066     function _beforeTokenTransfers(
1067         address from,
1068         address to,
1069         uint256 startTokenId,
1070         uint256 quantity
1071     ) internal virtual {}
1072 
1073     /**
1074      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1075      * minting.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - when `from` and `to` are both non-zero.
1083      * - `from` and `to` are never both zero.
1084      */
1085     function _afterTokenTransfers(
1086         address from,
1087         address to,
1088         uint256 startTokenId,
1089         uint256 quantity
1090     ) internal virtual {}
1091 }
1092 
1093 contract CryptoHippos is ERC721A, Ownable {
1094     using Strings for uint256;
1095     using MerkleProof for bytes32;
1096 
1097     string public baseURI;
1098     uint256 public cost = 0.08 ether;
1099     uint256 public maxSupply = 10000;
1100     uint256 public maxMintAmount = 5;
1101     uint256 public nftPerAddressLimit = 5;
1102     uint256 public nftReserve = 175;
1103     uint256 public reservedCount = 0;
1104     bool public paused = false;
1105     bool public onlyWhitelisted = true;
1106     mapping(address => uint256) public addressMintedBalance;
1107     bytes32 public rootHash =
1108         0xd227ba3c0d84000375a7b712e9dedf829760728f7ac90f8056723cd6bb757257;
1109     address private Address1 = 0x64f38f0827866a9532032CF590D10931f1357e57;
1110     address private Address2 = 0x2Be08be360bd2ef8A7231F44997432D15F80c9b1;
1111     address private Address3 = 0xee8917D6Af70d4C5287162ec5014c79a68E554c3;
1112     address private Address4 = 0xC85bA6c679dA5d0f89E793Aa10938F6dE98e6Ef2;
1113     address private Address5 = 0xBbB589796d01EF05f24C49f57d53125d4382ab62;
1114 
1115     constructor() ERC721A("Crypto Hippos NFT", "HIPPO", maxMintAmount, maxSupply) {
1116         setBaseURI(
1117             "https://gateway.pinata.cloud/ipfs/QmbM5YQu4YGLsdXbV4eptzePaRxdTnCJPNjQUYQNEmQy2V/"
1118         );
1119     }
1120 
1121     // internal
1122     function _baseURI() internal view virtual override returns (string memory) {
1123         return baseURI;
1124     }
1125 
1126     // public
1127     function mint(uint256 _mintAmount) public payable {
1128         require(!paused, "the contract is paused");
1129         require(_mintAmount > 0, "need to mint at least 1 NFT");
1130         require(
1131             _mintAmount <= maxMintAmount,
1132             "You can only mint 5 per transaction"
1133         );
1134         require(totalSupply() + _mintAmount <= maxSupply, "All CryptoHippos have been minted");
1135 
1136         require(!onlyWhitelisted, "Not public sale");
1137 
1138         require(msg.value >= cost * _mintAmount, "insufficient funds");
1139 
1140         _safeMint(msg.sender, _mintAmount);
1141         addressMintedBalance[msg.sender] =
1142             addressMintedBalance[msg.sender] +
1143             _mintAmount;
1144     }
1145 
1146     function whiteListedMint(
1147         bytes32[] calldata _merkleProof,
1148         uint256 _mintAmount
1149     ) public payable {
1150         require(!paused);
1151         require(totalSupply() + _mintAmount <= maxSupply, "All CryptoHippos have been minted");
1152         require(
1153             MerkleProof.verify(_merkleProof, rootHash, keccak256(abi.encodePacked(msg.sender))),
1154             "You are not whitelisted."
1155         );
1156         require(_mintAmount > 0, "need to mint at least 1 NFT");
1157         require(onlyWhitelisted);
1158         require(
1159             addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit,
1160             "You can only mint up to 5 CryptoHippos during whitelist sale, wait for public sale to do more than 5."
1161         );
1162         require(msg.value >= cost * _mintAmount);
1163         _safeMint(msg.sender, _mintAmount);
1164         addressMintedBalance[msg.sender] =
1165             addressMintedBalance[msg.sender] +
1166             _mintAmount;
1167     }
1168 
1169     function walletOfOwner(address _owner)
1170         public
1171         view
1172         returns (uint256[] memory)
1173     {
1174         uint256 ownerTokenCount = balanceOf(_owner);
1175         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1176         for (uint256 i; i < ownerTokenCount; i++) {
1177             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1178         }
1179         return tokenIds;
1180     }
1181 
1182     function tokenURI(uint256 tokenId)
1183         public
1184         view
1185         virtual
1186         override
1187         returns (string memory)
1188     {
1189         require(
1190             _exists(tokenId),
1191             "ERC721Metadata: URI query for nonexistent token"
1192         );
1193 
1194         string memory currentBaseURI = _baseURI();
1195         return
1196             bytes(currentBaseURI).length > 0
1197                 ? string(
1198                     abi.encodePacked(
1199                         currentBaseURI,
1200                         tokenId.toString()
1201                     )
1202                 )
1203                 : "";
1204     }
1205 
1206     //only owner
1207 
1208     function mintForAddress(uint256 _mintAmount, address _receiver)
1209         external
1210         onlyOwner
1211     {
1212         require(_mintAmount > 0, "Must mint more than 0");
1213         require(_mintAmount <= maxMintAmount, "Max 5 NFTs per tx");
1214         require(reservedCount + _mintAmount < nftReserve, "Marketing reserve exhausted.");
1215         require(totalSupply() + _mintAmount <= maxSupply);
1216         _safeMint(_receiver, _mintAmount);
1217         reservedCount += _mintAmount;
1218     }
1219 
1220     function setRootHash(bytes32 _rootHash) public onlyOwner {
1221         rootHash = _rootHash;
1222     }
1223 
1224     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1225         nftPerAddressLimit = _limit;
1226     }
1227 
1228     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1229         maxMintAmount = _newmaxMintAmount;
1230     }
1231 
1232     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1233         baseURI = _newBaseURI;
1234     }
1235 
1236     function pause(bool _state) public onlyOwner {
1237         paused = _state;
1238     }
1239 
1240     function setOnlyWhitelisted(bool _state) public onlyOwner {
1241         onlyWhitelisted = _state;
1242     }
1243 
1244     function withdraw() public onlyOwner {
1245         uint256 balance = address(this).balance;
1246         uint256 balance4 = (balance * 3800) / 10000;
1247         uint256 balance3 = (balance * 500) / 10000;
1248         uint256 balance2 = (balance * 450) / 10000;
1249         uint256 balance1 = (balance * 300) / 10000;
1250 
1251         payable(Address1).transfer(balance1);
1252 
1253         payable(Address2).transfer(balance2);
1254 
1255         payable(Address3).transfer(balance3);
1256 
1257         payable(Address4).transfer(balance4);
1258         uint256 balance5 = balance - (balance1 + balance2 + balance3 + balance4);
1259         payable(Address5).transfer(balance5);
1260     }
1261 }