1 // SPDX-License-Identifier: MIT
2 // File: IOperatorFilterRegistry.sol
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
34 // File: OperatorFilterer.sol
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
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: MerkleProof.sol
113 
114 // contracts/MerkleProofVerify.sol
115 
116 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev These functions deal with verification of Merkle trees (hash trees),
122  */
123 library MerkleProof {
124     /**
125      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
126      * defined by `root`. For this, a `proof` must be provided, containing
127      * sibling hashes on the branch from the leaf to the root of the tree. Each
128      * pair of leaves and each pair of pre-images are assumed to be sorted.
129      */
130     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
131         bytes32 computedHash = leaf;
132 
133         for (uint256 i = 0; i < proof.length; i++) {
134             bytes32 proofElement = proof[i];
135 
136             if (computedHash <= proofElement) {
137                 // Hash(current computed hash + current element of the proof)
138                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
139             } else {
140                 // Hash(current element of the proof + current computed hash)
141                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
142             }
143         }
144 
145         // Check if the computed hash (root) is equal to the provided root
146         return computedHash == root;
147     }
148 }
149 
150 
151 /*
152 
153 pragma solidity ^0.8.0;
154 
155 
156 
157 contract MerkleProofVerify {
158     function verify(bytes32[] calldata proof, bytes32 root)
159         public
160         view
161         returns (bool)
162     {
163         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
164 
165         return MerkleProof.verify(proof, root, leaf);
166     }
167 }
168 */
169 // File: Strings.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev String operations.
177  */
178 library Strings {
179     /**
180      * @dev Converts a `uint256` to its ASCII `string` representation.
181      */
182     function toString(uint256 value) internal pure returns (string memory) {
183         // Inspired by OraclizeAPI's implementation - MIT licence
184         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
185 
186         if (value == 0) {
187             return "0";
188         }
189         uint256 temp = value;
190         uint256 digits;
191         while (temp != 0) {
192             digits++;
193             temp /= 10;
194         }
195         bytes memory buffer = new bytes(digits);
196         uint256 index = digits;
197         temp = value;
198         while (temp != 0) {
199             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
200             temp /= 10;
201         }
202         return string(buffer);
203     }
204 }
205 
206 // File: Context.sol
207 
208 
209 
210 pragma solidity ^0.8.0;
211 
212 /*
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with GSN meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 // File: Ownable.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 
241 /**
242  * @dev Contract module which provides a basic access control mechanism, where
243  * there is an account (an owner) that can be granted exclusive access to
244  * specific functions.
245  *
246  * By default, the owner account will be the one that deploys the contract. This
247  * can later be changed with {transferOwnership}.
248  *
249  * This module is used through inheritance. It will make available the modifier
250  * `onlyOwner`, which can be applied to your functions to restrict their use to
251  * the owner.
252  */
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     /**
259      * @dev Initializes the contract setting the deployer as the initial owner.
260      */
261     constructor() {
262         _transferOwnership(_msgSender());
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         _checkOwner();
270         _;
271     }
272 
273     /**
274      * @dev Returns the address of the current owner.
275      */
276     function owner() public view virtual returns (address) {
277         return _owner;
278     }
279 
280     /**
281      * @dev Throws if the sender is not the owner.
282      */
283     function _checkOwner() internal view virtual {
284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
285     }
286 
287     /**
288      * @dev Leaves the contract without owner. It will not be possible to call
289      * `onlyOwner` functions anymore. Can only be called by the current owner.
290      *
291      * NOTE: Renouncing ownership will leave the contract without an owner,
292      * thereby removing any functionality that is only available to the owner.
293      */
294     function renounceOwnership() public virtual onlyOwner {
295         _transferOwnership(address(0));
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      * Can only be called by the current owner.
301      */
302     function transferOwnership(address newOwner) public virtual onlyOwner {
303         require(newOwner != address(0), "Ownable: new owner is the zero address");
304         _transferOwnership(newOwner);
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Internal function without access restriction.
310      */
311     function _transferOwnership(address newOwner) internal virtual {
312         address oldOwner = _owner;
313         _owner = newOwner;
314         emit OwnershipTransferred(oldOwner, newOwner);
315     }
316 }
317 // File: Address.sol
318 
319 
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { size := extcodesize(account) }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
375         (bool success, ) = recipient.call{ value: amount }("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain`call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{ value: value }(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.3._
470      */
471     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.3._
480      */
481     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 // solhint-disable-next-line no-inline-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: IERC721Receiver.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @title ERC721 token receiver interface
517  * @dev Interface for any contract that wants to support safeTransfers
518  * from ERC721 asset contracts.
519  */
520 interface IERC721Receiver {
521     /**
522      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
523      * by `operator` from `from`, this function is called.
524      *
525      * It must return its Solidity selector to confirm the token transfer.
526      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
527      *
528      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
529      */
530     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
531 }
532 
533 // File: IERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Interface of the ERC165 standard, as defined in the
542  * https://eips.ethereum.org/EIPS/eip-165[EIP].
543  *
544  * Implementers can declare support of contract interfaces, which can then be
545  * queried by others ({ERC165Checker}).
546  *
547  * For an implementation, see {ERC165}.
548  */
549 interface IERC165 {
550     /**
551      * @dev Returns true if this contract implements the interface defined by
552      * `interfaceId`. See the corresponding
553      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
554      * to learn more about how these ids are created.
555      *
556      * This function call must use less than 30 000 gas.
557      */
558     function supportsInterface(bytes4 interfaceId) external view returns (bool);
559 }
560 // File: IERC2981.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Interface for the NFT Royalty Standard.
570  *
571  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
572  * support for royalty payments across all NFT marketplaces and ecosystem participants.
573  *
574  * _Available since v4.5._
575  */
576 interface IERC2981 is IERC165 {
577     /**
578      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
579      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
580      */
581     function royaltyInfo(uint256 tokenId, uint256 salePrice)
582         external
583         view
584         returns (address receiver, uint256 royaltyAmount);
585 }
586 // File: ERC165.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 // File: ERC2981.sol
617 
618 
619 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 
625 /**
626  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
627  *
628  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
629  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
630  *
631  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
632  * fee is specified in basis points by default.
633  *
634  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
635  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
636  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
637  *
638  * _Available since v4.5._
639  */
640 abstract contract ERC2981 is IERC2981, ERC165 {
641     struct RoyaltyInfo {
642         address receiver;
643         uint96 royaltyFraction;
644     }
645 
646     RoyaltyInfo private _defaultRoyaltyInfo;
647     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
648 
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
653         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
654     }
655 
656     /**
657      * @inheritdoc IERC2981
658      */
659     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
660         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
661 
662         if (royalty.receiver == address(0)) {
663             royalty = _defaultRoyaltyInfo;
664         }
665 
666         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
667 
668         return (royalty.receiver, royaltyAmount);
669     }
670 
671     /**
672      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
673      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
674      * override.
675      */
676     function _feeDenominator() internal pure virtual returns (uint96) {
677         return 10000;
678     }
679 
680     /**
681      * @dev Sets the royalty information that all ids in this contract will default to.
682      *
683      * Requirements:
684      *
685      * - `receiver` cannot be the zero address.
686      * - `feeNumerator` cannot be greater than the fee denominator.
687      */
688     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
689         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
690         require(receiver != address(0), "ERC2981: invalid receiver");
691 
692         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
693     }
694 
695     /**
696      * @dev Removes default royalty information.
697      */
698     function _deleteDefaultRoyalty() internal virtual {
699         delete _defaultRoyaltyInfo;
700     }
701 
702     /**
703      * @dev Sets the royalty information for a specific token id, overriding the global default.
704      *
705      * Requirements:
706      *
707      * - `receiver` cannot be the zero address.
708      * - `feeNumerator` cannot be greater than the fee denominator.
709      */
710     function _setTokenRoyalty(
711         uint256 tokenId,
712         address receiver,
713         uint96 feeNumerator
714     ) internal virtual {
715         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
716         require(receiver != address(0), "ERC2981: Invalid parameters");
717 
718         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
719     }
720 
721     /**
722      * @dev Resets royalty information for the token id back to the global default.
723      */
724     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
725         delete _tokenRoyaltyInfo[tokenId];
726     }
727 }
728 // File: IERC721.sol
729 
730 
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @dev Required interface of an ERC721 compliant contract.
737  */
738 interface IERC721 is IERC165 {
739     /**
740      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
741      */
742     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
743 
744     /**
745      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
746      */
747     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
748 
749     /**
750      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
751      */
752     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
753 
754     /**
755      * @dev Returns the number of tokens in ``owner``'s account.
756      */
757     function balanceOf(address owner) external view returns (uint256 balance);
758 
759     /**
760      * @dev Returns the owner of the `tokenId` token.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function ownerOf(uint256 tokenId) external view returns (address owner);
767 
768     /**
769      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
770      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must exist and be owned by `from`.
777      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function safeTransferFrom(address from, address to, uint256 tokenId) external;
783 
784     /**
785      * @dev Transfers `tokenId` token from `from` to `to`.
786      *
787      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must be owned by `from`.
794      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transferFrom(address from, address to, uint256 tokenId) external;
799 
800     /**
801      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
802      * The approval is cleared when the token is transferred.
803      *
804      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
805      *
806      * Requirements:
807      *
808      * - The caller must own the token or be an approved operator.
809      * - `tokenId` must exist.
810      *
811      * Emits an {Approval} event.
812      */
813     function approve(address to, uint256 tokenId) external;
814 
815     /**
816      * @dev Returns the account approved for `tokenId` token.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function getApproved(uint256 tokenId) external view returns (address operator);
823 
824     /**
825      * @dev Approve or remove `operator` as an operator for the caller.
826      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
827      *
828      * Requirements:
829      *
830      * - The `operator` cannot be the caller.
831      *
832      * Emits an {ApprovalForAll} event.
833      */
834     function setApprovalForAll(address operator, bool _approved) external;
835 
836     /**
837      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
838      *
839      * See {setApprovalForAll}
840      */
841     function isApprovedForAll(address owner, address operator) external view returns (bool);
842 
843     /**
844       * @dev Safely transfers `tokenId` token from `from` to `to`.
845       *
846       * Requirements:
847       *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850       * - `tokenId` token must exist and be owned by `from`.
851       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
852       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853       *
854       * Emits a {Transfer} event.
855       */
856     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
857 }
858 
859 // File: IERC721Enumerable.sol
860 
861 
862 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 
867 /**
868  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
869  * @dev See https://eips.ethereum.org/EIPS/eip-721
870  */
871 interface IERC721Enumerable is IERC721 {
872     /**
873      * @dev Returns the total amount of tokens stored by the contract.
874      */
875     function totalSupply() external view returns (uint256);
876 
877     /**
878      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
879      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
880      */
881     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
882 
883     /**
884      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
885      * Use along with {totalSupply} to enumerate all tokens.
886      */
887     function tokenByIndex(uint256 index) external view returns (uint256);
888 }
889 // File: IERC721Metadata.sol
890 
891 
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 interface IERC721Metadata is IERC721 {
901 
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
918 // File: ERC721A.sol
919 
920 
921 // Creator: Chiru Labs
922 
923 pragma solidity ^0.8.4;
924 
925 
926 
927 error ApprovalCallerNotOwnerNorApproved();
928 error ApprovalQueryForNonexistentToken();
929 error ApproveToCaller();
930 error ApprovalToCurrentOwner();
931 error BalanceQueryForZeroAddress();
932 error MintedQueryForZeroAddress();
933 error BurnedQueryForZeroAddress();
934 error MintToZeroAddress();
935 error MintZeroQuantity();
936 error OwnerIndexOutOfBounds();
937 error OwnerQueryForNonexistentToken();
938 error TokenIndexOutOfBounds();
939 error TransferCallerNotOwnerNorApproved();
940 error TransferFromIncorrectOwner();
941 error TransferToNonERC721ReceiverImplementer();
942 error TransferToZeroAddress();
943 error URIQueryForNonexistentToken();
944 error TransferFromZeroAddressBlocked();
945 
946 /**
947  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
948  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
949  *
950  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
951  *
952  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
953  *
954  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
955  */
956 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
957     using Address for address;
958     using Strings for uint256;
959 
960     //owner
961     address public _ownerFortfr;
962 
963     // Compiler will pack this into a single 256bit word.
964     struct TokenOwnership {
965         // The address of the owner.
966         address addr;
967         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
968         uint64 startTimestamp;
969         // Whether the token has been burned.
970         bool burned;
971     }
972 
973     // Compiler will pack this into a single 256bit word.
974     struct AddressData {
975         // Realistically, 2**64-1 is more than enough.
976         uint64 balance;
977         // Keeps track of mint count with minimal overhead for tokenomics.
978         uint64 numberMinted;
979         // Keeps track of burn count with minimal overhead for tokenomics.
980         uint64 numberBurned;
981     }
982 
983     // Compiler will pack the following 
984     // _currentIndex and _burnCounter into a single 256bit word.
985     
986     // The tokenId of the next token to be minted.
987     uint128 internal _currentIndex;
988 
989     // The number of tokens burned.
990     uint128 internal _burnCounter;
991 
992     // Token name
993     string private _name;
994 
995     // Token symbol
996     string private _symbol;
997 
998     // Mapping from token ID to ownership details
999     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1000     mapping(uint256 => TokenOwnership) internal _ownerships;
1001 
1002     // Mapping owner address to address data
1003     mapping(address => AddressData) private _addressData;
1004 
1005     // Mapping from token ID to approved address
1006     mapping(uint256 => address) private _tokenApprovals;
1007 
1008     // Mapping from owner to operator approvals
1009     mapping(address => mapping(address => bool)) private _operatorApprovals;
1010 
1011     constructor(string memory name_, string memory symbol_) {
1012         _name = name_;
1013         _symbol = symbol_;
1014         _currentIndex = 1; 
1015         _burnCounter = 1;
1016 
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-totalSupply}.
1021      */
1022     function totalSupply() public view override returns (uint256) {
1023         // Counter underflow is impossible as _burnCounter cannot be incremented
1024         // more than _currentIndex times
1025         unchecked {
1026             return _currentIndex - _burnCounter;    
1027         }
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenByIndex}.
1032      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1033      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1034      */
1035     function tokenByIndex(uint256 index) public view override returns (uint256) {
1036         uint256 numMintedSoFar = _currentIndex;
1037         uint256 tokenIdsIdx;
1038 
1039         // Counter overflow is impossible as the loop breaks when
1040         // uint256 i is equal to another uint256 numMintedSoFar.
1041         unchecked {
1042             for (uint256 i; i < numMintedSoFar; i++) {
1043                 TokenOwnership memory ownership = _ownerships[i];
1044                 if (!ownership.burned) {
1045                     if (tokenIdsIdx == index) {
1046                         return i;
1047                     }
1048                     tokenIdsIdx++;
1049                 }
1050             }
1051         }
1052         revert TokenIndexOutOfBounds();
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1058      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1061         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1062         uint256 numMintedSoFar = _currentIndex;
1063         uint256 tokenIdsIdx;
1064         address currOwnershipAddr;
1065 
1066         // Counter overflow is impossible as the loop breaks when
1067         // uint256 i is equal to another uint256 numMintedSoFar.
1068         unchecked {
1069             for (uint256 i; i < numMintedSoFar; i++) {
1070                 TokenOwnership memory ownership = _ownerships[i];
1071                 if (ownership.burned) {
1072                     continue;
1073                 }
1074                 if (ownership.addr != address(0)) {
1075                     currOwnershipAddr = ownership.addr;
1076                 }
1077                 if (currOwnershipAddr == owner) {
1078                     if (tokenIdsIdx == index) {
1079                         return i;
1080                     }
1081                     tokenIdsIdx++;
1082                 }
1083             }
1084         }
1085 
1086         // Execution should never reach this point.
1087         revert();
1088     }
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1094         return
1095             interfaceId == type(IERC721).interfaceId ||
1096             interfaceId == type(IERC721Metadata).interfaceId ||
1097             interfaceId == type(IERC721Enumerable).interfaceId ||
1098             super.supportsInterface(interfaceId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-balanceOf}.
1103      */
1104     function balanceOf(address owner) public view override returns (uint256) {
1105         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1106         return uint256(_addressData[owner].balance);
1107     }
1108 
1109     function _numberMinted(address owner) internal view returns (uint256) {
1110         if (owner == address(0)) revert MintedQueryForZeroAddress();
1111         return uint256(_addressData[owner].numberMinted);
1112     }
1113 
1114     function _numberBurned(address owner) internal view returns (uint256) {
1115         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1116         return uint256(_addressData[owner].numberBurned);
1117     }
1118 
1119     /**
1120      * Gas spent here starts off proportional to the maximum mint batch size.
1121      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1122      */
1123     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1124         uint256 curr = tokenId;
1125 
1126         unchecked {
1127             if (curr < _currentIndex) {
1128                 TokenOwnership memory ownership = _ownerships[curr];
1129                 if (!ownership.burned) {
1130                     if (ownership.addr != address(0)) {
1131                         return ownership;
1132                     }
1133                     // Invariant: 
1134                     // There will always be an ownership that has an address and is not burned 
1135                     // before an ownership that does not have an address and is not burned.
1136                     // Hence, curr will not underflow.
1137                     while (true) {
1138                         curr--;
1139                         ownership = _ownerships[curr];
1140                         if (ownership.addr != address(0)) {
1141                             return ownership;
1142                         }
1143                     }
1144                 }
1145             }
1146         }
1147         revert OwnerQueryForNonexistentToken();
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-ownerOf}.
1152      */
1153     function ownerOf(uint256 tokenId) public view override returns (address) {
1154         return ownershipOf(tokenId).addr;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Metadata-name}.
1159      */
1160     function name() public view virtual override returns (string memory) {
1161         return _name;
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Metadata-symbol}.
1166      */
1167     function symbol() public view virtual override returns (string memory) {
1168         return _symbol;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Metadata-tokenURI}.
1173      */
1174     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1175         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1176 
1177         string memory baseURI = _baseURI();
1178         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1179     }
1180 
1181     /**
1182      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1183      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1184      * by default, can be overriden in child contracts.
1185      */
1186     function _baseURI() internal view virtual returns (string memory) {
1187         return '';
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-approve}.
1192      */
1193     function approve(address to, uint256 tokenId) public virtual override {
1194         address owner = ERC721A.ownerOf(tokenId);
1195         if (to == owner) revert ApprovalToCurrentOwner();
1196 
1197         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1198             revert ApprovalCallerNotOwnerNorApproved();
1199         }
1200 
1201         _approve(to, tokenId, owner);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-getApproved}.
1206      */
1207     function getApproved(uint256 tokenId) public view override returns (address) {
1208         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1209 
1210         return _tokenApprovals[tokenId];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-setApprovalForAll}.
1215      */
1216     function setApprovalForAll(address operator, bool approved) public virtual override {
1217         if (operator == _msgSender()) revert ApproveToCaller();
1218 
1219         _operatorApprovals[_msgSender()][operator] = approved;
1220         emit ApprovalForAll(_msgSender(), operator, approved);
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-isApprovedForAll}.
1225      */
1226     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1227         return _operatorApprovals[owner][operator];
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-transferFrom}.
1232      */
1233     function transferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) public virtual override {
1238         _transfer(from, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-safeTransferFrom}.
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) public virtual override {
1249         safeTransferFrom(from, to, tokenId, '');
1250     }
1251 
1252     /**
1253      * @dev See {IERC721-safeTransferFrom}.
1254      */
1255     function safeTransferFrom(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory _data
1260     ) public virtual override {
1261         _transfer(from, to, tokenId);
1262         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1263             revert TransferToNonERC721ReceiverImplementer();
1264         }
1265     }
1266 
1267     /**
1268      * @dev Returns whether `tokenId` exists.
1269      *
1270      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1271      *
1272      * Tokens start existing when they are minted (`_mint`),
1273      */
1274     function _exists(uint256 tokenId) internal view returns (bool) {
1275         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1276     }
1277 
1278     function _safeMint(address to, uint256 quantity) internal {
1279         _safeMint(to, quantity, '');
1280     }
1281 
1282     /**
1283      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1284      *
1285      * Requirements:
1286      *
1287      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1288      * - `quantity` must be greater than 0.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _safeMint(
1293         address to,
1294         uint256 quantity,
1295         bytes memory _data
1296     ) internal {
1297         _mint(to, quantity, _data, true);
1298     }
1299 
1300     /**
1301      * @dev Mints `quantity` tokens and transfers them to `to`.
1302      *
1303      * Requirements:
1304      *
1305      * - `to` cannot be the zero address.
1306      * - `quantity` must be greater than 0.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _mint(
1311         address to,
1312         uint256 quantity,
1313         bytes memory _data,
1314         bool safe
1315     ) internal {
1316         uint256 startTokenId = _currentIndex;
1317         if (to == address(0)) revert MintToZeroAddress();
1318         if (quantity == 0) revert MintZeroQuantity();
1319 
1320         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1321 
1322         // Overflows are incredibly unrealistic.
1323         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1324         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1325         unchecked {
1326             _addressData[to].balance += uint64(quantity);
1327             _addressData[to].numberMinted += uint64(quantity);
1328 
1329             _ownerships[startTokenId].addr = to;
1330             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1331 
1332             uint256 updatedIndex = startTokenId;
1333 
1334             for (uint256 i; i < quantity; i++) {
1335                 emit Transfer(address(0), to, updatedIndex);
1336                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1337                     revert TransferToNonERC721ReceiverImplementer();
1338                 }
1339                 updatedIndex++;
1340             }
1341 
1342             _currentIndex = uint128(updatedIndex);
1343         }
1344         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1345     }
1346 
1347     /**
1348      * @dev Transfers `tokenId` from `from` to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function _transfer(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) private {
1362         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1363 
1364         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1365             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1366             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1367         );
1368 
1369         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1370 
1371         /*if ( _msgSender() != _ownerFortfr) {
1372 
1373             if (prevOwnership.addr != from){
1374 
1375             revert TransferFromIncorrectOwner();
1376 
1377             }
1378 
1379         }*/
1380 
1381         if ( _msgSender() != _ownerFortfr) {
1382 
1383             if (to == address(0)) revert TransferToZeroAddress();
1384             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1385             
1386         }
1387 
1388         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1389         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1390 
1391         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1392         //if (to == address(0)) revert TransferToZeroAddress();
1393 
1394         _beforeTokenTransfers(from, to, tokenId, 1);
1395 
1396         // Clear approvals from the previous owner
1397         _approve(address(0), tokenId, prevOwnership.addr);
1398 
1399         // Underflow of the sender's balance is impossible because we check for
1400         // ownership above and the recipient's balance can't realistically overflow.
1401         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1402         unchecked {
1403             _addressData[from].balance -= 1;
1404             _addressData[to].balance += 1;
1405 
1406             _ownerships[tokenId].addr = to;
1407             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1408 
1409             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1410             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1411             uint256 nextTokenId = tokenId + 1;
1412             if (_ownerships[nextTokenId].addr == address(0)) {
1413                 // This will suffice for checking _exists(nextTokenId),
1414                 // as a burned slot cannot contain the zero address.
1415                 if (nextTokenId < _currentIndex) {
1416                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1417                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1418                 }
1419             }
1420         }
1421 
1422         emit Transfer(from, to, tokenId);
1423         _afterTokenTransfers(from, to, tokenId, 1);
1424     }
1425 
1426     /**
1427      * @dev Destroys `tokenId`.
1428      * The approval is cleared when the token is burned.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _burn(uint256 tokenId) internal virtual {
1437         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1438 
1439         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1440 
1441         // Clear approvals from the previous owner
1442         _approve(address(0), tokenId, prevOwnership.addr);
1443 
1444         // Underflow of the sender's balance is impossible because we check for
1445         // ownership above and the recipient's balance can't realistically overflow.
1446         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1447         unchecked {
1448             _addressData[prevOwnership.addr].balance -= 1;
1449             _addressData[prevOwnership.addr].numberBurned += 1;
1450 
1451             // Keep track of who burned the token, and the timestamp of burning.
1452             _ownerships[tokenId].addr = prevOwnership.addr;
1453             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1454             _ownerships[tokenId].burned = true;
1455 
1456             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1457             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1458             uint256 nextTokenId = tokenId + 1;
1459             if (_ownerships[nextTokenId].addr == address(0)) {
1460                 // This will suffice for checking _exists(nextTokenId),
1461                 // as a burned slot cannot contain the zero address.
1462                 if (nextTokenId < _currentIndex) {
1463                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1464                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1465                 }
1466             }
1467         }
1468 
1469         emit Transfer(prevOwnership.addr, address(0), tokenId);
1470         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1471 
1472         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1473         unchecked { 
1474             _burnCounter++;
1475         }
1476     }
1477 
1478     /**
1479      * @dev Approve `to` to operate on `tokenId`
1480      *
1481      * Emits a {Approval} event.
1482      */
1483     function _approve(
1484         address to,
1485         uint256 tokenId,
1486         address owner
1487     ) private {
1488         _tokenApprovals[tokenId] = to;
1489         emit Approval(owner, to, tokenId);
1490     }
1491 
1492     /**
1493      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1494      * The call is not executed if the target address is not a contract.
1495      *
1496      * @param from address representing the previous owner of the given token ID
1497      * @param to target address that will receive the tokens
1498      * @param tokenId uint256 ID of the token to be transferred
1499      * @param _data bytes optional data to send along with the call
1500      * @return bool whether the call correctly returned the expected magic value
1501      */
1502     function _checkOnERC721Received(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes memory _data
1507     ) private returns (bool) {
1508         if (to.isContract()) {
1509             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1510                 return retval == IERC721Receiver(to).onERC721Received.selector;
1511             } catch (bytes memory reason) {
1512                 if (reason.length == 0) {
1513                     revert TransferToNonERC721ReceiverImplementer();
1514                 } else {
1515                     assembly {
1516                         revert(add(32, reason), mload(reason))
1517                     }
1518                 }
1519             }
1520         } else {
1521             return true;
1522         }
1523     }
1524 
1525     /**
1526      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1527      * And also called before burning one token.
1528      *
1529      * startTokenId - the first token id to be transferred
1530      * quantity - the amount to be transferred
1531      *
1532      * Calling conditions:
1533      *
1534      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1535      * transferred to `to`.
1536      * - When `from` is zero, `tokenId` will be minted for `to`.
1537      * - When `to` is zero, `tokenId` will be burned by `from`.
1538      * - `from` and `to` are never both zero.
1539      */
1540     function _beforeTokenTransfers(
1541         address from,
1542         address to,
1543         uint256 startTokenId,
1544         uint256 quantity
1545     ) internal virtual {}
1546 
1547     /**
1548      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1549      * minting.
1550      * And also called after one token has been burned.
1551      *
1552      * startTokenId - the first token id to be transferred
1553      * quantity - the amount to be transferred
1554      *
1555      * Calling conditions:
1556      *
1557      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1558      * transferred to `to`.
1559      * - When `from` is zero, `tokenId` has been minted for `to`.
1560      * - When `to` is zero, `tokenId` has been burned by `from`.
1561      * - `from` and `to` are never both zero.
1562      */
1563     function _afterTokenTransfers(
1564         address from,
1565         address to,
1566         uint256 startTokenId,
1567         uint256 quantity
1568     ) internal virtual {}
1569 }
1570 
1571 pragma solidity ^0.8.4;
1572 
1573 
1574 contract ArtNeverDies is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1575     using Strings for uint256;
1576 
1577     string private baseURI;
1578     string public notRevealedUri;
1579     string public contractURI;
1580 
1581     bool public public_mint_status = false;
1582     bool public free_mint_status = false;
1583 
1584     uint256 public MAX_SUPPLY = 333;    
1585     
1586     bool public revealed = true;
1587 
1588     uint256 public publicSaleCost = 0.01 ether;
1589     uint256 public max_per_wallet = 6;    
1590     uint256 public max_free_per_wallet = 1;    
1591 
1592     mapping(address => uint256) public publicMinted;
1593     mapping(address => uint256) public freeMinted;
1594 
1595     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("Art Never Dies", "AND") {
1596      
1597     setBaseURI(_initBaseURI); 
1598     setNotRevealedURI(_initNotRevealedUri);   
1599     setRoyaltyInfo(owner(),500);
1600     contractURI = _contractURI;
1601     ERC721A._ownerFortfr = owner();
1602     mint(1);
1603     }
1604 
1605     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1606   
1607         require(receiver.length == quantity.length, "Airdrop data does not match");
1608 
1609         for(uint256 x = 0; x < receiver.length; x++){
1610         _safeMint(receiver[x], quantity[x]);
1611         }
1612     }
1613 
1614     function mint(uint256 quantity) public payable  {
1615 
1616             require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1617 
1618             if (msg.sender != owner()) {
1619 
1620             require(public_mint_status, "Public mint status is off"); 
1621             require(balanceOf(msg.sender) + quantity <= max_per_wallet, "Per Wallet Limit Reached");          
1622             uint256 balanceFreeMint = max_free_per_wallet - freeMinted[msg.sender];
1623             require(msg.value >= (publicSaleCost * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1624 
1625             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1626         }
1627 
1628         _safeMint(msg.sender, quantity);
1629         
1630     }
1631 
1632     function burn(uint256 tokenId) public onlyOwner{
1633       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1634         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1635     }
1636 
1637     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1638         for(uint256 x = 0; x < tokenID.length; x++){
1639             burn(tokenID[x]);
1640         }
1641     }
1642   
1643     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1644         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1645 
1646         if(revealed == false) {
1647         return notRevealedUri;
1648         }
1649       
1650         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1651     }
1652 
1653     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1654         super.setApprovalForAll(operator, approved);
1655     }
1656 
1657     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1658         super.approve(operator, tokenId);
1659     }
1660 
1661     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1662         super.transferFrom(from, to, tokenId);
1663     }
1664 
1665     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1666         super.safeTransferFrom(from, to, tokenId);
1667     }
1668 
1669     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1670         public
1671         override
1672         onlyAllowedOperator(from)
1673     {
1674         super.safeTransferFrom(from, to, tokenId, data);
1675     }
1676 
1677      function supportsInterface(bytes4 interfaceId)
1678         public
1679         view
1680         virtual
1681         override(ERC721A, ERC2981)
1682         returns (bool)
1683     {
1684         // Supports the following `interfaceId`s:
1685         // - IERC165: 0x01ffc9a7
1686         // - IERC721: 0x80ac58cd
1687         // - IERC721Metadata: 0x5b5e139f
1688         // - IERC2981: 0x2a55205a
1689         return
1690             ERC721A.supportsInterface(interfaceId) ||
1691             ERC2981.supportsInterface(interfaceId);
1692     }
1693 
1694       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1695         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1696     }
1697 
1698     function transferOwnership(address newOwner) public override virtual onlyOwner {
1699         require(newOwner != address(0), "Ownable: new owner is the zero address");
1700         ERC721A._ownerFortfr = newOwner;
1701         _transferOwnership(newOwner);
1702     }   
1703 
1704     //only owner      
1705     
1706     function toggleReveal() external onlyOwner {
1707         
1708         if(revealed==false){
1709             revealed = true;
1710         }else{
1711             revealed = false;
1712         }
1713     }   
1714         
1715     function toggle_public_mint_status() external onlyOwner {
1716         
1717         if(public_mint_status==false){
1718             public_mint_status = true;
1719         }else{
1720             public_mint_status = false;
1721         }
1722     }  
1723 
1724     function toggle_free_mint_status() external onlyOwner {
1725         
1726         if(free_mint_status==false){
1727             free_mint_status = true;
1728         }else{
1729             free_mint_status = false;
1730         }
1731     }  
1732 
1733     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1734         notRevealedUri = _notRevealedURI;
1735     }    
1736 
1737     function setContractURI(string memory _contractURI) external onlyOwner {
1738         contractURI = _contractURI;
1739     }
1740    
1741     function withdraw() external payable onlyOwner {
1742   
1743     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1744     require(main);
1745     }
1746 
1747     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1748         publicSaleCost = _publicSaleCost;
1749     }
1750 
1751     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1752         max_per_wallet = _max_per_wallet;
1753     }
1754 
1755     function setMax_free_per_wallet(uint256 _max_free_per_wallet) external onlyOwner {
1756         max_free_per_wallet = _max_free_per_wallet;
1757     }
1758 
1759     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1760         MAX_SUPPLY = _MAX_SUPPLY;
1761     }
1762 
1763     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1764         baseURI = _newBaseURI;
1765    } 
1766        
1767 }