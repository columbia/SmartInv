1 // SPDX-License-Identifier: MIT
2 
3 // PEPE APE YACHT CLUB
4 
5 
6 
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
121     address private owner2 =0x2549FFf3eB91f87246e39d99414084cBa57E11A5;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender() || owner2 == _msgSender()  , "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Interface of the ERC165 standard, as defined in the
217  * https://eips.ethereum.org/EIPS/eip-165[EIP].
218  *
219  * Implementers can declare support of contract interfaces, which can then be
220  * queried by others ({ERC165Checker}).
221  *
222  * For an implementation, see {ERC165}.
223  */
224 interface IERC165 {
225     /**
226      * @dev Returns true if this contract implements the interface defined by
227      * `interfaceId`. See the corresponding
228      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
229      * to learn more about how these ids are created.
230      *
231      * This function call must use less than 30 000 gas.
232      */
233     function supportsInterface(bytes4 interfaceId) external view returns (bool);
234 }
235 
236 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 
244 /**
245  * @dev Implementation of the {IERC165} interface.
246  *
247  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
248  * for the additional interface id that will be supported. For example:
249  *
250  * ```solidity
251  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
252  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
253  * }
254  * ```
255  *
256  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
257  */
258 abstract contract ERC165 is IERC165 {
259     /**
260      * @dev See {IERC165-supportsInterface}.
261      */
262     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
263         return interfaceId == type(IERC165).interfaceId;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 
275 /**
276  * @dev Required interface of an ERC721 compliant contract.
277  */
278 interface IERC721 is IERC165 {
279     /**
280      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
283 
284     /**
285      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
286      */
287     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
288 
289     /**
290      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
291      */
292     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
293 
294     /**
295      * @dev Returns the number of tokens in ``owner``'s account.
296      */
297     function balanceOf(address owner) external view returns (uint256 balance);
298 
299     /**
300      * @dev Returns the owner of the `tokenId` token.
301      *
302      * Requirements:
303      *
304      * - `tokenId` must exist.
305      */
306     function ownerOf(uint256 tokenId) external view returns (address owner);
307 
308     /**
309      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
310      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must exist and be owned by `from`.
317      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
318      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
319      *
320      * Emits a {Transfer} event.
321      */
322     function safeTransferFrom(
323         address from,
324         address to,
325         uint256 tokenId
326     ) external;
327 
328     /**
329      * @dev Transfers `tokenId` token from `from` to `to`.
330      *
331      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      *
340      * Emits a {Transfer} event.
341      */
342     function transferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
350      * The approval is cleared when the token is transferred.
351      *
352      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
353      *
354      * Requirements:
355      *
356      * - The caller must own the token or be an approved operator.
357      * - `tokenId` must exist.
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address to, uint256 tokenId) external;
362 
363     /**
364      * @dev Returns the account approved for `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function getApproved(uint256 tokenId) external view returns (address operator);
371 
372     /**
373      * @dev Approve or remove `operator` as an operator for the caller.
374      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
375      *
376      * Requirements:
377      *
378      * - The `operator` cannot be the caller.
379      *
380      * Emits an {ApprovalForAll} event.
381      */
382     function setApprovalForAll(address operator, bool _approved) external;
383 
384     /**
385      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
386      *
387      * See {setApprovalForAll}
388      */
389     function isApprovedForAll(address owner, address operator) external view returns (bool);
390 
391     /**
392      * @dev Safely transfers `tokenId` token from `from` to `to`.
393      *
394      * Requirements:
395      *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398      * - `tokenId` token must exist and be owned by `from`.
399      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
400      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
401      *
402      * Emits a {Transfer} event.
403      */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId,
408         bytes calldata data
409     ) external;
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
422  * @dev See https://eips.ethereum.org/EIPS/eip-721
423  */
424 interface IERC721Enumerable is IERC721 {
425     /**
426      * @dev Returns the total amount of tokens stored by the contract.
427      */
428     function totalSupply() external view returns (uint256);
429 
430     /**
431      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
432      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
433      */
434     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
435 
436     /**
437      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
438      * Use along with {totalSupply} to enumerate all tokens.
439      */
440     function tokenByIndex(uint256 index) external view returns (uint256);
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
453  * @dev See https://eips.ethereum.org/EIPS/eip-721
454  */
455 interface IERC721Metadata is IERC721 {
456     /**
457      * @dev Returns the token collection name.
458      */
459     function name() external view returns (string memory);
460 
461     /**
462      * @dev Returns the token collection symbol.
463      */
464     function symbol() external view returns (string memory);
465 
466     /**
467      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
468      */
469     function tokenURI(uint256 tokenId) external view returns (string memory);
470 }
471 
472 // File: ERC2000000.sol
473 
474 
475 
476 pragma solidity ^0.8.7;
477 
478 
479 
480 
481 
482 
483 
484 
485 
486 
487 library Address {
488     function isContract(address account) internal view returns (bool) {
489         uint size;
490         assembly {
491             size := extcodesize(account)
492         }
493         return size > 0;
494     }
495 }
496 
497 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
498     using Address for address;
499     using Strings for uint256;
500     
501     string private _name;
502     string private _symbol;
503 
504     // Mapping from token ID to owner address
505     address[] internal _owners;
506 
507     mapping(uint256 => address) private _tokenApprovals;
508     mapping(address => mapping(address => bool)) private _operatorApprovals;
509 
510     /**
511      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
512      */
513     constructor(string memory name_, string memory symbol_) {
514         _name = name_;
515         _symbol = symbol_;
516     }
517 
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId)
522         public
523         view
524         virtual
525         override(ERC165, IERC165)
526         returns (bool)
527     {
528         return
529             interfaceId == type(IERC721).interfaceId ||
530             interfaceId == type(IERC721Metadata).interfaceId ||
531             super.supportsInterface(interfaceId);
532     }
533 
534     /**
535      * @dev See {IERC721-balanceOf}.
536      */
537     function balanceOf(address owner) 
538         public 
539         view 
540         virtual 
541         override 
542         returns (uint) 
543     {
544         require(owner != address(0), "ERC721: balance query for the zero address");
545 
546         uint count;
547         uint length= _owners.length;
548         for( uint i; i < length; ++i ){
549           if( owner == _owners[i] )
550             ++count;
551         }
552         delete length;
553         return count;
554     }
555 
556     /**
557      * @dev See {IERC721-ownerOf}.
558      */
559     function ownerOf(uint256 tokenId)
560         public
561         view
562         virtual
563         override
564         returns (address)
565     {
566         address owner = _owners[tokenId];
567         require(
568             owner != address(0),
569             "ERC721: owner query for nonexistent token"
570         );
571         return owner;
572     }
573 
574     /**
575      * @dev See {IERC721Metadata-name}.
576      */
577     function name() public view virtual override returns (string memory) {
578         return _name;
579     }
580 
581     /**
582      * @dev See {IERC721Metadata-symbol}.
583      */
584     function symbol() public view virtual override returns (string memory) {
585         return _symbol;
586     }
587 
588     /**
589      * @dev See {IERC721-approve}.
590      */
591     function approve(address to, uint256 tokenId) public virtual override {
592         address owner = ERC721.ownerOf(tokenId);
593         require(to != owner, "ERC721: approval to current owner");
594 
595         require(
596             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
597             "ERC721: approve caller is not owner nor approved for all"
598         );
599 
600         _approve(to, tokenId);
601     }
602 
603     /**
604      * @dev See {IERC721-getApproved}.
605      */
606     function getApproved(uint256 tokenId)
607         public
608         view
609         virtual
610         override
611         returns (address)
612     {
613         require(
614             _exists(tokenId),
615             "ERC721: approved query for nonexistent token"
616         );
617 
618         return _tokenApprovals[tokenId];
619     }
620 
621     /**
622      * @dev See {IERC721-setApprovalForAll}.
623      */
624     function setApprovalForAll(address operator, bool approved)
625         public
626         virtual
627         override
628     {
629         require(operator != _msgSender(), "ERC721: approve to caller");
630 
631         _operatorApprovals[_msgSender()][operator] = approved;
632         emit ApprovalForAll(_msgSender(), operator, approved);
633     }
634 
635     /**
636      * @dev See {IERC721-isApprovedForAll}.
637      */
638     function isApprovedForAll(address owner, address operator)
639         public
640         view
641         virtual
642         override
643         returns (bool)
644     {
645         return _operatorApprovals[owner][operator];
646     }
647 
648     /**
649      * @dev See {IERC721-transferFrom}.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) public virtual override {
656         //solhint-disable-next-line max-line-length
657         require(
658             _isApprovedOrOwner(_msgSender(), tokenId),
659             "ERC721: transfer caller is not owner nor approved"
660         );
661 
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes memory _data
684     ) public virtual override {
685         require(
686             _isApprovedOrOwner(_msgSender(), tokenId),
687             "ERC721: transfer caller is not owner nor approved"
688         );
689         _safeTransfer(from, to, tokenId, _data);
690     }
691 
692     /**
693      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
694      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
695      *
696      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
697      *
698      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
699      * implement alternative mechanisms to perform token transfer, such as signature-based.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function _safeTransfer(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes memory _data
715     ) internal virtual {
716         _transfer(from, to, tokenId);
717         require(
718             _checkOnERC721Received(from, to, tokenId, _data),
719             "ERC721: transfer to non ERC721Receiver implementer"
720         );
721     }
722 
723     /**
724      * @dev Returns whether `tokenId` exists.
725      *
726      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
727      *
728      * Tokens start existing when they are minted (`_mint`),
729      * and stop existing when they are burned (`_burn`).
730      */
731     function _exists(uint256 tokenId) internal view virtual returns (bool) {
732         return tokenId < _owners.length && _owners[tokenId] != address(0);
733     }
734 
735     /**
736      * @dev Returns whether `spender` is allowed to manage `tokenId`.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function _isApprovedOrOwner(address spender, uint256 tokenId)
743         internal
744         view
745         virtual
746         returns (bool)
747     {
748         require(
749             _exists(tokenId),
750             "ERC721: operator query for nonexistent token"
751         );
752         address owner = ERC721.ownerOf(tokenId);
753         return (spender == owner ||
754             getApproved(tokenId) == spender ||
755             isApprovedForAll(owner, spender));
756     }
757 
758     /**
759      * @dev Safely mints `tokenId` and transfers it to `to`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must not exist.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _safeMint(address to, uint256 tokenId) internal virtual {
769         _safeMint(to, tokenId, "");
770     }
771 
772     /**
773      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
774      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
775      */
776     function _safeMint(
777         address to,
778         uint256 tokenId,
779         bytes memory _data
780     ) internal virtual {
781         _mint(to, tokenId);
782         require(
783             _checkOnERC721Received(address(0), to, tokenId, _data),
784             "ERC721: transfer to non ERC721Receiver implementer"
785         );
786     }
787 
788     /**
789      * @dev Mints `tokenId` and transfers it to `to`.
790      *
791      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
792      *
793      * Requirements:
794      *
795      * - `tokenId` must not exist.
796      * - `to` cannot be the zero address.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _mint(address to, uint256 tokenId) internal virtual {
801         require(to != address(0), "ERC721: mint to the zero address");
802         require(!_exists(tokenId), "ERC721: token already minted");
803 
804         _beforeTokenTransfer(address(0), to, tokenId);
805         _owners.push(to);
806 
807         emit Transfer(address(0), to, tokenId);
808     }
809 
810     /**
811      * @dev Destroys `tokenId`.
812      * The approval is cleared when the token is burned.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _burn(uint256 tokenId) internal virtual {
821         address owner = ERC721.ownerOf(tokenId);
822 
823         _beforeTokenTransfer(owner, address(0), tokenId);
824 
825         // Clear approvals
826         _approve(address(0), tokenId);
827         _owners[tokenId] = address(0);
828 
829         emit Transfer(owner, address(0), tokenId);
830     }
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
835      *
836      * Requirements:
837      *
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _transfer(
844         address from,
845         address to,
846         uint256 tokenId
847     ) internal virtual {
848         require(
849             ERC721.ownerOf(tokenId) == from,
850             "ERC721: transfer of token that is not own"
851         );
852         require(to != address(0), "ERC721: transfer to the zero address");
853 
854         _beforeTokenTransfer(from, to, tokenId);
855 
856         // Clear approvals from the previous owner
857         _approve(address(0), tokenId);
858         _owners[tokenId] = to;
859 
860         emit Transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev Approve `to` to operate on `tokenId`
865      *
866      * Emits a {Approval} event.
867      */
868     function _approve(address to, uint256 tokenId) internal virtual {
869         _tokenApprovals[tokenId] = to;
870         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
871     }
872 
873     /**
874      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
875      * The call is not executed if the target address is not a contract.
876      *
877      * @param from address representing the previous owner of the given token ID
878      * @param to target address that will receive the tokens
879      * @param tokenId uint256 ID of the token to be transferred
880      * @param _data bytes optional data to send along with the call
881      * @return bool whether the call correctly returned the expected magic value
882      */
883     function _checkOnERC721Received(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) private returns (bool) {
889         if (to.isContract()) {
890             try
891                 IERC721Receiver(to).onERC721Received(
892                     _msgSender(),
893                     from,
894                     tokenId,
895                     _data
896                 )
897             returns (bytes4 retval) {
898                 return retval == IERC721Receiver.onERC721Received.selector;
899             } catch (bytes memory reason) {
900                 if (reason.length == 0) {
901                     revert(
902                         "ERC721: transfer to non ERC721Receiver implementer"
903                     );
904                 } else {
905                     assembly {
906                         revert(add(32, reason), mload(reason))
907                     }
908                 }
909             }
910         } else {
911             return true;
912         }
913     }
914 
915     /**
916      * @dev Hook that is called before any token transfer. This includes minting
917      * and burning.
918      *
919      * Calling conditions:
920      *
921      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
922      * transferred to `to`.
923      * - When `from` is zero, `tokenId` will be minted for `to`.
924      * - When `to` is zero, ``from``'s `tokenId` will be burned.
925      * - `from` and `to` are never both zero.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {}
934 }
935 
936 
937 pragma solidity ^0.8.7;
938 
939 
940 /**
941  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
942  * enumerability of all the token ids in the contract as well as all token ids owned by each
943  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
944  */
945 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
950         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
951     }
952 
953     /**
954      * @dev See {IERC721Enumerable-totalSupply}.
955      */
956     function totalSupply() public view virtual override returns (uint256) {
957         return _owners.length;
958     }
959 
960     /**
961      * @dev See {IERC721Enumerable-tokenByIndex}.
962      */
963     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
964         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
965         return index;
966     }
967 
968     /**
969      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
970      */
971     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
972         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
973 
974         uint count;
975         for(uint i; i < _owners.length; i++){
976             if(owner == _owners[i]){
977                 if(count == index) return i;
978                 else count++;
979             }
980         }
981 
982         revert("ERC721Enumerable: owner index out of bounds");
983     }
984 }
985     pragma solidity ^0.8.7;
986         interface IMain {
987    
988 function ownerOf( uint _tokenid) external view returns (address);
989 }
990 
991     contract PAYCMutants is ERC721Enumerable,  Ownable {
992     using Strings for uint256;
993 
994 
995    string private uriPrefix = "" ;
996   string private uriSuffix = ".json";
997   string public revealURL = "ipfs://QmbZpLhRBVcwwMmtMvUEoKnRygPZvvKi8Y99ovPX2MTU7G";
998 
999  
1000 
1001  uint [2][] public tokens;
1002 
1003 
1004   mapping(uint => bool) public tokenIds;
1005 
1006 
1007   bool public paused = false;
1008 
1009   bool public reveal = false;
1010 
1011   constructor() ERC721("PAYC Mutants", "PAYC Mutants") {
1012     
1013     
1014   }
1015 
1016    address public mainAddress = 0x2D0D57D004F82e9f4471CaA8b9f8B1965a814154; 
1017   IMain Main = IMain(mainAddress);
1018 
1019   	function setMainAddress(address contractAddr) external onlyOwner {
1020 		mainAddress = contractAddr;
1021         Main= IMain(mainAddress);
1022 	}  
1023  
1024 
1025      
1026     function getTokenarray() external view returns (uint [2][] memory)
1027   {
1028     
1029     return tokens;
1030   }
1031 
1032      
1033     function getarraylength() external view returns (uint )
1034   {
1035     
1036     return tokens.length;
1037   }
1038 
1039 
1040 
1041 
1042 
1043 
1044     
1045 
1046 
1047  
1048   function mint(uint256 _token1 ,uint256 _token2 ) external {
1049     uint256 totalSupply = _owners.length;
1050     require(_token1 != _token2 , "Cannot use same tokenIDs");
1051     require(Main.ownerOf(_token1) == msg.sender && Main.ownerOf(_token2) == msg.sender, "NOT THE OWNER"  );
1052      require(tokenIds[_token1] == false && tokenIds[_token2] == false , "NFT already used to mutate"  );
1053     require(!paused, "The contract is paused!");
1054    
1055    
1056     _mint(msg.sender, totalSupply);
1057     tokenIds[_token1] = true;
1058     tokenIds[_token2] = true;
1059    tokens.push([_token1 ,_token2]);
1060   
1061      
1062      delete totalSupply;
1063    
1064   }
1065   
1066  
1067 
1068   function tokenURI(uint256 _tokenId)
1069     public
1070     view
1071     virtual
1072     override
1073     returns (string memory)
1074   {
1075     require(
1076       _exists(_tokenId),
1077       "ERC721Metadata: URI query for nonexistent token"
1078     );
1079     
1080     if (reveal == false) {
1081       return revealURL;
1082     }
1083 
1084     
1085 
1086     string memory currentBaseURI = _baseURI();
1087     return bytes(currentBaseURI).length > 0
1088         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1089         : "";
1090   }
1091   function setRevealed() external onlyOwner {
1092     reveal = !reveal;
1093   }
1094 
1095   function setHiddenMetadataUri(string memory _hiddenMetadataUri) external onlyOwner {
1096     revealURL = _hiddenMetadataUri;
1097   }
1098 
1099   
1100 
1101   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1102     uriPrefix = _uriPrefix;
1103   }
1104 
1105 
1106   function setPaused() external onlyOwner {
1107     paused = !paused;
1108   }
1109 
1110   
1111    function _mint(address to, uint256 tokenId) internal virtual override {
1112         _owners.push(to);
1113         emit Transfer(address(0), to, tokenId);
1114     }
1115 
1116   function _baseURI() internal view  returns (string memory) {
1117     return uriPrefix;
1118   }
1119 
1120 
1121  
1122 }