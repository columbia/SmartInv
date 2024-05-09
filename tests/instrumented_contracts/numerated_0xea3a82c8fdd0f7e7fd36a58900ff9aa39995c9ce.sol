1 // SPDX-License-Identifier: MIT
2 //PAYC Frogtober
3 
4 pragma solidity ^0.8.0;
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36 }
37 
38 // File: @openzeppelin/contracts/utils/Context.sol
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/access/Ownable.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @title ERC721 token receiver interface
152  * @dev Interface for any contract that wants to support safeTransfers
153  * from ERC721 asset contracts.
154  */
155 interface IERC721Receiver {
156     /**
157      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
158      * by `operator` from `from`, this function is called.
159      *
160      * It must return its Solidity selector to confirm the token transfer.
161      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
162      *
163      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
164      */
165     function onERC721Received(
166         address operator,
167         address from,
168         uint256 tokenId,
169         bytes calldata data
170     ) external returns (bytes4);
171 }
172 
173 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC165 standard, as defined in the
182  * https://eips.ethereum.org/EIPS/eip-165[EIP].
183  *
184  * Implementers can declare support of contract interfaces, which can then be
185  * queried by others ({ERC165Checker}).
186  *
187  * For an implementation, see {ERC165}.
188  */
189 interface IERC165 {
190     /**
191      * @dev Returns true if this contract implements the interface defined by
192      * `interfaceId`. See the corresponding
193      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
194      * to learn more about how these ids are created.
195      *
196      * This function call must use less than 30 000 gas.
197      */
198     function supportsInterface(bytes4 interfaceId) external view returns (bool);
199 }
200 
201 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Implementation of the {IERC165} interface.
211  *
212  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
213  * for the additional interface id that will be supported. For example:
214  *
215  * ```solidity
216  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
218  * }
219  * ```
220  *
221  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
222  */
223 abstract contract ERC165 is IERC165 {
224     /**
225      * @dev See {IERC165-supportsInterface}.
226      */
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Required interface of an ERC721 compliant contract.
242  */
243 interface IERC721 is IERC165 {
244     /**
245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
251      */
252     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
256      */
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
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
335     function getApproved(uint256 tokenId) external view returns (address operator);
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
354     function isApprovedForAll(address owner, address operator) external view returns (bool);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
387  * @dev See https://eips.ethereum.org/EIPS/eip-721
388  */
389 interface IERC721Enumerable is IERC721 {
390     /**
391      * @dev Returns the total amount of tokens stored by the contract.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
397      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
398      */
399     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
400 
401     /**
402      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
403      * Use along with {totalSupply} to enumerate all tokens.
404      */
405     function tokenByIndex(uint256 index) external view returns (uint256);
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
418  * @dev See https://eips.ethereum.org/EIPS/eip-721
419  */
420 interface IERC721Metadata is IERC721 {
421     /**
422      * @dev Returns the token collection name.
423      */
424     function name() external view returns (string memory);
425 
426     /**
427      * @dev Returns the token collection symbol.
428      */
429     function symbol() external view returns (string memory);
430 
431     /**
432      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
433      */
434     function tokenURI(uint256 tokenId) external view returns (string memory);
435 }
436 
437 // File: ERC2000000.sol
438 
439 
440 
441 pragma solidity ^0.8.7;
442 
443 
444 
445 
446 
447 
448 
449 
450 
451 
452 library Address {
453     function isContract(address account) internal view returns (bool) {
454         uint size;
455         assembly {
456             size := extcodesize(account)
457         }
458         return size > 0;
459     }
460 }
461 
462 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
463     using Address for address;
464     using Strings for uint256;
465     
466     string private _name;
467     string private _symbol;
468 
469     // Mapping from token ID to owner address
470     address[] internal _owners;
471 
472     mapping(uint256 => address) private _tokenApprovals;
473     mapping(address => mapping(address => bool)) private _operatorApprovals;
474 
475     /**
476      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
477      */
478     constructor(string memory name_, string memory symbol_) {
479         _name = name_;
480         _symbol = symbol_;
481     }
482 
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId)
487         public
488         view
489         virtual
490         override(ERC165, IERC165)
491         returns (bool)
492     {
493         return
494             interfaceId == type(IERC721).interfaceId ||
495             interfaceId == type(IERC721Metadata).interfaceId ||
496             super.supportsInterface(interfaceId);
497     }
498 
499     /**
500      * @dev See {IERC721-balanceOf}.
501      */
502     function balanceOf(address owner) 
503         public 
504         view 
505         virtual 
506         override 
507         returns (uint) 
508     {
509         require(owner != address(0), "ERC721: balance query for the zero address");
510 
511         uint count;
512         uint length= _owners.length;
513         for( uint i; i < length; ++i ){
514           if( owner == _owners[i] )
515             ++count;
516         }
517         delete length;
518         return count;
519     }
520 
521     /**
522      * @dev See {IERC721-ownerOf}.
523      */
524     function ownerOf(uint256 tokenId)
525         public
526         view
527         virtual
528         override
529         returns (address)
530     {
531         address owner = _owners[tokenId];
532         require(
533             owner != address(0),
534             "ERC721: owner query for nonexistent token"
535         );
536         return owner;
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-name}.
541      */
542     function name() public view virtual override returns (string memory) {
543         return _name;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-symbol}.
548      */
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev See {IERC721-approve}.
555      */
556     function approve(address to, uint256 tokenId) public virtual override {
557         address owner = ERC721.ownerOf(tokenId);
558         require(to != owner, "ERC721: approval to current owner");
559 
560         require(
561             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
562             "ERC721: approve caller is not owner nor approved for all"
563         );
564 
565         _approve(to, tokenId);
566     }
567 
568     /**
569      * @dev See {IERC721-getApproved}.
570      */
571     function getApproved(uint256 tokenId)
572         public
573         view
574         virtual
575         override
576         returns (address)
577     {
578         require(
579             _exists(tokenId),
580             "ERC721: approved query for nonexistent token"
581         );
582 
583         return _tokenApprovals[tokenId];
584     }
585 
586     /**
587      * @dev See {IERC721-setApprovalForAll}.
588      */
589     function setApprovalForAll(address operator, bool approved)
590         public
591         virtual
592         override
593     {
594         require(operator != _msgSender(), "ERC721: approve to caller");
595 
596         _operatorApprovals[_msgSender()][operator] = approved;
597         emit ApprovalForAll(_msgSender(), operator, approved);
598     }
599 
600     /**
601      * @dev See {IERC721-isApprovedForAll}.
602      */
603     function isApprovedForAll(address owner, address operator)
604         public
605         view
606         virtual
607         override
608         returns (bool)
609     {
610         return _operatorApprovals[owner][operator];
611     }
612 
613     /**
614      * @dev See {IERC721-transferFrom}.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) public virtual override {
621           require(
622             _isApprovedOrOwner(_msgSender(), tokenId),
623             "ERC721: transfer caller is not owner nor approved"
624         );
625 
626         _transfer(from, to, tokenId);
627       
628     }
629      
630        function pepetransferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) internal {
635         //solhint-disable-next-line max-line-length
636        // require(
637       //      _isApprovedOrOwner(_msgSender(), tokenId),
638       //      "ERC721: transfer caller is not owner nor approved"
639       //  );
640       _beforeTokenTransferpepe(from , to ,tokenId);
641          require(
642             ERC721.ownerOf(tokenId) == from,
643             "ERC721: transfer of token that is not own"
644         );
645 
646       _approve(address(0), tokenId);
647         _owners[tokenId] = to;
648 
649         emit Transfer(from, to, tokenId);
650     }
651      
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) public virtual override {
660         safeTransferFrom(from, to, tokenId, "");
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) public virtual override {
672       require(
673             _isApprovedOrOwner(_msgSender(), tokenId),
674             "ERC721: transfer caller is not owner nor approved"
675         );
676         _safeTransfer(from, to, tokenId, _data);
677         
678       
679     }
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
683      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
684      *
685      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
686      *
687      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
688      * implement alternative mechanisms to perform token transfer, such as signature-based.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function _safeTransfer(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) internal virtual {
705         _transfer(from, to, tokenId);
706        
707         require(
708             _checkOnERC721Received(from, to, tokenId, _data),
709             "ERC721: transfer to non ERC721Receiver implementer"
710         );
711 
712     }
713 
714     /**
715      * @dev Returns whether `tokenId` exists.
716      *
717      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
718      *
719      * Tokens start existing when they are minted (`_mint`),
720      * and stop existing when they are burned (`_burn`).
721      */
722     function _exists(uint256 tokenId) internal view virtual returns (bool) {
723         return tokenId < _owners.length && _owners[tokenId] != address(0);
724     }
725 
726     /**
727      * @dev Returns whether `spender` is allowed to manage `tokenId`.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function _isApprovedOrOwner(address spender, uint256 tokenId)
734         internal
735         view
736         virtual
737         returns (bool)
738     {
739         require(
740             _exists(tokenId),
741             "ERC721: operator query for nonexistent token"
742         );
743         address owner = ERC721.ownerOf(tokenId);
744         return (spender == owner ||
745             getApproved(tokenId) == spender ||
746             isApprovedForAll(owner, spender));
747     }
748 
749     /**
750      * @dev Safely mints `tokenId` and transfers it to `to`.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must not exist.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _safeMint(address to, uint256 tokenId) internal virtual {
760         _safeMint(to, tokenId, "");
761     }
762 
763     /**
764      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
765      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
766      */
767     function _safeMint(
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) internal virtual {
772         _mint(to, tokenId);
773         require(
774             _checkOnERC721Received(address(0), to, tokenId, _data),
775             "ERC721: transfer to non ERC721Receiver implementer"
776         );
777     }
778 
779     /**
780      * @dev Mints `tokenId` and transfers it to `to`.
781      *
782      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - `to` cannot be the zero address.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _mint(address to, uint256 tokenId) internal virtual {
792         require(to != address(0), "ERC721: mint to the zero address");
793         require(!_exists(tokenId), "ERC721: token already minted");
794 
795       
796         _owners.push(to);
797 
798         emit Transfer(address(0), to, tokenId);
799     }
800 
801     /**
802      * @dev Destroys `tokenId`.
803      * The approval is cleared when the token is burned.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _burn(uint256 tokenId) internal virtual {
812         address owner = ERC721.ownerOf(tokenId);
813 
814         _beforeTokenTransfer(owner, address(0), tokenId);
815 
816         // Clear approvals
817         _approve(address(0), tokenId);
818         _owners[tokenId] = address(0);
819 
820         emit Transfer(owner, address(0), tokenId);
821     }
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _transfer(
835         address from,
836         address to,
837         uint256 tokenId
838     ) internal virtual {
839         require(
840             ERC721.ownerOf(tokenId) == from,
841             "ERC721: transfer of token that is not own"
842         );
843         require(to != address(0), "ERC721: transfer to the zero address");
844 
845         _beforeTokenTransfer(from, to, tokenId);
846 
847         // Clear approvals from the previous owner
848         _approve(address(0), tokenId);
849         _owners[tokenId] = to;
850 
851         emit Transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev Approve `to` to operate on `tokenId`
856      *
857      * Emits a {Approval} event.
858      */
859     function _approve(address to, uint256 tokenId) internal virtual {
860         _tokenApprovals[tokenId] = to;
861         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
862     }
863 
864     /**
865      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
866      * The call is not executed if the target address is not a contract.
867      *
868      * @param from address representing the previous owner of the given token ID
869      * @param to target address that will receive the tokens
870      * @param tokenId uint256 ID of the token to be transferred
871      * @param _data bytes optional data to send along with the call
872      * @return bool whether the call correctly returned the expected magic value
873      */
874     function _checkOnERC721Received(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) private returns (bool) {
880         if (to.isContract()) {
881             try
882                 IERC721Receiver(to).onERC721Received(
883                     _msgSender(),
884                     from,
885                     tokenId,
886                     _data
887                 )
888             returns (bytes4 retval) {
889                 return retval == IERC721Receiver.onERC721Received.selector;
890             } catch (bytes memory reason) {
891                 if (reason.length == 0) {
892                     revert(
893                         "ERC721: transfer to non ERC721Receiver implementer"
894                     );
895                 } else {
896                     assembly {
897                         revert(add(32, reason), mload(reason))
898                     }
899                 }
900             }
901         } else {
902             return true;
903         }
904     }
905 
906     /**
907      * @dev Hook that is called before any token transfer. This includes minting
908      * and burning.
909      *
910      * Calling conditions:
911      *
912      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
913      * transferred to `to`.
914      * - When `from` is zero, `tokenId` will be minted for `to`.
915      * - When `to` is zero, ``from``'s `tokenId` will be burned.
916      * - `from` and `to` are never both zero.
917      *
918      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
919      */
920     function _beforeTokenTransfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {}
925       function _beforeTokenTransferpepe(
926         address from,
927         address to,
928         uint256 tokenId
929     ) internal virtual {}
930 }
931 
932 
933 pragma solidity ^0.8.7;
934 
935 
936 /**
937  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
938  * enumerability of all the token ids in the contract as well as all token ids owned by each
939  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
940  */
941 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
942     /**
943      * @dev See {IERC165-supportsInterface}.
944      */
945     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
946         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
947     }
948 
949     /**
950      * @dev See {IERC721Enumerable-totalSupply}.
951      */
952     function totalSupply() public view virtual override returns (uint256) {
953         return _owners.length;
954     }
955 
956     /**
957      * @dev See {IERC721Enumerable-tokenByIndex}.
958      */
959     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
960         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
961         return index;
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
968         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
969 
970         uint count;
971         for(uint i; i < _owners.length; i++){
972             if(owner == _owners[i]){
973                 if(count == index) return i;
974                 else count++;
975             }
976         }
977 
978         revert("ERC721Enumerable: owner index out of bounds");
979     }
980 }
981     pragma solidity ^0.8.7;
982 
983     interface IMain {
984    
985 function transferFrom( address from,   address to, uint256 tokenId) external;
986 function ownerOf( uint _tokenid) external view returns (address);
987 }
988 
989     contract PAYCFrogtober  is ERC721Enumerable,  Ownable {
990     using Strings for uint256;
991 
992 
993   string private uriPrefix = "ipfs://QmW2Q6zT2sZzmopJSzPxw67BLm3ATKijSCzuzHqrUo5cxE/";
994   string private uriSuffix = ".json";
995 
996   uint16 public constant maxSupply = 7777;
997   uint public cost = 0 ether;
998 
999    mapping (uint => bool) public minted;
1000   
1001 
1002   
1003   mapping (uint => uint) public mappingOldtoNewTokens;
1004   mapping (uint => uint) public mappingNewtoOldTokens;
1005  
1006 
1007   address public mainAddress = 0x2D0D57D004F82e9f4471CaA8b9f8B1965a814154;
1008   IMain Main = IMain(mainAddress);
1009 
1010   constructor() ERC721("PAYC Frogtober", "PAYC Frogtober") {
1011     
1012   }
1013   
1014 	function setMainAddress(address contractAddr) external onlyOwner {
1015 		mainAddress = contractAddr;
1016         Main= IMain(mainAddress);
1017 	}  
1018  
1019 
1020   function mint( uint tokenNumber) external payable {
1021      
1022           require(msg.value >= cost ,"Insufficient funds");
1023           require(minted[tokenNumber] == false , "Exchanged Already");
1024    
1025 
1026  
1027    uint16 totalSupply = uint16(_owners.length);
1028 
1029    
1030      Main.transferFrom( msg.sender, address(this),tokenNumber);
1031     _mint(msg.sender, totalSupply);
1032   
1033     mappingNewtoOldTokens[totalSupply] = tokenNumber;
1034     mappingOldtoNewTokens[tokenNumber] = totalSupply; 
1035     minted[tokenNumber] = true;
1036  
1037   }
1038 
1039  function _beforeTokenTransferpepe(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual override  {
1044         uint token =mappingNewtoOldTokens[tokenId];
1045         address _address = Main.ownerOf(token);
1046         address _caddress = address(this);
1047         require (from == _caddress || to ==  _caddress , "Transfer not Allowed");
1048         require (from == _address || to ==  _address , "Transfer not Allowed ");
1049         delete token;
1050     }
1051     
1052 
1053   function ExchangeOldForNew( uint tokenNumber ) external  {
1054 
1055  
1056  
1057   uint _token = mappingOldtoNewTokens[tokenNumber] ;
1058     address _caddress = address(this);
1059 
1060   
1061   Main.transferFrom(msg.sender, _caddress,tokenNumber);
1062   pepetransferFrom( _caddress, msg.sender,_token);
1063   
1064   }
1065 
1066   
1067 
1068    function ExchangeNewForOld( uint tokenNumber) external  {
1069 
1070  
1071 
1072   uint _token = mappingNewtoOldTokens[tokenNumber] ;
1073     address _caddress = address(this);
1074 
1075   Main.transferFrom( _caddress, msg.sender,_token);
1076   pepetransferFrom( msg.sender, _caddress,tokenNumber);
1077  
1078 
1079     
1080   }
1081   
1082 
1083   function checkIfNFTExist(uint256 _tokenId)
1084     public
1085     view
1086    returns (bool)
1087    {
1088     bool exist =   _exists(_tokenId);
1089     return exist;
1090    }
1091 
1092 
1093    
1094   function tokenURI(uint256 _tokenId)
1095     public
1096     view
1097     virtual
1098     override
1099     returns (string memory)
1100   {
1101     require(
1102       _exists(_tokenId),
1103       "ERC721Metadata: URI query for nonexistent token"
1104     );
1105   
1106 
1107     _tokenId = mappingNewtoOldTokens[_tokenId];
1108 
1109     string memory currentBaseURI = _baseURI();
1110     return bytes(currentBaseURI).length > 0
1111         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1112         : "";
1113   }
1114 
1115 
1116   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1117     uriPrefix = _uriPrefix;
1118   }
1119 
1120   function setCost(uint _cost) external onlyOwner {
1121     cost = _cost;
1122   }
1123 
1124 
1125 
1126 
1127 
1128  
1129  
1130 
1131   
1132    function _mint(address to, uint256 tokenId) internal virtual override {
1133         _owners.push(to);
1134         emit Transfer(address(0), to, tokenId);
1135     }
1136     
1137   function withdraw() external onlyOwner {
1138   uint _balance = address(this).balance;
1139      payable(msg.sender).transfer(_balance ); 
1140        
1141   }
1142 
1143 
1144   function _baseURI() internal view  returns (string memory) {
1145     return uriPrefix;
1146   }
1147 }