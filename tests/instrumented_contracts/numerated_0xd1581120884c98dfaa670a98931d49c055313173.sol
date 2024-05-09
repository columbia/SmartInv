1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @title Counters
22  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
23  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
24  *
25  * Include with `using Counters for Counters.Counter;`
26  */
27 library Counters {
28     struct Counter {
29         // This variable should never be directly accessed by users of the library: interactions must be restricted to
30         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
31         // this feature: see https://github.com/ethereum/solidity/issues/4637
32         uint256 _value; // default: 0
33     }
34 
35     function current(Counter storage counter) internal view returns (uint256) {
36         return counter._value;
37     }
38 
39     function increment(Counter storage counter) internal {
40         unchecked {
41             counter._value += 1;
42         }
43     }
44 
45     function decrement(Counter storage counter) internal {
46         uint256 value = counter._value;
47         require(value > 0, "Counter: decrement overflow");
48         unchecked {
49             counter._value = value - 1;
50         }
51     }
52 }
53 
54 
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Interface of the ERC165 standard, as defined in the
60  * https://eips.ethereum.org/EIPS/eip-165[EIP].
61  *
62  * Implementers can declare support of contract interfaces, which can then be
63  * queried by others ({ERC165Checker}).
64  *
65  * For an implementation, see {ERC165}.
66  */
67 interface IERC165 {
68     /**
69      * @dev Returns true if this contract implements the interface defined by
70      * `interfaceId`. See the corresponding
71      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
72      * to learn more about how these ids are created.
73      *
74      * This function call must use less than 30 000 gas.
75      */
76     function supportsInterface(bytes4 interfaceId) external view returns (bool);
77 }
78 
79 
80 pragma solidity ^0.8.0;
81 
82 
83 /**
84  * @dev Required interface of an ERC721 compliant contract.
85  */
86 interface IERC721 is IERC165 {
87     /**
88      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
91 
92     /**
93      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
94      */
95     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
96 
97     /**
98      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
99      */
100     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
101 
102     /**
103      * @dev Returns the number of tokens in ``owner``'s account.
104      */
105     function balanceOf(address owner) external view returns (uint256 balance);
106 
107     /**
108      * @dev Returns the owner of the `tokenId` token.
109      *
110      * Requirements:
111      *
112      * - `tokenId` must exist.
113      */
114     function ownerOf(uint256 tokenId) external view returns (address owner);
115 
116     /**
117      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
118      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must exist and be owned by `from`.
125      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
127      *
128      * Emits a {Transfer} event.
129      */
130     function safeTransferFrom(address from, address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Transfers `tokenId` token from `from` to `to`.
134      *
135      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
136      *
137      * Requirements:
138      *
139      * - `from` cannot be the zero address.
140      * - `to` cannot be the zero address.
141      * - `tokenId` token must be owned by `from`.
142      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(address from, address to, uint256 tokenId) external;
147 
148     /**
149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
150      * The approval is cleared when the token is transferred.
151      *
152      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
153      *
154      * Requirements:
155      *
156      * - The caller must own the token or be an approved operator.
157      * - `tokenId` must exist.
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address to, uint256 tokenId) external;
162 
163     /**
164      * @dev Returns the account approved for `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function getApproved(uint256 tokenId) external view returns (address operator);
171 
172     /**
173      * @dev Approve or remove `operator` as an operator for the caller.
174      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
175      *
176      * Requirements:
177      *
178      * - The `operator` cannot be the caller.
179      *
180      * Emits an {ApprovalForAll} event.
181      */
182     function setApprovalForAll(address operator, bool _approved) external;
183 
184     /**
185      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
186      *
187      * See {setApprovalForAll}
188      */
189     function isApprovedForAll(address owner, address operator) external view returns (bool);
190 
191     /**
192       * @dev Safely transfers `tokenId` token from `from` to `to`.
193       *
194       * Requirements:
195       *
196       * - `from` cannot be the zero address.
197       * - `to` cannot be the zero address.
198       * - `tokenId` token must exist and be owned by `from`.
199       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201       *
202       * Emits a {Transfer} event.
203       */
204     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
205 }
206 
207 
208 
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Enumerable is IERC721 {
218 
219     /**
220      * @dev Returns the total amount of tokens stored by the contract.
221      */
222     function totalSupply() external view returns (uint256);
223 
224     /**
225      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
226      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
227      */
228     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
229 
230     /**
231      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
232      * Use along with {totalSupply} to enumerate all tokens.
233      */
234     function tokenByIndex(uint256 index) external view returns (uint256);
235 }
236 
237 
238 pragma solidity ^0.8.0;
239 
240 
241 /**
242  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
243  * @dev See https://eips.ethereum.org/EIPS/eip-721
244  */
245 interface IERC721Metadata is IERC721 {
246 
247     /**
248      * @dev Returns the token collection name.
249      */
250     function name() external view returns (string memory);
251 
252     /**
253      * @dev Returns the token collection symbol.
254      */
255     function symbol() external view returns (string memory);
256 
257     /**
258      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259      */
260     function tokenURI(uint256 tokenId) external view returns (string memory);
261 }
262 
263 
264 
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @title ERC721 token receiver interface
270  * @dev Interface for any contract that wants to support safeTransfers
271  * from ERC721 asset contracts.
272  */
273 interface IERC721Receiver {
274     /**
275      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
276      * by `operator` from `from`, this function is called.
277      *
278      * It must return its Solidity selector to confirm the token transfer.
279      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
280      *
281      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
282      */
283     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
284 }
285 
286 
287 
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 
316 pragma solidity ^0.8.0;
317 
318 
319 /**
320  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
321  * the Metadata extension, but not including the Enumerable extension, which is available separately as
322  * {ERC721Enumerable}.
323  */
324 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
325     using Address for address;
326     using Strings for uint256;
327 
328     // Token name
329     string private _name;
330 
331     // Token symbol
332     string private _symbol;
333 
334     // Mapping from token ID to owner address
335     mapping (uint256 => address) private _owners;
336 
337     // Mapping owner address to token count
338     mapping (address => uint256) private _balances;
339 
340     // Mapping from token ID to approved address
341     mapping (uint256 => address) private _tokenApprovals;
342 
343     // Mapping from owner to operator approvals
344     mapping (address => mapping (address => bool)) private _operatorApprovals;
345 
346     /**
347      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
348      */
349     constructor (string memory name_, string memory symbol_) {
350         _name = name_;
351         _symbol = symbol_;
352     }
353 
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
358         return interfaceId == type(IERC721).interfaceId
359             || interfaceId == type(IERC721Metadata).interfaceId
360             || super.supportsInterface(interfaceId);
361     }
362 
363     /**
364      * @dev See {IERC721-balanceOf}.
365      */
366     function balanceOf(address owner) public view virtual override returns (uint256) {
367         require(owner != address(0), "ERC721: balance query for the zero address");
368         return _balances[owner];
369     }
370 
371     /**
372      * @dev See {IERC721-ownerOf}.
373      */
374     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
375         address owner = _owners[tokenId];
376         require(owner != address(0), "ERC721: owner query for nonexistent token");
377         return owner;
378     }
379 
380     /**
381      * @dev See {IERC721Metadata-name}.
382      */
383     function name() public view virtual override returns (string memory) {
384         return _name;
385     }
386 
387     /**
388      * @dev See {IERC721Metadata-symbol}.
389      */
390     function symbol() public view virtual override returns (string memory) {
391         return _symbol;
392     }
393 
394     /**
395      * @dev See {IERC721Metadata-tokenURI}.
396      */
397     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
398         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
399 
400         string memory baseURI = _baseURI();
401         return bytes(baseURI).length > 0
402             ? string(abi.encodePacked(baseURI, tokenId.toString()))
403             : '';
404     }
405 
406     /**
407      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
408      * in child contracts.
409      */
410     function _baseURI() internal view virtual returns (string memory) {
411         return "";
412     }
413 
414     /**
415      * @dev See {IERC721-approve}.
416      */
417     function approve(address to, uint256 tokenId) public virtual override {
418         address owner = ERC721.ownerOf(tokenId);
419         require(to != owner, "ERC721: approval to current owner");
420 
421         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
422             "ERC721: approve caller is not owner nor approved for all"
423         );
424 
425         _approve(to, tokenId);
426     }
427 
428     /**
429      * @dev See {IERC721-getApproved}.
430      */
431     function getApproved(uint256 tokenId) public view virtual override returns (address) {
432         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
433 
434         return _tokenApprovals[tokenId];
435     }
436 
437     /**
438      * @dev See {IERC721-setApprovalForAll}.
439      */
440     function setApprovalForAll(address operator, bool approved) public virtual override {
441         require(operator != _msgSender(), "ERC721: approve to caller");
442 
443         _operatorApprovals[_msgSender()][operator] = approved;
444         emit ApprovalForAll(_msgSender(), operator, approved);
445     }
446 
447     /**
448      * @dev See {IERC721-isApprovedForAll}.
449      */
450     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
451         return _operatorApprovals[owner][operator];
452     }
453 
454     /**
455      * @dev See {IERC721-transferFrom}.
456      */
457     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
458         //solhint-disable-next-line max-line-length
459         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
460 
461         _transfer(from, to, tokenId);
462     }
463 
464     /**
465      * @dev See {IERC721-safeTransferFrom}.
466      */
467     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
468         safeTransferFrom(from, to, tokenId, "");
469     }
470 
471     /**
472      * @dev See {IERC721-safeTransferFrom}.
473      */
474     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
475         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
476         _safeTransfer(from, to, tokenId, _data);
477     }
478 
479     /**
480      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
481      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
482      *
483      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
484      *
485      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
486      * implement alternative mechanisms to perform token transfer, such as signature-based.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must exist and be owned by `from`.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
498         _transfer(from, to, tokenId);
499         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
500     }
501 
502     /**
503      * @dev Returns whether `tokenId` exists.
504      *
505      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
506      *
507      * Tokens start existing when they are minted (`_mint`),
508      * and stop existing when they are burned (`_burn`).
509      */
510     function _exists(uint256 tokenId) internal view virtual returns (bool) {
511         return _owners[tokenId] != address(0);
512     }
513 
514     /**
515      * @dev Returns whether `spender` is allowed to manage `tokenId`.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
522         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
523         address owner = ERC721.ownerOf(tokenId);
524         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
525     }
526 
527 
528     /**
529      * @dev Mints `tokenId` and transfers it to `to`.
530      *
531      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
532      *
533      * Requirements:
534      *
535      * - `tokenId` must not exist.
536      * - `to` cannot be the zero address.
537      *
538      * Emits a {Transfer} event.
539      */
540     function _mint(address to, uint256 tokenId) internal virtual {
541         require(to != address(0), "ERC721: mint to the zero address");
542         require(!_exists(tokenId), "ERC721: token already minted");
543 
544         _beforeTokenTransfer(address(0), to, tokenId);
545 
546         _balances[to] += 1;
547         _owners[tokenId] = to;
548 
549         emit Transfer(address(0), to, tokenId);
550     }
551 
552     /**
553      * @dev Destroys `tokenId`.
554      * The approval is cleared when the token is burned.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      *
560      * Emits a {Transfer} event.
561      */
562     function _burn(uint256 tokenId) internal virtual {
563         address owner = ERC721.ownerOf(tokenId);
564 
565         _beforeTokenTransfer(owner, address(0), tokenId);
566 
567         // Clear approvals
568         _approve(address(0), tokenId);
569 
570         _balances[owner] -= 1;
571         delete _owners[tokenId];
572 
573         emit Transfer(owner, address(0), tokenId);
574     }
575 
576     /**
577      * @dev Transfers `tokenId` from `from` to `to`.
578      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
579      *
580      * Requirements:
581      *
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must be owned by `from`.
584      *
585      * Emits a {Transfer} event.
586      */
587     function _transfer(address from, address to, uint256 tokenId) internal virtual {
588         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
589         require(to != address(0), "ERC721: transfer to the zero address");
590 
591         _beforeTokenTransfer(from, to, tokenId);
592 
593         // Clear approvals from the previous owner
594         _approve(address(0), tokenId);
595 
596         _balances[from] -= 1;
597         _balances[to] += 1;
598         _owners[tokenId] = to;
599 
600         emit Transfer(from, to, tokenId);
601     }
602 
603     /**
604      * @dev Approve `to` to operate on `tokenId`
605      *
606      * Emits a {Approval} event.
607      */
608     function _approve(address to, uint256 tokenId) internal virtual {
609         _tokenApprovals[tokenId] = to;
610         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
611     }
612 
613     /**
614      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
615      * The call is not executed if the target address is not a contract.
616      *
617      * @param from address representing the previous owner of the given token ID
618      * @param to target address that will receive the tokens
619      * @param tokenId uint256 ID of the token to be transferred
620      * @param _data bytes optional data to send along with the call
621      * @return bool whether the call correctly returned the expected magic value
622      */
623     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
624         private returns (bool)
625     {
626         if (to.isContract()) {
627             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
628                 return retval == IERC721Receiver(to).onERC721Received.selector;
629             } catch (bytes memory reason) {
630                 if (reason.length == 0) {
631                     revert("ERC721: transfer to non ERC721Receiver implementer");
632                 } else {
633                     // solhint-disable-next-line no-inline-assembly
634                     assembly {
635                         revert(add(32, reason), mload(reason))
636                     }
637                 }
638             }
639         } else {
640             return true;
641         }
642     }
643 
644     /**
645      * @dev Hook that is called before any token transfer. This includes minting
646      * and burning.
647      *
648      * Calling conditions:
649      *
650      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
651      * transferred to `to`.
652      * - When `from` is zero, `tokenId` will be minted for `to`.
653      * - When `to` is zero, ``from``'s `tokenId` will be burned.
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      *
657      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
658      */
659     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
660 }
661 
662 
663 
664 pragma solidity ^0.8.0;
665 
666 
667 /**
668  * @title ERC721 Burnable Token
669  * @dev ERC721 Token that can be irreversibly burned (destroyed).
670  */
671 abstract contract ERC721Burnable is Context, ERC721 {
672     /**
673      * @dev Burns `tokenId`. See {ERC721-_burn}.
674      *
675      * Requirements:
676      *
677      * - The caller must own `tokenId` or be an approved operator.
678      */
679     function burn(uint256 tokenId) public virtual {
680         //solhint-disable-next-line max-line-length
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
682         _burn(tokenId);
683     }
684 }
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
693  * enumerability of all the token ids in the contract as well as all token ids owned by each
694  * account.
695  */
696 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
697     // Mapping from owner to list of owned token IDs
698     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
699 
700     // Mapping from token ID to index of the owner tokens list
701     mapping(uint256 => uint256) private _ownedTokensIndex;
702 
703     // Array with all token ids, used for enumeration
704     uint256[] private _allTokens;
705 
706     // Mapping from token id to position in the allTokens array
707     mapping(uint256 => uint256) private _allTokensIndex;
708 
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
713         return interfaceId == type(IERC721Enumerable).interfaceId
714             || super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
721         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
722         return _ownedTokens[owner][index];
723     }
724 
725     /**
726      * @dev See {IERC721Enumerable-totalSupply}.
727      */
728     function totalSupply() public view virtual override returns (uint256) {
729         return _allTokens.length;
730     }
731 
732     /**
733      * @dev See {IERC721Enumerable-tokenByIndex}.
734      */
735     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
736         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
737         return _allTokens[index];
738     }
739 
740     /**
741      * @dev Hook that is called before any token transfer. This includes minting
742      * and burning.
743      *
744      * Calling conditions:
745      *
746      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
747      * transferred to `to`.
748      * - When `from` is zero, `tokenId` will be minted for `to`.
749      * - When `to` is zero, ``from``'s `tokenId` will be burned.
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      *
753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
754      */
755     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
756         super._beforeTokenTransfer(from, to, tokenId);
757 
758         if (from == address(0)) {
759             _addTokenToAllTokensEnumeration(tokenId);
760         } else if (from != to) {
761             _removeTokenFromOwnerEnumeration(from, tokenId);
762         }
763         if (to == address(0)) {
764             _removeTokenFromAllTokensEnumeration(tokenId);
765         } else if (to != from) {
766             _addTokenToOwnerEnumeration(to, tokenId);
767         }
768     }
769 
770     /**
771      * @dev Private function to add a token to this extension's ownership-tracking data structures.
772      * @param to address representing the new owner of the given token ID
773      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
774      */
775     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
776         uint256 length = ERC721.balanceOf(to);
777         _ownedTokens[to][length] = tokenId;
778         _ownedTokensIndex[tokenId] = length;
779     }
780 
781     /**
782      * @dev Private function to add a token to this extension's token tracking data structures.
783      * @param tokenId uint256 ID of the token to be added to the tokens list
784      */
785     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
786         _allTokensIndex[tokenId] = _allTokens.length;
787         _allTokens.push(tokenId);
788     }
789 
790     /**
791      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
792      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
793      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
794      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
795      * @param from address representing the previous owner of the given token ID
796      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
797      */
798     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
799         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
800         // then delete the last slot (swap and pop).
801 
802         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
803         uint256 tokenIndex = _ownedTokensIndex[tokenId];
804 
805         // When the token to delete is the last token, the swap operation is unnecessary
806         if (tokenIndex != lastTokenIndex) {
807             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
808 
809             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
810             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
811         }
812 
813         // This also deletes the contents at the last position of the array
814         delete _ownedTokensIndex[tokenId];
815         delete _ownedTokens[from][lastTokenIndex];
816     }
817 
818     /**
819      * @dev Private function to remove a token from this extension's token tracking data structures.
820      * This has O(1) time complexity, but alters the order of the _allTokens array.
821      * @param tokenId uint256 ID of the token to be removed from the tokens list
822      */
823     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
824         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
825         // then delete the last slot (swap and pop).
826 
827         uint256 lastTokenIndex = _allTokens.length - 1;
828         uint256 tokenIndex = _allTokensIndex[tokenId];
829 
830         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
831         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
832         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
833         uint256 lastTokenId = _allTokens[lastTokenIndex];
834 
835         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
836         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
837 
838         // This also deletes the contents at the last position of the array
839         delete _allTokensIndex[tokenId];
840         _allTokens.pop();
841     }
842 }
843 
844 
845 
846 
847 
848 pragma solidity ^0.8.0;
849 
850 
851 /**
852  * @dev Contract module which provides a basic access control mechanism, where
853  * there is an account (an owner) that can be granted exclusive access to
854  * specific functions.
855  *
856  * By default, the owner account will be the one that deploys the contract. This
857  * can later be changed with {transferOwnership}.
858  *
859  * This module is used through inheritance. It will make available the modifier
860  * `onlyOwner`, which can be applied to your functions to restrict their use to
861  * the owner.
862  */
863 abstract contract Ownable is Context {
864     address private _owner;
865 
866     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
867 
868     /**
869      * @dev Initializes the contract setting the deployer as the initial owner.
870      */
871     constructor() {
872         _setOwner(_msgSender());
873     }
874 
875     /**
876      * @dev Returns the address of the current owner.
877      */
878     function owner() public view virtual returns (address) {
879         return _owner;
880     }
881 
882     /**
883      * @dev Throws if called by any account other than the owner.
884      */
885     modifier onlyOwner() {
886         require(owner() == _msgSender(), "Ownable: caller is not the owner");
887         _;
888     }
889 
890     /**
891      * @dev Leaves the contract without owner. It will not be possible to call
892      * `onlyOwner` functions anymore. Can only be called by the current owner.
893      *
894      * NOTE: Renouncing ownership will leave the contract without an owner,
895      * thereby removing any functionality that is only available to the owner.
896      */
897     function renounceOwnership() public virtual onlyOwner {
898         _setOwner(address(0));
899     }
900 
901     /**
902      * @dev Transfers ownership of the contract to a new account (`newOwner`).
903      * Can only be called by the current owner.
904      */
905     function transferOwnership(address newOwner) public virtual onlyOwner {
906         require(newOwner != address(0), "Ownable: new owner is the zero address");
907         _setOwner(newOwner);
908     }
909 
910     function _setOwner(address newOwner) private {
911         address oldOwner = _owner;
912         _owner = newOwner;
913         emit OwnershipTransferred(oldOwner, newOwner);
914     }
915 }
916 
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev String operations.
924  */
925 library Strings {
926     bytes16 private constant alphabet = "0123456789abcdef";
927 
928     /**
929      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
930      */
931     function toString(uint256 value) internal pure returns (string memory) {
932         // Inspired by OraclizeAPI's implementation - MIT licence
933         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
934 
935         if (value == 0) {
936             return "0";
937         }
938         uint256 temp = value;
939         uint256 digits;
940         while (temp != 0) {
941             digits++;
942             temp /= 10;
943         }
944         bytes memory buffer = new bytes(digits);
945         while (value != 0) {
946             digits -= 1;
947             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
948             value /= 10;
949         }
950         return string(buffer);
951     }
952 
953     /**
954      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
955      */
956     function toHexString(uint256 value) internal pure returns (string memory) {
957         if (value == 0) {
958             return "0x00";
959         }
960         uint256 temp = value;
961         uint256 length = 0;
962         while (temp != 0) {
963             length++;
964             temp >>= 8;
965         }
966         return toHexString(value, length);
967     }
968 
969     /**
970      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
971      */
972     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
973         bytes memory buffer = new bytes(2 * length + 2);
974         buffer[0] = "0";
975         buffer[1] = "x";
976         for (uint256 i = 2 * length + 1; i > 1; --i) {
977             buffer[i] = alphabet[value & 0xf];
978             value >>= 4;
979         }
980         require(value == 0, "Strings: hex length insufficient");
981         return string(buffer);
982     }
983 
984 }
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev Collection of functions related to the address type
992  */
993 library Address {
994     /**
995      * @dev Returns true if `account` is a contract.
996      *
997      * [IMPORTANT]
998      * ====
999      * It is unsafe to assume that an address for which this function returns
1000      * false is an externally-owned account (EOA) and not a contract.
1001      *
1002      * Among others, `isContract` will return false for the following
1003      * types of addresses:
1004      *
1005      *  - an externally-owned account
1006      *  - a contract in construction
1007      *  - an address where a contract will be created
1008      *  - an address where a contract lived, but was destroyed
1009      * ====
1010      */
1011     function isContract(address account) internal view returns (bool) {
1012         // This method relies on extcodesize, which returns 0 for contracts in
1013         // construction, since the code is only stored at the end of the
1014         // constructor execution.
1015 
1016         uint256 size;
1017         assembly {
1018             size := extcodesize(account)
1019         }
1020         return size > 0;
1021     }
1022 
1023     /**
1024      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1025      * `recipient`, forwarding all available gas and reverting on errors.
1026      *
1027      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1028      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1029      * imposed by `transfer`, making them unable to receive funds via
1030      * `transfer`. {sendValue} removes this limitation.
1031      *
1032      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1033      *
1034      * IMPORTANT: because control is transferred to `recipient`, care must be
1035      * taken to not create reentrancy vulnerabilities. Consider using
1036      * {ReentrancyGuard} or the
1037      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1038      */
1039     function sendValue(address payable recipient, uint256 amount) internal {
1040         require(address(this).balance >= amount, "Address: insufficient balance");
1041 
1042         (bool success, ) = recipient.call{value: amount}("");
1043         require(success, "Address: unable to send value, recipient may have reverted");
1044     }
1045 
1046     /**
1047      * @dev Performs a Solidity function call using a low level `call`. A
1048      * plain `call` is an unsafe replacement for a function call: use this
1049      * function instead.
1050      *
1051      * If `target` reverts with a revert reason, it is bubbled up by this
1052      * function (like regular Solidity function calls).
1053      *
1054      * Returns the raw returned data. To convert to the expected return value,
1055      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1056      *
1057      * Requirements:
1058      *
1059      * - `target` must be a contract.
1060      * - calling `target` with `data` must not revert.
1061      *
1062      * _Available since v3.1._
1063      */
1064     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1065         return functionCall(target, data, "Address: low-level call failed");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1070      * `errorMessage` as a fallback revert reason when `target` reverts.
1071      *
1072      * _Available since v3.1._
1073      */
1074     function functionCall(
1075         address target,
1076         bytes memory data,
1077         string memory errorMessage
1078     ) internal returns (bytes memory) {
1079         return functionCallWithValue(target, data, 0, errorMessage);
1080     }
1081 
1082     /**
1083      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1084      * but also transferring `value` wei to `target`.
1085      *
1086      * Requirements:
1087      *
1088      * - the calling contract must have an ETH balance of at least `value`.
1089      * - the called Solidity function must be `payable`.
1090      *
1091      * _Available since v3.1._
1092      */
1093     function functionCallWithValue(
1094         address target,
1095         bytes memory data,
1096         uint256 value
1097     ) internal returns (bytes memory) {
1098         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1099     }
1100 
1101     /**
1102      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1103      * with `errorMessage` as a fallback revert reason when `target` reverts.
1104      *
1105      * _Available since v3.1._
1106      */
1107     function functionCallWithValue(
1108         address target,
1109         bytes memory data,
1110         uint256 value,
1111         string memory errorMessage
1112     ) internal returns (bytes memory) {
1113         require(address(this).balance >= value, "Address: insufficient balance for call");
1114         require(isContract(target), "Address: call to non-contract");
1115 
1116         (bool success, bytes memory returndata) = target.call{value: value}(data);
1117         return _verifyCallResult(success, returndata, errorMessage);
1118     }
1119 
1120     /**
1121      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1122      * but performing a static call.
1123      *
1124      * _Available since v3.3._
1125      */
1126     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1127         return functionStaticCall(target, data, "Address: low-level static call failed");
1128     }
1129 
1130     /**
1131      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1132      * but performing a static call.
1133      *
1134      * _Available since v3.3._
1135      */
1136     function functionStaticCall(
1137         address target,
1138         bytes memory data,
1139         string memory errorMessage
1140     ) internal view returns (bytes memory) {
1141         require(isContract(target), "Address: static call to non-contract");
1142 
1143         (bool success, bytes memory returndata) = target.staticcall(data);
1144         return _verifyCallResult(success, returndata, errorMessage);
1145     }
1146 
1147     /**
1148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1149      * but performing a delegate call.
1150      *
1151      * _Available since v3.4._
1152      */
1153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1159      * but performing a delegate call.
1160      *
1161      * _Available since v3.4._
1162      */
1163     function functionDelegateCall(
1164         address target,
1165         bytes memory data,
1166         string memory errorMessage
1167     ) internal returns (bytes memory) {
1168         require(isContract(target), "Address: delegate call to non-contract");
1169 
1170         (bool success, bytes memory returndata) = target.delegatecall(data);
1171         return _verifyCallResult(success, returndata, errorMessage);
1172     }
1173 
1174     function _verifyCallResult(
1175         bool success,
1176         bytes memory returndata,
1177         string memory errorMessage
1178     ) private pure returns (bytes memory) {
1179         if (success) {
1180             return returndata;
1181         } else {
1182             // Look for revert reason and bubble it up if present
1183             if (returndata.length > 0) {
1184                 // The easiest way to bubble the revert reason is using memory via assembly
1185 
1186                 assembly {
1187                     let returndata_size := mload(returndata)
1188                     revert(add(32, returndata), returndata_size)
1189                 }
1190             } else {
1191                 revert(errorMessage);
1192             }
1193         }
1194     }
1195 }
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 contract Einform is Context, ERC721Enumerable, ERC721Burnable, Ownable {
1201     using Counters for Counters.Counter;
1202 
1203     Counters.Counter private _tokenIdTracker;
1204 
1205     string private _baseTokenURI;
1206     
1207     uint private constant maxEinforms = 1000;
1208     uint private constant mintPrice = 50000000000000000;
1209     bool private paused = false;
1210     
1211     event CreateEinform(uint indexed id);
1212     
1213     mapping(uint => uint) private cardsMap;
1214 
1215     constructor() ERC721("Einform", "Einform") {
1216         _baseTokenURI = "";
1217     }
1218 
1219     function _baseURI() internal view virtual override returns (string memory) {
1220         return _baseTokenURI;
1221     }
1222     
1223     function setBaseURI(string memory baseURI) external onlyOwner {
1224         _baseTokenURI = baseURI;
1225     }
1226 
1227     function mint(uint amount) public payable {
1228         require(!paused || msg.sender == owner());
1229         require(amount > 0 && amount < 11, "You have to mint between 1 and 10 Einforms.");
1230         require(msg.value == mintPrice*amount || msg.sender == owner(), "It costs 0.05 eth to mint an Einform.");
1231         require(_tokenIdTracker.current() + amount < maxEinforms, "There can only be 999 Einforms!");
1232         for(uint i = 0; i < amount; i++) {
1233             _tokenIdTracker.increment();
1234             _mint(msg.sender, _tokenIdTracker.current());
1235             emit CreateEinform(_tokenIdTracker.current());
1236         }
1237     }
1238 
1239     function pause() public virtual onlyOwner {
1240         paused = true;
1241     }
1242 
1243     function unpause() public virtual onlyOwner {
1244         paused = false;
1245     }
1246     
1247     function withdraw() external onlyOwner {
1248         payable(msg.sender).transfer(address(this).balance);
1249     }
1250 
1251     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1252         super._beforeTokenTransfer(from, to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev See {IERC165-supportsInterface}.
1257      */
1258     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1259         return super.supportsInterface(interfaceId);
1260     }
1261 }