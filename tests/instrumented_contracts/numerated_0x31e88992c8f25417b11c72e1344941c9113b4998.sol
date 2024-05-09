1 // File: @openzeppelin/contracts/access/Ownable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Enumerable is IERC721 {
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Implementation of the {IERC165} interface.
253  *
254  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
255  * for the additional interface id that will be supported. For example:
256  *
257  * ```solidity
258  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
259  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
260  * }
261  * ```
262  *
263  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
264  */
265 abstract contract ERC165 is IERC165 {
266     /**
267      * @dev See {IERC165-supportsInterface}.
268      */
269     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270         return interfaceId == type(IERC165).interfaceId;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
280  * the Metadata extension, but not including the Enumerable extension, which is available separately as
281  * {ERC721Enumerable}.
282  */
283 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
284     using Address for address;
285     using Strings for uint256;
286 
287     // Token name
288     string private _name;
289 
290     // Token symbol
291     string private _symbol;
292 
293     // Mapping from token ID to owner address
294     mapping(uint256 => address) private _owners;
295 
296     // Mapping owner address to token count
297     mapping(address => uint256) private _balances;
298 
299     // Mapping from token ID to approved address
300     mapping(uint256 => address) private _tokenApprovals;
301 
302     // Mapping from owner to operator approvals
303     mapping(address => mapping(address => bool)) private _operatorApprovals;
304 
305     /**
306      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
307      */
308     constructor(string memory name_, string memory symbol_) {
309         _name = name_;
310         _symbol = symbol_;
311     }
312 
313     /**
314      * @dev See {IERC165-supportsInterface}.
315      */
316     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
317         return
318             interfaceId == type(IERC721).interfaceId ||
319             interfaceId == type(IERC721Metadata).interfaceId ||
320             super.supportsInterface(interfaceId);
321     }
322 
323     /**
324      * @dev See {IERC721-balanceOf}.
325      */
326     function balanceOf(address owner) public view virtual override returns (uint256) {
327         require(owner != address(0), "ERC721: balance query for the zero address");
328         return _balances[owner];
329     }
330 
331     /**
332      * @dev See {IERC721-ownerOf}.
333      */
334     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
335         address owner = _owners[tokenId];
336         require(owner != address(0), "ERC721: owner query for nonexistent token");
337         return owner;
338     }
339 
340     /**
341      * @dev See {IERC721Metadata-name}.
342      */
343     function name() public view virtual override returns (string memory) {
344         return _name;
345     }
346 
347     /**
348      * @dev See {IERC721Metadata-symbol}.
349      */
350     function symbol() public view virtual override returns (string memory) {
351         return _symbol;
352     }
353 
354     /**
355      * @dev See {IERC721Metadata-tokenURI}.
356      */
357     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
358         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
359 
360         string memory baseURI = _baseURI();
361         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
362     }
363 
364     /**
365      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
366      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
367      * by default, can be overriden in child contracts.
368      */
369     function _baseURI() internal view virtual returns (string memory) {
370         return "";
371     }
372 
373     /**
374      * @dev See {IERC721-approve}.
375      */
376     function approve(address to, uint256 tokenId) public virtual override {
377         address owner = ERC721.ownerOf(tokenId);
378         require(to != owner, "ERC721: approval to current owner");
379 
380         require(
381             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
382             "ERC721: approve caller is not owner nor approved for all"
383         );
384 
385         _approve(to, tokenId);
386     }
387 
388     /**
389      * @dev See {IERC721-getApproved}.
390      */
391     function getApproved(uint256 tokenId) public view virtual override returns (address) {
392         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
393 
394         return _tokenApprovals[tokenId];
395     }
396 
397     /**
398      * @dev See {IERC721-setApprovalForAll}.
399      */
400     function setApprovalForAll(address operator, bool approved) public virtual override {
401         require(operator != _msgSender(), "ERC721: approve to caller");
402 
403         _operatorApprovals[_msgSender()][operator] = approved;
404         emit ApprovalForAll(_msgSender(), operator, approved);
405     }
406 
407     /**
408      * @dev See {IERC721-isApprovedForAll}.
409      */
410     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
411         return _operatorApprovals[owner][operator];
412     }
413 
414     /**
415      * @dev See {IERC721-transferFrom}.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) public virtual override {
422         //solhint-disable-next-line max-line-length
423         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
424 
425         _transfer(from, to, tokenId);
426     }
427 
428     /**
429      * @dev See {IERC721-safeTransferFrom}.
430      */
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) public virtual override {
436         safeTransferFrom(from, to, tokenId, "");
437     }
438 
439     /**
440      * @dev See {IERC721-safeTransferFrom}.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes memory _data
447     ) public virtual override {
448         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
449         _safeTransfer(from, to, tokenId, _data);
450     }
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
454      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
455      *
456      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
457      *
458      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
459      * implement alternative mechanisms to perform token transfer, such as signature-based.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function _safeTransfer(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes memory _data
475     ) internal virtual {
476         _transfer(from, to, tokenId);
477         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
478     }
479 
480     /**
481      * @dev Returns whether `tokenId` exists.
482      *
483      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
484      *
485      * Tokens start existing when they are minted (`_mint`),
486      * and stop existing when they are burned (`_burn`).
487      */
488     function _exists(uint256 tokenId) internal view virtual returns (bool) {
489         return _owners[tokenId] != address(0);
490     }
491 
492     /**
493      * @dev Returns whether `spender` is allowed to manage `tokenId`.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
500         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
501         address owner = ERC721.ownerOf(tokenId);
502         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
503     }
504 
505     /**
506      * @dev Safely mints `tokenId` and transfers it to `to`.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must not exist.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function _safeMint(address to, uint256 tokenId) internal virtual {
516         _safeMint(to, tokenId, "");
517     }
518 
519     /**
520      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
521      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
522      */
523     function _safeMint(
524         address to,
525         uint256 tokenId,
526         bytes memory _data
527     ) internal virtual {
528         _mint(to, tokenId);
529         require(
530             _checkOnERC721Received(address(0), to, tokenId, _data),
531             "ERC721: transfer to non ERC721Receiver implementer"
532         );
533     }
534 
535     /**
536      * @dev Mints `tokenId` and transfers it to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
539      *
540      * Requirements:
541      *
542      * - `tokenId` must not exist.
543      * - `to` cannot be the zero address.
544      *
545      * Emits a {Transfer} event.
546      */
547     function _mint(address to, uint256 tokenId) internal virtual {
548         require(to != address(0), "ERC721: mint to the zero address");
549         require(!_exists(tokenId), "ERC721: token already minted");
550 
551         _beforeTokenTransfer(address(0), to, tokenId);
552 
553         _balances[to] += 1;
554         _owners[tokenId] = to;
555 
556         emit Transfer(address(0), to, tokenId);
557     }
558 
559     /**
560      * @dev Destroys `tokenId`.
561      * The approval is cleared when the token is burned.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      *
567      * Emits a {Transfer} event.
568      */
569     function _burn(uint256 tokenId) internal virtual {
570         address owner = ERC721.ownerOf(tokenId);
571 
572         _beforeTokenTransfer(owner, address(0), tokenId);
573 
574         // Clear approvals
575         _approve(address(0), tokenId);
576 
577         _balances[owner] -= 1;
578         delete _owners[tokenId];
579 
580         emit Transfer(owner, address(0), tokenId);
581     }
582 
583     /**
584      * @dev Transfers `tokenId` from `from` to `to`.
585      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
586      *
587      * Requirements:
588      *
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      *
592      * Emits a {Transfer} event.
593      */
594     function _transfer(
595         address from,
596         address to,
597         uint256 tokenId
598     ) internal virtual {
599         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
600         require(to != address(0), "ERC721: transfer to the zero address");
601 
602         _beforeTokenTransfer(from, to, tokenId);
603 
604         // Clear approvals from the previous owner
605         _approve(address(0), tokenId);
606 
607         _balances[from] -= 1;
608         _balances[to] += 1;
609         _owners[tokenId] = to;
610 
611         emit Transfer(from, to, tokenId);
612     }
613 
614     /**
615      * @dev Approve `to` to operate on `tokenId`
616      *
617      * Emits a {Approval} event.
618      */
619     function _approve(address to, uint256 tokenId) internal virtual {
620         _tokenApprovals[tokenId] = to;
621         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
622     }
623 
624     /**
625      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
626      * The call is not executed if the target address is not a contract.
627      *
628      * @param from address representing the previous owner of the given token ID
629      * @param to target address that will receive the tokens
630      * @param tokenId uint256 ID of the token to be transferred
631      * @param _data bytes optional data to send along with the call
632      * @return bool whether the call correctly returned the expected magic value
633      */
634     function _checkOnERC721Received(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes memory _data
639     ) private returns (bool) {
640         if (to.isContract()) {
641             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
642                 return retval == IERC721Receiver(to).onERC721Received.selector;
643             } catch (bytes memory reason) {
644                 if (reason.length == 0) {
645                     revert("ERC721: transfer to non ERC721Receiver implementer");
646                 } else {
647                     assembly {
648                         revert(add(32, reason), mload(reason))
649                     }
650                 }
651             }
652         } else {
653             return true;
654         }
655     }
656 
657     /**
658      * @dev Hook that is called before any token transfer. This includes minting
659      * and burning.
660      *
661      * Calling conditions:
662      *
663      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
664      * transferred to `to`.
665      * - When `from` is zero, `tokenId` will be minted for `to`.
666      * - When `to` is zero, ``from``'s `tokenId` will be burned.
667      * - `from` and `to` are never both zero.
668      *
669      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
670      */
671     function _beforeTokenTransfer(
672         address from,
673         address to,
674         uint256 tokenId
675     ) internal virtual {}
676 }
677 
678 /**
679  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
680  * enumerability of all the token ids in the contract as well as all token ids owned by each
681  * account.
682  */
683 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
684     // Mapping from owner to list of owned token IDs
685     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
686 
687     // Mapping from token ID to index of the owner tokens list
688     mapping(uint256 => uint256) private _ownedTokensIndex;
689 
690     // Array with all token ids, used for enumeration
691     uint256[] private _allTokens;
692 
693     // Mapping from token id to position in the allTokens array
694     mapping(uint256 => uint256) private _allTokensIndex;
695 
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
700         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
701     }
702 
703     /**
704      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
705      */
706     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
707         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
708         return _ownedTokens[owner][index];
709     }
710 
711     /**
712      * @dev See {IERC721Enumerable-totalSupply}.
713      */
714     function totalSupply() public view virtual override returns (uint256) {
715         return _allTokens.length;
716     }
717 
718     /**
719      * @dev See {IERC721Enumerable-tokenByIndex}.
720      */
721     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
722         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
723         return _allTokens[index];
724     }
725 
726     /**
727      * @dev Hook that is called before any token transfer. This includes minting
728      * and burning.
729      *
730      * Calling conditions:
731      *
732      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
733      * transferred to `to`.
734      * - When `from` is zero, `tokenId` will be minted for `to`.
735      * - When `to` is zero, ``from``'s `tokenId` will be burned.
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      *
739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
740      */
741     function _beforeTokenTransfer(
742         address from,
743         address to,
744         uint256 tokenId
745     ) internal virtual override {
746         super._beforeTokenTransfer(from, to, tokenId);
747 
748         if (from == address(0)) {
749             _addTokenToAllTokensEnumeration(tokenId);
750         } else if (from != to) {
751             _removeTokenFromOwnerEnumeration(from, tokenId);
752         }
753         if (to == address(0)) {
754             _removeTokenFromAllTokensEnumeration(tokenId);
755         } else if (to != from) {
756             _addTokenToOwnerEnumeration(to, tokenId);
757         }
758     }
759 
760     /**
761      * @dev Private function to add a token to this extension's ownership-tracking data structures.
762      * @param to address representing the new owner of the given token ID
763      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
764      */
765     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
766         uint256 length = ERC721.balanceOf(to);
767         _ownedTokens[to][length] = tokenId;
768         _ownedTokensIndex[tokenId] = length;
769     }
770 
771     /**
772      * @dev Private function to add a token to this extension's token tracking data structures.
773      * @param tokenId uint256 ID of the token to be added to the tokens list
774      */
775     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
776         _allTokensIndex[tokenId] = _allTokens.length;
777         _allTokens.push(tokenId);
778     }
779 
780     /**
781      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
782      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
783      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
784      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
785      * @param from address representing the previous owner of the given token ID
786      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
787      */
788     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
789         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
790         // then delete the last slot (swap and pop).
791 
792         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
793         uint256 tokenIndex = _ownedTokensIndex[tokenId];
794 
795         // When the token to delete is the last token, the swap operation is unnecessary
796         if (tokenIndex != lastTokenIndex) {
797             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
798 
799             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
800             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
801         }
802 
803         // This also deletes the contents at the last position of the array
804         delete _ownedTokensIndex[tokenId];
805         delete _ownedTokens[from][lastTokenIndex];
806     }
807 
808     /**
809      * @dev Private function to remove a token from this extension's token tracking data structures.
810      * This has O(1) time complexity, but alters the order of the _allTokens array.
811      * @param tokenId uint256 ID of the token to be removed from the tokens list
812      */
813     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
814         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
815         // then delete the last slot (swap and pop).
816 
817         uint256 lastTokenIndex = _allTokens.length - 1;
818         uint256 tokenIndex = _allTokensIndex[tokenId];
819 
820         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
821         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
822         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
823         uint256 lastTokenId = _allTokens[lastTokenIndex];
824 
825         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
826         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
827 
828         // This also deletes the contents at the last position of the array
829         delete _allTokensIndex[tokenId];
830         _allTokens.pop();
831     }
832 }
833 
834 // File: @openzeppelin/contracts/utils/Strings.sol
835 
836 pragma solidity ^0.8.0;
837 
838 /**
839  * @dev String operations.
840  */
841 library Strings {
842     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
843 
844     /**
845      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
846      */
847     function toString(uint256 value) internal pure returns (string memory) {
848         // Inspired by OraclizeAPI's implementation - MIT licence
849         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
850 
851         if (value == 0) {
852             return "0";
853         }
854         uint256 temp = value;
855         uint256 digits;
856         while (temp != 0) {
857             digits++;
858             temp /= 10;
859         }
860         bytes memory buffer = new bytes(digits);
861         while (value != 0) {
862             digits -= 1;
863             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
864             value /= 10;
865         }
866         return string(buffer);
867     }
868 
869     /**
870      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
871      */
872     function toHexString(uint256 value) internal pure returns (string memory) {
873         if (value == 0) {
874             return "0x00";
875         }
876         uint256 temp = value;
877         uint256 length = 0;
878         while (temp != 0) {
879             length++;
880             temp >>= 8;
881         }
882         return toHexString(value, length);
883     }
884 
885     /**
886      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
887      */
888     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
889         bytes memory buffer = new bytes(2 * length + 2);
890         buffer[0] = "0";
891         buffer[1] = "x";
892         for (uint256 i = 2 * length + 1; i > 1; --i) {
893             buffer[i] = _HEX_SYMBOLS[value & 0xf];
894             value >>= 4;
895         }
896         require(value == 0, "Strings: hex length insufficient");
897         return string(buffer);
898     }
899 }
900 
901 // File: @openzeppelin/contracts/utils/Address.sol
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Collection of functions related to the address type
907  */
908 library Address {
909     /**
910      * @dev Returns true if `account` is a contract.
911      *
912      * [IMPORTANT]
913      * ====
914      * It is unsafe to assume that an address for which this function returns
915      * false is an externally-owned account (EOA) and not a contract.
916      *
917      * Among others, `isContract` will return false for the following
918      * types of addresses:
919      *
920      *  - an externally-owned account
921      *  - a contract in construction
922      *  - an address where a contract will be created
923      *  - an address where a contract lived, but was destroyed
924      * ====
925      */
926     function isContract(address account) internal view returns (bool) {
927         // This method relies on extcodesize, which returns 0 for contracts in
928         // construction, since the code is only stored at the end of the
929         // constructor execution.
930 
931         uint256 size;
932         assembly {
933             size := extcodesize(account)
934         }
935         return size > 0;
936     }
937 
938     /**
939      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
940      * `recipient`, forwarding all available gas and reverting on errors.
941      *
942      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
943      * of certain opcodes, possibly making contracts go over the 2300 gas limit
944      * imposed by `transfer`, making them unable to receive funds via
945      * `transfer`. {sendValue} removes this limitation.
946      *
947      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
948      *
949      * IMPORTANT: because control is transferred to `recipient`, care must be
950      * taken to not create reentrancy vulnerabilities. Consider using
951      * {ReentrancyGuard} or the
952      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
953      */
954     function sendValue(address payable recipient, uint256 amount) internal {
955         require(address(this).balance >= amount, "Address: insufficient balance");
956 
957         (bool success, ) = recipient.call{value: amount}("");
958         require(success, "Address: unable to send value, recipient may have reverted");
959     }
960 
961     /**
962      * @dev Performs a Solidity function call using a low level `call`. A
963      * plain `call` is an unsafe replacement for a function call: use this
964      * function instead.
965      *
966      * If `target` reverts with a revert reason, it is bubbled up by this
967      * function (like regular Solidity function calls).
968      *
969      * Returns the raw returned data. To convert to the expected return value,
970      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
971      *
972      * Requirements:
973      *
974      * - `target` must be a contract.
975      * - calling `target` with `data` must not revert.
976      *
977      * _Available since v3.1._
978      */
979     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
980         return functionCall(target, data, "Address: low-level call failed");
981     }
982 
983     /**
984      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
985      * `errorMessage` as a fallback revert reason when `target` reverts.
986      *
987      * _Available since v3.1._
988      */
989     function functionCall(
990         address target,
991         bytes memory data,
992         string memory errorMessage
993     ) internal returns (bytes memory) {
994         return functionCallWithValue(target, data, 0, errorMessage);
995     }
996 
997     /**
998      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
999      * but also transferring `value` wei to `target`.
1000      *
1001      * Requirements:
1002      *
1003      * - the calling contract must have an ETH balance of at least `value`.
1004      * - the called Solidity function must be `payable`.
1005      *
1006      * _Available since v3.1._
1007      */
1008     function functionCallWithValue(
1009         address target,
1010         bytes memory data,
1011         uint256 value
1012     ) internal returns (bytes memory) {
1013         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1014     }
1015 
1016     /**
1017      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1018      * with `errorMessage` as a fallback revert reason when `target` reverts.
1019      *
1020      * _Available since v3.1._
1021      */
1022     function functionCallWithValue(
1023         address target,
1024         bytes memory data,
1025         uint256 value,
1026         string memory errorMessage
1027     ) internal returns (bytes memory) {
1028         require(address(this).balance >= value, "Address: insufficient balance for call");
1029         require(isContract(target), "Address: call to non-contract");
1030 
1031         (bool success, bytes memory returndata) = target.call{value: value}(data);
1032         return _verifyCallResult(success, returndata, errorMessage);
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1037      * but performing a static call.
1038      *
1039      * _Available since v3.3._
1040      */
1041     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1042         return functionStaticCall(target, data, "Address: low-level static call failed");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1047      * but performing a static call.
1048      *
1049      * _Available since v3.3._
1050      */
1051     function functionStaticCall(
1052         address target,
1053         bytes memory data,
1054         string memory errorMessage
1055     ) internal view returns (bytes memory) {
1056         require(isContract(target), "Address: static call to non-contract");
1057 
1058         (bool success, bytes memory returndata) = target.staticcall(data);
1059         return _verifyCallResult(success, returndata, errorMessage);
1060     }
1061 
1062     /**
1063      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1064      * but performing a delegate call.
1065      *
1066      * _Available since v3.4._
1067      */
1068     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1069         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1070     }
1071 
1072     /**
1073      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1074      * but performing a delegate call.
1075      *
1076      * _Available since v3.4._
1077      */
1078     function functionDelegateCall(
1079         address target,
1080         bytes memory data,
1081         string memory errorMessage
1082     ) internal returns (bytes memory) {
1083         require(isContract(target), "Address: delegate call to non-contract");
1084 
1085         (bool success, bytes memory returndata) = target.delegatecall(data);
1086         return _verifyCallResult(success, returndata, errorMessage);
1087     }
1088 
1089     function _verifyCallResult(
1090         bool success,
1091         bytes memory returndata,
1092         string memory errorMessage
1093     ) private pure returns (bytes memory) {
1094         if (success) {
1095             return returndata;
1096         } else {
1097             // Look for revert reason and bubble it up if present
1098             if (returndata.length > 0) {
1099                 // The easiest way to bubble the revert reason is using memory via assembly
1100 
1101                 assembly {
1102                     let returndata_size := mload(returndata)
1103                     revert(add(32, returndata), returndata_size)
1104                 }
1105             } else {
1106                 revert(errorMessage);
1107             }
1108         }
1109     }
1110 }
1111 
1112 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 /**
1117  * @title ERC721 token receiver interface
1118  * @dev Interface for any contract that wants to support safeTransfers
1119  * from ERC721 asset contracts.
1120  */
1121 interface IERC721Receiver {
1122     /**
1123      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1124      * by `operator` from `from`, this function is called.
1125      *
1126      * It must return its Solidity selector to confirm the token transfer.
1127      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1128      *
1129      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1130      */
1131     function onERC721Received(
1132         address operator,
1133         address from,
1134         uint256 tokenId,
1135         bytes calldata data
1136     ) external returns (bytes4);
1137 }
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 /**
1142  * @dev Contract module which provides a basic access control mechanism, where
1143  * there is an account (an owner) that can be granted exclusive access to
1144  * specific functions.
1145  *
1146  * By default, the owner account will be the one that deploys the contract. This
1147  * can later be changed with {transferOwnership}.
1148  *
1149  * This module is used through inheritance. It will make available the modifier
1150  * `onlyOwner`, which can be applied to your functions to restrict their use to
1151  * the owner.
1152  */
1153 abstract contract Ownable is Context {
1154     address private _owner;
1155 
1156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1157 
1158     /**
1159      * @dev Initializes the contract setting the deployer as the initial owner.
1160      */
1161     constructor() {
1162         _setOwner(_msgSender());
1163     }
1164 
1165     /**
1166      * @dev Returns the address of the current owner.
1167      */
1168     function owner() public view virtual returns (address) {
1169         return _owner;
1170     }
1171 
1172     /**
1173      * @dev Throws if called by any account other than the owner.
1174      */
1175     modifier onlyOwner() {
1176         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Leaves the contract without owner. It will not be possible to call
1182      * `onlyOwner` functions anymore. Can only be called by the current owner.
1183      *
1184      * NOTE: Renouncing ownership will leave the contract without an owner,
1185      * thereby removing any functionality that is only available to the owner.
1186      */
1187     function renounceOwnership() public virtual onlyOwner {
1188         _setOwner(address(0));
1189     }
1190 
1191     /**
1192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1193      * Can only be called by the current owner.
1194      */
1195     function transferOwnership(address newOwner) public virtual onlyOwner {
1196         require(newOwner != address(0), "Ownable: new owner is the zero address");
1197         _setOwner(newOwner);
1198     }
1199 
1200     function _setOwner(address newOwner) private {
1201         address oldOwner = _owner;
1202         _owner = newOwner;
1203         emit OwnershipTransferred(oldOwner, newOwner);
1204     }
1205 }
1206 
1207 // File: polymon.sol
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 contract Polymon is ERC721Enumerable, Ownable{
1212     using Address for address;
1213     using Strings for uint256;
1214     
1215     struct generationStat { 
1216        uint256 supply;
1217        uint256 max_supply;
1218        uint256 burned_supply;
1219     }
1220     
1221     struct creatureStat { 
1222        bool gender;
1223        Generation generation;
1224        uint256 tokenId;
1225     }
1226     
1227     enum Generation{ GENE, GEND, GENC, GENB, GENA }
1228     
1229     uint256[5] public totalSupplies = [0, 0, 0, 0, 0];
1230     uint256[5] public totalBurned = [0, 0, 0, 0, 0];
1231     uint256[5] public blockEnds = [9999, 19999, 24999, 27499, 27509];
1232     uint256[5] public genderRarity = [2, 2, 3, 4, 5];
1233     
1234     uint256 public constant NFT_PRICE = 80000000000000000; // 0.08 ETH
1235     uint256 public constant NFT_PRICE_PRESALE = 75000000000000000; // 0.075 ETH
1236     
1237     uint256 public constant MAX_NFT_PURCHASE = 20;
1238     uint256 public constant RESERVED_TOKENS = 200;
1239     uint256 public constant MAX_EGG_SUPPLY = 10000;
1240     uint256 public constant MAX_PRESALE_SUPPLY = RESERVED_TOKENS + 500; //(500 supply, 200 reserved tokens)
1241     
1242     bool public presalePhase = false;
1243     bool public eggPhase = false;
1244     bool public incubationPhase = false;
1245     bool public fusionPhase = false;
1246 
1247     string private _baseTokenURI;
1248     mapping (uint256 => string) _tokenURIs;
1249    
1250     constructor() ERC721("Polymon","PLYMN"){
1251     }
1252     
1253     function togglePresalePhase() public onlyOwner {
1254         presalePhase = !presalePhase;
1255     }
1256 
1257     function toggleEggPhase() public onlyOwner {
1258         eggPhase = !eggPhase;
1259     }
1260     
1261     function toggleFusionPhase() public onlyOwner {
1262         fusionPhase = !fusionPhase;
1263     }
1264     
1265     function toggleIncubationPhase() public onlyOwner {
1266         incubationPhase = !incubationPhase;
1267     }
1268 
1269     function reserveTokens(uint256 numberOfTokens) public onlyOwner {
1270         uint supply = totalSupply();
1271         require((supply + numberOfTokens) <= RESERVED_TOKENS, "Purchase exceeding max reserve token supply");
1272         for (uint i = 0; i < numberOfTokens; i++) {
1273             _safeMint(msg.sender, supply + i);
1274         }
1275         totalSupplies[0] += numberOfTokens;
1276     }
1277     
1278     function reserveTeamTokens(address _shareHolder, uint256 numberOfTokens) public onlyOwner {
1279         uint supply = totalSupply();
1280         require((supply + numberOfTokens) <= RESERVED_TOKENS, "Purchase exceeding max reserve token supply");
1281         for (uint i = 0; i < numberOfTokens; i++) {
1282             _safeMint(_shareHolder, supply + i);
1283         }
1284         totalSupplies[0] += numberOfTokens;
1285     }
1286     
1287     function polyPresaleMint(uint256 numberOfTokens) public payable {
1288         uint256 totalSupply = totalSupply();
1289         require(presalePhase, "Presale hasnt started yet");
1290         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0");
1291         require((totalSupply + numberOfTokens) <= MAX_PRESALE_SUPPLY, "Purchase exceeding max presale token supply");
1292         require(numberOfTokens <= MAX_NFT_PURCHASE,"Can only mint a max of 20 tokens per transaction");
1293         require(NFT_PRICE_PRESALE * numberOfTokens == msg.value, "Sent ether value is incorrect");
1294 
1295         for (uint i = 0; i < numberOfTokens; i++) {
1296             _safeMint(msg.sender, totalSupply + i);
1297         }
1298         totalSupplies[0] += numberOfTokens;
1299     }
1300 
1301     function polyMint(uint256 numberOfTokens) public payable {
1302         uint256 totalSupply = totalSupply();
1303         require(eggPhase, "Cant buy eggs at the moment");
1304         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0");
1305         require((totalSupply + numberOfTokens) <= MAX_EGG_SUPPLY, "Purchase exceeding max token supply");
1306         require(numberOfTokens <= MAX_NFT_PURCHASE,"Can only mint a max of 20 tokens per transaction");
1307         require(NFT_PRICE * numberOfTokens == msg.value, "Sent ether value is incorrect");
1308 
1309         for (uint i = 0; i < numberOfTokens; i++) {
1310             _safeMint(msg.sender, totalSupply + i);
1311         }
1312         totalSupplies[0] += numberOfTokens;
1313     }
1314     
1315     function polyFuse(uint256 tokenId1, uint256 tokenId2) public {
1316        require(msg.sender == ownerOf(tokenId1), "This isnt your NFT");
1317        require(msg.sender == ownerOf(tokenId2), "This isnt your NFT");
1318        require(fusionPhase, "Cant fuse monsters at the moment");
1319        require(getGeneration(tokenId1) != Generation.GENE, "Eggs cant be fused");
1320        require(getGeneration(tokenId2) != Generation.GENE, "Eggs cant be fused");
1321        require(getGeneration(tokenId1) != Generation.GENA, "Alpha gen cant be fused");
1322        require(getGeneration(tokenId2) != Generation.GENA, "Alpha gen cant be fused");
1323        require(oppositeGender(tokenId1, tokenId2), "Monsters need to be of opposite gender");
1324        require(sameGeneration(tokenId1, tokenId2), "Monsters need to be of same generation");
1325        require(!blockLimitReached(tokenId1), "Max generation mints reached");
1326        
1327        uint256 _currentGen = uint256(getGeneration(tokenId1));
1328        uint256 _nextGen = _currentGen + 1;
1329        
1330        _burn(tokenId1);
1331        _burn(tokenId2);
1332        
1333        _safeMint(msg.sender, blockEnds[_currentGen] + 1 + totalSupplies[_nextGen]);
1334        
1335        totalBurned[_currentGen] += 2;
1336        totalSupplies[_nextGen]++;
1337     }
1338    
1339     function polyIncubate(uint256 tokenId) public {
1340        require(msg.sender == ownerOf(tokenId), "This isnt your NFT");
1341        require(incubationPhase, "Cant incubate at the moment");
1342        require(getGeneration(tokenId) == Generation.GENE, "Token is not an egg");
1343        
1344        uint256 _currentGen = uint256(getGeneration(tokenId));
1345       
1346        _burn(tokenId);
1347        _safeMint(msg.sender, tokenId + MAX_EGG_SUPPLY);
1348        totalBurned[_currentGen]++;
1349     }
1350     
1351     function blockLimitReached(uint256 tokenId1) private view returns (bool) {
1352         uint256 _currentGen = uint256(getGeneration(tokenId1));
1353         uint256 _nextGen = _currentGen + 1;
1354         uint256 _blockEnd = blockEnds[_nextGen];
1355         
1356         return (blockEnds[_currentGen] + 1 + totalSupplies[_nextGen]) > _blockEnd;
1357     }
1358     
1359     function getGender(uint256 tokenId) private view returns (bool) {
1360         uint256 _currentGen = uint256(getGeneration(tokenId));
1361         return (tokenId % genderRarity[_currentGen]) == 0;
1362     }
1363    
1364     function getGeneration(uint256 tokenId) private view returns (Generation) {
1365         if(tokenId > blockEnds[3])
1366             return Generation.GENA;
1367         
1368         else if(tokenId > blockEnds[2])
1369             return Generation.GENB;
1370         
1371         else if(tokenId > blockEnds[1])
1372             return Generation.GENC;
1373         
1374         else if(tokenId > blockEnds[0])
1375             return Generation.GEND;
1376         
1377         else
1378             return Generation.GENE;
1379     }
1380     
1381     function getGenerationStats() public view returns (generationStat[] memory)
1382     {
1383         generationStat[] memory stats = new generationStat[](totalSupplies.length);
1384         for (uint256 i; i < totalSupplies.length; i++) {
1385             stats[i].supply = totalSupplies[i];
1386             stats[i].max_supply = blockEnds[i] + 1;
1387             stats[i].burned_supply = totalBurned[i];
1388         }
1389         return stats;
1390     }
1391    
1392     function oppositeGender(uint256 tokenId1, uint256 tokenId2) private view returns (bool) {
1393         return getGender(tokenId1) != getGender(tokenId2);
1394     }
1395    
1396     function sameGeneration(uint256 tokenId1, uint256 tokenId2) private view returns (bool) {
1397         return getGeneration(tokenId1) == getGeneration(tokenId2);
1398     }
1399    
1400     function walletOfOwner(address _owner) public view returns (creatureStat[] memory)
1401     {
1402         uint256 tokenCount = balanceOf(_owner);
1403         creatureStat[] memory creatures = new creatureStat[](tokenCount);
1404         for (uint256 i; i < tokenCount; i++) {
1405             creatures[i].tokenId = tokenOfOwnerByIndex(_owner, i);
1406             creatures[i].gender = getGender(creatures[i].tokenId);
1407             creatures[i].generation = getGeneration(creatures[i].tokenId);
1408         }
1409         return creatures;
1410     }
1411     
1412     function tokenExists(uint256 tokenId) public view returns (bool){
1413         return _exists(tokenId);
1414     }
1415     
1416     function withdraw() public payable onlyOwner {
1417         uint balance = address(this).balance;
1418         payable(msg.sender).transfer(balance);
1419     }
1420     
1421     function withdrawAmount(uint256 amount) public payable onlyOwner {
1422         payable(msg.sender).transfer(amount);
1423     }
1424     
1425     function withdrawShareHolder(address _shareHolder, uint256 _balance, uint256 _share) public payable onlyOwner {
1426         payable(_shareHolder).transfer(_balance * _share / 100);
1427     }
1428     
1429     function getBalance() public view onlyOwner returns (uint256){
1430         return address(this).balance;
1431     }
1432 
1433     function _baseURI() internal view virtual override returns (string memory) {
1434         return _baseTokenURI;
1435     }
1436 
1437     // Sets base URI for all tokens, only able to be called by contract owner
1438     function setBaseURI(string memory baseURI_) public onlyOwner {
1439         _baseTokenURI = baseURI_;
1440     }
1441 
1442     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1443         // Concatenate the tokenID to the baseURI.
1444         return string(abi.encodePacked(_baseTokenURI, tokenId.toString()));
1445     }
1446 }