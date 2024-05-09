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
98 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 
126 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Interface of the ERC165 standard, as defined in the
135  * https://eips.ethereum.org/EIPS/eip-165[EIP].
136  *
137  * Implementers can declare support of contract interfaces, which can then be
138  * queried by others ({ERC165Checker}).
139  *
140  * For an implementation, see {ERC165}.
141  */
142 interface IERC165 {
143     /**
144      * @dev Returns true if this contract implements the interface defined by
145      * `interfaceId`. See the corresponding
146      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
147      * to learn more about how these ids are created.
148      *
149      * This function call must use less than 30 000 gas.
150      */
151     function supportsInterface(bytes4 interfaceId) external view returns (bool);
152 }
153 
154 
155 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
156 
157 
158 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev Required interface of an ERC721 compliant contract.
164  */
165 interface IERC721 is IERC165 {
166     /**
167      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
170 
171     /**
172      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
173      */
174     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
175 
176     /**
177      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
178      */
179     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
180 
181     /**
182      * @dev Returns the number of tokens in ``owner``'s account.
183      */
184     function balanceOf(address owner) external view returns (uint256 balance);
185 
186     /**
187      * @dev Returns the owner of the `tokenId` token.
188      *
189      * Requirements:
190      *
191      * - `tokenId` must exist.
192      */
193     function ownerOf(uint256 tokenId) external view returns (address owner);
194 
195     /**
196      * @dev Safely transfers `tokenId` token from `from` to `to`.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must exist and be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
205      *
206      * Emits a {Transfer} event.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId,
212         bytes calldata data
213     ) external;
214 
215     /**
216      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
217      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must exist and be owned by `from`.
224      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
225      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
226      *
227      * Emits a {Transfer} event.
228      */
229     function safeTransferFrom(
230         address from,
231         address to,
232         uint256 tokenId
233     ) external;
234 
235     /**
236      * @dev Transfers `tokenId` token from `from` to `to`.
237      *
238      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(
250         address from,
251         address to,
252         uint256 tokenId
253     ) external;
254 
255     /**
256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
257      * The approval is cleared when the token is transferred.
258      *
259      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
260      *
261      * Requirements:
262      *
263      * - The caller must own the token or be an approved operator.
264      * - `tokenId` must exist.
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Approve or remove `operator` as an operator for the caller.
272      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
273      *
274      * Requirements:
275      *
276      * - The `operator` cannot be the caller.
277      *
278      * Emits an {ApprovalForAll} event.
279      */
280     function setApprovalForAll(address operator, bool _approved) external;
281 
282     /**
283      * @dev Returns the account approved for `tokenId` token.
284      *
285      * Requirements:
286      *
287      * - `tokenId` must exist.
288      */
289     function getApproved(uint256 tokenId) external view returns (address operator);
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) external view returns (bool);
297 }
298 
299 
300 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
301 
302 
303 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 
331 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
340  * @dev See https://eips.ethereum.org/EIPS/eip-721
341  */
342 interface IERC721Metadata is IERC721 {
343     /**
344      * @dev Returns the token collection name.
345      */
346     function name() external view returns (string memory);
347 
348     /**
349      * @dev Returns the token collection symbol.
350      */
351     function symbol() external view returns (string memory);
352 
353     /**
354      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
355      */
356     function tokenURI(uint256 tokenId) external view returns (string memory);
357 }
358 
359 
360 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
361 
362 
363 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev String operations.
369  */
370 library Strings {
371     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
372     uint8 private constant _ADDRESS_LENGTH = 20;
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
376      */
377     function toString(uint256 value) internal pure returns (string memory) {
378         // Inspired by OraclizeAPI's implementation - MIT licence
379         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
380 
381         if (value == 0) {
382             return "0";
383         }
384         uint256 temp = value;
385         uint256 digits;
386         while (temp != 0) {
387             digits++;
388             temp /= 10;
389         }
390         bytes memory buffer = new bytes(digits);
391         while (value != 0) {
392             digits -= 1;
393             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
394             value /= 10;
395         }
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
401      */
402     function toHexString(uint256 value) internal pure returns (string memory) {
403         if (value == 0) {
404             return "0x00";
405         }
406         uint256 temp = value;
407         uint256 length = 0;
408         while (temp != 0) {
409             length++;
410             temp >>= 8;
411         }
412         return toHexString(value, length);
413     }
414 
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
417      */
418     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
419         bytes memory buffer = new bytes(2 * length + 2);
420         buffer[0] = "0";
421         buffer[1] = "x";
422         for (uint256 i = 2 * length + 1; i > 1; --i) {
423             buffer[i] = _HEX_SYMBOLS[value & 0xf];
424             value >>= 4;
425         }
426         require(value == 0, "Strings: hex length insufficient");
427         return string(buffer);
428     }
429 
430     /**
431      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
432      */
433     function toHexString(address addr) internal pure returns (string memory) {
434         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
435     }
436 }
437 
438 
439 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
440 
441 
442 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
443 
444 pragma solidity ^0.8.1;
445 
446 /**
447  * @dev Collection of functions related to the address type
448  */
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * [IMPORTANT]
454      * ====
455      * It is unsafe to assume that an address for which this function returns
456      * false is an externally-owned account (EOA) and not a contract.
457      *
458      * Among others, `isContract` will return false for the following
459      * types of addresses:
460      *
461      *  - an externally-owned account
462      *  - a contract in construction
463      *  - an address where a contract will be created
464      *  - an address where a contract lived, but was destroyed
465      * ====
466      *
467      * [IMPORTANT]
468      * ====
469      * You shouldn't rely on `isContract` to protect against flash loan attacks!
470      *
471      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
472      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
473      * constructor.
474      * ====
475      */
476     function isContract(address account) internal view returns (bool) {
477         // This method relies on extcodesize/address.code.length, which returns 0
478         // for contracts in construction, since the code is only stored at the end
479         // of the constructor execution.
480 
481         return account.code.length > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652                 /// @solidity memory-safe-assembly
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
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
1549 /******************************************************************************
1550     Smart contract generated on https://bueno.art
1551 
1552     Bueno is a suite of tools that allow artists to create generative art, 
1553     deploy smart contracts, and more -- all with no code.
1554 
1555     Bueno is not associated or affiliated with this project.
1556     Bueno is not liable for any bugs or minting issues associated with this contract.
1557 /******************************************************************************/
1558 
1559 pragma solidity ^0.8.7;
1560 
1561 error SaleInactive();
1562 error SoldOut();
1563 error InvalidPrice();
1564 error WithdrawFailed();
1565 error InvalidQuantity();
1566 error InvalidBatchMint();
1567 
1568 contract ArtDied is ERC721A, Ownable, ERC2981, OperatorFilterer {
1569     uint256 public price = 0.00 ether;
1570     uint256 public maxPerWallet = 1;
1571     uint256 public maxPerTransaction = 1;
1572 
1573     uint256 public immutable supply = 223;
1574 
1575     enum SaleState {
1576         CLOSED,
1577         OPEN
1578     }
1579 
1580     SaleState public saleState = SaleState.CLOSED;
1581 
1582     string public _baseTokenURI;
1583 
1584     mapping(address => uint256) public addressMintBalance;
1585 
1586     address[] public withdrawAddresses = [0xdAb6Eba99906A06b92731F8a1058F5C6BD8Bf779, 0x985AFcA097414E5510c2C4faEbDb287E4F237A1B];
1587     uint256[] public withdrawPercentages = [95, 5];
1588 
1589     constructor(
1590         string memory _name,
1591         string memory _symbol,
1592         string memory _baseUri,
1593         uint96 _royaltyAmount
1594     ) ERC721A(_name, _symbol) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1595         _baseTokenURI = _baseUri;
1596         _setDefaultRoyalty(0xdAb6Eba99906A06b92731F8a1058F5C6BD8Bf779, _royaltyAmount);
1597     }
1598 
1599     function mint(uint256 qty) external payable {
1600         if (saleState != SaleState.OPEN) revert SaleInactive();
1601         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1602         if (msg.value != price * qty) revert InvalidPrice();
1603 
1604         if (addressMintBalance[msg.sender] + qty > maxPerWallet) revert InvalidQuantity();
1605         if (qty > maxPerTransaction) revert InvalidQuantity();
1606         addressMintBalance[msg.sender] += qty;
1607 
1608         _safeMint(msg.sender, qty);
1609 
1610     }
1611 
1612     function _startTokenId() internal view virtual override returns (uint256) {
1613         return 1;
1614     }
1615 
1616     function _baseURI() internal view virtual override returns (string memory) {
1617         return _baseTokenURI;
1618     }
1619 
1620     
1621 
1622     function setBaseURI(string memory baseURI) external onlyOwner {
1623         _baseTokenURI = baseURI;
1624     }
1625 
1626     function setPrice(uint256 newPrice) external onlyOwner {
1627         price = newPrice;
1628     }
1629 
1630     function setSaleState(uint8 _state) external onlyOwner {
1631         saleState = SaleState(_state);
1632     }
1633 
1634     function freeMint(uint256 qty, address recipient) external onlyOwner {
1635         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1636         _safeMint(recipient, qty);
1637     }
1638 
1639     function batchMint(uint64[] calldata qtys, address[] calldata recipients)
1640         external
1641         onlyOwner
1642     {
1643         uint256 numRecipients = recipients.length;
1644         if (numRecipients != qtys.length) revert InvalidBatchMint();
1645 
1646         for (uint256 i = 0; i < numRecipients; ) {
1647             if ((_currentIndex - 1) + qtys[i] > supply) revert SoldOut();
1648 
1649             _safeMint(recipients[i], qtys[i]);
1650 
1651             unchecked {
1652                 i++;
1653             }
1654         }
1655     }
1656     
1657     function setPerWalletMax(uint256 _val) external onlyOwner {
1658         maxPerWallet = _val;
1659     }
1660 
1661     function setPerTransactionMax(uint256 _val) external onlyOwner {
1662         maxPerTransaction = _val;
1663     }
1664 
1665     function _withdraw(address _address, uint256 _amount) private {
1666         (bool success, ) = _address.call{value: _amount}("");
1667         if (!success) revert WithdrawFailed();
1668     }
1669 
1670     function withdraw() external onlyOwner {
1671         uint256 balance = address(this).balance;
1672 
1673         for (uint256 i; i < withdrawAddresses.length; i++) {
1674             _withdraw(withdrawAddresses[i], (balance * withdrawPercentages[i]) / 100);
1675         }
1676     }
1677 
1678     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1679         external
1680         onlyOwner
1681     {
1682         _setDefaultRoyalty(receiver, feeBasisPoints);
1683     }
1684 
1685     function supportsInterface(bytes4 interfaceId)
1686         public
1687         view
1688         override(ERC721A, ERC2981)
1689         returns (bool)
1690     {
1691         return super.supportsInterface(interfaceId);
1692     }
1693 
1694     function transferFrom(
1695       address from,
1696       address to,
1697       uint256 tokenId
1698     ) public override onlyAllowedOperator(from) {
1699         super.transferFrom(from, to, tokenId);
1700     }
1701 
1702     function safeTransferFrom(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) public override onlyAllowedOperator(from) {
1707         super.safeTransferFrom(from, to, tokenId);
1708     }
1709 
1710     function safeTransferFrom(
1711         address from,
1712         address to,
1713         uint256 tokenId,
1714         bytes memory data
1715     ) public override onlyAllowedOperator(from) {
1716         super.safeTransferFrom(from, to, tokenId, data);
1717     }
1718 }