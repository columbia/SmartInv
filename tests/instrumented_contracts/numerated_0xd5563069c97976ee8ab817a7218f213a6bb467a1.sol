1 /*
2          _          _            _          _           _         _          _            _            _              _             _      
3         /\ \       /\ \         /\ \       / /\        /\ \      / /\       /\ \         /\ \         /\ \     _    /\ \           /\ \    
4        /  \ \     /  \ \       /  \ \     / /  \       \ \ \    / /  \      \_\ \       /  \ \       /  \ \   /\_\ /  \ \         /  \ \   
5       / /\ \ \   / /\ \ \     / /\ \ \   / / /\ \__    /\ \_\  / / /\ \__   /\__ \     / /\ \ \     / /\ \ \_/ / // /\ \ \       / /\ \ \  
6      / / /\ \_\ / / /\ \_\   / / /\ \_\ / / /\ \___\  / /\/_/ / / /\ \___\ / /_ \ \   / / /\ \_\   / / /\ \___/ // / /\ \ \     / / /\ \_\ 
7     / / /_/ / // /_/_ \/_/  / / /_/ / / \ \ \ \/___/ / / /    \ \ \ \/___// / /\ \ \ / /_/_ \/_/  / / /  \/____// / /  \ \_\   / /_/_ \/_/ 
8    / / /__\/ // /____/\    / / /__\/ /   \ \ \      / / /      \ \ \     / / /  \/_// /____/\    / / /    / / // / /    \/_/  / /____/\    
9   / / /_____// /\____\/   / / /_____/_    \ \ \    / / /   _    \ \ \   / / /      / /\____\/   / / /    / / // / /          / /\____\/    
10  / / /      / / /______  / / /\ \ \ /_/\__/ / /___/ / /__ /_/\__/ / /  / / /      / / /______  / / /    / / // / /________  / / /______    
11 / / /      / / /_______\/ / /  \ \ \\ \/___/ //\__\/_/___\\ \/___/ /  /_/ /      / / /_______\/ / /    / / // / /_________\/ / /_______\   
12 \/_/       \/__________/\/_/    \_\/ \_____\/ \/_________/ \_____\/   \_\/       \/__________/\/_/     \/_/ \/____________/\/__________/                                                                                                                               
13 333 WL at .01 E Max 2
14 444 Public at .03 E Max 5
15 */
16 
17 pragma solidity ^0.8.13;
18 
19 interface IOperatorFilterRegistry {
20     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
21     function register(address registrant) external;
22     function registerAndSubscribe(address registrant, address subscription) external;
23     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
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
45 // File: OperatorFilterer.sol
46 
47 
48 pragma solidity ^0.8.13;
49 
50 
51 abstract contract OperatorFilterer {
52     error OperatorNotAllowed(address operator);
53 
54     IOperatorFilterRegistry constant operatorFilterRegistry =
55         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
56 
57     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
58         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
59         // will not revert, but the contract will need to be registered with the registry once it is deployed in
60         // order for the modifier to filter addresses.
61         if (address(operatorFilterRegistry).code.length > 0) {
62             if (subscribe) {
63                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
64             } else {
65                 if (subscriptionOrRegistrantToCopy != address(0)) {
66                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
67                 } else {
68                     operatorFilterRegistry.register(address(this));
69                 }
70             }
71         }
72     }
73 
74     modifier onlyAllowedOperator(address from) virtual {
75         // Check registry code length to facilitate testing in environments without a deployed registry.
76         if (address(operatorFilterRegistry).code.length > 0) {
77             // Allow spending tokens from addresses with balance
78             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
79             // from an EOA.
80             if (from == msg.sender) {
81                 _;
82                 return;
83             }
84             if (
85                 !(
86                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
87                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
88                 )
89             ) {
90                 revert OperatorNotAllowed(msg.sender);
91             }
92         }
93         _;
94     }
95 }
96 
97 // File: DefaultOperatorFilterer.sol
98 
99 
100 pragma solidity ^0.8.13;
101 
102 
103 abstract contract DefaultOperatorFilterer is OperatorFilterer {
104     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
105 
106     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
107 }
108 
109 // File: undead-ape-yacht-club.sol
110 
111 
112 
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev These functions deal with verification of Merkle Trees proofs.
122  *
123  * The proofs can be generated using the JavaScript library
124  * https://github.com/miguelmota/merkletreejs[merkletreejs].
125  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
126  *
127  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
128  *
129  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
130  * hashing, or use a hash function other than keccak256 for hashing leaves.
131  * This is because the concatenation of a sorted pair of internal nodes in
132  * the merkle tree could be reinterpreted as a leaf value.
133  */
134 library MerkleProof {
135     /**
136      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
137      * defined by `root`. For this, a `proof` must be provided, containing
138      * sibling hashes on the branch from the leaf to the root of the tree. Each
139      * pair of leaves and each pair of pre-images are assumed to be sorted.
140      */
141     function verify(
142         bytes32[] memory proof,
143         bytes32 root,
144         bytes32 leaf
145     ) internal pure returns (bool) {
146         return processProof(proof, leaf) == root;
147     }
148 
149     /**
150      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
151      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
152      * hash matches the root of the tree. When processing the proof, the pairs
153      * of leafs & pre-images are assumed to be sorted.
154      *
155      * _Available since v4.4._
156      */
157     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
158         bytes32 computedHash = leaf;
159         for (uint256 i = 0; i < proof.length; i++) {
160             bytes32 proofElement = proof[i];
161             if (computedHash <= proofElement) {
162                 // Hash(current computed hash + current element of the proof)
163                 computedHash = _efficientHash(computedHash, proofElement);
164             } else {
165                 // Hash(current element of the proof + current computed hash)
166                 computedHash = _efficientHash(proofElement, computedHash);
167             }
168         }
169         return computedHash;
170     }
171 
172     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
173         assembly {
174             mstore(0x00, a)
175             mstore(0x20, b)
176             value := keccak256(0x00, 0x40)
177         }
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Strings.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev String operations.
190  */
191 library Strings {
192     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
196      */
197     function toString(uint256 value) internal pure returns (string memory) {
198         // Inspired by OraclizeAPI's implementation - MIT licence
199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
200 
201         if (value == 0) {
202             return "0";
203         }
204         uint256 temp = value;
205         uint256 digits;
206         while (temp != 0) {
207             digits++;
208             temp /= 10;
209         }
210         bytes memory buffer = new bytes(digits);
211         while (value != 0) {
212             digits -= 1;
213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
214             value /= 10;
215         }
216         return string(buffer);
217     }
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
221      */
222     function toHexString(uint256 value) internal pure returns (string memory) {
223         if (value == 0) {
224             return "0x00";
225         }
226         uint256 temp = value;
227         uint256 length = 0;
228         while (temp != 0) {
229             length++;
230             temp >>= 8;
231         }
232         return toHexString(value, length);
233     }
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
237      */
238     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
239         bytes memory buffer = new bytes(2 * length + 2);
240         buffer[0] = "0";
241         buffer[1] = "x";
242         for (uint256 i = 2 * length + 1; i > 1; --i) {
243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
244             value >>= 4;
245         }
246         require(value == 0, "Strings: hex length insufficient");
247         return string(buffer);
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Address.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
255 
256 pragma solidity ^0.8.1;
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      *
279      * [IMPORTANT]
280      * ====
281      * You shouldn't rely on `isContract` to protect against flash loan attacks!
282      *
283      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
284      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
285      * constructor.
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize/address.code.length, which returns 0
290         // for contracts in construction, since the code is only stored at the end
291         // of the constructor execution.
292 
293         return account.code.length > 0;
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         (bool success, ) = recipient.call{value: amount}("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain `call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but also transferring `value` wei to `target`.
358      *
359      * Requirements:
360      *
361      * - the calling contract must have an ETH balance of at least `value`.
362      * - the called Solidity function must be `payable`.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         require(isContract(target), "Address: call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.call{value: value}(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
400         return functionStaticCall(target, data, "Address: low-level static call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal view returns (bytes memory) {
414         require(isContract(target), "Address: static call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.staticcall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
427         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         require(isContract(target), "Address: delegate call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.delegatecall(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
449      * revert reason using the provided one.
450      *
451      * _Available since v4.3._
452      */
453     function verifyCallResult(
454         bool success,
455         bytes memory returndata,
456         string memory errorMessage
457     ) internal pure returns (bytes memory) {
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 assembly {
466                     let returndata_size := mload(returndata)
467                     revert(add(32, returndata), returndata_size)
468                 }
469             } else {
470                 revert(errorMessage);
471             }
472         }
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @title ERC721 token receiver interface
485  * @dev Interface for any contract that wants to support safeTransfers
486  * from ERC721 asset contracts.
487  */
488 interface IERC721Receiver {
489     /**
490      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
491      * by `operator` from `from`, this function is called.
492      *
493      * It must return its Solidity selector to confirm the token transfer.
494      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
495      *
496      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
497      */
498     function onERC721Received(
499         address operator,
500         address from,
501         uint256 tokenId,
502         bytes calldata data
503     ) external returns (bytes4);
504 }
505 
506 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Interface of the ERC165 standard, as defined in the
515  * https://eips.ethereum.org/EIPS/eip-165[EIP].
516  *
517  * Implementers can declare support of contract interfaces, which can then be
518  * queried by others ({ERC165Checker}).
519  *
520  * For an implementation, see {ERC165}.
521  */
522 interface IERC165 {
523     /**
524      * @dev Returns true if this contract implements the interface defined by
525      * `interfaceId`. See the corresponding
526      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
527      * to learn more about how these ids are created.
528      *
529      * This function call must use less than 30 000 gas.
530      */
531     function supportsInterface(bytes4 interfaceId) external view returns (bool);
532 }
533 
534 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @dev Required interface of an ERC721 compliant contract.
575  */
576 interface IERC721 is IERC165 {
577     /**
578      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
584      */
585     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
586 
587     /**
588      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
589      */
590     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
591 
592     /**
593      * @dev Returns the number of tokens in ``owner``'s account.
594      */
595     function balanceOf(address owner) external view returns (uint256 balance);
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) external view returns (address owner);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Transfers `tokenId` token from `from` to `to`.
628      *
629      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) external;
645 
646     /**
647      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
648      * The approval is cleared when the token is transferred.
649      *
650      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
651      *
652      * Requirements:
653      *
654      * - The caller must own the token or be an approved operator.
655      * - `tokenId` must exist.
656      *
657      * Emits an {Approval} event.
658      */
659     function approve(address to, uint256 tokenId) external;
660 
661     /**
662      * @dev Returns the account approved for `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function getApproved(uint256 tokenId) external view returns (address operator);
669 
670     /**
671      * @dev Approve or remove `operator` as an operator for the caller.
672      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
673      *
674      * Requirements:
675      *
676      * - The `operator` cannot be the caller.
677      *
678      * Emits an {ApprovalForAll} event.
679      */
680     function setApprovalForAll(address operator, bool _approved) external;
681 
682     /**
683      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
684      *
685      * See {setApprovalForAll}
686      */
687     function isApprovedForAll(address owner, address operator) external view returns (bool);
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes calldata data
707     ) external;
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
720  * @dev See https://eips.ethereum.org/EIPS/eip-721
721  */
722 interface IERC721Metadata is IERC721 {
723     /**
724      * @dev Returns the token collection name.
725      */
726     function name() external view returns (string memory);
727 
728     /**
729      * @dev Returns the token collection symbol.
730      */
731     function symbol() external view returns (string memory);
732 
733     /**
734      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
735      */
736     function tokenURI(uint256 tokenId) external view returns (string memory);
737 }
738 
739 // File: @openzeppelin/contracts/utils/Context.sol
740 
741 
742 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 /**
747  * @dev Provides information about the current execution context, including the
748  * sender of the transaction and its data. While these are generally available
749  * via msg.sender and msg.data, they should not be accessed in such a direct
750  * manner, since when dealing with meta-transactions the account sending and
751  * paying for execution may not be the actual sender (as far as an application
752  * is concerned).
753  *
754  * This contract is only required for intermediate, library-like contracts.
755  */
756 abstract contract Context {
757     function _msgSender() internal view virtual returns (address) {
758         return msg.sender;
759     }
760 
761     function _msgData() internal view virtual returns (bytes calldata) {
762         return msg.data;
763     }
764 }
765 
766 // File: contracts/erc721a.sol
767 
768 
769 
770 // Creator: Chiru Labs
771 
772 
773 
774 pragma solidity ^0.8.4;
775 
776 
777 
778 
779 
780 
781 
782 
783 
784 
785 error ApprovalCallerNotOwnerNorApproved();
786 
787 error ApprovalQueryForNonexistentToken();
788 
789 error ApproveToCaller();
790 
791 error ApprovalToCurrentOwner();
792 
793 error BalanceQueryForZeroAddress();
794 
795 error MintToZeroAddress();
796 
797 error MintZeroQuantity();
798 
799 error OwnerQueryForNonexistentToken();
800 
801 error TransferCallerNotOwnerNorApproved();
802 
803 error TransferFromIncorrectOwner();
804 
805 error TransferToNonERC721ReceiverImplementer();
806 
807 error TransferToZeroAddress();
808 
809 error URIQueryForNonexistentToken();
810 
811 
812 
813 /**
814 
815  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
816 
817  * the Metadata extension. Built to optimize for lower gas during batch mints.
818 
819  *
820 
821  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
822 
823  *
824 
825  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
826 
827  *
828 
829  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
830 
831  */
832 
833 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
834 
835     using Address for address;
836 
837     using Strings for uint256;
838 
839 
840 
841     // Compiler will pack this into a single 256bit word.
842 
843     struct TokenOwnership {
844 
845         // The address of the owner.
846 
847         address addr;
848 
849         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
850 
851         uint64 startTimestamp;
852 
853         // Whether the token has been burned.
854 
855         bool burned;
856 
857     }
858 
859 
860 
861     // Compiler will pack this into a single 256bit word.
862 
863     struct AddressData {
864 
865         // Realistically, 2**64-1 is more than enough.
866 
867         uint64 balance;
868 
869         // Keeps track of mint count with minimal overhead for tokenomics.
870 
871         uint64 numberMinted;
872 
873         // Keeps track of burn count with minimal overhead for tokenomics.
874 
875         uint64 numberBurned;
876 
877         // For miscellaneous variable(s) pertaining to the address
878 
879         // (e.g. number of whitelist mint slots used).
880 
881         // If there are multiple variables, please pack them into a uint64.
882 
883         uint64 aux;
884 
885     }
886 
887 
888 
889     // The tokenId of the next token to be minted.
890 
891     uint256 internal _currentIndex;
892 
893 
894 
895     // The number of tokens burned.
896 
897     uint256 internal _burnCounter;
898 
899 
900 
901     // Token name
902 
903     string private _name;
904 
905 
906 
907     // Token symbol
908 
909     string private _symbol;
910 
911 
912 
913     // Mapping from token ID to ownership details
914 
915     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
916 
917     mapping(uint256 => TokenOwnership) internal _ownerships;
918 
919 
920 
921     // Mapping owner address to address data
922 
923     mapping(address => AddressData) private _addressData;
924 
925 
926 
927     // Mapping from token ID to approved address
928 
929     mapping(uint256 => address) private _tokenApprovals;
930 
931 
932 
933     // Mapping from owner to operator approvals
934 
935     mapping(address => mapping(address => bool)) private _operatorApprovals;
936 
937 
938 
939     constructor(string memory name_, string memory symbol_) {
940 
941         _name = name_;
942 
943         _symbol = symbol_;
944 
945         _currentIndex = _startTokenId();
946 
947     }
948 
949 
950 
951     /**
952 
953      * To change the starting tokenId, please override this function.
954 
955      */
956 
957     function _startTokenId() internal view virtual returns (uint256) {
958 
959         return 1;
960 
961     }
962 
963 
964 
965     /**
966 
967      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
968 
969      */
970 
971     function totalSupply() public view returns (uint256) {
972 
973         // Counter underflow is impossible as _burnCounter cannot be incremented
974 
975         // more than _currentIndex - _startTokenId() times
976 
977         unchecked {
978 
979             return _currentIndex - _burnCounter - _startTokenId();
980 
981         }
982 
983     }
984 
985 
986 
987     /**
988 
989      * Returns the total amount of tokens minted in the contract.
990 
991      */
992 
993     function _totalMinted() internal view returns (uint256) {
994 
995         // Counter underflow is impossible as _currentIndex does not decrement,
996 
997         // and it is initialized to _startTokenId()
998 
999         unchecked {
1000 
1001             return _currentIndex - _startTokenId();
1002 
1003         }
1004 
1005     }
1006 
1007 
1008 
1009     /**
1010 
1011      * @dev See {IERC165-supportsInterface}.
1012 
1013      */
1014 
1015     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1016 
1017         return
1018 
1019             interfaceId == type(IERC721).interfaceId ||
1020 
1021             interfaceId == type(IERC721Metadata).interfaceId ||
1022 
1023             super.supportsInterface(interfaceId);
1024 
1025     }
1026 
1027 
1028 
1029     /**
1030 
1031      * @dev See {IERC721-balanceOf}.
1032 
1033      */
1034 
1035     function balanceOf(address owner) public view override returns (uint256) {
1036 
1037         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1038 
1039         return uint256(_addressData[owner].balance);
1040 
1041     }
1042 
1043 
1044 
1045     /**
1046 
1047      * Returns the number of tokens minted by `owner`.
1048 
1049      */
1050 
1051     function _numberMinted(address owner) internal view returns (uint256) {
1052 
1053         return uint256(_addressData[owner].numberMinted);
1054 
1055     }
1056 
1057 
1058 
1059     /**
1060 
1061      * Returns the number of tokens burned by or on behalf of `owner`.
1062 
1063      */
1064 
1065     function _numberBurned(address owner) internal view returns (uint256) {
1066 
1067         return uint256(_addressData[owner].numberBurned);
1068 
1069     }
1070 
1071 
1072 
1073     /**
1074 
1075      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1076 
1077      */
1078 
1079     function _getAux(address owner) internal view returns (uint64) {
1080 
1081         return _addressData[owner].aux;
1082 
1083     }
1084 
1085 
1086 
1087     /**
1088 
1089      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1090 
1091      * If there are multiple variables, please pack them into a uint64.
1092 
1093      */
1094 
1095     function _setAux(address owner, uint64 aux) internal {
1096 
1097         _addressData[owner].aux = aux;
1098 
1099     }
1100 
1101 
1102 
1103     /**
1104 
1105      * Gas spent here starts off proportional to the maximum mint batch size.
1106 
1107      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1108 
1109      */
1110 
1111     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1112 
1113         uint256 curr = tokenId;
1114 
1115 
1116 
1117         unchecked {
1118 
1119             if (_startTokenId() <= curr && curr < _currentIndex) {
1120 
1121                 TokenOwnership memory ownership = _ownerships[curr];
1122 
1123                 if (!ownership.burned) {
1124 
1125                     if (ownership.addr != address(0)) {
1126 
1127                         return ownership;
1128 
1129                     }
1130 
1131                     // Invariant:
1132 
1133                     // There will always be an ownership that has an address and is not burned
1134 
1135                     // before an ownership that does not have an address and is not burned.
1136 
1137                     // Hence, curr will not underflow.
1138 
1139                     while (true) {
1140 
1141                         curr--;
1142 
1143                         ownership = _ownerships[curr];
1144 
1145                         if (ownership.addr != address(0)) {
1146 
1147                             return ownership;
1148 
1149                         }
1150 
1151                     }
1152 
1153                 }
1154 
1155             }
1156 
1157         }
1158 
1159         revert OwnerQueryForNonexistentToken();
1160 
1161     }
1162 
1163 
1164 
1165     /**
1166 
1167      * @dev See {IERC721-ownerOf}.
1168 
1169      */
1170 
1171     function ownerOf(uint256 tokenId) public view override returns (address) {
1172 
1173         return _ownershipOf(tokenId).addr;
1174 
1175     }
1176 
1177 
1178 
1179     /**
1180 
1181      * @dev See {IERC721Metadata-name}.
1182 
1183      */
1184 
1185     function name() public view virtual override returns (string memory) {
1186 
1187         return _name;
1188 
1189     }
1190 
1191 
1192 
1193     /**
1194 
1195      * @dev See {IERC721Metadata-symbol}.
1196 
1197      */
1198 
1199     function symbol() public view virtual override returns (string memory) {
1200 
1201         return _symbol;
1202 
1203     }
1204 
1205 
1206 
1207     /**
1208 
1209      * @dev See {IERC721Metadata-tokenURI}.
1210 
1211      */
1212 
1213     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1214 
1215         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1216 
1217 
1218 
1219         string memory baseURI = _baseURI();
1220 
1221         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1222 
1223     }
1224 
1225 
1226 
1227     /**
1228 
1229      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1230 
1231      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1232 
1233      * by default, can be overriden in child contracts.
1234 
1235      */
1236 
1237     function _baseURI() internal view virtual returns (string memory) {
1238 
1239         return '';
1240 
1241     }
1242 
1243 
1244 
1245     /**
1246 
1247      * @dev See {IERC721-approve}.
1248 
1249      */
1250 
1251     function approve(address to, uint256 tokenId) public override {
1252 
1253         address owner = ERC721A.ownerOf(tokenId);
1254 
1255         if (to == owner) revert ApprovalToCurrentOwner();
1256 
1257 
1258 
1259         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1260 
1261             revert ApprovalCallerNotOwnerNorApproved();
1262 
1263         }
1264 
1265 
1266 
1267         _approve(to, tokenId, owner);
1268 
1269     }
1270 
1271 
1272 
1273     /**
1274 
1275      * @dev See {IERC721-getApproved}.
1276 
1277      */
1278 
1279     function getApproved(uint256 tokenId) public view override returns (address) {
1280 
1281         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1282 
1283 
1284 
1285         return _tokenApprovals[tokenId];
1286 
1287     }
1288 
1289 
1290 
1291     /**
1292 
1293      * @dev See {IERC721-setApprovalForAll}.
1294 
1295      */
1296 
1297     function setApprovalForAll(address operator, bool approved) public virtual override {
1298 
1299         if (operator == _msgSender()) revert ApproveToCaller();
1300 
1301 
1302 
1303         _operatorApprovals[_msgSender()][operator] = approved;
1304 
1305         emit ApprovalForAll(_msgSender(), operator, approved);
1306 
1307     }
1308 
1309 
1310 
1311     /**
1312 
1313      * @dev See {IERC721-isApprovedForAll}.
1314 
1315      */
1316 
1317     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1318 
1319         return _operatorApprovals[owner][operator];
1320 
1321     }
1322 
1323 
1324 
1325     /**
1326 
1327      * @dev See {IERC721-transferFrom}.
1328 
1329      */
1330 
1331     function transferFrom(
1332 
1333         address from,
1334 
1335         address to,
1336 
1337         uint256 tokenId
1338 
1339     ) public virtual override {
1340 
1341         _transfer(from, to, tokenId);
1342 
1343     }
1344 
1345 
1346 
1347     /**
1348 
1349      * @dev See {IERC721-safeTransferFrom}.
1350 
1351      */
1352 
1353     function safeTransferFrom(
1354 
1355         address from,
1356 
1357         address to,
1358 
1359         uint256 tokenId
1360 
1361     ) public virtual override {
1362 
1363         safeTransferFrom(from, to, tokenId, '');
1364 
1365     }
1366 
1367 
1368 
1369     /**
1370 
1371      * @dev See {IERC721-safeTransferFrom}.
1372 
1373      */
1374 
1375     function safeTransferFrom(
1376 
1377         address from,
1378 
1379         address to,
1380 
1381         uint256 tokenId,
1382 
1383         bytes memory _data
1384 
1385     ) public virtual override {
1386 
1387         _transfer(from, to, tokenId);
1388 
1389         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1390 
1391             revert TransferToNonERC721ReceiverImplementer();
1392 
1393         }
1394 
1395     }
1396 
1397 
1398 
1399     /**
1400 
1401      * @dev Returns whether `tokenId` exists.
1402 
1403      *
1404 
1405      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1406 
1407      *
1408 
1409      * Tokens start existing when they are minted (`_mint`),
1410 
1411      */
1412 
1413     function _exists(uint256 tokenId) internal view returns (bool) {
1414 
1415         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1416 
1417             !_ownerships[tokenId].burned;
1418 
1419     }
1420 
1421 
1422 
1423     function _safeMint(address to, uint256 quantity) internal {
1424 
1425         _safeMint(to, quantity, '');
1426 
1427     }
1428 
1429 
1430 
1431     /**
1432 
1433      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1434 
1435      *
1436 
1437      * Requirements:
1438 
1439      *
1440 
1441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1442 
1443      * - `quantity` must be greater than 0.
1444 
1445      *
1446 
1447      * Emits a {Transfer} event.
1448 
1449      */
1450 
1451     function _safeMint(
1452 
1453         address to,
1454 
1455         uint256 quantity,
1456 
1457         bytes memory _data
1458 
1459     ) internal {
1460 
1461         _mint(to, quantity, _data, true);
1462 
1463     }
1464 
1465 
1466 
1467     /**
1468 
1469      * @dev Mints `quantity` tokens and transfers them to `to`.
1470 
1471      *
1472 
1473      * Requirements:
1474 
1475      *
1476 
1477      * - `to` cannot be the zero address.
1478 
1479      * - `quantity` must be greater than 0.
1480 
1481      *
1482 
1483      * Emits a {Transfer} event.
1484 
1485      */
1486 
1487     function _mint(
1488 
1489         address to,
1490 
1491         uint256 quantity,
1492 
1493         bytes memory _data,
1494 
1495         bool safe
1496 
1497     ) internal {
1498 
1499         uint256 startTokenId = _currentIndex;
1500 
1501         if (to == address(0)) revert MintToZeroAddress();
1502 
1503         if (quantity == 0) revert MintZeroQuantity();
1504 
1505 
1506 
1507         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1508 
1509 
1510 
1511         // Overflows are incredibly unrealistic.
1512 
1513         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1514 
1515         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1516 
1517         unchecked {
1518 
1519             _addressData[to].balance += uint64(quantity);
1520 
1521             _addressData[to].numberMinted += uint64(quantity);
1522 
1523 
1524 
1525             _ownerships[startTokenId].addr = to;
1526 
1527             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1528 
1529 
1530 
1531             uint256 updatedIndex = startTokenId;
1532 
1533             uint256 end = updatedIndex + quantity;
1534 
1535 
1536 
1537             if (safe && to.isContract()) {
1538 
1539                 do {
1540 
1541                     emit Transfer(address(0), to, updatedIndex);
1542 
1543                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1544 
1545                         revert TransferToNonERC721ReceiverImplementer();
1546 
1547                     }
1548 
1549                 } while (updatedIndex != end);
1550 
1551                 // Reentrancy protection
1552 
1553                 if (_currentIndex != startTokenId) revert();
1554 
1555             } else {
1556 
1557                 do {
1558 
1559                     emit Transfer(address(0), to, updatedIndex++);
1560 
1561                 } while (updatedIndex != end);
1562 
1563             }
1564 
1565             _currentIndex = updatedIndex;
1566 
1567         }
1568 
1569         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1570 
1571     }
1572 
1573 
1574 
1575     /**
1576 
1577      * @dev Transfers `tokenId` from `from` to `to`.
1578 
1579      *
1580 
1581      * Requirements:
1582 
1583      *
1584 
1585      * - `to` cannot be the zero address.
1586 
1587      * - `tokenId` token must be owned by `from`.
1588 
1589      *
1590 
1591      * Emits a {Transfer} event.
1592 
1593      */
1594 
1595     function _transfer(
1596 
1597         address from,
1598 
1599         address to,
1600 
1601         uint256 tokenId
1602 
1603     ) private {
1604 
1605         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1606 
1607 
1608 
1609         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1610 
1611 
1612 
1613         bool isApprovedOrOwner = (_msgSender() == from ||
1614 
1615             isApprovedForAll(from, _msgSender()) ||
1616 
1617             getApproved(tokenId) == _msgSender());
1618 
1619 
1620 
1621         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1622 
1623         if (to == address(0)) revert TransferToZeroAddress();
1624 
1625 
1626 
1627         _beforeTokenTransfers(from, to, tokenId, 1);
1628 
1629 
1630 
1631         // Clear approvals from the previous owner
1632 
1633         _approve(address(0), tokenId, from);
1634 
1635 
1636 
1637         // Underflow of the sender's balance is impossible because we check for
1638 
1639         // ownership above and the recipient's balance can't realistically overflow.
1640 
1641         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1642 
1643         unchecked {
1644 
1645             _addressData[from].balance -= 1;
1646 
1647             _addressData[to].balance += 1;
1648 
1649 
1650 
1651             TokenOwnership storage currSlot = _ownerships[tokenId];
1652 
1653             currSlot.addr = to;
1654 
1655             currSlot.startTimestamp = uint64(block.timestamp);
1656 
1657 
1658 
1659             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1660 
1661             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1662 
1663             uint256 nextTokenId = tokenId + 1;
1664 
1665             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1666 
1667             if (nextSlot.addr == address(0)) {
1668 
1669                 // This will suffice for checking _exists(nextTokenId),
1670 
1671                 // as a burned slot cannot contain the zero address.
1672 
1673                 if (nextTokenId != _currentIndex) {
1674 
1675                     nextSlot.addr = from;
1676 
1677                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1678 
1679                 }
1680 
1681             }
1682 
1683         }
1684 
1685 
1686 
1687         emit Transfer(from, to, tokenId);
1688 
1689         _afterTokenTransfers(from, to, tokenId, 1);
1690 
1691     }
1692 
1693 
1694 
1695     /**
1696 
1697      * @dev This is equivalent to _burn(tokenId, false)
1698 
1699      */
1700 
1701     function _burn(uint256 tokenId) internal virtual {
1702 
1703         _burn(tokenId, false);
1704 
1705     }
1706 
1707 
1708 
1709     /**
1710 
1711      * @dev Destroys `tokenId`.
1712 
1713      * The approval is cleared when the token is burned.
1714 
1715      *
1716 
1717      * Requirements:
1718 
1719      *
1720 
1721      * - `tokenId` must exist.
1722 
1723      *
1724 
1725      * Emits a {Transfer} event.
1726 
1727      */
1728 
1729     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1730 
1731         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1732 
1733 
1734 
1735         address from = prevOwnership.addr;
1736 
1737 
1738 
1739         if (approvalCheck) {
1740 
1741             bool isApprovedOrOwner = (_msgSender() == from ||
1742 
1743                 isApprovedForAll(from, _msgSender()) ||
1744 
1745                 getApproved(tokenId) == _msgSender());
1746 
1747 
1748 
1749             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1750 
1751         }
1752 
1753 
1754 
1755         _beforeTokenTransfers(from, address(0), tokenId, 1);
1756 
1757 
1758 
1759         // Clear approvals from the previous owner
1760 
1761         _approve(address(0), tokenId, from);
1762 
1763 
1764 
1765         // Underflow of the sender's balance is impossible because we check for
1766 
1767         // ownership above and the recipient's balance can't realistically overflow.
1768 
1769         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1770 
1771         unchecked {
1772 
1773             AddressData storage addressData = _addressData[from];
1774 
1775             addressData.balance -= 1;
1776 
1777             addressData.numberBurned += 1;
1778 
1779 
1780 
1781             // Keep track of who burned the token, and the timestamp of burning.
1782 
1783             TokenOwnership storage currSlot = _ownerships[tokenId];
1784 
1785             currSlot.addr = from;
1786 
1787             currSlot.startTimestamp = uint64(block.timestamp);
1788 
1789             currSlot.burned = true;
1790 
1791 
1792 
1793             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1794 
1795             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1796 
1797             uint256 nextTokenId = tokenId + 1;
1798 
1799             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1800 
1801             if (nextSlot.addr == address(0)) {
1802 
1803                 // This will suffice for checking _exists(nextTokenId),
1804 
1805                 // as a burned slot cannot contain the zero address.
1806 
1807                 if (nextTokenId != _currentIndex) {
1808 
1809                     nextSlot.addr = from;
1810 
1811                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1812 
1813                 }
1814 
1815             }
1816 
1817         }
1818 
1819 
1820 
1821         emit Transfer(from, address(0), tokenId);
1822 
1823         _afterTokenTransfers(from, address(0), tokenId, 1);
1824 
1825 
1826 
1827         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1828 
1829         unchecked {
1830 
1831             _burnCounter++;
1832 
1833         }
1834 
1835     }
1836 
1837 
1838 
1839     /**
1840 
1841      * @dev Approve `to` to operate on `tokenId`
1842 
1843      *
1844 
1845      * Emits a {Approval} event.
1846 
1847      */
1848 
1849     function _approve(
1850 
1851         address to,
1852 
1853         uint256 tokenId,
1854 
1855         address owner
1856 
1857     ) private {
1858 
1859         _tokenApprovals[tokenId] = to;
1860 
1861         emit Approval(owner, to, tokenId);
1862 
1863     }
1864 
1865 
1866 
1867     /**
1868 
1869      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1870 
1871      *
1872 
1873      * @param from address representing the previous owner of the given token ID
1874 
1875      * @param to target address that will receive the tokens
1876 
1877      * @param tokenId uint256 ID of the token to be transferred
1878 
1879      * @param _data bytes optional data to send along with the call
1880 
1881      * @return bool whether the call correctly returned the expected magic value
1882 
1883      */
1884 
1885     function _checkContractOnERC721Received(
1886 
1887         address from,
1888 
1889         address to,
1890 
1891         uint256 tokenId,
1892 
1893         bytes memory _data
1894 
1895     ) private returns (bool) {
1896 
1897         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1898 
1899             return retval == IERC721Receiver(to).onERC721Received.selector;
1900 
1901         } catch (bytes memory reason) {
1902 
1903             if (reason.length == 0) {
1904 
1905                 revert TransferToNonERC721ReceiverImplementer();
1906 
1907             } else {
1908 
1909                 assembly {
1910 
1911                     revert(add(32, reason), mload(reason))
1912 
1913                 }
1914 
1915             }
1916 
1917         }
1918 
1919     }
1920 
1921 
1922 
1923     /**
1924 
1925      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1926 
1927      * And also called before burning one token.
1928 
1929      *
1930 
1931      * startTokenId - the first token id to be transferred
1932 
1933      * quantity - the amount to be transferred
1934 
1935      *
1936 
1937      * Calling conditions:
1938 
1939      *
1940 
1941      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1942 
1943      * transferred to `to`.
1944 
1945      * - When `from` is zero, `tokenId` will be minted for `to`.
1946 
1947      * - When `to` is zero, `tokenId` will be burned by `from`.
1948 
1949      * - `from` and `to` are never both zero.
1950 
1951      */
1952 
1953     function _beforeTokenTransfers(
1954 
1955         address from,
1956 
1957         address to,
1958 
1959         uint256 startTokenId,
1960 
1961         uint256 quantity
1962 
1963     ) internal virtual {}
1964 
1965 
1966 
1967     /**
1968 
1969      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1970 
1971      * minting.
1972 
1973      * And also called after one token has been burned.
1974 
1975      *
1976 
1977      * startTokenId - the first token id to be transferred
1978 
1979      * quantity - the amount to be transferred
1980 
1981      *
1982 
1983      * Calling conditions:
1984 
1985      *
1986 
1987      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1988 
1989      * transferred to `to`.
1990 
1991      * - When `from` is zero, `tokenId` has been minted for `to`.
1992 
1993      * - When `to` is zero, `tokenId` has been burned by `from`.
1994 
1995      * - `from` and `to` are never both zero.
1996 
1997      */
1998 
1999     function _afterTokenTransfers(
2000 
2001         address from,
2002 
2003         address to,
2004 
2005         uint256 startTokenId,
2006 
2007         uint256 quantity
2008 
2009     ) internal virtual {}
2010 
2011 }
2012 // File: @openzeppelin/contracts/access/Ownable.sol
2013 
2014 
2015 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2016 
2017 pragma solidity ^0.8.0;
2018 
2019 
2020 /**
2021  * @dev Contract module which provides a basic access control mechanism, where
2022  * there is an account (an owner) that can be granted exclusive access to
2023  * specific functions.
2024  *
2025  * By default, the owner account will be the one that deploys the contract. This
2026  * can later be changed with {transferOwnership}.
2027  *
2028  * This module is used through inheritance. It will make available the modifier
2029  * `onlyOwner`, which can be applied to your functions to restrict their use to
2030  * the owner.
2031  */
2032 abstract contract Ownable is Context {
2033     address private _owner;
2034 
2035     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2036 
2037     /**
2038      * @dev Initializes the contract setting the deployer as the initial owner.
2039      */
2040     constructor() {
2041         _transferOwnership(_msgSender());
2042     }
2043 
2044     /**
2045      * @dev Returns the address of the current owner.
2046      */
2047     function owner() public view virtual returns (address) {
2048         return _owner;
2049     }
2050 
2051     /**
2052      * @dev Throws if called by any account other than the owner.
2053      */
2054     modifier onlyOwner() {
2055         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2056         _;
2057     }
2058 
2059     /**
2060      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2061      * Can only be called by the current owner.
2062      */
2063     function transferOwnership(address newOwner) public virtual onlyOwner {
2064         require(newOwner != address(0), "Ownable: new owner is the zero address");
2065         _transferOwnership(newOwner);
2066     }
2067 
2068     /**
2069      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2070      * Internal function without access restriction.
2071      */
2072     function _transferOwnership(address newOwner) internal virtual {
2073         address oldOwner = _owner;
2074         _owner = newOwner;
2075         emit OwnershipTransferred(oldOwner, newOwner);
2076     }
2077 }
2078 
2079 // File: contracts/contract.sol
2080 
2081 
2082 pragma solidity ^0.8.4;
2083 
2084 
2085 
2086 contract PersistenceofTime is Ownable, ERC721A, DefaultOperatorFilterer  {
2087 
2088     using Strings for uint256;
2089 
2090     string private baseTokenURI;
2091 
2092     uint256 public presaleCost = 0.01 ether;
2093     uint256 public publicSaleCost = 0.03 ether;
2094 
2095     uint64 public maxSupply = 777;
2096 
2097     uint64 public publicMaxSupply = 777;
2098     uint64 public publicTotalSupply = 0;
2099     uint64 public presaleMaxSupply = 333;
2100     uint64 public presaleTotalSupply = 0;
2101 
2102     uint64 public maxMintAmountPerPresaleAccount = 2;
2103     uint64 public maxMintAmountPerPublicAccount = 5;
2104 
2105     bool public presaleActive = false;
2106     bool public publicSaleActive = false;
2107 
2108     constructor() ERC721A("Persistence of Time by anon", "POT"){}
2109 
2110     modifier mintCompliance(uint256 _mintAmount) {
2111         require(_mintAmount > 0 , "Invalid mint amount!");
2112         require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
2113         _;
2114     }
2115 
2116     ///Mints NFTs for whitelist members during the presale
2117     function presaleMint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2118         require(presaleActive, "Presale is not Active");
2119 
2120         require(msg.value == presaleCost * _mintAmount, "Insufficient funds!");
2121         
2122         uint64 presaleAmountMintedPerAccount = getPresaleAmountMintedPerAccount(msg.sender);
2123         require(presaleAmountMintedPerAccount + _mintAmount <= maxMintAmountPerPresaleAccount, "Mint limit exceeded." );
2124         require(presaleTotalSupply + _mintAmount <= presaleMaxSupply, "Mint limit exceeded." );
2125 
2126         setPresaleAmountMintedPerAccount(msg.sender,presaleAmountMintedPerAccount + _mintAmount);
2127 
2128         presaleTotalSupply+=_mintAmount;
2129 
2130         _safeMint(msg.sender, _mintAmount);
2131     }
2132 
2133     ///Allows any address to mint when the public sale is open
2134     function publicMint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2135         require(publicSaleActive, "Public is not Active");
2136         require(tx.origin == msg.sender);
2137 
2138         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerPublicAccount, "Mint limit exceeded." );
2139         require(publicTotalSupply + _mintAmount <= publicMaxSupply, "Mint limit exceeded." );
2140         require(msg.value == publicSaleCost * _mintAmount, "Insufficient funds!");
2141 
2142 
2143         publicTotalSupply+=_mintAmount;
2144         _safeMint(msg.sender, _mintAmount);
2145     }
2146 
2147     ///Allows owner of the collection to airdrop a token to any address
2148     function ownerMint(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2149         _safeMint(_receiver, _mintAmount);
2150     }
2151 
2152     //@return token ids owned by an address in the collection
2153     function walletOfOwner(address _owner)
2154         external
2155         view
2156         returns (uint256[] memory)
2157     {
2158         uint256 ownerTokenCount = balanceOf(_owner);
2159         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2160         uint256 currentTokenId = 1;
2161         uint256 ownedTokenIndex = 0;
2162 
2163         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2164             if(exists(currentTokenId) == true) {
2165                 address currentTokenOwner = ownerOf(currentTokenId);
2166 
2167                 if (currentTokenOwner == _owner) {
2168                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
2169                     ownedTokenIndex++;
2170                 }
2171             }
2172             currentTokenId++;
2173         }
2174 
2175         return ownedTokenIds;
2176     }
2177 
2178     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2179         super.transferFrom(from, to, tokenId);
2180     }
2181 
2182     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2183         super.safeTransferFrom(from, to, tokenId);
2184     }
2185 
2186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2187         public
2188         override
2189         onlyAllowedOperator(from)
2190     {
2191         super.safeTransferFrom(from, to, tokenId, data);
2192     }
2193 
2194     //@return full url for passed in token id 
2195     function tokenURI(uint256 _tokenId)
2196 
2197         public
2198         view
2199         virtual
2200         override
2201         returns (string memory)
2202 
2203     {
2204 
2205         require(
2206         _exists(_tokenId),
2207         "ERC721Metadata: URI query for nonexistent token"
2208         );
2209 
2210         string memory currentBaseURI = _baseURI();
2211 
2212         return bytes(currentBaseURI).length > 0
2213 
2214             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2215 
2216             : "";
2217     }
2218 
2219 
2220 
2221     //@return amount an address has minted during the presale
2222     function getPresaleAmountMintedPerAccount(address _owner) public view returns (uint64) {
2223         return _getAux(_owner);
2224     }
2225 
2226     function setPresaleAmountMintedPerAccount(address _owner, uint64 _aux) internal {
2227         _setAux(_owner, _aux);
2228     }
2229 
2230 
2231     //@return amount an address has minted during all sales
2232     function numberMinted(address _owner) public view returns (uint256) {
2233         return _numberMinted(_owner);
2234     }
2235 
2236     //@return all NFT's minted including burned tokens
2237     function totalMinted() public view returns (uint256) {
2238         return _totalMinted();
2239     }
2240 
2241     function exists(uint256 _tokenId) public view returns (bool) {
2242         return _exists(_tokenId);
2243     }
2244 
2245     //@return url for the nft metadata
2246     function _baseURI() internal view virtual override returns (string memory) {
2247         return baseTokenURI;
2248     }
2249 
2250     function setBaseURI(string calldata _URI) external onlyOwner {
2251         baseTokenURI = _URI;
2252     }
2253     
2254     function setPresaleActive(bool _state) public onlyOwner {
2255         presaleActive = _state;
2256     }
2257 
2258     function setPublicActive(bool _state) public onlyOwner {
2259         publicSaleActive = _state;
2260     }
2261 
2262     function withdraw() public onlyOwner {
2263         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2264         require(os);
2265     }
2266 
2267     /// Fallbacks 
2268     receive() external payable { }
2269     fallback() external payable { }
2270 }