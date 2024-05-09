1 // SPDX-License-Identifier: MIT
2 //
3 //   ________               __     ______      __    ___           
4 //  / ____/ /_  ____  _____/ /_   / ____/___  / /_  / (_)___  _____
5 // / / __/ __ \/ __ \/ ___/ __/  / / __/ __ \/ __ \/ / / __ \/ ___/
6 /// /_/ / / / / /_/ (__  ) /_   / /_/ / /_/ / /_/ / / / / / (__  ) 
7 //\____/_/ /_/\____/____/\__/   \____/\____/_.___/_/_/_/ /_/____/  
8 //
9 //
10 //Contract by @CobbleDev
11 //
12 
13 pragma solidity ^0.8.0;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @title Counters
31  * @author Matt Condon (@shrugs)
32  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
33  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
34  *
35  * Include with `using Counters for Counters.Counter;`
36  */
37 library Counters {
38     struct Counter {
39         // This variable should never be directly accessed by users of the library: interactions must be restricted to
40         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
41         // this feature: see https://github.com/ethereum/solidity/issues/4637
42         uint256 _value; // default: 0
43     }
44 
45     function current(Counter storage counter) internal view returns (uint256) {
46         return counter._value;
47     }
48 
49     function increment(Counter storage counter) internal {
50         unchecked {
51             counter._value += 1;
52         }
53     }
54 
55     function decrement(Counter storage counter) internal {
56         uint256 value = counter._value;
57         require(value > 0, "Counter: decrement overflow");
58         unchecked {
59             counter._value = value - 1;
60         }
61     }
62 }
63 
64 
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Interface of the ERC165 standard, as defined in the
70  * https://eips.ethereum.org/EIPS/eip-165[EIP].
71  *
72  * Implementers can declare support of contract interfaces, which can then be
73  * queried by others ({ERC165Checker}).
74  *
75  * For an implementation, see {ERC165}.
76  */
77 interface IERC165 {
78     /**
79      * @dev Returns true if this contract implements the interface defined by
80      * `interfaceId`. See the corresponding
81      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
82      * to learn more about how these ids are created.
83      *
84      * This function call must use less than 30 000 gas.
85      */
86     function supportsInterface(bytes4 interfaceId) external view returns (bool);
87 }
88 
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Required interface of an ERC721 compliant contract.
95  */
96 interface IERC721 is IERC165 {
97     /**
98      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
101 
102     /**
103      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
104      */
105     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
106 
107     /**
108      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
109      */
110     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
111 
112     /**
113      * @dev Returns the number of tokens in ``owner``'s account.
114      */
115     function balanceOf(address owner) external view returns (uint256 balance);
116 
117     /**
118      * @dev Returns the owner of the `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function ownerOf(uint256 tokenId) external view returns (address owner);
125 
126     /**
127      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
128      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must exist and be owned by `from`.
135      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
137      *
138      * Emits a {Transfer} event.
139      */
140     function safeTransferFrom(address from, address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Transfers `tokenId` token from `from` to `to`.
144      *
145      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transferFrom(address from, address to, uint256 tokenId) external;
157 
158     /**
159      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
160      * The approval is cleared when the token is transferred.
161      *
162      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
163      *
164      * Requirements:
165      *
166      * - The caller must own the token or be an approved operator.
167      * - `tokenId` must exist.
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Returns the account approved for `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function getApproved(uint256 tokenId) external view returns (address operator);
181 
182     /**
183      * @dev Approve or remove `operator` as an operator for the caller.
184      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
185      *
186      * Requirements:
187      *
188      * - The `operator` cannot be the caller.
189      *
190      * Emits an {ApprovalForAll} event.
191      */
192     function setApprovalForAll(address operator, bool _approved) external;
193 
194     /**
195      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
196      *
197      * See {setApprovalForAll}
198      */
199     function isApprovedForAll(address owner, address operator) external view returns (bool);
200 
201     /**
202       * @dev Safely transfers `tokenId` token from `from` to `to`.
203       *
204       * Requirements:
205       *
206       * - `from` cannot be the zero address.
207       * - `to` cannot be the zero address.
208       * - `tokenId` token must exist and be owned by `from`.
209       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211       *
212       * Emits a {Transfer} event.
213       */
214     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
215 }
216 
217 
218 
219 
220 pragma solidity ^0.8.0;
221 
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Enumerable is IERC721 {
228 
229     /**
230      * @dev Returns the total amount of tokens stored by the contract.
231      */
232     function totalSupply() external view returns (uint256);
233 
234     /**
235      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
236      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
237      */
238     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
239 
240     /**
241      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
242      * Use along with {totalSupply} to enumerate all tokens.
243      */
244     function tokenByIndex(uint256 index) external view returns (uint256);
245 }
246 
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Metadata is IERC721 {
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 
274 
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @title ERC721 token receiver interface
280  * @dev Interface for any contract that wants to support safeTransfers
281  * from ERC721 asset contracts.
282  */
283 interface IERC721Receiver {
284     /**
285      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
286      * by `operator` from `from`, this function is called.
287      *
288      * It must return its Solidity selector to confirm the token transfer.
289      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
290      *
291      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
292      */
293     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
294 }
295 
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
306  * for the additional interface id that will be supported. For example:
307  *
308  * ```solidity
309  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
311  * }
312  * ```
313  *
314  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
315  */
316 abstract contract ERC165 is IERC165 {
317     /**
318      * @dev See {IERC165-supportsInterface}.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
331  * the Metadata extension, but not including the Enumerable extension, which is available separately as
332  * {ERC721Enumerable}.
333  */
334 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
335     using Address for address;
336     using Strings for uint256;
337 
338     // Token name
339     string private _name;
340 
341     // Token symbol
342     string private _symbol;
343 
344     // Mapping from token ID to owner address
345     mapping (uint256 => address) private _owners;
346 
347     // Mapping owner address to token count
348     mapping (address => uint256) private _balances;
349 
350     // Mapping from token ID to approved address
351     mapping (uint256 => address) private _tokenApprovals;
352 
353     // Mapping from owner to operator approvals
354     mapping (address => mapping (address => bool)) private _operatorApprovals;
355 
356     /**
357      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
358      */
359     constructor (string memory name_, string memory symbol_) {
360         _name = name_;
361         _symbol = symbol_;
362     }
363 
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
368         return interfaceId == type(IERC721).interfaceId
369             || interfaceId == type(IERC721Metadata).interfaceId
370             || super.supportsInterface(interfaceId);
371     }
372 
373     /**
374      * @dev See {IERC721-balanceOf}.
375      */
376     function balanceOf(address owner) public view virtual override returns (uint256) {
377         require(owner != address(0), "ERC721: balance query for the zero address");
378         return _balances[owner];
379     }
380 
381     /**
382      * @dev See {IERC721-ownerOf}.
383      */
384     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
385         address owner = _owners[tokenId];
386         require(owner != address(0), "ERC721: owner query for nonexistent token");
387         return owner;
388     }
389 
390     /**
391      * @dev See {IERC721Metadata-name}.
392      */
393     function name() public view virtual override returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev See {IERC721Metadata-symbol}.
399      */
400     function symbol() public view virtual override returns (string memory) {
401         return _symbol;
402     }
403 
404     /**
405      * @dev See {IERC721Metadata-tokenURI}.
406      */
407     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
408         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
409 
410         string memory baseURI = _baseURI();
411         return bytes(baseURI).length > 0
412             ? string(abi.encodePacked(baseURI, tokenId.toString()))
413             : '';
414     }
415 
416     /**
417      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
418      * in child contracts.
419      */
420     function _baseURI() internal view virtual returns (string memory) {
421         return "";
422     }
423 
424     /**
425      * @dev See {IERC721-approve}.
426      */
427     function approve(address to, uint256 tokenId) public virtual override {
428         address owner = ERC721.ownerOf(tokenId);
429         require(to != owner, "ERC721: approval to current owner");
430 
431         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
432             "ERC721: approve caller is not owner nor approved for all"
433         );
434 
435         _approve(to, tokenId);
436     }
437 
438     /**
439      * @dev See {IERC721-getApproved}.
440      */
441     function getApproved(uint256 tokenId) public view virtual override returns (address) {
442         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
443 
444         return _tokenApprovals[tokenId];
445     }
446 
447     /**
448      * @dev See {IERC721-setApprovalForAll}.
449      */
450     function setApprovalForAll(address operator, bool approved) public virtual override {
451         require(operator != _msgSender(), "ERC721: approve to caller");
452 
453         _operatorApprovals[_msgSender()][operator] = approved;
454         emit ApprovalForAll(_msgSender(), operator, approved);
455     }
456 
457     /**
458      * @dev See {IERC721-isApprovedForAll}.
459      */
460     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
461         return _operatorApprovals[owner][operator];
462     }
463 
464     /**
465      * @dev See {IERC721-transferFrom}.
466      */
467     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
468         //solhint-disable-next-line max-line-length
469         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
470 
471         _transfer(from, to, tokenId);
472     }
473 
474     /**
475      * @dev See {IERC721-safeTransferFrom}.
476      */
477     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
478         safeTransferFrom(from, to, tokenId, "");
479     }
480 
481     /**
482      * @dev See {IERC721-safeTransferFrom}.
483      */
484     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
485         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
486         _safeTransfer(from, to, tokenId, _data);
487     }
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
494      *
495      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
496      * implement alternative mechanisms to perform token transfer, such as signature-based.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must exist and be owned by `from`.
503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
504      *
505      * Emits a {Transfer} event.
506      */
507     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
508         _transfer(from, to, tokenId);
509         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
510     }
511 
512     /**
513      * @dev Returns whether `tokenId` exists.
514      *
515      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
516      *
517      * Tokens start existing when they are minted (`_mint`),
518      * and stop existing when they are burned (`_burn`).
519      */
520     function _exists(uint256 tokenId) internal view virtual returns (bool) {
521         return _owners[tokenId] != address(0);
522     }
523 
524     /**
525      * @dev Returns whether `spender` is allowed to manage `tokenId`.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
532         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
533         address owner = ERC721.ownerOf(tokenId);
534         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
535     }
536 
537 
538     /**
539      * @dev Mints `tokenId` and transfers it to `to`.
540      *
541      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
542      *
543      * Requirements:
544      *
545      * - `tokenId` must not exist.
546      * - `to` cannot be the zero address.
547      *
548      * Emits a {Transfer} event.
549      */
550     function _mint(address to, uint256 tokenId) internal virtual {
551         require(to != address(0), "ERC721: mint to the zero address");
552         require(!_exists(tokenId), "ERC721: token already minted");
553 
554         _beforeTokenTransfer(address(0), to, tokenId);
555 
556         _balances[to] += 1;
557         _owners[tokenId] = to;
558 
559         emit Transfer(address(0), to, tokenId);
560     }
561 
562     /**
563      * @dev Destroys `tokenId`.
564      * The approval is cleared when the token is burned.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      *
570      * Emits a {Transfer} event.
571      */
572     function _burn(uint256 tokenId) internal virtual {
573         address owner = ERC721.ownerOf(tokenId);
574 
575         _beforeTokenTransfer(owner, address(0), tokenId);
576 
577         // Clear approvals
578         _approve(address(0), tokenId);
579 
580         _balances[owner] -= 1;
581         delete _owners[tokenId];
582 
583         emit Transfer(owner, address(0), tokenId);
584     }
585 
586     /**
587      * @dev Transfers `tokenId` from `from` to `to`.
588      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
589      *
590      * Requirements:
591      *
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must be owned by `from`.
594      *
595      * Emits a {Transfer} event.
596      */
597     function _transfer(address from, address to, uint256 tokenId) internal virtual {
598         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
599         require(to != address(0), "ERC721: transfer to the zero address");
600 
601         _beforeTokenTransfer(from, to, tokenId);
602 
603         // Clear approvals from the previous owner
604         _approve(address(0), tokenId);
605 
606         _balances[from] -= 1;
607         _balances[to] += 1;
608         _owners[tokenId] = to;
609 
610         emit Transfer(from, to, tokenId);
611     }
612 
613     /**
614      * @dev Approve `to` to operate on `tokenId`
615      *
616      * Emits a {Approval} event.
617      */
618     function _approve(address to, uint256 tokenId) internal virtual {
619         _tokenApprovals[tokenId] = to;
620         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
621     }
622 
623     /**
624      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
625      * The call is not executed if the target address is not a contract.
626      *
627      * @param from address representing the previous owner of the given token ID
628      * @param to target address that will receive the tokens
629      * @param tokenId uint256 ID of the token to be transferred
630      * @param _data bytes optional data to send along with the call
631      * @return bool whether the call correctly returned the expected magic value
632      */
633     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
634         private returns (bool)
635     {
636         if (to.isContract()) {
637             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
638                 return retval == IERC721Receiver(to).onERC721Received.selector;
639             } catch (bytes memory reason) {
640                 if (reason.length == 0) {
641                     revert("ERC721: transfer to non ERC721Receiver implementer");
642                 } else {
643                     // solhint-disable-next-line no-inline-assembly
644                     assembly {
645                         revert(add(32, reason), mload(reason))
646                     }
647                 }
648             }
649         } else {
650             return true;
651         }
652     }
653 
654     /**
655      * @dev Hook that is called before any token transfer. This includes minting
656      * and burning.
657      *
658      * Calling conditions:
659      *
660      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
661      * transferred to `to`.
662      * - When `from` is zero, `tokenId` will be minted for `to`.
663      * - When `to` is zero, ``from``'s `tokenId` will be burned.
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      *
667      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
668      */
669     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
670 }
671 
672 
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @title ERC721 Burnable Token
679  * @dev ERC721 Token that can be irreversibly burned (destroyed).
680  */
681 abstract contract ERC721Burnable is Context, ERC721 {
682     /**
683      * @dev Burns `tokenId`. See {ERC721-_burn}.
684      *
685      * Requirements:
686      *
687      * - The caller must own `tokenId` or be an approved operator.
688      */
689     function burn(uint256 tokenId) public virtual {
690         //solhint-disable-next-line max-line-length
691         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
692         _burn(tokenId);
693     }
694 }
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
703  * enumerability of all the token ids in the contract as well as all token ids owned by each
704  * account.
705  */
706 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
707     // Mapping from owner to list of owned token IDs
708     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
709 
710     // Mapping from token ID to index of the owner tokens list
711     mapping(uint256 => uint256) private _ownedTokensIndex;
712 
713     // Array with all token ids, used for enumeration
714     uint256[] private _allTokens;
715 
716     // Mapping from token id to position in the allTokens array
717     mapping(uint256 => uint256) private _allTokensIndex;
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
723         return interfaceId == type(IERC721Enumerable).interfaceId
724             || super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
729      */
730     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
731         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
732         return _ownedTokens[owner][index];
733     }
734 
735     /**
736      * @dev See {IERC721Enumerable-totalSupply}.
737      */
738     function totalSupply() public view virtual override returns (uint256) {
739         return _allTokens.length;
740     }
741 
742     /**
743      * @dev See {IERC721Enumerable-tokenByIndex}.
744      */
745     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
746         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
747         return _allTokens[index];
748     }
749 
750     /**
751      * @dev Hook that is called before any token transfer. This includes minting
752      * and burning.
753      *
754      * Calling conditions:
755      *
756      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
757      * transferred to `to`.
758      * - When `from` is zero, `tokenId` will be minted for `to`.
759      * - When `to` is zero, ``from``'s `tokenId` will be burned.
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      *
763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
764      */
765     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
766         super._beforeTokenTransfer(from, to, tokenId);
767 
768         if (from == address(0)) {
769             _addTokenToAllTokensEnumeration(tokenId);
770         } else if (from != to) {
771             _removeTokenFromOwnerEnumeration(from, tokenId);
772         }
773         if (to == address(0)) {
774             _removeTokenFromAllTokensEnumeration(tokenId);
775         } else if (to != from) {
776             _addTokenToOwnerEnumeration(to, tokenId);
777         }
778     }
779 
780     /**
781      * @dev Private function to add a token to this extension's ownership-tracking data structures.
782      * @param to address representing the new owner of the given token ID
783      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
784      */
785     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
786         uint256 length = ERC721.balanceOf(to);
787         _ownedTokens[to][length] = tokenId;
788         _ownedTokensIndex[tokenId] = length;
789     }
790 
791     /**
792      * @dev Private function to add a token to this extension's token tracking data structures.
793      * @param tokenId uint256 ID of the token to be added to the tokens list
794      */
795     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
796         _allTokensIndex[tokenId] = _allTokens.length;
797         _allTokens.push(tokenId);
798     }
799 
800     /**
801      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
802      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
803      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
804      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
805      * @param from address representing the previous owner of the given token ID
806      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
807      */
808     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
809         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
810         // then delete the last slot (swap and pop).
811 
812         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
813         uint256 tokenIndex = _ownedTokensIndex[tokenId];
814 
815         // When the token to delete is the last token, the swap operation is unnecessary
816         if (tokenIndex != lastTokenIndex) {
817             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
818 
819             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
820             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
821         }
822 
823         // This also deletes the contents at the last position of the array
824         delete _ownedTokensIndex[tokenId];
825         delete _ownedTokens[from][lastTokenIndex];
826     }
827 
828     /**
829      * @dev Private function to remove a token from this extension's token tracking data structures.
830      * This has O(1) time complexity, but alters the order of the _allTokens array.
831      * @param tokenId uint256 ID of the token to be removed from the tokens list
832      */
833     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
834         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
835         // then delete the last slot (swap and pop).
836 
837         uint256 lastTokenIndex = _allTokens.length - 1;
838         uint256 tokenIndex = _allTokensIndex[tokenId];
839 
840         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
841         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
842         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
843         uint256 lastTokenId = _allTokens[lastTokenIndex];
844 
845         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
846         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
847 
848         // This also deletes the contents at the last position of the array
849         delete _allTokensIndex[tokenId];
850         _allTokens.pop();
851     }
852 }
853 
854 
855 
856 
857 
858 pragma solidity ^0.8.0;
859 
860 
861 /**
862  * @dev Contract module which provides a basic access control mechanism, where
863  * there is an account (an owner) that can be granted exclusive access to
864  * specific functions.
865  *
866  * By default, the owner account will be the one that deploys the contract. This
867  * can later be changed with {transferOwnership}.
868  *
869  * This module is used through inheritance. It will make available the modifier
870  * `onlyOwner`, which can be applied to your functions to restrict their use to
871  * the owner.
872  */
873 abstract contract Ownable is Context {
874     address private _owner;
875 
876     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
877 
878     /**
879      * @dev Initializes the contract setting the deployer as the initial owner.
880      */
881     constructor() {
882         _setOwner(_msgSender());
883     }
884 
885     /**
886      * @dev Returns the address of the current owner.
887      */
888     function owner() public view virtual returns (address) {
889         return _owner;
890     }
891 
892     /**
893      * @dev Throws if called by any account other than the owner.
894      */
895     modifier onlyOwner() {
896         require(owner() == _msgSender(), "Ownable: caller is not the owner");
897         _;
898     }
899 
900     /**
901      * @dev Leaves the contract without owner. It will not be possible to call
902      * `onlyOwner` functions anymore. Can only be called by the current owner.
903      *
904      * NOTE: Renouncing ownership will leave the contract without an owner,
905      * thereby removing any functionality that is only available to the owner.
906      */
907     function renounceOwnership() public virtual onlyOwner {
908         _setOwner(address(0));
909     }
910 
911     /**
912      * @dev Transfers ownership of the contract to a new account (`newOwner`).
913      * Can only be called by the current owner.
914      */
915     function transferOwnership(address newOwner) public virtual onlyOwner {
916         require(newOwner != address(0), "Ownable: new owner is the zero address");
917         _setOwner(newOwner);
918     }
919 
920     function _setOwner(address newOwner) private {
921         address oldOwner = _owner;
922         _owner = newOwner;
923         emit OwnershipTransferred(oldOwner, newOwner);
924     }
925 }
926 
927 
928 
929 
930 pragma solidity ^0.8.0;
931 
932 /**
933  * @dev String operations.
934  */
935 library Strings {
936     bytes16 private constant alphabet = "0123456789abcdef";
937 
938     /**
939      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
940      */
941     function toString(uint256 value) internal pure returns (string memory) {
942         // Inspired by OraclizeAPI's implementation - MIT licence
943         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
944 
945         if (value == 0) {
946             return "0";
947         }
948         uint256 temp = value;
949         uint256 digits;
950         while (temp != 0) {
951             digits++;
952             temp /= 10;
953         }
954         bytes memory buffer = new bytes(digits);
955         while (value != 0) {
956             digits -= 1;
957             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
958             value /= 10;
959         }
960         return string(buffer);
961     }
962 
963     /**
964      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
965      */
966     function toHexString(uint256 value) internal pure returns (string memory) {
967         if (value == 0) {
968             return "0x00";
969         }
970         uint256 temp = value;
971         uint256 length = 0;
972         while (temp != 0) {
973             length++;
974             temp >>= 8;
975         }
976         return toHexString(value, length);
977     }
978 
979     /**
980      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
981      */
982     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
983         bytes memory buffer = new bytes(2 * length + 2);
984         buffer[0] = "0";
985         buffer[1] = "x";
986         for (uint256 i = 2 * length + 1; i > 1; --i) {
987             buffer[i] = alphabet[value & 0xf];
988             value >>= 4;
989         }
990         require(value == 0, "Strings: hex length insufficient");
991         return string(buffer);
992     }
993 
994 }
995 
996 
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @dev Collection of functions related to the address type
1002  */
1003 library Address {
1004     /**
1005      * @dev Returns true if `account` is a contract.
1006      *
1007      * [IMPORTANT]
1008      * ====
1009      * It is unsafe to assume that an address for which this function returns
1010      * false is an externally-owned account (EOA) and not a contract.
1011      *
1012      * Among others, `isContract` will return false for the following
1013      * types of addresses:
1014      *
1015      *  - an externally-owned account
1016      *  - a contract in construction
1017      *  - an address where a contract will be created
1018      *  - an address where a contract lived, but was destroyed
1019      * ====
1020      */
1021     function isContract(address account) internal view returns (bool) {
1022         // This method relies on extcodesize, which returns 0 for contracts in
1023         // construction, since the code is only stored at the end of the
1024         // constructor execution.
1025 
1026         uint256 size;
1027         assembly {
1028             size := extcodesize(account)
1029         }
1030         return size > 0;
1031     }
1032 
1033     /**
1034      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1035      * `recipient`, forwarding all available gas and reverting on errors.
1036      *
1037      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1038      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1039      * imposed by `transfer`, making them unable to receive funds via
1040      * `transfer`. {sendValue} removes this limitation.
1041      *
1042      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1043      *
1044      * IMPORTANT: because control is transferred to `recipient`, care must be
1045      * taken to not create reentrancy vulnerabilities. Consider using
1046      * {ReentrancyGuard} or the
1047      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1048      */
1049     function sendValue(address payable recipient, uint256 amount) internal {
1050         require(address(this).balance >= amount, "Address: insufficient balance");
1051 
1052         (bool success, ) = recipient.call{value: amount}("");
1053         require(success, "Address: unable to send value, recipient may have reverted");
1054     }
1055 
1056     /**
1057      * @dev Performs a Solidity function call using a low level `call`. A
1058      * plain `call` is an unsafe replacement for a function call: use this
1059      * function instead.
1060      *
1061      * If `target` reverts with a revert reason, it is bubbled up by this
1062      * function (like regular Solidity function calls).
1063      *
1064      * Returns the raw returned data. To convert to the expected return value,
1065      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1066      *
1067      * Requirements:
1068      *
1069      * - `target` must be a contract.
1070      * - calling `target` with `data` must not revert.
1071      *
1072      * _Available since v3.1._
1073      */
1074     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1075         return functionCall(target, data, "Address: low-level call failed");
1076     }
1077 
1078     /**
1079      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1080      * `errorMessage` as a fallback revert reason when `target` reverts.
1081      *
1082      * _Available since v3.1._
1083      */
1084     function functionCall(
1085         address target,
1086         bytes memory data,
1087         string memory errorMessage
1088     ) internal returns (bytes memory) {
1089         return functionCallWithValue(target, data, 0, errorMessage);
1090     }
1091 
1092     /**
1093      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1094      * but also transferring `value` wei to `target`.
1095      *
1096      * Requirements:
1097      *
1098      * - the calling contract must have an ETH balance of at least `value`.
1099      * - the called Solidity function must be `payable`.
1100      *
1101      * _Available since v3.1._
1102      */
1103     function functionCallWithValue(
1104         address target,
1105         bytes memory data,
1106         uint256 value
1107     ) internal returns (bytes memory) {
1108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1109     }
1110 
1111     /**
1112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1113      * with `errorMessage` as a fallback revert reason when `target` reverts.
1114      *
1115      * _Available since v3.1._
1116      */
1117     function functionCallWithValue(
1118         address target,
1119         bytes memory data,
1120         uint256 value,
1121         string memory errorMessage
1122     ) internal returns (bytes memory) {
1123         require(address(this).balance >= value, "Address: insufficient balance for call");
1124         require(isContract(target), "Address: call to non-contract");
1125 
1126         (bool success, bytes memory returndata) = target.call{value: value}(data);
1127         return _verifyCallResult(success, returndata, errorMessage);
1128     }
1129 
1130     /**
1131      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1132      * but performing a static call.
1133      *
1134      * _Available since v3.3._
1135      */
1136     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1137         return functionStaticCall(target, data, "Address: low-level static call failed");
1138     }
1139 
1140     /**
1141      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1142      * but performing a static call.
1143      *
1144      * _Available since v3.3._
1145      */
1146     function functionStaticCall(
1147         address target,
1148         bytes memory data,
1149         string memory errorMessage
1150     ) internal view returns (bytes memory) {
1151         require(isContract(target), "Address: static call to non-contract");
1152 
1153         (bool success, bytes memory returndata) = target.staticcall(data);
1154         return _verifyCallResult(success, returndata, errorMessage);
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1159      * but performing a delegate call.
1160      *
1161      * _Available since v3.4._
1162      */
1163     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1164         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1165     }
1166 
1167     /**
1168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1169      * but performing a delegate call.
1170      *
1171      * _Available since v3.4._
1172      */
1173     function functionDelegateCall(
1174         address target,
1175         bytes memory data,
1176         string memory errorMessage
1177     ) internal returns (bytes memory) {
1178         require(isContract(target), "Address: delegate call to non-contract");
1179 
1180         (bool success, bytes memory returndata) = target.delegatecall(data);
1181         return _verifyCallResult(success, returndata, errorMessage);
1182     }
1183 
1184     function _verifyCallResult(
1185         bool success,
1186         bytes memory returndata,
1187         string memory errorMessage
1188     ) private pure returns (bytes memory) {
1189         if (success) {
1190             return returndata;
1191         } else {
1192             // Look for revert reason and bubble it up if present
1193             if (returndata.length > 0) {
1194                 // The easiest way to bubble the revert reason is using memory via assembly
1195 
1196                 assembly {
1197                     let returndata_size := mload(returndata)
1198                     revert(add(32, returndata), returndata_size)
1199                 }
1200             } else {
1201                 revert(errorMessage);
1202             }
1203         }
1204     }
1205 }
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 // CAUTION
1210 // This version of SafeMath should only be used with Solidity 0.8 or later,
1211 // because it relies on the compiler's built in overflow checks.
1212 
1213 /**
1214  * @dev Wrappers over Solidity's arithmetic operations.
1215  *
1216  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1217  * now has built in overflow checking.
1218  */
1219 library SafeMath {
1220     /**
1221      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1222      *
1223      * _Available since v3.4._
1224      */
1225     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1226         unchecked {
1227             uint256 c = a + b;
1228             if (c < a) return (false, 0);
1229             return (true, c);
1230         }
1231     }
1232 
1233     /**
1234      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1235      *
1236      * _Available since v3.4._
1237      */
1238     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1239         unchecked {
1240             if (b > a) return (false, 0);
1241             return (true, a - b);
1242         }
1243     }
1244 
1245     /**
1246      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1251         unchecked {
1252             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1253             // benefit is lost if 'b' is also tested.
1254             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1255             if (a == 0) return (true, 0);
1256             uint256 c = a * b;
1257             if (c / a != b) return (false, 0);
1258             return (true, c);
1259         }
1260     }
1261 
1262     /**
1263      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1264      *
1265      * _Available since v3.4._
1266      */
1267     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1268         unchecked {
1269             if (b == 0) return (false, 0);
1270             return (true, a / b);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1276      *
1277      * _Available since v3.4._
1278      */
1279     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1280         unchecked {
1281             if (b == 0) return (false, 0);
1282             return (true, a % b);
1283         }
1284     }
1285 
1286     /**
1287      * @dev Returns the addition of two unsigned integers, reverting on
1288      * overflow.
1289      *
1290      * Counterpart to Solidity's `+` operator.
1291      *
1292      * Requirements:
1293      *
1294      * - Addition cannot overflow.
1295      */
1296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1297         return a + b;
1298     }
1299 
1300     /**
1301      * @dev Returns the subtraction of two unsigned integers, reverting on
1302      * overflow (when the result is negative).
1303      *
1304      * Counterpart to Solidity's `-` operator.
1305      *
1306      * Requirements:
1307      *
1308      * - Subtraction cannot overflow.
1309      */
1310     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1311         return a - b;
1312     }
1313 
1314     /**
1315      * @dev Returns the multiplication of two unsigned integers, reverting on
1316      * overflow.
1317      *
1318      * Counterpart to Solidity's `*` operator.
1319      *
1320      * Requirements:
1321      *
1322      * - Multiplication cannot overflow.
1323      */
1324     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1325         return a * b;
1326     }
1327 
1328     /**
1329      * @dev Returns the integer division of two unsigned integers, reverting on
1330      * division by zero. The result is rounded towards zero.
1331      *
1332      * Counterpart to Solidity's `/` operator.
1333      *
1334      * Requirements:
1335      *
1336      * - The divisor cannot be zero.
1337      */
1338     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1339         return a / b;
1340     }
1341 
1342     /**
1343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1344      * reverting when dividing by zero.
1345      *
1346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1347      * opcode (which leaves remaining gas untouched) while Solidity uses an
1348      * invalid opcode to revert (consuming all remaining gas).
1349      *
1350      * Requirements:
1351      *
1352      * - The divisor cannot be zero.
1353      */
1354     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1355         return a % b;
1356     }
1357 
1358     /**
1359      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1360      * overflow (when the result is negative).
1361      *
1362      * CAUTION: This function is deprecated because it requires allocating memory for the error
1363      * message unnecessarily. For custom revert reasons use {trySub}.
1364      *
1365      * Counterpart to Solidity's `-` operator.
1366      *
1367      * Requirements:
1368      *
1369      * - Subtraction cannot overflow.
1370      */
1371     function sub(
1372         uint256 a,
1373         uint256 b,
1374         string memory errorMessage
1375     ) internal pure returns (uint256) {
1376         unchecked {
1377             require(b <= a, errorMessage);
1378             return a - b;
1379         }
1380     }
1381 
1382     /**
1383      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1384      * division by zero. The result is rounded towards zero.
1385      *
1386      * Counterpart to Solidity's `/` operator. Note: this function uses a
1387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1388      * uses an invalid opcode to revert (consuming all remaining gas).
1389      *
1390      * Requirements:
1391      *
1392      * - The divisor cannot be zero.
1393      */
1394     function div(
1395         uint256 a,
1396         uint256 b,
1397         string memory errorMessage
1398     ) internal pure returns (uint256) {
1399         unchecked {
1400             require(b > 0, errorMessage);
1401             return a / b;
1402         }
1403     }
1404 
1405     /**
1406      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1407      * reverting with custom message when dividing by zero.
1408      *
1409      * CAUTION: This function is deprecated because it requires allocating memory for the error
1410      * message unnecessarily. For custom revert reasons use {tryMod}.
1411      *
1412      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1413      * opcode (which leaves remaining gas untouched) while Solidity uses an
1414      * invalid opcode to revert (consuming all remaining gas).
1415      *
1416      * Requirements:
1417      *
1418      * - The divisor cannot be zero.
1419      */
1420     function mod(
1421         uint256 a,
1422         uint256 b,
1423         string memory errorMessage
1424     ) internal pure returns (uint256) {
1425         unchecked {
1426             require(b > 0, errorMessage);
1427             return a % b;
1428         }
1429     }
1430 }
1431 
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 interface GoblinInterface {
1436     function goldBalance(address) external view returns(uint);
1437     function getGoblinsCoins(uint) external view returns(uint);
1438     function burn(uint) external;
1439 }
1440 
1441 
1442 contract GoblinGhosts is Context, ERC721Enumerable, ERC721Burnable, Ownable {
1443     using Counters for Counters.Counter;
1444 
1445     Counters.Counter private _tokenIdTracker;
1446 
1447     string private _baseTokenURI;
1448     
1449     address GoblinContract = 0x6322834FE489003512A61662044BcFb5Eeb2A035;
1450     
1451     GoblinInterface gobInterface = GoblinInterface(GoblinContract);
1452     
1453     bool private paused = true;
1454     
1455     event CreateGhost(uint indexed id, uint coins, uint attributeSeed);
1456     
1457     mapping(uint => uint) private goldCoins;
1458 
1459     constructor() ERC721("Goblin Ghosts", "GGHOST") {
1460         _baseTokenURI = "https://goblingoonslair.com/ghost/";
1461     }
1462 
1463     function _baseURI() internal view virtual override returns (string memory) {
1464         return _baseTokenURI;
1465     }
1466     
1467     function setBaseURI(string memory baseURI) external onlyOwner {
1468         _baseTokenURI = baseURI;
1469     }
1470 
1471     function sacrifice(uint[] memory sacrifices) public {
1472         require(!paused || msg.sender == owner(), "The the pit is not open!");
1473         require(sacrifices.length > 1, "You have to burn at least 2 Goblins.");
1474         
1475         uint totalCoins = 0;
1476         for(uint i = 0; i < sacrifices.length; i++) {
1477             totalCoins = totalCoins + gobInterface.getGoblinsCoins(sacrifices[i]);
1478             gobInterface.burn(sacrifices[i]);
1479         }
1480         uint goblinCoin = SafeMath.div(totalCoins, sacrifices.length-1);
1481         uint remainderCoin = totalCoins - (goblinCoin*(sacrifices.length-1));
1482         
1483         for(uint i = 0; i < sacrifices.length-1; i++) {
1484             uint coins = goblinCoin;
1485             if(i == 0) {
1486                 coins = coins + remainderCoin;
1487             }
1488             if(i == sacrifices.length-2) {
1489                 coins = coins + 1;
1490             }
1491             _tokenIdTracker.increment();
1492             _mint(msg.sender, _tokenIdTracker.current());
1493             uint randomNumber =  uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, totalSupply())));
1494             goldCoins[_tokenIdTracker.current()] = coins;
1495             emit CreateGhost(_tokenIdTracker.current(), coins, randomNumber);
1496         }
1497     }
1498     
1499     function getGhostsCoins(uint id) public view returns(uint) {
1500         return goldCoins[id];
1501     }
1502     
1503     function goldBalance(address person) public view returns(uint) {
1504         uint total = gobInterface.goldBalance(person);
1505         for(uint i = 0; i < balanceOf(person); i++) {
1506             total = total + getGhostsCoins(tokenOfOwnerByIndex(person, i));
1507         }
1508         return total;
1509     }
1510 
1511     function pause() public virtual onlyOwner {
1512         paused = true;
1513     }
1514 
1515     function unpause() public virtual onlyOwner {
1516         paused = false;
1517     }
1518 
1519     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1520         super._beforeTokenTransfer(from, to, tokenId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC165-supportsInterface}.
1525      */
1526     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1527         return super.supportsInterface(interfaceId);
1528     }
1529 }