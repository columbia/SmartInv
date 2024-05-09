1 // SPDX-License-Identifier: MIT
2 //
3 //
4 //   _____  ____  ____  _      _____ _   _    _____  ____   ____  _   _  _____ 
5 //  / ____|/ __ \|  _ \| |    |_   _| \ | |  / ____|/ __ \ / __ \| \ | |/ ____|
6 // | |  __| |  | | |_) | |      | | |  \| | | |  __| |  | | |  | |  \| | (___  
7 // | | |_ | |  | |  _ <| |      | | | . ` | | | |_ | |  | | |  | | . ` |\___ \ 
8 // | |__| | |__| | |_) | |____ _| |_| |\  | | |__| | |__| | |__| | |\  |____) |
9 //  \_____|\____/|____/|______|_____|_| \_|  \_____|\____/ \____/|_| \_|_____/ 
10 //
11 //
12 //
13 //Contract by @CobbleDev
14 //
15 
16 pragma solidity ^0.8.0;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @title Counters
34  * @author Matt Condon (@shrugs)
35  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
36  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
37  *
38  * Include with `using Counters for Counters.Counter;`
39  */
40 library Counters {
41     struct Counter {
42         // This variable should never be directly accessed by users of the library: interactions must be restricted to
43         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
44         // this feature: see https://github.com/ethereum/solidity/issues/4637
45         uint256 _value; // default: 0
46     }
47 
48     function current(Counter storage counter) internal view returns (uint256) {
49         return counter._value;
50     }
51 
52     function increment(Counter storage counter) internal {
53         unchecked {
54             counter._value += 1;
55         }
56     }
57 
58     function decrement(Counter storage counter) internal {
59         uint256 value = counter._value;
60         require(value > 0, "Counter: decrement overflow");
61         unchecked {
62             counter._value = value - 1;
63         }
64     }
65 }
66 
67 
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Interface of the ERC165 standard, as defined in the
73  * https://eips.ethereum.org/EIPS/eip-165[EIP].
74  *
75  * Implementers can declare support of contract interfaces, which can then be
76  * queried by others ({ERC165Checker}).
77  *
78  * For an implementation, see {ERC165}.
79  */
80 interface IERC165 {
81     /**
82      * @dev Returns true if this contract implements the interface defined by
83      * `interfaceId`. See the corresponding
84      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
85      * to learn more about how these ids are created.
86      *
87      * This function call must use less than 30 000 gas.
88      */
89     function supportsInterface(bytes4 interfaceId) external view returns (bool);
90 }
91 
92 
93 pragma solidity ^0.8.0;
94 
95 
96 /**
97  * @dev Required interface of an ERC721 compliant contract.
98  */
99 interface IERC721 is IERC165 {
100     /**
101      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104 
105     /**
106      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
107      */
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109 
110     /**
111      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
112      */
113     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
114 
115     /**
116      * @dev Returns the number of tokens in ``owner``'s account.
117      */
118     function balanceOf(address owner) external view returns (uint256 balance);
119 
120     /**
121      * @dev Returns the owner of the `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function ownerOf(uint256 tokenId) external view returns (address owner);
128 
129     /**
130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must exist and be owned by `from`.
138      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
140      *
141      * Emits a {Transfer} event.
142      */
143     function safeTransferFrom(address from, address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Transfers `tokenId` token from `from` to `to`.
147      *
148      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address from, address to, uint256 tokenId) external;
160 
161     /**
162      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
163      * The approval is cleared when the token is transferred.
164      *
165      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
166      *
167      * Requirements:
168      *
169      * - The caller must own the token or be an approved operator.
170      * - `tokenId` must exist.
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address to, uint256 tokenId) external;
175 
176     /**
177      * @dev Returns the account approved for `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function getApproved(uint256 tokenId) external view returns (address operator);
184 
185     /**
186      * @dev Approve or remove `operator` as an operator for the caller.
187      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
188      *
189      * Requirements:
190      *
191      * - The `operator` cannot be the caller.
192      *
193      * Emits an {ApprovalForAll} event.
194      */
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     /**
198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
199      *
200      * See {setApprovalForAll}
201      */
202     function isApprovedForAll(address owner, address operator) external view returns (bool);
203 
204     /**
205       * @dev Safely transfers `tokenId` token from `from` to `to`.
206       *
207       * Requirements:
208       *
209       * - `from` cannot be the zero address.
210       * - `to` cannot be the zero address.
211       * - `tokenId` token must exist and be owned by `from`.
212       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214       *
215       * Emits a {Transfer} event.
216       */
217     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
218 }
219 
220 
221 
222 
223 pragma solidity ^0.8.0;
224 
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Enumerable is IERC721 {
231 
232     /**
233      * @dev Returns the total amount of tokens stored by the contract.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
239      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
240      */
241     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
242 
243     /**
244      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
245      * Use along with {totalSupply} to enumerate all tokens.
246      */
247     function tokenByIndex(uint256 index) external view returns (uint256);
248 }
249 
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
256  * @dev See https://eips.ethereum.org/EIPS/eip-721
257  */
258 interface IERC721Metadata is IERC721 {
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 }
275 
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @title ERC721 token receiver interface
283  * @dev Interface for any contract that wants to support safeTransfers
284  * from ERC721 asset contracts.
285  */
286 interface IERC721Receiver {
287     /**
288      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
289      * by `operator` from `from`, this function is called.
290      *
291      * It must return its Solidity selector to confirm the token transfer.
292      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
293      *
294      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
295      */
296     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
297 }
298 
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Implementation of the {IERC165} interface.
307  *
308  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
309  * for the additional interface id that will be supported. For example:
310  *
311  * ```solidity
312  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
314  * }
315  * ```
316  *
317  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
318  */
319 abstract contract ERC165 is IERC165 {
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return interfaceId == type(IERC165).interfaceId;
325     }
326 }
327 
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
334  * the Metadata extension, but not including the Enumerable extension, which is available separately as
335  * {ERC721Enumerable}.
336  */
337 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
338     using Address for address;
339     using Strings for uint256;
340 
341     // Token name
342     string private _name;
343 
344     // Token symbol
345     string private _symbol;
346 
347     // Mapping from token ID to owner address
348     mapping (uint256 => address) private _owners;
349 
350     // Mapping owner address to token count
351     mapping (address => uint256) private _balances;
352 
353     // Mapping from token ID to approved address
354     mapping (uint256 => address) private _tokenApprovals;
355 
356     // Mapping from owner to operator approvals
357     mapping (address => mapping (address => bool)) private _operatorApprovals;
358 
359     /**
360      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
361      */
362     constructor (string memory name_, string memory symbol_) {
363         _name = name_;
364         _symbol = symbol_;
365     }
366 
367     /**
368      * @dev See {IERC165-supportsInterface}.
369      */
370     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
371         return interfaceId == type(IERC721).interfaceId
372             || interfaceId == type(IERC721Metadata).interfaceId
373             || super.supportsInterface(interfaceId);
374     }
375 
376     /**
377      * @dev See {IERC721-balanceOf}.
378      */
379     function balanceOf(address owner) public view virtual override returns (uint256) {
380         require(owner != address(0), "ERC721: balance query for the zero address");
381         return _balances[owner];
382     }
383 
384     /**
385      * @dev See {IERC721-ownerOf}.
386      */
387     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
388         address owner = _owners[tokenId];
389         require(owner != address(0), "ERC721: owner query for nonexistent token");
390         return owner;
391     }
392 
393     /**
394      * @dev See {IERC721Metadata-name}.
395      */
396     function name() public view virtual override returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev See {IERC721Metadata-symbol}.
402      */
403     function symbol() public view virtual override returns (string memory) {
404         return _symbol;
405     }
406 
407     /**
408      * @dev See {IERC721Metadata-tokenURI}.
409      */
410     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
411         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
412 
413         string memory baseURI = _baseURI();
414         return bytes(baseURI).length > 0
415             ? string(abi.encodePacked(baseURI, tokenId.toString()))
416             : '';
417     }
418 
419     /**
420      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
421      * in child contracts.
422      */
423     function _baseURI() internal view virtual returns (string memory) {
424         return "";
425     }
426 
427     /**
428      * @dev See {IERC721-approve}.
429      */
430     function approve(address to, uint256 tokenId) public virtual override {
431         address owner = ERC721.ownerOf(tokenId);
432         require(to != owner, "ERC721: approval to current owner");
433 
434         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
435             "ERC721: approve caller is not owner nor approved for all"
436         );
437 
438         _approve(to, tokenId);
439     }
440 
441     /**
442      * @dev See {IERC721-getApproved}.
443      */
444     function getApproved(uint256 tokenId) public view virtual override returns (address) {
445         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
446 
447         return _tokenApprovals[tokenId];
448     }
449 
450     /**
451      * @dev See {IERC721-setApprovalForAll}.
452      */
453     function setApprovalForAll(address operator, bool approved) public virtual override {
454         require(operator != _msgSender(), "ERC721: approve to caller");
455 
456         _operatorApprovals[_msgSender()][operator] = approved;
457         emit ApprovalForAll(_msgSender(), operator, approved);
458     }
459 
460     /**
461      * @dev See {IERC721-isApprovedForAll}.
462      */
463     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
464         return _operatorApprovals[owner][operator];
465     }
466 
467     /**
468      * @dev See {IERC721-transferFrom}.
469      */
470     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
471         //solhint-disable-next-line max-line-length
472         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
473 
474         _transfer(from, to, tokenId);
475     }
476 
477     /**
478      * @dev See {IERC721-safeTransferFrom}.
479      */
480     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
481         safeTransferFrom(from, to, tokenId, "");
482     }
483 
484     /**
485      * @dev See {IERC721-safeTransferFrom}.
486      */
487     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
488         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
489         _safeTransfer(from, to, tokenId, _data);
490     }
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
497      *
498      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
499      * implement alternative mechanisms to perform token transfer, such as signature-based.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
511         _transfer(from, to, tokenId);
512         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
513     }
514 
515     /**
516      * @dev Returns whether `tokenId` exists.
517      *
518      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
519      *
520      * Tokens start existing when they are minted (`_mint`),
521      * and stop existing when they are burned (`_burn`).
522      */
523     function _exists(uint256 tokenId) internal view virtual returns (bool) {
524         return _owners[tokenId] != address(0);
525     }
526 
527     /**
528      * @dev Returns whether `spender` is allowed to manage `tokenId`.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
535         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
536         address owner = ERC721.ownerOf(tokenId);
537         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
538     }
539 
540 
541     /**
542      * @dev Mints `tokenId` and transfers it to `to`.
543      *
544      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
545      *
546      * Requirements:
547      *
548      * - `tokenId` must not exist.
549      * - `to` cannot be the zero address.
550      *
551      * Emits a {Transfer} event.
552      */
553     function _mint(address to, uint256 tokenId) internal virtual {
554         require(to != address(0), "ERC721: mint to the zero address");
555         require(!_exists(tokenId), "ERC721: token already minted");
556 
557         _beforeTokenTransfer(address(0), to, tokenId);
558 
559         _balances[to] += 1;
560         _owners[tokenId] = to;
561 
562         emit Transfer(address(0), to, tokenId);
563     }
564 
565     /**
566      * @dev Destroys `tokenId`.
567      * The approval is cleared when the token is burned.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      *
573      * Emits a {Transfer} event.
574      */
575     function _burn(uint256 tokenId) internal virtual {
576         address owner = ERC721.ownerOf(tokenId);
577 
578         _beforeTokenTransfer(owner, address(0), tokenId);
579 
580         // Clear approvals
581         _approve(address(0), tokenId);
582 
583         _balances[owner] -= 1;
584         delete _owners[tokenId];
585 
586         emit Transfer(owner, address(0), tokenId);
587     }
588 
589     /**
590      * @dev Transfers `tokenId` from `from` to `to`.
591      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
592      *
593      * Requirements:
594      *
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must be owned by `from`.
597      *
598      * Emits a {Transfer} event.
599      */
600     function _transfer(address from, address to, uint256 tokenId) internal virtual {
601         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
602         require(to != address(0), "ERC721: transfer to the zero address");
603 
604         _beforeTokenTransfer(from, to, tokenId);
605 
606         // Clear approvals from the previous owner
607         _approve(address(0), tokenId);
608 
609         _balances[from] -= 1;
610         _balances[to] += 1;
611         _owners[tokenId] = to;
612 
613         emit Transfer(from, to, tokenId);
614     }
615 
616     /**
617      * @dev Approve `to` to operate on `tokenId`
618      *
619      * Emits a {Approval} event.
620      */
621     function _approve(address to, uint256 tokenId) internal virtual {
622         _tokenApprovals[tokenId] = to;
623         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
624     }
625 
626     /**
627      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
628      * The call is not executed if the target address is not a contract.
629      *
630      * @param from address representing the previous owner of the given token ID
631      * @param to target address that will receive the tokens
632      * @param tokenId uint256 ID of the token to be transferred
633      * @param _data bytes optional data to send along with the call
634      * @return bool whether the call correctly returned the expected magic value
635      */
636     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
637         private returns (bool)
638     {
639         if (to.isContract()) {
640             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
641                 return retval == IERC721Receiver(to).onERC721Received.selector;
642             } catch (bytes memory reason) {
643                 if (reason.length == 0) {
644                     revert("ERC721: transfer to non ERC721Receiver implementer");
645                 } else {
646                     // solhint-disable-next-line no-inline-assembly
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
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      *
670      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
671      */
672     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
673 }
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @title ERC721 Burnable Token
682  * @dev ERC721 Token that can be irreversibly burned (destroyed).
683  */
684 abstract contract ERC721Burnable is Context, ERC721 {
685     /**
686      * @dev Burns `tokenId`. See {ERC721-_burn}.
687      *
688      * Requirements:
689      *
690      * - The caller must own `tokenId` or be an approved operator.
691      */
692     function burn(uint256 tokenId) public virtual {
693         //solhint-disable-next-line max-line-length
694         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
695         _burn(tokenId);
696     }
697 }
698 
699 
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
706  * enumerability of all the token ids in the contract as well as all token ids owned by each
707  * account.
708  */
709 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
710     // Mapping from owner to list of owned token IDs
711     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
712 
713     // Mapping from token ID to index of the owner tokens list
714     mapping(uint256 => uint256) private _ownedTokensIndex;
715 
716     // Array with all token ids, used for enumeration
717     uint256[] private _allTokens;
718 
719     // Mapping from token id to position in the allTokens array
720     mapping(uint256 => uint256) private _allTokensIndex;
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
726         return interfaceId == type(IERC721Enumerable).interfaceId
727             || super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
732      */
733     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
734         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
735         return _ownedTokens[owner][index];
736     }
737 
738     /**
739      * @dev See {IERC721Enumerable-totalSupply}.
740      */
741     function totalSupply() public view virtual override returns (uint256) {
742         return _allTokens.length;
743     }
744 
745     /**
746      * @dev See {IERC721Enumerable-tokenByIndex}.
747      */
748     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
749         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
750         return _allTokens[index];
751     }
752 
753     /**
754      * @dev Hook that is called before any token transfer. This includes minting
755      * and burning.
756      *
757      * Calling conditions:
758      *
759      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
760      * transferred to `to`.
761      * - When `from` is zero, `tokenId` will be minted for `to`.
762      * - When `to` is zero, ``from``'s `tokenId` will be burned.
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      *
766      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
767      */
768     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
769         super._beforeTokenTransfer(from, to, tokenId);
770 
771         if (from == address(0)) {
772             _addTokenToAllTokensEnumeration(tokenId);
773         } else if (from != to) {
774             _removeTokenFromOwnerEnumeration(from, tokenId);
775         }
776         if (to == address(0)) {
777             _removeTokenFromAllTokensEnumeration(tokenId);
778         } else if (to != from) {
779             _addTokenToOwnerEnumeration(to, tokenId);
780         }
781     }
782 
783     /**
784      * @dev Private function to add a token to this extension's ownership-tracking data structures.
785      * @param to address representing the new owner of the given token ID
786      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
787      */
788     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
789         uint256 length = ERC721.balanceOf(to);
790         _ownedTokens[to][length] = tokenId;
791         _ownedTokensIndex[tokenId] = length;
792     }
793 
794     /**
795      * @dev Private function to add a token to this extension's token tracking data structures.
796      * @param tokenId uint256 ID of the token to be added to the tokens list
797      */
798     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
799         _allTokensIndex[tokenId] = _allTokens.length;
800         _allTokens.push(tokenId);
801     }
802 
803     /**
804      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
805      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
806      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
807      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
808      * @param from address representing the previous owner of the given token ID
809      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
810      */
811     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
812         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
813         // then delete the last slot (swap and pop).
814 
815         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
816         uint256 tokenIndex = _ownedTokensIndex[tokenId];
817 
818         // When the token to delete is the last token, the swap operation is unnecessary
819         if (tokenIndex != lastTokenIndex) {
820             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
821 
822             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
823             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
824         }
825 
826         // This also deletes the contents at the last position of the array
827         delete _ownedTokensIndex[tokenId];
828         delete _ownedTokens[from][lastTokenIndex];
829     }
830 
831     /**
832      * @dev Private function to remove a token from this extension's token tracking data structures.
833      * This has O(1) time complexity, but alters the order of the _allTokens array.
834      * @param tokenId uint256 ID of the token to be removed from the tokens list
835      */
836     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
837         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
838         // then delete the last slot (swap and pop).
839 
840         uint256 lastTokenIndex = _allTokens.length - 1;
841         uint256 tokenIndex = _allTokensIndex[tokenId];
842 
843         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
844         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
845         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
846         uint256 lastTokenId = _allTokens[lastTokenIndex];
847 
848         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
849         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
850 
851         // This also deletes the contents at the last position of the array
852         delete _allTokensIndex[tokenId];
853         _allTokens.pop();
854     }
855 }
856 
857 
858 
859 
860 
861 pragma solidity ^0.8.0;
862 
863 
864 /**
865  * @dev Contract module which provides a basic access control mechanism, where
866  * there is an account (an owner) that can be granted exclusive access to
867  * specific functions.
868  *
869  * By default, the owner account will be the one that deploys the contract. This
870  * can later be changed with {transferOwnership}.
871  *
872  * This module is used through inheritance. It will make available the modifier
873  * `onlyOwner`, which can be applied to your functions to restrict their use to
874  * the owner.
875  */
876 abstract contract Ownable is Context {
877     address private _owner;
878 
879     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
880 
881     /**
882      * @dev Initializes the contract setting the deployer as the initial owner.
883      */
884     constructor() {
885         _setOwner(_msgSender());
886     }
887 
888     /**
889      * @dev Returns the address of the current owner.
890      */
891     function owner() public view virtual returns (address) {
892         return _owner;
893     }
894 
895     /**
896      * @dev Throws if called by any account other than the owner.
897      */
898     modifier onlyOwner() {
899         require(owner() == _msgSender(), "Ownable: caller is not the owner");
900         _;
901     }
902 
903     /**
904      * @dev Leaves the contract without owner. It will not be possible to call
905      * `onlyOwner` functions anymore. Can only be called by the current owner.
906      *
907      * NOTE: Renouncing ownership will leave the contract without an owner,
908      * thereby removing any functionality that is only available to the owner.
909      */
910     function renounceOwnership() public virtual onlyOwner {
911         _setOwner(address(0));
912     }
913 
914     /**
915      * @dev Transfers ownership of the contract to a new account (`newOwner`).
916      * Can only be called by the current owner.
917      */
918     function transferOwnership(address newOwner) public virtual onlyOwner {
919         require(newOwner != address(0), "Ownable: new owner is the zero address");
920         _setOwner(newOwner);
921     }
922 
923     function _setOwner(address newOwner) private {
924         address oldOwner = _owner;
925         _owner = newOwner;
926         emit OwnershipTransferred(oldOwner, newOwner);
927     }
928 }
929 
930 
931 
932 
933 pragma solidity ^0.8.0;
934 
935 /**
936  * @dev String operations.
937  */
938 library Strings {
939     bytes16 private constant alphabet = "0123456789abcdef";
940 
941     /**
942      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
943      */
944     function toString(uint256 value) internal pure returns (string memory) {
945         // Inspired by OraclizeAPI's implementation - MIT licence
946         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
947 
948         if (value == 0) {
949             return "0";
950         }
951         uint256 temp = value;
952         uint256 digits;
953         while (temp != 0) {
954             digits++;
955             temp /= 10;
956         }
957         bytes memory buffer = new bytes(digits);
958         while (value != 0) {
959             digits -= 1;
960             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
961             value /= 10;
962         }
963         return string(buffer);
964     }
965 
966     /**
967      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
968      */
969     function toHexString(uint256 value) internal pure returns (string memory) {
970         if (value == 0) {
971             return "0x00";
972         }
973         uint256 temp = value;
974         uint256 length = 0;
975         while (temp != 0) {
976             length++;
977             temp >>= 8;
978         }
979         return toHexString(value, length);
980     }
981 
982     /**
983      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
984      */
985     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
986         bytes memory buffer = new bytes(2 * length + 2);
987         buffer[0] = "0";
988         buffer[1] = "x";
989         for (uint256 i = 2 * length + 1; i > 1; --i) {
990             buffer[i] = alphabet[value & 0xf];
991             value >>= 4;
992         }
993         require(value == 0, "Strings: hex length insufficient");
994         return string(buffer);
995     }
996 
997 }
998 
999 
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 /**
1004  * @dev Collection of functions related to the address type
1005  */
1006 library Address {
1007     /**
1008      * @dev Returns true if `account` is a contract.
1009      *
1010      * [IMPORTANT]
1011      * ====
1012      * It is unsafe to assume that an address for which this function returns
1013      * false is an externally-owned account (EOA) and not a contract.
1014      *
1015      * Among others, `isContract` will return false for the following
1016      * types of addresses:
1017      *
1018      *  - an externally-owned account
1019      *  - a contract in construction
1020      *  - an address where a contract will be created
1021      *  - an address where a contract lived, but was destroyed
1022      * ====
1023      */
1024     function isContract(address account) internal view returns (bool) {
1025         // This method relies on extcodesize, which returns 0 for contracts in
1026         // construction, since the code is only stored at the end of the
1027         // constructor execution.
1028 
1029         uint256 size;
1030         assembly {
1031             size := extcodesize(account)
1032         }
1033         return size > 0;
1034     }
1035 
1036     /**
1037      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1038      * `recipient`, forwarding all available gas and reverting on errors.
1039      *
1040      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1041      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1042      * imposed by `transfer`, making them unable to receive funds via
1043      * `transfer`. {sendValue} removes this limitation.
1044      *
1045      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1046      *
1047      * IMPORTANT: because control is transferred to `recipient`, care must be
1048      * taken to not create reentrancy vulnerabilities. Consider using
1049      * {ReentrancyGuard} or the
1050      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1051      */
1052     function sendValue(address payable recipient, uint256 amount) internal {
1053         require(address(this).balance >= amount, "Address: insufficient balance");
1054 
1055         (bool success, ) = recipient.call{value: amount}("");
1056         require(success, "Address: unable to send value, recipient may have reverted");
1057     }
1058 
1059     /**
1060      * @dev Performs a Solidity function call using a low level `call`. A
1061      * plain `call` is an unsafe replacement for a function call: use this
1062      * function instead.
1063      *
1064      * If `target` reverts with a revert reason, it is bubbled up by this
1065      * function (like regular Solidity function calls).
1066      *
1067      * Returns the raw returned data. To convert to the expected return value,
1068      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1069      *
1070      * Requirements:
1071      *
1072      * - `target` must be a contract.
1073      * - calling `target` with `data` must not revert.
1074      *
1075      * _Available since v3.1._
1076      */
1077     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1078         return functionCall(target, data, "Address: low-level call failed");
1079     }
1080 
1081     /**
1082      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1083      * `errorMessage` as a fallback revert reason when `target` reverts.
1084      *
1085      * _Available since v3.1._
1086      */
1087     function functionCall(
1088         address target,
1089         bytes memory data,
1090         string memory errorMessage
1091     ) internal returns (bytes memory) {
1092         return functionCallWithValue(target, data, 0, errorMessage);
1093     }
1094 
1095     /**
1096      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1097      * but also transferring `value` wei to `target`.
1098      *
1099      * Requirements:
1100      *
1101      * - the calling contract must have an ETH balance of at least `value`.
1102      * - the called Solidity function must be `payable`.
1103      *
1104      * _Available since v3.1._
1105      */
1106     function functionCallWithValue(
1107         address target,
1108         bytes memory data,
1109         uint256 value
1110     ) internal returns (bytes memory) {
1111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1112     }
1113 
1114     /**
1115      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1116      * with `errorMessage` as a fallback revert reason when `target` reverts.
1117      *
1118      * _Available since v3.1._
1119      */
1120     function functionCallWithValue(
1121         address target,
1122         bytes memory data,
1123         uint256 value,
1124         string memory errorMessage
1125     ) internal returns (bytes memory) {
1126         require(address(this).balance >= value, "Address: insufficient balance for call");
1127         require(isContract(target), "Address: call to non-contract");
1128 
1129         (bool success, bytes memory returndata) = target.call{value: value}(data);
1130         return _verifyCallResult(success, returndata, errorMessage);
1131     }
1132 
1133     /**
1134      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1135      * but performing a static call.
1136      *
1137      * _Available since v3.3._
1138      */
1139     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1140         return functionStaticCall(target, data, "Address: low-level static call failed");
1141     }
1142 
1143     /**
1144      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1145      * but performing a static call.
1146      *
1147      * _Available since v3.3._
1148      */
1149     function functionStaticCall(
1150         address target,
1151         bytes memory data,
1152         string memory errorMessage
1153     ) internal view returns (bytes memory) {
1154         require(isContract(target), "Address: static call to non-contract");
1155 
1156         (bool success, bytes memory returndata) = target.staticcall(data);
1157         return _verifyCallResult(success, returndata, errorMessage);
1158     }
1159 
1160     /**
1161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1162      * but performing a delegate call.
1163      *
1164      * _Available since v3.4._
1165      */
1166     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1167         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1168     }
1169 
1170     /**
1171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1172      * but performing a delegate call.
1173      *
1174      * _Available since v3.4._
1175      */
1176     function functionDelegateCall(
1177         address target,
1178         bytes memory data,
1179         string memory errorMessage
1180     ) internal returns (bytes memory) {
1181         require(isContract(target), "Address: delegate call to non-contract");
1182 
1183         (bool success, bytes memory returndata) = target.delegatecall(data);
1184         return _verifyCallResult(success, returndata, errorMessage);
1185     }
1186 
1187     function _verifyCallResult(
1188         bool success,
1189         bytes memory returndata,
1190         string memory errorMessage
1191     ) private pure returns (bytes memory) {
1192         if (success) {
1193             return returndata;
1194         } else {
1195             // Look for revert reason and bubble it up if present
1196             if (returndata.length > 0) {
1197                 // The easiest way to bubble the revert reason is using memory via assembly
1198 
1199                 assembly {
1200                     let returndata_size := mload(returndata)
1201                     revert(add(32, returndata), returndata_size)
1202                 }
1203             } else {
1204                 revert(errorMessage);
1205             }
1206         }
1207     }
1208 }
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 
1213 contract GoblinGoons is Context, ERC721Enumerable, ERC721Burnable, Ownable {
1214     using Counters for Counters.Counter;
1215 
1216     Counters.Counter private _tokenIdTracker;
1217 
1218     string private _baseTokenURI;
1219     
1220     address CobbleAddress = 0xE0666cAC0C2267209Ba3Da4Db00c03315Fe64fA8;
1221     address DarkoAddress = 0x95270f71252AF1F92E54c777237091F9382Ca5D8;
1222     address MattAddress = 0xd17EdAE5256Ba32A8b34DD428Bcc625B704Ad104;
1223     
1224     
1225     uint private constant maxGoblins = 8500;
1226     uint private constant mintPrice = 30000000000000000;
1227     bool private paused = true;
1228     
1229     event CreateGoblin(uint indexed id, uint coins, uint attributeSeed);
1230     
1231     
1232     mapping(uint => uint) private goldCoins;
1233     uint public totalGoldCoins = 0;
1234 
1235     constructor() ERC721("Goblin Goons", "GOGS") {
1236         _baseTokenURI = "https://goblingoonslair.com/goblin/";
1237     }
1238 
1239     function _baseURI() internal view virtual override returns (string memory) {
1240         return _baseTokenURI;
1241     }
1242     
1243     function setBaseURI(string memory baseURI) external onlyOwner {
1244         _baseTokenURI = baseURI;
1245     }
1246     
1247 
1248     function mint(uint amount) public payable {
1249         require(!paused || msg.sender == owner());
1250         require(amount > 0 && amount < 11, "You can only mint between 1 and 10 Goblins.");
1251         require(msg.value == mintPrice*amount || msg.sender == owner(), "It costs 0.03 eth to mint a Goblin.");
1252         require(totalSupply() + amount < maxGoblins, "There can only be 8500 Goblins!");
1253         for(uint i = 0; i < amount; i++) {
1254             _tokenIdTracker.increment();
1255             mintGoblin(_tokenIdTracker.current());
1256         }
1257     }
1258     
1259     function mintGoblin(uint id) private {
1260         _mint(msg.sender, id);
1261         
1262         uint randomNumber =  uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, totalSupply())));
1263         
1264         uint randomCoins;
1265         if(randomNumber % 100 < 75) {randomCoins = 1;}
1266         else if(randomNumber % 100 < 95) {randomCoins = 2;}
1267         else {randomCoins = 3;}
1268         
1269         goldCoins[id] = randomCoins;
1270         totalGoldCoins = totalGoldCoins + randomCoins;
1271         emit CreateGoblin(id, randomCoins, randomNumber);
1272     }
1273     
1274     function getGoblinsCoins(uint id) public view returns(uint) {
1275         return goldCoins[id];
1276     }
1277     
1278     function goldBalance(address person) public view returns(uint) {
1279         uint total = 0;
1280         for(uint i = 0; i < balanceOf(person); i++) {
1281             total = total + getGoblinsCoins(tokenOfOwnerByIndex(person, i));
1282         }
1283         return total;
1284     }
1285 
1286     function pause() public virtual onlyOwner {
1287         paused = true;
1288     }
1289 
1290     function unpause() public virtual onlyOwner {
1291         paused = false;
1292     }
1293     
1294     function withdraw() external onlyOwner {
1295         uint balance = address(this).balance;
1296         payable(CobbleAddress).transfer((balance*3)/20);
1297         payable(DarkoAddress).transfer(balance/10);
1298         payable(MattAddress).transfer(balance/25);
1299         payable(msg.sender).transfer(address(this).balance);
1300     }
1301 
1302     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1303         super._beforeTokenTransfer(from, to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev See {IERC165-supportsInterface}.
1308      */
1309     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1310         return super.supportsInterface(interfaceId);
1311     }
1312 }