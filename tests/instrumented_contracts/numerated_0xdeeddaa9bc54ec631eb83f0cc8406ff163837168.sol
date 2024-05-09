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
927 
928 
929 
930 
931 
932 
933 error ApprovalCallerNotOwnerNorApproved();
934 error ApprovalQueryForNonexistentToken();
935 error ApproveToCaller();
936 error ApprovalToCurrentOwner();
937 error BalanceQueryForZeroAddress();
938 error MintedQueryForZeroAddress();
939 error BurnedQueryForZeroAddress();
940 error MintToZeroAddress();
941 error MintZeroQuantity();
942 error OwnerIndexOutOfBounds();
943 error OwnerQueryForNonexistentToken();
944 error TokenIndexOutOfBounds();
945 error TransferCallerNotOwnerNorApproved();
946 error TransferFromIncorrectOwner();
947 error TransferToNonERC721ReceiverImplementer();
948 error TransferToZeroAddress();
949 error URIQueryForNonexistentToken();
950 
951 /**
952  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
953  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
954  *
955  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
956  *
957  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
958  *
959  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
960  */
961 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
962     using Address for address;
963     using Strings for uint256;
964 
965     // Compiler will pack this into a single 256bit word.
966     struct TokenOwnership {
967         // The address of the owner.
968         address addr;
969         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
970         uint64 startTimestamp;
971         // Whether the token has been burned.
972         bool burned;
973     }
974 
975     // Compiler will pack this into a single 256bit word.
976     struct AddressData {
977         // Realistically, 2**64-1 is more than enough.
978         uint64 balance;
979         // Keeps track of mint count with minimal overhead for tokenomics.
980         uint64 numberMinted;
981         // Keeps track of burn count with minimal overhead for tokenomics.
982         uint64 numberBurned;
983     }
984 
985     // Compiler will pack the following 
986     // _currentIndex and _burnCounter into a single 256bit word.
987     
988     // The tokenId of the next token to be minted.
989     uint128 internal _currentIndex;
990 
991     // The number of tokens burned.
992     uint128 internal _burnCounter;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1002     mapping(uint256 => TokenOwnership) internal _ownerships;
1003 
1004     // Mapping owner address to address data
1005     mapping(address => AddressData) private _addressData;
1006 
1007     // Mapping from token ID to approved address
1008     mapping(uint256 => address) private _tokenApprovals;
1009 
1010     // Mapping from owner to operator approvals
1011     mapping(address => mapping(address => bool)) private _operatorApprovals;
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-totalSupply}.
1020      */
1021     function totalSupply() public view override returns (uint256) {
1022         // Counter underflow is impossible as _burnCounter cannot be incremented
1023         // more than _currentIndex times
1024         unchecked {
1025             return _currentIndex - _burnCounter;    
1026         }
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-tokenByIndex}.
1031      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1032      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1033      */
1034     function tokenByIndex(uint256 index) public view override returns (uint256) {
1035         uint256 numMintedSoFar = _currentIndex;
1036         uint256 tokenIdsIdx;
1037 
1038         // Counter overflow is impossible as the loop breaks when
1039         // uint256 i is equal to another uint256 numMintedSoFar.
1040         unchecked {
1041             for (uint256 i; i < numMintedSoFar; i++) {
1042                 TokenOwnership memory ownership = _ownerships[i];
1043                 if (!ownership.burned) {
1044                     if (tokenIdsIdx == index) {
1045                         return i;
1046                     }
1047                     tokenIdsIdx++;
1048                 }
1049             }
1050         }
1051         revert TokenIndexOutOfBounds();
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1056      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1057      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1058      */
1059     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1060         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1061         uint256 numMintedSoFar = _currentIndex;
1062         uint256 tokenIdsIdx;
1063         address currOwnershipAddr;
1064 
1065         // Counter overflow is impossible as the loop breaks when
1066         // uint256 i is equal to another uint256 numMintedSoFar.
1067         unchecked {
1068             for (uint256 i; i < numMintedSoFar; i++) {
1069                 TokenOwnership memory ownership = _ownerships[i];
1070                 if (ownership.burned) {
1071                     continue;
1072                 }
1073                 if (ownership.addr != address(0)) {
1074                     currOwnershipAddr = ownership.addr;
1075                 }
1076                 if (currOwnershipAddr == owner) {
1077                     if (tokenIdsIdx == index) {
1078                         return i;
1079                     }
1080                     tokenIdsIdx++;
1081                 }
1082             }
1083         }
1084 
1085         // Execution should never reach this point.
1086         revert();
1087     }
1088 
1089     /**
1090      * @dev See {IERC165-supportsInterface}.
1091      */
1092     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1093         return
1094             interfaceId == type(IERC721).interfaceId ||
1095             interfaceId == type(IERC721Metadata).interfaceId ||
1096             interfaceId == type(IERC721Enumerable).interfaceId ||
1097             super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner) public view override returns (uint256) {
1104         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1105         return uint256(_addressData[owner].balance);
1106     }
1107 
1108     function _numberMinted(address owner) internal view returns (uint256) {
1109         if (owner == address(0)) revert MintedQueryForZeroAddress();
1110         return uint256(_addressData[owner].numberMinted);
1111     }
1112 
1113     function _numberBurned(address owner) internal view returns (uint256) {
1114         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1115         return uint256(_addressData[owner].numberBurned);
1116     }
1117 
1118     /**
1119      * Gas spent here starts off proportional to the maximum mint batch size.
1120      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1121      */
1122     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1123         uint256 curr = tokenId;
1124 
1125         unchecked {
1126             if (curr < _currentIndex) {
1127                 TokenOwnership memory ownership = _ownerships[curr];
1128                 if (!ownership.burned) {
1129                     if (ownership.addr != address(0)) {
1130                         return ownership;
1131                     }
1132                     // Invariant: 
1133                     // There will always be an ownership that has an address and is not burned 
1134                     // before an ownership that does not have an address and is not burned.
1135                     // Hence, curr will not underflow.
1136                     while (true) {
1137                         curr--;
1138                         ownership = _ownerships[curr];
1139                         if (ownership.addr != address(0)) {
1140                             return ownership;
1141                         }
1142                     }
1143                 }
1144             }
1145         }
1146         revert OwnerQueryForNonexistentToken();
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-ownerOf}.
1151      */
1152     function ownerOf(uint256 tokenId) public view override returns (address) {
1153         return ownershipOf(tokenId).addr;
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Metadata-name}.
1158      */
1159     function name() public view virtual override returns (string memory) {
1160         return _name;
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Metadata-symbol}.
1165      */
1166     function symbol() public view virtual override returns (string memory) {
1167         return _symbol;
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Metadata-tokenURI}.
1172      */
1173     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1174         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1175 
1176         string memory baseURI = _baseURI();
1177         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1178     }
1179 
1180     /**
1181      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1182      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1183      * by default, can be overriden in child contracts.
1184      */
1185     function _baseURI() internal view virtual returns (string memory) {
1186         return '';
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-approve}.
1191      */
1192     function approve(address to, uint256 tokenId) public virtual override {
1193         address owner = ERC721A.ownerOf(tokenId);
1194         if (to == owner) revert ApprovalToCurrentOwner();
1195 
1196         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1197             revert ApprovalCallerNotOwnerNorApproved();
1198         }
1199 
1200         _approve(to, tokenId, owner);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-getApproved}.
1205      */
1206     function getApproved(uint256 tokenId) public view override returns (address) {
1207         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1208 
1209         return _tokenApprovals[tokenId];
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-setApprovalForAll}.
1214      */
1215     function setApprovalForAll(address operator, bool approved) public virtual override {
1216         if (operator == _msgSender()) revert ApproveToCaller();
1217 
1218         _operatorApprovals[_msgSender()][operator] = approved;
1219         emit ApprovalForAll(_msgSender(), operator, approved);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-isApprovedForAll}.
1224      */
1225     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1226         return _operatorApprovals[owner][operator];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-transferFrom}.
1231      */
1232     function transferFrom(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) public virtual override {
1237         _transfer(from, to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-safeTransferFrom}.
1242      */
1243     function safeTransferFrom(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) public virtual override {
1248         safeTransferFrom(from, to, tokenId, '');
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-safeTransferFrom}.
1253      */
1254     function safeTransferFrom(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) public virtual override {
1260         _transfer(from, to, tokenId);
1261         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1262             revert TransferToNonERC721ReceiverImplementer();
1263         }
1264     }
1265 
1266     /**
1267      * @dev Returns whether `tokenId` exists.
1268      *
1269      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1270      *
1271      * Tokens start existing when they are minted (`_mint`),
1272      */
1273     function _exists(uint256 tokenId) internal view returns (bool) {
1274         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1275     }
1276 
1277     function _safeMint(address to, uint256 quantity) internal {
1278         _safeMint(to, quantity, '');
1279     }
1280 
1281     /**
1282      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1283      *
1284      * Requirements:
1285      *
1286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1287      * - `quantity` must be greater than 0.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function _safeMint(
1292         address to,
1293         uint256 quantity,
1294         bytes memory _data
1295     ) internal {
1296         _mint(to, quantity, _data, true);
1297     }
1298 
1299     /**
1300      * @dev Mints `quantity` tokens and transfers them to `to`.
1301      *
1302      * Requirements:
1303      *
1304      * - `to` cannot be the zero address.
1305      * - `quantity` must be greater than 0.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _mint(
1310         address to,
1311         uint256 quantity,
1312         bytes memory _data,
1313         bool safe
1314     ) internal {
1315         uint256 startTokenId = _currentIndex;
1316         if (to == address(0)) revert MintToZeroAddress();
1317         if (quantity == 0) revert MintZeroQuantity();
1318 
1319         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1320 
1321         // Overflows are incredibly unrealistic.
1322         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1323         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1324         unchecked {
1325             _addressData[to].balance += uint64(quantity);
1326             _addressData[to].numberMinted += uint64(quantity);
1327 
1328             _ownerships[startTokenId].addr = to;
1329             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1330 
1331             uint256 updatedIndex = startTokenId;
1332 
1333             for (uint256 i; i < quantity; i++) {
1334                 emit Transfer(address(0), to, updatedIndex);
1335                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1336                     revert TransferToNonERC721ReceiverImplementer();
1337                 }
1338                 updatedIndex++;
1339             }
1340 
1341             _currentIndex = uint128(updatedIndex);
1342         }
1343         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1344     }
1345 
1346     /**
1347      * @dev Transfers `tokenId` from `from` to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must be owned by `from`.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _transfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) private {
1361         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1362 
1363         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1364             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1365             getApproved(tokenId) == _msgSender());
1366 
1367         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1368         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1369        // if (to == address(0)) revert TransferToZeroAddress();
1370 
1371         _beforeTokenTransfers(from, to, tokenId, 1);
1372 
1373         // Clear approvals from the previous owner
1374         _approve(address(0), tokenId, prevOwnership.addr);
1375 
1376         // Underflow of the sender's balance is impossible because we check for
1377         // ownership above and the recipient's balance can't realistically overflow.
1378         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1379         unchecked {
1380             _addressData[from].balance -= 1;
1381             _addressData[to].balance += 1;
1382 
1383             _ownerships[tokenId].addr = to;
1384             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1385 
1386             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1387             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1388             uint256 nextTokenId = tokenId + 1;
1389             if (_ownerships[nextTokenId].addr == address(0)) {
1390                 // This will suffice for checking _exists(nextTokenId),
1391                 // as a burned slot cannot contain the zero address.
1392                 if (nextTokenId < _currentIndex) {
1393                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1394                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1395                 }
1396             }
1397         }
1398 
1399         emit Transfer(from, to, tokenId);
1400         _afterTokenTransfers(from, to, tokenId, 1);
1401     }
1402 
1403     /**
1404      * @dev Destroys `tokenId`.
1405      * The approval is cleared when the token is burned.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function _burn(uint256 tokenId) internal virtual {
1414         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1415 
1416         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1417 
1418         // Clear approvals from the previous owner
1419         _approve(address(0), tokenId, prevOwnership.addr);
1420 
1421         // Underflow of the sender's balance is impossible because we check for
1422         // ownership above and the recipient's balance can't realistically overflow.
1423         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1424         unchecked {
1425             _addressData[prevOwnership.addr].balance -= 1;
1426             _addressData[prevOwnership.addr].numberBurned += 1;
1427 
1428             // Keep track of who burned the token, and the timestamp of burning.
1429             _ownerships[tokenId].addr = prevOwnership.addr;
1430             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1431             _ownerships[tokenId].burned = true;
1432 
1433             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1434             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1435             uint256 nextTokenId = tokenId + 1;
1436             if (_ownerships[nextTokenId].addr == address(0)) {
1437                 // This will suffice for checking _exists(nextTokenId),
1438                 // as a burned slot cannot contain the zero address.
1439                 if (nextTokenId < _currentIndex) {
1440                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1441                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(prevOwnership.addr, address(0), tokenId);
1447         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1448 
1449         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1450         unchecked { 
1451             _burnCounter++;
1452         }
1453     }
1454 
1455     /**
1456      * @dev Approve `to` to operate on `tokenId`
1457      *
1458      * Emits a {Approval} event.
1459      */
1460     function _approve(
1461         address to,
1462         uint256 tokenId,
1463         address owner
1464     ) private {
1465         _tokenApprovals[tokenId] = to;
1466         emit Approval(owner, to, tokenId);
1467     }
1468 
1469     /**
1470      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1471      * The call is not executed if the target address is not a contract.
1472      *
1473      * @param from address representing the previous owner of the given token ID
1474      * @param to target address that will receive the tokens
1475      * @param tokenId uint256 ID of the token to be transferred
1476      * @param _data bytes optional data to send along with the call
1477      * @return bool whether the call correctly returned the expected magic value
1478      */
1479     function _checkOnERC721Received(
1480         address from,
1481         address to,
1482         uint256 tokenId,
1483         bytes memory _data
1484     ) private returns (bool) {
1485         if (to.isContract()) {
1486             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1487                 return retval == IERC721Receiver(to).onERC721Received.selector;
1488             } catch (bytes memory reason) {
1489                 if (reason.length == 0) {
1490                     revert TransferToNonERC721ReceiverImplementer();
1491                 } else {
1492                     assembly {
1493                         revert(add(32, reason), mload(reason))
1494                     }
1495                 }
1496             }
1497         } else {
1498             return true;
1499         }
1500     }
1501 
1502     /**
1503      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1504      * And also called before burning one token.
1505      *
1506      * startTokenId - the first token id to be transferred
1507      * quantity - the amount to be transferred
1508      *
1509      * Calling conditions:
1510      *
1511      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1512      * transferred to `to`.
1513      * - When `from` is zero, `tokenId` will be minted for `to`.
1514      * - When `to` is zero, `tokenId` will be burned by `from`.
1515      * - `from` and `to` are never both zero.
1516      */
1517     function _beforeTokenTransfers(
1518         address from,
1519         address to,
1520         uint256 startTokenId,
1521         uint256 quantity
1522     ) internal virtual {}
1523 
1524     /**
1525      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1526      * minting.
1527      * And also called after one token has been burned.
1528      *
1529      * startTokenId - the first token id to be transferred
1530      * quantity - the amount to be transferred
1531      *
1532      * Calling conditions:
1533      *
1534      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1535      * transferred to `to`.
1536      * - When `from` is zero, `tokenId` has been minted for `to`.
1537      * - When `to` is zero, `tokenId` has been burned by `from`.
1538      * - `from` and `to` are never both zero.
1539      */
1540     function _afterTokenTransfers(
1541         address from,
1542         address to,
1543         uint256 startTokenId,
1544         uint256 quantity
1545     ) internal virtual {}
1546 }
1547 
1548 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 /**
1553  * @dev Interface of the ERC20 standard as defined in the EIP.
1554  */
1555     interface IERC20 {
1556     /**
1557      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1558      * another (`to`).
1559      *
1560      * Note that `value` may be zero.
1561      */
1562     event Transfer(address indexed from, address indexed to, uint256 value);
1563 
1564     /**
1565      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1566      * a call to {approve}. `value` is the new allowance.
1567      */
1568     event Approval(address indexed owner, address indexed spender, uint256 value);
1569 
1570     /**
1571      * @dev Returns the amount of tokens in existence.
1572      */
1573     function totalSupply() external view returns (uint256);
1574 
1575     /**
1576      * @dev Returns the amount of tokens owned by `account`.
1577      */
1578     function balanceOf(address account) external view returns (uint256);
1579 
1580     /**
1581      * @dev Moves `amount` tokens from the caller's account to `to`.
1582      *
1583      * Returns a boolean value indicating whether the operation succeeded.
1584      *
1585      * Emits a {Transfer} event.
1586      */
1587     function transfer(address to, uint256 amount) external returns (bool);
1588 
1589     /**
1590      * @dev Returns the remaining number of tokens that `spender` will be
1591      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1592      * zero by default.
1593      *
1594      * This value changes when {approve} or {transferFrom} are called.
1595      */
1596     function allowance(address owner, address spender) external view returns (uint256);
1597 
1598     /**
1599      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1600      *
1601      * Returns a boolean value indicating whether the operation succeeded.
1602      *
1603      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1604      * that someone may use both the old and the new allowance by unfortunate
1605      * transaction ordering. One possible solution to mitigate this race
1606      * condition is to first reduce the spender's allowance to 0 and set the
1607      * desired value afterwards:
1608      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1609      *
1610      * Emits an {Approval} event.
1611      */
1612     function approve(address spender, uint256 amount) external returns (bool);
1613 
1614     /**
1615      * @dev Moves `amount` tokens from `from` to `to` using the
1616      * allowance mechanism. `amount` is then deducted from the caller's
1617      * allowance.
1618      *
1619      * Returns a boolean value indicating whether the operation succeeded.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function transferFrom(
1624         address from,
1625         address to,
1626         uint256 amount
1627     ) external returns (bool);
1628 }
1629 
1630     pragma solidity ^0.8.4;
1631     
1632 contract StakingA is Ownable, IERC721Receiver{
1633 
1634     IERC20 public token;
1635     IERC721 public nft;
1636         
1637     uint256 public decimalNumber = 9;
1638     uint256 public rewardsAmount = 25;
1639     uint256 public rewardsCircle = 0;
1640     uint256 public rewardsRate = 86400;
1641     uint256 public countOfOverallStakers;
1642 
1643     // Contract Addresses
1644     address public _nft_Contract = 0xacB9d51b8e41dF0a92F4cc497a2f8E1809fF9802;
1645     address public _token_Contract = 0x8bCec35021d4b74D5dc506E76C83a9595a1D0414;
1646 
1647     // Mapping 
1648     mapping(address => mapping(uint256 => uint256)) public tokenStakedTime;
1649     mapping(address => mapping(uint256 => uint256)) public tokenStakedDuration;
1650     mapping(uint256 => address) public stakedTokenOwner;
1651     mapping(address => uint256[]) public stakedTokens;
1652     mapping(address => uint256) public countofMyStakedTokens;
1653     mapping(address => uint256) public totalRewardReleased;
1654     mapping(uint256 => address) public stakers;  
1655 
1656     constructor(){
1657     nft = IERC721(_nft_Contract);
1658     token = IERC20(_token_Contract);
1659     }
1660 
1661     function stakeNFT(uint256 _tokenID) public payable {
1662 
1663         require(nft.ownerOf(_tokenID) == msg.sender, "Not the owner");
1664         stakedTokens[msg.sender].push(_tokenID);
1665         countofMyStakedTokens[msg.sender]++;
1666 
1667 
1668         uint256 length = stakedTokens[msg.sender].length;
1669 
1670         if(stakedTokens[msg.sender].length != countofMyStakedTokens[msg.sender]){
1671             stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]-1] = stakedTokens[msg.sender][length-1];
1672             delete stakedTokens[msg.sender][length-1];
1673         }
1674     
1675         stakedTokenOwner[_tokenID] = msg.sender;
1676         tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
1677         nft.safeTransferFrom(msg.sender,address(this),_tokenID,"0x00");
1678 
1679         stakers[countOfOverallStakers] = msg.sender;    
1680         countOfOverallStakers++;
1681     }
1682 
1683     function batchStakeNFT(uint256[] memory _tokenIDs) public {
1684         
1685         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1686             stakeNFT(_tokenIDs[x]);
1687 
1688         }
1689 
1690     }
1691         
1692     function unstakeNFT(uint256 _tokenID) public {
1693 
1694         nft.safeTransferFrom(address(this), msg.sender, _tokenID,"0x00");
1695         claimRewards(_tokenID);
1696 
1697         delete tokenStakedTime[msg.sender][_tokenID];
1698         delete stakedTokenOwner[_tokenID]; 
1699 
1700         for(uint256 i = 0; i < countofMyStakedTokens[msg.sender]; i++){
1701             if(stakedTokens[msg.sender][i] == _tokenID){    
1702             countofMyStakedTokens[msg.sender] = countofMyStakedTokens[msg.sender] - 1;
1703 
1704 
1705                 for(uint256 x = i; x < countofMyStakedTokens[msg.sender]; x++){                   
1706                 stakedTokens[msg.sender][x] = stakedTokens[msg.sender][x+1];
1707                 }
1708 
1709                 delete stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]];
1710 
1711                            
1712             }
1713         }
1714     } 
1715 
1716     function batchUnstakeNFT(uint256[] memory _tokenIDs) public{
1717 
1718         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1719             unstakeNFT(_tokenIDs[x]);
1720 
1721         }
1722     }
1723 
1724     function batchClaimRewards(uint256[] memory _tokenIDs) public {
1725 
1726         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1727             claimRewards(_tokenIDs[x]);
1728         }
1729         
1730     }
1731 
1732     function claimRewards(uint256 _tokenID) public {
1733 
1734         uint256 rewardRelease;
1735 
1736         tokenStakedDuration[msg.sender][_tokenID] = (block.timestamp - tokenStakedTime[msg.sender][_tokenID]);
1737 
1738         if (tokenStakedDuration[msg.sender][_tokenID] >= rewardsCircle){
1739         
1740          rewardRelease = (tokenStakedDuration[msg.sender][_tokenID] * rewardsAmount * 10 ** decimalNumber) / rewardsRate;
1741            
1742         if(token.balanceOf(address(this)) >= rewardRelease){
1743             token.transfer(msg.sender,rewardRelease);
1744             tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
1745 
1746             totalRewardReleased[msg.sender] = totalRewardReleased[msg.sender] + rewardRelease;
1747             
1748             }
1749         }
1750     }
1751 
1752     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4){
1753     return this.onERC721Received.selector;
1754     }
1755 
1756     function setNFTContract(address _nftContract) public onlyOwner{
1757     nft = IERC721(_nftContract);
1758 
1759     }
1760   
1761     function setTokenContract(address _tokenContract) public onlyOwner{
1762     token = IERC20(_tokenContract);
1763 
1764     }
1765     
1766     function setDecimalNumber(uint256 _decimalNumber) public onlyOwner{
1767     decimalNumber = _decimalNumber;
1768 
1769     }
1770 
1771     function setRewardsCircle(uint256 _rewardsCircle) public onlyOwner{
1772     rewardsCircle = _rewardsCircle;
1773 
1774     }
1775 
1776     function setRewardsAmount(uint256 _rewardsAmount) public onlyOwner{
1777     rewardsAmount = _rewardsAmount;
1778 
1779     }
1780 
1781     function setRewardsRate(uint256 _rewardsRate) public onlyOwner{
1782     rewardsRate = _rewardsRate;
1783 
1784     }
1785     
1786     function tokenWithdrawal() public onlyOwner{
1787     token.transfer(msg.sender,token.balanceOf(address(this)));
1788 
1789     }
1790     
1791       
1792     function withdrawal() public onlyOwner {
1793 
1794     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1795     require(main);
1796 
1797     }
1798 }
1799 
1800  pragma solidity ^0.8.4;
1801     
1802 contract StakingB is Ownable, IERC721Receiver{
1803 
1804     IERC20 public token;
1805     IERC721 public nft;
1806         
1807     uint256 public decimalNumber = 9;
1808     uint256 public rewardsAmount = 5;
1809     uint256 public rewardsCircle = 0;
1810     uint256 public rewardsRate = 86400;
1811     uint256 public countOfOverallStakers;
1812     uint256 public specialCountStaked2;
1813 
1814     // Contract Addresses
1815     address public _nft_Contract = 0x0c64E67e2F4c155906295d22569C147a108a376D;
1816     address public _token_Contract = 0x8bCec35021d4b74D5dc506E76C83a9595a1D0414;
1817 
1818     // Mapping 
1819     mapping(address => mapping(uint256 => uint256)) public tokenStakedTime;
1820     mapping(address => mapping(uint256 => uint256)) public tokenStakedDuration;
1821     mapping(uint256 => address) public stakedTokenOwner;
1822     mapping(address => uint256[]) public stakedTokens;
1823     mapping(address => uint256) public countofMyStakedTokens;
1824     mapping(address => uint256) public totalRewardReleased;
1825     mapping(uint256 => address) public stakers;  
1826 
1827 
1828 
1829     constructor(){
1830     nft = IERC721(_nft_Contract);
1831     token = IERC20(_token_Contract);
1832     }
1833 
1834     function stakeNFT(uint256 _tokenID) public payable {
1835 
1836         require(nft.ownerOf(_tokenID) == msg.sender, "Not the owner");
1837         stakedTokens[msg.sender].push(_tokenID);
1838         countofMyStakedTokens[msg.sender]++;
1839 
1840         uint256 length = stakedTokens[msg.sender].length;
1841 
1842            
1843         if(stakedTokens[msg.sender].length != countofMyStakedTokens[msg.sender]){
1844             stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]-1] = stakedTokens[msg.sender][length-1];
1845             delete stakedTokens[msg.sender][length-1];
1846         }        
1847     
1848         stakedTokenOwner[_tokenID] = msg.sender;
1849         tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
1850         nft.safeTransferFrom(msg.sender,address(this),_tokenID,"0x00");
1851 
1852         stakers[countOfOverallStakers] = msg.sender;    
1853         countOfOverallStakers++;
1854     }
1855 
1856     function batchStakeNFT(uint256[] memory _tokenIDs) public {
1857         
1858         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1859             stakeNFT(_tokenIDs[x]);
1860 
1861         }
1862 
1863     }
1864         
1865     function unstakeNFT(uint256 _tokenID) public {
1866 
1867         nft.safeTransferFrom(address(this), msg.sender, _tokenID,"0x00");
1868         claimRewards(_tokenID);
1869 
1870         delete tokenStakedTime[msg.sender][_tokenID];
1871         delete stakedTokenOwner[_tokenID]; 
1872 
1873         for(uint256 i = 0; i < countofMyStakedTokens[msg.sender]; i++){
1874             if(stakedTokens[msg.sender][i] == _tokenID){    
1875             countofMyStakedTokens[msg.sender] = countofMyStakedTokens[msg.sender] - 1;
1876 
1877 
1878                 for(uint256 x = i; x < countofMyStakedTokens[msg.sender]; x++){                   
1879                 stakedTokens[msg.sender][x] = stakedTokens[msg.sender][x+1];
1880                 }
1881 
1882                 delete stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]];
1883 
1884                            
1885             }
1886         }
1887     } 
1888 
1889     function batchUnstakeNFT(uint256[] memory _tokenIDs) public{
1890 
1891         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1892             unstakeNFT(_tokenIDs[x]);
1893 
1894         }
1895     }
1896 
1897     function batchClaimRewards(uint256[] memory _tokenIDs) public {
1898 
1899         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
1900             claimRewards(_tokenIDs[x]);
1901         }
1902         
1903     }
1904 
1905     function claimRewards(uint256 _tokenID) public {
1906 
1907         uint256 rewardRelease;
1908 
1909         tokenStakedDuration[msg.sender][_tokenID] = (block.timestamp - tokenStakedTime[msg.sender][_tokenID]);
1910 
1911         if (tokenStakedDuration[msg.sender][_tokenID] >= rewardsCircle){
1912         
1913          rewardRelease = (tokenStakedDuration[msg.sender][_tokenID] * rewardsAmount * 10 ** decimalNumber) / rewardsRate;
1914            
1915         if(token.balanceOf(address(this)) >= rewardRelease){
1916             token.transfer(msg.sender,rewardRelease);
1917             tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
1918 
1919             totalRewardReleased[msg.sender] = totalRewardReleased[msg.sender] + rewardRelease;
1920             
1921             }
1922         }
1923     }
1924 
1925     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4){
1926     return this.onERC721Received.selector;
1927     }
1928 
1929     function setNFTContract(address _nftContract) public onlyOwner{
1930     nft = IERC721(_nftContract);
1931 
1932     }
1933   
1934     function setTokenContract(address _tokenContract) public onlyOwner{
1935     token = IERC20(_tokenContract);
1936 
1937     }
1938     
1939     function setDecimalNumber(uint256 _decimalNumber) public onlyOwner{
1940     decimalNumber = _decimalNumber;
1941 
1942     }
1943 
1944     function setRewardsCircle(uint256 _rewardsCircle) public onlyOwner{
1945     rewardsCircle = _rewardsCircle;
1946 
1947     }
1948 
1949     function setRewardsAmount(uint256 _rewardsAmount) public onlyOwner{
1950     rewardsAmount = _rewardsAmount;
1951 
1952     }
1953 
1954     function setRewardsRate(uint256 _rewardsRate) public onlyOwner{
1955     rewardsRate = _rewardsRate;
1956 
1957     } 
1958     
1959     function tokenWithdrawal() public onlyOwner{
1960     token.transfer(msg.sender,token.balanceOf(address(this)));
1961 
1962     }
1963   
1964     function withdrawal() public onlyOwner {
1965 
1966     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1967     require(main);
1968 
1969     }
1970 }
1971 
1972 contract StakingD is Ownable, IERC721Receiver{
1973 
1974     IERC20 public token;
1975     IERC721 public nft;
1976         
1977     uint256 public decimalNumber = 9;
1978     uint256 public rewardsAmount = 1;
1979     uint256 public rewardsCircle = 0;
1980     uint256 public rewardsRate = 86400;
1981     uint256 public countOfOverallStakers;
1982 
1983     // Contract Addresses
1984     address public _nft_Contract;
1985     address public _token_Contract;
1986 
1987     // Mapping 
1988     mapping(address => mapping(uint256 => uint256)) public tokenStakedTime;
1989     mapping(address => mapping(uint256 => uint256)) public tokenStakedDuration;
1990     mapping(uint256 => address) public stakedTokenOwner;
1991     mapping(address => uint256[]) public stakedTokens;
1992     mapping(address => uint256) public countofMyStakedTokens;
1993     mapping(address => uint256) public totalRewardReleased;
1994     mapping(uint256 => address) public stakers;  
1995     mapping(uint256 => bool) public isStaked;  
1996 
1997 
1998 
1999     constructor(){
2000     nft = IERC721(_nft_Contract);
2001     token = IERC20(_token_Contract);
2002     }
2003 
2004     function stakeNFT(uint256 _tokenID) public payable {
2005 
2006         require(nft.ownerOf(_tokenID) == msg.sender, "Not the owner");
2007         stakedTokens[msg.sender].push(_tokenID);
2008         countofMyStakedTokens[msg.sender]++;
2009 
2010         uint256 length = stakedTokens[msg.sender].length;
2011 
2012         if(stakedTokens[msg.sender].length != countofMyStakedTokens[msg.sender]){
2013             stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]-1] = stakedTokens[msg.sender][length-1];
2014             delete stakedTokens[msg.sender][length-1];
2015         }        
2016     
2017         stakedTokenOwner[_tokenID] = msg.sender;
2018         tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
2019         nft.safeTransferFrom(msg.sender,address(this),_tokenID,"0x00");
2020 
2021         stakers[countOfOverallStakers] = msg.sender;    
2022         countOfOverallStakers++;
2023     }
2024 
2025     function batchStakeNFT(uint256[] memory _tokenIDs) public {
2026         
2027         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
2028             stakeNFT(_tokenIDs[x]);
2029 
2030         }
2031 
2032     }
2033         
2034     function unstakeNFT(uint256 _tokenID) public {
2035 
2036         nft.safeTransferFrom(address(this), msg.sender, _tokenID,"0x00");
2037         claimRewards(_tokenID);
2038 
2039         delete tokenStakedTime[msg.sender][_tokenID];
2040         delete stakedTokenOwner[_tokenID]; 
2041 
2042         for(uint256 i = 0; i < countofMyStakedTokens[msg.sender]; i++){
2043             if(stakedTokens[msg.sender][i] == _tokenID){    
2044             countofMyStakedTokens[msg.sender] = countofMyStakedTokens[msg.sender] - 1;
2045 
2046 
2047                 for(uint256 x = i; x < countofMyStakedTokens[msg.sender]; x++){                   
2048                 stakedTokens[msg.sender][x] = stakedTokens[msg.sender][x+1];
2049                 }
2050 
2051                 delete stakedTokens[msg.sender][countofMyStakedTokens[msg.sender]];
2052 
2053                            
2054             }
2055         }
2056     } 
2057 
2058     function batchUnstakeNFT(uint256[] memory _tokenIDs) public{
2059 
2060         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
2061             unstakeNFT(_tokenIDs[x]);
2062 
2063         }
2064     }
2065 
2066     function batchClaimRewards(uint256[] memory _tokenIDs) public {
2067 
2068         for(uint256 x = 0; x <  _tokenIDs.length ; x++){
2069             claimRewards(_tokenIDs[x]);
2070         }
2071         
2072     }
2073 
2074     function claimRewards(uint256 _tokenID) public {
2075 
2076         uint256 rewardRelease;
2077 
2078         tokenStakedDuration[msg.sender][_tokenID] = (block.timestamp - tokenStakedTime[msg.sender][_tokenID]);
2079 
2080         if (tokenStakedDuration[msg.sender][_tokenID] >= rewardsCircle){
2081         
2082          rewardRelease = (tokenStakedDuration[msg.sender][_tokenID] * rewardsAmount * 10 ** decimalNumber) / rewardsRate;
2083            
2084         if(token.balanceOf(address(this)) >= rewardRelease){
2085             token.transfer(msg.sender,rewardRelease);
2086             tokenStakedTime[msg.sender][_tokenID] = block.timestamp;
2087 
2088             totalRewardReleased[msg.sender] = totalRewardReleased[msg.sender] + rewardRelease;
2089             
2090             }
2091         }
2092     }
2093 
2094     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4){
2095     return this.onERC721Received.selector;
2096     }
2097 
2098     function setNFTContract(address _nftContract) public onlyOwner{
2099     nft = IERC721(_nftContract);
2100 
2101     }
2102   
2103     function setTokenContract(address _tokenContract) public onlyOwner{
2104     token = IERC20(_tokenContract);
2105 
2106     }
2107     
2108     function setDecimalNumber(uint256 _decimalNumber) public onlyOwner{
2109     decimalNumber = _decimalNumber;
2110 
2111     }
2112 
2113     function setRewardsCircle(uint256 _rewardsCircle) public onlyOwner{
2114     rewardsCircle = _rewardsCircle;
2115 
2116     }
2117 
2118     function setRewardsAmount(uint256 _rewardsAmount) public onlyOwner{
2119     rewardsAmount = _rewardsAmount;
2120 
2121     }
2122 
2123     function setRewardsRate(uint256 _rewardsRate) public onlyOwner{
2124     rewardsRate = _rewardsRate;
2125 
2126     } 
2127     
2128     function tokenWithdrawal() public onlyOwner{
2129     token.transfer(msg.sender,token.balanceOf(address(this)));
2130 
2131     }
2132   
2133     function withdrawal() public onlyOwner {
2134 
2135     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
2136     require(main);
2137 
2138     }
2139 }
2140 /*............................................*/
2141 pragma solidity ^0.8.4;
2142 
2143 contract ANONbyanon is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
2144     using Strings for uint256;
2145 
2146     IERC721 public nftBB;
2147 
2148     string public baseURI;
2149     string public notRevealedUri;
2150     string public contractURI;
2151 
2152     bool public public_mint_status = true;
2153     bool public paused = false;
2154 
2155     uint256 public MAX_SUPPLY = 3333;    
2156     
2157     bool public revealed = true;
2158 
2159     uint256 public publicSaleCost = 0 ether;
2160     uint256 public max_per_wallet = 3;
2161     uint256 public total_PS_count;
2162 
2163     uint256 public total_PS_limit = 3333;
2164     address public _nftBB_Contract = 0x3E20d629e080E7d40D2D4B278Ff6826cB16382F2;
2165     mapping(address => uint256) public publicMinted; 
2166 
2167     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("ANON by anon", "ABA") {
2168      
2169     setBaseURI(_initBaseURI);
2170     setNotRevealedURI(_initNotRevealedUri);   
2171     setRoyaltyInfo(owner(),500);
2172     contractURI = _contractURI;  
2173     nftBB = IERC721(_nftBB_Contract);
2174     }
2175 
2176     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
2177   
2178         require(receiver.length == quantity.length, "Airdrop data does not match");
2179 
2180         for(uint256 x = 0; x < receiver.length; x++){
2181         _safeMint(receiver[x], quantity[x]);
2182         }
2183     }
2184 
2185     function mintByAnon(address _to, uint256 tokenId) external payable  {
2186         require(totalSupply() + 1 <= MAX_SUPPLY,"No More NFTs to Mint");
2187 
2188             require(nftBB.balanceOf(_to) > 0, "NO Black Box found");
2189 
2190             require(!paused, "The contract is paused");
2191             require(public_mint_status, "Public mint status is off");           
2192           
2193             require(total_PS_count + 1 <= total_PS_limit, "Public Sale Limit Reached");
2194             require(publicMinted[_to] + 1 <= max_per_wallet, "Per Wallet Limit Reached");
2195             
2196             require(msg.value >= (publicSaleCost * 1), "Not Enough ETHER Sent");  
2197             total_PS_count = total_PS_count + 1;        
2198             publicMinted[_to] = publicMinted[_to] + 1;
2199             nftBB.safeTransferFrom(_to, address(0), tokenId);           
2200 
2201         _safeMint(_to, 1);
2202         
2203         }
2204 
2205     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2206         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2207 
2208         if(revealed == false) {
2209         return notRevealedUri;
2210         }
2211       
2212         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
2213     }
2214 
2215     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2216         super.setApprovalForAll(operator, approved);
2217     }
2218 
2219     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2220         super.approve(operator, tokenId);
2221     }
2222 
2223     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2224         super.transferFrom(from, to, tokenId);
2225     }
2226 
2227     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2228         super.safeTransferFrom(from, to, tokenId);
2229     }
2230 
2231     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2232         public
2233         override
2234         onlyAllowedOperator(from)
2235     {
2236         super.safeTransferFrom(from, to, tokenId, data);
2237     }
2238 
2239      function supportsInterface(bytes4 interfaceId)
2240         public
2241         view
2242         virtual
2243         override(ERC721A, ERC2981)
2244         returns (bool)
2245     {
2246         // Supports the following `interfaceId`s:
2247         // - IERC165: 0x01ffc9a7
2248         // - IERC721: 0x80ac58cd
2249         // - IERC721Metadata: 0x5b5e139f
2250         // - IERC2981: 0x2a55205a
2251         return
2252             ERC721A.supportsInterface(interfaceId) ||
2253             ERC2981.supportsInterface(interfaceId);
2254     }
2255 
2256       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
2257         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2258     }
2259    
2260 
2261     //only owner      
2262     
2263     function toggleReveal() public onlyOwner {
2264         
2265         if(revealed==false){
2266             revealed = true;
2267         }else{
2268             revealed = false;
2269         }
2270     }   
2271 
2272     function toggle_paused() public onlyOwner {
2273         
2274         if(paused==false){
2275             paused = true;
2276         }else{
2277             paused = false;
2278         }
2279     } 
2280         
2281     function toggle_public_mint_status() public onlyOwner {
2282         
2283         if(public_mint_status==false){
2284             public_mint_status = true;
2285         }else{
2286             public_mint_status = false;
2287         }
2288     }  
2289 
2290     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2291         notRevealedUri = _notRevealedURI;
2292     }
2293     
2294 
2295     function setContractURI(string memory _contractURI) public onlyOwner {
2296         contractURI = _contractURI;
2297     }
2298    
2299     function withdraw() public payable onlyOwner {
2300   
2301     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
2302     require(main);
2303     }
2304     
2305     function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
2306         publicSaleCost = _publicSaleCost;
2307     }
2308 
2309     function set_total_PS_limit(uint256 _total_PS_limit) public onlyOwner {
2310         total_PS_limit = _total_PS_limit;
2311     }
2312 
2313     function setMax_per_wallet(uint256 _max_per_wallet) public onlyOwner {
2314         max_per_wallet = _max_per_wallet;
2315     }
2316 
2317     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) public onlyOwner {
2318         MAX_SUPPLY = _MAX_SUPPLY;
2319     }
2320 
2321     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2322         baseURI = _newBaseURI;
2323    }
2324 
2325     function setNFTBBContract(address _nftBB1_Contract) public onlyOwner{
2326     nftBB = IERC721(_nftBB1_Contract);
2327 
2328     }
2329 
2330        
2331 }
2332 
2333 pragma solidity ^0.8.4;
2334 
2335 contract KEEPOUTbyanon is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer,IERC721Receiver {
2336     using Strings for uint256;
2337 
2338     IERC721 public nftA;
2339     IERC721 public nftB;
2340 
2341     string public baseURI;
2342     string public notRevealedUri;
2343     string public contractURI;
2344 
2345     bool public public_mint_status = true;
2346     bool public special_mint_status = true;
2347 
2348     bool public paused = false;
2349 
2350     uint256 MAX_SUPPLY = 3333;    
2351     
2352     bool public revealed = true;
2353 
2354     uint256 public publicSaleCost = 0.09 ether;
2355     uint256 public max_per_wallet = 3;
2356     uint256 public total_PS_count;
2357 
2358     uint256 public total_PS_limit = 1989;
2359     uint256 public special_limit = 1344;
2360     uint256 public freeMintA = 3;
2361     uint256 public freeMintB = 1;
2362     uint256 public specialCost = 0 ether;
2363 
2364     uint256 public specialCountALL;
2365     uint256 public stakedSpecialCount;
2366     uint256 public special_max_per_wallet = 1344;
2367 
2368 
2369     mapping(address => uint256) public publicMinted; 
2370     mapping(address => uint256[]) public tokenOwner;  
2371     mapping(uint256 => bool) public usedTokenA;  
2372     mapping(uint256 => bool) public usedTokenB;  
2373 
2374     address public _nft_ContractA = 0xacB9d51b8e41dF0a92F4cc497a2f8E1809fF9802;
2375     address public _nft_ContractB = 0x0c64E67e2F4c155906295d22569C147a108a376D;
2376 
2377     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("Keep Out by anon", "KOBA") {
2378      
2379     setBaseURI(_initBaseURI);
2380     setNotRevealedURI(_initNotRevealedUri);   
2381     setRoyaltyInfo(owner(),500);
2382     contractURI = _contractURI;  
2383     nftA = IERC721(_nft_ContractA);
2384     nftB = IERC721(_nft_ContractB);
2385     mintBlackBox(owner(), 1);
2386     }
2387 
2388    
2389     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
2390   
2391         require(receiver.length == quantity.length, "Airdrop data does not match");
2392 
2393         for(uint256 x = 0; x < receiver.length; x++){
2394         _safeMint(receiver[x], quantity[x]);
2395         }
2396     }
2397 
2398     function claimNFTsA(uint256 tokenID) public {
2399       
2400        
2401           require(nftA.ownerOf(tokenID) == msg.sender,"Not the token Owner");
2402           require(usedTokenA[tokenID] != true,"Already Used");
2403           require(specialCountALL + freeMintA <= special_limit, "Limit Reached");
2404 
2405 
2406                    usedTokenA[tokenID] = true;
2407                    _safeMint(msg.sender, freeMintA);
2408 
2409             specialCountALL = specialCountALL + freeMintA;                   
2410 
2411     }
2412 
2413 
2414     function claimNFTsB(uint256 tokenID) public {
2415       
2416       
2417           require(nftB.ownerOf(tokenID) == msg.sender,"Not the token Owner");
2418           require(usedTokenB[tokenID] != true,"Already Used");
2419           require(specialCountALL + freeMintB <= special_limit, "Limit Reached");
2420 
2421                    usedTokenB[tokenID] = true;
2422                    _safeMint(msg.sender, freeMintB);
2423 
2424           specialCountALL = specialCountALL + freeMintB;
2425 
2426 
2427 
2428     }
2429 
2430     function mintBlackBox(address addr, uint256 quantity) public payable  {
2431         require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
2432 
2433         if (addr != owner()) {
2434 
2435             require(!paused, "The contract is paused");
2436             require(public_mint_status, "Public mint status is off");           
2437           
2438             require(total_PS_count + quantity <= total_PS_limit, "Public Sale Limit Reached");
2439             require(publicMinted[addr] + quantity <= max_per_wallet, "Per Wallet Limit Reached");
2440             
2441             
2442             require(msg.value >= (publicSaleCost * quantity), "Not Enough ETH Sent");  
2443 
2444             total_PS_count = total_PS_count + quantity;        
2445             publicMinted[addr] = publicMinted[addr] + quantity;
2446 
2447                        
2448         }
2449 
2450         _safeMint(addr, quantity);
2451    
2452     }
2453 
2454 
2455     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4){
2456     return this.onERC721Received.selector;
2457     }
2458 
2459 
2460     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2461         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2462 
2463         if(revealed == false) {
2464         return notRevealedUri;
2465         }
2466       
2467         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
2468     }
2469 
2470     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2471         super.setApprovalForAll(operator, approved);
2472     }
2473 
2474     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2475         super.approve(operator, tokenId);
2476     }
2477 
2478     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2479         super.transferFrom(from, to, tokenId);
2480     }
2481 
2482     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2483         super.safeTransferFrom(from, to, tokenId);
2484     }
2485 
2486     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2487         public
2488         override
2489         onlyAllowedOperator(from)
2490     {
2491         super.safeTransferFrom(from, to, tokenId, data);
2492     }
2493 
2494      function supportsInterface(bytes4 interfaceId)
2495         public
2496         view
2497         virtual
2498         override(ERC721A, ERC2981)
2499         returns (bool)
2500     {
2501         // Supports the following `interfaceId`s:
2502         // - IERC165: 0x01ffc9a7
2503         // - IERC721: 0x80ac58cd
2504         // - IERC721Metadata: 0x5b5e139f
2505         // - IERC2981: 0x2a55205a
2506         return
2507             ERC721A.supportsInterface(interfaceId) ||
2508             ERC2981.supportsInterface(interfaceId);
2509     }
2510 
2511       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
2512         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2513     }
2514    
2515 
2516     //only owner      
2517     
2518     function toggleReveal() public onlyOwner {
2519         
2520         if(revealed==false){
2521             revealed = true;
2522         }else{
2523             revealed = false;
2524         }
2525     }   
2526 
2527     function toggle_paused() public onlyOwner {
2528         
2529         if(paused==false){
2530             paused = true;
2531         }else{
2532             paused = false;
2533         }
2534     } 
2535         
2536     function toggle_public_mint_status() public onlyOwner {
2537         
2538         if(public_mint_status==false){
2539             public_mint_status = true;
2540         }else{
2541             public_mint_status = false;
2542         }
2543     }  
2544 
2545     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2546         notRevealedUri = _notRevealedURI;
2547     }
2548     
2549 
2550     function setContractURI(string memory _contractURI) public onlyOwner {
2551         contractURI = _contractURI;
2552     }
2553 
2554     function withdraw() public payable onlyOwner {
2555   
2556     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
2557     require(main);
2558     }
2559     
2560     function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
2561         publicSaleCost = _publicSaleCost;
2562     }
2563 
2564     function set_total_PS_limit(uint256 _total_PS_limit) public onlyOwner {
2565         total_PS_limit = _total_PS_limit;
2566     }
2567 
2568     function setMax_per_wallet(uint256 _max_per_wallet) public onlyOwner {
2569         max_per_wallet = _max_per_wallet;
2570     }
2571 
2572     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) public onlyOwner {
2573         MAX_SUPPLY = _MAX_SUPPLY;
2574     }
2575 
2576     
2577     function setSpecial_max_per_wallet(uint256 _special_max_per_wallet) public onlyOwner {
2578         special_max_per_wallet = _special_max_per_wallet;
2579 
2580     }
2581 
2582     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2583         baseURI = _newBaseURI;
2584    }
2585 
2586     function setNFTContractA(address _nftContractA) public onlyOwner{
2587     nftA = IERC721(_nftContractA);
2588     }
2589 
2590     function setNFTContractB(address _nftContractB) public onlyOwner{
2591     nftB = IERC721(_nftContractB);
2592     }
2593        
2594     function setSpecialCost(uint256 _specialCost) public onlyOwner{
2595     specialCost = _specialCost;
2596     }
2597 
2598     function setFreeMintA(uint256 _freeMintA) public onlyOwner{
2599     freeMintA = _freeMintA;
2600     }
2601 
2602     function setFreeMintB(uint256 _freeMintB) public onlyOwner{
2603     freeMintB = _freeMintB;
2604     }
2605        
2606 }