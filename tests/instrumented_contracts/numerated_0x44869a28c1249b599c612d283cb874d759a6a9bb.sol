1 // SPDX-License-Identifier: MIT
2 
3 // https://boredroosteryachtclub.xyz
4 // https://twitter.com/BoredRoosterYC
5 
6 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
7 
8 pragma solidity ^0.8.13;
9 
10 interface IOperatorFilterRegistry {
11     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
12     function register(address registrant) external;
13     function registerAndSubscribe(address registrant, address subscription) external;
14     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
15     function updateOperator(address registrant, address operator, bool filtered) external;
16     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
17     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
18     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
19     function subscribe(address registrant, address registrantToSubscribe) external;
20     function unsubscribe(address registrant, bool copyExistingEntries) external;
21     function subscriptionOf(address addr) external returns (address registrant);
22     function subscribers(address registrant) external returns (address[] memory);
23     function subscriberAt(address registrant, uint256 index) external returns (address);
24     function copyEntriesOf(address registrant, address registrantToCopy) external;
25     function isOperatorFiltered(address registrant, address operator) external returns (bool);
26     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
27     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
28     function filteredOperators(address addr) external returns (address[] memory);
29     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
30     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
31     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
32     function isRegistered(address addr) external returns (bool);
33     function codeHashOf(address addr) external returns (bytes32);
34 }
35 
36 
37 // File contracts/OperatorFilter/OperatorFilterer.sol
38 
39 
40 pragma solidity ^0.8.13;
41 
42 abstract contract OperatorFilterer {
43     error OperatorNotAllowed(address operator);
44 
45     IOperatorFilterRegistry constant operatorFilterRegistry =
46         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
47 
48     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
49         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
50         // will not revert, but the contract will need to be registered with the registry once it is deployed in
51         // order for the modifier to filter addresses.
52         if (address(operatorFilterRegistry).code.length > 0) {
53             if (subscribe) {
54                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
55             } else {
56                 if (subscriptionOrRegistrantToCopy != address(0)) {
57                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
58                 } else {
59                     operatorFilterRegistry.register(address(this));
60                 }
61             }
62         }
63     }
64 
65     modifier onlyAllowedOperator(address from) virtual {
66         // Check registry code length to facilitate testing in environments without a deployed registry.
67         if (address(operatorFilterRegistry).code.length > 0) {
68             // Allow spending tokens from addresses with balance
69             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
70             // from an EOA.
71             if (from == msg.sender) {
72                 _;
73                 return;
74             }
75             if (
76                 !(
77                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
78                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
79                 )
80             ) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 }
87 
88 
89 // File contracts/OperatorFilter/DefaultOperatorFilterer.sol
90 
91 
92 pragma solidity ^0.8.13;
93 
94 abstract contract DefaultOperatorFilterer is OperatorFilterer {
95     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
96 
97     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
98 }
99 
100 
101 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 
130 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
131 
132 
133 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Required interface of an ERC721 compliant contract.
139  */
140 interface IERC721 is IERC165 {
141     /**
142      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in ``owner``'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
192      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must exist and be owned by `from`.
199      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201      *
202      * Emits a {Transfer} event.
203      */
204     function safeTransferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Transfers `tokenId` token from `from` to `to`.
212      *
213      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must be owned by `from`.
220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
232      * The approval is cleared when the token is transferred.
233      *
234      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
235      *
236      * Requirements:
237      *
238      * - The caller must own the token or be an approved operator.
239      * - `tokenId` must exist.
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address to, uint256 tokenId) external;
244 
245     /**
246      * @dev Approve or remove `operator` as an operator for the caller.
247      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
248      *
249      * Requirements:
250      *
251      * - The `operator` cannot be the caller.
252      *
253      * Emits an {ApprovalForAll} event.
254      */
255     function setApprovalForAll(address operator, bool _approved) external;
256 
257     /**
258      * @dev Returns the account approved for `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function getApproved(uint256 tokenId) external view returns (address operator);
265 
266     /**
267      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
268      *
269      * See {setApprovalForAll}
270      */
271     function isApprovedForAll(address owner, address operator) external view returns (bool);
272 }
273 
274 
275 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Provides information about the current execution context, including the
284  * sender of the transaction and its data. While these are generally available
285  * via msg.sender and msg.data, they should not be accessed in such a direct
286  * manner, since when dealing with meta-transactions the account sending and
287  * paying for execution may not be the actual sender (as far as an application
288  * is concerned).
289  *
290  * This contract is only required for intermediate, library-like contracts.
291  */
292 abstract contract Context {
293     function _msgSender() internal view virtual returns (address) {
294         return msg.sender;
295     }
296 
297     function _msgData() internal view virtual returns (bytes calldata) {
298         return msg.data;
299     }
300 }
301 
302 
303 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
304 
305 
306 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
307 
308 pragma solidity ^0.8.1;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      *
331      * [IMPORTANT]
332      * ====
333      * You shouldn't rely on `isContract` to protect against flash loan attacks!
334      *
335      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
336      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
337      * constructor.
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize/address.code.length, which returns 0
342         // for contracts in construction, since the code is only stored at the end
343         // of the constructor execution.
344 
345         return account.code.length > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516                 /// @solidity memory-safe-assembly
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 
529 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @title ERC721 token receiver interface
538  * @dev Interface for any contract that wants to support safeTransfers
539  * from ERC721 asset contracts.
540  */
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 
560 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Metadata is IERC721 {
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() external view returns (string memory);
576 
577     /**
578      * @dev Returns the token collection symbol.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
584      */
585     function tokenURI(uint256 tokenId) external view returns (string memory);
586 }
587 
588 
589 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
590 
591 
592 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev String operations.
598  */
599 library Strings {
600     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
601     uint8 private constant _ADDRESS_LENGTH = 20;
602 
603     /**
604      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
605      */
606     function toString(uint256 value) internal pure returns (string memory) {
607         // Inspired by OraclizeAPI's implementation - MIT licence
608         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
609 
610         if (value == 0) {
611             return "0";
612         }
613         uint256 temp = value;
614         uint256 digits;
615         while (temp != 0) {
616             digits++;
617             temp /= 10;
618         }
619         bytes memory buffer = new bytes(digits);
620         while (value != 0) {
621             digits -= 1;
622             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
623             value /= 10;
624         }
625         return string(buffer);
626     }
627 
628     /**
629      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
630      */
631     function toHexString(uint256 value) internal pure returns (string memory) {
632         if (value == 0) {
633             return "0x00";
634         }
635         uint256 temp = value;
636         uint256 length = 0;
637         while (temp != 0) {
638             length++;
639             temp >>= 8;
640         }
641         return toHexString(value, length);
642     }
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
646      */
647     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
648         bytes memory buffer = new bytes(2 * length + 2);
649         buffer[0] = "0";
650         buffer[1] = "x";
651         for (uint256 i = 2 * length + 1; i > 1; --i) {
652             buffer[i] = _HEX_SYMBOLS[value & 0xf];
653             value >>= 4;
654         }
655         require(value == 0, "Strings: hex length insufficient");
656         return string(buffer);
657     }
658 
659     /**
660      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
661      */
662     function toHexString(address addr) internal pure returns (string memory) {
663         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
664     }
665 }
666 
667 
668 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Implementation of the {IERC165} interface.
677  *
678  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
679  * for the additional interface id that will be supported. For example:
680  *
681  * ```solidity
682  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
684  * }
685  * ```
686  *
687  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
688  */
689 abstract contract ERC165 is IERC165 {
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694         return interfaceId == type(IERC165).interfaceId;
695     }
696 }
697 
698 
699 // File erc721a/contracts/ERC721A.sol@v3.1.0
700 
701 
702 // Creator: Chiru Labs
703 
704 pragma solidity ^0.8.4;
705 
706 
707 
708 
709 
710 
711 
712 error ApprovalCallerNotOwnerNorApproved();
713 error ApprovalQueryForNonexistentToken();
714 error ApproveToCaller();
715 error ApprovalToCurrentOwner();
716 error BalanceQueryForZeroAddress();
717 error MintToZeroAddress();
718 error MintZeroQuantity();
719 error OwnerQueryForNonexistentToken();
720 error TransferCallerNotOwnerNorApproved();
721 error TransferFromIncorrectOwner();
722 error TransferToNonERC721ReceiverImplementer();
723 error TransferToZeroAddress();
724 error URIQueryForNonexistentToken();
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension. Built to optimize for lower gas during batch mints.
729  *
730  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
731  *
732  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
733  *
734  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
735  */
736 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Compiler will pack this into a single 256bit word.
741     struct TokenOwnership {
742         // The address of the owner.
743         address addr;
744         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
745         uint64 startTimestamp;
746         // Whether the token has been burned.
747         bool burned;
748     }
749 
750     // Compiler will pack this into a single 256bit word.
751     struct AddressData {
752         // Realistically, 2**64-1 is more than enough.
753         uint64 balance;
754         // Keeps track of mint count with minimal overhead for tokenomics.
755         uint64 numberMinted;
756         // Keeps track of burn count with minimal overhead for tokenomics.
757         uint64 numberBurned;
758         // For miscellaneous variable(s) pertaining to the address
759         // (e.g. number of whitelist mint slots used).
760         // If there are multiple variables, please pack them into a uint64.
761         uint64 aux;
762     }
763 
764     // The tokenId of the next token to be minted.
765     uint256 internal _currentIndex;
766 
767     // The number of tokens burned.
768     uint256 internal _burnCounter;
769 
770     // Token name
771     string private _name;
772 
773     // Token symbol
774     string private _symbol;
775 
776     // Mapping from token ID to ownership details
777     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
778     mapping(uint256 => TokenOwnership) internal _ownerships;
779 
780     // Mapping owner address to address data
781     mapping(address => AddressData) private _addressData;
782 
783     // Mapping from token ID to approved address
784     mapping(uint256 => address) private _tokenApprovals;
785 
786     // Mapping from owner to operator approvals
787     mapping(address => mapping(address => bool)) private _operatorApprovals;
788 
789     constructor(string memory name_, string memory symbol_) {
790         _name = name_;
791         _symbol = symbol_;
792         _currentIndex = _startTokenId();
793     }
794 
795     /**
796      * To change the starting tokenId, please override this function.
797      */
798     function _startTokenId() internal view virtual returns (uint256) {
799         return 0;
800     }
801 
802     /**
803      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
804      */
805     function totalSupply() public view returns (uint256) {
806         // Counter underflow is impossible as _burnCounter cannot be incremented
807         // more than _currentIndex - _startTokenId() times
808         unchecked {
809             return _currentIndex - _burnCounter - _startTokenId();
810         }
811     }
812 
813     /**
814      * Returns the total amount of tokens minted in the contract.
815      */
816     function _totalMinted() internal view returns (uint256) {
817         // Counter underflow is impossible as _currentIndex does not decrement,
818         // and it is initialized to _startTokenId()
819         unchecked {
820             return _currentIndex - _startTokenId();
821         }
822     }
823 
824     /**
825      * @dev See {IERC165-supportsInterface}.
826      */
827     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
828         return
829             interfaceId == type(IERC721).interfaceId ||
830             interfaceId == type(IERC721Metadata).interfaceId ||
831             super.supportsInterface(interfaceId);
832     }
833 
834     /**
835      * @dev See {IERC721-balanceOf}.
836      */
837     function balanceOf(address owner) public view override returns (uint256) {
838         if (owner == address(0)) revert BalanceQueryForZeroAddress();
839         return uint256(_addressData[owner].balance);
840     }
841 
842     /**
843      * Returns the number of tokens minted by `owner`.
844      */
845     function _numberMinted(address owner) internal view returns (uint256) {
846         return uint256(_addressData[owner].numberMinted);
847     }
848 
849     /**
850      * Returns the number of tokens burned by or on behalf of `owner`.
851      */
852     function _numberBurned(address owner) internal view returns (uint256) {
853         return uint256(_addressData[owner].numberBurned);
854     }
855 
856     /**
857      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
858      */
859     function _getAux(address owner) internal view returns (uint64) {
860         return _addressData[owner].aux;
861     }
862 
863     /**
864      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
865      * If there are multiple variables, please pack them into a uint64.
866      */
867     function _setAux(address owner, uint64 aux) internal {
868         _addressData[owner].aux = aux;
869     }
870 
871     /**
872      * Gas spent here starts off proportional to the maximum mint batch size.
873      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
874      */
875     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
876         uint256 curr = tokenId;
877 
878         unchecked {
879             if (_startTokenId() <= curr && curr < _currentIndex) {
880                 TokenOwnership memory ownership = _ownerships[curr];
881                 if (!ownership.burned) {
882                     if (ownership.addr != address(0)) {
883                         return ownership;
884                     }
885                     // Invariant:
886                     // There will always be an ownership that has an address and is not burned
887                     // before an ownership that does not have an address and is not burned.
888                     // Hence, curr will not underflow.
889                     while (true) {
890                         curr--;
891                         ownership = _ownerships[curr];
892                         if (ownership.addr != address(0)) {
893                             return ownership;
894                         }
895                     }
896                 }
897             }
898         }
899         revert OwnerQueryForNonexistentToken();
900     }
901 
902     /**
903      * @dev See {IERC721-ownerOf}.
904      */
905     function ownerOf(uint256 tokenId) public view override returns (address) {
906         return _ownershipOf(tokenId).addr;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-name}.
911      */
912     function name() public view virtual override returns (string memory) {
913         return _name;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-symbol}.
918      */
919     function symbol() public view virtual override returns (string memory) {
920         return _symbol;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-tokenURI}.
925      */
926     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
927         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
928 
929         string memory baseURI = _baseURI();
930         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
931     }
932 
933     /**
934      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
935      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
936      * by default, can be overriden in child contracts.
937      */
938     function _baseURI() internal view virtual returns (string memory) {
939         return '';
940     }
941 
942     /**
943      * @dev See {IERC721-approve}.
944      */
945     function approve(address to, uint256 tokenId) public override {
946         address owner = ERC721A.ownerOf(tokenId);
947         if (to == owner) revert ApprovalToCurrentOwner();
948 
949         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
950             revert ApprovalCallerNotOwnerNorApproved();
951         }
952 
953         _approve(to, tokenId, owner);
954     }
955 
956     /**
957      * @dev See {IERC721-getApproved}.
958      */
959     function getApproved(uint256 tokenId) public view override returns (address) {
960         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved) public virtual override {
969         if (operator == _msgSender()) revert ApproveToCaller();
970 
971         _operatorApprovals[_msgSender()][operator] = approved;
972         emit ApprovalForAll(_msgSender(), operator, approved);
973     }
974 
975     /**
976      * @dev See {IERC721-isApprovedForAll}.
977      */
978     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
979         return _operatorApprovals[owner][operator];
980     }
981 
982     /**
983      * @dev See {IERC721-transferFrom}.
984      */
985     function transferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         _transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         safeTransferFrom(from, to, tokenId, '');
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) public virtual override {
1013         _transfer(from, to, tokenId);
1014         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1015             revert TransferToNonERC721ReceiverImplementer();
1016         }
1017     }
1018 
1019     /**
1020      * @dev Returns whether `tokenId` exists.
1021      *
1022      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023      *
1024      * Tokens start existing when they are minted (`_mint`),
1025      */
1026     function _exists(uint256 tokenId) internal view returns (bool) {
1027         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1028             !_ownerships[tokenId].burned;
1029     }
1030 
1031     function _safeMint(address to, uint256 quantity) internal {
1032         _safeMint(to, quantity, '');
1033     }
1034 
1035     /**
1036      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1041      * - `quantity` must be greater than 0.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _safeMint(
1046         address to,
1047         uint256 quantity,
1048         bytes memory _data
1049     ) internal {
1050         _mint(to, quantity, _data, true);
1051     }
1052 
1053     /**
1054      * @dev Mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(
1064         address to,
1065         uint256 quantity,
1066         bytes memory _data,
1067         bool safe
1068     ) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1077         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1078         unchecked {
1079             _addressData[to].balance += uint64(quantity);
1080             _addressData[to].numberMinted += uint64(quantity);
1081 
1082             _ownerships[startTokenId].addr = to;
1083             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1084 
1085             uint256 updatedIndex = startTokenId;
1086             uint256 end = updatedIndex + quantity;
1087 
1088             if (safe && to.isContract()) {
1089                 do {
1090                     emit Transfer(address(0), to, updatedIndex);
1091                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1092                         revert TransferToNonERC721ReceiverImplementer();
1093                     }
1094                 } while (updatedIndex != end);
1095                 // Reentrancy protection
1096                 if (_currentIndex != startTokenId) revert();
1097             } else {
1098                 do {
1099                     emit Transfer(address(0), to, updatedIndex++);
1100                 } while (updatedIndex != end);
1101             }
1102             _currentIndex = updatedIndex;
1103         }
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) private {
1122         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1123 
1124         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1125 
1126         bool isApprovedOrOwner = (_msgSender() == from ||
1127             isApprovedForAll(from, _msgSender()) ||
1128             getApproved(tokenId) == _msgSender());
1129 
1130         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1131         if (to == address(0)) revert TransferToZeroAddress();
1132 
1133         _beforeTokenTransfers(from, to, tokenId, 1);
1134 
1135         // Clear approvals from the previous owner
1136         _approve(address(0), tokenId, from);
1137 
1138         // Underflow of the sender's balance is impossible because we check for
1139         // ownership above and the recipient's balance can't realistically overflow.
1140         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1141         unchecked {
1142             _addressData[from].balance -= 1;
1143             _addressData[to].balance += 1;
1144 
1145             TokenOwnership storage currSlot = _ownerships[tokenId];
1146             currSlot.addr = to;
1147             currSlot.startTimestamp = uint64(block.timestamp);
1148 
1149             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1150             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1151             uint256 nextTokenId = tokenId + 1;
1152             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1153             if (nextSlot.addr == address(0)) {
1154                 // This will suffice for checking _exists(nextTokenId),
1155                 // as a burned slot cannot contain the zero address.
1156                 if (nextTokenId != _currentIndex) {
1157                     nextSlot.addr = from;
1158                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev This is equivalent to _burn(tokenId, false)
1169      */
1170     function _burn(uint256 tokenId) internal virtual {
1171         _burn(tokenId, false);
1172     }
1173 
1174     /**
1175      * @dev Destroys `tokenId`.
1176      * The approval is cleared when the token is burned.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1185         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1186 
1187         address from = prevOwnership.addr;
1188 
1189         if (approvalCheck) {
1190             bool isApprovedOrOwner = (_msgSender() == from ||
1191                 isApprovedForAll(from, _msgSender()) ||
1192                 getApproved(tokenId) == _msgSender());
1193 
1194             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         }
1196 
1197         _beforeTokenTransfers(from, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, from);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             AddressData storage addressData = _addressData[from];
1207             addressData.balance -= 1;
1208             addressData.numberBurned += 1;
1209 
1210             // Keep track of who burned the token, and the timestamp of burning.
1211             TokenOwnership storage currSlot = _ownerships[tokenId];
1212             currSlot.addr = from;
1213             currSlot.startTimestamp = uint64(block.timestamp);
1214             currSlot.burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1220             if (nextSlot.addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId != _currentIndex) {
1224                     nextSlot.addr = from;
1225                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, address(0), tokenId);
1231         _afterTokenTransfers(from, address(0), tokenId, 1);
1232 
1233         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1234         unchecked {
1235             _burnCounter++;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Approve `to` to operate on `tokenId`
1241      *
1242      * Emits a {Approval} event.
1243      */
1244     function _approve(
1245         address to,
1246         uint256 tokenId,
1247         address owner
1248     ) private {
1249         _tokenApprovals[tokenId] = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1269             return retval == IERC721Receiver(to).onERC721Received.selector;
1270         } catch (bytes memory reason) {
1271             if (reason.length == 0) {
1272                 revert TransferToNonERC721ReceiverImplementer();
1273             } else {
1274                 assembly {
1275                     revert(add(32, reason), mload(reason))
1276                 }
1277             }
1278         }
1279     }
1280 
1281     /**
1282      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1283      * And also called before burning one token.
1284      *
1285      * startTokenId - the first token id to be transferred
1286      * quantity - the amount to be transferred
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` will be minted for `to`.
1293      * - When `to` is zero, `tokenId` will be burned by `from`.
1294      * - `from` and `to` are never both zero.
1295      */
1296     function _beforeTokenTransfers(
1297         address from,
1298         address to,
1299         uint256 startTokenId,
1300         uint256 quantity
1301     ) internal virtual {}
1302 
1303     /**
1304      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1305      * minting.
1306      * And also called after one token has been burned.
1307      *
1308      * startTokenId - the first token id to be transferred
1309      * quantity - the amount to be transferred
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` has been minted for `to`.
1316      * - When `to` is zero, `tokenId` has been burned by `from`.
1317      * - `from` and `to` are never both zero.
1318      */
1319     function _afterTokenTransfers(
1320         address from,
1321         address to,
1322         uint256 startTokenId,
1323         uint256 quantity
1324     ) internal virtual {}
1325 }
1326 
1327 
1328 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1329 
1330 
1331 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 /**
1336  * @dev Contract module which provides a basic access control mechanism, where
1337  * there is an account (an owner) that can be granted exclusive access to
1338  * specific functions.
1339  *
1340  * By default, the owner account will be the one that deploys the contract. This
1341  * can later be changed with {transferOwnership}.
1342  *
1343  * This module is used through inheritance. It will make available the modifier
1344  * `onlyOwner`, which can be applied to your functions to restrict their use to
1345  * the owner.
1346  */
1347 abstract contract Ownable is Context {
1348     address private _owner;
1349 
1350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1351 
1352     /**
1353      * @dev Initializes the contract setting the deployer as the initial owner.
1354      */
1355     constructor() {
1356         _transferOwnership(_msgSender());
1357     }
1358 
1359     /**
1360      * @dev Throws if called by any account other than the owner.
1361      */
1362     modifier onlyOwner() {
1363         _checkOwner();
1364         _;
1365     }
1366 
1367     /**
1368      * @dev Returns the address of the current owner.
1369      */
1370     function owner() public view virtual returns (address) {
1371         return _owner;
1372     }
1373 
1374     /**
1375      * @dev Throws if the sender is not the owner.
1376      */
1377     function _checkOwner() internal view virtual {
1378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1379     }
1380 
1381     /**
1382      * @dev Leaves the contract without owner. It will not be possible to call
1383      * `onlyOwner` functions anymore. Can only be called by the current owner.
1384      *
1385      * NOTE: Renouncing ownership will leave the contract without an owner,
1386      * thereby removing any functionality that is only available to the owner.
1387      */
1388     function renounceOwnership() public virtual onlyOwner {
1389         _transferOwnership(address(0));
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(newOwner != address(0), "Ownable: new owner is the zero address");
1398         _transferOwnership(newOwner);
1399     }
1400 
1401     /**
1402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1403      * Internal function without access restriction.
1404      */
1405     function _transferOwnership(address newOwner) internal virtual {
1406         address oldOwner = _owner;
1407         _owner = newOwner;
1408         emit OwnershipTransferred(oldOwner, newOwner);
1409     }
1410 }
1411 
1412 
1413 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.3
1414 
1415 
1416 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1417 
1418 pragma solidity ^0.8.0;
1419 
1420 /**
1421  * @dev Interface for the NFT Royalty Standard.
1422  *
1423  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1424  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1425  *
1426  * _Available since v4.5._
1427  */
1428 interface IERC2981 is IERC165 {
1429     /**
1430      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1431      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1432      */
1433     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1434         external
1435         view
1436         returns (address receiver, uint256 royaltyAmount);
1437 }
1438 
1439 
1440 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.3
1441 
1442 
1443 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1444 
1445 pragma solidity ^0.8.0;
1446 
1447 
1448 /**
1449  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1450  *
1451  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1452  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1453  *
1454  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1455  * fee is specified in basis points by default.
1456  *
1457  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1458  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1459  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1460  *
1461  * _Available since v4.5._
1462  */
1463 abstract contract ERC2981 is IERC2981, ERC165 {
1464     struct RoyaltyInfo {
1465         address receiver;
1466         uint96 royaltyFraction;
1467     }
1468 
1469     RoyaltyInfo private _defaultRoyaltyInfo;
1470     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1471 
1472     /**
1473      * @dev See {IERC165-supportsInterface}.
1474      */
1475     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1476         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1477     }
1478 
1479     /**
1480      * @inheritdoc IERC2981
1481      */
1482     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1483         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1484 
1485         if (royalty.receiver == address(0)) {
1486             royalty = _defaultRoyaltyInfo;
1487         }
1488 
1489         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1490 
1491         return (royalty.receiver, royaltyAmount);
1492     }
1493 
1494     /**
1495      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1496      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1497      * override.
1498      */
1499     function _feeDenominator() internal pure virtual returns (uint96) {
1500         return 10000;
1501     }
1502 
1503     /**
1504      * @dev Sets the royalty information that all ids in this contract will default to.
1505      *
1506      * Requirements:
1507      *
1508      * - `receiver` cannot be the zero address.
1509      * - `feeNumerator` cannot be greater than the fee denominator.
1510      */
1511     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1512         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1513         require(receiver != address(0), "ERC2981: invalid receiver");
1514 
1515         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1516     }
1517 
1518     /**
1519      * @dev Removes default royalty information.
1520      */
1521     function _deleteDefaultRoyalty() internal virtual {
1522         delete _defaultRoyaltyInfo;
1523     }
1524 
1525     /**
1526      * @dev Sets the royalty information for a specific token id, overriding the global default.
1527      *
1528      * Requirements:
1529      *
1530      * - `receiver` cannot be the zero address.
1531      * - `feeNumerator` cannot be greater than the fee denominator.
1532      */
1533     function _setTokenRoyalty(
1534         uint256 tokenId,
1535         address receiver,
1536         uint96 feeNumerator
1537     ) internal virtual {
1538         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1539         require(receiver != address(0), "ERC2981: Invalid parameters");
1540 
1541         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1542     }
1543 
1544     /**
1545      * @dev Resets royalty information for the token id back to the global default.
1546      */
1547     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1548         delete _tokenRoyaltyInfo[tokenId];
1549     }
1550 }
1551 
1552 pragma solidity ^0.8.7;
1553 
1554 error SaleInactive();
1555 error SoldOut();
1556 error InvalidPrice();
1557 error WithdrawFailed();
1558 error InvalidQuantity();
1559 error InvalidProof();
1560 error InvalidBatchMint();
1561 
1562 contract BoredRoosterYachtClub is ERC721A, Ownable, ERC2981, OperatorFilterer {
1563     uint256 public price = 0 ether;
1564     uint256 public maxPerWallet = 1;
1565     uint256 public maxPerTransaction = 1;
1566 
1567     uint256 public immutable supply = 700;
1568 
1569     enum SaleState {
1570         CLOSED,
1571         OPEN
1572     }
1573 
1574     SaleState public saleState = SaleState.CLOSED;
1575 
1576     string public _baseTokenURI;
1577 
1578     mapping(address => uint256) public addressMintBalance;
1579 
1580     address[] public withdrawAddresses = [0xdE5D1E6e3a12935Ba28FdA73cfe13de18c5D6E3a];
1581     uint256[] public withdrawPercentages = [100];
1582 
1583     constructor(
1584         string memory _name,
1585         string memory _symbol,
1586         string memory _baseUri,
1587         uint96 _royaltyAmount
1588     ) ERC721A(_name, _symbol) OperatorFilterer(address(0), false) {
1589         _baseTokenURI = _baseUri;
1590         _setDefaultRoyalty(0xdE5D1E6e3a12935Ba28FdA73cfe13de18c5D6E3a, _royaltyAmount);
1591     }
1592 
1593     function cockPunch(uint256 qty, bytes4 cock_a_doodle_doo) external {
1594         if (saleState != SaleState.OPEN) revert SaleInactive();
1595         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1596         if (addressMintBalance[msg.sender] + qty > maxPerWallet) revert InvalidQuantity();
1597         if (qty > maxPerTransaction) revert InvalidQuantity();
1598         require(cluck(msg.sender, cock_a_doodle_doo), "Use our web, cock");
1599         require(tx.origin == msg.sender, "Not a real cock");
1600         addressMintBalance[msg.sender] += qty;
1601 
1602         _safeMint(msg.sender, qty);
1603 
1604     }
1605 
1606     function _startTokenId() internal view virtual override returns (uint256) {
1607         return 1;
1608     }
1609 
1610     function _baseURI() internal view virtual override returns (string memory) {
1611         return _baseTokenURI;
1612     }
1613 
1614     
1615     function setBaseURI(string memory baseURI) external onlyOwner {
1616         _baseTokenURI = baseURI;
1617     }
1618 
1619     function setPrice(uint256 newPrice) external onlyOwner {
1620         price = newPrice;
1621     }
1622 
1623     function setSaleState(uint8 _state) external onlyOwner {
1624         saleState = SaleState(_state);
1625     }
1626 
1627     function cockDev(uint256 qty, address recipient) external onlyOwner {
1628         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1629         _safeMint(recipient, qty);
1630     }
1631 
1632     function setPerWalletMax(uint256 _val) external onlyOwner {
1633         maxPerWallet = _val;
1634     }
1635 
1636     function setPerTransactionMax(uint256 _val) external onlyOwner {
1637         maxPerTransaction = _val;
1638     }
1639 
1640     function _withdraw(address _address, uint256 _amount) private {
1641         (bool success, ) = _address.call{value: _amount}("");
1642         if (!success) revert WithdrawFailed();
1643     }
1644 
1645     function withdraw() external onlyOwner {
1646         uint256 balance = address(this).balance;
1647 
1648         for (uint256 i; i < withdrawAddresses.length; i++) {
1649             _withdraw(withdrawAddresses[i], (balance * withdrawPercentages[i]) / 100);
1650         }
1651     }
1652 
1653     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1654         external
1655         onlyOwner
1656     {
1657         _setDefaultRoyalty(receiver, feeBasisPoints);
1658     }
1659 
1660     function supportsInterface(bytes4 interfaceId)
1661         public
1662         view
1663         override(ERC721A, ERC2981)
1664         returns (bool)
1665     {
1666         return super.supportsInterface(interfaceId);
1667     }
1668 
1669     function transferFrom(
1670         address from,
1671         address to,
1672         uint256 tokenId
1673     ) public override onlyAllowedOperator(from) {
1674         super.transferFrom(from, to, tokenId);
1675     }
1676 
1677     function safeTransferFrom(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) public override onlyAllowedOperator(from) {
1682         super.safeTransferFrom(from, to, tokenId);
1683     }
1684 
1685     function safeTransferFrom(
1686         address from,
1687         address to,
1688         uint256 tokenId,
1689         bytes memory data
1690     ) public override onlyAllowedOperator(from) {
1691         super.safeTransferFrom(from, to, tokenId, data);
1692     }
1693 
1694     function cluck(address _cock, bytes4 _punch) internal pure returns(bool){
1695         return bytes4(keccak256(abi.encodePacked(_cock))) == _punch;
1696     }
1697 }