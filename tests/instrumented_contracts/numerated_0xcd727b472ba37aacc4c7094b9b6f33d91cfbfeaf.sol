1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: IRandom
8 
9 interface IRandom {
10     /**
11      * @dev Returns the URI for token type `id`.
12      *
13      * If the `\{id\}` substring is present in the URI, it must be replaced by
14      * clients with the actual token type ID.
15      */
16     function requestChainLinkEntropy() external returns (bytes32 requestId);
17 }
18 
19 // Part: IRarity
20 
21 interface IRarity {
22     //enum Rarity {Simple, SimpleUpgraded, Rare, Legendary, F1, F2, F3}
23     function getRarity(address _contract, uint256 _tokenId) external view returns(uint8 r);
24     function getRarity2(address _contract, uint256 _tokenId) external view returns(uint8 r);
25 }
26 
27 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Context
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC165
50 
51 /**
52  * @dev Interface of the ERC165 standard, as defined in the
53  * https://eips.ethereum.org/EIPS/eip-165[EIP].
54  *
55  * Implementers can declare support of contract interfaces, which can then be
56  * queried by others ({ERC165Checker}).
57  *
58  * For an implementation, see {ERC165}.
59  */
60 interface IERC165 {
61     /**
62      * @dev Returns true if this contract implements the interface defined by
63      * `interfaceId`. See the corresponding
64      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
65      * to learn more about how these ids are created.
66      *
67      * This function call must use less than 30 000 gas.
68      */
69     function supportsInterface(bytes4 interfaceId) external view returns (bool);
70 }
71 
72 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721
73 
74 /**
75  * @dev Required interface of an ERC721 compliant contract.
76  */
77 interface IERC721 is IERC165 {
78     /**
79      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
82 
83     /**
84      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
85      */
86     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
87 
88     /**
89      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
90      */
91     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
92 
93     /**
94      * @dev Returns the number of tokens in ``owner``'s account.
95      */
96     function balanceOf(address owner) external view returns (uint256 balance);
97 
98     /**
99      * @dev Returns the owner of the `tokenId` token.
100      *
101      * Requirements:
102      *
103      * - `tokenId` must exist.
104      */
105     function ownerOf(uint256 tokenId) external view returns (address owner);
106 
107     /**
108      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
109      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must exist and be owned by `from`.
116      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
118      *
119      * Emits a {Transfer} event.
120      */
121     function safeTransferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Transfers `tokenId` token from `from` to `to`.
129      *
130      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
131      *
132      * Requirements:
133      *
134      * - `from` cannot be the zero address.
135      * - `to` cannot be the zero address.
136      * - `tokenId` token must be owned by `from`.
137      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address from,
143         address to,
144         uint256 tokenId
145     ) external;
146 
147     /**
148      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
149      * The approval is cleared when the token is transferred.
150      *
151      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
152      *
153      * Requirements:
154      *
155      * - The caller must own the token or be an approved operator.
156      * - `tokenId` must exist.
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address to, uint256 tokenId) external;
161 
162     /**
163      * @dev Returns the account approved for `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function getApproved(uint256 tokenId) external view returns (address operator);
170 
171     /**
172      * @dev Approve or remove `operator` as an operator for the caller.
173      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
174      *
175      * Requirements:
176      *
177      * - The `operator` cannot be the caller.
178      *
179      * Emits an {ApprovalForAll} event.
180      */
181     function setApprovalForAll(address operator, bool _approved) external;
182 
183     /**
184      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
185      *
186      * See {setApprovalForAll}
187      */
188     function isApprovedForAll(address owner, address operator) external view returns (bool);
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must exist and be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200      *
201      * Emits a {Transfer} event.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId,
207         bytes calldata data
208     ) external;
209 }
210 
211 // Part: IHero
212 
213 /**
214  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
215  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
216  *
217  * _Available since v3.1._
218  */
219 interface IHero is IERC721 {
220     /**
221      * @dev Returns the URI for token type `id`.
222      *
223      * If the `\{id\}` substring is present in the URI, it must be replaced by
224      * clients with the actual token type ID.
225      */
226     function multiMint() external;
227     function setPartner(address _partner, uint256 _limit) external;
228     function transferOwnership(address newOwner) external; 
229     function partnersLimit(address _partner) external view returns(uint256, uint256);
230     function totalSupply() external view returns(uint256);
231     function reservedForPartners() external view returns(uint256);
232 }
233 
234 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC165
235 
236 /**
237  * @dev Implementation of the {IERC165} interface.
238  *
239  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
240  * for the additional interface id that will be supported. For example:
241  *
242  * ```solidity
243  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
244  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
245  * }
246  * ```
247  *
248  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
249  */
250 abstract contract ERC165 is IERC165 {
251     /**
252      * @dev See {IERC165-supportsInterface}.
253      */
254     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255         return interfaceId == type(IERC165).interfaceId;
256     }
257 }
258 
259 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155
260 
261 /**
262  * @dev Required interface of an ERC1155 compliant contract, as defined in the
263  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
264  *
265  * _Available since v3.1._
266  */
267 interface IERC1155 is IERC165 {
268     /**
269      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
270      */
271     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
272 
273     /**
274      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
275      * transfers.
276      */
277     event TransferBatch(
278         address indexed operator,
279         address indexed from,
280         address indexed to,
281         uint256[] ids,
282         uint256[] values
283     );
284 
285     /**
286      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
287      * `approved`.
288      */
289     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
290 
291     /**
292      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
293      *
294      * If an {URI} event was emitted for `id`, the standard
295      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
296      * returned by {IERC1155MetadataURI-uri}.
297      */
298     event URI(string value, uint256 indexed id);
299 
300     /**
301      * @dev Returns the amount of tokens of token type `id` owned by `account`.
302      *
303      * Requirements:
304      *
305      * - `account` cannot be the zero address.
306      */
307     function balanceOf(address account, uint256 id) external view returns (uint256);
308 
309     /**
310      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
311      *
312      * Requirements:
313      *
314      * - `accounts` and `ids` must have the same length.
315      */
316     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
317         external
318         view
319         returns (uint256[] memory);
320 
321     /**
322      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
323      *
324      * Emits an {ApprovalForAll} event.
325      *
326      * Requirements:
327      *
328      * - `operator` cannot be the caller.
329      */
330     function setApprovalForAll(address operator, bool approved) external;
331 
332     /**
333      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
334      *
335      * See {setApprovalForAll}.
336      */
337     function isApprovedForAll(address account, address operator) external view returns (bool);
338 
339     /**
340      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
341      *
342      * Emits a {TransferSingle} event.
343      *
344      * Requirements:
345      *
346      * - `to` cannot be the zero address.
347      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
348      * - `from` must have a balance of tokens of type `id` of at least `amount`.
349      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
350      * acceptance magic value.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 id,
356         uint256 amount,
357         bytes calldata data
358     ) external;
359 
360     /**
361      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
362      *
363      * Emits a {TransferBatch} event.
364      *
365      * Requirements:
366      *
367      * - `ids` and `amounts` must have the same length.
368      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
369      * acceptance magic value.
370      */
371     function safeBatchTransferFrom(
372         address from,
373         address to,
374         uint256[] calldata ids,
375         uint256[] calldata amounts,
376         bytes calldata data
377     ) external;
378 }
379 
380 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155Receiver
381 
382 /**
383  * @dev _Available since v3.1._
384  */
385 interface IERC1155Receiver is IERC165 {
386     /**
387         @dev Handles the receipt of a single ERC1155 token type. This function is
388         called at the end of a `safeTransferFrom` after the balance has been updated.
389         To accept the transfer, this must return
390         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
391         (i.e. 0xf23a6e61, or its own function selector).
392         @param operator The address which initiated the transfer (i.e. msg.sender)
393         @param from The address which previously owned the token
394         @param id The ID of the token being transferred
395         @param value The amount of tokens being transferred
396         @param data Additional data with no specified format
397         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
398     */
399     function onERC1155Received(
400         address operator,
401         address from,
402         uint256 id,
403         uint256 value,
404         bytes calldata data
405     ) external returns (bytes4);
406 
407     /**
408         @dev Handles the receipt of a multiple ERC1155 token types. This function
409         is called at the end of a `safeBatchTransferFrom` after the balances have
410         been updated. To accept the transfer(s), this must return
411         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
412         (i.e. 0xbc197c81, or its own function selector).
413         @param operator The address which initiated the batch transfer (i.e. msg.sender)
414         @param from The address which previously owned the token
415         @param ids An array containing ids of each token being transferred (order and length must match values array)
416         @param values An array containing amounts of each token being transferred (order and length must match ids array)
417         @param data Additional data with no specified format
418         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
419     */
420     function onERC1155BatchReceived(
421         address operator,
422         address from,
423         uint256[] calldata ids,
424         uint256[] calldata values,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Ownable
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 abstract contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor() {
452         _setOwner(_msgSender());
453     }
454 
455     /**
456      * @dev Returns the address of the current owner.
457      */
458     function owner() public view virtual returns (address) {
459         return _owner;
460     }
461 
462     /**
463      * @dev Throws if called by any account other than the owner.
464      */
465     modifier onlyOwner() {
466         require(owner() == _msgSender(), "Ownable: caller is not the owner");
467         _;
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         _setOwner(address(0));
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         _setOwner(newOwner);
488     }
489 
490     function _setOwner(address newOwner) private {
491         address oldOwner = _owner;
492         _owner = newOwner;
493         emit OwnershipTransferred(oldOwner, newOwner);
494     }
495 }
496 
497 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1155Receiver
498 
499 /**
500  * @dev _Available since v3.1._
501  */
502 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
507         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
508     }
509 }
510 
511 // File: HeroesUpgraderV2.sol
512 
513 contract HeroesUpgraderV2  is ERC1155Receiver, Ownable {
514 
515     // F1, F2, F3 rarity types reserved for future game play
516     enum Rarity {Simple, SimpleUpgraded, Rare, Legendary, F1, F2, F3}
517     struct Modification {
518         address sourceContract;
519         Rarity  sourceRarity;
520         address destinitionContract;
521         Rarity  destinitionRarity;
522         uint256 balanceForUpgrade;
523         bool enabled;
524     }
525 
526     bool internal chainLink;
527     address public chainLinkAdapter;
528     address internal whiteListBalancer = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
529     address public externalStorage;
530 
531     // Mapping of enabled modifications
532     // From modifier contract address and tokenId to Modification
533     mapping(address => mapping(uint256 => Modification)) public enabledModifications;
534 
535     // Mapping of enabled source conatracts
536     mapping(address => bool) public sourceContracts;
537     
538     //Mapping from upgradING contract address and tokenId to token 
539     //rarity. By default (token was not upgrade) any token has Simple rarity
540     mapping(address => mapping(uint256 => Rarity)) public rarity;
541     
542     event Upgraded(address destinitionContract, uint256 oldHero, uint256 newHero, Rarity newRarity);
543     event ModificationChange(address modifierContract, uint256 modifierId);
544     
545 
546     
547     function upgrade(uint256 oldHero, address modifierContract, uint256 modifierId) public {
548         //1.0 Check that modification is registered
549         require(
550             enabledModifications[modifierContract][modifierId].enabled
551             , "Unknown modificator"
552         );
553         // 1.1. Check that this hero is not rare o legendary
554         // In more common sence that modification from current oldHero rariry is enabled
555         require(
556             rarity[
557               enabledModifications[modifierContract][modifierId].sourceContract
558             ][oldHero] == enabledModifications[modifierContract][modifierId].sourceRarity,
559             "Cant modify twice or from your rarity"
560         );
561 
562         require(
563             IHero(
564                enabledModifications[modifierContract][modifierId].sourceContract
565             ).ownerOf(oldHero) == msg.sender,
566             "You need own hero for upgrade"
567         );
568         //2.Charge modificator from user
569         IERC1155(modifierContract).safeTransferFrom(
570             msg.sender,
571             address(this),
572             modifierId,
573             enabledModifications[modifierContract][modifierId].balanceForUpgrade,
574             '0'
575         );
576 
577         //3.Mint new hero  and save rarity
578         // get existing mint limit for this conatrct
579         (uint256 limit, uint256 minted) =
580             IHero(
581                enabledModifications[modifierContract][modifierId].destinitionContract
582             ).partnersLimit(address(this));
583         
584         // increase and set new free limit mint for this contract
585         IHero(
586             enabledModifications[modifierContract][modifierId].destinitionContract
587         ).setPartner(address(this), limit + 1);
588         
589         
590          
591         //get tokenId of token thet will mint
592         uint256 newToken = IHero(
593             enabledModifications[modifierContract][modifierId].destinitionContract
594         ).totalSupply();
595         
596         // mint with white list
597         IHero(
598             enabledModifications[modifierContract][modifierId].destinitionContract
599         ).multiMint();
600         
601         // transfer new token to sender
602         IHero(
603             enabledModifications[modifierContract][modifierId].destinitionContract
604         ).transferFrom(address(this), msg.sender, newToken);
605 
606         
607         /////////////////////////////////////////////////////////////////////
608         // correct whitelist balance
609         // For use  this functionalite Heroes Owner must manualy set limit
610         // for whiteListBalancer (two tx with same limit)
611         // (uint256 wl_limit, uint256 wl_minted) = IHero(
612         //        enabledModifications[modifierContract][modifierId].destinitionContract
613         //    ).partnersLimit(whiteListBalancer); 
614 
615         //if (limit != 0) {
616         IHero(
617             enabledModifications[modifierContract][modifierId].destinitionContract
618         ).setPartner(whiteListBalancer, limit);
619         IHero(
620             enabledModifications[modifierContract][modifierId].destinitionContract
621         ).setPartner(whiteListBalancer, limit);
622         IHero(
623             enabledModifications[modifierContract][modifierId].destinitionContract
624         ).setPartner(whiteListBalancer, limit);
625         IHero(
626             enabledModifications[modifierContract][modifierId].destinitionContract
627         ).setPartner(whiteListBalancer, 0);
628         //}
629         /////////////////////////////////////////////////////////////////////
630 
631         
632         //safe rarity of upgradING token
633         rarity[
634             enabledModifications[modifierContract][modifierId].sourceContract
635         ][oldHero] = Rarity.SimpleUpgraded;
636 
637         //safe rarity of new minted token
638         rarity[
639             enabledModifications[modifierContract][modifierId].sourceContract
640         ][newToken] = enabledModifications[modifierContract][modifierId].destinitionRarity;
641         //4.transfer new hero to msg.sender
642         emit Upgraded(
643             enabledModifications[modifierContract][modifierId].destinitionContract, 
644             oldHero,
645             newToken, 
646             enabledModifications[modifierContract][modifierId].destinitionRarity
647         );
648         
649         if (chainLink) {
650             IRandom(chainLinkAdapter).requestChainLinkEntropy();    
651         }
652         
653 
654     }
655 
656     function upgradeBatch(uint256[] memory oldHeroes, address modifierContract, uint256 modifierId) public {
657         require(oldHeroes.length <= 10, "Not more then 10");
658         for (uint256 i; i < oldHeroes.length; i ++) {
659             upgrade(oldHeroes[i], modifierContract, modifierId);
660         }
661     }
662 
663 
664     /// Return rarity of given  token
665     function getRarity(address _contract, uint256 _tokenId) public view returns(Rarity r) {
666         r = rarity[_contract][_tokenId];
667         if (externalStorage != address(0)) {
668             uint8 extRar = IRarity(externalStorage).getRarity(_contract, _tokenId);
669             if (Rarity(extRar) > r) {
670                 r = Rarity(extRar);
671             }
672         }
673         return r;
674     }
675 
676 
677     /// Return rarity of given  token
678     function getRarity2(address _contract, uint256 _tokenId) public view returns(Rarity r) {
679         require(sourceContracts[_contract], "Unknown source contract");
680         require(
681             IHero(_contract).ownerOf(_tokenId) != address(0),
682             "Seems like token not exist"
683         );
684         return getRarity(_contract, _tokenId);
685         // r = rarity[_contract][_tokenId];
686         //         if (externalStorage != address(0)) {
687         //     Rarity extRar = IRarity(externalStorage).getRarity(_contract, _tokenId);
688         //     if (extRar > r) {
689         //         r = extRar;
690         //     }
691         // }
692         // return r;
693     }
694 
695 
696     
697     /**
698         @dev Handles the receipt of a single ERC1155 token type. This function is
699         called at the end of a `safeTransferFrom` after the balance has been updated.
700         To accept the transfer, this must return
701         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
702         (i.e. 0xf23a6e61, or its own function selector).
703         @param operator The address which initiated the transfer (i.e. msg.sender)
704         @param from The address which previously owned the token
705         @param id The ID of the token being transferred
706         @param value The amount of tokens being transferred
707         @param data Additional data with no specified format
708         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
709     */
710     function onERC1155Received(
711         address operator,
712         address from,
713         uint256 id,
714         uint256 value,
715         bytes calldata data
716     )
717         external
718         override
719         returns(bytes4)
720     {
721         return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));  
722     }    
723 
724     /**
725         @dev Handles the receipt of a multiple ERC1155 token types. This function
726         is called at the end of a `safeBatchTransferFrom` after the balances have
727         been updated. To accept the transfer(s), this must return
728         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
729         (i.e. 0xbc197c81, or its own function selector).
730         @param operator The address which initiated the batch transfer (i.e. msg.sender)
731         @param from The address which previously owned the token
732         @param ids An array containing ids of each token being transferred (order and length must match values array)
733         @param values An array containing amounts of each token being transferred (order and length must match ids array)
734         @param data Additional data with no specified format
735         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
736     */
737     function onERC1155BatchReceived(
738         address operator,
739         address from,
740         uint256[] calldata ids,
741         uint256[] calldata values,
742         bytes calldata data
743     )
744         external
745         override
746         returns(bytes4)
747     {
748         return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256,uint256,bytes)"));  
749     }
750     
751     //////////////////////////////////////////////////////
752     ///   Admin Functions                             ////
753     //////////////////////////////////////////////////////
754     function setModification(
755         address _modifierContract,
756         uint256 _modifierId,
757         address _sourceContract,
758         Rarity  _sourceRarity,
759         address _destinitionContract,
760         Rarity  _destinitionRarity,
761         uint256 _balanceForUpgrade,
762         bool    _isEnabled
763     ) external onlyOwner {
764         require(_modifierContract != address(0), "No zero");
765         enabledModifications[_modifierContract][_modifierId].sourceContract = _sourceContract;
766         enabledModifications[_modifierContract][_modifierId].sourceRarity = _sourceRarity;
767         enabledModifications[_modifierContract][_modifierId].destinitionContract = _destinitionContract;
768         enabledModifications[_modifierContract][_modifierId].destinitionRarity = _destinitionRarity;
769         enabledModifications[_modifierContract][_modifierId].balanceForUpgrade = _balanceForUpgrade;
770         enabledModifications[_modifierContract][_modifierId].enabled = _isEnabled;
771         sourceContracts[_sourceContract] = _isEnabled;
772         emit ModificationChange(_modifierContract, _modifierId);
773     }
774 
775     function setModificationState(
776         address _modifierContract,
777         uint256 _modifierId,
778         bool    _isEnabled
779     ) external onlyOwner {
780         require(_modifierContract != address(0), "No zero");
781         enabledModifications[_modifierContract][_modifierId].enabled = _isEnabled;
782         sourceContracts[
783             enabledModifications[_modifierContract][_modifierId].sourceContract
784         ] = _isEnabled;
785         emit ModificationChange(_modifierContract, _modifierId);
786     }
787 
788     function revokeOwnership(address _contract) external onlyOwner {
789         IHero(_contract).transferOwnership(owner());
790     }
791 
792     function setChainLink(bool _isOn) external onlyOwner {
793         require(chainLinkAdapter != address(0), "Set adapter address first");
794         chainLink = _isOn;
795     }
796 
797     function setChainLinkAdapter(address _adapter) external onlyOwner {
798         chainLinkAdapter = _adapter;
799     } 
800 
801     function setPartnerProxy(
802         address _contract, 
803         address _partner, 
804         uint256 _newLimit
805     ) 
806         external 
807         onlyOwner 
808     {
809         IHero(_contract).setPartner(_partner, _newLimit);
810     } 
811 
812     function setWLBalancer(address _balancer) external onlyOwner {
813         require(_balancer != address(0));
814         whiteListBalancer = _balancer;
815     }
816 
817     function loadRaritiesBatch(address _contract, uint256[] memory _tokens, Rarity[] memory _rarities) external onlyOwner {
818         require(_contract != address(0), "No Zero Address");
819         require(_tokens.length == _rarities.length);
820          for (uint256 i; i < _tokens.length; i ++) {
821             rarity[_contract][_tokens[i]] = _rarities[i];
822         }
823     }
824 
825     function setExternalStorage(address _storage) external onlyOwner {
826         externalStorage = _storage;
827     }
828 }
