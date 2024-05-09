1 // File: @openzeppelin/contracts/access/Ownable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/utils/Address.sol
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
99 
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
125 
126 
127 
128 pragma solidity ^0.8.0;
129 
130 
131 /**
132  * @dev Required interface of an ERC721 compliant contract.
133  */
134 interface IERC721 is IERC165 {
135     /**
136      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
142      */
143     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
147      */
148     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
149 
150     /**
151      * @dev Returns the number of tokens in ``owner``'s account.
152      */
153     function balanceOf(address owner) external view returns (uint256 balance);
154 
155     /**
156      * @dev Returns the owner of the `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function ownerOf(uint256 tokenId) external view returns (address owner);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
166      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     /**
185      * @dev Transfers `tokenId` token from `from` to `to`.
186      *
187      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     /**
205      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
206      * The approval is cleared when the token is transferred.
207      *
208      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
209      *
210      * Requirements:
211      *
212      * - The caller must own the token or be an approved operator.
213      * - `tokenId` must exist.
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address to, uint256 tokenId) external;
218 
219     /**
220      * @dev Returns the account approved for `tokenId` token.
221      *
222      * Requirements:
223      *
224      * - `tokenId` must exist.
225      */
226     function getApproved(uint256 tokenId) external view returns (address operator);
227 
228     /**
229      * @dev Approve or remove `operator` as an operator for the caller.
230      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
242      *
243      * See {setApprovalForAll}
244      */
245     function isApprovedForAll(address owner, address operator) external view returns (bool);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId,
264         bytes calldata data
265     ) external;
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
269 
270 pragma solidity ^0.8.0;
271 
272 
273 /**
274  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
275  * @dev See https://eips.ethereum.org/EIPS/eip-721
276  */
277 interface IERC721Enumerable is IERC721 {
278     /**
279      * @dev Returns the total amount of tokens stored by the contract.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
285      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
286      */
287     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
288 
289     /**
290      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
291      * Use along with {totalSupply} to enumerate all tokens.
292      */
293     function tokenByIndex(uint256 index) external view returns (uint256);
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
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
325 // File: @openzeppelin/contracts/utils/Strings.sol
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
332  * @dev See https://eips.ethereum.org/EIPS/eip-721
333  */
334 interface IERC721Metadata is IERC721 {
335     /**
336      * @dev Returns the token collection name.
337      */
338     function name() external view returns (string memory);
339 
340     /**
341      * @dev Returns the token collection symbol.
342      */
343     function symbol() external view returns (string memory);
344 
345     /**
346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
347      */
348     function tokenURI(uint256 tokenId) external view returns (string memory);
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
352 
353 pragma solidity ^0.8.0;
354 
355 
356 
357 
358 
359 
360 
361 
362 /**
363  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
364  * the Metadata extension, but not including the Enumerable extension, which is available separately as
365  * {ERC721Enumerable}.
366  */
367 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
368     using Address for address;
369     using Strings for uint256;
370 
371     // Token name
372     string private _name;
373 
374     // Token symbol
375     string private _symbol;
376 
377     // Mapping from token ID to owner address
378     mapping(uint256 => address) private _owners;
379 
380     // Mapping owner address to token count
381     mapping(address => uint256) private _balances;
382 
383     // Mapping from token ID to approved address
384     mapping(uint256 => address) private _tokenApprovals;
385 
386     // Mapping from owner to operator approvals
387     mapping(address => mapping(address => bool)) private _operatorApprovals;
388 
389     /**
390      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
391      */
392     constructor(string memory name_, string memory symbol_) {
393         _name = name_;
394         _symbol = symbol_;
395     }
396 
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
401         return
402             interfaceId == type(IERC721).interfaceId ||
403             interfaceId == type(IERC721Metadata).interfaceId ||
404             super.supportsInterface(interfaceId);
405     }
406 
407     /**
408      * @dev See {IERC721-balanceOf}.
409      */
410     function balanceOf(address owner) public view virtual override returns (uint256) {
411         require(owner != address(0), "ERC721: balance query for the zero address");
412         return _balances[owner];
413     }
414 
415     /**
416      * @dev See {IERC721-ownerOf}.
417      */
418     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
419         address owner = _owners[tokenId];
420         require(owner != address(0), "ERC721: owner query for nonexistent token");
421         return owner;
422     }
423 
424     /**
425      * @dev See {IERC721Metadata-name}.
426      */
427     function name() public view virtual override returns (string memory) {
428         return _name;
429     }
430 
431     /**
432      * @dev See {IERC721Metadata-symbol}.
433      */
434     function symbol() public view virtual override returns (string memory) {
435         return _symbol;
436     }
437 
438     /**
439      * @dev See {IERC721Metadata-tokenURI}.
440      */
441     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
442         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
443 
444         string memory baseURI = _baseURI();
445         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
446     }
447 
448     /**
449      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
450      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
451      * by default, can be overriden in child contracts.
452      */
453     function _baseURI() internal view virtual returns (string memory) {
454         return "";
455     }
456 
457     /**
458      * @dev See {IERC721-approve}.
459      */
460     function approve(address to, uint256 tokenId) public virtual override {
461         address owner = ERC721.ownerOf(tokenId);
462         require(to != owner, "ERC721: approval to current owner");
463 
464         require(
465             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
466             "ERC721: approve caller is not owner nor approved for all"
467         );
468 
469         _approve(to, tokenId);
470     }
471 
472     /**
473      * @dev See {IERC721-getApproved}.
474      */
475     function getApproved(uint256 tokenId) public view virtual override returns (address) {
476         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
477 
478         return _tokenApprovals[tokenId];
479     }
480 
481     /**
482      * @dev See {IERC721-setApprovalForAll}.
483      */
484     function setApprovalForAll(address operator, bool approved) public virtual override {
485         require(operator != _msgSender(), "ERC721: approve to caller");
486 
487         _operatorApprovals[_msgSender()][operator] = approved;
488         emit ApprovalForAll(_msgSender(), operator, approved);
489     }
490 
491     /**
492      * @dev See {IERC721-isApprovedForAll}.
493      */
494     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
495         return _operatorApprovals[owner][operator];
496     }
497 
498     /**
499      * @dev See {IERC721-transferFrom}.
500      */
501     function transferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) public virtual override {
506         //solhint-disable-next-line max-line-length
507         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
508 
509         _transfer(from, to, tokenId);
510     }
511 
512     /**
513      * @dev See {IERC721-safeTransferFrom}.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) public virtual override {
520         safeTransferFrom(from, to, tokenId, "");
521     }
522 
523     /**
524      * @dev See {IERC721-safeTransferFrom}.
525      */
526     function safeTransferFrom(
527         address from,
528         address to,
529         uint256 tokenId,
530         bytes memory _data
531     ) public virtual override {
532         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
533         _safeTransfer(from, to, tokenId, _data);
534     }
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
539      *
540      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
541      *
542      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
543      * implement alternative mechanisms to perform token transfer, such as signature-based.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function _safeTransfer(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes memory _data
559     ) internal virtual {
560         _transfer(from, to, tokenId);
561         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
562     }
563 
564     /**
565      * @dev Returns whether `tokenId` exists.
566      *
567      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
568      *
569      * Tokens start existing when they are minted (`_mint`),
570      * and stop existing when they are burned (`_burn`).
571      */
572     function _exists(uint256 tokenId) internal view virtual returns (bool) {
573         return _owners[tokenId] != address(0);
574     }
575 
576     /**
577      * @dev Returns whether `spender` is allowed to manage `tokenId`.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
584         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
585         address owner = ERC721.ownerOf(tokenId);
586         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
587     }
588 
589     /**
590      * @dev Safely mints `tokenId` and transfers it to `to`.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must not exist.
595      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
596      *
597      * Emits a {Transfer} event.
598      */
599     function _safeMint(address to, uint256 tokenId) internal virtual {
600         _safeMint(to, tokenId, "");
601     }
602 
603     /**
604      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
605      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
606      */
607     function _safeMint(
608         address to,
609         uint256 tokenId,
610         bytes memory _data
611     ) internal virtual {
612         _mint(to, tokenId);
613         require(
614             _checkOnERC721Received(address(0), to, tokenId, _data),
615             "ERC721: transfer to non ERC721Receiver implementer"
616         );
617     }
618 
619     /**
620      * @dev Mints `tokenId` and transfers it to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
623      *
624      * Requirements:
625      *
626      * - `tokenId` must not exist.
627      * - `to` cannot be the zero address.
628      *
629      * Emits a {Transfer} event.
630      */
631     function _mint(address to, uint256 tokenId) internal virtual {
632         require(to != address(0), "ERC721: mint to the zero address");
633         require(!_exists(tokenId), "ERC721: token already minted");
634 
635         _beforeTokenTransfer(address(0), to, tokenId);
636 
637         _balances[to] += 1;
638         _owners[tokenId] = to;
639 
640         emit Transfer(address(0), to, tokenId);
641     }
642 
643     /**
644      * @dev Destroys `tokenId`.
645      * The approval is cleared when the token is burned.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      *
651      * Emits a {Transfer} event.
652      */
653     function _burn(uint256 tokenId) internal virtual {
654         address owner = ERC721.ownerOf(tokenId);
655 
656         _beforeTokenTransfer(owner, address(0), tokenId);
657 
658         // Clear approvals
659         _approve(address(0), tokenId);
660 
661         _balances[owner] -= 1;
662         delete _owners[tokenId];
663 
664         emit Transfer(owner, address(0), tokenId);
665     }
666 
667     /**
668      * @dev Transfers `tokenId` from `from` to `to`.
669      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
670      *
671      * Requirements:
672      *
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must be owned by `from`.
675      *
676      * Emits a {Transfer} event.
677      */
678     function _transfer(
679         address from,
680         address to,
681         uint256 tokenId
682     ) internal virtual {
683         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
684         require(to != address(0), "ERC721: transfer to the zero address");
685 
686         _beforeTokenTransfer(from, to, tokenId);
687 
688         // Clear approvals from the previous owner
689         _approve(address(0), tokenId);
690 
691         _balances[from] -= 1;
692         _balances[to] += 1;
693         _owners[tokenId] = to;
694 
695         emit Transfer(from, to, tokenId);
696     }
697 
698     /**
699      * @dev Approve `to` to operate on `tokenId`
700      *
701      * Emits a {Approval} event.
702      */
703     function _approve(address to, uint256 tokenId) internal virtual {
704         _tokenApprovals[tokenId] = to;
705         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
706     }
707 
708     /**
709      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
710      * The call is not executed if the target address is not a contract.
711      *
712      * @param from address representing the previous owner of the given token ID
713      * @param to target address that will receive the tokens
714      * @param tokenId uint256 ID of the token to be transferred
715      * @param _data bytes optional data to send along with the call
716      * @return bool whether the call correctly returned the expected magic value
717      */
718     function _checkOnERC721Received(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes memory _data
723     ) private returns (bool) {
724         if (to.isContract()) {
725             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
726                 return retval == IERC721Receiver(to).onERC721Received.selector;
727             } catch (bytes memory reason) {
728                 if (reason.length == 0) {
729                     revert("ERC721: transfer to non ERC721Receiver implementer");
730                 } else {
731                     assembly {
732                         revert(add(32, reason), mload(reason))
733                     }
734                 }
735             }
736         } else {
737             return true;
738         }
739     }
740 
741     /**
742      * @dev Hook that is called before any token transfer. This includes minting
743      * and burning.
744      *
745      * Calling conditions:
746      *
747      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
748      * transferred to `to`.
749      * - When `from` is zero, `tokenId` will be minted for `to`.
750      * - When `to` is zero, ``from``'s `tokenId` will be burned.
751      * - `from` and `to` are never both zero.
752      *
753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
754      */
755     function _beforeTokenTransfer(
756         address from,
757         address to,
758         uint256 tokenId
759     ) internal virtual {}
760 }
761 
762 // File: Nico/Incognito/index-prod.sol
763 
764 
765 pragma solidity ^0.8.0;
766 
767 
768 
769 /**
770  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
771  * enumerability of all the token ids in the contract as well as all token ids owned by each
772  * account.
773  */
774 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
775     // Mapping from owner to list of owned token IDs
776     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
777 
778     // Mapping from token ID to index of the owner tokens list
779     mapping(uint256 => uint256) private _ownedTokensIndex;
780 
781     // Array with all token ids, used for enumeration
782     uint256[] private _allTokens;
783 
784     // Mapping from token id to position in the allTokens array
785     mapping(uint256 => uint256) private _allTokensIndex;
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
791         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
792     }
793 
794     /**
795      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
796      */
797     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
798         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
799         return _ownedTokens[owner][index];
800     }
801 
802     /**
803      * @dev See {IERC721Enumerable-totalSupply}.
804      */
805     function totalSupply() public view virtual override returns (uint256) {
806         return _allTokens.length;
807     }
808 
809     /**
810      * @dev See {IERC721Enumerable-tokenByIndex}.
811      */
812     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
813         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
814         return _allTokens[index];
815     }
816 
817     /**
818      * @dev Hook that is called before any token transfer. This includes minting
819      * and burning.
820      *
821      * Calling conditions:
822      *
823      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
824      * transferred to `to`.
825      * - When `from` is zero, `tokenId` will be minted for `to`.
826      * - When `to` is zero, ``from``'s `tokenId` will be burned.
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      *
830      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
831      */
832     function _beforeTokenTransfer(
833         address from,
834         address to,
835         uint256 tokenId
836     ) internal virtual override {
837         super._beforeTokenTransfer(from, to, tokenId);
838 
839         if (from == address(0)) {
840             _addTokenToAllTokensEnumeration(tokenId);
841         } else if (from != to) {
842             _removeTokenFromOwnerEnumeration(from, tokenId);
843         }
844         if (to == address(0)) {
845             _removeTokenFromAllTokensEnumeration(tokenId);
846         } else if (to != from) {
847             _addTokenToOwnerEnumeration(to, tokenId);
848         }
849     }
850 
851     /**
852      * @dev Private function to add a token to this extension's ownership-tracking data structures.
853      * @param to address representing the new owner of the given token ID
854      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
855      */
856     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
857         uint256 length = ERC721.balanceOf(to);
858         _ownedTokens[to][length] = tokenId;
859         _ownedTokensIndex[tokenId] = length;
860     }
861 
862     /**
863      * @dev Private function to add a token to this extension's token tracking data structures.
864      * @param tokenId uint256 ID of the token to be added to the tokens list
865      */
866     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
867         _allTokensIndex[tokenId] = _allTokens.length;
868         _allTokens.push(tokenId);
869     }
870 
871     /**
872      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
873      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
874      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
875      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
876      * @param from address representing the previous owner of the given token ID
877      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
878      */
879     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
880         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
881         // then delete the last slot (swap and pop).
882 
883         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
884         uint256 tokenIndex = _ownedTokensIndex[tokenId];
885 
886         // When the token to delete is the last token, the swap operation is unnecessary
887         if (tokenIndex != lastTokenIndex) {
888             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
889 
890             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
891             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
892         }
893 
894         // This also deletes the contents at the last position of the array
895         delete _ownedTokensIndex[tokenId];
896         delete _ownedTokens[from][lastTokenIndex];
897     }
898 
899     /**
900      * @dev Private function to remove a token from this extension's token tracking data structures.
901      * This has O(1) time complexity, but alters the order of the _allTokens array.
902      * @param tokenId uint256 ID of the token to be removed from the tokens list
903      */
904     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
905         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
906         // then delete the last slot (swap and pop).
907 
908         uint256 lastTokenIndex = _allTokens.length - 1;
909         uint256 tokenIndex = _allTokensIndex[tokenId];
910 
911         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
912         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
913         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
914         uint256 lastTokenId = _allTokens[lastTokenIndex];
915 
916         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
917         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
918 
919         // This also deletes the contents at the last position of the array
920         delete _allTokensIndex[tokenId];
921         _allTokens.pop();
922     }
923 }
924 
925 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
926 
927 
928 
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
939     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
990             buffer[i] = _HEX_SYMBOLS[value & 0xf];
991             value >>= 4;
992         }
993         require(value == 0, "Strings: hex length insufficient");
994         return string(buffer);
995     }
996 }
997 
998 // File: @openzeppelin/contracts/utils/Context.sol
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 /**
1009  * @dev Collection of functions related to the address type
1010  */
1011 library Address {
1012     /**
1013      * @dev Returns true if `account` is a contract.
1014      *
1015      * [IMPORTANT]
1016      * ====
1017      * It is unsafe to assume that an address for which this function returns
1018      * false is an externally-owned account (EOA) and not a contract.
1019      *
1020      * Among others, `isContract` will return false for the following
1021      * types of addresses:
1022      *
1023      *  - an externally-owned account
1024      *  - a contract in construction
1025      *  - an address where a contract will be created
1026      *  - an address where a contract lived, but was destroyed
1027      * ====
1028      */
1029     function isContract(address account) internal view returns (bool) {
1030         // This method relies on extcodesize, which returns 0 for contracts in
1031         // construction, since the code is only stored at the end of the
1032         // constructor execution.
1033 
1034         uint256 size;
1035         assembly {
1036             size := extcodesize(account)
1037         }
1038         return size > 0;
1039     }
1040 
1041     /**
1042      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1043      * `recipient`, forwarding all available gas and reverting on errors.
1044      *
1045      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1046      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1047      * imposed by `transfer`, making them unable to receive funds via
1048      * `transfer`. {sendValue} removes this limitation.
1049      *
1050      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1051      *
1052      * IMPORTANT: because control is transferred to `recipient`, care must be
1053      * taken to not create reentrancy vulnerabilities. Consider using
1054      * {ReentrancyGuard} or the
1055      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1056      */
1057     function sendValue(address payable recipient, uint256 amount) internal {
1058         require(address(this).balance >= amount, "Address: insufficient balance");
1059 
1060         (bool success, ) = recipient.call{value: amount}("");
1061         require(success, "Address: unable to send value, recipient may have reverted");
1062     }
1063 
1064     /**
1065      * @dev Performs a Solidity function call using a low level `call`. A
1066      * plain `call` is an unsafe replacement for a function call: use this
1067      * function instead.
1068      *
1069      * If `target` reverts with a revert reason, it is bubbled up by this
1070      * function (like regular Solidity function calls).
1071      *
1072      * Returns the raw returned data. To convert to the expected return value,
1073      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1074      *
1075      * Requirements:
1076      *
1077      * - `target` must be a contract.
1078      * - calling `target` with `data` must not revert.
1079      *
1080      * _Available since v3.1._
1081      */
1082     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1083         return functionCall(target, data, "Address: low-level call failed");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1088      * `errorMessage` as a fallback revert reason when `target` reverts.
1089      *
1090      * _Available since v3.1._
1091      */
1092     function functionCall(
1093         address target,
1094         bytes memory data,
1095         string memory errorMessage
1096     ) internal returns (bytes memory) {
1097         return functionCallWithValue(target, data, 0, errorMessage);
1098     }
1099 
1100     /**
1101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1102      * but also transferring `value` wei to `target`.
1103      *
1104      * Requirements:
1105      *
1106      * - the calling contract must have an ETH balance of at least `value`.
1107      * - the called Solidity function must be `payable`.
1108      *
1109      * _Available since v3.1._
1110      */
1111     function functionCallWithValue(
1112         address target,
1113         bytes memory data,
1114         uint256 value
1115     ) internal returns (bytes memory) {
1116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1117     }
1118 
1119     /**
1120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1121      * with `errorMessage` as a fallback revert reason when `target` reverts.
1122      *
1123      * _Available since v3.1._
1124      */
1125     function functionCallWithValue(
1126         address target,
1127         bytes memory data,
1128         uint256 value,
1129         string memory errorMessage
1130     ) internal returns (bytes memory) {
1131         require(address(this).balance >= value, "Address: insufficient balance for call");
1132         require(isContract(target), "Address: call to non-contract");
1133 
1134         (bool success, bytes memory returndata) = target.call{value: value}(data);
1135         return _verifyCallResult(success, returndata, errorMessage);
1136     }
1137 
1138     /**
1139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1140      * but performing a static call.
1141      *
1142      * _Available since v3.3._
1143      */
1144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1145         return functionStaticCall(target, data, "Address: low-level static call failed");
1146     }
1147 
1148     /**
1149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1150      * but performing a static call.
1151      *
1152      * _Available since v3.3._
1153      */
1154     function functionStaticCall(
1155         address target,
1156         bytes memory data,
1157         string memory errorMessage
1158     ) internal view returns (bytes memory) {
1159         require(isContract(target), "Address: static call to non-contract");
1160 
1161         (bool success, bytes memory returndata) = target.staticcall(data);
1162         return _verifyCallResult(success, returndata, errorMessage);
1163     }
1164 
1165     /**
1166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1167      * but performing a delegate call.
1168      *
1169      * _Available since v3.4._
1170      */
1171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1173     }
1174 
1175     /**
1176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1177      * but performing a delegate call.
1178      *
1179      * _Available since v3.4._
1180      */
1181     function functionDelegateCall(
1182         address target,
1183         bytes memory data,
1184         string memory errorMessage
1185     ) internal returns (bytes memory) {
1186         require(isContract(target), "Address: delegate call to non-contract");
1187 
1188         (bool success, bytes memory returndata) = target.delegatecall(data);
1189         return _verifyCallResult(success, returndata, errorMessage);
1190     }
1191 
1192     function _verifyCallResult(
1193         bool success,
1194         bytes memory returndata,
1195         string memory errorMessage
1196     ) private pure returns (bytes memory) {
1197         if (success) {
1198             return returndata;
1199         } else {
1200             // Look for revert reason and bubble it up if present
1201             if (returndata.length > 0) {
1202                 // The easiest way to bubble the revert reason is using memory via assembly
1203 
1204                 assembly {
1205                     let returndata_size := mload(returndata)
1206                     revert(add(32, returndata), returndata_size)
1207                 }
1208             } else {
1209                 revert(errorMessage);
1210             }
1211         }
1212     }
1213 }
1214 
1215 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 /**
1226  * @title ERC721 token receiver interface
1227  * @dev Interface for any contract that wants to support safeTransfers
1228  * from ERC721 asset contracts.
1229  */
1230 interface IERC721Receiver {
1231     /**
1232      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1233      * by `operator` from `from`, this function is called.
1234      *
1235      * It must return its Solidity selector to confirm the token transfer.
1236      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1237      *
1238      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1239      */
1240     function onERC721Received(
1241         address operator,
1242         address from,
1243         uint256 tokenId,
1244         bytes calldata data
1245     ) external returns (bytes4);
1246 }
1247 
1248 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1249 
1250 
1251 
1252 
1253 
1254 
1255 
1256 
1257 
1258 
1259 
1260 
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 
1267 
1268 
1269 contract Incognito is ERC721, ERC721Enumerable, Ownable {
1270   
1271   // Provenance
1272   string public INCOGNITO_HASH = "";
1273 
1274   // Price & Supply
1275   uint256 public constant NFT_PRICE = 85000000000000000; //0.085 ETH
1276   uint public constant MAX_SUPPLY = 10000;
1277 
1278   // Internals
1279   string private _baseTokenURI;
1280   uint256 public startingIndexBlock;
1281   uint256 public startingIndex;  
1282 
1283   // Sale
1284   bool public hasSaleStarted = false;
1285   uint private constant MAX_MINT_PER_CALL = 15;
1286 
1287   // Pre-Sale
1288   bool public hasPreSaleStarted = false;
1289   uint public constant MAX_PRESALE_SUPPLY = 1777;
1290 
1291   constructor(string memory baseURI) ERC721("Incognito", "ICON") {
1292     setBaseURI(baseURI);
1293   }
1294 
1295   function _baseURI() internal view override(ERC721) returns (string memory) {        
1296     return _baseTokenURI;
1297   }
1298 
1299   function setBaseURI(string memory baseURI) public onlyOwner {
1300     _baseTokenURI = baseURI;
1301   }
1302   function getBaseURI() external view returns(string memory) {
1303     return _baseTokenURI;
1304   }
1305   
1306   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1307     uint256 tokenCount = balanceOf(_owner);
1308     if (tokenCount == 0) {
1309       // Return an empty array
1310       return new uint256[](0);
1311     } else {
1312       uint256[] memory result = new uint256[](tokenCount);
1313       uint256 index;
1314       for (index = 0; index < tokenCount; index++) {
1315         result[index] = tokenOfOwnerByIndex(_owner, index);
1316       }
1317       return result;
1318     }
1319   }
1320 
1321   function mintPreSale() public payable {
1322     require(hasPreSaleStarted, "Presale has not started");
1323     require(msg.value >= NFT_PRICE, "Incorrect ether value");
1324     require(totalSupply() < MAX_PRESALE_SUPPLY, "Presale has ended");
1325 
1326     uint mintIndex = totalSupply() + 1; // +1 so it doesn't start on index 0.
1327     _safeMint(msg.sender, mintIndex);
1328 
1329     // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
1330     // the end of pre-sale, set the starting index block
1331     if (startingIndexBlock == 0 && (totalSupply() == MAX_SUPPLY)) {
1332       startingIndexBlock = block.number;
1333     } 
1334   }
1335 
1336   function mint(uint256 numNFTs) public payable {
1337     require(hasSaleStarted, "Sale has not started");
1338     require(MAX_SUPPLY > totalSupply(), "Sale has ended");
1339     require(numNFTs > 0 && numNFTs <= MAX_MINT_PER_CALL, "Exceeds MAX_MINT_PER_CALL");
1340     require(MAX_SUPPLY >= totalSupply() + numNFTs, "Exceeds MAX_SUPPLY");
1341     require(msg.value >= NFT_PRICE * numNFTs, "Incorrect ether value");
1342 
1343     for (uint i = 0; i < numNFTs; i++) {
1344       uint mintIndex = totalSupply() + 1; // +1 so it doesn't start on index 0.
1345       _safeMint(msg.sender, mintIndex);
1346     }
1347 
1348     // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
1349     // the end of pre-sale, set the starting index block
1350     if (startingIndexBlock == 0 && (totalSupply() == MAX_SUPPLY)) {
1351       startingIndexBlock = block.number;
1352     } 
1353   }
1354 
1355   function flipSaleState() public onlyOwner {
1356     hasSaleStarted = !hasSaleStarted;
1357   }
1358 
1359   function flipPreSaleState() public onlyOwner {
1360     hasPreSaleStarted = !hasPreSaleStarted;
1361   }
1362   
1363   function withdraw() public onlyOwner {
1364     require(payable(msg.sender).send(address(this).balance));
1365   }
1366   function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1367     internal
1368     override(ERC721, ERC721Enumerable)
1369   {
1370     super._beforeTokenTransfer(from, to, tokenId);
1371   }
1372 
1373   function _burn(uint256 tokenId) internal override(ERC721) {
1374     super._burn(tokenId);
1375   }
1376 
1377   function tokenURI(uint256 tokenId)
1378     public
1379     view
1380     override(ERC721)
1381     returns (string memory)
1382   {
1383     return super.tokenURI(tokenId);
1384   }
1385   function supportsInterface(bytes4 interfaceId)
1386     public
1387     view
1388     override(ERC721, ERC721Enumerable)
1389     returns (bool)
1390   {
1391     return super.supportsInterface(interfaceId);
1392   }
1393 
1394   function setStartingIndex() public {
1395     require(startingIndex == 0, "Starting index is already set");
1396     require(startingIndexBlock != 0, "Starting index block must be set");
1397     
1398     startingIndex = uint(blockhash(startingIndexBlock)) % MAX_SUPPLY;
1399     // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1400     if (block.number - startingIndexBlock > 255) {
1401       startingIndex = uint(blockhash(block.number - 1)) % MAX_SUPPLY;
1402     }
1403     // Prevent default sequence
1404     if (startingIndex == 0) {
1405       startingIndex = startingIndex + 1;
1406     }
1407   }
1408 
1409   function emergencySetStartingIndexBlock() public onlyOwner {
1410     require(startingIndex == 0, "Starting index is already set");
1411     startingIndexBlock = block.number;
1412   }
1413 
1414   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1415     INCOGNITO_HASH = provenanceHash;
1416   }
1417 }