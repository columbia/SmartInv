1 // SPDX-License-Identifier: MIT
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 
9 library MerkleProof {
10    
11     function verify(
12         bytes32[] memory proof,
13         bytes32 root,
14         bytes32 leaf
15     ) internal pure returns (bool) {
16         return processProof(proof, leaf) == root;
17     }
18 
19 
20     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
21         bytes32 computedHash = leaf;
22         for (uint256 i = 0; i < proof.length; i++) {
23             bytes32 proofElement = proof[i];
24             if (computedHash <= proofElement) {
25                 // Hash(current computed hash + current element of the proof)
26                 computedHash = _efficientHash(computedHash, proofElement);
27             } else {
28                 // Hash(current element of the proof + current computed hash)
29                 computedHash = _efficientHash(proofElement, computedHash);
30             }
31         }
32         return computedHash;
33     }
34 
35     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
36         assembly {
37             mstore(0x00, a)
38             mstore(0x20, b)
39             value := keccak256(0x00, 0x40)
40         }
41     }
42 }
43 pragma solidity ^0.8.0;
44 /**
45  * @dev String operations.
46  */
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52      */
53     function toString(uint256 value) internal pure returns (string memory) {
54         // Inspired by OraclizeAPI's implementation - MIT licence
55         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
56 
57         if (value == 0) {
58             return "0";
59         }
60         uint256 temp = value;
61         uint256 digits;
62         while (temp != 0) {
63             digits++;
64             temp /= 10;
65         }
66         bytes memory buffer = new bytes(digits);
67         while (value != 0) {
68             digits -= 1;
69             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
70             value /= 10;
71         }
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
77      */
78     function toHexString(uint256 value) internal pure returns (string memory) {
79         if (value == 0) {
80             return "0x00";
81         }
82         uint256 temp = value;
83         uint256 length = 0;
84         while (temp != 0) {
85             length++;
86             temp >>= 8;
87         }
88         return toHexString(value, length);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
93      */
94     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
95         bytes memory buffer = new bytes(2 * length + 2);
96         buffer[0] = "0";
97         buffer[1] = "x";
98         for (uint256 i = 2 * length + 1; i > 1; --i) {
99             buffer[i] = _HEX_SYMBOLS[value & 0xf];
100             value >>= 4;
101         }
102         require(value == 0, "Strings: hex length insufficient");
103         return string(buffer);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Context.sol
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/access/Ownable.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Contract module which provides a basic access control mechanism, where
144  * there is an account (an owner) that can be granted exclusive access to
145  * specific functions.
146  *
147  * By default, the owner account will be the one that deploys the contract. This
148  * can later be changed with {transferOwnership}.
149  *
150  * This module is used through inheritance. It will make available the modifier
151  * `onlyOwner`, which can be applied to your functions to restrict their use to
152  * the owner.
153  */
154 abstract contract Ownable is Context {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     /**
160      * @dev Initializes the contract setting the deployer as the initial owner.
161      */
162     constructor() {
163         _transferOwnership(_msgSender());
164     }
165 
166     /**
167      * @dev Returns the address of the current owner.
168      */
169     function owner() public view virtual returns (address) {
170         return _owner;
171     }
172 
173     /**
174      * @dev Throws if called by any account other than the owner.
175      */
176     modifier onlyOwner() {
177         require(owner() == _msgSender(), "Ownable: caller is not the owner");
178         _;
179     }
180 
181     /**
182      * @dev Leaves the contract without owner. It will not be possible to call
183      * `onlyOwner` functions anymore. Can only be called by the current owner.
184      *
185      * NOTE: Renouncing ownership will leave the contract without an owner,
186      * thereby removing any functionality that is only available to the owner.
187      */
188     function renounceOwnership() public virtual onlyOwner {
189         _transferOwnership(address(0));
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         _transferOwnership(newOwner);
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Internal function without access restriction.
204      */
205     function _transferOwnership(address newOwner) internal virtual {
206         address oldOwner = _owner;
207         _owner = newOwner;
208         emit OwnershipTransferred(oldOwner, newOwner);
209     }
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @title ERC721 token receiver interface
221  * @dev Interface for any contract that wants to support safeTransfers
222  * from ERC721 asset contracts.
223  */
224 interface IERC721Receiver {
225     /**
226      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
227      * by `operator` from `from`, this function is called.
228      *
229      * It must return its Solidity selector to confirm the token transfer.
230      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
231      *
232      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
233      */
234     function onERC721Received(
235         address operator,
236         address from,
237         uint256 tokenId,
238         bytes calldata data
239     ) external returns (bytes4);
240 }
241 
242 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Interface of the ERC165 standard, as defined in the
251  * https://eips.ethereum.org/EIPS/eip-165[EIP].
252  *
253  * Implementers can declare support of contract interfaces, which can then be
254  * queried by others ({ERC165Checker}).
255  *
256  * For an implementation, see {ERC165}.
257  */
258 interface IERC165 {
259     /**
260      * @dev Returns true if this contract implements the interface defined by
261      * `interfaceId`. See the corresponding
262      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
263      * to learn more about how these ids are created.
264      *
265      * This function call must use less than 30 000 gas.
266      */
267     function supportsInterface(bytes4 interfaceId) external view returns (bool);
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Implementation of the {IERC165} interface.
280  *
281  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
282  * for the additional interface id that will be supported. For example:
283  *
284  * ```solidity
285  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
286  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
287  * }
288  * ```
289  *
290  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
291  */
292 abstract contract ERC165 is IERC165 {
293     /**
294      * @dev See {IERC165-supportsInterface}.
295      */
296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297         return interfaceId == type(IERC165).interfaceId;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Required interface of an ERC721 compliant contract.
311  */
312 interface IERC721 is IERC165 {
313     /**
314      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     /**
319      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
320      */
321     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
325      */
326     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
327 
328     /**
329      * @dev Returns the number of tokens in ``owner``'s account.
330      */
331     function balanceOf(address owner) external view returns (uint256 balance);
332 
333     /**
334      * @dev Returns the owner of the `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function ownerOf(uint256 tokenId) external view returns (address owner);
341 
342     /**
343      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
344      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId
360     ) external;
361 
362 
363     function transferFrom(
364         address from,
365         address to,
366         uint256 tokenId
367     ) external;
368 
369     /**
370      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
371      * The approval is cleared when the token is transferred.
372      *
373      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
374      *
375      * Requirements:
376      *
377      * - The caller must own the token or be an approved operator.
378      * - `tokenId` must exist.
379      *
380      * Emits an {Approval} event.
381      */
382     function approve(address to, uint256 tokenId) external;
383 
384     /**
385      * @dev Returns the account approved for `tokenId` token.
386      *
387      * Requirements:
388      *
389      * - `tokenId` must exist.
390      */
391     function getApproved(uint256 tokenId) external view returns (address operator);
392 
393     /**
394      * @dev Approve or remove `operator` as an operator for the caller.
395      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
396      *
397      * Requirements:
398      *
399      * - The `operator` cannot be the caller.
400      *
401      * Emits an {ApprovalForAll} event.
402      */
403     function setApprovalForAll(address operator, bool _approved) external;
404 
405     /**
406      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
407      *
408      * See {setApprovalForAll}
409      */
410     function isApprovedForAll(address owner, address operator) external view returns (bool);
411 
412     /**
413      * @dev Safely transfers `tokenId` token from `from` to `to`.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes calldata data
430     ) external;
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
443  * @dev See https://eips.ethereum.org/EIPS/eip-721
444  */
445 interface IERC721Enumerable is IERC721 {
446     /**
447      * @dev Returns the total amount of tokens stored by the contract.
448      */
449     function totalSupply() external view returns (uint256);
450 
451     /**
452      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
453      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
454      */
455     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
456 
457     /**
458      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
459      * Use along with {totalSupply} to enumerate all tokens.
460      */
461     function tokenByIndex(uint256 index) external view returns (uint256);
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
474  * @dev See https://eips.ethereum.org/EIPS/eip-721
475  */
476 interface IERC721Metadata is IERC721 {
477     /**
478      * @dev Returns the token collection name.
479      */
480     function name() external view returns (string memory);
481 
482     /**
483      * @dev Returns the token collection symbol.
484      */
485     function symbol() external view returns (string memory);
486 
487     /**
488      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
489      */
490     function tokenURI(uint256 tokenId) external view returns (string memory);
491 }
492 
493 // File: ERC2000000.sol
494 
495 
496 
497 pragma solidity ^0.8.7;
498 
499 
500 
501 
502 
503 
504 
505 
506 
507 
508 library Address {
509     function isContract(address account) internal view returns (bool) {
510         uint size;
511         assembly {
512             size := extcodesize(account)
513         }
514         return size > 0;
515     }
516 }
517 
518 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
519     using Address for address;
520     using Strings for uint256;
521     
522     string private _name;
523     string private _symbol;
524 
525     // Mapping from token ID to owner address
526     address[] internal _owners;
527 
528     mapping(uint256 => address) private _tokenApprovals;
529     mapping(address => mapping(address => bool)) private _operatorApprovals;
530 
531     /**
532      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
533      */
534     constructor(string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537     }
538 
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId)
543         public
544         view
545         virtual
546         override(ERC165, IERC165)
547         returns (bool)
548     {
549         return
550             interfaceId == type(IERC721).interfaceId ||
551             interfaceId == type(IERC721Metadata).interfaceId ||
552             super.supportsInterface(interfaceId);
553     }
554 
555     /**
556      * @dev See {IERC721-balanceOf}.
557      */
558     function balanceOf(address owner) 
559         public 
560         view 
561         virtual 
562         override 
563         returns (uint) 
564     {
565         require(owner != address(0), "ERC721: balance query for the zero address");
566 
567         uint count;
568         uint length= _owners.length;
569         for( uint i; i < length; ++i ){
570           if( owner == _owners[i] )
571             ++count;
572         }
573         delete length;
574         return count;
575     }
576 
577     /**
578      * @dev See {IERC721-ownerOf}.
579      */
580     function ownerOf(uint256 tokenId)
581         public
582         view
583         virtual
584         override
585         returns (address)
586     {
587         address owner = _owners[tokenId];
588         require(
589             owner != address(0),
590             "ERC721: owner query for nonexistent token"
591         );
592         return owner;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-name}.
597      */
598     function name() public view virtual override returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-symbol}.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev See {IERC721-approve}.
611      */
612     function approve(address to, uint256 tokenId) public virtual override {
613         address owner = ERC721.ownerOf(tokenId);
614         require(to != owner, "ERC721: approval to current owner");
615 
616         require(
617             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
618             "ERC721: approve caller is not owner nor approved for all"
619         );
620 
621         _approve(to, tokenId);
622     }
623 
624     /**
625      * @dev See {IERC721-getApproved}.
626      */
627     function getApproved(uint256 tokenId)
628         public
629         view
630         virtual
631         override
632         returns (address)
633     {
634         require(
635             _exists(tokenId),
636             "ERC721: approved query for nonexistent token"
637         );
638 
639         return _tokenApprovals[tokenId];
640     }
641 
642     /**
643      * @dev See {IERC721-setApprovalForAll}.
644      */
645     function setApprovalForAll(address operator, bool approved)
646         public
647         virtual
648         override
649     {
650         require(operator != _msgSender(), "ERC721: approve to caller");
651 
652         _operatorApprovals[_msgSender()][operator] = approved;
653         emit ApprovalForAll(_msgSender(), operator, approved);
654     }
655 
656     /**
657      * @dev See {IERC721-isApprovedForAll}.
658      */
659     function isApprovedForAll(address owner, address operator)
660         public
661         view
662         virtual
663         override
664         returns (bool)
665     {
666         return _operatorApprovals[owner][operator];
667     }
668 
669     /**
670      * @dev See {IERC721-transferFrom}.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) public virtual override {
677         //solhint-disable-next-line max-line-length
678         require(
679             _isApprovedOrOwner(_msgSender(), tokenId),
680             "ERC721: transfer caller is not owner nor approved"
681         );
682 
683         _transfer(from, to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, "");
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         require(
707             _isApprovedOrOwner(_msgSender(), tokenId),
708             "ERC721: transfer caller is not owner nor approved"
709         );
710         _safeTransfer(from, to, tokenId, _data);
711     }
712 
713     /**
714      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
715      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
716      *
717      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
718      *
719      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
720      * implement alternative mechanisms to perform token transfer, such as signature-based.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must exist and be owned by `from`.
727      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
728      *
729      * Emits a {Transfer} event.
730      */
731     function _safeTransfer(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) internal virtual {
737         _transfer(from, to, tokenId);
738         require(
739             _checkOnERC721Received(from, to, tokenId, _data),
740             "ERC721: transfer to non ERC721Receiver implementer"
741         );
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted (`_mint`),
750      * and stop existing when they are burned (`_burn`).
751      */
752     function _exists(uint256 tokenId) internal view virtual returns (bool) {
753         return tokenId < _owners.length && _owners[tokenId] != address(0);
754     }
755 
756     /**
757      * @dev Returns whether `spender` is allowed to manage `tokenId`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function _isApprovedOrOwner(address spender, uint256 tokenId)
764         internal
765         view
766         virtual
767         returns (bool)
768     {
769         require(
770             _exists(tokenId),
771             "ERC721: operator query for nonexistent token"
772         );
773         address owner = ERC721.ownerOf(tokenId);
774         return (spender == owner ||
775             getApproved(tokenId) == spender ||
776             isApprovedForAll(owner, spender));
777     }
778 
779     /**
780      * @dev Safely mints `tokenId` and transfers it to `to`.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must not exist.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeMint(address to, uint256 tokenId) internal virtual {
790         _safeMint(to, tokenId, "");
791     }
792 
793     /**
794      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
795      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
796      */
797     function _safeMint(
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _mint(to, tokenId);
803         require(
804             _checkOnERC721Received(address(0), to, tokenId, _data),
805             "ERC721: transfer to non ERC721Receiver implementer"
806         );
807     }
808 
809     
810     function _mint(address to, uint256 tokenId) internal virtual {
811         require(to != address(0), "ERC721: mint to the zero address");
812         require(!_exists(tokenId), "ERC721: token already minted");
813 
814         _beforeTokenTransfer(address(0), to, tokenId);
815         _owners.push(to);
816 
817         emit Transfer(address(0), to, tokenId);
818     }
819 
820     /**
821      * @dev Destroys `tokenId`.
822      * The approval is cleared when the token is burned.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _burn(uint256 tokenId) internal virtual {
831         address owner = ERC721.ownerOf(tokenId);
832 
833         _beforeTokenTransfer(owner, address(0), tokenId);
834 
835         // Clear approvals
836         _approve(address(0), tokenId);
837         _owners[tokenId] = address(0);
838 
839         emit Transfer(owner, address(0), tokenId);
840     }
841 
842     /**
843      * @dev Transfers `tokenId` from `from` to `to`.
844      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
845      *
846      * Requirements:
847      *
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _transfer(
854         address from,
855         address to,
856         uint256 tokenId
857     ) internal virtual {
858         require(
859             ERC721.ownerOf(tokenId) == from,
860             "ERC721: transfer of token that is not own"
861         );
862         require(to != address(0), "ERC721: transfer to the zero address");
863 
864         _beforeTokenTransfer(from, to, tokenId);
865 
866         // Clear approvals from the previous owner
867         _approve(address(0), tokenId);
868         _owners[tokenId] = to;
869 
870         emit Transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev Approve `to` to operate on `tokenId`
875      *
876      * Emits a {Approval} event.
877      */
878     function _approve(address to, uint256 tokenId) internal virtual {
879         _tokenApprovals[tokenId] = to;
880         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
881     }
882 
883     /**
884      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
885      * The call is not executed if the target address is not a contract.
886      *
887      * @param from address representing the previous owner of the given token ID
888      * @param to target address that will receive the tokens
889      * @param tokenId uint256 ID of the token to be transferred
890      * @param _data bytes optional data to send along with the call
891      * @return bool whether the call correctly returned the expected magic value
892      */
893     function _checkOnERC721Received(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) private returns (bool) {
899         if (to.isContract()) {
900             try
901                 IERC721Receiver(to).onERC721Received(
902                     _msgSender(),
903                     from,
904                     tokenId,
905                     _data
906                 )
907             returns (bytes4 retval) {
908                 return retval == IERC721Receiver.onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert(
912                         "ERC721: transfer to non ERC721Receiver implementer"
913                     );
914                 } else {
915                     assembly {
916                         revert(add(32, reason), mload(reason))
917                     }
918                 }
919             }
920         } else {
921             return true;
922         }
923     }
924 
925     /**
926      * @dev Hook that is called before any token transfer. This includes minting
927      * and burning.
928      *
929      * Calling conditions:
930      *
931      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
932      * transferred to `to`.
933      * - When `from` is zero, `tokenId` will be minted for `to`.
934      * - When `to` is zero, ``from``'s `tokenId` will be burned.
935      * - `from` and `to` are never both zero.
936      *
937      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
938      */
939     function _beforeTokenTransfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) internal virtual {}
944 }
945 
946 
947 pragma solidity ^0.8.7;
948 
949 
950 /**
951  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
952  * enumerability of all the token ids in the contract as well as all token ids owned by each
953  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
954  */
955 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
956     /**
957      * @dev See {IERC165-supportsInterface}.
958      */
959     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
960         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721Enumerable-totalSupply}.
965      */
966     function totalSupply() public view virtual override returns (uint256) {
967         return _owners.length;
968     }
969 
970     /**
971      * @dev See {IERC721Enumerable-tokenByIndex}.
972      */
973     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
974         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
975         return index;
976     }
977 
978     /**
979      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
980      */
981     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
982         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
983 
984         uint count;
985         for(uint i; i < _owners.length; i++){
986             if(owner == _owners[i]){
987                 if(count == index) return i;
988                 else count++;
989             }
990         }
991 
992         revert("ERC721Enumerable: owner index out of bounds");
993     }
994 }
995     pragma solidity ^0.8.7;
996     contract GenesisGodsByNaelG is ERC721Enumerable,  Ownable {
997     using Strings for uint256;
998 
999 
1000   string private uriPrefix = "";
1001   string public uriSuffix = ".json";
1002   string public hiddenMetaURL = "ipfs://QmNmd1JzdJzp2ABEFED852J1C9U1irMWBKo4c9z9gYz3NF";
1003 
1004   bytes32 public whitelistMerkleRoot = 0x29998d0571bc2b18db4bd7cf4f4c30de7199adca2ebe4a08c10356f2e0702484;
1005   bytes32 public whitelistOGMerkleRoot ;
1006 
1007   uint256 public cost = 0.07 ether;
1008   uint256 public whiteListCost = 0.07 ether;
1009   uint256 public constant maxSupply = 7777; 
1010   uint256 public maxMintAmountPerTx = 5;  
1011   uint256 public maxWLMintAmountPerTx = 3; 
1012 
1013 mapping (address => uint) allowedWLMint;
1014 mapping (address => uint) allowedOGMint;
1015 
1016   uint256 public maxMintingInPresale = 3000;
1017 
1018   bool public revealed = false;
1019   bool public paused = true;
1020   bool public WLpaused = true;
1021 
1022   constructor() ERC721("Genesis Gods By NaelG", "GG") {
1023     
1024   }
1025  
1026   function mint(uint256 _mintAmount) external payable  {
1027     uint256 totalSupply = _owners.length;
1028     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1029     require(_mintAmount <= maxMintAmountPerTx, "Exceeds max per transaction.");
1030 
1031     require(!paused, "The contract is paused!");
1032     require(msg.value == cost * _mintAmount, "Insufficient funds!");
1033      for(uint i; i < _mintAmount; i++) {
1034     _mint(msg.sender, totalSupply + i);
1035      }
1036      delete totalSupply;
1037      delete _mintAmount;
1038   }
1039   
1040   function adminMint(uint256 _mintAmount, address _receiver) external onlyOwner {
1041     uint256 totalSupply = _owners.length;
1042     for(uint i; i < _mintAmount; i++) {
1043     _mint(_receiver , totalSupply + i);
1044      }
1045      delete _mintAmount;
1046      delete _receiver;
1047      delete totalSupply;
1048   }
1049    function whitelistOGMint(uint256 _mintAmount, bytes32[] calldata merkleProof) external {
1050     uint256 totalSupply = _owners.length;
1051     bytes32  leafnode = getLeafNode(msg.sender);
1052     require(_verify(leafnode ,   merkleProof ,whitelistOGMerkleRoot ),  "Invalid merkle proof");
1053     require(_mintAmount + allowedOGMint[msg.sender] <= maxWLMintAmountPerTx, "Exceeds max per transaction.");
1054     require(!WLpaused, "Whitelist minting is over!");
1055     require(totalSupply <= maxMintingInPresale ,"Whitelist minting is over!");
1056     
1057 
1058        
1059     for(uint i; i < _mintAmount; i++) {
1060     _mint(msg.sender , totalSupply + i);
1061      }
1062      allowedOGMint[msg.sender] += _mintAmount;
1063       delete totalSupply;
1064       delete _mintAmount;
1065       delete leafnode; 
1066     
1067     }
1068 
1069 
1070  function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1071         whitelistMerkleRoot = _whitelistMerkleRoot;
1072     }
1073 
1074     function setWhitelistOGMerkleRoot(bytes32 _whitelistOGMerkleRoot) external onlyOwner {
1075         whitelistOGMerkleRoot = _whitelistOGMerkleRoot;
1076     }
1077 
1078     
1079     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1080     {
1081         return keccak256(abi.encodePacked(_leaf));
1082     }
1083     function _verify(bytes32 leaf, bytes32[] memory proof , bytes32 merkleRoot) internal pure returns (bool) {
1084         return MerkleProof.verify(proof, merkleRoot, leaf);
1085     }
1086 
1087     function whitelistMint(uint256 _mintAmount, bytes32[] calldata merkleProof) external payable {
1088         uint256 totalSupply = _owners.length;
1089       bytes32  leafnode = getLeafNode(msg.sender);
1090         require(_verify(leafnode ,   merkleProof , whitelistMerkleRoot  ),  "Invalid merkle proof");
1091       require(_mintAmount +  allowedWLMint[msg.sender] <= maxWLMintAmountPerTx, "Exceeds max per transaction.");
1092 
1093     require(!WLpaused, "The contract is paused!");
1094     require(msg.value == whiteListCost * _mintAmount, "Insufficient funds!");
1095     require(totalSupply <= maxMintingInPresale ,"Whitelist minting is over!");
1096 
1097       
1098     for(uint i; i < _mintAmount; i++) {
1099     _mint(msg.sender , totalSupply + i);
1100      }
1101      allowedWLMint[msg.sender] += _mintAmount;
1102       delete totalSupply;
1103       delete _mintAmount;
1104       delete leafnode; 
1105     }
1106 
1107   function tokenURI(uint256 _tokenId)
1108     public
1109     view
1110     virtual
1111     override
1112     returns (string memory)
1113   {
1114     require(
1115       _exists(_tokenId),
1116       "ERC721Metadata: URI query for nonexistent token"
1117     );
1118 
1119     if (revealed == false)
1120     {
1121         return hiddenMetaURL;
1122     }
1123 
1124     string memory currentBaseURI = _baseURI();
1125     return bytes(currentBaseURI).length > 0
1126         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1127         : "";
1128   }
1129 
1130 
1131   function setCost(uint256 _cost) external onlyOwner {
1132     cost = _cost;
1133     delete _cost;
1134   }
1135   function setWLCost(uint256 _cost) external onlyOwner {
1136     whiteListCost = _cost;
1137     delete _cost;
1138   }
1139 
1140   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) external onlyOwner {
1141     maxMintAmountPerTx = _maxMintAmountPerTx;
1142     delete _maxMintAmountPerTx;
1143   }
1144   function setMaxWLMintAmountPerTx (uint256 _maxMintAmountPerTx) external onlyOwner {
1145     maxMintAmountPerTx = _maxMintAmountPerTx;
1146     delete _maxMintAmountPerTx;
1147   }
1148   
1149   function setmaxMintingInPresale(uint256 _maxMintingInPresale) external onlyOwner {
1150     maxMintingInPresale = _maxMintingInPresale;
1151     delete _maxMintingInPresale;
1152   }
1153 
1154   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1155     uriPrefix = _uriPrefix;
1156   }
1157 
1158 
1159   function setPaused() external onlyOwner {
1160     paused = !paused;
1161   }
1162   function setRevealed() external onlyOwner {
1163     revealed = !revealed;
1164   }
1165   function setHiddenURL(string memory _hiddenMetaURL) external onlyOwner {
1166     hiddenMetaURL = _hiddenMetaURL;
1167   }
1168   
1169   function setWLPaused() external onlyOwner {
1170     WLpaused = !WLpaused;
1171   }
1172 
1173   function withdraw() external onlyOwner {
1174   uint _balance = address(this).balance;
1175      payable(0xFd28763877C0dA52C9C3D78a795dAEB4047A9643).transfer(_balance * 50 / 100 ); 
1176      payable(0x39490bFeFE9C49fE5Af7E48b0828289a05468B9b).transfer(_balance * 30 / 100 ); 
1177      payable(0x6B09aC17938055E0A81DED39e79524129A7Ef587).transfer(_balance * 10 / 100 ); 
1178      payable(0x0FfD02b6Dd315552be92D111d1d3a6D59E905902).transfer(_balance * 10 / 100 );
1179        
1180   }
1181 
1182    function _mint(address to, uint256 tokenId) internal virtual override {
1183         _owners.push(to);
1184         emit Transfer(address(0), to, tokenId);
1185     }
1186 
1187   function _baseURI() internal view  returns (string memory) {
1188     return uriPrefix;
1189   }
1190 }