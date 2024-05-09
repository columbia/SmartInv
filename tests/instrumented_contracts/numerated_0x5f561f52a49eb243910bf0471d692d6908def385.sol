1 // SPDX-License-Identifier: MIT
2 
3 // File: IOperatorFilterRegistry.sol
4 
5 
6 pragma solidity ^0.8.13;
7 
8 interface IOperatorFilterRegistry {
9     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
10     function register(address registrant) external;
11     function registerAndSubscribe(address registrant, address subscription) external;
12     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
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
34 // File: OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 abstract contract OperatorFilterer {
41     error OperatorNotAllowed(address operator);
42 
43     IOperatorFilterRegistry constant operatorFilterRegistry =
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
86 // File: DefaultOperatorFilterer.sol
87 
88 
89 pragma solidity ^0.8.13;
90 
91 
92 abstract contract DefaultOperatorFilterer is OperatorFilterer {
93     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
94 
95     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
96 }
97 
98 // File: undead-ape-yacht-club.sol
99 
100 
101 
102 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev These functions deal with verification of Merkle Trees proofs.
111  *
112  * The proofs can be generated using the JavaScript library
113  * https://github.com/miguelmota/merkletreejs[merkletreejs].
114  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
115  *
116  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
117  *
118  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
119  * hashing, or use a hash function other than keccak256 for hashing leaves.
120  * This is because the concatenation of a sorted pair of internal nodes in
121  * the merkle tree could be reinterpreted as a leaf value.
122  */
123 library MerkleProof {
124     /**
125      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
126      * defined by `root`. For this, a `proof` must be provided, containing
127      * sibling hashes on the branch from the leaf to the root of the tree. Each
128      * pair of leaves and each pair of pre-images are assumed to be sorted.
129      */
130     function verify(
131         bytes32[] memory proof,
132         bytes32 root,
133         bytes32 leaf
134     ) internal pure returns (bool) {
135         return processProof(proof, leaf) == root;
136     }
137 
138     /**
139      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
140      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
141      * hash matches the root of the tree. When processing the proof, the pairs
142      * of leafs & pre-images are assumed to be sorted.
143      *
144      * _Available since v4.4._
145      */
146     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
147         bytes32 computedHash = leaf;
148         for (uint256 i = 0; i < proof.length; i++) {
149             bytes32 proofElement = proof[i];
150             if (computedHash <= proofElement) {
151                 // Hash(current computed hash + current element of the proof)
152                 computedHash = _efficientHash(computedHash, proofElement);
153             } else {
154                 // Hash(current element of the proof + current computed hash)
155                 computedHash = _efficientHash(proofElement, computedHash);
156             }
157         }
158         return computedHash;
159     }
160 
161     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
162         assembly {
163             mstore(0x00, a)
164             mstore(0x20, b)
165             value := keccak256(0x00, 0x40)
166         }
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Strings.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev String operations.
179  */
180 library Strings {
181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
185      */
186     function toString(uint256 value) internal pure returns (string memory) {
187         // Inspired by OraclizeAPI's implementation - MIT licence
188         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
189 
190         if (value == 0) {
191             return "0";
192         }
193         uint256 temp = value;
194         uint256 digits;
195         while (temp != 0) {
196             digits++;
197             temp /= 10;
198         }
199         bytes memory buffer = new bytes(digits);
200         while (value != 0) {
201             digits -= 1;
202             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
203             value /= 10;
204         }
205         return string(buffer);
206     }
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
210      */
211     function toHexString(uint256 value) internal pure returns (string memory) {
212         if (value == 0) {
213             return "0x00";
214         }
215         uint256 temp = value;
216         uint256 length = 0;
217         while (temp != 0) {
218             length++;
219             temp >>= 8;
220         }
221         return toHexString(value, length);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
226      */
227     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
228         bytes memory buffer = new bytes(2 * length + 2);
229         buffer[0] = "0";
230         buffer[1] = "x";
231         for (uint256 i = 2 * length + 1; i > 1; --i) {
232             buffer[i] = _HEX_SYMBOLS[value & 0xf];
233             value >>= 4;
234         }
235         require(value == 0, "Strings: hex length insufficient");
236         return string(buffer);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: @openzeppelin/contracts/utils/Context.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 /**
736  * @dev Provides information about the current execution context, including the
737  * sender of the transaction and its data. While these are generally available
738  * via msg.sender and msg.data, they should not be accessed in such a direct
739  * manner, since when dealing with meta-transactions the account sending and
740  * paying for execution may not be the actual sender (as far as an application
741  * is concerned).
742  *
743  * This contract is only required for intermediate, library-like contracts.
744  */
745 abstract contract Context {
746     function _msgSender() internal view virtual returns (address) {
747         return msg.sender;
748     }
749 
750     function _msgData() internal view virtual returns (bytes calldata) {
751         return msg.data;
752     }
753 }
754 
755 // File: contracts/erc721a.sol
756 
757 
758 
759 // Creator: Chiru Labs
760 
761 
762 
763 pragma solidity ^0.8.4;
764 
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 error ApprovalCallerNotOwnerNorApproved();
775 
776 error ApprovalQueryForNonexistentToken();
777 
778 error ApproveToCaller();
779 
780 error ApprovalToCurrentOwner();
781 
782 error BalanceQueryForZeroAddress();
783 
784 error MintToZeroAddress();
785 
786 error MintZeroQuantity();
787 
788 error OwnerQueryForNonexistentToken();
789 
790 error TransferCallerNotOwnerNorApproved();
791 
792 error TransferFromIncorrectOwner();
793 
794 error TransferToNonERC721ReceiverImplementer();
795 
796 error TransferToZeroAddress();
797 
798 error URIQueryForNonexistentToken();
799 
800 
801 
802 /**
803 
804  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
805 
806  * the Metadata extension. Built to optimize for lower gas during batch mints.
807 
808  *
809 
810  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
811 
812  *
813 
814  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
815 
816  *
817 
818  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
819 
820  */
821 
822 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
823 
824     using Address for address;
825 
826     using Strings for uint256;
827 
828 
829 
830     // Compiler will pack this into a single 256bit word.
831 
832     struct TokenOwnership {
833 
834         // The address of the owner.
835 
836         address addr;
837 
838         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
839 
840         uint64 startTimestamp;
841 
842         // Whether the token has been burned.
843 
844         bool burned;
845 
846     }
847 
848 
849 
850     // Compiler will pack this into a single 256bit word.
851 
852     struct AddressData {
853 
854         // Realistically, 2**64-1 is more than enough.
855 
856         uint64 balance;
857 
858         // Keeps track of mint count with minimal overhead for tokenomics.
859 
860         uint64 numberMinted;
861 
862         // Keeps track of burn count with minimal overhead for tokenomics.
863 
864         uint64 numberBurned;
865 
866         // For miscellaneous variable(s) pertaining to the address
867 
868         // (e.g. number of whitelist mint slots used).
869 
870         // If there are multiple variables, please pack them into a uint64.
871 
872         uint64 aux;
873 
874     }
875 
876 
877 
878     // The tokenId of the next token to be minted.
879 
880     uint256 internal _currentIndex;
881 
882 
883 
884     // The number of tokens burned.
885 
886     uint256 internal _burnCounter;
887 
888 
889 
890     // Token name
891 
892     string private _name;
893 
894 
895 
896     // Token symbol
897 
898     string private _symbol;
899 
900 
901 
902     // Mapping from token ID to ownership details
903 
904     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
905 
906     mapping(uint256 => TokenOwnership) internal _ownerships;
907 
908 
909 
910     // Mapping owner address to address data
911 
912     mapping(address => AddressData) private _addressData;
913 
914 
915 
916     // Mapping from token ID to approved address
917 
918     mapping(uint256 => address) private _tokenApprovals;
919 
920 
921 
922     // Mapping from owner to operator approvals
923 
924     mapping(address => mapping(address => bool)) private _operatorApprovals;
925 
926 
927 
928     constructor(string memory name_, string memory symbol_) {
929 
930         _name = name_;
931 
932         _symbol = symbol_;
933 
934         _currentIndex = _startTokenId();
935 
936     }
937 
938 
939 
940     /**
941 
942      * To change the starting tokenId, please override this function.
943 
944      */
945 
946     function _startTokenId() internal view virtual returns (uint256) {
947 
948         return 1;
949 
950     }
951 
952 
953 
954     /**
955 
956      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
957 
958      */
959 
960     function totalSupply() public view returns (uint256) {
961 
962         // Counter underflow is impossible as _burnCounter cannot be incremented
963 
964         // more than _currentIndex - _startTokenId() times
965 
966         unchecked {
967 
968             return _currentIndex - _burnCounter - _startTokenId();
969 
970         }
971 
972     }
973 
974 
975 
976     /**
977 
978      * Returns the total amount of tokens minted in the contract.
979 
980      */
981 
982     function _totalMinted() internal view returns (uint256) {
983 
984         // Counter underflow is impossible as _currentIndex does not decrement,
985 
986         // and it is initialized to _startTokenId()
987 
988         unchecked {
989 
990             return _currentIndex - _startTokenId();
991 
992         }
993 
994     }
995 
996 
997 
998     /**
999 
1000      * @dev See {IERC165-supportsInterface}.
1001 
1002      */
1003 
1004     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1005 
1006         return
1007 
1008             interfaceId == type(IERC721).interfaceId ||
1009 
1010             interfaceId == type(IERC721Metadata).interfaceId ||
1011 
1012             super.supportsInterface(interfaceId);
1013 
1014     }
1015 
1016 
1017 
1018     /**
1019 
1020      * @dev See {IERC721-balanceOf}.
1021 
1022      */
1023 
1024     function balanceOf(address owner) public view override returns (uint256) {
1025 
1026         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1027 
1028         return uint256(_addressData[owner].balance);
1029 
1030     }
1031 
1032 
1033 
1034     /**
1035 
1036      * Returns the number of tokens minted by `owner`.
1037 
1038      */
1039 
1040     function _numberMinted(address owner) internal view returns (uint256) {
1041 
1042         return uint256(_addressData[owner].numberMinted);
1043 
1044     }
1045 
1046 
1047 
1048     /**
1049 
1050      * Returns the number of tokens burned by or on behalf of `owner`.
1051 
1052      */
1053 
1054     function _numberBurned(address owner) internal view returns (uint256) {
1055 
1056         return uint256(_addressData[owner].numberBurned);
1057 
1058     }
1059 
1060 
1061 
1062     /**
1063 
1064      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1065 
1066      */
1067 
1068     function _getAux(address owner) internal view returns (uint64) {
1069 
1070         return _addressData[owner].aux;
1071 
1072     }
1073 
1074 
1075 
1076     /**
1077 
1078      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1079 
1080      * If there are multiple variables, please pack them into a uint64.
1081 
1082      */
1083 
1084     function _setAux(address owner, uint64 aux) internal {
1085 
1086         _addressData[owner].aux = aux;
1087 
1088     }
1089 
1090 
1091 
1092     /**
1093 
1094      * Gas spent here starts off proportional to the maximum mint batch size.
1095 
1096      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1097 
1098      */
1099 
1100     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1101 
1102         uint256 curr = tokenId;
1103 
1104 
1105 
1106         unchecked {
1107 
1108             if (_startTokenId() <= curr && curr < _currentIndex) {
1109 
1110                 TokenOwnership memory ownership = _ownerships[curr];
1111 
1112                 if (!ownership.burned) {
1113 
1114                     if (ownership.addr != address(0)) {
1115 
1116                         return ownership;
1117 
1118                     }
1119 
1120                     // Invariant:
1121 
1122                     // There will always be an ownership that has an address and is not burned
1123 
1124                     // before an ownership that does not have an address and is not burned.
1125 
1126                     // Hence, curr will not underflow.
1127 
1128                     while (true) {
1129 
1130                         curr--;
1131 
1132                         ownership = _ownerships[curr];
1133 
1134                         if (ownership.addr != address(0)) {
1135 
1136                             return ownership;
1137 
1138                         }
1139 
1140                     }
1141 
1142                 }
1143 
1144             }
1145 
1146         }
1147 
1148         revert OwnerQueryForNonexistentToken();
1149 
1150     }
1151 
1152 
1153 
1154     /**
1155 
1156      * @dev See {IERC721-ownerOf}.
1157 
1158      */
1159 
1160     function ownerOf(uint256 tokenId) public view override returns (address) {
1161 
1162         return _ownershipOf(tokenId).addr;
1163 
1164     }
1165 
1166 
1167 
1168     /**
1169 
1170      * @dev See {IERC721Metadata-name}.
1171 
1172      */
1173 
1174     function name() public view virtual override returns (string memory) {
1175 
1176         return _name;
1177 
1178     }
1179 
1180 
1181 
1182     /**
1183 
1184      * @dev See {IERC721Metadata-symbol}.
1185 
1186      */
1187 
1188     function symbol() public view virtual override returns (string memory) {
1189 
1190         return _symbol;
1191 
1192     }
1193 
1194 
1195 
1196     /**
1197 
1198      * @dev See {IERC721Metadata-tokenURI}.
1199 
1200      */
1201 
1202     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1203 
1204         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1205 
1206 
1207 
1208         string memory baseURI = _baseURI();
1209 
1210         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1211 
1212     }
1213 
1214 
1215 
1216     /**
1217 
1218      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1219 
1220      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1221 
1222      * by default, can be overriden in child contracts.
1223 
1224      */
1225 
1226     function _baseURI() internal view virtual returns (string memory) {
1227 
1228         return '';
1229 
1230     }
1231 
1232 
1233 
1234     /**
1235 
1236      * @dev See {IERC721-approve}.
1237 
1238      */
1239 
1240     function approve(address to, uint256 tokenId) public override {
1241 
1242         address owner = ERC721A.ownerOf(tokenId);
1243 
1244         if (to == owner) revert ApprovalToCurrentOwner();
1245 
1246 
1247 
1248         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1249 
1250             revert ApprovalCallerNotOwnerNorApproved();
1251 
1252         }
1253 
1254 
1255 
1256         _approve(to, tokenId, owner);
1257 
1258     }
1259 
1260 
1261 
1262     /**
1263 
1264      * @dev See {IERC721-getApproved}.
1265 
1266      */
1267 
1268     function getApproved(uint256 tokenId) public view override returns (address) {
1269 
1270         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1271 
1272 
1273 
1274         return _tokenApprovals[tokenId];
1275 
1276     }
1277 
1278 
1279 
1280     /**
1281 
1282      * @dev See {IERC721-setApprovalForAll}.
1283 
1284      */
1285 
1286     function setApprovalForAll(address operator, bool approved) public virtual override {
1287 
1288         if (operator == _msgSender()) revert ApproveToCaller();
1289 
1290 
1291 
1292         _operatorApprovals[_msgSender()][operator] = approved;
1293 
1294         emit ApprovalForAll(_msgSender(), operator, approved);
1295 
1296     }
1297 
1298 
1299 
1300     /**
1301 
1302      * @dev See {IERC721-isApprovedForAll}.
1303 
1304      */
1305 
1306     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1307 
1308         return _operatorApprovals[owner][operator];
1309 
1310     }
1311 
1312 
1313 
1314     /**
1315 
1316      * @dev See {IERC721-transferFrom}.
1317 
1318      */
1319 
1320     function transferFrom(
1321 
1322         address from,
1323 
1324         address to,
1325 
1326         uint256 tokenId
1327 
1328     ) public virtual override {
1329 
1330         _transfer(from, to, tokenId);
1331 
1332     }
1333 
1334 
1335 
1336     /**
1337 
1338      * @dev See {IERC721-safeTransferFrom}.
1339 
1340      */
1341 
1342     function safeTransferFrom(
1343 
1344         address from,
1345 
1346         address to,
1347 
1348         uint256 tokenId
1349 
1350     ) public virtual override {
1351 
1352         safeTransferFrom(from, to, tokenId, '');
1353 
1354     }
1355 
1356 
1357 
1358     /**
1359 
1360      * @dev See {IERC721-safeTransferFrom}.
1361 
1362      */
1363 
1364     function safeTransferFrom(
1365 
1366         address from,
1367 
1368         address to,
1369 
1370         uint256 tokenId,
1371 
1372         bytes memory _data
1373 
1374     ) public virtual override {
1375 
1376         _transfer(from, to, tokenId);
1377 
1378         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1379 
1380             revert TransferToNonERC721ReceiverImplementer();
1381 
1382         }
1383 
1384     }
1385 
1386 
1387 
1388     /**
1389 
1390      * @dev Returns whether `tokenId` exists.
1391 
1392      *
1393 
1394      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1395 
1396      *
1397 
1398      * Tokens start existing when they are minted (`_mint`),
1399 
1400      */
1401 
1402     function _exists(uint256 tokenId) internal view returns (bool) {
1403 
1404         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1405 
1406             !_ownerships[tokenId].burned;
1407 
1408     }
1409 
1410 
1411 
1412     function _safeMint(address to, uint256 quantity) internal {
1413 
1414         _safeMint(to, quantity, '');
1415 
1416     }
1417 
1418 
1419 
1420     /**
1421 
1422      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1423 
1424      *
1425 
1426      * Requirements:
1427 
1428      *
1429 
1430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1431 
1432      * - `quantity` must be greater than 0.
1433 
1434      *
1435 
1436      * Emits a {Transfer} event.
1437 
1438      */
1439 
1440     function _safeMint(
1441 
1442         address to,
1443 
1444         uint256 quantity,
1445 
1446         bytes memory _data
1447 
1448     ) internal {
1449 
1450         _mint(to, quantity, _data, true);
1451 
1452     }
1453 
1454 
1455 
1456     /**
1457 
1458      * @dev Mints `quantity` tokens and transfers them to `to`.
1459 
1460      *
1461 
1462      * Requirements:
1463 
1464      *
1465 
1466      * - `to` cannot be the zero address.
1467 
1468      * - `quantity` must be greater than 0.
1469 
1470      *
1471 
1472      * Emits a {Transfer} event.
1473 
1474      */
1475 
1476     function _mint(
1477 
1478         address to,
1479 
1480         uint256 quantity,
1481 
1482         bytes memory _data,
1483 
1484         bool safe
1485 
1486     ) internal {
1487 
1488         uint256 startTokenId = _currentIndex;
1489 
1490         if (to == address(0)) revert MintToZeroAddress();
1491 
1492         if (quantity == 0) revert MintZeroQuantity();
1493 
1494 
1495 
1496         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1497 
1498 
1499 
1500         // Overflows are incredibly unrealistic.
1501 
1502         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1503 
1504         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1505 
1506         unchecked {
1507 
1508             _addressData[to].balance += uint64(quantity);
1509 
1510             _addressData[to].numberMinted += uint64(quantity);
1511 
1512 
1513 
1514             _ownerships[startTokenId].addr = to;
1515 
1516             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1517 
1518 
1519 
1520             uint256 updatedIndex = startTokenId;
1521 
1522             uint256 end = updatedIndex + quantity;
1523 
1524 
1525 
1526             if (safe && to.isContract()) {
1527 
1528                 do {
1529 
1530                     emit Transfer(address(0), to, updatedIndex);
1531 
1532                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1533 
1534                         revert TransferToNonERC721ReceiverImplementer();
1535 
1536                     }
1537 
1538                 } while (updatedIndex != end);
1539 
1540                 // Reentrancy protection
1541 
1542                 if (_currentIndex != startTokenId) revert();
1543 
1544             } else {
1545 
1546                 do {
1547 
1548                     emit Transfer(address(0), to, updatedIndex++);
1549 
1550                 } while (updatedIndex != end);
1551 
1552             }
1553 
1554             _currentIndex = updatedIndex;
1555 
1556         }
1557 
1558         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1559 
1560     }
1561 
1562 
1563 
1564     /**
1565 
1566      * @dev Transfers `tokenId` from `from` to `to`.
1567 
1568      *
1569 
1570      * Requirements:
1571 
1572      *
1573 
1574      * - `to` cannot be the zero address.
1575 
1576      * - `tokenId` token must be owned by `from`.
1577 
1578      *
1579 
1580      * Emits a {Transfer} event.
1581 
1582      */
1583 
1584     function _transfer(
1585 
1586         address from,
1587 
1588         address to,
1589 
1590         uint256 tokenId
1591 
1592     ) private {
1593 
1594         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1595 
1596 
1597 
1598         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1599 
1600 
1601 
1602         bool isApprovedOrOwner = (_msgSender() == from ||
1603 
1604             isApprovedForAll(from, _msgSender()) ||
1605 
1606             getApproved(tokenId) == _msgSender());
1607 
1608 
1609 
1610         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1611 
1612         if (to == address(0)) revert TransferToZeroAddress();
1613 
1614 
1615 
1616         _beforeTokenTransfers(from, to, tokenId, 1);
1617 
1618 
1619 
1620         // Clear approvals from the previous owner
1621 
1622         _approve(address(0), tokenId, from);
1623 
1624 
1625 
1626         // Underflow of the sender's balance is impossible because we check for
1627 
1628         // ownership above and the recipient's balance can't realistically overflow.
1629 
1630         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1631 
1632         unchecked {
1633 
1634             _addressData[from].balance -= 1;
1635 
1636             _addressData[to].balance += 1;
1637 
1638 
1639 
1640             TokenOwnership storage currSlot = _ownerships[tokenId];
1641 
1642             currSlot.addr = to;
1643 
1644             currSlot.startTimestamp = uint64(block.timestamp);
1645 
1646 
1647 
1648             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1649 
1650             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1651 
1652             uint256 nextTokenId = tokenId + 1;
1653 
1654             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1655 
1656             if (nextSlot.addr == address(0)) {
1657 
1658                 // This will suffice for checking _exists(nextTokenId),
1659 
1660                 // as a burned slot cannot contain the zero address.
1661 
1662                 if (nextTokenId != _currentIndex) {
1663 
1664                     nextSlot.addr = from;
1665 
1666                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1667 
1668                 }
1669 
1670             }
1671 
1672         }
1673 
1674 
1675 
1676         emit Transfer(from, to, tokenId);
1677 
1678         _afterTokenTransfers(from, to, tokenId, 1);
1679 
1680     }
1681 
1682 
1683 
1684     /**
1685 
1686      * @dev This is equivalent to _burn(tokenId, false)
1687 
1688      */
1689 
1690     function _burn(uint256 tokenId) internal virtual {
1691 
1692         _burn(tokenId, false);
1693 
1694     }
1695 
1696 
1697 
1698     /**
1699 
1700      * @dev Destroys `tokenId`.
1701 
1702      * The approval is cleared when the token is burned.
1703 
1704      *
1705 
1706      * Requirements:
1707 
1708      *
1709 
1710      * - `tokenId` must exist.
1711 
1712      *
1713 
1714      * Emits a {Transfer} event.
1715 
1716      */
1717 
1718     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1719 
1720         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1721 
1722 
1723 
1724         address from = prevOwnership.addr;
1725 
1726 
1727 
1728         if (approvalCheck) {
1729 
1730             bool isApprovedOrOwner = (_msgSender() == from ||
1731 
1732                 isApprovedForAll(from, _msgSender()) ||
1733 
1734                 getApproved(tokenId) == _msgSender());
1735 
1736 
1737 
1738             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1739 
1740         }
1741 
1742 
1743 
1744         _beforeTokenTransfers(from, address(0), tokenId, 1);
1745 
1746 
1747 
1748         // Clear approvals from the previous owner
1749 
1750         _approve(address(0), tokenId, from);
1751 
1752 
1753 
1754         // Underflow of the sender's balance is impossible because we check for
1755 
1756         // ownership above and the recipient's balance can't realistically overflow.
1757 
1758         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1759 
1760         unchecked {
1761 
1762             AddressData storage addressData = _addressData[from];
1763 
1764             addressData.balance -= 1;
1765 
1766             addressData.numberBurned += 1;
1767 
1768 
1769 
1770             // Keep track of who burned the token, and the timestamp of burning.
1771 
1772             TokenOwnership storage currSlot = _ownerships[tokenId];
1773 
1774             currSlot.addr = from;
1775 
1776             currSlot.startTimestamp = uint64(block.timestamp);
1777 
1778             currSlot.burned = true;
1779 
1780 
1781 
1782             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1783 
1784             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1785 
1786             uint256 nextTokenId = tokenId + 1;
1787 
1788             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1789 
1790             if (nextSlot.addr == address(0)) {
1791 
1792                 // This will suffice for checking _exists(nextTokenId),
1793 
1794                 // as a burned slot cannot contain the zero address.
1795 
1796                 if (nextTokenId != _currentIndex) {
1797 
1798                     nextSlot.addr = from;
1799 
1800                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1801 
1802                 }
1803 
1804             }
1805 
1806         }
1807 
1808 
1809 
1810         emit Transfer(from, address(0), tokenId);
1811 
1812         _afterTokenTransfers(from, address(0), tokenId, 1);
1813 
1814 
1815 
1816         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1817 
1818         unchecked {
1819 
1820             _burnCounter++;
1821 
1822         }
1823 
1824     }
1825 
1826 
1827 
1828     /**
1829 
1830      * @dev Approve `to` to operate on `tokenId`
1831 
1832      *
1833 
1834      * Emits a {Approval} event.
1835 
1836      */
1837 
1838     function _approve(
1839 
1840         address to,
1841 
1842         uint256 tokenId,
1843 
1844         address owner
1845 
1846     ) private {
1847 
1848         _tokenApprovals[tokenId] = to;
1849 
1850         emit Approval(owner, to, tokenId);
1851 
1852     }
1853 
1854 
1855 
1856     /**
1857 
1858      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1859 
1860      *
1861 
1862      * @param from address representing the previous owner of the given token ID
1863 
1864      * @param to target address that will receive the tokens
1865 
1866      * @param tokenId uint256 ID of the token to be transferred
1867 
1868      * @param _data bytes optional data to send along with the call
1869 
1870      * @return bool whether the call correctly returned the expected magic value
1871 
1872      */
1873 
1874     function _checkContractOnERC721Received(
1875 
1876         address from,
1877 
1878         address to,
1879 
1880         uint256 tokenId,
1881 
1882         bytes memory _data
1883 
1884     ) private returns (bool) {
1885 
1886         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1887 
1888             return retval == IERC721Receiver(to).onERC721Received.selector;
1889 
1890         } catch (bytes memory reason) {
1891 
1892             if (reason.length == 0) {
1893 
1894                 revert TransferToNonERC721ReceiverImplementer();
1895 
1896             } else {
1897 
1898                 assembly {
1899 
1900                     revert(add(32, reason), mload(reason))
1901 
1902                 }
1903 
1904             }
1905 
1906         }
1907 
1908     }
1909 
1910 
1911 
1912     /**
1913 
1914      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1915 
1916      * And also called before burning one token.
1917 
1918      *
1919 
1920      * startTokenId - the first token id to be transferred
1921 
1922      * quantity - the amount to be transferred
1923 
1924      *
1925 
1926      * Calling conditions:
1927 
1928      *
1929 
1930      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1931 
1932      * transferred to `to`.
1933 
1934      * - When `from` is zero, `tokenId` will be minted for `to`.
1935 
1936      * - When `to` is zero, `tokenId` will be burned by `from`.
1937 
1938      * - `from` and `to` are never both zero.
1939 
1940      */
1941 
1942     function _beforeTokenTransfers(
1943 
1944         address from,
1945 
1946         address to,
1947 
1948         uint256 startTokenId,
1949 
1950         uint256 quantity
1951 
1952     ) internal virtual {}
1953 
1954 
1955 
1956     /**
1957 
1958      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1959 
1960      * minting.
1961 
1962      * And also called after one token has been burned.
1963 
1964      *
1965 
1966      * startTokenId - the first token id to be transferred
1967 
1968      * quantity - the amount to be transferred
1969 
1970      *
1971 
1972      * Calling conditions:
1973 
1974      *
1975 
1976      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1977 
1978      * transferred to `to`.
1979 
1980      * - When `from` is zero, `tokenId` has been minted for `to`.
1981 
1982      * - When `to` is zero, `tokenId` has been burned by `from`.
1983 
1984      * - `from` and `to` are never both zero.
1985 
1986      */
1987 
1988     function _afterTokenTransfers(
1989 
1990         address from,
1991 
1992         address to,
1993 
1994         uint256 startTokenId,
1995 
1996         uint256 quantity
1997 
1998     ) internal virtual {}
1999 
2000 }
2001 // File: @openzeppelin/contracts/access/Ownable.sol
2002 
2003 
2004 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2005 
2006 pragma solidity ^0.8.0;
2007 
2008 
2009 /**
2010  * @dev Contract module which provides a basic access control mechanism, where
2011  * there is an account (an owner) that can be granted exclusive access to
2012  * specific functions.
2013  *
2014  * By default, the owner account will be the one that deploys the contract. This
2015  * can later be changed with {transferOwnership}.
2016  *
2017  * This module is used through inheritance. It will make available the modifier
2018  * `onlyOwner`, which can be applied to your functions to restrict their use to
2019  * the owner.
2020  */
2021 abstract contract Ownable is Context {
2022     address private _owner;
2023 
2024     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2025 
2026     /**
2027      * @dev Initializes the contract setting the deployer as the initial owner.
2028      */
2029     constructor() {
2030         _transferOwnership(_msgSender());
2031     }
2032 
2033     /**
2034      * @dev Returns the address of the current owner.
2035      */
2036     function owner() public view virtual returns (address) {
2037         return _owner;
2038     }
2039 
2040     /**
2041      * @dev Throws if called by any account other than the owner.
2042      */
2043     modifier onlyOwner() {
2044         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2045         _;
2046     }
2047 
2048     /**
2049      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2050      * Can only be called by the current owner.
2051      */
2052     function transferOwnership(address newOwner) public virtual onlyOwner {
2053         require(newOwner != address(0), "Ownable: new owner is the zero address");
2054         _transferOwnership(newOwner);
2055     }
2056 
2057     /**
2058      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2059      * Internal function without access restriction.
2060      */
2061     function _transferOwnership(address newOwner) internal virtual {
2062         address oldOwner = _owner;
2063         _owner = newOwner;
2064         emit OwnershipTransferred(oldOwner, newOwner);
2065     }
2066 }
2067 
2068 // File: contracts/contract.sol
2069 
2070 
2071 pragma solidity ^0.8.4;
2072 
2073 
2074 
2075 contract UndeadApeYachtClub is Ownable, ERC721A, DefaultOperatorFilterer  {
2076 
2077     using Strings for uint256;
2078 
2079     string private baseTokenURI;
2080 
2081     uint256 public presaleCost = 0 ether;
2082     uint256 public publicSaleCost = 0.02 ether;
2083 
2084     uint64 public maxSupply = 7777;
2085 
2086     uint64 public publicMaxSupply = 3777;
2087     uint64 public publicTotalSupply = 0;
2088     uint64 public presaleMaxSupply = 4000;
2089     uint64 public presaleTotalSupply = 0;
2090 
2091     uint64 public maxMintAmountPerPresaleAccount = 1;
2092     uint64 public maxMintAmountPerPublicAccount = 3;
2093 
2094     bool public presaleActive = false;
2095     bool public publicSaleActive = false;
2096 
2097     bytes32 public merkleRoot;
2098 
2099     constructor() ERC721A("Undead Ape Yacht Club", "UAYC"){}
2100 
2101     modifier mintCompliance(uint256 _mintAmount) {
2102         require(_mintAmount > 0 , "Invalid mint amount!");
2103         require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
2104         _;
2105     }
2106 
2107     ///Mints NFTs for whitelist members during the presale
2108     function presaleMint(bytes32[] calldata _merkleProof, uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2109         require(presaleActive, "Presale is not Active");
2110 
2111         require(msg.value == presaleCost * _mintAmount, "Insufficient funds!");
2112         
2113         uint64 presaleAmountMintedPerAccount = getPresaleAmountMintedPerAccount(msg.sender);
2114         require(presaleAmountMintedPerAccount + _mintAmount <= maxMintAmountPerPresaleAccount, "Mint limit exceeded." );
2115         require(presaleTotalSupply + _mintAmount <= presaleMaxSupply, "Mint limit exceeded." );
2116 
2117 
2118         ///verify the provided _merkleProof
2119         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2120         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the Presale whitelist.");
2121         
2122         setPresaleAmountMintedPerAccount(msg.sender,presaleAmountMintedPerAccount + _mintAmount);
2123 
2124         presaleTotalSupply+=_mintAmount;
2125 
2126         _safeMint(msg.sender, _mintAmount);
2127     }
2128 
2129     ///Allows any address to mint when the public sale is open
2130     function publicMint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2131         require(publicSaleActive, "Public is not Active");
2132         require(tx.origin == msg.sender);
2133 
2134         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerPublicAccount, "Mint limit exceeded." );
2135         require(publicTotalSupply + _mintAmount <= publicMaxSupply, "Mint limit exceeded." );
2136         require(msg.value == publicSaleCost * _mintAmount, "Insufficient funds!");
2137 
2138 
2139         publicTotalSupply+=_mintAmount;
2140         _safeMint(msg.sender, _mintAmount);
2141     }
2142 
2143     ///Allows owner of the collection to airdrop a token to any address
2144     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2145         _safeMint(_receiver, _mintAmount);
2146     }
2147 
2148     //@return token ids owned by an address in the collection
2149     function walletOfOwner(address _owner)
2150         external
2151         view
2152         returns (uint256[] memory)
2153     {
2154         uint256 ownerTokenCount = balanceOf(_owner);
2155         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2156         uint256 currentTokenId = 1;
2157         uint256 ownedTokenIndex = 0;
2158 
2159         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2160             if(exists(currentTokenId) == true) {
2161                 address currentTokenOwner = ownerOf(currentTokenId);
2162 
2163                 if (currentTokenOwner == _owner) {
2164                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
2165                     ownedTokenIndex++;
2166                 }
2167             }
2168             currentTokenId++;
2169         }
2170 
2171         return ownedTokenIds;
2172     }
2173 
2174     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2175         super.transferFrom(from, to, tokenId);
2176     }
2177 
2178     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2179         super.safeTransferFrom(from, to, tokenId);
2180     }
2181 
2182     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2183         public
2184         override
2185         onlyAllowedOperator(from)
2186     {
2187         super.safeTransferFrom(from, to, tokenId, data);
2188     }
2189 
2190     //@return full url for passed in token id 
2191     function tokenURI(uint256 _tokenId)
2192 
2193         public
2194         view
2195         virtual
2196         override
2197         returns (string memory)
2198 
2199     {
2200 
2201         require(
2202         _exists(_tokenId),
2203         "ERC721Metadata: URI query for nonexistent token"
2204         );
2205 
2206         string memory currentBaseURI = _baseURI();
2207 
2208         return bytes(currentBaseURI).length > 0
2209 
2210             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2211 
2212             : "";
2213     }
2214 
2215 
2216 
2217     //@return amount an address has minted during the presale
2218     function getPresaleAmountMintedPerAccount(address _owner) public view returns (uint64) {
2219         return _getAux(_owner);
2220     }
2221 
2222     function setPresaleAmountMintedPerAccount(address _owner, uint64 _aux) internal {
2223         _setAux(_owner, _aux);
2224     }
2225 
2226 
2227     //@return amount an address has minted during all sales
2228     function numberMinted(address _owner) public view returns (uint256) {
2229         return _numberMinted(_owner);
2230     }
2231 
2232     //@return all NFT's minted including burned tokens
2233     function totalMinted() public view returns (uint256) {
2234         return _totalMinted();
2235     }
2236 
2237     function exists(uint256 _tokenId) public view returns (bool) {
2238         return _exists(_tokenId);
2239     }
2240 
2241     function burn(uint256 _tokenId) public {
2242         require(exists(_tokenId), "Token does not exist");
2243         require(msg.sender == ownerOf(_tokenId), "Not the owner of the token");
2244         _burn(_tokenId, false);
2245     }
2246 
2247     //@return url for the nft metadata
2248     function _baseURI() internal view virtual override returns (string memory) {
2249         return baseTokenURI;
2250     }
2251 
2252     function setBaseURI(string calldata _URI) external onlyOwner {
2253         baseTokenURI = _URI;
2254     }
2255 
2256     function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
2257         publicSaleCost = _publicSaleCost;
2258     }
2259 
2260     function setPresaleCost(uint256 _presaleCost) public onlyOwner {
2261         presaleCost = _presaleCost;
2262     }
2263 
2264     function setMaxMintPerPresaleAccount(uint64 _maxMintAmountPerPresaleAccount) public onlyOwner {
2265         maxMintAmountPerPresaleAccount = _maxMintAmountPerPresaleAccount;
2266     }
2267    
2268     function setMaxMintPerPublicAccount(uint64 _maxMintAmountPerPublicAccount) public onlyOwner {
2269         maxMintAmountPerPublicAccount = _maxMintAmountPerPublicAccount;
2270     }
2271     
2272     function setPresaleActive(bool _state) public onlyOwner {
2273         presaleActive = _state;
2274     }
2275 
2276     function setPublicActive(bool _state) public onlyOwner {
2277         publicSaleActive = _state;
2278     }
2279 
2280     ///sets merkle tree root which determines the whitelisted addresses
2281     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2282         merkleRoot = _merkleRoot;
2283     }
2284 
2285     function setPublicMaxSupply(uint64 _publicMaxSupply) public onlyOwner {
2286         publicMaxSupply = _publicMaxSupply;
2287     }
2288 
2289     function setPresaleMaxSupply(uint64 _presaleMaxSupply) public onlyOwner {
2290         presaleMaxSupply = _presaleMaxSupply;
2291     }
2292 
2293     function withdraw() public onlyOwner {
2294         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2295         require(os);
2296     }
2297 
2298     /// Fallbacks 
2299     receive() external payable { }
2300     fallback() external payable { }
2301 }