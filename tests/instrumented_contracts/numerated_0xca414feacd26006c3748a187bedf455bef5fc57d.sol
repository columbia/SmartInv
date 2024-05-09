1 // SPDX-License-Identifier: MIT
2 //
3 // _____  ______   _____   ______
4 //|  _  | | ___ \ /  __ \ |___  /
5 //| | | | | |_/ / | /  \/    / / 
6 //| | | | |    /  | |       / /  
7 //\ \_/ / | |\ \  | \__/\ ./ /___
8 // \___/  \_| \_| \____/  \_____/
9 //
10 //
11 //Contract by @CobbleDev
12 //
13 
14 pragma solidity ^0.8.0;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @title Counters
32  * @author Matt Condon (@shrugs)
33  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
34  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
35  *
36  * Include with `using Counters for Counters.Counter;`
37  */
38 library Counters {
39     struct Counter {
40         // This variable should never be directly accessed by users of the library: interactions must be restricted to
41         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
42         // this feature: see https://github.com/ethereum/solidity/issues/4637
43         uint256 _value; // default: 0
44     }
45 
46     function current(Counter storage counter) internal view returns (uint256) {
47         return counter._value;
48     }
49 
50     function increment(Counter storage counter) internal {
51         unchecked {
52             counter._value += 1;
53         }
54     }
55 
56     function decrement(Counter storage counter) internal {
57         uint256 value = counter._value;
58         require(value > 0, "Counter: decrement overflow");
59         unchecked {
60             counter._value = value - 1;
61         }
62     }
63 }
64 
65 
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev Interface of the ERC165 standard, as defined in the
71  * https://eips.ethereum.org/EIPS/eip-165[EIP].
72  *
73  * Implementers can declare support of contract interfaces, which can then be
74  * queried by others ({ERC165Checker}).
75  *
76  * For an implementation, see {ERC165}.
77  */
78 interface IERC165 {
79     /**
80      * @dev Returns true if this contract implements the interface defined by
81      * `interfaceId`. See the corresponding
82      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
83      * to learn more about how these ids are created.
84      *
85      * This function call must use less than 30 000 gas.
86      */
87     function supportsInterface(bytes4 interfaceId) external view returns (bool);
88 }
89 
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102 
103     /**
104      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
105      */
106     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
110      */
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112 
113     /**
114      * @dev Returns the number of tokens in ``owner``'s account.
115      */
116     function balanceOf(address owner) external view returns (uint256 balance);
117 
118     /**
119      * @dev Returns the owner of the `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function ownerOf(uint256 tokenId) external view returns (address owner);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must exist and be owned by `from`.
136      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138      *
139      * Emits a {Transfer} event.
140      */
141     function safeTransferFrom(address from, address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Transfers `tokenId` token from `from` to `to`.
145      *
146      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(address from, address to, uint256 tokenId) external;
158 
159     /**
160      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
161      * The approval is cleared when the token is transferred.
162      *
163      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
164      *
165      * Requirements:
166      *
167      * - The caller must own the token or be an approved operator.
168      * - `tokenId` must exist.
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address to, uint256 tokenId) external;
173 
174     /**
175      * @dev Returns the account approved for `tokenId` token.
176      *
177      * Requirements:
178      *
179      * - `tokenId` must exist.
180      */
181     function getApproved(uint256 tokenId) external view returns (address operator);
182 
183     /**
184      * @dev Approve or remove `operator` as an operator for the caller.
185      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
186      *
187      * Requirements:
188      *
189      * - The `operator` cannot be the caller.
190      *
191      * Emits an {ApprovalForAll} event.
192      */
193     function setApprovalForAll(address operator, bool _approved) external;
194 
195     /**
196      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
197      *
198      * See {setApprovalForAll}
199      */
200     function isApprovedForAll(address owner, address operator) external view returns (bool);
201 
202     /**
203       * @dev Safely transfers `tokenId` token from `from` to `to`.
204       *
205       * Requirements:
206       *
207       * - `from` cannot be the zero address.
208       * - `to` cannot be the zero address.
209       * - `tokenId` token must exist and be owned by `from`.
210       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
211       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
212       *
213       * Emits a {Transfer} event.
214       */
215     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
216 }
217 
218 
219 
220 
221 pragma solidity ^0.8.0;
222 
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
226  * @dev See https://eips.ethereum.org/EIPS/eip-721
227  */
228 interface IERC721Enumerable is IERC721 {
229 
230     /**
231      * @dev Returns the total amount of tokens stored by the contract.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
237      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
238      */
239     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
240 
241     /**
242      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
243      * Use along with {totalSupply} to enumerate all tokens.
244      */
245     function tokenByIndex(uint256 index) external view returns (uint256);
246 }
247 
248 
249 pragma solidity ^0.8.0;
250 
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
254  * @dev See https://eips.ethereum.org/EIPS/eip-721
255  */
256 interface IERC721Metadata is IERC721 {
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 }
273 
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title ERC721 token receiver interface
281  * @dev Interface for any contract that wants to support safeTransfers
282  * from ERC721 asset contracts.
283  */
284 interface IERC721Receiver {
285     /**
286      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
287      * by `operator` from `from`, this function is called.
288      *
289      * It must return its Solidity selector to confirm the token transfer.
290      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
291      *
292      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
293      */
294     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
295 }
296 
297 
298 
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @dev Implementation of the {IERC165} interface.
305  *
306  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
307  * for the additional interface id that will be supported. For example:
308  *
309  * ```solidity
310  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
312  * }
313  * ```
314  *
315  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
316  */
317 abstract contract ERC165 is IERC165 {
318     /**
319      * @dev See {IERC165-supportsInterface}.
320      */
321     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
322         return interfaceId == type(IERC165).interfaceId;
323     }
324 }
325 
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
332  * the Metadata extension, but not including the Enumerable extension, which is available separately as
333  * {ERC721Enumerable}.
334  */
335 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
336     using Address for address;
337     using Strings for uint256;
338 
339     // Token name
340     string private _name;
341 
342     // Token symbol
343     string private _symbol;
344 
345     // Mapping from token ID to owner address
346     mapping (uint256 => address) private _owners;
347 
348     // Mapping owner address to token count
349     mapping (address => uint256) private _balances;
350 
351     // Mapping from token ID to approved address
352     mapping (uint256 => address) private _tokenApprovals;
353 
354     // Mapping from owner to operator approvals
355     mapping (address => mapping (address => bool)) private _operatorApprovals;
356 
357     /**
358      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
359      */
360     constructor (string memory name_, string memory symbol_) {
361         _name = name_;
362         _symbol = symbol_;
363     }
364 
365     /**
366      * @dev See {IERC165-supportsInterface}.
367      */
368     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
369         return interfaceId == type(IERC721).interfaceId
370             || interfaceId == type(IERC721Metadata).interfaceId
371             || super.supportsInterface(interfaceId);
372     }
373 
374     /**
375      * @dev See {IERC721-balanceOf}.
376      */
377     function balanceOf(address owner) public view virtual override returns (uint256) {
378         require(owner != address(0), "ERC721: balance query for the zero address");
379         return _balances[owner];
380     }
381 
382     /**
383      * @dev See {IERC721-ownerOf}.
384      */
385     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
386         address owner = _owners[tokenId];
387         require(owner != address(0), "ERC721: owner query for nonexistent token");
388         return owner;
389     }
390 
391     /**
392      * @dev See {IERC721Metadata-name}.
393      */
394     function name() public view virtual override returns (string memory) {
395         return _name;
396     }
397 
398     /**
399      * @dev See {IERC721Metadata-symbol}.
400      */
401     function symbol() public view virtual override returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev See {IERC721Metadata-tokenURI}.
407      */
408     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
409         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
410 
411         string memory baseURI = _baseURI();
412         return bytes(baseURI).length > 0
413             ? string(abi.encodePacked(baseURI, tokenId.toString()))
414             : '';
415     }
416 
417     /**
418      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
419      * in child contracts.
420      */
421     function _baseURI() internal view virtual returns (string memory) {
422         return "";
423     }
424 
425     /**
426      * @dev See {IERC721-approve}.
427      */
428     function approve(address to, uint256 tokenId) public virtual override {
429         address owner = ERC721.ownerOf(tokenId);
430         require(to != owner, "ERC721: approval to current owner");
431 
432         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
433             "ERC721: approve caller is not owner nor approved for all"
434         );
435 
436         _approve(to, tokenId);
437     }
438 
439     /**
440      * @dev See {IERC721-getApproved}.
441      */
442     function getApproved(uint256 tokenId) public view virtual override returns (address) {
443         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
444 
445         return _tokenApprovals[tokenId];
446     }
447 
448     /**
449      * @dev See {IERC721-setApprovalForAll}.
450      */
451     function setApprovalForAll(address operator, bool approved) public virtual override {
452         require(operator != _msgSender(), "ERC721: approve to caller");
453 
454         _operatorApprovals[_msgSender()][operator] = approved;
455         emit ApprovalForAll(_msgSender(), operator, approved);
456     }
457 
458     /**
459      * @dev See {IERC721-isApprovedForAll}.
460      */
461     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
462         return _operatorApprovals[owner][operator];
463     }
464 
465     /**
466      * @dev See {IERC721-transferFrom}.
467      */
468     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
469         //solhint-disable-next-line max-line-length
470         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
471 
472         _transfer(from, to, tokenId);
473     }
474 
475     /**
476      * @dev See {IERC721-safeTransferFrom}.
477      */
478     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
479         safeTransferFrom(from, to, tokenId, "");
480     }
481 
482     /**
483      * @dev See {IERC721-safeTransferFrom}.
484      */
485     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
486         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
487         _safeTransfer(from, to, tokenId, _data);
488     }
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
492      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
493      *
494      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
495      *
496      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
497      * implement alternative mechanisms to perform token transfer, such as signature-based.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
505      *
506      * Emits a {Transfer} event.
507      */
508     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
509         _transfer(from, to, tokenId);
510         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
511     }
512 
513     /**
514      * @dev Returns whether `tokenId` exists.
515      *
516      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
517      *
518      * Tokens start existing when they are minted (`_mint`),
519      * and stop existing when they are burned (`_burn`).
520      */
521     function _exists(uint256 tokenId) internal view virtual returns (bool) {
522         return _owners[tokenId] != address(0);
523     }
524 
525     /**
526      * @dev Returns whether `spender` is allowed to manage `tokenId`.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
533         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
534         address owner = ERC721.ownerOf(tokenId);
535         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
536     }
537 
538 
539     /**
540      * @dev Mints `tokenId` and transfers it to `to`.
541      *
542      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
543      *
544      * Requirements:
545      *
546      * - `tokenId` must not exist.
547      * - `to` cannot be the zero address.
548      *
549      * Emits a {Transfer} event.
550      */
551     function _mint(address to, uint256 tokenId) internal virtual {
552         require(to != address(0), "ERC721: mint to the zero address");
553         require(!_exists(tokenId), "ERC721: token already minted");
554 
555         _beforeTokenTransfer(address(0), to, tokenId);
556 
557         _balances[to] += 1;
558         _owners[tokenId] = to;
559 
560         emit Transfer(address(0), to, tokenId);
561     }
562 
563     /**
564      * @dev Destroys `tokenId`.
565      * The approval is cleared when the token is burned.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      *
571      * Emits a {Transfer} event.
572      */
573     function _burn(uint256 tokenId) internal virtual {
574         address owner = ERC721.ownerOf(tokenId);
575 
576         _beforeTokenTransfer(owner, address(0), tokenId);
577 
578         // Clear approvals
579         _approve(address(0), tokenId);
580 
581         _balances[owner] -= 1;
582         delete _owners[tokenId];
583 
584         emit Transfer(owner, address(0), tokenId);
585     }
586 
587     /**
588      * @dev Transfers `tokenId` from `from` to `to`.
589      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
590      *
591      * Requirements:
592      *
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      *
596      * Emits a {Transfer} event.
597      */
598     function _transfer(address from, address to, uint256 tokenId) internal virtual {
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
634     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
635         private returns (bool)
636     {
637         if (to.isContract()) {
638             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
639                 return retval == IERC721Receiver(to).onERC721Received.selector;
640             } catch (bytes memory reason) {
641                 if (reason.length == 0) {
642                     revert("ERC721: transfer to non ERC721Receiver implementer");
643                 } else {
644                     // solhint-disable-next-line no-inline-assembly
645                     assembly {
646                         revert(add(32, reason), mload(reason))
647                     }
648                 }
649             }
650         } else {
651             return true;
652         }
653     }
654 
655     /**
656      * @dev Hook that is called before any token transfer. This includes minting
657      * and burning.
658      *
659      * Calling conditions:
660      *
661      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
662      * transferred to `to`.
663      * - When `from` is zero, `tokenId` will be minted for `to`.
664      * - When `to` is zero, ``from``'s `tokenId` will be burned.
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      *
668      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
669      */
670     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
671 }
672 
673 
674 
675 pragma solidity ^0.8.0;
676 
677 
678 /**
679  * @title ERC721 Burnable Token
680  * @dev ERC721 Token that can be irreversibly burned (destroyed).
681  */
682 abstract contract ERC721Burnable is Context, ERC721 {
683     /**
684      * @dev Burns `tokenId`. See {ERC721-_burn}.
685      *
686      * Requirements:
687      *
688      * - The caller must own `tokenId` or be an approved operator.
689      */
690     function burn(uint256 tokenId) public virtual {
691         //solhint-disable-next-line max-line-length
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
693         _burn(tokenId);
694     }
695 }
696 
697 
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
704  * enumerability of all the token ids in the contract as well as all token ids owned by each
705  * account.
706  */
707 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
708     // Mapping from owner to list of owned token IDs
709     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
710 
711     // Mapping from token ID to index of the owner tokens list
712     mapping(uint256 => uint256) private _ownedTokensIndex;
713 
714     // Array with all token ids, used for enumeration
715     uint256[] private _allTokens;
716 
717     // Mapping from token id to position in the allTokens array
718     mapping(uint256 => uint256) private _allTokensIndex;
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
724         return interfaceId == type(IERC721Enumerable).interfaceId
725             || super.supportsInterface(interfaceId);
726     }
727 
728     /**
729      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
730      */
731     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
732         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
733         return _ownedTokens[owner][index];
734     }
735 
736     /**
737      * @dev See {IERC721Enumerable-totalSupply}.
738      */
739     function totalSupply() public view virtual override returns (uint256) {
740         return _allTokens.length;
741     }
742 
743     /**
744      * @dev See {IERC721Enumerable-tokenByIndex}.
745      */
746     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
747         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
748         return _allTokens[index];
749     }
750 
751     /**
752      * @dev Hook that is called before any token transfer. This includes minting
753      * and burning.
754      *
755      * Calling conditions:
756      *
757      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
758      * transferred to `to`.
759      * - When `from` is zero, `tokenId` will be minted for `to`.
760      * - When `to` is zero, ``from``'s `tokenId` will be burned.
761      * - `from` cannot be the zero address.
762      * - `to` cannot be the zero address.
763      *
764      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
765      */
766     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
767         super._beforeTokenTransfer(from, to, tokenId);
768 
769         if (from == address(0)) {
770             _addTokenToAllTokensEnumeration(tokenId);
771         } else if (from != to) {
772             _removeTokenFromOwnerEnumeration(from, tokenId);
773         }
774         if (to == address(0)) {
775             _removeTokenFromAllTokensEnumeration(tokenId);
776         } else if (to != from) {
777             _addTokenToOwnerEnumeration(to, tokenId);
778         }
779     }
780 
781     /**
782      * @dev Private function to add a token to this extension's ownership-tracking data structures.
783      * @param to address representing the new owner of the given token ID
784      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
785      */
786     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
787         uint256 length = ERC721.balanceOf(to);
788         _ownedTokens[to][length] = tokenId;
789         _ownedTokensIndex[tokenId] = length;
790     }
791 
792     /**
793      * @dev Private function to add a token to this extension's token tracking data structures.
794      * @param tokenId uint256 ID of the token to be added to the tokens list
795      */
796     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
797         _allTokensIndex[tokenId] = _allTokens.length;
798         _allTokens.push(tokenId);
799     }
800 
801     /**
802      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
803      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
804      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
805      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
806      * @param from address representing the previous owner of the given token ID
807      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
808      */
809     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
810         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
811         // then delete the last slot (swap and pop).
812 
813         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
814         uint256 tokenIndex = _ownedTokensIndex[tokenId];
815 
816         // When the token to delete is the last token, the swap operation is unnecessary
817         if (tokenIndex != lastTokenIndex) {
818             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
819 
820             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
821             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
822         }
823 
824         // This also deletes the contents at the last position of the array
825         delete _ownedTokensIndex[tokenId];
826         delete _ownedTokens[from][lastTokenIndex];
827     }
828 
829     /**
830      * @dev Private function to remove a token from this extension's token tracking data structures.
831      * This has O(1) time complexity, but alters the order of the _allTokens array.
832      * @param tokenId uint256 ID of the token to be removed from the tokens list
833      */
834     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
835         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
836         // then delete the last slot (swap and pop).
837 
838         uint256 lastTokenIndex = _allTokens.length - 1;
839         uint256 tokenIndex = _allTokensIndex[tokenId];
840 
841         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
842         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
843         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
844         uint256 lastTokenId = _allTokens[lastTokenIndex];
845 
846         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
847         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
848 
849         // This also deletes the contents at the last position of the array
850         delete _allTokensIndex[tokenId];
851         _allTokens.pop();
852     }
853 }
854 
855 
856 
857 
858 
859 pragma solidity ^0.8.0;
860 
861 
862 /**
863  * @dev Contract module which provides a basic access control mechanism, where
864  * there is an account (an owner) that can be granted exclusive access to
865  * specific functions.
866  *
867  * By default, the owner account will be the one that deploys the contract. This
868  * can later be changed with {transferOwnership}.
869  *
870  * This module is used through inheritance. It will make available the modifier
871  * `onlyOwner`, which can be applied to your functions to restrict their use to
872  * the owner.
873  */
874 abstract contract Ownable is Context {
875     address private _owner;
876 
877     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
878 
879     /**
880      * @dev Initializes the contract setting the deployer as the initial owner.
881      */
882     constructor() {
883         _setOwner(_msgSender());
884     }
885 
886     /**
887      * @dev Returns the address of the current owner.
888      */
889     function owner() public view virtual returns (address) {
890         return _owner;
891     }
892 
893     /**
894      * @dev Throws if called by any account other than the owner.
895      */
896     modifier onlyOwner() {
897         require(owner() == _msgSender(), "Ownable: caller is not the owner");
898         _;
899     }
900 
901     /**
902      * @dev Leaves the contract without owner. It will not be possible to call
903      * `onlyOwner` functions anymore. Can only be called by the current owner.
904      *
905      * NOTE: Renouncing ownership will leave the contract without an owner,
906      * thereby removing any functionality that is only available to the owner.
907      */
908     function renounceOwnership() public virtual onlyOwner {
909         _setOwner(address(0));
910     }
911 
912     /**
913      * @dev Transfers ownership of the contract to a new account (`newOwner`).
914      * Can only be called by the current owner.
915      */
916     function transferOwnership(address newOwner) public virtual onlyOwner {
917         require(newOwner != address(0), "Ownable: new owner is the zero address");
918         _setOwner(newOwner);
919     }
920 
921     function _setOwner(address newOwner) private {
922         address oldOwner = _owner;
923         _owner = newOwner;
924         emit OwnershipTransferred(oldOwner, newOwner);
925     }
926 }
927 
928 
929 
930 
931 pragma solidity ^0.8.0;
932 
933 /**
934  * @dev String operations.
935  */
936 library Strings {
937     bytes16 private constant alphabet = "0123456789abcdef";
938 
939     /**
940      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
941      */
942     function toString(uint256 value) internal pure returns (string memory) {
943         // Inspired by OraclizeAPI's implementation - MIT licence
944         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
945 
946         if (value == 0) {
947             return "0";
948         }
949         uint256 temp = value;
950         uint256 digits;
951         while (temp != 0) {
952             digits++;
953             temp /= 10;
954         }
955         bytes memory buffer = new bytes(digits);
956         while (value != 0) {
957             digits -= 1;
958             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
959             value /= 10;
960         }
961         return string(buffer);
962     }
963 
964     /**
965      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
966      */
967     function toHexString(uint256 value) internal pure returns (string memory) {
968         if (value == 0) {
969             return "0x00";
970         }
971         uint256 temp = value;
972         uint256 length = 0;
973         while (temp != 0) {
974             length++;
975             temp >>= 8;
976         }
977         return toHexString(value, length);
978     }
979 
980     /**
981      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
982      */
983     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
984         bytes memory buffer = new bytes(2 * length + 2);
985         buffer[0] = "0";
986         buffer[1] = "x";
987         for (uint256 i = 2 * length + 1; i > 1; --i) {
988             buffer[i] = alphabet[value & 0xf];
989             value >>= 4;
990         }
991         require(value == 0, "Strings: hex length insufficient");
992         return string(buffer);
993     }
994 
995 }
996 
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @dev Collection of functions related to the address type
1003  */
1004 library Address {
1005     /**
1006      * @dev Returns true if `account` is a contract.
1007      *
1008      * [IMPORTANT]
1009      * ====
1010      * It is unsafe to assume that an address for which this function returns
1011      * false is an externally-owned account (EOA) and not a contract.
1012      *
1013      * Among others, `isContract` will return false for the following
1014      * types of addresses:
1015      *
1016      *  - an externally-owned account
1017      *  - a contract in construction
1018      *  - an address where a contract will be created
1019      *  - an address where a contract lived, but was destroyed
1020      * ====
1021      */
1022     function isContract(address account) internal view returns (bool) {
1023         // This method relies on extcodesize, which returns 0 for contracts in
1024         // construction, since the code is only stored at the end of the
1025         // constructor execution.
1026 
1027         uint256 size;
1028         assembly {
1029             size := extcodesize(account)
1030         }
1031         return size > 0;
1032     }
1033 
1034     /**
1035      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1036      * `recipient`, forwarding all available gas and reverting on errors.
1037      *
1038      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1039      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1040      * imposed by `transfer`, making them unable to receive funds via
1041      * `transfer`. {sendValue} removes this limitation.
1042      *
1043      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1044      *
1045      * IMPORTANT: because control is transferred to `recipient`, care must be
1046      * taken to not create reentrancy vulnerabilities. Consider using
1047      * {ReentrancyGuard} or the
1048      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1049      */
1050     function sendValue(address payable recipient, uint256 amount) internal {
1051         require(address(this).balance >= amount, "Address: insufficient balance");
1052 
1053         (bool success, ) = recipient.call{value: amount}("");
1054         require(success, "Address: unable to send value, recipient may have reverted");
1055     }
1056 
1057     /**
1058      * @dev Performs a Solidity function call using a low level `call`. A
1059      * plain `call` is an unsafe replacement for a function call: use this
1060      * function instead.
1061      *
1062      * If `target` reverts with a revert reason, it is bubbled up by this
1063      * function (like regular Solidity function calls).
1064      *
1065      * Returns the raw returned data. To convert to the expected return value,
1066      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1067      *
1068      * Requirements:
1069      *
1070      * - `target` must be a contract.
1071      * - calling `target` with `data` must not revert.
1072      *
1073      * _Available since v3.1._
1074      */
1075     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1076         return functionCall(target, data, "Address: low-level call failed");
1077     }
1078 
1079     /**
1080      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1081      * `errorMessage` as a fallback revert reason when `target` reverts.
1082      *
1083      * _Available since v3.1._
1084      */
1085     function functionCall(
1086         address target,
1087         bytes memory data,
1088         string memory errorMessage
1089     ) internal returns (bytes memory) {
1090         return functionCallWithValue(target, data, 0, errorMessage);
1091     }
1092 
1093     /**
1094      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1095      * but also transferring `value` wei to `target`.
1096      *
1097      * Requirements:
1098      *
1099      * - the calling contract must have an ETH balance of at least `value`.
1100      * - the called Solidity function must be `payable`.
1101      *
1102      * _Available since v3.1._
1103      */
1104     function functionCallWithValue(
1105         address target,
1106         bytes memory data,
1107         uint256 value
1108     ) internal returns (bytes memory) {
1109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1114      * with `errorMessage` as a fallback revert reason when `target` reverts.
1115      *
1116      * _Available since v3.1._
1117      */
1118     function functionCallWithValue(
1119         address target,
1120         bytes memory data,
1121         uint256 value,
1122         string memory errorMessage
1123     ) internal returns (bytes memory) {
1124         require(address(this).balance >= value, "Address: insufficient balance for call");
1125         require(isContract(target), "Address: call to non-contract");
1126 
1127         (bool success, bytes memory returndata) = target.call{value: value}(data);
1128         return _verifyCallResult(success, returndata, errorMessage);
1129     }
1130 
1131     /**
1132      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1133      * but performing a static call.
1134      *
1135      * _Available since v3.3._
1136      */
1137     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1138         return functionStaticCall(target, data, "Address: low-level static call failed");
1139     }
1140 
1141     /**
1142      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1143      * but performing a static call.
1144      *
1145      * _Available since v3.3._
1146      */
1147     function functionStaticCall(
1148         address target,
1149         bytes memory data,
1150         string memory errorMessage
1151     ) internal view returns (bytes memory) {
1152         require(isContract(target), "Address: static call to non-contract");
1153 
1154         (bool success, bytes memory returndata) = target.staticcall(data);
1155         return _verifyCallResult(success, returndata, errorMessage);
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1160      * but performing a delegate call.
1161      *
1162      * _Available since v3.4._
1163      */
1164     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1165         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1166     }
1167 
1168     /**
1169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1170      * but performing a delegate call.
1171      *
1172      * _Available since v3.4._
1173      */
1174     function functionDelegateCall(
1175         address target,
1176         bytes memory data,
1177         string memory errorMessage
1178     ) internal returns (bytes memory) {
1179         require(isContract(target), "Address: delegate call to non-contract");
1180 
1181         (bool success, bytes memory returndata) = target.delegatecall(data);
1182         return _verifyCallResult(success, returndata, errorMessage);
1183     }
1184 
1185     function _verifyCallResult(
1186         bool success,
1187         bytes memory returndata,
1188         string memory errorMessage
1189     ) private pure returns (bytes memory) {
1190         if (success) {
1191             return returndata;
1192         } else {
1193             // Look for revert reason and bubble it up if present
1194             if (returndata.length > 0) {
1195                 // The easiest way to bubble the revert reason is using memory via assembly
1196 
1197                 assembly {
1198                     let returndata_size := mload(returndata)
1199                     revert(add(32, returndata), returndata_size)
1200                 }
1201             } else {
1202                 revert(errorMessage);
1203             }
1204         }
1205     }
1206 }
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 contract Orcz is Context, ERC721Enumerable, ERC721Burnable, Ownable {
1211     using Counters for Counters.Counter;
1212 
1213     Counters.Counter private _tokenIdTracker;
1214 
1215     string private _baseTokenURI;
1216     
1217     address CommunityAddress = 0xA3BDaa505a72FC6B3e15E69Ac1577aEcd0E2736b;
1218     address CobbleAddress = 0xE0666cAC0C2267209Ba3Da4Db00c03315Fe64fA8;
1219     address ChabusanAddress = 0xb4ce5faeB2228Bf48Ea7f5545eA0CD5d53F95a16;
1220     address MattAddress = 0xd17EdAE5256Ba32A8b34DD428Bcc625B704Ad104;
1221     
1222     uint private constant maxOrcz = 8800;
1223     uint private constant mintPrice = 40000000000000000;
1224     bool private paused = true;
1225     uint public leftToPayCommunity = 60000000000000000000;
1226     
1227     event CreateOrcz(uint indexed id);
1228 
1229     constructor() ERC721("Orcz", "ORCZ") {
1230         _baseTokenURI = "https://goblingoonslair.com/orcz/";
1231     }
1232 
1233     function _baseURI() internal view virtual override returns (string memory) {
1234         return _baseTokenURI;
1235     }
1236     
1237     function setBaseURI(string memory baseURI) external onlyOwner {
1238         _baseTokenURI = baseURI;
1239     }
1240 
1241     function mint(uint amount) public payable {
1242         require(!paused || msg.sender == owner());
1243         require(msg.value == mintPrice*amount || msg.sender == owner(), "It costs 0.04 eth to mint a Orcz.");
1244         require(totalSupply() + amount < maxOrcz, "There can only be 8800 Orcz!");
1245         for(uint i = 0; i < amount; i++) {
1246             _tokenIdTracker.increment();
1247             _mint(msg.sender, _tokenIdTracker.current());
1248             emit CreateOrcz(_tokenIdTracker.current());
1249         }
1250     }
1251 
1252     function pause() public virtual onlyOwner {
1253         paused = true;
1254     }
1255 
1256     function unpause() public virtual onlyOwner {
1257         paused = false;
1258     }
1259     
1260     function withdraw() external onlyOwner {
1261         uint balance = address(this).balance;
1262         if(balance < leftToPayCommunity) {
1263             payable(CommunityAddress).transfer(balance);
1264             leftToPayCommunity = leftToPayCommunity-balance;
1265             return;
1266         } else if(leftToPayCommunity > 0) {
1267             payable(CommunityAddress).transfer(leftToPayCommunity);
1268             leftToPayCommunity = 0;
1269         }
1270         
1271         payable(CobbleAddress).transfer(balance/5);
1272         payable(ChabusanAddress).transfer(balance/20);
1273         payable(MattAddress).transfer(balance/5);
1274         payable(msg.sender).transfer(address(this).balance);
1275     }
1276 
1277     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1278         super._beforeTokenTransfer(from, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1285         return super.supportsInterface(interfaceId);
1286     }
1287 }