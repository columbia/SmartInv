1 // SPDX-License-Identifier: MIT
2 
3 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 
35 // File contracts/OperatorFilter/OperatorFilterer.sol
36 
37 
38 pragma solidity ^0.8.13;
39 
40 abstract contract OperatorFilterer {
41     error OperatorNotAllowed(address operator);
42 
43     IOperatorFilterRegistry public constant operatorFilterRegistry =
44         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
45 
46     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
47         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
48         // will not revert, but the contract will need to be registered with the registry once it is deployed in
49         // order for the modifier to filter addresses.
50         if (address(operatorFilterRegistry).code.length > 0) {
51             if (subscribe) {
52                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
53             } else {
54                 if (subscriptionOrRegistrantToCopy != address(0)) {
55                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
56                 } else {
57                     operatorFilterRegistry.register(address(this));
58                 }
59             }
60         }
61     }
62 
63     modifier onlyAllowedOperator(address from) virtual {
64         // Check registry code length to facilitate testing in environments without a deployed registry.
65         if (address(operatorFilterRegistry).code.length > 0) {
66             // Allow spending tokens from addresses with balance
67             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
68             // from an EOA.
69             if (from == msg.sender) {
70                 _;
71                 return;
72             }
73             if (
74                 !(
75                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
76                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
77                 )
78             ) {
79                 revert OperatorNotAllowed(msg.sender);
80             }
81         }
82         _;
83     }
84 }
85 
86 
87 // File contracts/OperatorFilter/DefaultOperatorFilterer.sol
88 
89 
90 pragma solidity ^0.8.13;
91 
92 abstract contract DefaultOperatorFilterer is OperatorFilterer {
93     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
94 
95     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
96 }
97 
98 
99 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 
128 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
129 
130 
131 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Required interface of an ERC721 compliant contract.
137  */
138 interface IERC721 is IERC165 {
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
146      */
147     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
151      */
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     /**
155      * @dev Returns the number of tokens in ``owner``'s account.
156      */
157     function balanceOf(address owner) external view returns (uint256 balance);
158 
159     /**
160      * @dev Returns the owner of the `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function ownerOf(uint256 tokenId) external view returns (address owner);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 
188     /**
189      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
190      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must exist and be owned by `from`.
197      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
199      *
200      * Emits a {Transfer} event.
201      */
202     function safeTransferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Transfers `tokenId` token from `from` to `to`.
210      *
211      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
233      *
234      * Requirements:
235      *
236      * - The caller must own the token or be an approved operator.
237      * - `tokenId` must exist.
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address to, uint256 tokenId) external;
242 
243     /**
244      * @dev Approve or remove `operator` as an operator for the caller.
245      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
246      *
247      * Requirements:
248      *
249      * - The `operator` cannot be the caller.
250      *
251      * Emits an {ApprovalForAll} event.
252      */
253     function setApprovalForAll(address operator, bool _approved) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId) external view returns (address operator);
263 
264     /**
265      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
266      *
267      * See {setApprovalForAll}
268      */
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270 }
271 
272 
273 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
274 
275 
276 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Provides information about the current execution context, including the
282  * sender of the transaction and its data. While these are generally available
283  * via msg.sender and msg.data, they should not be accessed in such a direct
284  * manner, since when dealing with meta-transactions the account sending and
285  * paying for execution may not be the actual sender (as far as an application
286  * is concerned).
287  *
288  * This contract is only required for intermediate, library-like contracts.
289  */
290 abstract contract Context {
291     function _msgSender() internal view virtual returns (address) {
292         return msg.sender;
293     }
294 
295     function _msgData() internal view virtual returns (bytes calldata) {
296         return msg.data;
297     }
298 }
299 
300 
301 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
302 
303 
304 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
305 
306 pragma solidity ^0.8.1;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      *
329      * [IMPORTANT]
330      * ====
331      * You shouldn't rely on `isContract` to protect against flash loan attacks!
332      *
333      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
334      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
335      * constructor.
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize/address.code.length, which returns 0
340         // for contracts in construction, since the code is only stored at the end
341         // of the constructor execution.
342 
343         return account.code.length > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514                 /// @solidity memory-safe-assembly
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 
527 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
528 
529 
530 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @title ERC721 token receiver interface
536  * @dev Interface for any contract that wants to support safeTransfers
537  * from ERC721 asset contracts.
538  */
539 interface IERC721Receiver {
540     /**
541      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
542      * by `operator` from `from`, this function is called.
543      *
544      * It must return its Solidity selector to confirm the token transfer.
545      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
546      *
547      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
548      */
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 
558 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 
587 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
588 
589 
590 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev String operations.
596  */
597 library Strings {
598     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
599     uint8 private constant _ADDRESS_LENGTH = 20;
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
603      */
604     function toString(uint256 value) internal pure returns (string memory) {
605         // Inspired by OraclizeAPI's implementation - MIT licence
606         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
607 
608         if (value == 0) {
609             return "0";
610         }
611         uint256 temp = value;
612         uint256 digits;
613         while (temp != 0) {
614             digits++;
615             temp /= 10;
616         }
617         bytes memory buffer = new bytes(digits);
618         while (value != 0) {
619             digits -= 1;
620             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
621             value /= 10;
622         }
623         return string(buffer);
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
628      */
629     function toHexString(uint256 value) internal pure returns (string memory) {
630         if (value == 0) {
631             return "0x00";
632         }
633         uint256 temp = value;
634         uint256 length = 0;
635         while (temp != 0) {
636             length++;
637             temp >>= 8;
638         }
639         return toHexString(value, length);
640     }
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
644      */
645     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
646         bytes memory buffer = new bytes(2 * length + 2);
647         buffer[0] = "0";
648         buffer[1] = "x";
649         for (uint256 i = 2 * length + 1; i > 1; --i) {
650             buffer[i] = _HEX_SYMBOLS[value & 0xf];
651             value >>= 4;
652         }
653         require(value == 0, "Strings: hex length insufficient");
654         return string(buffer);
655     }
656 
657     /**
658      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
659      */
660     function toHexString(address addr) internal pure returns (string memory) {
661         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
662     }
663 }
664 
665 
666 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Implementation of the {IERC165} interface.
675  *
676  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
677  * for the additional interface id that will be supported. For example:
678  *
679  * ```solidity
680  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
682  * }
683  * ```
684  *
685  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
686  */
687 abstract contract ERC165 is IERC165 {
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692         return interfaceId == type(IERC165).interfaceId;
693     }
694 }
695 
696 
697 // File erc721a/contracts/ERC721A.sol@v3.1.0
698 
699 
700 // Creator: Chiru Labs
701 
702 pragma solidity ^0.8.4;
703 
704 
705 
706 
707 
708 
709 
710 error ApprovalCallerNotOwnerNorApproved();
711 error ApprovalQueryForNonexistentToken();
712 error ApproveToCaller();
713 error ApprovalToCurrentOwner();
714 error BalanceQueryForZeroAddress();
715 error MintToZeroAddress();
716 error MintZeroQuantity();
717 error OwnerQueryForNonexistentToken();
718 error TransferCallerNotOwnerNorApproved();
719 error TransferFromIncorrectOwner();
720 error TransferToNonERC721ReceiverImplementer();
721 error TransferToZeroAddress();
722 error URIQueryForNonexistentToken();
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
729  *
730  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
731  *
732  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
733  */
734 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Compiler will pack this into a single 256bit word.
739     struct TokenOwnership {
740         // The address of the owner.
741         address addr;
742         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
743         uint64 startTimestamp;
744         // Whether the token has been burned.
745         bool burned;
746     }
747 
748     // Compiler will pack this into a single 256bit word.
749     struct AddressData {
750         // Realistically, 2**64-1 is more than enough.
751         uint64 balance;
752         // Keeps track of mint count with minimal overhead for tokenomics.
753         uint64 numberMinted;
754         // Keeps track of burn count with minimal overhead for tokenomics.
755         uint64 numberBurned;
756         // For miscellaneous variable(s) pertaining to the address
757         // (e.g. number of whitelist mint slots used).
758         // If there are multiple variables, please pack them into a uint64.
759         uint64 aux;
760     }
761 
762     // The tokenId of the next token to be minted.
763     uint256 internal _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 internal _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
776     mapping(uint256 => TokenOwnership) internal _ownerships;
777 
778     // Mapping owner address to address data
779     mapping(address => AddressData) private _addressData;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790         _currentIndex = _startTokenId();
791     }
792 
793     /**
794      * To change the starting tokenId, please override this function.
795      */
796     function _startTokenId() internal view virtual returns (uint256) {
797         return 0;
798     }
799 
800     /**
801      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
802      */
803     function totalSupply() public view returns (uint256) {
804         // Counter underflow is impossible as _burnCounter cannot be incremented
805         // more than _currentIndex - _startTokenId() times
806         unchecked {
807             return _currentIndex - _burnCounter - _startTokenId();
808         }
809     }
810 
811     /**
812      * Returns the total amount of tokens minted in the contract.
813      */
814     function _totalMinted() internal view returns (uint256) {
815         // Counter underflow is impossible as _currentIndex does not decrement,
816         // and it is initialized to _startTokenId()
817         unchecked {
818             return _currentIndex - _startTokenId();
819         }
820     }
821 
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
826         return
827             interfaceId == type(IERC721).interfaceId ||
828             interfaceId == type(IERC721Metadata).interfaceId ||
829             super.supportsInterface(interfaceId);
830     }
831 
832     /**
833      * @dev See {IERC721-balanceOf}.
834      */
835     function balanceOf(address owner) public view override returns (uint256) {
836         if (owner == address(0)) revert BalanceQueryForZeroAddress();
837         return uint256(_addressData[owner].balance);
838     }
839 
840     /**
841      * Returns the number of tokens minted by `owner`.
842      */
843     function _numberMinted(address owner) internal view returns (uint256) {
844         return uint256(_addressData[owner].numberMinted);
845     }
846 
847     /**
848      * Returns the number of tokens burned by or on behalf of `owner`.
849      */
850     function _numberBurned(address owner) internal view returns (uint256) {
851         return uint256(_addressData[owner].numberBurned);
852     }
853 
854     /**
855      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
856      */
857     function _getAux(address owner) internal view returns (uint64) {
858         return _addressData[owner].aux;
859     }
860 
861     /**
862      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
863      * If there are multiple variables, please pack them into a uint64.
864      */
865     function _setAux(address owner, uint64 aux) internal {
866         _addressData[owner].aux = aux;
867     }
868 
869     /**
870      * Gas spent here starts off proportional to the maximum mint batch size.
871      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
872      */
873     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
874         uint256 curr = tokenId;
875 
876         unchecked {
877             if (_startTokenId() <= curr && curr < _currentIndex) {
878                 TokenOwnership memory ownership = _ownerships[curr];
879                 if (!ownership.burned) {
880                     if (ownership.addr != address(0)) {
881                         return ownership;
882                     }
883                     // Invariant:
884                     // There will always be an ownership that has an address and is not burned
885                     // before an ownership that does not have an address and is not burned.
886                     // Hence, curr will not underflow.
887                     while (true) {
888                         curr--;
889                         ownership = _ownerships[curr];
890                         if (ownership.addr != address(0)) {
891                             return ownership;
892                         }
893                     }
894                 }
895             }
896         }
897         revert OwnerQueryForNonexistentToken();
898     }
899 
900     /**
901      * @dev See {IERC721-ownerOf}.
902      */
903     function ownerOf(uint256 tokenId) public view override returns (address) {
904         return _ownershipOf(tokenId).addr;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-name}.
909      */
910     function name() public view virtual override returns (string memory) {
911         return _name;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-symbol}.
916      */
917     function symbol() public view virtual override returns (string memory) {
918         return _symbol;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-tokenURI}.
923      */
924     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
925         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
926 
927         string memory baseURI = _baseURI();
928         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), '.json')) : '';
929     }
930 
931     /**
932      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
933      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
934      * by default, can be overriden in child contracts.
935      */
936     function _baseURI() internal view virtual returns (string memory) {
937         return '';
938     }
939 
940     /**
941      * @dev See {IERC721-approve}.
942      */
943     function approve(address to, uint256 tokenId) public override {
944         address owner = ERC721A.ownerOf(tokenId);
945         if (to == owner) revert ApprovalToCurrentOwner();
946 
947         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
948             revert ApprovalCallerNotOwnerNorApproved();
949         }
950 
951         _approve(to, tokenId, owner);
952     }
953 
954     /**
955      * @dev See {IERC721-getApproved}.
956      */
957     function getApproved(uint256 tokenId) public view override returns (address) {
958         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
959 
960         return _tokenApprovals[tokenId];
961     }
962 
963     /**
964      * @dev See {IERC721-setApprovalForAll}.
965      */
966     function setApprovalForAll(address operator, bool approved) public virtual override {
967         if (operator == _msgSender()) revert ApproveToCaller();
968 
969         _operatorApprovals[_msgSender()][operator] = approved;
970         emit ApprovalForAll(_msgSender(), operator, approved);
971     }
972 
973     /**
974      * @dev See {IERC721-isApprovedForAll}.
975      */
976     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
977         return _operatorApprovals[owner][operator];
978     }
979 
980     /**
981      * @dev See {IERC721-transferFrom}.
982      */
983     function transferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) public virtual override {
988         _transfer(from, to, tokenId);
989     }
990 
991     /**
992      * @dev See {IERC721-safeTransferFrom}.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         safeTransferFrom(from, to, tokenId, '');
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) public virtual override {
1011         _transfer(from, to, tokenId);
1012         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1013             revert TransferToNonERC721ReceiverImplementer();
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      */
1024     function _exists(uint256 tokenId) internal view returns (bool) {
1025         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1026             !_ownerships[tokenId].burned;
1027     }
1028 
1029     function _safeMint(address to, uint256 quantity) internal {
1030         _safeMint(to, quantity, '');
1031     }
1032 
1033     /**
1034      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _safeMint(
1044         address to,
1045         uint256 quantity,
1046         bytes memory _data
1047     ) internal {
1048         _mint(to, quantity, _data, true);
1049     }
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _mint(
1062         address to,
1063         uint256 quantity,
1064         bytes memory _data,
1065         bool safe
1066     ) internal {
1067         uint256 startTokenId = _currentIndex;
1068         if (to == address(0)) revert MintToZeroAddress();
1069         if (quantity == 0) revert MintZeroQuantity();
1070 
1071         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1072 
1073         // Overflows are incredibly unrealistic.
1074         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1075         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1076         unchecked {
1077             _addressData[to].balance += uint64(quantity);
1078             _addressData[to].numberMinted += uint64(quantity);
1079 
1080             _ownerships[startTokenId].addr = to;
1081             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1082 
1083             uint256 updatedIndex = startTokenId;
1084             uint256 end = updatedIndex + quantity;
1085 
1086             if (safe && to.isContract()) {
1087                 do {
1088                     emit Transfer(address(0), to, updatedIndex);
1089                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1090                         revert TransferToNonERC721ReceiverImplementer();
1091                     }
1092                 } while (updatedIndex != end);
1093                 // Reentrancy protection
1094                 if (_currentIndex != startTokenId) revert();
1095             } else {
1096                 do {
1097                     emit Transfer(address(0), to, updatedIndex++);
1098                 } while (updatedIndex != end);
1099             }
1100             _currentIndex = updatedIndex;
1101         }
1102         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1103     }
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - `tokenId` token must be owned by `from`.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _transfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) private {
1120         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1121 
1122         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1123 
1124         bool isApprovedOrOwner = (_msgSender() == from ||
1125             isApprovedForAll(from, _msgSender()) ||
1126             getApproved(tokenId) == _msgSender());
1127 
1128         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1129         if (to == address(0)) revert TransferToZeroAddress();
1130 
1131         _beforeTokenTransfers(from, to, tokenId, 1);
1132 
1133         // Clear approvals from the previous owner
1134         _approve(address(0), tokenId, from);
1135 
1136         // Underflow of the sender's balance is impossible because we check for
1137         // ownership above and the recipient's balance can't realistically overflow.
1138         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1139         unchecked {
1140             _addressData[from].balance -= 1;
1141             _addressData[to].balance += 1;
1142 
1143             TokenOwnership storage currSlot = _ownerships[tokenId];
1144             currSlot.addr = to;
1145             currSlot.startTimestamp = uint64(block.timestamp);
1146 
1147             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1148             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1149             uint256 nextTokenId = tokenId + 1;
1150             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1151             if (nextSlot.addr == address(0)) {
1152                 // This will suffice for checking _exists(nextTokenId),
1153                 // as a burned slot cannot contain the zero address.
1154                 if (nextTokenId != _currentIndex) {
1155                     nextSlot.addr = from;
1156                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1157                 }
1158             }
1159         }
1160 
1161         emit Transfer(from, to, tokenId);
1162         _afterTokenTransfers(from, to, tokenId, 1);
1163     }
1164 
1165     /**
1166      * @dev This is equivalent to _burn(tokenId, false)
1167      */
1168     function _burn(uint256 tokenId) internal virtual {
1169         _burn(tokenId, false);
1170     }
1171 
1172     /**
1173      * @dev Destroys `tokenId`.
1174      * The approval is cleared when the token is burned.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1183         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1184 
1185         address from = prevOwnership.addr;
1186 
1187         if (approvalCheck) {
1188             bool isApprovedOrOwner = (_msgSender() == from ||
1189                 isApprovedForAll(from, _msgSender()) ||
1190                 getApproved(tokenId) == _msgSender());
1191 
1192             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1193         }
1194 
1195         _beforeTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Clear approvals from the previous owner
1198         _approve(address(0), tokenId, from);
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1203         unchecked {
1204             AddressData storage addressData = _addressData[from];
1205             addressData.balance -= 1;
1206             addressData.numberBurned += 1;
1207 
1208             // Keep track of who burned the token, and the timestamp of burning.
1209             TokenOwnership storage currSlot = _ownerships[tokenId];
1210             currSlot.addr = from;
1211             currSlot.startTimestamp = uint64(block.timestamp);
1212             currSlot.burned = true;
1213 
1214             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1215             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1216             uint256 nextTokenId = tokenId + 1;
1217             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1218             if (nextSlot.addr == address(0)) {
1219                 // This will suffice for checking _exists(nextTokenId),
1220                 // as a burned slot cannot contain the zero address.
1221                 if (nextTokenId != _currentIndex) {
1222                     nextSlot.addr = from;
1223                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1224                 }
1225             }
1226         }
1227 
1228         emit Transfer(from, address(0), tokenId);
1229         _afterTokenTransfers(from, address(0), tokenId, 1);
1230 
1231         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1232         unchecked {
1233             _burnCounter++;
1234         }
1235     }
1236 
1237     /**
1238      * @dev Approve `to` to operate on `tokenId`
1239      *
1240      * Emits a {Approval} event.
1241      */
1242     function _approve(
1243         address to,
1244         uint256 tokenId,
1245         address owner
1246     ) private {
1247         _tokenApprovals[tokenId] = to;
1248         emit Approval(owner, to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1253      *
1254      * @param from address representing the previous owner of the given token ID
1255      * @param to target address that will receive the tokens
1256      * @param tokenId uint256 ID of the token to be transferred
1257      * @param _data bytes optional data to send along with the call
1258      * @return bool whether the call correctly returned the expected magic value
1259      */
1260     function _checkContractOnERC721Received(
1261         address from,
1262         address to,
1263         uint256 tokenId,
1264         bytes memory _data
1265     ) private returns (bool) {
1266         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1267             return retval == IERC721Receiver(to).onERC721Received.selector;
1268         } catch (bytes memory reason) {
1269             if (reason.length == 0) {
1270                 revert TransferToNonERC721ReceiverImplementer();
1271             } else {
1272                 assembly {
1273                     revert(add(32, reason), mload(reason))
1274                 }
1275             }
1276         }
1277     }
1278 
1279     /**
1280      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1281      * And also called before burning one token.
1282      *
1283      * startTokenId - the first token id to be transferred
1284      * quantity - the amount to be transferred
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, `tokenId` will be burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _beforeTokenTransfers(
1295         address from,
1296         address to,
1297         uint256 startTokenId,
1298         uint256 quantity
1299     ) internal virtual {}
1300 
1301     /**
1302      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1303      * minting.
1304      * And also called after one token has been burned.
1305      *
1306      * startTokenId - the first token id to be transferred
1307      * quantity - the amount to be transferred
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` has been minted for `to`.
1314      * - When `to` is zero, `tokenId` has been burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _afterTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 }
1324 
1325 
1326 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1327 
1328 
1329 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 /**
1334  * @dev Contract module which provides a basic access control mechanism, where
1335  * there is an account (an owner) that can be granted exclusive access to
1336  * specific functions.
1337  *
1338  * By default, the owner account will be the one that deploys the contract. This
1339  * can later be changed with {transferOwnership}.
1340  *
1341  * This module is used through inheritance. It will make available the modifier
1342  * `onlyOwner`, which can be applied to your functions to restrict their use to
1343  * the owner.
1344  */
1345 abstract contract Ownable is Context {
1346     address private _owner;
1347 
1348     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1349 
1350     /**
1351      * @dev Initializes the contract setting the deployer as the initial owner.
1352      */
1353     constructor() {
1354         _transferOwnership(_msgSender());
1355     }
1356 
1357     /**
1358      * @dev Throws if called by any account other than the owner.
1359      */
1360     modifier onlyOwner() {
1361         _checkOwner();
1362         _;
1363     }
1364 
1365     /**
1366      * @dev Returns the address of the current owner.
1367      */
1368     function owner() public view virtual returns (address) {
1369         return _owner;
1370     }
1371 
1372     /**
1373      * @dev Throws if the sender is not the owner.
1374      */
1375     function _checkOwner() internal view virtual {
1376         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1377     }
1378 
1379     /**
1380      * @dev Leaves the contract without owner. It will not be possible to call
1381      * `onlyOwner` functions anymore. Can only be called by the current owner.
1382      *
1383      * NOTE: Renouncing ownership will leave the contract without an owner,
1384      * thereby removing any functionality that is only available to the owner.
1385      */
1386     function renounceOwnership() public virtual onlyOwner {
1387         _transferOwnership(address(0));
1388     }
1389 
1390     /**
1391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1392      * Can only be called by the current owner.
1393      */
1394     function transferOwnership(address newOwner) public virtual onlyOwner {
1395         require(newOwner != address(0), "Ownable: new owner is the zero address");
1396         _transferOwnership(newOwner);
1397     }
1398 
1399     /**
1400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1401      * Internal function without access restriction.
1402      */
1403     function _transferOwnership(address newOwner) internal virtual {
1404         address oldOwner = _owner;
1405         _owner = newOwner;
1406         emit OwnershipTransferred(oldOwner, newOwner);
1407     }
1408 }
1409 
1410 
1411 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.3
1412 
1413 
1414 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 /**
1419  * @dev Interface for the NFT Royalty Standard.
1420  *
1421  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1422  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1423  *
1424  * _Available since v4.5._
1425  */
1426 interface IERC2981 is IERC165 {
1427     /**
1428      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1429      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1430      */
1431     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1432         external
1433         view
1434         returns (address receiver, uint256 royaltyAmount);
1435 }
1436 
1437 
1438 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.3
1439 
1440 
1441 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 
1446 /**
1447  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1448  *
1449  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1450  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1451  *
1452  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1453  * fee is specified in basis points by default.
1454  *
1455  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1456  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1457  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1458  *
1459  * _Available since v4.5._
1460  */
1461 abstract contract ERC2981 is IERC2981, ERC165 {
1462     struct RoyaltyInfo {
1463         address receiver;
1464         uint96 royaltyFraction;
1465     }
1466 
1467     RoyaltyInfo private _defaultRoyaltyInfo;
1468     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1469 
1470     /**
1471      * @dev See {IERC165-supportsInterface}.
1472      */
1473     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1474         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1475     }
1476 
1477     /**
1478      * @inheritdoc IERC2981
1479      */
1480     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1481         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1482 
1483         if (royalty.receiver == address(0)) {
1484             royalty = _defaultRoyaltyInfo;
1485         }
1486 
1487         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1488 
1489         return (royalty.receiver, royaltyAmount);
1490     }
1491 
1492     /**
1493      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1494      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1495      * override.
1496      */
1497     function _feeDenominator() internal pure virtual returns (uint96) {
1498         return 10000;
1499     }
1500 
1501     /**
1502      * @dev Sets the royalty information that all ids in this contract will default to.
1503      *
1504      * Requirements:
1505      *
1506      * - `receiver` cannot be the zero address.
1507      * - `feeNumerator` cannot be greater than the fee denominator.
1508      */
1509     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1510         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1511         require(receiver != address(0), "ERC2981: invalid receiver");
1512 
1513         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1514     }
1515 
1516     /**
1517      * @dev Removes default royalty information.
1518      */
1519     function _deleteDefaultRoyalty() internal virtual {
1520         delete _defaultRoyaltyInfo;
1521     }
1522 
1523     /**
1524      * @dev Sets the royalty information for a specific token id, overriding the global default.
1525      *
1526      * Requirements:
1527      *
1528      * - `receiver` cannot be the zero address.
1529      * - `feeNumerator` cannot be greater than the fee denominator.
1530      */
1531     function _setTokenRoyalty(
1532         uint256 tokenId,
1533         address receiver,
1534         uint96 feeNumerator
1535     ) internal virtual {
1536         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1537         require(receiver != address(0), "ERC2981: Invalid parameters");
1538 
1539         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1540     }
1541 
1542     /**
1543      * @dev Resets royalty information for the token id back to the global default.
1544      */
1545     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1546         delete _tokenRoyaltyInfo[tokenId];
1547     }
1548 }
1549 
1550 
1551 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.3
1552 
1553 
1554 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1555 
1556 pragma solidity ^0.8.0;
1557 
1558 /**
1559  * @dev These functions deal with verification of Merkle Tree proofs.
1560  *
1561  * The proofs can be generated using the JavaScript library
1562  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1563  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1564  *
1565  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1566  *
1567  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1568  * hashing, or use a hash function other than keccak256 for hashing leaves.
1569  * This is because the concatenation of a sorted pair of internal nodes in
1570  * the merkle tree could be reinterpreted as a leaf value.
1571  */
1572 library MerkleProof {
1573     /**
1574      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1575      * defined by `root`. For this, a `proof` must be provided, containing
1576      * sibling hashes on the branch from the leaf to the root of the tree. Each
1577      * pair of leaves and each pair of pre-images are assumed to be sorted.
1578      */
1579     function verify(
1580         bytes32[] memory proof,
1581         bytes32 root,
1582         bytes32 leaf
1583     ) internal pure returns (bool) {
1584         return processProof(proof, leaf) == root;
1585     }
1586 
1587     /**
1588      * @dev Calldata version of {verify}
1589      *
1590      * _Available since v4.7._
1591      */
1592     function verifyCalldata(
1593         bytes32[] calldata proof,
1594         bytes32 root,
1595         bytes32 leaf
1596     ) internal pure returns (bool) {
1597         return processProofCalldata(proof, leaf) == root;
1598     }
1599 
1600     /**
1601      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1602      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1603      * hash matches the root of the tree. When processing the proof, the pairs
1604      * of leafs & pre-images are assumed to be sorted.
1605      *
1606      * _Available since v4.4._
1607      */
1608     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1609         bytes32 computedHash = leaf;
1610         for (uint256 i = 0; i < proof.length; i++) {
1611             computedHash = _hashPair(computedHash, proof[i]);
1612         }
1613         return computedHash;
1614     }
1615 
1616     /**
1617      * @dev Calldata version of {processProof}
1618      *
1619      * _Available since v4.7._
1620      */
1621     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1622         bytes32 computedHash = leaf;
1623         for (uint256 i = 0; i < proof.length; i++) {
1624             computedHash = _hashPair(computedHash, proof[i]);
1625         }
1626         return computedHash;
1627     }
1628 
1629     /**
1630      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1631      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1632      *
1633      * _Available since v4.7._
1634      */
1635     function multiProofVerify(
1636         bytes32[] memory proof,
1637         bool[] memory proofFlags,
1638         bytes32 root,
1639         bytes32[] memory leaves
1640     ) internal pure returns (bool) {
1641         return processMultiProof(proof, proofFlags, leaves) == root;
1642     }
1643 
1644     /**
1645      * @dev Calldata version of {multiProofVerify}
1646      *
1647      * _Available since v4.7._
1648      */
1649     function multiProofVerifyCalldata(
1650         bytes32[] calldata proof,
1651         bool[] calldata proofFlags,
1652         bytes32 root,
1653         bytes32[] memory leaves
1654     ) internal pure returns (bool) {
1655         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1656     }
1657 
1658     /**
1659      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1660      * consuming from one or the other at each step according to the instructions given by
1661      * `proofFlags`.
1662      *
1663      * _Available since v4.7._
1664      */
1665     function processMultiProof(
1666         bytes32[] memory proof,
1667         bool[] memory proofFlags,
1668         bytes32[] memory leaves
1669     ) internal pure returns (bytes32 merkleRoot) {
1670         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1671         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1672         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1673         // the merkle tree.
1674         uint256 leavesLen = leaves.length;
1675         uint256 totalHashes = proofFlags.length;
1676 
1677         // Check proof validity.
1678         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1679 
1680         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1681         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1682         bytes32[] memory hashes = new bytes32[](totalHashes);
1683         uint256 leafPos = 0;
1684         uint256 hashPos = 0;
1685         uint256 proofPos = 0;
1686         // At each step, we compute the next hash using two values:
1687         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1688         //   get the next hash.
1689         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1690         //   `proof` array.
1691         for (uint256 i = 0; i < totalHashes; i++) {
1692             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1693             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1694             hashes[i] = _hashPair(a, b);
1695         }
1696 
1697         if (totalHashes > 0) {
1698             return hashes[totalHashes - 1];
1699         } else if (leavesLen > 0) {
1700             return leaves[0];
1701         } else {
1702             return proof[0];
1703         }
1704     }
1705 
1706     /**
1707      * @dev Calldata version of {processMultiProof}
1708      *
1709      * _Available since v4.7._
1710      */
1711     function processMultiProofCalldata(
1712         bytes32[] calldata proof,
1713         bool[] calldata proofFlags,
1714         bytes32[] memory leaves
1715     ) internal pure returns (bytes32 merkleRoot) {
1716         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1717         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1718         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1719         // the merkle tree.
1720         uint256 leavesLen = leaves.length;
1721         uint256 totalHashes = proofFlags.length;
1722 
1723         // Check proof validity.
1724         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1725 
1726         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1727         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1728         bytes32[] memory hashes = new bytes32[](totalHashes);
1729         uint256 leafPos = 0;
1730         uint256 hashPos = 0;
1731         uint256 proofPos = 0;
1732         // At each step, we compute the next hash using two values:
1733         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1734         //   get the next hash.
1735         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1736         //   `proof` array.
1737         for (uint256 i = 0; i < totalHashes; i++) {
1738             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1739             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1740             hashes[i] = _hashPair(a, b);
1741         }
1742 
1743         if (totalHashes > 0) {
1744             return hashes[totalHashes - 1];
1745         } else if (leavesLen > 0) {
1746             return leaves[0];
1747         } else {
1748             return proof[0];
1749         }
1750     }
1751 
1752     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1753         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1754     }
1755 
1756     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1757         /// @solidity memory-safe-assembly
1758         assembly {
1759             mstore(0x00, a)
1760             mstore(0x20, b)
1761             value := keccak256(0x00, 0x40)
1762         }
1763     }
1764 }
1765 
1766 
1767 pragma solidity ^0.8.7;
1768 
1769 error SaleInactive();
1770 error SoldOut();
1771 error InvalidPrice();
1772 error WithdrawFailed();
1773 error InvalidQuantity();
1774 error InvalidProof();
1775 error InvalidBatchMint();
1776 
1777 contract HoneyHeaven is ERC721A, Ownable, ERC2981, OperatorFilterer {
1778     uint256 public price = 0.003 ether;
1779     uint256 public maxPerTransaction = 10;
1780     uint256 public immutable supply = 1333;
1781     string public _baseTokenURI = 'ipfs://Qmbwg1oVrEnBUpsGCkAsE3uiP5WsG17gndXNmh1uBiB2RT/';
1782 
1783     uint256 public freeUntil = 1333;
1784     uint256 public freebiesPerWallet = 1;
1785 
1786     enum SaleState {
1787         CLOSED,
1788         OPEN
1789     }
1790     SaleState public saleState = SaleState.CLOSED;
1791 
1792     constructor() ERC721A("HoneyHeaven", "HoneyHeaven") OperatorFilterer(address(0), false) {
1793         _setDefaultRoyalty(0x1FEa77CEA66f10C3F877dB210967Df602faA2944, 0);
1794     }
1795 ////
1796 
1797     function mint(uint256 qty) external payable {
1798         if (saleState != SaleState.OPEN) revert SaleInactive();
1799         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1800 
1801         if (qty > maxPerTransaction) revert InvalidQuantity();
1802 
1803         uint256 freeMintsLeftForWallet = freebiesPerWallet - balanceOf(msg.sender);
1804         uint256 freeMintsToBeUsed = qty < freeMintsLeftForWallet ? qty : freeMintsLeftForWallet;
1805         if (totalSupply() >= freeUntil) {
1806           freeMintsToBeUsed = 0;
1807         }
1808         uint256 payableAmount = qty - freeMintsToBeUsed;
1809         require(msg.value >= price * payableAmount, 'Insufficient funds!');
1810 
1811         _safeMint(msg.sender, qty);
1812 
1813     }
1814 
1815     function _startTokenId() internal view virtual override returns (uint256) {
1816         return 1;
1817     }
1818 
1819     function _baseURI() internal view virtual override returns (string memory) {
1820         return _baseTokenURI;
1821     }
1822 
1823     function setBaseURI(string memory baseURI) external onlyOwner {
1824         _baseTokenURI = baseURI;
1825     }
1826 
1827     function setPrice(uint256 newPrice) external onlyOwner {
1828         price = newPrice;
1829     }
1830 
1831     function setSaleState(uint8 _state) external onlyOwner {
1832         saleState = SaleState(_state);
1833     }
1834 
1835     function freeMint(uint256 qty, address recipient) external onlyOwner {
1836         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1837         _safeMint(recipient, qty);
1838     }
1839 
1840     function batchMint(uint64[] calldata qtys, address[] calldata recipients)
1841         external
1842         onlyOwner
1843     {
1844         uint256 numRecipients = recipients.length;
1845         if (numRecipients != qtys.length) revert InvalidBatchMint();
1846 
1847         for (uint256 i = 0; i < numRecipients; ) {
1848             if ((_currentIndex - 1) + qtys[i] > supply) revert SoldOut();
1849 
1850             _safeMint(recipients[i], qtys[i]);
1851 
1852             unchecked {
1853                 i++;
1854             }
1855         }
1856     }
1857 
1858     function setPerTransactionMax(uint256 _val) external onlyOwner {
1859         maxPerTransaction = _val;
1860     }
1861 
1862     function withdraw() external onlyOwner {
1863         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1864         if (!success) revert WithdrawFailed();
1865     }
1866 
1867     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1868         external
1869         onlyOwner
1870     {
1871         _setDefaultRoyalty(receiver, feeBasisPoints);
1872     }
1873 
1874     function supportsInterface(bytes4 interfaceId)
1875         public
1876         view
1877         override(ERC721A, ERC2981)
1878         returns (bool)
1879     {
1880         return super.supportsInterface(interfaceId);
1881     }
1882 
1883     function transferFrom(
1884         address from,
1885         address to,
1886         uint256 tokenId
1887     ) public override onlyAllowedOperator(from) {
1888         super.transferFrom(from, to, tokenId);
1889     }
1890 
1891     function safeTransferFrom(
1892         address from,
1893         address to,
1894         uint256 tokenId
1895     ) public override onlyAllowedOperator(from) {
1896         super.safeTransferFrom(from, to, tokenId);
1897     }
1898 
1899     function safeTransferFrom(
1900         address from,
1901         address to,
1902         uint256 tokenId,
1903         bytes memory data
1904     ) public override onlyAllowedOperator(from) {
1905         super.safeTransferFrom(from, to, tokenId, data);
1906     }
1907 }