1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and making it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
262  * @dev See https://eips.ethereum.org/EIPS/eip-721
263  */
264 interface IERC721Metadata is IERC721 {
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 
281 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
287  * @dev See https://eips.ethereum.org/EIPS/eip-721
288  */
289 interface IERC721Enumerable is IERC721 {
290     /**
291      * @dev Returns the total amount of tokens stored by the contract.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
297      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
298      */
299     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
300 
301     /**
302      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
303      * Use along with {totalSupply} to enumerate all tokens.
304      */
305     function tokenByIndex(uint256 index) external view returns (uint256);
306 }
307 
308 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Implementation of the {IERC165} interface.
341  *
342  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
343  * for the additional interface id that will be supported. For example:
344  *
345  * ```solidity
346  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
347  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
348  * }
349  * ```
350  *
351  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
352  */
353 abstract contract ERC165 is IERC165 {
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358         return interfaceId == type(IERC165).interfaceId;
359     }
360 }
361 
362 pragma solidity ^0.8.6;
363 
364 library Address {
365     function isContract(address account) internal view returns (bool) {
366         uint size;
367         assembly {
368             size := extcodesize(account)
369         }
370         return size > 0;
371     }
372 }
373 
374 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev String operations.
380  */
381 library Strings {
382     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
386      */
387     function toString(uint256 value) internal pure returns (string memory) {
388         // Inspired by OraclizeAPI's implementation - MIT licence
389         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
390 
391         if (value == 0) {
392             return "0";
393         }
394         uint256 temp = value;
395         uint256 digits;
396         while (temp != 0) {
397             digits++;
398             temp /= 10;
399         }
400         bytes memory buffer = new bytes(digits);
401         while (value != 0) {
402             digits -= 1;
403             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
404             value /= 10;
405         }
406         return string(buffer);
407     }
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
411      */
412     function toHexString(uint256 value) internal pure returns (string memory) {
413         if (value == 0) {
414             return "0x00";
415         }
416         uint256 temp = value;
417         uint256 length = 0;
418         while (temp != 0) {
419             length++;
420             temp >>= 8;
421         }
422         return toHexString(value, length);
423     }
424 
425     /**
426      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
427      */
428     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
429         bytes memory buffer = new bytes(2 * length + 2);
430         buffer[0] = "0";
431         buffer[1] = "x";
432         for (uint256 i = 2 * length + 1; i > 1; --i) {
433             buffer[i] = _HEX_SYMBOLS[value & 0xf];
434             value >>= 4;
435         }
436         require(value == 0, "Strings: hex length insufficient");
437         return string(buffer);
438     }
439 }
440 
441 pragma solidity ^0.8.13;
442 
443 interface IOperatorFilterRegistry {
444     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
445     function register(address registrant) external;
446     function registerAndSubscribe(address registrant, address subscription) external;
447     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
448     function unregister(address addr) external;
449     function updateOperator(address registrant, address operator, bool filtered) external;
450     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
451     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
452     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
453     function subscribe(address registrant, address registrantToSubscribe) external;
454     function unsubscribe(address registrant, bool copyExistingEntries) external;
455     function subscriptionOf(address addr) external returns (address registrant);
456     function subscribers(address registrant) external returns (address[] memory);
457     function subscriberAt(address registrant, uint256 index) external returns (address);
458     function copyEntriesOf(address registrant, address registrantToCopy) external;
459     function isOperatorFiltered(address registrant, address operator) external returns (bool);
460     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
461     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
462     function filteredOperators(address addr) external returns (address[] memory);
463     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
464     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
465     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
466     function isRegistered(address addr) external returns (bool);
467     function codeHashOf(address addr) external returns (bytes32);
468 }
469 
470 /**
471  * @title  OperatorFilterer
472  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
473  *         registrant's entries in the OperatorFilterRegistry.
474  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
475  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
476  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
477  */
478 abstract contract OperatorFilterer {
479     error OperatorNotAllowed(address operator);
480 
481     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
482         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
483 
484     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
485         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
486         // will not revert, but the contract will need to be registered with the registry once it is deployed in
487         // order for the modifier to filter addresses.
488         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
489             if (subscribe) {
490                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
491             } else {
492                 if (subscriptionOrRegistrantToCopy != address(0)) {
493                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
494                 } else {
495                     OPERATOR_FILTER_REGISTRY.register(address(this));
496                 }
497             }
498         }
499     }
500 
501     modifier onlyAllowedOperator(address from) virtual {
502         // Allow spending tokens from addresses with balance
503         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
504         // from an EOA.
505         if (from != msg.sender) {
506             _checkFilterOperator(msg.sender);
507         }
508         _;
509     }
510 
511     modifier onlyAllowedOperatorApproval(address operator) virtual {
512         _checkFilterOperator(operator);
513         _;
514     }
515 
516     function _checkFilterOperator(address operator) internal view virtual {
517         // Check registry code length to facilitate testing in environments without a deployed registry.
518         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
519             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
520                 revert OperatorNotAllowed(operator);
521             }
522         }
523     }
524 }
525 
526 /**
527  * @title  DefaultOperatorFilterer
528  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
529  */
530 abstract contract DefaultOperatorFilterer is OperatorFilterer {
531     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
532 
533     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
534 }
535 
536 pragma solidity ^0.8.7;
537 
538 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
539     using Address for address;
540     using Strings for uint256;
541     
542     string private _name;
543     string private _symbol;
544 
545     // Mapping from token ID to owner address
546     address[] internal _owners;
547 
548     mapping(uint256 => address) private _tokenApprovals;
549     mapping(address => mapping(address => bool)) private _operatorApprovals;
550 
551     /**
552      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
553      */
554     constructor(string memory name_, string memory symbol_) {
555         _name = name_;
556         _symbol = symbol_;
557     }
558 
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId)
563         public
564         view
565         virtual
566         override(ERC165, IERC165)
567         returns (bool)
568     {
569         return
570             interfaceId == type(IERC721).interfaceId ||
571             interfaceId == type(IERC721Metadata).interfaceId ||
572             super.supportsInterface(interfaceId);
573     }
574 
575     /**
576      * @dev See {IERC721-balanceOf}.
577      */
578     function balanceOf(address owner) 
579         public 
580         view 
581         virtual 
582         override 
583         returns (uint) 
584     {
585         require(owner != address(0), "ERC721: balance query for the zero address");
586 
587         uint count;
588         for( uint i; i < _owners.length; ++i ){
589           if( owner == _owners[i] )
590             ++count;
591         }
592         return count;
593     }
594 
595     /**
596      * @dev See {IERC721-ownerOf}.
597      */
598     function ownerOf(uint256 tokenId)
599         public
600         view
601         virtual
602         override
603         returns (address)
604     {
605         address owner = _owners[tokenId];
606         require(
607             owner != address(0),
608             "ERC721: owner query for nonexistent token"
609         );
610         return owner;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-name}.
615      */
616     function name() public view virtual override returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-symbol}.
622      */
623     function symbol() public view virtual override returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @dev See {IERC721-approve}.
629      */
630     function approve(address to, uint256 tokenId) public virtual override(IERC721) onlyAllowedOperatorApproval(to) {
631         address owner = ERC721.ownerOf(tokenId);
632         require(to != owner, "ERC721: approval to current owner");
633 
634         require(
635             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
636             "ERC721: approve caller is not owner nor approved for all"
637         );
638 
639         _approve(to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-getApproved}.
644      */
645     function getApproved(uint256 tokenId)
646         public
647         view
648         virtual
649         override
650         returns (address)
651     {
652         require(
653             _exists(tokenId),
654             "ERC721: approved query for nonexistent token"
655         );
656 
657         return _tokenApprovals[tokenId];
658     }
659 
660     /**
661      * @dev See {IERC721-setApprovalForAll}.
662      */
663     function setApprovalForAll(address operator, bool approved)
664         public
665         virtual
666         override(IERC721)
667         onlyAllowedOperatorApproval(operator)
668     {
669         require(operator != _msgSender(), "ERC721: approve to caller");
670 
671         _operatorApprovals[_msgSender()][operator] = approved;
672         emit ApprovalForAll(_msgSender(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC721-isApprovedForAll}.
677      */
678     function isApprovedForAll(address owner, address operator)
679         public
680         view
681         virtual
682         override
683         returns (bool)
684     {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-transferFrom}.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override(IERC721) onlyAllowedOperator(from) {
696         //solhint-disable-next-line max-line-length
697         require(
698             _isApprovedOrOwner(_msgSender(), tokenId),
699             "ERC721: transfer caller is not owner nor approved"
700         );
701 
702         _transfer(from, to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) public virtual override(IERC721) onlyAllowedOperator(from) {
713         safeTransferFrom(from, to, tokenId, "");
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId,
723         bytes memory _data
724     ) public virtual override(IERC721) onlyAllowedOperator(from) {
725         require(
726             _isApprovedOrOwner(_msgSender(), tokenId),
727             "ERC721: transfer caller is not owner nor approved"
728         );
729         _safeTransfer(from, to, tokenId, _data);
730     }
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
737      *
738      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
739      * implement alternative mechanisms to perform token transfer, such as signature-based.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function _safeTransfer(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) internal virtual {
756         _transfer(from, to, tokenId);
757         require(
758             _checkOnERC721Received(from, to, tokenId, _data),
759             "ERC721: transfer to non ERC721Receiver implementer"
760         );
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      * and stop existing when they are burned (`_burn`).
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return tokenId < _owners.length && _owners[tokenId] != address(0);
773     }
774 
775     /**
776      * @dev Returns whether `spender` is allowed to manage `tokenId`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function _isApprovedOrOwner(address spender, uint256 tokenId)
783         internal
784         view
785         virtual
786         returns (bool)
787     {
788         require(
789             _exists(tokenId),
790             "ERC721: operator query for nonexistent token"
791         );
792         address owner = ERC721.ownerOf(tokenId);
793         return (spender == owner ||
794             getApproved(tokenId) == spender ||
795             isApprovedForAll(owner, spender));
796     }
797 
798     /**
799      * @dev Safely mints `tokenId` and transfers it to `to`.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must not exist.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeMint(address to, uint256 tokenId) internal virtual {
809         _safeMint(to, tokenId, "");
810     }
811 
812     /**
813      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
814      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
815      */
816     function _safeMint(
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _mint(to, tokenId);
822         require(
823             _checkOnERC721Received(address(0), to, tokenId, _data),
824             "ERC721: transfer to non ERC721Receiver implementer"
825         );
826     }
827 
828     /**
829      * @dev Mints `tokenId` and transfers it to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - `to` cannot be the zero address.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _mint(address to, uint256 tokenId) internal virtual {
841         require(to != address(0), "ERC721: mint to the zero address");
842         require(!_exists(tokenId), "ERC721: token already minted");
843 
844         _beforeTokenTransfer(address(0), to, tokenId);
845         _owners.push(to);
846 
847         emit Transfer(address(0), to, tokenId);
848     }
849 
850     /**
851      * @dev Destroys `tokenId`.
852      * The approval is cleared when the token is burned.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _burn(uint256 tokenId) internal virtual {
861         address owner = ERC721.ownerOf(tokenId);
862 
863         _beforeTokenTransfer(owner, address(0), tokenId);
864 
865         // Clear approvals
866         _approve(address(0), tokenId);
867         _owners[tokenId] = address(0);
868 
869         emit Transfer(owner, address(0), tokenId);
870     }
871 
872     /**
873      * @dev Transfers `tokenId` from `from` to `to`.
874      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must be owned by `from`.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _transfer(
884         address from,
885         address to,
886         uint256 tokenId
887     ) internal virtual {
888         require(
889             ERC721.ownerOf(tokenId) == from,
890             "ERC721: transfer of token that is not own"
891         );
892         require(to != address(0), "ERC721: transfer to the zero address");
893 
894         _beforeTokenTransfer(from, to, tokenId);
895 
896         // Clear approvals from the previous owner
897         _approve(address(0), tokenId);
898         _owners[tokenId] = to;
899 
900         emit Transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev Approve `to` to operate on `tokenId`
905      *
906      * Emits a {Approval} event.
907      */
908     function _approve(address to, uint256 tokenId) internal virtual {
909         _tokenApprovals[tokenId] = to;
910         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
911     }
912 
913     /**
914      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
915      * The call is not executed if the target address is not a contract.
916      *
917      * @param from address representing the previous owner of the given token ID
918      * @param to target address that will receive the tokens
919      * @param tokenId uint256 ID of the token to be transferred
920      * @param _data bytes optional data to send along with the call
921      * @return bool whether the call correctly returned the expected magic value
922      */
923     function _checkOnERC721Received(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) private returns (bool) {
929         if (to.isContract()) {
930             try
931                 IERC721Receiver(to).onERC721Received(
932                     _msgSender(),
933                     from,
934                     tokenId,
935                     _data
936                 )
937             returns (bytes4 retval) {
938                 return retval == IERC721Receiver.onERC721Received.selector;
939             } catch (bytes memory reason) {
940                 if (reason.length == 0) {
941                     revert(
942                         "ERC721: transfer to non ERC721Receiver implementer"
943                     );
944                 } else {
945                     assembly {
946                         revert(add(32, reason), mload(reason))
947                     }
948                 }
949             }
950         } else {
951             return true;
952         }
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This includes minting
957      * and burning.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, ``from``'s `tokenId` will be burned.
965      * - `from` and `to` are never both zero.
966      *
967      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
968      */
969     function _beforeTokenTransfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {}
974 }
975 
976 pragma solidity ^0.8.7;
977 
978 /**
979  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
980  * enumerability of all the token ids in the contract as well as all token ids owned by each
981  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
982  */
983 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
984     /**
985      * @dev See {IERC165-supportsInterface}.
986      */
987     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
988         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-totalSupply}.
993      */
994     function totalSupply() public view virtual override returns (uint256) {
995         return _owners.length;
996     }
997 
998     /**
999      * @dev See {IERC721Enumerable-tokenByIndex}.
1000      */
1001     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1002         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1003         return index;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1010         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1011 
1012         uint count;
1013         for(uint i; i < _owners.length; i++){
1014             if(owner == _owners[i]){
1015                 if(count == index) return i;
1016                 else count++;
1017             }
1018         }
1019 
1020         revert("ERC721Enumerable: owner index out of bounds");
1021     }
1022 }
1023 
1024 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 /**
1029  * @dev Contract module which provides a basic access control mechanism, where
1030  * there is an account (an owner) that can be granted exclusive access to
1031  * specific functions.
1032  *
1033  * By default, the owner account will be the one that deploys the contract. This
1034  * can later be changed with {transferOwnership}.
1035  *
1036  * This module is used through inheritance. It will make available the modifier
1037  * `onlyOwner`, which can be applied to your functions to restrict their use to
1038  * the owner.
1039  */
1040 abstract contract Ownable is Context {
1041     address private _owner;
1042 
1043     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1044 
1045     /**
1046      * @dev Initializes the contract setting the deployer as the initial owner.
1047      */
1048     constructor() {
1049         _transferOwnership(_msgSender());
1050     }
1051 
1052     /**
1053      * @dev Returns the address of the current owner.
1054      */
1055     function owner() public view virtual returns (address) {
1056         return _owner;
1057     }
1058 
1059     /**
1060      * @dev Throws if called by any account other than the owner.
1061      */
1062     modifier onlyOwner() {
1063         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1064         _;
1065     }
1066 
1067     /**
1068      * @dev Leaves the contract without owner. It will not be possible to call
1069      * `onlyOwner` functions anymore. Can only be called by the current owner.
1070      *
1071      * NOTE: Renouncing ownership will leave the contract without an owner,
1072      * thereby removing any functionality that is only available to the owner.
1073      */
1074     function renounceOwnership() public virtual onlyOwner {
1075         _transferOwnership(address(0));
1076     }
1077 
1078     /**
1079      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1080      * Can only be called by the current owner.
1081      */
1082     function transferOwnership(address newOwner) public virtual onlyOwner {
1083         require(newOwner != address(0), "Ownable: new owner is the zero address");
1084         _transferOwnership(newOwner);
1085     }
1086 
1087     /**
1088      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1089      * Internal function without access restriction.
1090      */
1091     function _transferOwnership(address newOwner) internal virtual {
1092         address oldOwner = _owner;
1093         _owner = newOwner;
1094         emit OwnershipTransferred(oldOwner, newOwner);
1095     }
1096 }
1097 
1098 pragma solidity ^0.8.11;
1099 pragma abicoder v2;
1100 
1101 contract HAHAPEWPEW is ERC721Enumerable, Ownable, ReentrancyGuard {
1102   bool                                            public          pewPewReady = false;
1103   bool                                            public          prePewPewReady = false;
1104   string                                          public          baseURI;
1105   uint                                            public constant MAX_PEW_PEW = 2;
1106   uint                                            public constant MAX_PROJECT_PEW_PEW = 10;
1107   uint256                                         public constant HAHA_PEW_PEW = 6666;
1108   mapping(address => uint256)                     public          constructedPewPew;
1109   mapping(address => uint256)                     public          projectPewPews;
1110   mapping(address => mapping(uint256 => uint))    public          projectConstructedPewPew;
1111   address[]                                       public          availableProjectPewPews;
1112     
1113   constructor() ERC721("HAHAPEWPEW", "HAHAPEWPEW") {
1114     setBaseURI("ipfs://QmZgXPYQ9ZY6SxyDxTXQHLVrmP1xzSkpw1jauAcRkFfLsY/");
1115     // Luminal Genesis
1116     projectPewPews[address(0x8BAc4bd59dc49E46ee1972dFAf0c5e039b88552D)] = 2;
1117     availableProjectPewPews.push(address(0x8BAc4bd59dc49E46ee1972dFAf0c5e039b88552D));
1118 
1119     // Luminal Avatars
1120     projectPewPews[address(0x8e07dCEA5c57e2b0b71f7BBf514A3cc5bAb2E96e)] = 1;
1121     availableProjectPewPews.push(address(0x8e07dCEA5c57e2b0b71f7BBf514A3cc5bAb2E96e));
1122 
1123     // Funkari
1124     projectPewPews[address(0x1faFd33D882e1C275C61066019a23c1999B5006e)] = 1;
1125     availableProjectPewPews.push(address(0x1faFd33D882e1C275C61066019a23c1999B5006e));
1126 
1127     _mint(msg.sender, totalSupply());
1128   }
1129     
1130   function withdraw() public onlyOwner {
1131     uint256 balance = address(this).balance;
1132     require(balance > 0);
1133 
1134     (bool ownerSuccess, ) = msg.sender.call{value: address(this).balance}("");
1135     require(ownerSuccess, "PEW PEW ZOINK!");
1136   }
1137 
1138   function setBaseURI(string memory _baseURI) public onlyOwner {
1139     baseURI = _baseURI;
1140   }
1141 
1142   function happyPewPew() public onlyOwner {
1143     pewPewReady = !pewPewReady;
1144   }
1145 
1146   function preHappyPewPew() public onlyOwner {
1147     prePewPewReady = !prePewPewReady;
1148   }
1149 
1150   function addMoreProjectPewPew(uint256 amount, address projectPewPew) external onlyOwner {
1151     projectPewPews[projectPewPew] = amount;
1152     availableProjectPewPews.push(projectPewPew);
1153   }
1154   
1155   function constructManyProjectPewPew(address projectOwned, uint256[] calldata ownedTokenIds, uint pewPews) public payable nonReentrant {
1156     uint supply = totalSupply();
1157     uint availablePewPew;
1158     int pewPewTracker = int(pewPews);
1159     bool walletLimit = true;
1160     uint projectPewPewLimit = projectPewPews[projectOwned];
1161     for (uint i = 0; i < 3; i ++) {
1162       if (projectOwned == availableProjectPewPews[i]) {
1163         walletLimit = false;
1164         break;
1165       }
1166     }
1167     if (walletLimit == true) {
1168       require(pewPews <= MAX_PROJECT_PEW_PEW, "TOO MANY! ZOINK ZOINK");
1169       require(constructedPewPew[msg.sender] + pewPews <= MAX_PROJECT_PEW_PEW, "ZOINKS! CAPPED!");
1170     }
1171     require(prePewPewReady, "PEW PEW! ZOINK!");
1172     for (uint i = 0; i < ownedTokenIds.length; i ++) {
1173       require(IERC721(projectOwned).ownerOf(ownedTokenIds[i]) == msg.sender, "ZOINK! OWNZZZRPT!");
1174       availablePewPew += projectPewPewLimit - projectConstructedPewPew[projectOwned][ownedTokenIds[i]];
1175     }
1176     require(availablePewPew - pewPews >= 0, "ZOINKS! CAPPED!");
1177     require(supply + pewPews <= HAHA_PEW_PEW, "ZOINKS! OVERLOADED!");
1178     
1179     for (uint i = 0; i < ownedTokenIds.length; i ++) {
1180       require(projectPewPewLimit != projectConstructedPewPew[projectOwned][ownedTokenIds[i]], "ZOINK! MAXXED OUT!");
1181       if (pewPewTracker > 0) {
1182         int diff = int(projectPewPewLimit) - int(projectConstructedPewPew[projectOwned][ownedTokenIds[i]]);
1183         if (pewPewTracker - diff > 0) {
1184           projectConstructedPewPew[projectOwned][ownedTokenIds[i]] += uint(diff);
1185           pewPewTracker -= diff;
1186         } else {
1187           projectConstructedPewPew[projectOwned][ownedTokenIds[i]] += uint(pewPewTracker);
1188           pewPewTracker = 0;
1189           break;
1190         }
1191       }
1192     }
1193 
1194     constructedPewPew[msg.sender] += pewPews;
1195     for(uint i = 0; i < pewPews; i++) {
1196       _mint(msg.sender, supply + i);
1197     }
1198   }
1199 
1200   function constructPewPew(uint pewPews) public payable nonReentrant {
1201     uint supply = totalSupply();
1202     require(pewPewReady, "PEW PEW! ZOINK!");
1203     require(pewPews <= MAX_PEW_PEW, "ZOINKS! ZZZRPT!");
1204     require(constructedPewPew[msg.sender] + pewPews <= MAX_PEW_PEW, "ZOINKS! CAPPED!");
1205     require(supply + pewPews <= HAHA_PEW_PEW, "ZOINKS! OVERLOADED!");
1206     
1207     constructedPewPew[msg.sender] += pewPews;
1208     for(uint i = 0; i < pewPews; i++) {
1209       _mint(msg.sender, supply + i);
1210     }
1211   }
1212 
1213   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1214     require(_exists(_tokenId), "ZOINKS! NOT CONSTRUCTED");
1215     return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1216   }
1217 
1218   function airdrop(address _to, uint256 _numberOfTokens) external onlyOwner {
1219     uint256 supply = totalSupply();
1220     require(supply + _numberOfTokens <= HAHA_PEW_PEW, "ZOINKS! TOO MANY PEW PEW");
1221     for (uint256 i; i < _numberOfTokens; i++) {
1222       _mint(_to, supply + i);
1223     }
1224   }
1225 }