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
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 
34 // File contracts/OperatorFilter/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 abstract contract OperatorFilterer {
40     error OperatorNotAllowed(address operator);
41 
42     IOperatorFilterRegistry constant operatorFilterRegistry =
43         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
44 
45     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
46         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
47         // will not revert, but the contract will need to be registered with the registry once it is deployed in
48         // order for the modifier to filter addresses.
49         if (address(operatorFilterRegistry).code.length > 0) {
50             if (subscribe) {
51                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
52             } else {
53                 if (subscriptionOrRegistrantToCopy != address(0)) {
54                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
55                 } else {
56                     operatorFilterRegistry.register(address(this));
57                 }
58             }
59         }
60     }
61 
62     modifier onlyAllowedOperator(address from) virtual {
63         // Check registry code length to facilitate testing in environments without a deployed registry.
64         if (address(operatorFilterRegistry).code.length > 0) {
65             // Allow spending tokens from addresses with balance
66             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67             // from an EOA.
68             if (from == msg.sender) {
69                 _;
70                 return;
71             }
72             if (
73                 !(
74                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
75                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
76                 )
77             ) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 }
84 
85 
86 // File contracts/OperatorFilter/DefaultOperatorFilterer.sol
87 
88 
89 pragma solidity ^0.8.13;
90 
91 abstract contract DefaultOperatorFilterer is OperatorFilterer {
92     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
93 
94     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
95 }
96 
97 
98 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 
127 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
128 
129 
130 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Required interface of an ERC721 compliant contract.
136  */
137 interface IERC721 is IERC165 {
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in ``owner``'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
189      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must exist and be owned by `from`.
196      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198      *
199      * Emits a {Transfer} event.
200      */
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Transfers `tokenId` token from `from` to `to`.
209      *
210      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
229      * The approval is cleared when the token is transferred.
230      *
231      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
232      *
233      * Requirements:
234      *
235      * - The caller must own the token or be an approved operator.
236      * - `tokenId` must exist.
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Approve or remove `operator` as an operator for the caller.
244      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 }
270 
271 
272 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Provides information about the current execution context, including the
281  * sender of the transaction and its data. While these are generally available
282  * via msg.sender and msg.data, they should not be accessed in such a direct
283  * manner, since when dealing with meta-transactions the account sending and
284  * paying for execution may not be the actual sender (as far as an application
285  * is concerned).
286  *
287  * This contract is only required for intermediate, library-like contracts.
288  */
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes calldata) {
295         return msg.data;
296     }
297 }
298 
299 
300 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
301 
302 
303 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
304 
305 pragma solidity ^0.8.1;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      *
328      * [IMPORTANT]
329      * ====
330      * You shouldn't rely on `isContract` to protect against flash loan attacks!
331      *
332      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
333      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
334      * constructor.
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize/address.code.length, which returns 0
339         // for contracts in construction, since the code is only stored at the end
340         // of the constructor execution.
341 
342         return account.code.length > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         (bool success, ) = recipient.call{value: amount}("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but also transferring `value` wei to `target`.
407      *
408      * Requirements:
409      *
410      * - the calling contract must have an ETH balance of at least `value`.
411      * - the called Solidity function must be `payable`.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(address(this).balance >= value, "Address: insufficient balance for call");
436         require(isContract(target), "Address: call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.call{value: value}(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513                 /// @solidity memory-safe-assembly
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 
526 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
527 
528 
529 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
547      */
548     function onERC721Received(
549         address operator,
550         address from,
551         uint256 tokenId,
552         bytes calldata data
553     ) external returns (bytes4);
554 }
555 
556 
557 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 
586 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
587 
588 
589 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598     uint8 private constant _ADDRESS_LENGTH = 20;
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
602      */
603     function toString(uint256 value) internal pure returns (string memory) {
604         // Inspired by OraclizeAPI's implementation - MIT licence
605         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
606 
607         if (value == 0) {
608             return "0";
609         }
610         uint256 temp = value;
611         uint256 digits;
612         while (temp != 0) {
613             digits++;
614             temp /= 10;
615         }
616         bytes memory buffer = new bytes(digits);
617         while (value != 0) {
618             digits -= 1;
619             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
620             value /= 10;
621         }
622         return string(buffer);
623     }
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
627      */
628     function toHexString(uint256 value) internal pure returns (string memory) {
629         if (value == 0) {
630             return "0x00";
631         }
632         uint256 temp = value;
633         uint256 length = 0;
634         while (temp != 0) {
635             length++;
636             temp >>= 8;
637         }
638         return toHexString(value, length);
639     }
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
643      */
644     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
645         bytes memory buffer = new bytes(2 * length + 2);
646         buffer[0] = "0";
647         buffer[1] = "x";
648         for (uint256 i = 2 * length + 1; i > 1; --i) {
649             buffer[i] = _HEX_SYMBOLS[value & 0xf];
650             value >>= 4;
651         }
652         require(value == 0, "Strings: hex length insufficient");
653         return string(buffer);
654     }
655 
656     /**
657      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
658      */
659     function toHexString(address addr) internal pure returns (string memory) {
660         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev Implementation of the {IERC165} interface.
674  *
675  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
676  * for the additional interface id that will be supported. For example:
677  *
678  * ```solidity
679  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
680  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
681  * }
682  * ```
683  *
684  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
685  */
686 abstract contract ERC165 is IERC165 {
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691         return interfaceId == type(IERC165).interfaceId;
692     }
693 }
694 
695 
696 // File erc721a/contracts/ERC721A.sol@v3.1.0
697 
698 
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.4;
702 
703 
704 
705 
706 
707 
708 
709 error ApprovalCallerNotOwnerNorApproved();
710 error ApprovalQueryForNonexistentToken();
711 error ApproveToCaller();
712 error ApprovalToCurrentOwner();
713 error BalanceQueryForZeroAddress();
714 error MintToZeroAddress();
715 error MintZeroQuantity();
716 error OwnerQueryForNonexistentToken();
717 error TransferCallerNotOwnerNorApproved();
718 error TransferFromIncorrectOwner();
719 error TransferToNonERC721ReceiverImplementer();
720 error TransferToZeroAddress();
721 error URIQueryForNonexistentToken();
722 
723 /**
724  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
725  * the Metadata extension. Built to optimize for lower gas during batch mints.
726  *
727  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
728  *
729  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
730  *
731  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
732  */
733 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Compiler will pack this into a single 256bit word.
738     struct TokenOwnership {
739         // The address of the owner.
740         address addr;
741         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
742         uint64 startTimestamp;
743         // Whether the token has been burned.
744         bool burned;
745     }
746 
747     // Compiler will pack this into a single 256bit word.
748     struct AddressData {
749         // Realistically, 2**64-1 is more than enough.
750         uint64 balance;
751         // Keeps track of mint count with minimal overhead for tokenomics.
752         uint64 numberMinted;
753         // Keeps track of burn count with minimal overhead for tokenomics.
754         uint64 numberBurned;
755         // For miscellaneous variable(s) pertaining to the address
756         // (e.g. number of whitelist mint slots used).
757         // If there are multiple variables, please pack them into a uint64.
758         uint64 aux;
759     }
760 
761     // The tokenId of the next token to be minted.
762     uint256 internal _currentIndex;
763 
764     // The number of tokens burned.
765     uint256 internal _burnCounter;
766 
767     // Token name
768     string private _name;
769 
770     // Token symbol
771     string private _symbol;
772 
773     // Mapping from token ID to ownership details
774     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
775     mapping(uint256 => TokenOwnership) internal _ownerships;
776 
777     // Mapping owner address to address data
778     mapping(address => AddressData) private _addressData;
779 
780     // Mapping from token ID to approved address
781     mapping(uint256 => address) private _tokenApprovals;
782 
783     // Mapping from owner to operator approvals
784     mapping(address => mapping(address => bool)) private _operatorApprovals;
785 
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789         _currentIndex = _startTokenId();
790     }
791 
792     /**
793      * To change the starting tokenId, please override this function.
794      */
795     function _startTokenId() internal view virtual returns (uint256) {
796         return 0;
797     }
798 
799     /**
800      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
801      */
802     function totalSupply() public view returns (uint256) {
803         // Counter underflow is impossible as _burnCounter cannot be incremented
804         // more than _currentIndex - _startTokenId() times
805         unchecked {
806             return _currentIndex - _burnCounter - _startTokenId();
807         }
808     }
809 
810     /**
811      * Returns the total amount of tokens minted in the contract.
812      */
813     function _totalMinted() internal view returns (uint256) {
814         // Counter underflow is impossible as _currentIndex does not decrement,
815         // and it is initialized to _startTokenId()
816         unchecked {
817             return _currentIndex - _startTokenId();
818         }
819     }
820 
821     /**
822      * @dev See {IERC165-supportsInterface}.
823      */
824     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
825         return
826             interfaceId == type(IERC721).interfaceId ||
827             interfaceId == type(IERC721Metadata).interfaceId ||
828             super.supportsInterface(interfaceId);
829     }
830 
831     /**
832      * @dev See {IERC721-balanceOf}.
833      */
834     function balanceOf(address owner) public view override returns (uint256) {
835         if (owner == address(0)) revert BalanceQueryForZeroAddress();
836         return uint256(_addressData[owner].balance);
837     }
838 
839     /**
840      * Returns the number of tokens minted by `owner`.
841      */
842     function _numberMinted(address owner) internal view returns (uint256) {
843         return uint256(_addressData[owner].numberMinted);
844     }
845 
846     /**
847      * Returns the number of tokens burned by or on behalf of `owner`.
848      */
849     function _numberBurned(address owner) internal view returns (uint256) {
850         return uint256(_addressData[owner].numberBurned);
851     }
852 
853     /**
854      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
855      */
856     function _getAux(address owner) internal view returns (uint64) {
857         return _addressData[owner].aux;
858     }
859 
860     /**
861      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
862      * If there are multiple variables, please pack them into a uint64.
863      */
864     function _setAux(address owner, uint64 aux) internal {
865         _addressData[owner].aux = aux;
866     }
867 
868     /**
869      * Gas spent here starts off proportional to the maximum mint batch size.
870      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
871      */
872     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
873         uint256 curr = tokenId;
874 
875         unchecked {
876             if (_startTokenId() <= curr && curr < _currentIndex) {
877                 TokenOwnership memory ownership = _ownerships[curr];
878                 if (!ownership.burned) {
879                     if (ownership.addr != address(0)) {
880                         return ownership;
881                     }
882                     // Invariant:
883                     // There will always be an ownership that has an address and is not burned
884                     // before an ownership that does not have an address and is not burned.
885                     // Hence, curr will not underflow.
886                     while (true) {
887                         curr--;
888                         ownership = _ownerships[curr];
889                         if (ownership.addr != address(0)) {
890                             return ownership;
891                         }
892                     }
893                 }
894             }
895         }
896         revert OwnerQueryForNonexistentToken();
897     }
898 
899     /**
900      * @dev See {IERC721-ownerOf}.
901      */
902     function ownerOf(uint256 tokenId) public view override returns (address) {
903         return _ownershipOf(tokenId).addr;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-name}.
908      */
909     function name() public view virtual override returns (string memory) {
910         return _name;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-symbol}.
915      */
916     function symbol() public view virtual override returns (string memory) {
917         return _symbol;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-tokenURI}.
922      */
923     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
924         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
925 
926         string memory baseURI = _baseURI();
927         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
928     }
929 
930     /**
931      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
932      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
933      * by default, can be overriden in child contracts.
934      */
935     function _baseURI() internal view virtual returns (string memory) {
936         return '';
937     }
938 
939     /**
940      * @dev See {IERC721-approve}.
941      */
942     function approve(address to, uint256 tokenId) public override {
943         address owner = ERC721A.ownerOf(tokenId);
944         if (to == owner) revert ApprovalToCurrentOwner();
945 
946         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
947             revert ApprovalCallerNotOwnerNorApproved();
948         }
949 
950         _approve(to, tokenId, owner);
951     }
952 
953     /**
954      * @dev See {IERC721-getApproved}.
955      */
956     function getApproved(uint256 tokenId) public view override returns (address) {
957         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
958 
959         return _tokenApprovals[tokenId];
960     }
961 
962     /**
963      * @dev See {IERC721-setApprovalForAll}.
964      */
965     function setApprovalForAll(address operator, bool approved) public virtual override {
966         if (operator == _msgSender()) revert ApproveToCaller();
967 
968         _operatorApprovals[_msgSender()][operator] = approved;
969         emit ApprovalForAll(_msgSender(), operator, approved);
970     }
971 
972     /**
973      * @dev See {IERC721-isApprovedForAll}.
974      */
975     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
976         return _operatorApprovals[owner][operator];
977     }
978 
979     /**
980      * @dev See {IERC721-transferFrom}.
981      */
982     function transferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         _transfer(from, to, tokenId);
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         safeTransferFrom(from, to, tokenId, '');
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) public virtual override {
1010         _transfer(from, to, tokenId);
1011         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1012             revert TransferToNonERC721ReceiverImplementer();
1013         }
1014     }
1015 
1016     /**
1017      * @dev Returns whether `tokenId` exists.
1018      *
1019      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1020      *
1021      * Tokens start existing when they are minted (`_mint`),
1022      */
1023     function _exists(uint256 tokenId) internal view returns (bool) {
1024         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1025             !_ownerships[tokenId].burned;
1026     }
1027 
1028     function _safeMint(address to, uint256 quantity) internal {
1029         _safeMint(to, quantity, '');
1030     }
1031 
1032     /**
1033      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1038      * - `quantity` must be greater than 0.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _safeMint(
1043         address to,
1044         uint256 quantity,
1045         bytes memory _data
1046     ) internal {
1047         _mint(to, quantity, _data, true);
1048     }
1049 
1050     /**
1051      * @dev Mints `quantity` tokens and transfers them to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `quantity` must be greater than 0.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _mint(
1061         address to,
1062         uint256 quantity,
1063         bytes memory _data,
1064         bool safe
1065     ) internal {
1066         uint256 startTokenId = _currentIndex;
1067         if (to == address(0)) revert MintToZeroAddress();
1068         if (quantity == 0) revert MintZeroQuantity();
1069 
1070         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1071 
1072         // Overflows are incredibly unrealistic.
1073         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1074         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1075         unchecked {
1076             _addressData[to].balance += uint64(quantity);
1077             _addressData[to].numberMinted += uint64(quantity);
1078 
1079             _ownerships[startTokenId].addr = to;
1080             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1081 
1082             uint256 updatedIndex = startTokenId;
1083             uint256 end = updatedIndex + quantity;
1084 
1085             if (safe && to.isContract()) {
1086                 do {
1087                     emit Transfer(address(0), to, updatedIndex);
1088                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1089                         revert TransferToNonERC721ReceiverImplementer();
1090                     }
1091                 } while (updatedIndex != end);
1092                 // Reentrancy protection
1093                 if (_currentIndex != startTokenId) revert();
1094             } else {
1095                 do {
1096                     emit Transfer(address(0), to, updatedIndex++);
1097                 } while (updatedIndex != end);
1098             }
1099             _currentIndex = updatedIndex;
1100         }
1101         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1102     }
1103 
1104     /**
1105      * @dev Transfers `tokenId` from `from` to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must be owned by `from`.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _transfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) private {
1119         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1120 
1121         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1122 
1123         bool isApprovedOrOwner = (_msgSender() == from ||
1124             isApprovedForAll(from, _msgSender()) ||
1125             getApproved(tokenId) == _msgSender());
1126 
1127         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1128         if (to == address(0)) revert TransferToZeroAddress();
1129 
1130         _beforeTokenTransfers(from, to, tokenId, 1);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId, from);
1134 
1135         // Underflow of the sender's balance is impossible because we check for
1136         // ownership above and the recipient's balance can't realistically overflow.
1137         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1138         unchecked {
1139             _addressData[from].balance -= 1;
1140             _addressData[to].balance += 1;
1141 
1142             TokenOwnership storage currSlot = _ownerships[tokenId];
1143             currSlot.addr = to;
1144             currSlot.startTimestamp = uint64(block.timestamp);
1145 
1146             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1147             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1148             uint256 nextTokenId = tokenId + 1;
1149             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1150             if (nextSlot.addr == address(0)) {
1151                 // This will suffice for checking _exists(nextTokenId),
1152                 // as a burned slot cannot contain the zero address.
1153                 if (nextTokenId != _currentIndex) {
1154                     nextSlot.addr = from;
1155                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1156                 }
1157             }
1158         }
1159 
1160         emit Transfer(from, to, tokenId);
1161         _afterTokenTransfers(from, to, tokenId, 1);
1162     }
1163 
1164     /**
1165      * @dev This is equivalent to _burn(tokenId, false)
1166      */
1167     function _burn(uint256 tokenId) internal virtual {
1168         _burn(tokenId, false);
1169     }
1170 
1171     /**
1172      * @dev Destroys `tokenId`.
1173      * The approval is cleared when the token is burned.
1174      *
1175      * Requirements:
1176      *
1177      * - `tokenId` must exist.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1182         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1183 
1184         address from = prevOwnership.addr;
1185 
1186         if (approvalCheck) {
1187             bool isApprovedOrOwner = (_msgSender() == from ||
1188                 isApprovedForAll(from, _msgSender()) ||
1189                 getApproved(tokenId) == _msgSender());
1190 
1191             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1192         }
1193 
1194         _beforeTokenTransfers(from, address(0), tokenId, 1);
1195 
1196         // Clear approvals from the previous owner
1197         _approve(address(0), tokenId, from);
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1202         unchecked {
1203             AddressData storage addressData = _addressData[from];
1204             addressData.balance -= 1;
1205             addressData.numberBurned += 1;
1206 
1207             // Keep track of who burned the token, and the timestamp of burning.
1208             TokenOwnership storage currSlot = _ownerships[tokenId];
1209             currSlot.addr = from;
1210             currSlot.startTimestamp = uint64(block.timestamp);
1211             currSlot.burned = true;
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1217             if (nextSlot.addr == address(0)) {
1218                 // This will suffice for checking _exists(nextTokenId),
1219                 // as a burned slot cannot contain the zero address.
1220                 if (nextTokenId != _currentIndex) {
1221                     nextSlot.addr = from;
1222                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(from, address(0), tokenId);
1228         _afterTokenTransfers(from, address(0), tokenId, 1);
1229 
1230         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1231         unchecked {
1232             _burnCounter++;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Approve `to` to operate on `tokenId`
1238      *
1239      * Emits a {Approval} event.
1240      */
1241     function _approve(
1242         address to,
1243         uint256 tokenId,
1244         address owner
1245     ) private {
1246         _tokenApprovals[tokenId] = to;
1247         emit Approval(owner, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1252      *
1253      * @param from address representing the previous owner of the given token ID
1254      * @param to target address that will receive the tokens
1255      * @param tokenId uint256 ID of the token to be transferred
1256      * @param _data bytes optional data to send along with the call
1257      * @return bool whether the call correctly returned the expected magic value
1258      */
1259     function _checkContractOnERC721Received(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) private returns (bool) {
1265         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1266             return retval == IERC721Receiver(to).onERC721Received.selector;
1267         } catch (bytes memory reason) {
1268             if (reason.length == 0) {
1269                 revert TransferToNonERC721ReceiverImplementer();
1270             } else {
1271                 assembly {
1272                     revert(add(32, reason), mload(reason))
1273                 }
1274             }
1275         }
1276     }
1277 
1278     /**
1279      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1280      * And also called before burning one token.
1281      *
1282      * startTokenId - the first token id to be transferred
1283      * quantity - the amount to be transferred
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, `tokenId` will be burned by `from`.
1291      * - `from` and `to` are never both zero.
1292      */
1293     function _beforeTokenTransfers(
1294         address from,
1295         address to,
1296         uint256 startTokenId,
1297         uint256 quantity
1298     ) internal virtual {}
1299 
1300     /**
1301      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1302      * minting.
1303      * And also called after one token has been burned.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` has been minted for `to`.
1313      * - When `to` is zero, `tokenId` has been burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _afterTokenTransfers(
1317         address from,
1318         address to,
1319         uint256 startTokenId,
1320         uint256 quantity
1321     ) internal virtual {}
1322 }
1323 
1324 
1325 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1326 
1327 
1328 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 /**
1333  * @dev Contract module which provides a basic access control mechanism, where
1334  * there is an account (an owner) that can be granted exclusive access to
1335  * specific functions.
1336  *
1337  * By default, the owner account will be the one that deploys the contract. This
1338  * can later be changed with {transferOwnership}.
1339  *
1340  * This module is used through inheritance. It will make available the modifier
1341  * `onlyOwner`, which can be applied to your functions to restrict their use to
1342  * the owner.
1343  */
1344 abstract contract Ownable is Context {
1345     address private _owner;
1346 
1347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1348 
1349     /**
1350      * @dev Initializes the contract setting the deployer as the initial owner.
1351      */
1352     constructor() {
1353         _transferOwnership(_msgSender());
1354     }
1355 
1356     /**
1357      * @dev Throws if called by any account other than the owner.
1358      */
1359     modifier onlyOwner() {
1360         _checkOwner();
1361         _;
1362     }
1363 
1364     /**
1365      * @dev Returns the address of the current owner.
1366      */
1367     function owner() public view virtual returns (address) {
1368         return _owner;
1369     }
1370 
1371     /**
1372      * @dev Throws if the sender is not the owner.
1373      */
1374     function _checkOwner() internal view virtual {
1375         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1376     }
1377 
1378     /**
1379      * @dev Leaves the contract without owner. It will not be possible to call
1380      * `onlyOwner` functions anymore. Can only be called by the current owner.
1381      *
1382      * NOTE: Renouncing ownership will leave the contract without an owner,
1383      * thereby removing any functionality that is only available to the owner.
1384      */
1385     function renounceOwnership() public virtual onlyOwner {
1386         _transferOwnership(address(0));
1387     }
1388 
1389     /**
1390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1391      * Can only be called by the current owner.
1392      */
1393     function transferOwnership(address newOwner) public virtual onlyOwner {
1394         require(newOwner != address(0), "Ownable: new owner is the zero address");
1395         _transferOwnership(newOwner);
1396     }
1397 
1398     /**
1399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1400      * Internal function without access restriction.
1401      */
1402     function _transferOwnership(address newOwner) internal virtual {
1403         address oldOwner = _owner;
1404         _owner = newOwner;
1405         emit OwnershipTransferred(oldOwner, newOwner);
1406     }
1407 }
1408 
1409 
1410 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.3
1411 
1412 
1413 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 /**
1418  * @dev Interface for the NFT Royalty Standard.
1419  *
1420  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1421  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1422  *
1423  * _Available since v4.5._
1424  */
1425 interface IERC2981 is IERC165 {
1426     /**
1427      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1428      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1429      */
1430     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1431         external
1432         view
1433         returns (address receiver, uint256 royaltyAmount);
1434 }
1435 
1436 
1437 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.3
1438 
1439 
1440 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1441 
1442 pragma solidity ^0.8.0;
1443 
1444 
1445 /**
1446  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1447  *
1448  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1449  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1450  *
1451  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1452  * fee is specified in basis points by default.
1453  *
1454  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1455  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1456  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1457  *
1458  * _Available since v4.5._
1459  */
1460 abstract contract ERC2981 is IERC2981, ERC165 {
1461     struct RoyaltyInfo {
1462         address receiver;
1463         uint96 royaltyFraction;
1464     }
1465 
1466     RoyaltyInfo private _defaultRoyaltyInfo;
1467     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1468 
1469     /**
1470      * @dev See {IERC165-supportsInterface}.
1471      */
1472     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1473         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1474     }
1475 
1476     /**
1477      * @inheritdoc IERC2981
1478      */
1479     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1480         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1481 
1482         if (royalty.receiver == address(0)) {
1483             royalty = _defaultRoyaltyInfo;
1484         }
1485 
1486         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1487 
1488         return (royalty.receiver, royaltyAmount);
1489     }
1490 
1491     /**
1492      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1493      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1494      * override.
1495      */
1496     function _feeDenominator() internal pure virtual returns (uint96) {
1497         return 10000;
1498     }
1499 
1500     /**
1501      * @dev Sets the royalty information that all ids in this contract will default to.
1502      *
1503      * Requirements:
1504      *
1505      * - `receiver` cannot be the zero address.
1506      * - `feeNumerator` cannot be greater than the fee denominator.
1507      */
1508     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1509         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1510         require(receiver != address(0), "ERC2981: invalid receiver");
1511 
1512         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1513     }
1514 
1515     /**
1516      * @dev Removes default royalty information.
1517      */
1518     function _deleteDefaultRoyalty() internal virtual {
1519         delete _defaultRoyaltyInfo;
1520     }
1521 
1522     /**
1523      * @dev Sets the royalty information for a specific token id, overriding the global default.
1524      *
1525      * Requirements:
1526      *
1527      * - `receiver` cannot be the zero address.
1528      * - `feeNumerator` cannot be greater than the fee denominator.
1529      */
1530     function _setTokenRoyalty(
1531         uint256 tokenId,
1532         address receiver,
1533         uint96 feeNumerator
1534     ) internal virtual {
1535         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1536         require(receiver != address(0), "ERC2981: Invalid parameters");
1537 
1538         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1539     }
1540 
1541     /**
1542      * @dev Resets royalty information for the token id back to the global default.
1543      */
1544     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1545         delete _tokenRoyaltyInfo[tokenId];
1546     }
1547 }
1548 
1549 
1550 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.3
1551 
1552 
1553 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 /**
1558  * @dev These functions deal with verification of Merkle Tree proofs.
1559  *
1560  * The proofs can be generated using the JavaScript library
1561  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1562  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1563  *
1564  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1565  *
1566  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1567  * hashing, or use a hash function other than keccak256 for hashing leaves.
1568  * This is because the concatenation of a sorted pair of internal nodes in
1569  * the merkle tree could be reinterpreted as a leaf value.
1570  */
1571 library MerkleProof {
1572     /**
1573      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1574      * defined by `root`. For this, a `proof` must be provided, containing
1575      * sibling hashes on the branch from the leaf to the root of the tree. Each
1576      * pair of leaves and each pair of pre-images are assumed to be sorted.
1577      */
1578     function verify(
1579         bytes32[] memory proof,
1580         bytes32 root,
1581         bytes32 leaf
1582     ) internal pure returns (bool) {
1583         return processProof(proof, leaf) == root;
1584     }
1585 
1586     /**
1587      * @dev Calldata version of {verify}
1588      *
1589      * _Available since v4.7._
1590      */
1591     function verifyCalldata(
1592         bytes32[] calldata proof,
1593         bytes32 root,
1594         bytes32 leaf
1595     ) internal pure returns (bool) {
1596         return processProofCalldata(proof, leaf) == root;
1597     }
1598 
1599     /**
1600      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1601      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1602      * hash matches the root of the tree. When processing the proof, the pairs
1603      * of leafs & pre-images are assumed to be sorted.
1604      *
1605      * _Available since v4.4._
1606      */
1607     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1608         bytes32 computedHash = leaf;
1609         for (uint256 i = 0; i < proof.length; i++) {
1610             computedHash = _hashPair(computedHash, proof[i]);
1611         }
1612         return computedHash;
1613     }
1614 
1615     /**
1616      * @dev Calldata version of {processProof}
1617      *
1618      * _Available since v4.7._
1619      */
1620     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1621         bytes32 computedHash = leaf;
1622         for (uint256 i = 0; i < proof.length; i++) {
1623             computedHash = _hashPair(computedHash, proof[i]);
1624         }
1625         return computedHash;
1626     }
1627 
1628     /**
1629      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1630      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1631      *
1632      * _Available since v4.7._
1633      */
1634     function multiProofVerify(
1635         bytes32[] memory proof,
1636         bool[] memory proofFlags,
1637         bytes32 root,
1638         bytes32[] memory leaves
1639     ) internal pure returns (bool) {
1640         return processMultiProof(proof, proofFlags, leaves) == root;
1641     }
1642 
1643     /**
1644      * @dev Calldata version of {multiProofVerify}
1645      *
1646      * _Available since v4.7._
1647      */
1648     function multiProofVerifyCalldata(
1649         bytes32[] calldata proof,
1650         bool[] calldata proofFlags,
1651         bytes32 root,
1652         bytes32[] memory leaves
1653     ) internal pure returns (bool) {
1654         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1655     }
1656 
1657     /**
1658      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1659      * consuming from one or the other at each step according to the instructions given by
1660      * `proofFlags`.
1661      *
1662      * _Available since v4.7._
1663      */
1664     function processMultiProof(
1665         bytes32[] memory proof,
1666         bool[] memory proofFlags,
1667         bytes32[] memory leaves
1668     ) internal pure returns (bytes32 merkleRoot) {
1669         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1670         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1671         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1672         // the merkle tree.
1673         uint256 leavesLen = leaves.length;
1674         uint256 totalHashes = proofFlags.length;
1675 
1676         // Check proof validity.
1677         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1678 
1679         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1680         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1681         bytes32[] memory hashes = new bytes32[](totalHashes);
1682         uint256 leafPos = 0;
1683         uint256 hashPos = 0;
1684         uint256 proofPos = 0;
1685         // At each step, we compute the next hash using two values:
1686         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1687         //   get the next hash.
1688         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1689         //   `proof` array.
1690         for (uint256 i = 0; i < totalHashes; i++) {
1691             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1692             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1693             hashes[i] = _hashPair(a, b);
1694         }
1695 
1696         if (totalHashes > 0) {
1697             return hashes[totalHashes - 1];
1698         } else if (leavesLen > 0) {
1699             return leaves[0];
1700         } else {
1701             return proof[0];
1702         }
1703     }
1704 
1705     /**
1706      * @dev Calldata version of {processMultiProof}
1707      *
1708      * _Available since v4.7._
1709      */
1710     function processMultiProofCalldata(
1711         bytes32[] calldata proof,
1712         bool[] calldata proofFlags,
1713         bytes32[] memory leaves
1714     ) internal pure returns (bytes32 merkleRoot) {
1715         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1716         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1717         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1718         // the merkle tree.
1719         uint256 leavesLen = leaves.length;
1720         uint256 totalHashes = proofFlags.length;
1721 
1722         // Check proof validity.
1723         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1724 
1725         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1726         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1727         bytes32[] memory hashes = new bytes32[](totalHashes);
1728         uint256 leafPos = 0;
1729         uint256 hashPos = 0;
1730         uint256 proofPos = 0;
1731         // At each step, we compute the next hash using two values:
1732         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1733         //   get the next hash.
1734         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1735         //   `proof` array.
1736         for (uint256 i = 0; i < totalHashes; i++) {
1737             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1738             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1739             hashes[i] = _hashPair(a, b);
1740         }
1741 
1742         if (totalHashes > 0) {
1743             return hashes[totalHashes - 1];
1744         } else if (leavesLen > 0) {
1745             return leaves[0];
1746         } else {
1747             return proof[0];
1748         }
1749     }
1750 
1751     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1752         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1753     }
1754 
1755     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1756         /// @solidity memory-safe-assembly
1757         assembly {
1758             mstore(0x00, a)
1759             mstore(0x20, b)
1760             value := keccak256(0x00, 0x40)
1761         }
1762     }
1763 }
1764 
1765 /******************************************************************************
1766     Smart contract generated on https://bueno.art
1767 
1768     Bueno is a suite of tools that allow artists to create generative art, 
1769     deploy smart contracts, and more -- all with no code.
1770 
1771     Bueno is not associated or affiliated with this project.
1772     Bueno is not liable for any bugs or minting issues associated with this contract.
1773 /******************************************************************************/
1774 
1775 pragma solidity ^0.8.7;
1776 
1777 error SaleInactive();
1778 error SoldOut();
1779 error InvalidPrice();
1780 error WithdrawFailed();
1781 error InvalidQuantity();
1782 error InvalidProof();
1783 error InvalidBatchMint();
1784 
1785 contract TheDoriSamurai is ERC721A, Ownable, ERC2981, OperatorFilterer {
1786     uint256 public price = 0.0088 ether;
1787     uint256 public presalePrice = 0.0044 ether;
1788     uint256 public maxPerWallet = 2;
1789     uint256 public maxPerTransaction = 1;
1790     uint256 public presaleMaxPerWallet = 1;
1791     uint256 public presaleMaxPerTransaction = 1;
1792 
1793     uint256 public immutable presaleSupply = 888;
1794     uint256 public immutable supply = 888;
1795 
1796     enum SaleState {
1797         CLOSED,
1798         OPEN,
1799         PRESALE
1800     }
1801 
1802     SaleState public saleState = SaleState.CLOSED;
1803 
1804     string public _baseTokenURI;
1805 
1806     mapping(address => uint256) public addressMintBalance;
1807 
1808     address[] public withdrawAddresses = [0x117931C9CF3FDcaa12eBA112cbaEd913aAdcFcF2, 0x985AFcA097414E5510c2C4faEbDb287E4F237A1B];
1809     uint256[] public withdrawPercentages = [95, 5];
1810 
1811     bytes32 public merkleRoot = 0x2fbcb0ffc2d1bd79f6b0343fb8bb5ba7fce60efc3999d4d68b4141c8e09ec4ed;
1812 
1813     constructor(
1814         string memory _name,
1815         string memory _symbol,
1816         string memory _baseUri,
1817         uint96 _royaltyAmount
1818     ) ERC721A(_name, _symbol) OperatorFilterer(address(0), false) {
1819         _baseTokenURI = _baseUri;
1820         _setDefaultRoyalty(0x117931C9CF3FDcaa12eBA112cbaEd913aAdcFcF2, _royaltyAmount);
1821     }
1822 
1823     function mint(uint256 qty) external payable {
1824         if (saleState != SaleState.OPEN) revert SaleInactive();
1825         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1826         if (msg.value != price * qty) revert InvalidPrice();
1827 
1828         if (addressMintBalance[msg.sender] + qty > maxPerWallet) revert InvalidQuantity();
1829         if (qty > maxPerTransaction) revert InvalidQuantity();
1830         addressMintBalance[msg.sender] += qty;
1831 
1832         _safeMint(msg.sender, qty);
1833 
1834     }
1835 
1836     function presale(uint256 qty, bytes32[] calldata merkleProof) external payable {
1837         if (saleState != SaleState.PRESALE) revert SaleInactive();
1838         if (_currentIndex + (qty - 1) > presaleSupply) revert SoldOut();
1839         if (msg.value != presalePrice * qty) revert InvalidPrice();
1840 
1841         if (!MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender)))) { 
1842           revert InvalidProof();
1843         }
1844         if (addressMintBalance[msg.sender] + qty > presaleMaxPerWallet) revert InvalidQuantity();
1845         if (qty > presaleMaxPerTransaction) revert InvalidQuantity();
1846         addressMintBalance[msg.sender] += qty;
1847 
1848         _safeMint(msg.sender, qty);
1849 
1850     }
1851 
1852     function _startTokenId() internal view virtual override returns (uint256) {
1853         return 1;
1854     }
1855 
1856     function _baseURI() internal view virtual override returns (string memory) {
1857         return _baseTokenURI;
1858     }
1859 
1860     
1861 
1862     function setBaseURI(string memory baseURI) external onlyOwner {
1863         _baseTokenURI = baseURI;
1864     }
1865 
1866     function setPrice(uint256 newPrice) external onlyOwner {
1867         price = newPrice;
1868     }
1869 
1870     function setPresalePrice(uint256 newPrice) external onlyOwner {
1871         presalePrice = newPrice;
1872     }
1873 
1874     function setSaleState(uint8 _state) external onlyOwner {
1875         saleState = SaleState(_state);
1876     }
1877 
1878     function freeMint(uint256 qty, address recipient) external onlyOwner {
1879         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1880         _safeMint(recipient, qty);
1881     }
1882 
1883     function batchMint(uint64[] calldata qtys, address[] calldata recipients)
1884         external
1885         onlyOwner
1886     {
1887         uint256 numRecipients = recipients.length;
1888         if (numRecipients != qtys.length) revert InvalidBatchMint();
1889 
1890         for (uint256 i = 0; i < numRecipients; ) {
1891             if ((_currentIndex - 1) + qtys[i] > supply) revert SoldOut();
1892 
1893             _safeMint(recipients[i], qtys[i]);
1894 
1895             unchecked {
1896                 i++;
1897             }
1898         }
1899     }
1900 
1901     function setPerWalletMax(uint256 _val) external onlyOwner {
1902         maxPerWallet = _val;
1903     }
1904 
1905     function setPerTransactionMax(uint256 _val) external onlyOwner {
1906         maxPerTransaction = _val;
1907     }
1908 
1909     function setPresalePerWalletMax(uint256 _val) external onlyOwner {
1910         presaleMaxPerWallet = _val;
1911     }
1912 
1913     function setPresalePerTransactionMax(uint256 _val) external onlyOwner {
1914         presaleMaxPerTransaction = _val;
1915     }
1916 
1917     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1918         merkleRoot = _merkleRoot;
1919     }
1920 
1921     function _withdraw(address _address, uint256 _amount) private {
1922         (bool success, ) = _address.call{value: _amount}("");
1923         if (!success) revert WithdrawFailed();
1924     }
1925 
1926     function withdraw() external onlyOwner {
1927         uint256 balance = address(this).balance;
1928 
1929         for (uint256 i; i < withdrawAddresses.length; i++) {
1930             _withdraw(withdrawAddresses[i], (balance * withdrawPercentages[i]) / 100);
1931         }
1932     }
1933 
1934     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1935         external
1936         onlyOwner
1937     {
1938         _setDefaultRoyalty(receiver, feeBasisPoints);
1939     }
1940 
1941     function supportsInterface(bytes4 interfaceId)
1942         public
1943         view
1944         override(ERC721A, ERC2981)
1945         returns (bool)
1946     {
1947         return super.supportsInterface(interfaceId);
1948     }
1949 
1950     function transferFrom(
1951         address from,
1952         address to,
1953         uint256 tokenId
1954     ) public override onlyAllowedOperator(from) {
1955         super.transferFrom(from, to, tokenId);
1956     }
1957 
1958     function safeTransferFrom(
1959         address from,
1960         address to,
1961         uint256 tokenId
1962     ) public override onlyAllowedOperator(from) {
1963         super.safeTransferFrom(from, to, tokenId);
1964     }
1965 
1966     function safeTransferFrom(
1967         address from,
1968         address to,
1969         uint256 tokenId,
1970         bytes memory data
1971     ) public override onlyAllowedOperator(from) {
1972         super.safeTransferFrom(from, to, tokenId, data);
1973     }
1974 }