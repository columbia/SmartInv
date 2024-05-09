1 // SPDX-License-Identifier: MIT
2 
3 // File: IOperatorFilterRegistry.sol
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
1016         _currentIndex = 1; 
1017         _burnCounter = 1;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-totalSupply}.
1022      */
1023     function totalSupply() public view override returns (uint256) {
1024         // Counter underflow is impossible as _burnCounter cannot be incremented
1025         // more than _currentIndex times
1026         unchecked {
1027             return _currentIndex - _burnCounter;    
1028         }
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-tokenByIndex}.
1033      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1034      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1035      */
1036     function tokenByIndex(uint256 index) public view override returns (uint256) {
1037         uint256 numMintedSoFar = _currentIndex;
1038         uint256 tokenIdsIdx;
1039 
1040         // Counter overflow is impossible as the loop breaks when
1041         // uint256 i is equal to another uint256 numMintedSoFar.
1042         unchecked {
1043             for (uint256 i; i < numMintedSoFar; i++) {
1044                 TokenOwnership memory ownership = _ownerships[i];
1045                 if (!ownership.burned) {
1046                     if (tokenIdsIdx == index) {
1047                         return i;
1048                     }
1049                     tokenIdsIdx++;
1050                 }
1051             }
1052         }
1053         revert TokenIndexOutOfBounds();
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1058      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1059      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1060      */
1061     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1062         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1063         uint256 numMintedSoFar = _currentIndex;
1064         uint256 tokenIdsIdx;
1065         address currOwnershipAddr;
1066 
1067         // Counter overflow is impossible as the loop breaks when
1068         // uint256 i is equal to another uint256 numMintedSoFar.
1069         unchecked {
1070             for (uint256 i; i < numMintedSoFar; i++) {
1071                 TokenOwnership memory ownership = _ownerships[i];
1072                 if (ownership.burned) {
1073                     continue;
1074                 }
1075                 if (ownership.addr != address(0)) {
1076                     currOwnershipAddr = ownership.addr;
1077                 }
1078                 if (currOwnershipAddr == owner) {
1079                     if (tokenIdsIdx == index) {
1080                         return i;
1081                     }
1082                     tokenIdsIdx++;
1083                 }
1084             }
1085         }
1086 
1087         // Execution should never reach this point.
1088         revert();
1089     }
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1095         return
1096             interfaceId == type(IERC721).interfaceId ||
1097             interfaceId == type(IERC721Metadata).interfaceId ||
1098             interfaceId == type(IERC721Enumerable).interfaceId ||
1099             super.supportsInterface(interfaceId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-balanceOf}.
1104      */
1105     function balanceOf(address owner) public view override returns (uint256) {
1106         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1107         return uint256(_addressData[owner].balance);
1108     }
1109 
1110     function _numberMinted(address owner) internal view returns (uint256) {
1111         if (owner == address(0)) revert MintedQueryForZeroAddress();
1112         return uint256(_addressData[owner].numberMinted);
1113     }
1114 
1115     function _numberBurned(address owner) internal view returns (uint256) {
1116         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1117         return uint256(_addressData[owner].numberBurned);
1118     }
1119 
1120     /**
1121      * Gas spent here starts off proportional to the maximum mint batch size.
1122      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1123      */
1124     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1125         uint256 curr = tokenId;
1126 
1127         unchecked {
1128             if (curr < _currentIndex) {
1129                 TokenOwnership memory ownership = _ownerships[curr];
1130                 if (!ownership.burned) {
1131                     if (ownership.addr != address(0)) {
1132                         return ownership;
1133                     }
1134                     // Invariant: 
1135                     // There will always be an ownership that has an address and is not burned 
1136                     // before an ownership that does not have an address and is not burned.
1137                     // Hence, curr will not underflow.
1138                     while (true) {
1139                         curr--;
1140                         ownership = _ownerships[curr];
1141                         if (ownership.addr != address(0)) {
1142                             return ownership;
1143                         }
1144                     }
1145                 }
1146             }
1147         }
1148         revert OwnerQueryForNonexistentToken();
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-ownerOf}.
1153      */
1154     function ownerOf(uint256 tokenId) public view override returns (address) {
1155         return ownershipOf(tokenId).addr;
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Metadata-name}.
1160      */
1161     function name() public view virtual override returns (string memory) {
1162         return _name;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-symbol}.
1167      */
1168     function symbol() public view virtual override returns (string memory) {
1169         return _symbol;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-tokenURI}.
1174      */
1175     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1176         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1177 
1178         string memory baseURI = _baseURI();
1179         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1180     }
1181 
1182     /**
1183      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1184      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1185      * by default, can be overriden in child contracts.
1186      */
1187     function _baseURI() internal view virtual returns (string memory) {
1188         return '';
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-approve}.
1193      */
1194     function approve(address to, uint256 tokenId) public virtual override {
1195         address owner = ERC721A.ownerOf(tokenId);
1196         if (to == owner) revert ApprovalToCurrentOwner();
1197 
1198         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1199             revert ApprovalCallerNotOwnerNorApproved();
1200         }
1201 
1202         _approve(to, tokenId, owner);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-getApproved}.
1207      */
1208     function getApproved(uint256 tokenId) public view override returns (address) {
1209         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1210 
1211         return _tokenApprovals[tokenId];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-setApprovalForAll}.
1216      */
1217     function setApprovalForAll(address operator, bool approved) public virtual override {
1218         if (operator == _msgSender()) revert ApproveToCaller();
1219 
1220         _operatorApprovals[_msgSender()][operator] = approved;
1221         emit ApprovalForAll(_msgSender(), operator, approved);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-isApprovedForAll}.
1226      */
1227     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1228         return _operatorApprovals[owner][operator];
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-transferFrom}.
1233      */
1234     function transferFrom(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) public virtual override {
1239         _transfer(from, to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-safeTransferFrom}.
1244      */
1245     function safeTransferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) public virtual override {
1250         safeTransferFrom(from, to, tokenId, '');
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-safeTransferFrom}.
1255      */
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory _data
1261     ) public virtual override {
1262         _transfer(from, to, tokenId);
1263         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1264             revert TransferToNonERC721ReceiverImplementer();
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns whether `tokenId` exists.
1270      *
1271      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1272      *
1273      * Tokens start existing when they are minted (`_mint`),
1274      */
1275     function _exists(uint256 tokenId) internal view returns (bool) {
1276         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1277     }
1278 
1279     function _safeMint(address to, uint256 quantity) internal {
1280         _safeMint(to, quantity, '');
1281     }
1282 
1283     /**
1284      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1285      *
1286      * Requirements:
1287      *
1288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1289      * - `quantity` must be greater than 0.
1290      *
1291      * Emits a {Transfer} event.
1292      */
1293     function _safeMint(
1294         address to,
1295         uint256 quantity,
1296         bytes memory _data
1297     ) internal {
1298         _mint(to, quantity, _data, true);
1299     }
1300 
1301     /**
1302      * @dev Mints `quantity` tokens and transfers them to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `quantity` must be greater than 0.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _mint(
1312         address to,
1313         uint256 quantity,
1314         bytes memory _data,
1315         bool safe
1316     ) internal {
1317         uint256 startTokenId = _currentIndex;
1318         if (to == address(0)) revert MintToZeroAddress();
1319         if (quantity == 0) revert MintZeroQuantity();
1320 
1321         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1322 
1323         // Overflows are incredibly unrealistic.
1324         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1325         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1326         unchecked {
1327             _addressData[to].balance += uint64(quantity);
1328             _addressData[to].numberMinted += uint64(quantity);
1329 
1330             _ownerships[startTokenId].addr = to;
1331             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1332 
1333             uint256 updatedIndex = startTokenId;
1334 
1335             for (uint256 i; i < quantity; i++) {
1336                 emit Transfer(address(0), to, updatedIndex);
1337                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1338                     revert TransferToNonERC721ReceiverImplementer();
1339                 }
1340                 updatedIndex++;
1341             }
1342 
1343             _currentIndex = uint128(updatedIndex);
1344         }
1345         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1346     }
1347 
1348     /**
1349      * @dev Transfers `tokenId` from `from` to `to`.
1350      *
1351      * Requirements:
1352      *
1353      * - `to` cannot be the zero address.
1354      * - `tokenId` token must be owned by `from`.
1355      *
1356      * Emits a {Transfer} event.
1357      */
1358     function _transfer(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) private {
1363         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1364 
1365         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1366             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1367             getApproved(tokenId) == _msgSender());
1368 
1369         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1370         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1371         if (to == address(0)) revert TransferToZeroAddress();
1372 
1373         _beforeTokenTransfers(from, to, tokenId, 1);
1374 
1375         // Clear approvals from the previous owner
1376         _approve(address(0), tokenId, prevOwnership.addr);
1377 
1378         // Underflow of the sender's balance is impossible because we check for
1379         // ownership above and the recipient's balance can't realistically overflow.
1380         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1381         unchecked {
1382             _addressData[from].balance -= 1;
1383             _addressData[to].balance += 1;
1384 
1385             _ownerships[tokenId].addr = to;
1386             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1387 
1388             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1389             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1390             uint256 nextTokenId = tokenId + 1;
1391             if (_ownerships[nextTokenId].addr == address(0)) {
1392                 // This will suffice for checking _exists(nextTokenId),
1393                 // as a burned slot cannot contain the zero address.
1394                 if (nextTokenId < _currentIndex) {
1395                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1396                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1397                 }
1398             }
1399         }
1400 
1401         emit Transfer(from, to, tokenId);
1402         _afterTokenTransfers(from, to, tokenId, 1);
1403     }
1404 
1405     /**
1406      * @dev Destroys `tokenId`.
1407      * The approval is cleared when the token is burned.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _burn(uint256 tokenId) internal virtual {
1416         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1417 
1418         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1419 
1420         // Clear approvals from the previous owner
1421         _approve(address(0), tokenId, prevOwnership.addr);
1422 
1423         // Underflow of the sender's balance is impossible because we check for
1424         // ownership above and the recipient's balance can't realistically overflow.
1425         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1426         unchecked {
1427             _addressData[prevOwnership.addr].balance -= 1;
1428             _addressData[prevOwnership.addr].numberBurned += 1;
1429 
1430             // Keep track of who burned the token, and the timestamp of burning.
1431             _ownerships[tokenId].addr = prevOwnership.addr;
1432             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1433             _ownerships[tokenId].burned = true;
1434 
1435             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1436             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1437             uint256 nextTokenId = tokenId + 1;
1438             if (_ownerships[nextTokenId].addr == address(0)) {
1439                 // This will suffice for checking _exists(nextTokenId),
1440                 // as a burned slot cannot contain the zero address.
1441                 if (nextTokenId < _currentIndex) {
1442                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1443                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1444                 }
1445             }
1446         }
1447 
1448         emit Transfer(prevOwnership.addr, address(0), tokenId);
1449         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1450 
1451         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1452         unchecked { 
1453             _burnCounter++;
1454         }
1455     }
1456 
1457     /**
1458      * @dev Approve `to` to operate on `tokenId`
1459      *
1460      * Emits a {Approval} event.
1461      */
1462     function _approve(
1463         address to,
1464         uint256 tokenId,
1465         address owner
1466     ) private {
1467         _tokenApprovals[tokenId] = to;
1468         emit Approval(owner, to, tokenId);
1469     }
1470 
1471     /**
1472      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1473      * The call is not executed if the target address is not a contract.
1474      *
1475      * @param from address representing the previous owner of the given token ID
1476      * @param to target address that will receive the tokens
1477      * @param tokenId uint256 ID of the token to be transferred
1478      * @param _data bytes optional data to send along with the call
1479      * @return bool whether the call correctly returned the expected magic value
1480      */
1481     function _checkOnERC721Received(
1482         address from,
1483         address to,
1484         uint256 tokenId,
1485         bytes memory _data
1486     ) private returns (bool) {
1487         if (to.isContract()) {
1488             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1489                 return retval == IERC721Receiver(to).onERC721Received.selector;
1490             } catch (bytes memory reason) {
1491                 if (reason.length == 0) {
1492                     revert TransferToNonERC721ReceiverImplementer();
1493                 } else {
1494                     assembly {
1495                         revert(add(32, reason), mload(reason))
1496                     }
1497                 }
1498             }
1499         } else {
1500             return true;
1501         }
1502     }
1503 
1504     /**
1505      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1506      * And also called before burning one token.
1507      *
1508      * startTokenId - the first token id to be transferred
1509      * quantity - the amount to be transferred
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      * - When `to` is zero, `tokenId` will be burned by `from`.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _beforeTokenTransfers(
1520         address from,
1521         address to,
1522         uint256 startTokenId,
1523         uint256 quantity
1524     ) internal virtual {}
1525 
1526     /**
1527      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1528      * minting.
1529      * And also called after one token has been burned.
1530      *
1531      * startTokenId - the first token id to be transferred
1532      * quantity - the amount to be transferred
1533      *
1534      * Calling conditions:
1535      *
1536      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1537      * transferred to `to`.
1538      * - When `from` is zero, `tokenId` has been minted for `to`.
1539      * - When `to` is zero, `tokenId` has been burned by `from`.
1540      * - `from` and `to` are never both zero.
1541      */
1542     function _afterTokenTransfers(
1543         address from,
1544         address to,
1545         uint256 startTokenId,
1546         uint256 quantity
1547     ) internal virtual {}
1548 }
1549 
1550 pragma solidity ^0.8.4;
1551 
1552 contract AA1Spaceship is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1553     using Strings for uint256;
1554 
1555     string private baseURI;
1556     string public notRevealedUri;
1557     string public contractURI;
1558 
1559     bool public public_mint_status = true;
1560     bool public whitelist_mint_status = false;
1561     bool public revealed = false;
1562 
1563     uint256 public MAX_SUPPLY = 6000;  
1564     uint256 public publicSaleCost = 0.02 ether;
1565     uint256 public wlCost = 0.01 ether;
1566     uint256 public max_per_wallet = 8;  
1567     uint256 public whitelistCount;
1568     uint256 public whitelistLimit = 600;
1569     uint256 public whitelistLimitPerWallet = 8;
1570     uint256 public overallFreeMintLimit = 600;
1571     uint256 public freeMintedCount;
1572     uint256 public crewJoinLimit = 1;
1573     uint256 public max_per_txn = 1;  
1574 
1575     address[] public crew1;
1576     address[] public crew2;
1577     address[] public crew3;
1578     address[] public crew4;
1579     address[] public crew5;
1580     address[] public crew6;
1581     address[] public whitelistedAddresses;    
1582 
1583     mapping(address => uint256) public publicMinted;
1584     mapping(address => uint256) public whitelistMinted;
1585     mapping(address => uint256) public joined;
1586     mapping(address => uint256) public myCurrentCrew;
1587 
1588     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("AA1 Spaceship", "AA1") {
1589      
1590     setBaseURI(_initBaseURI);
1591     setNotRevealedURI(_initNotRevealedUri);   
1592     setRoyaltyInfo(0xa18b5819D04764bD42DCCC8313Ec2A54A066C780,500);
1593     contractURI = _contractURI;
1594     }
1595 
1596     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1597   
1598         require(receiver.length == quantity.length, "Airdrop data does not match");
1599 
1600         for(uint256 x = 0; x < receiver.length; x++){
1601         _safeMint(receiver[x], quantity[x]);
1602         }
1603     }
1604 
1605     function whitelistUsers(address[] calldata _users) public onlyOwner {
1606         delete whitelistedAddresses;
1607         whitelistedAddresses = _users;
1608     }
1609 
1610     function isWhitelisted(address _user) public view returns (bool) {
1611     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1612       if (whitelistedAddresses[i] == _user) {
1613           return true;
1614       }
1615     }
1616     return false;
1617   }
1618 
1619     function mint(uint256 quantity) public payable  {
1620         require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1621 
1622         if (msg.sender != owner()) {
1623             require(publicMinted[msg.sender] + whitelistMinted[msg.sender] + quantity <= max_per_wallet, "Per Wallet Limit Reached");
1624             require( quantity <= max_per_txn, "Per txn Limit Reached");
1625 
1626             if(whitelist_mint_status){
1627 
1628             require(isWhitelisted(msg.sender), "Not Whitelisted");
1629             require(whitelistMinted[msg.sender] + quantity <= whitelistLimitPerWallet, "Whitelist Limit Per Wallet Reached");
1630             require(whitelistCount + quantity <= whitelistLimit, "Overall Whitelist Limit Reached");
1631             require(msg.value >= (wlCost * quantity), "Not Enough ETH Sent");
1632             whitelistMinted[msg.sender] = whitelistMinted[msg.sender] + quantity;
1633             whitelistCount = whitelistCount + quantity;
1634 
1635             } else {
1636                 
1637             require(public_mint_status, "Public mint status is off");  
1638             if(totalSupply() + quantity <= overallFreeMintLimit){
1639                 freeMintedCount = freeMintedCount + quantity;
1640             }else{
1641                 require(msg.value >= (publicSaleCost * quantity), "Not Enough ETH Sent");
1642             }  
1643 
1644             publicMinted[msg.sender] = publicMinted[msg.sender] + quantity;
1645 
1646             }              
1647                        
1648         }
1649 
1650         _safeMint(msg.sender, quantity);
1651         
1652     }
1653 
1654     function joinCrew1() external {
1655         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1656         require(joined[msg.sender] < crewJoinLimit);
1657         crew1.push(msg.sender);
1658         joined[msg.sender]++;
1659         myCurrentCrew[msg.sender] = 1;
1660     }    
1661 
1662     function joinCrew2() external {
1663         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1664         require(joined[msg.sender] < crewJoinLimit);
1665         crew2.push(msg.sender);
1666         joined[msg.sender]++;
1667         myCurrentCrew[msg.sender] = 2;
1668     }    
1669 
1670 
1671     function joinCrew3() external {
1672         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1673         require(joined[msg.sender] < crewJoinLimit);
1674         crew3.push(msg.sender);
1675         joined[msg.sender]++;
1676         myCurrentCrew[msg.sender] = 3;
1677     }    
1678 
1679     function joinCrew4() external {
1680         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1681         require(joined[msg.sender] < crewJoinLimit);
1682         crew4.push(msg.sender);
1683         joined[msg.sender]++;
1684         myCurrentCrew[msg.sender] = 4;
1685     }    
1686 
1687     function joinCrew5() external {
1688         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1689         require(joined[msg.sender] < crewJoinLimit);
1690         crew5.push(msg.sender);
1691         joined[msg.sender]++;
1692         myCurrentCrew[msg.sender] = 5;
1693     }    
1694 
1695     function joinCrew6() external {
1696         require(balanceOf(msg.sender) > 0, "No NFTs in your wallet");
1697         require(joined[msg.sender] < crewJoinLimit);
1698         crew6.push(msg.sender);
1699         joined[msg.sender]++;
1700         myCurrentCrew[msg.sender] = 6;
1701     }    
1702 
1703 
1704     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1705         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1706 
1707         if(revealed == false) {
1708         return notRevealedUri;
1709         }
1710       
1711         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1712     }
1713 
1714     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1715         super.setApprovalForAll(operator, approved);
1716     }
1717 
1718     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1719         super.approve(operator, tokenId);
1720     }
1721 
1722     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1723         super.transferFrom(from, to, tokenId);
1724     }
1725 
1726     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1727         super.safeTransferFrom(from, to, tokenId);
1728     }
1729 
1730     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1731         public
1732         override
1733         onlyAllowedOperator(from)
1734     {
1735         super.safeTransferFrom(from, to, tokenId, data);
1736     }
1737 
1738      function supportsInterface(bytes4 interfaceId)
1739         public
1740         view
1741         virtual
1742         override(ERC721A, ERC2981)
1743         returns (bool)
1744     {
1745         // Supports the following `interfaceId`s:
1746         // - IERC165: 0x01ffc9a7
1747         // - IERC721: 0x80ac58cd
1748         // - IERC721Metadata: 0x5b5e139f
1749         // - IERC2981: 0x2a55205a
1750         return
1751             ERC721A.supportsInterface(interfaceId) ||
1752             ERC2981.supportsInterface(interfaceId);
1753     }
1754 
1755       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1756         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1757     }
1758    
1759 
1760     //only owner      
1761     
1762     function toggleReveal() external onlyOwner {
1763         
1764         if(revealed==false){
1765             revealed = true;
1766         }else{
1767             revealed = false;
1768         }
1769     }   
1770         
1771     function toggle_public_mint_status() external onlyOwner {
1772         
1773         if(public_mint_status==false){
1774             public_mint_status = true;
1775         }else{
1776             public_mint_status = false;
1777         }
1778     }  
1779 
1780     function toggle_whitelist_mint_status() external onlyOwner {
1781         
1782         if(whitelist_mint_status==false){
1783             whitelist_mint_status = true;
1784         }else{
1785             whitelist_mint_status = false;
1786         }
1787     }  
1788 
1789     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1790         notRevealedUri = _notRevealedURI;
1791     }    
1792 
1793     function setContractURI(string memory _contractURI) external onlyOwner {
1794         contractURI = _contractURI;
1795     }
1796    
1797     function withdraw() external payable onlyOwner {
1798   
1799     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1800     require(main);
1801     }
1802 
1803     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1804         publicSaleCost = _publicSaleCost;
1805     }
1806 
1807     function setWlCost(uint256 _wlCost) external onlyOwner {
1808         wlCost = _wlCost;
1809     }
1810 
1811     function setWhitelistLimit(uint256 _whitelistLimit) external onlyOwner {
1812         whitelistLimit = _whitelistLimit;
1813     }
1814 
1815     function setwhitelistLimitPerWallet(uint256 _whitelistLimitPerWallet) external onlyOwner {
1816         whitelistLimitPerWallet = _whitelistLimitPerWallet;
1817     }
1818 
1819     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1820         max_per_wallet = _max_per_wallet;
1821     }
1822 
1823     function setOverallFreeMintLimit(uint256 _overallFreeMintLimit) external onlyOwner {
1824         overallFreeMintLimit = _overallFreeMintLimit;
1825     }
1826 
1827     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1828         MAX_SUPPLY = _MAX_SUPPLY;
1829     }
1830 
1831     function setMax_per_txn(uint256 _max_per_txn) external onlyOwner {
1832         max_per_txn = _max_per_txn;
1833     }
1834 
1835     function setCrewJoinLimit(uint256 _crewJoinLimit) external onlyOwner {
1836         crewJoinLimit = _crewJoinLimit;
1837     }
1838 
1839     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1840         baseURI = _newBaseURI;
1841    }
1842 
1843     function getBaseURI() external view onlyOwner returns (string memory) {
1844         return baseURI;
1845     }
1846        
1847 }