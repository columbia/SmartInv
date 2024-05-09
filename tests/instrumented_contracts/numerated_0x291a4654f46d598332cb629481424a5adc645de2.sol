1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5    ###    ##       #### ######## ##    ##    ###    ########  #######  ########   ######  
6   ## ##   ##        ##  ##       ###   ##   ## ##      ##    ##     ## ##     ## ##    ## 
7  ##   ##  ##        ##  ##       ####  ##  ##   ##     ##    ##     ## ##     ## ##       
8 ##     ## ##        ##  ######   ## ## ## ##     ##    ##    ##     ## ########   ######  
9 ######### ##        ##  ##       ##  #### #########    ##    ##     ## ##   ##         ## 
10 ##     ## ##        ##  ##       ##   ### ##     ##    ##    ##     ## ##    ##  ##    ## 
11 ##     ## ######## #### ######## ##    ## ##     ##    ##     #######  ##     ##  ######  
12 
13 
14 */
15 
16 pragma solidity ^0.8.13;
17 
18 interface IOperatorFilterRegistry {
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20     function register(address registrant) external;
21     function registerAndSubscribe(address registrant, address subscription) external;
22     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
23     function unregister(address addr) external;
24     function updateOperator(address registrant, address operator, bool filtered) external;
25     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
26     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
27     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
28     function subscribe(address registrant, address registrantToSubscribe) external;
29     function unsubscribe(address registrant, bool copyExistingEntries) external;
30     function subscriptionOf(address addr) external returns (address registrant);
31     function subscribers(address registrant) external returns (address[] memory);
32     function subscriberAt(address registrant, uint256 index) external returns (address);
33     function copyEntriesOf(address registrant, address registrantToCopy) external;
34     function isOperatorFiltered(address registrant, address operator) external returns (bool);
35     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
36     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
37     function filteredOperators(address addr) external returns (address[] memory);
38     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
39     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
40     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
41     function isRegistered(address addr) external returns (bool);
42     function codeHashOf(address addr) external returns (bytes32);
43 }
44 
45 pragma solidity ^0.8.13;
46 
47 /**
48  * @title  OperatorFilterer
49  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
50  *         registrant's entries in the OperatorFilterRegistry.
51  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
52  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
53  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
54  */
55 abstract contract OperatorFilterer {
56     error OperatorNotAllowed(address operator);
57 
58     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
59         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
60 
61     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
62         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
63         // will not revert, but the contract will need to be registered with the registry once it is deployed in
64         // order for the modifier to filter addresses.
65         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
66             if (subscribe) {
67                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
68             } else {
69                 if (subscriptionOrRegistrantToCopy != address(0)) {
70                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
71                 } else {
72                     OPERATOR_FILTER_REGISTRY.register(address(this));
73                 }
74             }
75         }
76     }
77 
78     modifier onlyAllowedOperator(address from) virtual {
79         // Allow spending tokens from addresses with balance
80         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
81         // from an EOA.
82         if (from != msg.sender) {
83             _checkFilterOperator(msg.sender);
84         }
85         _;
86     }
87 
88     modifier onlyAllowedOperatorApproval(address operator) virtual {
89         _checkFilterOperator(operator);
90         _;
91     }
92 
93     function _checkFilterOperator(address operator) internal view virtual {
94         // Check registry code length to facilitate testing in environments without a deployed registry.
95         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
96             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
97                 revert OperatorNotAllowed(operator);
98             }
99         }
100     }
101 }
102 
103 
104 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
105 
106 pragma solidity ^0.8.0;
107 
108 abstract contract ReentrancyGuard {
109     
110     uint256 private constant _NOT_ENTERED = 1;
111     uint256 private constant _ENTERED = 2;
112 
113     uint256 private _status;
114 
115     constructor() {
116         _status = _NOT_ENTERED;
117     }
118 
119     modifier nonReentrant() {
120         // On the first call to nonReentrant, _notEntered will be true
121         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
122 
123         // Any calls to nonReentrant after this point will fail
124         _status = _ENTERED;
125 
126         _;
127 
128         _status = _NOT_ENTERED;
129     }
130 }
131 
132 
133 // File: @openzeppelin/contracts/utils/Strings.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev String operations.
142  */
143 library Strings {
144     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
145 
146     function toString(uint256 value) internal pure returns (string memory) {
147 
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
168      */
169     function toHexString(uint256 value) internal pure returns (string memory) {
170         if (value == 0) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (temp != 0) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value, length);
180     }
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
184      */
185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
186         bytes memory buffer = new bytes(2 * length + 2);
187         buffer[0] = "0";
188         buffer[1] = "x";
189         for (uint256 i = 2 * length + 1; i > 1; --i) {
190             buffer[i] = _HEX_SYMBOLS[value & 0xf];
191             value >>= 4;
192         }
193         require(value == 0, "Strings: hex length insufficient");
194         return string(buffer);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Context.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 abstract contract Context {
206     function _msgSender() internal view virtual returns (address) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes calldata) {
211         return msg.data;
212     }
213 }
214 
215 
216 // File: @openzeppelin/contracts/access/Ownable.sol
217 
218 pragma solidity ^0.8.0;
219 
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor() {
229         _transferOwnership(_msgSender());
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _transferOwnership(address(0));
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _transferOwnership(newOwner);
265     }
266 
267     /**
268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
269      * Internal function without access restriction.
270      */
271     function _transferOwnership(address newOwner) internal virtual {
272         address oldOwner = _owner;
273         _owner = newOwner;
274         emit OwnershipTransferred(oldOwner, newOwner);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Address.sol
279 
280 
281 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
282 
283 pragma solidity ^0.8.1;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     
290     function isContract(address account) internal view returns (bool) {
291         return account.code.length > 0;
292     }
293 
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 interface IERC721Receiver {
425   
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     function supportsInterface(bytes4 interfaceId) external view returns (bool);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 abstract contract ERC165 is IERC165 {
462     /**
463      * @dev See {IERC165-supportsInterface}.
464      */
465     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466         return interfaceId == type(IERC165).interfaceId;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
471 
472 
473 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482     /**
483      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489      */
490     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494      */
495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497     /**
498      * @dev Returns the number of tokens in ``owner``'s account.
499      */
500     function balanceOf(address owner) external view returns (uint256 balance);
501 
502   
503     function ownerOf(uint256 tokenId) external view returns (address owner);
504 
505 
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes calldata data
511     ) external;
512 
513   
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520  
521     function transferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527 
528     function approve(address to, uint256 tokenId) external;
529 
530 
531     function setApprovalForAll(address operator, bool _approved) external;
532 
533 
534     function getApproved(uint256 tokenId) external view returns (address operator);
535 
536     /**
537      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
538      *
539      * See {setApprovalForAll}
540      */
541     function isApprovedForAll(address owner, address operator) external view returns (bool);
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
554  * @dev See https://eips.ethereum.org/EIPS/eip-721
555  */
556 interface IERC721Metadata is IERC721 {
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 }
572 
573 // File: erc721a/contracts/IERC721A.sol
574 
575 
576 // ERC721A Contracts v3.3.0
577 // Creator: Chiru Labs
578 
579 pragma solidity ^0.8.4;
580 
581 
582 
583 /**
584  * @dev Interface of an ERC721A compliant contract.
585  */
586 interface IERC721A is IERC721, IERC721Metadata {
587     /**
588      * The caller must own the token or be an approved operator.
589      */
590     error ApprovalCallerNotOwnerNorApproved();
591 
592     /**
593      * The token does not exist.
594      */
595     error ApprovalQueryForNonexistentToken();
596 
597     /**
598      * The caller cannot approve to their own address.
599      */
600     error ApproveToCaller();
601 
602     /**
603      * The caller cannot approve to the current owner.
604      */
605     error ApprovalToCurrentOwner();
606 
607     /**
608      * Cannot query the balance for the zero address.
609      */
610     error BalanceQueryForZeroAddress();
611 
612     /**
613      * Cannot mint to the zero address.
614      */
615     error MintToZeroAddress();
616 
617     /**
618      * The quantity of tokens minted must be more than zero.
619      */
620     error MintZeroQuantity();
621 
622     /**
623      * The token does not exist.
624      */
625     error OwnerQueryForNonexistentToken();
626 
627     /**
628      * The caller must own the token or be an approved operator.
629      */
630     error TransferCallerNotOwnerNorApproved();
631 
632     /**
633      * The token must be owned by `from`.
634      */
635     error TransferFromIncorrectOwner();
636 
637     /**
638      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
639      */
640     error TransferToNonERC721ReceiverImplementer();
641 
642     /**
643      * Cannot transfer to the zero address.
644      */
645     error TransferToZeroAddress();
646 
647     /**
648      * The token does not exist.
649      */
650     error URIQueryForNonexistentToken();
651 
652     // Compiler will pack this into a single 256bit word.
653     struct TokenOwnership {
654         // The address of the owner.
655         address addr;
656         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
657         uint64 startTimestamp;
658         // Whether the token has been burned.
659         bool burned;
660     }
661 
662     // Compiler will pack this into a single 256bit word.
663     struct AddressData {
664         // Realistically, 2**64-1 is more than enough.
665         uint64 balance;
666         // Keeps track of mint count with minimal overhead for tokenomics.
667         uint64 numberMinted;
668         // Keeps track of burn count with minimal overhead for tokenomics.
669         uint64 numberBurned;
670         // For miscellaneous variable(s) pertaining to the address
671         // (e.g. number of whitelist mint slots used).
672         // If there are multiple variables, please pack them into a uint64.
673         uint64 aux;
674     }
675 
676     /**
677      * @dev Returns the total amount of tokens stored by the contract.
678      * 
679      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
680      */
681     function totalSupply() external view returns (uint256);
682 }
683 
684 
685 // File: erc721a/contracts/ERC721A.sol
686 
687 // ERC721A Contracts v3.3.0
688 // Creator: Chiru Labs
689 
690 pragma solidity ^0.8.4;
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
697  *
698  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
699  *
700  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
701  */
702 contract ERC721A is Context, ERC165, IERC721A {
703     using Address for address;
704     using Strings for uint256;
705 
706     // The tokenId of the next token to be minted.
707     uint256 internal _currentIndex;
708 
709     // The number of tokens burned.
710     uint256 internal _burnCounter;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to ownership details
719     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
720     mapping(uint256 => TokenOwnership) internal _ownerships;
721 
722     // Mapping owner address to address data
723     mapping(address => AddressData) private _addressData;
724 
725     // Mapping from token ID to approved address
726     mapping(uint256 => address) private _tokenApprovals;
727 
728     // Mapping from owner to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     constructor(string memory name_, string memory symbol_) {
732         _name = name_;
733         _symbol = symbol_;
734         _currentIndex = _startTokenId();
735     }
736 
737     /**
738      * To change the starting tokenId, please override this function.
739      */
740     function _startTokenId() internal view virtual returns (uint256) {
741         return 0;
742     }
743 
744     /**
745      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
746      */
747     function totalSupply() public view override returns (uint256) {
748         // Counter underflow is impossible as _burnCounter cannot be incremented
749         // more than _currentIndex - _startTokenId() times
750         unchecked {
751             return _currentIndex - _burnCounter - _startTokenId();
752         }
753     }
754 
755     /**
756      * Returns the total amount of tokens minted in the contract.
757      */
758     function _totalMinted() internal view returns (uint256) {
759         // Counter underflow is impossible as _currentIndex does not decrement,
760         // and it is initialized to _startTokenId()
761         unchecked {
762             return _currentIndex - _startTokenId();
763         }
764     }
765 
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
770         return
771             interfaceId == type(IERC721).interfaceId ||
772             interfaceId == type(IERC721Metadata).interfaceId ||
773             super.supportsInterface(interfaceId);
774     }
775 
776     /**
777      * @dev See {IERC721-balanceOf}.
778      */
779     function balanceOf(address owner) public view override returns (uint256) {
780         if (owner == address(0)) revert BalanceQueryForZeroAddress();
781         return uint256(_addressData[owner].balance);
782     }
783 
784     /**
785      * Returns the number of tokens minted by `owner`.
786      */
787     function _numberMinted(address owner) internal view returns (uint256) {
788         return uint256(_addressData[owner].numberMinted);
789     }
790 
791     /**
792      * Returns the number of tokens burned by or on behalf of `owner`.
793      */
794     function _numberBurned(address owner) internal view returns (uint256) {
795         return uint256(_addressData[owner].numberBurned);
796     }
797 
798     /**
799      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
800      */
801     function _getAux(address owner) internal view returns (uint64) {
802         return _addressData[owner].aux;
803     }
804 
805     /**
806      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
807      * If there are multiple variables, please pack them into a uint64.
808      */
809     function _setAux(address owner, uint64 aux) internal {
810         _addressData[owner].aux = aux;
811     }
812 
813     /**
814      * Gas spent here starts off proportional to the maximum mint batch size.
815      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
816      */
817     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
818         uint256 curr = tokenId;
819 
820         unchecked {
821             if (_startTokenId() <= curr) if (curr < _currentIndex) {
822                 TokenOwnership memory ownership = _ownerships[curr];
823                 if (!ownership.burned) {
824                     if (ownership.addr != address(0)) {
825                         return ownership;
826                     }
827                     // Invariant:
828                     // There will always be an ownership that has an address and is not burned
829                     // before an ownership that does not have an address and is not burned.
830                     // Hence, curr will not underflow.
831                     while (true) {
832                         curr--;
833                         ownership = _ownerships[curr];
834                         if (ownership.addr != address(0)) {
835                             return ownership;
836                         }
837                     }
838                 }
839             }
840         }
841         revert OwnerQueryForNonexistentToken();
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view override returns (address) {
848         return _ownershipOf(tokenId).addr;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-name}.
853      */
854     function name() public view virtual override returns (string memory) {
855         return _name;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-symbol}.
860      */
861     function symbol() public view virtual override returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-tokenURI}.
867      */
868     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
869         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
870 
871         string memory baseURI = _baseURI();
872         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
873     }
874 
875     /**
876      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878      * by default, can be overriden in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return '';
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public virtual override {
888         address owner = ERC721A.ownerOf(tokenId);
889         if (to == owner) revert ApprovalToCurrentOwner();
890 
891         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
892             revert ApprovalCallerNotOwnerNorApproved();
893         }
894 
895         _approve(to, tokenId, owner);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view override returns (address) {
902         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public virtual override {
911         if (operator == _msgSender()) revert ApproveToCaller();
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public virtual override {
955         _transfer(from, to, tokenId);
956         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
957             revert TransferToNonERC721ReceiverImplementer();
958         }
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
970     }
971 
972     /**
973      * @dev Equivalent to `_safeMint(to, quantity, '')`.
974      */
975     function _safeMint(address to, uint256 quantity) internal {
976         _safeMint(to, quantity, '');
977     }
978 
979     /**
980      * @dev Safely mints `quantity` tokens and transfers them to `to`.
981      *
982      * Requirements:
983      *
984      * - If `to` refers to a smart contract, it must implement
985      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
986      * - `quantity` must be greater than 0.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(
991         address to,
992         uint256 quantity,
993         bytes memory _data
994     ) internal {
995         uint256 startTokenId = _currentIndex;
996         if (to == address(0)) revert MintToZeroAddress();
997         if (quantity == 0) revert MintZeroQuantity();
998 
999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1000 
1001         // Overflows are incredibly unrealistic.
1002         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1003         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1004         unchecked {
1005             _addressData[to].balance += uint64(quantity);
1006             _addressData[to].numberMinted += uint64(quantity);
1007 
1008             _ownerships[startTokenId].addr = to;
1009             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1010 
1011             uint256 updatedIndex = startTokenId;
1012             uint256 end = updatedIndex + quantity;
1013 
1014             if (to.isContract()) {
1015                 do {
1016                     emit Transfer(address(0), to, updatedIndex);
1017                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1018                         revert TransferToNonERC721ReceiverImplementer();
1019                     }
1020                 } while (updatedIndex < end);
1021                 // Reentrancy protection
1022                 if (_currentIndex != startTokenId) revert();
1023             } else {
1024                 do {
1025                     emit Transfer(address(0), to, updatedIndex++);
1026                 } while (updatedIndex < end);
1027             }
1028             _currentIndex = updatedIndex;
1029         }
1030         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1031     }
1032 
1033     /**
1034      * @dev Mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _mint(address to, uint256 quantity) internal {
1044         uint256 startTokenId = _currentIndex;
1045         if (to == address(0)) revert MintToZeroAddress();
1046         if (quantity == 0) revert MintZeroQuantity();
1047 
1048         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1049 
1050         // Overflows are incredibly unrealistic.
1051         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1052         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1053         unchecked {
1054             _addressData[to].balance += uint64(quantity);
1055             _addressData[to].numberMinted += uint64(quantity);
1056 
1057             _ownerships[startTokenId].addr = to;
1058             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1059 
1060             uint256 updatedIndex = startTokenId;
1061             uint256 end = updatedIndex + quantity;
1062 
1063             do {
1064                 emit Transfer(address(0), to, updatedIndex++);
1065             } while (updatedIndex < end);
1066 
1067             _currentIndex = updatedIndex;
1068         }
1069         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1070     }
1071 
1072     /**
1073      * @dev Transfers `tokenId` from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) private {
1087         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1088 
1089         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1090 
1091         bool isApprovedOrOwner = (_msgSender() == from ||
1092             isApprovedForAll(from, _msgSender()) ||
1093             getApproved(tokenId) == _msgSender());
1094 
1095         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1096         if (to == address(0)) revert TransferToZeroAddress();
1097 
1098         _beforeTokenTransfers(from, to, tokenId, 1);
1099 
1100         // Clear approvals from the previous owner
1101         _approve(address(0), tokenId, from);
1102 
1103         // Underflow of the sender's balance is impossible because we check for
1104         // ownership above and the recipient's balance can't realistically overflow.
1105         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1106         unchecked {
1107             _addressData[from].balance -= 1;
1108             _addressData[to].balance += 1;
1109 
1110             TokenOwnership storage currSlot = _ownerships[tokenId];
1111             currSlot.addr = to;
1112             currSlot.startTimestamp = uint64(block.timestamp);
1113 
1114             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1115             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1116             uint256 nextTokenId = tokenId + 1;
1117             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1118             if (nextSlot.addr == address(0)) {
1119                 // This will suffice for checking _exists(nextTokenId),
1120                 // as a burned slot cannot contain the zero address.
1121                 if (nextTokenId != _currentIndex) {
1122                     nextSlot.addr = from;
1123                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1124                 }
1125             }
1126         }
1127 
1128         emit Transfer(from, to, tokenId);
1129         _afterTokenTransfers(from, to, tokenId, 1);
1130     }
1131 
1132     /**
1133      * @dev Equivalent to `_burn(tokenId, false)`.
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         _burn(tokenId, false);
1137     }
1138 
1139     /**
1140      * @dev Destroys `tokenId`.
1141      * The approval is cleared when the token is burned.
1142      *
1143      * Requirements:
1144      *
1145      * - `tokenId` must exist.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1150         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1151 
1152         address from = prevOwnership.addr;
1153 
1154         if (approvalCheck) {
1155             bool isApprovedOrOwner = (_msgSender() == from ||
1156                 isApprovedForAll(from, _msgSender()) ||
1157                 getApproved(tokenId) == _msgSender());
1158 
1159             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         }
1161 
1162         _beforeTokenTransfers(from, address(0), tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             AddressData storage addressData = _addressData[from];
1172             addressData.balance -= 1;
1173             addressData.numberBurned += 1;
1174 
1175             // Keep track of who burned the token, and the timestamp of burning.
1176             TokenOwnership storage currSlot = _ownerships[tokenId];
1177             currSlot.addr = from;
1178             currSlot.startTimestamp = uint64(block.timestamp);
1179             currSlot.burned = true;
1180 
1181             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1182             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1183             uint256 nextTokenId = tokenId + 1;
1184             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1185             if (nextSlot.addr == address(0)) {
1186                 // This will suffice for checking _exists(nextTokenId),
1187                 // as a burned slot cannot contain the zero address.
1188                 if (nextTokenId != _currentIndex) {
1189                     nextSlot.addr = from;
1190                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, address(0), tokenId);
1196         _afterTokenTransfers(from, address(0), tokenId, 1);
1197 
1198         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1199         unchecked {
1200             _burnCounter++;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(
1210         address to,
1211         uint256 tokenId,
1212         address owner
1213     ) private {
1214         _tokenApprovals[tokenId] = to;
1215         emit Approval(owner, to, tokenId);
1216     }
1217 
1218 
1219     function _checkContractOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1226             return retval == IERC721Receiver(to).onERC721Received.selector;
1227         } catch (bytes memory reason) {
1228             if (reason.length == 0) {
1229                 revert TransferToNonERC721ReceiverImplementer();
1230             } else {
1231                 assembly {
1232                     revert(add(32, reason), mload(reason))
1233                 }
1234             }
1235         }
1236     }
1237 
1238  
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246 
1247     function _afterTokenTransfers(
1248         address from,
1249         address to,
1250         uint256 startTokenId,
1251         uint256 quantity
1252     ) internal virtual {}
1253 }
1254 
1255 
1256 // File: contracts/ALIENATORS.sol
1257 
1258 pragma solidity >= 0.8.0 < 0.9.0;
1259 
1260 contract ALIENATORS is ERC721A, Ownable, ReentrancyGuard, OperatorFilterer {
1261 
1262   using Strings for uint256;
1263   address public signerAddress;
1264 
1265   string public uriPrefix;
1266   string public notRevealedURI;
1267   string public uriSuffix = ".json";
1268   
1269   uint256 public cost = 0.09 ether;
1270   uint256 public maxSupply = 625;
1271   uint256 public PHASE_MAX_SUPPLY = 625;
1272 
1273   uint256 public MaxperTx = 2;
1274   uint256 public nftPerAddressLimit = 2;
1275 
1276   bool public paused = false;
1277   uint256 public revealed = 0;
1278 
1279   bool public publicMintEnabled = false;
1280   bool public whitelistMintEnabled = false;
1281 
1282   mapping(address => uint256) public addressMintedBalance;
1283 
1284   constructor( address _signerAddress ) ERC721A ( "ALIENATORS", "AMB" ) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), false) {
1285     signerAddress = _signerAddress;
1286   }
1287 
1288 // ~~~~~~~~~~~~~~~~~~~~ URI's ~~~~~~~~~~~~~~~~~~~~
1289 
1290   function _baseURI() internal view virtual override returns (string memory) {
1291     return uriPrefix;
1292   }
1293 
1294 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1295 
1296   modifier mintCompliance(uint256 _mintAmount) {
1297     require(!paused, "The contract is paused!");
1298     require(_mintAmount > 0, "Mint amount can't be zero.");
1299     require(_mintAmount <= MaxperTx, "Max mint per transaction exceeded!");
1300     require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!");
1301     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1302     _;
1303   }
1304 
1305   modifier mintPriceCompliance(uint256 _mintAmount) {
1306     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1307     _;
1308   }
1309 
1310 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1311   
1312   // PUBLIC MINT
1313   function mint(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1314     require(publicMintEnabled, "Public mint is not active yet!");
1315     require(totalSupply() + _mintAmount < PHASE_MAX_SUPPLY, "Alienators: Phase mint limit reached!");
1316 
1317     addressMintedBalance[msg.sender] += _mintAmount;
1318     _safeMint(_msgSender(), _mintAmount);
1319   }
1320   
1321   // WHITELIST MINT
1322   function mintWhitelist(uint256 _mintAmount, bytes memory sig) public mintCompliance(_mintAmount) {
1323     require(whitelistMintEnabled, "Whitelist mint is not active yet!");
1324     require(isValidData(msg.sender, sig) == true, "User is not whitelisted!");
1325     require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max Whitelist mint exceeded!");
1326 
1327     addressMintedBalance[msg.sender] += _mintAmount;
1328     _safeMint(_msgSender(), _mintAmount);
1329   }
1330 
1331   // MINT for address
1332   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1333     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1334     _safeMint(_receiver, _mintAmount);
1335   }
1336 
1337 // ~~~~~~~~~~~~~~~~~~~~ SIGNATURES ~~~~~~~~~~~~~~~~~~~~
1338   function isValidData(address _user, bytes memory sig) public view returns (bool) {
1339     bytes32 message = keccak256(abi.encodePacked(_user));
1340     return (recoverSigner(message, sig) == signerAddress);
1341   }
1342 
1343   function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address) {
1344     uint8 v; bytes32 r; bytes32 s;
1345     (v, r, s) = splitSignature(sig);
1346     return ecrecover(message, v, r, s);
1347   }
1348 
1349   function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32) {
1350     require(sig.length == 65);
1351     bytes32 r; bytes32 s; uint8 v;
1352     assembly { r := mload(add(sig, 32)) s := mload(add(sig, 64)) v := byte(0, mload(add(sig, 96))) }
1353     return (v, r, s);
1354   }
1355 
1356 // ~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~
1357 
1358   // Check Wallet assets
1359   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1360     uint256 ownerTokenCount = balanceOf(_owner);
1361     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1362     uint256 currentTokenId = _startTokenId();
1363     uint256 ownedTokenIndex = 0;
1364     address latestOwnerAddress;
1365 
1366     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1367       TokenOwnership memory ownership = _ownerships[currentTokenId];
1368 
1369       if (!ownership.burned) {
1370         if (ownership.addr != address(0)) {
1371           latestOwnerAddress = ownership.addr;
1372         }
1373 
1374         if (latestOwnerAddress == _owner) {
1375           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1376           ownedTokenIndex++;
1377         }
1378       }
1379       currentTokenId++;
1380     }
1381     return ownedTokenIds;
1382   }
1383 
1384   // Start Token
1385   function _startTokenId() internal view virtual override returns (uint256) {
1386     return 1;
1387   }
1388 
1389   // TOKEN URI
1390   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1391     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1392     
1393     if (_tokenId > revealed) { return notRevealedURI; }
1394 
1395     string memory currentBaseURI = _baseURI();
1396     return bytes(currentBaseURI).length > 0
1397     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1398     : "";
1399   }
1400 
1401 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1402 
1403   // SIGNER
1404   function setSigner(address _newSigner) public onlyOwner {
1405     signerAddress = _newSigner;
1406   }
1407 
1408   // REVEALED AMOUNT
1409   function setRevealed(uint256 _revealedAmount) public onlyOwner {
1410     revealed = _revealedAmount;
1411   }
1412   
1413   // PAUSE
1414   function setPaused(bool _state) public onlyOwner {
1415     paused = _state;
1416   }
1417 
1418   // SET COST
1419   function setCost(uint256 _cost) public onlyOwner {
1420     cost = _cost;
1421   }
1422 
1423   // SET MAX SUPPLY
1424   function setMaxSupply(uint256 _MaxSupply) public onlyOwner {
1425     maxSupply = _MaxSupply;
1426   }
1427 
1428   // SET PHASE MAX SUPPLY
1429   function setPhaseMaxSupply(uint256 _phaseMaxSupply) public onlyOwner {
1430     PHASE_MAX_SUPPLY = _phaseMaxSupply;
1431   }
1432   
1433   // SET MAX MINT PER TRX
1434   function setMaxMintPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1435     MaxperTx = _maxMintAmountPerTx;
1436   }
1437   
1438   // SET MAX PER ADDRESS LIMIT
1439   function setMaxPerAddLimit(uint256 _maxPerAddLimit) public onlyOwner {
1440     nftPerAddressLimit = _maxPerAddLimit;
1441   }
1442 
1443   // SET BASE URI
1444   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1445     uriPrefix = _uriPrefix;
1446   }
1447   
1448   // SET HIDDEN URI
1449   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1450     notRevealedURI = _notRevealedURI;
1451   }
1452 
1453   // SET PUBLIC MINT STATE
1454   function setPublicMintState(bool _state) public onlyOwner {
1455     publicMintEnabled = _state;
1456   }
1457 
1458   // SET WHITELIST MINT STATE
1459   function setWLMintState(bool _state) public onlyOwner {
1460     whitelistMintEnabled = _state;
1461   }
1462 
1463   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1464     super.setApprovalForAll(operator, approved);
1465   }
1466 
1467   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1468     super.approve(operator, tokenId);
1469   }
1470 
1471   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1472     super.transferFrom(from, to, tokenId);
1473   }
1474 
1475   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1476     super.safeTransferFrom(from, to, tokenId);
1477   }
1478 
1479   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
1480     super.safeTransferFrom(from, to, tokenId, data);
1481   }
1482 
1483   function withdraw() public onlyOwner nonReentrant {
1484     (bool os, ) = payable(0x3aB45C090472F3b12bCA53f8D16A4Cc34ac6B2ea).call{value: address(this).balance}('');
1485     require(os);
1486   }
1487 }