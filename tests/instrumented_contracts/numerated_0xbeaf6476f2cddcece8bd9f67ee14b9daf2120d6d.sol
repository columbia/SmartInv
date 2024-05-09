1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.3;
4 
5 abstract contract ReentrancyGuard {
6     // Booleans are more expensive than uint256 or any type that takes up a full
7     // word because each write operation emits an extra SLOAD to first read the
8     // slot's contents, replace the bits taken up by the boolean, and then write
9     // back. This is the compiler's defense against contract upgrades and
10     // pointer aliasing, and it cannot be disabled.
11 
12     // The values being non-zero value makes deployment a bit more expensive,
13     // but in exchange the refund on every call to nonReentrant will be lower in
14     // amount. Since refunds are capped to a percentage of the total
15     // transaction's gas, it is best to keep them low in cases like this one, to
16     // increase the likelihood of the full refund coming into effect.
17     uint256 private constant _NOT_ENTERED = 1;
18     uint256 private constant _ENTERED = 2;
19 
20     uint256 private _status;
21 
22     constructor() {
23         _status = _NOT_ENTERED;
24     }
25 
26     /**
27      * @dev Prevents a contract from calling itself, directly or indirectly.
28      * Calling a `nonReentrant` function from another `nonReentrant`
29      * function is not supported. It is possible to prevent this from happening
30      * by making the `nonReentrant` function external, and making it call a
31      * `private` function that does the actual work.
32      */
33     modifier nonReentrant() {
34         // On the first call to nonReentrant, _notEntered will be true
35         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
36 
37         // Any calls to nonReentrant after this point will fail
38         _status = _ENTERED;
39 
40         _;
41 
42         // By storing the original value once again, a refund is triggered (see
43         // https://eips.ethereum.org/EIPS/eip-2200)
44         _status = _NOT_ENTERED;
45     }
46 }
47 
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
53      */
54     function toString(uint256 value) internal pure returns (string memory) {
55         // Inspired by OraclizeAPI's implementation - MIT licence
56         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
57 
58         if (value == 0) {
59             return "0";
60         }
61         uint256 temp = value;
62         uint256 digits;
63         while (temp != 0) {
64             digits++;
65             temp /= 10;
66         }
67         bytes memory buffer = new bytes(digits);
68         while (value != 0) {
69             digits -= 1;
70             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
71             value /= 10;
72         }
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
78      */
79     function toHexString(uint256 value) internal pure returns (string memory) {
80         if (value == 0) {
81             return "0x00";
82         }
83         uint256 temp = value;
84         uint256 length = 0;
85         while (temp != 0) {
86             length++;
87             temp >>= 8;
88         }
89         return toHexString(value, length);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
94      */
95     function toHexString(uint256 value, uint256 length)
96         internal
97         pure
98         returns (string memory)
99     {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 library Address {
113     function isContract(address account) internal view returns (bool) {
114         uint256 size;
115         assembly {
116             size := extcodesize(account)
117         }
118         return size > 0;
119     }
120 
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(
123             address(this).balance >= amount,
124             "Address: insufficient balance"
125         );
126 
127         (bool success, ) = recipient.call{value: amount}("");
128         require(
129             success,
130             "Address: unable to send value, recipient may have reverted"
131         );
132     }
133 
134     function functionCall(address target, bytes memory data)
135         internal
136         returns (bytes memory)
137     {
138         return functionCall(target, data, "Address: low-level call failed");
139     }
140 
141     function functionCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return
155             functionCallWithValue(
156                 target,
157                 data,
158                 value,
159                 "Address: low-level call with value failed"
160             );
161     }
162 
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(
170             address(this).balance >= value,
171             "Address: insufficient balance for call"
172         );
173         require(isContract(target), "Address: call to non-contract");
174 
175         (bool success, bytes memory returndata) = target.call{value: value}(
176             data
177         );
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180 
181     function functionStaticCall(address target, bytes memory data)
182         internal
183         view
184         returns (bytes memory)
185     {
186         return
187             functionStaticCall(
188                 target,
189                 data,
190                 "Address: low-level static call failed"
191             );
192     }
193 
194     function functionStaticCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal view returns (bytes memory) {
199         require(isContract(target), "Address: static call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function functionDelegateCall(address target, bytes memory data)
206         internal
207         returns (bytes memory)
208     {
209         return
210             functionDelegateCall(
211                 target,
212                 data,
213                 "Address: low-level delegate call failed"
214             );
215     }
216 
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     function verifyCallResult(
229         bool success,
230         bytes memory returndata,
231         string memory errorMessage
232     ) internal pure returns (bytes memory) {
233         if (success) {
234             return returndata;
235         } else {
236             // Look for revert reason and bubble it up if present
237             if (returndata.length > 0) {
238                 // The easiest way to bubble the revert reason is using memory via assembly
239 
240                 assembly {
241                     let returndata_size := mload(returndata)
242                     revert(add(32, returndata), returndata_size)
243                 }
244             } else {
245                 revert(errorMessage);
246             }
247         }
248     }
249 }
250 
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 abstract contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266     /**
267      * @dev Initializes the contract setting the deployer as the initial owner.
268      */
269     constructor() {
270         _transferOwnership(_msgSender());
271     }
272 
273     /**
274      * @dev Returns the address of the current owner.
275      */
276     function owner() public view virtual returns (address) {
277         return _owner;
278     }
279 
280     /**
281      * @dev Throws if called by any account other than the owner.
282      */
283     modifier onlyOwner() {
284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
285         _;
286     }
287 
288     /**
289      * @dev Leaves the contract without owner. It will not be possible to call
290      * `onlyOwner` functions anymore. Can only be called by the current owner.
291      *
292      * NOTE: Renouncing ownership will leave the contract without an owner,
293      * thereby removing any functionality that is only available to the owner.
294      */
295     function renounceOwnership() public virtual onlyOwner {
296         _transferOwnership(address(0));
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Can only be called by the current owner.
302      */
303     function transferOwnership(address newOwner) public virtual onlyOwner {
304         require(newOwner != address(0), "Ownable: new owner is the zero address");
305         _transferOwnership(newOwner);
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Internal function without access restriction.
311      */
312     function _transferOwnership(address newOwner) internal virtual {
313         address oldOwner = _owner;
314         _owner = newOwner;
315         emit OwnershipTransferred(oldOwner, newOwner);
316     }
317 }
318 
319 interface IERC165 {
320     /**
321      * @dev Returns true if this contract implements the interface defined by
322      * `interfaceId`. See the corresponding
323      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
324      * to learn more about how these ids are created.
325      *
326      * This function call must use less than 30 000 gas.
327      */
328     function supportsInterface(bytes4 interfaceId) external view returns (bool);
329 }
330 
331 interface IERC721 is IERC165 {
332     /**
333      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
339      */
340     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
344      */
345     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
346 
347     /**
348      * @dev Returns the number of tokens in ``owner``'s account.
349      */
350     function balanceOf(address owner) external view returns (uint256 balance);
351 
352     /**
353      * @dev Returns the owner of the `tokenId` token.
354      *
355      * Requirements:
356      *
357      * - `tokenId` must exist.
358      */
359     function ownerOf(uint256 tokenId) external view returns (address owner);
360 
361     /**
362      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
363      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `tokenId` token must exist and be owned by `from`.
370      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
372      *
373      * Emits a {Transfer} event.
374      */
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external;
380 
381     /**
382      * @dev Transfers `tokenId` token from `from` to `to`.
383      *
384      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `tokenId` token must be owned by `from`.
391      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 tokenId
399     ) external;
400 
401     /**
402      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
403      * The approval is cleared when the token is transferred.
404      *
405      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
406      *
407      * Requirements:
408      *
409      * - The caller must own the token or be an approved operator.
410      * - `tokenId` must exist.
411      *
412      * Emits an {Approval} event.
413      */
414     function approve(address to, uint256 tokenId) external;
415 
416     /**
417      * @dev Returns the account approved for `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function getApproved(uint256 tokenId) external view returns (address operator);
424 
425     /**
426      * @dev Approve or remove `operator` as an operator for the caller.
427      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
428      *
429      * Requirements:
430      *
431      * - The `operator` cannot be the caller.
432      *
433      * Emits an {ApprovalForAll} event.
434      */
435     function setApprovalForAll(address operator, bool _approved) external;
436 
437     /**
438      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
439      *
440      * See {setApprovalForAll}
441      */
442     function isApprovedForAll(address owner, address operator) external view returns (bool);
443 
444     /**
445      * @dev Safely transfers `tokenId` token from `from` to `to`.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes calldata data
462     ) external;
463 }
464 
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
483 interface IERC721Metadata is IERC721 {
484     /**
485      * @dev Returns the token collection name.
486      */
487     function name() external view returns (string memory);
488 
489     /**
490      * @dev Returns the token collection symbol.
491      */
492     function symbol() external view returns (string memory);
493 
494     /**
495      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
496      */
497     function tokenURI(uint256 tokenId) external view returns (string memory);
498 }
499 
500 interface IERC721Enumerable is IERC721 {
501     /**
502      * @dev Returns the total amount of tokens stored by the contract.
503      */
504     function totalSupply() external view returns (uint256);
505 
506     /**
507      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
508      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
509      */
510     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
511 
512     /**
513      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
514      * Use along with {totalSupply} to enumerate all tokens.
515      */
516     function tokenByIndex(uint256 index) external view returns (uint256);
517 }
518 
519 abstract contract ERC165 is IERC165 {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         return interfaceId == type(IERC165).interfaceId;
525     }
526 }
527 
528 library MerkleProof {
529     /**
530      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
531      * defined by `root`. For this, a `proof` must be provided, containing
532      * sibling hashes on the branch from the leaf to the root of the tree. Each
533      * pair of leaves and each pair of pre-images are assumed to be sorted.
534      */
535     function verify(
536         bytes32[] memory proof,
537         bytes32 root,
538         bytes32 leaf
539     ) internal pure returns (bool) {
540         return processProof(proof, leaf) == root;
541     }
542 
543     /**
544      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
545      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
546      * hash matches the root of the tree. When processing the proof, the pairs
547      * of leafs & pre-images are assumed to be sorted.
548      *
549      * _Available since v4.4._
550      */
551     function processProof(bytes32[] memory proof, bytes32 leaf)
552         internal
553         pure
554         returns (bytes32)
555     {
556         bytes32 computedHash = leaf;
557         for (uint256 i = 0; i < proof.length; i++) {
558             bytes32 proofElement = proof[i];
559             if (computedHash <= proofElement) {
560                 // Hash(current computed hash + current element of the proof)
561                 computedHash = keccak256(
562                     abi.encodePacked(computedHash, proofElement)
563                 );
564             } else {
565                 // Hash(current element of the proof + current computed hash)
566                 computedHash = keccak256(
567                     abi.encodePacked(proofElement, computedHash)
568                 );
569             }
570         }
571         return computedHash;
572     }
573 }
574 
575 contract ERC721A is
576     Context,
577     ERC165,
578     IERC721,
579     IERC721Metadata,
580     IERC721Enumerable
581 {
582     using Address for address;
583     using Strings for uint256;
584 
585     struct TokenOwnership {
586         address addr;
587         uint64 startTimestamp;
588     }
589 
590     struct AddressData {
591         uint128 balance;
592         uint128 numberMinted;
593     }
594 
595     uint256 private currentIndex = 0;
596 
597     uint256 internal immutable collectionSize;
598     uint256 internal immutable maxBatchSize;
599 
600     // Token name
601     string private _name;
602 
603     // Token symbol
604     string private _symbol;
605 
606     // Mapping from token ID to ownership details
607     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
608     mapping(uint256 => TokenOwnership) private _ownerships;
609 
610     // Mapping owner address to address data
611     mapping(address => AddressData) private _addressData;
612 
613     // Mapping from token ID to approved address
614     mapping(uint256 => address) private _tokenApprovals;
615 
616     // Mapping from owner to operator approvals
617     mapping(address => mapping(address => bool)) private _operatorApprovals;
618 
619     /**
620      * @dev
621      * `maxBatchSize` refers to how much a minter can mint at a time.
622      * `collectionSize_` refers to how many tokens are in the collection.
623      */
624     constructor(
625         string memory name_,
626         string memory symbol_,
627         uint256 maxBatchSize_,
628         uint256 collectionSize_
629     ) {
630         require(
631             collectionSize_ > 0,
632             "ERC721A: collection must have a nonzero supply"
633         );
634         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
635         _name = name_;
636         _symbol = symbol_;
637         maxBatchSize = maxBatchSize_;
638         collectionSize = collectionSize_;
639     }
640 
641     /**
642      * @dev See {IERC721Enumerable-totalSupply}.
643      */
644     function totalSupply() public view override returns (uint256) {
645         return currentIndex;
646     }
647 
648     /**
649      * @dev See {IERC721Enumerable-tokenByIndex}.
650      */
651     function tokenByIndex(uint256 index)
652         public
653         view
654         override
655         returns (uint256)
656     {
657         require(index < totalSupply(), "ERC721A: global index out of bounds");
658         return index;
659     }
660 
661     /**
662      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
663      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
664      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
665      */
666     function tokenOfOwnerByIndex(address owner, uint256 index)
667         public
668         view
669         override
670         returns (uint256)
671     {
672         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
673         uint256 numMintedSoFar = totalSupply();
674         uint256 tokenIdsIdx = 0;
675         address currOwnershipAddr = address(0);
676         for (uint256 i = 0; i < numMintedSoFar; i++) {
677             TokenOwnership memory ownership = _ownerships[i];
678             if (ownership.addr != address(0)) {
679                 currOwnershipAddr = ownership.addr;
680             }
681             if (currOwnershipAddr == owner) {
682                 if (tokenIdsIdx == index) {
683                     return i;
684                 }
685                 tokenIdsIdx++;
686             }
687         }
688         revert("ERC721A: unable to get token of owner by index");
689     }
690 
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId)
695         public
696         view
697         virtual
698         override(ERC165, IERC165)
699         returns (bool)
700     {
701         return
702             interfaceId == type(IERC721).interfaceId ||
703             interfaceId == type(IERC721Metadata).interfaceId ||
704             interfaceId == type(IERC721Enumerable).interfaceId ||
705             super.supportsInterface(interfaceId);
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner) public view override returns (uint256) {
712         require(
713             owner != address(0),
714             "ERC721A: balance query for the zero address"
715         );
716         return uint256(_addressData[owner].balance);
717     }
718 
719     function _numberMinted(address owner) internal view returns (uint256) {
720         require(
721             owner != address(0),
722             "ERC721A: number minted query for the zero address"
723         );
724         return uint256(_addressData[owner].numberMinted);
725     }
726 
727     function ownershipOf(uint256 tokenId)
728         internal
729         view
730         returns (TokenOwnership memory)
731     {
732         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
733 
734         uint256 lowestTokenToCheck;
735         if (tokenId >= maxBatchSize) {
736             lowestTokenToCheck = tokenId - maxBatchSize + 1;
737         }
738 
739         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
740             TokenOwnership memory ownership = _ownerships[curr];
741             if (ownership.addr != address(0)) {
742                 return ownership;
743             }
744         }
745 
746         revert("ERC721A: unable to determine the owner of token");
747     }
748 
749     /**
750      * @dev See {IERC721-ownerOf}.
751      */
752     function ownerOf(uint256 tokenId) public view override returns (address) {
753         return ownershipOf(tokenId).addr;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-name}.
758      */
759     function name() public view virtual override returns (string memory) {
760         return _name;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-symbol}.
765      */
766     function symbol() public view virtual override returns (string memory) {
767         return _symbol;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-tokenURI}.
772      */
773     function tokenURI(uint256 tokenId)
774         public
775         view
776         virtual
777         override
778         returns (string memory)
779     {
780         require(
781             _exists(tokenId),
782             "ERC721Metadata: URI query for nonexistent token"
783         );
784 
785         string memory baseURI = _baseURI();
786         return
787             bytes(baseURI).length > 0
788                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
789                 : "";
790     }
791 
792     /**
793      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
794      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
795      * by default, can be overriden in child contracts.
796      */
797     function _baseURI() internal view virtual returns (string memory) {
798         return "";
799     }
800 
801     /**
802      * @dev See {IERC721-approve}.
803      */
804     function approve(address to, uint256 tokenId) public override {
805         address owner = ERC721A.ownerOf(tokenId);
806         require(to != owner, "ERC721A: approval to current owner");
807 
808         require(
809             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
810             "ERC721A: approve caller is not owner nor approved for all"
811         );
812 
813         _approve(to, tokenId, owner);
814     }
815 
816     /**
817      * @dev See {IERC721-getApproved}.
818      */
819     function getApproved(uint256 tokenId)
820         public
821         view
822         override
823         returns (address)
824     {
825         require(
826             _exists(tokenId),
827             "ERC721A: approved query for nonexistent token"
828         );
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved)
837         public
838         override
839     {
840         require(operator != _msgSender(), "ERC721A: approve to caller");
841 
842         _operatorApprovals[_msgSender()][operator] = approved;
843         emit ApprovalForAll(_msgSender(), operator, approved);
844     }
845 
846     /**
847      * @dev See {IERC721-isApprovedForAll}.
848      */
849     function isApprovedForAll(address owner, address operator)
850         public
851         view
852         virtual
853         override
854         returns (bool)
855     {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev See {IERC721-transferFrom}.
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public override {
867         _transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public override {
878         safeTransferFrom(from, to, tokenId, "");
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public override {
890         _transfer(from, to, tokenId);
891         require(
892             _checkOnERC721Received(from, to, tokenId, _data),
893             "ERC721A: transfer to non ERC721Receiver implementer"
894         );
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      */
904     function _exists(uint256 tokenId) internal view returns (bool) {
905         return tokenId < currentIndex;
906     }
907 
908     function _safeMint(address to, uint256 quantity) internal {
909         _safeMint(to, quantity, "");
910     }
911 
912     /**
913      * @dev Mints `quantity` tokens and transfers them to `to`.
914      *
915      * Requirements:
916      *
917      * - there must be `quantity` tokens remaining unminted in the total collection.
918      * - `to` cannot be the zero address.
919      * - `quantity` cannot be larger than the max batch size.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeMint(
924         address to,
925         uint256 quantity,
926         bytes memory _data
927     ) internal {
928         uint256 startTokenId = currentIndex;
929         require(to != address(0), "ERC721A: mint to the zero address");
930         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
931         require(!_exists(startTokenId), "ERC721A: token already minted");
932         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
933 
934         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
935 
936         AddressData memory addressData = _addressData[to];
937         _addressData[to] = AddressData(
938             addressData.balance + uint128(quantity),
939             addressData.numberMinted + uint128(quantity)
940         );
941         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
942 
943         uint256 updatedIndex = startTokenId;
944 
945         for (uint256 i = 0; i < quantity; i++) {
946             emit Transfer(address(0), to, updatedIndex);
947             require(
948                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
949                 "ERC721A: transfer to non ERC721Receiver implementer"
950             );
951             updatedIndex++;
952         }
953 
954         currentIndex = updatedIndex;
955         _afterTokenTransfers(address(0), to, startTokenId, quantity);
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _transfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) private {
973         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
974 
975         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
976             getApproved(tokenId) == _msgSender() ||
977             isApprovedForAll(prevOwnership.addr, _msgSender()));
978 
979         require(
980             isApprovedOrOwner,
981             "ERC721A: transfer caller is not owner nor approved"
982         );
983 
984         require(
985             prevOwnership.addr == from,
986             "ERC721A: transfer from incorrect owner"
987         );
988         require(to != address(0), "ERC721A: transfer to the zero address");
989 
990         _beforeTokenTransfers(from, to, tokenId, 1);
991 
992         // Clear approvals from the previous owner
993         _approve(address(0), tokenId, prevOwnership.addr);
994 
995         _addressData[from].balance -= 1;
996         _addressData[to].balance += 1;
997         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
998 
999         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1000         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1001         uint256 nextTokenId = tokenId + 1;
1002         if (_ownerships[nextTokenId].addr == address(0)) {
1003             if (_exists(nextTokenId)) {
1004                 _ownerships[nextTokenId] = TokenOwnership(
1005                     prevOwnership.addr,
1006                     prevOwnership.startTimestamp
1007                 );
1008             }
1009         }
1010 
1011         emit Transfer(from, to, tokenId);
1012         _afterTokenTransfers(from, to, tokenId, 1);
1013     }
1014 
1015     /**
1016      * @dev Approve `to` to operate on `tokenId`
1017      *
1018      * Emits a {Approval} event.
1019      */
1020     function _approve(
1021         address to,
1022         uint256 tokenId,
1023         address owner
1024     ) private {
1025         _tokenApprovals[tokenId] = to;
1026         emit Approval(owner, to, tokenId);
1027     }
1028 
1029     uint256 public nextOwnerToExplicitlySet = 0;
1030 
1031     /**
1032      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1033      */
1034     function _setOwnersExplicit(uint256 quantity) internal {
1035         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1036         require(quantity > 0, "quantity must be nonzero");
1037         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1038         if (endIndex > collectionSize - 1) {
1039             endIndex = collectionSize - 1;
1040         }
1041         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1042         require(_exists(endIndex), "not enough minted yet for this cleanup");
1043         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1044             if (_ownerships[i].addr == address(0)) {
1045                 TokenOwnership memory ownership = ownershipOf(i);
1046                 _ownerships[i] = TokenOwnership(
1047                     ownership.addr,
1048                     ownership.startTimestamp
1049                 );
1050             }
1051         }
1052         nextOwnerToExplicitlySet = endIndex + 1;
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         if (to.isContract()) {
1072             try
1073                 IERC721Receiver(to).onERC721Received(
1074                     _msgSender(),
1075                     from,
1076                     tokenId,
1077                     _data
1078                 )
1079             returns (bytes4 retval) {
1080                 return retval == IERC721Receiver(to).onERC721Received.selector;
1081             } catch (bytes memory reason) {
1082                 if (reason.length == 0) {
1083                     revert(
1084                         "ERC721A: transfer to non ERC721Receiver implementer"
1085                     );
1086                 } else {
1087                     assembly {
1088                         revert(add(32, reason), mload(reason))
1089                     }
1090                 }
1091             }
1092         } else {
1093             return true;
1094         }
1095     }
1096 
1097     /**
1098      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1099      *
1100      * startTokenId - the first token id to be transferred
1101      * quantity - the amount to be transferred
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      */
1109     function _beforeTokenTransfers(
1110         address from,
1111         address to,
1112         uint256 startTokenId,
1113         uint256 quantity
1114     ) internal virtual {}
1115 
1116     /**
1117      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1118      * minting.
1119      *
1120      * startTokenId - the first token id to be transferred
1121      * quantity - the amount to be transferred
1122      *
1123      * Calling conditions:
1124      *
1125      * - when `from` and `to` are both non-zero.
1126      * - `from` and `to` are never both zero.
1127      */
1128     function _afterTokenTransfers(
1129         address from,
1130         address to,
1131         uint256 startTokenId,
1132         uint256 quantity
1133     ) internal virtual {}
1134 }
1135 
1136 contract NFTPD is ERC721A, Ownable, ReentrancyGuard {
1137     using Strings for uint256;
1138     using MerkleProof for bytes32;
1139 
1140     string public baseURI;
1141     uint256 public mintPrice = 0.025 ether;
1142     uint256 public wlPrice = 0.019 ether;
1143     uint256 public maxPerTransaction = 10;
1144     uint256 public maxPerWallet = 100;
1145     uint256 public maxTotalSupply = 3333;
1146     bool public isPublicLive = false;
1147     bool public isWhitelistLive = false;
1148     bytes32 public merkleTreeRoot;
1149     mapping(address => uint256) public whitelistMintsPerWallet;    
1150     mapping(address => uint256) public mintsPerWallet;
1151 
1152     address private Address1 = 0x27264A9F498933AA2495eBa96B2929B4c208c2eB;
1153     address private Address2 = 0x078116d7a4A77187E5312e7114C6945440A9b0c6;
1154     address private Address3 = 0x27d0E073Fc1f62B8856De351df7EEF497C4F1bab;
1155     address private Address4 = 0x31b7Fc64B3c9c3AA9142069d9aF7bC6DadCD5C6a;
1156     address private Address5 = 0x363513A0E2d9800902F16ae1cAA1314822AA21f9;
1157 
1158     constructor() ERC721A("nftpd", "NFTPD", maxPerTransaction, maxTotalSupply) {}
1159 
1160     function mintPublic(uint256 _amount) external payable nonReentrant {
1161         require(isPublicLive, "Sale not live");
1162         require(mintsPerWallet[_msgSender()] + _amount <= maxPerWallet, "Max per wallet reached");
1163         require(_amount > 0, "You must mint at least one");
1164         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1165         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1166         require(mintPrice * _amount <= msg.value, "Not enough ETH sent for selected amount");
1167 
1168         mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _amount;
1169 
1170         _safeMint(_msgSender(), _amount);
1171     }
1172 
1173     function mintWhitelist(uint256 _amount) external nonReentrant {
1174         require(mintsPerWallet[_msgSender()] + _amount <= maxPerWallet, "Max per wallet reached");
1175         require(isWhitelistLive, "Whitelist sale not live");
1176         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1177         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1178 
1179         mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _amount;
1180 
1181         _safeMint(_msgSender(), _amount);
1182     }
1183 
1184     function mintPrivate(address _receiver, uint256 _amount) external onlyOwner {
1185         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1186         _safeMint(_receiver, _amount);
1187     }
1188 
1189     function flipPublicSaleState() external onlyOwner {
1190         isPublicLive = !isPublicLive;
1191     }
1192 
1193     function flipWhitelistSaleState() external onlyOwner {
1194         isWhitelistLive = !isWhitelistLive;
1195     }
1196 
1197     function _baseURI() internal view virtual override returns (string memory) {
1198         return baseURI;
1199     }
1200 
1201     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1202         mintPrice = _mintPrice;
1203     }
1204 
1205     function setMaxTotalSupply(uint256 _maxTotalSupply) external onlyOwner {
1206         maxTotalSupply = _maxTotalSupply;
1207     }
1208 
1209     function setMaxPerTransaction(uint256 _maxPerTransaction) external onlyOwner {
1210         maxPerTransaction = _maxPerTransaction;
1211     }
1212 
1213     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1214         maxPerWallet = _maxPerWallet;
1215     }
1216 
1217     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1218         baseURI = _newBaseURI;
1219     }
1220 
1221     function setMerkleTreeRoot(bytes32 _merkleTreeRoot) external onlyOwner {
1222         merkleTreeRoot = _merkleTreeRoot;
1223     }
1224 
1225     function withdraw() public onlyOwner {
1226         uint256 balance = address(this).balance;
1227         uint256 balance4 = (balance * 3651) / 10000;
1228         uint256 balance3 = (balance * 794) / 10000;
1229         uint256 balance2 = (balance * 794) / 10000;
1230         uint256 balance1 = (balance * 794) / 10000;
1231 
1232         payable(Address1).transfer(balance1);
1233 
1234         payable(Address2).transfer(balance2);
1235 
1236         payable(Address3).transfer(balance3);
1237 
1238         payable(Address4).transfer(balance4);
1239 
1240         uint256 balance5 = balance - (balance1 + balance2 + balance3 + balance4);
1241         payable(Address5).transfer(balance5);
1242     }
1243 }