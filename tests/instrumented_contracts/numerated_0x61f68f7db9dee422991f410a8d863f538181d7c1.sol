1 /*
2   _ _  __       __                          
3  | (_)/ _| ___ / _| ___  _ __ _ __ ___  ___ 
4  | | | |_ / _ \ |_ / _ \| '__| '_ ` _ \/ __|
5  | | |  _|  __/  _| (_) | |  | | | | | \__ \
6  |_|_|_|  \___|_|  \___/|_|  |_| |_| |_|___/
7                                             
8 Contract by @beeble_xyz
9 0.01 Public mint.
10 Max 5 per wallet.
11 1000 Supply.
12 */
13 
14 pragma solidity ^0.8.13;
15 
16 interface IOperatorFilterRegistry {
17     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
18     function register(address registrant) external;
19     function registerAndSubscribe(address registrant, address subscription) external;
20     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
21     function updateOperator(address registrant, address operator, bool filtered) external;
22     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
23     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
24     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
25     function subscribe(address registrant, address registrantToSubscribe) external;
26     function unsubscribe(address registrant, bool copyExistingEntries) external;
27     function subscriptionOf(address addr) external returns (address registrant);
28     function subscribers(address registrant) external returns (address[] memory);
29     function subscriberAt(address registrant, uint256 index) external returns (address);
30     function copyEntriesOf(address registrant, address registrantToCopy) external;
31     function isOperatorFiltered(address registrant, address operator) external returns (bool);
32     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
33     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
34     function filteredOperators(address addr) external returns (address[] memory);
35     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
36     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
37     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
38     function isRegistered(address addr) external returns (bool);
39     function codeHashOf(address addr) external returns (bytes32);
40 }
41 
42 // File: OperatorFilterer.sol
43 
44 
45 pragma solidity ^0.8.13;
46 
47 
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry constant operatorFilterRegistry =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(operatorFilterRegistry).code.length > 0) {
59             if (subscribe) {
60                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     operatorFilterRegistry.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Check registry code length to facilitate testing in environments without a deployed registry.
73         if (address(operatorFilterRegistry).code.length > 0) {
74             // Allow spending tokens from addresses with balance
75             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
76             // from an EOA.
77             if (from == msg.sender) {
78                 _;
79                 return;
80             }
81             if (
82                 !(
83                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
84                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
85                 )
86             ) {
87                 revert OperatorNotAllowed(msg.sender);
88             }
89         }
90         _;
91     }
92 }
93 
94 // File: DefaultOperatorFilterer.sol
95 
96 
97 pragma solidity ^0.8.13;
98 
99 
100 abstract contract DefaultOperatorFilterer is OperatorFilterer {
101     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
102 
103     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
104 }
105 
106 // File: Lifeforms.sol
107 
108 
109 
110 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
111 
112 
113 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev These functions deal with verification of Merkle Trees proofs.
119  *
120  * The proofs can be generated using the JavaScript library
121  * https://github.com/miguelmota/merkletreejs[merkletreejs].
122  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
123  *
124  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
125  *
126  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
127  * hashing, or use a hash function other than keccak256 for hashing leaves.
128  * This is because the concatenation of a sorted pair of internal nodes in
129  * the merkle tree could be reinterpreted as a leaf value.
130  */
131 library MerkleProof {
132     /**
133      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
134      * defined by `root`. For this, a `proof` must be provided, containing
135      * sibling hashes on the branch from the leaf to the root of the tree. Each
136      * pair of leaves and each pair of pre-images are assumed to be sorted.
137      */
138     function verify(
139         bytes32[] memory proof,
140         bytes32 root,
141         bytes32 leaf
142     ) internal pure returns (bool) {
143         return processProof(proof, leaf) == root;
144     }
145 
146     /**
147      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
148      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
149      * hash matches the root of the tree. When processing the proof, the pairs
150      * of leafs & pre-images are assumed to be sorted.
151      *
152      * _Available since v4.4._
153      */
154     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
155         bytes32 computedHash = leaf;
156         for (uint256 i = 0; i < proof.length; i++) {
157             bytes32 proofElement = proof[i];
158             if (computedHash <= proofElement) {
159                 // Hash(current computed hash + current element of the proof)
160                 computedHash = _efficientHash(computedHash, proofElement);
161             } else {
162                 // Hash(current element of the proof + current computed hash)
163                 computedHash = _efficientHash(proofElement, computedHash);
164             }
165         }
166         return computedHash;
167     }
168 
169     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
170         assembly {
171             mstore(0x00, a)
172             mstore(0x20, b)
173             value := keccak256(0x00, 0x40)
174         }
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Strings.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = "0";
238         buffer[1] = "x";
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, "Strings: hex length insufficient");
244         return string(buffer);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on `isContract` to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * ```solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * ```
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Required interface of an ERC721 compliant contract.
572  */
573 interface IERC721 is IERC165 {
574     /**
575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
576      */
577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
581      */
582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
586      */
587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
588 
589     /**
590      * @dev Returns the number of tokens in ``owner``'s account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
605      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must exist and be owned by `from`.
612      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Transfers `tokenId` token from `from` to `to`.
625      *
626      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      *
635      * Emits a {Transfer} event.
636      */
637     function transferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
645      * The approval is cleared when the token is transferred.
646      *
647      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
648      *
649      * Requirements:
650      *
651      * - The caller must own the token or be an approved operator.
652      * - `tokenId` must exist.
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address to, uint256 tokenId) external;
657 
658     /**
659      * @dev Returns the account approved for `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function getApproved(uint256 tokenId) external view returns (address operator);
666 
667     /**
668      * @dev Approve or remove `operator` as an operator for the caller.
669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
670      *
671      * Requirements:
672      *
673      * - The `operator` cannot be the caller.
674      *
675      * Emits an {ApprovalForAll} event.
676      */
677     function setApprovalForAll(address operator, bool _approved) external;
678 
679     /**
680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
681      *
682      * See {setApprovalForAll}
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes calldata data
704     ) external;
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Metadata is IERC721 {
720     /**
721      * @dev Returns the token collection name.
722      */
723     function name() external view returns (string memory);
724 
725     /**
726      * @dev Returns the token collection symbol.
727      */
728     function symbol() external view returns (string memory);
729 
730     /**
731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
732      */
733     function tokenURI(uint256 tokenId) external view returns (string memory);
734 }
735 
736 // File: @openzeppelin/contracts/utils/Context.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev Provides information about the current execution context, including the
745  * sender of the transaction and its data. While these are generally available
746  * via msg.sender and msg.data, they should not be accessed in such a direct
747  * manner, since when dealing with meta-transactions the account sending and
748  * paying for execution may not be the actual sender (as far as an application
749  * is concerned).
750  *
751  * This contract is only required for intermediate, library-like contracts.
752  */
753 abstract contract Context {
754     function _msgSender() internal view virtual returns (address) {
755         return msg.sender;
756     }
757 
758     function _msgData() internal view virtual returns (bytes calldata) {
759         return msg.data;
760     }
761 }
762 
763 // File: contracts/erc721a.sol
764 
765 
766 
767 // Creator: Chiru Labs
768 
769 
770 
771 pragma solidity ^0.8.4;
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 
782 error ApprovalCallerNotOwnerNorApproved();
783 
784 error ApprovalQueryForNonexistentToken();
785 
786 error ApproveToCaller();
787 
788 error ApprovalToCurrentOwner();
789 
790 error BalanceQueryForZeroAddress();
791 
792 error MintToZeroAddress();
793 
794 error MintZeroQuantity();
795 
796 error OwnerQueryForNonexistentToken();
797 
798 error TransferCallerNotOwnerNorApproved();
799 
800 error TransferFromIncorrectOwner();
801 
802 error TransferToNonERC721ReceiverImplementer();
803 
804 error TransferToZeroAddress();
805 
806 error URIQueryForNonexistentToken();
807 
808 
809 
810 /**
811 
812  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
813 
814  * the Metadata extension. Built to optimize for lower gas during batch mints.
815 
816  *
817 
818  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
819 
820  *
821 
822  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
823 
824  *
825 
826  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
827 
828  */
829 
830 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
831 
832     using Address for address;
833 
834     using Strings for uint256;
835 
836 
837 
838     // Compiler will pack this into a single 256bit word.
839 
840     struct TokenOwnership {
841 
842         // The address of the owner.
843 
844         address addr;
845 
846         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
847 
848         uint64 startTimestamp;
849 
850         // Whether the token has been burned.
851 
852         bool burned;
853 
854     }
855 
856 
857 
858     // Compiler will pack this into a single 256bit word.
859 
860     struct AddressData {
861 
862         // Realistically, 2**64-1 is more than enough.
863 
864         uint64 balance;
865 
866         // Keeps track of mint count with minimal overhead for tokenomics.
867 
868         uint64 numberMinted;
869 
870         // Keeps track of burn count with minimal overhead for tokenomics.
871 
872         uint64 numberBurned;
873 
874         // For miscellaneous variable(s) pertaining to the address
875 
876         // (e.g. number of whitelist mint slots used).
877 
878         // If there are multiple variables, please pack them into a uint64.
879 
880         uint64 aux;
881 
882     }
883 
884 
885 
886     // The tokenId of the next token to be minted.
887 
888     uint256 internal _currentIndex;
889 
890 
891 
892     // The number of tokens burned.
893 
894     uint256 internal _burnCounter;
895 
896 
897 
898     // Token name
899 
900     string private _name;
901 
902 
903 
904     // Token symbol
905 
906     string private _symbol;
907 
908 
909 
910     // Mapping from token ID to ownership details
911 
912     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
913 
914     mapping(uint256 => TokenOwnership) internal _ownerships;
915 
916 
917 
918     // Mapping owner address to address data
919 
920     mapping(address => AddressData) private _addressData;
921 
922 
923 
924     // Mapping from token ID to approved address
925 
926     mapping(uint256 => address) private _tokenApprovals;
927 
928 
929 
930     // Mapping from owner to operator approvals
931 
932     mapping(address => mapping(address => bool)) private _operatorApprovals;
933 
934 
935 
936     constructor(string memory name_, string memory symbol_) {
937 
938         _name = name_;
939 
940         _symbol = symbol_;
941 
942         _currentIndex = _startTokenId();
943 
944     }
945 
946 
947 
948     /**
949 
950      * To change the starting tokenId, please override this function.
951 
952      */
953 
954     function _startTokenId() internal view virtual returns (uint256) {
955 
956         return 1;
957 
958     }
959 
960 
961 
962     /**
963 
964      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
965 
966      */
967 
968     function totalSupply() public view returns (uint256) {
969 
970         // Counter underflow is impossible as _burnCounter cannot be incremented
971 
972         // more than _currentIndex - _startTokenId() times
973 
974         unchecked {
975 
976             return _currentIndex - _burnCounter - _startTokenId();
977 
978         }
979 
980     }
981 
982 
983 
984     /**
985 
986      * Returns the total amount of tokens minted in the contract.
987 
988      */
989 
990     function _totalMinted() internal view returns (uint256) {
991 
992         // Counter underflow is impossible as _currentIndex does not decrement,
993 
994         // and it is initialized to _startTokenId()
995 
996         unchecked {
997 
998             return _currentIndex - _startTokenId();
999 
1000         }
1001 
1002     }
1003 
1004 
1005 
1006     /**
1007 
1008      * @dev See {IERC165-supportsInterface}.
1009 
1010      */
1011 
1012     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1013 
1014         return
1015 
1016             interfaceId == type(IERC721).interfaceId ||
1017 
1018             interfaceId == type(IERC721Metadata).interfaceId ||
1019 
1020             super.supportsInterface(interfaceId);
1021 
1022     }
1023 
1024 
1025 
1026     /**
1027 
1028      * @dev See {IERC721-balanceOf}.
1029 
1030      */
1031 
1032     function balanceOf(address owner) public view override returns (uint256) {
1033 
1034         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1035 
1036         return uint256(_addressData[owner].balance);
1037 
1038     }
1039 
1040 
1041 
1042     /**
1043 
1044      * Returns the number of tokens minted by `owner`.
1045 
1046      */
1047 
1048     function _numberMinted(address owner) internal view returns (uint256) {
1049 
1050         return uint256(_addressData[owner].numberMinted);
1051 
1052     }
1053 
1054 
1055 
1056     /**
1057 
1058      * Returns the number of tokens burned by or on behalf of `owner`.
1059 
1060      */
1061 
1062     function _numberBurned(address owner) internal view returns (uint256) {
1063 
1064         return uint256(_addressData[owner].numberBurned);
1065 
1066     }
1067 
1068 
1069 
1070     /**
1071 
1072      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1073 
1074      */
1075 
1076     function _getAux(address owner) internal view returns (uint64) {
1077 
1078         return _addressData[owner].aux;
1079 
1080     }
1081 
1082 
1083 
1084     /**
1085 
1086      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1087 
1088      * If there are multiple variables, please pack them into a uint64.
1089 
1090      */
1091 
1092     function _setAux(address owner, uint64 aux) internal {
1093 
1094         _addressData[owner].aux = aux;
1095 
1096     }
1097 
1098 
1099 
1100     /**
1101 
1102      * Gas spent here starts off proportional to the maximum mint batch size.
1103 
1104      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1105 
1106      */
1107 
1108     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1109 
1110         uint256 curr = tokenId;
1111 
1112 
1113 
1114         unchecked {
1115 
1116             if (_startTokenId() <= curr && curr < _currentIndex) {
1117 
1118                 TokenOwnership memory ownership = _ownerships[curr];
1119 
1120                 if (!ownership.burned) {
1121 
1122                     if (ownership.addr != address(0)) {
1123 
1124                         return ownership;
1125 
1126                     }
1127 
1128                     // Invariant:
1129 
1130                     // There will always be an ownership that has an address and is not burned
1131 
1132                     // before an ownership that does not have an address and is not burned.
1133 
1134                     // Hence, curr will not underflow.
1135 
1136                     while (true) {
1137 
1138                         curr--;
1139 
1140                         ownership = _ownerships[curr];
1141 
1142                         if (ownership.addr != address(0)) {
1143 
1144                             return ownership;
1145 
1146                         }
1147 
1148                     }
1149 
1150                 }
1151 
1152             }
1153 
1154         }
1155 
1156         revert OwnerQueryForNonexistentToken();
1157 
1158     }
1159 
1160 
1161 
1162     /**
1163 
1164      * @dev See {IERC721-ownerOf}.
1165 
1166      */
1167 
1168     function ownerOf(uint256 tokenId) public view override returns (address) {
1169 
1170         return _ownershipOf(tokenId).addr;
1171 
1172     }
1173 
1174 
1175 
1176     /**
1177 
1178      * @dev See {IERC721Metadata-name}.
1179 
1180      */
1181 
1182     function name() public view virtual override returns (string memory) {
1183 
1184         return _name;
1185 
1186     }
1187 
1188 
1189 
1190     /**
1191 
1192      * @dev See {IERC721Metadata-symbol}.
1193 
1194      */
1195 
1196     function symbol() public view virtual override returns (string memory) {
1197 
1198         return _symbol;
1199 
1200     }
1201 
1202 
1203 
1204     /**
1205 
1206      * @dev See {IERC721Metadata-tokenURI}.
1207 
1208      */
1209 
1210     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1211 
1212         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1213 
1214 
1215 
1216         string memory baseURI = _baseURI();
1217 
1218         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1219 
1220     }
1221 
1222 
1223 
1224     /**
1225 
1226      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1227 
1228      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1229 
1230      * by default, can be overriden in child contracts.
1231 
1232      */
1233 
1234     function _baseURI() internal view virtual returns (string memory) {
1235 
1236         return '';
1237 
1238     }
1239 
1240 
1241 
1242     /**
1243 
1244      * @dev See {IERC721-approve}.
1245 
1246      */
1247 
1248     function approve(address to, uint256 tokenId) public override {
1249 
1250         address owner = ERC721A.ownerOf(tokenId);
1251 
1252         if (to == owner) revert ApprovalToCurrentOwner();
1253 
1254 
1255 
1256         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1257 
1258             revert ApprovalCallerNotOwnerNorApproved();
1259 
1260         }
1261 
1262 
1263 
1264         _approve(to, tokenId, owner);
1265 
1266     }
1267 
1268 
1269 
1270     /**
1271 
1272      * @dev See {IERC721-getApproved}.
1273 
1274      */
1275 
1276     function getApproved(uint256 tokenId) public view override returns (address) {
1277 
1278         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1279 
1280 
1281 
1282         return _tokenApprovals[tokenId];
1283 
1284     }
1285 
1286 
1287 
1288     /**
1289 
1290      * @dev See {IERC721-setApprovalForAll}.
1291 
1292      */
1293 
1294     function setApprovalForAll(address operator, bool approved) public virtual override {
1295 
1296         if (operator == _msgSender()) revert ApproveToCaller();
1297 
1298 
1299 
1300         _operatorApprovals[_msgSender()][operator] = approved;
1301 
1302         emit ApprovalForAll(_msgSender(), operator, approved);
1303 
1304     }
1305 
1306 
1307 
1308     /**
1309 
1310      * @dev See {IERC721-isApprovedForAll}.
1311 
1312      */
1313 
1314     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1315 
1316         return _operatorApprovals[owner][operator];
1317 
1318     }
1319 
1320 
1321 
1322     /**
1323 
1324      * @dev See {IERC721-transferFrom}.
1325 
1326      */
1327 
1328     function transferFrom(
1329 
1330         address from,
1331 
1332         address to,
1333 
1334         uint256 tokenId
1335 
1336     ) public virtual override {
1337 
1338         _transfer(from, to, tokenId);
1339 
1340     }
1341 
1342 
1343 
1344     /**
1345 
1346      * @dev See {IERC721-safeTransferFrom}.
1347 
1348      */
1349 
1350     function safeTransferFrom(
1351 
1352         address from,
1353 
1354         address to,
1355 
1356         uint256 tokenId
1357 
1358     ) public virtual override {
1359 
1360         safeTransferFrom(from, to, tokenId, '');
1361 
1362     }
1363 
1364 
1365 
1366     /**
1367 
1368      * @dev See {IERC721-safeTransferFrom}.
1369 
1370      */
1371 
1372     function safeTransferFrom(
1373 
1374         address from,
1375 
1376         address to,
1377 
1378         uint256 tokenId,
1379 
1380         bytes memory _data
1381 
1382     ) public virtual override {
1383 
1384         _transfer(from, to, tokenId);
1385 
1386         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1387 
1388             revert TransferToNonERC721ReceiverImplementer();
1389 
1390         }
1391 
1392     }
1393 
1394 
1395 
1396     /**
1397 
1398      * @dev Returns whether `tokenId` exists.
1399 
1400      *
1401 
1402      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1403 
1404      *
1405 
1406      * Tokens start existing when they are minted (`_mint`),
1407 
1408      */
1409 
1410     function _exists(uint256 tokenId) internal view returns (bool) {
1411 
1412         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1413 
1414             !_ownerships[tokenId].burned;
1415 
1416     }
1417 
1418 
1419 
1420     function _safeMint(address to, uint256 quantity) internal {
1421 
1422         _safeMint(to, quantity, '');
1423 
1424     }
1425 
1426 
1427 
1428     /**
1429 
1430      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1431 
1432      *
1433 
1434      * Requirements:
1435 
1436      *
1437 
1438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1439 
1440      * - `quantity` must be greater than 0.
1441 
1442      *
1443 
1444      * Emits a {Transfer} event.
1445 
1446      */
1447 
1448     function _safeMint(
1449 
1450         address to,
1451 
1452         uint256 quantity,
1453 
1454         bytes memory _data
1455 
1456     ) internal {
1457 
1458         _mint(to, quantity, _data, true);
1459 
1460     }
1461 
1462 
1463 
1464     /**
1465 
1466      * @dev Mints `quantity` tokens and transfers them to `to`.
1467 
1468      *
1469 
1470      * Requirements:
1471 
1472      *
1473 
1474      * - `to` cannot be the zero address.
1475 
1476      * - `quantity` must be greater than 0.
1477 
1478      *
1479 
1480      * Emits a {Transfer} event.
1481 
1482      */
1483 
1484     function _mint(
1485 
1486         address to,
1487 
1488         uint256 quantity,
1489 
1490         bytes memory _data,
1491 
1492         bool safe
1493 
1494     ) internal {
1495 
1496         uint256 startTokenId = _currentIndex;
1497 
1498         if (to == address(0)) revert MintToZeroAddress();
1499 
1500         if (quantity == 0) revert MintZeroQuantity();
1501 
1502 
1503 
1504         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1505 
1506 
1507 
1508         // Overflows are incredibly unrealistic.
1509 
1510         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1511 
1512         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1513 
1514         unchecked {
1515 
1516             _addressData[to].balance += uint64(quantity);
1517 
1518             _addressData[to].numberMinted += uint64(quantity);
1519 
1520 
1521 
1522             _ownerships[startTokenId].addr = to;
1523 
1524             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1525 
1526 
1527 
1528             uint256 updatedIndex = startTokenId;
1529 
1530             uint256 end = updatedIndex + quantity;
1531 
1532 
1533 
1534             if (safe && to.isContract()) {
1535 
1536                 do {
1537 
1538                     emit Transfer(address(0), to, updatedIndex);
1539 
1540                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1541 
1542                         revert TransferToNonERC721ReceiverImplementer();
1543 
1544                     }
1545 
1546                 } while (updatedIndex != end);
1547 
1548                 // Reentrancy protection
1549 
1550                 if (_currentIndex != startTokenId) revert();
1551 
1552             } else {
1553 
1554                 do {
1555 
1556                     emit Transfer(address(0), to, updatedIndex++);
1557 
1558                 } while (updatedIndex != end);
1559 
1560             }
1561 
1562             _currentIndex = updatedIndex;
1563 
1564         }
1565 
1566         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1567 
1568     }
1569 
1570 
1571 
1572     /**
1573 
1574      * @dev Transfers `tokenId` from `from` to `to`.
1575 
1576      *
1577 
1578      * Requirements:
1579 
1580      *
1581 
1582      * - `to` cannot be the zero address.
1583 
1584      * - `tokenId` token must be owned by `from`.
1585 
1586      *
1587 
1588      * Emits a {Transfer} event.
1589 
1590      */
1591 
1592     function _transfer(
1593 
1594         address from,
1595 
1596         address to,
1597 
1598         uint256 tokenId
1599 
1600     ) private {
1601 
1602         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1603 
1604 
1605 
1606         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1607 
1608 
1609 
1610         bool isApprovedOrOwner = (_msgSender() == from ||
1611 
1612             isApprovedForAll(from, _msgSender()) ||
1613 
1614             getApproved(tokenId) == _msgSender());
1615 
1616 
1617 
1618         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1619 
1620         if (to == address(0)) revert TransferToZeroAddress();
1621 
1622 
1623 
1624         _beforeTokenTransfers(from, to, tokenId, 1);
1625 
1626 
1627 
1628         // Clear approvals from the previous owner
1629 
1630         _approve(address(0), tokenId, from);
1631 
1632 
1633 
1634         // Underflow of the sender's balance is impossible because we check for
1635 
1636         // ownership above and the recipient's balance can't realistically overflow.
1637 
1638         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1639 
1640         unchecked {
1641 
1642             _addressData[from].balance -= 1;
1643 
1644             _addressData[to].balance += 1;
1645 
1646 
1647 
1648             TokenOwnership storage currSlot = _ownerships[tokenId];
1649 
1650             currSlot.addr = to;
1651 
1652             currSlot.startTimestamp = uint64(block.timestamp);
1653 
1654 
1655 
1656             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1657 
1658             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1659 
1660             uint256 nextTokenId = tokenId + 1;
1661 
1662             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1663 
1664             if (nextSlot.addr == address(0)) {
1665 
1666                 // This will suffice for checking _exists(nextTokenId),
1667 
1668                 // as a burned slot cannot contain the zero address.
1669 
1670                 if (nextTokenId != _currentIndex) {
1671 
1672                     nextSlot.addr = from;
1673 
1674                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1675 
1676                 }
1677 
1678             }
1679 
1680         }
1681 
1682 
1683 
1684         emit Transfer(from, to, tokenId);
1685 
1686         _afterTokenTransfers(from, to, tokenId, 1);
1687 
1688     }
1689 
1690 
1691 
1692     /**
1693 
1694      * @dev This is equivalent to _burn(tokenId, false)
1695 
1696      */
1697 
1698     function _burn(uint256 tokenId) internal virtual {
1699 
1700         _burn(tokenId, false);
1701 
1702     }
1703 
1704 
1705 
1706     /**
1707 
1708      * @dev Destroys `tokenId`.
1709 
1710      * The approval is cleared when the token is burned.
1711 
1712      *
1713 
1714      * Requirements:
1715 
1716      *
1717 
1718      * - `tokenId` must exist.
1719 
1720      *
1721 
1722      * Emits a {Transfer} event.
1723 
1724      */
1725 
1726     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1727 
1728         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1729 
1730 
1731 
1732         address from = prevOwnership.addr;
1733 
1734 
1735 
1736         if (approvalCheck) {
1737 
1738             bool isApprovedOrOwner = (_msgSender() == from ||
1739 
1740                 isApprovedForAll(from, _msgSender()) ||
1741 
1742                 getApproved(tokenId) == _msgSender());
1743 
1744 
1745 
1746             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1747 
1748         }
1749 
1750 
1751 
1752         _beforeTokenTransfers(from, address(0), tokenId, 1);
1753 
1754 
1755 
1756         // Clear approvals from the previous owner
1757 
1758         _approve(address(0), tokenId, from);
1759 
1760 
1761 
1762         // Underflow of the sender's balance is impossible because we check for
1763 
1764         // ownership above and the recipient's balance can't realistically overflow.
1765 
1766         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1767 
1768         unchecked {
1769 
1770             AddressData storage addressData = _addressData[from];
1771 
1772             addressData.balance -= 1;
1773 
1774             addressData.numberBurned += 1;
1775 
1776 
1777 
1778             // Keep track of who burned the token, and the timestamp of burning.
1779 
1780             TokenOwnership storage currSlot = _ownerships[tokenId];
1781 
1782             currSlot.addr = from;
1783 
1784             currSlot.startTimestamp = uint64(block.timestamp);
1785 
1786             currSlot.burned = true;
1787 
1788 
1789 
1790             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1791 
1792             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1793 
1794             uint256 nextTokenId = tokenId + 1;
1795 
1796             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1797 
1798             if (nextSlot.addr == address(0)) {
1799 
1800                 // This will suffice for checking _exists(nextTokenId),
1801 
1802                 // as a burned slot cannot contain the zero address.
1803 
1804                 if (nextTokenId != _currentIndex) {
1805 
1806                     nextSlot.addr = from;
1807 
1808                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1809 
1810                 }
1811 
1812             }
1813 
1814         }
1815 
1816 
1817 
1818         emit Transfer(from, address(0), tokenId);
1819 
1820         _afterTokenTransfers(from, address(0), tokenId, 1);
1821 
1822 
1823 
1824         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1825 
1826         unchecked {
1827 
1828             _burnCounter++;
1829 
1830         }
1831 
1832     }
1833 
1834 
1835 
1836     /**
1837 
1838      * @dev Approve `to` to operate on `tokenId`
1839 
1840      *
1841 
1842      * Emits a {Approval} event.
1843 
1844      */
1845 
1846     function _approve(
1847 
1848         address to,
1849 
1850         uint256 tokenId,
1851 
1852         address owner
1853 
1854     ) private {
1855 
1856         _tokenApprovals[tokenId] = to;
1857 
1858         emit Approval(owner, to, tokenId);
1859 
1860     }
1861 
1862 
1863 
1864     /**
1865 
1866      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1867 
1868      *
1869 
1870      * @param from address representing the previous owner of the given token ID
1871 
1872      * @param to target address that will receive the tokens
1873 
1874      * @param tokenId uint256 ID of the token to be transferred
1875 
1876      * @param _data bytes optional data to send along with the call
1877 
1878      * @return bool whether the call correctly returned the expected magic value
1879 
1880      */
1881 
1882     function _checkContractOnERC721Received(
1883 
1884         address from,
1885 
1886         address to,
1887 
1888         uint256 tokenId,
1889 
1890         bytes memory _data
1891 
1892     ) private returns (bool) {
1893 
1894         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1895 
1896             return retval == IERC721Receiver(to).onERC721Received.selector;
1897 
1898         } catch (bytes memory reason) {
1899 
1900             if (reason.length == 0) {
1901 
1902                 revert TransferToNonERC721ReceiverImplementer();
1903 
1904             } else {
1905 
1906                 assembly {
1907 
1908                     revert(add(32, reason), mload(reason))
1909 
1910                 }
1911 
1912             }
1913 
1914         }
1915 
1916     }
1917 
1918 
1919 
1920     /**
1921 
1922      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1923 
1924      * And also called before burning one token.
1925 
1926      *
1927 
1928      * startTokenId - the first token id to be transferred
1929 
1930      * quantity - the amount to be transferred
1931 
1932      *
1933 
1934      * Calling conditions:
1935 
1936      *
1937 
1938      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1939 
1940      * transferred to `to`.
1941 
1942      * - When `from` is zero, `tokenId` will be minted for `to`.
1943 
1944      * - When `to` is zero, `tokenId` will be burned by `from`.
1945 
1946      * - `from` and `to` are never both zero.
1947 
1948      */
1949 
1950     function _beforeTokenTransfers(
1951 
1952         address from,
1953 
1954         address to,
1955 
1956         uint256 startTokenId,
1957 
1958         uint256 quantity
1959 
1960     ) internal virtual {}
1961 
1962 
1963 
1964     /**
1965 
1966      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1967 
1968      * minting.
1969 
1970      * And also called after one token has been burned.
1971 
1972      *
1973 
1974      * startTokenId - the first token id to be transferred
1975 
1976      * quantity - the amount to be transferred
1977 
1978      *
1979 
1980      * Calling conditions:
1981 
1982      *
1983 
1984      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1985 
1986      * transferred to `to`.
1987 
1988      * - When `from` is zero, `tokenId` has been minted for `to`.
1989 
1990      * - When `to` is zero, `tokenId` has been burned by `from`.
1991 
1992      * - `from` and `to` are never both zero.
1993 
1994      */
1995 
1996     function _afterTokenTransfers(
1997 
1998         address from,
1999 
2000         address to,
2001 
2002         uint256 startTokenId,
2003 
2004         uint256 quantity
2005 
2006     ) internal virtual {}
2007 
2008 }
2009 // File: @openzeppelin/contracts/access/Ownable.sol
2010 
2011 
2012 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2013 
2014 pragma solidity ^0.8.0;
2015 
2016 
2017 /**
2018  * @dev Contract module which provides a basic access control mechanism, where
2019  * there is an account (an owner) that can be granted exclusive access to
2020  * specific functions.
2021  *
2022  * By default, the owner account will be the one that deploys the contract. This
2023  * can later be changed with {transferOwnership}.
2024  *
2025  * This module is used through inheritance. It will make available the modifier
2026  * `onlyOwner`, which can be applied to your functions to restrict their use to
2027  * the owner.
2028  */
2029 abstract contract Ownable is Context {
2030     address private _owner;
2031 
2032     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2033 
2034     /**
2035      * @dev Initializes the contract setting the deployer as the initial owner.
2036      */
2037     constructor() {
2038         _transferOwnership(_msgSender());
2039     }
2040 
2041     /**
2042      * @dev Returns the address of the current owner.
2043      */
2044     function owner() public view virtual returns (address) {
2045         return _owner;
2046     }
2047 
2048     /**
2049      * @dev Throws if called by any account other than the owner.
2050      */
2051     modifier onlyOwner() {
2052         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2053         _;
2054     }
2055 
2056     /**
2057      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2058      * Can only be called by the current owner.
2059      */
2060     function transferOwnership(address newOwner) public virtual onlyOwner {
2061         require(newOwner != address(0), "Ownable: new owner is the zero address");
2062         _transferOwnership(newOwner);
2063     }
2064 
2065     /**
2066      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2067      * Internal function without access restriction.
2068      */
2069     function _transferOwnership(address newOwner) internal virtual {
2070         address oldOwner = _owner;
2071         _owner = newOwner;
2072         emit OwnershipTransferred(oldOwner, newOwner);
2073     }
2074 }
2075 
2076 // File: contracts/contract.sol
2077 
2078 
2079 pragma solidity ^0.8.4;
2080 
2081 
2082 
2083 contract LifeForms is Ownable, ERC721A, DefaultOperatorFilterer  {
2084 
2085     using Strings for uint256;
2086 
2087     string private baseTokenURI;
2088 
2089     uint256 public publicSaleCost = 0.01 ether;
2090 
2091     uint64 public maxSupply = 1000;
2092 
2093     uint64 public publicMaxSupply = 1000;
2094     uint64 public publicTotalSupply = 0;
2095 
2096     uint64 public maxMintAmountPerPublicAccount = 5;
2097 
2098     bool public presaleActive = false;
2099     bool public publicSaleActive = false;
2100 
2101     constructor() ERC721A("LifeForms by Guggenhiem", "LIFE"){}
2102 
2103     modifier mintCompliance(uint256 _mintAmount) {
2104         require(_mintAmount > 0 , "Invalid mint amount!");
2105         require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
2106         _;
2107     }
2108 
2109     ///Allows any address to mint when the public sale is open
2110     function publicMint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2111         require(publicSaleActive, "Public is not Active");
2112         require(tx.origin == msg.sender);
2113 
2114         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerPublicAccount, "Mint limit exceeded." );
2115         require(publicTotalSupply + _mintAmount <= publicMaxSupply, "Mint limit exceeded." );
2116         require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
2117 
2118 
2119         publicTotalSupply+=_mintAmount;
2120         _safeMint(msg.sender, _mintAmount);
2121     }
2122 
2123     ///Allows owner of the collection to airdrop a token to any address
2124     function ownerMint(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2125         _safeMint(_receiver, _mintAmount);
2126     }
2127 
2128     //@return token ids owned by an address in the collection
2129     function walletOfOwner(address _owner)
2130         external
2131         view
2132         returns (uint256[] memory)
2133     {
2134         uint256 ownerTokenCount = balanceOf(_owner);
2135         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2136         uint256 currentTokenId = 1;
2137         uint256 ownedTokenIndex = 0;
2138 
2139         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2140             if(exists(currentTokenId) == true) {
2141                 address currentTokenOwner = ownerOf(currentTokenId);
2142 
2143                 if (currentTokenOwner == _owner) {
2144                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
2145                     ownedTokenIndex++;
2146                 }
2147             }
2148             currentTokenId++;
2149         }
2150 
2151         return ownedTokenIds;
2152     }
2153 
2154     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2155         super.transferFrom(from, to, tokenId);
2156     }
2157 
2158     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2159         super.safeTransferFrom(from, to, tokenId);
2160     }
2161 
2162     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2163         public
2164         override
2165         onlyAllowedOperator(from)
2166     {
2167         super.safeTransferFrom(from, to, tokenId, data);
2168     }
2169 
2170     //@return full url for passed in token id 
2171     function tokenURI(uint256 _tokenId)
2172 
2173         public
2174         view
2175         virtual
2176         override
2177         returns (string memory)
2178 
2179     {
2180 
2181         require(
2182         _exists(_tokenId),
2183         "ERC721Metadata: URI query for nonexistent token"
2184         );
2185 
2186         string memory currentBaseURI = _baseURI();
2187 
2188         return bytes(currentBaseURI).length > 0
2189 
2190             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString()))
2191 
2192             : "";
2193     }
2194 
2195 
2196 
2197     //@return amount an address has minted during the presale
2198     function getPresaleAmountMintedPerAccount(address _owner) public view returns (uint64) {
2199         return _getAux(_owner);
2200     }
2201 
2202     function setPresaleAmountMintedPerAccount(address _owner, uint64 _aux) internal {
2203         _setAux(_owner, _aux);
2204     }
2205 
2206 
2207     //@return amount an address has minted during all sales
2208     function numberMinted(address _owner) public view returns (uint256) {
2209         return _numberMinted(_owner);
2210     }
2211 
2212     //@return all NFT's minted including burned tokens
2213     function totalMinted() public view returns (uint256) {
2214         return _totalMinted();
2215     }
2216 
2217     function exists(uint256 _tokenId) public view returns (bool) {
2218         return _exists(_tokenId);
2219     }
2220 
2221     //@return url for the nft metadata
2222     function _baseURI() internal view virtual override returns (string memory) {
2223         return baseTokenURI;
2224     }
2225 
2226     function setBaseURI(string calldata _URI) external onlyOwner {
2227         baseTokenURI = _URI;
2228     }
2229 
2230     function setPublicActive(bool _state) public onlyOwner {
2231         publicSaleActive = _state;
2232     }
2233 
2234     function withdraw() public onlyOwner {
2235         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2236         require(os);
2237     }
2238 
2239     /// Fallbacks 
2240     receive() external payable { }
2241     fallback() external payable { }
2242 }