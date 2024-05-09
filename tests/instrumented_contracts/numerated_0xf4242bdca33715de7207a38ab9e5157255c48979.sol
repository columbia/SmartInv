1 // File: @openzeppelin/contracts@4.1.0/access/Ownable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 // File: @openzeppelin/contracts@4.1.0/utils/Context.sol
7 
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 // File: @openzeppelin/contracts@4.1.0/utils/introspection/IERC165.sol
102 
103 
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 
129 // File: @openzeppelin/contracts@4.1.0/token/ERC721/IERC721.sol
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Required interface of an ERC721 compliant contract.
138  */
139 interface IERC721 is IERC165 {
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
152      */
153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
154 
155     /**
156      * @dev Returns the number of tokens in ``owner``'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(address from, address to, uint256 tokenId) external;
184 
185     /**
186      * @dev Transfers `tokenId` token from `from` to `to`.
187      *
188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(address from, address to, uint256 tokenId) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Returns the account approved for `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function getApproved(uint256 tokenId) external view returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     /**
245       * @dev Safely transfers `tokenId` token from `from` to `to`.
246       *
247       * Requirements:
248       *
249       * - `from` cannot be the zero address.
250       * - `to` cannot be the zero address.
251       * - `tokenId` token must exist and be owned by `from`.
252       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
253       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
254       *
255       * Emits a {Transfer} event.
256       */
257     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
258 }
259 
260 
261 // File: @openzeppelin/contracts@4.1.0/token/ERC721/extensions/IERC721Enumerable.sol
262 
263 
264 
265 pragma solidity ^0.8.0;
266 
267 
268 /**
269  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
270  * @dev See https://eips.ethereum.org/EIPS/eip-721
271  */
272 interface IERC721Enumerable is IERC721 {
273 
274     /**
275      * @dev Returns the total amount of tokens stored by the contract.
276      */
277     function totalSupply() external view returns (uint256);
278 
279     /**
280      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
281      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
282      */
283     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
284 
285     /**
286      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
287      * Use along with {totalSupply} to enumerate all tokens.
288      */
289     function tokenByIndex(uint256 index) external view returns (uint256);
290 }
291 
292 
293 
294 // File: @openzeppelin/contracts@4.1.0/utils/introspection/ERC165.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 
301 /**
302  * @dev Implementation of the {IERC165} interface.
303  *
304  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
305  * for the additional interface id that will be supported. For example:
306  *
307  * ```solidity
308  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
309  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
310  * }
311  * ```
312  *
313  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
314  */
315 abstract contract ERC165 is IERC165 {
316     /**
317      * @dev See {IERC165-supportsInterface}.
318      */
319     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
320         return interfaceId == type(IERC165).interfaceId;
321     }
322 }
323 
324 
325 // File: @openzeppelin/contracts@4.1.0/token/ERC721/extensions/IERC721Metadata.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
334  * @dev See https://eips.ethereum.org/EIPS/eip-721
335  */
336 interface IERC721Metadata is IERC721 {
337 
338     /**
339      * @dev Returns the token collection name.
340      */
341     function name() external view returns (string memory);
342 
343     /**
344      * @dev Returns the token collection symbol.
345      */
346     function symbol() external view returns (string memory);
347 
348     /**
349      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
350      */
351     function tokenURI(uint256 tokenId) external view returns (string memory);
352 }
353 
354 
355 
356 // File: @openzeppelin/contracts@4.1.0/token/ERC721/ERC721.sol
357 
358 
359 
360 pragma solidity ^0.8.0;
361 
362 
363 
364 
365 
366 
367 
368 
369 /**
370  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
371  * the Metadata extension, but not including the Enumerable extension, which is available separately as
372  * {ERC721Enumerable}.
373  */
374 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
375     using Address for address;
376     using Strings for uint256;
377 
378     // Token name
379     string private _name;
380 
381     // Token symbol
382     string private _symbol;
383 
384     // Mapping from token ID to owner address
385     mapping (uint256 => address) private _owners;
386 
387     // Mapping owner address to token count
388     mapping (address => uint256) private _balances;
389 
390     // Mapping from token ID to approved address
391     mapping (uint256 => address) private _tokenApprovals;
392 
393     // Mapping from owner to operator approvals
394     mapping (address => mapping (address => bool)) private _operatorApprovals;
395 
396     /**
397      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
398      */
399     constructor (string memory name_, string memory symbol_) {
400         _name = name_;
401         _symbol = symbol_;
402     }
403 
404     /**
405      * @dev See {IERC165-supportsInterface}.
406      */
407     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
408         return interfaceId == type(IERC721).interfaceId
409             || interfaceId == type(IERC721Metadata).interfaceId
410             || super.supportsInterface(interfaceId);
411     }
412 
413     /**
414      * @dev See {IERC721-balanceOf}.
415      */
416     function balanceOf(address owner) public view virtual override returns (uint256) {
417         require(owner != address(0), "ERC721: balance query for the zero address");
418         return _balances[owner];
419     }
420 
421     /**
422      * @dev See {IERC721-ownerOf}.
423      */
424     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
425         address owner = _owners[tokenId];
426         require(owner != address(0), "ERC721: owner query for nonexistent token");
427         return owner;
428     }
429 
430     /**
431      * @dev See {IERC721Metadata-name}.
432      */
433     function name() public view virtual override returns (string memory) {
434         return _name;
435     }
436 
437     /**
438      * @dev See {IERC721Metadata-symbol}.
439      */
440     function symbol() public view virtual override returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445      * @dev See {IERC721Metadata-tokenURI}.
446      */
447     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
448         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
449 
450         string memory baseURI = _baseURI();
451         return bytes(baseURI).length > 0
452             ? string(abi.encodePacked(baseURI, tokenId.toString()))
453             : '';
454     }
455 
456     /**
457      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
458      * in child contracts.
459      */
460     function _baseURI() internal view virtual returns (string memory) {
461         return "";
462     }
463 
464     /**
465      * @dev See {IERC721-approve}.
466      */
467     function approve(address to, uint256 tokenId) public virtual override {
468         address owner = ERC721.ownerOf(tokenId);
469         require(to != owner, "ERC721: approval to current owner");
470 
471         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
472             "ERC721: approve caller is not owner nor approved for all"
473         );
474 
475         _approve(to, tokenId);
476     }
477 
478     /**
479      * @dev See {IERC721-getApproved}.
480      */
481     function getApproved(uint256 tokenId) public view virtual override returns (address) {
482         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
483 
484         return _tokenApprovals[tokenId];
485     }
486 
487     /**
488      * @dev See {IERC721-setApprovalForAll}.
489      */
490     function setApprovalForAll(address operator, bool approved) public virtual override {
491         require(operator != _msgSender(), "ERC721: approve to caller");
492 
493         _operatorApprovals[_msgSender()][operator] = approved;
494         emit ApprovalForAll(_msgSender(), operator, approved);
495     }
496 
497     /**
498      * @dev See {IERC721-isApprovedForAll}.
499      */
500     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
501         return _operatorApprovals[owner][operator];
502     }
503 
504     /**
505      * @dev See {IERC721-transferFrom}.
506      */
507     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
508         //solhint-disable-next-line max-line-length
509         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
510 
511         _transfer(from, to, tokenId);
512     }
513 
514     /**
515      * @dev See {IERC721-safeTransferFrom}.
516      */
517     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
518         safeTransferFrom(from, to, tokenId, "");
519     }
520 
521     /**
522      * @dev See {IERC721-safeTransferFrom}.
523      */
524     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
525         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
526         _safeTransfer(from, to, tokenId, _data);
527     }
528 
529     /**
530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
532      *
533      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
534      *
535      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
536      * implement alternative mechanisms to perform token transfer, such as signature-based.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
548         _transfer(from, to, tokenId);
549         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
550     }
551 
552     /**
553      * @dev Returns whether `tokenId` exists.
554      *
555      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
556      *
557      * Tokens start existing when they are minted (`_mint`),
558      * and stop existing when they are burned (`_burn`).
559      */
560     function _exists(uint256 tokenId) internal view virtual returns (bool) {
561         return _owners[tokenId] != address(0);
562     }
563 
564     /**
565      * @dev Returns whether `spender` is allowed to manage `tokenId`.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
572         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
573         address owner = ERC721.ownerOf(tokenId);
574         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
575     }
576 
577     /**
578      * @dev Safely mints `tokenId` and transfers it to `to`.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must not exist.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function _safeMint(address to, uint256 tokenId) internal virtual {
588         _safeMint(to, tokenId, "");
589     }
590 
591     /**
592      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
593      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
594      */
595     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
596         _mint(to, tokenId);
597         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
598     }
599 
600     /**
601      * @dev Mints `tokenId` and transfers it to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
604      *
605      * Requirements:
606      *
607      * - `tokenId` must not exist.
608      * - `to` cannot be the zero address.
609      *
610      * Emits a {Transfer} event.
611      */
612     function _mint(address to, uint256 tokenId) internal virtual {
613         require(to != address(0), "ERC721: mint to the zero address");
614         require(!_exists(tokenId), "ERC721: token already minted");
615 
616         _beforeTokenTransfer(address(0), to, tokenId);
617 
618         _balances[to] += 1;
619         _owners[tokenId] = to;
620 
621         emit Transfer(address(0), to, tokenId);
622     }
623 
624     /**
625      * @dev Destroys `tokenId`.
626      * The approval is cleared when the token is burned.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      *
632      * Emits a {Transfer} event.
633      */
634     function _burn(uint256 tokenId) internal virtual {
635         address owner = ERC721.ownerOf(tokenId);
636 
637         _beforeTokenTransfer(owner, address(0), tokenId);
638 
639         // Clear approvals
640         _approve(address(0), tokenId);
641 
642         _balances[owner] -= 1;
643         delete _owners[tokenId];
644 
645         emit Transfer(owner, address(0), tokenId);
646     }
647 
648     /**
649      * @dev Transfers `tokenId` from `from` to `to`.
650      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
651      *
652      * Requirements:
653      *
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must be owned by `from`.
656      *
657      * Emits a {Transfer} event.
658      */
659     function _transfer(address from, address to, uint256 tokenId) internal virtual {
660         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
661         require(to != address(0), "ERC721: transfer to the zero address");
662 
663         _beforeTokenTransfer(from, to, tokenId);
664 
665         // Clear approvals from the previous owner
666         _approve(address(0), tokenId);
667 
668         _balances[from] -= 1;
669         _balances[to] += 1;
670         _owners[tokenId] = to;
671 
672         emit Transfer(from, to, tokenId);
673     }
674 
675     /**
676      * @dev Approve `to` to operate on `tokenId`
677      *
678      * Emits a {Approval} event.
679      */
680     function _approve(address to, uint256 tokenId) internal virtual {
681         _tokenApprovals[tokenId] = to;
682         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
683     }
684 
685     /**
686      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
687      * The call is not executed if the target address is not a contract.
688      *
689      * @param from address representing the previous owner of the given token ID
690      * @param to target address that will receive the tokens
691      * @param tokenId uint256 ID of the token to be transferred
692      * @param _data bytes optional data to send along with the call
693      * @return bool whether the call correctly returned the expected magic value
694      */
695     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
696         private returns (bool)
697     {
698         if (to.isContract()) {
699             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
700                 return retval == IERC721Receiver(to).onERC721Received.selector;
701             } catch (bytes memory reason) {
702                 if (reason.length == 0) {
703                     revert("ERC721: transfer to non ERC721Receiver implementer");
704                 } else {
705                     // solhint-disable-next-line no-inline-assembly
706                     assembly {
707                         revert(add(32, reason), mload(reason))
708                     }
709                 }
710             }
711         } else {
712             return true;
713         }
714     }
715 
716     /**
717      * @dev Hook that is called before any token transfer. This includes minting
718      * and burning.
719      *
720      * Calling conditions:
721      *
722      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
723      * transferred to `to`.
724      * - When `from` is zero, `tokenId` will be minted for `to`.
725      * - When `to` is zero, ``from``'s `tokenId` will be burned.
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      *
729      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
730      */
731     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
732 }
733 
734 
735 // File: @openzeppelin/contracts@4.1.0/token/ERC721/extensions/ERC721Enumerable.sol
736 
737 
738 
739 pragma solidity ^0.8.0;
740 
741 
742 
743 /**
744  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
745  * enumerability of all the token ids in the contract as well as all token ids owned by each
746  * account.
747  */
748 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
749     // Mapping from owner to list of owned token IDs
750     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
751 
752     // Mapping from token ID to index of the owner tokens list
753     mapping(uint256 => uint256) private _ownedTokensIndex;
754 
755     // Array with all token ids, used for enumeration
756     uint256[] private _allTokens;
757 
758     // Mapping from token id to position in the allTokens array
759     mapping(uint256 => uint256) private _allTokensIndex;
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
765         return interfaceId == type(IERC721Enumerable).interfaceId
766             || super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
771      */
772     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
773         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
774         return _ownedTokens[owner][index];
775     }
776 
777     /**
778      * @dev See {IERC721Enumerable-totalSupply}.
779      */
780     function totalSupply() public view virtual override returns (uint256) {
781         return _allTokens.length;
782     }
783 
784     /**
785      * @dev See {IERC721Enumerable-tokenByIndex}.
786      */
787     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
788         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
789         return _allTokens[index];
790     }
791 
792     /**
793      * @dev Hook that is called before any token transfer. This includes minting
794      * and burning.
795      *
796      * Calling conditions:
797      *
798      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
799      * transferred to `to`.
800      * - When `from` is zero, `tokenId` will be minted for `to`.
801      * - When `to` is zero, ``from``'s `tokenId` will be burned.
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      *
805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
806      */
807     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
808         super._beforeTokenTransfer(from, to, tokenId);
809 
810         if (from == address(0)) {
811             _addTokenToAllTokensEnumeration(tokenId);
812         } else if (from != to) {
813             _removeTokenFromOwnerEnumeration(from, tokenId);
814         }
815         if (to == address(0)) {
816             _removeTokenFromAllTokensEnumeration(tokenId);
817         } else if (to != from) {
818             _addTokenToOwnerEnumeration(to, tokenId);
819         }
820     }
821 
822     /**
823      * @dev Private function to add a token to this extension's ownership-tracking data structures.
824      * @param to address representing the new owner of the given token ID
825      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
826      */
827     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
828         uint256 length = ERC721.balanceOf(to);
829         _ownedTokens[to][length] = tokenId;
830         _ownedTokensIndex[tokenId] = length;
831     }
832 
833     /**
834      * @dev Private function to add a token to this extension's token tracking data structures.
835      * @param tokenId uint256 ID of the token to be added to the tokens list
836      */
837     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
838         _allTokensIndex[tokenId] = _allTokens.length;
839         _allTokens.push(tokenId);
840     }
841 
842     /**
843      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
844      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
845      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
846      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
847      * @param from address representing the previous owner of the given token ID
848      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
849      */
850     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
851         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
852         // then delete the last slot (swap and pop).
853 
854         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
855         uint256 tokenIndex = _ownedTokensIndex[tokenId];
856 
857         // When the token to delete is the last token, the swap operation is unnecessary
858         if (tokenIndex != lastTokenIndex) {
859             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
860 
861             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
862             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
863         }
864 
865         // This also deletes the contents at the last position of the array
866         delete _ownedTokensIndex[tokenId];
867         delete _ownedTokens[from][lastTokenIndex];
868     }
869 
870     /**
871      * @dev Private function to remove a token from this extension's token tracking data structures.
872      * This has O(1) time complexity, but alters the order of the _allTokens array.
873      * @param tokenId uint256 ID of the token to be removed from the tokens list
874      */
875     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
876         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
877         // then delete the last slot (swap and pop).
878 
879         uint256 lastTokenIndex = _allTokens.length - 1;
880         uint256 tokenIndex = _allTokensIndex[tokenId];
881 
882         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
883         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
884         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
885         uint256 lastTokenId = _allTokens[lastTokenIndex];
886 
887         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
888         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
889 
890         // This also deletes the contents at the last position of the array
891         delete _allTokensIndex[tokenId];
892         _allTokens.pop();
893     }
894 }
895 
896 // File: @openzeppelin/contracts@4.1.0/utils/Strings.sol
897 
898 
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @dev String operations.
904  */
905 library Strings {
906     bytes16 private constant alphabet = "0123456789abcdef";
907 
908     /**
909      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
910      */
911     function toString(uint256 value) internal pure returns (string memory) {
912         // Inspired by OraclizeAPI's implementation - MIT licence
913         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
914 
915         if (value == 0) {
916             return "0";
917         }
918         uint256 temp = value;
919         uint256 digits;
920         while (temp != 0) {
921             digits++;
922             temp /= 10;
923         }
924         bytes memory buffer = new bytes(digits);
925         while (value != 0) {
926             digits -= 1;
927             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
928             value /= 10;
929         }
930         return string(buffer);
931     }
932 
933     /**
934      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
935      */
936     function toHexString(uint256 value) internal pure returns (string memory) {
937         if (value == 0) {
938             return "0x00";
939         }
940         uint256 temp = value;
941         uint256 length = 0;
942         while (temp != 0) {
943             length++;
944             temp >>= 8;
945         }
946         return toHexString(value, length);
947     }
948 
949     /**
950      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
951      */
952     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
953         bytes memory buffer = new bytes(2 * length + 2);
954         buffer[0] = "0";
955         buffer[1] = "x";
956         for (uint256 i = 2 * length + 1; i > 1; --i) {
957             buffer[i] = alphabet[value & 0xf];
958             value >>= 4;
959         }
960         require(value == 0, "Strings: hex length insufficient");
961         return string(buffer);
962     }
963 
964 }
965 
966 
967 // File: @openzeppelin/contracts@4.1.0/utils/Address.sol
968 
969 
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev Collection of functions related to the address type
975  */
976 library Address {
977     /**
978      * @dev Returns true if `account` is a contract.
979      *
980      * [IMPORTANT]
981      * ====
982      * It is unsafe to assume that an address for which this function returns
983      * false is an externally-owned account (EOA) and not a contract.
984      *
985      * Among others, `isContract` will return false for the following
986      * types of addresses:
987      *
988      *  - an externally-owned account
989      *  - a contract in construction
990      *  - an address where a contract will be created
991      *  - an address where a contract lived, but was destroyed
992      * ====
993      */
994     function isContract(address account) internal view returns (bool) {
995         // This method relies on extcodesize, which returns 0 for contracts in
996         // construction, since the code is only stored at the end of the
997         // constructor execution.
998 
999         uint256 size;
1000         // solhint-disable-next-line no-inline-assembly
1001         assembly { size := extcodesize(account) }
1002         return size > 0;
1003     }
1004 
1005     /**
1006      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1007      * `recipient`, forwarding all available gas and reverting on errors.
1008      *
1009      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1010      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1011      * imposed by `transfer`, making them unable to receive funds via
1012      * `transfer`. {sendValue} removes this limitation.
1013      *
1014      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1015      *
1016      * IMPORTANT: because control is transferred to `recipient`, care must be
1017      * taken to not create reentrancy vulnerabilities. Consider using
1018      * {ReentrancyGuard} or the
1019      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1020      */
1021     function sendValue(address payable recipient, uint256 amount) internal {
1022         require(address(this).balance >= amount, "Address: insufficient balance");
1023 
1024         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1025         (bool success, ) = recipient.call{ value: amount }("");
1026         require(success, "Address: unable to send value, recipient may have reverted");
1027     }
1028 
1029     /**
1030      * @dev Performs a Solidity function call using a low level `call`. A
1031      * plain`call` is an unsafe replacement for a function call: use this
1032      * function instead.
1033      *
1034      * If `target` reverts with a revert reason, it is bubbled up by this
1035      * function (like regular Solidity function calls).
1036      *
1037      * Returns the raw returned data. To convert to the expected return value,
1038      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1039      *
1040      * Requirements:
1041      *
1042      * - `target` must be a contract.
1043      * - calling `target` with `data` must not revert.
1044      *
1045      * _Available since v3.1._
1046      */
1047     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1048       return functionCall(target, data, "Address: low-level call failed");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1053      * `errorMessage` as a fallback revert reason when `target` reverts.
1054      *
1055      * _Available since v3.1._
1056      */
1057     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1058         return functionCallWithValue(target, data, 0, errorMessage);
1059     }
1060 
1061     /**
1062      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1063      * but also transferring `value` wei to `target`.
1064      *
1065      * Requirements:
1066      *
1067      * - the calling contract must have an ETH balance of at least `value`.
1068      * - the called Solidity function must be `payable`.
1069      *
1070      * _Available since v3.1._
1071      */
1072     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1073         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1074     }
1075 
1076     /**
1077      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1078      * with `errorMessage` as a fallback revert reason when `target` reverts.
1079      *
1080      * _Available since v3.1._
1081      */
1082     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1083         require(address(this).balance >= value, "Address: insufficient balance for call");
1084         require(isContract(target), "Address: call to non-contract");
1085 
1086         // solhint-disable-next-line avoid-low-level-calls
1087         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1088         return _verifyCallResult(success, returndata, errorMessage);
1089     }
1090 
1091     /**
1092      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1093      * but performing a static call.
1094      *
1095      * _Available since v3.3._
1096      */
1097     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1098         return functionStaticCall(target, data, "Address: low-level static call failed");
1099     }
1100 
1101     /**
1102      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1103      * but performing a static call.
1104      *
1105      * _Available since v3.3._
1106      */
1107     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1108         require(isContract(target), "Address: static call to non-contract");
1109 
1110         // solhint-disable-next-line avoid-low-level-calls
1111         (bool success, bytes memory returndata) = target.staticcall(data);
1112         return _verifyCallResult(success, returndata, errorMessage);
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1117      * but performing a delegate call.
1118      *
1119      * _Available since v3.4._
1120      */
1121     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1122         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1123     }
1124 
1125     /**
1126      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1127      * but performing a delegate call.
1128      *
1129      * _Available since v3.4._
1130      */
1131     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1132         require(isContract(target), "Address: delegate call to non-contract");
1133 
1134         // solhint-disable-next-line avoid-low-level-calls
1135         (bool success, bytes memory returndata) = target.delegatecall(data);
1136         return _verifyCallResult(success, returndata, errorMessage);
1137     }
1138 
1139     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1140         if (success) {
1141             return returndata;
1142         } else {
1143             // Look for revert reason and bubble it up if present
1144             if (returndata.length > 0) {
1145                 // The easiest way to bubble the revert reason is using memory via assembly
1146 
1147                 // solhint-disable-next-line no-inline-assembly
1148                 assembly {
1149                     let returndata_size := mload(returndata)
1150                     revert(add(32, returndata), returndata_size)
1151                 }
1152             } else {
1153                 revert(errorMessage);
1154             }
1155         }
1156     }
1157 }
1158 
1159 // File: @openzeppelin/contracts@4.1.0/token/ERC721/IERC721Receiver.sol
1160 
1161 
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 /**
1166  * @title ERC721 token receiver interface
1167  * @dev Interface for any contract that wants to support safeTransfers
1168  * from ERC721 asset contracts.
1169  */
1170 interface IERC721Receiver {
1171     /**
1172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1173      * by `operator` from `from`, this function is called.
1174      *
1175      * It must return its Solidity selector to confirm the token transfer.
1176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1177      *
1178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1179      */
1180     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1181 }
1182 
1183 
1184 // File: AssPocket.sol
1185 
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 
1192 // "INSPIRED BY" / STOLEN FROM FUCKINGPICKLES
1193 contract AssPocket is ERC721, ERC721Enumerable, Ownable {
1194     uint16 public constant MAX_BANANAS = 10000;
1195     uint16 public theWorstGoldenBanana = 10000;
1196     uint16 public theHolyGoldenBanana = 10000;
1197     string private baseURI;
1198     
1199     constructor(string memory uri) ERC721("MyBananaFucko", "MBF") {
1200       setBaseURI(uri);
1201     }
1202 
1203     function mintMyBanana(address _to, uint _count) public payable {
1204         require(totalSupply() + _count <= MAX_BANANAS, "Max limit or Sale Ended");
1205         require(_count <= 20, "Exceeds 20");
1206         require(msg.value >= price(_count), "Value below price");
1207         for(uint i = 0; i < _count; i++){
1208             _safeMint(_to, totalSupply());
1209         }
1210     }
1211     
1212     function price(uint _count) public view returns (uint256) {
1213         // IT'S RAINING 1000 BANANAS
1214         if(totalSupply() <= 1000 ){
1215             return 0;
1216         }
1217         return 10000000000000000 * _count; // 0.01 ETH
1218     }
1219 
1220     function selectGoldenBanana() public onlyOwner {
1221         // FIXING THE GOLDEN PICKLE SCAM DRAW (MY MOST SINCERE CONDOLENCES TO PICKLE #9999, OWNER WILL GET AIRDROPPED BANANA #0 FREE OF CHARGE)
1222         require(theWorstGoldenBanana == 10000 || theHolyGoldenBanana == 10000, "Golden Bananas already minted");
1223         require(totalSupply() >= 2);
1224         uint256 randomHash = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
1225         if(theWorstGoldenBanana == 10000) {
1226             // LEARN FUCKING MODULO MATH SCUMBAG
1227             randomHash = randomHash % totalSupply();
1228             theWorstGoldenBanana = uint16(randomHash);
1229         } else {
1230             randomHash = randomHash % totalSupply()-1;
1231             if(randomHash >= theWorstGoldenBanana) {
1232                 randomHash++;
1233             }
1234             theHolyGoldenBanana = uint16(randomHash);
1235         }   
1236     }
1237     
1238     function withdrawAll() public payable onlyOwner {
1239         require(payable(_msgSender()).send(address(this).balance));
1240     }
1241 
1242     function _baseURI() internal view override returns (string memory) {
1243       return baseURI;
1244     }
1245     
1246     function setBaseURI(string memory uri) public onlyOwner {
1247       baseURI = uri;
1248     }
1249 
1250     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1251         internal
1252         override(ERC721, ERC721Enumerable)
1253     {
1254         super._beforeTokenTransfer(from, to, tokenId);
1255     }
1256 
1257     function supportsInterface(bytes4 interfaceId)
1258         public
1259         view
1260         override(ERC721, ERC721Enumerable)
1261         returns (bool)
1262     {
1263         return super.supportsInterface(interfaceId);
1264     }
1265 }