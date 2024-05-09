1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.3;
4 
5 
6 
7 // Part: Address
8 
9 library Address {
10     function isContract(address account) internal view returns (bool) {
11         uint256 size;
12         assembly {
13             size := extcodesize(account)
14         }
15         return size > 0;
16     }
17 
18     function sendValue(address payable recipient, uint256 amount) internal {
19         require(
20             address(this).balance >= amount,
21             "Address: insufficient balance"
22         );
23 
24         (bool success, ) = recipient.call{value: amount}("");
25         require(
26             success,
27             "Address: unable to send value, recipient may have reverted"
28         );
29     }
30 
31     function functionCall(address target, bytes memory data)
32         internal
33         returns (bytes memory)
34     {
35         return functionCall(target, data, "Address: low-level call failed");
36     }
37 
38     function functionCall(
39         address target,
40         bytes memory data,
41         string memory errorMessage
42     ) internal returns (bytes memory) {
43         return functionCallWithValue(target, data, 0, errorMessage);
44     }
45 
46     function functionCallWithValue(
47         address target,
48         bytes memory data,
49         uint256 value
50     ) internal returns (bytes memory) {
51         return
52             functionCallWithValue(
53                 target,
54                 data,
55                 value,
56                 "Address: low-level call with value failed"
57             );
58     }
59 
60     function functionCallWithValue(
61         address target,
62         bytes memory data,
63         uint256 value,
64         string memory errorMessage
65     ) internal returns (bytes memory) {
66         require(
67             address(this).balance >= value,
68             "Address: insufficient balance for call"
69         );
70         require(isContract(target), "Address: call to non-contract");
71 
72         (bool success, bytes memory returndata) = target.call{value: value}(
73             data
74         );
75         return verifyCallResult(success, returndata, errorMessage);
76     }
77 
78     function functionStaticCall(address target, bytes memory data)
79         internal
80         view
81         returns (bytes memory)
82     {
83         return
84             functionStaticCall(
85                 target,
86                 data,
87                 "Address: low-level static call failed"
88             );
89     }
90 
91     function functionStaticCall(
92         address target,
93         bytes memory data,
94         string memory errorMessage
95     ) internal view returns (bytes memory) {
96         require(isContract(target), "Address: static call to non-contract");
97 
98         (bool success, bytes memory returndata) = target.staticcall(data);
99         return verifyCallResult(success, returndata, errorMessage);
100     }
101 
102     function functionDelegateCall(address target, bytes memory data)
103         internal
104         returns (bytes memory)
105     {
106         return
107             functionDelegateCall(
108                 target,
109                 data,
110                 "Address: low-level delegate call failed"
111             );
112     }
113 
114     function functionDelegateCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         require(isContract(target), "Address: delegate call to non-contract");
120 
121         (bool success, bytes memory returndata) = target.delegatecall(data);
122         return verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     function verifyCallResult(
126         bool success,
127         bytes memory returndata,
128         string memory errorMessage
129     ) internal pure returns (bytes memory) {
130         if (success) {
131             return returndata;
132         } else {
133             // Look for revert reason and bubble it up if present
134             if (returndata.length > 0) {
135                 // The easiest way to bubble the revert reason is using memory via assembly
136 
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 // Part: Context
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 // Part: IERC165
171 
172 /**
173  * @dev Interface of the ERC165 standard, as defined in the
174  * https://eips.ethereum.org/EIPS/eip-165[EIP].
175  *
176  * Implementers can declare support of contract interfaces, which can then be
177  * queried by others ({ERC165Checker}).
178  *
179  * For an implementation, see {ERC165}.
180  */
181 interface IERC165 {
182     /**
183      * @dev Returns true if this contract implements the interface defined by
184      * `interfaceId`. See the corresponding
185      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
186      * to learn more about how these ids are created.
187      *
188      * This function call must use less than 30 000 gas.
189      */
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 }
192 
193 // Part: IERC721Receiver
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
209      */
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 // Part: Strings
219 
220 /**
221  * @dev String operations.
222  */
223 library Strings {
224     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
228      */
229     function toString(uint256 value) internal pure returns (string memory) {
230         // Inspired by OraclizeAPI's implementation - MIT licence
231         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
232 
233         if (value == 0) {
234             return "0";
235         }
236         uint256 temp = value;
237         uint256 digits;
238         while (temp != 0) {
239             digits++;
240             temp /= 10;
241         }
242         bytes memory buffer = new bytes(digits);
243         while (value != 0) {
244             digits -= 1;
245             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
246             value /= 10;
247         }
248         return string(buffer);
249     }
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
253      */
254     function toHexString(uint256 value) internal pure returns (string memory) {
255         if (value == 0) {
256             return "0x00";
257         }
258         uint256 temp = value;
259         uint256 length = 0;
260         while (temp != 0) {
261             length++;
262             temp >>= 8;
263         }
264         return toHexString(value, length);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
269      */
270     function toHexString(uint256 value, uint256 length)
271         internal
272         pure
273         returns (string memory)
274     {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 }
286 
287 // Part: ERC165
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
293  * for the additional interface id that will be supported. For example:
294  *
295  * ```solidity
296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
298  * }
299  * ```
300  *
301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
302  */
303 abstract contract ERC165 is IERC165 {
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      */
307     function supportsInterface(bytes4 interfaceId)
308         public
309         view
310         virtual
311         override
312         returns (bool)
313     {
314         return interfaceId == type(IERC165).interfaceId;
315     }
316 }
317 
318 // Part: IERC721
319 
320 /**
321  * @dev Required interface of an ERC721 compliant contract.
322  */
323 interface IERC721 is IERC165 {
324     /**
325      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
326      */
327     event Transfer(
328         address indexed from,
329         address indexed to,
330         uint256 indexed tokenId
331     );
332 
333     /**
334      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
335      */
336     event Approval(
337         address indexed owner,
338         address indexed approved,
339         uint256 indexed tokenId
340     );
341 
342     /**
343      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
344      */
345     event ApprovalForAll(
346         address indexed owner,
347         address indexed operator,
348         bool approved
349     );
350 
351     /**
352      * @dev Returns the number of tokens in ``owner``'s account.
353      */
354     function balanceOf(address owner) external view returns (uint256 balance);
355 
356     /**
357      * @dev Returns the owner of the `tokenId` token.
358      *
359      * Requirements:
360      *
361      * - `tokenId` must exist.
362      */
363     function ownerOf(uint256 tokenId) external view returns (address owner);
364 
365     /**
366      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
367      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `tokenId` token must exist and be owned by `from`.
374      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
375      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
376      *
377      * Emits a {Transfer} event.
378      */
379     function safeTransferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external;
384 
385     /**
386      * @dev Transfers `tokenId` token from `from` to `to`.
387      *
388      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must be owned by `from`.
395      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
396      *
397      * Emits a {Transfer} event.
398      */
399     function transferFrom(
400         address from,
401         address to,
402         uint256 tokenId
403     ) external;
404 
405     /**
406      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
407      * The approval is cleared when the token is transferred.
408      *
409      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
410      *
411      * Requirements:
412      *
413      * - The caller must own the token or be an approved operator.
414      * - `tokenId` must exist.
415      *
416      * Emits an {Approval} event.
417      */
418     function approve(address to, uint256 tokenId) external;
419 
420     /**
421      * @dev Returns the account approved for `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function getApproved(uint256 tokenId)
428         external
429         view
430         returns (address operator);
431 
432     /**
433      * @dev Approve or remove `operator` as an operator for the caller.
434      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
435      *
436      * Requirements:
437      *
438      * - The `operator` cannot be the caller.
439      *
440      * Emits an {ApprovalForAll} event.
441      */
442     function setApprovalForAll(address operator, bool _approved) external;
443 
444     /**
445      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
446      *
447      * See {setApprovalForAll}
448      */
449     function isApprovedForAll(address owner, address operator)
450         external
451         view
452         returns (bool);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 }
474 
475 // Part: Ownable
476 
477 /**
478  * @dev Contract module which provides a basic access control mechanism, where
479  * there is an account (an owner) that can be granted exclusive access to
480  * specific functions.
481  *
482  * By default, the owner account will be the one that deploys the contract. This
483  * can later be changed with {transferOwnership}.
484  *
485  * This module is used through inheritance. It will make available the modifier
486  * `onlyOwner`, which can be applied to your functions to restrict their use to
487  * the owner.
488  */
489 abstract contract Ownable is Context {
490     address private _owner;
491 
492     event OwnershipTransferred(
493         address indexed previousOwner,
494         address indexed newOwner
495     );
496 
497     /**
498      * @dev Initializes the contract setting the deployer as the initial owner.
499      */
500     constructor() {
501         _transferOwnership(_msgSender());
502     }
503 
504     /**
505      * @dev Returns the address of the current owner.
506      */
507     function owner() public view virtual returns (address) {
508         return _owner;
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         require(owner() == _msgSender(), "Ownable: caller is not the owner");
516         _;
517     }
518 
519     /**
520      * @dev Leaves the contract without owner. It will not be possible to call
521      * `onlyOwner` functions anymore. Can only be called by the current owner.
522      *
523      * NOTE: Renouncing ownership will leave the contract without an owner,
524      * thereby removing any functionality that is only available to the owner.
525      */
526     function renounceOwnership() public virtual onlyOwner {
527         _transferOwnership(address(0));
528     }
529 
530     /**
531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
532      * Can only be called by the current owner.
533      */
534     function transferOwnership(address newOwner) public virtual onlyOwner {
535         require(
536             newOwner != address(0),
537             "Ownable: new owner is the zero address"
538         );
539         _transferOwnership(newOwner);
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Internal function without access restriction.
545      */
546     function _transferOwnership(address newOwner) internal virtual {
547         address oldOwner = _owner;
548         _owner = newOwner;
549         emit OwnershipTransferred(oldOwner, newOwner);
550     }
551 }
552 
553 // Part: IERC721Enumerable
554 
555 /**
556  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
557  * @dev See https://eips.ethereum.org/EIPS/eip-721
558  */
559 interface IERC721Enumerable is IERC721 {
560     /**
561      * @dev Returns the total amount of tokens stored by the contract.
562      */
563     function totalSupply() external view returns (uint256);
564 
565     /**
566      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
567      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
568      */
569     function tokenOfOwnerByIndex(address owner, uint256 index)
570         external
571         view
572         returns (uint256 tokenId);
573 
574     /**
575      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
576      * Use along with {totalSupply} to enumerate all tokens.
577      */
578     function tokenByIndex(uint256 index) external view returns (uint256);
579 }
580 
581 // Part: IERC721Metadata
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 
604 // Part: ERC721A
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
611  *
612  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
613  *
614  * Does not support burning tokens to address(0).
615  */
616 contract ERC721A is
617     Context,
618     ERC165,
619     IERC721,
620     IERC721Metadata,
621     IERC721Enumerable
622 {
623     using Address for address;
624     using Strings for uint256;
625 
626     struct TokenOwnership {
627         address addr;
628         uint64 startTimestamp;
629     }
630 
631     struct AddressData {
632         uint128 balance;
633         uint128 numberMinted;
634     }
635 
636     uint256 private currentIndex = 0;
637 
638     uint256 internal immutable collectionSize;
639     uint256 internal immutable maxBatchSize;
640 
641     // Token name
642     string private _name;
643 
644     // Token symbol
645     string private _symbol;
646 
647     // Mapping from token ID to ownership details
648     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
649     mapping(uint256 => TokenOwnership) private _ownerships;
650 
651     // Mapping owner address to address data
652     mapping(address => AddressData) private _addressData;
653 
654     // Mapping from token ID to approved address
655     mapping(uint256 => address) private _tokenApprovals;
656 
657     // Mapping from owner to operator approvals
658     mapping(address => mapping(address => bool)) private _operatorApprovals;
659 
660     /**
661      * @dev
662      * `maxBatchSize` refers to how much a minter can mint at a time.
663      * `collectionSize_` refers to how many tokens are in the collection.
664      */
665     constructor(
666         string memory name_,
667         string memory symbol_,
668         uint256 maxBatchSize_,
669         uint256 collectionSize_
670     ) {
671         require(
672             collectionSize_ > 0,
673             "ERC721A: collection must have a nonzero supply"
674         );
675         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
676         _name = name_;
677         _symbol = symbol_;
678         maxBatchSize = maxBatchSize_;
679         collectionSize = collectionSize_;
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-totalSupply}.
684      */
685     function totalSupply() public view override returns (uint256) {
686         return currentIndex;
687     }
688 
689     /**
690      * @dev See {IERC721Enumerable-tokenByIndex}.
691      */
692     function tokenByIndex(uint256 index)
693         public
694         view
695         override
696         returns (uint256)
697     {
698         require(index < totalSupply(), "ERC721A: global index out of bounds");
699         return index;
700     }
701 
702     /**
703      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
704      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
705      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
706      */
707     function tokenOfOwnerByIndex(address owner, uint256 index)
708         public
709         view
710         override
711         returns (uint256)
712     {
713         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
714         uint256 numMintedSoFar = totalSupply();
715         uint256 tokenIdsIdx = 0;
716         address currOwnershipAddr = address(0);
717         for (uint256 i = 0; i < numMintedSoFar; i++) {
718             TokenOwnership memory ownership = _ownerships[i];
719             if (ownership.addr != address(0)) {
720                 currOwnershipAddr = ownership.addr;
721             }
722             if (currOwnershipAddr == owner) {
723                 if (tokenIdsIdx == index) {
724                     return i;
725                 }
726                 tokenIdsIdx++;
727             }
728         }
729         revert("ERC721A: unable to get token of owner by index");
730     }
731 
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId)
736         public
737         view
738         virtual
739         override(ERC165, IERC165)
740         returns (bool)
741     {
742         return
743             interfaceId == type(IERC721).interfaceId ||
744             interfaceId == type(IERC721Metadata).interfaceId ||
745             interfaceId == type(IERC721Enumerable).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view override returns (uint256) {
753         require(
754             owner != address(0),
755             "ERC721A: balance query for the zero address"
756         );
757         return uint256(_addressData[owner].balance);
758     }
759 
760     function _numberMinted(address owner) internal view returns (uint256) {
761         require(
762             owner != address(0),
763             "ERC721A: number minted query for the zero address"
764         );
765         return uint256(_addressData[owner].numberMinted);
766     }
767 
768     function ownershipOf(uint256 tokenId)
769         internal
770         view
771         returns (TokenOwnership memory)
772     {
773         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
774 
775         uint256 lowestTokenToCheck;
776         if (tokenId >= maxBatchSize) {
777             lowestTokenToCheck = tokenId - maxBatchSize + 1;
778         }
779 
780         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
781             TokenOwnership memory ownership = _ownerships[curr];
782             if (ownership.addr != address(0)) {
783                 return ownership;
784             }
785         }
786 
787         revert("ERC721A: unable to determine the owner of token");
788     }
789 
790     /**
791      * @dev See {IERC721-ownerOf}.
792      */
793     function ownerOf(uint256 tokenId) public view override returns (address) {
794         return ownershipOf(tokenId).addr;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-name}.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-symbol}.
806      */
807     function symbol() public view virtual override returns (string memory) {
808         return _symbol;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId)
815         public
816         view
817         virtual
818         override
819         returns (string memory)
820     {
821         require(
822             _exists(tokenId),
823             "ERC721Metadata: URI query for nonexistent token"
824         );
825 
826         string memory baseURI = _baseURI();
827         return
828             bytes(baseURI).length > 0
829                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
830                 : "";
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overriden in child contracts.
837      */
838     function _baseURI() internal view virtual returns (string memory) {
839         return "";
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public override {
846         address owner = ERC721A.ownerOf(tokenId);
847         require(to != owner, "ERC721A: approval to current owner");
848 
849         require(
850             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
851             "ERC721A: approve caller is not owner nor approved for all"
852         );
853 
854         _approve(to, tokenId, owner);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId)
861         public
862         view
863         override
864         returns (address)
865     {
866         require(
867             _exists(tokenId),
868             "ERC721A: approved query for nonexistent token"
869         );
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved)
878         public
879         override
880     {
881         require(operator != _msgSender(), "ERC721A: approve to caller");
882 
883         _operatorApprovals[_msgSender()][operator] = approved;
884         emit ApprovalForAll(_msgSender(), operator, approved);
885     }
886 
887     /**
888      * @dev See {IERC721-isApprovedForAll}.
889      */
890     function isApprovedForAll(address owner, address operator)
891         public
892         view
893         virtual
894         override
895         returns (bool)
896     {
897         return _operatorApprovals[owner][operator];
898     }
899 
900     /**
901      * @dev See {IERC721-transferFrom}.
902      */
903     function transferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public override {
908         _transfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public override {
919         safeTransferFrom(from, to, tokenId, "");
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) public override {
931         _transfer(from, to, tokenId);
932         require(
933             _checkOnERC721Received(from, to, tokenId, _data),
934             "ERC721A: transfer to non ERC721Receiver implementer"
935         );
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      */
945     function _exists(uint256 tokenId) internal view returns (bool) {
946         return tokenId < currentIndex;
947     }
948 
949     function _safeMint(address to, uint256 quantity) internal {
950         _safeMint(to, quantity, "");
951     }
952 
953     /**
954      * @dev Mints `quantity` tokens and transfers them to `to`.
955      *
956      * Requirements:
957      *
958      * - there must be `quantity` tokens remaining unminted in the total collection.
959      * - `to` cannot be the zero address.
960      * - `quantity` cannot be larger than the max batch size.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(
965         address to,
966         uint256 quantity,
967         bytes memory _data
968     ) internal {
969         uint256 startTokenId = currentIndex;
970         require(to != address(0), "ERC721A: mint to the zero address");
971         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
972         require(!_exists(startTokenId), "ERC721A: token already minted");
973         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
974 
975         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
976 
977         AddressData memory addressData = _addressData[to];
978         _addressData[to] = AddressData(
979             addressData.balance + uint128(quantity),
980             addressData.numberMinted + uint128(quantity)
981         );
982         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
983 
984         uint256 updatedIndex = startTokenId;
985 
986         for (uint256 i = 0; i < quantity; i++) {
987             emit Transfer(address(0), to, updatedIndex);
988             require(
989                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
990                 "ERC721A: transfer to non ERC721Receiver implementer"
991             );
992             updatedIndex++;
993         }
994 
995         currentIndex = updatedIndex;
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) private {
1014         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1015 
1016         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1017             getApproved(tokenId) == _msgSender() ||
1018             isApprovedForAll(prevOwnership.addr, _msgSender()));
1019 
1020         require(
1021             isApprovedOrOwner,
1022             "ERC721A: transfer caller is not owner nor approved"
1023         );
1024 
1025         require(
1026             prevOwnership.addr == from,
1027             "ERC721A: transfer from incorrect owner"
1028         );
1029         require(to != address(0), "ERC721A: transfer to the zero address");
1030 
1031         _beforeTokenTransfers(from, to, tokenId, 1);
1032 
1033         // Clear approvals from the previous owner
1034         _approve(address(0), tokenId, prevOwnership.addr);
1035 
1036         _addressData[from].balance -= 1;
1037         _addressData[to].balance += 1;
1038         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1039 
1040         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1041         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1042         uint256 nextTokenId = tokenId + 1;
1043         if (_ownerships[nextTokenId].addr == address(0)) {
1044             if (_exists(nextTokenId)) {
1045                 _ownerships[nextTokenId] = TokenOwnership(
1046                     prevOwnership.addr,
1047                     prevOwnership.startTimestamp
1048                 );
1049             }
1050         }
1051 
1052         emit Transfer(from, to, tokenId);
1053         _afterTokenTransfers(from, to, tokenId, 1);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(
1062         address to,
1063         uint256 tokenId,
1064         address owner
1065     ) private {
1066         _tokenApprovals[tokenId] = to;
1067         emit Approval(owner, to, tokenId);
1068     }
1069 
1070     uint256 public nextOwnerToExplicitlySet = 0;
1071 
1072     /**
1073      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1074      */
1075     function _setOwnersExplicit(uint256 quantity) internal {
1076         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1077         require(quantity > 0, "quantity must be nonzero");
1078         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1079         if (endIndex > collectionSize - 1) {
1080             endIndex = collectionSize - 1;
1081         }
1082         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1083         require(_exists(endIndex), "not enough minted yet for this cleanup");
1084         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1085             if (_ownerships[i].addr == address(0)) {
1086                 TokenOwnership memory ownership = ownershipOf(i);
1087                 _ownerships[i] = TokenOwnership(
1088                     ownership.addr,
1089                     ownership.startTimestamp
1090                 );
1091             }
1092         }
1093         nextOwnerToExplicitlySet = endIndex + 1;
1094     }
1095 
1096     /**
1097      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1098      * The call is not executed if the target address is not a contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param _data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) private returns (bool) {
1112         if (to.isContract()) {
1113             try
1114                 IERC721Receiver(to).onERC721Received(
1115                     _msgSender(),
1116                     from,
1117                     tokenId,
1118                     _data
1119                 )
1120             returns (bytes4 retval) {
1121                 return retval == IERC721Receiver(to).onERC721Received.selector;
1122             } catch (bytes memory reason) {
1123                 if (reason.length == 0) {
1124                     revert(
1125                         "ERC721A: transfer to non ERC721Receiver implementer"
1126                     );
1127                 } else {
1128                     assembly {
1129                         revert(add(32, reason), mload(reason))
1130                     }
1131                 }
1132             }
1133         } else {
1134             return true;
1135         }
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1140      *
1141      * startTokenId - the first token id to be transferred
1142      * quantity - the amount to be transferred
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` will be minted for `to`.
1149      */
1150     function _beforeTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1159      * minting.
1160      *
1161      * startTokenId - the first token id to be transferred
1162      * quantity - the amount to be transferred
1163      *
1164      * Calling conditions:
1165      *
1166      * - when `from` and `to` are both non-zero.
1167      * - `from` and `to` are never both zero.
1168      */
1169     function _afterTokenTransfers(
1170         address from,
1171         address to,
1172         uint256 startTokenId,
1173         uint256 quantity
1174     ) internal virtual {}
1175 }
1176 
1177 // File: NFT.sol
1178 
1179 contract NFT is ERC721A, Ownable {
1180     using Strings for uint256;
1181 
1182     string public baseURI;
1183     string public baseExtension = ".json";
1184     string public notRevealedUri;
1185     uint256 public cost = 0.1 ether;
1186     uint256 public maxSupply = 300;
1187     uint256 public maxMintAmount = 10;
1188     uint256 public nftPerAddressLimit = 3;
1189     uint256 public nftClaimLimit = 1;
1190     bool public paused = false;
1191     bool public revealed = false;
1192     bool public onlyWhitelisted = true;
1193     mapping(address => bool) whitelistedAddresses;
1194     mapping(address => uint256) public addressMintedBalance;
1195     mapping(address => bool) public hasClaimed;
1196 
1197     constructor(
1198         string memory _name,
1199         string memory _symbol,
1200         string memory _initBaseURI,
1201         string memory _initNonRevealURI
1202     ) ERC721A(_name, _symbol, maxMintAmount, maxSupply) {
1203         setBaseURI(_initBaseURI);
1204         setNotRevealedURI(_initNonRevealURI);
1205     }
1206 
1207     function _baseURI() internal view virtual override returns (string memory) {
1208         return baseURI;
1209     }
1210 
1211     function mint(uint256 _mintAmount) public payable {
1212         require(!paused, "the contract is paused");
1213         uint256 supply = totalSupply();
1214         require(_mintAmount > 0, "need to mint at least 1 NFT");
1215         require(
1216             _mintAmount <= maxMintAmount,
1217             "max mint amount per session exceeded"
1218         );
1219         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1220 
1221         if (msg.sender != owner()) {
1222             if (onlyWhitelisted == true) {
1223                 require(
1224                     whitelistedAddresses[msg.sender],
1225                     "user is not whitelisted"
1226                 );
1227                 uint256 ownerMintedCountWL = addressMintedBalance[msg.sender];
1228                 require(
1229                     ownerMintedCountWL + _mintAmount <= nftPerAddressLimit,
1230                     "max NFT per address exceeded"
1231                 );
1232             }
1233             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1234             require(
1235                 ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1236                 "max NFT per address exceeded"
1237             );
1238             require(msg.value >= cost * _mintAmount, "insufficient funds");
1239         }
1240 
1241         _safeMint(msg.sender, _mintAmount);
1242         addressMintedBalance[msg.sender] =
1243             addressMintedBalance[msg.sender] +
1244             _mintAmount;
1245     }
1246 
1247     function claimFree() public {
1248         uint256 ownerBalance = addressMintedBalance[msg.sender];
1249         require(ownerBalance >= nftClaimLimit, "Must be minted 2");
1250         require(!hasClaimed[msg.sender]);
1251         _safeMint(msg.sender, 1);
1252         hasClaimed[msg.sender] = true;
1253     }
1254 
1255     function isWhitelisted(address _user) public view returns (bool) {
1256         return whitelistedAddresses[_user];
1257     }
1258 
1259     function walletOfOwner(address _owner)
1260         public
1261         view
1262         returns (uint256[] memory)
1263     {
1264         uint256 ownerTokenCount = balanceOf(_owner);
1265         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1266         for (uint256 i; i < ownerTokenCount; i++) {
1267             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1268         }
1269         return tokenIds;
1270     }
1271 
1272     function tokenURI(uint256 tokenId)
1273         public
1274         view
1275         virtual
1276         override
1277         returns (string memory)
1278     {
1279         require(
1280             _exists(tokenId),
1281             "ERC721Metadata: URI query for nonexistent token"
1282         );
1283 
1284         if (revealed == false) {
1285             return notRevealedUri;
1286         }
1287 
1288         string memory currentBaseURI = _baseURI();
1289         return
1290             bytes(currentBaseURI).length > 0
1291                 ? string(
1292                     abi.encodePacked(
1293                         currentBaseURI,
1294                         tokenId.toString(),
1295                         baseExtension
1296                     )
1297                 )
1298                 : "";
1299     }
1300 
1301     //only owner
1302     function reveal() public onlyOwner {
1303         revealed = true;
1304     }
1305 
1306     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1307         nftPerAddressLimit = _limit;
1308     }
1309 
1310     function setNftClaimLimit(uint256 _limit) public onlyOwner {
1311         nftClaimLimit = _limit;
1312     }
1313 
1314     function setCost(uint256 _newCost) public onlyOwner {
1315         cost = _newCost;
1316     }
1317 
1318     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1319         maxMintAmount = _newmaxMintAmount;
1320     }
1321 
1322     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1323         baseURI = _newBaseURI;
1324     }
1325 
1326     function setBaseExtension(string memory _newBaseExtension)
1327         public
1328         onlyOwner
1329     {
1330         baseExtension = _newBaseExtension;
1331     }
1332 
1333     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1334         notRevealedUri = _notRevealedURI;
1335     }
1336 
1337     function pause(bool _state) public onlyOwner {
1338         paused = _state;
1339     }
1340 
1341     function setOnlyWhitelisted(bool _state) public onlyOwner {
1342         onlyWhitelisted = _state;
1343     }
1344 
1345     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1346         maxSupply = _maxSupply;
1347     }
1348 
1349     function whitelistUsers(address[] memory addresses) public onlyOwner {
1350         for (uint256 i = 0; i < addresses.length; i++) {
1351             whitelistedAddresses[addresses[i]] = true;
1352         }
1353     }
1354 
1355     function withdraw() public payable onlyOwner {
1356         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1357         require(os);
1358     }
1359 }
