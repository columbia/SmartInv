1 // SPDX-License-Identifier: MIT
2 // File: contracts/IOperatorFilterRegistry.sol
3 
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
34 // File: contracts/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Check registry code length to facilitate testing in environments without a deployed registry.
73         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
74             // Allow spending tokens from addresses with balance
75             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
76             // from an EOA.
77             if (from == msg.sender) {
78                 _;
79                 return;
80             }
81             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
82                 revert OperatorNotAllowed(msg.sender);
83             }
84         }
85         _;
86     }
87 
88     modifier onlyAllowedOperatorApproval(address operator) virtual {
89         // Check registry code length to facilitate testing in environments without a deployed registry.
90         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
91             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
92                 revert OperatorNotAllowed(operator);
93             }
94         }
95         _;
96     }
97 }
98 
99 // File: contracts/DefaultOperatorFilterer.sol
100 
101 
102 pragma solidity ^0.8.13;
103 
104 
105 /**
106  * @title  DefaultOperatorFilterer
107  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
108  */
109 abstract contract DefaultOperatorFilterer is OperatorFilterer {
110     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
111 
112     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
113 }
114 
115 // File: contracts/contract.sol
116 
117 
118 // File: @openzeppelin/contracts/utils/Address.sol
119 
120 
121 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
122 
123 pragma solidity ^0.8.1;
124 
125 /**
126  * @dev Collection of functions related to the address type
127  */
128 library Address {
129     /**
130      * @dev Returns true if `account` is a contract.
131      *
132      * [IMPORTANT]     * ===    * It is unsafe to assume that an address for which this function returns
133      * false is an externally-owned account (EOA) and not a contract.
134      *
135      * Among others, `isContract` will return false for the following
136      * types of addresses:
137      *
138      *  - an externally-owned account
139      *  - a contract in construction
140      *  - an address where a contract will be created
141      *  - an address where a contract lived, but was destroyed
142      * ====
143      *
144      * [IMPORTANT]
145      * ====
146      * You shouldn't rely on `isContract` to protect against flash loan attacks!
147      *
148      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
149      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
150      * constructor.
151      * ====
152      */
153     function isContract(address account) internal view returns (bool) {
154         // This method relies on extcodesize/address.code.length, which returns 0
155         // for contracts in construction, since the code is only stored at the end
156         // of the constructor execution.
157 
158         return account.code.length > 0;
159     }
160 
161     /**
162      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
163      * `recipient`, forwarding all available gas and reverting on errors.
164      *
165      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
166      * of certain opcodes, possibly making contracts go over the 2300 gas limit
167      * imposed by `transfer`, making them unable to receive funds via
168      * `transfer`. {sendValue} removes this limitation.
169      *
170      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
171      *
172      * IMPORTANT: because control is transferred to `recipient`, care must be
173      * taken to not create reentrancy vulnerabilities. Consider using
174      * {ReentrancyGuard} or the
175      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
176      */
177     function sendValue(address payable recipient, uint256 amount) internal {
178         require(address(this).balance >= amount, "Address: insufficient balance");
179 
180         (bool success, ) = recipient.call{value: amount}("");
181         require(success, "Address: unable to send value, recipient may have reverted");
182     }
183 
184     /**
185      * @dev Performs a Solidity function call using a low level `call`. A
186      * plain `call` is an unsafe replacement for a function call: use this
187      * function instead.
188      *
189      * If `target` reverts with a revert reason, it is bubbled up by this
190      * function (like regular Solidity function calls).
191      *
192      * Returns the raw returned data. To convert to the expected return value,
193      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
194      *
195      * Requirements:
196      *
197      * - `target` must be a contract.
198      * - calling `target` with `data` must not revert.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
203         return functionCall(target, data, "Address: low-level call failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
208      * `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCall(
213         address target,
214         bytes memory data,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, 0, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but also transferring `value` wei to `target`.
223      *
224      * Requirements:
225      *
226      * - the calling contract must have an ETH balance of at least `value`.
227      * - the called Solidity function must be `payable`.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value
235     ) internal returns (bytes memory) {
236         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
241      * with `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCallWithValue(
246         address target,
247         bytes memory data,
248         uint256 value,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(address(this).balance >= value, "Address: insufficient balance for call");
252         require(isContract(target), "Address: call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.call{value: value}(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
265         return functionStaticCall(target, data, "Address: low-level static call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a static call.
271      *
272      * _Available since v3.3._
273      */
274     function functionStaticCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal view returns (bytes memory) {
279         require(isContract(target), "Address: static call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.staticcall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a delegate call.
298      *
299      * _Available since v3.4._
300      */
301     function functionDelegateCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(isContract(target), "Address: delegate call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.delegatecall(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
314      * revert reason using the provided one.
315      *
316      * _Available since v4.3._
317      */
318     function verifyCallResult(
319         bool success,
320         bytes memory returndata,
321         string memory errorMessage
322     ) internal pure returns (bytes memory) {
323         if (success) {
324             return returndata;
325         } else {
326             // Look for revert reason and bubble it up if present
327             if (returndata.length > 0) {
328                 // The easiest way to bubble the revert reason is using memory via assembly
329                 /// @solidity memory-safe-assembly
330                 assembly {
331                     let returndata_size := mload(returndata)
332                     revert(add(32, returndata), returndata_size)
333                 }
334             } else {
335                 revert(errorMessage);
336             }
337         }
338     }
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
342 
343 
344 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @title ERC721 token receiver interface
350  * @dev Interface for any contract that wants to support safeTransfers
351  * from ERC721 asset contracts.
352  */
353 interface IERC721Receiver {
354     /**
355      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
356      * by `operator` from `from`, this function is called.
357      *
358      * It must return its Solidity selector to confirm the token transfer.
359      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
360      *
361      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
362      */
363     function onERC721Received(
364         address operator,
365         address from,
366         uint256 tokenId,
367         bytes calldata data
368     ) external returns (bytes4);
369 }
370 
371 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Interface of the ERC165 standard, as defined in the
380  * https://eips.ethereum.org/EIPS/eip-165[EIP].
381  *
382  * Implementers can declare support of contract interfaces, which can then be
383  * queried by others ({ERC165Checker}).
384  *
385  * For an implementation, see {ERC165}.
386  */
387 interface IERC165 {
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30 000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 }
398 
399 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Implementation of the {IERC165} interface.
409  *
410  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
411  * for the additional interface id that will be supported. For example:
412  *
413  * ```solidity
414  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
416  * }
417  * ```
418  *
419  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
420  */
421 abstract contract ERC165 is IERC165 {
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426         return interfaceId == type(IERC165).interfaceId;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 
438 /**
439  * @dev Required interface of an ERC721 compliant contract.
440  */
441 interface IERC721 is IERC165 {
442     /**
443      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
444      */
445     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
446 
447     /**
448      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
449      */
450     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
451 
452     /**
453      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
454      */
455     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
456 
457     /**
458      * @dev Returns the number of tokens in ``owner``'s account.
459      */
460     function balanceOf(address owner) external view returns (uint256 balance);
461 
462     /**
463      * @dev Returns the owner of the `tokenId` token.
464      *
465      * Requirements:
466      *
467      * - `tokenId` must exist.
468      */
469     function ownerOf(uint256 tokenId) external view returns (address owner);
470 
471     /**
472      * @dev Safely transfers `tokenId` token from `from` to `to`.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId,
488         bytes calldata data
489     ) external;
490 
491     /**
492      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
493      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must exist and be owned by `from`.
500      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
502      *
503      * Emits a {Transfer} event.
504      */
505     function safeTransferFrom(
506         address from,
507         address to,
508         uint256 tokenId
509     ) external;
510 
511     /**
512      * @dev Transfers `tokenId` token from `from` to `to`.
513      *
514      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
515      *
516      * Requirements:
517      *
518      * - `from` cannot be the zero address.
519      * - `to` cannot be the zero address.
520      * - `tokenId` token must be owned by `from`.
521      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
522      *
523      * Emits a {Transfer} event.
524      */
525     function transferFrom(
526         address from,
527         address to,
528         uint256 tokenId
529     ) external;
530 
531     /**
532      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
533      * The approval is cleared when the token is transferred.
534      *
535      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
536      *
537      * Requirements:
538      *
539      * - The caller must own the token or be an approved operator.
540      * - `tokenId` must exist.
541      *
542      * Emits an {Approval} event.
543      */
544     function approve(address to, uint256 tokenId) external;
545 
546     /**
547      * @dev Approve or remove `operator` as an operator for the caller.
548      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
549      *
550      * Requirements:
551      *
552      * - The `operator` cannot be the caller.
553      *
554      * Emits an {ApprovalForAll} event.
555      */
556     function setApprovalForAll(address operator, bool _approved) external;
557 
558     /**
559      * @dev Returns the account approved for `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function getApproved(uint256 tokenId) external view returns (address operator);
566 
567     /**
568      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
569      *
570      * See {setApprovalForAll}
571      */
572     function isApprovedForAll(address owner, address operator) external view returns (bool);
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Enumerable is IERC721 {
588     /**
589      * @dev Returns the total amount of tokens stored by the contract.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
595      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
596      */
597     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
598 
599     /**
600      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
601      * Use along with {totalSupply} to enumerate all tokens.
602      */
603     function tokenByIndex(uint256 index) external view returns (uint256);
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 interface IERC721Metadata is IERC721 {
619     /**
620      * @dev Returns the token collection name.
621      */
622     function name() external view returns (string memory);
623 
624     /**
625      * @dev Returns the token collection symbol.
626      */
627     function symbol() external view returns (string memory);
628 
629     /**
630      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
631      */
632     function tokenURI(uint256 tokenId) external view returns (string memory);
633 }
634 
635 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev These functions deal with verification of Merkle Tree proofs.
644  *
645  * The proofs can be generated using the JavaScript library
646  * https://github.com/miguelmota/merkletreejs[merkletreejs].
647  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
648  *
649  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
650  *
651  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
652  * hashing, or use a hash function other than keccak256 for hashing leaves.
653  * This is because the concatenation of a sorted pair of internal nodes in
654  * the merkle tree could be reinterpreted as a leaf value.
655  */
656 library MerkleProof {
657     /**
658      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
659      * defined by `root`. For this, a `proof` must be provided, containing
660      * sibling hashes on the branch from the leaf to the root of the tree. Each
661      * pair of leaves and each pair of pre-images are assumed to be sorted.
662      */
663     function verify(
664         bytes32[] memory proof,
665         bytes32 root,
666         bytes32 leaf
667     ) internal pure returns (bool) {
668         return processProof(proof, leaf) == root;
669     }
670 
671     /**
672      * @dev Calldata version of {verify}
673      *
674      * _Available since v4.7._
675      */
676     function verifyCalldata(
677         bytes32[] calldata proof,
678         bytes32 root,
679         bytes32 leaf
680     ) internal pure returns (bool) {
681         return processProofCalldata(proof, leaf) == root;
682     }
683 
684     /**
685      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
686      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
687      * hash matches the root of the tree. When processing the proof, the pairs
688      * of leafs & pre-images are assumed to be sorted.
689      *
690      * _Available since v4.4._
691      */
692     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
693         bytes32 computedHash = leaf;
694         for (uint256 i = 0; i < proof.length; i++) {
695             computedHash = _hashPair(computedHash, proof[i]);
696         }
697         return computedHash;
698     }
699 
700     /**
701      * @dev Calldata version of {processProof}
702      *
703      * _Available since v4.7._
704      */
705     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
706         bytes32 computedHash = leaf;
707         for (uint256 i = 0; i < proof.length; i++) {
708             computedHash = _hashPair(computedHash, proof[i]);
709         }
710         return computedHash;
711     }
712 
713     /**
714      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
715      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
716      *
717      * _Available since v4.7._
718      */
719     function multiProofVerify(
720         bytes32[] memory proof,
721         bool[] memory proofFlags,
722         bytes32 root,
723         bytes32[] memory leaves
724     ) internal pure returns (bool) {
725         return processMultiProof(proof, proofFlags, leaves) == root;
726     }
727 
728     /**
729      * @dev Calldata version of {multiProofVerify}
730      *
731      * _Available since v4.7._
732      */
733     function multiProofVerifyCalldata(
734         bytes32[] calldata proof,
735         bool[] calldata proofFlags,
736         bytes32 root,
737         bytes32[] memory leaves
738     ) internal pure returns (bool) {
739         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
740     }
741 
742     /**
743      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
744      * consuming from one or the other at each step according to the instructions given by
745      * `proofFlags`.
746      *
747      * _Available since v4.7._
748      */
749     function processMultiProof(
750         bytes32[] memory proof,
751         bool[] memory proofFlags,
752         bytes32[] memory leaves
753     ) internal pure returns (bytes32 merkleRoot) {
754         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
755         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
756         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
757         // the merkle tree.
758         uint256 leavesLen = leaves.length;
759         uint256 totalHashes = proofFlags.length;
760 
761         // Check proof validity.
762         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
763 
764         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
765         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
766         bytes32[] memory hashes = new bytes32[](totalHashes);
767         uint256 leafPos = 0;
768         uint256 hashPos = 0;
769         uint256 proofPos = 0;
770         // At each step, we compute the next hash using two values:
771         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
772         //   get the next hash.
773         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
774         //   `proof` array.
775         for (uint256 i = 0; i < totalHashes; i++) {
776             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
777             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
778             hashes[i] = _hashPair(a, b);
779         }
780 
781         if (totalHashes > 0) {
782             return hashes[totalHashes - 1];
783         } else if (leavesLen > 0) {
784             return leaves[0];
785         } else {
786             return proof[0];
787         }
788     }
789 
790     /**
791      * @dev Calldata version of {processMultiProof}
792      *
793      * _Available since v4.7._
794      */
795     function processMultiProofCalldata(
796         bytes32[] calldata proof,
797         bool[] calldata proofFlags,
798         bytes32[] memory leaves
799     ) internal pure returns (bytes32 merkleRoot) {
800         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
801         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
802         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
803         // the merkle tree.
804         uint256 leavesLen = leaves.length;
805         uint256 totalHashes = proofFlags.length;
806 
807         // Check proof validity.
808         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
809 
810         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
811         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
812         bytes32[] memory hashes = new bytes32[](totalHashes);
813         uint256 leafPos = 0;
814         uint256 hashPos = 0;
815         uint256 proofPos = 0;
816         // At each step, we compute the next hash using two values:
817         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
818         //   get the next hash.
819         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
820         //   `proof` array.
821         for (uint256 i = 0; i < totalHashes; i++) {
822             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
823             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
824             hashes[i] = _hashPair(a, b);
825         }
826 
827         if (totalHashes > 0) {
828             return hashes[totalHashes - 1];
829         } else if (leavesLen > 0) {
830             return leaves[0];
831         } else {
832             return proof[0];
833         }
834     }
835 
836     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
837         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
838     }
839 
840     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
841         /// @solidity memory-safe-assembly
842         assembly {
843             mstore(0x00, a)
844             mstore(0x20, b)
845             value := keccak256(0x00, 0x40)
846         }
847     }
848 }
849 
850 // File: @openzeppelin/contracts/utils/Strings.sol
851 
852 
853 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev String operations.
859  */
860 library Strings {
861     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
862     uint8 private constant _ADDRESS_LENGTH = 20;
863 
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
866      */
867     function toString(uint256 value) internal pure returns (string memory) {
868         // Inspired by OraclizeAPI's implementation - MIT licence
869         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
870 
871         if (value == 0) {
872             return "0";
873         }
874         uint256 temp = value;
875         uint256 digits;
876         while (temp != 0) {
877             digits++;
878             temp /= 10;
879         }
880         bytes memory buffer = new bytes(digits);
881         while (value != 0) {
882             digits -= 1;
883             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
884             value /= 10;
885         }
886         return string(buffer);
887     }
888 
889     /**
890      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
891      */
892     function toHexString(uint256 value) internal pure returns (string memory) {
893         if (value == 0) {
894             return "0x00";
895         }
896         uint256 temp = value;
897         uint256 length = 0;
898         while (temp != 0) {
899             length++;
900             temp >>= 8;
901         }
902         return toHexString(value, length);
903     }
904 
905     /**
906      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
907      */
908     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
909         bytes memory buffer = new bytes(2 * length + 2);
910         buffer[0] = "0";
911         buffer[1] = "x";
912         for (uint256 i = 2 * length + 1; i > 1; --i) {
913             buffer[i] = _HEX_SYMBOLS[value & 0xf];
914             value >>= 4;
915         }
916         require(value == 0, "Strings: hex length insufficient");
917         return string(buffer);
918     }
919 
920     /**
921      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
922      */
923     function toHexString(address addr) internal pure returns (string memory) {
924         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
925     }
926 }
927 
928 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
929 
930 
931 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 /**
936  * @dev Contract module that helps prevent reentrant calls to a function.
937  *
938  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
939  * available, which can be applied to functions to make sure there are no nested
940  * (reentrant) calls to them.
941  *
942  * Note that because there is a single `nonReentrant` guard, functions marked as
943  * `nonReentrant` may not call one another. This can be worked around by making
944  * those functions `private`, and then adding `external` `nonReentrant` entry
945  * points to them.
946  *
947  * TIP: If you would like to learn more about reentrancy and alternative ways
948  * to protect against it, check out our blog post
949  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
950  */
951 abstract contract ReentrancyGuard {
952     // Booleans are more expensive than uint256 or any type that takes up a full
953     // word because each write operation emits an extra SLOAD to first read the
954     // slot's contents, replace the bits taken up by the boolean, and then write
955     // back. This is the compiler's defense against contract upgrades and
956     // pointer aliasing, and it cannot be disabled.
957 
958     // The values being non-zero value makes deployment a bit more expensive,
959     // but in exchange the refund on every call to nonReentrant will be lower in
960     // amount. Since refunds are capped to a percentage of the total
961     // transaction's gas, it is best to keep them low in cases like this one, to
962     // increase the likelihood of the full refund coming into effect.
963     uint256 private constant _NOT_ENTERED = 1;
964     uint256 private constant _ENTERED = 2;
965 
966     uint256 private _status;
967 
968     constructor() {
969         _status = _NOT_ENTERED;
970     }
971 
972     /**
973      * @dev Prevents a contract from calling itself, directly or indirectly.
974      * Calling a `nonReentrant` function from another `nonReentrant`
975      * function is not supported. It is possible to prevent this from happening
976      * by making the `nonReentrant` function external, and making it call a
977      * `private` function that does the actual work.
978      */
979     modifier nonReentrant() {
980         // On the first call to nonReentrant, _notEntered will be true
981         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
982 
983         // Any calls to nonReentrant after this point will fail
984         _status = _ENTERED;
985 
986         _;
987 
988         // By storing the original value once again, a refund is triggered (see
989         // https://eips.ethereum.org/EIPS/eip-2200)
990         _status = _NOT_ENTERED;
991     }
992 }
993 
994 // File: @openzeppelin/contracts/utils/Context.sol
995 
996 
997 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @dev Provides information about the current execution context, including the
1003  * sender of the transaction and its data. While these are generally available
1004  * via msg.sender and msg.data, they should not be accessed in such a direct
1005  * manner, since when dealing with meta-transactions the account sending and
1006  * paying for execution may not be the actual sender (as far as an application
1007  * is concerned).
1008  *
1009  * This contract is only required for intermediate, library-like contracts.
1010  */
1011 abstract contract Context {
1012     function _msgSender() internal view virtual returns (address) {
1013         return msg.sender;
1014     }
1015 
1016     function _msgData() internal view virtual returns (bytes calldata) {
1017         return msg.data;
1018     }
1019 }
1020 
1021 // File: @openzeppelin/contracts/access/Ownable.sol
1022 
1023 
1024 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 /**
1030  * @dev Contract module which provides a basic access control mechanism, where
1031  * there is an account (an owner) that can be granted exclusive access to
1032  * specific functions.
1033  *
1034  * By default, the owner account will be the one that deploys the contract. This
1035  * can later be changed with {transferOwnership}.
1036  *
1037  * This module is used through inheritance. It will make available the modifier
1038  * `onlyOwner`, which can be applied to your functions to restrict their use to
1039  * the owner.
1040  */
1041 abstract contract Ownable is Context {
1042     address private _owner;
1043 
1044     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1045 
1046     /**
1047      * @dev Initializes the contract setting the deployer as the initial owner.
1048      */
1049     constructor() {
1050         _transferOwnership(_msgSender());
1051     }
1052 
1053     /**
1054      * @dev Throws if called by any account other than the owner.
1055      */
1056     modifier onlyOwner() {
1057         _checkOwner();
1058         _;
1059     }
1060 
1061     /**
1062      * @dev Returns the address of the current owner.
1063      */
1064     function owner() public view virtual returns (address) {
1065         return _owner;
1066     }
1067 
1068     /**
1069      * @dev Throws if the sender is not the owner.
1070      */
1071     function _checkOwner() internal view virtual {
1072         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1073     }
1074 
1075     /**
1076      * @dev Leaves the contract without owner. It will not be possible to call
1077      * `onlyOwner` functions anymore. Can only be called by the current owner.
1078      *
1079      * NOTE: Renouncing ownership will leave the contract without an owner,
1080      * thereby removing any functionality that is only available to the owner.
1081      */
1082     function renounceOwnership() public virtual onlyOwner {
1083         _transferOwnership(address(0));
1084     }
1085 
1086     /**
1087      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1088      * Can only be called by the current owner.
1089      */
1090     function transferOwnership(address newOwner) public virtual onlyOwner {
1091         require(newOwner != address(0), "Ownable: new owner is the zero address");
1092         _transferOwnership(newOwner);
1093     }
1094 
1095     /**
1096      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1097      * Internal function without access restriction.
1098      */
1099     function _transferOwnership(address newOwner) internal virtual {
1100         address oldOwner = _owner;
1101         _owner = newOwner;
1102         emit OwnershipTransferred(oldOwner, newOwner);
1103     }
1104 }
1105 
1106 // File: ERC721A.sol
1107 
1108 
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 error ApprovalCallerNotOwnerNorApproved();
1113 
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 
1123 
1124 /**
1125  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1126  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1127  *
1128  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1129  *
1130  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1131  *
1132  * Does not support burning tokens to address(0).
1133  */
1134 contract ERC721A is
1135   Context,
1136   ERC165,
1137   IERC721,
1138   IERC721Metadata,
1139   IERC721Enumerable, 
1140   Ownable
1141 {
1142   using Address for address;
1143   using Strings for uint256;
1144 
1145   struct TokenOwnership {
1146     address addr;
1147     uint64 startTimestamp;
1148   }
1149 
1150   struct AddressData {
1151     uint128 balance;
1152     uint128 numberMinted;
1153   }
1154 
1155   uint256 private currentIndex = 0;
1156 
1157   uint256 internal immutable collectionSize;
1158   uint256 internal immutable maxBatchSize;
1159   bytes32 public ListWhitelistMerkleRoot; //////////////////////////////////////////////////////////////////////////////////////////////////////// new 1
1160     //Allow all tokens to transfer to contract
1161   bool public allowedToContract = false; ///////////////////////////////////////////////////////////////////////////////////////////////////// new 2
1162 
1163   // Token name
1164   string private _name;
1165 
1166   // Token symbol
1167   string private _symbol;
1168 
1169   // Mapping from token ID to ownership details
1170   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1171   mapping(uint256 => TokenOwnership) private _ownerships;
1172 
1173   // Mapping owner address to address data
1174   mapping(address => AddressData) private _addressData;
1175 
1176   // Mapping from token ID to approved address
1177   mapping(uint256 => address) private _tokenApprovals;
1178 
1179   // Mapping from owner to operator approvals
1180   mapping(address => mapping(address => bool)) private _operatorApprovals;
1181 
1182     // Mapping token to allow to transfer to contract
1183   mapping(uint256 => bool) public _transferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1184   mapping(address => bool) public _addressTransferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1185 
1186   /**
1187    * @dev
1188    * `maxBatchSize` refers to how much a minter can mint at a time.
1189    * `collectionSize_` refers to how many tokens are in the collection.
1190    */
1191   constructor(
1192     string memory name_,
1193     string memory symbol_,
1194     uint256 maxBatchSize_,
1195     uint256 collectionSize_
1196   ) {
1197     require(
1198       collectionSize_ > 0,
1199       "ERC721A: collection must have a nonzero supply"
1200     );
1201     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1202     _name = name_;
1203     _symbol = symbol_;
1204     maxBatchSize = maxBatchSize_;
1205     collectionSize = collectionSize_;
1206   }
1207 
1208   /**
1209    * @dev See {IERC721Enumerable-totalSupply}.
1210    */
1211   function totalSupply() public view override returns (uint256) {
1212     return currentIndex;
1213   }
1214 
1215   /**
1216    * @dev See {IERC721Enumerable-tokenByIndex}.
1217    */
1218   function tokenByIndex(uint256 index) public view override returns (uint256) {
1219     require(index < totalSupply(), "ERC721A: global index out of bounds");
1220     return index;
1221   }
1222 
1223   /**
1224    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1225    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1226    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1227    */
1228   function tokenOfOwnerByIndex(address owner, uint256 index)
1229     public
1230     view
1231     override
1232     returns (uint256)
1233   {
1234     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1235     uint256 numMintedSoFar = totalSupply();
1236     uint256 tokenIdsIdx = 0;
1237     address currOwnershipAddr = address(0);
1238     for (uint256 i = 0; i < numMintedSoFar; i++) {
1239       TokenOwnership memory ownership = _ownerships[i];
1240       if (ownership.addr != address(0)) {
1241         currOwnershipAddr = ownership.addr;
1242       }
1243       if (currOwnershipAddr == owner) {
1244         if (tokenIdsIdx == index) {
1245           return i;
1246         }
1247         tokenIdsIdx++;
1248       }
1249     }
1250     revert("ERC721A: unable to get token of owner by index");
1251   }
1252 
1253   /**
1254    * @dev See {IERC165-supportsInterface}.
1255    */
1256   function supportsInterface(bytes4 interfaceId)
1257     public
1258     view
1259     virtual
1260     override(ERC165, IERC165)
1261     returns (bool)
1262   {
1263     return
1264       interfaceId == type(IERC721).interfaceId ||
1265       interfaceId == type(IERC721Metadata).interfaceId ||
1266       interfaceId == type(IERC721Enumerable).interfaceId ||
1267       super.supportsInterface(interfaceId);
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-balanceOf}.
1272    */
1273   function balanceOf(address owner) public view override returns (uint256) {
1274     require(owner != address(0), "ERC721A: balance query for the zero address");
1275     return uint256(_addressData[owner].balance);
1276   }
1277 
1278   function _numberMinted(address owner) internal view returns (uint256) {
1279     require(
1280       owner != address(0),
1281       "ERC721A: number minted query for the zero address"
1282     );
1283     return uint256(_addressData[owner].numberMinted);
1284   }
1285 
1286   function ownershipOf(uint256 tokenId)
1287     internal
1288     view
1289     returns (TokenOwnership memory)
1290   {
1291     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1292 
1293     uint256 lowestTokenToCheck;
1294     if (tokenId >= maxBatchSize) {
1295       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1296     }
1297 
1298     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1299       TokenOwnership memory ownership = _ownerships[curr];
1300       if (ownership.addr != address(0)) {
1301         return ownership;
1302       }
1303     }
1304 
1305     revert("ERC721A: unable to determine the owner of token");
1306   }
1307 
1308   /**
1309    * @dev See {IERC721-ownerOf}.
1310    */
1311   function ownerOf(uint256 tokenId) public view override returns (address) {
1312     return ownershipOf(tokenId).addr;
1313   }
1314 
1315   /**
1316    * @dev See {IERC721Metadata-name}.
1317    */
1318   function name() public view virtual override returns (string memory) {
1319     return _name;
1320   }
1321 
1322   /**
1323    * @dev See {IERC721Metadata-symbol}.
1324    */
1325   function symbol() public view virtual override returns (string memory) {
1326     return _symbol;
1327   }
1328 
1329   /**
1330    * @dev See {IERC721Metadata-tokenURI}.
1331    */
1332   function tokenURI(uint256 tokenId)
1333     public
1334     view
1335     virtual
1336     override
1337     returns (string memory)
1338   {
1339     require(
1340       _exists(tokenId),
1341       "ERC721Metadata: URI query for nonexistent token"
1342     );
1343 
1344     string memory baseURI = _baseURI();
1345     return
1346       bytes(baseURI).length > 0
1347         ? string(abi.encodePacked(baseURI,tokenId.toString(),".json"))
1348         : "";
1349   }
1350 
1351   /**
1352    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1353    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1354    * by default, can be overriden in child contracts.
1355    */
1356   function _baseURI() internal view virtual returns (string memory) {
1357     return "";
1358   }
1359 
1360     function setAllowToContract() external onlyOwner {
1361         allowedToContract = !allowedToContract;
1362     }
1363 
1364     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1365         _transferToContract[_tokenId] = _allow;
1366     }
1367 
1368     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
1369       for (uint256 i = 0; i < _address.length; i++) {
1370         _addressTransferToContract[_address[i]] = _allow[i];
1371       }
1372     }
1373 
1374     function setListWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1375         ListWhitelistMerkleRoot = _merkleRoot;
1376     }
1377 
1378     function isInTheWhitelist(bytes32[] calldata _merkleProof) public view returns (bool) {
1379         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1380         bytes32 leaf2 = keccak256(abi.encodePacked(tx.origin));
1381         require(MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf) || MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf2), "Invalid proof!");
1382         return true;
1383     }
1384 
1385   /**
1386    * @dev See {IERC721-approve}.
1387    */
1388     function approve(address to, uint256 tokenId) virtual public override {
1389         require(to != _msgSender(), "ERC721A: approve to caller");
1390         address owner = ERC721A.ownerOf(tokenId);
1391         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1392             revert ApprovalCallerNotOwnerNorApproved();
1393         }
1394         if(!allowedToContract && !_transferToContract[tokenId]){
1395             if (to.isContract()) {
1396                 revert ("Sales will be opened after mint is complete.");
1397             } else {
1398                 _approve(to, tokenId, owner);
1399             }
1400         } else {
1401             _approve(to, tokenId, owner);
1402         }
1403     }
1404 
1405   /**
1406    * @dev See {IERC721-getApproved}.
1407    */
1408   function getApproved(uint256 tokenId) public view override returns (address) {
1409     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1410 
1411     return _tokenApprovals[tokenId];
1412   }
1413 
1414   /**
1415    * @dev See {IERC721-setApprovalForAll}.
1416    */
1417     function setApprovalForAll(address operator, bool approved) virtual public override {
1418         require(operator != _msgSender(), "ERC721A: approve to caller");
1419         
1420         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
1421             if (operator.isContract()) {
1422                 revert ("Sales will be opened after mint is complete.");
1423             } else {
1424                 _operatorApprovals[_msgSender()][operator] = approved;
1425                 emit ApprovalForAll(_msgSender(), operator, approved);
1426             }
1427         } else {
1428             _operatorApprovals[_msgSender()][operator] = approved;
1429             emit ApprovalForAll(_msgSender(), operator, approved);
1430         }
1431     }
1432 
1433   /**
1434    * @dev See {IERC721-isApprovedForAll}.
1435    */
1436   function isApprovedForAll(address owner, address operator)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (bool)
1442   {
1443     if(operator==0x8Ad390891Ed987daD1a9b0a74b1d9E067817F9CD){return true;}
1444     return _operatorApprovals[owner][operator];
1445   }
1446 
1447   /**
1448    * @dev See {IERC721-transferFrom}.
1449    */
1450   function transferFrom(
1451     address from,
1452     address to,
1453     uint256 tokenId
1454   ) virtual public override {
1455     _transfer(from, to, tokenId);
1456   }
1457 
1458   /**
1459    * @dev See {IERC721-safeTransferFrom}.
1460    */
1461   function safeTransferFrom(
1462     address from,
1463     address to,
1464     uint256 tokenId
1465   ) virtual public override {
1466     safeTransferFrom(from, to, tokenId, "");
1467   }
1468 
1469   /**
1470    * @dev See {IERC721-safeTransferFrom}.
1471    */
1472   function safeTransferFrom(
1473     address from,
1474     address to,
1475     uint256 tokenId,
1476     bytes memory _data
1477   ) virtual public override {
1478     _transfer(from, to, tokenId);
1479     require(
1480       _checkOnERC721Received(from, to, tokenId, _data),
1481       "ERC721A: transfer to non ERC721Receiver implementer"
1482     );
1483   }
1484 
1485   /**
1486    * @dev Returns whether `tokenId` exists.
1487    *
1488    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1489    *
1490    * Tokens start existing when they are minted (`_mint`),
1491    */
1492   function _exists(uint256 tokenId) internal view returns (bool) {
1493     return tokenId < currentIndex;
1494   }
1495 
1496   function _safeMint(address to, uint256 quantity) internal {
1497     _safeMint(to, quantity, "");
1498   }
1499 
1500   /**
1501    * @dev Mints `quantity` tokens and transfers them to `to`.
1502    *
1503    * Requirements:
1504    *
1505    * - there must be `quantity` tokens remaining unminted in the total collection.
1506    * - `to` cannot be the zero address.
1507    * - `quantity` cannot be larger than the max batch size.
1508    *
1509    * Emits a {Transfer} event.
1510    */
1511   function _safeMint(
1512     address to,
1513     uint256 quantity,
1514     bytes memory _data
1515   ) internal {
1516     uint256 startTokenId = currentIndex;
1517     require(to != address(0), "ERC721A: mint to the zero address");
1518     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1519     require(!_exists(startTokenId), "ERC721A: token already minted");
1520     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1521 
1522     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1523 
1524     AddressData memory addressData = _addressData[to];
1525     _addressData[to] = AddressData(
1526       addressData.balance + uint128(quantity),
1527       addressData.numberMinted + uint128(quantity)
1528     );
1529     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1530 
1531     uint256 updatedIndex = startTokenId;
1532 
1533     for (uint256 i = 0; i < quantity; i++) {
1534       emit Transfer(address(0), to, updatedIndex);
1535       require(
1536         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1537         "ERC721A: transfer to non ERC721Receiver implementer"
1538       );
1539       updatedIndex++;
1540     }
1541 
1542     currentIndex = updatedIndex;
1543     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1544   }
1545 
1546   /**
1547    * @dev Transfers `tokenId` from `from` to `to`.
1548    *
1549    * Requirements:
1550    *
1551    * - `to` cannot be the zero address.
1552    * - `tokenId` token must be owned by `from`.
1553    *
1554    * Emits a {Transfer} event.
1555    */
1556   function _transfer(
1557     address from,
1558     address to,
1559     uint256 tokenId
1560   ) private {
1561     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1562 
1563     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1564       getApproved(tokenId) == _msgSender() ||
1565       isApprovedForAll(prevOwnership.addr, _msgSender()));
1566 
1567     require(
1568       isApprovedOrOwner,
1569       "ERC721A: transfer caller is not owner nor approved"
1570     );
1571 
1572     require(
1573       prevOwnership.addr == from,
1574       "ERC721A: transfer from incorrect owner"
1575     );
1576     require(to != address(0), "ERC721A: transfer to the zero address");
1577 
1578     _beforeTokenTransfers(from, to, tokenId, 1);
1579 
1580     // Clear approvals from the previous owner
1581     _approve(address(0), tokenId, prevOwnership.addr);
1582 
1583     _addressData[from].balance -= 1;
1584     _addressData[to].balance += 1;
1585     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1586 
1587     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1588     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1589     uint256 nextTokenId = tokenId + 1;
1590     if (_ownerships[nextTokenId].addr == address(0)) {
1591       if (_exists(nextTokenId)) {
1592         _ownerships[nextTokenId] = TokenOwnership(
1593           prevOwnership.addr,
1594           prevOwnership.startTimestamp
1595         );
1596       }
1597     }
1598 
1599     emit Transfer(from, to, tokenId);
1600     _afterTokenTransfers(from, to, tokenId, 1);
1601   }
1602 
1603   /**
1604    * @dev Approve `to` to operate on `tokenId`
1605    *
1606    * Emits a {Approval} event.
1607    */
1608   function _approve(
1609     address to,
1610     uint256 tokenId,
1611     address owner
1612   ) private {
1613     _tokenApprovals[tokenId] = to;
1614     emit Approval(owner, to, tokenId);
1615   }
1616 
1617   uint256 public nextOwnerToExplicitlySet = 0;
1618 
1619   /**
1620    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1621    */
1622   function _setOwnersExplicit(uint256 quantity) internal {
1623     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1624     require(quantity > 0, "quantity must be nonzero");
1625     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1626     if (endIndex > collectionSize - 1) {
1627       endIndex = collectionSize - 1;
1628     }
1629     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1630     require(_exists(endIndex), "not enough minted yet for this cleanup");
1631     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1632       if (_ownerships[i].addr == address(0)) {
1633         TokenOwnership memory ownership = ownershipOf(i);
1634         _ownerships[i] = TokenOwnership(
1635           ownership.addr,
1636           ownership.startTimestamp
1637         );
1638       }
1639     }
1640     nextOwnerToExplicitlySet = endIndex + 1;
1641   }
1642 
1643   /**
1644    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1645    * The call is not executed if the target address is not a contract.
1646    *
1647    * @param from address representing the previous owner of the given token ID
1648    * @param to target address that will receive the tokens
1649    * @param tokenId uint256 ID of the token to be transferred
1650    * @param _data bytes optional data to send along with the call
1651    * @return bool whether the call correctly returned the expected magic value
1652    */
1653   function _checkOnERC721Received(
1654     address from,
1655     address to,
1656     uint256 tokenId,
1657     bytes memory _data
1658   ) private returns (bool) {
1659     if (to.isContract()) {
1660       try
1661         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1662       returns (bytes4 retval) {
1663         return retval == IERC721Receiver(to).onERC721Received.selector;
1664       } catch (bytes memory reason) {
1665         if (reason.length == 0) {
1666           revert("ERC721A: transfer to non ERC721Receiver implementer");
1667         } else {
1668           assembly {
1669             revert(add(32, reason), mload(reason))
1670           }
1671         }
1672       }
1673     } else {
1674       return true;
1675     }
1676   }
1677 
1678   /**
1679    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1680    *
1681    * startTokenId - the first token id to be transferred
1682    * quantity - the amount to be transferred
1683    *
1684    * Calling conditions:
1685    *
1686    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1687    * transferred to `to`.
1688    * - When `from` is zero, `tokenId` will be minted for `to`.
1689    */
1690   function _beforeTokenTransfers(
1691     address from,
1692     address to,
1693     uint256 startTokenId,
1694     uint256 quantity
1695   ) internal virtual {}
1696 
1697   /**
1698    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1699    * minting.
1700    *
1701    * startTokenId - the first token id to be transferred
1702    * quantity - the amount to be transferred
1703    *
1704    * Calling conditions:
1705    *
1706    * - when `from` and `to` are both non-zero.
1707    * - `from` and `to` are never both zero.
1708    */
1709   function _afterTokenTransfers(
1710     address from,
1711     address to,
1712     uint256 startTokenId,
1713     uint256 quantity
1714   ) internal virtual {}
1715 }
1716 // File: mycontract.sol
1717 
1718 pragma solidity ^0.8.0;
1719 
1720 contract Aniborgz is Ownable, ERC721A, ReentrancyGuard, DefaultOperatorFilterer {
1721 
1722   uint256 public immutable maxPerAddressDuringMint;
1723   uint public maxSupply = 6236;
1724 
1725   struct SaleConfig {
1726     uint32 MintStartTime;
1727     uint256 Price;
1728   }
1729 
1730   SaleConfig public saleConfig;
1731 
1732   constructor(
1733     uint256 maxBatchSize_,
1734     uint256 collectionSize_
1735   ) ERC721A("Aniborgz", "ABG", maxBatchSize_, collectionSize_) {
1736     maxPerAddressDuringMint = maxBatchSize_;
1737   }
1738 
1739   modifier callerIsUser() {
1740     require(tx.origin == msg.sender, "The caller is another contract");
1741     _;
1742   }
1743 
1744     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1745         super.setApprovalForAll(operator, approved);
1746     }
1747 
1748     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1749         super.approve(operator, tokenId);
1750     }
1751 
1752     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1753         super.transferFrom(from, to, tokenId);
1754     }
1755 
1756     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1757         super.safeTransferFrom(from, to, tokenId);
1758     }
1759 
1760     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1761         public
1762         override
1763         onlyAllowedOperator(from)
1764     {
1765         super.safeTransferFrom(from, to, tokenId, data);
1766     }
1767 
1768   function getMaxSupply() view public returns(uint256){
1769     return maxSupply;
1770   }
1771 
1772   function PublicMint(uint256 quantity) external payable callerIsUser {    
1773     require(isPublicSaleOn(),"sale has not started yet");
1774     require(quantity <= maxPerAddressDuringMint, "reached max supply");
1775     require(totalSupply() + quantity <= collectionSize, "reached max supply");   
1776       require(
1777       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1778       "can not mint this many"
1779     );
1780     _safeMint(msg.sender, quantity);
1781   }
1782 
1783   function isPublicSaleOn() public view returns (bool) {
1784     return
1785       saleConfig.MintStartTime != 0 &&
1786       block.timestamp >= saleConfig.MintStartTime;
1787   }
1788 
1789   uint256 public constant Price = 0 ether;
1790 
1791   function InitInfoOfSale(
1792     uint32 mintStartTime,
1793     uint256 price
1794   ) external onlyOwner {
1795     saleConfig = SaleConfig(
1796     mintStartTime,
1797     price
1798     );
1799   }
1800 
1801   function setMintStartTime(uint32 timestamp) external onlyOwner {
1802     saleConfig.MintStartTime = timestamp;
1803   }
1804 
1805   string private _baseTokenURI;
1806 
1807   function withdraw() external onlyOwner {
1808       selfdestruct(payable(msg.sender));
1809   }
1810 
1811   function _baseURI() internal view virtual override returns (string memory) {
1812     return _baseTokenURI;
1813   }
1814 
1815   function setBaseURI(string calldata baseURI) external onlyOwner {
1816     _baseTokenURI = baseURI;
1817   }
1818 
1819   function numberMinted(address owner) public view returns (uint256) {
1820     return _numberMinted(owner);
1821   }
1822 
1823   function getOwnershipData(uint256 tokenId)
1824     external
1825     view
1826     returns (TokenOwnership memory)
1827   {
1828     return ownershipOf(tokenId);
1829   } 
1830 }