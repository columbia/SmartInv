1 // File: contracts/lib/Constants.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.19;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: contracts/IOperatorFilterRegistry.sol
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
151 // File: contracts/OperatorFilterer.sol
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
230 // File: contracts/DefaultOperatorFilterer.sol
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
249 // File: contracts/FixeArt.sol
250 
251 /**
252  *Submitted for verification at Etherscan.io on 2022-09-13
253 */
254 
255 // File: @openzeppelin/contracts/utils/Strings.sol
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
258 // Developed by https://transcendnt.io
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev String operations.
264  */
265 library Strings {
266     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
270      */
271     function toString(uint256 value) internal pure returns (string memory) {
272         // Inspired by OraclizeAPI's implementation - MIT licence
273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
274 
275         if (value == 0) {
276             return "0";
277         }
278         uint256 temp = value;
279         uint256 digits;
280         while (temp != 0) {
281             digits++;
282             temp /= 10;
283         }
284         bytes memory buffer = new bytes(digits);
285         while (value != 0) {
286             digits -= 1;
287             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
288             value /= 10;
289         }
290         return string(buffer);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
295      */
296     function toHexString(uint256 value) internal pure returns (string memory) {
297         if (value == 0) {
298             return "0x00";
299         }
300         uint256 temp = value;
301         uint256 length = 0;
302         while (temp != 0) {
303             length++;
304             temp >>= 8;
305         }
306         return toHexString(value, length);
307     }
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
311      */
312     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
313         bytes memory buffer = new bytes(2 * length + 2);
314         buffer[0] = "0";
315         buffer[1] = "x";
316         for (uint256 i = 2 * length + 1; i > 1; --i) {
317             buffer[i] = _HEX_SYMBOLS[value & 0xf];
318             value >>= 4;
319         }
320         require(value == 0, "Strings: hex length insufficient");
321         return string(buffer);
322     }
323 }
324 
325 // File: @openzeppelin/contracts/utils/Context.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Provides information about the current execution context, including the
334  * sender of the transaction and its data. While these are generally available
335  * via msg.sender and msg.data, they should not be accessed in such a direct
336  * manner, since when dealing with meta-transactions the account sending and
337  * paying for execution may not be the actual sender (as far as an application
338  * is concerned).
339  *
340  * This contract is only required for intermediate, library-like contracts.
341  */
342 abstract contract Context {
343     function _msgSender() internal view virtual returns (address) {
344         return msg.sender;
345     }
346 
347     function _msgData() internal view virtual returns (bytes calldata) {
348         return msg.data;
349     }
350 }
351 
352 // File: @openzeppelin/contracts/access/Ownable.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Contract module which provides a basic access control mechanism, where
362  * there is an account (an owner) that can be granted exclusive access to
363  * specific functions.
364  *
365  * By default, the owner account will be the one that deploys the contract. This
366  * can later be changed with {transferOwnership}.
367  *
368  * This module is used through inheritance. It will make available the modifier
369  * `onlyOwner`, which can be applied to your functions to restrict their use to
370  * the owner.
371  */
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377     /**
378      * @dev Initializes the contract setting the deployer as the initial owner.
379      */
380     constructor() {
381         _transferOwnership(_msgSender());
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view virtual returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if called by any account other than the owner.
393      */
394     modifier onlyOwner() {
395         require(owner() == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         _transferOwnership(address(0));
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Can only be called by the current owner.
413      */
414     function transferOwnership(address newOwner) public virtual onlyOwner {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         _transferOwnership(newOwner);
417     }
418 
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Internal function without access restriction.
422      */
423     function _transferOwnership(address newOwner) internal virtual {
424         address oldOwner = _owner;
425         _owner = newOwner;
426         emit OwnershipTransferred(oldOwner, newOwner);
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Address.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
434 
435 pragma solidity ^0.8.1;
436 
437 /**
438  * @dev Collection of functions related to the address type
439  */
440 library Address {
441     /**
442      * @dev Returns true if `account` is a contract.
443      *
444      * [IMPORTANT]
445      * ====
446      * It is unsafe to assume that an address for which this function returns
447      * false is an externally-owned account (EOA) and not a contract.
448      *
449      * Among others, `isContract` will return false for the following
450      * types of addresses:
451      *
452      *  - an externally-owned account
453      *  - a contract in construction
454      *  - an address where a contract will be created
455      *  - an address where a contract lived, but was destroyed
456      * ====
457      *
458      * [IMPORTANT]
459      * ====
460      * You shouldn't rely on `isContract` to protect against flash loan attacks!
461      *
462      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
463      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
464      * constructor.
465      * ====
466      */
467     function isContract(address account) internal view returns (bool) {
468         // This method relies on extcodesize/address.code.length, which returns 0
469         // for contracts in construction, since the code is only stored at the end
470         // of the constructor execution.
471 
472         return account.code.length > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
656 
657 
658 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @title ERC721 token receiver interface
664  * @dev Interface for any contract that wants to support safeTransfers
665  * from ERC721 asset contracts.
666  */
667 interface IERC721Receiver {
668     /**
669      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
670      * by `operator` from `from`, this function is called.
671      *
672      * It must return its Solidity selector to confirm the token transfer.
673      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
674      *
675      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
676      */
677     function onERC721Received(
678         address operator,
679         address from,
680         uint256 tokenId,
681         bytes calldata data
682     ) external returns (bytes4);
683 }
684 
685 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Interface of the ERC165 standard, as defined in the
694  * https://eips.ethereum.org/EIPS/eip-165[EIP].
695  *
696  * Implementers can declare support of contract interfaces, which can then be
697  * queried by others ({ERC165Checker}).
698  *
699  * For an implementation, see {ERC165}.
700  */
701 interface IERC165 {
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30 000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Implementation of the {IERC165} interface.
723  *
724  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
725  * for the additional interface id that will be supported. For example:
726  *
727  * ```solidity
728  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
729  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
730  * }
731  * ```
732  *
733  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
734  */
735 abstract contract ERC165 is IERC165 {
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740         return interfaceId == type(IERC165).interfaceId;
741     }
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
745 
746 
747 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @dev Required interface of an ERC721 compliant contract.
754  */
755 interface IERC721 is IERC165 {
756     /**
757      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
758      */
759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
760 
761     /**
762      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
763      */
764     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
768      */
769     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
770 
771     /**
772      * @dev Returns the number of tokens in ``owner``'s account.
773      */
774     function balanceOf(address owner) external view returns (uint256 balance);
775 
776     /**
777      * @dev Returns the owner of the `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function ownerOf(uint256 tokenId) external view returns (address owner);
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes calldata data
803     ) external;
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
807      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Transfers `tokenId` token from `from` to `to`.
827      *
828      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      *
837      * Emits a {Transfer} event.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
847      * The approval is cleared when the token is transferred.
848      *
849      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
850      *
851      * Requirements:
852      *
853      * - The caller must own the token or be an approved operator.
854      * - `tokenId` must exist.
855      *
856      * Emits an {Approval} event.
857      */
858     function approve(address to, uint256 tokenId) external;
859 
860     /**
861      * @dev Approve or remove `operator` as an operator for the caller.
862      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns the account approved for `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function getApproved(uint256 tokenId) external view returns (address operator);
880 
881     /**
882      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
883      *
884      * See {setApprovalForAll}
885      */
886     function isApprovedForAll(address owner, address operator) external view returns (bool);
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 /**
898  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
899  * @dev See https://eips.ethereum.org/EIPS/eip-721
900  */
901 interface IERC721Metadata is IERC721 {
902     /**
903      * @dev Returns the token collection name.
904      */
905     function name() external view returns (string memory);
906 
907     /**
908      * @dev Returns the token collection symbol.
909      */
910     function symbol() external view returns (string memory);
911 
912     /**
913      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
914      */
915     function tokenURI(uint256 tokenId) external view returns (string memory);
916 }
917 
918 // File: erc721a/contracts/IERC721A.sol
919 
920 
921 // ERC721A Contracts v3.3.0
922 // Creator: Chiru Labs
923 
924 pragma solidity ^0.8.4;
925 
926 
927 
928 /**
929  * @dev Interface of an ERC721A compliant contract.
930  */
931 interface IERC721A is IERC721, IERC721Metadata {
932     /**
933      * The caller must own the token or be an approved operator.
934      */
935     error ApprovalCallerNotOwnerNorApproved();
936 
937     /**
938      * The token does not exist.
939      */
940     error ApprovalQueryForNonexistentToken();
941 
942     /**
943      * The caller cannot approve to their own address.
944      */
945     error ApproveToCaller();
946 
947     /**
948      * The caller cannot approve to the current owner.
949      */
950     error ApprovalToCurrentOwner();
951 
952     /**
953      * Cannot query the balance for the zero address.
954      */
955     error BalanceQueryForZeroAddress();
956 
957     /**
958      * Cannot mint to the zero address.
959      */
960     error MintToZeroAddress();
961 
962     /**
963      * The quantity of tokens minted must be more than zero.
964      */
965     error MintZeroQuantity();
966 
967     /**
968      * The token does not exist.
969      */
970     error OwnerQueryForNonexistentToken();
971 
972     /**
973      * The caller must own the token or be an approved operator.
974      */
975     error TransferCallerNotOwnerNorApproved();
976 
977     /**
978      * The token must be owned by `from`.
979      */
980     error TransferFromIncorrectOwner();
981 
982     /**
983      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
984      */
985     error TransferToNonERC721ReceiverImplementer();
986 
987     /**
988      * Cannot transfer to the zero address.
989      */
990     error TransferToZeroAddress();
991 
992     /**
993      * The token does not exist.
994      */
995     error URIQueryForNonexistentToken();
996 
997     // Compiler will pack this into a single 256bit word.
998     struct TokenOwnership {
999         // The address of the owner.
1000         address addr;
1001         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1002         uint64 startTimestamp;
1003         // Whether the token has been burned.
1004         bool burned;
1005     }
1006 
1007     // Compiler will pack this into a single 256bit word.
1008     struct AddressData {
1009         // Realistically, 2**64-1 is more than enough.
1010         uint64 balance;
1011         // Keeps track of mint count with minimal overhead for tokenomics.
1012         uint64 numberMinted;
1013         // Keeps track of burn count with minimal overhead for tokenomics.
1014         uint64 numberBurned;
1015         // For miscellaneous variable(s) pertaining to the address
1016         // (e.g. number of whitelist mint slots used).
1017         // If there are multiple variables, please pack them into a uint64.
1018         uint64 aux;
1019     }
1020 
1021     /**
1022      * @dev Returns the total amount of tokens stored by the contract.
1023      * 
1024      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1025      */
1026     function totalSupply() external view returns (uint256);
1027 }
1028 
1029 // File: erc721a/contracts/ERC721A.sol
1030 
1031 
1032 // ERC721A Contracts v3.3.0
1033 
1034 pragma solidity ^0.8.4;
1035 
1036 
1037 
1038 
1039 
1040 
1041 
1042 /**
1043  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1044  * the Metadata extension. Built to optimize for lower gas during batch mints.
1045  *
1046  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1047  *
1048  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1049  *
1050  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1051  */
1052 contract ERC721A is Context, ERC165, IERC721A {
1053     using Address for address;
1054     using Strings for uint256;
1055 
1056     // The tokenId of the next token to be minted.
1057     uint256 internal _currentIndex;
1058 
1059     // The number of tokens burned.
1060     uint256 internal _burnCounter;
1061 
1062     // Token name
1063     string private _name;
1064 
1065     // Token symbol
1066     string private _symbol;
1067 
1068     // Mapping from token ID to ownership details
1069     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1070     mapping(uint256 => TokenOwnership) internal _ownerships;
1071 
1072     // Mapping owner address to address data
1073     mapping(address => AddressData) private _addressData;
1074 
1075     // Mapping from token ID to approved address
1076     mapping(uint256 => address) private _tokenApprovals;
1077 
1078     // Mapping from owner to operator approvals
1079     mapping(address => mapping(address => bool)) private _operatorApprovals;
1080 
1081     constructor(string memory name_, string memory symbol_) {
1082         _name = name_;
1083         _symbol = symbol_;
1084         _currentIndex = _startTokenId();
1085     }
1086 
1087     /**
1088      * To change the starting tokenId, please override this function.
1089      */
1090     function _startTokenId() internal view virtual returns (uint256) {
1091         return 1;
1092     }
1093 
1094     /**
1095      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1096      */
1097     function totalSupply() public view override returns (uint256) {
1098         // Counter underflow is impossible as _burnCounter cannot be incremented
1099         // more than _currentIndex - _startTokenId() times
1100         unchecked {
1101             return _currentIndex - _burnCounter - _startTokenId();
1102         }
1103     }
1104 
1105     /**
1106      * Returns the total amount of tokens minted in the contract.
1107      */
1108     function _totalMinted() internal view returns (uint256) {
1109         // Counter underflow is impossible as _currentIndex does not decrement,
1110         // and it is initialized to _startTokenId()
1111         unchecked {
1112             return _currentIndex - _startTokenId();
1113         }
1114     }
1115 
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1120         return
1121             interfaceId == type(IERC721).interfaceId ||
1122             interfaceId == type(IERC721Metadata).interfaceId ||
1123             super.supportsInterface(interfaceId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-balanceOf}.
1128      */
1129     function balanceOf(address owner) public view override returns (uint256) {
1130         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1131         return uint256(_addressData[owner].balance);
1132     }
1133 
1134     /**
1135      * Returns the number of tokens minted by `owner`.
1136      */
1137     function _numberMinted(address owner) internal view returns (uint256) {
1138         return uint256(_addressData[owner].numberMinted);
1139     }
1140 
1141     /**
1142      * Returns the number of tokens burned by or on behalf of `owner`.
1143      */
1144     function _numberBurned(address owner) internal view returns (uint256) {
1145         return uint256(_addressData[owner].numberBurned);
1146     }
1147 
1148     /**
1149      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1150      */
1151     function _getAux(address owner) internal view returns (uint64) {
1152         return _addressData[owner].aux;
1153     }
1154 
1155     /**
1156      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1157      * If there are multiple variables, please pack them into a uint64.
1158      */
1159     function _setAux(address owner, uint64 aux) internal {
1160         _addressData[owner].aux = aux;
1161     }
1162 
1163     /**
1164      * Gas spent here starts off proportional to the maximum mint batch size.
1165      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1166      */
1167     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1168         uint256 curr = tokenId;
1169 
1170         unchecked {
1171             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1172                 TokenOwnership memory ownership = _ownerships[curr];
1173                 if (!ownership.burned) {
1174                     if (ownership.addr != address(0)) {
1175                         return ownership;
1176                     }
1177                     // Invariant:
1178                     // There will always be an ownership that has an address and is not burned
1179                     // before an ownership that does not have an address and is not burned.
1180                     // Hence, curr will not underflow.
1181                     while (true) {
1182                         curr--;
1183                         ownership = _ownerships[curr];
1184                         if (ownership.addr != address(0)) {
1185                             return ownership;
1186                         }
1187                     }
1188                 }
1189             }
1190         }
1191         revert OwnerQueryForNonexistentToken();
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-ownerOf}.
1196      */
1197     function ownerOf(uint256 tokenId) public view override returns (address) {
1198         return _ownershipOf(tokenId).addr;
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Metadata-name}.
1203      */
1204     function name() public view virtual override returns (string memory) {
1205         return _name;
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Metadata-symbol}.
1210      */
1211     function symbol() public view virtual override returns (string memory) {
1212         return _symbol;
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Metadata-tokenURI}.
1217      */
1218     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1219         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1220 
1221         string memory baseURI = _baseURI();
1222         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1223     }
1224 
1225     /**
1226      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1227      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1228      * by default, can be overriden in child contracts.
1229      */
1230     function _baseURI() internal view virtual returns (string memory) {
1231         return '';
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-approve}.
1236      */
1237     function approve(address to, uint256 tokenId) virtual public override {
1238         address owner = ERC721A.ownerOf(tokenId);
1239         if (to == owner) revert ApprovalToCurrentOwner();
1240 
1241         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1242             revert ApprovalCallerNotOwnerNorApproved();
1243         }
1244 
1245         _approve(to, tokenId, owner);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-getApproved}.
1250      */
1251     function getApproved(uint256 tokenId) public view override returns (address) {
1252         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1253 
1254         return _tokenApprovals[tokenId];
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-setApprovalForAll}.
1259      */
1260     function setApprovalForAll(address operator, bool approved) public virtual override {
1261         if (operator == _msgSender()) revert ApproveToCaller();
1262 
1263         _operatorApprovals[_msgSender()][operator] = approved;
1264         emit ApprovalForAll(_msgSender(), operator, approved);
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-isApprovedForAll}.
1269      */
1270     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-transferFrom}.
1276      */
1277     function transferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public virtual override {
1282         _transfer(from, to, tokenId);
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-safeTransferFrom}.
1287      */
1288     function safeTransferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) public virtual override {
1293         safeTransferFrom(from, to, tokenId, '');
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-safeTransferFrom}.
1298      */
1299     function safeTransferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) public virtual override {
1305         _transfer(from, to, tokenId);
1306         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1307             revert TransferToNonERC721ReceiverImplementer();
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns whether `tokenId` exists.
1313      *
1314      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1315      *
1316      * Tokens start existing when they are minted (`_mint`),
1317      */
1318     function _exists(uint256 tokenId) internal view returns (bool) {
1319         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1320     }
1321 
1322     /**
1323      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1324      */
1325     function _safeMint(address to, uint256 quantity) internal {
1326         _safeMint(to, quantity, '');
1327     }
1328 
1329     /**
1330      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1331      *
1332      * Requirements:
1333      *
1334      * - If `to` refers to a smart contract, it must implement
1335      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1336      * - `quantity` must be greater than 0.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _safeMint(
1341         address to,
1342         uint256 quantity,
1343         bytes memory _data
1344     ) internal {
1345         uint256 startTokenId = _currentIndex;
1346         if (to == address(0)) revert MintToZeroAddress();
1347         if (quantity == 0) revert MintZeroQuantity();
1348 
1349         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1350 
1351         // Overflows are incredibly unrealistic.
1352         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1353         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1354         unchecked {
1355             _addressData[to].balance += uint64(quantity);
1356             _addressData[to].numberMinted += uint64(quantity);
1357 
1358             _ownerships[startTokenId].addr = to;
1359             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1360 
1361             uint256 updatedIndex = startTokenId;
1362             uint256 end = updatedIndex + quantity;
1363 
1364             if (to.isContract()) {
1365                 do {
1366                     emit Transfer(address(0), to, updatedIndex);
1367                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1368                         revert TransferToNonERC721ReceiverImplementer();
1369                     }
1370                 } while (updatedIndex < end);
1371                 // Reentrancy protection
1372                 if (_currentIndex != startTokenId) revert();
1373             } else {
1374                 do {
1375                     emit Transfer(address(0), to, updatedIndex++);
1376                 } while (updatedIndex < end);
1377             }
1378             _currentIndex = updatedIndex;
1379         }
1380         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1381     }
1382 
1383     /**
1384      * @dev Mints `quantity` tokens and transfers them to `to`.
1385      *
1386      * Requirements:
1387      *
1388      * - `to` cannot be the zero address.
1389      * - `quantity` must be greater than 0.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _mint(address to, uint256 quantity) internal {
1394         uint256 startTokenId = _currentIndex;
1395         if (to == address(0)) revert MintToZeroAddress();
1396         if (quantity == 0) revert MintZeroQuantity();
1397 
1398         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1399 
1400         // Overflows are incredibly unrealistic.
1401         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1402         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1403         unchecked {
1404             _addressData[to].balance += uint64(quantity);
1405             _addressData[to].numberMinted += uint64(quantity);
1406 
1407             _ownerships[startTokenId].addr = to;
1408             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1409 
1410             uint256 updatedIndex = startTokenId;
1411             uint256 end = updatedIndex + quantity;
1412 
1413             do {
1414                 emit Transfer(address(0), to, updatedIndex++);
1415             } while (updatedIndex < end);
1416 
1417             _currentIndex = updatedIndex;
1418         }
1419         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1420     }
1421 
1422     /**
1423      * @dev Transfers `tokenId` from `from` to `to`.
1424      *
1425      * Requirements:
1426      *
1427      * - `to` cannot be the zero address.
1428      * - `tokenId` token must be owned by `from`.
1429      *
1430      * Emits a {Transfer} event.
1431      */
1432     function _transfer(
1433         address from,
1434         address to,
1435         uint256 tokenId
1436     ) private {
1437         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1438 
1439         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1440 
1441         bool isApprovedOrOwner = (_msgSender() == from ||
1442             isApprovedForAll(from, _msgSender()) ||
1443             getApproved(tokenId) == _msgSender());
1444 
1445         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1446         if (to == address(0)) revert TransferToZeroAddress();
1447 
1448         _beforeTokenTransfers(from, to, tokenId, 1);
1449 
1450         // Clear approvals from the previous owner
1451         _approve(address(0), tokenId, from);
1452 
1453         // Underflow of the sender's balance is impossible because we check for
1454         // ownership above and the recipient's balance can't realistically overflow.
1455         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1456         unchecked {
1457             _addressData[from].balance -= 1;
1458             _addressData[to].balance += 1;
1459 
1460             TokenOwnership storage currSlot = _ownerships[tokenId];
1461             currSlot.addr = to;
1462             currSlot.startTimestamp = uint64(block.timestamp);
1463 
1464             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1465             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1466             uint256 nextTokenId = tokenId + 1;
1467             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1468             if (nextSlot.addr == address(0)) {
1469                 // This will suffice for checking _exists(nextTokenId),
1470                 // as a burned slot cannot contain the zero address.
1471                 if (nextTokenId != _currentIndex) {
1472                     nextSlot.addr = from;
1473                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1474                 }
1475             }
1476         }
1477 
1478         emit Transfer(from, to, tokenId);
1479         _afterTokenTransfers(from, to, tokenId, 1);
1480     }
1481 
1482     /**
1483      * @dev Equivalent to `_burn(tokenId, false)`.
1484      */
1485     function _burn(uint256 tokenId) internal virtual {
1486         _burn(tokenId, false);
1487     }
1488 
1489     /**
1490      * @dev Destroys `tokenId`.
1491      * The approval is cleared when the token is burned.
1492      *
1493      * Requirements:
1494      *
1495      * - `tokenId` must exist.
1496      *
1497      * Emits a {Transfer} event.
1498      */
1499     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1500         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1501 
1502         address from = prevOwnership.addr;
1503 
1504         if (approvalCheck) {
1505             bool isApprovedOrOwner = (_msgSender() == from ||
1506                 isApprovedForAll(from, _msgSender()) ||
1507                 getApproved(tokenId) == _msgSender());
1508 
1509             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1510         }
1511 
1512         _beforeTokenTransfers(from, address(0), tokenId, 1);
1513 
1514         // Clear approvals from the previous owner
1515         _approve(address(0), tokenId, from);
1516 
1517         // Underflow of the sender's balance is impossible because we check for
1518         // ownership above and the recipient's balance can't realistically overflow.
1519         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1520         unchecked {
1521             AddressData storage addressData = _addressData[from];
1522             addressData.balance -= 1;
1523             addressData.numberBurned += 1;
1524 
1525             // Keep track of who burned the token, and the timestamp of burning.
1526             TokenOwnership storage currSlot = _ownerships[tokenId];
1527             currSlot.addr = from;
1528             currSlot.startTimestamp = uint64(block.timestamp);
1529             currSlot.burned = true;
1530 
1531             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1532             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1533             uint256 nextTokenId = tokenId + 1;
1534             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1535             if (nextSlot.addr == address(0)) {
1536                 // This will suffice for checking _exists(nextTokenId),
1537                 // as a burned slot cannot contain the zero address.
1538                 if (nextTokenId != _currentIndex) {
1539                     nextSlot.addr = from;
1540                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1541                 }
1542             }
1543         }
1544 
1545         emit Transfer(from, address(0), tokenId);
1546         _afterTokenTransfers(from, address(0), tokenId, 1);
1547 
1548         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1549         unchecked {
1550             _burnCounter++;
1551         }
1552     }
1553 
1554     /**
1555      * @dev Approve `to` to operate on `tokenId`
1556      *
1557      * Emits a {Approval} event.
1558      */
1559     function _approve(
1560         address to,
1561         uint256 tokenId,
1562         address owner
1563     ) private {
1564         _tokenApprovals[tokenId] = to;
1565         emit Approval(owner, to, tokenId);
1566     }
1567 
1568     /**
1569      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1570      *
1571      * @param from address representing the previous owner of the given token ID
1572      * @param to target address that will receive the tokens
1573      * @param tokenId uint256 ID of the token to be transferred
1574      * @param _data bytes optional data to send along with the call
1575      * @return bool whether the call correctly returned the expected magic value
1576      */
1577     function _checkContractOnERC721Received(
1578         address from,
1579         address to,
1580         uint256 tokenId,
1581         bytes memory _data
1582     ) private returns (bool) {
1583         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1584             return retval == IERC721Receiver(to).onERC721Received.selector;
1585         } catch (bytes memory reason) {
1586             if (reason.length == 0) {
1587                 revert TransferToNonERC721ReceiverImplementer();
1588             } else {
1589                 assembly {
1590                     revert(add(32, reason), mload(reason))
1591                 }
1592             }
1593         }
1594     }
1595 
1596     /**
1597      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1598      * And also called before burning one token.
1599      *
1600      * startTokenId - the first token id to be transferred
1601      * quantity - the amount to be transferred
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      * - When `to` is zero, `tokenId` will be burned by `from`.
1609      * - `from` and `to` are never both zero.
1610      */
1611     function _beforeTokenTransfers(
1612         address from,
1613         address to,
1614         uint256 startTokenId,
1615         uint256 quantity
1616     ) internal virtual {}
1617 
1618     /**
1619      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1620      * minting.
1621      * And also called after one token has been burned.
1622      *
1623      * startTokenId - the first token id to be transferred
1624      * quantity - the amount to be transferred
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` has been minted for `to`.
1631      * - When `to` is zero, `tokenId` has been burned by `from`.
1632      * - `from` and `to` are never both zero.
1633      */
1634     function _afterTokenTransfers(
1635         address from,
1636         address to,
1637         uint256 startTokenId,
1638         uint256 quantity
1639     ) internal virtual {}
1640 }
1641 
1642 pragma solidity ^0.8.0;
1643 
1644 
1645 /**
1646  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1647  * @dev See https://eips.ethereum.org/EIPS/eip-721
1648  */
1649 interface IERC721Enumerable is IERC721 {
1650     /**
1651      * @dev Returns the total amount of tokens stored by the contract.
1652      */
1653     function totalSupply() external view returns (uint256);
1654 
1655     /**
1656      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1657      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1658      */
1659     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1660 
1661     /**
1662      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1663      * Use along with {totalSupply} to enumerate all tokens.
1664      */
1665     function tokenByIndex(uint256 index) external view returns (uint256);
1666 }
1667 
1668 
1669 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1670 
1671 pragma solidity ^0.8.0;
1672 
1673 /**
1674  * @title Counters
1675  * @author Matt Condon (@shrugs)
1676  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1677  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1678  *
1679  * Include with `using Counters for Counters.Counter;`
1680  */
1681 library Counters {
1682     struct Counter {
1683         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1684         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1685         // this feature: see https://github.com/ethereum/solidity/issues/4637
1686         uint256 _value; // default: 0
1687     }
1688 
1689     function current(Counter storage counter) internal view returns (uint256) {
1690         return counter._value;
1691     }
1692 
1693     function increment(Counter storage counter) internal {
1694         unchecked {
1695             counter._value += 1;
1696         }
1697     }
1698 
1699     function decrement(Counter storage counter) internal {
1700         uint256 value = counter._value;
1701         require(value > 0, "Counter: decrement overflow");
1702         unchecked {
1703             counter._value = value - 1;
1704         }
1705     }
1706 
1707     function reset(Counter storage counter) internal {
1708         counter._value = 0;
1709     }
1710 }
1711 
1712 
1713 
1714 // Developed by https://transcendnt.io
1715 
1716 pragma solidity ^0.8.4;
1717 
1718 
1719 contract InsertStonksGenesis is ERC721A, Ownable, DefaultOperatorFilterer {
1720     uint256 public max_supply = 5000;
1721     bool public paused = true;
1722     string public baseURI = "ipfs://bafybeie3hob7gdfze5swo7ij2txx3h4y2udby6f6pfllcarcyu3pxhodme/";
1723 
1724     using Strings for uint256;
1725 
1726     mapping(uint256 => string) private _tokenURIs;
1727 
1728     constructor() ERC721A("Insert Stonks Genesis Pass", "ISG") {
1729     }
1730 
1731     mapping(address => uint256) private _ownedTokenCount;
1732 
1733     function publicMint(uint256 quantity) external payable {
1734         require(!paused, "Minting is currently paused");
1735         require(totalSupply() + quantity <= max_supply, "Not enough tokens left");
1736         if (msg.sender != owner()) {
1737             require(quantity + _numberMinted(msg.sender) <= 1, "Max mints reached");
1738         }
1739         _safeMint(msg.sender, quantity);        
1740     }   
1741     
1742     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1743         require(index < balanceOf(owner), "Owner does not own this token");
1744 
1745         for (uint256 i = 0; i < totalSupply(); i++) {
1746             if (_exists(i) && ownerOf(i) == owner) {
1747                 if (index == 0) {
1748                     return i;
1749                 }
1750                 index--;
1751             }
1752         }
1753         revert("Token not found");
1754     }
1755 
1756     function _baseURI() internal view override returns (string memory) {
1757         return baseURI;
1758     }
1759 
1760 
1761     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1762         baseURI = _newBaseURI;
1763     }
1764 
1765     function pause() external onlyOwner {
1766     paused = true;
1767     }
1768 
1769     function unpause() external onlyOwner {
1770         paused = false;
1771     }
1772 
1773 
1774     function setMax_supply(uint256 _max_supply) public onlyOwner {
1775         max_supply = _max_supply;
1776     }
1777 
1778     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1779         super.setApprovalForAll(operator, approved);
1780     }
1781 
1782     /**
1783      * @dev See {IERC721-approve}.
1784      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
1785      */
1786     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1787         super.approve(operator, tokenId);
1788     }
1789 
1790     /**
1791      * @dev See {IERC721-transferFrom}.
1792      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
1793      */
1794     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1795         super.transferFrom(from, to, tokenId);
1796     }
1797 
1798     /**
1799      * @dev See {IERC721-safeTransferFrom}.
1800      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
1801      */
1802     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1803         super.safeTransferFrom(from, to, tokenId);
1804     }
1805 
1806     /**
1807      * @dev See {IERC721-safeTransferFrom}.
1808      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
1809      */
1810     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1811         public
1812         override
1813         onlyAllowedOperator(from)
1814     {
1815         super.safeTransferFrom(from, to, tokenId, data);
1816     }
1817 }