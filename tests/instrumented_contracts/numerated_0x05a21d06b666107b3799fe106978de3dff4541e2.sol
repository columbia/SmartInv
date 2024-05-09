1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 
47 // File: @openzeppelin/contracts/utils/Context.sol
48 
49 
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 
74 // File: @openzeppelin/contracts/access/Ownable.sol
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 
81 /**
82  * @dev Contract module which provides a basic access control mechanism, where
83  * there is an account (an owner) that can be granted exclusive access to
84  * specific functions.
85  *
86  * By default, the owner account will be the one that deploys the contract. This
87  * can later be changed with {transferOwnership}.
88  *
89  * This module is used through inheritance. It will make available the modifier
90  * `onlyOwner`, which can be applied to your functions to restrict their use to
91  * the owner.
92  */
93 abstract contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev Initializes the contract setting the deployer as the initial owner.
100      */
101     constructor() {
102         _setOwner(_msgSender());
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view virtual returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     /**
121      * @dev Leaves the contract without owner. It will not be possible to call
122      * `onlyOwner` functions anymore. Can only be called by the current owner.
123      *
124      * NOTE: Renouncing ownership will leave the contract without an owner,
125      * thereby removing any functionality that is only available to the owner.
126      */
127     function renounceOwnership() public virtual onlyOwner {
128         _setOwner(address(0));
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Can only be called by the current owner.
134      */
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         _setOwner(newOwner);
138     }
139 
140     function _setOwner(address newOwner) private {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 
148 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
149 
150 
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Interface of the ERC165 standard, as defined in the
156  * https://eips.ethereum.org/EIPS/eip-165[EIP].
157  *
158  * Implementers can declare support of contract interfaces, which can then be
159  * queried by others ({ERC165Checker}).
160  *
161  * For an implementation, see {ERC165}.
162  */
163 interface IERC165 {
164     /**
165      * @dev Returns true if this contract implements the interface defined by
166      * `interfaceId`. See the corresponding
167      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
168      * to learn more about how these ids are created.
169      *
170      * This function call must use less than 30 000 gas.
171      */
172     function supportsInterface(bytes4 interfaceId) external view returns (bool);
173 }
174 
175 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
176 
177 
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Implementation of the {IERC165} interface.
184  *
185  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
186  * for the additional interface id that will be supported. For example:
187  *
188  * ```solidity
189  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
190  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
191  * }
192  * ```
193  *
194  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
195  */
196 abstract contract ERC165 is IERC165 {
197     /**
198      * @dev See {IERC165-supportsInterface}.
199      */
200     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
201         return interfaceId == type(IERC165).interfaceId;
202     }
203 }
204 
205 
206 
207 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
208 
209 
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @dev Required interface of an ERC721 compliant contract.
216  */
217 interface IERC721 is IERC165 {
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
230      */
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237 
238     /**
239      * @dev Returns the owner of the `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function ownerOf(uint256 tokenId) external view returns (address owner);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
249      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external;
266 
267     /**
268      * @dev Transfers `tokenId` token from `from` to `to`.
269      *
270      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
292      *
293      * Requirements:
294      *
295      * - The caller must own the token or be an approved operator.
296      * - `tokenId` must exist.
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address to, uint256 tokenId) external;
301 
302     /**
303      * @dev Returns the account approved for `tokenId` token.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must exist.
308      */
309     function getApproved(uint256 tokenId) external view returns (address operator);
310 
311     /**
312      * @dev Approve or remove `operator` as an operator for the caller.
313      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
314      *
315      * Requirements:
316      *
317      * - The `operator` cannot be the caller.
318      *
319      * Emits an {ApprovalForAll} event.
320      */
321     function setApprovalForAll(address operator, bool _approved) external;
322 
323     /**
324      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
325      *
326      * See {setApprovalForAll}
327      */
328     function isApprovedForAll(address owner, address operator) external view returns (bool);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must exist and be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
340      *
341      * Emits a {Transfer} event.
342      */
343     function safeTransferFrom(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes calldata data
348     ) external;
349 }
350 
351 
352 
353 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
362  * @dev See https://eips.ethereum.org/EIPS/eip-721
363  */
364 interface IERC721Metadata is IERC721 {
365     /**
366      * @dev Returns the token collection name.
367      */
368     function name() external view returns (string memory);
369 
370     /**
371      * @dev Returns the token collection symbol.
372      */
373     function symbol() external view returns (string memory);
374 
375     /**
376      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
377      */
378     function tokenURI(uint256 tokenId) external view returns (string memory);
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
382 
383 
384 
385 pragma solidity ^0.8.0;
386 
387 
388 
389 
390 
391 
392 
393 
394 /**
395  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
396  * the Metadata extension, but not including the Enumerable extension, which is available separately as
397  * {ERC721Enumerable}.
398  */
399 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
400     using Address for address;
401     using Strings for uint256;
402 
403     // Token name
404     string private _name;
405 
406     // Token symbol
407     string private _symbol;
408 
409     // Mapping from token ID to owner address
410     mapping(uint256 => address) private _owners;
411 
412     // Mapping owner address to token count
413     mapping(address => uint256) private _balances;
414 
415     // Mapping from token ID to approved address
416     mapping(uint256 => address) private _tokenApprovals;
417 
418     // Mapping from owner to operator approvals
419     mapping(address => mapping(address => bool)) private _operatorApprovals;
420 
421     /**
422      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
423      */
424     constructor(string memory name_, string memory symbol_) {
425         _name = name_;
426         _symbol = symbol_;
427     }
428 
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
433         return
434             interfaceId == type(IERC721).interfaceId ||
435             interfaceId == type(IERC721Metadata).interfaceId ||
436             super.supportsInterface(interfaceId);
437     }
438 
439     /**
440      * @dev See {IERC721-balanceOf}.
441      */
442     function balanceOf(address owner) public view virtual override returns (uint256) {
443         require(owner != address(0), "ERC721: balance query for the zero address");
444         return _balances[owner];
445     }
446 
447     /**
448      * @dev See {IERC721-ownerOf}.
449      */
450     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
451         address owner = _owners[tokenId];
452         require(owner != address(0), "ERC721: owner query for nonexistent token");
453         return owner;
454     }
455 
456     /**
457      * @dev See {IERC721Metadata-name}.
458      */
459     function name() public view virtual override returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev See {IERC721Metadata-symbol}.
465      */
466     function symbol() public view virtual override returns (string memory) {
467         return _symbol;
468     }
469 
470     /**
471      * @dev See {IERC721Metadata-tokenURI}.
472      */
473     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
474         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
475 
476         string memory baseURI = _baseURI();
477         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
478     }
479 
480     /**
481      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
482      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
483      * by default, can be overriden in child contracts.
484      */
485     function _baseURI() internal view virtual returns (string memory) {
486         return "";
487     }
488 
489     /**
490      * @dev See {IERC721-approve}.
491      */
492     function approve(address to, uint256 tokenId) public virtual override {
493         address owner = ERC721.ownerOf(tokenId);
494         require(to != owner, "ERC721: approval to current owner");
495 
496         require(
497             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
498             "ERC721: approve caller is not owner nor approved for all"
499         );
500 
501         _approve(to, tokenId);
502     }
503 
504     /**
505      * @dev See {IERC721-getApproved}.
506      */
507     function getApproved(uint256 tokenId) public view virtual override returns (address) {
508         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
509 
510         return _tokenApprovals[tokenId];
511     }
512 
513     /**
514      * @dev See {IERC721-setApprovalForAll}.
515      */
516     function setApprovalForAll(address operator, bool approved) public virtual override {
517         require(operator != _msgSender(), "ERC721: approve to caller");
518 
519         _operatorApprovals[_msgSender()][operator] = approved;
520         emit ApprovalForAll(_msgSender(), operator, approved);
521     }
522 
523     /**
524      * @dev See {IERC721-isApprovedForAll}.
525      */
526     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
527         return _operatorApprovals[owner][operator];
528     }
529 
530     /**
531      * @dev See {IERC721-transferFrom}.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) public virtual override {
538         //solhint-disable-next-line max-line-length
539         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
540 
541         _transfer(from, to, tokenId);
542     }
543 
544     /**
545      * @dev See {IERC721-safeTransferFrom}.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) public virtual override {
552         safeTransferFrom(from, to, tokenId, "");
553     }
554 
555     /**
556      * @dev See {IERC721-safeTransferFrom}.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes memory _data
563     ) public virtual override {
564         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
565         _safeTransfer(from, to, tokenId, _data);
566     }
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
570      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
571      *
572      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
573      *
574      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
575      * implement alternative mechanisms to perform token transfer, such as signature-based.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function _safeTransfer(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes memory _data
591     ) internal virtual {
592         _transfer(from, to, tokenId);
593         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
594     }
595 
596     /**
597      * @dev Returns whether `tokenId` exists.
598      *
599      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
600      *
601      * Tokens start existing when they are minted (`_mint`),
602      * and stop existing when they are burned (`_burn`).
603      */
604     function _exists(uint256 tokenId) internal view virtual returns (bool) {
605         return _owners[tokenId] != address(0);
606     }
607 
608     /**
609      * @dev Returns whether `spender` is allowed to manage `tokenId`.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
616         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
617         address owner = ERC721.ownerOf(tokenId);
618         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
619     }
620 
621     /**
622      * @dev Safely mints `tokenId` and transfers it to `to`.
623      *
624      * Requirements:
625      *
626      * - `tokenId` must not exist.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function _safeMint(address to, uint256 tokenId) internal virtual {
632         _safeMint(to, tokenId, "");
633     }
634 
635     /**
636      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
637      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
638      */
639     function _safeMint(
640         address to,
641         uint256 tokenId,
642         bytes memory _data
643     ) internal virtual {
644         _mint(to, tokenId);
645         require(
646             _checkOnERC721Received(address(0), to, tokenId, _data),
647             "ERC721: transfer to non ERC721Receiver implementer"
648         );
649     }
650 
651     /**
652      * @dev Mints `tokenId` and transfers it to `to`.
653      *
654      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
655      *
656      * Requirements:
657      *
658      * - `tokenId` must not exist.
659      * - `to` cannot be the zero address.
660      *
661      * Emits a {Transfer} event.
662      */
663     function _mint(address to, uint256 tokenId) internal virtual {
664         require(to != address(0), "ERC721: mint to the zero address");
665         require(!_exists(tokenId), "ERC721: token already minted");
666 
667         _beforeTokenTransfer(address(0), to, tokenId);
668 
669         _balances[to] += 1;
670         _owners[tokenId] = to;
671 
672         emit Transfer(address(0), to, tokenId);
673     }
674 
675     /**
676      * @dev Destroys `tokenId`.
677      * The approval is cleared when the token is burned.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      *
683      * Emits a {Transfer} event.
684      */
685     function _burn(uint256 tokenId) internal virtual {
686         address owner = ERC721.ownerOf(tokenId);
687 
688         _beforeTokenTransfer(owner, address(0), tokenId);
689 
690         // Clear approvals
691         _approve(address(0), tokenId);
692 
693         _balances[owner] -= 1;
694         delete _owners[tokenId];
695 
696         emit Transfer(owner, address(0), tokenId);
697     }
698 
699     /**
700      * @dev Transfers `tokenId` from `from` to `to`.
701      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
702      *
703      * Requirements:
704      *
705      * - `to` cannot be the zero address.
706      * - `tokenId` token must be owned by `from`.
707      *
708      * Emits a {Transfer} event.
709      */
710     function _transfer(
711         address from,
712         address to,
713         uint256 tokenId
714     ) internal virtual {
715         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
716         require(to != address(0), "ERC721: transfer to the zero address");
717 
718         _beforeTokenTransfer(from, to, tokenId);
719 
720         // Clear approvals from the previous owner
721         _approve(address(0), tokenId);
722 
723         _balances[from] -= 1;
724         _balances[to] += 1;
725         _owners[tokenId] = to;
726 
727         emit Transfer(from, to, tokenId);
728     }
729 
730     /**
731      * @dev Approve `to` to operate on `tokenId`
732      *
733      * Emits a {Approval} event.
734      */
735     function _approve(address to, uint256 tokenId) internal virtual {
736         _tokenApprovals[tokenId] = to;
737         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
738     }
739 
740     /**
741      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
742      * The call is not executed if the target address is not a contract.
743      *
744      * @param from address representing the previous owner of the given token ID
745      * @param to target address that will receive the tokens
746      * @param tokenId uint256 ID of the token to be transferred
747      * @param _data bytes optional data to send along with the call
748      * @return bool whether the call correctly returned the expected magic value
749      */
750     function _checkOnERC721Received(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) private returns (bool) {
756         if (to.isContract()) {
757             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
758                 return retval == IERC721Receiver.onERC721Received.selector;
759             } catch (bytes memory reason) {
760                 if (reason.length == 0) {
761                     revert("ERC721: transfer to non ERC721Receiver implementer");
762                 } else {
763                     assembly {
764                         revert(add(32, reason), mload(reason))
765                     }
766                 }
767             }
768         } else {
769             return true;
770         }
771     }
772 
773     /**
774      * @dev Hook that is called before any token transfer. This includes minting
775      * and burning.
776      *
777      * Calling conditions:
778      *
779      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
780      * transferred to `to`.
781      * - When `from` is zero, `tokenId` will be minted for `to`.
782      * - When `to` is zero, ``from``'s `tokenId` will be burned.
783      * - `from` and `to` are never both zero.
784      *
785      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
786      */
787     function _beforeTokenTransfer(
788         address from,
789         address to,
790         uint256 tokenId
791     ) internal virtual {}
792 }
793 
794 
795 
796 
797 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
798 
799 
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @title ERC721 token receiver interface
805  * @dev Interface for any contract that wants to support safeTransfers
806  * from ERC721 asset contracts.
807  */
808 interface IERC721Receiver {
809     /**
810      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
811      * by `operator` from `from`, this function is called.
812      *
813      * It must return its Solidity selector to confirm the token transfer.
814      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
815      *
816      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
817      */
818     function onERC721Received(
819         address operator,
820         address from,
821         uint256 tokenId,
822         bytes calldata data
823     ) external returns (bytes4);
824 }
825 
826 
827 
828 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
829 
830 
831 
832 pragma solidity ^0.8.0;
833 
834 
835 /**
836  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
837  * @dev See https://eips.ethereum.org/EIPS/eip-721
838  */
839 interface IERC721Enumerable is IERC721 {
840     /**
841      * @dev Returns the total amount of tokens stored by the contract.
842      */
843     function totalSupply() external view returns (uint256);
844 
845     /**
846      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
847      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
848      */
849     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
850 
851     /**
852      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
853      * Use along with {totalSupply} to enumerate all tokens.
854      */
855     function tokenByIndex(uint256 index) external view returns (uint256);
856 }
857 
858 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
859 
860 
861 
862 pragma solidity ^0.8.0;
863 
864 
865 
866 /**
867  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
868  * enumerability of all the token ids in the contract as well as all token ids owned by each
869  * account.
870  */
871 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
872     // Mapping from owner to list of owned token IDs
873     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
874 
875     // Mapping from token ID to index of the owner tokens list
876     mapping(uint256 => uint256) private _ownedTokensIndex;
877 
878     // Array with all token ids, used for enumeration
879     uint256[] private _allTokens;
880 
881     // Mapping from token id to position in the allTokens array
882     mapping(uint256 => uint256) private _allTokensIndex;
883 
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
888         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
893      */
894     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
895         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
896         return _ownedTokens[owner][index];
897     }
898 
899     /**
900      * @dev See {IERC721Enumerable-totalSupply}.
901      */
902     function totalSupply() public view virtual override returns (uint256) {
903         return _allTokens.length;
904     }
905 
906     /**
907      * @dev See {IERC721Enumerable-tokenByIndex}.
908      */
909     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
910         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
911         return _allTokens[index];
912     }
913 
914     /**
915      * @dev Hook that is called before any token transfer. This includes minting
916      * and burning.
917      *
918      * Calling conditions:
919      *
920      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
921      * transferred to `to`.
922      * - When `from` is zero, `tokenId` will be minted for `to`.
923      * - When `to` is zero, ``from``'s `tokenId` will be burned.
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual override {
934         super._beforeTokenTransfer(from, to, tokenId);
935 
936         if (from == address(0)) {
937             _addTokenToAllTokensEnumeration(tokenId);
938         } else if (from != to) {
939             _removeTokenFromOwnerEnumeration(from, tokenId);
940         }
941         if (to == address(0)) {
942             _removeTokenFromAllTokensEnumeration(tokenId);
943         } else if (to != from) {
944             _addTokenToOwnerEnumeration(to, tokenId);
945         }
946     }
947 
948     /**
949      * @dev Private function to add a token to this extension's ownership-tracking data structures.
950      * @param to address representing the new owner of the given token ID
951      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
952      */
953     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
954         uint256 length = ERC721.balanceOf(to);
955         _ownedTokens[to][length] = tokenId;
956         _ownedTokensIndex[tokenId] = length;
957     }
958 
959     /**
960      * @dev Private function to add a token to this extension's token tracking data structures.
961      * @param tokenId uint256 ID of the token to be added to the tokens list
962      */
963     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
964         _allTokensIndex[tokenId] = _allTokens.length;
965         _allTokens.push(tokenId);
966     }
967 
968     /**
969      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
970      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
971      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
972      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
973      * @param from address representing the previous owner of the given token ID
974      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
975      */
976     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
977         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
978         // then delete the last slot (swap and pop).
979 
980         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
981         uint256 tokenIndex = _ownedTokensIndex[tokenId];
982 
983         // When the token to delete is the last token, the swap operation is unnecessary
984         if (tokenIndex != lastTokenIndex) {
985             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
986 
987             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
988             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
989         }
990 
991         // This also deletes the contents at the last position of the array
992         delete _ownedTokensIndex[tokenId];
993         delete _ownedTokens[from][lastTokenIndex];
994     }
995 
996     /**
997      * @dev Private function to remove a token from this extension's token tracking data structures.
998      * This has O(1) time complexity, but alters the order of the _allTokens array.
999      * @param tokenId uint256 ID of the token to be removed from the tokens list
1000      */
1001     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1002         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1003         // then delete the last slot (swap and pop).
1004 
1005         uint256 lastTokenIndex = _allTokens.length - 1;
1006         uint256 tokenIndex = _allTokensIndex[tokenId];
1007 
1008         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1009         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1010         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1011         uint256 lastTokenId = _allTokens[lastTokenIndex];
1012 
1013         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1014         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1015 
1016         // This also deletes the contents at the last position of the array
1017         delete _allTokensIndex[tokenId];
1018         _allTokens.pop();
1019     }
1020 }
1021 
1022 
1023 
1024 // File: @openzeppelin/contracts/utils/Strings.sol
1025 
1026 
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 /**
1031  * @dev String operations.
1032  */
1033 library Strings {
1034     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1035 
1036     /**
1037      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1038      */
1039     function toString(uint256 value) internal pure returns (string memory) {
1040         // Inspired by OraclizeAPI's implementation - MIT licence
1041         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1042 
1043         if (value == 0) {
1044             return "0";
1045         }
1046         uint256 temp = value;
1047         uint256 digits;
1048         while (temp != 0) {
1049             digits++;
1050             temp /= 10;
1051         }
1052         bytes memory buffer = new bytes(digits);
1053         while (value != 0) {
1054             digits -= 1;
1055             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1056             value /= 10;
1057         }
1058         return string(buffer);
1059     }
1060 
1061     /**
1062      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1063      */
1064     function toHexString(uint256 value) internal pure returns (string memory) {
1065         if (value == 0) {
1066             return "0x00";
1067         }
1068         uint256 temp = value;
1069         uint256 length = 0;
1070         while (temp != 0) {
1071             length++;
1072             temp >>= 8;
1073         }
1074         return toHexString(value, length);
1075     }
1076 
1077     /**
1078      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1079      */
1080     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1081         bytes memory buffer = new bytes(2 * length + 2);
1082         buffer[0] = "0";
1083         buffer[1] = "x";
1084         for (uint256 i = 2 * length + 1; i > 1; --i) {
1085             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1086             value >>= 4;
1087         }
1088         require(value == 0, "Strings: hex length insufficient");
1089         return string(buffer);
1090     }
1091 }
1092 
1093 
1094 // File: @openzeppelin/contracts/utils/Address.sol
1095 
1096 
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 /**
1101  * @dev Collection of functions related to the address type
1102  */
1103 library Address {
1104     /**
1105      * @dev Returns true if `account` is a contract.
1106      *
1107      * [IMPORTANT]
1108      * ====
1109      * It is unsafe to assume that an address for which this function returns
1110      * false is an externally-owned account (EOA) and not a contract.
1111      *
1112      * Among others, `isContract` will return false for the following
1113      * types of addresses:
1114      *
1115      *  - an externally-owned account
1116      *  - a contract in construction
1117      *  - an address where a contract will be created
1118      *  - an address where a contract lived, but was destroyed
1119      * ====
1120      */
1121     function isContract(address account) internal view returns (bool) {
1122         // This method relies on extcodesize, which returns 0 for contracts in
1123         // construction, since the code is only stored at the end of the
1124         // constructor execution.
1125 
1126         uint256 size;
1127         assembly {
1128             size := extcodesize(account)
1129         }
1130         return size > 0;
1131     }
1132 
1133     /**
1134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1135      * `recipient`, forwarding all available gas and reverting on errors.
1136      *
1137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1139      * imposed by `transfer`, making them unable to receive funds via
1140      * `transfer`. {sendValue} removes this limitation.
1141      *
1142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1143      *
1144      * IMPORTANT: because control is transferred to `recipient`, care must be
1145      * taken to not create reentrancy vulnerabilities. Consider using
1146      * {ReentrancyGuard} or the
1147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1148      */
1149     function sendValue(address payable recipient, uint256 amount) internal {
1150         require(address(this).balance >= amount, "Address: insufficient balance");
1151 
1152         (bool success, ) = recipient.call{value: amount}("");
1153         require(success, "Address: unable to send value, recipient may have reverted");
1154     }
1155 
1156     /**
1157      * @dev Performs a Solidity function call using a low level `call`. A
1158      * plain `call` is an unsafe replacement for a function call: use this
1159      * function instead.
1160      *
1161      * If `target` reverts with a revert reason, it is bubbled up by this
1162      * function (like regular Solidity function calls).
1163      *
1164      * Returns the raw returned data. To convert to the expected return value,
1165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1166      *
1167      * Requirements:
1168      *
1169      * - `target` must be a contract.
1170      * - calling `target` with `data` must not revert.
1171      *
1172      * _Available since v3.1._
1173      */
1174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1175         return functionCall(target, data, "Address: low-level call failed");
1176     }
1177 
1178     /**
1179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1180      * `errorMessage` as a fallback revert reason when `target` reverts.
1181      *
1182      * _Available since v3.1._
1183      */
1184     function functionCall(
1185         address target,
1186         bytes memory data,
1187         string memory errorMessage
1188     ) internal returns (bytes memory) {
1189         return functionCallWithValue(target, data, 0, errorMessage);
1190     }
1191 
1192     /**
1193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1194      * but also transferring `value` wei to `target`.
1195      *
1196      * Requirements:
1197      *
1198      * - the calling contract must have an ETH balance of at least `value`.
1199      * - the called Solidity function must be `payable`.
1200      *
1201      * _Available since v3.1._
1202      */
1203     function functionCallWithValue(
1204         address target,
1205         bytes memory data,
1206         uint256 value
1207     ) internal returns (bytes memory) {
1208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1209     }
1210 
1211     /**
1212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1213      * with `errorMessage` as a fallback revert reason when `target` reverts.
1214      *
1215      * _Available since v3.1._
1216      */
1217     function functionCallWithValue(
1218         address target,
1219         bytes memory data,
1220         uint256 value,
1221         string memory errorMessage
1222     ) internal returns (bytes memory) {
1223         require(address(this).balance >= value, "Address: insufficient balance for call");
1224         require(isContract(target), "Address: call to non-contract");
1225 
1226         (bool success, bytes memory returndata) = target.call{value: value}(data);
1227         return verifyCallResult(success, returndata, errorMessage);
1228     }
1229 
1230     /**
1231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1232      * but performing a static call.
1233      *
1234      * _Available since v3.3._
1235      */
1236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1237         return functionStaticCall(target, data, "Address: low-level static call failed");
1238     }
1239 
1240     /**
1241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1242      * but performing a static call.
1243      *
1244      * _Available since v3.3._
1245      */
1246     function functionStaticCall(
1247         address target,
1248         bytes memory data,
1249         string memory errorMessage
1250     ) internal view returns (bytes memory) {
1251         require(isContract(target), "Address: static call to non-contract");
1252 
1253         (bool success, bytes memory returndata) = target.staticcall(data);
1254         return verifyCallResult(success, returndata, errorMessage);
1255     }
1256 
1257     /**
1258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1259      * but performing a delegate call.
1260      *
1261      * _Available since v3.4._
1262      */
1263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1265     }
1266 
1267     /**
1268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1269      * but performing a delegate call.
1270      *
1271      * _Available since v3.4._
1272      */
1273     function functionDelegateCall(
1274         address target,
1275         bytes memory data,
1276         string memory errorMessage
1277     ) internal returns (bytes memory) {
1278         require(isContract(target), "Address: delegate call to non-contract");
1279 
1280         (bool success, bytes memory returndata) = target.delegatecall(data);
1281         return verifyCallResult(success, returndata, errorMessage);
1282     }
1283 
1284     /**
1285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1286      * revert reason using the provided one.
1287      *
1288      * _Available since v4.3._
1289      */
1290     function verifyCallResult(
1291         bool success,
1292         bytes memory returndata,
1293         string memory errorMessage
1294     ) internal pure returns (bytes memory) {
1295         if (success) {
1296             return returndata;
1297         } else {
1298             // Look for revert reason and bubble it up if present
1299             if (returndata.length > 0) {
1300                 // The easiest way to bubble the revert reason is using memory via assembly
1301 
1302                 assembly {
1303                     let returndata_size := mload(returndata)
1304                     revert(add(32, returndata), returndata_size)
1305                 }
1306             } else {
1307                 revert(errorMessage);
1308             }
1309         }
1310     }
1311 }
1312 
1313 
1314 
1315 
1316 
1317 // File: contracts/Origins.sol
1318 
1319 
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 
1325 
1326 /**
1327  * @dev Required interface of an ERC721 compliant contract.
1328  */
1329 
1330  
1331 
1332 interface ColorToken is IERC165 {
1333    
1334     function balanceOf(address owner) external view returns (uint256 balance);
1335 
1336     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1337     
1338     function getColors(uint256 tokenId) external view returns (string memory); // returns "#****** #****** #****** #****** #******"
1339     
1340 }
1341 
1342 interface OriginsGenie is IERC165 {
1343    
1344      function generateData(uint _tokenId, string[5] memory _colors, string memory _lat, string memory _long, string memory _dir,
1345                             string memory _x, string memory _y, string memory _z, string memory _t )
1346                             external pure returns (string memory);
1347     
1348 }
1349 
1350 //////////////////////////////////////////////////////////////////////////////
1351 //////////////////////////////////////////////////////////////////////
1352 
1353 pragma solidity ^0.8.7;
1354 
1355 
1356 contract Origins is  ERC721, ERC721Enumerable, Ownable {
1357 
1358     ///////////////////////////////////////////////////////////////////////////////////////
1359     /// Free to mint. Hope you enjoy them as much as I enjoyed making them.
1360     //////////////////////////////////////////////////////////////////////////////////////
1361 
1362     
1363 
1364     
1365     uint constant public MAX_SUPPLY = 8800;
1366     
1367     // Mint for free!!
1368     function claim() public {
1369         require(on);
1370         safeMint(_msgSender());
1371     }
1372 
1373     // Tip the dev
1374     function fundDev() public payable returns (string memory) {
1375         
1376         // Just an option to send a dev tip, to help recoup ether from deployment costs.
1377         // As a way to say thank you, I've reserved 150 extra tokens for those who choose
1378         // to use this function.
1379         
1380         if (msg.value > 0) {
1381             uint v = msg.value;
1382             coffeeFund.transfer(v);
1383             reserveMint(msg.sender, v);
1384             return "Thanks!!";
1385         }
1386     }
1387 
1388 
1389 
1390 ///////////////////////////////////////////////////////////////////////////////////////
1391     
1392     OriginsGenie public genie; // Seperate contract to manage json & image generation
1393     ColorToken public palette; // Source of color data
1394     
1395     using Counters for Counters.Counter; // Manages tokenId
1396     Counters.Counter private _tokenIdCounter;
1397 
1398     address payable public coffeeFund; // for tips from fundDev()
1399     
1400     bool public on = false;
1401 
1402     constructor (address _colorPallete)
1403     ERC721("ORIGINS", "NSEW") {
1404         palette = ColorToken(_colorPallete);
1405         //genie = OriginsGenie(_genie);
1406         coffeeFund = payable(msg.sender);
1407     }
1408 
1409     // Core Functions
1410     
1411 
1412     function getXYZ(uint _tokenId) public pure returns(string memory) {
1413         return string(abi.encodePacked(getX(_tokenId),' ', getY(_tokenId), ' ', getZ(_tokenId)));
1414     }
1415     
1416     function getX(uint _tokenId) public pure returns(string memory) {
1417         return _getCoordWithDecimal(_tokenId, 1000, "SIDE");
1418     }
1419     
1420     function getY(uint _tokenId) public pure returns(string memory) {
1421         return _getCoordWithDecimal(_tokenId, 1000, "FORD");
1422     }
1423     
1424     function getZ(uint _tokenId) public pure returns(string memory) {
1425         return _getCoordWithDecimal(_tokenId, 1000, "UPDWN");
1426     }
1427     
1428     function getLatLong(uint _tokenId) public pure returns(string memory _coords) {
1429         _coords = string(abi.encodePacked(getLatitude(_tokenId, false),' ', getLongitude(_tokenId, false)));
1430         return _coords;
1431     }
1432     
1433     function getLatitude(uint _tokenId, bool _fancy) public pure returns(string memory _latitude) {
1434         
1435         uint rand = random(string(abi.encodePacked(toString(_tokenId), "Lat:"))) % 61;
1436         uint _deg = _getRandomCoord(_tokenId, 90, "44cc");
1437         uint _min = _getRandomCoord(_tokenId, 60, "5c45");
1438         uint _sec = _getRandomCoord(_tokenId, 60, "4873");
1439         uint _secDec = _getRandomCoord(_tokenId, 10, "g543");
1440         string memory _direction;
1441         
1442         if (rand >= 15 || (rand < 30 && rand <= 45)) {
1443             _direction = ' N ';
1444         } else {
1445             _direction = ' S ';
1446         }
1447         // Example Output
1448         // 32° 18' 23.1" N
1449 
1450         if (!_fancy) {
1451             _latitude = string(abi.encodePacked(toString(_deg), _direction, toString(_min), "' ", toString(_sec), '.', toString(_secDec), "''" ));
1452         } else {
1453             _latitude = string(abi.encodePacked(toString(_deg), '&#176;', _direction, toString(_min), "' ", toString(_sec), '.', toString(_secDec), "''" ));
1454         }
1455         
1456         
1457         return _latitude;
1458     }
1459     
1460     function getLongitude(uint _tokenId, bool _fancy) public pure returns(string memory _longitude) {
1461         uint rand = random(string(abi.encodePacked(toString(_tokenId), "Long:"))) % 61;
1462         uint _deg = _getRandomCoord(_tokenId, 180, "ldeg");
1463         uint _min = _getRandomCoord(_tokenId, 60, "lmin");
1464         uint _sec = _getRandomCoord(_tokenId, 60, "lsec");
1465         uint _secDec = _getRandomCoord(_tokenId, 10, "lde");
1466         string memory _direction;
1467         
1468         if (rand >= 15 || (rand < 30 && rand <= 45)) {
1469             _direction = ' E ';
1470         } else {
1471             _direction = ' W ';
1472         }
1473         // 32° 18' 23.1" N
1474         if (!_fancy) {
1475             _longitude = string(abi.encodePacked(toString(_deg), _direction, toString(_min), "' ", toString(_sec), '.', toString(_secDec), "''" ));
1476         } else {
1477             _longitude = string(abi.encodePacked(toString(_deg), '&#176;', _direction, toString(_min), "' ", toString(_sec), '.', toString(_secDec), "''" ));
1478         }
1479 
1480         return _longitude;
1481     }
1482     
1483     function getTime(uint _tokenId) public pure returns(string memory) {
1484         return string(abi.encodePacked(
1485             toString(_getRandomCoord(_tokenId, 365, "635")), ':',
1486             toString(_getRandomCoord(_tokenId, 24, "133")), ':',
1487             toString(_getRandomCoord(_tokenId, 60, "ge4")), ':',
1488             toString(_getRandomCoord(_tokenId, 60, "7b4"))
1489             ));
1490     }
1491     
1492     
1493     function getDirection(uint _tokenId) public pure returns(string memory) {
1494         getDirection(_tokenId, false);
1495     }
1496 
1497     function getDirection(uint _tokenId, bool _fancy) public pure returns(string memory) {
1498         
1499         uint direction = _getRandomCoord(_tokenId, 359, "Compass");
1500         uint _directionDec = _getRandomCoord(_tokenId, 99, "Decimals");
1501         string memory directionLabel;
1502         
1503         if (direction < 68 || direction > 338) {if (direction < 22 || direction > 338) {directionLabel = "N";} else {directionLabel = "NE";}
1504         } else if (direction < 160) {if (direction < 112) {directionLabel = "E";} else {directionLabel = "SE";}} else if (direction < 250) {
1505         if (direction < 202) { directionLabel = "S"; } else {directionLabel = "SW";} } else if (direction < 338) { if (direction < 292) {
1506         directionLabel = "W"; } else { directionLabel = "NW"; }}
1507         
1508         string memory compass;
1509         
1510         if (!_fancy) {
1511             compass = string(abi.encodePacked(toString(direction), '.', toString(_directionDec), ' ', directionLabel));
1512         } else {
1513             compass = string(abi.encodePacked(toString(direction), '.', toString(_directionDec), '&#176;', ' ', directionLabel));
1514         }
1515         
1516         return compass;
1517     }
1518 
1519     function getColors(uint _tokenId) public view returns (string[5] memory _colors) {
1520         
1521         address _address = ownerOf(_tokenId);
1522         uint _bal = hasPallete(_address);
1523         if (_bal >= 1) {
1524             uint _index = _getRandomCoord(_tokenId, (_bal), "COLOR");
1525             uint paletteId = palette.tokenOfOwnerByIndex(_address, _index);
1526             bytes memory _buffer = bytes(palette.getColors(paletteId));
1527             
1528             for (uint i = 0 ; i < 5 ; i++) {
1529                 _colors[i] = string(abi.encodePacked(_buffer[(8*i)], _buffer[((8*i)+1)], _buffer[((8*i)+2)],_buffer[((8*i)+3)],_buffer[((8*i)+4)],_buffer[((8*i)+5)], _buffer[((8*i)+6)]));
1530             }
1531         } else {
1532 
1533             // #time #littleDiv #compass #clock #accents
1534             _colors[0] = "#fff"; 
1535             _colors[1] = "#fff"; 
1536             _colors[2] = "#fff"; 
1537             _colors[3] = "#fff"; 
1538             _colors[4] = "#000"; // bg
1539         }
1540         
1541        return _colors;
1542     }
1543 
1544     function tokenURI(uint256 tokenId)
1545         public
1546         view
1547         override
1548         returns (string memory)
1549     {
1550 
1551         string[5] memory _colors = getColors(tokenId);
1552         string memory _lat = getLatitude(tokenId, true);
1553         string memory _long = getLongitude(tokenId, true);
1554         string memory _dir = getDirection(tokenId, true);
1555         string memory _x = string(abi.encodePacked('X: ', getX(tokenId)));
1556         string memory _y = string(abi.encodePacked('Y: ', getY(tokenId)));
1557         string memory _z = string(abi.encodePacked('Z: ', getZ(tokenId)));
1558         string memory _t = getTime(tokenId);
1559    
1560         string memory _data = genie.generateData(tokenId, _colors,  _lat, _long, _dir,
1561                              _x, _y, _z, _t );
1562 
1563         return _data;
1564     }
1565 
1566 
1567     // internal
1568     
1569     function _getRandomCoord(uint _tokenId, uint _limit, string memory _label) internal pure returns(uint) {
1570         uint rand = random(string(abi.encodePacked(_label, toString(_tokenId))));
1571         uint _int = rand % _limit;
1572         
1573         return _int;
1574     }
1575     
1576     function _getCoordWithDecimal(uint _tokenId, uint _limit, string memory _label) internal pure returns(string memory) {
1577         
1578         uint rand = random(string(abi.encodePacked(_label, toString(_tokenId)))) % 61;
1579         uint _int = _getRandomCoord(_tokenId, _limit, _label);
1580         uint _dec = _getRandomCoord(_tokenId, 999, _label);
1581         
1582         if (rand <= 15 || (rand > 30 && rand <= 45)) {
1583             return string(abi.encodePacked('-', toString(_int), '.', toString(_dec)));
1584         } else {
1585             return string(abi.encodePacked(toString(_int), '.', toString(_dec)));
1586         }
1587         
1588     }
1589     
1590     //// Utility functions 
1591     
1592     function addGenie(address _genie) external onlyOwner {
1593         genie = OriginsGenie(_genie);
1594         on = true;
1595     }
1596 
1597     function hasPallete(address _address) internal view returns (uint) {
1598         return palette.balanceOf(_address);
1599     }
1600     
1601     function random(string memory input) internal pure returns (uint256) {
1602         return uint256(keccak256(abi.encodePacked(input)));
1603     }
1604 
1605     function reserveMint(address _mintTo, uint value) private returns (bool) {
1606         
1607         require(on);
1608         uint256 nextId = _tokenIdCounter.current();
1609 
1610         if(nextId < 8500){
1611             safeMint(_mintTo);
1612         } else if ((value >= 0.01 ether) || (nextId <= 8650)) {
1613             _safeMint(_mintTo, nextId);
1614             _tokenIdCounter.increment();
1615         }
1616         return true;
1617     }
1618 
1619     function safeMint(address to) private {
1620         uint256 nextId = _tokenIdCounter.current();
1621 
1622         require(nextId < 8500, "Reserved");
1623 
1624         _safeMint(to, nextId);
1625         _tokenIdCounter.increment();
1626     }
1627 
1628     function ownerClaim(uint tokenId, uint _b) public onlyOwner {
1629         require(tokenId > 8650 && tokenId <= 8800, "invalid");
1630         uint _it = tokenId + _b;
1631         while((gasleft() > 1000)){for(tokenId; tokenId < _it; tokenId++)
1632         {_safeMint(owner(), tokenId);}}
1633     }
1634     
1635     function toString(uint256 value) internal pure returns (string memory) {
1636     
1637     // From loot (for adventurers)
1638     // Inspired by OraclizeAPI's implementation - MIT license
1639     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1640 
1641         if (value == 0) {
1642             return "0";
1643         }
1644         uint256 temp = value;
1645         uint256 digits;
1646         while (temp != 0) {
1647             digits++;
1648             temp /= 10;
1649         }
1650         bytes memory buffer = new bytes(digits);
1651         while (value != 0) {
1652             digits -= 1;
1653             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1654             value /= 10;
1655         }
1656         return string(buffer);
1657     }
1658 
1659     function _beforeTokenTransfer(
1660         address from,
1661         address to,
1662         uint256 tokenId
1663     ) internal override(ERC721, ERC721Enumerable) {
1664         super._beforeTokenTransfer(from, to, tokenId);
1665     }
1666 
1667     function supportsInterface(bytes4 interfaceId)
1668         public
1669         view
1670         override(ERC721, ERC721Enumerable)
1671         returns (bool)
1672     {
1673         return super.supportsInterface(interfaceId);
1674     }
1675     
1676     
1677 }