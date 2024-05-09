1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(
60         address indexed from,
61         address indexed to,
62         uint256 indexed tokenId
63     );
64 
65     /**
66      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
67      */
68     event Approval(
69         address indexed owner,
70         address indexed approved,
71         uint256 indexed tokenId
72     );
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(
78         address indexed owner,
79         address indexed operator,
80         bool approved
81     );
82 
83     /**
84      * @dev Returns the number of tokens in ``owner``'s account.
85      */
86     function balanceOf(address owner) external view returns (uint256 balance);
87 
88     /**
89      * @dev Returns the owner of the `tokenId` token.
90      *
91      * Requirements:
92      *
93      * - `tokenId` must exist.
94      */
95     function ownerOf(uint256 tokenId) external view returns (address owner);
96 
97     /**
98      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
99      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must exist and be owned by `from`.
106      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
108      *
109      * Emits a {Transfer} event.
110      */
111     function safeTransferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Transfers `tokenId` token from `from` to `to`.
119      *
120      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must be owned by `from`.
127      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address from,
133         address to,
134         uint256 tokenId
135     ) external;
136 
137     /**
138      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
139      * The approval is cleared when the token is transferred.
140      *
141      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
142      *
143      * Requirements:
144      *
145      * - The caller must own the token or be an approved operator.
146      * - `tokenId` must exist.
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address to, uint256 tokenId) external;
151 
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId)
160         external
161         view
162         returns (address operator);
163 
164     /**
165      * @dev Approve or remove `operator` as an operator for the caller.
166      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
167      *
168      * Requirements:
169      *
170      * - The `operator` cannot be the caller.
171      *
172      * Emits an {ApprovalForAll} event.
173      */
174     function setApprovalForAll(address operator, bool _approved) external;
175 
176     /**
177      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
178      *
179      * See {setApprovalForAll}
180      */
181     function isApprovedForAll(address owner, address operator)
182         external
183         view
184         returns (bool);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external;
205 }
206 
207 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Enumerable is IERC721 {
215     /**
216      * @dev Returns the total amount of tokens stored by the contract.
217      */
218     function totalSupply() external view returns (uint256);
219 
220     /**
221      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
222      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
223      */
224     function tokenOfOwnerByIndex(address owner, uint256 index)
225         external
226         view
227         returns (uint256 tokenId);
228 
229     /**
230      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
231      * Use along with {totalSupply} to enumerate all tokens.
232      */
233     function tokenByIndex(uint256 index) external view returns (uint256);
234 }
235 
236 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Implementation of the {IERC165} interface.
241  *
242  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
243  * for the additional interface id that will be supported. For example:
244  *
245  * ```soliditycontract ERC721 is Context, ERC165, IERC721, IERC721Metadata
246  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
247  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
248  * }
249  * ```
250  *
251  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
252  */
253 abstract contract ERC165 is IERC165 {
254     /**
255      * @dev See {IERC165-supportsInterface}.
256      */
257     function supportsInterface(bytes4 interfaceId)
258         public
259         view
260         virtual
261         override
262         returns (bool)
263     {
264         return interfaceId == type(IERC165).interfaceId;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
273  * @dev See https://eips.ethereum.org/EIPS/eip-721
274  */
275 interface IERC721Metadata is IERC721 {
276     /**
277      * @dev Returns the token collection name.
278      */
279     function name() external view returns (string memory);
280 
281     /**
282      * @dev Returns the token collection symbol.
283      */
284     function symbol() external view returns (string memory);
285 
286     /**
287      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
288      */
289     function tokenURI(uint256 tokenId) external view returns (string memory);
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 pragma solidity ^0.8.10;
319 
320 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
321     using Address for address;
322 
323     string private _name;
324     string private _symbol;
325 
326     address[] internal _owners;
327 
328     mapping(uint256 => address) private _tokenApprovals;
329     mapping(address => mapping(address => bool)) private _operatorApprovals;
330 
331     constructor(string memory name_, string memory symbol_) {
332         _name = name_;
333         _symbol = symbol_;
334     }
335 
336     function supportsInterface(bytes4 interfaceId)
337         public
338         view
339         virtual
340         override(ERC165, IERC165)
341         returns (bool)
342     {
343         return
344             interfaceId == type(IERC721).interfaceId ||
345             interfaceId == type(IERC721Metadata).interfaceId ||
346             super.supportsInterface(interfaceId);
347     }
348 
349     function balanceOf(address owner)
350         public
351         view
352         virtual
353         override
354         returns (uint256)
355     {
356         require(
357             owner != address(0),
358             "ERC721: balance query for the zero address"
359         );
360         uint256 count = 0;
361         uint256 length = _owners.length;
362         for (uint256 i = 0; i < length; ++i) {
363             if (owner == _owners[i]) {
364                 ++count;
365             }
366         }
367         delete length;
368         return count;
369     }
370 
371     function ownerOf(uint256 tokenId)
372         public
373         view
374         virtual
375         override
376         returns (address)
377     {
378         address owner = _owners[tokenId];
379         require(
380             owner != address(0),
381             "ERC721: owner query for nonexistent token"
382         );
383         return owner;
384     }
385 
386     function name() public view virtual override returns (string memory) {
387         return _name;
388     }
389 
390     function symbol() public view virtual override returns (string memory) {
391         return _symbol;
392     }
393 
394     function approve(address to, uint256 tokenId) public virtual override {
395         address owner = ERC721P.ownerOf(tokenId);
396         require(to != owner, "ERC721: approval to current owner");
397 
398         require(
399             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
400             "ERC721: approve caller is not owner nor approved for all"
401         );
402 
403         _approve(to, tokenId);
404     }
405 
406     function getApproved(uint256 tokenId)
407         public
408         view
409         virtual
410         override
411         returns (address)
412     {
413         require(
414             _exists(tokenId),
415             "ERC721: approved query for nonexistent token"
416         );
417 
418         return _tokenApprovals[tokenId];
419     }
420 
421     function setApprovalForAll(address operator, bool approved)
422         public
423         virtual
424         override
425     {
426         require(operator != _msgSender(), "ERC721: approve to caller");
427 
428         _operatorApprovals[_msgSender()][operator] = approved;
429         emit ApprovalForAll(_msgSender(), operator, approved);
430     }
431 
432     function isApprovedForAll(address owner, address operator)
433         public
434         view
435         virtual
436         override
437         returns (bool)
438     {
439         return _operatorApprovals[owner][operator];
440     }
441 
442     function transferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) public virtual override {
447         //solhint-disable-next-line max-line-length
448         require(
449             _isApprovedOrOwner(_msgSender(), tokenId),
450             "ERC721: transfer caller is not owner nor approved"
451         );
452 
453         _transfer(from, to, tokenId);
454     }
455 
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) public virtual override {
461         safeTransferFrom(from, to, tokenId, "");
462     }
463 
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes memory _data
469     ) public virtual override {
470         require(
471             _isApprovedOrOwner(_msgSender(), tokenId),
472             "ERC721: transfer caller is not owner nor approved"
473         );
474         _safeTransfer(from, to, tokenId, _data);
475     }
476 
477     function _safeTransfer(
478         address from,
479         address to,
480         uint256 tokenId,
481         bytes memory _data
482     ) internal virtual {
483         _transfer(from, to, tokenId);
484         require(
485             _checkOnERC721Received(from, to, tokenId, _data),
486             "ERC721: transfer to non ERC721Receiver implementer"
487         );
488     }
489 
490     function _exists(uint256 tokenId) internal view virtual returns (bool) {
491         return tokenId < _owners.length && _owners[tokenId] != address(0);
492     }
493 
494     function _isApprovedOrOwner(address spender, uint256 tokenId)
495         internal
496         view
497         virtual
498         returns (bool)
499     {
500         require(
501             _exists(tokenId),
502             "ERC721: operator query for nonexistent token"
503         );
504         address owner = ERC721P.ownerOf(tokenId);
505         return (spender == owner ||
506             getApproved(tokenId) == spender ||
507             isApprovedForAll(owner, spender));
508     }
509 
510     function _safeMint(address to, uint256 tokenId) internal virtual {
511         _safeMint(to, tokenId, "");
512     }
513 
514     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
515         _mint(to, tokenId);
516         require(
517             _checkOnERC721Received(address(0), to, tokenId, _data),
518             "ERC721: transfer to non ERC721Receiver implementer"
519         );
520     }
521 
522     function _mint(address to, uint256 tokenId) internal virtual {
523         require(to != address(0), "ERC721: mint to the zero address");
524         require(!_exists(tokenId), "ERC721: token already minted");
525 
526         _beforeTokenTransfer(address(0), to, tokenId);
527         _owners.push(to);
528 
529         emit Transfer(address(0), to, tokenId);
530     }
531 
532     function _burn(uint256 tokenId) internal virtual {
533         address owner = ERC721P.ownerOf(tokenId);
534 
535         _beforeTokenTransfer(owner, address(0), tokenId);
536 
537         _approve(address(0), tokenId);
538         _owners[tokenId] = address(0);
539 
540         emit Transfer(owner, address(0), tokenId);
541     }
542 
543     function _transfer(
544         address from,
545         address to,
546         uint256 tokenId
547     ) internal virtual {
548         require(
549             ERC721P.ownerOf(tokenId) == from,
550             "ERC721: transfer of token that is not own"
551         );
552         require(to != address(0), "ERC721: transfer to the zero address");
553 
554         _beforeTokenTransfer(from, to, tokenId);
555 
556         _approve(address(0), tokenId);
557         _owners[tokenId] = to;
558 
559         emit Transfer(from, to, tokenId);
560     }
561 
562     function _approve(address to, uint256 tokenId) internal virtual {
563         _tokenApprovals[tokenId] = to;
564         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
565     }
566 
567     function _checkOnERC721Received(
568         address from,
569         address to,
570         uint256 tokenId,
571         bytes memory _data
572     ) private returns (bool) {
573         if (to.isContract()) {
574             try
575                 IERC721Receiver(to).onERC721Received(
576                     _msgSender(),
577                     from,
578                     tokenId,
579                     _data
580                 )
581             returns (bytes4 retval) {
582                 return retval == IERC721Receiver.onERC721Received.selector;
583             } catch (bytes memory reason) {
584                 if (reason.length == 0) {
585                     revert(
586                         "ERC721: transfer to non ERC721Receiver implementer"
587                     );
588                 } else {
589                     assembly {
590                         revert(add(32, reason), mload(reason))
591                     }
592                 }
593             }
594         } else {
595             return true;
596         }
597     }
598 
599     function _beforeTokenTransfer(
600         address from,
601         address to,
602         uint256 tokenId
603     ) internal virtual {}
604 }
605 
606 pragma solidity ^0.8.10;
607 
608 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
609     function supportsInterface(bytes4 interfaceId)
610         public
611         view
612         virtual
613         override(IERC165, ERC721P)
614         returns (bool)
615     {
616         return
617             interfaceId == type(IERC721Enumerable).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620 
621     function tokenOfOwnerByIndex(address owner, uint256 index)
622         public
623         view
624         override
625         returns (uint256 tokenId)
626     {
627         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
628         uint256 count;
629         for (uint256 i; i < _owners.length; ++i) {
630             if (owner == _owners[i]) {
631                 if (count == index) return i;
632                 else ++count;
633             }
634         }
635         require(false, "ERC721Enum: owner ioob");
636     }
637 
638     function tokensOfOwner(address owner)
639         public
640         view
641         returns (uint256[] memory)
642     {
643         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
644         uint256 tokenCount = balanceOf(owner);
645         uint256[] memory tokenIds = new uint256[](tokenCount);
646         for (uint256 i = 0; i < tokenCount; i++) {
647             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
648         }
649         return tokenIds;
650     }
651 
652     function totalSupply() public view virtual override returns (uint256) {
653         return _owners.length;
654     }
655 
656     function tokenByIndex(uint256 index)
657         public
658         view
659         virtual
660         override
661         returns (uint256)
662     {
663         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
664         return index;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/access/Ownable.sol
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Contract module which provides a basic access control mechanism, where
673  * there is an account (an owner) that can be granted exclusive access to
674  * specific functions.
675  *
676  * By default, the owner account will be the one that deploys the contract. This
677  * can later be changed with {transferOwnership}.
678  *
679  * This module is used through inheritance. It will make available the modifier
680  * `onlyOwner`, which can be applied to your functions to restrict their use to
681  * the owner.
682  */
683 abstract contract Ownable is Context {
684     address private _owner;
685 
686     event OwnershipTransferred(
687         address indexed previousOwner,
688         address indexed newOwner
689     );
690 
691     /**
692      * @dev Initializes the contract setting the deployer as the initial owner.
693      */
694     constructor() {
695         _setOwner(_msgSender());
696     }
697 
698     /**
699      * @dev Returns the address of the current owner.
700      */
701     function owner() public view virtual returns (address) {
702         return _owner;
703     }
704 
705     /**
706      * @dev Throws if called by any account other than the owner.
707      */
708     modifier onlyOwner() {
709         require(owner() == _msgSender(), "Ownable: caller is not the owner");
710         _;
711     }
712 
713     /**
714      * @dev Leaves the contract without owner. It will not be possible to call
715      * `onlyOwner` functions anymore. Can only be called by the current owner.
716      *
717      * NOTE: Renouncing ownership will leave the contract without an owner,
718      * thereby removing any functionality that is only available to the owner.
719      */
720     function renounceOwnership() public virtual onlyOwner {
721         _setOwner(address(0));
722     }
723 
724     /**
725      * @dev Transfers ownership of the contract to a new account (`newOwner`).
726      * Can only be called by the current owner.
727      */
728     function transferOwnership(address newOwner) public virtual onlyOwner {
729         require(
730             newOwner != address(0),
731             "Ownable: new owner is the zero address"
732         );
733         _setOwner(newOwner);
734     }
735 
736     function _setOwner(address newOwner) private {
737         address oldOwner = _owner;
738         _owner = newOwner;
739         emit OwnershipTransferred(oldOwner, newOwner);
740     }
741 }
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @title PaymentSplitter
747  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
748  * that the Ether will be split in this way, since it is handled transparently by the contract.
749  *
750  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
751  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
752  * an amount proportional to the percentage of total shares they were assigned.
753  *
754  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
755  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
756  * function.
757  */
758 contract PaymentSplitter is Context {
759     event PayeeAdded(address account, uint256 shares);
760     event PaymentReleased(address to, uint256 amount);
761     event PaymentReceived(address from, uint256 amount);
762 
763     uint256 private _totalShares;
764     uint256 private _totalReleased;
765 
766     mapping(address => uint256) private _shares;
767     mapping(address => uint256) private _released;
768     address[] private _payees;
769 
770     /**
771      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
772      * the matching position in the `shares` array.
773      *
774      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
775      * duplicates in `payees`.
776      */
777     constructor(address[] memory payees, uint256[] memory shares_) payable {
778         require(
779             payees.length == shares_.length,
780             "PaymentSplitter: payees and shares length mismatch"
781         );
782         require(payees.length > 0, "PaymentSplitter: no payees");
783 
784         for (uint256 i = 0; i < payees.length; i++) {
785             _addPayee(payees[i], shares_[i]);
786         }
787     }
788 
789     /**
790      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
791      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
792      * reliability of the events, and not the actual splitting of Ether.
793      *
794      * To learn more about this see the Solidity documentation for
795      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
796      * functions].
797      */
798     receive() external payable virtual {
799         emit PaymentReceived(_msgSender(), msg.value);
800     }
801 
802     /**
803      * @dev Getter for the total shares held by payees.
804      */
805     function totalShares() public view returns (uint256) {
806         return _totalShares;
807     }
808 
809     /**
810      * @dev Getter for the total amount of Ether already released.
811      */
812     function totalReleased() public view returns (uint256) {
813         return _totalReleased;
814     }
815 
816     /**
817      * @dev Getter for the amount of shares held by an account.
818      */
819     function shares(address account) public view returns (uint256) {
820         return _shares[account];
821     }
822 
823     /**
824      * @dev Getter for the amount of Ether already released to a payee.
825      */
826     function released(address account) public view returns (uint256) {
827         return _released[account];
828     }
829 
830     /**
831      * @dev Getter for the address of the payee number `index`.
832      */
833     function payee(uint256 index) public view returns (address) {
834         return _payees[index];
835     }
836 
837     /**
838      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
839      * total shares and their previous withdrawals.
840      */
841     function release(address payable account) public virtual {
842         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
843 
844         uint256 totalReceived = address(this).balance + _totalReleased;
845         uint256 payment = (totalReceived * _shares[account]) /
846             _totalShares -
847             _released[account];
848 
849         require(payment != 0, "PaymentSplitter: account is not due payment");
850 
851         _released[account] = _released[account] + payment;
852         _totalReleased = _totalReleased + payment;
853 
854         Address.sendValue(account, payment);
855         emit PaymentReleased(account, payment);
856     }
857 
858     /**
859      * @dev Add a new payee to the contract.
860      * @param account The address of the payee to add.
861      * @param shares_ The number of shares owned by the payee.
862      */
863     function _addPayee(address account, uint256 shares_) private {
864         require(
865             account != address(0),
866             "PaymentSplitter: account is the zero address"
867         );
868         require(shares_ > 0, "PaymentSplitter: shares are 0");
869         require(
870             _shares[account] == 0,
871             "PaymentSplitter: account already has shares"
872         );
873 
874         _payees.push(account);
875         _shares[account] = shares_;
876         _totalShares = _totalShares + shares_;
877         emit PayeeAdded(account, shares_);
878     }
879 }
880 
881 // File: @openzeppelin/contracts/utils/Address.sol
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Collection of functions related to the address type
886  */
887 library Address {
888     /**
889      * @dev Returns true if `account` is a contract.
890      *
891      * [IMPORTANT]
892      * ====
893      * It is unsafe to assume that an address for which this function returns
894      * false is an externally-owned account (EOA) and not a contract.
895      *
896      * Among others, `isContract` will return false for the following
897      * types of addresses:
898      *
899      *  - an externally-owned account
900      *  - a contract in construction
901      *  - an address where a contract will be created
902      *  - an address where a contract lived, but was destroyed
903      * ====
904      */
905     function isContract(address account) internal view returns (bool) {
906         // This method relies on extcodesize, which returns 0 for contracts in
907         // construction, since the code is only stored at the end of the
908         // constructor execution.
909 
910         uint256 size;
911         assembly {
912             size := extcodesize(account)
913         }
914         return size > 0;
915     }
916 
917     /**
918      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
919      * `recipient`, forwarding all available gas and reverting on errors.
920      *
921      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
922      * of certain opcodes, possibly making contracts go over the 2300 gas limit
923      * imposed by `transfer`, making them unable to receive funds via
924      * `transfer`. {sendValue} removes this limitation.
925      *
926      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
927      *
928      * IMPORTANT: because control is transferred to `recipient`, care must be
929      * taken to not create reentrancy vulnerabilities. Consider using
930      * {ReentrancyGuard} or the
931      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
932      */
933     function sendValue(address payable recipient, uint256 amount) internal {
934         require(
935             address(this).balance >= amount,
936             "Address: insufficient balance"
937         );
938 
939         (bool success, ) = recipient.call{value: amount}("");
940         require(
941             success,
942             "Address: unable to send value, recipient may have reverted"
943         );
944     }
945 
946     /**
947      * @dev Performs a Solidity function call using a low level `call`. A
948      * plain `call` is an unsafe replacement for a function call: use this
949      * function instead.
950      *
951      * If `target` reverts with a revert reason, it is bubbled up by this
952      * function (like regular Solidity function calls).
953      *
954      * Returns the raw returned data. To convert to the expected return value,
955      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
956      *
957      * Requirements:
958      *
959      * - `target` must be a contract.
960      * - calling `target` with `data` must not revert.
961      *
962      * _Available since v3.1._
963      */
964     function functionCall(address target, bytes memory data)
965         internal
966         returns (bytes memory)
967     {
968         return functionCall(target, data, "Address: low-level call failed");
969     }
970 
971     /**
972      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
973      * `errorMessage` as a fallback revert reason when `target` reverts.
974      *
975      * _Available since v3.1._
976      */
977     function functionCall(
978         address target,
979         bytes memory data,
980         string memory errorMessage
981     ) internal returns (bytes memory) {
982         return functionCallWithValue(target, data, 0, errorMessage);
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
987      * but also transferring `value` wei to `target`.
988      *
989      * Requirements:
990      *
991      * - the calling contract must have an ETH balance of at least `value`.
992      * - the called Solidity function must be `payable`.
993      *
994      * _Available since v3.1._
995      */
996     function functionCallWithValue(
997         address target,
998         bytes memory data,
999         uint256 value
1000     ) internal returns (bytes memory) {
1001         return
1002             functionCallWithValue(
1003                 target,
1004                 data,
1005                 value,
1006                 "Address: low-level call with value failed"
1007             );
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1012      * with `errorMessage` as a fallback revert reason when `target` reverts.
1013      *
1014      * _Available since v3.1._
1015      */
1016     function functionCallWithValue(
1017         address target,
1018         bytes memory data,
1019         uint256 value,
1020         string memory errorMessage
1021     ) internal returns (bytes memory) {
1022         require(
1023             address(this).balance >= value,
1024             "Address: insufficient balance for call"
1025         );
1026         require(isContract(target), "Address: call to non-contract");
1027 
1028         (bool success, bytes memory returndata) = target.call{value: value}(
1029             data
1030         );
1031         return verifyCallResult(success, returndata, errorMessage);
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1036      * but performing a static call.
1037      *
1038      * _Available since v3.3._
1039      */
1040     function functionStaticCall(address target, bytes memory data)
1041         internal
1042         view
1043         returns (bytes memory)
1044     {
1045         return
1046             functionStaticCall(
1047                 target,
1048                 data,
1049                 "Address: low-level static call failed"
1050             );
1051     }
1052 
1053     /**
1054      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1055      * but performing a static call.
1056      *
1057      * _Available since v3.3._
1058      */
1059     function functionStaticCall(
1060         address target,
1061         bytes memory data,
1062         string memory errorMessage
1063     ) internal view returns (bytes memory) {
1064         require(isContract(target), "Address: static call to non-contract");
1065 
1066         (bool success, bytes memory returndata) = target.staticcall(data);
1067         return verifyCallResult(success, returndata, errorMessage);
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1072      * but performing a delegate call.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function functionDelegateCall(address target, bytes memory data)
1077         internal
1078         returns (bytes memory)
1079     {
1080         return
1081             functionDelegateCall(
1082                 target,
1083                 data,
1084                 "Address: low-level delegate call failed"
1085             );
1086     }
1087 
1088     /**
1089      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1090      * but performing a delegate call.
1091      *
1092      * _Available since v3.4._
1093      */
1094     function functionDelegateCall(
1095         address target,
1096         bytes memory data,
1097         string memory errorMessage
1098     ) internal returns (bytes memory) {
1099         require(isContract(target), "Address: delegate call to non-contract");
1100 
1101         (bool success, bytes memory returndata) = target.delegatecall(data);
1102         return verifyCallResult(success, returndata, errorMessage);
1103     }
1104 
1105     /**
1106      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1107      * revert reason using the provided one.
1108      *
1109      * _Available since v4.3._
1110      */
1111     function verifyCallResult(
1112         bool success,
1113         bytes memory returndata,
1114         string memory errorMessage
1115     ) internal pure returns (bytes memory) {
1116         if (success) {
1117             return returndata;
1118         } else {
1119             // Look for revert reason and bubble it up if present
1120             if (returndata.length > 0) {
1121                 // The easiest way to bubble the revert reason is using memory via assembly
1122 
1123                 assembly {
1124                     let returndata_size := mload(returndata)
1125                     revert(add(32, returndata), returndata_size)
1126                 }
1127             } else {
1128                 revert(errorMessage);
1129             }
1130         }
1131     }
1132 }
1133 
1134 // File: @openzeppelin/contracts/utils/Strings.sol
1135 pragma solidity ^0.8.0;
1136 
1137 /**
1138  * @dev String operations.
1139  */
1140 library Strings {
1141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1142 
1143     /**
1144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1145      */
1146     function toString(uint256 value) internal pure returns (string memory) {
1147         // Inspired by OraclizeAPI's implementation - MIT licence
1148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1149 
1150         if (value == 0) {
1151             return "0";
1152         }
1153         uint256 temp = value;
1154         uint256 digits;
1155         while (temp != 0) {
1156             digits++;
1157             temp /= 10;
1158         }
1159         bytes memory buffer = new bytes(digits);
1160         while (value != 0) {
1161             digits -= 1;
1162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1163             value /= 10;
1164         }
1165         return string(buffer);
1166     }
1167 
1168     /**
1169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1170      */
1171     function toHexString(uint256 value) internal pure returns (string memory) {
1172         if (value == 0) {
1173             return "0x00";
1174         }
1175         uint256 temp = value;
1176         uint256 length = 0;
1177         while (temp != 0) {
1178             length++;
1179             temp >>= 8;
1180         }
1181         return toHexString(value, length);
1182     }
1183 
1184     /**
1185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1186      */
1187     function toHexString(uint256 value, uint256 length)
1188         internal
1189         pure
1190         returns (string memory)
1191     {
1192         bytes memory buffer = new bytes(2 * length + 2);
1193         buffer[0] = "0";
1194         buffer[1] = "x";
1195         for (uint256 i = 2 * length + 1; i > 1; --i) {
1196             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1197             value >>= 4;
1198         }
1199         require(value == 0, "Strings: hex length insufficient");
1200         return string(buffer);
1201     }
1202 }
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 /**
1207  * @dev These functions deal with verification of Merkle Trees proofs.
1208  *
1209  * The proofs can be generated using the JavaScript library
1210  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1211  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1212  *
1213  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1214  */
1215 library MerkleProof {
1216     /**
1217      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1218      * defined by `root`. For this, a `proof` must be provided, containing
1219      * sibling hashes on the branch from the leaf to the root of the tree. Each
1220      * pair of leaves and each pair of pre-images are assumed to be sorted.
1221      */
1222     function verify(
1223         bytes32[] memory proof,
1224         bytes32 root,
1225         bytes32 leaf
1226     ) internal pure returns (bool) {
1227         return processProof(proof, leaf) == root;
1228     }
1229 
1230     /**
1231      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1232      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1233      * hash matches the root of the tree. When processing the proof, the pairs
1234      * of leafs & pre-images are assumed to be sorted.
1235      *
1236      * _Available since v4.4._
1237      */
1238     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1239         bytes32 computedHash = leaf;
1240         for (uint256 i = 0; i < proof.length; i++) {
1241             bytes32 proofElement = proof[i];
1242             if (computedHash <= proofElement) {
1243                 // Hash(current computed hash + current element of the proof)
1244                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1245             } else {
1246                 // Hash(current element of the proof + current computed hash)
1247                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1248             }
1249         }
1250         return computedHash;
1251     }
1252 }
1253 
1254 pragma solidity ^0.8.10;
1255 
1256 contract She is ERC721Enum, Ownable, PaymentSplitter {
1257     using Strings for uint256;
1258 
1259     uint256 public constant MAX_SUPPLY = 1164;
1260     uint256 public constant MAX_PRESALE_PER_TX = 10;
1261     uint256 public constant MAX_PRESALE_PER_WALLET = 50;
1262     uint256 public constant MAX_PUBLIC_SALE_PER_TX = 10;
1263     uint256 public constant MAX_PUBLIC_PER_WALLET = 50;
1264     uint256 public constant COST = 0.05 ether;
1265     bytes32 private merkleRoot;
1266     bool public presaleOnlyActive = true;
1267     bool public paused = true;
1268     bool public revealed = false;
1269     string baseURI;
1270     string hiddenURI;
1271     
1272     mapping(address => uint256) public whitelistAddressMintedBalance;
1273     mapping(address => uint256) public publicAddressMintedBalance;
1274 
1275     address[] private _splitterAddressList = [
1276         0x948CD796Db88b64a55f7070cBF3db77017314873, //ian
1277         0x596DC4Bb87c9D7dc4e227906b2fd6651AE2E6FD9, //fidel
1278         0xF012B5afD31d8aa22B3B97740e41731E3e30f7d8  //adam
1279     ];
1280 
1281     uint256[] private _shareList = [12, 44, 44];
1282 
1283     constructor(string memory _hiddenURI, bytes32 _merkleRoot) ERC721P("She", "SHE") PaymentSplitter(_splitterAddressList, _shareList) {
1284         setHiddenURI(_hiddenURI);
1285         merkleRoot = _merkleRoot;
1286     }
1287 
1288     modifier mintCheck(uint256 _mintAmount) {
1289         uint256 supply = totalSupply();
1290         require(_mintAmount > 0, "Mint amt must be greater than 0");
1291         require(supply + _mintAmount <= MAX_SUPPLY, "Mint amt exceeds max supply");
1292         require(msg.value >= COST * _mintAmount, "Insufficient funds");
1293         _;
1294     }
1295 
1296     //---------------- Internal ----------------
1297 
1298     function _baseURI() internal view virtual returns (string memory) {
1299         return baseURI;
1300     }
1301 
1302     function _leaf(address _account) internal pure returns (bytes32) {
1303         return keccak256(abi.encodePacked(_account));
1304     }
1305 
1306     function _verifyLeaf(bytes32 _leafNode, bytes32[] memory _proof) internal view returns (bool) {
1307         return MerkleProof.verify(_proof, merkleRoot, _leafNode);
1308     }
1309 
1310     function _doMint(address _receiver, uint256 _mintAmount) internal {
1311         uint256 supply = totalSupply();
1312         for (uint256 i = 0; i < _mintAmount; i++) {
1313             _safeMint(_receiver, supply + i);
1314         }
1315     }
1316 
1317     //---------------- Public/External ----------------
1318 
1319     function whitelistMint(uint256 _mintAmount, bytes32[] calldata proof) external payable mintCheck(_mintAmount) {
1320         require(presaleOnlyActive && !paused, "Presale is currently not active");
1321         require(_verifyLeaf(_leaf(msg.sender), proof), "Invalid proof");
1322         require(_mintAmount <= MAX_PRESALE_PER_TX, "Mint amt greater than max per tx");
1323 
1324         uint256 senderMintedCount = whitelistAddressMintedBalance[msg.sender];
1325         require(senderMintedCount + _mintAmount <= MAX_PRESALE_PER_WALLET, "Total mints after tx exceeds max mints for this address");
1326         whitelistAddressMintedBalance[msg.sender] += _mintAmount;
1327         
1328         _doMint(msg.sender, _mintAmount);
1329     }
1330 
1331     function publicMint(uint256 _mintAmount) external payable mintCheck(_mintAmount) {
1332         require(!presaleOnlyActive && !paused, "Public sale is not active");
1333         require(!Address.isContract(msg.sender), "Contract to contract minting not allowed");
1334         require(msg.sender == tx.origin, "Sender must be origin wallet");
1335         require(_mintAmount <= MAX_PUBLIC_SALE_PER_TX, "Mint amt greater than max per tx");
1336         
1337         uint256 senderMintedCount = publicAddressMintedBalance[msg.sender]; 
1338         require(senderMintedCount + _mintAmount <= MAX_PUBLIC_PER_WALLET, "Total mints after tx exceeds max mints for this address.");
1339         publicAddressMintedBalance[msg.sender] += _mintAmount;
1340 
1341         _doMint(msg.sender, _mintAmount);
1342     }
1343 
1344     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1345         uint256 ownerTokenCount = balanceOf(_owner);
1346         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1347         uint256 currentTokenId = 1;
1348         uint256 ownedTokenIndex = 0;
1349 
1350         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1351             address currentTokenOwner = ownerOf(currentTokenId);
1352             if (currentTokenOwner == _owner) {
1353                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1354                 ownedTokenIndex++;
1355             }
1356             currentTokenId++;
1357         }
1358         return ownedTokenIds;
1359     }
1360 
1361     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1362         require(_exists(_tokenId), "ERC721Metadata: TokenID does not exist.");
1363         if (revealed == false) {
1364             return hiddenURI;
1365         }
1366         string memory currentBaseURI = _baseURI();
1367         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1368     }
1369 
1370     //---------------- Only Owner ----------------
1371 
1372     function teamReserveMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1373         uint256 supply = totalSupply();
1374         require(supply + _mintAmount <= MAX_SUPPLY, "Mint amt exceeds max supply");
1375         _doMint(_receiver, _mintAmount);
1376     }
1377 
1378     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1379         baseURI = _newBaseURI;
1380     }
1381 
1382     function setHiddenURI(string memory _hiddenURI) public onlyOwner {
1383         hiddenURI = _hiddenURI;
1384     }
1385 
1386     function pause(bool _state) public onlyOwner {
1387         paused = _state;
1388     }
1389 
1390     function reveal() public onlyOwner {
1391         revealed = true;
1392     }
1393 
1394     function whitelistMintOnly(bool _state) public onlyOwner {
1395         presaleOnlyActive = _state;
1396     }
1397 
1398     function setMerkleRoot(bytes32 _root) public onlyOwner {
1399         merkleRoot = _root;
1400     }
1401 }