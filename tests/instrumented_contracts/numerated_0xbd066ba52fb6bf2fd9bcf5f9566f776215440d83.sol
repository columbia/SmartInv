1 // SPDX-License-Identifier: MIT
2 
3 //Developer Info:
4 //fiverr: fiverr.com/rizwanali792
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Interface of the ERC165 standard, as defined in the
216  * https://eips.ethereum.org/EIPS/eip-165[EIP].
217  *
218  * Implementers can declare support of contract interfaces, which can then be
219  * queried by others ({ERC165Checker}).
220  *
221  * For an implementation, see {ERC165}.
222  */
223 interface IERC165 {
224     /**
225      * @dev Returns true if this contract implements the interface defined by
226      * `interfaceId`. See the corresponding
227      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
228      * to learn more about how these ids are created.
229      *
230      * This function call must use less than 30 000 gas.
231      */
232     function supportsInterface(bytes4 interfaceId) external view returns (bool);
233 }
234 
235 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 
243 /**
244  * @dev Implementation of the {IERC165} interface.
245  *
246  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
247  * for the additional interface id that will be supported. For example:
248  *
249  * ```solidity
250  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
251  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
252  * }
253  * ```
254  *
255  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
256  */
257 abstract contract ERC165 is IERC165 {
258     /**
259      * @dev See {IERC165-supportsInterface}.
260      */
261     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
262         return interfaceId == type(IERC165).interfaceId;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Required interface of an ERC721 compliant contract.
276  */
277 interface IERC721 is IERC165 {
278     /**
279      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
282 
283     /**
284      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
285      */
286     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
287 
288     /**
289      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
290      */
291     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
292 
293     /**
294      * @dev Returns the number of tokens in ``owner``'s account.
295      */
296     function balanceOf(address owner) external view returns (uint256 balance);
297 
298     /**
299      * @dev Returns the owner of the `tokenId` token.
300      *
301      * Requirements:
302      *
303      * - `tokenId` must exist.
304      */
305     function ownerOf(uint256 tokenId) external view returns (address owner);
306 
307     /**
308      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
309      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
310      *
311      * Requirements:
312      *
313      * - `from` cannot be the zero address.
314      * - `to` cannot be the zero address.
315      * - `tokenId` token must exist and be owned by `from`.
316      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
317      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
318      *
319      * Emits a {Transfer} event.
320      */
321     function safeTransferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327     /**
328      * @dev Transfers `tokenId` token from `from` to `to`.
329      *
330      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must be owned by `from`.
337      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
338      *
339      * Emits a {Transfer} event.
340      */
341     function transferFrom(
342         address from,
343         address to,
344         uint256 tokenId
345     ) external;
346 
347     /**
348      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
349      * The approval is cleared when the token is transferred.
350      *
351      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
352      *
353      * Requirements:
354      *
355      * - The caller must own the token or be an approved operator.
356      * - `tokenId` must exist.
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address to, uint256 tokenId) external;
361 
362     /**
363      * @dev Returns the account approved for `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function getApproved(uint256 tokenId) external view returns (address operator);
370 
371     /**
372      * @dev Approve or remove `operator` as an operator for the caller.
373      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
374      *
375      * Requirements:
376      *
377      * - The `operator` cannot be the caller.
378      *
379      * Emits an {ApprovalForAll} event.
380      */
381     function setApprovalForAll(address operator, bool _approved) external;
382 
383     /**
384      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
385      *
386      * See {setApprovalForAll}
387      */
388     function isApprovedForAll(address owner, address operator) external view returns (bool);
389 
390     /**
391      * @dev Safely transfers `tokenId` token from `from` to `to`.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must exist and be owned by `from`.
398      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
400      *
401      * Emits a {Transfer} event.
402      */
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId,
407         bytes calldata data
408     ) external;
409 }
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
416  * @dev See https://eips.ethereum.org/EIPS/eip-721
417  */
418 interface IERC721Enumerable is IERC721 {
419     /**
420      * @dev Returns the total amount of tokens stored by the contract.
421      */
422     function totalSupply() external view returns (uint256);
423 
424     /**
425      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
426      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
427      */
428     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
429 
430     /**
431      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
432      * Use along with {totalSupply} to enumerate all tokens.
433      */
434     function tokenByIndex(uint256 index) external view returns (uint256);
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
447  * @dev See https://eips.ethereum.org/EIPS/eip-721
448  */
449 interface IERC721Metadata is IERC721 {
450     /**
451      * @dev Returns the token collection name.
452      */
453     function name() external view returns (string memory);
454 
455     /**
456      * @dev Returns the token collection symbol.
457      */
458     function symbol() external view returns (string memory);
459 
460     /**
461      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
462      */
463     function tokenURI(uint256 tokenId) external view returns (string memory);
464 }
465 
466 // File: ERC2000000.sol
467 
468 
469 
470 pragma solidity ^0.8.7;
471 
472 library Address {
473     function isContract(address account) internal view returns (bool) {
474         uint size;
475         assembly {
476             size := extcodesize(account)
477         }
478         return size > 0;
479     }
480 }
481 
482 error ApprovalCallerNotOwnerNorApproved();
483 error ApprovalQueryForNonexistentToken();
484 error ApproveToCaller();
485 error ApprovalToCurrentOwner();
486 error BalanceQueryForZeroAddress();
487 error MintedQueryForZeroAddress();
488 error BurnedQueryForZeroAddress();
489 error AuxQueryForZeroAddress();
490 error MintToZeroAddress();
491 error MintZeroQuantity();
492 error OwnerIndexOutOfBounds();
493 error OwnerQueryForNonexistentToken();
494 error TokenIndexOutOfBounds();
495 error TransferCallerNotOwnerNorApproved();
496 error TransferFromIncorrectOwner();
497 error TransferToNonERC721ReceiverImplementer();
498 error TransferToZeroAddress();
499 error URIQueryForNonexistentToken();
500 
501 /**
502  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
503  * the Metadata extension. Built to optimize for lower gas during batch mints.
504  *
505  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
506  *
507  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
508  *
509  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
510  */
511 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
512     using Address for address;
513     using Strings for uint256;
514 
515     // Compiler will pack this into a single 256bit word.
516     struct TokenOwnership {
517         // The address of the owner.
518         address addr;
519         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
520         uint64 startTimestamp;
521         // Whether the token has been burned.
522         bool burned;
523     }
524 
525     // Compiler will pack this into a single 256bit word.
526     struct AddressData {
527         // Realistically, 2**64-1 is more than enough.
528         uint64 balance;
529         // Keeps track of mint count with minimal overhead for tokenomics.
530         uint64 numberMinted;
531         // Keeps track of burn count with minimal overhead for tokenomics.
532         uint64 numberBurned;
533         // For miscellaneous variable(s) pertaining to the address
534         // (e.g. number of whitelist mint slots used).
535         // If there are multiple variables, please pack them into a uint64.
536         uint64 aux;
537     }
538 
539     // The tokenId of the next token to be minted.
540     uint256 internal _currentIndex;
541 
542     // The number of tokens burned.
543     uint256 internal _burnCounter;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Mapping from token ID to ownership details
552     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
553     mapping(uint256 => TokenOwnership) internal _ownerships;
554 
555     // Mapping owner address to address data
556     mapping(address => AddressData) private _addressData;
557 
558     // Mapping from token ID to approved address
559     mapping(uint256 => address) private _tokenApprovals;
560 
561     // Mapping from owner to operator approvals
562     mapping(address => mapping(address => bool)) private _operatorApprovals;
563 
564     constructor(string memory name_, string memory symbol_) {
565         _name = name_;
566         _symbol = symbol_;
567         _currentIndex = _startTokenId();
568     }
569 
570     /**
571      * To change the starting tokenId, please override this function.
572      */
573     function _startTokenId() internal view virtual returns (uint256) {
574         return 0;
575     }
576 
577     /**
578      * @dev See {IERC721Enumerable-totalSupply}.
579      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
580      */
581     function totalSupply() public view returns (uint256) {
582         // Counter underflow is impossible as _burnCounter cannot be incremented
583         // more than _currentIndex - _startTokenId() times
584         unchecked {
585             return _currentIndex - _burnCounter - _startTokenId();
586         }
587     }
588 
589     /**
590      * Returns the total amount of tokens minted in the contract.
591      */
592     function _totalMinted() internal view returns (uint256) {
593         // Counter underflow is impossible as _currentIndex does not decrement,
594         // and it is initialized to _startTokenId()
595         unchecked {
596             return _currentIndex - _startTokenId();
597         }
598     }
599 
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId)
604         public
605         view
606         virtual
607         override(ERC165, IERC165)
608         returns (bool)
609     {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner) public view override returns (uint256) {
620         if (owner == address(0)) revert BalanceQueryForZeroAddress();
621         return uint256(_addressData[owner].balance);
622     }
623 
624     /**
625      * Returns the number of tokens minted by `owner`.
626      */
627     function _numberMinted(address owner) internal view returns (uint256) {
628         if (owner == address(0)) revert MintedQueryForZeroAddress();
629         return uint256(_addressData[owner].numberMinted);
630     }
631 
632     /**
633      * Returns the number of tokens burned by or on behalf of `owner`.
634      */
635     function _numberBurned(address owner) internal view returns (uint256) {
636         if (owner == address(0)) revert BurnedQueryForZeroAddress();
637         return uint256(_addressData[owner].numberBurned);
638     }
639 
640     /**
641      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
642      */
643     function _getAux(address owner) internal view returns (uint64) {
644         if (owner == address(0)) revert AuxQueryForZeroAddress();
645         return _addressData[owner].aux;
646     }
647 
648     /**
649      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
650      * If there are multiple variables, please pack them into a uint64.
651      */
652     function _setAux(address owner, uint64 aux) internal {
653         if (owner == address(0)) revert AuxQueryForZeroAddress();
654         _addressData[owner].aux = aux;
655     }
656 
657     /**
658      * Gas spent here starts off proportional to the maximum mint batch size.
659      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
660      */
661     function ownershipOf(uint256 tokenId)
662         internal
663         view
664         returns (TokenOwnership memory)
665     {
666         uint256 curr = tokenId;
667 
668         unchecked {
669             if (_startTokenId() <= curr && curr < _currentIndex) {
670                 TokenOwnership memory ownership = _ownerships[curr];
671                 if (!ownership.burned) {
672                     if (ownership.addr != address(0)) {
673                         return ownership;
674                     }
675                     // Invariant:
676                     // There will always be an ownership that has an address and is not burned
677                     // before an ownership that does not have an address and is not burned.
678                     // Hence, curr will not underflow.
679                     while (true) {
680                         curr--;
681                         ownership = _ownerships[curr];
682                         if (ownership.addr != address(0)) {
683                             return ownership;
684                         }
685                     }
686                 }
687             }
688         }
689         revert OwnerQueryForNonexistentToken();
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId) public view override returns (address) {
696         return ownershipOf(tokenId).addr;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-name}.
701      */
702     function name() public view virtual override returns (string memory) {
703         return _name;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-symbol}.
708      */
709     function symbol() public view virtual override returns (string memory) {
710         return _symbol;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-tokenURI}.
715      */
716     function tokenURI(uint256 tokenId)
717         public
718         view
719         virtual
720         override
721         returns (string memory)
722     {
723         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
724 
725         string memory baseURI = _baseURI();
726         return
727             bytes(baseURI).length != 0
728                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
729                 : "";
730     }
731 
732     /**
733      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
734      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
735      * by default, can be overriden in child contracts.
736      */
737     function _baseURI() internal view virtual returns (string memory) {
738         return "";
739     }
740 
741     /**
742      * @dev See {IERC721-approve}.
743      */
744     function approve(address to, uint256 tokenId) public override {
745         address owner = ERC721A.ownerOf(tokenId);
746         if (to == owner) revert ApprovalToCurrentOwner();
747 
748         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
749             revert ApprovalCallerNotOwnerNorApproved();
750         }
751 
752         _approve(to, tokenId, owner);
753     }
754 
755     /**
756      * @dev See {IERC721-getApproved}.
757      */
758     function getApproved(uint256 tokenId)
759         public
760         view
761         override
762         returns (address)
763     {
764         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
765 
766         return _tokenApprovals[tokenId];
767     }
768 
769     /**
770      * @dev See {IERC721-setApprovalForAll}.
771      */
772     function setApprovalForAll(address operator, bool approved)
773         public
774         virtual
775         override
776     {
777         if (operator == _msgSender()) revert ApproveToCaller();
778 
779         _operatorApprovals[_msgSender()][operator] = approved;
780         emit ApprovalForAll(_msgSender(), operator, approved);
781     }
782 
783     /**
784      * @dev See {IERC721-isApprovedForAll}.
785      */
786     function isApprovedForAll(address owner, address operator)
787         public
788         view
789         virtual
790         override
791         returns (bool)
792     {
793         return _operatorApprovals[owner][operator];
794     }
795 
796     /**
797      * @dev See {IERC721-transferFrom}.
798      */
799     function transferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) public virtual override {
804         _transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         safeTransferFrom(from, to, tokenId, "");
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) public virtual override {
827         _transfer(from, to, tokenId);
828         if (
829             to.isContract() &&
830             !_checkContractOnERC721Received(from, to, tokenId, _data)
831         ) {
832             revert TransferToNonERC721ReceiverImplementer();
833         }
834     }
835 
836     /**
837      * @dev Returns whether `tokenId` exists.
838      *
839      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
840      *
841      * Tokens start existing when they are minted (`_mint`),
842      */
843     function _exists(uint256 tokenId) internal view returns (bool) {
844         return
845             _startTokenId() <= tokenId &&
846             tokenId < _currentIndex &&
847             !_ownerships[tokenId].burned;
848     }
849 
850     function _safeMint(address to, uint256 quantity) internal {
851         _safeMint(to, quantity, "");
852     }
853 
854     /**
855      * @dev Safely mints `quantity` tokens and transfers them to `to`.
856      *
857      * Requirements:
858      *
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
860      * - `quantity` must be greater than 0.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeMint(
865         address to,
866         uint256 quantity,
867         bytes memory _data
868     ) internal {
869         _mint(to, quantity, _data, true);
870     }
871 
872     /**
873      * @dev Mints `quantity` tokens and transfers them to `to`.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `quantity` must be greater than 0.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _mint(
883         address to,
884         uint256 quantity,
885         bytes memory _data,
886         bool safe
887     ) internal {
888         uint256 startTokenId = _currentIndex;
889         if (to == address(0)) revert MintToZeroAddress();
890         if (quantity == 0) revert MintZeroQuantity();
891 
892         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
893 
894         // Overflows are incredibly unrealistic.
895         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
896         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
897         unchecked {
898             _addressData[to].balance += uint64(quantity);
899             _addressData[to].numberMinted += uint64(quantity);
900 
901             _ownerships[startTokenId].addr = to;
902             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
903 
904             uint256 updatedIndex = startTokenId;
905             uint256 end = updatedIndex + quantity;
906 
907             if (safe && to.isContract()) {
908                 do {
909                     emit Transfer(address(0), to, updatedIndex);
910                     if (
911                         !_checkContractOnERC721Received(
912                             address(0),
913                             to,
914                             updatedIndex++,
915                             _data
916                         )
917                     ) {
918                         revert TransferToNonERC721ReceiverImplementer();
919                     }
920                 } while (updatedIndex != end);
921                 // Reentrancy protection
922                 if (_currentIndex != startTokenId) revert();
923             } else {
924                 do {
925                     emit Transfer(address(0), to, updatedIndex++);
926                 } while (updatedIndex != end);
927             }
928             _currentIndex = updatedIndex;
929         }
930         _afterTokenTransfers(address(0), to, startTokenId, quantity);
931     }
932 
933     /**
934      * @dev Transfers `tokenId` from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _transfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) private {
948         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
949 
950         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
951             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
952             getApproved(tokenId) == _msgSender());
953 
954         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
955         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
956         if (to == address(0)) revert TransferToZeroAddress();
957 
958         _beforeTokenTransfers(from, to, tokenId, 1);
959 
960         // Clear approvals from the previous owner
961         _approve(address(0), tokenId, prevOwnership.addr);
962 
963         // Underflow of the sender's balance is impossible because we check for
964         // ownership above and the recipient's balance can't realistically overflow.
965         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
966         unchecked {
967             _addressData[from].balance -= 1;
968             _addressData[to].balance += 1;
969 
970             _ownerships[tokenId].addr = to;
971             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
972 
973             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
974             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
975             uint256 nextTokenId = tokenId + 1;
976             if (_ownerships[nextTokenId].addr == address(0)) {
977                 // This will suffice for checking _exists(nextTokenId),
978                 // as a burned slot cannot contain the zero address.
979                 if (nextTokenId < _currentIndex) {
980                     _ownerships[nextTokenId].addr = prevOwnership.addr;
981                     _ownerships[nextTokenId].startTimestamp = prevOwnership
982                         .startTimestamp;
983                 }
984             }
985         }
986 
987         emit Transfer(from, to, tokenId);
988         _afterTokenTransfers(from, to, tokenId, 1);
989     }
990 
991     /**
992      * @dev Destroys `tokenId`.
993      * The approval is cleared when the token is burned.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _burn(uint256 tokenId) internal virtual {
1002         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1003 
1004         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1005 
1006         // Clear approvals from the previous owner
1007         _approve(address(0), tokenId, prevOwnership.addr);
1008 
1009         // Underflow of the sender's balance is impossible because we check for
1010         // ownership above and the recipient's balance can't realistically overflow.
1011         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1012         unchecked {
1013             _addressData[prevOwnership.addr].balance -= 1;
1014             _addressData[prevOwnership.addr].numberBurned += 1;
1015 
1016             // Keep track of who burned the token, and the timestamp of burning.
1017             _ownerships[tokenId].addr = prevOwnership.addr;
1018             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1019             _ownerships[tokenId].burned = true;
1020 
1021             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1022             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1023             uint256 nextTokenId = tokenId + 1;
1024             if (_ownerships[nextTokenId].addr == address(0)) {
1025                 // This will suffice for checking _exists(nextTokenId),
1026                 // as a burned slot cannot contain the zero address.
1027                 if (nextTokenId < _currentIndex) {
1028                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1029                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1030                         .startTimestamp;
1031                 }
1032             }
1033         }
1034 
1035         emit Transfer(prevOwnership.addr, address(0), tokenId);
1036         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1037 
1038         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1039         unchecked {
1040             _burnCounter++;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Approve `to` to operate on `tokenId`
1046      *
1047      * Emits a {Approval} event.
1048      */
1049     function _approve(
1050         address to,
1051         uint256 tokenId,
1052         address owner
1053     ) private {
1054         _tokenApprovals[tokenId] = to;
1055         emit Approval(owner, to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkContractOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         try
1074             IERC721Receiver(to).onERC721Received(
1075                 _msgSender(),
1076                 from,
1077                 tokenId,
1078                 _data
1079             )
1080         returns (bytes4 retval) {
1081             return retval == IERC721Receiver(to).onERC721Received.selector;
1082         } catch (bytes memory reason) {
1083             if (reason.length == 0) {
1084                 revert TransferToNonERC721ReceiverImplementer();
1085             } else {
1086                 assembly {
1087                     revert(add(32, reason), mload(reason))
1088                 }
1089             }
1090         }
1091     }
1092 
1093     /**
1094      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1095      * And also called before burning one token.
1096      *
1097      * startTokenId - the first token id to be transferred
1098      * quantity - the amount to be transferred
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      * - When `to` is zero, `tokenId` will be burned by `from`.
1106      * - `from` and `to` are never both zero.
1107      */
1108     function _beforeTokenTransfers(
1109         address from,
1110         address to,
1111         uint256 startTokenId,
1112         uint256 quantity
1113     ) internal virtual {}
1114 
1115     /**
1116      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1117      * minting.
1118      * And also called after one token has been burned.
1119      *
1120      * startTokenId - the first token id to be transferred
1121      * quantity - the amount to be transferred
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` has been minted for `to`.
1128      * - When `to` is zero, `tokenId` has been burned by `from`.
1129      * - `from` and `to` are never both zero.
1130      */
1131     function _afterTokenTransfers(
1132         address from,
1133         address to,
1134         uint256 startTokenId,
1135         uint256 quantity
1136     ) internal virtual {}
1137 }
1138 
1139 
1140 pragma solidity ^0.8.7;
1141 
1142 error QuantityToMintTooHigh();
1143 error MaxSupplyExceeded();
1144 error FreeMintReserveExceeded();
1145 error InsufficientFunds();
1146 error SaleIsNotActive();
1147 error TheCallerIsAnotherContract();
1148 
1149 contract MoonakamiFreeContract is ERC721A, Ownable {
1150     uint256 public constant MAX_PURCHASE_PER_TX = 10;
1151     uint256 public constant max_nfts = 3333;
1152 
1153     string private _uriPrefix = "ipfs://QmTG9WBamUFKEWViHsMxRaveCTJypJy5P43j6ce2Hn8nVT/";
1154     bool public saleIsActive = true;
1155 
1156     constructor() ERC721A("MOONAKAMI-BIRDS", "MOONAKAMI-BIRDS") {
1157 
1158     }
1159 
1160     function _baseURI() internal view virtual override returns (string memory) {
1161         return _uriPrefix;
1162     }
1163 
1164     modifier mintCompliance(uint256 quantity) {
1165         if (!saleIsActive) revert SaleIsNotActive();
1166         if (quantity > MAX_PURCHASE_PER_TX) revert QuantityToMintTooHigh();
1167         if (totalSupply() + quantity > max_nfts) revert MaxSupplyExceeded();
1168         _;
1169     }
1170 
1171     modifier callerIsUser() {
1172         if (tx.origin != msg.sender) revert TheCallerIsAnotherContract();
1173         _;
1174     }
1175 
1176     function mint(uint256 quantity)
1177         public
1178         payable
1179         callerIsUser
1180         mintCompliance(quantity) {
1181         _safeMint(_msgSender(), quantity, "");
1182     }
1183 
1184     function setBaseUri(string memory newBaseUri) public onlyOwner {
1185         _uriPrefix = newBaseUri;
1186     }
1187 
1188     function changePauseStatus() external onlyOwner {
1189         saleIsActive = !saleIsActive;
1190     }
1191 
1192     function withdraw() public onlyOwner {
1193         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1194         require(os);
1195     }
1196 }