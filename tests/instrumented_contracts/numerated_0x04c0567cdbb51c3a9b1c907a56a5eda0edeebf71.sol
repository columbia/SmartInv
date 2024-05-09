1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 
5 /**
6  * @dev Interface for discreet in addition to the standard ERC721 interface.
7  */
8 interface discreetNFTInterface {
9     /**
10      * @dev Mint token with the supplied tokenId if it is currently available.
11      */
12     function mint(uint256 tokenId) external;
13 
14     /**
15      * @dev Mint token with the supplied tokenId if it is currently available to
16      * another address.
17      */
18     function mint(address to, uint256 tokenId) external;
19 
20     /**
21      * @dev Burn token with the supplied tokenId if it is owned, approved or
22      * reclaimable. Tokens become reclaimable after ~4 million blocks without a
23      * mint or transfer.
24      */
25     function burn(uint256 tokenId) external;
26 
27     /**
28      * @dev Check the current block number at which a given token will become
29      * reclaimable.
30      */
31     function reclaimableThreshold(uint256 tokenId) external view returns (uint256);
32 }
33 
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
63      */
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 interface IERC721Receiver {
196     /**
197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
198      * by `operator` from `from`, this function is called.
199      *
200      * It must return its Solidity selector to confirm the token transfer.
201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
202      *
203      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
204      */
205     function onERC721Received(
206         address operator,
207         address from,
208         uint256 tokenId,
209         bytes calldata data
210     ) external returns (bytes4);
211 }
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 
236 /**
237  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
238  * @dev See https://eips.ethereum.org/EIPS/eip-721
239  */
240 interface IERC721Enumerable is IERC721 {
241     /**
242      * @dev Returns the total amount of tokens stored by the contract.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
248      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
249      */
250     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
251 
252     /**
253      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
254      * Use along with {totalSupply} to enumerate all tokens.
255      */
256     function tokenByIndex(uint256 index) external view returns (uint256);
257 }
258 
259 
260 interface IENSReverseRegistrar {
261     function claim(address owner) external returns (bytes32 node);
262     function setName(string calldata name) external returns (bytes32 node);
263 }
264 
265 
266 /**
267  * @dev Implementation of the {IERC165} interface.
268  */
269 abstract contract ERC165 is IERC165 {
270     /**
271      * @dev See {IERC165-supportsInterface}.
272      */
273     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
274         return interfaceId == type(IERC165).interfaceId;
275     }
276 }
277 
278 
279 /**
280  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
281  * the Metadata extension, but not including the Enumerable extension, which is available separately as
282  * {ERC721Enumerable}.
283  */
284 contract ERC721 is ERC165, IERC721, IERC721Metadata {
285     // Token name
286     bytes14 private immutable _name;
287 
288     // Token symbol
289     bytes13 private immutable _symbol;
290 
291     // Mapping from token ID to owner address
292     mapping(uint256 => address) private _owners;
293 
294     // Mapping owner address to token count
295     mapping(address => uint256) private _balances;
296 
297     // Mapping from token ID to approved address
298     mapping(uint256 => address) private _tokenApprovals;
299 
300     // Mapping from owner to operator approvals
301     mapping(address => mapping(address => bool)) private _operatorApprovals;
302 
303     /**
304      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
305      */
306     constructor(bytes14 name_, bytes13 symbol_) {
307         _name = name_;
308         _symbol = symbol_;
309     }
310 
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
315         return
316             interfaceId == type(IERC721).interfaceId ||
317             interfaceId == type(IERC721Metadata).interfaceId ||
318             super.supportsInterface(interfaceId);
319     }
320 
321     /**
322      * @dev See {IERC721-balanceOf}.
323      */
324     function balanceOf(address owner) public view virtual override returns (uint256) {
325         require(owner != address(0), "ERC721: balance query for the zero address");
326         return _balances[owner];
327     }
328 
329     /**
330      * @dev See {IERC721-ownerOf}.
331      */
332     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
333         address owner = _owners[tokenId];
334         require(owner != address(0), "ERC721: owner query for nonexistent token");
335         return owner;
336     }
337 
338     /**
339      * @dev See {IERC721Metadata-name}.
340      */
341     function name() external view virtual override returns (string memory) {
342         return string(abi.encodePacked(_name));
343     }
344 
345     /**
346      * @dev See {IERC721Metadata-symbol}.
347      */
348     function symbol() external view virtual override returns (string memory) {
349         return string(abi.encodePacked(_symbol));
350     }
351 
352     /**
353      * @dev NOTE: standard functionality overridden.
354      */
355     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {}
356 
357     /**
358      * @dev See {IERC721-approve}.
359      */
360     function approve(address to, uint256 tokenId) external virtual override {
361         address owner = ERC721.ownerOf(tokenId);
362         require(to != owner, "ERC721: approval to current owner");
363 
364         require(
365             msg.sender == owner || isApprovedForAll(owner, msg.sender),
366             "ERC721: approve caller is not owner nor approved for all"
367         );
368 
369         _approve(to, tokenId);
370     }
371 
372     /**
373      * @dev See {IERC721-getApproved}.
374      */
375     function getApproved(uint256 tokenId) public view virtual override returns (address) {
376         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
377 
378         return _tokenApprovals[tokenId];
379     }
380 
381     /**
382      * @dev See {IERC721-setApprovalForAll}.
383      */
384     function setApprovalForAll(address operator, bool approved) external virtual override {
385         require(operator != msg.sender, "ERC721: approve to caller");
386 
387         _operatorApprovals[msg.sender][operator] = approved;
388         emit ApprovalForAll(msg.sender, operator, approved);
389     }
390 
391     /**
392      * @dev See {IERC721-isApprovedForAll}.
393      */
394     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
395         return _operatorApprovals[owner][operator];
396     }
397 
398     /**
399      * @dev See {IERC721-transferFrom}.
400      */
401     function transferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external virtual override {
406         //solhint-disable-next-line max-line-length
407         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
408 
409         _transfer(from, to, tokenId);
410     }
411 
412     /**
413      * @dev See {IERC721-safeTransferFrom}.
414      */
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external virtual override {
420         safeTransferFrom(from, to, tokenId, "");
421     }
422 
423     /**
424      * @dev See {IERC721-safeTransferFrom}.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId,
430         bytes memory _data
431     ) public virtual override {
432         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
433         _safeTransfer(from, to, tokenId, _data);
434     }
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
438      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
439      *
440      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
441      *
442      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
443      * implement alternative mechanisms to perform token transfer, such as signature-based.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must exist and be owned by `from`.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function _safeTransfer(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes memory _data
459     ) internal virtual {
460         _transfer(from, to, tokenId);
461         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
462     }
463 
464     /**
465      * @dev Returns whether `tokenId` exists.
466      *
467      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
468      *
469      * Tokens start existing when they are minted (`_mint`),
470      * and stop existing when they are burned (`_burn`).
471      */
472     function _exists(uint256 tokenId) internal view virtual returns (bool) {
473         return _owners[tokenId] != address(0);
474     }
475 
476     /**
477      * @dev Returns whether `spender` is allowed to manage `tokenId`.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
484         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
485         address owner = ERC721.ownerOf(tokenId);
486         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
487     }
488 
489     /**
490      * @dev Safely mints `tokenId` and transfers it to `to`.
491      *
492      * Requirements:
493      *
494      * - `tokenId` must not exist.
495      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
496      *
497      * Emits a {Transfer} event.
498      */
499     function _safeMint(address to, uint256 tokenId) internal virtual {
500         _mint(to, tokenId);
501         require(
502             _checkOnERC721Received(address(0), to, tokenId, ""),
503             "ERC721: transfer to non ERC721Receiver implementer"
504         );
505     }
506 
507     /**
508      * @dev Mints `tokenId` and transfers it to `to`.
509      *
510      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
511      *
512      * Requirements:
513      *
514      * - `tokenId` must not exist.
515      * - `to` cannot be the zero address.
516      *
517      * Emits a {Transfer} event.
518      */
519     function _mint(address to, uint256 tokenId) internal virtual {
520         require(to != address(0), "ERC721: mint to the zero address");
521         require(!_exists(tokenId), "ERC721: token already minted");
522 
523         _beforeTokenTransfer(address(0), to, tokenId);
524 
525         _balances[to] += 1;
526         _owners[tokenId] = to;
527 
528         emit Transfer(address(0), to, tokenId);
529     }
530 
531     /**
532      * @dev Destroys `tokenId`.
533      * The approval is cleared when the token is burned.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      *
539      * Emits a {Transfer} event.
540      */
541     function _burn(uint256 tokenId) internal virtual {
542         address owner = ERC721.ownerOf(tokenId);
543 
544         _beforeTokenTransfer(owner, address(0), tokenId);
545 
546         // Clear approvals
547         _approve(address(0), tokenId);
548 
549         _balances[owner] -= 1;
550         delete _owners[tokenId];
551 
552         emit Transfer(owner, address(0), tokenId);
553     }
554 
555     /**
556      * @dev Transfers `tokenId` from `from` to `to`.
557      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
558      *
559      * Requirements:
560      *
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      *
564      * Emits a {Transfer} event.
565      */
566     function _transfer(
567         address from,
568         address to,
569         uint256 tokenId
570     ) internal virtual {
571         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
572         require(to != address(0), "ERC721: transfer to the zero address");
573 
574         _beforeTokenTransfer(from, to, tokenId);
575 
576         // Clear approvals from the previous owner
577         _approve(address(0), tokenId);
578 
579         _balances[from] -= 1;
580         _balances[to] += 1;
581         _owners[tokenId] = to;
582 
583         emit Transfer(from, to, tokenId);
584     }
585 
586     /**
587      * @dev Approve `to` to operate on `tokenId`
588      *
589      * Emits a {Approval} event.
590      */
591     function _approve(address to, uint256 tokenId) internal virtual {
592         _tokenApprovals[tokenId] = to;
593         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
594     }
595 
596     /**
597      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
598      * The call is not executed if the target address is not a contract.
599      *
600      * @param from address representing the previous owner of the given token ID
601      * @param to target address that will receive the tokens
602      * @param tokenId uint256 ID of the token to be transferred
603      * @param _data bytes optional data to send along with the call
604      * @return bool whether the call correctly returned the expected magic value
605      */
606     function _checkOnERC721Received(
607         address from,
608         address to,
609         uint256 tokenId,
610         bytes memory _data
611     ) private returns (bool) {
612         uint256 size;
613         assembly { size := extcodesize(to) }
614         if (size > 0) {
615             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
616                 return retval == IERC721Receiver(to).onERC721Received.selector;
617             } catch (bytes memory reason) {
618                 if (reason.length == 0) {
619                     revert("ERC721: transfer to non ERC721Receiver implementer");
620                 } else {
621                     assembly {
622                         revert(add(32, reason), mload(reason))
623                     }
624                 }
625             }
626         } else {
627             return true;
628         }
629     }
630 
631     /**
632      * @dev Hook that is called before any token transfer. This includes minting
633      * and burning.
634      *
635      * Calling conditions:
636      *
637      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
638      * transferred to `to`.
639      * - When `from` is zero, `tokenId` will be minted for `to`.
640      * - When `to` is zero, ``from``'s `tokenId` will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(
646         address from,
647         address to,
648         uint256 tokenId
649     ) internal virtual {}
650 }
651 
652 
653 /**
654  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
655  * enumerability of all the token ids in the contract as well as all token ids owned by each
656  * account.
657  */
658 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
659     // Mapping from owner to list of owned token IDs
660     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
661 
662     // Mapping from token ID to index of the owner tokens list
663     mapping(uint256 => uint256) private _ownedTokensIndex;
664 
665     // Array with all token ids, used for enumeration
666     uint256[] private _allTokens;
667 
668     // Mapping from token id to position in the allTokens array
669     mapping(uint256 => uint256) private _allTokensIndex;
670 
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
675         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
676     }
677 
678     /**
679      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
680      */
681     function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual override returns (uint256) {
682         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
683         return _ownedTokens[owner][index];
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-totalSupply}.
688      */
689     function totalSupply() public view virtual override returns (uint256) {
690         return _allTokens.length;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-tokenByIndex}.
695      */
696     function tokenByIndex(uint256 index) external view virtual override returns (uint256) {
697         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
698         return _allTokens[index];
699     }
700 
701     /**
702      * @dev Hook that is called before any token transfer. This includes minting
703      * and burning.
704      *
705      * Calling conditions:
706      *
707      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
708      * transferred to `to`.
709      * - When `from` is zero, `tokenId` will be minted for `to`.
710      * - When `to` is zero, ``from``'s `tokenId` will be burned.
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      *
714      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
715      */
716     function _beforeTokenTransfer(
717         address from,
718         address to,
719         uint256 tokenId
720     ) internal virtual override {
721         super._beforeTokenTransfer(from, to, tokenId);
722 
723         if (from == address(0)) {
724             _addTokenToAllTokensEnumeration(tokenId);
725         } else if (from != to) {
726             _removeTokenFromOwnerEnumeration(from, tokenId);
727         }
728         if (to == address(0)) {
729             _removeTokenFromAllTokensEnumeration(tokenId);
730         } else if (to != from) {
731             _addTokenToOwnerEnumeration(to, tokenId);
732         }
733     }
734 
735     /**
736      * @dev Private function to add a token to this extension's ownership-tracking data structures.
737      * @param to address representing the new owner of the given token ID
738      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
739      */
740     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
741         uint256 length = ERC721.balanceOf(to);
742         _ownedTokens[to][length] = tokenId;
743         _ownedTokensIndex[tokenId] = length;
744     }
745 
746     /**
747      * @dev Private function to add a token to this extension's token tracking data structures.
748      * @param tokenId uint256 ID of the token to be added to the tokens list
749      */
750     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
751         _allTokensIndex[tokenId] = _allTokens.length;
752         _allTokens.push(tokenId);
753     }
754 
755     /**
756      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
757      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
758      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
759      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
760      * @param from address representing the previous owner of the given token ID
761      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
762      */
763     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
764         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
765         // then delete the last slot (swap and pop).
766 
767         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
768         uint256 tokenIndex = _ownedTokensIndex[tokenId];
769 
770         // When the token to delete is the last token, the swap operation is unnecessary
771         if (tokenIndex != lastTokenIndex) {
772             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
773 
774             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
775             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
776         }
777 
778         // This also deletes the contents at the last position of the array
779         delete _ownedTokensIndex[tokenId];
780         delete _ownedTokens[from][lastTokenIndex];
781     }
782 
783     /**
784      * @dev Private function to remove a token from this extension's token tracking data structures.
785      * This has O(1) time complexity, but alters the order of the _allTokens array.
786      * @param tokenId uint256 ID of the token to be removed from the tokens list
787      */
788     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
789         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
790         // then delete the last slot (swap and pop).
791 
792         uint256 lastTokenIndex = _allTokens.length - 1;
793         uint256 tokenIndex = _allTokensIndex[tokenId];
794 
795         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
796         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
797         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
798         uint256 lastTokenId = _allTokens[lastTokenIndex];
799 
800         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
801         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
802 
803         // This also deletes the contents at the last position of the array
804         delete _allTokensIndex[tokenId];
805         _allTokens.pop();
806     }
807 }
808 
809 
810 /**
811  * @dev extra-discreet
812  * @author 0age
813  */
814 contract extraDiscreetNFT is discreetNFTInterface, ERC721, ERC721Enumerable {
815     // Map tokenIds to block numbers past which they are burnable by any caller.
816     mapping(uint256 => uint256) private _reclaimableThreshold;
817 
818     // Map transaction submitters to the block number of their last token mint.
819     mapping(address => uint256) private _lastTokenMinted;
820 
821     // Fixed base64-encoded SVG fragments used across all images.
822     bytes32 private constant h0 = 'data:image/svg+xml;base64,PD94bW';
823     bytes32 private constant h1 = 'wgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz';
824     bytes32 private constant h2 = '0iVVRGLTgiPz48c3ZnIHZpZXdCb3g9Ij';
825     bytes32 private constant h3 = 'AgMCA1MDAgNTAwIiB4bWxucz0iaHR0cD';
826     bytes32 private constant h4 = 'ovL3d3dy53My5vcmcvMjAwMC9zdmciIH';
827     bytes32 private constant h5 = 'N0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOi';
828     bytes4 private constant m0 = 'iPjx';
829     bytes10 private constant m1 = 'BmaWxsPSIj';
830     bytes16 private constant f0 = 'IiAvPjwvc3ZnPg==';
831 
832     address public constant discreet = 0x3c77065B584D4Af705B3E38CC35D336b081E4948;
833 
834     address private immutable _admin;
835     uint256 private immutable _deployedAt;
836     mapping(address => bool) private _hasMintedAnOutOfRangeToken;
837 
838     /**
839      * @dev Deploy discreet as an ERC721 NFT.
840      */
841     constructor() ERC721("extra-discreet", "EXTRADISCREET") {
842         // Set up ENS reverse registrar.
843         IENSReverseRegistrar _ensReverseRegistrar = IENSReverseRegistrar(
844             0x084b1c3C81545d370f3634392De611CaaBFf8148
845         );
846 
847         _ensReverseRegistrar.claim(msg.sender);
848         _ensReverseRegistrar.setName("extra.discreet.eth");
849 
850         _admin = tx.origin;
851         _deployedAt = block.number;
852     }
853 
854     /**
855      * @dev Throttle minting to once a block and reset the reclamation threshold
856      * whenever a new token is minted or transferred.
857      */
858     function _beforeTokenTransfer(
859         address from,
860         address to,
861         uint256 tokenId
862     ) internal override(ERC721, ERC721Enumerable) {
863         super._beforeTokenTransfer(from, to, tokenId);
864 
865         // If minting: ensure it's the only one from this tx origin in the block.
866         if (from == address(0)) {
867             require(
868                 block.number > _lastTokenMinted[tx.origin],
869                 "extra-discreet: cannot mint multiple tokens per block from a single origin"
870             );
871 
872             _lastTokenMinted[tx.origin] = block.number;
873         }
874 
875         // If not burning: reset tokenId's reclaimable threshold block number.
876         if (to != address(0)) {
877             _reclaimableThreshold[tokenId] = block.number + 0x400000;
878         }
879     }
880 
881     /**
882      * @dev Mint a given discreet NFT if it is currently available.
883      */
884     function mint(uint256 tokenId) external override {
885         require(tokenId < 0x120, "extra-discreet: cannot mint out-of-range token");
886 
887         require(
888             msg.sender == _admin || block.number > _deployedAt + 0x10000,
889             "extra-discreet: only admin can mint directly for initial period"
890         );
891 
892         _safeMint(msg.sender, tokenId);
893     }
894 
895     /**
896      * @dev Mint a given NFT if it is currently available to a given address.
897      */
898     function mint(address to, uint256 tokenId) external override {
899         require(tokenId < 0x120, "extra-discreet: cannot mint out-of-range token");
900 
901         require(
902             msg.sender == _admin || block.number > _deployedAt + 0x10000,
903             "extra-discreet: only admin can mint directly for initial period"
904         );
905 
906         _safeMint(to, tokenId);
907     }
908 
909     /**
910      * @dev Mint a given NFT if it is currently available to a given address.
911      */
912     function mintFromOutOfRangeDiscreet(uint256 oldDiscreetTokenId, uint256 newExtraDiscreetTokenId) external {
913         require(
914             newExtraDiscreetTokenId < 0x120,
915             "extra-discreet: cannot mint out-of-range token"
916         );
917   
918         // old token needs to be out of range
919         require(
920             oldDiscreetTokenId >= 0x240,
921             "extra-discreet: cannot mint using in-range discreet token"
922         );
923         
924         // old token needs to be owned by caller
925         address oldOwner = IERC721(discreet).ownerOf(oldDiscreetTokenId);
926         require(
927             oldOwner == msg.sender,
928             "extra-discreet: cannot mint using unowned discreet token"
929         );
930 
931         // token needs to be "old" (i.e. hasn't been minted or transferred since
932         // deploying this contract)
933         uint256 oldReclaimableThreshold = discreetNFTInterface(discreet).reclaimableThreshold(oldDiscreetTokenId);
934         uint256 lastMoved = oldReclaimableThreshold - 0x400000;
935         require(
936             lastMoved < _deployedAt,
937             "extra-discreet: cannot mint using out-of-range discreet token that has moved since deployment of this contract"
938         );
939 
940         // Only one token can be minted per caller using this method
941         require(
942             !_hasMintedAnOutOfRangeToken[msg.sender],
943             "extra-discreet: can only mint using out-of-range discreet token once per caller"
944         );
945         _hasMintedAnOutOfRangeToken[msg.sender] = true;
946 
947         _safeMint(msg.sender, newExtraDiscreetTokenId);
948     }
949 
950     /**
951      * @dev Burn a given discreet NFT if it is owned, approved or reclaimable.
952      * Tokens become reclaimable after ~4 million blocks without a transfer.
953      */
954     function burn(uint256 tokenId) external override {
955         // Only enforce check if tokenId has not reached reclaimable threshold.
956         if (_reclaimableThreshold[tokenId] < block.number) {
957             require(
958                 _isApprovedOrOwner(msg.sender, tokenId),
959                 "extra-discreet: caller is not owner nor approved"
960             );
961         }
962 
963         _burn(tokenId);
964     }
965 
966     /**
967      * @dev Check the current block number at which the given token will become
968      * reclaimable.
969      */
970     function reclaimableThreshold(uint256 tokenId) external view override returns (uint256) {
971         return _reclaimableThreshold[tokenId];
972     }
973 
974     /**
975      * @dev Derive and return a discreet tokenURI formatted as a data URI.
976      */
977     function tokenURI(uint256 tokenId) external pure virtual override returns (string memory) {
978         require(tokenId < 0x120, "extra-discreet: URI query for out-of-range token");
979 
980         // Nine base64-encoded SVG fragments for background colors.
981         bytes9[9] memory c0 = [
982         	bytes9('MwMDAwMDA'),
983         	'M2OWZmMzc',
984         	'NmZjM3Njk',
985         	'MzNzY5ZmY',
986         	'NmZmZmOTA',
987         	'M5MGZmZmY',
988         	'NmZjkwZmY',
989         	'NmZmZmZmY',
990         	'M4MDgwODA'
991         ];
992 
993         // Four base64-encoded SVG fragments for primary shapes.
994         string[4] memory s0 = [
995         	'wb2x5Z29uIHBvaW50cz0iNDAwLDEwMCA0MDAsNDAwIDEwMCw0MDAiIC',
996         	'wb2x5Z29uIHBvaW50cz0iMTAwLDQwMCA0MDAsNDAwIDEwMCwxMDAiIC',
997         	'wb2x5Z29uIHBvaW50cz0iMTAwLDQwMCA0MDAsMTAwIDEwMCwxMDAiIC',
998         	'wb2x5Z29uIHBvaW50cz0iNDAwLDQwMCA0MDAsMTAwIDEwMCwxMDAiIC'
999         ];
1000 
1001         // Nine base64-encoded SVG fragments for primary colors.
1002         bytes8[9] memory c1 = [
1003         	bytes8('NjlmZjM3'),
1004         	'ZmYzNzY5',
1005         	'Mzc2OWZm',
1006         	'ZmZmZjkw',
1007         	'OTBmZmZm',
1008         	'ZmY5MGZm',
1009         	'ZmZmZmZm',
1010         	'ODA4MDgw',
1011         	'MDAwMDAw'
1012         ];
1013 
1014         // Construct a discrete tokenURI from a unique combination of the above.
1015 	    uint256 c0i = (tokenId % 72) / 8;
1016 	    uint256 s0i = tokenId / 72;
1017 	    uint256 c1i = (tokenId % 8 + (tokenId / 8)) % 9;
1018 	    return string(
1019 	        abi.encodePacked(
1020 	            h0, h1, h2, h3, h4, h5, c0[c0i], m0, s0[s0i], m1, c1[c1i], f0
1021 	       )
1022 	   );
1023     }
1024 
1025     /**
1026      * @dev Coalesce supportsInterface from inherited contracts.
1027      */
1028     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1029         return super.supportsInterface(interfaceId);
1030     }
1031 }