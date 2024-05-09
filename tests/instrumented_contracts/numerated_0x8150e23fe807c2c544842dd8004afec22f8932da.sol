1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5  ######    #######  ########  #### ##       ##          ###        ######      ###    ########  ########  ######## ##    ## 
6 ##    ##  ##     ## ##     ##  ##  ##       ##         ## ##      ##    ##    ## ##   ##     ## ##     ## ##       ###   ## 
7 ##        ##     ## ##     ##  ##  ##       ##        ##   ##     ##         ##   ##  ##     ## ##     ## ##       ####  ## 
8 ##   #### ##     ## ########   ##  ##       ##       ##     ##    ##   #### ##     ## ########  ##     ## ######   ## ## ## 
9 ##    ##  ##     ## ##   ##    ##  ##       ##       #########    ##    ##  ######### ##   ##   ##     ## ##       ##  #### 
10 ##    ##  ##     ## ##    ##   ##  ##       ##       ##     ##    ##    ##  ##     ## ##    ##  ##     ## ##       ##   ### 
11  ######    #######  ##     ## #### ######## ######## ##     ##     ######   ##     ## ##     ## ########  ######## ##    ##  
12 
13 */
14 
15 pragma solidity ^0.8.13;
16 
17 interface IOperatorFilterRegistry {
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19     function register(address registrant) external;
20     function registerAndSubscribe(address registrant, address subscription) external;
21     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
22     function unregister(address addr) external;
23     function updateOperator(address registrant, address operator, bool filtered) external;
24     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
25     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
26     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
27     function subscribe(address registrant, address registrantToSubscribe) external;
28     function unsubscribe(address registrant, bool copyExistingEntries) external;
29     function subscriptionOf(address addr) external returns (address registrant);
30     function subscribers(address registrant) external returns (address[] memory);
31     function subscriberAt(address registrant, uint256 index) external returns (address);
32     function copyEntriesOf(address registrant, address registrantToCopy) external;
33     function isOperatorFiltered(address registrant, address operator) external returns (bool);
34     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
35     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
36     function filteredOperators(address addr) external returns (address[] memory);
37     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
38     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
39     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
40     function isRegistered(address addr) external returns (bool);
41     function codeHashOf(address addr) external returns (bytes32);
42 }
43 
44 pragma solidity ^0.8.13;
45 
46 /**
47  * @title  OperatorFilterer
48  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
49  *         registrant's entries in the OperatorFilterRegistry.
50  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
51  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
52  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
53  */
54 abstract contract OperatorFilterer {
55     error OperatorNotAllowed(address operator);
56 
57     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
58         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
59 
60     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
61         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
62         // will not revert, but the contract will need to be registered with the registry once it is deployed in
63         // order for the modifier to filter addresses.
64         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
65             if (subscribe) {
66                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
67             } else {
68                 if (subscriptionOrRegistrantToCopy != address(0)) {
69                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
70                 } else {
71                     OPERATOR_FILTER_REGISTRY.register(address(this));
72                 }
73             }
74         }
75     }
76 
77     modifier onlyAllowedOperator(address from) virtual {
78         // Allow spending tokens from addresses with balance
79         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80         // from an EOA.
81         if (from != msg.sender) {
82             _checkFilterOperator(msg.sender);
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         _checkFilterOperator(operator);
89         _;
90     }
91 
92     function _checkFilterOperator(address operator) internal view virtual {
93         // Check registry code length to facilitate testing in environments without a deployed registry.
94         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
95             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
96                 revert OperatorNotAllowed(operator);
97             }
98         }
99     }
100 }
101 
102 
103 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
104 
105 pragma solidity ^0.8.0;
106 
107 abstract contract ReentrancyGuard {
108     
109     uint256 private constant _NOT_ENTERED = 1;
110     uint256 private constant _ENTERED = 2;
111 
112     uint256 private _status;
113 
114     constructor() {
115         _status = _NOT_ENTERED;
116     }
117 
118     modifier nonReentrant() {
119         // On the first call to nonReentrant, _notEntered will be true
120         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
121 
122         // Any calls to nonReentrant after this point will fail
123         _status = _ENTERED;
124 
125         _;
126 
127         _status = _NOT_ENTERED;
128     }
129 }
130 
131 
132 // File: @openzeppelin/contracts/utils/Strings.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev String operations.
141  */
142 library Strings {
143     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
144 
145     function toString(uint256 value) internal pure returns (string memory) {
146 
147         if (value == 0) {
148             return "0";
149         }
150         uint256 temp = value;
151         uint256 digits;
152         while (temp != 0) {
153             digits++;
154             temp /= 10;
155         }
156         bytes memory buffer = new bytes(digits);
157         while (value != 0) {
158             digits -= 1;
159             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
160             value /= 10;
161         }
162         return string(buffer);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
167      */
168     function toHexString(uint256 value) internal pure returns (string memory) {
169         if (value == 0) {
170             return "0x00";
171         }
172         uint256 temp = value;
173         uint256 length = 0;
174         while (temp != 0) {
175             length++;
176             temp >>= 8;
177         }
178         return toHexString(value, length);
179     }
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
183      */
184     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
185         bytes memory buffer = new bytes(2 * length + 2);
186         buffer[0] = "0";
187         buffer[1] = "x";
188         for (uint256 i = 2 * length + 1; i > 1; --i) {
189             buffer[i] = _HEX_SYMBOLS[value & 0xf];
190             value >>= 4;
191         }
192         require(value == 0, "Strings: hex length insufficient");
193         return string(buffer);
194     }
195 }
196 
197 // File: @openzeppelin/contracts/utils/Context.sol
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 abstract contract Context {
205     function _msgSender() internal view virtual returns (address) {
206         return msg.sender;
207     }
208 
209     function _msgData() internal view virtual returns (bytes calldata) {
210         return msg.data;
211     }
212 }
213 
214 
215 // File: @openzeppelin/contracts/access/Ownable.sol
216 
217 pragma solidity ^0.8.0;
218 
219 abstract contract Ownable is Context {
220     address private _owner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() {
228         _transferOwnership(_msgSender());
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _transferOwnership(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _transferOwnership(newOwner);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Internal function without access restriction.
269      */
270     function _transferOwnership(address newOwner) internal virtual {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
281 
282 pragma solidity ^0.8.1;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     
289     function isContract(address account) internal view returns (bool) {
290         return account.code.length > 0;
291     }
292 
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionCall(target, data, "Address: low-level call failed");
302     }
303 
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 interface IERC721Receiver {
424   
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 abstract contract ERC165 is IERC165 {
461     /**
462      * @dev See {IERC165-supportsInterface}.
463      */
464     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
465         return interfaceId == type(IERC165).interfaceId;
466     }
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
470 
471 
472 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Required interface of an ERC721 compliant contract.
479  */
480 interface IERC721 is IERC165 {
481     /**
482      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
483      */
484     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
485 
486     /**
487      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
488      */
489     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
493      */
494     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
495 
496     /**
497      * @dev Returns the number of tokens in ``owner``'s account.
498      */
499     function balanceOf(address owner) external view returns (uint256 balance);
500 
501   
502     function ownerOf(uint256 tokenId) external view returns (address owner);
503 
504 
505     function safeTransferFrom(
506         address from,
507         address to,
508         uint256 tokenId,
509         bytes calldata data
510     ) external;
511 
512   
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519  
520     function transferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526 
527     function approve(address to, uint256 tokenId) external;
528 
529 
530     function setApprovalForAll(address operator, bool _approved) external;
531 
532 
533     function getApproved(uint256 tokenId) external view returns (address operator);
534 
535     /**
536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
537      *
538      * See {setApprovalForAll}
539      */
540     function isApprovedForAll(address owner, address operator) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 interface IERC721Metadata is IERC721 {
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() external view returns (string memory);
560 
561     /**
562      * @dev Returns the token collection symbol.
563      */
564     function symbol() external view returns (string memory);
565 
566     /**
567      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
568      */
569     function tokenURI(uint256 tokenId) external view returns (string memory);
570 }
571 
572 // File: erc721a/contracts/IERC721A.sol
573 
574 
575 // ERC721A Contracts v3.3.0
576 // Creator: Chiru Labs
577 
578 pragma solidity ^0.8.4;
579 
580 
581 
582 /**
583  * @dev Interface of an ERC721A compliant contract.
584  */
585 interface IERC721A is IERC721, IERC721Metadata {
586     /**
587      * The caller must own the token or be an approved operator.
588      */
589     error ApprovalCallerNotOwnerNorApproved();
590 
591     /**
592      * The token does not exist.
593      */
594     error ApprovalQueryForNonexistentToken();
595 
596     /**
597      * The caller cannot approve to their own address.
598      */
599     error ApproveToCaller();
600 
601     /**
602      * The caller cannot approve to the current owner.
603      */
604     error ApprovalToCurrentOwner();
605 
606     /**
607      * Cannot query the balance for the zero address.
608      */
609     error BalanceQueryForZeroAddress();
610 
611     /**
612      * Cannot mint to the zero address.
613      */
614     error MintToZeroAddress();
615 
616     /**
617      * The quantity of tokens minted must be more than zero.
618      */
619     error MintZeroQuantity();
620 
621     /**
622      * The token does not exist.
623      */
624     error OwnerQueryForNonexistentToken();
625 
626     /**
627      * The caller must own the token or be an approved operator.
628      */
629     error TransferCallerNotOwnerNorApproved();
630 
631     /**
632      * The token must be owned by `from`.
633      */
634     error TransferFromIncorrectOwner();
635 
636     /**
637      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
638      */
639     error TransferToNonERC721ReceiverImplementer();
640 
641     /**
642      * Cannot transfer to the zero address.
643      */
644     error TransferToZeroAddress();
645 
646     /**
647      * The token does not exist.
648      */
649     error URIQueryForNonexistentToken();
650 
651     // Compiler will pack this into a single 256bit word.
652     struct TokenOwnership {
653         // The address of the owner.
654         address addr;
655         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
656         uint64 startTimestamp;
657         // Whether the token has been burned.
658         bool burned;
659     }
660 
661     // Compiler will pack this into a single 256bit word.
662     struct AddressData {
663         // Realistically, 2**64-1 is more than enough.
664         uint64 balance;
665         // Keeps track of mint count with minimal overhead for tokenomics.
666         uint64 numberMinted;
667         // Keeps track of burn count with minimal overhead for tokenomics.
668         uint64 numberBurned;
669         // For miscellaneous variable(s) pertaining to the address
670         // (e.g. number of whitelist mint slots used).
671         // If there are multiple variables, please pack them into a uint64.
672         uint64 aux;
673     }
674 
675     /**
676      * @dev Returns the total amount of tokens stored by the contract.
677      * 
678      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
679      */
680     function totalSupply() external view returns (uint256);
681 }
682 
683 
684 // File: erc721a/contracts/ERC721A.sol
685 
686 // ERC721A Contracts v3.3.0
687 // Creator: Chiru Labs
688 
689 pragma solidity ^0.8.4;
690 
691 /**
692  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
693  * the Metadata extension. Built to optimize for lower gas during batch mints.
694  *
695  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
696  *
697  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
698  *
699  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
700  */
701 contract ERC721A is Context, ERC165, IERC721A {
702     using Address for address;
703     using Strings for uint256;
704 
705     // The tokenId of the next token to be minted.
706     uint256 internal _currentIndex;
707 
708     // The number of tokens burned.
709     uint256 internal _burnCounter;
710 
711     // Token name
712     string private _name;
713 
714     // Token symbol
715     string private _symbol;
716 
717     // Mapping from token ID to ownership details
718     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
719     mapping(uint256 => TokenOwnership) internal _ownerships;
720 
721     // Mapping owner address to address data
722     mapping(address => AddressData) private _addressData;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733         _currentIndex = _startTokenId();
734     }
735 
736     /**
737      * To change the starting tokenId, please override this function.
738      */
739     function _startTokenId() internal view virtual returns (uint256) {
740         return 0;
741     }
742 
743     /**
744      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
745      */
746     function totalSupply() public view override returns (uint256) {
747         // Counter underflow is impossible as _burnCounter cannot be incremented
748         // more than _currentIndex - _startTokenId() times
749         unchecked {
750             return _currentIndex - _burnCounter - _startTokenId();
751         }
752     }
753 
754     /**
755      * Returns the total amount of tokens minted in the contract.
756      */
757     function _totalMinted() internal view returns (uint256) {
758         // Counter underflow is impossible as _currentIndex does not decrement,
759         // and it is initialized to _startTokenId()
760         unchecked {
761             return _currentIndex - _startTokenId();
762         }
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view override returns (uint256) {
779         if (owner == address(0)) revert BalanceQueryForZeroAddress();
780         return uint256(_addressData[owner].balance);
781     }
782 
783     /**
784      * Returns the number of tokens minted by `owner`.
785      */
786     function _numberMinted(address owner) internal view returns (uint256) {
787         return uint256(_addressData[owner].numberMinted);
788     }
789 
790     /**
791      * Returns the number of tokens burned by or on behalf of `owner`.
792      */
793     function _numberBurned(address owner) internal view returns (uint256) {
794         return uint256(_addressData[owner].numberBurned);
795     }
796 
797     /**
798      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
799      */
800     function _getAux(address owner) internal view returns (uint64) {
801         return _addressData[owner].aux;
802     }
803 
804     /**
805      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
806      * If there are multiple variables, please pack them into a uint64.
807      */
808     function _setAux(address owner, uint64 aux) internal {
809         _addressData[owner].aux = aux;
810     }
811 
812     /**
813      * Gas spent here starts off proportional to the maximum mint batch size.
814      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
815      */
816     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
817         uint256 curr = tokenId;
818 
819         unchecked {
820             if (_startTokenId() <= curr) if (curr < _currentIndex) {
821                 TokenOwnership memory ownership = _ownerships[curr];
822                 if (!ownership.burned) {
823                     if (ownership.addr != address(0)) {
824                         return ownership;
825                     }
826                     // Invariant:
827                     // There will always be an ownership that has an address and is not burned
828                     // before an ownership that does not have an address and is not burned.
829                     // Hence, curr will not underflow.
830                     while (true) {
831                         curr--;
832                         ownership = _ownerships[curr];
833                         if (ownership.addr != address(0)) {
834                             return ownership;
835                         }
836                     }
837                 }
838             }
839         }
840         revert OwnerQueryForNonexistentToken();
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return _ownershipOf(tokenId).addr;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public override virtual {
887         address owner = ERC721A.ownerOf(tokenId);
888         if (to == owner) revert ApprovalToCurrentOwner();
889 
890         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
891             revert ApprovalCallerNotOwnerNorApproved();
892         }
893 
894         _approve(to, tokenId, owner);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view override returns (address) {
901         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public virtual override {
910         if (operator == _msgSender()) revert ApproveToCaller();
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public virtual override {
954         _transfer(from, to, tokenId);
955         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
956             revert TransferToNonERC721ReceiverImplementer();
957         }
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      */
967     function _exists(uint256 tokenId) internal view returns (bool) {
968         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
969     }
970 
971     /**
972      * @dev Equivalent to `_safeMint(to, quantity, '')`.
973      */
974     function _safeMint(address to, uint256 quantity) internal {
975         _safeMint(to, quantity, '');
976     }
977 
978     /**
979      * @dev Safely mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - If `to` refers to a smart contract, it must implement
984      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
985      * - `quantity` must be greater than 0.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeMint(
990         address to,
991         uint256 quantity,
992         bytes memory _data
993     ) internal {
994         uint256 startTokenId = _currentIndex;
995         if (to == address(0)) revert MintToZeroAddress();
996         if (quantity == 0) revert MintZeroQuantity();
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         // Overflows are incredibly unrealistic.
1001         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1002         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1003         unchecked {
1004             _addressData[to].balance += uint64(quantity);
1005             _addressData[to].numberMinted += uint64(quantity);
1006 
1007             _ownerships[startTokenId].addr = to;
1008             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1009 
1010             uint256 updatedIndex = startTokenId;
1011             uint256 end = updatedIndex + quantity;
1012 
1013             if (to.isContract()) {
1014                 do {
1015                     emit Transfer(address(0), to, updatedIndex);
1016                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1017                         revert TransferToNonERC721ReceiverImplementer();
1018                     }
1019                 } while (updatedIndex < end);
1020                 // Reentrancy protection
1021                 if (_currentIndex != startTokenId) revert();
1022             } else {
1023                 do {
1024                     emit Transfer(address(0), to, updatedIndex++);
1025                 } while (updatedIndex < end);
1026             }
1027             _currentIndex = updatedIndex;
1028         }
1029         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1030     }
1031 
1032     /**
1033      * @dev Mints `quantity` tokens and transfers them to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `quantity` must be greater than 0.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _mint(address to, uint256 quantity) internal {
1043         uint256 startTokenId = _currentIndex;
1044         if (to == address(0)) revert MintToZeroAddress();
1045         if (quantity == 0) revert MintZeroQuantity();
1046 
1047         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1048 
1049         // Overflows are incredibly unrealistic.
1050         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1051         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1052         unchecked {
1053             _addressData[to].balance += uint64(quantity);
1054             _addressData[to].numberMinted += uint64(quantity);
1055 
1056             _ownerships[startTokenId].addr = to;
1057             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1058 
1059             uint256 updatedIndex = startTokenId;
1060             uint256 end = updatedIndex + quantity;
1061 
1062             do {
1063                 emit Transfer(address(0), to, updatedIndex++);
1064             } while (updatedIndex < end);
1065 
1066             _currentIndex = updatedIndex;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _transfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) private {
1086         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1087 
1088         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1089 
1090         bool isApprovedOrOwner = (_msgSender() == from ||
1091             isApprovedForAll(from, _msgSender()) ||
1092             getApproved(tokenId) == _msgSender());
1093 
1094         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1095         if (to == address(0)) revert TransferToZeroAddress();
1096 
1097         _beforeTokenTransfers(from, to, tokenId, 1);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId, from);
1101 
1102         // Underflow of the sender's balance is impossible because we check for
1103         // ownership above and the recipient's balance can't realistically overflow.
1104         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1105         unchecked {
1106             _addressData[from].balance -= 1;
1107             _addressData[to].balance += 1;
1108 
1109             TokenOwnership storage currSlot = _ownerships[tokenId];
1110             currSlot.addr = to;
1111             currSlot.startTimestamp = uint64(block.timestamp);
1112 
1113             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1114             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115             uint256 nextTokenId = tokenId + 1;
1116             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1117             if (nextSlot.addr == address(0)) {
1118                 // This will suffice for checking _exists(nextTokenId),
1119                 // as a burned slot cannot contain the zero address.
1120                 if (nextTokenId != _currentIndex) {
1121                     nextSlot.addr = from;
1122                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, to, tokenId);
1128         _afterTokenTransfers(from, to, tokenId, 1);
1129     }
1130 
1131     /**
1132      * @dev Equivalent to `_burn(tokenId, false)`.
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         _burn(tokenId, false);
1136     }
1137 
1138     /**
1139      * @dev Destroys `tokenId`.
1140      * The approval is cleared when the token is burned.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1149         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1150 
1151         address from = prevOwnership.addr;
1152 
1153         if (approvalCheck) {
1154             bool isApprovedOrOwner = (_msgSender() == from ||
1155                 isApprovedForAll(from, _msgSender()) ||
1156                 getApproved(tokenId) == _msgSender());
1157 
1158             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1159         }
1160 
1161         _beforeTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId, from);
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             AddressData storage addressData = _addressData[from];
1171             addressData.balance -= 1;
1172             addressData.numberBurned += 1;
1173 
1174             // Keep track of who burned the token, and the timestamp of burning.
1175             TokenOwnership storage currSlot = _ownerships[tokenId];
1176             currSlot.addr = from;
1177             currSlot.startTimestamp = uint64(block.timestamp);
1178             currSlot.burned = true;
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1184             if (nextSlot.addr == address(0)) {
1185                 // This will suffice for checking _exists(nextTokenId),
1186                 // as a burned slot cannot contain the zero address.
1187                 if (nextTokenId != _currentIndex) {
1188                     nextSlot.addr = from;
1189                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, address(0), tokenId);
1195         _afterTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1198         unchecked {
1199             _burnCounter++;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Approve `to` to operate on `tokenId`
1205      *
1206      * Emits a {Approval} event.
1207      */
1208     function _approve(
1209         address to,
1210         uint256 tokenId,
1211         address owner
1212     ) private {
1213         _tokenApprovals[tokenId] = to;
1214         emit Approval(owner, to, tokenId);
1215     }
1216 
1217     function _checkContractOnERC721Received(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory _data
1222     ) private returns (bool) {
1223         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1224             return retval == IERC721Receiver(to).onERC721Received.selector;
1225         } catch (bytes memory reason) {
1226             if (reason.length == 0) {
1227                 revert TransferToNonERC721ReceiverImplementer();
1228             } else {
1229                 assembly {
1230                     revert(add(32, reason), mload(reason))
1231                 }
1232             }
1233         }
1234     }
1235  
1236     function _beforeTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     function _afterTokenTransfers(
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 }
1250 
1251 pragma solidity >=0.8.9 <0.9.0;
1252 
1253 contract GORILLA_GARDEN is ERC721A, Ownable, ReentrancyGuard, OperatorFilterer {
1254 
1255   using Strings for uint256;
1256 
1257   string public uriPrefix;
1258   string public notRevealedURI;
1259   string public uriSuffix = ".json";
1260   
1261   uint256 public cost = 0.0039 ether;
1262 
1263   uint256 public maxSupply = 5555;
1264 
1265   uint256 public MaxperTx = 10;
1266   uint256 public nftPerAddressLimit = 10;
1267   uint256 public maxFree = 1;
1268 
1269   bool public paused = true;
1270   bool public revealed = false;
1271 
1272   mapping(address => uint256) public freeClaimed;
1273   mapping(address => uint256) public addressMintedBalance;
1274 
1275   constructor() ERC721A ( "Gorilla Garden", "GG" ) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {
1276     setNotRevealedURI( "ipfs://QmZ2xRZBAPDRZqFEFE5YZdcovh9uGPrsXEZRZspTfYfbJG/hidden.json" );
1277   }
1278 
1279 // ~~~~~~~~~~~~~~~~~~~~ URI's ~~~~~~~~~~~~~~~~~~~~
1280 
1281   function _baseURI() internal view virtual override returns (string memory) {
1282     return uriPrefix;
1283   }
1284 
1285 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1286 
1287   modifier mintCompliance(uint256 _mintAmount) {
1288     require(!paused, "The contract is paused!");
1289     require(_mintAmount > 0, "Mint amount can't be zero.");
1290     require(_mintAmount <= MaxperTx, "Max mint per transaction exceeded!");
1291     require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!");
1292     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1293     _;
1294   }
1295 
1296 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1297 
1298   // PUBLIC MINT
1299   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1300     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1301     
1302     addressMintedBalance[msg.sender] += _mintAmount;
1303     _safeMint(_msgSender(), _mintAmount);
1304   }
1305 
1306   // FREE MINT
1307   function mintfree() public {
1308     require(!paused, "The contract is paused!");
1309     require(totalSupply() + 1 <= maxSupply, "Mint amount exceeds max supply!");
1310     require(freeClaimed[msg.sender] + 1 <= maxFree, "Max free mint per address exceeded!");
1311 
1312     freeClaimed[msg.sender] += 1;
1313     _safeMint(_msgSender(), 1);
1314   }
1315 
1316   // MINT for address
1317   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1318     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1319     _safeMint(_receiver, _mintAmount);
1320   }
1321   
1322   // MASS AIRDROP
1323   function massAirdrop(address[] calldata _wallets) external onlyOwner {
1324     for (uint256 i; i < _wallets.length; ++i) {
1325       require(totalSupply() + 1 <= maxSupply, "Max supply exceeded!");
1326       _safeMint(_wallets[i], 1);
1327     }
1328   }
1329 
1330 // ~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~
1331 
1332   // Check Wallet assets
1333   function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1334     uint256 ownerTokenCount = balanceOf(_owner);
1335     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1336     uint256 currentTokenId = _startTokenId();
1337     uint256 ownedTokenIndex = 0;
1338     address latestOwnerAddress;
1339 
1340     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1341       TokenOwnership memory ownership = _ownerships[currentTokenId];
1342 
1343       if (!ownership.burned) {
1344         if (ownership.addr != address(0)) {
1345           latestOwnerAddress = ownership.addr;
1346         }
1347 
1348         if (latestOwnerAddress == _owner) {
1349           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1350           ownedTokenIndex++;
1351         }
1352       }
1353       currentTokenId++;
1354     }
1355     return ownedTokenIds;
1356   }
1357 
1358   // Start Token
1359   function _startTokenId() internal view virtual override returns (uint256) {
1360     return 1;
1361   }
1362 
1363   // TOKEN URI
1364   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1365     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1366     
1367     if (revealed == false) { return notRevealedURI; }
1368 
1369     string memory currentBaseURI = _baseURI();
1370     return bytes(currentBaseURI).length > 0
1371     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1372     : "";
1373     }
1374 
1375 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1376   // Set Cost
1377   function setCost(uint256 _cost) public onlyOwner {
1378     cost = _cost;
1379   }
1380   
1381   // Set Max Per Transaction
1382   function setMaxperTx(uint256 _maxMintperTx) public onlyOwner {
1383     MaxperTx = _maxMintperTx;
1384   }
1385   
1386   // Set Max Free Mint Per Wallet
1387   function setMaxFree(uint256 _maxFree) public onlyOwner {
1388     maxFree = _maxFree;
1389   }
1390   
1391   // Set Max Per Address Limit
1392   function setNftPerAddressLimit(uint256 _maxPerAddress) public onlyOwner {
1393     nftPerAddressLimit = _maxPerAddress;
1394   }
1395 
1396   // BaseURI
1397   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1398     uriPrefix = _uriPrefix;
1399   }
1400 
1401   // NotRevealedURI
1402   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1403     notRevealedURI = _notRevealedURI;
1404   }
1405 
1406   function pause() public onlyOwner {
1407     if (paused == true) { paused = false; }
1408     else { paused = true; }
1409   }
1410 
1411   function reveal() public onlyOwner {
1412     if (revealed == true) { revealed = false; }
1413     else { revealed = true; }
1414   }
1415 
1416   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1417         super.transferFrom(from, to, tokenId);
1418   }
1419 
1420   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1421         super.safeTransferFrom(from, to, tokenId);
1422   }
1423 
1424   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
1425         super.safeTransferFrom(from, to, tokenId, data);
1426   }
1427 
1428   function withdraw() external onlyOwner nonReentrant {
1429     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1430     require(success);
1431   }
1432 }