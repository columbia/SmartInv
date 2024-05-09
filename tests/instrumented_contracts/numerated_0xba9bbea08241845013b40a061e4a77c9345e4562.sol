1 pragma solidity 0.8.7;
2 
3 interface WnsRegistryInterface {
4     function getWnsAddress(string memory _label) external view returns (address);
5     function owner() external view returns (address);
6 }
7 
8 pragma solidity 0.8.7;
9 
10 abstract contract WnsRegistryImplementation is WnsRegistryInterface {
11     address WnsRegistry;
12 
13     constructor(address registry_) {
14         WnsRegistry = registry_;
15     }
16 
17     function getWnsAddress(string memory _label) public override view returns (address) {
18         WnsRegistryInterface wnsRegistry = WnsRegistryInterface(WnsRegistry);
19         return wnsRegistry.getWnsAddress(_label);
20     }
21 
22     function owner() public override view returns (address) {
23         WnsRegistryInterface wnsRegistry = WnsRegistryInterface(WnsRegistry);
24         return wnsRegistry.owner();
25     }
26 
27     function setRegistry(address _registry) public {
28         require(msg.sender == owner(), "Not authorized.");
29         WnsRegistry = _registry;
30     }
31 }
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 pragma solidity ^0.8.6;
57 
58 library Address {
59     function isContract(address account) internal view returns (bool) {
60         uint size;
61         assembly {
62             size := extcodesize(account)
63         }
64         return size > 0;
65     }
66 }
67 
68 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Implementation of the {IERC165} interface.
75  *
76  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
77  * for the additional interface id that will be supported. For example:
78  *
79  * ```solidity
80  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
81  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
82  * }
83  * ```
84  *
85  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
86  */
87 abstract contract ERC165 is IERC165 {
88     /**
89      * @dev See {IERC165-supportsInterface}.
90      */
91     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
92         return interfaceId == type(IERC165).interfaceId;
93     }
94 }
95 
96 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev String operations.
102  */
103 library Strings {
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
107      */
108     function toString(uint256 value) internal pure returns (string memory) {
109         // Inspired by OraclizeAPI's implementation - MIT licence
110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
111 
112         if (value == 0) {
113             return "0";
114         }
115         uint256 temp = value;
116         uint256 digits;
117         while (temp != 0) {
118             digits++;
119             temp /= 10;
120         }
121         bytes memory buffer = new bytes(digits);
122         while (value != 0) {
123             digits -= 1;
124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
125             value /= 10;
126         }
127         return string(buffer);
128     }
129 }
130 
131 
132 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 
137 /**
138  * @dev Required interface of an ERC721 compliant contract.
139  */
140 interface IERC721 is IERC165 {
141     /**
142      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in ``owner``'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Returns the account approved for `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function getApproved(uint256 tokenId) external view returns (address operator);
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId,
270         bytes calldata data
271     ) external;
272 }
273 
274 
275 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
282  * @dev See https://eips.ethereum.org/EIPS/eip-721
283  */
284 interface IERC721Metadata is IERC721 {
285     /**
286      * @dev Returns the token collection name.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the token collection symbol.
292      */
293     function symbol() external view returns (string memory);
294 
295     /**
296      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
297      */
298     function tokenURI(uint256 tokenId) external view returns (string memory);
299 }
300 
301 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 
329 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
336  * @dev See https://eips.ethereum.org/EIPS/eip-721
337  */
338 interface IERC721Enumerable is IERC721 {
339     /**
340      * @dev Returns the total amount of tokens stored by the contract.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
346      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
347      */
348     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
349 
350     /**
351      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
352      * Use along with {totalSupply} to enumerate all tokens.
353      */
354     function tokenByIndex(uint256 index) external view returns (uint256);
355 }
356 
357 pragma solidity ^0.8.7;
358 
359 abstract contract ERC721 is ERC165, IERC721, IERC721Metadata, WnsRegistryImplementation {
360     using Address for address;
361     using Strings for uint256;
362     
363     string private _name;
364     string private _symbol;
365     
366     // Mapping from token ID to owner address
367     address[] internal _owners;
368 
369     mapping(uint256 => address) private _tokenApprovals;
370     mapping(address => mapping(address => bool)) private _operatorApprovals;
371 
372     /**
373      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
374      */
375     constructor(string memory name_, string memory symbol_) {
376         _name = name_;
377         _symbol = symbol_;
378         
379     }
380 
381     /**
382      * @dev See {IERC165-supportsInterface}.
383      */
384     function supportsInterface(bytes4 interfaceId)
385         public
386         view
387         virtual
388         override(ERC165, IERC165)
389         returns (bool)
390     {
391         return
392             interfaceId == type(IERC721).interfaceId ||
393             interfaceId == type(IERC721Metadata).interfaceId ||
394             super.supportsInterface(interfaceId);
395     }
396 
397     /**
398      * @dev See {IERC721-balanceOf}.
399      */
400     function balanceOf(address owner) 
401         public 
402         view 
403         virtual 
404         override 
405         returns (uint) 
406     {
407         require(owner != address(0), "ERC721: balance query for the zero address");
408 
409         uint count;
410         for( uint i; i < _owners.length; ++i ){
411           if( owner == _owners[i] )
412             ++count;
413         }
414         return count;
415     }
416 
417     /**
418      * @dev See {IERC721-ownerOf}.
419      */
420     function ownerOf(uint256 tokenId)
421         public
422         view
423         virtual
424         override
425         returns (address)
426     {
427         address owner = _owners[tokenId];
428         require(
429             owner != address(0),
430             "ERC721: owner query for nonexistent token"
431         );
432         return owner;
433     }
434 
435     /**
436      * @dev See {IERC721Metadata-name}.
437      */
438     function name() public view virtual override returns (string memory) {
439         return _name;
440     }
441 
442     /**
443      * @dev See {IERC721Metadata-symbol}.
444      */
445     function symbol() public view virtual override returns (string memory) {
446         return _symbol;
447     }
448 
449     function _setNameSymbol(string memory name_, string memory symbol_) public {
450         require(msg.sender == owner(), "Not authorized.");
451         _name = name_;
452         _symbol = symbol_;
453     }
454 
455     /**
456      * @dev See {IERC721-approve}.
457      */
458     function approve(address to, uint256 tokenId) public virtual override {
459         address owner = ERC721.ownerOf(tokenId);
460         require(to != owner, "ERC721: approval to current owner");
461 
462         require(
463             msg.sender == owner || isApprovedForAll(owner, msg.sender),
464             "ERC721: approve caller is not owner nor approved for all"
465         );
466 
467         _approve(to, tokenId);
468     }
469 
470     /**
471      * @dev See {IERC721-getApproved}.
472      */
473     function getApproved(uint256 tokenId)
474         public
475         view
476         virtual
477         override
478         returns (address)
479     {
480         require(
481             _exists(tokenId),
482             "ERC721: approved query for nonexistent token"
483         );
484 
485         return _tokenApprovals[tokenId];
486     }
487 
488     /**
489      * @dev See {IERC721-setApprovalForAll}.
490      */
491     function setApprovalForAll(address operator, bool approved)
492         public
493         virtual
494         override
495     {
496         require(operator != msg.sender, "ERC721: approve to caller");
497 
498         _operatorApprovals[msg.sender][operator] = approved;
499         emit ApprovalForAll(msg.sender, operator, approved);
500     }
501 
502     /**
503      * @dev See {IERC721-isApprovedForAll}.
504      */
505     function isApprovedForAll(address owner, address operator)
506         public
507         view
508         virtual
509         override
510         returns (bool)
511     {
512         return _operatorApprovals[owner][operator];
513     }
514 
515     /**
516      * @dev See {IERC721-transferFrom}.
517      */
518     function transferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) public virtual override {
523         //solhint-disable-next-line max-line-length
524         require(
525             _isApprovedOrOwner(msg.sender, tokenId),
526             "ERC721: transfer caller is not owner nor approved"
527         );
528 
529         _transfer(from, to, tokenId);
530     }
531 
532     /**
533      * @dev See {IERC721-safeTransferFrom}.
534      */
535     function safeTransferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) public virtual override {
540         safeTransferFrom(from, to, tokenId, "");
541     }
542 
543     /**
544      * @dev See {IERC721-safeTransferFrom}.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId,
550         bytes memory _data
551     ) public virtual override {
552         require(
553             _isApprovedOrOwner(msg.sender, tokenId),
554             "ERC721: transfer caller is not owner nor approved"
555         );
556         _safeTransfer(from, to, tokenId, _data);
557     }
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
562      *
563      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
564      *
565      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
566      * implement alternative mechanisms to perform token transfer, such as signature-based.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function _safeTransfer(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes memory _data
582     ) internal virtual {
583         _transfer(from, to, tokenId);
584         require(
585             _checkOnERC721Received(from, to, tokenId, _data),
586             "ERC721: transfer to non ERC721Receiver implementer"
587         );
588     }
589 
590     /**
591      * @dev Returns whether `tokenId` exists.
592      *
593      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
594      *
595      * Tokens start existing when they are minted (`_mint`),
596      * and stop existing when they are burned (`_burn`).
597      */
598     function _exists(uint256 tokenId) internal view virtual returns (bool) {
599         return tokenId < _owners.length && _owners[tokenId] != address(0);
600     }
601 
602     /**
603      * @dev Returns whether `spender` is allowed to manage `tokenId`.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
610         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
611         address owner = ERC721.ownerOf(tokenId);
612         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender) || spender == getWnsAddress("_wnsMarketplace"));
613     }
614 
615     /**
616      * @dev Safely mints `tokenId` and transfers it to `to`.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must not exist.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function _safeMint(address to, uint256 tokenId) internal virtual {
626         _safeMint(to, tokenId, "");
627     }
628 
629     /**
630      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
631      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
632      */
633     function _safeMint(
634         address to,
635         uint256 tokenId,
636         bytes memory _data
637     ) internal virtual {
638         _mint(to, tokenId);
639         require(
640             _checkOnERC721Received(address(0), to, tokenId, _data),
641             "ERC721: transfer to non ERC721Receiver implementer"
642         );
643     }
644 
645     /**
646      * @dev Mints `tokenId` and transfers it to `to`.
647      *
648      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
649      *
650      * Requirements:
651      *
652      * - `tokenId` must not exist.
653      * - `to` cannot be the zero address.
654      *
655      * Emits a {Transfer} event.
656      */
657     function _mint(address to, uint256 tokenId) internal virtual {
658         require(to != address(0), "ERC721: mint to the zero address");
659         require(!_exists(tokenId), "ERC721: token already minted");
660 
661         _beforeTokenTransfer(address(0), to, tokenId);
662         _owners.push(to);
663         emit Transfer(address(0), to, tokenId);
664     }
665 
666     /**
667      * @dev Destroys `tokenId`.
668      * The approval is cleared when the token is burned.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      *
674      * Emits a {Transfer} event.
675      */
676     function _burn(uint256 tokenId) internal virtual {
677         address owner = ERC721.ownerOf(tokenId);
678 
679         _beforeTokenTransfer(owner, address(0), tokenId);
680 
681         // Clear approvals
682         _approve(address(0), tokenId);
683         _owners[tokenId] = address(0);
684 
685         emit Transfer(owner, address(0), tokenId);
686     }
687 
688     /**
689      * @dev Transfers `tokenId` from `from` to `to`.
690      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
691      *
692      * Requirements:
693      *
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must be owned by `from`.
696      *
697      * Emits a {Transfer} event.
698      */
699     function _transfer(
700         address from,
701         address to,
702         uint256 tokenId
703     ) internal virtual {
704         require(
705             ERC721.ownerOf(tokenId) == from,
706             "ERC721: transfer of token that is not own"
707         );
708         require(to != address(0), "ERC721: transfer to the zero address");
709 
710         _beforeTokenTransfer(from, to, tokenId);
711 
712         // Clear approvals from the previous owner
713         _approve(address(0), tokenId);
714         _owners[tokenId] = to;
715 
716         emit Transfer(from, to, tokenId);
717     }
718 
719     /**
720      * @dev Approve `to` to operate on `tokenId`
721      *
722      * Emits a {Approval} event.
723      */
724     function _approve(address to, uint256 tokenId) internal virtual {
725         _tokenApprovals[tokenId] = to;
726         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
727     }
728 
729     /**
730      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
731      * The call is not executed if the target address is not a contract.
732      *
733      * @param from address representing the previous owner of the given token ID
734      * @param to target address that will receive the tokens
735      * @param tokenId uint256 ID of the token to be transferred
736      * @param _data bytes optional data to send along with the call
737      * @return bool whether the call correctly returned the expected magic value
738      */
739     function _checkOnERC721Received(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) private returns (bool) {
745         if (to.isContract()) {
746             try
747                 IERC721Receiver(to).onERC721Received(
748                     msg.sender,
749                     from,
750                     tokenId,
751                     _data
752                 )
753             returns (bytes4 retval) {
754                 return retval == IERC721Receiver.onERC721Received.selector;
755             } catch (bytes memory reason) {
756                 if (reason.length == 0) {
757                     revert(
758                         "ERC721: transfer to non ERC721Receiver implementer"
759                     );
760                 } else {
761                     assembly {
762                         revert(add(32, reason), mload(reason))
763                     }
764                 }
765             }
766         } else {
767             return true;
768         }
769     }
770 
771     /**
772      * @dev Hook that is called before any token transfer. This includes minting
773      * and burning.
774      *
775      * Calling conditions:
776      *
777      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
778      * transferred to `to`.
779      * - When `from` is zero, `tokenId` will be minted for `to`.
780      * - When `to` is zero, ``from``'s `tokenId` will be burned.
781      * - `from` and `to` are never both zero.
782      *
783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
784      */
785     function _beforeTokenTransfer(
786         address from,
787         address to,
788         uint256 tokenId
789     ) internal virtual {}
790 }
791 
792 
793 pragma solidity ^0.8.7;
794 
795 /**
796  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
797  * enumerability of all the token ids in the contract as well as all token ids owned by each
798  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
799  */
800 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
805         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
806     }
807 
808     /**
809      * @dev See {IERC721Enumerable-totalSupply}.
810      */
811     function totalSupply() public view virtual override returns (uint256) {
812         return _owners.length;
813     }
814 
815     /**
816      * @dev See {IERC721Enumerable-tokenByIndex}.
817      */
818     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
819         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
820         return index;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
825      */
826     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
827         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
828 
829         uint count;
830         for(uint i; i < _owners.length; i++){
831             if(owner == _owners[i]){
832                 if(count == index) return i;
833                 else count++;
834             }
835         }
836 
837         revert("ERC721Enumerable: owner index out of bounds");
838     }
839 }
840 
841 
842 pragma solidity 0.8.7;
843 
844 abstract contract URI is ERC721Enumerable {
845 
846     string public baseURI;
847 
848     constructor(string memory _baseURI) {
849         baseURI = _baseURI;
850     }
851 
852     function setBaseURI(string memory _baseURI) public  {
853         baseURI = _baseURI;
854     }
855 
856     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
857         require(_exists(_tokenId), "Token does not exist.");
858         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
859     }
860 }
861 
862 // SPDX-License-Identifier: MIT
863 
864 pragma solidity 0.8.7;
865 
866 contract WnsErc721 is ERC721Enumerable, URI {
867 
868     constructor(address registry_, string memory _baseURI, string memory name_, string memory symbol_) ERC721(name_, symbol_) WnsRegistryImplementation(registry_) URI(_baseURI) {
869     }
870     
871     uint256 private nextTokenId;
872 
873     function getNextTokenId() public view returns (uint256) {
874         return nextTokenId;
875     }
876 
877     function mintErc721(address to) public {
878         require(msg.sender == getWnsAddress("_wnsRegistrar") || msg.sender == getWnsAddress("_wnsMigration"), "Caller is not authorized.");
879         _safeMint(to, nextTokenId);
880         nextTokenId += 1;
881     }
882 
883 }