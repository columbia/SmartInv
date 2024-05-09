1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
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
18   function _msgSender() internal view virtual returns (address) {
19     return msg.sender;
20   }
21 
22   function _msgData() internal view virtual returns (bytes calldata) {
23     return msg.data;
24   }
25 }
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37   /**
38    * @dev Returns true if this contract implements the interface defined by
39    * `interfaceId`. See the corresponding
40    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41    * to learn more about how these ids are created.
42    *
43    * This function call must use less than 30 000 gas.
44    */
45   function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54   /**
55    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56    */
57   event Transfer(
58     address indexed from,
59     address indexed to,
60     uint256 indexed tokenId
61   );
62 
63   /**
64    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65    */
66   event Approval(
67     address indexed owner,
68     address indexed approved,
69     uint256 indexed tokenId
70   );
71 
72   /**
73    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74    */
75   event ApprovalForAll(
76     address indexed owner,
77     address indexed operator,
78     bool approved
79   );
80 
81   /**
82    * @dev Returns the number of tokens in ``owner``'s account.
83    */
84   function balanceOf(address owner) external view returns (uint256 balance);
85 
86   /**
87    * @dev Returns the owner of the `tokenId` token.
88    *
89    * Requirements:
90    *
91    * - `tokenId` must exist.
92    */
93   function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95   /**
96    * @dev Transfers `tokenId` token from `from` to `to`.
97    *
98    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99    *
100    * Requirements:
101    *
102    * - `from` cannot be the zero address.
103    * - `to` cannot be the zero address.
104    * - `tokenId` token must be owned by `from`.
105    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106    *
107    * Emits a {Transfer} event.
108    */
109   function transferFrom(
110     address from,
111     address to,
112     uint256 tokenId
113   ) external;
114 
115   /**
116    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117    * The approval is cleared when the token is transferred.
118    *
119    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120    *
121    * Requirements:
122    *
123    * - The caller must own the token or be an approved operator.
124    * - `tokenId` must exist.
125    *
126    * Emits an {Approval} event.
127    */
128   function approve(address to, uint256 tokenId) external;
129 
130   /**
131    * @dev Returns the account approved for `tokenId` token.
132    *
133    * Requirements:
134    *
135    * - `tokenId` must exist.
136    */
137   function getApproved(uint256 tokenId)
138     external
139     view
140     returns (address operator);
141 
142   /**
143    * @dev Approve or remove `operator` as an operator for the caller.
144    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145    *
146    * Requirements:
147    *
148    * - The `operator` cannot be the caller.
149    *
150    * Emits an {ApprovalForAll} event.
151    */
152   function setApprovalForAll(address operator, bool _approved) external;
153 
154   /**
155    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156    *
157    * See {setApprovalForAll}
158    */
159   function isApprovedForAll(address owner, address operator)
160     external
161     view
162     returns (bool);
163 }
164 
165 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
166 
167 /**
168  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
169  * @dev See https://eips.ethereum.org/EIPS/eip-721
170  */
171 interface IERC721Metadata is IERC721 {
172   /**
173    * @dev Returns the token collection name.
174    */
175   function name() external view returns (string memory);
176 
177   /**
178    * @dev Returns the token collection symbol.
179    */
180   function symbol() external view returns (string memory);
181 
182   /**
183    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
184    */
185   function tokenURI(uint256 tokenId) external view returns (string memory);
186 }
187 
188 // File: @openzeppelin/contracts/introspection/ERC165.sol
189 
190 /**
191  * @dev Implementation of the {IERC165} interface.
192  *
193  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
194  * for the additional interface id that will be supported. For example:
195  *
196  * ```solidity
197  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
198  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
199  * }
200  * ```
201  *
202  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
203  */
204 abstract contract ERC165 is IERC165 {
205   /**
206    * @dev See {IERC165-supportsInterface}.
207    */
208   function supportsInterface(bytes4 interfaceId)
209     public
210     view
211     virtual
212     override
213     returns (bool)
214   {
215     return interfaceId == type(IERC165).interfaceId;
216   }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Strings.sol
220 
221 /**
222  * @dev String operations.
223  */
224 library Strings {
225   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
226 
227   /**
228    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
229    */
230   function toString(uint256 value) internal pure returns (string memory) {
231     // Inspired by OraclizeAPI's implementation - MIT licence
232     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
233 
234     if (value == 0) {
235       return '0';
236     }
237     uint256 temp = value;
238     uint256 digits;
239     while (temp != 0) {
240       digits++;
241       temp /= 10;
242     }
243     bytes memory buffer = new bytes(digits);
244     while (value != 0) {
245       digits -= 1;
246       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
247       value /= 10;
248     }
249     return string(buffer);
250   }
251 
252   /**
253    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
254    */
255   function toHexString(uint256 value) internal pure returns (string memory) {
256     if (value == 0) {
257       return '0x00';
258     }
259     uint256 temp = value;
260     uint256 length = 0;
261     while (temp != 0) {
262       length++;
263       temp >>= 8;
264     }
265     return toHexString(value, length);
266   }
267 
268   /**
269    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
270    */
271   function toHexString(uint256 value, uint256 length)
272     internal
273     pure
274     returns (string memory)
275   {
276     bytes memory buffer = new bytes(2 * length + 2);
277     buffer[0] = '0';
278     buffer[1] = 'x';
279     for (uint256 i = 2 * length + 1; i > 1; --i) {
280       buffer[i] = _HEX_SYMBOLS[value & 0xf];
281       value >>= 4;
282     }
283     require(value == 0, 'Strings: ERROR');
284     return string(buffer);
285   }
286 }
287 
288 /**
289  * @dev Contract module which provides a basic access control mechanism, where
290  * there is an account (an owner) that can be granted exclusive access to
291  * specific functions.
292  *
293  * By default, the owner account will be the one that deploys the contract. This
294  * can later be changed with {transferOwnership}.
295  *
296  * This module is used through inheritance. It will make available the modifier
297  * `onlyOwner`, which can be applied to your functions to restrict their use to
298  * the owner.
299  */
300 abstract contract Ownable is Context {
301   address private _owner;
302 
303   string constant private ERR = "Ownable: ERROR";
304 
305   event OwnershipTransferred(
306     address indexed previousOwner,
307     address indexed newOwner
308   );
309 
310   /**
311    * @dev Initializes the contract setting the deployer as the initial owner.
312    */
313   constructor() {
314     _transferOwnership(_msgSender());
315   }
316 
317   /**
318    * @dev Returns the address of the current owner.
319    */
320   function owner() public view virtual returns (address) {
321     return _owner;
322   }
323 
324   /**
325    * @dev Throws if called by any account other than the owner.
326    */
327   modifier onlyOwner() {
328     require(owner() == _msgSender(), ERR);
329     _;
330   }
331 
332   /**
333    * @dev Leaves the contract without owner. It will not be possible to call
334    * `onlyOwner` functions anymore. Can only be called by the current owner.
335    *
336    * NOTE: Renouncing ownership will leave the contract without an owner,
337    * thereby removing any functionality that is only available to the owner.
338    */
339   function renounceOwnership() public virtual onlyOwner {
340     _transferOwnership(address(0));
341   }
342 
343   /**
344    * @dev Transfers ownership of the contract to a new account (`newOwner`).
345    * Can only be called by the current owner.
346    */
347   function transferOwnership(address newOwner) public virtual onlyOwner {
348     require(newOwner != address(0), ERR);
349     _transferOwnership(newOwner);
350   }
351 
352   /**
353    * @dev Transfers ownership of the contract to a new account (`newOwner`).
354    * Internal function without access restriction.
355    */
356   function _transferOwnership(address newOwner) internal virtual {
357     address oldOwner = _owner;
358     _owner = newOwner;
359     emit OwnershipTransferred(oldOwner, newOwner);
360   }
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
364 
365 /**
366  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
367  * the Metadata extension, but not including the Enumerable extension, which is available separately as
368  * {ERC721Enumerable}.
369  */
370 contract ERC721 is Context, Ownable, ERC165, IERC721, IERC721Metadata {
371   using Strings for uint256;
372 
373   string constant private ERR = "ERC721: ERROR";
374 
375   // Token name
376   string internal _name;
377 
378   // Token symbol
379   string internal _symbol;
380 
381   // Base URI
382   string private _baseURI;
383 
384   // Current owner address index
385   uint256 _ownerCounter = 0;
386 
387   // Mapping from token ID to 16 owner addresses
388   mapping(uint256 => uint256) private _owners;
389 
390   // Mapping owner address to internal owner id + balances
391   mapping(address => uint256) private _extToIntMap;
392 
393   // Mapping internal address to external address
394   mapping(uint256 => address) private _intToExtMap;
395 
396   // Mapping from token ID to approved address
397   mapping(uint256 => address) private _tokenApprovals;
398 
399   // Mapping from owner to operator approvals
400   mapping(address => mapping(address => bool)) private _operatorApprovals;
401 
402   /**
403    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
404    */
405   function _initialize(string memory name_, string memory symbol_) internal {
406     _name = name_;
407     _symbol = symbol_;
408   }
409 
410   /**
411    * @dev See {IERC165-supportsInterface}.
412    */
413   function supportsInterface(bytes4 interfaceId)
414     public
415     view
416     virtual
417     override(ERC165, IERC165)
418     returns (bool)
419   {
420     return
421       interfaceId == type(IERC721).interfaceId ||
422       interfaceId == type(IERC721Metadata).interfaceId ||
423       super.supportsInterface(interfaceId);
424   }
425 
426   /**
427    * @dev See {IERC721-balanceOf}.
428    */
429   function balanceOf(address owner)
430     public
431     view
432     virtual
433     override
434     returns (uint256)
435   {
436     require(owner != address(0), ERR);
437     return _extToIntMap[owner] >> 128;
438   }
439 
440   /**
441    * @dev See {IERC721-ownerOf}.
442    */
443   function ownerOf(uint256 tokenId)
444     public
445     view
446     virtual
447     override
448     returns (address)
449   {
450     uint256 internalOwner = _getInternalOwner(tokenId);
451     require(internalOwner != 0, ERR);
452     return _intToExtMap[internalOwner];
453   }
454 
455   /**
456    * @dev See {IERC721Metadata-name}.
457    */
458   function name() public view virtual override returns (string memory) {
459     return _name;
460   }
461 
462   /**
463    * @dev See {IERC721Metadata-symbol}.
464    */
465   function symbol() public view virtual override returns (string memory) {
466     return _symbol;
467   }
468 
469   /**
470    * @dev See {IERC721Metadata-tokenURI}.
471    */
472   function tokenURI(uint256 tokenId)
473     public
474     view
475     virtual
476     override
477     returns (string memory)
478   {
479     require(_getInternalOwner(tokenId) != 0, ERR);
480 
481     bytes memory bytesURI = bytes(_baseURI);
482     if (bytesURI.length == 0 || bytesURI[bytesURI.length - 1] == '/')
483       return string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
484     else return _baseURI;
485   }
486 
487   function setBaseURI(string memory newBaseURI) external onlyOwner {
488     _baseURI = newBaseURI;
489   }
490 
491   /**
492    * @dev See {IERC721-approve}.
493    */
494   function approve(address to, uint256 tokenId) public virtual override {
495     address owner = ERC721.ownerOf(tokenId);
496     require(to != owner, ERR);
497 
498     require(
499       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
500       ERR
501     );
502     _approve(to, tokenId);
503   }
504 
505   /**
506    * @dev See {IERC721-getApproved}.
507    */
508   function getApproved(uint256 tokenId)
509     public
510     view
511     virtual
512     override
513     returns (address)
514   {
515     require(_getInternalOwner(tokenId) != 0, ERR);
516 
517     return _tokenApprovals[tokenId];
518   }
519 
520   /**
521    * @dev See {IERC721-setApprovalForAll}.
522    */
523   function setApprovalForAll(address operator, bool approved)
524     public
525     virtual
526     override
527   {
528     _setApprovalForAll(_msgSender(), operator, approved);
529   }
530 
531   /**
532    * @dev See {IERC721-isApprovedForAll}.
533    */
534   function isApprovedForAll(address owner, address operator)
535     public
536     view
537     virtual
538     override
539     returns (bool)
540   {
541     return _operatorApprovals[owner][operator];
542   }
543 
544   /**
545    * @dev See {IERC721-transferFrom}.
546    */
547   function transferFrom(
548     address from,
549     address to,
550     uint256 tokenId
551   ) public virtual override {
552     //solhint-disable-next-line max-line-length
553     require(
554       _isApprovedOrOwner(_msgSender(), tokenId),
555       ERR
556     );
557 
558     _transfer(from, to, tokenId);
559   }
560 
561   /**
562    * @dev Returns whether `spender` is allowed to manage `tokenId`.
563    *
564    * Requirements:
565    *
566    * - `tokenId` must exist.
567    */
568   function _isApprovedOrOwner(address spender, uint256 tokenId)
569     internal
570     view
571     virtual
572     returns (bool)
573   {
574     require(_getInternalOwner(tokenId) != 0, ERR);
575     address owner = ERC721.ownerOf(tokenId);
576     return (spender == owner ||
577       getApproved(tokenId) == spender ||
578       isApprovedForAll(owner, spender));
579   }
580 
581   /**
582    * @dev Mints `tokenId` and transfers it to `to`.
583    *
584    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
585    *
586    * Requirements:
587    *
588    * - `tokenId` must not exist.
589    * - `to` cannot be the zero address.
590    *
591    * Emits a {Transfer} event.
592    */
593   function _mint(address to, uint256 tokenId, uint256 num) internal virtual {
594     require(to != address(0), ERR);
595 
596     uint256 toInt = _getInternalOwnerFromAddress(to);
597     uint256 tokenIdEnd = tokenId + num;
598     uint256 curBase = tokenId >> 4;
599     uint256 mask = _owners[curBase];
600 
601     for (; tokenId < tokenIdEnd; ++tokenId) {
602       // Update storage balance of previous bin
603       uint256 base = tokenId >> 4;
604       uint256 idBits = (tokenId & 0xF) << 4;
605       if (base != curBase) {
606         _owners[curBase] = mask;
607         curBase = base;
608         mask = _owners[curBase];
609       }
610       require(((mask >> idBits) & 0xFFFF) == 0, ERR);
611       mask |= (toInt << idBits);
612 
613       emit Transfer(address(0), to, tokenId);
614     }
615     _owners[curBase] = mask;
616     _extToIntMap[to] += num << 128;
617   }
618 
619   /**
620    * @dev Destroys `tokenId`.
621    * The approval is cleared when the token is burned.
622    *
623    * Requirements:
624    *
625    * - `tokenId` must exist.
626    *
627    * Emits a {Transfer} event.
628    */
629   function _burn(uint256 tokenId) internal virtual {
630     // Clear approvals
631     _approve(address(0), tokenId);
632     
633     uint256 intOwner = _getInternalOwner(tokenId);
634     require(intOwner != 0, ERR);
635     _setInternalOwner(tokenId, 0);
636 
637     address owner = _intToExtMap[intOwner];
638     _extToIntMap[owner] -= 1 << 128;
639 
640     emit Transfer(owner, address(0), tokenId);
641   }
642 
643   /**
644    * @dev Transfers `tokenId` from `from` to `to`.
645    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
646    *
647    * Requirements:
648    *
649    * - `to` cannot be the zero address.
650    * - `tokenId` token must be owned by `from`.
651    *
652    * Emits a {Transfer} event.
653    */
654   function _transfer(
655     address from,
656     address to,
657     uint256 tokenId
658   ) internal virtual {
659     uint256 intOwner = _getInternalOwner(tokenId);
660     require(
661       _intToExtMap[intOwner] == from,
662       ERR
663     );
664     require(to != address(0), ERR);
665 
666     // Clear approvals from the previous owner
667     _approve(address(0), tokenId);
668     
669     uint256 toInt = _getInternalOwnerFromAddress(to);
670     _setInternalOwner(tokenId, toInt);
671 
672     _extToIntMap[from] -= 1 << 128;
673     _extToIntMap[to] += 1 << 128;
674 
675     emit Transfer(from, to, tokenId);
676   }
677 
678   /**
679    * @dev Approve `to` to operate on `tokenId`
680    *
681    * Emits a {Approval} event.
682    */
683   function _approve(address to, uint256 tokenId) internal virtual {
684     _tokenApprovals[tokenId] = to;
685     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
686   }
687 
688   /**
689    * @dev Approve `operator` to operate on all of `owner` tokens
690    *
691    * Emits a {ApprovalForAll} event.
692    */
693   function _setApprovalForAll(
694     address owner,
695     address operator,
696     bool approved
697   ) internal virtual {
698     require(owner != operator, ERR);
699     _operatorApprovals[owner][operator] = approved;
700     emit ApprovalForAll(owner, operator, approved);
701   }
702 
703   function _getInternalOwner(uint256 tokenId) internal view returns(uint256) {
704     return (_owners[tokenId >> 4] >> ((tokenId & 0xF) << 4)) & 0xFFFF;
705   }
706 
707   function _getInternalOwnerFromAddress(address externalOwner) internal returns(uint256) {
708     uint256 intOwner = _extToIntMap[externalOwner];
709     if (intOwner == 0) {
710       require(_ownerCounter < 0xFFFF, ERR);
711       _extToIntMap[externalOwner] = intOwner = ++_ownerCounter;
712       _intToExtMap[intOwner] = externalOwner;
713     }
714     return uint256(uint128(intOwner));
715   }
716 
717   function _setInternalOwner(uint256 tokenId, uint256 newOwner) internal {
718     uint256 mask = _owners[tokenId >> 4] &~ (0xFFFF << ((tokenId & 0xF) << 4));
719     _owners[tokenId >> 4] = mask | newOwner << ((tokenId & 0xF) << 4);
720   }
721 }
722 
723 /**
724  * @dev OpenSea proxy registry to prevent gas spend for approvals
725  */
726 contract ProxyRegistry {
727   mapping(address => address) public proxies;
728 }
729 
730 /**
731  * @dev Contract module that helps prevent reentrant calls to a function.
732  *
733  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
734  * available, which can be applied to functions to make sure there are no nested
735  * (reentrant) calls to them.
736  *
737  * Note that because there is a single `nonReentrant` guard, functions marked as
738  * `nonReentrant` may not call one another. This can be worked around by making
739  * those functions `private`, and then adding `external` `nonReentrant` entry
740  * points to them.
741  *
742  * TIP: If you would like to learn more about reentrancy and alternative ways
743  * to protect against it, check out our blog post
744  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
745  */
746 abstract contract ReentrancyGuard {
747   // Booleans are more expensive than uint256 or any type that takes up a full
748   // word because each write operation emits an extra SLOAD to first read the
749   // slot's contents, replace the bits taken up by the boolean, and then write
750   // back. This is the compiler's defense against contract upgrades and
751   // pointer aliasing, and it cannot be disabled.
752 
753   // The values being non-zero value makes deployment a bit more expensive,
754   // but in exchange the refund on every call to nonReentrant will be lower in
755   // amount. Since refunds are capped to a percentage of the total
756   // transaction's gas, it is best to keep them low in cases like this one, to
757   // increase the likelihood of the full refund coming into effect.
758   uint256 private constant _NOT_ENTERED = 1;
759   uint256 private constant _ENTERED = 2;
760 
761   uint256 private _status;
762 
763   constructor() {
764     _status = _NOT_ENTERED;
765   }
766 
767   /**
768    * @dev Prevents a contract from calling itself, directly or indirectly.
769    * Calling a `nonReentrant` function from another `nonReentrant`
770    * function is not supported. It is possible to prevent this from happening
771    * by making the `nonReentrant` function external, and making it call a
772    * `private` function that does the actual work.
773    */
774   modifier nonReentrant() {
775     // On the first call to nonReentrant, _notEntered will be true
776     require(_status != _ENTERED, 'ReentrancyGuard: ERROR');
777 
778     // Any calls to nonReentrant after this point will fail
779     _status = _ENTERED;
780 
781     _;
782 
783     // By storing the original value once again, a refund is triggered (see
784     // https://eips.ethereum.org/EIPS/eip-2200)
785     _status = _NOT_ENTERED;
786   }
787 }
788 
789 /**
790  * @dev Implementation of Opt ERC721 contract
791  */
792 contract ERC721Opt is ERC721, ReentrancyGuard {
793 
794   string private constant ERR = "ERC721Base: Error";
795 
796   // OpenSea proxy registry
797   address private immutable _osProxyRegistryAddress;
798   // Address allowed to initialize contract
799   address private immutable _initializer;
800 
801   // Max mints per transaction
802   uint256 private _maxTxMint;
803 
804   // The CAP of mintable tokenIds
805   uint256 private _cap;
806 
807   // The CAP of free mintable tokenIds
808   uint256 private _freeCap;
809 
810   // ETH price of one tokenIds
811   uint256 private _tokenPrice;
812 
813   // TokenId counter, 1 minted in ctor
814   uint256 private _currentTokenId;
815 
816   // Advertise mints
817   uint256 private _advertised;
818 
819   // Fired when funds are distributed
820   event Withdraw(address indexed receiver, uint256 amount);
821 
822   /**
823    * @dev Initialization.
824    */
825   constructor(address initializer_, address osProxyRegistry_) {
826     _osProxyRegistryAddress = osProxyRegistry_;
827     _initializer = initializer_;
828   }
829 
830   /**
831    * @dev Clone Initialization.
832    */
833   function initialize(
834     address owner_,
835     string memory name_,
836     string memory symbol_,
837     uint256 cap_,
838     uint256 freeCap_,
839     uint256 maxPerTx_,
840     uint256 price_) external
841   {
842     require(msg.sender == _initializer, ERR);
843 
844     _transferOwnership(owner_);
845 
846     ERC721._initialize(name_, symbol_);
847     _cap = cap_;
848     _freeCap = freeCap_ + 1;
849     _maxTxMint = maxPerTx_;
850     _tokenPrice = price_;
851     _currentTokenId = 1;
852 
853     emit Transfer(address(0), address(0), 0);
854   }
855 
856   /**
857    * @dev See {IERC721-isApprovedForAll}.
858    */
859   function isApprovedForAll(address owner, address operator)
860     public
861     view
862     virtual
863     override
864     returns (bool)
865   {
866     // Whitelist OpenSea proxy contract for easy trading.
867     ProxyRegistry proxyRegistry = ProxyRegistry(_osProxyRegistryAddress);
868     if (address(proxyRegistry.proxies(owner)) == operator) {
869       return true;
870     }
871     return super.isApprovedForAll(owner, operator);
872   }
873 
874   /**
875    * @dev mint
876    */
877   function mint(address to, uint256 numMint) external payable nonReentrant {
878     uint256 tidEnd = _currentTokenId + numMint;
879     
880     uint numPayMint = tidEnd > _freeCap ? tidEnd - _freeCap : 0;
881     if (numPayMint > numMint) numPayMint = numMint;
882 
883     require(numMint > 0 &&
884       numMint <= _maxTxMint &&
885       tidEnd <= _cap - _advertised &&
886       msg.value >= numPayMint * _tokenPrice, ERR
887     );
888 
889     _mint(to, _currentTokenId, numMint);
890     _currentTokenId += numMint;
891 
892     {
893       uint256 dust = msg.value - (numPayMint * _tokenPrice);
894       if (dust > 0) payable(msg.sender).transfer(dust);
895     }
896   }
897 
898   /**
899    * @dev advertise
900    */
901   function advertise(address[] memory to, uint256[] memory numMints) external onlyOwner {
902     require(to.length == numMints.length, ERR);
903 
904     uint256 curTokenId = _cap;
905     uint256 maxAdvertised = _advertised;
906     for (uint256 i=0; i < to.length; ++i) {
907       for (uint256 j = 0; j < numMints[i]; ++j) {
908         emit Transfer(address(0), to[i], curTokenId - j);
909       }
910       if (numMints[i] > maxAdvertised) maxAdvertised = numMints[i];
911     }
912     if (maxAdvertised > _advertised) _advertised = maxAdvertised;
913   }
914 
915   /**
916    * @dev Withdraw rewards
917    */
918   function withdraw(address account) external onlyOwner {
919     uint256 amount = address(this).balance;
920     payable(account).transfer(amount);
921     emit Withdraw(account, amount);
922   }
923 
924   /**
925    * @dev return number of minted token
926    */
927   function totalSupply() external view returns (uint256) {
928     return _currentTokenId;
929   }
930 
931   /**
932    * @dev return number of remaining free token
933    */
934   function freeMintLeft() external view returns (uint256) {
935     return _currentTokenId < _freeCap ? _freeCap - _currentTokenId : 0;
936   }
937 
938   /**
939    * @dev Set free mintable token cap
940    */
941   function setFreeTokenCap(uint256 newCap) external onlyOwner {
942     _freeCap = newCap + 1;
943   }
944 
945   /**
946    * @dev Set token price
947    */
948   function setTokenPrice(uint256 newPrice) external onlyOwner {
949     _tokenPrice = newPrice;
950   }
951 
952   /**
953    * @dev we don't allow ether receive()
954    */
955   receive() external payable {
956     revert(ERR);
957   }
958 }