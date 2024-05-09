1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Contract module that helps prevent reentrant calls to a function.
80  *
81  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
82  * available, which can be applied to functions to make sure there are no nested
83  * (reentrant) calls to them.
84  *
85  * Note that because there is a single `nonReentrant` guard, functions marked as
86  * `nonReentrant` may not call one another. This can be worked around by making
87  * those functions `private`, and then adding `external` `nonReentrant` entry
88  * points to them.
89  *
90  * TIP: If you would like to learn more about reentrancy and alternative ways
91  * to protect against it, check out our blog post
92  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
93  */
94 abstract contract ReentrancyGuard {
95     // Booleans are more expensive than uint256 or any type that takes up a full
96     // word because each write operation emits an extra SLOAD to first read the
97     // slot's contents, replace the bits taken up by the boolean, and then write
98     // back. This is the compiler's defense against contract upgrades and
99     // pointer aliasing, and it cannot be disabled.
100 
101     // The values being non-zero value makes deployment a bit more expensive,
102     // but in exchange the refund on every call to nonReentrant will be lower in
103     // amount. Since refunds are capped to a percentage of the total
104     // transaction's gas, it is best to keep them low in cases like this one, to
105     // increase the likelihood of the full refund coming into effect.
106     uint256 private constant _NOT_ENTERED = 1;
107     uint256 private constant _ENTERED = 2;
108 
109     uint256 private _status;
110 
111     constructor() {
112         _status = _NOT_ENTERED;
113     }
114 
115     /**
116      * @dev Prevents a contract from calling itself, directly or indirectly.
117      * Calling a `nonReentrant` function from another `nonReentrant`
118      * function is not supported. It is possible to prevent this from happening
119      * by making the `nonReentrant` function external, and making it call a
120      * `private` function that does the actual work.
121      */
122     modifier nonReentrant() {
123         // On the first call to nonReentrant, _notEntered will be true
124         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
125 
126         // Any calls to nonReentrant after this point will fail
127         _status = _ENTERED;
128 
129         _;
130 
131         // By storing the original value once again, a refund is triggered (see
132         // https://eips.ethereum.org/EIPS/eip-2200)
133         _status = _NOT_ENTERED;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Interface of the ERC165 standard, as defined in the
251  * https://eips.ethereum.org/EIPS/eip-165[EIP].
252  *
253  * Implementers can declare support of contract interfaces, which can then be
254  * queried by others ({ERC165Checker}).
255  *
256  * For an implementation, see {ERC165}.
257  */
258 interface IERC165 {
259     /**
260      * @dev Returns true if this contract implements the interface defined by
261      * `interfaceId`. See the corresponding
262      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
263      * to learn more about how these ids are created.
264      *
265      * This function call must use less than 30 000 gas.
266      */
267     function supportsInterface(bytes4 interfaceId) external view returns (bool);
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Implementation of the {IERC165} interface.
280  *
281  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
282  * for the additional interface id that will be supported. For example:
283  *
284  * ```solidity
285  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
286  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
287  * }
288  * ```
289  *
290  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
291  */
292 abstract contract ERC165 is IERC165 {
293     /**
294      * @dev See {IERC165-supportsInterface}.
295      */
296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297         return interfaceId == type(IERC165).interfaceId;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev _Available since v3.1._
311  */
312 interface IERC1155Receiver is IERC165 {
313     /**
314         @dev Handles the receipt of a single ERC1155 token type. This function is
315         called at the end of a `safeTransferFrom` after the balance has been updated.
316         To accept the transfer, this must return
317         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
318         (i.e. 0xf23a6e61, or its own function selector).
319         @param operator The address which initiated the transfer (i.e. msg.sender)
320         @param from The address which previously owned the token
321         @param id The ID of the token being transferred
322         @param value The amount of tokens being transferred
323         @param data Additional data with no specified format
324         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
325     */
326     function onERC1155Received(
327         address operator,
328         address from,
329         uint256 id,
330         uint256 value,
331         bytes calldata data
332     ) external returns (bytes4);
333 
334     /**
335         @dev Handles the receipt of a multiple ERC1155 token types. This function
336         is called at the end of a `safeBatchTransferFrom` after the balances have
337         been updated. To accept the transfer(s), this must return
338         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
339         (i.e. 0xbc197c81, or its own function selector).
340         @param operator The address which initiated the batch transfer (i.e. msg.sender)
341         @param from The address which previously owned the token
342         @param ids An array containing ids of each token being transferred (order and length must match values array)
343         @param values An array containing amounts of each token being transferred (order and length must match ids array)
344         @param data Additional data with no specified format
345         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
346     */
347     function onERC1155BatchReceived(
348         address operator,
349         address from,
350         uint256[] calldata ids,
351         uint256[] calldata values,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 
365 /**
366  * @dev _Available since v3.1._
367  */
368 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
369     /**
370      * @dev See {IERC165-supportsInterface}.
371      */
372     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
373         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Holder.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @dev _Available since v3.1._
387  */
388 contract ERC1155Holder is ERC1155Receiver {
389     function onERC1155Received(
390         address,
391         address,
392         uint256,
393         uint256,
394         bytes memory
395     ) public virtual override returns (bytes4) {
396         return this.onERC1155Received.selector;
397     }
398 
399     function onERC1155BatchReceived(
400         address,
401         address,
402         uint256[] memory,
403         uint256[] memory,
404         bytes memory
405     ) public virtual override returns (bytes4) {
406         return this.onERC1155BatchReceived.selector;
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 
418 /**
419  * @dev Required interface of an ERC1155 compliant contract, as defined in the
420  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
421  *
422  * _Available since v3.1._
423  */
424 interface IERC1155 is IERC165 {
425     /**
426      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
427      */
428     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
429 
430     /**
431      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
432      * transfers.
433      */
434     event TransferBatch(
435         address indexed operator,
436         address indexed from,
437         address indexed to,
438         uint256[] ids,
439         uint256[] values
440     );
441 
442     /**
443      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
444      * `approved`.
445      */
446     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
447 
448     /**
449      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
450      *
451      * If an {URI} event was emitted for `id`, the standard
452      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
453      * returned by {IERC1155MetadataURI-uri}.
454      */
455     event URI(string value, uint256 indexed id);
456 
457     /**
458      * @dev Returns the amount of tokens of token type `id` owned by `account`.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      */
464     function balanceOf(address account, uint256 id) external view returns (uint256);
465 
466     /**
467      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
468      *
469      * Requirements:
470      *
471      * - `accounts` and `ids` must have the same length.
472      */
473     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
474         external
475         view
476         returns (uint256[] memory);
477 
478     /**
479      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
480      *
481      * Emits an {ApprovalForAll} event.
482      *
483      * Requirements:
484      *
485      * - `operator` cannot be the caller.
486      */
487     function setApprovalForAll(address operator, bool approved) external;
488 
489     /**
490      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
491      *
492      * See {setApprovalForAll}.
493      */
494     function isApprovedForAll(address account, address operator) external view returns (bool);
495 
496     /**
497      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
498      *
499      * Emits a {TransferSingle} event.
500      *
501      * Requirements:
502      *
503      * - `to` cannot be the zero address.
504      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
505      * - `from` must have a balance of tokens of type `id` of at least `amount`.
506      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
507      * acceptance magic value.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 id,
513         uint256 amount,
514         bytes calldata data
515     ) external;
516 
517     /**
518      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
519      *
520      * Emits a {TransferBatch} event.
521      *
522      * Requirements:
523      *
524      * - `ids` and `amounts` must have the same length.
525      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
526      * acceptance magic value.
527      */
528     function safeBatchTransferFrom(
529         address from,
530         address to,
531         uint256[] calldata ids,
532         uint256[] calldata amounts,
533         bytes calldata data
534     ) external;
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Interface of the ERC20 standard as defined in the EIP.
546  */
547 interface IERC20 {
548     /**
549      * @dev Returns the amount of tokens in existence.
550      */
551     function totalSupply() external view returns (uint256);
552 
553     /**
554      * @dev Returns the amount of tokens owned by `account`.
555      */
556     function balanceOf(address account) external view returns (uint256);
557 
558     /**
559      * @dev Moves `amount` tokens from the caller's account to `recipient`.
560      *
561      * Returns a boolean value indicating whether the operation succeeded.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transfer(address recipient, uint256 amount) external returns (bool);
566 
567     /**
568      * @dev Returns the remaining number of tokens that `spender` will be
569      * allowed to spend on behalf of `owner` through {transferFrom}. This is
570      * zero by default.
571      *
572      * This value changes when {approve} or {transferFrom} are called.
573      */
574     function allowance(address owner, address spender) external view returns (uint256);
575 
576     /**
577      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
578      *
579      * Returns a boolean value indicating whether the operation succeeded.
580      *
581      * IMPORTANT: Beware that changing an allowance with this method brings the risk
582      * that someone may use both the old and the new allowance by unfortunate
583      * transaction ordering. One possible solution to mitigate this race
584      * condition is to first reduce the spender's allowance to 0 and set the
585      * desired value afterwards:
586      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
587      *
588      * Emits an {Approval} event.
589      */
590     function approve(address spender, uint256 amount) external returns (bool);
591 
592     /**
593      * @dev Moves `amount` tokens from `sender` to `recipient` using the
594      * allowance mechanism. `amount` is then deducted from the caller's
595      * allowance.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(
602         address sender,
603         address recipient,
604         uint256 amount
605     ) external returns (bool);
606 
607     /**
608      * @dev Emitted when `value` tokens are moved from one account (`from`) to
609      * another (`to`).
610      *
611      * Note that `value` may be zero.
612      */
613     event Transfer(address indexed from, address indexed to, uint256 value);
614 
615     /**
616      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
617      * a call to {approve}. `value` is the new allowance.
618      */
619     event Approval(address indexed owner, address indexed spender, uint256 value);
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Interface for the optional metadata functions from the ERC20 standard.
632  *
633  * _Available since v4.1._
634  */
635 interface IERC20Metadata is IERC20 {
636     /**
637      * @dev Returns the name of the token.
638      */
639     function name() external view returns (string memory);
640 
641     /**
642      * @dev Returns the symbol of the token.
643      */
644     function symbol() external view returns (string memory);
645 
646     /**
647      * @dev Returns the decimals places of the token.
648      */
649     function decimals() external view returns (uint8);
650 }
651 
652 // File: contracts/JUNGLE.sol
653 
654 
655 pragma solidity ^0.8.0;
656 
657 
658 
659 
660 
661 
662 
663 
664 
665 interface IJungleFreaksNFT {
666     function transferFrom(address _from, address _to, uint256 _tokenId) external;
667 }
668 
669 contract Jungle is ERC1155Holder, Context, IERC20, IERC20Metadata, Ownable, ReentrancyGuard {
670     using Strings for uint256;
671 
672     uint256 private _totalSupply;
673     string private _name = "Jungle";
674     string private _symbol = "JUNGLE";
675     uint256 public EMISSION_END = 1801717200;
676     uint256 public constant EMISSION_RATE = 10 ether;
677     uint256 public constant EMISSION_RATE_COTF = 35 ether;
678     uint256 public constant EMISSION_RATE_MTFM = 15 ether;
679     address public constant JUNGLE_FREAKS_ADDRESS = 0x7E6Bc952d4b4bD814853301bEe48E99891424de0;
680     address public constant LEGENDARY_VAULT_ADDRESS = 0x495f947276749Ce646f68AC8c248420045cb7b5e;
681     uint256 public constant LEGENDARY_COTF = 64396628092031731206525383750081342765665389133291640817070595755125256486927;
682     uint256 public constant LEGENDARY_MTFM = 64396628092031731206525383750081342765665389133291640817070595754025744859163;
683     bool public live = false;
684 
685     struct LegendariesStaked {
686         uint32 cotfAccumulatedTime;
687         uint32 mtfmAccumulatedTime;
688         uint32 cotfLastStaked;
689         uint32 mtfmLastStaked;
690         uint8 cotfStaked;
691         uint8 mtfmStaked;
692     }
693 
694     mapping(uint256 => uint256) internal timeStaked;
695     mapping(uint256 => address) internal tokenStaker;
696     mapping(address => uint256[]) internal stakerTokens;
697     mapping(address => LegendariesStaked) public legendariesStaked;
698 
699     // ERC20 mappings
700     mapping(address => uint256) private _balances;
701     mapping(address => mapping(address => uint256)) private _allowances;
702     mapping(address => bool) private authorizedAddresses;
703     mapping(address => bool) public controllers;
704 
705     IJungleFreaksNFT private constant _freaksContract = IJungleFreaksNFT(JUNGLE_FREAKS_ADDRESS);
706     IERC1155 private constant _vaultContract = IERC1155(LEGENDARY_VAULT_ADDRESS);
707 
708     constructor() {}
709 
710     modifier stakingEnabled {
711         require(live && block.timestamp < EMISSION_END, "NOT_LIVE");
712         _;
713     }
714 
715     modifier onlyTokenController {
716         require(controllers[msg.sender], "NOT_CONTROLLER");
717         _;
718     }
719 
720     function getStakedTokens(address staker) public view returns (uint256[] memory) {
721         return stakerTokens[staker];
722     }
723     
724     function getStakedAmount(address staker) public view returns (uint256) {
725         return stakerTokens[staker].length;
726     }
727 
728     function getStaker(uint256 tokenId) public view returns (address) {
729         return tokenStaker[tokenId];
730     }
731 
732     function getAllRewards(address staker) public view returns (uint256) {
733         uint256 totalRewards = 0;
734 
735         uint256[] memory tokens = stakerTokens[staker];
736         for (uint256 i = 0; i < tokens.length; i++) {
737             totalRewards += (getStakingTimestamp() - timeStaked[tokens[i]]) * EMISSION_RATE / 86400;
738         }
739 
740         return totalRewards;
741     }
742 
743     function getLegendariesRewards(address staker) public view returns (uint256) {
744         LegendariesStaked storage stakingState = legendariesStaked[staker];
745         uint256 totalRewards;
746 
747         uint256 timestamp = getStakingTimestamp();
748         totalRewards += (((timestamp - stakingState.cotfLastStaked) * stakingState.cotfStaked) + stakingState.cotfAccumulatedTime) * EMISSION_RATE_COTF / 86400;
749         totalRewards += (((timestamp - stakingState.mtfmLastStaked) * stakingState.mtfmStaked) + stakingState.mtfmAccumulatedTime) * EMISSION_RATE_MTFM / 86400;
750 
751         return totalRewards;
752     }
753 
754     function stakeById(uint256[] calldata tokenIds) external stakingEnabled {
755         require(stakerTokens[msg.sender].length + tokenIds.length <= 100, "MAX_TOKENS_STAKED");
756         uint256 timestamp = getStakingTimestamp();
757 
758         for (uint256 i = 0; i < tokenIds.length; i++) {
759             uint256 id = tokenIds[i];
760             _freaksContract.transferFrom(msg.sender, address(this), id);
761 
762             stakerTokens[msg.sender].push(id);
763             timeStaked[id] = timestamp;
764             tokenStaker[id] = msg.sender;
765         }
766     }
767 
768     function stakeLegendaries(uint8 cotf, uint8 mtfm) external stakingEnabled nonReentrant {
769         LegendariesStaked storage stakingState = legendariesStaked[msg.sender];
770         uint256 timestamp = getStakingTimestamp();
771 
772         if (cotf > 0) {
773             stakingState.cotfAccumulatedTime += (uint32(timestamp) - stakingState.cotfLastStaked) * stakingState.cotfStaked;
774             stakingState.cotfLastStaked = uint32(timestamp);
775             stakingState.cotfStaked += cotf;
776 
777             _vaultContract.safeTransferFrom(msg.sender, address(this), LEGENDARY_COTF, cotf, "");
778         }
779 
780         if (mtfm > 0) {
781             stakingState.mtfmAccumulatedTime += (uint32(timestamp) - stakingState.mtfmLastStaked) * stakingState.mtfmStaked;
782             stakingState.mtfmLastStaked = uint32(timestamp);
783             stakingState.mtfmStaked += mtfm;
784             
785             _vaultContract.safeTransferFrom(msg.sender, address(this), LEGENDARY_MTFM, mtfm, "");
786         }
787     }
788 
789     function unstakeLegendaries(uint8 cotf, uint8 mtfm) external nonReentrant {
790         require(cotf > 0 || mtfm > 0, "No tokens to unstake");
791 
792         LegendariesStaked storage stakingState = legendariesStaked[msg.sender];
793         uint256 totalRewards;
794         uint256 timestamp = getStakingTimestamp();
795 
796         if (cotf > 0) {
797             totalRewards += (((timestamp - stakingState.cotfLastStaked) * stakingState.cotfStaked) + stakingState.cotfAccumulatedTime) * EMISSION_RATE_COTF / 86400;
798 
799             stakingState.cotfAccumulatedTime = 0;
800             stakingState.cotfLastStaked = uint32(timestamp);
801             stakingState.cotfStaked -= cotf; // Relying on underflow check.
802 
803             _vaultContract.safeTransferFrom(address(this), msg.sender, LEGENDARY_COTF, cotf, "");
804         }
805 
806         if (mtfm > 0) {
807             totalRewards += (((timestamp - stakingState.mtfmLastStaked) * stakingState.mtfmStaked) + stakingState.mtfmAccumulatedTime) * EMISSION_RATE_MTFM / 86400;
808 
809             stakingState.mtfmAccumulatedTime = 0;
810             stakingState.mtfmLastStaked = uint32(timestamp);
811             stakingState.mtfmStaked -= mtfm; // Relying on underflow check.
812 
813             _vaultContract.safeTransferFrom(address(this), msg.sender, LEGENDARY_MTFM, mtfm, "");
814         }
815 
816         _mint(msg.sender, totalRewards);
817     }
818 
819     function claimLegendaries() external nonReentrant {
820         LegendariesStaked storage stakingState = legendariesStaked[msg.sender];
821         uint256 totalRewards;
822         uint256 timestamp = getStakingTimestamp();
823 
824         if (stakingState.cotfStaked > 0) {
825             totalRewards += (((timestamp - stakingState.cotfLastStaked) * stakingState.cotfStaked) + stakingState.cotfAccumulatedTime) * EMISSION_RATE_COTF / 86400;
826 
827             stakingState.cotfAccumulatedTime = 0;
828             stakingState.cotfLastStaked = uint32(timestamp);
829         }
830 
831         if (stakingState.mtfmStaked > 0) {
832             totalRewards += (((timestamp - stakingState.mtfmLastStaked) * stakingState.mtfmStaked) + stakingState.mtfmAccumulatedTime) * EMISSION_RATE_MTFM / 86400;
833 
834             stakingState.mtfmAccumulatedTime = 0;
835             stakingState.mtfmLastStaked = uint32(timestamp);
836         }
837 
838         _mint(msg.sender, totalRewards);
839     }
840 
841     function unstakeByIds(uint256[] calldata tokenIds) external {
842         uint256 totalRewards = 0;
843         uint256 timestamp = getStakingTimestamp();
844 
845         for (uint256 i = 0; i < tokenIds.length; i++) {
846             uint256 id = tokenIds[i];
847             require(tokenStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
848 
849             _freaksContract.transferFrom(address(this), msg.sender, id);
850             totalRewards += (timestamp - timeStaked[id]) * EMISSION_RATE / 86400;
851 
852             removeTokenIdFromArray(stakerTokens[msg.sender], id);
853             tokenStaker[id] = address(0);
854         }
855 
856         _mint(msg.sender, totalRewards);
857     }
858 
859     function unstakeAll() external {
860         require(getStakedAmount(msg.sender) > 0, "NONE_STAKED");
861         uint256 totalRewards = 0;
862         uint256 timestamp = getStakingTimestamp();
863 
864         for (uint256 i = stakerTokens[msg.sender].length; i > 0; i--) {
865             uint256 id = stakerTokens[msg.sender][i - 1];
866 
867             _freaksContract.transferFrom(address(this), msg.sender, id);
868             totalRewards += (timestamp - timeStaked[id]) * EMISSION_RATE / 86400;
869 
870             stakerTokens[msg.sender].pop();
871             tokenStaker[id] = address(0);
872         }
873 
874         _mint(msg.sender, totalRewards);
875     }
876 
877     function claimAll() external {
878         uint256 totalRewards = 0;
879         uint256 timestamp = getStakingTimestamp();
880 
881         uint256[] memory tokens = stakerTokens[msg.sender];
882         for (uint256 i = 0; i < tokens.length; i++) {
883             uint256 id = tokens[i];
884 
885             totalRewards += (timestamp - timeStaked[id]) * EMISSION_RATE / 86400;
886             timeStaked[id] = timestamp;
887         }
888 
889         _mint(msg.sender, totalRewards);
890     }
891 
892     function rescueERC1155(address token, uint256[] calldata ids, uint256[] calldata amounts, address to) external onlyOwner {
893         IERC1155(token).safeBatchTransferFrom(address(this), to, ids, amounts, "");
894     }
895     
896     function toggle() external onlyOwner {
897         live = !live;
898     }
899 
900     function updateEmissionEnd(uint256 newTime) external onlyOwner {
901         EMISSION_END = newTime;
902     }
903 
904     function getStakingTimestamp() view internal returns (uint256) {
905         return block.timestamp < EMISSION_END ? block.timestamp : EMISSION_END;
906     }
907 
908     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
909         uint256 length = array.length;
910         for (uint256 i = 0; i < length; i++) {
911             if (array[i] == tokenId) {
912                 length--;
913                 if (i < length) {
914                     array[i] = array[length];
915                 }
916                 array.pop();
917                 break;
918             }
919         }
920     }
921 
922     // Token functions
923     // --------------------------------------------------------------
924     function mint(address to, uint256 amount) external onlyTokenController {
925         _mint(to, amount);
926     }
927 
928     function burn(address from, uint256 amount) external onlyTokenController {
929         _burn(from, amount);
930     }
931 
932     function setController(address controller, bool authorized) public onlyOwner {
933         controllers[controller] = authorized;
934     }
935 
936     function setAuthorizedAddress(address authorizedAddress, bool authorized) public onlyOwner {
937         authorizedAddresses[authorizedAddress] = authorized;
938     }
939 
940     // ERC20 functions
941     // --------------------------------------------------------------    
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945     
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949     
950     function decimals() public view virtual override returns (uint8) {
951         return 18;
952     }
953     
954     function totalSupply() public view virtual override returns (uint256) {
955         return _totalSupply;
956     }
957     
958     function balanceOf(address account) public view virtual override returns (uint256) {
959         return _balances[account];
960     }
961     
962     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
963         _transfer(_msgSender(), recipient, amount);
964         return true;
965     }
966     
967     function allowance(address owner, address spender) public view virtual override returns (uint256) {
968         return _allowances[owner][spender];
969     }
970     
971     function approve(address spender, uint256 amount) public virtual override returns (bool) {
972         _approve(_msgSender(), spender, amount);
973         return true;
974     }
975     
976     function transferFrom(
977         address sender,
978         address recipient,
979         uint256 amount
980     ) public virtual override returns (bool) {
981         _transfer(sender, recipient, amount);
982 
983         if (!authorizedAddresses[msg.sender]) {
984             uint256 currentAllowance = _allowances[sender][_msgSender()];
985             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
986             unchecked {
987                 _approve(sender, _msgSender(), currentAllowance - amount);
988             }
989         }
990 
991         return true;
992     }
993     
994     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
995         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
996         return true;
997     }
998     
999     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1000         uint256 currentAllowance = _allowances[_msgSender()][spender];
1001         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1002         unchecked {
1003             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1004         }
1005 
1006         return true;
1007     }
1008     
1009     function _transfer(
1010         address sender,
1011         address recipient,
1012         uint256 amount
1013     ) internal virtual {
1014         require(sender != address(0), "ERC20: transfer from the zero address");
1015         require(recipient != address(0), "ERC20: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(sender, recipient, amount);
1018 
1019         uint256 senderBalance = _balances[sender];
1020         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1021         unchecked {
1022             _balances[sender] = senderBalance - amount;
1023         }
1024         _balances[recipient] += amount;
1025 
1026         emit Transfer(sender, recipient, amount);
1027 
1028         _afterTokenTransfer(sender, recipient, amount);
1029     }
1030     
1031     function _mint(address account, uint256 amount) internal virtual {
1032         require(account != address(0), "ERC20: mint to the zero address");
1033 
1034         _beforeTokenTransfer(address(0), account, amount);
1035 
1036         _totalSupply += amount;
1037         _balances[account] += amount;
1038         emit Transfer(address(0), account, amount);
1039 
1040         _afterTokenTransfer(address(0), account, amount);
1041     }
1042     
1043     function _burn(address account, uint256 amount) internal virtual {
1044         require(account != address(0), "ERC20: burn from the zero address");
1045 
1046         _beforeTokenTransfer(account, address(0), amount);
1047 
1048         uint256 accountBalance = _balances[account];
1049         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1050         unchecked {
1051             _balances[account] = accountBalance - amount;
1052         }
1053         _totalSupply -= amount;
1054 
1055         emit Transfer(account, address(0), amount);
1056 
1057         _afterTokenTransfer(account, address(0), amount);
1058     }
1059     
1060     function _approve(
1061         address owner,
1062         address spender,
1063         uint256 amount
1064     ) internal virtual {
1065         require(owner != address(0), "ERC20: approve from the zero address");
1066         require(spender != address(0), "ERC20: approve to the zero address");
1067 
1068         _allowances[owner][spender] = amount;
1069         emit Approval(owner, spender, amount);
1070     }
1071 
1072     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1073 
1074     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1075 }