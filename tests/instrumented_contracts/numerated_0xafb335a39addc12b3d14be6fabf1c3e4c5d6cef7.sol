1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
10 
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     /**
16      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
17      *         true if supplied registrant address is not registered.
18      */
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(address registrant, address subscription) external;
30 
31     /**
32      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
33      *         address without subscribing.
34      */
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36 
37     /**
38      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
39      *         Note that this does not remove any filtered addresses or codeHashes.
40      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
41      */
42     function unregister(address addr) external;
43 
44     /**
45      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
46      */
47     function updateOperator(address registrant, address operator, bool filtered) external;
48 
49     /**
50      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
51      */
52     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
53 
54     /**
55      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
56      */
57     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
58 
59     /**
60      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
61      */
62     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
63 
64     /**
65      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
66      *         subscription if present.
67      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
68      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
69      *         used.
70      */
71     function subscribe(address registrant, address registrantToSubscribe) external;
72 
73     /**
74      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
75      */
76     function unsubscribe(address registrant, bool copyExistingEntries) external;
77 
78     /**
79      * @notice Get the subscription address of a given registrant, if any.
80      */
81     function subscriptionOf(address addr) external returns (address registrant);
82 
83     /**
84      * @notice Get the set of addresses subscribed to a given registrant.
85      *         Note that order is not guaranteed as updates are made.
86      */
87     function subscribers(address registrant) external returns (address[] memory);
88 
89     /**
90      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
91      *         Note that order is not guaranteed as updates are made.
92      */
93     function subscriberAt(address registrant, uint256 index) external returns (address);
94 
95     /**
96      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
97      */
98     function copyEntriesOf(address registrant, address registrantToCopy) external;
99 
100     /**
101      * @notice Returns true if operator is filtered by a given address or its subscription.
102      */
103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
104 
105     /**
106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
107      */
108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
109 
110     /**
111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
112      */
113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
114 
115     /**
116      * @notice Returns a list of filtered operators for a given address or its subscription.
117      */
118     function filteredOperators(address addr) external returns (address[] memory);
119 
120     /**
121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
122      *         Note that order is not guaranteed as updates are made.
123      */
124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
125 
126     /**
127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
128      *         its subscription.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
132 
133     /**
134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
135      *         its subscription.
136      *         Note that order is not guaranteed as updates are made.
137      */
138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
139 
140     /**
141      * @notice Returns true if an address has registered
142      */
143     function isRegistered(address addr) external returns (bool);
144 
145     /**
146      * @dev Convenience method to compute the code hash of an arbitrary contract
147      */
148     function codeHashOf(address addr) external returns (bytes32);
149 }
150 
151 // File: operator-filter-registry/src/OperatorFilterer.sol
152 
153 
154 pragma solidity ^0.8.13;
155 
156 
157 /**
158  * @title  OperatorFilterer
159  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
160  *         registrant's entries in the OperatorFilterRegistry.
161  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
162  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
163  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
164  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
165  *         administration methods on the contract itself to interact with the registry otherwise the subscription
166  *         will be locked to the options set during construction.
167  */
168 
169 abstract contract OperatorFilterer {
170     /// @dev Emitted when an operator is not allowed.
171     error OperatorNotAllowed(address operator);
172 
173     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
174         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
175 
176     /// @dev The constructor that is called when the contract is being deployed.
177     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
178         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
179         // will not revert, but the contract will need to be registered with the registry once it is deployed in
180         // order for the modifier to filter addresses.
181         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
182             if (subscribe) {
183                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
184             } else {
185                 if (subscriptionOrRegistrantToCopy != address(0)) {
186                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
187                 } else {
188                     OPERATOR_FILTER_REGISTRY.register(address(this));
189                 }
190             }
191         }
192     }
193 
194     /**
195      * @dev A helper function to check if an operator is allowed.
196      */
197     modifier onlyAllowedOperator(address from) virtual {
198         // Allow spending tokens from addresses with balance
199         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
200         // from an EOA.
201         if (from != msg.sender) {
202             _checkFilterOperator(msg.sender);
203         }
204         _;
205     }
206 
207     /**
208      * @dev A helper function to check if an operator approval is allowed.
209      */
210     modifier onlyAllowedOperatorApproval(address operator) virtual {
211         _checkFilterOperator(operator);
212         _;
213     }
214 
215     /**
216      * @dev A helper function to check if an operator is allowed.
217      */
218     function _checkFilterOperator(address operator) internal view virtual {
219         // Check registry code length to facilitate testing in environments without a deployed registry.
220         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
221             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
222             // may specify their own OperatorFilterRegistry implementations, which may behave differently
223             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
224                 revert OperatorNotAllowed(operator);
225             }
226         }
227     }
228 }
229 
230 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
231 
232 
233 pragma solidity ^0.8.13;
234 
235 
236 /**
237  * @title  DefaultOperatorFilterer
238  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
239  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
240  *         administration methods on the contract itself to interact with the registry otherwise the subscription
241  *         will be locked to the options set during construction.
242  */
243 
244 abstract contract DefaultOperatorFilterer is OperatorFilterer {
245     /// @dev The constructor that is called when the contract is being deployed.
246     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
247 }
248 
249 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Contract module that helps prevent reentrant calls to a function.
258  *
259  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
260  * available, which can be applied to functions to make sure there are no nested
261  * (reentrant) calls to them.
262  *
263  * Note that because there is a single `nonReentrant` guard, functions marked as
264  * `nonReentrant` may not call one another. This can be worked around by making
265  * those functions `private`, and then adding `external` `nonReentrant` entry
266  * points to them.
267  *
268  * TIP: If you would like to learn more about reentrancy and alternative ways
269  * to protect against it, check out our blog post
270  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
271  */
272 abstract contract ReentrancyGuard {
273     // Booleans are more expensive than uint256 or any type that takes up a full
274     // word because each write operation emits an extra SLOAD to first read the
275     // slot's contents, replace the bits taken up by the boolean, and then write
276     // back. This is the compiler's defense against contract upgrades and
277     // pointer aliasing, and it cannot be disabled.
278 
279     // The values being non-zero value makes deployment a bit more expensive,
280     // but in exchange the refund on every call to nonReentrant will be lower in
281     // amount. Since refunds are capped to a percentage of the total
282     // transaction's gas, it is best to keep them low in cases like this one, to
283     // increase the likelihood of the full refund coming into effect.
284     uint256 private constant _NOT_ENTERED = 1;
285     uint256 private constant _ENTERED = 2;
286 
287     uint256 private _status;
288 
289     constructor() {
290         _status = _NOT_ENTERED;
291     }
292 
293     /**
294      * @dev Prevents a contract from calling itself, directly or indirectly.
295      * Calling a `nonReentrant` function from another `nonReentrant`
296      * function is not supported. It is possible to prevent this from happening
297      * by making the `nonReentrant` function external, and making it call a
298      * `private` function that does the actual work.
299      */
300     modifier nonReentrant() {
301         // On the first call to nonReentrant, _notEntered will be true
302         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
303 
304         // Any calls to nonReentrant after this point will fail
305         _status = _ENTERED;
306 
307         _;
308 
309         // By storing the original value once again, a refund is triggered (see
310         // https://eips.ethereum.org/EIPS/eip-2200)
311         _status = _NOT_ENTERED;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev These functions deal with verification of Merkle Trees proofs.
324  *
325  * The proofs can be generated using the JavaScript library
326  * https://github.com/miguelmota/merkletreejs[merkletreejs].
327  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
328  *
329  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
330  */
331 library MerkleProof {
332     /**
333      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
334      * defined by `root`. For this, a `proof` must be provided, containing
335      * sibling hashes on the branch from the leaf to the root of the tree. Each
336      * pair of leaves and each pair of pre-images are assumed to be sorted.
337      */
338     function verify(
339         bytes32[] memory proof,
340         bytes32 root,
341         bytes32 leaf
342     ) internal pure returns (bool) {
343         return processProof(proof, leaf) == root;
344     }
345 
346     /**
347      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
348      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
349      * hash matches the root of the tree. When processing the proof, the pairs
350      * of leafs & pre-images are assumed to be sorted.
351      *
352      * _Available since v4.4._
353      */
354     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
355         bytes32 computedHash = leaf;
356         for (uint256 i = 0; i < proof.length; i++) {
357             bytes32 proofElement = proof[i];
358             if (computedHash <= proofElement) {
359                 // Hash(current computed hash + current element of the proof)
360                 computedHash = _efficientHash(computedHash, proofElement);
361             } else {
362                 // Hash(current element of the proof + current computed hash)
363                 computedHash = _efficientHash(proofElement, computedHash);
364             }
365         }
366         return computedHash;
367     }
368 
369     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
370         assembly {
371             mstore(0x00, a)
372             mstore(0x20, b)
373             value := keccak256(0x00, 0x40)
374         }
375     }
376 }
377 
378 // File: @openzeppelin/contracts/utils/Strings.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev String operations.
387  */
388 library Strings {
389     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
393      */
394     function toString(uint256 value) internal pure returns (string memory) {
395         // Inspired by OraclizeAPI's implementation - MIT licence
396         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
397 
398         if (value == 0) {
399             return "0";
400         }
401         uint256 temp = value;
402         uint256 digits;
403         while (temp != 0) {
404             digits++;
405             temp /= 10;
406         }
407         bytes memory buffer = new bytes(digits);
408         while (value != 0) {
409             digits -= 1;
410             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
411             value /= 10;
412         }
413         return string(buffer);
414     }
415 
416     /**
417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
418      */
419     function toHexString(uint256 value) internal pure returns (string memory) {
420         if (value == 0) {
421             return "0x00";
422         }
423         uint256 temp = value;
424         uint256 length = 0;
425         while (temp != 0) {
426             length++;
427             temp >>= 8;
428         }
429         return toHexString(value, length);
430     }
431 
432     /**
433      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
434      */
435     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
436         bytes memory buffer = new bytes(2 * length + 2);
437         buffer[0] = "0";
438         buffer[1] = "x";
439         for (uint256 i = 2 * length + 1; i > 1; --i) {
440             buffer[i] = _HEX_SYMBOLS[value & 0xf];
441             value >>= 4;
442         }
443         require(value == 0, "Strings: hex length insufficient");
444         return string(buffer);
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Context.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 abstract contract Context {
466     function _msgSender() internal view virtual returns (address) {
467         return msg.sender;
468     }
469 
470     function _msgData() internal view virtual returns (bytes calldata) {
471         return msg.data;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/access/Ownable.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Contract module which provides a basic access control mechanism, where
485  * there is an account (an owner) that can be granted exclusive access to
486  * specific functions.
487  *
488  * By default, the owner account will be the one that deploys the contract. This
489  * can later be changed with {transferOwnership}.
490  *
491  * This module is used through inheritance. It will make available the modifier
492  * `onlyOwner`, which can be applied to your functions to restrict their use to
493  * the owner.
494  */
495 abstract contract Ownable is Context {
496     address private _owner;
497 
498     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor() {
504         _transferOwnership(_msgSender());
505     }
506 
507     /**
508      * @dev Returns the address of the current owner.
509      */
510     function owner() public view virtual returns (address) {
511         return _owner;
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         require(owner() == _msgSender(), "Ownable: caller is not the owner");
519         _;
520     }
521 
522     /**
523      * @dev Leaves the contract without owner. It will not be possible to call
524      * `onlyOwner` functions anymore. Can only be called by the current owner.
525      *
526      * NOTE: Renouncing ownership will leave the contract without an owner,
527      * thereby removing any functionality that is only available to the owner.
528      */
529     function renounceOwnership() public virtual onlyOwner {
530         _transferOwnership(address(0));
531     }
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Can only be called by the current owner.
536      */
537     function transferOwnership(address newOwner) public virtual onlyOwner {
538         require(newOwner != address(0), "Ownable: new owner is the zero address");
539         _transferOwnership(newOwner);
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Internal function without access restriction.
545      */
546     function _transferOwnership(address newOwner) internal virtual {
547         address oldOwner = _owner;
548         _owner = newOwner;
549         emit OwnershipTransferred(oldOwner, newOwner);
550     }
551 }
552 
553 // File: @openzeppelin/contracts/utils/Address.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Collection of functions related to the address type
562  */
563 library Address {
564     /**
565      * @dev Returns true if `account` is a contract.
566      *
567      * [IMPORTANT]
568      * ====
569      * It is unsafe to assume that an address for which this function returns
570      * false is an externally-owned account (EOA) and not a contract.
571      *
572      * Among others, `isContract` will return false for the following
573      * types of addresses:
574      *
575      *  - an externally-owned account
576      *  - a contract in construction
577      *  - an address where a contract will be created
578      *  - an address where a contract lived, but was destroyed
579      * ====
580      */
581     function isContract(address account) internal view returns (bool) {
582         // This method relies on extcodesize, which returns 0 for contracts in
583         // construction, since the code is only stored at the end of the
584         // constructor execution.
585 
586         uint256 size;
587         assembly {
588             size := extcodesize(account)
589         }
590         return size > 0;
591     }
592 
593     /**
594      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
595      * `recipient`, forwarding all available gas and reverting on errors.
596      *
597      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
598      * of certain opcodes, possibly making contracts go over the 2300 gas limit
599      * imposed by `transfer`, making them unable to receive funds via
600      * `transfer`. {sendValue} removes this limitation.
601      *
602      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
603      *
604      * IMPORTANT: because control is transferred to `recipient`, care must be
605      * taken to not create reentrancy vulnerabilities. Consider using
606      * {ReentrancyGuard} or the
607      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
608      */
609     function sendValue(address payable recipient, uint256 amount) internal {
610         require(address(this).balance >= amount, "Address: insufficient balance");
611 
612         (bool success, ) = recipient.call{value: amount}("");
613         require(success, "Address: unable to send value, recipient may have reverted");
614     }
615 
616     /**
617      * @dev Performs a Solidity function call using a low level `call`. A
618      * plain `call` is an unsafe replacement for a function call: use this
619      * function instead.
620      *
621      * If `target` reverts with a revert reason, it is bubbled up by this
622      * function (like regular Solidity function calls).
623      *
624      * Returns the raw returned data. To convert to the expected return value,
625      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
626      *
627      * Requirements:
628      *
629      * - `target` must be a contract.
630      * - calling `target` with `data` must not revert.
631      *
632      * _Available since v3.1._
633      */
634     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
635         return functionCall(target, data, "Address: low-level call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
640      * `errorMessage` as a fallback revert reason when `target` reverts.
641      *
642      * _Available since v3.1._
643      */
644     function functionCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, 0, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but also transferring `value` wei to `target`.
655      *
656      * Requirements:
657      *
658      * - the calling contract must have an ETH balance of at least `value`.
659      * - the called Solidity function must be `payable`.
660      *
661      * _Available since v3.1._
662      */
663     function functionCallWithValue(
664         address target,
665         bytes memory data,
666         uint256 value
667     ) internal returns (bytes memory) {
668         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
673      * with `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(
678         address target,
679         bytes memory data,
680         uint256 value,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         require(address(this).balance >= value, "Address: insufficient balance for call");
684         require(isContract(target), "Address: call to non-contract");
685 
686         (bool success, bytes memory returndata) = target.call{value: value}(data);
687         return verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
692      * but performing a static call.
693      *
694      * _Available since v3.3._
695      */
696     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
697         return functionStaticCall(target, data, "Address: low-level static call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
702      * but performing a static call.
703      *
704      * _Available since v3.3._
705      */
706     function functionStaticCall(
707         address target,
708         bytes memory data,
709         string memory errorMessage
710     ) internal view returns (bytes memory) {
711         require(isContract(target), "Address: static call to non-contract");
712 
713         (bool success, bytes memory returndata) = target.staticcall(data);
714         return verifyCallResult(success, returndata, errorMessage);
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
719      * but performing a delegate call.
720      *
721      * _Available since v3.4._
722      */
723     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
724         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
729      * but performing a delegate call.
730      *
731      * _Available since v3.4._
732      */
733     function functionDelegateCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         require(isContract(target), "Address: delegate call to non-contract");
739 
740         (bool success, bytes memory returndata) = target.delegatecall(data);
741         return verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
746      * revert reason using the provided one.
747      *
748      * _Available since v4.3._
749      */
750     function verifyCallResult(
751         bool success,
752         bytes memory returndata,
753         string memory errorMessage
754     ) internal pure returns (bytes memory) {
755         if (success) {
756             return returndata;
757         } else {
758             // Look for revert reason and bubble it up if present
759             if (returndata.length > 0) {
760                 // The easiest way to bubble the revert reason is using memory via assembly
761 
762                 assembly {
763                     let returndata_size := mload(returndata)
764                     revert(add(32, returndata), returndata_size)
765                 }
766             } else {
767                 revert(errorMessage);
768             }
769         }
770     }
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @title ERC721 token receiver interface
782  * @dev Interface for any contract that wants to support safeTransfers
783  * from ERC721 asset contracts.
784  */
785 interface IERC721Receiver {
786     /**
787      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
788      * by `operator` from `from`, this function is called.
789      *
790      * It must return its Solidity selector to confirm the token transfer.
791      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
792      *
793      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
794      */
795     function onERC721Received(
796         address operator,
797         address from,
798         uint256 tokenId,
799         bytes calldata data
800     ) external returns (bytes4);
801 }
802 
803 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
804 
805 
806 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 /**
811  * @dev Interface of the ERC165 standard, as defined in the
812  * https://eips.ethereum.org/EIPS/eip-165[EIP].
813  *
814  * Implementers can declare support of contract interfaces, which can then be
815  * queried by others ({ERC165Checker}).
816  *
817  * For an implementation, see {ERC165}.
818  */
819 interface IERC165 {
820     /**
821      * @dev Returns true if this contract implements the interface defined by
822      * `interfaceId`. See the corresponding
823      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
824      * to learn more about how these ids are created.
825      *
826      * This function call must use less than 30 000 gas.
827      */
828     function supportsInterface(bytes4 interfaceId) external view returns (bool);
829 }
830 
831 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 
839 /**
840  * @dev Implementation of the {IERC165} interface.
841  *
842  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
843  * for the additional interface id that will be supported. For example:
844  *
845  * ```solidity
846  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
847  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
848  * }
849  * ```
850  *
851  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
852  */
853 abstract contract ERC165 is IERC165 {
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
858         return interfaceId == type(IERC165).interfaceId;
859     }
860 }
861 
862 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Required interface of an ERC721 compliant contract.
872  */
873 interface IERC721 is IERC165 {
874     /**
875      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
876      */
877     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
878 
879     /**
880      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
881      */
882     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
883 
884     /**
885      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
886      */
887     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
888 
889     /**
890      * @dev Returns the number of tokens in ``owner``'s account.
891      */
892     function balanceOf(address owner) external view returns (uint256 balance);
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) external view returns (address owner);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) external;
922 
923     /**
924      * @dev Transfers `tokenId` token from `from` to `to`.
925      *
926      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) external;
942 
943     /**
944      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
945      * The approval is cleared when the token is transferred.
946      *
947      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
948      *
949      * Requirements:
950      *
951      * - The caller must own the token or be an approved operator.
952      * - `tokenId` must exist.
953      *
954      * Emits an {Approval} event.
955      */
956     function approve(address to, uint256 tokenId) external;
957 
958     /**
959      * @dev Returns the account approved for `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function getApproved(uint256 tokenId) external view returns (address operator);
966 
967     /**
968      * @dev Approve or remove `operator` as an operator for the caller.
969      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
970      *
971      * Requirements:
972      *
973      * - The `operator` cannot be the caller.
974      *
975      * Emits an {ApprovalForAll} event.
976      */
977     function setApprovalForAll(address operator, bool _approved) external;
978 
979     /**
980      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
981      *
982      * See {setApprovalForAll}
983      */
984     function isApprovedForAll(address owner, address operator) external view returns (bool);
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes calldata data
1004     ) external;
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1017  * @dev See https://eips.ethereum.org/EIPS/eip-721
1018  */
1019 interface IERC721Metadata is IERC721 {
1020     /**
1021      * @dev Returns the token collection name.
1022      */
1023     function name() external view returns (string memory);
1024 
1025     /**
1026      * @dev Returns the token collection symbol.
1027      */
1028     function symbol() external view returns (string memory);
1029 
1030     /**
1031      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1032      */
1033     function tokenURI(uint256 tokenId) external view returns (string memory);
1034 }
1035 
1036 // File: erc721a/contracts/ERC721A.sol
1037 
1038 
1039 // Creator: Chiru Labs
1040 
1041 pragma solidity ^0.8.4;
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 
1050 error ApprovalCallerNotOwnerNorApproved();
1051 error ApprovalQueryForNonexistentToken();
1052 error ApproveToCaller();
1053 error ApprovalToCurrentOwner();
1054 error BalanceQueryForZeroAddress();
1055 error MintToZeroAddress();
1056 error MintZeroQuantity();
1057 error OwnerQueryForNonexistentToken();
1058 error TransferCallerNotOwnerNorApproved();
1059 error TransferFromIncorrectOwner();
1060 error TransferToNonERC721ReceiverImplementer();
1061 error TransferToZeroAddress();
1062 error URIQueryForNonexistentToken();
1063 
1064 /**
1065  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1066  * the Metadata extension. Built to optimize for lower gas during batch mints.
1067  *
1068  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1069  *
1070  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1071  *
1072  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1073  */
1074 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1075     using Address for address;
1076     using Strings for uint256;
1077 
1078     // Compiler will pack this into a single 256bit word.
1079     struct TokenOwnership {
1080         // The address of the owner.
1081         address addr;
1082         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1083         uint64 startTimestamp;
1084         // Whether the token has been burned.
1085         bool burned;
1086     }
1087 
1088     // Compiler will pack this into a single 256bit word.
1089     struct AddressData {
1090         // Realistically, 2**64-1 is more than enough.
1091         uint64 balance;
1092         // Keeps track of mint count with minimal overhead for tokenomics.
1093         uint64 numberMinted;
1094         // Keeps track of burn count with minimal overhead for tokenomics.
1095         uint64 numberBurned;
1096         // For miscellaneous variable(s) pertaining to the address
1097         // (e.g. number of whitelist mint slots used).
1098         // If there are multiple variables, please pack them into a uint64.
1099         uint64 aux;
1100     }
1101 
1102     // The tokenId of the next token to be minted.
1103     uint256 internal _currentIndex;
1104 
1105     // The number of tokens burned.
1106     uint256 internal _burnCounter;
1107 
1108     // Token name
1109     string private _name;
1110 
1111     // Token symbol
1112     string private _symbol;
1113 
1114     // Mapping from token ID to ownership details
1115     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1116     mapping(uint256 => TokenOwnership) internal _ownerships;
1117 
1118     // Mapping owner address to address data
1119     mapping(address => AddressData) private _addressData;
1120 
1121     // Mapping from token ID to approved address
1122     mapping(uint256 => address) private _tokenApprovals;
1123 
1124     // Mapping from owner to operator approvals
1125     mapping(address => mapping(address => bool)) private _operatorApprovals;
1126 
1127     constructor(string memory name_, string memory symbol_) {
1128         _name = name_;
1129         _symbol = symbol_;
1130         _currentIndex = _startTokenId();
1131     }
1132 
1133     /**
1134      * To change the starting tokenId, please override this function.
1135      */
1136     function _startTokenId() internal view virtual returns (uint256) {
1137         return 0;
1138     }
1139 
1140     /**
1141      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1142      */
1143     function totalSupply() public view returns (uint256) {
1144         // Counter underflow is impossible as _burnCounter cannot be incremented
1145         // more than _currentIndex - _startTokenId() times
1146         unchecked {
1147             return _currentIndex - _burnCounter - _startTokenId();
1148         }
1149     }
1150 
1151     /**
1152      * Returns the total amount of tokens minted in the contract.
1153      */
1154     function _totalMinted() internal view returns (uint256) {
1155         // Counter underflow is impossible as _currentIndex does not decrement,
1156         // and it is initialized to _startTokenId()
1157         unchecked {
1158             return _currentIndex - _startTokenId();
1159         }
1160     }
1161 
1162     /**
1163      * @dev See {IERC165-supportsInterface}.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1166         return
1167             interfaceId == type(IERC721).interfaceId ||
1168             interfaceId == type(IERC721Metadata).interfaceId ||
1169             super.supportsInterface(interfaceId);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-balanceOf}.
1174      */
1175     function balanceOf(address owner) public view override returns (uint256) {
1176         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1177         return uint256(_addressData[owner].balance);
1178     }
1179 
1180     /**
1181      * Returns the number of tokens minted by `owner`.
1182      */
1183     function _numberMinted(address owner) internal view returns (uint256) {
1184         return uint256(_addressData[owner].numberMinted);
1185     }
1186 
1187     /**
1188      * Returns the number of tokens burned by or on behalf of `owner`.
1189      */
1190     function _numberBurned(address owner) internal view returns (uint256) {
1191         return uint256(_addressData[owner].numberBurned);
1192     }
1193 
1194     /**
1195      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1196      */
1197     function _getAux(address owner) internal view returns (uint64) {
1198         return _addressData[owner].aux;
1199     }
1200 
1201     /**
1202      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1203      * If there are multiple variables, please pack them into a uint64.
1204      */
1205     function _setAux(address owner, uint64 aux) internal {
1206         _addressData[owner].aux = aux;
1207     }
1208 
1209     /**
1210      * Gas spent here starts off proportional to the maximum mint batch size.
1211      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1212      */
1213     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1214         uint256 curr = tokenId;
1215 
1216         unchecked {
1217             if (_startTokenId() <= curr && curr < _currentIndex) {
1218                 TokenOwnership memory ownership = _ownerships[curr];
1219                 if (!ownership.burned) {
1220                     if (ownership.addr != address(0)) {
1221                         return ownership;
1222                     }
1223                     // Invariant:
1224                     // There will always be an ownership that has an address and is not burned
1225                     // before an ownership that does not have an address and is not burned.
1226                     // Hence, curr will not underflow.
1227                     while (true) {
1228                         curr--;
1229                         ownership = _ownerships[curr];
1230                         if (ownership.addr != address(0)) {
1231                             return ownership;
1232                         }
1233                     }
1234                 }
1235             }
1236         }
1237         revert OwnerQueryForNonexistentToken();
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-ownerOf}.
1242      */
1243     function ownerOf(uint256 tokenId) public view override returns (address) {
1244         return _ownershipOf(tokenId).addr;
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Metadata-name}.
1249      */
1250     function name() public view virtual override returns (string memory) {
1251         return _name;
1252     }
1253 
1254     /**
1255      * @dev See {IERC721Metadata-symbol}.
1256      */
1257     function symbol() public view virtual override returns (string memory) {
1258         return _symbol;
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Metadata-tokenURI}.
1263      */
1264     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1265         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1266 
1267         string memory baseURI = _baseURI();
1268         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1269     }
1270 
1271     /**
1272      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1273      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1274      * by default, can be overriden in child contracts.
1275      */
1276     function _baseURI() internal view virtual returns (string memory) {
1277         return '';
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-approve}.
1282      */
1283     function approve(address to, uint256 tokenId) public virtual override {
1284         address owner = ERC721A.ownerOf(tokenId);
1285         if (to == owner) revert ApprovalToCurrentOwner();
1286 
1287         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1288             revert ApprovalCallerNotOwnerNorApproved();
1289         }
1290 
1291         _approve(to, tokenId, owner);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721-getApproved}.
1296      */
1297     function getApproved(uint256 tokenId) public view override returns (address) {
1298         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1299 
1300         return _tokenApprovals[tokenId];
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-setApprovalForAll}.
1305      */
1306     function setApprovalForAll(address operator, bool approved) public virtual override {
1307         if (operator == _msgSender()) revert ApproveToCaller();
1308 
1309         _operatorApprovals[_msgSender()][operator] = approved;
1310         emit ApprovalForAll(_msgSender(), operator, approved);
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-isApprovedForAll}.
1315      */
1316     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1317         return _operatorApprovals[owner][operator];
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-transferFrom}.
1322      */
1323     function transferFrom(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) public virtual override {
1328         _transfer(from, to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-safeTransferFrom}.
1333      */
1334     function safeTransferFrom(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) public virtual override {
1339         safeTransferFrom(from, to, tokenId, '');
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-safeTransferFrom}.
1344      */
1345     function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId,
1349         bytes memory _data
1350     ) public virtual override {
1351         _transfer(from, to, tokenId);
1352         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1353             revert TransferToNonERC721ReceiverImplementer();
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns whether `tokenId` exists.
1359      *
1360      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1361      *
1362      * Tokens start existing when they are minted (`_mint`),
1363      */
1364     function _exists(uint256 tokenId) internal view returns (bool) {
1365         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1366     }
1367 
1368     function _safeMint(address to, uint256 quantity) internal {
1369         _safeMint(to, quantity, '');
1370     }
1371 
1372     /**
1373      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1378      * - `quantity` must be greater than 0.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeMint(
1383         address to,
1384         uint256 quantity,
1385         bytes memory _data
1386     ) internal {
1387         _mint(to, quantity, _data, true);
1388     }
1389 
1390     /**
1391      * @dev Mints `quantity` tokens and transfers them to `to`.
1392      *
1393      * Requirements:
1394      *
1395      * - `to` cannot be the zero address.
1396      * - `quantity` must be greater than 0.
1397      *
1398      * Emits a {Transfer} event.
1399      */
1400     function _mint(
1401         address to,
1402         uint256 quantity,
1403         bytes memory _data,
1404         bool safe
1405     ) internal {
1406         uint256 startTokenId = _currentIndex;
1407         if (to == address(0)) revert MintToZeroAddress();
1408         if (quantity == 0) revert MintZeroQuantity();
1409 
1410         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1411 
1412         // Overflows are incredibly unrealistic.
1413         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1414         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1415         unchecked {
1416             _addressData[to].balance += uint64(quantity);
1417             _addressData[to].numberMinted += uint64(quantity);
1418 
1419             _ownerships[startTokenId].addr = to;
1420             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1421 
1422             uint256 updatedIndex = startTokenId;
1423             uint256 end = updatedIndex + quantity;
1424 
1425             if (safe && to.isContract()) {
1426                 do {
1427                     emit Transfer(address(0), to, updatedIndex);
1428                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1429                         revert TransferToNonERC721ReceiverImplementer();
1430                     }
1431                 } while (updatedIndex != end);
1432                 // Reentrancy protection
1433                 if (_currentIndex != startTokenId) revert();
1434             } else {
1435                 do {
1436                     emit Transfer(address(0), to, updatedIndex++);
1437                 } while (updatedIndex != end);
1438             }
1439             _currentIndex = updatedIndex;
1440         }
1441         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1442     }
1443 
1444     /**
1445      * @dev Transfers `tokenId` from `from` to `to`.
1446      *
1447      * Requirements:
1448      *
1449      * - `to` cannot be the zero address.
1450      * - `tokenId` token must be owned by `from`.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _transfer(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) private {
1459         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1460 
1461         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1462 
1463         bool isApprovedOrOwner = (_msgSender() == from ||
1464             isApprovedForAll(from, _msgSender()) ||
1465             getApproved(tokenId) == _msgSender());
1466 
1467         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1468         if (to == address(0)) revert TransferToZeroAddress();
1469 
1470         _beforeTokenTransfers(from, to, tokenId, 1);
1471 
1472         // Clear approvals from the previous owner
1473         _approve(address(0), tokenId, from);
1474 
1475         // Underflow of the sender's balance is impossible because we check for
1476         // ownership above and the recipient's balance can't realistically overflow.
1477         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1478         unchecked {
1479             _addressData[from].balance -= 1;
1480             _addressData[to].balance += 1;
1481 
1482             TokenOwnership storage currSlot = _ownerships[tokenId];
1483             currSlot.addr = to;
1484             currSlot.startTimestamp = uint64(block.timestamp);
1485 
1486             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1487             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1488             uint256 nextTokenId = tokenId + 1;
1489             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1490             if (nextSlot.addr == address(0)) {
1491                 // This will suffice for checking _exists(nextTokenId),
1492                 // as a burned slot cannot contain the zero address.
1493                 if (nextTokenId != _currentIndex) {
1494                     nextSlot.addr = from;
1495                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1496                 }
1497             }
1498         }
1499 
1500         emit Transfer(from, to, tokenId);
1501         _afterTokenTransfers(from, to, tokenId, 1);
1502     }
1503 
1504     /**
1505      * @dev This is equivalent to _burn(tokenId, false)
1506      */
1507     function _burn(uint256 tokenId) internal virtual {
1508         _burn(tokenId, false);
1509     }
1510 
1511     /**
1512      * @dev Destroys `tokenId`.
1513      * The approval is cleared when the token is burned.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1522         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1523 
1524         address from = prevOwnership.addr;
1525 
1526         if (approvalCheck) {
1527             bool isApprovedOrOwner = (_msgSender() == from ||
1528                 isApprovedForAll(from, _msgSender()) ||
1529                 getApproved(tokenId) == _msgSender());
1530 
1531             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1532         }
1533 
1534         _beforeTokenTransfers(from, address(0), tokenId, 1);
1535 
1536         // Clear approvals from the previous owner
1537         _approve(address(0), tokenId, from);
1538 
1539         // Underflow of the sender's balance is impossible because we check for
1540         // ownership above and the recipient's balance can't realistically overflow.
1541         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1542         unchecked {
1543             AddressData storage addressData = _addressData[from];
1544             addressData.balance -= 1;
1545             addressData.numberBurned += 1;
1546 
1547             // Keep track of who burned the token, and the timestamp of burning.
1548             TokenOwnership storage currSlot = _ownerships[tokenId];
1549             currSlot.addr = from;
1550             currSlot.startTimestamp = uint64(block.timestamp);
1551             currSlot.burned = true;
1552 
1553             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1554             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1555             uint256 nextTokenId = tokenId + 1;
1556             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1557             if (nextSlot.addr == address(0)) {
1558                 // This will suffice for checking _exists(nextTokenId),
1559                 // as a burned slot cannot contain the zero address.
1560                 if (nextTokenId != _currentIndex) {
1561                     nextSlot.addr = from;
1562                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1563                 }
1564             }
1565         }
1566 
1567         emit Transfer(from, address(0), tokenId);
1568         _afterTokenTransfers(from, address(0), tokenId, 1);
1569 
1570         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1571         unchecked {
1572             _burnCounter++;
1573         }
1574     }
1575 
1576     /**
1577      * @dev Approve `to` to operate on `tokenId`
1578      *
1579      * Emits a {Approval} event.
1580      */
1581     function _approve(
1582         address to,
1583         uint256 tokenId,
1584         address owner
1585     ) private {
1586         _tokenApprovals[tokenId] = to;
1587         emit Approval(owner, to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1592      *
1593      * @param from address representing the previous owner of the given token ID
1594      * @param to target address that will receive the tokens
1595      * @param tokenId uint256 ID of the token to be transferred
1596      * @param _data bytes optional data to send along with the call
1597      * @return bool whether the call correctly returned the expected magic value
1598      */
1599     function _checkContractOnERC721Received(
1600         address from,
1601         address to,
1602         uint256 tokenId,
1603         bytes memory _data
1604     ) private returns (bool) {
1605         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1606             return retval == IERC721Receiver(to).onERC721Received.selector;
1607         } catch (bytes memory reason) {
1608             if (reason.length == 0) {
1609                 revert TransferToNonERC721ReceiverImplementer();
1610             } else {
1611                 assembly {
1612                     revert(add(32, reason), mload(reason))
1613                 }
1614             }
1615         }
1616     }
1617 
1618     /**
1619      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1620      * And also called before burning one token.
1621      *
1622      * startTokenId - the first token id to be transferred
1623      * quantity - the amount to be transferred
1624      *
1625      * Calling conditions:
1626      *
1627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1628      * transferred to `to`.
1629      * - When `from` is zero, `tokenId` will be minted for `to`.
1630      * - When `to` is zero, `tokenId` will be burned by `from`.
1631      * - `from` and `to` are never both zero.
1632      */
1633     function _beforeTokenTransfers(
1634         address from,
1635         address to,
1636         uint256 startTokenId,
1637         uint256 quantity
1638     ) internal virtual {}
1639 
1640     /**
1641      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1642      * minting.
1643      * And also called after one token has been burned.
1644      *
1645      * startTokenId - the first token id to be transferred
1646      * quantity - the amount to be transferred
1647      *
1648      * Calling conditions:
1649      *
1650      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1651      * transferred to `to`.
1652      * - When `from` is zero, `tokenId` has been minted for `to`.
1653      * - When `to` is zero, `tokenId` has been burned by `from`.
1654      * - `from` and `to` are never both zero.
1655      */
1656     function _afterTokenTransfers(
1657         address from,
1658         address to,
1659         uint256 startTokenId,
1660         uint256 quantity
1661     ) internal virtual {}
1662 }
1663 
1664 // File: contracts/FucContract/fuc.sol
1665 
1666 
1667 
1668 pragma solidity ^0.8.17;
1669 
1670 
1671 
1672 
1673 
1674 
1675 /////////////////////////////////////////////////////////////////////////////
1676 //                                                                         //
1677 //                                                                         //
1678 //    ░░░░░░░░░█████████░░░░░░░░░██░░░░░░██░░░░░░░░░░░░░█████████░░░░░░    //
1679 //    ░░░░░░░░░██░░░░░░░░░░░░░░░░██░░░░░░██░░░░░░░░░░░██░░░░░░░░░░░░░░░    //
1680 //    ░░░░░░░░░█████████░░░░░░░░░██░░░░░░██░░░░░░░░░░░██░░░░░░░░░░░░░░░    //
1681 //    ░░░░░░░░░██░░░░░░░░░░░░░░░░██░░░░░░██░░░░░░░░░░░██░░░░░░░░░░░░░░░    //
1682 //    ░░░░░░░░░██░░░░░░░░░░░░░░░░██░░░░░░██░░░░░░░░░░░██░░░░░░░░░░░░░░░    //
1683 //    ░░░░░░░░░██░░░░░░░░░░░░░░░░██████████░░░░░░░░░░░░░█████████░░░░░░    //
1684 //                                                                         //
1685 //                                                                         //
1686 /////////////////////////////////////////////////////////////////////////////
1687 
1688 contract Fuc is ERC721A, Ownable, ReentrancyGuard ,DefaultOperatorFilterer{
1689 
1690     string public baseUri;
1691 
1692     bool public paused = false;
1693 
1694     string public contractURI;
1695 
1696     uint64 public count = 7777;
1697 
1698     mapping(uint8 => uint8) public tokenLimit;
1699 
1700     mapping(uint8 => uint256) public priceType;
1701 
1702     mapping(uint8 => bytes32) public rootType;
1703 
1704     mapping(uint8 => bool) public levelStatu;
1705 
1706     mapping(address => bool)  public marketPlace;
1707 
1708     address private withdrawAddress;
1709 
1710     TimeConfig public timeConfig;
1711 
1712     constructor(
1713         string memory _tokenName,
1714         string memory _tokenSymbol,
1715         string memory _baseUri,
1716         string memory _contractURI,
1717         address _address
1718     ) ERC721A(_tokenName, _tokenSymbol) {
1719         baseUri = _baseUri;
1720         contractURI = _contractURI;
1721         withdrawAddress = _address;
1722     }
1723 
1724     struct TimeConfig {
1725         uint256 partnerStartTime;
1726         uint256 partnerEndTime;
1727         uint256 fucthelistStartTime;
1728         uint256 fucthelistEndTime;
1729         uint256 whitelistStartTime;
1730         uint256 whitelistEndTime;
1731     }
1732     //--------add--------
1733     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1734         require(marketPlace[operator] == true, "Not allowed");
1735         super.setApprovalForAll(operator, approved);
1736     }
1737 
1738     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1739         require(marketPlace[operator] == true, "Not allowed");
1740         super.approve(operator, tokenId);
1741     }
1742 
1743     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1744         super.transferFrom(from, to, tokenId);
1745     }
1746 
1747     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1748         super.safeTransferFrom(from, to, tokenId);
1749     }
1750 
1751     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1752         public
1753         override
1754         onlyAllowedOperator(from)
1755     {
1756         super.safeTransferFrom(from, to, tokenId, data);
1757     }
1758     //--------add--------
1759     function setAllowMarket(address market) public onlyOwner{
1760         marketPlace[market] = true;
1761     }
1762 
1763     modifier onlyAccounts() {
1764         require(msg.sender == tx.origin, "Not allowed origin");
1765         _;
1766     }
1767 
1768     modifier fucStatus() {
1769         require(paused == true, "Sale not started");
1770         _;
1771     }
1772 
1773     function setLevelStatu(uint8 ltype , bool status) public onlyOwner{
1774         require(ltype <= 3,"Type error");
1775         for (uint8 i = 0; i <= 3; i++) {
1776             levelStatu[i] = false;
1777         }
1778         levelStatu[ltype-1] = status;
1779     }
1780 
1781     function setPausedStatu() public onlyOwner{
1782         paused = !paused;
1783     }
1784     /**
1785      * method setTokenLimit
1786      * param detail
1787      * ttype == 1 set partner token limit 
1788      * ttype == 2 set fucthelist token limit 
1789      * ttype == 3 set whitelist token limit 
1790      * ttype == 4 set open token limit
1791      */
1792     function setTokenLimit(uint8 _account , uint8 ttype) public onlyOwner fucStatus{
1793         require(ttype <= 4 && _account < 10,"Param error");
1794         // require(_account < 10,"Upper limit exceeded");
1795         tokenLimit[ttype-1] = _account;
1796     }
1797 
1798     /**
1799      * method setTime
1800      * param detail
1801      * timeType == 1 set partner time
1802      * timeType == 2 set fucthelist time 
1803      * timeType == 3 set whitelist time
1804      */
1805     function setTime(uint256 startTime , uint256 endTime ,int8 timeType) public onlyOwner fucStatus{
1806         // require(timeType <= 3,"Type error");
1807         if(timeType == 1){
1808             timeConfig.partnerStartTime = startTime;
1809             timeConfig.partnerEndTime = endTime;
1810         }
1811         if(timeType == 2) {
1812             timeConfig.fucthelistStartTime = startTime;
1813             timeConfig.fucthelistEndTime = endTime;
1814         }
1815 
1816         if(timeType == 3) {
1817             timeConfig.whitelistStartTime = startTime;
1818             timeConfig.whitelistEndTime = endTime;
1819         }
1820     }
1821     /**
1822      * method setPrice
1823      * param detail
1824      * ptype == 1 set partner token price 
1825      * ptype == 2 set fucthelist token price 
1826      * ptype == 3 set whitelist token price 
1827      * ptype == 4 set open token price 
1828      */
1829     function setPrice(uint256 price , uint8 ptype) public onlyOwner fucStatus{
1830         require(ptype <= 4,"Type error");
1831         priceType[ptype - 1] = price;
1832     }
1833 
1834     /**
1835      * method setRoot
1836      * param detail
1837      * rtype == 1 set partner merkleRoot
1838      * rtype == 2 set fucthelist merkleRoot 
1839      * rtype == 3 set whitelist merkleRoot
1840      */
1841     function setRoot(bytes32 _root , uint8 rtype) public onlyOwner {
1842         require(rtype <= 3,"Type error");
1843         rootType[rtype - 1] = _root;
1844     }
1845 
1846     function isValid(bytes32[] memory proof ,bytes32 _root) internal view returns (bool) {
1847         return MerkleProof.verify(proof, _root ,keccak256(abi.encodePacked(msg.sender)));
1848     }
1849 
1850     function SafeMint(uint8 amount , bytes32[] memory proof) external payable fucStatus onlyAccounts {
1851         require(amount > 0 && amount <= 6, "Amount must in 0-6");
1852         uint64 aux = _getAux(msg.sender);
1853         if(levelStatu[0] == true) {
1854             require(block.timestamp >= timeConfig.partnerStartTime && block.timestamp <= timeConfig.partnerEndTime && priceType[0] > 0,"sale not started");
1855             require(msg.value >= priceType[0] * amount, "Insufficient funds!");
1856             require(isValid(proof ,rootType[0]), "Not Allowlist");
1857             require(amount + _numberMinted(msg.sender) <= tokenLimit[0], "Upper limit exceeded");
1858             _setAux(msg.sender, aux + amount);
1859         } else if(levelStatu[1] == true) {
1860             require(block.timestamp >= timeConfig.fucthelistStartTime && block.timestamp <= timeConfig.fucthelistEndTime && priceType[1] > 0  ,"sale not started");
1861             require(msg.value >= priceType[1] * amount, "Insufficient funds!");
1862             if(aux < 10) {
1863                 aux = 10;
1864             }
1865             require(aux + amount - 10 <= tokenLimit[1], "Upper limit exceeded");
1866             require(isValid(proof ,rootType[1]), "Not Allowlist");
1867             setAux(1,msg.sender, amount , aux);
1868         } else if(levelStatu[2] == true) {
1869             require(block.timestamp >= timeConfig.whitelistStartTime && block.timestamp <= timeConfig.whitelistEndTime && priceType[2] > 0  ,"sale not started");
1870             require(msg.value >= priceType[2] * amount, "Insufficient funds!");
1871             if(aux < 20) {
1872                 aux = 20;
1873             }
1874             require(aux + amount - 20 <= tokenLimit[2], "Upper limit exceeded");
1875             require(isValid(proof ,rootType[2]), "Not Allowlist");
1876             setAux(2,msg.sender, amount, aux);
1877         } else {
1878             require(block.timestamp > timeConfig.whitelistEndTime && timeConfig.whitelistEndTime != 0 ,"sale not started") ;
1879             if(aux < 30) {
1880                 aux = 30;
1881             }
1882             require(aux + amount - 30 <= tokenLimit[3], "Upper limit exceeded");
1883             require(priceType[3] > 0 && msg.value >= priceType[3] * amount , "Insufficient funds!");
1884             setAux(3,msg.sender, amount, aux);
1885         }
1886         count = count - amount;
1887         require(count >= 0, "count out of range");
1888         
1889         _safeMint(msg.sender, amount);
1890     }
1891 
1892     //  function geTime() public view returns(uint256){
1893     //     return block.timestamp;
1894     // }
1895 
1896     function setAux(uint8 ctype , address ads , uint8 amount ,uint64 aux) private {
1897         if(ctype == aux/10){
1898             _setAux(ads, aux + amount);
1899         }
1900     }
1901 
1902     function getAux(address owner) public view returns(uint64){
1903         return _getAux(owner);
1904     }
1905 
1906     function getPrice() public view returns(uint256, uint8){
1907         uint256 _price;
1908         uint8 _type;
1909         if(levelStatu[0] == true) {
1910             _price = priceType[0];
1911             _type = 1;
1912         } else if(levelStatu[1] == true) {
1913             _price = priceType[1];
1914             _type = 2;
1915         } else if(levelStatu[2] == true) {
1916             _price = priceType[2];
1917             _type = 3;
1918         } else {
1919             _price = priceType[3];
1920             _type = 4;
1921         }
1922         return (_price , _type);
1923     }
1924 
1925     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1926         require(_exists(tokenId) && bytes(baseUri).length > 0, "Metadata: nonexistent token");
1927         // require(bytes(baseUri).length > 0, "no set baseUri");
1928         return string(abi.encodePacked(baseUri, Strings.toString(tokenId), ".json"));
1929     }
1930 
1931     function changeBaseURI(string memory baseURI_) public onlyOwner fucStatus {
1932         baseUri = baseURI_;
1933     }
1934     
1935     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1936         uint256 ownerTokenCount = balanceOf(_owner);
1937         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1938         uint256 currentTokenId = _startTokenId();
1939         uint256 ownedTokenIndex = 0;
1940         address latestOwnerAddress;
1941 
1942         while (ownedTokenIndex < ownerTokenCount) {
1943             TokenOwnership memory ownership = _ownerships[currentTokenId];
1944 
1945             if (!ownership.burned && ownership.addr != address(0)) {
1946                 latestOwnerAddress = ownership.addr; 
1947             }
1948 
1949             if (latestOwnerAddress == _owner) {
1950                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1951 
1952                 ownedTokenIndex++;
1953             }
1954 
1955             currentTokenId++;
1956         }
1957 
1958         return ownedTokenIds;
1959     }
1960     
1961     function withdrawMoney() external nonReentrant onlyAccounts {
1962         require(msg.sender == withdrawAddress, "Not allowed origin");
1963         (bool success, ) = withdrawAddress.call{value: address(this).balance}("");
1964         require(success, "Transfer failed.");
1965     }
1966 
1967 }